Return-Path: <kvm+bounces-3659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C403806647
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 05:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BA52B2130E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 04:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3428F10973;
	Wed,  6 Dec 2023 04:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5Rux5oqe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A3618D;
	Tue,  5 Dec 2023 20:37:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUXdciVUVW15MLpejlUvQyLR0G8bSOFRlzHhVZe3DG2fyikqWhvsunzQXNBbqdGFEc/qisZe5oDmwi55DDl9M9GFY/8QjbnGpsd9lSQWcnN3fWDOKYwBdprCTfxF8Qx5GpxQGul06zDTlqY88dC+JhReQnWoTDGKqOPGsuyoleOZ4unIl8FYHyYRTI5plMZqf1Pewy2+S/7R0ASJFuM490Lc+REGPorfmBwzMb5jKa1xXMGTgXN+RRDBBoY0D9bQyEUBVuPATMoXT8R8xETOSz9kB60kCFVrj59aXUmm3TsRrMzEisPS4mxB8+iH1YqGRfbRSwz8TToulFx8cMKEHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5JsrJxlqcx3qFQQ8C1R/jSc4CjoHmd3m65qg7S2nyQ=;
 b=bqDKX9zwDzKUwHO32GGuStEKh4rKVC0dvIdDXFRoCIOjmRx5V10zf2Oey97V7PS8ikWG1DaMkue9N22UqxjZtMWPcLBko8tOdYgQQrNmtc6LglMd076292rD+RcBR0ef0dq06kO8KVUz8BJ3lAs+qx30o7ZM0qx7BALqkURe4PIir0hj5qTVY5zqEErFAPHYl2YTDqImTLHGNBqYpDcKTamz7wU6G0uByeCb/TuC69NZvYgNTeEbjceJRKSqQf1DMWLq2Pul57bFyjqRiT8B5tNBCcfW1cwu0kgDnU/eH+s2wX3YFIVBMjtL+/ZKqTF2wDtwTpIZcyFQ5RHPVgMVrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5JsrJxlqcx3qFQQ8C1R/jSc4CjoHmd3m65qg7S2nyQ=;
 b=5Rux5oqeku+wb8LSQyy2UR6hze75BTQpRZjXyzPj7Iy2YQXpPb7CP0i021oPX8FhLpOTNc/zMKCDgcTCifjcWh5RAVT7cFP64BxaUrxWEpkWoMg4DjHpMhqEvCABjQQw0ud+/+3IHOcAnq0qgCkefdi9tn0SF4qZPF1JW+FeCiA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.34; Wed, 6 Dec 2023 04:37:25 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d320:6e6c:d4c4:7fda]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d320:6e6c:d4c4:7fda%3]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 04:37:25 +0000
Message-ID: <dbffc58e-e720-42fc-8c8d-44cd3f0281e3@amd.com>
Date: Wed, 6 Dec 2023 10:07:14 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v6 12/16] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231128125959.1810039-1-nikunj@amd.com>
 <20231128125959.1810039-13-nikunj@amd.com>
 <CAAH4kHYL9A4+F0cN1VT1EbaHACFjB6Crbsdzp3hwjz+GuK_CSg@mail.gmail.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAAH4kHYL9A4+F0cN1VT1EbaHACFjB6Crbsdzp3hwjz+GuK_CSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: d7fc2f8a-b4ef-4b77-c82b-08dbf6150b44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Gfu3TZFGJhauou/C2IKc8v4iHRLNZsXqYywB35NiZvUc4g+KdKMKemufSfyaXepHQuOPD5Or/SzE5nbCo8hYSyG+QrIhOQFggbe+1elWZPiC1c0uveNvHKvWsXdNw1SEl+oqoyJND708H/dg60hF0rGkHHr3cHNsjxppmYw/cNWV0xXxEnT2mQWpm2iRnTa1JrQ3UrhxQWxQZ0Kp9259nN7E+gsvY0dtZJzH1K1rbG3IzLRKHj24Mnx9EW4pe2YTgIdn0766vnYcQl8DvC1sjE2/XJV2YA0vd7OnPhgdQxSf6iJtYYVrPyqq1QdCFYh9JH26wagIPe5umYLsnDM9Ne9z7GWZeABO12HAGv/EKkpB1L6AVQ3IGFCzO0mPKembLx298QuVYSoIn49IwMmB/Xyva7Vo0/wHh1c1pDqIpEXqC9z/EesR89M9HdnCDrMZMEgyusI3QHlvbzYNfCikhUeY1WtQddiMtkqyC+QWeoVNEPcUiqdalb8mbWUzOip+7/FlEKxvYWlTVnFMCna0aJrToMieZipWJaJUcw0iTjf7oVdQGgYLTm+v+wD7UvoSkBkCijkeXVf+8CZSlaIyjJWDDLDmi1Fc6/mp7NVjW4MA07SiHJ2NQUJs6M60YRg8l3Oz/v6EyEd4bupxcLH/ZlvIthw8E7o9Oa2SO1IoOHw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(376002)(366004)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(38100700002)(3450700001)(36756003)(7416002)(5660300002)(31696002)(41300700001)(2906002)(966005)(6486002)(26005)(2616005)(53546011)(6506007)(478600001)(6512007)(8936002)(66946007)(8676002)(4326008)(66556008)(66476007)(6916009)(316002)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckFWMVNYMmZqUjd6dXp2akpOeFpDVVVxLzJrV2UrL2wwUmFoQkVLdkx0aFpR?=
 =?utf-8?B?aE9scE5QRElxUjAwVTJpRTl5RkMxdzhaZjNXWWNIdEJ0VjJJZ1lydkcvRGYz?=
 =?utf-8?B?Q0VacDU1bVI2S05PeFlGMkxqb1lGUkRLaVhlaWxIUjhRaU9za2tiSlBybEF0?=
 =?utf-8?B?VjFMQnRQdHMzV0d0K0hEZUpKWWZybjZ6MFEzcmxBdDlsR2JaWnFtdTllQjc5?=
 =?utf-8?B?ZndMdGUwODhjMjFVZ2xjWjhOeE1tQWJWQ1BvNklqcC82YWczaC90aDNCaGRt?=
 =?utf-8?B?NlNKamFmZ0RNNTNUS3RoTnJ1T3kweFBwOTJ1SnlqVzg1dFNCcDZ3OThQRWxK?=
 =?utf-8?B?MS9YS090NnViSnk3ZUJyTkNKd1lkTG5KYjFJR0VWdEZmMzZWTTRnWmZPU1N0?=
 =?utf-8?B?T01QMml0dGRvOW5LNFFUb1gwNWpPWHZqZWtONkV6ZzFPL1o2WlA1TlhWRkg5?=
 =?utf-8?B?YkN3TzlSQ2t0VE9pU09maUpzajlRWUlTekdSaWdtRmNESEtuaUxTNXcxcmlx?=
 =?utf-8?B?L0VQQWJaZ2dndHdnVWxUVSt2SzRaQlJHYURPL3RtQ0xwMDlYaXBucmlhSzFF?=
 =?utf-8?B?ZnlTMmhLRUgvK1BzVWxpL0Y0S2JOVGg5SHFrVWJ3eTQwYlk1UGZua2NzVE45?=
 =?utf-8?B?eCt5bmZGRWlKdWdLN1p4NVNsKzBnYXpUNnZVcmZTK3E0RVhVSXl6M0hhbkpS?=
 =?utf-8?B?WUZjSXd2R1kyMExrb1dMVDRzVTJxUk9ValBHQ3daTk1sQjFIdEgybE1uWS9z?=
 =?utf-8?B?QWVqb2dZQlVKRlNlY3ZwTXlNL2JNcWJMWG1odGxwK2VYcnJqQjlNUzFsdWxC?=
 =?utf-8?B?ekRHZmFQc0lOOXBxTExSQWlFdTNqVW9MTFVNejQ1NUtOcGxXMnUyNmh5WTVm?=
 =?utf-8?B?NlJyanV4cURZbHJMS2RmTkhWdjh6MHBKc2JyM3dxcGFaeHI1azNyRGpnSUxh?=
 =?utf-8?B?TG5WbW5hZFp3UFU0N2dldjk3ZzFwaUV6anEwY21PMmlWWDloeTRPQ0UvYVhH?=
 =?utf-8?B?b2FYMjRCK0hmMlovUXUweVpWSGU5R1NCb2lZK3lYcmI4QkFZd3piTmpjMnd3?=
 =?utf-8?B?UGowSndiakd3cnRMOGtRcXpwTGxIeDFQVzVlME9uai8yVGZYQzlpdGhWRTVr?=
 =?utf-8?B?aEpFTzVEc3c0NGVGSHNnMzVQelZobzNGczVKd2pkclVUYXNlYjBjSGg3bEtD?=
 =?utf-8?B?UUt4QnV3UE4wVWV0bTRzU2dFUjdSNTY2NEt4eG9SVjBkWFdzVHVkZzJpMlN0?=
 =?utf-8?B?d3krZ0Z6UmFDQlUyL05yRFNaZjQ1bCtzNGxnTU9DemRoZW9WeU1RekJhM1dL?=
 =?utf-8?B?M0pWNkRBbzdwaGRXNnFibTFLR2xVaE5HTTNvMWo1R2M1YlMwVkw1WVZKMnpD?=
 =?utf-8?B?bFB4bkRoc2xLNXZSVmVacEN3MDJkcWxNNlhmWXVnSEJzbWh6NWxkRDBoOHcv?=
 =?utf-8?B?akEraUF1OEdOdWJhc0JZWlkwUmY3VTBDMGVzOW5GNXlIK1dZMHRjNEJmb3pi?=
 =?utf-8?B?TnkxMzA4YmJqSVFBazc1YmhyWFEzYXdoTS9iMmpHSHVJTnlhZXdYbUdEMzAr?=
 =?utf-8?B?REdMVWgwYm9VeUpCWTV0WEFuVGsrVEk2NmFqNk1ETTNzZVYrU0prT2F5Vktw?=
 =?utf-8?B?U1d1ZlUyTm5qaEdOQnFqeXdINzMwME1TaEMvc05BWW8ybVhUalh0b2ZLZTQx?=
 =?utf-8?B?bi9kVUZhN0U3NEo2Q2hJU0R1a1JhYjQzL3JBbVJrZ3BkZE5wVWZyYlZrTTBN?=
 =?utf-8?B?K3pHLzlZRTJTbGhZSDhQKzhnQm5oK25QMUxtZFNIa0VFb1Z5NUM3bEMvdDdM?=
 =?utf-8?B?aTU5aVY1anh2VHFTUjFHVHkza2w1UzM5RWh6S1FXM2ZNMGc0TDdkcEhXNXBX?=
 =?utf-8?B?SXJSTEMrc2RZNFBXR0d6c2wvdFcrQ2dFQ1NDVkthWTE2azVHTk9oRG5KM1dl?=
 =?utf-8?B?OWtKZGFLSFhZbUlCSHFQRThWKzRKVUFFemZuNWdOeitsdm9UUFJvYnU1OE1G?=
 =?utf-8?B?M21hNEdDT01wUkhNb0pIUURzR0ZHZHZLRW10QlRxbmVKTXFoVnEvcEpnR1Fr?=
 =?utf-8?B?YlVtSHZUWlczNnVkTCtybHR4VERKN0JkVzhJQllrWWEvREhuVXNWVklFR0dZ?=
 =?utf-8?Q?eQdkS8a3PeDn0mqKllCehB40c?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fc2f8a-b4ef-4b77-c82b-08dbf6150b44
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 04:37:25.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C9Y8HkV0S2qtFDAxpwJtjCZGIoX9alDKgz4JPXGJyGN9GVAaRRrxvzYEc/rZW7zQ5RwgRm8K+G6yg0Yizo91Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536

On 12/5/2023 10:46 PM, Dionna Amalie Glaze wrote:
> On Tue, Nov 28, 2023 at 5:02 AM Nikunj A Dadhania <nikunj@amd.com> wrote:
>>
>> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
>> is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
>> instructions are being intercepted. If this should occur and Secure
>> TSC is enabled, terminate guest execution.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kernel/sev-shared.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index ccb0915e84e1..6d9ef5897421 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -991,6 +991,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
>>         bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
>>         enum es_result ret;
>>
>> +       /*
>> +        * RDTSC and RDTSCP should not be intercepted when Secure TSC is
>> +        * enabled. Terminate the SNP guest when the interception is enabled.
>> +        * This file is included from kernel/sev.c and boot/compressed/sev.c,
>> +        * use sev_status here as cc_platform_has() is not available when
>> +        * compiling boot/compressed/sev.c.
>> +        */
>> +       if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
>> +               return ES_VMM_ERROR;
> 
> Is this not a cc_platform_has situation? I don't recall how the
> conversation shook out for TDX's forcing X86_FEATURE_TSC_RELIABLE
> versus having a cc_attr_secure_tsc

For SNP, SecureTSC is an opt-in feature. AFAIU, for TDX the feature is 
turned on by default. So SNP guests need to check if the VMM has enabled 
the feature before moving forward with SecureTSC initializations.

The idea was to have some generic name instead of AMD specific SecureTSC
(cc_attr_secure_tsc), and I had sought comments from Kirill [1]. After 
that discussion I have added a synthetic flag for Secure TSC[2].

Regards
Nikunj

1. https://lore.kernel.org/lkml/55de810b-66f9-49e3-8459-b7cac1532a0c@amd.com/
2. https://lore.kernel.org/lkml/20231128125959.1810039-10-nikunj@amd.com/


