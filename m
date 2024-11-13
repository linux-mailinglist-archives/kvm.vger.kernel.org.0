Return-Path: <kvm+bounces-31775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94BF29C7824
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 17:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C9B41F24B6D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFBF15B987;
	Wed, 13 Nov 2024 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ULaUpO5D";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1bikosKo"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A22F41C92;
	Wed, 13 Nov 2024 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731513831; cv=none; b=oVGxnsV6VXX2w71hTtH2i5bXsfhOGwlroLdxur8Rs/BGR9Nz7pRsXH+8MyonL8HDzNiXMzIeTZP9hHcSdufOld/ucCux5DioEU5fftDwWAwtrL0HhN/HcrTWNA4ks9sl0bcOPBQzy1N7KvzkCZvjlkNPAqFSe77IOS80YWVOtgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731513831; c=relaxed/simple;
	bh=0rvZTMtJ3F13U4qn3mQOzLEvAdJLknVek+g7ayMUb44=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OSkUbHNqQdRftNof0QEYp1Eo9XGgExQWPXolYfFvK+J+OIrxpoyjKvaOsFRYpzJfrNLEZGSoo24KFvG7keoYOd0t6mamnb2YmDF376XahvTpxMChBZmwF6oaXDF6OghjgRA08/kloP8PMdIlikB6iOuXZCDOJhwB4oOqq4ZlqAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ULaUpO5D; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1bikosKo; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1731513828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mtC6I/wVh3bb76vb3t0LUdhFECXQ4KT3wwkegPBL5lI=;
	b=ULaUpO5DuZ2pMJ9QlEii8n5VH6LQrYmON5UKYjXr0uXw+BUKWIg3fJdbqxb7NYrD27WKbP
	MxbAa92xpSgi5CzUkOgozoczZ7yU3XwWuzeDxuX/evohe/FFAGHe4xC3fZza0Gwnx+RFdk
	r3zRuOySUPvmBBd8Nwz5eOvEW61/VGQlgm4svSukGmofp5FPDxCdXC5h22VbV6mxNSkHV/
	m23pCYVsbhhkRw7VJUH8Fcw4fSz3FJZzpDU5hwbyaB7IEGc7yd49G99fyDPYTLNeklt0g/
	2GqGG/XpRctO4FYQIGmbqt6TlNZN4ZgL+uLI8ZghI3jUtQKhCtWaG5SjTgvJvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1731513828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mtC6I/wVh3bb76vb3t0LUdhFECXQ4KT3wwkegPBL5lI=;
	b=1bikosKoqAqJ9LV5ympvkJTzAxL5PJTgiwLFysyriYVLswkkIvCB4AFn7UaMhQltW9CflT
	PspCYbjP3/ELnqDQ==
To: Philipp Stanner <pstanner@redhat.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, Basavaraj Natikar
 <basavaraj.natikar@amd.com>, Jiri Kosina <jikos@kernel.org>, Benjamin
 Tissoires <bentiss@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov <oakad@yahoo.com>,
 Sudarsana Kalluru <skalluru@marvell.com>, Manish Chopra
 <manishc@marvell.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rasesh Mody
 <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com, Igor Mitsyanko
 <imitsyanko@quantenna.com>, Sergey Matyukevich <geomatsi@gmail.com>, Kalle
 Valo <kvalo@kernel.org>, Sanjay R Mehta <sanju.mehta@amd.com>, Shyam
 Sundar S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>, Dave
 Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Alex Williamson
 <alex.williamson@redhat.com>, Juergen Gross <jgross@suse.com>, Stefano
 Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Philipp Stanner <pstanner@redhat.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Chen Ni
 <nichen@iscas.ac.cn>, Ricky Wu <ricky_wu@realtek.com>, Al Viro
 <viro@zeniv.linux.org.uk>, Breno Leitao <leitao@debian.org>, Kevin Tian
 <kevin.tian@intel.com>, Mostafa Saleh <smostafa@google.com>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kunwu Chan
 <chentao@kylinos.cn>, Ankit Agrawal <ankita@nvidia.com>, Christian Brauner
 <brauner@kernel.org>, Reinette Chatre <reinette.chatre@intel.com>, Eric
 Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 01/11] PCI: Prepare removing devres from pci_intx()
In-Reply-To: <20241113124158.22863-3-pstanner@redhat.com>
References: <20241113124158.22863-2-pstanner@redhat.com>
 <20241113124158.22863-3-pstanner@redhat.com>
Date: Wed, 13 Nov 2024 17:04:00 +0100
Message-ID: <87plmzktn3.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 13 2024 at 13:41, Philipp Stanner wrote:
> +/**
> + * pci_intx_unmanaged - enables/disables PCI INTx for device dev,
> + * unmanaged version
> + * @pdev: the PCI device to operate on
> + * @enable: boolean: whether to enable or disable PCI INTx

Except that the argument is of type int, which really should be type bool.

> + * Enables/disables PCI INTx for device @pdev
> + *
> + * This function behavios identically to pci_intx(), but is never managed with
> + * devres.

behavios?

> + */
> +void pci_intx_unmanaged(struct pci_dev *pdev, int enable)

I find this function name mildy confusing. This _unmanaged suffix is not
really telling me anything. And the reference that this behaves
identically to pci_intx() makes it even worse.

This function is about controlling the PCI INTX_DISABLE bit in the
PCI_COMMAND config word, right?

So naming it pci_intx_control() would make it entirely clear what this
is about, no?

Thanks,

        tglx

