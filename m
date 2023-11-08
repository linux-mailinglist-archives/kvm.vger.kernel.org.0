Return-Path: <kvm+bounces-1270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B3A47E5EDC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99A5CB20F01
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7CA37169;
	Wed,  8 Nov 2023 19:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IhNeWXwJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8456B3715B;
	Wed,  8 Nov 2023 19:53:17 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADB72118;
	Wed,  8 Nov 2023 11:53:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2U9UxGV9aUtoCFiNJHHZZ7gY0eVzQQIE+ZFZiiIM/81RHixjh5lCV5/yQjHL3pZi4GjzVy5x82D/1h7SqxjT0724fL5GEIRdJUmx8S7ug62VQp8rbmEmI2xV+w7eqY4WThWSj5u0qkcjm1dPoWeTwUXx4eNhch6XfOVubeZ0PoQsju7zyBXkTtK7G6JpqXEanmy6abxby/8QjFRc1iX+Oo1Ehi2QI4OGAqf2bN3JB7ri/NlTUDF1/bKMChqUd0cxRpReTFUGq2KOu0hC5NbFbzjMkFSQX+YQXp8UlFy65gVHdrfqsV7HSbXG7xvitfwkAzXrZD0Ud2X9fxNOgezzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nQr4RBqGiB8dHXvZDmJCmsInztRncX4F2Cutfuhvgs=;
 b=Z1RtMrp6o2Rfdc79N1oklb4/72p83u/lUBSyhve7s3LS6kg11V2XG2cvaOxA4Y10saVyXmdep+6yOYtE0cpOe4pri33TAjBGT7ji5s8BXFUVR3OlSEMSlbVXvpL57KnYanwI/HiWoYJal49w13nIW5HzER9YGfjYYhEC8Xgdcmk2NV74ebqUwUneAcaUaSeVcsIW4UKi3sokHhuSwIb76SII1zatgeh1PNiqTeZ/emrglnW10zb/XJ7/G2BpgWr2wUwLtEaRjv7+sL9hn/WwzoOVpw/Api/sMx8rvU6m8q+RxwbUuoBf1kexQhYyDnlD7h1P8TyPUZYjdhUAP1ZfUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nQr4RBqGiB8dHXvZDmJCmsInztRncX4F2Cutfuhvgs=;
 b=IhNeWXwJ+9T30wzP5cgcPTnskt90Yr+a5yMtWQ9eZw8R5DSBmqEYc85Vq++SMU+1qcYw0IFiecAImI5ppVQTOM9PObsd1vynIQW/ciongIb4vq31tp9UdOwp7UIqVLw5K2/8JwkNlsLRfDP/mbaYjC7ryp3vjmuIgm0YlY3G/60=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Wed, 8 Nov
 2023 19:53:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%6]) with mapi id 15.20.6954.028; Wed, 8 Nov 2023
 19:53:14 +0000
Message-ID: <f6e36ffd-86e4-49cf-40d7-a289b444fe3e@amd.com>
Date: Wed, 8 Nov 2023 13:53:10 -0600
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
 <250f5513-91c0-d0b5-cb59-439e26ba16dc@amd.com>
 <20231107212740.GFZUqrzK7yzy41dRKp@fat_crate.local>
 <20231107220852.GGZUq1dHJ2q9LYV2oG@fat_crate.local>
 <4b68fd05-5d21-0472-42c3-6cf6f1f9f967@amd.com>
 <20231108061413.GAZUsnNVcmYZNMw2Kr@fat_crate.local>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231108061413.GAZUsnNVcmYZNMw2Kr@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0154.namprd02.prod.outlook.com
 (2603:10b6:5:332::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BN9PR12MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ee4af0-e1d3-4abd-5618-08dbe0945854
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yV7mrddSSr78bOc34/uCeRCQE7PoIXSgXOZYBoWW0hvz4v7HsbORORdFRgJ31Nof4hY2QM/fR+iHVqB+9fVPB+jOIGn9yoHdSgTyhX7bVYPcgmwXy5PCch521IosrsDKewr0CrhKbkApkcUc0W5j2geFn39jxiov1fwl/1naS3ELp27bSJBaF1JJRWm92aaiTAELmgqgkG/KB5tWwBbb31UvQYKNNH+S5hZ9Zg6sbeiUrGna47TsrpOuXvPgKNOfB9RURR8HYrwWQi7qVYqPO4lFq66C3dnNgb2m8LGYNx8pSluwCpANH4RYwuHE1Rpv1QhXpzG9w8KLwCq2tdT3asItiF+9o1h1tOp1ZlkiDG8nBcGmk7rk2aRR9KdGEHaOR1/2RhfqiGSd5h7Qat64jKlr0ZEEGwlX5pFw5zhNEJrIcOO9ucCexPU9HRDKA9gRgcwWfTvdazv/RwsGX03/D4yAREVDHZ3fxWwSEgA9H4lj4bnV+xXEdGhNtyYDRkXHsHI4W7FLpqd85VDb6DEb5dvvP9PprmCB5hjLKP7aoZvqlI7mAmGy7UZPEir4bcsUDHjSGp4GREgZi8smEwQJc+9puqO+mYsnILHxN5pXVMFBhdAbc0TgzI8c5xghBk+m7MLbRyOJzMLI06ij+8Pegw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(366004)(396003)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(2906002)(7406005)(7416002)(31686004)(41300700001)(8676002)(8936002)(4326008)(5660300002)(66556008)(6916009)(316002)(54906003)(66476007)(66946007)(31696002)(6486002)(26005)(478600001)(6512007)(53546011)(36756003)(2616005)(6506007)(83380400001)(86362001)(6666004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjlhR1kybWFMbE5TSVhiMk81OVhqRVVCUzQxcFpUVkl1TGJVSE15eFo3TFBW?=
 =?utf-8?B?YmpzeGpsZ0JtdWg1aUczZ25NRmgrcnpNK2tqaUFYcVM0ZGNobHBBU0lEc3kw?=
 =?utf-8?B?OFJmSWw3dFoyN0pxRE5Mc3RDeTRVL3JBREhEcWxmSmIyMnpydWo3K1pTWlg1?=
 =?utf-8?B?Wlh0eG1wendkRHFJM2VzVnpYUTZqK0IzbUY4QWdyKzJuTnpldCt0Y3p2MWY4?=
 =?utf-8?B?bjNLR3UvMDlZelVzWVZ3bGMybnlJRC9pVmdPNnQ0d3hudnV4cWNuS09zd242?=
 =?utf-8?B?OG0vZlZDM3cyK2lBK0xaaUJzaXBYR0oxdVAydjI0YW1LWHRrbEwzVHA0SVN2?=
 =?utf-8?B?WFJpVmQ0eGhWdDB6L3Z1YVA2WjQ0Tjd2bmtGMWNORCtlQjhvZmdhbGNRcVNN?=
 =?utf-8?B?RFZMdVByQkRxUjFWZFF6WFNOa05WY2dsV0w0V2JlSzZIamwzWU5MaFFDWjdO?=
 =?utf-8?B?NUR3K0FZdkhSTzdiK0EyNHNJUVFJTG9pMmY1aUJxR3NBL21aZm4rZ21sMnF6?=
 =?utf-8?B?dVd2VVEybVFiUkw2eXRQUkRqRjlScDczQTBiY1kxWktTd0ZWUXFIQ0hRaCsy?=
 =?utf-8?B?OXJHQWk2anB4dTRKRXVkY1o5Z05oOU9oU2FRUWdjR3l6NEZNSk1LRTJOcDFJ?=
 =?utf-8?B?Tm9zNjJEeGI4U0J5RlZUTE91RjdoL2xlc3RIOXhGaVJSQUhmMCtWVm9hcE1y?=
 =?utf-8?B?K2dNa25xYUZ1VWdYc01uS2VKTXUwaDM3b21aTnh6MFhQNERPbWM3MGtncUhj?=
 =?utf-8?B?dGZvUjJaOWJhdklOWnhJUlU4TGZnVS9SR2ppRzg0ZU5jZldUWkEySDV0QU1G?=
 =?utf-8?B?ZGRxaFVqSFRpT3I2NVVFNzdJa0ZWZzJsUG9BMzZhNnZtTnVwcXBOUUZ2YitO?=
 =?utf-8?B?V1dFenl0TTJvbkhEd2ZUenVZN1BWeFdGbTZ0S081MWw1UGIxRG5Ic2RqWm5O?=
 =?utf-8?B?WlNLVTdOa05LS3Mzc2VlWHdEOEN6ck5KY1NQb3FJL1VQQzFkS0pwdG1ydTYw?=
 =?utf-8?B?MzEveWhDeFcxWjVnb2dBbExGNkZVRTJwVnZTbjZ0TGNES1NzN0ZzVXZ5ajJI?=
 =?utf-8?B?YmtVSEtlOEZTRDlUNE5TVCt0UXVLQVVPbGVudzVWQjZVeStxSXpiRkNHQWZH?=
 =?utf-8?B?NDFRUmZRSHlkTllJa2dhelVIcGRqVzM0djZnNjhuTUEwZXhqSWJzU2hxUVdR?=
 =?utf-8?B?YUdxRmJKOVhpMWtRcjFhcHVoQ2lrbDRnZzJmTXZCa0JLdk5mbWNRc0N5Z210?=
 =?utf-8?B?V2tQV0szVE5wSjZiZzl5d2ZTY1BoNVdPZzNYQkZyWGwrWHFaQkVKRGlEL0oz?=
 =?utf-8?B?Z0k1YS9tRjB6RUtGb3FaK2h5NWlnTmJDNWJ4TVZaTkx4Smh3bVN2bm1MMEdN?=
 =?utf-8?B?b1NqL1poZi9PV2dXVGxDemMwQUc4OG9oYTI3MVQ2RWNPc0wrZjVnekNXclRX?=
 =?utf-8?B?UWZnTmcyaXFsRm16QUpLcld1eDZ0UzIzU1VSenZvTjlWNTNpeTJhZmd3NWNW?=
 =?utf-8?B?anRhcGtMcXdORk95ZGhkeWF0QXh0UkpZWkJod2NUWTU4NkQvbDFEd2p2NVlF?=
 =?utf-8?B?WEQ1cmk5elIyS1RyK3hwd1R4QTRXbkQ5YThyR2FJaE1lQW1UUFZQNDlyTkxN?=
 =?utf-8?B?NHZOV2VscEVLWFJsUGR4b0ZsQ3pnakZQa202QVpueEo2clQ1Q1V5RjlnMzhn?=
 =?utf-8?B?eDQ5NmFTWGsxckthLzgyRnpoYXl4SSs4Y2dtTlcraTF4WDczTGhUajJ5RTg5?=
 =?utf-8?B?RnlmK29TWlV5SVNhZm9pMUEwSkZCTWdZbFh5aTlUZm84dDVzRjhJQUZPMjlw?=
 =?utf-8?B?U1B4WVF5eGtQdC9PQlFyUEdRN1lQcEJtS2huNHNQY2FVN1JJR1ZvMHVVMWhQ?=
 =?utf-8?B?TVNtSFRQc3FGWVBBZXBuOFN4dWJabDNpeFZaL0QyZjhCTXVBVmpPdXJPQVYw?=
 =?utf-8?B?V055bUh1bGkwVm95MWE2eFo5VDljZ041elY2SHF0cjY0dUd5V3A5N21GZm5Z?=
 =?utf-8?B?WkdFRzVsQ0FpZVpBeThhZ1JwR0hVTmozMHBYN2NmUFg5UnBhaFV0cWFjTGMv?=
 =?utf-8?B?alNOQkY2c2VNU0JXVHkwbUZ1RWxvNy9zOWV5VGJJQ3hIK05xSzV6OURWMjhQ?=
 =?utf-8?Q?Sn+WU3OBgwV8PFlrEelwKuqYS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ee4af0-e1d3-4abd-5618-08dbe0945854
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 19:53:14.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KV4TOhwV6NSHLIqNZxXni+ELcQf7yd7uonFgvg/XCW52KGFJrOQZcjRWhPrLkjFRODzM20eyp7/DzRvICH+W9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5115

On 11/8/2023 12:14 AM, Borislav Petkov wrote:
> On Tue, Nov 07, 2023 at 04:33:41PM -0600, Kalra, Ashish wrote:
>> We will still need some method to tell the IOMMU driver if SNP
>> support/feature is disabled by this function, for example, when CPU family
>> and model is not supported by SNP and we jump to no_snp label.
> 
> See below.
> 
>> The reliable way for this to work is to ensure snp_rmptable_init() is called
>> before IOMMU initialization and then IOMMU initialization depends on SNP
>> feature flag setup by snp_rmptable_init() to enable SNP support on IOMMU or
>> not.
> 
> Yes, this whole SNP initialization needs to be reworked and split this
> way:
> 
> - early detection work which needs to be done once goes to
>    bsp_init_amd(): that's basically your early_detect_mem_encrypt() stuff
>    which needs to happen exactly only once and early.
> 
> - Any work like:
> 
> 	 c->x86_phys_bits -= (cpuid_ebx(0x8000001f) >> 6) & 0x3f;
> 
>    and the like which needs to happen on each AP, gets put in a function
>    which gets called by init_amd().
> 
> By the time IOMMU gets to init, you already know whether it should
> enable SNP and check X86_FEATURE_SEV_SNP.
> 
> Finally, you call __snp_rmptable_init() which does the *per-CPU* init
> work which is still pending. >
> Ok?	

Yes, will need to rework the SNP initialization stuff, the important 
point is that we want to do snp_rmptable_init() stuff before IOMMU 
initialization as for things like RMP table not correctly setup, etc., 
we don't want IOMMU initialization to enable SNP on the IOMMUs.

Thanks,
Ashish


