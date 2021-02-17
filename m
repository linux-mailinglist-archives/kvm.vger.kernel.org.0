Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1A431D7A6
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 11:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBQKon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 05:44:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhBQKom (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 05:44:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613558594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bqh+z3S1LOPkMx7mrF138oI0jbxi9ICWVeOhMqs/ZPE=;
        b=PVbxgriKfjlKKWcihuocZtX2XwochFAfTEikeDZjNx/ohKLwOF+jHzzKOJ0GgyTKLhRPTE
        HjsBndmM5ZLNdWBbpm/WhIk+Mqnf+xhgKQ0iJcE/shqCcGGpsGTKDkE7HE2HIoW27UMT7Y
        JkZ95wUt27m9ZbkZG+gvlX5N+ds3xps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-QsNCNAdPP2O0GjlB2QrvUQ-1; Wed, 17 Feb 2021 05:43:11 -0500
X-MC-Unique: QsNCNAdPP2O0GjlB2QrvUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C7161020C4A;
        Wed, 17 Feb 2021 10:43:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65B2A5D9C0;
        Wed, 17 Feb 2021 10:43:07 +0000 (UTC)
Date:   Wed, 17 Feb 2021 11:43:04 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kernel-team@android.com, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Handle CMOs on Read Only memslots
Message-ID: <20210217104304.ri2zs4pvbulqe3hu@kamzik.brq.redhat.com>
References: <20210211142738.1478292-1-maz@kernel.org>
 <63fbfcec-b31f-7248-0382-0cad4165424c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63fbfcec-b31f-7248-0382-0cad4165424c@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 12:18:31PM +0000, Alexandru Elisei wrote:
> Hi Marc,
> 
> Played with this for a bit to try to understand the problem better, wrote a simple
> MMIO device in kvmtool which maps the memory as a read-only memslot [1] and poked
> it with kvm-unit-tests [2].
> 
> [1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/mmiodev-wip1
> 
> [2] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/mmiodev-wip1

Looks like you forgot to add arm/mmiodev.c to your commit.

Thanks,
drew

> 
> On 2/11/21 2:27 PM, Marc Zyngier wrote:
> > It appears that when a guest traps into KVM because it is
> > performing a CMO on a Read Only memslot, our handling of
> > this operation is "slightly suboptimal", as we treat it as
> > an MMIO access without a valid syndrome.
> >
> > The chances that userspace is adequately equiped to deal
> > with such an exception being slim, it would be better to
> > handle it in the kernel.
> >
> > What we need to provide is roughly as follows:
> >
> > (a) if a CMO hits writeable memory, handle it as a normal memory acess
> > (b) if a CMO hits non-memory, skip it
> > (c) if a CMO hits R/O memory, that's where things become fun:
> >   (1) if the CMO is DC IVAC, the architecture says this should result
> >       in a permission fault
> >   (2) if the CMO is DC CIVAC, it should work similarly to (a)
> >
> > We already perform (a) and (b) correctly, but (c) is a total mess.
> > Hence we need to distinguish between IVAC (c.1) and CIVAC (c.2).
> >
> > One way to do it is to treat CMOs generating a translation fault as
> > a *read*, even when they are on a RW memslot. This allows us to
> > further triage things:
> >
> > If they come back with a permission fault, that is because this is
> > a DC IVAC instruction:
> > - inside a RW memslot: no problem, treat it as a write (a)(c.2)
> > - inside a RO memslot: inject a data abort in the guest (c.1)
> >
> > The only drawback is that DC IVAC on a yet unmapped page faults
> > twice: one for the initial translation fault that result in a RO
> > mapping, and once for the permission fault. I think we can live with
> > that.
> >
> > Reported-by: Jianyong Wu <jianyong.wu@arm.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >
> > Notes:
> >     I have taken the option to inject an abort in the guest when
> >     it issues a DC IVAC on a R/O memslot, but another option would
> >     be to just perform the invalidation ourselves as a DC CIAVAC.
> >     
> >     This would have the advantage of being consistent with what we
> >     do for emulated MMIO.
> >
> >  arch/arm64/kvm/mmu.c | 53 ++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 41 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 7d2257cc5438..c7f4388bea45 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -760,7 +760,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	struct kvm_pgtable *pgt;
> >  
> >  	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
> > -	write_fault = kvm_is_write_fault(vcpu);
> > +	/*
> > +	 * Treat translation faults on CMOs as read faults. Should
> > +	 * this further generate a permission fault on a R/O memslot,
> > +	 * it will be caught in kvm_handle_guest_abort(), with
> > +	 * prejudice. Permission faults on non-R/O memslot will be
> > +	 * gracefully handled as writes.
> > +	 */
> > +	if (fault_status == FSC_FAULT && kvm_vcpu_dabt_is_cm(vcpu))
> > +		write_fault = false;
> 
> This means that every DC CIVAC will map the IPA with read permissions in the stage
> 2 tables, regardless of the IPA being already mapped. It's harmless, but a bit
> unexpected.
> 
> > +	else
> > +		write_fault = kvm_is_write_fault(vcpu);
> >  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> >  	VM_BUG_ON(write_fault && exec_fault);
> >  
> > @@ -1013,19 +1023,37 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >  		}
> >  
> >  		/*
> > -		 * Check for a cache maintenance operation. Since we
> > -		 * ended-up here, we know it is outside of any memory
> > -		 * slot. But we can't find out if that is for a device,
> > -		 * or if the guest is just being stupid. The only thing
> > -		 * we know for sure is that this range cannot be cached.
> > +		 * Check for a cache maintenance operation. Three cases:
> > +		 *
> > +		 * - It is outside of any memory slot. But we can't find out
> > +		 *   if that is for a device, or if the guest is just being
> > +		 *   stupid. The only thing we know for sure is that this
> > +		 *   range cannot be cached.  So let's assume that the guest
> > +		 *   is just being cautious, and skip the instruction.
> > +		 *
> > +		 * - Otherwise, check whether this is a permission fault.
> > +		 *   If so, that's a DC IVAC on a R/O memslot, which is a
> > +		 *   pretty bad idea, and we tell the guest so.
> >  		 *
> > -		 * So let's assume that the guest is just being
> > -		 * cautious, and skip the instruction.
> > +		 * - If this wasn't a permission fault, pass it along for
> > +		 *   further handling (including faulting the page in if it
> > +		 *   was a translation fault).
> >  		 */
> > -		if (kvm_is_error_hva(hva) && kvm_vcpu_dabt_is_cm(vcpu)) {
> > -			kvm_incr_pc(vcpu);
> > -			ret = 1;
> > -			goto out_unlock;
> > +		if (kvm_vcpu_dabt_is_cm(vcpu)) {
> > +			if (kvm_is_error_hva(hva)) {
> > +				kvm_incr_pc(vcpu);
> > +				ret = 1;
> > +				goto out_unlock;
> > +			}
> > +
> > +			if (fault_status == FSC_PERM) {
> > +				/* DC IVAC on a R/O memslot */
> > +				kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> > +				ret = 1;
> > +				goto out_unlock;
> > +			}
> 
> I don't like the inconsistency. We go from exiting to userspace for both DC
> IVAC/DC CIVAC to mapping the IPA with read permissions for DC CIVAC, but injecting
> a DABT for a DC IVAC. DC IVAC acts just like a DC CIVAC and requires the same
> permissions when executed by a guest, so I'm not sure we should be handling them
> differently.
> 
> Thanks,
> 
> Alex
> 
> > +
> > +			goto handle_access;
> >  		}
> >  
> >  		/*
> > @@ -1039,6 +1067,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >  		goto out_unlock;
> >  	}
> >  
> > +handle_access:
> >  	/* Userspace should not be able to register out-of-bounds IPAs */
> >  	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
> >  
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

