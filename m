Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A1B46E244
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 07:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhLIGJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 01:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhLIGJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 01:09:37 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168DEC061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 22:06:05 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id 4-20020a170902c20400b0014381f710d5so1791848pll.11
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 22:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LsI+EVLOAR/IPr1dNwAWdHhFNfhytImXJJV+EwgSPyM=;
        b=nVpDN2WbbOJ5vEn0zAsBuNVBsmGH7YIMPEFAXIEHuODn1P3/q0LQtTgElK5lGt13y8
         iK1+W3YI/VWzVwJe/BRIPFa3rlBNekxHQ2LK25VH3+4RVtnNXnQz13cDiAX+cJnLGKXy
         ZC4R1QOMgGqYcOAkISH2n97Mw8bclhLnIoq8/W6hIxqPREzy/pzwSZbEbdUvBeiPQsmC
         PYuCFsNyMV8laehJ8jyrR+6VhE5kg6V/x1kOG6jr9fHnQNWEjrqX45/wHpaRoNasYCAw
         7pgcbYZeOWmDyCPftdXyzsg9Q/IQ6YntsgQkgMo/m6gbXZnU5Isae+CmbHTrPBObkxu4
         shFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LsI+EVLOAR/IPr1dNwAWdHhFNfhytImXJJV+EwgSPyM=;
        b=D3D3BNozrKW5RxFFlp7bijfBwHk344evHgSrc77fy3GQbvVytGOOuQmotN03oJPOnc
         sjYjQ1jHGvufs/BSnO4JEWB/mWsuF/WR25pE/xB3jHF/Kf51L8O+Zw1SuDp7GdypVfOW
         +ysa8llVPSZQWlfW9S1XauZKT7ossQMts/Z/upSvlYznTRTIQZaWXfrRem1goojqY3jJ
         xML6DHdHBOe//Rrqj89IUj0Wgi57qrLv2z6l6mQBqQ6xyhXp/rE2gWjPY9Nu+i3le672
         jR6oWk4km14RAg3saTeqnZiBw5HkKCX4mg9AvN7n06psXIi0+L+qrRXSP72QSnnXLpMb
         oHLw==
X-Gm-Message-State: AOAM5332IAXsQHYbnKNU7M3zFkJ9eVydj/ZkmkVPC+kDiC+M0Cc35N7I
        Rdoyzzu8gd8KrLMC3q23xF6mFfNuF9I=
X-Google-Smtp-Source: ABdhPJzTnM+An2UblYxdMMdlwFtQ+NaLz0iMDR5IifEqtUirsklw+Z7vn7+18qI4vCEBUzeZ2gJda2Iv+IQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2306:b0:141:e52e:457d with SMTP id
 d6-20020a170903230600b00141e52e457dmr64914357plh.3.1639029964517; Wed, 08 Dec
 2021 22:06:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Dec 2021 06:05:49 +0000
In-Reply-To: <20211209060552.2956723-1-seanjc@google.com>
Message-Id: <20211209060552.2956723-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211209060552.2956723-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 4/7] KVM: x86/mmu: Zap only obsolete roots if a root shadow
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
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
 arch/x86/kvm/mmu/mmu.c          | 66 +++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c              |  4 +-
 4 files changed, 64 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d5fede05eb5f..62e5e842b692 100644
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
index e9fbb2c8bbe2..923e0e95e7d7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -79,6 +79,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
+void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 31605cd3c09f..b6115d8ea696 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2345,7 +2345,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 				       struct list_head *invalid_list,
 				       int *nr_zapped)
 {
-	bool list_unstable;
+	bool list_unstable, zapped_root = false;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
@@ -2387,14 +2387,20 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
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
 
@@ -3985,7 +3991,7 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
 	 * to reload even if no vCPU is actively using the root.
 	 */
-	if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
+	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
 		return true;
 
 	return fault->slot &&
@@ -4187,8 +4193,8 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	/*
 	 * It's possible that the cached previous root page is obsolete because
 	 * of a change in the MMU generation number. However, changing the
-	 * generation number is accompanied by KVM_REQ_MMU_RELOAD, which will
-	 * free the root set here and allocate a new one.
+	 * generation number is accompanied by KVM_REQ_MMU_FREE_OBSOLETE_ROOTS,
+	 * which will free the root set here and allocate a new one.
 	 */
 	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 
@@ -5113,6 +5119,52 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 	WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
 }
 
+static bool is_obsolete_root(struct kvm_vcpu *vcpu, hpa_t root_hpa)
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
+	return !sp || is_obsolete_sp(vcpu->kvm, sp);
+}
+
+static void __kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu,
+					  struct kvm_mmu *mmu)
+{
+	unsigned long roots_to_free = 0;
+	int i;
+
+	if (is_obsolete_root(vcpu, mmu->root_hpa))
+		roots_to_free |= KVM_MMU_ROOT_CURRENT;
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		if (is_obsolete_root(vcpu, mmu->root_hpa))
+			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+	}
+
+	if (roots_to_free)
+		kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
+}
+
+void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu)
+{
+	__kvm_mmu_free_obsolete_roots(vcpu, &vcpu->arch.root_mmu);
+	__kvm_mmu_free_obsolete_roots(vcpu, &vcpu->arch.guest_mmu);
+}
+
 static bool need_remote_flush(u64 old, u64 new)
 {
 	if (!is_shadow_present_pte(old))
@@ -5686,7 +5738,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Note: we need to do this under the protection of mmu_lock,
 	 * otherwise, vcpu would purge shadow page but miss tlb flush.
 	 */
-	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
 
 	kvm_zap_obsolete_pages(kvm);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca1f0350a868..35a4f07b4f40 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9714,8 +9714,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
2.34.1.400.ga245620fadb-goog

