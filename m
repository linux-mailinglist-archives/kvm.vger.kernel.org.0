Return-Path: <kvm+bounces-54915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E74B2B246
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF3E0188FC64
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7962E1E376C;
	Mon, 18 Aug 2025 20:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K+h/+Hd2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDBC202C5C;
	Mon, 18 Aug 2025 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548361; cv=fail; b=k9pwBzGDcL+vtUr2gPZQWyzpofG3F4NJXvSbNlS7D82KAl9YfWG1Yk2MsWlvTGEZVCIRcHDb1+oZGvltxg9LWsbh/MkYfnL7ldt2obhV9YhjORUb+s5JiizOF08suXp8onofhqLoOsQm5v5zeerHDKOdWk2hfplyBD1Gecmi2Gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548361; c=relaxed/simple;
	bh=mMq88Y5pSaFpSXl0kP8FA38W6dQFKG2mprE8U6YTOYM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mqeO8amdguiX/tPceoRBMrHgCNyRJJMmW2Fi6WY3DGvuq2nLxY2r0yTEuK2IyJpRLeGQr+fFGftvYTmNlrb8ZQylzM7lHmvyVtTtK2YkfiLe/qemyODc05sbPrqcaoBqDMCTscretu9rXTLhbWrSUPsji/GdNUO5gtip+YB4aFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K+h/+Hd2; arc=fail smtp.client-ip=40.107.237.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AXxmDLvmOZYYsLcSnvtseg0n+OjVDAMvvnmK6BA/o6FB3prLC85/OXXiJqv9KFRVsBtiiQGQLAvICsQNK3kz1q5Ymab8Xo/NTNrHdJZ7M6Cito9ztwBlH8EptQamrcRGECepu3xAHd3fkfTxGo4e7Y4tH4vy+Ao6wv96aX4/vrNUuqcvCK+qhUO/eZNmv94xXpT8sKHmFEnNMt/8QTKOSZwGSjN0pj01k/0W9ttgjjxIa14xGWw4r3hPm1UjhiXNabF1mNac50l7m/jBbo4P7fNivmRMEucggPY8S//o1OC7hJW3xw2LhCGFHLwxawWJiuMk02BP9epNWeKJe9BN6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4da8J11azjjYelo+WeqdgbzvuCrIo9iptFh1FWAOhDA=;
 b=UAZc3PdMebQO+qG1g7mIohzzx+VnH6oSBg6YBBAMIHcKJLDDVNQrDwxUNxo8qwhP+lPEQF4Q+Z6wQSZetWyIeRNHgr2Irj7rcZO23Y6OkH2Gy0KXpTFujK2E4DENwCxQ4i88MGqC2plce+gQ2aoX2BzBdI3bEMClLLSbhSmkNblLpV4DRfm5xAMrZLFzW7L9SmjNWnhsLB2DD3hZWWdABbh6iX7N100l1V5a+eQSew7pnfJjGqj2nbHnyPdKhqyBh8+pYn/9RIIy3p5e2yXSRrn4rs5niU0eQk7e3WbpbH71XKZWEhAeW1DJRyq4JlPrydp4QHa8rlEJRH4eKV6nLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4da8J11azjjYelo+WeqdgbzvuCrIo9iptFh1FWAOhDA=;
 b=K+h/+Hd2/wEyXEGb/9lp16wMc173jlDIKgW4OX3XAr6dUP4zcP92ZVL1nFWW3hi5fsPoyyn+EUti/QZUG9pxZu56gqFqPB43w6K8tx4FkAveyh50q/AMmi41KqncbBOi8EQ72dsJPt5AFXBGFASblVm4bgmXcO4N1fwBdt5UDt8=
Received: from MN2PR11CA0019.namprd11.prod.outlook.com (2603:10b6:208:23b::24)
 by CH2PR12MB4120.namprd12.prod.outlook.com (2603:10b6:610:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 20:19:09 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::cd) by MN2PR11CA0019.outlook.office365.com
 (2603:10b6:208:23b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Mon,
 18 Aug 2025 20:19:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 20:19:08 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 15:19:07 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [RESEND PATCH v2 3/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Mon, 18 Aug 2025 20:18:58 +0000
Message-ID: <1f3398c19eab6701566f4044c2c1059114d9bc48.1755548015.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755548015.git.ashish.kalra@amd.com>
References: <cover.1755548015.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|CH2PR12MB4120:EE_
X-MS-Office365-Filtering-Correlation-Id: 663d014d-54c4-4692-0822-08ddde947cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+eiN1dIjU0gT5dKdQsjH9C707Hr7QJguLD7onnxCl+AbvXGtcqJCbm/dn5Qj?=
 =?us-ascii?Q?TisV1qfDHUahf6/TojovVXjUT9g4bQviZfXos3vltjlYHzX6Lz40us97mIGM?=
 =?us-ascii?Q?mo72KBez5B8J+az4ed3deiNy5aLhFLKjHSJaioGZLuaI/ezJTHD3OYsPLXMB?=
 =?us-ascii?Q?KyS2gQXSiHNZ+H7W75aQl8ERqcfrnStCgft6u+As3ja8aprSDn2M9hhO7mbm?=
 =?us-ascii?Q?iW2aX+tkBUvzNgeOaQhKZynKSx0sFpSIAoRQgfvr2g3CG6x2+3XF2v6iubmP?=
 =?us-ascii?Q?/t7R73TfN++nJrlRCydiJU5KlVW5Y/9yCn9I/ViUMGd9mt+M66GlKDDKXxgz?=
 =?us-ascii?Q?P28RoyC3et0X9DJBHI8dj1cKrlcY0ADkwBxiM4IUZb820h/wdqXbggCCMQDd?=
 =?us-ascii?Q?ipO5my0etC40w/GrvfLd4odcANGNMvXbHYcuxMhGflQPO6PenZDZaqrx8UZX?=
 =?us-ascii?Q?P5Po6GohNdow2A5Dzyt6/PD6jd4mFItZjfDMYojgF6ZoaNtPYkfmBXwe/ttP?=
 =?us-ascii?Q?2Meg4fDmpgOjUV2Loeu2lHVu+nwJwXfLXeLZ6zKi3nZYJjno4YoKx3Hvbkqq?=
 =?us-ascii?Q?hJMc5yOUzo0RH3KJkS8J3V66Uq/aS1anyCNitZAovWBDmELRCjKmwYwxJ7Lv?=
 =?us-ascii?Q?Brwrhw/zRrbZEYY6yRYjE5XqaVucbje7rvG3mDeJAMI2Xvx3nLMuklr+qxu4?=
 =?us-ascii?Q?GqXcItfcTibHUu+7i2fnOghG6+nDOse6IR19nYcqSM55YKIZMNPq/auwWKQ8?=
 =?us-ascii?Q?8bHv/P94T+0MMJRV7GJxEjPIogkNct8ovtG/p+OQHaLo6uZvsad+V00gbJOb?=
 =?us-ascii?Q?F14vBCnw1rgbpVnuLOLCGo3G+xfb34hJtr/39lZHG4S/FkPgEp9ZFhLPBPVI?=
 =?us-ascii?Q?iKDgxLuhk4TsrFaH1OFwhVU5FDbfeaF2P5CuGVZdshrwV1sMx6FVuVtQ8K6S?=
 =?us-ascii?Q?e6VkMkpA0LURkImWu9ij9wCUxxWcMefff1RDdHpNLHW+17TVT6BMj5ymYqg6?=
 =?us-ascii?Q?pe4N4JQCIQCXU39eJ6ZdTZ88+fRIFEpu1ulZ/impZoW1xkGRF71dNXqsVlDt?=
 =?us-ascii?Q?X49LQvRWIhd9amBlsuNzsmsOFVvVmS57dt+T4eKx6JaCV7uMgiQ6Jtuiwrx2?=
 =?us-ascii?Q?BofrSbO1enHJ4V/JhORqszkAxHt/zd2ww087UYzX2LypYaWJAZGkwMPOvebN?=
 =?us-ascii?Q?ttoRqnLc+/Xcfl0W9BZemC9QQgY/1gz70Gfw0ICV4E9UFzybGRntdgQM/KCr?=
 =?us-ascii?Q?wFLWc5SlBRnXRpxzCdY2OUz36BoBjcSkI7fgOxMThLoyqdqna47v/pQYtdWU?=
 =?us-ascii?Q?GeLWNzcwk8gvcOr1HfNSGLhxdKoEZR25ZXeSREcBgH6MjcgXNx1qYEYFhwFb?=
 =?us-ascii?Q?xl9DGGaxQyrilIQjhYNwl1MLq+WeYpqMtieHee7lgpE4MXSgwJgvA9hEBJK7?=
 =?us-ascii?Q?0H0KMDIZiQXxHsZtUQimW5r/i3ebmr4jWtcJbTw9JywqeXKtSjcXaMJT0ZhW?=
 =?us-ascii?Q?yPcsdxC4h39Mjq+1PkFwDBzvwYVeMUYINXFPk3KWiF4vdqPO8XFlxAQydA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 20:19:08.8456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 663d014d-54c4-4692-0822-08ddde947cee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4120

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

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sfs.c            | 302 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  47 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 7 files changed, 467 insertions(+), 2 deletions(-)
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
index 000000000000..0e984414de5d
--- /dev/null
+++ b/drivers/crypto/ccp/sfs.c
@@ -0,0 +1,302 @@
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
+		dev_warn(sfs_dev->dev, "firmware request fail %d\n", ret);
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
+		dev_warn(sfs_dev->dev,
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
+	int ret;
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
+		goto cleanup_cmd_buf;
+
+	dev_notice(sfs_dev->dev, "SFS support is available\n");
+
+	return 0;
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


