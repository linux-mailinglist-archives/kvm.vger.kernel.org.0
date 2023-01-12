Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013A1666D15
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 09:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbjALIzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 03:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240015AbjALIx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 03:53:57 -0500
Received: from out-232.mta0.migadu.com (out-232.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667B538AC9
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 00:53:13 -0800 (PST)
Date:   Thu, 12 Jan 2023 09:53:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673513590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ih3LoD0rr1Vt0JqEH5DJCm0WVPskqNFudmLXTQa+hLM=;
        b=kl8Qi78H5E2mlUNfvcOzOb91mMuA5UySzjp03yZ737+IndlqzNzVO+w3N2qxSeCpgVGM/a
        /WV58mcmGtbss196wYSrlYY4ijnlu1ot2xHwR2x+8fUFjQAmwM1GPO9IKfh4foxNz/crKl
        AykQzCTED73HdgGzjhagvW0q2ZZJ3pc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
        imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v2 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Message-ID: <20230112085307.jvx5px2b3pfmwd6v@orel>
References: <20230111215422.2153645-1-coltonlewis@google.com>
 <20230111215422.2153645-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111215422.2153645-2-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 11, 2023 at 09:54:22PM +0000, Colton Lewis wrote:
> Replace the MAX_SMP probe loop in favor of reading a number directly
> from the QEMU error message. This is equally safe as the existing code
> because the error message has had the same format as long as it has
> existed, since QEMU v2.10. The final number before the end of the
> error message line indicates the max QEMU supports. A short awk
> program is used to extract the number, which becomes the new MAX_SMP
> value.
> 
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
> but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
                                                                    ^ 1

> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.

I guess that problem doesn't go away if we don't set the number of CPUs
to be the same, regardless of machine, i.e. we're still picking a
machine-specific value when we pick MAX_SMP. I think I know what you
mean though. For gicv2 tests on machines that support non-power-of-2
CPUs greater than 8 it's possible to end up with less than 8 for
MAX_SMP, which is surprising. Maybe while fixing the shift above you
can change the text to be more in line with that?

> 
> A previous comment explains the loop should only apply to kernels
> <=v4.3 on arm and suggests deletion when it becomes tiresome to
> maintian. However, it is always theoretically possible to test on a
> machine that has more CPUs than QEMU supports, so it makes sense to
> leave some check in place.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  scripts/runtime.bash | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f8794e9..4377e75 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -188,12 +188,10 @@ function run()
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
> +# error first. The awk program takes the last number from the QEMU
> +# error message, which gives the allowable MAX_SMP.
> +if $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> +      |& grep -qi 'exceeds max CPUs'; then

If the message has always been the same then the -i on grep shouldn't be
necessary.

> +	GET_LAST_NUM='/exceeds max CPUs/ {match($0, /[[:digit:]]+)$/); print substr($0, RSTART, RLENGTH-1)}'
> +	MAX_SMP=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& awk "$GET_LAST_NUM")

We should restructure this so we only have to invoke QEMU once and I
think we can do it with just bash and grep. Something like

 if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'exceeds max CPUs'); then
     smp=${smp##*\(}
     MAX_SMP=${smp:0:-1}
 fi

Thanks,
drew
