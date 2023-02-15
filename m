Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A49697328
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjBOBIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjBOBHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:07:53 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530C932516
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:31 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52ec7c792b1so155291387b3.5
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BAtKaaHohTEAYMjD0cR4uj3MWVe56GuEhp9bvwPfa4=;
        b=Yj822Ifz/waLQy8MmSjHN2pZu32oORMwB771wgCi32mwkJC0hUQpN1N/nWxoPuQKkY
         MR5Obqol9/aE1XAhNk7AVogHzndhjoI3zj/ErGMJSzobg1QkdKs40EF9od/2mDXGl3Mr
         vML3D5iNNfD1nb34vZDllfCbGcaAnWRYJUliZNg+yJkjJr9xtUkHpwrusRFPJfJbTXvS
         iIZLxpFggJQJTFRdLpI55cjbpErqmMuA8qkkrcU08xAnYu4PDLbIWuBAlSrsut48bP65
         31IIpqq6lv+RfBeb3Rip0r7AbEsVn78niJMaW1e4tKNTl7PeTbGqq+6vGsP827kL6i0p
         hNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BAtKaaHohTEAYMjD0cR4uj3MWVe56GuEhp9bvwPfa4=;
        b=1swuRMHMvVq68wWLhIeKIQ9NXnfValfsDrN5mrFps1WBnxHEc0K+yur6szDcSxnVuF
         YxbFfL88DohE5Op5PuNzhwvqkXFgVrLRRIeBD14CzYoUCwzyEzr3NlUD4yBlRhS/2Lyn
         6wMe+MxHeFsALTSPou8Hd3E9H6ujtlTM/TFdB9ureR2EjsZLLg3eptKe8eZ4FeDjMAkK
         6kpOKgV5nTNetNPpKvgZ31dTmckcE++SeTuRDLcaEcsiNwrKRDVwpIvU43zPc+gs476Y
         F4rIWakwn1eODVXgDBKfaiOGOXPycTXpA3t01RQalBN0Izgg7A2r31EakMXZux2LlYdT
         wHMA==
X-Gm-Message-State: AO0yUKXtQJpaqZ4Rsfmzmz+P10A6JQfrwKpUDfv/MoFNWHpzYOr0GDhB
        3Odmi2oBqCp2QbALnIclivogIOK6M+7V
X-Google-Smtp-Source: AK7set9KQp5+rmM+igHZkkICMtVguIIXyRbXqTvu6s5OOn6LZ8Hz4m5ENjHy86UYN6YyxNTRrDsY/D2AXKXH
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ae0b:0:b0:530:a340:bcd7 with SMTP id
 m11-20020a81ae0b000000b00530a340bcd7mr0ywh.8.1676423250349; Tue, 14 Feb 2023
 17:07:30 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:09 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-9-rananta@google.com>
Subject: [REPOST PATCH 08/16] selftests: KVM: aarch64: Consider PMU event
 filters for VM creation
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Accept a list of KVM PMU event filters as an argument while creating
a VM via create_vpmu_vm(). Upcoming patches would leverage this to
test the event filters' functionality.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 64 +++++++++++++++++--
 1 file changed, 60 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 15aebc7d7dc94..2b3a4fa3afa9c 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -15,10 +15,14 @@
 #include <vgic.h>
 #include <asm/perf_event.h>
 #include <linux/bitfield.h>
+#include <linux/bitmap.h>
 
 /* The max number of the PMU event counters (excluding the cycle counter) */
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
 
+/* The max number of event numbers that's supported */
+#define ARMV8_PMU_MAX_EVENTS		64
+
 /*
  * The macros and functions below for reading/writing PMEV{CNTR,TYPER}<n>_EL0
  * were basically copied from arch/arm64/kernel/perf_event.c.
@@ -224,6 +228,8 @@ struct pmc_accessor pmc_accessors[] = {
 	{ read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevtypern },
 };
 
+#define MAX_EVENT_FILTERS_PER_VM 10
+
 #define INVALID_EC	(-1ul)
 uint64_t expected_ec = INVALID_EC;
 uint64_t op_end_addr;
@@ -232,6 +238,7 @@ struct vpmu_vm {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	int gic_fd;
+	unsigned long *pmu_filter;
 };
 
 enum test_stage {
@@ -541,8 +548,51 @@ static void guest_code(void)
 #define GICD_BASE_GPA	0x8000000ULL
 #define GICR_BASE_GPA	0x80A0000ULL
 
+static unsigned long *
+set_event_filters(struct kvm_vcpu *vcpu, struct kvm_pmu_event_filter *pmu_event_filters)
+{
+	int j;
+	unsigned long *pmu_filter;
+	struct kvm_device_attr filter_attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_FILTER,
+	};
+
+	/*
+	 * Setting up of the bitmap is similar to what KVM does.
+	 * If the first filter denys an event, default all the others to allow, and vice-versa.
+	 */
+	pmu_filter = bitmap_zalloc(ARMV8_PMU_MAX_EVENTS);
+	TEST_ASSERT(pmu_filter, "Failed to allocate the pmu_filter");
+
+	if (pmu_event_filters[0].action == KVM_PMU_EVENT_DENY)
+		bitmap_fill(pmu_filter, ARMV8_PMU_MAX_EVENTS);
+
+	for (j = 0; j < MAX_EVENT_FILTERS_PER_VM; j++) {
+		struct kvm_pmu_event_filter *pmu_event_filter = &pmu_event_filters[j];
+
+		if (!pmu_event_filter->nevents)
+			break;
+
+		pr_debug("Applying event filter:: event: 0x%x; action: %s\n",
+				pmu_event_filter->base_event,
+				pmu_event_filter->action == KVM_PMU_EVENT_ALLOW ? "ALLOW" : "DENY");
+
+		filter_attr.addr = (uint64_t) pmu_event_filter;
+		vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
+
+		if (pmu_event_filter->action == KVM_PMU_EVENT_ALLOW)
+			__set_bit(pmu_event_filter->base_event, pmu_filter);
+		else
+			__clear_bit(pmu_event_filter->base_event, pmu_filter);
+	}
+
+	return pmu_filter;
+}
+
 /* Create a VM that has one vCPU with PMUv3 configured. */
-static struct vpmu_vm *create_vpmu_vm(void *guest_code)
+static struct vpmu_vm *
+create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -586,6 +636,9 @@ static struct vpmu_vm *create_vpmu_vm(void *guest_code)
 		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
 
 	/* Initialize vPMU */
+	if (pmu_event_filters)
+		vpmu_vm->pmu_filter = set_event_filters(vcpu, pmu_event_filters);
+
 	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
 	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
 
@@ -594,6 +647,8 @@ static struct vpmu_vm *create_vpmu_vm(void *guest_code)
 
 static void destroy_vpmu_vm(struct vpmu_vm *vpmu_vm)
 {
+	if (vpmu_vm->pmu_filter)
+		bitmap_free(vpmu_vm->pmu_filter);
 	close(vpmu_vm->gic_fd);
 	kvm_vm_free(vpmu_vm->vm);
 	free(vpmu_vm);
@@ -631,7 +686,7 @@ static void run_counter_access_test(uint64_t pmcr_n)
 	guest_data.expected_pmcr_n = pmcr_n;
 
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
-	vpmu_vm = create_vpmu_vm(guest_code);
+	vpmu_vm = create_vpmu_vm(guest_code, NULL);
 	vcpu = vpmu_vm->vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -676,7 +731,7 @@ static void run_counter_access_error_test(uint64_t pmcr_n)
 	guest_data.expected_pmcr_n = pmcr_n;
 
 	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
-	vpmu_vm = create_vpmu_vm(guest_code);
+	vpmu_vm = create_vpmu_vm(guest_code, NULL);
 	vcpu = vpmu_vm->vcpu;
 
 	/* Update the PMCR_EL0.N with @pmcr_n */
@@ -719,9 +774,10 @@ static uint64_t get_pmcr_n_limit(void)
 	struct vpmu_vm *vpmu_vm;
 	uint64_t pmcr;
 
-	vpmu_vm = create_vpmu_vm(guest_code);
+	vpmu_vm = create_vpmu_vm(guest_code, NULL);
 	vcpu_get_reg(vpmu_vm->vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
 	destroy_vpmu_vm(vpmu_vm);
+
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
-- 
2.39.1.581.gbfd45094c4-goog

