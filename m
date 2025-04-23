Return-Path: <kvm+bounces-43961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D0D0A990C1
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E9767B06B3
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1B629B209;
	Wed, 23 Apr 2025 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3v6Hoc4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB029AAF1;
	Wed, 23 Apr 2025 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421318; cv=none; b=mYw1YimVnHMb8jpda7Y9hARJi8M/OxfRt0mrOXMVc4CjCWMZfTIrZ+NDw9jb/Ay0n8raG0Lm4ifL6uIBLMn25oZu4IxFm30w9DZKypKlYjWO4rlnw5cKmtFJ13jdTf6Fy8PwSG80Skb0gdXftE5Ngf20Dxn66Pno5VQGuvl+bP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421318; c=relaxed/simple;
	bh=QXWML07vMieaqb/obaP1emEXNEc9cWHjd/dRppNxB+A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OZ1CPqWbyfEkJqrudjb3/geL7YNdDoZMLHbw/mpUXws8nYMG/Ooy+rC7ux4K/WlLMV6n12KxoxlbDCrNcwXCV9yyVUpUiWazHCI9yLY6FjfcGNJyFAIljBJEfy5/oNHOg+joHAApOqylbQGh7UI2ih4jMBNr9pPCv6EMI1il6wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3v6Hoc4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F48C4CEE3;
	Wed, 23 Apr 2025 15:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421318;
	bh=QXWML07vMieaqb/obaP1emEXNEc9cWHjd/dRppNxB+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3v6Hoc46eQpxeIYlCOxyHmTattiekSGnEa6LXJssiK+8OgoqauMiMRx3ggxYGn/f
	 qWh8dmp9VKivdhPVfvpxYT/CE8YSEVNHbCd9GSh2mWQvzyW2wVjCx+THOQF17JmEPf
	 o4LPUQnG4ffdKpAXgvosLhQbxb913cGD4uo2bgeACJ6PEj8yir+clQbGWT7uxbdzVF
	 OL79kVO/hGt1gb1L9XxoskcQkVhbAQ3hYw4HeB8XnHp0xYwmQ+LfmL1t9bYYu+BK9I
	 HDhipwwUaTVuIFOLWSajp7ewRHThPharlegfvOJWzLbphS0UzOfImplmXAlMe9X5FH
	 YdVD6kf8+mPng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7boi-0082xr-Oa;
	Wed, 23 Apr 2025 16:15:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 14/17] KVM: arm64: nv: Plumb TLBI S1E2 into system instruction dispatch
Date: Wed, 23 Apr 2025 16:15:05 +0100
Message-Id: <20250423151508.2961768-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have to handle TLBI S1E2 in the core code, plumb the
sysinsn dispatch code into it, so that these instructions don't
just UNDEF anymore.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 87 +++++++++++++++++++++++++++------------
 1 file changed, 61 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 204470283ccc3..de954524b7870 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3628,11 +3628,22 @@ static void s2_mmu_tlbi_s1e1(struct kvm_s2_mmu *mmu,
 	WARN_ON(__kvm_tlbi_s1e2(mmu, info->va.addr, info->va.encoding));
 }
 
+static bool handle_tlbi_el2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	if (!kvm_supported_tlbi_s1e2_op(vcpu, sys_encoding))
+		return undef_access(vcpu, p, r);
+
+	kvm_handle_s1e2_tlbi(vcpu, sys_encoding, p->regval);
+	return true;
+}
+
 static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
-	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
 
 	/*
 	 * If we're here, this is because we've trapped on a EL1 TLBI
@@ -3643,6 +3654,13 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 * - HCR_EL2.E2H == 0 : a non-VHE guest
 	 * - HCR_EL2.{E2H,TGE} == { 1, 0 } : a VHE guest in guest mode
 	 *
+	 * Another possibility is that we are invalidating the EL2 context
+	 * using EL1 instructions, but that we landed here because we need
+	 * additional invalidation for structures that are not held in the
+	 * CPU TLBs (such as the VNCR pseudo-TLB and its EL2 mapping). In
+	 * that case, we are guaranteed that HCR_EL2.{E2H,TGE} == { 1, 1 }
+	 * as we don't allow an NV-capable L1 in a nVHE configuration.
+	 *
 	 * We don't expect these helpers to ever be called when running
 	 * in a vEL1 context.
 	 */
@@ -3652,7 +3670,13 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding))
 		return undef_access(vcpu, p, r);
 
-	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) {
+		kvm_handle_s1e2_tlbi(vcpu, sys_encoding, p->regval);
+		return true;
+	}
+
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm,
+				   get_vmid(__vcpu_sys_reg(vcpu, VTTBR_EL2)),
 				   &(union tlbi_info) {
 					   .va = {
 						   .addr = p->regval,
@@ -3774,16 +3798,21 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1IS, handle_ripas2e1is),
 
-	SYS_INSN(TLBI_ALLE2OS, undef_access),
-	SYS_INSN(TLBI_VAE2OS, undef_access),
+	SYS_INSN(TLBI_ALLE2OS, handle_tlbi_el2),
+	SYS_INSN(TLBI_VAE2OS, handle_tlbi_el2),
 	SYS_INSN(TLBI_ALLE1OS, handle_alle1is),
-	SYS_INSN(TLBI_VALE2OS, undef_access),
+	SYS_INSN(TLBI_VALE2OS, handle_tlbi_el2),
 	SYS_INSN(TLBI_VMALLS12E1OS, handle_vmalls12e1is),
 
-	SYS_INSN(TLBI_RVAE2IS, undef_access),
-	SYS_INSN(TLBI_RVALE2IS, undef_access),
+	SYS_INSN(TLBI_RVAE2IS, handle_tlbi_el2),
+	SYS_INSN(TLBI_RVALE2IS, handle_tlbi_el2),
+	SYS_INSN(TLBI_ALLE2IS, handle_tlbi_el2),
+	SYS_INSN(TLBI_VAE2IS, handle_tlbi_el2),
 
 	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
+
+	SYS_INSN(TLBI_VALE2IS, handle_tlbi_el2),
+
 	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
 	SYS_INSN(TLBI_IPAS2E1OS, handle_ipas2e1is),
 	SYS_INSN(TLBI_IPAS2E1, handle_ipas2e1is),
@@ -3793,11 +3822,17 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2LE1, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1, handle_ripas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1OS, handle_ripas2e1is),
-	SYS_INSN(TLBI_RVAE2OS, undef_access),
-	SYS_INSN(TLBI_RVALE2OS, undef_access),
-	SYS_INSN(TLBI_RVAE2, undef_access),
-	SYS_INSN(TLBI_RVALE2, undef_access),
+	SYS_INSN(TLBI_RVAE2OS, handle_tlbi_el2),
+	SYS_INSN(TLBI_RVALE2OS, handle_tlbi_el2),
+	SYS_INSN(TLBI_RVAE2, handle_tlbi_el2),
+	SYS_INSN(TLBI_RVALE2, handle_tlbi_el2),
+	SYS_INSN(TLBI_ALLE2, handle_tlbi_el2),
+	SYS_INSN(TLBI_VAE2, handle_tlbi_el2),
+
 	SYS_INSN(TLBI_ALLE1, handle_alle1is),
+
+	SYS_INSN(TLBI_VALE2, handle_tlbi_el2),
+
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 
 	SYS_INSN(TLBI_IPAS2E1ISNXS, handle_ipas2e1is),
@@ -3805,19 +3840,19 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2LE1ISNXS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1ISNXS, handle_ripas2e1is),
 
-	SYS_INSN(TLBI_ALLE2OSNXS, undef_access),
-	SYS_INSN(TLBI_VAE2OSNXS, undef_access),
+	SYS_INSN(TLBI_ALLE2OSNXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_VAE2OSNXS, handle_tlbi_el2),
 	SYS_INSN(TLBI_ALLE1OSNXS, handle_alle1is),
-	SYS_INSN(TLBI_VALE2OSNXS, undef_access),
+	SYS_INSN(TLBI_VALE2OSNXS, handle_tlbi_el2),
 	SYS_INSN(TLBI_VMALLS12E1OSNXS, handle_vmalls12e1is),
 
-	SYS_INSN(TLBI_RVAE2ISNXS, undef_access),
-	SYS_INSN(TLBI_RVALE2ISNXS, undef_access),
-	SYS_INSN(TLBI_ALLE2ISNXS, undef_access),
-	SYS_INSN(TLBI_VAE2ISNXS, undef_access),
+	SYS_INSN(TLBI_RVAE2ISNXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_RVALE2ISNXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_ALLE2ISNXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_VAE2ISNXS, handle_tlbi_el2),
 
 	SYS_INSN(TLBI_ALLE1ISNXS, handle_alle1is),
-	SYS_INSN(TLBI_VALE2ISNXS, undef_access),
+	SYS_INSN(TLBI_VALE2ISNXS, handle_tlbi_el2),
 	SYS_INSN(TLBI_VMALLS12E1ISNXS, handle_vmalls12e1is),
 	SYS_INSN(TLBI_IPAS2E1OSNXS, handle_ipas2e1is),
 	SYS_INSN(TLBI_IPAS2E1NXS, handle_ipas2e1is),
@@ -3827,14 +3862,14 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2LE1NXS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1NXS, handle_ripas2e1is),
 	SYS_INSN(TLBI_RIPAS2LE1OSNXS, handle_ripas2e1is),
-	SYS_INSN(TLBI_RVAE2OSNXS, undef_access),
-	SYS_INSN(TLBI_RVALE2OSNXS, undef_access),
-	SYS_INSN(TLBI_RVAE2NXS, undef_access),
-	SYS_INSN(TLBI_RVALE2NXS, undef_access),
-	SYS_INSN(TLBI_ALLE2NXS, undef_access),
-	SYS_INSN(TLBI_VAE2NXS, undef_access),
+	SYS_INSN(TLBI_RVAE2OSNXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_RVALE2OSNXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_RVAE2NXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_RVALE2NXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_ALLE2NXS, handle_tlbi_el2),
+	SYS_INSN(TLBI_VAE2NXS, handle_tlbi_el2),
 	SYS_INSN(TLBI_ALLE1NXS, handle_alle1is),
-	SYS_INSN(TLBI_VALE2NXS, undef_access),
+	SYS_INSN(TLBI_VALE2NXS, handle_tlbi_el2),
 	SYS_INSN(TLBI_VMALLS12E1NXS, handle_vmalls12e1is),
 };
 
-- 
2.39.2


