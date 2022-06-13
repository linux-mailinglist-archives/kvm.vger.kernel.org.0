Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814DE548030
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 09:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239014AbiFMHNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 03:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238948AbiFMHNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 03:13:09 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289031A3B4
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 00:13:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1YGuk8oC+tnwteFNYzaiwOBB7+lAc5YoyVmUbMXvqrEHKfTNYmw61WTAppZ0loOwHnpgEEkhNEUVAtfk1FWAL9de7TvLCv0SqWfIXOZF6lUgf40kXtJWd0ZtbKhT1NVqZ4TQZVWDYWZ/868mDNRBxnshqrGYRkTWfIgRtxC/LEUIrBFYymG5bxqWPphmrV0wmdRcWS8lF2v85TTwIrnQ9UmuebGteROW0OH3X/N76cxq/WdBNUsydCubC6ktzXwO59UJbQjTZajNh3zDweH9vs+oNAtajy/pzrAye+GJd5l+Yh2RGmKQuIkGYPDhDIOn4B5c+O6YCE7R1WgVmUhuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JedgFLMCG7Sv4O0OD3glQMvonjoHycppnjIz8TIPuiY=;
 b=DWkF9sZp6UpME/C82ohF6nBVypqQmST67E7/iKYqdDYwuZ4YkJfoMXMjxwfuUyblQuEZewZc0ANijeB5eL4chaQlHiEKH53yaWpbHokaLQe0q0i9otm7A2I335fCehK+hzo85Qj/vq7wmcFDGYA06SmgMYEDbXkqP9GxSqy4EQrVQ07OJe1/+J9XtsRtHH0iFWJ06l9mJxiEPd/MMwr5zLmmUs3uUYB2Lqt0d15fFPrHTmf+WezSNwVVXzS+MVEuHXArL226gFvydvFvtgzsViea1oe6aSra/0M3yPIkDWi6wClAUcjTgL/QMAnmRsFWWsHRn38eeCFRGMffLoADxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JedgFLMCG7Sv4O0OD3glQMvonjoHycppnjIz8TIPuiY=;
 b=q2nLziW/TGp7yeCjYxD7MjK+lNLCxOjllkq0zNTrrr/F4JBMjXHSFPqkH+M8ZFdj9R5a7qhf/CzJq8MAxsbqhewRzZB2gyu5+O0zQphnWkSrkVKcST2b6nMmDi1oa5/r7fVyg2duxvU2+Z6XBMDWtT2/INdZ7wo/0aM7N2auXvhc7c5gX7798nCxjEcGRisI3ZPtVs1BX9U5VSgT8NnQ1Vf415XWkbZsPaLzGw8qyeNqJf3uGwoTHRDkAVxD18lQhwhWmuqdfC8VMfT+J7liHvpeIBnYjomQNaMgur8tg8TCuvgBGWQh012sbEr3VtBgC1nxmAs88qDXzSuuP/zamQ==
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by LV2PR12MB5965.namprd12.prod.outlook.com (2603:10b6:408:172::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19; Mon, 13 Jun
 2022 07:13:06 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::21) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Mon, 13 Jun 2022 07:13:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 07:13:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 07:13:05 +0000
Received: from [172.27.11.221] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 00:13:02 -0700
Message-ID: <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
Date:   Mon, 13 Jun 2022 10:13:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
 <20220606085619.7757-3-yishaih@nvidia.com>
 <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e9969ad-b22c-4826-ca5c-08da4d0c29bb
X-MS-TrafficTypeDiagnostic: LV2PR12MB5965:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5965204ECAA8438243E9882DC3AB9@LV2PR12MB5965.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pNLc6zx6yzkKo7Y5gZfedXolPu2mzguy+QJJb/OHsyHbm0WDFo3p2/B12QwndwLfQObYMXW7t3CrXxpH0ajtxVRcprNpsc07Uyc8DEbKUmlabCdqs47CNLqKrRlPX8nGaOL1dXX9dG1TbMWUH12DuH34YUB+51cj31E/JYb40Q8BvTcclDGGI+w4+x2kCsTPIcUIWcgBBYrdnS/Ft98pVK9JKk7o9+BBS+XrQIgfNbOX+/7qttBD4DBbfNH3C2P7C+zzXt2s7z7NE8jJbPN0vrDWssbduypod+MbRlaBLKE20KNyBcU+dnubMG4YGNVaAbOKZV7/PuCZodJz6MwJSal2mupdSfsU9Coj5a107AoXWNzfS/Xeh4jyD9eb91G6QRHd/MR2pgQtXsTTnz1zZGknK41/YkHm3oKdnSXGN9xf4yHPORoGkvnfV2dZ6ytyRs4mOTRIKKoU++eNmgIfdbz/N7CWn5Znth2M1GfsSjPHpDKx72iTqDTc0UI0/8tiTiSBPJpT3dBx77zsreOIkml7n1gElrrxADQQO57l8VxlH5w3chudTMfkkOboMnZzbXuKrIqvuSP9UxioXsyQNA57k7hNMywkUsmBF4EzZ3fleWxZI1mqUWdNUs6BjuC4oD4fTet7y75tR/U6LREgij6fIyvITK7BGLBdMUfRmN1GUykYqw7ePZFIbdGsRaNtXl+B04ZBjCS5oDWZQkGYywB9YirbxiCbyC4we7pOxIbW6MSdSiicduyUUFFIcVHi
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(36840700001)(46966006)(2906002)(16526019)(356005)(36860700001)(16576012)(508600001)(81166007)(36756003)(316002)(26005)(53546011)(86362001)(83380400001)(426003)(336012)(47076005)(40460700003)(31696002)(82310400005)(8676002)(54906003)(110136005)(4326008)(2616005)(70586007)(5660300002)(8936002)(31686004)(186003)(70206006)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 07:13:06.0215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e9969ad-b22c-4826-ca5c-08da4d0c29bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5965
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/2022 6:32, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Monday, June 6, 2022 4:56 PM
>>
>> vfio core checks whether the driver sets some migration op (e.g.
>> set_state/get_state) and accordingly calls its op.
>>
>> However, currently mlx5 driver sets the above ops without regards to its
>> migration caps.
>>
>> This might lead to unexpected usage/Oops if user space may call to the
>> above ops even if the driver doesn't support migration. As for example,
>> the migration state_mutex is not initialized in that case.
>>
>> The cleanest way to manage that seems to split the migration ops from
>> the main device ops, this will let the driver setting them separately
>> from the main ops when it's applicable.
>>
>> As part of that, changed HISI driver to match this scheme.
>>
>> This scheme may enable down the road to come with some extra group of
>> ops (e.g. DMA log) that can be set without regards to the other options
>> based on driver caps.
>>
>> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:

Thanks Kevin, please see below.

>
>> @@ -1534,8 +1534,8 @@ vfio_ioctl_device_feature_mig_device_state(struct
>> vfio_device *device,
>>   	struct file *filp = NULL;
>>   	int ret;
>>
>> -	if (!device->ops->migration_set_state ||
>> -	    !device->ops->migration_get_state)
>> +	if (!device->mig_ops->migration_set_state ||
>> +	    !device->mig_ops->migration_get_state)
>>   		return -ENOTTY;
> ...
>
>> @@ -1582,8 +1583,8 @@ static int
>> vfio_ioctl_device_feature_migration(struct vfio_device *device,
>>   	};
>>   	int ret;
>>
>> -	if (!device->ops->migration_set_state ||
>> -	    !device->ops->migration_get_state)
>> +	if (!device->mig_ops->migration_set_state ||
>> +	    !device->mig_ops->migration_get_state)
>>   		return -ENOTTY;
>>
> Above checks can be done once when the device is registered then
> here replaced with a single check on device->mig_ops.
>
I agree, it may look as of below.

Theoretically, this could be done even before this patch upon device 
registration.

We could check that both 'ops' were set and *not* only one of and later 
check for the specific 'op' upon the feature request.

Alex,

Do you prefer to switch to the below as part of V2 or stay as of current 
submission and I'll just add Kevin as Reviewed-by ?

diff --git a/drivers/vfio/pci/vfio_pci_core.c 
b/drivers/vfio/pci/vfio_pci_core.c
index a0d69ddaf90d..f42102a03851 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1855,6 +1855,11 @@ int vfio_pci_core_register_device(struct 
vfio_pci_core_device *vdev)
         if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
                 return -EINVAL;

+       if (vdev->vdev.mig_ops &&
+          !(vdev->vdev.mig_ops->migration_get_state &&
+            vdev->vdev.mig_ops->migration_get_state))
+               return -EINVAL;
+

Yishai

