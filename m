Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E622EB6CC
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 01:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbhAFAYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 19:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbhAFAYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 19:24:10 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB02C06179F
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 16:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Bl/X+U+GWKGXkOizMADC+1uhUYiVzybTnXj88JzYPL0=; b=t950RH1JeIhvBMTxymgLPKfBZg
        aTd8X1FxTkTt3WZlf3/yoEWJi09qa8pqsDuqru0yCLg4dQDFHge4uFTWpsg+S15r/YNJDSQ1x0xnW
        ozzR3yGP5V6iIOfO+l5udBQ6hffBhteAxSdGuwn7vEo9giEBSS48ldq/K70uC4uwB3/4C1ImdhMX0
        O5kqZjKuiRPZJvan+Lxb05GLx8OdIcgCH0KTNuirsw1FTgAxTrZLxTVW4qZi7P0PL8hc6+4tkPA+Q
        DaCD55dHwJMSXghURp9hKjFtkOoTeIZ8X85uRfDCy2Jv4huRqbjg1wmW3D/L3aHS+MdcqIEEg7T9E
        o8ysJXsg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kwwbi-0004Zu-Dy; Wed, 06 Jan 2021 00:23:22 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kwwbh-001Niw-By; Wed, 06 Jan 2021 00:23:21 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v4 04/16] KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR
Date:   Wed,  6 Jan 2021 00:23:02 +0000
Message-Id: <20210106002314.328380-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106002314.328380-1-dwmw2@infradead.org>
References: <20210106002314.328380-1-dwmw2@infradead.org>
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
 arch/x86/kvm/xen.h       |  2 ++
 include/linux/kvm_host.h | 30 +++++++++++++++---------------
 include/uapi/linux/kvm.h | 11 +++++++++++
 5 files changed, 72 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e391f4dfe457..600d2b64928e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5618,6 +5618,26 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
index 81e12f716d2e..d06b5afcc1f2 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,6 +9,8 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
+int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..398ed0c99606 100644
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
 #include <linux/kvm_dirty_ring.h>
 
@@ -226,21 +241,6 @@ enum {
 
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
index 32b59efc2c30..7b5fed0cb2ad 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1583,6 +1583,17 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+#define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
+#define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
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
2.29.2

