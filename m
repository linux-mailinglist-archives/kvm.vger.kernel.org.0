Return-Path: <kvm+bounces-61478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E11FFC20014
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 13:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8E09934E40D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 12:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85BC32548E;
	Thu, 30 Oct 2025 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GDTWIEl7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EC831AF1E;
	Thu, 30 Oct 2025 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827233; cv=none; b=f5SRr6DljDTyiHryAHSfvqIfUjGijXVr0yA1RRNEu1EsI+oGl0dt8vH7QBuRGQOFFb/rRX38BWLdn4EZ6WIav+Zw+cj24DWQwRmOLM+xueF62JAS2jxj0x89h0RioIG3eue/UrN1SsX5tc5xDkPskSyxamKkQIOPUXzKUvJk5zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827233; c=relaxed/simple;
	bh=QP7tdwQd4OxeSGfWsVqm9Zb2T1wUSpsY0DId1bNFcO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DV8ITFyIYkPhXlzmj5UpxvaGmBhvvgNENnH9jxvWguoTN820azqQvNNPasYI4U2qP/+Jezmh1gcUtY2qNnsnABAhBcptrqc6nZhnHqs4+p+LOrUzXrh09SYu2PYw0LIhYO0Pz3dGqxBqNIgqJtPKdKkWilID9+zDOGhXaREo4Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GDTWIEl7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913F2C4CEFF;
	Thu, 30 Oct 2025 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761827232;
	bh=QP7tdwQd4OxeSGfWsVqm9Zb2T1wUSpsY0DId1bNFcO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDTWIEl7dRwqX5FLwLXig5AWQ+CJHxhp9h9vIvTwBbpV+pexoRdlxpe1Z87KO83Gn
	 wn09GM4J4n3aiOmsM/ndwhOFKLd3SSJ1HIemA/UUdXmzrBAuc7kmtMTs0yNAdY+F9j
	 +JJHC2CjAgme30ypZEsFDxPZaPB4EWvhtNckebu08nyFAu4qd2RCX2WJwX02wxuMov
	 /dGLiQ+LKhMaVpOqBHv8yOGExoTExl3c39tjD+t3furbnOd7R4JrlCpd850od53XEI
	 9MU51fKSBKDGK//FulYK2e1icg9klKg98g5SxT22YGjTn2PBv0io+Zk+6j/qwU0ZO3
	 MPODi/EshA2eA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vERkE-00000000yNP-2HBu;
	Thu, 30 Oct 2025 12:27:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v2 2/3] KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
Date: Thu, 30 Oct 2025 12:27:06 +0000
Message-ID: <20251030122707.2033690-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030122707.2033690-1-maz@kernel.org>
References: <20251030122707.2033690-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Drive the idreg fields indicating the presence of GICv3 directly from
the vgic code. This avoids having to do any sort of runtime clearing
of the idreg.

Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1796b1a22a72a..ca411cce41409 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -71,6 +71,7 @@ static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type);
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	struct kvm_vcpu *vcpu;
+	u64 aa64pfr0, pfr1;
 	unsigned long i;
 	int ret;
 
@@ -161,10 +162,19 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
-	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
+	aa64pfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;
+	pfr1 = kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
+
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V2) {
 		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
-	else
+	} else {
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
+		aa64pfr0 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
+		pfr1 |= SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+	}
+
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
 
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap = system_supports_direct_sgis();
-- 
2.47.3


