Return-Path: <kvm+bounces-35241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05296A0AB24
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76D311886155
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23511C3C18;
	Sun, 12 Jan 2025 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xe15X6xc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106971C07DC;
	Sun, 12 Jan 2025 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701733; cv=none; b=ctnACUqyCGp9hbnww/fCP8oAmuna/Xx+gNRzNFcCC/9jxXQ2IAGPivjxTJ1qPHUj9IfBSIGYK8jFmGy8KN6ze1rS9CqfQ6XwYTPZTaOSjuviDAS5YoBaprD16KxOj2N7oXIfGmXxW/a2snG564MpqyZyaXo5pc4X0hckvZ/PiGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701733; c=relaxed/simple;
	bh=AAx1thK/qARvmlKm/GHshhs0gk8iIkS9tRKm3XsQwuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jvTWw69RlLvrgZqaKCzC2XHNvEp5ntOCU/+nSxD0ezNS5aT/l557t1rf0EDM4tGDP7262T8f2YkY4gp9Ckt/CfuJrZdHnYMmCcYbAV8mDMHbhIdkrcvGiPw31U2iqjKDHjihkN2XdKw+IPabpuyQrFLOoRmNriuI86kg8edZweg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xe15X6xc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6057CC4CEE6;
	Sun, 12 Jan 2025 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736701732;
	bh=AAx1thK/qARvmlKm/GHshhs0gk8iIkS9tRKm3XsQwuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xe15X6xcCjeakafeevsW/ZBDTh4R/38gRiKU6jqOGwESh+mv5KBmh6Ho1TuNy3D99
	 jn2BzauGSfEKXGqXTDNz8V/KE16JSfNdQZMFentmZAy+H+rLFeTqwvqyZi1sd/CrQS
	 TtxzCMpOersUMmOiZB0/Jtx7ox1UkE5yMSrXF6GF9wh45mQZJFIqW0P9qXwDVQm4Sd
	 S8i4sDFdnqfnzcJm+urlFQtSvru+BTk7kldCQHXncYnmxw30S29QdFeayDADzNFGiy
	 1poELrz9DueczH95mBE9iQacIp5UpMSSCjoLlZBoZnnlGXS11AzJRODRwJBuO38QeD
	 a9KUf9fF02zLg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1SE-00BNxR-Ex;
	Sun, 12 Jan 2025 17:08:50 +0000
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
Subject: [PATCH v2 08/17] KVM: arm64: nv: Sanitise ICH_HCR_EL2 accesses
Date: Sun, 12 Jan 2025 17:08:36 +0000
Message-Id: <20250112170845.1181891-9-maz@kernel.org>
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


