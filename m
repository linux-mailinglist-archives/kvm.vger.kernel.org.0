Return-Path: <kvm+bounces-34707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C27A04A52
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 20:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C849188825D
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265FE1F63C4;
	Tue,  7 Jan 2025 19:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="P3yFFuPS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCF318C03B;
	Tue,  7 Jan 2025 19:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736278709; cv=none; b=gNsKieRu+tfC8AwttGnjSLAXttpgv5qwpk9L77bHhPUvOfAFG5MVnqiUVAectjIGd2PbLCsiQcBR0i/51DLKlRmWwm8dwjjW4nGVu8ZavBJLg6CaApz95F4vszJ1J6E4yelWtV2/HjobHSsyd2sBRRnU21EgpwlQNZ3NUxH8hs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736278709; c=relaxed/simple;
	bh=nFjbWHBRQAB+XZaLeZGymnWHgaXshNQHPnO8dCuWbMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKVhja/bAjl78it+Xdc2s5EK26KZTiFWFRuZBFEoZ+k0bT5YiW9qCUdoSCNqpFVDKtQc1Fo+/26HIpwgkjdyajotV4CvPvQai90i/2342/VIHX6uZ2QcWhAH/cAhKikcgX0k3gjg3CIr2IiKrp2LGlhxRdv8PxRBFGeglZGmRqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=P3yFFuPS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B255540E0266;
	Tue,  7 Jan 2025 19:38:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rV5L-LrXDQN7; Tue,  7 Jan 2025 19:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736278693; bh=SeEs4IzK5HSBKGK2piwSzg+l59MPiaVC9Qzgry/qOLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P3yFFuPSodOKP4ckgyhjQAh0YorwyMlsLw9Hu2CX9GfQSUUq8IdH/EkDxSsDyUTwU
	 EI+khNJmEorHHuC/91xuVd2zgLa4m3/ZRtEWeS+6Mtlq9Z1fFihnS2jUp7CRVjL6Hs
	 5PLfFrdsFeLpOID5rpNokkUwqpSf0JeeEQfzILuhSKEjV51Ryr7dr7AOTgMPQJUNvF
	 LF6nugWj0Z1uIZaA0NIMO35AFEh0wq1a1843ws3jPRSRbRSaIsJo73Jhl1qZsafXjN
	 t+Y+AdVKsj/p/PqdI9oJiYiePN0V7725ck4K8N3VoyNFR6Ixk2Vl3tN0k9uDkKlSxp
	 XrT3o/b6i8ve4scY3zXTHVT4wp7/0UtV6jukjuJM9y/ln7Cxd1wnF8fvDS3eROSZVY
	 m/0ESa/G6svYxPLIGeH4T+HrqJtRHA8g6bQmOAvWT+k+45P9J6sBdtq7uaZ9gAlabc
	 lcB/1lYSdn5+LzfxTKLSSwMrvWf3W+ilWw+5g8KEBZ48CvLnsROzN7Yd1lBqunpn5E
	 Gr0t76Qik2ZMNpW3YkSS+Dg6qrd7NLIK6dGJDAyl+6VYBIsbHyqAIufOoM49sR9rW1
	 BHJn1TGb4FYqbQOuKre9ie3hw+4HxSzm62DhJwqHteL2hMiClSrJikodqR2nOiGLze
	 0ciLfHmmTbusIi/mjWa4F3x0=
Received: from zn.tnic (p200300Ea971F9314329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C6BC940E0163;
	Tue,  7 Jan 2025 19:37:57 +0000 (UTC)
Date: Tue, 7 Jan 2025 20:37:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, francescolavra.fl@gmail.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
Message-ID: <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-13-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250106124633.1418972-13-nikunj@amd.com>

On Mon, Jan 06, 2025 at 06:16:32PM +0530, Nikunj A Dadhania wrote:
> Although the kernel switches over to stable TSC clocksource instead of
> PV clocksource, the scheduler still keeps on using PV clocks as the
> sched clock source. This is because KVM, Xen and VMWare, switch the
> paravirt sched clock handler in their init routines. HyperV is the
> only PV clock source that checks if the platform provides an invariant
> TSC and does not switch to PV sched clock.

So this below looks like some desperate hackery. Are you doing this because
kvm_sched_clock_init() does

	paravirt_set_sched_clock(kvm_sched_clock_read);

?

If so, why don't you simply prevent that on STSC guests?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

