Return-Path: <kvm+bounces-59560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D539EBC08B7
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 09:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA8153BF8A4
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 07:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40CE2571CD;
	Tue,  7 Oct 2025 07:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="enlAKYhl"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012009.outbound.protection.outlook.com [52.101.53.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550EF3B7A8;
	Tue,  7 Oct 2025 07:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759823978; cv=fail; b=mRNx15/SziVwuQcZ6uXlbJe/djEu6SYRuqjihdJSz7JoOout4W8qeB8u5MXHk9kQ3z543Pwr/lzTWNc/0JbTdaGGs+F2yK0RmbwSQZi93iQDbybzPOPHw42f0IQ83kEPIt0Ghv0mu7GC6rQbJukfdS0FlOk6HLdv7ZiXhVhvaoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759823978; c=relaxed/simple;
	bh=bTNwD9nF0cK7FDqMugQ2HC6DKEyKJCKVjETpLESOfdA=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QXu02lD6aqVBxbUE0oanRy0ppeOziBBgH2gXYHQXA9hXKiYIRtOKBm7Lob9QGfNKZIGHWJqdASh7X7Lofftuyo7UoMRzGYiW4yv9mdVKsXvuD7h5fNyVxwj9MVfH6SeRmhOxGpZtpxVAfG1pmudezx0djQWktYtUmr0LIjfzYzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=enlAKYhl; arc=fail smtp.client-ip=52.101.53.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiyUT/nNLXV+GmnMf5P7E0wO1GEwcdT5fXMC7jCq6JgBoayyTw9jnpAZzXOxTx00tebQLfDWeACTvLXCnL2TPI7aZTjOPxCIODx0JXgTMhk6gbYnXDW9mjrf+QadYmDy5+PDV8lBXpFVS4jFu2/hsITJJw8Ok0vwUGK/sEYZB8NNAM0YxeGz3uuK2FZmC0/9l0rCkyh/b6ZWf9Ohy+vQIQlEkJ0h89M4dvLADx+bc4t2fkOjFNH61GUHs6bmIRuLlcEGe9PCkdMS0cYcCjtU3upBDDLkdhyQOgk4R3lAbdfHbdj3DE7jmqXTWm8esRoy11RCVdr5AQyvFWr5rZnMUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKyIzbWq4QBHejvq6zxISROdAD+DbgoCnhjZrTLIMEg=;
 b=Cbx1lnvBUp2fZdzKyeLeP6y4WiOKhCol7QCfUo0KV95dU/HLBM55yLzLiUK0xcfcFuxQJZUMPY26eIjB3GmrkczB7pc6B09VWkPyu8bSLp1mxw1Dh7A+Dpn4vqxaiIHjSNaYAtYgKpSfP/XcnACpiFwx5GZIlmdYVOYnda/khLnwmHPmN+kcbYeJyezGKDcMs1UP99dSWViDeKlERAlouUukPgozrsAo/HpPMMcol6pgxv2QmMTOXVzv1ROpxkPOUZDlkOAPp5CIW83q+uqJCzWDcqx91RgkfqNE0A+jF4PdivjGQHlvOJZlkzJwZ9Vp87i3SvvgzPR2TuXcugwTgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKyIzbWq4QBHejvq6zxISROdAD+DbgoCnhjZrTLIMEg=;
 b=enlAKYhlmfwDfQWEgQ+DSOsV3CmRxzXmPsteYpTTF/UEFhU6vyhh3fv2lVZIo50YSBWJgP4SI/0zS+rRYPbV2Gg81OvTlBpAXUdT3CSEaQxYbmv7iEapxfoqk75Jd3FdGkh2EVUCnXiDftmFtY9SXQkSwsWt1beW+DOnGQ12Eh4=
Received: from CYZPR12CA0014.namprd12.prod.outlook.com (2603:10b6:930:8b::18)
 by BL1PR12MB5705.namprd12.prod.outlook.com (2603:10b6:208:384::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 07:59:28 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:930:8b:cafe::c) by CYZPR12CA0014.outlook.office365.com
 (2603:10b6:930:8b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Tue,
 7 Oct 2025 07:59:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9 via Frontend Transport; Tue, 7 Oct 2025 07:59:27 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 7 Oct
 2025 00:59:21 -0700
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
Subject: Re: [PATCH v2 1/2] KVM: x86: Advertise EferLmsleUnsupported to
 userspace
In-Reply-To: <20251001001529.1119031-2-jmattson@google.com>
References: <20251001001529.1119031-1-jmattson@google.com>
 <20251001001529.1119031-2-jmattson@google.com>
Date: Tue, 7 Oct 2025 07:59:14 +0000
Message-ID: <85qzvfqh0t.fsf@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|BL1PR12MB5705:EE_
X-MS-Office365-Filtering-Correlation-Id: eaeaa804-9327-4f3c-729b-08de0577703c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eCoYH2LiSa4UldhvG2UGK9YkcqJBQoqYoAZomnzqYjPJvgXFn6B5XbNlFGP1?=
 =?us-ascii?Q?qaTt/Wzqfvx8PQ36p8GABb4Bzrrl+It8zlN5mf3BbEicRzGCPxSpI/sELtQf?=
 =?us-ascii?Q?OnF4f4KBIIG5CTksL5Ju/25O0Z8tqchCTkopugAgD0AaDRRsO0i4GCRqNh5M?=
 =?us-ascii?Q?+npUSv73Ye1rICMmf5QqOu1AMimQ6tpTJ+6hJHchp39KFR7EB9tveI4aR2OW?=
 =?us-ascii?Q?BcsOT/aElxT1Ny20iLLd+pywdvHCm+C2Kqti4widn/wegZlKB80pJsZHHUZ0?=
 =?us-ascii?Q?+pkuPV0synoFJ6GLfEoYjveKkBO6GQ0OjgrKoBfe6L4swvmoNya78uQFGsKz?=
 =?us-ascii?Q?Pd60mG+IF8M8AciMnRrcwhnfDunfZTrjImHfImDugPDBAb6l/9z5cbc1bM0h?=
 =?us-ascii?Q?Nksy4iFC3GzaE0mOne1TYmXTAEx1srurKU1GmudyALcZu34ss1vY/5AJgs9V?=
 =?us-ascii?Q?kVMzX/yZLeXw5XgFeMhcHcwSRa7e2O2YIpeXzVbrgemEprsdAP4uB9It4fin?=
 =?us-ascii?Q?aShVPOlT5A2XzoHgsy4XJG2Z69L1umtsf9YE+++6xHqaHESqe7J/imn/95WX?=
 =?us-ascii?Q?FuhmMo1h8JYWuDcnJ3ObtNxmYE2U11U+WQbp2tdSIy6na33vIZZ0ymVJWCmP?=
 =?us-ascii?Q?iuJCaAAOHZDXCPyRDS0Gt+L9j256Zxc4Eb2r1g1VodFPQ1QaFC0Li7bJsxag?=
 =?us-ascii?Q?aQuWH4dkypxhLQufUxvCKnK6kAyuZi6KGTVfdWzcgWvu21yJ74/5RoTKW4hM?=
 =?us-ascii?Q?+1LVWeiuT3lzilIOUmfZ4agRwDFpZxRgAol0mOtl1089ucGDUm+v0Xf9m1eU?=
 =?us-ascii?Q?Ybx61eEx6kqMql9YLfgP0JEjcOTsTtJf9RfCzVPOBEdYVAwPxFLlyzYSAL8m?=
 =?us-ascii?Q?dSEtt7tVsGNoJTKDlQC0XrlaIdkfkQrCN0Mu5NozxjFCHxOmTnPpDWMwhZqF?=
 =?us-ascii?Q?7EsJCNAH6kevhE2vr6qnnC7qixqXj4w6j6VAsWjnlO8oLSNa0QY57fN64W0z?=
 =?us-ascii?Q?uGMRkhfJSnSWeWPE33/e2Ewo5BYLVfKG6hFps69YV6jbRCNuLjNZtsdhVjaa?=
 =?us-ascii?Q?z+WNAtwF2UzLKPJtwo7/du7Lx4StoQz6B1jZhtiNSKqGaHG6ESC3uppYpSM6?=
 =?us-ascii?Q?diiPp3FGsPdR+dpNqYgxqrxIB6Z//kk/lvPCa0ox7IEIRZPxQfQq9q7BWegh?=
 =?us-ascii?Q?yY+kTmbP+R4d/tsd07JLOJ12d2N3OwnVWSy4AnKdsgKnTHeN0Sr4rzW0wAsJ?=
 =?us-ascii?Q?XGX/TZA4TETJWzNHxIYSyfGXV0by2X89pu/BGnoydLmqgLmWrXj2iyi+/Ait?=
 =?us-ascii?Q?cpsN+POZPcriyLjTuoyH9+7YFGkBN78H9eON2r4rYXejemQAsuO3Pwq6EfKI?=
 =?us-ascii?Q?mY1o1lv2dZCFkUZL+ZpkQne5obkfxz62NQ4eav6k/MALvDl9cXLaqKEB+KhB?=
 =?us-ascii?Q?53akN1aP+oVOU7JE+SGTyK1cH74eCjIWanO95Iejzz/4k0jHwpcJbtG3crfO?=
 =?us-ascii?Q?UuOeoWflCyscDXjbIFkPKHV17gr/7qn5bmoGtTl2KoqZOAUlxlYwUN+KOz2r?=
 =?us-ascii?Q?ynViaM4V3UKMspyx0+9ktT/Y0OSsuEE+QSf7s7pa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 07:59:27.4574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eaeaa804-9327-4f3c-729b-08de0577703c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5705

Jim Mattson <jmattson@google.com> writes:

> CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
> bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
> set, EFER.LMLSE is unsupported. KVM has never supported EFER.LMSLE, so
> it cannot support a 0-setting of this bit.
>
> Pass through the bit in KVM_GET_SUPPORTED_CPUID to advertise the
> unavailability of EFER.LMSLE to userspace.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>

> ---
>  v1 -> v2:
>    Pass through the bit from hardware, rather than forcing it to be set.
>
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/cpuid.c               | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 751ca35386b0..f9b593721917 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -338,6 +338,7 @@
>  #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
>  #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
>  #define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation same mode protection*/
> +#define X86_FEATURE_EFER_LMSLE_MBZ	(13*32+20) /* EFER.LMSLE must be zero */
>  #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
>  #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
>  #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e2836a255b16..4823970611fd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1096,6 +1096,7 @@ void kvm_set_cpu_caps(void)
>  		F(AMD_STIBP),
>  		F(AMD_STIBP_ALWAYS_ON),
>  		F(AMD_IBRS_SAME_MODE),
> +		F(EFER_LMSLE_MBZ),
>  		F(AMD_PSFD),
>  		F(AMD_IBPB_RET),
>  	);
> -- 
> 2.51.0.618.g983fd99d29-goog

