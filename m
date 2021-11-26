Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CFD45E7A0
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 07:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345930AbhKZGEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 01:04:23 -0500
Received: from mail-mw2nam08on2102.outbound.protection.outlook.com ([40.107.101.102]:26112
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344020AbhKZGCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 01:02:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oY5rKktJSuEjYFpsGgqFP6AteOpqbUVY7PA9BJ02m85jjWCsOz45cIof68jorad9ojMcgRzAsLMyATa09Ne4CQwUcOA8k42BaLtF8thmThVAhiXMIOYTjrlQngc7Pb6aQNYnp5V1D0KaLnAQdPl+GQh/SWPgWbhjQnFYFph0qSktjt9kMmNbzG4ys1PpakRtVIAWwkBwbBw8V9o00qxO2drvVqPNrsFyPHOi9yengUyC3GvxbmxMOSSju1DOEFlf11/SLs5tPBHWb5EpLk6pqFgZYTgAZWSi0F8E4MX6Qv/VKX61z1zmDaAH1ijdD2GS0WvAXCny9etcSMIeQ1pPFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMA3rw8bx4HxC+CYJNhzGmKOXDrCfRbSrtbf4SEQW1o=;
 b=V6g0GVIUfh28EaNgCvVin7AQi1Kl52PuWObfCsZfbb0fMPu0EdPP1mDWVbM3LN6/2vqrRQU6VcRxULJDanbQILWAJ+Qo/o02MmC+7T3PGVArePoWRP1HAdj+0xcn27Pdw46gHYdbm1MkQrYGSpbtDg2kBQypB9wnk2dmYuBEScjaHXL6O1+YE7wIBbYHk85LY5S8TE7id5tHY9F3UopNtvVHFt2tKKyX9ovYuQ9QXWeytvLwv7v/qy6QaoF1cs5HQ4CGhVmQNlXhnslKgxqI7K/qQr2SgT3dX4D3IMttEuuoUWmQ/nNyQlvY2xmb42XBuMyLfn4bdA0kVezL4KUrZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMA3rw8bx4HxC+CYJNhzGmKOXDrCfRbSrtbf4SEQW1o=;
 b=k1KqXCW9r4IbAWxDTdazMJC0HFnqMFTUC6kiFDmv1Ob2hGiWiGAymH1Bp6wZYaERDmcdZlKzVJox90Efyb0QkqSjHxiIt7EMcanHfStg6SN74US08J8ITWVdubnwmMMkqhuYudTTSc9GrH8H4dDzjS/naJNYysNxJlTdR/PnBXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM5PR01MB2379.prod.exchangelabs.com (2603:10b6:3:3a::17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.22; Fri, 26 Nov 2021 05:59:08 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::ec55:306:a75d:8529%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 05:59:07 +0000
Message-ID: <a32b4390-a735-783f-9351-a71334d67572@os.amperecomputing.com>
Date:   Fri, 26 Nov 2021 11:29:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 2/2] KVM: arm64: nv: fixup! Support multiple nested
 Stage-2 mmu structures
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, darren@os.amperecomputing.com,
        D Scott Phillips <scott@os.amperecomputing.com>
References: <20211122095803.28943-1-gankulkarni@os.amperecomputing.com>
 <20211122095803.28943-3-gankulkarni@os.amperecomputing.com>
 <877dcwco1m.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <877dcwco1m.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR15CA0005.namprd15.prod.outlook.com
 (2603:10b6:930:14::18) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
Received: from [192.168.1.22] (122.177.58.155) by CY5PR15CA0005.namprd15.prod.outlook.com (2603:10b6:930:14::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend Transport; Fri, 26 Nov 2021 05:59:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d67398a4-4473-4ed5-897c-08d9b0a1dbdb
X-MS-TrafficTypeDiagnostic: DM5PR01MB2379:
X-Microsoft-Antispam-PRVS: <DM5PR01MB237922B7D5EF41BEE46A52429C639@DM5PR01MB2379.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kdjeeLOFCBYPWWmm1yd5s1LOJHmp3RcZqIUGf3/EAqVBqT7yKTMmdQyYgEfqWuKUK5FXedWPdOFeZFRmVWnnQ4a1seXSsf5qLrwnd+Rh6V33RGnnR0i3smqdVc6B4T929kh9pYyp0EX80qgYPrXnadWoQ1torl6mJx9kuTkZMCxngur6c9hnG9x3VQ8cBT4L077aE8cuKP2eZf5tAMM8HGJqro4iiLwC756HLI5p+f9pXpYzHKTBDXikG8FS1bzWwUHdELQqDqerfw7eGRzGp9L+QdRN+htReteLD5JF//wHGjMRtmsUTwmpJRpoTuolLbYSm2wjMnPagIi3eIkTol0hBo9RhYCYpud905jRVMm4SDGxZmpB0BTdSPm3Tr8CFf4O0sNTYnULlz/bETqbHn/76tT1rv7qiNBobFu/YYVxjKx7xVAXgl9DQiNqYyPEtrXWiY3kgONqVliATvth5i8dc6jrRfrwbKrkVf2HMY3GK4Cf9TH8azx1SxPLkO7XOhp199yJIydVXMZKtwpHPvRrLMsCvZX3InDOrEUdFAyNp6e1R3VObUe+cpqcPP6tGHtVhoG0XhmLVkB4EsJrAFMzIh8Nd9jPJltVSv2yuFskm7k/fwSUmhu3Sj8lKoXyrgYv0zkk8GMq2pzkkEMaQen9z5YuEXrgsDtO/HW6q9cwV1Z+pI/FLOBuq+ndLTk9qQgZPmZ8YskZ7IUNq1GJEfUi9sCMp/KMT4QdWxDM9SZCiZ1apCikDKcMZsTXRrydFikMWAXYdVBtyywjFvi+Z9FtOt2EUZ8G8d311dniPz7jWCQPL4A4yqC450u1IEn4m+S+gmyDtDB6DdfWVkDY2JCBtdW2IdUeUqv3uPQpKg8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(53546011)(31686004)(8936002)(16576012)(4326008)(83380400001)(52116002)(38100700002)(2906002)(55236004)(107886003)(316002)(26005)(5660300002)(66946007)(508600001)(8676002)(66476007)(86362001)(956004)(66556008)(38350700002)(186003)(6916009)(6486002)(2616005)(31696002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3d5QnlVdnBndDlTWTdpSVoxZzN1MytlZVYyeWtKaXFjN2NiSHl0SFZncXQ0?=
 =?utf-8?B?T0FuQ3dwOUUyejZOald6ZmtEZWdzclBNOWhjcUl4bDhHZmR1a2RPSHB5azFr?=
 =?utf-8?B?ZEs3OVdDU1ZJeG9aZ3d5emZ1anFobGdZcEppQ05NNG55THZuU0lVaWxsNkQ1?=
 =?utf-8?B?aytNOS9CbHdEdDdBM1IwQjczdG4wR3VUS2I4YTYvb3FWOTFlaTQwa3RlUlRN?=
 =?utf-8?B?ZFAzOUg2M3RsZExxclBENXNUNk9BaGMrMVZ0Rlg2ZnpWTm9xcDM0d3RrcXNU?=
 =?utf-8?B?dEU5VDYxOGRiWEg4R0Y0NGNsZlVPbkNmUzMwb2NGNjlBNlRocVNaT1ZsM1do?=
 =?utf-8?B?UmVuZWtUQWZtUllPRldubUIrUjl3SXVsQXF6a3gydXAxeVZUV1RQSndLcnRu?=
 =?utf-8?B?WmREenNLUVNMbWg5SlJmSmRMcVZNSGtKVkRRUFRkUktaVlNVYnFJSVkrWisz?=
 =?utf-8?B?SEpEZDRkUk5JbjZSRWxSMndTbHBld1kwQnB1S1dJK1ZBT1hWNmFQUERkb0pZ?=
 =?utf-8?B?emRoZTJGMlRIM1VxN20rRUhaeVVIRHZPVGJJd0ZYN2kyUms0azFoK3RtaEFO?=
 =?utf-8?B?MDhtTzliUHk5ZitLYkdLTS85Z3F3NGZhNkU0ZEJaVHIwTmpMSEZGRklFbXlt?=
 =?utf-8?B?WVpGa083Q2RUQVlYYTBMWENwcUtDN0FjYVY2by81Mk9tN2FsamFsbnA3WXgw?=
 =?utf-8?B?dC8rMHR3UGxJRm5kam5pblhIZkFXUnZZQy9Bb21ya05kbTZkSUpiLzFNczZn?=
 =?utf-8?B?R09NSjV1ejJYRWE2T1FrbXpVUlh1ck1DUnIvVEl3WkRjUnNjQzlXUHUvbCtW?=
 =?utf-8?B?dWlzcHZKMzk4RXVnWXc0cEtwRG14Qmp2RzNZSEN4cEMxZm1FYk8xWkRYeDhN?=
 =?utf-8?B?TndrVFZpZXJ4T1QrMGx4a1kzVWFPdWRHcnQzVGs2NXg2WmdTTXRtcnhNY3hI?=
 =?utf-8?B?T0pJVEptalRXNTNvRXdZa2xLNDQvbHVBTUx5MEFPdmR1c0EwZ2pISGNaTTN3?=
 =?utf-8?B?bklqWE0vSGUzM3FRU2FjRldUT0s3dlVGRlhHaDhoenZZV003ZkU3QTRmWFdG?=
 =?utf-8?B?R0g1SUtLbjg4akV4R0ZZcUhHRklzZ3pRR1ZEL3JPcmtHemJqNXJJYnZyOEZi?=
 =?utf-8?B?SUg4bXlpYWY2aUNBQzRFOTBQMjFSNUNDM1QyaW40Y1M1ZGg5NUxjSGZuSldr?=
 =?utf-8?B?b2lxckI0UEJkOHZWZzhsR3djQmhqZHNyUzZWbi80T1VpZDI0bGhyMlZMaWRR?=
 =?utf-8?B?NzRmOTFSaG1wc1RpeU1JQUpiSmhZTWZRdlh5clNoeGYzQmRnbnM1VDVzWXl1?=
 =?utf-8?B?dU9tSmZqTUdaWGdoRi8zWlRGTjJrYzBuaklKOUR0NmlETzFjWHdaMDR6RGt4?=
 =?utf-8?B?Z3hFdUZYR2FZc1F1a0JOK001TU9iaFFKMDh1b00yNDF4Y05iZlN1QlJlQ05y?=
 =?utf-8?B?ajVRekFkTFdTU2xZSzlMWkZOczNZdFV3aGt2dTU0Tld4UmhJVVRnbnBqaFdo?=
 =?utf-8?B?ek1oZW5lU21KdjQrZDZSaG5WS1l6d1dXN0dZOXVwSGQvRWFINFpJM2tPMTc2?=
 =?utf-8?B?Q1NmTEJLMWthVllSSWZESnFPaXRzb1hWZFFvVysyUzVBdU0rWHcxTFFSaXBX?=
 =?utf-8?B?U2EyRXI5d21EbWk0K0IyRm9oSFFPWDFDdllwVXAxNndOTTBHQW5ZNWVoQWxw?=
 =?utf-8?B?K0duRnJYN3B4ejNLeU9aUFJVWDRDbmRrc3A0Rm1mOTNCR2VQbERmWC9Zc1Mz?=
 =?utf-8?B?L3RPeWJvbzczcGUybC82Z2JIQlgxMUI4Z0hnbGtzTUVtMkpzdm02Wlp1aEFS?=
 =?utf-8?B?bE10Y0FheFZWTk82VW9tOG1HZVZtR0h1SkZBTEtYb1plWXpxd096ZVBBSGIz?=
 =?utf-8?B?MWcxZjNKbStBZWR1aUU3WjFSSDM2YjZuenJwUVNJVVhKSEJpZk9XZFNETGY2?=
 =?utf-8?B?NFp1T0krM3dkSG9JNE8vY0ZRMGNNb2Qwd3cybmZXVU50WEFTcCt5MVBtV1dY?=
 =?utf-8?B?SzlwVXoyOEUwc1lhTnJLelhwVEZ2dTRaQmdibi9SZTdxRWFueGc5blJ0V0JC?=
 =?utf-8?B?OFFucUxkc1FiakpnWE85ZGg2SkJCOFYxcHdickRCYW1mTGdQS0QwTFFzTis1?=
 =?utf-8?B?aFpRdm5NTm94Wk5vV0M3V3J6MkFVc1dOQitLM3R2aDc1VzNRQUhkbHo4Mm9U?=
 =?utf-8?B?ZWNUSjRnb0FvYUdHMUtoaXRjbUtiaXJ3TlcwV05TaEkwWGYyT0lDR0M1eXpn?=
 =?utf-8?B?S0FBMDNnRDVEUmN3YTdmVCtENmozbThBR3FwOGZEVTZlNERrajVIZnNRRnlm?=
 =?utf-8?B?Z3Qvam1iMFNtL29sQVBCL0xpTDhrWlY0YTNMSFl5YXNzeXlCbXIvUT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67398a4-4473-4ed5-897c-08d9b0a1dbdb
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 05:59:07.5711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNtN3LCRFybr/fX0+CMJJGE3znTU7e9dzc0gKZON8DEOZs3DHwqWgKGpoZTdYH8SnJWl4+sWWszmsRH7C8qbGMb90ePvO6ODuZJzPSRhJZSVBGCLAGwDuDVniPh5J+bx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2379
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 25-11-2021 07:53 pm, Marc Zyngier wrote:
> On Mon, 22 Nov 2021 09:58:03 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> Commit 1776c91346b6 ("KVM: arm64: nv: Support multiple nested Stage-2 mmu
>> structures")[1] added a function kvm_vcpu_init_nested which expands the
>> stage-2 mmu structures array when ever a new vCPU is created. The array
>> is expanded using krealloc() and results in a stale mmu address pointer
>> in pgt->mmu. Adding a fix to update the pointer with the new address after
>> successful krealloc.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/
>> branch kvm-arm64/nv-5.13
>>
>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>> ---
>>   arch/arm64/kvm/nested.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>> index 4ffbc14d0245..57ad8d8f4ee5 100644
>> --- a/arch/arm64/kvm/nested.c
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -68,6 +68,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>>   		       num_mmus * sizeof(*kvm->arch.nested_mmus),
>>   		       GFP_KERNEL | __GFP_ZERO);
>>   	if (tmp) {
>> +		int i;
>> +
>>   		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]) ||
>>   		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
>>   			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
>> @@ -80,6 +82,13 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>>   		}
>>   
>>   		kvm->arch.nested_mmus = tmp;
>> +
>> +		/* Fixup pgt->mmu after krealloc */
>> +		for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>> +			struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>> +
>> +			mmu->pgt->mmu = mmu;
>> +		}
>>   	}
>>   
>>   	mutex_unlock(&kvm->lock);
> 
> Another good catch. I've tweaked a bit to avoid some unnecessary
> repainting, see below.
> 
> Thanks again,
> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index a4dfffa1dae0..92b225db59ac 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -66,8 +66,19 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>   	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
>   	tmp = krealloc(kvm->arch.nested_mmus,
>   		       num_mmus * sizeof(*kvm->arch.nested_mmus),
> -		       GFP_KERNEL | __GFP_ZERO);
> +		       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>   	if (tmp) {
> +		/*
> +		 * If we went through a realocation, adjust the MMU

Is it more precise to say?
> +		 * back-pointers in the pg_table structures.
* back-pointers in the pg_table structures of previous inits.

> +		 */
> +		if (kvm->arch.nested_mmus != tmp) {
> +			int i;
> +
> +			for (i = 0; i < num_mms - 2; i++)
> +				tmp[i].pgt->mmu = &tmp[i];
> +		}

Thanks for this optimization, it saves 2 redundant iterations.
> +
>   		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]) ||
>   		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
>   			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
> 

Feel free to add,
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>


Thanks,
Ganapat
