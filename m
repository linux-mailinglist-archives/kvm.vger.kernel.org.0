Return-Path: <kvm+bounces-4119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F0B80DFC7
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 01:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD9611F21BE6
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 00:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C955556B8E;
	Tue, 12 Dec 2023 00:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N+hQ4/oP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC2E9B;
	Mon, 11 Dec 2023 16:00:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gd8woyYjIaphULxadrq+RDdF0ODPocd/LBlOZDs+pEotZ8p9Ynv1gIB28OaF9PITpDB3hn4jFj1JaPNeEW0Bx6TcCJOXVn3V+4pJG2q/nmbvb4FTFT7SYHLlPqkpmdVhkxM3G7FQIDsqQuIp3Q2A5UG4ibEvhJsDqra21+bpyumwQyJ1kq+0yhikbX7Sie1/ACKASqwyyoLiEh5BAVAi31pfwaY4HJtj99NeiqzQdVEHCKhR3RGEwGPNm1n1LqTBFUEA48yiaLnOH3ZwBiwqsPT4pNLOUeHKw/aDVva9Hbi/nh2OI4F6Zo1GH1Bd0UUe8gvHuIvX0H8rvrBLSMuSTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9EQEP4lvY69HxoIZg7IhOUxSzsJsQGlrk71y5GIEr/4=;
 b=OP1DEDOFnQ/ua2IJvOlP2mWpAIIlatOhCFDNKhfIRfTEQVAiMaw/ouIVDvGXB8tILXfXN7RMCKkHbuZI9t9azBhs/eKkM3e5PVZixsWVmCYJ3lRX8v0vE5DJPh+sb/uDDiK1vKXtc2nK+TguPepTbXuzwxghqbNnqCoQggiAHHY89Zw0aRKXHSOcDiXjyia1PvX+dO03TpHVWHT7ybmXT/LoOnmAMu0f7OP6VnyMuxvYMDaeMK7AnmCwKAhQzj7LpvEh0FuvTos9JFbsyM7NpBjISQYdjjYjDujQ69SlTqq1Voa0Og7hwZ1SEqUKgBQwcgp2LzSA3eEMAlgonTKRcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EQEP4lvY69HxoIZg7IhOUxSzsJsQGlrk71y5GIEr/4=;
 b=N+hQ4/oP3F3HBpl+AOoG15nDcTDabDKXMVJ6N6raT1z2T3Rm0h1sENxiGkEHXhqjmWqLHj6231BMfnBTuAaeVCxAWgwBn7/1inxhBQz37XDfLpJLC2bSDFVtNNytgyLYMEREmKv2FTL8u8AiDcdtkSeimoIat2SGFE37Col1V8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB4928.namprd12.prod.outlook.com (2603:10b6:5:1b8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Tue, 12 Dec
 2023 00:00:10 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7068.031; Tue, 12 Dec 2023
 00:00:10 +0000
Message-ID: <52916a2b-4a18-5409-0a2d-756852d847eb@amd.com>
Date: Mon, 11 Dec 2023 18:00:07 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 23/50] KVM: SEV: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
Content-Language: en-US
To: Vlastimil Babka <vbabka@suse.cz>, Michael Roth <michael.roth@amd.com>,
 kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-24-michael.roth@amd.com>
 <20e52d79-7eff-1aad-2f77-24ed7fd56fa7@suse.cz>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20e52d79-7eff-1aad-2f77-24ed7fd56fa7@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:806:23::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM6PR12MB4928:EE_
X-MS-Office365-Filtering-Correlation-Id: 89ea9c11-d60e-4e26-a7df-08dbfaa54efc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UaZugNJE722Jir9qCCYJ2TnQQ5QV1IvzG2TSPftjNAuQDJYfXNuI0Dh8OT7HUGgmbRtsu5w5BaQ/Kxi31KZifANffRXaksrRfwvzex7rpge+HuJG30/uD3KsQiVJ0eWMeUN9auX2jah+4RGe921G78JpeOt3DNA4A5hQvGsuJrhFcQpUwBA04X4nTZGKRNdFTCQg7ml3nBB2nfTiwzBvcPSbif8XPDw72l/bleDT8QsY9mxeeXprLiubdWTe3bH+RLGDALwMMb8kvHg70BqXAyvL8xzW6V4eD0WjojnlGQCtwnGBIUiG0Uze+iHZr2k+Po8OSFUHD+xu9ssoJmevDEi5EMwaXf+OB51RNC5gUcmgcUs+qEgW8LKsy4I7yKO6xZEPN7iXRyj15PydIJltUWodGoNaPx7m9nnHQ9eg0Q7vsZbXC4kn2VBxWfJzIJsfhSWHaKC1sFFdQvzk9sqyzaPCGR2aVml/CeoGWkHWq4vUjk4YHIq2RhA0Pob4/pivnfRRmLvC94cdbO0hzJ/ZV8DAJp3bmMo68x30dUzLte/LN0lt4j8bWakCcAINRKIkseV6FXfdKwwKMH81vzZST5eFgjspgKNvF2n3pJA7KOzxGGHBti2mydZDQXJT+AB4n63rq4VAq8WSrBYvI68Qjw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(136003)(396003)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(26005)(6666004)(6512007)(53546011)(7406005)(5660300002)(83380400001)(4326008)(2906002)(6506007)(41300700001)(478600001)(6486002)(8676002)(8936002)(66946007)(110136005)(316002)(66476007)(66556008)(31696002)(38100700002)(7416002)(86362001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjhzYmJMMUx4ancrMndXNE42WXh4QW5McUd4VkYwYmw0WW1Rc1VpZ1dGL2N0?=
 =?utf-8?B?ZnlrcE04dUJtSXI2Y1pjbzhNSzBvMndoRTNVTUZIZG93RDdEdVlOWjhhbXlI?=
 =?utf-8?B?UjAwem5UcVlRRXRMa0VHMU1ZVmpOMjFFcHhOaHN6RVZyanlJT09oT3dhRmNw?=
 =?utf-8?B?bW9DSSs2aUdqbmowT2wybmk1Z0xJZWJiWEJJRjhmU1FtWE04TzU2dDQ2cHk1?=
 =?utf-8?B?RkNmeDRNR2RGU1B4MjdueHNqV3NkTlcySjdKcHpiTWVnbEsyc1M0TzhsdUdK?=
 =?utf-8?B?cktVS0dlbnc5WGhUZWNTdERpQVJEdkFEa3JCSTRraWEwZGNZeWtIQnZmSXNU?=
 =?utf-8?B?WlBsM0RtelpNWFZ1eGRuR1NJZkxxUXV5TSt4VWVHbVdxc0xqOXpYVWlFbXdG?=
 =?utf-8?B?dHBNOFM3OHBTdUVsVEY3NEF5Tm1LdExCZjA2ZmUrUkdKVXk5a0NQWFI0ZHlh?=
 =?utf-8?B?clJGS29mOVNsNUZidi9TdmxQQTc3V1djbUhmSFFVUXNMQ21ZZnJkdGU1d0I0?=
 =?utf-8?B?WnltNzBGOU9EcmdmTzd4dE5wSVIweHV2L2ZLaStDVkZvNFNoYjZHbTN0VTIy?=
 =?utf-8?B?VXFETE55dFp0dmxvdFZoUng3Qmw2SEs2ZGN3bGd5ZzhzZ0ZjdEpyc3l3a3Fl?=
 =?utf-8?B?V01hSGpPd2VCRkNKWUtPSTZNV2FCbEhyQVg2cUxQZXJIbUdVNzc2T2N1bVcx?=
 =?utf-8?B?THM4MWgxMXVkQTZGR2dIdER4SVpOaXMvWEdCcVdCUG9EbTIxMVlIKzRpR3kx?=
 =?utf-8?B?ZTRGQXFZNjRYQWg3UU9GZmJQZ0RqTy9UM1czcnV3T1paSFV5VHFLbjV6QWJ2?=
 =?utf-8?B?SWwxbE9qNms4L2lFdXBaS3VUTWlKOXBDQzh2RWlyUmVSVlVENWNyWmhYZzNk?=
 =?utf-8?B?UDkwN2VJZEs1anZkTmdKOUo1R0c1KzRvYndGZzk4c2ZmdjYxblBOd0hLS21C?=
 =?utf-8?B?V3hGS2g3am15bHZ5b0ljTitpZURHNmVLakxzbTZzVjN3TTV0Z3kwalR6U1B4?=
 =?utf-8?B?T1FWaER4anIrUUM4VFFOaDY4S3FrYUxoSE9tcWVtWWliNWo2L0R1b1RucmM5?=
 =?utf-8?B?RmFrZUM4WDVHWFQ2NFpXdFJNaFNsc1dYVnFiR2w0QmVQWVREa0JVRnRlMUgr?=
 =?utf-8?B?R2tsbTgvOFZ0NjJlclY2OWRuMlczRWxTVCtrUXhQYVpjSVhOdkV3em5CSDRW?=
 =?utf-8?B?ZmE3VWp4c2IvUloxM3FOZncrcldsK2xCcUlGeGVCVUNHTWFjQzlJZytzdGZt?=
 =?utf-8?B?ZGFES1ZaNWpKNURtcEtLbGhzcEZvQmw4bFFMN1daOWd2TVVySWc3cU9lL040?=
 =?utf-8?B?aHQ1bzh1SlJzcnVrcDlydmNjV2JvRm1QajYyRWFBSDJjaXpkVXJaYVhxNlpW?=
 =?utf-8?B?Q2R1bnBqOVRWRFUzVS9oOEZhQVJ4RnZoTVhYbTFWSS9GSHRoeU1aNFVrTnpk?=
 =?utf-8?B?bU1RdFV2K0cxWVBDVkh1YU5IVmh3MTg2bHc4b2s2MFAwNTUwYllDd1lYZGRB?=
 =?utf-8?B?YWdvTUZuTk9hcVZpR21LS1ZsZWx6NEhvZ2NUMkpPQVlCLzFGSXNPd0ZDd2sx?=
 =?utf-8?B?dlQwLzRIMjB1cjFLaDV2cTFZa0F6aDJSNVUwUnZLSkx2REIwbU1abUg0OERN?=
 =?utf-8?B?ZkRBc3l3eDNneVRsNkcyTW9BQ08wT1RjdUYzaWkvQ1FCd1lIWnBuODdNajlT?=
 =?utf-8?B?UnZvRDFuRHJjYVdSU1JlZXBoSm5UWVRjRVVaS0ZFdWJmaENya21QUkNYbDNK?=
 =?utf-8?B?UlZEdURJaTAxY3M4Z2JZYURyNWdLSng4SW9aNmNHR1BoY2o1Vy9ndGVOaUU3?=
 =?utf-8?B?RW91TmlHWHQrdk5tNGJNV04vMHI2aitCeUFIZ0RJWDV5SFhlcU13MjlnZVZT?=
 =?utf-8?B?N3N1UFN2SHhDU3lFOHhGeTVsZmVKRlJmd1ZsQXRNQnFLc3VvZjAvK3U2N1V2?=
 =?utf-8?B?UzFUdnpqOFFUL2pQR1RuTUszaDVHcDBIQmlvb0JLQktJcUpCZDBIMWNoNGgx?=
 =?utf-8?B?SXdPMmRhMm9WVXZnOUZKcTltSjNnUldDN3Vka29nRXJtaStHSDRiMXVOREJI?=
 =?utf-8?B?WnFFRDhNS1ViVG9CWHRYc0VDOG5XYm1BcitOcWo4aXZzaVJkS0x4RG5nQ2hC?=
 =?utf-8?Q?81S7ftZwClPJCNQBOF7gQS566?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ea9c11-d60e-4e26-a7df-08dbfaa54efc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 00:00:10.6042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVfjmpgnYX2rB1B8xZizwVA7pLKhmzMPEzXaENa0GmAxtDMPy5YAZxTmiByUgK0OQFhp88XmLaKHXAbdVSO1TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4928

Hello Vlastimil,

On 12/11/2023 7:24 AM, Vlastimil Babka wrote:
> On 10/16/23 15:27, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> Implement a workaround for an SNP erratum where the CPU will incorrectly
>> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
>> RMP entry of a VMCB, VMSA or AVIC backing page.
>>
>> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
>> backing pages as "in-use" via a reserved bit in the corresponding RMP
>> entry after a successful VMRUN. This is done for _all_ VMs, not just
>> SNP-Active VMs.
>>
>> If the hypervisor accesses an in-use page through a writable
>> translation, the CPU will throw an RMP violation #PF. On early SNP
>> hardware, if an in-use page is 2mb aligned and software accesses any
>> part of the associated 2mb region with a hupage, the CPU will
>> incorrectly treat the entire 2mb region as in-use and signal a spurious
>> RMP violation #PF.
>>
>> The recommended is to not use the hugepage for the VMCB, VMSA or
>> AVIC backing page for similar reasons. Add a generic allocator that will
>> ensure that the page returns is not hugepage (2mb or 1gb) and is safe to
> 
> This is a bit confusing wording as we are not avoiding "using a
> hugepage" but AFAIU, avoiding using a (4k) page that has a hugepage
> aligned physical address, right?

Yes.

> 
>> be used when SEV-SNP is enabled. Also implement similar handling for the
>> VMCB/VMSA pages of nested guests.
>>
>> Co-developed-by: Marc Orr <marcorr@google.com>
>> Signed-off-by: Marc Orr <marcorr@google.com>
>> Reported-by: Alper Gun <alpergun@google.com> # for nested VMSA case
>> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> [mdr: squash in nested guest handling from Ashish]
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
> 
> <snip>
> 
>> +
>> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long pfn;
>> +	struct page *p;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>> +
>> +	/*
>> +	 * Allocate an SNP safe page to workaround the SNP erratum where
>> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
>> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
>> +	 * or AVIC backing page. The recommeded workaround is to not use the
>> +	 * hugepage.
> 
> Same here "not use the hugepage"
> 
>> +	 *
>> +	 * Allocate one extra page, use a page which is not 2mb aligned
>> +	 * and free the other.
> 
> This makes more sense.
> 
>> +	 */
>> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
>> +	if (!p)
>> +		return NULL;
>> +
>> +	split_page(p, 1);
> > Yeah I think that's a sensible use of split_page(), as we don't have
> support for forcefully non-aligned allocations or specific "page
> coloring" in the page allocator.

Yes, using split_page() allows us to free the additionally allocated 
page individually.

Thanks,
Ashish

> So even with my wording concerns:
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

