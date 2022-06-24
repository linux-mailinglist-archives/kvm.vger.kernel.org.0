Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73455A394
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiFXVdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiFXVdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:33:21 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EFA2AE10
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:20 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d3-20020a170903230300b0016a4d9ded01so1853219plh.6
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EhkHFbJWaJMliQN0tQTB0zsZERxec1S+mwX59ILmQi4=;
        b=cNB8lSEjiCER00kdGq5pyvT0qlNclCYHuv91WuVjS00oZNQdsScfBcUaSHukxFmdue
         XLed341AdBP7j3pZuz+PIbGA5sflWjLabNs2eMy02TOY7k8/DXyxyCgRxqGQ7rX/5oAU
         lEn4UmIuEl3KnLJG3M2vSRRTjr9Hps8wQApdrgFPkFBhQPIYphkXLeD94rdlgV5ijEdn
         juqKFlttm1hQVpv3VHMpCTOazCjHAD/717mztRvU7Mkkif8EpMQGZ+xdyNm3IjsdxGuB
         iez3nWtRTuBjcG0rLHIX7Kiyri66qcoyJy35EHVDOCFCa+oNLbIOw2tv91XniTpoS1N2
         smaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EhkHFbJWaJMliQN0tQTB0zsZERxec1S+mwX59ILmQi4=;
        b=j7yUnsFW7J0s8p2eewRy0b3ITjb2T2+BirYw/NQCrZQD+EeJqYZGVWoBpx+FlW1NtG
         +90ipfWQeF1eBY6mKF1K2tIzAWHLhJ7+y5qaYLUxXfJr276AQTjxqHtaJYuLmzGKKxWM
         zz9YZZWSGWDtzJoBIzhhgTT6gGG0pQOa+Ya0Ap7Chk88SYcvi+Nq/dP5K5XYxM+H2NPh
         ji+NxIgBkGUnmyEiG1pWo13qlsXewLGS6Eumxt5o/q0TOuDK+n/QKo6pStYHY/0ktCcs
         81O7+zSvpYDj0C3jywlV9aDnNI/MLtVXXzIoPCqKd87orcS9S9iotoYxQiwyjE7p8Zi3
         SbGg==
X-Gm-Message-State: AJIora+bMNLea4SDMOiTBsII6V4pFE/xbtZTNQY5qmWXAQZKvg5S8Z0e
        1Yfifl8Xq1LmBe/SDnd29x+lojKk174RmnCbZpdac40o+3nRjL/GxrpUfst8jSYmKmhVb8hbVeg
        CPNvdch1AMSJbcqiNPqKLQDbLbyHsxJCZumBpzVwrzTrmEMWKJgG8XlIhFy9u12k=
X-Google-Smtp-Source: AGRyM1tWTXmOJnCNnQ3+h+2OeV4Kgaw9UTsyruCv/PYerCEssgColM8Mc/cJJlMmA0j9BeSm+0+OAAP6LTygNw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:c984:b0:1ec:747b:da32 with SMTP
 id w4-20020a17090ac98400b001ec747bda32mr1002253pjt.216.1656106399957; Fri, 24
 Jun 2022 14:33:19 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:32:55 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-12-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 11/13] KVM: selftests: aarch64: Add dirty logging tests
 into page_fault_test
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

Add some dirty logging tests into page_fault_test. Mark the data and/or
page-table memslots for dirty logging, perform some accesses, and check
that the dirty log bits are set or clean when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 26318d39940b..d44a024dca89 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -34,6 +34,12 @@ static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
 #define CMD_SKIP_TEST				(1ULL << 1)
 #define CMD_HOLE_PT				(1ULL << 2)
 #define CMD_HOLE_TEST				(1ULL << 3)
+#define CMD_RECREATE_PT_MEMSLOT_WR		(1ULL << 4)
+#define CMD_CHECK_WRITE_IN_DIRTY_LOG		(1ULL << 5)
+#define CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG		(1ULL << 6)
+#define CMD_CHECK_NO_WRITE_IN_DIRTY_LOG		(1ULL << 7)
+#define CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG	(1ULL << 8)
+#define CMD_SET_PTE_AF				(1ULL << 9)
 
 #define PREPARE_FN_NR				10
 #define CHECK_FN_NR				10
@@ -248,6 +254,21 @@ static void guest_check_pte_af(void)
 	GUEST_ASSERT_EQ(*((uint64_t *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
 }
 
+static void guest_check_write_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_WRITE_IN_DIRTY_LOG);
+}
+
+static void guest_check_no_write_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_NO_WRITE_IN_DIRTY_LOG);
+}
+
+static void guest_check_s1ptw_wr_in_dirty_log(void)
+{
+	GUEST_SYNC(CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG);
+}
+
 static void guest_exec(void)
 {
 	int (*code)(void) = (int (*)(void))TEST_EXEC_GVA;
@@ -382,6 +403,19 @@ static bool punch_hole_in_memslot(struct kvm_vm *vm,
 	return true;
 }
 
+static bool check_write_in_dirty_log(struct kvm_vm *vm,
+		struct memslot_desc *ms, uint64_t host_pg_nr)
+{
+	unsigned long *bmap;
+	bool first_page_dirty;
+
+	bmap = bitmap_zalloc(ms->size / getpagesize());
+	kvm_vm_get_dirty_log(vm, ms->idx, bmap);
+	first_page_dirty = test_bit(host_pg_nr, bmap);
+	free(bmap);
+	return first_page_dirty;
+}
+
 /* Returns true to continue the test, and false if it should be skipped. */
 static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
@@ -394,6 +428,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		continue_test = punch_hole_in_memslot(vm, &memslot[PT]);
 	if (cmd & CMD_HOLE_TEST)
 		continue_test = punch_hole_in_memslot(vm, &memslot[TEST]);
+	if (cmd & CMD_CHECK_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[TEST], 0),
+				"Missing write in dirty log");
+	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[PT], 0),
+				"Missing s1ptw write in dirty log");
+	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, &memslot[TEST], 0),
+				"Unexpected write in dirty log");
+	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, &memslot[PT], 0),
+				"Unexpected s1ptw write in dirty log");
 
 	return continue_test;
 }
@@ -751,6 +797,19 @@ static void help(char *name)
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
+#define TEST_DIRTY_LOG(_access, _with_af, _test_check)				\
+{										\
+	.name			= SCAT3(dirty_log, _access, _with_af),		\
+	.test_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_prepare		= { _PREPARE(_with_af),				\
+				    _PREPARE(_access) },			\
+	.guest_test		= _access,					\
+	.guest_test_check	= { _CHECK(_with_af), _test_check,		\
+				    guest_check_s1ptw_wr_in_dirty_log},		\
+	.expected_events	= { 0 },					\
+}
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the Access Flag (AF) (sanity checks). */
 	TEST_ACCESS(guest_read64, with_af, CMD_NONE),
@@ -803,6 +862,21 @@ static struct test_desc tests[] = {
 	TEST_UFFD(guest_exec, with_af, CMD_HOLE_TEST | CMD_HOLE_PT,
 			uffd_test_read_handler, uffd_pt_write_handler, 2),
 
+	/*
+	 * Try accesses when the test and PT memslots are both tracked for
+	 * dirty logging.
+	 */
+	TEST_DIRTY_LOG(guest_read64, with_af, guest_check_no_write_in_dirty_log),
+	/* no_af should also lead to a PT write. */
+	TEST_DIRTY_LOG(guest_read64, no_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_ld_preidx, with_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_at, no_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_exec, with_af, guest_check_no_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_write64, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_cas, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_dc_zva, with_af, guest_check_write_in_dirty_log),
+	TEST_DIRTY_LOG(guest_st_preidx, with_af, guest_check_write_in_dirty_log),
+
 	{ 0 }
 };
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

