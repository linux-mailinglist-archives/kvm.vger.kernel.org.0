Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299C44C2C0E
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 13:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiBXMtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 07:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbiBXMtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 07:49:12 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA08A1D8AA2
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 04:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tUCSPldi4MafAVJb7f2BAVv6ilZdji9KNRiLvYchnE4=; b=W2XtwsNyIklJChJVtpu5GUmWvp
        GHTcJ7lClYo7+saeyVBGM051WQ08mD5VblSCrOgoj5KzwbQwSaefZkGonWTuer+Hi4fJ3wk40rE/y
        qN9Z5ieAKdqZPmpu4qWgMKElsyZW4yMAc3OJ5aMf8TJwNBdhdOijUsnPfY6mv44nhVLIdXHqw8II1
        FgAZJ8Gn1Id29jSPQdksL2WxC1U9DTmtGa6IAC/ALA+aDV4FXCWdgQCwzdVQ82nA0BTnfnuSf1H+2
        gcx14A83Q5Rsm7ngiCaNWgeo/y5tsH69/gDTo0p1oiSknVTexC1JJPmvYQgfdGWBqIPJjNvWnHu9N
        HvCl7pEA==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXk-00CcPp-KM; Thu, 24 Feb 2022 12:48:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXj-0000tz-Dx; Thu, 24 Feb 2022 12:48:23 +0000
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
Subject: [PATCH v1 02/16] KVM: x86/xen: Use gfn_to_pfn_cache for runstate area
Date:   Thu, 24 Feb 2022 12:48:05 +0000
Message-Id: <20220224124819.3315-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224124819.3315-1-dwmw2@infradead.org>
References: <20220224124819.3315-1-dwmw2@infradead.org>
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

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/x86.c              |   1 +
 arch/x86/kvm/xen.c              | 111 ++++++++++++++++----------------
 arch/x86/kvm/xen.h              |   6 +-
 4 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 713e08f62385..d730079e5b10 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -602,10 +602,9 @@ struct kvm_vcpu_xen {
 	u32 current_runstate;
 	bool vcpu_info_set;
 	bool vcpu_time_info_set;
-	bool runstate_set;
 	struct gfn_to_hva_cache vcpu_info_cache;
 	struct gfn_to_hva_cache vcpu_time_info_cache;
-	struct gfn_to_hva_cache runstate_cache;
+	struct gfn_to_pfn_cache runstate_cache;
 	u64 last_steal;
 	u64 runstate_entry_time;
 	u64 runstate_times[4];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6552360d8888..8430daaccd35 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11215,6 +11215,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	fpu_free_guest_fpstate(&vcpu->arch.guest_fpu);
 
+	kvm_xen_destroy_vcpu(vcpu);
 	kvm_hv_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 5be1c9227105..eb0d11f80d1d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -133,27 +133,37 @@ static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
-	struct gfn_to_hva_cache *ghc = &vx->runstate_cache;
-	struct kvm_memslots *slots = kvm_memslots(v->kvm);
-	bool atomic = (state == RUNSTATE_runnable);
-	uint64_t state_entry_time;
-	int __user *user_state;
-	uint64_t __user *user_times;
+	struct gfn_to_pfn_cache *gpc = &vx->runstate_cache;
+	uint64_t *user_times;
+	unsigned long flags;
+	size_t user_len;
+	int *user_state;
 
 	kvm_xen_update_runstate(v, state);
 
-	if (!vx->runstate_set)
+	if (!vx->runstate_cache.active)
 		return;
 
-	if (unlikely(slots->generation != ghc->generation || kvm_is_error_hva(ghc->hva)) &&
-	    kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len))
-		return;
+	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
+		user_len = sizeof(struct vcpu_runstate_info);
+	else
+		user_len = sizeof(struct compat_vcpu_runstate_info);
 
-	/* We made sure it fits in a single page */
-	BUG_ON(!ghc->memslot);
+	read_lock_irqsave(&gpc->lock, flags);
+	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
+					   user_len)) {
+		read_unlock_irqrestore(&gpc->lock, flags);
 
-	if (atomic)
-		pagefault_disable();
+		/* When invoked from kvm_sched_out() we cannot sleep */
+		if (state == RUNSTATE_runnable)
+			return;
+
+		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
+						 user_len, false))
+			return;
+
+		read_lock_irqsave(&gpc->lock, flags);
+	}
 
 	/*
 	 * The only difference between 32-bit and 64-bit versions of the
@@ -167,38 +177,33 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	 */
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
 	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
-	user_state = (int __user *)ghc->hva;
-
 	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
-
-	user_times = (uint64_t __user *)(ghc->hva +
-					 offsetof(struct compat_vcpu_runstate_info,
-						  state_entry_time));
 #ifdef CONFIG_X86_64
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
 		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
 		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
-
-	if (v->kvm->arch.xen.long_mode)
-		user_times = (uint64_t __user *)(ghc->hva +
-						 offsetof(struct vcpu_runstate_info,
-							  state_entry_time));
 #endif
+
+	user_state = gpc->khva;
+
+	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
+		user_times = gpc->khva + offsetof(struct vcpu_runstate_info,
+						  state_entry_time);
+	else
+		user_times = gpc->khva + offsetof(struct compat_vcpu_runstate_info,
+						  state_entry_time);
+
 	/*
 	 * First write the updated state_entry_time at the appropriate
 	 * location determined by 'offset'.
 	 */
-	state_entry_time = vx->runstate_entry_time;
-	state_entry_time |= XEN_RUNSTATE_UPDATE;
-
 	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
-		     sizeof(state_entry_time));
+		     sizeof(user_times[0]));
 	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
-		     sizeof(state_entry_time));
+		     sizeof(user_times[0]));
 
-	if (__put_user(state_entry_time, user_times))
-		goto out;
+	user_times[0] = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
 	smp_wmb();
 
 	/*
@@ -212,8 +217,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
 
-	if (__put_user(vx->current_runstate, user_state))
-		goto out;
+	*user_state = vx->current_runstate;
 
 	/*
 	 * Write the actual runstate times immediately after the
@@ -228,23 +232,19 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
 		     sizeof(vx->runstate_times));
 
-	if (__copy_to_user(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times)))
-		goto out;
+	memcpy(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
 	smp_wmb();
 
 	/*
 	 * Finally, clear the XEN_RUNSTATE_UPDATE bit in the guest's
 	 * runstate_entry_time field.
 	 */
-	state_entry_time &= ~XEN_RUNSTATE_UPDATE;
-	__put_user(state_entry_time, user_times);
+	user_times[0] &= ~XEN_RUNSTATE_UPDATE;
 	smp_wmb();
 
- out:
-	mark_page_dirty_in_slot(v->kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+	read_unlock_irqrestore(&gpc->lock, flags);
 
-	if (atomic)
-		pagefault_enable();
+	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
@@ -507,24 +507,17 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 		if (data->u.gpa == GPA_INVALID) {
-			vcpu->arch.xen.runstate_set = false;
+			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
+						     &vcpu->arch.xen.runstate_cache);
 			r = 0;
 			break;
 		}
 
-		/* It must fit within a single page */
-		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_runstate_info) > PAGE_SIZE) {
-			r = -EINVAL;
-			break;
-		}
-
-		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.runstate_cache,
-					      data->u.gpa,
-					      sizeof(struct vcpu_runstate_info));
-		if (!r) {
-			vcpu->arch.xen.runstate_set = true;
-		}
+					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
+					      sizeof(struct vcpu_runstate_info),
+					      false);
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
@@ -659,7 +652,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			r = -EOPNOTSUPP;
 			break;
 		}
-		if (vcpu->arch.xen.runstate_set) {
+		if (vcpu->arch.xen.runstate_cache.active) {
 			data->u.gpa = vcpu->arch.xen.runstate_cache.gpa;
 			r = 0;
 		}
@@ -1057,3 +1050,9 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
 
 	return 0;
 }
+
+void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
+{
+	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
+				     &vcpu->arch.xen.runstate_cache);
+}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index adbcc9ed59db..54b2bf4c3001 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -23,7 +23,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_init_vm(struct kvm *kvm);
 void kvm_xen_destroy_vm(struct kvm *kvm);
-
+void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu);
 int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
 			    struct kvm *kvm);
 int kvm_xen_setup_evtchn(struct kvm *kvm,
@@ -65,6 +65,10 @@ static inline void kvm_xen_destroy_vm(struct kvm *kvm)
 {
 }
 
+static inline void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return false;
-- 
2.33.1

