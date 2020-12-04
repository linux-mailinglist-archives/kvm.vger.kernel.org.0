Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09752CE4E4
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbgLDBTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731944AbgLDBTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:19:36 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73E2C061A54
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bFK5dbSDMwaMu04SqdRJV5rl+URUHl7Q8V+NQHaLCr0=; b=A020GmEZXYjncT2WttICM8VvLm
        vPY+Xg+PabHl+Skzda5l0ZTcp11Av8Mf/yPjP8jUGLegrVlfeQCwYfsBJzHwmBVivSqwtuADtntFw
        Ib/NR9TJ/YXoOePrqnwATWMTv+OOLYMWoPHDpcNI3VDEHAm2Yc37bPxVNTH3sLnjnUBdBMj5uWLnX
        yEHaF2InP745y4seUYtSHekn+2RVTr+64o1L9Gu+1QCCH4Uh/9cSs98BdFPE17NsuQSv89RbZRDdP
        p3WDq7iyeNT4nFxIST02g05zltGn3h1xy/C0pu1iFOMZfUuZPXELOnOaQq1bhF4WPcLyX/W0x3kDP
        HSUVTNvg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkL-0002k2-GS; Fri, 04 Dec 2020 01:18:53 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CSAH-EN; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 12/15] KVM: x86/xen: register vcpu info
Date:   Fri,  4 Dec 2020 01:18:45 +0000
Message-Id: <20201204011848.2967588-13-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

The vcpu info supersedes the per vcpu area of the shared info page and
the guest vcpus will use this instead.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/x86.c              |  1 +
 arch/x86/kvm/xen.c              | 94 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/xen.h              | 14 +++++
 include/uapi/linux/kvm.h        |  5 ++
 5 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b6eff9814c6a..617c120d03a3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -523,6 +523,8 @@ struct kvm_vcpu_hv {
 /* Xen HVM per vcpu emulation context */
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
+	struct kvm_host_map vcpu_info_map;
+	struct vcpu_info *vcpu_info;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34f06394de7e..0a15748e3aa8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10003,6 +10003,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 
 	kvm_hv_vcpu_uninit(vcpu);
+	kvm_xen_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
 	kvm_free_lapic(vcpu);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 2e4e98297364..f9ae2cfae0d2 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -80,13 +80,33 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	return 0;
 }
 
+static void *xen_vcpu_info(struct kvm_vcpu *v)
+{
+	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(v);
+	struct kvm_xen *kvm = &v->kvm->arch.xen;
+	unsigned int offset = 0;
+	void *hva = NULL;
+
+	if (vcpu_xen->vcpu_info)
+		return vcpu_xen->vcpu_info;
+
+	if (kvm->shinfo && v->vcpu_id < MAX_VIRT_CPUS) {
+		hva = kvm->shinfo;
+		offset += offsetof(struct shared_info, vcpu_info);
+		offset += v->vcpu_id * sizeof(struct vcpu_info);
+	}
+
+	return hva + offset;
+}
+
 void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
+	void *hva = xen_vcpu_info(v);
 	unsigned int offset;
 
-	if (v->vcpu_id >= MAX_VIRT_CPUS)
+	if (!hva)
 		return;
 
 	BUILD_BUG_ON(offsetof(struct shared_info, vcpu_info) != 0);
@@ -98,10 +118,10 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	offset = v->vcpu_id * sizeof(struct vcpu_info);
 	offset += offsetof(struct vcpu_info, time);
 
-	guest_hv_clock = v->kvm->arch.xen.shinfo + offset;
+	guest_hv_clock = hva + offset;
 
 	if (guest_hv_clock->version & 1)
-		++guest_hv_clock->version;  /* first time write, random junk */
+		++guest_hv_clock->version;
 
 	vcpu->hv_clock.version = guest_hv_clock->version + 1;
 	guest_hv_clock->version = vcpu->hv_clock.version;
@@ -127,6 +147,20 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	guest_hv_clock->version = vcpu->hv_clock.version;
 }
 
+static int vcpu_attr_loc(struct kvm_vcpu *vcpu, u16 type,
+			 struct kvm_host_map **map, void ***hva, size_t *sz)
+{
+	switch(type) {
+	case KVM_XEN_ATTR_TYPE_VCPU_INFO:
+		*map = &vcpu->arch.xen.vcpu_info_map;
+		*hva = (void **)&vcpu->arch.xen.vcpu_info;
+		if (sz)
+			*sz = sizeof(struct vcpu_info);
+		return 0;
+	}
+	return -EINVAL;
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
@@ -147,6 +181,28 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
+	case KVM_XEN_ATTR_TYPE_VCPU_INFO: {
+		gpa_t gpa = data->u.vcpu_attr.gpa;
+		struct kvm_host_map *map;
+		struct kvm_vcpu *v;
+		size_t sz;
+		void **hva;
+
+		v = kvm_get_vcpu(kvm, data->u.vcpu_attr.vcpu);
+		if (!v)
+			return -EINVAL;
+
+		r = vcpu_attr_loc(v, data->type, &map, &hva, &sz);
+		if (r)
+			return r;
+
+		r = kvm_xen_map_guest_page(kvm, map, hva, gpa, sz);
+		if (!r)
+			kvm_xen_setup_pvclock_page(v);
+
+		break;
+	}
+
 	default:
 		break;
 	}
@@ -172,6 +228,27 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
+	case KVM_XEN_ATTR_TYPE_VCPU_INFO: {
+		struct kvm_host_map *map;
+		struct kvm_vcpu *v;
+		void **hva;
+
+		v = kvm_get_vcpu(kvm, data->u.vcpu_attr.vcpu);
+		if (!v)
+			return -EINVAL;
+
+		r = vcpu_attr_loc(v, data->type, &map, &hva, NULL);
+		if (r)
+			return r;
+
+		if (*hva) {
+			data->u.vcpu_attr.gpa = gfn_to_gpa(map->gfn) +
+				offset_in_page(*hva);
+			r = 0;
+		}
+		break;
+	}
+
 	default:
 		break;
 	}
@@ -311,6 +388,17 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kvm_xen_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(vcpu);
+
+	if (vcpu_xen->vcpu_info) {
+		kvm_unmap_gfn(vcpu->kvm, &vcpu_xen->vcpu_info_map,
+			      NULL, true, false);
+		vcpu_xen->vcpu_info = NULL;
+	}
+}
+
 void kvm_xen_destroy_vm(struct kvm *kvm)
 {
 	struct kvm_xen *xen = &kvm->arch.xen;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 4f73866b3d33..6d09b46d3c2e 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,12 +9,26 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+static inline struct kvm_vcpu_xen *vcpu_to_xen_vcpu(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->arch.xen;
+}
+
+static inline struct kvm_vcpu *xen_vcpu_to_vcpu(struct kvm_vcpu_xen *xen_vcpu)
+{
+	struct kvm_vcpu_arch *arch;
+
+	arch = container_of(xen_vcpu, struct kvm_vcpu_arch, xen);
+	return container_of(arch, struct kvm_vcpu, arch);
+}
+
 void kvm_xen_setup_pvclock_page(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
 void kvm_xen_destroy_vm(struct kvm *kvm);
+void kvm_xen_vcpu_uninit(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3bcd04e4e38f..35b0d3b80f67 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1587,12 +1587,17 @@ struct kvm_xen_hvm_attr {
 		struct {
 			__u64 gfn;
 		} shared_info;
+		struct {
+			__u32 vcpu;
+			__u64 gpa;
+		} vcpu_attr;
 		__u64 pad[4];
 	} u;
 };
 
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.26.2

