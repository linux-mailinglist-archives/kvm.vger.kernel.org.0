Return-Path: <kvm+bounces-29602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 942D59ADE67
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C1A1B22A7F
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 08:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E385E1B0F2C;
	Thu, 24 Oct 2024 08:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UtI4WtBY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB931741EF
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 08:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729757000; cv=none; b=szLTHaeAOYWaWxenIeQSrq2JqcmtBziCiANpX5jZCGOng3NJ1HaiOoRiNHMg/OIArpDYqkkctxGu35tybPPOPcrn/7EzrbeRFunPL8wBLJrV+QCHAF386N5ZFW4a9IRzkfyLHPfoBWqvE+1M0FtGkxz8oq2JGnMHSbDAkReSxR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729757000; c=relaxed/simple;
	bh=Q1kfe1t0sp4jY5sNXXPh9kCYnsSIp6kXPNBXZwj0GiI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cxL3DJD4r/ib2a0X7V7DniqY94EPh8GxPQCysP2/IfJL0ywdXMwLw9yn/n4FtZC0I+vSyWlZXwxC+xd0FQclQfQcIBdxmcVFVxQyFO6XWHokQjKvu+P6sK8pQ7BFk6HL15g2qRcfPjBfLl5O/+3tAIq1x6qL+1NrQh3rrrPEJ7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UtI4WtBY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729756991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCHAxEtiIjB9/eMXdwm4L84xFlQFaCf3ZNV6cwdqU9g=;
	b=UtI4WtBY2j/9pznS5alQKURqQDZO7EIevs6jCfACJcP1A/THgN+NEOXvZRpDnAjRsMdqSK
	KUST2v2FGdtgkSEHK2idc6crgRsuA6+0vnmGd5OeDp41cDHVC56L34jvaq2zRjgkvAplul
	ItpM93Ul8nh5vmavYNSeMnpVsMlLhrE=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-wj_cjAMCM2CrAPnyTFQCmA-1; Thu, 24 Oct 2024 04:03:10 -0400
X-MC-Unique: wj_cjAMCM2CrAPnyTFQCmA-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-718107b2091so604518a34.3
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 01:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729756989; x=1730361789;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eCHAxEtiIjB9/eMXdwm4L84xFlQFaCf3ZNV6cwdqU9g=;
        b=gAj70f3tj+Domqldc031r5x2FhTrf/GHKWUz2of6dzz3W8iMW8aqat/kIUVLXdHU2j
         vfOqGmFKdVwrhxttJvogBQyKaXBYnJUorP3mzKaU77Hq5X8HHdd2YSQk9O1HINeDGYC5
         Bq+NdfW7cReo9L+6//+Xgnc4WXU7lccVJV4BqbB0A/dh9PbvUvNud/rwfGxbYaReX29Q
         dRrb5gxJzbwOy/MF24OYcTImy3vMDkTigipksagYxX0926wgt2lhy1+0vfCBkl88rIcf
         LZhVhnrHII2Hna7ty9KMS6rI5PIwH45bFW+az+1XharePtgwSwWpLwnwBr1EyLEt+29z
         pdYg==
X-Forwarded-Encrypted: i=1; AJvYcCWOGTQ3gua7w+3yfAGOqCeSiI7y4mOBXTt3+wGin0j+mlCvKRLL7AmLsqbkFSzocc1OOqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYMw6+voT+pFqGCtOOiJp5nVuWW5Ty8SUlQFK+dZ7iL9UmyB2m
	ujfpOb7YrKV3k0cEozkUUU2XNC5Ft8nWtlIzJxIUn12l9S0y98OYkmLlH0r36wQsihhloB3rbyg
	3RNIyTPgyv6Sjav1Gi9GL8a0NaGhffRdFI9ILVofhCWyRwQrrrA==
X-Received: by 2002:a05:6830:6dc7:b0:718:c0d:6bdb with SMTP id 46e09a7af769-718598599b9mr736374a34.20.1729756989547;
        Thu, 24 Oct 2024 01:03:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVwKg5C+Tp+G04yjB73N1UyaDqsdgqmmyDICp7Nqm80mYC6tnNIzWvedx2PALg7dJ9abA7Jw==
X-Received: by 2002:a05:6830:6dc7:b0:718:c0d:6bdb with SMTP id 46e09a7af769-718598599b9mr736305a34.20.1729756989132;
        Thu, 24 Oct 2024 01:03:09 -0700 (PDT)
Received: from dhcp-64-16.muc.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ce0099a79fsm47100376d6.90.2024.10.24.01.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 01:03:08 -0700 (PDT)
Message-ID: <aec23bb79b9ff7dd7f13eb67460e0605eac22912.camel@redhat.com>
Subject: Re: [PATCH 02/13] ALSA: hda_intel: Use always-managed version of
 pcim_intx()
From: Philipp Stanner <pstanner@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
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
 Iwai <tiwai@suse.com>, Chen Ni <nichen@iscas.ac.cn>, Mario Limonciello
 <mario.limonciello@amd.com>, Ricky Wu <ricky_wu@realtek.com>, Al Viro
 <viro@zeniv.linux.org.uk>, Breno Leitao <leitao@debian.org>, Kevin Tian
 <kevin.tian@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ilpo
 =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Mostafa Saleh
 <smostafa@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu
 <yi.l.liu@intel.com>,  Christian Brauner <brauner@kernel.org>, Ankit
 Agrawal <ankita@nvidia.com>, Eric Auger <eric.auger@redhat.com>, Reinette
 Chatre <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>, Marek
 =?ISO-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, Peter Ujfalusi
 <peter.ujfalusi@linux.intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Kai Vehmanen
 <kai.vehmanen@linux.intel.com>,  Rui Salvaterra <rsalvaterra@gmail.com>,
 linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-input@vger.kernel.org, netdev@vger.kernel.org, 
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org,  kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-sound@vger.kernel.org
Date: Thu, 24 Oct 2024 10:02:59 +0200
In-Reply-To: <87ttd2276j.wl-tiwai@suse.de>
References: <20241015185124.64726-1-pstanner@redhat.com>
	 <20241015185124.64726-3-pstanner@redhat.com> <87v7xk2ps5.wl-tiwai@suse.de>
	 <6f3db65fe9a5dcd1a7a8d9bd5352ecb248ef57b1.camel@redhat.com>
	 <87ttd2276j.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-10-23 at 17:03 +0200, Takashi Iwai wrote:
> On Wed, 23 Oct 2024 15:50:09 +0200,
> Philipp Stanner wrote:
> >=20
> > On Tue, 2024-10-22 at 16:08 +0200, Takashi Iwai wrote:
> > > On Tue, 15 Oct 2024 20:51:12 +0200,
> > > Philipp Stanner wrote:
> > > >=20
> > > > pci_intx() is a hybrid function which can sometimes be managed
> > > > through
> > > > devres. To remove this hybrid nature from pci_intx(), it is
> > > > necessary to
> > > > port users to either an always-managed or a never-managed
> > > > version.
> > > >=20
> > > > hda_intel enables its PCI-Device with pcim_enable_device().
> > > > Thus,
> > > > it needs
> > > > the always-managed version.
> > > >=20
> > > > Replace pci_intx() with pcim_intx().
> > > >=20
> > > > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> > > > ---
> > > > =C2=A0sound/pci/hda/hda_intel.c | 2 +-
> > > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/sound/pci/hda/hda_intel.c
> > > > b/sound/pci/hda/hda_intel.c
> > > > index b4540c5cd2a6..b44ca7b6e54f 100644
> > > > --- a/sound/pci/hda/hda_intel.c
> > > > +++ b/sound/pci/hda/hda_intel.c
> > > > @@ -786,7 +786,7 @@ static int azx_acquire_irq(struct azx
> > > > *chip,
> > > > int do_disconnect)
> > > > =C2=A0	}
> > > > =C2=A0	bus->irq =3D chip->pci->irq;
> > > > =C2=A0	chip->card->sync_irq =3D bus->irq;
> > > > -	pci_intx(chip->pci, !chip->msi);
> > > > +	pcim_intx(chip->pci, !chip->msi);
> > > > =C2=A0	return 0;
> > > > =C2=A0}
> > > > =C2=A0
> > >=20
> > > Hm, it's OK-ish to do this as it's practically same as what
> > > pci_intx()
> > > currently does.=C2=A0 But, the current code can be a bit inconsistent
> > > about
> > > the original intx value.=C2=A0 pcim_intx() always stores !enable to
> > > res->orig_intx unconditionally, and it means that the orig_intx
> > > value
> > > gets overridden at each time pcim_intx() gets called.
> >=20
> > Yes.
> >=20
> > >=20
> > > Meanwhile, HD-audio driver does release and re-acquire the
> > > interrupt
> > > after disabling MSI when something goes wrong, and pci_intx()
> > > call
> > > above is a part of that procedure.=C2=A0 So, it can rewrite the
> > > res->orig_intx to another value by retry without MSI.=C2=A0 And after
> > > the
> > > driver removal, it'll lead to another state.
> >=20
> > I'm not sure that I understand this paragraph completely. Still,
> > could
> > a solution for the driver on the long-term just be to use
> > pci_intx()?
>=20
> pci_intx() misses the restore of the original value, so it's no
> long-term solution, either.

Sure that is missing =E2=80=93 I was basically asking whether the driver co=
uld
live without that feature.

Consider that point obsolete, see below

>=20
> What I meant is that pcim_intx() blindly assumes the negative of the
> passed argument as the original state, which isn't always true.=C2=A0 e.g=
.
> when the driver calls it twice with different values, a wrong value
> may be remembered.

Ah, I see =E2=80=93 thoguh the issue is when it's called several times with=
 the
*same* value, isn't it?

E.g.

pcim_intx(pdev, 1); // 0 is remembered as the old value
pcim_intx(pdev, 1); // 0 is falsely remembered as the old value

Also, it would seem that calling the function for the first time like
that:

pcim_intx(pdev, 0); // old value: 1

is at least incorrect, because INTx should be 0 per default, shouldn't
it? Could then even be a 1st class bug, because INTx would end up being
enabled despite having been disabled all the time.

>=20
> That said, I thought of something like below.

At first glance that looks like a good idea to me, thanks for working
this out!

IMO you can submit that as a patch so we can discuss it separately.

Greetings,
Philipp

>=20
>=20
> thanks,
>=20
> Takashi
>=20
> -- 8< --
> --- a/drivers/pci/devres.c
> +++ b/drivers/pci/devres.c
> @@ -438,8 +438,17 @@ static void pcim_intx_restore(struct device
> *dev, void *data)
> =C2=A0	__pcim_intx(pdev, res->orig_intx);
> =C2=A0}
> =C2=A0
> -static struct pcim_intx_devres *get_or_create_intx_devres(struct
> device *dev)
> +static void save_orig_intx(struct pci_dev *pdev)
> =C2=A0{
> +	u16 pci_command;
> +
> +	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
> +	res->orig_intx =3D !(pci_command & PCI_COMMAND_INTX_DISABLE);
> +}
> +
> +static struct pcim_intx_devres *get_or_create_intx_devres(struct
> pci_dev *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> =C2=A0	struct pcim_intx_devres *res;
> =C2=A0
> =C2=A0	res =3D devres_find(dev, pcim_intx_restore, NULL, NULL);
> @@ -447,8 +456,10 @@ static struct pcim_intx_devres
> *get_or_create_intx_devres(struct device *dev)
> =C2=A0		return res;
> =C2=A0
> =C2=A0	res =3D devres_alloc(pcim_intx_restore, sizeof(*res),
> GFP_KERNEL);
> -	if (res)
> +	if (res) {
> +		save_orig_intx(pdev);
> =C2=A0		devres_add(dev, res);
> +	}
> =C2=A0
> =C2=A0	return res;
> =C2=A0}
> @@ -467,11 +478,10 @@ int pcim_intx(struct pci_dev *pdev, int enable)
> =C2=A0{
> =C2=A0	struct pcim_intx_devres *res;
> =C2=A0
> -	res =3D get_or_create_intx_devres(&pdev->dev);
> +	res =3D get_or_create_intx_devres(pdev);
> =C2=A0	if (!res)
> =C2=A0		return -ENOMEM;
> =C2=A0
> -	res->orig_intx =3D !enable;
> =C2=A0	__pcim_intx(pdev, enable);
> =C2=A0
> =C2=A0	return 0;
>=20


