Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0434F8B55
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiDHAno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiDHAnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:43:41 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B262E4163E
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 17:41:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d1-20020a631d41000000b0039cbc6d6499so2614008pgm.7
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 17:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vmPxi8tlqNKxZd05a1XP/jao3E82fBv+i/4x7pnaLsI=;
        b=tMIuX0yqrclqYGkpTzh/qLhiF10GNnRXa1Nk//WTzhHNhjuHwW7Zf/y4gV3vufmaGE
         w++9eq0eqfz10dQi1xFQVIdPDQ43/yc/sekFfKgBswkq8c+hPL5pwzcRYKutblQCWat/
         l/ak6XVuFefGxfFueLCZUmfiSiK/WaHdVbd92YGcTcamLQXg1/RPZvJ1wpT5PZGtJk3p
         JFpZXMm3hSffNSyojcXWGEhDrF/OhPR5rQFz5HSrBDiO8dDlNY32lXA9ZGy1h11FgaSk
         RCygPZtzuKBb9b62pXLZ1EiuoqhaWyUp06ZFAE4+nvIDcxrHGiruQpk996MEYuYGTSxD
         w/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vmPxi8tlqNKxZd05a1XP/jao3E82fBv+i/4x7pnaLsI=;
        b=Xnh4ZKYRydIBeaMvIhWEdCBcDCrph8d2rA4eGpBF4X0ZdFrkAI92ISUYceTBLdSBPI
         oInG3pC8ZyaFkKkURosfct4UYE6Pu45dRhaNLeiQCOPZDDq8zgBBZI/4AlTCj+UysjXY
         87sJq1dO4bpKFono5361T08r3uHCwDXRnFe7/nZrF5/o/lSre4xRSr7Mv1mJdwjJRwD9
         Xr8FLG4mSWx6089mHAqd6IvrW15zufx2fJ8Rh2Sy2jcGTKfdmHhZoaA3GmdOFs4pnWTy
         Dm2uozIsb7s8/j2GmL+dtQCexiozFL5qjFWyAh8el9ocAxN5/wRd1rzjvzQ28bjhjLbH
         8Lqg==
X-Gm-Message-State: AOAM533DNciu+6/s9KHDx7yK7+d0821WwCLcBzQYsoomnBjhx6vsWFmY
        z3f7VESabe1np9YGSXmgFLgvTKuC/zrKtelQdO7cobZnFFqblYPLPlePG9rw55M7HoLVYRPlWjV
        bUPSj/NBww0ictvRdiSnOV44iw2A2/caZirxzM5g9NGnslA6D2YWVuWW/gIP20JI=
X-Google-Smtp-Source: ABdhPJw2ii8+mstoIuvp0zydoE6c6ec/E5e3hrWq9R0OHBslT05bVGeSTfjavLWiiOJfCDLrMZTaTtXLvKUpgw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:182a:b0:4fd:dee2:6371 with SMTP
 id y42-20020a056a00182a00b004fddee26371mr16982089pfa.8.1649378499100; Thu, 07
 Apr 2022 17:41:39 -0700 (PDT)
Date:   Thu,  7 Apr 2022 17:41:17 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-11-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 10/13] KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Add some userfaultfd tests into page_fault_test. Punch holes into the
data and/or page-table memslots, perform some accesses, and check that
the faults are taken (or not taken) when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 171 +++++++++++++++++-
 1 file changed, 169 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 04fc6007f630..bee525625956 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -52,6 +52,8 @@ uint64_t pte_gpa;
 enum { PT, TEST, NR_MEMSLOTS};
 
 struct memslot_desc {
+	size_t paging_size;
+	char *data_copy;
 	void *hva;
 	uint64_t gpa;
 	uint64_t size;
@@ -73,6 +75,9 @@ struct memslot_desc {
 static struct event_cnt {
 	int aborts;
 	int fail_vcpu_runs;
+	int uffd_faults;
+	/* uffd_faults is incremented from multiple threads. */
+	pthread_mutex_t uffd_faults_mutex;
 } events;
 
 struct test_desc {
@@ -82,6 +87,8 @@ struct test_desc {
 	bool (*guest_prepare[PREPARE_FN_NR])(void);
 	void (*guest_test)(void);
 	void (*guest_test_check[CHECK_FN_NR])(void);
+	int (*uffd_pt_handler)(int mode, int uffd, struct uffd_msg *msg);
+	int (*uffd_test_handler)(int mode, int uffd, struct uffd_msg *msg);
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
 	uint32_t pt_memslot_flags;
@@ -306,6 +313,7 @@ static void guest_code(struct test_desc *test)
 	if (!guest_prepare(test))
 		GUEST_SYNC(CMD_SKIP_TEST);
 
+	flush_tlb_page(TEST_GVA);
 	GUEST_SYNC(test->mem_mark_cmd);
 	test->guest_test();
 
@@ -323,6 +331,56 @@ static void no_iabt_handler(struct ex_regs *regs)
 	GUEST_ASSERT_1(false, regs->pc);
 }
 
+static int uffd_generic_handler(int uffd_mode, int uffd,
+		struct uffd_msg *msg, struct memslot_desc *memslot,
+		bool expect_write)
+{
+	uint64_t addr = msg->arg.pagefault.address;
+	uint64_t flags = msg->arg.pagefault.flags;
+	struct uffdio_copy copy;
+	int ret;
+
+	TEST_ASSERT(uffd_mode == UFFDIO_REGISTER_MODE_MISSING,
+			"The only expected UFFD mode is MISSING");
+	ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write);
+	ASSERT_EQ(addr, (uint64_t)memslot->hva);
+
+	pr_debug("uffd fault: addr=%p write=%d\n",
+			(void *)addr, !!(flags & UFFD_PAGEFAULT_FLAG_WRITE));
+
+	copy.src = (uint64_t)memslot->data_copy;
+	copy.dst = addr;
+	copy.len = memslot->paging_size;
+	copy.mode = 0;
+
+	ret = ioctl(uffd, UFFDIO_COPY, &copy);
+	if (ret == -1) {
+		pr_info("Failed UFFDIO_COPY in 0x%lx with errno: %d\n",
+				addr, errno);
+		return ret;
+	}
+
+	pthread_mutex_lock(&events.uffd_faults_mutex);
+	events.uffd_faults += 1;
+	pthread_mutex_unlock(&events.uffd_faults_mutex);
+	return 0;
+}
+
+static int uffd_pt_write_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	return uffd_generic_handler(mode, uffd, msg, &memslot[PT], true);
+}
+
+static int uffd_test_write_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	return uffd_generic_handler(mode, uffd, msg, &memslot[TEST], true);
+}
+
+static int uffd_test_read_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	return uffd_generic_handler(mode, uffd, msg, &memslot[TEST], false);
+}
+
 static void punch_hole_in_memslot(struct kvm_vm *vm,
 		struct memslot_desc *memslot)
 {
@@ -332,11 +390,11 @@ static void punch_hole_in_memslot(struct kvm_vm *vm,
 	fd = vm_mem_region_get_src_fd(vm, memslot->idx);
 	if (fd != -1) {
 		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-				0, memslot->size);
+				0, memslot->paging_size);
 		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
 	} else {
 		hva = addr_gpa2hva(vm, memslot->gpa);
-		ret = madvise(hva, memslot->size, MADV_DONTNEED);
+		ret = madvise(hva, memslot->paging_size, MADV_DONTNEED);
 		TEST_ASSERT(ret == 0, "madvise failed, errno: %d\n", errno);
 	}
 }
@@ -484,9 +542,60 @@ static void setup_memslots(struct kvm_vm *vm, enum vm_guest_mode mode,
 	virt_pg_map(vm, TEST_PTE_GVA, pte_gpa);
 }
 
+static void setup_uffd(enum vm_guest_mode mode, struct test_params *p,
+		struct uffd_desc **uffd)
+{
+	struct test_desc *test = p->test_desc;
+	uint64_t large_page_size = get_backing_src_pagesz(p->src_type);
+	int i;
+
+	/*
+	 * When creating the map, we might not only have created a pte page,
+	 * but also an intermediate level (pte_gpa != gpa[PT]). So, we
+	 * might need to demand page both.
+	 */
+	memslot[PT].paging_size = align_up(pte_gpa - memslot[PT].gpa,
+			large_page_size) + large_page_size;
+	memslot[TEST].paging_size = large_page_size;
+
+	for (i = 0; i < NR_MEMSLOTS; i++) {
+		memslot[i].data_copy = malloc(memslot[i].paging_size);
+		TEST_ASSERT(memslot[i].data_copy, "Failed malloc.");
+		memcpy(memslot[i].data_copy, memslot[i].hva,
+				memslot[i].paging_size);
+	}
+
+	uffd[PT] = NULL;
+	if (test->uffd_pt_handler)
+		uffd[PT] = uffd_setup_demand_paging(
+				UFFDIO_REGISTER_MODE_MISSING, 0,
+				memslot[PT].hva, memslot[PT].paging_size,
+				test->uffd_pt_handler);
+
+	uffd[TEST] = NULL;
+	if (test->uffd_test_handler)
+		uffd[TEST] = uffd_setup_demand_paging(
+				UFFDIO_REGISTER_MODE_MISSING, 0,
+				memslot[TEST].hva, memslot[TEST].paging_size,
+				test->uffd_test_handler);
+}
+
 static void check_event_counts(struct test_desc *test)
 {
 	ASSERT_EQ(test->expected_events.aborts,	events.aborts);
+	ASSERT_EQ(test->expected_events.uffd_faults, events.uffd_faults);
+}
+
+static void free_uffd(struct test_desc *test, struct uffd_desc **uffd)
+{
+	int i;
+
+	if (test->uffd_pt_handler)
+		uffd_stop_demand_paging(uffd[PT]);
+	if (test->uffd_test_handler)
+		uffd_stop_demand_paging(uffd[TEST]);
+	for (i = 0; i < NR_MEMSLOTS; i++)
+		free(memslot[i].data_copy);
 }
 
 static void print_test_banner(enum vm_guest_mode mode, struct test_params *p)
@@ -543,6 +652,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = (struct test_params *)arg;
 	struct test_desc *test = p->test_desc;
 	struct kvm_vm *vm;
+	struct uffd_desc *uffd[NR_MEMSLOTS];
 	bool skip_test = false;
 
 	print_test_banner(mode, p);
@@ -554,7 +664,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	reset_event_counts();
 	setup_memslots(vm, mode, p);
 
+	/*
+	 * Set some code at memslot[TEST].hva for the guest to execute (only
+	 * applicable to the EXEC tests). This has to be done before
+	 * setup_uffd() as that function copies the memslot data for the uffd
+	 * handler.
+	 */
 	load_exec_code_for_test();
+	setup_uffd(mode, p, uffd);
 	setup_abort_handlers(vm, test);
 	vcpu_args_set(vm, 0, 1, test);
 
@@ -565,7 +682,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	sync_stats_from_guest(vm);
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
+	free_uffd(test, uffd);
 
+	/*
+	 * Make sure this is called after the uffd threads have exited (and
+	 * updated their respective event counters).
+	 */
 	if (!skip_test)
 		check_event_counts(test);
 }
@@ -616,6 +738,7 @@ int main(int argc, char *argv[])
 #define SNAME(s)			#s
 #define SCAT2(a, b)			SNAME(a ## _ ## b)
 #define SCAT3(a, b, c)			SCAT2(a, SCAT2(b, c))
+#define SCAT4(a, b, c, d)		SCAT2(a, SCAT3(b, c, d))
 
 #define _CHECK(_test)			_CHECK_##_test
 #define _PREPARE(_test)			_PREPARE_##_test
@@ -646,6 +769,20 @@ int main(int argc, char *argv[])
 	.expected_events	= { 0 },					\
 }
 
+#define TEST_UFFD(_access, _with_af, _mark_cmd,					\
+		  _uffd_test_handler, _uffd_pt_handler, _uffd_faults)		\
+{										\
+	.name			= SCAT4(uffd, _access, _with_af, #_mark_cmd),	\
+	.guest_prepare		= { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.mem_mark_cmd		= _mark_cmd,					\
+	.guest_test_check	= { _CHECK(_with_af) },				\
+	.uffd_test_handler	= _uffd_test_handler,				\
+	.uffd_pt_handler	= _uffd_pt_handler,				\
+	.expected_events	= { .uffd_faults = _uffd_faults, },		\
+}
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
 	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
@@ -668,6 +805,36 @@ static struct test_desc tests[] = {
 	TEST_ACCESS(guest_at, no_af, CMD_HOLE_TEST),
 	TEST_ACCESS(guest_dc_zva, no_af, CMD_HOLE_TEST),
 
+	/*
+	 * Punch holes in the test and PT memslots and mark them for
+	 * userfaultfd handling. This should result in 2 faults: the test
+	 * access and its respective S1 page table walk (S1PTW).
+	 */
+	TEST_UFFD(guest_read64, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_read_handler, uffd_pt_write_handler, 2),
+	/* no_af should also lead to a PT write. */
+	TEST_UFFD(guest_read64, no_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_read_handler, uffd_pt_write_handler, 2),
+	/* Note how that cas invokes the read handler. */
+	TEST_UFFD(guest_cas, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_read_handler, uffd_pt_write_handler, 2),
+	/*
+	 * Can't test guest_at with_af as it's IMPDEF whether the AF is set.
+	 * The S1PTW fault should still be marked as a write.
+	 */
+	TEST_UFFD(guest_at, no_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_read_handler, uffd_pt_write_handler, 1),
+	TEST_UFFD(guest_ld_preidx, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_read_handler, uffd_pt_write_handler, 2),
+	TEST_UFFD(guest_write64, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_write_handler, uffd_pt_write_handler, 2),
+	TEST_UFFD(guest_dc_zva, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_write_handler, uffd_pt_write_handler, 2),
+	TEST_UFFD(guest_st_preidx, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_write_handler, uffd_pt_write_handler, 2),
+	TEST_UFFD(guest_exec, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
+			uffd_test_read_handler, uffd_pt_write_handler, 2),
+
 	{ 0 },
 };
 
-- 
2.35.1.1178.g4f1659d476-goog

