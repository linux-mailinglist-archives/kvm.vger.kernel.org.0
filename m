Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16154D5B53
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 07:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiCKGE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 01:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347310AbiCKGDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 01:03:55 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7C2B40
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:26 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d145-20020a621d97000000b004f7285f67e8so4642803pfd.2
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9kgFaGsT8/B0fio+4RiMckapt6Qp1qpNOH83d8/dvfs=;
        b=eEpqL3c5BAWAM4Zd47HQtztsOnCFI0c8VLYJbxS/kbJDaNcAyytHkHe2S4iq8FoWzJ
         6JoA89sHYrLEKkDXGAcoTIqI0GOnFrT38qzd/pAbRZSNqgC30EC5oW7BPwR+yTNCAPuw
         NJJiTjt33iCewXSjkATF62yUeKDMrRNvNTELh+dd+LxEyThuHPIO6zteDZKH4AnU9y4l
         5ZerJGMZnM2LsXVZtV2p3uMqm2cNcUWZngd+u+XPzSYySEUrzaOqOUY9Is3tEs8qkMae
         joBq2xgovJLzf6nCX196L2feJ14E/evb82bI3XYBIbkFTepY+oweLAzXv2gkj+vpwOPo
         AImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9kgFaGsT8/B0fio+4RiMckapt6Qp1qpNOH83d8/dvfs=;
        b=SdjWZyZQ6ZK8LA3z9yLPsShsFUA0N2/+yjFOnAYl7t7pVkMJahMkRiDOgaTwvnIjiQ
         G2/60MPtWoq9Az+5cWnF3NFOPkLcG2cyaVw8O+isVX9LvlfAX/Ywq1xhvUUyl4sg+VLw
         HAdzZ/J/9PzQ3aPilGcLqL8wkIoULu5mZKvQLratejgZKPALER7Nq1buqy37S/sM0Aaj
         IChFX1uUFtSZyukGFli6AlISqtkoh5tiICYgMx1Bg/B/yl624NRUsT7uSOUfVrdFaGnv
         LxpwlRSrrw0usUMHrQHZAzvAHCQgPW5dq6WdGAAyRssiiql8I0WNJkBvto6dA57JuMSs
         tkEQ==
X-Gm-Message-State: AOAM532FiCZH3AH1E1uJTj9THDslSkJyerlTaFex8jTzCwE+Q0fXk52V
        nHw2H8x3W+pYfa8ILj/c/nZFWGwybp6AxgOggDpgljDe3n/K0YDNc2d7bqY7ySJzk+2D+31cCN9
        4Ps09TKfPKrxmL2EViM1rbmX9tgQszptuT7MhF5zo1hBmWnDlf2Q3nldulLEhKcA=
X-Google-Smtp-Source: ABdhPJylXOEFK30IzO362QIV0eVcmcL0f9ewowSR/vacH9J6rbR5mLCxq1VlgHLRqtvGbDRxJhlkAG1SuFYnXA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:9e07:0:b0:4f6:a7e3:1b57 with SMTP id
 y7-20020aa79e07000000b004f6a7e31b57mr8361479pfq.13.1646978545757; Thu, 10 Mar
 2022 22:02:25 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:02:05 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 09/11] KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
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

Add some dirty logging tests into page_fault_test. Mark the data and/or
page-table memslots for dirty logging, perform some accesses, and check
that the dirty log bits are set or clean when expected.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 123 ++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 99449eaddb2b..b41da9317242 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -45,6 +45,11 @@
 #define CMD_SKIP_TEST				(-1LL)
 #define CMD_HOLE_PT				(1ULL << 2)
 #define CMD_HOLE_TEST				(1ULL << 3)
+#define CMD_RECREATE_PT_MEMSLOT_WR		(1ULL << 4)
+#define CMD_CHECK_WRITE_IN_DIRTY_LOG		(1ULL << 5)
+#define CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG		(1ULL << 6)
+#define CMD_CHECK_NO_WRITE_IN_DIRTY_LOG		(1ULL << 7)
+#define CMD_SET_PTE_AF				(1ULL << 8)
 
 #define PREPARE_FN_NR				10
 #define CHECK_FN_NR				10
@@ -251,6 +256,21 @@ static void guest_check_pte_af(void)
 	GUEST_ASSERT_EQ(*((uint64_t *)pte_gva) & PTE_AF, PTE_AF);
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
 static void guest_test_exec(void)
 {
 	int (*code)(void) = (int (*)(void))test_exec_gva;
@@ -380,12 +400,34 @@ static void punch_hole_in_memslot(struct kvm_vm *vm,
 	}
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
 static void handle_cmd(struct kvm_vm *vm, int cmd)
 {
 	if (cmd & CMD_HOLE_PT)
 		punch_hole_in_memslot(vm, &memslot[PT]);
 	if (cmd & CMD_HOLE_TEST)
 		punch_hole_in_memslot(vm, &memslot[TEST]);
+	if (cmd & CMD_CHECK_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[TEST], 0),
+				"Missing write in dirty log");
+	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
+		TEST_ASSERT(!check_write_in_dirty_log(vm, &memslot[TEST], 0),
+				"Unexpected s1ptw write in dirty log");
+	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
+		TEST_ASSERT(check_write_in_dirty_log(vm, &memslot[PT], 0),
+				"Missing s1ptw write in dirty log");
 }
 
 static void sync_stats_from_guest(struct kvm_vm *vm)
@@ -783,6 +825,56 @@ int main(int argc, char *argv[])
 #define TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(__a, __th, __ph)			\
 	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(__a, __th, __ph, __AF_TEST_ARGS)
 
+#define	__TEST_ACCESS_DIRTY_LOG(__a, ...)					\
+{										\
+	.name			= SNAME(TEST_ACCESS_DIRTY_LOG ## _ ## __a),	\
+	.test_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test 		= __a,						\
+	.expected_events	= { 0 },					\
+	__VA_ARGS__								\
+}
+
+#define __CHECK_WRITE_IN_DIRTY_LOG						\
+	.guest_test_check	= { guest_check_write_in_dirty_log, },
+
+#define __CHECK_NO_WRITE_IN_DIRTY_LOG						\
+	.guest_test_check	= { guest_check_no_write_in_dirty_log, },
+
+#define	TEST_WRITE_DIRTY_LOG(__a, ...)						\
+	__TEST_ACCESS_DIRTY_LOG(__a, __CHECK_WRITE_IN_DIRTY_LOG __VA_ARGS__)
+
+#define	TEST_NO_WRITE_DIRTY_LOG(__a, ...)					\
+	__TEST_ACCESS_DIRTY_LOG(__a, __CHECK_NO_WRITE_IN_DIRTY_LOG __VA_ARGS__)
+
+#define	__TEST_S1PTW_DIRTY_LOG(__a, ...)					\
+{										\
+	.name			= SNAME(S1PTW_AF_DIRTY_LOG ## _ ## __a),	\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test 		= __a,						\
+	.expected_events	= { 0 },					\
+	__VA_ARGS__								\
+}
+
+#define __CHECK_S1PTW_WR_IN_DIRTY_LOG						\
+	.guest_test_check	= { guest_check_s1ptw_wr_in_dirty_log, },
+
+#define	TEST_S1PTW_DIRTY_LOG(__a, ...)						\
+	__TEST_S1PTW_DIRTY_LOG(__a, __CHECK_S1PTW_WR_IN_DIRTY_LOG __VA_ARGS__)
+
+#define __AF_TEST_ARGS_FOR_DIRTY_LOG						\
+	.guest_prepare		= { guest_set_ha, guest_clear_pte_af, },	\
+	.guest_test_check       = { guest_check_s1ptw_wr_in_dirty_log, 		\
+				    guest_check_pte_af, },
+
+#define __AF_AND_LSE_ARGS_FOR_DIRTY_LOG						\
+	.guest_prepare		= { guest_set_ha, guest_clear_pte_af,		\
+				    guest_check_lse, },				\
+	.guest_test_check       = { guest_check_s1ptw_wr_in_dirty_log, 		\
+				    guest_check_pte_af, },
+
+#define	TEST_S1PTW_AF_DIRTY_LOG(__a, ...)					\
+	TEST_S1PTW_DIRTY_LOG(__a, __AF_TEST_ARGS_FOR_DIRTY_LOG)
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the AF (sanity checks). */
 	TEST_HW_ACCESS_FLAG(guest_test_read64),
@@ -793,6 +885,37 @@ static struct test_desc tests[] = {
 	TEST_HW_ACCESS_FLAG(guest_test_dc_zva),
 	TEST_HW_ACCESS_FLAG(guest_test_exec),
 
+	/* Dirty log basic checks. */
+	TEST_WRITE_DIRTY_LOG(guest_test_write64),
+	TEST_WRITE_DIRTY_LOG(guest_test_cas, __PREPARE_LSE_TEST_ARGS),
+	TEST_WRITE_DIRTY_LOG(guest_test_dc_zva),
+	TEST_WRITE_DIRTY_LOG(guest_test_st_preidx),
+	TEST_NO_WRITE_DIRTY_LOG(guest_test_read64),
+	TEST_NO_WRITE_DIRTY_LOG(guest_test_ld_preidx),
+	TEST_NO_WRITE_DIRTY_LOG(guest_test_at),
+	TEST_NO_WRITE_DIRTY_LOG(guest_test_exec),
+
+	/*
+	 * S1PTW on a PT (no AF) which is marked for dirty logging. Note that
+	 * this still shows up in the dirty log as a write.
+	 */
+	TEST_S1PTW_DIRTY_LOG(guest_test_write64),
+	TEST_S1PTW_DIRTY_LOG(guest_test_st_preidx),
+	TEST_S1PTW_DIRTY_LOG(guest_test_read64),
+	TEST_S1PTW_DIRTY_LOG(guest_test_cas, __PREPARE_LSE_TEST_ARGS),
+	TEST_S1PTW_DIRTY_LOG(guest_test_ld_preidx),
+	TEST_S1PTW_DIRTY_LOG(guest_test_at),
+	TEST_S1PTW_DIRTY_LOG(guest_test_dc_zva),
+	TEST_S1PTW_DIRTY_LOG(guest_test_exec),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_write64),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_st_preidx),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_read64),
+	TEST_S1PTW_DIRTY_LOG(guest_test_cas, __AF_AND_LSE_ARGS_FOR_DIRTY_LOG),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_ld_preidx),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_at),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_dc_zva),
+	TEST_S1PTW_AF_DIRTY_LOG(guest_test_exec),
+
 	/* Accessing a hole shouldn't fault (more sanity checks). */
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_read64),
 	TEST_ACCESS_ON_HOLE_NO_FAULTS(guest_test_cas, __PREPARE_LSE_TEST_ARGS),
-- 
2.35.1.723.g4982287a31-goog

