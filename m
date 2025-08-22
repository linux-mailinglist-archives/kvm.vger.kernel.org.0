Return-Path: <kvm+bounces-55495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5346B314C6
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 12:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4082F7A3667
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 10:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11F42D7DC2;
	Fri, 22 Aug 2025 10:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPC/aLcR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61442D3A97;
	Fri, 22 Aug 2025 10:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755857330; cv=none; b=HqynsWIgsXHELjjUtPLOZnwXMc3dAfpxgoJGdMkmFQdqj/nXXCMgbd4PnwROnag2pUKTrQ6VEXnvp1NDqPNz22Y+HNZzH+L5BXfhOoCfmKqIkkrCzui4mblbJ5lWZqFMIJ5o8sQPdFFVVCjAEO72HoGVTrj+VDjAshAd0YmWWu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755857330; c=relaxed/simple;
	bh=7pbp7b4MJQuhnZtl/iQt6X0PGAG53lDNYxERnubuCEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KaUbAiHuSPwNTwP9+pM3O5U8kb1L50jN1WBJ2QgOHR/Ta45Qav9AGb/GY9cLqzzbfTz7q7XxiQW9aoP+i9HhUV+gND3OLNx09a5jIqodqEUzvMrZdOdWOwMadSHn4wUvBslYmu1RhTuqdtGIYdHXBuiLYnK6+jGP/Snyj+VB4LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPC/aLcR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945BDC4CEF1;
	Fri, 22 Aug 2025 10:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755857330;
	bh=7pbp7b4MJQuhnZtl/iQt6X0PGAG53lDNYxERnubuCEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IPC/aLcR1VtD6z1nJN2YSAoZzdLo3MZsEee0m/eRJjRpHYtgxNfEinxYyfn3AUTna
	 dM+sV0D5pAnbIrUmGFOBlNAw+xvVYhH77ngT2sLecoCU7072HZ7lEd4OEZ1agP0nlD
	 QEXRPJkZb9hU/ZDyfzGu15XIuBkzuy70unHaoMWZCAUe9GGT/IG1WhdR7EIKktjAuK
	 2LhV4yUY8qso6nmQCYD4CEBa8XEW/ew4N7P8N3ZS2sazAVz5LUzKYYHm5JdtsfYaNz
	 ZF3++7JuKRRo5lQ+9ffuecWSIWnZdlUpc1NyRP4MTdTuFzGqhASLoGzGCZy9irZY8a
	 3fLTp9Hj9yBuw==
Date: Fri, 22 Aug 2025 14:34:08 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, 
	Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR when
 setting LAPIC regs
Message-ID: <zx4aiu65mmk72mo2kooj52q4k3vsp43znlrdadajivsw6ns7ou@7xtzfms3de66>
References: <cover.1755609446.git.maciej.szmigiero@oracle.com>
 <2b2cfff9a2bd6bcc97b97fee7f3a3e1186c9b03c.1755609446.git.maciej.szmigiero@oracle.com>
 <aKeDuaW5Df7PgA38@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKeDuaW5Df7PgA38@google.com>

On Thu, Aug 21, 2025 at 01:38:17PM -0700, Sean Christopherson wrote:
> On Tue, Aug 19, 2025, Maciej S. Szmigiero wrote:
> > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > 
> > When AVIC is enabled the normal pre-VMRUN sync in sync_lapic_to_cr8() is
> > inhibited so any changed TPR in the LAPIC state would not get copied into
> > the V_TPR field of VMCB.
> > 
> > AVIC does sync between these two fields, however it does so only on
> > explicit guest writes to one of these fields, not on a bare VMRUN.
> > 
> > This is especially true when it is the userspace setting LAPIC state via
> > KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
> > VMCB.
> > 
> > Practice shows that it is the V_TPR that is actually used by the AVIC to
> > decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
> > so any leftover value in V_TPR will cause serious interrupt delivery issues
> > in the guest when AVIC is enabled.
> > 
> > Fix this issue by explicitly copying LAPIC TPR to VMCB::V_TPR in
> > avic_apicv_post_state_restore(), which gets called from KVM_SET_LAPIC and
> > similar code paths when AVIC is enabled.
> > 
> > Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
> > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index a34c5c3b164e..877bc3db2c6e 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -725,8 +725,31 @@ int avic_init_vcpu(struct vcpu_svm *svm)
> >  
> >  void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
> >  {
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +	u64 cr8;
> > +
> >  	avic_handle_dfr_update(vcpu);
> >  	avic_handle_ldr_update(vcpu);
> > +
> > +	/* Running nested should have inhibited AVIC. */
> > +	if (WARN_ON_ONCE(nested_svm_virtualize_tpr(vcpu)))
> > +		return;
> 
> 
> > +
> > +	/*
> > +	 * Sync TPR from LAPIC TASKPRI into V_TPR field of the VMCB.
> > +	 *
> > +	 * When AVIC is enabled the normal pre-VMRUN sync in sync_lapic_to_cr8()
> > +	 * is inhibited so any set TPR LAPIC state would not get reflected
> > +	 * in V_TPR.
> 
> Hmm, I think that code is straight up wrong.  There's no justification, just a
> claim:
> 
>   commit 3bbf3565f48ce3999b5a12cde946f81bd4475312
>   Author:     Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>   AuthorDate: Wed May 4 14:09:51 2016 -0500
>   Commit:     Paolo Bonzini <pbonzini@redhat.com>
>   CommitDate: Wed May 18 18:04:31 2016 +0200
> 
>     svm: Do not intercept CR8 when enable AVIC
>     
>     When enable AVIC:
>         * Do not intercept CR8 since this should be handled by AVIC HW.
>         * Also, we don't need to sync cr8/V_TPR and APIC backing page.   <======
>     
>     Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>     [Rename svm_in_nested_interrupt_shadow to svm_nested_virtualize_tpr. - Paolo]
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> That claim assumes APIC[TPR] will _never_ be modified by anything other than
> hardware. 

It also isn't clear to me why only sync_lapic_to_cr8() was gated when 
AVIC was enabled, while sync_cr8_to_lapic() continues to copy V_TRP to 
the backing page. If AVIC is enabled, then the AVIC hardware updates 
both the backing page and V_TPR on a guest write to TPR.

> That's obviously false for state restore from userspace, and it's also
> technically false at steady state, e.g. if KVM managed to trigger emulation of a
> store to the APIC page, then KVM would bypass the automatic harware sync.

Do you mean emulation due to AVIC being inhibited? I initially thought 
this could be a problem, but in this scenario, AVIC would be disabled on 
the next VMRUN, so we will end up sync'ing TPR from the lapic to V_TPR.

> 
> There's also the comically ancient KVM_SET_VAPIC_ADDR, which AFAICT appears to
> be largely dead code with respect to vTPR (nothing sets KVM_APIC_CHECK_VAPIC
> except for the initial ioctl), but could again set APIC[TPR] without updating
> V_TPR.
>
> So, rather than manually do the update during state restore, my vote 
> is to restore the sync logic.  And if we want to optimize that code 
> (seems unnecessary), then we should hook all TPR writes.

I guess you mean apic_set_tpr()? We will need to hook into that in 
addition to updating avic_apicv_post_state_restore() since KVM_SET_LAPIC 
just does a memcpy of the register state.

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d9931c6c4bc6..1bfebe40854f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4046,8 +4046,7 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
>         struct vcpu_svm *svm = to_svm(vcpu);
>         u64 cr8;
>  
> -       if (nested_svm_virtualize_tpr(vcpu) ||
> -           kvm_vcpu_apicv_active(vcpu))
> +       if (nested_svm_virtualize_tpr(vcpu))
>                 return;
>  
>         cr8 = kvm_get_cr8(vcpu);

I agree that this is a simpler fix, so would be good to do for backport 
ease.

The code in sync_lapic_to_cr8 ends up being a function call to 
kvm_get_cr8() and ~6 instructions, which isn't that much. But if we can 
gate sync'ing V_TPR to the backing page in sync_cr8_to_lapic() as well, 
then it might be good to do so.


- Naveen


