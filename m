Return-Path: <kvm+bounces-43556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5506BA917C6
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 282AF5A4B3E
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4CCB226D14;
	Thu, 17 Apr 2025 09:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v7npmzoZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C81335BA;
	Thu, 17 Apr 2025 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881893; cv=fail; b=ONFH+oIOI4J0F9n6yqZvmXSqIXu81WIShhiM4UWiaTQfstW2FWXLisl51DUhWvIlJykH88OD+QsYEZY9akueho9x9WwJ6qf4/liBlwf0XMEOfIIZSOXytvuJZhvqE+7gDDqJqYKGAaRGzOtNdetMQGI7kOZnXM9eJWWZSrt7XZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881893; c=relaxed/simple;
	bh=B4JBCRsZ4u0ER8nXcWrOMtDefXQRAsHpPeedDHigxkI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jTJ7NJzqMi4AwEc9CW5neKUTYvPmDYsvD8dzQfOWt4czF/Ok7H9sNKIb0e2Td+khOPZvt1WJF668m96nI6mPcBIhAaNHQrIU+5S8TVACqbqUpINf/s+qbBmjutJfj42VTuE850viVj7jO0A75XBO2540zmF7+fh4r3KFDWNfQ7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v7npmzoZ; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hZ4BSEi3DomFVf9m1afiLCpKBsx0GNbJfAkWYvDasqgGbpfp/supJkpetZtZI2/YS8Ut3kKpq9fPvnhkFgUxYr9DInZ0lRjPQy666UFyb19yRJnrHNdJpysmSGxL73Dv+fe7g8VLsFKH8E83vtL/D1wP4vWet8hcOdQHI0Mhas3kh8LyA5eLhW2U3u4Zxs6PW8ok/uwan3dActqGa5nkt0Mo5DA9WiRhEpBOlkOfp3RUmBXnNacjTicpEk6ScVbVf7xazAC5dNmynj6jCmXzBhmr7xMZ3sk0irU23A6tmdY4sdI05W5KnvIfES0D08/dzTOgvT/R9Ywbt+RhX+zDIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/1A7IVUNFPTU+FPCzjRS2HBHGdPpHvhYDWwGZ+KFQM=;
 b=DNqwqbLyYDWw7Dlvd8gbhgj97mSIyFOXel18NdpemxFwfwJMcPkOxgn828dCY62WcM9Hc/oWyperkebYKMv2F67ocvtmiSSXFa2l9BVhrCRGjw1+Hak8Qk/JpQ8jQjakczeLsHkQwiaxRBtFZltrWxF4ZPgbTjPqYBWI1tmacZJTQRgtJ6yNXNAixKNoTUEvY6w3CHyZpAnMGcKPVmrZB1Xn3+1OD9y+2HbwfdBH5S7C63EQ9B5ePE3a18Lv1gvv+PCWVJ/vs5daK8gQOcoEj+Ws+uq+5X88NJDTAu0HBoSZ5OWZY5rndXcD3PIq6nBjHz5ZEMgVKYqCgZSbxlA5Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/1A7IVUNFPTU+FPCzjRS2HBHGdPpHvhYDWwGZ+KFQM=;
 b=v7npmzoZaS8h+CrT4TEdFE6IOr/dct4atM29kUZwzaMNCEUmEMOz2AM0Cco65C7bwMhyXMnZygPxnS66W73KdbcZLhARlh9hmGa57kfqnq1a9oxIG+APxCEoIGTN1tTppjNSVOPgb41xY363mtxG891W+81DSRREOxv6qD0olKA=
Received: from BL0PR02CA0055.namprd02.prod.outlook.com (2603:10b6:207:3d::32)
 by DS0PR12MB8525.namprd12.prod.outlook.com (2603:10b6:8:159::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Thu, 17 Apr
 2025 09:24:46 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:207:3d:cafe::50) by BL0PR02CA0055.outlook.office365.com
 (2603:10b6:207:3d::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.15 via Frontend Transport; Thu,
 17 Apr 2025 09:24:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 17 Apr 2025 09:24:46 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:24:38 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v4 18/18] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Thu, 17 Apr 2025 14:47:08 +0530
Message-ID: <20250417091708.215826-19-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|DS0PR12MB8525:EE_
X-MS-Office365-Filtering-Correlation-Id: 735abb8d-c5ad-4588-bd36-08dd7d91b1db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jtT6xrj+0nhUXUjr24tz9rHO0lMON9TTkwXlTe/CpP9wwF+fY7uZQrwiUMsL?=
 =?us-ascii?Q?R9f3Pq095Q2pkIxVZFGm6dDdJTf5iwCPJWSOlb71h5j9srXP/en4OnqPa5qN?=
 =?us-ascii?Q?5WSbhwgWY4NWzP5KKu9QX0/+P3qfk/t/NMtu3iJBTOPSynLmRFVJmFGY9NNB?=
 =?us-ascii?Q?K78zv0sqbKkMqHuqaPQEusj+Pxwa9Q3P4e7Zymzlifo9a1rfNterNrVuQ/hI?=
 =?us-ascii?Q?++59lXwh7ZTc36IrWV4gVEQf3EcHM7Dk5r88Q3nqLdQMAhQtkXa3H/qqBiDO?=
 =?us-ascii?Q?hv1aP89pbNuRnSQ7aU/bKEtJd9uFRc4yihpHOvdoh5bv/MINzm4GmfymXdXl?=
 =?us-ascii?Q?G2cJtDSiA60VQRSAGcS50c4qnh4DRwaSoZYNGMPuzN4jE0oxCaOsYV3w72On?=
 =?us-ascii?Q?/HIxjdO/Df7XL3zyBgj1nu/pQk/DrI++OfbywCCknMcBn8nCkKNjFF2JAJZQ?=
 =?us-ascii?Q?0tj1TH/joKcdepErr8uCK59HE1+x/3h+eVuBky2ICdVxeTNofqsp78tqmVcM?=
 =?us-ascii?Q?7PhpbZ8xu/cFDraDW24OSCqDFhn9Lr6gzX46r7Gvn4AyfmifDQNdX+IyuiUq?=
 =?us-ascii?Q?JFErPRoRqkhXCOeKeBTG3nHP7Xs9TzhbK/eoqQvYBVGjsItzCIRZTejUAbpy?=
 =?us-ascii?Q?bwRRUy3BjvuRCv5Xq8sIXVR6vjuKYzb2nLeNy+qKxV23V+3o1rXPwbPjJ14m?=
 =?us-ascii?Q?IbKKDz6tm6XsZRXexqXvy+0M1fVXXqHukn6Up8kysugk5eFS6/jl0AJE+kUB?=
 =?us-ascii?Q?fZLLTA00U4q/O7veTdEMc3qfk9VXKUASisSmXYtb8EpLdJ/E8AQLFpXHyHPb?=
 =?us-ascii?Q?JOX0EpcJNashT4C9Vo/k+Q0Qi0XXICX+oeLrWzEoUIDPzky2SKuLE2I1Ar5D?=
 =?us-ascii?Q?NgmRiAgfCjd1OKGS6j6QdyAPq+gDAhEwIxzn5QeUmEqeuoEo5TP96F/kieoq?=
 =?us-ascii?Q?nfhzAOTIjiytQwJMAMYm5ueUAzubF7cRJswZQ4Y0Gukmbqo7Swdbnb8OmdNv?=
 =?us-ascii?Q?ItSLl5opSZ7moNGc5Fdrb/DCQVoR0xqR9VPiwPJce08su7Gt9+w2/0Z2bPli?=
 =?us-ascii?Q?yUAAw8MyWYiR6E4fsw1ScvETKn3T+UpV9mwwIoAowN8TV13IeFePBXD/z17U?=
 =?us-ascii?Q?QcrKZGIpvG/kTuyT3jns3U13zqDA8EzDKv7koiJX1N0q200pnbDpfE2t0iQS?=
 =?us-ascii?Q?A1B9bYrh4IOEHgxIJu3SNw4ko3jt72CUP1YgpJPNn702LBwffH+iOEK2N7Vd?=
 =?us-ascii?Q?wwRYd88g2NMZuSielRp/e+7GFIhmBJUh8YMT/mk5KWV61MspVm8ySAEfwdYt?=
 =?us-ascii?Q?C34HkVgZGURCWvCYszI5F1HgZC77+56hP0IdvBon1BaCf8xGT3rRj6qUul79?=
 =?us-ascii?Q?vF9AjblqlJGdk2a9e9mKcJ2FOcQ0B9Eq9/zifhiu9uWU3wZaa+agbKdvii5y?=
 =?us-ascii?Q?AB7ZzgiZONRIa7r5+SAOKGm2r2ADl8GieclZdMedK3DuNJ8mdN2GrMpdh0Dm?=
 =?us-ascii?Q?aotnvKig8ERb/5pHkEKIl64Aoy37kVW95bnV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:24:46.3748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 735abb8d-c5ad-4588-bd36-08dd7d91b1db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8525

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC feature if CONFIG_AMD_SECURE_AVIC is
enabled.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - No change.

 arch/x86/boot/compressed/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index a418e80cfcf3..c5a467c334af 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -402,13 +402,20 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 				 MSR_AMD64_SNP_SECURE_AVIC |		\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
+#ifdef CONFIG_AMD_SECURE_AVIC
+#define SNP_FEATURE_SECURE_AVIC		MSR_AMD64_SNP_SECURE_AVIC
+#else
+#define SNP_FEATURE_SECURE_AVIC		0
+#endif
+
 /*
  * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
 #define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
-				 MSR_AMD64_SNP_SECURE_TSC)
+				 MSR_AMD64_SNP_SECURE_TSC |	\
+				 SNP_FEATURE_SECURE_AVIC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


