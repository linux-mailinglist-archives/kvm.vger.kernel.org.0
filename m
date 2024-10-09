Return-Path: <kvm+bounces-28227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18FD79967CB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 12:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A202B26E21
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE57191499;
	Wed,  9 Oct 2024 10:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWiKfluC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B5E19004B
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 10:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471352; cv=none; b=gp3UQP+5EEdQ9Tl3mQ+Fci678VhUO+yoGf+22BQri7yiUs6Q8O4GO7fhKpg/6qte9/Za27DpYJZEIbaHXSgLfOYx2Wl2sCQDTYvueVIyRUADeB55RxlFoS45mfepBYiOHnwDdKwPI86lHDoWq93ogJ+fRINVE3JQ5ynbdPDoIV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471352; c=relaxed/simple;
	bh=QInJooaDPemMhvMB9jWGaofNM3nwEDgzSTZ4ktw/WnQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IgoXAJPasi47X2lBQKzwYdyn6X/xGixPEMWFUASezYcIdHHUs8TB5VMZ1QAR9TMOik4+kIQ4Nlp8HCM0tR4vP0U/kgt1B89ZYXoxFacf7/wdaJsZ5OOLBuSmiFB+sPZdfziyD2oYqD9jVDeUUuOOL3KxFmJhEFQFbY9oGpycWrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VWiKfluC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728471350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AcZlzWYyN8UAcZA3DQr50bLqr6cMtcb31GCRb120JWk=;
	b=VWiKfluC+PDvqIK7eqlOxQOPpAbtrhjqsX1NN6+GRBu9h53GRDwdPCD0kzxY9Zzyk8KmRc
	zsUjXTXrX6BCgVbFXrRYJ4E9shFpOtEiJD0QOKkN6wW1xaOZC8RboqUFiGiFUdn13w16RT
	PLqOji5Fr+/sVIaEgn4xmFqCBjJ0wcU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-mQKiu7O3NgmUdvVJ1WywKQ-1; Wed, 09 Oct 2024 06:55:49 -0400
X-MC-Unique: mQKiu7O3NgmUdvVJ1WywKQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2e293238575so1284149a91.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 03:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728471348; x=1729076148;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AcZlzWYyN8UAcZA3DQr50bLqr6cMtcb31GCRb120JWk=;
        b=WXLtvbe0fP4ejMr4L/2v4vhcoPJQ5KmOcvsrcQ02XrE5aTGKa/lPNPkGFFYcEojyUU
         tezEZxtTc3KFQ3YSZaAEBAYj07up7NgZOGl02PZ8YkuQNdtw4ldX20qeUassT86zx9An
         3yPfWCVNJfSpARfToWv0/V9wccDfCYaKfe/v3K+hnn3xvpnYpKsmIlZqQJK1VVdCS+gY
         IGUFbylCPxaBv+Idg5Aa5o88iAapjYe681nULJ65Eh+JmzPzavqwk9XOCeSllIQaVP5D
         UdYgnWkMdWqOiaOA7MZUw39R33791J934sbUWHpgRnRHxsSV8y8YjExhTDRnmv9yJjRj
         3KIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ6n42+u7yYQgWqKYOacXxj71YSh5WuEaRUwLc2G0gJEOTbDNs0jfQfchP0Em9iESsXkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzPOuFEcXA6XP2JYtWsqfgi0tj97sJaovCJrWcAsWeaatrlIkN
	o9urpaLX0m/OIZmty9h3NPJnWtO5bxaPdYtckp9n4UAItGRb16sibBQeon21xiYs4j3MT8y/4Wy
	QeFOIwzfylHgy0ot7riIYDUlXUHSDq3Rc4TwUdKrAFURAX52gnA==
X-Received: by 2002:a17:90b:28c7:b0:2e2:b21b:2247 with SMTP id 98e67ed59e1d1-2e2b21b2322mr933617a91.27.1728471348043;
        Wed, 09 Oct 2024 03:55:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVV2txsjAP9qEDQxARdGlpHpBZTxsJXvis+5//ouL/mBT0m0DdnB1NIlYvykMWn/28LY/iUQ==
X-Received: by 2002:a17:90b:28c7:b0:2e2:b21b:2247 with SMTP id 98e67ed59e1d1-2e2b21b2322mr933536a91.27.1728471347607;
        Wed, 09 Oct 2024 03:55:47 -0700 (PDT)
Received: from dhcp-64-16.muc.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e2a365cb84sm1341556a91.0.2024.10.09.03.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 03:55:46 -0700 (PDT)
Message-ID: <d6a78b6a3dec3e2371cced1382cd83d7dcf37426.camel@redhat.com>
Subject: Re: [RFC PATCH 09/13] ata: Use always-managed version of pci_intx()
From: Philipp Stanner <pstanner@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 Sergey Shtylyov <s.shtylyov@omp.ru>, Basavaraj Natikar
 <basavaraj.natikar@amd.com>, Jiri Kosina <jikos@kernel.org>,  Benjamin
 Tissoires <bentiss@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov <oakad@yahoo.com>,
 Sudarsana Kalluru <skalluru@marvell.com>, Manish Chopra
 <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Rasesh Mody <rmody@marvell.com>,
 GR-Linux-NIC-Dev@marvell.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Sanjay R Mehta <sanju.mehta@amd.com>, Shyam Sundar S K
 <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>, Dave Jiang
 <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>, Bjorn Helgaas
 <bhelgaas@google.com>, Alex Williamson <alex.williamson@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Jaroslav Kysela <perex@perex.cz>, Takashi
 Iwai <tiwai@suse.com>, Mario Limonciello <mario.limonciello@amd.com>, Chen
 Ni <nichen@iscas.ac.cn>, Ricky Wu <ricky_wu@realtek.com>, Al Viro
 <viro@zeniv.linux.org.uk>, Breno Leitao <leitao@debian.org>, Kevin Tian
 <kevin.tian@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ilpo
 =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, Mostafa Saleh
 <smostafa@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Soumya Negi <soumya.negi97@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi
 Liu <yi.l.liu@intel.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, 
 Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>, Eric Auger
 <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>, Marek
 =?ISO-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Kai Vehmanen
 <kai.vehmanen@linux.intel.com>,  Peter Ujfalusi
 <peter.ujfalusi@linux.intel.com>, Rui Salvaterra <rsalvaterra@gmail.com>,
 Marc Zyngier <maz@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-input@vger.kernel.org, netdev@vger.kernel.org, 
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org,  linux-staging@lists.linux.dev,
 kvm@vger.kernel.org,  xen-devel@lists.xenproject.org,
 linux-sound@vger.kernel.org
Date: Wed, 09 Oct 2024 12:55:07 +0200
In-Reply-To: <95b23ff9-eb17-4e1c-b7a3-2d3691ffc48f@kernel.org>
References: <20241009083519.10088-1-pstanner@redhat.com>
	 <20241009083519.10088-10-pstanner@redhat.com>
	 <95b23ff9-eb17-4e1c-b7a3-2d3691ffc48f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-10-09 at 17:51 +0900, Damien Le Moal wrote:
> On 10/9/24 17:35, Philipp Stanner wrote:
> > pci_intx() is a hybrid function which can sometimes be managed
> > through
> > devres. To remove this hybrid nature from pci_intx(), it is
> > necessary to
> > port users to either an always-managed or a never-managed version.
> >=20
> > All users in ata enable their PCI-Device with pcim_enable_device().
> > Thus,
> > they need the always-managed version.
> >=20
> > Replace pci_intx() with pci_intx_unmanaged().
>=20
> This contradicts the sentence above and the patche replaces
> pci_intx() with
> pcim_intx()... So s/pci_intx_unmanaged/pcim_intx in the above
> sentence ?

Yes, absolutely correct, the commit message is broken. The code itself
is fine, I grepped through it for pci_enable / pcim_enable

P.

>=20
> >=20
> > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> > ---
> > =C2=A0drivers/ata/ahci.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 2 +-
> > =C2=A0drivers/ata/ata_piix.c=C2=A0=C2=A0 | 2 +-
> > =C2=A0drivers/ata/pata_rdc.c=C2=A0=C2=A0 | 2 +-
> > =C2=A0drivers/ata/sata_sil24.c | 2 +-
> > =C2=A0drivers/ata/sata_sis.c=C2=A0=C2=A0 | 2 +-
> > =C2=A0drivers/ata/sata_uli.c=C2=A0=C2=A0 | 2 +-
> > =C2=A0drivers/ata/sata_vsc.c=C2=A0=C2=A0 | 2 +-
> > =C2=A07 files changed, 7 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> > index 45f63b09828a..9273ff3d4732 100644
> > --- a/drivers/ata/ahci.c
> > +++ b/drivers/ata/ahci.c
> > @@ -1985,7 +1985,7 @@ static int ahci_init_one(struct pci_dev
> > *pdev, const struct pci_device_id *ent)
> > =C2=A0
> > =C2=A0	if (ahci_init_msi(pdev, n_ports, hpriv) < 0) {
> > =C2=A0		/* legacy intx interrupts */
> > -		pci_intx(pdev, 1);
> > +		pcim_intx(pdev, 1);
> > =C2=A0	}
> > =C2=A0	hpriv->irq =3D pci_irq_vector(pdev, 0);
> > =C2=A0
> > diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> > index 093b940bc953..d441246fa357 100644
> > --- a/drivers/ata/ata_piix.c
> > +++ b/drivers/ata/ata_piix.c
> > @@ -1725,7 +1725,7 @@ static int piix_init_one(struct pci_dev
> > *pdev, const struct pci_device_id *ent)
> > =C2=A0	 * message-signalled interrupts currently).
> > =C2=A0	 */
> > =C2=A0	if (port_flags & PIIX_FLAG_CHECKINTR)
> > -		pci_intx(pdev, 1);
> > +		pcim_intx(pdev, 1);
> > =C2=A0
> > =C2=A0	if (piix_check_450nx_errata(pdev)) {
> > =C2=A0		/* This writes into the master table but it does
> > not
> > diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
> > index 0a9689862f71..09792aac7f9d 100644
> > --- a/drivers/ata/pata_rdc.c
> > +++ b/drivers/ata/pata_rdc.c
> > @@ -340,7 +340,7 @@ static int rdc_init_one(struct pci_dev *pdev,
> > const struct pci_device_id *ent)
> > =C2=A0		return rc;
> > =C2=A0	host->private_data =3D hpriv;
> > =C2=A0
> > -	pci_intx(pdev, 1);
> > +	pcim_intx(pdev, 1);
> > =C2=A0
> > =C2=A0	host->flags |=3D ATA_HOST_PARALLEL_SCAN;
> > =C2=A0
> > diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> > index 72c03cbdaff4..b771ebd41252 100644
> > --- a/drivers/ata/sata_sil24.c
> > +++ b/drivers/ata/sata_sil24.c
> > @@ -1317,7 +1317,7 @@ static int sil24_init_one(struct pci_dev
> > *pdev, const struct pci_device_id *ent)
> > =C2=A0
> > =C2=A0	if (sata_sil24_msi && !pci_enable_msi(pdev)) {
> > =C2=A0		dev_info(&pdev->dev, "Using MSI\n");
> > -		pci_intx(pdev, 0);
> > +		pcim_intx(pdev, 0);
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	pci_set_master(pdev);
> > diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
> > index ef8724986de3..b8b6d9eff3b8 100644
> > --- a/drivers/ata/sata_sis.c
> > +++ b/drivers/ata/sata_sis.c
> > @@ -290,7 +290,7 @@ static int sis_init_one(struct pci_dev *pdev,
> > const struct pci_device_id *ent)
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	pci_set_master(pdev);
> > -	pci_intx(pdev, 1);
> > +	pcim_intx(pdev, 1);
> > =C2=A0	return ata_host_activate(host, pdev->irq,
> > ata_bmdma_interrupt,
> > =C2=A0				 IRQF_SHARED, &sis_sht);
> > =C2=A0}
> > diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
> > index 60ea45926cd1..52894ff49dcb 100644
> > --- a/drivers/ata/sata_uli.c
> > +++ b/drivers/ata/sata_uli.c
> > @@ -221,7 +221,7 @@ static int uli_init_one(struct pci_dev *pdev,
> > const struct pci_device_id *ent)
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	pci_set_master(pdev);
> > -	pci_intx(pdev, 1);
> > +	pcim_intx(pdev, 1);
> > =C2=A0	return ata_host_activate(host, pdev->irq,
> > ata_bmdma_interrupt,
> > =C2=A0				 IRQF_SHARED, &uli_sht);
> > =C2=A0}
> > diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
> > index d39b87537168..a53a2dfc1e17 100644
> > --- a/drivers/ata/sata_vsc.c
> > +++ b/drivers/ata/sata_vsc.c
> > @@ -384,7 +384,7 @@ static int vsc_sata_init_one(struct pci_dev
> > *pdev,
> > =C2=A0		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE,
> > 0x80);
> > =C2=A0
> > =C2=A0	if (pci_enable_msi(pdev) =3D=3D 0)
> > -		pci_intx(pdev, 0);
> > +		pcim_intx(pdev, 0);
> > =C2=A0
> > =C2=A0	/*
> > =C2=A0	 * Config offset 0x98 is "Extended Control and Status
> > Register 0"
>=20
>=20


