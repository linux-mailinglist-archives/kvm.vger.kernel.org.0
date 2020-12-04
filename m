Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E39D2CE4EA
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388361AbgLDBUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388169AbgLDBUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:10 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BFDC061A56
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yXOzitL3Rs2Ssfb6JgsWCDmAOI7PE0Yl/pr6Bf4inFo=; b=bv9PpQQ4IHvSrZpNNWk/ws061J
        A7duLkO4twiwEsZgBVdoyr6TOZbzCvhLJSrvUQaHtqDa1EtK8p1vSBZEEej7vAjcaAg+xlb7+XRvg
        iFD3ZXQfikoneIKQEgtGKHZJ0LTdlZAqsZZSrUitlsZmDCkYByfV6tyhj9EesSyXm5VngU4v4mcYq
        Nc8yVLDcrMZhL3UvFWXyXVuYoN7hadrbgNvyHzf4PK+qa7kI3EqVaMAPiyVVmTrAxna1K5+JMrZ2h
        lCmRfPcmW6DCUfm/PXDa+P9IQVEY8qAy0mvsgzMfJ/pNRY9bhIMKPp1Y3p0lQ56xmYMNXB82ljnkx
        AeknrCFQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkL-0002k0-Dd; Fri, 04 Dec 2020 01:18:53 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CSA5-BQ; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 08/15] KVM: x86/xen: register shared_info page
Date:   Fri,  4 Dec 2020 01:18:41 +0000
Message-Id: <20201204011848.2967588-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

We add a new ioctl, XEN_HVM_SHARED_INFO, to allow hypervisor
to know where the guest's shared info page is.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/x86.c              |  1 +
 arch/x86/kvm/xen.c              | 69 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  4 ++
 4 files changed, 76 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c9a4feaee2e7..b6eff9814c6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -893,6 +893,8 @@ struct msr_bitmap_range {
 /* Xen emulation context */
 struct kvm_xen {
 	bool long_mode;
+	struct kvm_host_map shinfo_map;
+	void *shinfo;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1cc4fe5ff52d..156ce72ba9bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10445,6 +10445,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_mmu_uninit_vm(kvm);
 	kvm_page_track_cleanup(kvm);
 	kvm_hv_destroy_vm(kvm);
+	kvm_xen_destroy_vm(kvm);
 }
 
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 52cb9e465542..c156ed1ef972 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -13,9 +13,51 @@
 #include <linux/kvm_host.h>
 
 #include <trace/events/kvm.h>
+#include <xen/interface/xen.h>
 
 #include "trace.h"
 
+static int kvm_xen_map_guest_page(struct kvm *kvm, struct kvm_host_map *map,
+				  void **hva, gpa_t gpa, size_t len)
+{
+	gfn_t gfn = gpa_to_gfn(gpa);
+	struct kvm_host_map new_map;
+	bool unmap = !!*hva;
+	int ret;
+
+	if (offset_in_page(gpa) + len > PAGE_SIZE)
+		return -EINVAL;
+
+	ret = kvm_map_gfn(kvm, gfn, &new_map, NULL, false);
+	if (ret)
+		return ret;
+
+	WRITE_ONCE(*hva, new_map.hva + offset_in_page(gpa));
+
+	if (unmap) {
+	        synchronize_srcu(&kvm->srcu);
+
+		kvm_unmap_gfn(kvm, map, NULL, true, false);
+	}
+
+	*map = new_map;
+	return 0;
+}
+
+static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
+{
+	gpa_t gpa = gfn_to_gpa(gfn);
+	int ret;
+
+	ret = kvm_xen_map_guest_page(kvm, &kvm->arch.xen.shinfo_map,
+				     (void **)&kvm->arch.xen.shinfo, gpa,
+				     PAGE_SIZE);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
@@ -28,6 +70,14 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		kvm->arch.xen.long_mode = !!data->u.long_mode;
 		r = 0;
 		break;
+
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO: {
+		gfn_t gfn = data->u.shared_info.gfn;
+
+		r = kvm_xen_shared_info_init(kvm, gfn);
+		break;
+	}
+
 	default:
 		break;
 	}
@@ -44,6 +94,15 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		data->u.long_mode = kvm->arch.xen.long_mode;
 		r = 0;
 		break;
+
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO: {
+		if (kvm->arch.xen.shinfo) {
+			data->u.shared_info.gfn = kvm->arch.xen.shinfo_map.gfn;
+			r = 0;
+		}
+		break;
+	}
+
 	default:
 		break;
 	}
@@ -182,3 +241,13 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 
 	return 0;
 }
+
+void kvm_xen_destroy_vm(struct kvm *kvm)
+{
+	struct kvm_xen *xen = &kvm->arch.xen;
+
+	if (xen->shinfo) {
+		kvm_unmap_gfn(kvm, &xen->shinfo_map, NULL, true, false);
+		xen->shinfo = NULL;
+	}
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e297c910f3e4..3bcd04e4e38f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1584,11 +1584,15 @@ struct kvm_xen_hvm_attr {
 
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

