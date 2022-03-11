Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CE14D5B51
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 07:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbiCKGFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 01:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347316AbiCKGD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 01:03:56 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C97AE5C
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:29 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id i4-20020a63b304000000b0038108d6e7cdso777694pgf.14
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=n0unht5qzdqOFcOLqfZJouXFJeZ+JY2CKOuyKBmheCA=;
        b=LfwlZvTsfX375jUVosmH2FSFaIoyaBWCknnU1gJXvE28xTOYuOr1q34o/zA3Wsg9jT
         1JVwKQ9XrP+iijvAAd70Cgzq8cD0IViWF29HrRDlnUofoEh+LvPKJPTHMhzPy9NDLsjG
         7lyOr1VvFITJI3s4CZr6sXM/jKuJV+mDBLTCUv6n2fvBwx2KDZ2pzT2cjzui2bPFke9n
         mx0fCUxeqG/f8dQmK90wSLvRQSPolTkdzSTP6RXfFXX8N+BykM0G00XaeJ6jw2nWzG94
         nrd04TyJUg0miVpBO/KsSCs5BTrjFQG9ZkCLLH/giJEabKAnATpwD64gxUwfgV3VFeZL
         wymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=n0unht5qzdqOFcOLqfZJouXFJeZ+JY2CKOuyKBmheCA=;
        b=2mnXo/3JaA31XTbeW4EqB0fs6pAKOEjZiB5Ui/BfcDxTYEMpFkMHyx1D51fqRnxkjE
         nkLj1FX0ufhXVRFJkjgqbmJdVgIgWWXDblvzycoO7xeuOvamg4J88KV4CT44lNS7QtFg
         gruufnsll4CbLd+O8CGbTesN8vZlx/oBKx4NL6zBPkv4Af2ai4U8I15CaalV+dsSZxCW
         Re38K3evDc/F8a9p9SLoQdx0wuehe+RLRYxQir28E8F9Op2Vv4B07Lbc0cBSnDNJ5alH
         jJEQ729a0Q3myNnTs88Sl5RyLRaR4vRGwy7J5UReMLmBIrtPXka0hlJaSueYDlN1DtqG
         cLeQ==
X-Gm-Message-State: AOAM5317WnV6q0T6ioTIcsHUW1XKdZJJswK2YMjHdRggvTYr+p+wKyOP
        c2A6Bt6KntC4rqLvAveN5dX+3DenBLR7bEE/6bNK7nJUGSzMKKJXuAlQJGKBjqo5tbVUB2cAOkG
        +j9iLiOLNpLWotA8UnNVEGle+WJXqhgzTintPEe9UHM9TePYkRelIsxNEUgdETas=
X-Google-Smtp-Source: ABdhPJw3bzyRx2Qc+ZAwSoMid/szXDn7Vzz6hZONQ9ewFnuLbhdgmtOSNT7JklW7GOKEz7JP8odEs7mpTOXbOg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:f78d:b0:14f:ce61:eaf2 with SMTP
 id q13-20020a170902f78d00b0014fce61eaf2mr8934670pln.124.1646978548847; Thu,
 10 Mar 2022 22:02:28 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:02:07 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-12-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 11/11] KVM: selftests: aarch64: Add mix of tests into page_fault_test
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

Add some mix of tests into page_fault_test, like stage 2 faults on
memslots marked for both userfaultfd and dirty-logging.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 148 ++++++++++++++++++
 1 file changed, 148 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index e6607f903bc1..f1a5bf081a5b 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -399,6 +399,12 @@ static int uffd_test_read_handler(int mode, int uffd, struct uffd_msg *msg)
 	return uffd_generic_handler(mode, uffd, msg, &memslot[TEST], false);
 }
 
+static int uffd_no_handler(int mode, int uffd, struct uffd_msg *msg)
+{
+	TEST_FAIL("There was no UFFD fault expected.");
+	return -1;
+}
+
 static void punch_hole_in_memslot(struct kvm_vm *vm,
 		struct memslot_desc *memslot)
 {
@@ -912,6 +918,30 @@ int main(int argc, char *argv[])
 #define TEST_S1PTW_ON_HOLE_UFFD_AF(__a, __uffd_handler)				\
 	TEST_S1PTW_ON_HOLE_UFFD(__a, __uffd_handler, __AF_TEST_ARGS)
 
+#define __DIRTY_LOG_TEST							\
+	.test_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test_check	= { guest_check_write_in_dirty_log, },		\
+
+#define __DIRTY_LOG_S1PTW_TEST							\
+	.pt_memslot_flags	= KVM_MEM_LOG_DIRTY_PAGES,			\
+	.guest_test_check	= { guest_check_s1ptw_wr_in_dirty_log, },	\
+
+#define TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(__a, __uffd_handler, ...)	\
+	TEST_S1PTW_ON_HOLE_UFFD(__a, __uffd_handler,				\
+			__DIRTY_LOG_TEST __VA_ARGS__)
+
+#define TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(__a, __uffd_handler, ...)		\
+	TEST_ACCESS_ON_HOLE_UFFD(__a, __uffd_handler,				\
+			__DIRTY_LOG_TEST __VA_ARGS__)
+
+#define TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(__a, __uffd_handler, ...)	\
+	TEST_ACCESS_ON_HOLE_UFFD(__a, __uffd_handler,				\
+			__DIRTY_LOG_S1PTW_TEST __VA_ARGS__)
+
+#define TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(__a, __uffd_handler, ...)		\
+	TEST_S1PTW_ON_HOLE_UFFD(__a, __uffd_handler,				\
+			__DIRTY_LOG_S1PTW_TEST __VA_ARGS__)
+
 #define TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD(__a, __th, __ph, ...)		\
 {										\
 	.name			= SNAME(ACCESS_S1PTW_ON_HOLE_UFFD ## _ ## __a),	\
@@ -1015,6 +1045,10 @@ int main(int argc, char *argv[])
 	.guest_prepare		= { guest_set_ha, guest_check_lse, },		\
 	.guest_test_check	= { guest_check_pte_af, }
 
+#define __NULL_UFFD_HANDLERS							\
+	.uffd_test_handler	= uffd_no_handler,				\
+	.uffd_pt_handler	= uffd_no_handler
+
 #define	TEST_WRITE_ON_RO_MEMSLOT_AF(__a)					\
 	TEST_WRITE_ON_RO_MEMSLOT(__a, __AF_TEST_IN_RO_MEMSLOT_ARGS)
 
@@ -1105,6 +1139,37 @@ int main(int argc, char *argv[])
 #define TEST_EXEC_AND_S1PTW_AF_ON_RO_MEMSLOT(__a) 				\
 	TEST_EXEC_AND_S1PTW_ON_RO_MEMSLOT(__a, __AF_TEST_IN_RO_MEMSLOT_ARGS)
 
+#define TEST_WRITE_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(__a)			\
+	TEST_WRITE_AND_S1PTW_ON_RO_MEMSLOT(__a, __NULL_UFFD_HANDLERS)
+#define TEST_READ_AND_S1PTW_ON_RO_MEMSLOT_WITH_UFFD(__a)			\
+	TEST_READ_AND_S1PTW_ON_RO_MEMSLOT(__a, __NULL_UFFD_HANDLERS)
+#define TEST_CM_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(__a)			\
+	TEST_CM_AND_S1PTW_ON_RO_MEMSLOT(__a, __NULL_UFFD_HANDLERS)
+#define TEST_EXEC_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(__a)			\
+	TEST_EXEC_AND_S1PTW_ON_RO_MEMSLOT(__a, __NULL_UFFD_HANDLERS)
+
+#define	TEST_WRITE_ON_RO_DIRTY_LOG_MEMSLOT(__a, ...)				\
+{										\
+	.name			= SNAME(WRITE_ON_RO_MEMSLOT ## _ ## __a),	\
+	.test_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.guest_test		= __a,						\
+	.guest_test_check	= { guest_check_no_write_in_dirty_log, },	\
+	.mmio_handler		= mmio_on_test_gpa_handler,			\
+	.expected_events	= { .mmio_exits = 1, },				\
+	__VA_ARGS__								\
+}
+
+#define	TEST_CM_ON_RO_DIRTY_LOG_MEMSLOT(__a, ...)				\
+{										\
+	.name			= SNAME(WRITE_ON_RO_MEMSLOT ## _ ## __a),	\
+	.test_memslot_flags	= KVM_MEM_READONLY | KVM_MEM_LOG_DIRTY_PAGES,	\
+	.guest_test		= __a,						\
+	.guest_test_check	= { guest_check_no_write_in_dirty_log, },	\
+	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
+	.expected_events	= { .fail_vcpu_runs = 1, },			\
+	__VA_ARGS__								\
+}
+
 static struct test_desc tests[] = {
 	/* Check that HW is setting the AF (sanity checks). */
 	TEST_HW_ACCESS_FLAG(guest_test_read64),
@@ -1223,6 +1288,65 @@ static struct test_desc tests[] = {
 	TEST_ACCESS_AND_S1PTW_ON_HOLE_UFFD_AF(guest_test_exec,
 			uffd_test_read_handler, uffd_pt_write_handler),
 
+	/* Write into a memslot marked for both dirty logging and UFFD. */
+	TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(guest_test_write64,
+			uffd_test_write_handler),
+	/* Note that the cas uffd handler is for a read. */
+	TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(guest_test_cas,
+			uffd_test_read_handler, __PREPARE_LSE_TEST_ARGS),
+	TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(guest_test_dc_zva,
+			uffd_test_write_handler),
+	TEST_WRITE_ON_DIRTY_LOG_AND_UFFD(guest_test_st_preidx,
+			uffd_test_write_handler),
+
+	/*
+	 * Access whose s1ptw faults on a hole that's marked for both dirty
+	 * logging and UFFD.
+	 */
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_read64,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_cas,
+			uffd_pt_write_handler, __PREPARE_LSE_TEST_ARGS),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_ld_preidx,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_exec,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_write64,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_st_preidx,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_dc_zva,
+			uffd_pt_write_handler),
+	TEST_S1PTW_ON_DIRTY_LOG_AND_UFFD(guest_test_at,
+			uffd_pt_write_handler),
+
+	/*
+	 * Write on a memslot marked for dirty logging whose related s1ptw
+	 * is on a hole marked with UFFD.
+	 */
+	TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(guest_test_write64,
+			uffd_pt_write_handler),
+	TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(guest_test_cas,
+			uffd_pt_write_handler, __PREPARE_LSE_TEST_ARGS),
+	TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(guest_test_dc_zva,
+			uffd_pt_write_handler),
+	TEST_WRITE_DIRTY_LOG_AND_S1PTW_ON_UFFD(guest_test_st_preidx,
+			uffd_pt_write_handler),
+
+	/*
+	 * Write on a memslot that's on a hole marked with UFFD, whose related
+	 * sp1ptw is on a memslot marked for dirty logging.
+	 */
+	TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(guest_test_write64,
+			uffd_test_write_handler),
+	/* Note that the uffd handler is for a read. */
+	TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(guest_test_cas,
+			uffd_test_read_handler, __PREPARE_LSE_TEST_ARGS),
+	TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(guest_test_dc_zva,
+			uffd_test_write_handler),
+	TEST_WRITE_UFFD_AND_S1PTW_ON_DIRTY_LOG(guest_test_st_preidx,
+			uffd_test_write_handler),
+
 	/* Access on readonly memslot (sanity check). */
 	TEST_WRITE_ON_RO_MEMSLOT(guest_test_write64),
 	TEST_READ_ON_RO_MEMSLOT(guest_test_read64),
@@ -1290,6 +1414,30 @@ static struct test_desc tests[] = {
 	TEST_CM_AND_S1PTW_AF_ON_RO_MEMSLOT(guest_test_st_preidx),
 	TEST_EXEC_AND_S1PTW_AF_ON_RO_MEMSLOT(guest_test_exec),
 
+	/*
+	 * Access on a memslot marked as readonly with also dirty log tracking.
+	 * There should be no write in the dirty log.
+	 */
+	TEST_WRITE_ON_RO_DIRTY_LOG_MEMSLOT(guest_test_write64),
+	TEST_CM_ON_RO_DIRTY_LOG_MEMSLOT(guest_test_cas,
+			__PREPARE_LSE_TEST_ARGS),
+	TEST_CM_ON_RO_DIRTY_LOG_MEMSLOT(guest_test_dc_zva),
+	TEST_CM_ON_RO_DIRTY_LOG_MEMSLOT(guest_test_st_preidx),
+
+	/*
+	 * Access on a RO memslot with S1PTW also on a RO memslot, while also
+	 * having those memslot regions marked for UFFD fault handling.  The
+	 * result is that UFFD fault handlers should not be called.
+	 */
+	TEST_WRITE_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(guest_test_write64),
+	TEST_READ_AND_S1PTW_ON_RO_MEMSLOT_WITH_UFFD(guest_test_read64),
+	TEST_READ_AND_S1PTW_ON_RO_MEMSLOT_WITH_UFFD(guest_test_ld_preidx),
+	TEST_CM_AND_S1PTW_ON_RO_MEMSLOT(guest_test_cas,
+			__PREPARE_LSE_TEST_ARGS __NULL_UFFD_HANDLERS),
+	TEST_CM_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(guest_test_dc_zva),
+	TEST_CM_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(guest_test_st_preidx),
+	TEST_EXEC_AND_S1PTW_AF_ON_RO_MEMSLOT_WITH_UFFD(guest_test_exec),
+
 	{ 0 },
 };
 
-- 
2.35.1.723.g4982287a31-goog

