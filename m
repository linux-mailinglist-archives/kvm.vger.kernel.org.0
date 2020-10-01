Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B202E27F71D
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 03:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbgJABVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 21:21:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730178AbgJABU6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 21:20:58 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601515256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLIFikHpp6WZI5FsFK/Gmk9tNNIYWLKcTqGUhJqeIVw=;
        b=HABLAr+3dcsOm5UA18Vdbo0JLu17Qyy9Rv86CiuRbDiBF2RcQ4Xy2fINvaKaP9DWlVZmNu
        GF1EcjP14NFMmLjbJ2hkNXW9qbNxGIJBKGz75u2r3iujgx766TZ1tbiP46wyQV0RsIvf1P
        3j7qJT8EZJRkYnsVXxku2vDVY9VYhSc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-lmJFzhWJPViLFIcy-Qm87Q-1; Wed, 30 Sep 2020 21:20:54 -0400
X-MC-Unique: lmJFzhWJPViLFIcy-Qm87Q-1
Received: by mail-qv1-f71.google.com with SMTP id bo17so2135100qvb.2
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 18:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wLIFikHpp6WZI5FsFK/Gmk9tNNIYWLKcTqGUhJqeIVw=;
        b=ktZwESRJ5N5OXLXTj1X8GtWEmslJe8qG4TH6yCSRxEQwKszmhE4+4VM5lf1MsnOjx5
         dlh5BxbdbY+x3BoHbvVGnlGm8BQcNZy2ieyJSDtm1nJOUMsJ1Kwokfg4JXEl970Li2IB
         0Vh9qE1nOu9NJogoU08819NwHvXFMJ6K9oT8AQgNdQL8PHgXFMyPv5yOzhw+T8yw4fWh
         EEJr56Qy8bBu3ExuP+ud+od/TrLQy56i9HHE6uIJUlKJju6mtTytvtQUj1cdqGZSp5f3
         QOLAqKCprsbYsufxZ0QKszi6X8i6NdwDrb0Yv+CrUkZWV+ZZeSEJAJ4PbNLTfAsC3nMF
         vEVQ==
X-Gm-Message-State: AOAM530XWA2YLPmeOOjPKhfUaIu0cStg6ZkodNQ3aT20pQ1Ko+/YOvIN
        iCroWYQpi5J2hv6av4JKUgaCrihlp5DjInXW+l5quBN6+JTstGMva8Bw400+xk8NveSJtSJCLYw
        qUybHMrut+fOJ
X-Received: by 2002:ac8:43d3:: with SMTP id w19mr5404789qtn.129.1601515253678;
        Wed, 30 Sep 2020 18:20:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxm60Ik+wrlPuxEj0AGlPnKFBVlzz1j8QO0IT+ohvfD2RLsmJezQA904lo1q3vTAJUjsukYuw==
X-Received: by 2002:ac8:43d3:: with SMTP id w19mr5404755qtn.129.1601515253314;
        Wed, 30 Sep 2020 18:20:53 -0700 (PDT)
Received: from localhost.localdomain (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id y46sm4714478qtc.30.2020.09.30.18.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 18:20:52 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v13 03/14] KVM: X86: Don't track dirty for KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Date:   Wed, 30 Sep 2020 21:20:33 -0400
Message-Id: <20201001012044.5151-4-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001012044.5151-1-peterx@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originally, we have three code paths that can dirty a page without
vcpu context for X86:

  - init_rmode_identity_map
  - init_rmode_tss
  - kvmgt_rw_gpa

init_rmode_identity_map and init_rmode_tss will be setup on
destination VM no matter what (and the guest cannot even see them), so
it does not make sense to track them at all.

To do this, allow __x86_set_memory_region() to return the userspace
address that just allocated to the caller.  Then in both of the
functions we directly write to the userspace address instead of
calling kvm_write_*() APIs.

Another trivial change is that we don't need to explicitly clear the
identity page table root in init_rmode_identity_map() because no
matter what we'll write to the whole page with 4M huge page entries.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/svm/avic.c         |  9 ++--
 arch/x86/kvm/vmx/vmx.c          | 88 ++++++++++++++++-----------------
 arch/x86/kvm/x86.c              | 37 +++++++++++---
 4 files changed, 81 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d0f77235da92..e43f4e99e5c6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1665,7 +1665,8 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
 int kvm_is_in_guest(void);
 
-int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size);
+void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
+				     u32 size);
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f73f84d56452..ea2bae97e3e0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -233,7 +233,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
  */
 static int avic_update_access_page(struct kvm *kvm, bool activate)
 {
-	int ret = 0;
+	void __user *ret;
+	int r = 0;
 
 	mutex_lock(&kvm->slots_lock);
 	/*
@@ -249,13 +250,15 @@ static int avic_update_access_page(struct kvm *kvm, bool activate)
 				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
 				      APIC_DEFAULT_PHYS_BASE,
 				      activate ? PAGE_SIZE : 0);
-	if (ret)
+	if (IS_ERR(ret)) {
+		r = PTR_ERR(ret);
 		goto out;
+	}
 
 	kvm->arch.apic_access_page_done = activate;
 out:
 	mutex_unlock(&kvm->slots_lock);
-	return ret;
+	return r;
 }
 
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4551a7e80ebc..4786c4f0f4ad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3496,42 +3496,33 @@ bool __vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static int init_rmode_tss(struct kvm *kvm)
+static int init_rmode_tss(struct kvm *kvm, void __user *ua)
 {
-	gfn_t fn;
-	u16 data = 0;
-	int idx, r;
+	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
+	u16 data;
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		if (__copy_to_user(ua + PAGE_SIZE * i, zero_page, PAGE_SIZE))
+			return -EFAULT;
+	}
 
-	idx = srcu_read_lock(&kvm->srcu);
-	fn = to_kvm_vmx(kvm)->tss_addr >> PAGE_SHIFT;
-	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
-	if (r < 0)
-		goto out;
 	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
-	r = kvm_write_guest_page(kvm, fn++, &data,
-			TSS_IOPB_BASE_OFFSET, sizeof(u16));
-	if (r < 0)
-		goto out;
-	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE);
-	if (r < 0)
-		goto out;
-	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
-	if (r < 0)
-		goto out;
+	if (__copy_to_user(ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16)))
+		return -EFAULT;
+
 	data = ~0;
-	r = kvm_write_guest_page(kvm, fn, &data,
-				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
-				 sizeof(u8));
-out:
-	srcu_read_unlock(&kvm->srcu, idx);
-	return r;
+	if (__copy_to_user(ua + RMODE_TSS_SIZE - 1, &data, sizeof(u8)))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int init_rmode_identity_map(struct kvm *kvm)
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	int i, r = 0;
-	kvm_pfn_t identity_map_pfn;
+	void __user *uaddr;
 	u32 tmp;
 
 	/* Protect kvm_vmx->ept_identity_pagetable_done. */
@@ -3542,24 +3533,24 @@ static int init_rmode_identity_map(struct kvm *kvm)
 
 	if (!kvm_vmx->ept_identity_map_addr)
 		kvm_vmx->ept_identity_map_addr = VMX_EPT_IDENTITY_PAGETABLE_ADDR;
-	identity_map_pfn = kvm_vmx->ept_identity_map_addr >> PAGE_SHIFT;
 
-	r = __x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
-				    kvm_vmx->ept_identity_map_addr, PAGE_SIZE);
-	if (r < 0)
+	uaddr = __x86_set_memory_region(kvm,
+					IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
+					kvm_vmx->ept_identity_map_addr,
+					PAGE_SIZE);
+	if (IS_ERR(uaddr)) {
+		r = PTR_ERR(uaddr);
 		goto out;
+	}
 
-	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
-	if (r < 0)
-		goto out;
 	/* Set up identity-mapping pagetable for EPT in real mode */
 	for (i = 0; i < PT32_ENT_PER_PAGE; i++) {
 		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
 			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
-		r = kvm_write_guest_page(kvm, identity_map_pfn,
-				&tmp, i * sizeof(tmp), sizeof(tmp));
-		if (r < 0)
+		if (__copy_to_user(uaddr + i * sizeof(tmp), &tmp, sizeof(tmp))) {
+			r = -EFAULT;
 			goto out;
+		}
 	}
 	kvm_vmx->ept_identity_pagetable_done = true;
 
@@ -3586,19 +3577,22 @@ static void seg_setup(int seg)
 static int alloc_apic_access_page(struct kvm *kvm)
 {
 	struct page *page;
-	int r = 0;
+	void __user *hva;
+	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
 	if (kvm->arch.apic_access_page_done)
 		goto out;
-	r = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
-				    APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
-	if (r)
+	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
+				      APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
+	if (IS_ERR(hva)) {
+		ret = PTR_ERR(hva);
 		goto out;
+	}
 
 	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 	if (is_error_page(page)) {
-		r = -EFAULT;
+		ret = -EFAULT;
 		goto out;
 	}
 
@@ -3610,7 +3604,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	kvm->arch.apic_access_page_done = true;
 out:
 	mutex_unlock(&kvm->slots_lock);
-	return r;
+	return ret;
 }
 
 int allocate_vpid(void)
@@ -4612,7 +4606,7 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
-	int ret;
+	void __user *ret;
 
 	if (enable_unrestricted_guest)
 		return 0;
@@ -4622,10 +4616,12 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 				      PAGE_SIZE * 3);
 	mutex_unlock(&kvm->slots_lock);
 
-	if (ret)
-		return ret;
+	if (IS_ERR(ret))
+		return PTR_ERR(ret);
+
 	to_kvm_vmx(kvm)->tss_addr = addr;
-	return init_rmode_tss(kvm);
+
+	return init_rmode_tss(kvm, ret);
 }
 
 static int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4015a43cc8a..bd51cc1fd6a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10233,7 +10233,32 @@ void kvm_arch_sync_events(struct kvm *kvm)
 	kvm_free_pit(kvm);
 }
 
-int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
+#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
+
+/**
+ * __x86_set_memory_region: Setup KVM internal memory slot
+ *
+ * @kvm: the kvm pointer to the VM.
+ * @id: the slot ID to setup.
+ * @gpa: the GPA to install the slot (unused when @size == 0).
+ * @size: the size of the slot. Set to zero to uninstall a slot.
+ *
+ * This function helps to setup a KVM internal memory slot.  Specify
+ * @size > 0 to install a new slot, while @size == 0 to uninstall a
+ * slot.  The return code can be one of the following:
+ *
+ *   HVA:           on success (uninstall will return a bogus HVA)
+ *   -errno:        on error
+ *
+ * The caller should always use IS_ERR() to check the return value
+ * before use.  Note, the KVM internal memory slots are guaranteed to
+ * remain valid and unchanged until the VM is destroyed, i.e., the
+ * GPA->HVA translation will not change.  However, the HVA is a user
+ * address, i.e. its accessibility is not guaranteed, and must be
+ * accessed via __copy_{to,from}_user().
+ */
+void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
+				      u32 size)
 {
 	int i, r;
 	unsigned long hva, old_npages;
@@ -10242,12 +10267,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 
 	/* Called with kvm->slots_lock held.  */
 	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
-		return -EINVAL;
+		return ERR_PTR_USR(-EINVAL);
 
 	slot = id_to_memslot(slots, id);
 	if (size) {
 		if (slot && slot->npages)
-			return -EEXIST;
+			return ERR_PTR_USR(-EEXIST);
 
 		/*
 		 * MAP_SHARED to prevent internal slot pages from being moved
@@ -10256,7 +10281,7 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
 			      MAP_SHARED | MAP_ANONYMOUS, 0);
 		if (IS_ERR((void *)hva))
-			return PTR_ERR((void *)hva);
+			return (void __user *)hva;
 	} else {
 		if (!slot || !slot->npages)
 			return 0;
@@ -10275,13 +10300,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 		m.memory_size = size;
 		r = __kvm_set_memory_region(kvm, &m);
 		if (r < 0)
-			return r;
+			return ERR_PTR_USR(r);
 	}
 
 	if (!size)
 		vm_munmap(hva, old_npages * PAGE_SIZE);
 
-	return 0;
+	return (void __user *)hva;
 }
 EXPORT_SYMBOL_GPL(__x86_set_memory_region);
 
-- 
2.26.2

