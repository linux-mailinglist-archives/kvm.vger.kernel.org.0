Return-Path: <kvm+bounces-38302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D760DA36FD5
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 18:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 929AA188C655
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 17:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E281FCCF7;
	Sat, 15 Feb 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNux1FGS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C65B1EA7E2;
	Sat, 15 Feb 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739641103; cv=none; b=clXWh8PJJ4pgw0AAFUbjdyKR7E8EKqXE0us9gG4SegBlhqQy48bAjkDd0i/AJje1dHK8tDxdlE3WZ1Qb0qcXfSWBaxy+blPt7V470O4qwuASeWfYmufSw9qPFxSqPf4quLxWsd0BFYkcS6ZuUDm1gWIo19D1r3TDZzzZNHUCrh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739641103; c=relaxed/simple;
	bh=QU3/C06IpfcUbhRM6dRoR9sRaAPsFdhqwZsnX766PyE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bEsmUrLtqXdV6qRM1mNE6pIXail7SAaOj+jTQXLHbk+XUsRYAEinMLA/0kEQYU7b451M7ZgdR4fX/bzWX5c4Xi3+lt4HlM5tv2USaV49pi1SMEzrlL0hqJYfRIjIsZSBO+44IFzJFgdeFBYdqEwy3OZ4GcwGOMYQwF7n+GXiqMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNux1FGS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B011C4CEDF;
	Sat, 15 Feb 2025 17:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739641103;
	bh=QU3/C06IpfcUbhRM6dRoR9sRaAPsFdhqwZsnX766PyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNux1FGStfkiy1bGuwKYEIlDbu+fzRlDSlEUIX6EUwY8XpFxxwV9ftNFmJzEygCUN
	 2G+x17ykJ0Vd0215ZpYsrOos5UVKBpg/BUd7ayQJyWGvGdiWr8QrS99c1z6Ky92iWl
	 kNDZK0DstoeS1DSO51dvhnRE1F983xiB+qtcnru+nde+2bUaSzqO14PL8myijGrCnv
	 oJz4cXzcgTLVmP578gYJPcqhc/ZZquca26R0AyRIIMYXsuqQAJQ7nQp8sPPtY8Zc4x
	 MWEKUycBndDWwZDCHKFP44oB84GvfqZaTtbt0OmZkgnw1GBdQjdcWNej/UGUEMiRHk
	 FzszHTWI0WA7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjM7R-004Pqp-EP;
	Sat, 15 Feb 2025 17:38:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 06/14] KVM: arm64: Consolidate idreg reset method
Date: Sat, 15 Feb 2025 17:38:08 +0000
Message-Id: <20250215173816.3767330-7-maz@kernel.org>
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

Since all the ID_DESC() users are using kvm_read_sanitised_id_reg()
as the .reset method, consolidate all the uses into that particular
macro.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9f10dbd26e348..b1bd1a47e7caa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2270,14 +2270,14 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 #define ID_DESC(name)				\
 	SYS_DESC(SYS_##name),			\
 	.access	= access_id_reg,		\
-	.get_user = get_id_reg			\
+	.get_user = get_id_reg,			\
+	.reset = kvm_read_sanitised_id_reg
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
 	.val = 0,				\
 }
 
@@ -2286,7 +2286,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = aa32_id_visibility,	\
-	.reset = kvm_read_sanitised_id_reg,	\
 	.val = 0,				\
 }
 
@@ -2295,7 +2294,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = id_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
 	.val = mask,				\
 }
 
@@ -2304,7 +2302,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	ID_DESC(sysreg),				\
 	.set_user = set_##name,				\
 	.visibility = id_visibility,			\
-	.reset = kvm_read_sanitised_id_reg,		\
 	.val = (mask),					\
 }
 
@@ -2319,7 +2316,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.get_user = get_id_reg,				\
 	.set_user = set_id_reg,				\
 	.visibility = raz_visibility,			\
-	.reset = kvm_read_sanitised_id_reg,		\
 	.val = 0,					\
 }
 
@@ -2332,7 +2328,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	ID_DESC(name),				\
 	.set_user = set_id_reg,			\
 	.visibility = raz_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
 	.val = 0,				\
 }
 
-- 
2.39.2


