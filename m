Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F29E54E335
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 16:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377631AbiFPOS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 10:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377625AbiFPOS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 10:18:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D87C193E5
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 07:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFbogSLjD+/f+0D305rTx9e+0dD6jraNFhOoP616u5FslDt4Py/hzKSMRUM1aRyk/8+4y6dVuyp4kSV1NT4dPJ0cVWSyfYEgQhO/dHqAzLL3u0OKEkPz5TGFOUvu6eAeBbe7wWIMUQoqMLmZy2BhouIgPEb6KKgo4qNr+zzxs90iSExBG8tibhQbD1M1jRAVTfKGriq8L/drJZH7hkdNF4aQPE+f79a1jSKxChBi/cF/KfYTDH478+QBF11T6cTm39kHAybGsVzkzK+hbpJXLZ5qIHMfmIA3tR8IodC6/Yuvtjn5pH5ETY7NCFYjcoTMS3NUYQygXcdyNJBGHlvPlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2eFQrrDl87wCksF8Ygf/svOzD8FD6JzmSX03ra04Dw=;
 b=nVNlsJxTYtpHpPdCTRoX8E7nY1Pd9q/fV8+OT04OkUYe9wUWfFQ5E+NQzBkcZ2CopdU1D0rf69P8xXDFCIMBhY/pPU42pguqlvrBKUSIZxxJG7knlAIt6Jr2RpVEo5LYnVfg2uVx8ApgViYnj3DeDSuzVIVRc1MITnzi3uBKLL3IsnKZg9Pg6QbpNUBUy487Qby7FtdMVSnt4jHQtvm5lXePUZhAcfjzPXE3SzuGbHxD1cVax9pZJCbQKx6v7J07eyGHM9R9GS1DbWbmqmQR04mKd+gyCX7rPHFzrco5iQEBYcwWQanbWTG1eTYfK38vnlypDkxVjrXMIskH2SRoSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2eFQrrDl87wCksF8Ygf/svOzD8FD6JzmSX03ra04Dw=;
 b=ZLP9Ggg7Ehmpqvd4jJ4pFxLIc9n3PKooPrWWO16cWjSuXdHFWVY1wfn7wTGy20FUOuFIDWIRQgqLe0l8hftGTl7cPLaypNSMX8RdhHJ5+ezUd3JvBaJmBkoVQ0LlBbBcIStIHLQ9pqjHK853T+1Nng+Uvmom8m79FD5rpbloXJWhHiVFqEuBHekzUv3gjef5k0iPvMNVKwDTqfesad+Ri4v5PDUnU69ixvE8VKYk12sfLogB9/BNGfDcJJUhnXSZjOx8gUClvUZDCMQ6OdMAKuVFC6YdBcgTmDfGqB/bIhjJNa+qh4xu6rgJ6HIZSdnTWr/pB1LX8yzIqhOY1rDqJQ==
Received: from CO2PR04CA0156.namprd04.prod.outlook.com (2603:10b6:104::34) by
 CH2PR12MB3928.namprd12.prod.outlook.com (2603:10b6:610:23::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Thu, 16 Jun 2022 14:18:24 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::8a) by CO2PR04CA0156.outlook.office365.com
 (2603:10b6:104::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Thu, 16 Jun 2022 14:18:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Thu, 16 Jun 2022 14:18:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 16 Jun
 2022 14:18:23 +0000
Received: from [172.27.13.86] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 16 Jun
 2022 07:18:19 -0700
Message-ID: <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
Date:   Thu, 16 Jun 2022 17:18:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "liulongfang@huawei.com" <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
 <20220606085619.7757-3-yishaih@nvidia.com>
 <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
In-Reply-To: <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa30a0da-8433-46ac-e66b-08da4fa312cf
X-MS-TrafficTypeDiagnostic: CH2PR12MB3928:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3928EA6A369B6D8A49CA3DC0C3AC9@CH2PR12MB3928.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aaz7ZclmROI48545DNYLpvnyD3wPwVV/zA5FN+4j3JqmnpF1Vm0vdcFaU310U3/7KlwGlS3dNDqd25/VwsKx4xtCB7HxwzG0KY8xLPt/0b4q5gEFoBK21RXazXSeyrZsJVLXUywgImSV86AszmDWXqFva4czzARcGxCSWbEzLb0wP40KQ3FnM1rFbhjsek/2gznYwSTw5lofqO+zvzKIwjItxu8vaoQgKPw09dNi5dK/z0vuEm6EieIqr9YmLZKYEDsSqKmkL6eY2H55EB8DnvYWeMMtIHqbjXahJVBj72XwfnwB1kcYlT57TeosFfiOppgyxyO45TRWz505pUWN5dp3Lcd8tsczHZ3mdY7cfkdhiaY08R3Y+AEw7du/rnOkTQC6VBxEkptzQTeVljZDRZZ9B9uEFtYrPocUFBw7q9bp7/a1Gg+XI9y2wbKGVRZJ/RJVD0nNVsbEEC0cYHNi2n3WFg/62IjZJEf/1YCrtDWn9C5VZvUAArPeukr+pA0VNY1v0mJ+oDh4e+SfFv11RgzL2etUT8b9G9yJ4W02ZOoL9HOID2A4nmX9VTRnCRdvwIxaq8ePcALR3k2OWl8wVyS89NkPa5ANemytEUj6N7p1ZsaL+w0P+xT21T4KvKG8mCFn+ifQ2SSbpCC1nvpsKvC4iuS4g2wUIF01meGarE+jE8sQo+tfVHS5G7+gupIAW3VjCJJgUrb2UspUyZ3YcWstFxppI0yii7FOikj6e9S+ZqKZRwu23LjENoADkqfF
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(81166007)(356005)(54906003)(426003)(2906002)(8936002)(83380400001)(5660300002)(498600001)(16526019)(186003)(36756003)(82310400005)(40460700003)(26005)(6666004)(31696002)(47076005)(110136005)(70586007)(70206006)(31686004)(4326008)(8676002)(16576012)(107886003)(86362001)(336012)(316002)(2616005)(53546011)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 14:18:23.8974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa30a0da-8433-46ac-e66b-08da4fa312cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3928
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/06/2022 10:13, Yishai Hadas wrote:
> On 10/06/2022 6:32, Tian, Kevin wrote:
>>> From: Yishai Hadas <yishaih@nvidia.com>
>>> Sent: Monday, June 6, 2022 4:56 PM
>>>
>>> vfio core checks whether the driver sets some migration op (e.g.
>>> set_state/get_state) and accordingly calls its op.
>>>
>>> However, currently mlx5 driver sets the above ops without regards to 
>>> its
>>> migration caps.
>>>
>>> This might lead to unexpected usage/Oops if user space may call to the
>>> above ops even if the driver doesn't support migration. As for example,
>>> the migration state_mutex is not initialized in that case.
>>>
>>> The cleanest way to manage that seems to split the migration ops from
>>> the main device ops, this will let the driver setting them separately
>>> from the main ops when it's applicable.
>>>
>>> As part of that, changed HISI driver to match this scheme.
>>>
>>> This scheme may enable down the road to come with some extra group of
>>> ops (e.g. DMA log) that can be set without regards to the other options
>>> based on driver caps.
>>>
>>> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 
>>> devices")
>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:
>
> Thanks Kevin, please see below.
>
>>
>>> @@ -1534,8 +1534,8 @@ vfio_ioctl_device_feature_mig_device_state(struct
>>> vfio_device *device,
>>>       struct file *filp = NULL;
>>>       int ret;
>>>
>>> -    if (!device->ops->migration_set_state ||
>>> -        !device->ops->migration_get_state)
>>> +    if (!device->mig_ops->migration_set_state ||
>>> +        !device->mig_ops->migration_get_state)
>>>           return -ENOTTY;
>> ...
>>
>>> @@ -1582,8 +1583,8 @@ static int
>>> vfio_ioctl_device_feature_migration(struct vfio_device *device,
>>>       };
>>>       int ret;
>>>
>>> -    if (!device->ops->migration_set_state ||
>>> -        !device->ops->migration_get_state)
>>> +    if (!device->mig_ops->migration_set_state ||
>>> +        !device->mig_ops->migration_get_state)
>>>           return -ENOTTY;
>>>
>> Above checks can be done once when the device is registered then
>> here replaced with a single check on device->mig_ops.
>>
> I agree, it may look as of below.
>
> Theoretically, this could be done even before this patch upon device 
> registration.
>
> We could check that both 'ops' were set and *not* only one of and 
> later check for the specific 'op' upon the feature request.
>
> Alex,
>
> Do you prefer to switch to the below as part of V2 or stay as of 
> current submission and I'll just add Kevin as Reviewed-by ?
>
> diff --git a/drivers/vfio/pci/vfio_pci_core.c 
> b/drivers/vfio/pci/vfio_pci_core.c
> index a0d69ddaf90d..f42102a03851 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1855,6 +1855,11 @@ int vfio_pci_core_register_device(struct 
> vfio_pci_core_device *vdev)
>         if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>                 return -EINVAL;
>
> +       if (vdev->vdev.mig_ops &&
> +          !(vdev->vdev.mig_ops->migration_get_state &&
> +            vdev->vdev.mig_ops->migration_get_state))
> +               return -EINVAL;
> +
>
> Yishai
>
Hi Alex,

Did you have the chance to review the above note ?

I would like to send V2 with Kevin's Reviewed-by tag for both patches, 
just wonder about the nit.

Yishai

