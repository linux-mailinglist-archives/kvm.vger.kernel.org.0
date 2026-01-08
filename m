Return-Path: <kvm+bounces-67448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1326D05580
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:06:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A790C30CBA0F
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 18:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB852F4A19;
	Thu,  8 Jan 2026 17:59:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4AC2EB862;
	Thu,  8 Jan 2026 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895174; cv=none; b=QsxnSB8TYeEjQyWJZ1xFmSlKnokiYNLEtyL7iGBpEq0zHPxdy8xP9V/BP5o+c+PryNd0L7WDliD6EEKUaYOynPzu3QgL44JTno2R8688Q/sAK/ZZ7tsd46yJkO800JdF9WMMA4Mt/8vDy1MZYtieA5OMtxAvFqzfp+SYfyZyyJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895174; c=relaxed/simple;
	bh=sx1ccfpOH3rIlBXTgrOC+8Y/h/QBr758sug6lz7re9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fr/WDgCOOTrrEUu1TsN9t1jWhmButweFpjq8hd0rGWJx/rPMIsTYVneaqMqSO8ZodEvvxYjuQZX3sXc7r6AYfl/n5YMQu8AH0vCPt13Ue/Hl5G2HJLce4MkbgTPbrJ+muR37bjS9x2JQqIBE3MbJWG70sfu96pImvEisiD3HyV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8109497;
	Thu,  8 Jan 2026 09:59:20 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E42773F5A1;
	Thu,  8 Jan 2026 09:59:24 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	maz@kernel.org,
	will@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 13/15] arm64: psci: Implement MIGRATE_INFO_TYPE
Date: Thu,  8 Jan 2026 17:57:51 +0000
Message-ID: <20260108175753.1292097-14-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108175753.1292097-1-suzuki.poulose@arm.com>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Let the guest know that our PSCI implementation is entirely oblivious to
the existence of a Trusted OS, and thus shouldn't care about it.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/psci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm64/psci.c b/arm64/psci.c
index 94e39d40..3deb672e 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
@@ -32,6 +32,7 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_CPU_ON:
 	case PSCI_0_2_FN_AFFINITY_INFO:
 	case PSCI_0_2_FN64_AFFINITY_INFO:
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -190,6 +191,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 		affinity_info(vcpu, res);
 		break;
+	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+		/* Trusted OS not present */
+		res->a0 = PSCI_0_2_TOS_MP;
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.43.0


