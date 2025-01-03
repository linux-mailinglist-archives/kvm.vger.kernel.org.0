Return-Path: <kvm+bounces-34525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2324FA00905
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 13:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFEAB3A10D0
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 12:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C05AD1F9ECE;
	Fri,  3 Jan 2025 12:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UE0raoxV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E40417BB32;
	Fri,  3 Jan 2025 12:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735906015; cv=none; b=SsNKhPflJZFypktEsUysJKA8LdVkZ0qvvmIkp9ckTydlruepaSWKYYJ3ODoKk4MQk/eQ8qptoXnzjy77mwcEyfHmYSaSTcqKcK3+zZkKApvBH27oi9O4O6xxuiCr1anNxVGpmcrxAn1y/xZvjp1NjzYzyx4EeDq+gSFNTgfNBfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735906015; c=relaxed/simple;
	bh=1+ZENZ35MHANOaJm46OQhl93mrdvoUfHZlSCvHdc3X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyMk5SSpYrApkFQjg1DFIx5oHrvDcAbZvTP9fCEcXiu+8i1V61dPnSYEfdpBLG45uDsZbDdgusx6NYvocbgllUMZDWnqUCh+Rl8QJruSsv7s04xzLxaU10jJb0eLqLNT8psTVX5UI3nCEmUV58e1cm/e84bWKNbo8PYuoLXKYuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UE0raoxV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6492C40E021D;
	Fri,  3 Jan 2025 12:06:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id oX53FHeXWJlz; Fri,  3 Jan 2025 12:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735906007; bh=GF7MqXMHjglrzvnKq07eQV25mhpyMs/NyLbc+v2Pmi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UE0raoxVELM/CCUQH7YhD3CUN6MSWfht9KFYk5avkQKizrGAdyMk0qXFDgEkoNaku
	 HzTUvBZ6hdxJVOnPW3CN985xhmGKEx2PK7+84QQedQmrnjbzhg/YQC62Kt2ZPsJbY8
	 kxnKo09xVMAah3aUAVPl5cqv6chk6gvot7HftSFkUDyuutXFPoxTuEVVtNyxEODmdw
	 8epE34KkCDE7BNe+dO+jvfJgFa6NSUnhyc2zamRDWelnv94NCdvWuVGNxTj/d0HICb
	 voSn9gS2aDG2990M20SDFWAJ5kn6YW7ToFc6tH3luV1vkPcQf0eq75goPDoKSIRenu
	 O22k5+2KsnVBziWEJ4bf8WA70oijgB8Hg+52+38q4B5A76j1xT8ZhIIJxmqZY+S/Hi
	 1Kos0YcEeMC9HEkWQXNRwkKzNDI0ia4iJO9O0WMLJOTnAkXvCgpUnXRJj2/16OUy2T
	 RRERtq9blCngbQ8+CMFFp/gN/wtGxWpxrTuHNfzNrVW6mnIM9MGzzmbzo55z0xmItI
	 TjtGtiJ9iB8YEB/BuddhFV1kT0JH6ysCZiV8QuPONtC4BAhINQ7B8rKUpEdmuz6AVX
	 8lKGFD7LYazZ+CyP4ucwZGOBDU3Y0u/qszUyAZyU6gyv7ZrIcnlRA3HwgbWGzzE0Uj
	 2I44yAw/OSvp90PGSfhYZEhk=
Received: from zn.tnic (p200300eA971f93bA329C23FFfEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93ba:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 49F4840E01C5;
	Fri,  3 Jan 2025 12:06:33 +0000 (UTC)
Date: Fri, 3 Jan 2025 13:06:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v15 10/13] tsc: Upgrade TSC clocksource rating
Message-ID: <20250103120632.GCZ3fSyMiODH8-XBC4@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-11-nikunj@amd.com>
 <20241230113611.GKZ3KFq-Xm_5W40P2M@fat_crate.local>
 <984b7761-acf8-4275-9dcc-ca0539c2d922@amd.com>
 <20250102093237.GEZ3ZdNa-zuiyC9LUQ@fat_crate.local>
 <2139da61-d03e-49b3-9c7c-08c137bcf22c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2139da61-d03e-49b3-9c7c-08c137bcf22c@amd.com>

On Fri, Jan 03, 2025 at 03:39:56PM +0530, Nikunj A. Dadhania wrote:
> Right, let me limit this only to virtualized environments as part of 
> CONFIG_PARAVIRT.

That's not what you do below - you check whether you're running as a guest.

And that's not sufficient as I just said. I think the only somewhat reliable
thing you can do is when you're running as a STSC guest.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

