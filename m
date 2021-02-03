Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB2830DD84
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhBCPDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbhBCPC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46DAC06121D
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Fbgx4u7VtAv3LBgqnbcYbp9lV1zW3p5uHBkcW5ty0cE=; b=NjjIAUQ9SS3FUfLRoAO/eBCoio
        2JikgSZgvSHC3Z/QLXbYMNKiDw1Bg/UXJkQJUXsGYVX//dp6i/VqDd4XxE8jJfgn9bsSpjuKBk2+X
        7RcWlx90wuow2PfA2Xz4Z1ExhKDlS8h4wDpe7rVtJwrI/cMFuF1ODA/wQmccFroTw+uqj1J7T8Gu5
        5J7Hw0PIqMl698VC06eXJsCNGtj9eV6jEfTjWlPpsJtrO5mkV1PArOQ0eQNZ7KwFYby7sJsODh//U
        rP2tebM7LqP9I8wQNP636n8YDE1/DD5VOjOvB6btkVXIRSAATbsNX1UJVK66KB36e28dtMPkW9i9l
        ZMVVT/jA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zL-PO; Wed, 03 Feb 2021 15:01:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reo-Cs; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 14/19] KVM: x86/xen: register vcpu info
Date:   Wed,  3 Feb 2021 15:01:09 +0000
Message-Id: <20210203150114.920335-15-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
 arch/x86/kvm/xen.c              | 25 ++++++++++++++++++++++++-
 include/uapi/linux/kvm.h        |  3 +++
 3 files changed, 29 insertions(+), 1 deletion(-)

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
index 5cbf6955e509..2712f1aa9ac9 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -120,15 +120,31 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 
 int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 {
-	int r = -ENOENT;
+	int idx, r = -ENOENT;
 
 	mutex_lock(&vcpu->kvm->lock);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	switch (data->type) {
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
+		/* No compat necessary here. */
+		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
+			     sizeof(struct compat_vcpu_info));
+
+		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
+					      &vcpu->arch.xen.vcpu_info_cache,
+					      data->u.gpa,
+					      sizeof(struct vcpu_info));
+		if (!r)
+			vcpu->arch.xen.vcpu_info_set = true;
+		break;
+
+
 	default:
 		break;
 	}
 
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	mutex_unlock(&vcpu->kvm->lock);
 	return r;
 }
@@ -140,6 +156,13 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 	mutex_lock(&vcpu->kvm->lock);
 
 	switch (data->type) {
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
+		if (vcpu->arch.xen.vcpu_info_set) {
+			data->u.gpa = vcpu->arch.xen.vcpu_info_cache.gpa;
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index af09f07d6d02..a34a35a8f354 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1612,10 +1612,13 @@ struct kvm_xen_vcpu_attr {
 	__u16 type;
 	__u16 pad[3];
 	union {
+		__u64 gpa;
 		__u64 pad[8];
 	} u;
 };
 
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.29.2

