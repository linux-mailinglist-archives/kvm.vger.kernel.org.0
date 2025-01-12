Return-Path: <kvm+bounces-35249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B64A0AB2C
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1978116667A
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4611CB51F;
	Sun, 12 Jan 2025 17:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQaGsGdu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D611C5F2B;
	Sun, 12 Jan 2025 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701734; cv=none; b=DJeQKJMkSt+ql+7psPsbQw2DqpRg0OX2EBUMFfhu5JIC/vsnfv8hrn8WRXHv114Vs07OQcSyjkDDukAdLgm2Z09WlPsShnCwZd9FkhRQTMLCGUlEKse+IiP99tCwGu9wF+depDVDB3PIOJff6X0rpbGn2KoeuoOdKBPJbp1djnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701734; c=relaxed/simple;
	bh=JSBW8RAszUnNeq0jMTzvpSWQiVSVXM9WuQg/Gq5vzbs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XI7YupU5VDsrou/YpZzsgMvW7n3k8ksoaYFTVN7u9uqoFbW9xcBS3619HYWC1KnAvc7HaDJFHAfvm8osA2S3Mc14WUcL3AXF+Ks+HzDg4beTlgifN2NDEI5hoL7vePqlQej5OVeg/c1Xpg05UwHttKVOprqUrohfDDSB/wMI+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQaGsGdu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645E8C4CEE3;
	Sun, 12 Jan 2025 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736701734;
	bh=JSBW8RAszUnNeq0jMTzvpSWQiVSVXM9WuQg/Gq5vzbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQaGsGduLX0+lNmOAkzJ8F3V66zQlcQ7aCO8kS8pugCChbZ7iH18QraHSUYC3to/C
	 J5X+mODSakreDf8Xv1hBtcszEGtT2DHfOBYDipQzINs1GAKUezpELQieBASlN0tVdH
	 JY44Pj4nTkkvs0c3CE4aMdn0m2Rqi/FN+B5hkFrRj0K14dTYtLOOP+OHHIBRYWtD6O
	 lL7/HiVAO3xeqPdvubfl1+77vshmb+ivWPTWa+DjfAbTXeaLSA44jVkCRt1oMXyVRj
	 6fsRaSJsJZz/6CtWNyQn6V5gNJvkqXi2h5iDdPvbbbh6YzWOzqyCNUD4nCNKiE3+69
	 15SL+OBWm3x5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1SG-00BNxR-Mz;
	Sun, 12 Jan 2025 17:08:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 17/17] KVM: arm64: nv: Fail KVM init if asking for NV without GICv3
Date: Sun, 12 Jan 2025 17:08:45 +0000
Message-Id: <20250112170845.1181891-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250112170845.1181891-1-maz@kernel.org>
References: <20250112170845.1181891-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although there is nothing in NV that is fundamentally incompatible
with the lack of GICv3, there is no HW implementation without one,
at least on the virtual side (yes, even fruits have some form of
vGICv3).

We therefore make the decision to require GICv3, which will only
affect models such as QEMU. Booting with a GICv2 or something
even more exotic while asking for NV will result in KVM being
disabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 756cc4e74e10f..0154480828aa9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2318,6 +2318,13 @@ static int __init init_subsystems(void)
 		goto out;
 	}
 
+	if (kvm_mode == KVM_MODE_NV &&
+	   !(vgic_present && kvm_vgic_global_state.type == VGIC_V3)) {
+		kvm_err("NV support requires GICv3, giving up\n");
+		err = -EINVAL;
+		goto out;
+	}
+
 	/*
 	 * Init HYP architected timer support
 	 */
-- 
2.39.2


