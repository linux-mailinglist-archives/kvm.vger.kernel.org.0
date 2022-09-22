Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBB05E599E
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiIVDXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiIVDVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAB095688
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q84-20020a25d957000000b006aeb2dba911so7003297ybg.8
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=AZw1gJfegvOphMBeEyY3Bk5qAPIfoUIErHWHqLDrxMc=;
        b=kzjHZ8SIP1dGJFy121XAjYuSnTmCHfAVgwgASz/hPbRDaoQKuF/9pGvLn0twl8N2zm
         eBDpR1SZn7gV/0Hxcx9nCun1WPXC31IQingFRVenqvgtrgSPlRG1IEUWaHPTei870fk5
         I1s89usoVL56vbljfHP8ZiDmtmgz00vOGdh1Gm+ca2sHyjYjASSh6ivE2EL4n6GCoT6l
         1VWyjgvqH3T5rfV86JA5gVt1/Hao44rqufNuRbXSoR1qF8Q1PXs1iOrlaq+sEswG4GsF
         URjZ4zxOFTOaHd6NYBddNiZ4DvIwKjySyaCHkUOeGyi6jTYXeVEkGJBMjw38bZ9GYGDI
         jVrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=AZw1gJfegvOphMBeEyY3Bk5qAPIfoUIErHWHqLDrxMc=;
        b=JQDM1SSExWAAnHIUi9AQ8FyCqScDtYxx2XAKEyd758uHh+ta5UKo/8f2GGCcMPTM68
         QvNNtJtyIs/vXwVz7traPkqNq7fYJTX/qzFlp8boMoRSdoC58LaJ5NcVtjad+x1KNM4B
         y7UGraTtTN5apSEI4wyLY0w6K+4ladspY8U6Eyv7dhZBp3YhRkXQkYiaIsshyRJQ/zbf
         K8m7TrHelAjQOLtgkcG3J9YLVxYzzGqs9AxsQuKokGEuAkMN5fBITUjI0K1uxDTF0umu
         9l0RovgyZSqxkg9ELCnDKuS4u34lkeWFVQhvj7ABpv6WyPjzt14Ly6D2cas8chg1A6MW
         JImA==
X-Gm-Message-State: ACrzQf0Fo43c1X9TKF8VPJiI3LanB5s+v8acCOzfiDQGPifVFTfnXUTw
        WMxsL7yRJarsQZnmlMQ8VVHjq4t0TmGAEsPQ5rJeETOvcubzWnXesbgitWJ8/AnfnENii9Lo7TN
        rN+8SISH17M4hXl0HjKidVWSI0dZ3op22J8WR1UqSmym28JtQS8n3KuxU0bKutJU=
X-Google-Smtp-Source: AMsMyM7lWYY+S4d140K7nPy9QlgISe4DKEMt0sOkhYkPe7vc8cMdhojYVjU3AtGdNFd0hN4+GxV+6DDnv3Mn3g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9947:0:b0:6b4:1ed6:19eb with SMTP id
 n7-20020a259947000000b006b41ed619ebmr1493975ybo.285.1663816759981; Wed, 21
 Sep 2022 20:19:19 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:55 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-13-ricarkol@google.com>
Subject: [PATCH v8 12/14] KVM: selftests: aarch64: Add dirty logging tests
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

Add some dirty logging tests into page_fault_test. Mark the data and/or
page-table memslots for dirty logging, perform some accesses, and check
that the dirty log bits are set or clean when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 75ad1440268a..5f6e10a385a9 100644
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
@@ -677,6 +724,19 @@ static void help(char *name)
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
@@ -730,6 +790,21 @@ static struct test_desc tests[] = {
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
2.37.3.968.ga6b4b080e4-goog

