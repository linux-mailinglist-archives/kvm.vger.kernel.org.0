Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CFC3F8D50
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 19:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243082AbhHZRvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 13:51:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230306AbhHZRvb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 13:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630000243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PvXsdXQQUMrVaAVuvdnDTnPGYLw11LK+qxHRVFWcVTM=;
        b=XUtnGwckm2M2aTi4u3CuDYYCXCi2QYCG0CeB66B5tfiMKtDS69UrytRO0rFK/GsRbZikNM
        bSDYtHzbCM7ZJqeDStfUOFqv+KBlmpHljtzmF9rh50OfyZsuDWz/L2+OVHtvT7upUlp9y5
        p8ULoG/Gbi/YpRCIlflwdL9FOgxE/aw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-QdMGh5PlPZ2sM6eQY6OdGA-1; Thu, 26 Aug 2021 13:50:42 -0400
X-MC-Unique: QdMGh5PlPZ2sM6eQY6OdGA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC037800493;
        Thu, 26 Aug 2021 17:50:39 +0000 (UTC)
Received: from localhost (unknown [10.22.10.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 496746788F;
        Thu, 26 Aug 2021 17:50:32 +0000 (UTC)
Date:   Thu, 26 Aug 2021 10:52:10 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
Message-ID: <20210826145210.gpfbiagntwoswrzp@habkost.net>
References: <20210823185841.ov7ejn2thwebcwqk@habkost.net>
 <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com>
 <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
 <87h7fej5ov.fsf@vitty.brq.redhat.com>
 <36b6656637d1e6aaa2ab5098f7ebc27644466294.camel@redhat.com>
 <87bl5lkgfm.fsf@vitty.brq.redhat.com>
 <CAOpTY_q=0cuxXAToJrcqCRERY_sUSB1HNVBVNiEpH6Dsy0-+yA@mail.gmail.com>
 <87tujcidka.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87tujcidka.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 02:40:53PM +0200, Vitaly Kuznetsov wrote:
> Eduardo Habkost <ehabkost@redhat.com> writes:
> 
> > On Wed, Aug 25, 2021 at 5:43 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> Maxim Levitsky <mlevitsk@redhat.com> writes:
> >>
> >> > On Wed, 2021-08-25 at 10:21 +0200, Vitaly Kuznetsov wrote:
> >> >> Maxim Levitsky <mlevitsk@redhat.com> writes:
> >> >>
> >> >> > On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
> >> >> ...
> >> >> > Not a classical review but,
> >> >> > I did some digital archaeology with this one, trying to understand what is going on:
> >> >> >
> >> >> >
> >> >> > I think that 16 bit vcpu bitmap is due to the fact that IOAPIC spec states that
> >> >> > it can address up to 16 cpus in physical destination mode.
> >> >> >
> >> >> > In logical destination mode, assuming flat addressing and that logical id = 1 << physical id
> >> >> > which KVM hardcodes, it is also only possible to address 8 CPUs.
> >> >> >
> >> >> > However(!) in flat cluster mode, the logical apic id is split in two.
> >> >> > We have 16 clusters and each have 4 CPUs, so it is possible to address 64 CPUs,
> >> >> > and unlike the logical ID, the KVM does honour cluster ID,
> >> >> > thus one can stick say cluster ID 0 to any vCPU.
> >> >> >
> >> >> >
> >> >> > Let's look at ioapic_write_indirect.
> >> >> > It does:
> >> >> >
> >> >> >     -> bitmap_zero(&vcpu_bitmap, 16);
> >> >> >     -> kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq, &vcpu_bitmap);
> >> >> >     -> kvm_make_scan_ioapic_request_mask(ioapic->kvm, &vcpu_bitmap); // use of the above bitmap
> >> >> >
> >> >> >
> >> >> > When we call kvm_bitmap_or_dest_vcpus, we can already overflow the bitmap,
> >> >> > since we pass all 8 bit of the destination even when it is physical.
> >> >> >
> >> >> >
> >> >> > Lets examine the kvm_bitmap_or_dest_vcpus:
> >> >> >
> >> >> >   -> It calls the kvm_apic_map_get_dest_lapic which
> >> >> >
> >> >> >        -> for physical destinations, it just sets the bitmap, which can overflow
> >> >> >           if we pass it 8 bit destination (which basically includes reserved bits + 4 bit destination).
> >> >> >
> >> >> >
> >> >> >        -> For logical apic ID, it seems to truncate the result to 16 bit, which isn't correct as I explained
> >> >> >           above, but should not overflow the result.
> >> >> >
> >> >> >
> >> >> >    -> If call to kvm_apic_map_get_dest_lapic fails, it goes over all vcpus and tries to match the destination
> >> >> >        This can overflow as well.
> >> >> >
> >> >> >
> >> >> > I also don't like that ioapic_write_indirect calls the kvm_bitmap_or_dest_vcpus twice,
> >> >> > and second time with 'old_dest_id'
> >> >> >
> >> >> > I am not 100%  sure why old_dest_id/old_dest_mode are needed as I don't see anything in the
> >> >> > function changing them.
> >> >> > I think only the guest can change them, so maybe the code deals with the guest changing them
> >> >> > while the code is running from a different vcpu?
> >> >> >
> >> >> > The commit that introduced this code is 7ee30bc132c683d06a6d9e360e39e483e3990708
> >> >> > Nitesh Narayan Lal, maybe you remember something about it?
> >> >> >
> >> >>
> >> >> Before posting this patch I've contacted Nitesh privately, he's
> >> >> currently on vacation but will take a look when he gets back.
> >> >>
> >> >> > Also I worry a lot about other callers of kvm_apic_map_get_dest_lapic
> >> >> >
> >> >> > It is also called from kvm_irq_delivery_to_apic_fast, and from kvm_intr_is_single_vcpu_fast
> >> >> > and both seem to also use 'unsigned long' for bitmap, and then only use 16 bits of it.
> >> >> >
> >> >> > I haven't dug into them, but these don't seem to be IOAPIC related and I think
> >> >> > can overwrite the stack as well.
> >> >>
> >> >> I'm no expert in this code but when writing the patch I somehow
> >> >> convinced myself that a single unsigned long is always enough. I think
> >> >> that for cluster mode 'bitmap' needs 64-bits (and it is *not* a
> >> >> vcpu_bitmap, we need to convert). I may be completely wrong of course
> >> >> but in any case this is a different issue. In ioapic_write_indirect() we
> >> >> have 'vcpu_bitmap' which should certainly be longer than 64 bits.
> >> >
> >> >
> >> > This code which I mentioned in 'other callers' as far as I see is not IOAPIC related.
> >> > For regular local APIC all bets are off, any vCPU and apic ID are possible
> >> > (xapic I think limits apic id to 255 but x2apic doesn't).
> >> >
> >> > I strongly suspect that this code can overflow as well.
> >>
> >> I've probably missed something but I don't see how
> >> kvm_apic_map_get_dest_lapic() can set bits above 64 in 'bitmap'. If it
> >> can, then we have a problem indeed.
> >
> > It would be nice if the compiler took care of validating bitmap sizes
> > for us. Shouldn't we make the function prototypes explicit about the
> > bitmap sizes they expect?
> >
> > I believe some `typedef DECLARE_BITMAP(...)` or `typedef struct {
> > DECLARE_BITMAP(...) } ...` declarations would be very useful here.
> 
> The fundamental problem here is that bitmap in Linux has 'unsigned long
> *' type, it's supposed to be accompanied with 'int len' parameter but
> it's not always the case.
> 
> In KVM, we usually use 'vcpu_bitmap' (or 'dest_vcpu_bitmap') and these
> are 'KVM_MAX_VCPUS' long. Just 'bitmap' or 'mask' case is a bit more
> complicated. E.g. kvm_apic_map_get_logical_dest() uses 'u16 *mask' and
> this means that only 16 bits in the destination are supposed to be
> set. kvm_apic_map_get_dest_lapic() uses 'unsigned long *bitmap' - go
> figure.
> 
> We could've probably used a declaration like you suggest to e.g. create
> incompatible 'bitmap16','bitmap64',... types and make the compiler do
> the checking but I'm slightly hesitant to introduce such helpers to KVM
> and not the whole kernel. Alternatively, we could've just encoded the
> length in parameters name, e.g. 
> 
> @@ -918,7 +918,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
>  static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
>                 struct kvm_lapic **src, struct kvm_lapic_irq *irq,
>                 struct kvm_apic_map *map, struct kvm_lapic ***dst,
> -               unsigned long *bitmap)
> +               unsigned long *bitmap64)

You can communicate the expected bitmap size to the compiler
without typedefs if using DECLARE_BITMAP inside the function
parameter list is acceptable coding style (is it?).

For example, the following would have allowed the compiler to
catch the bug you are fixing:

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d7c25d0c1354..e8c64747121a 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -236,7 +236,7 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
 
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
-			      unsigned long *vcpu_bitmap);
+			      DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS));
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..1df113894cba 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1166,7 +1166,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
  * each available vcpu to identify the same.
  */
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
-			      unsigned long *vcpu_bitmap)
+			      DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS))
 {
 	struct kvm_lapic **dest_vcpu = NULL;
 	struct kvm_lapic *src = NULL;

-- 
Eduardo

