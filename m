Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969474705D7
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243688AbhLJQkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243669AbhLJQkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:40:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAFCC0617A2
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=InWCUgUYJLGeO/hhoUYObYArENpRsQYdt3sDsLY0824=; b=nYLhA6ydbmq3nTNkLzyH9rUl1g
        bjhu7owgAWGyE+t+3tzomJSgBrxy8n1uMc0f/v/wUtPdCBOgCI6p1BDftTqymWKMiQBM14MYI23t+
        onP7EoV5MovHd/UieTlHjv4GygRpPfU2gy9X/DimYsrBczmhLIn94wIuLvvEZ2x/Tvf9E9vWFAAGb
        XkXVRHFxzQzMdagXUaVFV4hA7DlhfIyPCGzfnGHLtLC/Ih6ZnFqP/mKFao3E/tcOe1JjTdJ9EbcdB
        QI2UQEagiklLuMPuHsxCxN9M7kNu+KW/bX8yY2pz1hHZZQ6y5q88lHiA0gJm4r6OA0pmdhU732aZF
        Q5Jde1Yw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisk-00AUQw-Qn; Fri, 10 Dec 2021 16:36:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisl-0000lf-3g; Fri, 10 Dec 2021 16:36:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH v6 3/6] KVM: x86/xen: Maintain valid mapping of Xen shared_info page
Date:   Fri, 10 Dec 2021 16:36:22 +0000
Message-Id: <20211210163625.2886-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210163625.2886-1-dwmw2@infradead.org>
References: <20211210163625.2886-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Use the newly reinstated gfn_to_pfn_cache to maintain a kernel mapping
of the Xen shared_info page so that it can be accessed in atomic context.

Note that we do not participate in dirty tracking for the shared info
page and we do not explicitly mark it dirty every single tim we deliver
an event channel interrupts. We wouldn't want to do that even if we *did*
have a valid vCPU context with which to do so.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst  | 12 ++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/xen.c              | 25 ++++++++++++++-----------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..455664c39d42 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -371,6 +371,9 @@ The bits in the dirty bitmap are cleared before the ioctl returns, unless
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is enabled.  For more information,
 see the description of the capability.
 
+Note that the Xen shared info page, if configured, shall always be assumed
+to be dirty. KVM will not explicitly mark it such.
+
 4.9 KVM_SET_MEMORY_ALIAS
 ------------------------
 
@@ -5134,6 +5137,15 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
   not aware of the Xen CPU id which is used as the index into the
   vcpu_info[] array, so cannot know the correct default location.
 
+  Note that the shared info page may be constantly written to by KVM;
+  it contains the event channel bitmap used to deliver interrupts to
+  a Xen guest, amongst other things. It is exempt from dirty tracking
+  mechanisms — KVM will not explicitly mark the page as dirty each
+  time an event channel interrupt is delivered to the guest! Thus,
+  userspace should always assume that the designated GFN is dirty if
+  any vCPU has been running or any event channel interrupts can be
+  routed to the guest.
+
 KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
   Sets the exception vector used to deliver Xen event channel upcalls.
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d5fede05eb5f..a49d503e7296 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1019,7 +1019,7 @@ struct msr_bitmap_range {
 struct kvm_xen {
 	bool long_mode;
 	u8 upcall_vector;
-	gfn_t shinfo_gfn;
+	struct gfn_to_pfn_cache shinfo_cache;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index dff2bdf9507a..da4bf2c6407f 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -23,16 +23,21 @@ DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
 static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 {
+	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 	gpa_t gpa = gfn_to_gpa(gfn);
 	int wc_ofs, sec_hi_ofs;
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	if (kvm_is_error_hva(gfn_to_hva(kvm, gfn))) {
-		ret = -EFAULT;
+	if (gfn == GPA_INVALID) {
+		kvm_gfn_to_pfn_cache_destroy(kvm, gpc);
 		goto out;
 	}
-	kvm->arch.xen.shinfo_gfn = gfn;
+
+	ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, false, true, gpa,
+					PAGE_SIZE, false);
+	if (ret)
+		goto out;
 
 	/* Paranoia checks on the 32-bit struct layout */
 	BUILD_BUG_ON(offsetof(struct compat_shared_info, wc) != 0x900);
@@ -260,15 +265,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		if (data->u.shared_info.gfn == GPA_INVALID) {
-			kvm->arch.xen.shinfo_gfn = GPA_INVALID;
-			r = 0;
-			break;
-		}
 		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
 		break;
 
-
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		if (data->u.vector && data->u.vector < 0x10)
 			r = -EINVAL;
@@ -299,7 +298,10 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		data->u.shared_info.gfn = kvm->arch.xen.shinfo_gfn;
+		if (kvm->arch.xen.shinfo_cache.active)
+			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
+		else
+			data->u.shared_info.gfn = GPA_INVALID;
 		r = 0;
 		break;
 
@@ -661,11 +663,12 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 
 void kvm_xen_init_vm(struct kvm *kvm)
 {
-	kvm->arch.xen.shinfo_gfn = GPA_INVALID;
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
 {
+	kvm_gfn_to_pfn_cache_destroy(kvm, &kvm->arch.xen.shinfo_cache);
+
 	if (kvm->arch.xen_hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 }
-- 
2.31.1

