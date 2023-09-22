Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EDA7ABA0A
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 21:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbjIVT2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 15:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbjIVT2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 15:28:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8383C2
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 12:28:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhfjyOVwhJCw2lhlIiF5Tof6fGVbVfY8Mb0Dsp7NFVt/5Ket1xfx+NvumCgzlftLDhA+e3mY3yo3znPIqMBAcsHRKGBb8lWFW64dJcJvRmtGrCwoZhx2JYJAu6da0Pcz1dyYw+pdtpBoVcIkvZccb6PW84gz0fhhNFj6ZUflHO7iX5npQMf2U40plTFTmA01AEdW8GjtbJH/YWkRYeUd+fgDzZIla3RLXmNJvaL4oq5v2gXq4Hq/mlitQ7eoOYx4thgKpdKBU/Hod511ad5m1D7mc3tdrMom2dnFVFPwRuPvB6PdyxmE9e1F/sf0BNYZ476NCe6CrPSnqVTQI9Sy/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HO7fXnmDg84ssMF9VnpwMUA1jkgHxX0d6Q9PgudG3KU=;
 b=ASGRwQ/Y60iBovxH/HpsPU4p/3/k2+RMA7DrD+VTr1D+op46LsFwRJYIeDRLAGk0AV83kLKblJquPAh7BYBo0KGfFJuaz09FfeyybWQAqys5eNKSnFLZJeS4S6AUIv/sYZrj/BQVsfi2jPshD9Ga8NE+Flk1WYeRjPzGsRG2qApbZ/MXSS9ERL1VhmDy1cwfbAQd9PaQet8QOk1hMrOAj2DqFxVGZr8jRhnn8tRna0WBLamiBep3ae/Y1Xo23rhOlLkxcQL9uuNnqZPFbZErJQCqUT6/88cl+Ilpjqda1fYxAzdc/GBN+pszKzGIbMlh1QoDXV7IpAumt1bNLrRIuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HO7fXnmDg84ssMF9VnpwMUA1jkgHxX0d6Q9PgudG3KU=;
 b=OIpEV2jKLfxuSvNaiVf+djdE0aE/RjSwHgkj4RVKgxM4ghKiDJpwws+3EYZPh/+V680jOT4FmNxqcewNty+bQuz/BT+3GBDWTyAHK7m3SCKui5hRaWLViOiymWEdKAEla7EMTyyqzp1D3rXzgwi+WTjb06ZoJd8vjsAzo2Ez6kY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH7PR12MB7162.namprd12.prod.outlook.com (2603:10b6:510:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 19:28:02 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::fbfe:ec9c:b106:437e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::fbfe:ec9c:b106:437e%5]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 19:28:02 +0000
Message-ID: <269b02c3-7abb-2fb1-959e-1441d3ecf07f@amd.com>
Date:   Fri, 22 Sep 2023 14:27:58 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v4 20/21] i386: Use CPUCacheInfo.share_level to encode
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
 <20230914072159.1177582-21-zhao1.liu@linux.intel.com>
From:   "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <20230914072159.1177582-21-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0029.namprd05.prod.outlook.com
 (2603:10b6:803:40::42) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH7PR12MB7162:EE_
X-MS-Office365-Filtering-Correlation-Id: 461963de-eae8-471f-a182-08dbbba2094a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOG/3Lo4gSFNjVLb1X2ru9JW4TfBALjG/SO0zIrOv7krily1hLJ6Uej7RNkVA2t+Ntej8tuv0ODT5DoDukGSc8ECAtuPwOxiUjZNhKLy3BvimZJ7u0uv36IBgY+nLMk9aisaeuR8Ew+Fl+M5y7BIvYInWPCQ5YzfN54XCK0XAxfPytQVRULOfGdgPHPPXE1IRf6QxfvqHqHzgPdctryU9HWOFtXlE6FqY4ztbOI/erbMioMLsnWmv0CSLzz6ukowAPCFOwFZNI2VCpINPEGcA7TE1Z1S/hfJuWbUvbCVi/ut0/EE5deqHsF2GcO5sCYq2QoZuhX5y6zUTeP82pTcDeyIdzrfQ3eph7TUvSjYogKHjCKfVsewGH+0JLvVcnn6gQFL7jK+LvJ3y3TIY5FLMMX/4x3NtvE/ATHNMJ6SP8mqQtIJwqtOiqlOr1gOHyB5yAd4SMLeqr5H96eLhYLmGa2KqDREXdtLQWt6MCk6Wuu3prQC7YHzu9HT0kVbjXetd7fcKh7pxHDuv67Sf6gVDtGNrhDdOCQW1JxF0Uiz9Cspp3JX9yTVf+2RqGvFAdqAMXb/gqx4hyhOLHbHHUCA+eO1Dc+p1P6pAWZ5bBhdEEDaPtM+Du5UPUSd3PHUsvJWqMvLIN9SCvf2QoJA8P4t+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(376002)(366004)(396003)(186009)(1800799009)(451199024)(5660300002)(7416002)(2906002)(54906003)(66556008)(66476007)(66946007)(316002)(110136005)(8676002)(4326008)(8936002)(41300700001)(36756003)(31696002)(6666004)(31686004)(53546011)(6506007)(478600001)(26005)(2616005)(83380400001)(6512007)(38100700002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnA2SnROS0J5MktlMjE5bU92a2tnWjdPTko0R043WXgvdjZ4aXduSU9yQVBu?=
 =?utf-8?B?c2FjdkhBNjRiVGlUT0ZTRzlxQUpVNDhtbzBjVVVVOU1GbXF2bGxKRUxQaGl2?=
 =?utf-8?B?c3kwWnoxWGpKZ3pic1F4elhEWVkvTG5mOTVyVSs2UXlqWnhVS3VWUGZnWGlR?=
 =?utf-8?B?bzl4eWowUDRWL2hNbUN0SHFkNUZXZllaZEJ4TlBoamRldklPcXhsR2RhNjNQ?=
 =?utf-8?B?RVFqUC9MZ0tEODRTcms4cVJZbEpyWGpOR2JwS3VJN0t2VFB3R0dVeFJ1dDlU?=
 =?utf-8?B?bFNQb0dUWVczcndqUmo1LzJTaEVMMXpjL2VMS3FydVN6SHA3ck1VcVNiTDBu?=
 =?utf-8?B?cHN6Q1N4cXU2N04rcVhSV2kyT3J2NktqMEJkOUNkZE1Ga200c1VKdVE0T042?=
 =?utf-8?B?Q2tJb3VkMEtLbk0yR0dVaGZ0ZEpmQmkyQU9KRGVoV09Rdm1rSzRIMWt1LzRO?=
 =?utf-8?B?VGZzY1Y1N1VCSy9HTGRrVWpNZTdBMDZVa3FkUExCczdjbmdvbVJWY2lmSHRk?=
 =?utf-8?B?VGpEOTNYYStLZ0lJb1dsU3lXRTlvV0tMelBSV0U0eVl3RGR3cHg5QUtZT3dF?=
 =?utf-8?B?NnlYc3I2ZGkwVnhVMml1QytLdFpBbmRrRVUyV3FjenFJQ0JVRHZ6N1RHRUkv?=
 =?utf-8?B?VVRXV3JHcE9ZZ0xmN0h3WWR1cmVMWTdSN1FqNTJoZjVSZi9UU1U1Wmp1ZlRl?=
 =?utf-8?B?UTFwdEx0aHpvU2xEOVFrb0lTd3d0dTNZU0VKajE3bGV4blZBU3hSOWE5QzMz?=
 =?utf-8?B?aitaVjZpWnpLNUxOaXdHUUdVK3lrOE1iT0EyejMyZFR3S29sNXdmRjlnajB5?=
 =?utf-8?B?TzZBd1k4YjcyY0pDbEszTW9FbGxYamZkeFg4K2c3cHFaektxcUc4M2tid0xX?=
 =?utf-8?B?YTdsNU9IRDRRc1pqU3hjN0VQYmxXL1ozODE1NHpLSTlaclEzMFVsdzlPL0JI?=
 =?utf-8?B?RjkwY2VQT0paSWMzcW52UzU1WmdXNlcrakNVYXhueVJDd0d6U0ZUdEQrZDhD?=
 =?utf-8?B?aVUyYjU3ai9kNFdIV0hpSDVZdm1XcG5UOTNUWTNUcFNOMm95bDlUdGJ0RVIy?=
 =?utf-8?B?aWhjdjczUmU2OWhrZDFQSGhhNmdZK2k5T1pjSlRnS21mSFdtQ0NNM0k3ZHli?=
 =?utf-8?B?dDVTWnJJTi9mcU8wNzQ4dU1tN0tRcFRSOUZNR3FUVm1NcG1CZUJDTWN2REZi?=
 =?utf-8?B?R2Q0V3BwMDFGYk1xTC9wQ01JQm9MN2o4ZU1CeTErWlFZYnlNenZEMVVLTmFj?=
 =?utf-8?B?cFp5OTVobHUxeDRqUnB0bTZkNGcrc0lSbkdmeUtJRjlpSVBrSXM3cnpqMGN5?=
 =?utf-8?B?V3NhZC9RY2xXeGJTbHR6SWZBVjdsaHlydnk0Y0RpdFFCdlMxOEYzU0ZJbWUw?=
 =?utf-8?B?REJhcVhBZUp6TFZaanRnNElDdC9memZuREc0SnJ5Y0JnajNVc3VzOU4rbXhq?=
 =?utf-8?B?eFdIREl2dHdxYzEyNkwwTTVXdWVDRTNOLzVyZWhhb3grMzNpam5JWFF5Q284?=
 =?utf-8?B?eXdsSFVMU21qVjJPYm5YbXhYUll2VHFmeEdmTGhhOXFMaDZzb2hQczFJczJV?=
 =?utf-8?B?a2tNYW50QXFaaUw5UGUxcmtmWGxwdE90ak96cjNYSVk0Yy9aZ3FOTjdNYS9Q?=
 =?utf-8?B?Z0krVVFtdjdhYkxtNFU5Q3I5T2xPREMvNmNIS1d4UG5sNjRMWXpKNm5EbkU1?=
 =?utf-8?B?dnhSNVZtajUyWWNzclJrKzBQTHBsaG50WmxrK3Bha3pldXlTR2xZcEdIVDFQ?=
 =?utf-8?B?aUZ4bTNwWFR3UkI2QTczL0ZtbTI1YWJYY2hOUmYrcVdJVWVWVVhBSHBpQlFI?=
 =?utf-8?B?ZGVybHQ4TGpYdElhTnJCeWpzZjhlY0tCSzRtQ0pQdzNCaUVLK0ZPTTNocHhz?=
 =?utf-8?B?NXNHZmRaTldWT2g4NmkxZDVBWDJ5a21DNDR5d3FqNEl4TXROeld2TDd2SlNT?=
 =?utf-8?B?MnFtc04ybmVDMVFTUkpmVXdIWURHS0lha1RXb3N6TE03R2lSWTdNZ09TaXEy?=
 =?utf-8?B?MGZhRUYyU3lzbGN0eDRBWGxUUFNLSk95ZnVPeHFwb1VGQVdGczZaRXlsWnIw?=
 =?utf-8?B?MDJHWmQrakFMOUJGVklhYzI3SElKNTlBTWsxa3g2eXJxYkE2czBKVFRydGJG?=
 =?utf-8?Q?5cs+nj5U9nHh3j+69jdqPQOU7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461963de-eae8-471f-a182-08dbbba2094a
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 19:28:01.9477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZbCBztuebV572pfD7U9rGuh+RE67Jhbxkf+osT5Mtt+xkvCGM33Jmkt5G3JKJqiJ
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
> CPUID[0x8000001D].EAX[bits 25:14] NumSharingCache: number of logical
> processors sharing cache.
>
> The number of logical processors sharing this cache is
> NumSharingCache + 1.
>
> After cache models have topology information, we can use
> CPUCacheInfo.share_level to decide which topology level to be encoded
> into CPUID[0x8000001D].EAX[bits 25:14].
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Babu Moger <babu.moger@amd.com>


> ---
> Changes since v3:
>   * Explain what "CPUID[0x8000001D].EAX[bits 25:14]" means in the commit
>     message. (Babu)
>
> Changes since v1:
>   * Use cache->share_level as the parameter in
>     max_processor_ids_for_cache().
> ---
>   target/i386/cpu.c | 10 +---------
>   1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index bc28c59df089..3bed823dc3b7 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -482,20 +482,12 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>                                          uint32_t *eax, uint32_t *ebx,
>                                          uint32_t *ecx, uint32_t *edx)
>   {
> -    uint32_t num_sharing_cache;
>       assert(cache->size == cache->line_size * cache->associativity *
>                             cache->partitions * cache->sets);
>   
>       *eax = CACHE_TYPE(cache->type) | CACHE_LEVEL(cache->level) |
>                  (cache->self_init ? CACHE_SELF_INIT_LEVEL : 0);
> -
> -    /* L3 is shared among multiple cores */
> -    if (cache->level == 3) {
> -        num_sharing_cache = 1 << apicid_die_offset(topo_info);
> -    } else {
> -        num_sharing_cache = 1 << apicid_core_offset(topo_info);
> -    }
> -    *eax |= (num_sharing_cache - 1) << 14;
> +    *eax |= max_processor_ids_for_cache(topo_info, cache->share_level) << 14;
>   
>       assert(cache->line_size > 0);
>       assert(cache->partitions > 0);
