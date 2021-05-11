Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0690D37A6E7
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 14:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhEKMjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 08:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230475AbhEKMjn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 08:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=roneRRGESREmK30tskJzHlO9bn1BNbeDsRNGwZoyjB0=;
        b=IkKFx8rkE+GDJukKqWAQSWq6rpVHIbGM4ycIGAeL9UQOFKsnVCbkCAHyGNXl8plmgqnMTa
        jnq9bU42zKBBu7EdGoP+YoAj1h80XQDcWrKJSIIPRFZ6iWoqEAjgLdIgkvBtfifFQS9BGq
        wOtbK5aHqru2Jlo1WAo6HpSnV/m9GmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-X1hB2uzsMdmlRemMQWtb2w-1; Tue, 11 May 2021 08:38:34 -0400
X-MC-Unique: X1hB2uzsMdmlRemMQWtb2w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9914E1006C83;
        Tue, 11 May 2021 12:38:32 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB76010016FC;
        Tue, 11 May 2021 12:38:28 +0000 (UTC)
Message-ID: <39c6336c4f9046ecd21e5810a4fd4d75aa2c97ad.camel@redhat.com>
Subject: Re: [PATCH 4/8] KVM: VMX: Adjust the TSC-related VMCS fields on L2
 entry and exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Stamatis, Ilias" <ilstam@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ilstam@mailbox.org" <ilstam@mailbox.org>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "haozhong.zhang@intel.com" <haozhong.zhang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "dplotnikov@virtuozzo.com" <dplotnikov@virtuozzo.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Date:   Tue, 11 May 2021 15:38:27 +0300
In-Reply-To: <3a636a78f08d7ba725a77ff659c7df7e5bb5dfc7.camel@amazon.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-5-ilstam@mailbox.org>
         <4bb959a084e7acc4043f683888b9660f1a4a3fd7.camel@redhat.com>
         <3a636a78f08d7ba725a77ff659c7df7e5bb5dfc7.camel@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-10 at 14:44 +0000, Stamatis, Ilias wrote:
> On Mon, 2021-05-10 at 16:53 +0300, Maxim Levitsky wrote:
> > On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> > > From: Ilias Stamatis <ilstam@amazon.com>
> > > 
> > > When L2 is entered we need to "merge" the TSC multiplier and TSC
> > > offset
> > > values of VMCS01 and VMCS12 and store the result into the current
> > > VMCS02.
> > > 
> > > The 02 values are calculated using the following equations:
> > >   offset_02 = ((offset_01 * mult_12) >> 48) + offset_12
> > >   mult_02 = (mult_01 * mult_12) >> 48
> > 
> > I would mention that 48 is kvm_tsc_scaling_ratio_frac_bits instead.
> > Also maybe add the common code in a separate patch?
> 
> Right, will do.
> 
> > > Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |  1 +
> > >  arch/x86/kvm/vmx/nested.c       | 26 ++++++++++++++++++++++----
> > >  arch/x86/kvm/x86.c              | 25 +++++++++++++++++++++++++
> > >  3 files changed, 48 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h
> > > b/arch/x86/include/asm/kvm_host.h
> > > index cdddbf0b1177..e7a1eb36f95a 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1780,6 +1780,7 @@ void kvm_define_user_return_msr(unsigned
> > > index, u32 msr);
> > >  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
> > > 
> > >  u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, bool l1);
> > > +u64 kvm_compute_02_tsc_offset(u64 l1_offset, u64 l2_multiplier, u64
> > > l2_offset);
> > >  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
> > > 
> > >  unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index bced76637823..a1bf28f33837 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3353,8 +3353,22 @@ enum nvmx_vmentry_status
> > > nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > >       }
> > > 
> > >       enter_guest_mode(vcpu);
> > > -     if (vmcs12->cpu_based_vm_exec_control &
> > > CPU_BASED_USE_TSC_OFFSETTING)
> > > -             vcpu->arch.tsc_offset += vmcs12->tsc_offset;
> > > +
> > > +     if (vmcs12->cpu_based_vm_exec_control &
> > > CPU_BASED_USE_TSC_OFFSETTING) {
> > > +             if (vmcs12->secondary_vm_exec_control &
> > > SECONDARY_EXEC_TSC_SCALING) {
> > > +                     vcpu->arch.tsc_offset =
> > > kvm_compute_02_tsc_offset(
> > > +                                     vcpu->arch.l1_tsc_offset,
> > > +                                     vmcs12->tsc_multiplier,
> > > +                                     vmcs12->tsc_offset);
> > > +
> > > +                     vcpu->arch.tsc_scaling_ratio =
> > > mul_u64_u64_shr(
> > > +                                     vcpu->arch.tsc_scaling_ratio,
> > > +                                     vmcs12->tsc_multiplier,
> > > +                                     kvm_tsc_scaling_ratio_frac_bit
> > > s);
> > > +             } else {
> > > +                     vcpu->arch.tsc_offset += vmcs12->tsc_offset;
> > > +             }
> > > +     }
> > > 
> > >       if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
> > >               exit_reason.basic = EXIT_REASON_INVALID_STATE;
> > > @@ -4454,8 +4468,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu,
> > > u32 vm_exit_reason,
> > >       if (nested_cpu_has_preemption_timer(vmcs12))
> > >               hrtimer_cancel(&to_vmx(vcpu)-
> > > > nested.preemption_timer);
> > > 
> > > -     if (vmcs12->cpu_based_vm_exec_control &
> > > CPU_BASED_USE_TSC_OFFSETTING)
> > > -             vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
> > > +     if (vmcs12->cpu_based_vm_exec_control &
> > > CPU_BASED_USE_TSC_OFFSETTING) {
> > > +             vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
> > > +
> > > +             if (vmcs12->secondary_vm_exec_control &
> > > SECONDARY_EXEC_TSC_SCALING)
> > > +                     vcpu->arch.tsc_scaling_ratio = vcpu-
> > > > arch.l1_tsc_scaling_ratio;
> > > +     }
> > > 
> > >       if (likely(!vmx->fail)) {
> > >               sync_vmcs02_to_vmcs12(vcpu, vmcs12);
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 26a4c0f46f15..87deb119c521 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2266,6 +2266,31 @@ static u64 kvm_compute_tsc_offset(struct
> > > kvm_vcpu *vcpu, u64 target_tsc)
> > >       return target_tsc - tsc;
> > >  }
> > > 
> > > +/*
> > > + * This function computes the TSC offset that is stored in VMCS02
> > > when entering
> > > + * L2 by combining the offset and multiplier values of VMCS01 and
> > > VMCS12.
> > > + */
> > > +u64 kvm_compute_02_tsc_offset(u64 l1_offset, u64 l2_multiplier, u64
> > > l2_offset)
> > > +{
> > > +     u64 offset;
> > > +
> > > +     /*
> > > +      * The L1 offset is interpreted as a signed number by the CPU
> > > and can
> > > +      * be negative. So we extract the sign before the
> > > multiplication and
> > > +      * put it back afterwards if needed.
> > 
> > If I understand correctly the reason for sign extraction is that we
> > don't
> > have mul_s64_u64_shr. Maybe we should add it?
> > 
> 
> Initially I added a mul_s64_s64_shr and used that.
> 
> You can take a look
> here:
> 
> https://github.com/ilstam/linux/commit/7bc0b75bb7b8d9bcecf41e2e1e1936880d3b93d1
> 
> 
> I added mul_s64_s64_shr instead of mul_s64_u64_shr thinking that a)
> perhaps it would be more useful as a general-purpose function and b)
> even though the multiplier is unsigned in reality it's caped so it
> should be safe to cast it to signed.

Actually is it? Intel's PRM I think defines TSC multiplier to be full 
64 bit. It is shifted right after multiplication, making the multiplier
be effictively a fixed point 16.48 number but since multiplication is done
first, it will still have to use full 64 bit value.
> 
> But then I realized that
> mul_u64_u64_shr that we already have is enough and I can just simply re-
> use that.
> 
> How would a mul_s64_u64_shr be implemented?

I'll say even if it is implemented by just extracting the sign as you did
and then calling mul_u64_u64_shr, 
it could still be a bit better documentation wise.


> 
> I think in the end
> we need to decide if we want to do signed or unsigned multiplication.
> And depending on this we need to do a signed or unsigned right shift
> accordingly.
I agree.
> 
> So if we did have a mul_s64_u64_shr wouldn't it need to cast
> either of the arguments and then use mul_u64_u64 (or mul_s64_s64) being
> just a wrapper essentially? I don't think that we can guarantee that
> casting either of the arguments is always safe if we want to advertise
> this as a general purpose function.

Note that I don't have a strong opinion on this whole thing, so if you feel
that it should be left as is, I don't mind.

> 
> Thanks for the reviews!

No problem!

Best regards,
	Maxim Levitsky

> 
> Ilias
> 
> > The pattern of (A * B) >> shift appears many times in TSC scaling.
> > 
> > So instead of this function maybe just use something like that?
> > 
> > merged_offset = l2_offset + mul_s64_u64_shr ((s64) l1_offset,
> >                                              l2_multiplier,
> >                                              kvm_tsc_scaling_ratio_fra
> > c_bits)
> > 
> > Or another idea:
> > 
> > How about
> > 
> > u64 __kvm_scale_tsc_value(u64 value, u64 multiplier) {
> >         return mul_u64_u64_shr(value,
> >                                multiplier,
> >                                kvm_tsc_scaling_ratio_frac_bits);
> > }
> > 
> > 
> > and
> > 
> > s64 __kvm_scale_tsc_offset(u64 value, u64 multiplier)
> > {
> >         return mul_s64_u64_shr((s64)value,
> >                                multiplier,
> >                                kvm_tsc_scaling_ratio_frac_bits);
> > }
> > 
> > And then use them in the code.
> > 
> > Overall though the code *looks* correct to me
> > but I might have missed something.
> > 
> > Best regards,
> >         Maxim Levitsky
> > 
> > 
> > > +      */
> > > +     offset = mul_u64_u64_shr(abs((s64) l1_offset),
> > > +                              l2_multiplier,
> > > +                              kvm_tsc_scaling_ratio_frac_bits);
> > > +
> > > +     if ((s64) l1_offset < 0)
> > > +             offset = -((s64) offset);
> > > +
> > > +     offset += l2_offset;
> > > +     return offset;
> > > +}
> > > +EXPORT_SYMBOL_GPL(kvm_compute_02_tsc_offset);
> > > +
> > >  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
> > >  {
> > >       return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu,
> > > host_tsc, true);





