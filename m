Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCE52F202C
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 20:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391396AbhAKT6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391377AbhAKT6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 14:58:13 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DF9C06179F
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 11:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cCxJxylhdPJxP9NvV6aGcy+ZFbUDaJSF1lHjG6wnXMc=; b=R+JyKb7gv+WhzniJZTRhocdCGO
        KhsXcJput5c7GEqaWiDeTrdeLuvgD6eRa+spETCP4dBo3j8AzujVcTiq8EfgKBHBMrBiamyQgKh5P
        NEURPHemzTiaYxiX9Ez957krHFEnvbQLNAz2HG9o3hDqtJ2ISsC/HXdNXLJijXe4+bOsGUNX1wyuL
        5IPKCNJWWf3mzPdBoHNwjTfcZAYlkvGu2Ixu2KxgiSXbLsKgi36aXgcx5T4Qq5w4H96b2sMJPk1Cv
        Cv28FXmna7BM+O4xnW4l+kZnuTswLJLTyH1WZT/cRU3XmkmX/RvUJiwmBFFkfUzy+4lhMfYOJOX8r
        4Cb6stvg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kz3Jg-0001hC-NV; Mon, 11 Jan 2021 19:57:29 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jf-0001Hp-L9; Mon, 11 Jan 2021 19:57:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v5 10/16] KVM: x86/xen: register vcpu info
Date:   Mon, 11 Jan 2021 19:57:19 +0000
Message-Id: <20210111195725.4601-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111195725.4601-1-dwmw2@infradead.org>
References: <20210111195725.4601-1-dwmw2@infradead.org>
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
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/xen.c              | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  5 +++++
 3 files changed, 37 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 07ae5887afa1..421d082d772d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -523,6 +523,8 @@ struct kvm_vcpu_hv {
 /* Xen HVM per vcpu emulation context */
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
+	bool vcpu_info_set;
+	struct gfn_to_hva_cache vcpu_info_cache;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e5117a611737..4bc72e0b9928 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -58,6 +58,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
+	struct kvm_vcpu *v;
 	int r = -ENOENT;
 
 	switch (data->type) {
@@ -73,6 +74,23 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
 		break;
 
+	case KVM_XEN_ATTR_TYPE_VCPU_INFO:
+		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
+		if (!v)
+			return -EINVAL;
+
+		/* No compat necessary here. */
+		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
+			     sizeof(struct compat_vcpu_info));
+		r = kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.vcpu_info_cache,
+					      data->u.vcpu_attr.gpa,
+					      sizeof(struct vcpu_info));
+		if (r)
+			return r;
+
+		v->arch.xen.vcpu_info_set = true;
+		break;
+
 	default:
 		break;
 	}
@@ -83,6 +101,7 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
+	struct kvm_vcpu *v;
 
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
@@ -97,6 +116,17 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		}
 		break;
 
+	case KVM_XEN_ATTR_TYPE_VCPU_INFO:
+		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
+		if (!v)
+			return -EINVAL;
+
+		if (v->arch.xen.vcpu_info_set) {
+			data->u.vcpu_attr.gpa = v->arch.xen.vcpu_info_cache.gpa;
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0c04bb6eda09..5ab0063d109a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1596,12 +1596,17 @@ struct kvm_xen_hvm_attr {
 		struct {
 			__u64 gfn;
 		} shared_info;
+		struct {
+			__u32 vcpu_id;
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
2.29.2

