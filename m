Return-Path: <kvm+bounces-28970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0179A00DF
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 07:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 142F81F222F9
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 05:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E8518C33A;
	Wed, 16 Oct 2024 05:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTPd17kq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263B718BC0B;
	Wed, 16 Oct 2024 05:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729057189; cv=none; b=On8qLn5+FETXyfi/dJjiU5YUmQEJuHmsmF6amDUJCtgrFnqI7yyqSLk5z7n25o6/jsIU+f8gdTShlhy2kQUOK2TWFsKDh/xIsYIDPVWPY3n50xFPIinw7hqHOngWoAvNJ33iqNfD77OL89Qml0HhQu6r/U8zez9vJ/4FGz2xlv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729057189; c=relaxed/simple;
	bh=Bd5M4DzFMNGGadIfi1fklC0+ZqtBunY0WkA0awItZsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9Oj/71ClAwjO5Y/W7bDuTvsHpGMP3oNta9KpmX7UrUKxQidQlVQVlw8jikgS9HWtRjsLvxQrzm6K9oLn5rfzxtjFBMdncOsQR8uv0pi5IVP+0Grb/zm6oJTs4GNaBonzfOk/X+DyY5nbxmmqQr4HKCxQYI3vFDrkTWlQ2Jm7KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTPd17kq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E85C4CEC5;
	Wed, 16 Oct 2024 05:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729057188;
	bh=Bd5M4DzFMNGGadIfi1fklC0+ZqtBunY0WkA0awItZsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UTPd17kqa+JStBo//drZQEXyhoDU5Ick9FOrbiK2kK6EtrjHt2psudKPkH6oC/JjU
	 UK7DuqgB1JR/yTVSIQJrmb20KHuDiQAI5hwh8cFhK/eWYqq9mtCIzMO4GOty2SoRF6
	 h+kDt3eL0NVejAHRkxFksFewisHYtyjgnG5HKBLU=
Date: Wed, 16 Oct 2024 07:39:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
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
	Chen Ni <nichen@iscas.ac.cn>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ricky Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Breno Leitao <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Yi Liu <yi.l.liu@intel.com>, Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Eric Auger <eric.auger@redhat.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>,
	Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>,
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
Message-ID: <2024101652-valium-gizzard-cf14@gregkh>
References: <20241015185124.64726-1-pstanner@redhat.com>
 <20241015185124.64726-14-pstanner@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015185124.64726-14-pstanner@redhat.com>

On Tue, Oct 15, 2024 at 08:51:23PM +0200, Philipp Stanner wrote:
> pci_intx() and its managed counterpart pcim_intx() only exist for older
> drivers which have not been ported yet for various reasons. Future
> drivers should preferably use pci_alloc_irq_vectors().
> 
> Mark pci_intx() and pcim_intx() as deprecated and encourage usage of
> pci_alloc_irq_vectors() in its place.

No one is going to notice these comments, so please, if this really does
need to be removed, just remove it from all callers and delete the
function from the tree.

thanks,

greg k-h

