Return-Path: <kvm+bounces-42908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F13BA7FD2B
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30DB6172DF7
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B79D26FA6F;
	Tue,  8 Apr 2025 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZXEaeYu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37FE26E17C;
	Tue,  8 Apr 2025 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109560; cv=none; b=AqcBei4XGH6smhdGZ/DhbWlUJ17WYQswzPUuC27ASVDbZqa89zgxdxuzBJJPiaZwZGPOcqmKqRE7bWLjuWZ3CbXaHC/SaNZSBgNGKNas6UT6Um0ThjHImsg47RRvMjJe4gO3qBd4RrXMzOBDXt5G5z5Ns9fkKKGSfcZ6iu/PV5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109560; c=relaxed/simple;
	bh=DX96ijfGmBt5iZBTXCNJU76uJhpiSiLLcleh4XBMe4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QCgL7enReis+HwFAnIwuISQdtUXkmpBudLHt737xtESlMqZjZWfkF5cP6+498R8Ryy1f75M1f3dBZ5p9247vU+cfHN9w+bYCULUmr99dt/rLaVUrH5xzhfuchxKp1l8yRR4KMGfCXqdSwrz0I7ll3AZhMdzbrahmo1tVGeHYsWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZXEaeYu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B171C4CEE7;
	Tue,  8 Apr 2025 10:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744109560;
	bh=DX96ijfGmBt5iZBTXCNJU76uJhpiSiLLcleh4XBMe4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZXEaeYug0hPRATdKnAbfAfGZKILcGqAZQEF6TQkJjLZtPcXm6qcoy+6Sjat7JgsK
	 qnyR2fiKYAifOBCD/RdNeSj81OyggClpD+i4fS/j/k2RG3vs742v8v0PIuq6rM4W1T
	 79TMdv1jrEAyBSZk024Pb9E0oNcmGDYhQGpdI4feLOo9NbpYQqTHj8cJjYWXu02CRA
	 cq82pHNVhepx6tGvaGEpfJ05c4eqiwpwGx2ydQW1lWd7B3L/X75z7ltrlczq8JPjV1
	 F2gN48I9jSOewgQ/sk0Kesv2mk8z80o/l/BmLmKoZxZSiWo2rYWFlXC2ZsKD/vthdl
	 3jxxzs+mbYWRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u26ZK-003QX2-Py;
	Tue, 08 Apr 2025 11:52:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 09/17] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
Date: Tue,  8 Apr 2025 11:52:17 +0100
Message-Id: <20250408105225.4002637-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250408105225.4002637-1-maz@kernel.org>
References: <20250408105225.4002637-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As VNCR_EL2.BADDR contains a VA, it is bound to trigger faults.

These faults can have multiple source:

- We haven't mapped anything on the host: we need to compute the
  resulting translation, populate a TLB, and eventually map
  the corresponding page

- The permissions are out of whack: we need to tell the guest about
  this state of affairs

Note that the kernel doesn't support S1POE for itself yet, so
the particular case of a VNCR page mapped with no permissions
or with write-only permissions is not correctly handled yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h        |   2 +
 arch/arm64/include/asm/kvm_host.h   |   1 +
 arch/arm64/include/asm/kvm_nested.h |   1 +
 arch/arm64/kvm/handle_exit.c        |   1 +
 arch/arm64/kvm/nested.c             | 158 ++++++++++++++++++++++++++++
 5 files changed, 163 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d1b1a33f9a8b0..011d29c017b9e 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -99,6 +99,8 @@
 #define ESR_ELx_AET_CE		(UL(6) << ESR_ELx_AET_SHIFT)
 
 /* Shared ISS field definitions for Data/Instruction aborts */
+#define ESR_ELx_VNCR_SHIFT	(13)
+#define ESR_ELx_VNCR		(UL(1) << ESR_ELx_VNCR_SHIFT)
 #define ESR_ELx_SET_SHIFT	(11)
 #define ESR_ELx_SET_MASK	(UL(3) << ESR_ELx_SET_SHIFT)
 #define ESR_ELx_FnV_SHIFT	(10)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f5ac454dcf66a..8fb1c8d5fd142 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -53,6 +53,7 @@
 #define KVM_REQ_RESYNC_PMU_EL0		KVM_ARCH_REQ(7)
 #define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
+#define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 98b3d6b589668..be4be8ec49d9e 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -335,5 +335,6 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 /* VNCR management */
 int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
+int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b73dc26bc44b4..9700627dd85f3 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -317,6 +317,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
+	[ESR_ELx_EC_DABT_CUR]	= kvm_handle_vncr_abort,
 	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
 	[ESR_ELx_EC_WATCHPT_LOW]= kvm_handle_guest_debug,
 	[ESR_ELx_EC_BREAKPT_LOW]= kvm_handle_guest_debug,
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 810aa668e1f3a..a7b3770baa8d2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -882,6 +882,164 @@ int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
+{
+	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
+}
+
+static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
+{
+	bool write_fault, writable;
+	unsigned long mmu_seq;
+	struct vncr_tlb *vt;
+	struct page *page;
+	u64 va, pfn, gfn;
+	int ret;
+
+	vt = vcpu->arch.vncr_tlb;
+
+	vt->wi = (struct s1_walk_info) {
+		.regime	= TR_EL20,
+		.as_el0	= false,
+		.pan	= false,
+	};
+	vt->wr = (struct s1_walk_result){};
+	vt->valid = false;
+	
+	guard(srcu)(&vcpu->kvm->srcu);
+
+	va =  read_vncr_el2(vcpu);
+
+	ret = __kvm_translate_va(vcpu, &vt->wi, &vt->wr, va);
+	if (ret)
+		return ret;
+
+	write_fault = kvm_is_write_fault(vcpu);
+
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	gfn = vt->wr.pa >> PAGE_SHIFT;
+	pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writable, &page);
+	if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
+		return -EFAULT;
+
+	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
+		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
+			return -EAGAIN;
+
+		vt->gva = va;
+		vt->hpa = pfn << PAGE_SHIFT;
+		vt->valid = true;
+		vt->cpu = -1;
+
+		kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
+	}
+
+	kvm_release_faultin_page(vcpu->kvm, page, false, vt->wr.pw);
+	if (vt->wr.pw)
+		mark_page_dirty(vcpu->kvm, gfn);
+
+	return 0;
+}
+
+static void inject_vncr_perm(struct kvm_vcpu *vcpu)
+{
+	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+
+	/* Adjust the fault level to reflect that of the guest's */
+	esr &= ~ESR_ELx_FSC;
+	esr |= FIELD_PREP(ESR_ELx_FSC,
+			  ESR_ELx_FSC_PERM_L(vt->wr.level));
+
+	kvm_inject_nested_sync(vcpu, esr);
+}
+
+static bool kvm_vncr_tlb_lookup(struct kvm_vcpu *vcpu)
+{
+	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
+
+	lockdep_assert_held_read(&vcpu->kvm->mmu_lock);
+
+	if (!vt->valid)
+		return false;
+
+	if (read_vncr_el2(vcpu) != vt->gva)
+		return false;
+
+	if (vt->wr.nG) {
+		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
+		u64 ttbr = ((tcr & TCR_A1) ?
+			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
+			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
+		u16 asid;
+
+		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
+		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
+		    !(tcr & TCR_ASID16))
+			asid &= GENMASK(7, 0);
+
+		return asid != vt->wr.asid;
+	}
+
+	return true;
+}
+
+int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
+{
+	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+
+	BUG_ON(!(esr & ESR_ELx_VNCR_SHIFT));
+
+	if (esr_fsc_is_permission_fault(esr)) {
+		inject_vncr_perm(vcpu);
+	} else if (esr_fsc_is_translation_fault(esr)) {
+		bool valid;
+		int ret;
+
+		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+			valid = kvm_vncr_tlb_lookup(vcpu);
+
+		if (!valid)
+			ret = kvm_translate_vncr(vcpu);
+		else
+			ret = -EPERM;
+
+		switch (ret) {
+		case -EAGAIN:
+		case -ENOMEM:
+			/* Let's try again... */
+			break;
+		case -EFAULT:
+		case -EINVAL:
+		case -ENOENT:
+			/*
+			 * Translation failed, inject the corresponding
+			 * exception back to EL2.
+			 */
+			BUG_ON(!vt->wr.failed);
+
+			esr &= ~ESR_ELx_FSC;
+			esr |= FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);
+
+			kvm_inject_nested_sync(vcpu, esr);
+			break;
+		case -EPERM:
+			/* Hack to deal with POE until we get kernel support */
+			inject_vncr_perm(vcpu);
+			break;
+		case 0:
+			break;
+		}
+	} else {
+		WARN_ONCE(1, "Unhandled VNCR abort, ESR=%llx\n", esr);
+	}
+
+	return 1;
+}
+
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
-- 
2.39.2


