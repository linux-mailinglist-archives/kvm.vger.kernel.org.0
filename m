Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A5F59EFF6
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiHWXsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiHWXsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:48:01 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448DF8B9B4
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-32a115757b6so266097977b3.13
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=C3mw9TC4ccUp9ylGFVORw6Xc1IPwCBImXAp0s1FQtvY=;
        b=ptgB4pRaV5V8SPuqWv1fddbrucjPZdH+/qJ/NGfyNpKFi24MsqzzVKhnp9OhTo/SIF
         dQ3eQpEO44nbMTCpPuwNNwGxPV24l20eqt3eROiH+TrCCHh64gxMhOQjZcwOM+702JpH
         JPieDZkYr63mazSwOXWbn288NK1YQrWEF8hKTEChN8oUiO/43tAixHbvO8g2l8Wt6L0n
         OILmLpCkvNZL1ovNb53wLRI7IqeiBnWVcb8NOyCFvDCBgySWeojoIezjAVDHB6Go7rLD
         pFdRCc6qfN+KvHyv/qjwn6595FWrUUUYU+uiJJv2X/r5GqlmrHwDNajC7crsknI39mBP
         bFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=C3mw9TC4ccUp9ylGFVORw6Xc1IPwCBImXAp0s1FQtvY=;
        b=aD+Zs6pu9DBCAeMswM1yJTLiB2rVb9713lmX2/hgwifl9pmGs2V8aLc1UuL2VeXbXV
         +0UE6BLm1i4cf5TyyRu0qJUrobj3FlC5QzX2S44tRODuAb+WPEij/uFgbrLBv/hiupAu
         WM/6i6NtHYss8ICLVH9xPTXQlvcYezY2ZzjLMoneqHjV6uen1JYowj6uxPr8kubRGC36
         PoiDqh5p1koRZiVQuIuFR6WRDy02INcAG9C69tRP9Ir6uAYW1SYcZjY7ACRECwB+nMlY
         DwSO3Ls8umJ+WJckMohrhUSi86BV0kM8bAxoV/f2+0uG3/VAnvC3AYlJrOizt8qts32h
         /K4w==
X-Gm-Message-State: ACgBeo3aVyAUL3ps3eQi4pFHSlE/QzTVzsPdMClwFbqX1E2pdSVyjiJg
        bS/+zuZMwl5+eT9yqQE9n5C0xNm/Q17uvvat7uMeriD1r5Sp3Vf67r5r14zOyoBBwmTZNpkFfcE
        76HHkgUeHwYEh/P92WcarhO0a9D3VMvoZ8lpw3tSqdiLrfPEkVezgqCF6Q6uFCcE=
X-Google-Smtp-Source: AA6agR6G72/926ISlJ/T1Xd3tCIya4UiNSonqcQsOzvgHaEd+gMfDs1/m9zN4VnySbDFGR+cPw/61agxR066zQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:4941:0:b0:33d:778:3bbe with SMTP id
 w62-20020a814941000000b0033d07783bbemr10451318ywa.459.1661298474796; Tue, 23
 Aug 2022 16:47:54 -0700 (PDT)
Date:   Tue, 23 Aug 2022 23:47:25 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-12-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 11/13] KVM: selftests: aarch64: Add dirty logging tests
 into page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com,
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

Add some dirty logging tests into page_fault_test. Mark the data and/or
page-table memslots for dirty logging, perform some accesses, and check
that the dirty log bits are set or clean when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 27b8b50fd4c4..50117a070be0 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -31,6 +31,11 @@ static uint64_t *guest_test_memory = (uint64_t *)TEST_GVA;
 #define CMD_SKIP_TEST				(1ULL << 1)
 #define CMD_HOLE_PT				(1ULL << 2)
 #define CMD_HOLE_DATA				(1ULL << 3)
+#define CMD_CHECK_WRITE_IN_DIRTY_LOG		(1ULL << 4)
+#define CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG		(1ULL << 5)
+#define CMD_CHECK_NO_WRITE_IN_DIRTY_LOG		(1ULL << 6)
+#define CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG	(1ULL << 7)
+#define CMD_SET_PTE_AF				(1ULL << 8)
 
 #define PREPARE_FN_NR				10
 #define CHECK_FN_NR				10
@@ -213,6 +218,21 @@ static void guest_check_pte_af(void)
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
@@ -398,6 +418,21 @@ static bool punch_hole_in_memslot(struct kvm_vm *vm,
 	return true;
 }
 
+static bool check_write_in_dirty_log(struct kvm_vm *vm,
+		struct userspace_mem_region *region, uint64_t host_pg_nr)
+{
+	unsigned long *bmap;
+	bool first_page_dirty;
+	uint64_t size = region->region.memory_size;
+
+	/* getpage_size() is not always equal to vm->page_size */
+	bmap = bitmap_zalloc(size / getpagesize());
+	kvm_vm_get_dirty_log(vm, region->region.slot, bmap);
+	first_page_dirty = test_bit(host_pg_nr, bmap);
+	free(bmap);
+	return first_page_dirty;
+}
+
 /* Returns true to continue the test, and false if it should be skipped. */
 static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
@@ -414,6 +449,18 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		continue_test = punch_hole_in_memslot(vm, pt_region);
 	if (cmd & CMD_HOLE_DATA)
 		continue_test = punch_hole_in_memslot(vm, data_region);
+	if (cmd & CMD_CHECK_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, data_region, 0),
+				"Missing write in dirty log");
+	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, 0),
+				"Missing s1ptw write in dirty log");
+	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, data_region, 0),
+				"Unexpected write in dirty log");
+	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, 0),
+				"Unexpected s1ptw write in dirty log");
 
 	return continue_test;
 }
@@ -700,6 +747,19 @@ static void help(char *name)
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
+#define TEST_DIRTY_LOG(_access, _with_af, _test_check)				\
+{										\
+	.name			= SCAT3(dirty_log, _access, _with_af),		\
+	.data_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
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
@@ -753,6 +813,21 @@ static struct test_desc tests[] = {
 	TEST_UFFD(guest_exec, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
 			uffd_data_read_handler, uffd_pt_write_handler, 2),
 
+	/*
+	 * Try accesses when the data and PT memslots are both tracked for
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
2.37.1.595.g718a3a8f04-goog

