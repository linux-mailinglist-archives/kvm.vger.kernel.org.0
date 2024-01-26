Return-Path: <kvm+bounces-7066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C75CE83D3AB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC43B1C2214F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4A4111AD;
	Fri, 26 Jan 2024 04:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VRpfg1eR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC3713FED;
	Fri, 26 Jan 2024 04:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244348; cv=fail; b=dDEN5gprWHudcWtw7HRPG1BEaxlKDL55FBvHwpqRPoHENrgsDJgMTNP98YLFKrpqF94JgvKqPgfbSa9ZPTUAIVYZh0N9IWm+HRjQ1DgiC32E/wFqSBrl/wwFLo9fPA1eE9V++zR1rqV/4Hoh/ZzZouxeBeuN+Hhgu3l2COvIfhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244348; c=relaxed/simple;
	bh=2sIUYBbXkdCzEf1ZEnDU2qwuN3+Kmyq3ApGKZF72kEM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OqjCxn+QaJ9GKirWd6cb8pq44Tt80sty53w1wV+XpmRQDM4GY1Q3F1BODDgDlsPhgXyUmwbA4mmAxVCHCS5m7OpPvNV/ay/P1d1OPEZJIzrowyLpWPJfH2xadC/x8No0/hGikZNpKeYUEwE5LDNotzE9OLc9gr6F5IVLaOHOXGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VRpfg1eR; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6wjTveJHPX6U+uUvmKwgGtIa8NA12O44etpuwPmlmOPIHinAZ3BP3+PK/SF7N5pXWzz2EHx8HwsGguJWrOpg7V5+o0CTVTBiI2YH8mX1KKG2VIfN4WmQN7RTknrY8f8YimYopZaRHx/JTfjDSju4lSKG29GSPoSjAx+m/+uqBVRx188JYaBKVWERrZN88ap8lKe2OT+5iM9/rQlSN7LfD57Hfn9Ia4Cgse56CBQ7kts34FAZVBOillzS0l/DfVuGozqQKXVJOtcsNIaW8chQkb9O1tAHqNcDKw+hICra6+AQrMZ+hVEHEXdE9Sa4AXBlRaWxOGi+DE5W9l39pAKqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AMGVMMWRfpMi4iyhUnQz528Hz/O4DZ5uaxI+sp5psM=;
 b=oPkgfGwNW1mjAOS64BqG8Lro1NE76vwvXzlIz6HTtyhtMmDzLe4L+ktAdcY1TFKTi068upOlsV4evEDTLIu8/xoNx43fe1GUQ4ASVQ8I9KzN64R9Zo4cffJnBZb8W3eS5G9Z7/pRz7Io9msWgce0rNCAQN0bxbEA58EHykYQT7yZImlWd2GKq0IIZPA7K1Ub+N+7aUDsjDvk2DdziF0uhnFETvpdqrmclpnDA2zUho4tunYsKB8mvJsBPXBg3s4/j1qUq5itNk56wIK040teyXgIFPZOXOvUEw4ShwAJP0PK7k8F0OY5esQqDOyolP6tBUqX+X+2FjOkFwBNR1kq5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AMGVMMWRfpMi4iyhUnQz528Hz/O4DZ5uaxI+sp5psM=;
 b=VRpfg1eRJBgaFp0qlb4QLS86yagyUuSMiUh32zHu8+WMev2gdIuma23xhcZ5cj1jf/CNZ1E8RFefCyRxhTmiINmzIkICwuOP0FeNaUvDqRH/jgP01QhxHJk+utzUOM9J9sMh3Be059ZhIIYR+lvZR3z6/Atk8gm0zA+xm1NOVik=
Received: from DM6PR08CA0011.namprd08.prod.outlook.com (2603:10b6:5:80::24) by
 BL0PR12MB4915.namprd12.prod.outlook.com (2603:10b6:208:1c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:45:44 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::69) by DM6PR08CA0011.outlook.office365.com
 (2603:10b6:5:80::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.38 via Frontend
 Transport; Fri, 26 Jan 2024 04:45:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:45:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:45:41 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v2 22/25] x86/cpufeatures: Enable/unmask SEV-SNP CPU feature
Date: Thu, 25 Jan 2024 22:11:22 -0600
Message-ID: <20240126041126.1927228-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|BL0PR12MB4915:EE_
X-MS-Office365-Filtering-Correlation-Id: 100c4706-a2ee-4b33-17f6-08dc1e29a814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rHP180opXMHn+HCrZQ0/PpXNBbJB3JxvKE7k+OpmZnHQ+LzBKxp7gRHVQQlmPosLwWL++N8oxZ0cEbPepgnvyeoN65rhJD3kV+P+3McVQ4Yy8lKrgyy+pUKyCyqayu91rZ0/pmwN2PsWSDg06ZeGVpMPKNYA0fi2RGHDGJJhP4WL/CqictxAXG2PVWqTsE78+i7Uv8SUzxm4VM7v+X4Yg43X5nckjA2+mlYNa1w0jY892ofL/LsvoLMNfKsvBXVePYzbjoNKUGWLYmhxoJAjbqA8pxrYNIDpnE8GQN6h9/IFecUHkDdOu5efRSN/dbWIgaEnQNrF/QPl5nY/O94f5qXiuBBPtA4tdSZxcS6/PLIg/1fAoWt3YrofpWrZtIyV6CtgQOOjiYD1Yj5Cn9QMrtcgVk8hB7fiRHZ++yQI4ivVp9GckmuMjiE8L0eAFk87Md0MBkJHcvxE/NrI6Rx4LM60WOSoWVO5MHTZycc/9+BiMSPOGX2SCt1CvBzp9GgpcPr92XiJGCOwj/ntiYOy2LbAq5qYWGEiW3iaNuBYggEgcD2/bF9CZrBzsKssQFq85WuPGcZJeEiMZPMYtpjwyojzaa7w36Cop09OA/LK05/h5toLF24mK3gCUSH9K3ZB19nu6qb8m2Aqa40AVgkHI1lx/9Qz/Sqpv2h4xj5NouAHa96PCFhvZ746MtgSIOa/oz69mjxpYVH1ArG9kb6JniBLxmVEd1G/KzKBQkwK0VRoSKJWda3bpMNZOEFHg4KxmrolhMZUlsEJvVbzpQ/PuA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(376002)(39860400002)(346002)(230922051799003)(64100799003)(186009)(82310400011)(451199024)(1800799012)(36840700001)(40470700004)(46966006)(40480700001)(40460700003)(83380400001)(47076005)(36756003)(356005)(81166007)(86362001)(36860700001)(44832011)(8936002)(8676002)(4326008)(5660300002)(426003)(336012)(26005)(16526019)(2616005)(1076003)(82740400003)(70206006)(316002)(54906003)(6916009)(70586007)(7416002)(7406005)(4744005)(2906002)(41300700001)(6666004)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:45:44.1211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 100c4706-a2ee-4b33-17f6-08dc1e29a814
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4915

With all the required host changes in place, it should now be possible
to initialize SNP-related MSR bits, set up RMP table enforcement, and
initialize SNP support in firmware while maintaining legacy support for
SEV/SEV-ES guests. Go ahead and enable the SNP feature now.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/disabled-features.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 1ea64d4e7021..85a7b5ce96c9 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -117,7 +117,11 @@
 #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
 #endif
 
+#ifdef CONFIG_KVM_AMD_SEV
+#define DISABLE_SEV_SNP		0
+#else
 #define DISABLE_SEV_SNP		(1 << (X86_FEATURE_SEV_SNP & 31))
+#endif
 
 /*
  * Make sure to add features to the correct mask
-- 
2.25.1


