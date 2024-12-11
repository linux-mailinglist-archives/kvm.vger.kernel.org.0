Return-Path: <kvm+bounces-33502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D87389ED651
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 20:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 249A81886E7B
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89BD237FDC;
	Wed, 11 Dec 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="TnOeE87z"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF8920B812;
	Wed, 11 Dec 2024 19:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943644; cv=none; b=nK0TaXruvFEvhH3daJdY1Z94zMXN0tdgE/umUyAetx6XAVHLO6+flTu1gCL/Mv5/RILCpqkS9MzGwpTgT1XcpsU1PqmAXxpdM4SZ+QX6gS2w9w0cf0vPm+A0KDnppK+gmp4cwRRfVsNVU4yCMIF2HwITmXWrcKvPXD2Eyd5LwzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943644; c=relaxed/simple;
	bh=150oBL40t4VacKmbp0f70pR4Wu6eyHZmp4sDBWbXpyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYYUGZNYMlXB+67gdsuR6puizszIGpbt+9KCezXXcEGsRXIV/DsTzPvpTS4xUEwpR0b2TNdUOptKQ0jLJKHP+JUZmW3P17XtQSEQsVrysgx7rQOefbnkeU32vI+IeEopwBNHWOr2Vw9YwfOM5rVfbwDGfoaugueXRoFmItRoQ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=TnOeE87z; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2E06C40E02B9;
	Wed, 11 Dec 2024 19:00:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MgJMfnRakA2h; Wed, 11 Dec 2024 19:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733943635; bh=hFITHqeKcZ3yAGHCql4Wq6is635X2/KeLgXn/itVKlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TnOeE87zAArqdxltmNAWKRR/MWqSjxdkIG93VzeXQw1EXd/cBH9+q2i0iR4procgT
	 bAd1pnfMKnVsPWVHWu6hpz2Yv1YdVfkexG0BOz5ZZthuH/2jr6kQ2u+94c6P4+mTS3
	 92wuG+8R9yopYqb9AxysM1tsys8Ry3Wp3Rup+0wU/AzIwhxCfVlaApyq7ewZFiB/Zr
	 edHe8ImKw2+nfq/76s8f7MtdLnASR/xM3kEc/3qwJTHhe2SFkhhFDKepHT+zChUBjD
	 Ldhsy/hz/wtJycnqrKgrQxwN6HoEGJ7koYpb74MYkAxlmAEu/wni7xKPyicnrQGaDJ
	 1+BCElhHPnc473nOLz4Gpy1v16KsTsMRCe2an0y9dwU5xIQ8uIoL2TQjsYRV58Qt0V
	 8dIxWaAo4f09vCsQXXrLaNvOpcjCcOp2aCV9YP42upfTJBFUFJdFP21kxQR2bhtZvQ
	 iFFk1Kr2tQ0S5nB18YfciDWf6x/BBMPc9fU6QjcI0TkM8eiG+lRlKzGFTECEzKcYqi
	 aF8c5QQ2R+OMKkNhVDvnS1t/TrOaho4KNyUFAK7/jaNm7xiLoyjfJ54ZTpo/rbI/eS
	 jgtT5rQwQRX51JIPgwR5UexTdmbO6Yf0wyMkhcg6GUzIIVWPcYx9pdRk4g7cbRYqsu
	 zDmR1/lTMpkJdMX9gGo06s/E=
Received: from zn.tnic (p200300Ea971F93Ce329C23FffeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93ce:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F39B040E0169;
	Wed, 11 Dec 2024 19:00:23 +0000 (UTC)
Date: Wed, 11 Dec 2024 20:00:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure
 TSC enabled guests
Message-ID: <20241211190023.GGZ1nhR7YQWGysKeEW@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
 <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
 <15e82ca3-9166-cdb4-7d66-e1c6600919d7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15e82ca3-9166-cdb4-7d66-e1c6600919d7@amd.com>

On Tue, Dec 10, 2024 at 08:29:31AM -0600, Tom Lendacky wrote:
> > This is changing the behavior for SEV-ES and SNP guests(non SECURE_TSC), TSC MSR
> > reads are converted to RDTSC. This is a good optimization. But just wanted to
> > bring up the subtle impact.
> 
> Right, I think it should still flow through the GHCB MSR request for
> non-Secure TSC guests.

Why?

I'm trying to think of a reason but I'm getting confused by what needs to
happen where and when... :-\

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

