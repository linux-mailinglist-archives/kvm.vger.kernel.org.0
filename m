Return-Path: <kvm+bounces-55865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C06DB37E90
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD8A1203579
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B786A341652;
	Wed, 27 Aug 2025 09:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Asr76mip"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B912773C3;
	Wed, 27 Aug 2025 09:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756286245; cv=none; b=aFOLnfHqdSCh2bxitUpnUFZN1zoYrs7+1toiPAkZd7RV7G5BMD/dwyn6z1YyjoVgKjIA66VD/U0d4veHRIxfui/FJ++wAzn7iWeHiBQu08PRRm1oC7R4CFTe/oQAiyn3EusF/9ciFgNZiLYOwzuBt28IgNDbM9FHvTITRDp7vog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756286245; c=relaxed/simple;
	bh=TYyx1Z0CNHtXF1OQjZhKtuBTijXSsUPz57zuUcrMcvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENgBGOkmcO0o0kjC0UZsmZOQqEimMJsAhnOvg9mt2Fd8cQstDz5BlzwzBrr6Ozfr3MbO/0Fxd3yGESus0vlmhkeP8SkYklGalYYvSRNtvSTxl/P6nm2KDhi2C32rN/DQNUkujkXM0EMfoPs70Ns8PhO98CR0vEzUi74ficW6/1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Asr76mip; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF9CC113CF;
	Wed, 27 Aug 2025 09:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756286245;
	bh=TYyx1Z0CNHtXF1OQjZhKtuBTijXSsUPz57zuUcrMcvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Asr76mipEwGUVqlmQiWISvswLcwClR12ZwT7goxVWatoDn6RaUI2EvuUir5jc4ZOi
	 pVDBodH6b4RdBDcKYhF67601faqJKFIAxT67Cxr3XoilZRyOGuzwSiJCliOImN6FsS
	 rzgVonSjgUP8MpttBxXseKia9cgXo1F9rahoREOdV+aOuz5ErDQ6UrSbm2vu+DW/ec
	 HQILjuNSczallNk3E/hbN4yRaikm3kKbSfg9TdZ0x3bd+sgT74seFE3ZlhaO2+1a7m
	 IzWg9Fq72BffVaWAWAojuDMDfWxejd/55/E1KCU3yz6FoR7zjEielbez8xD/voiFAv
	 hWN5o7P5m8lQQ==
Date: Wed, 27 Aug 2025 11:17:22 +0200
From: Amit Shah <amit@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, jpoimboe@kernel.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: Re: [PATCH v5 1/1] x86: kvm: svm: set up ERAPS support for guests
Message-ID: <aK7NIk1ArgQaDPHp@mun-amitshah-l>
References: <20250515152621.50648-1-amit@kernel.org>
 <20250515152621.50648-2-amit@kernel.org>
 <aKYBeIokyVC8AKHe@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKYBeIokyVC8AKHe@google.com>

On (Wed) 20 Aug 2025 [10:10:16], Sean Christopherson wrote:
> On Thu, May 15, 2025, Amit Shah wrote:

[...]

> > For guests to observe and use this feature, 
> 
> Guests don't necessarily "use" this feature.  It's something that's enabled by
> KVM and affects harware behavior regardless of whether or not the guest is even
> aware ERAPS is a thing.

OK wording it is tricky.  "use" in the sense of for the entire RSB to be
utilized within guest context.  Not "use" as in guest needs enablement or
needs to do anything special.

"For the extended size to also be utilized when the CPU is in guest context,
the hypervisor needs to..." ?

> > the hypervisor needs to expose the CPUID bit, and also set a VMCB bit.
> > Without one or both of those, 
> 
> No?  If there's no enabling for bare metal usage, I don't see how emulation of
> CPUID can possibly impact usage of RAP size.  The only thing that matters is the
> VMCB bit.  And nothing in this patch queries guest CPUID.

True.

> Observing ERAPS _might_ cause the guest to forego certain mitigations, but KVM
> has zero visibility into whether or not such mitigations exist, if the guest will
> care about ERAPS, etc.

Sure, there's nothing guest-specific about this; any OS, when it detects
ERAPS, may or may not want to adapt to its existence.  (As it turns out, for
Linux, no adaptation is necessary.)

> > guests continue to use the older default RSB size and behaviour for backwards
> > compatibility.  This means the hardware RSB size is limited to 32 entries for
> > guests that do not have this feature exposed to them.

[...]

> > 2. Hosts that disable NPT: the ERAPS feature also flushes the RSB
> >    entries when the CR3 is updated.  When using shadow paging, CR3
> >    updates within the guest do not update the CPU's CR3 register.
> 
> Yes they do, just indirectly.  KVM changes the effective CR3 in reaction to the
> guest's new CR3.  If hardware doesn't flush in that situation, then it's trivially
> easy to set ERAP_CONTROL_FLUSH_RAP on writes to CR3.

Yea, that's right - since it doesn't happen in-guest (i.e. there's an exit
instead), it needs KVM to set that bit.

[...]

> > @@ -3482,6 +3485,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
> >  	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
> >  	pr_err("%-20s%d\n", "asid:", control->asid);
> >  	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
> > +	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
> >  	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
> >  	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
> >  	pr_err("%-20s%08x\n", "int_state:", control->int_state);
> > @@ -3663,6 +3667,11 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
> >  
> >  		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
> >  
> > +		if (vmcb_is_extended_rap(svm->vmcb01.ptr)) {
> > +			vmcb_set_flush_guest_rap(svm->vmcb01.ptr);
> > +			vmcb_clr_flush_guest_rap(svm->nested.vmcb02.ptr);
> > +		}
> > +
> >  		vmexit = nested_svm_exit_special(svm);
> >  
> >  		if (vmexit == NESTED_EXIT_CONTINUE)
> > @@ -3670,6 +3679,11 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
> >  
> >  		if (vmexit == NESTED_EXIT_DONE)
> >  			return 1;
> > +	} else {
> > +		if (vmcb_is_extended_rap(svm->vmcb01.ptr) && svm->nested.initialized) {
> > +			vmcb_set_flush_guest_rap(svm->nested.vmcb02.ptr);
> > +			vmcb_clr_flush_guest_rap(svm->vmcb01.ptr);
> > +		}
> 
> Handling this in the common exit path is confusing, inefficient, and lacking.

Heh, I agree.  I toyed with doing this just before VMRUN.  But I can't recall
why I disliked that more.

> Assuming hardware doesn't automatically clear ERAP_CONTROL_FLUSH_RAP, then KVM

That's right - it doesn't.

> should clear the flag after _any_ exit, not just exits that reach this point,
> e.g. if KVM stays in the fast path.

(or just before VMRUN).  Right.

> And IIUC, ERAP_CONTROL_FLUSH_RAP needs to be done on _every_ nested transition,
> not just those that occur in direct response to a hardware #VMEXIT. So, hook
> nested_vmcb02_prepare_control() for nested VMRUN and nested_svm_vmexit() for
> nested #VMEXIT.

Does sound better.  I think the case I wanted to preserve in this complex
logic was if we have a L2->exit->L2 transition, I didn't want to set the FLUSH
bit.

> Side topic, the changelog should call out that KVM deliberately ignores guest
> CPUID, and instead unconditionally enables the full size RAP when ERAPS is
> supported.  I.e. KVM _could_ check guest_cpu_cap_has() instead of kvm_cpu_cap_has()
> in all locations, to avoid having to flush the RAP on nested transitions when
> ERAPS isn't enumerated to the guest, but presumably using the full size RAP is
> better for overall performance.

Yea.

> The changelog should also call out that if the full size RAP is enabled, then
> it's KVM's responsibility to flush the RAP on nested transitions irrespective
> of whether or not ERAPS is advertised to the guest.  Because if ERAPS isn't
> advertised, the the guest's mitigations will likely be insufficient.

You mean the L2 guest?  ACK on the update.

> With the caveat that I'm taking a wild guess on the !npt behavior, something
> like this?

[...]

> +#define ERAP_CONTROL_FULL_SIZE_RAP BIT(0)
> +#define ERAP_CONTROL_FLUSH_RAP BIT(1)

Oh I def prefer to keep the APM-specified names.

[...]

Patch looks good!

I'll test it a bit and repost.

Thanks,

		Amit


