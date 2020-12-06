Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0453F2D0317
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgLFLEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 06:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFLEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 06:04:16 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA3AC0613D1
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 03:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tBq69FrBfo3FGfDE8wAnuLV0cMI+RANBkpZW+oLWxTs=; b=ojgQbeRJCwP76EdkbwoRvmbumu
        PgnApGv07+3OzfO4VVa9uSyagnxH6ZQ1tsI3f1Bib/p3G2GXpzY38ENryvYPQ3du9y/EzmqprbuBz
        wknzaT5RxITDYL8Mh0nWPoGs7iOCZ5XKlER90twDCs4uF/Xs7Drab30LDartQjzexm1tJkc1sn5Xt
        pTxrEC+govrmCHaM4o7V5aBdust2jOvzxqk6HeXbHiMuItsFFld/qGzU/J543Vcsn6mKuGxa4Q661
        k3lyY6FDlqPrsDi0n3Yimx7OiKXAWW5bHIxUs9dkvKApldtagcYKldUVscYqCm+FC2IyNMIiIFp6T
        J64x3kZg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klrpE-0004tJ-Ok; Sun, 06 Dec 2020 11:03:32 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1klrpD-000jpP-Mr; Sun, 06 Dec 2020 11:03:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de
Subject: [PATCH v2 06/16] KVM: x86/xen: latch long_mode when hypercall page is set up
Date:   Sun,  6 Dec 2020 11:03:17 +0000
Message-Id: <20201206110327.175629-7-dwmw2@infradead.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/xen.c              | 16 +++++++++++++++-
 include/uapi/linux/kvm.h        |  3 +++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9de3229e91e1..c9a4feaee2e7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -890,6 +890,11 @@ struct msr_bitmap_range {
 	unsigned long *bitmap;
 };
 
+/* Xen emulation context */
+struct kvm_xen {
+	bool long_mode;
+};
+
 enum kvm_irqchip_mode {
 	KVM_IRQCHIP_NONE,
 	KVM_IRQCHIP_KERNEL,       /* created with KVM_CREATE_IRQCHIP */
@@ -969,6 +974,7 @@ struct kvm_arch {
 	struct hlist_head mask_notifier_list;
 
 	struct kvm_hv hyperv;
+	struct kvm_xen xen;
 
 	#ifdef CONFIG_KVM_MMU_AUDIT
 	int audit_point;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c0b2c67e0235..52cb9e465542 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -21,6 +21,13 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 	int r = -ENOENT;
 
 	switch (data->type) {
+	case KVM_XEN_ATTR_TYPE_LONG_MODE:
+		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode)
+			return -EINVAL;
+
+		kvm->arch.xen.long_mode = !!data->u.long_mode;
+		r = 0;
+		break;
 	default:
 		break;
 	}
@@ -33,6 +40,10 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 	int r = -ENOENT;
 
 	switch (data->type) {
+	case KVM_XEN_ATTR_TYPE_LONG_MODE:
+		data->u.long_mode = kvm->arch.xen.long_mode;
+		r = 0;
+		break;
 	default:
 		break;
 	}
@@ -45,6 +56,10 @@ int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
 	struct kvm *kvm = vcpu->kvm;
 	u32 page_num = data & ~PAGE_MASK;
 	u64 page_addr = data & PAGE_MASK;
+	bool lm = is_long_mode(vcpu);
+
+	/* Latch long_mode for shared_info pages etc. */
+	vcpu->kvm->arch.xen.long_mode = lm;
 
 	/*
 	 * If Xen hypercall intercept is enabled, fill the hypercall
@@ -79,7 +94,6 @@ int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
 				return 1;
 		}
 	} else {
-		int lm = is_long_mode(vcpu);
 		u8 *blob_addr = lm ? (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_64
 				   : (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_32;
 		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3d9ac2f4dc10..6b556ef98b76 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1584,10 +1584,13 @@ struct kvm_xen_hvm_attr {
 	__u16 type;
 
 	union {
+		__u8 long_mode;
 		__u64 pad[4];
 	} u;
 };
 
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.26.2

