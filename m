Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25E94E5B86
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345351AbiCWWzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345340AbiCWWzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:55:54 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097608D681
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:23 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x18-20020a170902ea9200b00153e0dbca9bso1522413plb.9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rNNhRfKhYknMP2+oJNC4EO4oFb/4JLt8/J+1Ulwb074=;
        b=fcvWs/M+OJroPCiM23XkgUWvmtBZv19XWU8pgUAWdJSm2HusVFqNt28RzQrt/t2l3w
         kdnTH1+Lkj19lUhY+ewLR83Amgot0T086obsthKAvw5ww0g1hDdLdWnLAUdYeTZliIE4
         kl2oI+GwPq7NBmTx1tsnI61h65IZYcZkUyhe1G4tq5nabV5tS4skuTB5hx8mb+srtcsi
         gUtprmAUDrIGCsXGcOIFGI7av3RTDpjprQeWNjE+ZY1xTIe7MYFX7aVm2JlLtKyYSqwE
         erZLyDHHqWFnnSxMY/0fEgTwyrISc5KxCqH20R9tjpfg1ol8iFppXePAdkYQeSW6kZlY
         ZWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rNNhRfKhYknMP2+oJNC4EO4oFb/4JLt8/J+1Ulwb074=;
        b=5xC+DG5d6SSyNUiNdNZPRicAVhihxRntZ7U2P7cQIqco7bsv8uLUyZI4ODX+/mmFvO
         0qHQIncfyaFbvlI4n3LXoRpfKqed7c1Gi+cx4W4GW6akikRDDlB8eO9EFYlJvgHbcIyl
         o5YNvDzLWqAlVrvbcLkPXfYEK8sfzvEDdRUgGJ4l5vV1p5ccz5GRDlH6ZcXTyb5kEsEM
         lLqGnUhaTWYJ1+ETpGxCA6xC+XnMJBWIXvqyuM0LTp8qDFy3PAVqzSxe6MZy9ukfw4YG
         AXr0S1A4BGhCEJ2DfRXkfbBqSzhB85/ZSK15B7el0jkV7iRSuG/2IU0sDP6bi3OQllVe
         v0rA==
X-Gm-Message-State: AOAM532rfvgBc4LgvLlcQwomRxZHB70H7m+sCaiSMEeYaa2uaK0rBN/Y
        2/G1ahR1VKiYqHEVTXOxCXRmIokoxfbOueSTfNfDg8YdfEc8KJxmEFdgBu2ByRTImEDmydZb55G
        CuPxC7uyyS+LMZS+/oxQ5SB2YV2yD1SyMZp3bOc06bTUwoqGOw4GHf4pBSc8wS6Q=
X-Google-Smtp-Source: ABdhPJzZcZCSZNlq91/IIXrO/vTBcBMJURE15e8jxPmh/Bne7GSzSCwhKyzaScOvedmnAsB3HGQ+Qutp6F+1og==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:249:b0:153:857c:a1fe with SMTP id
 j9-20020a170903024900b00153857ca1femr2562597plh.44.1648076062416; Wed, 23 Mar
 2022 15:54:22 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:54:02 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-9-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 08/11] KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
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
 .../selftests/kvm/aarch64/page_fault_test.c   | 232 +++++++++++++++++-
 1 file changed, 229 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 00477a4f10cb..99449eaddb2b 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -57,6 +57,8 @@ uint64_t pte_gpa;
 enum { PT, TEST, NR_MEMSLOTS};
 
 struct memslot_desc {
+	size_t paging_size;
+	char *data_copy;
 	void *hva;
 	uint64_t gpa;
 	uint64_t size;
@@ -78,6 +80,9 @@ struct memslot_desc {
 static struct event_cnt {
 	int aborts;
 	int fail_vcpu_runs;
+	int uffd_faults;
+	/* uffd_faults is incremented from multiple threads. */
+	pthread_mutex_t uffd_faults_mutex;
 } events;
 
 struct test_desc {
@@ -87,6 +92,8 @@ struct test_desc {
 	bool (*guest_prepare[PREPARE_FN_NR])(void);
 	void (*guest_test)(void);
 	void (*guest_test_check[CHECK_FN_NR])(void);
+	int (*uffd_pt_handler)(int mode, int uffd, struct uffd_msg *msg);
+	int (*uffd_test_handler)(int mode, int uffd, struct uffd_msg *msg);
 	void (*dabt_handler)(struct ex_regs *regs);
 	void (*iabt_handler)(struct ex_regs *regs);
 	uint32_t pt_memslot_flags;
@@ -305,6 +312,56 @@ static void no_iabt_handler(struct ex_regs *regs)
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
@@ -314,11 +371,11 @@ static void punch_hole_in_memslot(struct kvm_vm *vm,
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
@@ -457,9 +514,60 @@ static void setup_memslots(struct kvm_vm *vm, enum vm_guest_mode mode,
 	virt_pg_map(vm, pte_gva, pte_gpa);
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
@@ -517,6 +625,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = (struct test_params *)arg;
 	struct test_desc *test = p->test_desc;
 	struct kvm_vm *vm;
+	struct uffd_desc *uffd[NR_MEMSLOTS];
 	bool skip_test = false;
 
 	print_test_banner(mode, p);
@@ -528,7 +637,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
 	setup_guest_args(vm, test);
 
@@ -542,7 +658,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -625,6 +746,43 @@ int main(int argc, char *argv[])
 	__VA_ARGS__								\
 }
 
+#define TEST_ACCESS_ON_HOLE_UFFD(__a, __uffd_handler, ...)			\
+{										\
+	.name			= SNAME(ACCESS_ON_HOLE_UFFD ## _ ## __a),	\
+	.guest_test		= __a,						\
+	.mem_mark_cmd		= CMD_HOLE_TEST,				\
+	.uffd_test_handler	= __uffd_handler,				\
+	.expected_events	= { .uffd_faults = 1, },			\
+	__VA_ARGS__								\
+}
+
+#define TEST_S1PTW_ON_HOLE_UFFD(__a, __uffd_handler, ...)			\
+{										\
+	.name			= SNAME(S1PTW_ON_HOLE_UFFD ## _ ## __a),	\
+	.guest_test		= __a,						\
+	.mem_mark_cmd		= CMD_HOLE_PT,					\
+	.uffd_pt_handler	= __uffd_handler,				\
+	.expected_events	= { .uffd_faults = 1, },			\
+	__VA_ARGS__								\
+}
+
+#define TEST_S1PTW_ON_HOLE_UFFD_AF(__a, __uffd_handler)				\
+	TEST_S1PTW_ON_HOLE_UFFD(__a, __uffd_handler, __AF_TEST_ARGS)
+
+#define TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(__a, __th, __ph, ...)		\
+{										\
+	.name			= SNAME(ACCESS_S1PTW_ON_HOLE_UFFD ## _ ## __a),	\
+	.guest_test		= __a,						\
+	.mem_mark_cmd		= CMD_HOLE_PT | CMD_HOLE_TEST,			\
+	.uffd_pt_handler	= __ph,						\
+	.uffd_test_handler	= __th,						\
+	.expected_events	= { .uffd_faults = 2, },			\
+	__VA_ARGS__								\
+}
+
+#define TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(__a, __th, __ph)			\
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(__a, __th, __ph, __AF_TEST_ARGS)
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the AF (sanity checks). */
 	TEST_HW_ACCESS_FLAG(guest_test_read64),
@@ -640,10 +798,78 @@ static struct test_desc tests[] = {
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_cas, __PREPARE_LSE_TEST_ARGS),
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_ld_preidx),
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_write64),
-	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_at),
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_dc_zva),
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_st_preidx),
 
+	/* UFFD basic (sanity checks) */
+	TEST_ACCESS_ON_HOLE_UFFD(guest_test_read64, uffd_test_read_handler),
+	TEST_ACCESS_ON_HOLE_UFFD(guest_test_cas, uffd_test_read_handler,
+			__PREPARE_LSE_TEST_ARGS),
+	TEST_ACCESS_ON_HOLE_UFFD(guest_test_ld_preidx, uffd_test_read_handler),
+	TEST_ACCESS_ON_HOLE_UFFD(guest_test_write64, uffd_test_write_handler),
+	TEST_ACCESS_ON_HOLE_UFFD(guest_test_st_preidx, uffd_test_write_handler),
+	TEST_ACCESS_ON_HOLE_UFFD(guest_test_dc_zva, uffd_test_write_handler),
+	TEST_ACCESS_ON_HOLE_UFFD(guest_test_exec, uffd_test_read_handler),
+
+	/* UFFD fault due to S1PTW. Note how they are all write faults. */
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_read64, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_cas, uffd_pt_write_handler,
+			__PREPARE_LSE_TEST_ARGS),
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_at, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_ld_preidx, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_write64, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_dc_zva, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_st_preidx, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_exec, uffd_pt_write_handler),
+
+	/* UFFD fault due to S1PTW with AF. Note how they all write faults. */
+	TEST_S1PTW_ON_HOLE_UFFD_AF(guest_test_read64, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD(guest_test_cas, uffd_pt_write_handler,
+			__AF_LSE_TEST_ARGS),
+	/*
+	 * Can't test the AF case for address translation insts (D5.4.11) as
+	 * it's IMPDEF whether that marks the AF.
+	 */
+	TEST_S1PTW_ON_HOLE_UFFD_AF(guest_test_ld_preidx, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD_AF(guest_test_write64, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD_AF(guest_test_st_preidx, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD_AF(guest_test_dc_zva, uffd_pt_write_handler),
+	TEST_S1PTW_ON_HOLE_UFFD_AF(guest_test_exec, uffd_pt_write_handler),
+
+	/* UFFD faults due to an access and its S1PTW. */
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(guest_test_read64,
+			uffd_test_read_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(guest_test_cas,
+			uffd_test_read_handler, uffd_pt_write_handler,
+			__PREPARE_LSE_TEST_ARGS),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(guest_test_ld_preidx,
+			uffd_test_read_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(guest_test_write64,
+			uffd_test_write_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(guest_test_dc_zva,
+			uffd_test_write_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(guest_test_st_preidx,
+			uffd_test_write_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(guest_test_exec,
+			uffd_test_read_handler, uffd_pt_write_handler),
+
+	/* UFFD faults due to an access and its S1PTW with AF. */
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(guest_test_read64,
+			uffd_test_read_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(guest_test_cas,
+			uffd_test_read_handler, uffd_pt_write_handler,
+			__AF_LSE_TEST_ARGS),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(guest_test_ld_preidx,
+			uffd_test_read_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(guest_test_write64,
+			uffd_test_write_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(guest_test_dc_zva,
+			uffd_test_write_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(guest_test_st_preidx,
+			uffd_test_write_handler, uffd_pt_write_handler),
+	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(guest_test_exec,
+			uffd_test_read_handler, uffd_pt_write_handler),
+
 	{ 0 },
 };
 
-- 
2.35.1.894.gb6a874cedc-goog

