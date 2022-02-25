Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E548A4C4D94
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbiBYSXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiBYSXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:23:30 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B746F11AA
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:22:57 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id n8-20020a654508000000b003783b1e9834so938587pgq.0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TGmyZn+f+4hIZ/LUaz810TG9h9t+KkL+VEw1/fW9xZE=;
        b=l764Sm9hNNUi5MdxS2VNyezNzrSlGCVCo9C+zq2apXu0W1+0BXCc6ljJQVUvHvgteL
         qEOQKVZVi2DJsqkB8BPkvybHNaCO2+7pNHN2/pHqeG29cTD+a3bfmsGeXKRlcCqTQagq
         uGrFW3Xzzn3VwZT1pZ4F8sMtQfxDlv2be9nnTRj5fsS+RcUvUjHS9kHDBnoNFiYMG7XA
         rpdbotPAqD/rZVRoc4Za1Yvr5AaiF1x7voLdebaFmKigmdjcZxAhBHob7Ho29I6QpHaa
         4RTrKpvOP/eMjnPut7lHucTw1uGORrD/YYsrIERRxJhieThe3AoVyhUBgELliTQz3sCD
         Uv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TGmyZn+f+4hIZ/LUaz810TG9h9t+KkL+VEw1/fW9xZE=;
        b=xRDw58DWNrO24yF/N1boBNArAai9bzuEURLcE/rC10y+1k3xTsVidOi3bTRMBj22ew
         udrkrI8QI4mG5CGP6h5M4bTKWyEpcTQKTFIrvNjWaa8o7OtA1IYmUUjynyRzZ8pheSgy
         bh++vBeYNz/GpSgMWqgb+FxA+kIYo2cj0sjUFKihrynW16GpkX08Ara3+GTcqRsPufpJ
         KqQkbcRCI+SYoDmt5dhcc3uG+ZEgTtTAo6oayJRydwur2tUWv8h2Kj5ndk8QLC/Ywdpl
         Lic81TlSRFFZGLapRzBcElqTm0l42Nt57C36m1HSQ05/ckldFSJpCahMP/U9ZWVs6Lm5
         7xZw==
X-Gm-Message-State: AOAM533D5vnnj+XUazShpF/6g96OgNt3cH45G1nxbJJ00CN3FwzOiHfT
        21TIQtOxzqPAhcfrH59vwfb73Py3Pug=
X-Google-Smtp-Source: ABdhPJwLaz0GsL6EieN8giNkqv3Js05m/fcvm98V2qIpCHzZYOedItWZtug/UoBLqIl1xU34AjpupMWfF2M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:3d0f:b0:1bb:80e9:3b45 with SMTP id
 h15-20020a17090a3d0f00b001bb80e93b45mr4298597pjc.31.1645813376623; Fri, 25
 Feb 2022 10:22:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Feb 2022 18:22:45 +0000
In-Reply-To: <20220225182248.3812651-1-seanjc@google.com>
Message-Id: <20220225182248.3812651-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v2 4/7] KVM: x86/mmu: Zap only obsolete roots if a root shadow
 page is zapped
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zap only obsolete roots when responding to zapping a single root shadow
page.  Because KVM keeps root_count elevated when stuffing a previous
root into its PGD cache, shadowing a 64-bit guest means that zapping any
root causes all vCPUs to reload all roots, even if their current root is
not affected by the zap.

For many kernels, zapping a single root is a frequent operation, e.g. in
Linux it happens whenever an mm is dropped, e.g. process exits, etc...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/mmu.h              |  1 +
 arch/x86/kvm/mmu/mmu.c          | 65 +++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c              |  4 +-
 4 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 713e08f62385..343041e892c6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -102,6 +102,8 @@
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
+	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 1d0c1904d69a..bf8dbc4bb12a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -80,6 +80,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
+void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 32c6d4b33d03..825996408465 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2310,7 +2310,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 				       struct list_head *invalid_list,
 				       int *nr_zapped)
 {
-	bool list_unstable;
+	bool list_unstable, zapped_root = false;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
@@ -2352,14 +2352,20 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 		 * in kvm_mmu_zap_all_fast().  Note, is_obsolete_sp() also
 		 * treats invalid shadow pages as being obsolete.
 		 */
-		if (!is_obsolete_sp(kvm, sp))
-			kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
+		zapped_root = !is_obsolete_sp(kvm, sp);
 	}
 
 	if (sp->lpage_disallowed)
 		unaccount_huge_nx_page(kvm, sp);
 
 	sp->role.invalid = 1;
+
+	/*
+	 * Make the request to free obsolete roots after marking the root
+	 * invalid, otherwise other vCPUs may not see it as invalid.
+	 */
+	if (zapped_root)
+		kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
 	return list_unstable;
 }
 
@@ -3947,7 +3953,7 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
 	 * to reload even if no vCPU is actively using the root.
 	 */
-	if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
+	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
 		return true;
 
 	return fault->slot &&
@@ -4180,8 +4186,8 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	/*
 	 * It's possible that the cached previous root page is obsolete because
 	 * of a change in the MMU generation number. However, changing the
-	 * generation number is accompanied by KVM_REQ_MMU_RELOAD, which will
-	 * free the root set here and allocate a new one.
+	 * generation number is accompanied by KVM_REQ_MMU_FREE_OBSOLETE_ROOTS,
+	 * which will free the root set here and allocate a new one.
 	 */
 	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 
@@ -5085,6 +5091,51 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 }
 
+static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
+{
+	struct kvm_mmu_page *sp;
+
+	if (!VALID_PAGE(root_hpa))
+		return false;
+
+	/*
+	 * When freeing obsolete roots, treat roots as obsolete if they don't
+	 * have an associated shadow page.  This does mean KVM will get false
+	 * positives and free roots that don't strictly need to be freed, but
+	 * such false positives are relatively rare:
+	 *
+	 *  (a) only PAE paging and nested NPT has roots without shadow pages
+	 *  (b) remote reloads due to a memslot update obsoletes _all_ roots
+	 *  (c) KVM doesn't track previous roots for PAE paging, and the guest
+	 *      is unlikely to zap an in-use PGD.
+	 */
+	sp = to_shadow_page(root_hpa);
+	return !sp || is_obsolete_sp(kvm, sp);
+}
+
+static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
+{
+	unsigned long roots_to_free = 0;
+	int i;
+
+	if (is_obsolete_root(kvm, mmu->root.hpa))
+		roots_to_free |= KVM_MMU_ROOT_CURRENT;
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		if (is_obsolete_root(kvm, mmu->root.hpa))
+			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+	}
+
+	if (roots_to_free)
+		kvm_mmu_free_roots(kvm, mmu, roots_to_free);
+}
+
+void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu)
+{
+	__kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.root_mmu);
+	__kvm_mmu_free_obsolete_roots(vcpu->kvm, &vcpu->arch.guest_mmu);
+}
+
 static bool need_remote_flush(u64 old, u64 new)
 {
 	if (!is_shadow_present_pte(old))
@@ -5656,7 +5707,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Note: we need to do this under the protection of mmu_lock,
 	 * otherwise, vcpu would purge shadow page but miss tlb flush.
 	 */
-	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
 
 	kvm_zap_obsolete_pages(kvm);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 579b26ffc124..d6bf0562c4c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9856,8 +9856,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 		}
-		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
-			kvm_mmu_unload(vcpu);
+		if (kvm_check_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
+			kvm_mmu_free_obsolete_roots(vcpu);
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
 			__kvm_migrate_timers(vcpu);
 		if (kvm_check_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu))
-- 
2.35.1.574.g5d30c73bfb-goog

