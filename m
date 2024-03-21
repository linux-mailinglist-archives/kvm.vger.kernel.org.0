Return-Path: <kvm+bounces-12414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4867F885CB4
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01345281A35
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6944712C533;
	Thu, 21 Mar 2024 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZnBJARK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE612BF09;
	Thu, 21 Mar 2024 15:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036473; cv=none; b=B0+rbJ6cdpJg1milaBZHu4i9LeYUO3B4Qd8vCZesoRy/rz52b3loNQyHJ6lcJXK6UQZjjzXN+KEI1OYAHAQSAFsDlBrDqL6to+fMpuy39c1MY1NbCmPE+LvPgrHmgp6MZ9UDgpdPzAnjuqlx+Snaf8C7zrcX0hpDgnZzbgCm2iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036473; c=relaxed/simple;
	bh=rx2CXyS8Z2B7PlM560/Mg4cctxPW0BXZTrgvo90EaJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sqEFul0nccMScIuYoM020G7NlSuR+XioKREp+ydYVRug8YBZymT/ASL/XCjevAt9BgmhoWrB5p1Ns0uP5r/4QI/9ZN9lOXJzmPZONV8zJwMnlDK9NWqSW+gpGQizRxhI8/bWknTqUcdHlN52NN8d2o1UY46M/4KbD6oNWuzhyoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZnBJARK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B706C43330;
	Thu, 21 Mar 2024 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036473;
	bh=rx2CXyS8Z2B7PlM560/Mg4cctxPW0BXZTrgvo90EaJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZnBJARKJl73lcaMHtHmRm4e1stVo2Gw0o5rg5xFXwPxs6sbCqJenaqBXSontmKFy
	 fL7eY7MyXtcAIIU1ddGKjBOcfIIu25Qpwb5H4/IUr2HCEuIIO5I2oMleKxaTgatNCk
	 wyjkEOkfJhjWdLgDkgvDz65nl07h8MpLieI5tFarNUpR3RwR2B1dWKOeHixHvnWFAv
	 Q/D7iyEurk936SLwaPKudOGnaoq2m2Be2FulQWS2OVtAiaQpY85dS7KCxUEERfZuk3
	 34aFpACD7xmrcjtoeuRZmk+pdCSBpVz2eHXgN4xRXQEFxwknb1m9dcLZAJ/7IclACt
	 aQWYRLlVYms2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkR-00EEqz-Ks;
	Thu, 21 Mar 2024 15:54:31 +0000
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
Subject: [PATCH v3 11/15] KVM: arm64: nv: Add kvm_has_pauth() helper
Date: Thu, 21 Mar 2024 15:53:52 +0000
Message-Id: <20240321155356.3236459-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240321155356.3236459-1-maz@kernel.org>
References: <20240321155356.3236459-1-maz@kernel.org>
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
index 3f1c3c91e5c2..a65701b95078 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1335,4 +1335,19 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
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


