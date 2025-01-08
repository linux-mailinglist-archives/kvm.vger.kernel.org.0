Return-Path: <kvm+bounces-34841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA206A0659D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 20:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9846B163CC8
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797AB202C4A;
	Wed,  8 Jan 2025 19:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jgBziM7E"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD3319ABB6;
	Wed,  8 Jan 2025 19:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736366048; cv=none; b=Gz0ogT5M63/GSgrpng5kXAbOJk82ZoYKqIb8wTkXJ1pe+fu/RKzowB5Qa6qD6qI2MV+mU6a1aXNPaFLoUMn/t57syrAeUdvBncETGogfD8+PFui/96Gs6tdIxrtf0YUpoA2csxWM2pxNPwUzMM1oYdgGJ6awplJmo7COkje7Dwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736366048; c=relaxed/simple;
	bh=1WhdFkm5TvvzgQMogGItBk3izfeNslQXiIz60qI13zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oftDalI13FR8yjoN9tDRyOB6b4qaJqWO96dNRUPNMUH02hzTpUDqG2KFpwwhfksADO+7+eUqo6TLOhHa0NpCXlTDNQY0QJs7HW5oOAgspPDmXCpIuW82nf/PWkjh4i3HyMFZym4D1i78HGAkk0/0nJ56sPGOUuLP7tqBfJScm1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jgBziM7E; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7E7CF40E0288;
	Wed,  8 Jan 2025 19:54:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pWvtWdUyOvzK; Wed,  8 Jan 2025 19:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736366039; bh=OiFUaUqOKrPeOdTdOo5dvna74DcOY3zRo6Ew3skg2NI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgBziM7EJXWaPPUr5xrdaAci59rZwvfzVi6T23D07ER42f/mxYz80xffcYCuDj1CC
	 Ik3fCQePUhlkJ80IcSrDtR+ahhsJIGAFG962PrhmHHz4RG7QMhYNggzHo1gAotDCw7
	 ksm5Dfv1GldW16iHGLnGmrIgOfTukVePaLllo+pajDLXKzCrx6q4BzcjvFTjm6dJyM
	 7BQBkKrlDb4J45B6B44bk7XuncLp9tc9ss2epovlG3j223rPCnsKnLzSZnK63oamk0
	 +zQP1lhweW+t6Pb2s+8tsJJeiseJWkHwRkCYk/bvgQzHKGu0gnWNtA7Z3rwl2WpfS7
	 4iXnhNk7Uva6AGX/0vShJjnfgcNWbNaUEw5mf8SgKApcHUpItyNHxLuHNHSNyorfN7
	 Ynz8o67yj+MuRicDbo5voZIpmIp5yX7yONwA/rg7F1qkK5j8vM+M4rBEwY4tjOKW/m
	 Sf1arH1EG3v4QF6iPI1fdZTyxGxJIYJGvNbyE2Fqcgsn0lhlHbFdICpjbtOxEx7AtK
	 fpHB6wzMz9E/VlJvW0kgx5+fcJ//zyaWMGZ2s0AT5l16+kj0KaeQvQpiDhuNYowA6R
	 2JxJVocy+/WwsES21Tpd78S1VIqObdBZ9f4QVVQgAdc5EsZ/vWd7xayIopBTD3fdCO
	 iSx52z1xd7paT1P0Sx7sk7RY=
Received: from zn.tnic (p200300eA971f938F329C23FffEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:938f:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1AB6D40E01F9;
	Wed,  8 Jan 2025 19:53:44 +0000 (UTC)
Date: Wed, 8 Jan 2025 20:53:43 +0100
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
Message-ID: <20250108195343.GJZ37XxzQrzJm7kksU@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com>
 <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z36vqqTgrZp5Y3ab@google.com>

On Wed, Jan 08, 2025 at 09:02:34AM -0800, Sean Christopherson wrote:
> I'm okay starting with just TDX and SNP guests, but I don't want to special case
> SNP's Secure TSC anywhere in kvmclock or common TSC/sched code.
> 
> For TDX guests, the TSC is _always_ "secure".

Ah, good to know. I was wondering what the situation in TDX land is wrt TSC...

> So similar to singling out kvmclock,
> handling SNP's STSC but not the TDX case again leaves the kernel in an inconsistent
> state.  Which is why I originally suggested[*] fixing the sched_clock mess in a
> generically; doing so would avoid the need to special case SNP or TDX in code
> that doesn't/shouldn't care about SNP or TDX.

Right.

> My vote is to apply through "x86/sev: Mark Secure TSC as reliable clocksource",
> and then split "x86/tsc: Switch Secure TSC guests away from kvm-clock" to grab
> only the snp_secure_tsc_init() related changes (which is how that patch should
> be constructed no matter what; adding support for MSR_AMD64_GUEST_TSC_FREQ has
> nothing to do with kvmclock).
> 
> And then figure out how to wrangle clocksource and sched_clock in a way that is
> sane and consistent.

Makes sense to me, I'll carve out the bits.

Nikunj, I'd appreciate it if you gathered whatever bits are left wrt kvmclock
and take care of things as Sean suggests above.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

