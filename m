Return-Path: <kvm+bounces-15639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 243288AE3BE
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 13:22:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4001285A93
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 11:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFD0824AC;
	Tue, 23 Apr 2024 11:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GAU+fzu5"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD207BB0C;
	Tue, 23 Apr 2024 11:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713871312; cv=none; b=myMKONLWcYDF7novtTZ2riUJflca0CWmKZUvB6KKPA663tus+3K6uOhdTg2BwgzVJonqPLjFdwj8mTEcmIj9AeA7APNSrhKIHeSjlcgHzFcdIZ0EyUIuoKUOXSC3XCbf9i5szKsDPVqufoi84MH76LSyzS1ChdedkBaWSu+53Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713871312; c=relaxed/simple;
	bh=I/yn2f9dZbjw4OOqQPgtSPROIMMwqdF9qGkxsLuYvXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czIVZ3c7ZKRkdzTmoHCG7Iod2nt58bfCVV1hYVN9J+Rr+CCP8PRg9EMuM7gW4HfiWdZ6Py8PwJqJQmzy3D5gKA6XuI31uW92X3HAXeFa0AYTlZw0/XTA7lSC9/ywrFQ0gDoet2avMivGtLgTL5NEQEgTfvuvqFwPstnlOobNFPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GAU+fzu5; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E7BD540E0192;
	Tue, 23 Apr 2024 11:21:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HDbFvtKgaTYj; Tue, 23 Apr 2024 11:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713871304; bh=tHSmuxJux2alopCnOxYrmJ14nmb6gg9cT23R1aEXklM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GAU+fzu5158JAZFEgI3tUFZcQsnCyOaWCx5IcGmApelqqcOhCW0//CGtwzW8tZRUq
	 m2Qbt2aIO8LT4As9N0gA5GLF2YtBlteksvBWkKzOsf22K4yWt0Tj4XVAk5J3OA1jTM
	 NBTEKr95ErFoS96aWfgN50JFpvhs2YUrXfqXg4CU2trVXiKnp/nf62apliT8nARfW4
	 4UGT8M3SubzJXvznwyF1n8HtgvsQjw/Jqx+WgK3RjJSiG6ag0FOi4Pzd7pAy+6hsfW
	 Gt1Kue8yrXp6xnGyH78DTj3Z4irQYyoFE2fCzro6bbnaBRZTUprut7w8nWU9kbGiOX
	 J2RVBRHiTex+RDJ+ZnU8CfNKFxSS1fIybEZXp942FpWBc+7pMXffFNs4hJ8KF5zmhv
	 6W7cTDQ4+wHtNYa+igRo7s1VcCRsSB+T311yP+M3+XykFcfsbIokv1om3LRb1gNN03
	 ugcr4PqVbnRaIn7PgbDePKFlGDgrmAlNvP4xxUnfJQpJ+83YlSy5J9b8BcueqcIm4U
	 AZLjRFdHRjfA6t62MUyVtkigP7GiD9mWxE4lCAUINgNFJ78fzI2vVGOh+OqfHSRXXk
	 n5/k9rn9g27/YI1mi/q/pNXJ179dlUXewhmw+gQssNCB+0mkHey0SOKJbV1clHTLSv
	 25MczdI9wEgUpnW0SfmKQ/qw=
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 90EA140E00B2;
	Tue, 23 Apr 2024 11:21:33 +0000 (UTC)
Date: Tue, 23 Apr 2024 13:21:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 06/16] virt: sev-guest: Move SNP Guest command mutex
Message-ID: <20240423112128.GDZieZuKw8Ca2jiXw9@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-7-nikunj@amd.com>
 <20240422130012.GAZiZfXM5Z2yRvw7Cx@fat_crate.local>
 <6a7a8892-bb8d-4f03-a802-d7eee48045b5@amd.com>
 <20240423102829.GCZieNTcHyuAYMcRf5@fat_crate.local>
 <f8dbd58c-78da-4b3f-a79b-6693c04fb104@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f8dbd58c-78da-4b3f-a79b-6693c04fb104@amd.com>

On Tue, Apr 23, 2024 at 04:12:00PM +0530, Nikunj A. Dadhania wrote:
> Something like below ?
> 
> snp_guest_ioctl()
> -> get_report()/get_derived_key()/get_ext_report()
>   -> snp_send_guest_request()
>        snp_guest_cmd_lock();
>        ...
>        snp_guest_cmd_lock();
> 
> With this the cmd_lock will be private to sev.c and lock/unlock function
> doesn't need to be exported.

Yes, something like that.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

