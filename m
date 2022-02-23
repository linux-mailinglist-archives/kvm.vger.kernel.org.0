Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322734C16E3
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbiBWPed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiBWPec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:34:32 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC8EB91F1
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 07:34:04 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 75so20303484pgb.4
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 07:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KMel7Fz8t8HlxJOCBu85KHEQ5yzL0wyZ+rcFmUgdy0E=;
        b=M+U0kyMPm3TH6C4hYPCfETqlvkW8OeZMDr3MxrOQKcgjjscL6+NhewFa3tmrV4kQS0
         oj6eVETfJCzUCfynDvnhaXpiYZVSoGOKyZITyS7u/4634W26YJutH6JmzKw2gvcnfgTt
         ukY1Ni2TWuisX7b8AAlkumyBIftwI/defLPa2zdsLed1VXMiYbTQkycANJf3f2i8RYlE
         8OAQABbUCX5Ed2MHQ/Jfu9lUEBicYuxysVoCopPyOzAQBiX6gcaLEYz81824sGa+6hnN
         DTgNrTUQY+Vg908seSlMrU+mxmOP0eiN9cys8KzmRSeK5hviuHI/Qdsh6+qtAo2v/uEr
         YrjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KMel7Fz8t8HlxJOCBu85KHEQ5yzL0wyZ+rcFmUgdy0E=;
        b=RMIbcN70pKGNbrUEAgnkbnztiQachC+m44awb+Mp+tEDb/7+hThLQ+mRvGBH3/ut/p
         vEvm1+kTAWAeKlpCbvrOdbjgGsxsOUyIscrbCEqyGUFDrL/cEtq4d6RYgoaUIqkuPUIb
         5SPvGfZA/C3EX9j4/ZjnDZSGI1k8tOHjy2k/KkKgg+LZcKIIadsDHV30sUj16vEQIM4C
         0353ZmV8F/aFEeqJEPA6ad7qW9j7ZabAFDQQKhngOr9tfvzAx/RpiOP9uFzhifKfguzj
         yghJqK0E70S2Doy0b9JYw9fUndIoEANV+KGdfF+pmXBTkwq03c+4NUY1uwZVTh3L8vFI
         0WeQ==
X-Gm-Message-State: AOAM5334Dw0zTSiDQf4VpmHK5zMIuY6qvRTipDJxQLLnvySuWm6Mvlyw
        wrtL2TJLIqyKnM2Ozq0KVxM=
X-Google-Smtp-Source: ABdhPJwoyjwr4QcmMC4pRtKeQOfjk0yapbRuUrL4W2UNSTw0Si5DrRoixfr0Vy9erLQ104mC2Yay5w==
X-Received: by 2002:a05:6a00:1251:b0:4f1:2a1:3073 with SMTP id u17-20020a056a00125100b004f102a13073mr317957pfi.72.1645630444036;
        Wed, 23 Feb 2022 07:34:04 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (115-64-212-59.static.tpgi.com.au. [115.64.212.59])
        by smtp.gmail.com with ESMTPSA id l14sm3271165pjz.32.2022.02.23.07.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 07:34:03 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH] KVM: PPC: Book3S HV: Update guest state entry/exit accounting to new API
Date:   Thu, 24 Feb 2022 01:33:52 +1000
Message-Id: <20220223153352.2590602-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
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

Update the guest state and timing entry/exit accounting to use the new
API, which was introduced following issues found[1]. KVM HV does not
seem to suffer from those issues listed, but it does call srcu inside
the guest context which is fragile at best. The new API allows guest
entry timing to be de-coupled from state entry.

Change to the new API, move the srcu_read_lock/unlock outside the guest
context, move tracing related entry/exit together with the guest state
switches, and extend timing coverage out to include the secondary thread
gathering in the P7/8 path.

[1] https://lore.kernel.org/lkml/20220201132926.3301912-1-mark.rutland@arm.com/

Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
KVM PR and BookE possibly have more issues (like taking host interrupts
in guest context) but look harder to fix.

Thanks,
Nick

 arch/powerpc/kvm/book3s_hv.c | 39 ++++++++++++------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 84c89f08ae9a..4f0915509dbb 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3683,6 +3683,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		return;
 	}
 
+	guest_timing_enter_irqoff();
+
 	kvmppc_clear_host_core(pcpu);
 
 	/* Decide on micro-threading (split-core) mode */
@@ -3812,23 +3814,15 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	for (sub = 0; sub < core_info.n_subcores; ++sub)
 		spin_unlock(&core_info.vc[sub]->lock);
 
-	guest_enter_irqoff();
-
 	srcu_idx = srcu_read_lock(&vc->kvm->srcu);
 
+	guest_state_enter_irqoff();
 	this_cpu_disable_ftrace();
 
-	/*
-	 * Interrupts will be enabled once we get into the guest,
-	 * so tell lockdep that we're about to enable interrupts.
-	 */
-	trace_hardirqs_on();
-
 	trap = __kvmppc_vcore_entry();
 
-	trace_hardirqs_off();
-
 	this_cpu_enable_ftrace();
+	guest_state_exit_irqoff();
 
 	srcu_read_unlock(&vc->kvm->srcu, srcu_idx);
 
@@ -3863,11 +3857,10 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	kvmppc_set_host_core(pcpu);
 
-	context_tracking_guest_exit();
 	if (!vtime_accounting_enabled_this_cpu()) {
 		local_irq_enable();
 		/*
-		 * Service IRQs here before vtime_account_guest_exit() so any
+		 * Service IRQs here before guest_timing_exit_irqoff() so any
 		 * ticks that occurred while running the guest are accounted to
 		 * the guest. If vtime accounting is enabled, accounting uses
 		 * TB rather than ticks, so it can be done without enabling
@@ -3876,7 +3869,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		 */
 		local_irq_disable();
 	}
-	vtime_account_guest_exit();
+	guest_timing_exit_irqoff();
 
 	local_irq_enable();
 
@@ -4520,33 +4513,28 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	__kvmppc_create_dtl_entry(vcpu, pcpu, tb + vc->tb_offset, 0);
 
-	trace_kvm_guest_enter(vcpu);
-
-	guest_enter_irqoff();
-
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 
+	trace_kvm_guest_enter(vcpu);
+	guest_timing_enter_irqoff();
+	guest_state_enter_irqoff();
 	this_cpu_disable_ftrace();
 
-	/* Tell lockdep that we're about to enable interrupts */
-	trace_hardirqs_on();
-
 	trap = kvmhv_p9_guest_entry(vcpu, time_limit, lpcr, &tb);
 	vcpu->arch.trap = trap;
 
-	trace_hardirqs_off();
-
 	this_cpu_enable_ftrace();
+	guest_state_exit_irqoff();
+	trace_kvm_guest_exit(vcpu);
 
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 
 	set_irq_happened(trap);
 
-	context_tracking_guest_exit();
 	if (!vtime_accounting_enabled_this_cpu()) {
 		local_irq_enable();
 		/*
-		 * Service IRQs here before vtime_account_guest_exit() so any
+		 * Service IRQs here before guest_timing_exit_irqoff() so any
 		 * ticks that occurred while running the guest are accounted to
 		 * the guest. If vtime accounting is enabled, accounting uses
 		 * TB rather than ticks, so it can be done without enabling
@@ -4555,7 +4543,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 		 */
 		local_irq_disable();
 	}
-	vtime_account_guest_exit();
+	guest_timing_exit_irqoff();
 
 	vcpu->cpu = -1;
 	vcpu->arch.thread_cpu = -1;
@@ -4575,7 +4563,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
 		kvmppc_core_dequeue_dec(vcpu);
 
-	trace_kvm_guest_exit(vcpu);
 	r = RESUME_GUEST;
 	if (trap) {
 		if (!nested)
-- 
2.23.0

