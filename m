Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47F5BF333
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 04:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiIUCCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 22:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIUCCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 22:02:36 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0160478BE7
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 19:02:33 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oap4J-00Eb2I-G7; Wed, 21 Sep 2022 04:02:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=uG0AOpt2CyZI62orwWliEpaN9pL/1GxTgFPNgCfpVCQ=; b=PYBkO4x8qHDP0Axxdhpr7sztpw
        8g/Pgft/efymjkGnI/4MOSLP8Crdn0db1w/S1FE/UvVkc5TzJvQZZ5BFIOsJEIVJW1htl7JWUJvni
        0zGmVZlTbRxqxLI8bUHvXYQnndr49HjeclzWZHPzffx2v7ULNNK93O2YVI8hwwWzBVYjgkrFAlAo7
        /dXNjH83WFa2KmosuSx7udXsVz/qx98QOS+pboQdY0wRxVNxn7FoRsMnvGl/VPRu00H1+eH38raE6
        0pZ8hTCAERZLVE8+zPFHYv01EDBGAFyutBPtOsE4AxC8XtBheft8nOz9aGuvST/ScK8axwjAInQxw
        4kWQDXSQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oap4J-0002TS-6U; Wed, 21 Sep 2022 04:02:31 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oap3w-0006er-EM; Wed, 21 Sep 2022 04:02:08 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 1/8] KVM: x86: Add initializer for gfn_to_pfn_cache
Date:   Wed, 21 Sep 2022 04:01:33 +0200
Message-Id: <20220921020140.3240092-2-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921020140.3240092-1-mhal@rbox.co>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
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

Move the gfn_to_pfn_cache lock initialization to another helper and
call the new helper during VM/vCPU creation.

Rename "cache_init" and "cache_destroy" to activate+deactivate to
avoid implying that the cache really is destroyed/freed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c       | 12 +++++----
 arch/x86/kvm/xen.c       | 57 +++++++++++++++++++++-------------------
 include/linux/kvm_host.h | 23 +++++++++++-----
 virt/kvm/pfncache.c      | 21 ++++++++-------
 4 files changed, 65 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..15032b7f0589 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2301,11 +2301,11 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 
 	/* we verify if the enable bit is set... */
 	if (system_time & 1) {
-		kvm_gfn_to_pfn_cache_init(vcpu->kvm, &vcpu->arch.pv_time, vcpu,
-					  KVM_HOST_USES_PFN, system_time & ~1ULL,
-					  sizeof(struct pvclock_vcpu_time_info));
+		kvm_gpc_activate(vcpu->kvm, &vcpu->arch.pv_time, vcpu,
+				 KVM_HOST_USES_PFN, system_time & ~1ULL,
+				 sizeof(struct pvclock_vcpu_time_info));
 	} else {
-		kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
+		kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
 	}
 
 	return;
@@ -3374,7 +3374,7 @@ static int kvm_pv_enable_async_pf_int(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
 	vcpu->arch.time = 0;
 }
 
@@ -11551,6 +11551,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
+	kvm_gpc_init(&vcpu->arch.pv_time);
+
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 280cb5dc7341..cecf8299b187 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -42,13 +42,13 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	int idx = srcu_read_lock(&kvm->srcu);
 
 	if (gfn == GPA_INVALID) {
-		kvm_gfn_to_pfn_cache_destroy(kvm, gpc);
+		kvm_gpc_deactivate(kvm, gpc);
 		goto out;
 	}
 
 	do {
-		ret = kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, KVM_HOST_USES_PFN,
-						gpa, PAGE_SIZE);
+		ret = kvm_gpc_activate(kvm, gpc, NULL, KVM_HOST_USES_PFN, gpa,
+				       PAGE_SIZE);
 		if (ret)
 			goto out;
 
@@ -554,15 +554,15 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			     offsetof(struct compat_vcpu_info, time));
 
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
+			kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
-					      &vcpu->arch.xen.vcpu_info_cache,
-					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct vcpu_info));
+		r = kvm_gpc_activate(vcpu->kvm,
+				     &vcpu->arch.xen.vcpu_info_cache, NULL,
+				     KVM_HOST_USES_PFN, data->u.gpa,
+				     sizeof(struct vcpu_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
@@ -570,16 +570,16 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-						     &vcpu->arch.xen.vcpu_time_info_cache);
+			kvm_gpc_deactivate(vcpu->kvm,
+					   &vcpu->arch.xen.vcpu_time_info_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
-					      &vcpu->arch.xen.vcpu_time_info_cache,
-					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct pvclock_vcpu_time_info));
+		r = kvm_gpc_activate(vcpu->kvm,
+				     &vcpu->arch.xen.vcpu_time_info_cache,
+				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
+				     sizeof(struct pvclock_vcpu_time_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
@@ -590,16 +590,15 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 		if (data->u.gpa == GPA_INVALID) {
-			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-						     &vcpu->arch.xen.runstate_cache);
+			kvm_gpc_deactivate(vcpu->kvm,
+					   &vcpu->arch.xen.runstate_cache);
 			r = 0;
 			break;
 		}
 
-		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
-					      &vcpu->arch.xen.runstate_cache,
-					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct vcpu_runstate_info));
+		r = kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
+				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
+				     sizeof(struct vcpu_runstate_info));
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
@@ -1817,7 +1816,12 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.xen.vcpu_id = vcpu->vcpu_idx;
 	vcpu->arch.xen.poll_evtchn = 0;
+
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
+
+	kvm_gpc_init(&vcpu->arch.xen.runstate_cache);
+	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache);
+	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache);
 }
 
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
@@ -1825,18 +1829,17 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 	if (kvm_xen_timer_enabled(vcpu))
 		kvm_xen_stop_timer(vcpu);
 
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-				     &vcpu->arch.xen.runstate_cache);
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-				     &vcpu->arch.xen.vcpu_info_cache);
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
-				     &vcpu->arch.xen.vcpu_time_info_cache);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.runstate_cache);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_time_info_cache);
+
 	del_timer_sync(&vcpu->arch.xen.poll_timer);
 }
 
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	idr_init(&kvm->arch.xen.evtchn_ports);
+	kvm_gpc_init(&kvm->arch.xen.shinfo_cache);
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
@@ -1844,7 +1847,7 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
 
-	kvm_gfn_to_pfn_cache_destroy(kvm, &kvm->arch.xen.shinfo_cache);
+	kvm_gpc_deactivate(kvm, &kvm->arch.xen.shinfo_cache);
 
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		if (!evtchnfd->deliver.port.port)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..9fd67026d91a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1241,8 +1241,17 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 /**
- * kvm_gfn_to_pfn_cache_init - prepare a cached kernel mapping and HPA for a
- *                             given guest physical address.
+ * kvm_gpc_init - initialize gfn_to_pfn_cache.
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ *
+ * This sets up a gfn_to_pfn_cache by initializing locks.
+ */
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc);
+
+/**
+ * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
+ *                    physical address.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1266,9 +1275,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  * kvm_gfn_to_pfn_cache_check() to ensure that the cache is valid before
  * accessing the target page.
  */
-int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-			      gpa_t gpa, unsigned long len);
+int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+		     struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+		     gpa_t gpa, unsigned long len);
 
 /**
  * kvm_gfn_to_pfn_cache_check - check validity of a gfn_to_pfn_cache.
@@ -1325,7 +1334,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
 /**
- * kvm_gfn_to_pfn_cache_destroy - destroy and unlink a gfn_to_pfn_cache.
+ * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1333,7 +1342,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
  * This removes a cache from the @kvm's list to be processed on MMU notifier
  * invocation.
  */
-void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
+void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 68ff41d39545..08f97cf97264 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -346,17 +346,20 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
 
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc)
+{
+	rwlock_init(&gpc->lock);
+	mutex_init(&gpc->refresh_lock);
+}
+EXPORT_SYMBOL_GPL(kvm_gpc_init);
 
-int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
-			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-			      gpa_t gpa, unsigned long len)
+int kvm_gpc_activate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+		     struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+		     gpa_t gpa, unsigned long len)
 {
 	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
 
 	if (!gpc->active) {
-		rwlock_init(&gpc->lock);
-		mutex_init(&gpc->refresh_lock);
-
 		gpc->khva = NULL;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->uhva = KVM_HVA_ERR_BAD;
@@ -371,9 +374,9 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	}
 	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_init);
+EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_deactivate(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
 	if (gpc->active) {
 		spin_lock(&kvm->gpc_lock);
@@ -384,4 +387,4 @@ void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 		gpc->active = false;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_destroy);
+EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);
-- 
2.37.3

