Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926486CAC33
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 19:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjC0Rta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 13:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjC0RtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 13:49:13 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABDA4214;
        Mon, 27 Mar 2023 10:49:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ir43azXzif6mxVWCoG/xjpF1FKXdyZY35U7uIF+6PC7MS85BJ+XMLvsgIcm1wfyqC4bIr/KzrZCLnppU1HeHFjflz569ylzekVL9L9mryE6Qv6w7xnCBuEtTFRs9/wMosLL15LNN4qCuz9D7TSM7SznwId+YZC98TbFgbJ1a7LPoaUtv4sRB6S5CoEVfrquGWeOuS+0H/LRHwhFwiF1+h+LttrZCdDKKKmINhU3omvB0gC1Hi+vUvdLX8qZ20RvtdRj2LnEi6NqxLNb+Laq9qmUNuE9FZFGq2KBbV+UJ5H9Luxhur+LbWJEdSpgowR3Jyey5OArZmD8jbhK0A9cEKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1/cXob2+wsXRXQQ3c7nt+9I8zIlpqe6Oe7p1YbDYf4=;
 b=e4nl6p0mLMI7oz+7cZ7piqJnI5Omc01JqUj5UI4mNd9CfTrlO0IRdCVeed3FZP3IIDF4whB5jPikJs3YZkquVTZVWcCxo6u+ofRseThwtYkDg7EIelb2YEuLvZz4fP3nVlYLYOa6kjUSDZ09Gj/a5rjOTsVZj8k7AxkchM8ds9vqv5PqAvaeu+K43IRPfYkPmo976Z9lyqRJoSuf5bV8qGipJYKNBOe1ab7DLB9K/ztZv0E9SMyqBRDIV4HbuXRIHFk9nsHsmsNuKpeMJ0fzz4bLGTyNsri+NFnNnExOFuLgnbWmso9kI1qbwjjV3PP1QyGyeDg9MTgOgk6u/2x1KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1/cXob2+wsXRXQQ3c7nt+9I8zIlpqe6Oe7p1YbDYf4=;
 b=TW7vId8tZmgzLl1ag84WKzaqdmSsLbQS68QZh95ad7Ou0xxN3bnghVo0TPqwEJYd2bcMPXgwVgJ/34pXlnDEPWA2OOaGN9WfCyxHZBc6vtwxUjJ/bIjonUNG5vfY+mrS2bGseb28KLc/PiIa9/58FMQ6jIHclaQoQaLH1f5+RCHPrYI7vU9xLyX6ox6XU5NHkRfCWHnoOaLYBtg5+VUJZppbK9OyZl5CsBz+pLbxukFKeTcoS7KaNpWcYBwxc02ynhGoEY+urxuJieGTx179lww2n0vdJ5EUHXl2bHHjiGrP/sbA1gajE4hnKhNGPZRrZ6jOz27VBJMKIC+tFLiiow==
Received: from DM6PR13CA0057.namprd13.prod.outlook.com (2603:10b6:5:134::34)
 by DM4PR12MB5891.namprd12.prod.outlook.com (2603:10b6:8:67::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Mon, 27 Mar
 2023 17:48:57 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::23) by DM6PR13CA0057.outlook.office365.com
 (2603:10b6:5:134::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.17 via Frontend
 Transport; Mon, 27 Mar 2023 17:48:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.23 via Frontend Transport; Mon, 27 Mar 2023 17:48:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 27 Mar 2023
 10:48:48 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 27 Mar 2023 10:48:47 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Mon, 27 Mar 2023 10:48:46 -0700
Date:   Mon, 27 Mar 2023 10:48:45 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <joro@8bytes.org>, <robin.murphy@arm.com>,
        <cohuck@redhat.com>, <eric.auger@redhat.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <lulu@redhat.com>,
        <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <yan.y.zhao@intel.com>,
        <terrence.xu@intel.com>, <yanting.jiang@intel.com>
Subject: Re: [PATCH v8 00/24] Add vfio_device cdev for iommufd support
Message-ID: <ZCHW/QIKQVhBjg/x@Asurada-Nvidia>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230327094047.47215-1-yi.l.liu@intel.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT064:EE_|DM4PR12MB5891:EE_
X-MS-Office365-Filtering-Correlation-Id: d98d36de-ac96-45b1-6fb4-08db2eeb8a79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e6H3kIzrznSDbRvtGo5d6OuNsY9+4G6vWe9bIg21I47z0WDOcbBcfJ1Y5DfcADogTnZxD+3bQTLBHTrHOLshuEgFNZFgvHNnu79SfcTSNYQ6CXggW7oG+DZqTgv5rrMP8k6jI4zjQEjS2XrUBh6N9ej2F2/EazdK/Iavimc0J0Mdf1u9WeSYBLxsy22HdfvP5iStm8wzX77iTTQPG6Y60GDnjFYtRCTr9EgX4dMYsUgxp/2d4Z5D64wF6KSCdDqahiXUUN2u5g934jrCiG0TLYXPTbmwB7JcQEyA+d2jykH0poipAe/wMYElAH8WfkMOLoYsCx3xy4hcYxhl6jTgxxlcQbDqo/89Xm9j1z6/Q/s5QtdNvyWUtXnDE8B9/JNTzadHyPpOnSebR3eeTY8kXVIlvnCtMwxMd5fcVIlEI1pE5elqRERPLzRhCJ+eDSlG95n8f8A/jkXGs9ypz4cvBMBn56CrkSF2Lxuml4yud7BmrV6rGqEoUj5BCwCJYqJ2TfNjswBhd/Brk4KYZZU7/t++yH6Mx2IRzM3h555L/zWEIapBeWdYA33ueyt5JGzxOicwYC3vcoMTpxl1SA38KcW9st8gjN1mMbcFNeNOGgNRnrPVabRmu4Y2IAi1dck9vwqlm0IFOXfyMdeho/ee1p/3CINlV2FLTFTSvBwJLgn8vRX+5OvmzYBBZeBCa/MBoakBv51Ha24UUUDa0GlaqazmbiiqqblzzUMkC4HSaXgtuVYZFt6D7CiuqjPmmaTQpcedBpSKsNcP8mlbx1ENhAWEv9UCrXOgHFuJGrPaKSSOXil2IOF0+v8qVCMVHWBj5+xcc+qeH/Ubavfhx4Kg6j4+Nq53F5alNumxUHTs1pE=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(47076005)(83380400001)(426003)(336012)(8676002)(70586007)(45080400002)(2906002)(70206006)(4326008)(6916009)(54906003)(966005)(478600001)(9686003)(316002)(186003)(26005)(55016003)(82310400005)(40480700001)(7416002)(86362001)(33716001)(36860700001)(41300700001)(34020700004)(7636003)(356005)(8936002)(82740400003)(40460700003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 17:48:57.7057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d98d36de-ac96-45b1-6fb4-08db2eeb8a79
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5891
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:40:23AM -0700, Yi Liu wrote:
> External email: Use caution opening links or attachments
> 
> 
> Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens the /dev/vfio/$group_id first before getting device fd and hence
> getting access to device. This is not the desired model for iommufd. Per
> the conclusion of community discussion[1], iommufd provides device-centric
> kAPIs and requires its consumer (like VFIO) to be device-centric user
> APIs. Such user APIs are used to associate device with iommufd and also
> the I/O address spaces managed by the iommufd.
> 
> This series first introduces a per device file structure to be prepared
> for further enhancement and refactors the kvm-vfio code to be prepared
> for accepting device file from userspace. Afte this, adds a mechanism for
> blocking device access before iommufd bind. Then refactors the vfio to be
> able to handle cdev path (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> This refactor includes making the device_open exclusive between group and
> cdev path, only allow single device open in cdev path; vfio-iommufd code is
> also refactored to support cdev. e.g. split the vfio_iommufd_bind() into
> two steps. Eventually, adds the cdev support for vfio device and the new
> ioctls, then makes group infrastructure optional as it is not needed when
> vfio device cdev is compiled.
> 
> This series is based on some preparation works done to vfio emulated devices[2]
> and vfio pci hot reset enhancements[3].
> 
> This series is a prerequisite for iommu nesting for vfio device[4] [5].
> 
> The complete code can be found in below branch, simple tests done to the
> legacy group path and the cdev path. Draft QEMU branch can be found at[6]
> 
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v8
> (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)
> 
> base-commit: 1d412cdf6cd17c347b5398416a60518671e13d37
> 
> [1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
> [2] https://lore.kernel.org/kvm/20230327093351.44505-1-yi.l.liu@intel.com/
> [3] https://lore.kernel.org/kvm/20230327093458.44939-1-yi.l.liu@intel.com/
> [4] https://lore.kernel.org/linux-iommu/20230309080910.607396-1-yi.l.liu@intel.com/
> [5] https://lore.kernel.org/linux-iommu/20230309082207.612346-1-yi.l.liu@intel.com/
> [6] https://github.com/yiliu1765/qemu/tree/iommufd_rfcv3 (it is based on Eric's
>     QEMU iommufd rfcv3 (https://lore.kernel.org/kvm/20230131205305.2726330-1-eric.auger@redhat.com/)
>     plus commits to align with vfio_device_cdev v8)
> 
> Change log:
> 
> v8:
>  - Add patch 18 to determine noiommu device at vfio_device registration (Jason)
>  - Add patch 19 to name noiommu device with "noiommu-" prefix to be par with
>    group path
>  - Add r-b from Kevin
>  - Add t-b from Terrence

This runs well with iommufd selftest on x86 and QEMU sanity on
ARM64, applying nesting series on top of this series:
https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03272023

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
