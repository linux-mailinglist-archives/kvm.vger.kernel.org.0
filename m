Return-Path: <kvm+bounces-57496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 864BCB56059
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 12:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 642A91B215E5
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 10:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1051C2EC54C;
	Sat, 13 Sep 2025 10:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cz+p4A04"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B836926AA93;
	Sat, 13 Sep 2025 10:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757760969; cv=none; b=K9V7s9ahZ7HQWS+jQjtmXetuRmdKh8sGPYkw5xU3yMHNUAqUE9TdINw4bQrpCCM2gu0NIut1Coa+SLSvLdI4KJ3/y+kAWU58bAx+FBpIiCrqvk4urKjvRlhIg/lRCGqsVPSip6QKtwB9vp9P2Tiylo+4wPl8ys9cuRjF6U7ECN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757760969; c=relaxed/simple;
	bh=StEO0JBxtKDi5amum5PC55LRvUuZuDitKv2SKv0kuaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ukh1LBhd9CpW5eB18JjN9U1ddGE+1dEvKFTBh6RqiAPU0/qybsQFJELthRSegAFvkf6h+VqSh5+svIk3q36MFFFEXz7XM3ze54DcbnemqwSQls0NxWRX0SvoWrgZhRtEV8umy3hcT9Cb+kvORJFJ6WJAVf+JI8idH/blGq3C2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cz+p4A04; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E27ED40E00DE;
	Sat, 13 Sep 2025 10:56:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Zvm0Fs6JS_mw; Sat, 13 Sep 2025 10:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757760958; bh=336e6boM42p2fnauyw2slmKIpvfDhufaTO4hMI5mBnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cz+p4A04BVqH5BbXIWSMPwE8GxsN0+ojBdJxYyXUBlt7LFdEGfzmBXfXpJKxigdhy
	 XT2CXTV2GlucEzz3tYerXBL85HUBRGyvQL64jIevoIHcz9JNYF5FHCdR5Vm89XJOfS
	 z9R1jZs/7cfWfCKXNlyR70sMuxFeLgGQjsXEXXzBfIRHDt9+Ls2yIuqvhURa51hzVZ
	 gCgrJgdXtCIVVAmJ8RLM+R3AWokKt+r4+35lkgwkE3vSPYhU9XxaiJYOnm2nysyiZK
	 0PMUZOD/xNEYwGbaZuD7gDX0RaOgQcJcabmdwfVZTfmcyBQ0GYM+WMoV9BduIYqRQK
	 p7SWgNoLIfhBvKuCaeJMAGKWrzB7WXCZu3mRoZaNZl+/y+EhZVmc6eq634TuSp5wj2
	 hPCLBePRlff3VzWS2svPFLXPXHzkjRrm+QjFMVsP0FBEgCgW1aehRi4nVheGP5cAdc
	 7K/UdrRgmVuB1hguGq9tExcNM6iNTQeujwYq8fjPVaZmYvWfoiKy6nrkldcjB2TZgv
	 IrBCbr7FyT3C+JGsoJRXTMyHcFpwoJEXukeAX3HQuXa/lYRJ3UQGCUgUDCN12ZIoHp
	 7n+EXfMW8Ij3/8+sN+WjIEGgrbq5g6tJn3GHxcAxmoTFMiwHQKR0oUljatnlbpJXhv
	 fcw+boHoYrpPDMRMjzITBxYI=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 8D1F940E015C;
	Sat, 13 Sep 2025 10:55:38 +0000 (UTC)
Date: Sat, 13 Sep 2025 12:55:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: herbert@gondor.apana.org.au
Cc: Sean Christopherson <seanjc@google.com>,
	Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
	nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
	john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
Message-ID: <20250913105528.GAaMVNoJ1_Qwq8cfos@fat_crate.local>
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
 <20250912155852.GBaMRDPEhr2hbAXavs@fat_crate.local>
 <aMRnxb68UTzId7zz@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aMRnxb68UTzId7zz@google.com>

On Fri, Sep 12, 2025 at 11:34:45AM -0700, Sean Christopherson wrote:
> On Fri, Sep 12, 2025, Borislav Petkov wrote:
> > On Wed, Sep 10, 2025 at 10:55:24PM +0000, Ashish Kalra wrote:
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > 
> > > When leaking certain page types, such as Hypervisor Fixed (HV_FIXED)
> > > pages, it does not make sense to dump RMP contents for the 2MB range of
> > > the page(s) being leaked. In the case of HV_FIXED pages, this is not an
> > > error situation where the surrounding 2MB page RMP entries can provide
> > > debug information.
> > > 
> > > Add new __snp_leak_pages() API with dump_rmp bool parameter to support
> > > continue adding pages to the snp_leaked_pages_list but not issue
> > > dump_rmpentry().
> > > 
> > > Make snp_leak_pages() a wrapper for the common case which also allows
> > > existing users to continue to dump RMP entries.
> > > 
> > > Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > ---
> > >  arch/x86/include/asm/sev.h | 8 +++++++-
> > >  arch/x86/virt/svm/sev.c    | 7 ++++---
> > >  2 files changed, 11 insertions(+), 4 deletions(-)
> > 
> > Sean, lemme know if I should carry this through tip.
> 
> Take them through tip, but the stubs mess in sev.h really needs to be cleaned up
> (doesn't have to block this series, but should be done sooner than later).

Right, I guess Tom's on that one...

As to the other two:

https://lore.kernel.org/r/e7807012187bdda8d76ab408b87f15631461993d.1757543774.git.ashish.kalra@amd.com
https://lore.kernel.org/r/7be1accd4c0968fe04d6efe6ebb0185d77bed129.1757543774.git.ashish.kalra@amd.com

Herbert, how do you want to proceed here?

Do you want me to give you an immutable branch with the first patch and you
can base the other two ontop or should I carry all three through tip?

Yeah, it is time for patch tetris again... :-P

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

