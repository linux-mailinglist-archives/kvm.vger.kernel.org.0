Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0B855A3A1
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiFXVdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiFXVdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:19 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A9E14D32
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:18 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id cp20-20020a17090afb9400b001ec75748019so1717056pjb.6
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FvNgQYmZ0VCVXXneiKRWIEcoapMuc+hIl73ImkZUig0=;
        b=l9/sn1uQQ4n8HO6x93z6uEojn1rgQt+U8pUGHFFCd8P5BldVh9SQaBs0q7TFDF66p1
         0PD69z+3fOcXWu0+zhrS8qXoRGy8r7bUkIx0VNeWDQ+3nPvenExpMQZZ4XVaAmhVoEGS
         OjUPrygH1GjZj5mvzGJDqQypsAr3kLs1+kcLD79utvDWI0vtqZwHeJNTXqZ6o7aLxRG3
         CqGGgOxUbwAczV108pD6NQDiYIi5uPTJXdxTn1PzC5wGZaZybHtVSipgYqCuGLyr6jvf
         K3fy9DfKkeFWwQh9cKoMtUSSpks9rGcBom3/GVLsZdd3Z1E61w7YWlTu9i80g7X2uXYq
         l5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FvNgQYmZ0VCVXXneiKRWIEcoapMuc+hIl73ImkZUig0=;
        b=h/Q0KbSxcuRJoyxB9wr+pjqe74pdc7vw90fs77xqb/2t+h261SrEKrHyCDKxCGOmtl
         CSHcESH5w/SwyI+72Qgs110usARAvkXSeR+lFvHsTTz/+/hmSOnNoG1b6JHVsTTgeDBu
         Rlchm+WDkQmXZzSGTfq2kJqdGzZqinUzlNaKlJSKeGDkKJ+sCxIPYj6gciFuCCVfbkfj
         VjJdAqMLwNX3zfm6cEufU4tVhA6AW0nuSbfEgpeKo7MflQ67JdnxWNnPcgP5bmC6roK2
         nmVzA5Yj+zI4qJwR4IUc6pLO3dKWADS0zeauJi/YdXibMBlnH4T5spItajFVxrUgLsU2
         qjNw==
X-Gm-Message-State: AJIora//JaNsuTnn1ggIJPBwtxZMdbuBlbljDBtZqAzHCcnG+ayKWZes
        yp0TXuVgbFAoc0RKctBxNvL4SCe7bhu1WHnyV3lRW5FTYQq4QP0sa6RTbzg2+Q/osR4CTH/vzRu
        DyB+EqJO3VgGIrAiH9ydpscJovUeF0RK5Tw0GULZ8zCkPx3f1lCcTv12VtJ4MexU=
X-Google-Smtp-Source: AGRyM1sKp3keSikLFIbuw9Ku49cNDNVXIxSD3+cHDAu1dcNPKJ0kMUwVe3KafIBD9qG+ewzce5UUDVdtby4Uqw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4b0e:b0:1ed:196d:b691 with SMTP
 id lx14-20020a17090b4b0e00b001ed196db691mr1030244pjb.78.1656106398223; Fri,
 24 Jun 2022 14:33:18 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:54 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-11-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 10/13] KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com, Ricardo Koller <ricarkol@google.com>
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
 .../selftests/kvm/aarch64/page_fault_test.c   | 165 +++++++++++++++++-
 1 file changed, 163 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index bdda4e3fcdaa..26318d39940b 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -47,6 +47,8 @@ enum {
 };
 
 struct memslot_desc {
+	size_t paging_size;
+	char *data_copy;
 	void *hva;
 	uint64_t gpa;
 	uint64_t size;
@@ -65,6 +67,9 @@ struct memslot_desc {
 static struct event_cnt {
 	int aborts;
 	int fail_vcpu_runs;
+	int uffd_faults;
+	/* uffd_faults is incremented from multiple threads. */
+	pthread_mutex_t uffd_faults_mutex;
 } events;
 
 struct test_desc {
@@ -74,6 +79,8 @@ struct test_desc {
 	bool (*guest_prepare[PREPARE_FN_NR])(void);
 	void (*guest_test)(void);
 	void (*guest_test_check[CHECK_FN_NR])(void);
+	int (*uffd_pt_handler)(int mode, int uffd, struct uffd_msg *msg);
+	int (*uffd_test_handler)(int mode, int uffd, struct uffd_msg *msg);
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
 	uint32_t pt_memslot_flags;
@@ -301,6 +308,57 @@ static void no_iabt_handler(struct ex_regs *regs)
 }
 
 /* Returns true to continue the test, and false if it should be skipped. */
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
+/* Returns false if the test should be skipped. */
 static bool punch_hole_in_memslot(struct kvm_vm *vm,
 		struct memslot_desc *memslot)
 {
@@ -310,14 +368,14 @@ static bool punch_hole_in_memslot(struct kvm_vm *vm,
 	fd = vm_mem_region_get_src_fd(vm, memslot->idx);
 	if (fd != -1) {
 		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-				0, memslot->size);
+				0, memslot->paging_size);
 		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
 	} else {
 		if (is_backing_src_hugetlb(memslot->src_type))
 			return false;
 
 		hva = addr_gpa2hva(vm, memslot->gpa);
-		ret = madvise(hva, memslot->size, MADV_DONTNEED);
+		ret = madvise(hva, memslot->paging_size, MADV_DONTNEED);
 		TEST_ASSERT(ret == 0, "madvise failed, errno: %d\n", errno);
 	}
 
@@ -487,11 +545,56 @@ static void setup_memslots(struct kvm_vm *vm, enum vm_guest_mode mode,
 			"The pte_gpa (%p) should be aligned to the guest page (%lx).",
 			(void *)pte_gpa, guest_page_size);
 	virt_pg_map(vm, TEST_PTE_GVA, pte_gpa);
+
+	memslot[PT].paging_size = memslot[PT].size;
+	memslot[TEST].paging_size = memslot[TEST].size;
+}
+
+static void setup_uffd(enum vm_guest_mode mode, struct test_params *p,
+		struct uffd_desc **uffd)
+{
+	struct test_desc *test = p->test_desc;
+	int i;
+
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
 }
 
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
@@ -550,6 +653,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_desc *test = p->test_desc;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpus[1], *vcpu;
+	struct uffd_desc *uffd[NR_MEMSLOTS];
 	bool skip_test = false;
 
 	print_test_banner(mode, p);
@@ -561,7 +665,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
 	setup_abort_handlers(vm, vcpu, test);
 	vcpu_args_set(vcpu, 1, test);
 
@@ -572,7 +683,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -590,6 +706,7 @@ static void help(char *name)
 #define SNAME(s)			#s
 #define SCAT2(a, b)			SNAME(a ## _ ## b)
 #define SCAT3(a, b, c)			SCAT2(a, SCAT2(b, c))
+#define SCAT4(a, b, c, d)		SCAT2(a, SCAT3(b, c, d))
 
 #define _CHECK(_test)			_CHECK_##_test
 #define _PREPARE(_test)			_PREPARE_##_test
@@ -620,6 +737,20 @@ static void help(char *name)
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
@@ -642,6 +773,36 @@ static struct test_desc tests[] = {
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
 	{ 0 }
 };
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

