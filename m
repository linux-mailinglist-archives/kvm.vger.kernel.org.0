Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4174E7498
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358796AbiCYOBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 10:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352923AbiCYOBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 10:01:01 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFEC5E75D;
        Fri, 25 Mar 2022 06:59:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so8413846pjq.2;
        Fri, 25 Mar 2022 06:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gDqiN5pf4YDkXe9dP0rfveBOw3P+FW2+px95EQefoNY=;
        b=kkYNqJpY8u9gDoA9DnmCRX7/62AGWobuqKlzAlcYN+uWXouh/BeH2tZLvpP1Pe5x8N
         odUpBRTSCOad2wiq7N7r6BVHd7Tq3kfkf1E02MNx4v1o6iot5eEohU3h2MArIvqoLUNO
         WEYzgPqODwFOQ94RBABFjlSNGNeRGTu6VPYltarL+8TlZXyC74qo2nKyoUnVDwakPW1v
         bgK6qRtDpIXuMhwsEByfEpza4BqRiySjBynWM/jG0csg6eMtKEosH73rYuew+iXlXyw8
         Dkt8JcgmXT3tshkJhLi3xirQ6/0pQ6HDHktRByei3kU53y6tGeytGASCqa3e86ICPyt5
         nkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gDqiN5pf4YDkXe9dP0rfveBOw3P+FW2+px95EQefoNY=;
        b=cgy9X8k9rGAq5k/iZsEGBSrlG+hsmnsGziCqJUfCX9jYhDdiL8pTynxpV+UWsFk4Cp
         jLfF0fFHu69qtJSuMeDtCgfvHJFZBwKPqv/Mj7eko2R7sbYS2XrD+jbUDRe4/qrhmmGP
         a4oIlASfLVYcbpot+rxWjGkpOaseavxmdBQWzfw3HGqzFxSycQ+b8yiikcSapBQcEZkm
         eFVXhDxJMpe2OY2QFePhwt3MRN17bclRENU/p3R2yfH7251fNs31Q4rIf5doeMIMcdbu
         L+uR+1Za1rGWstnIVwJ4Rm3XvrR6MDfo/EtTW9GQfKXvPifmTycexs1Yzwpe2Yv7Hk28
         yYeA==
X-Gm-Message-State: AOAM5324bCPH6u99iSnT8HmKOWienGgMvC/LFWcxQ3UqjU1cReOJComO
        eBr9aiEGFNwG4X+iHTPv9rMj3/EJEO0=
X-Google-Smtp-Source: ABdhPJz7rYWP7B/KvxYgG8AMv5MkxbfY9Bt+GYvPawceO5AABPa4vilU0dOYqMC6kplGuZmI2PtUzg==
X-Received: by 2002:a17:902:7888:b0:148:adf2:9725 with SMTP id q8-20020a170902788800b00148adf29725mr11724634pll.136.1648216767272;
        Fri, 25 Mar 2022 06:59:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id lw4-20020a17090b180400b001c7327d09c3sm14470875pjb.53.2022.03.25.06.59.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:59:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND 1/5] KVM: X86: Add MSR_KVM_PREEMPT_COUNT support
Date:   Fri, 25 Mar 2022 06:58:25 -0700
Message-Id: <1648216709-44755-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
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

