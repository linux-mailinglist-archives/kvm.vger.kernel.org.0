Return-Path: <kvm+bounces-33583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 186429EE97B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 15:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9614D281115
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 14:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E3321765E;
	Thu, 12 Dec 2024 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4ieOnsN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F6A2135AC
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 14:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015520; cv=none; b=prPwr+ad6da/t0aqDUb+i3uHrFAdKV3KcRuyXSCf5WwYy0zAHJefNB9Ixw5yZZyvQpI1evfuWRt/hVxw/CgdACj5SNMjZ0iHjvFCwayF9c8vYqKZ5HLFbd58jhqG4cKrYSxBDBvwrI09bGTgfb88EHaqd+wVbrS0LHc+QXzzQSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015520; c=relaxed/simple;
	bh=G6Z2o7H+YRsuJn5EHuxMgQuZNMoz/Zu4aqlYRNiWXyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IPrCEQE4K2RocEIAeBslrZf1QSJoP7JjiPJLvf//UyL/9GYd9uAYGsnEWi2pXBWffTDkoB/xAen25The4WzGPaAHmAitD9TIMmJIwzT/EF+mSrx/R2qafCeiq5phxxBwh2jssmit5P7G8LMGiYAbTsY92OI8nhveSds4gjTgOFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q4ieOnsN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734015518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mp7PByfrT26c6XlUU6lXZIxvrN1DU5qMvcLQpbxnk5A=;
	b=Q4ieOnsNtSrfUI+gNJ5dX/tEjo8dMVfuODtCVZfS6FOyjIt7UwqTlZwA+WjS2euJkvEA76
	6vOZLCCO0bldypzGkBwqRdSBgFbnuSyf2KQXfuEUfr0Q2xIodsWHV9wGw5yLybhHVKVOw1
	mrV+fa+GsdI0Mw0Mjd2g//eXko3EqNg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-2Xo9XowLOwKWPZDvIT2TvA-1; Thu, 12 Dec 2024 09:58:35 -0500
X-MC-Unique: 2Xo9XowLOwKWPZDvIT2TvA-1
X-Mimecast-MFC-AGG-ID: 2Xo9XowLOwKWPZDvIT2TvA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361d4e8359so5684985e9.3
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 06:58:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734015514; x=1734620314;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mp7PByfrT26c6XlUU6lXZIxvrN1DU5qMvcLQpbxnk5A=;
        b=kkYG0Nmz5Ux6gUgJionBTQctBdxYFZnTvw7zTGjVfJfJWLWdcHu1g1D0U39JhhxDyd
         G+KtWUURlMAqjVpx965Y+AN9ILsfNfShyh1s+PqtbTDSLL2QLCrNqy3u1eQn4hBo0+mb
         9nyP1PDRqIeSklTqNqQBgZgEfKF7Oj7DBf/Kfy2J6bblDZoPb6fkGAJ1sTOwi8OcKiH+
         kY65Sif5adKONOpbFLk2V/ngUuon9PjzMIfCOWKWt8ZatWbAr2G/E2qFZQyXsGLV5Uy/
         /UakL9W12VlwrEu09bxGYeM96xijEij1b374xBUfzIoDgw+SLMuwTk05wJ7RSlc8JeWV
         UCyA==
X-Forwarded-Encrypted: i=1; AJvYcCXLkmWLznSxxw3sQ7zP6jp6xJY456VAcFTFEWUaRwMZqKMjkORI4z+S7L5+cN7DlJtK0Zk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzSyI4tDWV3UW6iFvrc1IRpsLgDhIi+1fs13/eeks48oLSE4VP
	fcRlvojz1djIwBS2W2/jwnMavZjTL3618zpiBThJNkvt5uCLbrDp/YSrzhFpkEpLN1uWtNgiam5
	Id3419fGURhylQmlAMppMx4iuUzOiTu1Qf6L/YWMVSDxlWaFVow==
X-Gm-Gg: ASbGnct1FMn42GbV95ahQTdefJ+nAEwRSc0Z8qFDWca1g0aG1NUJ5jZzNeThRLdQv59
	gbaJTFCftkrzfpoi+5CFLoHUEZyHFrPJvAtejbrUTBpJmWkGzQTt9unpcvjvnSI+XVOwJV5cOie
	3BrAStk8jEzWsdf+g0IJ+xYBEbFzkbpAW5iZ1wmSwRvP1mOAoD39+7T2VHJ4lnRxQpWlWViblAn
	HmAs7L/OGXledxtw0iM9ZxWJ2rJc5Uo6KjcopT2ZxkR0QoytwMaK+hR4+8UdGtFzquxxqmTfZ+6
	A6ai8Ho=
X-Received: by 2002:a05:600c:1e89:b0:435:21a1:b109 with SMTP id 5b1f17b1804b1-436228239d4mr34776045e9.2.1734015514529;
        Thu, 12 Dec 2024 06:58:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHoQPXURHNGvrny3f7vl2oVT9jWXY7D4FX6dkSlxmx2R9PGBk/+viTtA90lBPMFXjybTLaFQQ==
X-Received: by 2002:a05:600c:1e89:b0:435:21a1:b109 with SMTP id 5b1f17b1804b1-436228239d4mr34775655e9.2.1734015514130;
        Thu, 12 Dec 2024 06:58:34 -0800 (PST)
Received: from [192.168.88.24] (146-241-48-67.dyn.eolo.it. [146.241.48.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4362559edc3sm19213025e9.22.2024.12.12.06.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 06:58:33 -0800 (PST)
Message-ID: <a6d7a4ee-929e-4bee-80bf-a7b4f4f89f4a@redhat.com>
Date: Thu, 12 Dec 2024 15:58:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/11] Remove devres from pci_intx()
To: Philipp Stanner <pstanner@redhat.com>, amien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Basavaraj Natikar <basavaraj.natikar@amd.com>, Jiri Kosina
 <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov
 <oakad@yahoo.com>, Sudarsana Kalluru <skalluru@marvell.com>,
 Manish Chopra <manishc@marvell.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Rasesh Mody <rmody@marvell.com>,
 GR-Linux-NIC-Dev@marvell.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Sanjay R Mehta <sanju.mehta@amd.com>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>,
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Alex Williamson <alex.williamson@redhat.com>, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Chen Ni <nichen@iscas.ac.cn>,
 Ricky Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Breno Leitao <leitao@debian.org>, Thomas Gleixner <tglx@linutronix.de>,
 Kevin Tian <kevin.tian@intel.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yi Liu <yi.l.liu@intel.com>, Kunwu Chan <chentao@kylinos.cn>,
 Dan Carpenter <dan.carpenter@linaro.org>,
 "Dr. David Alan Gilbert" <linux@treblig.org>,
 Ankit Agrawal <ankita@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20241209130632.132074-2-pstanner@redhat.com>
 <20241209130632.132074-13-pstanner@redhat.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241209130632.132074-13-pstanner@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/9/24 14:06, Philipp Stanner wrote:
> pci_intx() is a hybrid function which can sometimes be managed through
> devres. This hybrid nature is undesirable.
> 
> Since all users of pci_intx() have by now been ported either to
> always-managed pcim_intx() or never-managed pci_intx_unmanaged(), the
> devres functionality can be removed from pci_intx().
> 
> Consequently, pci_intx_unmanaged() is now redundant, because pci_intx()
> itself is now unmanaged.
> 
> Remove the devres functionality from pci_intx(). Have all users of
> pci_intx_unmanaged() call pci_intx(). Remove pci_intx_unmanaged().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> ---
>  drivers/misc/cardreader/rtsx_pcr.c            |  2 +-
>  drivers/misc/tifm_7xx1.c                      |  6 +--
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
>  drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
>  drivers/ntb/hw/amd/ntb_hw_amd.c               |  4 +-
>  drivers/ntb/hw/intel/ntb_hw_gen1.c            |  2 +-
>  drivers/pci/devres.c                          |  4 +-
>  drivers/pci/msi/api.c                         |  2 +-
>  drivers/pci/msi/msi.c                         |  2 +-
>  drivers/pci/pci.c                             | 43 +------------------
>  drivers/vfio/pci/vfio_pci_core.c              |  2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c             | 10 ++---
>  drivers/xen/xen-pciback/conf_space_header.c   |  2 +-
>  include/linux/pci.h                           |  1 -
>  14 files changed, 22 insertions(+), 62 deletions(-)

For the net bits:

Acked-by: Paolo Abeni <pabeni@redhat.com>


