Return-Path: <kvm+bounces-19227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9683090232B
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A93C11C221E1
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB17158D60;
	Mon, 10 Jun 2024 13:44:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3087386255;
	Mon, 10 Jun 2024 13:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718027068; cv=none; b=KxnUkmYCntWVEHus3hPiPuAajnbbZ0KsHgM5Jkt/ZK0dfLWXi7cLXpw581n6xrbkPwzdBhz3CeS0pWJts58WyL0Wqoa4Fq4Tz5LZ5HIo9MTI1kdvxWG/oRgV/9g6wIUiayT1/13VIsEHOVVG9S7RSSnCwyn3sHjZ5BR9G1IW9BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718027068; c=relaxed/simple;
	bh=PXzB2CfFVPOkpm1ENsA7+9DLxxEPtB8SHxv47VUK+j0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NFpTLgkuJHyjmfmCK9VDzdttnsetv9q+YuTTO6n0GCpNfwnY1nZVWCJ9D0OmrnOo4yTZbcukza5vhIaVSl8KG4GumTe4uZpyrW8DNqYtRNod4t5z3U+wcDwyXIHmVrvAcf564wVfxA2OuuaFREK099OO1zb8Bu/M/q+cvdp65W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32AD812FC;
	Mon, 10 Jun 2024 06:44:50 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE77E3F58B;
	Mon, 10 Jun 2024 06:44:22 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v3 40/43] arm64: RME: Provide register list for unfinalized RME RECs
Date: Mon, 10 Jun 2024 14:41:59 +0100
Message-Id: <20240610134202.54893-41-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

KVM_GET_REG_LIST should not be called before SVE is finalized. The ioctl
handler currently returns -EPERM in this case. But because it uses
kvm_arm_vcpu_is_finalized(), it now also rejects the call for
unfinalized REC even though finalizing the REC can only be done late,
after Realm descriptor creation.

Move the check to copy_sve_reg_indices(). One adverse side effect of
this change is that a KVM_GET_REG_LIST call that only probes for the
array size will now succeed even if SVE is not finalized, but that seems
harmless since the following KVM_GET_REG_LIST with the full array will
fail.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c   | 4 ----
 arch/arm64/kvm/guest.c | 9 +++------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b04f08e242a6..19b04299d1b2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1805,10 +1805,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (unlikely(!kvm_vcpu_initialized(vcpu)))
 			break;
 
-		r = -EPERM;
-		if (!kvm_arm_vcpu_is_finalized(vcpu))
-			break;
-
 		r = -EFAULT;
 		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
 			break;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index e3366c9bdd9d..6299561da46d 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -652,12 +652,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 {
 	const unsigned int slices = vcpu_sve_slices(vcpu);
 
-	if (!vcpu_has_sve(vcpu))
+	if (!vcpu_has_sve(vcpu) || !kvm_arm_vcpu_sve_finalized(vcpu))
 		return 0;
 
-	/* Policed by KVM_GET_REG_LIST: */
-	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
-
 	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
 		+ 1; /* KVM_REG_ARM64_SVE_VLS */
 }
@@ -673,8 +670,8 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 	if (!vcpu_has_sve(vcpu))
 		return 0;
 
-	/* Policed by KVM_GET_REG_LIST: */
-	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
+	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+		return -EPERM;
 
 	/*
 	 * Enumerate this first, so that userspace can save/restore in
-- 
2.34.1


