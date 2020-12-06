Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE79A2D031D
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgLFLEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 06:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbgLFLEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 06:04:37 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF5AC061A55
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 03:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RIBLkremV8VRJ8yij0ZrrOY6kMMOGhoTXP3SsJTLyUE=; b=XjCgYKztXC+3Ih5MgV/UvcWHUA
        Xhoeq1qz309hGalDuLhDth4XTzs3235G0EZK3k//uN95UytSfx3PZdBF6odaycMV7jq+DwEad4DAA
        jMM2zdCI/z1AxeyamX5qjRZZIDdB21apKu/5KuNLoTChJkX1Tdetgim6oQmiBmki8Yss2TvVkCdda
        D2VgF6B14NpfWBsv/3zGghDukDybcdLnRAojQ5UDkVwA/6/aPBe9E71VeVjUjWLNJVD45wzsxeChG
        bEJPcxydXSuP/JWDW+mgWI6QwMWz8iipl7s8ahJbMh2H+V1YA7+Lxi92qdodxgC06wRDtHpvywN33
        nwpQ03Lg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klrpE-0004tM-SG; Sun, 06 Dec 2020 11:03:33 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1klrpD-000jph-Q5; Sun, 06 Dec 2020 11:03:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de
Subject: [PATCH v2 12/16] KVM: x86/xen: register vcpu info
Date:   Sun,  6 Dec 2020 11:03:23 +0000
Message-Id: <20201206110327.175629-13-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206110327.175629-1-dwmw2@infradead.org>
References: <20201206110327.175629-1-dwmw2@infradead.org>
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
 arch/x86/kvm/xen.c              | 96 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/xen.h              | 14 +++++
 include/uapi/linux/kvm.h        |  5 ++
 5 files changed, 113 insertions(+), 5 deletions(-)

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
index abc4c78a7aa4..27f3a59f45b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10004,6 +10004,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 
 	kvm_hv_vcpu_uninit(vcpu);
+	kvm_xen_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
 	kvm_free_lapic(vcpu);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index cb2a37cf12da..2a160a5c8589 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -80,6 +80,27 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	return 0;
 }
 
+static void *xen_vcpu_info(struct kvm_vcpu *v)
+{
+	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(v);
+	struct kvm_xen *kvm = &v->kvm->arch.xen;
+	void *hva;
+
+	hva = READ_ONCE(vcpu_xen->vcpu_info);
+	if (hva)
+		return hva;
+
+	if (v->vcpu_id < MAX_VIRT_CPUS)
+		hva = READ_ONCE(kvm->shinfo);
+
+	if (hva) {
+		hva += offsetof(struct shared_info, vcpu_info);
+		hva += v->vcpu_id * sizeof(struct vcpu_info);
+	}
+
+	return hva;
+}
+
 void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
@@ -88,9 +109,6 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	void *hva;
 	int idx;
 
-	if (v->vcpu_id >= MAX_VIRT_CPUS)
-		return;
-
 	BUILD_BUG_ON(offsetof(struct shared_info, vcpu_info) != 0);
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, vcpu_info) != 0);
 	BUILD_BUG_ON(sizeof(struct vcpu_info) != sizeof(struct compat_vcpu_info));
@@ -98,7 +116,7 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 		     offsetof(struct compat_vcpu_info, time));
 
 	idx = srcu_read_lock(&v->kvm->srcu);
-	hva = READ_ONCE(v->kvm->arch.xen.shinfo);
+	hva = xen_vcpu_info(v);
 	if (!hva)
 		goto out;
 
@@ -108,7 +126,7 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	guest_hv_clock = hva + offset;
 
 	if (guest_hv_clock->version & 1)
-		++guest_hv_clock->version;  /* first time write, random junk */
+		++guest_hv_clock->version;
 
 	vcpu->hv_clock.version = guest_hv_clock->version + 1;
 	guest_hv_clock->version = vcpu->hv_clock.version;
@@ -137,6 +155,20 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	srcu_read_unlock(&v->kvm->srcu, idx);
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
@@ -157,6 +189,28 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
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
@@ -182,6 +236,27 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
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
@@ -321,6 +396,17 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
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
index 950a364f5b22..a4d80cc21ee4 100644
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
index caa9faf3c5ad..8dda080175b6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1588,12 +1588,17 @@ struct kvm_xen_hvm_attr {
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

