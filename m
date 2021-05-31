Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FED0395902
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhEaKf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:35:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231338AbhEaKfv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 06:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622457251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vWlpLeqe+h7IWNv7jE/nVWyaS5tVXhak42tjTLyHuE=;
        b=PwEJaKS9yRFGNcgmGNYR/BgK/Bfmz146ClFevM3PkNhuOvNSWmjM3h5lwILeVrddqcZsuX
        kn77O5Lvbo9sIrnrAhrze1DAvsO+ZJY73svDXX6bXDq8mRScJRkZVPDyQUHRnBEATVn7Id
        B5EKUVsppzEdvoMKNyF6zH7IrfgNjuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-3qjLcSZ6NUWiwyF1jCpIrg-1; Mon, 31 May 2021 06:34:10 -0400
X-MC-Unique: 3qjLcSZ6NUWiwyF1jCpIrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9843A8005AD;
        Mon, 31 May 2021 10:34:09 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.195.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F28905D9CD;
        Mon, 31 May 2021 10:34:01 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH v3 5/5] KVM: arm64: selftests: get-reg-list: Split base and pmu registers
Date:   Mon, 31 May 2021 12:33:44 +0200
Message-Id: <20210531103344.29325-6-drjones@redhat.com>
In-Reply-To: <20210531103344.29325-1-drjones@redhat.com>
References: <20210531103344.29325-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
own sublist and then create new, pmu-enabled vcpu configs which can
be tested.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index b46b8a1fdc0c..a16c8f05366c 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -637,7 +637,7 @@ int main(int ac, char **av)
  * The current blessed list was primed with the output of kernel version
  * v4.15 with --core-reg-fixup and then later updated with new registers.
  *
- * The blessed list is up to date with kernel version v5.10-rc5
+ * The blessed list is up to date with kernel version v5.13-rc3
  */
 static __u64 base_regs[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
@@ -829,8 +829,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
 	ARM64_SYS_REG(3, 0, 6, 0, 0),	/* FAR_EL1 */
 	ARM64_SYS_REG(3, 0, 7, 4, 0),	/* PAR_EL1 */
-	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
-	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
 	ARM64_SYS_REG(3, 0, 10, 2, 0),	/* MAIR_EL1 */
 	ARM64_SYS_REG(3, 0, 10, 3, 0),	/* AMAIR_EL1 */
 	ARM64_SYS_REG(3, 0, 12, 0, 0),	/* VBAR_EL1 */
@@ -839,6 +837,16 @@ static __u64 base_regs[] = {
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
@@ -848,8 +856,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 3, 9, 13, 0),	/* PMCCNTR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 14, 0),	/* PMUSERENR_EL0 */
 	ARM64_SYS_REG(3, 3, 9, 14, 3),	/* PMOVSSET_EL0 */
-	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
-	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
 	ARM64_SYS_REG(3, 3, 14, 8, 0),
 	ARM64_SYS_REG(3, 3, 14, 8, 1),
 	ARM64_SYS_REG(3, 3, 14, 8, 2),
@@ -913,9 +919,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 3, 14, 15, 5),
 	ARM64_SYS_REG(3, 3, 14, 15, 6),
 	ARM64_SYS_REG(3, 3, 14, 15, 7),	/* PMCCFILTR_EL0 */
-	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
-	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
-	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
 };
 
 static __u64 vregs[] = {
@@ -1015,6 +1018,8 @@ static __u64 sve_rejects_set[] = {
 	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
 #define VREGS_SUBLIST \
 	{ "vregs", .regs = vregs, .regs_n = ARRAY_SIZE(vregs), }
+#define PMU_SUBLIST \
+	{ "pmu", .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
 #define SVE_SUBLIST \
 	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
 	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
@@ -1027,6 +1032,14 @@ static struct vcpu_config vregs_config = {
 	{0},
 	},
 };
+static struct vcpu_config vregs_pmu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	PMU_SUBLIST,
+	{0},
+	},
+};
 static struct vcpu_config sve_config = {
 	.sublists = {
 	BASE_SUBLIST,
@@ -1034,9 +1047,19 @@ static struct vcpu_config sve_config = {
 	{0},
 	},
 };
+static struct vcpu_config sve_pmu_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	SVE_SUBLIST,
+	PMU_SUBLIST,
+	{0},
+	},
+};
 
 static struct vcpu_config *vcpu_configs[] = {
 	&vregs_config,
+	&vregs_pmu_config,
 	&sve_config,
+	&sve_pmu_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.31.1

