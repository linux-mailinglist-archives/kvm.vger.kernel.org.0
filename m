Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C994B59E242
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358808AbiHWLyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358690AbiHWLw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:52:57 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C160D477C;
        Tue, 23 Aug 2022 02:33:03 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z187so12908188pfb.12;
        Tue, 23 Aug 2022 02:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=G7if3ijpIc8TnQSHWXh0LcgIPH6U4JE/8vWFIIr8OLI=;
        b=ATgMOrzq/UEEdAS5zLeMKcguyeiRDtrEpY6t6fu0f1aQVYBfeAK9KVeBR5vRRiNNu1
         3v6Yi9RvBCPhN7v2L0AfLEmE3WxAB6jOJvI92ZXaMXsMreZ+mQYaXC/wPVPI85rKkdJw
         07iIdK/otGFLxLmdCfPFVm+r+O0We7GqGBfMOH43piVN1KMSx90572wB335lezFCMGGv
         QeR6P+3aNs/MpcmvV2j6meKl7GHZhXndKjTQtHcgANEkSi17q3B4bmh61c6Mf09x2uhQ
         ajnbBJ2+3SHA9Qh8HqMfFFb4OiepwdPmRSVVm12Bv6coNJYgI2fGvUdVMU1qILvtO6nx
         dzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=G7if3ijpIc8TnQSHWXh0LcgIPH6U4JE/8vWFIIr8OLI=;
        b=Kmg2dmXUcpqL7pbYkjLVbpb2dSyWHhT/ftqi5qg5Hg1A28o418xdA790fkxpMj9tIa
         UKLRgJtRHX1MSVsOtlCL/XjbvX5OOXSPmL0GL9cJQz01pHd25q97ubXf6tyQ0CvrKhBy
         rsYadUZPHsI1PB/+IgexR4R7gDHEXsyc+MaaaTTIql+7ZQiwdjEh8xjjjgGKcOBMmGNI
         z06eprlx0vYAFy3GkYEfyNrWvm0WXTM10cjshGxv81E+LGOwob9X+xuSnG7vf6EcGqMa
         5vP1RSJ+eJMY6AlopCSjWSMztt7HnUKH/ITtHKZTNqlgdIBLIMJ+H00zyxh/GP+blLwA
         8r3g==
X-Gm-Message-State: ACgBeo0Samz1qD+FcDKwUAfQ/6TF8Y+Vpc+wEbdNhrNgA0ehzAY3FYKK
        YhI4pSQOsGLt3UI0SxX0JqA=
X-Google-Smtp-Source: AA6agR6aBUzNMOzQ/JKSPbAlZJui3XnUYekBLY/m5yG3qo12sPCWaxxOnwapLcT+jzSsHoR+BigRUw==
X-Received: by 2002:a63:fb4a:0:b0:429:8605:6ebf with SMTP id w10-20020a63fb4a000000b0042986056ebfmr19798586pgj.225.1661247175818;
        Tue, 23 Aug 2022 02:32:55 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:32:55 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH RESEND v2 6/8] KVM: x86/pmu: Defer counter emulated overflow via pmc->stale_counter
Date:   Tue, 23 Aug 2022 17:32:19 +0800
Message-Id: <20220823093221.38075-7-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823093221.38075-1-likexu@tencent.com>
References: <20220823093221.38075-1-likexu@tencent.com>
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
index 4e568a7ef464..ffd982bf015d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -488,7 +488,10 @@ enum pmc_type {
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
index 6940cbeee54d..45d062cb1dd5 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -350,6 +350,12 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
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
@@ -522,14 +528,9 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
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
index 6242b0b81116..42b591755010 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -647,14 +647,14 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
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
2.37.2

