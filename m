Return-Path: <kvm+bounces-54346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D201B1F502
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 16:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43D69563417
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 14:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6337C2BE057;
	Sat,  9 Aug 2025 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DE3Bhcyz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E198F6E;
	Sat,  9 Aug 2025 14:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754750902; cv=none; b=NkLslDzvA2VsMNVsvR16vwbqsxAz6b5763NH03lBnv4AP0qOLVe3ukLNQo5kLW6kXHeFO4xddn/XND4HoEY+P8EYnZa4wlCumA7lJDxs+Jof7GZ1IJOT7oNyHsBY9yjJs7EawWpEu9E1L2FFiTnLzU9wCY+RI5ZPPAVkQNDi6qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754750902; c=relaxed/simple;
	bh=tQJASm8aH44i/KGmtlC/YVwcBXyOdMk6jpYTylxFeag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rd3xzKz+yJwJIuJK+Q/Y5RuSAvsyM5LasrVnsfiCXGpdTz4+6BJ61wMritgMCkGv41N4XN77xlORRTHEvKfsGTE5/+UCtFGyuZRs5MAHrHZEXOA3O3PZfFD5iQoHGMfdQpCndrIxkXfrEydKWpXSP4h7Chk9gOMNUPo3AjXcfJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DE3Bhcyz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082CAC4CEE7;
	Sat,  9 Aug 2025 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754750902;
	bh=tQJASm8aH44i/KGmtlC/YVwcBXyOdMk6jpYTylxFeag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DE3BhcyzzLLWP6RIECv2n6Rkklaq1bx+l7gtzPmjlecPTS5W3RvumiXgsCVMR2LPd
	 FOCwzQ/H7MXKfaErfjUsXkDTwk1fNzavdr9q60Mznibgx+bILe9kCjIgSyliVK+8Z+
	 sL+AFABq1CJ6XkcbquVO6D7HLxcLVkxsJyJiQsA3ZqrhHS0aOyl0dZzWC68ZSwpl71
	 wZYvUYEvaHXEn/BWypf+cP0j07Ccg3xVPUVuzMm+X3Dj0YY0VNslXKrF0ogyoHsqCN
	 +cRYft5U9GvMCQHejK8ZwMweDZbooGLIwVXct306dutCA1VBvSSCzJT1c1zBGQpacZ
	 r2Zt4EL9YqwUw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ukkrm-005eZC-VO;
	Sat, 09 Aug 2025 15:48:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] KVM: arm64: nv: Fix ATS12 handling of single-stage translation
Date: Sat,  9 Aug 2025 15:48:10 +0100
Message-Id: <20250809144811.2314038-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250809144811.2314038-1-maz@kernel.org>
References: <20250809144811.2314038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, volodymyr_babchuk@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Volodymyr reports that using a Xen DomU as a nested guest (where
HCR_EL2.E2H == 0), ATS12 results in a translation that stops at
the L2's S1, which isn't something you'd normally expects.

Comparing the code against the spec proves to be illuminating,
and suggests that the author of such code must have been tired,
cross-eyed, drunk, or maybe all of the above.

The gist of it is that, apart from HCR_EL2.VM or HCR_EL2.DC being
0, only the use of the EL2&0 translation regime limits the walk
to S1 only, and that we must finish the S2 walk in any other case.
Which solves the above issue, as E2H==0 indicates that ATS12 walks
the EL1&0 translation regime.

Explicitly checking for EL2&0 fixes this.

Reported-by: Volodymyr Babchuk <volodymyr_babchuk@epam.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: be04cebf3e788 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
Link: https://lore.kernel.org/r/20250806141707.3479194-2-volodymyr_babchuk@epam.com
---
 arch/arm64/kvm/at.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 0e56105339493..d71ca4ddc9d1e 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1420,10 +1420,10 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		return;
 
 	/*
-	 * If we only have a single stage of translation (E2H=0 or
-	 * TGE=1), exit early. Same thing if {VM,DC}=={0,0}.
+	 * If we only have a single stage of translation (EL2&0), exit
+	 * early. Same thing if {VM,DC}=={0,0}.
 	 */
-	if (!vcpu_el2_e2h_is_set(vcpu) || vcpu_el2_tge_is_set(vcpu) ||
+	if (compute_translation_regime(vcpu, op) == TR_EL20 ||
 	    !(vcpu_read_sys_reg(vcpu, HCR_EL2) & (HCR_VM | HCR_DC)))
 		return;
 
-- 
2.39.2


