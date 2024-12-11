Return-Path: <kvm+bounces-33521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D65469ED992
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9F0A1885FBE
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C701F2360;
	Wed, 11 Dec 2024 22:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VgroUNht"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4E01A841F;
	Wed, 11 Dec 2024 22:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955804; cv=none; b=ilgxxUUot87e/ckhkicUc6LvwRiFYYEdUvcAdocpveyboHj//1SXyEsyyin4aqIdncBWw9vkLrNqhUyD8WQU1bZzVh1q3mt+qUP9aP/HV7xR1oIBx4FxVVShyLKIAwKYwFjm0JJueI4kBnhkSLXAbbZZBAXRyy4bm2MlwHpCkhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955804; c=relaxed/simple;
	bh=FAHaJzqzxhNMZUVphM4CCAPbYqfD6DAlT1PbmpRowAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cgU6g5WqKbALueTdLtjh2pEql7etCc75OzV274sjJpM4PiEidujhTSLo8NzXrRF2f9vQOkHLjka+MWQsAk9yDBwwlgEqWMAxJpJIlyHqvbg5iOWMmkmpbtn0asMSBDGxmIG6eNR0pTwhCcjXK1aXNmAYb8i2+DXzXklV2izYZgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VgroUNht; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8CD2140E02BC;
	Wed, 11 Dec 2024 22:23:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Za_wmwg4_34v; Wed, 11 Dec 2024 22:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733955795; bh=Ew8nV/ChJV7CVLh5nxiJBga8I8SZyEPbO518A/BfRuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VgroUNhtZd5joOyUMAT4CY3FiyX434MVYvhhDb2aj3y0CAM7oGobPhG3BqA5gcsKo
	 4bwdr5vlq+Kxs7NxNTduteizrtOa0ZgO/GbvCuOudFrT1PrbQ08+IIh9KkB4iDsFps
	 aE69hFYeLw6jdbyniGWm2pU8Zdc02NL55s4j6G3VqAMAwBH0Xf4dkAZVExhrCECNs0
	 AAU7vwhXQaJplePBfGuNhSvzblH3amPeYAfJUsk/Q/wp/86jS3jTpXAeIAnh5zov2w
	 hKMBue8UNvduT4NZoLu4omz/p0+y/qMYXAUtSOTDg7LDhGMSQqWN+Xpjo97eFJ9MxI
	 /iywiRjeYTndDkqaZCK7/gmkusik4iCLCwKNtz5il/UOOKzF7xNP7BxQzhjp/gQbsY
	 hhkM4AA1QEJyMbD70udJSpDh+ShunVYQRvlizcJIXQa0CgoTaLHA2PfcawFG+4ywrV
	 6D7Y0elZu07io7zSaNgFuqgz93d8t75qKIsyLvhvCwWu7Csz2ftIj7um8YRtthiOZF
	 H9Gv9ZYU56pyQcfh5sh0Mma+96WCOFdWVme/ZOMRaK1cGWQQc2TqD5doPyqHQdWoax
	 OSiS9+xEV5jepO0vuy/BJjD7IC1XfXqt9F8Kk0+rxDqdXRvbQtbN3IcjOo3Xt90FNq
	 BJo9UmngeTsd966DUcDQZZfg=
Received: from zn.tnic (p200300Ea971F93ce329c23FffEA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93ce:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DAF6240E02B9;
	Wed, 11 Dec 2024 22:23:03 +0000 (UTC)
Date: Wed, 11 Dec 2024 23:22:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure
 TSC enabled guests
Message-ID: <20241211222257.GKZ1oQwZcSXSMXPvoY@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
 <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
 <15e82ca3-9166-cdb4-7d66-e1c6600919d7@amd.com>
 <20241211190023.GGZ1nhR7YQWGysKeEW@fat_crate.local>
 <984f8f36-8492-9278-81b3-f87b9b193597@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <984f8f36-8492-9278-81b3-f87b9b193597@amd.com>

On Wed, Dec 11, 2024 at 04:01:31PM -0600, Tom Lendacky wrote:
> It could be any reason... maybe the hypervisor wants to know when this
> MSR used in order to tell the guest owner to update their code. Writing
> to or reading from that MSR is not that common, so I would think we want
> to keep the same behavior that has been in effect.

Ah, I thought you're gonna say something along the lines of, yeah, we must use
the HV GHCB protocol because of <raisins> and there's no other way this could
work.

> But if we do want to make this change, maybe do it separate from the
> Secure TSC series since it alters the behavior of SEV-ES guests and
> SEV-SNP guests without Secure TSC.

Already suggested so - this should be a separate patch.

It would be interesting to see if it brings any improvement by avoiding the HV
call... especially since RDTSC is used a *lot* and prominently at that in
sched_clock, for example.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

