Return-Path: <kvm+bounces-20279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8896B9126E7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 060601F22FA8
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8692FC148;
	Fri, 21 Jun 2024 13:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0v/eFTef"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B695B65F;
	Fri, 21 Jun 2024 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718977460; cv=fail; b=DP4lYUvOq9zA7VByVk1PWmE1Mf4L+VOAsoQM8L4d2r9fiD7fSOcyVziCKmx5GAXrcem0Fw226ra2zm/iK1DrRbQjIkc+QR5YK3GD451JB38LtsPEGwcDaOfan3WA8WeNhYhanAYLaTsn0KmR6ryZAIUl80iJywPl2vNucpxbm6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718977460; c=relaxed/simple;
	bh=5/QuOL/mBoBOl0NYuu5ig1BADCeZvGxFYPefrhAcYnM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RVScHObSLOxxyjKNYAS1VVvi4IggA1ybwW5bkk6UsOq7nJ0QCh9g1AoZBN/Gt5Dx1B1okPou7Ayq5gXbYu1w3Z4LZASrj2WRGUIieN9cQ1gYHTUO6Yh3oOBCdRyYVuyzMsbiFwS4f8NZgTqP+AbjrveYltea/4TeM72k1ma8Iak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0v/eFTef; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSU3hRqm7Z6LzakdJl6qU2DzB5NjPC8AAMCVCRK/w961213MLjTqMQHvgxFJlpdhD2QgzUVd31H2N/fNZ/tPcU72r/ReeS5Yur5DrTTQQbSaTJhpv3V6LJTz+54BRRAA/XYAVOMZuPUXrSK1GeK/CV2MTIuE/EmcmhHO1j+Br+UyvuFkF2VI2oIPBEZIgwISpLHir2dfEMHehxad0BhBvtJ7cpHYoTBuWybFsVJwzm1lg1ZiKSCRshnETmAmIk8JnRjczbVCY22krjek7FbrToVGYBlgteCxVTJ50S8NkHEbLi9UINkvjMYedTWA7XOFLMAU9IFGH/en0mQtua/D4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKnujZWp1dTkcUSjKlzlK8Tf2E1xWTdnwbWuZJAxpxo=;
 b=Nkj+sgaToDdBoRXZN6f9BOCTQ5D69og6T5yG9cnCt+a1uKWtA92PJI4nhN5lFIFPWfFGJRpLXVYnS3KqviS4g/1Ytz2J02rqTpVProeL0pob3oeNGuneD3Mxn7rW/wZAJqe7+jzQrS0llLTL24L6F7nZFtitpeaA6Y5hA99bgSDAitlEkjMJB3f4qX/nxE8tJng2Y7mEgebDWG88boz8Y2ZKEsMm4Sn0nAKh1JZI3VJZo7wtoouyjuMMsSyL4qbKFnBXUPAJUCgcP1b9P5f4KffADzPEsvk6PEBj50HUB9S9hvAYQTMHvejgX6Kbd6bn/9YtUyt6/hGN9719CcPOYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKnujZWp1dTkcUSjKlzlK8Tf2E1xWTdnwbWuZJAxpxo=;
 b=0v/eFTef0+KA7FHoKg5QuIFCt5s7a383DMz/lwfd2LzxlSNIq7tZ2zkY4pRNampK4NMetWmmUHBX5La5jIBGKEmzX6joBA7lUHazBqU8RCOUB8lCo3BNhk8hKve8mKOyv/KiqEG+7ccpuHInD87DH3hsprwCYwSVYLaYzZt/oXg=
Received: from CYZPR02CA0004.namprd02.prod.outlook.com (2603:10b6:930:a1::23)
 by SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 21 Jun
 2024 13:44:16 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:930:a1:cafe::2f) by CYZPR02CA0004.outlook.office365.com
 (2603:10b6:930:a1::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 13:44:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 13:44:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 08:44:15 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v1 2/5] x86/sev: Move sev_guest.h into common SEV header
Date: Fri, 21 Jun 2024 08:40:38 -0500
Message-ID: <20240621134041.3170480-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240621134041.3170480-1-michael.roth@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|SA0PR12MB4399:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cb1b27c-1760-4c93-53ca-08dc91f83e63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|7416011|36860700010|376011|1800799021|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b6wpLyayd3ST3Q4sKg8LsU/wXmka/GyhQiCML5Ocp57lCGa++24Ypt6TD47o?=
 =?us-ascii?Q?bG7a/d3s9I3E4Z7MHAgSgzoSdoGIlNqQe+FGy6alsx5FsOcZqtTzEMUXxT+U?=
 =?us-ascii?Q?V+93ib54QdBWRIV6uSjNCNsxmYGRCOXITPCBa9ZeMDrW5a5/An0Ew7YJ3zGY?=
 =?us-ascii?Q?zg5iqjDTWZQTUdhlNk4YCeLZ8FuYP4ZkaIj7ocSghm/slzUoeeOhgW4YrdEc?=
 =?us-ascii?Q?1o+CHaxsVrMFbS3EdLuzFVSv4dh/pW6EqQ02YwfDFWRHGbnzan46G1WhN/sf?=
 =?us-ascii?Q?3kUSPgzDXCfvww2JOtyv4PktDLWCEd3whe/kiPdnohloklHNT9cJrzWsd9N6?=
 =?us-ascii?Q?kaSElkOf26UNemHf/G0JIVZMT4pD9Ha6wD+kAg+iwnwZhdLt7C9BItjmh0hN?=
 =?us-ascii?Q?7ePOzPVokzV8FXry7V30Dyv2w8WWQxxxDfwYTyyOJE567SnBhh8pkXB+78aR?=
 =?us-ascii?Q?js+MDW2tKyZvxd91vQH823fLDEyFUlALQKx9O6FYTlijVrv3sNj4FZK7tzwe?=
 =?us-ascii?Q?Vw4iT45prWEXWVt2Ibfs2Q2/RJMk9TrGmrAkV5LuZULlJM02xaBDk8eDBM70?=
 =?us-ascii?Q?JNLRUbGaztW53RlhnmctIxC0bOe3dH5uT481rLnEodnSMrHUpl4VJtqfnx8r?=
 =?us-ascii?Q?HscnCnqrAQ69nAeapIX5/E5VYikF21XVtLkGzdSe/y6f09bMO7ruLEdmgpru?=
 =?us-ascii?Q?OkIFvI4PYPzrLbFDkeG2723/9vehd+t5MjkPLrxY+aHMI99VgyMqoJE8i2lW?=
 =?us-ascii?Q?uJuuBFKjEdB6A+ucGCU37nFKp1v3IhP+CF+a9NsreW/b6UARZliQkts+h6Wj?=
 =?us-ascii?Q?kbBvidsHDwHC/nSpxe3nqDNvHesWvqlvPeyvO6frdi+Faobh88XB9xNPgXVX?=
 =?us-ascii?Q?8t2ojceqJYvWw7n9P13ryKJ6HA2ixPc325xTKZ/7OsMn/YF+MNlnGMSBkVsO?=
 =?us-ascii?Q?tf0SzN8TfG6GVZyk7wkmhQD4r9xDMp/9vqODaAuUehD8ODEDGhV/ytUoAS2m?=
 =?us-ascii?Q?Cqsc6VmaL+W98KvaY9R+Dxif27+X/Fcoh2ptLu1bLHgxvGT9VHT/oPaP18EM?=
 =?us-ascii?Q?B8NSU/D4I7li6UccDWrzSJgv472qZAJttMSTe852RKmN9lWhfsq6JBODDjna?=
 =?us-ascii?Q?4Q1l191a9mBkQoZzRlB+GHdrVJ9WgSterp7tf7Q6/37WrcuSW4dARoOQPy8Z?=
 =?us-ascii?Q?J/yLBbIPpRiLc/oT7wBBiyHWFB+WytiQzOdyx6cc5n4g++3ENvYTmLnVeEZX?=
 =?us-ascii?Q?Z9dAiiBEKsIiDu837MTv6sWYGZ0wlb1de21nYV54hMISX/sjAEp2I/SrF198?=
 =?us-ascii?Q?Devh2ewlZro5caN5BBtMfYW95p6HsqLmXf+MfNsE0S8Up13qhDPot/qRabQp?=
 =?us-ascii?Q?DfoeZ/U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(7416011)(36860700010)(376011)(1800799021)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 13:44:16.3131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb1b27c-1760-4c93-53ca-08dc91f83e63
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399

sev_guest.h currently contains various definitions relating to the
format of SNP_GUEST_REQUEST commands to SNP firmware. Currently only the
sev-guest driver makes use of them, but when the KVM side of this is
implemented there's a need to parse the SNP_GUEST_REQUEST header to
determine whether additional information needs to be provided to the
guest. Prepare for this by moving those definitions to a common header
that's shared by host/guest code so that KVM can also make use of them.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev.h              | 48 +++++++++++++++++++
 drivers/virt/coco/sev-guest/sev-guest.c |  2 -
 drivers/virt/coco/sev-guest/sev-guest.h | 63 -------------------------
 3 files changed, 48 insertions(+), 65 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 1936f37e3371..72f9ba3a2fee 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -119,6 +119,54 @@ struct snp_req_data {
 	unsigned int data_npages;
 };
 
+#define MAX_AUTHTAG_LEN		32
+
+/* See SNP spec SNP_GUEST_REQUEST section for the structure */
+enum msg_type {
+	SNP_MSG_TYPE_INVALID = 0,
+	SNP_MSG_CPUID_REQ,
+	SNP_MSG_CPUID_RSP,
+	SNP_MSG_KEY_REQ,
+	SNP_MSG_KEY_RSP,
+	SNP_MSG_REPORT_REQ,
+	SNP_MSG_REPORT_RSP,
+	SNP_MSG_EXPORT_REQ,
+	SNP_MSG_EXPORT_RSP,
+	SNP_MSG_IMPORT_REQ,
+	SNP_MSG_IMPORT_RSP,
+	SNP_MSG_ABSORB_REQ,
+	SNP_MSG_ABSORB_RSP,
+	SNP_MSG_VMRK_REQ,
+	SNP_MSG_VMRK_RSP,
+
+	SNP_MSG_TYPE_MAX
+};
+
+enum aead_algo {
+	SNP_AEAD_INVALID,
+	SNP_AEAD_AES_256_GCM,
+};
+
+struct snp_guest_msg_hdr {
+	u8 authtag[MAX_AUTHTAG_LEN];
+	u64 msg_seqno;
+	u8 rsvd1[8];
+	u8 algo;
+	u8 hdr_version;
+	u16 hdr_sz;
+	u8 msg_type;
+	u8 msg_version;
+	u16 msg_sz;
+	u32 rsvd2;
+	u8 msg_vmpck;
+	u8 rsvd3[35];
+} __packed;
+
+struct snp_guest_msg {
+	struct snp_guest_msg_hdr hdr;
+	u8 payload[4000];
+} __packed;
+
 struct sev_guest_platform_data {
 	u64 secrets_gpa;
 };
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 654290a8e1ba..f0ea26f18cbf 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -29,8 +29,6 @@
 #include <asm/svm.h>
 #include <asm/sev.h>
 
-#include "sev-guest.h"
-
 #define DEVICE_NAME	"sev-guest"
 #define AAD_LEN		48
 #define MSG_HDR_VER	1
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
deleted file mode 100644
index 21bda26fdb95..000000000000
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2021 Advanced Micro Devices, Inc.
- *
- * Author: Brijesh Singh <brijesh.singh@amd.com>
- *
- * SEV-SNP API spec is available at https://developer.amd.com/sev
- */
-
-#ifndef __VIRT_SEVGUEST_H__
-#define __VIRT_SEVGUEST_H__
-
-#include <linux/types.h>
-
-#define MAX_AUTHTAG_LEN		32
-
-/* See SNP spec SNP_GUEST_REQUEST section for the structure */
-enum msg_type {
-	SNP_MSG_TYPE_INVALID = 0,
-	SNP_MSG_CPUID_REQ,
-	SNP_MSG_CPUID_RSP,
-	SNP_MSG_KEY_REQ,
-	SNP_MSG_KEY_RSP,
-	SNP_MSG_REPORT_REQ,
-	SNP_MSG_REPORT_RSP,
-	SNP_MSG_EXPORT_REQ,
-	SNP_MSG_EXPORT_RSP,
-	SNP_MSG_IMPORT_REQ,
-	SNP_MSG_IMPORT_RSP,
-	SNP_MSG_ABSORB_REQ,
-	SNP_MSG_ABSORB_RSP,
-	SNP_MSG_VMRK_REQ,
-	SNP_MSG_VMRK_RSP,
-
-	SNP_MSG_TYPE_MAX
-};
-
-enum aead_algo {
-	SNP_AEAD_INVALID,
-	SNP_AEAD_AES_256_GCM,
-};
-
-struct snp_guest_msg_hdr {
-	u8 authtag[MAX_AUTHTAG_LEN];
-	u64 msg_seqno;
-	u8 rsvd1[8];
-	u8 algo;
-	u8 hdr_version;
-	u16 hdr_sz;
-	u8 msg_type;
-	u8 msg_version;
-	u16 msg_sz;
-	u32 rsvd2;
-	u8 msg_vmpck;
-	u8 rsvd3[35];
-} __packed;
-
-struct snp_guest_msg {
-	struct snp_guest_msg_hdr hdr;
-	u8 payload[4000];
-} __packed;
-
-#endif /* __VIRT_SEVGUEST_H__ */
-- 
2.25.1


