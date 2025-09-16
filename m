Return-Path: <kvm+bounces-57792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 899E9B5A3F9
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 561827ACC4B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40092F9DA0;
	Tue, 16 Sep 2025 21:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XcYc0GZg"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010033.outbound.protection.outlook.com [52.101.85.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE482D9EE5;
	Tue, 16 Sep 2025 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758058212; cv=fail; b=GWpvZ8IM4h7hARF4/f6UegZ/h0GHD2E8NOnqOltexVZ3bToXznQEsgZ7rlf88x3e1wFChydOYsZ1QqBAxkp9qMI449bVSzxOLsCgJPjG77AepxJSE0CyACo+cpyMGp1zhNj4/6luFrXvipUOzU8i8u3EfpsPjQUSNf7zznQoh4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758058212; c=relaxed/simple;
	bh=lNyyz04Ufa9j+C4/833nGef7Uag5TmZ++p6TYVWrp+U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZ+ozqwscFWnInmuraShND5xs6OnXpmzmvGPINow3sieQr+Fo3mqc67NPMAi19772PfiZJ241sUumh4gQ3Hp4PDy+8cCXddCuBd5Aq6U2g09XppRWf7Qw/5mo392azGeQGyrTWaXpK5TSQiTvd6ENknYRXF9fDw4UVRkjidHFBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XcYc0GZg; arc=fail smtp.client-ip=52.101.85.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k8Pqg/vywzPP6aXyudyM6HFyrq651+VI/KHHCsoALGIWjOLAYyLV8oIZkbKLx5AYJhkXaiZDwt3TXzYbpoDTaAzKDGPr7ZgYk/Fu5pTIEzP4ZJiuld3jnxg8ZcVqnpOf6tSrqG6L/+GwrVD6EP6Jn7KOPI0e1atrU4iHz1f4HL514oF948ztscxp/KglZPZJ/KRW0wS0P8F3ilooYaCV4zYZem9V00rLwyoIzQC6X4vqBxe03xkELTdiG1gh4z6NHT3rlJiuzryR3g58NKmGF02+MN6NaRIp8Zn6UuuTRmUHoRo0zGxJhKEbfvXrfe49BhJAOQTWnYwPhxLVPqk0tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmUgR1pPsMfZiYy3i5aSspY4qGBjHaZfS08qjKH584I=;
 b=joeXZKCcIFRf+O3G1n2/bXemrH4RFztO4/wqoGWnYaxCAdcjoCe5GUDm2cbvnUXVYdlSZXNa2lMMUS4gdwRHGhwWWTCwfwt/m6T5CHw1jp+xmWq7RdlfbAh1matky+G4cnkX9ZY4jWiMm3mhxb+vZwTLUSiAlQFZbp5zvk8izi77exN7YMbrvws0ioFvkyKO9KUiCmnRBewFJ9IZIwyx3uRWgEkz1U+kGIm6JqZSf9shbifbpaNNrsiiyTUs/3MGQ4pBTTbsbvI/G7ixZoqxjV6Vzu7Og68F0LUpnRCU2+cDMJlTqMMhRZXq1GWpaVT6YQrN1uUo+Q8mqnG95BVK0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmUgR1pPsMfZiYy3i5aSspY4qGBjHaZfS08qjKH584I=;
 b=XcYc0GZgtkZbYJAJ6Ky4AaUfwtb/J/ENwbc2A9/Z/ZOrlV48StCg12KvSHJ9py1dxI1sVINPtRRsvPv36NxJD89uBkKdOd8t9qqDyqoyejmPOoNcc2poONswBuHL/JN1lTcaA0wjSlHXv+ovBAeQgceHdqo1E/6qXo5Kq8joHqU=
Received: from SA0PR11CA0092.namprd11.prod.outlook.com (2603:10b6:806:d1::7)
 by CH3PR12MB8209.namprd12.prod.outlook.com (2603:10b6:610:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 21:30:02 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:806:d1:cafe::df) by SA0PR11CA0092.outlook.office365.com
 (2603:10b6:806:d1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Tue,
 16 Sep 2025 21:30:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 16 Sep 2025 21:30:02 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Sep
 2025 14:29:58 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v6 3/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Tue, 16 Sep 2025 21:29:49 +0000
Message-ID: <c07e43d87fc312b7694aeadfa357033400954a1f.1758057691.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1758057691.git.ashish.kalra@amd.com>
References: <cover.1758057691.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|CH3PR12MB8209:EE_
X-MS-Office365-Filtering-Correlation-Id: 400c5aa9-2b52-4187-4696-08ddf5683201
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FXMdoqrzVmufVEPI7OgzaLoPdHMZ/J0Exi6GboNOeK241Z2k/EntR1yWN83V?=
 =?us-ascii?Q?yAh4rweTQgJDKLZ32C1654mNuPhd4d6PylHWaAlEr5hiNWGvS5xva+8QEI1+?=
 =?us-ascii?Q?mU86trYluLrTve6tqtcHWW2FnKj2loO5nOzXxgDJwWHNAykXdiWxCqzXgD/t?=
 =?us-ascii?Q?a7kYlmrk92a8uzgZHpcZ17bmwfEk+bTJEW9mgFIbLFvSd1CKqEAc0POq6BUw?=
 =?us-ascii?Q?Vf31Ivyzi/FmkOjoLau5uWe8TkHfKsTGCqzOpymuPbIz6craFs8EoiDwKM+O?=
 =?us-ascii?Q?9TDfLcL0sR69aJb7LGJ/5vZo2PywjoLedxA4hDl+MHJldrbUDevVjFFuk47k?=
 =?us-ascii?Q?1sECYPIjDZNZB2fk63oWZHhtPvf8cTGVlKEeU4NNaKiC9LCvTSxjz1Lc86xq?=
 =?us-ascii?Q?Axqr/FR9zYn/Jp9j22Cam0bbp3HmsCYizTKCxN+7FZboa5nr6PYQTD+8I9TE?=
 =?us-ascii?Q?xWkNvGk2H3hBIXy7Mdbh+UCH1jQ7VsVutoNhNDFYqt1zX+q/qFYnsoAaXYhd?=
 =?us-ascii?Q?3bLpnDiJElFi2M712HDhNTGoDo8ekVtSeiaFHyLbWrV/TzaGUf74i4DxruAs?=
 =?us-ascii?Q?3mEsFpBUnbYudJIaqBOp8OtLs50kR5DAJljWr7zafn7v5tniak3kibK6QyVs?=
 =?us-ascii?Q?vV5803Wv1k4R62wQ3LqCTtXazqn0sKEgBbPTBMRVdggXID+EqvEUPkrGLCw5?=
 =?us-ascii?Q?6BSI/Bnp63MtZYKOEql4jS9vqSaAb3rkS4p6imnLZXaex1WhXZrQ43zP/3nA?=
 =?us-ascii?Q?LUaInvqUTJc9wD8W85YAaB+OGEtBM/LfDc4rCmGLFJVHQOA/ngT40vXd6bbJ?=
 =?us-ascii?Q?xGlCRDql7QBGw+mZ+zTJkythnw9VCz9SeKPw+SFvvBfKWvyX01rYZnjw1b6F?=
 =?us-ascii?Q?996AYry6PPlw5EY1q1d/hvBh5W8cxzi/7bMFR+nJaodCvngSCbk5wzxo3xBZ?=
 =?us-ascii?Q?RY9iIEaJo4wMS122PTgynozKTUC6HQVrg1QS5l1Efa51kxFlVazKwAey/Sme?=
 =?us-ascii?Q?HWHn4k3jc+b0M/yn41JKAlO2IGRvjUo8gN7p3mk3QGKjrC7O8F+2AOJfIMnY?=
 =?us-ascii?Q?v7KLGseXN4D07bjQIXMX7tT4bdcxlZNaneuQFjG5o7pPkz+7jaRBvyx3OE9k?=
 =?us-ascii?Q?KbF24XLbh6TN2N71FojoREhq04ISOzSJ97SsycanQ+B23i7SKY5vqG7K77dH?=
 =?us-ascii?Q?qIF6iEs6id0aVcTfW3W3diUbtgiLuTq+vv1F9so6EA5N2vwbHbKqWPe/O9Fw?=
 =?us-ascii?Q?7bwWxIVFsQWmytU+f35rDarFzWs2FrYuup0ST1cF2xVFdABLJhBDRfAtBKqb?=
 =?us-ascii?Q?Dt8YNTbVGgo/HIE/StTHS+mRvGaYLs4eYLHmyLzabqupzcQ4FBe7R6BvQd4t?=
 =?us-ascii?Q?0jfDhi+qfiIZdd9Ua2W1C1zwLTRe/VRQHbJdbaMIMIXhdYOErxLLpt8rkW5N?=
 =?us-ascii?Q?TuksR3FfIdDIw3uPgx09nQ/QESZyVG8E6l5PqqaZE7EH3w+Z5ai/x//6n3UE?=
 =?us-ascii?Q?iiLdeqKtQVzu5LViotlO2lAXa2cFWyuI7VYxSAO1aRGXgojD3e81BKgZzQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 21:30:02.0132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 400c5aa9-2b52-4187-4696-08ddf5683201
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8209

From: Ashish Kalra <ashish.kalra@amd.com>

AMD Seamless Firmware Servicing (SFS) is a secure method to allow
non-persistent updates to running firmware and settings without
requiring BIOS reflash and/or system reset.

SFS does not address anything that runs on the x86 processors and
it can be used to update ASP firmware, modules, register settings
and update firmware for other microprocessors like TMPM, etc.

SFS driver support adds ioctl support to communicate the SFS
commands to the ASP/PSP by using the TEE mailbox interface.

The Seamless Firmware Servicing (SFS) driver is added as a
PSP sub-device.

For detailed information, please look at the SFS specifications:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sfs.c            | 311 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  47 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 7 files changed, 476 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 394484929dae..a9626b30044a 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -13,7 +13,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
                                    tee-dev.o \
                                    platform-access.o \
                                    dbc.o \
-                                   hsti.o
+                                   hsti.o \
+                                   sfs.o
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 1c5a7189631e..9e21da0e298a 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -17,6 +17,7 @@
 #include "psp-dev.h"
 #include "sev-dev.h"
 #include "tee-dev.h"
+#include "sfs.h"
 #include "platform-access.h"
 #include "dbc.h"
 #include "hsti.h"
@@ -182,6 +183,17 @@ static int psp_check_tee_support(struct psp_device *psp)
 	return 0;
 }
 
+static int psp_check_sfs_support(struct psp_device *psp)
+{
+	/* Check if device supports SFS feature */
+	if (!psp->capability.sfs) {
+		dev_dbg(psp->dev, "psp does not support SFS\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int psp_init(struct psp_device *psp)
 {
 	int ret;
@@ -198,6 +210,12 @@ static int psp_init(struct psp_device *psp)
 			return ret;
 	}
 
+	if (!psp_check_sfs_support(psp)) {
+		ret = sfs_dev_init(psp);
+		if (ret)
+			return ret;
+	}
+
 	if (psp->vdata->platform_access) {
 		ret = platform_access_dev_init(psp);
 		if (ret)
@@ -302,6 +320,8 @@ void psp_dev_destroy(struct sp_device *sp)
 
 	tee_dev_destroy(psp);
 
+	sfs_dev_destroy(psp);
+
 	dbc_dev_destroy(psp);
 
 	platform_access_dev_destroy(psp);
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index e43ce87ede76..268c83f298cb 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -32,7 +32,8 @@ union psp_cap_register {
 		unsigned int sev			:1,
 			     tee			:1,
 			     dbc_thru_ext		:1,
-			     rsvd1			:4,
+			     sfs			:1,
+			     rsvd1			:3,
 			     security_reporting		:1,
 			     fused_part			:1,
 			     rsvd2			:1,
@@ -68,6 +69,7 @@ struct psp_device {
 	void *tee_data;
 	void *platform_access_data;
 	void *dbc_data;
+	void *sfs_data;
 
 	union psp_cap_register capability;
 };
@@ -118,12 +120,16 @@ struct psp_ext_request {
  * @PSP_SUB_CMD_DBC_SET_UID:		Set UID for DBC
  * @PSP_SUB_CMD_DBC_GET_PARAMETER:	Get parameter from DBC
  * @PSP_SUB_CMD_DBC_SET_PARAMETER:	Set parameter for DBC
+ * @PSP_SUB_CMD_SFS_GET_FW_VERS:	Get firmware versions for ASP and other MP
+ * @PSP_SUB_CMD_SFS_UPDATE:		Command to load, verify and execute SFS package
  */
 enum psp_sub_cmd {
 	PSP_SUB_CMD_DBC_GET_NONCE	= PSP_DYNAMIC_BOOST_GET_NONCE,
 	PSP_SUB_CMD_DBC_SET_UID		= PSP_DYNAMIC_BOOST_SET_UID,
 	PSP_SUB_CMD_DBC_GET_PARAMETER	= PSP_DYNAMIC_BOOST_GET_PARAMETER,
 	PSP_SUB_CMD_DBC_SET_PARAMETER	= PSP_DYNAMIC_BOOST_SET_PARAMETER,
+	PSP_SUB_CMD_SFS_GET_FW_VERS	= PSP_SFS_GET_FW_VERSIONS,
+	PSP_SUB_CMD_SFS_UPDATE		= PSP_SFS_UPDATE,
 };
 
 int psp_extended_mailbox_cmd(struct psp_device *psp, unsigned int timeout_msecs,
diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
new file mode 100644
index 000000000000..2f4beaafe7ec
--- /dev/null
+++ b/drivers/crypto/ccp/sfs.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure Processor Seamless Firmware Servicing support.
+ *
+ * Copyright (C) 2025 Advanced Micro Devices, Inc.
+ *
+ * Author: Ashish Kalra <ashish.kalra@amd.com>
+ */
+
+#include <linux/firmware.h>
+
+#include "sfs.h"
+#include "sev-dev.h"
+
+#define SFS_DEFAULT_TIMEOUT		(10 * MSEC_PER_SEC)
+#define SFS_MAX_PAYLOAD_SIZE		(2 * 1024 * 1024)
+#define SFS_NUM_2MB_PAGES_CMDBUF	(SFS_MAX_PAYLOAD_SIZE / PMD_SIZE)
+#define SFS_NUM_PAGES_CMDBUF		(SFS_MAX_PAYLOAD_SIZE / PAGE_SIZE)
+
+static DEFINE_MUTEX(sfs_ioctl_mutex);
+
+static struct sfs_misc_dev *misc_dev;
+
+static int send_sfs_cmd(struct sfs_device *sfs_dev, int msg)
+{
+	int ret;
+
+	sfs_dev->command_buf->hdr.status = 0;
+	sfs_dev->command_buf->hdr.sub_cmd_id = msg;
+
+	ret = psp_extended_mailbox_cmd(sfs_dev->psp,
+				       SFS_DEFAULT_TIMEOUT,
+				       (struct psp_ext_request *)sfs_dev->command_buf);
+	if (ret == -EIO) {
+		dev_dbg(sfs_dev->dev,
+			 "msg 0x%x failed with PSP error: 0x%x, extended status: 0x%x\n",
+			 msg, sfs_dev->command_buf->hdr.status,
+			 *(u32 *)sfs_dev->command_buf->buf);
+	}
+
+	return ret;
+}
+
+static int send_sfs_get_fw_versions(struct sfs_device *sfs_dev)
+{
+	/*
+	 * SFS_GET_FW_VERSIONS command needs the output buffer to be
+	 * initialized to 0xC7 in every byte.
+	 */
+	memset(sfs_dev->command_buf->sfs_buffer, 0xc7, PAGE_SIZE);
+	sfs_dev->command_buf->hdr.payload_size = 2 * PAGE_SIZE;
+
+	return send_sfs_cmd(sfs_dev, PSP_SFS_GET_FW_VERSIONS);
+}
+
+static int send_sfs_update_package(struct sfs_device *sfs_dev, const char *payload_name)
+{
+	char payload_path[PAYLOAD_NAME_SIZE + sizeof("amd/")];
+	const struct firmware *firmware;
+	unsigned long package_size;
+	int ret;
+
+	/* Sanitize userspace provided payload name */
+	if (!strnchr(payload_name, PAYLOAD_NAME_SIZE, '\0'))
+		return -EINVAL;
+
+	snprintf(payload_path, sizeof(payload_path), "amd/%s", payload_name);
+
+	ret = firmware_request_nowarn(&firmware, payload_path, sfs_dev->dev);
+	if (ret < 0) {
+		dev_warn_ratelimited(sfs_dev->dev, "firmware request failed for %s (%d)\n",
+				     payload_path, ret);
+		return -ENOENT;
+	}
+
+	/*
+	 * SFS Update Package command's input buffer contains TEE_EXT_CMD_BUFFER
+	 * followed by the Update Package and it should be 64KB aligned.
+	 */
+	package_size = ALIGN(firmware->size + PAGE_SIZE, 0x10000U);
+
+	/*
+	 * SFS command buffer is a pre-allocated 2MB buffer, fail update package
+	 * if SFS payload is larger than the pre-allocated command buffer.
+	 */
+	if (package_size > SFS_MAX_PAYLOAD_SIZE) {
+		dev_warn_ratelimited(sfs_dev->dev,
+			 "SFS payload size %ld larger than maximum supported payload size of %u\n",
+			 package_size, SFS_MAX_PAYLOAD_SIZE);
+		release_firmware(firmware);
+		return -E2BIG;
+	}
+
+	/*
+	 * Copy firmware data to a HV_Fixed memory region.
+	 */
+	memcpy(sfs_dev->command_buf->sfs_buffer, firmware->data, firmware->size);
+	sfs_dev->command_buf->hdr.payload_size = package_size;
+
+	release_firmware(firmware);
+
+	return send_sfs_cmd(sfs_dev, PSP_SFS_UPDATE);
+}
+
+static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct sfs_user_get_fw_versions __user *sfs_get_fw_versions;
+	struct sfs_user_update_package __user *sfs_update_package;
+	struct psp_device *psp_master = psp_get_master_device();
+	char payload_name[PAYLOAD_NAME_SIZE];
+	struct sfs_device *sfs_dev;
+	int ret = 0;
+
+	if (!psp_master || !psp_master->sfs_data)
+		return -ENODEV;
+
+	sfs_dev = psp_master->sfs_data;
+
+	guard(mutex)(&sfs_ioctl_mutex);
+
+	switch (cmd) {
+	case SFSIOCFWVERS:
+		dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
+
+		sfs_get_fw_versions = (struct sfs_user_get_fw_versions __user *)arg;
+
+		ret = send_sfs_get_fw_versions(sfs_dev);
+		if (ret && ret != -EIO)
+			return ret;
+
+		/*
+		 * Return SFS status and extended status back to userspace
+		 * if PSP status indicated success or command error.
+		 */
+		if (copy_to_user(&sfs_get_fw_versions->blob, sfs_dev->command_buf->sfs_buffer,
+				 PAGE_SIZE))
+			return -EFAULT;
+		if (copy_to_user(&sfs_get_fw_versions->sfs_status,
+				 &sfs_dev->command_buf->hdr.status,
+				 sizeof(sfs_get_fw_versions->sfs_status)))
+			return -EFAULT;
+		if (copy_to_user(&sfs_get_fw_versions->sfs_extended_status,
+				 &sfs_dev->command_buf->buf,
+				 sizeof(sfs_get_fw_versions->sfs_extended_status)))
+			return -EFAULT;
+		break;
+	case SFSIOCUPDATEPKG:
+		dev_dbg(sfs_dev->dev, "in SFSIOCUPDATEPKG\n");
+
+		sfs_update_package = (struct sfs_user_update_package __user *)arg;
+
+		if (copy_from_user(payload_name, sfs_update_package->payload_name,
+				   PAYLOAD_NAME_SIZE))
+			return -EFAULT;
+
+		ret = send_sfs_update_package(sfs_dev, payload_name);
+		if (ret && ret != -EIO)
+			return ret;
+
+		/*
+		 * Return SFS status and extended status back to userspace
+		 * if PSP status indicated success or command error.
+		 */
+		if (copy_to_user(&sfs_update_package->sfs_status,
+				 &sfs_dev->command_buf->hdr.status,
+				 sizeof(sfs_update_package->sfs_status)))
+			return -EFAULT;
+		if (copy_to_user(&sfs_update_package->sfs_extended_status,
+				 &sfs_dev->command_buf->buf,
+				 sizeof(sfs_update_package->sfs_extended_status)))
+			return -EFAULT;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct file_operations sfs_fops = {
+	.owner	= THIS_MODULE,
+	.unlocked_ioctl = sfs_ioctl,
+};
+
+static void sfs_exit(struct kref *ref)
+{
+	misc_deregister(&misc_dev->misc);
+	kfree(misc_dev);
+	misc_dev = NULL;
+}
+
+void sfs_dev_destroy(struct psp_device *psp)
+{
+	struct sfs_device *sfs_dev = psp->sfs_data;
+
+	if (!sfs_dev)
+		return;
+
+	/*
+	 * Change SFS command buffer back to the default "Write-Back" type.
+	 */
+	set_memory_wb((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
+
+	snp_free_hv_fixed_pages(sfs_dev->page);
+
+	if (sfs_dev->misc)
+		kref_put(&misc_dev->refcount, sfs_exit);
+
+	psp->sfs_data = NULL;
+}
+
+/* Based on sev_misc_init() */
+static int sfs_misc_init(struct sfs_device *sfs)
+{
+	struct device *dev = sfs->dev;
+	int ret;
+
+	/*
+	 * SFS feature support can be detected on multiple devices but the SFS
+	 * FW commands must be issued on the master. During probe, we do not
+	 * know the master hence we create /dev/sfs on the first device probe.
+	 */
+	if (!misc_dev) {
+		struct miscdevice *misc;
+
+		misc_dev = kzalloc(sizeof(*misc_dev), GFP_KERNEL);
+		if (!misc_dev)
+			return -ENOMEM;
+
+		misc = &misc_dev->misc;
+		misc->minor = MISC_DYNAMIC_MINOR;
+		misc->name = "sfs";
+		misc->fops = &sfs_fops;
+		misc->mode = 0600;
+
+		ret = misc_register(misc);
+		if (ret)
+			return ret;
+
+		kref_init(&misc_dev->refcount);
+	} else {
+		kref_get(&misc_dev->refcount);
+	}
+
+	sfs->misc = misc_dev;
+	dev_dbg(dev, "registered SFS device\n");
+
+	return 0;
+}
+
+int sfs_dev_init(struct psp_device *psp)
+{
+	struct device *dev = psp->dev;
+	struct sfs_device *sfs_dev;
+	struct page *page;
+	int ret = -ENOMEM;
+
+	sfs_dev = devm_kzalloc(dev, sizeof(*sfs_dev), GFP_KERNEL);
+	if (!sfs_dev)
+		return -ENOMEM;
+
+	/*
+	 * Pre-allocate 2MB command buffer for all SFS commands using
+	 * SNP HV_Fixed page allocator which also transitions the
+	 * SFS command buffer to HV_Fixed page state if SNP is enabled.
+	 */
+	page = snp_alloc_hv_fixed_pages(SFS_NUM_2MB_PAGES_CMDBUF);
+	if (!page) {
+		dev_dbg(dev, "Command Buffer HV-Fixed page allocation failed\n");
+		goto cleanup_dev;
+	}
+	sfs_dev->page = page;
+	sfs_dev->command_buf = page_address(page);
+
+	dev_dbg(dev, "Command buffer 0x%px to be marked as HV_Fixed\n", sfs_dev->command_buf);
+
+	/*
+	 * SFS command buffer must be mapped as non-cacheable.
+	 */
+	ret = set_memory_uc((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
+	if (ret) {
+		dev_dbg(dev, "Set memory uc failed\n");
+		goto cleanup_cmd_buf;
+	}
+
+	dev_dbg(dev, "Command buffer 0x%px marked uncacheable\n", sfs_dev->command_buf);
+
+	psp->sfs_data = sfs_dev;
+	sfs_dev->dev = dev;
+	sfs_dev->psp = psp;
+
+	ret = sfs_misc_init(sfs_dev);
+	if (ret)
+		goto cleanup_mem_attr;
+
+	dev_notice(sfs_dev->dev, "SFS support is available\n");
+
+	return 0;
+
+cleanup_mem_attr:
+	set_memory_wb((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
+
+cleanup_cmd_buf:
+	snp_free_hv_fixed_pages(page);
+
+cleanup_dev:
+	psp->sfs_data = NULL;
+	devm_kfree(dev, sfs_dev);
+
+	return ret;
+}
diff --git a/drivers/crypto/ccp/sfs.h b/drivers/crypto/ccp/sfs.h
new file mode 100644
index 000000000000..97704c210efd
--- /dev/null
+++ b/drivers/crypto/ccp/sfs.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * AMD Platform Security Processor (PSP) Seamless Firmware (SFS) Support.
+ *
+ * Copyright (C) 2025 Advanced Micro Devices, Inc.
+ *
+ * Author: Ashish Kalra <ashish.kalra@amd.com>
+ */
+
+#ifndef __SFS_H__
+#define __SFS_H__
+
+#include <uapi/linux/psp-sfs.h>
+
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+#include <linux/psp-sev.h>
+#include <linux/psp-platform-access.h>
+#include <linux/set_memory.h>
+
+#include "psp-dev.h"
+
+struct sfs_misc_dev {
+	struct kref refcount;
+	struct miscdevice misc;
+};
+
+struct sfs_command {
+	struct psp_ext_req_buffer_hdr hdr;
+	u8 buf[PAGE_SIZE - sizeof(struct psp_ext_req_buffer_hdr)];
+	u8 sfs_buffer[];
+} __packed;
+
+struct sfs_device {
+	struct device *dev;
+	struct psp_device *psp;
+
+	struct page *page;
+	struct sfs_command *command_buf;
+
+	struct sfs_misc_dev *misc;
+};
+
+void sfs_dev_destroy(struct psp_device *psp);
+int sfs_dev_init(struct psp_device *psp);
+
+#endif /* __SFS_H__ */
diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
index 1504fb012c05..540abf7de048 100644
--- a/include/linux/psp-platform-access.h
+++ b/include/linux/psp-platform-access.h
@@ -7,6 +7,8 @@
 
 enum psp_platform_access_msg {
 	PSP_CMD_NONE			= 0x0,
+	PSP_SFS_GET_FW_VERSIONS,
+	PSP_SFS_UPDATE,
 	PSP_CMD_HSTI_QUERY		= 0x14,
 	PSP_I2C_REQ_BUS_CMD		= 0x64,
 	PSP_DYNAMIC_BOOST_GET_NONCE,
diff --git a/include/uapi/linux/psp-sfs.h b/include/uapi/linux/psp-sfs.h
new file mode 100644
index 000000000000..94e51670383c
--- /dev/null
+++ b/include/uapi/linux/psp-sfs.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Userspace interface for AMD Seamless Firmware Servicing (SFS)
+ *
+ * Copyright (C) 2025 Advanced Micro Devices, Inc.
+ *
+ * Author: Ashish Kalra <ashish.kalra@amd.com>
+ */
+
+#ifndef __PSP_SFS_USER_H__
+#define __PSP_SFS_USER_H__
+
+#include <linux/types.h>
+
+/**
+ * SFS: AMD Seamless Firmware Support (SFS) interface
+ */
+
+#define PAYLOAD_NAME_SIZE	64
+#define TEE_EXT_CMD_BUFFER_SIZE	4096
+
+/**
+ * struct sfs_user_get_fw_versions - get current level of base firmware (output).
+ * @blob:                  current level of base firmware for ASP and patch levels (input/output).
+ * @sfs_status:            32-bit SFS status value (output).
+ * @sfs_extended_status:   32-bit SFS extended status value (output).
+ */
+struct sfs_user_get_fw_versions {
+	__u8	blob[TEE_EXT_CMD_BUFFER_SIZE];
+	__u32	sfs_status;
+	__u32	sfs_extended_status;
+} __packed;
+
+/**
+ * struct sfs_user_update_package - update SFS package (input).
+ * @payload_name:          name of SFS package to load, verify and execute (input).
+ * @sfs_status:            32-bit SFS status value (output).
+ * @sfs_extended_status:   32-bit SFS extended status value (output).
+ */
+struct sfs_user_update_package {
+	char	payload_name[PAYLOAD_NAME_SIZE];
+	__u32	sfs_status;
+	__u32	sfs_extended_status;
+} __packed;
+
+/**
+ * Seamless Firmware Support (SFS) IOC
+ *
+ * possible return codes for all SFS IOCTLs:
+ *  0:          success
+ *  -EINVAL:    invalid input
+ *  -E2BIG:     excess data passed
+ *  -EFAULT:    failed to copy to/from userspace
+ *  -EBUSY:     mailbox in recovery or in use
+ *  -ENODEV:    driver not bound with PSP device
+ *  -EACCES:    request isn't authorized
+ *  -EINVAL:    invalid parameter
+ *  -ETIMEDOUT: request timed out
+ *  -EAGAIN:    invalid request for state machine
+ *  -ENOENT:    not implemented
+ *  -ENFILE:    overflow
+ *  -EPERM:     invalid signature
+ *  -EIO:       PSP I/O error
+ */
+#define SFS_IOC_TYPE	'S'
+
+/**
+ * SFSIOCFWVERS - returns blob containing FW versions
+ *                ASP provides the current level of Base Firmware for the ASP
+ *                and the other microprocessors as well as current patch
+ *                level(s).
+ */
+#define SFSIOCFWVERS	_IOWR(SFS_IOC_TYPE, 0x1, struct sfs_user_get_fw_versions)
+
+/**
+ * SFSIOCUPDATEPKG - updates package/payload
+ *                   ASP loads, verifies and executes the SFS package.
+ *                   By default, the SFS package/payload is loaded from
+ *                   /lib/firmware/amd, but alternative firmware loading
+ *                   path can be specified using kernel parameter
+ *                   firmware_class.path or the firmware loading path
+ *                   can be customized using sysfs file:
+ *                   /sys/module/firmware_class/parameters/path.
+ */
+#define SFSIOCUPDATEPKG	_IOWR(SFS_IOC_TYPE, 0x2, struct sfs_user_update_package)
+
+#endif /* __PSP_SFS_USER_H__ */
-- 
2.34.1


