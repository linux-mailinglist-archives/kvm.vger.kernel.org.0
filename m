Return-Path: <kvm+bounces-63947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 535F6C75B87
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9FC3F347458
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A1C63A8D68;
	Thu, 20 Nov 2025 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVzdvSF6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBEA3A79A6;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659563; cv=none; b=jHiQeBrszBrcWu7sB0robt0T/b2UmzijcVSlMzwSXHgEwfl5m6roYSB0sCu1eESQc0oUzOOLh46mYiJdVdah1ScvklWxKAFyZIMVO/JC7Asb5suwKGiJsHXZzrEuo/0G+TEJKGjs2GvCLL9p0zvknp536sDVxFkqELtk0RWKIac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659563; c=relaxed/simple;
	bh=2M4MvgwXEugIL3oc9eCJTpv22xhUFFpaQt+5YS+onvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKImGVwvqVEcXSUzDx9nvSHNN+HDANkyhgy6DTxSjNHn+mjPmjZAogdys58W8fUAttxdKthWl9lvH6GhLgNxbcrM7WJsfyZMCnjtEMniQGREm4N0cvW6Uklvj+G3rozNu8qZDTeFcJXz/4yM66klnpPCsFGeJirk8teE2zcz9e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVzdvSF6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82599C116D0;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659563;
	bh=2M4MvgwXEugIL3oc9eCJTpv22xhUFFpaQt+5YS+onvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVzdvSF6VGpIZtYXPv6LJuKjlM21JV/05/5SjEULzrDDidGNXnI3TZ2dqWXazwbT2
	 W0ai4cgD4n5OLbpYCldBbu0BJJAqdvUa+Qnz9eoSXa6yvHhNew1r7C+Zl8gqe/61Yd
	 4s9lnqsbaePP2MgBZdRm+LqtHFdppjEYM72KSUt6uI/l8x34nf5LUPjMjzVod+2KYo
	 EB47DZGijmfnWlxypeHVI4QjTPyTLNALb4420MK7OY4GfIk+4DY22yF4HYiSf9Wm8e
	 gEX6VsENiuwgAQ8VAwT9efqWDP/+w3Pjn01aOP0A9gkauGpsOhd+6ZSnPtFJfzXjs8
	 5hpGQoATC5oIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Px-00000006y6g-2vqD;
	Thu, 20 Nov 2025 17:26:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 32/49] KVM: arm64: GICv3: Handle in-LR deactivation when possible
Date: Thu, 20 Nov 2025 17:25:22 +0000
Message-ID: <20251120172540.2267180-33-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Even when we have either an LR overflow or SPIs in flight, it is
extremely likely that the interrupt being deactivated is still in
the LRs, and that going all the way back to the the generic trap
handling code is a waste of time.

Instead, try and deactivate in place when possible, and only if
this fails, perform a full exit.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 38 ++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index f2f5854551449..71199e1a92940 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -792,7 +792,7 @@ static void __vgic_v3_bump_eoicount(void)
 	write_gicreg(hcr, ICH_HCR_EL2);
 }
 
-static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+static int ___vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 vid = vcpu_get_reg(vcpu, rt);
 	u64 lr_val;
@@ -800,19 +800,25 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 	/* EOImode == 0, nothing to be done here */
 	if (!(vmcr & ICH_VMCR_EOIM_MASK))
-		return;
+		return 1;
 
 	/* No deactivate to be performed on an LPI */
 	if (vid >= VGIC_MIN_LPI)
-		return;
+		return 1;
 
 	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
-	if (lr == -1) {
-		__vgic_v3_bump_eoicount();
-		return;
+	if (lr != -1) {
+		__vgic_v3_clear_active_lr(lr, lr_val);
+		return 1;
 	}
 
-	__vgic_v3_clear_active_lr(lr, lr_val);
+	return 0;
+}
+
+static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	if (!___vgic_v3_write_dir(vcpu, vmcr, rt))
+		__vgic_v3_bump_eoicount();
 }
 
 static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
@@ -1247,9 +1253,21 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	case SYS_ICC_DIR_EL1:
 		if (unlikely(is_read))
 			return 0;
-		/* Full exit if required to handle overflow deactivation... */
-		if (vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr & ICH_HCR_EL2_TDIR)
-			return 0;
+		/*
+		 * Full exit if required to handle overflow deactivation,
+		 * unless we can emulate it in the LRs (likely the majority
+		 * of the cases).
+		 */
+		if (vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr & ICH_HCR_EL2_TDIR) {
+			int ret;
+
+			ret = ___vgic_v3_write_dir(vcpu, __vgic_v3_read_vmcr(),
+						   kvm_vcpu_sys_get_rt(vcpu));
+			if (ret)
+				__kvm_skip_instr(vcpu);
+
+			return ret;
+		}
 		fn = __vgic_v3_write_dir;
 		break;
 	case SYS_ICC_RPR_EL1:
-- 
2.47.3


