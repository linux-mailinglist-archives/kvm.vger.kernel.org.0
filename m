Return-Path: <kvm+bounces-72186-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qE/LMunOoWn3wQQAu9opvQ
	(envelope-from <kvm+bounces-72186-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:05:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 349D61BB2E8
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFAE731B3CDC
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D9B35CBD7;
	Fri, 27 Feb 2026 16:59:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06655356A2B
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211596; cv=none; b=uPLJYPX+g/j3daGVjyAjQXXYZod1FIy63FUxnwGY/mg11yEEXvedwQn6aDK56HwNg5bNFfrYrelctagwYxj2SSLWbKBW5PYZDDOXKmhY7WpKq5CCb4vzuPZiLe1RgGk4/Cbjw79eq1YEqOZgn32l/MiUPZ2CVLpR1A4Bx28TQLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211596; c=relaxed/simple;
	bh=btyywYT33i0Lf9IQcTmns7XcT2/j2rYyQM4kWBIrhUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMRYiU8hxxstWs9TaRCr/Kx/sebH0MgmRVDKE+pusWSjzfyfi+SF4a9bGFBCS5xPzQWebD8dldYBVHsOkyyK34zVVHccHXLtjiU/fn+iciKe93SgOkaDmdtM+2gOhLhQKkuRifA+udXWtfOYaaehI7+LW95T1vxiZcC3DgRNMRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6864614BF;
	Fri, 27 Feb 2026 08:59:47 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5D6A63F73B;
	Fri, 27 Feb 2026 08:59:52 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 10/17] arm64: Add support for finding vCPU for given MPIDR
Date: Fri, 27 Feb 2026 16:56:17 +0000
Message-ID: <20260227165624.1519865-11-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72186-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.975];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: 349D61BB2E8
X-Rspamd-Action: no action

From: Oliver Upton <oliver.upton@linux.dev>

Some PSCI calls take an MPIDR affinity as an argument. Add a helper to
get the vCPU that matches an MPIDR so we can find the intended
recipient.

Reviewed-by: Marc Zyngier <maz@kernel.org>
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


