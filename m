Return-Path: <kvm+bounces-38698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A16CA3DBAE
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB1F219C19DB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAF61FE449;
	Thu, 20 Feb 2025 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPYIIRTN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7731FAC48;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059355; cv=none; b=GLFkmdHLMb1gLBq+wAHhkt/MHZBSUJmJawWKz4rcR+Wnu1sqMapuXk3XgTnbDUEs9GNGAFHjYVlA4zEgWBWAeQKEvG7l7k5TzY0pDmtbQkFZAs2Ap4bRyWx6ff2tYOpYYkfJ1EsXN6cLGXYtFoet5bj47ZE+ns9oxkrExEnvaHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059355; c=relaxed/simple;
	bh=hLX78IQJhSjho4blNERHsZLoh+IQBUydLUQRnCHy3Bg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SYM1bcKkYHfP57AjFu80dIhg1SumKVgqxDl1eY6YB3vUokkGIB/aXGBNrNuHDbsMaWaJ2h7HBs+8NhClF3+V/VacYssnRHnXeNCezxRi6o8XwXlI8vekPCMr2mCUMBAycBsIEO5sALxPhMy10fhInUeLWj3D772R6d5ftH3OQEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPYIIRTN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A9CC4CEDD;
	Thu, 20 Feb 2025 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059354;
	bh=hLX78IQJhSjho4blNERHsZLoh+IQBUydLUQRnCHy3Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPYIIRTNVqeMFiMlGsrveziYs/FAPq/tsRf1aGRuKJWBjsBpcqrUq7ZXO0FCA/1dV
	 4O5p8lUcoyxepZOSqU9fsMZFdMlO8oKymJTf2SPpVQOTCqSsZ+TbmoNwQOH6mBoIeb
	 pAvs/K/diNS3rID6Wg5OsBKTyy9aGOhTKipYejkwiOWCNp34o9EynI5VaocOY1FxlZ
	 AsHkHGvw5dHy6jsy7qqIj83v3WPV042D1lIp93SF/AnH/akMfMIVhtBBeemYv/RURK
	 laWUV9zzz+LcwwtFlTa3QtMKGu6L5N+gEqb2E866P8db9jDbSVTqQD3GXNQU8TcE19
	 /qfUBc920zGxg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vQ-006DXp-QN;
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
Subject: [PATCH v2 06/14] KVM: arm64: Consolidate idreg callbacks
Date: Thu, 20 Feb 2025 13:48:59 +0000
Message-Id: <20250220134907.554085-7-maz@kernel.org>
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

Most of the ID_DESC() users use the same callbacks, with only a few
overrides. Consolidate the common callbacks in a macro, and consistently
use it everywhere.

Whilst we're at it, give ID_UNALLOCATED() a .name string, so that we can
easily decode traces.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9f10dbd26e348..678213dc15513 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2267,35 +2267,33 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
  * from userspace.
  */
 
+#define ID_DESC_DEFAULT_CALLBACKS		\
+	.access	= access_id_reg,		\
+	.get_user = get_id_reg,			\
+	.set_user = set_id_reg,			\
+	.visibility = id_visibility,		\
+	.reset = kvm_read_sanitised_id_reg
+
 #define ID_DESC(name)				\
 	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg			\
+	ID_DESC_DEFAULT_CALLBACKS
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	ID_DESC(name),				\
-	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
 	.val = 0,				\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define AA32_ID_SANITISED(name) {		\
 	ID_DESC(name),				\
-	.set_user = set_id_reg,			\
 	.visibility = aa32_id_visibility,	\
-	.reset = kvm_read_sanitised_id_reg,	\
 	.val = 0,				\
 }
 
 /* sys_reg_desc initialiser for writable ID registers */
 #define ID_WRITABLE(name, mask) {		\
 	ID_DESC(name),				\
-	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
 	.val = mask,				\
 }
 
@@ -2303,8 +2301,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 #define ID_FILTERED(sysreg, name, mask) {	\
 	ID_DESC(sysreg),				\
 	.set_user = set_##name,				\
-	.visibility = id_visibility,			\
-	.reset = kvm_read_sanitised_id_reg,		\
 	.val = (mask),					\
 }
 
@@ -2314,12 +2310,10 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
  * (1 <= crm < 8, 0 <= Op2 < 8).
  */
 #define ID_UNALLOCATED(crm, op2) {			\
+	.name = "S3_0_0_" #crm "_" #op2,		\
 	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
-	.access = access_id_reg,			\
-	.get_user = get_id_reg,				\
-	.set_user = set_id_reg,				\
+	ID_DESC_DEFAULT_CALLBACKS,			\
 	.visibility = raz_visibility,			\
-	.reset = kvm_read_sanitised_id_reg,		\
 	.val = 0,					\
 }
 
@@ -2330,9 +2324,7 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
  */
 #define ID_HIDDEN(name) {			\
 	ID_DESC(name),				\
-	.set_user = set_id_reg,			\
 	.visibility = raz_visibility,		\
-	.reset = kvm_read_sanitised_id_reg,	\
 	.val = 0,				\
 }
 
-- 
2.39.2


