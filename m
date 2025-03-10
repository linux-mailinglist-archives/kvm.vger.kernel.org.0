Return-Path: <kvm+bounces-40637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E49E7A59448
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E90E168B6D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D094922B8C0;
	Mon, 10 Mar 2025 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xse3VCZD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE0022B595;
	Mon, 10 Mar 2025 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609518; cv=none; b=Nmy5pHUM2HQtc2wV8xKgYqYhO6ae76M2sB7ePenLBdX2sdbeObj4HTIcdLX/kVjI3Kv4IawBniQ81aD5rXQ9/qCBjfr0EpByP+vE0czbn/zVs9TOCz94gH+o5uT8bhxGWkwKChfLDBVRbdMCZTJHft3xd58YHDdVfm1ZhRO9GLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609518; c=relaxed/simple;
	bh=c4i86duoXEmDwXPSOJ2OB2+MENRRYS3JIWDrzcjnE64=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zce2ejP0qaIpaCVICluLV4rmAzVfF9ZojSGVWSaU7o7oIWuhDbls/+9X7Caa30338DJZfdQ78rA5i2TLg2VxFd+Y+amOpfKr7QG0rd+DaYHqQSm9ydRtjQCoVbVM7OP90KAtVAMKZ+2Ms30PR7mFVmRnsGS7pUU+BI54Q3bzbhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xse3VCZD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2ADC4CEF0;
	Mon, 10 Mar 2025 12:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609517;
	bh=c4i86duoXEmDwXPSOJ2OB2+MENRRYS3JIWDrzcjnE64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xse3VCZDp/4QeTj9roEwXnXyvPxMGR4YqQZtjRKZUb/hZX8dR111DFEYzsgjsvtvI
	 QgE05en97Soy+vjp1WWLadzMT93kgPzabZmOLL8S9IlbjazGjyMJDmBv8WXj2T1slp
	 N2QdFQjusozhnL5U+dCmTt15Yj/HCLw5A5JNioVIk9PznLNAdW3wC6aT4EN5u5HKzY
	 afnj1ndq58gGwviv0tRJnna7ImmUQjQzfo3YzIgAgbwJCCgoTFqsyHTNZLK6yoYoxL
	 k20VynlBZDFZuni/wYvicUeWJ8oaRkggzhOTDnM1s+1mMJLpUJide2ManQAPwlet5+
	 lOq+pfr3yG4lQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcC3-00CAea-Lm;
	Mon, 10 Mar 2025 12:25:15 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 21/23] KVM: arm64: Allow kvm_has_feat() to take variable arguments
Date: Mon, 10 Mar 2025 12:25:03 +0000
Message-Id: <20250310122505.2857610-22-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
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
index 9bac3c6800294..89f8415fea063 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1526,12 +1526,16 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
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


