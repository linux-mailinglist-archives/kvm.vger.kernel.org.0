Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEDB5FE3F2
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiJMVNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiJMVNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:11 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE3C190E53
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:12:55 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id v1-20020aa78081000000b005636d8a1947so1798255pff.0
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gevzVagMbQoR45WzsGVt74F8pXR1wYOxGraePZU6BPw=;
        b=OcajF8ZdgWvzSjcSQgUM4TAej7hicV5o0oo4Ytv01XUnlvgM+Ikr84KRLTVWz0c5Z9
         DmNyhDEtyZ/OHJWuRq6z7UCtDqlf2nDgENRpHNf/e8H7av/CBQ6u2qYJq76pZxA5X6n0
         8R3qBEnPdbtT86At0jRnWXq6pM219EXJjhDm5fz5a+cONM3kPUp/LJflWEAXdeoFDZia
         KMctiUTjFfG/li0HSb7VMZX1hFbQnibzUNeEGVdeejgjmHNmdCMPguR9/0R1/ov0HgnA
         4g9wxFeUEjEloz31pcP3mg0FJ04WqHEMPMC6On/EylL4ZvAv2LvkNcnLMrRFq/wu4efJ
         8aPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gevzVagMbQoR45WzsGVt74F8pXR1wYOxGraePZU6BPw=;
        b=MciK/otD3b01Yjq+KozyuRxy0bRbzhJ9MMu3tSZtGVsdVcpOxQzSGkAipitO6Rpz81
         FTuJ6T6tbr2EjjtLdRKUmAOkVqe3lL+ou0/TkIOPP7HqXQXVIA2pDWzLYwCSxnpEfjlr
         msVGyNlHWpqeKCXGXpCzcsMUb5ZNXzeWskz0Vq5cBgSapw+9n8qXnxz+4M9c8FziML7v
         Ey+cnYdgWSZbryuMTenWJwb4uWWHvcsWW3IPjO3C16j4nvVDUs9gBv45TwdGgdLXTwEO
         xweRuhyZzeoOEoSMCvZTLGnH4kTm6CCkywmNOXhEGl51w4T/VA2XLeLsnTkrTHIs6Li7
         WB6g==
X-Gm-Message-State: ACrzQf26Oc4uatqqk0X7d70FVm5gkhkE1hYvBagKDMySGVb9Jg8sXQ3B
        cew7Kjvko4Kn/yGe3UGxbtlGux3bW+g=
X-Google-Smtp-Source: AMsMyM6OhYuX5d5FpblM517k1J148s7nC5q11XNu/RMmGV5MfHPuyfAcPCnJztM1vSQjo0AhrVmnnDrGc4A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:ad0:b0:555:ac02:433b with SMTP id
 c16-20020a056a000ad000b00555ac02433bmr1501633pfl.18.1665695560839; Thu, 13
 Oct 2022 14:12:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:19 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-2-seanjc@google.com>
Subject: [PATCH v2 01/16] KVM: Initialize gfn_to_pfn_cache locks in dedicated helper
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

Move the gfn_to_pfn_cache lock initialization to another helper and
call the new helper during VM/vCPU creation.  There are race
conditions possible due to kvm_gfn_to_pfn_cache_init()'s
ability to re-initialize the cache's locks.

For example: a race between ioctl(KVM_XEN_HVM_EVTCHN_SEND) and
kvm_gfn_to_pfn_cache_init() leads to a corrupted shinfo gpc lock.

                (thread 1)                |           (thread 2)
                                          |
 kvm_xen_set_evtchn_fast                  |
  read_lock_irqsave(&gpc->lock, ...)      |
                                          | kvm_gfn_to_pfn_cache_init
                                          |  rwlock_init(&gpc->lock)
  read_unlock_irqrestore(&gpc->lock, ...) |

Rename "cache_init" and "cache_destroy" to activate+deactivate to
avoid implying that the cache really is destroyed/freed.

Note, there more races in the newly named kvm_gpc_activate() that will
be addressed separately.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
[sean: call out that this is a bug fix]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 12 +++++----
 arch/x86/kvm/xen.c       | 57 +++++++++++++++++++++-------------------
 include/linux/kvm_host.h | 24 ++++++++++++-----
 virt/kvm/pfncache.c      | 21 ++++++++-------
 4 files changed, 66 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4bd5f8a751de..943f039564e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2315,11 +2315,11 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 
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
@@ -3388,7 +3388,7 @@ static int kvm_pv_enable_async_pf_int(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.pv_time);
 	vcpu->arch.time = 0;
 }
 
@@ -11757,6 +11757,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
+	kvm_gpc_init(&vcpu->arch.pv_time);
+
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 93c628d3e3a9..b2be60c6efa4 100644
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
@@ -1816,7 +1815,12 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1824,18 +1828,17 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
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
@@ -1843,7 +1846,7 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
 
-	kvm_gfn_to_pfn_cache_destroy(kvm, &kvm->arch.xen.shinfo_cache);
+	kvm_gpc_deactivate(kvm, &kvm->arch.xen.shinfo_cache);
 
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		if (!evtchnfd->deliver.port.port)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 32f259fa5801..694c4cb6caf4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1240,8 +1240,18 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 /**
- * kvm_gfn_to_pfn_cache_init - prepare a cached kernel mapping and HPA for a
- *                             given guest physical address.
+ * kvm_gpc_init - initialize gfn_to_pfn_cache.
+ *
+ * @gpc:	   struct gfn_to_pfn_cache object.
+ *
+ * This sets up a gfn_to_pfn_cache by initializing locks.  Note, the cache must
+ * be zero-allocated (or zeroed by the caller before init).
+ */
+void kvm_gpc_init(struct gfn_to_pfn_cache *gpc);
+
+/**
+ * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
+ *                    physical address.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1265,9 +1275,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
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
@@ -1324,7 +1334,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
 
 /**
- * kvm_gfn_to_pfn_cache_destroy - destroy and unlink a gfn_to_pfn_cache.
+ * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
  *
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
@@ -1332,7 +1342,7 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
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
2.38.0.413.g74048e4d9e-goog

