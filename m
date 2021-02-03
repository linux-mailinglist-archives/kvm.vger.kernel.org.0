Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06E30DD79
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhBCPCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbhBCPCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:02:37 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B410BC061793
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1LZnHnkJoj83CWKXZ2KE3LaHlvqELAYLDYL0G3j8qFg=; b=C8dowhUvLWGVTp3FrXl+LQph/8
        GtqbbTDrjb4rnZeGf7Q2Cv6YdlCmVoC8I0Vh3fWWdTffSWPLUa2oKRwdoUiMGq+xLSZUq/jh+Tnv3
        fgJ0l4EiIMFEjSB1HMlDxx+IuQmpeRjIT7lA+pW6G20vNJonUWgvLEA0lOYMjBROvhAgcnthxteKi
        7etLs6LRU7kUgW35BuP9d01sBkjkFhbWja9jl/ze4bQnKSh6r4QmeIye7EaJMM38QRDF9p4CeBiYo
        GlsnBzbQQSsa7i8eQm0I4EnDDJ0BlJNxhK81b7uCENwkQ7rHIR4GCJtDHTJz15Iu4WRQIfzzTxXnH
        0MnrN0Yg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7Jeg-00015o-Bh; Wed, 03 Feb 2021 15:01:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003rec-9A; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 10/19] KVM: x86/xen: register shared_info page
Date:   Wed,  3 Feb 2021 15:01:05 +0000
Message-Id: <20210203150114.920335-11-dwmw2@infradead.org>
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

From: Joao Martins <joao.m.martins@oracle.com>

Add KVM_XEN_ATTR_TYPE_SHARED_INFO to allow hypervisor to know where the
guest's shared info page is.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/xen.c              | 40 +++++++++++++++++++++++++++++----
 include/uapi/linux/kvm.h        |  4 ++++
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4ca6e060b578..07ae5887afa1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -897,6 +897,8 @@ struct msr_bitmap_range {
 /* Xen emulation context */
 struct kvm_xen {
 	bool long_mode;
+	bool shinfo_set;
+	struct gfn_to_hva_cache shinfo_cache;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 55da739267b1..924d4e853108 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -13,25 +13,49 @@
 #include <linux/kvm_host.h>
 
 #include <trace/events/kvm.h>
+#include <xen/interface/xen.h>
 
 #include "trace.h"
 
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
+static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
+{
+	int ret;
+	int idx = srcu_read_lock(&kvm->srcu);
+
+	ret = kvm_gfn_to_hva_cache_init(kvm, &kvm->arch.xen.shinfo_cache,
+					gfn_to_gpa(gfn), PAGE_SIZE);
+	if (!ret) {
+		kvm->arch.xen.shinfo_set = true;
+	}
+
+	srcu_read_unlock(&kvm->srcu, idx);
+	return ret;
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
 
+	mutex_lock(&kvm->lock);
+
 	mutex_unlock(&kvm->lock);
 
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
-		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode)
-			return -EINVAL;
+		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
+			r = -EINVAL;
+		} else {
+			kvm->arch.xen.long_mode = !!data->u.long_mode;
+			r = 0;
+		}
+		break;
 
-		kvm->arch.xen.long_mode = !!data->u.long_mode;
-		r = 0;
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
+		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
 		break;
+
 	default:
 		break;
 	}
@@ -51,6 +75,14 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		data->u.long_mode = kvm->arch.xen.long_mode;
 		r = 0;
 		break;
+
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
+		if (kvm->arch.xen.shinfo_set) {
+			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e3ed21c333af..3c5b7ca7dce3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1593,11 +1593,15 @@ struct kvm_xen_hvm_attr {
 	__u16 pad[3];
 	union {
 		__u8 long_mode;
+		struct {
+			__u64 gfn;
+		} shared_info;
 		__u64 pad[8];
 	} u;
 };
 
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.29.2

