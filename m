Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE3B663744
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbjAJCYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbjAJCYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:24:42 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249572F7AF
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 18:24:42 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id u3-20020a056a00124300b0056d4ab0c7cbso4352356pfi.7
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 18:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MOc6nDFQxL2+zMzMHVOY/zZ9XFhHWFGOwpzRU/kQJv4=;
        b=giKA0LkehwnFAaJcxWDPj+9uugfdIq16i6d89COL3MpQpBHSdMfJ9ai8B/GNsiicdz
         waa3+dABc6GxX+rusfAc1gaP6XzkrpGIi00AjbdmFPqbki6H8jAXkPw3Jcf3jXZDXMiS
         qXNXBTPXkAvi97AZ1KuPRVCL5sk0w6opxw+DjBNx4zzc7ViUoMSNOXeh/5SOPDnai0WO
         KqdaQ+T//2ENiD+cHLk4zBDULpMfmWA22SSrDHCxgNnwPLWwTZJhVi+F3glO7pYLwsXi
         +5Lfdc7QG74jkXTkewy+fEtoBS3X18mhc5J2koQaC1bzpfRVu7rcApDO/2qlJHDGX9Jv
         5hBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MOc6nDFQxL2+zMzMHVOY/zZ9XFhHWFGOwpzRU/kQJv4=;
        b=o1tHg5ABi0V0pX2YuzNY4hifzt3x7GZd6MRCf9cMO+bHge9IGR+5xNCd8nKnSq2S4Z
         Y/Ly7MnO/XrE6ZiMslbXtVLECm1TRqoTvdzGAPFI7XtCYTDcZFEvVt1Q9WdRItNv7rMF
         ka15Otk3u/+q2Ow/YoxYhjhCGr54tcPdIdeg/iyNGpRqPg6/T9mW6D+h5QBTWX2kb+kP
         fPGDwASTnSXBWxXBaBiMNeWBsBTQq8OUGSmGxOkPaNL2J5LlTc8q44/lAyxJiTfEakSb
         1Ss33yEZJbdYm2nCaTlBhAwJBQBByhjSJpmeEl/9R5hQrlz7m0jWwCYM5+q4jTrB9iNY
         5+EQ==
X-Gm-Message-State: AFqh2kpCXMJdIBACZvFAC1jUquIVCwvN076USolN+AJd8Wqb4XIflGvH
        rzhoIg53U/InI0sfO+EyQ2k/QL5BOUIZj5wDFTwvDsBhWVd6H2IJ2mbD+Tixjwo4cP5rfkLOy2v
        iJuPpIBe2bkeZhB4JHEHuMS0cmqXWzRAOWAytca+sVC4WZYp5HvGRBIGC5uZ6cp4=
X-Google-Smtp-Source: AMrXdXtiP2AjlooOdh29gOi1ydGUgioJWHVFIDJdUdJK5lpaF4pioCqj/pDWU2ysBBrHgveL1sZl9eOQXlw7Bg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:e046:0:b0:477:a381:84d with SMTP id
 n6-20020a63e046000000b00477a381084dmr4374577pgj.207.1673317481175; Mon, 09
 Jan 2023 18:24:41 -0800 (PST)
Date:   Tue, 10 Jan 2023 02:24:31 +0000
In-Reply-To: <20230110022432.330151-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230110022432.330151-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110022432.330151-4-ricarkol@google.com>
Subject: [PATCH 3/4] KVM: selftests: aarch64: Fix check of dirty log PT write
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

The dirty log checks are mistakenly testing the first page in the page
table (PT) memory region instead of the page holding the test data page
PTE.  This wasn't an issue before commit "KVM: arm64: Fix handling of S1PTW
S2 fault on RO memslots" as all PT pages (including the first page) were
treated as writes.

Fix the page_fault_test dirty logging tests by checking for the right page:
the one for the PTE of the data test page.

Fixes: a4edf25b3e25 ("KVM: selftests: aarch64: Add dirty logging tests into page_fault_test")
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 1a3bb2bd8657..2e2178a7d0d8 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -470,9 +470,12 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 {
 	struct userspace_mem_region *data_region, *pt_region;
 	bool continue_test = true;
+	uint64_t pte_gpa, pte_pg;
 
 	data_region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
 	pt_region = vm_get_mem_region(vm, MEM_REGION_PT);
+	pte_gpa = addr_hva2gpa(vm, virt_get_pte_hva(vm, TEST_GVA));
+	pte_pg = (pte_gpa - pt_region->region.guest_phys_addr) / getpagesize();
 
 	if (cmd == CMD_SKIP_TEST)
 		continue_test = false;
@@ -485,13 +488,13 @@ static bool handle_cmd(struct kvm_vm *vm, int cmd)
 		TEST_ASSERT(check_write_in_dirty_log(vm, data_region, 0),
 			    "Missing write in dirty log");
 	if (cmd & CMD_CHECK_S1PTW_WR_IN_DIRTY_LOG)
-		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, 0),
+		TEST_ASSERT(check_write_in_dirty_log(vm, pt_region, pte_pg),
 			    "Missing s1ptw write in dirty log");
 	if (cmd & CMD_CHECK_NO_WRITE_IN_DIRTY_LOG)
 		TEST_ASSERT(!check_write_in_dirty_log(vm, data_region, 0),
 			    "Unexpected write in dirty log");
 	if (cmd & CMD_CHECK_NO_S1PTW_WR_IN_DIRTY_LOG)
-		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, 0),
+		TEST_ASSERT(!check_write_in_dirty_log(vm, pt_region, pte_pg),
 			    "Unexpected s1ptw write in dirty log");
 
 	return continue_test;
-- 
2.39.0.314.g84b9a713c41-goog

