Return-Path: <kvm+bounces-45646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CF58AACB6C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3A861C25565
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D93288C12;
	Tue,  6 May 2025 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlSsfvFT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE08C288521;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549856; cv=none; b=AdDSIPPSZRJcyvGjB5i2alUI2/4O/lMMSKbkInZmW3ooaJC5B/Eig+FsFKlZ0UKfHDEqxFIwTjIUWHMxnUTZ3G8fUj2o9EqbaWjv3pnsl6ILuDPi8a3mCFdXKajvwpQw+kLxlEuIcAUJm8eG+B6RfFAHFTziH4oZ0C+JBBgkKtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549856; c=relaxed/simple;
	bh=xZoAbmM+hMY8JchzItb56G4GAlsrEEMidF7bm78opo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TltJkXeknRGGd2bWufpeTkLjI/uIhFxEgwpyOfEWJWkKNj3/vc2m3kUT1S64Tfx3AYC2UDSmqEry3b5FEB/FQOVjiG7omlBJMSnWtlvprXEAAo32LoRVp8rgTEgaSluyl9UvJQGknX44avNi9V+TP+UGrhk4sS42u0BhVzyr9jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlSsfvFT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED4AC4CEEF;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549855;
	bh=xZoAbmM+hMY8JchzItb56G4GAlsrEEMidF7bm78opo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlSsfvFTXq42EEd+m0NWMOYZmDywr8KGLaPWxg/nShXiXAxi07f3+vZ1K4lc+Hn6A
	 yh+//Ey6iE6RAKFkXEiA59lUJEOL93x6kjJC6pB9dUeUwTEMsIwD/4k5sCpDL/MBSF
	 3Xif6wp1MwTr2Tuenk/tMC+5VNOPNP4v1+uYRehQjx78u1GJIAzmsD6hexrxbaW9rp
	 uabHmoRFSph+FFKY6/uVLIVdn4qh6sgvF4un/0c7O0YJSlNh/8DQaAQMiju66hQ90O
	 vbQHDpVRtbpI5j7WlIMyV9eGb0RHjbJNyq0gvmYe29vt7CbLrb1BR7tqGE/hhdvc6u
	 mQQ8xiKjdZX4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOw-00CJkN-2b;
	Tue, 06 May 2025 17:44:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 34/43] KVM: arm64: Allow kvm_has_feat() to take variable arguments
Date: Tue,  6 May 2025 17:43:39 +0100
Message-Id: <20250506164348.346001-35-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to be able to write more compact (and easier to read) code,
let kvm_has_feat() and co take variable arguments. This enables
constructs such as:

	#define FEAT_SME	ID_AA64PFR1_EL1, SME, IMP

	if (kvm_has_feat(kvm, FEAT_SME))
		[...]

which is admitedly more readable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0eff513167868..3b5fc64c4085c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1572,12 +1572,16 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	 kvm_cmp_feat_signed(kvm, id, fld, op, limit) :			\
 	 kvm_cmp_feat_unsigned(kvm, id, fld, op, limit))
 
-#define kvm_has_feat(kvm, id, fld, limit)				\
+#define __kvm_has_feat(kvm, id, fld, limit)				\
 	kvm_cmp_feat(kvm, id, fld, >=, limit)
 
-#define kvm_has_feat_enum(kvm, id, fld, val)				\
+#define kvm_has_feat(kvm, ...) __kvm_has_feat(kvm, __VA_ARGS__)
+
+#define __kvm_has_feat_enum(kvm, id, fld, val)				\
 	kvm_cmp_feat_unsigned(kvm, id, fld, ==, val)
 
+#define kvm_has_feat_enum(kvm, ...) __kvm_has_feat_enum(kvm, __VA_ARGS__)
+
 #define kvm_has_feat_range(kvm, id, fld, min, max)			\
 	(kvm_cmp_feat(kvm, id, fld, >=, min) &&				\
 	kvm_cmp_feat(kvm, id, fld, <=, max))
-- 
2.39.2


