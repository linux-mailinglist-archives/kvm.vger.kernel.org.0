Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3983444C51
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhKDAaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhKDA26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:28:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C30C06120A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:21 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a127-20020a627f85000000b0047feae4a8d9so2319631pfd.19
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Knv6NX4aNDEtvlXPSeSH4G0VJXSoyW8J2lqqVusFeB0=;
        b=WAj+5pKSlToue5x/Xjp3tHAY8zkyEMkATjMwSDKkSLNc+c15nQO/y3IMeoonW+8TGW
         IJ//NVTbf9iDd83CZGqogcbVBJFAwkAWutEaX8OHtmK98GraXTwQmiojDJlfjgAF0LlZ
         VKLj3H4JJK4O+dXU8VVJcJqNhuhyRpmQ/xKaWsc+4pgLXjw9U6El3bcpe+Md5lqvOckG
         VcaHEmfZpm2lQzXxITOF5vpCwMpKOib5Ate7AUJbu3BfwOJ4sMpJbFl+NTQugIzCKWHz
         Bu63CaoNp5DbWRkc48ITeWB0/vQjNJnW0r5KU3r+tAHLd4I7Sk2VhJyHE/A1d5epjjc8
         jySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Knv6NX4aNDEtvlXPSeSH4G0VJXSoyW8J2lqqVusFeB0=;
        b=kC/Ufo1YfIxizK48haCV38L3qPGwhM+oYde4ruhfxIKj6gV+dTu8TMQrTznaPg2dKF
         U/TmUdlouZoBaqvKjsmymy6GZlmLx/rrfJnBeiBZT1NNzDL/Im9BijMxZNRA49WXNJ5l
         tCBZXoP59MwdVUxZG5j3cNvokmatTpqMEN7eirAPLdbbETHrqki8wHFGU7LZRB/W8XcR
         GSQspaZcUS4eIALsi5ZCR8Up7L9NTPNLePQdHEikZOB9KikG52yFfk3YlSy3MDxQVWxJ
         rdGZHmrnsCwCxyjcLv0EBDHHlr/TvyD5YPD4z1O1FD6WHPvaqXFFNUjxXxin/NxbOIWB
         lwjA==
X-Gm-Message-State: AOAM530KogHRQHVOsHpi6YVEZtX2LGrqxRxxUSJNzM/6uSDT5JQl2oqJ
        ompI28fHT/O5LwFldqY3jma9jD9taSY=
X-Google-Smtp-Source: ABdhPJycWJt6vZswesjO49ykEcHeMjmquF3AfKfwc6UF1QVg1hQjUz6uw6WOUx1iNerGeq81ot/R29ZJDgQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr252380pjd.0.1635985580217; Wed, 03 Nov 2021 17:26:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:14 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-14-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 13/30] KVM: RISC-V: Use "new" memslot instead of
 userspace memory region
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get the slot ID, hva, etc... from the "new" memslot instead of the
userspace memory region when preparing/committing a memory region.  This
will allow a future commit to drop @mem from the prepare/commit hooks
once all architectures convert to using "new".

Opportunistically wait to get the various "new" values until after
filtering out the DELETE case in anticipation of a future commit passing
NULL for @new when deleting a memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 3a00c2df7640..db5230ec6951 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -466,18 +466,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * allocated dirty_bitmap[], dirty pages will be tracked while
 	 * the memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
-		stage2_wp_memory_region(kvm, mem->slot);
+	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES)
+		stage2_wp_memory_region(kvm, new->id);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem,
-				enum kvm_mr_change change)
+				   const struct kvm_userspace_memory_region *mem,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
+				   enum kvm_mr_change change)
 {
-	hva_t hva = mem->userspace_addr;
-	hva_t reg_end = hva + mem->memory_size;
-	bool writable = !(mem->flags & KVM_MEM_READONLY);
+	hva_t hva, reg_end, size;
+	gpa_t base_gpa;
+	bool writable;
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -488,10 +489,15 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * Prevent userspace from creating a memory region outside of the GPA
 	 * space addressable by the KVM guest GPA space.
 	 */
-	if ((memslot->base_gfn + memslot->npages) >=
-	    (stage2_gpa_size >> PAGE_SHIFT))
+	if ((new->base_gfn + new->npages) >= (stage2_gpa_size >> PAGE_SHIFT))
 		return -EFAULT;
 
+	hva = new->userspace_addr;
+	size = new->npages << PAGE_SHIFT;
+	reg_end = hva + size;
+	base_gpa = new->base_gfn << PAGE_SHIFT;
+	writable = !(new->flags & KVM_MEM_READONLY);
+
 	mmap_read_lock(current->mm);
 
 	/*
@@ -527,15 +533,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		vm_end = min(reg_end, vma->vm_end);
 
 		if (vma->vm_flags & VM_PFNMAP) {
-			gpa_t gpa = mem->guest_phys_addr +
-				    (vm_start - mem->userspace_addr);
+			gpa_t gpa = base_gpa + (vm_start - hva);
 			phys_addr_t pa;
 
 			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
 			pa += vm_start - vma->vm_start;
 
 			/* IO region dirty page logging not allowed */
-			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 				ret = -EINVAL;
 				goto out;
 			}
@@ -553,8 +558,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		stage2_unmap_range(kvm, mem->guest_phys_addr,
-				   mem->memory_size, false);
+		stage2_unmap_range(kvm, base_gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
 
 out:
-- 
2.33.1.1089.g2158813163f-goog

