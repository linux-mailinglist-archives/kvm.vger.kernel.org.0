Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D95957C91F
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiGUKgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbiGUKgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:36:15 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06382ED5B;
        Thu, 21 Jul 2022 03:36:11 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l124so1366869pfl.8;
        Thu, 21 Jul 2022 03:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5qNMyDQo4A34X5plEKgK+lj9B4G4Lhqi9J4w62YEBQ=;
        b=VQgJk5LP1KoQKRSQ7nZK5snNyQzFtjY+59zuQGsgmtxJ7YSYAhq8wa6PAzyZhygGgT
         9Ri+R5jFLjcOvulBb3jQeAF1DMO4En1sm08q/hzxOSrYg2xXvvq3xk5YLBC52a3nLy61
         jVjYEu8U/WxBWurcLderJ0eIntNHvADuliKexijtlYG8rMgz9lDBY/XxT28fQ5kX4LsL
         eTMAeCkpbWj1cqFgEjBpjLOWei0lN/Rwm2dNZ34w0udB1KDKbeWDZIj3BvpIwn4CtsBt
         KCA6jVG+89d71UqXwXYjzam68Tam4efJnfozeKwoX1WEULQApeHtFpM7P83kAlfssyhZ
         LwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5qNMyDQo4A34X5plEKgK+lj9B4G4Lhqi9J4w62YEBQ=;
        b=M6htiC8I6+soFlCHGWdxl5j7a6VEssARL/HICAO6bxGQCXie9HX/YKi8zPhfmn5jpB
         6p2MLE68kpAqlRaUtBQ6eff/N8Mhi4mj0iyHAhZglUoLdXuUcxL8ZPDQ7OGcO4glNpcI
         isFbczr9KJYoergwvzd54HGypdhdN21TPWczYMl0WKzVREAw59MaoplVvwc9BjO7CKFm
         eiZcrqDIShrLRG7Tl9sbTnCPO3ItuxfbwF4mSvZojnCBVa8I9wDhGzizeGiMm52IlDlX
         FVxqyBoe9/Ck25yapjemNXbYFq9v4l6wKJk2+JZQscmV+Ao03V8veUJCo9nRWWURIIbE
         PfnA==
X-Gm-Message-State: AJIora9owhJaPCRBvyJVmsvvWgGOd+UF2sWU5Ih4ZCA0KQ43qXl71xwM
        nht75PHOmBTGkhOEJsKkLgg=
X-Google-Smtp-Source: AGRyM1vfdvl5vmayBovxnh4gAwflYBbqP4uXh++h+aebb2/OsssnTGPlG6s6MHI+2smXuKPMJVvgjQ==
X-Received: by 2002:a05:6a00:a12:b0:527:dba9:c416 with SMTP id p18-20020a056a000a1200b00527dba9c416mr43148134pfh.33.1658399771032;
        Thu, 21 Jul 2022 03:36:11 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a65494c000000b00419aa0d9a2esm1161887pgs.28.2022.07.21.03.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:36:10 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v2 7/7] KVM: x86/pmu: Defer counter emulated overflow via pmc->stale_counter
Date:   Thu, 21 Jul 2022 18:35:48 +0800
Message-Id: <20220721103549.49543-8-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220721103549.49543-1-likexu@tencent.com>
References: <20220721103549.49543-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 0295b763bd14..92f397361e3f 100644
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
index 97236b6cbe04..e3d9f2876081 100644
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
2.37.1

