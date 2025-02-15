Return-Path: <kvm+bounces-38308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF73A36FD8
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 899091884DDE
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB511FDA8D;
	Sat, 15 Feb 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccLo+p3D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1AD1E5B94;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641104; cv=none; b=PhWMMqA85sY2gHYUTL3BxJvplzat2O1ifnqV6Ugi/6wvKHapq/e5zms2UCS5r30RhEVyZG94AReVDcHKasFnc4M/VKmkZZ1eLZ11ZwF7pXf4/4bBSQ8AokjVMhPJ2bavplyA8i8hFP8WSrW7misvBioVoLsy4ZrCmRHSlclZAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641104; c=relaxed/simple;
	bh=l6/K3TgHqFMCERF5V5TBAO9LtyJHG0zZIRxuUinA74M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tJcMzNnLVGrdf5WDcDeCYtEbXskXzW5Q6Mg9RjSDvhjfTdr/v9oFuIn7gsn55FmFSjJq+pjePDHRjvAV+40tqKMvY4HGwpHmvHhwIkxCtHeFkTL4+IS1xOrn6WvJ2EYr0hQGDkOVttFmloUXqYg5QOwSBwBI5d7E44DXzo9lQOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccLo+p3D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BF8C4CEF2;
	Sat, 15 Feb 2025 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641104;
	bh=l6/K3TgHqFMCERF5V5TBAO9LtyJHG0zZIRxuUinA74M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccLo+p3DqEQCuREatieqYtX4+1e3lMiYepqpQomKJ1107yhfwX+gbA9NWI4sLXFq9
	 wt2KhTmzojLKVGfMmeluUAkOHEfU9HYVD15zr0N71LKcQCcv+7SPgDjj17bbpldnvW
	 Bxtz6ts8f4apxuZh4lIEJil5wbuc9o/VG2Owb7pvKlrcS0DRjBP7iRpmmFsdnEeIF8
	 /7ynVofi2rsezg5USRPl/eBtQRbrt6UQxRnY6DtjrXg15UoKoK9sTplt6swTRhQ1rt
	 zUsPZJjwBy5p+PsJDai9aJy2Y3T7DWW1YwcPSz3Ur9TUwRXHFF7vj2LSIp+pp1owLT
	 syJa1Z0iskJSw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7S-004Pqp-Jx;
	Sat, 15 Feb 2025 17:38:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 12/14] KVM: arm64: Advertise FEAT_ECV when possible
Date: Sat, 15 Feb 2025 17:38:14 +0000
Message-Id: <20250215173816.3767330-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215173816.3767330-1-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
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

We can advertise support for FEAT_ECV if supported on the HW as
long as we limit it to the basic trap bits, and not advertise
CNTPOFF_EL2 support, even if the host has it (the short story
being that CNTPOFF_EL2 is not virtualisable).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5ec5acb6310e9..d55c296fcb27a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -848,14 +848,16 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64MMFR0_EL1:
-		/* Hide ECV, ExS, Secure Memory */
-		val &= ~(ID_AA64MMFR0_EL1_EVC		|
-			 ID_AA64MMFR0_EL1_EXS		|
+		/* Hide ExS, Secure Memory */
+		val &= ~(ID_AA64MMFR0_EL1_EXS		|
 			 ID_AA64MMFR0_EL1_TGRAN4_2	|
 			 ID_AA64MMFR0_EL1_TGRAN16_2	|
 			 ID_AA64MMFR0_EL1_TGRAN64_2	|
 			 ID_AA64MMFR0_EL1_SNSMEM);
 
+		/* Hide CNTPOFF if present */
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR0_EL1, ECV, IMP);
+
 		/* Disallow unsupported S2 page sizes */
 		switch (PAGE_SIZE) {
 		case SZ_64K:
-- 
2.39.2


