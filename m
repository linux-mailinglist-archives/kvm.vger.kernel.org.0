Return-Path: <kvm+bounces-11983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1418C87E898
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 12:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9392D1C21305
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 11:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7D43717F;
	Mon, 18 Mar 2024 11:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="ilzM5pPB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2130.outbound.protection.outlook.com [40.107.93.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA543771C;
	Mon, 18 Mar 2024 11:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710761306; cv=fail; b=qYSkqrs0RYPon8LHaI4K4sRYIvefnRw30WosxIkNVHGFzBTkLmd8K68ROck46iT1SDWDvMkiYPmBk3G8nt6D8iQFbVPTPM5d7MkHg3jQE8S2P7gn/GGiXxmBbckyoFJpgGNoETaMKgUZO2qUzgxZ/62Hq8pjPrUSjWojEJwEGsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710761306; c=relaxed/simple;
	bh=I+VcpaFDsZ64SAotA4PuNiadJ0Pnz+28E9bAmq86w6o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W9TAn4sjLU/2rmKAxZ1nehMRmiARUjHf9Hh8lq2ZS8LLuSdVzhGUm3RIxowguECYnfCQpHuJGc6vjz1ow6DLHbxSdQ2doFE3GW9vMvI6zRHIKJvUJ/246w7xD6W1XdbfS1z2hwF38RsJVqhIUZ7eXr/1R8X4vW3JBn2yL7cIM9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=ilzM5pPB; arc=fail smtp.client-ip=40.107.93.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6URwowporLEAfnpRmqyvHs4t5bNgMmxUfZa2zhaQr2Z3B7b7tV5Ruvwsh+hBw8HY/p7Ueg78XwEdCpyDXCEcaenLdj1tKudnCAPAWKuDuZE2hzP5CAi0ewwUIr9yCDZ+GI3iCsslAWhuIFsu5/KVaO7jJqkpvpTW5sxD3RFN6jtGYbLHJe6ZJKIWLsSpTuyF/yKVod8UXx4h8x2ApV2LzrDNRZbf0XuO0OltoZRyKjOtpR2yoSsYcGmx3h77YPIMga4WCubmA4rkGQWhhySzOmeBUYNW9eL9QajyRlwQqMHDSgaDg7v31JlZkoQl9bc9nYkCXxFbgREiN4D1hkYbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZfWYd0G6zzLE1H1//0Sl7XVJ/bm+xzAXfxMky0adwQ=;
 b=IjEsyoZdTHcGjV2VeVRWM0al6c6JrNVvF2/UijLAYIntBm1RIHsUHv5hxueVVge4I6OUWxVfKq19FinhkXWFcS2P/NnoMzcmxb3pyFR+1NhiYhL64frBZCIPk/AyJpBh8uqzi4n5otxWOSTMc55wkFTnn1GeBr3M6v5YDlWgk42nKz/XROWu7E928AT0S5Dultw+sqksmOlls/+n7Prv1SpWIlxJCTpQMTu9Xj0eNMjj3aLnTJvgaBXLvPll21yh9KMRKTtPfGuk0hpxK0ORZ4O4UOp2x6CBQz7hhRUlLmSF5PsP7M40382UFuHwuiWoYDtCOhpV2aUHV+85dCLDdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZfWYd0G6zzLE1H1//0Sl7XVJ/bm+xzAXfxMky0adwQ=;
 b=ilzM5pPBuCT3VivAwV1MWsiET4WSqs8IheWUvbNvgvWExf2ooxCiAbCgdcT93MyfqeRxKbyOHNYCuk5qUR8Xqr1U7IL4wJF5Kia4P8yJUe3aE/B66AP/pI2Eon+qgah0h0CvSW7dFSGFYVxuDjuTuJ5dU8mZFrr+AeO0pfvgMck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA1PR01MB8063.prod.exchangelabs.com (2603:10b6:806:336::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.26; Mon, 18 Mar 2024 11:28:21 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 11:28:20 +0000
Message-ID: <9ae4b453-4d5b-4537-b004-4db60183019a@os.amperecomputing.com>
Date: Mon, 18 Mar 2024 16:58:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 12/28] KVM: arm64: Support timers in realm RECs
Content-Language: en-US
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-13-steven.price@arm.com>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20230127112932.38045-13-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::13) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA1PR01MB8063:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f05b23-3df8-422e-e782-08dc473e8403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	33/jE95bPXjFkPJFYaJKy0fG7SDBmAS1TnZ/3+ENJNtugtwYj7DGYmBmeZH05fGU2UltgYaeHY1dMLsUjyfxAq4vIYzP04P9SFoYg++FlrJQeHu2KanQFT6Bpzul+EjpjRldG+y+v+l1ZMXepccwM6bZHhRcUjSdmVkftZzHKEorlLgl5S94ry0g78wrZxsGHb6d2w5XBlSUs2FFUk8ySK+TE1NRBajtodW+I0cS9ePIMQcLR8k92iubbuVhcsHCUqCkPupopOwFK4ptio/H9y07cYntGCE7G+87Dpy+Moz7x/ar+UmDccnIr+Q7OYfbulGTdUDl5s1sgn4nNukLj9XuRbuywamH7sci73eC7z50qLdpGa2m4PbXqAePoAB7mF1Lr3nO+PBgJnfj4YGcvpg2Ly0XBjnEyuADRew9cbM7ImiGP3bd7MjiqHmCgpzl0+Rzw0erViQmixAey1Unzk4hm2H/QniIvSMBJr+A7JPAh1oSaSwYdzgbns8WK6Mwj0ag0sndINrVkYTR9GtN0Y5VqtW/PNY+F+FZNqMqn4VhxvoKkccmGP1T8+mI1EYknOs0R033BkWRyVh90ryxlYHCLw04QyG0I3BtZWpKY5SvWBaqeCsXmUQ6VZpRsJlygrPr8P5i3qO/7ua9rpHRxucjh+DqReue1+ceTzK3A8s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnYvNWZHYzBuS1FKcHd3UTk4RnB4OUdoeW1Hdk9VNzQxM3NBaU1aSGt0QXZi?=
 =?utf-8?B?Ulp3TTNmazIzWjlaaVhnVVVpVmRuZkNua0hDTG5DQU04NHJ3MnZRZGIzbk42?=
 =?utf-8?B?dnpCMUNHL2Y1QnlPYkxkOXlGdVFrYllDcG5WcGp2TnFselhuSjU4Z0poVzRW?=
 =?utf-8?B?TDZkR0xMVmhDUGUrQ3FyQ2dJcXUraDNXbjE3dWs5VC9aVFlRSGhkb2F0TjQy?=
 =?utf-8?B?bnRRZThPRWR0UFp4RkgraS9Xc1I3RWFCcEdudklLRTY0cmhTdG1GUGFCT2pq?=
 =?utf-8?B?bnUzSTZEMVBXajJBeC9maHRacjQxV1pJWlFXb1pNWHRoSjRGSTVkVXRHT2Fr?=
 =?utf-8?B?MkEyZWJtK0NIc2QrZnhJWGRrMXpJaHpSTnBUZkdYdTZsVG9pU2tqTjNwZDRX?=
 =?utf-8?B?V0tTVGlrOWV0VFpRdDFTNXlKREZUSzNiNG1PaldPU29JOFRyMDltajR0clZ0?=
 =?utf-8?B?blBwWHZpaTR5MWxxNFd4bVVhS2NGeDdWeTdSZ3NnZkNhSEE3ZkljYUxFQ2ZD?=
 =?utf-8?B?YWRRbG9IYnAybk5EUWFkamtEUzBDYXErTnJVS2ZweU1HZFpsYkVMN0s1QVla?=
 =?utf-8?B?ZTJxdit4U0JlVjU3eElqWE10WlZ3NVdrWnZQVkhlYkJDcHZLZmV2Y1RtWlpM?=
 =?utf-8?B?VkZ4Ty9RRjQrb3ZFTjZpVmFFOVJvTmsyd21CTkVQRDh0RDhnYzRlYlR0Zm1z?=
 =?utf-8?B?MFZOVWhVUnloM2JyRHpqRTlqN1lMeVZmMTZaenVyVWRBRDhrbk9ZMjBjVFRV?=
 =?utf-8?B?WEErRk90MkNnMk9TNEppUGZUYXVRckN6YldPVDQvR05oblRrenZwM2FKakox?=
 =?utf-8?B?dU56ejhPbThlNVVEYldya1lOalAxZE9VcFRDM0RMMGg5bUNEVWpJVTNDaEtU?=
 =?utf-8?B?bjNvSng0bENEeGNuaHV4eVBFOXAvaElYU3BxbEUvMEVSTzRFVEJ5c0Y1WXpu?=
 =?utf-8?B?WGF2ejdhR1VORjFBSU5HMWNNd2hkV2YvRDErczhiYlF4aG5BckVwYWFZR1pq?=
 =?utf-8?B?VFNiU25xTy9wQ1puaWh6RTh0QTA3emRXNnYwYUdHeGxQKzh2Zk5menNDVFlI?=
 =?utf-8?B?S2VIZ2YxYngvYjZSOGkybFdtWmpJNGNGVTJ4cTE2TG9VczYyVDZHNW53cDkv?=
 =?utf-8?B?MmxGdGQ0aFVMYXZIcmlxMm44czdSSHJ4OXozMlYzd1pKQ2M2QWtXbmdTeCty?=
 =?utf-8?B?N3RpSlNMMFd3bjVlN05wcEtucXUvVUlqT1FVWURhYys1YXlQWVBQR3AxN0pU?=
 =?utf-8?B?bGtkVTJibVBzaHdPcnVaYnJ5UWhRWTM2VU5vbWNJbHZQejdjS2JHRmVjOWNa?=
 =?utf-8?B?VXEwV1VrMUU2eU8wR1p3SGw1VUxsQ2duUkdyRlJuWURDR3VWMlIrc2U0eitQ?=
 =?utf-8?B?YmtVZGpaUm85RnV5R0k0cnhyajhmV1hPZ2ZUVFYxTTRUK29Ebld1cDNobTlJ?=
 =?utf-8?B?ZG1taDNMcXVFZTBTbUI1ZlN2QXozV3h5YTQ2R1NMQW5BMy80eFdkbTB5N3Ri?=
 =?utf-8?B?OHZKQlJ0MDVJUmp4OU5aS0JKQm9FeGpyMzJqRHAyN2ZVRnZrK2JhYjJIbzRY?=
 =?utf-8?B?R1JPalRqOXlEeDhKTm5Ka2VDRkJMbkwwR3ZhdXBXVnA2Ujc0eFI4bTBZMm9M?=
 =?utf-8?B?aTc5UUU1b2tkemJ3TWNqdFpubU9xQUVQeFpTbXFLR3pLWXQ2c1dUNHFxdlJk?=
 =?utf-8?B?NDFMamNTTHNaRFFnMUozRVBOajNGYjBkSno2bytoTVNWNDZFT3Q0elM2U1ZN?=
 =?utf-8?B?b1o5MnNReFE0VDVCWThQMHd2bjZtZGpIR04yTTJadm9JR3Y1L0tjSjg2VzRr?=
 =?utf-8?B?alJuMW1XakNmaGdwNUdHNjdCVHlwNnhBUzY3V0p0MUtnSkk4azEySkt3S0Vv?=
 =?utf-8?B?L09uZlk3VFRic0Uva1F3d0pJVTIwVjBMZWRNakhpbFpUSXVjMEpwT1JjY0Vp?=
 =?utf-8?B?QjY1a1JheGRCNmdZY003RFZ6WGpPOERhakk3RFV1MWJZYkgxZzlGZU42UExK?=
 =?utf-8?B?UElrV0EvTDZmWmRianZhZnEvZlVkeVJHbnMzRUNxVGVIRHVHTWx3eG5xMzBU?=
 =?utf-8?B?dHJSU1huY0ZjbHo3WDBlbG1QNHpDcitTbnRIYUhKcllzTWNaSXZBRVRObGxM?=
 =?utf-8?B?dVBlcmJyMGRMb0hRbG5EbitPV3phSDlYZnRzenBWd1l0WG1MY3hOT2VIVU9w?=
 =?utf-8?Q?8K9T5Xlz/+/YEVRwLUjen1qgTjqzqVnA8PfMWLw9ho1a?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f05b23-3df8-422e-e782-08dc473e8403
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 11:28:20.9345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpeOGHg8Ouv+iQARbxdsgkrj6qu3DJBR8tssUtgiUB41uHmAh1no8DNqYnSWdzEYOg8SOLBh9szqWInQ+IoxE3Vry8z7fK8l0HxmmhXE4LhLM2yxi3K0GdMhYpQVcfsW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8063



On 27-01-2023 04:59 pm, Steven Price wrote:
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arch_timer.c  | 53 ++++++++++++++++++++++++++++++++----
>   include/kvm/arm_arch_timer.h |  2 ++
>   2 files changed, 49 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index bb24a76b4224..d4af9ee58550 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -130,6 +130,11 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>   {
>   	struct kvm_vcpu *vcpu = ctxt->vcpu;
>   
> +	if (kvm_is_realm(vcpu->kvm)) {
> +		WARN_ON(offset);
> +		return;
> +	}
> +
>   	switch(arch_timer_ctx_index(ctxt)) {
>   	case TIMER_VTIMER:
>   		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> @@ -411,6 +416,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>   	}
>   }
>   
> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
> +	int i;
> +
> +	for (i = 0; i < NR_KVM_TIMERS; i++) {

Do we required to check for all timers, is realm/rmm uses hyp timers?

> +		struct arch_timer_context *timer = &arch_timer->timers[i];
> +		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
> +		bool level = kvm_timer_irq_can_fire(timer) && status;
> +
> +		if (level != timer->irq.level)
> +			kvm_timer_update_irq(vcpu, level, timer);
> +	}
> +}
> +
>   /* Only called for a fully emulated timer */
>   static void timer_emulate(struct arch_timer_context *ctx)
>   {
> @@ -621,6 +641,11 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>   	if (unlikely(!timer->enabled))
>   		return;
>   
> +	kvm_timer_unblocking(vcpu);
> +
> +	if (vcpu_is_rec(vcpu))
> +		return;
> +

For realm, timer->enabled is not set, load returns before this check.

>   	get_timer_map(vcpu, &map);
>   
>   	if (static_branch_likely(&has_gic_active_state)) {
> @@ -633,8 +658,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>   
>   	set_cntvoff(timer_get_offset(map.direct_vtimer));
>   
> -	kvm_timer_unblocking(vcpu);
> -
>   	timer_restore_state(map.direct_vtimer);
>   	if (map.direct_ptimer)
>   		timer_restore_state(map.direct_ptimer);
> @@ -668,6 +691,9 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>   	if (unlikely(!timer->enabled))
>   		return;
>   
> +	if (vcpu_is_rec(vcpu))
> +		goto out;
> +
>   	get_timer_map(vcpu, &map);
>   
>   	timer_save_state(map.direct_vtimer);
> @@ -686,9 +712,6 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>   	if (map.emul_ptimer)
>   		soft_timer_cancel(&map.emul_ptimer->hrtimer);
>   
> -	if (kvm_vcpu_is_blocking(vcpu))
> -		kvm_timer_blocking(vcpu);
> -
>   	/*
>   	 * The kernel may decide to run userspace after calling vcpu_put, so
>   	 * we reset cntvoff to 0 to ensure a consistent read between user
> @@ -697,6 +720,11 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>   	 * virtual offset of zero, so no need to zero CNTVOFF_EL2 register.
>   	 */
>   	set_cntvoff(0);
> +
> +out:
> +	if (kvm_vcpu_is_blocking(vcpu))
> +		kvm_timer_blocking(vcpu);
> +
>   }
>   
>   /*
> @@ -785,12 +813,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>   	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
>   	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>   	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> +	u64 cntvoff;
>   
>   	vtimer->vcpu = vcpu;
>   	ptimer->vcpu = vcpu;
>   
> +	if (kvm_is_realm(vcpu->kvm))
> +		cntvoff = 0;
> +	else
> +		cntvoff = kvm_phys_timer_read();
> +
>   	/* Synchronize cntvoff across all vtimers of a VM. */
> -	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
> +	update_vtimer_cntvoff(vcpu, cntvoff);
>   	timer_set_offset(ptimer, 0);
>   
>   	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
> @@ -1265,6 +1299,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>   		return -EINVAL;
>   	}
>   
> +	/*
> +	 * We don't use mapped IRQs for Realms because the RMI doesn't allow
> +	 * us setting the LR.HW bit in the VGIC.
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		return 0;
> +
>   	get_timer_map(vcpu, &map);
>   
>   	ret = kvm_vgic_map_phys_irq(vcpu,
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index cd6d8f260eab..158280e15a33 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -76,6 +76,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   
> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu);
> +
>   u64 kvm_phys_timer_read(void);
>   
>   void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);

Thanks,
Ganapat

