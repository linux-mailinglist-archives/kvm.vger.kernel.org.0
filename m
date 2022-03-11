Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3094D5B4D
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 07:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346755AbiCKGFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 01:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347300AbiCKGDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 01:03:54 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337F01A948F
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:16 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 9-20020a630509000000b0037c8607d296so4231159pgf.22
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 22:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KUc4dNO91pxe/NV0PVPkfNxi+9BwbPEO+xnILPLfPtM=;
        b=OWem3wBwWHa+HaaS8WpKJBbzmMF72Cj+Df1b68H+hj8/jon+uQJrz08+ML/M0WqJJ1
         2SaXqEBuLt3uZBIMPZ0oE5QkFVVbwwoE5wJWFRLpvdSXEpKESmZfpezDhuxF621uKGuQ
         rXtV601E/AhPf4YgMyBH4LjaEO6M8oNTBbIxHiur5TT20l9pZwAqQYx9aGauBknmdeQq
         YEfCapjRrzso8wYmMZ1I6oyEAA9CcZnJkteqFu8mQovKsiXdj5L2RSUteZDo2izqb66Q
         V5k1eNjv9Qx7bUK3FxF2bkCWT5gRa8berXIo+1vqOzeVrc5glsskWiD5bAeSzJc3qTLE
         540A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KUc4dNO91pxe/NV0PVPkfNxi+9BwbPEO+xnILPLfPtM=;
        b=fZjEQ0ovDgh3aS3wGIF0iU+A+I7LuxBbgD0VA2lNWjAMu5Xg3zn6Wh+nNlYN3MkWhz
         /hCNqUIV0p8lnBSnReBt3zOmBMLeM07Ko8PnDGcLQNQS7h2Du5KrrlFIxi1l/gYM/NDV
         CPpwfW/ADxndhxmFNSBcogM00vPU7hnZk8WBKV+i34i8FL2InOso0eyctZxjMAyReOD0
         1Vkmxg9BMh0dcFquxp6kAxxfQRUVCdbzhfO/WmvYsXodWDNIZcOF454o83EBStVoEQ3c
         PZKQtv7yR1FRgMcH7/NSHC4etVJJ7jRwrEZlZArAqJ6OOy2lsT/80WHfCLFHRyBbDOJX
         /Pdg==
X-Gm-Message-State: AOAM533uBomD0J3vaOnjgHpTxbNOgQHs2u3w+14uvzE8Hq0/bnL3cJc+
        05AWnWo96ssGjxQxky4OgwuliUgv3wn83x1yXDy51EiiksheAhrS4DHRecMCmwyvKc69gfQ67hW
        wLHpjuXIvMyV9utCFyzFqzVJ6vzgf6moyprX5YOOHitvD3q71dwiJu4+PrFrPQ0s=
X-Google-Smtp-Source: ABdhPJzk4mG7szV7nhCSQP4wEbEtKHndkNBInkYogcawx/lZmIEZBQ8uLDfqKN6TKj4ltYzJ4pYt4Cq2WbHPmQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1248:b0:4f7:db0:4204 with SMTP
 id u8-20020a056a00124800b004f70db04204mr8469014pfi.27.1646978535585; Thu, 10
 Mar 2022 22:02:15 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:01:59 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 03/11] KVM: selftests: aarch64: Add vm_get_pte_gpa library function
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
2.35.1.723.g4982287a31-goog

