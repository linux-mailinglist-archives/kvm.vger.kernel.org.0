Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F434197E2
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbhI0P2t convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 27 Sep 2021 11:28:49 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3882 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbhI0P2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:28:48 -0400
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HJ5yZ1zygz67y04;
        Mon, 27 Sep 2021 23:24:06 +0800 (CST)
Received: from lhreml711-chm.china.huawei.com (10.201.108.62) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 27 Sep 2021 17:27:08 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml711-chm.china.huawei.com (10.201.108.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 27 Sep 2021 16:27:07 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Mon, 27 Sep 2021 16:27:07 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHXqhdQM13RiELH60aUjxjG41fnUKulAGMAgAAGK3CAAZpfgIARVJdwgAAGl4CAABbuYA==
Date:   Mon, 27 Sep 2021 15:27:07 +0000
Message-ID: <5570187c4a0a4da6969c0dba7aaaab5b@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
 <a440256250c14182b9eefc77d5d399b8@huawei.com>
 <20210927150119.GB964074@nvidia.com>
In-Reply-To: <20210927150119.GB964074@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.80.194]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 27 September 2021 16:01
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> Leon Romanovsky <leonro@nvidia.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> mgurtovoy@nvidia.com; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
> migration
> 
> On Mon, Sep 27, 2021 at 01:46:31PM +0000, Shameerali Kolothum Thodi
> wrote:
> 
> > > > > Nope, this is locked wrong and has no lifetime management.
> > > >
> > > > Ok. Holding the device_lock() sufficient here?
> > >
> > > You can't hold a hisi_qm pointer with some kind of lifecycle
> > > management of that pointer. device_lock/etc is necessary to call
> > > pci_get_drvdata()
> >
> > Since this migration driver only supports VF devices and the PF
> > driver will not be removed until all the VF devices gets removed,
> > is the locking necessary here?
> 
> Oh.. That is really busted up. pci_sriov_disable() is called under the
> device_lock(pf) and obtains the device_lock(vf).
> 
> This means a VF driver can never use the device_lock(pf), otherwise it
> can deadlock itself if PF removal triggers VF removal.

Exactly. I can easily simulate that in this driver.

> 
> But you can't access these members without using the device_lock(), as
> there really are no safety guarentees..

Hmm.. I was hoping that we can avoid holding the lock since
we are sure of the PF driver behavior. But right, there are no
guarantee here.

> The mlx5 patches have this same sketchy problem.
> 
> We may need a new special function 'pci_get_sriov_pf_devdata()' that
> confirms the vf/pf relationship and explicitly interlocks with the
> pci_sriov_enable/disable instead of using device_lock()
> 
> Leon, what do you think?
> 

Thanks,
Shameer
