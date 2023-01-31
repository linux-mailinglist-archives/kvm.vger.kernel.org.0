Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846DD682484
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 07:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjAaGig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 01:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjAaGif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 01:38:35 -0500
X-Greylist: delayed 387 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 22:38:33 PST
Received: from out-77.mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2C03CE2A
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 22:38:33 -0800 (PST)
Date:   Tue, 31 Jan 2023 07:32:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675146724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x8Kn2qeJM1klhLG/HhjicUBVZSX/GZZVoTBt/Rvyd2E=;
        b=xxKybRY1ykRSEdudXEQS2ucWfFEh/LyCFhGW7F4W+nqF8YNTdCCoOiGZxR5VovBqsWv0rG
        Al6UCOKMpmaAXHNNId1taW5DKnvnXvrkebJr6b9ZyB38czKut1ckVcsx/HYrFrzvtpd0Cw
        MH3+ojnjLTYZqsvmCBL2JS/4e9GfsSw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
        imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v3 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Message-ID: <20230131063203.67qgjf2ispi2k6hd@orel>
References: <20230130195700.729498-1-coltonlewis@google.com>
 <20230130195700.729498-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130195700.729498-2-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 07:57:00PM +0000, Colton Lewis wrote:
> Replace the MAX_SMP probe loop in favor of reading a number directly
> from the QEMU error message. This is equally safe as the existing code
> because the error message has had the same format as long as it has
> existed, since QEMU v2.10. The final number before the end of the
> error message line indicates the max QEMU supports. A short awk

awk is not used, despite the comment also being updated to say it's
being used.

> program is used to extract the number, which becomes the new MAX_SMP
> value.
> 
> This loop logic is broken for machines with a number of CPUs that
> isn't a power of two. This problem was noticed for gicv2 tests on
> machines with a non-power-of-two number of CPUs greater than 8 because
> tests were running with MAX_SMP less than 8. As a hypthetical example,
> a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
> 6. This can, in rare circumstances, lead to different test results
> depending only on the number of CPUs the machine has.
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
> index f8794e9a..587ffe30 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -188,12 +188,10 @@ function run()
>  # Probe for MAX_SMP, in case it's less than the number of host cpus.
>  #
>  # This probing currently only works for ARM, as x86 bails on another

It just occurred to me that this code runs on all architectures, even
though it only works for Arm. We should wrap this code in $ARCH
checks or put it in a function which only Arm calls. That change
should be a separate patch though.

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
> +if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> +      |& grep 'exceeds max CPUs'); then
> +	smp=${smp##*(}
> +	MAX_SMP=${smp:0:-1}
> +fi
> -- 
> 2.39.1.456.gfc5497dd1b-goog
>

Thanks,
drew
