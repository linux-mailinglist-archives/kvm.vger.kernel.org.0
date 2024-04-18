Return-Path: <kvm+bounces-15151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C703F8AA34F
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AB24B2767F
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B38D194C8C;
	Thu, 18 Apr 2024 19:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CkskRf0L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485A6180A79;
	Thu, 18 Apr 2024 19:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469610; cv=fail; b=bRXQzGay++clMsvz6GTvBgwMp5unfEykUoeq8G/wjWb06ctg0s45Ru2uu0t8iLX7aBbjKJU3Er/ORLUNvSDWIRqZYU+w1ywA3cTBXOFPgv9eRqTkn89UM0sMJ3O+C8gC95+VVxD8xz/PkTT73iBTwDXOu3kFpUc5Nu5suNfEdi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469610; c=relaxed/simple;
	bh=PP1YMKnmfsyimPkc5yU3oGVQNrCDsOVslUSpGBLjLbo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HoXIksLXyE2fKVslnxhXe/cNaHX7Qr7UVKekZKG4w5M5waaDdnXyAddtp5Yx8Vm9LPQG/KrINRk3MMknoYlQrLZr1uN5wf5WFw/Iy83uPfdQLOe+9O004hmRWKOJNe9t1QUfw1ExhMevmf5eOckLf6wwx/jJ7wkX0/PcbaFsxxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CkskRf0L; arc=fail smtp.client-ip=40.107.100.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ny5zjjtY+BlBPQcZHJT98LgiM87zVwDPVkSnvrEFwKrtQ5Br5Mv2OdoE6XzIEknZ6gtyvlZdNDaUrNLb0JE73gIdRil1ne6fZyTmJPsqCns0IfBTR9TObpGWaHru9d6SIJ+9dJuk2i5l13KM9wy4lXIZQsx2w1gY8RqxDmkBcRZTxEEFFw6X88qc3GEmWFdIr4QWC++JAOV3nqf3i42335SiuP4UxMK69abbEpXZ0ATr+y/pSlp/uAd/tS5pQ+pLKWinfi6pBPIM8K1RG9LKAVZpWLfnRvlbJ6SGIv4Secom3S/+bSfhUlP09cpQBk//KwziAT91fkBgT77rjtVSzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dI+b7G8O4Obt6TT0NSEZZPrWnT1Jca5ybYB27GLl24=;
 b=kSNd0jEuiHxYR5OKL+2D7oeLunfE0o/qpoTc4pCME0pxIisXlE+hmK/wwR43Os2iDSjB4Bm0sZneq6ZptaLeyB8t7RVfZ7KLzK5F5D6smNvFsW4B0NDXC3uM5krEOn45Xos5sP81cMD6/7UPxt9svrg1Md1iDqgEXc+k1yRe6Gf4+gdUdKAx0/IxXlfQRuUU2MjVro1yIAQt5RuZV3dtXGF65W/HMMcw87Ric2J0st1mfKibyDabNsTiK/p00Ypl46I8G1QgfFpymKOI1Kn48WHXNVTyPrhoXTk6StsldFLKif56YrA4SvXU7hECRz/9t5NYnHVsMZuBrItFV46QXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dI+b7G8O4Obt6TT0NSEZZPrWnT1Jca5ybYB27GLl24=;
 b=CkskRf0LmrS4PyA19ysxmsp8nA5KN3h4y2R75cCuzW2NbO1ZTFpw5syBQYqE2MTb1tVVP1Nd8BZiduUnij8bhwJSkFfpdGCdIpkGSJrYUoNbHNRIL9sR/a6hi0aTlR2Jst/tdAf226zocd3Tgn6nY1C5J/TxaPpe1b58ZdZZ59I=
Received: from SN7P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::16)
 by DS0PR12MB8814.namprd12.prod.outlook.com (2603:10b6:8:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 19:46:46 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:806:124:cafe::49) by SN7P222CA0016.outlook.office365.com
 (2603:10b6:806:124::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.24 via Frontend
 Transport; Thu, 18 Apr 2024 19:46:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:46:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:46:44 -0500
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
Subject: [PATCH v13 01/26] [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
Date: Thu, 18 Apr 2024 14:41:08 -0500
Message-ID: <20240418194133.1452059-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|DS0PR12MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: ccc2a210-ef36-4947-eec0-08dc5fe047c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rUDs9wU2DisUr9ZZRh26V2KzHS7t5oKN49kb1tMTae0YCcmrVZAlC42wcgzbYztsLkpswmS2Zh99Bpwpj4+12d06vYppUdXcwK3dlp+M6DkU50/jU2ngMeadyN2iE0VhEk5qpW0fpW8w1fgyTSZvfWlFFGVRLleHY95KBe1d6Lr1/6KIkT54P/OXkgS+8ketYsR5BZIU5zAJojvWAa+pdOL5WKwRpQJyfFtUOkCQQDKtlKbP4HOgHpSy+f333vzDFqOIn7Na5rM4l0kpJl+5F01SeIj8axBx7TTakMmgAQhjFq4mj5k+eP6UHUKCABJ7VVlSsJJ0JFx4btJ6ZFccxx011zmC3SDy7UiwMqS+77t61e75kjOeXwAeUkPvMxbHvXY3LOayYb7kc0uNRnZwK0JTlQOYG1HW2m9n4h6VFaxkk//tXR3pGjTBowWgnIWf1Ne2xUx8NQ1O2UJjIb+5VU0Sy+/6PWL2U/h6qm3+8PCe8TKiH/+CnhQqe5mHUxNVGGfgSwpX/W33+kCqlltBKfPQej1jV1w5CArna74xU6EYNG1rfQbMurEklGWcDwpItoaxyZi9OcYmqN1VaecfWNI5lvuHSJ2PCGKiR9cv07UYc/m4DpcOTjCtRsOmwY73pFLxTJ8BSJxOMLSc3dOxUk6n5kmm63oqhhn7c2PZvrAhCBIzbcvrVZfHqtqZqfq/eSzXJcAq5RxQw1lrnloGC5YfR2BUO47wN7+nKxA5Hz2w2Ah/hGa9t07kH24PMPzn
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:46:46.0715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc2a210-ef36-4947-eec0-08dc5fe047c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8814

From: "Borislav Petkov (AMD)" <bp@alien8.de>

The functionality to load SEV-SNP guests by the host will soon rely on
cc_platform* helpers because the cpu_feature* API with the early
patching is insufficient when SNP support needs to be disabled late.

Therefore, pull that functionality in.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7632fe6e4db9..d64fb2b3eb69 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -135,6 +135,7 @@ config KVM_AMD_SEV
 	default y
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
+	select ARCH_HAS_CC_PLATFORM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1


