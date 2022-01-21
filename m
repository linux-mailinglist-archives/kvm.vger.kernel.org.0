Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F02495E74
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 12:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245576AbiAULdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 06:33:42 -0500
Received: from mail-bn8nam11on2126.outbound.protection.outlook.com ([40.107.236.126]:34586
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230234AbiAULdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 06:33:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZrWWHrzIcaMckAgtM8sHPyoItx39xXP3rll9RocgCHCGzhJYh331CT6CMeRia++xrtqn1rjXdAnJr7piHuPfU6jxBFRqVI0SIuoCqiV4sR4/stxXlbkTtUnqCkNmWXYUZzkvknhuNnP3iqYCoQLowYyZcvh+2gwxkcbq+Mhyw53BDAfvncoYswgypDf4AW3jo2s5bIU3kxKDtLh3tVg2H74RrzDGwaaoZPeN/8xUxBvkZcc1/ykt0aQT0EUsbYzKV7U3VnrzBr/hodT9ejdAnqf97yd+mIr2787y44+qRLE2vI92ZdDRyqWHeWj4rWCn1rozOCss5QVRiuB0zdQjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dmubWtIazhZKUA8O+lHNepUgAetncR3TZ8DvMRPq40=;
 b=iYxneMZy1WSOOdqybCQBbTsHDWUEt/co+xrgqkmp+DSLdamygfQt64akRtYC9dQ/nsYLCZ4/BPTAJWJE4jq7BX2p4z2XxsxyqibmMJnZiBP8adNdWDSja97kZ6JETtAOAaFS9d85tBYybCUMw4+s9vQ6JMaF/Yy41vKy3e0PPNbWN43U/9JzH4WdLS76KIEtjrvkf2y3NZhlWiDsunvzf2ihVzeO/oH+MqAjTrv2a7dQreG+/CiBu1DQaq3SCeG7JGUz8+356c+sdTaH7IT1Lhi5Ry8RDneRa9wNS2ZMFzgWrGp0GoWNLH0DeIylh5C54jafZDlVKl8cPZwTp4plsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dmubWtIazhZKUA8O+lHNepUgAetncR3TZ8DvMRPq40=;
 b=HE3A8hjtav+tlJ+V0YJT/p0UUpeKVfpY+Q0X2gf/RR3TfGJkDm5sHxvcOaDQz/2dse/p6aASP56RpAXhbF4H5eYFlc2iVfvbaDNEs6boPitjkdChsrtyvI231H9kbFmvPB51tkKnjp3HdgwfAygopmfLx+1GTggoZbXgnGArdm8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SJ0PR01MB6174.prod.exchangelabs.com (2603:10b6:a03:29e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.7; Fri, 21 Jan 2022 11:33:39 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::3825:c594:1116:2a01%8]) with mapi id 15.20.4888.014; Fri, 21 Jan 2022
 11:33:39 +0000
Message-ID: <300f7a61-acd1-21bd-d36d-1532d2cecf44@os.amperecomputing.com>
Date:   Fri, 21 Jan 2022 17:03:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 36/69] KVM: arm64: nv: Filter out unsupported features
 from ID regs
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-37-maz@kernel.org>
 <e850857c-9cab-8e16-0568-acb513514ae8@os.amperecomputing.com>
 <87h7b3wqe9.wl-maz@kernel.org>
 <ef667048-7fbe-55dc-9856-546fd9d3c690@os.amperecomputing.com>
 <87zgouuxvy.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87zgouuxvy.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY4PR20CA0004.namprd20.prod.outlook.com
 (2603:10b6:903:98::14) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d56a44e4-4619-46a8-60b5-08d9dcd1de86
X-MS-TrafficTypeDiagnostic: SJ0PR01MB6174:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR01MB6174C30AB1DA753ACB18523D9C5B9@SJ0PR01MB6174.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09QYWiC28e0AEIObVbQa9WXm4frUnzMOaZvJ3fFGVRqfO7mMFb3zNwKFnCY3bwEoIS5C5kEaAS1pAiFRPKiHDHpIVpqJjrFHk2Z6jLxX3j6g5CXFlgK2QCfzg7ISPV62OTrVCfDbKYOgitYORGEqNpV+b+1Qr1whiBdYAsJU0uFWwNOutvBmH0dEPinG0Fqz+AkyzelhAqvDaQhUk+bAJuxUrjr69yWCANy8p2AdhBPyNJIjVTJ3AVXWtyqTOe7pVerNiZ6izoHlvWlKkMXCdddMSR74wCHTWe4/OEcUBxYeyE+pg+AZa1OkiOP/2E5nt9rNB2viGioXuE7Qwk0tcmyealMSAn1xtP8u3iEts0gVmplY15OzpW2aNinndHTUgaMcQoR6vg1HfLOKbaE11Lq7XGbZZSsejZyE2Tr0dOG9NzhRR7xFI22PAYx2Ujjv54hVRUCM8jyLq4U5q5MhA1NtSvdyCmZ38mNV5GuoQVB6Og69zIMOSIULcGG8UXkrRDkBDSWTuwkMtpFFguwkPw7E3ChqQDnbYwNGFjHug5IuqLAS4NBOgv8meJfvfLu2Tcvv5LXc7nc+vfCHJ/MlIB03pXhtMJRdjxOunUuN0poOhoXjTwrR5mIdcOMaxgFuEQQ/Ky9bUpB0p7cqQ5GHzJG1+tJ57m1l4rSQABQseOKds0AYTQytZ4V31i9f2Pjl2z040IaaM4UyKfmoifZMdx6HUKRaxgw5KtujVi85W60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(38100700002)(66946007)(6916009)(7416002)(4326008)(86362001)(54906003)(316002)(66476007)(66556008)(186003)(38350700002)(2616005)(52116002)(2906002)(53546011)(8676002)(508600001)(26005)(8936002)(6512007)(6506007)(83380400001)(31696002)(5660300002)(31686004)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z21VVkRWSmtHN0d2NmZOR0tBVzRRMGIzTVNXRWsyeXUzUkFkeUdNcHFpT2V6?=
 =?utf-8?B?Sk91VlBJT0NYb2xnckU5MEFlMmozK0o0b0VrUmJQVHB4WGhyeUNhUVpXK0N2?=
 =?utf-8?B?L3dKNC9FSEZnZWg2bUJSV1JQMWg0TzdRMVI4YzNESHQrSWV6NUc3TTRqOTZ3?=
 =?utf-8?B?S1lrQlRiTnZ2ZFpVT0p1enNVSUI4MzEvYm1BSklTcVdMQkJQZFNBM0l0Si9I?=
 =?utf-8?B?eW9ELzNYam9GVkhkak1aRlQvc01mVmEvTThOdmlYQmFpUHF3Y1FFWi9haml3?=
 =?utf-8?B?UkJOb1VSS011S0hNL1RnM2toZFN5MHc4T1YzemdpeTRnOEpvYloyaS92eGl0?=
 =?utf-8?B?OWZkakpHZnUycElPQUNBVVRqU2Z4RU9TaTlldHhONmxXVkxYSDFZOU02Yjk3?=
 =?utf-8?B?L3IwK0FmclhvaW5XRzgzbm9oNzl1RWplak14b2hOZlpzdjI3cmJCNVNCUTRn?=
 =?utf-8?B?NnNTY0t1NThuT1BlY1E5VCtEOTJhNGF0SHlST3RpRVhGdm4xQUh2bU9vdGFO?=
 =?utf-8?B?SWI2TndyL3Z2L2RnVTV0TEU3c1dWUlp1UTNWZDltNEFNSENLMGxpU0tndEV4?=
 =?utf-8?B?MmZJQTZxN2RtWkxDeVpndXoyTFZHZnh0eDRlTzlIK1JuN3Y0VlJhQ3NSQitP?=
 =?utf-8?B?UXpPLyt6Z2hrY3V4OWhTaXc0MUVnUW92N1RuQTlOSjdveUpmOU9sUGl4cHBn?=
 =?utf-8?B?VWVIc2I3djA2dWd0aWlpNGJDTzNCQWJBcUlBcFlicHo1TmRoYWo3c3FNRHl1?=
 =?utf-8?B?SWZlQlByU285NXkwU0pDbVcyNDB3ZTVLVTM1NGxzU0Z4czBtYjFvZDBEVlYr?=
 =?utf-8?B?amd3VjREME5OcDV4Rzh0MnF3TGtYOVJSRU5kS0YzNVFqQmdwWU16SVFTUlov?=
 =?utf-8?B?QWZxN2FFMnhFTEJsRzNiUDkzbnhqcW5QVXNXUFJWcG5Ldml3NVRjVlpxaVN2?=
 =?utf-8?B?NG5BNzZmUnVCWUhIcDFkTjg2eW1mTTFNdkRVLzNSMUVTV2FicHZaaXhDUEhX?=
 =?utf-8?B?REVkSE5RZ3V5bVAzbzQwRVFGL0s5b2h6anFMK21Tdzc4OUlobFVWSythcWpW?=
 =?utf-8?B?amFlWThLcWp6K01jOXBiYVBtL1NYNFpXTjZtMmM2Uy9xSlIwRWlaY2VBUDNV?=
 =?utf-8?B?aWdOeW1YeEl6dWZrZ3BReStrcmhxYmNEUVFnc1pDUmcyajBDWVUyTytiMXRQ?=
 =?utf-8?B?TzFFaGtvcEFpZkFMZldHK1ZabU9mVHRnd3NITlZRaWwzZHYxd3RaWVk1ZlRJ?=
 =?utf-8?B?QmZrdjVVT3RKbmxLaTNJYUt6bWY2aW9kUngrSWpyN2kyMkl0R25TMTdBQ01u?=
 =?utf-8?B?V080ejNrYU9kL3BCZDJZMFk2WFVRZ3NOL3VtZlZoeDR0QSs0eEx6Z29rd3ZJ?=
 =?utf-8?B?emgyemIvaXBVS2d5THpzcEVRUUwxRmhkZnU4S0NlOGVneU5xQUxzTnZ6U2F3?=
 =?utf-8?B?MEdkaWtjQStEL1dvSUN0N21wQlZpMGFMUHp6MlVoblRIVVJCVWozcGVlMlEw?=
 =?utf-8?B?ZlVrSGY3MExDVzlZTlJoU0hBNmxkdGFCOCtDK09pVWIxbFRKdFRtMnd6YkpL?=
 =?utf-8?B?QWlidmNLVVVzM3crZlpSdGdMN2lDcG5YNVdPN2JycW4xWVQ0SkFTS0dWQXlk?=
 =?utf-8?B?Vk1RMTI0QnNkK2hjd3pidUxhVUlsc1U3WnNnQW15S1FmUDhiN2FKM3NVVzBD?=
 =?utf-8?B?RVU0RnpUVnVNT2Q0MzNDYW4rb21EVSs1Z0dlTWVqV0xKcGVYYkVJWWxaUC83?=
 =?utf-8?B?YnhMRy9Hb1lkL1BOTnZNeUo4enpFTVNyNkFzc0p2ZzVia2dtelVCSk5mTTRX?=
 =?utf-8?B?RDJaWkpFSC9tSnJRa0JYUE1VaEo3UmVhUjhvdDJ0UzRiVEk0cXN2ZVg0dVEx?=
 =?utf-8?B?aWQwSjFkZnhUSXRocEh2SEtjaitpaVRwV05Zdzl5dXRyNXNCc1IwNjJXVFNR?=
 =?utf-8?B?K1FZbUJobXQxcjJKYisxNyt3alhSeGpCRWRxOTc3RlpSMXFSbkNpY0RlR1Bp?=
 =?utf-8?B?UEJEanFOZUJPVDd6RXk4UXR1MlAwYkdxQkcxaWtES0g0aFprWGMwcU9CcER1?=
 =?utf-8?B?dnZHNFlBNzVnUkhxY0FWdkR2MDNkMFRFWGJTQzU5NUM0SEJ5RS8wQi90UW80?=
 =?utf-8?B?ZFhHVUJKT1lhemZoVHFzdkFNRGIzV2dIYVZKVXlLMllDZkNML2dSSXdaTkE4?=
 =?utf-8?B?RktzSC9vTlRSeCs1eFN2dE1qNlRORmV5RU83bkxDN3kzcm5ncUUrQ0pCb3hC?=
 =?utf-8?B?dmw0enZhcEhUcm1rSjhLUTFyS0l0YzhrZmJaUHNjRCt2MVVGNS9wYkJxRWtU?=
 =?utf-8?B?cUQxM1ZlSk1YY2NtaXVxQ3dIZ1pGS0dWeXdVMEM1NXZwOXBGQklnUT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56a44e4-4619-46a8-60b5-08d9dcd1de86
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 11:33:39.0353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lIWsK1AJBMYzbUxa63DWKHNeb7TU+ADJ2VJgEn93Xj+neQwLv/8mlMSN0uwFjLpvNL7M7Ju2jllcIj9HJWbUvH+P9fKiLqb2ZtVhOVS8puNhoR/IqrhalveZQ1BR4fGx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 21-12-2021 02:40 pm, Marc Zyngier wrote:
> On Tue, 21 Dec 2021 06:03:49 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 20-12-2021 03:26 pm, Marc Zyngier wrote:
>>> On Mon, 20 Dec 2021 07:26:50 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>>
>>>> Hi Marc,
>>>>
>>>> On 30-11-2021 01:31 am, Marc Zyngier wrote:
>>>>> As there is a number of features that we either can't support,
>>>>> or don't want to support right away with NV, let's add some
>>>>> basic filtering so that we don't advertize silly things to the
>>>>> EL2 guest.
>>>>>
>>>>> Whilst we are at it, avertize ARMv8.4-TTL as well as ARMv8.5-GTG.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>>     arch/arm64/include/asm/kvm_nested.h |   6 ++
>>>>>     arch/arm64/kvm/nested.c             | 152 ++++++++++++++++++++++++++++
>>>>>     arch/arm64/kvm/sys_regs.c           |   4 +-
>>>>>     arch/arm64/kvm/sys_regs.h           |   2 +
>>>>>     4 files changed, 163 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>>>>> index 07c15f51cf86..026ddaad972c 100644
>>>>> --- a/arch/arm64/include/asm/kvm_nested.h
>>>>> +++ b/arch/arm64/include/asm/kvm_nested.h
>>>>> @@ -67,4 +67,10 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>>>>>     extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>>>>>     extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>>>>>     +struct sys_reg_params;
>>>>> +struct sys_reg_desc;
>>>>> +
>>>>> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>>>>> +			  const struct sys_reg_desc *r);
>>>>> +
>>>>>     #endif /* __ARM64_KVM_NESTED_H */
>>>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>>>> index 42a96c8d2adc..19b674983e13 100644
>>>>> --- a/arch/arm64/kvm/nested.c
>>>>> +++ b/arch/arm64/kvm/nested.c
>>>>> @@ -20,6 +20,10 @@
>>>>>     #include <linux/kvm_host.h>
>>>>>       #include <asm/kvm_emulate.h>
>>>>> +#include <asm/kvm_nested.h>
>>>>> +#include <asm/sysreg.h>
>>>>> +
>>>>> +#include "sys_regs.h"
>>>>>       /*
>>>>>      * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>>>>> @@ -38,3 +42,151 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>>>>>       	return -EINVAL;
>>>>>     }
>>>>> +
>>>>> +/*
>>>>> + * Our emulated CPU doesn't support all the possible features. For the
>>>>> + * sake of simplicity (and probably mental sanity), wipe out a number
>>>>> + * of feature bits we don't intend to support for the time being.
>>>>> + * This list should get updated as new features get added to the NV
>>>>> + * support, and new extension to the architecture.
>>>>> + */
>>>>> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>>>>> +			  const struct sys_reg_desc *r)
>>>>> +{
>>>>> +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>>>>> +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>>>>> +	u64 val, tmp;
>>>>> +
>>>>> +	if (!nested_virt_in_use(v))
>>>>> +		return;
>>>>> +
>>>>> +	val = p->regval;
>>>>> +
>>>>> +	switch (id) {
>>>>> +	case SYS_ID_AA64ISAR0_EL1:
>>>>> +		/* Support everything but O.S. and Range TLBIs */
>>>>> +		val &= ~(FEATURE(ID_AA64ISAR0_TLB)	|
>>>>> +			 GENMASK_ULL(27, 24)		|
>>>>> +			 GENMASK_ULL(3, 0));
>>>>> +		break;
>>>>> +
>>>>> +	case SYS_ID_AA64ISAR1_EL1:
>>>>> +		/* Support everything but PtrAuth and Spec Invalidation */
>>>>> +		val &= ~(GENMASK_ULL(63, 56)		|
>>>>> +			 FEATURE(ID_AA64ISAR1_SPECRES)	|
>>>>> +			 FEATURE(ID_AA64ISAR1_GPI)	|
>>>>> +			 FEATURE(ID_AA64ISAR1_GPA)	|
>>>>> +			 FEATURE(ID_AA64ISAR1_API)	|
>>>>> +			 FEATURE(ID_AA64ISAR1_APA));
>>>>> +		break;
>>>>> +
>>>>> +	case SYS_ID_AA64PFR0_EL1:
>>>>> +		/* No AMU, MPAM, S-EL2, RAS or SVE */
>>>>> +		val &= ~(GENMASK_ULL(55, 52)		|
>>>>> +			 FEATURE(ID_AA64PFR0_AMU)	|
>>>>> +			 FEATURE(ID_AA64PFR0_MPAM)	|
>>>>> +			 FEATURE(ID_AA64PFR0_SEL2)	|
>>>>> +			 FEATURE(ID_AA64PFR0_RAS)	|
>>>>> +			 FEATURE(ID_AA64PFR0_SVE)	|
>>>>> +			 FEATURE(ID_AA64PFR0_EL3)	|
>>>>> +			 FEATURE(ID_AA64PFR0_EL2));
>>>>> +		/* 64bit EL2/EL3 only */
>>>>> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
>>>>> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), 0b0001);
>>>>> +		break;
>>>>> +
>>>>> +	case SYS_ID_AA64PFR1_EL1:
>>>>> +		/* Only support SSBS */
>>>>> +		val &= FEATURE(ID_AA64PFR1_SSBS);
>>>>> +		break;
>>>>> +
>>>>> +	case SYS_ID_AA64MMFR0_EL1:
>>>>> +		/* Hide ECV, FGT, ExS, Secure Memory */
>>>>> +		val &= ~(GENMASK_ULL(63, 43)			|
>>>>> +			 FEATURE(ID_AA64MMFR0_TGRAN4_2)		|
>>>>> +			 FEATURE(ID_AA64MMFR0_TGRAN16_2)	|
>>>>> +			 FEATURE(ID_AA64MMFR0_TGRAN64_2)	|
>>>>> +			 FEATURE(ID_AA64MMFR0_SNSMEM));
>>>>> +
>>>>> +		/* Disallow unsupported S2 page sizes */
>>>>> +		switch (PAGE_SIZE) {
>>>>> +		case SZ_64K:
>>>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0001);
>>>>> +			fallthrough;
>>>>> +		case SZ_16K:
>>>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0001);
>>>>> +			fallthrough;
>>>>> +		case SZ_4K:
>>>>> +			/* Support everything */
>>>>> +			break;
>>>>> +		}
>>>>
>>>> It seems to me that Host hypervisor(L0) has to boot with 4KB page size
>>>> to support all (4, 16 and 64KB) page sizes at L1, any specific reason
>>>> for this restriction?
>>>
>>> Well, yes.
>>>
>>> If you have a L0 that has booted with (let's say) 64kB page size, how
>>> do you provide S2 mappings with 4kB granularity so that you can
>>> implement the permissions that a L1 guest hypervisor can impose on its
>>> own guest, given that KVM currently mandates S1 and S2 to use the same
>>> page sizes?
>>>
>>> You can't. That's why we tell the guest hypervisor how much we
>>> support, and the guest hypervisor can decide to go ahead or not
>>> depending on what it does.
>>>
>>> If one day we can support S2 mappings that are smaller than the host
>>> page sizes, then we'll be able to allow to advertise all page sizes.
>>> But I wouldn't hold my breath for this to happen.
>>
>> Thanks for the detailed explanation!.
>> Can we put one line comment that explains why this manipulation?
>> It would be helpful to see a comment like S2 PAGE_SIZE should be
>> at-least the size of Host PAGE_SIZE?
> 
> Can do, but we need to get the terminology straight, because this is
> very quickly becoming confusing. Something like:
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7c9dd1edf011..d35a947f5679 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -850,7 +850,12 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>   			/* Support everything */
>   			break;
>   		}
> -		/* Advertize supported S2 page sizes */
> +		/*
> +		 * Since we can't support a guest S2 page size smaller than
> +		 * the host's own page size (due to KVM only populating its
> +		 * own S2 using the kernel's page size), advertise the
> +		 * limitation using FEAT_GTG.
> +		 */

I have tried booting L0 with 4K page-size and L1 with 64K and with this 
config the L2/NestedVM boot hangs. I have tried L2 with page-sizes 4K 
and 64K(though S1 page size of L2 should not matter?).


>   		switch (PAGE_SIZE) {
>   		case SZ_4K:
>   			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0010);
> 
> So not quite a one line comment! ;-)
> 
> Ultimately, all there is to know is in the description of FEAT_GTG in
> the ARMv8 ARM.
> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat
