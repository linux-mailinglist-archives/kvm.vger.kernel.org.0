Return-Path: <kvm+bounces-1497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD3507E820E
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 19:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71B37281171
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 18:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5113AC2D;
	Fri, 10 Nov 2023 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WZG/z/ao"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AE23AC10
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 18:52:16 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737E211985
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 10:52:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpQrYGNT+mYEuWmlOHJCbxZo+y7H+o1vL/eYhgWPT8kWkB6mKuVEYutvYsVZ8krv23oQCQ5TvQK339K9E1cm4uZ3VZ49SXSo/Mik0T/tY8wu8xzaURkscw1UClodgYiHsJeJchYa6941COj4HfnS2pAbtmBv8LZvw4vNgc1Syy3S9wrS95RYG2vQxXNUPN1LTYbFo2pfSTGekJW8jkGZLYfX5Txs8mnNyybznysuDiMe0vlb+KRxCxeyAMZ5sTsM/FuGwh9h0WH2wl5yazmXrcLqoRvXdrQtoCu33Kfbk8DeywhQIlqyAEQddtqNxzak52de4qRJ3odwIIOnz6uE1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PBNgZc+RreQxSi+855CN7rkcLigGLweUfvdJBMn6co=;
 b=TvyPQ+uJWfNBs/ZvDu6NUQAhNTstBF4SAurMTF3YC2dQJiXMv0mKSGNBcpiYNPs0sJRbFLQ3PKGvzEb6TvTem/9phLhpb6MyKrf+7ZJfVoo1EPk7RvUEmw5hOyviNMgKs1L72axO/PI7jlLuAJ21JpLpqvgq+nl1o2UyunXmGMQvcUHjPpekrK50IplHr23XWPX+QW3w/l7UoEFCn/KzywauKFDGFeqA+peWVJ95psoIUkckOO7bcg+KbwqQGljgQoRJlp7FSRN0Fff3zaMj9EQakaFi30Z985RkTlqzNY3GE/yivCwBBcxC0nKAu+yBXSHS5I8zy51cFOtlP2T7Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PBNgZc+RreQxSi+855CN7rkcLigGLweUfvdJBMn6co=;
 b=WZG/z/aoiy8ztbcPUUbPWIgIYgqKtPSN3AJ1j4IpL2qql6n0+BJzPr9WFkdYaJfE1885SW5EQkrZI8u6KkIQxRbfjQW0Fmy8SwgWAH3lvJlfJKmsI+FX5RBANyczNDfXW5XjZ54vGSan7iFyc+xiMJWJr9wql9Fgu7bXnfO+IX8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH7PR12MB7987.namprd12.prod.outlook.com (2603:10b6:510:27c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Fri, 10 Nov
 2023 18:52:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.6977.020; Fri, 10 Nov 2023
 18:52:08 +0000
Message-ID: <cafa9495-aae1-28a4-0628-bb5a7fb6d78d@amd.com>
Date: Fri, 10 Nov 2023 12:52:06 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC PATCH 3/4] KVM: SEV: Limit the call of WBINVDs based on the
 event type of mmu notifier
Content-Language: en-US
To: Jacky Li <jackyli@google.com>, Sean Christpherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Ovidiu Panait <ovidiu.panait@windriver.com>,
 Liam Merwick <liam.merwick@oracle.com>, David Rientjes
 <rientjes@google.com>, David Kaplan <david.kaplan@amd.com>,
 Peter Gonda <pgonda@google.com>, Mingwei Zhang <mizhang@google.com>,
 kvm@vger.kernel.org
References: <20231110003734.1014084-1-jackyli@google.com>
 <20231110003734.1014084-4-jackyli@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231110003734.1014084-4-jackyli@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::24) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH7PR12MB7987:EE_
X-MS-Office365-Filtering-Correlation-Id: c9be46b1-d6c5-497b-0db6-08dbe21e2401
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lLghyy36C77muhm7yOx1C1VBx1UWXQ6Cw4jqKCtuSXzwTBu9cbdCf4C26VwmGKGM6xv7ZCdcQaCj41hnv/RnnHwZAybH3Jgnr2445mS3fUZzHvBe5+Da44NLGnrhRBwxAa7MgR6mBTZCY7/doJWok80zDiH8syyd8ZBJWeUo1sUHo1DdxonSs/vVeBiJ0CgNDzxA0wQnL/kqm+KkSdbuqXNFP5T1TfbtBJPr7yqy+/IBmCQ3QvzoA9tNa0N7lTN+78vTO2vYoWVWQXltRhZbr4H96Yi1FOoj7U7wpv6Ox0593sS67/+pEcltvzvlzgAyo+kHde2VUzxmnvPhjBShtZkyp+w9FCeij5bNXr/pYGydijEU0GVt24hW3KD+Co1sf8LtjeqJxsgRtjBii4kHK9H0norAVFTS3FgRJ0BKearrHw5+1dC5Ms0CK+VLuUXiCzrHatM537TdGYfbyg0Xy7rYElqrn8yVgbFMoNK26z6qU1DC2ay2YA57i0GPY1ZbJuWD+m50GFD9Hr9LgCFpdVSUr7Y6nEfOAPGW56lI8cuyvssf21XDdBwatD5JGLUECpQ2QQbmbRPQB2v7fwkNv9ArH0p5PUPhIDQCzg5ZOVvp3w5DEUXbKTABW0+8KVfvg8MJdmLYeU4dd3FE+AJwBg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(346002)(396003)(136003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(66476007)(6512007)(6486002)(478600001)(2616005)(53546011)(6506007)(8676002)(5660300002)(41300700001)(66556008)(26005)(316002)(110136005)(8936002)(4326008)(83380400001)(66946007)(54906003)(36756003)(38100700002)(31696002)(86362001)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUZUNkI1THR5aktWYmJDRUlDM1JSUHlrbkdyM3kycUdXbEFQTDZrMEo5WVJw?=
 =?utf-8?B?ajFpNkwzdDRqNGR4cEMwQ1pTOUp3bDVuK0hlR3ZRNGVwSTVvWXA1ODBIalJs?=
 =?utf-8?B?WWd1dDhpYWtCRUkyQ096N0pkNnNyVHNWZFdsRWhmeU9vWDBONzRydGlJNWFU?=
 =?utf-8?B?WHpmZDVIYjREWVZ0YStrYXFPMXhScVFMWGpXZnhYS0JJeVdnRUswSWMxcUE3?=
 =?utf-8?B?YjlKNllTRE5lbWo4MUhveEsrYUR2WEpYdDNUa2pTZFhBblZPTlE4UEJidVZ0?=
 =?utf-8?B?K2JVTUZiQjYxK3RUUitjenF0NTViZE4vem5YUlJVN2ptRHlNMzRpa3BVY2NY?=
 =?utf-8?B?d01qY1ExK1grUXh0NHpUcFZaTGNkOTlONUtvdVYreHAwWU9ESmhOV1NJZ216?=
 =?utf-8?B?Tk14ekpYanpLcVZBYjlvc25NdURiRlhzd2xMNWtpYVJ6VGx2emUrSmpjTHFT?=
 =?utf-8?B?RmdRa21IR3NDSnVuZVBaVlllNVZHelYwbEM1UzdycE15cUNaK3g1ZG5ib0g2?=
 =?utf-8?B?bHVRbEs0TXJTQnJkL3ZKOXhZdTQvV2dZUWxnTzIyN2J3OUtxbFNnbG9yemFD?=
 =?utf-8?B?S3o5YTdvbnBGU1lVV0dDWm44Y3VZV2pHQ3I5T2tSbW1FSmh5UWhHS0p6Mi9G?=
 =?utf-8?B?UjNjTm8zMENkeVdLdmlQMkdzbTc5TzYybzZpMkR4U1pldlBhbENBcWExM3pl?=
 =?utf-8?B?YTFib0JiRjdxM2lyTEZVdHNLbm93UHExTy9aNll5YmMxSW42RXpoTVFRaGlX?=
 =?utf-8?B?NXRrLzdnQVFJb2c1QUdYNmRNelU0TThIa2N1dDJxRTRySTBob1ExbWVJcGZQ?=
 =?utf-8?B?R3QxbWIvb080ZWR5VDhNRlFlTUp1ZEgzN3BsK1FnbWw1SDJpMGZ5TWl6aHdE?=
 =?utf-8?B?cEVqdGlHWVZCTkY1Vm1HcUdwZXBKNDZGcUlscFQ1azBqKzI1QkxCRWh4bTl0?=
 =?utf-8?B?UTcrVzBhRW9BdjhnVlRUZDN3MERzaWNwYkt2WDhueWY0WFJiLzVzNnVZK2to?=
 =?utf-8?B?ekswSEZrdzdQZXUwNVpGRStwK2UwWWNIUFhsa2IxOWNFQnNPTzZKOXQ5U1o2?=
 =?utf-8?B?Zy9mcWMrRW1laHRHcnhWRll0eHBRWTk5aWlwUUhpdWFsUG5wS1ovd05XYklE?=
 =?utf-8?B?ZEhaT29OYWRZRWxSZFlUbnl0WlkrUFpMUkNITzZ3NHo0dVJRTHBUN0xQTm1p?=
 =?utf-8?B?eTBEUDdWMlFaUExDQXNtQmY0VGZLL2l5NzJLS1h2c2svVHM3TWIvOWZ6SFVU?=
 =?utf-8?B?amhNcGZDUVJKeHplbk05SjdGUmpIcUpJNFp2Y21pODRzVjVnTUNZRUNtUHg1?=
 =?utf-8?B?MVdnckNYUC9KU25XMkhvVEhDN1Mxdmowd0VzdnF5bWNLZVhFYTRJTjNjcE1B?=
 =?utf-8?B?MW83dUtmUkwvK09NN3dzQ29EUDRvcTM0Y3F3Wkd3b0tRR3E3SUdDVmg0bDly?=
 =?utf-8?B?WHhqUGJGMEh5a0ZsRE1pSUVGb21qajJkQnMwQVcrTGZQVkhMbyt0UWZIN3Zm?=
 =?utf-8?B?dDhCMmJtclB5d2VNNjE2UFZBNGVZRk5QejJvenR1VTNyU3Fpc2p0b0JDaWQw?=
 =?utf-8?B?cFp5VFhMTmlZVS9nZWV6Vmh6bnUxU2ZEaUZUQlFYWGhYUGdVTi9pY091VGt4?=
 =?utf-8?B?YVNNR3VvbFpBQmJTM0NRdUVwVXFSalF6OXlHeENrUlBRTHBQSFNWd0s4dDVJ?=
 =?utf-8?B?MnMrWkZXV2lZV2NBcy9Ib0xxMzhRcHN1OTNta0wxaXRtVkRUOUc0eHFFVGRz?=
 =?utf-8?B?TC8yY0QzMUZGNEpMQkF6djErakdpMUZzTm02aDlyc3hzNDhaQUROcHpnZlZs?=
 =?utf-8?B?RTVYWDVOcWJKM1FRVDVOc1hxNDdWVVg5a09JZHo4QlhoTTRQcmlkNGU5MWpJ?=
 =?utf-8?B?MmhHU0RKeU5JQ1VlU2YzK2hpTzdsNHdBakQ0WG1CUVBVYTIvU2o3TVFoSlRs?=
 =?utf-8?B?Qk9wOVZnRzJBZ2NuNWlkQktRMnZlRGZIcWczVk5HME9jbVliMkYrdVEwOWZi?=
 =?utf-8?B?L0RPZWY1aHhWZ0t6S1RkRTFtbHdVQnkrL291R0hyVjdMMHBzY25nVWpqOWdT?=
 =?utf-8?B?YzJFSUx3Sk5MM2liRUpSZlR6bzlobzE4NWxXUDQyeENoMm5ZNkl2M0U1cDBR?=
 =?utf-8?Q?kU2heHliQD/mvmA01SFOhyijD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9be46b1-d6c5-497b-0db6-08dbe21e2401
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 18:52:08.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uONIy0rxY+M5pnFE9rFxaeH8/+xqF9d+pIxfYMfkz1MyCGglAEeqTZ4/yH/2KqoDymflTW0wiWkeTDlKUvNEVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7987

On 11/9/2023 6:37 PM, Jacky Li wrote:
> The cache flush was originally introduced to enforce the cache coherency
> across VM boundary in SEV, so the flush is not needed in some cases when
> the page remains in the same VM. wbinvd_on_all_cpus() is a costly
> operation so use the mmu notifier event type information in the range
> struct to only do cache flush when needed.
> 
> The physical page might be allocated to a different VM after the range
> is unmapped, cleared, released or migrated. So do a cache flush only on
> those events.
> 
> Signed-off-by: Jacky Li <jackyli@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Suggested-by: Sean Christpherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 8d30f6c5e872..477df8a06629 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2335,7 +2335,11 @@ void sev_guest_memory_reclaimed(struct kvm *kvm,
>   	if (!sev_guest(kvm))
>   		return;
>   
> -	wbinvd_on_all_cpus();
> +	if (mmu_notifier_event == MMU_NOTIFY_UNMAP ||
> +	    mmu_notifier_event == MMU_NOTIFY_CLEAR ||

When i looked at MMU notifier event filtering and the various code paths 
(of interest) from where the MMU invalidation notifier gets invoked:

For NUMA load balancing during #PF fault handling, try_to_migrate_one() 
does MMU invalidation notifier invocation with MMU_NOTIFY_CLEAR event 
and then looking at KSM code paths, try_to_merge_one_page() -> 
write_protect_page() and try_to_merge_one_page() -> replace_page() does 
MMU invalidation notifier invocations also with MMU_NOTIFY_CLEAR event.

Now, i remember from previous discussions, that the CLEAR event is an 
overloaded event used for page zapping, madvise, etc., so i don't think 
we will be able to filter *out* this event and if this is the case then 
i have concerns about this whole patch-series as this event is 
triggering most of the performance issues we are observing.

Thanks,
Ashish

> +	    mmu_notifier_event == MMU_NOTIFY_RELEASE ||
> +	    mmu_notifier_event == MMU_NOTIFY_MIGRATE)
> +		wbinvd_on_all_cpus();
>   }
>   
>   void sev_free_vcpu(struct kvm_vcpu *vcpu)
> 

