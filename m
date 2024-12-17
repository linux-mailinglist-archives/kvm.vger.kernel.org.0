Return-Path: <kvm+bounces-33967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D87629F4F18
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF8C37A3DDC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42241F8937;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="keTNWfmX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1F1F76D4;
	Tue, 17 Dec 2024 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734448446; cv=none; b=Noz+KdEDWGY6sRIY1OsQ2cNpy8VhRwt+z/BYFZ2e4uX9QnJM5XtoNqaLYohWD3vDbTTJhymflLknAni2HMYDoCEEHEF6avTMX1yJNqzvLIAPgndhi8vsfFqucNRXpitCjxZa+6lAphEaqe/ZL7881VoMnpKzL6MIkoyryyT6LXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734448446; c=relaxed/simple;
	bh=nAC/ZkuhKGWosTuXH8V3vBlUw/qX7PIayXIp2unPRDg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tD9+9duxPpfflVzKROJQCuR1fS9t79yrNFJkl0+/RjPBjE66dgRJlIkSgp0JFbQ9ENR3LDOIVTCCXQBY13pf9t3M4XQJq4DthYCzjOk8T0RqXm5urRi00Enod5eOgXnzSsc/HzZ5HN9vdHrLsoPgNlbTuvPlzP53vUjUYAJ8XaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=keTNWfmX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA35CC4CED4;
	Tue, 17 Dec 2024 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734448445;
	bh=nAC/ZkuhKGWosTuXH8V3vBlUw/qX7PIayXIp2unPRDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keTNWfmXU5FtOFoDqddSiv5RaJXt7OHHzduAZSX92XJiAmRjVQ/rGl36HDAi4b1t3
	 qJRjuGFRAzHK4SCFpeizVNp+diqg9SQgKxwXUbi91leC+qvCIlPZ7JolYdarrS6ddo
	 hik7MQSIQY6dviIwkk3hazEmmE6wvigjnjhm2+SiOjgXQ1Ui16NwDnTtl1O4s3OKrb
	 W7o+9DPCAIlQpC1gj+XGZNC31SoHG7GSMCfu954sbSFTImmxqkA+YiHf04JiTv/sKD
	 Y4r8yvl/u4Q6zLsCplGiMpsfNxUdXTRY+389yGDvaQBKo7cyd1LwwR6wTzx55r7Zqv
	 za74pDPkna5IQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNZGt-004bWV-LV;
	Tue, 17 Dec 2024 15:14:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eauger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 06/16] KVM: arm64: nv: Add ICH_*_EL2 registers to vpcu_sysreg
Date: Tue, 17 Dec 2024 15:13:21 +0000
Message-Id: <20241217151331.934077-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217151331.934077-1-maz@kernel.org>
References: <20241217151331.934077-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eauger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_NV2 comes with a bunch of register-to-memory redirection
involving the ICH_*_EL2 registers (LRs, APRs, VMCR, HCR).

Adds them to the vcpu_sysreg enumeration.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8cc25845b4be3..218047cd0296d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -554,7 +554,33 @@ enum vcpu_sysreg {
 	VNCR(CNTP_CVAL_EL0),
 	VNCR(CNTP_CTL_EL0),
 
+	VNCR(ICH_LR0_EL2),
+	VNCR(ICH_LR1_EL2),
+	VNCR(ICH_LR2_EL2),
+	VNCR(ICH_LR3_EL2),
+	VNCR(ICH_LR4_EL2),
+	VNCR(ICH_LR5_EL2),
+	VNCR(ICH_LR6_EL2),
+	VNCR(ICH_LR7_EL2),
+	VNCR(ICH_LR8_EL2),
+	VNCR(ICH_LR9_EL2),
+	VNCR(ICH_LR10_EL2),
+	VNCR(ICH_LR11_EL2),
+	VNCR(ICH_LR12_EL2),
+	VNCR(ICH_LR13_EL2),
+	VNCR(ICH_LR14_EL2),
+	VNCR(ICH_LR15_EL2),
+
+	VNCR(ICH_AP0R0_EL2),
+	VNCR(ICH_AP0R1_EL2),
+	VNCR(ICH_AP0R2_EL2),
+	VNCR(ICH_AP0R3_EL2),
+	VNCR(ICH_AP1R0_EL2),
+	VNCR(ICH_AP1R1_EL2),
+	VNCR(ICH_AP1R2_EL2),
+	VNCR(ICH_AP1R3_EL2),
 	VNCR(ICH_HCR_EL2),
+	VNCR(ICH_VMCR_EL2),
 
 	NR_SYS_REGS	/* Nothing after this line! */
 };
-- 
2.39.2


