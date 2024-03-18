Return-Path: <kvm+bounces-11978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4AB87E7EC
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 12:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CD031C21744
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 11:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32CBD3611B;
	Mon, 18 Mar 2024 11:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="pSURvjHc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2128.outbound.protection.outlook.com [40.107.92.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53014328B6;
	Mon, 18 Mar 2024 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.128
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710759711; cv=fail; b=lnZ3yIc7kCFtCueOSV7lkWytLZVwDRE7Z5lcjaw1XWnhG6bSf24u4yui802I7hf7nVYS50RbuXxPY4TzvBKd3sj5lBUxfjLhnPn6FB+QU5reOUXsRr+2/ULeXsWCXf+FlEc0s3Kl5YGZ3kBosIgMHvhs4du24/XL2sXNT/lfNe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710759711; c=relaxed/simple;
	bh=GM0p4sJZxxCOJGhyRXgi+CSJWdxGl+YFZmAYs4T7Vyc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K7/q5+0/mq8VOzlh5khaU3aLue3isyQnBNA+eClqG14uSSqanN6Y8wjZdKQ3BF5CSyM4mc54g8774hWnySi1MaawAFql4yl7KSf3IEH2wKlE72cI6JGdMdKkeBC9nbxmvG8RuZM1s542RgAq+2lPX/tOAX4XiO77YEOPVswGRrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=pSURvjHc; arc=fail smtp.client-ip=40.107.92.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HotgCD2wgCScTwhyShFEDTyDetSVoaJzxtoq3FG3F7QA1txh/Jw/rymR2W1Z5EOn2Y8LSTAkKpKQ1ET/q6+9LwZE/VtHYKmhpBOCvy+0MtUZQxD1aqZVTb6QflGBN7HnNTq86M2hzbuw/D/DkaC+McSVAcrROiR4DhN5rI/Rl9PPlI3Z3FfuyB99YXtAbS3dJ5vGwY63wiCbkZN7OD9OAZ0lHn+qXc/d0G2AzOh4u5TOBcXxBjj1iCkxVE62ZfXtjQtx4USGGen2ZNbtFQTr9mjqmsmNYSvXceFF1yAZo/+UXudA1CCPSJ9CIbWZAp1t9Uk5+UxzFvltypFGT7Idew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZDY5Vcrw+IqpvLuGMjmKB5JmIew6oL1QKwYVqiK9ZQ=;
 b=JL0iCM2u5+YJVAQxCQUv5U+jIwOaiCIb7nxyWjnrGmNBOaAXRmhXaShc/B5HtsvU6WwC64cLQcfmXfQdOzCIGjTwBsD+5JWc015nWrTxloY66Gro6cj7e/cNsBnGZkue8Ve0eHWOOqO+fPM1LU+hFpru+3ovg76RY59v8YBX2/jaP8UTLn1Kqa2oJyCBMysQfzC8OZ4fu/2TokFaMyEJyaobI+b+eyX99oXX95b3QjxsgJw7VnV4+eR38YvGNQ35p3V4FQHujXMTxGDGwAXy1UKUVRUSLDVQXghK4oOz1M12QYdqGwMjTxG6KcP2X4rhXUc/vGvmxC3e1uncQ8er4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZDY5Vcrw+IqpvLuGMjmKB5JmIew6oL1QKwYVqiK9ZQ=;
 b=pSURvjHcXHjhV6WQaPCTSoEpqO74GMMhvl6P+3Tp5hDQFFR9R3qYflPrDX1xvKJFIQJj/NhDoMT7HSP726nRQsp4xnZaytImowC9fv4YGwrc0M1X1/5XFJuWUKPJuzXFNpDyKoLT9xPHKbEkPf0eriiRxvn5ae0kw0rALbohmwE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA1PR01MB6797.prod.exchangelabs.com (2603:10b6:806:1a6::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.25; Mon, 18 Mar 2024 11:01:46 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 11:01:45 +0000
Message-ID: <84bb27a2-0649-4ba4-8f31-baff7b3a9b3a@os.amperecomputing.com>
Date: Mon, 18 Mar 2024 16:31:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/28] arm64: RME: RTT handling
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
 <20230127112932.38045-10-steven.price@arm.com>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20230127112932.38045-10-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0040.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::20) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA1PR01MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: 840c9568-67d8-4efc-dbc1-08dc473acd31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VX3WJ625SBFnngRW5VPOwcvrf8Jr0YwU6bxyd34utdFc3qld7+TXjivz/iRn+CEWXEwm7b4CTUx+5/rqwmG2QFIU8m7z8rf9NLSWKeFqc/JJZq2JSYm1CDm1MsaJ+5/m9GtXG0je1pfm/G+y9IKADFu6ZxCYLr2y6m3SU3GSerPX4r8qNebG5KuYFmhxyiWv3UyRdbfi1CFRCM1khmQcel/zijfhmx4pEWgmv4dgxe3B2AwVvKMjWSUDagZpqX+b1sJMLZbqSqJr1lY1q/YQBHapVdUbgjy8cg37bvSeylv2f9sKXCp/OAZi7BS1QxFxWX6/UOdl7zYxxCJsR3oJx5uyTSqdphlaGxGYncHwxiMRyq6NkSAObhhIiFJLwvOlMd58DBAjITKyaWr+PTYKDZYTW5nfJoF9VxQM/4czb7lPWdpzTugpgpb5z2XFB8TmYUIMOiax5aK/jpuwdtW39uIPvmNbSUtmo5tmFsz+yR3kJErPBNqf0XxuiXvCfHwMF/9eXlsN2Vu7vUp3vGrAHvWwDdF7IoxLGU7Htee1qzP9r3lZyIR9M192Is/KXQS7Z/2GsgoLzgPtAtmWfrnIQfjJ2YCdartuWg0aQaYhyUnIEm9fs/gu/9shnQAYFyAy3jHfYKOcHAobq/TMH0rp2CCpYCvTf3ql6JUqyzROppM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3FCc2tRdFMxZ1dIM1BHRGFJaC9vRk5yeUVvcmljaUpkMklSVlM2ampMY3BT?=
 =?utf-8?B?MmRrWGQ4RGdPb0d1bkYvL0Y0OVR3YXBOQmMzQVNOTmtsK3lZaDBVVWd3TGtv?=
 =?utf-8?B?MVpyN0NJMkllQVJneHYzd0ovQlN1QVllaXlobVY4blh5N2h2VzNYSThGb2Fn?=
 =?utf-8?B?Z0U4c3FZamw4WGFZSTg4b3UwUjladis2dzZOSkl5NTh6N1BuK3BITnd4TVZy?=
 =?utf-8?B?V0F2UGVCUnZKbkhPOGdJK0Q2V3VnVmtxZ0NEYkp3VjRNaWdMTFBncGpDWUlT?=
 =?utf-8?B?bWhlbWJxQjdHSjRJTTBiYmpHQ3RMTHIxa1BEdEhrdnYzNlBpWHJ1TjdFNDFW?=
 =?utf-8?B?Y2M0TjBFS3VQNWdRQTdDbng0R2ZBclZ1M2tSTmRxdWJOME1hamRzLzlkWThp?=
 =?utf-8?B?WWhQZkVzRk5JcTlvS1FiWWx1aTZEdEtDT0NrRGVNbGpsS0VtWElJb29mL0Y4?=
 =?utf-8?B?amhrV2JGbmJaNEh0aWZQSSsxZ3dGVll5RE5QcGFTQ2VLZm40d0ltRmN0bmFI?=
 =?utf-8?B?Tm5TckNIVm9rTjliTitnR01DdW5zSTNiUEY2ZXR1bWFvMVlLWnlOUDhuOENP?=
 =?utf-8?B?R2ZjWm1tbDFpM3JxYjNMQkhsZitBc1dpTFBDbGFFeEJ3MlV3cFlobE1RMU8z?=
 =?utf-8?B?aGppZytzTDNaY1lTTk1iYnVPcTVrN21KbitjZ1RZU2pJdFZhWU9vMmt3RmIw?=
 =?utf-8?B?cGpnZVZBenpEQU50MWk4a2dyWjZMcFZnYjN2WnV6S2gxMU5BVnBZWGRjYzRr?=
 =?utf-8?B?cktXUEZZZURmVGxJajBQckp2Zm5ZWHJrV3lDTkQwV25yc2NXa0Z4TGRlcERt?=
 =?utf-8?B?ckdzWDUzM3hjZksrTjAyMk1lcXFsQzJ6Y0lLem5meEFzOWt4dk1PaUF0YkY2?=
 =?utf-8?B?KzJGTmVKbjdCRGpmMkhVRFBocWN4c285V1NJNit5eGFjTWFOd0hpS0RTOEFh?=
 =?utf-8?B?SjR6RW5VTjNwcmpTR2VuN3Y4Sk82L0g0dWdaUStCUzllT2d0RGsxNHRNQmx1?=
 =?utf-8?B?VkZlWUV4bHpNNEdYU0E5NVlGaVp4RWpGaVorVVBXUGtFT2hhTlJaaUVmeTFz?=
 =?utf-8?B?MVJMcVhYcURReElSeFM4b1ZQK2IydFp5MndhOGNub3pUdlRVYXE1Z3RtYzdz?=
 =?utf-8?B?eEpxa2pBOG9XYWNlWW5KQjhwYTBSK3N0a25ZRXEwc3dsTnNqLzVaaTBKK09Q?=
 =?utf-8?B?MGFJc0xncUhXekFvS3VZYUs1QmEwNllFb1Y3aDJ5Y1V6R2VHd3ZXSWFMZG1x?=
 =?utf-8?B?WDJJSzFMbGZDMk1xRk9VZFh3Rm1zNlRFMEh4ancwTkljR1RXbkZicWpSS2p2?=
 =?utf-8?B?Z1haN1VjNGpCMFRDbFZ3MlFxdWo1UHRQUzhycWNFaFFSekgyZGdtTVI3U1lO?=
 =?utf-8?B?NmdWbVB6L01hNWpnbndwRTl2Z3c0bTBCNFZSZU5aSUZzZW9pUEFjd3RQa01u?=
 =?utf-8?B?bFd5eHlJSVUvMmFRclBIaWU3R1FlNjB6UTZtdndqeW00d0NWbFRUZjNGNDhm?=
 =?utf-8?B?L3dDd0xKNEZuME9PdmprbitSRTVJeUZRREZrK3EyNHBxYUxEZFV3Y25jdzRo?=
 =?utf-8?B?MDNZMS9jSXJ0UzF4T09XSzdieTNHak5hMXMvcXpNRmEvcnNGUnJ0K3RxNDhh?=
 =?utf-8?B?MTdkYXlxVFV6RVZxaVZ1SHJoMklPL0VUOFFocUNtbE5SL2dFRFNKeW9GYlVO?=
 =?utf-8?B?NjZnV0o4VFE2Umowc0RmbXh4TUFLUXViUWl2eE84bEZIanZnVGM1dUR5OEM3?=
 =?utf-8?B?U2ZSOGxweXFXOGlhby9MaEFtZ2dQM2tINkQ0ZWZVTWh3Y3ovNzNVMDNGUVpm?=
 =?utf-8?B?SFlIUDZPQlVxRnlMeFZ1Rnp4VTFEQlllMDJiNmgwVjM3MFgyaG9iU2Jmd0k4?=
 =?utf-8?B?em00QmRkanl6ZkVzRHRqcVpRWVU0bVB1TENqZ2ZidzE5bjA5RDBnVFhuQ05w?=
 =?utf-8?B?NnNPSVM0SHhYVHA3eFJuMTE1c2IrVmhpTkY5VWh5ZGpsak1kR0pWcDJWd2h1?=
 =?utf-8?B?eitGdy8zeTRmTUQyc3ZCRzh3cWlKNHAzVGY2RTVZaldyMG1SdW1jcjI2WXBy?=
 =?utf-8?B?R0hMcEl2WEgzVmlEM3lBQm5GV1JJTW1VSHhCd2Vya1B2WkFiUm5DOXlDYzRY?=
 =?utf-8?B?VGZvdVNSMHliTVhLYlFsdGNaMWx6bUY2STBBSkFaMkwrZGtWT1RYajFJc210?=
 =?utf-8?Q?KdkiKk5AkqUH3qpIOWqXTFCIEYyhDLWjs5qj5ABt1DAx?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 840c9568-67d8-4efc-dbc1-08dc473acd31
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 11:01:45.7363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UaMyPaTzvK2PLWMnDCa6jzQyERMvVANxPuMXC7vq8MV5C+dhw6MaV2qboT5TFEwYk1IGApCqMksaL40bMOuQvufQbPkj+loIKF7yZB9CBWeqGPe9CKsiclssRTmk3JUD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6797


On 27-01-2023 04:59 pm, Steven Price wrote:
> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  19 +++++
>   arch/arm64/kvm/mmu.c             |   7 +-
>   arch/arm64/kvm/rme.c             | 139 +++++++++++++++++++++++++++++++
>   3 files changed, 162 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index a6318af3ed11..eea5118dfa8a 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -35,5 +35,24 @@ u32 kvm_realm_ipa_limit(void);
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
> +void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level);
> +
> +#define RME_RTT_BLOCK_LEVEL	2
> +#define RME_RTT_MAX_LEVEL	3
> +
> +#define RME_PAGE_SHIFT		12
> +#define RME_PAGE_SIZE		BIT(RME_PAGE_SHIFT)

Can we use PAGE_SIZE and PAGE_SHIFT instead of redefining?
May be we can use them to define RME_PAGE_SIZE and RME_PAGE_SHIFT.

> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
> +#define RME_RTT_LEVEL_SHIFT(l)	\
> +	((RME_PAGE_SHIFT - 3) * (4 - (l)) + 3)

Instead of defining again, can we define to
ARM64_HW_PGTABLE_LEVEL_SHIFT?

> +#define RME_L2_BLOCK_SIZE	BIT(RME_RTT_LEVEL_SHIFT(2))
> +
> +static inline unsigned long rme_rtt_level_mapsize(int level)
> +{
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return RME_PAGE_SIZE;
> +
> +	return (1UL << RME_RTT_LEVEL_SHIFT(level));
> +}
>   
>   #endif
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 22c00274884a..f29558c5dcbc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -834,16 +834,17 @@ void stage2_unmap_vm(struct kvm *kvm)
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> -	struct kvm_pgtable *pgt = NULL;
> +	struct kvm_pgtable *pgt;
>   
>   	write_lock(&kvm->mmu_lock);
> +	pgt = mmu->pgt;
>   	if (kvm_is_realm(kvm) &&
>   	    kvm_realm_state(kvm) != REALM_STATE_DYING) {
> -		/* TODO: teardown rtts */
>   		write_unlock(&kvm->mmu_lock);
> +		kvm_realm_destroy_rtts(&kvm->arch.realm, pgt->ia_bits,
> +				       pgt->start_level);
>   		return;
>   	}
> -	pgt = mmu->pgt;
>   	if (pgt) {
>   		mmu->pgd_phys = 0;
>   		mmu->pgt = NULL;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 0c9d70e4d9e6..f7b0e5a779f8 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -73,6 +73,28 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> +static void realm_destroy_undelegate_range(struct realm *realm,
> +					   unsigned long ipa,
> +					   unsigned long addr,
> +					   ssize_t size)
> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	int ret;
> +
> +	while (size > 0) {
> +		ret = rmi_data_destroy(rd, ipa);
> +		WARN_ON(ret);
> +		ret = rmi_granule_undelegate(addr);
> +
> +		if (ret)
> +			get_page(phys_to_page(addr));
> +
> +		addr += PAGE_SIZE;
> +		ipa += PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +	}
> +}
> +
>   static unsigned long create_realm_feat_reg0(struct kvm *kvm)
>   {
>   	unsigned long ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
> @@ -170,6 +192,123 @@ static int realm_create_rd(struct kvm *kvm)
>   	return r;
>   }
>   
> +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
> +			     int level, phys_addr_t rtt_granule)
> +{
> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +	return rmi_rtt_destroy(rtt_granule, virt_to_phys(realm->rd), addr,
> +			level);
> +}
> +
> +static int realm_destroy_free_rtt(struct realm *realm, unsigned long addr,
> +				  int level, phys_addr_t rtt_granule)
> +{
> +	if (realm_rtt_destroy(realm, addr, level, rtt_granule))
> +		return -ENXIO;
> +	if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
> +		put_page(phys_to_page(rtt_granule));
> +
> +	return 0;
> +}
> +
> +static int realm_rtt_create(struct realm *realm,
> +			    unsigned long addr,
> +			    int level,
> +			    phys_addr_t phys)
> +{
> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +	return rmi_rtt_create(phys, virt_to_phys(realm->rd), addr, level);
> +}
> +
> +static int realm_tear_down_rtt_range(struct realm *realm, int level,
> +				     unsigned long start, unsigned long end)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	ssize_t map_size = rme_rtt_level_mapsize(level);
> +	unsigned long addr, next_addr;
> +	bool failed = false;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_addr, tmp_rtt;
> +		struct rtt_entry rtt;
> +		unsigned long end_addr;
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		end_addr = min(next_addr, end);
> +
> +		if (rmi_rtt_read_entry(rd, ALIGN_DOWN(addr, map_size),
> +				       level, &rtt)) {
> +			failed = true;
> +			continue;
> +		}
> +
> +		rtt_addr = rmi_rtt_get_phys(&rtt);
> +		WARN_ON(level != rtt.walk_level);
> +
> +		switch (rtt.state) {
> +		case RMI_UNASSIGNED:
> +		case RMI_DESTROYED:
> +			break;
> +		case RMI_TABLE:
> +			if (realm_tear_down_rtt_range(realm, level + 1,
> +						      addr, end_addr)) {
> +				failed = true;
> +				break;
> +			}
> +			if (IS_ALIGNED(addr, map_size) &&
> +			    next_addr <= end &&
> +			    realm_destroy_free_rtt(realm, addr, level + 1,
> +						   rtt_addr))
> +				failed = true;
> +			break;
> +		case RMI_ASSIGNED:
> +			WARN_ON(!rtt_addr);
> +			/*
> +			 * If there is a block mapping, break it now, using the
> +			 * spare_page. We are sure to have a valid delegated
> +			 * page at spare_page before we enter here, otherwise
> +			 * WARN once, which will be followed by further
> +			 * warnings.
> +			 */
> +			tmp_rtt = realm->spare_page;
> +			if (level == 2 &&
> +			    !WARN_ON_ONCE(tmp_rtt == PHYS_ADDR_MAX) &&
> +			    realm_rtt_create(realm, addr,
> +					     RME_RTT_MAX_LEVEL, tmp_rtt)) {
> +				WARN_ON(1);
> +				failed = true;
> +				break;
> +			}
> +			realm_destroy_undelegate_range(realm, addr,
> +						       rtt_addr, map_size);
> +			/*
> +			 * Collapse the last level table and make the spare page
> +			 * reusable again.
> +			 */
> +			if (level == 2 &&
> +			    realm_rtt_destroy(realm, addr, RME_RTT_MAX_LEVEL,
> +					      tmp_rtt))
> +				failed = true;
> +			break;
> +		case RMI_VALID_NS:
> +			WARN_ON(rmi_rtt_unmap_unprotected(rd, addr, level));
> +			break;
> +		default:
> +			WARN_ON(1);
> +			failed = true;
> +			break;
> +		}
> +	}
> +
> +	return failed ? -EINVAL : 0;
> +}
> +
> +void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level)
> +{
> +	realm_tear_down_rtt_range(realm, start_level, 0, (1UL << ia_bits));
> +}
> +
>   /* Protects access to rme_vmid_bitmap */
>   static DEFINE_SPINLOCK(rme_vmid_lock);
>   static unsigned long *rme_vmid_bitmap;

Thanks,
Ganapat

