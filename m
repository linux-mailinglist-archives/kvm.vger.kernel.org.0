Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA9F444C81
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhKDAbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbhKDA30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:29:26 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBDDC06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:49 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j3-20020a628003000000b004811bc66186so2353706pfd.5
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cwptNtKIDGBxPZN/2DV/RXa3ZTx9EN7Ut32v7IxrbNY=;
        b=kp5W0d4ZKAqTQCeZRqX3O+a/DAfCjKvi3mu4Tg7fQ3jvfDHMY9wuQ5slcGHjKHrpuA
         O41kLcfJOvm1lVdKYW85uy2oNREGu2MSv7jrDheS1753o05M2Y57yo4STeIs65Q2EHGK
         B5up0zB0VZ6L8ytxDvtb0VGTD9hy1sbsnk0DAyC3cwRi4JiDc+TXwSManxsjb2qDyn2O
         OiXBUS1i7vJaF7j3il7TVpDWNEF8CLeaquv4Bhyqc0YSiiB0sbOWzXDrq3GuqvjBYdoT
         il3fanhD0s/lcfunhrA5jBW1o7Wn+UmL0jWWhjPVM5Fv3i3nvUx16q/ebHR7bCXwY+na
         ZUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cwptNtKIDGBxPZN/2DV/RXa3ZTx9EN7Ut32v7IxrbNY=;
        b=IRnZHRq1MqClT9GAfBVhLKS+8SvRtudrSouF1FWLY8jrklvRwrtUFeGF45WCvQ3egR
         Rj9tUjdwlo66ZgqHPX1+jX4kNnFxp7aOYF79TZed4gavtujhrKwDx6IqbgJGSeLCRq+/
         MaWqlxQS7/dD3UFGW3B33MDZIPZWDJvUCI66bu+EFvEN6FKgrJVfft7AynHNYMLQLFbn
         ws/E9RWcdDKRhCmGAst+2twbxXukAwkazsyeFj2HEPMnpG0ipKB8l7e0YLHS1urczEPQ
         O4IdfNg/GDK3cprCCaH7EEEz34zp6HKIvUDmMtQJGU8q2Aib4SwtrJCLNSaLlfSvLU0b
         DFhA==
X-Gm-Message-State: AOAM5305cnHj2fj+M3ClFtOeq6W8pw11m/JX7yZu55mBbvGjA8Q2T1LA
        S1DVcifnM90QB4nDIZ5GRUXsw4aLdrQ=
X-Google-Smtp-Source: ABdhPJwR0Cgz5rdM3APhtKmfNq/3RdcWCCfmBz9ZLpAOZgawdF+Lq6eMD3AhC92nfdAaylW7AAzDiY84qhk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1709:b0:481:203:d3bd with SMTP id
 h9-20020a056a00170900b004810203d3bdmr28140075pfc.58.1635985608753; Wed, 03
 Nov 2021 17:26:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:30 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-30-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 29/30] KVM: Wait 'til the bitter end to initialize the
 "new" memslot
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

Initialize the "new" memslot in the !DELETE path only after the various
sanity checks have passed.  This will allow a future commit to allocate
@new dynamically without having to copy a memslot, and without having to
deal with freeing @new in error paths and in the "nothing to change" path
that's hiding in the sanity checks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d22e40225703..5cc0b50faa8c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1838,6 +1838,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	struct kvm_memory_slot new;
 	struct kvm_memslots *slots;
 	enum kvm_mr_change change;
+	unsigned long npages;
+	gfn_t base_gfn;
 	int as_id, id;
 	int r;
 
@@ -1864,6 +1866,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		return -EINVAL;
+	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
+		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
 
@@ -1887,15 +1891,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		return kvm_set_memslot(kvm, old, &new, KVM_MR_DELETE);
 	}
 
-	new.as_id = as_id;
-	new.id = id;
-	new.base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
-	new.npages = mem->memory_size >> PAGE_SHIFT;
-	new.flags = mem->flags;
-	new.userspace_addr = mem->userspace_addr;
-
-	if (new.npages > KVM_MEM_MAX_NR_PAGES)
-		return -EINVAL;
+	base_gfn = (mem->guest_phys_addr >> PAGE_SHIFT);
+	npages = (mem->memory_size >> PAGE_SHIFT);
 
 	if (!old || !old->npages) {
 		change = KVM_MR_CREATE;
@@ -1904,27 +1901,33 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 * To simplify KVM internals, the total number of pages across
 		 * all memslots must fit in an unsigned long.
 		 */
-		if ((kvm->nr_memslot_pages + new.npages) < kvm->nr_memslot_pages)
+		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		if ((new.userspace_addr != old->userspace_addr) ||
-		    (new.npages != old->npages) ||
-		    ((new.flags ^ old->flags) & KVM_MEM_READONLY))
+		if ((mem->userspace_addr != old->userspace_addr) ||
+		    (npages != old->npages) ||
+		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
-		if (new.base_gfn != old->base_gfn)
+		if (base_gfn != old->base_gfn)
 			change = KVM_MR_MOVE;
-		else if (new.flags != old->flags)
+		else if (mem->flags != old->flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
 			return 0;
 	}
 
 	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
-	    kvm_check_memslot_overlap(slots, id, new.base_gfn,
-				      new.base_gfn + new.npages))
+	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
 		return -EEXIST;
 
+	new.as_id = as_id;
+	new.id = id;
+	new.base_gfn = base_gfn;
+	new.npages = npages;
+	new.flags = mem->flags;
+	new.userspace_addr = mem->userspace_addr;
+
 	return kvm_set_memslot(kvm, old, &new, change);
 }
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
-- 
2.33.1.1089.g2158813163f-goog

