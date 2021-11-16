Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419DB45384A
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 18:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237307AbhKPRKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 12:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbhKPRKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 12:10:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1017BC061570;
        Tue, 16 Nov 2021 09:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Athk7QhOX+XF+7kU5mobL1dTLNMQcGq+rRZNqKuBEHI=; b=AzyLEMBgBOK94ViY+UroM3Cmyu
        H4cKwMph/jdkPrPfyjX72JYYS4x24wV5BsBg06q7Jk7zextoMT9m72Mh54MncB679J2x7rqJD0htG
        7kKvFm5VJVnGtDnsM/OOHB32E+dvkNO/1zhs34KW+l2zEOGSAsaZ5GIT77aLtOLhUc0aUOixuIiyO
        Mja3CaG3cdI02U+Du2CSmz4eJTCweNFaWkRGf/ngDDN85TagB7ZjCU2oHxdX6T8iUKthTgVklXLGP
        6tjX/SdEvohRmmcMFwt3t+Yb/QxFrJ55SuXx3E0Qth+sVb10yJBp4duz1HLjm1nmPBSOOjLX6DKfV
        O1A4iu6Q==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=freeip.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mn1vN-002Qjc-3n; Tue, 16 Nov 2021 17:07:13 +0000
Message-ID: <2563218f606faac912d17a40edb4d564191fd9f8.camel@infradead.org>
Subject: Re: [EXTERNAL] There is a null-ptr-deref bug in kvm_dirty_ring_get
 in virt/kvm/dirty_ring.c
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Tue, 16 Nov 2021 17:07:10 +0000
In-Reply-To: <a6d8416c50ba86b57f7f193c1ea2f388de90c0bc.camel@infradead.org>
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
         <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
         <a6d8416c50ba86b57f7f193c1ea2f388de90c0bc.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-eC5qnGabH/QYqwcM5mUy"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-eC5qnGabH/QYqwcM5mUy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-11-16 at 16:22 +0000, David Woodhouse wrote:
>=20
> I suppose we could make it a KVM_XEN_VCPU_SET_ATTR instead, and thus
> associate it with a particular CPU at least for the initial wallclock
> write?
>=20

We'd end up needing to do all this too, to plumb that 'vcpu' through to
the actual mark_page_dirty_in_slot(). And I might end up wanting to
kill kvm_write_guest() et al completely. If we're never supposed to be
writing without a vCPU associated with the write, then we should always
use kvm_vcpu_write_guest(), shouldn't we?

Paolo, what do you think? Want me to finish and test this and submit
it, along with changing the shinfo address to a per-vCPU thing?

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 326cdfec74a1..d8411ce4db4b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1143,7 +1143,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
 		kvm_set_pfn_dirty(pfn);
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+		mark_page_dirty_in_slot(kvm, vcpu, memslot, gfn);
 	}
=20
 out_unlock:
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33794379949e..4fd2ad5327b6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3090,7 +3090,7 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct=
 kvm_page_fault *fault,
 		return false;
=20
 	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
-		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
+		mark_page_dirty_in_slot(vcpu->kvm, vcpu, fault->slot, fault->gfn);
=20
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 0c76c45fdb68..0598515f3ae2 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -184,7 +184,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_pa=
ge *sp,
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON(level > PG_LEVEL_4K);
-		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
+		mark_page_dirty_in_slot(vcpu->kvm, vcpu, slot, gfn);
 	}
=20
 	*new_spte =3D spte;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a54c3491af42..c5669c9918a4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -247,7 +247,7 @@ static void handle_changed_spte_dirty_log(struct kvm *k=
vm, int as_id, gfn_t gfn,
 	if ((!is_writable_pte(old_spte) || pfn_changed) &&
 	    is_writable_pte(new_spte)) {
 		slot =3D __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
-		mark_page_dirty_in_slot(kvm, slot, gfn);
+		mark_page_dirty_in_slot(kvm, NULL, slot, gfn);
 	}
 }
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a879e4d08758..c14ce545fae9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2118,7 +2118,7 @@ static s64 get_kvmclock_base_ns(void)
 }
 #endif
=20
-void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_of=
s)
+void kvm_write_wall_clock(struct kvm_vcpu *vcpu, gpa_t wall_clock, int sec=
_hi_ofs)
 {
 	int version;
 	int r;
@@ -2129,7 +2129,7 @@ void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall=
_clock, int sec_hi_ofs)
 	if (!wall_clock)
 		return;
=20
-	r =3D kvm_read_guest(kvm, wall_clock, &version, sizeof(version));
+	r =3D kvm_vcpu_read_guest(vcpu, wall_clock, &version, sizeof(version));
 	if (r)
 		return;
=20
@@ -2138,7 +2138,7 @@ void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall=
_clock, int sec_hi_ofs)
=20
 	++version;
=20
-	if (kvm_write_guest(kvm, wall_clock, &version, sizeof(version)))
+	if (kvm_vcpu_write_guest(vcpu, wall_clock, &version, sizeof(version)))
 		return;
=20
 	/*
@@ -2146,22 +2146,22 @@ void kvm_write_wall_clock(struct kvm *kvm, gpa_t wa=
ll_clock, int sec_hi_ofs)
 	 * system time (updated by kvm_guest_time_update below) to the
 	 * wall clock specified here.  We do the reverse here.
 	 */
-	wall_nsec =3D ktime_get_real_ns() - get_kvmclock_ns(kvm);
+	wall_nsec =3D ktime_get_real_ns() - get_kvmclock_ns(vcpu->kvm);
=20
 	wc.nsec =3D do_div(wall_nsec, 1000000000);
 	wc.sec =3D (u32)wall_nsec; /* overflow in 2106 guest time */
 	wc.version =3D version;
=20
-	kvm_write_guest(kvm, wall_clock, &wc, sizeof(wc));
+	kvm_vcpu_write_guest(vcpu, wall_clock, &wc, sizeof(wc));
=20
 	if (sec_hi_ofs) {
 		wc_sec_hi =3D wall_nsec >> 32;
-		kvm_write_guest(kvm, wall_clock + sec_hi_ofs,
-				&wc_sec_hi, sizeof(wc_sec_hi));
+		kvm_vcpu_write_guest(vcpu, wall_clock + sec_hi_ofs,
+				     &wc_sec_hi, sizeof(wc_sec_hi));
 	}
=20
 	version++;
-	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
+	kvm_vcpu_write_guest(vcpu, wall_clock, &version, sizeof(version));
 }
=20
 static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time=
,
@@ -3353,7 +3353,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
  out:
 	user_access_end();
  dirty:
-	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
+	mark_page_dirty_in_slot(vcpu->kvm, vcpu, ghc->memslot, gpa_to_gfn(ghc->gp=
a));
 }
=20
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -3494,14 +3494,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
 			return 1;
=20
 		vcpu->kvm->arch.wall_clock =3D data;
-		kvm_write_wall_clock(vcpu->kvm, data, 0);
+		kvm_write_wall_clock(vcpu, data, 0);
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
 			return 1;
=20
 		vcpu->kvm->arch.wall_clock =3D data;
-		kvm_write_wall_clock(vcpu->kvm, data, 0);
+		kvm_write_wall_clock(vcpu, data, 0);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
@@ -4421,7 +4421,7 @@ static void kvm_steal_time_set_preempted(struct kvm_v=
cpu *vcpu)
 	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
 		vcpu->arch.st.preempted =3D KVM_VCPU_PREEMPTED;
=20
-	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
+	mark_page_dirty_in_slot(vcpu->kvm, vcpu, ghc->memslot, gpa_to_gfn(ghc->gp=
a));
 }
=20
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ea264c4502e4..f1dab3413fc8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -294,7 +294,7 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu =
*vcpu)
 	return is_smm(vcpu) || static_call(kvm_x86_apic_init_signal_blocked)(vcpu=
);
 }
=20
-void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_of=
s);
+void kvm_write_wall_clock(struct kvm_vcpu *vcpu, gpa_t wall_clock, int sec=
_hi_ofs);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc=
_eip);
=20
 u64 get_kvmclock_ns(struct kvm *kvm);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 7a58df25c9b2..e7b0c0af807d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -37,7 +37,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_=
t gfn)
=20
 	ret =3D kvm_gfn_to_pfn_cache_init(kvm, gpc, NULL, true, gpa,
 					PAGE_SIZE, true);
-	if (ret)
+	if (ret && !kvm->vcpus[0])
 		goto out;
=20
 	/* Paranoia checks on the 32-bit struct layout */
@@ -60,7 +60,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_=
t gfn)
 	}
 #endif
=20
-	kvm_write_wall_clock(kvm, gpa + wc_ofs, sec_hi_ofs - wc_ofs);
+	kvm_write_wall_clock(kvm->vcpus[0], gpa + wc_ofs, sec_hi_ofs - wc_ofs);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MASTERCLOCK_UPDATE);
=20
 out:
@@ -316,7 +316,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	err:
 		user_access_end();
=20
-		mark_page_dirty_in_slot(v->kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+		mark_page_dirty_in_slot(v->kvm, v, ghc->memslot, ghc->gpa >> PAGE_SHIFT)=
;
 	} else {
 		__get_user(rc, (u8 __user *)ghc->hva + offset);
 	}
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.=
h
index 4da8d4a4140b..f3be974f9c5a 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -43,7 +43,8 @@ static inline int kvm_dirty_ring_alloc(struct kvm_dirty_r=
ing *ring,
 	return 0;
 }
=20
-static inline struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
+static inline struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm,
+							struct kvm_vcpu *vcpu)
 {
 	return NULL;
 }
@@ -78,7 +79,8 @@ static inline bool kvm_dirty_ring_soft_full(struct kvm_di=
rty_ring *ring)
=20
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)=
;
-struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm);
+struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm,
+					  struct kvm_vcpu *vcpu);
=20
 /*
  * called with kvm->slots_lock held, returns the number of
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f145a58e37b0..59a92a82e3a3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -954,7 +954,8 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm,=
 gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
-void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *mems=
lot, gfn_t gfn);
+void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			     struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
=20
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 2b4474387895..879d454eef71 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -36,12 +36,16 @@ static bool kvm_dirty_ring_full(struct kvm_dirty_ring *=
ring)
 	return kvm_dirty_ring_used(ring) >=3D ring->size;
 }
=20
-struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
+struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm, struct kvm_vcpu=
 *vcpu)
 {
-	struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();
+	struct kvm_vcpu *running_vcpu =3D kvm_get_running_vcpu();
=20
+	WARN_ON_ONCE(vcpu && vcpu !=3D running_vcpu);
 	WARN_ON_ONCE(vcpu->kvm !=3D kvm);
=20
+	if (!vcpu)
+		vcpu =3D running_vcpu;
+
 	return &vcpu->dirty_ring;
 }
=20
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4065fd32271a..24f300e5fa96 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2787,7 +2787,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu,=
 gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
=20
-static int __kvm_write_guest_page(struct kvm *kvm,
+static int __kvm_write_guest_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
 {
@@ -2800,7 +2800,7 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	r =3D __copy_to_user((void __user *)addr + offset, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(kvm, memslot, gfn);
+	mark_page_dirty_in_slot(kvm, vcpu, memslot, gfn);
 	return 0;
 }
=20
@@ -2809,7 +2809,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
 {
 	struct kvm_memory_slot *slot =3D gfn_to_memslot(kvm, gfn);
=20
-	return __kvm_write_guest_page(kvm, slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(kvm, NULL, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
=20
@@ -2818,7 +2818,7 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, =
gfn_t gfn,
 {
 	struct kvm_memory_slot *slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn);
=20
-	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
+	return __kvm_write_guest_page(vcpu->kvm, vcpu, slot, gfn, data, offset, l=
en);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
=20
@@ -2937,7 +2937,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, st=
ruct gfn_to_hva_cache *ghc,
 	r =3D __copy_to_user((void __user *)ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
-	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
+	mark_page_dirty_in_slot(kvm, NULL, ghc->memslot, gpa >> PAGE_SHIFT);
=20
 	return 0;
 }
@@ -3006,7 +3006,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsig=
ned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
=20
-void mark_page_dirty_in_slot(struct kvm *kvm,
+void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			     struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
 {
@@ -3015,7 +3015,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		u32 slot =3D (memslot->as_id << 16) | memslot->id;
=20
 		if (kvm->dirty_ring_size)
-			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
+			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm, vcpu),
 					    slot, rel_gfn);
 		else
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
@@ -3028,7 +3028,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
=20
 	memslot =3D gfn_to_memslot(kvm, gfn);
-	mark_page_dirty_in_slot(kvm, memslot, gfn);
+	mark_page_dirty_in_slot(kvm, NULL, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
=20
@@ -3037,7 +3037,7 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, =
gfn_t gfn)
 	struct kvm_memory_slot *memslot;
=20
 	memslot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
+	mark_page_dirty_in_slot(vcpu->kvm, vcpu, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
=20


--=-eC5qnGabH/QYqwcM5mUy
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEx
MTE2MTcwNzEwWjAvBgkqhkiG9w0BCQQxIgQgWnvawsrbTbvrBbgzV1nFI94HZWW8lGinvOvSMUk1
6Qowgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBACMDTPJgvvTgl6t7heQwPBobPY9QUdNMotBelB53J0a9Ck0xFSWOOMMVrkDx5Dja
cl35J0VDI/hV/xG+bSo0btlpSlvltsbkdZ6wg4deFknDSpVTcd86hUPGt61+ghMTrmjQQF5PxLtY
4aUWtfPiVyNRzCJIhx9nh0jA9/t8cvqjnbSHphsuOeWN+Bi5gOg9uTaZIOq3odgupejhVxJuExCp
s/CzR5rDs9qqKMxy/As7l2EzinLUdHeyczo3f+dmAIgiQpmvphcmGbDk6b6gST/Z1wEdVRbibluf
YtsDZ6hg03KpUTbQofjjyqAkvLTPOnPfGeJsDFHUB8qiCfGwPyIAAAAAAAA=


--=-eC5qnGabH/QYqwcM5mUy--

