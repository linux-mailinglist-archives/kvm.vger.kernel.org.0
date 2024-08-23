Return-Path: <kvm+bounces-24915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BAB495CDF9
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:32:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53B702878EE
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BF2188598;
	Fri, 23 Aug 2024 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p7mqwdbv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4966D188019;
	Fri, 23 Aug 2024 13:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419949; cv=fail; b=HcT5zgQefSSyXAjKo6HoTcEAZ9TXRLgnqT7qN3eJw2TXI5bhaV1g9LH5SMlDCYzV0mjWlL+8ll5W8c2eUovvcIiTs+z4Lo2WGFiI5V1jKP7te2Ej6nxz9k/PMPlQqjeUQGjVuCVmyAuUA0a7ovnbjp3hXVpg1SBXscf+11xYOaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419949; c=relaxed/simple;
	bh=2sSNnNiqrPK9u1bC+fx+PtkJGEtNQBTDs1bPprCle3M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qbTF0AuBHNq9W+4nbfu57I/nxgm/6E/95tn0iI0GjlUuLK4+PfUOZ9nZa4vwgKk/WwkpYBaAgWoDG7Y+UHNwJ4rO3GffEdS5HPsmuWUmidshBI/040v1JFcDB0utph88qqwW/mnlGrWlToa/T9aaa3dQv4u8zH4r+a8CZd0UtRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p7mqwdbv; arc=fail smtp.client-ip=40.107.94.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGJZ5FMPHRo8EGPBU/mpBlrHaBNv8JlvNzq1YI72GZYE/HdCCJsn1TlUDqP7oxnGp3MIpczKuKcEC+mLSCnQr4SCqxhQ92VscN5w0JFPPa9IKpJPLARh8xUIZa5a7gmuFaMLopDSke8zcUd1qg3Tr2AQsmkYdCQrBxCiAYjjFFysItj2p8CV1AWviaH814Da4C3VCZpamRRGYyax1C067WLv0WBPr74VUfldpzzhFn34AWfAsmrHEMRKWtNWiogHgPKL+jMg9yP5Z7zezLlZSs898pLzlC/wFs3ERaxZ2GMDMNJlnqus/9JQeAsPX9ygvgPIIzFN0GciSMHXlEmqrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsIusbNi933NMJt5Rj3XHKhmTlQroQCHYhChkcWKWRU=;
 b=dZ49Bthy+8u3NEyxT7IQ6TpMkS5CsgKCFOYUn0Iz7MO+XqkzH4RmgmgmetA7jNifoQgMhPOaxKcXj9J2fcA2GWUM0jm/qtRCXYcmkDFegDnywV/t29KFhg/5cwlaYwpDsWTU+CEg5HVC3NZ0W6lt4EsHMect4OZiOhch5MAXoL/c9F0ZsaEFyIcGRxZQjS8x03EG+hB0yrY6XPO70U/bTEOMAsfZXxGLOCDH99331vSnLTnWkIvXlJD2ufzVDmcCAEfNgV90GrckxY8pzukzKcZsPiz2JF7TIZj4lKcooIsVBr81nsG0D3bVK6MlDl/TAxkgHccCcGglzjll0WTxCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsIusbNi933NMJt5Rj3XHKhmTlQroQCHYhChkcWKWRU=;
 b=p7mqwdbvEAY4BakJ2CXTxOyJS6jGO3SQvu/qd0S1/Q/saITZFWZsxrfXyNROlREBhDKtuRGrxjLxWtIgo/nk3vuYytys+QyKmehX2pCYfUECGHF4VePSyog8+5nNz9f5t/knD0XW7aJVz0uLldD3IpYiuwTKSEDw/G0ANf1VVJU=
Received: from PH7PR10CA0012.namprd10.prod.outlook.com (2603:10b6:510:23d::26)
 by SJ1PR12MB6195.namprd12.prod.outlook.com (2603:10b6:a03:457::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Fri, 23 Aug
 2024 13:32:21 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:510:23d:cafe::ec) by PH7PR10CA0012.outlook.office365.com
 (2603:10b6:510:23d::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:32:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:32:20 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:32:15 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 17/21] coco/sev-guest: Implement the guest side of things
Date: Fri, 23 Aug 2024 23:21:31 +1000
Message-ID: <20240823132137.336874-18-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|SJ1PR12MB6195:EE_
X-MS-Office365-Filtering-Correlation-Id: 26d496f9-a68d-4fce-fad6-08dcc3780402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M89j1Qy/WN3GIXysA0FdYLmpWPoCbwz9giDCFUNcyDrqMrbJC8nuBDQYMzIL?=
 =?us-ascii?Q?xMEUUQRyyuqNhPqZWdEnEnRKvCOMS/KrdRq0UYmBVRIHwvLoucU2pAADPG7B?=
 =?us-ascii?Q?YgBwDnIE6sJG9KdFxO6/PJClrRDLG84JXqf09S7GFsuyaZyH1KDFlDKBGSVm?=
 =?us-ascii?Q?AHKnfQKh/6uqxgYFwkzu/R5JsKiyFQD0p1O0yVliGS6kwWLs4V4QlSiYw8Ji?=
 =?us-ascii?Q?XOSoBn0HEWSN6qNemErjC+zyUdHx82huE8wvUI8orDtgt8fynLE7h8zkH7ym?=
 =?us-ascii?Q?9l6eyguXjgU6MZgSq7vC1441ucgVqg1AAFOp3NptQ/lcYAN0P1svh0Q7RW0U?=
 =?us-ascii?Q?dEExEDx68lXfQuOVrr7j55xggeVWyUgttdJfJ5e6QQwk5b/4F8TLfTtlv18T?=
 =?us-ascii?Q?aVseW9/a6EPjXnRjMFiAtaAH3oWBL0lKn0FlHYSH5b+IXPMbp/TLwJU2wJez?=
 =?us-ascii?Q?fUXhOVbesrofQi7VkWgnvnEfI2zYt2FHSnPwaD8RxD0jTdevmGd/dpWtfftm?=
 =?us-ascii?Q?y3hatVX7xrsbTnIv4seGUODF4Ozwxgdapr4o4XjBh2bv2ffv+tS99MgZQyVo?=
 =?us-ascii?Q?yVkAbHVNMcNijT8OJBSDkxAwWAXzb8e8lZyixem5piPGqKHdDeAk2F17CqVX?=
 =?us-ascii?Q?U9tPhRqwv4/dOXB/aza4npo5Ie/361HAnt2zIMri7wVBz9c5AmVk25G37YFn?=
 =?us-ascii?Q?+Pqx3jkCOnCBVpFApWmgA9I8Fdgi+dKb12D4U68OKhZgHk8x07F68bYrDARB?=
 =?us-ascii?Q?Cn3/iG2NSCBzeph9UYIToEd3pItqTAQKERImWOJBx4RfCbhJ71uviCQkFfxi?=
 =?us-ascii?Q?bqEiDXB/n4jrxM4JLC7Tdy8HdMXL4lAARVvRYDakYRzQHpx+AQtDV9PlB8ap?=
 =?us-ascii?Q?uQaDMfKZxu5jMBQmWbrl7KL5OQlRQ7fshoiNjZwRRx+aZf4ZcpRQj8QMiEFK?=
 =?us-ascii?Q?tAZpHzhFLHc+16KkKR+Mi+vQMoeBf+z3urfJx9ltYauLpb7CT8y2/OeisrSC?=
 =?us-ascii?Q?R5xatw5T+if9bqdC2p8H2IpnnTdDUb+7AsqLOAfPCzQswbHDkq0Q38s/G6lz?=
 =?us-ascii?Q?qOZH5HjiKHfjIf246eBIc/TctaNp7FdsnLn3Y0Zq2l/B5EhBMLj6pNfWeQ3c?=
 =?us-ascii?Q?Q/kg+clHHfaGaZHP1XMLAJ+sC17T3xLH3xnLnXQn5vktTYQyzWxFH2zuMe0m?=
 =?us-ascii?Q?+2qFjAhNoIa29kqSFa4Zy6nAvmGa8eZOjDw5IkjNn+TSAzQ3DleNjq4wF3Fg?=
 =?us-ascii?Q?owfx2f2SNyTHAPW3Nm0qDxXKUbYNN80WiEdDIwDbgnLno7BLTgBJtxY3TVHM?=
 =?us-ascii?Q?0xeGf2vasFfu+Y+1jeWAalgCC3NVkq4IoEZZA12lQ3mcH1T50LO5AduBNSef?=
 =?us-ascii?Q?DtBDwq8v62J8gbuKyPPuu/jxNwmsjJQOpJjFG48qlhEeuDp7YwMX0zOAygiI?=
 =?us-ascii?Q?8moFjXTKO4qsN0ijNwysEuI/MClv1Hcn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:32:20.9313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d496f9-a68d-4fce-fad6-08dcc3780402
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6195

Define tsm_ops for the guest and forward the ops calls to the HV via
SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST.
Do the attestation report examination and enable MMIO.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/sev-guest/Makefile        |   2 +-
 arch/x86/include/asm/sev.h                  |   2 +
 drivers/virt/coco/sev-guest/sev-guest.h     |   2 +
 include/linux/psp-sev.h                     |  22 +
 arch/x86/coco/sev/core.c                    |  11 +
 drivers/virt/coco/sev-guest/sev_guest.c     |  16 +-
 drivers/virt/coco/sev-guest/sev_guest_tio.c | 513 ++++++++++++++++++++
 7 files changed, 566 insertions(+), 2 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/Makefile b/drivers/virt/coco/sev-guest/Makefile
index 2d7dffed7b2f..34ea9fab698b 100644
--- a/drivers/virt/coco/sev-guest/Makefile
+++ b/drivers/virt/coco/sev-guest/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_SEV_GUEST) += sev-guest.o
-sev-guest-y += sev_guest.o
+sev-guest-y += sev_guest.o sev_guest_tio.o
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 8edd7bccabf2..431c12bbd337 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -117,6 +117,8 @@ struct snp_req_data {
 	unsigned long resp_gpa;
 	unsigned long data_gpa;
 	unsigned int data_npages;
+	unsigned int guest_rid;
+	unsigned long param;
 };
 
 #define MAX_AUTHTAG_LEN		32
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
index 765f42ff55aa..d1254148c83b 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -51,4 +51,6 @@ int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 void *alloc_shared_pages(struct device *dev, size_t sz);
 void free_shared_pages(void *buf, size_t sz);
 
+void sev_guest_tsm_set_ops(bool set, struct snp_guest_dev *snp_dev);
+
 #endif /* __VIRT_SEVGUEST_H__ */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index adf40e0316dc..bff7396d18de 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -1050,6 +1050,9 @@ static inline void snp_free_firmware_page(void *addr) { }
 #define MMIO_VALIDATE_RANGEID(r)  ((r) & 0x7)
 #define MMIO_VALIDATE_RESERVED(r) ((r) & 0xFFF0000000000008ULL)
 
+#define MMIO_MK_VALIDATE(start, size, range_id) \
+	(MMIO_VALIDATE_GPA(start) | (get_order(size >> 12) << 4) | ((range_id) & 0xFF))
+
 /* Optional Certificates/measurements/report data from TIO_GUEST_REQUEST */
 struct tio_blob_table_entry {
 	guid_t guid;
@@ -1067,4 +1070,23 @@ struct tio_blob_table_entry {
 #define TIO_GUID_REPORT \
 	GUID_INIT(0x70dc5b0e, 0x0cc0, 0x4cd5, 0x97, 0xbb, 0xff, 0x0b, 0xa2, 0x5b, 0xf3, 0x20)
 
+/*
+ * Status codes from TIO_MSG_MMIO_VALIDATE_REQ
+ */
+enum mmio_validate_status {
+	MMIO_VALIDATE_SUCCESS = 0,
+	MMIO_VALIDATE_INVALID_TDI = 1,
+	MMIO_VALIDATE_TDI_UNBOUND = 2,
+	MMIO_VALIDATE_NOT_ASSIGNED = 3, /* At least one page is not assigned to the guest */
+	MMIO_VALIDATE_NOT_UNIFORM = 4,  /* The Validated bit is not uniformly set for
+					   the MMIO subrange */
+	MMIO_VALIDATE_NOT_IMMUTABLE = 5,/* At least one page does not have immutable bit set
+					   when validated bit is clear */
+	MMIO_VALIDATE_NOT_MAPPED = 6,   /* At least one page is not mapped to the expected GPA */
+	MMIO_VALIDATE_NOT_REPORTED = 7, /* The provided MMIO range ID is not reported in
+					   the interface report */
+	MMIO_VALIDATE_OUT_OF_RANGE = 8, /* The subrange is out the MMIO range in
+					   the interface report */
+};
+
 #endif	/* __PSP_SEV_H__ */
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index de1df0cb45da..d05a97421ffc 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2468,6 +2468,11 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
 		ghcb_set_rax(ghcb, input->data_gpa);
 		ghcb_set_rbx(ghcb, input->data_npages);
+	} else if (exit_code == SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST) {
+		ghcb_set_rax(ghcb, input->data_gpa);
+		ghcb_set_rbx(ghcb, input->data_npages);
+		ghcb_set_rcx(ghcb, input->guest_rid);
+		ghcb_set_rdx(ghcb, input->param);
 	}
 
 	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
@@ -2477,6 +2482,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 	rio->exitinfo2 = ghcb->save.sw_exit_info_2;
 	switch (rio->exitinfo2) {
 	case 0:
+		if (exit_code == SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST)
+			input->param = ghcb_get_rdx(ghcb);
 		break;
 
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_BUSY):
@@ -2489,6 +2496,10 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 			input->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
+		} else if (exit_code == SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST) {
+			input->data_npages = ghcb_get_rbx(ghcb);
+			ret = -ENOSPC;
+			break;
 		}
 		fallthrough;
 	default:
diff --git a/drivers/virt/coco/sev-guest/sev_guest.c b/drivers/virt/coco/sev-guest/sev_guest.c
index d04d270f359e..571faade5690 100644
--- a/drivers/virt/coco/sev-guest/sev_guest.c
+++ b/drivers/virt/coco/sev-guest/sev_guest.c
@@ -52,6 +52,10 @@ static int vmpck_id = -1;
 module_param(vmpck_id, int, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
+static bool tsm_enable = true;
+module_param(tsm_enable, bool, 0644);
+MODULE_PARM_DESC(tsm_enable, "Enable SEV TIO");
+
 /* Mutex to serialize the shared buffer access and command handling. */
 DEFINE_MUTEX(snp_cmd_mutex);
 
@@ -277,7 +281,8 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 		return -EBADMSG;
 
 	/* Verify response message type and version number. */
-	if (resp_hdr->msg_type != (req_hdr->msg_type + 1) ||
+	if ((resp_hdr->msg_type != (req_hdr->msg_type + 1) &&
+	     (resp_hdr->msg_type != (req_hdr->msg_type - 0x80))) ||
 	    resp_hdr->msg_version != req_hdr->msg_version)
 		return -EBADMSG;
 
@@ -337,6 +342,10 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
 	switch (rc) {
 	case -ENOSPC:
+		if (exit_code == SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST) {
+			pr_warn("SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST => -ENOSPC");
+			break;
+		}
 		/*
 		 * If the extended guest request fails due to having too
 		 * small of a certificate data buffer, retry the same
@@ -1142,6 +1151,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_cert_data;
 
+	if (tsm_enable)
+		sev_guest_tsm_set_ops(true, snp_dev);
+
 	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
 	return 0;
 
@@ -1160,6 +1172,8 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 {
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
+	if (tsm_enable)
+		sev_guest_tsm_set_ops(false, snp_dev);
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
 	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
 	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
diff --git a/drivers/virt/coco/sev-guest/sev_guest_tio.c b/drivers/virt/coco/sev-guest/sev_guest_tio.c
new file mode 100644
index 000000000000..33a082e7f039
--- /dev/null
+++ b/drivers/virt/coco/sev-guest/sev_guest_tio.c
@@ -0,0 +1,513 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/pci.h>
+#include <linux/psp-sev.h>
+#include <linux/tsm.h>
+
+#include <asm/svm.h>
+#include <asm/sev.h>
+
+#include "sev-guest.h"
+
+#define TIO_MESSAGE_VERSION	1
+
+ulong tsm_vtom = 0x7fffffff;
+module_param(tsm_vtom, ulong, 0644);
+MODULE_PARM_DESC(tsm_vtom, "SEV TIO vTOM value");
+
+static void tio_guest_blob_free(struct tsm_blob *b)
+{
+	memset(b->data, 0, b->len);
+}
+
+static int handle_tio_guest_request(struct snp_guest_dev *snp_dev, u8 type,
+				   void *req_buf, size_t req_sz, void *resp_buf, u32 resp_sz,
+				   u64 *pt_pa, u64 *npages, u64 *bdfn, u64 *param, u64 *fw_err)
+{
+	struct snp_guest_request_ioctl rio = {
+		.msg_version = TIO_MESSAGE_VERSION,
+		.exitinfo2 = 0,
+	};
+	int ret;
+
+	snp_dev->input.data_gpa = 0;
+	snp_dev->input.data_npages = 0;
+	snp_dev->input.guest_rid = 0;
+	snp_dev->input.param = 0;
+
+	if (pt_pa && npages) {
+		snp_dev->input.data_gpa = *pt_pa;
+		snp_dev->input.data_npages = *npages;
+	}
+	if (bdfn)
+		snp_dev->input.guest_rid = *bdfn;
+	if (param)
+		snp_dev->input.param = *param;
+
+	mutex_lock(&snp_cmd_mutex);
+	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST,
+				   &rio, type, req_buf, req_sz, resp_buf, resp_sz);
+	mutex_unlock(&snp_cmd_mutex);
+
+	if (param)
+		*param = snp_dev->input.param;
+
+	*fw_err = rio.exitinfo2;
+
+	return ret;
+}
+
+static int guest_request_tio_certs(struct snp_guest_dev *snp_dev, u8 type,
+				   void *req_buf, size_t req_sz, void *resp_buf, u32 resp_sz,
+				   u64 bdfn, enum tsm_tdisp_state *state,
+				   struct tsm_blob **certs, struct tsm_blob **meas,
+				   struct tsm_blob **report, u64 *fw_err)
+{
+	u64 certs_size = SZ_32K, c1 = 0, pt_pa, param = 0;
+	struct tio_blob_table_entry *pt;
+	int rc;
+
+	pt = alloc_shared_pages(snp_dev->dev, certs_size);
+	if (!pt)
+		return -ENOMEM;
+
+	pt_pa = __pa(pt);
+	c1 = certs_size;
+	rc = handle_tio_guest_request(snp_dev, type, req_buf, req_sz, resp_buf, resp_sz,
+				      &pt_pa, &c1, &bdfn, state ? &param : NULL, fw_err);
+
+	if (c1 > SZ_32K) {
+		free_shared_pages(pt, certs_size);
+		certs_size = c1;
+		pt = alloc_shared_pages(snp_dev->dev, certs_size);
+		if (!pt)
+			return -ENOMEM;
+
+		pt_pa = __pa(pt);
+		rc = handle_tio_guest_request(snp_dev, type, req_buf, req_sz, resp_buf, resp_sz,
+					      &pt_pa, &c1, &bdfn, state ? &param : NULL, fw_err);
+	}
+
+	if (rc)
+		return rc;
+
+	tsm_blob_put(*meas);
+	tsm_blob_put(*certs);
+	tsm_blob_put(*report);
+	*meas = NULL;
+	*certs = NULL;
+	*report = NULL;
+
+	for (unsigned int i = 0; i < 3; ++i) {
+		u8 *ptr = ((u8 *) pt) + pt[i].offset;
+		size_t len = pt[i].length;
+		struct tsm_blob *b;
+
+		if (guid_is_null(&pt[i].guid))
+			break;
+
+		if (!len)
+			continue;
+
+		b = tsm_blob_new(ptr, len, tio_guest_blob_free);
+		if (!b)
+			break;
+
+		if (guid_equal(&pt[i].guid, &TIO_GUID_MEASUREMENTS))
+			*meas = b;
+		else if (guid_equal(&pt[i].guid, &TIO_GUID_CERTIFICATES))
+			*certs = b;
+		else if (guid_equal(&pt[i].guid, &TIO_GUID_REPORT))
+			*report = b;
+	}
+	free_shared_pages(pt, certs_size);
+
+	if (state)
+		*state = param;
+
+	return 0;
+}
+
+struct tio_msg_tdi_info_req {
+	__u16 guest_device_id;
+	__u8 reserved[14];
+} __packed;
+
+struct tio_msg_tdi_info_rsp {
+	__u16 guest_device_id;
+	__u16 status;
+	__u8 reserved1[12];
+	union {
+		u32 meas_flags;
+		struct {
+			u32 meas_digest_valid : 1;
+			u32 meas_digest_fresh : 1;
+		};
+	};
+	union {
+		u32 tdisp_lock_flags;
+		/* These are TDISP's LOCK_INTERFACE_REQUEST flags */
+		struct {
+			u32 no_fw_update : 1;
+			u32 cache_line_size : 1;
+			u32 lock_msix : 1;
+			u32 bind_p2p : 1;
+			u32 all_request_redirect : 1;
+		};
+	};
+	__u64 spdm_algos;
+	__u8 certs_digest[48];
+	__u8 meas_digest[48];
+	__u8 interface_report_digest[48];
+} __packed;
+
+static int tio_tdi_status(struct tsm_tdi *tdi, struct snp_guest_dev *snp_dev,
+			  struct tsm_tdi_status *ts)
+{
+	struct snp_guest_crypto *crypto = snp_dev->crypto;
+	size_t resp_len = sizeof(struct tio_msg_tdi_info_rsp) + crypto->a_len;
+	struct tio_msg_tdi_info_rsp *rsp = kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_tdi_info_req req = {
+		.guest_device_id = pci_dev_id(tdi->pdev),
+	};
+	u64 fw_err = 0;
+	int rc;
+	enum tsm_tdisp_state state = 0;
+
+	pci_notice(tdi->pdev, "TDI info");
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = guest_request_tio_certs(snp_dev, TIO_MSG_TDI_INFO_REQ, &req,
+				     sizeof(req), rsp, resp_len,
+				     pci_dev_id(tdi->pdev), &state,
+				     &tdi->tdev->certs, &tdi->tdev->meas,
+				     &tdi->report, &fw_err);
+
+	ts->meas_digest_valid = rsp->meas_digest_valid;
+	ts->meas_digest_fresh = rsp->meas_digest_fresh;
+	ts->no_fw_update = rsp->no_fw_update;
+	ts->cache_line_size = rsp->cache_line_size == 0 ? 64 : 128;
+	ts->lock_msix = rsp->lock_msix;
+	ts->bind_p2p = rsp->bind_p2p;
+	ts->all_request_redirect = rsp->all_request_redirect;
+#define __ALGO(x, n, y) \
+	((((x) & (0xFFUL << (n))) == TIO_SPDM_ALGOS_##y) ? \
+	 (1ULL << TSM_TDI_SPDM_ALGOS_##y) : 0)
+	ts->spdm_algos =
+		__ALGO(rsp->spdm_algos, 0, DHE_SECP256R1) |
+		__ALGO(rsp->spdm_algos, 0, DHE_SECP384R1) |
+		__ALGO(rsp->spdm_algos, 8, AEAD_AES_128_GCM) |
+		__ALGO(rsp->spdm_algos, 8, AEAD_AES_256_GCM) |
+		__ALGO(rsp->spdm_algos, 16, ASYM_TPM_ALG_RSASSA_3072) |
+		__ALGO(rsp->spdm_algos, 16, ASYM_TPM_ALG_ECDSA_ECC_NIST_P256) |
+		__ALGO(rsp->spdm_algos, 16, ASYM_TPM_ALG_ECDSA_ECC_NIST_P384) |
+		__ALGO(rsp->spdm_algos, 24, HASH_TPM_ALG_SHA_256) |
+		__ALGO(rsp->spdm_algos, 24, HASH_TPM_ALG_SHA_384) |
+		__ALGO(rsp->spdm_algos, 32, KEY_SCHED_SPDM_KEY_SCHEDULE);
+#undef __ALGO
+	memcpy(ts->certs_digest, rsp->certs_digest, sizeof(ts->certs_digest));
+	memcpy(ts->meas_digest, rsp->meas_digest, sizeof(ts->meas_digest));
+	memcpy(ts->interface_report_digest, rsp->interface_report_digest,
+	       sizeof(ts->interface_report_digest));
+
+	ts->valid = true;
+	ts->state = state;
+	/* The response buffer contains the sensitive data, explicitly clear it. */
+	memzero_explicit(&rsp, sizeof(resp_len));
+	kfree(rsp);
+	return rc;
+}
+
+struct tio_msg_mmio_validate_req {
+	__u16 guest_device_id; /* Hypervisor provided identifier used by the guest
+				  to identify the TDI in guest messages */
+	__u16 reserved1;
+	__u8 reserved2[12];
+	__u64 subrange_base;
+	__u32 subrange_page_count;
+	__u32 range_offset;
+	union {
+		__u16 flags;
+		struct {
+			__u16 validated:1; /* Desired value to set RMP.Validated for the range */
+			/* Force validated:
+			 * 0: If subrange does not have RMP.Validated set uniformly, fail.
+			 * 1: If subrange does not have RMP.Validated set uniformly, force
+			 *    to requested value
+			 */
+			__u16 force_validated:1;
+		};
+	};
+	__u16 range_id;
+	__u8 reserved3[12];
+} __packed;
+
+struct tio_msg_mmio_validate_rsp {
+	__u16 guest_interface_id;
+	__u16 status; /* MMIO_VALIDATE_xxx */
+	__u8 reserved1[12];
+	__u64 subrange_base;
+	__u32 subrange_page_count;
+	__u32 range_offset;
+	union {
+		__u16 flags;
+		struct {
+			__u16 changed:1; /* Indicates that the Validated bit has changed
+					    due to this operation */
+		};
+	};
+	__u16 range_id;
+	__u8 reserved2[12];
+} __packed;
+
+static int mmio_validate_range(struct snp_guest_dev *snp_dev, struct pci_dev *pdev,
+			       unsigned int range_id, resource_size_t start, resource_size_t size,
+			       bool invalidate, u64 *fw_err)
+{
+	struct snp_guest_crypto *crypto = snp_dev->crypto;
+	size_t resp_len = sizeof(struct tio_msg_mmio_validate_rsp) + crypto->a_len;
+	struct tio_msg_mmio_validate_rsp *rsp = kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_mmio_validate_req req = {
+		.guest_device_id = pci_dev_id(pdev),
+		.subrange_base = start,
+		.subrange_page_count = size >> PAGE_SHIFT,
+		.range_offset = 0,
+		.validated = 1, /* Desired value to set RMP.Validated for the range */
+		.force_validated = 0,
+		.range_id = range_id,
+	};
+	u64 bdfn = pci_dev_id(pdev);
+	u64 mmio_val = MMIO_MK_VALIDATE(start, size, range_id);
+	int rc;
+
+	if (!rsp)
+		return -ENOMEM;
+
+	if (invalidate)
+		memset(&req, 0, sizeof(req));
+
+	rc = handle_tio_guest_request(snp_dev, TIO_MSG_MMIO_VALIDATE_REQ,
+			       &req, sizeof(req), rsp, resp_len,
+			       NULL, NULL, &bdfn, &mmio_val, fw_err);
+	if (rc)
+		goto free_exit;
+
+	if (rsp->status)
+		rc = -EBADR;
+
+free_exit:
+	/* The response buffer contains the sensitive data, explicitly clear it. */
+	memzero_explicit(&rsp, sizeof(resp_len));
+	kfree(rsp);
+	return rc;
+}
+
+static int tio_tdi_mmio_validate(struct tsm_tdi *tdi, struct snp_guest_dev *snp_dev,
+				 bool invalidate)
+{
+	struct pci_dev *pdev = tdi->pdev;
+	struct tdi_report_mmio_range mr;
+	struct resource *r;
+	u64 fw_err = 0;
+	int i = 0, rc;
+
+	pci_notice(tdi->pdev, "MMIO validate");
+
+	if (WARN_ON_ONCE(!tdi->report || !tdi->report->data))
+		return -EFAULT;
+
+	for (i = 0; i < TDI_REPORT_MR_NUM(tdi->report); ++i) {
+		mr = TDI_REPORT_MR(tdi->report, i);
+		r = pci_resource_n(tdi->pdev, mr.range_id);
+
+		if (r->end == r->start || ((r->end - r->start + 1) & ~PAGE_MASK) || !mr.num) {
+			pci_warn(tdi->pdev, "Skipping broken range [%d] #%d %d pages, %llx..%llx\n",
+				i, mr.range_id, mr.num, r->start, r->end);
+			continue;
+		}
+
+		if (mr.is_non_tee_mem) {
+			pci_info(tdi->pdev, "Skipping non-TEE range [%d] #%d %d pages, %llx..%llx\n",
+				 i, mr.range_id, mr.num, r->start, r->end);
+			continue;
+		}
+
+		rc = mmio_validate_range(snp_dev, pdev, mr.range_id,
+					 r->start, r->end - r->start + 1, invalidate, &fw_err);
+		if (rc) {
+			pci_err(pdev, "MMIO #%d %llx..%llx validation failed 0x%llx\n",
+				mr.range_id, r->start, r->end, fw_err);
+			continue;
+		}
+
+		pci_notice(pdev, "MMIO #%d %llx..%llx validated\n",  mr.range_id, r->start, r->end);
+	}
+
+	return rc;
+}
+
+struct sdte {
+	__u64 v                  : 1;
+	__u64 reserved           : 3;
+	__u64 cxlio              : 3;
+	__u64 reserved1          : 45;
+	__u64 ppr                : 1;
+	__u64 reserved2          : 1;
+	__u64 giov               : 1;
+	__u64 gv                 : 1;
+	__u64 glx                : 2;
+	__u64 gcr3_tbl_rp0       : 3;
+	__u64 ir                 : 1;
+	__u64 iw                 : 1;
+	__u64 reserved3          : 1;
+	__u16 domain_id;
+	__u16 gcr3_tbl_rp1;
+	__u32 interrupt          : 1;
+	__u32 reserved4          : 5;
+	__u32 ex                 : 1;
+	__u32 sd                 : 1;
+	__u32 reserved5          : 2;
+	__u32 sats               : 1;
+	__u32 gcr3_tbl_rp2       : 21;
+	__u64 giv                : 1;
+	__u64 gint_tbl_len       : 4;
+	__u64 reserved6          : 1;
+	__u64 gint_tbl           : 46;
+	__u64 reserved7          : 2;
+	__u64 gpm                : 2;
+	__u64 reserved8          : 3;
+	__u64 hpt_mode           : 1;
+	__u64 reserved9          : 4;
+	__u32 asid               : 12;
+	__u32 reserved10         : 3;
+	__u32 viommu_en          : 1;
+	__u32 guest_device_id    : 16;
+	__u32 guest_id           : 15;
+	__u32 guest_id_mbo       : 1;
+	__u32 reserved11         : 1;
+	__u32 vmpl               : 2;
+	__u32 reserved12         : 3;
+	__u32 attrv              : 1;
+	__u32 reserved13         : 1;
+	__u32 sa                 : 8;
+	__u8 ide_stream_id[8];
+	__u32 vtom_en            : 1;
+	__u32 vtom               : 31;
+	__u32 rp_id              : 5;
+	__u32 reserved14         : 27;
+	__u8  reserved15[0x40-0x30];
+} __packed;
+
+struct tio_msg_sdte_write_req {
+	__u16 guest_device_id;
+	__u8 reserved[14];
+	struct sdte sdte;
+} __packed;
+
+#define SDTE_WRITE_SUCCESS		0
+#define SDTE_WRITE_INVALID_TDI		1
+#define SDTE_WRITE_TDI_NOT_BOUND	2
+#define SDTE_WRITE_RESERVED		3
+
+struct tio_msg_sdte_write_rsp {
+	__u16 guest_device_id;
+	__u16 status; /* SDTE_WRITE_xxx */
+	__u8 reserved[12];
+} __packed;
+
+static int tio_tdi_sdte_write(struct tsm_tdi *tdi, struct snp_guest_dev *snp_dev, bool invalidate)
+{
+	struct snp_guest_crypto *crypto = snp_dev->crypto;
+	size_t resp_len = sizeof(struct tio_msg_sdte_write_rsp) + crypto->a_len;
+	struct tio_msg_sdte_write_rsp *rsp = kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_sdte_write_req req = {
+		.guest_device_id = pci_dev_id(tdi->pdev),
+		.sdte.vmpl = 0,
+		.sdte.vtom = tsm_vtom,
+		.sdte.vtom_en = 1,
+		.sdte.iw = 1,
+		.sdte.ir = 1,
+		.sdte.v = 1,
+	};
+	u64 fw_err = 0;
+	u64 bdfn = pci_dev_id(tdi->pdev);
+	int rc;
+
+	BUILD_BUG_ON(sizeof(struct sdte) * 8 != 512);
+
+	if (invalidate)
+		memset(&req, 0, sizeof(req));
+
+	pci_notice(tdi->pdev, "SDTE write vTOM=%lx", (unsigned long) req.sdte.vtom << 21);
+
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = handle_tio_guest_request(snp_dev, TIO_MSG_SDTE_WRITE_REQ,
+			       &req, sizeof(req), rsp, resp_len,
+			       NULL, NULL, &bdfn, NULL, &fw_err);
+	if (rc) {
+		pci_err(tdi->pdev, "SDTE write failed with 0x%llx\n", fw_err);
+		goto free_exit;
+	}
+
+free_exit:
+	/* The response buffer contains the sensitive data, explicitly clear it. */
+	memzero_explicit(&rsp, sizeof(resp_len));
+	kfree(rsp);
+	return rc;
+}
+
+static int sev_guest_tdi_status(struct tsm_tdi *tdi, void *private_data, struct tsm_tdi_status *ts)
+{
+	struct snp_guest_dev *snp_dev = private_data;
+
+	return tio_tdi_status(tdi, snp_dev, ts);
+}
+
+static int sev_guest_tdi_validate(struct tsm_tdi *tdi, bool invalidate, void *private_data)
+{
+	struct snp_guest_dev *snp_dev = private_data;
+	struct tsm_tdi_status ts = { 0 };
+	int ret;
+
+	if (!tdi->report) {
+		ret = tio_tdi_status(tdi, snp_dev, &ts);
+
+		if (ret || !tdi->report) {
+			pci_err(tdi->pdev, "No report available, ret=%d", ret);
+			if (!ret && tdi->report)
+				ret = -EIO;
+			return ret;
+		}
+
+		if (ts.state != TDISP_STATE_RUN) {
+			pci_err(tdi->pdev, "Not in RUN state, state=%d instead", ts.state);
+			return -EIO;
+		}
+	}
+
+	ret = tio_tdi_sdte_write(tdi, snp_dev, invalidate);
+	if (ret)
+		return ret;
+
+	ret = tio_tdi_mmio_validate(tdi, snp_dev, invalidate);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+struct tsm_ops sev_guest_tsm_ops = {
+	.tdi_validate = sev_guest_tdi_validate,
+	.tdi_status = sev_guest_tdi_status,
+};
+
+void sev_guest_tsm_set_ops(bool set, struct snp_guest_dev *snp_dev)
+{
+	if (set)
+		tsm_set_ops(&sev_guest_tsm_ops, snp_dev);
+	else
+		tsm_set_ops(NULL, NULL);
+}
-- 
2.45.2


