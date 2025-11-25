Return-Path: <kvm+bounces-64563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDEC5C8727C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0E933B31DD
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E472E1C6B;
	Tue, 25 Nov 2025 20:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9mZv298"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19E2629D;
	Tue, 25 Nov 2025 20:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764103734; cv=none; b=gO5PUfBecJA+o+1D1DMRK67QjJFlj/Ivgdl/Ew0akyYNs5ZOYfk1GPRbjuu46d9yMol8sGGZUPTPirsE8GcTROjyen1hCiAmhSUTP3Xd2d9Cr+uIxaB1agiscyAq0PIwUlhLaadwF/jdM0HGAR+a8edkVGzKjphcpfV9M65VEGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764103734; c=relaxed/simple;
	bh=JK/jjvYSwgAGtXn2/4YtYuj6bvcT8tHZpTXPO//omWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dw8JipLO5i2n1qpN0TV0JdvfbtFXwTuzJ5hnGAZ+CvvukRFOgrWwux6hzVknxyeoHtPM2Wb8nImdsKtLgpRQUYo3ic4jTAAc0RhvEdW3rUR5vEavkeuiUQ4WLnSJCD2IKzLHCtktmdux1F+FXLeznzKpknHDxLgNDC9vQwlwB5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t9mZv298; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0FCC4CEF1;
	Tue, 25 Nov 2025 20:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764103733;
	bh=JK/jjvYSwgAGtXn2/4YtYuj6bvcT8tHZpTXPO//omWg=;
	h=From:To:Cc:Subject:Date:From;
	b=t9mZv298Wpa5eTpRc/cfeMLeKRD7X1tEKMrtXLVf/QISI3Crlp6vonCAvSPxWQsZY
	 ro+iytmds2t16rpz2mdFFyA4Q4PJOfadM9IcZEdnyiWmGJQC3Q0oLaGlUCjVHbzq8d
	 NLxScvnNk6R8dlh9BJIpPLBiknpId/E1OGH4rpB9lKs+E9wgvABFin1JjAiASSzh6W
	 i0r+a3+6yKpu4ABehDmL8J273pok8USYQHeZc4emMz5Z+u+/r/8jub4O0qifFJjHNl
	 QZR22SlP707NVF3dA6Ghczg1rDcfZf07sz+CbJAF6zHeKqhLtE+ZkABDzVdYzowhmi
	 75GJtcxBvhz+A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vNzxz-00000008HI3-3DX2;
	Tue, 25 Nov 2025 20:48:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2] KVM: arm64: Add endian casting to kvm_swap_s[12]_desc()
Date: Tue, 25 Nov 2025 20:48:48 +0000
Message-ID: <20251125204848.1136383-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, lkp@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Keep sparse quiet by explicitly casting endianness conversion
when swapping S1 and S2 descriptors.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511260246.JQDGsQKa-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202511260344.9XehvH5Q-lkp@intel.com/
Fixes: c59ca4b5b0c3f ("KVM: arm64: Implement HW access flag management in stage-1 SW PTW")
Fixes: 39db933ba67f8 ("KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---

Notes:
    Missed the S2 issue the first time, and only caught up with
    the robot's email.

 arch/arm64/kvm/at.c     | 8 ++++----
 arch/arm64/kvm/nested.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index f774a02d9393b..d25fef0f66e21 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -386,11 +386,11 @@ static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
 			    struct s1_walk_info *wi)
 {
 	if (wi->be) {
-		old = cpu_to_be64(old);
-		new = cpu_to_be64(new);
+		old = (__force u64)cpu_to_be64(old);
+		new = (__force u64)cpu_to_be64(new);
 	} else {
-		old = cpu_to_le64(old);
-		new = cpu_to_le64(new);
+		old = (__force u64)cpu_to_le64(old);
+		new = (__force u64)cpu_to_le64(new);
 	}
 
 	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c3033d1fe718c..cdeeb8f09e722 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -224,11 +224,11 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
 			      struct s2_walk_info *wi)
 {
 	if (wi->be) {
-		old = cpu_to_be64(old);
-		new = cpu_to_be64(new);
+		old = (__force u64)cpu_to_be64(old);
+		new = (__force u64)cpu_to_be64(new);
 	} else {
-		old = cpu_to_le64(old);
-		new = cpu_to_le64(new);
+		old = (__force u64)cpu_to_le64(old);
+		new = (__force u64)cpu_to_le64(new);
 	}
 
 	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
-- 
2.47.3


