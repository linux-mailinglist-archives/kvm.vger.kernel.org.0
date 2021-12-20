Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A073E47A548
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 08:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbhLTHLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 02:11:13 -0500
Received: from mail-mw2nam10on2138.outbound.protection.outlook.com ([40.107.94.138]:5089
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234251AbhLTHLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 02:11:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvsShAEOkHxMOwVktZZdknd8oFHi9ZUP8cs2CB/CRmFAKFl5uZ4u0eiV5aRuyxB/uxnYapDNTHIU4GfWKq9Pkl8CzaPYaJLZ8KP1G+jC+j6HWH6SJMvZ1wCSjmkKMvLInbjFDrFQBASV7koElKOgnm+QMqZTlXU3KpbzWQD9wqrSKBxL8az/sNSOrvPfs6foo3crv10lCLjJ+RX3Q4mOQvSzvfWp/t1ixQ44MCskEXhQnaNTcbOI6nCf6qR66GVV9UMjaQMQzde9M6HRem3Ts3WSq066kjx9VzNdbFxRL++aiMQExzfUmD387Bo15X+OzMM1jW8ERnzp/tdMCRdj3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFj0b9hXnI4L65Ys/fDZ8yrW0cnmM0dSDV7nmFpbiCk=;
 b=OFeCb1ciqfilMI8sFmJdmSQv+/vZ2UzZ+e6YiSe30mB5Pou3IoVQ9qDk1We0c/CFw1V8hrzg7nPQ6yFbBlnTW202kBYAnNaZjmdtse6tp4cvmsABHWsiWUz/5cESKNEe0pO9OadxZWZCCK3/QWU0XX8jlaOiXmhvKJLGrPpTY5Q0hYbOHeHzKnt342uqRkbbKdqLPgGgHjzDzdXGKsprFgNT8zrfnN7Q2UzIdC5JgxeBcdi3LDj0UTb0nZGCFW7WDa7l4SYLdfp+waKGOOWNDyHfEDtXiG2ojB/MscRjz6OxAy0oF4s8Hw88jsGx+DSuO/78Al1lSLcIHXbg0vfqhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFj0b9hXnI4L65Ys/fDZ8yrW0cnmM0dSDV7nmFpbiCk=;
 b=fVn0o/vn0hYIZnIrhj4NeFD8YBVhEDvEMhuDkQFbG68CY5rXOKbfToRD6FvHJTO/8FPIQBA1DPD+rHHsuXxFfAcly/KX4h1gw+Ckk9h0TQQGe3olZznSpilCzWzJZZcHrGqIkmisWMdXCurHXHBtBE3jNJv7w/EjLFaCrXoiZ8Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM5PR01MB2313.prod.exchangelabs.com (2603:10b6:3:b::15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.17; Mon, 20 Dec 2021 07:11:10 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 07:11:10 +0000
Message-ID: <c9e1cae5-ded4-d4e5-e60e-2e2044800ad1@os.amperecomputing.com>
Date:   Mon, 20 Dec 2021 12:41:03 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 29/69] KVM: arm64: nv: Respect the virtual HCR_EL2.NV
 bit setting
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
 <20211129200150.351436-30-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-30-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0032.namprd14.prod.outlook.com
 (2603:10b6:610:56::12) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58c7b65b-8a73-4f6f-0f29-08d9c387e69a
X-MS-TrafficTypeDiagnostic: DM5PR01MB2313:EE_
X-Microsoft-Antispam-PRVS: <DM5PR01MB23138378AD989B86068D4A119C7B9@DM5PR01MB2313.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6HFyg7yYtR2+Dw3Z0vjIPuTPlvnp7c+vUfwyxxytWtdBsroI4BOJviJijD0lw8pOwdUOAtqjRPl4xr70hfhKylO9A/JZCvwD9ehP5BMtzp5y7mD87tEb7y5cxq4mYMaZxq/bhraPcVRzu7e612qS7Edm5Vq4+0mHTIv2mG3yZMahsUI4C3CfXe8Fp705XvzAdiWxd0TeNVFyoDpo5O+c2nv0DMg6rxvITmpgCeofSVzCr3mnKkbpLWNgCQ9Y9sI3+NbiZeE/WGs526bdlAsgLvZG/BbODhOx0GtF0EIqXAp9P4e9Vmcli/w1xLiNvf/QKzK4Ajwe+gUN/1gw3IuSrf8BOgcItVWcg3RwjZvmGZ1A9LIvI1e04dkjoaoYV7I3YkheHydeK5pxZFoI/e05icWkRmFzG+AlAxbrzHkDjQQpfjp8rySQWjOcn0nvglA5YSGHvf1MNuLlSv6a3KPYjZm4LQReVkEw476hD7wC0KdwNerXr5YnzXyf2W7ejLTgwmxrzaG+nsGhKGBulaj6Y5XGJKIN6SISWcspdfscKlb4kajVbAwF6EOLe6xAZyq0JzmSSxUhCf1eceziK5xiBPnD70OI+6h/hRW/8+e0CXEZGRXMffDO2Pxd1EKdcj0q+GQnQw/qz6b1w7/T/QCjeeJ9n+eVpcCY53x9/SlyHu/iIYr3eMUvEEY1qUWWU6T4Rq/MHcLYI1810gNUUWr/7j3MwHOhE2+pBq3d+xUmJ3zZ1LES4P2UzL9DQgKjNVeqYTGsuv5fBoRg4Jk15NDn2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(54906003)(7416002)(52116002)(53546011)(6506007)(38100700002)(38350700002)(31696002)(83380400001)(8936002)(2906002)(8676002)(316002)(86362001)(508600001)(6666004)(4326008)(2616005)(6512007)(5660300002)(186003)(6486002)(66946007)(66476007)(66556008)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2V6WXFBTTZpZERBQUNBY1pQNlFzeUNKMlJ1bmFsV2ZVcXB1WDJsYkxER2Jy?=
 =?utf-8?B?YThOckJBazVzZEZyVWpyWnBHSzVLclBZL0UyYlU2aHRLQmVPYnErRVMwLzg4?=
 =?utf-8?B?OERUT0s4YXBhQnl3S3NoakhRVWlGTHBYR0RIOEpXT1E1d1VoZUdTWTBHcFlW?=
 =?utf-8?B?Z2xhZGg5cVViSlczNGZxVit3ZGcrdE03SXJXbUpFT3Myb1ZraktiWnZOWits?=
 =?utf-8?B?NUwrbHVPMWpjc1ZZdTJNM3Z6WkpsblNhUGJ3U0E0eXhwWGtUeDZLQkdYajly?=
 =?utf-8?B?OThRNXgybWJXeTNCY2JmY0hkd0EyV2tFSGpMUCtRdHd5TXAvNmlyR3hZUEJK?=
 =?utf-8?B?K0FTeHhjRThHV3A5clRsZUlBSVpmZUFnKzg2dmg2ZFdiQkQ3eEMrNW1YdlA3?=
 =?utf-8?B?aDdhOXl6ZkdSRVJubDJHWTg4b3F1QTlEVzNHamU2b1h5ZDJqbWtFU1EzcE1Q?=
 =?utf-8?B?RGhwNTJPYVBXL0Q2MFd2ZTBaNU50VmF2RmR5VGZMYU8rMytsWkplY1BISnUr?=
 =?utf-8?B?OWNESHdxTSsxdW00MmlqNE1lYjFtT2tZMHl4cXpXRlZXdWN0MG9na1A3UXY5?=
 =?utf-8?B?MVpQNEFyTmgrNmRqSEpsM2taQldwc2IzbW9aMDhmYmhWMXQza0lEelh6eXN2?=
 =?utf-8?B?dXpmWU9yaCt2U3Nja3JZb2t4S3ZubmFVUURnKzd6Ylp2aXVzeGJlZlpjU1BW?=
 =?utf-8?B?MHl0YThjQ3RmcVdaUk9NRTgxUWU1R2c5dVZYWDZiTC9rMTQ5NG9jVmlBRTIr?=
 =?utf-8?B?NzltV3U0UHpwaUtxM0dVc05qTVJPeU1yTGhQN1JCbE5OKy9VVWVyMHJBdTl0?=
 =?utf-8?B?RnUveTZKdjBSVEp6Mnk3akFGbVhPZWFqbWlXRjFxS0pKRzI5MVhyZlBjbXdF?=
 =?utf-8?B?NU40VEZveEFjQU0xaU9ycXljT3BxTGRqTXczazloOW93RlNXTXhYbnR2WWN4?=
 =?utf-8?B?RHRoSEdFRVJOaHZka2NuRjNQNER4bzRsYk1XUnYrTGJPRzRSdjlKcWxydG5F?=
 =?utf-8?B?Q3VhdmFYYUVjVEh3VGdjcDBycjlnZXNKbGxXVkZXNytRSjQzUkNnL3JHdnJx?=
 =?utf-8?B?elJQRHVOdDUxakFHKzVnWThiRmEyRU9JU3RuQ09tME91Y3VQdVpsY0RDd1l6?=
 =?utf-8?B?MG9tMEcrVmdOcVZNU0s0bXNRa2YySTJnbER6NWlhdVZoTFVwdUs3Z2Fkandl?=
 =?utf-8?B?Z2lWQmo2STFlcTluWUoxNE9xZ3pUL0lROFZQcGlkMi9vNGVLajZtUHhISktv?=
 =?utf-8?B?ZHRtNGRxam9FTWN2SXVMYXNJNnF0OENaM0pRSmlNR0UxSWdjb3hadGhmVlZn?=
 =?utf-8?B?UnJVS2JUZ005Y1RSd2FvdUNlakNGNzhkR2pHQlBYUjBxbUYrbzVRUlJXSERO?=
 =?utf-8?B?SVZiVk0rV010TUFQbFRHSGRHSzdTaC93ZU9lbEpLNS8rVHJXek5ONUd2L0Ja?=
 =?utf-8?B?Y2dNQys0NnNGTmNUem1ONzQrUmpxM3NDN2EwK2NyZmtQS2NYUFAwYUZQdXdB?=
 =?utf-8?B?ZzRDaFdOSzNGY1dqQ2JQR1l6a25LQzFVeTZoOUkzY1hzekJvTjJ6WkJJZ3cz?=
 =?utf-8?B?L2JwK3FzQzBsWU9UaUF4YXBNemlRck1nR1padlhYc1FPeDdGa01yNnVYbXRL?=
 =?utf-8?B?NjhRalk5KzRoV0hyL2tERTZSVFF0TlIvOSsyQ2pPbUxZenNCSEVMZjhJSmw0?=
 =?utf-8?B?ZlQvcFBjV3dwUktLc0dia091YWZ3ODVIR1V4ZHdyOWxzZTBHTEVMU2czWFUz?=
 =?utf-8?B?OEFMZnVjT1kzNTV5MjliRlptWEVJYjNRdndKRnhqRnRrOUdKQlcwdHpVd21t?=
 =?utf-8?B?a3VZK29zZy9ZK0Y0UWk1cDFqR2dCS0s3MmdERHhpNi9NcEtkT3FMVTlGRWl5?=
 =?utf-8?B?OWdnVytCZnJtZkpwWWo4SkdmVDRzR1hNcGVUMGlRMVM5ZU1ydDlQMXJSMU13?=
 =?utf-8?B?VzVyS2ltWkFFSkx1ZUdwZ1h5RmwvRkRXTlNzamRVRDMwN2Jxa3NCRzVRU3Rv?=
 =?utf-8?B?azV4TnFTQkdIV01WWEZlcC9ZWENJV3VNTFRNOW5oWGM1VDdoMTEvQ0hIQnZG?=
 =?utf-8?B?cFd2TUJEbFY0dmJPZHN4WmRETi9mc1h3dFl0VDgrK05JYlhnQzhFS0xoSVB1?=
 =?utf-8?B?WG1jVVcwV2pUVjRVcEd4WSs2NnJrcjFBRG9mRW8rWnpLSWNRRXFkbXpzVElP?=
 =?utf-8?B?Uzl0Vi85QlUrMXZUK3M4RTRBOWorVDM2ZnFMZVhvVjhnTzdZTkU1K2p1UXlI?=
 =?utf-8?B?MXl0SHpEREZzczNtZzY4bEVkRk1IK29IbGZvK1gvSENNRXd6NFNRekdaYlNh?=
 =?utf-8?B?eS9Ha1NodURRd0RjRXVScU03TWk3TkNpREZIaWlMT01pT1pTcGFjUT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c7b65b-8a73-4f6f-0f29-08d9c387e69a
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 07:11:10.7586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+kfi27ciIyl9H9KNuBjJjeXCYvVnDc6DmOJaWwmIZrU9OZ9Qa3sikgEF26K18MaO3vefsFzopI95EEktwCrbMAEqYPsiBMqUPlSGk48+3DaWLkz8oH0+Nv+QdqTINIP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2313
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 30-11-2021 01:31 am, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Forward traps due to HCR_EL2.NV bit to the virtual EL2 if they are not
> coming from the virtual EL2 and the virtual HCR_EL2.NV bit is set.
> 
> In addition to EL2 register accesses, setting NV bit will also make EL12
> register accesses trap to EL2. To emulate this for the virtual EL2,
> forword traps due to EL12 register accessses to the virtual EL2 if the
> virtual HCR_EL2.NV bit is set.
> 
> This is for recursive nested virtualization.

What is recursive nested virtualization means?
Are we going to set NV/NV1/NV2 bits of ID_AA64MMFR2_EL1 of 
Guest-Hypervisor to support NV in Guest-Hypervisor?

> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [Moved code to emulate-nested.c]
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_arm.h    |  1 +
>   arch/arm64/include/asm/kvm_nested.h |  2 ++
>   arch/arm64/kvm/emulate-nested.c     | 27 +++++++++++++++++++++++++++
>   arch/arm64/kvm/handle_exit.c        |  7 +++++++
>   arch/arm64/kvm/sys_regs.c           | 24 ++++++++++++++++++++++++
>   5 files changed, 61 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 2eccf883e8fe..9759bc893a51 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -20,6 +20,7 @@
>   #define HCR_AMVOFFEN	(UL(1) << 51)
>   #define HCR_FIEN	(UL(1) << 47)
>   #define HCR_FWB		(UL(1) << 46)
> +#define HCR_NV		(UL(1) << 42)
>   #define HCR_API		(UL(1) << 41)
>   #define HCR_APK		(UL(1) << 40)
>   #define HCR_TEA		(UL(1) << 37)
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 4c2ac9650a3e..26cba7b4d743 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -62,5 +62,7 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
>   }
>   
>   int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
> +extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
> +extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>   
>   #endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 339e8272b01e..8c7f2fe24bc6 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -25,11 +25,38 @@
>   
>   #include "trace.h"
>   
> +bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
> +{
> +	bool control_bit_set;
> +
> +	if (!nested_virt_in_use(vcpu))
> +		return false;
> +
> +	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
> +	if (!vcpu_mode_el2(vcpu) && control_bit_set) {
> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +		return true;
> +	}
> +	return false;
> +}
> +
> +bool forward_nv_traps(struct kvm_vcpu *vcpu)
> +{
> +	return forward_traps(vcpu, HCR_NV);
> +}
> +
>   void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
>   {
>   	u64 spsr, elr, mode;
>   	bool direct_eret;
>   
> +	/*
> +	 * Forward this trap to the virtual EL2 if the virtual
> +	 * HCR_EL2.NV bit is set and this is coming from !EL2.
> +	 */
> +	if (forward_nv_traps(vcpu))
> +		return;
> +
>   	/*
>   	 * Going through the whole put/load motions is a waste of time
>   	 * if this is a VHE guest hypervisor returning to its own
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 7721c7c36137..6ff709c124d0 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -64,6 +64,13 @@ static int handle_smc(struct kvm_vcpu *vcpu)
>   {
>   	int ret;
>   
> +	/*
> +	 * Forward this trapped smc instruction to the virtual EL2 if
> +	 * the guest has asked for it.
> +	 */
> +	if (forward_traps(vcpu, HCR_TSC))
> +		return 1;
> +
>   	/*
>   	 * "If an SMC instruction executed at Non-secure EL1 is
>   	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6490b0e3dcaf..3468b8df8661 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -267,10 +267,19 @@ static u32 get_ccsidr(u32 csselr)
>   	return ccsidr;
>   }
>   
> +static bool el12_reg(struct sys_reg_params *p)
> +{
> +	/* All *_EL12 registers have Op1=5. */
> +	return (p->Op1 == 5);
> +}
> +
>   static bool access_rw(struct kvm_vcpu *vcpu,
>   		      struct sys_reg_params *p,
>   		      const struct sys_reg_desc *r)
>   {
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return false;
> +
>   	if (p->is_write)
>   		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
>   	else
> @@ -283,6 +292,9 @@ static bool access_sctlr_el2(struct kvm_vcpu *vcpu,
>   			     struct sys_reg_params *p,
>   			     const struct sys_reg_desc *r)
>   {
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return false;
> +
>   	if (p->is_write) {
>   		u64 val = p->regval;
>   
> @@ -367,6 +379,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>   	bool was_enabled = vcpu_has_cache_enabled(vcpu);
>   	u64 val, mask, shift;
>   
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return false;
> +
>   	/* We don't expect TRVM on the host */
>   	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
>   
> @@ -1664,6 +1679,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
>   		       struct sys_reg_params *p,
>   		       const struct sys_reg_desc *r)
>   {
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return false;
> +
>   	if (p->is_write)
>   		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
>   	else
> @@ -1676,6 +1694,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>   			struct sys_reg_params *p,
>   			const struct sys_reg_desc *r)
>   {
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return false;
> +
>   	if (p->is_write)
>   		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
>   	else
> @@ -1688,6 +1709,9 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
>   			    struct sys_reg_params *p,
>   			    const struct sys_reg_desc *r)
>   {
> +	if (el12_reg(p) && forward_nv_traps(vcpu))
> +		return false;
> +
>   	if (p->is_write)
>   		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
>   	else

Thanks,
Ganapat
