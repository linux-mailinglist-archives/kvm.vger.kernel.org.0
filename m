Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E74B40F29C
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 08:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhIQGwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 02:52:41 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:57860
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229456AbhIQGwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 02:52:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXqRnkrSkuVxZqpi4dKKGvqU5dlscktVSeqSoOZvVTsOEz1BLAlj6L36kGusxs7QdTy84ZExFmYYeCqk0+n638oBBZPnkhCjMi9YrXqn7/lcKkOCp+Z15AerzFgacVbdWviw9I8OK5YMo/rcKGOZ6gYHcfpu5I9cV7p8wzXBoBR7h266Pf7KdVkoKjY7i7fofwGIePc5g6Yq6h0btHhrjwfnQENhldfP/jHDAhQrTu/WFcHYrramgfoQYfXmFgTff0qAN2mkbyxtNl1hOAg27Gja40mr0nkNo0EbYcK+cv2butyD/GhTEn27sUwavCE00PKvT49iPuIUYvhISxuH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6TQUa4y4ly2LZSrTO1twGHHldVsC5qhai9dUR5SBAkM=;
 b=Aou8vYkyKjuTbpzWkvmM4l2eOnONt9iBq/GfLv9hWCCDzOqXLArGMS3vUiXa5331SX8C7GnlfnFbFdJeDOn1GIBeIi7lK6T8nKTp+15c05XXpxghZKd1M1175YUWCAM2eUZy8+jxKwiQ7hNFxICd7Ro/o0q7fgu8C05C1X278CgYTdJxTtEanQTvSX2EVI2Tb6KxTFMMlDt/YXFNjGbR9RkzUhjkxV5u4jyhQrCvkyJbQ47sPeW3AyEM6BaGqPrlQJFm7rxNm+3Vr9fi3w7jCm/NsiCYkiCsxpCIJ6FgAJV70RUVjeLLdBzF2qz3jKXdAlvat6V8nqZLcGeNkXMJTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TQUa4y4ly2LZSrTO1twGHHldVsC5qhai9dUR5SBAkM=;
 b=TqtN/a0skfJra5ylPD2r/bZP/S+LzRVFEh/kpcdjnap166SKf0F/ZZfO+jDGwfxGcjomD4DY7xnPkkF+AfcXavga1Iu8YmRj+3ls2bJ0hLjlSQCLDX11vTRs3N5sFmatxMKMJAFlUn+oGVSYoylzBpF6utQA5pg8Aa7+SMlCieFYXhW1Z4biV7uJcL/KJRH4XVPXRa1snSePI2psrf22Yn3E9a/huGx1/Dz92ed1r7umuDWIV0F9TwGdhl3SdwV0QEO0wVq3i974dal33Xf6ex/vq/hykAZLi0omscJO3yEDTfPMM/zs4gYlEv7aeOXUFl/rvwQSOo0vMvn3j551Xw==
Received: from BN9P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::14)
 by MN2PR12MB4319.namprd12.prod.outlook.com (2603:10b6:208:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 06:51:15 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::de) by BN9P222CA0009.outlook.office365.com
 (2603:10b6:408:10c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Fri, 17 Sep 2021 06:51:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 06:51:15 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Sep
 2021 06:51:13 +0000
Received: from [10.40.102.56] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Sep
 2021 06:51:10 +0000
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
To:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-12-hch@lst.de>
 <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com>
 <20210916221854.GT3544071@ziepe.ca>
 <BN9PR11MB54333BE60F997D3A9183EDD38CDD9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210917050543.GA22003@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <8a5ff811-3bba-996a-a8e0-faafe619f193@nvidia.com>
Date:   Fri, 17 Sep 2021 12:21:07 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210917050543.GA22003@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76b55634-68a4-465e-d589-08d979a78b5c
X-MS-TrafficTypeDiagnostic: MN2PR12MB4319:
X-Microsoft-Antispam-PRVS: <MN2PR12MB43195CCB39412BE684FD7594DCDD9@MN2PR12MB4319.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXKcXQErzCAhsyTj5w27Q8pGfVOP8eB56B+Hz3ogs4P6FIGNVfDRJNe4QsCLP0da3VX34fjnJQC8zoMBwp6+1+VKHAJEOxmpTQq13Q7eOZeeHzNldJ9LJWHQYMIPRLX4mEJvD5+Ozx6+leQA+41gTzKWzJpJMKnxnQx1oElz8BUKWkFbwLCpb6VkouadmSc+K63z9On1FTkuZoIcA+z+dGYAScErKSuqjgGOcCFzMbbNwHFRobhiEuRyharo/1Azr603TihLtg8hfbdRykyQbi0H18kStoHkedNkUA/rg3uhIVLi59sseQW/Bh0HCKxNOZdXpdP2oZG6/kTQXeVhaYkwRUWlaeIq+ETLbduEdeGRiAi/U8CZ9B49JQIV6tx5tiSqJfMi3Jbo4nvJJCXqdl84fK/PFy10cOWrxBRBTy1Hu89Ev3SIQK7VC7hXSIEeWjZjcYGHyQ/rBgTgf0EzghHJpC/eQ217+OD9f3M2bWVUzKRfM57yfs3Y0P5sl0qnnUkDsySxZ93vDsrnA2NF0UIF2nzf9cGofdSATP8929UP0Q2ud/CeysuTfX+Umua0p9du4HD5k+fUSQjflis4AN6j80Vp1z0MwF7rDilHMBtGVRu2+LYA/Y3066PoFcbyBYLNYUzJs3k/o0b9NBhlj6a63TYgtFujGrHTK3QSEfHKqIx1MkPKVDPWD2QlPs2DKzerZ+Hf1e12pyZWqC4+Web0dPhNxEsG7eUrrMxpIQ0=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(36840700001)(8676002)(110136005)(8936002)(26005)(478600001)(6666004)(336012)(36860700001)(426003)(7636003)(36756003)(4326008)(54906003)(186003)(82740400003)(5660300002)(47076005)(53546011)(356005)(316002)(36906005)(16576012)(2616005)(70206006)(16526019)(31696002)(70586007)(2906002)(31686004)(86362001)(82310400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 06:51:15.2443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b55634-68a4-465e-d589-08d979a78b5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4319
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/17/2021 10:35 AM, Christoph Hellwig wrote:
> On Fri, Sep 17, 2021 at 04:49:41AM +0000, Tian, Kevin wrote:
>>> You just use the new style mdev API and directly call
>>> vfio_register_group_dev and it will pick up the
>>> parent->dev->iommu_group naturally like everything else using physical
>>> iommu groups.
>>>
>>

Directly calling vfio_register_group_dev() doesn't work without linking 
mdev->dev->iommu_group to mdev->type->parent->dev->iommu_group.

When mdev device is created, mdev->dev->iommu_group is NULL. Then if 
called vfio_register_group_dev with mdev->dev as vfio device, it fails 
because mdev->dev->iommu_group is NULL. So create vfio_device with mdev 
parent's dev as below:

if (IOMMU backed mdev)
     vfio_init_group_dev(&vfio_dev, &mdev->type->parent->dev, &fops);
else
     vfio_init_group_dev(&vfio_dev, &mdev->dev, &fops);

if (IOMMU backed mdev)
     vfio_register_group_dev(&vfio_dev);
else
     vfio_register_emulated_iommu_dev(&vfio_dev);

But still mdev->dev->iommu_group is NULL and 
/sys/bus/mdev/devices/<mdev_uuid>/iommu_group is not present.
For QEMU, input parameter is mdev device's UUID. QEMU checks 
/sys/bus/mdev/devices/<mdev_uuid>/iommu_group path and fails with error 
"no iommu_group found".

There has to be symlink /mdev/devices/<mdev_uuid>/iommu_group to it's 
parent device's iommu_group.

iommu_group_add_device(parent_iommu_group, mdev->dev) fails because mdev 
device is not pci device or ACPI device. Can it be allowed to add mdev 
device to its parent's iommu group here?

>> For above usage (wrap pdev into mdev), isn't the right way to directly add
>> vendor vfio-pci driver since vfio-pci-core has been split out now? It's not
>> necessary to fake a mdev just for adding some mediation in the r/w path...
> 
> Exactly.

vfio-pci doesn't provide way to configure the device as mdev framework 
provide using mdev_types.

Thanks,
Kirti

