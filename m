Return-Path: <kvm+bounces-2271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D447F44B5
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 12:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C17A9B210BF
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 11:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BCE4B5A0;
	Wed, 22 Nov 2023 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="BVJcd9sd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2132.outbound.protection.outlook.com [40.107.93.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF03092
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 03:10:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehu+/J+N9MWHegl++vdqI3nTsA4HODKwRrU5zg2pqj+A/GDhtoi+Unw+o5RISV21E+f1rLtSC5t2e/8U5MTY0mF9xOdAr3dQkIETtn2czzKXpxVB1ngmvAlrnc/yYPJRzPJGoR/GRr3p/G0dHavm+xeQD86gVdEfDsoaa5slBPhZgqaFPI/DFwHim/WQgmQG9ZLbAD3SYYQV5AQX+9b9MMdMtqcGqiFMAcCkhD4S+bfTFQ7WEa9Qi1SgTOEvqZfJh462LEakANfkBM5pC5fpNN7tVHVBlyWvJX095dOvUIGRfB/Yj/tMe07l49qlGa3G7xMcsfZeF/Jq0U00u5Jmmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJsboL0GXUSfU39kVfHTl+CkcXU63BWp31UEGf1buSo=;
 b=YD6YDZv+gjLvVk5nh7zTP+aIAmtvhBrDNdvbRhIgdfaumyic9FFqW8gPXco+MiF892knxc3CLpJCpoGlayvZkszpluXr1holHG4/kH4ts89UvXBv0R+EuvgJ4hwqR6AzrHXVAB7qyYfaCR570z4uXl6yPgqJkhLEp9hBojRmDtLwTcDv4ujmXtJ6n5jUnCU2b4yRf3mUD0UYij0j8Ir4+b6iUt1/pF0+UIx8BnIVK1RK70v1KSQgsMZG10rX2mO0ACed2+uYYtNNrJJu3bV+4k0yPlnpcEfxXO8UimqzwQbvlI4kG+kZ4p+foDRMVUANvNMESDBen/pX9+RjQqoWxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJsboL0GXUSfU39kVfHTl+CkcXU63BWp31UEGf1buSo=;
 b=BVJcd9sdUdx+7uq8caZSq7gIFzeGJ7kFRmh+Kg8MSHDxs4o/fsQgcSGLTZ7SVLGpsAzDbnrC0s5BFUvSJRl5iRAi5RaOiC4thOY3XiLfO2iVxUOZQsAglGzo6NZ+CF+SIgAnQLCuYyh033hEdkvoL65YIOsBUw4Vm1QySWHA0dQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BY3PR01MB6740.prod.exchangelabs.com (2603:10b6:a03:365::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.19; Wed, 22 Nov 2023 11:10:22 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7002.027; Wed, 22 Nov 2023
 11:10:22 +0000
Message-ID: <64cdd9ea-fc7b-4108-a896-43b16eef1553@os.amperecomputing.com>
Date: Wed, 22 Nov 2023 16:40:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <a44660c4-e43a-4663-94c0-9b290ea755e3@os.amperecomputing.com>
 <86ttpfzd5k.wl-maz@kernel.org>
 <67082409-f432-44b6-bf40-1af9b4b7b569@os.amperecomputing.com>
 <86r0kjzbnq.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86r0kjzbnq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:610:33::29) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BY3PR01MB6740:EE_
X-MS-Office365-Filtering-Correlation-Id: 71d8b343-d2f2-42f0-b196-08dbeb4b9ea0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iNEb6rNYpgSWtb8mCTjIkIYc2+jIzdFBRRQFKsdr2QbnR/lWtzeD3+l/tjOz840KYcLI3NOdYVSPYTFIdV6FfS1INyAmIssJzaMebnKH7b4J9Jm6XtgWxdmVLkqxpc5U8E/JH2qfNw/Y9M+oftpp2onwJvxUy/n/Ob1nXw/sXqFICBKcHOI5Ke4lbRpAhKkMmHq+dLz3w8fhKrjzgLH/Abw9KoFJzFQ2RRkHit/12CqmdLg8M4eMiEQCo0biVZ7BQJugYDt2gQtwcxhg2AYK0THwqzGPP9vHFv3Xys+EfaeS4yk3ciyEpYzpJhejhslnx7AEoFdkaZUgrQVnzC4Gubwc0tJAxr4KgUcrMZTtLQPao4rUJh4HiqSV1c+opcPQV2zjEqDmjND0NWggHxh/wwr0Z6j8p+D1P/YS8NoHvHTunFdScXef67qJFYTULdyhdSBkMaV1HKCBaO4VjQzgfyH7O2XpsggIMYTFvOrARV+I+ao29LK/sSbBgIQ1+AEbCWaQG4zK1xC1jg4quPqN30En2joLs7sklPFHL8Bt9wfTj+wj4RIWQtp8eM3e1Xx3oirB+hyN5zS85Z8SqiK3ebTUFxd6+vW0kziFO5DTB/g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39850400004)(366004)(396003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(41300700001)(31686004)(2906002)(7416002)(5660300002)(8676002)(54906003)(316002)(4326008)(8936002)(66476007)(66556008)(66946007)(966005)(478600001)(6486002)(6666004)(6916009)(6506007)(53546011)(6512007)(26005)(2616005)(83380400001)(31696002)(86362001)(38100700002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U291RStNcFdTc3g3TFpSMEpaWW83bjJRRUNQcHN1TVFoQ21aeG4xQlB5cHhO?=
 =?utf-8?B?MlhpazBoRjBSc3RMNkxsNkxPaEJDWEJkMC9JNld0Um9WZEk2L2s4bVh3b1Zi?=
 =?utf-8?B?QlJYYzBDWTU5QnBSQ0cvWDJzYXRZTmpKS09aMFA1N0FKWGZwWFFtaHF0Y0wz?=
 =?utf-8?B?Sk8ydy81bUZoUWdvR3NycENMZlpHZ3V3R3hiT3JET3lFZXJDd3VqVTJrenF3?=
 =?utf-8?B?TWNnSDVGTEs3eWFhUnNmb210bnFRcVNsTlJnSUdSNjF6RXpOQkJ0RXFGVjl5?=
 =?utf-8?B?b0xkdm8vNmFWemlnNkFOb2lhdFFkazBYeEJxMDJ2NEZZazUyNXZybEFzTmEv?=
 =?utf-8?B?eVpXbTNTR2FDSVNWcEQyUXB5Skg4c0h3TDNGMSthU1hDWXlra1BjK2FxbXFt?=
 =?utf-8?B?OHgwampMVVZrTFZGQ3ZnZURtSHhpRGo2SmlGczk3d1dSZjFabDdlSVNwUG9a?=
 =?utf-8?B?dVpFU0hjYXVQU051ZUoyR3o5eXoxVE9VWTdwcHgzZERtRC95QmZtV3pDZXRI?=
 =?utf-8?B?Q2dYR29VSmZxckZobExNK1NuK2puL2xkTlVwcjNRWlhCTnlyMEFHdjBIUEFl?=
 =?utf-8?B?U3AvRHFBSmZFc0ZUYVJFZUdyTVV1ZmR2SWdRUDJBVzE1NHE5d2J0d1dpZ3JB?=
 =?utf-8?B?ZHNLK3RRNWd6aEduY2xpL1pFMmk2U214WUNMRmVrVjhqQ3BwTVpMUVMxMEsw?=
 =?utf-8?B?SEFOZjZQbXFlbGpVZElXb0xEQnFiRmJ4djE4RzhiL2cwYUNnZ1ArZWUyQmJs?=
 =?utf-8?B?WXJESTJWS2RoN1NTSVpuVXk2WWw0L2FOMFJ1Uzd1RXlBeXZBTUZhWWFWcG4v?=
 =?utf-8?B?TnFxSzUzR1lSTXM4cmFEZ3g5WnNEMkg0NmhmODcwUnVKQUtqUUFOSTR2Vitp?=
 =?utf-8?B?MUN4NzE3YlVXT0RlODZURXN3VWEzSU50emVVSEN5YzJZTVNEZ2VLdlNOUWtp?=
 =?utf-8?B?WHArRDFTUjhZRWNUOFBiZUhHeHA2MjVvWXlmcks4Y0ZGWklldHZBVFhiNHhN?=
 =?utf-8?B?QlB4Y0ZiaGQ3ZGNQNXA5NzN3NVQwdmMwQWYyclZxcWZQdmlJcmlSamp4S01o?=
 =?utf-8?B?VVA4VGgvZkJmbzdJUjVVb2o1UmxpRzdTTzUzQkp2amJ4QXJQYWxxWHpmeXlt?=
 =?utf-8?B?YnpSbGFLUWUxdlJBUDdrY2NNcHdZUkozWC8vanArQlkwUjl2eTZkL1RJV09S?=
 =?utf-8?B?R3VZN1RWUWZjNTM4blhER3d0UVFCenVIakFpSTdyQzNYM0g4Y1BGSWtSTlJm?=
 =?utf-8?B?dGY2OTJzcWxSYlk4aTlMVGs1VFRZMi91R243Z25yeldab09STVdDQzV5VW9v?=
 =?utf-8?B?eHZta0V0SWVMYU5scFZraXhNTFFuSzBMMTlySFBUbzBQaVhBdU9KZ01pTU1I?=
 =?utf-8?B?Y3RFMVdCdnppT2VKN3VJYlVqM0c1N1JDb09SUHJmVGxxbW9sV2FtRzM4WlQ1?=
 =?utf-8?B?c05Wa05oWmJzbzBIcFZPQVFiWjlJUTQ1OFY4STF5aGRsSUpVRlVCRnFaUm9O?=
 =?utf-8?B?UDM3U25pT1VxcGhBTXRLTm5WVmRwaWhmckZGTWJrNEZLZUFXTTFxRjRIWXpi?=
 =?utf-8?B?T3ZlSTd6by9Tby91N3lFZEVMVjdDQXpldVFWV3RRVkRKcFo2RjlkQ3JMdng3?=
 =?utf-8?B?WUg0UUVsY0poSWZoV3c5d1Q4b0RxV0toc092NW84clNnR2dReWhuSm0ycnRY?=
 =?utf-8?B?a242cnd4NEpOUEtIcm4vRXk0OElHa3JQMmNIMlR6TjloSjY2MExOZ291VUVH?=
 =?utf-8?B?WUl1ZFNyRDdaVGZidTBkaXJ0dkdnUU10Q2ZoZEJYTE51YXNVTmtXaUN3WTl4?=
 =?utf-8?B?bklJUDhKRTM4TXM1YXJ5ekJNWmFja1ZkWXlZWEl6Q0d1MVFPZ2d6MUw2T1VC?=
 =?utf-8?B?Z1RJNDJMYm5qT2xyY0FBSDd3dFZmS3pLanFpYzBGOXdLcUZXMTZPN09SZzQz?=
 =?utf-8?B?MU1uSlVXN3hSaTV6Qys4VkEvRVdMSjAvTmVITnlheFljSkJ5bVV6NFVXSzI2?=
 =?utf-8?B?Rk9pYnZiNUVsMW04bm1MZUpXcDJwQkQrZjlNUkZLd01HVGNnNFpTRjF3SDNL?=
 =?utf-8?B?Vkl5UDhvMGJYWXZsUWZIbEZGTFo5ZlVkZFhMeGpOSU5jRk1wQnFlNjVNWWM5?=
 =?utf-8?B?My9oRUZKaXQ1dHBpNVJaMGNJS0pJK0Q1RVl2Q0FDc25ON3h1ODd0M1A4V2x4?=
 =?utf-8?Q?AT+4UR8/O3NBMq7G4ktFB5M=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d8b343-d2f2-42f0-b196-08dbeb4b9ea0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 11:10:22.0581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQyX2DEMokDFcEXcE41T1waOfA03Vy9hyM1EUC59WiMlWbMp91W8WbUhUTMTKMfMN2Stmdlb7C418DFkhLdgMthw78Z9Kt+ZtA7HB/OybfCMaxfqVBcOCQUNZCX42fnO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6740



On 21-11-2023 03:11 pm, Marc Zyngier wrote:
> On Tue, 21 Nov 2023 09:26:22 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 21-11-2023 02:38 pm, Marc Zyngier wrote:
>>> On Tue, 21 Nov 2023 08:51:35 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>>
>>>> Hi Marc,
>>>>
>>>> On 20-11-2023 06:39 pm, Marc Zyngier wrote:
>>>>> This is the 5th drop of NV support on arm64 for this year, and most
>>>>> probably the last one for this side of Christmas.
>>>>>
>>>>> For the previous episodes, see [1].
>>>>>
>>>>> What's changed:
>>>>>
>>>>> - Drop support for the original FEAT_NV. No existing hardware supports
>>>>>      it without FEAT_NV2, and the architecture is deprecating the former
>>>>>      entirely. This results in fewer patches, and a slightly simpler
>>>>>      model overall.
>>>>>
>>>>> - Reorganise the series to make it a bit more logical now that FEAT_NV
>>>>>      is gone.
>>>>>
>>>>> - Apply the NV idreg restrictions on VM first run rather than on each
>>>>>      access.
>>>>>
>>>>> - Make the nested vgic shadow CPU interface a per-CPU structure rather
>>>>>      than per-vcpu.
>>>>>
>>>>> - Fix the EL0 timer fastpath
>>>>>
>>>>> - Work around the architecture deficiencies when trapping WFI from a
>>>>>      L2 guest.
>>>>>
>>>>> - Fix sampling of nested vgic state (MISR, ELRSR, EISR)
>>>>>
>>>>> - Drop the patches that have already been merged (NV trap forwarding,
>>>>>      per-MMU VTCR)
>>>>>
>>>>> - Rebased on top of 6.7-rc2 + the FEAT_E2H0 support [2].
>>>>>
>>>>> The branch containing these patches (and more) is at [3]. As for the
>>>>> previous rounds, my intention is to take a prefix of this series into
>>>>> 6.8, provided that it gets enough reviewing.
>>>>>
>>>>> [1] https://lore.kernel.org/r/20230515173103.1017669-1-maz@kernel.org
>>>>> [2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
>>>>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.8-nv2-only
>>>>>
>>>>
>>>> V11 series is not booting on Ampere platform (I am yet to debug).
>>>> With lkvm, it is stuck at the very early stage itself and no early
>>>> boot prints/logs.
>>>>
>>>> Are there any changes needed in kvmtool for V11?
>>>
>>> Not really, I'm still using the version I had built for 6.5. Is the
>>> problem with L1 or L2?
>>
>> Stuck in the L1 itself.
>>
>> I am using kvmtool from
>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/log/?h=arm64/nv-5.16
> 
> Huh. That's positively ancient. Yet, you shouldn't get into a
> situation where the L1 guest locks up.
> 
> I have pushed out my kvmtool branch[1]. Please give it a go.
> 
No change, still L1 hangs. Captured ftrace and the L1 is keep 
looping/faulting around same address across kvm_entry and kvm_exits.

It is a weird behavior, L1 is faulting and looping around MDCR and 
AA64MMFR3_EL1 access in function __finalise_el2.

asm:
ffffffc080528a58:       d53dc000        mrs     x0, vbar_el12
ffffffc080528a5c:       d518c000        msr     vbar_el1, x0
ffffffc080528a60:       d53c1120        mrs     x0, mdcr_el2
ffffffc080528a64:       9272f400        and     x0, x0, #0xffffffffffffcfff
ffffffc080528a68:       9266f400        and     x0, x0, #0xfffffffffcffffff
ffffffc080528a6c:       d51c1120        msr     mdcr_el2, x0
ffffffc080528a70:       d53d2040        mrs     x0, tcr_el12
ffffffc080528a74:       d5182040        msr     tcr_el1, x0
ffffffc080528a78:       d53d2000        mrs     x0, ttbr0_el12
ffffffc080528a7c:       d5182000        msr     ttbr0_el1, x0
ffffffc080528a80:       d53d2020        mrs     x0, ttbr1_el12
ffffffc080528a84:       d5182020        msr     ttbr1_el1, x0
ffffffc080528a88:       d53da200        mrs     x0, mair_el12
ffffffc080528a8c:       d518a200        msr     mair_el1, x0
ffffffc080528a90:       d5380761        mrs     x1, s3_0_c0_c7_3
ffffffc080528a94:       d3400c21        ubfx    x1, x1, #0, #4
ffffffc080528a98:       b4000141        cbz     x1, ffffffc080528ac0 
<__finalise_el2+0x270>
ffffffc080528a9c:       d53d2060        mrs     x0, s3_5_c2_c0_3

ftrace:
       kvm-vcpu-0-88776   [001] ...1.  6076.581774: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a6c
       kvm-vcpu-0-88776   [001] d..1.  6076.581774: kvm_entry: PC: 
0x0000000080528a6c
       kvm-vcpu-0-88776   [001] ...1.  6076.581775: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a90
       kvm-vcpu-0-88776   [001] d..1.  6076.581776: kvm_entry: PC: 
0x0000000080528a90
       kvm-vcpu-0-88776   [001] ...1.  6076.581778: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a60
       kvm-vcpu-0-88776   [001] d..1.  6076.581778: kvm_entry: PC: 
0x0000000080528a60
       kvm-vcpu-0-88776   [001] ...1.  6076.581779: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a6c
       kvm-vcpu-0-88776   [001] d..1.  6076.581779: kvm_entry: PC: 
0x0000000080528a6c
       kvm-vcpu-0-88776   [001] ...1.  6076.581780: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a90
       kvm-vcpu-0-88776   [001] d..1.  6076.581781: kvm_entry: PC: 
0x0000000080528a90
       kvm-vcpu-0-88776   [001] ...1.  6076.581783: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a60
       kvm-vcpu-0-88776   [001] d..1.  6076.581783: kvm_entry: PC: 
0x0000000080528a60
       kvm-vcpu-0-88776   [001] ...1.  6076.581784: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a6c
       kvm-vcpu-0-88776   [001] d..1.  6076.581784: kvm_entry: PC: 
0x0000000080528a6c
       kvm-vcpu-0-88776   [001] ...1.  6076.581785: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a90
       kvm-vcpu-0-88776   [001] d..1.  6076.581786: kvm_entry: PC: 
0x0000000080528a90
       kvm-vcpu-0-88776   [001] ...1.  6076.581788: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a60
       kvm-vcpu-0-88776   [001] d..1.  6076.581788: kvm_entry: PC: 
0x0000000080528a60
       kvm-vcpu-0-88776   [001] ...1.  6076.581789: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a6c
       kvm-vcpu-0-88776   [001] d..1.  6076.581789: kvm_entry: PC: 
0x0000000080528a6c
       kvm-vcpu-0-88776   [001] ...1.  6076.581790: kvm_exit: TRAP: 
HSR_EC: 0x0018 (SYS64), PC: 0x0000000080528a90



Thanks,
Ganapat


