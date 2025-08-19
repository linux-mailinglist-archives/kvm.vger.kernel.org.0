Return-Path: <kvm+bounces-55041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D81B2CE79
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8C5516F1D8
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3A23451A4;
	Tue, 19 Aug 2025 21:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kJ1XyVjl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210A333CE99;
	Tue, 19 Aug 2025 21:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755638711; cv=none; b=cOPbCGGgi7xE32417hdHJH3gOYfWCgj5X+Le1rRSklH1tpX+pthTgRBtv41QFxlhpB0QHyIFfkgEV5ZpYYGX0UMM7njYt49BZxMk3SqzgOBYXkoPfGQR/8lklnVUtvx3MhVbWVMYSG4PAHUjH5TS/hpOT3I9v5zyaycYRxJRaQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755638711; c=relaxed/simple;
	bh=gz4cSJidYvlRm3l98kEQpnBrC6PXb3bq3dh8HN1CvVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qidUkNzU//aaEshd9L1tfO1H1kPJIyhDEzjgtsVub1eallSvCktlCASYxcFSba2H/ndPsF075fN7frN6SQ+0n40CeufHv2mrWlIB7r9VNRc82gtx+TbFQGoSrJcdCtIdy5VzQDdvLc8IlNAEcartRPILJZQTjv0NT9hB09zrPvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kJ1XyVjl; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9469D40E0206;
	Tue, 19 Aug 2025 21:25:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ghLrb5KTflZr; Tue, 19 Aug 2025 21:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755638701; bh=xNjVKGDyo0LdT07rIb/GdeJXA9lh/FC32YYUKXTYqCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kJ1XyVjlF3OZQOVI1MfOatgUUQc2yslNBcCWiJ93iOMsytWJt1Y0op+ubx2Mlh9Gx
	 c/fRvDd7nCozp6MlMn14BmuLvVmmsxxjOZSnnFTj6uSssn33ZZpifnGeOG+/taIE+H
	 80bUOHn4EtnPY3VWYv2zQNOpvqHtW6ZvaZG3ObeprDcwqv4miAwS4kbCbTMDvQNXm+
	 NZew+MrIuG8IfQL+fEA1YqoL6LwTH6S3DV/HLLwtZULNGIUFGA1Mux0CzWUQ0g1meg
	 QoH+Y1qO7VV18RtUlGgkbgO5VnxDdax8XlgUfzRRFjF11SXjgBF1aOtnhOqf/WnW7R
	 dvq+HpC91Yj2PTUIOBox2msG9Y43Xfh42+fFU/FFqtiqwfSuwS8oEcfVXTZJnwYI3n
	 6kfDJ+H2xGPcm31F88ZjFJnA1CQzwP2ww/Gu1n2d98ZMzghylFXGyWjclyIloUbeb+
	 mAVl53VZfjijMrtKn/LlRpj8Z+0gw4a68dFMQ3ylALuQh0KcRMiV9bT/FcWNDHwrzc
	 ZT5v7+QDeZrGEWYaGm86Wzv0UPAQ0Tp02aO32Qrn5Db5m3wW3/i973cphIRhAgeNv7
	 w02o9lE3lurUzZVI7pTkyUMPr8OorXtWHLo1aAovvwIQy0E4s0RhnisHUnyFmYfR31
	 jlLqOsIgsAZeBodWMJP2eURw=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8393240E0232;
	Tue, 19 Aug 2025 21:24:42 +0000 (UTC)
Date: Tue, 19 Aug 2025 23:24:36 +0200
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
Message-ID: <20250819212436.GIaKTrlN6tjmuXJvxs@fat_crate.local>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
 <20250819113447.GJaKRhVx6lBPUc6NMz@fat_crate.local>
 <e3a8e247-0ced-4354-b7cf-25ee7beb9987@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e3a8e247-0ced-4354-b7cf-25ee7beb9987@amd.com>

On Tue, Aug 19, 2025 at 07:58:52PM +0530, K Prateek Nayak wrote:
> This is possible, however what should be the right thing for
> CPUID_Fn8000001E_EBX [Core Identifiers] (Core::X86::Cpuid::CoreId)?
> 
> Should QEMU just wrap and start counting the Core Identifiers again
> from 0?
> 
> Or Should QEMU go ahead and populate just the
> CPUID_Fn8000001E_EAX [Extended APIC ID] (Core::X86::Cpuid::ExtApicId)
> fields and continue to zero out EBX and ECX when CoreID > 255?

I think the right thing to do is what the HW does (or will do), when it gets
to more than 256 APIC IDs - "cores" is ambiguous.

Perhaps something to discuss with hw folks internally first and then stick to
that plan everywhere, qemu included.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

