Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167E7444C3A
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhKDAaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbhKDA2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:28:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA84C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:12 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b23-20020a170902d89700b001415444f5a6so1946637plz.7
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tLQvwVMFuRU1rudmVd+Ot8DGDwWCKV2XWE4z9OvxcSI=;
        b=aidjRg109rDQhcbEOaDvYUP/J6xeFiJXWQHPB/9inpIU47CGJj4EB+RwhcIG070Mie
         lVHTfvEeNG2Brzpgw8EZNdAVeUVZ4nNqCUo0Ix5XLJ0H18oJo/2rFOKMzl6fWLSJY191
         J6xXKGp+3siToXIqVebLKzjgDI+yAMnV78lg50hWKNPX/pVq2TrOflawSIczG+Lqobke
         Z0ZzafsHPcdo8PEDuhw/rn2m58dsopFaT3sRkFsFmilo83Ii5s7nnixu4BD3y0cdffxJ
         kzs8TJbXMv5IItYIkJSv/EhZBtHn1F5Yu5VOIhoRSGmVNkoq+MSSDwRM5budJwMaPSM5
         i1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tLQvwVMFuRU1rudmVd+Ot8DGDwWCKV2XWE4z9OvxcSI=;
        b=7WMqCBteGe0UQFRb/+j1YRbocmkv+Jf9+5IdLAXP2eVpmPvHFuFgQVIOxU035MhESw
         dZYwTzqRWFcz0ziEpXTzjBeZW9bKFSu+8vFXPXmNZJKSEI8TFoUiNczh9UhREjUEx8Lk
         E7Esi64mScbG379Y0UuPCN8uN0zbNXLQWDVcs8uu63v+qDbDaRIT7hhTyzdG3xNonFxk
         daFBB0j5rZGc+eLNbzKGXZkkUng8PE5r2vt/8PG9BuTiRtk1sPHttHs7EJh5rRbXvG0I
         wXYGnSLeJwDrvHKOllNi3EEnCK4INA+hTSZOkKCJDwR4hPUsUksttjQlr1dHDyaO8Ygb
         u6og==
X-Gm-Message-State: AOAM53376iGRwR8Io8gNKWmXIeq7J8/EWcMMNoHXo/sgtcCsnonlznzM
        3hwvY5B5FyrTdsBa+RyTKh7150hsm7Q=
X-Google-Smtp-Source: ABdhPJwCsMzZuRxv6iw0pTuYU4/wjVIfD1uNyeuH4Gna3eUrPsMPSwpB1c5wUSrPuzkGj84qqgXi63hO2s0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1484:b0:48c:2e58:8d39 with SMTP id
 v4-20020a056a00148400b0048c2e588d39mr11085289pfu.13.1635985571770; Wed, 03
 Nov 2021 17:26:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:09 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-9-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 08/30] KVM: arm64: Use "new" memslot instead of userspace
 memory region
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

Opportunistically wait to get the hva begin+end until after filtering out
the DELETE case in anticipation of a future commit passing NULL for @new
when deleting a memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cc41eadfbbf4..21213cba7c47 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1473,14 +1473,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 		/*
 		 * If we're with initial-all-set, we don't need to write
 		 * protect any pages because they're all reported as dirty.
 		 * Huge pages and normal pages will be write protect gradually.
 		 */
 		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, mem->slot);
+			kvm_mmu_wp_memory_region(kvm, new->id);
 		}
 	}
 }
@@ -1491,8 +1491,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	hva_t hva = mem->userspace_addr;
-	hva_t reg_end = hva + mem->memory_size;
+	hva_t hva, reg_end;
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -1506,6 +1505,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if ((new->base_gfn + new->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
+	hva = new->userspace_addr;
+	reg_end = hva + (new->npages << PAGE_SHIFT);
+
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-- 
2.33.1.1089.g2158813163f-goog

