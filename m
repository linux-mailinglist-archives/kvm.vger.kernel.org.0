Return-Path: <kvm+bounces-64551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C0859C86D68
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:41:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 08BAA350D71
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B9E33A02D;
	Tue, 25 Nov 2025 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ri//HlS/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07F9274B59;
	Tue, 25 Nov 2025 19:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764099705; cv=none; b=Dk9lKaUZhuQPr2R9EYzilVRTiGAayZFOqb6iGpQjgqA2bSmOpBdQp7rujM+ZsCFhdlkOHaK5oq7Ib72mkvxFjh9lHDiPBAiHuaGWo9XO7WVOwLFLOwA30UR4XYNB8Rc8wT3W0e3bxwBM2lOvg30Jkc6uV+t2EWlg/wfixeDEw4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764099705; c=relaxed/simple;
	bh=q1XrjBDBdd+NI+CU1uTxO0pJaAQ+bVffaYJhhaFxauQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OhzxDl+v9DlkgJzWkI0l8/4cKMRXP0CKPtalSQhAwQ+hl3metmIOKSQR6P5ZBzAD23YBHzWI+Krw14HDApCWmHZVOaPAuoA0llK8wx++UG8IL1QFcIMowk82PEIztKjCAXAv1yaXCHNkJwVsjEJMrjRpNO5DA1TAWO40JcFQSf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ri//HlS/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD6CC4CEF1;
	Tue, 25 Nov 2025 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764099705;
	bh=q1XrjBDBdd+NI+CU1uTxO0pJaAQ+bVffaYJhhaFxauQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Ri//HlS/rWxwFVTtjDva4j/if+FF9A0+ocX/LBtvCM1iUVyYF+HV7lFyslkhQLj5h
	 bYmGkQEuFQyH7NZTbZJTCofjUJBy5wmF19PWxLnAImrsJbu6g2PaX0CB7ilcMy9oG1
	 JDnUbneEs1ePLz7svQVGE3P0hifg3R8nONn/mErdSv3z+NosCPnkaFpmZRZNYBwaW5
	 fFY+8KF/TeoZNsAb9jb+nSKTxSpQh+/dwzv/ShfUQ7VnAa9S78msCP8dzSbzVSiajv
	 IEodzobJg/S+/cdEOz8UeJUd9RbcdZ4lOsjNDROgKhs5LjOIz/51y9ymkhMvYRTIP9
	 CZsFdPcwp+4LQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vNyv0-00000008GGi-3P2p;
	Tue, 25 Nov 2025 19:41:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: arm64: Add endian casting to kvm_swap_s1_desc()
Date: Tue, 25 Nov 2025 19:41:37 +0000
Message-ID: <20251125194138.1097971-1-maz@kernel.org>
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
when swapping S1 descriptors.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511260246.JQDGsQKa-lkp@intel.com/
Fixes: c59ca4b5b0c3f ("KVM: arm64: Implement HW access flag management in stage-1 SW PTW")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
-- 
2.47.3


