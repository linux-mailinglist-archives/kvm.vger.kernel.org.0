Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE89243F2AF
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 00:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhJ1WZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 18:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhJ1WZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 18:25:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C521FC061570
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 15:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yJLPYNOcFrypNVbkDc5/trGSzxwocdzr0Z3p/pF2eDU=; b=dnYiYPNFGCjYlc1com+XAj4163
        mih9fONyObCgGoOiplryP4rTXo3tENTKkpiEf9uNeOsLoLs/lvzuOLXVEfrU7kpAbVTOyumGJllVe
        5oNBPrmktw0P+9QpxTLN8lyP1147nGmOLvQr7a/6zziIcq6NEHsmLC09nQvbDtwcmEU+6AFpIj4tk
        ndqBl9raz5X6bQ3+qtSrkjKaPyxjPmMpnQJhOLlz3Aq61XtNAptQplO3V1tq2/hZjJjokwNK7hJZO
        4kQBBpdpjtNYJvMOOkjGJHyGqjkUB17dfqdW/PKihyfzcKrVAnOylv8SlAeug/h3E+plWlmnV1wPi
        0U5gphLw==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mgDmz-009FGe-94; Thu, 28 Oct 2021 22:22:25 +0000
Message-ID: <1d5f4755ea6be5c7eb8f59dea2daef30fc16b173.camel@infradead.org>
Subject: Re: [EXTERNAL] [PATCH] KVM: x86/xen: Fix runstate updates to be
 atomic when preempting vCPU
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Date:   Thu, 28 Oct 2021 23:22:21 +0100
In-Reply-To: <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
         <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com>
         <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org>
         <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-TzpBNLCAQ4hz8vbeds5h"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-TzpBNLCAQ4hz8vbeds5h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-10-25 at 13:19 +0100, David Woodhouse wrote:
> On Mon, 2021-10-25 at 11:39 +0100, David Woodhouse wrote:
> > > One possible solution (which I even have unfinished patches for) is t=
o
> > > put all the gfn_to_pfn_caches on a list, and refresh them when the MM=
U
> > > notifier receives an invalidation.
> >=20
> > For this use case I'm not even sure why I'd *want* to cache the PFN and
> > explicitly kmap/memremap it, when surely by *definition* there's a
> > perfectly serviceable HVA which already points to it?
>=20
> That's indeed true for *this* use case but my *next* use case is
> actually implementing the event channel delivery.
>=20
> What we have in-kernel already is everything we absolutely *need* in
> order to host Xen guests, but I really do want to fix the fact that
> even IPIs and timers are bouncing up through userspace.

Here's a completely untested attempt, in which all the complexity is
based around the fact that I can't just pin the pages as Jo=C3=A3o and
Ankur's original did.

It adds a new KVM_IRQ_ROUTING_XEN_EVTCHN with an ABI that allows for us
to add FIFO event channels, but for now only supports 2 level.

In kvm_xen_set_evtchn() I currently use kvm_map_gfn() *without* a cache
at all, but I'll work something out for that. I think I can use a
gfn_to_hva_cache (like the one removed in commit 319afe685) and in the
rare case that it's invalid, I can take kvm->lock to revalidate it.

It sets the bit in the global shared info but doesn't touch the target
vCPU's vcpu_info; instead it sets a bit in an *in-kernel* shadow of the
target's evtchn_pending_sel word, and kicks the vCPU.

That shadow is actually synced to the guest's vcpu_info struct in
kvm_xen_has_interrupt(). There's a little bit of fun asm there to set
the bits in the userspace struct and then clear the same set of bits in
the kernel shadow *if* the first op didn't fault. Or such is the
intent; I didn't hook up a test yet.

As things stand, I should be able to use this for delivery of PIRQs
from my VMM, where things like passed-through PCI MSI gets turned into
Xen event channels. As well as KVM unit tests, of course.

The plan is then to hook up IPIs and timers =E2=80=94 again based on the Or=
acle
code from before, but using eventfds for the actual evtchn delivery.=20

=46rom be4b79e54ed07bbd2e4310a6da9e990efa6fbc6e Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Thu, 28 Oct 2021 23:10:31 +0100
Subject: [PATCH] KVM: x86/xen: First attempt at KVM_IRQ_ROUTING_XEN_EVTCHN

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/irq_comm.c         |  12 +++
 arch/x86/kvm/xen.c              | 176 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/xen.h              |   6 ++
 include/linux/kvm_host.h        |   7 ++
 include/uapi/linux/kvm.h        |  10 ++
 6 files changed, 207 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 70771376e246..e1a4521ae838 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -606,6 +606,7 @@ struct kvm_vcpu_xen {
 	u64 last_steal;
 	u64 runstate_entry_time;
 	u64 runstate_times[4];
+	unsigned long evtchn_pending_sel;
 };
=20
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d5b72a08e566..6894f9a369f2 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -24,6 +24,7 @@
=20
 #include "hyperv.h"
 #include "x86.h"
+#include "xen.h"
=20
 static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 			   struct kvm *kvm, int irq_source_id, int level,
@@ -175,6 +176,13 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_ro=
uting_entry *e,
 			return r;
 		break;
=20
+#ifdef CONFIG_KVM_XEN
+	case KVM_IRQ_ROUTING_XEN_EVTCHN:
+		if (!level)
+			return -1;
+
+		return kvm_xen_set_evtchn(e, kvm, true);
+#endif
 	default:
 		break;
 	}
@@ -310,6 +318,10 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->hv_sint.vcpu =3D ue->u.hv_sint.vcpu;
 		e->hv_sint.sint =3D ue->u.hv_sint.sint;
 		break;
+#ifdef CONFIG_KVM_XEN
+	case KVM_IRQ_ROUTING_XEN_EVTCHN:
+		return kvm_xen_setup_evtchn(kvm, e, ue);
+#endif
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c4bca001a7c9..bff5c458af96 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -207,6 +207,8 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, =
int state)
=20
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 {
+	unsigned long evtchn_pending_sel =3D READ_ONCE(v->arch.xen.evtchn_pending=
_sel);
+	bool atomic =3D in_atomic() || !task_is_running(current);
 	int err;
 	u8 rc =3D 0;
=20
@@ -216,6 +218,9 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	 */
 	struct gfn_to_hva_cache *ghc =3D &v->arch.xen.vcpu_info_cache;
 	struct kvm_memslots *slots =3D kvm_memslots(v->kvm);
+	bool ghc_valid =3D slots->generation =3D=3D ghc->generation &&
+		!kvm_is_error_hva(ghc->hva) && ghc->memslot;
+
 	unsigned int offset =3D offsetof(struct vcpu_info, evtchn_upcall_pending)=
;
=20
 	/* No need for compat handling here */
@@ -231,8 +236,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	 * cache in kvm_read_guest_offset_cached(), but just uses
 	 * __get_user() instead. And falls back to the slow path.
 	 */
-	if (likely(slots->generation =3D=3D ghc->generation &&
-		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
+	if (!evtchn_pending_sel && ghc_valid) {
 		/* Fast path */
 		pagefault_disable();
 		err =3D __get_user(rc, (u8 __user *)ghc->hva + offset);
@@ -251,12 +255,72 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	 * and we'll end up getting called again from a context where we *can*
 	 * fault in the page and wait for it.
 	 */
-	if (in_atomic() || !task_is_running(current))
+	if (atomic)
 		return 1;
=20
-	kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
-				     sizeof(rc));
+	if (!ghc_valid) {
+		err =3D kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len);
+		if (err && !ghc->memslot) {
+			/*
+			 * If this failed, userspace has screwed up the
+			 * vcpu_info mapping. No interrupts for you.
+			 */
+			return 0;
+		}
+	}
=20
+	/*
+	 * Now we have a valid (protected by srcu) userspace HVA in
+	 * ghc->hva which points to the struct vcpu_info. If there
+	 * are any bits in the in-kernel evtchn_pending_sel then
+	 * we need to write those to the guest vcpu_info and set
+	 * its evtchn_upcall_pending flag. If there aren't any bits
+	 * to add, we only want to *check* evtchn_upcall_pending.
+	 */
+	if (evtchn_pending_sel) {
+		if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
+			struct vcpu_info __user *vi =3D (void *)ghc->hva;
+
+			/* Attempt to set the evtchn_pending_sel bits in the
+			 * guest, and if that succeeds then clear the same
+			 * bits in the in-kernel version. */
+			asm volatile("1:\t" LOCK_PREFIX "orq %1, %0\n"
+				     "\tnotq %0\n"
+				     "\t" LOCK_PREFIX "andq %2, %0\n"
+				     "2:\n"
+				     "\t.section .fixup,\"ax\"\n"
+				     "3:\tjmp\t2b\n"
+				     "\t.previous\n"
+				     _ASM_EXTABLE_UA(1b, 3b)
+				     : "=3Dr" (evtchn_pending_sel)
+				     : "m" (vi->evtchn_pending_sel),
+				       "m" (v->arch.xen.evtchn_pending_sel),
+				       "0" (evtchn_pending_sel));
+		} else {
+			struct compat_vcpu_info __user *vi =3D (void *)ghc->hva;
+			u32 evtchn_pending_sel32 =3D evtchn_pending_sel;
+
+			/* Attempt to set the evtchn_pending_sel bits in the
+			 * guest, and if that succeeds then clear the same
+			 * bits in the in-kernel version. */
+			asm volatile("1:\t" LOCK_PREFIX "orl %1, %0\n"
+				     "\tnotl %0\n"
+				     "\t" LOCK_PREFIX "andl %2, %0\n"
+				     "2:\n"
+				     "\t.section .fixup,\"ax\"\n"
+				     "3:\tjmp\t2b\n"
+				     "\t.previous\n"
+				     _ASM_EXTABLE_UA(1b, 3b)
+				     : "=3Dr" (evtchn_pending_sel32)
+				     : "m" (vi->evtchn_pending_sel),
+				       "m" (v->arch.xen.evtchn_pending_sel),
+				       "0" (evtchn_pending_sel32));
+		}
+		rc =3D 1;
+		__put_user(rc, (u8 __user *)ghc->hva + offset);
+	} else {
+		__get_user(rc, (u8 __user *)ghc->hva + offset);
+	}
 	return rc;
 }
=20
@@ -772,3 +836,105 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
=20
 	return 0;
 }
+
+static inline int max_evtchn_port(struct kvm *kvm)
+{
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
+		return 4096;
+	else
+		return 1024;
+}
+
+int kvm_xen_set_evtchn(struct kvm_kernel_irq_routing_entry *e,
+		       struct kvm *kvm, bool in_atomic)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_host_map map;
+	unsigned long *pending_bits, *mask_bits;
+	int port_word_bit;
+	int rc;
+
+	vcpu =3D kvm_get_vcpu_by_id(kvm, e->xen_evtchn.vcpu);
+	if (!vcpu)
+		return -EINVAL;
+
+	if (vcpu->arch.xen.vcpu_info_set)
+		return -EINVAL;
+
+	if (e->xen_evtchn.port >=3D max_evtchn_port(kvm))
+		return -EINVAL;
+
+	/* With no cache this is *always* going to fail in the atomic case for no=
w */
+	rc =3D kvm_map_gfn(vcpu, kvm->arch.xen.shinfo_gfn, &map, NULL, in_atomic)=
;
+	if (rc < 0)
+		return in_atomic ? -EWOULDBLOCK : rc;
+
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
+		struct shared_info *shinfo =3D map.hva;
+		pending_bits =3D (unsigned long *)&shinfo->evtchn_pending;
+		mask_bits =3D (unsigned long *)&shinfo->evtchn_mask;
+		port_word_bit =3D e->xen_evtchn.port / 64;
+	} else {
+		struct compat_shared_info *shinfo =3D map.hva;
+		pending_bits =3D (unsigned long *)&shinfo->evtchn_pending;
+		mask_bits =3D (unsigned long *)&shinfo->evtchn_mask;
+		port_word_bit =3D e->xen_evtchn.port / 32;
+	}
+
+	/*
+	 * If this port wasn't already set, and if it isn't masked, then
+	 * we try to set the corresponding bit in the in-kernel shadow of
+	 * evtchn_pending_sel for the target vCPU. And if *that* wasn't
+	 * already set, then we kick the vCPU in question to write to the
+	 * *real* evtchn_pending_sel in its own guest vcpu_info struct.
+	 */
+	if (!test_and_set_bit(e->xen_evtchn.port, pending_bits) &&
+	    !test_bit(e->xen_evtchn.port, mask_bits) &&
+	    !test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))=
 {
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_vcpu_kick(vcpu);
+	}
+
+	kvm_unmap_gfn(vcpu, &map, NULL, true, in_atomic);
+	return rc;
+}
+
+int kvm_xen_setup_evtchn(struct kvm *kvm,
+			 struct kvm_kernel_irq_routing_entry *e,
+			 const struct kvm_irq_routing_entry *ue)
+
+{
+	struct kvm_vcpu *vcpu;
+
+	if (kvm->arch.xen.shinfo_gfn =3D=3D GPA_INVALID)
+		return -EINVAL;
+
+	if (e->xen_evtchn.vcpu >=3D KVM_MAX_VCPUS)
+		return -EINVAL;
+
+	vcpu =3D kvm_get_vcpu_by_id(kvm, ue->u.xen_evtchn.vcpu);
+	if (!vcpu)
+		return -EINVAL;
+
+	if (vcpu->arch.xen.vcpu_info_set)
+		return -EINVAL;
+
+	if (!kvm->arch.xen.upcall_vector)
+		return -EINVAL;
+
+	/* Once we support the per-vCPU LAPIC based vector we will permit
+	 * that here instead of the per-KVM upcall vector */
+
+	if (e->xen_evtchn.port >=3D max_evtchn_port(kvm))
+		return -EINVAL;
+
+	/* We only support 2 level event channels for now */
+	if (e->xen_evtchn.priority !=3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
+		return -EINVAL;
+
+	e->xen_evtchn.port =3D ue->u.xen_evtchn.port;
+	e->xen_evtchn.vcpu =3D ue->u.xen_evtchn.vcpu;
+	e->xen_evtchn.priority =3D ue->u.xen_evtchn.priority;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index cc0cf5f37450..3e717947b928 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -24,6 +24,12 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_h=
vm_config *xhc);
 void kvm_xen_init_vm(struct kvm *kvm);
 void kvm_xen_destroy_vm(struct kvm *kvm);
=20
+int kvm_xen_set_evtchn(struct kvm_kernel_irq_routing_entry *e,
+		       struct kvm *kvm, bool in_atomic);
+int kvm_xen_setup_evtchn(struct kvm *kvm,
+			 struct kvm_kernel_irq_routing_entry *e,
+			 const struct kvm_irq_routing_entry *ue);
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f18df7fe874..9003fae1af9d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -470,6 +470,12 @@ struct kvm_hv_sint {
 	u32 sint;
 };
=20
+struct kvm_xen_evtchn {
+	u32 port;
+	u32 vcpu;
+	u32 priority;
+};
+
 struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
 	u32 type;
@@ -490,6 +496,7 @@ struct kvm_kernel_irq_routing_entry {
 		} msi;
 		struct kvm_s390_adapter_int adapter;
 		struct kvm_hv_sint hv_sint;
+		struct kvm_xen_evtchn xen_evtchn;
 	};
 	struct hlist_node link;
 };
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..05391c80bb6a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1143,11 +1143,20 @@ struct kvm_irq_routing_hv_sint {
 	__u32 sint;
 };
=20
+struct kvm_irq_routing_xen_evtchn {
+	__u32 port;
+	__u32 vcpu;
+	__u32 priority;
+};
+
+#define KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL ((__u32)(-1))
+
 /* gsi routing entry types */
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 #define KVM_IRQ_ROUTING_HV_SINT 4
+#define KVM_IRQ_ROUTING_XEN_EVTCHN 5
=20
 struct kvm_irq_routing_entry {
 	__u32 gsi;
@@ -1159,6 +1168,7 @@ struct kvm_irq_routing_entry {
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
 		struct kvm_irq_routing_hv_sint hv_sint;
+		struct kvm_irq_routing_xen_evtchn xen_evtchn;
 		__u32 pad[8];
 	} u;
 };
--=20
2.31.1


--=-TzpBNLCAQ4hz8vbeds5h
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
MDI4MjIyMjIxWjAvBgkqhkiG9w0BCQQxIgQgvkPgPtnhm4W4KA+o9QToIWM4P0FpPJrbJ3HqOWnd
G2Ywgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBADRerofw+lXzjYsE0CCA3uHtGrD2iIAHFW3jcC0lxcoYoqpVLdYqwsxpNz0VuNmA
Hlu2Pje5jEa0u85sxWvp/Skfm68BHndGp8hV9o6xKwgCNqws1jUzPxp1OSWLsblqxwYOwhL9to8+
X54Vn8IXESAAIFOojjHWHSbxjgYCFu3A9QPls1b+8OkBAbVbwr+YdzQVq4dw1jy21woozK7NP3Bw
TxEM4j4zO5n6IXHnYvhiv55O73PR7xuJhrU5zhgqYO1UuVAFBPnOuODIPeqadeluUaozc+dk6d5R
PSVveeorfl/k3fEsB2BzMgl51MY1h05N2wDgyOfsLQhEWAyCsO0AAAAAAAA=


--=-TzpBNLCAQ4hz8vbeds5h--

