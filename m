Return-Path: <kvm+bounces-30181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F16DE9B7C0C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B76C8281B67
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 13:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E041A072C;
	Thu, 31 Oct 2024 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="yoCNsTYA";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="tnv8I/cO"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C001F19EEC0;
	Thu, 31 Oct 2024 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730382307; cv=none; b=PO4c+rpmqDEgR8okCGeIDGu7cg7rnsGaDYDVIgQSozUWTcH5kVYg55ZuEVZ0cP1TI8KBvIkiGJj5U5xaxQ64rIfTC4ajjhKKnR+fpk/DZwE9p4LU5bS/aSUve2t/y4AQhBTBZ38A1tFlpnXj8UjQFf6OiOzXvOCCwcpipiRRI9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730382307; c=relaxed/simple;
	bh=SyiKIQDNVRhU2dYWC7KpnbYi2u+O8MurNHCaNdwZdao=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Jysb6iqz23lag5IlsmQUOz7/rXCj016mYBLVGtEpVA8Wj6unrULdgSB0vBvxgouO4TqAm4uM9ZpDYRPj8dKhlzEMYggkvKDY1hM89DZNMJANo+GWYNUjsnfqRcSuZ+oL+gmrex/V1utaUwUkf/cTdPbtN++bMDPCwmScGdR1Osc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=yoCNsTYA; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=tnv8I/cO; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1730382304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eEO4GUXIuQTW+sY+/WiYJk1PjJtbzNP/nS0HeFEOI6A=;
	b=yoCNsTYAFyyFk5pGSYkD1piEjw8MOo53vDo2YkXW02EDMHDlaOfzFQIBgvw62YeQnStj0R
	qkY5Ky9UOyVC1w3OVKBzXSwejc99F3AGpf5zUOBwsDyJSVfTnZWMWet1KTbQJOfOLCVNhV
	cy7TVNur5FmVBVRh+KOvfZ/CNyLR8SNv9i7yqNqrq5kD5xMENaMe0V6OpvokmfW/Ob9QM/
	5un8Zwrlq9QRR3JPr7QuSkLpK98KMG43mFh0DMvW9yQHq+GuztrjGuFKrW+m4h5GhCy/Ac
	kp1SwmKR/ksHOOv6R90FQYE4O+PRPlazUvlT9/6ThYdYhTcp0TO69X6RMhaPYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1730382304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eEO4GUXIuQTW+sY+/WiYJk1PjJtbzNP/nS0HeFEOI6A=;
	b=tnv8I/cOG9O9Bmuz6A4PtC/V6UOPd//2+oyqsIznzxGGzis4KZd76yQ3kxGFswkP13hKpV
	nr8ioE+FYr3wlOBw==
To: Philipp Stanner <pstanner@redhat.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, Sergey Shtylyov
 <s.shtylyov@omp.ru>, Basavaraj Natikar <basavaraj.natikar@amd.com>, Jiri
 Kosina <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Alex Dubov <oakad@yahoo.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Manish Chopra <manishc@marvell.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rasesh Mody
 <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com, Igor Mitsyanko
 <imitsyanko@quantenna.com>, Sergey Matyukevich <geomatsi@gmail.com>, Kalle
 Valo <kvalo@kernel.org>, Sanjay R Mehta <sanju.mehta@amd.com>, Shyam
 Sundar S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>, Dave
 Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Alex Williamson
 <alex.williamson@redhat.com>, Juergen Gross <jgross@suse.com>, Stefano
 Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Jaroslav Kysela <perex@perex.cz>, Takashi
 Iwai <tiwai@suse.com>, Chen Ni <nichen@iscas.ac.cn>, Mario Limonciello
 <mario.limonciello@amd.com>, Philipp Stanner <pstanner@redhat.com>, Ricky
 Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>, Breno Leitao
 <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>, Ilpo =?utf-8?Q?J?=
 =?utf-8?Q?=C3=A4rvinen?=
 <ilpo.jarvinen@linux.intel.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Mostafa Saleh <smostafa@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Christian
 Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, Eric
 Auger <eric.auger@redhat.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>, Marek
 =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
 Pierre-Louis
 Bossart <pierre-louis.bossart@linux.dev>, Peter Ujfalusi
 <peter.ujfalusi@linux.intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Kai Vehmanen
 <kai.vehmanen@linux.intel.com>, Rui Salvaterra <rsalvaterra@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 01/13] PCI: Prepare removing devres from pci_intx()
In-Reply-To: <20241015185124.64726-2-pstanner@redhat.com>
References: <20241015185124.64726-1-pstanner@redhat.com>
 <20241015185124.64726-2-pstanner@redhat.com>
Date: Thu, 31 Oct 2024 14:45:03 +0100
Message-ID: <87cyjgwfmo.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Oct 15 2024 at 20:51, Philipp Stanner wrote:
> +/**
> + * pci_intx - enables/disables PCI INTx for device dev, unmanaged version

mismatch vs. actual function name.

> + * @pdev: the PCI device to operate on
> + * @enable: boolean: whether to enable or disable PCI INTx
> + *
> + * Enables/disables PCI INTx for device @pdev
> + *
> + * This function behavios identically to pci_intx(), but is never managed with
> + * devres.
> + */
> +void pci_intx_unmanaged(struct pci_dev *pdev, int enable)

This is a misnomer. The function controls the INTX_DISABLE bit of a
PCI device. Something like this:

void __pci_intx_control()
{
}

static inline void pci_intx_enable(d)
{
        __pci_intx_control(d, true);
}

.....

makes it entirely clear what this is about.

Hmm?

Thanks,

        tglx

