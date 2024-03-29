Return-Path: <kvm+bounces-13134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F5C18927A0
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CE961F2341C
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58AB13E413;
	Fri, 29 Mar 2024 23:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tIqmA0po"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8751513BAD2;
	Fri, 29 Mar 2024 23:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753628; cv=fail; b=NAyU4Ql1nzqh8Ta+6+4fkuH3r8iuNk9YQFSF2A6/gisj9px5BkNYKlBn4AgIMyWt1I567ugxqpkl3AYixa0QaggzXoehxx6L6ncHvn8I7Ez2tFYoL9vZNbZ6wk3Abq1m4Yl3ARVXTYgiBOs5wDFCDMLeLe6eG2QE/wdDDqys51o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753628; c=relaxed/simple;
	bh=/LyX0lMdUIy7Re5uMF7sJFrGKLk94ez+2D00SwZmmSM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4Ct+4Fh5CFHklVz8ec/KI+Vy8l6gy8sMrsA8G0VSc6BXV51aSZvcce5TO0VWpkgWRO6L20qOjtIvW71UBRjh/dpKSwVxN3thY6iXTtS2sn6wbWKOTbs/7n5LW4tFODW5ZD6LyYgDgXpsXkY2D4E35ysdtbX5m/Gl5n/SGm3LLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tIqmA0po; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndNy51RAtRmNI8klSsRuUDkZ+QOIkz6PU7RicglEDrpSyeD334tm0h8TSmMzsqeKS6iJHpCYyPb/2bgRTgXwHuE5nHOCRWpYsQEUf9FfnAoZgq/FS6Ag1+n/PW1+XMjGrd3hTaQEMzt4f+mR1+LDDkpXF6HZbdDWTZG2jzrQfcx3peXwGhSzI8Mp7fmiZjGo3auxlW9277c3ZxbV6l/RzlDC8dI1+yGUojFlO4mTFp9PJnkeSg2YDsVKIVAYEAoYZXTUzSuLTkJJqQLWjodWuLBih6ic/HZU09yGVYj2AxSh3I65W1AeCVMVbbEa8KbrhsCIUknM1mpNPA/gEPz2Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=;
 b=gMrC496qK2lsX87+6Bzyto2bAcxON65hdXqTeSYWXiTb9dMrUdvT2nBXXHCO9PSCV8BRKATgr3QFZL2DbJrjIrQrsltBxeFF71VRItM5A+TTH4AicOLngecTmO8rH7zlYENBB2oVx3wSKnvuU6N30ye3Cjzdcs1BVE9Zy9sB4Ul91SoyuDz+mggYy57PkPNmCmlx2d166CZHTTZJJJYqBcsHxO085W4pD2XSkVkLV72jqVcUQau02SVCvvx1k9v76Lrx1CsfhE62bu8cgJJLFXucZdWOwY5ft5+iXGnW/Bwt1HJdv9FcbPLjhvfQZ/2KhAPqUXvJYyvL0lc5vYMNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvZLQjrPFSHZU6UdddtPnKlQpxoW832vsCNW4OOtrX8=;
 b=tIqmA0poLlOQSgC8NQymU+wMavstViScDkmLWx+nPuwEKSNoq8248LCA6B4ywz4GfDsUL/JVBQork/uEDWaaxIugEnRZyot0VUV/YkV9/1sII8p7qKebIp15+bvVlPGAntwT+ov4j9ElzGeCZbgxsHd/5BERvoXJ+Xjp3NdTnpU=
Received: from DM6PR01CA0007.prod.exchangelabs.com (2603:10b6:5:296::12) by
 CY8PR12MB7730.namprd12.prod.outlook.com (2603:10b6:930:85::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.41; Fri, 29 Mar 2024 23:07:03 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:296:cafe::1c) by DM6PR01CA0007.outlook.office365.com
 (2603:10b6:5:296::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:07:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:07:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:07:02 -0500
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
Subject: [PATCH v12 02/29] [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
Date: Fri, 29 Mar 2024 17:58:08 -0500
Message-ID: <20240329225835.400662-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|CY8PR12MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ffad58-535d-4024-6cb1-08dc5044f290
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0GqJcz06FWXScvO9q8UIen2Z5TIMPCwU7rdZJGHj+mAWkK5UWm4PnDKCmYgyV6KpeW5mNlwQEgzWXz89aRhNwVa9wB2gRYvrLIgGWw4N6Vr4jp4dfl8VwdC0ycC93sxY2xW+fe4jdeZgPhu/SB4QLT2sV1ndIpuyq40tUT/o0P/0nz3TFNAeu7DWQtwO9KM1gGCLv2c2YWaG2I28urqVBAEPs/Lh7IB9KQK2t3Q81bePUBE3DM6N5Un4Q9wYfgoHPRTlgN+Bh9FkttL47rOMJ/EVcgsz+MQmLB8WK66RMLcIwfu/vtN5y6nLduBqBfhorBcp6zuEs+PTOhNcN+CFyqBClZmAJ8QdSuOlmTWjymD3lzO1y3oa0U/+yLlDAcMsYKIUpx+5WQ5j4/lAZVO0q6s8IPE/Dc+d60WxY1YU28uCX49WJM5XsQDmNxH0XrGqxIGyQZ0OZG+XWbADxRLmF7wtKjB1K4TnGmFbGxlv/VDZqHCcq+fnJCBe64OkMcnbvkErwcuRbZnRIpyyoGQaZNbaa+GScMLvc2hjsnKH9ehVr+YXspEX9UHlliDBQHx99aXyp2F7q/0rnaYKqbHpMo4ZK26eAjrPsaaPwox+sjWJqIifSdzkr/G99zUVnLEkfYHuelBcZ+UO++2QpNKzeTssudbif+5NjNuyXxfRTfOYllVrmGeB2cLdGZT0KfYdernQqt8vm5t2THsWM9CWDi2o4SF+TnOkjV3wIec1H3DVG759Esk29a322K114Jm/
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400014)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:07:03.6536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ffad58-535d-4024-6cb1-08dc5044f290
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7730

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


