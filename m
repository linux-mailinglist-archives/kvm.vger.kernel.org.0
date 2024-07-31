Return-Path: <kvm+bounces-22781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76FAC9432CD
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99C931C209AB
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A331C1BF315;
	Wed, 31 Jul 2024 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4M/0uwPr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344DD1BE87E;
	Wed, 31 Jul 2024 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438549; cv=fail; b=CreYpmTC08oNHwntei6rFhY5XbdQ2bqvmI7fn8iQOylc4xyCaVGCrWquEI2jsqYEPxGAxmnC730nFhcVWTAZkdRpa8rA6Wsmpe/os0Ks6Q+qA5RJzsvwq5pihq19j1LCPkPP6qRh+QFU4yrU3Wficw550t2ybwLsJZyH2XhXuLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438549; c=relaxed/simple;
	bh=873UYNPs74NRbebFgGrFHaJvV2TXQGX4q+s5REb44so=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H/25k88cscxZJvF2AdgCAQ5viaIGXVIkOW2KTginnMKwCvgLkyNgbt+ajJ99+k7tmItTXYxbRdZ6Mvm0v6x+WLjo9CcaiuEP10084ZFvAxb5yY98ZYrUoCWHTY0i/sW97SA7X2zLzvW+BaqPm3yUyd4k+3OW5Iygr+irIgaRhME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4M/0uwPr; arc=fail smtp.client-ip=40.107.94.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U50HkV29J8wjVi+j6NxS1wWd9QyPOt7iNtKRqfgKOki8CasrXtxC1APnEBA6NcsR8ti5GXrf50xYp+DARE0wclrCRN59F4uzAk73OegGFzoodPUs+PB+lgoHFy+QC6+gldGeVtTnShN6CBb2tllspd3yqQi2yayWe47nQqkvESPqHC6dtvTZjwuBiHzrV/lTRKMwK9nRfVWtGMmT9VHSVsLW3WOB61U6XXFl9aNxcseW4OJw527pNGzoeXOjA54mkHRnXhba5YBG4PEJCL6SXk8HoGqKtwI9oxjz1sGX+Psmh0OVvOlvtRcuSkkpeQMEI43gLBd6+1hKoOTUBL37MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6Vfup39AQ2zzjj9KaUPtqjrlhiyTaZ2dG5/4SdAdJA=;
 b=fFfatpRxVjwJQUKDna875BKzFGxnhqU6H6mFAyuz0w5uDoIMhYLL6moS8tSQBj/xUj7VnIG5+AK/Cw1FLibysxVS75z6m3g0rnttVklfZdVvlN251ijZePN3f0p7mkp94pX9wvmCoa2I5GgbvnD7XRTehSNJBQuE7FKWVzib2E/cQxvjpMhCi3NXwxKRSkqUEX633oEN1B3jpUQzdPPGka+2trm1FgxWl35c9xK9Bkp7iVNSeRnhoXfa6dWBf6vEoxQcRgsZqRUxKTADXgDA8PiJbMisxj3mLbCMm8pHJc0h0z2SOnvZBVh5v6WGoP62MkVIzrvNloBB7QThXIRCVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6Vfup39AQ2zzjj9KaUPtqjrlhiyTaZ2dG5/4SdAdJA=;
 b=4M/0uwPrl/qHlHCzhR/F88WPCd+IXtGlqiVbfxEn60BS85ZfoKJTr4gObh5fpwikJ1S2v0edqokihCBvtmocEXEA+A4PQ8mN37OEZS2Ahl1pH1Kl6OE8j79+nBDBudtbwM1oG3TIV1fWHeZJxeN9KsnERyEjeoAPxR2hxtnTGLo=
Received: from DM6PR07CA0050.namprd07.prod.outlook.com (2603:10b6:5:74::27) by
 DS0PR12MB6416.namprd12.prod.outlook.com (2603:10b6:8:cb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7807.28; Wed, 31 Jul 2024 15:09:03 +0000
Received: from DS3PEPF0000C37C.namprd04.prod.outlook.com
 (2603:10b6:5:74:cafe::4b) by DM6PR07CA0050.outlook.office365.com
 (2603:10b6:5:74::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37C.mail.protection.outlook.com (10.167.23.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:03 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:59 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 09/20] virt: sev-guest: Reduce the scope of SNP command mutex
Date: Wed, 31 Jul 2024 20:38:00 +0530
Message-ID: <20240731150811.156771-10-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37C:EE_|DS0PR12MB6416:EE_
X-MS-Office365-Filtering-Correlation-Id: d499e578-977c-4e0c-3a9c-08dcb172b705
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L4dmwp/FftzVrqPwjSZR0nKXGCbVbsrQZR6BV0OfWk7Kd55nRPN3txRnu+ix?=
 =?us-ascii?Q?shuN35/HdjpQz4vp+rPa8MPCQG/2maXge1DakZYw+AGO1PMoFaJ4/ObvZYSq?=
 =?us-ascii?Q?2NOMpUI1SaS7ec48ZlLicgclSXz/FpFGCtryEaomDrXdqbe9bgUiPa4PUh+C?=
 =?us-ascii?Q?cZnben3glC3WiHccOgjx/e8xbJ6b05PRAk0dQ7KL4CI628mp4TscnBSbUHjz?=
 =?us-ascii?Q?443tcQvN95fVTpiITjuaRe3YCaBGDR+Chyhlc6+1jpzZ0lxydMXwasGQYwBt?=
 =?us-ascii?Q?XxxFzPoczVeARjST31WDXoccL4feTTPsfjUpRWPurdDnQ0wICMKWbvcPU6z8?=
 =?us-ascii?Q?LsNI0rcLEWwG9XiBkq+4KB5AQFbib1zgmIm1ktX65pi7/EYTVD58+IaYCiHx?=
 =?us-ascii?Q?kXAjdABm+5oDM7WR2bzC+k7eixBFPWehczNbjrMPMBclXk46312UqyRcii+o?=
 =?us-ascii?Q?r4ZDP/uBVZXpgnm+LTdyVOHChurqMNQ2ngSizMEyRt8L/S6q9rKQK+xaFPtL?=
 =?us-ascii?Q?fHVOhFErGtAj3JmZG8FfFNECwhg48me1AvyGmXSySD8thrv722+0odgNG8LA?=
 =?us-ascii?Q?JRM4W80zmxKIPqPF2g5HDE3ApBPTUqsYBDgmQMUGsR+N2LU619+myY2oILaZ?=
 =?us-ascii?Q?xg6ji5Fmqs8zM+Ks0Pl78TdyYbZOwcZbp1k/8zr/FIU5xTg7kGR25wmVKqya?=
 =?us-ascii?Q?1nwOoHp7dfQI7XwSptiIhyq2yW48cLg9LuatL1ZiNwpPVaHChtAPelzsh6cC?=
 =?us-ascii?Q?1TqttjawNS9EYULxs0gL4I3/8yyV547d1QDKJ//k2SttwSqwfzjg79nLlvn1?=
 =?us-ascii?Q?kCv6V9okOqGrd+BquC44Lv0mg0hVsCeyy8Fz+ObCISKV0szIW2ZNUVgvzHmU?=
 =?us-ascii?Q?66dHhTfA/Z4WzQXIEjzYLueq9sSHOc4CyyenIPdny/gzxzSuIiPw4SfgA3g1?=
 =?us-ascii?Q?0WhQTUNEVqJCybIqMnVxOh4HTWEhC5fGJFpE+ol9lnU0AZ+e7AS2I46caVwk?=
 =?us-ascii?Q?aZV/7A5T8g+ItX44XLurHHd2eda4b+dsvXvGYEOSN/QAtZSev4izsaJ3+BXy?=
 =?us-ascii?Q?kCG+pP5WpFG/VoaAlh68qyp6y1pc/kQwmMBOsQODMBYDJEIA+IFzFNURWP1D?=
 =?us-ascii?Q?ENuJjO1XdEiShGtT+0htY9boP8KsYWUKJMsPoQd8oGdwYqowyfO33z57JEbj?=
 =?us-ascii?Q?Gktuuh/Vcdq/bvfYYSvNw5i+XsaCR5faRa/bO6zaZnjC2SdVwbf094Ddn9Hu?=
 =?us-ascii?Q?E7xA17HRMNm7U/bbO7ndCnfyl3NkFH8t6tDR2rAlgKPWSlOwyTUZy2yVwKmp?=
 =?us-ascii?Q?qpYDBZHT457PJ251KDS/wnRuFzpX0jdeLH9Y2gmdB3iXjE985DKH0zpiGFsJ?=
 =?us-ascii?Q?fRt1ADhK/9SEYTx9e65+ecSQOMzn2vWARda77hi2eXE23U/OFatbZ+Z3mIT5?=
 =?us-ascii?Q?HTDY2oD9ljLO/k/YMUGG64rxXlqrQHLx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:03.3635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d499e578-977c-4e0c-3a9c-08dcb172b705
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6416

The SNP command mutex is used to serialize access to the shared buffer,
command handling, and message sequence number.

All shared buffer, command handling, and message sequence updates are done
within snp_send_guest_request(), so moving the mutex to this function is
appropriate and maintains the critical section.

Since the mutex is now taken at a later point in time, remove the lockdep
checks that occur before taking the mutex.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 92734a2345a6..42f7126f1718 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -345,6 +345,8 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	u64 seqno;
 	int rc;
 
+	guard(mutex)(&snp_cmd_mutex);
+
 	/* Get message sequence and verify that its a non-zero */
 	seqno = snp_get_msg_seqno(snp_dev);
 	if (!seqno)
@@ -419,8 +421,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -458,8 +458,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -501,8 +499,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
@@ -590,12 +586,9 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
 
@@ -620,8 +613,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		break;
 	}
 
-	mutex_unlock(&snp_cmd_mutex);
-
 	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
 
@@ -736,8 +727,6 @@ static int sev_svsm_report_new(struct tsm_report *report, void *data)
 	man_len = SZ_4K;
 	certs_len = SEV_FW_BLOB_MAX_SIZE;
 
-	guard(mutex)(&snp_cmd_mutex);
-
 	if (guid_is_null(&desc->service_guid)) {
 		call_id = SVSM_ATTEST_CALL(SVSM_ATTEST_SERVICES);
 	} else {
@@ -872,8 +861,6 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	if (!buf)
 		return -ENOMEM;
 
-	guard(mutex)(&snp_cmd_mutex);
-
 	/* Check if the VMPCK is not empty */
 	if (is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-- 
2.34.1


