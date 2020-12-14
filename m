Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B92D2D943B
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 09:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439341AbgLNIkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 03:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439327AbgLNIjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 03:39:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E74C061793
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 00:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dpU7EpXmnSNHkV8Bf2XAsM/PcDFJkfLpM9gNT+0TuwM=; b=GM+Hrd5z/yI1KVrEqSNFCl4Bur
        rQGHoDmEGD8sGUlLuzJpJ90rGDAn0ONUFqTWmwtG4n+GY7VXjCvwSOnQpjRCvl7sMIBZpU9evX4sL
        FzZyY3/HFRNzuMsovhBbaqnWpkGlxLwUoOge4IQcXUl6lMJTxOfWmYfQV0MYj0rFecE/Nq3IU0iIg
        9LM76zup6dRD8rSHh2Msn4iGc0LoIhtxo6pRuMH1aBoRmqTuSzgYhmpJjbykHL6mJC74gvNUsZUGB
        6dIKzvbDNqUqsFgwNGK4mTs/FekR5MPkBbO2GRAdZwqs6rO+djaOIAH7hvbdNw9rL11saMJuyqj2v
        iZDfz5dg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kojNs-00028e-5W; Mon, 14 Dec 2020 08:39:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kojNr-008Sxr-Nh; Mon, 14 Dec 2020 08:39:07 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: [PATCH v3 08/17] KVM: x86/xen: register shared_info page
Date:   Mon, 14 Dec 2020 08:38:56 +0000
Message-Id: <20201214083905.2017260-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214083905.2017260-1-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

We add a new ioctl, XEN_HVM_SHARED_INFO, to allow hypervisor
to know where the guest's shared info page is.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/xen.c              | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/xen.h              |  1 -
 include/uapi/linux/kvm.h        |  4 ++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c9a4feaee2e7..8bcd83dacf43 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -893,6 +893,8 @@ struct msr_bitmap_range {
 /* Xen emulation context */
 struct kvm_xen {
 	bool long_mode;
+	bool shinfo_set;
+	struct gfn_to_hva_cache shinfo_cache;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 52cb9e465542..9dd9c42842b8 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -13,9 +13,23 @@
 #include <linux/kvm_host.h>
 
 #include <trace/events/kvm.h>
+#include <xen/interface/xen.h>
 
 #include "trace.h"
 
+static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
+{
+	int ret;
+
+	ret = kvm_gfn_to_hva_cache_init(kvm, &kvm->arch.xen.shinfo_cache,
+					gfn_to_gpa(gfn), PAGE_SIZE);
+	if (ret)
+		return ret;
+
+	kvm->arch.xen.shinfo_set = true;
+	return 0;
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
@@ -28,6 +42,11 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		kvm->arch.xen.long_mode = !!data->u.long_mode;
 		r = 0;
 		break;
+
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
+		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
+		break;
+
 	default:
 		break;
 	}
@@ -44,6 +63,14 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
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
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index cd3c52b62068..120b7450252a 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -13,7 +13,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
-void kvm_xen_destroy_vm(struct kvm *kvm);
 
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6b556ef98b76..caa9faf3c5ad 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1585,11 +1585,15 @@ struct kvm_xen_hvm_attr {
 
 	union {
 		__u8 long_mode;
+		struct {
+			__u64 gfn;
+		} shared_info;
 		__u64 pad[4];
 	} u;
 };
 
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.26.2

