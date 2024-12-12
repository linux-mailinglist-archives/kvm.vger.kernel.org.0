Return-Path: <kvm+bounces-33652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 172DF9EFC47
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:21:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6414916CAC8
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0871218CBFB;
	Thu, 12 Dec 2024 19:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jsm8J74C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CE2190497;
	Thu, 12 Dec 2024 19:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734031281; cv=none; b=osKKm/yWkEPc046zIdpq0lONItGpnMnzZKaB+Ywtv0Iny44bMyBfsGW5+UNDNVhPtCrHQKlFxLvttkYb9ibMcnKLUDel8rtXvkCDpY0GUUDpJFYdhvI8uEbU586aJoSGaaYmHMcotbCurTpZa8w79HWwhDst8vPxZE8IS4Y5uGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734031281; c=relaxed/simple;
	bh=7jTnse7IuWHCGd/Dl0nDYQ1TbdJrSYaJ37r4en1LiKY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=M4YyqtDyIWXs8tL1VAecfGBffcDLcj0iaIUZqhWhGEFi63P1L7r01+IVF6TYqnLmhbcrRyMcX6pm6QWwKTQmfspq4kl+ubadv5WkijYM07rPd7Tq58klB8YPC5BI+XPrFB4QFvYg97USmCO4tgB5XxNKdDPgeLaOFFHYMGwqPOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jsm8J74C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DA5C4CECE;
	Thu, 12 Dec 2024 19:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734031280;
	bh=7jTnse7IuWHCGd/Dl0nDYQ1TbdJrSYaJ37r4en1LiKY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Jsm8J74CeCOSQX2TAidV+m7FZS6ULNXQzhXeWkuv5iEzrUHcg8znyVLdxbxRPru+9
	 VTNtp1UpRC4YYL3KINlGq6Rm3mDmwWUjLlcvFtcaDdm/sMMc8jL3Lt6IP5xBBVa4uN
	 g6rp1AYKrZau2/lQVHaCgwMigVCU6RnvH5h7xgx9CXno8P90z+4zZDJzkW2VTv9vLB
	 2v8zIQ6uOpGnT4DsGys0y1UkWGeCS95G+7B8sB3FnS30uNrBNXakIEsYRc31wuk1wU
	 pMewcBUam+M54kZf6oMYeSKDOO0eQTk9gVUDIBiga7Z+z4SFYtDLeKSArBCBnotXnd
	 YNml6TBS6OcqA==
Date: Thu, 12 Dec 2024 13:21:18 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Philipp Stanner <pstanner@redhat.com>
Cc: amien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
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
	Mario Limonciello <mario.limonciello@amd.com>,
	Chen Ni <nichen@iscas.ac.cn>, Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Breno Leitao <leitao@debian.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Kevin Tian <kevin.tian@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>, Kunwu Chan <chentao@kylinos.cn>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 00/11] Remove implicit devres from pci_intx()
Message-ID: <20241212192118.GA3359591@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209130632.132074-2-pstanner@redhat.com>

On Mon, Dec 09, 2024 at 02:06:22PM +0100, Philipp Stanner wrote:
> @Driver-Maintainers: Your driver might be touched by patch "Remove
> devres from pci_intx()". You might want to take a look.
> 
> Changes in v3:
>   - Add Thomas' RB.
> 
> Changes in v2:
>   - Drop pci_intx() deprecation patch.
>   - ata: Add RB from Sergey and Niklas.
>   - wifi: Add AB by Kalle.
>   - Drop INTx deprecation patch
>   - Drop ALSA / hda_intel patch because pci_intx() was removed from
>     there in the meantime.
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

Applied the ones with maintainer acks to pci/devres for v6.14, thanks!

I'll poke the ones that haven't been acked yet.

> Philipp Stanner (11):
>   PCI: Prepare removing devres from pci_intx()
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
>  drivers/pci/pci.c                             | 16 +++----------
>  include/linux/pci.h                           |  1 +
>  13 files changed, 18 insertions(+), 45 deletions(-)
> 
> -- 
> 2.47.1
> 

