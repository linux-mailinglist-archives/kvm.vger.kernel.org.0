Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03FF5A2F49
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 20:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345311AbiHZStv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 14:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345315AbiHZStK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 14:49:10 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3778AEA8B0
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:46:07 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a21-20020a62bd15000000b005360da6b25aso1248094pff.23
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=stpKDIZUfAsiCHACs7kxVCVZD/2HAYo+g81a4039rSM=;
        b=JLKuVXKrzJAX9lRDhFsvN8/57xqI44Ve65I6izBKMAWQAMDfeEvNRM8DT3GncC3jwZ
         C5mD65vLDnS6SAxPZoqbFr5f7WpXMTrxN/dyNDj4aqpZvCoZugfQPwalqA6vRAitkQQ+
         iVq0c8TSx43/2GslVLWOp4abBXvIvl2/YnUmXq+KQOBelyY9wT8h7qhoazsR714fkWZ1
         sd/h8qjuKJ+2YBKQQ0LS2IX6ai5LBKslrfp8j7nMI82yApy++/Q7osQdgMMx85/E/pSr
         M2nnRFjmfvS/DvYqbuzLCnbHCCSa9wxSi81pxM1dOSbEKgcyRA3ov+eLejm79JsPxgRX
         O5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=stpKDIZUfAsiCHACs7kxVCVZD/2HAYo+g81a4039rSM=;
        b=vWXLiTrSfeV9wKGdFX55LWgN1UHkFEQN2XEDSuBVacx9Pph2RrBLa/YyZ1F7QJyNyA
         I3N4S85JIF2BcVCc59d0kQ+VXzdchTS3I4APF4NzA08hUzhWgzQ+K/CzcXNtFb0qahFH
         ynHBBUqsOvvhHAKm/JYhMRsowVjzJ93fXyB5fHXSyDiLjTLrQA9Lz6Y2JDSEOiSZY5vZ
         3ONMeookgX7bFnjyEXP67PW9KsdtuXrWiY0YA8Wzm2So08JL8su3SNPKnFtCOwpe2304
         HsJUKLiqVC8pIOYpafjCbLY3fgDnFDJPoNY/ZcldJQRRdu06GcFzNwgueaV1rPrQYsP0
         /21w==
X-Gm-Message-State: ACgBeo1lVWA9MWHXOK+VBXTCVLRdUQcs7RgF8ek+Tvgy7u4acex4jYcH
        y6+n6+HjKPaAvoSFZnBEarkg9Wm9xm/2
X-Google-Smtp-Source: AA6agR54JHf5XDCzHtZ9WW+dQdBMo2qJwzcI8ikqfIIMo2VhpBmsWT3mg59hNVT6q78/LP+pCPy1siiXW+CB
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:ad1:b0:530:2cb7:84e2 with SMTP id
 c17-20020a056a000ad100b005302cb784e2mr5057556pfl.18.1661539566895; Fri, 26
 Aug 2022 11:46:06 -0700 (PDT)
Date:   Fri, 26 Aug 2022 11:45:00 -0700
In-Reply-To: <20220826184500.1940077-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20220826184500.1940077-1-vipinsh@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826184500.1940077-5-vipinsh@google.com>
Subject: [PATCH v3 4/4] KVM: selftests: Run dirty_log_perf_test on specific cpus
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Add command line options, -c,  to run the vcpus and optionally the main
process on the specific cpus on a host machine. This is useful as it
provides a way to analyze performance based on the vcpus and dirty log
worker locations, like on the different numa nodes or on the same numa
nodes.

Link: https://lore.kernel.org/lkml/20220801151928.270380-1-vipinsh@google.com
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 23 ++++++-
 .../selftests/kvm/include/perf_test_util.h    |  4 ++
 .../selftests/kvm/lib/perf_test_util.c        | 62 ++++++++++++++++++-
 3 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1346f6b5a9bd..9514b5f28b67 100644
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
@@ -459,6 +475,9 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (pcpu_list)
+		perf_test_setup_pinning(pcpu_list, nr_vcpus);
+
 	TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
 
 	pr_info("Test iterations: %"PRIu64"\n",	p.iterations);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index eaa88df0555a..d02619f153a2 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -27,6 +27,8 @@ struct perf_test_vcpu_args {
 	/* Only used by the host userspace part of the vCPU thread */
 	struct kvm_vcpu *vcpu;
 	int vcpu_idx;
+	bool pin_pcpu;
+	int pcpu;
 };
 
 struct perf_test_args {
@@ -60,4 +62,6 @@ void perf_test_guest_code(uint32_t vcpu_id);
 uint64_t perf_test_nested_pages(int nr_vcpus);
 void perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
 
+int perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus);
+
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..7a1e8223e7c7 100644
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
@@ -240,9 +243,26 @@ void __weak perf_test_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_v
 	exit(KSFT_SKIP);
 }
 
+static void pin_me_to_pcpu(int pcpu)
+{
+	cpu_set_t cpuset;
+	int err;
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(pcpu, &cpuset);
+	errno = 0;
+	err = sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);
+	TEST_ASSERT(err == 0, "sched_setaffinity errored out: %d\n", errno);
+}
+
 static void *vcpu_thread_main(void *data)
 {
 	struct vcpu_thread *vcpu = data;
+	int idx = vcpu->vcpu_idx;
+	struct perf_test_vcpu_args *vcpu_args = &perf_test_args.vcpu_args[idx];
+
+	if (vcpu_args->pin_pcpu)
+		pin_me_to_pcpu(vcpu_args->pcpu);
 
 	WRITE_ONCE(vcpu->running, true);
 
@@ -255,7 +275,7 @@ static void *vcpu_thread_main(void *data)
 	while (!READ_ONCE(all_vcpu_threads_running))
 		;
 
-	vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_idx]);
+	vcpu_thread_fn(vcpu_args);
 
 	return NULL;
 }
@@ -292,3 +312,43 @@ void perf_test_join_vcpu_threads(int nr_vcpus)
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_join(vcpu_threads[i].thread, NULL);
 }
+
+int perf_test_setup_pinning(const char *pcpus_string, int nr_vcpus)
+{
+	char delim[2] = ",";
+	char *cpu, *cpu_list;
+	int i = 0, pcpu_num;
+
+	cpu_list = strdup(pcpus_string);
+	TEST_ASSERT(cpu_list, "strdup() allocation failed.\n");
+
+	cpu = strtok(cpu_list, delim);
+
+	// 1. Get all pcpus for vcpus
+	while (cpu && i < nr_vcpus) {
+		pcpu_num = atoi_paranoid(cpu);
+		TEST_ASSERT(pcpu_num >= 0, "Invalid cpu number: %d\n", pcpu_num);
+
+		perf_test_args.vcpu_args[i].pin_pcpu = true;
+		perf_test_args.vcpu_args[i++].pcpu = pcpu_num;
+
+		cpu = strtok(NULL, delim);
+	}
+
+	TEST_ASSERT(i == nr_vcpus,
+		    "Number of pcpus (%d) not sufficient for the number of vcpus (%d).",
+		    i, nr_vcpus);
+
+	// 2. Check if main worker is provided
+	if (cpu) {
+		pcpu_num = atoi_paranoid(cpu);
+		TEST_ASSERT(pcpu_num >= 0, "Invalid cpu number: %d\n", pcpu_num);
+
+		pin_me_to_pcpu(pcpu_num);
+
+		cpu = strtok(NULL, delim);
+	}
+
+	free(cpu_list);
+	return i;
+}
-- 
2.37.2.672.g94769d06f0-goog

