Return-Path: <kvm+bounces-37221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2850A26F29
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 11:16:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 665DB1886BBE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188EC20A5C2;
	Tue,  4 Feb 2025 10:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wN7Sl9Bf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960F413C9D4;
	Tue,  4 Feb 2025 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738664198; cv=fail; b=sVSDPFwHQqkjwRnEKnUWG6MTXiaZucL7l3JLmqLenP2Etb1VyF4SWRbNUn064UvUByeOjq6aBc4H/xlTxDCwgWtMEQ5McUeBXde1uF+nCmK1wyrQmuY0YIgcuUGz7prkRE653NzcwTQrxJL05NAYivPN8MH4hwpbVzs6snJebt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738664198; c=relaxed/simple;
	bh=x8bHo+6VdpLig/R+zhG/QKsg0B1rIvEgqquEjUAw8nc=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bu64j9Ktx2PJ73Sglv6y5h7rAiIix3euslAup1w3KsK/FFG76pMNqslFIA4EotEt4VZbPcYwyyMF/Y8597mMUGy5mpPpSj6Eql+8LtR3rz28dn27sndXLLjPjlx9RZ5ZUKiqqu8TwS4N5mWqS0jOFjGC9Ltgud8CZoFkfGr3SAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wN7Sl9Bf; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sdI+DsqcdvqSXA9zIj3r8YBkur/gf2oFLacX2KbQaugQ+ZQoYcIqemoWPL3gNjmd6zsMw0GZp6SlKvFF+yApyydqaHNZP16QU4SNGpiQEjm3kjqjVw7GLZr/yOwPUg3ZQnZhXrPSPqR+ivL6vOvs2FjyaGnXD/Liw/CtpEEK7BsWOPGIxb698Md7LQKNjSg9bmVqKoPbEw1gaRo3X/ptHOQ3a9cquiII2KIu5vCNK44bxkbQwEQtTjeogVkzeMy91wSTzlVCBfDuhG7UugjE5QKTm/e7veqrlnTrSI0P+51xUprS0520QE2nEJ7B0r1jy6Y3k1EwbILj5qlpcXIg6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYQPtGe3YL7mSqevDlxs0Eh/1R6bR/R1bDkYQ9bo7b8=;
 b=amphElKyq4jYfC7uvGY3e6MNv2O4rkLDeXoAHV4ZHrkkfqCckqtsBW8kkECQbe+2HYkLllUQ9TvwFou3ZuQ1ijZUqMRsnyuTD00cG5mkOd4OabYNFjDQ/j1nsu2kWjPxT/6aFnzU7cyhrN2363zKWRkU2xOMAPrTjdYoJI7qembIrj/DbLZZ/u0BDa4PP78AZzSHEfGc609eHKB7cH/Cy90jMTWQiI30ntSar//1q3o5SWDDZ5VjVMKcEAzep/Cejlp61rKa74anHDMMSnfRh+TN5nt4L3rAVBC19oBEa9a2f4lAijkelMGWXVhYapjTbYdhYJ5+/UbfCj5L/c/RPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYQPtGe3YL7mSqevDlxs0Eh/1R6bR/R1bDkYQ9bo7b8=;
 b=wN7Sl9Bfn73RYQ5bhJZu0apyNVM5M8oNLLKoFLBKRCxl9awNmhpNrySfmQuy6rT3L5pZUFDLj8Ets/nIl2/dN6++4LBCuRQGph4GF5PKfEWsNAAOKn8yO6BsCxZKrvGwmSDSzT+HS74FkUbaqMMdvvRqGoiNl6RWvCw8e/2BznE=
Received: from CH2PR08CA0024.namprd08.prod.outlook.com (2603:10b6:610:5a::34)
 by IA1PR12MB6020.namprd12.prod.outlook.com (2603:10b6:208:3d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 10:16:32 +0000
Received: from CH2PEPF00000140.namprd02.prod.outlook.com
 (2603:10b6:610:5a:cafe::5) by CH2PR08CA0024.outlook.office365.com
 (2603:10b6:610:5a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.27 via Frontend Transport; Tue,
 4 Feb 2025 10:16:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000140.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Tue, 4 Feb 2025 10:16:32 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 4 Feb
 2025 04:16:24 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross
	<jgross@suse.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
	<haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, "Alexey
 Makhalov" <alexey.amakhalov@broadcom.com>, Jan Kiszka
	<jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>, "Andy
 Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<virtualization@lists.linux.dev>, <linux-hyperv@vger.kernel.org>,
	<jailhouse-dev@googlegroups.com>, <kvm@vger.kernel.org>,
	<xen-devel@lists.xenproject.org>, Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 06/16] x86/tdx: Override PV calibration routines with
 CPUID-based calibration
In-Reply-To: <20250201021718.699411-7-seanjc@google.com>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-7-seanjc@google.com>
Date: Tue, 4 Feb 2025 10:16:22 +0000
Message-ID: <85r04e5821.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000140:EE_|IA1PR12MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: 819e76c7-674d-420e-8f62-08dd4504ff4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjVsaXlpb0kwRG85WURkMTM3NmhwN1lJMU56bmIweHhTWDVYMWtJdXhVSkZu?=
 =?utf-8?B?bjZRdnJmSkZuZHI0a2R3bmQzODROSUVGVFlITGU4K3FNdlFwbWE2dXE1U2pS?=
 =?utf-8?B?bDV0U21ZeDNMRFNwU2d5c2c0dDVuY1dFTGxNQUZhbWRFUnRTZUY0dUVwWEo3?=
 =?utf-8?B?QVR5UFJVVUtiRjJCeXUrVWhyMU9jbDBRZEw1N0prNklUL0pDQmNrUkxOVUtM?=
 =?utf-8?B?Uk5najd1a0ZwWTdPbmxxMURtVm5CNGVmMlFLTVgrbzBWSzZ0ZzdMUXR5anhM?=
 =?utf-8?B?U2RMbGxsMkpFWStnZVBBdjFaTzdxM290d2I5RG1mT2NOenZMekRhQXRpV243?=
 =?utf-8?B?VktXNzZUMk1jUkNuMVFJVGlFN2JEQ05ac3cvWWg2ZHhjTWV6WVRUQ1dKMVAx?=
 =?utf-8?B?Y2hiUEJhR3phc0VnSDFJRjJ5dlhja1F5elF1eXltSFlGOWNvbnFSQkhVOWwz?=
 =?utf-8?B?cDhOcmR6Q1M4RldDelJnWUMrSWNzKytLeXhQeGRHV1R1U2J6VFNiYXNpWmJG?=
 =?utf-8?B?dHh4ektlYzZ6bmJzdmlSeG5qdnBxSTJadnZJR3hCVjRMQ1NCczlDbXdHK2Z3?=
 =?utf-8?B?ZFNMMDB6UFAxT2ROREdJU1NOcG1Kc3A1YkMrdmovbE5qN2x6bjFNaVhyc2Zq?=
 =?utf-8?B?QnhFdVJhaERvUWJ3Zk9DK1gxaElSd2d6N244RWFmeFhDWmd5UjI1Z2RTSmFn?=
 =?utf-8?B?UVRNcTd2NjA2TlVrSHR1WjdNTnpNd1UrdmNGWS9FVjdMVVpjald3bUEzaUdK?=
 =?utf-8?B?UStJcU9aQ2lFTkY2VllCdVdjbitVR1JwY3ZQVVNlenVBNHVabkpJQzJ6aThQ?=
 =?utf-8?B?amMra21rbWw1OE1OTUZUbG1hRC9JMXUyR0RGTUJBR3FJL3F1UUFVeU0xWmRo?=
 =?utf-8?B?aWJZczdVZFFQeXlxWlJ4dUhuN05aZS95ZzVqb244dDdHekhzdHRMcUhaL25v?=
 =?utf-8?B?dytLM2NGS05qdlhtRThqY0JVSlc5YXlyNmh6S0ZuL2dJWC96dEpLaWxKUnFL?=
 =?utf-8?B?Qm9QQisvUzV0d0t3NEE5NjhNdmZ6TmtEN2wwdWJOKzYrSTFpOWZwUFQwaSs2?=
 =?utf-8?B?aVZHVUdHN3R6eEtHaVhTajdwdldZOU9HQzZOaERhb0RwdGliVWgyWDUyOU9D?=
 =?utf-8?B?TkxkTUZLb2lyWUpMUzdDZU1uZzJKOFpIblMwbmNlY1paSnBrU2JTUXgybm9L?=
 =?utf-8?B?T1NjVVNoNWhKbU5sUzVmcWVhMGJCa29nenRDdzZ2dVc1SWZNcWw1YVk2dzVX?=
 =?utf-8?B?VzdPUmlGM1pNNFVMTEptZ3JFeXR6T0FnNTJjbW0xeVlGMWZJYmF0VEtzeHBn?=
 =?utf-8?B?ZUpoODFwSXIxTGZrc080TWxPQ1JGMStaRmFNbGdiYkpoSHZXR1U4VzBFUHps?=
 =?utf-8?B?Z0wxalFORS9QdlVOeVprTUFjY0pnbU5mcUZKbW4rSi9DeUJYZDN6ZUxBeCtC?=
 =?utf-8?B?eEh4emY5cm81eHEzdlVBbFZDNUV4OFhWMDVPaXkrbkQ3VmJjWlVZLytJSUIw?=
 =?utf-8?B?SzdSNzVNRXl5SWFMblliMDlwR1ZzTVJPQ01vR0phMUxCKzZNWEFIT3ZtNFBY?=
 =?utf-8?B?UEplRkpJdUNnNDhPTFJ0bHN3TzM2U0pTcUdoMmxxajhOOEhsSUlJZzVLVVBW?=
 =?utf-8?B?TXk4M0J4aXk1VmxFMzlHREtjRkpKUVhRT0luZFZ1Q1Y2VE1ZUkE1MFU3cnR0?=
 =?utf-8?B?R2V4MWJ1MW5oRXkzbFJQODM4Smo0OVFxMlNoaHh3K3R0c2dzNW40bm4ydUx3?=
 =?utf-8?B?cFB0eXVmbi9xb3ZrNG9yaHdiUUczdkhubkdyWGtzNmMxMWdvUHFMRVpwdDVD?=
 =?utf-8?B?S0lCd3haRnQzTmpuS0hvbGZVbE9iTEhFdm4yblBFZ0NGaDJURWNUTzYwYmgv?=
 =?utf-8?B?NGNTVGxXTDVqaDdMREFVc1hrZnRnU3M4T21EZ0NkQ0I5bzlxYmxybDdUMWtB?=
 =?utf-8?B?dXcxaFdRRCtDN0RKbUppVEVNMyt3a0h0eTFuMGdqNnhab1hWVkNBZUVPdTVk?=
 =?utf-8?Q?LyvLuDm9hjr5Fc1WuXL04KCWrDFcKo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 10:16:32.1287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 819e76c7-674d-420e-8f62-08dd4504ff4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000140.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6020

Sean Christopherson <seanjc@google.com> writes:

> When running as a TDX guest, explicitly override the TSC frequency
> calibration routine with CPUID-based calibration instead of potentially
> relying on a hypervisor-controlled PV routine.  For TDX guests, CPUID.0x15
> is always emulated by the TDX-Module, i.e. the information from CPUID is
> more trustworthy than the information provided by the hypervisor.
>
> To maintain backwards compatibility with TDX guest kernels that use native
> calibration, and because it's the least awful option, retain
> native_calibrate_tsc()'s stuffing of the local APIC bus period using the
> core crystal frequency.  While it's entirely possible for the hypervisor
> to emulate the APIC timer at a different frequency than the core crystal
> frequency, the commonly accepted interpretation of Intel's SDM is that AP=
IC
> timer runs at the core crystal frequency when that latter is enumerated v=
ia
> CPUID:
>
>   The APIC timer frequency will be the processor=E2=80=99s bus clock or c=
ore
>   crystal clock frequency (when TSC/core crystal clock ratio is enumerated
>   in CPUID leaf 0x15).
>
> If the hypervisor is malicious and deliberately runs the APIC timer at the
> wrong frequency, nothing would stop the hypervisor from modifying the
> frequency at any time, i.e. attempting to manually calibrate the frequency
> out of paranoia would be futile.
>
> Deliberately leave the CPU frequency calibration routine as is, since the
> TDX-Module doesn't provide any guarantees with respect to CPUID.0x16.

Does TDX use kvmclock? If yes, kvmclock would have registered the CPU
frequency calibration routine:

	tsc_register_calibration_routines(kvm_get_tsc_khz, kvm_get_cpu_khz,
 					  tsc_properties);

so TDX will use kvm_get_cpu_khz(), which will either use CPUID.0x16 or
PV clock, is this on the expected line ?

Regards
Nikunj

> +
> +void __init tdx_tsc_init(void)
> +{
> +	/* TSC is the only reliable clock in TDX guest */
> +	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> +	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +
> +	/*
> +	 * Override the PV calibration routines (if set) with more trustworthy
> +	 * CPUID-based calibration.  The TDX module emulates CPUID, whereas any
> +	 * PV information is provided by the hypervisor.
> +	 */
> +	tsc_register_calibration_routines(tdx_get_tsc_khz, NULL);
> +}

