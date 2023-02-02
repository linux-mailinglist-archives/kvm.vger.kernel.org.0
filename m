Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E416876EF
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjBBICF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbjBBIBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:01:46 -0500
Received: from out-236.mta0.migadu.com (out-236.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ec])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBA28660D
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 00:01:32 -0800 (PST)
Date:   Thu, 2 Feb 2023 09:01:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675324890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vox5D44kH5MDAFbCq9MCAQQB3B4oIlJzuk/ZpbnnsEQ=;
        b=NWQxg4fiXxnIFla94/48Hbm+7rSIhYESWNTsSlSWZOoFGH1g7WXwpFyZDzbEr0zdYOZC4d
        plQmbGlvklTtoYo/AWvlaeWG0IJzPasOUerbAKeJXrxJFRQNC/8fSqMwG03yaHsmJ4Yu4x
        TZkL00rK/mUYJDeXUvcY0UJfN5gGJuM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
        imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v4 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Message-ID: <20230202080122.2kbtmsbcu45pzr4f@orel>
References: <20230201172110.1970980-1-coltonlewis@google.com>
 <20230201172110.1970980-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201172110.1970980-2-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 05:21:10PM +0000, Colton Lewis wrote:
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
>  scripts/runtime.bash | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f8794e9a..587ffe30 100644
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

I point this awk reference out in the last review. I also stated
we should do something else, which is not done in this version.
Go read the last review comments again.

> +# error message, which gives the allowable MAX_SMP.
> +if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> +      |& grep 'exceeds max CPUs'); then
> +	smp=${smp##*(}
> +	MAX_SMP=${smp:0:-1}
> +fi
> -- 
> 2.39.1.456.gfc5497dd1b-goog
> 
