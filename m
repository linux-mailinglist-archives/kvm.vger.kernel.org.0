Return-Path: <kvm+bounces-33325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC299E9AAC
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 16:37:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7482C2860DA
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 15:36:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B6F1C5CA7;
	Mon,  9 Dec 2024 15:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GkaIK0jF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF1C1B423A;
	Mon,  9 Dec 2024 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733758612; cv=none; b=I961GwJQActOPNwFUhwxZKLIl1Suy3pt7kbgU8RYcPUSrA9bMKL0+5AsOj8v+azoabW2DwNQLRX0qF+NwH4lKU/6mL/fs8m/WY4uhE2O6iFKWz5s7rVwSA7HRzFznIi45Cvs5Lqm90A00xgC+ry1V2PaZzD7OCyTMhhdujA49i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733758612; c=relaxed/simple;
	bh=u23xpMXKDQXAXNTTSJUN3dEZ4DGr+vUhy9HWCwQtvKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIM0rx8DreKyy5pfwiYKMcWubVN1Wx2QBgqDiMMRtz8SGhuCcGEEpuIHR3rZWawVyccv5NuQ/p0Ap9/ZPyNN9Axx8Icih8jaQPK7AXaY+FgCdf9UTC262lHtlf1Iq3NPo6SIZmhDzQqW27kz8q3d+1sB1uBS07Ym4aNO5JmbOtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GkaIK0jF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8C9A440E019C;
	Mon,  9 Dec 2024 15:36:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mDGC-KkFxf3S; Mon,  9 Dec 2024 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733758603; bh=VZlFuj5FtSkwHLOMN8Qj73EIeqPOllgrKoefjKTnmGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GkaIK0jFeHn8M7Ifzp1RpLzJczd8cePBeIVh3mGbzKeDv8PenkSOe5lotLM7BTNmw
	 nkmlQrZIfWMd7uleDdabhyUHMW9AE5OorZhuhgixfDAxceb8CCWBB4hQ+MQbnWVG82
	 0Se4d8wnVBqyhCQcdY9bD3r1UjuibQv7kO5AXUpcgQGcmh6unHqmKXRFReAAxxffGr
	 jVLeAkkgKk5xB60L/ofFCNBjJyAZwlHDLj7lnRWCQZLKFtVfAGvWf3hbvqwojFDU48
	 a8qskefOO2ZROyLpTc0ycncVaK1QFUMRlmCzSqWPc8a6qJ7TNyrzZMmEUGTS8H57mW
	 jhLA4X5D/zbRa8Mx3kiGEPeu4s8e3CgdMCnwLGgwEmpnHYY8MFivFfC4LRl2LyDIwu
	 y1WRY1uOFfNG60NMBGI+QtVysQAmTPzvITR/0AEWN4Fk5GRiq+WYfnX0F0ZySEv+kF
	 4Ddg03TvXfeNNTFLWk7pVvPUXRuk8wetM/V+HqP31qAmF/F4trUTnaV4yWdvuvFdDP
	 G7EWuvoEsPcv4o6ME9flx88WRWjueVUjuogyVK80QL6ancARHLAZeZxK+WhA8SeVbY
	 pl5nLWPpOULwkYMU5BYv17QE6ITls/bUJg0qGGYQ5IzYEaN0VlOdN0ynUoahFxI4Jf
	 WVJ6014zng+sOOqFs9i3j06w=
Received: from zn.tnic (p200300Ea971f9307329C23fFfea6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9307:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3C19940E015E;
	Mon,  9 Dec 2024 15:36:31 +0000 (UTC)
Date: Mon, 9 Dec 2024 16:36:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <20241209153625.GDZ1cOeYjTYDoN_oVC@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
 <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local>
 <8965fa19-8a9b-403e-a542-8566f30f3fee@amd.com>
 <20241206202752.GCZ1NeSMYTZ4ZDcfGJ@fat_crate.local>
 <CAAH4kHb-qoBtUxPiNtFsBFFQdh+5mx2z0F32KrkFycgc-S45Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAH4kHb-qoBtUxPiNtFsBFFQdh+5mx2z0F32KrkFycgc-S45Rg@mail.gmail.com>

On Fri, Dec 06, 2024 at 04:27:40PM -0800, Dionna Amalie Glaze wrote:
> Given sev-guest requires heightened privileges, can we not assume a
> reasonable user space?

And that sev-guest driver runs in the guest so the worst that can happen is,
the guest gets killed for misbehaving. Oh well...

I guess that's ok.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

