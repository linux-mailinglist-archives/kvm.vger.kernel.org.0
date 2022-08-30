Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284BF5A6B8B
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 20:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiH3SAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 14:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiH3R7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 13:59:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD578DE84
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:59:26 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f4so11332885pgc.12
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/+D2Tln40Mx/WAH0Ico3syAwQZZ8lLnlPBkmPzh1zz8=;
        b=RQZzWkEcevIVTT+KYPoXriMijj9PxtAFdQlty4WGXqmOHESCAe8GmWtZBvLvpxHhsS
         9HSBiG5ywBhQzuwuDYQATXZ57jFXWzftMFUiwdSpx/StJT/KsZKxpJxmRYPX6EOV/+SU
         KrRs03zaxV6+z736jnba0Ufz+S0/8pPQBh3qv6rfKB9xpZRQDYAkBbj2YsKLNzeox+Hm
         YLzPB7Al9l2Lf8ynUaBnwDFT+k46UbtrjweROi3U9udsiaaJrlctaU1cYZ/iT9OT6hxI
         hqnu454VhoiUzzj3TnGY/73edDBgfXXcQMezKe/GKvh5lntf6IUZkBewXUgqsmqjV0KP
         4vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/+D2Tln40Mx/WAH0Ico3syAwQZZ8lLnlPBkmPzh1zz8=;
        b=gXaOJsD43QJxvSN4JVkStA7CvT/TI8jSzr6jM3ey9Ub+jutqDKOhghtLRn04xeoNss
         TIRPcYKF30ZYNMPP9P+iQYJo45baCPrvFkpJzZaNuCR6VE5N2LArxhsb4jfXhmMVvm33
         s1rbEEZpNT+eWAux2CFDtmR1OWSa/GxKs2B1Cf8fo/vG/Oa5FytRRRjLm6jyRgkXeC5k
         BZhuP+vdkA1nE1Cp2DYGJ2i5njNDfTlyqOPjzxv4ttsenRXSVbntB7RqGYIdHQGdxdSB
         Bh1u2AmrVRqhNani7ziK6pcjOfwm2bajEHjs4j2oF4HuHWD4mI1tBP2GrfN0hnG9yvB/
         JsPQ==
X-Gm-Message-State: ACgBeo2ifOWwh7XWn8ZzjQzMS82fXAiUxizfM7RocpUqeTvu7HWfVKrF
        HLrlYD1YipqwaXHBHxDtc0ZkVA==
X-Google-Smtp-Source: AA6agR7ABHMc3AUNfVWIljR4WBT9M2pCoBIN1rtf9rRj/Y5zNRUWm1RfbFczEegYA3fW4+M4tCx9Ww==
X-Received: by 2002:a05:6a00:1910:b0:52f:13d7:44c4 with SMTP id y16-20020a056a00191000b0052f13d744c4mr21741073pfi.32.1661882364637;
        Tue, 30 Aug 2022 10:59:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j64-20020a625543000000b0050dc76281e0sm9627945pfb.186.2022.08.30.10.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 10:59:24 -0700 (PDT)
Date:   Tue, 30 Aug 2022 17:59:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH RESEND v2 6/8] KVM: x86/pmu: Defer counter emulated
 overflow via pmc->stale_counter
Message-ID: <Yw5P+COQIf/UPNuY@google.com>
References: <20220823093221.38075-1-likexu@tencent.com>
 <20220823093221.38075-7-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823093221.38075-7-likexu@tencent.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> There are contextual restrictions on the functions that can be called
> in the *_exit_handlers_fastpath path, for example calling
> pmc_reprogram_counter() brings up a host complaint like:

State the actual problem instead of forcing the reader to decipher that from the
stacktrace.

>  [*] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
>  [*] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 2981888, name: CPU 15/KVM
>  [*] preempt_count: 1, expected: 0
>  [*] RCU nest depth: 0, expected: 0
>  [*] INFO: lockdep is turned off.
>  [*] irq event stamp: 0
>  [*] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>  [*] hardirqs last disabled at (0): [<ffffffff8121222a>] copy_process+0x146a/0x62d0
>  [*] softirqs last  enabled at (0): [<ffffffff81212269>] copy_process+0x14a9/0x62d0
>  [*] softirqs last disabled at (0): [<0000000000000000>] 0x0
>  [*] Preemption disabled at:
>  [*] [<ffffffffc2063fc1>] vcpu_enter_guest+0x1001/0x3dc0 [kvm]
>  [*] CPU: 17 PID: 2981888 Comm: CPU 15/KVM Kdump: 5.19.0-rc1-g239111db364c-dirty #2
>  [*] Call Trace:
>  [*]  <TASK>
>  [*]  dump_stack_lvl+0x6c/0x9b
>  [*]  __might_resched.cold+0x22e/0x297
>  [*]  __mutex_lock+0xc0/0x23b0
>  [*]  perf_event_ctx_lock_nested+0x18f/0x340
>  [*]  perf_event_pause+0x1a/0x110
>  [*]  reprogram_counter+0x2af/0x1490 [kvm]
>  [*]  kvm_pmu_trigger_event+0x429/0x950 [kvm]
>  [*]  kvm_skip_emulated_instruction+0x48/0x90 [kvm]
>  [*]  handle_fastpath_set_msr_irqoff+0x349/0x3b0 [kvm]
>  [*]  vmx_vcpu_run+0x268e/0x3b80 [kvm_intel]
>  [*]  vcpu_enter_guest+0x1d22/0x3dc0 [kvm]
> 
> A new stale_counter field is introduced to keep this part of the semantics
> invariant. It records the current counter value and it's used to determine
> whether to inject an emulated overflow interrupt in the later
> kvm_pmu_handle_event(), given that the internal count value from its
> perf_event has not been added to pmc->counter in time, or the guest
> will update the value of a running counter directly.

Describe what the change is at a high level, don't give a play-by-play of the
code changes.

  Defer reprogramming counters and handling overflow via KVM_REQ_PMU
  when incrementing counters.  KVM skips emulated WRMSR in the VM-Exit
  fastpath, the fastpath runs with IRQs disabled, skipping instructions
  can increment and reprogram counters, reprogramming counters can
  sleep, and sleeping is disallowed while IRQs are disabled.

  <stack trace>

  Add a field to kvm_pmc to track the previous counter value in order
  to defer overflow detection to kvm_pmu_handle_event() (reprogramming
  must be done before handling overflow).

> Opportunistically shrink sizeof(struct kvm_pmc) a bit.
> 
> Suggested-by: Wanpeng Li <wanpengli@tencent.com>
> Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 +++--
>  arch/x86/kvm/pmu.c              | 15 ++++++++-------
>  arch/x86/kvm/svm/pmu.c          |  2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
>  4 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4e568a7ef464..ffd982bf015d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -488,7 +488,10 @@ enum pmc_type {
>  struct kvm_pmc {
>  	enum pmc_type type;
>  	u8 idx;
> +	bool is_paused;
> +	bool intr;
>  	u64 counter;
> +	u64 stale_counter;

Use "prev_counter", "stale" makes it sound like a flag, e.g. "this counter is
stale".

>  	u64 eventsel;
>  	struct perf_event *perf_event;
>  	struct kvm_vcpu *vcpu;
> @@ -498,8 +501,6 @@ struct kvm_pmc {
>  	 * ctrl value for fixed counters.
>  	 */
>  	u64 current_config;
> -	bool is_paused;
> -	bool intr;
>  };
>  
>  #define KVM_PMC_MAX_FIXED	3
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 6940cbeee54d..45d062cb1dd5 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -350,6 +350,12 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  		}
>  
>  		__reprogram_counter(pmc);
> +
> +		if (pmc->stale_counter) {

This check is unnecessary.  The values are unsigned, so counter can't be less than
the previous value if the previous value was '0'.

> +			if (pmc->counter < pmc->stale_counter)
> +				__kvm_perf_overflow(pmc, false);
> +			pmc->stale_counter = 0;
> +		}
