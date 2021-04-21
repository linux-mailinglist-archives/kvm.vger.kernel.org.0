Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F63B3669BB
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 13:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhDULOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 07:14:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238732AbhDULOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 07:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619003627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/V0WhEVHAM0C6m5PpVh+o2jrUdbsJsqNYYgAzqcM5I=;
        b=ItDRFKKtebMAgqIYz3YTyKp9oYmffnQfvITvBUstHa0Fz/5Up4mEfmOXU3gkX6bLGj82Kw
        i4NTD+l4ERrhss/LWpVQQ2YiNTEWmJhFsgmHU1iYcJewYV+r7sSH8oQfw8xQ9Y7JHcQP3T
        FdOSKm4c+8TkRlwplrUlkvtGzephQf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-JTxke6veN_SQyPArducv5Q-1; Wed, 21 Apr 2021 07:13:43 -0400
X-MC-Unique: JTxke6veN_SQyPArducv5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB7E283DD20;
        Wed, 21 Apr 2021 11:13:42 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-112-160.ams2.redhat.com [10.36.112.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 774896268F;
        Wed, 21 Apr 2021 11:13:37 +0000 (UTC)
Date:   Wed, 21 Apr 2021 13:13:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/6] s390x: Add more Ultravisor command
 structure definitions
Message-ID: <20210421131335.31a2bf47.cohuck@redhat.com>
In-Reply-To: <20210316091654.1646-3-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
        <20210316091654.1646-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 09:16:50 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> They are needed in the new UV tests.
> 
> As we now extend the size of the query struct, we need to set the
> length in the UV guest query test to a constant instead of using
> sizeof.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h | 148 ++++++++++++++++++++++++++++++++++++++++++++-
>  s390x/uv-guest.c   |   2 +-
>  2 files changed, 148 insertions(+), 2 deletions(-)
> 

(...)

>  struct uv_cb_qui {
>  	struct uv_cb_header header;
>  	u64 reserved08;
>  	u64 inst_calls_list[4];
> -	u64 reserved30[15];
> +	u64 reserved30[2];
> +	u64 uv_base_stor_len;
> +	u64 reserved48;
> +	u64 conf_base_phys_stor_len;
> +	u64 conf_base_virt_stor_len;
> +	u64 conf_virt_var_stor_len;
> +	u64 cpu_stor_len;
> +	u32 reserved70[3];
> +	u32 max_num_sec_conf;
> +	u64 max_guest_stor_addr;
> +	u8  reserved88[158 - 136];
> +	u16 max_guest_cpus;
> +	u8  reserveda0[200 - 160];
> +}  __attribute__((packed))  __attribute__((aligned(8)));

(...)

> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index a13669ab..95a968c5 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -59,7 +59,7 @@ static void test_query(void)
>  {
>  	struct uv_cb_qui uvcb = {
>  		.header.cmd = UVC_CMD_QUI,
> -		.header.len = sizeof(uvcb) - 8,
> +		.header.len = 0xa0,

This is a magic constant coming out of nowhere. Could you please at
least add a comment to make clear what you are testing?

>  	};
>  	int cc;
>  

