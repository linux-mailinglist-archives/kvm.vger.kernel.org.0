Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3297F5F7C7F
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 19:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJGRvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 13:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiJGRvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 13:51:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62838D25B2
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 10:51:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x1so5197830plv.5
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 10:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1lRmPL17ewK5r7v4/Z5wcorFNGfrrBdSgDO7MWGkQEg=;
        b=gxpxA5Y1bjH0g6B+S6aB5V1jKYPn4lfH/Xc+8h1IW/23TzX0TrkOQgzQT9XjRjNHb4
         9gtI9i9tzwaGJ3bec5ZGElmaVkFLmqXPLd7eZNOs/MsJeaDRHDaVVnVfG8mzLyf87xuT
         cRfm6P8y2b87GvvTKkQRpp91tixHfxihtpGS79Kpx6bQmQ2uBK0Wnd8ZsdYRCs+5Ex0j
         M2kb8UmgaLzSgRpD49o40wVX2fMGgXk2iZNg7Ho0R0vIKRbD2z/DhNn1WdC6IZ2q0hPv
         awPBlC0/TrOaOyCciM6chHMX7/fox/jEkDq4pRWKCZqTjOluO2BOkZyw3AStz0ecaM0m
         JiVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lRmPL17ewK5r7v4/Z5wcorFNGfrrBdSgDO7MWGkQEg=;
        b=Cr7C+uWbGUqx2jwUfKgp6943DYYLEI+e1LHrO5AHQPxFhEKSS7FY2rtMIr+Ivf7e0A
         X99HzcFaR2r78BIugH8MT0z3JI3QZRmWTmcV1ZoBGLJ/+Nl3pj3tq3odiPdu1ZE1/N1v
         y4/LpckYwLxHHQyL0yjG5l9/h2XdfUUA1sf3WUk6P1IMZ2NFBbW9bXcNT+4l7PQ2Ca7W
         cL4PRiXJlUja26V49sJH8EY3aEkXw8ZV2fAU7h+6Ays7at6dVukR6FpLU8pu8vCTWqb3
         i/kGgXmVlzL6/7+4YUXOFzncHLRYnJ3sMZddBTZFPbgh38WJFM9mqvZ+rjZPfbrjxJj0
         Pd2Q==
X-Gm-Message-State: ACrzQf1E2wZzEGAftI3JjgUS/E66ihv2Ud0rYOmqOXR0fpuMvKzLxpSA
        3o4/R6mQwM+FiZ3Tgtkigi9dng==
X-Google-Smtp-Source: AMsMyM5kqCzb06FD9oceSqeqw1khdmPQSFaoWKiN6xW+VUZXdNE0dGIf9lgqMZLZ/7KSf+Sp9HsWvQ==
X-Received: by 2002:a17:902:e8ca:b0:17f:764c:740f with SMTP id v10-20020a170902e8ca00b0017f764c740fmr6015816plg.51.1665165101675;
        Fri, 07 Oct 2022 10:51:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h2-20020a63f902000000b00438834b14a1sm1914025pgi.80.2022.10.07.10.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 10:51:40 -0700 (PDT)
Date:   Fri, 7 Oct 2022 17:51:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dapeng Mi <dapeng1.mi@intel.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhenyuw@linux.intel.com
Subject: Re: [PATCH] KVM: x86: disable halt polling when powersave governor
 is used
Message-ID: <Y0BnKIW+7sqJbTyY@google.com>
References: <20220915073121.1038840-1-dapeng1.mi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915073121.1038840-1-dapeng1.mi@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 15, 2022, Dapeng Mi wrote:
> Halt polling is enabled by default even through the CPU frequency
> governor is configured to powersave. Generally halt polling would
> consume extra power and this's not identical with the intent of
> powersave governor.
> 
> disabling halt polling in powersave governor can save the precious
> power in power critical case.
> 
> FIO random read test on Alder Lake platform shows halt polling
> occupies ~17% CPU utilization and consume 7% extra CPU power.
> After disabling halt polling, CPU has more chance to enter deeper
> C-states (C1E%: 25.3% -> 33.4%, C10%: 4.4% -> 17.4%).
> 
> On Alder Lake platform, we don't find there are obvious performance
> downgrade after disabling halt polling on FIO and Netperf cases.
> Netperf UDP_RR case runs from two VMs locate on two different physical
> machines.
> 
> FIO(MB/s)	Base	Disable-halt-polling	Delta%
> Rand-read	432.6	436.3			0.8%
> 
> Netperf		Base	Disable-halt-polling	Delta%
> UDP_RR          509.8	508.5			-0.3%
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@intel.com>
> ---
>  arch/x86/kvm/x86.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7374d768296..c0eb6574cbbb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13015,7 +13015,22 @@ bool kvm_vector_hashing_enabled(void)
>  
>  bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  {
> -	return (vcpu->arch.msr_kvm_poll_control & 1) == 0;
> +	struct cpufreq_policy *policy = cpufreq_cpu_get(vcpu->cpu);

Preemption is not disabled at this point, which means that using vcpu->cpu is
potentially unsafe.  Given that cpufreq is refcounting the returned object, I gotta
imaging get migrated to a different pCPU would be problematic.

> +	bool powersave = false;

I don't see anything in here that's x86 specific.  Unless I'm missing something,
this belongs in common KVM.

> +
> +	/*
> +	 * Halt polling could consume much CPU power, if CPU frequency
> +	 * governor is set to "powersave", disable halt polling.
> +	 */
> +	if (policy) {
> +		if ((policy->policy == CPUFREQ_POLICY_POWERSAVE) ||
> +			(policy->governor &&

Indentation is messed up.

> +				!strncmp(policy->governor->name, "powersave",

KVM should not be comparing magic strings.  If the cpufreq subsystem can't get
policy->policy right, then that needs to be fixed.

> +					CPUFREQ_NAME_LEN)))
> +			powersave = true;
> +		cpufreq_cpu_put(policy);
> +	}
> +	return ((vcpu->arch.msr_kvm_poll_control & 1) == 0) || powersave;

Doing all of the above work if polling is disabled is silly.

>  }
>  EXPORT_SYMBOL_GPL(kvm_arch_no_poll);

All in all, _if_ we want to do this automatically and not let userspace decide how
to manage powersave vs. halt-poll, I think this should be more like:

---
 virt/kvm/kvm_main.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e30f1b4ecfa5..01116859cb31 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -29,6 +29,7 @@
 #include <linux/file.h>
 #include <linux/syscore_ops.h>
 #include <linux/cpu.h>
+#include <linux/cpufreq.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/stat.h>
@@ -3483,6 +3484,23 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 	}
 }
 
+static bool kvm_cpufreq_no_halt_poll(struct kvm_vcpu *vcpu)
+{
+	struct cpufreq_policy *policy;
+	bool powersave = false;
+
+	preempt_disable();
+
+	policy = cpufreq_cpu_get(vcpu->cpu);
+	if (policy) {
+		powersave = (policy->policy == CPUFREQ_POLICY_POWERSAVE);
+		cpufreq_cpu_put(policy);
+	}
+
+	preempt_enable();
+	return powersave;
+}
+
 /*
  * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
  * polling is enabled, busy wait for a short time before blocking to avoid the
@@ -3491,7 +3509,8 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
  */
 void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 {
-	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
+	const bool halt_poll_allowed = !kvm_arch_no_poll(vcpu) &&
+				       !kvm_cpufreq_no_halt_poll(vcpu);
 	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
 	ktime_t start, cur, poll_end;
 	bool waited = false;

base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 

