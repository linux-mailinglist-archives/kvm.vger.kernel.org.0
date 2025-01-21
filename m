Return-Path: <kvm+bounces-36107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 420BEA17D0D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 12:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB5BE1884A93
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A808F1F131B;
	Tue, 21 Jan 2025 11:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fsKhi3NQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B0526AFA;
	Tue, 21 Jan 2025 11:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737459147; cv=none; b=BfeldD3wCkQ2+ZYqii45h9tqAc+Vx72proaQm+i95a6f3KpniTKfdDSfpOGW9XHINWzNKsP5MAshX7kLSPTbB0pznBbn9WA979o4DBteGKwGCrmAtMZV4f91JRcaEz4Jmaq7DKyl4+q0QLlkaGaC2Xj//6syOymGki0VgLF8PEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737459147; c=relaxed/simple;
	bh=af+oSx+K9BpZVMKkleDgbo/9/G4dOsmPyIrvZ1SayG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ux7f5BnGbu2/gvuBOTZJpBY3KjSWj/wrfHzkG/MrBc4L+gryKE0I0GV+wP9urd782rjXH3jsnkB0f2XBTxSDH46HjNNOTFZuhj2rgDEs8A7tiSJZXXw3mVTM5ILUwC+X4qBlI5l/1xJRSRIEg4v9ZKhP4+vQvXMqRwNPmacjNHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fsKhi3NQ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 57D7040E0286;
	Tue, 21 Jan 2025 11:32:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id C9dbRpCkjAkc; Tue, 21 Jan 2025 11:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1737459140; bh=pJAtM4599Bc3qsGQx8W8156XT9kNhh7AoEjPS6NUepM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fsKhi3NQF3WiD4rN48HFsAZCOSmOs7DI503aBPgkRuUcvJDG/PgUxh2l7sva2Qll3
	 V7UQV655yVEXP63F7FghWPyXR5KQ19q5EDkjB6P15xiXWwjVIjxhPMGCdTNuZaHYBs
	 I8AHExOpsIGnmtIONptReAT1Cs9MSYcCYaI85+Z2RR+qgi6limveKHHOFx0wfyT3wJ
	 74g+ONC7WlIlCDVuaT7JVbogjyNlip1ldjBLlm9WyDRrqGWmrqAzqI6QjXKY//R7pQ
	 o88KsDhQkghaVrJ8WrO9gVUKLi/BGqcyFMVCfYSaw+hlOgj5YpiXeaUMBEYx5ezK+8
	 7uuj/MOVgpRU3dzsy/5R0fQmHFNaUMmdamWp1892OcA8W/CcBuwac4OlONKPxJF8mL
	 UwRR8/upYoUWsVdK1AcRidlQOhhDIbwIckZNPAfFUvOnAj2yCG2AsSiz8iv82U0mAu
	 trRV4Ym9bJlITNiBOQCH4mH5eOra+5RWDG2nD/V60wceChHXFYBUjTyoK0Q2gx8AAf
	 QoDA9+pCY07b1c1FZrKE5eA26E+HdHZUZyuBnllpIrIGOTPB8cIV1BwPb+1zJsZ/pR
	 KRsmtEJKfe0Tn8hdxBsCb3aI5S+zgrHzgrchVokaWY9hD1b3ieCwvQPxB5w/oVUloD
	 Q98AENAfbw0ZsYGedHRqYFdc=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 173C640E015F;
	Tue, 21 Jan 2025 11:32:05 +0000 (UTC)
Date: Tue, 21 Jan 2025 12:32:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
Message-ID: <20250121113204.GBZ4-FtP4cjjhKqvCV@fat_crate.local>
References: <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com>
 <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com>
 <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
 <Z4gqlbumOFPF_rxd@google.com>
 <20250116162525.GFZ4ky9TdSn7jltgw7@fat_crate.local>
 <Z4k6OcbLqMxvvmb-@google.com>
 <20250117202848.GAZ4q9gMHorhVMfvM0@fat_crate.local>
 <Z4rEuTonLal7Li1O@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z4rEuTonLal7Li1O@google.com>

On Fri, Jan 17, 2025 at 12:59:37PM -0800, Sean Christopherson wrote:
> The proposal here, and what kvmclock already does for clocksource, is to use the
> raw TSC when the hypervisor sets bits that effectively say that the massaging of
> TSC done by the PV clock isn't needed.
>
> > But we really really trust it when the guest type is SNP+STSC or TDX since
> > there the HV is out of the picture and the only one who can flub it there is
> > the OEM.
> 
> Yep.  This one _is_ about trust.  Specifically, we trust the raw TSC more than
> any clock that is provided by the HV.

Ok, makes sense.

> It's not KVM guest code though.  The CPUID stuff is Intel's architecturally
> defined behavior.  There are oodles and oodles of features that are transparently
> emulated by the hypervisor according to hardware specifications.  Generally
> speaking, the kernel treats those as "native", e.g. native_wrmsrl(), native_cpuid(),
> etc.

Uuuh, this is calling for confusion.

native_* has always been stuff the kernel calls when it runs, well, natively,
on baremetal. And not some PV or whatever-enlightened ops.

Now, if you want to emulate those transparently that's fine but this is what
native means in arch/x86/. Unless I've missed some memo but I doubt it. And
I asked around :)

> What I am proposing is that, for TDX especially, instead of relying on the
> hypervisor to use a paravirtual channel for communicating the TSC frequency,
> we rely on the hardware-defined way of getting the frequency, because CPUID
> is emulated by the trusted entity, i.e. the OEM.

I wouldn't trust the OEM with a single bit but that's a different story. :-P

> Hmm, though I suppose I'm arguing against myself in that case.  If the
> hypervisor provides the frequency and there are no trust issues, why would
> we care if the kernel gets the frequency via CPUID or the PV channel.  It's
> really only TDX that matters.  And we could handle TDX by overriding
> .calibrate_tsc() in tsc_init(), same as Secure TSC.

I guess it all boils down to the trust level you want to have with the TSC.
I don't know whether there's even a HV which tries to lie to the guest with
the TSC and I guess we'll find out eventually but for now we could treat the
two things similarly. The two things being:

- TDX and STSC SNP guests - full TSC trust
- HV with the required CPUID bits set - almost full, we assume HV is
  benevolent. Could change if we notice something.

> That said, I do think it makes sense to either override the vendor and F/M/S
> checks native_calibrate_tsc().  Or even better drop the initial vendor check
> entirely,

I have no clue why that thing is even there:

aa297292d708 ("x86/tsc: Enumerate SKL cpu_khz and tsc_khz via CPUID")

I guess back then it meant that only Intel sports those new CPUID leafs but
those things do change.

> because both Intel and AMD have a rich history of implementing each other's
> CPUID leaves.  I.e. I see no reason to ignore CPUID 0x15 just because the
> CPU isn't Intel.
> 
> As for the Goldmost F/M/S check, that one is a virtualization specific
> thing.  The argument is that when running as a guest, any non-TSC
> clocksource is going to be emulated by the hypervisor, and therefore is
> going to be less reliable than TSC.  I.e. putting a watchdog on TSC does
> more harm than good, because what ends up happening is the TSC gets marked
> unreliable because the *watchdog* is unreliable.

So I think the best thing to do is to carve out the meat of that function
which is valid for both baremetal and virtualized and then have separate
helpers which call the common thing. So that you don't have to test
on *everything* when having to change it in the future for whatever reason and
so that both camps can be relatively free when implementing their
idiosyncrasies.

And then it should fit in the current scheme with platform function ptrs.

I know you want to use native_calibrate_tsc() but then you have to sprinkle
"am I a guest" checks and this reminds me of the "if XEN" fiasco back then.
Also, a really nasty lying HV won't simply set X86_FEATURE_HYPERVISOR...

So I'd prefer if we fit a guest which runs on a relatively honest HV :) into
the current scheme as the kernel running simply on yet another platform, even
at the price of some small code duplication.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

