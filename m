Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393874D56A8
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345246AbiCKA12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244821AbiCKA10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:27:26 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8261A2724
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:26:15 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 67-20020a621446000000b004f739ef52f1so4207932pfu.0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=C/6kqtgpfTZHxI5VWOjwoNRlEkRWSpZD6XXLim3vJOQ=;
        b=Bs0Nt6VPOSGpoyrAZTXHtLQrqfTnnHH0UC9KK9A0vLWpFqtNCmQ76QkKCaoiU7vlME
         Q0bTazFlFcbJfqcpCjLO9tF13nAtANqrfJ4/weyLzjhfeuO+6qrSrtOmMS7TIYUEvmoj
         3jWCRL/2/6pXWfByCKv+9rhnbh7rbU0XaID/OlkGYUR1Z4dQD7f/Cw2G6GMi4iWL1Uec
         P+O9K7voxCptiW2ggUfO7UL3R6VkHHKXqZbW0O4DhLGBotN31nqItGDXOibW5YjGwp66
         nMmg3cEoPd8Q4NTBLdQxpNMCsJJ+tFv4B4qQ12ZQNrnMrYMMdODRkSRN3LkqTjAlbCWy
         wjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C/6kqtgpfTZHxI5VWOjwoNRlEkRWSpZD6XXLim3vJOQ=;
        b=bzYcTFUaGF/jxB2JKm9fsrrMRaRcvXpk+F/qG/kk9T4jRY1f3jtBFsIgagny7pRfzg
         Nh60c/SU4pgVCxHuVPvz10YS2WN3JL6pgXPL0xy/xyBxab6AiqvS9bNtcuPBglKFne1V
         G3ouLZC0alFMiY0N97q1S4NBOIyPWGtke+glKlhC6e6PtLw7ot+VfN29M56jF9oz7T3j
         qwJ0dLtac0xIOsFB/39jIrxaWDOpwvCEzXRDYCCMhr8ggIYEe2Rd33Z+VbT4mdb1meIE
         jYgIWvuJkplQQRyowyDpLuPIm/ya3hEYGfPJS1wmTsg7DC7lMq7f08ygpiLZZrsxvW1o
         QlnA==
X-Gm-Message-State: AOAM532CyXjKEvzL8sxcybFCEzbIKUoo7iKXfBD1OMzKG0kSjARxfB2q
        svggseYuEJhrBiwm9nv45WR6GTP+8wJhag==
X-Google-Smtp-Source: ABdhPJxWLEVXby9lk2SDFDSYjtNrAmaCeZHIJ0XIStrXC375fHHUc9G7571Y4uEmDYxZrmSHCBqVZt0xqwpthw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:12c8:b0:1bf:6484:3e27 with SMTP
 id b8-20020a17090a12c800b001bf64843e27mr7807022pjg.209.1646958375426; Thu, 10
 Mar 2022 16:26:15 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:28 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-27-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 26/26] KVM: selftests: Map x86_64 guest virtual memory with
 huge pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
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

Override virt_map() in x86_64 selftests to use the largest page size
possible when mapping guest virtual memory. This enables testing eager
page splitting with shadow paging (e.g. kvm_intel.ept=N), as it allows
KVM to shadow guest memory with huge pages.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  6 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  4 +--
 .../selftests/kvm/lib/x86_64/processor.c      | 31 +++++++++++++++++++
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 37db341d4cc5..efb228d2fbf7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -470,6 +470,12 @@ enum x86_page_size {
 	X86_PAGE_SIZE_2M,
 	X86_PAGE_SIZE_1G,
 };
+
+static inline size_t page_size_bytes(enum x86_page_size page_size)
+{
+	return 1UL << (page_size * 9 + 12);
+}
+
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		   enum x86_page_size page_size);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1665a220abcb..60198587236d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1432,8 +1432,8 @@ vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
  * Within the VM given by @vm, creates a virtual translation for
  * @npages starting at @vaddr to the page range starting at @paddr.
  */
-void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	      unsigned int npages)
+void __weak virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		     unsigned int npages)
 {
 	size_t page_size = vm->page_size;
 	size_t size = npages * page_size;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..7df84292d5de 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -282,6 +282,37 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
 }
 
+void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, unsigned int npages)
+{
+	size_t size = (size_t) npages * vm->page_size;
+	size_t vend = vaddr + size;
+	enum x86_page_size page_size;
+	size_t stride;
+
+	TEST_ASSERT(vaddr + size > vaddr, "Vaddr overflow");
+	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+
+	/*
+	 * Map the region with all 1G pages if possible, falling back to all
+	 * 2M pages, and finally all 4K pages. This could be improved to use
+	 * a mix of page sizes so that more of the region is mapped with large
+	 * pages.
+	 */
+	for (page_size = X86_PAGE_SIZE_1G; page_size >= X86_PAGE_SIZE_4K; page_size--) {
+		stride = page_size_bytes(page_size);
+
+		if (!(vaddr % stride) && !(paddr % stride) && !(size % stride))
+			break;
+	}
+
+	TEST_ASSERT(page_size >= X86_PAGE_SIZE_4K,
+		    "Cannot map unaligned region: vaddr 0x%lx paddr 0x%lx npages 0x%x\n",
+		    vaddr, paddr, npages);
+
+	for (; vaddr < vend; vaddr += stride, paddr += stride)
+		__virt_pg_map(vm, vaddr, paddr, page_size);
+}
+
 static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
 						       uint64_t vaddr)
 {
-- 
2.35.1.723.g4982287a31-goog

