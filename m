Return-Path: <kvm+bounces-14872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7F58A7485
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0052B281FD9
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D47138486;
	Tue, 16 Apr 2024 19:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="efreX0vE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA8E137C29;
	Tue, 16 Apr 2024 19:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295169; cv=fail; b=JpVeusUlOTc+w/YorR62Bhe3uMM+/5IttWyLxpsXv+M21YR13nBG2p+Jn88OLwesfaAwFQfsfDPC2LRCt5fmg8BElsRexnQKQp7z6H2LN88tTmN02o44gKWNyr1/PQ9Y9wVTM0Ksk/OXdBJ9jEpvWDvZYljUY4aGjufiPseJtdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295169; c=relaxed/simple;
	bh=Zo9Y/KwGOKmQ0To7Lrw/6kel3Gp+a4wdXCVtK2gS5+c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d8rWaGVJfzFTw30tiqEUI+SPYmTxpXCzRFwXYtPm6xQB0KE0vWJs3l407kQJjhCVmMQ5AVK0ceBgl6K0vs2IcjuxE9fAelHHPQPlxgz9gB+ZqF6B0r3acguSN7LKXwWhroAGT6IOSgjI+jB2tyO+lQDKsE90vjfN2aJdX8Y40UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=efreX0vE; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nw+z6advdqjLqHlJFJfqEBNk0gHxarjQtbDzw6jmFz5U1e7u07mvOPTv3o6gUdN50mGhFiwQ+P/LNULOxcMSc1cXc36nHfg1PtpVjeSRtG7QbEYdQz1R46lJsxURlGbPuBH6QLzNmBZ8Rm6JqPdUgc1772EdxygLwmIPGgbIfwRcKjNwAy7zafXPuEwsIX4tlv2RaNeWWUdIr7ez+OeAdOpHL3FsCd7uPkWiGsWOC55VQ/4pbTlhW9H8zsQO/MBdXf4tQ0r3UdYjQ3HYeYHPkojk2Ddt7glup66axKq1i3p5BE0coQnDsAR+olTziE3KC9bo/qeUbyLcMVmz4pBS+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlbAsoQ0NWRGyOgit4lYWbPaYSNUKC/j3vYM3fTmpUA=;
 b=VTc7ujwGAsA59HxTMXAy2f1bAv9tSe2vuGrFid9NuZUUQwm3DwVYvKASKH+tfzssOCiq5TjVYc08IqXOwT4BXQllGigkSal+xY53jRhQHHTiQDJf6Zb232v9JYs2pO40SAcV25nJoAlC7Y6O4CIJUfoHM1Qt76VAZlx276KSzXM/OJDDf5hypdT95FuTBDdtkqIGuZ8zDhtsrzWneXB6FrncmzJbtoHFmyz2dNiPIE805+mUD2DxeGZH6RRDGhL5poAQILIpcUW8zgdMYlrGLPzFUFZyZyNgriroRyU4rwGrX31VxoL44ZYkQeFGCs1NQXrwUh6mRYIF3R3poq24Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlbAsoQ0NWRGyOgit4lYWbPaYSNUKC/j3vYM3fTmpUA=;
 b=efreX0vEIxYZtNfLKy0KBADzXPn1Zk4/eR1lGXTd+AH3z3+g08/yhvlah6Gr9eWJzTQSmWyXgcj6WP4eKNbOz5uUguvtQRKfViBjpBWyv/KGLnB2LVK3kZhJKK/hQv67+Ipw8KbFkG4ka3L0MpZFBRJebUTkfWVwMYPaB8u9tDQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:19:23 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::57f3:51f5:d039:ed24]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::57f3:51f5:d039:ed24%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:19:21 +0000
Message-ID: <7a57fbd1-d249-4ccf-8013-32ad1c29dd03@amd.com>
Date: Tue, 16 Apr 2024 14:19:19 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Set enable bits for GP counters in
 PERF_GLOBAL_CTRL at "RESET"
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sandipan Das <sandipan.das@amd.com>, Like Xu <like.xu.linux@gmail.com>,
 Mingwei Zhang <mizhang@google.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20240309013641.1413400-1-seanjc@google.com>
 <20240309013641.1413400-2-seanjc@google.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20240309013641.1413400-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:805:66::36) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM6PR12MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: 162b7387-ec69-47c8-7c6c-08dc5e4a1ed2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LPddmw+Jn/xIvGqwh/0lp3JDjp4yaP1ugHwRTO1d4RVzCttrfwaU1wUnFObJxfsIswldX1WHvJg2lZ8UB4pjF6suhwm8uIAs80alPqezaQsrdu+ry6aXEKyz61zkOppzP9c7g61J/ilnjXsstD1hcro25UuuY1+d/2jDtXtejsNIMvO/4a+0jLBJnPxZH93UVn4JISavualhPCANwakQ8Vlt9f+qrnV1V9IiFXMeCWtn6KhY1C8bmVxFBgp6bS0Gz0vj2EmU+kB0XRNqVMfuK6eZVvxPwtrjQtQRXWfmVXXd5v14sA5+Dnlr1aqT8THZiVNc8Pv57b3OTCuclMzO3BY63bgpHGFSc28ZTUi/tm1JFMQf1/TJoSCIp8TeXs3fsFFCOPG5MWxt3WcRKbiuLO7Ob6+ccb0apIYagDUY31WsQiPWa1vpqNpSt0R01/XaTwLg/ZHJDKF8XrzsnxSrrSI+u1K1Va6Xk+Z5NfbsCaixr5yIoS4ZfgB8fZ9AKAbgdba87poqAzuaZ5tHA6pmWD+BthABQbLeaPUeJWbL9quyAwGaH+Pp0DONL/UU47+sQPiW0xmO868DGnHmHmhhrPNFbcAjfrtkLR5fIpB8o1vY1iCgS7DHTZlp+APhKkC+1eNsYJpZLLnup4+JUyxdbjJqTEvZmBXXBlQVcG1G3uQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGcvbDJNb2QrWDdnSTRscVhpWUZvSUZuZlF5UjhaalUxVTNEVDAxRHVOOWM1?=
 =?utf-8?B?U3ovclBCNkdnMityU21rVE1YSjdWcGY2dzE5Q3JyRG5BcWRMY0xlcW93d0la?=
 =?utf-8?B?MzVLcWF4Q1A4K0hCS0c5citXL0VnY3E3SHBFODZmTktvR1F1dWJZazFZSDBP?=
 =?utf-8?B?TTdnMTRGdzg4Yll2M21GbWVDZll0VmU0VlZMMlFnY0pZRkNVeCtFT1FWNkNj?=
 =?utf-8?B?cEc5UkVuM0xpcE1La2F4UHU4blg4cjRlblFMcXpEbG42MWhiSXN1Wk1GR1Rh?=
 =?utf-8?B?c1ZUUGQ2dEJoMWdoSTdpMzVKWnBIV2xsSkdMMnhHYVF5ZjlBS004SlVmYzR2?=
 =?utf-8?B?YWFEeURrVVVRUG1XVFZZZVZaTWFlaXJjVkJISEFXd2dIa1ZyTGNrYkxLUlAr?=
 =?utf-8?B?VTVtL1JSYTJJUTRkaUh6Uk44QWp0elJ6d0szdHBXUENCRnVBQVIxcmRDeFJn?=
 =?utf-8?B?YXo5ZlVpUDQvRlFBWWhoL01LRk5ydFZYOW4vWW1lNlZJYXNqVlRMRnVraFBL?=
 =?utf-8?B?THF2b0VQL000SDd6a0J2WGxTS2JZOE95RGdSQkZBSUduVEdTaDhPNW5ROVV1?=
 =?utf-8?B?RDlnanZHL2dacUQwQ0tRRC9WZmtueWk1Y2l6SmhxZlA4a1RTNzNhRVVKaTVz?=
 =?utf-8?B?RlhzYXNNVXhBd2RHSmp5USsvYU8yMU1MZ3d5ZTAzRFJWc3d5NVkyNmVMTXVL?=
 =?utf-8?B?OUxFMTlGci9VMGp4LzUxNGJvdEZGMGhuRHdLa0s2SGxKV2xLa3hjRVJzUy9I?=
 =?utf-8?B?b2hWVXh2VVZvVSt2MUI1RkRqY2s2dUVJcHh3OWxpZjBHNWFkdjY1SFZhdEVV?=
 =?utf-8?B?dW80MjB3U2Z3NVhYc1ZuTkZsbzl4anNPTExBSGlKZEdBaUoxSW5ZZW55TUoy?=
 =?utf-8?B?dzh2MXY5MEo3ZVdjT1RFdDQ4clZBSzU4N2hiSGU2dFRIWmlzbGZ3RDZ5b0JF?=
 =?utf-8?B?ZUtmaTJydit6UFBZdE9yY3VQeVVkeSsxMXYxRjNNeXhzUlp5YitSdUtnWWwy?=
 =?utf-8?B?cDcyRVlpSFUzMFVVQVVWOFdpS1Y1dkNDWFhISGtnUEVZbXh3cFBlY25IcXNi?=
 =?utf-8?B?WXRpSXREUkVQNUpqZTJCdUpHQ2lOdlNhS2E1YnRNZEdRK01CdEw4VktIa05Z?=
 =?utf-8?B?NlgraDBsanM2S0ZrSDNtdnJMNGk1Y2J1RDA1TWFUYk5LclVxcnR1dkI0T2pq?=
 =?utf-8?B?ZjdvSTVUeHZDZUUzYWF3dWlnOEFtRit3TzM1Q05sVXRIR0pWbGE5NERhK2lo?=
 =?utf-8?B?d01keFBpZkJ2RS8zYTFmWlJ0bHMra1d1cms2UnJrMXpocEttK0hCSzZaOFJk?=
 =?utf-8?B?NVE4bVJXY01WV2lFcW1iQkdMNjhLamY5NHFMbUFqQmYzN3U3bElyczhmdzZJ?=
 =?utf-8?B?SnhZY0crREFDQ1hBMTJhOGdoVzhLQmpUVTFmL1FOQXp6ZXYrQzBiblJHUXA2?=
 =?utf-8?B?Vjh2RC9BaDBMZ3dYZXNGcFhQajdMVXBqSVFTeUFlUFVSQSsvOGZyenoxRGlJ?=
 =?utf-8?B?MDg5QlBxSGRIQUhPbkV4em1KV0pmanJLcm1pOGk0ZXBzbkp5bzhPZTVxdFA3?=
 =?utf-8?B?akM5c2ZBcXNBTU13cFR0SFhqWWF0OFMxYUtiZitldVRNMUVoeS83YTd5YzBS?=
 =?utf-8?B?T0F5dXJzNy9KMVJWM0hYL3FObTJaZE5uNUc5RGpVdnBGRnpBZ3BmYXVzU3ln?=
 =?utf-8?B?Ujk1MklIUkw2VFFHbkVxNkxuOE5RR0k0WVRYanNXSDVkY0FESDRRYUtBVk5r?=
 =?utf-8?B?TldGY1YwdlJtTXFqRWZPcXJWZXQxOVg2S2RFNi9xdzNoVXM0NWhqMWtkL1lL?=
 =?utf-8?B?U0pMNE1lWlNZN3AzMXRoM2ZTc1Q1dy9BSDFGNzlxQ2psYVNXVEtuaWFYdUl0?=
 =?utf-8?B?dzdDcEJiRGc4YnFpTVExcnRRSUJIVzlTeEJXN0dBZWNFR1RrRUJET1M1T2VI?=
 =?utf-8?B?SExCbnVaTTkrY1krYXF3dXRwUzc4dXloSG4xdTRyWGVyZnZFYlMwNlJZQWw2?=
 =?utf-8?B?YkJ0N1VQZlUvS2t4bXlIeXh1aHI1d1g4aGFhNzgxNTQ5QTlKUjZBd3NON2lz?=
 =?utf-8?B?REdaZ0ZCaVM3a1hUWi9wWml4UklZVXVNQmZRdzNmckxSbnJkVzl2MGNiT1pi?=
 =?utf-8?Q?nCsU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 162b7387-ec69-47c8-7c6c-08dc5e4a1ed2
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:19:21.9091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwTA+XBKKxtJMSZGEc4m9nVIUmh5fA7cuSb1OVQxo+KnEfVyJnEQNuQul6tW4hch
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267



On 3/8/24 19:36, Sean Christopherson wrote:
> Set the enable bits for general purpose counters in IA32_PERF_GLOBAL_CTRL
> when refreshing the PMU to emulate the MSR's architecturally defined
> post-RESET behavior.  Per Intel's SDM:
> 
>   IA32_PERF_GLOBAL_CTRL:  Sets bits n-1:0 and clears the upper bits.
> 
> and
> 
>   Where "n" is the number of general-purpose counters available in the processor.
> 
> AMD also documents this behavior for PerfMonV2 CPUs in one of AMD's many
> PPRs.
> 
> Do not set any PERF_GLOBAL_CTRL bits if there are no general purpose
> counters, although a literal reading of the SDM would require the CPU to
> set either bits 63:0 or 31:0.  The intent of the behavior is to globally
> enable all GP counters; honor the intent, if not the letter of the law.
> 
> Leaving PERF_GLOBAL_CTRL '0' effectively breaks PMU usage in guests that
> haven't been updated to work with PMUs that support PERF_GLOBAL_CTRL.
> This bug was recently exposed when KVM added supported for AMD's
> PerfMonV2, i.e. when KVM started exposing a vPMU with PERF_GLOBAL_CTRL to
> guest software that only knew how to program v1 PMUs (that don't support
> PERF_GLOBAL_CTRL).
> 
> Failure to emulate the post-RESET behavior results in such guests
> unknowingly leaving all general purpose counters globally disabled (the
> entire reason the post-RESET value sets the GP counter enable bits is to
> maintain backwards compatibility).
> 
> The bug has likely gone unnoticed because PERF_GLOBAL_CTRL has been
> supported on Intel CPUs for as long as KVM has existed, i.e. hardly anyone
> is running guest software that isn't aware of PERF_GLOBAL_CTRL on Intel
> PMUs.  And because up until v6.0, KVM _did_ emulate the behavior for Intel
> CPUs, although the old behavior was likely dumb luck.
> 
> Because (a) that old code was also broken in its own way (the history of
> this code is a comedy of errors), and (b) PERF_GLOBAL_CTRL was documented
> as having a value of '0' post-RESET in all SDMs before March 2023.
> 
> Initial vPMU support in commit f5132b01386b ("KVM: Expose a version 2
> architectural PMU to a guests") *almost* got it right (again likely by
> dumb luck), but for some reason only set the bits if the guest PMU was
> advertised as v1:
> 
>         if (pmu->version == 1) {
>                 pmu->global_ctrl = (1 << pmu->nr_arch_gp_counters) - 1;
>                 return;
>         }
> 
> Commit f19a0c2c2e6a ("KVM: PMU emulation: GLOBAL_CTRL MSR should be
> enabled on reset") then tried to remedy that goof, presumably because
> guest PMUs were leaving PERF_GLOBAL_CTRL '0', i.e. weren't enabling
> counters.
> 
>         pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
>                 (((1ull << pmu->nr_arch_fixed_counters) - 1) << X86_PMC_IDX_FIXED);
>         pmu->global_ctrl_mask = ~pmu->global_ctrl;
> 
> That was KVM's behavior up until commit c49467a45fe0 ("KVM: x86/pmu:
> Don't overwrite the pmu->global_ctrl when refreshing") removed
> *everything*.  However, it did so based on the behavior defined by the
> SDM , which at the time stated that "Global Perf Counter Controls" is
> '0' at Power-Up and RESET.
> 
> But then the March 2023 SDM (325462-079US), stealthily changed its
> "IA-32 and Intel 64 Processor States Following Power-up, Reset, or INIT"
> table to say:
> 
>   IA32_PERF_GLOBAL_CTRL: Sets bits n-1:0 and clears the upper bits.
> 
> Note, kvm_pmu_refresh() can be invoked multiple times, i.e. it's not a
> "pure" RESET flow.  But it can only be called prior to the first KVM_RUN,
> i.e. the guest will only ever observe the final value.
> 
> Note #2, KVM has always cleared global_ctrl during refresh (see commit
> f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")),
> i.e. there is no danger of breaking existing setups by clobbering a value
> set by userspace.
> 
> Reported-by: Babu Moger <babu.moger@amd.com>
> Cc: Sandipan Das <sandipan.das@amd.com>
> Cc: Like Xu <like.xu.linux@gmail.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Tested-by: Babu Moger <babu.moger@amd.com>

-- 
Thanks
Babu Moger

