Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2990D53C1FC
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbiFCA4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241477AbiFCAvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:51:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA9037BD0
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:54 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t1-20020a62ea01000000b0051be221a3ebso120572pfh.17
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oai2S4EAAmPa85Y066HalubGdHo4lrztUXD+OqH0Pt0=;
        b=REisubbk7rC2CW6edImhLHH0fon978Zlg4rD+vjgbXBj09G5w4bujvJ00mSGtO10nd
         PfPcG/vOQrncclX/jpvpuSG65CdGVnh0Ad2iH74leK7xH59WTPrMsvOz0nKsV6lnlZE7
         9YLlozP0MmaoWriGh1kOrbX1jA8ZCgtEAjhTDtS4jUyUF2kfgx7UZ9iHSkC6qt/FgM/z
         L7Xhu/Y2VtyBApTwy5LhsGiQichsT9odIGZ9vwwiAxgmX5z8xvVH7VIzdpRbFx74m9cw
         wUMcApHWw7W8VbGWdpeEFNtpzs2DF/KqSjoXJ9cgw6kPDEUPEjEpnikK5T81j12nV0pq
         dGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oai2S4EAAmPa85Y066HalubGdHo4lrztUXD+OqH0Pt0=;
        b=Y/nfF3iEZRCDPFTdUgEvN/rnGDwelz/AwZdCFBe6nEdkzmICFHZ7id8WWSYIgZx0UC
         CwQB1FkWPDSpxDl+viPNXKSbB1q9VIh6SKSQDWy/Tj1qK72dwkN6tzm+Qy0q25P17bl2
         ebO/nSqASK0Xg1l8n+vCMN2jBrAG0gvu0KCqs4Bw3OSsHAJoitZpEoxvU+vYBmXkLL/q
         yupQGaJkPA+G769fdYhKRMlvEjQfmnpHOhTg0qNkb34Zz344R/z2osEicAiUmpFewskx
         oEqCbR4zK+Ma5WucZVnh8fwS3RXD0nolkELzU5hynMPSm3R8qtKqYhKW8SMZCXLIhwIQ
         z3qQ==
X-Gm-Message-State: AOAM533wrXncLUtMCL3sBu0rVn94VxlzbYgY6fBMXN6BT3vGILmNxvN6
        EoJh2uTIMCOeMwFVP+6fTtlU71p8KYo=
X-Google-Smtp-Source: ABdhPJybzkfP8XOFigNlJyzeIyrO7HboVnS/qJJzz7nmtrMseCsv7OL9og0Trni5G+5ezjx895WlaNoVaWQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:3646:0:b0:51b:91c7:fd4a with SMTP id
 d67-20020a623646000000b0051b91c7fd4amr16238495pfa.78.1654217274137; Thu, 02
 Jun 2022 17:47:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:30 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-144-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 143/144] KVM: selftests: Add TEST_REQUIRE macros to reduce
 skipping copy+paste
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add TEST_REQUIRE() and __TEST_REQUIRE() to replace the myriad open coded
instances of selftests exiting with KSFT_SKIP after printing an
informational message.  In addition to reducing the amount of boilerplate
code in selftests, the UPPERCASE macro names make it easier to visually
identify a test's requirements.

Convert usage that erroneously uses something other than print_skip()
and/or "exits" with '0' or some other non-KSFT_SKIP value.

Intentionally drop a kvm_vm_free() in aarch64/debug-exceptions.c as part
of the conversion.  All memory and file descriptors are freed on process
exit, so the explicit free is superfluous.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 11 +++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  |  7 ++----
 .../selftests/kvm/aarch64/get-reg-list.c      | 10 +++++---
 .../testing/selftests/kvm/aarch64/psci_test.c |  5 +---
 .../selftests/kvm/aarch64/vcpu_width_config.c |  5 +---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 10 +++-----
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  5 +---
 .../selftests/kvm/access_tracking_perf_test.c | 11 +++-----
 .../testing/selftests/kvm/include/test_util.h |  9 +++++++
 .../selftests/kvm/kvm_binary_stats_test.c     |  5 +---
 .../selftests/kvm/kvm_create_max_vcpus.c      |  6 ++---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 10 ++------
 .../selftests/kvm/lib/x86_64/processor.c      |  8 +++---
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  5 +---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  5 +---
 tools/testing/selftests/kvm/rseq_test.c       | 13 ++++------
 tools/testing/selftests/kvm/s390x/memop.c     | 11 ++------
 .../selftests/kvm/s390x/sync_regs_test.c      |  8 ++----
 tools/testing/selftests/kvm/steal_time.c      |  5 +---
 .../kvm/system_counter_offset_test.c          |  8 +++---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 23 ++++++-----------
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |  5 +---
 .../testing/selftests/kvm/x86_64/debug_regs.c |  5 +---
 .../kvm/x86_64/emulator_error_test.c          |  5 +---
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  9 +++----
 .../selftests/kvm/x86_64/fix_hypercall_test.c |  5 +---
 .../kvm/x86_64/get_msr_index_features.c       |  5 +---
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |  5 +---
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  6 ++---
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  6 +----
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  5 +---
 .../selftests/kvm/x86_64/mmio_warning_test.c  | 10 ++------
 .../selftests/kvm/x86_64/mmu_role_test.c      | 10 ++------
 .../selftests/kvm/x86_64/platform_info_test.c |  7 +-----
 .../kvm/x86_64/pmu_event_filter_test.c        | 25 ++++---------------
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  5 +---
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 19 +++++---------
 .../selftests/kvm/x86_64/sync_regs_test.c     | 10 ++------
 .../kvm/x86_64/triple_fault_event_test.c      | 10 ++------
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  5 +---
 .../vmx_exception_with_invalid_guest_state.c  |  6 ++---
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 10 +-------
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 23 ++++++-----------
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  5 +---
 .../kvm/x86_64/vmx_set_nested_state_test.c    |  5 +---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  5 +---
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  8 +++---
 .../selftests/kvm/x86_64/xss_msr_test.c       | 13 +++-------
 48 files changed, 117 insertions(+), 295 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index ca4c08b4e353..f68019be67c0 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -375,10 +375,7 @@ static struct kvm_vm *test_vm_create(void)
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
 	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
-	if (gic_fd < 0) {
-		print_skip("Failed to create vgic-v3");
-		exit(KSFT_SKIP);
-	}
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
 
 	/* Make all the test's cmdline args visible to the guest */
 	sync_global_to_guest(vm, test_args);
@@ -468,10 +465,8 @@ int main(int argc, char *argv[])
 	if (!parse_args(argc, argv))
 		exit(KSFT_SKIP);
 
-	if (test_args.migration_freq_ms && get_nprocs() < 2) {
-		print_skip("At least two physical CPUs needed for vCPU migration");
-		exit(KSFT_SKIP);
-	}
+	__TEST_REQUIRE(!test_args.migration_freq_ms || get_nprocs() >= 2,
+		       "At least two physical CPUs needed for vCPU migration");
 
 	vm = test_vm_create();
 	test_run(vm);
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index c27352b90ccf..b8072b40ccc8 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -259,11 +259,8 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	if (debug_version(vcpu) < 6) {
-		print_skip("Armv8 debug architecture not supported.");
-		kvm_vm_free(vm);
-		exit(KSFT_SKIP);
-	}
+	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+		       "Armv8 debug architecture not supported.");
 
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 013bf0f54580..b3116c151d1c 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -395,10 +395,12 @@ static void check_supported(struct vcpu_config *c)
 	struct reg_sublist *s;
 
 	for_each_sublist(c, s) {
-		if (s->capability && !kvm_has_cap(s->capability)) {
-			fprintf(stderr, "%s: %s not available, skipping tests\n", config_name(c), s->name);
-			exit(KSFT_SKIP);
-		}
+		if (!s->capability)
+			continue;
+
+		__TEST_REQUIRE(kvm_has_cap(s->capability),
+			       "%s: %s not available, skipping tests\n",
+			       config_name(c), s->name);
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 7928c62635fd..a889e1cf5e4d 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -192,10 +192,7 @@ static void host_test_system_suspend(void)
 
 int main(void)
 {
-	if (!kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND)) {
-		print_skip("KVM_CAP_ARM_SYSTEM_SUSPEND not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND));
 
 	host_test_cpu_on();
 	host_test_system_suspend();
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
index fff02c442610..80b74c6f152b 100644
--- a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -82,10 +82,7 @@ int main(void)
 	struct kvm_vm *vm;
 	int ret;
 
-	if (!kvm_has_cap(KVM_CAP_ARM_EL1_32BIT)) {
-		print_skip("KVM_CAP_ARM_EL1_32BIT is not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_EL1_32BIT));
 
 	/* Get the preferred target type and copy that to init1 for later use */
 	vm = vm_create_barebones();
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 56b76fbfffea..b91ea02a8a80 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -719,13 +719,9 @@ int main(int ac, char **av)
 	}
 
 	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V2);
-	if (!ret) {
-		pr_info("Running GIC_v2 tests.\n");
-		run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
-		return 0;
-	}
+	__TEST_REQUIRE(!ret, "No GICv2 nor GICv3 support");
 
-	print_skip("No GICv2 nor GICv3 support");
-	exit(KSFT_SKIP);
+	pr_info("Running GIC_v2 tests.\n");
+	run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 90dbba61d72a..046ba4fde648 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -768,10 +768,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 
 	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
 			GICD_BASE_GPA, GICR_BASE_GPA);
-	if (gic_fd < 0) {
-		print_skip("Failed to create vgic-v3, skipping");
-		exit(KSFT_SKIP);
-	}
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3, skipping");
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
 		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 1c771378f7f4..1c2749b1481a 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -104,10 +104,7 @@ static uint64_t lookup_pfn(int pagemap_fd, struct kvm_vm *vm, uint64_t gva)
 		return 0;
 
 	pfn = entry & PAGEMAP_PFN_MASK;
-	if (!pfn) {
-		print_skip("Looking up PFNs requires CAP_SYS_ADMIN");
-		exit(KSFT_SKIP);
-	}
+	__TEST_REQUIRE(pfn, "Looking up PFNs requires CAP_SYS_ADMIN");
 
 	return pfn;
 }
@@ -380,10 +377,8 @@ int main(int argc, char *argv[])
 	}
 
 	page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
-	if (page_idle_fd < 0) {
-		print_skip("CONFIG_IDLE_PAGE_TRACKING is not enabled");
-		exit(KSFT_SKIP);
-	}
+	__TEST_REQUIRE(page_idle_fd >= 0,
+		       "CONFIG_IDLE_PAGE_TRACKING is not enabled");
 	close(page_idle_fd);
 
 	for_each_guest_mode(run_test, &params);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 99e0dcdc923f..493b2a799a61 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -34,6 +34,15 @@ static inline int _no_printf(const char *format, ...) { return 0; }
 #endif
 
 void print_skip(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
+#define __TEST_REQUIRE(f, fmt, ...)		\
+do {						\
+	if (!(f)) {				\
+		print_skip(fmt, ##__VA_ARGS__);	\
+		exit(KSFT_SKIP);		\
+	}					\
+} while (0)
+
+#define TEST_REQUIRE(f) __TEST_REQUIRE(f, "Requirement not met: %s", #f)
 
 ssize_t test_write(int fd, const void *buf, size_t count);
 ssize_t test_read(int fd, void *buf, size_t count);
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 8754b78ae785..1baabf955d63 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -213,10 +213,7 @@ int main(int argc, char *argv[])
 	}
 
 	/* Check the extension for binary stats */
-	if (!kvm_has_cap(KVM_CAP_BINARY_STATS_FD)) {
-		print_skip("Binary form statistics interface is not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_BINARY_STATS_FD));
 
 	/* Create VMs and VCPUs */
 	vms = malloc(sizeof(vms[0]) * max_vm);
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index 3ae0237e96b2..31b3cb24b9a7 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -64,11 +64,9 @@ int main(int argc, char *argv[])
 			rl.rlim_max = nr_fds_wanted;
 
 			int r = setrlimit(RLIMIT_NOFILE, &rl);
-			if (r < 0) {
-				printf("RLIMIT_NOFILE hard limit is too low (%d, wanted %d)\n",
+			__TEST_REQUIRE(r >= 0,
+				       "RLIMIT_NOFILE hard limit is too low (%d, wanted %d)\n",
 				       old_rlim_max, nr_fds_wanted);
-				exit(KSFT_SKIP);
-			}
 		} else {
 			TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
 		}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 12b7c40542df..603a6d529357 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -26,10 +26,7 @@ int open_path_or_exit(const char *path, int flags)
 	int fd;
 
 	fd = open(path, flags);
-	if (fd < 0) {
-		print_skip("%s not available (errno: %d)", path, errno);
-		exit(KSFT_SKIP);
-	}
+	__TEST_REQUIRE(fd >= 0, "%s not available (errno: %d)", path, errno);
 
 	return fd;
 }
@@ -93,10 +90,7 @@ static void vm_open(struct kvm_vm *vm)
 {
 	vm->kvm_fd = _open_kvm_dev_path_or_exit(O_RDWR);
 
-	if (!kvm_has_cap(KVM_CAP_IMMEDIATE_EXIT)) {
-		print_skip("immediate_exit not available");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_IMMEDIATE_EXIT));
 
 	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, vm->type);
 	TEST_ASSERT(vm->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm->fd));
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index b95458cadafe..a871723f7ee1 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -610,14 +610,14 @@ void vm_xsave_req_perm(int bit)
 	kvm_fd = open_kvm_dev_path_or_exit();
 	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	close(kvm_fd);
+
 	if (rc == -1 && (errno == ENXIO || errno == EINVAL))
 		exit(KSFT_SKIP);
 	TEST_ASSERT(rc == 0, "KVM_GET_DEVICE_ATTR(0, KVM_X86_XCOMP_GUEST_SUPP) error: %ld", rc);
-	if (!(bitmask & (1ULL << bit)))
-		exit(KSFT_SKIP);
 
-	if (!is_xfd_supported())
-		exit(KSFT_SKIP);
+	TEST_REQUIRE(bitmask & (1ULL << bit));
+
+	TEST_REQUIRE(is_xfd_supported());
 
 	rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 01a9d831da13..37e9c0a923e0 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -174,10 +174,7 @@ bool nested_svm_supported(void)
 
 void nested_svm_check_supported(void)
 {
-	if (!nested_svm_supported()) {
-		print_skip("nested SVM not enabled");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(nested_svm_supported());
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 5469a1da471a..3ba8278c5086 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -381,10 +381,7 @@ bool nested_vmx_supported(void)
 
 void nested_vmx_check_supported(void)
 {
-	if (!nested_vmx_supported()) {
-		print_skip("nested VMX not enabled");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(nested_vmx_supported());
 }
 
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 68c0c8bb206e..aba7be178dab 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -171,12 +171,11 @@ static void *migration_worker(void *ign)
 	return NULL;
 }
 
-static int calc_min_max_cpu(void)
+static void calc_min_max_cpu(void)
 {
 	int i, cnt, nproc;
 
-	if (CPU_COUNT(&possible_mask) < 2)
-		return -EINVAL;
+	TEST_REQUIRE(CPU_COUNT(&possible_mask) >= 2);
 
 	/*
 	 * CPU_SET doesn't provide a FOR_EACH helper, get the min/max CPU that
@@ -198,7 +197,8 @@ static int calc_min_max_cpu(void)
 		cnt++;
 	}
 
-	return (cnt < 2) ? -EINVAL : 0;
+	__TEST_REQUIRE(cnt >= 2,
+		       "Only one usable CPU, task migration not possible");
 }
 
 int main(int argc, char *argv[])
@@ -215,10 +215,7 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
 		    strerror(errno));
 
-	if (calc_min_max_cpu()) {
-		print_skip("Only one usable CPU, task migration not possible");
-		exit(KSFT_SKIP);
-	}
+	calc_min_max_cpu();
 
 	sys_rseq(0);
 
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 6175cdb61e8a..2ca141749bcf 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -695,19 +695,12 @@ static void test_errors(void)
 
 int main(int argc, char *argv[])
 {
-	int memop_cap, extension_cap;
-
 	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
 
-	memop_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP);
-	extension_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP_EXTENSION);
-	if (!memop_cap) {
-		print_skip("CAP_S390_MEM_OP not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_MEM_OP));
 
 	test_copy();
-	if (extension_cap > 0) {
+	if (kvm_has_cap(KVM_CAP_S390_MEM_OP_EXTENSION)) {
 		test_copy_key();
 		test_copy_key_storage_prot_override();
 		test_copy_key_fetch_prot();
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index 13c4c091aa66..e08629ad19f3 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -79,16 +79,12 @@ int main(int argc, char *argv[])
 	struct kvm_run *run;
 	struct kvm_regs regs;
 	struct kvm_sregs sregs;
-	int rv, cap;
+	int rv;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	cap = kvm_check_cap(KVM_CAP_SYNC_REGS);
-	if (!cap) {
-		print_skip("CAP_SYNC_REGS not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_SYNC_REGS));
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 398819d4074f..d122f1e05cdd 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -271,10 +271,7 @@ int main(int ac, char **av)
 	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
 	ucall_init(vm, NULL);
 
-	if (!is_steal_time_supported(vcpus[0])) {
-		print_skip("steal-time not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
 
 	/* Run test on each VCPU */
 	for (i = 0; i < NR_VCPUS; ++i) {
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 7c8be0930737..862a8e93e070 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -28,11 +28,9 @@ static struct test_case test_cases[] = {
 
 static void check_preconditions(struct kvm_vcpu *vcpu)
 {
-	if (!__vcpu_has_device_attr(vcpu, KVM_VCPU_TSC_CTRL, KVM_VCPU_TSC_OFFSET))
-		return;
-
-	print_skip("KVM_VCPU_TSC_OFFSET not supported; skipping test");
-	exit(KSFT_SKIP);
+	__TEST_REQUIRE(!__vcpu_has_device_attr(vcpu, KVM_VCPU_TSC_CTRL,
+					       KVM_VCPU_TSC_OFFSET),
+		       "KVM_VCPU_TSC_OFFSET not supported; skipping test");
 }
 
 static void setup_system_counter(struct kvm_vcpu *vcpu, struct test_case *test)
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index b421c8369dba..dab4ca16a2df 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -317,7 +317,6 @@ int main(int argc, char *argv[])
 {
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_regs regs1, regs2;
-	bool amx_supported = false;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
@@ -334,21 +333,15 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	entry = kvm_get_supported_cpuid_entry(1);
-	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
-		print_skip("XSAVE feature not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(entry->ecx & X86_FEATURE_XSAVE);
 
-	if (kvm_get_cpuid_max_basic() >= 0xd) {
-		entry = kvm_get_supported_cpuid_index(0xd, 0);
-		amx_supported = entry && !!(entry->eax & XFEATURE_MASK_XTILE);
-		if (!amx_supported) {
-			print_skip("AMX is not supported by the vCPU (eax=0x%x)", entry->eax);
-			exit(KSFT_SKIP);
-		}
-		/* Get xsave/restore max size */
-		xsave_restore_size = entry->ecx;
-	}
+	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xd);
+
+	entry = kvm_get_supported_cpuid_index(0xd, 0);
+	TEST_REQUIRE(entry->eax & XFEATURE_MASK_XTILE);
+
+	/* Get xsave/restore max size */
+	xsave_restore_size = entry->ecx;
 
 	run = vcpu->run;
 	vcpu_regs_get(vcpu, &regs1);
diff --git a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
index 1635aae970e9..a80940ac420f 100644
--- a/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c
@@ -70,10 +70,7 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 
 	entry = kvm_get_supported_cpuid_entry(1);
-	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
-		print_skip("XSAVE feature not supported");
-		return 0;
-	}
+	TEST_REQUIRE(entry->ecx & X86_FEATURE_XSAVE);
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index bba811edef96..7ef99c3359a0 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -95,10 +95,7 @@ int main(void)
 		1,		/* cli */
 	};
 
-	if (!kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG)) {
-		print_skip("KVM_CAP_SET_GUEST_DEBUG not supported");
-		return 0;
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	run = vcpu->run;
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index 119bcb1158d5..bfff2d271c48 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -162,10 +162,7 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	if (!kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR)) {
-		printf("module parameter 'allow_smaller_maxphyaddr' is not set.  Skipping test.\n");
-		return 0;
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index a6da1ccbee4e..8dda527cc080 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -208,12 +208,9 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	if (!nested_vmx_supported() ||
-	    !kvm_has_cap(KVM_CAP_NESTED_STATE) ||
-	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
-		print_skip("Enlightened VMCS is unsupported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(nested_vmx_supported());
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS));
 
 	vcpu_set_hv_cpuid(vcpu);
 	vcpu_enable_evmcs(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
index 137759547720..f6f251ce59e1 100644
--- a/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
@@ -156,10 +156,7 @@ static void test_fix_hypercall_disabled(void)
 
 int main(void)
 {
-	if (!(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) & KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
-		print_skip("KVM_X86_QUIRK_HYPERCALL_INSN not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) & KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
 
 	test_fix_hypercall();
 	test_fix_hypercall_disabled();
diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
index 1e366fdfe7be..d09b3cbcadc6 100644
--- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
+++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
@@ -25,10 +25,7 @@ int main(int argc, char *argv[])
 	 * will cover the "regular" list of MSRs, the coverage here is purely
 	 * opportunistic and not interesting on its own.
 	 */
-	if (!kvm_check_cap(KVM_CAP_GET_MSR_FEATURES)) {
-		print_skip("KVM_CAP_GET_MSR_FEATURES not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GET_MSR_FEATURES));
 
 	(void)kvm_get_msr_index_list();
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index e2fac752d354..cbd4a7d36189 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -137,10 +137,7 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	if (!kvm_has_cap(KVM_CAP_HYPERV_CPUID)) {
-		print_skip("KVM_CAP_HYPERV_CPUID not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_CPUID));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 171009184c3b..c5cd9835dbd6 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -127,10 +127,8 @@ int main(int argc, char *argv[])
 	struct ucall uc;
 	int stage;
 
-	if (!nested_svm_supported()) {
-		print_skip("Nested SVM not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(nested_svm_supported());
+
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	vcpu_set_hv_cpuid(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
index 6e3c4bd60b76..138455575a11 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -181,11 +181,7 @@ int main(void)
 	int flags;
 
 	flags = kvm_check_cap(KVM_CAP_ADJUST_CLOCK);
-	if (!(flags & KVM_CLOCK_REALTIME)) {
-		print_skip("KVM_CLOCK_REALTIME not supported; flags: %x",
-			   flags);
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(flags & KVM_CLOCK_REALTIME);
 
 	check_clocksource();
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 24dad3a47206..5901ccec7079 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -204,10 +204,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	if (!kvm_has_cap(KVM_CAP_ENFORCE_PV_FEATURE_CPUID)) {
-		print_skip("KVM_CAP_ENFORCE_PV_FEATURE_CPUID not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ENFORCE_PV_FEATURE_CPUID));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
index 31ae837fedb1..0e4590afd0e1 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -93,15 +93,9 @@ int main(void)
 {
 	int warnings_before, warnings_after;
 
-	if (!is_intel_cpu()) {
-		print_skip("Must be run on an Intel CPU");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(is_intel_cpu());
 
-	if (vm_is_unrestricted_guest(NULL)) {
-		print_skip("Unrestricted guest must be disabled");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(!vm_is_unrestricted_guest(NULL));
 
 	warnings_before = get_warnings_count();
 
diff --git a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
index 62e674095bd2..9fd82580a382 100644
--- a/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmu_role_test.c
@@ -117,16 +117,10 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!do_gbpages && !do_maxphyaddr) {
-		print_skip("No sub-tests selected");
-		return 0;
-	}
+	__TEST_REQUIRE(do_gbpages || do_maxphyaddr, "No sub-tests selected");
 
 	entry = kvm_get_supported_cpuid_entry(0x80000001);
-	if (!(entry->edx & CPUID_GBPAGES)) {
-		print_skip("1gb hugepages not supported");
-		return 0;
-	}
+	TEST_REQUIRE(entry->edx & CPUID_GBPAGES);
 
 	if (do_gbpages) {
 		pr_info("Test MMIO after toggling CPUID.GBPAGES\n\n");
diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index 3cb48e4b615b..76417c7d687b 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -70,17 +70,12 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	int rv;
 	uint64_t msr_platform_info;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	rv = kvm_check_cap(KVM_CAP_MSR_PLATFORM_INFO);
-	if (!rv) {
-		print_skip("KVM_CAP_MSR_PLATFORM_INFO not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_MSR_PLATFORM_INFO));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index ffa6a2f93de2..de9ee00d84cf 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -417,39 +417,24 @@ static bool use_amd_pmu(void)
 
 int main(int argc, char *argv[])
 {
-	void (*guest_code)(void) = NULL;
+	void (*guest_code)(void);
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	int r;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	r = kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER);
-	if (!r) {
-		print_skip("KVM_CAP_PMU_EVENT_FILTER not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER));
 
-	if (use_intel_pmu())
-		guest_code = intel_guest_code;
-	else if (use_amd_pmu())
-		guest_code = amd_guest_code;
-
-	if (!guest_code) {
-		print_skip("Don't know how to test this guest PMU");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
+	guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	if (!sanity_check_pmu(vcpu)) {
-		print_skip("Guest PMU is not functional");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(sanity_check_pmu(vcpu));
 
 	test_without_filter(vcpu);
 	test_member_deny_list(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index abf740f08d68..7ef713fdd0a5 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -123,10 +123,7 @@ static void check_set_bsp_busy(void)
 
 int main(int argc, char *argv[])
 {
-	if (!kvm_has_cap(KVM_CAP_SET_BOOT_CPU_ID)) {
-		print_skip("set_boot_cpu_id not available");
-		return 0;
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_BOOT_CPU_ID));
 
 	run_vm_bsp(0);
 	run_vm_bsp(1);
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index ffd8613987ae..76ba6fc80e37 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -400,22 +400,15 @@ int main(int argc, char *argv[])
 {
 	struct kvm_cpuid_entry2 *cpuid;
 
-	if (!kvm_has_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM) &&
-	    !kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
-		print_skip("Capabilities not available");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM));
 
 	cpuid = kvm_get_supported_cpuid_entry(0x80000000);
-	if (cpuid->eax < 0x8000001f) {
-		print_skip("AMD memory encryption not available");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(cpuid->eax >= 0x8000001f);
+
 	cpuid = kvm_get_supported_cpuid_entry(0x8000001f);
-	if (!(cpuid->eax & X86_FEATURE_SEV)) {
-		print_skip("AMD SEV not available");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(cpuid->eax & X86_FEATURE_SEV);
+
 	have_sev_es = !!(cpuid->eax & X86_FEATURE_SEV_ES);
 
 	if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index 773db9d4f228..9b6db0b0b13e 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -94,14 +94,8 @@ int main(int argc, char *argv[])
 	setbuf(stdout, NULL);
 
 	cap = kvm_check_cap(KVM_CAP_SYNC_REGS);
-	if ((cap & TEST_SYNC_FIELDS) != TEST_SYNC_FIELDS) {
-		print_skip("KVM_CAP_SYNC_REGS not supported");
-		exit(KSFT_SKIP);
-	}
-	if ((cap & INVALID_SYNC_FIELD) != 0) {
-		print_skip("The \"invalid\" field is not invalid");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE((cap & TEST_SYNC_FIELDS) == TEST_SYNC_FIELDS);
+	TEST_REQUIRE(!(cap & INVALID_SYNC_FIELD));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
index 078bd7a0bbb1..5a202ecb8ea0 100644
--- a/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86_64/triple_fault_event_test.c
@@ -46,15 +46,9 @@ int main(void)
 	vm_vaddr_t vmx_pages_gva;
 	struct ucall uc;
 
-	if (!nested_vmx_supported()) {
-		print_skip("Nested VMX not supported");
-		exit(KSFT_SKIP);
-	}
+	nested_vmx_check_supported();
 
-	if (!kvm_has_cap(KVM_CAP_X86_TRIPLE_FAULT_EVENT)) {
-		print_skip("KVM_CAP_X86_TRIPLE_FAULT_EVENT not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_TRIPLE_FAULT_EVENT));
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 	vm_enable_cap(vm, KVM_CAP_X86_TRIPLE_FAULT_EVENT, 1);
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index fcc713ff75ff..47139aab7408 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -93,10 +93,7 @@ static void *run_vcpu(void *_cpu_nr)
 
 int main(int argc, char *argv[])
 {
-	if (!kvm_has_cap(KVM_CAP_VM_TSC_CONTROL)) {
-		print_skip("KVM_CAP_VM_TSC_CONTROL not available");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_TSC_CONTROL));
 
 	vm = vm_create(NR_TEST_VCPUS);
 	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
index 5bc2cee0d613..2641b286b4ed 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_exception_with_invalid_guest_state.c
@@ -111,10 +111,8 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	if (!is_intel_cpu() || vm_is_unrestricted_guest(NULL)) {
-		print_skip("Must be run with kvm_intel.unrestricted_guest=0");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(is_intel_cpu());
+	TEST_REQUIRE(!vm_is_unrestricted_guest(NULL));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	get_set_sigalrm_vcpu(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
index 190af8124677..ff4644038c55 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_nested_tsc_scaling_test.c
@@ -116,14 +116,6 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 	GUEST_DONE();
 }
 
-static void tsc_scaling_check_supported(void)
-{
-	if (!kvm_has_cap(KVM_CAP_TSC_CONTROL)) {
-		print_skip("TSC scaling not supported by the HW");
-		exit(KSFT_SKIP);
-	}
-}
-
 static void stable_tsc_check_supported(void)
 {
 	FILE *fp;
@@ -159,7 +151,7 @@ int main(int argc, char *argv[])
 	uint64_t l2_tsc_freq = 0;
 
 	nested_vmx_check_supported();
-	tsc_scaling_check_supported();
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_TSC_CONTROL));
 	stable_tsc_check_supported();
 
 	/*
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index a308442458b8..eb592fae44ef 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -57,7 +57,6 @@ int main(int argc, char *argv[])
 	struct kvm_cpuid2 *cpuid;
 	struct kvm_cpuid_entry2 *entry_1_0;
 	struct kvm_cpuid_entry2 *entry_a_0;
-	bool pdcm_supported = false;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	int ret;
@@ -71,20 +70,14 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	cpuid = kvm_get_supported_cpuid();
 
-	if (kvm_get_cpuid_max_basic() >= 0xa) {
-		entry_1_0 = kvm_get_supported_cpuid_index(1, 0);
-		entry_a_0 = kvm_get_supported_cpuid_index(0xa, 0);
-		pdcm_supported = entry_1_0 && !!(entry_1_0->ecx & X86_FEATURE_PDCM);
-		eax.full = entry_a_0->eax;
-	}
-	if (!pdcm_supported) {
-		print_skip("MSR_IA32_PERF_CAPABILITIES is not supported by the vCPU");
-		exit(KSFT_SKIP);
-	}
-	if (!eax.split.version_id) {
-		print_skip("PMU is not supported by the vCPU");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xa);
+
+	entry_1_0 = kvm_get_supported_cpuid_index(1, 0);
+	entry_a_0 = kvm_get_supported_cpuid_index(0xa, 0);
+	TEST_REQUIRE(entry_1_0->ecx & X86_FEATURE_PDCM);
+
+	eax.full = entry_a_0->eax;
+	__TEST_REQUIRE(eax.split.version_id, "PMU is not supported by the vCPU");
 
 	/* testcase 1, set capabilities when we have PDCM bit */
 	vcpu_set_cpuid(vcpu, cpuid);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index 7438258511da..99e57b0cc2c9 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -169,10 +169,7 @@ int main(int argc, char *argv[])
 	 */
 	nested_vmx_check_supported();
 
-	if (!kvm_has_cap(KVM_CAP_NESTED_STATE)) {
-		print_skip("KVM_CAP_NESTED_STATE not supported");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 21f280a7c5e1..b564b86dfc1d 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -267,10 +267,7 @@ int main(int argc, char *argv[])
 
 	have_evmcs = kvm_check_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS);
 
-	if (!kvm_has_cap(KVM_CAP_NESTED_STATE)) {
-		print_skip("KVM_CAP_NESTED_STATE not available");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
 
 	/*
 	 * AMD currently does not implement set_nested_state, so for now we
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 4340c2f2300f..bdcb28186ccc 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -362,10 +362,7 @@ int main(int argc, char *argv[])
 			       !strncmp(argv[1], "--verbose", 10));
 
 	int xen_caps = kvm_check_cap(KVM_CAP_XEN_HVM);
-	if (!(xen_caps & KVM_XEN_HVM_CONFIG_SHARED_INFO) ) {
-		print_skip("KVM_XEN_HVM_CONFIG_SHARED_INFO not available");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(xen_caps & KVM_XEN_HVM_CONFIG_SHARED_INFO);
 
 	bool do_runstate_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_RUNSTATE);
 	bool do_eventfd_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL);
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index a91f11fb26f4..8b76cade9bcd 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -80,14 +80,12 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
+	unsigned int xen_caps;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	if (!(kvm_check_cap(KVM_CAP_XEN_HVM) &
-	      KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) ) {
-		print_skip("KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL not available");
-		exit(KSFT_SKIP);
-	}
+	xen_caps = kvm_check_cap(KVM_CAP_XEN_HVM);
+	TEST_REQUIRE(xen_caps & KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL);
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	vcpu_set_hv_cpuid(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
index 1e3506c3deed..4e2e08059b95 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -19,7 +19,6 @@
 int main(int argc, char *argv[])
 {
 	struct kvm_cpuid_entry2 *entry;
-	bool xss_supported = false;
 	bool xss_in_msr_list;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -29,14 +28,10 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
-	if (kvm_get_cpuid_max_basic() >= 0xd) {
-		entry = kvm_get_supported_cpuid_index(0xd, 1);
-		xss_supported = entry && !!(entry->eax & X86_FEATURE_XSAVES);
-	}
-	if (!xss_supported) {
-		print_skip("IA32_XSS is not supported by the vCPU");
-		exit(KSFT_SKIP);
-	}
+	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xd);
+
+	entry = kvm_get_supported_cpuid_index(0xd, 1);
+	TEST_REQUIRE(entry->eax & X86_FEATURE_XSAVES);
 
 	xss_val = vcpu_get_msr(vcpu, MSR_IA32_XSS);
 	TEST_ASSERT(xss_val == 0,
-- 
2.36.1.255.ge46751e96f-goog

