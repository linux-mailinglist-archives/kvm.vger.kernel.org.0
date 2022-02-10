Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D514B0268
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiBJBbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:31:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiBJBbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:31:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C81A0
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mELgNS1+ruG4c62o2IDV3AR0D1jff1f/1QgrgjYj/SU=; b=HpPbvpEj82nGjGCSz5U3QL1GSx
        NaHsKsMUQCQIYxeEDJ4Kp1q+GU93U3C46iQplpu3n51tOuWutaGreZlG6nwlDqQK5qtrHjhTgHEBx
        hpYh/HcYoSEfkB8b44m/7q2Dl6oZhCYUgi09ONVeVg9h08yomflxPyafYg18hVkJjCvsKIBSnY+DP
        lQp293ZxPxSRJsYtG/ExQVq8eWVnYmPdIdvAbPuNM7CXi4ICUqquYRwK6/Sl/LZcCohYRe8d4b2K9
        hpsfyHz37Pk6T+wqUJ4ovQKAH/oiPSe4KVLHR2i1JLdJn8viSlMJIjmr+bDoWCDXSQ7ssMoHjJMzL
        GC759Ycw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008xl2-FD; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-0019Ct-0G; Thu, 10 Feb 2022 00:27:24 +0000
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
Subject: [PATCH v0 03/15] KVM: x86: Use gfn_to_pfn_cache for pv_time
Date:   Thu, 10 Feb 2022 00:27:09 +0000
Message-Id: <20220210002721.273608-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220210002721.273608-1-dwmw2@infradead.org>
References: <20220210002721.273608-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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

Add a new kvm_setup_guest_pvclock() which parallels the existing
kvm_setup_pvclock_page(). The latter will be removed once we convert
all users to the gfn_to_pfn_cache version.

Using the new cache, we can potentially let kvm_set_guest_paused() set
the PVCLOCK_GUEST_STOPPED bit directly rather than having to delegate
to the vCPU via KVM_REQ_CLOCK_UPDATE. But not yet.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/x86.c              | 76 +++++++++++++++++++++++++++------
 2 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1e73053fd2bf..c64b80c07fdd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -747,8 +747,7 @@ struct kvm_vcpu_arch {
 	gpa_t time;
 	struct pvclock_vcpu_time_info hv_clock;
 	unsigned int hw_tsc_khz;
-	struct gfn_to_hva_cache pv_time;
-	bool pv_time_enabled;
+	struct gfn_to_pfn_cache pv_time;
 	/* set guest stopped flag in pvclock flags field */
 	bool pvclock_set_guest_stopped_request;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d0191bf30b3..992baebf0a58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2209,14 +2209,14 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 	kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
 
 	/* we verify if the enable bit is set... */
-	vcpu->arch.pv_time_enabled = false;
-	if (!(system_time & 1))
-		return;
-
-	if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
-				       &vcpu->arch.pv_time, system_time & ~1ULL,
-				       sizeof(struct pvclock_vcpu_time_info)))
-		vcpu->arch.pv_time_enabled = true;
+	if (system_time & 1) {
+		kvm_gfn_to_pfn_cache_init(vcpu->kvm, &vcpu->arch.pv_time, vcpu,
+					  false, true, system_time & ~1ULL,
+					  sizeof(struct pvclock_vcpu_time_info),
+					  false);
+	} else {
+		kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
+	}
 
 	return;
 }
@@ -2919,6 +2919,56 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	return data.clock;
 }
 
+static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
+				    struct gfn_to_pfn_cache *gpc,
+				    unsigned int offset)
+{
+	struct kvm_vcpu_arch *vcpu = &v->arch;
+	struct pvclock_vcpu_time_info *guest_hv_clock;
+	unsigned long flags;
+
+	read_lock_irqsave(&gpc->lock, flags);
+	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
+					   offset + sizeof(*guest_hv_clock))) {
+		read_unlock_irqrestore(&gpc->lock, flags);
+
+		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
+						 offset + sizeof(*guest_hv_clock),
+						 true))
+			return;
+
+		read_lock_irqsave(&gpc->lock, flags);
+	}
+
+	guest_hv_clock = (void *)(gpc->khva + offset);
+
+	/*
+	 * This VCPU is paused, but it's legal for a guest to read another
+	 * VCPU's kvmclock, so we really have to follow the specification where
+	 * it says that version is odd if data is being modified, and even after
+	 * it is consistent.
+	 */
+
+	guest_hv_clock->version = vcpu->hv_clock.version = (guest_hv_clock->version + 1) | 1;
+	smp_wmb();
+
+	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
+	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
+
+	if (vcpu->pvclock_set_guest_stopped_request) {
+		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
+		vcpu->pvclock_set_guest_stopped_request = false;
+	}
+
+	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
+	smp_wmb();
+
+	guest_hv_clock->version = ++vcpu->hv_clock.version;
+	read_unlock_irqrestore(&gpc->lock, flags);
+
+	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
+}
+
 static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
 				   struct gfn_to_hva_cache *cache,
 				   unsigned int offset)
@@ -3064,8 +3114,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	vcpu->hv_clock.flags = pvclock_flags;
 
-	if (vcpu->pv_time_enabled)
-		kvm_setup_pvclock_page(v, &vcpu->pv_time, 0);
+	if (vcpu->pv_time.active)
+		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
 	if (vcpu->xen.vcpu_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
 				       offsetof(struct compat_vcpu_info, time));
@@ -3259,7 +3309,7 @@ static int kvm_pv_enable_async_pf_int(struct kvm_vcpu *vcpu, u64 data)
 
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.pv_time_enabled = false;
+	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
 	vcpu->arch.time = 0;
 }
 
@@ -5058,7 +5108,7 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
  */
 static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->arch.pv_time_enabled)
+	if (!vcpu->arch.pv_time.active)
 		return -EINVAL;
 	vcpu->arch.pvclock_set_guest_stopped_request = true;
 	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -6122,7 +6172,7 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
 
 	mutex_lock(&kvm->lock);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!vcpu->arch.pv_time_enabled)
+		if (!vcpu->arch.pv_time.active)
 			continue;
 
 		ret = kvm_set_guest_paused(vcpu);
-- 
2.33.1

