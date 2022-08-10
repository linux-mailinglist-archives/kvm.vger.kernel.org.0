Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8465C58F20A
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiHJR7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiHJR7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:59:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49ED796BE
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:59:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x19-20020a25e013000000b0067c0cedc96bso5927441ybg.21
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=U5B2F0DiGgGWUmE1r6w4IgG4Iss0hpMKcitTq51NslI=;
        b=MXLWrP3pJeKgzgPZozVFAWUNs29y945ExqJ6a5BPpV3wEMO5ZmOVNqkS98o7lYkOLT
         A9YB5b3NcMzaeb6JsjGYhGju0YpI6CzlSijhEOm8QKpEzURjIF2qRf5w6yGB+C8r33mj
         urt9xQYqIqSH/PdnNTu96XNYSl4LKXKJLevvtwmRtKNjgrR7XDJisQiCmgKdK4DjZC15
         JtwARlF1DKHSM1L4tyFutz1r2cqw4Xvv1Zux00+AztOt2tu7rcNnZk19xQAXB2z7m5/R
         U5dCM97E1El0Xb489+MkNjdOBShTCXDsmKpNvRLfrXHoeg4sdicAnXOEmblQEsq+fLA9
         X4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=U5B2F0DiGgGWUmE1r6w4IgG4Iss0hpMKcitTq51NslI=;
        b=48uybaMQ3ntkC9bZDjiTBPBnLzfVEQvBQ1lKSmatU8/jsqbl9Zs/Iy4/uQfOAf7Z9a
         TtBvUPqg8R2rKZwVuhc4fT5YNexUqe/X1py91s7WwrI2ATpq3Rp5Fvms5DmzkIRcMXFO
         hnLgC42uvvtqPeV8zVtd48O3UDmpul5q3ODEiufu++90jBAP6ouSNFFki2JfZN31ZYax
         HAJw3krewv1Ylv1kNCHo4PgSUWP3bbT2BZN50WZe9b3DYZyAk8TTd/a2ceh+QAI7UJg5
         guXRDcacAD7wwJZpnTdZVQsOMAFllIdfsGhiNEx3U7+bnwLYIXME5pEAvQsA2JtvP6QM
         KT7Q==
X-Gm-Message-State: ACgBeo2x6FdOy3h1GAhP9ltALTHy/X1hDMNejzQyEf01xLkemDbu5GG8
        LSF8uIsI1lXQ2S/xBRLAKp9cMfHqTeCW10hCS3mt8bP2fjNYGOVd7ECUg+YARiMEks3Mpb0nPQn
        ECKdSEnPOwN9ziLxjdkAiXFv8SlFCcQLULnK+i0TIcjsJeYs1KGw8SG9G3WiYDPvA6RnBuwE=
X-Google-Smtp-Source: AA6agR7D71JIRL71J4a0BRxBJSq3GYVfq+gyJZieiw8b3KxA9z1+4ATlb+B9ngEwie292f7zamYEsJAPIrcwPkLa5g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:3bca:0:b0:67c:f8:593b with SMTP id
 i193-20020a253bca000000b0067c00f8593bmr11852747yba.88.1660154364770; Wed, 10
 Aug 2022 10:59:24 -0700 (PDT)
Date:   Wed, 10 Aug 2022 17:58:30 +0000
In-Reply-To: <20220810175830.2175089-1-coltonlewis@google.com>
Message-Id: <20220810175830.2175089-4-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220810175830.2175089-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH 3/3] KVM: selftests: Randomize page access order
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the ability to use random_table to randomize the order in which
pages are accessed. Add the -a argument to enable this new
behavior. This should make accesses less predictable and make for a
more realistic test. It includes the possibility that the same pages
may be hit multiple times during an iteration.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../testing/selftests/kvm/dirty_log_perf_test.c | 11 +++++++++--
 .../selftests/kvm/include/perf_test_util.h      |  2 ++
 .../testing/selftests/kvm/lib/perf_test_util.c  | 17 ++++++++++++++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index dcc5d44fc757..265cb4f7e088 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -132,6 +132,7 @@ struct test_params {
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	bool random_access;
 	uint32_t random_seed;
 };
 
@@ -227,6 +228,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->partition_vcpu_memory_access);
 
 	perf_test_set_wr_fract(vm, p->wr_fract);
+	perf_test_set_random_access(vm, p->random_access);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -357,10 +359,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
+	printf("usage: %s [-h] [-a] [-r random seed] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
+	printf(" -a: access memory randomly rather than in order.\n");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -g: Do not enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2. This\n"
@@ -403,6 +406,7 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
+		.random_access = false,
 		.random_seed = time(NULL),
 	};
 	int opt;
@@ -414,8 +418,11 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:or:s:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "aeghi:p:m:nb:f:v:or:s:x:")) != -1) {
 		switch (opt) {
+		case 'a':
+			p.random_access = true;
+			break;
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 597875d0c3db..6c6f81ce2216 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -39,6 +39,7 @@ struct perf_test_args {
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
+	bool random_access;
 
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
@@ -56,6 +57,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
 void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_random_access(struct kvm_vm *vm, bool random_access);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
 void perf_test_join_vcpu_threads(int vcpus);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 3c7b93349fef..9838d1ad9166 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -52,6 +52,9 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 	struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
 	uint64_t gva;
 	uint64_t pages;
+	uint64_t addr;
+	bool random_access = pta->random_access;
+	bool populated = false;
 	int i;
 
 	gva = vcpu_args->gva;
@@ -62,7 +65,11 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 
 	while (true) {
 		for (i = 0; i < pages; i++) {
-			uint64_t addr = gva + (i * pta->guest_page_size);
+			if (populated && random_access)
+				addr = gva +
+					((random_table[vcpu_idx][i] % pages) * pta->guest_page_size);
+			else
+				addr = gva + (i * pta->guest_page_size);
 
 			if (random_table[vcpu_idx][i] % 100 < pta->wr_fract)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
@@ -70,6 +77,7 @@ void perf_test_guest_code(uint32_t vcpu_idx)
 				READ_ONCE(*(uint64_t *)addr);
 		}
 
+		populated = true;
 		GUEST_SYNC(1);
 	}
 }
@@ -169,6 +177,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 	/* By default vCPUs will write to memory. */
 	pta->wr_fract = 100;
+	pta->random_access = false;
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
@@ -276,6 +285,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
 	sync_global_to_guest(vm, perf_test_args);
 }
 
+void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
+{
+	perf_test_args.random_access = random_access;
+	sync_global_to_guest(vm, perf_test_args);
+}
+
 uint64_t __weak perf_test_nested_pages(int nr_vcpus)
 {
 	return 0;
-- 
2.37.1.559.g78731f0fdb-goog

