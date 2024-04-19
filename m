Return-Path: <kvm+bounces-15230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A73A88AACD1
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:30:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 350DB1F21EE2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122C97F46E;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ehu+Y539"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317B97E11E;
	Fri, 19 Apr 2024 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522592; cv=none; b=XRHmbNefSRsfyrOKnBoGwxdDKQgZ02dc0ah/sQca2E1JOp/E+sBB8bx3msj4d725CK0b/COESkACJOCc6PUB1kGB3mkWWdkATthXNt2o/S7AdOfSVC2xpR2RBR9Sod4QOlrUnPMp1QPnCvw/esCGGGzXjr4L4cuKFQgNRBBlE1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522592; c=relaxed/simple;
	bh=0ghS+d/37kG9I38a1NzWxGiZYdqk3MoQyhIqBHrfUaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BVMeqX6RXT7l2d7xFZwmQmoRwuera3ArCh8MVHliQ2nHS92ymRZ6aeuxVdBQdfhZm+goO5GiVE6Q1mtcHSUS/UAdK13fNOsgF3afcG4XPGp7WkUW8FWt3BqoFyRAN4rMyvIrbbhOxcsqaXITanF9ZMHPYQAJ9eYFPEEs63EpYkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ehu+Y539; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91A2C32786;
	Fri, 19 Apr 2024 10:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522591;
	bh=0ghS+d/37kG9I38a1NzWxGiZYdqk3MoQyhIqBHrfUaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ehu+Y539kz/UpKatxH9BxcNZnBjDHEECI6hn9v8xvHsrtURB9Jpvp25iPkiehHBDp
	 lWI3NjmSiFJmsYsXmg3tqhJYgUUv9QoKUvYl6iET8FOH+dCO+SBrpl1QDD8PbmEJkM
	 fwjfZSZNOdsY4dXh9//xQSP4lolkVCbvoDRBwfUGcQXu5sZxz97q00YyB46CEjsEjn
	 x4lJ40LH2CMXvoPTQLuam2AdYyAkx2fSn6MftmVfonMy0bSwTfJRs5LGqnwblVb3eg
	 lSgiZCevXrRjNps2wwx0vqzNyEiifwF1BUEXdr6MhG0e8C+AMpaFmBAO8ueXwUJ3ry
	 4O/VlKxtHqIIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV7-00636W-I9;
	Fri, 19 Apr 2024 11:29:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 03/15] KVM: arm64: Constraint PAuth support to consistent implementations
Date: Fri, 19 Apr 2024 11:29:23 +0100
Message-Id: <20240419102935.1935571-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

PAuth comes it two parts: address authentication, and generic
authentication. So far, KVM mandates that both are implemented.

PAuth also comes in three flavours: Q5, Q3, and IMPDEF. Only one
can be implemented for any of address and generic authentication.

Crucially, the architecture doesn't mandate that address and generic
authentication implement the *same* flavour. This would make
implementing ERETAx very difficult for NV, something we are not
terribly keen on.

So only allow PAuth support for KVM on systems that are not totally
insane. Which is so far 100% of the known HW.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3dee5490eea9..a7178af1ab0c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -218,6 +218,40 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_arm_teardown_hypercalls(kvm);
 }
 
+static bool kvm_has_full_ptr_auth(void)
+{
+	bool apa, gpa, api, gpi, apa3, gpa3;
+	u64 isar1, isar2, val;
+
+	/*
+	 * Check that:
+	 *
+	 * - both Address and Generic auth are implemented for a given
+         *   algorithm (Q5, IMPDEF or Q3)
+	 * - only a single algorithm is implemented.
+	 */
+	if (!system_has_full_ptr_auth())
+		return false;
+
+	isar1 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
+	isar2 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
+
+	apa = !!FIELD_GET(ID_AA64ISAR1_EL1_APA_MASK, isar1);
+	val = FIELD_GET(ID_AA64ISAR1_EL1_GPA_MASK, isar1);
+	gpa = (val == ID_AA64ISAR1_EL1_GPA_IMP);
+
+	api = !!FIELD_GET(ID_AA64ISAR1_EL1_API_MASK, isar1);
+	val = FIELD_GET(ID_AA64ISAR1_EL1_GPI_MASK, isar1);
+	gpi = (val == ID_AA64ISAR1_EL1_GPI_IMP);
+
+	apa3 = !!FIELD_GET(ID_AA64ISAR2_EL1_APA3_MASK, isar2);
+	val  = FIELD_GET(ID_AA64ISAR2_EL1_GPA3_MASK, isar2);
+	gpa3 = (val == ID_AA64ISAR2_EL1_GPA3_IMP);
+
+	return (apa == gpa && api == gpi && apa3 == gpa3 &&
+		(apa + api + apa3) == 1);
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
@@ -311,7 +345,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
-		r = system_has_full_ptr_auth();
+		r = kvm_has_full_ptr_auth();
 		break;
 	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
 		if (kvm)
@@ -1270,7 +1304,7 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!system_supports_sve())
 		clear_bit(KVM_ARM_VCPU_SVE, &features);
 
-	if (!system_has_full_ptr_auth()) {
+	if (!kvm_has_full_ptr_auth()) {
 		clear_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, &features);
 		clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
 	}
-- 
2.39.2


