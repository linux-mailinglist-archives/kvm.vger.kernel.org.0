Return-Path: <kvm+bounces-58657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 370E9B9A535
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:46:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 313C316070B
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D12B309F14;
	Wed, 24 Sep 2025 14:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hlbCyiLn"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4482305946;
	Wed, 24 Sep 2025 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758725180; cv=none; b=rLtvezNXDDa2zVuU503uOXG48Zmzd1HzZPajusvoXn3hly7YiOiVXl3BXrbqhs5TYdMVjZ6ijOrar77yaeekBoQ6aL/pNXBGXj8VRlRBvpbF90OSpi+dAvo06cZqezOh1YqT+8KldJvWCGRZtn18RM7BBgmhkDq1iGsGm7LczrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758725180; c=relaxed/simple;
	bh=7j2wBjwip+TbAK+W6ajd/duuMORmgbd8rAemzHv7TWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAh0VZpsXDCSk9mbBXruonXTmSdx6vsFfKLCEuqrebJL0zis/vxe7amijc4wYjFu5szKqRiHkwA3uSRbqoXwVB7VutBsyrpBbLKueOeajW0jw4eGsSi/HEHsDHOVPv6iMMhxlHbwnNciS1TLW9lzy1obb11+tuBzdbkB9RljGGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hlbCyiLn; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7783440E016D;
	Wed, 24 Sep 2025 14:46:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ztbmEybf6PuW; Wed, 24 Sep 2025 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758725164; bh=/wOPi68hxXKhWt7shz/orRmYHj1GN+HaaQnjO0mEpDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hlbCyiLnZDCTMwp9X0mRmfGCD8cwx9J+N9zs6B3z17F000I+s+qAIx/XYrMTMuPD5
	 CUqaIrGD0OY3QuXu7TFIv6exlu/9h1d7zm/X+j+CWnnEipxMP3kynpnp4SeHqKkJTX
	 J2znK49rhNuR09y9y+zB+xDRHORZHX8bnE3flj4ic1B9SrRdWi5Yj3qFBVAKkDYrub
	 vQ7/e6iDJROzNAhqMNGB7SXysNbAchEuSxZij2vS+k61s4pusHcm7wna8HE9EsWky4
	 C0AsCfcCr5tVH/F6gYvZitTlbFCiOByKS1MX7SNC9wWRShh2IQeX/Vvra5FCTLbuKM
	 0T8xr98aLeimH042GOqhkXvstgv0ZJF4b6LSUyKMTTfO3s/8VWpl9p8A/ItyCOYbnt
	 PVDH/VAJP/CSGValSKlkbdeHY3gCCdfjiU09nNAXatq4AMfFM4947zcJYJDtRuWkdV
	 r35UTo1IYMVcCv9/ypBDVhAQUVOYK+rkAdjWgZFEys4dLeo+JvHHUe//bfuDa5xhDq
	 9NZ/ym4eKdXVSj7E1Mble8pmu2E+mfBlajMum5wMHG3tuOx3yoNYZN+GK5S4rLgBoK
	 +J3fk26KUDAvegXaTcT1tUcx2FEc9Y7NzDesG57zykbvfnauweaolvHDB+PTqv75xp
	 SAa2rEiCsAsuRRfe21zFgKdE=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C429C40E016A;
	Wed, 24 Sep 2025 14:45:55 +0000 (UTC)
Date: Wed, 24 Sep 2025 16:45:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Aithal, Srikanth" <sraithal@amd.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Linux-Next Mailing List <linux-next@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
	Ashish Kalra <Ashish.Kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: AMD SNP guest kdump broken since linuxnext-20250908
Message-ID: <20250924144549.GAaNQEHc-wy0M_JTtJ@fat_crate.local>
References: <e8ace4cc-eb22-4117-b34d-16ecc1c8742d@amd.com>
 <aNPxLQBxUau-FWtj@google.com>
 <CAMj1kXHxUVowtCqBCKRE2_dv4TSUK6Kgwd46RzjjskAW8qYjHg@mail.gmail.com>
 <616d8f02-a4ea-4f9a-ad4f-8bcbc2ccc887@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <616d8f02-a4ea-4f9a-ad4f-8bcbc2ccc887@amd.com>

On Wed, Sep 24, 2025 at 08:13:35PM +0530, Aithal, Srikanth wrote:
> On 9/24/2025 7:45 PM, Ard Biesheuvel wrote:
> > Hi,
> > 
> > On Wed, 24 Sept 2025 at 15:25, Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > +Ard and Boris (and Tom for good measure)
> > > 
> > 
> > Thanks for the cc, and apologies for the breakage.
> > 
> > Does this help?
> > 
> > --- a/arch/x86/boot/startup/sev-startup.c
> > +++ b/arch/x86/boot/startup/sev-startup.c
> > @@ -44,7 +44,7 @@
> >   /* Include code shared with pre-decompression boot stage */
> >   #include "sev-shared.c"
> > 
> > -void __init
> > +void
> >   early_set_pages_state(unsigned long vaddr, unsigned long paddr,
> >                        unsigned long npages, const struct psc_desc *desc)
> >   {
> 
> Tested this patch on top of 6.17.0-rc7-next-20250923 [https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tag/?h=next-20250923].
> 
> This patch fixes the issue reported for the SNP guest type. It was also
> tested on [normal, SEV, SEV-ES] guest types, and kdump works fine on all.
> 
> Reported-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>

Cool, thanks for testing.

Ard, pls send a proper patch so that I can slap it ontop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

