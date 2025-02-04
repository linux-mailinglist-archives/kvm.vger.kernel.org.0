Return-Path: <kvm+bounces-37209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A70F3A26CF8
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 09:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2805D7A2934
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 08:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 597AB2066DE;
	Tue,  4 Feb 2025 08:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PLXGeL2I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D231718D620;
	Tue,  4 Feb 2025 08:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738656161; cv=fail; b=gesSa9gfR/8XEeX+vXPYUYFIvCfV61nRvcbM6slVCQFMjlIYeOY7llI75hm19YNyRitHyuSbpSiTi0keEGzQhmhZzP2TT/rdFoZKMZ69OP9TyVvnxBSUElXMn20JC/1xAIIR3OvWu0DpIUTiN5xctK0EQXkrpgaqbf1VD+iHbOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738656161; c=relaxed/simple;
	bh=Nff9UR2ox+SdrtrK/zbHIxzm4ooikfcu6cD2a21kHLA=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Zektoct+BRR9y485YepafygquoH+44Fd2uSZFRgsK8YwJuTDlNFCDwqTuO6zzVovL5uXjxE56iuM/G4xIwjmOcVRax2pxdmklGeK+URLOfLUCw5yp0/e/B8zu+7ofoY+x3jhLgN3afz8EDmex+dNM7Y9PA3McB7F7TbZqUiOEA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PLXGeL2I; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+BdEoAJQzHAW9sy8GECaCnqQPiOkYqdKDlIJf0IQ5yUjxMbtSLgNaOnJn0gMeU5qrCEtP67SUwJpcVpxz0n8auaBQNO/x8/dp459wiWcWNM4T2yugRh7NM1QCz2HwWR96V8CIycsMvLMgQ5YLX9iihbJ1YdDP9hz0Lj4rP/uiPwi2NyVyDxilGCBzoIe71aQYqxUOFa7e4JPnSOEPjKS+QQByVJWk9mEMCxzWS41lqq3XFgZCSllHdPZKibRIqCzlPPe8pNwGpF+EBK/ErOM86wqZ2Hv0BOi8STO4doTneZa673b+L7wijBTvTslCOQ8yjEPqxDXBf77TReWLbu7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2D5lXZBHVFDsmXl9n1XG3euKCn85ZJhr7IO1WYED/lI=;
 b=qRNUVPJGASCxwj8UfSPHXj8iVGSoNCSc7/vKsBwrO1Ubx8ZKUye2K/EJH/5x7Ob3YUNkAQ8H1ZpLfBD30HjN/83K8SRuVlsrfmG2mS9aZkcWv4umc+jPwao2No3iSWxBdWecex7s4qBOL3PNJRzrDIu01QRjX2jC+9L3LKkzDTdNu9M9Yc9J5kqpDybuFQBLTRqZ1O+RkvwNWZMaOgWartSk8MCHpygY6ohE6kI88Xz3LSAxDYUVtzOsniWykijYCB++6ksg5czKHVZfvski0bbbGWB+AUPuKzz/r+GJBwaOMOJd0fXZXurNDyb8YnCLkoHgN8zPaFVn+a+yZJTj4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2D5lXZBHVFDsmXl9n1XG3euKCn85ZJhr7IO1WYED/lI=;
 b=PLXGeL2Irl0ZgtABfiVo0n3CvYitfV5YS00d2ayWEzxgjazpKxxjQDqOZlAbGRdNhGJRXGlEY+Gby5qAK/Djnz1KHeoPqE19yGwZwmO8GO4f840SK9erFXl/YYbLHR8/t0tNS99Sl9hOIlMLRj4C2gCBAExSERsmDTSaSkB9WxQ=
Received: from BN9PR03CA0395.namprd03.prod.outlook.com (2603:10b6:408:111::10)
 by SA1PR12MB8859.namprd12.prod.outlook.com (2603:10b6:806:37c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 08:02:37 +0000
Received: from BN3PEPF0000B373.namprd21.prod.outlook.com
 (2603:10b6:408:111:cafe::7) by BN9PR03CA0395.outlook.office365.com
 (2603:10b6:408:111::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Tue,
 4 Feb 2025 08:02:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B373.mail.protection.outlook.com (10.167.243.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.2 via Frontend Transport; Tue, 4 Feb 2025 08:02:37 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 4 Feb
 2025 02:02:29 -0600
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
Subject: Re: [PATCH 04/16] x86/sev: Mark TSC as reliable when configuring
 Secure TSC
In-Reply-To: <20250201021718.699411-5-seanjc@google.com>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-5-seanjc@google.com>
Date: Tue, 4 Feb 2025 08:02:21 +0000
Message-ID: <85y0ym5e9e.fsf@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B373:EE_|SA1PR12MB8859:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bcca8b8-250b-4212-1e7d-08dd44f24a06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nkNqDxv8OLfDQJg18fuIzIAYPP9di320vzrI1S8kGYGmlj3HNyIip+41Bck3?=
 =?us-ascii?Q?Sg3M7kMfxi6mnnIBLYVmhcAQqmC+Vz93sN+U/QHjS6F8CuMyBTnWWtUe/VOz?=
 =?us-ascii?Q?UBqaOR9UJNwxYdQs9ZAOycKnqhezERjLZ4Lcv7/UO58tSnoXTsXnovyifg2S?=
 =?us-ascii?Q?x5oAV5pj0nm1vnT1VB6Qj4Alg9qU4irLHKkETvAvadrf6TEnAnUeRwWPc/sC?=
 =?us-ascii?Q?erkscjM7K4RrUiq6vpeacVt7efhR7pO429B+2Sdd6sUp8b7tZH2smv6vxn9W?=
 =?us-ascii?Q?dxwVCUvhbJP37zlRSs/a1a2nX4i8/qFDfcUrvFqFBo5QZzxUi3v1Y1lfvsXk?=
 =?us-ascii?Q?UQgg9e3HToGuscu/flsde3i/t+6lquWpOKfOzXQ5MxJqaZCnj/3xbsMM3kLq?=
 =?us-ascii?Q?annQKHRTc/4eOsEPZjEVz2bVg5EjwHaaTG4cgcbMPnwcFqKsVSiG855pM8or?=
 =?us-ascii?Q?4n+B4Epcks9KGzNM9JqrxkFZmo9Y81qM4y8NBiaZajeFNGb4toShl0UfLG3y?=
 =?us-ascii?Q?hyND63pB+JaGtpMNTf+bCApCTD017mua86MHzll1ybGxf2tTF7xz23moceH7?=
 =?us-ascii?Q?mLn11b1IiTd0vcBkMiJ6b2Kw9j112BefpjnqUbLTKjcekmWcY2YuN0lvvTND?=
 =?us-ascii?Q?7T8fDzYSu4hhIKDaYXhKDLm6ZbeFSVk54hXoni5LopBXmbjX/ZSDHRpVuVFb?=
 =?us-ascii?Q?xFbHg6s0UDzgTJAyQOFGsWE4wsR+0m5hds5uSzrKNsMpoqBDPZxXcgu/Y3ZV?=
 =?us-ascii?Q?TA3JukeN1OtsbHGZ5wx66QZ4cp5xkUkwwuM4YxbW2U70FvbdqCORxBaRzxe9?=
 =?us-ascii?Q?iLkhWM9YMU6kvGEbK6R11OUfVjMhamhRSjU9mGk3PGWhFV3wvdxT0QEhtCNJ?=
 =?us-ascii?Q?Cj91CNl6xk9oCSnxZ8oIfuQhTPddrEyzVfZ+klppxhihNOt9OeRZ1UpurQja?=
 =?us-ascii?Q?25CuyTXZtXw/rM9rDiTkjyTCuqpvOYFB/3xg4RpjOA8dXbn7XEwEHPdr10fF?=
 =?us-ascii?Q?c1bIvwNPucn4Q8uw/Z/xjv6cyAu/QK1gGw/P/g82YcFCz9N8JJYKdt2LrR9I?=
 =?us-ascii?Q?lSviZMZWjKHXmK4Mp9hmEGwEGqmzBpyiOXfG9cCBgqfT+naK+WrRc45kjY3v?=
 =?us-ascii?Q?IPSdUQWh70Iggg7PMHvizUw95KWWE/k1Y2v1nbCdHEJGj8WUPFkklc4KNQuL?=
 =?us-ascii?Q?TWvTGtzsbeQwCLfrAdefojRL4LmSRbo3emqzcc+H4URaWSazdAQMjC0wnWzZ?=
 =?us-ascii?Q?ju35P+9nJ7Ns0LxQH9HO8LArcdVfro6NibZ138k4eL/AA+Xum1/JXsmsl0HY?=
 =?us-ascii?Q?qE2oFrGJ4eQVIQnqQwDphBeOGbNKi8sJ1MzprIGSZ2N9m50fe7dMpiKqIkxb?=
 =?us-ascii?Q?ESBObshPIrK4leKmmSmlPIlC8ZRU3yu1bUkfBaSv+CJW9T2kOxupLHncZFvp?=
 =?us-ascii?Q?zNVq6sVaBWg1z+1z8XohFcjfFOncqzDcwQNmIqWrUL4+TR4W6gyuw596UWWi?=
 =?us-ascii?Q?IDqwuC1Q02kDp4ax71KkH2E3Sc+0yv1WpMIy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 08:02:37.0386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcca8b8-250b-4212-1e7d-08dd44f24a06
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B373.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8859

Sean Christopherson <seanjc@google.com> writes:

> Move the code to mark the TSC as reliable from sme_early_init() to
> snp_secure_tsc_init().  The only reader of TSC_RELIABLE is the aptly
> named check_system_tsc_reliable(), which runs in tsc_init(), i.e.
> after snp_secure_tsc_init().
>
> This will allow consolidating the handling of TSC_KNOWN_FREQ and
> TSC_RELIABLE when overriding the TSC calibration routine.
>
> Cc: Nikunj A Dadhania <nikunj@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/coco/sev/core.c      | 2 ++
>  arch/x86/mm/mem_encrypt_amd.c | 3 ---
>  2 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 684cef70edc1..e6ce4ca72465 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3288,6 +3288,8 @@ void __init snp_secure_tsc_init(void)
>  		return;
>  
>  	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> +
>  	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
>  	snp_tsc_freq_khz = (unsigned long)(tsc_freq_mhz * 1000);
>  
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> index b56c5c073003..774f9677458f 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -541,9 +541,6 @@ void __init sme_early_init(void)
>  	 * kernel mapped.
>  	 */
>  	snp_update_svsm_ca();
> -
> -	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> -		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
>  }
>  
>  void __init mem_encrypt_free_decrypted_mem(void)
> -- 
> 2.48.1.362.g079036d154-goog

