Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3052CE4F3
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388583AbgLDBU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388484AbgLDBUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC10C08ED7E
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=D2wqb3/TmK1+qquzpA98VL9SfPOlJ4Epg+ON1D817Lw=; b=grBrBi7OY+K+ZCw2xIdaXtZpK9
        3IKPev7zoSKS4yk2yKwi4zx4lDrznwCQxKO46KkEkYYNgLV1FYqTosgxumLrfyo6JwZtEiH7Cs9J1
        FMkB5T5DQ6OUAL7OvBeCa51PxAoHSkNJF6T6OCY9g24GYnoUX0OOQtT0COQKNCyNeKeGaPHVoVkzD
        1JIOyN5R9gTiBwkMmRcE+dNC9qNrUk5lNol+Xvjsq+egvLurO5BKCAAswMurvfZqby+F0XMXfOikW
        uihNMzg/Okv//uKrDOwO3vvlBUMeaYIxT/nGFnqqj/w8Vq4Q6bi/CMQbBBcvOvEQdjjXJaqz8k8Ns
        7C0xerKA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkK-0004Kf-TO; Fri, 04 Dec 2020 01:18:55 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CSAK-F2; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 13/15] KVM: x86/xen: register vcpu time info region
Date:   Fri,  4 Dec 2020 01:18:46 +0000
Message-Id: <20201204011848.2967588-14-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Allow the Xen emulated guest the ability to register secondary
vcpu time information. On Xen guests this is used in order to be
mapped to userspace and hence allow vdso gettimeofday to work.

In doing so, move kvm_xen_set_pvclock_page() logic to
kvm_xen_update_vcpu_time() and have the former a top-level
function which updates primary vcpu time info (in struct vcpu_info)
and secondary one.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/xen.c              | 53 ++++++++++++++++++++++-----------
 include/uapi/linux/kvm.h        |  1 +
 3 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 617c120d03a3..ec9425289209 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -525,6 +525,8 @@ struct kvm_vcpu_xen {
 	u64 hypercall_rip;
 	struct kvm_host_map vcpu_info_map;
 	struct vcpu_info *vcpu_info;
+	struct kvm_host_map pv_time_map;
+	struct pvclock_vcpu_time_info *pv_time;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index f9ae2cfae0d2..5c67d9038651 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -99,26 +99,10 @@ static void *xen_vcpu_info(struct kvm_vcpu *v)
 	return hva + offset;
 }
 
-void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
+static void kvm_xen_update_vcpu_time(struct kvm_vcpu *v,
+				     struct pvclock_vcpu_time_info *guest_hv_clock)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
-	struct pvclock_vcpu_time_info *guest_hv_clock;
-	void *hva = xen_vcpu_info(v);
-	unsigned int offset;
-
-	if (!hva)
-		return;
-
-	BUILD_BUG_ON(offsetof(struct shared_info, vcpu_info) != 0);
-	BUILD_BUG_ON(offsetof(struct compat_shared_info, vcpu_info) != 0);
-	BUILD_BUG_ON(sizeof(struct vcpu_info) != sizeof(struct compat_vcpu_info));
-	BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
-		     offsetof(struct compat_vcpu_info, time));
-
-	offset = v->vcpu_id * sizeof(struct vcpu_info);
-	offset += offsetof(struct vcpu_info, time);
-
-	guest_hv_clock = hva + offset;
 
 	if (guest_hv_clock->version & 1)
 		++guest_hv_clock->version;
@@ -147,6 +131,25 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	guest_hv_clock->version = vcpu->hv_clock.version;
 }
 
+void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
+{
+	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(v);
+	struct vcpu_info *vcpu_info = xen_vcpu_info(v);
+
+	BUILD_BUG_ON(offsetof(struct shared_info, vcpu_info) != 0);
+	BUILD_BUG_ON(offsetof(struct compat_shared_info, vcpu_info) != 0);
+	BUILD_BUG_ON(sizeof(struct vcpu_info) != sizeof(struct compat_vcpu_info));
+	BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
+		     offsetof(struct compat_vcpu_info, time));
+
+	if (likely(vcpu_info))
+		kvm_xen_update_vcpu_time(v, &vcpu_info->time);
+
+	/* Update secondary pvclock region if registered */
+	if (vcpu_xen->pv_time)
+		kvm_xen_update_vcpu_time(v, vcpu_xen->pv_time);
+}
+
 static int vcpu_attr_loc(struct kvm_vcpu *vcpu, u16 type,
 			 struct kvm_host_map **map, void ***hva, size_t *sz)
 {
@@ -157,6 +160,13 @@ static int vcpu_attr_loc(struct kvm_vcpu *vcpu, u16 type,
 		if (sz)
 			*sz = sizeof(struct vcpu_info);
 		return 0;
+
+	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
+		*map = &vcpu->arch.xen.pv_time_map;
+		*hva = (void **)&vcpu->arch.xen.pv_time;
+		if (sz)
+			*sz = sizeof(struct pvclock_vcpu_time_info);
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -181,6 +191,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
+	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
 	case KVM_XEN_ATTR_TYPE_VCPU_INFO: {
 		gpa_t gpa = data->u.vcpu_attr.gpa;
 		struct kvm_host_map *map;
@@ -228,6 +239,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
+	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
 	case KVM_XEN_ATTR_TYPE_VCPU_INFO: {
 		struct kvm_host_map *map;
 		struct kvm_vcpu *v;
@@ -397,6 +409,11 @@ void kvm_xen_vcpu_uninit(struct kvm_vcpu *vcpu)
 			      NULL, true, false);
 		vcpu_xen->vcpu_info = NULL;
 	}
+	if (vcpu_xen->pv_time) {
+		kvm_unmap_gfn(vcpu->kvm, &vcpu_xen->pv_time_map,
+			      NULL, true, false);
+		vcpu_xen->pv_time = NULL;
+	}
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 35b0d3b80f67..8a1914a9e206 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1598,6 +1598,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
+#define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.26.2

