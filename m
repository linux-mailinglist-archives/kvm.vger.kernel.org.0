Return-Path: <kvm+bounces-6162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A0482C65B
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 21:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E210AB22363
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 20:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BBD168AB;
	Fri, 12 Jan 2024 20:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PXOVenkJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F20E16429;
	Fri, 12 Jan 2024 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqWC7lDW+MWOtwVpPOulbex0dEjL1B/ZCR8RCJ2DUa3LeZfBXeulHbuL88zkp3BgZHPxjsMxRnKBwAXQE2iat5V+5DzxjEFnKkiECnqt8b2mYTOBU9YTFxdjBEpni/nvcrI6Ss3DxpXS+iPoJZoi/zgNVd/I4lHHpkGx6Zg6YFP9qXfwSjalDxVQz/U38wxHZzJprf8Ft6RJPmyVKKbuHETDDGmvihF3q6Gq/JrZ9Oa63bFhG0H3p2pnwXsvkwtKRWJdNikAiQfVfxcKmFmdhoLdjJ8VOdT/7Er9IN8U/HJi7IJEdrijtWiroti/1OCKQne0kfyW55b0IuCSqkrKZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aT8xXminJ7/owQ8pQDLsKq1mG2AQj0XY/TlVViOcFsk=;
 b=guo065ETSihV6LLWD7nvnSj2KbBAUoXoHWd/sSx8MykcXMP21rl9E2J9I4PpHV0bmuRFGDYKU+ek9uECFbIFJlTwDY60GycSaigecOwY793OJuplyslbzW1b/XE70k/mzC/j8X6JVtoU7X3okex16/6nBoh1UZhfmubg3MMTZ07EJkPwhai/zFM7UFIT1bpOKl6D7x7eGEmQcO0JXrPjrKW5R/hzJeT5qdWBOGqMTR84ZefXOgCAfIxgpHAzJ7iV09ofSBc0gd+jlsVKge1BAdBaqWGaJG6qm/tDWZNwHiBoF5jdQtKZ1gZyjuqz7rVFA/bSP4kAIiKFWBg/zQHipQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aT8xXminJ7/owQ8pQDLsKq1mG2AQj0XY/TlVViOcFsk=;
 b=PXOVenkJ9Y5O4ZHNbhj8Bi1omGcrbFaCuE2cDbrZxc4S3RoGvzUO7KymknpSw8zeErnwRifnbxC7Q7LiNEU5cUxxsgr0dEXA7wAJ8YlKkMwB7Jb79Qlm9eb9jjl+iK+WwlaDxcBxOCOwLR/VJZOZp/kKI8JO2+RJLlgiX3ur25Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MN0PR12MB6247.namprd12.prod.outlook.com (2603:10b6:208:3c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.24; Fri, 12 Jan
 2024 20:28:18 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%3]) with mapi id 15.20.7181.018; Fri, 12 Jan 2024
 20:28:18 +0000
Message-ID: <63297d29-bb24-ac5e-0b47-35e22bb1a2f8@amd.com>
Date: Fri, 12 Jan 2024 14:28:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::30) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MN0PR12MB6247:EE_
X-MS-Office365-Filtering-Correlation-Id: 59b3c418-a448-4c8d-ed19-08dc13ad0332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RIdgJmnlNtmdhTgTXJQbGeK7bgjrnHfermZ40xKGjJltN0u69i7Al7En3wJPsNpq//qxzRpmt2b4dDOeDNdygEalohhmMp60o6be0XVcGtHLChJxuPpSf0B57SMkgBbGjizqMAoC+59ommp8Fc0ojLx4cj0JiiqxoGb2J0myh/zOQ2FQ7jL5WRwoAanIrJ/0a0YhlFwGXptSslPRLqJphDsqD0+TYSsGWV9CgvM2Vhytpsqzi/V56qGE/7uCVIIqWmLpzuzo9lb2VKDmKgclfSuxRft1d+l8BsEIRoo898sELO2u1r3xiMGUp1GwyfLx93VYR5y4L8vtQIllOw185G5H8XWN87uKPtGfGv348gmudn2wlG+gupc5UyD6wWck9eO1/GN/KV9UAeZg5tMgEuLU6OhliZa7Gyj1StcdZxfdteYmsCkX+CKegEw+52nfUWPe4mFzazJL2aC7UFYeeTyGc0dOat11TBCya2+3m8VkD++XZmfUpHDdso0nDh2vkIxm3wQJu/VObpxKmGYPCpFGhFEhM4+98P08HNM1l27yLymJYS/eCFaOefpt5bfK1Izgzdp94sAf7BzI6hFLR5MFWSIphb7cpYDuCZf/4BkrGWbASPKnTI8lBAdMdfdjpzfDI6rP6HNe7JPo6mhS6w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(366004)(136003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(31686004)(26005)(41300700001)(66946007)(36756003)(86362001)(31696002)(6506007)(38100700002)(316002)(54906003)(7416002)(6512007)(53546011)(2616005)(8676002)(6666004)(2906002)(110136005)(6486002)(66556008)(66476007)(478600001)(8936002)(7406005)(5660300002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlhFVlpvUWhKR3pNMlVpYUdoMWI4TWd0ZHp6U3gzUTFMYjdSOUFkaU1XQ2M5?=
 =?utf-8?B?cFlrZFQyRWNZeVY1enZXZ2ZmVC8rZjAwWTltT0lRcjByRHNDMmVHQXk1UXNM?=
 =?utf-8?B?enZBYWU0UE1PZjIxWnlRZ1lmNFdWNVcrdkg4Rk5Od1NiZDVkQWxKQmE2UmZm?=
 =?utf-8?B?RTY1KzNzRkFpcmxxNFRNM1l4dEdPdU04M0hBV2hSUkNEb3pUWEZuRitKM1Ro?=
 =?utf-8?B?RXBWbFNhZzZaUGNmbm1BaEV0b0l5VTJiejl4K0NLZHFTQ21iU3dpMzBYVnVu?=
 =?utf-8?B?RmlsMmpqZG56N3lidjBkTTQwSmdjb3prY2NZeEM1Lys5TS82bGhjUjhOYlRX?=
 =?utf-8?B?SlVRTjFtUzF0SWNRY01UU0FQWFErTm5EM04wdDJxVUN4QkFiSDdGTjhDY1hQ?=
 =?utf-8?B?eUVZcy9jdjdpdUF1QzhzU3FQWnE4d3gwbDFFMU9NNkwwSG9ZUldGajNTK2Ns?=
 =?utf-8?B?NXJFai9ielVlM0xPbEVCc2VRUEhHb0QyOHJLcjZTYzZtVDZBZmpvSEZObzds?=
 =?utf-8?B?dkZiaTI4ZXdiYWtlMmR6Qm5CQ1JGaktLZzA0YWNwRmwzZ2FBS3J5Sy9nK2xj?=
 =?utf-8?B?NFU0Z3RTbXZ2eTlWczE0Z3VoWEJSWFZlb3J1YnNidjZ4K1AxVzg2RkJTVW1T?=
 =?utf-8?B?RGRKSURJVFhMRzdLd3hpaEpzSUlYcm83eVljbHkyeE5nMWQ0dlpQL2d1R2Z4?=
 =?utf-8?B?Wm9tNFM1MkdxZnFKbWYwMFBHenVZa1hoeSs2REhPQTFZcStQMGE5cUprQ2h0?=
 =?utf-8?B?VW81MzJjYnJoRnhoY3BZdE5SRFM5Z0x3aWFGWElDUkpxOGVCdi9Qc3ZBaFZv?=
 =?utf-8?B?RWpRK1FZYzJlbFcxc1g3Tk5qblg2WWdUVFIxREdGQjlwYSszNTBMTnFBbUdi?=
 =?utf-8?B?TXR0bExEZ1lUUVJQQXJLYU8xbzBsbllSc3Ntc3VIRTRZYnRkdUJyemVsTDN2?=
 =?utf-8?B?SlRCSHlQYSsvWEFTQXZQYk43d2J1WlVrNmI2b21tS0l3aWFPMnZ4RC8zdE5m?=
 =?utf-8?B?ekNHalhtdXprRHByZXJmd0FWNlVXZU9iZ0RiQkZGRWtHWDJMRHZHUDRHaTAv?=
 =?utf-8?B?aWE2WEdDeGkrYUtIVndublVJY0FWOG9SeFdpT2IxRWJtdHhHeTd5TFAvcEkz?=
 =?utf-8?B?aUFBa1lnNXpwOG9WY0VKQnVwOHRPWHh2clhXdUcraWxCYUwrcEtCdHIycFZ1?=
 =?utf-8?B?L0lKci9OY3ZFczJlSy9uQzlYR0s4ZWVKUk1PK05RanJHaU42eTE3TUNqMmpQ?=
 =?utf-8?B?OHdQbFBCUlZnL08yR2NTQytLczBGbTl0RzNKc3hhMUwzenE1U0E0RTE3R2xY?=
 =?utf-8?B?M3JXK2pqeDBUOWJ4RUVEWmhpMlRkcXltTXFRYUtPeVdLMjN4dStITWFiSlgx?=
 =?utf-8?B?ZzNWT09rVzZKUlFaQlgyeVRGQ0l5aVI4VTQ3d3RlckZrRU43bjcwdWsybkE4?=
 =?utf-8?B?QTN3cWJFbFluVFd3MnVoc1RVblFjUzhGbnR6U0xMZXZtRVZEZGorankvM1Qw?=
 =?utf-8?B?WWh6akF5NFFMMkJJSng0NWZMc01zUW4yL0FqVHlpNnluaitreGFmVHBmTjV2?=
 =?utf-8?B?dnNqVmRWUGZNVlR1M3lueGpndURvZExYektJY1h6dlMwaVlsZUtsdWJFNjIx?=
 =?utf-8?B?V21IeUhjdFlIeVUycnBqQ2xqRTMvTWZVUzJuUFkxRkVBSGlrWVA1eEZnUGhq?=
 =?utf-8?B?UEwrWjEzdG5pZHR1aFlJVU5qUFVITnBYdHpNZ09rZ2J6c0NjUGtIS2ExNk01?=
 =?utf-8?B?NmhNOVJTdUVyV29LSnd2bmlWRlNmcy9QS3VFa2c3L0tVRzBEOC84RFIyKzZi?=
 =?utf-8?B?US9qSDdXNFJiL0ZSekp5Rm1TWEwwTnpiTkFRcXdadVB3NGhtbGpYb1pBWFhW?=
 =?utf-8?B?RXcvdzVNOGhzd3V3aERFQy9IOXp0aG4vM2JsQi9iaS9IR1hpWUI1alRoN0N2?=
 =?utf-8?B?QU5GRUc2aDlEOHF3TFVOY2RVQ0ZlZEZyWHZ1NHpnaUYybVFZOGdBQzRzUXVP?=
 =?utf-8?B?MW5BWW5rSUh6ZlQvaGVxSVNaK3RKOVM0VitXVXpnMW54MzJ1UmE0Q2JjMzV1?=
 =?utf-8?B?Nmo3aGw0bktmbWpLNWpSZDFjVmZ3Q1ByTFFzSEtBeUIvNTVmY1BMVzcyeDN6?=
 =?utf-8?Q?STSbxCB5rmDN+56GMzXm5J7yY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b3c418-a448-4c8d-ed19-08dc13ad0332
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2024 20:28:18.5343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sj8E7GzHnzUVt2GgcQJu2f/x/YXXoM98SBc62Nkn22X/mNSeFAM3PKSttHugKwZ46HddM/V0pap8N6b7Lj1C4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6247



On 1/12/24 14:07, Borislav Petkov wrote:
> On Fri, Jan 12, 2024 at 12:00:01PM -0800, Dave Hansen wrote:
>> On 12/30/23 08:19, Michael Roth wrote:
>>> If the kernel uses a 2MB directmap mapping to write to an address, and
>>> that 2MB range happens to contain a 4KB page that set to private in the
>>> RMP table, that will also lead to a page-fault exception.

I thought there was also a desire to remove the direct map for any pages 
assigned to a guest as private, not just the case that the comment says. 
So updating the comment would probably the best action.

>>
>> I thought we agreed long ago to just demote the whole direct map to 4k
>> on kernels that might need to act as SEV-SNP hosts.  That should be step
>> one and this can be discussed as an optimization later.

Won't this accomplish that without actually demoting a lot of long-live 
kernel related mappings that would never be demoted? I don't think we need 
to demote the whole mapping to 4K.

Thanks,
Tom

> 
> What would be the disadvantage here? Higher TLB pressure when running
> kernel code I guess...
> 

