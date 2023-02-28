Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394BE6A592F
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjB1Mg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjB1MgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:36:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE272ED5A;
        Tue, 28 Feb 2023 04:36:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkZmWngh00THIO33Psbrl8/GQhH3sLbKvZxCElCd9oS0qNhxlz5Bz4gsfPoGFZF6KY4gAw98LU8kMZXyQiKVF39b0MIcd2lhZcY3Bp+CJP8WdLbPWSWQzJANuKtQlQiuuPU1tXRrIju5OY2Ql5IV+G06wUPMdG0a59a9aBIwPSo+EOWzzyZJZgh5TIVfajJFpS/b9TDKxlJ+5BUxWjjYisAlXLg0K0eAMdNKk+5HvPPhB9Lj+IYx74swTCw4mrCnLtwGOt8M7h/xkFbbLS6FzXxqNeZToUi0gRZ2FHDCzELC+6UF1BkWFMSu0VBvmZfZX6OwSGnG6e/z03omTGtIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnCk75Hv5dDPZzDPv7+X1qNHtbmhBc3a30j6g1p3cwI=;
 b=ltMz5ssmhD3CfzEMPjCfKJmlmqsgrTETWDVdUcyEyEW7qbmX6/wKHAkitHfEEzSUVtygki8tTHQV2phGrHtJxyH41/GKJ3D12ylnh25lQkADUHcX2zOjfFUSVPzyizG/hJ3wmteMiaSdkKO+omaSbn6wvg2JLQ3wW4YQ4tcbe+6plFDQuFXKjqdCCNP6dEzQz+9A/6NgpBSVbToLmovgBpglGicY6fjsJ1JEqau4vLvc088rw2UXr6cbsqv17SBiByE6uJYO0/a8TW5zOKxjFQ3UDVS/Jf0vj1IoidFhQ6GNorqd6VdkTd7ab+SK+qY6rzERnOMxdW65/Oyaxpft8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnCk75Hv5dDPZzDPv7+X1qNHtbmhBc3a30j6g1p3cwI=;
 b=hBiw/9LIeXwcQ3YsR7aVfER0LQPrX1Tg6ijhxQKApCSOj92+lLvxZznP3eMbxrHWLrLfqyPjCVdLspmKwpU1rXdC2dDnMMF+X6Fb7x1s74b1wH8za938OqkGoEi2Cp8jmGCxQ38qLt/lGF1Dsd5J3NRgD3G5O7wTiSOxocidFeHFX1mULDVNGxSate96of6JLDb0n4jgZMWylqm19QLCv2gdXXdK3qmMM0mJ45dMLwHLPCRWOTvTaRQaDx8vvwHGmFMS/1Kp5NxJ2CVkSPu9F/St1gVkQGnrcg/PtYKASjCRLO7D2Hkp74LJSJC4t3wh0gilJkvQr7c1KYq6Ol383g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8722.namprd12.prod.outlook.com (2603:10b6:806:373::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Tue, 28 Feb
 2023 12:36:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:36:20 +0000
Date:   Tue, 28 Feb 2023 08:36:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 18/19] vfio: Compile group optionally
Message-ID: <Y/31Q0KAAQITGW4d@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-19-yi.l.liu@intel.com>
 <DS0PR11MB75296779110F91EA7648F9E1C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75296779110F91EA7648F9E1C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:208:a8::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8722:EE_
X-MS-Office365-Filtering-Correlation-Id: 09eec8a2-f349-4c09-49b5-08db1988650f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZIxji0SDW+oddchPFdn12183onHWJBH4ogUC6wOOI2vrRV7H4Ey71Ctg9FznD4eYTB+ehqL0//6FO1r0Jzz/wKNrSaVyxvz/M0wx7oIdSeAnBq6imr4fRWkBtE9Q58w5tA9cscvqu/uk/Se0WaSGKmGASvodO7iBCMX8vNto2XdbUjgPsw0Ke/1BadG7dy9rxf7ZFfI9fKZlpu2UgtskEFq5RQXawErvmHKGL86hNOki6RTR526FPPuCRBVJmDmEANdw3DN6UNC7TBAGxFsEVJEFRqXvaZqnJq9mWCJJu8MFBlHw26qMBivs973h9S2dh9wtgC8ikUNzj6NfuX/n7qUTpqYzAjBKYC2HpPhPrBEYvEd/4/dXrI2u7bDpSDVcfdGrDa4CyhSnKe9VG9BbxZMll4/2Hfq9vm0mPcSOjfz8D5o7T9uccfaqSUb71uFz+KdoqF4t4rV7b8xDZmBdmbF2GFm/deFJ61d3Rm7ObGIyHvPyXQ5MMlk2fSz9VHMGFDvyO3du8pG4BHUkOp+ZJCwNY/ddpKzyqasQM9CWkhiNIaTbK4QyuHAYe70Z5JMWjKXxFbmUYHyWOqoIrMXvDj+ziQZIAthcZMIsrL6qWHBdKzu84rwYRRNq/tcK7NSFk/ztf01BZpkm4v3wctZUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199018)(86362001)(2616005)(316002)(54906003)(36756003)(6486002)(2906002)(5660300002)(186003)(8676002)(66556008)(6916009)(4326008)(66946007)(7416002)(41300700001)(6512007)(6506007)(478600001)(8936002)(26005)(38100700002)(66476007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k414ohi6RS3+UJJX+GbpZM6qKMfVfHaQUXfxArGhezLVF6Vdv+r461F9nk9K?=
 =?us-ascii?Q?HGt82Vwe3wjD4qJzvtMSs/DPjV00vcYnCTIa2Qcxaj/kUSGb1m9p5H2gAcOi?=
 =?us-ascii?Q?segAvJyjfxQ1GxQBvlNA8oAuRD8UtD8T91Q+irs8hn+gN5P1ddZvVrTYNm6d?=
 =?us-ascii?Q?hVvBgmtNRDs0F3Phh+ea+sFWOZc5Yu8HrZWnesVnQHA5TXTtge8/UEGqXt/N?=
 =?us-ascii?Q?OLEKn0MG/eMzByuB3+G8PfVtd7BooUiJE4FxJKmQ5gAoO1PLI5v6E/gWy5i8?=
 =?us-ascii?Q?xlssuY9kzPe6HdePRDNwEG+yu4Q119wydh3geEiIxXzV7vwkN0d8RNWZAWY4?=
 =?us-ascii?Q?JA1LSkIqg2XIyAQ+zOjlM3VT5dAhhwtuMmfSuMIpKD/7LJrjeGGzaYEgPUpi?=
 =?us-ascii?Q?fk87fqsUp4E9kI1/rztl+u0i36O+4kYb7ve6Oca8xZjhyalui2f+A8NdOw1O?=
 =?us-ascii?Q?HALSlQfia1YVWwr3/rbtDAne0/rql95u1EL/gvspid09YNURNeduWlXlZBP+?=
 =?us-ascii?Q?HXceQ+DB5h74dp/N/ES8u8pWCxtXmLovp1Z94Zwv5j8VPKTxq13ouI1NSCyp?=
 =?us-ascii?Q?pgKbJZ5jz9uLYtxJzF2Tg/RzBa0jNT45qGV4dMrEP5m2FoLlyXkrLIjpBbiS?=
 =?us-ascii?Q?ELSu7PMIwUx57fwj1hxLyKCAkpUvVd+lA/Uvqc6iRWXu1KmPtoOarJOtdxQx?=
 =?us-ascii?Q?v6UIhxYHyQbx6KEIWh9zqu3pNs+d4hAAHrcwidOsR78ld7dhQS8HdhsJ+cLj?=
 =?us-ascii?Q?mLqVBMY/Xk1M6dZtKJnC4rjvBLlGaCAApJNAXHLS+2ksjVQgTjoqRqm094ng?=
 =?us-ascii?Q?09zyown4T8WMCUVDcE03t7w0WyLT3K6Kh9GQOgVZl9abJISSA7bsFbYBr3M8?=
 =?us-ascii?Q?EJX4L4vtrN9kLbFg5fmI5vLAK6fUbZ2rS69bZ8U2KU4hUTePxF1bpublRjlj?=
 =?us-ascii?Q?Z8cgx++w8t+t03oQ5bTsuxTs6rwJbR+D1p+o2Wmj2cp35vkgrvV/Av8+7kOm?=
 =?us-ascii?Q?FVNOmywdwBFbPorf2CF1YgYJMpt/HujUbhDUupTc6+elVcM0pwz2XIHJyXYH?=
 =?us-ascii?Q?SfZpxkqMcOeRDd4EwFpPTvjtSrLFExAmei3pZ226s+Kch1dxHsSqZtZ0q3/s?=
 =?us-ascii?Q?bQl6l/EMWtKi9xE3P7+CABC+4A+/2nR3xtOYdoSxhnNWThNecaRNgCtJX12H?=
 =?us-ascii?Q?xizYD+I5/snTZxuZpqUop9Iwk7JmYmo61qPMQfabNUmb68TrcBZQf648M+OX?=
 =?us-ascii?Q?W3rr0yB54wRfj3IfhzIXEYwYFVZ29o7poODBUeGk3DSvxQaTsnIlzl51JwAo?=
 =?us-ascii?Q?zxhEBFiybEjf9qPQ+ZmKYZxD+TS7pqrTjnDDnj76+Ic20mx/bRufOGDslt0b?=
 =?us-ascii?Q?cQLP5Y03irhlySaqzA3gAvYTlsXiRyQysitp/o/q3nA1utmLaHYcuJIpj56I?=
 =?us-ascii?Q?n/6L2EZqx8DHc4kwL29aNCcqwNpLjK83hPaDCLyYZNNLgUsOs6G1gRnXufi/?=
 =?us-ascii?Q?Ri4N2eKiR3reQBd9XYPDsNKQp3aKk4OVbmzGYfObJv9feK19/RpAYYsQPzJe?=
 =?us-ascii?Q?iOG9LNOmW0V4s+BsHYD4/S5JmB4i8tm2d6qPdHnc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09eec8a2-f349-4c09-49b5-08db1988650f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:36:20.7304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qeUJDlLTfoL87XpAN53FbmFUGk4Co9xPzo0IH2sO2y1+1AZMbDQz8ib5FRYQn4Vp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8722
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 06:00:09AM +0000, Liu, Yi L wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, February 27, 2023 7:12 PM
> > 
> > group code is not needed for vfio device cdev, so with vfio device cdev
> > introduced, the group infrastructures can be compiled out if only cdev
> > is needed.
> > 
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/Kconfig  | 14 +++++++++
> >  drivers/vfio/Makefile |  2 +-
> >  drivers/vfio/vfio.h   | 72
> > +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h  | 24 ++++++++++++++-
> >  4 files changed, 110 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 169762316513..c3ab06c314ea 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -4,6 +4,8 @@ menuconfig VFIO
> >  	select IOMMU_API
> >  	depends on IOMMUFD || !IOMMUFD
> >  	select INTERVAL_TREE
> > +	select VFIO_GROUP if SPAPR_TCE_IOMMU
> > +	select VFIO_DEVICE_CDEV if !VFIO_GROUP && (X86 || S390 || ARM || ARM64)
> 
> Got below warning when IOMMUFD=n, VFIO_GROUP=n. so may remove
> this select or needs to let VFIO_DEVICE_CDEV select IOMMUFD instead of
> depends on IOMMUFD.

Add

select VFIO_GROUP if !IOMMUFD

Jason
