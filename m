Return-Path: <kvm+bounces-9800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DF88670B8
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAA031F2CD58
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB96258108;
	Mon, 26 Feb 2024 10:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DL5dlkHI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DF457898;
	Mon, 26 Feb 2024 10:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942063; cv=none; b=GPetUm+QeRDfRynW5EzsN15FQQq7MHrkzd7f7ScxjIPkjMu5pFiCe1TQ6/HVfR+9lwnYsFHZqCK6fc7dVg5cOsjecodTr+JPLR1FFYukaQXswFH30xStEB67HNUM+kXyP5LnGlPRoPxYQjtvhFYKZcUZzOnY4tnJoNc14QEmp3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942063; c=relaxed/simple;
	bh=63HmN5bCw4yV1qIue0vyjz/ZbDoxT4DvgQFZU7t3gk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uwccHZF7ndeEXXhRJtW0aeCqCBNhx2jUheEhjqyWNn5MnTUXH30hPQ4R9upMiLVT9w4xlSSC6ps/i+dLUdadTadsi1MK9+PEKly5w3rp8IwmF3uZo06KswsuF3Pi4TeBBuxoL2pcbPyJ8xY8wmjqG44nRwHLoX/qrGyoOOmMbeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DL5dlkHI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922DDC433C7;
	Mon, 26 Feb 2024 10:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942062;
	bh=63HmN5bCw4yV1qIue0vyjz/ZbDoxT4DvgQFZU7t3gk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DL5dlkHI47lmnA625/1WTaWJiR21N8DYzo4vnkSFEg8Ylhx5elfNUQXvFKtYtd7bx
	 mthQPgigxFpKzhbgslNj/lWoqJkfbILyms+aZYODtuzOSyLG3rGcEmRpySmAfoDw2q
	 N+huvi+IR2zVP248n25U41AsYLBj5LNl+W9yzMOUFjF41Q0lu0+Mg3CXon/VjRUnNJ
	 Tj7IJ1G+baH0rSWKKByk+s4DfTAv2snc1QHd595MeVeDcwwWJKcr0+CS3cKMH/5v/i
	 qkCpzKRNGMCppXN8Ej3T0yFdSvWiflMJKa+rmm/bXpxkX4SuwLyJx4b1+dYwLztxXO
	 bDeVNQOytyMOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtZ-006nQ5-DO;
	Mon, 26 Feb 2024 10:07:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 10/13] KVM: arm64: nv: Add kvm_has_pauth() helper
Date: Mon, 26 Feb 2024 10:05:58 +0000
Message-Id: <20240226100601.2379693-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100601.2379693-1-maz@kernel.org>
References: <20240226100601.2379693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Pointer Authentication comes in many flavors, and a faithful emulation
relies on correctly handling the flavour implemented by the HW.

For this, provide a new kvm_has_pauth() that checks whether we
expose to the guest a particular level of support. This checks
across all 3 possible authentication algorithms (Q5, Q3 and IMPDEF).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 75eb8e170515..a97b092b7064 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1334,4 +1334,19 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, min) && \
 	 get_idreg_field((kvm), id, fld) <= expand_field_sign(id, fld, max))
 
+/* Check for a given level of PAuth support */
+#define kvm_has_pauth(k, l)						\
+	({								\
+		bool pa, pi, pa3;					\
+									\
+		pa  = kvm_has_feat((k), ID_AA64ISAR1_EL1, APA, l);	\
+		pa &= kvm_has_feat((k), ID_AA64ISAR1_EL1, GPA, IMP);	\
+		pi  = kvm_has_feat((k), ID_AA64ISAR1_EL1, API, l);	\
+		pi &= kvm_has_feat((k), ID_AA64ISAR1_EL1, GPI, IMP);	\
+		pa3  = kvm_has_feat((k), ID_AA64ISAR2_EL1, APA3, l);	\
+		pa3 &= kvm_has_feat((k), ID_AA64ISAR2_EL1, GPA3, IMP);	\
+									\
+		(pa + pi + pa3) == 1;					\
+	})
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.39.2


