Return-Path: <kvm+bounces-54978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B916B2C0A9
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 13:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 909DD1893E12
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E3632BF5D;
	Tue, 19 Aug 2025 11:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="lAeSY4ZM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7FC30F813;
	Tue, 19 Aug 2025 11:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755603325; cv=none; b=eRZ2pvPDPfjLjvd2R5o1VCqybOt35iQrnxAxPTsKPrOHyFoQCf2MFpmxT7f3ar3owj1zTHesxKwL6pEYS4/xoV0mSmPnBbha49If2/VzDqiT63w7pTjixXKWkya3FiQVYWKec+vKGoQsxqbhZMz/DsoCQd4/LZARlhboa20UCoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755603325; c=relaxed/simple;
	bh=WV1rxNjB+TYqIAQsI+V7tfqrGc3WfHnR+6UzQJkULEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQdDrjIVlJHeJek99B8g7mp1h/1SRaWzoRU+bww3WDDSUaPmYLj2q1WvxqpRiLHUTkgS+2u1+st71aFqGzeGl9xVg87j/qhNQRbi8UTuGiMmm/iA5gOd0bZBFSltiK35U7h3MgY9+w/IQJdKVIb9aktq0+w8U+gVpnO0QGa1ZuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=lAeSY4ZM; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7B59540E0232;
	Tue, 19 Aug 2025 11:35:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aLRSC9M65czv; Tue, 19 Aug 2025 11:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755603314; bh=g/G+pgACZoF3hG1rLn4uE9m9WQvLEWOUUt+4q8jMk+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lAeSY4ZM2pw8IFmOlaS3AA7YC0WWO8kVSib0isnJ8MRUkSjuLstJyZqTzuRP8le9q
	 CSNI7jaT/Lf5fG3tJyzKxBvuhs730KAvfOomyiuBWOIUgrlJv/F6rYw8Fk/yKCha+2
	 3tZOnENDz3MTygaarLvMsyKcB+fY1RAx26rN81IhxOWSECHxXNVf2HplYbBFKPnbhv
	 mr6A3xWbDhSinS0oFJgDwowtf3MYi65+a9pILK9HsmGZW9T9bRqfxZWwAW2Is6IenL
	 K9lI1diW6dLFi6tCsmycgF2yLc4Ae3Ewav2kqmmLWYAZkn+OH0CGmZ+3VJWt5NaLlK
	 le2zqk8WD8JwanqHAzd4O6RR3aeLoUbTzvFU4w1zdvJdpCLwFOT/csJ4lE7Wd7hQKW
	 qp2jg1oaty6mizUrCYZ13ItdfTlk7bHo79g4v2FQDKh3YhrC+tcVjDalthNvYfVy9L
	 gyBpsgCzj8gWW4gG/bh+b7nSQG7EE5pmlGbWequqkNjScRosvyMLD4UR6ZVtrloQz3
	 Z73WYBQy2+mRobPzbi4xKJhqN7B+C+4oT0Ne+S0+f/WbShBLN+rXNuLtY7HIQo/ENC
	 K4xQmKQXGQcXNYrtzevlnHZybRXnaQ6AabWK/hwM/5oer7TJYMOeVAkIIv1c2dg6z6
	 AW5XntmANeHujyHURoDkG7Cc=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0DF5140E0194;
	Tue, 19 Aug 2025 11:34:54 +0000 (UTC)
Date: Tue, 19 Aug 2025 13:34:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
	Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v3 0/4] x86/cpu/topology: Work around the nuances of
 virtualization on AMD/Hygon
Message-ID: <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250818060435.2452-1-kprateek.nayak@amd.com>

Lemme try to make some sense of this because the wild use of names and things
is making my head spin...

On Mon, Aug 18, 2025 at 06:04:31AM +0000, K Prateek Nayak wrote:
> When running an AMD guest on QEMU with > 255 cores, the following FW_BUG
> was noticed with recent kernels:
> 
>     [Firmware Bug]: CPU 512: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0200
> 
> Naveen, Sairaj debugged the cause to commit c749ce393b8f ("x86/cpu: Use
> common topology code for AMD") where, after the rework, the initial
> APICID was set using the CPUID leaf 0x8000001e EAX[31:0] as opposed to

That's

CPUID_Fn8000001E_ECX [Node Identifiers] (Core::X86::Cpuid::NodeId)

> the value from CPUID leaf 0xb EDX[31:0] previously.

That's

CPUID_Fn0000000B_EDX [Extended Topology Enumeration]
(Core::X86::Cpuid::ExtTopEnumEdx)

> This led us down a rabbit hole of XTOPOEXT vs TOPOEXT support, preferred

What is XTOPOEXT? 

CPUID_Fn0000000B_EDX?

Please define all your things properly so that we can have common base when
reading this text.

TOPOEXT is, I presume:

#define X86_FEATURE_TOPOEXT		( 6*32+22) /* "topoext" Topology extensions CPUID leafs */

Our PPR says:

CPUID_Fn80000001_ECX [Feature Identifiers] (Core::X86::Cpuid::FeatureExtIdEcx)

"22 TopologyExtensions: topology extensions support. Read-only. Reset:
Fixed,1. 1=Indicates support for Core::X86::Cpuid::CachePropEax0 and
Core::X86::Cpuid::ExtApicId."

Those leafs are:

CPUID_Fn8000001D_EAX_x00 [Cache Properties (DC)] (Core::X86::Cpuid::CachePropEax0)

DC topology info. Probably not important for this here.

and

CPUID_Fn8000001E_EAX [Extended APIC ID] (Core::X86::Cpuid::ExtApicId)

the extended APIC ID is there.

How is this APIC ID different from the extended APIC ID in

CPUID_Fn0000000B_EDX [Extended Topology Enumeration] (Core::X86::Cpuid::ExtTopEnumEdx)

?

> order of their parsing, and QEMU nuances like [1] where QEMU 0's out the
> CPUID leaf 0x8000001e on CPUs where Core ID crosses 255 fearing a
> Core ID collision in the 8 bit field which leads to the reported FW_BUG.

Is that what the hw does though?

Has this been verified instead of willy nilly clearing CPUID leafs in qemu?

> Following were major observations during the debug which the two
> patches address respectively:
> 
> 1. The support for CPUID leaf 0xb is independent of the TOPOEXT feature

Yes, PPR says so.

>    and is rather linked to the x2APIC enablement.

Because the SDM says:

"Bits 31-00: x2APIC ID of the current logical processor."

?

Is our version not containing the x2APIC ID?

> On baremetal, this has
>    not been a problem since TOPOEXT support (Fam 0x15 and above)
>    predates the support for CPUID leaf 0xb (Fam 0x17[Zen2] and above)
>    however, in virtualized environment, the support for x2APIC can be
>    enabled independent of topoext where QEMU expects the guest to parse
>    the topology and the APICID from CPUID leaf 0xb.

So we're fixing a qemu bug?

Why isn't qemu force-enabling TOPOEXT support when one requests x2APIC?

My initial reaction: fix qemu.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

