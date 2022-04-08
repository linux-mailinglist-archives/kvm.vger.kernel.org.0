Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28984F8B05
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiDHAnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiDHAnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:43:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829FF17869F
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 17:41:27 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t204-20020a635fd5000000b0039ba3f42ba0so3879225pgb.13
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 17:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HeX9SVaeN+dOlq3215hdXIGo/ycBIAgWX4h+cW+bQa4=;
        b=A2NZj+FpVZNDGJQWNXDrB2BNEOaaJfiikxNwLSYWGz6Zg9PxPsi/PfA69cXgtQpKBW
         cS4Xc3Zw68rXwZDzMOUQePv5n9Q1jW6twdRYmGzcWfLz505eZNzAaNqoVjfDNoJNzs5t
         kkhDrFclG6AMRs/8DvYiF49WBSiWkeb//ayHr/Dywek4pLEUSiko1nFj0N0ZPWqmAeLo
         iaQpWW/D5UoCcVTmeT1tuu3HwxFwI3ucBk51EU8HRTPTV1ShDoiT/LFnU/x4UE3uGEeO
         YSNa9Hbp2I8ZNdqwlqVFXkCeNvu4ZBd9JR89XsorHdFFbn6LYPNSqmNiHiTacj1NxRN6
         Alow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HeX9SVaeN+dOlq3215hdXIGo/ycBIAgWX4h+cW+bQa4=;
        b=Fmw9b+Dk04P6bhRn0k5QWucUtrVsgZOqb8pKC7BWYyaXvYwuO9Y5i/NPKZ1kIQVJsv
         /fa3GzumJx3bdjsOQfJBDSHkp5LG7QOeBXY9Lp4QsOU8M/3DwoXN4dCOyZlKL3HOxgLu
         w5CulfURMR4kzymYdO2Lpegc4ILNY3Bt8ibz4vFEPiowYcdrt/egGU9kBAwibxSQVXuC
         C79Q5X2KTXVTZC6Ww96OOtzUp8wJ/ltvu5fNAx2JrYgeSgurJMxeBsNGv8ZQbrOoV6wk
         XMxbmEZXtwCJ+fiEyxi4qGvXFasxPXR4y3wlvgITqgJ2OScIL2CB+FVGVk5LXXZsxLWJ
         H4lg==
X-Gm-Message-State: AOAM533nxMFX5bonI7MkU4X/nUXGqCc7cY5LILNd9MtTJA8Wv7ZTLlIn
        Qj9bhGH7gzBMbuw7eRI8UtvgN47w/RtXfGY+10wvGjGHYDAURU60jrW6ppLfrMOhdwzMj8qimuZ
        8FGcMotaLy4Smju0K/SkKAbhuLD19GMFKNiHvVjz/D2b44voogDuAQFNNX83Zd8M=
X-Google-Smtp-Source: ABdhPJyKVr37Yo71iEW4bLnBVyE3YskZbsr0cqGngvrD9/wXPN9pxPB1vdwn2+eYR04wMeSf5UMtQue/ILXUyA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:6c8a:0:b0:398:5208:220a with SMTP id
 h132-20020a636c8a000000b003985208220amr13391414pgc.176.1649378486405; Thu, 07
 Apr 2022 17:41:26 -0700 (PDT)
Date:   Thu,  7 Apr 2022 17:41:09 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 02/13] KVM: selftests: aarch64: Add vm_get_pte_gpa library function
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

Add a library function (in-guest) to get the GPA of the PTE of a
particular GVA.  This will be used in a future commit by a test to clear
and check the AF (access flag) of a particular page.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  2 ++
 .../selftests/kvm/lib/aarch64/processor.c     | 24 +++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 8f9f46979a00..caa572d83062 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -125,6 +125,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva);
+
 static inline void cpu_relax(void)
 {
 	asm volatile("yield" ::: "memory");
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9343d82519b4..ee006d354b79 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -139,7 +139,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep;
 
@@ -162,7 +162,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 			goto unmapped_gva;
 		/* fall through */
 	case 2:
-		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
+		ptep = (uint64_t *)(pte_addr(vm, *ptep) + pte_index(vm, gva) * 8);
 		if (!ptep)
 			goto unmapped_gva;
 		break;
@@ -170,6 +170,26 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 		TEST_FAIL("Page table levels must be 2, 3, or 4");
 	}
 
+	return (vm_paddr_t)ptep;
+
+unmapped_gva:
+	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
+	exit(1);
+}
+
+vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	uint64_t *ptep;
+	vm_paddr_t ptep_gpa;
+
+	ptep_gpa = vm_get_pte_gpa(vm, gva);
+	if (!ptep_gpa)
+		goto unmapped_gva;
+
+	ptep = addr_gpa2hva(vm, ptep_gpa);
+	if (!ptep)
+		goto unmapped_gva;
+
 	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 
 unmapped_gva:
-- 
2.35.1.1178.g4f1659d476-goog

