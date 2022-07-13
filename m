Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3122357365D
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiGMM0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiGMMZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:54 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA41D1EF7;
        Wed, 13 Jul 2022 05:25:44 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f11so9417034pgj.7;
        Wed, 13 Jul 2022 05:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XsanBgHWAtIbJ++WDURz73dEqP2UMuYGIlKVLnPoouk=;
        b=Y5hdn3XjAkLtN0bs7hF/F+rLM8h7uAY3iIqtdnZTtnmpLwDa1I0L/T57cs+IgRuUdk
         +ZfRnyXvezchBsjiVlEbTYL9JeMsEpNNUHLVhcCHjuf5fwfySPyzsSMbDjSGH4vpoyBG
         Y/qC1fT7kaFG5aN1DpErYK4ZEzPJN8NzdX3SnvFrZ2bXQg71ZPAplpsdjQqV0Zm6aFX+
         AYAikFHsCAH617zxsJKiweYcpy9vpCkjfeiwMkzZ+nwNBoyHAr0R0Q8qw4FbG0W5Sz1q
         Xx4v4htHtQpgC4zIxvC4sSQhADYe2koLNMhq7JiddNIX8VVv8nOvmlkvV1X4tEL7V2na
         ZWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XsanBgHWAtIbJ++WDURz73dEqP2UMuYGIlKVLnPoouk=;
        b=BmeQ7yCQiwRYW1eDhsO4LaswhM75trkcZaaHulf6q41n5bMkmvgVfEFb/VNP4nXe7o
         EtB5Z9SBZzL7A96UFCM02TKskbq2PWBFy9OggLKjX4hddfgnhVEBTQ+iF5mqxDWNKnnf
         rUxVTdb8yL75bbxU0GWO8x7mmD4B9Sng4jek1ic5FzOHl8fg2enpwDFMPb+RG0a9Tp7N
         fMYMe1TApnXHzZ42LaLMQM4KyGRej1Jt2+/EcB2fWNhsmRWgbQ+rZn70Z3foWAMuBzXG
         DnO3pypQI/oQlmo/oRSV6gXvS2daDR+SVogupVXApDvpLwAtZ4f1Ertsvb0deQqAFpmg
         gBUQ==
X-Gm-Message-State: AJIora8DQmvLMF6TmcvANm81WnYSUkbkeN5CtVdgIir7Lq3MyefPst4c
        Xx6ASeAq8RrMvhZ+L7yWd8U=
X-Google-Smtp-Source: AGRyM1sm7IiaOrlOxLUkwk4IaSse3JCDRb0MdFl+laNBUvVoaf/bsCXrFGoueA2xDWSOwmDHME4nvg==
X-Received: by 2002:a63:100d:0:b0:411:8781:121a with SMTP id f13-20020a63100d000000b004118781121amr2681022pgl.583.1657715143218;
        Wed, 13 Jul 2022 05:25:43 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:42 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 7/7] KVM: x86/pmu: Defer counter emulated overflow via pmc->stale_counter
Date:   Wed, 13 Jul 2022 20:25:06 +0800
Message-Id: <20220713122507.29236-8-likexu@tencent.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713122507.29236-1-likexu@tencent.com>
References: <20220713122507.29236-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

There are contextual restrictions on the functions that can be called
in the *_exit_handlers_fastpath path, for example calling
pmc_reprogram_counter() brings up a host complaint like:

 [*] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
 [*] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 2981888, name: CPU 15/KVM
 [*] preempt_count: 1, expected: 0
 [*] RCU nest depth: 0, expected: 0
 [*] INFO: lockdep is turned off.
 [*] irq event stamp: 0
 [*] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 [*] hardirqs last disabled at (0): [<ffffffff8121222a>] copy_process+0x146a/0x62d0
 [*] softirqs last  enabled at (0): [<ffffffff81212269>] copy_process+0x14a9/0x62d0
 [*] softirqs last disabled at (0): [<0000000000000000>] 0x0
 [*] Preemption disabled at:
 [*] [<ffffffffc2063fc1>] vcpu_enter_guest+0x1001/0x3dc0 [kvm]
 [*] CPU: 17 PID: 2981888 Comm: CPU 15/KVM Kdump: 5.19.0-rc1-g239111db364c-dirty #2
 [*] Call Trace:
 [*]  <TASK>
 [*]  dump_stack_lvl+0x6c/0x9b
 [*]  __might_resched.cold+0x22e/0x297
 [*]  __mutex_lock+0xc0/0x23b0
 [*]  perf_event_ctx_lock_nested+0x18f/0x340
 [*]  perf_event_pause+0x1a/0x110
 [*]  reprogram_counter+0x2af/0x1490 [kvm]
 [*]  kvm_pmu_trigger_event+0x429/0x950 [kvm]
 [*]  kvm_skip_emulated_instruction+0x48/0x90 [kvm]
 [*]  handle_fastpath_set_msr_irqoff+0x349/0x3b0 [kvm]
 [*]  vmx_vcpu_run+0x268e/0x3b80 [kvm_intel]
 [*]  vcpu_enter_guest+0x1d22/0x3dc0 [kvm]

A new stale_counter field is introduced to keep this part of the semantics
invariant. It records the current counter value and it's used to determine
whether to inject an emulated overflow interrupt in the later
kvm_pmu_handle_event(), given that the internal count value from its
perf_event has not been added to pmc->counter in time, or the guest
will update the value of a running counter directly.

Opportunistically shrink sizeof(struct kvm_pmc) a bit.

Suggested-by: Wanpeng Li <wanpengli@tencent.com>
Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/pmu.c              | 15 ++++++++-------
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index de5a149d0971..4d85d189d082 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -489,7 +489,10 @@ enum pmc_type {
 struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
+	bool is_paused;
+	bool intr;
 	u64 counter;
+	u64 stale_counter;
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
@@ -498,8 +501,6 @@ struct kvm_pmc {
 	 * ctrl value for fixed counters.
 	 */
 	u64 current_config;
-	bool is_paused;
-	bool intr;
 };
 
 #define KVM_PMC_MAX_FIXED	3
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 681d3ac8d75c..b43561bd8daf 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -352,6 +352,12 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 		}
 
 		__reprogram_counter(pmc);
+
+		if (pmc->stale_counter) {
+			if (pmc->counter < pmc->stale_counter)
+				__kvm_perf_overflow(pmc, false);
+			pmc->stale_counter = 0;
+		}
 	}
 
 	/*
@@ -524,14 +530,9 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	u64 prev_count;
-
-	prev_count = pmc->counter;
+	pmc->stale_counter = pmc->counter;
 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
-
-	__reprogram_counter(pmc);
-	if (pmc->counter < prev_count)
-		__kvm_perf_overflow(pmc, false);
+	reprogram_counter(pmc);
 }
 
 static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f24613a108c5..e9c66dd659a6 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -290,7 +290,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 		struct kvm_pmc *pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = pmc->eventsel = 0;
+		pmc->counter = pmc->stale_counter = pmc->eventsel = 0;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5f6b9f596f16..ca4b55085c87 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -654,14 +654,14 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = pmc->eventsel = 0;
+		pmc->counter = pmc->stale_counter = pmc->eventsel = 0;
 	}
 
 	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
 		pmc = &pmu->fixed_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = 0;
+		pmc->counter = pmc->stale_counter = 0;
 	}
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
-- 
2.37.0

