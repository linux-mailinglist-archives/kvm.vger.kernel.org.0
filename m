Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7464E2D0318
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgLFLEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 06:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLFLEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 06:04:16 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D4DC0613D4
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 03:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RaddUgsDseJfkus5sbsM6ZbzFgc5eINIiXu3UzWp/ys=; b=18bCujpLU6jN9NpUv6x3xoY65k
        ssAMD05jgCOL8JFUTSK4QgsiN1KpF2gt8IUZZB3F39Dyr+QiIKvei0acyTDVq7V8OkECRu2X1tfWG
        DEu4c+BvF+kWu7xFl2yQiDdGaCwcPmr8uJSODC2zsWt21Zz7pqrhnyI+g7bOdpWe5C8y0GWQxcm6+
        KXbph28DR37OmfEdjHpsaWE3ZjoW+As/CdX9fe9emVWnHXu0k3daQFQ9RUyxA3FPkTy+1ba2J7u/D
        7SL6t1m0Oy0XM5wl1B5LspO2N2xoY84sL1+moiQFNW1Ysl+pxOoIAWNiaaAr/huegDqQlZiRdDRfg
        dhXRGrdA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klrpE-0004tI-OJ; Sun, 06 Dec 2020 11:03:32 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1klrpD-000jpM-MF; Sun, 06 Dec 2020 11:03:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de
Subject: [PATCH v2 05/16] KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR
Date:   Sun,  6 Dec 2020 11:03:16 +0000
Message-Id: <20201206110327.175629-6-dwmw2@infradead.org>
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

This will be used to set up shared info pages etc.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c       | 20 ++++++++++++++++++++
 arch/x86/kvm/xen.c       | 24 ++++++++++++++++++++++++
 arch/x86/kvm/xen.h       |  3 +++
 include/linux/kvm_host.h | 30 +++++++++++++++---------------
 include/uapi/linux/kvm.h | 11 +++++++++++
 5 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5394dda3e3b0..975ef5d6dda1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5595,6 +5595,26 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_XEN_HVM_GET_ATTR: {
+		struct kvm_xen_hvm_attr xha;
+
+		r = -EFAULT;
+		if (copy_from_user(&xha, argp, sizeof(xha)))
+			goto out;
+		r = kvm_xen_hvm_get_attr(kvm, &xha);
+		if (copy_to_user(argp, &xha, sizeof(xha)))
+			goto out;
+		break;
+	}
+	case KVM_XEN_HVM_SET_ATTR: {
+		struct kvm_xen_hvm_attr xha;
+
+		r = -EFAULT;
+		if (copy_from_user(&xha, argp, sizeof(xha)))
+			goto out;
+		r = kvm_xen_hvm_set_attr(kvm, &xha);
+		break;
+	}
 	case KVM_SET_CLOCK: {
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 503935d8212e..c0b2c67e0235 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -16,6 +16,30 @@
 
 #include "trace.h"
 
+int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	int r = -ENOENT;
+
+	switch (data->type) {
+	default:
+		break;
+	}
+
+	return r;
+}
+
+int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	int r = -ENOENT;
+
+	switch (data->type) {
+	default:
+		break;
+	}
+
+	return r;
+}
+
 int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 81e12f716d2e..afc6dad41fb5 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,8 +9,11 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
+int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
+void kvm_xen_destroy_vm(struct kvm *kvm);
 
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8eb5eb1399f5..846a010f5d5f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -33,6 +33,21 @@
 
 #include <linux/kvm_types.h>
 
+struct kvm_host_map {
+	/*
+	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
+	 * a 'struct page' for it. When using mem= kernel parameter some memory
+	 * can be used as guest memory but they are not managed by host
+	 * kernel).
+	 * If 'pfn' is not managed by the host kernel, this field is
+	 * initialized to KVM_UNMAPPED_PAGE.
+	 */
+	struct page *page;
+	void *hva;
+	kvm_pfn_t pfn;
+	kvm_pfn_t gfn;
+};
+
 #include <asm/kvm_host.h>
 
 #ifndef KVM_MAX_VCPU_ID
@@ -225,21 +240,6 @@ enum {
 
 #define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
 
-struct kvm_host_map {
-	/*
-	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
-	 * a 'struct page' for it. When using mem= kernel parameter some memory
-	 * can be used as guest memory but they are not managed by host
-	 * kernel).
-	 * If 'pfn' is not managed by the host kernel, this field is
-	 * initialized to KVM_UNMAPPED_PAGE.
-	 */
-	struct page *page;
-	void *hva;
-	kvm_pfn_t pfn;
-	kvm_pfn_t gfn;
-};
-
 /*
  * Used to check if the mapping is valid or not. Never use 'kvm_host_map'
  * directly to check for that.
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6b593a23cd41..3d9ac2f4dc10 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1577,6 +1577,17 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_X86_MSR_FILTER */
 #define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
 
+#define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc7, struct kvm_xen_hvm_attr)
+#define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc8, struct kvm_xen_hvm_attr)
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+
+	union {
+		__u64 pad[4];
+	} u;
+};
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.26.2

