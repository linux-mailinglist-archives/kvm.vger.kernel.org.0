Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276BA2CE4F0
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbgLDBUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388438AbgLDBUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749ACC08E862
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=R2vUNqAF4JwuTdyq1tWsiIAQjtZTYr/ZlynGak/XgAI=; b=IEuscKRQgxVJ5Yw/NgJ6y04WDx
        P+J0zDqqe+LXEeF0x45S+tYc+4gjMBJmr26lbwBB/doz833LQrHX8wtORFbU9r89bUC+DFblHgw+n
        OYgbW8A4eMrq2TGt4oMPHafAe7+IwtTOrwiLf//mFqKWajDzjSW/1czbm0/KwgYwN/percAa0dLPj
        kl+mUTsY9KnMXR+CiUVnEXi/QsBIShcL7IjTgdyulPakgWjZkyk4dWOaeYsKBs7BN4jQirQe5SUPd
        z/TBHq9ITvBi795UuIt6A6XkPNI3uoGzgD4B+jfebltl/ln41BaFtlxr2aLxLkKrKigdpLSG1UbDu
        bt2Aqz+A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkK-0004Kb-Or; Fri, 04 Dec 2020 01:18:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CS9z-AO; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 06/15] KVM: x86/xen: latch long_mode when hypercall page is set up
Date:   Fri,  4 Dec 2020 01:18:39 +0000
Message-Id: <20201204011848.2967588-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
index f652b5deedde..e297c910f3e4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1583,10 +1583,13 @@ struct kvm_xen_hvm_attr {
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

