Return-Path: <kvm+bounces-11977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB40487E431
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 08:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6703828149F
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 07:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A15A22F0F;
	Mon, 18 Mar 2024 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="EGcJ4zvU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2127.outbound.protection.outlook.com [40.107.223.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA8241E1;
	Mon, 18 Mar 2024 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710747650; cv=fail; b=i+x8qEhjXOBxIjcUGzoSWwMLJ0n5lmvZk2cSb9iS49xY5Ld7YUd16hb95OzXdsimTlcey0+Kwbta8DE3/dziUgNsZjLxv6skUFNhpUDZYZD1gRFNbuVBZTNHyYHig9Cw6CD+RlXxC9T9ujLiPheOLv1ugF19oJ40LA4rxeJV1hA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710747650; c=relaxed/simple;
	bh=8bbe7XXmsLC6kbqcGNy9Byvxj0UF8Vlt4MQ8mNsmttg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SoRq7zWJiKcE72qF8LKXse01K4/boekmynpOYuACZ8FaQZNkyIvxzTfoGywUu833/4qOXsGp3yyz9BCCSr8E93Z83HokWZnNe2KZQpUeDzeNQwgRnwAsinptlPQabVI+mS8LhqhjETHH8AG05UJRLAT+08CHekvCP20e3oJ2XNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=EGcJ4zvU; arc=fail smtp.client-ip=40.107.223.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzeX0R4+EUzMPqNXBKI2WZkb+BoQPPIdSvxFM5AGUO3WlcKg1WXReTU7qTSLEAwXlzAiRssvsKkkj9jXP4QFA0mmPfj3rW+C1cmDY4LmrIqW+LM7I80evvo7VDfxAS/F76Ao2iRxl6PR8hukLp7qDISu/bYQ5YfsjNbBRka1oivNgVqDLRp577fJSAHPq00rdFPv57Pg+KSGsgvNALFUSgjWDR0vHRtuTRQyiWgfa0bx7blt0/R7495iImIVPV5TrcXLxCIOmbjpf2uZtKHUadVDL/iFXXhIadX1Wm7HYlr5aWDvVY6ego7OCXBkFiw+zJx1vpSv91lQR+yge9TGcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjY+Onnn4YsdIXnz5zDWPQdHRLABu7dJ2X/07WCv9xU=;
 b=SN1x5rOUNVeXVkgR0hlS9NFBJlD0Vo1HNNmz0I9CUWV6PKDgiadtgmG5urMg4tIjO9wtvrHXNqw0ZeGBDL/3wYJapo3uBp8Dijqai4sBUOqjt2o5SD3Vq5Ehr+4uFPO3V9sqL78L5uPLeTuOmBVLYxHuqmfBOfVuaih+v83MlKpkYcVQYT3BBjiElcVvYBrC47d0T56CmoLKmeDj5q0U/9fAxkOBHMcdPd9P/XmjAUISryYAflwQxmAkm8IES0EPpYNo2nkLlbn4zAzspxbrWy4TSTIRVqcjJqQ5omJahv1/ej7vekDHD9wCApKSk4TQB9GnKjP+lhOUVm6H/uH5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjY+Onnn4YsdIXnz5zDWPQdHRLABu7dJ2X/07WCv9xU=;
 b=EGcJ4zvUzMD5YiYnJylSPrDhZIh8RshwqEtdoDDpdADI/OiTxsesUq8nPw/XfygQBlyoMRIMULgLsCHAQneEI18kVP6MmYhURM/fMGBr6UQ1iMKLNM5ibri42Gfqq9vpkas3imJ55MY06Su0cda/abdRtwcX/lwbuIYXo/Qr+Hc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 CO1PR01MB7324.prod.exchangelabs.com (2603:10b6:303:157::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.27; Mon, 18 Mar 2024 07:40:44 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 07:40:43 +0000
Message-ID: <e5267f44-5e9a-42a2-a921-5f3428b03c05@os.amperecomputing.com>
Date: Mon, 18 Mar 2024 13:10:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 06/28] arm64: RME: ioctls to create and configure
 realms
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
 <20230127112932.38045-7-steven.price@arm.com>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20230127112932.38045-7-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0243.namprd03.prod.outlook.com
 (2603:10b6:610:e5::8) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|CO1PR01MB7324:EE_
X-MS-Office365-Filtering-Correlation-Id: e4243d7a-edda-4f72-5035-08dc471eb79d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	x9VEJwm2kWzpW9kt5yf6XCyhjX8aUZeZ6rme1HA08LD9vdNheS2A2MKwIrJlLKcpf0yHU8u5eRKzY3JEiXDdXVilJyjlz78gMTyPXLhiQSOB1eFo5KFGYMePObJxNcUZu0l6JRAe6tuqR7HSiKNouK0AbCDDk0RDKCHE8igTyjuXhOJfLX5WshIcxxlIjdLPmM51Yw11R2FPFI2sJShVyBJL3aWFm2jNjKeNZX3cZSanva0Hq+Sqr94asRDbNReR/rBDrs3fGq+sR+emt9kSVU7O6lfG8m2DnmGlw5EN2MNgEAf2c6kxNJRlZsHlT0EpS1jSPgmKBAGrgnu2BVNAX6utGzRw7QvXXKW37tontReqMBNDqM47279mQt3dutwpSt5+t7SfFxDZH7ljK47VjZFFW2rcZ3H8VNMHsvgGS7QdkU9V+6WXJ9YHEf5KVOVHIX1g8h0/UkWkeKLzXN5hjmBTY5Tuz/q9OT2alakGsuaJWFUHORyheZnjAD4RMS/4Pfqf0V7WCYSUPOOjiTepxDt9yCuKGcYTo093AXD7rO3RQHa6hD6+2QhiV8NJifUq5IamgO3g+7AwpEHD/Pu+vTwpoCgw70AXLw/ADIVWASCtugg2dIoPlv92zQrJGOoo6btaqHilbgZ+UvuEnGaEdVZHPVyMUg7DqUVC7o7C1LE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFRwNy9TbkZiYnc0K2NFcU1paXZYejB6OGxxN0d4cUFCUURTMW1jZ1lRUEZG?=
 =?utf-8?B?MlpwZ2hBb2FPYS9HVWxZWTA4TGJrVnpXTEk5ZCtISFUzazVjRG9RZGNyN2Zn?=
 =?utf-8?B?RHBPM0xLbnRMV2g2eHMwVGNlMDVqUTdmamIxc3dYUlBkK0JsN3dFc29hUm53?=
 =?utf-8?B?bkwydHByS09XdVJEMWZvckhHNDBqTk5wS2dwZkxSZjk1Y1l3dzBCdjE3Z0tm?=
 =?utf-8?B?cWFwS2RwblpvS2VJRTc4UDZvZjdjSjdiUkFHdFdOb2dya0hmTVgzZk5vM3hq?=
 =?utf-8?B?bDNrMnJpTjFJZWhmWVdXZjlmZ1owaGRud2EvVnFxR0t1dnkwNWZ3YzJHOXJy?=
 =?utf-8?B?Z1hBVHNCazBWSnpRTU1ZeUFja0lPVXRFTzBvdGdMUHdVcTdDNCtpOG5jaitD?=
 =?utf-8?B?MzJlclZFOUZSNXBkZWhxOEhxVVVlUHMvSVlKdUJJbXQyMUNYUzR5S2RkYTAx?=
 =?utf-8?B?TnZJVEU1NGgxZndLb29UMWs2d09WY0NyYnBaVHFWcEJ5dUlNcUozcmpnTE0x?=
 =?utf-8?B?WVc2Ykp2OFVhOUlOVWpYZXpVMnhJd1RZTlpwM2lYckRLdXhpS2JBeVc1UHlt?=
 =?utf-8?B?cnF6eXNMYVdpOTY4V3V5MVBld3k3Sm5wZnplVXhqUlQwWDFVdnFGTVVSdW90?=
 =?utf-8?B?WExGYTlRQmZtckM1UlpVM0dham5LMEdNRktFdVh0T0FjaW96TXp5YS9SOFA3?=
 =?utf-8?B?TDg3VjRCK2F6RVJ6U0N1L2ZLUm9MbERoUytUdnZVcElVcDhOWDBKVmxFd1Bq?=
 =?utf-8?B?QmV5ZER0VncvYzlCTEJPODhRUzhWREtqdmpieUhBWGF2THFnbWhUK2wrOC9F?=
 =?utf-8?B?cVlPWmNhNFRndkNiR29RT3VESVVyUnJYNnRkcFZLVzRvVlNzNndpbkc4WHN6?=
 =?utf-8?B?MWhhYmk5TUZQQmlCd05jUnNYSzBzcC9IVHNKSXNjcm4zSk1naU91cnkycnQr?=
 =?utf-8?B?bU9Jby9hYUJUNTZoR2haeUVic0xNVjZwK1YvdGg4VEhKaU9Tamp2eEUzTTlL?=
 =?utf-8?B?RVRzRUFoVXpqL2ZUM0orZVNsUWdqdEFvRkR2Um1Dek02dEgrMGJyTGtXcTJU?=
 =?utf-8?B?N1pmMG5tQ0JWMVdhSUNScUVmUFdQV1dpdXUxOWFXOGJPaDFiYWpDUXNJR3px?=
 =?utf-8?B?SStqb1lXNnlodUNtRGYxMnMzTDdwbDF0dEVjeTZUZ21XK0puKzZ4cTcwcjJX?=
 =?utf-8?B?S0ozaGFicWh3UkExY1FMK0gyWXNwWTgrZllidUJlR1hneXVGY0cwWDlaM0dN?=
 =?utf-8?B?WHhjbVJQdDZsdTZuR2Y3T1Y0Z2JhT1FIM2hHYWN5QlBCSWg2L20weWJ3MU1B?=
 =?utf-8?B?Z01wOUY2dDhSejhMRXd5OCsrMlZyeUZCYWxydXh1cjFtUEY4MEk5VUdDRlow?=
 =?utf-8?B?Y1BuakJKbWI4Zjl1a2hzT2N3TE9ydjRxaFA3ZFIzNWdRZDlRelNiRzJxZHBN?=
 =?utf-8?B?NHVKVE96RFpCM2Jra0dFM2Njc0xzYU9ya00rbkF0b005cm9NL3RiK1ZBRjJW?=
 =?utf-8?B?NzBNT2VyVGpVY21QeVNab1RsZDl3RjJnK3V2WGRvQTlPVkVTdVNsdDRPMkZj?=
 =?utf-8?B?QUJpTzAwYlVGYjI4MC9ZNkZnOUhxSnlpNGdXM0tkekJ6Tmo4NEMzZEhERGYw?=
 =?utf-8?B?V1N3WXlpU05kQndFbDFEVEI2ZERINUMrNFp0UjZjNDBUeUJ4VzJ5NFZCSDV6?=
 =?utf-8?B?d3JZRFpBTHF1RFlBdHV0STdXK1g4cXlkbi9kbWY4N2FDVXB3K2htS05Pbk4v?=
 =?utf-8?B?aTEwWGp6UTlQRDJCdWpRQU9GQitxbStjSGgwNzViRW43dGlGY01VWmd6c3Rx?=
 =?utf-8?B?QlE4U2ZxUEVvYjFEL2lFbS9pdHN0WXQ2a1U4QWRJdEtNb3dZNG5Mb1lUOGx6?=
 =?utf-8?B?cTMzLzk0NE5TZk9SWUR2QjJpMThYWERFSEk4U2VHZ1lYY2JnNWNaS2FUVU1G?=
 =?utf-8?B?V2c5dk5Mc2MvRjkyNFhpRUcydml6akpLN2hWRGFRcDhrNzZCODJiQk5tdW5U?=
 =?utf-8?B?Z1dUVEdvUXByb2dpUVIrMC9yVS94N0tNZjNTSDJQMDlFbTNFc2pHMmMwOXRO?=
 =?utf-8?B?RUo3Q3prWk94aG1UUElvN0E2V1ZIeUtsSzlBTGE5QjhDZm0rNFY1ektKUXho?=
 =?utf-8?B?MEVxUUpEaThDSjE2YVdQVEZON0E0dHg3bmRuaWdwQmQvZGZlSTVuVWJGRlBl?=
 =?utf-8?Q?yDEk8DObnyIlxV87CW5Y8rD7uzQrwhzQybJzrSbuyuvM?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4243d7a-edda-4f72-5035-08dc471eb79d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 07:40:43.6406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29UA+MwyIFDAJ1/wjFk7cqCq1O0MnCsH9frZCVPY9sd+sUKhVnIP7CUYlYmaaXbR8botjg5WJVtd+lPDOgMeiiJBA8SbqFcv3rSp1xhAVtzeMi4rDqz9dwZgzHn6NEht
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB7324



On 27-01-2023 04:59 pm, Steven Price wrote:
> Add the KVM_CAP_ARM_RME_CREATE_FD ioctl to create a realm. This involves
> delegating pages to the RMM to hold the Realm Descriptor (RD) and for
> the base level of the Realm Translation Tables (RTT). A VMID also need
> to be picked, since the RMM has a separate VMID address space a
> dedicated allocator is added for this purpose.
> 
> KVM_CAP_ARM_RME_CONFIG_REALM is provided to allow configuring the realm
> before it is created.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  14 ++
>   arch/arm64/kvm/arm.c             |  19 ++
>   arch/arm64/kvm/mmu.c             |   6 +
>   arch/arm64/kvm/reset.c           |  33 +++
>   arch/arm64/kvm/rme.c             | 357 +++++++++++++++++++++++++++++++
>   5 files changed, 429 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index c26bc2c6770d..055a22accc08 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -6,6 +6,8 @@
>   #ifndef __ASM_KVM_RME_H
>   #define __ASM_KVM_RME_H
>   
> +#include <uapi/linux/kvm.h>
> +
>   enum realm_state {
>   	REALM_STATE_NONE,
>   	REALM_STATE_NEW,
> @@ -15,8 +17,20 @@ enum realm_state {
>   
>   struct realm {
>   	enum realm_state state;
> +
> +	void *rd;
> +	struct realm_params *params;
> +
> +	unsigned long num_aux;
> +	unsigned int vmid;
> +	unsigned int ia_bits;
>   };
>   
>   int kvm_init_rme(void);
> +u32 kvm_realm_ipa_limit(void);
> +
> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> +int kvm_init_realm_vm(struct kvm *kvm);
> +void kvm_destroy_realm(struct kvm *kvm);
>   
>   #endif
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d97b39d042ab..50f54a63732a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -103,6 +103,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		r = 0;
>   		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
>   		break;
> +	case KVM_CAP_ARM_RME:
> +		if (!static_branch_unlikely(&kvm_rme_is_available))
> +			return -EINVAL;
> +		mutex_lock(&kvm->lock);
> +		r = kvm_realm_enable_cap(kvm, cap);
> +		mutex_unlock(&kvm->lock);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		break;
> @@ -172,6 +179,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	 */
>   	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
>   
> +	/* Initialise the realm bits after the generic bits are enabled */
> +	if (kvm_is_realm(kvm)) {
> +		ret = kvm_init_realm_vm(kvm);
> +		if (ret)
> +			goto err_free_cpumask;
> +	}
> +
>   	return 0;
>   
>   err_free_cpumask:
> @@ -204,6 +218,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_destroy_vcpus(kvm);
>   
>   	kvm_unshare_hyp(kvm, kvm + 1);
> +
> +	kvm_destroy_realm(kvm);
>   }
>   
>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> @@ -300,6 +316,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ARM_PTRAUTH_GENERIC:
>   		r = system_has_full_ptr_auth();
>   		break;
> +	case KVM_CAP_ARM_RME:
> +		r = static_key_enabled(&kvm_rme_is_available);
> +		break;
>   	default:
>   		r = 0;
>   	}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 31d7fa4c7c14..d0f707767d05 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -840,6 +840,12 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	struct kvm_pgtable *pgt = NULL;
>   
>   	write_lock(&kvm->mmu_lock);
> +	if (kvm_is_realm(kvm) &&
> +	    kvm_realm_state(kvm) != REALM_STATE_DYING) {
> +		/* TODO: teardown rtts */
> +		write_unlock(&kvm->mmu_lock);
> +		return;
> +	}
>   	pgt = mmu->pgt;
>   	if (pgt) {
>   		mmu->pgd_phys = 0;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index e0267f672b8a..c165df174737 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -395,3 +395,36 @@ int kvm_set_ipa_limit(void)
>   
>   	return 0;
>   }
> +
> +int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
> +{
> +	u64 mmfr0, mmfr1;
> +	u32 phys_shift;
> +	u32 ipa_limit = kvm_ipa_limit;
> +
> +	if (kvm_is_realm(kvm))
> +		ipa_limit = kvm_realm_ipa_limit();
> +
> +	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> +		return -EINVAL;
> +
> +	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
> +	if (phys_shift) {
> +		if (phys_shift > ipa_limit ||
> +		    phys_shift < ARM64_MIN_PARANGE_BITS)
> +			return -EINVAL;
> +	} else {
> +		phys_shift = KVM_PHYS_SHIFT;
> +		if (phys_shift > ipa_limit) {
> +			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
> +				     current->comm);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> +	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
> +
> +	return 0;
> +}
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f6b587bc116e..9f8c5a91b8fc 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -5,9 +5,49 @@
>   
>   #include <linux/kvm_host.h>
>   
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>   #include <asm/rmi_cmds.h>
>   #include <asm/virt.h>
>   
> +/************ FIXME: Copied from kvm/hyp/pgtable.c **********/
> +#include <asm/kvm_pgtable.h>
> +
> +struct kvm_pgtable_walk_data {
> +	struct kvm_pgtable		*pgt;
> +	struct kvm_pgtable_walker	*walker;
> +
> +	u64				addr;
> +	u64				end;
> +};
> +
> +static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
> +{
> +	u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
> +	u64 mask = BIT(pgt->ia_bits) - 1;
> +
> +	return (addr & mask) >> shift;
> +}
> +
> +static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
> +{
> +	struct kvm_pgtable pgt = {
> +		.ia_bits	= ia_bits,
> +		.start_level	= start_level,
> +	};
> +
> +	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
> +}
> +
> +/******************/
> +
> +static unsigned long rmm_feat_reg0;
> +
> +static bool rme_supports(unsigned long feature)
> +{
> +	return !!u64_get_bits(rmm_feat_reg0, feature);
> +}
> +
>   static int rmi_check_version(void)
>   {
>   	struct arm_smccc_res res;
> @@ -33,8 +73,319 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> +static unsigned long create_realm_feat_reg0(struct kvm *kvm)
> +{
> +	unsigned long ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
> +	u64 feat_reg0 = 0;
> +
> +	int num_bps = u64_get_bits(rmm_feat_reg0,
> +				   RMI_FEATURE_REGISTER_0_NUM_BPS);
> +	int num_wps = u64_get_bits(rmm_feat_reg0,
> +				   RMI_FEATURE_REGISTER_0_NUM_WPS);
> +
> +	feat_reg0 |= u64_encode_bits(ia_bits, RMI_FEATURE_REGISTER_0_S2SZ);
> +	feat_reg0 |= u64_encode_bits(num_bps, RMI_FEATURE_REGISTER_0_NUM_BPS);
> +	feat_reg0 |= u64_encode_bits(num_wps, RMI_FEATURE_REGISTER_0_NUM_WPS);
> +
> +	return feat_reg0;
> +}
> +
> +u32 kvm_realm_ipa_limit(void)
> +{
> +	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> +}
> +
> +static u32 get_start_level(struct kvm *kvm)
> +{
> +	long sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, kvm->arch.vtcr);
> +
> +	return VTCR_EL2_TGRAN_SL0_BASE - sl0;
> +}
> +
> +static int realm_create_rd(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_params *params = realm->params;
> +	void *rd = NULL;
> +	phys_addr_t rd_phys, params_phys;
> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> +	unsigned int pgd_sz;
> +	int i, r;
> +
> +	if (WARN_ON(realm->rd) || WARN_ON(!realm->params))
> +		return -EEXIST;
> +
> +	rd = (void *)__get_free_page(GFP_KERNEL);
> +	if (!rd)
> +		return -ENOMEM;
> +
> +	rd_phys = virt_to_phys(rd);
> +	if (rmi_granule_delegate(rd_phys)) {
> +		r = -ENXIO;
> +		goto out;
> +	}
> +
> +	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
> +	for (i = 0; i < pgd_sz; i++) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> +
> +		if (rmi_granule_delegate(pgd_phys)) {
> +			r = -ENXIO;
> +			goto out_undelegate_tables;
> +		}
> +	}
> +
> +	params->rtt_level_start = get_start_level(kvm);
> +	params->rtt_num_start = pgd_sz;
> +	params->rtt_base = kvm->arch.mmu.pgd_phys;
> +	params->vmid = realm->vmid;
> +
> +	params_phys = virt_to_phys(params);
> +
> +	if (rmi_realm_create(rd_phys, params_phys)) {
> +		r = -ENXIO;
> +		goto out_undelegate_tables;
> +	}
> +
> +	realm->rd = rd;
> +	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
> +
> +	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> +		WARN_ON(rmi_realm_destroy(rd_phys));
> +		goto out_undelegate_tables;
> +	}
> +
> +	return 0;
> +
> +out_undelegate_tables:
> +	while (--i >= 0) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> +
> +		WARN_ON(rmi_granule_undelegate(pgd_phys));
> +	}
> +	WARN_ON(rmi_granule_undelegate(rd_phys));
> +out:
> +	free_page((unsigned long)rd);
> +	return r;
> +}
> +
> +/* Protects access to rme_vmid_bitmap */
> +static DEFINE_SPINLOCK(rme_vmid_lock);
> +static unsigned long *rme_vmid_bitmap;
> +
> +static int rme_vmid_init(void)
> +{
> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
> +
> +	rme_vmid_bitmap = bitmap_zalloc(vmid_count, GFP_KERNEL);
> +	if (!rme_vmid_bitmap) {
> +		kvm_err("%s: Couldn't allocate rme vmid bitmap\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rme_vmid_reserve(void)
> +{
> +	int ret;
> +	unsigned int vmid_count = 1 << kvm_get_vmid_bits();
> +
> +	spin_lock(&rme_vmid_lock);
> +	ret = bitmap_find_free_region(rme_vmid_bitmap, vmid_count, 0);
> +	spin_unlock(&rme_vmid_lock);
> +
> +	return ret;
> +}
> +
> +static void rme_vmid_release(unsigned int vmid)
> +{
> +	spin_lock(&rme_vmid_lock);
> +	bitmap_release_region(rme_vmid_bitmap, vmid, 0);
> +	spin_unlock(&rme_vmid_lock);
> +}
> +
> +static int kvm_create_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	int ret;
> +
> +	if (!kvm_is_realm(kvm) || kvm_realm_state(kvm) != REALM_STATE_NONE)
> +		return -EEXIST;
> +
> +	ret = rme_vmid_reserve();
> +	if (ret < 0)
> +		return ret;
> +	realm->vmid = ret;
> +
> +	ret = realm_create_rd(kvm);
> +	if (ret) {
> +		rme_vmid_release(realm->vmid);
> +		return ret;
> +	}
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_NEW);
> +
> +	/* The realm is up, free the parameters.  */
> +	free_page((unsigned long)realm->params);
> +	realm->params = NULL;
> +
> +	return 0;
> +}
> +
> +static int config_realm_hash_algo(struct realm *realm,
> +				  struct kvm_cap_arm_rme_config_item *cfg)
> +{
> +	switch (cfg->hash_algo) {
> +	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256:
> +		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_256))
> +			return -EINVAL;
> +		break;
> +	case KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512:
> +		if (!rme_supports(RMI_FEATURE_REGISTER_0_HASH_SHA_512))
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	realm->params->measurement_algo = cfg->hash_algo;
> +	return 0;
> +}
> +
> +static int config_realm_sve(struct realm *realm,
> +			    struct kvm_cap_arm_rme_config_item *cfg)
> +{
> +	u64 features_0 = realm->params->features_0;
> +	int max_sve_vq = u64_get_bits(rmm_feat_reg0,
> +				      RMI_FEATURE_REGISTER_0_SVE_VL);
> +
> +	if (!rme_supports(RMI_FEATURE_REGISTER_0_SVE_EN))
> +		return -EINVAL;
> +
> +	if (cfg->sve_vq > max_sve_vq)
> +		return -EINVAL;
> +
> +	features_0 &= ~(RMI_FEATURE_REGISTER_0_SVE_EN |
> +			RMI_FEATURE_REGISTER_0_SVE_VL);
> +	features_0 |= u64_encode_bits(1, RMI_FEATURE_REGISTER_0_SVE_EN);
> +	features_0 |= u64_encode_bits(cfg->sve_vq,
> +				      RMI_FEATURE_REGISTER_0_SVE_VL);
> +
> +	realm->params->features_0 = features_0;
> +	return 0;
> +}
> +
> +static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	struct kvm_cap_arm_rme_config_item cfg;
> +	struct realm *realm = &kvm->arch.realm;
> +	int r = 0;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NONE)
> +		return -EBUSY;
> +
> +	if (copy_from_user(&cfg, (void __user *)cap->args[1], sizeof(cfg)))
> +		return -EFAULT;
> +
> +	switch (cfg.cfg) {
> +	case KVM_CAP_ARM_RME_CFG_RPV:
> +		memcpy(&realm->params->rpv, &cfg.rpv, sizeof(cfg.rpv));
> +		break;
> +	case KVM_CAP_ARM_RME_CFG_HASH_ALGO:
> +		r = config_realm_hash_algo(realm, &cfg);
> +		break;
> +	case KVM_CAP_ARM_RME_CFG_SVE:
> +		r = config_realm_sve(realm, &cfg);
> +		break;
> +	default:
> +		r = -EINVAL;
> +	}
> +
> +	return r;
> +}
> +
> +int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +	int r = 0;
> +
> +	switch (cap->args[0]) {
> +	case KVM_CAP_ARM_RME_CONFIG_REALM:
> +		r = kvm_rme_config_realm(kvm, cap);
> +		break;
> +	case KVM_CAP_ARM_RME_CREATE_RD:
> +		if (kvm->created_vcpus) {
> +			r = -EBUSY;
> +			break;
> +		}
> +
> +		r = kvm_create_realm(kvm);
> +		break;
> +	default:
> +		r = -EINVAL;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +void kvm_destroy_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> +	unsigned int pgd_sz;
> +	int i;
> +
> +	if (realm->params) {
> +		free_page((unsigned long)realm->params);
> +		realm->params = NULL;
> +	}
> +
> +	if (kvm_realm_state(kvm) == REALM_STATE_NONE)
> +		return;
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DYING);
> +
> +	rme_vmid_release(realm->vmid);
> +
> +	if (realm->rd) {
> +		phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +
> +		if (WARN_ON(rmi_realm_destroy(rd_phys)))
> +			return;
> +		if (WARN_ON(rmi_granule_undelegate(rd_phys)))
> +			return;
> +		free_page((unsigned long)realm->rd);
> +		realm->rd = NULL;
> +	}
> +
> +	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
> +	for (i = 0; i < pgd_sz; i++) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> +
> +		if (WARN_ON(rmi_granule_undelegate(pgd_phys)))
> +			return;
> +	}
> +
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
> +int kvm_init_realm_vm(struct kvm *kvm)
> +{
> +	struct realm_params *params;
> +
> +	params = (struct realm_params *)get_zeroed_page(GFP_KERNEL);
> +	if (!params)
> +		return -ENOMEM;
> +
> +	params->features_0 = create_realm_feat_reg0(kvm);
> +	kvm->arch.realm.params = params;
> +	return 0;
> +}
> +
>   int kvm_init_rme(void)
>   {
> +	int ret;
> +
>   	if (PAGE_SIZE != SZ_4K)
>   		/* Only 4k page size on the host is supported */
>   		return 0;
> @@ -43,6 +394,12 @@ int kvm_init_rme(void)
>   		/* Continue without realm support */
>   		return 0;
>   
> +	ret = rme_vmid_init();
> +	if (ret)
> +		return ret;
> +
> +	WARN_ON(rmi_features(0, &rmm_feat_reg0));

Why WARN_ON, Is that good enough to print err/info message and keep 
"kvm_rme_is_available" disabled?

IMO, we should print message when rme is enabled, otherwise it should be 
silent return.

> +
>   	/* Future patch will enable static branch kvm_rme_is_available */
>   
>   	return 0;

Thanks,
Ganapat

