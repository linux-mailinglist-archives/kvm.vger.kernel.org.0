Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90768663742
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbjAJCYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237813AbjAJCYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:24:39 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DE51AA0E
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 18:24:37 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id r17-20020a17090aa09100b0021903e75f14so3885643pjp.9
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 18:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp6KZaK4i0OSbu/NKsojSPHfn0Q7jcm1ulmiEmBiGis=;
        b=mYIeQ+JzfQV+H0X8TCj99JI2E0PAPczxPWPqFxRirVqv7rZKLgJm7qYa734dOfWvfX
         iFiJIxPuXLLRsw9owEKjYFY3+7GG8U8m8tC8WcZ4EozaWQV++GwGYe8rPkwmfj0qn27v
         6HAOba+KZ69fnS2lGpmBnrCgUlLOfwD+l+YY0/cim/trueDBSjRbD/OGCcwiJ/kvITsp
         78NqQpOOGNuOnw/MmcC7E+yX0Gpj3sLjtcRvR/158R2lq4X9zEhc1EnTzkowJYX+YKAo
         lJQ/qMd3z4jxjT9M3Bx47nz7eN1C8NO2ByC8PKXhFx84MLTOvrNx+2FqnI8vQPKUopFt
         o5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp6KZaK4i0OSbu/NKsojSPHfn0Q7jcm1ulmiEmBiGis=;
        b=wDsYAUh3CZgWksRnXAewC7NTDvj2QfLCxaVMYr3BIHrwrRnt984gPhC72HWNLh+aV+
         Td2CbXL3Lcs/jR3KWP1iV8dLr0YvYZPSI9BRALVUS/gDe8RRh6I1nO80g0/7mEmiqHRA
         Cj24L7k0OZfoE/uCVi5+aabPhmOS7OaMAmBTfnwBEaHFHcaYu/Mp3n8K4M4IVX3IxHFD
         9YpbGTDSNgKZYVbq1+rGQwOjhehmQWnJ+DQpoSiLvqLjCb3Waxg8tsZqS+0pHXbEG/Ll
         z02Hcx3jNWZy20hZUQQIcZy+w6mJmaO1xwV7AFswKrv3k5MLW4xY2YNxIzgK4IXw7ijV
         sIOw==
X-Gm-Message-State: AFqh2kon375JkkRCN6H43pi0bO37cspW14J0jHk3HYbnfJz4pt5PrXOb
        TLQ5VM5dkwSdqOFHB+X7euFFgTkyeOjAAt0glswC+YCtImutFfKzPmU6vV1+hS9jX7FS5kOjd/h
        a3LvTCRVvCx6jPZ5ybzgQ5k78qD7eKHDaFSJ4rpc8FHFr6op0P5o1fSKAaiTvGqA=
X-Google-Smtp-Source: AMrXdXvx8qzMyX8irVdKpLvvBiqlHdIkLXL9LLz5G0n6v+r0pID6P3UN1J6hoRz6I0zZ8IbU3BGTomZDD5N+2A==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a62:e90e:0:b0:57f:1e2b:4c56 with SMTP id
 j14-20020a62e90e000000b0057f1e2b4c56mr3610324pfh.31.1673317477141; Mon, 09
 Jan 2023 18:24:37 -0800 (PST)
Date:   Tue, 10 Jan 2023 02:24:29 +0000
In-Reply-To: <20230110022432.330151-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230110022432.330151-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110022432.330151-2-ricarkol@google.com>
Subject: [PATCH 1/4] KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com,
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

Only Stage1 Page table walks (S1PTW) writing a PTE on an unmapped page
should result in a userfaultfd write. However, the userfaultfd tests in
page_fault_test wrongly assert that any S1PTW is a PTE write.

Fix this by relaxing the read vs. write checks in all userfaultfd handlers.
Note that this is also an attempt to focus less on KVM (and userfaultfd)
behavior, and more on architectural behavior. Also note that after commit
"KVM: arm64: Fix S1PTW handling on RO memslots" the userfaultfd fault
(S1PTW with AF on an unmaped PTE page) is actually a read: the translation
fault that comes before the permission fault.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/page_fault_test.c   | 83 ++++++++-----------
 1 file changed, 34 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index beb944fa6fd4..0dda58766185 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -304,7 +304,7 @@ static struct uffd_args {
 
 /* Returns true to continue the test, and false if it should be skipped. */
 static int uffd_generic_handler(int uffd_mode, int uffd, struct uffd_msg *msg,
-				struct uffd_args *args, bool expect_write)
+				struct uffd_args *args)
 {
 	uint64_t addr = msg->arg.pagefault.address;
 	uint64_t flags = msg->arg.pagefault.flags;
@@ -313,7 +313,6 @@ static int uffd_generic_handler(int uffd_mode, int uffd, struct uffd_msg *msg,
 
 	TEST_ASSERT(uffd_mode == UFFDIO_REGISTER_MODE_MISSING,
 		    "The only expected UFFD mode is MISSING");
-	ASSERT_EQ(!!(flags & UFFD_PAGEFAULT_FLAG_WRITE), expect_write);
 	ASSERT_EQ(addr, (uint64_t)args->hva);
 
 	pr_debug("uffd fault: addr=%p write=%d\n",
@@ -337,19 +336,14 @@ static int uffd_generic_handler(int uffd_mode, int uffd, struct uffd_msg *msg,
 	return 0;
 }
 
-static int uffd_pt_write_handler(int mode, int uffd, struct uffd_msg *msg)
+static int uffd_pt_handler(int mode, int uffd, struct uffd_msg *msg)
 {
-	return uffd_generic_handler(mode, uffd, msg, &pt_args, true);
+	return uffd_generic_handler(mode, uffd, msg, &pt_args);
 }
 
-static int uffd_data_write_handler(int mode, int uffd, struct uffd_msg *msg)
+static int uffd_data_handler(int mode, int uffd, struct uffd_msg *msg)
 {
-	return uffd_generic_handler(mode, uffd, msg, &data_args, true);
-}
-
-static int uffd_data_read_handler(int mode, int uffd, struct uffd_msg *msg)
-{
-	return uffd_generic_handler(mode, uffd, msg, &data_args, false);
+	return uffd_generic_handler(mode, uffd, msg, &data_args);
 }
 
 static void setup_uffd_args(struct userspace_mem_region *region,
@@ -822,7 +816,7 @@ static void help(char *name)
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_test_check	= { _CHECK(_with_af), _test_check },		\
 	.uffd_data_handler	= _uffd_data_handler,				\
-	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.uffd_pt_handler	= uffd_pt_handler,				\
 	.expected_events	= { .uffd_faults = _uffd_faults, },		\
 }
 
@@ -878,7 +872,7 @@ static void help(char *name)
 	.guest_prepare		= { _PREPARE(_access) },			\
 	.guest_test		= _access,					\
 	.uffd_data_handler	= _uffd_data_handler,				\
-	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.uffd_pt_handler	= uffd_pt_handler,				\
 	.mmio_handler		= _mmio_handler,				\
 	.expected_events	= { .mmio_exits = _mmio_exits,			\
 				    .uffd_faults = _uffd_faults },		\
@@ -892,7 +886,7 @@ static void help(char *name)
 	.mem_mark_cmd		= CMD_HOLE_DATA | CMD_HOLE_PT,			\
 	.guest_test		= _access,					\
 	.uffd_data_handler	= _uffd_data_handler,				\
-	.uffd_pt_handler	= uffd_pt_write_handler,			\
+	.uffd_pt_handler	= uffd_pt_handler,			\
 	.fail_vcpu_run_handler	= fail_vcpu_run_mmio_no_syndrome_handler,	\
 	.expected_events	= { .fail_vcpu_runs = 1,			\
 				    .uffd_faults = _uffd_faults },		\
@@ -933,29 +927,27 @@ static struct test_desc tests[] = {
 	 * (S1PTW).
 	 */
 	TEST_UFFD(guest_read64, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
-	/* no_af should also lead to a PT write. */
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_read64, no_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
-	/* Note how that cas invokes the read handler. */
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_cas, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	/*
 	 * Can't test guest_at with_af as it's IMPDEF whether the AF is set.
 	 * The S1PTW fault should still be marked as a write.
 	 */
 	TEST_UFFD(guest_at, no_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 1),
+		  uffd_no_handler, uffd_pt_handler, 1),
 	TEST_UFFD(guest_ld_preidx, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_write64, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_write_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_dc_zva, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_write_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_st_preidx, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_write_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 	TEST_UFFD(guest_exec, with_af, CMD_HOLE_DATA | CMD_HOLE_PT,
-		  uffd_data_read_handler, uffd_pt_write_handler, 2),
+		  uffd_data_handler, uffd_pt_handler, 2),
 
 	/*
 	 * Try accesses when the data and PT memory regions are both
@@ -980,25 +972,25 @@ static struct test_desc tests[] = {
 	 * fault, and nothing in the dirty log.  Any S1PTW should result in
 	 * a write in the dirty log and a userfaultfd write.
 	 */
-	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af, uffd_data_read_handler, 2,
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, with_af, uffd_data_handler, 2,
 				guest_check_no_write_in_dirty_log),
 	/* no_af should also lead to a PT write. */
-	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af, uffd_data_read_handler, 2,
+	TEST_UFFD_AND_DIRTY_LOG(guest_read64, no_af, uffd_data_handler, 2,
 				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af, uffd_data_read_handler,
+	TEST_UFFD_AND_DIRTY_LOG(guest_ld_preidx, with_af, uffd_data_handler,
 				2, guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_at, with_af, 0, 1,
+	TEST_UFFD_AND_DIRTY_LOG(guest_at, with_af, uffd_no_handler, 1,
 				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af, uffd_data_read_handler, 2,
+	TEST_UFFD_AND_DIRTY_LOG(guest_exec, with_af, uffd_data_handler, 2,
 				guest_check_no_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af, uffd_data_write_handler,
+	TEST_UFFD_AND_DIRTY_LOG(guest_write64, with_af, uffd_data_handler,
 				2, guest_check_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af, uffd_data_read_handler, 2,
+	TEST_UFFD_AND_DIRTY_LOG(guest_cas, with_af, uffd_data_handler, 2,
 				guest_check_write_in_dirty_log),
-	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af, uffd_data_write_handler,
+	TEST_UFFD_AND_DIRTY_LOG(guest_dc_zva, with_af, uffd_data_handler,
 				2, guest_check_write_in_dirty_log),
 	TEST_UFFD_AND_DIRTY_LOG(guest_st_preidx, with_af,
-				uffd_data_write_handler, 2,
+				uffd_data_handler, 2,
 				guest_check_write_in_dirty_log),
 
 	/*
@@ -1051,22 +1043,15 @@ static struct test_desc tests[] = {
 	 * no userfaultfd write fault. Reads result in userfaultfd getting
 	 * triggered.
 	 */
-	TEST_RO_MEMSLOT_AND_UFFD(guest_read64, 0, 0,
-				 uffd_data_read_handler, 2),
-	TEST_RO_MEMSLOT_AND_UFFD(guest_ld_preidx, 0, 0,
-				 uffd_data_read_handler, 2),
-	TEST_RO_MEMSLOT_AND_UFFD(guest_at, 0, 0,
-				 uffd_no_handler, 1),
-	TEST_RO_MEMSLOT_AND_UFFD(guest_exec, 0, 0,
-				 uffd_data_read_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_read64, 0, 0, uffd_data_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_ld_preidx, 0, 0, uffd_data_handler, 2),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_at, 0, 0, uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_AND_UFFD(guest_exec, 0, 0, uffd_data_handler, 2),
 	TEST_RO_MEMSLOT_AND_UFFD(guest_write64, mmio_on_test_gpa_handler, 1,
-				 uffd_data_write_handler, 2),
-	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_cas,
-					     uffd_data_read_handler, 2),
-	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_dc_zva,
-					     uffd_no_handler, 1),
-	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_st_preidx,
-					     uffd_no_handler, 1),
+				 uffd_data_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_cas, uffd_data_handler, 2),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_dc_zva, uffd_no_handler, 1),
+	TEST_RO_MEMSLOT_NO_SYNDROME_AND_UFFD(guest_st_preidx, uffd_no_handler, 1),
 
 	{ 0 }
 };
-- 
2.39.0.314.g84b9a713c41-goog

