Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EC82D943D
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 09:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439394AbgLNIki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 03:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439384AbgLNIki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 03:40:38 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BDAC061248
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 00:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+UPzA+6T7ArOyuOiOcZfCw/ZJaUd/QJizqTO9bQXDeE=; b=Zl+MZ5CXTzgvZYDRo/b8+IOeEt
        zifdib0MvlxktPNV3G+MuEQSd/2PttzikWRrhNsVq3PTiQ1ziC9L1QNvEPi/5G9H5maJ4+kNaec+D
        gklR8x/Ev7U/qAzwyf61QxBy1NbhkHeHy9yW+Hje6SrcxMqTs9aBouQ9EwhVEy2B+u21QcDsCQZCN
        FhfguQPSL02yx2s2xPtRA2jmxpnl/KE6T7qE8cYmECsFhut0busKso6TLZQ/w21+y2n5YOfYYEkN6
        HSopUDumu1yje6rZQYnwn/s+anqnXh7yrsba3YuBOR51a4GZnxry+Z0DWnZacod2JqyVySJDS7pei
        3i7dMQVg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kojNs-0006lV-SL; Mon, 14 Dec 2020 08:39:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kojNr-008Sy6-QK; Mon, 14 Dec 2020 08:39:07 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: [PATCH v3 13/17] KVM: x86/xen: register vcpu time info region
Date:   Mon, 14 Dec 2020 08:39:01 +0000
Message-Id: <20201214083905.2017260-14-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214083905.2017260-1-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
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
 arch/x86/kvm/x86.c              |  2 ++
 arch/x86/kvm/xen.c              | 26 ++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 56c00a9441a3..b7dfcb4de92a 100644
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
index cbdc05bb53bd..2234fdf49d82 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2729,6 +2729,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
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
index 87d150992f48..f60c5c61761c 100644
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

