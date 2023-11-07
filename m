Return-Path: <kvm+bounces-1055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADF07E48E5
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A71352813EF
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E45636AE3;
	Tue,  7 Nov 2023 19:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BThJdlIr"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC931358B0;
	Tue,  7 Nov 2023 19:00:07 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4F999;
	Tue,  7 Nov 2023 11:00:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNoHWx9f6509xL4wfVap/7CBxMv3bFIrbaivXE5iEJYV1awBInaR47U6AXGlcp67h4KmKw97QpppscvUIS4bqDoJZBqCUcM19YxSoXM3IcNxBWkvX3FtcCLnaM3M/MYr96bhcuXbD7BoZpuuZDnDJva6zANlS++dqt6MIhb+sP3EvCrjoYRRankoM+4LD6Wg+og6rzGw/LS7Q0yp4Us0MQTf6FQQ+iU8+KvvlhnMRypktiLScr7eOD2WLOdhnnSntr56VrzH5TLu0aoE+RlseuraQHU3KeIBor/MexSs2iL1gRo97H4mf4ojSDPiYQn5tzI6dN+Qx1Z6Df+pzkDmwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TK2x+9N9l+vTDm4bOePHxaL7KyAuN4a5XagmA9VPPTM=;
 b=n7kdwQSxpt+l+VPkPMOng8Hli2AKTr89dmZYdaZPPosc4Xlngqs7gHkgPXm3DTrezmhzFz90Cdb0SddvGfu+V3/oT6N+rROzpPt1yT5JlGa90+kTUrqk/xF/kiV6mBFxpXHoJowEIG4Eb1gt6rKfhDlQF0Jse80dgDdTABBuw4aPaXkn5Ka7/mvsZpLlJ0hDsMAjXH0hs+Q/gNE5pF3WUrVnRdRqEOpiu5L3gx0XzIiSyRp9eIo5TArc7shG+yHGUC6vGNwyqa4HPP57PfRaZ7y35BGQ52mH0ElBV6yQnIfS8AusjJ3a970YOq1H9rMbOAZHAyYQLAlxvONHTb8vXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK2x+9N9l+vTDm4bOePHxaL7KyAuN4a5XagmA9VPPTM=;
 b=BThJdlIr1n8PUF2khAcfMmvsr1Sw+Goe8kMbdlDpohq9orCgoJIAn63ejgSAsOHcWnaD5gc+oNz9NC6NyGvARColZsGxOXaAIiPssyTBt2n3ZdFn37kjj6b/k4wgg9z/5QLVJEqJrCNPCTCbMew8nox0i10u7WzGooeo79ktP6Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4315.namprd12.prod.outlook.com (2603:10b6:5:223::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 19:00:04 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%6]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 19:00:04 +0000
Message-ID: <4a2016d6-dc1f-ff68-9827-0b72b7c8eac2@amd.com>
Date: Tue, 7 Nov 2023 13:00:00 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 06/50] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
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
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231107163142.GAZUpmbt/i3himIf+E@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0126.namprd11.prod.outlook.com
 (2603:10b6:806:131::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM6PR12MB4315:EE_
X-MS-Office365-Filtering-Correlation-Id: 744c25f6-07e6-4027-cae8-08dbdfc3c01b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XEn1FUKR+hH54P++ZBmncZW1nCkXpX9jbZ5B4zrzFDXLz9nySKmabJ9TurkhnfpcHtXvebwrXnug9zYvlHPQcdD35NGs4zcsoSrL+bh7E/P+vIB72KqrlohuxnF36EjMZeLZkOTxlEuroTU1t4/aXcHNbwor1JJ2QqfIhX1meSOhArXrufdvx4fQR1NptqS0PaDqjcxOZ1DFfVwjQ4oVOoZundUWxAL2FeCo9LLbA2wOy/81GTSakETDQUt9DhcdYoV3HmaMG3gBErHhKio8UCLxc6tW+ivx/+udGKSMI4tTAMZLKLv7NR1qamHLaM+KK6LRwnvmsnAM61C9zke6uosbPDodWqrZcPx8ZErRTa3wvHJSYedxAr03dqtLc5FiU35YO7NtAOGS3/4xpzjj4f3wwHWYaTg7GdTV+4BNVh0Jf/n+pt7BLUOdLCgslYBrFDekwgT6dExr8Xo7nZSZPSj9WS3DEXgao18NtRMltEHE22MsdGQlnM8rNV6dS25x3PSrNIk6JjWrabcTvPdSX4q/+FUa1NlUbbVltsykWcQe1X9iILUeV9bdp7h1kjCTx1HvUXQRUhoWC9vEWeAGVqPflFWUpqDN8j67q79uVgWECM5hNHlJZ1tNOz2JfVzltjtCFZV+5A962ZxVQ48ZpyiZDwT9jmGR1TnTEY+c4QJzU587EhsSDd1J3nxXok6d
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(31686004)(2616005)(26005)(53546011)(41300700001)(6506007)(6666004)(6512007)(38100700002)(86362001)(31696002)(7406005)(5660300002)(6486002)(966005)(2906002)(4326008)(7416002)(83380400001)(8676002)(8936002)(478600001)(66556008)(36756003)(316002)(66946007)(66476007)(6636002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWc5QXQrTCt6Q2RXVzlKRmxqSFJNa2N3dXdTL012N0FHVDFzellBcGpib0wy?=
 =?utf-8?B?WXprNmVhYk9BcUdLRmZXSkRzT1JSeGl2cEhrWldVZnB6N2pOWEJEMXFOYlZE?=
 =?utf-8?B?d0JheVp2RXJhK3Y0VjdITmhpbTZGUlgvV1FrSWRHKzZlTXFMUXhGbTYxcGNX?=
 =?utf-8?B?V0F4TW9mYnVuRjhCT1ZDVm84bWxuTDlMdncvUXQ3bWtjcTlJd0xjOU5JVWtQ?=
 =?utf-8?B?YmUweUJpOXFvODk4N0ZpSVFYTXlmZHkveUx6TUJ5NktTY0toelpXL2xhVlg1?=
 =?utf-8?B?YklyaFlEdU00NU5EcVlGdm1nRUxDbTQwMFNpODZJMVBvVjJHL1lsVnlpY2px?=
 =?utf-8?B?RXlMUHFJZjFHZzluSTdZaHNLTnVCKzVhTEs5dnZHWC9xcHF1K2tTVDFSeVpG?=
 =?utf-8?B?ZDJqT25nbXh4emsxTUxQMklyZUx1ZHJaNVdWdHhIU0JTdFc4UG1oaVJNTHlu?=
 =?utf-8?B?Y3RrbGE5VmdQZ0RVK1ZlUXR1QU40L0QrRVRxUWM0T2VSeDZXWERGV0h6cUlO?=
 =?utf-8?B?N0FtMXA0ZkpUNGtBbG9zdWs1UUlTMVg2VUtoWUU2dFhPVjV5TTlGck5oR1hL?=
 =?utf-8?B?MU93cnk3eDJubjl3SzVQWGdXTmNpblFOd3QvQmVvZlhMdkw4dzlBSzVYRUNF?=
 =?utf-8?B?dmtBUEhZdG90R1MxNm1zRENDaDVHamlTditRampES2J0aW9sckF5Q0xBbFRM?=
 =?utf-8?B?U0NPY0kwM2xWSU10a1BQMkJYQjBwdzkyTllrUDNrMld1RTRGbU5IOTVnUWYv?=
 =?utf-8?B?NFl0TkN1TFRkbHRXVnZKSXovVWpyN3VVaWxhYUVWWHpZZTBBOHk0bjMzK09D?=
 =?utf-8?B?SVA4cngzSUFYNGtkWGNrVGlmZ29PalJhS3lCcnZRaTJlVGQrb3ZTbVBFSit4?=
 =?utf-8?B?azZpcDBsK1JiUGFTd05UUWNSdjgvT3BxZzl5RnJVbWNQUS9yUnh0S3l4OU8z?=
 =?utf-8?B?eXBWMjVKVmpPMGZCVnh0dzB6RW5NUHEvcERNd09XSzJTN3BxS0J2dURrclFL?=
 =?utf-8?B?dUlIaC8wVXd2UWZOWkl1RktvRzYra0ZNdk5wbzc5WHc1KzJlQTVwUXpHZDRr?=
 =?utf-8?B?WnBYRE9POVJpTlVXZmMwQmpwUzlJRmJYVUw4MXNqSlZJMWRTdVc4M25ZajQw?=
 =?utf-8?B?cTg5N2E3V3hId3J5MU11MkpDV1U0dGI3ZVEvM0VHV2JMR3c3dUpTakRzN2JN?=
 =?utf-8?B?UU85L2VSUmRMNHIwNmk3WGVBZ2dUanNldnFjakp1SjJXZVdQTlg0T1dqNHpn?=
 =?utf-8?B?cTJLVkRJN3prQ1NsZ3NtNWVtTWRYSDIwMnRPNXlvWjlSMkdwbUlaNFR2Tmtw?=
 =?utf-8?B?MVRyeWwwdC94NXdUKzUrZzE1RGdGQWhKaDNJM2JTZlAzZzVvSG9LMkpUaXJo?=
 =?utf-8?B?emZFNnhhTjFiOGZ2V21aV281Kzc0bzVIa3A2WjhFVGIvdU5ZdGxRY3MyUXpz?=
 =?utf-8?B?VzFFN3FBakZUaW91ekY0dmFQK2ErTkRNRm81SHVtSjhidEhWY3oyWU9QT3gx?=
 =?utf-8?B?YkNIWWRJemkwd2t1MEtWTFMrYzZFWEFVTDJnUU1nY25tNVdPank4cUNkd3dC?=
 =?utf-8?B?V3hzNXErWjlOREQ0Q0hsSVJFRW9RTExQYWJjRjJmbWNqUkF2d1ZhYklZcFB0?=
 =?utf-8?B?LzdJVEUvbXNQVUFlYXAxUm1BdmVseURodXZTQlFBTTV6N0lVa2ZhR1RjR2JS?=
 =?utf-8?B?emwwZTRneENZNXEwWXdJN0N2cy9WbHUydlRMVGczVEZxOWh6QnFjUnFyUE9T?=
 =?utf-8?B?cGVickRpYUFJd2FrbERwbG5QcU42Z1BZbDM2L3ZzaXpWaG9BcE5PVDV0YnRr?=
 =?utf-8?B?MzRJdWNKVEFmWHZBZERGbC9sTjhRd2k4cUIzLzhjaS94WERqL1MwazB2R290?=
 =?utf-8?B?dkJEU2ZRUFBZQWxKeEFNcDA0VFJQTHFWNSs0RG1KUU9zTGJ0NXo4VlVIbTJv?=
 =?utf-8?B?V3RvY3drZHN4QUNncWUyQ0lzUWJXbkYxT09GSkxKanZ1SGVXTS9xUUtTcTdM?=
 =?utf-8?B?SW9ZNjJGdURmamZTYU4xZ0lDdDZPVFYrdk1mbWtIcnN0Z2tCNHJJTUljREpr?=
 =?utf-8?B?cC9GWktiQUNSR2pmdkRVU3pjdC9JKzJpYkNYRWFUVVR1VVBoQnFJT1FIK0RB?=
 =?utf-8?Q?h24MDLWgLCernnRTPioeabQsK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744c25f6-07e6-4027-cae8-08dbdfc3c01b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 19:00:03.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOKKY64InJJzbKD/YtLmOInF/ApKZi8EUku6bZf5Zx3XAZFLguv/L0Bd6thjGCZe/Jkzm9M7ezayCJ9TIxoNwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4315

Hello Boris,

Addressing of some of the remaining comments:

On 11/7/2023 10:31 AM, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:35AM -0500, Michael Roth wrote:
>> +static bool early_rmptable_check(void)
>> +{
>> +	u64 rmp_base, rmp_size;
>> +
>> +	/*
>> +	 * For early BSP initialization, max_pfn won't be set up yet, wait until
>> +	 * it is set before performing the RMP table calculations.
>> +	 */
>> +	if (!max_pfn)
>> +		return true;
> 
> This already says that this is called at the wrong point during init.
> 
> Right now we have
> 
> early_identify_cpu -> early_init_amd -> early_detect_mem_encrypt
> 
> which runs only on the BSP but then early_init_amd() is called in
> init_amd() too so that it takes care of the APs too.
> 
> Which ends up doing a lot of unnecessary work on each AP in
> early_detect_mem_encrypt() like calculating the RMP size on each AP
> unnecessarily where this needs to happen exactly once.
> 
> Is there any reason why this function cannot be moved to init_amd()
> where it'll do the normal, per-AP init?
> 
> And the stuff that needs to happen once, needs to be called once too.
> 
>> +
>> +	return snp_get_rmptable_info(&rmp_base, &rmp_size);
>> +}
>> +
>>   static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>   {
>>   	u64 msr;
>> @@ -659,6 +674,9 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>   		if (!(msr & MSR_K7_HWCR_SMMLOCK))
>>   			goto clear_sev;
>>   
>> +		if (cpu_has(c, X86_FEATURE_SEV_SNP) && !early_rmptable_check())
>> +			goto clear_snp;
>> +
>>   		return;
>>   
>>   clear_all:
>> @@ -666,6 +684,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>>   clear_sev:
>>   		setup_clear_cpu_cap(X86_FEATURE_SEV);
>>   		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
>> +clear_snp:
>>   		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>>   	}
>>   }
> 
> ...
> 
>> +bool snp_get_rmptable_info(u64 *start, u64 *len)
>> +{
>> +	u64 max_rmp_pfn, calc_rmp_sz, rmp_sz, rmp_base, rmp_end;
>> +
>> +	rdmsrl(MSR_AMD64_RMP_BASE, rmp_base);
>> +	rdmsrl(MSR_AMD64_RMP_END, rmp_end);
>> +
>> +	if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
>> +		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
>> +		return false;
>> +	}
> 
> If you're masking off bits 0-12 above...
> 
>> +
>> +	if (rmp_base > rmp_end) {
> 
> ... why aren't you using the masked out vars further on?
> 
> I know, the hw will say, yeah, those bits are 0 but still. IOW, do:
> 
> 	rmp_base &= RMP_ADDR_MASK;
> 	rmp_end  &= RMP_ADDR_MASK;
> 
> after reading them.
> 
>> +		pr_err("RMP configuration not valid: base=%#llx, end=%#llx\n", rmp_base, rmp_end);
>> +		return false;
>> +	}
>> +
>> +	rmp_sz = rmp_end - rmp_base + 1;
>> +
>> +	/*
>> +	 * Calculate the amount the memory that must be reserved by the BIOS to
>> +	 * address the whole RAM, including the bookkeeping area. The RMP itself
>> +	 * must also be covered.
>> +	 */
>> +	max_rmp_pfn = max_pfn;
>> +	if (PHYS_PFN(rmp_end) > max_pfn)
>> +		max_rmp_pfn = PHYS_PFN(rmp_end);
>> +
>> +	calc_rmp_sz = (max_rmp_pfn << 4) + RMPTABLE_CPU_BOOKKEEPING_SZ;
>> +
>> +	if (calc_rmp_sz > rmp_sz) {
>> +		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
>> +		       calc_rmp_sz, rmp_sz);
>> +		return false;
>> +	}
>> +
>> +	*start = rmp_base;
>> +	*len = rmp_sz;
>> +
>> +	return true;
>> +}
>> +
>> +static __init int __snp_rmptable_init(void)
>> +{
>> +	u64 rmp_base, rmp_size;
>> +	void *rmp_start;
>> +	u64 val;
>> +
>> +	if (!snp_get_rmptable_info(&rmp_base, &rmp_size))
>> +		return 1;
>> +
>> +	pr_info("RMP table physical address [0x%016llx - 0x%016llx]\n",
> 
> That's "RMP table physical range"
> 
>> +		rmp_base, rmp_base + rmp_size - 1);
>> +
>> +	rmp_start = memremap(rmp_base, rmp_size, MEMREMAP_WB);
>> +	if (!rmp_start) {
>> +		pr_err("Failed to map RMP table addr 0x%llx size 0x%llx\n", rmp_base, rmp_size);
> 
> No need to dump rmp_base and rmp_size again here - you're dumping them
> above.
> 
>> +		return 1;
>> +	}
>> +
>> +	/*
>> +	 * Check if SEV-SNP is already enabled, this can happen in case of
>> +	 * kexec boot.
>> +	 */
>> +	rdmsrl(MSR_AMD64_SYSCFG, val);
>> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
>> +		goto skip_enable;
>> +
>> +	/* Initialize the RMP table to zero */
> 
> Again: useless comment.
> 
>> +	memset(rmp_start, 0, rmp_size);
>> +
>> +	/* Flush the caches to ensure that data is written before SNP is enabled. */
>> +	wbinvd_on_all_cpus();
>> +
>> +	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
> 
> First of all, use the APM bit name here pls: MtrrFixDramModEn.
> 
> And then, for the life of me, I can't find any mention in the APM why
> this bit is needed. Neither in "15.36.2 Enabling SEV-SNP" nor in
> "15.34.3 Enabling SEV".
> 
> Looking at the bit defintions of WrMem an RdMem - read and write
> requests get directed to system memory instead of MMIO so I guess you
> don't want to be able to write MMIO for certain physical ranges when SNP
> is enabled but it'll be good to have this properly explained instead of
> a "this must happen" information-less sentence.

This is a per-requisite for SNP_INIT as per the SNP Firmware ABI 
specifications, section 8.8.2:

 From the SNP FW ABI specs:

If INIT_RMP is 1, then the firmware ensures the following system 
requirements are met:
• SYSCFG[MemoryEncryptionModEn] must be set to 1 across all cores. (SEV 
must be
enabled.)
• SYSCFG[SecureNestedPagingEn] must be set to 1 across all cores.
• SYSCFG[VMPLEn] must be set to 1 across all cores.
• SYSCFG[MFDM] must be set to 1 across all cores.
• VM_HSAVE_PA (MSR C001_0117) must be set to 0h across all cores.
• HWCR[SmmLock] (MSR C001_0015) must be set to 1 across all cores.

So, this platform enabling code for SNP needs to ensure that these 
conditions are met before SNP_INIT is called.

> 
>> +	on_each_cpu(mfd_enable, NULL, 1);
>> +
>> +	/* Enable SNP on all CPUs. */
> 
> Useless comment.
> 
>> +	on_each_cpu(snp_enable, NULL, 1);
>> +
>> +skip_enable:
>> +	rmp_start += RMPTABLE_CPU_BOOKKEEPING_SZ;
>> +	rmp_size -= RMPTABLE_CPU_BOOKKEEPING_SZ;
>> +
>> +	rmptable_start = (struct rmpentry *)rmp_start;
>> +	rmptable_max_pfn = rmp_size / sizeof(struct rmpentry) - 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int __init snp_rmptable_init(void)
>> +{
>> +	int family, model;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>> +		return 0;
>> +
>> +	family = boot_cpu_data.x86;
>> +	model  = boot_cpu_data.x86_model;
> 
> Looks useless - just use boot_cpu_data directly below.
> 
> As mentioned here already https://lore.kernel.org/all/Y9ubi0i4Z750gdMm@zn.tnic/
> 
> And I already mentioned that for v9:
> 
> https://lore.kernel.org/r/20230621094236.GZZJLGDAicp1guNPvD@fat_crate.local
> 
> Next time I'm NAKing this patch until you incorporate all review
> comments or you give a technical reason why you disagree with them.
> 
>> +	/*
>> +	 * RMP table entry format is not architectural and it can vary by processor and
>> +	 * is defined by the per-processor PPR. Restrict SNP support on the known CPU
>> +	 * model and family for which the RMP table entry format is currently defined for.
>> +	 */
>> +	if (family != 0x19 || model > 0xaf)
>> +		goto nosnp;
>> +
>> +	if (amd_iommu_snp_enable())
>> +		goto nosnp;
>> +
>> +	if (__snp_rmptable_init())
>> +		goto nosnp;
>> +
>> +	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
>> +
>> +	return 0;
>> +
>> +nosnp:
>> +	setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>> +	return -ENOSYS;
>> +}
>> +
>> +/*
>> + * This must be called after the PCI subsystem. This is because amd_iommu_snp_enable()
>> + * is called to ensure the IOMMU supports the SEV-SNP feature, which can only be
>> + * called after subsys_initcall().
>> + *
>> + * NOTE: IOMMU is enforced by SNP to ensure that hypervisor cannot program DMA
>> + * directly into guest private memory. In case of SNP, the IOMMU ensures that
>> + * the page(s) used for DMA are hypervisor owned.
>> + */
>> +fs_initcall(snp_rmptable_init);
> 
> This looks backwards. AFAICT, the IOMMU code should call arch code to
> enable SNP at the right time, not the other way around - arch code
> calling driver code.
> 
> Especially if the SNP table enablement depends on some exact IOMMU
> init_state:
> 
>          if (init_state > IOMMU_ENABLED) {
> 		pr_err("SNP: Too late to enable SNP for IOMMU.\n");
> 
> 

This is again as per SNP_INIT requirements, that SNP support is enabled 
in the IOMMU before SNP_INIT is done. The above function 
snp_rmptable_init() only calls the IOMMU driver to enable SNP support 
when it has detected and enabled platform support for SNP.

It is not that IOMMU driver has to call the arch code to enable SNP at 
the right time but it is the other way around that once platform support 
for SNP is enabled then the IOMMU driver has to be called to enable the 
same for the IOMMU and this needs to be done before the CCP driver is 
loaded and does SNP_INIT.

Thanks,
Ashish

