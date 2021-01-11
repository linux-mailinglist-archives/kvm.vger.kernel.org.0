Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4F2F2034
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 20:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391413AbhAKT6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391280AbhAKT6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 14:58:53 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B14DC0617A6
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 11:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fM/Edm8ws3OR84ugO2auApPCSjtZhOaO3u6TKN/TtAM=; b=J2J0UI0KIi7PIGNa2gJTlFMB2o
        MhzAfZaeL1WpfEpNHgDf+QJmnPFJUoJDW+FyLQ36XMHOW4ZvJPenQSgz/Ofn09pbMj/sMoAOhz1b5
        peYM91Q70ABZJNaX8KU6MdIs/oReTi7MYi22f4D9wrKCBmc7nLprsXqc71FAZ3qr6Jj1dIPn8SK2I
        ElM7fpmMFtxMabAXXePKcnw6UPIDyglPIG1Y1wexyDFiGALY6mS8CHNyC/xG/lAn0zImnhwdXPX8h
        Zpu+XokFBvBHvj5rAsC7gVb8ZEvMk8Gx51JJaskgTmEq05tiya6QU84acIn3di1IDscX0OYrUaw6L
        F0H7iQtw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kz3Jg-0001h5-Js; Mon, 11 Jan 2021 19:57:29 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz3Jf-0001Ha-HU; Mon, 11 Jan 2021 19:57:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v5 05/16] KVM: x86/xen: latch long_mode when hypercall page is set up
Date:   Mon, 11 Jan 2021 19:57:14 +0000
Message-Id: <20210111195725.4601-6-dwmw2@infradead.org>
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
index 31d4eb100efd..3293866d5ee1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1592,10 +1592,13 @@ struct kvm_xen_hvm_attr {
 	__u16 type;
 	__u16 pad[3];
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
2.29.2

