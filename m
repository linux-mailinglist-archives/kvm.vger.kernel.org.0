Return-Path: <kvm+bounces-33656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 775C69EFC87
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 20:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3740628C28D
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D7F1AAE28;
	Thu, 12 Dec 2024 19:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8Cw2aVs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C33168497;
	Thu, 12 Dec 2024 19:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734031777; cv=none; b=RHacACiAxDDOeOrHpCkFzFB+lyxA6+ti1Ftqu5cCsKt0XFUTrO9PwChkHyVdILQADqGb+IULsJY+5gEhTJfjmjfj1ywSUlMFRky51tbcNn+CpQVyv1mPi0wpoqUrukRJ1JYXlhFpB352lpfsrjLeYSyM99oqgya4QA+rHliZlJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734031777; c=relaxed/simple;
	bh=WYoQMRv5P87I4hjtnXW8jZn4JiuWP9wJLhfOJzWWED8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Lb3jUZVJyNcHkpqYeVOQPNfL+449gsR1gZ7RltnfYyebupl25hBlolCKGEKysLQtvbyewlV5M9IYqTFXWqO4dEp270mIlxYBIWhH/SZnfwpun5YuFDwQWtqdz9hOjSUCEu5vWYftBWodLxXBmYpK+HlLE5zM1GD1CmSqZG18vJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8Cw2aVs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF19C4CECE;
	Thu, 12 Dec 2024 19:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734031776;
	bh=WYoQMRv5P87I4hjtnXW8jZn4JiuWP9wJLhfOJzWWED8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=d8Cw2aVsk35SPPPau+WmwKHftXtxOtBGxzABqjUp3VewkjoIOKo8B2KXqKje+JVSP
	 djTBvJiul67mWCuDNPW4/7UmW1JpZA0Oe5fd7eFxyNc9E3jTYVs++scwAbEKvN2iio
	 ASWerK5IzlxQVYyY4PM1IgFrHu0PGaU7uXur0la91TTLygMlSjhi0SElqDcrayVRMc
	 0tYs1Hf43YjllDIP7BU4vZCfLJYJF9u51IjbOaLqSBjARf2gjtT5Lvj9TK90DQ5pmV
	 rzwfJOkKAeZX8PAqSxmH3Y12S6t6PJiSyxTumghytGk8wMXEJrBvzc6gMccg5kHs/2
	 saRXMHh0KSqZQ==
Date: Thu, 12 Dec 2024 13:29:35 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Philipp Stanner <pstanner@redhat.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>
Cc: amien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Dubov <oakad@yahoo.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
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
Subject: Re: [PATCH v3 09/11] wifi: qtnfmac: use always-managed version of
 pcim_intx()
Message-ID: <20241212192935.GA3360239@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209130632.132074-11-pstanner@redhat.com>

[cc->to: Igor]

On Mon, Dec 09, 2024 at 02:06:31PM +0100, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> port users to either an always-managed or a never-managed version.
> 
> qtnfmac enables its PCI-Device with pcim_enable_device(). Thus, it needs
> the always-managed version.
> 
> Replace pci_intx() with pcim_intx().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> Acked-by: Kalle Valo <kvalo@kernel.org>

Hoping for an ack from Igor, too.

> ---
>  drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> index f66eb43094d4..3adcfac2886f 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
> @@ -204,7 +204,7 @@ static void qtnf_pcie_init_irq(struct qtnf_pcie_bus_priv *priv, bool use_msi)
>  
>  	if (!priv->msi_enabled) {
>  		pr_warn("legacy PCIE interrupts enabled\n");
> -		pci_intx(pdev, 1);
> +		pcim_intx(pdev, 1);
>  	}
>  }
>  
> -- 
> 2.47.1
> 

