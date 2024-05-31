Return-Path: <kvm+bounces-18475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 815538D596B
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A476E1C237EF
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184F57C6C9;
	Fri, 31 May 2024 04:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XD4IdLBY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B397720B33;
	Fri, 31 May 2024 04:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129987; cv=fail; b=Cnu2gbQKGaUM+XYhzTy9xmrqDI5ArBTVmD8qnUWVFULASwDt0XT+ivdMHJZ3cwi1doj+cEYy3HEetgLRWB+2ObNJSRGl6G5sHD3nsQeFYTEWmRExNbrPGe8ZFAXVjHAEc4ouTvG/AP3Nv4GjYa4gFAGHu5r7Ryn7ttDQUFZ1OuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129987; c=relaxed/simple;
	bh=7ZDn46ulUtwzRbJyDl53G4ujNNySYMc14dJ+ykT7hFA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNi3ugrzVQh2AKoytZ61zWRekzyyWFh2N3MbI+uZqaAe92Iv6vCIUNRncwnAEb+syVJGSYkTk8K4c942SvhDnyYDO6p+W24zbQjsmvY8YzEMc2THw49k3oRKqivGgGqE6TeMSZ0Qu0n6c50H7nLtkmhm/KDyjaCt029AZIm3LZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XD4IdLBY; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juRJwq5GmKz0opQ/Lq1iVRZXPrI/KarOiQSDw5C43hjPC66hAlYlxkA/2BoKnYdTixsMreCdOV2FiZcGAghpoXw5Qi9VaunxyjWpflKqYdsjcsOKyzRfpSYxvbb0579+pIgIuuXSQJeDdVjvPflDOiZo2oVt7f0QQGEMgpN2efTsPCXNFQttbm/kD4aW7DI4Z7Iwyw6B8Fi8S0OIyCbCwFcE/uOa0UJkDscNANBVc3X6w2xTJS8mBwURSE7g8ez2AUDGjgmkCjiLAeTvQcJ6zZxKwpouhzP9iJ1qeh+SldhAIMjYiO/7f0mDi03mOhp2OmGYCpNiXl6ZRBQUX5BUJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9GkarFZgKGH1f0qGp274+NA5OexXI/DQxI6BAriPHU=;
 b=JnMzO/Oaigzx3MDHhUTcx+x6S4H+9gv5BXfr/Xm+0w+OTWIKwN+gbedqvmxUllMg0dyCuZYxOQH5Ks3AWrAdQRNUGRfFvTk2CWgIRVKjZU+oFkxJbjy/EQxKDUeD8MmhJnJBf6i0BvBlM9v1DkBmn0ybaQGEATS5n1xY76a5290xZqIfyXIU2tcWYBKtzvnYqTNQzlObdUSrZsItFeComeZGW5PC+FUmtu6BSzXCdK6Aw5Tlxn3MrWLeiY2fqYE6QOe4qS2XEoD4YAebm0gCI9+lLp75+sHldEc5unrLncX9UrwvS8IKCMWoNdu7P19KSTs0Tb5HIVkRAC5vwad5Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9GkarFZgKGH1f0qGp274+NA5OexXI/DQxI6BAriPHU=;
 b=XD4IdLBYnBsArk3ZFclJ70oJAGs2SFzfQPN5f/DCn9MT4zbhat3l4gzlyChHANg2Keyj+weuGHziHcDTO/JIIFusUuzZFfe/zO63ThtFhiGfP8nz8hFrB9l4RmhKuL3r2gkp9GqddYwPVE/TMiSkDDnAwSz6Dc9CIG/3woMsliM=
Received: from DM6PR08CA0057.namprd08.prod.outlook.com (2603:10b6:5:1e0::31)
 by DS0PR12MB7874.namprd12.prod.outlook.com (2603:10b6:8:141::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Fri, 31 May
 2024 04:33:03 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::ad) by DM6PR08CA0057.outlook.office365.com
 (2603:10b6:5:1e0::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23 via Frontend
 Transport; Fri, 31 May 2024 04:33:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:33:02 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:32:58 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 08/24] virt: sev-guest: Take mutex in snp_send_guest_request()
Date: Fri, 31 May 2024 10:00:22 +0530
Message-ID: <20240531043038.3370793-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|DS0PR12MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: 16c183ef-92ab-47be-93dc-08dc812ac26f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m3KPB/7VCTLMMzpAbEhgT8cbRlciN8AaXry6PFlWUziOdx2UA9+sEGHRp5/D?=
 =?us-ascii?Q?BYWfx5r4g9lm58WoeKX26m67YaCAZ4xSDjJNv13MvCPadvpL6RwFVmAgI2/Z?=
 =?us-ascii?Q?jvYr1ET5R+OaRtW4Tzkm7/hvTKecflX6QpeZED8/BG8v/TGsrv/0PqJKJUU1?=
 =?us-ascii?Q?ST/g+LkK7a87urmW6xgMngI+7oPv5o03AsZk1n9L93fwfLDVGb7MlfuTH+C5?=
 =?us-ascii?Q?NlNMej6fC20Oy6GYEKPq4Y3f36gj1XLzXlNCLqFwBtA7xUvndAyr/EWlnvdi?=
 =?us-ascii?Q?cqUR8IeIwk3XH67kbbhvV9Y7sloVhHJKU7GLd0q7qtvxj20NmCMDRWIPFdf0?=
 =?us-ascii?Q?BOGXf4hS5Obaw0NVslGtUiK6i8qpmpGkECkbDug+xlEXHeHTD4nxTJLeSmwB?=
 =?us-ascii?Q?Emp3GcPW/Va2nZdMS23pOP9UX4c+lRjum7rMM+ptwUWEjufB64esJJi39U9p?=
 =?us-ascii?Q?043t7F4iBO8StqFV9zCY6aZElU7qUEalfHxkM6Uz3Wkk3+zZwVV81qr4VOlZ?=
 =?us-ascii?Q?DiEs8CdDG5jx9h73G0QitKV0rCDU9AGfYJLBrAv/lAWCLmZxBRW2bD4pkwEE?=
 =?us-ascii?Q?2S8wi9A91ZC8Pn2MIsyGmPU4B1Y7XQZmra5T95iOiWIYNxOvV7shAGB2ZGdy?=
 =?us-ascii?Q?XO09tgB+Ur2OCjTOxHBsnCzYTmI8/zsdInAPXaqBeoiNrq35VkaGjd3+LD2q?=
 =?us-ascii?Q?oETerDBvDU9yBIEU/OpdazOlPhmsA9sFoHeEGMKSlIXY5zB+OnjiwC/40NPU?=
 =?us-ascii?Q?nJTTz4CYCdzPN8htYezXUbPphMXTaxx07345/p/6IHo1q6Yxb0lz+RU2j2Fl?=
 =?us-ascii?Q?Nqbfa2VtNy6cSHrygrEULjUI1cKOeuJsJY+Os4Q82fegCd6pJ2WlmdhJrZ/7?=
 =?us-ascii?Q?apYJ4OCkIKRzJvTTbFXdnfD66Jx67LJRay2ZtBVy9iPJGs3+jZLTibbGRd2z?=
 =?us-ascii?Q?Zysg4enWJB2g7B/+4FO0h9zw6+h1vRlcIkuy/52Y9GST2qtdYjGshEKdVtIS?=
 =?us-ascii?Q?TZX90+o4PmLMoQOsJ5yFVHPHW3fKupICvzqxKm+Dh0Ln50XodEwAOZyT8pfM?=
 =?us-ascii?Q?mG0KRGRCEW40pr9KMA7PxrC+LYhJCViHSWkzRnLeUNX6O8xa3ngir4MTJYtd?=
 =?us-ascii?Q?PISusalZcbA29aDVb1tAWlbg7B82ZdVsWqKKwWSTjBP/RbQH3KptpgHGSvbf?=
 =?us-ascii?Q?9sJmnHE/l0//lawvw2qPhgYTR4UXWm/z16FRR774i3ZRBx15dcU6tud3cWn0?=
 =?us-ascii?Q?Hqci/QaRnxQCXgquiWCmAPU8Gc4pVEsU8CBBaWxzwI8Bsten5o1ye/yXprm1?=
 =?us-ascii?Q?WHlpLJRsOhAEPBteSx9NYDuZuAnqWMqlftXFJfyIrKqHIdgFtxLQg/mpNDBe?=
 =?us-ascii?Q?UaXST1A=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:33:02.9688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c183ef-92ab-47be-93dc-08dc812ac26f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7874

SNP command mutex is used to serialize access to the shared buffer, command
handling and message sequence number races.

As part of the preparation for moving SEV guest driver common code and
making mutex private, take the mutex in snp_send_guest_request() instead of
snp_guest_ioctl(). This will result in locking behavior change as detailed
below:

Current locking behaviour:

    snp_guest_ioctl()
      mutex_lock(&snp_cmd_mutex)
        get_report()/get_derived_key()/get_ext_report()
          snp_send_guest_request()
    	...
      mutex_unlock(&snp_cmd_mutex)

New locking behaviour:

    snp_guest_ioctl()
      get_report()/get_derived_key()/get_ext_report()
        snp_send_guest_request()
           guard(mutex)(&snp_cmd_mutex)
             ...

Remove multiple lockdep check in the sev-guest driver as they are redundant
now.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 0729d0b73495..19ee85fcfd08 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -111,8 +111,6 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 {
 	u64 count;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	count = snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] + 1;
 
 	/*
@@ -334,6 +332,8 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	u64 seqno;
 	int rc;
 
+	guard(mutex)(&snp_cmd_mutex);
+
 	/* Get message sequence and verify that its a non-zero */
 	seqno = snp_get_msg_seqno(snp_dev);
 	if (!seqno)
@@ -388,8 +388,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -436,8 +434,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -488,8 +484,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	sockptr_t certs_address;
 	int ret, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
@@ -585,12 +579,9 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	if (!input.msg_version)
 		return -EINVAL;
 
-	mutex_lock(&snp_cmd_mutex);
-
 	/* Check if the VMPCK is not empty */
 	if (is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-		mutex_unlock(&snp_cmd_mutex);
 		return -ENOTTY;
 	}
 
@@ -615,8 +606,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		break;
 	}
 
-	mutex_unlock(&snp_cmd_mutex);
-
 	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
 
@@ -705,8 +694,6 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	if (!buf)
 		return -ENOMEM;
 
-	guard(mutex)(&snp_cmd_mutex);
-
 	/* Check if the VMPCK is not empty */
 	if (is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-- 
2.34.1


