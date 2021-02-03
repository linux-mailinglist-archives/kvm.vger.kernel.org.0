Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222B730DD7E
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhBCPCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhBCPCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:42 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF209C0617A9
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Wb9QPaURw0jsH0SoZ9RC5YIxLVuDMsFj80syaL6x0E4=; b=BCC7WgyhyXKjePTniPmAd9z+eo
        ir/HcIccUsUqE9MMZehlgbX5t4J5h1elhBOC3EbJfrOXe6WCXLEB6DGTu4AqIRP9/oKGoZ4o1WXIw
        +skMV1kLkI9QGjL4cj9dAGdb8O4Ezw9obdPQN2k5pkoDYnu1TmPMZX12z23cmrupVrjAzJ3zpvOmO
        QRKcajgst4mGRuIsgFYlq7qw4Lx9m0DHUrzvTm9+0HZnKZl3NkgqXqsAjVUhGnW+en4tsxalYPWvL
        Csn7PeLvQU9F1bKrRKjLFlhFZBIzmvAtwUELOZfqIKv1kfvD7WuZIfaKSp/x8ML5+T9Shv/BCeU0C
        +FskNwmA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Jeg-00015n-B0; Wed, 03 Feb 2021 15:01:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003reW-7j; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 08/19] KVM: x86/xen: latch long_mode when hypercall page is set up
Date:   Wed,  3 Feb 2021 15:01:03 +0000
Message-Id: <20210203150114.920335-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
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
index cf2af8efebe8..4ca6e060b578 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -894,6 +894,11 @@ struct msr_bitmap_range {
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
@@ -973,6 +978,7 @@ struct kvm_arch {
 	struct hlist_head mask_notifier_list;
 
 	struct kvm_hv hyperv;
+	struct kvm_xen xen;
 
 	#ifdef CONFIG_KVM_MMU_AUDIT
 	int audit_point;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a3fd791b0354..55da739267b1 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -25,6 +25,13 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 	mutex_unlock(&kvm->lock);
 
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
@@ -40,6 +47,10 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 	mutex_lock(&kvm->lock);
 
 	switch (data->type) {
+	case KVM_XEN_ATTR_TYPE_LONG_MODE:
+		data->u.long_mode = kvm->arch.xen.long_mode;
+		r = 0;
+		break;
 	default:
 		break;
 	}
@@ -53,6 +64,10 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 	struct kvm *kvm = vcpu->kvm;
 	u32 page_num = data & ~PAGE_MASK;
 	u64 page_addr = data & PAGE_MASK;
+	bool lm = is_long_mode(vcpu);
+
+	/* Latch long_mode for shared_info pages etc. */
+	vcpu->kvm->arch.xen.long_mode = lm;
 
 	/*
 	 * If Xen hypercall intercept is enabled, fill the hypercall
@@ -87,7 +102,6 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 				return 1;
 		}
 	} else {
-		int lm = is_long_mode(vcpu);
 		u64 blob_addr = lm ? kvm->arch.xen_hvm_config.blob_addr_64
 				   : kvm->arch.xen_hvm_config.blob_addr_32;
 		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 71b8ca359265..e3ed21c333af 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1592,10 +1592,13 @@ struct kvm_xen_hvm_attr {
 	__u16 type;
 	__u16 pad[3];
 	union {
+		__u8 long_mode;
 		__u64 pad[8];
 	} u;
 };
 
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.29.2

