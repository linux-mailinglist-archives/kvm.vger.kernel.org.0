Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268D1556DDE
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 23:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiFVVhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 17:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiFVVhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 17:37:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEB5735AA8
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 14:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655933828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhppIX6vNX1hZt/miaFbnfjIfVwbxcf3RlezEUIw2Gs=;
        b=H+KYQO5T999+7XafPgn3PFTaJbBlMrcFBkd4WO35rSoVcB2TNYuzDhQZN9WAGPy2NJm7fE
        n7wyEFr19fmJQ/rg73aTqoHVh3g6l89oP4QlZrzem1Ns9TBDt6SqfaXmcrQLR8mEa0vLTL
        eR5c4Nr9JLmWViyrlo7hxMRd6a6bAzE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-Lf3JDPBmO9m-ml0OkVpc0Q-1; Wed, 22 Jun 2022 17:37:07 -0400
X-MC-Unique: Lf3JDPBmO9m-ml0OkVpc0Q-1
Received: by mail-il1-f198.google.com with SMTP id k8-20020a056e02156800b002d91998aef7so5374065ilu.0
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 14:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vhppIX6vNX1hZt/miaFbnfjIfVwbxcf3RlezEUIw2Gs=;
        b=SpKrWtfy9gYgJkl/iJMWhNkRk4BXw8gJIJQHQSUD1aRn7gYFQmfVgsG0O9XLR0vzO5
         vFWbHiYOWwMUlZberIZr89WPRJmLyd9KOXBgVRaSb5u3OPHDMJ5lE2nOZuzFQd17vEPG
         DQU59zv1QZpQpouN4swkwcJMLcHde8lhPMuuS4d+ojpcAS2zvyoaEHYc1a97gDhstM+5
         QtQmIlctcq8x0RKcJuKFJpfkVL11l4WLd3Lsha07zS19LiTs2xQCSbKysSvOF94n+n+r
         evz7rgXSddvCuPiX8vRwkFZ1M9sycnONszyWwjnll8sAmkcruFUfDeIcdTePO7zx1SHw
         lZTg==
X-Gm-Message-State: AJIora+ld22Mnl41L4M87ZT7Ae6HSpKkwprinnUGDL3xWmVZJn5f2L+n
        cgao9z/cplQB4X2ApSuSIrccm3gN5ZgXKBVtphs8uumdENSbl8Ebltowv0Hz3GwESx8gSbUdC6d
        Svs8GJDJj6J67OZvJ1qUbgb/17QP5dN7QFZP1O+pDiF1XCrgAsU533FXQ8AAfSg==
X-Received: by 2002:a05:6e02:1a28:b0:2d8:e770:d43f with SMTP id g8-20020a056e021a2800b002d8e770d43fmr3278543ile.137.1655933825873;
        Wed, 22 Jun 2022 14:37:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uJcMRkwsDNKTMq4mKtUplbgjsXpC8ptulSt8S8Q5/HCNbhHNMkLxzTCVOW888ONQuKUYm7dA==
X-Received: by 2002:a05:6e02:1a28:b0:2d8:e770:d43f with SMTP id g8-20020a056e021a2800b002d8e770d43fmr3278518ile.137.1655933825523;
        Wed, 22 Jun 2022 14:37:05 -0700 (PDT)
Received: from localhost.localdomain (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id g7-20020a0566380c4700b00339d892cc89sm1510446jal.83.2022.06.22.14.37.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jun 2022 14:37:04 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 2/4] kvm: Merge "atomic" and "write" in __gfn_to_pfn_memslot()
Date:   Wed, 22 Jun 2022 17:36:54 -0400
Message-Id: <20220622213656.81546-3-peterx@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220622213656.81546-1-peterx@redhat.com>
References: <20220622213656.81546-1-peterx@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Merge two boolean parameters into a bitmask flag called kvm_gtp_flag_t for
__gfn_to_pfn_memslot().  This cleans the parameter lists, and also prepare
for new boolean to be added to __gfn_to_pfn_memslot().

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/arm64/kvm/mmu.c                   |  5 ++--
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  5 ++--
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  5 ++--
 arch/x86/kvm/mmu/mmu.c                 | 10 +++----
 include/linux/kvm_host.h               |  9 ++++++-
 virt/kvm/kvm_main.c                    | 37 +++++++++++++++-----------
 virt/kvm/kvm_mm.h                      |  6 +++--
 virt/kvm/pfncache.c                    |  2 +-
 8 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5651a05b6a8..ce1edb512b4e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1204,8 +1204,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable, NULL);
+	pfn = __gfn_to_pfn_memslot(memslot, gfn,
+				   write_fault ? KVM_GTP_WRITE : 0,
+				   NULL, &writable, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 514fd45c1994..e2769d58dd87 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -598,8 +598,9 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 		write_ok = true;
 	} else {
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok, NULL);
+		pfn = __gfn_to_pfn_memslot(memslot, gfn,
+					   writing ? KVM_GTP_WRITE : 0,
+					   NULL, &write_ok, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 42851c32ff3b..232b17c75b83 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -845,8 +845,9 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 		unsigned long pfn;
 
 		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, upgrade_p, NULL);
+		pfn = __gfn_to_pfn_memslot(memslot, gfn,
+					   writing ? KVM_GTP_WRITE : 0,
+					   NULL, upgrade_p, NULL);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4653688fa6d..e92f1ab63d6a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3968,6 +3968,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 
 static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	kvm_gtp_flag_t flags = fault->write ? KVM_GTP_WRITE : 0;
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
 
@@ -3999,8 +4000,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	}
 
 	async = false;
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
-					  fault->write, &fault->map_writable,
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags,
+					  &async, &fault->map_writable,
 					  &fault->hva);
 	if (!async)
 		return RET_PF_CONTINUE; /* *pfn has correct page already */
@@ -4016,9 +4017,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
-	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
-					  fault->write, &fault->map_writable,
-					  &fault->hva);
+	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, flags, NULL,
+					  &fault->map_writable, &fault->hva);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c20f2d55840c..b646b6fcaec6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1146,8 +1146,15 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
+
+/* gfn_to_pfn (gtp) flags */
+typedef unsigned int __bitwise kvm_gtp_flag_t;
+
+#define  KVM_GTP_WRITE          ((__force kvm_gtp_flag_t) BIT(0))
+#define  KVM_GTP_ATOMIC         ((__force kvm_gtp_flag_t) BIT(1))
+
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool *async, bool write_fault,
+			       kvm_gtp_flag_t gtp_flags, bool *async,
 			       bool *writable, hva_t *hva);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 64ec2222a196..952400b42ee9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2444,9 +2444,11 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
  * The slow path to get the pfn of the specified host virtual address,
  * 1 indicates success, -errno is returned if error is detected.
  */
-static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
+static int hva_to_pfn_slow(unsigned long addr, bool *async,
+			   kvm_gtp_flag_t gtp_flags,
 			   bool *writable, kvm_pfn_t *pfn)
 {
+	bool write_fault = gtp_flags & KVM_GTP_WRITE;
 	unsigned int flags = FOLL_HWPOISON;
 	struct page *page;
 	int npages = 0;
@@ -2565,20 +2567,22 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function can sleep
+ * @gtp_flags: kvm_gtp_flag_t flags (atomic, write, ..)
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
- * @write_fault: whether we should get a writable host page
  * @writable: whether it allows to map a writable host page for !@write_fault
  *
- * The function will map a writable host page for these two cases:
+ * The function will map a writable (KVM_GTP_WRITE set) host page for these
+ * two cases:
  * 1): @write_fault = true
  * 2): @write_fault = false && @writable, @writable will tell the caller
  *     whether the mapping is writable.
  */
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-		     bool write_fault, bool *writable)
+kvm_pfn_t hva_to_pfn(unsigned long addr, kvm_gtp_flag_t gtp_flags, bool *async,
+		     bool *writable)
 {
+	bool write_fault = gtp_flags & KVM_GTP_WRITE;
+	bool atomic = gtp_flags & KVM_GTP_ATOMIC;
 	struct vm_area_struct *vma;
 	kvm_pfn_t pfn = 0;
 	int npages, r;
@@ -2592,7 +2596,7 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	if (atomic)
 		return KVM_PFN_ERR_FAULT;
 
-	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	npages = hva_to_pfn_slow(addr, async, gtp_flags, writable, &pfn);
 	if (npages == 1)
 		return pfn;
 
@@ -2625,10 +2629,11 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 }
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool atomic, bool *async, bool write_fault,
+			       kvm_gtp_flag_t gtp_flags, bool *async,
 			       bool *writable, hva_t *hva)
 {
-	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
+	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL,
+					       gtp_flags & KVM_GTP_WRITE);
 
 	if (hva)
 		*hva = addr;
@@ -2651,28 +2656,30 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 		writable = NULL;
 	}
 
-	return hva_to_pfn(addr, atomic, async, write_fault,
-			  writable);
+	return hva_to_pfn(addr, gtp_flags, async, writable);
 }
 EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
-	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
-				    write_fault, writable, NULL);
+	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn,
+				    write_fault ? KVM_GTP_WRITE : 0,
+				    NULL, writable, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, KVM_GTP_WRITE,
+				    NULL, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
 kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, KVM_GTP_WRITE | KVM_GTP_ATOMIC,
+				    NULL, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 41da467d99c9..1c870911eb48 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -3,6 +3,8 @@
 #ifndef __KVM_MM_H__
 #define __KVM_MM_H__ 1
 
+#include <linux/kvm_host.h>
+
 /*
  * Architectures can choose whether to use an rwlock or spinlock
  * for the mmu_lock.  These macros, for use in common code
@@ -24,8 +26,8 @@
 #define KVM_MMU_READ_UNLOCK(kvm)	spin_unlock(&(kvm)->mmu_lock)
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
-kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-		     bool write_fault, bool *writable);
+kvm_pfn_t hva_to_pfn(unsigned long addr, kvm_gtp_flag_t gtp_flags, bool *async,
+		     bool *writable);
 
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index dd84676615f1..0f9f6b5d2fbb 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -123,7 +123,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
 		smp_rmb();
 
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(uhva, KVM_GTP_WRITE, NULL, NULL);
 		if (is_error_noslot_pfn(new_pfn))
 			break;
 
-- 
2.32.0

