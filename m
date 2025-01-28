Return-Path: <kvm+bounces-36744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8596A2041B
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:41:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0E543A6839
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54DB1D6DA3;
	Tue, 28 Jan 2025 05:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RFFrIxY+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B8D42A92;
	Tue, 28 Jan 2025 05:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738042893; cv=fail; b=JEKexyJIARkIHpVXzbw30xY1wFMYqGNIIwdbFpuxcl2hUdDpcugK3zy2austm8oKhbvmVXcHc1ZHwD9vTZLB5ntteyoOfUUDcJfP9H0xwTy8LdeV6Hi/P7sFtZpSlvxwg8ZPzgBFHtXT0d+xDyIZoQIpHbYS9bIDft/aulZt1+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738042893; c=relaxed/simple;
	bh=UmfuKJp+KPK8Rkz67ZrPWCERZcmxKnBUFP1hsWTwNe8=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=X+DT70O2rU24DUS+Jz01p7fOJeA66+GDTwp/y47ddy76WrHJCw+n8gqxTIq02MryxCs64foBCdCGim7CTIcjMLEZCJQEnK/GssNSWwrf81dXd5NbGCPEgsDtn/X4/4iX+uELsvNBX5ByMfPwAM9VKbEdMVSupQUpEoZUKeOY81I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RFFrIxY+; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tIuImkjkXjRFNK3mzo506W3aGHTEtF4bT1ClZchKx2slAsXUgddx/0rlJEwATPS0HvQoyHpDqqKH6ZdNz3sEjKOT/gfqGRhgCB/ZpvrrHxJ8sR0AA/gscwWqh5e3J/s4D0ENzFIRzyay2+fyfL4yQDUurT+BKAb0w7H7CPYOXUZYVNHgul9BwA8zSTKbFHR20kni8znnD2s/Z7G1E1r9xRb+ugMjxfV2sA3Zz9U/ygR8XI0iXF2Dy5i60YYoj6+9z8TM58K7boZb7SiQmVa2MgjgGz4Gvhjs3FZ88EJGmtGQpphPCrCwOpNsJLCec9JcHw4nE4J5jnqoW82HDoPahQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FS0Cz/Y8IPm04JlidV3KfOCvzuD6oJlychwz9iEtUa8=;
 b=Mtw/StKNwWRL7iYBNwYaHDpSsJCl4819WgmTDqKtptn+CVnv+CSjvG8Wyai9MfJtW2FL8ifUfUmS+GWI884/192xMSDbEQ+nnlCg24ZbFGrjydTsRxohkaJvbhYfwWEWbl5n8Ei+qQJkh7gNMnvbp4LptrHW+3TZzrm0Jtmki5OSZdO2ZmsA/n4ni3AsvgVuKgZDrre58GPgyYNtki1P9sKkNvKzmfns7UEjJsUyyfrEUcWHQrDmdXHRqg8OE4eJyHzjrNVuS8Y73UW9Jgya2crRTWZ5iF823UCbBk8ZNcuxqI+j1XKBk24LJQ8miL7gs8VDfogRbmzFVWqzbc1Tow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS0Cz/Y8IPm04JlidV3KfOCvzuD6oJlychwz9iEtUa8=;
 b=RFFrIxY+VwONNji6el8DkDFc6G8mpAym5EJL1e53gn+G2Q3b8/LnEmAhQ4xe8k55WvJHeyQpIZBUdkrU1LWpAIfAGi/22PkccBI0McjFCDiaDPi+Aj1DMVk1xW9mLXH8WzEcazzedf7Ha48+55wCKYrfwZsi20IcfVraRZrJ4qg=
Received: from BN9PR03CA0555.namprd03.prod.outlook.com (2603:10b6:408:138::20)
 by MN2PR12MB4343.namprd12.prod.outlook.com (2603:10b6:208:26f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.23; Tue, 28 Jan
 2025 05:41:27 +0000
Received: from BN2PEPF000044A9.namprd04.prod.outlook.com
 (2603:10b6:408:138:cafe::35) by BN9PR03CA0555.outlook.office365.com
 (2603:10b6:408:138::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.24 via Frontend Transport; Tue,
 28 Jan 2025 05:41:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A9.mail.protection.outlook.com (10.167.243.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Tue, 28 Jan 2025 05:41:26 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 27 Jan
 2025 23:41:21 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
	<thomas.lendacky@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <pbonzini@redhat.com>, <francescolavra.fl@gmail.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>, Juergen Gross
	<jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
In-Reply-To: <Z4gqlbumOFPF_rxd@google.com>
References: <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
 <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
 <Z36FG1nfiT5kKsBr@google.com>
 <20250108153420.GEZ36a_IqnzlHpmh6K@fat_crate.local>
 <Z36vqqTgrZp5Y3ab@google.com>
 <4ab9dc76-4556-4a96-be0d-2c8ee942b113@amd.com>
 <Z4gqlbumOFPF_rxd@google.com>
Date: Tue, 28 Jan 2025 05:41:19 +0000
Message-ID: <858qqvwl4w.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A9:EE_|MN2PR12MB4343:EE_
X-MS-Office365-Filtering-Correlation-Id: 68c23fbf-23b1-4bb8-dab4-08dd3f5e686d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wik9lWF1l3WIgYo9EQwK7TdwEDLhpZyfIyLNEbOL4Z1dKGM5DQN+KRIXwNRt?=
 =?us-ascii?Q?OjYbavRNFa8T1AJfXm+emJZmkb6SgvcCt09A3rHfCweTPax0yD4CFoBhOMbz?=
 =?us-ascii?Q?dhCNtwPasn6GNKzrXRHSCy1R4ipBfbjwdGlRxf9waLdJjwhUjwwoR9Wfn/26?=
 =?us-ascii?Q?iaaLz7mJMs4TBzQ8udnlmTH5GXhzzegPOZmRXD6cENRtVuxdJWHtJZEWBbxm?=
 =?us-ascii?Q?aN8760KMXSDV4koig7PFUh3a3l+uuV5a8cmLCQx3KoyEzDb/hl6sUhpojQe0?=
 =?us-ascii?Q?2T6OqXwc7B1jLu4Ko1E5IJr1ZwihI7tCrxlPD6IO9Qirw7MDGZO8+ssrIF44?=
 =?us-ascii?Q?GPtrlCpIGbmREEDLaUn1/ZbDiTvBK1kc/77FpmnEFw30KxUJLNI6lzGHKqjK?=
 =?us-ascii?Q?rJ+m8J2hkQ0Xjoph0g6XXcLaLA14vjLOVSuHu8jEn+sU03vL8IftnFQlQbTD?=
 =?us-ascii?Q?psD1TWYhP6d5h/HvNDouWQnTAJNXAuKaqeckfXFjKSKSUrUhAg0XEZLtGWOR?=
 =?us-ascii?Q?x8Yp3IDqkHdfBLm7aLc3w0iwhBAi/zNzFp19fJC4y0S8dx+1N32PJYhocBuT?=
 =?us-ascii?Q?5RqCToBx6ouWTREB1Cfr2pWwYjQW7zurPUP9HyKBIF1qv/gxqkL8td60VIFe?=
 =?us-ascii?Q?8fXQoSQcZMFHvHxIXUknQUva9jIqqNYKbae2Vd+B+b4XcPjfZEgKFYfc7d/A?=
 =?us-ascii?Q?EJVw0Fcaoeg4zMNhvzludNVsV8YylpYnUffYU92NcQRazv9gjuhpvHQDFmuK?=
 =?us-ascii?Q?4Z7wGQsg8OO2gJsV3qYs2yeMGGf9q3cCpmOTkC9vDdeVC1P/Hd/iO1s18anR?=
 =?us-ascii?Q?BelO4rFyg4oY9bApLd/vYK8xNmTaagi8Yi1ar3wydH5RVq3H2PPib0gXhp8u?=
 =?us-ascii?Q?uibhV427GZtSYhqTgxgkHg6MzKlCqLgFOxQmc2JRHT2MwgIrE7ye0mxkcVos?=
 =?us-ascii?Q?ByFhGt6h9jnSdma1Hb/r2qfVB9iDtGkMtS2nf+3F/hVCInPWli5r1t1myyV/?=
 =?us-ascii?Q?pGl8DQaYcwD64JfSVspbIKMYjAihpY46w8pBSLjXh2qvP5M+gqVZmyk/r+7g?=
 =?us-ascii?Q?ttt9dgQToI3n1Hkm+Ai34AcxLDwF4a8HWlAyNY1dIoBrpnGV6hwEKTs3Utnz?=
 =?us-ascii?Q?wyQC2Fhe+R+n5qiU5DT7Km+vcXvN5x72cbP3kQNjpTroSFiGmcBwX80qPnC4?=
 =?us-ascii?Q?f4EcljzmWpByW5ntQlKCQ9rtlMJuUEXTyGxLOBdwiRQhHZvA9gHhJpGPpJUW?=
 =?us-ascii?Q?BtXsxrWou1FrfyTmj5jfZyKG6ZF8Bk4KxxCW6fArHwU9cY664xbA/0k3INBB?=
 =?us-ascii?Q?ZrrgLLF40TJuEktAyzSdqwlLaNBKrOvnlUNiq/uw/XRERqTE7TosaljZ2oSp?=
 =?us-ascii?Q?r009BEo28MGm4VEt/wsNOiInVr0ch3OS4I7NG3OIgZ/qU8LSyHklT0jT8/Qe?=
 =?us-ascii?Q?DF9Y5iyL4x4rnfXCyCgnyk+d4NqfUT46ewwax4BWfSNPV1iSQ4xnkMMDDezo?=
 =?us-ascii?Q?CqRg7NeYi4JlMcQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2025 05:41:26.7202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c23fbf-23b1-4bb8-dab4-08dd3f5e686d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4343

Sean Christopherson <seanjc@google.com> writes:

>
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 0864b314c26a..9baffb425386 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -663,7 +663,12 @@ unsigned long native_calibrate_tsc(void)
>  	unsigned int eax_denominator, ebx_numerator, ecx_hz, edx;
>  	unsigned int crystal_khz;
>  
> -	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> +	/*
> +	 * Ignore the vendor when running as a VM, if the hypervisor provides
> +	 * garbage CPUID information then the vendor is also suspect.
> +	 */
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL &&
> +	    !boot_cpu_has(X86_FEATURE_HYPERVISOR))
>  		return 0;
>  
>  	if (boot_cpu_data.cpuid_level < 0x15)
> @@ -713,10 +718,13 @@ unsigned long native_calibrate_tsc(void)
>  		return 0;
>  
>  	/*
> -	 * For Atom SoCs TSC is the only reliable clocksource.
> -	 * Mark TSC reliable so no watchdog on it.
> +	 * For Atom SoCs TSC is the only reliable clocksource.  Similarly, in a
> +	 * VM, any watchdog is going to be less reliable than the TSC as the
> +	 * watchdog source will be emulated in software.  In both cases, mark
> +	 * the TSC reliable so that no watchdog runs on it.
>  	 */
> -	if (boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
> +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) ||
> +	    boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
>  		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);

One more point here is for AMD guests, TSC will not be marked reliable
as per the above change, it will only be effective for CPUs supporting
CPUID 15H/16H. Although, the watchdog should be stopped for AMD guests
as well.

Will it make sense to move this before cpuid_level check ?

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index e7abcc4d02c3..2769d1598c0d 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -672,6 +672,14 @@ unsigned long native_calibrate_tsc(void)
 	    !boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return 0;
 
+	/*
+	 * In a VM, any watchdog is going to be less reliable than the TSC as
+	 * the watchdog source will be emulated in software. Mark the TSC
+	 * reliable so that no watchdog runs on it.
+	 */
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+
 	if (boot_cpu_data.cpuid_level < CPUID_LEAF_TSC)
 		return 0;
 
@@ -719,13 +727,10 @@ unsigned long native_calibrate_tsc(void)
 		return 0;
 
 	/*
-	 * For Atom SoCs TSC is the only reliable clocksource.  Similarly, in a
-	 * VM, any watchdog is going to be less reliable than the TSC as the
-	 * watchdog source will be emulated in software.  In both cases, mark
-	 * the TSC reliable so that no watchdog runs on it.
+	 * For Atom SoCs TSC is the only reliable clocksource.
+	 * Mark TSC reliable so no watchdog on it.
 	 */
-	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) ||
-	    boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
+	if (boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 
 #ifdef CONFIG_X86_LOCAL_APIC

Regards
Nikunj

