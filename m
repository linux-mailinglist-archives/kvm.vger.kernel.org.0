Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D004C79A5
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 21:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiB1UHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 15:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiB1UGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 15:06:53 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D98A2E0A9
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 12:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=maZeH5kDzSXVeC1VE2r8jVXeKPQJs5dtO17uunZaXPI=; b=Ma0BFh/y7531ItxPGZJw3KSynn
        lu8gcwGNmqhzkD5SgkgkX0XZYSHz2Y02JTpi8VGRPgR0GBuwmN1m3ZzqHVa0waWNmnNphNsiDQa0n
        oV5hjRrrsFduCsU8ZZR183qR7RPOwGtiC+3wyZxFHEKwx5LGnYsuaJVE5gSRHW5nXDVhQ9FoEFeQE
        19epWGUMnLBve5YkBpwG6RZfcGdXAtoQkJzcvze7C12jDauz4jje7/y4fPWQSyvfs9AD85XqgCQT7
        NX8tvfXwUxFmxUmeikye/HSy6N9le5uoOUYJY3Z28N6a7mIVst2n3n6NkQA+5Z1DtPCoYxbjguYKX
        3ofZ5uZw==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOmHK-00DzoC-Hy; Mon, 28 Feb 2022 20:05:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOmHK-000d9Y-18; Mon, 28 Feb 2022 20:05:54 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v2 07/17] KVM: x86/xen: Make kvm_xen_set_evtchn() reusable from other places
Date:   Mon, 28 Feb 2022 20:05:42 +0000
Message-Id: <20220228200552.150406-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220228200552.150406-1-dwmw2@infradead.org>
References: <20220228200552.150406-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Clean it up to return -errno on error consistently, while still being
compatible with the return conventions for kvm_arch_set_irq_inatomic()
and the kvm_set_irq() callback.

We use -ENOTCONN to indicate when the port is masked. No existing users
care, except that it's negative.

Also allow it to optimise the vCPU lookup. Unless we abuse the lapic
map, there is no quick lookup from APIC ID to a vCPU; the logic in
kvm_get_vcpu_by_id() will just iterate over all vCPUs till it finds
the one it wants. So do that just once and stash the result in the
struct kvm_xen_evtchn for next time.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/irq_comm.c  |  2 +-
 arch/x86/kvm/xen.c       | 83 ++++++++++++++++++++++++++++------------
 arch/x86/kvm/xen.h       |  2 +-
 include/linux/kvm_host.h |  3 +-
 4 files changed, 62 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 6e0dab04320e..0687162c4f22 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -181,7 +181,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 		if (!level)
 			return -1;
 
-		return kvm_xen_set_evtchn_fast(e, kvm);
+		return kvm_xen_set_evtchn_fast(&e->xen_evtchn, kvm);
 #endif
 	default:
 		break;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 65ffba89441a..9c87263a5be2 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -859,13 +859,16 @@ static inline int max_evtchn_port(struct kvm *kvm)
 }
 
 /*
- * This follows the kvm_set_irq() API, so it returns:
+ * The return value from this function is propagated to kvm_set_irq() API,
+ * so it returns:
  *  < 0   Interrupt was ignored (masked or not delivered for other reasons)
  *  = 0   Interrupt was coalesced (previous irq is still pending)
  *  > 0   Number of CPUs interrupt was delivered to
+ *
+ * It is also called directly from kvm_arch_set_irq_inatomic(), where the
+ * only check on its return value is a comparison with -EWOULDBLOCK'.
  */
-int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
-			    struct kvm *kvm)
+int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 {
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 	struct kvm_vcpu *vcpu;
@@ -873,18 +876,23 @@ int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
 	unsigned long flags;
 	int port_word_bit;
 	bool kick_vcpu = false;
-	int idx;
-	int rc;
+	int vcpu_idx, idx, rc;
 
-	vcpu = kvm_get_vcpu_by_id(kvm, e->xen_evtchn.vcpu);
-	if (!vcpu)
-		return -1;
+	vcpu_idx = READ_ONCE(xe->vcpu_idx);
+	if (vcpu_idx >= 0)
+		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
+	else {
+		vcpu = kvm_get_vcpu_by_id(kvm, xe->vcpu_id);
+		if (!vcpu)
+			return -EINVAL;
+		WRITE_ONCE(xe->vcpu_idx, kvm_vcpu_get_idx(vcpu));
+	}
 
 	if (!vcpu->arch.xen.vcpu_info_cache.active)
-		return -1;
+		return -EINVAL;
 
-	if (e->xen_evtchn.port >= max_evtchn_port(kvm))
-		return -1;
+	if (xe->port >= max_evtchn_port(kvm))
+		return -EINVAL;
 
 	rc = -EWOULDBLOCK;
 
@@ -898,12 +906,12 @@ int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
 		struct shared_info *shinfo = gpc->khva;
 		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
 		mask_bits = (unsigned long *)&shinfo->evtchn_mask;
-		port_word_bit = e->xen_evtchn.port / 64;
+		port_word_bit = xe->port / 64;
 	} else {
 		struct compat_shared_info *shinfo = gpc->khva;
 		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
 		mask_bits = (unsigned long *)&shinfo->evtchn_mask;
-		port_word_bit = e->xen_evtchn.port / 32;
+		port_word_bit = xe->port / 32;
 	}
 
 	/*
@@ -913,10 +921,10 @@ int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
 	 * already set, then we kick the vCPU in question to write to the
 	 * *real* evtchn_pending_sel in its own guest vcpu_info struct.
 	 */
-	if (test_and_set_bit(e->xen_evtchn.port, pending_bits)) {
+	if (test_and_set_bit(xe->port, pending_bits)) {
 		rc = 0; /* It was already raised */
-	} else if (test_bit(e->xen_evtchn.port, mask_bits)) {
-		rc = -1; /* Masked */
+	} else if (test_bit(xe->port, mask_bits)) {
+		rc = -ENOTCONN; /* Masked */
 	} else {
 		rc = 1; /* Delivered to the bitmap in shared_info. */
 		/* Now switch to the vCPU's vcpu_info to set the index and pending_sel */
@@ -962,17 +970,12 @@ int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
 	return rc;
 }
 
-/* This is the version called from kvm_set_irq() as the .set function */
-static int evtchn_set_fn(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
-			 int irq_source_id, int level, bool line_status)
+static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 {
 	bool mm_borrowed = false;
 	int rc;
 
-	if (!level)
-		return -1;
-
-	rc = kvm_xen_set_evtchn_fast(e, kvm);
+	rc = kvm_xen_set_evtchn_fast(xe, kvm);
 	if (rc != -EWOULDBLOCK)
 		return rc;
 
@@ -1016,7 +1019,7 @@ static int evtchn_set_fn(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm
 		struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 		int idx;
 
-		rc = kvm_xen_set_evtchn_fast(e, kvm);
+		rc = kvm_xen_set_evtchn_fast(xe, kvm);
 		if (rc != -EWOULDBLOCK)
 			break;
 
@@ -1033,11 +1036,27 @@ static int evtchn_set_fn(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm
 	return rc;
 }
 
+/* This is the version called from kvm_set_irq() as the .set function */
+static int evtchn_set_fn(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+			 int irq_source_id, int level, bool line_status)
+{
+	if (!level)
+		return -EINVAL;
+
+	return kvm_xen_set_evtchn(&e->xen_evtchn, kvm);
+}
+
+/*
+ * Set up an event channel interrupt from the KVM IRQ routing table.
+ * Used for e.g. PIRQ from passed through physical devices.
+ */
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue)
 
 {
+	struct kvm_vcpu *vcpu;
+
 	if (ue->u.xen_evtchn.port >= max_evtchn_port(kvm))
 		return -EINVAL;
 
@@ -1045,8 +1064,22 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
 	if (ue->u.xen_evtchn.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
 		return -EINVAL;
 
+	/*
+	 * Xen gives us interesting mappings from vCPU index to APIC ID,
+	 * which means kvm_get_vcpu_by_id() has to iterate over all vCPUs
+	 * to find it. Do that once at setup time, instead of every time.
+	 * But beware that on live update / live migration, the routing
+	 * table might be reinstated before the vCPU threads have finished
+	 * recreating their vCPUs.
+	 */
+	vcpu = kvm_get_vcpu_by_id(kvm, ue->u.xen_evtchn.vcpu);
+	if (vcpu)
+		e->xen_evtchn.vcpu_idx = kvm_vcpu_get_idx(vcpu);
+	else
+		e->xen_evtchn.vcpu_idx = -1;
+
 	e->xen_evtchn.port = ue->u.xen_evtchn.port;
-	e->xen_evtchn.vcpu = ue->u.xen_evtchn.vcpu;
+	e->xen_evtchn.vcpu_id = ue->u.xen_evtchn.vcpu;
 	e->xen_evtchn.priority = ue->u.xen_evtchn.priority;
 	e->set = evtchn_set_fn;
 
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 7dd0590f93e1..e28feb32add6 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -25,7 +25,7 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_init_vm(struct kvm *kvm);
 void kvm_xen_destroy_vm(struct kvm *kvm);
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu);
-int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
+int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
 			    struct kvm *kvm);
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0d3bda6f14c0..aa596fd19578 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -602,7 +602,8 @@ struct kvm_hv_sint {
 
 struct kvm_xen_evtchn {
 	u32 port;
-	u32 vcpu;
+	u32 vcpu_id;
+	int vcpu_idx;
 	u32 priority;
 };
 
-- 
2.33.1

