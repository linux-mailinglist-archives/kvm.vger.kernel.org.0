Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FE05F17C8
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiJABAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiJABAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:00:04 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E98C12089
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id w9-20020a17090a780900b002093deb1701so2745013pjk.0
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=WE5d81HbbIB8PtF8lmTW9QEFN11Wp+5ApIIrELuP49A=;
        b=EVdwXcwOSg047cB4/lcRqcS9bRvxHoA3iIfW6IXdACB64nSC1e/kOQRf6XQp4g8bEZ
         //BmRdvfbaqsAM0OsU9UiPOzLM60eQ+Zf9egRZlb/UC3mnkDLhfOa5x2QdBwgow7kN8y
         znfGbstRgmpYn1uOECB+ZEJ9SqyxdKB1IAk9y5qDxkBPLUESw9gf6bRNu6D8h6F8Ds/V
         t/2p+gEpkZzGTXt96S1pzrqGJZcWOG9ot81OE1LxoytEpptEDkdYcFxVHhvk1CXap17o
         pjQjOKGl8A5nyBpUddhuOeJa5pKPBq6w9sKoRo9mzU4l+7VwAn+R7yB+UU7tLNmrDDC/
         BTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=WE5d81HbbIB8PtF8lmTW9QEFN11Wp+5ApIIrELuP49A=;
        b=F2CIe1Zn5bF7QQnMIQrda862mvvddpRGw3P6jTzQqpSZu3h8uXf/PTrnUKtHHZLL6p
         YACPnJs1van4xUZWa+72CxqlWWTTDFVJOAH2X3yW3GjVp6TkEfly7pjVUF2QoBpxgWh+
         8rd68lshFLmEXwtM43IQYjSyaWxFVR2xezGNEGlqAQpXnuXy+qXIMzyFyTbcKEx3eRGw
         h9jB8elcfOqIDGLyOVSn7JLMatGBA4P2BUXTYq2RQlQHYGuS2w9EqueEM440kx0GF56i
         hgMkd+rC28iosVQIshtAAWocI9nvB3VRVZfVxg2fHuPnwIyPYbByyfyoV9mAsYKlr9ca
         pdbg==
X-Gm-Message-State: ACrzQf1T8AIeTun8vObnvBdra2KgnCm1nJ0sWcOz+d6i5ZyNzYCSo7+1
        j6ebGTj1ceXJc7AOPYnOFe9ZFmZMScA=
X-Google-Smtp-Source: AMsMyM4a9IcbCaPHAe9T6HaFEDaLX9Rb+ZC0mKLfRZagbftuEGMOPR1ALP2uq84Q1l1PDjfyV+M6s2C+PO8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:16c4:b0:535:890:d4a with SMTP id
 l4-20020a056a0016c400b0053508900d4amr11773279pfc.0.1664585975538; Fri, 30 Sep
 2022 17:59:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:53 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-11-seanjc@google.com>
Subject: [PATCH v4 10/32] KVM: x86: Move APIC access page helper to common x86 code
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
index 316b61b56cca..80e8b1cc6dc2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2436,6 +2436,41 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
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
index a5ac4a5a5179..0587a8282cb3 100644
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
index 9dba04b6b019..974d9a366d5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3771,39 +3771,6 @@ static void seg_setup(int seg)
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
@@ -7348,7 +7315,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	vmx->loaded_vmcs = &vmx->vmcs01;
 
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
-		err = alloc_apic_access_page(vcpu->kvm);
+		err = kvm_alloc_apic_access_page(vcpu->kvm);
 		if (err)
 			goto free_vmcs;
 	}
-- 
2.38.0.rc1.362.ged0d419d3c-goog

