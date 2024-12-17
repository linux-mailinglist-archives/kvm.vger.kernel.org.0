Return-Path: <kvm+bounces-33965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D019F4F26
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA8EA1884B67
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45EB1F893A;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MA10NKDG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540511F7571;
	Tue, 17 Dec 2024 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734448446; cv=none; b=prAUSQl0DYOMTtUopKvhdSGudBertSPbcY/HyO930TqOuCWhGPq7Av3pmEwUX1CGITQEnLQS69EzsCfYKUKNC0hTYjDPO8+kNkrsrrOtrmXAQE9whWDlAL88ZIy0z6vzgBwX0QAxEdlbk+RalcxdifwIBfkMX3ASgfHwbTOSGjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734448446; c=relaxed/simple;
	bh=AAx1thK/qARvmlKm/GHshhs0gk8iIkS9tRKm3XsQwuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bp8+B0/1RMPFZnkqcfDpkMxsEJD3QEavBzFHTmW7Ook6EYH4LnHlRAGt9f+rBKDZ54wB2eAv+9mp5AP1GtUunBcH8QBiPJ6pg3nu7eSVueKiBMzt0Mf/2x780jZWS0SusHffTUeoz3EzVtGD6MTsknbzb52FozD64DRX9wp96yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MA10NKDG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14F9C4CEDE;
	Tue, 17 Dec 2024 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734448446;
	bh=AAx1thK/qARvmlKm/GHshhs0gk8iIkS9tRKm3XsQwuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MA10NKDGPx1T0Y/jpTwLsC+gBtPG9BNeMRHgOCNoEaxk93pm+qzEnjIhVFegzYo05
	 k6N/sxmiNEIcgac1Zz6gLwdY+yavfYz/7zMh7FS+oliGrqWzDvXHiWTgMRmJBez8ca
	 DdBjSCZ4nATaVL0ueOPSAEfHOi58gEiNn6Db2qdtffKNo/AirxOxAvWQeDY62o5qUu
	 OGLf2jkD+gHkKLau47SKyHrif7HXU1UZZWP9JA2/SphWiMEbib+4A2YPg88Np4N/Bf
	 brhzZLYgzTmFDPyiNBQxQC21PcV9+AVEMLS5nKcFvGHKfGTYmQX7AErPSP1jj4uX8k
	 wsP1vJ8eVUEEA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNZGu-004bWV-2b;
	Tue, 17 Dec 2024 15:14:04 +0000
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
Subject: [PATCH 08/16] KVM: arm64: nv: Sanitise ICH_HCR_EL2 accesses
Date: Tue, 17 Dec 2024 15:13:23 +0000
Message-Id: <20241217151331.934077-9-maz@kernel.org>
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

As ICH_HCR_EL2 is a VNCR accessor when runnintg NV, add some
sanitising to what gets written. Crucially, mark TDIR as RES0
if the HW doesn't support it (unlikely, but hey...), as well
as anything GICv4 related, since we only expose a GICv3 to the
uest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9b36218b48def..37f7ef2f44bd8 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1271,6 +1271,15 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= MDCR_EL2_EnSTEPOP;
 	set_sysreg_masks(kvm, MDCR_EL2, res0, res1);
 
+	/* ICH_HCR_EL2 */
+	res0 = ICH_HCR_EL2_RES0;
+	res1 = ICH_HCR_EL2_RES1;
+	if (!(kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_EL2_TDS))
+		res0 |= ICH_HCR_EL2_TDIR;
+	/* No GICv4 is presented to the guest */
+	res0 |= ICH_HCR_EL2_DVIM | ICH_HCR_EL2_vSGIEOICount;
+	set_sysreg_masks(kvm, ICH_HCR_EL2, res0, res1);
+
 	return 0;
 }
 
-- 
2.39.2


