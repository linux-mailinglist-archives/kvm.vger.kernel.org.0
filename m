Return-Path: <kvm+bounces-30115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4A49B6FCA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 23:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73F301F222EE
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056B421745A;
	Wed, 30 Oct 2024 22:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGnfP7Ar"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066A11BD9E7;
	Wed, 30 Oct 2024 22:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730326660; cv=none; b=WjaKySa2kpuoRCJ6DxfG384mkLP9oWjuiuP6xJbSBep0TqYGQDSFaxeanto9MuQ8UXEO3d3xaE5iUzBceWzPQO/tFZw9MhGvIcixGUY68bd0en9SlWyI0vY/yeY2DkW38d4f0t/uQ4HgrWWasehqWWv4gMT+rJoEhF9XDE/ub8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730326660; c=relaxed/simple;
	bh=hmCcTNJwyZk0ee56ytBk9i4eOtptK5uTArpnChQPbzk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=oy3V2usP3KrNnwy1jGIZGkW4JlJh0GP8RyUFGP7313Jyvtrobj4qmyhPm0mR5NFc1OYMR7YkcXZUfR6ByBN/KjLUYq77UdgwfuMf/5QHr1T4oYPeFlUG6wcP3IEHj1s5GNAHQM0YyXotJYsv5eLqVWWDemH9eCHcyJCxqaCSrTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGnfP7Ar; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3913FC4CECE;
	Wed, 30 Oct 2024 22:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730326659;
	bh=hmCcTNJwyZk0ee56ytBk9i4eOtptK5uTArpnChQPbzk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=oGnfP7ArKKdfSdgdnkKr7SkEnhwI4nY+JGypMiyscKrSh2koWdUM4bEIYHcoVRtmA
	 HuGtZd7+EhsSZKGsSElcy0Ekf1Ww0XJz+CC/k+Lyv93Pjy1sctZPVHq2ye34KwR2cM
	 BK6k4mDq37WcoKSeIdS6Dykd1seb3K6MaOqwt7pucQeiJF9BIdqo96G1NTsjD7AK/F
	 RSMAKuBU3/553ttm2CAep19cPgSP8wuqNrGnio71malobZI2XoVqqJ3i5mKV/tHQzD
	 b+pchDCDpw/vI+Q3mqbdXkWdGIm9PhoPKYSd9frqB8SQkOwkBxe7BOOJjjYvM4WuEB
	 3GNefMYxm1CyQ==
Date: Wed, 30 Oct 2024 17:17:37 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Kalle Valo <kvalo@kernel.org>, Sanjay R Mehta <sanju.mehta@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Jon Mason <jdmason@kudzu.us>, Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ricky Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Breno Leitao <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>, Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Eric Auger <eric.auger@redhat.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Rui Salvaterra <rsalvaterra@gmail.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 00/13] Remove implicit devres from pci_intx()
Message-ID: <20241030221737.GA1223682@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015185124.64726-1-pstanner@redhat.com>

On Tue, Oct 15, 2024 at 08:51:10PM +0200, Philipp Stanner wrote:
> @Driver-Maintainers: Your driver might be touched by patch "Remove
> devres from pci_intx()". You might want to take a look.
> 
> Changes since the RFC [1]:
>   - Add a patch deprecating pci{m}_intx(). (Heiner, Andy, Me)
>   - Add Acked-by's already given.
>   - Export pcim_intx() as a GPL function. (Alex)
>   - Drop patch for rts5280, since this driver will be removed quite
>     soon. (Philipp Hortmann, Greg)
>   - Use early-return in pci_intx_unmanaged() and pci_intx(). (Andy)
> 
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
> Patch "Remove devres from pci_intx()" obviously reverts the previous
> patches that made drivers use pci_intx_unmanaged(). But this way it's
> easier to review and approve. It also makes sure that each checked out
> commit should provide correct behavior, not just the entire series as a
> whole.
> 
> Merge plan for this is to enter through the PCI tree.
> 
> [1] https://lore.kernel.org/all/20241009083519.10088-1-pstanner@redhat.com/

I *think* this series depends on resolution of Takashi's "Restore the
original INTX_DISABLE bit by pcim_intx()" patch [2], right?

For now I'm postponing this series, but let me know if that's not the
right thing.

[2] https://lore.kernel.org/r/20241024155539.19416-1-tiwai@suse.de

> Philipp Stanner (13):
>   PCI: Prepare removing devres from pci_intx()
>   ALSA: hda_intel: Use always-managed version of pcim_intx()
>   drivers/xen: Use never-managed version of pci_intx()
>   net/ethernet: Use never-managed version of pci_intx()
>   net/ntb: Use never-managed version of pci_intx()
>   misc: Use never-managed version of pci_intx()
>   vfio/pci: Use never-managed version of pci_intx()
>   PCI: MSI: Use never-managed version of pci_intx()
>   ata: Use always-managed version of pci_intx()
>   wifi: qtnfmac: use always-managed version of pcim_intx()
>   HID: amd_sfh: Use always-managed version of pcim_intx()
>   Remove devres from pci_intx()
>   PCI: Deprecate pci_intx(), pcim_intx()
> 
>  drivers/ata/ahci.c                            |  2 +-
>  drivers/ata/ata_piix.c                        |  2 +-
>  drivers/ata/pata_rdc.c                        |  2 +-
>  drivers/ata/sata_sil24.c                      |  2 +-
>  drivers/ata/sata_sis.c                        |  2 +-
>  drivers/ata/sata_uli.c                        |  2 +-
>  drivers/ata/sata_vsc.c                        |  2 +-
>  drivers/hid/amd-sfh-hid/amd_sfh_pcie.c        |  4 +--
>  drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c |  2 +-
>  .../wireless/quantenna/qtnfmac/pcie/pcie.c    |  2 +-
>  drivers/pci/devres.c                          | 29 +++++--------------
>  drivers/pci/pci.c                             | 19 ++++--------
>  include/linux/pci.h                           |  1 +
>  sound/pci/hda/hda_intel.c                     |  2 +-
>  14 files changed, 26 insertions(+), 47 deletions(-)
> 
> -- 
> 2.47.0
> 

