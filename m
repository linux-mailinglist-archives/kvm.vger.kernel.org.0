Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251285BF121
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiITXcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiITXb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:31:57 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32DB785A8
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:49 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q188-20020a632ac5000000b004393cb3da9cso2447026pgq.3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=Kmkqo8W6GEB/9Ej5pR2iGXpBCCrUFtWow+gW+3A4WGM=;
        b=jlBDemICDWcRC4bNuLagL5EeQYJbqTC+cVge16/mzolq+Nu8oE2n/ZaebmDTseeeI0
         47guimRf1vs/qEcvZRD99qKTYtaQ5D4ANQ/nnKBhXPcIXtg5zmU3p8hARLuMhAUEEpqV
         4qAyenaqAF2PpLwpUW0PR51xUWl33iiffFHZYi/K2aWbiHwoC98MP5lsJ10rkyoBTq5o
         2W/RXxxnD91vDxJaQQrR20VeXbxnNT4tSNdU/p4jKP/RRGIxr+SOWRGzMrQDi6qEaF8v
         ezt8XlfD6olcafjbmTAjDtSlIVsIMOJhZw8Hf5JBXYuPUf20J/UV8yn+HDM5IGFAA8Kn
         Blxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=Kmkqo8W6GEB/9Ej5pR2iGXpBCCrUFtWow+gW+3A4WGM=;
        b=TKJjciUI5HqE4eV8Q7hCIcWfWdOBNb3DuMEWqdHrid9gPpVbTPrbZjRNErD0ACfPGe
         gmGrtgkAnyatnBjp98nJ3pI+FWfhcBOpazaqCWlMlKuDr+JYRlxc/eVnFqhR6FYXJbzB
         zStNXmuD7F4TK+IOGqx+hlVPkz2NOof+GvE6m+01dwFS84TraHMh3sGmHo/0fn0OK7u1
         AAx1b5gKK9t7x//4Uceoe3o7lLbZBytnahRAvvjx8SJbKlBGq1K7G0SzSSD0odjrhE36
         oYRih4XVNk+hpvqWEiEqOgthsVtDt1tI6kAmVeCnv2YtCC7LmVC7w+AUCGLQ6AntiOLr
         m2CA==
X-Gm-Message-State: ACrzQf3yebS/kvNQhZ+Lz/alQjnaFAjqluURZrzRF91JV9YU6VQ5Y6FX
        07fF/QccYD6MLSZDJw7lCGePM3vNisQ=
X-Google-Smtp-Source: AMsMyM7zQaWg9XVmM3OjbFCQJcICwP8w12Tk/Gla3LUSE5B4/TcfGAPAslcnJX1fDxYVwl3WDW/YfRfqQg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP id
 p10-20020a17090b010a00b002002849235fmr524110pjz.1.1663716706972; Tue, 20 Sep
 2022 16:31:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:12 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-7-seanjc@google.com>
Subject: [PATCH v3 06/28] KVM: x86: Move APIC access page helper to common x86 code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c    | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h    |  1 +
 arch/x86/kvm/svm/avic.c | 41 +++++++----------------------------------
 arch/x86/kvm/vmx/vmx.c  | 35 +----------------------------------
 4 files changed, 44 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a02defa3f7b5..99994d2470a2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2433,6 +2433,41 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 
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
index 117a46df5cc1..6d06397683d0 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -111,6 +111,7 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map);
 int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
 void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
+int kvm_alloc_apic_access_page(struct kvm *kvm);
 
 bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3b2c88b168ba..0424a5e664bb 100644
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
index c9b49a09e6b5..b39095ef9bd7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3818,39 +3818,6 @@ static void seg_setup(int seg)
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
@@ -7356,7 +7323,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	vmx->loaded_vmcs = &vmx->vmcs01;
 
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
-		err = alloc_apic_access_page(vcpu->kvm);
+		err = kvm_alloc_apic_access_page(vcpu->kvm);
 		if (err)
 			goto free_vmcs;
 	}
-- 
2.37.3.968.ga6b4b080e4-goog

