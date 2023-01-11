Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A910866627F
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbjAKSHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbjAKSG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:06:59 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1819218B20
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=M7OewXuuc2RwiC+Z+c7QuSOrIFr3cHINnhaYsxajvJ0=; b=UvcDXRfrcQhpLdPgWH54u/HBfv
        /6cbWRBQbz0rkgEhQO9J4YUZ+OZ77LRgLFgcJubWm7GvJo3DNG147Hn+5VV0CX5Bpnf+7FHjskY+o
        OUzZgOpShv3Gh0LakFITjF9LQY7PHaJHi+H5iZux4Y+6Lx99KPFw7c9eyX3SzLvrICHKrUikIrpLz
        SUJ2M24+kR3TSQ9GRxvZAlBxrcfxobdRaA8ADoHoRiy1B3TcsHCWSo8/s8UfCQuvnayCu5SrqTm86
        naSf64NSYsAgt2Hnh8B+NWM/aXadxCvNzMsEfywtpz3CGgIj0RJTyxbkKLnqqCuK3aDue2bisGxLG
        EQi4+mqw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pFfUp-003lME-1t;
        Wed, 11 Jan 2023 18:06:43 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFfUx-0003kX-7X; Wed, 11 Jan 2023 18:06:51 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, paul <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 4/4] KVM: x86/xen: Avoid deadlock by adding kvm->arch.xen.xen_lock leaf node lock
Date:   Wed, 11 Jan 2023 18:06:51 +0000
Message-Id: <20230111180651.14394-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230111180651.14394-1-dwmw2@infradead.org>
References: <20230111180651.14394-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In commit 14243b387137a ("KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN
and event channel delivery") the clever version of me left some helpful
notes for those who would come after him:

       /*
        * For the irqfd workqueue, using the main kvm->lock mutex is
        * fine since this function is invoked from kvm_set_irq() with
        * no other lock held, no srcu. In future if it will be called
        * directly from a vCPU thread (e.g. on hypercall for an IPI)
        * then it may need to switch to using a leaf-node mutex for
        * serializing the shared_info mapping.
        */
       mutex_lock(&kvm->lock);

In commit 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
the other version of me ran straight past that comment without reading it,
and introduced a potential deadlock by taking vcpu->mutex and kvm->lock
in the wrong order.

Solve this as originally suggested, by adding a leaf-node lock in the Xen
state rather than using kvm->lock for it.

Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/xen.c              | 65 +++++++++++++++------------------
 2 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2f5bf581d00a..4ef0143fa682 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1115,6 +1115,7 @@ struct msr_bitmap_range {
 
 /* Xen emulation context */
 struct kvm_xen {
+	struct mutex xen_lock;
 	u32 xen_version;
 	bool long_mode;
 	bool runstate_update_flag;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 809b82bdb9c3..8bebc41f8f9e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -608,26 +608,26 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
 			r = -EINVAL;
 		} else {
-			mutex_lock(&kvm->lock);
+			mutex_lock(&kvm->arch.xen.xen_lock);
 			kvm->arch.xen.long_mode = !!data->u.long_mode;
-			mutex_unlock(&kvm->lock);
+			mutex_unlock(&kvm->arch.xen.xen_lock);
 			r = 0;
 		}
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.xen.xen_lock);
 		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
 		break;
 
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		if (data->u.vector && data->u.vector < 0x10)
 			r = -EINVAL;
 		else {
-			mutex_lock(&kvm->lock);
+			mutex_lock(&kvm->arch.xen.xen_lock);
 			kvm->arch.xen.upcall_vector = data->u.vector;
-			mutex_unlock(&kvm->lock);
+			mutex_unlock(&kvm->arch.xen.xen_lock);
 			r = 0;
 		}
 		break;
@@ -637,9 +637,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_XEN_VERSION:
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.xen.xen_lock);
 		kvm->arch.xen.xen_version = data->u.xen_version;
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
 		r = 0;
 		break;
 
@@ -648,9 +648,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 			r = -EOPNOTSUPP;
 			break;
 		}
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.xen.xen_lock);
 		kvm->arch.xen.runstate_update_flag = !!data->u.runstate_update_flag;
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
 		r = 0;
 		break;
 
@@ -665,7 +665,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
@@ -704,7 +704,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 	return r;
 }
 
@@ -712,7 +712,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 {
 	int idx, r = -ENOENT;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.xen.xen_lock);
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	switch (data->type) {
@@ -940,7 +940,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 	}
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.xen.xen_lock);
 	return r;
 }
 
@@ -948,7 +948,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 {
 	int r = -ENOENT;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.xen.xen_lock);
 
 	switch (data->type) {
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
@@ -1031,7 +1031,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		break;
 	}
 
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.xen.xen_lock);
 	return r;
 }
 
@@ -1124,7 +1124,7 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 	     xhc->blob_size_32 || xhc->blob_size_64))
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 
 	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
 		static_branch_inc(&kvm_xen_enabled.key);
@@ -1133,7 +1133,7 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 
 	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 	return 0;
 }
 
@@ -1676,15 +1676,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		mm_borrowed = true;
 	}
 
-	/*
-	 * For the irqfd workqueue, using the main kvm->lock mutex is
-	 * fine since this function is invoked from kvm_set_irq() with
-	 * no other lock held, no srcu. In future if it will be called
-	 * directly from a vCPU thread (e.g. on hypercall for an IPI)
-	 * then it may need to switch to using a leaf-node mutex for
-	 * serializing the shared_info mapping.
-	 */
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 
 	/*
 	 * It is theoretically possible for the page to be unmapped
@@ -1713,7 +1705,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 
 	if (mm_borrowed)
 		kthread_unuse_mm(kvm->mm);
@@ -1829,7 +1821,7 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 	int ret;
 
 	/* Protect writes to evtchnfd as well as the idr lookup.  */
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 	evtchnfd = idr_find(&kvm->arch.xen.evtchn_ports, port);
 
 	ret = -ENOENT;
@@ -1860,7 +1852,7 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 	}
 	ret = 0;
 out_unlock:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 	return ret;
 }
 
@@ -1923,10 +1915,10 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
 		evtchnfd->deliver.port.priority = data->u.evtchn.deliver.port.priority;
 	}
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 	ret = idr_alloc(&kvm->arch.xen.evtchn_ports, evtchnfd, port, port + 1,
 			GFP_KERNEL);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 	if (ret >= 0)
 		return 0;
 
@@ -1944,9 +1936,9 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
 {
 	struct evtchnfd *evtchnfd;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 	evtchnfd = idr_remove(&kvm->arch.xen.evtchn_ports, port);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 
 	if (!evtchnfd)
 		return -ENOENT;
@@ -1963,7 +1955,7 @@ static int kvm_xen_eventfd_reset(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		idr_remove(&kvm->arch.xen.evtchn_ports, evtchnfd->send_port);
 		synchronize_srcu(&kvm->srcu);
@@ -1971,7 +1963,7 @@ static int kvm_xen_eventfd_reset(struct kvm *kvm)
 			eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
 		kfree(evtchnfd);
 	}
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 
 	return 0;
 }
@@ -2063,6 +2055,7 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 
 void kvm_xen_init_vm(struct kvm *kvm)
 {
+	mutex_init(&kvm->arch.xen.xen_lock);
 	idr_init(&kvm->arch.xen.evtchn_ports);
 	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN);
 }
-- 
2.35.3

