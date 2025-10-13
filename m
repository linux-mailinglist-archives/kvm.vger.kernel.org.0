Return-Path: <kvm+bounces-59879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B59BD2105
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 10:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 171F14EE11D
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328242F6588;
	Mon, 13 Oct 2025 08:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HeRVsr0q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2F02F5A39;
	Mon, 13 Oct 2025 08:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760344339; cv=none; b=o9DWFOSt7o4TKDVaHqmHlR/siEkaG8TbPpzEafwCZMewUTs5Er6F8yScOtSTLusaSbQDyXYcZgdO6GpNwNKX5RkZ5JYXbtPG0y9LcwifpUBdVJJOsx2JIVPWDu6oIhwamTx0PCmnbjHzAA9CzleBTPaK117CzhRFiHphf5Wz9Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760344339; c=relaxed/simple;
	bh=e4jSbrTR091qdtjsZD853eW2199IQDEFqqJDuRj7BAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He1lz2Sot6nWk5zgWUl9qlUActm8yC9JCmCpV2DANwCjaTTz5y2o5TPkUQQ0+fHqoCW0cqMne0uZZj4ZxezzhxNYq99z777le3U+bm6sCHRiM748SrhKyg8IwxEg9f/6N77j4E0BwtosHGVZkEq7mKXk0nit3sAnQl9td87RISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HeRVsr0q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1677CC116C6;
	Mon, 13 Oct 2025 08:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760344339;
	bh=e4jSbrTR091qdtjsZD853eW2199IQDEFqqJDuRj7BAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeRVsr0qs4gBzQ0wAfVSY+ncgi4aRM8Dk5yc9Cf7VYR+S4pKL6MSRGQ7leHdapfn+
	 whqtM1anLGxy3WTA7ExzI5OjYttsLpYeVkEdLtk+S42c6hOcsnR5/KgxEKN9NacffO
	 xOTqSMgS9bOZQCLoLS3GdoSyx4kC7xPCHjIKL/tkHwlyX5rpv/G51Ph5g7wFT0pkza
	 AEDHJ+5f5dJS2GflhsT3NBBR6ZfrimdHamUco8peUSEeqZ67BpK3k9y6WuwLziLOSu
	 pz3sDkw6Ui83+AYP/baQpOeBRLk91gWbfFyKC+jTWD071pm9Rc1tKCYKCSQItkwQXJ
	 1oc9TVjxLvafQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8Dyb-0000000DRrP-0AUh;
	Mon, 13 Oct 2025 08:32:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 2/3] KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
Date: Mon, 13 Oct 2025 09:32:06 +0100
Message-ID: <20251013083207.518998-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013083207.518998-1-maz@kernel.org>
References: <20251013083207.518998-1-maz@kernel.org>
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
 arch/arm64/kvm/vgic/vgic-init.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 4c3c0d82e4760..2c518b0a4d81b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -161,10 +161,16 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
-	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
+	*__vm_id_reg(&kvm->arch, SYS_ID_AA64PFR0_EL1) &= ~ID_AA64PFR0_EL1_GIC;
+	*__vm_id_reg(&kvm->arch, SYS_ID_PFR1_EL1) &= ~ID_PFR1_EL1_GIC;
+
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V2) {
 		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
-	else
+	} else {
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
+		*__vm_id_reg(&kvm->arch, SYS_ID_AA64PFR0_EL1) |= SYS_FIELD_VALUE(ID_AA64PFR0_EL1, GIC, IMP);
+		*__vm_id_reg(&kvm->arch, SYS_ID_PFR1_EL1) |= SYS_FIELD_VALUE(ID_PFR1_EL1, GIC, GICv3);
+	}
 
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap = system_supports_direct_sgis();
-- 
2.47.3


