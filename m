Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51DB34C888
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 10:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhC2IXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:23:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233499AbhC2IVr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 04:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617006106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rdC6ctNxHMs5DpR2knYrAQfqYbnWOpzrP59GxxT4/4M=;
        b=U+I8uKhhhFBsqWn3zNl1pkgcX17H+LFeFBBM+FhT2D8CiBnzLJTo9tXn/82sGBP67H6ztY
        9eThFY2LHEkYNCqgAmNwWcbo99z3ZEOu2vy0N1FuoxOfMoxhoeGNuj3Id7TLfypELuuuOt
        K+6Pbbhli1WuiO+t6i3PExPTeDTs8hU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-gigemqIjPwChAmMd6dPyVA-1; Mon, 29 Mar 2021 04:21:42 -0400
X-MC-Unique: gigemqIjPwChAmMd6dPyVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99B7A1005D4F;
        Mon, 29 Mar 2021 08:21:41 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-129.ams2.redhat.com [10.36.112.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D95071002388;
        Mon, 29 Mar 2021 08:21:36 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: lib: css: separate wait for
 IRQ and check I/O completion
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <8a8430c6-a345-22aa-29ae-5df77b5d3b9c@redhat.com>
Date:   Mon, 29 Mar 2021 10:21:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/2021 10.39, Pierre Morel wrote:
> We will may want to check the result of an I/O without waiting
> for an interrupt.
> For example because we do not handle interrupt.
> Let's separate waiting for interrupt and the I/O complretion check.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/css.h     |  1 +
>   lib/s390x/css_lib.c | 13 ++++++++++---
>   2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 0058355..5d1e1f0 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -317,6 +317,7 @@ int css_residual_count(unsigned int schid);
>   
>   void enable_io_isc(uint8_t isc);
>   int wait_and_check_io_completion(int schid);
> +int check_io_completion(int schid);
>   
>   /*
>    * CHSC definitions
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index f5c4f37..1e5c409 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -487,18 +487,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>   }
>   
>   /* wait_and_check_io_completion:
> + * @schid: the subchannel ID
> + */
> +int wait_and_check_io_completion(int schid)
> +{
> +	wait_for_interrupt(PSW_MASK_IO);
> +	return check_io_completion(schid);
> +}
> +
> +/* check_io_completion:
>    * @schid: the subchannel ID
>    *
>    * Makes the most common check to validate a successful I/O
>    * completion.
>    * Only report failures.
>    */
> -int wait_and_check_io_completion(int schid)
> +int check_io_completion(int schid)
>   {
>   	int ret = 0;
>   
> -	wait_for_interrupt(PSW_MASK_IO);
> -
>   	report_prefix_push("check I/O completion");
>   
>   	if (lowcore_ptr->io_int_param != schid) {
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

