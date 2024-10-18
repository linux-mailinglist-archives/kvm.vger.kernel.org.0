Return-Path: <kvm+bounces-29186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D249A4A3D
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2024 01:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73D7228243D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 23:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA2D191F97;
	Fri, 18 Oct 2024 23:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evtxctpR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75011817;
	Fri, 18 Oct 2024 23:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729295139; cv=none; b=OmiOMG8Lys/smUXmH59CeiZe0fgD2Tu+J9+rCerZ5N3b5erD1Op3kUalu3z0Iaj+gyPrvqpNYBZYSXiLCT0BAvCoiZqVrZEZIid2W3b0oSzrOXEbfcRZW/7+jCk2j16fEts/ibTfYGKnJ8stHR6bpx+RszoKeFHZPY74/5IB9hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729295139; c=relaxed/simple;
	bh=lFZnjV8RlVPG6PrVOgGg9hgB2Ob3uus6nsFdYXxg0xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=TcCmc9xGp5zi+KyatlAp1nCUjrl7OhoX5KPxHwT9SPd8wUmeRdsJZPurUONEIEzZVv+xr1UyvGmyQwPFvFT0EvQU8PUS0O/FqQ1v46ZBKds9MxQuwhAx6v8esadfO+poUJaiyGyCccxH4pzs9jmkIdmJwzVeUdMTjrOARFzipLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evtxctpR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6996C4CEC3;
	Fri, 18 Oct 2024 23:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729295139;
	bh=lFZnjV8RlVPG6PrVOgGg9hgB2Ob3uus6nsFdYXxg0xQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=evtxctpRyaoTSOigJT5cFz8FlzinZ4CiqIbWurTmKrRfQkXyPwANmEAW+wstE4BGx
	 TIN4rKkxFq5bRqf1RYbu8X5+GaKP8PCUkJCSI7XdnVuPyggqqCKegX2g9xYIK1RWWo
	 +b0kx6X/7xFOXGXdvbNco/L2DpCtD2beey4jXYhDZqcjQ6tHOX7X1U5wq38aQ9bZXw
	 j4FYzQwUpZeifU9a96tVVuahIFbm86NthAcccPlNw2GRZ0nybq3IyuM42izSzAVkj8
	 T19Q5jWyld7A4Ht/0K1UYHtBeST5LII4RfUrhhhbZUkSRif8tr3x1ApUVAUGVSTvJT
	 Ma/8xyjaHk33A==
Date: Fri, 18 Oct 2024 18:45:37 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
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
Subject: Re: [PATCH 13/13] PCI: Deprecate pci_intx(), pcim_intx()
Message-ID: <20241018234537.GA770692@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f871a77fb51e54332886882e8ecb1a4a5f5d296b.camel@redhat.com>

On Wed, Oct 16, 2024 at 10:53:16AM +0200, Philipp Stanner wrote:
> On Wed, 2024-10-16 at 10:43 +0200, Heiner Kallweit wrote:
> > On 16.10.2024 08:57, Philipp Stanner wrote:
> > > On Tue, 2024-10-15 at 13:53 -0600, Alex Williamson wrote:
> > > > On Tue, 15 Oct 2024 20:51:23 +0200
> > > > Philipp Stanner <pstanner@redhat.com> wrote:
> > > > 
> > > > > pci_intx() and its managed counterpart pcim_intx() only exist
> > > > > for
> > > > > older
> > > > > drivers which have not been ported yet for various reasons.
> > > > > Future
> > > > > drivers should preferably use pci_alloc_irq_vectors().
> > > > > 
> > > > > Mark pci_intx() and pcim_intx() as deprecated and encourage
> > > > > usage
> > > > > of
> > > > > pci_alloc_irq_vectors() in its place.
> > > > 
> > > > I don't really understand this.  As we've discussed previously
> > > > pci_alloc_irq_vectors() is, unsurprisingly, for allocating PCI
> > > > IRQ
> > > > vectors while pci_intx() is for manipulating the INTx disable bit
> > > > on
> > > > PCI devices.  The latter is a generic mechanism for preventing
> > > > PCI
> > > > devices from generating INTx, regardless of whether there's a
> > > > vector
> > > > allocated for it.  How does the former replace the latter and why
> > > > do
> > > > we
> > > > feel the need to deprecate the latter?
> > > > 
> > > > It feels like this fits some narrow narrative and makes all users
> > > > of
> > > > these now deprecated functions second class citizens.  Why?  At
> > > > it's
> > > > root these are simply providing mask and set or mask and clear
> > > > register
> > > > bit operations.  Thanks,
> > > 
> > > I got the feeling from the RFC discussion that that was basically
> > > the
> > > consensus: people should use pci_alloc_irq_vectors(). Or did I
> > > misunderstand Andy and Heiner?
> > > 
> > I think there are two different use cases for pci_intx().
> > At first there are several drivers where the direct usage of
> > pci_intx()
> > can be eliminated by switching to the pci_alloc_irq_vectors() API.
> > 
> > And then there's usage of pci_intx() in
> > drivers/vfio/pci/vfio_pci_intrs.c
> > drivers/xen/xen-pciback/conf_space_header.c
> > There we have to keep the (AFAICS unmanaged) pci_intx() calls.
> 
> There is also the usage within PCI itself, in MSI. Patch №8 touches
> that.
> 
> It's why I think this series should land before anyone should port
> direct pci_intx() users to the irq vectors function, because the latter
> also uses pci_intx() and its own devres, which sounds explosive to me.
>
> > > I'm perfectly happy with dropping this patch and continue offering
> > > pci{m}_intx() to users, since after removing that hybrid hazzard I
> > > don't see any harm in them anymore.

So is the bottom line that we should drop *this* patch and apply the
rest of the series?

> > > > > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> > > > > ---
> > > > >  drivers/pci/devres.c | 5 ++++-
> > > > >  drivers/pci/pci.c    | 5 ++++-
> > > > >  2 files changed, 8 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
> > > > > index 6f8f712fe34e..4c76fc063104 100644
> > > > > --- a/drivers/pci/devres.c
> > > > > +++ b/drivers/pci/devres.c
> > > > > @@ -435,7 +435,7 @@ static struct pcim_intx_devres
> > > > > *get_or_create_intx_devres(struct device *dev)
> > > > >  }
> > > > >  
> > > > >  /**
> > > > > - * pcim_intx - managed pci_intx()
> > > > > + * pcim_intx - managed pci_intx() (DEPRECATED)
> > > > >   * @pdev: the PCI device to operate on
> > > > >   * @enable: boolean: whether to enable or disable PCI INTx
> > > > >   *
> > > > > @@ -443,6 +443,9 @@ static struct pcim_intx_devres
> > > > > *get_or_create_intx_devres(struct device *dev)
> > > > >   *
> > > > >   * Enable/disable PCI INTx for device @pdev.
> > > > >   * Restore the original state on driver detach.
> > > > > + *
> > > > > + * This function is DEPRECATED. Do not use it in new code.
> > > > > + * Use pci_alloc_irq_vectors() instead (there is no managed
> > > > > version, currently).
> > > > >   */
> > > > >  int pcim_intx(struct pci_dev *pdev, int enable)
> > > > >  {
> > > > > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > > > > index 7ce1d0e3a1d5..dc69e23b8982 100644
> > > > > --- a/drivers/pci/pci.c
> > > > > +++ b/drivers/pci/pci.c
> > > > > @@ -4477,11 +4477,14 @@ void pci_disable_parity(struct pci_dev
> > > > > *dev)
> > > > >  }
> > > > >  
> > > > >  /**
> > > > > - * pci_intx - enables/disables PCI INTx for device dev
> > > > > + * pci_intx - enables/disables PCI INTx for device dev
> > > > > (DEPRECATED)
> > > > >   * @pdev: the PCI device to operate on
> > > > >   * @enable: boolean: whether to enable or disable PCI INTx
> > > > >   *
> > > > >   * Enables/disables PCI INTx for device @pdev
> > > > > + *
> > > > > + * This function is DEPRECATED. Do not use it in new code.
> > > > > + * Use pci_alloc_irq_vectors() instead.
> > > > >   */
> > > > >  void pci_intx(struct pci_dev *pdev, int enable)
> > > > >  {
> > > > 
> > > 
> > > 
> > 
> 

