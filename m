Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6A637BE6C
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 15:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhELNpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 09:45:14 -0400
Received: from foss.arm.com ([217.140.110.172]:39424 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhELNpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 09:45:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0CA76D;
        Wed, 12 May 2021 06:44:05 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54FAE3F718;
        Wed, 12 May 2021 06:44:05 -0700 (PDT)
Subject: Re: [PATCH v2 kvm-unit-tests 1/2] libcflat: clean up and complete
 long division routines
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20210512105440.748153-1-pbonzini@redhat.com>
 <20210512105440.748153-2-pbonzini@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6febc33b-d45d-f251-3df6-51153ca7dcc3@arm.com>
Date:   Wed, 12 May 2021 14:44:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512105440.748153-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 5/12/21 11:54 AM, Paolo Bonzini wrote:
> Avoid possible uninitialized variables on machines where
> division by zero does not trap.  Add __divmoddi4, and
> use it in __moddi3 and __divdi3.

Looks good now, I like the change to __moddi3 and __divdi3 as that means that the
tests will cover __divmoddi4, and the functions are now similar to their unsigned
counterparts:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  lib/ldiv32.c | 40 ++++++++++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 16 deletions(-)
>
> diff --git a/lib/ldiv32.c b/lib/ldiv32.c
> index 96f4b35..897a4b9 100644
> --- a/lib/ldiv32.c
> +++ b/lib/ldiv32.c
> @@ -1,6 +1,7 @@
>  #include <stdint.h>
>  
>  extern uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem);
> +extern int64_t __divmoddi4(int64_t num, int64_t den, int64_t *p_rem);
>  extern int64_t __moddi3(int64_t num, int64_t den);
>  extern int64_t __divdi3(int64_t num, int64_t den);
>  extern uint64_t __udivdi3(uint64_t num, uint64_t den);
> @@ -11,8 +12,11 @@ uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
>  	uint64_t quot = 0;
>  
>  	/* Trigger a division by zero at run time (trick taken from iPXE).  */
> -	if (den == 0)
> +	if (den == 0) {
> +		if (p_rem)
> +			*p_rem = 0;
>  		return 1/((unsigned)den);
> +	}
>  
>  	if (num >= den) {
>  		/* Align den to num to avoid wasting time on leftmost zero bits.  */
> @@ -35,31 +39,35 @@ uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
>  	return quot;
>  }
>  
> -int64_t __moddi3(int64_t num, int64_t den)
> +int64_t __divmoddi4(int64_t num, int64_t den, int64_t *p_rem)
>  {
> -	uint64_t mask = num < 0 ? -1 : 0;
> +	int32_t nmask = num < 0 ? -1 : 0;
> +	int32_t qmask = (num ^ den) < 0 ? -1 : 0;
> +	uint64_t quot;
>  
>  	/* Compute absolute values and do an unsigned division.  */
> -	num = (num + mask) ^ mask;
> +	num = (num + nmask) ^ nmask;
>  	if (den < 0)
>  		den = -den;
>  
> -	/* Copy sign of num into result.  */
> -	return (__umoddi3(num, den) + mask) ^ mask;
> +	/* Copy sign of num^den into quotient, sign of num into remainder.  */
> +	quot = (__udivmoddi4(num, den, (uint64_t *)p_rem) + qmask) ^ qmask;
> +	if (p_rem)
> +		*p_rem = (*p_rem + nmask) ^ nmask;
> +	return quot;
>  }
>  
> -int64_t __divdi3(int64_t num, int64_t den)
> +int64_t __moddi3(int64_t num, int64_t den)
>  {
> -	uint64_t mask = (num ^ den) < 0 ? -1 : 0;
> -
> -	/* Compute absolute values and do an unsigned division.  */
> -	if (num < 0)
> -		num = -num;
> -	if (den < 0)
> -		den = -den;
> +	int64_t rem;
> +	__divmoddi4(num, den, &rem);
> +	return rem;
> +}
>  
> -	/* Copy sign of num^den into result.  */
> -	return (__udivdi3(num, den) + mask) ^ mask;
> +int64_t __divdi3(int64_t num, int64_t den)
> +{
> +	int64_t rem;
> +	return __divmoddi4(num, den, &rem);
>  }
>  
>  uint64_t __udivdi3(uint64_t num, uint64_t den)
