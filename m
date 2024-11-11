Return-Path: <kvm+bounces-31453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C1E39C3D5B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D4641F25F7C
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF344198A1B;
	Mon, 11 Nov 2024 11:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VIpH+amj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39519158A09;
	Mon, 11 Nov 2024 11:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731324674; cv=none; b=ciVZaJKswpceSOGJtsoQRHIwJ76JWyNQQE3Wbznthq/0UgisqIhihcNG7zw+sPfAYo75xojyO7V1fuj0UyKhSelg33tqhIPIjHHkAsA+IwzXUQ6pL29pWICV5VamJ8aSprMUnBnWw+h2AdiaGJbYM6/x/mLjHlL/7x5JFu0h4UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731324674; c=relaxed/simple;
	bh=vMg2pCpu5IA+RdZRhOZ9ibA+Z8DTNXF32ji+f7AER5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCTkQjQMaW/mTP7XbhIxmTrhNSaNHFMMd4s2JPCSLxwUKTSov5hOUPEM5mASjp71LLm8WzABNcwz8tt14vE/w7kED35UCFsfBJKzSOKV5mrzSbNwAVx93ouQ6PMtfnkmG8afs2I9FHTT5Wi1LKS1ix8020SQ4pW+Sinn4t06E6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VIpH+amj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1D3AA40E0169;
	Mon, 11 Nov 2024 11:31:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id q4FdW_DnE7aN; Mon, 11 Nov 2024 11:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731324666; bh=1i35xRLuOIMeKe4gXXpoFv7Vf3wLVDEnHnT2V6tVKlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIpH+amj7V0qfR/YXFVUS9HIsM3T2yx7hX1gSkrvY03EZLd30SxX9T4xk5kpkdYOJ
	 KkSfU6GuFRjmE1uGtKscGwZKPzogh2cRs2r1qlqRymQ/scllVHyjSRSyGLnX7p14lZ
	 APjgDS+y0xfTU02SHMMF+OqfDDucAYub1uU4GUeLEu6eIIxOeOiSRS6UviTFpS6Neo
	 ukaGovLtnR6eaqevdRS58C4PwsUrC1cTLXowe2As++pQHyVRc0ksDbW2bmbq+tvx48
	 pm/qtlcDIlphpBwjNJFEjTl2Zxe91v3axvDoJVcypxKOiSOEN/ZcYGp3v7RVrQuIRe
	 ORcr2Eck4zVmTAT6wQyoH6L3WV2neqk5RukklpRYV73AV1751vFlyZxji34ixHsKQl
	 rs1KqJL4kf9/Sx+8gqCW/JnOcRvug7nnzPAP3bXXsQYHC5+1HhJWjueYH4qJbx335X
	 FEE4ZJSRyrdvXo8yE5andkoGprv42+gspXHvy5d0xmcYfFUP6iWwh6e1rApdsfwWx1
	 lgndkLJ/cQHnmU48qxaP9phK1vsnYQ1Amaeg7pmGw0fZl/dqLVcTUqVRssSeQlbQg9
	 9k7gfsgUbZWADg8YKi58s8tDx2XHpWPBqsrOjr9kDT3JETLBgxnmQGebENXGTctZae
	 4ulUSf+M/jyYnd4s7l+qS+GQ=
Received: from zn.tnic (p200300ea973a31c3329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31c3:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 074BD40E0028;
	Mon, 11 Nov 2024 11:30:54 +0000 (UTC)
Date: Mon, 11 Nov 2024 12:30:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241111113054.GAZzHq7m-HqMz9Vqiv@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
 <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
 <4115f048-5032-8849-bb92-bdc79fc5a741@amd.com>
 <20241111105152.GBZzHhyL4EkqJ5z84X@fat_crate.local>
 <df1da11b-6413-8198-1bb0-587212942dbc@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <df1da11b-6413-8198-1bb0-587212942dbc@amd.com>

On Mon, Nov 11, 2024 at 04:53:30PM +0530, Nikunj A. Dadhania wrote:
> When snp_msg_alloc() is called by the sev-guest driver, secrets will
> be reinitialized and buffers will be re-allocated, leaking memory
> allocated during snp_get_tsc_info()::snp_msg_alloc(). 

Huh?

How do you leak memory when you clear all buffers before that?!?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

