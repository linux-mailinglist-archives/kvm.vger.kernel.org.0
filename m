Return-Path: <kvm+bounces-57122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7209BB50497
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 19:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14C19368008
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 17:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A2835AAAD;
	Tue,  9 Sep 2025 17:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IrNWt2lx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497E2BEC28;
	Tue,  9 Sep 2025 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757439592; cv=none; b=sUm4bgH/LKgo4HLPw24wNhyObqSs0XWihWYA1NouN6lpZEMWq3sY2As33LvbOosI1vJTIRpj/cqIOJBDmLiVO2oN1eGlpWcipbQ8D+CedzBZcm+mwoY2R1lFztyc7mmbQSzHJBhRia7PGKFE473u1vykt1zitUj6C1rzzQM2Zas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757439592; c=relaxed/simple;
	bh=+n9pz43aS4hOhK8bXI2NJBf6dCltl6zFRfC8DVieOtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAvDgJt74ryt0c5RL3Ck9K5lqBMe7TaR/khwesOVI1zadTbozaLyrlgHEqMv3Pegcvk82crybvAaHTXAt6Bc8i8DexzgOI5UC4/Us7RZYaK4OQ4wRaV7dXm3BUtC+9AvdHiZQkYhrYc6LftUMpI9mMAjkBmtLzFsFAxVxKiP6tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IrNWt2lx; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C0FD540E015C;
	Tue,  9 Sep 2025 17:39:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dA0Od3MwFIK0; Tue,  9 Sep 2025 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757439579; bh=UTdzHdMhMiMBsjVrY3uR5aLdq+eZ3RE3QSN+QBRgISo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IrNWt2lx5gtduj5ozxb0AWdfv7JAmZGzqtdFog/80hQ2U5AWpx8i4FM4T4b6bHvF4
	 k1r/QOYkE6Sst/PimeQqZpzfabt3RlWeRWwKMsMQHUHJn7JxOtDJjwRTtggarlAP+p
	 aIwD0okNab5VAvcJvsF5NJRp4mMgYlFky9qUol96ZiuUGpN8NkHSH00eeYMtl54M4g
	 u823Rl95VxdQB9emFXoN0c2UpLQ1oCvP7/N1tapJflVB0iA3p/2ox+TY83BRty3Uns
	 yUBR6dOiQBxC4Mp6PbvX/CJl463FVO9QxLrMPB4gjxsdh5g3k7m+1Nq1KqQm3PACie
	 TgAd/xizsmzr9UTOJzJO5PTyYj/+UO4WS7kFlXnTLO2K1Y+syuIphJJ7OKp1bCUW1C
	 IrTETgZ1eXemYSc7fbgclRyn8oQvIStCNk/ps2P/mQmk0knasa4nLir3/0oFynvXJi
	 P1aMZoVxpfP/6/nrvYyLfZwOB/T8elWe3H7qEmEsfD98tORVH9EgviuMtaGYZIP7y/
	 XrJoxo6avCsyWm0Fq8DgWgW4xBSAcHdgSO5yAI9aMVBOfFo78dTO9K1cLdsDRnKgqC
	 BZIqYD4jwXDt1ChwFDNJtUEF5ZXKDyGAh59+L55B14kIRSpPPPmXAmYlu/JxpIVROs
	 uhqta4D7UQ6QNa6U6NJt525Y=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 305E940E01B0;
	Tue,  9 Sep 2025 17:38:57 +0000 (UTC)
Date: Tue, 9 Sep 2025 19:38:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Babu Moger <babu.moger@amd.com>, corbet@lwn.net,
	Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
	pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
	arnd@arndb.de, fvdl@google.com, seanjc@google.com,
	thomas.lendacky@amd.com, pawan.kumar.gupta@linux.intel.com,
	perry.yuan@amd.com, manali.shukla@amd.com, sohil.mehta@intel.com,
	xin@zytor.com, Neeraj.Upadhyay@amd.com, peterz@infradead.org,
	tiala@microsoft.com, mario.limonciello@amd.com,
	dapeng1.mi@linux.intel.com, michael.roth@amd.com,
	chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
	gautham.shenoy@amd.com
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
Message-ID: <20250909173850.GCaMBmKk6mrAP6IF4V@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
 <107058d3-9c2d-4cd4-beba-d65b7c6bd9a0@intel.com>
 <20250909161930.GBaMBTku_VgKUpTs2V@fat_crate.local>
 <0227e8ec-aa65-43e6-af07-e71f7a1edca2@intel.com>
 <aMBlAG1Pmtr2hHWN@agluck-desk3>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aMBlAG1Pmtr2hHWN@agluck-desk3>

On Tue, Sep 09, 2025 at 10:33:52AM -0700, Luck, Tony wrote:
> Conflicts in Babu's series were trivial.

Right, and considering how tip:x86/cache has only one patch, I might even
fast-forward it to -rc6 which will have Reinette's fix so we should be good.

At least that's the plan - we'll see.

> Fractionally more complex in my AET series (because some of the code touched
> by Reinette's patch moved to a whole new function. But still not hard.
> 
> Whole set (upstream + Reinette + Babu + Me) pushed here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git reinette-abmc-aet-wip

It doesn't hurt to test the different piles.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

