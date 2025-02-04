Return-Path: <kvm+bounces-37210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88DD2A26D44
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 09:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C7707A3F5C
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 08:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D42206F14;
	Tue,  4 Feb 2025 08:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KVIBnG9/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F68F2063CB;
	Tue,  4 Feb 2025 08:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738657643; cv=fail; b=hv88rUXTJB2drlAHlZx1Kape7/bLTc/9TqYt5lEN7Ikn/EWjXD2ILvKQmKcp2JYdN75wnt+3/tUdBcT19bQ8TdPVyK/yMJsJPDhzlMoozTpAsNGiCmTS6Q8KH7P3fb2GIP/1HLq8B1lB8vo/xOlCJ/+czpSJL2tDzfH7+pbUh5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738657643; c=relaxed/simple;
	bh=Esk7YLIdIMg+yC/wjdAqqnzMchrPrU3/ebOW5IVgcHk=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WtDLNEqQvn7Hv0vF5iVjC2fz5OMHFwNGVH6+ToXi6Ww0VwnlBwJR3LleNsprQMj2yQX9BEYyWNu3EstBaq+Q0HulIyFhLqQsCSH82Ipm4XDQcZ6RBMSvO1U/YUNfkgwPFK3Jb/mTtR/usoFamncP15veZvGg0Ckv2uGe7P0ejsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KVIBnG9/; arc=fail smtp.client-ip=40.107.223.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G8QUtWGufmsKxflMLeAa7caiv/ghRg3leOKrTFzPukZ/GeC6THoCoVWx6hyH79V1xWKqnysEV18rnHSCZyiXXdNDZMScecyjmFCV3W55eeCzbqP7o9hgrw9e6d/DHA+8LQNn5bjfeQ66/0jaXW2I9w3/HkNm4aY4fFSclrfLdJpV5lYrf0ZJU/T3d1Q055yTkJ5Ig+a+D1mF8T3xzrqlslkejiIfB7XfFE6mEw3WkZlI2v4HCyoNYn87dxJuZfDWeuOvY6THRRLNayBIScVhL7birWvAk6Uak1vzbO9QnfmCZ6FqiDAZWSpfK7E+qeud9umBD6I+vg9x4q7ls2GQdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qTvRc4R7HQtNFKeYPVE6NHVmkklFcpzPun7h3HxzF8=;
 b=YZkpRzua3gSXx9oTdz7PH6ClNOOmuC0FVQeEaKqE3Ej2ZvxvF5M7OjSapWurW3LjX3EiAWNSjJnLsisatlA6X8N7IAnp0u5v77QxoHb9DcHfF2VZpEJxaGHPSq5tO6uU18XwSivgRw1Bdsm8MOOXqSKBOnw7VrNvr4vFbjCqz469U9PVoa6/F2taMc+qya7OncI/NmNEob8zJ0tfayhXUNbgyXD8LrOmDTWcjglvdGtV3cy4m4Tjhhljo50TtR3f/RQrpa9/kPbr5Lnpe10MX+GW1dOBs4olVxhJ7CqlavD7gVKwBoyIFv4Fezcg7DkmoCmrF3Lw7bPEfUr1qsOEoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qTvRc4R7HQtNFKeYPVE6NHVmkklFcpzPun7h3HxzF8=;
 b=KVIBnG9/L+UPrDXPjvnYSXRoOLTGnR16l4Vt/uTeMO+a2XjXykYNKDcMdUbsqnfBHNOHjneVkdn0KzZt5FZhIBG1lzOZsgGqBb/TTm4FBhqEW22zsMT8u8x+yKjLo4dpSjFyHm8pPxJFEEF6BSVYI4chQZD04rVsGMW4iGR8YYs=
Received: from MW4PR03CA0297.namprd03.prod.outlook.com (2603:10b6:303:b5::32)
 by SA1PR12MB5659.namprd12.prod.outlook.com (2603:10b6:806:236::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Tue, 4 Feb
 2025 08:27:19 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:303:b5:cafe::a) by MW4PR03CA0297.outlook.office365.com
 (2603:10b6:303:b5::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.20 via Frontend Transport; Tue,
 4 Feb 2025 08:27:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Tue, 4 Feb 2025 08:27:18 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 4 Feb
 2025 02:27:06 -0600
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
Subject: Re: [PATCH 05/16] x86/sev: Move check for SNP Secure TSC support to
 tsc_early_init()
In-Reply-To: <20250201021718.699411-6-seanjc@google.com>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-6-seanjc@google.com>
Date: Tue, 4 Feb 2025 08:27:04 +0000
Message-ID: <85v7tq5d47.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|SA1PR12MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: b8f94ebc-b63b-4f10-63a2-08dd44f5bd45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zCJ24BYv/wWLmJTSQQ5/44NJ1N6nC4J5gTEacAoO4zK721UaG+uG1kjsPgZ0?=
 =?us-ascii?Q?TG8nfvPUQEK10C0VXAzMynA7CzZ2nRsbtJLJ8RqVccd98s54MPu/pBDcVyDq?=
 =?us-ascii?Q?FgFPXhxU7955krhe9pmeI0DLkzvJtqyn7Kh8j+1unZzW/NRyfRkIW5BjDQZb?=
 =?us-ascii?Q?/L50Tsd452RoFsRLsA0von92p5TgyXseA3mBTQNfKI6M1bNj1FJJviuIv6pK?=
 =?us-ascii?Q?1FlIIJl3QAwiohghcKk15o5sFCo3dfyBbhH/ekQiSDILJtXyWaSUBbEuTGAE?=
 =?us-ascii?Q?fVyuuVuT+pz0VrNswsgyeaigdZxdK2vntliX0XgUXoEgx90C2f882F3DLfe0?=
 =?us-ascii?Q?az3Y/YhUJaBU3g3MrNsHUt3s4VAJIKvYksxPghAmpd+AzvHwoDdpcG1rPGra?=
 =?us-ascii?Q?4wGkrBPKZEYdIDIVnAvpc3lozU17v/656UnrgKuQU7s5z4JNGaPqufT4hG8B?=
 =?us-ascii?Q?/30f+kiSjhcVl0hqVsqMlf7C27/DXfHc4NpvyGrpyqOfJ9S/kufYi0MAtU6Z?=
 =?us-ascii?Q?danZ15wHLnzk9dcc5i01YZf+638IRbInmPSzPKNvzcd9hsBtj2cJKEk7/4pV?=
 =?us-ascii?Q?u2zjTC4vkSE5yaAGvvsXMzoLNTaLz+V7SwcqQRVkMXcDTWnRLKzBHmyVEGM0?=
 =?us-ascii?Q?IgaE1x8eO1p+fLVcEwmBgwe1YPKMyPZEkjPJZ6QxevZggVUpKe7HIDmIIwMf?=
 =?us-ascii?Q?Y+zgMvId8u4OJIgOv8w8RGK7ROYyFMrcKkkFrwm4ogShZ1y99r/v6Nf9thbQ?=
 =?us-ascii?Q?V7jr2Ql/ZYkxV1O2+ajGIJSw7e7mm08fU0X7VH/tirQLu/5W7a6zz8HOOx+L?=
 =?us-ascii?Q?S8+lkSpoH5Ic7rgEgqlA1nytRku/rs9DoCI/9t8xihd8EESRDcwEq92VJIVx?=
 =?us-ascii?Q?0SVwv2BO3+m1N1L6m2vLzuuWnzuYaTdIPjJ2RYduH3I75UH/WNTpQsjxjjFA?=
 =?us-ascii?Q?Ln32UpYytBMu5qX2t8cSWKx6hDTC924a95Qt/jYRmiTMQ04soDd7AHsE7hQz?=
 =?us-ascii?Q?7yOnNNuQdgn9iJEmMV3ykvrdLyQUD0ybsayPFasTbSdCcFuhCMFkCJjeXXMc?=
 =?us-ascii?Q?nNCRlcvtfTDTflEGS8EEQMjlIU3mhYR4PsTSNdZawrOuePwmMPogUJ5VcqGl?=
 =?us-ascii?Q?r8OptXQXzQPWWPDy9oQrkIk0qTVbJEBue0KbnOy/ES7WcikBgjFuSi7Y/3SV?=
 =?us-ascii?Q?7D5M/s4QFErHs5dS2wnrYLoDNtyPoa9VAQHMzANwksci4EyVqTV4WGdsf+2x?=
 =?us-ascii?Q?tcG5Ly77SAEKMnyRNEaDWigI1G3S9D42y/eiUvl748kG2zn3s3Pny9ICn7hH?=
 =?us-ascii?Q?U7SRhFXwDPgcKMvC3USTPwXSDVTKnbShE+dJFYil4GiwFh8/SY7QUeOD61U5?=
 =?us-ascii?Q?R0jfbipXdw6X2dRBdgpvYQ/iYHkvvF2pbBys30RKKAGyaNGfnVq5q5FPuUDy?=
 =?us-ascii?Q?wtNAtKAPtQPdN2Fheu9CGtrWTaElgaFgJTvg2jolaguqyGGpUwhb6qcWZMOR?=
 =?us-ascii?Q?IGlTfN4G3ANdRs2iE12dLoUlPv4uJc8iG+lB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 08:27:18.8033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f94ebc-b63b-4f10-63a2-08dd44f5bd45
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5659

Sean Christopherson <seanjc@google.com> writes:

> Move the check on having a Secure TSC to the common tsc_early_init() so
> that it's obvious that having a Secure TSC is conditional, and to prepare
> for adding TDX to the mix (blindly initializing *both* SNP and TDX TSC
> logic looks especially weird).

Agree.

>
> No functional change intended.
>
> Cc: Nikunj A Dadhania <nikunj@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/coco/sev/core.c | 3 ---
>  arch/x86/kernel/tsc.c    | 3 ++-
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index e6ce4ca72465..dab386f782ce 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3284,9 +3284,6 @@ void __init snp_secure_tsc_init(void)
>  {
>  	unsigned long long tsc_freq_mhz;
>  
> -	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> -		return;
> -
>  	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>  	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
>  
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 5a16271b7a5c..09ca0cbd4f31 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -1514,7 +1514,8 @@ void __init tsc_early_init(void)
>  	if (is_early_uv_system())
>  		return;
>  
> -	snp_secure_tsc_init();
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		snp_secure_tsc_init();
>  
>  	if (!determine_cpu_tsc_frequencies(true))
>  		return;
> -- 
> 2.48.1.362.g079036d154-goog

