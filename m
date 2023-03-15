Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523146BC0CD
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 00:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjCOXXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 19:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjCOXXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 19:23:13 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B715119C78;
        Wed, 15 Mar 2023 16:23:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzHPIr9o1nbZTvPq/5sy/OMKltbmWYRCAbfbukymb7+z7xz0d6eSJHCTKUmOYeDgvS/riaoY21whfYDEPuoZEgMS1N9TMrzHdkPr+kITXSyw3ELaAtla88xcGBhVYSgmjpKPnN3pMu5WOKOQkxuby3f65NGCKSuDknXyuak0/0eJHVg7Qzb4Abtjwk+pS9bT+GASfbtmBr78or6MGqp75goaMzgm4u6IYZVgZfLa6Zx0IjK1M3XmK5UdvZWeqK2e2+NatihvCdL2G0ki7kl/oAxOU2K1/WbUf2+KZP3bNaVnGK/5x0SXHxqx9VNqhVcX00jRsp+FQm45poGNlaK6Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQe6R6Pab9M8sTjgZIAmwP7eaDvQ9tFtWEfis4HxpEg=;
 b=QPkYNbCOzvvrXFBV+U8UL2aawEqM6Dck/uWmqUZgTfx83g8Hhb3OMkeBk/9tVflxJeHY5E/tWxDu1jUG9GfYEelY1JbYqlF3BaETYUzyZAvSMw78Ev+6DNGy9c5jIzygyqmrS6OI/EYbO7AWzKTBXDyQOVnvHi2Qkg7fqUABqZ2Q1WrW/pMICy/Y4kbhpe8WsZg2+8itNoKV1wjW8a2EcDvWOwQhuJRMrRUD3a2dA7icntP+hB9PB8+ARZiNfcaOSNkNxCk1GY/Zo2K1ZBsF8rFSY3/9K3JbzQBfpBF7HqIVRnd7eh0K/YeIJCsphxJ0SZwJYG8Vjfkh53xfLpkN8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQe6R6Pab9M8sTjgZIAmwP7eaDvQ9tFtWEfis4HxpEg=;
 b=W5T4tnTrXiUnonIwwJmx1fA7gC4m/EEHiGBH5t9MVvtunnLKeGe3I7b50C61g8LuxarFXUbGi0fzyLyN1qcn0pZvrUIC6B2Di/Y2jSPQPlcYhfBvxAa2U5UZSpmGPS64lMP66dEeaWVzRqz4Tvi7AaXJJ4QH6l4/yGXh+zdGFjW3kgMzVXGEUCmR0qnabRkHLeqLyHO89gjZB7QwOs0Cwbj3l8lwiplMHvZxeAl6CamTl5ZwvlThkXmVcJVxQSmwC4jdhGEw8/oYVV1s4G8WcxXKpekKN0Wnv+mEZ7m3xEfg0NaxmOW0yT3izlnCXdOIz1ZriuKWgvtvsSc7StGBPw==
Received: from BN9PR03CA0466.namprd03.prod.outlook.com (2603:10b6:408:139::21)
 by CH0PR12MB5266.namprd12.prod.outlook.com (2603:10b6:610:d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 23:23:09 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::ca) by BN9PR03CA0466.outlook.office365.com
 (2603:10b6:408:139::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29 via Frontend
 Transport; Wed, 15 Mar 2023 23:23:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.16 via Frontend Transport; Wed, 15 Mar 2023 23:23:09 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 15 Mar 2023
 16:23:01 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 15 Mar 2023 16:23:01 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 15 Mar 2023 16:23:00 -0700
Date:   Wed, 15 Mar 2023 16:22:58 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "Xu, Terrence" <terrence.xu@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Message-ID: <ZBJTUiukDLysAeAx@Asurada-Nvidia>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
 <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <SA1PR11MB5873479F73CFBAA170717624F0AC9@SA1PR11MB5873.namprd11.prod.outlook.com>
 <Y/64ejbhMiV77uUA@Asurada-Nvidia>
 <b7c1f9d5b4b647f0b0686c3b99f3d006@huawei.com>
 <ZAE2J0I1LiBjWUnm@Asurada-Nvidia>
 <d59a0262d5bf423c9e49ad4ac6015296@huawei.com>
 <ZALspPvvLGFuK96F@Asurada-Nvidia>
 <90a277ea100d496b82f8cc84388bbca2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <90a277ea100d496b82f8cc84388bbca2@huawei.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT040:EE_|CH0PR12MB5266:EE_
X-MS-Office365-Filtering-Correlation-Id: 33db72a9-6b76-40e1-8b5e-08db25ac3d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQBo8fibBUmzD+ncQPUzL59llclptORRiJQbrK8j+Pu7kaVe3/oaGKxGRJnOvOwm5SvsiwsjBLe1BgJTCHyBfuxueEcBG64JK52FDV4cIe7NSi/mXhXBZs2+y5Qmi72ESenVOr7FwBi9UnBXfrhnzuFROwQfPoTdAsuyMKLKankWU4esJy1Uit214tyMLEgwYH7mNRUqqfeDgI6TgkIW3ZWJf5XGtJr5End8gJtQGhYsTqvFrG+e/xAPIACRkfRjojJd2JWe9hvkHiSIyDj018sfBYCBE+oqc+AAzVDFUkprBTF3NI6dIXSjFgRlCRzuscAiVNtOpAZC5ISIk24P2OeMlbTGNvaLPns99FXqVbazSkyTfzzpofd9Rqt2voQTwP12JnOMRmR9XQ71WBsVSYzDDWGcB8bSeDYwHpzZTQbOSWLJ+2PLewIUkn1XHNw1AMKOoiEE+34Xoug6DTy2pkKTF+fU2LSCy/Tw0VJxi+cItWP6joN4eNK+40grDPe5R1ElNdZUk2bFVsLza6rQtPLyGtwlNTAGbx+dx7eTNbMXD7i9Li4xu3D9c5ZVGrZK4BNrk8jB/e6IWkHRfWNaq10Xyay+sfvzGwhd5JHcfXUd4UCSf+Gx2u0CO1XmARAtxlqLc31/srQL6rrCoK377g3PuXOVOP24fg79yuMhdqxZXEzBQYFZqHZMk17QiFpaz81rXY1Aqzj0eL4srreMgDJ0fy+cr2R7gSDPAFL+GHsstuMHYppDvodiYIPlZmyx8B1kwBoYHElITMl11apaL+5ORvXmqygJr/rLZoPp/Ck=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199018)(40470700004)(36840700001)(46966006)(2906002)(7636003)(82740400003)(83380400001)(7416002)(5660300002)(40460700003)(41300700001)(8936002)(4326008)(70586007)(40480700001)(55016003)(8676002)(356005)(36860700001)(316002)(86362001)(54906003)(110136005)(70206006)(478600001)(82310400005)(426003)(47076005)(186003)(336012)(966005)(26005)(9686003)(33716001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 23:23:09.1393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33db72a9-6b76-40e1-8b5e-08db25ac3d21
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5266
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 14, 2023 at 11:38:11AM +0000, Shameerali Kolothum Thodi wrote:

> Hi Nicolin,
> 
> I rebased your latest Qemu branch[1] on top of v7.2.0 and not observed
> the above issue so far. However noticed couple of other issues when
> we try to hot add/remove devices.
> 
> (qemu) device_del net1
> qemu-system-aarch64-iommufd: Failed to free id: 4 Inappropriate ioctl for device
> qemu-system-aarch64-iommufd: IOMMU_IOAS_UNMAP failed: No such file or directory
> qemu-system-aarch64-iommufd: vfio_dma_unmap(0xaaaaf587a3d0, 0x8000101000, 0xf000) = -2 (No such file or directory)
> qemu-system-aarch64-iommufd: IOMMU_IOAS_UNMAP failed: No such file or directory
> qemu-system-aarch64-iommufd: vfio_dma_unmap(0xaaaaf587a3d0, 0x8000000000, 0x100000) = -2 (No such file or directory)
> qemu-system-aarch64-iommufd: Failed to free id:1 Device or resource busy
> 
> Ignoring the MMIO UNMAP errors, it looks like the object free is
> not proper on dev removal path. I have few quick fixes here
> for this,
> https://github.com/hisilicon/qemu/tree/private-v7.2.0-iommufd-nesting

The smmuv3 change looks good to me. I will let Yi check the
iommufd change.

Yi, I wonder if this is the hot reset case that you asked me
for, a couple of weeks ago.

> With the above, it seems the HWPT/IOAS objects are destroyed properly
> on dev detach path. But when the dev is added back, gets a Qemu seg fault
> and so far I have no clue why that happens.
>
> (qemu) device_add vfio-pci,host=0000:7d:02.1,iommufd=iommufd0,bus=rp1,id=net1
> ./qemu_run-iommufd-nested: line 13:  7041 Segmentation fault
> (core dumped) ./qemu-system-aarch64-iommufd
> -machine virt,gic-version=3,iommu=nested-smmuv3,iommufd=iommufd0
> -enable-kvm -cpu host -m 1G -smp cpus=8,maxcpus=8 -object
> iommufd,id=iommufd0 -bios QEMU_EFI_Dec2018.fd -kernel
> Image-iommufd -initrd rootfs-iperf.cpio -device
> ioh3420,id=rp1 -device
> vfio-pci,host=0000:7d:02.1,iommufd=iommufd0,bus=rp1,id=net1 -append
> "rdinit=init console=ttyAMA0 root=/dev/vda rw
> earlycon=pl011,0x9000000" -net none -nographic -trace events=events -D
> trace_iommufd
> 
> There are no kernel log/crash and not much useful traces while this happens.
> Understand these are early days and it is not robust in anyway, but please
> let me know if you suspect anything. I will continue debugging and will update
> if anything.

Thanks! That'd be very helpful.

Nicolin
