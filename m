Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A005F5481
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 14:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJEMbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 08:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiJEMbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 08:31:45 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AB822502
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 05:31:43 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1og3Yr-00GbDN-Up; Wed, 05 Oct 2022 14:31:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=3pQ3ilms57JqiE3C7Rj76L3jcxzviL70TszX3K0MirY=; b=KlM/zBM3GYGYPm1jPVwn07q3iI
        v2/NvxmvVSVmQske2nwwW20P2+j592KdzWDEoIBxO4VFaUvLRLDu9GX7cVb/YFs8oANPgO5FwjMKJ
        HEzlXb6co9xLG7Xlv41OisJQP33+TH+FjzkwVELnOd2yYuRv7hwny2AaaTKTyFslNqYHPQlAALYXG
        1anWclhKWEfupcIFCfnD8Viow9ATpq60mQH5OmyyycXrz+eE0eSgQinvuVFy7ztYD8VXMkzFY5SMf
        mBaxB+1HmVgqmbKt2fzVcz93vehCRnjY4LIt43irK2T3i4qc4ErKJOIIVZmW116zmKY2utYwzbiT7
        6s8SSVoQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1og3Yr-0001Kq-Ip; Wed, 05 Oct 2022 14:31:41 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1og3YQ-0007vp-Mq; Wed, 05 Oct 2022 14:31:14 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 4/8] KVM: x86: Store immutable gfn_to_pfn_cache properties
Date:   Wed,  5 Oct 2022 14:30:47 +0200
Message-Id: <20221005123051.895056-5-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221005123051.895056-1-mhal@rbox.co>
References: <YySujDJN2Wm3ivi/@google.com>
 <20221005123051.895056-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the assignment of immutable properties @kvm, @vcpu, @usage, @len
to the initializer.  Make _activate() and _deactivate() use stored
values.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c        | 16 ++++++-------
 arch/x86/kvm/xen.c        | 50 ++++++++++++++++++---------------------
 include/linux/kvm_host.h  | 40 +++++++++++++++----------------
 include/linux/kvm_types.h |  2 ++
 virt/kvm/pfncache.c       | 36 +++++++++++++++-------------
 5 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 45136ce7185e..ed8e4f8c9cf0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2300,13 +2300,10 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 	kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
 
 	/* we verify if the enable bit is set... */
-	if (system_time & 1) {
-		kvm_gpc_activate(vcpu->kvm, &vcpu->arch.pv_time, vcpu,
-				 KVM_HOST_USES_PFN, system_time & ~1ULL,
-				 sizeof(struct pvclock_vcpu_time_info));
-	} else {
-		kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
-	}
+	if (system_time & 1)
+		kvm_gpc_activate(&vcpu->arch.pv_time, system_time & ~1ULL);
+	else
+		kvm_gpc_deactivate(&vcpu->arch.pv_time);
 
 	return;
 }
@@ -3374,7 +3371,7 @@ static int kvm_pv_enable_async_pf_int(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
+	kvm_gpc_deactivate(&vcpu->arch.pv_time);
 	vcpu->arch.time = 0;
 }
 
@@ -11551,7 +11548,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
-	kvm_gpc_init(&vcpu->arch.pv_time);
+	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm, vcpu, KVM_HOST_USES_PFN,
+		     sizeof(struct pvclock_vcpu_time_info));
 
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 361f77dc7a3d..9b4b0e6e66e5 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -42,13 +42,12 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	int idx = srcu_read_lock(&kvm->srcu);
 
 	if (gfn == GPA_INVALID) {
-		kvm_gpc_deactivate(kvm, gpc);
+		kvm_gpc_deactivate(gpc);
 		goto out;
 	}
 
 	do {
-		ret = kvm_gpc_activate(kvm, gpc, NULL, KVM_HOST_USES_PFN, gpa,
-				       PAGE_SIZE);
+		ret = kvm_gpc_activate(gpc, gpa);
 		if (ret)
 			goto out;
 
@@ -553,15 +552,13 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			     offsetof(struct compat_vcpu_info, time));
 
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
+			kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gpc_activate(vcpu->kvm,
-				     &vcpu->arch.xen.vcpu_info_cache, NULL,
-				     KVM_HOST_USES_PFN, data->u.gpa,
-				     sizeof(struct vcpu_info));
+		r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
+				     data->u.gpa);
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
@@ -569,16 +566,13 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gpc_deactivate(vcpu->kvm,
-					   &vcpu->arch.xen.vcpu_time_info_cache);
+			kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_time_info_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gpc_activate(vcpu->kvm,
-				     &vcpu->arch.xen.vcpu_time_info_cache,
-				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
-				     sizeof(struct pvclock_vcpu_time_info));
+		r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_time_info_cache,
+				     data->u.gpa);
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
@@ -589,15 +583,13 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gpc_deactivate(vcpu->kvm,
-					   &vcpu->arch.xen.runstate_cache);
+			kvm_gpc_deactivate(&vcpu->arch.xen.runstate_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
-				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
-				     sizeof(struct vcpu_runstate_info));
+		r = kvm_gpc_activate(&vcpu->arch.xen.runstate_cache,
+				     data->u.gpa);
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
@@ -1818,9 +1810,12 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
 
-	kvm_gpc_init(&vcpu->arch.xen.runstate_cache);
-	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache);
-	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache);
+	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm, NULL,
+		     KVM_HOST_USES_PFN, sizeof(struct vcpu_runstate_info));
+	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm, NULL,
+		     KVM_HOST_USES_PFN, sizeof(struct vcpu_info));
+	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache, vcpu->kvm, NULL,
+		     KVM_HOST_USES_PFN, sizeof(struct pvclock_vcpu_time_info));
 }
 
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
@@ -1828,9 +1823,9 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 	if (kvm_xen_timer_enabled(vcpu))
 		kvm_xen_stop_timer(vcpu);
 
-	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.runstate_cache);
-	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
-	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_time_info_cache);
+	kvm_gpc_deactivate(&vcpu->arch.xen.runstate_cache);
+	kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
+	kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_time_info_cache);
 
 	del_timer_sync(&vcpu->arch.xen.poll_timer);
 }
@@ -1838,7 +1833,8 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	idr_init(&kvm->arch.xen.evtchn_ports);
-	kvm_gpc_init(&kvm->arch.xen.shinfo_cache);
+	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN,
+		     PAGE_SIZE);
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
@@ -1846,7 +1842,7 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
 
-	kvm_gpc_deactivate(kvm, &kvm->arch.xen.shinfo_cache);
+	kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
 
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		if (!evtchnfd->deliver.port.port)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f687e56c24bc..024b8df5302c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1244,17 +1244,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * kvm_gpc_init - initialize gfn_to_pfn_cache.
  *
  * @gpc:	   struct gfn_to_pfn_cache object.
- *
- * This sets up a gfn_to_pfn_cache by initializing locks.
- */
-void kvm_gpc_init(struct gfn_to_pfn_cache *gpc);
-
-/**
- * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
- *                    physical address.
- *
  * @kvm:	   pointer to kvm instance.
- * @gpc:	   struct gfn_to_pfn_cache object.
  * @vcpu:	   vCPU to be used for marking pages dirty and to be woken on
  *		   invalidation.
  * @usage:	   indicates if the resulting host physical PFN is used while
@@ -1263,20 +1253,31 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc);
  *		   changes!---will also force @vcpu to exit the guest and
  *		   refresh the cache); and/or if the PFN used directly
  *		   by KVM (and thus needs a kernel virtual mapping).
- * @gpa:	   guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
  *
+ * This sets up a gfn_to_pfn_cache by initializing locks and assigning the
+ * immutable attributes.
+ */
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
+		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+		  unsigned long len);
+
+/**
+ * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
+ *                    physical address.
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ * @gpa:	   guest physical address to map.
+ *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
- *                 -EFAULT for an untranslatable guest physical address.
+ *		   -EFAULT for an untranslatable guest physical address.
  *
- * This primes a gfn_to_pfn_cache and links it into the @kvm's list for
+ * This primes a gfn_to_pfn_cache and links it into the @gpc->kvm's list for
  * invalidations to be processed.  Callers are required to use kvm_gpc_check()
  * to ensure that the cache is valid before accessing the target page.
  */
-int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-		     struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-		     gpa_t gpa, unsigned long len);
+int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
 /**
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
@@ -1335,13 +1336,12 @@ void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 /**
  * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
  *
- * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  *
- * This removes a cache from the @kvm's list to be processed on MMU notifier
- * invocation.
+ * This removes a cache from the @gpc->kvm's list to be processed on MMU
+ * notifier invocation.
  */
-void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
+void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 3ca3db020e0e..d66b276d29e0 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -67,12 +67,14 @@ struct gfn_to_pfn_cache {
 	gpa_t gpa;
 	unsigned long uhva;
 	struct kvm_memory_slot *memslot;
+	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	struct list_head list;
 	rwlock_t lock;
 	struct mutex refresh_lock;
 	void *khva;
 	kvm_pfn_t pfn;
+	unsigned long len;
 	enum pfn_cache_usage usage;
 	bool active;
 	bool valid;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 76f1b669cf28..56ca0e9c6ed7 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -346,44 +346,48 @@ void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
 
-void kvm_gpc_init(struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
+		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+		  unsigned long len)
 {
+	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
+	WARN_ON_ONCE((usage & KVM_GUEST_USES_PFN) && !vcpu);
+
 	rwlock_init(&gpc->lock);
 	mutex_init(&gpc->refresh_lock);
+
+	gpc->kvm = kvm;
+	gpc->vcpu = vcpu;
+	gpc->usage = usage;
+	gpc->len = len;
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_init);
 
-int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-		     struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-		     gpa_t gpa, unsigned long len)
+int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
-	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
-
 	if (!gpc->active) {
 		gpc->khva = NULL;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->uhva = KVM_HVA_ERR_BAD;
-		gpc->vcpu = vcpu;
-		gpc->usage = usage;
 		gpc->valid = false;
 		gpc->active = true;
 
-		spin_lock(&kvm->gpc_lock);
-		list_add(&gpc->list, &kvm->gpc_list);
-		spin_unlock(&kvm->gpc_lock);
+		spin_lock(&gpc->kvm->gpc_lock);
+		list_add(&gpc->list, &gpc->kvm->gpc_list);
+		spin_unlock(&gpc->kvm->gpc_lock);
 	}
-	return kvm_gpc_refresh(kvm, gpc, gpa, len);
+	return kvm_gpc_refresh(gpc->kvm, gpc, gpa, gpc->len);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 {
 	if (gpc->active) {
-		spin_lock(&kvm->gpc_lock);
+		spin_lock(&gpc->kvm->gpc_lock);
 		list_del(&gpc->list);
-		spin_unlock(&kvm->gpc_lock);
+		spin_unlock(&gpc->kvm->gpc_lock);
 
-		kvm_gpc_unmap(kvm, gpc);
+		kvm_gpc_unmap(gpc->kvm, gpc);
 		gpc->active = false;
 	}
 }
-- 
2.37.3

