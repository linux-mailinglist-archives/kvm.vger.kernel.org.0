Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8692934D6
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404026AbgJTGVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403858AbgJTGTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:11 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C39C0613D7
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:10 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id l28so649746lfp.10
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AaYRj6xxvmS8+RSQnvAq9Jrn29IaqjqNuI5uDDknTs8=;
        b=Mx8Loju0ToSqHftzzoqfzPESbc1/N5hRz2KdNGw6KMMpjbYco5/VUfE0YsDuD/OBDB
         JpJ/p+fJo/oJLR6hyaQ81Ij7sV1JyaGGX4cvNalQc+/Smhjx6MWeJvV+7MmRii4qI9lr
         iLtnSPtkcNN9ChtzzeCEBk/GWIthMl995KtwZndE+McBnOElURh1YWLGLm9290oiKyzQ
         gs85KEQcShl9Na88mBkbryY9v93NrKHgz3fPWpqALkn/h2k8+gSjUvqBxaO5z39uQ/p4
         H2s7AwoLkEmDssTQesbwtQiJXlxCDVAw3vhvG35bXeapUXA2tBY8eSngavhDBqnymtbB
         Rmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AaYRj6xxvmS8+RSQnvAq9Jrn29IaqjqNuI5uDDknTs8=;
        b=MDog2T3QSKLzPpNDofyAF+f+LI79Ult5npsKE0aCRl60+WmmpPd0XJnY6B6zWGr9kT
         SVzb7VSjNkkbFJ8A8hX+alI1rK2AwXLo0yJz5XvYqOiDx3I/xtA/1uofQZQ3jHktoK4S
         7eWfClogOJEErB/YCi73G0SdNKaRHpbIgY93yCpEszE06dgG/qzdjYcD42vvVMtESQ4M
         p6UYuZlnW8plwb2GYHlmZaWBmOGDrGVvwZGWjFKJSLaf54CQfxpSOC9QcFgAvJmGK8WI
         IoBmfBVWjZ6EDw02C0K5An+kJwPvKee2F8fGUGZakQgr1DtuEqKEaaVYzVhc1KORN3Cs
         l6Ww==
X-Gm-Message-State: AOAM532q2hq/gnpz5+gPenr8GqgNdR+2OjQ5Jtg65AKkJJymIQl0is3G
        5hhj3bNDKoeJGY3hBKL6ZetVyI+HRJxAVw==
X-Google-Smtp-Source: ABdhPJzbVM30/ELO/VgPUbztIkJyCxcT3aLv3ozPYXAT3IE2iadH3MCBuaGjih+qQs0NlZhBazcvPQ==
X-Received: by 2002:a19:8988:: with SMTP id l130mr405110lfd.126.1603174748490;
        Mon, 19 Oct 2020 23:19:08 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id s17sm135242lfp.292.2020.10.19.23.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id EF98B102F67; Tue, 20 Oct 2020 09:19:01 +0300 (+03)
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
Subject: [RFCv2 08/16] KVM: Use GUP instead of copy_from/to_user() to access guest memory
Date:   Tue, 20 Oct 2020 09:18:51 +0300
Message-Id: <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
protection feature is enabled.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/kvm_host.h |  4 ++
 virt/kvm/kvm_main.c      | 90 +++++++++++++++++++++++++++++++---------
 2 files changed, 75 insertions(+), 19 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 05e3c2fb3ef7..380a64613880 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -504,6 +504,7 @@ struct kvm {
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
+	bool mem_protected;
 };
 
 #define kvm_err(fmt, ...) \
@@ -728,6 +729,9 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 void kvm_get_pfn(kvm_pfn_t pfn);
 
+int copy_from_guest(void *data, unsigned long hva, int len, bool protected);
+int copy_to_guest(unsigned long hva, const void *data, int len, bool protected);
+
 void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf88233b819a..a9884cb8c867 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2313,19 +2313,70 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+int copy_from_guest(void *data, unsigned long hva, int len, bool protected)
+{
+	int offset = offset_in_page(hva);
+	struct page *page;
+	int npages, seg;
+
+	if (!protected)
+		return __copy_from_user(data, (void __user *)hva, len);
+
+	might_fault();
+	kasan_check_write(data, len);
+	check_object_size(data, len, false);
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		npages = get_user_pages_unlocked(hva, 1, &page, 0);
+		if (npages != 1)
+			return -EFAULT;
+		memcpy(data, page_address(page) + offset, seg);
+		put_page(page);
+		len -= seg;
+		hva += seg;
+		offset = 0;
+	}
+
+	return 0;
+}
+
+int copy_to_guest(unsigned long hva, const void *data, int len, bool protected)
+{
+	int offset = offset_in_page(hva);
+	struct page *page;
+	int npages, seg;
+
+	if (!protected)
+		return __copy_to_user((void __user *)hva, data, len);
+
+	might_fault();
+	kasan_check_read(data, len);
+	check_object_size(data, len, true);
+
+	while ((seg = next_segment(len, offset)) != 0) {
+		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);
+		if (npages != 1)
+			return -EFAULT;
+		memcpy(page_address(page) + offset, data, seg);
+		put_page(page);
+		len -= seg;
+		hva += seg;
+		offset = 0;
+	}
+
+	return 0;
+}
+
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+				 void *data, int offset, int len,
+				 bool protected)
 {
-	int r;
 	unsigned long addr;
 
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_from_user(data, (void __user *)addr + offset, len);
-	if (r)
-		return -EFAULT;
-	return 0;
+	return copy_from_guest(data, addr + offset, len, protected);
 }
 
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
@@ -2333,7 +2384,8 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(slot, gfn, data, offset, len,
+				     kvm->mem_protected);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -2342,7 +2394,8 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(slot, gfn, data, offset, len,
+				     vcpu->kvm->mem_protected);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -2415,7 +2468,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
 static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+			          const void *data, int offset, int len,
+				  bool protected)
 {
 	int r;
 	unsigned long addr;
@@ -2423,7 +2477,8 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
 	addr = gfn_to_hva_memslot(memslot, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_to_user((void __user *)addr + offset, data, len);
+
+	r = copy_to_guest(addr + offset, data, len, protected);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(memslot, gfn);
@@ -2435,7 +2490,8 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(slot, gfn, data, offset, len,
+				      kvm->mem_protected);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
 
@@ -2444,7 +2500,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_write_guest_page(slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(slot, gfn, data, offset, len,
+				      vcpu->kvm->mem_protected);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
@@ -2560,7 +2617,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (unlikely(!ghc->memslot))
 		return kvm_write_guest(kvm, gpa, data, len);
 
-	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
+	r = copy_to_guest(ghc->hva + offset, data, len, kvm->mem_protected);
 	if (r)
 		return -EFAULT;
 	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
@@ -2581,7 +2638,6 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 				 unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
-	int r;
 	gpa_t gpa = ghc->gpa + offset;
 
 	BUG_ON(len + offset > ghc->len);
@@ -2597,11 +2653,7 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (unlikely(!ghc->memslot))
 		return kvm_read_guest(kvm, gpa, data, len);
 
-	r = __copy_from_user(data, (void __user *)ghc->hva + offset, len);
-	if (r)
-		return -EFAULT;
-
-	return 0;
+	return copy_from_guest(data, ghc->hva + offset, len, kvm->mem_protected);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_offset_cached);
 
-- 
2.26.2

