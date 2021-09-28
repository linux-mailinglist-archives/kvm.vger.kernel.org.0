Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6341B3AF
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 18:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241703AbhI1QW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 12:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241729AbhI1QW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 12:22:57 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078FEC06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:21:17 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k24so21732915pgh.8
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 09:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4W1FddI98pFlnr+A0lvtfqj/bE0RlEbF+OZi5QyXfNQ=;
        b=rRG5+ibV0VfTSTicp1bhIGdnPJs2eKiLq2XzebWggCrmgs3veBEvfmHcXBiVrkvlhr
         pasvKyJuVD/tCR/gXD4BcHA9nsxqDt4qCNpCzJiytnVVYjPlnxLaPBgP5mSWdyI9kW+J
         i4LEEcGYlnHMbwfaCAnCjMwTclB4O68YC5H5sFscTb65HQuzCWDCisyhMm5ffdKTn7Ay
         lNZC2KYMygu6dBZSzwm9+EdohM3Suyj+qhy/hk/Z14ubImxH8k78+tqDOqBOz7l+yJ6f
         Txn/VQ5RX8HjLrgWFg6NC/blpkElmvDMFM+9G7EoTZP0AkKUWZyACsImEB5K+QlbXbhB
         mH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4W1FddI98pFlnr+A0lvtfqj/bE0RlEbF+OZi5QyXfNQ=;
        b=UuVnMmSY5sUi3V1wMfFJNTQlgRIAke713BJIzO7YZMO0+CLdl4cjYSqXwAuxuaZUrM
         s5Fow6v1kHLy6TbFWjeFKEBdqiku6zfSLoqUILfnN8t7NIhNnjSRisj2orgUgd9LlpfQ
         GJW2pn2R7A6+zo2mwk+kUTabph3MuKc/zizorNXAXMuP5TnNnl5yeI9x78bZNWhRGYZn
         OrFq2uptfQIvk/gzJQOU0XBPXNKBLSaPewPu8Rek5ImqN11h9Zg9s3WwBJ/ej4QmTJ5d
         9x4TIA/n6PPmPTSOFGDJCc4TjoCL3ewSkQZoVUOAazdYCyEo+1gW1IdvYXX6VD2hbXIo
         +5Cw==
X-Gm-Message-State: AOAM530SnduBtL4leJhQaYM3X3qzLlS20V82L0JhxIfejo+2ORUkZEoL
        ISnZg3i5+ln13CbrXGUqxdrIaA==
X-Google-Smtp-Source: ABdhPJwvRKMgNcMAnByHEA4jwqcNi7NdpV8g3FIwIP1nCr7TIZIvl4OYYda797EjrwyZo4NDgJC3GA==
X-Received: by 2002:a63:2d02:: with SMTP id t2mr5392663pgt.1.1632846076184;
        Tue, 28 Sep 2021 09:21:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p9sm3038231pfo.153.2021.09.28.09.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 09:21:15 -0700 (PDT)
Date:   Tue, 28 Sep 2021 16:21:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 07/14] KVM: Don't block+unblock when halt-polling is
 successful
Message-ID: <YVNA+KTbLrxGQ6ML@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-8-seanjc@google.com>
 <878rzlass2.wl-maz@kernel.org>
 <80d90ee6-0d43-3735-5c26-be8c3d72d493@redhat.com>
 <877df3btgb.wl-maz@kernel.org>
 <YVH/LjCqk/9PfDHn@google.com>
 <87o88dt5m5.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o88dt5m5.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021, Marc Zyngier wrote:
> On Mon, 27 Sep 2021 18:28:14 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Sun, Sep 26, 2021, Marc Zyngier wrote:
> > > On Sun, 26 Sep 2021 07:27:28 +0100,
> > > Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > > 
> > > > On 25/09/21 11:50, Marc Zyngier wrote:
> > > > >> there is no need for arm64 to put/load
> > > > >> the vGIC as KVM hasn't relinquished control of the vCPU in any way.
> > > > > 
> > > > > This doesn't mean that there is no requirement for any state
> > > > > change. The put/load on GICv4 is crucial for performance, and the VMCR
> > > > > resync is a correctness requirement.
> > 
> > Ah crud, I didn't blame that code beforehand, I simply assumed
> > kvm_arch_vcpu_blocking() was purely for the blocking/schedule()
> > sequence.  The comment in arm64's kvm_arch_vcpu_blocking() about
> > kvm_arch_vcpu_runnable() makes more sense now too.
> > 
> > > > I wouldn't even say it's crucial for performance: halt polling cannot
> > > > work and is a waste of time without (the current implementation of)
> > > > put/load.
> > > 
> > > Not quite. A non-V{LPI,SGI} could still be used as the a wake-up from
> > > WFI (which is the only reason we end-up on this path). Only LPIs (and
> > > SGIs on GICv4.1) can be directly injected, meaning that SPIs and PPIs
> > > still follow the standard SW injection model.
> > > 
> > > However, there is still the ICH_VMCR_EL2 requirement (to get the
> > > up-to-date priority mask and group enable bits) for SW-injected
> > > interrupt wake-up to work correctly, and I really don't want to save
> > > that one eagerly on each shallow exit.
> > 
> > IIUC, VMCR is resident in hardware while the guest is running, and
> > KVM needs to retrieve the VMCR when processing interrupts to
> > determine if a interrupt is above the priority threshold.  If that's
> > the case, then IMO handling the VMCR via an arch hook is
> > unnecessarily fragile, e.g. any generic call that leads to
> > kvm_arch_vcpu_runnable() needs to know that arm64 lazily retrieves a
> > guest register.
> 
> Not quite. We only need to retrieve the VMCR if we are in a situation
> where we need to trigger a wake-up from WFI at the point where we have
> not done a vcpu_put() yet. All the other cases where the interrupt is
> injected are managed by the HW. And the only case where
> kvm_arch_vcpu_runnable() gets called is when blocking.
> 
> I also don't get why a hook would be fragile, as long as it has well
> defined semantics.

Generic KVM should not have to know that a seemingly benign arch hook,
kvm_arch_vcpu_runnable(), cannot be safely called without first calling another
arch hook.  E.g. I suspect there's a (benign?) race in kvm_vcpu_on_spin().  If
the loop is delayed between checking rcuwait_active() and vcpu_dy_runnable(),
and the target vCPU is awakened during that period, KVM can call
kvm_arch_vcpu_runnable() while the vCPU is running.

It's kind of a counter-example to my below suggestion as putting the vGIC would
indeed lead to state corruption if the vCPU is running, but I would argue that
arm64 should override kvm_arch_dy_runnable() so that its correctness is guaranteed,
e.g. by not calling kvm_arch_vcpu_runnable() if the vCPU is already running.

> > A better approach for VMCR would be to retrieve the value from
> > hardware on-demand, e.g. via a hook in vgic_get_vmcr(), so that it's all but
> > impossible to have bugs where KVM is working with a stale VMCR, e.g.
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> > index 48c6067fc5ec..0784de0c4080 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> > @@ -828,6 +828,13 @@ void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> >  
> >  void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> >  {
> > +       if (!vcpu->...->vmcr_available) {
> > +               preempt_disable();
> > +               kvm_vgic_vmcr_sync(vcpu);
> > +               preempt_enable();
> > +               vcpu->...->vmcr_available = true;
> > +       }
> > +
> 
> But most of the uses of vgic_get_vmcr() are in contexts where the vcpu
> isn't running at all (such as save/restore). It really only operates
> on the shadow state, and what you have above will only lead to state
> corruption.

Ignoring the kvm_arch_dy_runnable() case for the moment, how would it lead to
corruption?  The idea is that the 'vmcr_available' flag would be cleared when the
vCPU is run, i.e. it tracks whether or not the shadow state may be stale.

> >         if (kvm_vgic_global_state.type == VGIC_V2)
> >                 vgic_v2_get_vmcr(vcpu, vmcr);
> >         else
> > 
> > 
> > Regarding vGIC v4, does KVM require it to be resident in hardware
> > while the vCPU is loaded?
> 
> It is a requirement. Otherwise, we end-up with an inconsistent state
> between the delivery of doorbells and the state of the vgic.

For my own understanding, does KVM require it to be resident in hardware while
the vCPU is loaded but _not_ running?  What I don't fully understand is how KVM
can safely load/put the vCPU if that true, i.e. wouldn't there always be a window
for badness?

> Also, reloading the GICv4 state can be pretty expensive (multiple MMIO
> accesses), which is why we really don't want to do that on the hot path
> (kvm_arch_vcpu_ioctl_run() *is* a hot path).

I wasn't suggesting to reload GICv4 on every entry, it would only be reloaded
if it was put between vcpu_load() and entry to the guest.

> > If not, then we could do something like
> > this, which would eliminate the arch hooks entirely if the VMCR is
> > handled as above.

...

> > @@ -813,6 +787,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                  */
> >                 preempt_disable();
> > 
> > +               /*
> > +                * Reload vGIC v4 if necessary, as it may be put on-demand so
> > +                * that KVM can detect directly injected interrupts, e.g. when
> > +                * determining if the vCPU is runnable due to a pending event.
> > +                */
> > +               vgic_v4_load(vcpu);
> 
> You'd need to detect that a previous put has been done.

Not that it will likely matter, but doesn't the its_vpe.resident check automatically
handle this?

> But overall, it puts the complexity at the wrong place. WFI (aka
> kvm_vcpu_block) is the place where we want to handle this synchronisation,
> and not the run loop.
> 
> Instead of having a well defined interface with the blocking code
> where we implement the required synchronisation, you spray the vgic
> crap all over, and it becomes much harder to reason about it. Guess
> what, I'm not keen on it.

My objection to the arch hooks is that, from generic KVM's perspective, the
direct dependency is not on blocking, it's on calling kvm_arch_vcpu_runnable().
That's why I suggested handling this by tracking whether or not the VMCR is
up-to-date/stale, as it allows generic KVM to safely call kvm_arch_vcpu_runnable()
whenever the vCPU is loaded.

I don't have a strong opinion on arm64 preferring the sync to be specific to
WFI, but if that's the case then IMO this should be handled fully in arm64, e.g.
a patch like so (or with a wrapper around the call to kvm_vcpu_block() if we
want to guard against future calls into generic KVM)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..312f3acd3ca3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -367,27 +367,12 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)

 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
-       /*
-        * If we're about to block (most likely because we've just hit a
-        * WFI), we need to sync back the state of the GIC CPU interface
-        * so that we have the latest PMR and group enables. This ensures
-        * that kvm_arch_vcpu_runnable has up-to-date data to decide
-        * whether we have pending interrupts.
-        *
-        * For the same reason, we want to tell GICv4 that we need
-        * doorbells to be signalled, should an interrupt become pending.
-        */
-       preempt_disable();
-       kvm_vgic_vmcr_sync(vcpu);
-       vgic_v4_put(vcpu, true);
-       preempt_enable();
+
 }

 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-       preempt_disable();
-       vgic_v4_load(vcpu);
-       preempt_enable();
+
 }

 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..9870e824a27e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -95,8 +95,28 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
        } else {
                trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
                vcpu->stat.wfi_exit_stat++;
+
+               /*
+                * Sync back the state of the GIC CPU interface so that we have
+                * the latest PMR and group enables. This ensures that
+                * kvm_arch_vcpu_runnable has up-to-date data to decide whether
+                * we have pending interrupts, e.g. when determining if the
+                * vCPU should block.
+                *
+                * For the same reason, we want to tell GICv4 that we need
+                * doorbells to be signalled, should an interrupt become pending.
+                */
+               preempt_disable();
+               kvm_vgic_vmcr_sync(vcpu);
+               vgic_v4_put(vcpu, true);
+               preempt_enable();
+
                kvm_vcpu_block(vcpu);
                kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+
+               preempt_disable();
+               vgic_v4_load(vcpu);
+               preempt_enable();
        }

        kvm_incr_pc(vcpu);





