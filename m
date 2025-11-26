Return-Path: <kvm+bounces-64680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C5EC8ACC3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB6A73B8FD5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C3333CE80;
	Wed, 26 Nov 2025 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2D0JL3B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC92A33A6F9;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764172801; cv=none; b=Dn2LRbMh21bFqr0J8+QnWSUMQFEjPhUcL7Q31QWBGIOimz+r14B8J/vIzj1yDl7BAB1MkQ7e0+1lbZ2L3k6GBhRfVf478TJYZUykTcRDqjheu/69EafoAUzRMOVtErsfHvhFAgnnNnNFxOtFs/K8ypOCKRmhQuue/GlER4xKtTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764172801; c=relaxed/simple;
	bh=YsSPAktGKZYpXd8EVw1BHlsLN0IZwUebr/zgLah6+nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pS6LytwpeWIwBsSw1Yyi28FhcvQf593QilCiN65P5ysdlVqSbyv5SwhJS7egzUFfNwNBmWBMxGb1p6A4Pl87/Oi6PqM090BQBsGNH8/KxUsazEYbHjjc/OApMeASaL6hYrrZRDiy3QhP4H9W59T9QMCpdNXzf/6l0SRG8ktrIco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2D0JL3B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7EDC113D0;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764172801;
	bh=YsSPAktGKZYpXd8EVw1BHlsLN0IZwUebr/zgLah6+nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2D0JL3BFjCgtgX99vdIBdJ2Oz8zNFHFv69lCQpzDe5Mxaait38yB0zY2ennXWNT3
	 L9s5Ozp4f5mKv1ot00McCJO55GNAdmJJv5el3cH6r6ufqkLha91oDhXc3g5vnMNnlc
	 /8/SYPXwEXN16QXX8JrVoBRCrn7EOjxYjkPeWYrvIDvgLTFl3Qn17WxW54QQQwA9GZ
	 9UjYSedfusetQrlURn4mt+CloQx+tr9aG2CpMU9fJC6Pqd1LPxBg+WzD+ZnR2FaK8J
	 dUESFQLk8ZBTZ4BmxfzIDvTDt6Hp07i30il5WzP26xJOiDJO3RqtRJbMz2pMqQTRSw
	 rNpw6Joa2urtA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vOHvy-00000008WrH-3H3A;
	Wed, 26 Nov 2025 15:59:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 2/5] KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
Date: Wed, 26 Nov 2025 15:59:48 +0000
Message-ID: <20251126155951.1146317-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126155951.1146317-1-maz@kernel.org>
References: <20251126155951.1146317-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
to force GMID_EL1 being trapped.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9e4c46fbfd802..2ca6862e935b5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5561,6 +5561,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 
 	if (kvm_has_mte(vcpu->kvm))
 		vcpu->arch.hcr_el2 |= HCR_ATA;
+	else if (id_aa64pfr1_mte(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1)))
+		vcpu->arch.hcr_el2 |= HCR_TID5;
 
 	/*
 	 * In the absence of FGT, we cannot independently trap TLBI
-- 
2.47.3


