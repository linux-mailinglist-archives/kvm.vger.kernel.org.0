Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2794A7D29
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348713AbiBCBBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348704AbiBCBBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:39 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DEBC06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:38 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o72-20020a17090a0a4e00b001b4e5b5b6c0so785540pjo.5
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kP0Hm9+AffHHY/1UdAipn0JE+3nNfhLxmoZeHFaZkJU=;
        b=gR6j3Ofw/NicTnv99Oi6LGqf5cf8CMgKZ1eRIInU7crAz8OFrKvq7Q5cRh+aYm86BN
         8aTO9+YKu1yPL2FRcV1q8kutU4NcQyJYilPA6VhNvu8VFfW7lW2n5PSxmn0FX7Bq1L9M
         TtUJZKLjoz/Gw1flC8hOdId7GOExeLKibk1oqxsbIyHMi7OXinbEoS/Z565/OVVX4kQA
         RX3x9KLa81B97L+BEnutq7y/SXN5HHrJWxpWhth4QNjyFnDk4a5zUTGFZaW/BPt+t+lZ
         Jw0Qa6dZ0PpWWYYk7t/ZpDm+LMG76DZSJOY7LWqqXPDfGnThULwA37SnKKsYR8P0fVN0
         bENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kP0Hm9+AffHHY/1UdAipn0JE+3nNfhLxmoZeHFaZkJU=;
        b=7WDkBpFc1OR9fT2zLf6knPKFJIEHud4QdTN0YOUnnvkU7n15PXmWFb12DILW5VWeL+
         CWx081xl8no7cfGm+wcXN6SJMTVDuZIpMMhI2KEiZuFRb/C/GkYjfuwqx98lnUxksGCr
         xBgxKZQlAa07wkP3BlbGj0SPi0eNg30EplrKc2G0WSiQLVB80MfnKSbruPjVMLfTGblb
         GU889YU+bgfsnLak/KXrLx4HT4elNoFtCFrWq0r9PIbFRzpqOqM5lfKtHlWJPTPNIC3M
         WA8+H1uTRzhLuQJFdjY9qRo/ig57dFwmAEqqZid5mONpRW9rtsb+iIx7aj7nzxtIua5+
         igOA==
X-Gm-Message-State: AOAM533YN2wHe+HsrIhUEmfq4rahbWdt5ngslHoTVjdEhcYBqsSSHqa1
        nYL8or9go8MwAg8h56ps8lUwXT2ivEaDLA==
X-Google-Smtp-Source: ABdhPJwkhnq+CDnvbVowYI8RemBupjY7lQI+1x0zr8ztW1F+4vQfp1jNo8twVWIYvR3k46Z0onZn8MnZL+hM1A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e844:: with SMTP id
 t4mr32917485plg.104.1643850098316; Wed, 02 Feb 2022 17:01:38 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:51 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-24-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 23/23] KVM: selftests: Map x86_64 guest virtual memory with
 huge pages
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
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
index 8a470da7b71a..0d6014b7eaf0 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -465,6 +465,12 @@ enum x86_page_size {
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
index d8cf851ab119..33c4a43bffcd 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1393,8 +1393,8 @@ vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
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
2.35.0.rc2.247.g8bbb082509-goog

