Return-Path: <kvm+bounces-68019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73581D1E98D
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 12:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D3663044873
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263282F3608;
	Wed, 14 Jan 2026 11:58:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD1539447C
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391931; cv=none; b=RPaiSuR/n8PTjh69rE+AJfRHuF8Vxa1oln7YjnGuPg8VK7LsWGgg4RuucU9PJvh/tWE87zmAI7nq/c59AOPktx5gZW+0EfXo7YSaj4kIIQmH87rDFE1Oulxs+X9+I6E4kkMK7G+dx6yNv/G3dvRLlyskcpEy4BLjdOsMvml1u/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391931; c=relaxed/simple;
	bh=Mdgjubedp24vdBglgtszpCoCNNLe4oxprQMU53F560k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XJzZNs3nB2yEoTWEaid3UPeDXz7m0J8Fb3H2Qx2lPOrO1m+q9UcwBXmZ6n0E+inc8bPuwaVTN82M7VmfCeolQkKU7HS2KjeQzYX4gORP/SX2eMIAyfbuOfEMXfv1R4IZ6hBpVUoFap88r4yZelAF3iF0cE8esM1hMHN79exRyYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BEAE1515;
	Wed, 14 Jan 2026 03:58:39 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 002E43F632;
	Wed, 14 Jan 2026 03:58:44 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 01/11] arm64: set SCTLR_EL1 to a known value for secondary cores
Date: Wed, 14 Jan 2026 11:56:53 +0000
Message-Id: <20260114115703.926685-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This ensures that primary and secondary cores will have the same values for
SCTLR_EL1.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Fixes: 10b65ce77ae7 ("arm64: Configure SCTLR_EL1 at boot")
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/cstart64.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 014c9c7b..dcdd1516 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -185,6 +185,11 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+	/* set SCTLR_EL1 to a known value */
+	ldr	x0, =INIT_SCTLR_EL1_MMU_OFF
+	msr	sctlr_el1, x0
+	isb
+
 	/* enable FP/ASIMD and SVE */
 	mov	x0, #(3 << 20)
 	orr	x0, x0, #(3 << 16)
-- 
2.25.1


