Return-Path: <kvm+bounces-57117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CF56B50260
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0269F1C61F4C
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 16:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E41352066;
	Tue,  9 Sep 2025 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kcmnc1GC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613C32676DE;
	Tue,  9 Sep 2025 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757434821; cv=none; b=uplQFROWHr+mFLRrwHgKzpR3tz1ibFTGQLRnucJk/nMbwSjDpdVKAdT9Yn0WHRsThdGLP5TchMbdCdoKZrgliwae6/arnmUm4p5cTgEdWN6Alq7uRDKg+eGYX0w5s9YFV35+VGF5h6X0XxUYbOleaShgE5n/7Ea5XPWUGByLcCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757434821; c=relaxed/simple;
	bh=DZrzh3YrIPCMm+fmI9j9QYQyXWS+KJz5vNz1swKkAZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M9JuMh07Zq2QNi+l2Jj1bJUm8qNQky8yRB+xawEmMq1+mOt2q3XH+F48iNzF8xeJk+6DxJQc0/YahQSQm3yngSY0y+kHnleAiJ7GAw5Tbw7K+vBhnd7sC1UhoFw5Y7GPd0aA3QBazZux8oclLd3dkUrzHextqpu3pn5jCK/f5TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kcmnc1GC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B178640E015C;
	Tue,  9 Sep 2025 16:20:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JWkyA880veGD; Tue,  9 Sep 2025 16:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757434814; bh=JXykKyxBLHPVAEdl8ppaWAN7HuPa8yfNHgz3CX8cwqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kcmnc1GCRz9SHgxzzrXJ63GQDbBvJcdzZtKmen8BLUqe2LJS+m9Br8OammWEpS0Ia
	 tElg+Gy16W/i17ZoG6U1z31PNB66l/wIg3qPgbLDniEYspZ3QAct1na/8mC1P3xjxG
	 q50ZN2hf1+L74xulicSh/PdfGXKR6LvOyPv39orm4N1BK0cfU9Bg4HyEljgMFzNIDT
	 dUNX8U6W53J9zF658boiBukyD7u2P3/mOqzATPSzQNdm1kaDAh8JBrwWkamEcGrYMr
	 LsurNyA91GCLYpMMr8g1Jxl65wECTdLNkvl0U3tYrZmcrbKxWul4NTfeSsWRQXcmvg
	 F0OwvmfByKCM4jx/x155nHi/2CDzhl6uqxGz9z1vKEQ3XijEi10Wu0Xqpm2iY6j/ip
	 AHPV3gaSxzwvSsEKJ52qWK3Xm/Ys6KXZenjmUKL3oyUAhp4DwWQdRozm1Ru1Hmldgv
	 wR35iE9/jibplztA8xr7rxtff48fsvEzPp1JUeDqPUFw/whH2ANUq1cl/1rLxN3LN6
	 i5e3CL9UB2kAj06nFmbA7bL2FJ+lfRO4aQHLtvTSq8B6GwAg3DykheyJEKTowehsnX
	 fhIvKU5e8/KPncZa0+gg585jgNOOldGsWDtSFN4XL7sP5FYZxo1454MdTuhk6xvxP8
	 9MpMWVGymPDe+d6nV1jkQcOo=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D60D140E015F;
	Tue,  9 Sep 2025 16:19:31 +0000 (UTC)
Date: Tue, 9 Sep 2025 18:19:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
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
Message-ID: <20250909161930.GBaMBTku_VgKUpTs2V@fat_crate.local>
References: <cover.1757108044.git.babu.moger@amd.com>
 <107058d3-9c2d-4cd4-beba-d65b7c6bd9a0@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <107058d3-9c2d-4cd4-beba-d65b7c6bd9a0@intel.com>

On Tue, Sep 09, 2025 at 09:03:13AM -0700, Reinette Chatre wrote:
> When I checked tip/master did not include x86/urgent yet but when it does (and
> tip/master thus includes x86/cache and x86/urgent), could you please
> merge your series on top of tip/master to ensure all conflicts can be resolved
> cleanly and ready to provide conflict resolutions to Boris if needed?

Thanks, just give it a test but no rebasing anymore - I'm going through the
set. If there are conflicts, we do enough patch tetris in tip to catch them
and handle them upfront - you guys don't have to worry about it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

