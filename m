Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B9F47A542
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 08:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhLTHFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 02:05:05 -0500
Received: from mail-dm6nam10on2124.outbound.protection.outlook.com ([40.107.93.124]:64801
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232331AbhLTHEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 02:04:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPZOCuIRNh7ttWoPzGzraZafhAHF9XL87DR4eAvL29n50kb37OrImceHnGAKAhP+nG3yk3lutuT6IIAgjZswkQsJValN+omYr0Wyr0gH3xOCJb9mNxJn2cM2opqZ7plOekpqjxc4mzz47OOaUwRdaGEHlZN1fxnEE0lyIR8RdzqLNp34gTANAUGOTXUTJ7fs8x0242dIqISMOCQVT98CPeBHlTs+4l77b8bsUohuvjwoUo2q2WOE+yovQMxCwtq0j0ppzH20bgiCfiukmG0C7lPgyg5yrWicyzsZ/U6SPgtJFlQQZk2b7QI1+p/aH+0afWwpEV2Kf4oCFuvJ60ywEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dsWjl9QROIdCvHZ+xIHpIMSorgZFCZgorYO/ItOULfo=;
 b=fqe+v04LUzfR6AKXCG1n/ql4teGvUBQQdn8uUBntFWfvN6jQLCGDbamMvShpocIxgYw3Cdf12yUQUs0MlOnv5KP2khIxo/iFub/QI/fJW0uQQSXILR9KtTFJJdVKfJjXbqdzsaBKfmqpkCcKwVxofeZOYIklxkNChUoVBUvHzqhKFW/5YAakns0Npkj8sbvR37Hi0nBsiOKJnE+A4KPl0iEVpoye/BjmirUV1uFn1wvQ7MdchptZ3P2jP1GORqHxKJt4GuSFHKFjZc65ON2iOjD2W1xjgW3BpNzp9DT+h7S4PENv0QYO0oA/0/si7H21BS6id+3477mADSOsz6Topw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsWjl9QROIdCvHZ+xIHpIMSorgZFCZgorYO/ItOULfo=;
 b=DNnM+jezk/SJgznsfewjSuBXaGWb7RX3aVPLF3UCO60B7i4DrKZjm3nPQu1GN+bQjtetLE6mvwR0TUgd40uk/mu3cuPoC2sA9JsQmKTnJTQMiA1e0X2Bf4Q2LMLylLlJTKkkZZP3x3Kd/CG1sPC9sM12BniCdFmfiYtYNa/dobo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM5PR01MB2313.prod.exchangelabs.com (2603:10b6:3:b::15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.17; Mon, 20 Dec 2021 07:04:52 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 07:04:52 +0000
Message-ID: <13046e57-b7e5-7f0b-15bd-38c09e21807a@os.amperecomputing.com>
Date:   Mon, 20 Dec 2021 12:34:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 18/69] KVM: arm64: nv: Handle virtual EL2 registers in
 vcpu_read/write_sys_reg()
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
 <20211129200150.351436-19-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-19-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:610:b1::11) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff3d1015-a3a4-4102-a659-08d9c38704e5
X-MS-TrafficTypeDiagnostic: DM5PR01MB2313:EE_
X-Microsoft-Antispam-PRVS: <DM5PR01MB2313004CD80E349F2EBFF03F9C7B9@DM5PR01MB2313.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6KUZjnweXo5Y06zXKyDrGWmVPVW4SuoKQtUHsuFTB/5xQ+z3Tfg1+FyHbzlk7wHlbYigtjYJ5G/c3y0kC+WTfMLVuh+LW1XgpzNuQa8vmpNxfVDLWLTL8/NqjCqa7GVs4kI0dr2kC92GzBw9rplAfPI8zR3+s+AnXPAUeI5N61kFQfyZTWXuVnn4Ynny0lNj5u9aPnvkDcS7YHhwQulXWNun23zDTukkq1kJrC6HZQKs0p5NkFbmJ55KeGTbIPPuA0YXg3DaL1ktX61fVi/+aYRnbwOJYg5TR9D+9ijHp/g8h62pe4rukHKdOcqUbbp63ke4JkZ49FIxKCb/T2HO5i+lD7wtgLS0QIv0yf6od8hSlEikdwPkggaJzlqdko/TaHwD62Gno4HG6KIKikL0zNOIbvjMEyIwFJ/0ma/ZV2CksOCC6kVaKuYyQ3RbeVQwl5WM6pp+wzEntqOG3Wq2JbCP8tIw4Cr3X3s0KcOBboWj0meY1DAPZmvkKcHZluYTyHt29i+CwPrmrFpx3IFrWaqRXlhSRa7r+/uGbGUuQ+w71OKB9JjfWADEk5j4rZvp3Eep6UK0TotwyVgyRNtzRFVvYA4eUXbLF6vCR/a5Cc/ynZ5nwHI4ZA1RtWE5c0XO2xSjwT7Gb151urZpEYsHZE/jSLNExqzZpjIebpaVEu0RufdIxno7GHUjSUGSxpTSbNRlxUsMDrej5djBUBBDmdObF/Yx7aeubUExgZXDLGmwxWXGTY7Znvk+c507FY4C4L1riS0rZ+PE0XqfgsUPhQsKHrF9M5sIza4LaWo+c3pFLCJYhjetBCONBmQLMhAC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(508600001)(66946007)(66476007)(66556008)(26005)(4326008)(5660300002)(6486002)(186003)(2616005)(6512007)(7416002)(52116002)(53546011)(6506007)(31686004)(54906003)(316002)(86362001)(8936002)(2906002)(38100700002)(38350700002)(31696002)(83380400001)(8676002)(43740500002)(357404004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzhNYmdUWkdIV0FHRVp6OWU3K0ZsS09SSkcrQ0Z0cFBLUkRGbU9xYmp2a0NO?=
 =?utf-8?B?c1BlcmpoTEdLcFYraHQ4dG03SnBLYkN4bnhONXk0cHpNTWxXVkRPT2psUjF2?=
 =?utf-8?B?KzBpaGU3bC9tanduNEdyNVZaYmcyNE5pdWd0RGh2T2s1UGNyK2svVldMTTJr?=
 =?utf-8?B?ckgzNndUUEVEM2hRSnQrNFJLVXB1dzAyMzhsRTQ2bDNpc2hOTmRZR1NjVElY?=
 =?utf-8?B?REtNZGF2YzBhc1NMZzdtOEtrMEtvRU41QWN3Z29SS3J4b1doeW5Yem15MGxl?=
 =?utf-8?B?QjRSdzlINHVtWFc0c1VqQzcyanBNUmQxMHB4eFBzM1Uwb2srTnJOdWV0aGxM?=
 =?utf-8?B?dVRrbndxK3p1QWFhQ1g1Ym41SGx5Z3Z3OEowOVgvODlpdG5BdUJNVWlMcXdw?=
 =?utf-8?B?aGE2YVo1LzFCTG5aTmxObjhmbDdvRy8vY09JcWFOdk9ML0NsSnZ6UGd0ZTQz?=
 =?utf-8?B?azNHUGQ2YVUzTWVMUHVkUU91WXRmS1FOT25ZeTMrai90dkNkeXdWWVJIQVo0?=
 =?utf-8?B?OEkvRmxPbGM4czcyeGQzTy9wbUdheFhkTVZJWGFPNUJ2VUZkSVVhaFl1SzZT?=
 =?utf-8?B?TDlJMEdhS3Y3bDg1Q3pkZlh5T1RFYXFSTjhYc0doaGw5ZjIvSERtS0dEd0Ru?=
 =?utf-8?B?L09mNnRxNmpEQnRTU3BqREQyWjJRRXpYZklDMmJhaER0VXY1WExJWVhGRElO?=
 =?utf-8?B?V3BUVjNlUHp5elVla0g4dUR0TGpDMFhTVGZVcGp4RTlpaytqV0I3L2hON0ZU?=
 =?utf-8?B?R2x4bnhTVEZjZENOR0xZVWU2OXRXVmY0SWdGaUJ0TGNpNDQ4UmFVeC9GM3Jw?=
 =?utf-8?B?ZkZHbk85UnIxZ0xIa3VDbUVoWVFQKzBJaVpaUXZLUU42WUg4REJGN1piOVBi?=
 =?utf-8?B?bnRzOE9icEFSbDNpWjlBT1gxdHhGMVdxWUM2ekErVHhIb09jQ2VBOG8venkr?=
 =?utf-8?B?cmtiOXAwcmk3ZWpuQ1RsbVQza1hTUHhYblU5cmZCQno4aE0yN2xjbGhsM3pv?=
 =?utf-8?B?MUx3dTN2MjJZQzQvSG41azczNzJGejdaeGZQclYweWJ0Y3pSM0Zhc0pudjJq?=
 =?utf-8?B?YVhQODlwbDFUYzFVbGxydlN0dzlrN0c4UGQybE5zVW1yeGpiMWsydFhUU1hy?=
 =?utf-8?B?V2haLzl4a0ZsSFRLUThYQXIzcWJjQzQ2UmZwUmhYVFNjRUt1aDgwZ0tuZGRM?=
 =?utf-8?B?ZnNpQ3RBVmMvQ3dPVFp2OTlKSDQ5TlBGV2lUdnB2MUFmOUJkTnB5WFpaTHlr?=
 =?utf-8?B?Ky9OODVKTjZtNTBxOWxFaFJDZ3hjZ1E1WnJ0YXN6Nk5sWXFyVGpsdjBYT3JV?=
 =?utf-8?B?am1XNXd5QXltV01JQ0hjaWVXck1vUUYza04vYzNGN1dwWk5vSzFnNXBwWk5v?=
 =?utf-8?B?ZVJDWG1valVXbUpwWnFSdmZPaUxPQkFWMSt3dURxUTJtajhQSUlURDEzQnpE?=
 =?utf-8?B?dWZqbWpjeG9waUdtb1dqSHhETjFqdndESFgrM0dOVU1ULzBjUkt5UlpxVmdw?=
 =?utf-8?B?dE9nTzh5cGZJbys5akx6RDhxNWI1amwyK05pQjVnN0piRUQ3VmdmTkNsZDRl?=
 =?utf-8?B?VmRlaXA1Q3ZvYkV1S2pJVURIb25lemtESU1kYm5RN2NCV0hxMC9FMUhBcFJB?=
 =?utf-8?B?N3I3L3YxaDlIdS9SdG9zOVVld21BNEJTYVEvT3h0T3h6bkoxUk9mRDZmVEFV?=
 =?utf-8?B?dUd2QnB6bFZJN2kyTXR2VWhBZ1c2RXp2Y1BqUW1BUCs4RVA4NTUyZkdacW5a?=
 =?utf-8?B?QWdEZjkyU01EL0VTNkl3NndsMUl1RHJINWQ5bE5OcU1nMWxnelN2WTVSZXUy?=
 =?utf-8?B?cGdZMC9DbE1KWmE2c1dONVZrQVpMaEtKSUxPMEliSUtSUnBlMGc5cEMybGMw?=
 =?utf-8?B?Z2hNemVoU2RBajJUYzV1MzBqUS9JYUkrcStLOWRuSTJzL0ZqZmVjeVVDY3BO?=
 =?utf-8?B?cUlheFJ5TFhob2RwM0FHRStYNCtCWDNURVp4TE9aY0pMYnhMVkZ6VnJ3RWpm?=
 =?utf-8?B?S2FUcm5JMUNXQllxSGZ0NDdPNjV2eTRFRWkycUR3WVp6UFQwaEVFR2ZtbkVt?=
 =?utf-8?B?T0ZYdEJGYks2ZEN4VDQwTDRnTEVMSyt0WkdQYUprY0YxZUR2U2hscWxsZkxy?=
 =?utf-8?B?eVMvbmg5aXVHREF6VXc3U2hXck13OEFTR1N5VndwK3hyeTVtUS9zTFhNdTFK?=
 =?utf-8?B?QitMYW0zcFlxejJjaEtleWQxTzQxSWZFUzlEYmJHaVhpTXRNdzdLTTRYSjBq?=
 =?utf-8?B?NDhWMjV4SFRWQW5mM01hTHplcVh4M2NQeXlTM21zY1hUaWdjZUpzekZjS2RJ?=
 =?utf-8?B?QzVyYk5DV1c2QTJ2U1htQy8zNUNLcjk1NU0rZElXUERTUnRZL2tJUT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3d1015-a3a4-4102-a659-08d9c38704e5
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 07:04:52.0733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hK2ThVKKfXNK+kepWeiWm+EI3Y3k1Hzw0i5u9rlS1D9FC0x/jx4x04jndtjjz4cV0o0tPWAlnn66x9jY2lHDyfUbXmgw3+OcWY6vQ9PLcs4Lprh6cWxWodvCSQ3U7ulE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2313
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 30-11-2021 01:30 am, Marc Zyngier wrote:
> KVM internally uses accessor functions when reading or writing the
> guest's system registers. This takes care of accessing either the stored
> copy or using the "live" EL1 system registers when the host uses VHE.
> 
> With the introduction of virtual EL2 we add a bunch of EL2 system
> registers, which now must also be taken care of:
> - If the guest is running in vEL2, and we access an EL1 sysreg, we must
>    revert to the stored version of that, and not use the CPU's copy.
> - If the guest is running in vEL1, and we access an EL2 sysreg, we must

Do we have vEL1? or is it a typo?

>    also use the stored version, since the CPU carries the EL1 copy.
> - Some EL2 system registers are supposed to affect the current execution
>    of the system, so we need to put them into their respective EL1
>    counterparts. For this we need to define a mapping between the two.
>    This is done using the newly introduced struct el2_sysreg_map.
> - Some EL2 system registers have a different format than their EL1
>    counterpart, so we need to translate them before writing them to the
>    CPU. This is done using an (optional) translate function in the map.
> - There are the three special registers SP_EL2, SPSR_EL2 and ELR_EL2,
>    which need some separate handling (SPSR_EL2 is being handled in a
>    separate patch).
> 
> All of these cases are now wrapped into the existing accessor functions,
> so KVM users wouldn't need to care whether they access EL2 or EL1
> registers and also which state the guest is in.
> 
> This handles what was formerly known as the "shadow state" dynamically,
> without requiring a separate copy for each vCPU EL.
> 
> Co-developed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/sys_regs.c | 143 ++++++++++++++++++++++++++++++++++++--
>   1 file changed, 139 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 730a24468915..61596355e42d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -24,6 +24,7 @@
>   #include <asm/kvm_emulate.h>
>   #include <asm/kvm_hyp.h>
>   #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>   #include <asm/perf_event.h>
>   #include <asm/sysreg.h>
>   
> @@ -64,23 +65,157 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>   	return false;
>   }
>   
> +#define PURE_EL2_SYSREG(el2)						\
> +	case el2: {							\
> +		*el1r = el2;						\
> +		return true;						\
> +	}
> +
> +#define MAPPED_EL2_SYSREG(el2, el1, fn)					\
> +	case el2: {							\
> +		*xlate = fn;						\
> +		*el1r = el1;						\
> +		return true;						\
> +	}
> +
> +static bool get_el2_mapping(unsigned int reg,
> +			    unsigned int *el1r, u64 (**xlate)(u64))
> +{
> +	switch (reg) {
> +		PURE_EL2_SYSREG(  VPIDR_EL2	);
> +		PURE_EL2_SYSREG(  VMPIDR_EL2	);
> +		PURE_EL2_SYSREG(  ACTLR_EL2	);
> +		PURE_EL2_SYSREG(  HCR_EL2	);
> +		PURE_EL2_SYSREG(  MDCR_EL2	);
> +		PURE_EL2_SYSREG(  HSTR_EL2	);
> +		PURE_EL2_SYSREG(  HACR_EL2	);
> +		PURE_EL2_SYSREG(  VTTBR_EL2	);
> +		PURE_EL2_SYSREG(  VTCR_EL2	);
> +		PURE_EL2_SYSREG(  RVBAR_EL2	);
> +		PURE_EL2_SYSREG(  TPIDR_EL2	);
> +		PURE_EL2_SYSREG(  HPFAR_EL2	);
> +		PURE_EL2_SYSREG(  ELR_EL2	);
> +		PURE_EL2_SYSREG(  SPSR_EL2	);
> +		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
> +				  translate_sctlr_el2_to_sctlr_el1	     );
> +		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,
> +				  translate_cptr_el2_to_cpacr_el1	     );
> +		MAPPED_EL2_SYSREG(TTBR0_EL2,   TTBR0_EL1,
> +				  translate_ttbr0_el2_to_ttbr0_el1	     );
> +		MAPPED_EL2_SYSREG(TTBR1_EL2,   TTBR1_EL1,   NULL	     );
> +		MAPPED_EL2_SYSREG(TCR_EL2,     TCR_EL1,
> +				  translate_tcr_el2_to_tcr_el1		     );
> +		MAPPED_EL2_SYSREG(VBAR_EL2,    VBAR_EL1,    NULL	     );
> +		MAPPED_EL2_SYSREG(AFSR0_EL2,   AFSR0_EL1,   NULL	     );
> +		MAPPED_EL2_SYSREG(AFSR1_EL2,   AFSR1_EL1,   NULL	     );
> +		MAPPED_EL2_SYSREG(ESR_EL2,     ESR_EL1,     NULL	     );
> +		MAPPED_EL2_SYSREG(FAR_EL2,     FAR_EL1,     NULL	     );
> +		MAPPED_EL2_SYSREG(MAIR_EL2,    MAIR_EL1,    NULL	     );
> +		MAPPED_EL2_SYSREG(AMAIR_EL2,   AMAIR_EL1,   NULL	     );
> +		MAPPED_EL2_SYSREG(CNTHCTL_EL2, CNTKCTL_EL1,
> +				  translate_cnthctl_el2_to_cntkctl_el1	     );
> +	default:
> +		return false;
> +	}
> +}
> +
>   u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>   {
>   	u64 val = 0x8badf00d8badf00d;
> +	u64 (*xlate)(u64) = NULL;
> +	unsigned int el1r;
> +
> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> +		goto memory_read;
> +
> +	if (unlikely(get_el2_mapping(reg, &el1r, &xlate))) {
> +		if (!is_hyp_ctxt(vcpu))
> +			goto memory_read;
> +
> +		/*
> +		 * ELR_EL2 is special cased for now.
> +		 */
> +		switch (reg) {
> +		case ELR_EL2:
> +			return read_sysreg_el1(SYS_ELR);
> +		}
> +
> +		/*
> +		 * If this register does not have an EL1 counterpart,
> +		 * then read the stored EL2 version.
> +		 */
> +		if (reg == el1r)
> +			goto memory_read;
> +
> +		/*
> +		 * If we have a non-VHE guest and that the sysreg
> +		 * requires translation to be used at EL1, use the
> +		 * in-memory copy instead.
> +		 */
> +		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
> +			goto memory_read;
> +
> +		/* Get the current version of the EL1 counterpart. */
> +		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
> +		return val;
> +	}
> +
> +	/* EL1 register can't be on the CPU if the guest is in vEL2. */
> +	if (unlikely(is_hyp_ctxt(vcpu)))
> +		goto memory_read;
>   
> -	if (vcpu->arch.sysregs_loaded_on_cpu &&
> -	    __vcpu_read_sys_reg_from_cpu(reg, &val))
> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
>   		return val;
>   
> +memory_read:
>   	return __vcpu_sys_reg(vcpu, reg);
>   }
>   
>   void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>   {
> -	if (vcpu->arch.sysregs_loaded_on_cpu &&
> -	    __vcpu_write_sys_reg_to_cpu(val, reg))
> +	u64 (*xlate)(u64) = NULL;
> +	unsigned int el1r;
> +
> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> +		goto memory_write;
> +
> +	if (unlikely(get_el2_mapping(reg, &el1r, &xlate))) {
> +		if (!is_hyp_ctxt(vcpu))
> +			goto memory_write;
> +
> +		/*
> +		 * Always store a copy of the write to memory to avoid having
> +		 * to reverse-translate virtual EL2 system registers for a
> +		 * non-VHE guest hypervisor.
> +		 */
> +		__vcpu_sys_reg(vcpu, reg) = val;
> +
> +		switch (reg) {
> +		case ELR_EL2:
> +			write_sysreg_el1(val, SYS_ELR);
> +			return;
> +		}
> +
> +		/* No EL1 counterpart? We're done here.? */
> +		if (reg == el1r)
> +			return;
> +
> +		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
> +			val = xlate(val);
> +
> +		/* Redirect this to the EL1 version of the register. */
> +		WARN_ON(!__vcpu_write_sys_reg_to_cpu(val, el1r));
> +		return;
> +	}
> +
> +	/* EL1 register can't be on the CPU if the guest is in vEL2. */
> +	if (unlikely(is_hyp_ctxt(vcpu)))
> +		goto memory_write;
> +
> +	if (__vcpu_write_sys_reg_to_cpu(val, reg))
>   		return;
>   
> +memory_write:
>   	 __vcpu_sys_reg(vcpu, reg) = val;
>   }
>   

Thanks,
Ganapat
