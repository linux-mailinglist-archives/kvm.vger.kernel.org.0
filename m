Return-Path: <kvm+bounces-67440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4A3D054D5
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7CF203075F5C
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48872F659C;
	Thu,  8 Jan 2026 17:59:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A23F25F797;
	Thu,  8 Jan 2026 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895151; cv=none; b=dsmT61m+enRYpJZ9f+mm7W9Ett7VrMk4vqYfrWcX6aJULRnnOwBHD039kNuUviv19HR8wXvSZTkZGDNhDOcO07DKK9c7MQvHVgx1j565vexgn2jzj00xpPTTgWZfDSdquowQsTRtpRSr3qCI8UlYqbTp8IqqmMr/Mb7aZK4XbT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895151; c=relaxed/simple;
	bh=Jy09jgbBZ0NtLoWAppmx87IBHL6F4I7aPwJ9L2m2ZNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0HzioBjXS2NhWOsj3u+2h1O8gqHqMGk4tvSjkCVP/lMN0Zh75X1k+CdRLoMO0LwSBJrs/kkfalqAPZrjPBDx/4uxySt0QBgaNaD6GQ7yq6jQbZIw33bmfvtrCTlhechpMzHnu6g+C471GKWMBv1bYfMCfSZIRMIQNdoos8AmeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A92E1684;
	Thu,  8 Jan 2026 09:58:55 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 44C6D3F5A1;
	Thu,  8 Jan 2026 09:58:59 -0800 (PST)
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
Subject: [kvmtool PATCH v5 05/15] arm64: Stash kvm_vcpu_init for later use
Date: Thu,  8 Jan 2026 17:57:43 +0000
Message-ID: <20260108175753.1292097-6-suzuki.poulose@arm.com>
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

A subsequent change will add support for resetting a vCPU, which
requires reissuing the KVM_ARM_VCPU_INIT ioctl. Save the kvm_vcpu_init
worked out for later use.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-cpu-arch.h | 2 +-
 arm64/kvm-cpu.c                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index 1af394aa..2f189abc 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -17,7 +17,7 @@ struct kvm_cpu {
 	pthread_t	thread;
 
 	unsigned long	cpu_id;
-	unsigned long	cpu_type;
+	struct kvm_vcpu_init	init;
 	const char	*cpu_compatible;
 
 	struct kvm	*kvm;
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 94c08a4d..3d914112 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -194,7 +194,7 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->init		= vcpu_init;
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
-- 
2.43.0


