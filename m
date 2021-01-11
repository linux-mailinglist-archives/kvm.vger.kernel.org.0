Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059EE2F2037
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 20:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391445AbhAKT7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391406AbhAKT6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 14:58:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9778DC0617A9
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 11:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=pDVVgagejnyvOgl3F+23LlzBAD55IHXrLcXMQ3eH38I=; b=uD6oLTv7m7Yk4nJzZSPHsHzvZN
        e0sYchIa4Mf6jmZieACqWYGp2AF0bYGqJ8ymEhnLzFHXfJ4i1iy43JlkMBE+Z7hCB2f4xFKgb/pYE
        h5cVGNf1tEmr7r8YHjjpBjLUbD20/pE106UOZpSLPdjnmCLlmwvdNmylsdLXa0ut6SehL00/Uk9dX
        SKmehasomRr7nFPjA7Afkne2k/c6xGR2Z9amajhL61x8sHNKL70m1B/JEKmSX9FUj3EuXvrVd5xdq
        GCd3iNRohC7iERARZuLAFxl9y480rgYwG4VI+vobTBNcmtMASGnUCuBuC/X/SuHFHbhB46iI67lo+
        TUSVYb5A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jg-003kSZ-3C; Mon, 11 Jan 2021 19:57:37 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jf-0001Hv-Mc; Mon, 11 Jan 2021 19:57:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v5 12/16] KVM: x86/xen: register vcpu time info region
Date:   Mon, 11 Jan 2021 19:57:21 +0000
Message-Id: <20210111195725.4601-13-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111195725.4601-1-dwmw2@infradead.org>
References: <20210111195725.4601-1-dwmw2@infradead.org>
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
 arch/x86/kvm/x86.c              |  2 ++
 arch/x86/kvm/xen.c              | 26 ++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 421d082d772d..cd65bd43fc5f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -524,7 +524,9 @@ struct kvm_vcpu_hv {
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
 	bool vcpu_info_set;
+	bool vcpu_time_info_set;
 	struct gfn_to_hva_cache vcpu_info_cache;
+	struct gfn_to_hva_cache vcpu_time_info_cache;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af4490c20d63..1cf503d559eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2735,6 +2735,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	if (vcpu->xen.vcpu_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
 				       offsetof(struct compat_vcpu_info, time));
+	if (vcpu->xen.vcpu_time_info_set)
+		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
 	if (v == kvm_get_vcpu(v->kvm, 0))
 		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d2055b60fdc1..1cca46effec8 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -95,6 +95,21 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		break;
 
+	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
+		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
+		if (!v)
+			return -EINVAL;
+
+		r = kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.vcpu_time_info_cache,
+					      data->u.vcpu_attr.gpa,
+					      sizeof(struct pvclock_vcpu_time_info));
+		if (r)
+			return r;
+
+		v->arch.xen.vcpu_time_info_set = true;
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
+		break;
+
 	default:
 		break;
 	}
@@ -131,6 +146,17 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		}
 		break;
 
+	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
+		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
+		if (!v)
+			return -EINVAL;
+
+		if (v->arch.xen.vcpu_time_info_set) {
+			data->u.vcpu_attr.gpa = v->arch.xen.vcpu_time_info_cache.gpa;
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5ab0063d109a..6e91c004ae68 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1607,6 +1607,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
+#define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.29.2

