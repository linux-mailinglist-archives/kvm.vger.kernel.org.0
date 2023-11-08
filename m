Return-Path: <kvm+bounces-1210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7D9A7E59E8
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BA3B281592
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 15:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9781330348;
	Wed,  8 Nov 2023 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s3A93e6H"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C08430333;
	Wed,  8 Nov 2023 15:19:40 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E437B1991;
	Wed,  8 Nov 2023 07:19:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gb2PtNhua7wSiFVF4G8e/KJBjyEr7zQjb4RH2N1CJnIUn5aL3cfqrvhNAkZD0yxbX6xJgSLN6E7rwT7dkILzJ6qoQrNjOC3CUCM0B4hzg9nL6SjAOR8r5d4lX+jO0g49DM0T/BY0p97Oc6mUO6kEBHzBdl3F3NmtspKuzT3hdoEqmRNy5b/r0Hd68zxM8bY1c182d2kj/kFmjY1+pnfeZ4oqvT7KpZ923ZNdxVreZma+ayT2i34XD7PQr8Q6n6T4e4orVhfGsDCN/LUPNUdLC7Lwlck3F5KIOIqqjulnlBNDwOIS4+755f2zzhg3u657QlGQh/CjF7ipIUxr6V+A1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=739yf/Vir7+5YdRzch++nK7N5jqJabcKLBDu9bKbNO8=;
 b=IX/nI34TliAx8oXQhH7bpWvS4nmE7iSFvCf1teSUg7qA8Jd2LxKpsqC7t3teYVbN15LnE9djIcUKIW4yyXlrGctdcbBkArf75p6MrwA9Go9Fqy5ZmaoJsBh67L8ZjWyDzUnjUsCnIcIAipX4R20KqHKbhXLC74JR1nCl3qMm60ZzruuvRceaoXqIX7WppkACh718OPDqHCgyf1T1v2kTGj3+1DJFATxUHc6fqo+VAjwEmkU2n8QjBYw6aFs4jFDzRPEr7DLT0Dlwt1ejoVS+UO6kT5mO4exDmnKbCYWR6rH6Z83ZIJIl0VwEo9niU3pNFpwFoqG8zH2lmwqj2AS9aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=739yf/Vir7+5YdRzch++nK7N5jqJabcKLBDu9bKbNO8=;
 b=s3A93e6HAFPhEk/Gzijn9LRsnh1Y1Cq/YGW5RxwzSU802NdMRvp+6Mx+GG1LfdvAcOmfWh+qOFTBqXpQ8Me8Y7dRlUZcewys3DSJZClGoxm4vAuW6oMCqcEuRtmG91Mxt+Of1dyi1RTF01A8m+NQ0iHofTQm6PfY4ZfO64iApvU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH7PR12MB7939.namprd12.prod.outlook.com (2603:10b6:510:278::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Wed, 8 Nov
 2023 15:19:34 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6954.028; Wed, 8 Nov 2023
 15:19:34 +0000
Message-ID: <0eb91574-9b50-4225-acd0-4dcf1eafe596@amd.com>
Date: Wed, 8 Nov 2023 09:19:29 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
 Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-7-michael.roth@amd.com>
 <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
 <8ec38db1-5ccf-4684-bc0d-d48579ebf0d0@amd.com>
 <503e778f-6324-44ca-b057-afe510ceea0f@linux.microsoft.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 1NhFSLKvfA==
In-Reply-To: <503e778f-6324-44ca-b057-afe510ceea0f@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::9) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH7PR12MB7939:EE_
X-MS-Office365-Filtering-Correlation-Id: b9ad502f-74e0-4429-42c4-08dbe06e1cf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JwLa/EQ59LaWftVjGv8jH9GbrSW8ckNInNG4RMqzd/pZURsdoQ8EQBYBDy5Li0/7FSVs11gxWIzafFn51nbR+VocMxKqly00E8NEidpyYbwsj+4Y+laWwIprzpXDGwaX1Lxj3YBV9VfQuLfRfevfeDO4Tp9Mf+F/b1vGvUnmDMEQRhDlA9GhesYAFo0reQEDDoSxspgpc2Jh9dix4ogZar/rk6xqS7erU34D9u86p314TO7LpxxAKPBMDjnu2T/PAiw3lkUDm/xVs/qIRl2gb0RUmvdZcvV8qKPf2wVqwdy5ldsnKenh8hgUM5HTyeTZdXZbo3C/UENfl2Du9RAIpO7ohPefOK0Kbp2WFkqMDubRCPCmz4H1GahzEkLheLQwRhFfezAFGAxHFn1It7wkyd6RXPcCpXNcJ4tJjPtfMczkSNmBrnBJXx8LmimROQEiraY6kMLgaMjkMxN2fspz5yX5O7swaoOK69sS/IXbIZtKjcJGyYOFayMViMKeNaZN7vUDoybl4aqhhOVSWPXAIiKrE3DOdZVMFVxqPsUpjuUK93S1jdu+02h/zGqHpkpfT17IACjSIsmnVf6seHuRmsZQVxkkUvoCKruUqxwM7qXyOyqSSAo1pEtCSN2FdrKStsdjezA3FWNUcVs7cWhbAQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(136003)(346002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(36756003)(6666004)(53546011)(6506007)(4326008)(8676002)(8936002)(6512007)(41300700001)(6486002)(5660300002)(2906002)(7416002)(2616005)(7406005)(31686004)(316002)(6636002)(83380400001)(26005)(110136005)(66556008)(66946007)(478600001)(66476007)(86362001)(38100700002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkttVWgyZ1E1Sk8rYlZMdWR4UzBHSmxvUnNoMkV3eGpkdHRNdy8rTXptRVNP?=
 =?utf-8?B?NHZudFFDU3dhTXY2Qm5WamNXc09JZ3FQNmVQTzFqYTA2TFRpejRmZkt2VXJE?=
 =?utf-8?B?M0lsbW12ODJaK1NkNlFqTXNrMkphOEczOVFtQ0x5SWxDM0xoc3BtUzNzY25H?=
 =?utf-8?B?OGkrWVMvaGsza1QwVG5nOTl4Z3N0Q0hYb0YyQVJxREN5SHBERTg0L0JjWk5W?=
 =?utf-8?B?T0NyWFhnVGd5T0NQOEMyNWU0TUtyd3hkQU1PUHFVU1VzeTZKaVdMTkJJNkNN?=
 =?utf-8?B?TUo3aDJYUW1aL3JvcXZDR0dHbXJaWVlVL1FZYzE0T25EZVp0dGU1enBIVlJa?=
 =?utf-8?B?OEdXTjNCeUhFSVlQaS9jOWhZR1FqZVYwZG9CTUJ4bmxaNDRicWpobU1KclVQ?=
 =?utf-8?B?SHRxYzB3OUQrQjFTR0VyNCtNeWZoWDdFRkZGUzBJTjBkVlFMNHBLa1JNNHRz?=
 =?utf-8?B?MVNVVTBTa2FnNFdjVGxDUzZ1Y1Y2NExpdnpveGVVaVJqampZTXZSM1EvbEJV?=
 =?utf-8?B?RkRxS085MzJ2V0ZuNUdrNXo5bzUxQW8wWEVKMHBPU0lZN2pEYldyWDY1MkJJ?=
 =?utf-8?B?Wll6Um9EeXZxcGJNYnBJc3VTTzNOQzlvTnBudnF3Vjh5QlJHNHUva0RZQkhC?=
 =?utf-8?B?UDVMQ2kwMkR4Y3VoUnBrS01sdGo3S01Od0xzTGV0a1FrU0s2RW5xNC9LR3Bt?=
 =?utf-8?B?djQ4cDZQNGRaZUs5N0xGZHU5Z25jQzhJWHcyV3lNQlZwVUlIMEJndlpINlJM?=
 =?utf-8?B?VkUyVTVIcTZOcWRHRWJpYk5pZ0ZGY1dJTmk3bzR1ck9rbzFSYUp0Q2ZrUUY0?=
 =?utf-8?B?cWp6R1dFeXdtS1lhYVB6cVRHSVJody94WVhsRC9lUlVvU3pPdVd1Y2xmQzNy?=
 =?utf-8?B?bDhGcUVmeElLL2NEdHVqUDFhVHJveXlKQS9RQ1V4RXdvcFl3emdQcHkwMEZI?=
 =?utf-8?B?bzhLclRqUjJvWXo5SUVQOUtJUHRmelVMN3JSSGluakVzSGZROGwyMnBCUXdC?=
 =?utf-8?B?V3VsWURreGl2dTdyRWwzTGcxWnVxYWxtaXFEMGtzVm1JYldhMUh5RjFWNVRi?=
 =?utf-8?B?MmsreEZzZFVVWWIyUzJqdUZuTjBXcDZyWFV6NUZhdmw0VFdGYVJ3elVCdGd2?=
 =?utf-8?B?T2FaQWsxYlhiMXJIK1I4cU1yd3ZCa2VwcUMzRHplZkZuNzRUdDEweHlVQXVW?=
 =?utf-8?B?WC8xd29McXZreGxCTHFjUU1TN1NGajB0TUxrZFQ1eTVDUmZZaXhkcTR6Wk8y?=
 =?utf-8?B?cE1abG5sS2VVREZZK0d4ZlllNktJRGpyaWhZZkpIbVdoam1HZG85RDE1cjFz?=
 =?utf-8?B?QWk0akJ4c2lrcDArNjdKYW1hMGNZdTY2K0dSQTV3VlNtNVBlakFnakFuSXpv?=
 =?utf-8?B?RnFMSzBSN0F2OFhGK2UvQ1VuSXhGZ3c5SGlNL011V1dCSHVEeWRPYm0yRVlG?=
 =?utf-8?B?Z0ZLQTl3NTNyenQzRFpRY0RwdzRBV2RFNXFWd0pES2c5V3VEcE1Ea2tXaVNV?=
 =?utf-8?B?eHNwMjQ3UVZYWEdyaitPQkMxa2Z5dTRMalhqQ01HM1AxSUprTkcvaFR2ZmtP?=
 =?utf-8?B?TS9ncjFIRXEyM1lmOCtnWmRqSFFiSDZTdnNFaThwT2tuYWlyaHJoY3g5Z1Rw?=
 =?utf-8?B?TmlKSWVqYk95T25ldERHRGxPTFpaSkUxMmM2ZjV3czJnU3YybTA2MWpqRkgy?=
 =?utf-8?B?MWJjZlBEQ0M0ZTN0UW5YSDFtNUVXZWIzN3hnZW9tYTh6M0tyUDQzazRDQSsy?=
 =?utf-8?B?ODhNaVFkc0x4RW9KeS9IcW9raTVST29udS81d3FaQWdtTGNuMVZHMmg3OWZV?=
 =?utf-8?B?Yk1OaGxUeG1odU9qN1hlbWdWenl0YVVNbEZXNk1NRk92Sk9vUFpVYTg3S1Rw?=
 =?utf-8?B?YlVVa2s2emYvbHZDWStzRm5iU01rd3R3aUFIQy9JSm5pbWN0dys4NzJZWWpF?=
 =?utf-8?B?byt5c1FYaCtZK040RXNISTFkVnpscG9VbXlkS2pCWVdRZG1FSndkZHY3TnRl?=
 =?utf-8?B?U0lHUEJPN1pXSWt4STVDTkNvblIvMUxlUzY4TWUzNURoTEZyZmZ6VFJ6NWxO?=
 =?utf-8?B?UzBmZUNVNS9tY3UzVXFZdFcrbGd6ODRjVVU5R2wvcUc5TmdaSkdPLzhzbjJz?=
 =?utf-8?Q?Ops/xr5z+Qih7nx4+p1EMM1FG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ad502f-74e0-4429-42c4-08dbe06e1cf0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 15:19:34.1806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNIoo/jTF3FjPnMq7TpipV9Hkhfjf067cNyxEfqGyqQu/MD7eMDnZFlNBtK1O3K8grhF2YRs5KwaztnaISbMQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7939

On 11/8/23 02:21, Jeremi Piotrowski wrote:
> On 07/11/2023 19:32, Tom Lendacky wrote:
>> On 11/7/23 10:31, Borislav Petkov wrote:
>>>
>>> And the stuff that needs to happen once, needs to be called once too.
>>>
>>>> +
>>>> +    return snp_get_rmptable_info(&rmp_base, &rmp_size);
>>>> +}
>>>> +
>>>>    static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>>>    {
>>>>        u64 msr;
>>>> @@ -659,6 +674,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>>>            if (!(msr & MSR_K7_HWCR_SMMLOCK))
>>>>                goto clear_sev;
>>>>    +        if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
>>>> +            goto clear_snp;
>>>> +
>>>>            return;
>>>>      clear_all:
>>>> @@ -666,6 +684,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>>>    clear_sev:
>>>>            setup_clear_cpu_cap(X86_FEATURE_SEV);
>>>>            setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
>>>> +clear_snp:
>>>>            setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>>>>        }
>>>>    }
>>>
>>> ...
>>>
>>>> +bool snp_get_rmptable_info(u64 *start, u64 *len)
>>>> +{
>>>> +    u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
>>>> +
>>>> +    rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
>>>> +    rdmsrl(MSR_AMD64_RMP_END, rmp_end);
>>>> +
>>>> +    if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
>>>> +        pr_err("Memory for the RMP table has not been reserved by BIOS\n");
>>>> +        return false;
>>>> +    }
>>>
>>> If you're masking off bits 0-12 above...
>>
>> Because the RMP_END MSR, most specifically, has a default value of 0x1fff, where bits [12:0] are reserved. So to specifically check if the MSR has been set to a non-zero end value, the bit are masked off. However, ...
>>
> 
> Do you have a source for this? Because the APM vol. 2, table A.7 says the reset value of RMP_END is all zeros.

Ah, good catch. Let me work on getting the APM updated.

Thanks,
Tom

> 
> Thanks,
> Jeremi
> 

