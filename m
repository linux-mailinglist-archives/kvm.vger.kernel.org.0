Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81FD4D5D58
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 09:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbiCKIbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 03:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiCKIbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 03:31:10 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF7D1B45FD;
        Fri, 11 Mar 2022 00:30:07 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 9so7116795pll.6;
        Fri, 11 Mar 2022 00:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gDqiN5pf4YDkXe9dP0rfveBOw3P+FW2+px95EQefoNY=;
        b=AZEZcXX6nMsaAwas+IdJHLE7pZOp4Ov+sL7IwkhOxtxDJQfEFh0cgmGklog0Sm7tRP
         E3yk44onMe7eFe037XDU2MyVeqiV/ide7lkKskpnZ0k51oBxaCVZ6A0oVGBZ6z89F0dt
         aa8g5wl5qsI+hQcDSS1PDktAOOlpMxPBunZUaOTbYab468G1CrUwy5Ab2d1LhgT3Jeom
         d6Hx6DPWZvYHqcx8n4mncACAZKZvzDAzsgioKeah6ZWYEZPdubWNNpLm/ENzF+t4kM1a
         Ne5yFHm/FxO3kC1S6+6mc5njSf74/nsmqzkKTRSVsQipQbWugRkIjPbpMKEoTnsyem1K
         2N1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gDqiN5pf4YDkXe9dP0rfveBOw3P+FW2+px95EQefoNY=;
        b=pq19kadIZVMjGIMhXmM4nzp3yebaKcRN+sXogkEL4WglDvvr2PqlWrdGjiEBx0td6a
         SLe0ilubbrMzluh3rLW+iKD2qY9JYtCu+6lrJiYAUBiNk5Kk+Wj57E2+WHn39TiQQMmh
         BmosAl5/ryRKfkGlVgUDU4B5XnOCr5KdGtxsZKXjXE+FlxcVWTNOIrXQhH7UvJbyTZf3
         dQIG2dyvN2btDxOrQX4TmLra6lWe8YwA97+Qp0Wm6LYUSFE9P0q/kqa+BfKVvCQvHdzP
         CpzalnoUuoMY3RHYfwZrH+Pz4ZzihjBzOcmTNnXiektto5vi72AJ91Gvw8jsvSyODfRv
         abXQ==
X-Gm-Message-State: AOAM533Reha0H0uA3wwkNCMTh8uf9bwO3/pPer8Ml2SyHnhoEtY6kudL
        Ddj2zlI/mNLxX4uSLECoENXeYWNkklA=
X-Google-Smtp-Source: ABdhPJxF+HbhIh7uRDvBNu9loK5OTQP9MoDFZkm1ntli+DYFDfjHUae21ehsfZ2ba2ViD332ECJXTQ==
X-Received: by 2002:a17:90b:4595:b0:1be:db22:8327 with SMTP id hd21-20020a17090b459500b001bedb228327mr20604506pjb.99.1646987406951;
        Fri, 11 Mar 2022 00:30:06 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id l1-20020a17090aec0100b001bfa1bafeadsm9090576pjy.53.2022.03.11.00.30.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:30:06 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/5] KVM: X86: Add MSR_KVM_PREEMPT_COUNT support
Date:   Fri, 11 Mar 2022 00:29:10 -0800
Message-Id: <1646987354-28644-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
References: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

x86 preempt_count is per-cpu, any non-zero value for preempt_count
indicates that either preemption has been disabled explicitly or the 
CPU is currently servicing some sort of interrupt. The guest will 
pass this value to the hypervisor, so the hypervisor knows whether 
the guest is running in the critical section.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h      |  6 +++++
 arch/x86/include/uapi/asm/kvm_para.h |  2 ++
 arch/x86/kvm/x86.c                   | 35 ++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f72e80178ffc..50f011a7445a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -856,6 +856,12 @@ struct kvm_vcpu_arch {
 
 	u64 msr_kvm_poll_control;
 
+	struct {
+		u64 msr_val;
+		bool preempt_count_enabled;
+		struct gfn_to_hva_cache preempt_count_cache;
+	} pv_pc;
+
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
 	 * more of the PTEs used to translate the write itself, i.e. the access
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..f99fa4407604 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -36,6 +36,7 @@
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
+#define KVM_FEATURE_PREEMPT_COUNT	18
 
 #define KVM_HINTS_REALTIME      0
 
@@ -58,6 +59,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_PREEMPT_COUNT	0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 51106d32f04e..af75e273cb32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1456,6 +1456,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
+	MSR_KVM_PREEMPT_COUNT,
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSC_DEADLINE,
@@ -3433,6 +3434,25 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
+static int kvm_pv_enable_preempt_count(struct kvm_vcpu *vcpu, u64 data)
+{
+	u64 addr = data & ~KVM_MSR_ENABLED;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.pv_pc.preempt_count_cache;
+
+	vcpu->arch.pv_pc.preempt_count_enabled = false;
+	vcpu->arch.pv_pc.msr_val = data;
+
+	if (!(data & KVM_MSR_ENABLED))
+		return 0;
+
+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, sizeof(int)))
+		return 1;
+
+	vcpu->arch.pv_pc.preempt_count_enabled = true;
+
+	return 0;
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	bool pr = false;
@@ -3652,6 +3672,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_PREEMPT_COUNT:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PREEMPT_COUNT))
+			return 1;
+
+		if (kvm_pv_enable_preempt_count(vcpu, data))
+			return 1;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3992,6 +4020,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+	case MSR_KVM_PREEMPT_COUNT:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PREEMPT_COUNT))
+			return 1;
+
+		msr_info->data = vcpu->arch.pv_pc.msr_val;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -11190,6 +11224,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
+	vcpu->arch.pv_pc.preempt_count_enabled = false;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
-- 
2.25.1

