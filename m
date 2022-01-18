Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1616C4924BA
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbiARL3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:29:11 -0500
Received: from mail-dm6nam11on2136.outbound.protection.outlook.com ([40.107.223.136]:9024
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233893AbiARL3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:29:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAqcKGi03qhL+eI/Ott8AwIxYp/cbSs7I8xqsZqa6i3arlHs7prG1Uv3JAXaqdC0cGPqHgUZgcoHOQDmqATF+F53nwMkr+xOvde875VPO2OL9FJJ7IzP0HoBogSrTPNuALv8RCdRV+TYbAqgxq7T1hcDJkgtOaLuX2dWEo4DK7Ub/oVXXE7YclXOfPtNSz9ccY6Bco2SoGcCCilxL8O41u6ZFgzBoreZ6Hp0hqX5OPYsETpbV91LuO+u7g0OwZ40NbKcEOXUFpYrf0Ahgrq+7MpKX23HXBgY3/5+YxUHJy8xB7/TE1IbUFDN5L0fbqLkMUy0qLzqX3SxYiHgIHtzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sepb/7fGHtYjOzWWfZ8RjEw0/PBaVghM84Sz/ZvZZuc=;
 b=CvUKjvBYzmuUUgE9ZNcASE23olHgheLhu9yTy+I+lKnWfcG4wDbIw0UZ+/7KURB1LkHvqowyBsrs4cr6oB1ChvpxL6LnkkjcXWGkOc1d6/Q8tZNn1n1C585SqiZmrKZaNdf6jcMDPq4VFbAR+8Tis28zzJyLIJ4vxK38xYAzqJiBZsmn2+Oqgun5iMmxxClMdWOyBzmvUd43yFDFvzaBtiZQllT5MpGZJDRvT+QjcYaQizUEx3Bu0ZJRwMfMZ1csJpGx18Ycenzccz6pwPYI7+9lWWRcnmsuhjiNv62br7pVVbNRR7h7/Tv8I0dGNb58DVVANa5ZA65u4ccPGKlh2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sepb/7fGHtYjOzWWfZ8RjEw0/PBaVghM84Sz/ZvZZuc=;
 b=QtbZGnUOA3Hl2cJYd4+v+Qr22hBwWBq8XmvB6V8CUdNUM1EuF+we1Rwos4uDC97ljbdlvsvevxdV3SqjRGYKsow6s0gRvrlO2sduG0lEyAxWqNpH/tKxkeiDf4Oli+hf1qCKOHsMP+dlGAqCcMXVelkvFTrJ40eJkax7riBnk5w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 BN0PR01MB6957.prod.exchangelabs.com (2603:10b6:408:16c::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.13; Tue, 18 Jan 2022 11:29:07 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01%8]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 11:29:07 +0000
Message-ID: <a70a4d4a-c036-615c-4076-fe0753bcd810@os.amperecomputing.com>
Date:   Tue, 18 Jan 2022 16:59:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 44/69] KVM: arm64: nv: Set a handler for the system
 instruction traps
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-45-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-45-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:610:b3::34) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8afa3f40-1c57-43cd-19ca-08d9da75bd9e
X-MS-TrafficTypeDiagnostic: BN0PR01MB6957:EE_
X-Microsoft-Antispam-PRVS: <BN0PR01MB6957ADEB023A87174ADDD2AB9C589@BN0PR01MB6957.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bX8QzyhDMazzFRfaJ1iYdtaE60dQPZ+j5UAxzmOTDvhbbdwYDthyraQEtcAVcU2Rd012x6B+qETZt4oDTW3lBRTavpEJId+9tqpqOfNsDDyJfsfzRZFT0+il8gwUVXFdlWDD7FUoDPcaoHnspWMO01/mX4ufobux6R6KEq2Juo8ZX7AuYmLz7DaDQ6La43C8qH183rjFBN7JbbxtFjYBTxfEVKLjnbasmaJSSAHo08BgKhtqcAjJ4L1jrL9U2gsSjEM3Ff3wwpYlXECIFIz92i83DIxH0Gx8TBntD75rP5j7V/9koJfCcyLsGslpFVQKe4uhfOqQxGhFPJrUsTIhCfpJaVrEAfW8mgACytOUGCzuMT/uJn0m4/lz9uLCyPQCEKmWPV2o/60czJHHjySEqCJS/fy4OFSRL5CtZoLzU9fk6Xn1cU3LcUNzg5S8UqZfK0fdVFzH46ee29A7SNuLJ4/lV9Ug/CaAL6ctmGx02PSgiw67jxNxO7x/OyggfS2e+4OMl7N7h2RJlTWOgPIwyg34cvX4esfbnaaRI3Hl6ohMiDir7ZuPvgrF3CRhczG4o0jXr6Hn5DBxOCjH4+43LB14/ATJGIF/GKVcC2a+wTCg8MkCEE+rBownumKxylWB0Fo5EXyix2BBE6W4/Av4TsJqv80aPFaB8xncsctAW15XlR7oGcb+1GFdDCIqE+2P9oWvT+gCv6zzJfgQDUj+3dlo4fdLHihXfgk/+0jnBW4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(2616005)(54906003)(6486002)(5660300002)(8676002)(8936002)(52116002)(53546011)(6506007)(86362001)(31686004)(31696002)(26005)(66476007)(316002)(66946007)(6666004)(508600001)(66556008)(38100700002)(38350700002)(2906002)(4326008)(186003)(83380400001)(7416002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGZlWFlXd2t2RDJPYW9WSS8xRi9aR3BrREZidk0wMnhlWElOTlpFYnB6aGFj?=
 =?utf-8?B?UHFiVUNWWGh2cEY5aUd4Rzg4cWpucVMwUy9lRkNSUlJSbkpPVUFuR2xMNXJ6?=
 =?utf-8?B?L3FZaWJTcHdzeHdqM2xPd1VXT1I5Wmp3ZjQ5di9NM2dVZ3RmaW83WTBPdHNz?=
 =?utf-8?B?bmkvS09welJRdUtKUGVQaFVMdjBkdm85MHV3b1pPYWhpbmlwWWR6VHNobEtE?=
 =?utf-8?B?S2lZdzlLUktpaVJKYXFENEQrYUxsVkFlOUJENFkyQmNqS1dlR2k5QXBjSkRk?=
 =?utf-8?B?UkkyY3NCcjFzdVEzbFNOTzhGOVcvK01zZVVtckJRV2REZDRXejNOeHIyMGVh?=
 =?utf-8?B?OSt6WXpTV3lWckIyY1QxbVlpWTUrcDdEYkNOK2FHUG9SbjJXVjByWEdhUm1D?=
 =?utf-8?B?bmRQVkltb1dqdEw1SzZuc1g4Z2w4WUtDdHg3K2c1YVh0MWJ6VG54VnVSZDY4?=
 =?utf-8?B?a3dxTjZvOVNrYllvMDlnZElaRXNjUDFQMy9XT2xZekdkU01QaHhLMm1UQ3JL?=
 =?utf-8?B?aXZiSU5NanFJNnFpVmM1NHNSVmUzaGM3WkxQOGdKMkxhd1N3SUZqZkt1S0lv?=
 =?utf-8?B?RlNHbU41N09uUjVoR2k0Z2Z1cko1ZUdSNkxKdHdwNlNKa1U2enVoM2l4UWtu?=
 =?utf-8?B?NFJiRGJHbnZsL3lUREJJb2VmM2NqREdrT3k5QVdVQ29TeEpUM1lIcEtHUHhj?=
 =?utf-8?B?dlpwWWdpekJtbS9iZ3p4WFBIUFVjZlU4OGNWK0Q1TUFxVXBCckxXeFltOGYx?=
 =?utf-8?B?UDdJRUNsRjY4ZFplTUkvRVJwNHpzQjMxS2RSaWZ6dU5HWGNhamNtaE5kcVc1?=
 =?utf-8?B?eWgzdUtmeXpiOEtyMHR4Ti9FeU9NdTFpdjRNam54RDVjTDJXZnFQK2tDb0xh?=
 =?utf-8?B?MC9yQVhnR0hpblowZFRPSkhEd1UrNWxrT1dDRWxaT01jTFNlQWNHeVpZSUUz?=
 =?utf-8?B?M2dtbWVIWWIvWHV1b1U1eU9LV1FtbDA3NUNwblNFUDdGd3NoUjZjR2xqME5y?=
 =?utf-8?B?V1o1YVhSU0JUTUwzd3hhSW0wenV3QWZnUGxITTN2T1BQWHU0MUNjUlNvMG1R?=
 =?utf-8?B?VTB3UElsTCtzS3VtVU10YXh5YXBxY2owMUU1eTZyb1pQSVIwTThTM0RGTTBj?=
 =?utf-8?B?RFFIbFBYVXdJd0pQMjBmU2tHQWJxQW5XSjhRYkpCQXhMNWxIRm1ITkNWOUhD?=
 =?utf-8?B?aGY1STdpeDZMQ2xmK09ZUVZsZjJtZXYreW93K1R5b0ZVVENVZnJzeTd4QmQy?=
 =?utf-8?B?M2R2QkR0ZXlGRWFLbGdmb25aWC8ya1FRZjVzTVYvWHkxVHlFd2ltQVlCbkg2?=
 =?utf-8?B?VWdvaGdFdFMyMEs3cDErUXNGZmcvcTBFMTV3L2xrcnVZM1NKanF3VXhFQzJL?=
 =?utf-8?B?NkRvSVc2eFRObEJJWDJNTkg0VnpSOFlweDdZcXpHREdwczc2aXN6N3N2b0cy?=
 =?utf-8?B?YTZPTVhrOEo1RFkwNU5FYk1DSHUrS0NiL2c4QWxzTFMvOXIyN1hxSXlKY1Na?=
 =?utf-8?B?QWhKT28rWTBOaDZ2aHVBUEJQTGppRTJQWlAxRUR3N1llWlpTWDdMVkhKeFdj?=
 =?utf-8?B?bGJIdFpOU2szaFRBTkVEMVNOMnZoczQ0cGZGTitPTVZrZUVjWmFuNzNiVEhD?=
 =?utf-8?B?eFFHNVUxWkhsUlhlZXVOM3RmRHZlaWl6ZC9NcEtINUpDMFhVUlRGR1MvMUx3?=
 =?utf-8?B?Tlhocks0d1ZYWWVraXZaeXlIaTE4Zk44Q0tvV0k0MUd3WUl5dm9sRVo2anVl?=
 =?utf-8?B?NG5IbW5TN3E3bHZnK2FsOCtFZkkrRzYxSHoveWd2U3M4WlJxcUs2NjZkVS9Z?=
 =?utf-8?B?V3o1UFVVcXY1RngwNzZaRGhIdVdOZlgyQU0ybit6K1BIdDF2dWcvcWtxdEVH?=
 =?utf-8?B?ODU4SWdlY21DanZTK1ZaRVVpaFpySS8rZXVvUGpoUGpOamxkUDkvQXovaU5Z?=
 =?utf-8?B?bmE5c2xGTmkzejNUUFlzZHZldVVDOTk0bkZrZXJ4c2wyZ2pIMDFOcWVhQmNH?=
 =?utf-8?B?MVJXYUN1Y3VnYTM2Q3FwVXA1Mk1ZdFJ4ODdodVAxdHhTdE0weGZzWkF3Mktq?=
 =?utf-8?B?N1ZYc3hHT0I5Y2JMdVhHQVRNbE9mdmY5L3ZXUUw0eVJORldhN2lJRDN6RVVN?=
 =?utf-8?B?N0Faa21KZGp6NFhvdndRTnZjTW0vTFFXUUtxR3pGWU5GSFFxeVRtczJWdlpQ?=
 =?utf-8?B?MVFPL1ppN0k3d2t0bkdzL3pBWnFudUExTkhSMzlna0VYVEloa0dBUzVxTysv?=
 =?utf-8?B?OEVsckhlZC9aZktQQTZGVlptcVJ6eGxZNlppRWErWkQyZUV3cTltZUdLMlZv?=
 =?utf-8?B?cGRnc3J6NmVhbDBUL1pXSlllbXJuK3lIVFYxeHV0MlcvUFd4b3ZYQT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afa3f40-1c57-43cd-19ca-08d9da75bd9e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:29:07.8013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAjuEBUCM9kMqz44hkrAboOKWaGf6aE57VXlvKUIygP7IMW3Ow8eNSPt1DwNqtrcGPo+FoAWXfDRaN2Y138mtQCFKVgWOXCvmpU/aS9josP+rkBiTkdA94ORZbGaTZ04
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6957
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30-11-2021 01:31 am, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> When HCR.NV bit is set, execution of the EL2 translation regime address
> aranslation instructions and TLB maintenance instructions are trapped to
Typo: translation

> EL2. In addition, execution of the EL1 translation regime address
> aranslation instructions and TLB maintenance instructions that are only
Typo: translation

> accessible from EL2 and above are trapped to EL2. In these cases,
> ESR_EL2.EC will be set to 0x18.
> 
> Rework the system instruction emulation framework to handle potentially
> all system instruction traps other than MSR/MRS instructions. Those
> system instructions would be AT and TLBI instructions controlled by
> HCR_EL2.NV, AT, and TTLB bits.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: squashed two patches together, redispatched various bits around]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h |  4 +--
>   arch/arm64/kvm/handle_exit.c      |  2 +-
>   arch/arm64/kvm/sys_regs.c         | 48 +++++++++++++++++++++++++------
>   3 files changed, 42 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 00c3366129b8..35f3d7939484 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -411,7 +411,7 @@ struct kvm_vcpu_arch {
>   	/*
>   	 * Guest registers we preserve during guest debugging.
>   	 *
> -	 * These shadow registers are updated by the kvm_handle_sys_reg
> +	 * These shadow registers are updated by the kvm_handle_sys
>   	 * trap handler if the guest accesses or updates them while we
>   	 * are using guest debug.
>   	 */
> @@ -729,7 +729,7 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu);
>   int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
>   int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
>   int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
> -int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
> +int kvm_handle_sys(struct kvm_vcpu *vcpu);
>   
>   void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
>   
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 6ff709c124d0..8b3b758e674e 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -234,7 +234,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>   	[ESR_ELx_EC_SMC32]	= handle_smc,
>   	[ESR_ELx_EC_HVC64]	= handle_hvc,
>   	[ESR_ELx_EC_SMC64]	= handle_smc,
> -	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
> +	[ESR_ELx_EC_SYS64]	= kvm_handle_sys,
>   	[ESR_ELx_EC_SVE]	= handle_sve,
>   	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
>   	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 77f07f960d84..222f8c6f1d7e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1770,10 +1770,6 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
>    * more demanding guest...
>    */
>   static const struct sys_reg_desc sys_reg_descs[] = {
> -	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> -	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
> -	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
> -
>   	DBG_BCR_BVR_WCR_WVR_EL1(0),
>   	DBG_BCR_BVR_WCR_WVR_EL1(1),
>   	{ SYS_DESC(SYS_MDCCINT_EL1), trap_debug_regs, reset_val, MDCCINT_EL1, 0 },
> @@ -2240,6 +2236,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },
>   };
>   
> +#define SYS_INSN_TO_DESC(insn, access_fn, forward_fn)	\
> +	{ SYS_DESC((insn)), (access_fn), NULL, 0, 0, NULL, NULL, (forward_fn) }
> +static struct sys_reg_desc sys_insn_descs[] = {
> +	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> +	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
> +	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
> +};
> +
>   static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>   			struct sys_reg_params *p,
>   			const struct sys_reg_desc *r)
> @@ -2794,6 +2798,24 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
>   	return 1;
>   }
>   
> +static int emulate_sys_instr(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> +{
> +	const struct sys_reg_desc *r;
> +
> +	/* Search from the system instruction table. */
> +	r = find_reg(p, sys_insn_descs, ARRAY_SIZE(sys_insn_descs));
> +
> +	if (likely(r)) {
> +		perform_access(vcpu, p, r);
> +	} else {
> +		kvm_err("Unsupported guest sys instruction at: %lx\n",
> +			*vcpu_pc(vcpu));
> +		print_sys_reg_instr(p);
> +		kvm_inject_undefined(vcpu);
> +	}
> +	return 1;
> +}
> +
>   /**
>    * kvm_reset_sys_regs - sets system registers to reset value
>    * @vcpu: The VCPU pointer
> @@ -2811,10 +2833,11 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>   }
>   
>   /**
> - * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
> + * kvm_handle_sys-- handles a system instruction or mrs/msr instruction trap
> +		    on a guest execution
>    * @vcpu: The VCPU pointer
>    */
> -int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
> +int kvm_handle_sys(struct kvm_vcpu *vcpu)
>   {
>   	struct sys_reg_params params;
>   	unsigned long esr = kvm_vcpu_get_esr(vcpu);
> @@ -2826,10 +2849,16 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>   	params = esr_sys64_to_params(esr);
>   	params.regval = vcpu_get_reg(vcpu, Rt);
>   
> -	ret = emulate_sys_reg(vcpu, &params);
> +	if (params.Op0 == 1) {
> +		/* System instructions */
> +		ret = emulate_sys_instr(vcpu, &params);
> +	} else {
> +		/* MRS/MSR instructions */
> +		ret = emulate_sys_reg(vcpu, &params);
> +		if (!params.is_write)
> +			vcpu_set_reg(vcpu, Rt, params.regval);
> +	}
>   
> -	if (!params.is_write)
> -		vcpu_set_reg(vcpu, Rt, params.regval);
>   	return ret;
>   }
>   
> @@ -3245,6 +3274,7 @@ void kvm_sys_reg_table_init(void)
>   	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true));
>   	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true));
>   	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false));
> +	BUG_ON(check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false));
>   
>   	/* We abuse the reset function to overwrite the table itself. */
>   	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)

It looks good to me, please feel free to add.
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

Thanks,
Ganapat
