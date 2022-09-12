Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C6E5B61F7
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 21:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiILT65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 15:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiILT6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 15:58:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087F52B27D
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:58:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b14-20020a056902030e00b006a827d81fd8so8152578ybs.17
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 12:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=ReL31gFVBtM0T5XeVkKbrWlb/S7H+C7/yMtVoeFH/ic=;
        b=f5/eiddU61a9XS1LBPWHtj3JjjCC1gqQz/hox1wnewJumz0TcZ24E4BZXNrcMUQhXk
         ppX6DCeSSVHUztJcTk+/IkXvE4GEwEHpaHUKOYhezsvc3SweTYjMMF5rq85bQ5rW0rO2
         8lotfzNmbIk0FC2wq9045Y1408Cb+1Ui6CPK0dFNPyIME42maTX53zSKVB+8aNeArvow
         Noe1QolnXc1EMuLBlL2qC8u1EeEjIrlpWUTy/scgY02nlOdGfTF4+1K7eLpyghHVopQd
         lFpm3zAS442cLG7TSllxgNjsU52daIZ9q7euk7himgzdud0FEu+iEKrOL2y4SpVIZnlk
         96lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=ReL31gFVBtM0T5XeVkKbrWlb/S7H+C7/yMtVoeFH/ic=;
        b=4z/4wYmd0uJ7f548mpmDOZVsTaujBvHNwVc4vjNM+B4XeaaZbLxrA08DbvQQ0J3Fr2
         Ce+ysntVbAVQyI4xN+9snIlqZwM8fibs9KSrXeUiaxhu7jdFVcKBGB3wW9dqVs7RZeF7
         5swSltQjeezKtwbh+WU21m7K/JgG6qU1gIgTVVG0RZwONefis7taDqVlZJHLo0vEDzyD
         4L15TbQAuANyQKP4aG1PJyze3GL8cnuW7XoEvOpxVGgJQ+wgBSNj48XKWAExmnsmHyZP
         vMXPtrUfuicPzVqahAt5uY58a3bgV+bsa29xCpEwtLjr98CtWMMRm/zL6mF2BnwB9foA
         K5gw==
X-Gm-Message-State: ACgBeo1GDeAal9aznlMKj1k+rkOg7yquaGxx7GXouUxlTR966ezHwpnx
        86GBg68R/5N/bhdpTOKPaCcOyiBcdHn7oK0vAIgR88Z69PF2I31IYrfKcckq1lfOr692datsIc9
        mHtmd6CBMPxrYLSdgV74CBRPGJLFluyif8nRUhq0pUH3BjO5AhsIKf9sUoWHTJXPRqLsAQnk=
X-Google-Smtp-Source: AA6agR5XEafhzfU6qMZ/56wFocEYWnl77fF038uunHPc1OYbYxSpiPPaUlJtCpeTgZCtHo44TFPnCnX6Bg+VpTHisg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:e7c6:0:b0:6ae:62c2:1566 with SMTP
 id e189-20020a25e7c6000000b006ae62c21566mr16255918ybh.631.1663012733194; Mon,
 12 Sep 2022 12:58:53 -0700 (PDT)
Date:   Mon, 12 Sep 2022 19:58:48 +0000
In-Reply-To: <20220912195849.3989707-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20220912195849.3989707-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912195849.3989707-3-coltonlewis@google.com>
Subject: [PATCH v6 2/3] KVM: selftests: randomize which pages are written vs read
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev, Colton Lewis <coltonlewis@google.com>
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

Randomize which pages are written vs read using the random number
generator.

Change the variable wr_fract and associated function calls to
write_percent that now operates as a percentage from 0 to 100 where X
means each page has an X% chance of being written. Change the -f
argument to -w to reflect the new variable semantics. Keep the same
default of 100% writes.

Population always uses 100% writes to ensure all memory is actually
populated and not just mapped to the zero page. The prevents expensive
copy-on-write faults from occurring during the dirty memory iterations
below, which would pollute the performance results.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 37 ++++++++++++-------
 .../selftests/kvm/include/perf_test_util.h    |  4 +-
 .../selftests/kvm/lib/perf_test_util.c        | 10 ++---
 4 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index d8909032317a..d86046ef3a0b 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -274,7 +274,7 @@ static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
 static void access_memory(struct kvm_vm *vm, int vcpus, enum access_type access,
 			  const char *description)
 {
-	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
+	perf_test_set_write_percent(vm, (access == ACCESS_READ) ? 0 : 100);
 	iteration_work = ITERATION_ACCESS_MEMORY;
 	run_iteration(vm, vcpus, description);
 }
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index a89a620f50d4..dfa5957332b1 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -122,10 +122,10 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 struct test_params {
 	unsigned long iterations;
 	uint64_t phys_offset;
-	int wr_fract;
 	bool partition_vcpu_memory_access;
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
+	uint32_t write_percent;
 	uint32_t random_seed;
 };
 
@@ -224,7 +224,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	/* If no argument provided, random seed will be 0. */
 	pr_info("Random seed: %u\n", p->random_seed);
 	perf_test_set_random_seed(vm, p->random_seed);
-	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -249,6 +248,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
 		vcpu_last_completed_iteration[vcpu_id] = -1;
 
+	/*
+	 * Use 100% writes during the population phase to ensure all
+	 * memory is actually populated and not just mapped to the zero
+	 * page. The prevents expensive copy-on-write faults from
+	 * occurring during the dirty memory iterations below, which
+	 * would pollute the performance results.
+	 */
+	perf_test_set_write_percent(vm, 100);
 	perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
 
 	/* Allow the vCPUs to populate memory */
@@ -270,6 +277,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+	perf_test_set_write_percent(vm, p->write_percent);
+
 	while (iteration < p->iterations) {
 		/*
 		 * Incrementing the iteration number will start the vCPUs
@@ -342,7 +351,7 @@ static void help(char *name)
 	puts("");
 	printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
 	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
-	       "[-x memslots]\n", name);
+	       "[-x memslots] [-w percentage]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
@@ -359,10 +368,6 @@ static void help(char *name)
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     dirtied by each vCPU. e.g. 10M or 3G.\n"
 	       "     (default: 1G)\n");
-	printf(" -f: specify the fraction of pages which should be written to\n"
-	       "     as opposed to simply read, in the form\n"
-	       "     1/<fraction of pages to write>.\n"
-	       "     (default: 1 i.e. all pages are written to.)\n");
 	printf(" -v: specify the number of vCPUs to run.\n");
 	printf(" -o: Overlap guest memory accesses instead of partitioning\n"
 	       "     them into a separate region of memory for each vCPU.\n");
@@ -370,6 +375,11 @@ static void help(char *name)
 	backing_src_help("-s");
 	printf(" -x: Split the memory region into this number of memslots.\n"
 	       "     (default: 1)\n");
+	printf(" -w: specify the percentage of pages which should be written to\n"
+	       "     as an integer from 0-100 inclusive. This is probabalistic,\n"
+	       "     so -w X means each page has an X%% chance of writing\n"
+	       "     and a (100-X)%% chance of reading.\n"
+	       "     (default: 100 i.e. all pages are written to.)\n");
 	puts("");
 	exit(0);
 }
@@ -379,10 +389,10 @@ int main(int argc, char *argv[])
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	struct test_params p = {
 		.iterations = TEST_HOST_LOOP_N,
-		.wr_fract = 1,
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
+		.write_percent = 100,
 	};
 	int opt;
 
@@ -393,7 +403,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
 		switch (opt) {
 		case 'g':
 			dirty_log_manual_caps = 0;
@@ -413,10 +423,11 @@ int main(int argc, char *argv[])
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
-		case 'f':
-			p.wr_fract = atoi(optarg);
-			TEST_ASSERT(p.wr_fract >= 1,
-				    "Write fraction cannot be less than one");
+		case 'w':
+			p.write_percent = atoi(optarg);
+			TEST_ASSERT(p.write_percent >= 0
+				    && p.write_percent <= 100,
+				    "Write percentage must be between 0 and 100");
 			break;
 		case 'v':
 			nr_vcpus = atoi(optarg);
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index f18530984b42..f93f2ea7c6a3 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -35,7 +35,7 @@ struct perf_test_args {
 	uint64_t size;
 	uint64_t guest_page_size;
 	uint32_t random_seed;
-	int wr_fract;
+	uint32_t write_percent;
 
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
@@ -51,7 +51,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   bool partition_vcpu_memory_access);
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 
 void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index b1e731de0966..9effd229b75d 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -60,7 +60,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
 			uint64_t addr = gva + (i * pta->guest_page_size);
 			guest_random(&rand);
 
-			if (i % pta->wr_fract == 0)
+			if (rand % 100 < pta->write_percent)
 				*(uint64_t *)addr = 0x0123456789ABCDEF;
 			else
 				READ_ONCE(*(uint64_t *)addr);
@@ -118,7 +118,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 	/* By default vCPUs will write to memory. */
-	pta->wr_fract = 1;
+	pta->write_percent = 100;
 
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
@@ -220,10 +220,10 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
 	kvm_vm_free(vm);
 }
 
-void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
+void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent)
 {
-	perf_test_args.wr_fract = wr_fract;
-	sync_global_to_guest(vm, perf_test_args);
+	perf_test_args.write_percent = write_percent;
+	sync_global_to_guest(vm, perf_test_args.write_percent);
 }
 
 void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
-- 
2.37.2.789.g6183377224-goog

