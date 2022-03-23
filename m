Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EBC4E5B79
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241349AbiCWWzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiCWWzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:55:43 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB058CDA6
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:13 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p21-20020a631e55000000b00372d919267cso1352269pgm.1
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EX5EdkPTcMFobBvg2k2IPzfGAyJv+44CwzcOylMIfUM=;
        b=QXX9iZudZkXIo6wQ/ra4T2fPlG8qjoYt07mt2kngzjE9dhe3Dx9l52TRYkqJR7e4Qj
         9nYLZ/vLz8qnYf4o2ymu82DKVONyT2QxVh2wYgg2K+9+0UCEznlA3L8YwiqVaOjqJaTx
         pppzXBXWskc8koE/QRdI6XNRQAKzdRM83fntH+rkqvMdKJcjM3XzKalXNz8qdXTEJLsI
         ijjHKokSVH8e1aAAyGTH2VtZJdPKBIdzAezuHc8PgD9vNXTjNsbsMzlDKWIaSujE+Sh/
         WTx/gsX4vlG+zwOYii+USookdJYWIAipso6FweptVh1BF3XpHYsZ9iNhx5VFhoXX/TDW
         4zoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EX5EdkPTcMFobBvg2k2IPzfGAyJv+44CwzcOylMIfUM=;
        b=2IRy/cKgi7eBeQ5sGFtZUNyux1SKQerOHDbRJ4nQsj5BtKR8YfQeImJKyxDh5Lai16
         AFonV5jj9tBSNw8PEhwjxzMnkq5+DVtmDNB41Rrc4shGPmhAOJVC7u3mYIcncrPmXtdF
         hLJAjaolTwWMdLevxWkNg+DHElQI5n2ZrT/sRBRHiGD868xG2dk4vgRiKQOkw18emFnj
         ErzOaVtG9buYZPkXlgF/kznCSFiintZ3m+gzCtZNb6SChrwYnH6tx0YfysD1PYaDsUMd
         imGZV/lxaSmWElbfjuA+k8G1824iwmRY9XErL0J4SbMIFxwhL2xQWYsvB9Vh67RXwfaK
         wGuQ==
X-Gm-Message-State: AOAM530ry+UkGj02q/LaBaJp0DbsueN1/qj41w1QtXIYSevL82C1PsHk
        JYBG9/6F+6aHSKDTs6vowWgfeEE/jiXspRqww7NLNrT646rOZRuFNQxElw2UNAjmxda6mN72szX
        stmHg2aqe+tQH7w7GWb75A0nPpty5yHPnZah91XEOaAG9AseiTFS5HeCnuDYugSk=
X-Google-Smtp-Source: ABdhPJxlDAyrKty4WlvxYaFgWBnQWGbA8dG7nnwcr1i+I3TtdRt9Pt8GemhN9kPAWxAHCUPTszfC7fapjfAFuw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a65:524b:0:b0:383:1b87:2d21 with SMTP id
 q11-20020a65524b000000b003831b872d21mr1670543pgp.482.1648076052888; Wed, 23
 Mar 2022 15:54:12 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:53:56 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 02/11] KVM: selftests: aarch64: Add vm_get_pte_gpa library function
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
2.35.1.894.gb6a874cedc-goog

