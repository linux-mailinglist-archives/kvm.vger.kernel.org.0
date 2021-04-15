Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2D360A57
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhDONRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:17:21 -0400
Received: from foss.arm.com ([217.140.110.172]:45992 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhDONRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 09:17:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE92311B3;
        Thu, 15 Apr 2021 06:16:57 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B0E33F694;
        Thu, 15 Apr 2021 06:16:57 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool] arm: Fail early if KVM_CAP_ARM_PMU_V3 is not supported
Date:   Thu, 15 Apr 2021 14:17:25 +0100
Message-Id: <20210415131725.105675-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pmu__generate_fdt_nodes() checks if the host has support for PMU in a guest
and prints a warning if that's not the case. However, this check is too
late because the function is called after the VCPU has been created, and
VCPU creation fails if KVM_CAP_ARM_PMU_V3 is not available with a rather
unhelpful error:

$ ./vm run -c1 -m64 -f selftest.flat --pmu
  # lkvm run --firmware selftest.flat -m 64 -c 1 --name guest-1039
  Info: Placing fdt at 0x80200000 - 0x80210000
  Fatal: Unable to initialise vcpu

Move the check for KVM_CAP_ARM_PMU_V3 to kvm_cpu__arch_init() before the
VCPU is created so the user can get a more useful error message. This
also matches the behaviour of KVM_CAP_ARM_EL1_32BIT.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm-cpu.c | 4 ++++
 arm/pmu.c     | 5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 2acecaecb696..6a2408c632df 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -50,6 +50,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	    !kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
 		die("32bit guests are not supported\n");
 
+	if (kvm->cfg.arch.has_pmuv3 &&
+	    !kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3))
+		die("PMUv3 is not supported");
+
 	vcpu = calloc(1, sizeof(struct kvm_cpu));
 	if (!vcpu)
 		return NULL;
diff --git a/arm/pmu.c b/arm/pmu.c
index ffd152e27447..5b058eabb49d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -43,11 +43,6 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	if (!kvm->cfg.arch.has_pmuv3)
 		return;
 
-	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3)) {
-		pr_info("PMU unsupported\n");
-		return;
-	}
-
 	for (i = 0; i < kvm->nrcpus; i++) {
 		struct kvm_device_attr pmu_attr;
 
-- 
2.31.1

