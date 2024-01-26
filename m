Return-Path: <kvm+bounces-7043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98FAD83D2D2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 128061F26EE1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 03:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076E3AD49;
	Fri, 26 Jan 2024 03:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jysyXo5y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBCB8F5F;
	Fri, 26 Jan 2024 03:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706238234; cv=fail; b=mOttz+FjFKF8QG2wraGD9IvHyzrR/aMDYrD9P7hWuxwen3Lm/I+pJYoGz7azuzOJ33d/Y/umiZcI400S74H8jfSEuP4IUk0T2f5PnfYKSpoLTw3gntDtPcS8yKy7AbatGdlr2skkzCY+ZX5Om/Jpw0W9Z1cnQOj7cVMGz8KMy2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706238234; c=relaxed/simple;
	bh=68yriXkhpIIsJGjNUNrxJGz8A/SFpTGkLSmwfWRhjRg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A8P/yqPgmiQZpTiPsdnpGGgT/jXJpjTyM2/432RDCbTzu/g4K8JoB0i2/qfjozKWnShO9lpgw7Z3KGzteU/afiYBeepIX3xbC9+Fs6frBlOLZsgub34VBlPzrbyAnrqK+QosmjDjkmU8y1sNyanueVg/R3MUPfnPrBMyKgRq1TE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jysyXo5y; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edzT63DAWSxVTqFeft0ioDcixlO/ZXnef375aBYLdNyAkgzkzPdKQQsn5caVHh7+aZUQ2iPb1DcpyNXbxALHAxTeNTJEP8UvGAZrS0rfyOTFsrxa9mQEUmYsdnykuiWt8WCq6vfY4TrPwZ4JqDaY8THrY3d1EZ+1TA/wy74KrPsoC7ry8wDlZL3lq5KQKrf23c51Sic3kvBzVEf4uJXXX8CW6u86/pVYRgZMVRz/nc/ClfHtGe5Bpi4JDjLk5g14A8L0uc2XE4fuRRSs2jpX7xihdhONpN19dPM6UDzkIxIYEqLZ1tSyzbJlfc5vMxeMLczEQ6tsiMjnMaXX/mymXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruo9megWB7tdFWotbxLMpjBYxEY+KCoN0/W8nSZZXPc=;
 b=CFyMke+jGAKH+9KT3NbbL0s+KGwuQr6sCC3ut9s7a2S8gA7DczZxbii15GEb6A1ppQ35BgHlw0pjuOZTaPxnPnJ89/ZOwtiR/AyToRyNHZqNE9gChOTZ1mFFofzKL6QPa0Ne/y9/Y7ZTuqzlwo+1BzjYLroDNK/yGPpsGdO2Q1MUru/YFRJgsP2v4YueKfJPdSMjWndw6IULNo3XGec9tB1SppSJiqYIdwKbglkEl4Wsuj3rJGw1z6r4xCLO4bT8wQasWWnpYj4dr8FMnjQL6mIyThDQYB94Gd1OmOh4EvZqKGBdETF5Lth6kwoM6VGb/oF+ZlJPULLb10nuGu/dCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruo9megWB7tdFWotbxLMpjBYxEY+KCoN0/W8nSZZXPc=;
 b=jysyXo5yN2leWbzjNPXRcxttMwiu9tKu2WYZEVC6HcY0cIrFy+Ehlex5YZkxKDwTG2r9bdrsFu3JI4hdEq4TLOuQAd1Di3us+2yvn7eCVefq4b4rO6lHc+2xNgJeapbwPqjGq9yERm8zDPugUvpGepRhYBSnEclFDmRid7GP0AQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA3PR12MB7998.namprd12.prod.outlook.com (2603:10b6:806:320::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.31; Fri, 26 Jan
 2024 03:03:48 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::afdf:5f2a:ead9:622]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::afdf:5f2a:ead9:622%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 03:03:47 +0000
Message-ID: <ea2a6e5d-583a-4e11-b9b1-1f6f353d2c02@amd.com>
Date: Thu, 25 Jan 2024 21:03:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 21/26] crypto: ccp: Add panic notifier for SEV/SNP
 firmware shutdown on kdump
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-mm@kvack.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com, tobin@ibm.com,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-22-michael.roth@amd.com>
 <20240121114900.GLZa0ErBHIqvook5zK@fat_crate.local>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20240121114900.GLZa0ErBHIqvook5zK@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0082.namprd04.prod.outlook.com
 (2603:10b6:806:121::27) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SA3PR12MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: 52d64228-b167-4f8f-2847-08dc1e1b6a5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OQACnZxLAdvbMKgggliJoJvPRsM/2HHEgatLdLyEk/C+y1Md34WdxQi6gW9HrmjvufwAEezLpp8Fr3dmox3GRKqbJ5gd0oFkrVnebm7l9uEezpUJMnbmSWl8Cr/YB4emSoAF83q52nAomYywPp9tklBCM/XCYR1F/d9D5AvElY9bOsqPGUYGGOw3jEj2HBrIyQM8gLVDhhc8RsrN+66VrZ3El4uDxYP0C3uPtVoL65IEAfQ/JFh1odGXu8/Cvh7ZZT/xBI81tb9mNP5xCEkfeoWaO+Tdu3gq9ca80da1BuTyh91wQmaLe+DSzUBAQqZJ0oi12eCe43z/qHDMIb7pNDgMI0jVbypbgscBZpdfPRFR+Ruo58K3Azu/8EFSdhkV3zztHcIiBmUfkrHMAE5C1jitNf0Yxj6Fowqj63NIt3z9v3W8HVJm3BnuKOahLSr8fyJzbCUaoeDb2rE5jby3nM7upKtSu0l3N3qsQ322N7nraVm6kI2PCo7YtEaCsWXR9AH/feB0v6bxONWvKHn/y97REaqBAoMI3tgOpew7Bkq/hYxX5KxsD04k405lH4UAHgZxrRLhbuj4rKSQeE5BMYfpObAZXSmi52OitrZzfq5QafZ8H5pqMcPAeo938oIgQnrKgLojblwbWCSpMKy7Pw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(346002)(396003)(136003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(316002)(66476007)(8936002)(66556008)(4326008)(8676002)(86362001)(110136005)(36756003)(31686004)(2906002)(66946007)(5660300002)(6636002)(6486002)(6506007)(41300700001)(53546011)(38100700002)(7406005)(7416002)(31696002)(83380400001)(26005)(2616005)(6512007)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjBYbDF2YkJpUUl0dk9tRFdUUVl6T0Z2eDhRK2JubUhnR3FJTm1QeStpc3R1?=
 =?utf-8?B?aDlidXAzRVZOSERudHovR0lpVVZSbEhSVzA3UncxZjFQcDRxSFNISjhVcTBI?=
 =?utf-8?B?TjBNQ1lmeERxOUFlb0w4SVNtSEJyM3dTbHJ4RGl4RFJhTHhFRldqT2NYMHZn?=
 =?utf-8?B?S0tkRXNLVXR3K2tSRWtDd1FXcGZ4elRkSWFzcVNRZTdITWNuK0JDVnIxS0Zs?=
 =?utf-8?B?aytjcXFwMlMxRUJET2FZL1hTZDAzV0U2S0VXck82clgyc0NjSDdpajNHT0FZ?=
 =?utf-8?B?Q1MwNE9rSlFsY3Q1RTRKZnNLWGRjajFoaGxWMHR4S1J3UzU1TGRvK2ZJb2ta?=
 =?utf-8?B?M1NGVFBmeFh0MHhRbHlCbDFGT2xITGJEeTVwVW9aKzJWaUk0YS9KakdWRU1v?=
 =?utf-8?B?MlpIcHhVYVNyaUh3bEFtN2JDdkZ6REVTTXFVTEM0ZDhFd3VLUUhIMWxhbUk2?=
 =?utf-8?B?REpTYzRZQ05SWmNHellqeGc2Qm13RDRCUms3VHkrYjNFQWhxWm84SmpBZnFZ?=
 =?utf-8?B?eHNyYURPbHdHa3k4VmppZkZxSFpVVWxIY2RzbmZQeUl1U3lvcWZ0MHI4TlFG?=
 =?utf-8?B?SzkrUlh6dy81UEFZRlFsejVnNEF6ejM5WllYRDBNUTRiWlRNMGo0ZmU1dk1J?=
 =?utf-8?B?VCtWdVZzaE8zYjA0emljT0ZqWlE4cHNiRGZ3YXpDSnBoak9GN0wyTy9qTFZi?=
 =?utf-8?B?TFlBN1FzNXlXT0x1U2k3dnl1WFQ4S0tqOVJ2aVE0OTV2WU1sWTRmc1cwZi94?=
 =?utf-8?B?TDBCY1dhaGY4R2J6amtQQ1Vkcm0zKzFQNExoNkJWUDZRS3c3ZHBIeEFWZm9K?=
 =?utf-8?B?VmdNK00vbW11cVl3QWM2ZVArdGVsNStxcytYZVRqbmxwdlNQa1JqT0FhTkls?=
 =?utf-8?B?eVFvSE5QaXY2Tmt5RGVpVGNkWmpTaVdTVzZDNUtJbEpxTHV5eHZQaERQOUNU?=
 =?utf-8?B?bzREa3NQd0YveUlFeXpBM1o1MGpmY1lUdVo3VVc4UHYyVjlOOUtQSlg3bm5r?=
 =?utf-8?B?NThETmpiL2ZHNjViZ2hZT3d6RGhaaTNWcjNiYS9sS01RQnZpZzFYNE9rUXhY?=
 =?utf-8?B?cCtlSkVOZE9Bcm1IY25OZUNjb05FUm80VUtxM3hrTktrSEpHUkxVRlhnVUNn?=
 =?utf-8?B?VUxpVVIzYTJ6aXlUT1BPZWdraVpic1k4VkFSYXlpT3hoaTJDT1BEd2pRNFhk?=
 =?utf-8?B?WU5DNmtiNGd0MzRlcjlVbmFoT0dNWEhuVFdGWmVsMUEzbGtZRUZWaWR0Z0dz?=
 =?utf-8?B?YnJIVjduUy8rWkhGTWtZMjU3YjNzMUFFZ0k1YnY2MVcrY1BPSTZLMG9qeW80?=
 =?utf-8?B?bDYzSlBPNkkxM0JoMEE4enVkWTVmTjhaNDByMlFaV2IwMExHWmhlakFvRSt0?=
 =?utf-8?B?aFpxc09IWmdUeEVCY0l0Q2pNTWEyTjFQa1JlQzU1cHU4SEZNRWJadWdqMWs1?=
 =?utf-8?B?NmxvejZBM0lSQ0VEZU9kclFoY0swMDhya0JwNWNkb0dTek1pczdWQnZvY25F?=
 =?utf-8?B?cmpYcU9uWnZXdm9nNHdJYlE0NWUrd3JxTGg1Y2VlZGJoWnFxSUNQWnNlSGpz?=
 =?utf-8?B?RkJVZlZMYy9CdnVZbXd6V3E3YlB0a1BZbUF0bzFWd3R6b20wWEZHYnhBbDhB?=
 =?utf-8?B?MkdJUXdGaXBVM1FWT29XUDZ1aUoyRTN3aUM3Tnl6NDFtbnFrcW1DU0U5cFB2?=
 =?utf-8?B?S0YwM1p3dGEyWklGYlZqVmhKNzIxYnRZZHp4QmtWZUxROWV1cm1DbmhxZ1Nv?=
 =?utf-8?B?aU1jSGJOUUdBRlZ6WWJSZ1pSa2dieVl3dVR2VGd2TENRS3h0OWEyRHpzRXp5?=
 =?utf-8?B?MDRxbWM2TWphQTgrRVUxVEpQNGhuOGIvczBtY2tOYk9ZRU43c2Erd01Cam9P?=
 =?utf-8?B?MndhdGRqNFc5Wkk1WWdOTDJvU1hjdWhPQW9weDdnT2YwN09FK0IzUTRraStm?=
 =?utf-8?B?ZG1PV3pvSERIWVVsZnBpTy9kNHlnd0I1WDA5OG9IU0MvVGZCU2xaSjBXYkMw?=
 =?utf-8?B?YklPaGk2bEpENU1ldWJlVjV5MXZJd0RVWSt0VWRydzdkbm9XUENPSE1Pa3Iv?=
 =?utf-8?B?WFpMQ3ZpS1hNNmU3eTFDRnlPcUwyRDJ0V3pQUDhmc2FUQnFlbGVRWkVYaGh3?=
 =?utf-8?Q?z2Q2tVkRfEZBKx01jIE8Ucgjg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d64228-b167-4f8f-2847-08dc1e1b6a5e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 03:03:47.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7X/bX7Mf4MDGDXFyo5lU7AnDVZRz0vAM1GnJWBBGHr4tKprifQaGwkEiGwEFSJWgb8OILuTL+iDgNxTILiFaMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7998

Hello Boris,

On 1/21/2024 5:49 AM, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:49AM -0600, Michael Roth wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Add a kdump safe version of sev_firmware_shutdown() registered as a
>> crash_kexec_post_notifier, which is invoked during panic/crash to do
>> SEV/SNP shutdown. This is required for transitioning all IOMMU pages
>> to reclaim/hypervisor state, otherwise re-init of IOMMU pages during
>> crashdump kernel boot fails and panics the crashdump kernel. This
>> panic notifier runs in atomic context, hence it ensures not to
>> acquire any locks/mutexes and polls for PSP command completion
>> instead of depending on PSP command completion interrupt.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> [mdr: remove use of "we" in comments]
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Cleanups ontop, see if the below works too. Especially:
>
> * I've zapped the WBINVD before the TMR pages are freed because
> __sev_snp_shutdown_locked() will WBINVD anyway.

This flush is required for TMR, as TMR is encrypted and it needs to be 
flushed from cache before being reclaimed and freed, therefore this 
flush is required.

SNP_SHUTDOWN_EX may additionally require wbinvd + DF_FLUSH, therefore 
there is another WBINVD in __sev_snp_shutdown_locked().

>
> * The mutex_is_locked() check in snp_shutdown_on_panic() is silly
> because the panic notifier runs on one CPU anyway.

But, what if there is an active command on the PSP when panic occurs, 
the mutex will already be acquired in such a case and we can't issue 
another PSP command if there is an active PSP command, so i believe this 
check is required.

Thanks, Ashish


