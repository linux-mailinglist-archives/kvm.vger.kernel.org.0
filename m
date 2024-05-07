Return-Path: <kvm+bounces-16816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A02988BDE39
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5788F282FCB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C594D14D71E;
	Tue,  7 May 2024 09:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="g4cR8t/i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [83.166.143.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A8C14D71B
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 09:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074236; cv=none; b=bB0Crq8bVKLdQy649obHzFAMhk7I0YpzcMJ3hRYFNQZ7I4fiwtotFBybrXLMZeCwDoeCv/UMpXI7aTaAP7L9Av+oW/oRKvMpzAudlMSent5hB6R9DiFQibOdEenxJzj+1bSoneNfJiHPk4mfD7sCz6nJ3R5YL0c9ovvbGqV1bhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074236; c=relaxed/simple;
	bh=N7C083XW9HErJ1+R52TKnyEZNzil5v9FCazYyr/JQx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qf81RWJj41CvWPHwiIQlrtq6A0drtfSBAXV+tXUqd8Lr2xqCZxU5O0XShzDyBToiYUdDfG45nUeox27vfX/qJxNpulsXtexX9n/O5ts7iqO01vmjXEp3UxXK4wOMzOYRS9pZhITHpjAWhaEEWCyBwmiSMfZM52lXgf/YexY98K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=g4cR8t/i; arc=none smtp.client-ip=83.166.143.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VYY0h64rLzhcB;
	Tue,  7 May 2024 11:30:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1715074228;
	bh=N7C083XW9HErJ1+R52TKnyEZNzil5v9FCazYyr/JQx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g4cR8t/iRRSN5giqF0Iwy3XXWNCfhqE/qqqfoxy0lSmFuyqhdQ4FyOhVfsBJ5BFWv
	 xFaM80SdAPMBtmnCReKLZkFRcwvBisebzGQz+PahxsjXN1dm1r13uXB5fKC058GUn5
	 E40tFjEfU9DKYpAc1PGGy+RZ3L2pJN9bZLXwuqBg=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VYY0d4NWlzhxd;
	Tue,  7 May 2024 11:30:25 +0200 (CEST)
Date: Tue, 7 May 2024 11:30:24 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Alexander Graf <graf@amazon.com>, 
	Angelina Vu <angelinavu@linux.microsoft.com>, Anna Trikalinou <atrikalinou@microsoft.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Forrest Yuan Yu <yuanyu@google.com>, 
	James Gowans <jgowans@amazon.com>, James Morris <jamorris@linux.microsoft.com>, 
	John Andersen <john.s.andersen@intel.com>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Marian Rotariu <marian.c.rotariu@gmail.com>, Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>, 
	=?utf-8?B?TmljdciZb3IgQ8OuyJt1?= <nicu.citu@icloud.com>, Thara Gopinath <tgopinath@microsoft.com>, 
	Trilok Soni <quic_tsoni@quicinc.com>, Wei Liu <wei.liu@kernel.org>, Will Deacon <will@kernel.org>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, =?utf-8?Q?=C8=98tefan_=C8=98icleru?= <ssicleru@bitdefender.com>, 
	dev@lists.cloudhypervisor.org, kvm@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, 
	x86@kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [RFC PATCH v3 3/5] KVM: x86: Add notifications for Heki policy
 configuration and violation
Message-ID: <20240507.ieghomae0UoC@digikod.net>
References: <20240503131910.307630-1-mic@digikod.net>
 <20240503131910.307630-4-mic@digikod.net>
 <ZjTuqV-AxQQRWwUW@google.com>
 <20240506.ohwe7eewu0oB@digikod.net>
 <ZjmFPZd5q_hEBdBz@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZjmFPZd5q_hEBdBz@google.com>
X-Infomaniak-Routing: alpha

On Mon, May 06, 2024 at 06:34:53PM GMT, Sean Christopherson wrote:
> On Mon, May 06, 2024, Mickaël Salaün wrote:
> > On Fri, May 03, 2024 at 07:03:21AM GMT, Sean Christopherson wrote:
> > > > ---
> > > > 
> > > > Changes since v1:
> > > > * New patch. Making user space aware of Heki properties was requested by
> > > >   Sean Christopherson.
> > > 
> > > No, I suggested having userspace _control_ the pinning[*], not merely be notified
> > > of pinning.
> > > 
> > >  : IMO, manipulation of protections, both for memory (this patch) and CPU state
> > >  : (control registers in the next patch) should come from userspace.  I have no
> > >  : objection to KVM providing plumbing if necessary, but I think userspace needs to
> > >  : to have full control over the actual state.
> > >  : 
> > >  : One of the things that caused Intel's control register pinning series to stall
> > >  : out was how to handle edge cases like kexec() and reboot.  Deferring to userspace
> > >  : means the kernel doesn't need to define policy, e.g. when to unprotect memory,
> > >  : and avoids questions like "should userspace be able to overwrite pinned control
> > >  : registers".
> > >  : 
> > >  : And like the confidential VM use case, keeping userspace in the loop is a big
> > >  : beneifit, e.g. the guest can't circumvent protections by coercing userspace into
> > >  : writing to protected memory.
> > > 
> > > I stand by that suggestion, because I don't see a sane way to handle things like
> > > kexec() and reboot without having a _much_ more sophisticated policy than would
> > > ever be acceptable in KVM.
> > > 
> > > I think that can be done without KVM having any awareness of CR pinning whatsoever.
> > > E.g. userspace just needs to ability to intercept CR writes and inject #GPs.  Off
> > > the cuff, I suspect the uAPI could look very similar to MSR filtering.  E.g. I bet
> > > userspace could enforce MSR pinning without any new KVM uAPI at all.
> > > 
> > > [*] https://lore.kernel.org/all/ZFUyhPuhtMbYdJ76@google.com
> > 
> > OK, I had concern about the control not directly coming from the guest,
> > especially in the case of pKVM and confidential computing, but I get you
> 
> Hardware-based CoCo is completely out of scope, because KVM has zero visibility
> into the guest (well, SNP technically allows trapping CR0/CR4, but KVM really
> shouldn't intercept CR0/CR4 for SNP guests).
> 
> And more importantly, _KVM_ doesn't define any policies for CoCo VMs.  KVM might
> help enforce policies that are defined by hardware/firmware, but KVM doesn't
> define any of its own.
> 
> If pKVM on x86 comes along, then KVM will likely get in the business of defining
> policy, but until that happens, KVM needs to stay firmly out of the picture.
> 
> > point.  It should indeed be quite similar to the MSR filtering on the
> > userspace side, except that we need another interface for the guest to
> > request such change (i.e. self-protection).
> > 
> > Would it be OK to keep this new KVM_HC_LOCK_CR_UPDATE hypercall but
> > forward the request to userspace with a VM exit instead?  That would
> > also enable userspace to get the request and directly configure the CR
> > pinning with the same VM exit.
> 
> No?  Maybe?  I strongly suspect that full support will need a richer set of APIs
> than a single hypercall.  E.g. to handle kexec(), suspend+resume, emulated SMM,
> and so on and so forth.  And that's just for CR pinning.
> 
> And hypercalls are hampered by the fact that VMCALL/VMMCALL don't allow for
> delegation or restriction, i.e. there's no way for the guest to communicate to
> the hypervisor that a less privileged component is allowed to perform some action,
> nor is there a way for the guest to say some chunk of CPL0 code *isn't* allowed
> to request transition.  Delegation and restriction all has to be done out-of-band.
> 
> It'd probably be more annoying to setup initially, but I think a synthetic device
> with an MMIO-based interface would be more powerful and flexible in the long run.
> Then userspace can evolve without needing to wait for KVM to catch up.
> 
> Actually, potential bad/crazy idea.  Why does the _host_ need to define policy?
> Linux already knows what assets it wants to (un)protect and when.  What's missing
> is a way for the guest kernel to effectively deprivilege and re-authenticate
> itself as needed.  We've been tossing around the idea of paired VMs+vCPUs to
> support VTLs and SEV's VMPLs, what if we usurped/piggybacked those ideas, with a
> bit of pKVM mixed in?
> 
> Borrowing VTL terminology, where VTL0 is the least privileged, userspace launches
> the VM at VTL0.  At some point, the guest triggers the deprivileging sequence and
> userspace creates VTL1.  Userpace also provides a way for VTL0 restrict access to
> its memory, e.g. to effectively make the page tables for the kernel's direct map
> writable only from VTL1, to make kernel text RO (or XO), etc.  And VTL0 could then
> also completely remove its access to code that changes CR0/CR4.
> 
> It would obviously require a _lot_ more upfront work, e.g. to isolate the kernel
> text that modifies CR0/CR4 so that it can be removed from VTL0, but that should
> be doable with annotations, e.g. tag relevant functions with __magic or whatever,
> throw them in a dedicated section, and then free/protect the section(s) at the
> appropriate time.
> 
> KVM would likely need to provide the ability to switch VTLs (or whatever they get
> called), and host userspace would need to provide a decent amount of the backend
> mechanisms and "core" policies, e.g. to manage VTL0 memory, teardown (turn off?)
> VTL1 on kexec(), etc.  But everything else could live in the guest kernel itself.
> E.g. to have CR pinning play nice with kexec(), toss the relevant kexec() code into
> VTL1.  That way VTL1 can verify the kexec() target and tear itself down before
> jumping into the new kernel. 
> 
> This is very off the cuff and have-wavy, e.g. I don't have much of an idea what
> it would take to harden kernel text patching, but keeping the policy in the guest
> seems like it'd make everything more tractable than trying to define an ABI
> between Linux and a VMM that is rich and flexible enough to support all the
> fancy things Linux does (and will do in the future).

Yes, we agree that the guest needs to manage its own policy.  That's why
we implemented Heki for KVM this way, but without VTLs because KVM
doesn't support them.

To sum up, is the VTL approach the only one that would be acceptable for
KVM?  If yes, that would indeed require a *lot* of work for something
we're not sure will be accepted later on.

> 
> Am I crazy?  Or maybe reinventing whatever that McAfee thing was that led to
> Intel implementing EPTP switching?
> 

