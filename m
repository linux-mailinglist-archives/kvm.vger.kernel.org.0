Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9AF2934C5
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403927AbgJTGTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403882AbgJTGTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:13 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C3CC0613CE
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a5so726021ljj.11
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X/AtwUDIUn48g4k1JMQhi4QAxxtPsV8WteLTDiTNmxc=;
        b=JfPp6qCGASr2dJ2fakpZJ/fzyDk1AscK0upX+1EvAoNCwUAfXJF8hJQyqg47MXmTLI
         T8Bg/HjhcMQZHi55Rl+ufcciPWjUvblzpko+Rjfud93AxnRaQg10hKd8ARqA1lAqpH//
         CAVrCc+7zyCPKlh66MIXjilJ1s7TiQtVYTLo/QW1tJViUVbs0PFIek2K7Rxy7msVGuK+
         rQACyCccbOocxMOBdKfA6lN9pQ55v8htkn4mvsOWjnqR3oTuLlVGCYSpuVoupFl2H4AT
         Ju6OrlpGe4i4iyn9riSOObFDEFqaJwBsnfDbVl2JqlCW2a8bRSnJInGi2L8qL+VMQDV/
         BLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X/AtwUDIUn48g4k1JMQhi4QAxxtPsV8WteLTDiTNmxc=;
        b=ANOcU0IQF3t4J90y9rRfOnghLyHQxrNqjMORAtzfy0AHWTiYQyhUXGX/Uwbcy/1JPq
         G1IR6Ddeflbu9vLDMV2KRKNlLW612CHjfs4tUVqKJPAquPVGtp1TK+SR1ZgIaUY7YVCQ
         uri0MV9s9b3bN1/Am9EPMAC4PS/YnBXyhIgLqjarxjOcj0ZY6ncWVE3/wGNPZcuF4fy8
         nE2fMWk7lazkMpaeAwn6kmEmdPz7ygbWOhvcNQTFW/5DxCu8aa8V5pZuE/ZpyuMBvI5m
         Vb7pNteX6FxDNMuai81IoHL7wJwo1xrq0AfUW74oDOQPg1BphG/1ImwQY8D+3NxUKNZQ
         93sA==
X-Gm-Message-State: AOAM530l6amMB57UoBr6rwNQqAIBNm6gkBVAb4C4JkuF0exxCcBsaPnC
        SODJnZQez/UWMzaAT/JG+x7iCA==
X-Google-Smtp-Source: ABdhPJzddsHVqR9gNuwpBey6U9atB+OQkWz90dQzJ+5gTf2tHZ47zm/83ZQZQoIfsUI3D9HQtWFezQ==
X-Received: by 2002:a2e:9183:: with SMTP id f3mr451109ljg.343.1603174751286;
        Mon, 19 Oct 2020 23:19:11 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id b15sm197222ljp.117.2020.10.19.23.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 136DB102F6A; Tue, 20 Oct 2020 09:19:02 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 11/16] KVM: Protected memory extension
Date:   Tue, 20 Oct 2020 09:18:54 +0300
Message-Id: <20201020061859.18385-12-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add infrastructure that handles protected memory extension.

Arch-specific code has to provide hypercalls and define non-zero
VM_KVM_PROTECTED.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/kvm_host.h |  4 +++
 virt/kvm/Kconfig         |  3 ++
 virt/kvm/kvm_main.c      | 68 ++++++++++++++++++++++++++++++++++++++
 virt/lib/Makefile        |  1 +
 virt/lib/mem_protected.c | 71 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 147 insertions(+)
 create mode 100644 virt/lib/mem_protected.c

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 380a64613880..6655e8da4555 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -701,6 +701,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
 
+int kvm_protect_all_memory(struct kvm *kvm);
+int kvm_protect_memory(struct kvm *kvm,
+		       unsigned long gfn, unsigned long npages, bool protect);
+
 int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 			    struct page **pages, int nr_pages);
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 1c37ccd5d402..50d7422386aa 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -63,3 +63,6 @@ config HAVE_KVM_NO_POLL
 
 config KVM_XFER_TO_GUEST_WORK
        bool
+
+config HAVE_KVM_PROTECTED_MEMORY
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 125db5a73e10..4c008c7b4974 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -154,6 +154,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+int __kvm_protect_memory(unsigned long start, unsigned long end, bool protect);
+
 __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 						   unsigned long start, unsigned long end)
 {
@@ -1371,6 +1373,15 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (r)
 		goto out_bitmap;
 
+	if (IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) &&
+	    mem->memory_size && kvm->mem_protected) {
+		r = __kvm_protect_memory(new.userspace_addr,
+					 new.userspace_addr + new.npages * PAGE_SIZE,
+					 true);
+		if (r)
+			goto out_bitmap;
+	}
+
 	if (old.dirty_bitmap && !new.dirty_bitmap)
 		kvm_destroy_dirty_bitmap(&old);
 	return 0;
@@ -2720,6 +2731,63 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
+int kvm_protect_memory(struct kvm *kvm,
+		       unsigned long gfn, unsigned long npages, bool protect)
+{
+	struct kvm_memory_slot *memslot;
+	unsigned long start, end;
+	gfn_t numpages;
+
+	if (!IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY))
+		return -KVM_ENOSYS;
+
+	if (!npages)
+		return 0;
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	/* Not backed by memory. It's okay. */
+	if (!memslot)
+		return 0;
+
+	start = gfn_to_hva_many(memslot, gfn, &numpages);
+	end = start + npages * PAGE_SIZE;
+
+	/* XXX: Share range across memory slots? */
+	if (WARN_ON(numpages < npages))
+		return -EINVAL;
+
+	return __kvm_protect_memory(start, end, protect);
+}
+EXPORT_SYMBOL_GPL(kvm_protect_memory);
+
+int kvm_protect_all_memory(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	unsigned long start, end;
+	int i, ret = 0;;
+
+	if (!IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY))
+		return -KVM_ENOSYS;
+
+	mutex_lock(&kvm->slots_lock);
+	kvm->mem_protected = true;
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			start = memslot->userspace_addr;
+			end = start + memslot->npages * PAGE_SIZE;
+			ret = __kvm_protect_memory(start, end, true);
+			if (ret)
+				goto out;
+		}
+	}
+out:
+	mutex_unlock(&kvm->slots_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_protect_all_memory);
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->sigset_active)
diff --git a/virt/lib/Makefile b/virt/lib/Makefile
index bd7f9a78bb6b..d6e50510801f 100644
--- a/virt/lib/Makefile
+++ b/virt/lib/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_IRQ_BYPASS_MANAGER) += irqbypass.o
+obj-$(CONFIG_HAVE_KVM_PROTECTED_MEMORY) += mem_protected.o
diff --git a/virt/lib/mem_protected.c b/virt/lib/mem_protected.c
new file mode 100644
index 000000000000..0b01dd74f29c
--- /dev/null
+++ b/virt/lib/mem_protected.c
@@ -0,0 +1,71 @@
+#include <linux/kvm_host.h>
+#include <linux/mm.h>
+#include <linux/pagewalk.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <asm/tlbflush.h>
+
+int __kvm_protect_memory(unsigned long start, unsigned long end, bool protect)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
+	int ret;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
+	ret = -ENOMEM;
+	vma = find_vma(current->mm, start);
+	if (!vma)
+		goto out;
+
+	ret = -EINVAL;
+	if (vma->vm_start > start)
+		goto out;
+
+	if (start > vma->vm_start)
+		prev = vma;
+	else
+		prev = vma->vm_prev;
+
+	ret = 0;
+	while (true) {
+		unsigned long newflags, tmp;
+
+		tmp = vma->vm_end;
+		if (tmp > end)
+			tmp = end;
+
+		newflags = vma->vm_flags;
+		if (protect)
+			newflags |= VM_KVM_PROTECTED;
+		else
+			newflags &= ~VM_KVM_PROTECTED;
+
+		/* The VMA has been handled as part of other memslot */
+		if (newflags == vma->vm_flags)
+			goto next;
+
+		ret = mprotect_fixup(vma, &prev, start, tmp, newflags);
+		if (ret)
+			goto out;
+
+next:
+		start = tmp;
+		if (start < prev->vm_end)
+			start = prev->vm_end;
+
+		if (start >= end)
+			goto out;
+
+		vma = prev->vm_next;
+		if (!vma || vma->vm_start != start) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+out:
+	mmap_write_unlock(mm);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__kvm_protect_memory);
-- 
2.26.2

