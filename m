Return-Path: <kvm+bounces-33759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE1569F146B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 18:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0156280E6D
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199F81E7668;
	Fri, 13 Dec 2024 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsGwzCps"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEF3187FFA;
	Fri, 13 Dec 2024 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734112431; cv=none; b=Y5Uplpsd5HFc7QAKP0H6ZLhlhukl7L8K5m8IvH/fpmotA4wyoLjoxx2BmyMGfRe2hh4lrNu3xiAvtpu2PpO8bw6XVNZegVHmqFdN0ndh5kJsKtWEvbFi1pCwBz99pbeg88yI4Vav2eafIADm10pXdgNaC8ThQ1V9cjCd61BEDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734112431; c=relaxed/simple;
	bh=giLsrBe+eXIr2Z5RCc4V156ArPFV4LhVw7wYhIzIoXE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=TjxITHd02ehDSerFxudBlFZyRpdunAWlFjdwEpTml/F3ia7cY54S+XaZBEMNQArNH9g/91aQh+x/zgF2CC+HvFbYHuCSM546jDCbcmwUWegQ2wiKaR03J3dZoh8r0fBaOxGQxgCUfq0gjYoOoF9ETeTC8uZnzLx3jXWTxUvScTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsGwzCps; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6830CC4CED0;
	Fri, 13 Dec 2024 17:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734112430;
	bh=giLsrBe+eXIr2Z5RCc4V156ArPFV4LhVw7wYhIzIoXE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=dsGwzCpsHyKSEp5dYNZqIU7VIPCf1+1BvfLnsNExHvF+KgHEKWxdDya2OH4Yb1KdO
	 xjyNZsn9LGsL+5ubm9YwLy6PfO1o9HHK4GH9HnfKOzJfFxn/wgTn1u4o1aUgnAXEWn
	 GkW8WT5ub+1C8izqxGJm68p92qbUmH0Zz6j12LSWYDuKvCO0PKAmAIFG8J70k4DM58
	 BkmbpSUnFf6MODuN2bFpAw11s14p/2yDMhpzWn6yJuuKNDwnCnEugjbstu3jKrQ4hZ
	 YZx0beo5hpke+CycdWaTs127pteqlLsHIM7BixvuD11GKP+6nU5Tvb5YUerVZXNZPP
	 DkNTiHRBWPZvw==
Date: Fri, 13 Dec 2024 11:53:49 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: Philipp Stanner <pstanner@redhat.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	amien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
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
	Sanjay R Mehta <sanju.mehta@amd.com>,
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
	xen-devel@lists.xenproject.org,
	Igor Mitsyanko <i.mitsyanko@gmail.com>
Subject: Re: [PATCH v3 09/11] wifi: qtnfmac: use always-managed version of
 pcim_intx()
Message-ID: <20241213175349.GA3421319@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cyhvoox9.fsf@kernel.org>

[+cc personal address for Igor]

On Fri, Dec 13, 2024 at 12:30:42PM +0200, Kalle Valo wrote:
> Bjorn Helgaas <helgaas@kernel.org> writes:
> 
> > [cc->to: Igor]
> >
> > On Mon, Dec 09, 2024 at 02:06:31PM +0100, Philipp Stanner wrote:
> >> pci_intx() is a hybrid function which can sometimes be managed through
> >> devres. To remove this hybrid nature from pci_intx(), it is necessary to
> >> port users to either an always-managed or a never-managed version.
> >> 
> >> qtnfmac enables its PCI-Device with pcim_enable_device(). Thus, it needs
> >> the always-managed version.
> >> 
> >> Replace pci_intx() with pcim_intx().
> >> 
> >> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> >> Acked-by: Kalle Valo <kvalo@kernel.org>
> >
> > Hoping for an ack from Igor, too.
> 
> Igor hasn't been around for a while so I'm not expecting see an ack from
> him, I think the whole qtnfmac driver should be removed in the future.
> Feel free to take the patch as is.

Thanks, Kalle, will do.

