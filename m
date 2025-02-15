Return-Path: <kvm+bounces-38285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B119AA36EF0
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 705D01894611
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6576E1EA7CB;
	Sat, 15 Feb 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUNeio6+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FAE1DE4D3;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631723; cv=none; b=e5rP6g61y7mE7+82dpfid/Eu8w0vCJrMC/XXPnlw03Uf7idIcJ+vdNrPB7jH4kO4PmG3/Bi635Omavu/ptI0NUeXdZ+YnR3qU3pKiDiAFh/t/5tnxOLur8e2qu/N/Q3Eh5Di3xAy8ygAeddDyOFkyWQ1e8XkYOD8P5hE8AfDmiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631723; c=relaxed/simple;
	bh=D49Oij77kNU/TzhivA/5mv71aVXgtxyHWjzVWpPaFPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j1FDxPMPFcUkk089u1i83RxWouwgDerHr9NcBq9BZSJG1PP8t1E1KGUiyggYCHxcHc0DfaDTublTSz7ljDgDOoC4MKUuDRpKejnZPiCMUC7HnIIV1L/XXjRGRWHT6gP8yW91AswZcWa36uC8I8Qvs0yJYUZl3XUDv4QYuWEXAHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUNeio6+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D6AC4CEEA;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631723;
	bh=D49Oij77kNU/TzhivA/5mv71aVXgtxyHWjzVWpPaFPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUNeio6+OKWilLjwqsM5XeXfzwT8TxHTvAa9vHJCwqBs+z3/HKcRBZIUceNBYhhYn
	 TC/dd1kA1X4bHH4m9fu4J0cb86oC+owM7PU8HluLZBpaVvdLdZ5uaysMwBfmUsudHq
	 KbNJDtiqWAdEtn0fu3DZ66G0b6tdS5zFTic1OP/x5Mvhzk2e75XEx9sKmPXCheIfQD
	 z0KUc+4KdKrvnYqhbGCqGCdxJbrtRPrCFW75E59sNsBm645SnEz8cH3/eE3C8io+yJ
	 zRbC0rQjN5fGR6a7rSR+4achHwZ/zQ4PukCYj7dCEtaw0BuGzFDnMWo/CiGpXywNF0
	 Z2fTAJKrlvq3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJg8-004Nz6-V0;
	Sat, 15 Feb 2025 15:02:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 04/14] KVM: arm64: nv: Snapshot S1 ASID tagging information during walk
Date: Sat, 15 Feb 2025 15:01:24 +0000
Message-Id: <20250215150134.3765791-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
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

We currently completely ignore any sort of ASID tagging during a S1
walk, as AT doesn't care about it.

However, such information is required if we are going to create
anything that looks like a TLB from this walk.

Let's capture it both the nG and ASID information while walking
the page tables.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/at.c                 | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 43162f1dc4993..2bd315a59f283 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -273,6 +273,8 @@ struct s1_walk_result {
 			u64	pa;
 			s8	level;
 			u8	APTable;
+			bool	nG;
+			u16	asid;
 			bool	UXNTable;
 			bool	PXNTable;
 			bool	uwxn;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index cded013587178..382847ce0c9b7 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -410,6 +410,33 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wr->pa = desc & GENMASK(47, va_bottom);
 	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
 
+	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
+	if (wr->nG) {
+		u64 asid_ttbr, tcr;
+
+		switch (wi->regime) {
+		case TR_EL10:
+			tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
+			asid_ttbr = ((tcr & TCR_A1) ?
+				     vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
+				     vcpu_read_sys_reg(vcpu, TTBR0_EL1));
+			break;
+		case TR_EL20:
+			tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
+			asid_ttbr = ((tcr & TCR_A1) ?
+				     vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
+				     vcpu_read_sys_reg(vcpu, TTBR0_EL2));
+			break;
+		default:
+			BUG();
+		}
+
+		wr->asid = FIELD_GET(TTBR_ASID_MASK, asid_ttbr);
+		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
+		    !(tcr & TCR_ASID16))
+			wr->asid &= GENMASK(7, 0);
+	}
+
 	return 0;
 
 addrsz:
-- 
2.39.2


