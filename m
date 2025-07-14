Return-Path: <kvm+bounces-52370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA599B04AE2
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 152A37ABBBF
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5E02797A3;
	Mon, 14 Jul 2025 22:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XAIRNvHv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77291277807;
	Mon, 14 Jul 2025 22:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532853; cv=fail; b=Y2gScmKglIcLBbvWFNDq5LajSrfdQBFwfJL0BtTxsPfDOTGhwoVBy3cYIcZ3mjE/KUh4Nbtw9cvj9bXBv5JYF0dKPv09eTo6keBrvliYLxRefXc0D4WL6/nVqiB5cgdkogFt7NTRAOIwBRyIIMk61sn0pPDkimopIbYBZ9ApVTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532853; c=relaxed/simple;
	bh=DrdIwmQcEyUIZaviWN5Vb74iRPbx/egsmIL7S6KzMtE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JoredJfF4hKsJFh4NNaJaTKXHcnuxeslBiAfpiX9fuBnzfzStEAlcO/nF6QRPsPXbFcuDgJ8BOvXbcv1PZ0errPxKBvwrNI4HTLYI3IEvCsQlKjHqb23cFEw/uaOFdzzjtGuvR5BnziUJGpUn121S3O47WLCbzOGEPUQ0Dj/LgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XAIRNvHv; arc=fail smtp.client-ip=40.107.244.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p1Z8W6E6vL7OqeFv2abkOEYbobZhuhJJ9xPpsrfxQgyq+rxAwnhFt+0ZQX7cg1MOBICACVZqlMAo2PXrnUpHxOSpnjlMMycmHD/lGx7F/ARlv1CLtg1Rx1E1/4xdHrtESFz3teOmVHJD+fifL7/aA4w9yLKyDvTjc3TMhxQF0vG50MMkJdIJUTl2UVlP9zds4Oqa+ODK3nL4sJluqWYMCTGdCIyRzFAEpTCURX9mVYYGhLYPG3VuKwyXNJvUWbhnddNjxgzwASkNbVvYcL5tg+2dxNmez0/JS257evmeqBzokMdeImjq2/zzfa6QFs5eGhwUI3P5tjJAx37eo/5CQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0sQaaodKfUXnQidfh9Kkx4clbtAKOiP4+nB5dc5Gkk=;
 b=XPqix9ZKKlIAa/MAHkPNG3J4PTwmU8vzGE8adEOernTs7LuuxYcK0n9CKJJxT+uBEgPxYfCOA9dqfiBdipBSIsAR8oq56mpYzTlrdKJnfPRqA7ecPtkZ34xcYx2+ZfeQAofM93RCx7DRXVTdTkleC9OIMEa9hhgVrkQwPKiWCW+mloKQIpUAzfQLEXolnID7LquVbVtytVo5VI0/xMNfyQ3XI5KAL1A4Gzw8fv9ByR/oP7SF0D3XiVr61mMmScdRi/vn9IdtS05MMdm9baOnhUuLcZCua0gnUfUobm1xn6OfAmvXbpqZ+36KA8OXyQtamaEWOc/7rYp98qcgmfbuMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0sQaaodKfUXnQidfh9Kkx4clbtAKOiP4+nB5dc5Gkk=;
 b=XAIRNvHvssgZiwHPhbR0BOO47YUS9hFVeVd5DXhTKalaImZIrQU0t+Qmwa1Zvjl03NobpOqsKbkYGIhT6rR8I1iyjwXgI/rn47DM09XTrPM+b/kjzi8KG91jfPDQCxDnR01+3gfhXRfqrDhY3vUIlkP8aI0bfzNWurgewds9iak=
Received: from SA0PR11CA0019.namprd11.prod.outlook.com (2603:10b6:806:d3::24)
 by MW4PR12MB7468.namprd12.prod.outlook.com (2603:10b6:303:212::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Mon, 14 Jul
 2025 22:40:47 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:806:d3:cafe::1c) by SA0PR11CA0019.outlook.office365.com
 (2603:10b6:806:d3::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.32 via Frontend Transport; Mon,
 14 Jul 2025 22:40:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Mon, 14 Jul 2025 22:40:46 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 14 Jul
 2025 17:40:44 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v6 5/7] crypto: ccp - Add support to enable CipherTextHiding on SNP_INIT_EX
Date: Mon, 14 Jul 2025 22:40:34 +0000
Message-ID: <15640300c8980b671b34b0b4290976d77c1629cf.1752531191.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752531191.git.ashish.kalra@amd.com>
References: <cover.1752531191.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|MW4PR12MB7468:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ab13d9f-ce5f-451e-2a31-08ddc32779c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3HthDrIXdR0XM2xGXJ1qF8cQ6oabNu8ai1WiGWe+72NhkxfMUvNqLHtfGP82?=
 =?us-ascii?Q?7alhTZifyyVUUEd53DAso4KP/XJzjPa2kaBvxbRPIjfI3XFrhlOEuTRiKOv5?=
 =?us-ascii?Q?xSWYvlLoK62WsPFqqq1psTa4LhnI+BgU3i005WQe1aINqzQpQu45ETKqupDA?=
 =?us-ascii?Q?sP9VncZe9j6Su7L586b4aPWaHszhMgHLyC/wZ0LP7Pdy1K86BvLr9jZ+U5WO?=
 =?us-ascii?Q?29GtwKPxpwsZVIh0+kUTPS8GHLH8lBMCHe4QJWYxsOXiwS5Qfx13dKkIYvTf?=
 =?us-ascii?Q?ubwnTRdVaBV6Fhc21EMD2AKN9X45iG0w0PdSRHCt0ZsTPljuvULNdqQhbBYg?=
 =?us-ascii?Q?OveqD/jTs4xwSFUiH7TZypKLh1oh3fyvQ7vlLDXlJX+u4TGxJ3WIZ2gY5eKS?=
 =?us-ascii?Q?Y18YTu9/PIThmEcmmEJkY2vJQ34cOarEUIYWSOsv/Nft00SlaJzWMvm3yRYr?=
 =?us-ascii?Q?+nDU//yTO3iFE11K0NNFjqSSWJPdP995zWZ1V7FUudI+gCiy06Z5zpNEFMgs?=
 =?us-ascii?Q?tLP3Gc0P8geH22P/0oTpHrE0lCjWsZEeVQqwftdZZNLqblVpIe7KKwKm5rqP?=
 =?us-ascii?Q?DhV5bC212714DTV6wE/pr1K++8d62/6ROsmPwY+N1OUmPuOIuhIhNEXd0kId?=
 =?us-ascii?Q?kCJtxFAcZqj1n4amdgN4tYlbYFPkXPKqTV3TOMwr32HZKIymh8ApKi299xq4?=
 =?us-ascii?Q?tQ9qB0vWungnm3Xe3xiQ7m/ubsSi4ReCbCvuMsKKEDIPx8WOv3o/7BgJPQKE?=
 =?us-ascii?Q?6WLmqDJNmo5+QE1pp9SEOwhIBOuzXqd2smrZsFMj6plK2Ct3ObR4EwMNPD65?=
 =?us-ascii?Q?J7+AzqUAdj7LAwHgMAJukz1Z9UVOyi4H8cYDh/xzvF8vfazwE41YU6ONBmB3?=
 =?us-ascii?Q?IBz/x5lrUufFSzixJFRhKgDjxrWGtUgPqa6n7TwzV6/HBU4hd6gF1eFosZ6U?=
 =?us-ascii?Q?5iZPD5olFrCJYiYCCa8HVhIGBG/70zz1xa2BYH49vTF4+xZ9LOXkkZX0QhJm?=
 =?us-ascii?Q?eVKOOuaQV3YPSjPxJftIrPTuEP3x+xrhFIAoQwOoZr0g5bF67Xbh1u5v2g2v?=
 =?us-ascii?Q?G4Wtj6rXCKMKFvXbneXrSBXdoPmdyOjUvIE8nukqFBdwoG3WjHsjGSZ1tKct?=
 =?us-ascii?Q?iC1N0olezEIi6tRJ2ZIOXMafi34BtKyFVm9S6LH5WLx/NQhs9IK+GgWCKd7M?=
 =?us-ascii?Q?Ls502eb8+5R7n308PNNSX6GBlSbjRdbZjaIUOxTtx7Klmt9zLAJXTgUVoKbI?=
 =?us-ascii?Q?dfWNX6SvUdhU3FmzAe4tivEE8i4tohRLFNsrGY6QeHEqtqkd5o0BSK34AdnB?=
 =?us-ascii?Q?qBm41bSA+s/ESmXvJINAeZREXouEfDcoOIxNcKW5oXkbh8u/fBv7pb68ADVQ?=
 =?us-ascii?Q?hKrBqkyd3xXeKevnO5or/kRLayT5AF4+CwiPcadZjOsNccqybChZUDh6Ow0w?=
 =?us-ascii?Q?mJBO6trYwvLwlpjyfQopGUoAdqV/m79aZY6PUNEmHwp+RhbWfo0QkCYAa93j?=
 =?us-ascii?Q?a2nc842z72QWMpHF+JDmJ8nIpACWHwPODXTkpdn+Z/rXvlGkgdrScVri2g?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:40:46.9620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ab13d9f-ce5f-451e-2a31-08ddc32779c0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7468

From: Ashish Kalra <ashish.kalra@amd.com>

To enable ciphertext hiding, it must be specified in the SNP_INIT_EX
command as part of SNP initialization.

Modify the sev_platform_init_args structure, which is used as input to
sev_platform_init(), to include a field that, when non-zero,
indicates that ciphertext hiding should be enabled and specifies the
maximum ASID that can be used for an SEV-SNP guest.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 12 +++++++++---
 include/linux/psp-sev.h      | 10 ++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ed18cd113724..9709c140ab19 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1186,7 +1186,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
-static int __sev_snp_init_locked(int *error)
+static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
@@ -1247,6 +1247,12 @@ static int __sev_snp_init_locked(int *error)
 		}
 
 		memset(&data, 0, sizeof(data));
+
+		if (max_snp_asid) {
+			data.ciphertext_hiding_en = 1;
+			data.max_snp_asid = max_snp_asid;
+		}
+
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
@@ -1433,7 +1439,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->sev_plat_status.state == SEV_STATE_INIT)
 		return 0;
 
-	rc = __sev_snp_init_locked(&args->error);
+	rc = __sev_snp_init_locked(&args->error, args->max_snp_asid);
 	if (rc && rc != -ENODEV)
 		return rc;
 
@@ -1516,7 +1522,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
 {
 	int error, rc;
 
-	rc = __sev_snp_init_locked(&error);
+	rc = __sev_snp_init_locked(&error, 0);
 	if (rc) {
 		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
 		return rc;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d83185b4268b..e0dbcb4b4fd9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -748,10 +748,13 @@ struct sev_data_snp_guest_request {
 struct sev_data_snp_init_ex {
 	u32 init_rmp:1;
 	u32 list_paddr_en:1;
-	u32 rsvd:30;
+	u32 rapl_dis:1;
+	u32 ciphertext_hiding_en:1;
+	u32 rsvd:28;
 	u32 rsvd1;
 	u64 list_paddr;
-	u8  rsvd2[48];
+	u16 max_snp_asid;
+	u8  rsvd2[46];
 } __packed;
 
 /**
@@ -800,10 +803,13 @@ struct sev_data_snp_shutdown_ex {
  * @probe: True if this is being called as part of CCP module probe, which
  *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
  *  unless psp_init_on_probe module param is set
+ * @max_snp_asid: When non-zero, enable ciphertext hiding and specify the
+ *  maximum ASID that can be used for an SEV-SNP guest.
  */
 struct sev_platform_init_args {
 	int error;
 	bool probe;
+	unsigned int max_snp_asid;
 };
 
 /**
-- 
2.34.1


