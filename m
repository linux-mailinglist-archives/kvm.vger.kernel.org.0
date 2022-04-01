Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83A54EF963
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350801AbiDAR6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350837AbiDAR63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:29 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB5E1834D4
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:38 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t66-20020a625f45000000b004fabd8f5cc1so1999906pfb.11
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=whi7VXODCYStZwZ0yhJ9hj7iu8dCf643usT2exONxAs=;
        b=fuN0d8N9vFpmGZgcbUnIPl1/u50XpVyZVJS25Zl8sNb/QRw8cVTyJ5dMdqA5+b4+ZF
         uSZa76VjUdHU0qH1Va5a1zhK0stt4d5uFxMsf6ivJGXpSjoisa6ZlsqPiy1q//ZG6dgK
         E70U/wr8WlB5MVNjCZS6zluBKURb/ry6bmDWBkudFenFfsRDpzcJwK8g9cWgZalXPg39
         dhNKu56TjS2VbFJgtFxwT7wFpAedLoTQxO4/+9hOW6Wb4II8CrKPKuliva4BSCXXUE2Q
         8/Bl+aR/+ltV30PKrHQhHQgNsOJUQvLBay/8SjLanwL99lfTbrvVCd2W7FugWSH6scXf
         43Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=whi7VXODCYStZwZ0yhJ9hj7iu8dCf643usT2exONxAs=;
        b=ksBn5ggxmpvq/PZoATpPYsSWvJhHQ+pVTLQu9wE5a8EdI0GlIbG7SI5DeIqVRzu9P5
         V5qpYdZ7D4qJ5+EaG/ABJ2CUKoaRWW9S6FkzX2Lhacy8REKhAq71OaJKEffhhQfTdvp4
         EXjhjqe5+yNJVYD0Y4rw1uftyyaezjA/eKO7tEN018VytGD3yCczx9foSEwuEh18BE0J
         uBr70896V7PqAe3LElhJypV9NRBx0bapECt49BYfse7G3mTWO8j2yAoPR6YD5oVUcELL
         mZAvby9FBOgwnjPhZ0bMRRZbU6XJuNkkNzBr1pR7TQ9lqCEijCkbwlctlqAkM3QVj6bu
         p/fQ==
X-Gm-Message-State: AOAM532Euynkw5ayh9M6F5tpIhjcnwsN4DMoHascRv/nyJVJZBbtm+Fl
        R6e71IKqare4cerbdTDpwQagXmT2BnXsbw==
X-Google-Smtp-Source: ABdhPJzrOoFK0CXfNiBHYff/Ss14MY3SHaY29S4xt2lMgr9gQfCmCewctxWArdepbXNkov7vRSKMSJUb4tjYpQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1ca1:b0:4fa:7e80:6957 with SMTP
 id y33-20020a056a001ca100b004fa7e806957mr12069429pfw.33.1648835798210; Fri,
 01 Apr 2022 10:56:38 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:54 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-24-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 23/23] KVM: selftests: Map x86_64 guest virtual memory with
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
2.35.1.1094.g7c7d902a7c-goog

