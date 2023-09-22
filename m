Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4801A7AB57C
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjIVQGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjIVQGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:06:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252BF99
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=np/vBuLebS0B6ewtZimWvBMUVKzhD73oO4P5ZaG6svEnk2Jn96iP73nZ0h8UyEpe9iaiSa+fMAWTQ+gMe/IATx0+VY579HqCQJXnhZYWtIq1KsWLwyFH8PJJVBxlaTqt8BQYXXOrV3shvSRQMBZfeA8U596ZBYaHodOFpw0rPI9HGHd8G92vg+MyBKtBgeWgzjHTZKmDithb0/kpX1qjM6GqEtn4tBU7foxY2N742215tM2TmsRPNjFdsGZ2Uu563rgjLqJ7/dtJjhJ1v+NGrj6iadVpXB5fuQNS3NnKsKXtoq6m1G5W5uoigIMpbQHFrUX7bf19cA78HSjOeDnICQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGVBz0LuLqyIQ98NqGaxFeDPnLimx3SHocxOjpcGo4Y=;
 b=lCpOxcy2T4w/fKT5P8j5msO1HJ0r+jAK1nETmJFw4RRPuiescQvc2XIREBUK8sBPfItRCUumo9FJAhy9X5m2h0KbPRZKLEDqk+aGEz4nf6o64cMTC41dQcKD4+CVXZ0RyxxMbO/itzyFORH+VAXx8ofSQtHQKqwRv9r/try6hQJOVCuw9wVoj0yquXaCAHoJ1kJ/ggFp951l5/qQYcFdqzUmhYAiGinA7we7AVmyZm0Xcw6E/SZbBgx3az2+XYLQAFta5atQFaiQU+GpzW48Xfi4ARfX36v2CDZ07+mIJ14Kz7FXc2tg0kUh+L+/NAAO9FrYS1VjiNam67n6AEcRAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGVBz0LuLqyIQ98NqGaxFeDPnLimx3SHocxOjpcGo4Y=;
 b=JZcux8ckagM3PVXVvYxT+IQJiNkhJdNgMS7xmW91LQIUT9HHE7643BM79sMkBw2NEX6kicpVNfPeGD7WIXKmly73sVWLtR+ZW+/6Sfx3SdtaSNKH9/rPJkmpENktrrmLYJz+xLkhGwtVBQS6E/plQehV+wGiZy2utJzGrYmW7QU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW3PR12MB4507.namprd12.prod.outlook.com (2603:10b6:303:2c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 16:06:02 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::fbfe:ec9c:b106:437e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::fbfe:ec9c:b106:437e%5]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 16:06:02 +0000
Message-ID: <316dfbed-5b67-4140-8502-d0f32dec5162@amd.com>
Date:   Fri, 22 Sep 2023 11:05:59 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v4 01/21] i386: Fix comment style in topology.h
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
 <20230914072159.1177582-2-zhao1.liu@linux.intel.com>
From:   "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <20230914072159.1177582-2-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:806:22::8) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|MW3PR12MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cdc5b48-16c2-48c3-4deb-08dbbb85d172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EvKsy40TH1EY1jkU133Bnoxpgk084ouembTeHNyXSW9Ge1r260Bf8Jja3DFdRNcHjRpCYIOIZdOfqTpqF90kzxl+Yqj0UzZJGVsj6Zy/5w8NfIITDhcc6sDYnen2K91gBVvMzuJ0M2JuAgxZOLhttS8CowMZoIoiBiIKLlrfkQnRODFifYqn/W93yReQs8G8TKsBbEpKsdhZT4M4+ovLsFMojkRmU2qvUuzypGWFXT3atfwua7t6WgswwV8102t7f5ETMEHpsjdsSRK7hzkCwsz/tX6kwGTKP3f0xWK0n+FvJrT/9QUwAO0nfGwT+/MQktXE02mfSMAEKvOQS/+8qIb6mZvmY4gOOAmJ9tCuZTkNRF0XfZNoehyX2sXgvT39iwR1wAoOKlQE7eGyPJHTAlEQbf3XVeutMTMf8EaZV9BxR1ivK2UpbnZwYYn63N8azv6P/uxbO+V26IdDdOtqvz0gaGCZsbgyYy1sSHW4Jq44n46Zi5sEvgUE1uOdNx96I2RrvLFYQh1/ifyI7QA/i+vSo/QEGnQOl1pltrsxkAmwRPeInvxXIVrQEy313OnjYtZe0+PsPabCzSg5PCmAUS63lEQC+/Jepx/7iWAGaiHe5SDLU01KVLSgcIF4u2rYxWLXckbymK/s3zh4Q4Z7Kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(39860400002)(136003)(186009)(1800799009)(451199024)(38100700002)(5660300002)(31696002)(36756003)(966005)(2906002)(54906003)(66476007)(66556008)(110136005)(66946007)(478600001)(2616005)(6666004)(6486002)(6506007)(6512007)(53546011)(316002)(8676002)(4326008)(8936002)(7416002)(31686004)(41300700001)(83380400001)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1E1TzIwNzNKaGhHT3hlVUpiVGM1Y0hJOXkxTUZrbUFNUTUrU05TSytXK1Bt?=
 =?utf-8?B?MWVNOHRLa0pvZ2tqT29tUmhnTlpuNkpuOG5tUC9kRlR4dzRvSWs2M0pRc20y?=
 =?utf-8?B?NGU5SnIxMFo3azU5UjMyL1dZY3FkYnl1a2ZCNTRuMmdJRUREQ081aFdyQXli?=
 =?utf-8?B?MFdOaVRTZU9mU25DR3FmcXlpbHVVOWdhQ0FrRllvb0M3cE0rYU9ZZ2VBaGpE?=
 =?utf-8?B?VU5UcXBHdERRdVNkSUdOTSttTkxKb05aek1LSUM1SXV0SW44Qk5Sa25memRV?=
 =?utf-8?B?VEtaODBxellIS1lzZWRrSUV0Tkc2WlhueGw0bThIeU11TFJOQ3E0VFFhZkVJ?=
 =?utf-8?B?a3lobTEwL2lTOXBkRWlMWVkzZncwb0w4RVRPbVB2czVCOGtrSEsreTNXYnUx?=
 =?utf-8?B?S0tPS0dYK29vOHE0NnRVOUxQNXRmZ3BON1pYZXFwWThtRzdhUCttR2VlQ3lX?=
 =?utf-8?B?cUxmRlJxM0YzQ0ZZdlh2c0ZDZkJ0K091NXVVTlVQZFkzTjVCY2hTN0FaVWhW?=
 =?utf-8?B?N3lFSjlWR01aSkFWUEFDZHJhZ1FjeDJsQUdwdUdpbmpiTjE5YnVkNjNNcUxC?=
 =?utf-8?B?VHhNak9tZ2xDalpVdkRlbVN1enc2bEpDVHhIcG92WU9iNVZsT3dHMGJSS2di?=
 =?utf-8?B?UDBqaVM3RVU5NmhXWXNDbXJVdHExbEc3NUlzVUx3N2JDQUg3Q1o2UFRYVWc5?=
 =?utf-8?B?YWtKanBERzd6OERDSCt6K25WT2QzcWNkOW4vNFVCc2diSi9rdTNySFhXZGR3?=
 =?utf-8?B?aU5uWnpqRm9EV3pYeFY5ZW5DMFpkbVhDY0NrYzIxN2pXOVNOdVN2eG5lM1Iv?=
 =?utf-8?B?U1JObkhNUGRFOHp3aytlVlZwRkExZXFTTnpzVEhQeS9hSGtrNWNtVklTbjQy?=
 =?utf-8?B?QkFBa1JBaWdlZDZ1K0lVbnFkVzNsR3c3VHZ0c3ppQlZKZzZWU2Nqb2YvQ3hR?=
 =?utf-8?B?UkF6ckMza05xc3ppQlpPZ3Q3S0JsWEdoVFl1QlNhR0dVWnRZaXZyQlRwRTJ1?=
 =?utf-8?B?YnVtZ1pDSDJSMzlUQVFBYWZETUtGWG9ESWJtdG4xTVZselF5YmxlSVFSTWQ3?=
 =?utf-8?B?bjRHQ3ErcU0yUWZ6VGtWQjk3eURjNzIxVks5Sm9CQ2FUZU1OQnVvdGtCa1dD?=
 =?utf-8?B?Mkk1b1VkcjdZNCtUcEI1SUhHRS9QV21EYm5rZDFoaE83NjdsWlpVRHArU2Rr?=
 =?utf-8?B?ZEt6NW1IanhEckVBS256WG1reTRwLys5VXhxQnZoeGdIaFJjTVVGQjNLVTFx?=
 =?utf-8?B?Q1NnMWd3NmI4UlRlK0NWUVpsNVU4MGpoVGd0WVluNlhCejBUNEg2YnNSWFhs?=
 =?utf-8?B?RW00N2FHcmJtQUxUZnI2aG1PV3VnVWkzdW0wQ05mMTlWYndVK25DRFJvWWYz?=
 =?utf-8?B?ZVRSNFJuZ3ZWZkwzdTJIdmtaRWsvenR0eWRoZjROUCtKUnROYWNHeStLQmNn?=
 =?utf-8?B?a1VTQ1Z4bjZiamtEMG1lWDNOUWNUMDdrci8yUmY0WGozY05rT2RaYmhSRGJs?=
 =?utf-8?B?T0VpeVRkd1dmQ0dQbEg1dFZtS0FPSDMzSE9SM01waURhclZ4SlRxQklyQnFl?=
 =?utf-8?B?VW14MG9KL1ZXRTlVQVZwLytQNzlHU1ArOWlQbE9hSTRFZFhEWHBvNEZPazFK?=
 =?utf-8?B?SEljOEI5dTNHVU4wQjI5L1Q5ZGQ0Q2tTNGZrTGdCSFNURU16anZHMldMT2Nx?=
 =?utf-8?B?enZLMFI1eEwxb25NQWFQT1pFRE83b1c3Qkl5MmR3L2VlSzcwMWdzVEk1bkZB?=
 =?utf-8?B?S0ZQSS8ya0RKZlpveTRMRFR3QjJ3aklNTXFHZGZuMTRYVU01d3V0cGRJVXdw?=
 =?utf-8?B?SHRoSUdsZ3BLK3FoS1dIUThUZ01lVDFiWHovTWYxdFBlQ0FqVDJLeERBRjFn?=
 =?utf-8?B?TXltYzJFeWtHR1JhamlkcGxiL29ZbHVMbVJUNXVWM0tNcWRhYVBQc2pYZTJV?=
 =?utf-8?B?ckt4SklNdGIzRlAybEYrbU5NK0l0eUxxRk5UWVptN2NEK1VLMkVmMGFGRGRx?=
 =?utf-8?B?Z0s5UUNjK3BuTk00K29qOWg0Z3A2UTB5aXE1UHJ3STI0Qm9SWWhDZ25yZm8x?=
 =?utf-8?B?Qitaa0RVZUlOQlhGMDh3QzJZeEtZNHZpRzNERnJUUXBlRkpYbjZRYnlZWUUw?=
 =?utf-8?Q?6YYw=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdc5b48-16c2-48c3-4deb-08dbbb85d172
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 16:06:02.3306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rhxTEPbPFtoqHfZsQDyJGcqENv+YOPDnFuNLqXtYUpIUCqafJ70hFa7n/W3eYUGM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4507
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
> For function comments in this file, keep the comment style consistent
> with other files in the directory.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@Intel.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Babu Moger <babu.moger@amd.com>

Thanks

Babu


> ---
> Changes since v3:
>   * Optimized the description in commit message: Change "with other
>     places" to "with other files in the directory". (Babu)
> ---
>   include/hw/i386/topology.h | 33 +++++++++++++++++----------------
>   1 file changed, 17 insertions(+), 16 deletions(-)
>
> diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
> index 81573f6cfde0..5a19679f618b 100644
> --- a/include/hw/i386/topology.h
> +++ b/include/hw/i386/topology.h
> @@ -24,7 +24,8 @@
>   #ifndef HW_I386_TOPOLOGY_H
>   #define HW_I386_TOPOLOGY_H
>   
> -/* This file implements the APIC-ID-based CPU topology enumeration logic,
> +/*
> + * This file implements the APIC-ID-based CPU topology enumeration logic,
>    * documented at the following document:
>    *   Intel® 64 Architecture Processor Topology Enumeration
>    *   http://software.intel.com/en-us/articles/intel-64-architecture-processor-topology-enumeration/
> @@ -41,7 +42,8 @@
>   
>   #include "qemu/bitops.h"
>   
> -/* APIC IDs can be 32-bit, but beware: APIC IDs > 255 require x2APIC support
> +/*
> + * APIC IDs can be 32-bit, but beware: APIC IDs > 255 require x2APIC support
>    */
>   typedef uint32_t apic_id_t;
>   
> @@ -58,8 +60,7 @@ typedef struct X86CPUTopoInfo {
>       unsigned threads_per_core;
>   } X86CPUTopoInfo;
>   
> -/* Return the bit width needed for 'count' IDs
> - */
> +/* Return the bit width needed for 'count' IDs */
>   static unsigned apicid_bitwidth_for_count(unsigned count)
>   {
>       g_assert(count >= 1);
> @@ -67,15 +68,13 @@ static unsigned apicid_bitwidth_for_count(unsigned count)
>       return count ? 32 - clz32(count) : 0;
>   }
>   
> -/* Bit width of the SMT_ID (thread ID) field on the APIC ID
> - */
> +/* Bit width of the SMT_ID (thread ID) field on the APIC ID */
>   static inline unsigned apicid_smt_width(X86CPUTopoInfo *topo_info)
>   {
>       return apicid_bitwidth_for_count(topo_info->threads_per_core);
>   }
>   
> -/* Bit width of the Core_ID field
> - */
> +/* Bit width of the Core_ID field */
>   static inline unsigned apicid_core_width(X86CPUTopoInfo *topo_info)
>   {
>       return apicid_bitwidth_for_count(topo_info->cores_per_die);
> @@ -87,8 +86,7 @@ static inline unsigned apicid_die_width(X86CPUTopoInfo *topo_info)
>       return apicid_bitwidth_for_count(topo_info->dies_per_pkg);
>   }
>   
> -/* Bit offset of the Core_ID field
> - */
> +/* Bit offset of the Core_ID field */
>   static inline unsigned apicid_core_offset(X86CPUTopoInfo *topo_info)
>   {
>       return apicid_smt_width(topo_info);
> @@ -100,14 +98,14 @@ static inline unsigned apicid_die_offset(X86CPUTopoInfo *topo_info)
>       return apicid_core_offset(topo_info) + apicid_core_width(topo_info);
>   }
>   
> -/* Bit offset of the Pkg_ID (socket ID) field
> - */
> +/* Bit offset of the Pkg_ID (socket ID) field */
>   static inline unsigned apicid_pkg_offset(X86CPUTopoInfo *topo_info)
>   {
>       return apicid_die_offset(topo_info) + apicid_die_width(topo_info);
>   }
>   
> -/* Make APIC ID for the CPU based on Pkg_ID, Core_ID, SMT_ID
> +/*
> + * Make APIC ID for the CPU based on Pkg_ID, Core_ID, SMT_ID
>    *
>    * The caller must make sure core_id < nr_cores and smt_id < nr_threads.
>    */
> @@ -120,7 +118,8 @@ static inline apic_id_t x86_apicid_from_topo_ids(X86CPUTopoInfo *topo_info,
>              topo_ids->smt_id;
>   }
>   
> -/* Calculate thread/core/package IDs for a specific topology,
> +/*
> + * Calculate thread/core/package IDs for a specific topology,
>    * based on (contiguous) CPU index
>    */
>   static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
> @@ -137,7 +136,8 @@ static inline void x86_topo_ids_from_idx(X86CPUTopoInfo *topo_info,
>       topo_ids->smt_id = cpu_index % nr_threads;
>   }
>   
> -/* Calculate thread/core/package IDs for a specific topology,
> +/*
> + * Calculate thread/core/package IDs for a specific topology,
>    * based on APIC ID
>    */
>   static inline void x86_topo_ids_from_apicid(apic_id_t apicid,
> @@ -155,7 +155,8 @@ static inline void x86_topo_ids_from_apicid(apic_id_t apicid,
>       topo_ids->pkg_id = apicid >> apicid_pkg_offset(topo_info);
>   }
>   
> -/* Make APIC ID for the CPU 'cpu_index'
> +/*
> + * Make APIC ID for the CPU 'cpu_index'
>    *
>    * 'cpu_index' is a sequential, contiguous ID for the CPU.
>    */
