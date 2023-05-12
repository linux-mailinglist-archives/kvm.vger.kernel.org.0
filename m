Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376EE700914
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 15:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241226AbjELNUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 09:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241180AbjELNUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 09:20:46 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992C1273D
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:44 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-965e93f915aso1694915566b.2
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 06:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683897643; x=1686489643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EAj9+wwvvQBZb98iVWDhS9msbB+DvyCsfBWvAkxMn64=;
        b=DPoOZm5Rl64bijgyVluptsPFEFFd2ZcMbhjgo9kJtSubQHcsnAmp6mg9cld22TEP/k
         8gd0KwXkWIMvbu5SKWIzUOYciaRsxL+2TOIxqgAVw5OzjpBumNM0LKyA/Iz4/BgP9v5g
         cRamXKMEVGn7ScSVK2z3AzXDOogjtOJp6AYjoHcay1MzYt3b6/WVeisZdVVkTLzFxGwS
         KxgPjFvxXnljOSMUjf+7AGDzyk4kkZcm+NvQ43VY9/HnI8v43tCl/HyYtvAPanulIr/6
         yBPrW9tqsRHxJ58CGj3Frvsl2QE2YdOj55MCzBO3V0TevenREPNAThyR9ihB35fnNBUM
         T6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683897643; x=1686489643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EAj9+wwvvQBZb98iVWDhS9msbB+DvyCsfBWvAkxMn64=;
        b=WLuErH4Woi2jLlNXKu7540njUUB7mZ/IhGDQDzeu96/FybiIb1ndeW6bt4D+IYrIs2
         ob82DQQv/tfiwIIti3ClpPw6PrTpO/oIRNb/POIWfwxSaBFPZ3pDAifB/mvVc6eVtbR+
         wEPIWfQYFeC/5NuixyQg/fcN0JJIKFWbiLyRjaxZ+vqBI53xeeHUWR1tQvjl3Y3w7wik
         pgVTm8rK65ZLxJqQMJVzKXMx70IQbxA0iSdFC+fTTn1PvGNWO4HXXY78U8LyIuQ74hS7
         BJ7DztMKkBc05X8EwoxImglSCkdt76Z2Z7Mwfqfxt7/kYhw114Csh3JMFgXLgojE1Jzo
         6nEg==
X-Gm-Message-State: AC+VfDwQybs+YkoZO0aZr+OlXriNncBJa9ULxSQgAjnmnjcLGTzvv1SK
        27QNKd6dNm9aRUrffzTlmgqovw==
X-Google-Smtp-Source: ACHHUZ5Xdbv4TKYy6h0Rjoz+3eKhIg12ZBJAmVqbeZQ0LPWOkKCp5otUgJd7XKtatLLOz1txgOuE4A==
X-Received: by 2002:a17:907:720e:b0:966:5a6c:752d with SMTP id dr14-20020a170907720e00b009665a6c752dmr16587933ejc.20.1683897643124;
        Fri, 12 May 2023 06:20:43 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af43a100a78da3f586d44204.dip0.t-ipconnect.de. [2003:f6:af43:a100:a78d:a3f5:86d4:4204])
        by smtp.gmail.com with ESMTPSA id w21-20020a170907271500b00969dfd160aesm5077981ejk.109.2023.05.12.06.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 06:20:42 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.3 5/5] KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults
Date:   Fri, 12 May 2023 15:20:24 +0200
Message-Id: <20230512132024.4029-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230512132024.4029-1-minipli@grsecurity.net>
References: <20230512132024.4029-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit cf9f4c0eb1699d306e348b1fd0225af7b2c282d3 ]

Refresh the MMU's snapshot of the vCPU's CR0.WP prior to checking for
permission faults when emulating a guest memory access and CR0.WP may be
guest owned.  If the guest toggles only CR0.WP and triggers emulation of
a supervisor write, e.g. when KVM is emulating UMIP, KVM may consume a
stale CR0.WP, i.e. use stale protection bits metadata.

Note, KVM passes through CR0.WP if and only if EPT is enabled as CR0.WP
is part of the MMU role for legacy shadow paging, and SVM (NPT) doesn't
support per-bit interception controls for CR0.  Don't bother checking for
EPT vs. NPT as the "old == new" check will always be true under NPT, i.e.
the only cost is the read of vcpu->arch.cr4 (SVM unconditionally grabs CR0
from the VMCB on VM-Exit).

Reported-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lkml.kernel.org/r/677169b4-051f-fcae-756b-9a3e1bb9f8fe%40grsecurity.net
Fixes: fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owned bit")
Tested-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230405002608.418442-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v6.3.x
---
- substitute lack of kvm_is_cr0_bit_set() with the older
  kvm_read_cr0_bits()

 arch/x86/kvm/mmu.h     | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 168c46fd8dd1..0f38b78ab04b 100644
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
index 18c0deeaa2ec..d3812de54b02 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5121,6 +5121,21 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 	return role;
 }
 
+void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *mmu)
+{
+	const bool cr0_wp = !!kvm_read_cr0_bits(vcpu, X86_CR0_WP);
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
-- 
2.39.2

