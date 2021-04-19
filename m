Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA897364066
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 13:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbhDSLZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 07:25:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238235AbhDSLY7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 07:24:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618831469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4pQoOAQbOu69VBRovTiFAk1L5ZGcnX6fUZqyACIrwfI=;
        b=gTtCih729rqtpRLryBtKoOutejkU7rR3LNl2JH8fdgUcJfif8Z4ZKn2iXOgrqSvMDRtjcp
        C6iqb2WBkDJfqLqPab0Lec0btCXRsGW5hrqx8jxNAQSFoDhA8GuPqk7wrfXWDaP8AChCSj
        PIoTZNNMUtDbnMbe3GNs0gYVqGCOGAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-oAMriGx1PKSz0LcsX0MecA-1; Mon, 19 Apr 2021 07:24:27 -0400
X-MC-Unique: oAMriGx1PKSz0LcsX0MecA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE480108BD0A;
        Mon, 19 Apr 2021 11:24:25 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 995105D741;
        Mon, 19 Apr 2021 11:24:24 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: uv-guest: Add invalid share
 location test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        imbrenda@linux.ibm.com
References: <20210316091654.1646-1-frankja@linux.ibm.com>
 <20210316091654.1646-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2c178a2c-d207-e4b8-f159-ecd9e18a2d28@redhat.com>
Date:   Mon, 19 Apr 2021 13:24:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210316091654.1646-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/2021 10.16, Janosch Frank wrote:
> Let's also test sharing unavailable memory.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/uv-guest.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 99544442..a13669ab 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -15,6 +15,7 @@
>   #include <asm/interrupt.h>
>   #include <asm/facility.h>
>   #include <asm/uv.h>
> +#include <sclp.h>
>   
>   static unsigned long page;
>   
> @@ -99,6 +100,10 @@ static void test_sharing(void)
>   	uvcb.header.len = sizeof(uvcb);
>   	cc = uv_call(0, (u64)&uvcb);
>   	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "share");
> +	uvcb.paddr = get_ram_size() + PAGE_SIZE;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x101, "invalid memory");

Would it make sense to add a #define for 0x101 ?

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>

