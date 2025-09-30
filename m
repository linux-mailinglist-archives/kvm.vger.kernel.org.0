Return-Path: <kvm+bounces-59152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59F22BAC835
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DBAD323D5E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A38E3019D9;
	Tue, 30 Sep 2025 10:32:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41DF3016F2;
	Tue, 30 Sep 2025 10:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228345; cv=none; b=cGW5V8jOWGoFxoJZkS5rLcNFCkBQmJ0A5vv9+kXiDzkxP73NijIkyDTPWt5aWCIEIv0PvhkiitpI1RtbEfhaX6pbM3KqulZb6DU2PPidnhC/ohYtNBvbjFRYnQYejPvCCEzP06qOdB4rALARpG6DyO/EplAllGfJteQhZQcOAec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228345; c=relaxed/simple;
	bh=oylsjyDfIxk0RuOQkwH/oKfLKeIqIwFScslKOtpmzDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa7dt5qdnmF+qz/dKfn8edEKdsVG1ZG68FeOugEcKM3tmi8I28FkzkIOM3buLIAoGeErSLezrtM52/GclctxRyomM7NYpVEPnnRjjDGUY9u6dyU/U1xWzLHtmpcgN4TZbhgdv4fKbeQv9bgT9nDD8GnZSgnGLlbQb3wt6l41yk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 901CC2682;
	Tue, 30 Sep 2025 03:32:15 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3CFBC3F66E;
	Tue, 30 Sep 2025 03:32:22 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH kvmtool v4 14/15] arm64: psci: Implement SYSTEM_{OFF,RESET}
Date: Tue, 30 Sep 2025 11:31:29 +0100
Message-ID: <20250930103130.197534-16-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930103130.197534-1-suzuki.poulose@arm.com>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Add support for the PSCI SYSTEM_{OFF,RESET} calls. Match the behavior of
the SYSTEM_EVENT based implementation and just terminate the VM.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/psci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arm64/psci.c b/arm64/psci.c
index 3deb672e..874ad141 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
@@ -33,6 +33,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_AFFINITY_INFO:
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -195,6 +197,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 		/* Trusted OS not present */
 		res->a0 = PSCI_0_2_TOS_MP;
 		break;
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
+		kvm__reboot(vcpu->kvm);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.43.0


