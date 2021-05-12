Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E2237BAD4
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 12:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhELKjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 06:39:39 -0400
Received: from foss.arm.com ([217.140.110.172]:36404 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhELKjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 06:39:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F16B31B;
        Wed, 12 May 2021 03:38:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E56863F719;
        Wed, 12 May 2021 03:38:24 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 1/2] libcflat: clean up and complete long
 division routines
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20210511174106.703235-1-pbonzini@redhat.com>
 <20210511174106.703235-2-pbonzini@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3255ae16-ee2d-861d-d7e8-9360e7eaa09c@arm.com>
Date:   Wed, 12 May 2021 11:39:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210511174106.703235-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Thanks for sending this so quickly!

On 5/11/21 6:41 PM, Paolo Bonzini wrote:
> Avoid possible uninitialized variables on machines where
> division by zero does not trap.  Add __divmoddi4, and

According to the ARM Architecture Reference Manual for ARMv7-A (ARM DDI 0406C.d),
hardware floating point support is optional (page A2-54), so initializing the
remainder to zero in the case of zero division makes sense.

> do not use 64-bit math unnecessarily in __moddi3 and __divdi3.
>
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  lib/ldiv32.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/lib/ldiv32.c b/lib/ldiv32.c
> index 96f4b35..c39fccd 100644
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
> @@ -35,9 +39,27 @@ uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
>  	return quot;
>  }
>  
> +int64_t __divmoddi4(int64_t num, int64_t den, int64_t *p_rem)
> +{
> +	int32_t nmask = num < 0 ? -1 : 0;
> +	int32_t qmask = (num ^ den) < 0 ? -1 : 0;
> +	uint64_t quot;
> +
> +	/* Compute absolute values and do an unsigned division.  */
> +	num = (num + nmask) ^ nmask;
> +	if (den < 0)
> +		den = -den;
> +
> +	/* Copy sign of num^den into quotient, sign of num into remainder.  */
> +	quot = (__divmoddi4(num, den, p_rem) + qmask) ^ qmask;

I see no early return statement in the function, it looks to me like the function
will recurse forever. Maybe you wanted to call here __*u*divmoddi4() (emphasis
added) instead?

Other than that, the function looks correct.

Thanks,

Alex

> +	if (p_rem)
> +		*p_rem = (*p_rem + nmask) ^ nmask;
> +	return quot;
> +}
> +
>  int64_t __moddi3(int64_t num, int64_t den)
>  {
> -	uint64_t mask = num < 0 ? -1 : 0;
> +	int32_t mask = num < 0 ? -1 : 0;
>  
>  	/* Compute absolute values and do an unsigned division.  */
>  	num = (num + mask) ^ mask;
> @@ -50,7 +72,7 @@ int64_t __moddi3(int64_t num, int64_t den)
>  
>  int64_t __divdi3(int64_t num, int64_t den)
>  {
> -	uint64_t mask = (num ^ den) < 0 ? -1 : 0;
> +	int32_t mask = (num ^ den) < 0 ? -1 : 0;
>  
>  	/* Compute absolute values and do an unsigned division.  */
>  	if (num < 0)
