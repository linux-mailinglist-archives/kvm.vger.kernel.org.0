Return-Path: <kvm+bounces-40135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B825A4F760
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 652373AAF68
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 06:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6971DC9BE;
	Wed,  5 Mar 2025 06:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wf9PaZn1"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25E1156F44
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 06:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741157125; cv=none; b=n/yr5HZILBlwoGoB6bB1o5cmtOdPtsagAW1V6KP2reFjBZkGo5ijAL7Zwri/cGW2pP3OPNcO5LOTafPMwzNKtQomrR2mqZMS0HYV/OndqZ4zIqdx4a/vGWPYnbKaaKv/nuZL8dD8011d64qfm0zgyeDauJDd3l9n+oaEXpTq9WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741157125; c=relaxed/simple;
	bh=1O99U5nRWIuBAzW+EccIHzGDSDZySRUCBYSsmWHrZoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUJGOY4Yoa74KOxckUIKWydNQiFI2lMIcxmCmnrWV5q9t2p02YmCnZZOh1stT78tN1ej7/5oiM0VNHtWkmZ4LeHUJhu8yEWK8Ib3Kw97wfy5qvnzAFmpAMNAxsQB7we8h9drp04jTmfPMP7PCdnt9tZG+4RaSOiLZedhhyOvttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wf9PaZn1; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 5 Mar 2025 06:45:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741157121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qS9UAv2i+fAHlT+2Q9Dnnlq3IrBK4nCeCJYvJbiG8Ow=;
	b=Wf9PaZn1OnZLxpIZbUPs+klnOtfRlJdhcNPTNu2uBWRJh9wGZEBrwJITmSbbKrosX2DcGq
	JWMal9Y6il+7Lu9N/zpchFMkmy1LqrPjjGbPwjE/0uaAncXOFgyA2cWFP1G4pMK7fTND9A
	jAh1zIO9J9k6mBYDFQbr7DLZAhFkROE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 13/13] KVM: nSVM: Stop bombing the TLB on nested
 transitions
Message-ID: <Z8fy-saRNCC031jw@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-14-yosry.ahmed@linux.dev>
 <da0b13813b11e5b13f01dced9a629ac07fad27cd.camel@redhat.com>
 <Z8YrdcWd1PD76adM@google.com>
 <36d8ffbda9e69c5245ded717e7491f6fcd5ca72e.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36d8ffbda9e69c5245ded717e7491f6fcd5ca72e.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 04, 2025 at 10:14:40PM -0500, Maxim Levitsky wrote:
> On Mon, 2025-03-03 at 22:21 +0000, Yosry Ahmed wrote:
> > On Fri, Feb 28, 2025 at 09:21:54PM -0500, Maxim Levitsky wrote:
> > > On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> > > > Now that nested TLB flushes are properly tracked with a well-maintained
> > > > separate ASID for L2 and proper handling of L1's TLB flush requests,
> > > > drop the unconditional flushes and syncs on nested transitions.
> > > > 
> > > > On a Milan machine, an L1 and L2 guests were booted, both with a single
> > > > vCPU, and pinned to a single physical CPU to maximize TLB collisions. In
> > > > this setup, the cpuid_rate microbenchmark [1] showed the following
> > > > changes with this patch:
> > > > 
> > > > +--------+--------+-------------------+----------------------+
> > > > > L0     | L1     | cpuid_rate (base) | cpuid_rate (patched) |
> > > > +========+========+===================+======================+
> > > > > NPT    | NPT    | 256621            | 301113 (+17.3%)      |
> > > > > NPT    | Shadow | 180017            | 203347 (+12.96%)     |
> > > > > Shadow | Shadow | 177006            | 189150 (+6.86%)      |
> > > > +--------+--------+-------------------+----------------------+
> > > > 
> > > > [1]https://lore.kernel.org/kvm/20231109180646.2963718-1-khorenko@virtuozzo.com/
> > > > 
> > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > ---
> > > >  arch/x86/kvm/svm/nested.c | 7 -------
> > > >  1 file changed, 7 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index 8e40ff21f7353..45a187d4c23d1 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -512,9 +512,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
> > > >  		svm->nested.last_asid = svm->nested.ctl.asid;
> > > >  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> > > >  	}
> > > > -	/* TODO: optimize unconditional TLB flush/MMU sync */
> > > > -	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > > > -	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > > >  }
> > > >  
> > > >  static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
> > > > @@ -530,10 +527,6 @@ static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
> > > >  	 */
> > > >  	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
> > > >  		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> > > > -
> > > > -	/* TODO: optimize unconditional TLB flush/MMU sync */
> > > > -	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > > > -	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > > >  }
> > > >  
> > > >  /*
> > > 
> > > Assuming that all previous patches are correct this one should work as well.
> > > 
> > > However only a very heavy stress testing, including hyperv, windows guests
> > > of various types, etc can give me confidence that there is no some ugly bug lurking
> > > somewhere.
> > 
> > I tried booting an L2 and running some workloads like netperf in there.
> > I also tried booting an L3.
> > 
> > I am planning to try and run some testing with a windows L2 guest. I am
> > assuming this exercises the hyper-V emulation in L1, which could be
> > interesting.
> > 
> > I am not sure if I will be able to test more scenarios though,
> > especially Windows as an L1 (and something else as an L2).
> > 
> > Let me know if you have something specific in mind.
> 
> 
> KVM can run itself 'under' HyperV (although in this case when it runs a guest
> the guest will be L3 overall, so not really something supported but still something that might
> reveal bugs).
> In this case KVM/L1 can take advantage of L0's TLB flush interface.

I don't think I will be able to test on Hyper-V.

> 
> Stress testing L3s also can be nice, although in this case from L0 POV, it doesn't see L3 at all.
> Instead it sees that L1 runs two different L2s back to back, so the current code will
> likely flush everything all the time.

I did run an L3 in an attempt to shake out any bugs.

> 
> 
> The direct TLB flush that hyperv does, especially from L2 to L0 should also be tested,
> it's a relatively new feature, so we need to check that L2 actually uses it.

Is this when KVM is emulating Hyper-V for nested guests, or when KVM is
running on top of Hyper-V? If the latter, as I said earlier I am not
sure if I will be able to test that.

> 
> KVM also has its own way of TLB flushing paravirtualization, which can in theory interfere with this.
> 
> 
> It's also nice to run a hyperv enabled Windows as KVM guest, and run a guest in it (can be Windows or Linux or anything else)
> Such guest will run two L2 VMs, Windows itself and the VM you run inside.

Yeah that's something I intend on doing. Sean mentioned that recent
Windows versions run the OS in L1 on top of the hypervisor in L0, so I
think if I run a Windows VM I automatically get both L1 and L2. So just
running a Windows VM should exercise the TLB flushes. I will also try to
run WSL to have multiple L2 VMs. I believe that's what you are talking
about here.

> 
> 
> You can also try other L1s, like VirtualBox, VMware, running in Windows or Linux L1,
> and themselves can run a windows or Linux L2. 
> 
> You can also test other OSes like BSD* and such as L1, they might have a different TLB access pattern and
> might reveal something, who knows. These can also run L2s using their own hypervisors.
> 
> Running a very old (say Windows XP, or some very old Linux) as L2 might also reveal something.

Honestly, I don't think I have the time or resources to test other
operating systems or L1s tbh. Currently my plan is to try and exercise
more scenarios in a Linux L2 guest, and run a Windows guest as I
mentioned earlier.

> 
> (But don't try to run win95/98 - this OS is known to not flush TLB properly (it doesn't use INVLPG when it should),
> so it doesn't work well on AMD at all because of this).

Good to know :)

> 
> Finally, it might be worth it to develop a TLB stress test if one doesn't exist yet.

I also thought about this, but I think it would be very tricky to cover
all the cases, and we'd need the test to create an L1 that is
sophisticated enough to exercise different TLB flushing scenarios. I
think running an actual OS as L1 is probably exercising the TLB code
more that any test.

That being said, Sean did mention the 'access' tests in KUT, and I plan
to check how relevant they are and if they can easily extended to add
some coverage for this.

