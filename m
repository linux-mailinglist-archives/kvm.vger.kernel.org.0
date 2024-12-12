Return-Path: <kvm+bounces-33653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98DE69EFC51
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4071E1890E4F
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61EEE1B4154;
	Thu, 12 Dec 2024 19:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7Ww+fY+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3E2190497;
	Thu, 12 Dec 2024 19:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734031292; cv=none; b=ZrLk7AtKXtfftLdeqnyklr8zHZ/TkBb6BII8XGkJuOk1lAkdfjov1bAYwz5NeBtpLkU0C2AyEOSsgd7L70AxOuPKiegITXcwQtQFCYa3q0gV3qq7XqzWI8L4ESTFGYTpHOEZAsJdV/rIJE4iU+mw88fja6JaMQZfQsSDp3ZtPOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734031292; c=relaxed/simple;
	bh=IbIwv1jGi3ADBtK60JNsHHHrXo2ysodiR7fOfGgUVZU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=OrgANjPVbQbjPnIFFHbrCgsmvk6zKpfj23Y+3kZijc6KiVzgu34fywGkDTRxXlrBqhQD615OBe77+PYfqGx+FvXMnH4lG3teijfpuybhIc0Vr/yKVvA6aaHZCxinfE9oKedqZU31J2uxp3IW+gFt/gOZ93uUO/4iTCU+7fg72cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7Ww+fY+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF63AC4CECE;
	Thu, 12 Dec 2024 19:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734031292;
	bh=IbIwv1jGi3ADBtK60JNsHHHrXo2ysodiR7fOfGgUVZU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=X7Ww+fY+bDJtf3JxD/fNdF9zPIqj7pIGW/Dr+8Hy8zeOUa7vem/i36jiSgi47zLR3
	 YpC9QVHuv7/PiiXwbFbJuD7PWiQvUm4tLZL89I7y6drN/IISf9C/h2IC7qJcgPOCYO
	 TnykuuOqWi0PRGE6pVEOPgNxJnBWWG52IOH275lcGsYtS8MPZd1Ks1XKaW1+ryZtpO
	 IXw35zDUnBs6v/FBtZoqMaTrIZOPnPE0vABs8PZYyW8Z8fcrhs9GihaNd+TgvR5kYJ
	 gFO04DIRnzP1eI07UKaDS8MVDbssUZ/lDF97BIT7ZiYJkn87B953qsx+t4Wp9qf70X
	 d8haM3Qwmd07Q==
Date: Thu, 12 Dec 2024 13:21:30 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Philipp Stanner <pstanner@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
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
Subject: Re: [PATCH v3 06/11] vfio/pci: Use never-managed version of
 pci_intx()
Message-ID: <20241212192130.GA3359535@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209130632.132074-8-pstanner@redhat.com>

[cc->to: Alex W]

On Mon, Dec 09, 2024 at 02:06:28PM +0100, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
> 
> vfio enables its PCI-Device with pci_enable_device(). Thus, it
> needs the never-managed version.
> 
> Replace pci_intx() with pci_intx_unmanaged().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Not applied yet, pending ack from Alex.

> ---
>  drivers/vfio/pci/vfio_pci_core.c  |  2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1ab58da9f38a..90240c8d51aa 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -498,7 +498,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  		if (vfio_pci_nointx(pdev)) {
>  			pci_info(pdev, "Masking broken INTx support\n");
>  			vdev->nointx = true;
> -			pci_intx(pdev, 0);
> +			pci_intx_unmanaged(pdev, 0);
>  		} else
>  			vdev->pci_2_3 = pci_intx_mask_supported(pdev);
>  	}
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 8382c5834335..40abb0b937a2 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -118,7 +118,7 @@ static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>  	 */
>  	if (unlikely(!is_intx(vdev))) {
>  		if (vdev->pci_2_3)
> -			pci_intx(pdev, 0);
> +			pci_intx_unmanaged(pdev, 0);
>  		goto out_unlock;
>  	}
>  
> @@ -132,7 +132,7 @@ static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>  		 * mask, not just when something is pending.
>  		 */
>  		if (vdev->pci_2_3)
> -			pci_intx(pdev, 0);
> +			pci_intx_unmanaged(pdev, 0);
>  		else
>  			disable_irq_nosync(pdev->irq);
>  
> @@ -178,7 +178,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *data)
>  	 */
>  	if (unlikely(!is_intx(vdev))) {
>  		if (vdev->pci_2_3)
> -			pci_intx(pdev, 1);
> +			pci_intx_unmanaged(pdev, 1);
>  		goto out_unlock;
>  	}
>  
> @@ -296,7 +296,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
>  	 */
>  	ctx->masked = vdev->virq_disabled;
>  	if (vdev->pci_2_3) {
> -		pci_intx(pdev, !ctx->masked);
> +		pci_intx_unmanaged(pdev, !ctx->masked);
>  		irqflags = IRQF_SHARED;
>  	} else {
>  		irqflags = ctx->masked ? IRQF_NO_AUTOEN : 0;
> @@ -569,7 +569,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
>  	 * via their shutdown paths.  Restore for NoINTx devices.
>  	 */
>  	if (vdev->nointx)
> -		pci_intx(pdev, 0);
> +		pci_intx_unmanaged(pdev, 0);
>  
>  	vdev->irq_type = VFIO_PCI_NUM_IRQS;
>  }
> -- 
> 2.47.1
> 

