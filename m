Return-Path: <kvm+bounces-15159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7495C8AA36E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 010C51F21748
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABAD61BF6EA;
	Thu, 18 Apr 2024 19:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KbrsZkdp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E16918412C;
	Thu, 18 Apr 2024 19:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469764; cv=fail; b=aq3WsJh7oNRbJtDRzMogUoWzfF6G4K55Qj4sL8IZwKy32mk0zRGE2SNKWLtfGVVqfkqtY02ZUQW1/ULBbchb1GgmdX18bHsbtSYqSzNvvmSFkSWs665Duv3KAvq0X4jqiMj494aBSS2HrYEtArY8CmsaDTYJ9h+pv1IxraYWL5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469764; c=relaxed/simple;
	bh=/LyX0lMdUIy7Re5uMF7sJFrGKLk94ez+2D00SwZmmSM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OojihXXmWX5oP1MDxQgDXK0lFc1YoA2duJooq0A70Tz+0hm649uS4Zc0ko3JLDwCimwJgSPoT+ciQwUML2jvIXD1pb77dRzX5H4YOvV9o8Q43ZEHWTgWjkzqFPd+w5Wt5ep3bCjgxsEK7Nr9jlsAGd72j5JpDqwKAfGKbDJ1qxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KbrsZkdp; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk5SXXHIjy0LcJzRIKYL8c2ckBhqdB+r/GW/chZpBNwYk6lq+5bJP/SoqfaEN7p0ChL4b1G1XH98df21s0QmDBRELRvPWe9vIfHyVu+njDkfw/DPqTbTlZPBJRF3/d+Gbbg5N2yo2qReomycabqPA7ELvB6vH8jGa/fjPieVu//kQb2pDG0vSzr01FbVEWqp132DYJXzAMP0JFGai+I6KdtdzCk0dhv2RJVUGO494qPsp36miV0MzG8kKzNVx8Q22sGoY5vu03oTLWDuLrKP8Wpt4hfqY6lRL0EVhBsfJ2eq+6RFLeANg8G+nuClI+GbOIg63vl4bJaxsw6ZXeJsRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=;
 b=addtLWZDMS2fO0VbV6Jf6vMEt9l98CoUxj5sFub8wnigBGS/V5KuRCQfl0nIbPPhMy1VxAT0B9xRHjbYdrWBEg3FN/ZEwyMXXxiBBNykOodpvT6eklsfvppykAVgPGK9788Fmg4UjFver9ky/K6oUkxOLSKCuFBC/6aHt4wBUagteSDPbeZ8fvAXIzIw8s+/7DEsD3dBfgaRcFIoneThEKSOdX9YJG2bj+S9AOCfcW0uWUffcS2O481AblJrHU+SgFSVTN+wfJM7c6X7XPiZa1loerk+VAPuQv/hFgEc3kOPcIJmJ2ROFffcVjAIK+FPHRIsj0JeVHn8LKbe3f28ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=;
 b=KbrsZkdp0Fxypm8dduEptXITP32sKgde2zjg5oxU5/x8bR6bSGa6xXaxK04imOErzxTeADD9/FzyisUF99ozqcBUCkNH7SaOzaxLBFT2QnLypjFn8JpScDqSV7gffXpLyLg9D3oIjLdNY6kgwJ2CTx3ID2LJvqaBcJhO05jc8pI=
Received: from SA9PR03CA0025.namprd03.prod.outlook.com (2603:10b6:806:20::30)
 by SJ2PR12MB8941.namprd12.prod.outlook.com (2603:10b6:a03:542::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 19:49:20 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:806:20:cafe::b9) by SA9PR03CA0025.outlook.office365.com
 (2603:10b6:806:20::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.28 via Frontend
 Transport; Thu, 18 Apr 2024 19:49:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:49:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:49:19 -0500
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
Subject: [PATCH v13 02/26] [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
Date: Thu, 18 Apr 2024 14:41:09 -0500
Message-ID: <20240418194133.1452059-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|SJ2PR12MB8941:EE_
X-MS-Office365-Filtering-Correlation-Id: 18d8d66b-5193-4e22-ff08-08dc5fe0a397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7Hi69/DLJoZX/Uv7JnYDgrBYFG0NJIga1LP56oKOvondWpFPFl8/kxhk2nkWTBQluAEdjIe3c0VD/no2PJr5XX/qRlJi5pmHiQ3CmrgLMvQSSx3/R7vO8nC7N9zU56FN/sSCyoTazzxR+4j7EdLMeKg88EDmVOowlQ/P5kXVrK26IGtAMtGeF0jDCrbCrJSOlkxfoBkbQG1pgaaW649JLKmB3o7UfDHfoktscwdHDSMSJKGZ4pgN7yHq4QkxePRgPSu2x69sUgJguv6gmIXEbF/W6V/pzr71D6nIByGWBOKVqGuXpbpX6VbRIUdxUVLrOrOeGaeAQLcqPAPLuaiYUFd18rDiimyeUse4azLSN1YU9KO4TC5RIb+S+bLTWu04RFmthUkVNVk4E8uCVEEG6HDjyJgfL5e5AF7INp2uA6lOxWwv9IA6Yjjj7/+EVRaTnXs5fkrhEMkm5C3nMvUJNQHK1howY7gJC+2NWkeYYfw6H82cV/m2Qq7WYYgvgNt65IhF4hxWq0l3p7/t+1wmf6h+sMpTHUcahKVoWKkZ0DFY43cUOkcPnjDgUDF5OGu6azUMMWFnbA//Ly5sztArfkUtPllAsyoVbwBUO1RwOAroL2oj/IeQq1il5h25wpSwdZJBzck0IXB5rVPuw8KMka43l4LkDv51njFf4LYvbTk4HGW+fr3QvhWYdq+foxAaSpruee1JfkGMZoSg1mF//1MbILmlE1jXY/RyujpPKddBNTDwYgZ6pLUaDZo4Ov8+
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:49:20.1103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d8d66b-5193-4e22-ff08-08dc5fe0a397
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8941

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Add functionality to set and/or clear different attributes of the
machine as a confidential computing platform. Add the first one too:
whether the machine is running as a host for SEV-SNP guests.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/coco/core.c        | 52 +++++++++++++++++++++++++++++++++++++
 include/linux/cc_platform.h | 12 +++++++++
 2 files changed, 64 insertions(+)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index d07be9d05cd0..8c3fae23d3c6 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -16,6 +16,11 @@
 enum cc_vendor cc_vendor __ro_after_init = CC_VENDOR_NONE;
 u64 cc_mask __ro_after_init;
 
+static struct cc_attr_flags {
+	__u64 host_sev_snp	: 1,
+	      __resv		: 63;
+} cc_flags;
+
 static bool noinstr intel_cc_platform_has(enum cc_attr attr)
 {
 	switch (attr) {
@@ -89,6 +94,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
 	case CC_ATTR_GUEST_SEV_SNP:
 		return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
 
+	case CC_ATTR_HOST_SEV_SNP:
+		return cc_flags.host_sev_snp;
+
 	default:
 		return false;
 	}
@@ -148,3 +156,47 @@ u64 cc_mkdec(u64 val)
 	}
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
+
+static void amd_cc_platform_clear(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp = 0;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_clear(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_clear(attr);
+		break;
+	default:
+		break;
+	}
+}
+
+static void amd_cc_platform_set(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_HOST_SEV_SNP:
+		cc_flags.host_sev_snp = 1;
+		break;
+	default:
+		break;
+	}
+}
+
+void cc_platform_set(enum cc_attr attr)
+{
+	switch (cc_vendor) {
+	case CC_VENDOR_AMD:
+		amd_cc_platform_set(attr);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
index cb0d6cd1c12f..60693a145894 100644
--- a/include/linux/cc_platform.h
+++ b/include/linux/cc_platform.h
@@ -90,6 +90,14 @@ enum cc_attr {
 	 * Examples include TDX Guest.
 	 */
 	CC_ATTR_HOTPLUG_DISABLED,
+
+	/**
+	 * @CC_ATTR_HOST_SEV_SNP: AMD SNP enabled on the host.
+	 *
+	 * The host kernel is running with the necessary features
+	 * enabled to run SEV-SNP guests.
+	 */
+	CC_ATTR_HOST_SEV_SNP,
 };
 
 #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
@@ -107,10 +115,14 @@ enum cc_attr {
  * * FALSE - Specified Confidential Computing attribute is not active
  */
 bool cc_platform_has(enum cc_attr attr);
+void cc_platform_set(enum cc_attr attr);
+void cc_platform_clear(enum cc_attr attr);
 
 #else	/* !CONFIG_ARCH_HAS_CC_PLATFORM */
 
 static inline bool cc_platform_has(enum cc_attr attr) { return false; }
+static inline void cc_platform_set(enum cc_attr attr) { }
+static inline void cc_platform_clear(enum cc_attr attr) { }
 
 #endif	/* CONFIG_ARCH_HAS_CC_PLATFORM */
 
-- 
2.25.1


