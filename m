Return-Path: <kvm+bounces-26200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 972D5972938
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 08:04:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF5A6285B85
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E095A175D37;
	Tue, 10 Sep 2024 06:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KBrW0Kew"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2085.outbound.protection.outlook.com [40.107.96.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B813AD09;
	Tue, 10 Sep 2024 06:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725948261; cv=fail; b=iz00pFhpIV0FuB3yIE55lTJNyW5hjzIscgDjmxL7dwZQdILDojhE7RP+u6HUxbYHmgwupNQi08HIeQv20navXWcpKBQVbonow98PExOlPnNei5it6OsRNHT5ZDwOOGjHoaLfxJi0QNTaf+JGpxhg71WXzGjelUvGkSVvAilRQ0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725948261; c=relaxed/simple;
	bh=QI8lcM155gvsN/0vpySkRHE5Uso3hpCbCzm1Za6gDHw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lDe66z+dCDNoC1GmnH8tWFSmhRF1FO+0zOvOKFOjzeAJYgJdW5T8brcFs8PGQh2ch4eJc26Eo0RFBWTXWal+hy5bu935JQO9uat5S6bRl+lIle3fqNocGvcc7mcwHNdVBq8nbCbpZPqIPP8DdeqCbvT5fcsfYjtIMVjeI/U7zrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KBrW0Kew; arc=fail smtp.client-ip=40.107.96.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x8V5o1WdjWKjKvfk9JzFo2knPV0L8cYJLuMzLTXh2pZBpD8J42N+/mYfXdPmpqaQRTzZWelGun4BgdtzJjnYQzoF1mFGkLrhUpQQORPh+Y0d/GsjhCk1DZLqZL3nniBH57o6TPF9tR5WUm4Jpkd3Z47JywmPyeblRI82aNnxvBibWG4GCAD332Qrjp43+WzwNAkpwXFfLyJwMie3i8k3WVMtimny1ZTf17O5QMraIIwVCj8hookkbFc8Mdc5/rs/q8ndxF/YdcfBSKvNToEimJzEyV8v9sSvyYViNVDgSKsf39Wja8jZuqKKcxT30m+DL0pkHuTPaP9lM7kQWBh6CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tpm1292gyqgs6s3vVvds7fgnNH/TOdvo/ndkaO/+jLE=;
 b=VyGndk0seSXTy5C0GcaIwUVPTfZUrkUV0g029vdkXQ6Yh6fjTQC2/VAJcIalmtjp9/qdaj72LuO073OltFu/AflcFqcxpaVyLuDfoaPnji1L/DuSERAymq1ozP/j3y8PgwkSStwJvAouh5DnBBv2fIdTAMOyU9sfF5jw+RIaJBk70MwY1akcfzsdsqn7Ej8hIYcQmF09NPGP5tPIysNxZabdyL5Mnf8oIPC/lN863f6JZcmpSOIeGvbMiIJ2vp0Ol1eCWbWH1NbcStStykFcbjdc62JlesO/CM6NGeJbXaFfdK/bqjolF7GeQtTLBS6JRBQRvpPEGvPtw5sI4sDhuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpm1292gyqgs6s3vVvds7fgnNH/TOdvo/ndkaO/+jLE=;
 b=KBrW0KewhOKhy/s88we4PFcda0ZFFmg+TQApbnadHq6xXMWH0UutZc/iCTifmLywS25l+CJs3osoJAF029ULBW+30yzSrdL4my1qNmFQWq76rBUmM4d/Dhah7OndSkMiAXtgbeOHjR++vSfGRtF9Zd2PncJK5aoaENyxx2a886o=
Received: from SJ0PR03CA0378.namprd03.prod.outlook.com (2603:10b6:a03:3a1::23)
 by LV3PR12MB9120.namprd12.prod.outlook.com (2603:10b6:408:1a3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 10 Sep
 2024 06:04:15 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::e5) by SJ0PR03CA0378.outlook.office365.com
 (2603:10b6:a03:3a1::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Tue, 10 Sep 2024 06:04:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 10 Sep 2024 06:04:15 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Sep
 2024 01:04:13 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v2 1/6] x86/sev: Define the #HV doorbell page structure
Date: Tue, 10 Sep 2024 06:03:31 +0000
Message-ID: <e4a96bea85f2581d82a3a47839289460e84b0589.1725945912.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1725945912.git.huibo.wang@amd.com>
References: <cover.1725945912.git.huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|LV3PR12MB9120:EE_
X-MS-Office365-Filtering-Correlation-Id: 053a64e3-318c-4101-bba9-08dcd15e665e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3dkERxObV1ad87RHiOv1BBEpC0QVuTfdPYMr4VeF95WKYI9bF3dwkDOHPLLt?=
 =?us-ascii?Q?ViixYxAsYex/2nWbuBWRWFS0e7F41VkvDnQTEJ2/jeJdGy7vxv61x8gXbji4?=
 =?us-ascii?Q?DTgF1WS1VEeIDiJSjj2R8cJ9+/MaMsy+DAcWHTROw7h2shVT8mwRzh+4YiUU?=
 =?us-ascii?Q?hw4e9MoeyfXK3Y5X65tDL4aVkVQYjTenTK+yg1xtGfh6KkU2Pfj9gtm2faT/?=
 =?us-ascii?Q?pWdFDu1zNteZO1Ajl/TWS1flumXsPpseWv2JBN3QpGCH3lggUtMxhvvrFmf8?=
 =?us-ascii?Q?DRNp97NlnvrvEAHqevaPJ+Clwsk1JdlikshIB02d7Av9d2JdxURdhlpM+5ox?=
 =?us-ascii?Q?6FZ0ySe6SH20OnOhomA7t7aZ7gdZhm02oXfQ3SQYVKNzsyUuHw3y0e5XcKYr?=
 =?us-ascii?Q?1z/nTuU3/cfpDjfmYJE7ZmHM+8FwvqH6Z8B5VELSAsXxRLyBWwX7fO4F6cll?=
 =?us-ascii?Q?w6SGhMboi2HxqZyVAAe8TyqL4G/0UVAa/Dhwxbuq+EvGSbYcVWApEKTenFzV?=
 =?us-ascii?Q?LsjscYVoywyv1fmLxJdtUnrq35HU+5R8dlZc2QrTc0fsw0i0wZiYpL68maOt?=
 =?us-ascii?Q?QXzvRamzQterrsqnPeyjbUrfpzJPCIFhg0w9D78ViLStdKagh7qQfOOMp2Bb?=
 =?us-ascii?Q?+oc8h7ewSWTQBoYYbj8XX2I9H0Wmd70L73B5G1J/mcfRcR/Sa6+dUoW6A3SS?=
 =?us-ascii?Q?TmHBp+FfEeuW2oYDp2XoOrmmrd5X6Dxf0j5kAPyFPnEnZFOLKUmPklm5WDAu?=
 =?us-ascii?Q?PcXHLga/EqbMnJC+E8Bs+I7UlItd/pC2xUgudlTxfM62Pv6Dii0IUQWvxnbl?=
 =?us-ascii?Q?pPijX3aYvAEb78n06QCvZ7Ftjr726k6VgktNU2LNwTYY29FdwkNdZEjU3HWr?=
 =?us-ascii?Q?J1pQHrjT1A6HvFcMi8vNZaRgfygqUhgZqbki9GMyjbDWcF7wH/PxgqFXYmHw?=
 =?us-ascii?Q?vyvQnD7IyQtz7WWR+fV+QXdnz6VjdMIxVo1so1JASY85cIGcR+byPkqinmXM?=
 =?us-ascii?Q?JLX9WeP5pm7ouMUl72FoJtmO0UFDifsims577NjaFnLG7UJl+/LJUCLquFw0?=
 =?us-ascii?Q?QCJOQ/FW0o3Z8iwb82hBoz1INh9mmpaUAJYy9CU1mYivIi+VqRTalEIbp1zp?=
 =?us-ascii?Q?ZuauEkMrlDjQBBRHL1J0sKp9DThwcninQ9Ne5625d30uv92aLSc87bRv4k6R?=
 =?us-ascii?Q?L+A4rHSlit1kZGCnzxhwQA0QgKo+3yDStJH1oWkPve1lnSHLHybFAi+9Ytui?=
 =?us-ascii?Q?eJsbUBmz5ViHS1RHmf6xg0iDY0Q+hwSwgHURHDFJU/mIuW6iuc+MnBmAK/H9?=
 =?us-ascii?Q?eh8Vn8DHjjnmjhh3RefLLP7UqQSgeqW5fOLAM6j3oydFLcOssh16keBdhOlD?=
 =?us-ascii?Q?bdtqsGPTCx9Wq0qPWYUWMGkeg+VswJe9UufTnvM+thZ0XkusKlNPoDaf55B4?=
 =?us-ascii?Q?XOtsM+KolB4+dC6t3/qSDNgKPjRg/ESw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 06:04:15.2508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 053a64e3-318c-4101-bba9-08dcd15e665e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9120

Restricted injection is a feature which enforces additional interrupt and event
injection security protections for a SEV-SNP guest. It disables all
hypervisor-based interrupt queuing and event injection of all vectors except
a new exception vector, #HV (28), which is reserved for SNP guest use, but
never generated by hardware. #HV is only allowed to be injected into VMSAs that
execute with Restricted Injection.

The guests running with the SNP restricted injection feature active limit the
host to ringing a doorbell with a #HV exception.

Define two fields in the #HV doorbell page: a pending event field, and an
EOI assist.

Create the structure definition for the #HV doorbell page as per GHCB
specification.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/asm/svm.h | 41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f0dea3750ca9..2b1f4c8daf19 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -516,6 +516,47 @@ struct ghcb {
 	u32 ghcb_usage;
 } __packed;
 
+/*
+ * Hypervisor doorbell page:
+ *
+ * Used when restricted injection is enabled for a VM. One page in size that
+ * is shared between the guest and hypervisor to communicate exception and
+ * interrupt events.
+ */
+struct hvdb_events {
+	/* First 64 bytes of HV doorbell page defined in GHCB specification */
+	union {
+		struct {
+			/* Interrupt vector being injected */
+			u8 vector;
+
+			/* Non-maskable event field (NMI, etc.) */
+			u8 nm_events;
+		};
+
+		struct {
+			/* Non-maskable event indicators */
+			u16 reserved1:		8,
+			    nmi:		1,
+			    mce:		1,
+			    reserved2:		5,
+			    no_further_signal:	1;
+		};
+
+		u16 pending_events;
+	};
+
+	u8 no_eoi_required;
+
+	u8 reserved3[61];
+};
+
+struct hvdb {
+	struct hvdb_events events;
+
+	/* Remainder of the page is for software use */
+	u8 reserved[PAGE_SIZE - sizeof(struct hvdb_events)];
+};
 
 #define EXPECTED_VMCB_SAVE_AREA_SIZE		744
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
-- 
2.34.1


