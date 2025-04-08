Return-Path: <kvm+bounces-42911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8667A7FD6F
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47DD23B659D
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F9926FA79;
	Tue,  8 Apr 2025 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6EQqhUb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A08226F453;
	Tue,  8 Apr 2025 10:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109561; cv=none; b=W7KgJZW0X8W8jB7CMFc3ef1l7tKS9npRv++nuqNsPH3DGpVrs4HejRfn6NV6acVRpAVzcMFK7hrxS0RiAqhrBn/mFbb8ndsLIMFQ9yJ+sA6gHNeVrsb5M4P0ThzblkE5pTSYYNJX23HftPymUZnLTnLf52IXUr7KZK+j85k3Xss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109561; c=relaxed/simple;
	bh=ydvZE2fcKiHSXxy2PEWqOT/2J5DSfX2LWTaD8LM7MhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D6URpq4Va7xScd6g050W7bszMUhNVHtb6X6RXeG5ean+kVhiQMYL5zNRJA/c9XQqk09iE6dvpVxrjO5llnXXt5mC2f6X0LsHymtjbfOMaofWpGLkAB+7DWTmyubnIjiIQ6V0x1+NCc2Y/IEQurfn95pHJpNbITPMBf0Ol+SsNVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6EQqhUb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BC0C4CEE7;
	Tue,  8 Apr 2025 10:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744109561;
	bh=ydvZE2fcKiHSXxy2PEWqOT/2J5DSfX2LWTaD8LM7MhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6EQqhUbjihCw38r8bJlIz/jQWNYrmqWPIph4sFf8VkH2AyZAO9Hxv3xLW8z2wWF5
	 qglkD09LyTxd/SayrAyYOoHMgF2a192LO+/PJQb6eQtYNiRPtTcK9CV/jQV5br0/NY
	 ZG2EUwaUpd8NXWFTURjlrcrwGiTtq7OvcqVBjv8uIF+Qc7fynRHTq1LqCSXqyf0bPZ
	 z4yuRz6Lr3SsMqowkEKU8kQiuNfQvM2qpWuE5BR5fjv6iO59BhxSl6P97xxLTukPBD
	 rMIGzX5Ic6njY+A2i2Kypnp6TA8VS5TBugaVEYbowxmnL9K0Lft98wXiPmKF9GT4nt
	 doJ3ksJg+tPoA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u26ZL-003QX2-Ac;
	Tue, 08 Apr 2025 11:52:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 12/17] KVM: arm64: nv: Program host's VNCR_EL2 to the fixmap address
Date: Tue,  8 Apr 2025 11:52:20 +0100
Message-Id: <20250408105225.4002637-13-maz@kernel.org>
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

Since we now have a way to map the guest's VNCR_EL2 on the host,
we can point the host's VNCR_EL2 to it and go full circle!

Note that we unconditionally assign the fixmap to VNCR_EL2,
irrespective of the guest's version being mapped or not. We want
to take a fault on first access, so the fixmap either contains
something guranteed to be either invalid or a guest mapping.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 220dee8a45e0d..5eaff1ae32b29 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -48,6 +48,7 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 {
+	u64 guest_hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
 	u64 hcr = vcpu->arch.hcr_el2;
 
 	if (!vcpu_has_nv(vcpu))
@@ -70,9 +71,23 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
 	} else {
 		host_data_clear_flag(VCPU_IN_HYP_CONTEXT);
+
+		if (guest_hcr & HCR_NV) {
+			u64 va = __fix_to_virt(vncr_fixmap(smp_processor_id()));
+
+			/* Inherit the low bits from the actual register */
+			va |= __vcpu_sys_reg(vcpu, VNCR_EL2) & GENMASK(PAGE_SHIFT - 1, 0);
+			write_sysreg_s(va, SYS_VNCR_EL2);
+
+			/* Force NV2 in case the guest is forgetful... */
+			guest_hcr |= HCR_NV2;
+		}
 	}
 
-	return hcr | (__vcpu_sys_reg(vcpu, HCR_EL2) & ~NV_HCR_GUEST_EXCLUDE);
+	BUG_ON(host_data_test_flag(VCPU_IN_HYP_CONTEXT) &&
+	       host_data_test_flag(L1_VNCR_MAPPED));
+
+	return hcr | (guest_hcr & ~NV_HCR_GUEST_EXCLUDE);
 }
 
 static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
-- 
2.39.2


