Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5B07CDAEC
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 13:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjJRLqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 07:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjJRLqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 07:46:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8778FF7
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 04:46:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUfxLhf+l7BRFH4B6v2ZW5ykb2tKuvZD5fENiaZcliIgc1RahLV7ume7eIb90qpK1FL+82TAfb4KDDx9/CEJRtgGAkvun5wkMKH/1qGSeWVopgjLLbXrhlkgT0j2MPeJZWxJlX1aQYrrHc/pZ3CZgBpy6Ji/1PcwsDgF8O1efxu+oqDCCJGK1+dbdTmTXJB3k+iGhyyCyhOU9GBwCnJrekOiUVAUPJFzEq9sfhUJsFkmaX1B29bXaBy8BevvViGJngAmLtZFReO751w2cGUPaM2ijVBvGkDbbcDW8q2AOpeWA62YIyKrhXBFltYWEatF8S6+FqymTEYr4k5fY9y+yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6z5yQI4vlCTWwAEN/FQw13o2P7RF2nZxMSj2f2QZ5k=;
 b=mVyASCUikWPmhZL5DIlrV9pd/KYEu0sMEgHQmY1zJzhkB1z44apNb8ZhtE2ID3mUOL60iBzb+XqAjHf78ZoVetDAJEDJ0KXDHrB2mbB2HUH5wQtzAY1J1N8IaB8xMfDNG1Oe39HWGiTaRVO0I909e0ECp3DzinTaVZim+jmbd0R0unjZA0fKclp1uiB3khNQk9Fs3EJy+9Bdaxelr9b5wmbRWtIV6MC5DXydXEBbQQvSFR3d0KHFXSer0mEiWWOeML1kVoOUZaRz0cmX3gaOcFp9iPtT6W/dQzivterOG2YxkqpOVYsfNu42KC44Zs57A1ox8CzQOLTioZGapYrT+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6z5yQI4vlCTWwAEN/FQw13o2P7RF2nZxMSj2f2QZ5k=;
 b=PwcXWE8BXYd2FfDD1eVnWzVvF/peCatmOKI6VrZ439GxMfSWMc6D9DdmvWYJzp/hEIZRrqwnnX052zJEP921BpQoCoF/aiutZCpwaFD3Evi4+hsyw19N+oWorpI+3Fo8oc+JN9c1oUgpL9+1vJ4O33CfThxvr+nbTBaLd6XbP7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DS0PR12MB8563.namprd12.prod.outlook.com (2603:10b6:8:165::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6886.36; Wed, 18 Oct 2023 11:46:48 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::90d5:d841:f95d:d414%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 11:46:48 +0000
Message-ID: <7f320e1a-0c69-f51b-bc4b-3346108197d8@amd.com>
Date:   Wed, 18 Oct 2023 18:46:37 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DS0PR12MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: 24f425d6-9efa-438c-35f8-08dbcfcfe8ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xb17wSsPwku9+uioTFlp2y+dm8wd+cbj6hxTLx6pfvMwPsaSx2/dKk+vTWWagQT1PD2Elf6nTvfVtU81kda5Y3SDd9phPxgM+Ap78DWxRRL0W0dv5kev4LDspL13HD9SQLOQIRz8xwp7WjBoNukF9Q3LZwVGJqChZoVW46BByVsGkq3SXFBqhojJKVm/xFUXAF7Vnon4KEWtYy+OBQLabaPPpk+gOyPX0hwaVNG3+TS4eFGwwWYbsXXevvgyZURx07KCr4MmS9DyuTYAqb9mR6FJdPpPwmLvGZDvJpC/65R9boS0WS6xKCrravP89p71b8WBi12ZFE21uQ2btGiaYf0wpiABZWxsP9jdv3fH+f1qikU1X7rjSp83mLVjwfOd6XT0xWGVyElxa4Eu9Vc3YVZbfVzcz3qgc5ooNVxFg3FNdJABzxuA5XoZnHLHebj8HectXMeIOIXsrFliiHizMpcJMFp8+eXGBQLkdcRuj40PUeI0NTAHUCJYS4ptiaP+bB1XetmxpIpQTLPnDrwvJcJ1i7r4BOfJyal5nZd6qL3uQ9TlmTvg2jecQgKpq2Mppse918NgTvHb/ZARcgD28QomaskAfEYUqHGWHZ9s3Bv7dv3N25f7dm+Pl6ZFxSeEaqMQKYJgbfk+bhyPbfFJi9/Aqx9Ek6wjHv2REVX98E4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(396003)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(31686004)(66556008)(66946007)(54906003)(6486002)(6666004)(478600001)(66476007)(31696002)(38100700002)(6512007)(316002)(26005)(86362001)(53546011)(6506007)(2616005)(41300700001)(36756003)(5660300002)(7416002)(8936002)(8676002)(2906002)(4326008)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEhUTTBwNEp6U2w0Vnh2THBpTHR6ZTZjejBVM0xIc201YjEzemkxQi9VSTVo?=
 =?utf-8?B?aU5QajJGQThWY1JBN1VTbjEwZHRicEJ4TXY2SSs3bkdvNWFMY3JvRmRBdUEz?=
 =?utf-8?B?Y3BpZTVSNkNycmVyR0FhSmlJVmMxOGxYQ2Q5aGpFK1gwZThneWw1c01ySmhY?=
 =?utf-8?B?YjJndjQxamxqRWl4dmtSMVZ1Tm1HYlJpanBhd3cza2drRzFpeXpEMVd2TW40?=
 =?utf-8?B?M1FBbHZINTcrQ1c4K0I5T0JyaEppakpxTDY1N0k5U0pJUlpxcmNQWDlVT2dV?=
 =?utf-8?B?WWZRNnc0cFR6SE1ZbnQzM1NXRnR3U3ErU2hpSDJaVFV6Sjdhanl6RVZUcEhJ?=
 =?utf-8?B?a3VtUjI1WmhaN2QyUkE2VEVoWkVRTkgwNW5ESUlQYytRUEZGOUVvQnpKcmZB?=
 =?utf-8?B?LzhLVWFhLzcxR0VGOGc4MUN5MkhYZVJnN1N2YTNOckJRWlFrb2pNRjR4aWNL?=
 =?utf-8?B?YXFac092UytDMWZab2tMR3FoZ2NOdHY5UDdYd1RpdkFRbVQwOU4wQzl1T25T?=
 =?utf-8?B?bGQ5aU01VHlvd0ZlbTZLekU0U2pHckV1Um1ROCtRN3MwclhwZzBIeENKVWhi?=
 =?utf-8?B?SDd3TGVFVk5CdTNWLzlqTW9lL2dzRmFoUHVkNXFjallRSUpWdzFrd1VGOTQ3?=
 =?utf-8?B?enp6Sk9YakxmcFVZY01GZ1pNL0VlMmYvOEFuVkhyYkM3RGVLRXFSU09WeW1E?=
 =?utf-8?B?L2dETmoxQVJDM21pNjI5T3ZYcUt3VEpiODcvc2VqS21PNnphcHNMbUhKVkQ1?=
 =?utf-8?B?SWYyMzl3YWgvd2VHdjMvT2pNK0JVRUNwOEV3aGxYUjNGSkw0VEdYZVVhenRF?=
 =?utf-8?B?QjRETlB4RXRtTG1ZNk9objIxekNoY3RUYmVLbDdUS2Vpa1NFQXRrcDRIemcv?=
 =?utf-8?B?cEsvVm1NOWVkSVc4a1diM1pTcmZ3bkRqQnlMbXlCUDZvMW1UdGxsSTkybU00?=
 =?utf-8?B?Nm5OaHNNYnNMbHE2TTc4WThabTh2UUQ4UXkvYVJVa1Bnc1BHY1IvdHdDTkRo?=
 =?utf-8?B?QXdNUEVOUVJPRGkzc1F1dHQvWmNjMDQ3U01KVmY2QzVwZTYwd1J5bUEzWHo0?=
 =?utf-8?B?ZkthYW9wbWFxREpoK3ByejBDdERLUGNKNnJVcFRoOWVuSzVVbTBDS05kRkpV?=
 =?utf-8?B?WXBkbjVscjdqaGk0emFwSFVVbm11SStMK2orakhjMUp5U0laR2ZCcTFNMGJE?=
 =?utf-8?B?R1hidGx4SGRSSTQrcWhNbkVtZm0vT3RSdkZNSm04R3VvNEhBWXJ1c3Rxenpo?=
 =?utf-8?B?RlVDTDBVNHgvaUlqOHB5emNpM2JJUGhsOG9CcXlJbHBWYXRTazkrcXE4a2Ex?=
 =?utf-8?B?RVJUdHN3RXFFWkVqc3pITng2dmJudm5tOHVHUnVNeE55c01LcEZic0ZMVTZ1?=
 =?utf-8?B?NkFScUdYWmpuUHV2ZUQ0OU1XN2FzVExOcGhKWlJsbnZEL1dJQXNhRmtrY0M0?=
 =?utf-8?B?UWMyd3FiNVJuWTVmYU5DcS9JZzVpeFhYWjFXcXZoczcwdGlZbmJQd2hMaGlD?=
 =?utf-8?B?dmFtVmFWRktWNDlhcDZ6VXdxeU5xS200NDFDWmhOTURVN0FaTjdCV3dvdWIw?=
 =?utf-8?B?b3ZodjhkNUNsSlBHbkxiV0ZkVk8yS05IK0drVjV1Tk14MmFnT0ZkR2Ftdkk0?=
 =?utf-8?B?MU15dHFNMktaK2FpS0pWQXJYcGEybGF0M0tYVWdxTUZUci9EUmVCdlRKT1Fn?=
 =?utf-8?B?OHFxOVVEcml4RGkrVXBYUFc5M2xYZ1RLWXdYMEFLeTlLV1E3eDZpSWZTK2hZ?=
 =?utf-8?B?Zkp5TXZBb1FydmQ0ZUVzNDltWlVycVRyUDBLSEVQem1NR0JRK284L0VlZmhK?=
 =?utf-8?B?b0ZQKzNRWCtqZW9tdDQySjZRTHB0WDFnR0VtT2RMaHh4Tlg2WnNoMTlSM1B0?=
 =?utf-8?B?N3N1RjkvZzM2bGdaekNBOVVISVI3V0RrbzYxY3pXVVRmQzNRdzUxOUtWYjVa?=
 =?utf-8?B?cFFMMFBvaVR4M09VUEV0eldxa2ZBaWNRNSttSmtaRnJvRnU2ZkNqYituNU1z?=
 =?utf-8?B?NTB0MThYOHdJdG5IRjRQakhkb0tibStUdHZjTWRTVmV5MmFYRUF0Q3p6OXM0?=
 =?utf-8?B?V0VQN2NTODQ5VEhsMzh5V29Wc0x0WjZtRk1nVmpRcFlTMXZScGd2dTdZbG44?=
 =?utf-8?Q?o3Jnq8M75ZodRtA8ocTiJBDAq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f425d6-9efa-438c-35f8-08dbcfcfe8ed
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 11:46:47.9375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AvVaoDlHGLjLHQ9pZhTi2N6mWhstTmCVMHVm71e5hgIPLgRfx1/7KWvIDbve+GPc71y8IiPBB/wYmF8oPDZIAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8563
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joao,

On 10/17/2023 4:54 PM, Joao Martins wrote:
> On 17/10/2023 09:18, Suthikulpanit, Suravee wrote:
>> Hi Joao,
>>
>> On 9/23/2023 8:25 AM, Joao Martins wrote:
>>> ...
>>> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
>>> index 2892aa1b4dc1..099ccb04f52f 100644
>>> --- a/drivers/iommu/amd/io_pgtable.c
>>> +++ b/drivers/iommu/amd/io_pgtable.c
>>> @@ -486,6 +486,89 @@ static phys_addr_t iommu_v1_iova_to_phys(struct
>>> io_pgtable_ops *ops, unsigned lo
>>>        return (__pte & ~offset_mask) | (iova & offset_mask);
>>>    }
>>>    +static bool pte_test_dirty(u64 *ptep, unsigned long size)
>>> +{
>>> +    bool dirty = false;
>>> +    int i, count;
>>> +
>>> +    /*
>>> +     * 2.2.3.2 Host Dirty Support
>>> +     * When a non-default page size is used , software must OR the
>>> +     * Dirty bits in all of the replicated host PTEs used to map
>>> +     * the page. The IOMMU does not guarantee the Dirty bits are
>>> +     * set in all of the replicated PTEs. Any portion of the page
>>> +     * may have been written even if the Dirty bit is set in only
>>> +     * one of the replicated PTEs.
>>> +     */
>>> +    count = PAGE_SIZE_PTE_COUNT(size);
>>> +    for (i = 0; i < count; i++) {
>>> +        if (test_bit(IOMMU_PTE_HD_BIT, (unsigned long *) &ptep[i])) {
>>> +            dirty = true;
>>> +            break;
>>> +        }
>>> +    }
>>> +
>>> +    return dirty;
>>> +}
>>> +
>>> +static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size)
>>> +{
>>> +    bool dirty = false;
>>> +    int i, count;
>>> +
>>> +    /*
>>> +     * 2.2.3.2 Host Dirty Support
>>> +     * When a non-default page size is used , software must OR the
>>> +     * Dirty bits in all of the replicated host PTEs used to map
>>> +     * the page. The IOMMU does not guarantee the Dirty bits are
>>> +     * set in all of the replicated PTEs. Any portion of the page
>>> +     * may have been written even if the Dirty bit is set in only
>>> +     * one of the replicated PTEs.
>>> +     */
>>> +    count = PAGE_SIZE_PTE_COUNT(size);
>>> +    for (i = 0; i < count; i++)
>>> +        if (test_and_clear_bit(IOMMU_PTE_HD_BIT,
>>> +                    (unsigned long *) &ptep[i]))
>>> +            dirty = true;
>>> +
>>> +    return dirty;
>>> +}
>>
>> Can we consolidate the two functions above where we can pass the flag and check
>> if IOMMU_DIRTY_NO_CLEAR is set?
>>
> I guess so yes -- it was initially to have an efficient tight loop to check all
> replicated PTEs, but I think I found a way to merge everything e.g.
> 
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index 099ccb04f52f..953f867b4943 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -486,8 +486,10 @@ static phys_addr_t iommu_v1_iova_to_phys(struct
> io_pgtable_ops *ops, unsigned lo
>          return (__pte & ~offset_mask) | (iova & offset_mask);
>   }
> 
> -static bool pte_test_dirty(u64 *ptep, unsigned long size)
> +static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size,
> +                                    unsigned long flags)
>   {
> +       bool test_only = flags & IOMMU_DIRTY_NO_CLEAR;
>          bool dirty = false;
>          int i, count;
> 
> @@ -501,35 +503,20 @@ static bool pte_test_dirty(u64 *ptep, unsigned long size)
>           * one of the replicated PTEs.
>           */
>          count = PAGE_SIZE_PTE_COUNT(size);
> -       for (i = 0; i < count; i++) {
> -               if (test_bit(IOMMU_PTE_HD_BIT, (unsigned long *) &ptep[i])) {
> +       for (i = 0; i < count && test_only; i++) {
> +               if (test_bit(IOMMU_PTE_HD_BIT,
> +                            (unsigned long *) &ptep[i])) {
>                          dirty = true;
>                          break;
>                  }
>          }
> 
> -       return dirty;
> -}
> -
> -static bool pte_test_and_clear_dirty(u64 *ptep, unsigned long size)
> -{
> -       bool dirty = false;
> -       int i, count;
> -
> -       /*
> -        * 2.2.3.2 Host Dirty Support
> -        * When a non-default page size is used , software must OR the
> -        * Dirty bits in all of the replicated host PTEs used to map
> -        * the page. The IOMMU does not guarantee the Dirty bits are
> -        * set in all of the replicated PTEs. Any portion of the page
> -        * may have been written even if the Dirty bit is set in only
> -        * one of the replicated PTEs.
> -        */
> -       count = PAGE_SIZE_PTE_COUNT(size);
> -       for (i = 0; i < count; i++)
> +       for (i = 0; i < count && !test_only; i++) {
>                  if (test_and_clear_bit(IOMMU_PTE_HD_BIT,
> -                                       (unsigned long *) &ptep[i]))
> +                                      (unsigned long *) &ptep[i])) {
>                          dirty = true;
> +               }
> +       }
> 
>          return dirty;
>   }
> @@ -559,9 +546,7 @@ static int iommu_v1_read_and_clear_dirty(struct
> io_pgtable_ops *ops,
>                   * Mark the whole IOVA range as dirty even if only one of
>                   * the replicated PTEs were marked dirty.
>                   */
> -               if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
> -                               pte_test_dirty(ptep, pgsize)) ||
> -                   pte_test_and_clear_dirty(ptep, pgsize))
> +               if (pte_test_and_clear_dirty(ptep, pgsize, flags))
>                          iommu_dirty_bitmap_record(dirty, iova, pgsize);
>                  iova += pgsize;
>          } while (iova < end);
> 
>>> +
>>> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
>>> +                     unsigned long iova, size_t size,
>>> +                     unsigned long flags,
>>> +                     struct iommu_dirty_bitmap *dirty)
>>> +{
>>> +    struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
>>> +    unsigned long end = iova + size - 1;
>>> +
>>> +    do {
>>> +        unsigned long pgsize = 0;
>>> +        u64 *ptep, pte;
>>> +
>>> +        ptep = fetch_pte(pgtable, iova, &pgsize);
>>> +        if (ptep)
>>> +            pte = READ_ONCE(*ptep);
>>> +        if (!ptep || !IOMMU_PTE_PRESENT(pte)) {
>>> +            pgsize = pgsize ?: PTE_LEVEL_PAGE_SIZE(0);
>>> +            iova += pgsize;
>>> +            continue;
>>> +        }
>>> +
>>> +        /*
>>> +         * Mark the whole IOVA range as dirty even if only one of
>>> +         * the replicated PTEs were marked dirty.
>>> +         */
>>> +        if (((flags & IOMMU_DIRTY_NO_CLEAR) &&
>>> +                pte_test_dirty(ptep, pgsize)) ||
>>> +            pte_test_and_clear_dirty(ptep, pgsize))
>>> +            iommu_dirty_bitmap_record(dirty, iova, pgsize);
>>> +        iova += pgsize;
>>> +    } while (iova < end);
>>> +
> 
> You earlier point made me discover that the test-only case might end up clearing
> the PTE unnecessarily. But I have addressed it in the previous comment

Reviewed by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thanks,
Suravee
