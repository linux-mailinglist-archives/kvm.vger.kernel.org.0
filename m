Return-Path: <kvm+bounces-393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 862DD7DF509
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 15:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E40A1F2278D
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 14:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD86E1BDEB;
	Thu,  2 Nov 2023 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5pxqjCQd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44381BDD1
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 14:29:53 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2A210F5;
	Thu,  2 Nov 2023 07:29:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KN3tDAVrG8IfncLOSO5oRHfdTX17YMoxJfag1h1LXVTaTXRb5h20kzF2T9AVDI5pJ8bv5uPlIZtT6gQb+IDJiinLSTYArbWOZNZzgnzPQOCaA+HV0sPfROTv/Bmp/sviLyDRHq3eihkq6FV/dW5nlB4neNxs+xypaBE45V7Yc5vJWL59QmmJ4X+NRYZ7r1I36MJldXrcomMrHWlq+yjv5DiUmITZnG4RK8ELPiTj9RyzBCfzYBpTPjK1AzYCsM958GKDUwjKdg+Dul+/d38eBy7j45DTel646skxrCvyT9EX5S5KX6906Aj53vfSOTuJYA+eIjYEXp6Wz2s01HcE6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXc9McQIhEfXK0Hww43B0fzTvs5x3MsGCGcmbuXFtXU=;
 b=lSd34cRpdY1CCMidaJVCKc4pyrQ7dtEP6fKi11C5FPJm9lS1nQq4EAC211Qr8gJwgfcqBQ/pPkD2ERdsK1PElbykeljjCAZtM/KnvLvJZfy9CAcvApjO3pLtZn1KPWVm3rFvCb3TDj1J+6wbxU78GhJMDfJlUBSSQlSUd2/Q/kyttNz6uQzsDpqXToly+uW61j5VdaMfGb0fuFIAMpt5btROBEpjeWIvJtgKJeYfB/zwg4BkwHkI+IxkaUY2wj1jt7HRLOgqCOB7wB0fvhVvI3DedkT/EtdvcO2j/pG9kfSamG5LWGyLebKnjnedmx7t8ULIuLzNOGik+M7RvVKu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXc9McQIhEfXK0Hww43B0fzTvs5x3MsGCGcmbuXFtXU=;
 b=5pxqjCQdDqSla0LMQSEe/IirW5sGo97H0UqAQHfLoKlJTUAuHA6EFeDy3cPmhVJvqI/VtH6Be3qvNjvBUbDYuMVaCLPfchGbB40czJONo7Bph4AeMAwnSZIItUamsOpbT0qmmzXvhw96lt3Q4+QaxmMObvu2lT3ffmoazIiUMiw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SN7PR12MB6840.namprd12.prod.outlook.com (2603:10b6:806:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Thu, 2 Nov
 2023 14:29:25 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.030; Thu, 2 Nov 2023
 14:29:25 +0000
Message-ID: <0c4ea410-4213-4ab6-9151-da312a50aacf@amd.com>
Date: Thu, 2 Nov 2023 09:29:22 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/14] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: nikunj@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org,
 kvm@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-10-nikunj@amd.com>
 <b5e71977-abf6-aa27-3a7b-37230b014724@amd.com>
 <60e5b46c-7e4b-44bb-a76f-a4b30b154d4a@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 1NhFSLKvfA==
In-Reply-To: <60e5b46c-7e4b-44bb-a76f-a4b30b154d4a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:8:2f::19) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SN7PR12MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: e2332115-ec17-43bf-0b5d-08dbdbb01d36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VEpDKD0tCWLPmnrqLeIJSSD+XUCIILZppl/MP7xjrNcNMmeOtNKARLpzOCGQTm2zTN6MTxzkchq0Edg/yThJgOw+A2ln7OVMbvGS6sqDC9tlm0N/UaP5lgNH9FwLHTIPGGMax7MHuwCJEdD6pWLfQcMdKcciihjg7VH+6z+bDnYb7Lej+rd4n08iGXFi67hWaPXcgZqvUSPufwpXzYf1smvEoKx7JI48cduE2xtqaMTpD0YoatBz6CH+OsVJk5dwsfmspLBmD38rpYt7m3q0kE5p1Rc+pUWqpGbVbLh9Wu8CyIiGpoZWH6tY21+1ETHUY+yWGMPN+L9kIB0vCwRFBPG1zD0b9E5teFqKSizDE/YvDGL90k5TJsdYpCbYpxarenEOBycpGe0x+LOPO3auLAzAXzyDVt2uF/6QAi1U7spr6gLPl5oVMXmDEJQr50y9xKagWDYVA9Kefo1nkUUgcvaQm9y0IClQ07g1rfKV/e6vlEstVSHfn+WMPquMpsclO5hQocBlMT6qydDrX4BWgljVmJtjR6+p8PBIsaZGFbhsisPTI/0gEXX82Bmup+X5QOi95CaDe3aIRMnuCmyP3VIT55Ii+4AA39XFYV6CP3ejIJk297abewWRS33PwBmmcAZomMCwaO/WiSkYPoR+2w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(26005)(6512007)(53546011)(6666004)(2616005)(6506007)(478600001)(6486002)(66946007)(5660300002)(41300700001)(8936002)(66476007)(6916009)(8676002)(66556008)(316002)(36756003)(38100700002)(31696002)(4326008)(83380400001)(86362001)(2906002)(7416002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjFOcTgwUHczT1JPYm1NK1dsU3I0RTlVaEpnaGFSNFNleThxTDBqbkZPQy96?=
 =?utf-8?B?SDFVNnV0dGlkUjZUTUlqRGRwZlhmSnNvOE9RSVBPcUVLSU9hL3lzNXBtckZC?=
 =?utf-8?B?QzBPOHRLdVZKOXF0aGxvcEVQdzJHR29iTDJvbittWWRGdmhqeDdzUG42L2c0?=
 =?utf-8?B?WlRhbjU4dGlOZXY1c3hmS3NLNGE0T0ZvYlArR0syRnF1aFM5NnpDdi84Smd0?=
 =?utf-8?B?QStaRS9EeU1jS2R4N3Jnbm1aM3pWSlBRUVlBMWZDbXUrTUVTY0RWRmR1K09Y?=
 =?utf-8?B?VnJjc1J4OENUL0szN2xvTHgyUzJkRzZZaVpmQWVPT3l1czNrS0xkMlVnQjJ4?=
 =?utf-8?B?Uk85QVJmNmdRKzdSb3dqbklVbmFQYUFNNDRPa1RaWHNFN0FrLzlGMUdBU1Yv?=
 =?utf-8?B?S2I2K0VnSXlvVHZLVEtYdXRFRmhSWHlPSWlvMGptVzRiWWZyVC80eWxHZTdu?=
 =?utf-8?B?dXlXZnUxMzBxSE5aZlhIakc3N1R6dWhCaTRiUGlpNi95cnpReFV5eVRwV3Ew?=
 =?utf-8?B?MWE4dDJkdlI2WmxkZ3NwakJuV01EL0R6VTF3MnlORTU5NXJLbEJHdHJFalFP?=
 =?utf-8?B?T3RmVXFSWEZJeXBqNC9JM2FWY2VDM3FFd3R6c3F2czZET1B3VEFXSFFUUDgr?=
 =?utf-8?B?dkVxd0FNRFREYmtFK1JZcGV5aGZ3bGkvbjFQeWx2VXp4a0EzaWhmWTQ5VTg2?=
 =?utf-8?B?L2hQVEF6eVpzZUl3T25MMWdKWXd0bytLSjJ3MUdXdVc2Q3VBRWVLMGlaaEtU?=
 =?utf-8?B?WEFYeStrS2xmUHVVTlFHK05zRlNqLzFZQWZMT0hhaUNORmRvcEtpVGZwQTlK?=
 =?utf-8?B?YUJKUHJSYXRQbUVUR2krSUZRb0JBNlEvaGxDNHQxUmtRd1EyRVJkOTlEakpB?=
 =?utf-8?B?WEVYK2xuTzRkQ2ppdWN6cDBBVUV3WW9OS0dNUFdQTXIzM2RjcUdCM3Q3NE9u?=
 =?utf-8?B?OWZRdXdJWnJXak5zUkh6ekU3L2NYeXZVTkp5M3lMUEZBclJPNXJXd1ZaSnpl?=
 =?utf-8?B?eEVDb1hXeXZzRkg5MW9peXJJSE1FWEhXL1N5emg1UXlpYmc5aDBKZE1SRTNU?=
 =?utf-8?B?STVsaHpvU1Z3VjFXUVJqUnlSV1QyU05hSHA5bTk1VkFiWmhWUjc4UnM0bWxT?=
 =?utf-8?B?NVorZ0dmYlFrTUxBaVMwbHdsSlQ1dmh4aFhtaDQvc2NOOWZLSjh2R291NG15?=
 =?utf-8?B?N1VUbmwwSVhONmdjZTBFZjVNVHM3aGlHcTJHTHM2Vk8zYVF1bTZ0aDlQVE55?=
 =?utf-8?B?R2VreHdWZTRVTTRjOFc5N0RTUGNLTldGbmVQOGVXeXgwUlJsd2ZWaWdRMEkv?=
 =?utf-8?B?T1pTUUpoY0FjZ1dkaXFFUWVzUWRDcmhFUzlxRkFNdzVpWWpIU1lsRWUyTWVy?=
 =?utf-8?B?bEg2Sm8zK0NzMmlNclFSMGVVOUp4dklXRnNRS2xGWGRjaFNFWGNnSWcraGd0?=
 =?utf-8?B?VUJRRzVYcThncERjRk5FQTZNdGpYUEZmYmNUL2hpWHBiWTZDMjJrZkhOUGdx?=
 =?utf-8?B?bktXNEJ0OWJrTGtFaWdISk1ZUUlzZTRSODdTNkR1cmQ3R3pmY2tLV2ZWNy8w?=
 =?utf-8?B?WlhNVENhK2wrTURocHlBV0RIdjVocHovZGFWc0VNUXdiM0ExVHlwWUxRNHZ3?=
 =?utf-8?B?YzAxK29LdkYzaFhzcmYyTnpMaFVOUnRDYXVGcFgzclgwR0RGQUNEcjhZNUpH?=
 =?utf-8?B?eHEvb3hWVjZpeTM3TmVtWGh5NE1yTi9CNG5IYnYzUXp0NE9pWHFza3J0ay95?=
 =?utf-8?B?dWNlL250cDQvbWZRQnJmdTAyeGpjWVpUeXdyYTVmbnpKaUowNkM5SCtOejZH?=
 =?utf-8?B?a0c4M3hCeCtNenQyMmRhQTgzQzJrZHF3WGpGb3lJTTVKczdTNTU5MVpQeW9r?=
 =?utf-8?B?dFdYZ0pBY3Z0WVYxWVV3bDZCdnp1YjFqT250anBCdFJJcUw2VTF0S296NHdD?=
 =?utf-8?B?OTJpbWpxRTFYTTE4MDk4Vitwekl4bmxqSEhnK3ZwdkhJZU5DUGY3VzBhUXNx?=
 =?utf-8?B?aFdDTnAwZFY5TjZKNlZGY2N3VTRCVm4rbTBoWEI3ZVRFMFpBczFnNHI5MlI0?=
 =?utf-8?B?VU5KYWlldG9GcnRURUx3VFVzR0VqVlhSVW1WNk5QeDBEZTFCajkyY2JVUVUx?=
 =?utf-8?Q?AnF6GOA5Rb2Pk6IZLfIXJPrBr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2332115-ec17-43bf-0b5d-08dbdbb01d36
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 14:29:25.5294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n0KCoida6k2QBUyqr/I9nDMcT2KKrvplLvt0Pa9g8bI9YO2KAB+t6/LXosuCQWeetK/HlR+kOZwXwIGB9WU7OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6840

On 11/2/23 00:36, Nikunj A. Dadhania wrote:
> On 10/31/2023 1:56 AM, Tom Lendacky wrote:
>> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>>> Add support for Secure TSC in SNP enabled guests. Secure TSC allows
>>> guest to securely use RDTSC/RDTSCP instructions as the parameters
>>> being used cannot be changed by hypervisor once the guest is launched.
>>>
>>> During the boot-up of the secondary cpus, SecureTSC enabled guests
>>> need to query TSC info from AMD Security Processor. This communication
>>> channel is encrypted between the AMD Security Processor and the guest,
>>> the hypervisor is just the conduit to deliver the guest messages to
>>> the AMD Security Processor. Each message is protected with an
>>> AEAD (AES-256 GCM). Use minimal AES GCM library to encrypt/decrypt SNP
>>> Guest messages to communicate with the PSP.
>>
>> Add to this commit message that you're using the enc_init hook to perform some Secure TSC initialization and why you have to do that.
> 
> Sure, will add.
>   
>>>
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> ---
>>>    arch/x86/coco/core.c             |  3 ++
>>>    arch/x86/include/asm/sev-guest.h | 18 +++++++
>>>    arch/x86/include/asm/sev.h       |  2 +
>>>    arch/x86/include/asm/svm.h       |  6 ++-
>>>    arch/x86/kernel/sev.c            | 82 ++++++++++++++++++++++++++++++++
>>>    arch/x86/mm/mem_encrypt_amd.c    |  6 +++
>>>    include/linux/cc_platform.h      |  8 ++++
>>>    7 files changed, 123 insertions(+), 2 deletions(-)
>>>

>>> +void __init snp_secure_tsc_prepare(void)
>>> +{
>>> +    if (!cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>>> +        return;
>>> +
>>> +    if (snp_get_tsc_info())
>>> +        sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
>>
>> How about using SEV_TERM_SET_LINUX and a new GHCB_TERM_SECURE_TSC_INFO.
> 
> Yes, we can do that, I remember you had said this will required GHCB spec change and then thought of sticking with the current return code.

No spec change needed. The base SNP support is already using it, so not an 
issue to add a new error code.

Thanks,
Tom


