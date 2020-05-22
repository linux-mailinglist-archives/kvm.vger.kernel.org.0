Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EE71DE748
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgEVMxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbgEVMw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:26 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E41FC05BD43
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:25 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c21so6458698lfb.3
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xSlGXwZufpWJ/6PcI9wa5h49Q8Cff6k8tuJGZLYF0wg=;
        b=lp2cPjep8pO3ef7efxdX23yH12G8mY0S4LTqFaOt/6xv78Aem/EuLlfjxwRSjMbbX6
         c/dhpm9jzQrXTaRqmuhQnVhYJ57/t1GipR/F3oPpH3D9CpdHSxRqWtAWWfxqBHwcX35q
         N/mtjNJ0ytEFesRnXoV+7dcOCh8RsSxoqPlYhBDXhNelnTH6s4nT8zWyM/ICFQNSBqOB
         wpqX8Yb6D2a4QNiHpDYDllg292XKYpO5BULq04WYMN60SYONE1D1z/40f5Ghu0nEf2eD
         cY62ID2aNCkj5MbDfWn54C9PukEjzMouBZ+xToc5f1RZETPmdrUqEoHRwkg9Cd6Z6A7V
         SOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xSlGXwZufpWJ/6PcI9wa5h49Q8Cff6k8tuJGZLYF0wg=;
        b=F0aV6krdrFlqXTXjCW7YhSZYw8m6BK3HC2MnNLa3F22wjtGdXFPpobzfFpZ+efbp0+
         iRFeQpJxhQwAuPNq6e47CIg7NHGEckzU9io1m/dRlfacSeWF5fpbzBiEVoFmm2OdTQIp
         98AZLsvYMaPY8sCikURrE6yjOTEJpibuJgOP1bIK9tS6mwB9QMmIiSRfUhIGQ1R+xmwJ
         x6oc0YLMYzXzRsW5fo8aSKxTPcdtgeJxJ6a7kYNZfY6t7n3tNYzBfuopiYrdZ58MUdhe
         xlu+pK+QTnD7bHSuDJHPKl7lcfrIAYbxgYGbPnvGwBKBMqK+yjmUHDDmXMNFrQn7h4PE
         uq/Q==
X-Gm-Message-State: AOAM5322AgxY0UbgrtK0DCfmsQEHFlCk9b2y1w4KCJsUvNCwoNwSg+/S
        qylpYoz3T9ASCAvIX09d5wXzhw==
X-Google-Smtp-Source: ABdhPJz0KS216ZdFcrTTxidcO5MGn8K/8zWzWL1hNqwpMUy/NI3epk39K070+VkyxSdfYpnbmRHWxQ==
X-Received: by 2002:a05:6512:14c:: with SMTP id m12mr7492997lfo.165.1590151944083;
        Fri, 22 May 2020 05:52:24 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id h8sm1020840ljg.28.2020.05.22.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id EF8CA102059; Fri, 22 May 2020 15:52:19 +0300 (+03)
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
Subject: [RFC 11/16] KVM: Rework copy_to/from_guest() to avoid direct mapping
Date:   Fri, 22 May 2020 15:52:09 +0300
Message-Id: <20200522125214.31348-12-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are going unmap guest pages from direct mapping and cannot rely on it
for guest memory access. Use temporary kmap_atomic()-style mapping to
access guest memory.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 virt/kvm/kvm_main.c | 57 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 07d45da5d2aa..63282def3760 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2258,17 +2258,45 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+static pte_t **guest_map_ptes;
+static struct vm_struct *guest_map_area;
+
+static void *map_page_atomic(struct page *page)
+{
+	pte_t *pte;
+	void *vaddr;
+
+	preempt_disable();
+	pte = guest_map_ptes[smp_processor_id()];
+	vaddr = guest_map_area->addr + smp_processor_id() * PAGE_SIZE;
+	set_pte(pte, mk_pte(page, PAGE_KERNEL));
+	return vaddr;
+}
+
+static void unmap_page_atomic(void *vaddr)
+{
+	pte_t *pte = guest_map_ptes[smp_processor_id()];
+	set_pte(pte, __pte(0));
+	__flush_tlb_one_kernel((unsigned long)vaddr);
+	preempt_enable();
+}
+
 int copy_from_guest(void *data, unsigned long hva, int len)
 {
 	int offset = offset_in_page(hva);
 	struct page *page;
 	int npages, seg;
+	void *vaddr;
 
 	while ((seg = next_segment(len, offset)) != 0) {
 		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_KVM);
 		if (npages != 1)
 			return -EFAULT;
-		memcpy(data, page_address(page) + offset, seg);
+
+		vaddr = map_page_atomic(page);
+		memcpy(data, vaddr + offset, seg);
+		unmap_page_atomic(vaddr);
+
 		put_page(page);
 		len -= seg;
 		hva += seg;
@@ -2283,13 +2311,18 @@ int copy_to_guest(unsigned long hva, const void *data, int len)
 	int offset = offset_in_page(hva);
 	struct page *page;
 	int npages, seg;
+	void *vaddr;
 
 	while ((seg = next_segment(len, offset)) != 0) {
 		npages = get_user_pages_unlocked(hva, 1, &page,
 						 FOLL_WRITE | FOLL_KVM);
 		if (npages != 1)
 			return -EFAULT;
-		memcpy(page_address(page) + offset, data, seg);
+
+		vaddr = map_page_atomic(page);
+		memcpy(vaddr + offset, data, seg);
+		unmap_page_atomic(vaddr);
+
 		put_page(page);
 		len -= seg;
 		hva += seg;
@@ -4921,6 +4954,18 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		goto out_free;
 
+	if (VM_KVM_PROTECTED) {
+		guest_map_ptes = kmalloc_array(num_possible_cpus(),
+					       sizeof(pte_t *), GFP_KERNEL);
+		if (!guest_map_ptes)
+			goto out_unreg;
+
+		guest_map_area = alloc_vm_area(PAGE_SIZE * num_possible_cpus(),
+					       guest_map_ptes);
+		if (!guest_map_ptes)
+			goto out_unreg;
+	}
+
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
@@ -4944,6 +4989,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	return 0;
 
 out_unreg:
+	if (guest_map_area)
+		free_vm_area(guest_map_area);
+	if (guest_map_ptes)
+		kfree(guest_map_ptes);
 	kvm_async_pf_deinit();
 out_free:
 	kmem_cache_destroy(kvm_vcpu_cache);
@@ -4965,6 +5014,10 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
+	if (guest_map_area)
+		free_vm_area(guest_map_area);
+	if (guest_map_ptes)
+		kfree(guest_map_ptes);
 	debugfs_remove_recursive(kvm_debugfs_dir);
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
-- 
2.26.2

