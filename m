Return-Path: <kvm+bounces-37874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98F6FA30E98
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C528188B93D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4B1253B52;
	Tue, 11 Feb 2025 14:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DRFd+IWF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DA72512F4;
	Tue, 11 Feb 2025 14:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739284795; cv=none; b=Vud+Esz1mz40VuJ1BzBxlltUKZgJIgjmRE/RpBdEFxD51AJ+xAp6tyDWOAjRS5Y5YeLBoqyPo9O9Ek59hgHu90gNXZzMRsiRgfiu8CBQhClI3UezEkgSPBqyuu6lY48JLQXx7f7IAeksClR4/ndUqB04cCeukqJzZ1mJMY45D2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739284795; c=relaxed/simple;
	bh=irGBFZvISEuw2wpC8vSJ1dQOP9CCFXZdcoJvKrGVMzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkfDQht3HJtNuZ+kw9wsSjdxs+3USnZ1Qe0t1w5G82eVLXC7dmtS5QschZz4LUeTEtAVFzF0m1cYyFChAvx/oGs0r9JYEVLCz3kOEAJcet6zTpjWINkrzM3HfKOSZ6minOz7kR263lx2ItBpyK0IDh6oOf0Txm6ESIxnnnxKpIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DRFd+IWF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F29FE40E0224;
	Tue, 11 Feb 2025 14:39:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BL9hIm6yGZuQ; Tue, 11 Feb 2025 14:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739284787; bh=MoLQPIRFF2ToK9+6OuM2hGZjp5T1q9wl8C6INqwMDng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DRFd+IWFE5uOVAGwcy61fj/qecexF/x6y0dBm5TTJhmz0rCYYi9HD4fjWg4bUc5AD
	 RaursO1ZfrbphRYdloM13lR8JpbQ3oLvf3B9U0RWR6A7wsKDCpf7zObqSW/LefYsGD
	 mofk9b4zTUI1p0Dm8LVCYKiTQO6opHxlXtvmcLXHpvXK+h0ibfbN6i4en/hBXmxfxg
	 0pzWUdIiUKDo47yq0cMJHEdHx1r+gFjG26rGUDB47uaL3Aiklj6Ff3VDYqBcdJgWu4
	 PZmwpbxQz5QqI/modawN5aPQqoU1R4cFpgJAwfBnM1v0+sRhMXgxgEBjr0dgfRmv7i
	 +ymUCw5jsWZxqLHy7QBa8r5ltbfDdI5maVH27rTjsqRRIYcNdj+2QVZj/IGdfsHJoC
	 79PtuaPe/amSI3Ng/Uj4RwfdQYq7RTPgLmjMeKZkR2w7cpzzIRoPAbfpHf8/xRVT8Q
	 QYOSfzJT/cWwewyoir2VSOwmvsZhaa90jzypbbtCv0cRBF94hCumUj0rvkZHfvzsKO
	 rYQ8duFT6aDEMGpTrDjPWe59lV5O8/wkTUA4cpOGNvcG6EN1K9abvMPmZdwfTTZl7V
	 eVmi1Cv8ke8wfVlvgW0h91AsbdJpGGK9HtRa58ADZA/WVQePFf3cO8QVyxz698kH5s
	 yYToDTss4L2jNyGdDV/Lu3i0=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DA33A40E01AE;
	Tue, 11 Feb 2025 14:39:20 +0000 (UTC)
Date: Tue, 11 Feb 2025 15:39:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.amakhalov@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev,
	linux-hyperv@vger.kernel.org, jailhouse-dev@googlegroups.com,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 00/16] x86/tsc: Try to wrangle PV clocks vs. TSC
Message-ID: <20250211143919.GBZ6thF2Ryx-D2YpDz@fat_crate.local>
References: <20250201021718.699411-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250201021718.699411-1-seanjc@google.com>

On Fri, Jan 31, 2025 at 06:17:02PM -0800, Sean Christopherson wrote:
> And if the host provides the core crystal frequency in CPUID.0x15, then KVM
> guests can use that for the APIC timer period instead of manually
> calibrating the frequency.

Hmm, so that part: what's stopping the host from faking the CPUID leaf? I.e.,
I would think that actually doing the work to calibrate the frequency would be
more reliable/harder to fake to a guest than the guest simply reading some
untrusted values from CPUID...

Or are we saying here: oh well, there are so many ways for a normal guest to
be lied to so that we simply do the completely different approach and trust
the HV to be benevolent when we're not dealing with confidential guests which
have all those other things to keep the HV honest?

Just checking the general thinking here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

