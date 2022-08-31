Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EE25A797F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiHaIyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiHaIx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:53:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23160C9EA1;
        Wed, 31 Aug 2022 01:53:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q3so10270468pjg.3;
        Wed, 31 Aug 2022 01:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Gcm2IRQTqs+/zd8fZUOqHHTB6+RBczdToyXqQTmBoEc=;
        b=T18AiWlRi04ewNMzE3Y7uPaapmJYaFVOTjtOepcQ0GfIy5ouQQSw0g+ZIPHNsKtYhY
         RsaWxlAp8Q5/xOXeU0ivK0iyVuANRJkWGBRbxXoSK2cfYvKxgai8+ygd2x8vGm75Dopa
         ZlwCRI8vJZAnQv/CHGMXRXyAWp6lscAdj96d0EYXaJR+pvf2/k4TqRJo8422ucv5aEbH
         2GxByNR69DVz1HNAL09cPBsaSj/EBF8jFOtJa4ws+20gcQEKqvCymsca8UIykya78gRz
         eiZuK37lTxQ0VZd+DpDMwvDCmHL5t6zuLUYXH+alak34YSD8T/F5S260KyZzUOW6pKSL
         J37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Gcm2IRQTqs+/zd8fZUOqHHTB6+RBczdToyXqQTmBoEc=;
        b=WsKjj9ccdSqJEhXrQGQEGrXNNAj2TB251bpRaZ/1KXoDDun4kOC/JIV4TAF2U5uzoy
         a5DaaiDuPqdMo1hsrcceLlDu8i929QcUo31hnfQokx1IeTbsE6suHr3QQgM0qAOVI6aD
         EdPCgJ9T3lIT+bH8uag7E7ai0FXdWIWl04OjgS/2JnxFq3ilw/ZtvpUY4aqqdD+U6t8u
         ZlHCz03+3oTjkQa2xgQeDjxGJaPbYY1s5KG4aa7yvZLnHNgArR2V8IQPw7GzTxC6bM9l
         MHmcQi93JY6GutlbZ9Z5j27cssVu5JzF4bgwepU66RX9q8hF+ZjXEJq82FfGQROuUron
         feZQ==
X-Gm-Message-State: ACgBeo3Oo5uJdRFQdv1MZHVQ6nyeWUWxfnckdHwSb4eExrwxY7BSoDIC
        UEKabedIgEu72Vkx7j2Oyxo=
X-Google-Smtp-Source: AA6agR5/UBexJglfYrq5LHFgtkDhtnwSjNhhnXinG0hsWVHNVzgqRw6BCv+0Y1tb/ywYSdA1zWdQsw==
X-Received: by 2002:a17:90a:868c:b0:1fd:cfe8:5511 with SMTP id p12-20020a17090a868c00b001fdcfe85511mr2151436pjn.174.1661936035476;
        Wed, 31 Aug 2022 01:53:55 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b001fab208523esm868772pjk.3.2022.08.31.01.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:53:55 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v3 5/7] KVM: x86/pmu: Defer counter emulated overflow via pmc->prev_counter
Date:   Wed, 31 Aug 2022 16:53:26 +0800
Message-Id: <20220831085328.45489-6-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220831085328.45489-1-likexu@tencent.com>
References: <20220831085328.45489-1-likexu@tencent.com>
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

Defer reprogramming counters and handling overflow via KVM_REQ_PMU
when incrementing counters.  KVM skips emulated WRMSR in the VM-Exit
fastpath, the fastpath runs with IRQs disabled, skipping instructions
can increment and reprogram counters, reprogramming counters can
sleep, and sleeping is disallowed while IRQs are disabled.

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

Add a field to kvm_pmc to track the previous counter value in order
to defer overflow detection to kvm_pmu_handle_event() (reprogramming
must be done before handling overflow).

Opportunistically shrink sizeof(struct kvm_pmc) a bit.

Suggested-by: Wanpeng Li <wanpengli@tencent.com>
Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/pmu.c              | 13 ++++++-------
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4e568a7ef464..08c3f90b4ac3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -488,7 +488,10 @@ enum pmc_type {
 struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
+	bool is_paused;
+	bool intr;
 	u64 counter;
+	u64 prev_counter;
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
index 7f391750ebd3..3c42df3a55ff 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -349,6 +349,10 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 		}
 
 		reprogram_counter(pmc);
+
+		if (pmc->counter < pmc->prev_counter)
+			__kvm_perf_overflow(pmc, false);
+		pmc->prev_counter = 0;
 	}
 
 	/*
@@ -521,14 +525,9 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	u64 prev_count;
-
-	prev_count = pmc->counter;
+	pmc->prev_counter = pmc->counter;
 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
-
-	reprogram_counter(pmc);
-	if (pmc->counter < prev_count)
-		__kvm_perf_overflow(pmc, false);
+	kvm_pmu_request_counter_reprogam(pmc);
 }
 
 static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 70219c19b872..0166f3bc6447 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -290,7 +290,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 		struct kvm_pmc *pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = pmc->eventsel = 0;
+		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 863a6ff9e214..1d3d0bd3e0e7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -647,14 +647,14 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = pmc->eventsel = 0;
+		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
 	}
 
 	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
 		pmc = &pmu->fixed_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = 0;
+		pmc->counter = pmc->prev_counter = 0;
 	}
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
-- 
2.37.3

