Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB962D031A
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgLFLER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 06:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgLFLEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 06:04:16 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6555C061A53
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 03:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=G3h2y4HGxsW9vktNlEFOJWEhUUjXG4P3u6KUdNeZZXc=; b=hfxWaIU7G4cN2kK8LsMTucgGEz
        qPkuGvGhfy1H3yZEWdncbnQyEzUNGmtblez5kZqHxSotKOgLw/zGrm5YmPTU87iUPpTurmjQ0HRU1
        E3Nx7xKvfxGELyYrMdEidi1ntw7t4nDsCwU0xshNzXAeG4CokQVf4pL/jpzaQkjzW9XAckYMrRGOz
        9B3KSu4aqmdP2wcswj6z/N5PGxY3hiSjXUCcqCPVha+jqckD5dWLT77iV+fZhznW5lyipNGnPog4g
        id1xNi+NZv/nDwrlnUos/200RNY67Y4bAHOGe+trdWCthgAVQJYeqFzzsKM7EyLX9r5tT7hL+n5pl
        4u1K4MCQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klrpE-0004tN-Sj; Sun, 06 Dec 2020 11:03:33 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1klrpD-000jpk-Ql; Sun, 06 Dec 2020 11:03:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de
Subject: [PATCH v2 13/16] KVM: x86/xen: register vcpu time info region
Date:   Sun,  6 Dec 2020 11:03:24 +0000
Message-Id: <20201206110327.175629-14-dwmw2@infradead.org>
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
 arch/x86/kvm/xen.c              | 62 +++++++++++++++++++++------------
 include/uapi/linux/kvm.h        |  1 +
 3 files changed, 43 insertions(+), 22 deletions(-)

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
index 2a160a5c8589..74716c2b455f 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -101,29 +101,10 @@ static void *xen_vcpu_info(struct kvm_vcpu *v)
 	return hva;
 }
 
-void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
+static void kvm_xen_update_vcpu_time(struct kvm_vcpu *v,
+				     struct pvclock_vcpu_time_info *guest_hv_clock)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
-	struct pvclock_vcpu_time_info *guest_hv_clock;
-	unsigned int offset;
-	void *hva;
-	int idx;
-
-	BUILD_BUG_ON(offsetof(struct shared_info, vcpu_info) != 0);
-	BUILD_BUG_ON(offsetof(struct compat_shared_info, vcpu_info) != 0);
-	BUILD_BUG_ON(sizeof(struct vcpu_info) != sizeof(struct compat_vcpu_info));
-	BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
-		     offsetof(struct compat_vcpu_info, time));
-
-	idx = srcu_read_lock(&v->kvm->srcu);
-	hva = xen_vcpu_info(v);
-	if (!hva)
-		goto out;
-
-	offset = v->vcpu_id * sizeof(struct vcpu_info);
-	offset += offsetof(struct vcpu_info, time);
-
-	guest_hv_clock = hva + offset;
 
 	if (guest_hv_clock->version & 1)
 		++guest_hv_clock->version;
@@ -150,8 +131,31 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	vcpu->hv_clock.version++;
 
 	guest_hv_clock->version = vcpu->hv_clock.version;
+}
+
+void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
+{
+	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(v);
+	struct vcpu_info *vcpu_info;
+	struct pvclock_vcpu_time_info *pv_info;
+	int idx;
+
+	BUILD_BUG_ON(offsetof(struct shared_info, vcpu_info) != 0);
+	BUILD_BUG_ON(offsetof(struct compat_shared_info, vcpu_info) != 0);
+	BUILD_BUG_ON(sizeof(struct vcpu_info) != sizeof(struct compat_vcpu_info));
+	BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
+		     offsetof(struct compat_vcpu_info, time));
+
+	idx = srcu_read_lock(&v->kvm->srcu);
+	vcpu_info = xen_vcpu_info(v);
+	if (likely(vcpu_info))
+		kvm_xen_update_vcpu_time(v, &vcpu_info->time);
+
+	/* Update secondary pvclock region if registered */
+	pv_info = READ_ONCE(vcpu_xen->pv_time);
+	if (pv_info)
+		kvm_xen_update_vcpu_time(v, pv_info);
 
- out:
 	srcu_read_unlock(&v->kvm->srcu, idx);
 }
 
@@ -165,6 +169,13 @@ static int vcpu_attr_loc(struct kvm_vcpu *vcpu, u16 type,
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
@@ -189,6 +200,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
+	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
 	case KVM_XEN_ATTR_TYPE_VCPU_INFO: {
 		gpa_t gpa = data->u.vcpu_attr.gpa;
 		struct kvm_host_map *map;
@@ -236,6 +248,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
+	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
 	case KVM_XEN_ATTR_TYPE_VCPU_INFO: {
 		struct kvm_host_map *map;
 		struct kvm_vcpu *v;
@@ -405,6 +418,11 @@ void kvm_xen_vcpu_uninit(struct kvm_vcpu *vcpu)
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
index 8dda080175b6..3ff3f72ac6b3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1599,6 +1599,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
+#define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.26.2

