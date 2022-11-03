Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB936188AA
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 20:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiKCTUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 15:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiKCTTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 15:19:41 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68C4220FE
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 12:17:55 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id f189-20020a6238c6000000b0056e3400fdc0so1172626pfa.10
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 12:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VE7RW56VayO0keHNnwyMULSgmJMIPboymyf3dnMpIn8=;
        b=dP06Br4JqYIplmuDlAtw8NBC+7JUvZT/C7ro4K3jXNYWrwSPrgJpl0+uHN7VL6sqQA
         N5IDDScJ9pn8OFNVw5BiW9bPmtVrxqPhIx98k/ZYGVIJqmijFynyPv8l5O5OHZqwX59D
         5c2VHbPch+kLoZSHgsf3qRYJoaO5jO3bm7zzL157WfPUALtR9KPBrKoduYJ2o2ambwtj
         d1dmvwelsNsILAAx1/4TQ/sdHjKQpgUd6vkHfhUd5w0V4iDmpAFTlHn+WwyfDai9uW+l
         7F4auKXvQmQslZ5G9HMyHp3gOR7NITa9rRHwjmexITZIFDs825hDqcphrS6DgrGW9oJZ
         WfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VE7RW56VayO0keHNnwyMULSgmJMIPboymyf3dnMpIn8=;
        b=WOYNkWGudvIYxlw09ysIxZM49FYLlphOp95PAOJXc4gmiMfJ130BVwDsKVck/cU2fQ
         2zuvqmCG7DVr4PWV4kR63TeqBB2lrFtnMXuN9WVn6UyCngQdtyOxZXaDOiin9xTYtNV1
         Qj3FITaFUBAspHZRvpCQAHzMNggnF0/jj4+NjD8I5jkuFZinlWYIiPlRqo2KCxzOw02n
         DpWveQ0/vedK667r3Y8i54sqegDgN4nKtxR247C+Xi8KYZMTiAJjcb6+OC0PD6CTkNtk
         SMsfxo0Eg1lbxHilHIYkG0YIHagC1b+Ok1qnGhO5N0Uc52vMhSqwBVngfW9KjHEjISM+
         t11g==
X-Gm-Message-State: ACrzQf1fPn5VpjDynOpknUXxs8F3/skfvWSDYTI9KSBBh3l5dddjqyZd
        VKZ+TqxdV8vRZxKrB8PJmVEgdwaTobdP
X-Google-Smtp-Source: AMsMyM4hBl4M9fbpMdGpzYElHUBrf9nCvqojz3WQNHWrEUlKpMlDYb9B4dvU37yIpnHK9KVboTV5Bql8iMiL
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:f291:b0:20a:eab5:cf39 with SMTP id
 fs17-20020a17090af29100b0020aeab5cf39mr144204pjb.1.1667503058552; Thu, 03 Nov
 2022 12:17:38 -0700 (PDT)
Date:   Thu,  3 Nov 2022 12:17:19 -0700
In-Reply-To: <20221103191719.1559407-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221103191719.1559407-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221103191719.1559407-8-vipinsh@google.com>
Subject: [PATCH v9 7/7] KVM: selftests: Allowing running dirty_log_perf_test
 on specific CPUs
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Add a command line option, -c, to pin vCPUs to physical CPUs (pCPUs),
i.e.  to force vCPUs to run on specific pCPUs.

Requirement to implement this feature came in discussion on the patch
"Make page tables for eager page splitting NUMA aware"
https://lore.kernel.org/lkml/YuhPT2drgqL+osLl@google.com/

This feature is useful as it provides a way to analyze performance based
on the vCPUs and dirty log worker locations, like on the different NUMA
nodes or on the same NUMA nodes.

To keep things simple, implementation is intentionally very limited,
either all of the vCPUs will be pinned followed by an optional main
thread or nothing will be pinned.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 25 ++++++++-
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 .../selftests/kvm/include/perf_test_util.h    |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 54 +++++++++++++++++++
 .../selftests/kvm/lib/perf_test_util.c        |  8 ++-
 5 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 4d639683b8ef..0612158329aa 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -353,7 +353,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
-	       "[-x memslots]\n", name);
+	       "[-x memslots] [-c physical cpus to run test on]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -383,6 +383,17 @@ static void help(char *name)
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
+	printf(" -c: Pin tasks to physical CPUs.  Takes a list of comma separated\n"
+	       "     values (target pCPU), one for each vCPU, plus an optional\n"
+	       "     entry for the main application task (specified via entry\n"
+	       "     <nr_vcpus + 1>).  If used, entries must be provided for all\n"
+	       "     vCPUs, i.e. pinning vCPUs is all or nothing.\n\n"
+	       "     E.g. to create 3 vCPUs, pin vCPU0=>pCPU22, vCPU1=>pCPU23,\n"
+	       "     vCPU2=>pCPU24, and pin the application task to pCPU50:\n\n"
+	       "         ./dirty_log_perf_test -v 3 -c 22,23,24,50\n\n"
+	       "     To leave the application task unpinned, drop the final entry:\n\n"
+	       "         ./dirty_log_perf_test -v 3 -c 22,23,24\n\n"
+	       "     (default: no pinning)\n");
 	puts("");
 	exit(0);
 }
@@ -390,6 +401,7 @@ static void help(char *name)
 int main(int argc, char *argv[])
 {
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
+	const char *pcpu_list = NULL;
 	struct test_params p = {
 		.iterations = TEST_HOST_LOOP_N,
 		.wr_fract = 1,
@@ -406,11 +418,14 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "b:ef:ghi:m:nop:s:v:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "b:c:ef:ghi:m:nop:s:v:x:")) != -1) {
 		switch (opt) {
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
+		case 'c':
+			pcpu_list = optarg;
+			break;
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
@@ -456,6 +471,12 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (pcpu_list) {
+		kvm_parse_vcpu_pinning(pcpu_list, perf_test_args.vcpu_to_pcpu,
+				       nr_vcpus);
+		perf_test_args.pin_vcpus = true;
+	}
+
 	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
 
 	pr_info("Test iterations: %"PRIu64"\n",	p.iterations);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..3bf2333ef95d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -688,6 +688,10 @@ static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 
 struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
+void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
+void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
+			    int nr_vcpus);
+
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
 unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index eaa88df0555a..849c875dd0ff 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -39,6 +39,10 @@ struct perf_test_args {
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
+	/* True if all vCPUs are pinned to pCPUs */
+	bool pin_vcpus;
+	/* The vCPU=>pCPU pinning map. Only valid if pin_vcpus is true. */
+	uint32_t vcpu_to_pcpu[KVM_MAX_VCPUS];
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f1cb1627161f..3b7710fb3784 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -11,6 +11,7 @@
 #include "processor.h"
 
 #include <assert.h>
+#include <sched.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -443,6 +444,59 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 	return vm_vcpu_recreate(vm, 0);
 }
 
+void kvm_pin_this_task_to_pcpu(uint32_t pcpu)
+{
+	cpu_set_t mask;
+	int r;
+
+	CPU_ZERO(&mask);
+	CPU_SET(pcpu, &mask);
+	r = sched_setaffinity(0, sizeof(mask), &mask);
+	TEST_ASSERT(!r, "sched_setaffinity() failed for pCPU '%u'.\n", pcpu);
+}
+
+static uint32_t parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
+{
+	uint32_t pcpu = atoi_non_negative("CPU number", cpu_str);
+
+	TEST_ASSERT(CPU_ISSET(pcpu, allowed_mask),
+		    "Not allowed to run on pCPU '%d', check cgroups?\n", pcpu);
+	return pcpu;
+}
+
+void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
+			    int nr_vcpus)
+{
+	cpu_set_t allowed_mask;
+	char *cpu, *cpu_list;
+	char delim[2] = ",";
+	int i, r;
+
+	cpu_list = strdup(pcpus_string);
+	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
+
+	r = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
+	TEST_ASSERT(!r, "sched_getaffinity() failed");
+
+	cpu = strtok(cpu_list, delim);
+
+	/* 1. Get all pcpus for vcpus. */
+	for (i = 0; i < nr_vcpus; i++) {
+		TEST_ASSERT(cpu, "pCPU not provided for vCPU '%d'\n", i);
+		vcpu_to_pcpu[i] = parse_pcpu(cpu, &allowed_mask);
+		cpu = strtok(NULL, delim);
+	}
+
+	/* 2. Check if the main worker needs to be pinned. */
+	if (cpu) {
+		kvm_pin_this_task_to_pcpu(parse_pcpu(cpu, &allowed_mask));
+		cpu = strtok(NULL, delim);
+	}
+
+	TEST_ASSERT(!cpu, "pCPU list contains trailing garbage characters '%s'", cpu);
+	free(cpu_list);
+}
+
 /*
  * Userspace Memory Region Find
  *
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..3a1d0a44419b 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -2,6 +2,8 @@
 /*
  * Copyright (C) 2020, Google LLC.
  */
+#define _GNU_SOURCE
+
 #include <inttypes.h>
 
 #include "kvm_util.h"
@@ -243,6 +245,10 @@ void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_v
 static void *vcpu_thread_main(void *data)
 {
 	struct vcpu_thread *vcpu = data;
+	int vcpu_idx = vcpu->vcpu_idx;
+
+	if (perf_test_args.pin_vcpus)
+		kvm_pin_this_task_to_pcpu(perf_test_args.vcpu_to_pcpu[vcpu_idx]);
 
 	WRITE_ONCE(vcpu->running, true);
 
@@ -255,7 +261,7 @@ static void *vcpu_thread_main(void *data)
 	while (!READ_ONCE(all_vcpu_threads_running))
 		;
 
-	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_idx]);
+	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu_idx]);
 
 	return NULL;
 }
-- 
2.38.1.273.g43a17bfeac-goog

