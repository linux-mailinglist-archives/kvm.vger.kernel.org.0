Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABACA6D713D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236592AbjDEA0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbjDEA0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:26:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C273A4686
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:26:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3-20020a250b03000000b00b5f1fab9897so33879848ybl.19
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680654371;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7nmekayv4SH0rSzad1MWQ/D12tu4qT2henSiDZHgO0k=;
        b=F8myf2Vk5oC+wfqXzA+dbw6vKDjJcFQrVY+T9nS3zKGAM/fnAYbaYPzlSa3APE4GKI
         Us+ZIKQPuxrHRhIPV4Mzr2UVC6DPG+JqRYq2Scpqm81tE87jqBg2pe4d5DKZZyZvoOO3
         Yc8I/k1VlrrxVzYn+GBDlQOYTxM/kra4Rd8KdsQk528etR9zMkwWB6pRtMM7ep3lY2Dz
         KUN5DSnpJX7VlsUuEj7awsm8jjWxEjyIlB2FzFjXrQQMmJifEQVA1ASHyiB4Q51YH6hY
         WnzXUXzCLQaklydceakKhaTu1IvdZcWj8vK0ZFy59x14+R38+vDc5csEPfCCZRQ47eJZ
         2bxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680654371;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7nmekayv4SH0rSzad1MWQ/D12tu4qT2henSiDZHgO0k=;
        b=GPkZBxzwQ4uBS2Rhkq2RbTivymEhIC/K6tG347fLDVdvr6mFzzcgJyyFZXspuHpEgy
         NjhtxS6xL84hiWN6SHoRgq7x1lMkbgAmsgjrnSmX4nh1wLlTmTEBv2rZYkC2GuCCivmo
         Ku9sTRiAnYyXiXxgB2GsMtorZdwhRM5Xn2BR9/z1op+q0wB8lvoqoWE27f/16AjnPrFv
         Vj5U+Jc6s3eoWwY1xB5JVuAjBKpZnvlxBKlzjMgxz6lf77iBc3WfJExkN3KwB7rTxHXB
         y8IxDwtIyg+cS/Vy2pNo2syeuTrdWbt0jcJkeAs3XB6077Lo8J8+QKFRK2SJIh8WmNX9
         dKrA==
X-Gm-Message-State: AAQBX9dXNOxlCfnq4gtbs/OGaTwRNzMf+DpZFHLvflMzpfims4gSoX2e
        hkZRoCUKdm2ZHjUdHRXnA8K1SkkypEc=
X-Google-Smtp-Source: AKy350Zrca+kTf8uAmn8KwWlRlkThBg9VVg3KUirIvr13awIBm+8dbSPPIlv9RIoOYVBfSdL1NPe+65QX10=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:73c6:0:b0:b78:1b26:a642 with SMTP id
 o189-20020a2573c6000000b00b781b26a642mr2634832ybc.1.1680654371045; Tue, 04
 Apr 2023 17:26:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:26:08 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405002608.418442-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated
 permission faults
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If CR0.WP may be guest-owned, i.e. TDP is enabled, refresh the MMU's
snapshot of the guest's CR0.WP prior to checking for permission faults
when emulating a guest memory access.  If the guest toggles only CR0.WP
and triggers emulation of a supervisor write, e.g. when KVM is emulating
UMIP, KVM may consume a stale CR0.WP, i.e. use stale protection bits
metadata.

Reported-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lkml.kernel.org/r/677169b4-051f-fcae-756b-9a3e1bb9f8fe%40grsecurity.net
Fixes: fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owned bit")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h     | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 89f532516a45..92d5a1924fc1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -113,6 +113,8 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
+void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *mmu);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
@@ -153,6 +155,24 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->root_role.level);
 }
 
+static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+						    struct kvm_mmu *mmu)
+{
+	/*
+	 * When EPT is enabled, KVM may passthrough CR0.WP to the guest, i.e.
+	 * @mmu's snapshot of CR0.WP and thus all related paging metadata may
+	 * be stale.  Refresh CR0.WP and the metadata on-demand when checking
+	 * for permission faults.  Exempt nested MMUs, i.e. MMUs for shadowing
+	 * nEPT and nNPT, as CR0.WP is ignored in both cases.  Note, KVM does
+	 * need to refresh nested_mmu, a.k.a. the walker used to translate L2
+	 * GVAs to GPAs, as that "MMU" needs to honor L2's CR0.WP.
+	 */
+	if (!tdp_enabled || mmu == &vcpu->arch.guest_mmu)
+		return;
+
+	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
+}
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
@@ -184,8 +204,12 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
 	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
 	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
-	bool fault = (mmu->permissions[index] >> pte_access) & 1;
 	u32 errcode = PFERR_PRESENT_MASK;
+	bool fault;
+
+	kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
+
+	fault = (mmu->permissions[index] >> pte_access) & 1;
 
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4c874d4ec68f..47269d50e98d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5186,6 +5186,21 @@ static union kvm_cpu_role kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
 	return role;
 }
 
+void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *mmu)
+{
+	const bool cr0_wp = kvm_is_cr0_bit_set(vcpu, X86_CR0_WP);
+
+	BUILD_BUG_ON((KVM_MMU_CR0_ROLE_BITS & KVM_POSSIBLE_CR0_GUEST_BITS) != X86_CR0_WP);
+	BUILD_BUG_ON((KVM_MMU_CR4_ROLE_BITS & KVM_POSSIBLE_CR4_GUEST_BITS));
+
+	if (is_cr0_wp(mmu) == cr0_wp)
+		return;
+
+	mmu->cpu_role.base.cr0_wp = cr0_wp;
+	reset_guest_paging_metadata(vcpu, mmu);
+}
+
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* tdp_root_level is architecture forced level, use it if nonzero */

base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393
-- 
2.40.0.348.gf938b09366-goog

