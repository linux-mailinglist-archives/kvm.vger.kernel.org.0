Return-Path: <kvm+bounces-57424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 222E6B55504
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 18:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ED6F5C51D8
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615DD322763;
	Fri, 12 Sep 2025 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hHjXkSQG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DB230E83D;
	Fri, 12 Sep 2025 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757695823; cv=none; b=bYFaQSuL9+T8G9B6s+DlliLVp3PctKkY0vbXMdcGlggDkUUg9QynOcpQsX02yojtgse/M86xiIs8NhhlELV6wucPSVCJkhxJ1mr/QRhtC3FMfzW05QGdf773TlNTnR8bxyvnThLFUVcXbUIrThgeVe5+CcRvgHtMcyOh9RoPu4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757695823; c=relaxed/simple;
	bh=yhItCoXJETu41nDKJyPJnnHZE1jRo0RqhqoZPxSC4Ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iI3+rGT7opO5MmTHIwHKqoX0LJ0lvL6NstR3yKB51595QlhzfiuOSlEM7qaC9tJ74atkcjuUTzdQJzZTlNbco1cC3pgQhyxIsHzYTFZA5LC5QvqtgG69eL0if1xIn7Kye+Xn+8fjcMjbPIuA4gzSstXqkoOC8UZMfnlHr05+IpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hHjXkSQG; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1666640E0163;
	Fri, 12 Sep 2025 16:50:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4LbRX7pKTjxY; Fri, 12 Sep 2025 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757695814; bh=hiOFsXxPAZefUfcS4fOmUq2Dn7juaTFKBN2G4jHBWd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hHjXkSQGRW4+4xS8O8eCyYiukfFuBJplaNLGCSrJI/0kIzoVrfWnaIIrlxV6wYEQR
	 MAzqbos7zlZTJL9QWOmAv5APYv4Ic4WRezlL+CnmwGClw35CGGdkKPRspg53cx6Buw
	 IgdRO+45U9t2z9vL4dcZF5D37Ygeas5Ah/pPcha+OXODMmK/n5P2O1qvwHsFWpud9u
	 y+dyTWiV1P9wlQSpymQgp3PcbanYrMzg3B+lgd/XU/g3A2ErSPSPq3qtItWEkU/9LW
	 uwaaEJtC2TKP7ojtVB5A71rxwEPkHpv/he/EByqBFkUbtxGZ8/GZVlPhAfsK3iKePg
	 VRMf8lC2i+U6AFufmC2ts3u39O+2Kv8Vi84VM/eck+I2RpQMpSBigA02wZjfW3YrUC
	 MJl9BTt1w8QJgS/LYH13aXfRlwODdT2Go63OYQyI+NyA1fMaw6Z/ESuf9x16FXZ8YS
	 7fG80Z7tB3yxMKLf9GMxJdKu2yBG2+kzN3EHizKclcNwsl1X+X6OwSHeZLXiS81FZ3
	 yKPtVvtDlqjXbt4RXGax+IMDEYAzsOX6LnuK/hxy+KlkiMwvVcollhkevAKyCvC8//
	 AggUyLWFeQ3oDX6l7phjqkdLTj+ta36pislW92TYDBE+/X38MmMb4vmEuc7f7ZtH3k
	 E3XXA0yyFnpOODmdrU9dBuNo=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id AA0DB40E00DD;
	Fri, 12 Sep 2025 16:50:03 +0000 (UTC)
Date: Fri, 12 Sep 2025 18:49:57 +0200
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
Message-ID: <20250912164957.GCaMRPNf7P60wqBud9@fat_crate.local>
References: <20250612082233.3008318-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612082233.3008318-1-aik@amd.com>

On Thu, Jun 12, 2025 at 06:22:33PM +1000, Alexey Kardashevskiy wrote:
> QEMU Inter-VM Shared Memory (ivshmem) is designed to share a memory
> region between guest and host. The host creates a file, passes it to QEMU
> which it presents to the guest via PCI BAR#2. The guest userspace
> can map /sys/bus/pci/devices/0000:01:02.3/resource2(_wc) to use the region
> without having the guest driver for the device at all.
> 
> The problem with this, since it is a PCI resource, the PCI sysfs
> reasonably enforces:

Ok, so I read it up until now and can't continue because all I hear is a big
honking HACK alarm here!

Shared memory which is presented to a guest via PCI BAR?!?

Can it get any more ugly than this?

I hope I'm missing an important aspect here...

> diff --git a/drivers/pci/mmap.c b/drivers/pci/mmap.c
> index 8da3347a95c4..8495bee08fae 100644
> --- a/drivers/pci/mmap.c
> +++ b/drivers/pci/mmap.c
> @@ -35,6 +35,7 @@ int pci_mmap_resource_range(struct pci_dev *pdev, int bar,
>  	if (write_combine)
>  		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
>  	else
> +	else if (!(pci_resource_flags(pdev, bar) & IORESOURCE_CACHEABLE))
	^^^^^^

This can't build.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

