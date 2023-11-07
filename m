Return-Path: <kvm+bounces-1085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC427E4A81
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 22:21:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C05F3B210E0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A042D2A1D8;
	Tue,  7 Nov 2023 21:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F6y1tcHr"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AC92A1C8;
	Tue,  7 Nov 2023 21:21:37 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF71D79;
	Tue,  7 Nov 2023 13:21:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkdozjUI3Xvc1uL/RehkXeARmjbEsqYygZd/9lY5PBgFrBAwugRijcfTKZeppktNSdcKj3BfW1DWtL0JzOpCvxdomprovOP8FErFKFXwtWcrCjZe5Ozuxv2d576+eT0lGOJhPsIP9PDM+7rwEo5eLHoHL3HUB5fdAd484ZUqsjRU7H17Pv2u4+JxmzX1sZIvId0qlvsNkoyPaNopELlPx+09MpqjqLGawWqBg5N46d72BkvLxY5ojNpvQibejJNwIawbjzz11k9vNprjVbV0kGDdGEIVr17olHwspEpF4AbjuhsZga95Lme2gMiM3XoV3WNh37SxE4bTB3zzN7moKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vr/OIpwYFN2GNmOixGyK/Z1oAJhk/nqQiPcKV6yEITY=;
 b=P5xUft/uwa76O1yORyB7IR8XVyZKhoxiTyd2jFPyLAKm5s3L428IN5IZSx6WJOtsyLgtYzVi0b2XQKjU6a7PWSfBxaZy0pW/u9P9owCRtxtQweWp+vVMsHHefr5Kadh7oDrE1SZa9nHb1quMyg/xazLtAQzvnz6wJUOYPRhDjaXmjIwOyh0mEvh5g1a74at8CreZT7BuKFqg6SGTDnATw1mUmctTi0Hf1PhTjnUp2YTZlF6nPj9n7Dldc4YVvGrTluQGKpBmG/tofJCKYOxDx+L41DrrhQkUBrSCfhfQiPqf697SnNSFs1SBPSTC3JcPFQET1zI9t8cSf6cXxzZaxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vr/OIpwYFN2GNmOixGyK/Z1oAJhk/nqQiPcKV6yEITY=;
 b=F6y1tcHrxWF0ZMtV/1W9ZM0zTBH2YNVMUvZxZ/YB4L/O0/V6DM1XK+EHQe2Jmhx6eojiVYvn6nNpAkElm761nDIvpPJK4PEuD3TeNK9gWunsxzjJ6c0mYg+ALGxba8XE8zNtBFMLjhVaymgQiY+R7EkMDaShTfGul5dJXDLhrM8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ0PR12MB6782.namprd12.prod.outlook.com (2603:10b6:a03:44d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 21:21:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%6]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 21:21:34 +0000
Message-ID: <250f5513-91c0-d0b5-cb59-439e26ba16dc@amd.com>
Date: Tue, 7 Nov 2023 15:21:29 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
 <20231107191931.GCZUqNwxP8JcSbjZ0/@fat_crate.local>
 <20231107202757.GEZUqdzYyzVBHTBhZX@fat_crate.local>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231107202757.GEZUqdzYyzVBHTBhZX@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR18CA0003.namprd18.prod.outlook.com
 (2603:10b6:5:15b::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SJ0PR12MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ca68b21-ce9d-4fff-b0e1-08dbdfd7848f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fqMTtW/bbYPU5iH0X4DIgpbEYeoxKWBsSF2J7II3Lkib/t5LCYpe1XyCCS8fbBh1tsGYOqnhiVdNDxI9XU5INOUextB7uE68E+O0nzHw+Udkj9gy9yVMd1Hxe4O5qh5TyT4hPtc6zIoJ/ns4tzyU2KZpMlIdU4avBaskzvpR1xjJXXY6JTLPLTg0iAj6yiH7BV+lDoRWWkmdRZN+3dDVqQC+DUWiQ/1weFaMV66dhafrfU+5OqRgPxL+VMQJ8JVkqjAlD5SES4rM21WT0az8OQMMk3gxN8nsOilRxJ4CxMiF3B0KokWFVcOwlViVmZKi//h46QXUly6843dHZVxej+IhFy1jze5mdfoTBiPYQ1g2n/V7JU4+f+Nu2NlXxlQiOKv2mKK+eiShCABWmV2MgcaWLgpHNv1ZHRwAb4zbkW5c+WiUpndO1/YyOrvKii2ApvEf0NO2S1xhFsBvUI/qM6dKoSVM+TXuI+IXKsQDLOGQl2ihmoGJE5ngjWvL9TN3eN8zKP8W0bldVFVWLSWG9BKYrn4O7W/gcOFtCBmpeWGNMlhsgaIl0j8gYxb7NmnifE6HY1JOlYmMiW5Ce+Ozmk+5UGV/uAf/SazFvNAlaBTmCaX4D8rSxs+C02mfGl2Uowwhp3yvTpyT/4eSS6JlbA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(39860400002)(376002)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6512007)(2616005)(31696002)(26005)(478600001)(36756003)(66946007)(6916009)(66556008)(66476007)(54906003)(316002)(53546011)(6506007)(6666004)(8676002)(8936002)(5660300002)(4326008)(6486002)(2906002)(41300700001)(38100700002)(7406005)(83380400001)(86362001)(31686004)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGt4dWsyTGJCT2dkNEE1ZXFrNmkyQXFNVDVkYjlYc1RnaUNwa1AyU0dSMjkv?=
 =?utf-8?B?NThaUkNXT0J0U2FLamVoNzZDdU55b2NJK1ZLbFZhU3FVOTNTYklVVCtiNXQ2?=
 =?utf-8?B?d3VWU0cxUEtPSmdqcVR0TGl4Z3hFcGNhcVZIc2pzemNzc3BJQlJwaEhJYUc5?=
 =?utf-8?B?cFpFNGlkNlFTV1owRTZxVDE0SFhKdTlRdGUvR3RlandTOUJncDFCMzhxSmtm?=
 =?utf-8?B?bXZnWmsyK21tZDh5TktkbkdsdVNMS3BTUEszOGhOMWRaeVB4MTFKSi9Hd1JF?=
 =?utf-8?B?eGtkdU9xVWVaUHA0K3NLVHdrajFsR0JjczlYSGZrK0xiSDEveUZ4QktlNXg3?=
 =?utf-8?B?OXc5ZDFVTDZJQjRmNURhaDZwZU1rV0dSQ0s3bHhMVEthWEpJWUlsNDYrYTd2?=
 =?utf-8?B?Y0hoMDQvay9DaTRFNk4wOVplYmpwZ3Rrcld0WFgxOXEwdTNLTk1IOEsxV3ZS?=
 =?utf-8?B?NWNxVDVBdFUzaHlRUzZsRHR6QmFucmJLWHZXUjk0UkcyNnNPYmVrL256QVc4?=
 =?utf-8?B?Z2wxRE5HTlhaOWkwRGpFRk43dEhCTDhZam9HN3Nkazh3Y2hkK1hNbDl4WVEy?=
 =?utf-8?B?cWxwUnJSc2IxS1IzME1acVNHWFdtdjRiNFJ2aVg3TUtDczBIcnZkR1NOVW50?=
 =?utf-8?B?Mk96UHNQOGF2NHlWb21RVzRmVHFGR3ZzT0JEbkNuZEV6NDlzY1FwVmJTa0Jn?=
 =?utf-8?B?ekFwam9aaTB3c3NTenBBbEJHdEl5VEQwR29WLzhPcjFVbmVTRTlXMVZaNG13?=
 =?utf-8?B?dzlFYmdaN1dPSmpudEdpays5NU1WMjd6VzJhSURocUJzWm9WVk1xUFN5c1Vx?=
 =?utf-8?B?bER1V2JTVTRMUTVSTDc1azNncyt4LzdsWW8wckZjRzhkekljV01MUmgwUTAw?=
 =?utf-8?B?WEdCNlg1K2VhUE91R1IyTG9BaDJja0RRR1hieGdJcVdDYmVoVy9rMlZ2dWpw?=
 =?utf-8?B?VFdyZVJPNGxMNTVwd1NkUTBYanhrNnRyTWNSaGdkSVhLVGozd0VKbHhmN3pr?=
 =?utf-8?B?M2VjT2lGbDBqUCt3d01uK2NFRTZyekpXWUJhMThaVjVpdHR4aTBicDNXa3hJ?=
 =?utf-8?B?clhuNnh1WFlPZXZTVU5vTlJtbitxUWhZdTRkS2ZKM2FJUC9jMUxLYjZ6c01I?=
 =?utf-8?B?MGoxOGxNTUpTbldBQnYyRXVpZ2lzc1B5VU5NWVNTamR3ODIvTG4xSzlPYnBI?=
 =?utf-8?B?ZW5uUGJiMCtneFNQWFJ3YlhnYkk0ZmdrVXBxWWUxRCtlQlIwMG8wUmIzZnNW?=
 =?utf-8?B?QnJYY1FxUjdwT2h2TUxlMUZneUkwVlBBOWswdkhCUS81YTlnZGZuMUd6bkk0?=
 =?utf-8?B?RElqZ3BYclkzU3VoK3E3M09sVDZvbWZOK1VxNjg5akxHdE5UYkhaMDUzTmRR?=
 =?utf-8?B?WEJPeVFwS040ZHlEU2UzQWtscnNoK2tobWFKWW16UjB5dTFOV2NYSjdkeGJl?=
 =?utf-8?B?aUVzUEU2VjFQUkhxWW5EQzE5MmVkSXJvUStaUmlqWDhHWEVMbElGQVNvR1Bm?=
 =?utf-8?B?ZDNBcCtYZHVudW5hVmhpRHJyYUVCVy9GNURSbG5RZml1U3B6SU9ock44cTN5?=
 =?utf-8?B?SjZraXQ3UVE2eXNVcVlRYmpUK1d1UFMrbzRidnNsWWdvVUp6MG5vTk1RNkxY?=
 =?utf-8?B?R1MrUU1xUUlIUVpmdk5saWkraDNGMzVrMlFxRDVrN1Y3ZWVkQXZkS3MxY1Vj?=
 =?utf-8?B?bGJDejh5RXJuTFJzeDhtLzJPRWJZcFRGUXdEMXMxYTlOazZJanRhT0o0d2Fv?=
 =?utf-8?B?VmpJVktham9Mc1ZLaCtyZmRUYXFSeE1odkxlUVNTZFVNUjFsUysvbmlnWW91?=
 =?utf-8?B?RWtMWVdGNzlGK0pIYkNpQmZFbFBuWkNBaUUwWE82d2xSTlpMTDFITVM2dlZO?=
 =?utf-8?B?ek9vcXZiQm9JQk56WWFTSXkrV3JsUmJsZ2ZuY01JMlRqV3pQNVBKSk5mTmQy?=
 =?utf-8?B?dUd0UXB4RUx0dGRpOVVoRUYrL3Vwa0lHWE5ZbVdzVDZpZnkrRUQrdE1rZXVR?=
 =?utf-8?B?OURQS3BPbFN2NDhnUVJFWEtIMkdESnk4MUVQaWQrVnJWUm5HT0s2d0tLMlBk?=
 =?utf-8?B?N1VFVGJmNW8rZ010NkZmY3hKNm5VSmx2Z3Y5MEJOTG5QcTVWWXcrQml5bDNh?=
 =?utf-8?Q?gXpgu6a3SMeDvd0D7meWf/8AW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca68b21-ce9d-4fff-b0e1-08dbdfd7848f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 21:21:34.0067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xGimx9W99zlTZaQc6E55qNYct7WD/WUz5tr4tRXBOhxcNNOPO1VhlwfRkeoUHFFog5XvxSQ+sYcXovUKlqhKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6782

On 11/7/2023 2:27 PM, Borislav Petkov wrote:
> On Tue, Nov 07, 2023 at 08:19:31PM +0100, Borislav Petkov wrote:
>> Arch code does not call drivers - arch code sets up the arch and
>> provides facilities which the drivers use.
> 
> IOW (just an example diff):
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 1c9924de607a..00cdbc844961 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3290,6 +3290,7 @@ static int __init state_next(void)
>   		break;
>   	case IOMMU_ENABLED:
>   		register_syscore_ops(&amd_iommu_syscore_ops);
> +		amd_iommu_snp_enable();
>   		ret = amd_iommu_init_pci();
>   		init_state = ret ? IOMMU_INIT_ERROR : IOMMU_PCI_INIT;
>   		break;
> @@ -3814,16 +3815,6 @@ int amd_iommu_snp_enable(void)
>   		return -EINVAL;
>   	}
>   
> -	/*
> -	 * Prevent enabling SNP after IOMMU_ENABLED state because this process
> -	 * affect how IOMMU driver sets up data structures and configures
> -	 * IOMMU hardware.
> -	 */
> -	if (init_state > IOMMU_ENABLED) {
> -		pr_err("SNP: Too late to enable SNP for IOMMU.\n");
> -		return -EINVAL;
> -	}
> -
>   	amd_iommu_snp_en = check_feature_on_all_iommus(FEATURE_SNP);
>   	if (!amd_iommu_snp_en)
>   		return -EINVAL;
> 
> and now you only need to line up snp_rmptable_init() after IOMMU init
> instead of having it be a fs_initcall which happens right after
> pci_subsys_init() so that PCI is there but at the right time when iommu
> init state is at IOMMU_ENABLED but no later because then it is too late.
> 
> And there you need to test amd_iommu_snp_en which is already exported
> anyway.
> 
> Ok?
> 

No, this is not correct as this will always enable SNP support on IOMMU 
even when SNP support is not supported and enabled on the platform, and 
then we will do stuff like forcing IOMMU v1 pagetables which we really 
don't want to do if SNP is not supported and enabled on the platform.

That's what snp_rmptable_init() calling amd_iommu_snp_enable() ensures 
that SNP on IOMMU is *only* enabled when platform/arch support for it is 
detected and enabled.

And isn't IOMMU driver always going to be built-in and isn't it part of 
the platform support (not arch code, but surely platform specific code)?
(IOMMU enablement is requirement for SNP).

Thanks,
Ashish

