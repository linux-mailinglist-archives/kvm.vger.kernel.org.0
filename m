Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADA45F6C8F
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 19:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiJFRMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 13:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiJFRMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 13:12:07 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEDAA98E7
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 10:12:03 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id o14-20020a056a00214e00b0056238ef46ebso1459001pfk.2
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 10:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bNbcK3LL3MeRLMBsJX3wEFu+BxWkeXqN6i942qppoGM=;
        b=S8qrJeH0gN8gfBUaxED2sgbwZGLAVK9GuIdQQZD/J9UmHKy8zhuU2xSlToWAUcJKRe
         5UKLTE50Lczc578QLLXLci1Fgb4UnLYL6/jGTHZWTGsLNVhla8yeTnMgNL4XgNCP8smh
         VMwDnAFa2wzCl2Rwrd6njaMK5jAhURzTPj0X0aTA2QJ5Py899Ni9BiJUDJZx/N6XXg2Q
         fs/YKdzRFFuQyL6jSmNaElLcqD5h3qd+zzYOYl1BvzND84wSlRE0F6r34DfztQGMfoSE
         j8G9YPdERjLazF77IcBX9JgmyIKjbGQLcyEyJ14lQlRPo//0+O2Y8LZyL5SOQKxuqqS+
         RMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bNbcK3LL3MeRLMBsJX3wEFu+BxWkeXqN6i942qppoGM=;
        b=ZJk2PED5HXzTxwWgSW1RtLiLYUaUhi34Tueii3kjVS++wKzC5iaEjHejTPfU1n7PK2
         sDQzu1rdhTMjFt9PFrkLM2BFeLKbeLWrMsepbX20LCKVCHTVT4DqE2Ih73luW1UoV/1R
         zoZUQBcbPHkR21hkRt6f/U4oDofahJpVauZozX+WSHx/bP8YYnmUPwl03T+Y15P8TgFh
         72XMM7esg8OnB7eFoyLy3srQCyC7Q1cEX6kR9CT4zthNQXeH9y2kyPoEaqmjjvI1d4dX
         gg1GAEoHugRKkLVRp+jRJpjin+bPFApQ1acpzalH7AjiY5u2ImD+zH1FsMpCIpkbCWW/
         NVcw==
X-Gm-Message-State: ACrzQf1aXq1Lzw2QOZg4f64h6ybxxQn/LzbHUxGWhCp0c0Rumz8ifVVR
        DC29DHKVwxFxsqiDSblkCtAuiIP0d5WC
X-Google-Smtp-Source: AMsMyM5rSvgSAK+YZ3JBGH9d6o9ZH5TCl/R/DmTIyBNezNnhmGVCjxSdKqbhIzk32aAAaVMSynctk/QdmCFi
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:784d:b0:178:6946:3ff7 with SMTP id
 e13-20020a170902784d00b0017869463ff7mr449882pln.133.1665076323020; Thu, 06
 Oct 2022 10:12:03 -0700 (PDT)
Date:   Thu,  6 Oct 2022 10:11:32 -0700
In-Reply-To: <20221006171133.372359-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221006171133.372359-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006171133.372359-5-vipinsh@google.com>
Subject: [PATCH v4 4/4] KVM: selftests: Run dirty_log_perf_test on specific CPUs
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Add command line options, -c,  to run the vCPUs and optionally the main
process on the specific CPUs on a host machine. This is useful as it
provides a way to analyze performance based on the vCPUs and dirty log
worker locations, like on the different numa nodes or on the same numa
nodes.

Link: https://lore.kernel.org/lkml/20220801151928.270380-1-vipinsh@google.com
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 23 +++++++-
 .../selftests/kvm/include/perf_test_util.h    |  6 ++
 .../selftests/kvm/lib/perf_test_util.c        | 58 ++++++++++++++++++-
 3 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index ecda802b78ff..33f83e423f75 100644
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
@@ -383,6 +383,18 @@ static void help(char *name)
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
+	printf(" -c: Comma separated values of the physical CPUs, which will run\n"
+	       "     the vCPUs, optionally, followed by the main application thread cpu.\n"
+	       "     Number of values must be at least the number of vCPUs.\n"
+	       "     The very next number is used to pin main application thread.\n\n"
+	       "     Example: ./dirty_log_perf_test -v 3 -c 22,23,24,50\n"
+	       "     This means that the vcpu 0 will run on the physical cpu 22,\n"
+	       "     vcpu 1 on the physical cpu 23, vcpu 2 on the physical cpu 24\n"
+	       "     and the main thread will run on cpu 50.\n\n"
+	       "     Example: ./dirty_log_perf_test -v 3 -c 22,23,24\n"
+	       "     Same as the previous example except now main application\n"
+	       "     thread can run on any physical cpu\n\n"
+	       "     (default: No cpu mapping)\n");
 	puts("");
 	exit(0);
 }
@@ -398,6 +410,7 @@ int main(int argc, char *argv[])
 		.slots = 1,
 	};
 	int opt;
+	const char *pcpu_list = NULL;
 
 	dirty_log_manual_caps =
 		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
@@ -406,11 +419,14 @@ int main(int argc, char *argv[])
 
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
@@ -458,6 +474,9 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (pcpu_list)
+		perf_test_setup_pinning(pcpu_list, nr_vcpus);
+
 	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
 
 	pr_info("Test iterations: %"PRIu64"\n",	p.iterations);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index eaa88df0555a..8197260e3b6b 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -27,6 +27,8 @@ struct perf_test_vcpu_args {
 	/* Only used by the host userspace part of the vCPU thread */
 	struct kvm_vcpu *vcpu;
 	int vcpu_idx;
+	/* The pCPU to which this vCPU is pinned. Only valid if pin_vcpus is true. */
+	int pcpu;
 };
 
 struct perf_test_args {
@@ -39,6 +41,8 @@ struct perf_test_args {
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
+	/* True if all vCPUs are pinned to pCPUs*/
+	bool pin_vcpus;
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
@@ -60,4 +64,6 @@ void perf_test_guest_code(uint32_t vcpu_id);
 uint64_t perf_test_nested_pages(int nr_vcpus);
 void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
 
+void perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus);
+
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..5d1aca0482b4 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -2,7 +2,10 @@
 /*
  * Copyright (C) 2020, Google LLC.
  */
+#define _GNU_SOURCE
+
 #include <inttypes.h>
+#include <sched.h>
 
 #include "kvm_util.h"
 #include "perf_test_util.h"
@@ -240,9 +243,25 @@ void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_v
 	exit(KSFT_SKIP);
 }
 
+static void pin_me_to_pcpu(int pcpu)
+{
+	cpu_set_t cpuset;
+	int err;
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(pcpu, &cpuset);
+	err = sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);
+	TEST_ASSERT(err == 0, "sched_setaffinity() errored out for pcpu: %d\n", pcpu);
+}
+
 static void *vcpu_thread_main(void *data)
 {
 	struct vcpu_thread *vcpu = data;
+	int idx = vcpu->vcpu_idx;
+	struct perf_test_vcpu_args *vcpu_args = &perf_test_args.vcpu_args[idx];
+
+	if (perf_test_args.pin_vcpus)
+		pin_me_to_pcpu(vcpu_args->pcpu);
 
 	WRITE_ONCE(vcpu->running, true);
 
@@ -255,7 +274,7 @@ static void *vcpu_thread_main(void *data)
 	while (!READ_ONCE(all_vcpu_threads_running))
 		;
 
-	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_idx]);
+	vcpu_thread_fn(vcpu_args);
 
 	return NULL;
 }
@@ -292,3 +311,40 @@ void perf_test_join_vcpu_threads(int nr_vcpus)
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_join(vcpu_threads[i].thread, NULL);
 }
+
+static int pcpu_num(const char *cpu_str)
+{
+	int pcpu = atoi_paranoid(cpu_str);
+	TEST_ASSERT(pcpu >= 0, "Invalid cpu number: %d\n", pcpu);
+	return pcpu;
+}
+
+void perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus)
+{
+	char delim[2] = ",";
+	char *cpu, *cpu_list;
+	int i = 0;
+
+	cpu_list = strdup(pcpus_string);
+	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
+
+	cpu = strtok(cpu_list, delim);
+
+	// 1. Get all pcpus for vcpus
+	while (cpu && i < nr_vcpus) {
+		perf_test_args.vcpu_args[i++].pcpu = pcpu_num(cpu);
+		cpu = strtok(NULL, delim);
+	}
+
+	TEST_ASSERT(i == nr_vcpus,
+		    "Number of pcpus (%d) not sufficient for the number of vcpus (%d).",
+		    i, nr_vcpus);
+
+	perf_test_args.pin_vcpus = true;
+
+	// 2. Check if main worker is provided
+	if (cpu)
+		pin_me_to_pcpu(pcpu_num(cpu));
+
+	free(cpu_list);
+}
-- 
2.38.0.rc1.362.ged0d419d3c-goog

