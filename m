Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20465696E55
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 21:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjBNUSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 15:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBNUSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 15:18:20 -0500
Received: from out-125.mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BEA1DB8C
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 12:18:19 -0800 (PST)
Date:   Tue, 14 Feb 2023 21:18:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676405897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yuaj1zHJFoMRoJdDoO0Dzp8Y3jToLAkJ82554SZ8ZIU=;
        b=k+3PkFmNUb/WlOGQkV+evZKnMssx18jo7IkQO+fxrPjU+xDmFDPA7JWw1WQ+po7wXixkQt
        hBEy63+/7sbhUDkzm1uEaLoAtDizanAU425UCRaSQkqDzHQWbK9p3quzoLcegDzNtWYSDm
        SEOMHzIMfB0GtfYBLrxjABItmm+F7TY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
        imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v5] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Message-ID: <20230214201816.rhky4rn7kmvfuh75@orel>
References: <20230207233256.3791424-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207233256.3791424-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 11:32:56PM +0000, Colton Lewis wrote:
> Replace the MAX_SMP probe loop in favor of reading a number directly
> from the QEMU error message. This is equally safe as the existing code
> because the error message has had the same format as long as it has
> existed, since QEMU v2.10. The final number before the end of the
> error message line indicates the max QEMU supports.
> 
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. This problem was noticed for gicv2 tests on
> machines with a non-power-of-two number of CPUs greater than 8 because
> tests were running with MAX_SMP less than 8. As a hypothetical example,
> a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.
> 
> A previous comment explains the loop should only apply to kernels
> <=v4.3 on arm and suggests deletion when it becomes tiresome to
> maintain. However, it is always theoretically possible to test on a
> machine that has more CPUs than QEMU supports, so it makes sense to
> leave some check in place.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  scripts/runtime.bash | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> v5: Remove the last awk reference and guard the probing code with a
> check that ARCH = arm or arm64.
> 
> v4: https://lore.kernel.org/kvm/20230201172110.1970980-1-coltonlewis@google.com/
> 
> v3: https://lore.kernel.org/kvm/20230130195700.729498-1-coltonlewis@google.com/
> 
> v2: https://lore.kernel.org/kvm/20230111215422.2153645-1-coltonlewis@google.com/
> 
> v1: https://lore.kernel.org/kvm/20221219185250.631503-1-coltonlewis@google.com/
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f8794e9a..fb64e855 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -188,12 +188,11 @@ function run()
>  # Probe for MAX_SMP, in case it's less than the number of host cpus.
>  #
>  # This probing currently only works for ARM, as x86 bails on another
> -# error first. Also, this probing isn't necessary for any ARM hosts
> -# running kernels later than v4.3, i.e. those including ef748917b52
> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
> -# point when maintaining the while loop gets too tiresome, we can
> -# just remove it...
> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> -		|& grep -qi 'exceeds max CPUs'; do
> -	MAX_SMP=$((MAX_SMP >> 1))
> -done
> +# error first, so this check is only run for ARM and ARM64. The
> +# parameter expansion takes the last number from the QEMU error
> +# message, which gives the allowable MAX_SMP.
> +if [ "${ARCH%64}" = arm ] && smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> +      |& grep 'exceeds max CPUs'); then
> +	smp=${smp##*(}
> +	MAX_SMP=${smp:0:-1}
> +fi
> --
> 2.39.1.519.gcb327c4b5f-goog

Applied, thanks
