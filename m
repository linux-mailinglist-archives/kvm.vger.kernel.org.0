Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F3F376AFF
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 22:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhEGUFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 16:05:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhEGUFm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 16:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620417882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vsn0n/n41qSgktCXK2TGNsKBldvh+9wi0dK3Oc3lJD4=;
        b=gAL8idvTNDo0Sr/vxmAoEfHARsefm+uc95V1Ar7ZGGoPtADqLNoZ1Fiy9wAe60fIFPIsYF
        MRa0AXPTbokEhZDWISSOxz4V5iIZDu7coITr/09qwGnof6NFo/MxcoKQuozqwS+KW/Xx2S
        7kFh8tH+9lX5NHVShzIVTyuCTQ8YoAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-YgeIyFXLN2uu8DfI2U5DgQ-1; Fri, 07 May 2021 16:04:40 -0400
X-MC-Unique: YgeIyFXLN2uu8DfI2U5DgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E8BD1006C80;
        Fri,  7 May 2021 20:04:39 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EEB81A26A;
        Fri,  7 May 2021 20:04:36 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH 6/6] KVM: arm64: selftests: get-reg-list: Split base and pmu registers
Date:   Fri,  7 May 2021 22:04:16 +0200
Message-Id: <20210507200416.198055-7-drjones@redhat.com>
In-Reply-To: <20210507200416.198055-1-drjones@redhat.com>
References: <20210507200416.198055-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
userspace when not available") the get-reg-list* tests have been
failing with

  ...
  ... There are 74 missing registers.
  The following lines are missing registers:
  ...

where the 74 missing registers are all PMU registers. This isn't a
bug in KVM that the selftest found, even though it's true that a
KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
flag, but still expecting the PMU registers to be in the reg-list,
would suddenly no longer have their expectations met. In that case,
the expectations were wrong, though, so that KVM userspace needs to
be fixed, and so does this selftest. The fix for this selftest is to
pull the PMU registers out of the base register sublist into their
own sublist and then create new, pmu-enabled vcpu configs which we
can be tested.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 50 ++++++++++++++++---
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 2f7caa0b9e57..9bc6e125bae7 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -37,12 +37,16 @@
 
 enum {
 	VREGS,
+	VREGS_PMU,
 	SVE,
+	SVE_PMU,
 };
 
 static char * const vcpu_config_names[] = {
 	[VREGS] = "vregs",
+	[VREGS_PMU] = "vregs+pmu",
 	[SVE] = "sve",
+	[SVE_PMU] = "sve+pmu",
 	NULL
 };
 
@@ -59,6 +63,7 @@ struct reg_sublist {
 struct vcpu_config {
 	const char *name;
 	bool sve;
+	bool pmu;
 	struct reg_sublist sublists[];
 };
 
@@ -339,6 +344,8 @@ static void prepare_vcpu_init(struct vcpu_config *c, struct kvm_vcpu_init *init)
 {
 	if (c->sve)
 		init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
+	if (c->pmu)
+		init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
 }
 
 static void finalize_vcpu(struct kvm_vm *vm, uint32_t vcpuid, struct vcpu_config *c)
@@ -357,6 +364,10 @@ static void check_supported(struct vcpu_config *c)
 		fprintf(stderr, "%s: SVE not available, skipping tests\n", c->name);
 		exit(KSFT_SKIP);
 	}
+	if (c->pmu && !kvm_check_cap(KVM_CAP_ARM_PMU_V3)) {
+		fprintf(stderr, "%s: PMU not available, skipping tests\n", c->name);
+		exit(KSFT_SKIP);
+	}
 }
 
 static bool fixup_core_regs;
@@ -614,7 +625,7 @@ int main(int ac, char **av)
  * The current blessed list was primed with the output of kernel version
  * v4.15 with --core-reg-fixup and then later updated with new registers.
  *
- * The blessed list is up to date with kernel version v5.10-rc5
+ * The blessed list is up to date with kernel version v5.11-rc6
  */
 static __u64 base_regs[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
@@ -806,8 +817,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
 	ARM64_SYS_REG(3, 0, 6, 0, 0),	/* FAR_EL1 */
 	ARM64_SYS_REG(3, 0, 7, 4, 0),	/* PAR_EL1 */
-	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
-	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
 	ARM64_SYS_REG(3, 0, 10, 2, 0),	/* MAIR_EL1 */
 	ARM64_SYS_REG(3, 0, 10, 3, 0),	/* AMAIR_EL1 */
 	ARM64_SYS_REG(3, 0, 12, 0, 0),	/* VBAR_EL1 */
@@ -816,6 +825,16 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
 	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
 	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
+	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
+	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
+	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
+	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
+	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
+};
+
+static __u64 pmu_regs[] = {
+	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
+	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
 	ARM64_SYS_REG(3, 3, 9, 12, 0),	/* PMCR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 1),	/* PMCNTENSET_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 12, 2),	/* PMCNTENCLR_EL0 */
@@ -825,8 +844,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 3, 9, 13, 0),	/* PMCCNTR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 14, 0),	/* PMUSERENR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 14, 3),	/* PMOVSSET_EL0 */
-	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
-	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 8, 0),
 	ARM64_SYS_REG(3, 3, 14, 8, 1),
 	ARM64_SYS_REG(3, 3, 14, 8, 2),
@@ -890,9 +907,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 3, 14, 15, 5),
 	ARM64_SYS_REG(3, 3, 14, 15, 6),
 	ARM64_SYS_REG(3, 3, 14, 15, 7),	/* PMCCFILTR_EL0 */
-	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
-	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
-	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
 };
 
 static __u64 vregs[] = {
@@ -996,6 +1010,15 @@ static struct vcpu_config vregs_config = {
 	{0},
 	},
 };
+static struct vcpu_config vregs_pmu_config = {
+	vcpu_config_names[VREGS_PMU], .pmu = true,
+	.sublists = {
+	{ base_regs,	ARRAY_SIZE(base_regs), },
+	{ vregs,	ARRAY_SIZE(vregs), },
+	{ pmu_regs,	ARRAY_SIZE(pmu_regs), },
+	{0},
+	},
+};
 static struct vcpu_config sve_config = {
 	vcpu_config_names[SVE], .sve = true,
 	.sublists = {
@@ -1004,9 +1027,20 @@ static struct vcpu_config sve_config = {
 	{0},
 	},
 };
+static struct vcpu_config sve_pmu_config = {
+	vcpu_config_names[SVE_PMU], .sve = true, .pmu = true,
+	.sublists = {
+	{ base_regs,	ARRAY_SIZE(base_regs), },
+	{ sve_regs,	ARRAY_SIZE(sve_regs),	sve_rejects_set,	ARRAY_SIZE(sve_rejects_set), },
+	{ pmu_regs,	ARRAY_SIZE(pmu_regs), },
+	{0},
+	},
+};
 
 static struct vcpu_config *vcpu_configs[] = {
 	&vregs_config,
+	&vregs_pmu_config,
 	&sve_config,
+	&sve_pmu_config,
 	NULL
 };
-- 
2.30.2

