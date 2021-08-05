Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6563E0F3D
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 09:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhHEHdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 03:33:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231499AbhHEHdW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 03:33:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628148788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VMJr84Y9bUNKt9cAHm1Vupejhp2NHPyfaDvSsHp2BrQ=;
        b=GCf3qBI8HicT70/BWeQRQLABdqVMXfGeLIUWu7ShmxHE+0JGSbMo+U2nxiUVMK+AcrYxpl
        SpiXVCZfL305ZNoOlOcxTz/s/rviOKI1BXfpZyCquFMfNLQ3+ye86Z0pgl9ebgN1QRKl5G
        YtGn+ygxO2pN6AZfp+tYhnaiQT8qZZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-cPH-JUHKMRGuyXsE6Wr6iw-1; Thu, 05 Aug 2021 03:33:07 -0400
X-MC-Unique: cPH-JUHKMRGuyXsE6Wr6iw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F06CD10066E5;
        Thu,  5 Aug 2021 07:33:05 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98A8460BF4;
        Thu,  5 Aug 2021 07:33:05 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH] KVM: xen: do not use struct gfn_to_hva_cache
Date:   Thu,  5 Aug 2021 03:33:05 -0400
Message-Id: <20210805073305.2682042-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gfn_to_hva_cache is not thread-safe, so it is usually used only within
a vCPU (whose code is protected by vcpu->mutex).  The Xen interface
implementation has such a cache in kvm->arch, but it is not really
used except to store the location of the shared info page.  Replace
shinfo_set and shinfo_cache with just the value that is passed via
KVM_XEN_ATTR_TYPE_SHARED_INFO; the only complication is that the
initialization value is not zero anymore and therefore kvm_xen_init_vm
needs to be introduced.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/x86.c              |  1 +
 arch/x86/kvm/xen.c              | 23 ++++++++++++-----------
 arch/x86/kvm/xen.h              |  5 +++++
 4 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a079880d4cd5..6a73ff7db5f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1003,9 +1003,8 @@ struct msr_bitmap_range {
 /* Xen emulation context */
 struct kvm_xen {
 	bool long_mode;
-	bool shinfo_set;
 	u8 upcall_vector;
-	struct gfn_to_hva_cache shinfo_cache;
+	gfn_t shinfo_gfn;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 348452bb16bc..3cedc7cc132a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11162,6 +11162,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_hv_init_vm(kvm);
 	kvm_page_track_init(kvm);
 	kvm_mmu_init_vm(kvm);
+	kvm_xen_init_vm(kvm);
 
 	return static_call(kvm_x86_vm_init)(kvm);
 }
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index ae17250e1efe..9ea9c3dabe37 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -25,15 +25,14 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 {
 	gpa_t gpa = gfn_to_gpa(gfn);
 	int wc_ofs, sec_hi_ofs;
-	int ret;
+	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	ret = kvm_gfn_to_hva_cache_init(kvm, &kvm->arch.xen.shinfo_cache,
-					gpa, PAGE_SIZE);
-	if (ret)
+	if (kvm_is_error_hva(gfn_to_hva(kvm, gfn))) {
+		ret = -EFAULT;
 		goto out;
-
-	kvm->arch.xen.shinfo_set = true;
+	}
+	kvm->arch.xen.shinfo_gfn = gfn;
 
 	/* Paranoia checks on the 32-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) != 0x900);
@@ -245,7 +244,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
 		if (data->u.shared_info.gfn == GPA_INVALID) {
-			kvm->arch.xen.shinfo_set = false;
+			kvm->arch.xen.shinfo_gfn = GPA_INVALID;
 			r = 0;
 			break;
 		}
@@ -283,10 +282,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		if (kvm->arch.xen.shinfo_set)
-			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
-		else
-			data->u.shared_info.gfn = GPA_INVALID;
+		data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_gfn);
 		r = 0;
 		break;
 
@@ -646,6 +642,11 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 	return 0;
 }
 
+void kvm_xen_init_vm(struct kvm *kvm)
+{
+	kvm->arch.xen.shinfo_gfn = GPA_INVALID;
+}
+
 void kvm_xen_destroy_vm(struct kvm *kvm)
 {
 	if (kvm->arch.xen_hvm_config.msr)
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 463a7844a8ca..cc0cf5f37450 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -21,6 +21,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
+void kvm_xen_init_vm(struct kvm *kvm);
 void kvm_xen_destroy_vm(struct kvm *kvm);
 
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
@@ -50,6 +51,10 @@ static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 	return 1;
 }
 
+static inline void kvm_xen_init_vm(struct kvm *kvm)
+{
+}
+
 static inline void kvm_xen_destroy_vm(struct kvm *kvm)
 {
 }
-- 
2.27.0

