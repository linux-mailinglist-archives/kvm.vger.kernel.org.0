Return-Path: <kvm+bounces-2427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E76F67F707F
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 10:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 165841C20F04
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A47179B2;
	Fri, 24 Nov 2023 09:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="SAJSUy+R"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2102.outbound.protection.outlook.com [40.107.243.102])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4A119A3
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 01:50:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mN9oNDgrtJ8fxOjDvt6O6Nzekhb83yvgHMTQEmu0iEXXVwHmSulb96JiCIAejZ0L8OUDzDIZOgswp6pvgLB2Hnb1m0YJwh5x6r9tGZVKN6F69ntmn4VWDBYXl10RtkGPNpuFuTO4DSRvc3oLoZESZEqlxBzQu4/IXlEXU3OrFdRSo7HGHXOLE57TCEJG2ncYKFi/LHX70Pfk0x8JaQvTHqGKNYbAXhzJIOyuYqDD8UyteUYw88vk6d/Jx/QeNTU/w0cIPD94JtvnKNRyVBKGAc48mBKs5P88NrovvVQOLIe6mU2F/i3rjJkHmggszfVl3htCTnUScINvquFxnGPefg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyrGk0l4Lx7eHD4tqJftCaQG0PgdU/Vhla33Ecrz02o=;
 b=J7RxiMKBT/zPsKgeUvkyrM0w3xqyCoXfNei0e97X1jdkcRHZz7ejSoh7jsafH0qmAoy1RCQU9LrOq1rubOFVI+q/AJOz1xnA2EzA6Aumn94pXdJhLMkabuNk2CPV1qN/a3SxjQjqBDsbRZgve3Imd0+jPDtmIqpIMQE7t83PEPkro5uiOj1Jb9uT3vSF04FLTDGpmrA+oSgxGWAhct1//Tms4oJn2fCq9qCyUmDmHImO0Kq4NOr1hm1Iu5e1SNg4dS/6TWXKqRIftrnTlNoymqnBGWGSzCnxDoQE5pNbJYkNZikaEVvJ3gDAodR0NeA3M4lh8CD10gBRdAmGi61u+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XyrGk0l4Lx7eHD4tqJftCaQG0PgdU/Vhla33Ecrz02o=;
 b=SAJSUy+RmXx54MDgOFZX22c3s2psAcTAbe4Q4qr4dzCSZ1TCCYFa6qRLF6YGlrLCgJK1d9zTWPlsBDpfHFkdN4l3uZWt8g33yvoIsAHgk91ZZXFal9SJNiFuBsgK5I9qTh4/JJkkGyrj1MlRd9I0v68eP2GQAQhyFypv/640Tg4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BL3PR01MB6882.prod.exchangelabs.com (2603:10b6:208:355::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.21; Fri, 24 Nov 2023 09:50:45 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7025.020; Fri, 24 Nov 2023
 09:50:45 +0000
Message-ID: <134912e4-beed-4ab6-8ce1-33e69ec382b3@os.amperecomputing.com>
Date: Fri, 24 Nov 2023 15:20:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Miguel Luis <miguel.luis@oracle.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <DB1E4B70-0FA0-4FA4-85AE-23B034459675@oracle.com>
 <86msv7ylnu.wl-maz@kernel.org>
 <05733774-4210-4097-9912-fb3aa8542fdd@oracle.com>
 <86a5r4zafh.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86a5r4zafh.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:610:5a::26) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BL3PR01MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: e923a1ab-2799-4c7a-e3b6-08dbecd2d400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9R7hEbGsFII+otW+/tLFzjj1Z7Lr1C5soAjOj5oduCjsQERq8QgHWjbF1iGg4lLqfzFxkfr5qLDlidtyeCGcBRIMbHGpfRhOn3GhiqHYDf3090KXlqpVJi+S0s39GSGLC7FDLs6ZssgHnd37UvynmYV1xzAuS4drMdQ4chyaBtVBh6++/3LlUe/JGAkHBwwkgwINsJndN0cdPWzUF3t+QILzo5tOkWqpPRSpb4BNSgAcsaXNffYwC9E93eVZhz99xWpQxuVuLD+pI1vgTsRayfURXQ/J53MPlWiMv6YPhOhrTVMw6zVvvuXrM7zL9q/k7WxNVei0QA1fISdoqI+8hBw7VlKJX+Tc65lt5Jh/B5fSVyA85waKDl/xFFr3OzxBh0mcYrruxQBBqZ4Kr6amHOp6HxIMMo5hq5KI5aGiW9wcF+BV8scX5DVGVg7ZktOwM10mONCaVZ8PMFi4hpRsipJDlLIrq2rLw98UsYb4c95CS1U3tsSOepmbGFyKzLIXh2Gk/yC3yOsI/4o+tXvbS+Y/3+vZv38EJ3izKOnmo06zN6ZjNvli1R8KHt75w1exrXrYMCvXQJRfbk4Ss6a6yhOzH1rTfADFfF3a7pOgNjw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(366004)(136003)(39850400004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(2906002)(5660300002)(7416002)(41300700001)(8936002)(38100700002)(110136005)(2616005)(6506007)(26005)(31696002)(86362001)(6666004)(6512007)(53546011)(966005)(6486002)(83380400001)(66946007)(4326008)(8676002)(316002)(54906003)(478600001)(66556008)(66476007)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzIwUEUwYVovMmk0d2JYVVZBbkV4UVZ3cDZKVGxzWFNCSkx6QmJLRHM3dC84?=
 =?utf-8?B?bGk4YllNckxjeDRtOXd5TE9lV2NQL2psWTVrejlDeEJTUFQ3YjV4YjRLczBJ?=
 =?utf-8?B?N000V2Rod1phc0V4eTgvSDFxT2M0Z0FDK1IxYzZxWEdsOERBNS9DNFB0Q0Rh?=
 =?utf-8?B?MStBYVlVSFpMblVnSjlwbTAyanQzTWM5OEYzR0tNZlVYL3dDTWNsS3F4VFp5?=
 =?utf-8?B?YWNUZmhVZWhEdDRSUzYzempzSThUdnZwTXhUQWs3WFhCZG9YUEtRYjNkUk5n?=
 =?utf-8?B?R3lMRXhEQ2d4VkF5OWZIdDYrakRWcVpVd1FOR2lKUHdoVFkxbEV3amlmd0t6?=
 =?utf-8?B?UUJoTXNjbHhoZWhvL09DOGIyS0M5UW42Y1ZlZmxVaDlIUzhDb2dlakFUMXF3?=
 =?utf-8?B?OXppMWdia05iTEVtUzhxdVFyWVN2VGhWTStYVmQ4NGpuOXNoZXZTSE43YWpB?=
 =?utf-8?B?L25Cd2JacHpSMER2T2oxYTU5RTNhZVJRWDlUMjdpQTR1VU11L0Y3OFhaVk95?=
 =?utf-8?B?UUpOQzh0VTE5U21pN040WUlrK1pXd08yN2ZjektJSzRQVXZIUnF0WHNIamh0?=
 =?utf-8?B?dWRaOVZwNFE3RTNtUU14QnUwTWhFMkNpR1Uza2E1RlFkYXRUaVpxc1B4b2dn?=
 =?utf-8?B?NC92elczS0NxQ0Q2UWtyOHFvZ1RWZ2FHNWdoYkhMNldhUHM2UitLOUsybVhI?=
 =?utf-8?B?OUl1dTVtNUtTelhaMHNLOERiRlpOclJxek04TkZWR3luaFErTnlBYmNwdXRU?=
 =?utf-8?B?TWE5dHZQd2MwaWZ0T0FQQ3E0aG5HRjlUQlVGNmQyV2VHaFlKZVEyYnRHTzhs?=
 =?utf-8?B?OHpLeEFtUmNicVBxNXNwbzBGRkZmQSs1N09VRHVqb0RWZGkvVmpzSFhoc1VX?=
 =?utf-8?B?dWxieTZaSEUwQzNtYUozRTVYTllEM3BSNTdTUW5HdFVxbEhpeUpLWVl6SXpk?=
 =?utf-8?B?Tkl0ZGVselJYTmFKazVVTDFJME9mZktBRmZZWHhBQTNURjUrYnl1U3c4SVJD?=
 =?utf-8?B?c21hbHJXbmo4c3l1RG53MUo0eGFpd1RjK1cxV2NkZ3MrbmswWHY5Q0VNRWpR?=
 =?utf-8?B?cmpqU3c0bjYwb3VYQzVFMTZxbmpzM3JLK3BZSVpabUcyOWVKVHBZbkQvczg4?=
 =?utf-8?B?di9hTXU3Z2wyb3hMOTByUjdyL01TU3EyU28zUnVPRXN4Rk1qNkhZblBQOFBa?=
 =?utf-8?B?bW0xUU44ZDNDQmVqc3ExTjhTOGxUTDA3NjdkWVd4eFBjV2JxU2F6Rk5PcGFM?=
 =?utf-8?B?Z3AydFBwNUk5TEJjcWU2Uk9Wd05WclU1cUlySUp2cXpuZndyckpPZGNPdFBh?=
 =?utf-8?B?Q2lSMlg1QWpJYm9rT2pPSm45K1J5NDVlU3dLQ0hWRzJnTG1FcW5DMWlnaVJx?=
 =?utf-8?B?b0pxSXNqSDRlSDFxSXBCR0xOdlFhTEhiSmRsVFQ1bENhclhlWkFXcHVyc2NK?=
 =?utf-8?B?Q1o2T2JsTVFRcDQ3dlpXNlpOcHYxWTQzK3NXcjZRQTJFNVoxRzVxK1B6TlM4?=
 =?utf-8?B?WHJXZlgvV3pUSTRmYjdMMFdjWEV6a1lqNUo4MU5HRTJ0Q05EUFluR0FzdnNt?=
 =?utf-8?B?SFcrZjNWNFVjQkpVRER5UnlhNU9Fc0hEVGhKYU0rZVFlNEFDNUltNHpPODVj?=
 =?utf-8?B?WnZpN0YrRHRRQytJcVQxVnYxQjdPbDc0NlBtcUtQa0d5c3ppT0NubHJmWDZ1?=
 =?utf-8?B?WE82UVRkbGhKRTFjQTVzWlZuTGgvQkpNcEhJcjQ4ekJORGhTcS8rREk3VzRa?=
 =?utf-8?B?UXVmUlZYcUVFUjFYOWVtck1VdHR6RDNXM1F1anhDcVhLYTVVaXlaa1ZaWFZm?=
 =?utf-8?B?bndlbXpKbTlHMDdaZld2Y1gzeVpxSnV1OW5Ca1BHdVlqQUZLd29UL2h6dWo3?=
 =?utf-8?B?cjZKdVhRejczb3kzZzF0Z0RTenp0R2hIdnZ0SHlhTkxBRG9iWDVYSXhoVlBT?=
 =?utf-8?B?SzFGeVUwc0VmWGowZlBMYVRxOUl4clZzNkMzYVhXWThKZWs0VVVSUUVYU2Nh?=
 =?utf-8?B?RUF0dEhoWEJIVjdVQmIzaXJyMmZWRWdNeE5mUDE5OUZvbk1YTmdadCtmUG1t?=
 =?utf-8?B?M3lsKytnazVmdFN4aVdsVFBWWG9OWmFaczYwK2FrZ2xaY3BSTnRqMFRLTG1m?=
 =?utf-8?B?R3NIOXNPdVV1ajdwVkZEeEdiMnRwN0hVeG84K0RmbnNTMjBoWGM0MFNJcnFZ?=
 =?utf-8?Q?ajucWUj0NyvrgyuUAcqh8lpQ2VqYUyPYLJqeRO3XS0I4?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e923a1ab-2799-4c7a-e3b6-08dbecd2d400
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2023 09:50:44.8965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jvxXE0AYec/i8mMSZsOjBz3Agq1Yrv+y/qHuxYM97QHKFoEF11S/jU/9jcvqv8ZcWX+7urUzbJEVHsWEXpqsIua2CQSjbkqmuBRVL//oz31qFTVwE7u7Xi3XkF6qJqj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB6882



On 23-11-2023 10:14 pm, Marc Zyngier wrote:
> On Thu, 23 Nov 2023 16:21:48 +0000,
> Miguel Luis <miguel.luis@oracle.com> wrote:
>>
>> Hi Marc,
>>
>> On 21/11/2023 18:02, Marc Zyngier wrote:
>>> On Tue, 21 Nov 2023 16:49:52 +0000,
>>> Miguel Luis <miguel.luis@oracle.com> wrote:
>>>> Hi Marc,
>>>>
>>>>> On 20 Nov 2023, at 12:09, Marc Zyngier <maz@kernel.org> wrote:
>>>>>
>>>>> This is the 5th drop of NV support on arm64 for this year, and most
>>>>> probably the last one for this side of Christmas.
>>>>>
>>>>> For the previous episodes, see [1].
>>>>>
>>>>> What's changed:
>>>>>
>>>>> - Drop support for the original FEAT_NV. No existing hardware supports
>>>>>   it without FEAT_NV2, and the architecture is deprecating the former
>>>>>   entirely. This results in fewer patches, and a slightly simpler
>>>>>   model overall.
>>>>>
>>>>> - Reorganise the series to make it a bit more logical now that FEAT_NV
>>>>>   is gone.
>>>>>
>>>>> - Apply the NV idreg restrictions on VM first run rather than on each
>>>>>   access.
>>>>>
>>>>> - Make the nested vgic shadow CPU interface a per-CPU structure rather
>>>>>   than per-vcpu.
>>>>>
>>>>> - Fix the EL0 timer fastpath
>>>>>
>>>>> - Work around the architecture deficiencies when trapping WFI from a
>>>>>   L2 guest.
>>>>>
>>>>> - Fix sampling of nested vgic state (MISR, ELRSR, EISR)
>>>>>
>>>>> - Drop the patches that have already been merged (NV trap forwarding,
>>>>>   per-MMU VTCR)
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
>>>> While I was testing this with kvmtool for 5.16 I noted the following on dmesg:
>>>>
>>>> [  803.014258] kvm [19040]: Unsupported guest sys_reg access at: 8129fa50 [600003c9]
>>>>                  { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },
>>>>
>>>> This is CPACR_EL12.
>>> CPACR_EL12 is redirected to VNCR[0x100]. It really shouldn't trap...
>>>
>>>> Still need yet to debug.
>>> Can you disassemble the guest around the offending PC?
>>
>> [ 1248.686350] kvm [7013]: Unsupported guest sys_reg access at: 812baa50 [600003c9]
>>                  { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },
>>
>>   12baa00:    14000008     b    0x12baa20
>>   12baa04:    d000d501     adrp    x1, 0x2d5c000
>>   12baa08:    91154021     add    x1, x1, #0x550
>>   12baa0c:    f9400022     ldr    x2, [x1]
>>   12baa10:    f9400421     ldr    x1, [x1, #8]
>>   12baa14:    8a010042     and    x2, x2, x1
>>   12baa18:    d3441c42     ubfx    x2, x2, #4, #4
>>   12baa1c:    b4000082     cbz    x2, 0x12baa2c
>>   12baa20:    d2a175a0     mov    x0, #0xbad0000                 // #195887104
>>   12baa24:    f2994220     movk    x0, #0xca11
>>   12baa28:    d69f03e0     eret
>>   12baa2c:    d2c00080     mov    x0, #0x400000000               // #17179869184
>>   12baa30:    f2b10000     movk    x0, #0x8800, lsl #16
>>   12baa34:    f2800000     movk    x0, #0x0
>>   12baa38:    d51c1100     msr    hcr_el2, x0
>>   12baa3c:    d5033fdf     isb
>>   12baa40:    d53c4100     mrs    x0, sp_el1
>>   12baa44:    9100001f     mov    sp, x0
>>   12baa48:    d538d080     mrs    x0, tpidr_el1
>>   12baa4c:    d51cd040     msr    tpidr_el2, x0
>>   12baa50:    d53d1040     mrs    x0, cpacr_el12
>>   12baa54:    d5181040     msr    cpacr_el1, x0
>>   12baa58:    d53dc000     mrs    x0, vbar_el12
>>   12baa5c:    d518c000     msr    vbar_el1, x0
>>   12baa60:    d53c1120     mrs    x0, mdcr_el2
>>   12baa64:    9272f400     and    x0, x0, #0xffffffffffffcfff
>>   12baa68:    9266f400     and    x0, x0, #0xfffffffffcffffff
>>   12baa6c:    d51c1120     msr    mdcr_el2, x0
>>   12baa70:    d53d2040     mrs    x0, tcr_el12
>>   12baa74:    d5182040     msr    tcr_el1, x0
>>   12baa78:    d53d2000     mrs    x0, ttbr0_el12
>>   12baa7c:    d5182000     msr    ttbr0_el1, x0
>>   12baa80:    d53d2020     mrs    x0, ttbr1_el12
>>   12baa84:    d5182020     msr    ttbr1_el1, x0
>>   12baa88:    d53da200     mrs    x0, mair_el12
>>   12baa8c:    d518a200     msr    mair_el1, x0
>>   12baa90:    d5380761     mrs    x1, s3_0_c0_c7_3
>>   12baa94:    d3400c21     ubfx    x1, x1, #0, #4
>>   12baa98:    b4000141     cbz    x1, 0x12baac0
>>   12baa9c:    d53d2060     mrs    x0, s3_5_c2_c0_3
> 
> OK, this is suspiciously close to the location Ganapatrao was having
> issues with. Are you running on the same hardware?
> 
> In any case, we should never take a trap for this access. Can you dump
> HCR_EL2 at the point where the guest traps (in switch.c)?
> 

I have dumped HCR_EL2 before entry to L1 in both V11 and V10.
on V10 HCR_EL2=0x2743c827c263f
on V11 HCR_EL2=0x27c3c827c263f

on V11 the function vcpu_el2_e2h_is_set(vcpu) is returning false 
resulting in NV1 bit set along with NV and NV2.
AFAIK, For L1 to be in VHE, NV1 bit should be zero and NV=NV2=1.

I could boot L1 then L2, if I hack vcpu_el2_e2h_is_set to return true.
There could be a bug in V11 or E2H0 patchset resulting in 
vcpu_el2_e2h_is_set() returning false?

>>>> As for QEMU, it is having issues enabling _EL2 feature although EL2
>>>> is supported by checking KVM_CAP_ARM_EL2; need yet to debug this.
>>> The capability number changes at each release. Make sure you resync
>>> your includes.
>>
>> Been there but it seems a different problem this time.
> 
> Creating the VM with SVE? NV doesn't support it yet (and it has been
> the case for a long while).
> 
> 	M.
> 

Thanks,
Ganapat

