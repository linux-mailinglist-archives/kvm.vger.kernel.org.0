Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674F67ABA04
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 21:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbjIVT1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 15:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjIVT1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 15:27:33 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8391BAC
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 12:27:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfEMr4lD9ZQUbEGPjgqPLncJPJ0BPp8bKj6VfHTjwAkAoEQRIH6khFpSCNJZ0Vnr+ORPC3AUN67ztygaFCC3c3PGGUO5cwHEYRRg+entstiv6ZanbkB9zbnhndMCl9jzTGub5J0kurs8FfKCo2rIsy3yHjnMCLMkb4sfBC2ly3b2G1PGoObMWSZQkPkQL81q3vaPeLU0j4gGcXUmCsCsIGIZcPmA08F8s/nrLTEEjbeO23G2NWYdtbwuNWvLYxjeNLYH8TZwoqmEAVuk4iQ6xKcQGoyFHr5NrJki5q5a0LvefBfE9V/bQicS7wOdI3s9PsvLs5gJLMlUA7z3wmdZtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNhFc674AmLcsvot7tBxU43L1lqoXek5ScxrNjy7w9Y=;
 b=lAIRsrdCtJ2SNwHjqlVpJWHOjdziJ+jRSPhsiy0ZmsdGPpalRKyoZNRBk+90bcP98OpEYs+qP9QYZJV0+iQgEKPC9azkr+vkRB+eNm+MrAy83b3LqW7gJ1n+EEsNqLUvltuTXXUJF6gu09afV/PP/TAzqwiI0+tieND880EaYvu6CS/OkMY8gu5vFvOYl/SIlWJ9D4EAeiTVNi/aI/wJAx5FaqJyzra+SsXaBMg2DETSx3afkQEdg1gvPuBjdtVjoFwP6Xs8p9Oigkeb5kE7dsZ7RhpsfiEh48EqkJGdXcW6pQZ5m9xGiih6445gT2XAHFluaibHGMDBFxcgnwkT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNhFc674AmLcsvot7tBxU43L1lqoXek5ScxrNjy7w9Y=;
 b=0Vfg85yPk3MZoTg8h3lkO2UjVSKexCGV7sUl6BsfDInHHrfGL7FNNSbj1eUEIxectbD9GrvsQyVwaTotYX5OGathBpQUA5bVqJHRlC5j8dyejk/QW1QcpY93yYKfJ8qJPTO7JKbSxp0NqH6n9kVLp1sdkg4eMVz+pqhEnPC/2NI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH7PR12MB7162.namprd12.prod.outlook.com (2603:10b6:510:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 19:27:23 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::fbfe:ec9c:b106:437e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::fbfe:ec9c:b106:437e%5]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 19:27:23 +0000
Message-ID: <69d49658-07ca-e7e5-df2b-aec75f6652ff@amd.com>
Date:   Fri, 22 Sep 2023 14:27:18 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v4 19/21] i386: Use offsets get NumSharingCache for
 CPUID[0x8000001D].EAX[bits 25:14]
Content-Language: en-US
To:     Zhao Liu <zhao1.liu@linux.intel.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
 <20230914072159.1177582-20-zhao1.liu@linux.intel.com>
From:   "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <20230914072159.1177582-20-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0024.namprd05.prod.outlook.com
 (2603:10b6:803:40::37) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH7PR12MB7162:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fb27723-b1b7-4b50-fa2b-08dbbba1f264
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMhR67t4hO1zujfNXzDApHk7+zwZ0nT0Dx6i2OOpOSXRek8noj4awPvOguwBQuRRrx3Wzi/AhPI6Xdtm/smYmjefI3UWlTS1QmPelo3ElcPRiw6Z5ixq0Tw8PgmRlPyIlTsSe133BHf524hm+W/A9fWN2dfIyrXtQFz76sWVSrRXcBkISOojQdxmfEKUdhY4BIOM3M0KHLE3F5FSS3YmGmzaLU6L+NaMPcQEMn2k7O6JTq+8GNM3SUFFKhlWTvq23LW2+BMp/nbZpmP4KfRbVh6w5yS1ck8FzYgEcNwUDkLFn5qiFOf8sQMPipaBUKOj16bUz37MZ6zJDajd8L6SjVrIq5wFtppnjKAa90SGMXcdiaJbwcTLB6Lh3KfJ1xGhtLI4GgsXjjMzMveECDsJorANY5/vkrDOPo/p+jaJer+nKwQo+M2gZNYRk6hLvISUWx7kvK1e/CBwCGGUEdEiMkRX6pTCTXfV8FCTvakuKYYFv2QyIOC+GiRjzpw504/cvbJfsn1JGpMkXlIe7YljjrIapBOEO/m70LOBPg87z19jusIZRsb9qmKA8wZgIqIkQMhiKi/bqXAUagybQZ3Y5mr5AHtbwer1WZZyQlhzy93u5Vt6Vcg8j1b9kHb094X8ZvIg6pqQ7E+BZyoaR+UdPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(366004)(396003)(186009)(1800799009)(451199024)(5660300002)(7416002)(2906002)(54906003)(66556008)(66476007)(66946007)(316002)(110136005)(8676002)(4326008)(8936002)(41300700001)(36756003)(31696002)(6666004)(31686004)(53546011)(6506007)(478600001)(26005)(2616005)(83380400001)(6512007)(38100700002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmhTOVRqaTczTTJxbWJMeHRqaEpKT3I3SUMwbjJET0tvYnUxREM2a0lFbGl2?=
 =?utf-8?B?VnZvNDdLcGtUcGd2cmp3SWVRRjJnakkzR1BiM1hJZEpMSWY2VVN5bmVZS2ty?=
 =?utf-8?B?VnE4aFFSaURnczVyYVZ0S2hXNU5ra3EwUE5OdlVpQTJiSE5uUFNhN1lTL2FZ?=
 =?utf-8?B?MmFObThmYmxvSHhKZWhXR2I4VnluMUpyNmtVRTg5TjNaZ3VPYTBRYkx1Y2pl?=
 =?utf-8?B?eEhYMThGWGVEejB2SHlwMVJyV2dKalg5ZkpscTJVMm9wK2NSTVNnd08vRitV?=
 =?utf-8?B?TTRETDduTXZMRU93eXYxVGwxQmdSdXhBQTNwZnpQS2Y4VDFNVEx0bFhjMFBT?=
 =?utf-8?B?dUtwRktLTlBiNkg4aEFsNHVISEMyNFRQcmRDaXZGdEtWQ0RxdUxyd3k4ai9t?=
 =?utf-8?B?dEJBQXpZRVhrazlkOXBSWVdRelJqLzRXZGJrU3dPK0JVSDRCa3hXWkhoby9W?=
 =?utf-8?B?VlFzbGx2R1FDT01iWWhpeXhyWVFLMmxPd0NNdUcyNXE0YWVaMzgvSFRNL0do?=
 =?utf-8?B?emljTWlaYXN2dlBPVHBlRm1hc3ZDUHB6dDJuaVZKdTBZUkNoemx1aVJTMHVv?=
 =?utf-8?B?WVVvbVlwUkpOSE1oa1l3OUhnMDRLSzliRkJKa0FTa2dGR252YTZBTkdZaW9w?=
 =?utf-8?B?djZPdkN4ZjQ4Vm5LaVNYRllZekgvK0gvTnBRdWxqOGw1TGNNV0FIcXZ2SmNl?=
 =?utf-8?B?MjIwRnVleEgxb09CYWpka2llSjUzdzIrVFhYN3JUZmNnaHh1d0lWNFJ1V0I0?=
 =?utf-8?B?Vjk5KzErNnpIWThocjErWVBaRFU1TUMzYmJDemlmMlBHclp4Uytma0ZnR01T?=
 =?utf-8?B?UGNaaERYdWxzV1NWYWdiY2NyZHlsb2EyaDNlS0NtaGZvTEp0ekV4MTZnVTlD?=
 =?utf-8?B?b1BnTi8zS2pOSU1XM0ZQMVVsWDZYbmR3bm4xZzVpTEc4K0V4ZWlwbEU2cEpo?=
 =?utf-8?B?M2lkUDlNeU82RkpCT1Bmd2krRGZwYnh2ZWtOeTY2RzhYcEFVTzh2UWtyUVA2?=
 =?utf-8?B?bXNUR0RlZnNZOGlQdjBXTFBDVUxmbHVuRENLWUJERTZQWjBQNkcwcHJSWVpa?=
 =?utf-8?B?VWw4SjNFdWhOVzJ0bGd5SHlXVk4wQTJmRnIwVXdsbFIzd3pNTml3cU8xL1or?=
 =?utf-8?B?VktwZk5LRmJvcy91Y2hLNnBUak5yck9qck9DNThpanZFbmh2WDlVcVFQK2dU?=
 =?utf-8?B?YmJqWkNTWmZPU0FHWnQxcnhDWkwzT1ZKVUV0eDA2WW9peHY3RkNqUHRyelZS?=
 =?utf-8?B?WmdDZkVteklkTnYvQUVyVWRseEJzbmwxTXFROGhFUTlNVDhjWVZRcTNGdkJo?=
 =?utf-8?B?TXFLWWdUOHp4V0dKOTc3Z3hhdlcxVUVSOStkYnVpV2l2dk1wR2VqT3loVnNX?=
 =?utf-8?B?dnJMbFlOR2FCQm5vR2lVN0lxZWlvTDJmRlhId1FHWHBlc0R3VHZCd3B1M201?=
 =?utf-8?B?ZW1ZZC8vZnNKZG9PN3dPQnpuL1JXK1d2QVBlNHdKTjdLZGxqbk9VUE9PUnk5?=
 =?utf-8?B?OFoxQ3BKVFo5eU9Ta2tXREoyTzJ2d0RjUWZKVDU4ODBUQTBwS2gveTlQMTg0?=
 =?utf-8?B?K1pXcEFyVE4zWi9Nb3BoUVJmL2YveVNZZjRaenA3eVRxN2x3eXdtSzA0VDQ5?=
 =?utf-8?B?TklBYkVvbGwzZU0xTDNIbEZRV3RlSHViTWlUMjNSVFdDaXdiODdYSXNRWVIr?=
 =?utf-8?B?OW1jblVONWdqSVBlM3U2c2Vmc3RhZC93azhEY2p2WUJPeVhKY3JoazVreW5y?=
 =?utf-8?B?L0piczBSZStVVk9ISTNHaGV5dXJpRkM0M1d3UVIvU0pBSWliNCs0bnpSbnRM?=
 =?utf-8?B?MnljY3ZSL2MybXRHUGViR0ZiZzdXUGd3K01GWmFuR0txYTZxeGdIUVM5bmJD?=
 =?utf-8?B?ZzZpQWNHZU52NFFoaFlVaFIzTDJnWHdJT2ZWTzhrazNzVG9kODg4Y2IxSEJl?=
 =?utf-8?B?NFVGSG5WVlA4ZUF4eU9Eclk1STVXb3VHZ2FORVVPRW9NeWdjYzRaNG9yRHM0?=
 =?utf-8?B?bEgxSUpBUWxjM2dZakFGdjUxZU5acGJWaU1Cb3ExNzN2ajVrZi96MWtNcm0z?=
 =?utf-8?B?VlIzRG9PZzh0amJ0cG1qYzBrcFE5MlAweTFqT21KSTVrYndCY0prb2l1Rmxw?=
 =?utf-8?Q?e1OA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb27723-b1b7-4b50-fa2b-08dbbba1f264
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 19:27:23.5483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0mLLyVrmlJTIh8sq3rRCol+94eKKP9LzT6x4UvIX5wSXD0cYhDhksrtqGYOW/oG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7162
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/14/2023 2:21 AM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
>
> The commit 8f4202fb1080 ("i386: Populate AMD Processor Cache Information
> for cpuid 0x8000001D") adds the cache topology for AMD CPU by encoding
> the number of sharing threads directly.
>
>  From AMD's APM, NumSharingCache (CPUID[0x8000001D].EAX[bits 25:14])
> means [1]:
>
> The number of logical processors sharing this cache is the value of
> this field incremented by 1. To determine which logical processors are
> sharing a cache, determine a Share Id for each processor as follows:
>
> ShareId = LocalApicId >> log2(NumSharingCache+1)
>
> Logical processors with the same ShareId then share a cache. If
> NumSharingCache+1 is not a power of two, round it up to the next power
> of two.
>
>  From the description above, the calculation of this field should be same
> as CPUID[4].EAX[bits 25:14] for Intel CPUs. So also use the offsets of
> APIC ID to calculate this field.
>
> [1]: APM, vol.3, appendix.E.4.15 Function 8000_001Dh--Cache Topology
>       Information
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
> ---
> Changes since v3:
>   * Rewrite the subject. (Babu)
>   * Delete the original "comment/help" expression, as this behavior is
>     confirmed for AMD CPUs. (Babu)
>   * Rename "num_apic_ids" (v3) to "num_sharing_cache" to match spec
>     definition. (Babu)
>
> Changes since v1:
>   * Rename "l3_threads" to "num_apic_ids" in
>     encode_cache_cpuid8000001d(). (Yanan)
>   * Add the description of the original commit and add Cc.
> ---
>   target/i386/cpu.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 5d066107d6ce..bc28c59df089 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -482,7 +482,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>                                          uint32_t *eax, uint32_t *ebx,
>                                          uint32_t *ecx, uint32_t *edx)
>   {
> -    uint32_t l3_threads;
> +    uint32_t num_sharing_cache;
>       assert(cache->size == cache->line_size * cache->associativity *
>                             cache->partitions * cache->sets);
>   
> @@ -491,13 +491,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>   
>       /* L3 is shared among multiple cores */
>       if (cache->level == 3) {
> -        l3_threads = topo_info->modules_per_die *
> -                     topo_info->cores_per_module *
> -                     topo_info->threads_per_core;
> -        *eax |= (l3_threads - 1) << 14;
> +        num_sharing_cache = 1 << apicid_die_offset(topo_info);
>       } else {
> -        *eax |= ((topo_info->threads_per_core - 1) << 14);
> +        num_sharing_cache = 1 << apicid_core_offset(topo_info);
>       }
> +    *eax |= (num_sharing_cache - 1) << 14;
>   
>       assert(cache->line_size > 0);
>       assert(cache->partitions > 0);
