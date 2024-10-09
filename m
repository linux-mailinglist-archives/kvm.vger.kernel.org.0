Return-Path: <kvm+bounces-28232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D57A09968B2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1385C1C20A54
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D88192D70;
	Wed,  9 Oct 2024 11:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GG8exBYu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D26A1925AF;
	Wed,  9 Oct 2024 11:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728472970; cv=none; b=m4tOiG5H59x2symr1jKpZUt0Rui6H+QA7nBo3sA0iE9iTwFIZPbXhdOn//3FmcrhbF9zP9StAzrq6WoqfQzwhs8haKg39umGtTVSxH7w9/cJU73u6f7LZ4g/MP4QbmW3Mvy77FzwQNf30W0gsz3yQwxBraOoW+V0F24em7LbodM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728472970; c=relaxed/simple;
	bh=X+X5pqYz1T47iLwFfpzVNKgxYUB28qYfDSgtxnhoG2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hALU9M3oaQuRVLtIZRbgQ555uo7EB7kR7KMhofXrrPwLIf8fAo5g+RZTNt6S2keevCLNN6zzsuZDAcgapsMW5FlFjf9CPUt2sJmmyvOxwJf2KxVmbdHWkp8dcclHl9Y1k17haJJID/dq+jSdtvBCwrKw2TpdJQtNWVPouhK7fFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GG8exBYu; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 023BB40E0284;
	Wed,  9 Oct 2024 11:22:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id i4qykRlUbPsH; Wed,  9 Oct 2024 11:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1728472960; bh=3Xost7FCGJwitvgxtuVBjex1pNOGJ+J8b2uM+8TsZPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GG8exBYuoax+VVUhvcB4YP+lw/9UuJsqkPJpJvg2iScEFePPgOhUBXrFH1vHUb6Ar
	 ZVj6PNdMfaYKlwq6jHgmB4BNNaUcXSad6aDR+C9XsAsg9K7KKk13L9Sdz35txus0qS
	 C/IkzFK4KoqEq28JpSSQwbljtjce2hIANLbjfX6KwAvfRyiK+JTSbeCh31bAkKntWH
	 mh5O8VxNWre9vcRH5KWziVVfU9LCxGaWc38Ga14+JTrc32UC/Lw/K5e558TVQ1QfDE
	 FmkRG7D3U3whbbaIi5L9xm05d2G3a67k882Brz3JvMuZoEgWHmMOHPSZqMJJ4Wm4JH
	 rid4g4nzO0DTOqsszwlZBzEFwS4NDt04mCm+8ZpX87Pw28skcLW1tmBHR0J4qmVqcR
	 6Q87Q4vC1MrlAhMHJzMUEBzH0L3cYbwVdyt69GnXOBxMb/NSSao1u325AdWLeIS0u5
	 mSaWulIIMd3heI/NO9zMhD0c52X5jAZxmRKW9ssA9XalFVCY+eBSoldL9nFmgpHdIz
	 GqKau8TKvUpGOhqobLShoOoX7frvZPcqg2DOs2yTNr7xnvd6BPnuTpgK8xuRxr/huq
	 pyYP6f1vzg1P+oICs4rDQdLHoEp1Jkdg/lZVtevgobTgXthY0cIkgdVILAXkgP/C4x
	 YazgUE6kWpUUibabECljtEVA=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EE0E440E0191;
	Wed,  9 Oct 2024 11:22:21 +0000 (UTC)
Date: Wed, 9 Oct 2024 13:22:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241009112216.GHZwZnaI89RBEcEELU@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <sng54pb3ck25773jnajmnci3buczq4tnvuofht6rnqbfqpu77s@vucyk6py2wyf>
 <20241009104234.GFZwZeGsJA-VoHSkxj@fat_crate.local>
 <7vgwuvktoqzt5ue3zmnjssjqccqahr75osn4lrdnoxrhmqp5f6@p5cy6ypkchdv>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7vgwuvktoqzt5ue3zmnjssjqccqahr75osn4lrdnoxrhmqp5f6@p5cy6ypkchdv>

On Wed, Oct 09, 2024 at 02:03:48PM +0300, Kirill A. Shutemov wrote:
> I would rather convert these three attributes to synthetic X86_FEATUREs
> next to X86_FEATURE_TDX_GUEST. I suggested it once.

And back then I answered that splitting the coco checks between a X86_FEATURE
and a cc_platform ones is confusing. Which ones do I use, X86_FEATURE or
cc_platform?

Oh, for SNP or TDX I use cpu_feature_enabled() but in generic code I use
cc_platform.

Sounds confusing to me.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

