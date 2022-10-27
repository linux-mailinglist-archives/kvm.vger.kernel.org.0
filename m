Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C333560FCDB
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbiJ0QTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbiJ0QSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:18:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5805196084
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EkjjTNkRC1SrGcUT44WLfdm9dpHrtSyenxlLxXIz8CI=;
        b=hDXMVvhNOraMR3on7kkiPScxnraXo58xsQqFRvTV61eymEMkxBf3A4hdcYDG4rBPJuZHTN
        BqFT9LdCxyQgy22B75ea36FN3D025rLk+0NognKTbBBS0/p9Ja304cgAAfHfUiJLQar+ml
        TMGwT8hsIv+xpoz0RTgWx9YSzD4vV3o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-TMIBKSFLO16KMYNE8nTx_w-1; Thu, 27 Oct 2022 12:18:52 -0400
X-MC-Unique: TMIBKSFLO16KMYNE8nTx_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 685BE800B30;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 417051415137;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 06/16] KVM: Store immutable gfn_to_pfn_cache properties
Date:   Thu, 27 Oct 2022 12:18:39 -0400
Message-Id: <20221027161849.2989332-7-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

Move the assignment of immutable properties @kvm, @vcpu, and @usage to
the initializer.  Make _activate() and _deactivate() use stored values.

Note, @len is also effectively immutable, but less obviously so.  Leave
@len as is for now, it will be addressed in a future patch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
[sean: handle @len in a separate patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c        | 14 +++++-------
 arch/x86/kvm/xen.c        | 46 ++++++++++++++++++---------------------
 include/linux/kvm_host.h  | 37 +++++++++++++++----------------
 include/linux/kvm_types.h |  1 +
 virt/kvm/pfncache.c       | 22 ++++++++++++-------
 5 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e5c546cba66..44e1330c9dfd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2314,13 +2314,11 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 	kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
 
 	/* we verify if the enable bit is set... */
-	if (system_time & 1) {
-		kvm_gpc_activate(vcpu->kvm, &vcpu->arch.pv_time, vcpu,
-				 KVM_HOST_USES_PFN, system_time & ~1ULL,
+	if (system_time & 1)
+		kvm_gpc_activate(&vcpu->arch.pv_time, system_time & ~1ULL,
 				 sizeof(struct pvclock_vcpu_time_info));
-	} else {
-		kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
-	}
+	else
+		kvm_gpc_deactivate(&vcpu->arch.pv_time);
 
 	return;
 }
@@ -3388,7 +3386,7 @@ static int kvm_pv_enable_async_pf_int(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
+	kvm_gpc_deactivate(&vcpu->arch.pv_time);
 	vcpu->arch.time = 0;
 }
 
@@ -11829,7 +11827,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
-	kvm_gpc_init(&vcpu->arch.pv_time);
+	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm, vcpu, KVM_HOST_USES_PFN);
 
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 5ea8f82d60b1..2d597d47b817 100644
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
+		ret = kvm_gpc_activate(gpc, gpa, PAGE_SIZE);
 		if (ret)
 			goto out;
 
@@ -209,8 +208,7 @@ static inline size_t kvm_xen_runstate_info_size(struct kvm *kvm)
 static int kvm_xen_activate_runstate_gpc(struct kvm_vcpu *vcpu, unsigned long gpa)
 {
 	size_t user_len = kvm_xen_runstate_info_size(vcpu->kvm);
-	return kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
-				NULL, KVM_HOST_USES_PFN, gpa, user_len);
+	return kvm_gpc_activate(&vcpu->arch.xen.runstate_cache, gpa, user_len);
 }
 
 static int kvm_xen_reactivate_runstate_gpcs(struct kvm *kvm)
@@ -580,15 +578,13 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
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
+				     data->u.gpa, sizeof(struct vcpu_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
@@ -596,15 +592,13 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
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
+		r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_time_info_cache,
+				     data->u.gpa,
 				     sizeof(struct pvclock_vcpu_time_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -616,8 +610,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gpc_deactivate(vcpu->kvm,
-					   &vcpu->arch.xen.runstate_cache);
+			kvm_gpc_deactivate(&vcpu->arch.xen.runstate_cache);
 			r = 0;
 			break;
 		}
@@ -1846,9 +1839,12 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
 
-	kvm_gpc_init(&vcpu->arch.xen.runstate_cache);
-	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache);
-	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache);
+	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm, NULL,
+		     KVM_HOST_USES_PFN);
+	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm, NULL,
+		     KVM_HOST_USES_PFN);
+	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache, vcpu->kvm, NULL,
+		     KVM_HOST_USES_PFN);
 }
 
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
@@ -1856,9 +1852,9 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1866,7 +1862,7 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	idr_init(&kvm->arch.xen.evtchn_ports);
-	kvm_gpc_init(&kvm->arch.xen.shinfo_cache);
+	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN);
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
@@ -1874,7 +1870,7 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
 
-	kvm_gpc_deactivate(kvm, &kvm->arch.xen.shinfo_cache);
+	kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
 
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		if (!evtchnfd->deliver.port.port)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4dc6571c832f..7a913818ba3c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1243,18 +1243,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * kvm_gpc_init - initialize gfn_to_pfn_cache.
  *
  * @gpc:	   struct gfn_to_pfn_cache object.
- *
- * This sets up a gfn_to_pfn_cache by initializing locks.  Note, the cache must
- * be zero-allocated (or zeroed by the caller before init).
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
@@ -1263,20 +1252,31 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc);
  *		   changes!---will also force @vcpu to exit the guest and
  *		   refresh the cache); and/or if the PFN used directly
  *		   by KVM (and thus needs a kernel virtual mapping).
+ *
+ * This sets up a gfn_to_pfn_cache by initializing locks and assigning the
+ * immutable attributes.  Note, the cache must be zero-allocated (or zeroed by
+ * the caller before init).
+ */
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
+		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage);
+
+/**
+ * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
+ *                    physical address.
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
  *
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
+int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len);
 
 /**
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
@@ -1335,13 +1335,12 @@ void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 /**
  * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
  *
- * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  *
- * This removes a cache from the @kvm's list to be processed on MMU notifier
+ * This removes a cache from the VM's list to be processed on MMU notifier
  * invocation.
  */
-void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
+void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 3ca3db020e0e..76de36e56cdf 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -67,6 +67,7 @@ struct gfn_to_pfn_cache {
 	gpa_t gpa;
 	unsigned long uhva;
 	struct kvm_memory_slot *memslot;
+	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	struct list_head list;
 	rwlock_t lock;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 32ccf168361b..6756dfa60d5a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -357,25 +357,29 @@ void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
 
-void kvm_gpc_init(struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
+		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage)
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
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_init);
 
-int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-		     struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-		     gpa_t gpa, unsigned long len)
+int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 {
-	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
+	struct kvm *kvm = gpc->kvm;
 
 	if (!gpc->active) {
 		gpc->khva = NULL;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->uhva = KVM_HVA_ERR_BAD;
-		gpc->vcpu = vcpu;
-		gpc->usage = usage;
 		gpc->valid = false;
 
 		spin_lock(&kvm->gpc_lock);
@@ -395,8 +399,10 @@ int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 {
+	struct kvm *kvm = gpc->kvm;
+
 	if (gpc->active) {
 		/*
 		 * Deactivate the cache before removing it from the list, KVM
-- 
2.31.1


