Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB5360FCDD
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbiJ0QT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbiJ0QS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759B6196B4D
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8dxvWw7cc00qYC3G7D2Ly6NMtjgd9FL+mjGaKcWOw4=;
        b=Zb5CBG6eGMeFNLwoRAP8RxS1SZEbt+lugT7H6Lo+lub/5JUjY5c1+XMakH0YNLZ6n8aUCL
        YW3KQhA6bnLS3QKP6/yscs+gKJE7zNCOAVTjeL2LH2j7GdFTKB2yaABckj8vn4GFSgU1FZ
        tRNOOWKO5+2jULtci5Pw5wscEB8T2HI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-5dryEaD3NAeEPOlTCwg0bg-1; Thu, 27 Oct 2022 12:18:52 -0400
X-MC-Unique: 5dryEaD3NAeEPOlTCwg0bg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3CB1185A78B;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A20481415117;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 08/16] KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_check()
Date:   Thu, 27 Oct 2022 12:18:41 -0400
Message-Id: <20221027161849.2989332-9-pbonzini@redhat.com>
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

Make kvm_gpc_check() use kvm instance cached in gfn_to_pfn_cache.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-9-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  2 +-
 arch/x86/kvm/xen.c       | 12 ++++++------
 include/linux/kvm_host.h |  3 +--
 virt/kvm/pfncache.c      |  4 ++--
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9380fd9e1cf0..0e3546aa34dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3034,7 +3034,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	WARN_ON_ONCE(gpc->len != offset + sizeof(*guest_hv_clock));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 26c8a8dc2737..d3cb28388e3c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -241,7 +241,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		return;
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
@@ -374,7 +374,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * little more honest about it.
 	 */
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
@@ -437,7 +437,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -981,7 +981,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa))
+	if (!kvm_gpc_check(gpc, gpc->gpa))
 		goto out_rcu;
 
 	ret = false;
@@ -1372,7 +1372,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa))
+	if (!kvm_gpc_check(gpc, gpc->gpa))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1406,7 +1406,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(kvm, gpc, gpc->gpa)) {
+		if (!kvm_gpc_check(gpc, gpc->gpa)) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 931775e92f85..466988b8b5f6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1281,7 +1281,6 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 /**
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
  *
- * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   current guest physical address to map.
  *
@@ -1295,7 +1294,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
  * Callers in IN_GUEST_MODE may do so without locking, although they should
  * still hold a read lock on kvm->scru for the memslot checks.
  */
-bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa);
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 96008b69d48c..dfcf883ca298 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -76,9 +76,9 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	}
 }
 
-bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
-	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
 	if (!gpc->active)
 		return false;
-- 
2.31.1


