Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0771F2E7DE7
	for <lists+kvm@lfdr.de>; Thu, 31 Dec 2020 04:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgLaDsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 22:48:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgLaDsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Dec 2020 22:48:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609386409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N5OaX6F98I/drdoA444VeQQgChUSY/jiQHwro+QYrcg=;
        b=gwz9Agl7YToGQXi+txwQf9xJVjuZI2Vf1U+ZX9iEDUnkclYcABJ0u+pYloV+/yMocwONTm
        VNk4mvuVT0CUHEmF67vdwIAibgNV59kKuSBtq5wGPprBgDEFYdfhKXOsvVQVB59Upy3Cgj
        GCCbqX3SZuDZ1XyBGlfb9rDeDBlh0uI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-TLv5Jar4OWCXAWc8oZbAoQ-1; Wed, 30 Dec 2020 22:46:45 -0500
X-MC-Unique: TLv5Jar4OWCXAWc8oZbAoQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EB778015C6;
        Thu, 31 Dec 2020 03:46:44 +0000 (UTC)
Received: from [10.72.12.236] (ovpn-12-236.pek2.redhat.com [10.72.12.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 976E460BE2;
        Thu, 31 Dec 2020 03:46:39 +0000 (UTC)
Subject: Re: [RFC 2/2] KVM: add initial support for ioregionfd blocking
 read/write operations
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
References: <cover.1609231373.git.eafanasova@gmail.com>
 <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <72556405-8501-26bc-4939-69e312857e91@redhat.com>
Date:   Thu, 31 Dec 2020 11:46:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/12/29 下午6:02, Elena Afanasova wrote:
> Signed-off-by: Elena Afanasova<eafanasova@gmail.com>
> ---
>   virt/kvm/ioregion.c | 157 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 157 insertions(+)
>
> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> index a200c3761343..8523f4126337 100644
> --- a/virt/kvm/ioregion.c
> +++ b/virt/kvm/ioregion.c
> @@ -4,6 +4,33 @@
>   #include <kvm/iodev.h>
>   #include "eventfd.h"
>   
> +/* Wire protocol */
> +struct ioregionfd_cmd {
> +	__u32 info;
> +	__u32 padding;
> +	__u64 user_data;
> +	__u64 offset;
> +	__u64 data;
> +};
> +


I wonder do we need a seq in the protocol. It might be useful if we 
allow a pair of file descriptors to be used for multiple different ranges.

Thanks


> +struct ioregionfd_resp {
> +	__u64 data;
> +	__u8 pad[24];
> +};

