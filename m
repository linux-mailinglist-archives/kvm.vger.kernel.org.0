Return-Path: <kvm+bounces-7064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C0383D3A5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C3B128C65C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE67C10A19;
	Fri, 26 Jan 2024 04:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TFrl5xVk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AF513AF0;
	Fri, 26 Jan 2024 04:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244306; cv=fail; b=QrL9czxUIXUGo+M3d/v5SlViQdboKX7IKRPB8xTdwVRq0RiYQDf9qyT9UA5RESd0alIe/cVIB+pn7F1lQRrz8fr64rfsVsJQC9R8hj7ncPyNZ8A6DNlUb8ABTOZ11yEDYvav4+ReEmqhwEbE/r7HnSKCWpZoIW7XW8F3GJzkxSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244306; c=relaxed/simple;
	bh=76BTXg4sALymSfPCL0b04xry2EXH4Znpc+QY3WSWfeY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNfRQOiVB4PDY2umqx3amVohIxZouE7+xSDdzW0TJbXdx383OeBv3NG243eF6yHKF35q2p3l3PLorvHPq2jVPiglkPPJgDv8iT/m9+4s0J2WNRWLUUuJ/scKAWZaIJuvpnl5iBhoPaYFE/3a0wN/Dxf+C7bV7JLBhFcaF3dbj3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TFrl5xVk; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NORmJmUq3hewCRKzFyyxWUYGy181Yq8fpWCoEtHsennHv4epf324Y8riNOB3LU9ZNn45GTseD7Zryh3VxbUdWIERUBiy9qZ3cCGj5l0miNaR+Q/WnRhVq8Boc5/hRGimEv4Umrywio/krRR4gGcwhZtJHUbCQLi05JJsApBvKbYfUfbV8P6PFeNbfikxeFsvPdn1JOBtuBHqJ82jax3+aprGW2jw9CqQyo7WiN6S5cNEw83BWNJjHvCq5RjEZTS/eN2/rCTa0ZZ5q3VOdDqwewmiA8ynhQ6mGOVHHs77bBQ7ZRiDV4gizylkbt9So915UTrTBhLR5xGwLYI7B61WNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZrwuA+myy/OhKqqUcE+jpu3j4mlNa0YdB31jV4lASGo=;
 b=K+rj3c7t03BUAfAcIcXSI0tCMtbVUS8c1MKFlBzs2YojsrU2VCbcMajD8Lv73Ze/EGO4GXaWFb06Kl1TlJmuhkHwmfcOv1zV9UEb4plTiDRTuMmyh7+jP6OJpy7I/etEy+EHEVXDNm8AkGbhaBsenQFtY9m4la3SEz4Dm9XxU657rCy6TSpsXmaskgMYpqJC0sdKnmmZ00m1nKFIeuSfla5Yr5j+lpSuUcGJUx2KV3nRwh+NgM6fV7ejXOdMBuDyZKquJaqFzyT5p8Kl+M9FS8t06Xe707jwZ48TPpH/QHv52PyYceglRRCLGdxKwufNyzSxADNB/p8qB21RNIWHrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrwuA+myy/OhKqqUcE+jpu3j4mlNa0YdB31jV4lASGo=;
 b=TFrl5xVk28GpKG7SBiKvyf5FUcIFy7LLlN+f7WhNBuZVPWXflzykkEKEBvtNs5GcvYP9k10Ia99BFYVQH8dMF6qVn723ULxjQdgc0TAGoIfp9ePRET3t2dJFPqqvF9HxvSHYVQH5QhdkyJeYhhslN2hTiTMGgFYwwQgkQU0DuhQ=
Received: from MW4PR04CA0216.namprd04.prod.outlook.com (2603:10b6:303:87::11)
 by IA1PR12MB7517.namprd12.prod.outlook.com (2603:10b6:208:41a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 04:45:00 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:303:87:cafe::42) by MW4PR04CA0216.outlook.office365.com
 (2603:10b6:303:87::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26 via Frontend
 Transport; Fri, 26 Jan 2024 04:45:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:45:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:44:59 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>
Subject: [PATCH v2 01/25] x86/cpufeatures: Add SEV-SNP CPU feature
Date: Thu, 25 Jan 2024 22:11:01 -0600
Message-ID: <20240126041126.1927228-2-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|IA1PR12MB7517:EE_
X-MS-Office365-Filtering-Correlation-Id: 927a4435-6866-4501-2d90-08dc1e298de7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	z14I7UH0O9zJcJLtj9u6+VPOuiymI6TtN+U49b4OsPyNha/EU6UHwXGGrlmJmevM8A62piUIw/446E1+tuvDWMAxGN5E2Ji0jBFXnJwfbk9yf8zupv61R7N91MKi9IxLZBIS6k7EdgwpgoTcibGDVGcNavJzKWDcjpWIEXd8GAv+avX++pOY/7sW2EyPPWb/LFhIL4nh7728QEnX8UiKRthRCsVetIkIY+WFTQCShLiVytesSownful9bTRAPGbDABZJWct5l9SPh7kUts9UayjTt77SsQUCVQEH9oJfJcpgGg+d4fptjV9ByzixchVrlWUTeVO48YOe0ueizAJ5m4Lhi+Juwi3v76+3FhImY6+e9wkhKc4k5Q3D3LOY4QNs/21CJ+vWFQmeRt7TGJXLro34QJw6SAapcJY/YW44/dmbZrVWAalyzeAR7UOCFtCSy77Tlq+2gUaNjgPbI+o9RUTpkk1u+dNbzgvRdYcxNcMf0GpBNHVX4heEVK4mQ0wubXuXRxxBIcJnRH+He3uy0i6JaNIMbMPBa7sj1mJj5DsDsEsNnIXyWjsARf/g7yvWlEyLaEE2fOrsemXy+I00IolHCCgNlYejkqbhO0wkt7ZQ5MeznZk7nvaT2sBDDrQrhS0QGxP4xkGalbNR2TIMssJ7E13+j1ZoVzjpZag1fS//0MuMp4Q78ti5kq5aelL3mSA2IZL2UdJtATYvIs8gpMu+WCqViay5aQKcKivpP21ZIaErWJCqhPivdvrT6c4+v1riFbyRYbxPJUz3QEnEFA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(1800799012)(186009)(82310400011)(64100799003)(451199024)(46966006)(36840700001)(40470700004)(40480700001)(40460700003)(5660300002)(426003)(336012)(26005)(16526019)(70206006)(70586007)(54906003)(6916009)(2906002)(7406005)(7416002)(83380400001)(6666004)(316002)(478600001)(8676002)(44832011)(4326008)(1076003)(2616005)(8936002)(82740400003)(81166007)(356005)(47076005)(86362001)(36860700001)(41300700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:45:00.1435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 927a4435-6866-4501-2d90-08dc1e298de7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7517

From: Brijesh Singh <brijesh.singh@amd.com>

Add CPU feature detection for Secure Encrypted Virtualization with
Secure Nested Paging. This feature adds a strong memory integrity
protection to help prevent malicious hypervisor-based attacks like
data replay, memory re-mapping, and more.

Since enabling the SNP CPU feature imposes a number of additional
requirements on host initialization and handling legacy firmware APIs
for SEV/SEV-ES guests, only introduce the CPU feature bit so that the
relevant handling can be added, but leave it disabled via a
disabled-features mask.

Once all the necessary changes needed to maintain legacy SEV/SEV-ES
support are introduced in subsequent patches, the SNP feature bit will
be unmasked/enabled.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/include/asm/disabled-features.h | 4 +++-
 arch/x86/kernel/cpu/amd.c                | 5 +++--
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index fdf723b6f6d0..0fa702673e73 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -440,6 +440,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 36d0c1e05e60..1ea64d4e7021 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -117,6 +117,8 @@
 #define DISABLE_IBT	(1 << (X86_FEATURE_IBT & 31))
 #endif
 
+#define DISABLE_SEV_SNP		(1 << (X86_FEATURE_SEV_SNP & 31))
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -141,7 +143,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	(DISABLE_IBT)
-#define DISABLED_MASK19	0
+#define DISABLED_MASK19	(DISABLE_SEV_SNP)
 #define DISABLED_MASK20	0
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 34e5c2cb8042..79153e9b92b5 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -602,8 +602,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 *	      SME feature (set in scattered.c).
 	 *	      If the kernel has not enabled SME via any means then
 	 *	      don't advertise the SME feature.
-	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
-	 *            SEV and SEV_ES feature (set in scattered.c).
+	 *   For SEV: If BIOS has not enabled SEV then don't advertise SEV and
+	 *	      any additional functionality based on it.
 	 *
 	 *   In all cases, since support for SME and SEV requires long mode,
 	 *   don't advertise the feature under CONFIG_X86_32.
@@ -638,6 +638,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index f4542d2718f4..e58bd69356ee 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -437,6 +437,7 @@
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
-- 
2.25.1


