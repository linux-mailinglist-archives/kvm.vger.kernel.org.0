Return-Path: <kvm+bounces-28310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B07F9974F5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEE90B256B2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38401E1A04;
	Wed,  9 Oct 2024 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgfV2Jq2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BCE13A244;
	Wed,  9 Oct 2024 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728498758; cv=none; b=mZftwqCsMZpUbfA6I0GNmU2FdulQ9CwPPE2pcvJvIPswjYGtkNphWru9qndrZrDaNSYpUiM/bcoboIJm5O06bwLM1dqz+ie1vgyneu4G0jXhtFJPNAEVW3EP+eutQFmXEqKGobwKEIrDsUxGSNMC4tu87mCGUus+S1k+v6WN7Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728498758; c=relaxed/simple;
	bh=bSSiGC3g3GabtARrnMj44CZqyy3E+8f4NuRq+RhgMPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iscotjju6fB/iXrIF9+SDqfPC5M3YP+1kyNxoyXmBl3Tfw+8jg5DlfrwlTroXADtXFR8Y6ZRdFMntHoj1EQfyFCp69VsXr480DP2urvf/Zc2J3dW0ottFu/62McOkK9T/IjQT9lBZsYhPEze0TEFmgr5ftMmVmIOmuNJ8mmN1JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgfV2Jq2; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a994cd82a3bso16661766b.2;
        Wed, 09 Oct 2024 11:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728498755; x=1729103555; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tHWLAGUkGjurq/EbYyrSVR7K+eem2ACfoMVdEJSkJug=;
        b=SgfV2Jq2Y3pcrmUWLH1hY/zX6x8h1pFkALQwT43mvaKhPs2Aodk13+6Y0GeUmgLRlo
         ZlzbtKdnjnBKDGfHEXabF9jmCjqmXOFnLdxHTu/kUNyBWOwnN6LKXqADw/oIF75p2v31
         MS2xrQDl3IzVO/pmv3Eussump4teL3fIw0icZdRD/Ib3fqRVh88e/Un3Zcytg1f/uQNa
         DA343D5CoXh5SXYk60XGBQ2ew3iEiGkaaENf5Vc6MZgWLdXc03ywG/rZO4A1m5DE5GRX
         XyDNjDNMNDF6k3E4LhKfP9u2h7eDMnCNOn4biskvi13Wjj8bPIVzVnwMyiS/+NkKjonA
         kTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728498755; x=1729103555;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tHWLAGUkGjurq/EbYyrSVR7K+eem2ACfoMVdEJSkJug=;
        b=DP246i7+Vh8gR5i380Npio5ejUSUu7Zx50kfGX4Em2upMrP5BtQLWcfrgxbC4oxubp
         ceTjiXhQgr7Wasy/C+rPludbTgRHY0/foGxwh/132rjLn9PMTWcmqQAHarxE9Sk59qaG
         vdJRhfKtsle3jyuxzVDw5y/ZcOPATJk6cBP/SVXNwkqfaaLY1/MikHJigf6qlxDy+P07
         95ZGNCXwPPIzlMJXDE0/ywYcldoJDqWqverTB6g/IDK0a3FdIbtbtwPcccSFCTt12OBW
         G8hgYLSya3EyUyvhjzq2/SEQV+9g4BD9ZkTNdhOd54Pt+0yWTHAEFTRyMLI4EnrYmNxh
         qmxw==
X-Forwarded-Encrypted: i=1; AJvYcCVBx0f/L7p0Q90Mpor/u1u+Sf2+zTgg3QOO38qIvcH4kKrNL41Uy2gHKeh7hAscmgidMxM=@vger.kernel.org, AJvYcCVhyJG+c7BOdYg+xFAezl6r6sApwtfhfCbMw+FNKizbHNUi/aTydIRg3BZ3z1YmfQ1aZUWikLHY+LWN7cTT@vger.kernel.org, AJvYcCVv2P+YTSwY2woFfO9YO/fmXxRP6ChcLQGp76yzdMNMsxJpmq6uD4eR7gkw+fJECDvNUmQluLXO9SQ6gkc=@vger.kernel.org, AJvYcCW6Nz5AB6S2UQ39Ei0pEye0PD2hf2rggajNjHZNMLRUXzUEpBgZ/qJFsbFFiomS2sJhOZn2yrW4BgkA@vger.kernel.org, AJvYcCWGvS9swU+lCBTX4fCgtdBkg4CC0B7FfD3HwfH0VPOCsn2G430WamX/9sQZlZqx32uiNz8EfO2J@vger.kernel.org, AJvYcCXHywX6mH5lRfGHSFA/2uZzKsESDeEFg71XNmTOWPOZJgcshHt6S98kTpVMLA7SIh2jrxeZ/RbsRj0PYXI=@vger.kernel.org, AJvYcCXPRXCN/AjO7n+9jB9r/cQIjvEVml3qfOcyTC7fmmn9WU4A9xI+ANvMB1ZCw49NKbdrySPeUcxVrXC8s6yU+/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyzR4oAjLyC6jFFMYp0nQa3z5nhu73mNM/e39u1A6oEDJLEQzE
	Ll0KcnStsP5zcXnN576w9IDdxPrW7Y7+iA4YCby1FlBDSdFUzBDx3i4h9bb6
X-Google-Smtp-Source: AGHT+IEBv3GCm8Aviv10dRX1hBYK+NueR4e/GzPds1/fWd5JaekK6CwLsS7GL+rfjHYS5z/u2KXZwg==
X-Received: by 2002:a17:907:970e:b0:a99:89ea:593e with SMTP id a640c23a62f3a-a998d117e60mr306519666b.13.1728498755241;
        Wed, 09 Oct 2024 11:32:35 -0700 (PDT)
Received: from ?IPV6:2a02:3100:b338:6300:ac71:eea5:34f6:504b? (dynamic-2a02-3100-b338-6300-ac71-eea5-34f6-504b.310.pool.telefonica.de. [2a02:3100:b338:6300:ac71:eea5:34f6:504b])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a996167411csm356771566b.14.2024.10.09.11.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:32:33 -0700 (PDT)
Message-ID: <8643a212-884c-48de-a2d0-0f068fc49ca2@gmail.com>
Date: Wed, 9 Oct 2024 20:32:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/13] Remove implicit devres from pci_intx()
To: Philipp Stanner <pstanner@redhat.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Sergey Shtylyov <s.shtylyov@omp.ru>,
 Basavaraj Natikar <basavaraj.natikar@amd.com>, Jiri Kosina
 <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov
 <oakad@yahoo.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Manish Chopra <manishc@marvell.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
 Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Sanjay R Mehta <sanju.mehta@amd.com>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>,
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Alex Williamson <alex.williamson@redhat.com>, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Chen Ni <nichen@iscas.ac.cn>,
 Ricky Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Breno Leitao <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Mostafa Saleh <smostafa@google.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Soumya Negi <soumya.negi97@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yi Liu <yi.l.liu@intel.com>, "Dr. David Alan Gilbert" <linux@treblig.org>,
 Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Rui Salvaterra <rsalvaterra@gmail.com>, Marc Zyngier <maz@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org, linux-staging@lists.linux.dev,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-sound@vger.kernel.org
References: <20241009083519.10088-1-pstanner@redhat.com>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
Autocrypt: addr=hkallweit1@gmail.com; keydata=
 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
In-Reply-To: <20241009083519.10088-1-pstanner@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09.10.2024 10:35, Philipp Stanner wrote:
> Hi all,
> 
> this series removes a problematic feature from pci_intx(). That function
> sometimes implicitly uses devres for automatic cleanup. We should get
> rid of this implicit behavior.
> 
> To do so, a pci_intx() version that is always-managed, and one that is
> never-managed are provided. Then, all pci_intx() users are ported to the
> version they need. Afterwards, pci_intx() can be cleaned up and the
> users of the never-managed version be ported back to pci_intx().
> 
> This way we'd get this PCI API consistent again.
> 
AFAICS pci_intx() is used only by drivers which haven't been converted
to the pci_alloc_irq_vectors() API yet. Wouldn't it be better to do this
instead of trying to improve pci_intx()?
Eventually pci_intx() would have to be used in PCI core only.

> The last patch obviously reverts the previous patches that made drivers
> use pci_intx_unmanaged(). But this way it's easier to review and
> approve. It also makes sure that each checked out commit should provide
> correct behavior, not just the entire series as a whole.
> 
> Merge plan for this would be to enter through the PCI tree.
> 
> Please say so if you've got concerns with the general idea behind the
> RFC.
> 
> Regards,
> P.
> 
> Philipp Stanner (13):
>   PCI: Prepare removing devres from pci_intx()
>   ALSA: hda: hda_intel: Use always-managed version of pcim_intx()
>   drivers/xen: Use never-managed version of pci_intx()
>   net/ethernet: Use never-managed version of pci_intx()
>   net/ntb: Use never-managed version of pci_intx()
>   misc: Use never-managed version of pci_intx()
>   vfio/pci: Use never-managed version of pci_intx()
>   PCI: MSI: Use never-managed version of pci_intx()
>   ata: Use always-managed version of pci_intx()
>   staging: rts5280: Use always-managed version of pci_intx()
>   wifi: qtnfmac: use always-managed version of pcim_intx()
>   HID: amd_sfh: Use always-managed version of pcim_intx()
>   Remove devres from pci_intx()
> 
>  drivers/ata/ahci.c                            |  2 +-
>  drivers/ata/ata_piix.c                        |  2 +-
>  drivers/ata/pata_rdc.c                        |  2 +-
>  drivers/ata/sata_sil24.c                      |  2 +-
>  drivers/ata/sata_sis.c                        |  2 +-
>  drivers/ata/sata_uli.c                        |  2 +-
>  drivers/ata/sata_vsc.c                        |  2 +-
>  drivers/hid/amd-sfh-hid/amd_sfh_pcie.c        |  4 ++--
>  drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c |  2 +-
>  .../wireless/quantenna/qtnfmac/pcie/pcie.c    |  2 +-
>  drivers/pci/devres.c                          | 24 +++----------------
>  drivers/pci/pci.c                             | 14 +----------
>  drivers/staging/rts5208/rtsx.c                |  2 +-
>  include/linux/pci.h                           |  1 +
>  sound/pci/hda/hda_intel.c                     |  2 +-
>  15 files changed, 18 insertions(+), 47 deletions(-)
> 


