Return-Path: <kvm+bounces-65520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50957CAE8FA
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 01:49:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3C3D308ED02
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 00:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0262367CE;
	Tue,  9 Dec 2025 00:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PmzyMfvZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AD9218AAB
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 00:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765241324; cv=none; b=Tgb3rMbdCJeGVVADfmoC3mk/XEsgV2wJfHOtstO9pkegj2+S5NrNokWRdSVdPGlIOzR51MfWuN4ulaUJZVCrOFzFZdLUcgsgaNHANykJavYGIxX2xvtRcukVOoh+LLd02qX5ulSgkpAiVSWEFBxT2clAChh65MrN6+ACbUVFbUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765241324; c=relaxed/simple;
	bh=S3RFH80Xb4dwN71dMJF9zOdcMbXQRr/mxcin8aHHBKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XG2A1oMEfsJXNOxQ8A4XY/cC3uOhFccuULWh5lQFk1rRlGkJEbq0/piIuQKBUHckbqmJE9zIeSM62QgIRzKdiB8b0+7aa6gWwDKoH4K2Wko1SM5VpzLS+vKuO2Wd1uxjxXxpKqG8VTN9h4Pg1iuV7RApEGBzAshxGX4On3yQBU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PmzyMfvZ; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Dec 2025 00:48:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765241308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3U6blHyHC54iULT0QuHaYpTtaR4BR2LrdNCuPvUYiUU=;
	b=PmzyMfvZhrGe+u74PrGfU0LwNMzpSfJoFASQceTZX9LZ4oXG/c5EyNQz0VIgpKj7/dHvjQ
	OYmeG+rqpPFJpsdOI9dluraC9XWqZGpRH8hMXe2I7Lue+gQSXvC6BHaJv7ZKRMqCMhGhKU
	vhl2yzbttUhlLX7VefuR2F+web5H/Kk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Subject: Re: [PATCH v16 36/51] KVM: nSVM: Save/load CET Shadow Stack state
 to/from vmcb12/vmcb02
Message-ID: <tamhy4gqijflouthniyre3w5r4ywjuzvlaeavvgyrfifozdi3g@zcd432svuw5i>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-37-seanjc@google.com>
 <ngbxelfw4lvipsvnoykqo4sonuyjqhuyoh5yogvc6btqj4w6cr@y2jpmnyjphmc>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ngbxelfw4lvipsvnoykqo4sonuyjqhuyoh5yogvc6btqj4w6cr@y2jpmnyjphmc>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 28, 2025 at 10:23:02PM +0000, Yosry Ahmed wrote:
> On Fri, Sep 19, 2025 at 03:32:43PM -0700, Sean Christopherson wrote:
> > Transfer the three CET Shadow Stack VMCB fields (S_CET, ISST_ADDR, and
> > SSP) on VMRUN, #VMEXIT, and loading nested state (saving nested state
> > simply copies the entire save area).  SVM doesn't provide a way to
> > disallow L1 from enabling Shadow Stacks for L2, i.e. KVM *must* provide
> > nested support before advertising SHSTK to userspace.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 826473f2d7c7..a6443feab252 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -636,6 +636,14 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
> >  		vmcb_mark_dirty(vmcb02, VMCB_DT);
> >  	}
> >  
> > +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
> > +	    (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_CET)))) {
> > +		vmcb02->save.s_cet  = vmcb12->save.s_cet;
> > +		vmcb02->save.isst_addr = vmcb12->save.isst_addr;
> > +		vmcb02->save.ssp = vmcb12->save.ssp;
> > +		vmcb_mark_dirty(vmcb02, VMCB_CET);
> > +	}
> > +
> 
> According to the APM, there are some consistency checks that should be
> done on CET related fields in the VMCB12. Specifically from
> "Canonicalization and Consistency Checks. " in 15.5.1 in the APM Volume
> 2 (24593—Rev. 3.42—March 2024):
> 
> • Any reserved bit is set in S_CET
> • CR4.CET=1 when CR0.WP=0
> • CR4.CET=1 and U_CET.SS=1 when EFLAGS.VM=1
> • Any reserved bit set in U_CET (SEV-ES only):
>   - VMRUN results in VMEXIT(INVALID)
>   - VMEXIT forces reserved bits to 0
> 
> Most consistency checks are done in __nested_vmcb_check_save(), but it
> only operates on the cached save area, which does not have everything
> you need. You'll probably need to add the needed fields to the cached
> save area, or move the consistency checks elsewhere.
> 
> Related to this, I am working on patches to copy everything we use from
> vmcb12->save to the cache area to minimize directly accessing vmcb12
> from the guest memory as much as possible. So I already intend to add
> other fields to the cached save area.
> 
> There's also a couple of other missing consistency checks that I will
> send patches for, which also need fields currently not in the cached
> save area.

I don't really care that much, but I think this fell through the cracks.

Regarding the cached save area, the series I was talking about is
already out [*], and I am preparing to send a newer version. It puts the
fields used here in the cache, so it should be straightforward to add
the consistency checks on top of it.

[*]https://lore.kernel.org/kvm/20251110222922.613224-1-yosry.ahmed@linux.dev/

> 
> >  	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
> >  
> >  	svm_set_efer(vcpu, svm->nested.save.efer);
> > @@ -1044,6 +1052,12 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
> >  	to_save->rsp = from_save->rsp;
> >  	to_save->rip = from_save->rip;
> >  	to_save->cpl = 0;
> > +
> > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> > +		to_save->s_cet  = from_save->s_cet;
> > +		to_save->isst_addr = from_save->isst_addr;
> > +		to_save->ssp = from_save->ssp;
> > +	}
> >  }
> >  
> >  void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
> > @@ -1111,6 +1125,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >  	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
> >  	vmcb12->save.cpl    = vmcb02->save.cpl;
> >  
> > +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
> > +		vmcb12->save.s_cet	= vmcb02->save.s_cet;
> > +		vmcb12->save.isst_addr	= vmcb02->save.isst_addr;
> > +		vmcb12->save.ssp	= vmcb02->save.ssp;
> > +	}
> > +
> >  	vmcb12->control.int_state         = vmcb02->control.int_state;
> >  	vmcb12->control.exit_code         = vmcb02->control.exit_code;
> >  	vmcb12->control.exit_code_hi      = vmcb02->control.exit_code_hi;
> > -- 
> > 2.51.0.470.ga7dc726c21-goog
> > 

