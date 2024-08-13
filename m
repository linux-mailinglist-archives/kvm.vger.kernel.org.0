Return-Path: <kvm+bounces-23963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BFD950208
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADC5E1C21024
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E3319A2AC;
	Tue, 13 Aug 2024 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KL/7hgB4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D319ADBB;
	Tue, 13 Aug 2024 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543583; cv=none; b=NJn8RVQFFI8deq4R3jWb5AcYg1KJCVA6yU1O6zpZ5kBZHwt09d6f4QgJewSNPSC2xU0mocBhS0ovNRVLHZdc5+/sb/jPPynpgpNCJbZGsEU9olVmRhbOG+lNc579lui8JRRiVI5C/ilNvOy0dhtyqgTRC29LNKECTJnBy0a1Vmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543583; c=relaxed/simple;
	bh=Mpd41u/OQb/mH4vQMFgyLtSbBnfY5mHwiO+lMECYSFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TDf2brY6SDW6Xb5yz19rftaNzKdlNViS7rTF8bsdMnjzjouoaN9J+85LXXpCwQAwfuBuHlTaXMJvcFxycjyBVf1RzvlF4QeNDQlnsLhrdpQ1tDYyvFPdL/BYGGl3xIggVmVHb8xcMV6OMGv9yCZZ4MPkehgADXZ9nvy0QrEhO/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KL/7hgB4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D196C4AF0B;
	Tue, 13 Aug 2024 10:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543583;
	bh=Mpd41u/OQb/mH4vQMFgyLtSbBnfY5mHwiO+lMECYSFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL/7hgB4Ev/RmQbEWOjNk21dO8wbs+g+ZDHnijdQ4A3UgOyz5m9beuTZ3uBA4fV/S
	 N/1OeJDlPqXg0cWxNJtGzXTaIaDrTvJQXKBJlgqpFYljUPkPir1His8o+ihZaBIZIm
	 lWv7w3jQK8ZhrF9tNyhMheZnM6pwSeVW17tbNWhh6C5phdngrGeD4Y/PU07E9fPZWD
	 5gU4zTY9A6mGyRuLz6URcAkkQDbStazvtJ9+oL9P0PF4tOyRW3ih3kITyr3+mHJmom
	 xyG/GNP1JG/TrsDeByZ2fC99jXWowxqNX2/qkWRnJ4mmorpwVCRrsarzzc+X4Eviwk
	 G6Q50/Rrbjvgg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ0-003INM-TW;
	Tue, 13 Aug 2024 11:06:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v3 08/18] KVM: arm64: nv: Honor absence of FEAT_PAN2
Date: Tue, 13 Aug 2024 11:05:30 +0100
Message-Id: <20240813100540.1955263-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If our guest has been configured without PAN2, make sure that
AT S1E1{R,W}P will generate an UNDEF.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..e7e5e0df119e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4600,6 +4600,10 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_TLBIRVAAE1OS	|
 						HFGITR_EL2_TLBIRVAE1OS);
 
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
+						HFGITR_EL2_ATS1E1WP);
+
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
-- 
2.39.2


