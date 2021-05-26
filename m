Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604953918BE
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhEZNZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:25:20 -0400
Received: from mail-dm6nam11on2077.outbound.protection.outlook.com ([40.107.223.77]:15539
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233130AbhEZNZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 09:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Me7XT6BXXwIuQsCQjGtnAphjqKfimVyf93WV6W0Yqw1GrZjHzIX8s2vQCG+IrGk6NWMxig3OgBbfgZvAQp64ZfGYWm9vjME6PsCaJ7etHwyAAmxQFfi8n4HSZ+PGxE91HzOUAgazm+pDIoPCmxNqSRO7pDY0V2eRbGGlj4WsXyjoF/R6NIT1vQ+j5x5hEJBteCeMQFeVvdwSgftOtd639anrHFlLNqYOt+fWnwGEDN07U2YyFdMSEeYqgGJmh8RIcvsph6H5tEtIgPRuQHtet3trkuVpA8CGGo/ikyHT4sVFYcd8xPZOadvE6ySvmPpj5Z/1s+cL+CtISwzVcpp9PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjp2sDNuJ898l30QtUPCykiPOrseNsZ04qjONJSxJrM=;
 b=OjC/IlOVqpixTH2v8etjgUMsOfMjxT0EqP/Pad3ACev0SXrxtIvVUuuXt9MIJY/MAsjcQ7nrS9kyPeBQoz9mX9b6ri+7NfwMhgA5vEQkoysbNPRHqVUootwXM83Dl7/NtoAgGiXLVTtxFHIJ29VN61nRO3NuDexe+hLQp+hpbPGry932gipSmb+CR47EsGxq5yeTkmBaeM5//oYcYvGOAuzWbfzshnCGtnvrcfGNlCC5b8eo6nd7K1i4G3IGPQzvi+JpoM0qTqpKz62GkPB4NAW3auDI8v1hfAT7JbBmniLVWvVm4kkY9VFwl8E6ikC5kOjWNcw2zah8xiEFG7Is7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjp2sDNuJ898l30QtUPCykiPOrseNsZ04qjONJSxJrM=;
 b=hE3cf/KqIy1LcON4vV7SDpIwk8MyHY/Jmo2/5Ed13l65gKYbE7Kqq1hnSjTkMoiVwrqIya38WZgFI9wFrm/pcbnmaxLuOrm18bYi88cu1HXoPzr3prVfQMDyfBa3ZolaoDBy+K2dk+nE+fSr5X+yvW5dLOJ53Cx00ynX/+eVMHA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 13:23:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Wed, 26 May 2021
 13:23:46 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 13/20] x86/sev: Register GHCB memory when
 SEV-SNP is active
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-14-brijesh.singh@amd.com> <YKzbfwD6nHL7ChcJ@zn.tnic>
 <b15cd25b-ee69-237d-9044-84fba2cf4bb2@amd.com> <YK0LFk3xMjfirG9E@zn.tnic>
 <9e7b7406-ec24-2991-3577-ce7da61a61ca@amd.com> <YK4bnQiJ6cVzCCE9@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9fada61c-274d-5348-ef1f-eb1b3bb337e5@amd.com>
Date:   Wed, 26 May 2021 08:23:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YK4bnQiJ6cVzCCE9@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0030.namprd02.prod.outlook.com
 (2603:10b6:803:2e::16) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0030.namprd02.prod.outlook.com (2603:10b6:803:2e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 26 May 2021 13:23:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42f6cbc9-56bd-4a5d-00ea-08d920497d6e
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2414464CBCDE7F091D4B0BE2E5249@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8D/861nY45v7Fg4LQXWaJWGAJao7Ai3na6U7J7CoLTuzLzlWCArJBc0EgYwXNp6585NSah7wblgH/T3oSZGRAkNUPuXY7UT2/nOKgnWL+6L3eFxfedxwd4AKo6I4e9TpdEyJCcA+Vjd9JWIp8d4o6ihXbil0UvIABdnZ/QQoQ+oJ3pvpDtVXRnZu8SnZBc/Q7iu6CQXWDYDh5BzwOIq3IGmAGrddGypOxK8tmTypP+rwGcWmVW9s7MnHz00kCspn/OK5cjIdehhaj1iZBivVxl68zaK7ITvbQluM9VFsI9D4P9k0F4HhZiyyK7CwXjR/IYCdukKxiiSdaH0tb0VaDkpz4veMWpbgRdK2AlI3hBoXE10x/yCBsOHpD3PSu1riCKtdZm66t0ShsQAhPIg8SjFD3lq/wgZEofFo6XD0vCFmpyUdVjP2QpbDjojUZkbBrRgU+qEWs5mbDV6lRadb6dsQ1DMaa9hAwvoQd0VZcrdA9FEG6wolHLb+FfjQfhDxik3IPML0Lsa+U6o4D8D7ctd2dRUMAstWotW6a0W8HQzNwLFp3LQQ80w/LR1bpDheYaO1fCx9rT1XDTanmdKqnzDrKiwKHeacgJogEJxRp9E51B0V+vfjdR3jZBW08b2sSXeg4blReEMfZGggdDL6VDfKHIb9uA9qvelymgLnM28cMbAGYEt/k/bNBY6QaDUnNdGNjqkD0G42ZmTvM7FXjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(8936002)(16526019)(4326008)(6916009)(31686004)(186003)(2616005)(31696002)(2906002)(38100700002)(38350700002)(66476007)(66556008)(8676002)(6512007)(26005)(316002)(5660300002)(86362001)(66946007)(53546011)(6486002)(6506007)(7416002)(36756003)(478600001)(956004)(52116002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OElwbS9Bc3RGc3RtQ1NaOTFDZVRRRm11em1Ib0R5b2ZuZ3d6UlA1anlOWWUz?=
 =?utf-8?B?cmFxMmdoZkNFTDBGRmxReEVYVGRHRms1QTVYRlZCVVpCWWpZZFZVRDFWTXha?=
 =?utf-8?B?WlBuWUd6N3Z0aXV1bjZac2hPMVhaYUgzRjM3TytHSjBDeEhFT1BZTzU1dzZk?=
 =?utf-8?B?Y2d3Mk04SDBrTnNEVTd4NVRCTUh4UFZWUUdZdGRwNkhwdzhXVVlmRWIvVzVT?=
 =?utf-8?B?eDNQd05MN2Q3T1pZVE5WK25WSWhPZ2ROeVJjUDRkWFF1ampzNWg2WTU4dWY2?=
 =?utf-8?B?NG9oT1ZIK0I2UHFXcFFaVFBDdGpsSHlvN3RpOFJsMER0QVhPamlpcnRSTy9P?=
 =?utf-8?B?UUNsbEJtTU9GcUVIOUlFRk44QlNKL1c2UkVaeko3cWoxTGF6RG5CMXpoK0p4?=
 =?utf-8?B?RDVWejRyOXZaMUhHRHh0bDIvTjAzRktQWjhEY3NreG00SDVMK29MY05vSFll?=
 =?utf-8?B?NFc2Q2RPZW9Ja2tYc3pwdkdlYlpmN2ZhNk5jR2lSdGZ1ZDRVRm9HY1dMY0lU?=
 =?utf-8?B?N0k3R3pKZUpIUHo0dTIwdXpPQ1MxZWs5QTl4V3NvMEUrTldKU1dYN0FiRGsz?=
 =?utf-8?B?blBxRzREWk9xdFlGRktBK1lsanVwanZ0SWtWMEQzTjB5OVBDUXNpYWVtR1hY?=
 =?utf-8?B?bjVGNWY2QnlZWEpqdE5uRUIwK21OVGZlWnY3WEZ3OEMrZlBaZlg5K2V4S09h?=
 =?utf-8?B?clVFS0JYVEo2MWMra3I0MXpVeUNKSTBGV1d0bVkvblBka1ErelhnVVVteWg0?=
 =?utf-8?B?c0UrYTBsZDUxS0RzQ0ZRNkFURGZMMlN3ZVV3VVUvUVhsbklVTHNhMldqTXND?=
 =?utf-8?B?WlpvdmdVM0NrN25Pd2FTWnhxR1RZalI4MGtaVzJFTzJUVm4zMkR4Yk5nSGM5?=
 =?utf-8?B?SHZBNEZpQWEzdGQyZG1QRjNZd0RmYjNBYk15eXpTUWsyUGQzUERDVm8vN0gv?=
 =?utf-8?B?UnNUeG84cEx4d3hDQytyellWVXlDOExFV3gzcmkxRnlERGp3SDBsNHUyMXEr?=
 =?utf-8?B?ZEhKTWpjZmVvSDNRWUg1T1NQSlAwOFFxUFo0eU5Udk0xVzZlM1ZpNXY1TUgw?=
 =?utf-8?B?cVFmZ3B6SktDS09xL1BrMGdkOGttSVZINmtWUTRpbjFpazFwQlMwRDRhMjV4?=
 =?utf-8?B?ZjdVUzdYL1YrU1RZdzhadGlOZmMzOGQ4c3F4Yms0VDlwQlBBK012cTNDYy9C?=
 =?utf-8?B?Z1NnRHNieUIrU2xHc1daN0YxaU1wcW52Nk5NZVZsdlFhNW54TXhFcGFleUVQ?=
 =?utf-8?B?QlZlY2FhVmliMXdqNlpSMkRCc2NqRW5tMlhnU0ZFOFc0NEJEVno3YmFiNTlD?=
 =?utf-8?B?ZTNtTzBWRmtRUlZqcmRyYzBib2k0bC8rVzJBK1E1RWo3TE5xTmQ4eGs5VU85?=
 =?utf-8?B?b3M3K0g5VHBzT0gySzhBOVRPTTdJL2ZPRFMxRnFxZW9rQjZGMzQzbldqZFp3?=
 =?utf-8?B?WkhOTVYyMmRCSzdadXZlNndtcCtGWUFBUTlNTC84MUh4TFZ5ZG8waHFCSzhS?=
 =?utf-8?B?aEQ2Sk4rNk9ISXNxZk40a0lOaVhCMjNxbWhmNENzbWxSWTFnckxwV2k1OHNn?=
 =?utf-8?B?dWVoVFhCcExPL21GVGh0NExrU093VDJqdTNHdlpXb1ZCTVRDU0tIQ1UyMzFw?=
 =?utf-8?B?SmY4eWZrN29IWWZvaVdReUk4R1BhODh0OS9hSFBXSzBhNjByTFlkcHkwMkFO?=
 =?utf-8?B?YWkwNVNKRktQZGtyRVhsVmtKZzk1TmpSaEJlOWdlSVk2ZGlkdkZzQ3BzL1VQ?=
 =?utf-8?Q?RVlFN0g+6fngVZlozNWyySarN6Z/G/ZPlrnsCOL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f6cbc9-56bd-4a5d-00ea-08d920497d6e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 13:23:46.1087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKmAiEAi8llEU7OqPjJ45O9lfLkipUxafWOJo1X3o42R4YUyIlIO8XUj7gLWqT2MUbBVhiY+9pF/iO/5HOlqXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/26/21 4:57 AM, Borislav Petkov wrote:
> On Tue, May 25, 2021 at 09:47:24AM -0500, Brijesh Singh wrote:
>> Maybe I should have said, its not applicable in the decompressed path.
> Aha, ok. How's that, ontop of yours:

Sure, its fine with me. I will apply this change.

-Birjesh


> ---
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index 07b9529d7d95..c9dd98b9dcdf 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -208,7 +208,7 @@ static bool early_setup_sev_es(void)
>  
>  	/* SEV-SNP guest requires the GHCB GPA must be registered */
>  	if (sev_snp_enabled())
> -		snp_register_ghcb(__pa(&boot_ghcb_page));
> +		snp_register_ghcb_early(__pa(&boot_ghcb_page));
>  
>  	return true;
>  }
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 37a23c524f8c..7200f44d6b6b 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -81,7 +81,7 @@ static bool ghcb_get_hv_features(void)
>  	return true;
>  }
>  
> -static void snp_register_ghcb(unsigned long paddr)
> +static void snp_register_ghcb_early(unsigned long paddr)
>  {
>  	unsigned long pfn = paddr >> PAGE_SHIFT;
>  	u64 val;
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 5544557d9fb6..144c20479cae 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -108,7 +108,18 @@ DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
>  void do_early_exception(struct pt_regs *regs, int trapnr);
>  
>  /* Defined in sev-shared.c */
> -static void snp_register_ghcb(unsigned long paddr);
> +static void snp_register_ghcb_early(unsigned long paddr);
> +
> +static void snp_register_ghcb(struct sev_es_runtime_data *data,
> +			      unsigned long paddr)
> +{
> +	if (data->snp_ghcb_registered)
> +		return;
> +
> +	snp_register_ghcb_early(paddr);
> +
> +	data->snp_ghcb_registered = true;
> +}
>  
>  static void __init setup_vc_stacks(int cpu)
>  {
> @@ -239,10 +250,8 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
>  	}
>  
>  	/* SEV-SNP guest requires that GHCB must be registered before using it. */
> -	if (sev_snp_active() && !data->snp_ghcb_registered) {
> -		snp_register_ghcb(__pa(ghcb));
> -		data->snp_ghcb_registered = true;
> -	}
> +	if (sev_snp_active())
> +		snp_register_ghcb(data, __pa(ghcb));
>  
>  	return ghcb;
>  }
> @@ -681,7 +690,7 @@ static bool __init sev_es_setup_ghcb(void)
>  
>  	/* SEV-SNP guest requires that GHCB GPA must be registered */
>  	if (sev_snp_active())
> -		snp_register_ghcb(__pa(&boot_ghcb_page));
> +		snp_register_ghcb_early(__pa(&boot_ghcb_page));
>  
>  	return true;
>  }
>
