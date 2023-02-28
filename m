Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F381E6A6038
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 21:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjB1URZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 15:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB1URY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 15:17:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5116730B19;
        Tue, 28 Feb 2023 12:17:22 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677615440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+tJEqgPfdkTLU3mHfnXrw2lQR9/7aJ/wKbNQqiobsHA=;
        b=3/ATstbq1/o40KQTaNbjoQFnnRTxln+BSFSftjZl4miiX0TOMmHlKAvntvpvK8n58cBAPq
        QSweVaDkdRg8gKlaKLyOTfUaZVBodYetM5Qxf9t7CjYwSnpitNIOlWsZVdoQgmTlbZktbF
        JGJt4ytVrT4i5qdLUvvHJANSdw42TunY9w1B5M4F27l8Ax7/aMmAsj4vUJ/pmBi5iofZ7e
        9BazaWNjxsfEkaiCsljXy9Zz4aSplSe7psdVXAyPbaEwtYoF1JtpRGYm3ASxOd4Y4Jxz3w
        4WH+2O5JgQCNjQkVslb1ubbtgWxf+Lr9ZC3/QfvlMWA15T4+2nAMrB7ZbzdgLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677615440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+tJEqgPfdkTLU3mHfnXrw2lQR9/7aJ/wKbNQqiobsHA=;
        b=hfXbJyNq/WCvzU5kJYwwuAWRs5vlS8B6t/OswGP/vo0Xa6aH6LS2i0jKHm62zAgbhr3NwW
        TRs2z77XlyQBJcAw==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v12 06/11] x86/smpboot: Remove initial_stack on 64-bit
In-Reply-To: <c6863590f5fbf139f6aec50d0f3bc8e8b00cfcaf.camel@infradead.org>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-7-usama.arif@bytedance.com> <87k001n4xo.ffs@tglx>
 <c6863590f5fbf139f6aec50d0f3bc8e8b00cfcaf.camel@infradead.org>
Date:   Tue, 28 Feb 2023 21:17:19 +0100
Message-ID: <87edq9mto0.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28 2023 at 17:09, David Woodhouse wrote:
> On Tue, 2023-02-28 at 17:13 +0100, Thomas Gleixner wrote:
>> As this patch is now part of the parallel boot series and actually
>> introduces smpboot_control, the above is neither accurate nor useful.
>
> Better commit message, add a comment where we abuse current->thread.sp
> in the sleep path. Didn't remove the {} which would be added back in
> the very next patch. Pushed to my tree for Usama's next round.

Ok.

> However, we start by introducing one more: smpboot_control. For now this

s/we// :)

> merely holds the CPU# of the CPU which is coming up. That CPU can then
> find its own per-cpu data, and everything else it needs can be found from
> there, allowing the other global variables to be removed.
>
> First to be removed is initial_stack. Each CPU can load %rsp from its
> current_task->thread.sp instead. That is already set up with the correct
> idle thread for APs. Set up the .sp field in INIT_THREAD on x86 so that
> the BSP also finds a suitable stack pointer in the static per-cpu data
> when coming up on first boot.
>
> On resume from S3, the CPU needs a temporary stack because its idle task
> is already active. Instead of setting initial_stack, the sleep code can
> simply set its own current->thread.sp to point to the temporary stack.
> The true stack pointer will get restored with the rest of the CPU
> context in do_suspend_lowlevel().

Thanks for writing this up!

> +	/*
> +	 * As each CPU starts up, it will find its own stack pointer
> +	 * from its current_task->thread.sp. Typically that will be
> +	 * the idle thread for a newly-started AP, or even the boot
> +	 * CPU which will find it set to &init_task in the static
> +	 * per-cpu data.
> +	 *
> +	 * Make the resuming CPU use the temporary stack at startup
> +	 * by setting current->thread.sp to point to that. The true
> +	 * %rsp will be restored with the rest of the CPU context,
> +	 * by do_suspend_lowlevel().

Right, but what restores current->thread.sp? thread.sp is used by
unwinders...

Thanks,

        tglx
