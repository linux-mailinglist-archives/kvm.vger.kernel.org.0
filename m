Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08198663383
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbjAIVyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237669AbjAIVyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:54:06 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C94617070
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:54:05 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id w12-20020a5e970c000000b0070450f33abbso919643ioj.14
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MF+FfAxmoC6dFnj4ddByp++95c4ioR7dqQUFBF7r1tA=;
        b=KAaLiFLNSM2c203YeUTO7jF6xO8EhU/ISPtEeD5TD+CwxmpXoDhWvszR4cpvw0hbov
         XgSW91l2fld0hCkSrFubd+0ZVKstaNXvS2OObcyoZMl1C0Q/3091JKrAbJ1xtAzLYSZn
         +12PoMfix+0cqHZ0FWT6jhefdQ7qbQWxgqKSWvcydwnkGpi36ex064jnqxQXGcoagQED
         wmFS0SmXhsFi/MWc5uTsq9bPcd8HRE/fBqDCIg0Uxld930nL0GHYNBsLIKFAL0Dh45mN
         ipSG795V+G3ctkaDMs/fS4Zs7WckCYmyk7VP/PsR7QuY2Merv00NdFHgdLDlsW7DufCR
         jcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MF+FfAxmoC6dFnj4ddByp++95c4ioR7dqQUFBF7r1tA=;
        b=gKF1bEjPVbUK2nnCjSk/ZMamaoeCAqPL70gPCdzMGh6YOC7/M9c8eikQfRgC16MhLy
         cCO3hYyBAyWEx/Ypifk4iZTAINeAlonGS53uox9pJ8LhAPq5hB8PiecIAtP9RY/PoONw
         nhZI9Lc1W2kQuOkgx4uGtZYZskG5hUecbEPoThwStwsjhUdQApcAoWRZA1yjuSsCjFOO
         LhS/Qx/kzoGCmRWBr2/SAAYJpe7Qm6UxGaHqASxYSwhryjCSaqg/qIBneXkrbiH9U2og
         YPifMVKXPGxNGwuHt3QmfcfDSUheTad5iZYw+RhY9CM8gbB5FB+3p0QhGqOehL52qyiI
         QlCw==
X-Gm-Message-State: AFqh2kp3eqsIumL6wTIN6pQY4Yxpu9r5OEk+PNrFELvNQMLKbhhWa8HI
        +Sj6zcR0BgWsu+fVShVfmMwr2qtE6v51
X-Google-Smtp-Source: AMrXdXvsMsw3ht7evpmsM3wj6mrDWGrXj8WzBYsxkxo6YHxdcq+zXrV8iCa7YF2HBD1+Zwf/eh64SHJ4FoDT
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:cc4b:0:b0:375:c16b:7776 with SMTP id
 i11-20020a02cc4b000000b00375c16b7776mr6011988jaq.54.1673301244565; Mon, 09
 Jan 2023 13:54:04 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:53:43 +0000
In-Reply-To: <20230109215347.3119271-1-rananta@google.com>
Mime-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109215347.3119271-3-rananta@google.com>
Subject: [RFC PATCH 2/6] KVM: arm64: Add support for FEAT_TLBIRANGE
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define a generic function __kvm_tlb_flush_range() to
invalidate the TLBs over a range of addresses. Use
this to define  __kvm_tlb_flush_range_vmid_ipa()
(for VHE and nVHE) to flush a range of stage-2
page-tables using IPA in one go.

If the system supports FEAT_TLBIRANGE, the following
patches would conviniently replace global TLBI such
as vmalls12e1is in the map, unmap, and dirty-logging
paths with ripas2e1is instead.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   | 21 +++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/tlb.c       | 20 ++++++++++++++++++++
 4 files changed, 76 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43c3bc0f9544d..bdf94ae0333b0 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_range_vmid_ipa,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
@@ -221,10 +222,30 @@ DECLARE_KVM_NVHE_SYM(__per_cpu_end);
 DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
+#define __kvm_tlb_flush_range(op, mmu, start, end, tlb_level) do {		\
+	unsigned long pages, stride;						\
+										\
+	stride = PAGE_SIZE;							\
+	start = round_down(start, stride);					\
+	end = round_up(end, stride);						\
+	pages = (end - start) >> PAGE_SHIFT;					\
+										\
+	if ((!system_supports_tlb_range() &&					\
+	     (end - start) >= (MAX_TLBI_OPS * stride)) ||			\
+	    pages >= MAX_TLBI_RANGE_PAGES) {					\
+		__kvm_tlb_flush_vmid(mmu);					\
+		break;								\
+	}									\
+										\
+	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false);	\
+} while (0)
+
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
+extern void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t start,
+						phys_addr_t end, int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 728e01d4536b0..ac52d0fbb9719 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -116,6 +116,16 @@ static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
 	__kvm_flush_vm_context();
 }
 
+static void handle___kvm_tlb_flush_range_vmid_ipa(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
+	DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
+	DECLARE_REG(int, level, host_ctxt, 4);
+
+	__kvm_tlb_flush_range_vmid_ipa(kern_hyp_va(mmu), start, end, level);
+}
+
 static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -314,6 +324,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
+	HANDLE_FUNC(__kvm_tlb_flush_range_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f5896..292f5c4834d08 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -55,6 +55,30 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	}
 }
 
+void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t start,
+					phys_addr_t end, int level)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__kvm_tlb_flush_range(ipas2e1is, mmu, start, end, level);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	/* See the comment below in __kvm_tlb_flush_vmid_ipa() */
+	if (icache_is_vpipt())
+		icache_inval_all_pou();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 			      phys_addr_t ipa, int level)
 {
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 24cef9b87f9e9..2631cc09e4184 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -79,6 +79,26 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 	local_irq_restore(cxt->flags);
 }
 
+void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t start,
+					phys_addr_t end, int level)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__kvm_tlb_flush_range(ipas2e1is, mmu, start, end, level);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 			      phys_addr_t ipa, int level)
 {
-- 
2.39.0.314.g84b9a713c41-goog

