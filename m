Return-Path: <kvm+bounces-38695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A033CA3DBA8
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65C833ADC64
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302CC1FBC8E;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRAoCjpw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575E11F8921;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059354; cv=none; b=hb/mpw84f0rxpgXmFswuHniYQmI995bYSQsusw4F7zZtv31JLtlaOrXNlSX9fDO7hftCj21ZfQWQGh6fZLOVbwZfAAa8++jya+qBWQ7oxc1Ng5nt9Nxo8N5bqbrUBXl0dIuhuPUDRpI/SqrOyCLt5U8Eu05IXtVGnaiqALVDzRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059354; c=relaxed/simple;
	bh=RvUSEhI6cySQmIz8ZQ/36MwcnMPJHyHB8RpivDDZCT0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s9E2h6zTlFW+9se9BgFqbx8I4gJ9Uypnb1pAOjB8EKrawM+082rzVYpqeeCo2xLQ+1iitr1HYno2j+y/SXPX4t71yv/7tJiwErT/4Ti+akPoDArkcnJCia69loekt1R6Tjccr2XftRuYc4bHB32/mHqP8TJaeu7n7TVGuaY0XDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRAoCjpw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37464C4CEE3;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059354;
	bh=RvUSEhI6cySQmIz8ZQ/36MwcnMPJHyHB8RpivDDZCT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRAoCjpwAQIn/5ro9NR6AEKHCbJQ+GvUl7Dvl3vAGrQT3duRVWb5VP3kLDpuJqVCu
	 hJ8Mxj7rRs/S+1v/aUc5xaTbi6JNezmU3Qa1Ar8WZgO4b/d13WixkUsG4jaH+5yuZG
	 hjHuQg2jKYZxT9cA7meGDsojvFNNYC9VeGT4i+pgmjzcIdLZsa1yDvmIR99pLLS07n
	 /SCJOIX14OXQ0OwmCuxSE5t0r4mtw0LKWTjKCLUFWuI84NCnxdfjfLkaZKevAQUKdB
	 dm0yFCYB7TblKX4WpOFDGRxpsYEsl6WrSF+Y0eR0oiYIy7Z+TQ7M/mYTOK+fWXqrpA
	 eblGtQ9VWH3Jw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vQ-006DXp-8p;
	Thu, 20 Feb 2025 13:49:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 03/14] KVM: arm64: Mark HCR.EL2.E2H RES0 when ID_AA64MMFR1_EL1.VH is zero
Date: Thu, 20 Feb 2025 13:48:56 +0000
Message-Id: <20250220134907.554085-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
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

Enforce HCR_EL2.E2H being RES0 when VHE is disabled, so that we can
actually rely on that bit never being flipped behind our back.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 0c9387d2f5070..ed3add7d32f66 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1034,6 +1034,8 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= (HCR_TEA | HCR_TERR);
 	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
 		res0 |= HCR_TLOR;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
+		res0 |= HCR_E2H;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, IMP))
 		res1 |= HCR_E2H;
 	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
-- 
2.39.2


