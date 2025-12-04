Return-Path: <kvm+bounces-65264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 752CCCA313C
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1C754303281B
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E0E30AABE;
	Thu,  4 Dec 2025 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4bU6XTc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FC5338596;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841717; cv=none; b=bUmk67sX16+kSgyRosArfRokeF954hJbnWWjIP6lI4Cy0ttbDgrOv5f17sOwE9y4+wcyt+nIhPLyAIW+JO14DKbdd9Q2iLmvs9fS4OObLiqaFaPUONyHxrPZuD8gpQW1Zpda9jyaf5sYJMwHjnYQmJKowTN++MIOAFMTuzryWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841717; c=relaxed/simple;
	bh=si+8MTGO26F/F4k3uMd0juQ9tO6Gxb5QxflpsHGJ3G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwC7t+2EGj5vYNukr/zWP/uZKokInMSs+MDsMLZnew/IbL+MVXot+ITWWrvgrjW+0wPd62egg8BOX97bOgMoRQ7JFmu7XHbo8rzBlWGzQUtuVw9pSgv8L9nsC3whvU8TM687oOAvybxiT6yijV8v3Wlxe7qV8m2ZSuuN42sG3IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4bU6XTc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCD5C19421;
	Thu,  4 Dec 2025 09:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764841717;
	bh=si+8MTGO26F/F4k3uMd0juQ9tO6Gxb5QxflpsHGJ3G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4bU6XTcdt+v3Kdol3M/Ni3Kd3j/0yJoYVLUn0MstA+PTCT1eXJcCxGzfq+eI/axC
	 eW6qRv6dEd+M1j6y7jsm+TCv40RS+kJ01gAXFPyZ9tJAg8LWbK3rXLwYwwqH4Sls4N
	 9BppbVn8/nblB4QsNI1t0AuW//7z/EXp0ieJ769DpE493ByBA2Z24WHHPO+tWgyrfI
	 3RQXTOBPhqEbuGH+HblKV/8KBlPxkxmY0eJ6k2Ycw5NIhylTsJ3gC6WHAIJHxqYmad
	 QCAHdz5XgxcW1QLzbtmo1rzQNbaQw/8mcK2VBUFJ6q7pvHRcqge3qEL1DcSWJknEq6
	 rsPrnzMTPcwcQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vR5ww-0000000AP90-1fVv;
	Thu, 04 Dec 2025 09:48:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v3 1/9] arm64: Repaint ID_AA64MMFR2_EL1.IDS description
Date: Thu,  4 Dec 2025 09:47:58 +0000
Message-ID: <20251204094806.3846619-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251204094806.3846619-1-maz@kernel.org>
References: <20251204094806.3846619-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_AA64MMFR2_EL1.IDS, as described in the sysreg file, is pretty horrible
as it diesctly give the ESR value. Repaint it using the usual NI/IMP
identifiers to describe the absence/presence of FEAT_IDST.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
 arch/arm64/tools/sysreg            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 82da9b03692d4..107d62921b168 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -134,7 +134,7 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
 	MAX_FEAT(ID_AA64MMFR2_EL1, UAO, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, IESB, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, AT, IMP),
-	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, 0x18),
+	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, TTL, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, BBM, 2),
 	MAX_FEAT(ID_AA64MMFR2_EL1, E0PD, IMP),
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 1c6cdf9d54bba..3261e8791ac03 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2257,8 +2257,8 @@ UnsignedEnum	43:40	FWB
 	0b0001	IMP
 EndEnum
 Enum	39:36	IDS
-	0b0000	0x0
-	0b0001	0x18
+	0b0000	NI
+	0b0001	IMP
 EndEnum
 UnsignedEnum	35:32	AT
 	0b0000	NI
-- 
2.47.3


