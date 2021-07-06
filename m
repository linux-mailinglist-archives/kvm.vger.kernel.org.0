Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14CD3BC522
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 06:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhGFECg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 00:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhGFECf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 00:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC8961375;
        Tue,  6 Jul 2021 03:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625543998;
        bh=EBb836TUqwdFybd5e2qAGza9Mok0L1tjLS+MbMnBjN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ro2L/nJ4cUN3ER5i2dJBf/AoagWgvc7fTnq9wCDIWMaIK1/W4Fsl2yB0GSMy9mC0L
         D3ywytE827DeLQGb9bH5+zgKUENID8BWXwP7OgigfS++eWj34tKndOwKh1d6ACah7A
         HMjgnNxt8KkJ97fiXGIEQ4riZ9A6cfV+i6nd6Lce18CP8vCVXpYL4yaiUkrT7RX2kP
         ixKBJ1i36AsdX/evHWTr4u3uzEEsHHRoYXFG6Mr49SnegKfLZTkN2zNxBGGjX/vKew
         WgTvpmKmW/NF3DleCNOTTj0eisiOauD4DzjHiBGeetDA9i2g6R7XC4iwkEULdjNHLH
         6vPk8pBEd6jog==
Date:   Tue, 6 Jul 2021 06:59:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <YOPVOnRXPWGvloIT@unreal>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <YOFdTnlkcDZzw4b/@unreal>
 <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
 <d02dff3a-8035-ced1-7fc3-fcff791f9203@nvidia.com>
 <834a009bba0d4db1b7a1c32e8f20611d@huawei.com>
 <YONPGcwjGH+gImDj@unreal>
 <20210705183247.GU4459@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705183247.GU4459@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 05, 2021 at 03:32:47PM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 05, 2021 at 09:27:37PM +0300, Leon Romanovsky wrote:
> 
> > > I think, in any case, it would be good to update the Documentation based on
> > > which way we end up doing this.
> > 
> > The request to update Documentation can be seen as an example of
> > choosing not-good API decisions. Expectation to see all drivers to
> > use same callbacks with same vfio-core function calls sounds strange
> > to me.
> 
> It is not vfio-core, it is vfio-pci-core. It is similar to how some of
> the fops stuff works, eg the generic_file whatever functions everyone
> puts in.

It doesn't really matter if it is vfio-core or vfio-pci-core. This looks
horrible and it is going to be repeated for every driver:

+       .release        = vfio_pci_core_release,
+       .ioctl          = vfio_pci_core_ioctl,
+       .read           = vfio_pci_core_read,
+       .write          = vfio_pci_core_write,
+       .mmap           = vfio_pci_core_mmap,
+       .request        = vfio_pci_core_request,
+       .match          = vfio_pci_core_match,
+       .reflck_attach  = vfio_pci_core_reflck_attach,
+};

At some point of time you will add new .XXX callback and will
find yourself changing all drivers to have something like
".XXX = vfio_pci_core_XXX,"

Thanks
