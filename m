Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63906FB426
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbjEHPqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbjEHPqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:46:30 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886979EE4
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:46:16 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50bc1612940so8902213a12.2
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560775; x=1686152775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b062hKlu11ozPjzQ3nUPfYzQg304FNVr6n23/8qMZEo=;
        b=IiKf5Xa9w7mL+0vtGPYsvdbZfZ+TTlhlKuWqSHIGZME0XynCfZuqmd0cPadE7QfoPD
         /TP/t+Qm75iiADjsjny+WUCEmBl+kesNIMQMLV1P/WeLojGZGDbBnNcSd50KFBVTPpOH
         L/EWiUTbtxCNZ2PW7nc4iYXVryl7WVz9fPslMS86va4pJ3oJewPVfiX2TwfqLBRHZo4C
         Dsq7loXYmBFRVKqDBSRdCsmKuB871UVMPkS07HgsjG8aazPQZJr5G+PrMi/SS68A6sLt
         cpwRG/gRgCdEPxJNNeQ7lheYSnTGfqapEw3MA3uW0OHSD8a8hobw+s1TpfXfBXkki/MB
         kM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560775; x=1686152775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b062hKlu11ozPjzQ3nUPfYzQg304FNVr6n23/8qMZEo=;
        b=J3jkst/QMFhTP5QJOgfGHZ89AuY52AL093CbR3doaZ684ZTvvS4Rzht5GAP9GU0yLt
         lHQqLhZ2yvvitpMlq49sJMOrSCixD31UOZOvqDQHFA51vRL9TwcbuiQ4VjOMXJH8NcMI
         GfFIwTeMszh+gOZBRdxP8HsR/u24zHi+pgPBZmCdPMC2b1hIrOnbK9uqYL9ot089fihm
         ssmrtI6LyhZ5Vn8HUg5SExFrIbiAo8x3kDZZL3S7oy01BZNvnVDu3+kpwP+lyT4eqick
         SVeSg4x+lzNZZ4F9fM92LBIrn5xoOt8Xz7WVJDbOqCjb4Yqdek+P3NzqKBZzp1Ph/J4v
         jhfw==
X-Gm-Message-State: AC+VfDxz6zQqNci5LFD+mjr7j3tdOW31mVGpJOYxQMNIlnA3pLjupXi/
        g8NJpRjF+VyrSfjF2SybxSddrQ==
X-Google-Smtp-Source: ACHHUZ6Y9zCCzrv9JIgBOKkIm6WzkofMrdtZEI0JsTjMzIraRxY497y9MGLULe4X6L9/Pp4Gk8ittQ==
X-Received: by 2002:aa7:d8c7:0:b0:50c:160d:f652 with SMTP id k7-20020aa7d8c7000000b0050c160df652mr8487675eds.8.1683560774942;
        Mon, 08 May 2023 08:46:14 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id j19-20020aa7ca53000000b0050bc27a4967sm6213551edt.21.2023.05.08.08.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:46:14 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.1 5/5] KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults
Date:   Mon,  8 May 2023 17:46:02 +0200
Message-Id: <20230508154602.30008-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154602.30008-1-minipli@grsecurity.net>
References: <20230508154602.30008-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v6.1.x
---
 arch/x86/kvm/mmu.h     | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..59804be91b5b 100644
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
index f2a10c7d1369..230108a90cf3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5005,6 +5005,21 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
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

