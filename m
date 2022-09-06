Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39FE5AE246
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 10:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239059AbiIFIQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 04:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbiIFIQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 04:16:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479A05508C
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 01:16:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOFlvE9CKkmvg/E7rlDI+fZ8RS+xkqnPkjespM/v4PySgr+3ggV2pDkFQEatfkUf/7C1vn7ATu1+25QN9p8YAG267+YpE5k6QVWsxwqTqcvFFY5mjHSCQaU/9U/txBCBnzOQJxXTN1fkI/MDcH7+Y9VbsAXuerWcvaXbieH9qwdxqbgG1H1OJtf5UqSBNvJECjRKF0ZR07nJz0BrlN2e4geMMHoN6zHUkXkERdmvuFU9B6nwHaDgbdTaRfWkwffr7d2kMG+S/skuuhXsuLfKXAocao74mNf9HYreNUwd7JV7k3GxfoO5gPKmuAHElzafDLyVAw+SQmwE7GTR4aIcFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9MZDLBoztag1l5BBhel4CBt8uyC4CcZsoRGOswmpA8=;
 b=ArDS5MSB7+ZNYrScR6+3TIqlJQ7fX9JcYgXF+34lUODaDt0/K/xZOPp7Ap9iBAigNITZn696IRujj0qHiziItb1cCZ/pVq0eKQ/06Oa9L7NWrN6cT/yIBg7r3Ar8eDHY3hTT8Y4TiwmC7DI8icP6N53BgStYYL3ocOe0E9SOT0L3zHM3wRwoBeXxwKMs7Ers2rcfn2aUh+TDTGPqm7PxrNSVadQgCloPw/PAM0FBMPIVMsloiL8kUu2tET2cHtreSxVtpO+DsPpPtQ6X4g3W5AapnxglsRqOWpeTFQB6JDx3edmgQwgVRawF0Obrblh7zds1t1iU6WBbWw6Iyxm7/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9MZDLBoztag1l5BBhel4CBt8uyC4CcZsoRGOswmpA8=;
 b=pbe/7CVleFo+FGIJlA2isj5zSo34IRJ+MF7Uy8yjNU+wYE0p6PLZApkl4GpGSNZrMOfNy6EwlihV3J/o99UcLdW4af448yL1ew/W2YfQBL55xKFsSCx6jmZvVkRq5hGO6t3K2BEV1ollaiwKaagcnYCCoRiWEr0jiD9aHWf0c+Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MN0PR12MB6032.namprd12.prod.outlook.com (2603:10b6:208:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 08:16:24 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::e459:32ff:cdfc:fc8b%8]) with mapi id 15.20.5588.016; Tue, 6 Sep 2022
 08:16:24 +0000
Message-ID: <0666abab-ed22-6708-a794-de5449d049f1@amd.com>
Date:   Tue, 6 Sep 2022 13:46:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to
 cover Intel Arch PMU Version 1
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-11-likexu@tencent.com>
From:   Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20220819110939.78013-11-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0188.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::11) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dfcd24a-bc6d-4e35-7b35-08da8fe016c6
X-MS-TrafficTypeDiagnostic: MN0PR12MB6032:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KDSk9tJnT/Ov5b/v9CwDjmFU3m8vmhmNc7/XBhQRqsig+brS2AgkDha52gnV0NAbo3Bam2m8Al1e+IJsBXHkQT6YDaTS6lvLxud+hIPBGfHpk0JQNYeaDsze107EOZwoYD8pRDb0TYl6iwFWsT5tQyJsqvM/8HIjgk4AZVFo0pmLw21MdBNGVcLW2LpOhDcc4sUdFLFpI6kkXKllXPLmQJDKiUyXGIVTRI5wWuC+80MbW9n2ePlSZ6Cl8epJ5HEqgc39KONQHctpT2A+0YZCEyNfFxhw90ou1fZdLXMbkB95Di2mGHoNsMcyygPsoOwnJoTWYJ09goDutVqaiT1pF9L2zdnsgyw8oVaGenoN8wKjRqoeKcw1hiF2+vgRNijpDbT6s+UQKpg5Lk7BSCpay1TznlSg6cPEcRhTxHoeL1HCsTDI2JXfwdo0+liVqcyNvUE1V4CqZy3qBNbfiyJ0fTOy3ytanA0vby6GE0Is8CWY72m5zUB5aPF+0M9uTzpgi+58DzQgbWgWxgVoIeBpTXxi5Pqe3zghs4DYZk5k+/oCtMGXOW7Qmt9S0M8LJpbEHFaLp0mtzZX2d2V+qGTp2coK/A27g9GlMiy30oh+5zNRcnshspad5dHJc9d+kGGaNdJWXfU+Jqw97FYM0mHs2ZJaS8aJ6OYHZBRuXhQIJ6WqdsGyk77wEFb4oFeXkzQPLab1uLrMy3MoffKhiP4PS4GKV72rOteLz+950viArsByQfT+8jws4f7M5WP5/T/StnYICPLRnh3UJNQ3y3uuO9vQuSGzKa1pVG3E8FGvyZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(38100700002)(6916009)(66556008)(66476007)(8676002)(4326008)(66946007)(316002)(83380400001)(2906002)(5660300002)(8936002)(2616005)(6512007)(186003)(478600001)(26005)(6486002)(53546011)(6506007)(54906003)(41300700001)(44832011)(36756003)(31696002)(6666004)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHZhK0VQek1jUm82NW1UUVRqNWhSVmo1WGJhbzlsb0w1NlRCTFVBVFljVUgx?=
 =?utf-8?B?N3I5K1V2RFgwNGNmZmQwTkswY2krbll1aDI1SU5zaTNxRmJpaW0zUWhiaXQ0?=
 =?utf-8?B?U3N1NVUydGZJZSs1aHhtaGxYU0xBdXdXM0FrYkxtRVpXakR2NVZVYnNreFVu?=
 =?utf-8?B?RXczWWFjbWdhZWpZOW1hRnBmUDZIOEFZUlZxcDVEODNsQzd5R3NOVGJoWk1x?=
 =?utf-8?B?Uk1USWZwZWxJRS9IOTl2RTFBcHRIUWk0emVPN1BLck9oSEVHVFRRakhhZVVh?=
 =?utf-8?B?RmpKZXNSWmV2OVJ6R2JDcTlaZ1VRZm1NRllYM2ZMSysvWThuRVFUMmNHWGFv?=
 =?utf-8?B?eS9JWUpxcVJjRmJ2YjRaSlZBZWUydkFTQ2VoL3MxaURZZHF4NWlFSmFXUTBE?=
 =?utf-8?B?RUJId1NCczBadjRjV0p1T21DZE5YQWhCTml0R0h0SG15TXc5OVRSWlFzYmg3?=
 =?utf-8?B?SUZFalY0Y21MUEx2VXNwVnZmSlQ0YVFNemtrQWlLT21oNFlyb08vNk84OG14?=
 =?utf-8?B?djZGQ1VjTDA3SndOVkVKakU4SWtpU1hoYkMzMWdQQzlESUpmUGFjRDdwRTBj?=
 =?utf-8?B?NGJTL1ZCRnIzMXBHOGtBNGlxV0ZWTWpEK1ZiYXA4NFRUTTF4RE84M1dVYXlZ?=
 =?utf-8?B?aFJSNU42dGs0THRwQzlyTGtqOVRjNGYwSjVXUkYwVGJvbVFsWkRDVFVvVlBM?=
 =?utf-8?B?dW9hRzBmSmdMaXNldXhreUhxblNvR08wemY0Nm1oZ29pN05xenJZL0dSRkd2?=
 =?utf-8?B?M3Zxa1VuOVFybFFFaEpVbzlmV3RFS3d0eEVQdkpqQmE3dEJ1TlBZQldxR2ky?=
 =?utf-8?B?dnBFL1ZyRTR6SzBwNEZhMVQ4Sk5ucGJ4MjJYRGkvaVFqcGUyZ2RrR0EwRkdU?=
 =?utf-8?B?RXl4VExGQ2FoU0UwWW1EclRoQVFRcXI4NnZxYlFFS0dBcDVHejk3ZXRFcU1x?=
 =?utf-8?B?LzRITkNKVnpCTFJoNmtSZmw5SHFhS0RiRThaSk5IcWtDLzRLWDB0dHV4MGsw?=
 =?utf-8?B?WForRnNqdTRjSE9WS1FEZGpyUGhCNzc2QTlzeGZOM0ZIL0sxRVdRMExnRlh0?=
 =?utf-8?B?Q3NieWNQdnk1NFI5c0xvR2RBSS9Hd21PRVQxNXJrSE85MS9DVmgxS241cnhu?=
 =?utf-8?B?WDRrK1FEVjRXeGhMMkYwdU51N1luai9SS3NaQVI1T3lsSkJaMmJIZkVac1Zh?=
 =?utf-8?B?VlRXZ09UWVZ1NEZqRmE3ZCsxUkFXRzdhUytGT2U5Z1dxUThkL0hOMnJNUWtj?=
 =?utf-8?B?cTd6aDZYK3NMUGdpbWhXK0hFVGFOVjBkTHNkeFF0VUJGU1Z2Y29ySTFDN05h?=
 =?utf-8?B?M2JQTmZDVW5aUkpFcE5pamtaTktzRHN3VUEySmtxVUcyNzlvL1o5SmZCY1ha?=
 =?utf-8?B?L1dBRThrZ2FVcFNsSzEzN1IwTm9ZYXFTZUlBOHJqaHN3YTVEdUkyYW5XQ2Mv?=
 =?utf-8?B?UzI3THYwb05zekszQW5NTHJQaFJtTDBTUEpRNGpmSjJOTUwrMEk4RkFHSHJI?=
 =?utf-8?B?MFVWQ2NjZ3NuMnhjaEVJV1E1VjJnZVp1NnhSZVhJYjhSSCt0aXNoWkZPTFN4?=
 =?utf-8?B?VU1WWnJFNTNOSEhIa3puYjdzMExlV3drZFFNYmFvbjRlTFl6NnkvR0pzRzVS?=
 =?utf-8?B?clBNSitoZTVHK3lyWDU4MDlXN2t6Ylp5dHNsOC9Ua1BKM05ObHI4OGVhclFJ?=
 =?utf-8?B?dCs4UDFXTm1vcEZaeUdyUTlEcG9ZclhkK0trdk1tSDRmVnJJR2VneXZqeDVF?=
 =?utf-8?B?QUxOa3JUUm9QaTc1ellLcU1NcXdOVXlHYUlydmpFdVl5N0FKM1Yzd2FJRk94?=
 =?utf-8?B?TStDNWdqRkJBL1hKTXV6NFhnVU1GOWo3alpzSlppbjhiMFRDVStJWm55VG1n?=
 =?utf-8?B?cmR0VElGVjNSYzhZU3hyWFlmUEtFUURIL2kxMFpLaXRIL3lzUTFMQWVaTVJz?=
 =?utf-8?B?MjREY0M5MzdXL2FacUNrZllYR1dYaWx0WWVYZTBsbWx0bXdEWFdickdqZncw?=
 =?utf-8?B?MDd2dXgwdnhZb3ZPSWUxRWJRS1BmQjV4UlB3a0NhTFdhK29XN1ZqU3hOM3pa?=
 =?utf-8?B?ODBXbUdVaHBXVWdGNXZ3VnpSQnpQdDlYQVp3eFhYc0ZnZ1NpT3NtMFlIWHht?=
 =?utf-8?Q?AMDjPM4p13rTvHEaF5g7gCg98?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dfcd24a-bc6d-4e35-7b35-08da8fe016c6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 08:16:24.7492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UwSWpwqqUQsLIEXZ802PqcLvhhE5aFW3PNAgY+DN5Lo52R0NHctKWtRsyaX70pF7tJL/WRgtSj3rC1QpSd/baQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6032
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

On 8/19/2022 4:39 PM, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> For most unit tests, the basic framework and use cases which test
> any PMU counter do not require any changes, except for two things:
> 
> - No access to registers introduced only in PMU version 2 and above;
> - Expanded tolerance for testing counter overflows
>   due to the loss of uniform control of the gloabl_ctrl register
> 
> Adding some pmu_version() return value checks can seamlessly support
> Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 43 insertions(+), 21 deletions(-)
> 
> [...] 
> @@ -327,13 +335,21 @@ static void check_counter_overflow(void)
>  			cnt.config &= ~EVNTSEL_INT;
>  		idx = event_to_global_idx(&cnt);
>  		__measure(&cnt, cnt.count);
> -		report(cnt.count == 1, "cntr-%d", i);
> +
> +		report(check_irq() == (i % 2), "irq-%d", i);
> +		if (pmu_version() > 1)
> +			report(cnt.count == 1, "cntr-%d", i);
> +		else
> +			report(cnt.count < 4, "cntr-%d", i);
> +
> [...]

Sorry I missed this in the previous response. With an upper bound of
4, I see this test failing some times for at least one of the six
counters (with NMI watchdog disabled on the host) on a Milan (Zen 3)
system. Increasing it further does reduce the probability but I still
see failures. Do you see the same behaviour on systems with Zen 3 and
older processors?

- Sandipan
