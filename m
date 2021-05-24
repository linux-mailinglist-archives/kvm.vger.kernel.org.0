Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C4E38F281
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhEXRux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:50:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233471AbhEXRuw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621878564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HCVGDPjhDboqswyYbpUusx4xh2KVDt6mlxvdBPf1sRw=;
        b=NAWFqJulXhJQFVzbbw1VWreOkgYxQpLqCQsGTsKJvl7IDZvRbbBR1khTqVVejMpGr3m/Mc
        z65EqAGPRAtsSatZ8BlarZrvEojtcPZFCqegxfIWbn2aeYVcWWiwCVWxSfL5+kXW0Fcnxw
        SLBJUzYlGj+SDW4ry2RzZnSVBbcscAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-nephAWIsOKqTpA52vfqhvA-1; Mon, 24 May 2021 13:49:20 -0400
X-MC-Unique: nephAWIsOKqTpA52vfqhvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73769800D62;
        Mon, 24 May 2021 17:49:18 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC46850C0D;
        Mon, 24 May 2021 17:49:14 +0000 (UTC)
Message-ID: <f6913c3669e156372c3d8e94946f2ec0dfc97020.camel@redhat.com>
Subject: Re: [PATCH v3 01/12] math64.h: Add mul_s64_u64_shr()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 24 May 2021 20:49:13 +0300
In-Reply-To: <20210521102449.21505-2-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-2-ilstam@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-05-21 at 11:24 +0100, Ilias Stamatis wrote:
> This function is needed for KVM's nested virtualization. The nested TSC
> scaling implementation requires multiplying the signed TSC offset with
> the unsigned TSC multiplier.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  include/linux/math64.h | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/include/linux/math64.h b/include/linux/math64.h
> index 66deb1fdc2ef..2928f03d6d46 100644
> --- a/include/linux/math64.h
> +++ b/include/linux/math64.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_MATH64_H
>  
>  #include <linux/types.h>
> +#include <linux/math.h>
>  #include <vdso/math64.h>
>  #include <asm/div64.h>
>  
> @@ -234,6 +235,24 @@ static inline u64 mul_u64_u64_shr(u64 a, u64 b, unsigned int shift)
>  
>  #endif
>  
> +#ifndef mul_s64_u64_shr
> +static inline u64 mul_s64_u64_shr(s64 a, u64 b, unsigned int shift)
> +{
> +	u64 ret;
> +
> +	/*
> +	 * Extract the sign before the multiplication and put it back
> +	 * afterwards if needed.
> +	 */
> +	ret = mul_u64_u64_shr(abs(a), b, shift);
> +
> +	if (a < 0)
> +		ret = -((s64) ret);
> +
> +	return ret;
> +}
> +#endif /* mul_s64_u64_shr */
> +
>  #ifndef mul_u64_u32_div
>  static inline u64 mul_u64_u32_div(u64 a, u32 mul, u32 divisor)
>  {

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

