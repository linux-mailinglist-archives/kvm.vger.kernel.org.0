Return-Path: <kvm+bounces-1605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDED47EA15C
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 17:40:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E888E1C208DE
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 16:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F12D22303;
	Mon, 13 Nov 2023 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="SS3AGQV6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853C021347
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 16:40:07 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2116.outbound.protection.outlook.com [40.107.21.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7AFDB
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:40:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6nt7t11PQFNUfcUw8qi2SIhKXy8uIlAw0hcLHcI8vvaXxaFfAJqGQHNkozqMx/IBAmCl3R8fuOXQcxHJDJ4iZQbqTbCNXSoFGYlwGfMVh2LHemkUEUyW8RBwPRRMG1Omon6fuq/0WmwA90T251qlBxXW+G1NYFB8ejNLEkcMrjWWDZb3aJNsMkv0oiT4JO86CLEDZUaGE/v9nRGiQuKR8W3Ea1N+jO7jsIAQDYx62w7bzFtEE1bLN0UjJ9fGTDtIm2AsgvtF9nCi+HUGQ/l7EmWjHNnhUUreovSJmG+CcTd7UenZnMF82jQsZOQoJY43qV4idJBVT35xj+zJRKXUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nV63I7m1BfzZjTeWqD8ywa/NKdHAmISawF2Gx6ZS0k=;
 b=YS5tPp9Omx5Gs0fK2EMHVU4K4etI08QZT8yi+uGj+WTYGoSvhsihUbZqY/i25zqUgcXB+URe62kPyEZfABgmg9LCUWBuXr6qIeVepFy0+ZtaVD03zXLsinRX3AK2jH7wEkdMxE6W+HGdbXa3v+y5u+t0RswiS+oioxvBTEDBV6sGNO00pWEDPRMtRQAZAVgQJHKhuJIh2eqnnXaxowQXd575KHomTu4vlhj+WAa4mVxQBWRqGM47X2dlXobAvLGu6IG/s/mYtfM6+DTP9l3tZoHn9kRB0M+dBd3ZKgu9Gz3IOLJNg6D4E1vVE2a35soBvofAZPmVz6NV8hYQH1+amA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nV63I7m1BfzZjTeWqD8ywa/NKdHAmISawF2Gx6ZS0k=;
 b=SS3AGQV6t7dq2tcy6gvPS7pfKiv6gc/R+4G13zZvsE7WSpf0JbLPXNecEBSXGKKxjgzrbNd10dCx+uDZXnZzxw+VlKIAKl65DeVJmgSFFQbn0WFNM9A3ewokGUHaxCTu1wHwnDt+fbpginodOPc2G3V+G1dEbKFE+iFRHnuiXirhED4gBDaCKjCP195Go0eQCubdyLa4Cg9nP1b8EQ/0Z0TxFlfBDEVYxoPtNyVOMa6PRHQUETx2iD0rZ9OLnxUwKb1xDp88mFfVHeP+dxrX5L6eqP8zuWurmNSJUhdunC2h6gf91Afww9m6KGhCfGZ85z/hNVaOVOasoghK+0fHSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by DU2PR08MB10087.eurprd08.prod.outlook.com (2603:10a6:10:491::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 16:40:02 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::46ee:1c5c:2cc6:b1fa]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::46ee:1c5c:2cc6:b1fa%4]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 16:40:02 +0000
Message-ID: <c84e080c-1504-4856-8949-28abfad5cd19@virtuozzo.com>
Date: Mon, 13 Nov 2023 17:39:59 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is
 disabled
Content-Language: en-US
To: Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc: pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
 chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
 jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
 danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
 groug@kaod.org, palmer@dabbelt.com, alistair.francis@wdc.com,
 bin.meng@windriver.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
 richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
 thuth@redhat.com, joe.jin@oracle.com, likexu@tencent.com,
 Alexander Ivanov <alexander.ivanov@virtuozzo.com>,
 Konstantin Khorenko <khorenko@virtuozzo.com>
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
 <20221119122901.2469-3-dongli.zhang@oracle.com>
From: "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <20221119122901.2469-3-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR04CA0116.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::14) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|DU2PR08MB10087:EE_
X-MS-Office365-Filtering-Correlation-Id: c4f5bd24-ce06-4039-18da-08dbe4672f06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tDjJ2mCtHyh5HVUkmRVkqm6mJtbUgPjqJCTjAH0q8pS8/u6ObL8rN1Ws5bUMoPmYzyimXF3rADCpexcs1OIgQy3jnL1cepCh+E7Jmu4qzjvKkmDDrc3drosyRe6zvYewyBMASyE/uTu//YZ9SAMO9UTbOtu95swnPlxDiM+qTZAjM/nj/GKA9iU20jkHm+cdsNxAJxIcXJrOhS/yOsIBhDfCtFPOT7Qs22kT8GCSpuAuTngTUy3gNEgOFhEp5+QV1080oMeBXV+Zoybh2CpgxcmiP9/4uWSxMNjjT18R4YiSTW43Ir5HSVUUnWcU9Tqt6pPw5yNSDA3VMlnQmdZpFGQhwAZMtrrwISEplRPs75Xdbz7Ndp0pi+3Hroo1NCqthUIiFP6cweZ2vChl9IYzoMFCG/DAEKXyG6lVTk2kYqmiG8QWMQp4Djhh8HNJ5d8Qfj/e2SExv3g/eeVSJI91H3GbITlsiKuZEoUb1Ks5rRCkxDEpsNV5bvBGJLJ+MWEM5DbwiyafFvjrmf/HcYFAtTWtRQ27bcNaV2IelnAXG4zRG/BzKMrsb2ofpAh8PjKbG8GxF7wvXnQMOXICh/YvgrdWLP2YkA/wimLBHMNZ/rk/67tBErIclnYuqvOYx6HTAYSFVWROoIMa+xhdow5rmg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39830400003)(376002)(396003)(136003)(366004)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(26005)(107886003)(38100700002)(83380400001)(31696002)(86362001)(7416002)(7406005)(5660300002)(2616005)(6512007)(6506007)(53546011)(31686004)(478600001)(6666004)(6486002)(966005)(36756003)(66946007)(316002)(66476007)(66556008)(54906003)(8676002)(4326008)(8936002)(2906002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2JpRFBBY1ZTSmpMVDNBWWNORzJ0TzZoYlh2NW5wcVljR2pmV2tSZGN4NGU4?=
 =?utf-8?B?VW1MWXFFMURBcHZhL0Q0SjV2dTNvNktDQmwxM0tyM3VmeTVpUzhvUk1aWHJk?=
 =?utf-8?B?TXZXMkxGVlpDOHQ0Yy9JQ0pKMjl1Z2FlK0lMSkJEa0QwbWsyVGhiMGxHSmkx?=
 =?utf-8?B?OE9scUY1aHdxRU9lMURlcWg1MXVwd1lqdUtzNDNqOVJmeGFtNTNMVjRRUGZw?=
 =?utf-8?B?dkdkVHg0bGZRZGc1Qk9qV2thV1QzQUJqeFlGOE53dWpjbkFxMTFDTm1qalIr?=
 =?utf-8?B?WXBWWXhhM1RpTWJjUTVSSXVJUnVqZXU2b2VqMXA3VHp0SUdFUDJGbHVGMGVE?=
 =?utf-8?B?elF2TnV5QUVoTGpzNmx5a3FSQ0JubHNiejNIUnp5MjZFcmkwYTd5KzZhU3p5?=
 =?utf-8?B?SXFSMW0veTYyNUhueGkwZVRiTWlDeWQvcEIwSmV3L2pKUXdoenROMFNwOUdp?=
 =?utf-8?B?bk5LZk1CVmxiTG1vLzQ0UkVzSFowbmtyWlhIakFsYWpaUlRxQzE5ekdQc2FS?=
 =?utf-8?B?bm1hejl3ZFBJbGpDWGg2MFdhemJ6Q0g2TXlIQUhIZ0dqdWs3L3ArVmJmKzRr?=
 =?utf-8?B?ZnI0VzJHNVFvTGRVSkZUNS9oODBLQ0tFUGt0Snd3aU8vZDBLWTlVYmtCN21o?=
 =?utf-8?B?dXJTVE14OHlrS01YbFI3VklCMks1VzVPeTlxekF0WHBEaVVydmNka1UzYXdC?=
 =?utf-8?B?bDBKdFVGOFN5T3NJcFJuZmJQVTNvNnNIM0FCb2RHTzRLbDlIQUtER3dwdFZk?=
 =?utf-8?B?MlErdU1JMmtqYkhTaGRIMDM5V2F5UVRRR0VJQjlGejRJOEZCb1hza2cyeUY0?=
 =?utf-8?B?c2gyYnR5VFpvUkZhYnQxVEY0dlR3dXBsTk9IT0pEY2trM0xrSGVPNnZJV0pt?=
 =?utf-8?B?NEM3Zkcza1F6Rmp6Y0Q0TkFBL05YRjhBdmQxQXZsVVdFMUpiV3picHpieWJ6?=
 =?utf-8?B?NUNYWDF5VkZnOGtUeS85R0g3TTd0UnpyUFpWNHU1SUFtSlBDSVlxZ1FISXFh?=
 =?utf-8?B?akNrb1BiMk03WUt3R3NhSXY2b0xFVFI4dVJTenZQTmxXTVMzci9VeG91RFZz?=
 =?utf-8?B?Uk5LOEpWMm1renBzcStMUGhCckIvVjV1bm5YSHc0SGcvOVF4dlhMVFFkZE1D?=
 =?utf-8?B?citOZ25Uam5IYWFsY0x3VWdTeCtESGl0R2lNTjlJRzh5S1NqaXFQcjVuY2Z2?=
 =?utf-8?B?ai9nR0dHQk9DMWZSNENYa1FaSnBkNGh0TVltQ2FObGtmZ1dYblZ6dkx1VnJ4?=
 =?utf-8?B?UndUWklZNHdvZjFRN2pLTk9jQXJPZVpYVmJ4NFI3eE1tUVhsdG0zdTBmUDZR?=
 =?utf-8?B?TU1RbEd5dUYxcGVqaFpIZFZkaXVOU2E5NGRMd0lyb2JyWERKR09SNUE2a0Q2?=
 =?utf-8?B?YVhkdjhqd2dud1hIMFJZZDZhM1o0Rlo5Tk9YRXd5UUZHQjBIUTNtcFNMOGtn?=
 =?utf-8?B?UXJXc3VsbmxFNHJyT2ZkL2xhSzJHTG90dDNPWURvUGhvSlhZbW5sWjZCK284?=
 =?utf-8?B?YnVrclV2TzZna2Y4Wm1OUWN1Zm41SkZoUzE1Y3h2ZmwyeXc0TXdmdHkvcUY3?=
 =?utf-8?B?N1R6SU9iYnhCdkZEOGl6QkJXV3JLK1FQZElZdnRHaTBxNFlDWGY0Z1NjOGNV?=
 =?utf-8?B?SjN3MjRjdStmbjNzRlN3TGVocml1dHRHOEo1ZkJVcENVbTcxdXhUUWhFZnky?=
 =?utf-8?B?WktMYStJeXQySTFPaUMyakZvRUN5MHhKQUxzVzBLblJvTDNFa29UUm1nYnlr?=
 =?utf-8?B?NEkrYnV1dm5nc1l1M0ZMb1ZlK1BXUDFRRGV6bEJDbFhRMUtUdzdtTmxkWlQ4?=
 =?utf-8?B?aHZVSWkwRmZEYTRWMCs4bzZGejNYSFpLUDl0L05Kd2wvblVVNGp0TnAyUzRj?=
 =?utf-8?B?YkdXenlqSnh3eGowZVp4UVNQZG5vaTV1ejZSN2FtYmZVaEc2dTE5OEJDcm5E?=
 =?utf-8?B?QUNZWDlvbmVrMS9wczZiS0xzbjJ2bXBleWxWN1A2c1FHQVZFMS93ZDR6dXFT?=
 =?utf-8?B?SWFVb1RROGp5TmYvRjk1dFQ1c2FLRDVSN2tUanI3OCtROXRady8xdFlJT1Mv?=
 =?utf-8?B?R2xUQm9PTXVnMTRudjNabDR1aUtRcUhCb0Izek53MkFYdGErTlFzcmxRMk9G?=
 =?utf-8?Q?9MRyMBny6ehARhfRkpZyNK7+y?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f5bd24-ce06-4039-18da-08dbe4672f06
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 16:40:02.5958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0mx3+lGHHgB7/NZ2QdWuuyAw2xus/XcKdpeta0ChQoaZpFjtbsihjLcCtD6BurO79Jgyb6W/tlGkWwyQ1ukyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10087

On 11/19/22 13:29, Dongli Zhang wrote:
> The "perf stat" at the VM side still works even we set "-cpu host,-pmu" in
> the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
> could disable the pmu virtualization in an AMD environment.
>
> We still see below at VM kernel side ...
>
> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>
> ... although we expect something like below.
>
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>
> This is because the AMD pmu (v1) does not rely on cpuid to decide if the
> pmu virtualization is supported.
>
> We disable KVM_CAP_PMU_CAPABILITY if the 'pmu' is disabled in the vcpu
> properties.
>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>   target/i386/kvm/kvm.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8fec0bc5b5..0b1226ff7f 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -137,6 +137,8 @@ static int has_triple_fault_event;
>   
>   static bool has_msr_mcg_ext_ctl;
>   
> +static int has_pmu_cap;
> +
>   static struct kvm_cpuid2 *cpuid_cache;
>   static struct kvm_cpuid2 *hv_cpuid_cache;
>   static struct kvm_msr_list *kvm_feature_msrs;
> @@ -1725,6 +1727,19 @@ static void kvm_init_nested_state(CPUX86State *env)
>   
>   void kvm_arch_pre_create_vcpu(CPUState *cs)
>   {
> +    X86CPU *cpu = X86_CPU(cs);
> +    int ret;
> +
> +    if (has_pmu_cap && !cpu->enable_pmu) {
> +        ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                KVM_PMU_CAP_DISABLE);
> +        if (ret < 0) {
> +            error_report("kvm: Failed to disable pmu cap: %s",
> +                         strerror(-ret));
> +        }
> +
> +        has_pmu_cap = 0;
> +    }
>   }
>   
>   int kvm_arch_init_vcpu(CPUState *cs)
> @@ -2517,6 +2532,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           }
>       }
>   
> +    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
> +
>       ret = kvm_get_supported_msrs(s);
>       if (ret < 0) {
>           return ret;
This patch is very important in particular.
It boosts performance of any single VMexit
is 13% for AMD. Intel is being measured.

At my opinion v1 of the patch is better that
version 2. We should not introduce any
new capability but disable PMU if we can
while it is disabled according to the configuration.

The discussion about performance improvement
is here
https://lore.kernel.org/lkml/ZU2D3f6kc0MDzNR5@google.com/T/

Den

