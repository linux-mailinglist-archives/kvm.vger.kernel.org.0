Return-Path: <kvm+bounces-59561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 84308BC08C1
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 10:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0C12C4F371E
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 08:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8603825392C;
	Tue,  7 Oct 2025 08:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3nrZV/vF"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFBE19E99F;
	Tue,  7 Oct 2025 08:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759824162; cv=fail; b=OO4GtO6ysoxSnhO47kJPx1gQEkFtYTbptSdS1+53BdPnF7klmZrfCrETTMFwYV0gbu2ZPzemGha2keeitAjmOSxeQeI5EQzbcrwoicgBCnd7+Yrq5pe+TLGkbVxA4WYcMguA2H36nQS8fSZn0tEtidQLv5cKjaErAYR+w03nOc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759824162; c=relaxed/simple;
	bh=XrubsYwmu98mFNMwuzRTJ1tPf3Fbp5ZkdAQ2XanNKIc=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fj99G7cvBMWq7XwNHtFpEoBbtvOdcmsTwQ7JZseW/D8ZsOzk1d2F78Ra+ZnPLTV5VpvMCxMY4dufwraAU1GASEhM/EXJc0QM5RkATqECjSYkGOMoJzCeq6vboS535hfBkEQtY84116P/7R3ep3GjWFmt3tmVIJIIgMrL5DVNqaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3nrZV/vF; arc=fail smtp.client-ip=52.101.48.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIibPEoDcdZ89l3aRuRF+TOt03RV0fIYKHZ5l2Q0vvT3PclMl41rICqTxJGQysh7qDBavVGu7knYFbIFnj4bQSVZ66LQUOAszNACmUVg++Iq5612Z2PVwKrCRo8wp3R4I8oz/BzmOMxDbKPomNgoNPcfuwtHiFnqzx6C3pd0rLhfs63tkWbchECEGELXuO6hz5erSRU7j7z7P5DCpQanThYbGx670MyqOpYexECZ3CpcS4w9V7s1NeEXPMylRRN5jDlot98Bd0cSZhb4Laq0PhQrU97KMFa2tKXScp9xd6bdVsPAeuemWM1wf7Pmcw2IpbfbK0NqgVFctgTg3BT5dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cga0AsIFReHJHgtit/Y/Taf+uVAR3BmXREL1JgJnoOs=;
 b=hRR95OdjkSoHL6YZ6m9tNRkWIRBAPhmIJRQQanIBv/x3KvaYHHAGRCJVqmtuue5YBIKtuJy4qP/Fdk+Bai5uGZcGPDlmFLBPz0vPm6yXwHS5Zw7S8WjmA109jNlcJQWAl1nYlRzLahf4blveaWP6G0i8kx36poioeekWIhNLLpHulbOIwof0qgRKMUQRB7abkX3Jhj+wEguxMmqLOG3KLK4QDBoHy04E8JwAG7+l7a5rvE7zqVi7gC/+WLPXxSSw8rgcD7hYGWyM4AO2vWtbAexoTA+OnNvwyzfkwhsPTcZy4+y3ZpOMV1/TeV9p9/sQM8ctyRO18CXXJ4nh7vOpqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cga0AsIFReHJHgtit/Y/Taf+uVAR3BmXREL1JgJnoOs=;
 b=3nrZV/vFKM3yBHtXqUX74yKRI3cOXe1/jBsuNa2TEg2B724GMPLWEAZ+xYAwxggjkS9uXCV1UYofQDT4ZHAZSWqwA2jww67M+WkHucEDNT7LJ/6f5bCVXGbji7e3QHOHoeeEjY95XkLOG/kLORs40AhXQQj5rPC5J0yeR8fg63o=
Received: from BN9PR03CA0487.namprd03.prod.outlook.com (2603:10b6:408:130::12)
 by PH7PR12MB6785.namprd12.prod.outlook.com (2603:10b6:510:1ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 08:02:34 +0000
Received: from MN1PEPF0000ECD9.namprd02.prod.outlook.com
 (2603:10b6:408:130:cafe::b) by BN9PR03CA0487.outlook.office365.com
 (2603:10b6:408:130::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Tue,
 7 Oct 2025 08:02:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000ECD9.mail.protection.outlook.com (10.167.242.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9 via Frontend Transport; Tue, 7 Oct 2025 08:02:34 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 7 Oct
 2025 01:02:28 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Jim Mattson <jmattson@google.com>,
	"Perry Yuan" <perry.yuan@amd.com>, Sohil Mehta <sohil.mehta@intel.com>, "Xin
 Li (Intel)" <xin@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity
	<avi@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Disallow EFER.LMSLE when not supported
 by hardware
In-Reply-To: <20251001001529.1119031-3-jmattson@google.com>
References: <20251001001529.1119031-1-jmattson@google.com>
 <20251001001529.1119031-3-jmattson@google.com>
Date: Tue, 7 Oct 2025 08:02:26 +0000
Message-ID: <85o6qjqgvh.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD9:EE_|PH7PR12MB6785:EE_
X-MS-Office365-Filtering-Correlation-Id: b8c94bee-7af4-472b-e453-08de0577dfa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T18m69/KuvZxSuFYvsBBAnBdhso6R+8tWgc/OdbXgHMonNVcokzqyB1C7146?=
 =?us-ascii?Q?jcrrh+kEQ+8H/KkFuoRkSJtCtB4t6mWO2mWLP22tdBsIfQO9b4/mMB1sKgkh?=
 =?us-ascii?Q?P/Z0rvksqL4Wmg0tlGDMKD8i4tpp/cO4oSw9X/9kyLvP5Zvf1Oj73EiuvUR7?=
 =?us-ascii?Q?Wu3cTp6yNxI/rJekRODLTPtMinyD3kCoVKB2MvAzWmvoeP+BkSLPtHKf8nVf?=
 =?us-ascii?Q?ODE0Rpk4cW6sp1MiTI0UamZZTLnGjk5R+oyPTD/ZjLQeXRtQfWnn/DMlSNyg?=
 =?us-ascii?Q?QNRUyNmj3fykUN1pC/cUhPtU4DMOC7OvbCvoFhJX/tSXFE5LgwnvB0jL8o5B?=
 =?us-ascii?Q?uUtwcrHcpE6SbSjK4dOmMmNvQb54/wx21FWpIP8YWWi9g4C4Ewy2ufJCH+Qz?=
 =?us-ascii?Q?qhk/8ecDQqUZ9vqECAYi87/DAxBN+Rj1mhU2QZcAGlKseZUTd2drE1xYFy3l?=
 =?us-ascii?Q?3tFVcrRgGk5/QO9UZ9qLUCUaunaOl8L634z4pO5OevOj7tsBrEK7V75q9FNt?=
 =?us-ascii?Q?4FqoULQYh+hjThmJBPuUp1jqC8R4lBqNvxuRPJQ0Siri6pWu32dL2n5iHSQ/?=
 =?us-ascii?Q?ygtKu+YZvVhzpTfrM85g/L+u+r4bfXlkkKxFGlCA6bg2b8QSs5eeTBBDlHCT?=
 =?us-ascii?Q?p3JDiwEiESun/izUBE7RPeHTlxks5hk5SKYgv456PYafEDzTxjf/hLBb89pe?=
 =?us-ascii?Q?Uy1EqhQu6z5F57flArEbObr1kjPRbhBF4qJIEqxaGjCI3FZo8nqStjxPp/md?=
 =?us-ascii?Q?fRAJzHsLnH+DGuj07GLFKjTEblpM63ydVkWuxPHpYiRQbhJjkRCDQ5IMXDk6?=
 =?us-ascii?Q?zwcibXmEGS0nPe6aRX8DtZvV+zrSC2/dxsUtW1eFTqFqigAEcXLNvnICh4zy?=
 =?us-ascii?Q?reRdA3pL+aXwwMWzsd3Te66lboJH7PTCoY8KBluF2cShQBHB12TxI2XSXK8b?=
 =?us-ascii?Q?wovkFni3TNmy63GhmygbDRaRBGeOYtc9xKFZOoxWG3F//kEtP75XlR84dKgh?=
 =?us-ascii?Q?9DDztnL6bu2c0wPzB0LbQIGeXwEKaW5ikuNl388l5j+4bM+4M5Qcb6iynJxz?=
 =?us-ascii?Q?A9AxhpTR46wtBpQTqIgYyYWbRstFpdpQZH503Ju8PRuHnvVDwh2NSuDV6DrY?=
 =?us-ascii?Q?iBQgkFhOQcUtAupgBXxEaO2ege/5a0PsbbCkm3+dksMNAw7xA0yruPLjssSN?=
 =?us-ascii?Q?EBi8kGWzyX6q8JM48Ksy42o6XnpVzAVKsg6/E8mZewYuTuFZWwiSUmtCDhsl?=
 =?us-ascii?Q?VXYDhqWEXOUkK1XSFgtwgSgjZmEYhUcQiWnBXk86vC6FkBnZrLw1gwwlB3ay?=
 =?us-ascii?Q?G+1YZQoVpYdowAoUSZXktzUlwhNCpLOoEdAOp7EqStbtb79jS/7Q30QL/0ed?=
 =?us-ascii?Q?VPpKNEyVQJIT0kmprme7gjIrdXXE8YUJ2QR/hy0vR/yYrwJ05UyS0FDF7EO9?=
 =?us-ascii?Q?ulU3QT9WF+RgIqbOV01EGuK/dfXDV7QijYGpTAK92oQPHlKZzgr0tSKwqEh1?=
 =?us-ascii?Q?QSZLHTBOYD0zzSE8GM2mfkgKLB3wkiU7X1mloPNX7oI/gJXuLzuC/5vPwt4R?=
 =?us-ascii?Q?16QHn9irYgwOYA488oovUfe0m83AaX17wEbVFjwQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 08:02:34.4454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c94bee-7af4-472b-e453-08de0577dfa9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6785

Jim Mattson <jmattson@google.com> writes:

> Modern AMD CPUs do not support segment limit checks in 64-bit mode
> (i.e. EFER.LMSLE must be zero). Do not allow a guest to set EFER.LMSLE
> on a CPU that requires the bit to be zero.
>
> For backwards compatibility, allow EFER.LMSLE to be set on CPUs that
> support segment limit checks in 64-bit mode, even though KVM's
> implementation of the feature is incomplete (e.g. KVM's emulator does
> not enforce segment limits in 64-bit mode).
>
> Fixes: eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with nested svm")
>
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  arch/x86/kvm/svm/svm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1bfebe40854f..78d0fc85d0bd 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5351,7 +5351,9 @@ static __init int svm_hardware_setup(void)
>  
>  	if (nested) {
>  		pr_info("Nested Virtualization enabled\n");
> -		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
> +		kvm_enable_efer_bits(EFER_SVME);
> +		if (!boot_cpu_has(X86_FEATURE_EFER_LMSLE_MBZ))
> +			kvm_enable_efer_bits(EFER_LMSLE);
>  
>  		r = nested_svm_init_msrpm_merge_offsets();
>  		if (r)
> -- 
> 2.51.0.618.g983fd99d29-goog

