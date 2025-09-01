Return-Path: <kvm+bounces-56453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58131B3E69A
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 570B53A4B1A
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 575CC2F069D;
	Mon,  1 Sep 2025 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="KqyxXN49"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D620B2F0C6A;
	Mon,  1 Sep 2025 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756735491; cv=none; b=clqP2wSdvMJeXsWCA1lpdbcTRoVRJ5sC5EZ99IePmF+qcCfWe2GbiXxWg7S2pLy9JF3923n95MYuTIXXLRYIx3OSZHx1+LNwG47cm/udkAw38y307CH6SxlDDmjNjuO4IP3OX/TyXhoOw4+8DQsjAQfdfxKlUVXtprDM1L7Yz6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756735491; c=relaxed/simple;
	bh=MBAxppJ4Yxipfgrq9hINNhoETtapRmUwYX9DHjy9cNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rn9xtc1TRlq1XQgjVFYnnpziZhHlnmyNBAJpNcUzMLkcmUzo/sfcJ/7lRudTdahwoZQamjbvWIt5qQ0oc/AxYRtaCl+ZPvGea/0XfgDfZsORwy+7QrLBMY+eO9sWL45TdLwY7nvBxmTTdarXtDLud7Z/eIwSMuNM6mpn1mMkhu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=KqyxXN49; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 66DF340E01A3;
	Mon,  1 Sep 2025 14:04:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DAawho8N4MkJ; Mon,  1 Sep 2025 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756735482; bh=9OkTfI5wEVdDhw+V3HGr4K3GrOFekJwQhvaU0g8yFRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqyxXN49ErtrMYQF9qPuCeTxGSzJHQgewRH6zhEnjZjmmVYPCcAns4N0UMe25WYCf
	 NxwAUAh8iD2P0mCb8cv4X2oKQuGKkBlXy2eH/oUKR5/Gi3gc2qiG1TqBkrpBZcKCeP
	 3/f1BxLXzqjCqu92+SrC8J8M/HUgBm9sEnQzYKGmGn8rO5MG+QYXtu9+WJ+eX2zbEu
	 QHSY9GreTEF/5z31RHxeblndGIeNVQ3nloJQkcxLpsyadt3ntu2t25ANubzNcSlRVB
	 6ScwRTvqlkUQohVTFqtWFgsti848JcphihZiuRdKF4Ub3cLelMZNwv9Pz3a2Gvag2d
	 ncRnEEszasDOTMJcw9575YprL2UvrHse1wEEyoCB1bQBoJI3GUY4EwtJyAfT4q18sa
	 A51pFNn11DSwD0L8Eo9ipIxmUUFAN/slq4UceHwbkvwK8PTZQyL156uzvAmH66gC8c
	 SaWDO4jmXkCmF1cMHM65Ihb/I9Bh4107f2ztiklE0lNfznWodoSyVUMH/gHzMmeZQV
	 B4QMpi2QJdpAbECPWZbuNIToWiUQuxViXJcPy+84ctXb/PXMC9/Gc9pRAbpYifo8kr
	 UXlkSPl71iWc8WMbU07gCznpmNZBbu//+fy1lTilo0Cd1GEHbR0HCNCDjihsMGUwAN
	 O5jEdHh8fifoUbyr4dhf78Uo=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id B1F7440E01A2;
	Mon,  1 Sep 2025 14:04:19 +0000 (UTC)
Date: Mon, 1 Sep 2025 16:04:18 +0200
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
	Tom Lendacky <thomas.lendacky@amd.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Naveen N Rao <naveen@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/4] x86/cpu/topology: Always try
 cpu_parse_topology_ext() on AMD/Hygon
Message-ID: <20250901140418.GDaLWn4iNqlpgw75_y@fat_crate.local>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
 <20250825075732.10694-3-kprateek.nayak@amd.com>
 <20250830171921.GAaLMymVpsFhjWtylo@fat_crate.local>
 <939c23b3-2a43-4083-985c-ab0b16a3c452@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <939c23b3-2a43-4083-985c-ab0b16a3c452@amd.com>

On Mon, Sep 01, 2025 at 09:51:53AM +0530, K Prateek Nayak wrote:
> Ack! Does "has_xtopology" sound good or should we go for something more
> explicit like "has_xtopology_0x26_0xb"?

has_xtopology with a comment above it to explicitly state what it means,
sounds good.

> Patch 3 will get rid of that "has_topoext" argument in parse_8000_001e()
> entirely so I'll rename the local variable here and use the subsequent
> cleanup for parse_8000_001e().

Ok.

So pls send this one now so that I can queue it as an urgent fix and then the
cleanups can go ontop later.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

