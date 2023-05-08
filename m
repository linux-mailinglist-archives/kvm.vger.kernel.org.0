Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08A96FB416
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbjEHPpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbjEHPp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:45:26 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8362F9008
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:45:17 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so49927046a12.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560716; x=1686152716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YjFnTYTT0fhl3mFg3Lh3D1eOfp7jUv3/u7ma/pELifQ=;
        b=Z9ulQAP2QDZQkQVUDpF+2nBuMZvWQVHrw4rRMyiAqBvSjQCry0bE7/G3uXVr4LXTZc
         fTpEJB2QDZXiMVPJuKanheOnXlA6RDFIhwgP4/YgFUAKKoCMts0ssA+bx+V8DVBIjHbV
         xHwJRcgmrhYkfD3NNv5C7G+8hH+rLVbEZkh4Q2noGFRpoPBHwQQLVQtTESz9zfBMF50t
         cv1TJWpw2eO2zZMeyzL66elvekRQ4KMb9wntucU6NtII+LpXjHw/8xaavT16YZ8R4ZcQ
         6r6gvoZZ64X3jGLFAR+kYyQNNvuJB5KygSXl0Z+VLWcLeyA1TuA4tq4ixAt1H4vcrc7G
         MkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560716; x=1686152716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjFnTYTT0fhl3mFg3Lh3D1eOfp7jUv3/u7ma/pELifQ=;
        b=cuKZ92C3ga/mKhm9URgCuI403DL0GklQgrUk/wpH+c+3IXEnI4MDg+qu+zvWb6QCHb
         Aj1JdHWqYqFui8Y2MXAWLj3KvVaL2X17I7+LQEWty6lEDX/16wTYC+9AF9KWckaGswmK
         cbVFWfW+kosjARKITtfCuiHqXLudpw1FIDD3/01vUEG9T+7Ju8F08aaCBNM+QVbQhOMl
         pKC3qeajumajKO8BFUEvD5xtW3I9zRGuiQfng1lw9a7aP1vhsH+/HxZJVevaVBpjcLAb
         nfz9p/oG0+jLFVMzs+6TgJZrXJrL0xeGnwFAaF/YdkhVMr6coqkRgmZ/SlKH73uAy8yB
         a0xw==
X-Gm-Message-State: AC+VfDwhcmeFPn4fiB4hqPhyvuS8pAHO8bX/D16Ta7suFU166vDDdggS
        DmXuJRzN3cpG/y6FxdmHYRzLpQ==
X-Google-Smtp-Source: ACHHUZ6BUgQHKIzm0JgYCm79Bm+9D2wUh8Nft53SFDGTpx6L2RmslwNR6cq90bytYU70H8NGbNvV9g==
X-Received: by 2002:a17:906:730d:b0:959:b757:e49 with SMTP id di13-20020a170906730d00b00959b7570e49mr10132777ejc.1.1683560716035;
        Mon, 08 May 2023 08:45:16 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id kw3-20020a170907770300b0096621c999c6sm121758ejc.79.2023.05.08.08.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:45:15 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 6.2 5/5] KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults
Date:   Mon,  8 May 2023 17:44:57 +0200
Message-Id: <20230508154457.29956-6-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154457.29956-1-minipli@grsecurity.net>
References: <20230508154457.29956-1-minipli@grsecurity.net>
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v6.2.x
---
- substitute lack of kvm_is_cr0_bit_set() with the older
  kvm_read_cr0_bits()

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
index 2faea9e87362..ce135539145f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5047,6 +5047,21 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
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

