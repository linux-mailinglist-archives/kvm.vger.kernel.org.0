Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0AE613E17
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 20:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiJaTSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 15:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJaTSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 15:18:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE85E11170;
        Mon, 31 Oct 2022 12:18:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnVtJkVj2dL11sZvSXLDNppyhL6pVtvlctHZJf/LRycIyo0dT6UWeZTNFVNJ6wdhpiBUMQ/SoiskNgikVtGNfK1UF2162qcQtuNBiIPyPHkGGpsLgLlroccU8q7f0NGOfCId89umX+A7AJWjsoPVyWPRUM6YWKDhEFKNLolvvQezaaZU5QY4i5CpYAF7gjOM98NDSr83IgmAQwzm69PXYjrTm0hDwf8Oke4yrUXbX5Fw0Ef9Ob+bJoojbwLqQeCj2ukivDKLOyr86H7tlHXulVbFIOup72Ax9mPdWu+m3GSBqT4abbh5Co5A1s/Oqg2eTXYvl99lO4xd5szsyqcTZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwR5DHV5724w+bSriLtxdLtq28JJUeAHkVhYS+5MEmI=;
 b=nFnPJ59vh4ZSFDZTCE9l4sAU7A5WXzRupu2qXJe2pp1WZ3k+daHtOMndt0kdf0ilyv1cEPhE1Kz2tiMknmqGZi4BZbVeOLoK5KL8iwp6TDTPHHWD8NJvQeqF506Rf04qyHFrvaFmYS3cTRCEdza9CsaFOz7AcHa87SbE3JpRu9eKb/xuitOjoUihz7vHIeSSmV27CQMoxbYzx/jJ4SwhsibRCE3d/tqG0ue4laOzmaPufdktiDgtxVguwAySodo68ErUN3KNHAhNV61aPtiW8MvprTEuItv5hjsK2lwdqutw/bk0BBelCzQ2RkLu+yBlre7nTgJDHcW7JMBS1W6I3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwR5DHV5724w+bSriLtxdLtq28JJUeAHkVhYS+5MEmI=;
 b=fDTAhO1sCg3ipqo44+MLTH9TN4huFTkl2XQI8U2Up5pr+UFmT64eBMMwnP5bdSKjO4m3CrrynyRBDZzGf5oj24x8GMqSw0KrbMgSJitL2ayWVM4J81PAGK+gT5MBdvcL9PQfpZcgwdFOGVweWkoqHUWs2JynaDhXqVreqUzhblg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11) by MN0PR12MB6320.namprd12.prod.outlook.com
 (2603:10b6:208:3d3::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 19:18:41 +0000
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::a035:7550:7327:3d10]) by CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::a035:7550:7327:3d10%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 19:18:41 +0000
Message-ID: <15374225-f136-4c42-cf6c-f587b654a526@amd.com>
Date:   Mon, 31 Oct 2022 20:18:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH kernel v2] swiotlb: Half the size if allocation failed
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20221031081327.47089-1-aik@amd.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20221031081327.47089-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P193CA0100.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::41) To CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0181:EE_|MN0PR12MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: f085c8c9-1be1-4178-737b-08dabb74b8a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZbXiXTVdd3vKzmX1lg9+GblnuzGOX6olqoD7qaJqMk7o7NhPpLqeoGylCq8XqYFTq8ZmZa7ezPvclGEzP8httDHT2HS/PZAL1TPOa3uXZIB7RV08ucrFAuDkI4+8avDLv+Al21xzJARpbAhBm4+opm29BzalxnpAr0TGuoG3Tz9496gojWQW3KgOOC1Z0M1ppNUzb2YRPelKaj7IiFHxdJ9NSLKU2/Y5OvUn6K6yEN2PwP/jdpJQSMIMdykzQP+IiAVQmjHmaOW/AUPRlTV1R3ywhMpQR3MGAMikYpAdTYvDI9Opnvz+Dzk6bk9lWeTknxgVamhY9T6BRxMC2LSCPJz5H9ACT7XkqT1UqIA6UFaJD4QWAyDleH3Qh006rtCqHq3XPA5r+/HbH4CP+A1PcfYxVUyMoZy+n4N2dsCA9J31OcDFjRBpv6RtzomiofLgpHA6uqqqTCYv/PFEZ9MWTxCzjCFe01ojT/ipI8Gyi9FmaYnzW4D0aieJplhZFrMmGN8EF+Ba6TiaEljeJ5i5sLefM3YGF+V1ksjGyyMr5v8ij8ijvLvGjH2h1Q5UnLKZwb3tpygd/Mo9QAtA0FnkeiIYTZbBxxLV2C8j43HRgvB6EIG3C/dVns9GGCD7051YqssEgOCNMJukIiCMmtT/KAgax/2vygNFF1OXCXn2+lwn2NERB/kNyKRXXgJCMmJFc5iLWCtzuRY5GcoqsmcxJTrWgxbdsUgTWS/PPv9Mu85HNNtoGEU9q6pOEnbHr0nbAbv1DuLZAbolEhXj7Cj2/R0QU43eLVzH4IHp5uCND6w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1201MB0181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199015)(26005)(6512007)(2616005)(53546011)(6666004)(478600001)(6506007)(83380400001)(186003)(2906002)(54906003)(316002)(6486002)(8676002)(66476007)(66556008)(66946007)(8936002)(4326008)(5660300002)(41300700001)(31696002)(86362001)(36756003)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3diZGZBQkFDMHNaaW5nRW15QlBwWG5wQTduZ3A2ME9yOWxhSXRxSlFjblF5?=
 =?utf-8?B?Q1c5TlJXQVpLVDR4RkZlSWNFc256MS91dDVFcTcxQnpGWWhqZFBtaGErMm1k?=
 =?utf-8?B?dFpLS0M0UkF6cVFkc2FobFlXWTFWdTFNSFArU2F0OWxYZjkwVVVGU092bklK?=
 =?utf-8?B?dlR0ajFCNWFJRUZ4NjJuOWZyN0w4L3JKMzN0VzFXNTZmYy9xSit4WnBLby9z?=
 =?utf-8?B?a2hERHBnQnpoUnZJZTh2cVV4MWlLY3phTjVhSkNyN1hzMDBES2tyRjN1Mk96?=
 =?utf-8?B?N043cXVxd093NUVVZmREcklvYXN4UE1ZTncwMThYTGtuSEtCS043ZEI1U0hn?=
 =?utf-8?B?TjV4L3hiSWRyV0tjSkxuWFpNb0JYWTVkdUIrZ2lpSmZ3dmlZbE1SSzRzbVZH?=
 =?utf-8?B?N0Vsa1MvTkpDdm1GT0cwY1Q4dEdaci95SUY4VDF0YmYvUWU0S01LY3V6MUM5?=
 =?utf-8?B?WHZTNFBqdTZySy9vTCt0dElpZTB6SXRIRXJOc0pXMWE5WkZRNDFyL1QrZ2xw?=
 =?utf-8?B?eUVqN0VKWVRmbHU1NTUxTFJGNkpOSWsrVE5oZjJNMnM0WW16QkVCRTNIUlNC?=
 =?utf-8?B?ZUlqc3hqT1NjeWN2ZnBFemdwV0RUYjJULzNod3FBVm05Y2hYd0V0VzBtTU5T?=
 =?utf-8?B?bndBNSt1MEZUQ0ZoTDFPcnBmV2hPY1orVFYvTTJEVDBxWTNtbTVTQkg4R3Zo?=
 =?utf-8?B?bVlKU0pDQ01RMWl6bm1hVTNlVUZRYmY4ZjV1OU93cWNhVVhaeEF3bmNydXhN?=
 =?utf-8?B?YVV6elhGaXZpVUxSVUpaSk1VbFZkaXJNMExWZXlpK2MyMEdEdnVFQzQ2UFFY?=
 =?utf-8?B?NjhNZTkwQjF5N1ZhK1dXaWlML1VMNkNjYzFNV3VTOUF3aTRqRC9KL3VUaVlM?=
 =?utf-8?B?bGJaTDNVSlBYZUMvMStYOEYxUXpCTHJnNGJYcUFBTEEyNmtIMVBEVFdSSERp?=
 =?utf-8?B?YVZvN3JNRVdYRzZXanQ3cEtVVGErMW1zbWp3bTZZREtpWEcwUHdpRVRkMWF1?=
 =?utf-8?B?QVhqdTZFdEM2WTJ2WkhOWVdqcVRJdEVoRWd2TkhqWGw5cVlQTjJxTHJYTEll?=
 =?utf-8?B?OXZkcXVMYVQwK1pOM3haSTBYRG4wSVdpRi9lYUdjaHB5VXF3cG1nYldlcmRo?=
 =?utf-8?B?N3pmbjZ2Rk13RUI4VmwyaTZkYzJ1aFhZL1J5OS8weEM5SjB6Q3VjTGp2cVFl?=
 =?utf-8?B?T1NGZHppbUNQYU54eVk4M3ZmNlpMSFlTNFl1OWpiVVZNNTlUZlJDcktHNjFE?=
 =?utf-8?B?aStlV3JZYUhLNndwMEUvWmg4U1JOMVh1U2NaNi9DQmljSU85S0RDVFMzTThJ?=
 =?utf-8?B?RFNucXIrVXAveFFpajhnYUpWemV1bTFhVVNMVndFamdvajN3VjFnQkdiRzUv?=
 =?utf-8?B?TkZoNytvQ3YvTTdOeUNpVXN1OERGRUowL24yRFllMWN1OVhycEw1RlIwZzRn?=
 =?utf-8?B?M1hHYUxtc3VHdjJJTTh6NkdhRXZheGdkSVVhYVRDSlF2SzIwZTgzZ0FxVmVn?=
 =?utf-8?B?ZnZ5aVdra0NXckxHN0tSWStqc2ZpdVlWZU9FNDJRQm1maDhOWkluTGpjRUg5?=
 =?utf-8?B?OGpSQzlzS2c3S3RwOW92Q2xqdllVd2kzaUNVTWRxK1ZRMVVpa0Vqd2RaUTBy?=
 =?utf-8?B?TnROZzJRWnJ2VWQyM2J0aDNyYi9hamdZMm1ZK09nMEo2Z2tyNXFGSDZ3blZO?=
 =?utf-8?B?OEdERjhSSGp5Q3NSSHhFcFg3UmpKeGwxRktrZjQxR085MG12Z0JITkIySXhR?=
 =?utf-8?B?VDFxSk4rdW9GREhNbk5IazVDNHhKVTlVaUduSEJFLzRhNFJRZS9LK1liN0F6?=
 =?utf-8?B?eWxoWFVvMnJTemZzZ0hVWk9scEZjeXY5blMySWk3RjBLMmpOMld3OGs3VTRL?=
 =?utf-8?B?VVc3cW84Ym9reWtmbjVPTzJkdXBna0RoTGtoY3Z1dytSMHBSaDd6ZEZJRkdE?=
 =?utf-8?B?UTJ5aGVYWlFYQzFxUDVRQ3BOTzVIVG5BMjdPT1BzbmtsSHA5WGdUUDltVnhs?=
 =?utf-8?B?U1IyVFpscDJodWhrZVF1NFlvL3g1TXlzdzg0NEdlRkNBL0F2ZTFyUnl0d0ox?=
 =?utf-8?B?NktvSFNRYll5VmRkNlZTYUIrREpCSnVtNDArcWRlMHBLT0lPby9EUmczRUlr?=
 =?utf-8?Q?WodwWNs4xP+uGl5xv8dY6Fjhe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f085c8c9-1be1-4178-737b-08dabb74b8a4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1201MB0181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 19:18:41.6763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/yWQ2zwRzOo4qbaY9U5TrYuOqSsG1A6U7DWAAfGMvrTN4htAKe35QBv9bg62e3DRR8T+wOdo7ci6cVxxcPExg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6320
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/31/2022 9:13 AM, Alexey Kardashevskiy wrote:
> At the moment the AMD encrypted platform reserves 6% of RAM for SWIOTLB
> or 1GB, whichever is less. However it is possible that there is no block
> big enough in the low memory which make SWIOTLB allocation fail and
> the kernel continues without DMA. In such case a VM hangs on DMA.
> 
> This moves alloc+remap to a helper and calls it from a loop where
> the size is halved on each iteration.
> 
> This updates default_nslabs on successful allocation which looks like
> an oversight as not doing so should have broken callers of
> swiotlb_size_or_default().
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> --
> Changes:
> v2:
> * moved alloc+remap to a helper as suggested
> * removed "x86" and "amd" from subj
> 
> --
> I hit the problem with
> QEMU's "-m 16819M" where SWIOTLB was adjusted to
> 0x7e200 == 1,058,013,184 (slightly less than 1GB) while
> 0x7e180 still worked.
> 
> With guest errors enabled, there are many unassigned accesses from
> virtio.
> ---
>   kernel/dma/swiotlb.c | 66 +++++++++++++++++++++++++++-----------------
>   1 file changed, 41 insertions(+), 25 deletions(-)
> 
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 339a990554e7..53fc6e7d3aa5 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -300,6 +300,36 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>   	return;
>   }
>   
> +static void *swiotlb_memblock_alloc(unsigned long nslabs, unsigned int flags,
> +				    int (*remap)(void *tlb, unsigned long nslabs))
> +{
> +	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
> +	void *tlb;
> +
> +	/*
> +	 * By default allocate the bounce buffer memory from low memory, but
> +	 * allow to pick a location everywhere for hypervisors with guest
> +	 * memory encryption.
> +	 */
> +	if (flags & SWIOTLB_ANY)
> +		tlb = memblock_alloc(bytes, PAGE_SIZE);
> +	else
> +		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
> +
> +	if (!tlb) {
> +		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n", __func__, bytes);
> +		return NULL;
> +	}
> +
> +	if (remap && remap(tlb, nslabs) < 0) {
> +		memblock_free(tlb, PAGE_ALIGN(bytes));
> +		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
> +		return NULL;
> +	}
> +
> +	return tlb;
> +}
> +
>   /*
>    * Statically reserve bounce buffer space and initialize bounce buffer data
>    * structures for the software IO TLB used to implement the DMA API.
> @@ -310,7 +340,6 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
>   	struct io_tlb_mem *mem = &io_tlb_default_mem;
>   	unsigned long nslabs;
>   	size_t alloc_size;
> -	size_t bytes;
>   	void *tlb;
>   
>   	if (!addressing_limit && !swiotlb_force_bounce)
> @@ -325,32 +354,19 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
>   	if (!default_nareas)
>   		swiotlb_adjust_nareas(num_possible_cpus());
>   
> -	nslabs = default_nslabs;
> -	/*
> -	 * By default allocate the bounce buffer memory from low memory, but
> -	 * allow to pick a location everywhere for hypervisors with guest
> -	 * memory encryption.
> -	 */
> -retry:
> -	bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
> -	if (flags & SWIOTLB_ANY)
> -		tlb = memblock_alloc(bytes, PAGE_SIZE);
> -	else
> -		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
> -	if (!tlb) {
> -		pr_warn("%s: failed to allocate tlb structure\n", __func__);
> -		return;
> -	}
> -
> -	if (remap && remap(tlb, nslabs) < 0) {
> -		memblock_free(tlb, PAGE_ALIGN(bytes));
> -
> +	for (nslabs = default_nslabs;; ) {
> +		tlb = swiotlb_memblock_alloc(nslabs, flags, remap);
> +		if (tlb)
> +			break;
> +		if (nslabs <= IO_TLB_MIN_SLABS)
> +			return;
>   		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
> -		if (nslabs >= IO_TLB_MIN_SLABS)
> -			goto retry;
> +	}
>   
> -		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
> -		return;
> +	if (default_nslabs != nslabs) {
> +		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
> +			default_nslabs, nslabs);
> +		default_nslabs = nslabs;
>   	}
>   
>   	alloc_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), nslabs));

With memblock contiguous allocation under 4G memory fallback to lower 
order allocation, seems to fix the inconsistent state issue if the 
buffer is not at all allocated.

Feel free to add:
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
