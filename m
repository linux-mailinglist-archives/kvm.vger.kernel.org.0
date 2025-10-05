Return-Path: <kvm+bounces-59502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF8EBB94DF
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 10:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C370D345AA6
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 08:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F2F208994;
	Sun,  5 Oct 2025 08:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="bnhTNpyq"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013072.outbound.protection.outlook.com [52.103.74.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A141865FA;
	Sun,  5 Oct 2025 08:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759653873; cv=fail; b=LqI3AKqwrArIAFnshAJZfNDj6FQo9cI92JMt3TBRw8XepSqwEvftWFMYUvnJUI8ME3A7P7gsxtVaUoaeOBtMZQMgp9JhNjMt5sWqwO3Z+ZO76eGshiMxC8VN6+KXanh7NZEXb39mn3ApuEjMdGAk/WvJVpLtIrVO9tHGQmV0yfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759653873; c=relaxed/simple;
	bh=gZ2BDZFL5EqQse1AX0qPtsLZEL9lmdRMrPq73wcagi8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eU78x2DCSus68UZed7fbT6TLmGLQGKP6qsVZvAXxlAWpNiS7aiIBUkTlcW7koOv+tgdartcpUZiI0plg/wbutEbd3o5D7OJSa03J/f9aVDgFGQ1b2SnGbOf+pFriNwKXvyGw7ZyjZxPAK6aFAz2Bbqe3QaT2JA391zkJFLQc2wU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=bnhTNpyq; arc=fail smtp.client-ip=52.103.74.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gh1rcGOL6oCNOr+SO2+ABobqgUxxFbtNeNLUFbey85v6x77PNbBqgfDj+pJc1lNiBGLi5U+8GVlGi3DK+6PU+Tgh1DIeoVQLVVgghPgHfyQLoj1gD+zm+ULmtkg0wg0S6gWuQceJf+ZoQhqyqCwoEPWjVJqOKHjOUKWBK/fVlau2Z5eTTRfnG2DqWAAg2zAOGJrKPaaX4GXGXYciAHzg5hkYmw+qfDCUbT/WebXBVdBdWjKxjh/C7MAQYpxDufOrSgAYcL6g8guZjL9b3PbiqaCsAnibyNqXBpN4RVqObGhJCAWVwtkYfAVX3J6JtB3ylaBXOZL3A1lkaP2mzV/eyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GBn8fNk/CwlZ69yhThcdETS6jlHK7nmkwRuvgCtqVU=;
 b=fDxU+mZUSQKv+YbizZIMXRmjEVybFqwLJjDx8ssK9cALX9yBDulxjJsoj5VN5wgPifj6ZW3CRsEgo4fdRjGtRXbVC5ws6YacQt11PaySekfBJQajsIg2Whn73voP5AhjzdBoHc2G8YclVIslYE4iayZxEo4cV+UEpa2PJVBcdEp6lmDkTkF0ClxfoQazOwKwNT6EY6mnCjIBsHLzGAlcvVAfdzkXWbzDqz/mKYXhbYp649pVw6f8F151VhrrstzM5Rin9r+L08UvfbGFM1RHu5EmeRjSea2zbHT/QOOjtqcF00hT2wI4SbyMkj2yQZCFYeR0uUsH8HO7K5Qy0eRNRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GBn8fNk/CwlZ69yhThcdETS6jlHK7nmkwRuvgCtqVU=;
 b=bnhTNpyqfPvYG9zkcLWjnj2SmUJvRWKZaXRsQXo49w8WDh37f/SrrmyPbws6rqKHYdatozEYOWZFumuFAK75Cci9/bIZ3i3vOWLggXEH50v+fL7jw4zyasozMyKaNMzoQMnu4xULiXHJTsVY5QF+4dFj0UO94YPSlYB9Y4HkiWy/OHX+29J8ilqz7foua0jpvcgUEoFqgrSjKUlgmLiPJX/MOjjDl7dY67++G2K3TnlZTsRhMtRau8+1jgve3OJ7DN9JyQFDAeWhr4YxGRnP0aYtuQYVHYXxM1KqdKgblBdlBEdG46IbyCKoKCJst8U2EicFOR1qJs+KVpilMGi99g==
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com (2603:1096:d10:5a::6)
 by TYZPR04MB5805.apcprd04.prod.outlook.com (2603:1096:400:1fe::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.18; Sun, 5 Oct
 2025 08:44:26 +0000
Received: from KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa]) by KUZPR04MB9265.apcprd04.prod.outlook.com
 ([fe80::3c38:c065:daf4:cbfa%5]) with mapi id 15.20.9182.017; Sun, 5 Oct 2025
 08:44:24 +0000
Message-ID:
 <KUZPR04MB9265EEB3E98A19CE443F8DC8F3E2A@KUZPR04MB9265.apcprd04.prod.outlook.com>
Date: Sun, 5 Oct 2025 16:44:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 14/18] RISC-V: KVM: Enable KVM_VFIO interfaces on
 RISC-V arch
To: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, anup@brainfault.org,
 atish.patra@linux.dev, tglx@linutronix.de, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-34-ajones@ventanamicro.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20250920203851.2205115-34-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0115.jpnprd01.prod.outlook.com
 (2603:1096:405:4::31) To KUZPR04MB9265.apcprd04.prod.outlook.com
 (2603:1096:d10:5a::6)
X-Microsoft-Original-Message-ID:
 <98017c59-7425-4b93-bd14-d5f9653e6e55@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB9265:EE_|TYZPR04MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: 77f3a465-6c8d-476b-3e7d-08de03eb62b8
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|461199028|8060799015|19110799012|5072599009|37102599003|23021999003|15080799012|3412199025|440099028|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFB3Wk1vRVNCYndqVkJ6aXpockxhT2NLWng5OVF5R1NNbXlManpRNXlwUE9B?=
 =?utf-8?B?Q1NHUGNUL09FdW8ybTVha3AyLzZ2NHBTcVpTN244QTBqQU1tT3owQ0Q0K1hN?=
 =?utf-8?B?Zm1ndXIxajdaNnMrNnc1emd2ZWxNeDNVYVJRUmhIdHVPZnZsOEVBekFjR3kx?=
 =?utf-8?B?aUlTZURJQUNrcXRTbWptcldJTEtDb2RuS01TUll4cjhYb21UOXNmbjU2WFdi?=
 =?utf-8?B?OXp2RWVUT3QvaFVzUXY2RkxvbGxkNmVERG5xTXh5c2lLZjhOb0MxanBHWmY2?=
 =?utf-8?B?a1BlWHJMdWwxWWRtUUdjYk16WnNSdWt3QWZJeUFMRHljNFhiSzVwVi9nL01O?=
 =?utf-8?B?c0xhcUE1aUNYcThKMzF5WVhyTFpwNVFNd0RHcjRvdS9NNUk0dTdDWlJmVEdh?=
 =?utf-8?B?Q283Mk54eEN6UXJmbDBhUUk3TmtpcjMyaHc1dENJY1hQTGpwYk4vMVl0S0JT?=
 =?utf-8?B?V1AzWkVDRXkzZExkaTFpcDFacG16RldrOFJvUnFjS0cyWTNNcWpYdmY5ckdF?=
 =?utf-8?B?TlRBaGg2QUxkMDNVOVkvc2Q4WFE3MllmdmFYOTFQSmZrZ2JRbktFRVZNL0Nt?=
 =?utf-8?B?bjdDZ05FTUVRMmlISUlub0thS21sUHBGb3NMbCtxVytnc2xnOUhSdlkxTHZL?=
 =?utf-8?B?cmcyR1pZQWNxMWR1OEcyaEdNeTd4b0wvK1h1Q3VtUndrMGd0c1ZBcjI3WXdC?=
 =?utf-8?B?UGh6ZGVmTHcyRmVHSmpkL2NnUDlkSXR5YUEzRnlTRDlEcnhDdHNDcXdnNW5l?=
 =?utf-8?B?S3VlV0NqMnRNcHhFa29ISm0wS01MWjVDQXQrMkRicVdrMzlibFZzU0RYWWJI?=
 =?utf-8?B?cW01dUNwelFJRTZLbkZSeUZ0Tkk2TG9kTGdFS0VtdkpDWVNDaVhkclBGOTJS?=
 =?utf-8?B?dEhYamZjUlFzTU84cGFuRFFSbnJnNWFyZzZTUXptalhrMWZDd2J1SmRzTDd0?=
 =?utf-8?B?enJlakFTcUxDWnVrRVpSWkw4TS9uM3MwRDZKbnJNM1ZjOTdGTDRiK3BoN0pH?=
 =?utf-8?B?Wms3dmNmY1ZiZmhsN2J6WkFlZTRpNmVIKzFPSkF3U0N6TWVLcGh4UDlSRktS?=
 =?utf-8?B?V0F6dks5N05haTRYUEZkK09iRDhWZnN6dGlDNUZrbittS3VIRUprMU5qYWZE?=
 =?utf-8?B?NWw4T2JZL1BiMVJPd05yWE92dnhkamllUnRYc0U2alRQUVJESWk0eWhPanMw?=
 =?utf-8?B?MnJyMXRWY2ZhQzZOS3d3MHR4TC9wcWdZb2FlUjRrNGpMZjJ1V2VDV05Qc1F2?=
 =?utf-8?B?VGk2aGgxbHArTDZqTnBBSnBRdk5BTWRYbWhUcmlWcGpQcjhZSER0RW8veCs3?=
 =?utf-8?B?bi8yb1hqVUdKbUd1NzZSZ29haWFOcFBicjJiNkxzdEJLMmpxdmJqcUVYa1lt?=
 =?utf-8?B?Um1IeUxWZnZrWGZYVUNCVml0WjRVaTdtSDBuUngzQ1Nadkk5ZVFwc2xrRjBy?=
 =?utf-8?B?U04yUStZOVlmWkMzNWpFbjhEMXEvRnJVNlNBQUZ6R1hsNlJhOFBmNk5VTkMx?=
 =?utf-8?B?bUxxTWgrS1U1MXJlcStMbWNLUlNqeFYwUzUxdmxReWpuZjliRW01WVJia0Iv?=
 =?utf-8?B?bWFHSE1BT2NjMzFUdWxEUzNSSUo5aGU3bDQzd2JUekhEZEd1Y2VGb1ROcVND?=
 =?utf-8?B?QjAwWFEzNU5yWStyeXJvUkl4NnBpM1E9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2d2Q3pkcExsR3kwV2lQUWZVdFl1akIrZkRTQjhMblNEL1dHNE94Z3JRa25n?=
 =?utf-8?B?WGtOZHdpVDNiTnRqQkpueHY3YnhZeTRSeXptTmdqZDVkaHY1RXJPMTRwSGUr?=
 =?utf-8?B?cGhucXNlU1dEQmw0Zis2WjFtZFB0ZC9JMEdNaXArNExqbTlIeENNUCt3Qm9P?=
 =?utf-8?B?S3BOM29XMGpSS0FiK1B2QlZ6d0ovZS9YTkFNSjNEZkxrSFlCNjhyN2p1b3Zk?=
 =?utf-8?B?QWsvTXJTR2F2QTRvbko0VTlpT2M5K3paQUpFM0N4NHljbWdLL0cyRTJtUksw?=
 =?utf-8?B?eEpJUGhFMHRPS3M1MEdpZzFTaGZEaldFNGNzQTFPUUQ2aGJiaDhUUnV0bzV4?=
 =?utf-8?B?VHRaeUJSZFlLaXBNdjkxR0xDcUF3eklsSnFtNFZST1psM1lzWXVuM3NqZmFQ?=
 =?utf-8?B?MkxXVXVmckNyUXBEZGZKQWh3d3VBRU9WeW02U1dFMnZZR0tXQ1Z3RlJMZGZK?=
 =?utf-8?B?bWV6Mkl0RklacDE5L0ZvSkhIa1BVcEpqWWoxakc2RnNHVWNyRGlRZE1iTk1M?=
 =?utf-8?B?WWNBVnRyb0NITmpadWUzb2t1eHljMDEwZkpSbVpWOVcrWUZNS0xWREl3QkRW?=
 =?utf-8?B?ZVJEYS82ZlVrTEJTNCtGdHdHVWozbTZtVWszNXVSWVQ0TXRBNURFNjJkbmZC?=
 =?utf-8?B?Mm14Q0lGK3dZalg2dE5RKzhjTmhOdElMejZvM2FEWFI0RmRDdjEyTDJJVEQv?=
 =?utf-8?B?QmZ6Q3VLemszVjlzazBRR1pvandNbXp6OWtXVm1GWkJmcFNIKzdYQ09iZzcw?=
 =?utf-8?B?bE0zTElKMVUrLzhXNzNaUWlqNkRHUVl0T3VpRVFDQXFTeituY0tPeGhDRFFE?=
 =?utf-8?B?QndYWmhET3V3eGdpSkRYRTFmaGVLa0k1NDlFdkJIQVNjNUE3aG1IUU4waWsw?=
 =?utf-8?B?RjRBbDdSZmxKNm4zQ0tnMDRVbDJsWFhsWW00MGllTFhNV0RBbU8rNEx2a1lP?=
 =?utf-8?B?WWZqRGJ2a2N0SWhQSWxLZTNoQ0QzZ0MzdzJQVm82VXd0eGxKbEhMa3c0WGh3?=
 =?utf-8?B?UmVlMzhiNlZjU3ZHcS9udUdmdzFIdFR4eU54QTF2M0FCYzNmNUpRcmNsTG1y?=
 =?utf-8?B?NDFlOXBLeGhkSzJxd2lKbUJ3dUpvUElRdXVvdzlCWDdFZkRXVlpDeWxCWjZx?=
 =?utf-8?B?WXpwVGJkUFAyMWM2S1QrRWpkRW1SK2VySFhhT2FwaUZMUXhYRmt6UVk5MXdS?=
 =?utf-8?B?c1ZINlpmMzlmMTJQbW1yWDl4WGRMZXZEWkE4WXBHSVd0UUFBVlJGNjBBbmdx?=
 =?utf-8?B?YnVKRWgya3EreWhvZWFLcFRuQm93YlY5SDM1VFY0MVV3WFNSelJOeGNJTm5o?=
 =?utf-8?B?ak9DRWN6eHNjc3l6RGR5YmJPd1ljYUZFUHlUbTR2TjlERUxFbnhDL0NOcTJV?=
 =?utf-8?B?MEdZeEhOT1VYZHVwMUZRYkQrb3YxZHF2cVlMZUU3TS8vVkhqbElER2VrZ0Y0?=
 =?utf-8?B?WjRxVjVrNkw3SGRwazd0Z3V2TW9TVDNtallLYUpLby9YVW8xN2VjZWNPMlBR?=
 =?utf-8?B?c1M0b1dLZ3FuY3NGTDVOM3JKbnd6ZHFMLzZNV2wyZy9IUkVnOFF0ekNsVWNV?=
 =?utf-8?B?UnNib3MrdDJZTVNvN2gwWkY2YXlTY0lXOTlNaTIvdE0xQ2g2YWl0dG01VWpw?=
 =?utf-8?Q?D9T/55MvRt3H+x6qb18sfGJ/zcCtTnYaBRKWPX03Yghs=3D?=
X-OriginatorOrg: sct-15-20-9052-0-msonline-outlook-38779.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f3a465-6c8d-476b-3e7d-08de03eb62b8
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB9265.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2025 08:44:24.3878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB5805

On 9/21/2025 4:39 AM, Andrew Jones wrote:
> From: Tomasz Jeznach <tjeznach@rivosinc.com>
>
> Enable KVM/VFIO support on RISC-V architecture.
>
> Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/kvm/Kconfig | 2 ++
>   1 file changed, 2 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> index 5a62091b0809..968a33ab23b8 100644
> --- a/arch/riscv/kvm/Kconfig
> +++ b/arch/riscv/kvm/Kconfig
> @@ -30,10 +30,12 @@ config KVM
>   	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>   	select KVM_GENERIC_HARDWARE_ENABLING
>   	select KVM_MMIO
> +	select KVM_VFIO
>   	select KVM_XFER_TO_GUEST_WORK
>   	select KVM_GENERIC_MMU_NOTIFIER
>   	select SCHED_INFO
>   	select GUEST_PERF_EVENTS if PERF_EVENTS
> +	select SRCU
>   	help
>   	  Support hosting virtualized guest machines.
>   

