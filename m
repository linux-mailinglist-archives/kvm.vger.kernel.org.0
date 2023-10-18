Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5A87CD765
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 11:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjJRJD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 05:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJRJD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 05:03:27 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A8DEA
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 02:03:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPqvsvugTe2FhjHJePL3e8/l0+Vb8la13203cu7Es21ThNNOra56KvZmeQcz4QOZYi9WOV2tbRKEVAW0q+ujVdAI7blKXUzwTDbky5AINAjgEXm+1VntiP7HMnCxie8q8uGhQBsCn3LQpj1tI2QVdQxNJIZFNNp0+m85j7Jh34TmOV6qRXgwW9AaYGdP+et7BhdoNLTTYWvAvQS/PJIPB6WUpXksPCsu7MAIms8V9iqpDK9YeT7hAREGfsEmCh2jcvnbWzrmhfgsawZvIqhn3rp8P0unvHFtQIEQlFyw5r0NRkMwgXVCWvzv9CKTmQA2v1aleDd28D4/M6OWgOrc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dj+oiAjjd4Wf54Dfkw2oRSXIQ3s2g2Dq2QL4Uvkt1fY=;
 b=Vpo+PZ7bCmo+7DzDnQdNYHXV6LRyC7/tG6FDzhPrVm68lfMUbooh98B2R3KAqqxOj4BhjbACnJKfPXPKTXUHL7Apnu8Zd8xTHMFAGjjIxvfjNNmy6K60k56tYSPOOImB2VlexS/By5UmELKdYV+pBEs7GsJeySHWxw21oo36nq65DHPo8q4F12xwtq6EnzpPeHxbeQLYCdCT8VgKW85dqBIIQfUZG7d+WsYnZ8HeLGJ0bRaZ1Jsy4E0NLJoLMadnZYzD+z+PwiBd7T19aWQ5RLgmb6Ev8BlfVzu+SKX1ZKxphYFui/M3oFGmVeV6bhk3Vt8AuIfciRk0Mq3oVVeJ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dj+oiAjjd4Wf54Dfkw2oRSXIQ3s2g2Dq2QL4Uvkt1fY=;
 b=ochlVuFCVrU62SGnWq4/+J98PIJ33/6TWssi5zq55DPYSbdMCIzbe4hTTNXX4mGGwKnhIGqLpCiSyA84GWRSwVxGukC+MMAHjqr6i581HB1W9arkpw7bnq/WQAUluqDfJk8X7cJvMzyDMd0W9Cd1NF3jMO5iELGpICBLzHUxBeE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 MW3PR12MB4443.namprd12.prod.outlook.com (2603:10b6:303:2d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.23; Wed, 18 Oct 2023 09:03:21 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::726d:296a:5a0b:1e98]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::726d:296a:5a0b:1e98%4]) with mapi id 15.20.6886.037; Wed, 18 Oct 2023
 09:03:21 +0000
Message-ID: <2f78d1c7-694c-154e-51d0-4e3cd9b9b769@amd.com>
Date:   Wed, 18 Oct 2023 14:33:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 18/19] iommu/amd: Print access/dirty bits if supported
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-19-joao.m.martins@oracle.com>
 <b7cb98c2-6500-1917-b528-4e4a97fc194d@amd.com>
 <e128845a-c5f8-4152-9781-cd7b5026ea8c@oracle.com>
From:   Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <e128845a-c5f8-4152-9781-cd7b5026ea8c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0228.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::16) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|MW3PR12MB4443:EE_
X-MS-Office365-Filtering-Correlation-Id: 168b3912-3044-414e-00e5-08dbcfb913d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dd1VowJwtNmTGZGostXRBZVBk7xw0XEkx9bxHsaoO+VG7EzBTTWuQU5bU972wXc1ReduF7wFQxFEIsL82iAEh1wp0hMRPJZDj5iYJtHaSbPyHN3BrR5W0Lyssb/tfK0dCtFlYpvwws5NXps4KTzfcjca2spIgpG3hSawSidS0R1v2HxVJe7D2VKqXY2qSjm627eaptS+G1nSOKgCm+WQpdnwB7sC4nWR0J5sYHAXcalBHBQ/GU2UIS15X7YgzK0kA5gSNymgrlH8D42UaT2D5iVXgBUnRWT+Vjb7cLq08/ccWL85wPwHSuadTTF9c6jYFeJbvLz2ooGsGni2eFUVz2XOfOqvI0Eoj9bGO+2IyXzGzgmWOjgC7KeIceGX8KSPGAIIps+cvFM3dqNJtXPasKbFqBiwMB0Gowyels5K7EB+5SkOgqZxByi5SyjqfYe/OeDHNHD4nGw4USMGv1w75Ju3T2Y+v2v5+86XDBRBZgb031O0kcDSEADND5g2t8h2zVuDMk/520VeZyrfosf84eGe95Co2Cr/6AvzYsw7V/YPYsNzPepkAFhdx4CWtqMDjFhETXifCFr8vG2XEpzeuUBIFoBnprV9DlJ0NCD77WOBeiIQ3OQEP5hvE0bCdwb6afOo9ciSlbdPojN5vVV9vb0Ewlu58nHfSr2zLFcaNEk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(376002)(39860400002)(396003)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(31686004)(26005)(38100700002)(83380400001)(7416002)(44832011)(41300700001)(66946007)(66556008)(66476007)(8936002)(8676002)(4326008)(5660300002)(54906003)(2906002)(31696002)(316002)(86362001)(966005)(6486002)(6506007)(53546011)(478600001)(6666004)(2616005)(6512007)(36756003)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGlUVmhwL3NrQkwxcjZtY2w2ZkF3L3AyTGw2U1NkZ1RxVlJOcTAzV1FvMkg5?=
 =?utf-8?B?MHNaaUYwTGpma0hjR1JPMkx2OXZNZS9iNVBiMmRXSjEycFZNd21KRDEzb2cx?=
 =?utf-8?B?ZnZVVkg4V2k1SU1OR1pMM1FUaEFYdW5OMEpxd0t4eG02YVVDNGtYbGwwUWMw?=
 =?utf-8?B?QWVMdjV0eEZLTWxWSHVMUXZ0azhnc2Rld1NYZS9BTDc2U2xmcXpOOVBCaHU0?=
 =?utf-8?B?WG5xSW4zTzdVNHA3dWtMYTliMkFMU1g4dVpVbjhscmNWdDJ6dzNQWUt3V0ZO?=
 =?utf-8?B?d1lRTzRkVFpvL0VVeTIvblpBRStHbG9XdFZ2bDI4TGFYQ29uQk9GUVJ6Qjkv?=
 =?utf-8?B?eHgxV004YmhXUkhka3M5SVJyc3ozTmlzdjdMVUtNR0E5d2M4Vk9sbnJEd1Nk?=
 =?utf-8?B?TTV0WmJLclkvUGRxd3h3eDBvN1pXTjBQWGxZMDVuSklJTWNGYzNDZzl6OGp6?=
 =?utf-8?B?MFJmeCs3OGtuUytseDdJNkthT2hEaHZnTEN1YlFzU2phU2xheCtnbFRlRjVS?=
 =?utf-8?B?YjgrcWJlMzFoa1FjaWdnaUlwaTdiVnNrbmxaMlhUYUhSV1hENUtMQnRDNTRi?=
 =?utf-8?B?amFLTTE4TEVINk15RGhNVEovZjRBUW5BRWxvVzdWUTdSV0JabE0zRGRiM2pt?=
 =?utf-8?B?RlVNdWVLaVZQTjJYYjlkdXp0aFAzdDhabEVtOEtzRE5mWFBHT05kdmNBQ2Ex?=
 =?utf-8?B?ZDRtUGJmMFZkMTZibjBFR1NLNkRSeTFzNCtVYVdLeVQ2dDVaV1dYMmRobjBT?=
 =?utf-8?B?cFd6S0wxZFA4OXBOQnJvS3E2U2hVRWViRk56ajI3WEs3dW8vSVhTb0lncncx?=
 =?utf-8?B?V2dTQStsRU8yVnoxUEVCMGp5YlRibzFPMEdFanhEWWoyYkV1Y2VLVURiRCtP?=
 =?utf-8?B?K1BOa0hNQllBMUNkenNHZDFnUHNvQ1Fud2gveEMwMlBxc0NJdTZLMkFxNmgr?=
 =?utf-8?B?N3AwNVZrbDZLWnI3RW9WVlFlWm5YZHpGNU90aDUxYVBYS2U5SUNuZmFPYjRE?=
 =?utf-8?B?TFY5QnliZ05Ub2pPTUNMNytjSFlyVTRkVWRrS2N0ejByVjU1dk5rZElvSWdS?=
 =?utf-8?B?Mk1GRWduRlFKazI0ZldkMHFGOU1KM0NKVUpwTzFtTFhaRkJ0Vi9OcXAzSXU5?=
 =?utf-8?B?ZWZhZDdMTEFCa1NpdUFmL2p0djhZTkFSa0hXWTd6N09FUEFrVk5ST2dGaWJB?=
 =?utf-8?B?WlY5a29ybzhzaGJ3UW5HSlNNMHVOQmxhUTZuVXdRSUNoT2dwSzREM2FReGJx?=
 =?utf-8?B?ZjIvK0p4TlNuajZjdjNaNE1BMy9BaXFTVEFyYm1LRlZBTGdhbmtvN1JDRFov?=
 =?utf-8?B?aTVEemJFK2U3bUFjdzdHMmNKMzdnaE9jVEhROG45b0RTaWt3bytkdlZJa0ho?=
 =?utf-8?B?R2VVaEVBSTVWN1dmSWgrUk5tMmpsNFdZZmRhbW91YU1YYllnMk9qTkluMGMz?=
 =?utf-8?B?RDZtcDErV2d1aVA3ZkUyMmM3eElwT1RRK0xZQXFlQ3gwYXIxZjRMTlYyUHYx?=
 =?utf-8?B?SklCZktlUHJoOW4waGVNcE1jVzdQK1hrQ2doTmY1SnBHVkZic2owRlYzS2dY?=
 =?utf-8?B?dFpMYWdObDNHSEs4eTRBVUV0QjVqZ3pEZHNsVm16TGxYTnNSZDc0WjczUlo0?=
 =?utf-8?B?K1IralFqYmx6UHNsVDg5UnlyZTBhMG9nNmlSOG1NQmU2amg2enFXekw5WUFn?=
 =?utf-8?B?OXRpYUJtNG1MSnQxTkllbU9LWDZJZzhsQ2JCL3Vmd0s3STEzNzQ2WFplOURu?=
 =?utf-8?B?bzdzZjQ5N2pCS01aNi96eWljYjJGNnRhTWdSN0ZEd1UxVVpqZkFsNzc3LzV3?=
 =?utf-8?B?MHN1RnYzTmI3Qy9PbjYzVnJ6WXF3bVlHVDJybG5ZekdiN2FEd0E4ZHB5SDMv?=
 =?utf-8?B?N0JRd2Y0ekV3K2xKZ3UwVlJyVGJVNlptQ2ZEb0NOSjM1ZHFzem5wWHk2WUpz?=
 =?utf-8?B?SDlzMkkyK1o2YnNwUEFTd0MyZlB2WXEwUzdKd0Zva2c3U3o3bXBTVFhXaVgw?=
 =?utf-8?B?d1JzNE1LbDlzaHhndlZxQzR1MEpndnZIV2ZGcUwzVFcydWM0KzNlRGIxZFow?=
 =?utf-8?B?MFRCNGVhTzYxaWFrWWs5czlGV2ViK05mTjVoYWYraldENHhsYkMzaTU4MzdM?=
 =?utf-8?Q?nHR7OH2DWBgA/dJXHN51zoqmI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 168b3912-3044-414e-00e5-08dbcfb913d6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 09:03:21.5378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pc2WQ3YU8NlUCvv9M9oHmLq/7Wq1CmpSRMWoyc/ALzMaE8gdKl0n8xVzmcuWPmETBLvDm7oZi1hG9ehGBfVLgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4443
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

On 10/18/2023 2:23 PM, Joao Martins wrote:
> On 18/10/2023 09:32, Vasant Hegde wrote:
>> Joao,
>>
>> On 9/23/2023 6:55 AM, Joao Martins wrote:
>>> Print the feature, much like other kernel-supported features.
>>>
>>> One can still probe its actual hw support via sysfs, regardless
>>> of what the kernel does.
>>>
>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>> ---
>>>  drivers/iommu/amd/init.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>> index 45efb7e5d725..b091a3d10819 100644
>>> --- a/drivers/iommu/amd/init.c
>>> +++ b/drivers/iommu/amd/init.c
>>> @@ -2208,6 +2208,10 @@ static void print_iommu_info(void)
>>>  
>>>  			if (iommu->features & FEATURE_GAM_VAPIC)
>>>  				pr_cont(" GA_vAPIC");
>>> +			if (iommu->features & FEATURE_HASUP)
>>> +				pr_cont(" HASup");
>>> +			if (iommu->features & FEATURE_HDSUP)
>>> +				pr_cont(" HDSup");
>>
>> Note that this has a conflict with iommu/next branch. But it should be fairly
>> straight to fix it. Otherwise patch looks good to me.
>>
> I guess it's this patch, thanks for reminding:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/commit/drivers/iommu/amd/init.c?h=next&id=7b7563a93437ef945c829538da28f0095f1603ec

Right.

> 
> But then it's the same problem as the previous patch. The loop above is enterily
> reworked, so the code above won't work, and the "iommu->features &" conditionals
> needs to be replaced with a check_feature(FEATURE_HDSUP) and
> check_feature(FEATURE_HASUP). And depending on the order of pull requests this
> is problematic. The previous patch can get away with direct usage of
> amd_iommu_efr, but this one sadly no.
> 
> I can skip this patch in particular for v4 and re-submit after -rc1 when
> everything is aligned. It is only for user experience about console printing two
> strings. Real feature probe is not affected users still have the old sysfs
> interface, and these days IOMMUFD GET_HW_INFO which userspace/VMM will rely on.

IIUC this can be an independent patch and doesn't have strict dependency on this
series itself. May be you can rebase it on top of iommu/next and post it separately?


-Vasant
