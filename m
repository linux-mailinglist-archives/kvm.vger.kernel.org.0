Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39CE47A563
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 08:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhLTH1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 02:27:01 -0500
Received: from mail-bn8nam12on2109.outbound.protection.outlook.com ([40.107.237.109]:2062
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234305AbhLTH1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 02:27:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buDz2UtCNIpFj90gHx7Wx64hMbDxeU1mRME+SRJbLvDGqs8G3ULo88M0ApThh/A0z+66CyvW7jZjZaiD4iRkNiRzn1jhPYq6B7/7sHDJLx5gyMxn86M5/IWAE438NzXnMoLr7LGkGBO7RNCD1NpY+YAUiUMlFS295s6LjrPgbwo9dHjAiM2sdNbn7W0oSE3GZGYL0KPQ74P32AgdTodNgYn4MQ5fZwwellnqTngq5f6mFMb2WIwSANtzRv4aRHO+UFfiOUJcu3XDrz7OZaBbBM8nkzLcF2I7fXuhhWiiMFmNUwPdnUVRFCzRYGNtCIKdE4KZz5z+wukd7qSCBJA/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itnf4EB4aOVvm8+oWqntaKKX7ObHiMlAm8dXvMs1xXE=;
 b=bjfu9Miw1eHrD6tfrTHDCE+LYJqtoA6Bl47fCjqzu5c510eIf2KCdUa1AEF7Z/ewxehel9jEVNnF1fG7pSsCu1AYL0MF+W91YkUWwxhMosMt2KVCpnGHB27I3qGWOivMDVZ8gwCXoR+9k/W5TK3bHVxCAd7kWSHzuHdU5Khl3b8WAjKM15KBasv5Jr7vfrxIbOjRHgLNj9ZtT+KOu2Qs3NArtgqeZUSWIfRALSShY/m2Sxh7bSB0uVCCVi81xDr8Vnvf1wk4YIGm7cL4zI9KmP25VXaWmgtk5hFvEkKJ1/AIdShIiuQsJV+b9RVDSK0V/1ffwWMJdUstesEfcO3EmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itnf4EB4aOVvm8+oWqntaKKX7ObHiMlAm8dXvMs1xXE=;
 b=DFpviJCjskT24XfJVj+8JL42yZpObKM9HmSshJLuNGBwHiRjkhRYri+KYG5NORB4gZjbiflUvznQyLW50OI3xq/PAhDp7pLbGoccI3iRHRWWLGcQgrz/d0duQXcOaZhHpQ9D0J5/am68Yrvs392DIOW130mL4K6Tl5Ja2hm8Bg0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM5PR0102MB3333.prod.exchangelabs.com (2603:10b6:4:a3::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Mon, 20 Dec 2021 07:26:57 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 07:26:57 +0000
Message-ID: <e850857c-9cab-8e16-0568-acb513514ae8@os.amperecomputing.com>
Date:   Mon, 20 Dec 2021 12:56:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 36/69] KVM: arm64: nv: Filter out unsupported features
 from ID regs
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
 <20211129200150.351436-37-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-37-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:610:b3::30) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fc5df3d-9a35-4639-e77a-08d9c38a1b1e
X-MS-TrafficTypeDiagnostic: DM5PR0102MB3333:EE_
X-Microsoft-Antispam-PRVS: <DM5PR0102MB33337ED9D7D0ED72167382F09C7B9@DM5PR0102MB3333.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5YlcipAok0+80AIQ4i2sXljnRLwFDLf57GpcRdO/3LiYIu/yo9ni70E3RnAAii3y61PUPSWELRlhNcCRZ4iRXw7HGwzTKIOyC4UyvbgnFd9zYKZRy39XC1yN2HQ72TVeSME3HEkwGKhcU4F6+JTbv6mZ+bxrEjmEW37pAc90Yt+K6JKpMdF6ilX8h+Us674S4vcqfl7e/Q77gmDwm9jRrwjh+my/fdCgc4aP/V0QKpNqsK9OdIJiu9V5OH3jzj7HJ7vua+3siX7s/7L8KF+2sjK8vQ1B7HvKet9oCty64ZKioF04VOnVhMnT//JHdj6W8K+uIUy99PpHjL93FIn1sQUOQOIlIj9GvQQ1Nn0praZnbbP4IqmalXALw08KiGMkaYd3koT9tVmq/6zcaQ/kK3jRkLANZ/n7gwHGboSI40W2cBGX0kb9zAxU7oGj8WhIWGGh5MjK5e85YQnmZOjCYAgSiCpxREWl4/tqOsuV+X/3ydO8pbwXxiQDX2SGI9wD3eVxyGkcVdmV9o20ZyP8IRJFprZ0zcntjMxJxb1v3k9YepDbRQgEAeQ8k/K96mHL4V4y8FQTte8qsQAEH0lo9USijFTjPAFFgVaETiNWJpUql7vro4hw5M9+yiWZvRLRhgX1I8br3TX79v6lguas8PhWpZNuSF9ktsNIIxRcllt7ezbZcqngLMttu986nB183eXFwAVY3Cq9VVmFg7ECaWbDIMmbBUm+IUn7Xi4/P8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(7416002)(66556008)(52116002)(26005)(508600001)(83380400001)(2906002)(316002)(5660300002)(66946007)(86362001)(8676002)(6512007)(38100700002)(6666004)(54906003)(38350700002)(4326008)(31686004)(6506007)(31696002)(66476007)(8936002)(6486002)(53546011)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjBRSi8raStGQndMazc2U0xBeVJzcmNxclR3MGNkcVVrSk4xUjZGOU9yM3Vz?=
 =?utf-8?B?NnY2L0loLzFobmhkN2xOajJPQVdacTU0RmdkTzVGbnZGMXI3L2Z0SlRoVjg3?=
 =?utf-8?B?Zmg1aWRiWkpFMy9icllLSHdyVTJJU01TUnVUd1JwcVNEWjh5blpjUkw3cXNJ?=
 =?utf-8?B?TWFEczdHOHF4NENqMFhIU2VGNEF6REVESU5rWjNPaURKOVVtMjFOY3ZxbElW?=
 =?utf-8?B?ZU1JdVJ3cmpLWTlTaGVMWmpJQVRWZnRIMWVpZkgvRWREVFNQTWI4bTVDMFFi?=
 =?utf-8?B?b2kzSTViSDBYcDgvQm1UQTcwTXVXY0lVRm9CMjljSURpcUt5cFNMS0pyRnZC?=
 =?utf-8?B?OVJXOW93Ni80RTJoaVR3SmwxWjJ1bXRZY1MybVJLZzdiUTJxVUh1TktrTEZ2?=
 =?utf-8?B?cnZBcENCNmo2WHd0UWRrS1ZzNmhOMWVxd0NSczd4cFRiek5samZodlh4Z1dl?=
 =?utf-8?B?Y2d2R0NMUkEvOWNXb09ROW9CbVdYSjd0OEJNU0Z4cWJCZGpmcjJhZnFpaVR0?=
 =?utf-8?B?bmVFN1FZUUFUc2tpU0t0RXBiR2w3cE1VVEVsUHlYQm1IWmxoZ1hCeDN4Zmt1?=
 =?utf-8?B?TEpSTHFmd2w2dXIwWWpRSHQwWGIzZkxaYXdWZGQwWWk1T0RUQUxubVkxUkds?=
 =?utf-8?B?SFM0MS9STlZGMFExTklrcnJLNnZIeXlyN1htVkhOSjc0UndrRkk3NG55V2FT?=
 =?utf-8?B?YTdGKzFNM1hRU1FwaktOWFRRdzBudFFucFU4Z00vS240Y3dJdVR1MTRtS0Uz?=
 =?utf-8?B?N1lqSXB2SDJBem1SNnVhNU1JNm14RWQxd3hZZ0lGUHN3TG13SGVEd0lRNWQv?=
 =?utf-8?B?UGllM1Qwd3RnVDMyMDBPMytVdWJTZWNWMmx4M3Mva2VSam9kdEpjcHFLMElt?=
 =?utf-8?B?UWhxVkkvVmtCTmxmV0NOV3haa2RFc1NsTnRFeTNSL2dDN3NqTGs1NG1yNGxj?=
 =?utf-8?B?YzVsYWt5ZHB1QjdKQjQ4akw5WWhIenFEcmM4dUhHcXVDSHV4M20vMWMvMnJC?=
 =?utf-8?B?NGx1bXBwUnQ1clVmWkl2QzhoWUxsdTk0c2FXRUxZcDFiWWVvdlptTzkva3RX?=
 =?utf-8?B?ekduZUY0ODRBUDhGR3I3TlNiaFcvQ3B4TVhRYW5vb3docXZVcEVGZ0d5a0RL?=
 =?utf-8?B?dHNYYzd1WGI0Qy82aEwvb0xLNUpTM0ZZZmhPVDk5V20ycnNQSEdkZXVQRHRL?=
 =?utf-8?B?R0tIODZjTzBqbVNzWlhhWGJsSThxQkR4Y3h3emk3MWdGYkNoRUxISklPNzd0?=
 =?utf-8?B?NE85bDdqclFDNGk1eFJoU2FiNE1jNFp4dUdscWg3Q2NyTk1qK2cxakJOVWtP?=
 =?utf-8?B?QlhHTVV3Rk1hcklQbnZGWUQvbXFnOGx5ZWI5ejF3S2VCM0hvbTJ2UHlKdkFY?=
 =?utf-8?B?SEFBS3BoTmo4UHlabjNWbHFQNU91bHN1Nk82QmdPdGlZS04zMVJCUFo4cDha?=
 =?utf-8?B?YUZUTDc4S25WVmQzSzkxTjR4T3FaMVozeHQxSGg1SFdoQXl6dkprTHVGbVlx?=
 =?utf-8?B?UjIvbEFFTE15a0x1enRVTlZDVVlxOWRvY05IMVVmTEN2aEVWdXAySHB4TXh3?=
 =?utf-8?B?dzdCTXNjeWJpL3VGdE5MSHRPUnpVT2RMMnFzZTZxcUU0NTB0SEgvNlo3M3Jm?=
 =?utf-8?B?azMxZGx1bFI2c3owSTIyeWN2bkgxV3FHV0kzV25OdnFsQWIxdXpMako5NmJt?=
 =?utf-8?B?Wi9YeUdkWkR1Mk9Nc3dKOHVHK01VTVRaN1RlZy9yWGM2cE9vUmhUVWR4ZU1X?=
 =?utf-8?B?eFdacVpmWndFanlTSFJKYndOMC9MUy9BZ2tMR09mejBJRks1QzA0aGlzS2tH?=
 =?utf-8?B?RmNTQXJNSXVtUnZ2OVlaZzE3Q2pkOVhYemtxSzRza1VyQ0ZzN3dBNldid3ow?=
 =?utf-8?B?Q0xINngzam55UkVhdzAwV09yaE40VFE3dzJJbW4ybnhQUExjMlBDb1FjeWRZ?=
 =?utf-8?B?VnVIVDhzN2ZvbnA4ckdrMzRxVFRwbDVmMWluS3dyWmh4emRuenhCREpmRERS?=
 =?utf-8?B?MU9RNDRZK1BsdGsyTVl4NHZvWndsUEVxZFdMNUh2RUR4U0xhWWV2LzVWOUdh?=
 =?utf-8?B?T0hVYlY4c0hxSWFzLzh1TngvUnF2N1VydDBxaVV4QWFsZmNSdDA2VXo4OTNt?=
 =?utf-8?B?SlJwN0U3UVRQdWFKMENQWUtma3pGQk04MC96dytxYjJJbGFXZW9vZTFsTTND?=
 =?utf-8?B?UGc0ZHBCM3c0ajFCZmlneXlzeDkzcGN0SEtQRjRiTURyUElBKzZDZmVUTGw2?=
 =?utf-8?B?QTByU1lWZ3ZGTkpDY2lwOHFJR0l5bkpuR202TWJwaEJPTXFmYk14cWpjSEJq?=
 =?utf-8?B?ak5OMVBndXV6ejRFTFFjejNmSCtXUVhGTzZhN29OWjFRWGVzYUwydz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc5df3d-9a35-4639-e77a-08d9c38a1b1e
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 07:26:57.8486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AV8JXSHA0sMQudj8gAmEAVXJI0skctVOp0F+q74eSvVaawd9NwVuOphCzQM2QVow6rxMV6sSOeTdsIM+SJ+2ZddVgzoVZw5tdV4PVkxuw/o815WahfgrUaiTavx3O190
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0102MB3333
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 30-11-2021 01:31 am, Marc Zyngier wrote:
> As there is a number of features that we either can't support,
> or don't want to support right away with NV, let's add some
> basic filtering so that we don't advertize silly things to the
> EL2 guest.
> 
> Whilst we are at it, avertize ARMv8.4-TTL as well as ARMv8.5-GTG.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_nested.h |   6 ++
>   arch/arm64/kvm/nested.c             | 152 ++++++++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c           |   4 +-
>   arch/arm64/kvm/sys_regs.h           |   2 +
>   4 files changed, 163 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 07c15f51cf86..026ddaad972c 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -67,4 +67,10 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>   extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>   extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>   
> +struct sys_reg_params;
> +struct sys_reg_desc;
> +
> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r);
> +
>   #endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 42a96c8d2adc..19b674983e13 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -20,6 +20,10 @@
>   #include <linux/kvm_host.h>
>   
>   #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
> +#include <asm/sysreg.h>
> +
> +#include "sys_regs.h"
>   
>   /*
>    * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
> @@ -38,3 +42,151 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>   
>   	return -EINVAL;
>   }
> +
> +/*
> + * Our emulated CPU doesn't support all the possible features. For the
> + * sake of simplicity (and probably mental sanity), wipe out a number
> + * of feature bits we don't intend to support for the time being.
> + * This list should get updated as new features get added to the NV
> + * support, and new extension to the architecture.
> + */
> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> +	u64 val, tmp;
> +
> +	if (!nested_virt_in_use(v))
> +		return;
> +
> +	val = p->regval;
> +
> +	switch (id) {
> +	case SYS_ID_AA64ISAR0_EL1:
> +		/* Support everything but O.S. and Range TLBIs */
> +		val &= ~(FEATURE(ID_AA64ISAR0_TLB)	|
> +			 GENMASK_ULL(27, 24)		|
> +			 GENMASK_ULL(3, 0));
> +		break;
> +
> +	case SYS_ID_AA64ISAR1_EL1:
> +		/* Support everything but PtrAuth and Spec Invalidation */
> +		val &= ~(GENMASK_ULL(63, 56)		|
> +			 FEATURE(ID_AA64ISAR1_SPECRES)	|
> +			 FEATURE(ID_AA64ISAR1_GPI)	|
> +			 FEATURE(ID_AA64ISAR1_GPA)	|
> +			 FEATURE(ID_AA64ISAR1_API)	|
> +			 FEATURE(ID_AA64ISAR1_APA));
> +		break;
> +
> +	case SYS_ID_AA64PFR0_EL1:
> +		/* No AMU, MPAM, S-EL2, RAS or SVE */
> +		val &= ~(GENMASK_ULL(55, 52)		|
> +			 FEATURE(ID_AA64PFR0_AMU)	|
> +			 FEATURE(ID_AA64PFR0_MPAM)	|
> +			 FEATURE(ID_AA64PFR0_SEL2)	|
> +			 FEATURE(ID_AA64PFR0_RAS)	|
> +			 FEATURE(ID_AA64PFR0_SVE)	|
> +			 FEATURE(ID_AA64PFR0_EL3)	|
> +			 FEATURE(ID_AA64PFR0_EL2));
> +		/* 64bit EL2/EL3 only */
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), 0b0001);
> +		break;
> +
> +	case SYS_ID_AA64PFR1_EL1:
> +		/* Only support SSBS */
> +		val &= FEATURE(ID_AA64PFR1_SSBS);
> +		break;
> +
> +	case SYS_ID_AA64MMFR0_EL1:
> +		/* Hide ECV, FGT, ExS, Secure Memory */
> +		val &= ~(GENMASK_ULL(63, 43)			|
> +			 FEATURE(ID_AA64MMFR0_TGRAN4_2)		|
> +			 FEATURE(ID_AA64MMFR0_TGRAN16_2)	|
> +			 FEATURE(ID_AA64MMFR0_TGRAN64_2)	|
> +			 FEATURE(ID_AA64MMFR0_SNSMEM));
> +
> +		/* Disallow unsupported S2 page sizes */
> +		switch (PAGE_SIZE) {
> +		case SZ_64K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0001);
> +			fallthrough;
> +		case SZ_16K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0001);
> +			fallthrough;
> +		case SZ_4K:
> +			/* Support everything */
> +			break;
> +		}

It seems to me that Host hypervisor(L0) has to boot with 4KB page size 
to support all (4, 16 and 64KB) page sizes at L1, any specific reason 
for this restriction?

> +		/* Advertize supported S2 page sizes */
> +		switch (PAGE_SIZE) {
> +		case SZ_4K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0010);
> +			fallthrough;
> +		case SZ_16K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0010);
> +			fallthrough;
> +		case SZ_64K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64_2), 0b0010);
> +			break;
> +		}
> +		/* Cap PARange to 40bits */

Any specific reasons for the 40 bit cap?

> +		tmp = FIELD_GET(FEATURE(ID_AA64MMFR0_PARANGE), val);
> +		if (tmp > 0b0010) {
> +			val &= ~FEATURE(ID_AA64MMFR0_PARANGE);
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE), 0b0010);
> +		}
> +		break;
> +
> +	case SYS_ID_AA64MMFR1_EL1:
> +		val &= (FEATURE(ID_AA64MMFR1_PAN)	|
> +			FEATURE(ID_AA64MMFR1_LOR)	|
> +			FEATURE(ID_AA64MMFR1_HPD)	|
> +			FEATURE(ID_AA64MMFR1_VHE)	|
> +			FEATURE(ID_AA64MMFR1_VMIDBITS));
> +		break;
> +
> +	case SYS_ID_AA64MMFR2_EL1:
> +		val &= ~(FEATURE(ID_AA64MMFR2_EVT)	|
> +			 FEATURE(ID_AA64MMFR2_BBM)	|
> +			 FEATURE(ID_AA64MMFR2_TTL)	|
> +			 GENMASK_ULL(47, 44)		|
> +			 FEATURE(ID_AA64MMFR2_ST)	|
> +			 FEATURE(ID_AA64MMFR2_CCIDX)	|
> +			 FEATURE(ID_AA64MMFR2_LVA));
> +
> +		/* Force TTL support */
> +		val |= FIELD_PREP(FEATURE(ID_AA64MMFR2_TTL), 0b0001);
> +		break;
> +
> +	case SYS_ID_AA64DFR0_EL1:
> +		/* Only limited support for PMU, Debug, BPs and WPs */
> +		val &= (FEATURE(ID_AA64DFR0_PMSVER)	|
> +			FEATURE(ID_AA64DFR0_WRPS)	|
> +			FEATURE(ID_AA64DFR0_BRPS)	|
> +			FEATURE(ID_AA64DFR0_DEBUGVER));
> +
> +		/* Cap PMU to ARMv8.1 */
> +		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), val);
> +		if (tmp > 0b0100) {
> +			val &= ~FEATURE(ID_AA64DFR0_PMUVER);
> +			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_PMUVER), 0b0100);
> +		}
> +		/* Cap Debug to ARMv8.1 */
> +		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_DEBUGVER), val);
> +		if (tmp > 0b0111) {
> +			val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
> +			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 0b0111);
> +		}
> +		break;
> +
> +	default:
> +		/* Unknown register, just wipe it clean */
> +		val = 0;
> +		break;
> +	}
> +
> +	p->regval = val;
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9deedd5a058f..19b33ccb61b8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1431,8 +1431,10 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
>   			  const struct sys_reg_desc *r)
>   {
>   	bool raz = sysreg_visible_as_raz(vcpu, r);
> +	bool ret = __access_id_reg(vcpu, p, r, raz);
>   
> -	return __access_id_reg(vcpu, p, r, raz);
> +	access_nested_id_reg(vcpu, p, r);
> +	return ret;
>   }
>   
>   static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index cc0cc95a0280..d260c26b1834 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -201,4 +201,6 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
>   	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
>   	Op2(sys_reg_Op2(reg))
>   
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> +
>   #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */

Thanks,
Ganapat
