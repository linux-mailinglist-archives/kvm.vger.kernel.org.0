Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AEE5FE3FC
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiJMVOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiJMVNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:37 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF6C191D4E
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:21 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t7-20020a62ea07000000b005619a832f68so1786698pfh.11
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1msHt2h1zk3U7VfDgxOJcVdiI5NiAbcgEYge87AV1N4=;
        b=LT3c/pDjbJWeU16zOB0oo+t9+yGv0hQb2pF6+lsobdNrnTlzOJ1BT9HjXDwk8ar+Ri
         4E369MG74nJF1S/jSUVKQHt+1Z7J3aN/bMnEI2apAE9SXqbHbwG857JwlSlj5sFGHWqK
         xp2r7KilhlU7w5bcLRZNQuk87ysFvoRHZJtrvE1rLdr5fZ+NrIJYGjciglfo6aCpEygQ
         /EXa0W3oC58ZqFJsCXJ6zrDsS5fw7ErpyUlS6jYCIBOyX+6k1h7KUnMQUuDg/vBWUSIO
         Q/b+sjAjkMHjsSWkxGaab75aABk8kPEBUcmMj67xOhZmZ7nQByi+SYoaGa+hxi0RS9I8
         4PTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1msHt2h1zk3U7VfDgxOJcVdiI5NiAbcgEYge87AV1N4=;
        b=JevLyPHEqDB0nk2uvaLUawNPIcwRwug3fU1vzPWxkTWEkVwsXbv/TprnWtuuwCGufG
         oU43TZDrxVF1Blk4xu8JSU6Pkx6VwQKCJrKdzhrLiChvIUEs+lmIzsUEWdH6xkau6bMM
         Fdwh/7sCbivCdtYBdfT1iNL/8C2MJWSfLRSp3MqVxi9tDQSrR/JpxlXixPBKNaQvVzgw
         3X3xnXW1JVB2v/nPOxOUG7J/po5ueDMPWwKNmaE5lTAtxjh+hop0HWCcDRn6IBt69FRW
         La+8+WmfyIBEpvxqF8a6Expnp/6sw4YbQG2TN9/byB8R+gwN7yr5WKC6PeO3xJ4I8Cz/
         T8VQ==
X-Gm-Message-State: ACrzQf1fp1g08F0y3AZzxrjvwQ2nGnprbFQd7ju1mfiMdY/oUXAZIGxk
        g8KpjiKXu4V+SRzeGnwVj10RYEg2HdQ=
X-Google-Smtp-Source: AMsMyM6RFkaj0/jA7js6tXadWjKbBCfJEO4acH6bd27Y9fq7PfEz7rQ1YFzwS3asqgOmFogbEop+9IEEvVI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1d0d:b0:20d:5c1c:5fbb with SMTP id
 on13-20020a17090b1d0d00b0020d5c1c5fbbmr13469697pjb.196.1665695569201; Thu, 13
 Oct 2022 14:12:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:24 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-7-seanjc@google.com>
Subject: [PATCH v2 06/16] KVM: Store immutable gfn_to_pfn_cache properties
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
---
 arch/x86/kvm/x86.c        | 14 +++++-------
 arch/x86/kvm/xen.c        | 47 ++++++++++++++++++---------------------
 include/linux/kvm_host.h  | 37 +++++++++++++++---------------
 include/linux/kvm_types.h |  1 +
 virt/kvm/pfncache.c       | 22 +++++++++++-------
 5 files changed, 61 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd00e6a33203..9c68050672de 100644
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
 
@@ -11757,7 +11755,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
-	kvm_gpc_init(&vcpu->arch.pv_time);
+	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm, vcpu, KVM_HOST_USES_PFN);
 
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 74d9f4985f93..55b7195d69d6 100644
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
 
@@ -550,15 +549,13 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
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
 
@@ -566,15 +563,13 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
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
@@ -586,14 +581,13 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
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
+		r = kvm_gpc_activate(&vcpu->arch.xen.runstate_cache,
+				     data->u.gpa,
 				     sizeof(struct vcpu_runstate_info));
 		break;
 
@@ -1814,9 +1808,12 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 
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
@@ -1824,9 +1821,9 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1834,7 +1831,7 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	idr_init(&kvm->arch.xen.evtchn_ports);
-	kvm_gpc_init(&kvm->arch.xen.shinfo_cache);
+	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN);
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
@@ -1842,7 +1839,7 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
 
-	kvm_gpc_deactivate(kvm, &kvm->arch.xen.shinfo_cache);
+	kvm_gpc_deactivate(&kvm->arch.xen.shinfo_cache);
 
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		if (!evtchnfd->deliver.port.port)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bb020ee3b2fe..e5e70607a5ef 100644
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
2.38.0.413.g74048e4d9e-goog

