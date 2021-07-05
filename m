Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009E33BB7B7
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 09:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhGEHZA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 5 Jul 2021 03:25:00 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3351 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhGEHY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 03:24:59 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GJH4D4Skqz6FBdK;
        Mon,  5 Jul 2021 15:14:20 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 09:22:21 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 08:22:20 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Mon, 5 Jul 2021 08:22:20 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v2 2/4] hisi_acc_vfio_pci: Override ioctl method to limit
 BAR2 region size
Thread-Topic: [RFC v2 2/4] hisi_acc_vfio_pci: Override ioctl method to limit
 BAR2 region size
Thread-Index: AQHXbyj3vpz5WZg5PUaAeM5yVRE1zKswEt6AgAPrT3A=
Date:   Mon, 5 Jul 2021 07:22:20 +0000
Message-ID: <0b5ce067e86b46d78033d1d3694db529@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
        <20210702095849.1610-3-shameerali.kolothum.thodi@huawei.com>
 <20210702142937.5cbe366f.alex.williamson@redhat.com>
In-Reply-To: <20210702142937.5cbe366f.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.83.49]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: 02 July 2021 21:30
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; jgg@nvidia.com; mgurtovoy@nvidia.com;
> Linuxarm <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>;
> Zengtao (B) <prime.zeng@hisilicon.com>; yuzenghui
> <yuzenghui@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v2 2/4] hisi_acc_vfio_pci: Override ioctl method to limit
> BAR2 region size
> 
> On Fri, 2 Jul 2021 10:58:47 +0100
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > HiSilicon ACC VF device BAR2 region consists of both functional register
> > space and migration control register space. From a security point of
> > view, it's not advisable to export the migration control region to Guest.
> >
> > Hence, hide the migration region and report only the functional register
> > space.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  drivers/vfio/pci/hisi_acc_vfio_pci.c | 42 +++++++++++++++++++++++++++-
> >  1 file changed, 41 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> > index a9e173098ab5..d57cf6d7adaf 100644
> > --- a/drivers/vfio/pci/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> > @@ -12,6 +12,46 @@
> >  #include <linux/vfio.h>
> >  #include <linux/vfio_pci_core.h>
> >
> > +static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned
> int cmd,
> > +				    unsigned long arg)
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +
> > +	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> > +		struct pci_dev *pdev = vdev->pdev;
> > +		struct vfio_region_info info;
> > +		unsigned long minsz;
> > +
> > +		minsz = offsetofend(struct vfio_region_info, offset);
> > +
> > +		if (copy_from_user(&info, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (info.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> > +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> > +
> > +			/*
> > +			 * ACC VF dev BAR2 region(64K) consists of both functional
> > +			 * register space and migration control register space.
> > +			 * Report only the first 32K(functional region) to Guest.
> > +			 */
> > +			info.size = pci_resource_len(pdev, info.index) / 2;
> > +
> 
> Great, but what actually prevents the user from accessing the full
> extent of the BAR since you're re-using core code for read/write/mmap,
> which are all basing access on pci_resource_len()?  Thanks,

Ah..true. Missed that. I will add overrides for read/write/mmap and limit
the access.

Thanks,
Shameer

> 
> Alex
> 
> > +			info.flags = VFIO_REGION_INFO_FLAG_READ |
> > +					VFIO_REGION_INFO_FLAG_WRITE |
> > +					VFIO_REGION_INFO_FLAG_MMAP;
> > +
> > +			return copy_to_user((void __user *)arg, &info, minsz) ?
> > +					    -EFAULT : 0;
> > +		}
> > +	}
> > +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> > +}
> > +
> >  static int hisi_acc_vfio_pci_open(struct vfio_device *core_vdev)
> >  {
> >  	struct vfio_pci_core_device *vdev =
> > @@ -33,7 +73,7 @@ static const struct vfio_device_ops
> hisi_acc_vfio_pci_ops = {
> >  	.name		= "hisi-acc-vfio-pci",
> >  	.open		= hisi_acc_vfio_pci_open,
> >  	.release	= vfio_pci_core_release,
> > -	.ioctl		= vfio_pci_core_ioctl,
> > +	.ioctl		= hisi_acc_vfio_pci_ioctl,
> >  	.read		= vfio_pci_core_read,
> >  	.write		= vfio_pci_core_write,
> >  	.mmap		= vfio_pci_core_mmap,

