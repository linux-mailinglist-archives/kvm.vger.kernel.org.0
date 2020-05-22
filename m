Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38761DE74D
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgEVMxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbgEVMwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:24 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268B7C08C5CA
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:24 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id w15so6418472lfe.11
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j2/vuMi890bpJ5y0t7xywOAn8150Dzh7/cc8lYIsDKY=;
        b=uMPxr4NVfF3vE1qVqq7sYsFj93VH+Y34ADY3/+IJkn11M5r/WatHHUjnukprdosb1T
         yo55gN9SX8HuBKmD+23WnyRvesSBKuSXQVtISqJ7086/9z6VeO2Xww8Ar+v85g91tiJt
         W0C/h2VXuOHKVnZNbOcSQkmhe8wicTwNh8SySiF7S62NpX2whckYamOo0Y5tYn0NNACH
         lbYF8qvggQ3Hq+I2RP22XsY014kHkea5U1sutNdpE0tb9CGfLQtUaz+qUWdf4lxp/yZZ
         EVwfQUaqG5nxl49hfwRyoY83XXfPpb3nZL1+IYFkOn7WLdUmDIZ44pLogc8bXKvC0BG/
         sDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j2/vuMi890bpJ5y0t7xywOAn8150Dzh7/cc8lYIsDKY=;
        b=eO0ePm30JhrOI+/neREllZR3lHyU/hOZXNYv0qlXDkmHg+jgC+YtZiZXHh0WDnyxtV
         6yRxLwEdZZ3lks4iy3DG5tP/uF2v3Ls/chy0AskdvCfqN4VpNFo7HynZG4N9LbaseOib
         lBSUes/pwCE+6WwnVw5AW8/se+xgNmfu7YVuoBF9xSqJqa7KygWtSza256Ol0uxuwjCJ
         Sp0AFsTmQhlNHs9Y6aoumsvi6bhxW+xmXA2hr5SriCTp08R5kUa23ziZpSEFW/3OgBFN
         l0gtKASNb8325AvcaWN+0FMu3GseA9UkgNzogBvDo2W4GkIZwx+9l/r3vnTJgWeEzLuA
         /bvQ==
X-Gm-Message-State: AOAM532nFIVtTQWMdK7jsvwyQE4DIV0M985fQDOFNwFSuhG6bRMLQW7R
        vVW19D8T0CGYt3nDgVP0Es6GTw==
X-Google-Smtp-Source: ABdhPJwQqkBG5wVjIjX0BwokaMhLdwCURG8El+OhoC+P0UogOvR1pNP5w8yY/1CvTRn+oqftAvC5tA==
X-Received: by 2002:a19:c64c:: with SMTP id w73mr7336911lff.67.1590151942584;
        Fri, 22 May 2020 05:52:22 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id i11sm2644335ljg.9.2020.05.22.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:21 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id E0440102057; Fri, 22 May 2020 15:52:19 +0300 (+03)
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
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 09/16] KVM: Protected memory extension
Date:   Fri, 22 May 2020 15:52:07 +0300
Message-Id: <20200522125214.31348-10-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add infrastructure that handles protected memory extension.

Arch-specific code has to provide hypercalls and define non-zero
VM_KVM_PROTECTED.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/kvm_host.h |   4 ++
 mm/mprotect.c            |   1 +
 virt/kvm/kvm_main.c      | 131 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bd0bb600f610..d7072f6d6aa0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -700,6 +700,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm);
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot);
 
+int kvm_protect_all_memory(struct kvm *kvm);
+int kvm_protect_memory(struct kvm *kvm,
+		       unsigned long gfn, unsigned long npages, bool protect);
+
 int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 			    struct page **pages, int nr_pages);
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 494192ca954b..552be3b4c80a 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -505,6 +505,7 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	vm_unacct_memory(charged);
 	return error;
 }
+EXPORT_SYMBOL_GPL(mprotect_fixup);
 
 /*
  * pkey==-1 when doing a legacy mprotect()
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 530af95efdf3..07d45da5d2aa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -155,6 +155,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+static int protect_memory(unsigned long start, unsigned long end, bool protect);
+
 __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		unsigned long start, unsigned long end, bool blockable)
 {
@@ -1309,6 +1311,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (r)
 		goto out_bitmap;
 
+	if (mem->memory_size && kvm->mem_protected) {
+		r = protect_memory(new.userspace_addr,
+				   new.userspace_addr + new.npages * PAGE_SIZE,
+				   true);
+		if (r)
+			goto out_bitmap;
+	}
+
 	if (old.dirty_bitmap && !new.dirty_bitmap)
 		kvm_destroy_dirty_bitmap(&old);
 	return 0;
@@ -2652,6 +2662,127 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
 
+static int protect_memory(unsigned long start, unsigned long end, bool protect)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
+	int ret;
+
+	if (down_write_killable(&mm->mmap_sem))
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
+	up_write(&mm->mmap_sem);
+	return ret;
+}
+
+int kvm_protect_memory(struct kvm *kvm,
+		       unsigned long gfn, unsigned long npages, bool protect)
+{
+	struct kvm_memory_slot *memslot;
+	unsigned long start, end;
+	gfn_t numpages;
+
+	if (!VM_KVM_PROTECTED)
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
+	return protect_memory(start, end, protect);
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
+	if (!VM_KVM_PROTECTED)
+		return -KVM_ENOSYS;
+
+	mutex_lock(&kvm->slots_lock);
+	kvm->mem_protected = true;
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(memslot, slots) {
+			start = memslot->userspace_addr;
+			end = start + memslot->npages * PAGE_SIZE;
+			ret = protect_memory(start, end, true);
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
-- 
2.26.2

