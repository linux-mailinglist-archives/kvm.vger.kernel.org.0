Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5384697334
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjBOBIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbjBOBIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:08:13 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D9A32501
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:41 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id s12-20020a056e021a0c00b0030efd0ed890so12271655ild.7
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0LRKHv8C7GNrFb1gl+E1gfO7HmO+3D0ztdjnWC4dVGc=;
        b=JTC5S3GsS6ZOJmXLKswiG7whyctIzAppUOG+oyJhenHSIgULJn4qFWjonyPM1bwZ4j
         V5JVVnZnnKwYnEbMGSiKr+u9zcm08pMT0x93hS3W31FzGxAaxPw/MPXDS6XIoef9W/E4
         nwpv9TxTnio1zPy1qecC8ZASO42aHoVaPdkChEfso+gdaWu9aySEUhEYCJhuv3rhFU5v
         mD9UY879zV8g+0xNPD91fAYVAN/UCGvDtSi/qg51fC2g/kvK9vByNVdXJIfmgpG6GqqN
         Au6tImv1NRghYiEJCtBWFTvT9XRnYdoxdhdb9cm840YZqAZ/HQCbwwaghKATKR2oUnqt
         L6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0LRKHv8C7GNrFb1gl+E1gfO7HmO+3D0ztdjnWC4dVGc=;
        b=nMuagMb6PJiPIiGSpxjOdqn94b22ZIrYQwLYpan81NCzkBVd2TSF0QtK52D6v1Blrj
         Cx5E1Z5qiq0aTkpKzfH97fbdaioHsTMkUaENKL8ZiasNLqQpcqmKksRL4VP3Hhis83r2
         DNMo/iIDwXRBifLbeqxzxv70H/iTIYndbNuNtxo809om8ryB+QWeNTF3DLLXrO4tqzx/
         QoyVJ80F95Zh1jq4NqrjMfKvXyUTWdumbVnEZnSe5NWnNILl0QV2d2jHBMoNtq19r5Oq
         V91e9hg6nPZBGDw4bDUp1SSRw4jg55P6c9O2lpuwMWHTPlssjrCbAJKdPoTYGG+MC8X1
         FX/A==
X-Gm-Message-State: AO0yUKXcF3nsS2cxDPCw4emtMk+rS31e4MBUgb0GCJcqdhnDp8MmZI2Q
        wUgg68yi0hLFHT2h7pEoJQY3jI+bwWSX
X-Google-Smtp-Source: AK7set/PNHzkCHVO4XQYy4JJRB4oQAwAFnQi9qjc12IrECLlkauDLQD3bIuQ4egx1XgKPntcuYC2H1BANpGX
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6e02:96c:b0:315:5d89:fb2c with SMTP id
 q12-20020a056e02096c00b003155d89fb2cmr584391ilt.2.1676423259705; Tue, 14 Feb
 2023 17:07:39 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:16 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-16-rananta@google.com>
Subject: [REPOST PATCH 15/16] selftests: KVM: aarch64: Add multi-vCPU support
 for vPMU VM creation
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PMU test's create_vpmu_vm() currently creates a VM with only
one cpu. Extend this to accept a number of cpus as a argument
to create a multi-vCPU VM. This would help the upcoming patches
to test the vPMU context across multiple vCPUs.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 82 +++++++++++--------
 1 file changed, 49 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index fd00acb9391c8..239fc7e06b3b9 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -320,7 +320,8 @@ uint64_t op_end_addr;
 
 struct vpmu_vm {
 	struct kvm_vm *vm;
-	struct kvm_vcpu *vcpu;
+	int nr_vcpus;
+	struct kvm_vcpu **vcpus;
 	int gic_fd;
 	unsigned long *pmu_filter;
 };
@@ -1164,10 +1165,11 @@ set_event_filters(struct kvm_vcpu *vcpu, struct kvm_pmu_event_filter *pmu_event_
 	return pmu_filter;
 }
 
-/* Create a VM that has one vCPU with PMUv3 configured. */
+/* Create a VM that with PMUv3 configured. */
 static struct vpmu_vm *
-create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
+create_vpmu_vm(int nr_vcpus, void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
 {
+	int i;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vcpu_init init;
@@ -1187,7 +1189,11 @@ create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
 	vpmu_vm = calloc(1, sizeof(*vpmu_vm));
 	TEST_ASSERT(vpmu_vm, "Failed to allocate vpmu_vm");
 
-	vpmu_vm->vm = vm = vm_create(1);
+	vpmu_vm->vcpus = calloc(nr_vcpus, sizeof(struct kvm_vcpu *));
+	TEST_ASSERT(vpmu_vm->vcpus, "Failed to allocate kvm_vpus");
+	vpmu_vm->nr_vcpus = nr_vcpus;
+
+	vpmu_vm->vm = vm = vm_create(nr_vcpus);
 	vm_init_descriptor_tables(vm);
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
 
@@ -1197,26 +1203,35 @@ create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
 					guest_sync_handler);
 	}
 
-	/* Create vCPU with PMUv3 */
+	/* Create vCPUs with PMUv3 */
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
-	vpmu_vm->vcpu = vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
-	vcpu_init_descriptor_tables(vcpu);
-	vpmu_vm->gic_fd = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
 
-	/* Make sure that PMUv3 support is indicated in the ID register */
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
-	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
-	TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
-		    pmuver >= ID_AA64DFR0_PMUVER_8_0,
-		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
+	for (i = 0; i < nr_vcpus; i++) {
+		vpmu_vm->vcpus[i] = vcpu = aarch64_vcpu_add(vm, i, &init, guest_code);
+		vcpu_init_descriptor_tables(vcpu);
+	}
 
-	/* Initialize vPMU */
-	if (pmu_event_filters)
-		vpmu_vm->pmu_filter = set_event_filters(vcpu, pmu_event_filters);
+	/* vGIC setup is expected after the vCPUs are created but before the vPMU is initialized */
+	vpmu_vm->gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
 
-	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
-	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
+	for (i = 0; i < nr_vcpus; i++) {
+		vcpu = vpmu_vm->vcpus[i];
+
+		/* Make sure that PMUv3 support is indicated in the ID register */
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
+		pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
+		TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
+			pmuver >= ID_AA64DFR0_PMUVER_8_0,
+			"Unexpected PMUVER (0x%x) on the vCPU %d with PMUv3", i, pmuver);
+
+		/* Initialize vPMU */
+		if (pmu_event_filters)
+			vpmu_vm->pmu_filter = set_event_filters(vcpu, pmu_event_filters);
+
+		vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
+		vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
+	}
 
 	return vpmu_vm;
 }
@@ -1227,6 +1242,7 @@ static void destroy_vpmu_vm(struct vpmu_vm *vpmu_vm)
 		bitmap_free(vpmu_vm->pmu_filter);
 	close(vpmu_vm->gic_fd);
 	kvm_vm_free(vpmu_vm->vm);
+	free(vpmu_vm->vcpus);
 	free(vpmu_vm);
 }
 
@@ -1264,8 +1280,8 @@ static void run_counter_access_test(uint64_t pmcr_n)
 	guest_data.expected_pmcr_n = pmcr_n;
 
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
-	vpmu_vm = create_vpmu_vm(guest_code, NULL);
-	vcpu = vpmu_vm->vcpu;
+	vpmu_vm = create_vpmu_vm(1, guest_code, NULL);
+	vcpu = vpmu_vm->vcpus[0];
 
 	/* Save the initial sp to restore them later to run the guest again */
 	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
@@ -1309,8 +1325,8 @@ static void run_counter_access_error_test(uint64_t pmcr_n)
 	guest_data.expected_pmcr_n = pmcr_n;
 
 	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
-	vpmu_vm = create_vpmu_vm(guest_code, NULL);
-	vcpu = vpmu_vm->vcpu;
+	vpmu_vm = create_vpmu_vm(1, guest_code, NULL);
+	vcpu = vpmu_vm->vcpus[0];
 
 	/* Update the PMCR_EL0.N with @pmcr_n */
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
@@ -1396,8 +1412,8 @@ static void run_kvm_event_filter_error_tests(void)
 	};
 
 	/* KVM should not allow configuring filters after the PMU is initialized */
-	vpmu_vm = create_vpmu_vm(guest_code, NULL);
-	ret = __vcpu_ioctl(vpmu_vm->vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
+	vpmu_vm = create_vpmu_vm(1, guest_code, NULL);
+	ret = __vcpu_ioctl(vpmu_vm->vcpus[0], KVM_SET_DEVICE_ATTR, &filter_attr);
 	TEST_ASSERT(ret == -1 && errno == EBUSY,
 			"Failed to disallow setting an event filter after PMU init");
 	destroy_vpmu_vm(vpmu_vm);
@@ -1427,14 +1443,14 @@ static void run_kvm_event_filter_test(void)
 
 	/* Test for valid filter configurations */
 	for (i = 0; i < ARRAY_SIZE(pmu_event_filters); i++) {
-		vpmu_vm = create_vpmu_vm(guest_code, pmu_event_filters[i]);
+		vpmu_vm = create_vpmu_vm(1, guest_code, pmu_event_filters[i]);
 		vm = vpmu_vm->vm;
 
 		pmu_filter_gva = vm_vaddr_alloc(vm, pmu_filter_bmap_sz, KVM_UTIL_MIN_VADDR);
 		memcpy(addr_gva2hva(vm, pmu_filter_gva), vpmu_vm->pmu_filter, pmu_filter_bmap_sz);
 		guest_data.pmu_filter = (unsigned long *) pmu_filter_gva;
 
-		run_vcpu(vpmu_vm->vcpu);
+		run_vcpu(vpmu_vm->vcpus[0]);
 
 		destroy_vpmu_vm(vpmu_vm);
 	}
@@ -1449,8 +1465,8 @@ static void run_kvm_evtype_filter_test(void)
 
 	guest_data.test_stage = TEST_STAGE_KVM_EVTYPE_FILTER;
 
-	vpmu_vm = create_vpmu_vm(guest_code, NULL);
-	run_vcpu(vpmu_vm->vcpu);
+	vpmu_vm = create_vpmu_vm(1, guest_code, NULL);
+	run_vcpu(vpmu_vm->vcpus[0]);
 	destroy_vpmu_vm(vpmu_vm);
 }
 
@@ -1465,7 +1481,7 @@ static void *run_vcpus_migrate_test_func(void *arg)
 	struct vcpu_migrate_data *migrate_data = arg;
 	struct vpmu_vm *vpmu_vm = migrate_data->vpmu_vm;
 
-	run_vcpu(vpmu_vm->vcpu);
+	run_vcpu(vpmu_vm->vcpus[0]);
 	migrate_data->vcpu_done = true;
 
 	return NULL;
@@ -1535,7 +1551,7 @@ static void run_vcpu_migration_test(uint64_t pmcr_n)
 	guest_data.test_stage = TEST_STAGE_VCPU_MIGRATION;
 	guest_data.expected_pmcr_n = pmcr_n;
 
-	migrate_data.vpmu_vm = vpmu_vm = create_vpmu_vm(guest_code, NULL);
+	migrate_data.vpmu_vm = vpmu_vm = create_vpmu_vm(1, guest_code, NULL);
 
 	/* Initialize random number generation for migrating vCPUs to random pCPUs */
 	srand(time(NULL));
@@ -1571,8 +1587,8 @@ static uint64_t get_pmcr_n_limit(void)
 	struct vpmu_vm *vpmu_vm;
 	uint64_t pmcr;
 
-	vpmu_vm = create_vpmu_vm(guest_code, NULL);
-	vcpu_get_reg(vpmu_vm->vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	vpmu_vm = create_vpmu_vm(1, guest_code, NULL);
+	vcpu_get_reg(vpmu_vm->vcpus[0], KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
 	destroy_vpmu_vm(vpmu_vm);
 
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
-- 
2.39.1.581.gbfd45094c4-goog

