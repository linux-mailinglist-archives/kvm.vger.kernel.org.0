Return-Path: <kvm+bounces-44445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07C0BA9DAB0
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731949A20D0
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B264254B14;
	Sat, 26 Apr 2025 12:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0x231l5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA29254870;
	Sat, 26 Apr 2025 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670540; cv=none; b=CY+JpBecONCR+x4lEFT+2yBZan4Y6vA8o/zmUSR6E97UO7R3x1fMIZJGJWDOsLiZ3W1K6YqLOuJRO88VLW0E/4oWmuKV34yPEF3xjrudv9ekuJ1TELrkJ6JE4+jcOJ+f+rG9dQRmq1BarqtlrCvC8W61amKOt+9psZQ+aLjmvVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670540; c=relaxed/simple;
	bh=xZoAbmM+hMY8JchzItb56G4GAlsrEEMidF7bm78opo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U1IoJv1qxQyfOrDiQypGbPpLV8RdAxM0YxSzv0HxE12+PJsDHSUvTCnJDTEkdzUIEArKJGB8KOqVhrIhVQ4sUH5LJLe16OHUTou3e6kxnhjfnsLz2ebWIVe00ziY4HnsqK19DLCKFKeA3C7m6qOFCzemOp13sR0XdadTUiAkxNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0x231l5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C23C4CEE2;
	Sat, 26 Apr 2025 12:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670540;
	bh=xZoAbmM+hMY8JchzItb56G4GAlsrEEMidF7bm78opo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0x231l5XB6A/Xun2TPj9KmOhzGcdmJsAvFWVrZVbmDG1zAre+IX5CfuV5sA2ea7B
	 N88QgA0E8tlMJZwl2yAHgS7DcIf2fIR1q/UTreyax/yahocq/Bk6e7ZQ9zo2BPia6b
	 I0+oAJu1pRyLjVjEK59oc5k1tif5CHhoyyaEJpsb/TvI7sqyLJmKJC8itMRbXquT0J
	 Dug5swGEtsnOG7D/fvhQFmlKq5uAGAeD/voX/NKn5RGwuZyUzPucqf0Zgvc0v0AVQl
	 DoJwxX8cToS76HAeDIixIGkyxhtjA3YcClXANzzhAZkgMuDulrEPZFLj3N6xIO2WMo
	 e0Hj2it0Oo4Qg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeQ-0092VH-5z;
	Sat, 26 Apr 2025 13:28:58 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 33/42] KVM: arm64: Allow kvm_has_feat() to take variable arguments
Date: Sat, 26 Apr 2025 13:28:27 +0100
Message-Id: <20250426122836.3341523-34-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
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


