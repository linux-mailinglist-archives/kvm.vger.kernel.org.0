Return-Path: <kvm+bounces-33654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E48619EFC60
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0768D16BBFA
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059821AA1C4;
	Thu, 12 Dec 2024 19:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhBebKxO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106CD168497;
	Thu, 12 Dec 2024 19:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734031452; cv=none; b=AtD13zofXgikZqpYERMEukiMOLw4Hkce9g990Y0JUWge6nHGrENYBk/HibMeYJvuD62xcaSJlcko0+FDZOG1NlN3TqGkpcejnoLwi+hnqOPHdXZtrOOmEB2LXRliARqTk0ippIlyWmNRUtTYe6fGFNEIDf6wOQX3SsSH67oDb3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734031452; c=relaxed/simple;
	bh=1drleKSVmSZecvjLL637vpj9Uwu8sP8KERGudhXDLZw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=op1TuzGKIdu6k1GbZmAPGWe6Jg4fFuFex80rwGCmj3ekpylQNqJZYVLkRQXvRtJiTr+c53TzIfEPKWvUBZPmtmf0z91zOoK4ufyki3LAiaJhhsCN6rncYmDMkw3q6pHbMGll3N4fTkjt91ZX52h6qL029F0ya/fexwT/6xddP+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhBebKxO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F31C4CECE;
	Thu, 12 Dec 2024 19:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734031451;
	bh=1drleKSVmSZecvjLL637vpj9Uwu8sP8KERGudhXDLZw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=AhBebKxOvxeSefMCQemAWxdtkP4lVSLp5/JlRJC4BX23eiI2Dl5bBHYOzHkMhk3wt
	 OAKQyIj5oWEFDKCXqKn3KUvYZcII+c+3REDcqSqR6azZ1GnrIpXKBVzFidMWXQ3pKZ
	 R5A3dM3mkD/Z183rT7dmOaL89lpe1hKYJP8js22v6fuP/RNOss2jpGL+dIcGyXDW4B
	 fJUEwnK84ONbYJE1CE/5Ci++Vj2VlTYdpRGnc77CNZ7XTaG22cuCJ+XeVcOimFy80u
	 psMKUA60y/77EjFe3Zp7qZwmaKzvSPciD45Yc0j4otDxKpHaTxdtEPPVrPUhumAZOb
	 JI/VpaGWfDtow==
Date: Thu, 12 Dec 2024 13:24:10 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Philipp Stanner <pstanner@redhat.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	Rasesh Mody <rmody@marvell.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	GR-Linux-NIC-Dev@marvell.com,
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
Subject: Re: [PATCH v3 03/11] net/ethernet: Use never-managed version of
 pci_intx()
Message-ID: <20241212192410.GA3359655@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209130632.132074-5-pstanner@redhat.com>

[cc->to: Sudarsana, Manish, Rasesh]

On Mon, Dec 09, 2024 at 02:06:25PM +0100, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
> 
> broadcom/bnx2x and brocade/bna enable their PCI-Device with
> pci_enable_device(). Thus, they need the never-managed version.
> 
> Replace pci_intx() with pci_intx_unmanaged().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Hoping for an ack from Sudarsana, Manish, Rasesh.

> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 2 +-
>  drivers/net/ethernet/brocade/bna/bnad.c          | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index 678829646cec..2ae63d6e6792 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -1669,7 +1669,7 @@ static void bnx2x_igu_int_enable(struct bnx2x *bp)
>  	REG_WR(bp, IGU_REG_PF_CONFIGURATION, val);
>  
>  	if (val & IGU_PF_CONF_INT_LINE_EN)
> -		pci_intx(bp->pdev, true);
> +		pci_intx_unmanaged(bp->pdev, true);
>  
>  	barrier();
>  
> diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
> index ece6f3b48327..2b37462d406e 100644
> --- a/drivers/net/ethernet/brocade/bna/bnad.c
> +++ b/drivers/net/ethernet/brocade/bna/bnad.c
> @@ -2669,7 +2669,7 @@ bnad_enable_msix(struct bnad *bnad)
>  		}
>  	}
>  
> -	pci_intx(bnad->pcidev, 0);
> +	pci_intx_unmanaged(bnad->pcidev, 0);
>  
>  	return;
>  
> -- 
> 2.47.1
> 

