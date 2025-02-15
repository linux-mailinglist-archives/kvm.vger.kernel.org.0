Return-Path: <kvm+bounces-38276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DD5A36CCA
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 10:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA0091891A2A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 09:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC2E19DFA5;
	Sat, 15 Feb 2025 09:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HLkIVfZ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB95802;
	Sat, 15 Feb 2025 09:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739610958; cv=none; b=fF+E4sMIVRZt30vXs1z71E3KS0lGKPCbX69cInn9y62aSWsdNJI36U0MYyYndq6fCpnUiTAlAd83Zdn95STIQGuXBDmiqLGKvl7Wm6pgky8QQGYyRaJPV7thn7/iEMeFGWRRwmMNcl7mlFmTR8c/9itUNmL/Cik7Pk6ptzrneYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739610958; c=relaxed/simple;
	bh=YsUYvy8hAImOx4jZz20N8WQ4g8+bYbqphA9Y0Vr7j18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuTSsPxiprvvOI5Omol1HIarofSo1trZUYrMulVIEwtUiJYTrnjeDgvbM1hBNXEgNq47P0rgm2hga9VpNy3LECrJnuTBDMvCRqDKgIf/ElD9Biltvmgv42rLh6ssl9nZVaD0DryTMe6q1479djdqzbAbPEKCLdPkYDLEOo99BXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HLkIVfZ0; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8F3A740E016A;
	Sat, 15 Feb 2025 09:15:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z3-Z8iVj-auL; Sat, 15 Feb 2025 09:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739610945; bh=OB+tdRVB1FIrp8S+jWnd7Rhad1CcgG6e0AvI5zTQmEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HLkIVfZ0ZwT7308toasPmNWQLTs94svqWUFUo175FPskKv/CDu3w4pzkp1s6X0CXB
	 0by7unBOT1pWu/FuPkgFWojKaUqP+XFSPe5odHIhTnHSC9bIZxEn5fMM/c2CiBtUSi
	 QSfX04n5WUaL+GXsanuj/GOTvGq3nfjk01LQWy1sHiI21dXRO+9ppE6bGJZ0BiJobU
	 cmYbHtUSsnUabaMZUxEHsEsYsPJFPBn18r68uLAYNOP1bJtH0Gaz8WPlPB7NwqfK0K
	 L5NocX3vLO/ux6Zp4aPK527LhqHap+iAew5K+SsnMB4w2Urb98jUANQvP1LvnSGgNb
	 DjqdbBKyTFNI0B/FvCnwWRxFaV1X8TbzsgSuHydVOJIJ1uMjrq5RP6ZYDJQ2aICjZ+
	 1QqPBWuIyvRMxzWjj5x7bMXKqWvI03lpAQg/ps6Npxa7sYj9UYrKis2gsSsaobGeli
	 ikENHzx1MO39ezEDrmT9vwj1HbMs9PtSQKsmJvWkP5FhLoi0/G4O278nhNJZ8eVZxV
	 cdT9/FPHGuLaGbVb63qIJD9vSj7sj4Okl4/N0pGPDi4gwuXnsCgBQxCPf17amv0Nu2
	 ikDxUMqKaOiKBNyMRcID9KzVXOI/6zcpJs9l25dO5cEzooQC6PEY2kFFoFKyLLdjO7
	 s0PurcHvOp6lkAZOTORSM88w=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3421740E0028;
	Sat, 15 Feb 2025 09:15:34 +0000 (UTC)
Date: Sat, 15 Feb 2025 10:15:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Patrick Bellasi <derkling@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250215091527.GAZ7BbL2UfeJ0_52ib@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <Z6_mY3a_FH-Zw4MC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z6_mY3a_FH-Zw4MC@google.com>

On Sat, Feb 15, 2025 at 12:57:07AM +0000, Yosry Ahmed wrote:
> Should this patch (and the two previously merged patches) be backported
> to stable? I noticed they did not have CC:stable.

Because a stable backport would require manual backporting, depending on where
it goes. And Brendan, Patrick or I are willing to do that - it's a question of
who gets there first. :-)

And folks, whoever wants to backport, pls tell the others so that we don't
duplicate work.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

