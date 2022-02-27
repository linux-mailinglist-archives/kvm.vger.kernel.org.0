Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A454C5C7C
	for <lists+kvm@lfdr.de>; Sun, 27 Feb 2022 16:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiB0PL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 10:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiB0PLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 10:11:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6956826D6;
        Sun, 27 Feb 2022 07:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EWUObjMNXky6LWRLhm/UE868kzuFg7I5GR+wdbgLLSI=; b=CvzJCjppIXl4MNtjDeY0M6GRRY
        3gm0cNNiIsr3p6T4K1LTY6I2gkvxd/MZ2qGairDy3MLAwbW6J5yNOIHCVlOp38Duh03SXkIOEBSb8
        9C6Dq6IXaBkKyFc8B6D3hY7rxsoPWKZq3vINi4FZ2QZk9mpwCcIkL1rdWC/WRp66f0zIR9yv0JJQW
        xBa11hoNiGrGGS3xIqixtlJ+zqjW369RXJGPa75Xy35Y/u2eVIjEhgQ3zkW+BZhPTb0HANcJ3Y2yD
        or96BhaRkPfPmI0JHzp5mKENXYG/XVw5UrGrPqnF2/TCVYcli2Y40RJGeoycK0/qdvK6rEiGgUGf/
        Fdp1Ek3g==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOLCX-007dyo-Eb; Sun, 27 Feb 2022 15:11:09 +0000
Message-ID: <c231fe921c11b2097d7747dd1d16279cef349c0a.camel@infradead.org>
Subject: [PATCH] KVM: Remove dirty handling from gfn_to_pfn_cache completely
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sun, 27 Feb 2022 15:11:08 +0000
In-Reply-To: <YhklbH6ZyYrZmmGw@google.com>
References: <20220223165302.3205276-1-seanjc@google.com>
         <2547e9675d855449bc5cc7efb97251d6286a377c.camel@amazon.co.uk>
         <YhkAJ+nw2lCzRxsg@google.com>
         <915ddc7327585bbe8587b91b8cd208520d684db1.camel@infradead.org>
         <YhkRcK64Jya6YpA9@google.com>
         <550e1d7ef2b2f7f666e5b60e9bb855a8ccc0fb14.camel@infradead.org>
         <YhklbH6ZyYrZmmGw@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-72mtBZxZq2PjpjOoYfPb"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
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


--=-72mtBZxZq2PjpjOoYfPb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

It isn't OK to cache the dirty status of a page in internal structures
for an indefinite period of time.

Any time a vCPU exits the run loop to userspace might be its last; the
VMM might do its final check of the dirty log, flush the last remaining
dirty pages to the destination and complete a live migration. If we
have internal 'dirty' state which doesn't get flushed until the vCPU
is finally destroyed on the source after migration is complete, then
we have lost data because that will escape the final copy.

This problem already exists with the use of kvm_vcpu_unmap() to mark
pages dirty in e.g. VMX nesting.

Note that the actual Linux MM already considers the page to be dirty
since we have a writeable mapping of it. This is just about the KVM
dirty logging.

Make the PV clock mark the page dirty immediately (which is fine as
it's happening in vCPU context). Document the Xen shinfo/vcpu_info
case more completely as being exempt, because we might dirty those
from interrupt context as we deliver event channels.

For the nesting-style use cases (KVM_GUEST_USES_PFN) we will need to
track which gfn_to_pfn_caches have been used and explicitly mark the
corresponding pages dirty before returning to userspace. But we would
have needed external tracking of that anyway, rather than walking the
full list of GPCs to find those belonging to this vCPU which are dirty.

So let's rely *solely* on that external tracking, and keep it simple
rather than laying a tempting trap for callers to fall into.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---

This sits on top of the Xen event channel series, because that adds a
few users of gfn_to_pfn_cache and I wanted to see it actually being
used this way. If we're OK with this approach, I'll refactor that
series to put this first.

I think this is OK for the KVM_GUEST_USES_PFN cases (mostly nesting)
because, as I note in the commit message, they're going to want to keep
track of which caches they have used *anyway* to avoid walking the full
GPC list on every exit to userspace.

 Documentation/virt/kvm/api.rst |  4 ++++
 arch/x86/kvm/x86.c             |  8 +++----
 arch/x86/kvm/xen.c             | 24 +++++++-------------
 include/linux/kvm_host.h       | 14 +++++-------
 include/linux/kvm_types.h      |  3 +--
 virt/kvm/pfncache.c            | 41 +++++++---------------------------
 6 files changed, 30 insertions(+), 64 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 982fcdf8cfa8..77b631452036 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5288,6 +5288,10 @@ type values:
=20
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
   Sets the guest physical address of the vcpu_info for a given vCPU.
+  As with the shared_info page for the VM, the corresponding page may be
+  dirtied at any time if event channel interrupt delivery is enabled, so
+  userspace should always assume that the page is dirty without relying
+  on dirty logging.
=20
 KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
   Sets the guest physical address of an additional pvclock structure
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04f86cb94069..08317ad5c93b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2237,8 +2237,7 @@ static void kvm_write_system_time(struct kvm_vcpu *vc=
pu, gpa_t system_time,
 	if (system_time & 1) {
 		kvm_gfn_to_pfn_cache_init(vcpu->kvm, &vcpu->arch.pv_time, vcpu,
 					  KVM_HOST_USES_PFN, system_time & ~1ULL,
-					  sizeof(struct pvclock_vcpu_time_info),
-					  false);
+					  sizeof(struct pvclock_vcpu_time_info));
 	} else {
 		kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.pv_time);
 	}
@@ -2958,8 +2957,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *=
v,
 		read_unlock_irqrestore(&gpc->lock, flags);
=20
 		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 offset + sizeof(*guest_hv_clock),
-						 true))
+						 offset + sizeof(*guest_hv_clock)))
 			return;
=20
 		read_lock_irqsave(&gpc->lock, flags);
@@ -2989,6 +2987,8 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *=
v,
 	smp_wmb();
=20
 	guest_hv_clock->version =3D ++vcpu->hv_clock.version;
+
+	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 	read_unlock_irqrestore(&gpc->lock, flags);
=20
 	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index f59dca40d7c3..71311bb03d53 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -49,7 +49,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_=
t gfn)
=20
 	do {
 		ret =3D kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, KVM_HOST_USES_PFN,
-						gpa, PAGE_SIZE, false);
+						gpa, PAGE_SIZE);
 		if (ret)
 			goto out;
=20
@@ -245,8 +245,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, =
int state)
 		if (state =3D=3D RUNSTATE_runnable)
 			return;
=20
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 user_len, false))
+		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa, user_len))
 			return;
=20
 		read_lock_irqsave(&gpc->lock, flags);
@@ -377,8 +376,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 		read_unlock_irqrestore(&gpc->lock, flags);
=20
 		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 sizeof(struct vcpu_info),
-						 false))
+						 sizeof(struct vcpu_info)))
 			return;
=20
 		read_lock_irqsave(&gpc->lock, flags);
@@ -454,8 +452,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 			return 1;
=20
 		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
-						 sizeof(struct vcpu_info),
-						 false)) {
+						 sizeof(struct vcpu_info))) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -583,7 +580,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
 		r =3D kvm_gfn_to_pfn_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_info_cache,
 					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct vcpu_info), false);
+					      sizeof(struct vcpu_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
=20
@@ -600,8 +597,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
 		r =3D kvm_gfn_to_pfn_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_time_info_cache,
 					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct pvclock_vcpu_time_info),
-					      false);
+					      sizeof(struct pvclock_vcpu_time_info));
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
@@ -621,8 +617,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
 		r =3D kvm_gfn_to_pfn_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.runstate_cache,
 					      NULL, KVM_HOST_USES_PFN, data->u.gpa,
-					      sizeof(struct vcpu_runstate_info),
-					      false);
+					      sizeof(struct vcpu_runstate_info));
 		break;
=20
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
@@ -1513,8 +1508,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *=
xe, struct kvm *kvm)
 			break;
=20
 		idx =3D srcu_read_lock(&kvm->srcu);
-		rc =3D kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpc->gpa,
-						  PAGE_SIZE, false);
+		rc =3D kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
=20
@@ -1829,10 +1823,8 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
=20
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
 				     &vcpu->arch.xen.runstate_cache);
-	vcpu->arch.xen.vcpu_info_cache.dirty =3D false;
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
 				     &vcpu->arch.xen.vcpu_info_cache);
-	vcpu->arch.xen.vcpu_time_info_cache.dirty =3D false;
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
 				     &vcpu->arch.xen.vcpu_time_info_cache);
 	del_timer_sync(&vcpu->arch.xen.poll_timer);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6e5bbb1b3e0d..aa596fd19578 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1228,7 +1228,6 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, =
gfn_t gfn);
  *		   by KVM (and thus needs a kernel virtual mapping).
  * @gpa:	   guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
- * @dirty:         mark the cache dirty immediately.
  *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
@@ -1242,7 +1241,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, =
gfn_t gfn);
  */
 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gp=
c,
 			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-			      gpa_t gpa, unsigned long len, bool dirty);
+			      gpa_t gpa, unsigned long len);
=20
 /**
  * kvm_gfn_to_pfn_cache_check - check validity of a gfn_to_pfn_cache.
@@ -1251,7 +1250,6 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct=
 gfn_to_pfn_cache *gpc,
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   current guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
- * @dirty:         mark the cache dirty immediately.
  *
  * @return:	   %true if the cache is still valid and the address matches.
  *		   %false if the cache is not valid.
@@ -1273,7 +1271,6 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, stru=
ct gfn_to_pfn_cache *gpc,
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   updated guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
- * @dirty:         mark the cache dirty immediately.
  *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
@@ -1286,7 +1283,7 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, stru=
ct gfn_to_pfn_cache *gpc,
  * with the lock still held to permit access.
  */
 int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache =
*gpc,
-				 gpa_t gpa, unsigned long len, bool dirty);
+				 gpa_t gpa, unsigned long len);
=20
 /**
  * kvm_gfn_to_pfn_cache_unmap - temporarily unmap a gfn_to_pfn_cache.
@@ -1294,10 +1291,9 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, st=
ruct gfn_to_pfn_cache *gpc,
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  *
- * This unmaps the referenced page and marks it dirty, if appropriate. The
- * cache is left in the invalid state but at least the mapping from GPA to
- * userspace HVA will remain cached and can be reused on a subsequent
- * refresh.
+ * This unmaps the referenced page. The cache is left in the invalid state
+ * but at least the mapping from GPA to userspace HVA will remain cached
+ * and can be reused on a subsequent refresh.
  */
 void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *=
gpc);
=20
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 784f37cbf33e..d1447801fc68 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
+#/* SPDX-License-Identifier: GPL-2.0-only */
=20
 #ifndef __KVM_TYPES_H__
 #define __KVM_TYPES_H__
@@ -74,7 +74,6 @@ struct gfn_to_pfn_cache {
 	enum pfn_cache_usage usage;
 	bool active;
 	bool valid;
-	bool dirty;
 };
=20
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 9b3a192cb18c..d789f2705e5e 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -49,19 +49,6 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, =
unsigned long start,
 				}
 				__set_bit(gpc->vcpu->vcpu_idx, vcpu_bitmap);
 			}
-
-			/*
-			 * We cannot call mark_page_dirty() from here because
-			 * this physical CPU might not have an active vCPU
-			 * with which to do the KVM dirty tracking.
-			 *
-			 * Neither is there any point in telling the kernel MM
-			 * that the underlying page is dirty. A vCPU in guest
-			 * mode might still be writing to it up to the point
-			 * where we wake them a few lines further down anyway.
-			 *
-			 * So all the dirty marking happens on the unmap.
-			 */
 		}
 		write_unlock_irq(&gpc->lock);
 	}
@@ -104,8 +91,7 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct =
gfn_to_pfn_cache *gpc,
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
=20
-static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva,
-			  gpa_t gpa, bool dirty)
+static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva, gpa_=
t gpa)
 {
 	/* Unmap the old page if it was mapped before, and release it */
 	if (!is_error_noslot_pfn(pfn)) {
@@ -118,9 +104,7 @@ static void __release_gpc(struct kvm *kvm, kvm_pfn_t pf=
n, void *khva,
 #endif
 		}
=20
-		kvm_release_pfn(pfn, dirty);
-		if (dirty)
-			mark_page_dirty(kvm, gpa);
+		kvm_release_pfn(pfn, false);
 	}
 }
=20
@@ -152,7 +136,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsi=
gned long uhva)
 }
=20
 int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache =
*gpc,
-				 gpa_t gpa, unsigned long len, bool dirty)
+				 gpa_t gpa, unsigned long len)
 {
 	struct kvm_memslots *slots =3D kvm_memslots(kvm);
 	unsigned long page_offset =3D gpa & ~PAGE_MASK;
@@ -160,7 +144,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struc=
t gfn_to_pfn_cache *gpc,
 	unsigned long old_uhva;
 	gpa_t old_gpa;
 	void *old_khva;
-	bool old_valid, old_dirty;
+	bool old_valid;
 	int ret =3D 0;
=20
 	/*
@@ -177,14 +161,12 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, str=
uct gfn_to_pfn_cache *gpc,
 	old_khva =3D gpc->khva - offset_in_page(gpc->khva);
 	old_uhva =3D gpc->uhva;
 	old_valid =3D gpc->valid;
-	old_dirty =3D gpc->dirty;
=20
 	/* If the userspace HVA is invalid, refresh that first */
 	if (gpc->gpa !=3D gpa || gpc->generation !=3D slots->generation ||
 	    kvm_is_error_hva(gpc->uhva)) {
 		gfn_t gfn =3D gpa_to_gfn(gpa);
=20
-		gpc->dirty =3D false;
 		gpc->gpa =3D gpa;
 		gpc->generation =3D slots->generation;
 		gpc->memslot =3D __gfn_to_memslot(slots, gfn);
@@ -255,14 +237,9 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, stru=
ct gfn_to_pfn_cache *gpc,
 	}
=20
  out:
-	if (ret)
-		gpc->dirty =3D false;
-	else
-		gpc->dirty =3D dirty;
-
 	write_unlock_irq(&gpc->lock);
=20
-	__release_gpc(kvm, old_pfn, old_khva, old_gpa, old_dirty);
+	__release_gpc(kvm, old_pfn, old_khva, old_gpa);
=20
 	return ret;
 }
@@ -272,7 +249,6 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct=
 gfn_to_pfn_cache *gpc)
 {
 	void *old_khva;
 	kvm_pfn_t old_pfn;
-	bool old_dirty;
 	gpa_t old_gpa;
=20
 	write_lock_irq(&gpc->lock);
@@ -280,7 +256,6 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, struct=
 gfn_to_pfn_cache *gpc)
 	gpc->valid =3D false;
=20
 	old_khva =3D gpc->khva - offset_in_page(gpc->khva);
-	old_dirty =3D gpc->dirty;
 	old_gpa =3D gpc->gpa;
 	old_pfn =3D gpc->pfn;
=20
@@ -293,14 +268,14 @@ void kvm_gfn_to_pfn_cache_unmap(struct kvm *kvm, stru=
ct gfn_to_pfn_cache *gpc)
=20
 	write_unlock_irq(&gpc->lock);
=20
-	__release_gpc(kvm, old_pfn, old_khva, old_gpa, old_dirty);
+	__release_gpc(kvm, old_pfn, old_khva, old_gpa);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_unmap);
=20
=20
 int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gp=
c,
 			      struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
-			      gpa_t gpa, unsigned long len, bool dirty)
+			      gpa_t gpa, unsigned long len)
 {
 	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) !=3D usage);
=20
@@ -319,7 +294,7 @@ int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct g=
fn_to_pfn_cache *gpc,
 		list_add(&gpc->list, &kvm->gpc_list);
 		spin_unlock(&kvm->gpc_lock);
 	}
-	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len, dirty);
+	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_init);
=20
--=20
2.33.1


--=-72mtBZxZq2PjpjOoYfPb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMjI3MTUxMTA4WjAvBgkqhkiG9w0BCQQxIgQgGnlPju3K
DqGUq5ecZ8ueeh5XUcWK8rLzrgB7tpsGWDkwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAN9kCfe6ZmVDDFyaBF5fMxJHBDfeqiPjOV
0d5mA3q9ccWrQvskL+9h68SAMkCZPZouQUj6c48SqSgjHfpKwM13B9M7QI+PKYYptbbpqwwnRpdG
nF7tXOcmLFmmZhHGNczIlbUezmtMcLTzsZrcr6F5Kh6X+8F+6U485yupBzHs8QCP9PXfDmL1g0gc
GhbQTFbynbc4CPIBSnOV0k/w2woop5xDhYynwYVBX+dAUYLyCNPv+pjjmRGeVp+phBJVvTJPCf8u
h7v7eZtINPyFnLC4QVWktjQJ0FOBcEqfiGjzWeImUJPXSS5bHwf97KJy4rnPWL/x6SfdEe28SEaY
+rnWfHrGdmp3xX/l7Au7OIDuX+ZIESiX7nZK6cR/ETpbTlmsPI68DernEutBUt6Avfm9xKaHfEAB
QrW+/rz8e3hI3vm6RaUVa0wt8wq6vgd3vaasdBwAiaJ2/VR6OIP0i1Oh6qMIxCWlxSiLoJ9cH7sf
Gc/+3bpfSWlq9bQ/6YdPH7c3vC+jEchbHNMB8XRzKJHD/0KHsePdex0rEy4Xvjo9raPrfRqUpVHb
XZgDvlZgzCIu+jgSjvcHJhiKCgKeK4G9bMwjXo8zNPLeSwfS8BGzwlBMomd0dYlW0qmp3bqJkPwv
waDB12XL2yiL+FqQS/Vf2zebbZt8UbekIrSX6QJBxwAAAAAAAA==


--=-72mtBZxZq2PjpjOoYfPb--

