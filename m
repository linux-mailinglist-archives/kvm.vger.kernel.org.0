Return-Path: <kvm+bounces-65280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D11CA3FEB
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 15:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EFD3D301AD23
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 14:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF71C34104D;
	Thu,  4 Dec 2025 14:23:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB8E21CFE0
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858229; cv=none; b=cbD6yU25ySkLOEG5LbqpB2SB4tXqeB3b4P+cXQiecm/seBVXeKxM8onGKpR0uMzdnjpczN4PGOr2yMpcBA3h4gIsI6+olvfgutZwAfPuQ4wPopO8BkWxzsKj2r/O6IZeZzPdVacDWzai2sMMbHsTBzItKKrsVCDZxUmG07uSpzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858229; c=relaxed/simple;
	bh=AQ05VoVrya+r4oDU0jIKRSlGB+3aPZGgmGxytlximaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dB7Mee863qsdYt6ldVaEwj5p8pjuASE38MhJ9XqulRRLBK76gJGBQvpBBMf2k0yuUozOSWuepB9bflo7Lomq/+5PIyGfLb+IE7Bdl+fuYsnhSH5fFO7yHsYHy26zapnBPyYELeZ/m9ZmYJO8XLUY+lQMlJTu05RCPrQznJSgZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 078501575;
	Thu,  4 Dec 2025 06:23:40 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E53863F73B;
	Thu,  4 Dec 2025 06:23:45 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v4 01/11] arm64: set SCTLR_EL1 to a known value for secondary cores
Date: Thu,  4 Dec 2025 14:23:28 +0000
Message-Id: <20251204142338.132483-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251204142338.132483-1-joey.gouly@arm.com>
References: <20251204142338.132483-1-joey.gouly@arm.com>
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


