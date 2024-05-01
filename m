Return-Path: <kvm+bounces-16321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFB78B8746
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F7A21F22A93
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E453F51C34;
	Wed,  1 May 2024 09:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2aDYeyq8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8C44E1A2;
	Wed,  1 May 2024 09:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554464; cv=fail; b=rCRKfNIYJw0uR6ruY/EDnb/Fc5ZFn95hVmahBIfsy4gHjbsJ0M6FZgFseuy4gkkgudfuIkGSuFEryFtXgtrFhNf/rkTNKGMnuMhC51v1X2tGdPV/Anha3tqk5uBQCCRjkX3fisMNMIaQDl+MTwHbeADVZVsgQM1dz0GCZIOqzz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554464; c=relaxed/simple;
	bh=FJCMQvRyfp5Z1IhuXUvGBSE2rK2rAfv2nhEopFQTfmA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6or9r96i3V1wfOeIAQJk9nBBKX2pL1HfrvelHg1aGsQpcbMVfGyXGA3BFwkaeW6lLCJAmFiIvSBxftVh7vMuiQ2NUuFjztSrrmEaC7lIom90lIwddI02m2mBllYO2lyUMrugSbPmAvOoKh/r5QceQXGy6xZ5glKqP6gwzInnbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2aDYeyq8; arc=fail smtp.client-ip=40.107.237.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrfnL/4mjbd9/o6FyIQYIt59G6MEDH//FXRWi/ebt0WLlKQyXkweaGi/OgcYb1JdAtcf7/JtbZyjYYCJ2A5aqCA1DAg0Don5suQ4N7VWdFJH5H2PI51rh8e87FMwNOYNX4RwehNt8cco7B+rVjnV0hzLFLCJG63aexodig7MRmEMIf0oZlCI6mEZce/TspMgdZ6o48VDHHqFJOvpNpXtoUF3iO05C/4SFQzaN98O6tCEfetWa9ThaNpc1b0KJHQCJy/fg1fPN5pp7qZ5CiAeYSpoUzitmWeFWr588cqYUiP9WFZPK52gM4n5NH/rd3HBtAWsC3zRtK/6KrFUkKWjnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXRnpadbMHv81jR+cczjNT88FJu0zOLgWChtKNLc+po=;
 b=hDytNGQBKQLpX74Yx0NqUpPby0ciIfrKqJMPKLwPIYmv03TuStafmc9pzid9NkkNDtyV+CjeFGolVQe6qUlo0SQ9il1yj4zZJ7+5IMRU5ZQHcVbJcR015vTuxUnEMg2aZQS+TYMPsBv+k7YdaBs6xI1Qzm9V04swBKJ+bpG3QQ3zlNm1VQeg80eQwm/9P/LdHM5X5ljR/89DDhWgczGXACwldYVyiO9MTTSzEiFh/5PMYwMxWYMsGzgq+gTGhmH4RCK243LU84aBRFyjNUX07uxBG5Z7AZn0n39s43beoy31LZ3IYSiSX0iPOh2ZxjEZkUj1/QloEnSpM9rSwJdcDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXRnpadbMHv81jR+cczjNT88FJu0zOLgWChtKNLc+po=;
 b=2aDYeyq8y+2NRsrSvzgw7WwhHSbXZVJxrpwTiasorZgmr6XGN5P8I/PDiS6t2JBE/YpTcNVdlH0v4g8xganb23UKDSi7g/XXxzE5joVGeeCWR6pagZschyAEpQRHzdxIH6Fwz/0hRmls7oIjz5i+NdMUoUA1sdFLghTjNZTDDfw=
Received: from BN8PR12CA0003.namprd12.prod.outlook.com (2603:10b6:408:60::16)
 by CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 09:07:38 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:60:cafe::30) by BN8PR12CA0003.outlook.office365.com
 (2603:10b6:408:60::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.27 via Frontend
 Transport; Wed, 1 May 2024 09:07:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:07:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:07:37 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v15 03/20] KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
Date: Wed, 1 May 2024 03:51:53 -0500
Message-ID: <20240501085210.2213060-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 18d077b5-226f-4716-be0a-08dc69be261b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|82310400014|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j0k5CPwcjjPjbOfcDghqoJIAlYyvZpwET3TvhL0PR2BdbAe2fSYfY3j1CKM9?=
 =?us-ascii?Q?aLZ33xbyMVuA2XdsECLQU18FJaRBNVnU+5GkoWyqj5VCsmhYrOfzbes6y6I/?=
 =?us-ascii?Q?7dixQ5dnGu3p1Z7zeYl3zJCPK7eZS/DtOmxImfkz9NaFyazU5aEemlQNIq6E?=
 =?us-ascii?Q?Fol1UhZsMwuCQvObYZr+LVgJIMks5MfSbK9/KmC81mkZRIMy8jj0OCing6PF?=
 =?us-ascii?Q?X80Vd11gKhxEwAkb4QqfvaLQ2ou5jyMXy4lyKtnXFOmb+B8oZPpuXim0HbfG?=
 =?us-ascii?Q?CSWAA+Aq4Xx35vL7fW8Pa1SMRkvNVLsKNlEHv03eB0fjRizztSYT+m0Q2PCk?=
 =?us-ascii?Q?y/0v6suVGWaZa904JKdSgMpISD0Brw204qBsD/a3B0HLzF+ExX0qJTYvkcwW?=
 =?us-ascii?Q?CWVBaE/npterivJzlsJhQjkdUql53iUzgazgnAeQec//a48Z6GzFJbncDwPa?=
 =?us-ascii?Q?C7GL4hisGH4bY+CKVb/2sljXD/Cmgur8cZ/O8x/Xvf277IZ2VCjxKZ1krkLj?=
 =?us-ascii?Q?P102oioiovg87x28YzONG5NRi7LM5zLNFh+v6mywfP1jaYPP45EyFG711l4/?=
 =?us-ascii?Q?pnOCehk7MHbmT+FOOO3jygM7A6BN85cXAwOGA/QfXoHMFSsPGC9b13Aw9LyP?=
 =?us-ascii?Q?z5WPEQQd5Fg/3BV0LTTsamOqsdyIy3mdDjGmQ3ZPpPdDNk3AyjjGf95Ym68Q?=
 =?us-ascii?Q?7kqCp/AavYObhGMKLZrzdR0MjJoyH5GuBS2L4P0k0Fpqkd20uzt5qLbOMhL7?=
 =?us-ascii?Q?m4MOEXx3ffSxHlpJwCLaC5l/+zvnhXm01Dpf9eVJ4eUtyZZ7I//3U2K0KEgg?=
 =?us-ascii?Q?JL2dZ1/JtBIH976xhjUl4Z7F0awzdLGBBHed7sD66JTyV97o/sRsCZqhDgz0?=
 =?us-ascii?Q?dyR4fE60Lg/moAszGelkFEnys8XeQC1DD7/BxDzBsCpusYl+VyQGcRBhq12S?=
 =?us-ascii?Q?L4VUc//wfaBAjpSnTl45cPWarHkG//GGLn8K0u4IK2GCf4AqlPBo65BeuiPT?=
 =?us-ascii?Q?dZrjoTv16P0qmFCbq0YkW3gQ30H+RarF5HiMQIsTKDGXGkLf0CJXEw1mM8j6?=
 =?us-ascii?Q?1PD4/zvbEywHXha3tbyoYvXD2J2Gg+9yz9z0ST97oJ4hsfP/Ej9OOPG9cAsa?=
 =?us-ascii?Q?eIsjBVh2TekM6k98y58smQ873MiBpgb1wgE1f86yunCwXk6SmaRvYt3RohCf?=
 =?us-ascii?Q?AkOqAOhPs+0Cuwbn/fFw/9sgl/YkgZSSw2N+epke3rIT29+IK3pSQEBU3gu6?=
 =?us-ascii?Q?Xf8ZpeEX0AHicAwUIb0pFZna5PELQB7kyCE6zrFuSLNBbXoGPBg2F6mA3te8?=
 =?us-ascii?Q?d03Qk5ttrj4SHBUppJFo12lO7cF0CRX6YXYxxKGzjVLSMg7pPstyP9h/I1ho?=
 =?us-ascii?Q?nuuyUI/b1gRN/vkfxK8mGqFk9wHN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:07:38.3197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d077b5-226f-4716-be0a-08dc69be261b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431

SEV-SNP relies on private memory support to run guests, so make sure to
enable that support via the CONFIG_KVM_GENERIC_PRIVATE_MEM config
option.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d64fb2b3eb69..5e72faca4e8f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -136,6 +136,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1


