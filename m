Return-Path: <kvm+bounces-5725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB3582574C
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 16:56:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55D31B233B0
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 15:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72FC2E831;
	Fri,  5 Jan 2024 15:56:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DA62E824;
	Fri,  5 Jan 2024 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4T67Lr1f5hz1Q6cn;
	Fri,  5 Jan 2024 23:54:44 +0800 (CST)
Received: from dggems704-chm.china.huawei.com (unknown [10.3.19.181])
	by mail.maildlp.com (Postfix) with ESMTPS id 560911800C6;
	Fri,  5 Jan 2024 23:56:12 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 23:56:11 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Fri, 5 Jan 2024 15:56:09 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Linuxarm <linuxarm@huawei.com>, liulongfang
	<liulongfang@huawei.com>
Subject: RE: [PATCH] hisi_acc_vfio_pci: Update migration data pointer
 correctly on saving/resume
Thread-Topic: [PATCH] hisi_acc_vfio_pci: Update migration data pointer
 correctly on saving/resume
Thread-Index: AQHaG5IKSxqx627vikqShB0juPG9VbCDRMsAgEhisBA=
Date: Fri, 5 Jan 2024 15:56:09 +0000
Message-ID: <12f92affadf34f048a2eb2e7e9ecd879@huawei.com>
References: <20231120091406.780-1-shameerali.kolothum.thodi@huawei.com>
 <20231120142928.GC6083@nvidia.com>
In-Reply-To: <20231120142928.GC6083@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Alex,

Just a gentle ping on this.=20

Thanks,
Shameer

> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, November 20, 2023 2:29 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> alex.williamson@redhat.com; yishaih@nvidia.com; kevin.tian@intel.com;
> Linuxarm <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>
> Subject: Re: [PATCH] hisi_acc_vfio_pci: Update migration data pointer cor=
rectly
> on saving/resume
>=20
> On Mon, Nov 20, 2023 at 09:14:06AM +0000, Shameer Kolothum wrote:
> > When the optional PRE_COPY support was added to speed up the device
> > compatibility check, it failed to update the saving/resuming data
> > pointers based on the fd offset. This results in migration data
> > corruption and when the device gets started on the destination the
> > following error is reported in some cases,
> >
> > [  478.907684] arm-smmu-v3 arm-smmu-v3.2.auto: event 0x10 received:
> > [  478.913691] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000310200000010 [
> > 478.919603] arm-smmu-v3 arm-smmu-v3.2.auto:  0x000002088000007f [
> > 478.925515] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000000000000000 [
> > 478.931425] arm-smmu-v3 arm-smmu-v3.2.auto:  0x0000000000000000 [
> > 478.947552] hisi_zip 0000:31:00.0: qm_axi_rresp [error status=3D0x1]
> > found [  478.955930] hisi_zip 0000:31:00.0: qm_db_timeout [error
> > status=3D0x400] found [  478.955944] hisi_zip 0000:31:00.0: qm sq
> > doorbell timeout in function 2
> >
> > Fixes: d9a871e4a143 ("hisi_acc_vfio_pci: Introduce support for
> > PRE_COPY state transitions")
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Jason

