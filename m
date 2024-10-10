Return-Path: <kvm+bounces-28405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04C61998187
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 152F51C2694B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBE01BC078;
	Thu, 10 Oct 2024 09:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ma16Iqar"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F41C7E765;
	Thu, 10 Oct 2024 09:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728551017; cv=none; b=p5nF10Uph7OkYx3tW5eVrFy/FFV1F5p0bJfRBjZtZy5R773R9IONA2w36chRPE4xChdmqxDeCE5mhKEIC2w4SNVE9Tg51WKjAqxpY8JX7i8skQWxRrZ5AW91C4iNrmY3wVgux88rE7LA4dx3qrsDOR+pz6niG03vz39sm0gS2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728551017; c=relaxed/simple;
	bh=qIga4ENKvNDSpomy+u9cYcJeIt2znVA3OvUMUn8Vt00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ixm5ONYehhGK5Cg2sHEP249mMbZtKoA/AelPpVKighJmu4VrJg3SrTrMNPKVNRHD7UPS97cLzgAmIuhpDwQl3MpqcthBg8NIx884NfjdOAjg2A9TTl2lNG2SjDQwFxtjijT33k/ShiLzZxBdMOnN1PG8NNsRv6hHv5E4ZdESxt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ma16Iqar; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CC3C4CEC5;
	Thu, 10 Oct 2024 09:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728551016;
	bh=qIga4ENKvNDSpomy+u9cYcJeIt2znVA3OvUMUn8Vt00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ma16Iqar46lFxN+U2JAe5vdwsOfrFSCv51iNGmJlzaeAsMcNWERh9kaZfcgmAlIsn
	 7oz09EjJd/j2moVcv8Qezht0w8lMm2GuIu9huksqREaTjb8+PZCZvolwVMZIoA3XXU
	 MiZzJ+yW2KdX7Yc9d7XcuMS6Gb4qyxLjxlOU9iVM=
Date: Thu, 10 Oct 2024 11:03:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Philipp Hortmann <philipp.g.hortmann@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Alex Dubov <oakad@yahoo.com>,
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
	Mario Limonciello <mario.limonciello@amd.com>,
	Chen Ni <nichen@iscas.ac.cn>, Ricky Wu <ricky_wu@realtek.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Breno Leitao <leitao@debian.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Soumya Negi <soumya.negi97@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>,
	Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	Marc Zyngier <maz@kernel.org>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	ntb@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-staging@lists.linux.dev, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-sound@vger.kernel.org
Subject: Re: [RFC PATCH 10/13] staging: rts5280: Use always-managed version
 of pci_intx()
Message-ID: <2024101006-chump-image-e65c@gregkh>
References: <20241009083519.10088-1-pstanner@redhat.com>
 <20241009083519.10088-11-pstanner@redhat.com>
 <2024100936-brunette-flannels-0d82@gregkh>
 <411f3c94-58b5-471e-bc58-e23d89d2078f@gmail.com>
 <b57dbf0c83125d58e4e2b488b5b5f71410fd8d6a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b57dbf0c83125d58e4e2b488b5b5f71410fd8d6a.camel@redhat.com>

On Thu, Oct 10, 2024 at 10:03:30AM +0200, Philipp Stanner wrote:
> On Wed, 2024-10-09 at 21:41 +0200, Philipp Hortmann wrote:
> > On 10/9/24 11:38, Greg Kroah-Hartman wrote:
> > > On Wed, Oct 09, 2024 at 10:35:16AM +0200, Philipp Stanner wrote:
> > > > pci_intx() is a hybrid function which can sometimes be managed
> > > > through
> > > > devres. To remove this hybrid nature from pci_intx(), it is
> > > > necessary to
> > > > port users to either an always-managed or a never-managed
> > > > version.
> > > > 
> > > > rts5208 enables its PCI-Device with pcim_enable_device(). Thus,
> > > > it needs the
> > > > always-managed version.
> > > > 
> > > > Replace pci_intx() with pcim_intx().
> > > > 
> > > > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> > > > ---
> > > >   drivers/staging/rts5208/rtsx.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > 
> > Hi Philipp,
> > 
> > this driver (rts5208) will be removed soon - patch is send in.
> > 
> > Discussion about removal:
> > https://lore.kernel.org/linux-staging/2024100943-shank-washed-a765@gregkh/T/#t
> 
> 
> Alright, thx for the heads up.
> 
> I'm not entirely how best to deal with that, though. I could drop this
> patch, but then the driver would end up with an unmanaged pci_intx().
> 
> Might this be a problem for users if my series lands sooner than the
> removal, say in v6.13 and your removal in v6.14?

The removal will happen in 6.13, I'm going to be queueing it up right
now.

thanks,

greg k-h

