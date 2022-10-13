Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D7A5FE400
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiJMVOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiJMVNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:39 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF94192DB4
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:27 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3576c47f204so28156957b3.2
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5URKB2UHMUSPpWygEwKHgMdRAkLfFXnLzKwGOMCRDNA=;
        b=UKNC2oX08Dn5jOmQaFh8md74layXZhPEWoVtlgyMroHsnDPxL9Ea4oOE99qmFZKq35
         c/rLwzP18IC/7p/JVrfDeh8kN2cowwAN6IbStXMfiY3r5he7mlWqzRYwplCfiCsVKlFR
         beyqEUJa6kiF+TycHjvtt5ttKot4XXozvmzS53XK4tISWavxxqJxecXn+FH51b0th1rd
         4uRhaeMV8UAV3LShApu0XEjCuUUNQ+agDoal03x65LKmf5LXR7Zk67B+Qu5NJkMIfZrn
         6W3aUB5e0ujvuP1lNjRimNix4mKv2pZ4WBlWNv3IEGmMpb3LiiFoptN5NXk8Ojsx6fzm
         uYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5URKB2UHMUSPpWygEwKHgMdRAkLfFXnLzKwGOMCRDNA=;
        b=fvO88DNnGNtavTO3H8shd0l9FurSPh5ubIr2wSJ+nZnmGC+f785vAkMq42oKsX9all
         a0f5Zu3kfhKaOtfyxb0DUhtIfU8m/MeHzba88F1D/Je13Zx/8Mi25mVhAJvuuYvtL6AH
         uii9wIK4J0ciKTdARCf60+5+TWrcpnZDO2OeicOgu8D2YgambCQmjQywRQfvuyay9ov0
         JwAPdVizTE+dPEYkwWsf9AVcmvqlUe+5u4Jo6z26eTNA8CBzHIfakV+3P7DUs/Qhhmhc
         UoaXpnwAY6D3LX19igrdXVgmOVVuB6DwFQffRL6HHyQtHyvP/RRQ9QZUc6xryFc8fXUa
         C4GQ==
X-Gm-Message-State: ACrzQf2F+yvNvwJfyhlFQSASg0VG2Dguh8JY5nEC5J9vtxeG2F+dHCjl
        36TNKfm2wbtqnWL0u6Uyak1e6qKfP9w=
X-Google-Smtp-Source: AMsMyM76F81HmX3F2Qos6l80xV4HqE50+9kT+DWyQE4AfLfy2pocrTQVdpKufL11zhYH9DERGg08VIhL+Ck=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3746:0:b0:6bd:33bc:a284 with SMTP id
 e67-20020a253746000000b006bd33bca284mr1714965yba.506.1665695572592; Thu, 13
 Oct 2022 14:12:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:26 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-9-seanjc@google.com>
Subject: [PATCH v2 08/16] KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_check()
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

Make kvm_gpc_check() use kvm instance cached in gfn_to_pfn_cache.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       |  2 +-
 arch/x86/kvm/xen.c       | 12 ++++++------
 include/linux/kvm_host.h |  3 +--
 virt/kvm/pfncache.c      |  4 ++--
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b4fa3455f3a..b357a84f8c49 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3033,7 +3033,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	WARN_ON_ONCE(gpc->len != offset + sizeof(*guest_hv_clock));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 6f5a5507392e..c7304f37c438 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -211,7 +211,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		return;
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
@@ -344,7 +344,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * little more honest about it.
 	 */
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
@@ -407,7 +407,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -947,7 +947,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa))
+	if (!kvm_gpc_check(gpc, gpc->gpa))
 		goto out_rcu;
 
 	ret = false;
@@ -1338,7 +1338,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa))
+	if (!kvm_gpc_check(gpc, gpc->gpa))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1372,7 +1372,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(kvm, gpc, gpc->gpa)) {
+		if (!kvm_gpc_check(gpc, gpc->gpa)) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c79f2e122ac8..ad8ef7f2d705 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1282,7 +1282,6 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 /**
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
  *
- * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   current guest physical address to map.
  *
@@ -1296,7 +1295,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
  * Callers in IN_GUEST_MODE may do so without locking, although they should
  * still hold a read lock on kvm->scru for the memslot checks.
  */
-bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa);
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 34883ad12536..6fe76fb4d228 100644
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
2.38.0.413.g74048e4d9e-goog

