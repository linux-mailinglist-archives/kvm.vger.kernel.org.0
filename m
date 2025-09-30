Return-Path: <kvm+bounces-59146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05276BAC814
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFAA4485628
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023042FF164;
	Tue, 30 Sep 2025 10:32:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4692FDC44;
	Tue, 30 Sep 2025 10:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228335; cv=none; b=SJ4qzgcX1DjgFT3ChteFgQBng/b7Dr2Fz9ZJ71Po4ep0JMNJQ1lJ/MMNtvH14mRC7bUlLxF5ahxD7kITJFKHvLwYMv3rad2BqumhH/TO9e6hn6iAgIswoj8aSURQglTajjKyq3zYvzfuRI5v2jfhlUHGuncBROttxYxsHpr/d/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228335; c=relaxed/simple;
	bh=zGdVqIbpQPBSUw3Jutj7bJBQ1ltnUDkmYx/Oioo8W/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShY1iZQBCaDDHNGToz0gVsCMW1IYmcNKN14yWZHXyYTQy/LRr8qti0zsXxdZzsV7AJKWz4k17Gu7bCf2zcO86G+0U3G0FVdo5+dkhNtzmzRbx8nn6YgQaw+jEbamEGT2ySdpaYbeHHBrgaDEcEdu6NsYCQJLjIJ6vfvc3t3VsPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0AFD2696;
	Tue, 30 Sep 2025 03:32:05 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 76A9F3F66E;
	Tue, 30 Sep 2025 03:32:12 -0700 (PDT)
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
Subject: [PATCH kvmtool v4 08/15] arm64: Add support for finding vCPU for given MPIDR
Date: Tue, 30 Sep 2025 11:31:23 +0100
Message-ID: <20250930103130.197534-10-suzuki.poulose@arm.com>
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

Some PSCI calls take an MPIDR affinity as an argument. Add a helper to
get the vCPU that matches an MPIDR so we can find the intended
recipient.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-arch.h |  2 ++
 arm64/kvm.c                  | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index 8f508ef8..a50e6a4f 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -114,4 +114,6 @@ struct kvm_arch {
 	cpu_set_t *vcpu_affinity_cpuset;
 };
 
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr);
+
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 23b4dab1..41c47b13 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -5,6 +5,7 @@
 #include "kvm/virtio-console.h"
 #include "kvm/fdt.h"
 #include "kvm/gic.h"
+#include "kvm/kvm-cpu.h"
 
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
@@ -128,6 +129,22 @@ void kvm__arch_init(struct kvm *kvm)
 	kvm__arch_enable_mte(kvm);
 }
 
+
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr)
+{
+	int i;
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_cpu *tmp = kvm->cpus[i];
+		u64 mpidr = kvm_cpu__get_vcpu_mpidr(tmp) & ARM_MPIDR_HWID_BITMASK;
+
+		if (mpidr == target_mpidr)
+			return tmp;
+	}
+
+	return NULL;
+}
+
 static u64 kvm__arch_get_payload_region_size(struct kvm *kvm)
 {
 	if (kvm->cfg.arch.aarch32_guest)
-- 
2.43.0


