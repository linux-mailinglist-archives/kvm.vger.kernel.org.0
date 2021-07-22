Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584273D1CD9
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 06:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhGVDes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 23:34:48 -0400
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:58166
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229779AbhGVDer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 23:34:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVKNq9AJOZqFBX221p+LipgK1i8UsLNTcBhJBb75ed3B7XcIbTy/4APms84U9VOjJ0PMZzQDx6H6Qme4M7jEpbF/PteUxesGuBAof0PuU9K88nhz723yzgq5P2FURS3t1nfsRjcXIkQUPiQ3DU172vn4TeBMOGOcAkaBybYkTvJ/AOubccd8VitA5fRImGoRzHoKkbnouNhTC7FWRLP5dd54XM9bvL9bSfTEyH6I/WBhaGoZUmbADHuk8k6VmvOwmazxqyKHpSAMm5bKIVU3O7WKypN6W5VzLbuo7ILxxjydg2ibCUbWZ7ZPaCCTupogAEBcFIuI0BtJk3tAuAxwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=565WBIEQ6Gy3vPabFxqkkk+08bFVqJo6SldT8D9NM7s=;
 b=P8s8jzqTiiGOnta/fAdRWcndVR+YKU7c8lgwiwSTNIPSdMlbTroCNhYWoTuxrHqoWHWYkvH/Spon3h7QpnW9GX83hW71z8unlainJLE0ypUMldMFkXETkN51/6ZOlcLbbiKJbBUb2T3DqIVTHGXVFQUSoJDq06ZBaDVGh9Z64frpwv8dCsGia603+PiIspc73Hj9ne6qoIGZPkAORrOOHE3pX4GX99gKegaXkhMvdMlPl1Ac/KOtkXZ0Rl18BgzPJBonl9/INbiG5bZzxJnDpVp64ONkZITJePgZjtr2WSN8l8KVt0Dbxc4LVuLOM4EFa6hJuA2BXmv8lDZlEmyIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=565WBIEQ6Gy3vPabFxqkkk+08bFVqJo6SldT8D9NM7s=;
 b=LU6v7vh0ymehlXqwchXCnfbbBP7uklrw5ghnzxMvh79oeZy4VM6rlBSi1tJAZ8NE3qB57FKZQW3PkIal71CVy+lxEdTjMVxBhCpcvvMupCJg1IITtdhz5xW7WDLpGxn9CqYSFDvgrxY9ASGe4DyLZM41WNxhvUFH6Uiv7pYNaJE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nextfour.com;
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com (2603:10a6:10:194::6)
 by DBAPR03MB6613.eurprd03.prod.outlook.com (2603:10a6:10:19b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 04:15:19 +0000
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::254c:af9d:3060:2201]) by DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::254c:af9d:3060:2201%6]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 04:15:19 +0000
Subject: Re: [PATCH] KVM: Consider SMT idle status when halt polling
To:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        mingo@redhat.com, peterz@infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210722035807.36937-1-lirongqing@baidu.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <a05553b3-7475-c1b8-0282-81ab8b1185c6@nextfour.com>
Date:   Thu, 22 Jul 2021 07:15:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210722035807.36937-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: HE1PR08CA0066.eurprd08.prod.outlook.com
 (2603:10a6:7:2a::37) To DBAPR03MB6630.eurprd03.prod.outlook.com
 (2603:10a6:10:194::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.121] (91.145.109.188) by HE1PR08CA0066.eurprd08.prod.outlook.com (2603:10a6:7:2a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 04:15:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98313f69-b99e-4a0c-5d67-08d94cc75111
X-MS-TrafficTypeDiagnostic: DBAPR03MB6613:
X-Microsoft-Antispam-PRVS: <DBAPR03MB66130D81D6B8C489E74643BD83E49@DBAPR03MB6613.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhYdhXsNRdIbAtBafVBQDcSogwDNjPqCi5ZT01VF+nn2dFl11GweP9iu2+JmBIL2IFvIJouTJFm2DD1BJZU+7H6lkgjNnilJNCuP12DLEoQ3etPmRCe/+1dw7tBCaysMhYWl3OZ3o7r8nm3uuFBu1FJjLIp2WKzJ3pRAGo8c+ck3TxgmTiucgNUp8G1oMzE6oFKFxnbz7jUinfkVcIXQJ3shdIbrX/jqnmlAQtvFYDEo/getlPaEoreuY324xAs8nBAWnK7fUrIfzapemUcJsRNs/sxh00Pcg5EVQkjFITxumler0eP0SrdtQlevIvBfKXFJDSXcthk660s1Wht+roKgFrPaYoYCwd1TeRXARkQPkJH+ebE1OethVXLhT+JwT35bxYz3kR15WwxCYv//3hJoA4hjCCclaxOK69EG9/GPZ51aNOu8cno5JkptU28bUI09H3RPDfqg/eEisFDWOMvbf2G+LLPotWlf9E2PQqF1ANc2+72yHQwx4Y9A0mbm5Lm84neVqEdlEqhQYl9RSe39Zl7ZrBHbMHApJww0YWACEz26meyt9Vpk+QcCQelq6G5K4VX/X/mcOQgX2NrjSru2vGbo/mIHxopW/64NpenysgOnVruf4LFZaXP9i3S/8eq8aoqoP8n94p7G4/kt4levdC8kVCBhWuGuPzdE+DkYkCwUh5REHIDu+4Az3Y5PTVrxhOa5GRDyslgUqLoDVu5yJ+Yr5af3eVG7xSqirfnvbJRDxS5opswxgP5cLe1Ofwmcrhje8mYrOx4+W96A4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR03MB6630.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(39830400003)(346002)(366004)(31686004)(31696002)(186003)(66946007)(52116002)(8676002)(66556008)(36756003)(66476007)(6486002)(5660300002)(508600001)(26005)(83380400001)(956004)(2906002)(86362001)(8936002)(2616005)(38350700002)(316002)(16576012)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0ZWbUdiSjE5VE9ZQm9Pc0dTSlFwQXZaTHYyTWZJSk5iRGxqS21oWWhNbVRM?=
 =?utf-8?B?cjdqQmZyNXFiT0NOOVJSNElsdmZRcEgrZEVpcWZxVnZWVnF1MmM2R0h0UDRS?=
 =?utf-8?B?QVVJVjdyMmExZmpTRFZ1dURZcms2RzhMN0lzd3JUS2ZGUnk2Ulp1MTlqS3Zh?=
 =?utf-8?B?Yy83Z2MzaVBLZ09GV3VqbFR0dURKMVUzWWVvZjFJK2tCaUtud0JKSGNqUGU1?=
 =?utf-8?B?eGlyVVVZYWN6V3FnR2xXZlhjNDQ4TzRDNlIrSkhXTE16SUIzTjFad25UVFNM?=
 =?utf-8?B?QjhPaHhKL2FDTWJTY0YvbnU3K2JCanIrb2IvT2x3VDdjb2xYQ0ZQRnJMZEdw?=
 =?utf-8?B?OHZnRlN0alRYV1pGZEdXaURvVVFLUlBicXZFQVgzV2dVd1ZsNTN2YkJWQWpa?=
 =?utf-8?B?VVdSbm9mNmZZZk1xSWFXam9mMk54MkpydzU5YkRrMFpNOEIxOCtHYzhocVE4?=
 =?utf-8?B?VzVZVFo4djFsZEk5d2VLK2szQ1dJcVVtQVhHRGg0Zmg4MFJvUkllZ1JSK24x?=
 =?utf-8?B?NzMyN2pzakdsZXp4cFl0Ty9yTVU1ZjU4K2FEQjlDOEhuM3AvcEMzMTVwYzR6?=
 =?utf-8?B?NGFqaDJ5OXZMZHhlRW5HWXlaRDZkRlJ1WW4vOHdmZFZvQ01seGNtM3RTOTVR?=
 =?utf-8?B?SnBMeFZoVFZmV0NwTktXQXNmcGlTRXJLU3UvWU5IWUFUWi9Ba20zVXNFT0xr?=
 =?utf-8?B?SWF6LzlhekdkQUhMOWJzOVMxRjhka2dMKzFNTWVyMWtCY1dSK08wTW5XWFZn?=
 =?utf-8?B?ZEphenFtVGpwMVBjM29Yd0x1cG0xdEtPb1VENXZELzRUazRBT25tdVQ0NkNV?=
 =?utf-8?B?MGJObUJlTlBaeFgrbCt5aThpTFRKK0NxYUhkRWtmbTZGdHpzaU1wRU5yak9L?=
 =?utf-8?B?ZThvTkVMWXFNSTUwWFdOQnlsU2JGR29aMHc3YnNpY2ZZMkJRd1MzUSs4S1pJ?=
 =?utf-8?B?Vm0rcjdidTM5czNabXIvZ05PQ1Z1VjNXeERveDlVNWQzN1d4S2Vmem9mczBQ?=
 =?utf-8?B?M1ZkMDBKL1AyVU1qV1JVYjlkSHRvVC8rSnlnRnVmYWR1QzQ5cEV2T1c5TXZN?=
 =?utf-8?B?ZWJtMjM2MGtlT1JqWWNVQ2ExdXRpZCt1QWE5RzQ5TmZabGo5aEtuSUF6OUs2?=
 =?utf-8?B?T2NzcXZZTHlMN2tLdzU4YzE0cDlBZmxPcFczY3dLSjNITTJydGhGU2NyWVNG?=
 =?utf-8?B?c2NuWkxjTERWWUlLTTMyNm5rNDRWTlc3bE5VdXFTWUN5azVTY0ZTTDZlRDFL?=
 =?utf-8?B?cTc1UTU4UVZXK0Vad2RBTkZPcVYyYTdOMmtJMzYzTVc2bFJaVzJmNDlqdGh2?=
 =?utf-8?B?VlRTY0ZsY1pzNG01aVhkK0ZsWndQSnA3SlFPVXRIaklRS01SYkpBQkpYZERx?=
 =?utf-8?B?bW5KZytNa3c2cnlFaFJ0Qm9vZVJUZng2b1d1WG5iZXZRZHhDQjM0dTl0d3VH?=
 =?utf-8?B?Q0MxZ0x4QmNwWEN3Z0N5WkhucEUvT0FOcm83UFozQWxJOVF5VVhGM1dUQVNs?=
 =?utf-8?B?c1NzeU5LVm81NHQydVhpQ2IySFhTQ0hmTFFMVCtJR01oWGorVnNCVmV3bHZi?=
 =?utf-8?B?ZDZoSTlPbUtFZXlDQU1yL05MTStVM3JVTHUzV0JLbElDM2lxTHVEWlNZTWk4?=
 =?utf-8?B?dmRXWFF6QVd1WUtJNTh5ZTFiRTZtTlpCSmRoSFp5NDQ0Y0pMQXlSaGVYTkgr?=
 =?utf-8?B?a2JvU2s3Mk91c3h6ZTRGTVNlbXRmRDBjeXE1K0xVWnpjSFV2aEpIUXIyeHZM?=
 =?utf-8?Q?ms9qAGBKBtg6RB2eqpHnoZcbAm/UBWW5+Foz/7I?=
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98313f69-b99e-4a0c-5d67-08d94cc75111
X-MS-Exchange-CrossTenant-AuthSource: DBAPR03MB6630.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 04:15:19.4340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcdHrHnquEhCU8YS9vdXxWvHXmfkY7aR8Fb4uTANnBnlbZLe27cQ6b62MXnWehA6UzreBto86m6p6kb/Riwljr2AgyLb8o/6M77nPqHBCOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6613
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.7.2021 6.58, Li RongQing wrote:
> SMT siblings share caches and other hardware, halt polling
> will degrade its sibling performance if its sibling is busy
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>   include/linux/kvm_host.h |  5 ++++-
>   include/linux/sched.h    | 17 +++++++++++++++++
>   kernel/sched/fair.c      | 17 -----------------
>   3 files changed, 21 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae7735b..15b3ef4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -269,7 +269,10 @@ static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
>   
>   static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
>   {
> -	return single_task_running() && !need_resched() && ktime_before(cur, stop);
> +	return single_task_running() &&
> +		   !need_resched() &&
> +		   ktime_before(cur, stop) &&
> +		   is_core_idle(raw_smp_processor_id());
>   }
>   
>   /*
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ec8d07d..c333218 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -34,6 +34,7 @@
>   #include <linux/rseq.h>
>   #include <linux/seqlock.h>
>   #include <linux/kcsan.h>
> +#include <linux/topology.h>
>   #include <asm/kmap_size.h>
>   
>   /* task_struct member predeclarations (sorted alphabetically): */
> @@ -2191,6 +2192,22 @@ int sched_trace_rq_nr_running(struct rq *rq);
>   
>   const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
>   
> +static inline bool is_core_idle(int cpu)
> +{
> +#ifdef CONFIG_SCHED_SMT
> +	int sibling;
> +
> +	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
> +		if (cpu == sibling)
> +			continue;
> +
> +		if (!idle_cpu(cpu))
> +			return false;

if (!idle_cpu(sibling))  instead, now it returns always false.



> +	}
> +#endif
> +	return true;
> +}
> +
>   #ifdef CONFIG_SCHED_CORE
>   extern void sched_core_free(struct task_struct *tsk);
>   extern void sched_core_fork(struct task_struct *p);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 44c4520..5b0259c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1477,23 +1477,6 @@ struct numa_stats {
>   	int idle_cpu;
>   };
>   
> -static inline bool is_core_idle(int cpu)
> -{
> -#ifdef CONFIG_SCHED_SMT
> -	int sibling;
> -
> -	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
> -		if (cpu == sibling)
> -			continue;
> -
> -		if (!idle_cpu(cpu))
> -			return false;
> -	}
> -#endif
> -
> -	return true;
> -}
> -
>   struct task_numa_env {
>   	struct task_struct *p;
>   

