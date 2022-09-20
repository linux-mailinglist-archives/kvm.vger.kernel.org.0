Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207A75BDBA1
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 06:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiITE0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 00:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiITE0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 00:26:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67E4558F6
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:26:13 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3454647ff7dso11235197b3.12
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 21:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=3IXMWWfhtSsnWeEyyRGnY8bQzfkxRCulrm5lrBr2778=;
        b=mDlKsGvufu24AUWZmQxjy4dDHZr0IMLom0OcsA+CPTSTZBTc55fQQZ7XvAqQYh8JQQ
         /BZBn3awHOYByiGORNERPmq4y3FLE25ZV8D4Zc6sU9hrdN9lHiMuODYUanjtYGL9h47P
         QH5V0rahWRonwSDW8Fb9CZBBYbtnNctCosTGsA+mLSRYPyDVxpigGouSJyehNlcOXdsv
         VZjSyOPcK/TbHNmIqhNuoFHnaitRn1MjVH+cQifjwqk4fpep77Q2+exbXlypC0oNHoq9
         TOxA91c8qh3oruT+UU8jeG0yRLGPuxB45vKwOkXEuAWBl97Cop30/sKwemYjpxNModLT
         yaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=3IXMWWfhtSsnWeEyyRGnY8bQzfkxRCulrm5lrBr2778=;
        b=QyV5t4wcQ44MPr6xhnR8jV3FNBoRqR4j54Uqnz4ICJL1spBvnvM46TiFQxyvjIhJJn
         BMXwoNbujtOavjMen2Kf1Ac3rtZ/mvdblAGqp4bjbFaAG02REZCkYjdE4uKktZiZt2vA
         HGPiMi/4zJZi7z+p4J3NJjQssLu0Fn30AuFQBtbe7lWfwvmUIxG0Xqp+VpygEGGfNWka
         fKYyjqEXExyTu8HoLQ3Oj/R48/rqy/9Tz1MJtmPQH0kqxZV15LbYi52zcPnoIKvCOEuM
         aI4DcZ3M4WGtYdw3+5SrkMSg8jiYb2wmG2ytEpPM9mHSs9jqk/Y7ZFwg3Td1RvghMwv0
         XuLg==
X-Gm-Message-State: ACrzQf1ZN5hu5MxHhC7QvupOa+zbTqzTnHUPu0/wz3goKMRs/YmYru6m
        zrnXa4/3mas7/5IKdQoZKpqhM0fueECrB3Xn27sTyXOuKFLajLMPPrKCF2tBX6QgjP+h7484mZu
        odNxQVWP5TXkgz0qM5gIQZLdsrv3K1i1q3Htcfmt0imnCIEboZLaRTRhvINdQQfE=
X-Google-Smtp-Source: AMsMyM6Den55RmqFll9pcUknT6wyrAOnjPhou4r/Ws2nEoXmH8JyMap/kYjowHtq9butXPRcpdO5MbSv0HQmNQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:38d:0:b0:348:b184:cedc with SMTP id
 135-20020a81038d000000b00348b184cedcmr17380084ywd.175.1663647971983; Mon, 19
 Sep 2022 21:26:11 -0700 (PDT)
Date:   Tue, 20 Sep 2022 04:25:50 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-13-ricarkol@google.com>
Subject: [PATCH v7 12/13] KVM: selftests: aarch64: Add readonly memslot tests
 into page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Add some readonly memslot tests into page_fault_test. Mark the data
and/or page-table memslots as readonly, perform some accesses, and check
that the right fault is triggered when expected (e.g., a store with no
write-back should lead to an mmio exit).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 101 +++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 51b2ac260db5..386c20b47723 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -41,6 +41,8 @@ static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
 #define CHECK_FN_NR				10
 
 static struct event_cnt {
+	int mmio_exits;
+	int fail_vcpu_runs;
 	int uffd_faults;
 	/* uffd_faults is incremented from multiple threads. */
 	pthread_mutex_t uffd_faults_mutex;
@@ -57,6 +59,8 @@ struct test_desc {
 	uffd_handler_t uffd_data_handler;
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
+	void (*mmio_handler)(struct kvm_vm *vm, struct kvm_run *run);
+	void (*fail_vcpu_run_handler)(int ret);
 	uint32_t pt_memslot_flags;
 	uint32_t data_memslot_flags;
 	bool skip;
@@ -418,6 +422,31 @@ static bool punch_hole_in_memslot(struct kvm_vm *vm,
 	return true;
 }
 
+static void mmio_on_test_gpa_handler(struct kvm_vm *vm, struct kvm_run *run)
+{
+	struct userspace_mem_region *region;
+	void *hva;
+
+	region = vm_get_mem_region(vm, MEM_REGION_DATA);
+	hva = (void *)region->region.userspace_addr;
+
+	ASSERT_EQ(run->mmio.phys_addr, region->region.guest_phys_addr);
+
+	memcpy(hva, run->mmio.data, run->mmio.len);
+	events.mmio_exits += 1;
+}
+
+static void mmio_no_handler(struct kvm_vm *vm, struct kvm_run *run)
+{
+	uint64_t data;
+
+	memcpy(&data, run->mmio.data, sizeof(data));
+	pr_debug("addr=%lld len=%d w=%d data=%lx\n",
+			run->mmio.phys_addr, run->mmio.len,
+			run->mmio.is_write, data);
+	TEST_FAIL("There was no MMIO exit expected.");
+}
+
 static bool check_write_in_dirty_log(struct kvm_vm *vm,
 		struct userspace_mem_region *region, uint64_t host_pg_nr)
 {
@@ -465,6 +494,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 	return continue_test;
 }
 
+void fail_vcpu_run_no_handler(int ret)
+{
+	TEST_FAIL("Unexpected vcpu run failure\n");
+}
+
+void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
+{
+	TEST_ASSERT(errno == ENOSYS,
+		"The mmio handler should have returned not implemented.");
+	events.fail_vcpu_runs += 1;
+}
+
 typedef uint32_t aarch64_insn_t;
 extern aarch64_insn_t __exec_test[2];
 
@@ -570,9 +611,20 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 	vm->memslots[MEM_REGION_DATA] = DATA_MEMSLOT;
 }
 
+static void setup_default_handlers(struct test_desc *test)
+{
+	if (!test->mmio_handler)
+		test->mmio_handler = mmio_no_handler;
+
+	if (!test->fail_vcpu_run_handler)
+		test->fail_vcpu_run_handler = fail_vcpu_run_no_handler;
+}
+
 static void check_event_counts(struct test_desc *test)
 {
 	ASSERT_EQ(test->expected_events.uffd_faults, events.uffd_faults);
+	ASSERT_EQ(test->expected_events.mmio_exits, events.mmio_exits);
+	ASSERT_EQ(test->expected_events.fail_vcpu_runs, events.fail_vcpu_runs);
 }
 
 static void print_test_banner(enum vm_guest_mode mode, struct test_params *p)
@@ -597,10 +649,18 @@ static void reset_event_counts(void)
 static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 		struct test_desc *test)
 {
+	struct kvm_run *run;
 	struct ucall uc;
+	int ret;
+
+	run = vcpu->run;
 
 	for (;;) {
-		vcpu_run(vcpu);
+		ret = _vcpu_run(vcpu);
+		if (ret) {
+			test->fail_vcpu_run_handler(ret);
+			goto done;
+		}
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
@@ -614,6 +674,10 @@ static void vcpu_run_loop(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 			break;
 		case UCALL_DONE:
 			goto done;
+		case UCALL_NONE:
+			if (run->exit_reason == KVM_EXIT_MMIO)
+				test->mmio_handler(vm, run);
+			break;
 		default:
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
@@ -654,6 +718,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	load_exec_code_for_test(vm);
 	setup_uffd(vm, p, &pt_uffd, &data_uffd);
 	setup_abort_handlers(vm, vcpu, test);
+	setup_default_handlers(test);
 	vcpu_args_set(vcpu, 1, test);
 
 	vcpu_run_loop(vm, vcpu, test);
@@ -741,6 +806,25 @@ static void help(char *name)
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)			\
+{										\
+	.name			= SCAT3(ro_memslot, _access, _with_af),		\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_prepare		= { _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mmio_handler		= _mmio_handler,				\
+	.expected_events	= { .mmio_exits = _mmio_exits },		\
+}
+
+#define TEST_RO_MEMSLOT_NO_SYNDROME(_access)					\
+{										\
+	.name			= SCAT2(ro_memslot_no_syndrome, _access),	\
+	.data_memslot_flags	= KVM_MEM_READONLY,				\
+	.guest_test		= _access,					\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1 },			\
+}
+
 static struct test_desc tests[] = {
 
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
@@ -809,6 +893,21 @@ static struct test_desc tests[] = {
 	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
 	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
 
+	/*
+	 * Try accesses when the data memslot is marked read-only (with
+	 * KVM_MEM_READONLY). Writes with a syndrome result in an MMIO exit,
+	 * writes with no syndrome (e.g., CAS) result in a failed vcpu run, and
+	 * reads/execs with and without syndroms do not fault.
+	 */
+	TEST_RO_MEMSLOT(guest_read64, 0, 0),
+	TEST_RO_MEMSLOT(guest_ld_preidx, 0, 0),
+	TEST_RO_MEMSLOT(guest_at, 0, 0),
+	TEST_RO_MEMSLOT(guest_exec, 0, 0),
+	TEST_RO_MEMSLOT(guest_write64, mmio_on_test_gpa_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_dc_zva),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_cas),
+	TEST_RO_MEMSLOT_NO_SYNDROME(guest_st_preidx),
+
 	{ 0 }
 };
 
-- 
2.37.3.968.ga6b4b080e4-goog

