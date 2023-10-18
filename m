Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26ABF7CD67E
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjJRIaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 04:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbjJRIaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 04:30:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2048.outbound.protection.outlook.com [40.107.100.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A397102
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 01:30:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+iC+pEvEH5u47m0PxM6pqCVWNxa7QJ6aRgQkO+ehyavIavQ4z1UcNRFKKCaAexElcKZM/MDqTJUFpntB5wBknEqnv6JYhret1+QPvot2cidlbQGPAWtltztLE+Mdtv3oahDbx7VBEGbK3QW1ULWB0GjrvJNNvg0F8TddAdSbQmD45r9QyctZaX/NoRkuFPixN+Xlhr84/HgcWVnLEfWiuTQUquP6d45Sl8HrR86qNRHL8kCWgyM2VXHlNQzAQ24wQAju5uZuasz5+CX1TF5EPtmp6ILDRsDhuE08WcYylUtsed0RjEbfE7CtzI+G1d6iZtoRMlBgiqgnpiNzQ+wDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7vbkvKN5+TOPUuibhmpn4CPkNVFK4tAzf/RQLKvXoY=;
 b=HxiZIDKncWIzcm22aTaw0LgkzB8jMgnhYqvA2cvhdosxSjzPDeyvz1G/ebQD1HK38LMjTfp+jVPyo+WB6jZ2a/VLNMjKxMJlNm/eYhrWNRRW+Ov2NfUbSpNtnj4lNKs8ykBlyON27F2fBFPUNZRb0vfZkFMDnzZsELzaIQ7ZSEeg1vcuSaJjS0hvkfW5R3s0mp/Y2rMLLiAPYsQlO/jtPHs1eB9rQb9gaM1OIioJ9GcHpFdC2mWXxydwZqyDONzEaYjDfItqflGpQbd8y0wRsq3510NbaMLJxhcfpdA0iGUsI9etSyv0eMVaY/hhMXAr82P1gRohU51foZ+bn1P2gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7vbkvKN5+TOPUuibhmpn4CPkNVFK4tAzf/RQLKvXoY=;
 b=4oubbYRpfUJ2wEi6A3gKL401kBgym6fBng+oml0Mp+GaycZzfUucaaZ/nY+E4sd2aur1heMeOpZP1kl501qKjxZiBL6ZRikjxUA+eH9OqobpJlSDYfQuACmt6f51IucXs9TSZzpOeRFw6gYPR2U99MqJLq2J8BV3nS0QOSskIig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 BN9PR12MB5082.namprd12.prod.outlook.com (2603:10b6:408:133::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 08:29:59 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::726d:296a:5a0b:1e98]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::726d:296a:5a0b:1e98%4]) with mapi id 15.20.6886.037; Wed, 18 Oct 2023
 08:29:59 +0000
Message-ID: <55b30df0-3080-803f-5c24-dd4519b13c01@amd.com>
Date:   Wed, 18 Oct 2023 13:59:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 16/19] iommu/amd: Add domain_alloc_user based domain
 allocation
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-17-joao.m.martins@oracle.com>
 <6c1a0f25-f701-8448-d46c-15c9848f90a3@amd.com>
 <401bae66-b1b4-4d02-b50b-ab2e4e2f4e2d@oracle.com>
 <20231017131045.GA3952@nvidia.com>
 <8f34e144-0ec1-4ca0-9e41-29da90aa7aef@oracle.com>
 <b9e0a47c-b860-48dd-b6d4-b59838046c9e@oracle.com>
From:   Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <b9e0a47c-b860-48dd-b6d4-b59838046c9e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|BN9PR12MB5082:EE_
X-MS-Office365-Filtering-Correlation-Id: 875e0409-d2e6-4baa-3485-08dbcfb46a59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cNOj2Upwq90EkpKAV0iqc6zluLx7ya5HqmAB+mk1iopbzmF7Xtay1Pe1E5hYCcglmOcGfws4C4OQijYvmg1ZLeT/9pJc2Jnggb+Fs0S5+6ePOZT4AMLcC+fTQSvKJcKrGe06gwLt5AiAFHdYSQUROM8abPWtGbYKgEv653ZkJim9k1UkebPtw7mVNlyXIrRzsBYaS8x4wMUzhR3PlLxTBFjSr3i2qXCQfF2PrYW1yhOEx6YSYVBqDBHG/+zUyV8azJqi1lYgNXyCWFVT/dkgBopsVT7WxyQTL79jvMIABdysU0IlpM3SnhVjG9sgRdj//N2eB/4Bn7z4HJITvmWVuZD6/Z1FazTYfDR69gUqcMRcQHCnsIPdl16qyKGqdeo0G04fpz8wzvqHIIoV5I9desR6m92D/CAn09zg+Z/TYjbFRBX0wOuP3PvG9a0jz/rVXGDHCeeR4YYKzXqo0wBdW15Ol0hNcne4EUnnW2OhptFGGR7rpGGCe9FYvG+3x6wX2SL3jKZZVhjXk3aYF5V8WmTQ0/EibKrR/ypls73W4JsYkt8CoC96Xr5uXJNi/l69fe60HRSk7FKtWPL2NBgmDUPspcKCnXp8kob9WC67zhbTSM6wPGdPWfAff5LIhgyakWdLCYKG/mLlZQcYKwCUWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(26005)(6506007)(2616005)(6666004)(4326008)(966005)(53546011)(8936002)(316002)(44832011)(5660300002)(41300700001)(7416002)(2906002)(478600001)(8676002)(6486002)(110136005)(66556008)(66946007)(54906003)(66476007)(86362001)(31696002)(38100700002)(36756003)(31686004)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWtseTBROGVRaXdrTjhxVzYxQTVGOGxJT0JWc2pQcktNSmowbFM5S2RpYjZE?=
 =?utf-8?B?RVEycU5PekRmWVRuUis2K0wwT1AzbWNxd3pnVS9Ib2RtckZ6eU4rUHpTVkRr?=
 =?utf-8?B?b0dkMGRTUnZiZzNDbW96cy9waTdaVXZWV2FnSnJQZWdtY1lLaWZCVE1MeEIy?=
 =?utf-8?B?QWg2b3NQK0dyRnN5OTZvM3RPWUplVTFENnAwS05HcWtBcE1LNzBDbnErYVMv?=
 =?utf-8?B?dU5obEtJc3VpTnY0M0VHZ3BjdldxaGZ4bHpVRzczY1gwc3lvUDJmalVrbUUv?=
 =?utf-8?B?dU8xWU1hbEFpbHhneGtPbVMrNUYrVG0wUGUvM1hheXBmako4Mmo5azVSNnQ1?=
 =?utf-8?B?cTF3UGZScDkwR3lxYjVrSHdQOUpsZEdmRm1GODJTZDZndnZhVGVjd0p4V3JU?=
 =?utf-8?B?cExwZjU4V2RBcWRTM0F4Mm9mZk1YTS8wT1l6b0NWdHJxSlpIdEtEVW9xbTZ0?=
 =?utf-8?B?U0hCbmZMOVczcWl0aVZwYVM4bVUyRm01L21RNTkrckQ3ZUZxQU9GU1lYRGxM?=
 =?utf-8?B?dDlDbHVublJ4dENjUFFRVk1nTDZCNU5MUkU1Y0g0bWNEa1NuSys1bzRtTEN0?=
 =?utf-8?B?RnkwN1llT0FCSncwN01SZE5IakRpTmQ1OU5RZUQxdUdITWtQR3g0dHRVYk9R?=
 =?utf-8?B?WUNwZFI0cEdaUXhnbEo3NndCMGZOQmQzYzZpVzBBMER3Y0I1TEI3eWNoNHdy?=
 =?utf-8?B?Yks2K0l1ck9KSGRKajNUV3J5b0lZdU5LZlhaWkQxUWpkZm1BeHQ1S1did3Vr?=
 =?utf-8?B?RXY4c3FPZFNDdGcyNnF5UWxwYWRmZzdlOEdUR3AzUEcybFoyc2hhR21oRlRr?=
 =?utf-8?B?TGt4Z0Rma3o4Z0wrQnR3b2NQSS9DeFJhK2tVYWpnUUNreTJ4cGI3dERkS2FK?=
 =?utf-8?B?TVY2YmlOTitnbzRVcVNnR3pQdm1UOVVBUSsvZndJOStBL2kzelBZemN2bEFy?=
 =?utf-8?B?WG1kbGdZZGxiTWJPbXg3c0lDeDFNSWNxY1Y3WXhRM0RtRXF6dHQrNnA3QzVs?=
 =?utf-8?B?YnB0Zy9iZktjU2tWR1ZVcUVDRTE0b3p2YlRlVVRNcVhVNm0rR2dNN3hRU2xw?=
 =?utf-8?B?c1R0L1pTRkp5aElLRklkVkt6REVEYzJ4b2tpR2l0ZkRGSFVORm5nWkFqaGN2?=
 =?utf-8?B?bHk5VURqWHRNbVBUQVMrUW1VVGI3TG1JRElmblBKOW1xbCtVd2JvK3RmU3Y0?=
 =?utf-8?B?LzRQZjFkMTJVK01zZmlVZlFwNVBVMWVEQkk5QVZRNDZDZ1lZRHFSSWFIZ1lE?=
 =?utf-8?B?c1FPVHh0cFBkYzFLQUpIcFl5dTFrRTlPQ3cyR1YrNE9yY0JNdDRWUEYrYS9S?=
 =?utf-8?B?MGpnZnczWmdseklyc0FVVW9zYWkwN1F5Szl4QVZTMzVvbVoxWDZwOHVEQ1Fk?=
 =?utf-8?B?MEczWFZWUTI2RFk3cGNWSkwza0VpUDJpSWQ4M25aNnNFSFE2S1NkTUZOUWNS?=
 =?utf-8?B?UVRzdXdENDllK09ndFVyVzY3U00za29TTC83K2NabUpkbStxUHpsOVNhZmxv?=
 =?utf-8?B?c2NLbzBlcWtpMGdYOUgzNHFFdGFwdkwvRUpWclVxU3kySzF5UDVSOUdQWkhS?=
 =?utf-8?B?Y1NmQXlOZDV1RHlBZFdOeGZ5Vk02UVB5NW4vQ0JBeVFWVy8rSEdxODI4WnY1?=
 =?utf-8?B?bHAxWWFNYUh3S1pSYW5DUUg0MXY2SU5YZGNZWFExUXhPWHdGMi9RM3hYVDlr?=
 =?utf-8?B?enhpQldRSGRhV1pMT0xmNzRGTVVrTHlaNytMTlBnTlFTRlpmK3hBbkV3eEt2?=
 =?utf-8?B?QnFGTVdOS1ZKdWhsV0h5R0p0N1pTbitBTTRQT3oyNVpYNU43UWJyTVRrZjVC?=
 =?utf-8?B?V1VDUkdENGZCZHVoTmtXVnA1cE5scndHcXVUSzNjZjhIeE9kZExEOTdsaWZJ?=
 =?utf-8?B?bkhibE5kTTFndFhoQVhYaTIxQUxnZ3dKbUM5Z0JHeGVVZkl1OWhhSVFlUldP?=
 =?utf-8?B?UkZ5blg0d0dFL0hha2E4Y1J3bW9lbjJoei9EZERDZTVjSzdaTDdzekJ4VjdG?=
 =?utf-8?B?aHo1UTdhWE5RQ09kdklHLzk1TGRjbHk2OWRNbFR5SGhmSTJzcUl2R0lnTW9l?=
 =?utf-8?B?Rmx6aDZKcTZQbFIrd2p0dk1qenBKQm85ZjRCUFlaRTVHVUxuQ2FXblBSWHYw?=
 =?utf-8?Q?sE/GomOGNyReg1afjZYDjyyq8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 875e0409-d2e6-4baa-3485-08dbcfb46a59
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 08:29:59.8290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IkVsggCm2rSxZ6qYHCKayNZQTiAMe//iCkPbNEhzY+nYeyqkLm2q9TEFz7/hB6ScHqcskw6qdAANHnYbAmPLeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5082
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/2023 8:07 PM, Joao Martins wrote:
> On 17/10/2023 15:14, Joao Martins wrote:
>> On 17/10/2023 14:10, Jason Gunthorpe wrote:
>>> On Tue, Oct 17, 2023 at 10:07:11AM +0100, Joao Martins wrote:
>>>>
>>>>  static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
>>>> -                                                 struct amd_iommu *iommu,
>>>>                                                   struct device *dev,
>>>>                                                   u32 flags)
>>>>  {
>>>>         struct protection_domain *domain;
>>>> +       struct amd_iommu *iommu = NULL;
>>>> +
>>>> +       if (dev) {
>>>> +               iommu = rlookup_amd_iommu(dev);
>>>> +               if (!iommu)
>>>
>>> This really shouldn't be rlookup_amd_iommu, didn't the series fixing
>>> this get merged?
>>
>> From the latest linux-next, it's still there.
>>
> I'm assuming you refer to this new helper:
> 
> https://lore.kernel.org/linux-iommu/20231013151652.6008-3-vasant.hegde@amd.com/
> 
> But it's part 3 out of a 4-part multi-series; and only the first part has been
> merged.

That's correct. Part 2 parts are merged. For now you can use
rlookup_amd_iommu(). I can fix it later.

-Vasant
