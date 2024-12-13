Return-Path: <kvm+bounces-33699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA19C9F0590
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:32:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B895F18858AF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7980719D886;
	Fri, 13 Dec 2024 07:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXws51p4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AE93207;
	Fri, 13 Dec 2024 07:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734075145; cv=none; b=HUihgheNum5cHsn6k2mbti28rtc/z3Ug4R0dl2Q8+8slhUKeS755Fp+s7+bYS8t457ukzuF875VgpFZlpMLq1+pWMiG+u3PNHwyzV7tM3Za3Qr++Hse0+ThJsml6UfMCK9LeVgU9ll1L/T0h6bcOZ5IOlugMwDc7RKMoposy5eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734075145; c=relaxed/simple;
	bh=KF2u61fFy2MhhhXHsq56NzRxS4bNBSmPrcwIzbiCk28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTt9bQ078C30Ko6QS3MosAWp1BX+ai+GNzNu16u5XMyrwBWgbR5YoXF6Wp2dOvWorYpefw3drqtiEsK/J18QX+fwziYfe7zQxXP04BFSCHS76P6hwiYGGvLRWBpr5hjjYFT0P6V5Ta1QLsaNsES3CUpP/r6z28ZqBgo1FGGx7+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXws51p4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C47C4CED0;
	Fri, 13 Dec 2024 07:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734075144;
	bh=KF2u61fFy2MhhhXHsq56NzRxS4bNBSmPrcwIzbiCk28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YXws51p4OlwPq738uGlipsQN5HV9ZVc0qBQtIDFJ/RVNPLGvtjmm8j7Lruy9AroPG
	 fwsqluHpE8hKxixfh9G9UkxLnr46YSpthgtDfA9vQaZk5drkqBVz90PEiil9zPChQB
	 04xHlVOMH3ZIXzCGOFptOxKKf9WCynUw3GeIuYZg=
Date: Fri, 13 Dec 2024 08:31:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Philipp Stanner <pstanner@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Alex Dubov <oakad@yahoo.com>, amien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
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
Message-ID: <2024121335-blooper-cognitive-04ec@gregkh>
References: <20241209130632.132074-7-pstanner@redhat.com>
 <20241212192637.GA3359920@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212192637.GA3359920@bhelgaas>

On Thu, Dec 12, 2024 at 01:26:37PM -0600, Bjorn Helgaas wrote:
> [cc->to: Arnd, Greg, Alex]
> 
> On Mon, Dec 09, 2024 at 02:06:27PM +0100, Philipp Stanner wrote:
> > pci_intx() is a hybrid function which can sometimes be managed through
> > devres. To remove this hybrid nature from pci_intx(), it is necessary to
> > port users to either an always-managed or a never-managed version.
> > 
> > cardreader/rtsx_pcr.c and tifm_7xx1.c enable their PCI-Device with
> > pci_enable_device(). Thus, they need the never-managed version.
> > 
> > Replace pci_intx() with pci_intx_unmanaged().
> > 
> > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> 
> Looking for ack from Arnd, Greg, Alex.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

