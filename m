Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA5E4B025C
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiBJBcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:32:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiBJBcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:32:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242D010E0
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Wx2SHMFRFNms0QAIPNmRLyuGN49B+s0O45YYcLdb6nk=; b=jBqaFP1EKztmuOW0FaHuKBHzu4
        VGqKIFCGg+JhafHtZN7glL9ZOEs9CezVnMtp8tbxdTo1PSxuq7RHOUuEDHHMATOZ1q2DyH9UmjcJq
        JAv0D6zNDS3agg2vnmVeCzhYVgmfpIzw5iWkzj6Qh9quRyLlhAbtszCypjA7iWgcERv7ijHw6ynk7
        dyV+aIopDfDyRkP6/A4M/ZN071LwfgLOkz+ne0I7pPRnA7M96E9HrHtFs62ZR3m1f1Vsh3uYyxIqv
        +/t2Q9coXGhvu8Mo/LlnlR1DUNvCUVLpd+m5cqtOWLcBtfxunLCBLgraldL7zBKMIlKIo50mz9bWn
        xoZyT1RA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008xl1-Dk; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIx-0019Cj-Uj; Thu, 10 Feb 2022 00:27:23 +0000
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
Subject: [PATCH v0 01/15] KVM: x86/xen: Fix runstate updates to be atomic when preempting vCPU
Date:   Thu, 10 Feb 2022 00:27:07 +0000
Message-Id: <20220210002721.273608-2-dwmw2@infradead.org>
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

There are circumstances whem kvm_xen_update_runstate_guest() should not
sleep because it ends up being called from __schedule() when the vCPU
is preempted:

[  222.830825]  kvm_xen_update_runstate_guest+0x24/0x100
[  222.830878]  kvm_arch_vcpu_put+0x14c/0x200
[  222.830920]  kvm_sched_out+0x30/0x40
[  222.830960]  __schedule+0x55c/0x9f0

To handle this, make it use the same trick as __kvm_xen_has_interrupt(),
of using the hva from the gfn_to_hva_cache directly. Then it can use
pagefault_disable() around the accesses and just bail out if the page
is absent (which is unlikely).

After first looking at this, there followed a long path of discovery
which culminated in removing the existing gfn_to_pfn_cache and replacing
it with something more fit for purpose in 5.17. A future patch can
convert the runstate code to use that, but this simpler fix can be
applied more easily to the older stable kernels.

Fixes: 30b5c851af79 ("KVM: x86/xen: Add support for vCPU runstate information")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/xen.c | 102 ++++++++++++++++++++++++++++++---------------
 1 file changed, 68 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index bad57535fad0..39b319f428bc 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -133,36 +133,60 @@ static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
+	struct gfn_to_hva_cache *ghc = &vx->runstate_cache;
+	struct kvm_memslots *slots = kvm_memslots(v->kvm);
+	bool atomic = (state == RUNSTATE_runnable);
 	uint64_t state_entry_time;
-	unsigned int offset;
+	int __user *user_state;
+	uint64_t __user *user_times;
 
 	kvm_xen_update_runstate(v, state);
 
 	if (!vx->runstate_set)
 		return;
 
-	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+	if (unlikely(slots->generation != ghc->generation || kvm_is_error_hva(ghc->hva)) &&
+	    kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len))
+		return;
+
+	/* We made sure it fits in a single page */
+	BUG_ON(!ghc->memslot);
+
+	if (atomic)
+		pagefault_disable();
 
-	offset = offsetof(struct compat_vcpu_runstate_info, state_entry_time);
-#ifdef CONFIG_X86_64
 	/*
-	 * The only difference is alignment of uint64_t in 32-bit.
-	 * So the first field 'state' is accessed directly using
-	 * offsetof() (where its offset happens to be zero), while the
-	 * remaining fields which are all uint64_t, start at 'offset'
-	 * which we tweak here by adding 4.
+	 * The only difference between 32-bit and 64-bit versions of the
+	 * runstate struct is the alignment of uint64_t in 32-bit, which
+	 * means that the 64-bit version has an additional 4 bytes of
+	 * padding after the first field 'state'.
+	 *
+	 * So we use 'int __user *user_state' to point to the state field,
+	 * and 'uint64_t __user *user_times' for runstate_entry_time. So
+	 * the actual array of time[] in each state starts at user_times[1].
 	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
+	user_state = (int __user *)ghc->hva;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+
+	user_times = (uint64_t __user *)(ghc->hva +
+					 offsetof(struct compat_vcpu_runstate_info,
+						  state_entry_time));
+#ifdef CONFIG_X86_64
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
 		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
 		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
 
 	if (v->kvm->arch.xen.long_mode)
-		offset = offsetof(struct vcpu_runstate_info, state_entry_time);
+		user_times = (uint64_t __user *)(ghc->hva +
+						 offsetof(struct vcpu_runstate_info,
+							  state_entry_time));
 #endif
 	/*
-	 * First write the updated state_entry_time at the appropriate
-	 * location determined by 'offset'.
+	 * First write the updated state_entry_time to the guest area.
 	 */
 	state_entry_time = vx->runstate_entry_time;
 	state_entry_time |= XEN_RUNSTATE_UPDATE;
@@ -172,28 +196,21 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
 		     sizeof(state_entry_time));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &state_entry_time, offset,
-					  sizeof(state_entry_time)))
-		return;
+	if (__put_user(state_entry_time, user_times))
+		goto out;
 	smp_wmb();
 
 	/*
 	 * Next, write the new runstate. This is in the *same* place
 	 * for 32-bit and 64-bit guests, asserted here for paranoia.
 	 */
-	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
-		     offsetof(struct compat_vcpu_runstate_info, state));
 	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
 	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
 		     sizeof(vx->current_runstate));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &vx->current_runstate,
-					  offsetof(struct vcpu_runstate_info, state),
-					  sizeof(vx->current_runstate)))
-		return;
+	if (__put_user(vx->current_runstate, user_state))
+		goto out;
 
 	/*
 	 * Write the actual runstate times immediately after the
@@ -208,24 +225,23 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
 		     sizeof(vx->runstate_times));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &vx->runstate_times[0],
-					  offset + sizeof(u64),
-					  sizeof(vx->runstate_times)))
-		return;
-
+	if (__copy_to_user(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times)))
+		goto out;
 	smp_wmb();
 
 	/*
 	 * Finally, clear the XEN_RUNSTATE_UPDATE bit in the guest's
 	 * runstate_entry_time field.
 	 */
-
 	state_entry_time &= ~XEN_RUNSTATE_UPDATE;
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &state_entry_time, offset,
-					  sizeof(state_entry_time)))
-		return;
+	__put_user(state_entry_time, user_times);
+	smp_wmb();
+
+ out:
+	mark_page_dirty_in_slot(v->kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+
+	if (atomic)
+		pagefault_enable();
 }
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
@@ -443,6 +459,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_info_cache,
 					      data->u.gpa,
@@ -460,6 +482,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct pvclock_vcpu_time_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_time_info_cache,
 					      data->u.gpa,
@@ -481,6 +509,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_runstate_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.runstate_cache,
 					      data->u.gpa,
-- 
2.33.1

