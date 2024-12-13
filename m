Return-Path: <kvm+bounces-33687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5879F0427
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 06:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE26616A298
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 05:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C765C18A6D7;
	Fri, 13 Dec 2024 05:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bw4/mjm1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD8679F5;
	Fri, 13 Dec 2024 05:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067563; cv=none; b=tDUI9nfiQaKi+grH21AcKQ1JxeNRuftcT95DkRAhAHZuRJgq7g+OAd60Lg7+CVqOhBvU9Yds9wVyQue0AoXcF1ECLvRjksRbvCAHkIdzKPx7KN2Gx8Mly4I5fHcQGtwAESs2yjMgopCBC0fLVmw1pjH3d2PVheMBBvecCGudjdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067563; c=relaxed/simple;
	bh=M2xdmdLNhUnONPFOKg4DD+NknFYDEaK+x9KyPHrv24s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJye4tLFOdtdtJRylVIdQ4swmLY/OK3kSO2urkQcPjcal6j87Mjdp1IVM0b8DA19An3kk4HkmEGFZXWi+UbPJYzPohvPHb1X+GJdzWpf7taYDwOFxTQGhGtV7lHtIvK4tx8JeRqKY+0YW6hmfm5UX2ki3Gh5OTj16nt1TS6RxF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bw4/mjm1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D513C4CED1;
	Fri, 13 Dec 2024 05:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734067562;
	bh=M2xdmdLNhUnONPFOKg4DD+NknFYDEaK+x9KyPHrv24s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bw4/mjm10HI4gIYEq6PcUyF1AyHtdTx8xY1u9mQ/MqJN77zbADAxHBaxyRlLd3fvm
	 K+xp87WmOhOZL0i+Bq0ipg5X8v20dbpQflvkGqWjrmRLY/0GuREkoyHJNVYE+cNf5x
	 z8LCuZGHvDXUpEOFv59Bb7IqvPJLfr+Ey53P+W4LJrWqp6nhL8os12GgjvLuqPfWM7
	 tQzQgeo6YclbvdVoVzle3X83Llu3G9oxPWspWAnjZkdc3+GZOJaUxSQ04u5mGgaPm3
	 thWesm1LM0XsGyHp4VpoNWDNgdZGRIRa8iRReDoOdNpvWyxV8vC93Zm54QQh6yd+QZ
	 BUiwJG/w6t0xg==
Date: Fri, 13 Dec 2024 06:25:47 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Philipp Stanner <pstanner@redhat.com>,
	amien Le Moal <dlemoal@kernel.org>,
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
Message-ID: <Z1vFWyHkBD4d5xnG@ryzen>
References: <20241209130632.132074-2-pstanner@redhat.com>
 <20241212192118.GA3359591@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212192118.GA3359591@bhelgaas>

On Thu, Dec 12, 2024 at 01:21:18PM -0600, Bjorn Helgaas wrote:
> On Mon, Dec 09, 2024 at 02:06:22PM +0100, Philipp Stanner wrote:
> 
> Applied the ones with maintainer acks to pci/devres for v6.14, thanks!

I don't see this on:
https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/

Did you perhaps forget to push?


Kind regards,
Niklas

