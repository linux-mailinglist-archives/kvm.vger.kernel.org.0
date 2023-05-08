Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECC46FB457
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbjEHPt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbjEHPtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:49:12 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9E5AD26
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:48:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-94ef0a8546fso757195466b.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560907; x=1686152907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9sfiCmAl7MFuZIKET6VHP2k7SLxPKw23VxB9Fd66Jg=;
        b=BpJm4ohGshjhdYMt8BEDRG54maOqplzKVQ/M+1e5Tc89Hi+j10QKZxil9EjtWBVUg0
         8NNqXcfDTH0eMhwS+IdSNlnjUtmwuHmdj6Xvx9oQRpzCoYA8nLyHSpbsX76xcy8hJYqk
         kOKZrRt2CFbQSyajMXyBKhq71DdjKU0CKiHLFwbj3KEXENA9Tl/yahgMQ6khx0rT/Fg6
         wo51pgCaIOqNwcIlpoHe+NNl6fKGcAJPyNETtmge8yF2gpchTL8NTn/JgsB6x8M3D1sJ
         67pOFJccOUtsC6GtXN2in/BrGMDTvVdKczK1EtmSSCtMhkaloNEHTJZqCj58Wg1DBwE2
         aNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560907; x=1686152907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z9sfiCmAl7MFuZIKET6VHP2k7SLxPKw23VxB9Fd66Jg=;
        b=O9/J1pE1FQHhqEqjdqBdz+ViM0uR7Y+5SjJNDyeeT8YTatpes13BvRWoOcZO8sm/Rl
         log4mSV0IFTA6m529KpbWj3bNvozxn/rB9KRAiLE5PKeXQp58j24WzZVLuoEJzdTS41E
         GMWbXoT/oB7U4XZzD5+qfBekde6HhpMRMxTqzUM8+3cYCItJBjXs+GfHhXbb+1HihtrG
         mDU/ULSbPfsuEfWS6xpl4vXlEBnH2X8k86adR4gItJgwAz31SGXs+uWrsHDpViEukT6Y
         9hMGNWsT/K/GAwKYYTWT8KIZsFr/1IN+cWpmg2BqbubF5gqhl50s+4/Y9y5600RWuX5y
         j9Yw==
X-Gm-Message-State: AC+VfDx8ITOTbRBtakpHqTHed950KoyeWMB2YZvy1o20k0m0CevznU4Y
        k8YwTrsiyM3kqvyelruiQtl8EQWMr+1ojy/OTxbiuA==
X-Google-Smtp-Source: ACHHUZ7wX1X2xBZTjrBM0/PQWLXDNKwfEZ0sT29rjATHzhr5Lcx3srVS4wv/eRPpTtL+xGEvvhnFkA==
X-Received: by 2002:a17:907:36c6:b0:94f:562b:2979 with SMTP id bj6-20020a17090736c600b0094f562b2979mr8453343ejc.31.1683560907360;
        Mon, 08 May 2023 08:48:27 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id k21-20020a170906055500b009584c5bcbc7sm126316eja.49.2023.05.08.08.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:48:26 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.10 10/10] KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults
Date:   Mon,  8 May 2023 17:48:04 +0200
Message-Id: <20230508154804.30078-11-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154804.30078-1-minipli@grsecurity.net>
References: <20230508154804.30078-1-minipli@grsecurity.net>
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
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.10.x
---
- this kernel lacks the MMU role bits access helpers, so I simply open
  coded them
- it also has "historic" ones for vCPU ones, like is_write_protection()
- no reset_guest_paging_metadata() yet either, so I open-coded its v5.10
  pendant as well

 arch/x86/kvm/mmu.h     | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index a77f6acb46f6..ee4dd4eb7c1c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -70,6 +70,8 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
+void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *mmu);
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
@@ -171,6 +173,24 @@ static inline bool is_write_protection(struct kvm_vcpu *vcpu)
 	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
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
@@ -202,8 +222,12 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	unsigned long smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
 	int index = (pfec >> 1) +
 		    (smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
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
index e1107723ffdc..a17f222b628e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4486,6 +4486,22 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 	return role;
 }
 
+void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *mmu)
+{
+	const bool cr0_wp = is_write_protection(vcpu);
+
+	BUILD_BUG_ON((KVM_MMU_CR0_ROLE_BITS & KVM_POSSIBLE_CR0_GUEST_BITS) != X86_CR0_WP);
+	BUILD_BUG_ON((KVM_MMU_CR4_ROLE_BITS & KVM_POSSIBLE_CR4_GUEST_BITS));
+
+	if (mmu->mmu_role.base.cr0_wp == cr0_wp)
+		return;
+
+	mmu->mmu_role.base.cr0_wp = cr0_wp;
+	update_permission_bitmask(vcpu, mmu, false);
+	update_pkru_bitmask(vcpu, mmu, false);
+}
+
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* Use 5-level TDP if and only if it's useful/necessary. */
-- 
2.39.2

