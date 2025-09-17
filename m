Return-Path: <kvm+bounces-57925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07EDFB815D1
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 20:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4060A1C25CB6
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 18:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E569301497;
	Wed, 17 Sep 2025 18:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BV2wsGOB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838CA26D4C4;
	Wed, 17 Sep 2025 18:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758134329; cv=none; b=XorcweviEGSsIh/ruCfXS04vcXTw69bN+JrNtUjxBlycJ/LBqRqGxgIFSvnXocl1e7GOKzVUYKMMwGBvFVurlFfeSj3b2q7VZMc+7LIwfVtaOiRAu52GwKRKUh9aVDE23vAGm+XKR4veeferjYeXZx/HjIcGF8Kn7Dx3xF9+TxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758134329; c=relaxed/simple;
	bh=TqE3A9l2moOt53Rhn4bLDHNCQxyxQLB0PPQkFw6K+aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgpky+HnV6/DL2ioCU1CVgPmvgOHUp/nD5EZTGkPiy7iBtgZdyYBh6Lzqxzqyh/TEHxkvmJpbt75iPqkkMEKbIFrouIq8srH9hqVP2qO6+c7w9K0p7sIdxRlv3XevIRmojwvtChg9XTSaAQTXpSFq7kBVXqnTo/coMFW/LkH2pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BV2wsGOB; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 132B940E01A3;
	Wed, 17 Sep 2025 18:38:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pXxv3NKnGAaa; Wed, 17 Sep 2025 18:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758134319; bh=lz6EW2NlhQyAUDO56c2jj9Z9w8ykktjlbRhP7nmvwnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BV2wsGOBWx4hOvrDqeKBl2gXzCktne4YARKbnnjBrPQ2wPq2rOwK8Eso1B2mtKBt8
	 bvAmijJl2FiJE9YATb/mkyN6sptLLotr0CBx+tELaPbYOjXUeFKEHeHY9tpute2bkh
	 PyHB8gGWTXFRwo6jeqn0c6RQMPbJFvUarwt9CKFFzd5Z6glyKWFnYqqjzENXmm+RpS
	 ZmygFc1OpgRk4pGGOzfg8I9b7kmnqai+nDbSHpsV2YzaNGDWLjla6ouFOvfci0heV8
	 KSwfCVpWWzK7ZGA3RaBx/py22mrCmhNiM3VVd9ZxeYoylWRQ24VV+rFVS7grOlZh23
	 eUHlqw9qyjdtcLWEcSYalx5rZY+kfUdtYg5OXtCofnUGhSm0f/j0MAKbi4GahxuUkX
	 AHnEQotXFjVQ112PqM0u63cqd1sPU1EL/DDd6DQwzzvRKeoxkNGhL3pwwmAXmI3kxD
	 6cSduszUliareX7IXQgtBZEadvY10iPOAhi/6JSlAZXcBb86duqnjJCxePGoEzXgOC
	 up7GEaeNnph8pShUgdGWbmM3WuAplXK5BGzzwEJfPr1JePz3yfNw5o/ocU4G4ojWvd
	 enQg9OSv77vZJOyJi6b2OD9vSO/ghSzL+M/zQBrenI1icUMkC0OxrNePAb4k/Uj5XI
	 VaJG4gBrf2GPs7nzQB7IrM10=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id DE51440E019E;
	Wed, 17 Sep 2025 18:38:27 +0000 (UTC)
Date: Wed, 17 Sep 2025 20:38:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Nikunj A. Dadhania" <nikunj@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] PCI: Add quirk to always map ivshmem as write-back
Message-ID: <20250917183821.GDaMsAHa7kVPBt5HAV@fat_crate.local>
References: <20250612082233.3008318-1-aik@amd.com>
 <20250912164957.GCaMRPNf7P60wqBud9@fat_crate.local>
 <c6e09d1e-c950-4ba7-8773-2062e0c62068@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c6e09d1e-c950-4ba7-8773-2062e0c62068@amd.com>

On Mon, Sep 15, 2025 at 05:43:33PM +1000, Alexey Kardashevskiy wrote:
> yeah, sadly, there is one - people are actually using it, for, like,
> a decade, and not exactly keen on changing those user space tools :) Hence
> "RFC".

Then this commit message needs a lot more explanation as it is something the
kernel should support apparently when running as a guest...

But then, if it has been used for a decade already, why do you need that quirk
now? No one has noticed in 10 years time...?

> > >   	else
> > > +	else if (!(pci_resource_flags(pdev, bar) & IORESOURCE_CACHEABLE))
> > 	^^^^^^
> > 
> > This can't build.
> 
> Why? Compiles and works just fine.

Here's a more detailed explanation:

https://lore.kernel.org/r/202506131608.QlkxUPnI-lkp@intel.com

You haven't replaced the "else" with "else if" but left it there.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

