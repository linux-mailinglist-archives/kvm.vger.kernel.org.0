Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A05E6E2976
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 19:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjDNR3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 13:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjDNR3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 13:29:34 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005EF76B4
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 10:29:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f8b46f399so101189597b3.10
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 10:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681493368; x=1684085368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6yXpQV1dyaIZNXVMPwYu1hFdV6Rbra8P0PHGUh6odQY=;
        b=BH+iDovlEdPlXeqFnQAwC3i/GbldXsEXVPPEleNqyMhYfztj3mdzkuLlpAM8js5DUN
         4U4peoDsgxG17FkNzwtjyxSL3WK1rPGjVyS5QvlEVrjLnJgBjRFxmmeYv457CmnZ8KDJ
         4mVIPXKqkjuU6lq6hbX+u7l+2lD2htHCU+DPKyG8N5n76kYehutWHFguGNaE0jRxQIg/
         LNATsfmPe+mliFpE/lIwk8FNYS5HccutpQOfwg0Re4I1wNzbCBkZh3zsds829lIrEx08
         dSdWCtgy7SccBWpxP6luF5aSag3jFs0zKj7ece2j/n4S47P7iOsVYZp3PKXG+V+EVjI2
         dZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493368; x=1684085368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6yXpQV1dyaIZNXVMPwYu1hFdV6Rbra8P0PHGUh6odQY=;
        b=TJm5clpwUIlGxREJWAZXSQm5ojDjl4ElgwSE3EfAIaFOTpvj2bRoAkj7FgzlMH9qDL
         ctrWBoMgevL5PcyhGgfp4ZEvCKcIkji9NjE+liLll/C3iOIsWT1n1/aMisISxE2Of7tE
         qWFWnUggxC26w3ZWltLpoQmidf976qPvys5w9DBHSDbIybBGdIKquVzPPQfAj0VvZy44
         7fQuSkfPSTDcVXwYx5E2nxPMJcWhBJJeiRc31ISEGJPdCPrNtiswlMFRq5Hz5cJjL7mt
         tqlWKOsBjhrIbQgi+Ob0Kks5JmvPb7u4dNSBGDJVICTmKO7xopHQV0JjzSFIwU88Hxfx
         +fKQ==
X-Gm-Message-State: AAQBX9e69hU4//JKEC1I2vhvClpmWTh2tSIqgSk0pmulVxnXyz/Qfpux
        FmT40yazRSZs/1TpmLT9ZXeO1lWAuwzD
X-Google-Smtp-Source: AKy350aJJ9Vbsc0RGRyarCzXp0LRIHsj2K5ceufsNwzluZRRFidFLTDVynELZbpYeTnaEMbB4S53iorRdTV9
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ed06:0:b0:541:693f:cdd1 with SMTP id
 k6-20020a81ed06000000b00541693fcdd1mr4258848ywm.9.1681493368275; Fri, 14 Apr
 2023 10:29:28 -0700 (PDT)
Date:   Fri, 14 Apr 2023 17:29:17 +0000
In-Reply-To: <20230414172922.812640-1-rananta@google.com>
Mime-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230414172922.812640-3-rananta@google.com>
Subject: [PATCH v3 2/7] KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
to flush a range of stage-2 page-tables using IPA in one go.
If the system supports FEAT_TLBIRANGE, the following patches
would conviniently replace global TLBI such as vmalls12e1is
in the map, unmap, and dirty-logging paths with ripas2e1is
instead.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c      | 39 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/tlb.c       | 35 +++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 43c3bc0f9544d..33352d9399e32 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
@@ -225,6 +226,8 @@ extern void __kvm_flush_vm_context(void);
 extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
+extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+					phys_addr_t start, phys_addr_t end);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 728e01d4536b0..81d30737dc7c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -125,6 +125,16 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
 }
 
+static void
+handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
+	DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
+
+	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, end);
+}
+
 static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
@@ -315,6 +325,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
+	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f5896..d2504df9d38b6 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -109,6 +109,45 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t start, phys_addr_t end)
+{
+	struct tlb_inv_context cxt;
+	unsigned long pages, stride;
+
+	/*
+	 * Since the range of addresses may not be mapped at
+	 * the same level, assume the worst case as PAGE_SIZE
+	 */
+	stride = PAGE_SIZE;
+	start = round_down(start, stride);
+	end = round_up(end, stride);
+	pages = (end - start) >> PAGE_SHIFT;
+
+	if (!system_supports_tlb_range() || pages >= MAX_TLBI_RANGE_PAGES) {
+		__kvm_tlb_flush_vmid(mmu);
+		return;
+	}
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
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
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 24cef9b87f9e9..f34d6dd9e4674 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -111,6 +111,41 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	__tlb_switch_to_host(&cxt);
 }
 
+void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
+				phys_addr_t start, phys_addr_t end)
+{
+	struct tlb_inv_context cxt;
+	unsigned long pages, stride;
+
+	/*
+	 * Since the range of addresses may not be mapped at
+	 * the same level, assume the worst case as PAGE_SIZE
+	 */
+	stride = PAGE_SIZE;
+	start = round_down(start, stride);
+	end = round_up(end, stride);
+	pages = (end - start) >> PAGE_SHIFT;
+
+	if (!system_supports_tlb_range() || pages >= MAX_TLBI_RANGE_PAGES) {
+		__kvm_tlb_flush_vmid(mmu);
+		return;
+	}
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
+
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(&cxt);
+}
+
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
-- 
2.40.0.634.g4ca3ef3211-goog

