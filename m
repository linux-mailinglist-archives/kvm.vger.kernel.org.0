Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000274EE99A
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344240AbiDAINT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344245AbiDAIMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:12:53 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7431A20289E;
        Fri,  1 Apr 2022 01:11:03 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t13so1830191pgn.8;
        Fri, 01 Apr 2022 01:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hK83t9f5HQafaC7imUrsohagDN5P+WqmTJrwFOTNByc=;
        b=Hb6r8iUYn8KML/e3dSFoz16o8xys6lniHfXomQc7/yT4DWbu5qjMiryK/nOqoLHoLq
         UhXmoPl+BYg/pxxI6oMFRGMXCzvt+8Y79P0tUkOT+YfFTDoP8rDL78C4nOzoRV2+Zwgg
         OoFU/k/oRz7YWAAYTXZDbP/MkMIT/pptQim9O2JUG3p7QId+Sn5QfwiDSPgM1dDY5x2l
         7rAYw2pbQiuKfRpL/l+BDqOEz4hc4925PV5TC7s+1fMbCUTMLAmitYFOEKzZoy9xlMjh
         vEOJTaAUm3aB9vn1RCRT0La/nqqdWu3//GxBCJIqyBIX16VdVwuEXdNHjvS15ia2Sz4R
         62sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hK83t9f5HQafaC7imUrsohagDN5P+WqmTJrwFOTNByc=;
        b=CK5YC3EMGFUiOYcYRQoQ2OoIwJVpVI805mwZUtrG+KrbozFN6dj5mJi9cX3WCR2Nb3
         kSkZU6cKFfij2hYpBHnDHkQ2TO2GaSowG7MP8On3UF/B7hnoprN1cXw8C8awK1qVsPG7
         gy5u1Ql3zJThKihIu9/sNPDBT3+UJhR0fUIxpR2z8XloMjA5PpVB4lVmQWdPDpEuqLvq
         kR8f2xpcjTpVpBxBdGTVjvW9qxlSmJwzUBpRjl5yE9fTjEqzg8trdypEv8hlz3D1nmrc
         WbyBMoVUHbX0gMYoorriJ01fnAHxD4FcRuJDzRHySfEHy6lXBeoMS4iTfEKvldrdX21y
         0rkQ==
X-Gm-Message-State: AOAM532hkZ0C5Iz1LkqmHs1V2Hw3US1cn6RkxRWFIMSnq5o9qEdZTvvr
        +L01clDfrdllKzw4tJdIpIlRQCcQnWs=
X-Google-Smtp-Source: ABdhPJx1q466naYnenpZZ56jSDgSLsGsCKFBLwHKaYWeEED5WjcSsFf+UQx3As/Us+l+D7MJ5Mu+Ig==
X-Received: by 2002:a05:6a00:114e:b0:4c8:55f7:faad with SMTP id b14-20020a056a00114e00b004c855f7faadmr9781149pfm.86.1648800662811;
        Fri, 01 Apr 2022 01:11:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id hg5-20020a17090b300500b001c795eedcffsm11634790pjb.13.2022.04.01.01.11.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Apr 2022 01:11:02 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 1/5] KVM: X86: Add MSR_KVM_PREEMPT_COUNT support
Date:   Fri,  1 Apr 2022 01:10:01 -0700
Message-Id: <1648800605-18074-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
References: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
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
index 4138939532c6..c13c9ed50903 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -852,6 +852,12 @@ struct kvm_vcpu_arch {
 
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
index 02cf0a7e1d14..f2d2e3d25230 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1456,6 +1456,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
+	MSR_KVM_PREEMPT_COUNT,
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSC_DEADLINE,
@@ -3442,6 +3443,25 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
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
@@ -3661,6 +3681,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4001,6 +4029,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
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
@@ -11192,6 +11226,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
+	vcpu->arch.pv_pc.preempt_count_enabled = false;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
-- 
2.25.1

