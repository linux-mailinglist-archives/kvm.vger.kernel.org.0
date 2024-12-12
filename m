Return-Path: <kvm+bounces-33655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3DC89EFC72
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5317516AE70
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075A2198E7B;
	Thu, 12 Dec 2024 19:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nq8Debfn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0347619AA58;
	Thu, 12 Dec 2024 19:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734031600; cv=none; b=OVryeSA+3Ukupm6heEXldhKDMv9npCT6rwpRQQbRAu0PbQHSBwCKNQc7wF+F9bqwKL5uPfJT9Cr7+oYgIkdxCH+bopsBL7tXvm6Rx3kf7o2NdzJ8cctqqcpwyzw6pLHNeHcieWj8Z1340u0x8wKjSYIvLldMBkwnTeKz0Ji0uGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734031600; c=relaxed/simple;
	bh=GY8df68Vpq13zRfn9lQiZuhcp6ZPERGYWUjygEgKyfo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=dU/H4ZtV9yPmTaYcfZgnosD5WodKBSn4IJCLgixT9tId17YEii18GZVZbZWENi8gtyvoFTXMIaF3QyEdNkY9ZhgwJmCtKHVIwEHcQjrvXHL1gCRAW3QjBYMOtRQQ3tTPXGkjgOzLlhUhAEZ2tMZ+9Sed90DVjiIHyf9xpK0LHDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nq8Debfn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE3DC4CECE;
	Thu, 12 Dec 2024 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734031599;
	bh=GY8df68Vpq13zRfn9lQiZuhcp6ZPERGYWUjygEgKyfo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Nq8DebfnKz6oRj40JuP2b63VJxYs2cK7koMQE4wqMV6qD2csMUAgK5AzSgqwbBYEL
	 u9euMyyzqa7e7GkjVAp6yQfo1AZ2Co8EJsXQ4Tm39YjgSAGT4PgrOZSOipNdus0wWP
	 5jEOuPBPs1+JKN2ABFGyBe3bAHjHJXDBdMubHDqVFWJ7Vy1RPqX8Fa+BwvWlMEiPRP
	 qSJu+l8/ulTi3y9AwZpqtrLG6q55HekV8WDMGP0u1YdCkLSXeeoiRpw137PWbZFSeR
	 0v5Q/aRW85aEzTfeInJqQ6lZPduXCDaQWJCKCHPvbJoZteMnM1UyL4vc31qeB26R6X
	 PJXIBsPc6+D8Q==
Date: Thu, 12 Dec 2024 13:26:37 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Philipp Stanner <pstanner@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>
Cc: amien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
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
Subject: Re: [PATCH v3 05/11] misc: Use never-managed version of pci_intx()
Message-ID: <20241212192637.GA3359920@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209130632.132074-7-pstanner@redhat.com>

[cc->to: Arnd, Greg, Alex]

On Mon, Dec 09, 2024 at 02:06:27PM +0100, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
> 
> cardreader/rtsx_pcr.c and tifm_7xx1.c enable their PCI-Device with
> pci_enable_device(). Thus, they need the never-managed version.
> 
> Replace pci_intx() with pci_intx_unmanaged().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Looking for ack from Arnd, Greg, Alex.

> ---
>  drivers/misc/cardreader/rtsx_pcr.c | 2 +-
>  drivers/misc/tifm_7xx1.c           | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
> index be3d4e0e50cc..e25e6d560dd7 100644
> --- a/drivers/misc/cardreader/rtsx_pcr.c
> +++ b/drivers/misc/cardreader/rtsx_pcr.c
> @@ -1057,7 +1057,7 @@ static int rtsx_pci_acquire_irq(struct rtsx_pcr *pcr)
>  	}
>  
>  	pcr->irq = pcr->pci->irq;
> -	pci_intx(pcr->pci, !pcr->msi_en);
> +	pci_intx_unmanaged(pcr->pci, !pcr->msi_en);
>  
>  	return 0;
>  }
> diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
> index 1d54680d6ed2..5f9c7ccae8d2 100644
> --- a/drivers/misc/tifm_7xx1.c
> +++ b/drivers/misc/tifm_7xx1.c
> @@ -327,7 +327,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
>  		goto err_out;
>  	}
>  
> -	pci_intx(dev, 1);
> +	pci_intx_unmanaged(dev, 1);
>  
>  	fm = tifm_alloc_adapter(dev->device == PCI_DEVICE_ID_TI_XX21_XX11_FM
>  				? 4 : 2, &dev->dev);
> @@ -368,7 +368,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
>  err_out_free:
>  	tifm_free_adapter(fm);
>  err_out_int:
> -	pci_intx(dev, 0);
> +	pci_intx_unmanaged(dev, 0);
>  	pci_release_regions(dev);
>  err_out:
>  	if (!pci_dev_busy)
> @@ -392,7 +392,7 @@ static void tifm_7xx1_remove(struct pci_dev *dev)
>  		tifm_7xx1_sock_power_off(tifm_7xx1_sock_addr(fm->addr, cnt));
>  
>  	iounmap(fm->addr);
> -	pci_intx(dev, 0);
> +	pci_intx_unmanaged(dev, 0);
>  	pci_release_regions(dev);
>  
>  	pci_disable_device(dev);
> -- 
> 2.47.1
> 

