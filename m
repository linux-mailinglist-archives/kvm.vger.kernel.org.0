Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E336E65F8C5
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbjAFBNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbjAFBNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:13:32 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7065471FC2
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:13:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y10-20020aa7942a000000b005814a9d972bso57589pfo.5
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AyyJxQdOuQ1HMd97et9gNBfdu2A+bTjtvnw5z18m+ZY=;
        b=n3f4DDGgwl8y3FetIa6hhUj8fZP1Vy6XVXj5BUFUUOJ0KMAv0fVJVc9d74Q9+ZkM85
         N5q2+hS/Cn/Gh5l1CddiI4JJs11r5Sj4FYCInlpqZeVCiCEeuJaagkODP7FZKXy3DuGd
         W95QR3jNMFXRxL9+eCgy8hf6rPiwOV6rEObaPA/eVcEqY28nAPiNcLKPI/Y2FJWlY/Gr
         gtIV4EG0KM5H0XNfJTpObusljai093RjgxkeHgc6idUDdYFiqnPTNz46K8mmwdGxW9jd
         iUnfCDnIsB+/0gq58XiUNgE8v9+Ap3mYfNRRYK/klTU8IvKVMplMQv5dVtKdHE3cgxLF
         u0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AyyJxQdOuQ1HMd97et9gNBfdu2A+bTjtvnw5z18m+ZY=;
        b=dzdjKDVw/mfrc+BpXi5OkH1TMVjjxdisXxDO5vLUAUkxPaGI6X9ZhRYsaUDUiRgXMG
         Zn1l3gZHKoN7S3UnIZquxxxKDCKWXJVRB15kuu1w75DVqcfHV4JlcsK7L/NEbvD5Islp
         LVi0XrbOcG0mqxin9OZHsocqYnt7FpBw9RJ22ev7eJPg5OOxPQ2WhyhtdRizw9aVnM3M
         tU0C8dRAi3wQ9RdMjWux6ziumB+I6/taVoqCyzn5ioGy9pE52vygrdB4Iii80+lmlooU
         hmWpeYTUfI6sN5NKn0naElSFFvD2QuoTHJmQe5DuPeH2dF4MNw7I4h00DFqFdkgF/LOV
         VCxQ==
X-Gm-Message-State: AFqh2kofleAAcAzEtl2xzCnMc5ylY2ch+NQW43Pu3ZZyq0KBKb7evJAL
        Nz4r/HvOPJzj6MHUnxUtEQWXVzdJFSE=
X-Google-Smtp-Source: AMrXdXsJTMbOzZ0K/SQrXcu5c8coRhChkRcw6+yG+IPWl1olBN5AujCViadAk0NIMA1fo8H5iBEqC2oASz0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fa82:b0:225:ed9f:fdc6 with SMTP id
 cu2-20020a17090afa8200b00225ed9ffdc6mr3839156pjb.116.1672967610011; Thu, 05
 Jan 2023 17:13:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:12:42 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-10-seanjc@google.com>
Subject: [PATCH v5 09/33] KVM: x86: Move APIC access page helper to common x86 code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the APIC access page allocation helper function to common x86 code,
the allocation routine is virtually identical between APICv (VMX) and
AVIC (SVM).  Keep APICv's gfn_to_page() + put_page() sequence, which
verifies that a backing page can be allocated, i.e. that the system isn't
under heavy memory pressure.  Forcing the backing page to be populated
isn't strictly necessary, but skipping the effective prefetch only delays
the inevitable.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c    | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h    |  1 +
 arch/x86/kvm/svm/avic.c | 41 +++++++----------------------------------
 arch/x86/kvm/vmx/vmx.c  | 35 +----------------------------------
 4 files changed, 44 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3ed74ad60516..e73386c26d2c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2435,6 +2435,41 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 	apic->highest_isr_cache = -1;
 }
 
+int kvm_alloc_apic_access_page(struct kvm *kvm)
+{
+	struct page *page;
+	void __user *hva;
+	int ret = 0;
+
+	mutex_lock(&kvm->slots_lock);
+	if (kvm->arch.apic_access_memslot_enabled)
+		goto out;
+
+	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
+				      APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
+	if (IS_ERR(hva)) {
+		ret = PTR_ERR(hva);
+		goto out;
+	}
+
+	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
+	if (is_error_page(page)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * Do not pin the page in memory, so that memory hot-unplug
+	 * is able to migrate it.
+	 */
+	put_page(page);
+	kvm->arch.apic_access_memslot_enabled = true;
+out:
+	mutex_unlock(&kvm->slots_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_alloc_apic_access_page);
+
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 58c3242fcc7a..8c6442751dab 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -112,6 +112,7 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map);
 int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
+int kvm_alloc_apic_access_page(struct kvm *kvm);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 97ad0661f963..ec28ba4c5f1b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -256,39 +256,6 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	return &avic_physical_id_table[index];
 }
 
-/*
- * Note:
- * AVIC hardware walks the nested page table to check permissions,
- * but does not use the SPA address specified in the leaf page
- * table entry since it uses  address in the AVIC_BACKING_PAGE pointer
- * field of the VMCB. Therefore, we set up the
- * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
- */
-static int avic_alloc_access_page(struct kvm *kvm)
-{
-	void __user *ret;
-	int r = 0;
-
-	mutex_lock(&kvm->slots_lock);
-
-	if (kvm->arch.apic_access_memslot_enabled)
-		goto out;
-
-	ret = __x86_set_memory_region(kvm,
-				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
-				      APIC_DEFAULT_PHYS_BASE,
-				      PAGE_SIZE);
-	if (IS_ERR(ret)) {
-		r = PTR_ERR(ret);
-		goto out;
-	}
-
-	kvm->arch.apic_access_memslot_enabled = true;
-out:
-	mutex_unlock(&kvm->slots_lock);
-	return r;
-}
-
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 {
 	u64 *entry, new_entry;
@@ -305,7 +272,13 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	if (kvm_apicv_activated(vcpu->kvm)) {
 		int ret;
 
-		ret = avic_alloc_access_page(vcpu->kvm);
+		/*
+		 * Note, AVIC hardware walks the nested page table to check
+		 * permissions, but does not use the SPA address specified in
+		 * the leaf SPTE since it uses address in the AVIC_BACKING_PAGE
+		 * pointer field of the VMCB.
+		 */
+		ret = kvm_alloc_apic_access_page(vcpu->kvm);
 		if (ret)
 			return ret;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0220e22b89ca..8ed14fcfe870 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3808,39 +3808,6 @@ static void seg_setup(int seg)
 	vmcs_write32(sf->ar_bytes, ar);
 }
 
-static int alloc_apic_access_page(struct kvm *kvm)
-{
-	struct page *page;
-	void __user *hva;
-	int ret = 0;
-
-	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_memslot_enabled)
-		goto out;
-	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
-				      APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
-	if (IS_ERR(hva)) {
-		ret = PTR_ERR(hva);
-		goto out;
-	}
-
-	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (is_error_page(page)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	/*
-	 * Do not pin the page in memory, so that memory hot-unplug
-	 * is able to migrate it.
-	 */
-	put_page(page);
-	kvm->arch.apic_access_memslot_enabled = true;
-out:
-	mutex_unlock(&kvm->slots_lock);
-	return ret;
-}
-
 int allocate_vpid(void)
 {
 	int vpid;
@@ -7394,7 +7361,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	vmx->loaded_vmcs = &vmx->vmcs01;
 
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
-		err = alloc_apic_access_page(vcpu->kvm);
+		err = kvm_alloc_apic_access_page(vcpu->kvm);
 		if (err)
 			goto free_vmcs;
 	}
-- 
2.39.0.314.g84b9a713c41-goog

