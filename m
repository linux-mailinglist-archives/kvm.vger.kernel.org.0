Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622C66CB0A5
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 23:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbjC0V0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 17:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjC0V0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 17:26:49 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F98173E
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 14:26:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5417f156cb9so100518717b3.8
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 14:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679952406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3xVJ0N59qUEhVyxa5lPWnKYJK9Dfj1U3UBTaOD3sM/0=;
        b=JcmnWZJ5rGE4MkSwKdVKH9etXI4TFZXyy4ksVKno0LgBNHS0el0sZViVzhP+/kr8f1
         pWaG/KqpBMOfTjbxnnVQL5KElmoSoP+dJWaq7k/EdsxvepvVnH6C77QBpgALZz+u6Lbh
         Yn44VGtFgLjA8qDbMpCq/ESaNZFHQa1u0TZT2t5AvRW+5uYkEcezSVsnt97vhrfCgtr8
         ydLZx3/kYkuQMBuhgLvD3DgGreZU1GrmUOEwnYFPvKwK8qlZ0BvhDN40OO39xBKGWSmf
         eU2lg6DdyYv8j8tMQFzKxjhzt+AqPTS4JK4dwc7nXg71pOK1yHsw2CRDlNxjxHGeNte0
         NhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679952406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xVJ0N59qUEhVyxa5lPWnKYJK9Dfj1U3UBTaOD3sM/0=;
        b=aiDZedkjD/kJGlg81epICrYa1EqlNwdH2mL3F6ibDOVhhFHS0ecAm2jC/EXm/eVCI0
         +ouEbKAbb950i6Z4nCxbqQD91Ce6eo7PvGvaK1F1plIKClDCtwyYoy1T6U/7oe6vVv8+
         UUNLWUDiuZ29rlXOO1KP5Z+v4sAT1D5Jglnfu3LeulAgA03BK4URIusMI1+5u76LqQEL
         UO1zekWefpAWYOT8tdmBoyKhB0J2r5S45Z+HVs/K5OvWuriT7YsHPYIL33jU/85g21MM
         DV3rQPghJxZTHDDmVB7fAcuhZahVxJhqu1F5a9dWaXKUDWGU78DgwsvQveB7wSoEV/Ov
         5Oeg==
X-Gm-Message-State: AAQBX9fGbAht28VYBmjF/bj2/IWwhSJuH4e6miBAtWZF91WivE62fBHF
        jTldcEyLB7ytKMrkdukxEMicIiLPCbP23IaBfQ==
X-Google-Smtp-Source: AKy350ZZqTUsOWfWDw3mRj90w93mlr6JTHyWQ821Tl/tt6+S5Vtphvvv2aUa828g2u+uenzbQmbdINy9XOFMlq9bQw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1586:b0:b77:81f:42dc with
 SMTP id k6-20020a056902158600b00b77081f42dcmr7948841ybu.1.1679952406391; Mon,
 27 Mar 2023 14:26:46 -0700 (PDT)
Date:   Mon, 27 Mar 2023 21:26:35 +0000
In-Reply-To: <20230327212635.1684716-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20230327212635.1684716-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230327212635.1684716-3-coltonlewis@google.com>
Subject: [PATCH v3 2/2] KVM: selftests: Print summary stats of memory latency distribution
From:   Colton Lewis <coltonlewis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print summary stats of the memory latency distribution in nanoseconds
for dirty_log_perf_test. For every iteration, this prints the minimum,
the 50th percentile, the 90th percentile, the 99th percentile, and the
maximum. These percentiles are common in latency testing to give a
picture of the right half of the distribution, particularly the worst
cases.

Stats are calculated by sorting the samples taken from all vcpus and
picking from the index corresponding with each percentile.

Because keeping all samples is impractical due to the space required
in some cases (pooled memory w/ 64 vcpus would be 64 GB/vcpu * 64
vcpus * 250,000 samples/GB * 8 bytes/sample ~ 8 GB extra memory just
for samples), reservoir sampling [1] is used to only keep a small
number of samples per vcpu (settable via command argument). There is a
tradeoff between stat accuracy and memory usage. More samples means
more accuracy but also more memory use.

Because other selftests use memstress.c, those tests were hardcoded to
take 0 samples at this time.

[1] https://en.wikipedia.org/wiki/Reservoir_sampling#Simple:_Algorithm_R

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  3 +-
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 21 +++++-
 .../selftests/kvm/include/aarch64/processor.h | 10 +++
 .../testing/selftests/kvm/include/memstress.h | 10 ++-
 .../selftests/kvm/include/x86_64/processor.h  | 10 +++
 tools/testing/selftests/kvm/lib/memstress.c   | 68 ++++++++++++++++---
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 8 files changed, 110 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f56..89947aa4ff3a 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -306,7 +306,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int nr_vcpus = params->nr_vcpus;

-	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes,
+				 0, 1,
 				 params->backing_src, !overlap_memory_access);

 	memstress_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index b0e1fc4de9e2..bc5c171eca9e 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -135,7 +135,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int i;

-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 0, 1,
 				 p->src_type, p->partition_vcpu_memory_access);

 	demand_paging_size = get_backing_src_pagesz(p->src_type);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e9d6d1aecf89..79495f65c419 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -133,6 +133,7 @@ struct test_params {
 	int slots;
 	uint32_t write_percent;
 	uint32_t random_seed;
+	uint64_t samples_per_vcpu;
 	bool random_access;
 };

@@ -224,6 +225,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i;

 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+				 p->samples_per_vcpu,
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);

@@ -275,6 +277,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Populate memory time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);

+	if (p->samples_per_vcpu)
+		memstress_print_percentiles(vm, nr_vcpus);
+
 	/* Enable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	enable_dirty_logging(vm, p->slots);
@@ -305,6 +310,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		pr_info("Iteration %d dirty memory time: %ld.%.9lds\n",
 			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);

+		if (p->samples_per_vcpu)
+			memstress_print_percentiles(vm, nr_vcpus);
+
 		clock_gettime(CLOCK_MONOTONIC, &start);
 		get_dirty_log(vm, bitmaps, p->slots);
 		ts_diff = timespec_elapsed(start);
@@ -367,8 +375,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-a] [-i iterations] [-p offset] [-g] "
-	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
+	printf("usage: %s [-h] [-a] [-i iterations] [-p offset] [-g] [-l samples per vcpu] "
+	       "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type] "
 	       "[-x memslots] [-w percentage] [-c physical cpus to run test on]\n", name);
 	puts("");
 	printf(" -a: access memory randomly rather than in order.\n");
@@ -382,6 +390,9 @@ static void help(char *name)
 	       "     is not enabled).\n");
 	printf(" -p: specify guest physical test memory offset\n"
 	       "     Warning: a low offset can conflict with the loaded test code.\n");
+	printf(" -l: Turn on latency measurements and specify number of samples\n"
+	       "     to store per vcpu. More samples means more accuracy at the cost\n"
+	       "     of additional memory use. 1000 is a good value.\n");
 	guest_modes_help();
 	printf(" -n: Run the vCPUs in nested mode (L2)\n");
 	printf(" -e: Run vCPUs while dirty logging is being disabled.  This\n"
@@ -428,6 +439,7 @@ int main(int argc, char *argv[])
 		.slots = 1,
 		.random_seed = 1,
 		.write_percent = 100,
+		.samples_per_vcpu = 0,
 	};
 	int opt;

@@ -438,7 +450,7 @@ int main(int argc, char *argv[])

 	guest_modes_append_default();

-	while ((opt = getopt(argc, argv, "ab:c:eghi:m:nop:r:s:v:x:w:")) != -1) {
+	while ((opt = getopt(argc, argv, "ab:c:eghi:l:m:nop:r:s:v:x:w:")) != -1) {
 		switch (opt) {
 		case 'a':
 			p.random_access = true;
@@ -462,6 +474,9 @@ int main(int argc, char *argv[])
 		case 'i':
 			p.iterations = atoi_positive("Number of iterations", optarg);
 			break;
+		case 'l':
+			p.samples_per_vcpu = atoi_positive("Number of samples/vcpu", optarg);
+			break;
 		case 'm':
 			guest_modes_cmdline(optarg);
 			break;
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index f65e491763e0..d441f485e9c6 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -219,4 +219,14 @@ uint32_t guest_get_vcpuid(void);
 uint64_t cycles_read(void);
 uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);

+#define MEASURE_CYCLES(x)			\
+	({					\
+		uint64_t start;			\
+		start = cycles_read();		\
+		isb();				\
+		x;				\
+		dsb(nsh);			\
+		cycles_read() - start;		\
+	})
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 72e3e358ef7b..25a3b5e308e9 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -37,6 +37,12 @@ struct memstress_args {
 	uint64_t guest_page_size;
 	uint32_t random_seed;
 	uint32_t write_percent;
+	uint64_t samples_per_vcpu;
+	/* Store all samples in a flat array so they can be easily
+	 * sorted later.
+	 */
+	vm_vaddr_t latency_samples;
+

 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
@@ -56,7 +62,8 @@ struct memstress_args {
 extern struct memstress_args memstress_args;

 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes,
+				   uint64_t samples_per_vcpu, int slots,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access);
 void memstress_destroy_vm(struct kvm_vm *vm);
@@ -72,4 +79,5 @@ void memstress_guest_code(uint32_t vcpu_id);
 uint64_t memstress_nested_pages(int nr_vcpus);
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);

+void memstress_print_percentiles(struct kvm_vm *vm, int nr_vcpus);
 #endif /* SELFTEST_KVM_MEMSTRESS_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 5d977f95d5f5..7352e02db4ee 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1137,4 +1137,14 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 uint64_t cycles_read(void);
 uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);

+#define MEASURE_CYCLES(x)			\
+	({					\
+		uint64_t start;			\
+		start = cycles_read();		\
+		asm volatile("mfence");		\
+		x;				\
+		asm volatile("mfence");		\
+		cycles_read() - start;		\
+	})
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 5f1d3173c238..d9cae925d990 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -48,14 +48,17 @@ void memstress_guest_code(uint32_t vcpu_idx)
 {
 	struct memstress_args *args = &memstress_args;
 	struct memstress_vcpu_args *vcpu_args = &args->vcpu_args[vcpu_idx];
-	struct guest_random_state rand_state;
 	uint64_t gva;
 	uint64_t pages;
 	uint64_t addr;
 	uint64_t page;
 	int i;
-
-	rand_state = new_guest_random_state(args->random_seed + vcpu_idx);
+	struct guest_random_state rand_state =
+		new_guest_random_state(args->random_seed + vcpu_idx);
+	uint64_t *vcpu_samples = (uint64_t *)args->latency_samples
+		+ args->samples_per_vcpu * vcpu_idx;
+	uint64_t cycles;
+	uint32_t maybe_sample;

 	gva = vcpu_args->gva;
 	pages = vcpu_args->pages;
@@ -73,15 +76,46 @@ void memstress_guest_code(uint32_t vcpu_idx)
 			addr = gva + (page * args->guest_page_size);

 			if (guest_random_u32(&rand_state) % 100 < args->write_percent)
-				*(uint64_t *)addr = 0x0123456789ABCDEF;
+				cycles = MEASURE_CYCLES(*(uint64_t *)addr = 0x0123456789ABCDEF);
 			else
-				READ_ONCE(*(uint64_t *)addr);
+				cycles = MEASURE_CYCLES(READ_ONCE(*(uint64_t *)addr));
+
+			if (i < args->samples_per_vcpu) {
+				vcpu_samples[i] = cycles;
+				continue;
+			}
+
+			maybe_sample = guest_random_u32(&rand_state) % (i + 1);
+
+			if (maybe_sample < args->samples_per_vcpu)
+				vcpu_samples[maybe_sample] = cycles;
 		}

 		GUEST_SYNC(1);
 	}
 }

+/* compare function for qsort */
+static int memstress_qcmp(const void *a, const void *b)
+{
+	return *(int *)a - *(int *)b;
+}
+
+void memstress_print_percentiles(struct kvm_vm *vm, int nr_vcpus)
+{
+	uint64_t n_samples = nr_vcpus * memstress_args.samples_per_vcpu;
+	uint64_t *samples = addr_gva2hva(vm, memstress_args.latency_samples);
+
+	qsort(samples, n_samples, sizeof(uint64_t), &memstress_qcmp);
+
+	pr_info("Latency distribution = min:0.%.9lds, 50th:0.%.9lds, 90th:0.%.9lds, 99th:0.%.9lds, max:0.%.9lds\n",
+		cycles_to_ns(vcpus[0], samples[0]),
+		cycles_to_ns(vcpus[0], samples[n_samples / 2]),
+		cycles_to_ns(vcpus[0], samples[n_samples * 9 / 10]),
+		cycles_to_ns(vcpus[0], samples[n_samples * 99 / 100]),
+		cycles_to_ns(vcpus[0], samples[n_samples - 1]));
+}
+
 void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 			   struct kvm_vcpu *vcpus[],
 			   uint64_t vcpu_memory_bytes,
@@ -119,21 +153,26 @@ void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 }

 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes,
+				   uint64_t samples_per_vcpu, int slots,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
 	struct memstress_args *args = &memstress_args;
 	struct kvm_vm *vm;
-	uint64_t guest_num_pages, slot0_pages = 0;
+	uint64_t guest_num_pages, sample_pages, slot0_pages = 0;
 	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
 	uint64_t region_end_gfn;
+	uint64_t sample_size;
+	uint64_t sample_slot;
+	uint64_t sample_start;
 	int i;

 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));

 	/* By default vCPUs will write to memory. */
 	args->write_percent = 100;
+	args->samples_per_vcpu = samples_per_vcpu;

 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
@@ -159,12 +198,17 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	if (args->nested)
 		slot0_pages += memstress_nested_pages(nr_vcpus);

+	sample_size = samples_per_vcpu * nr_vcpus * sizeof(uint64_t);
+	sample_pages = vm_adjust_num_guest_pages(
+		mode, 1 + sample_size / args->guest_page_size);
+
 	/*
 	 * Pass guest_num_pages to populate the page tables for test memory.
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_num_pages,
+	vm = __vm_create_with_vcpus(mode, nr_vcpus,
+				    slot0_pages + guest_num_pages + sample_pages,
 				    memstress_guest_code, vcpus);

 	args->vm = vm;
@@ -190,7 +234,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 		    " nr_vcpus: %d wss: %" PRIx64 "]\n",
 		    guest_num_pages, region_end_gfn - 1, nr_vcpus, vcpu_memory_bytes);

-	args->gpa = (region_end_gfn - guest_num_pages - 1) * args->guest_page_size;
+	args->gpa = (region_end_gfn - guest_num_pages - sample_pages - 1) * args->guest_page_size;
 	args->gpa = align_down(args->gpa, backing_src_pagesz);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
@@ -213,6 +257,12 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	/* Do mapping for the demand paging memory slot */
 	virt_map(vm, guest_test_virt_mem, args->gpa, guest_num_pages);

+	memstress_args.latency_samples = guest_test_virt_mem + args->size;
+	sample_start = args->gpa + args->size;
+	sample_slot = MEMSTRESS_MEM_SLOT_INDEX + slots;
+	vm_userspace_mem_region_add(vm, backing_src, sample_start, sample_slot, sample_pages, 0);
+	virt_map(vm, memstress_args.latency_samples, sample_start, sample_pages);
+
 	memstress_setup_vcpus(vm, nr_vcpus, vcpus, vcpu_memory_bytes,
 			      partition_vcpu_memory_access);

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9855c41ca811..0a14f7d16e0c 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -95,7 +95,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vm *vm;

-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 0, 1,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);

--
2.40.0.348.gf938b09366-goog
