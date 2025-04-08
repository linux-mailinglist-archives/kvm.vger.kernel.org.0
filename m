Return-Path: <kvm+bounces-42895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB845A7F9B8
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 11:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 058437AA02A
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 09:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95928267B70;
	Tue,  8 Apr 2025 09:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DHdV+h0v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8321E26773D
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 09:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744104767; cv=fail; b=k6bteWh92rMTtPOkDz/ALneSyfklc2gMh8Zsrm9UxlH4rYBRC8GreJV47Q5LVgd4iEgjbfzn0Ck/p05f8Dsgqoua0khE/H286g56wtvr87Hl47u8p8ApOeD2beNqvK57quaGX0cBM0p1CQW9neuwDVlXxerMiESlG+JCOZ1OdPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744104767; c=relaxed/simple;
	bh=+1kIjpo32mxNBWfG/Vh+1z45oUbcTNpQuUGnwbgWhEE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iOGPAMqBLMc4QEz7EaT4IXt/zd6tB4i4J9Kh65rEiOyrKHgtAJG3Tz04DEh48NpZ7aLbwh1o/hlvqVfbVSeQ/YmxpVQ/SIJtROS6YYwBUm0X9ld9+jxx9RT0h+a8+Zcm4zGVYQYMwA71Jw/Q+XWTbNK7/E8RPT3svK468F+qky0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DHdV+h0v; arc=fail smtp.client-ip=40.107.243.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oAT1O8GtMOAu/oh9fQ1kr9K6b3i9O6VPazwyryiUdcxTeJSEkhmmw6qYxXzl4SziGYBBqEVac00C3+WzRLx3AelWpQ1pHvOIBo9IIsYw7QAMwalSo9D7PsJa/ls1vY6fwKlM66N71KfbV83VcUXvdDa7c9DTA3GVplo2Jbg/U0TdhKZkkY0hvzivXnHZvD7659Y5CNqkLOUz7fDYqH3W1oj8p4zV72OMTth+d66/bmMF/T0ThZ+J4rAQS0IolyP4UtxIh49SQWekI+Jyste2gAjBSloGhX/NHgxy3FUD+553erebLgUhjMj1eC+hMp0frg593q75xGlgpN+5MWfadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ddkdwJehwtdN89XF+lcmjDOqCDs+zDrqbNWjytkDcNQ=;
 b=R7Cm+7aK6Mu2hY32BZvb3BPyWReQlsjNwuceHulORBj6uaGBQHXcYl5YWUwmj1cmbFITkfVqmKrStdXHHrJbOpF+3e6AueIAS3WHUN6s8/nXCG+1lcJjL2rhG61a8QgmOhQGEanIQh+AgzR6BCByE0zG5rKuVVc4fYDFtjVUHQtiuYLLZqN3EiPYLAyNIGfm2ggTXzRtPVXJ0Un65twWHj6oPPdZspJdJQhMq0ia/5HHPEJlgHJqarNQ2X7DE6K7sR422yL2rcj7sZsLzLhTGfBTGJ08jFpMjv5qTONZg4DrB0PW2MX5myiYHpkOkPZ6+b7heeN6FOn5fIwyS+972A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddkdwJehwtdN89XF+lcmjDOqCDs+zDrqbNWjytkDcNQ=;
 b=DHdV+h0vVztscLKQXorZoSkbjkNjeW82kehEJXTqCXCBMbYKQQeF8fSJmhIt6uPZCUT4KZEEMvKafAPT5yxajuccc0rU4i6jGUJZ2jh+hKFTxABfrGLA8Kqe0I9+d51XzV+cTyBQplPcNMKxZjDsTYQ4CwLC4IgV5zyoStzHVbQ=
Received: from SJ0PR05CA0145.namprd05.prod.outlook.com (2603:10b6:a03:33d::30)
 by CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Tue, 8 Apr
 2025 09:32:41 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:33d:cafe::b2) by SJ0PR05CA0145.outlook.office365.com
 (2603:10b6:a03:33d::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.10 via Frontend Transport; Tue,
 8 Apr 2025 09:32:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Tue, 8 Apr 2025 09:32:40 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Apr
 2025 04:32:37 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>
Subject: [PATCH v6 2/4] KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
Date: Tue, 8 Apr 2025 15:02:11 +0530
Message-ID: <20250408093213.57962-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250408093213.57962-1-nikunj@amd.com>
References: <20250408093213.57962-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|CH2PR12MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: 32ae83bc-c221-4eab-7cf5-08dd76804f15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YPVPX+SL7/jdDI29q2dPxRBdYfQHnpqtiQPljU6czBUMd9m/pZjgsgszK8Af?=
 =?us-ascii?Q?zxrztpDVJRw3HFXxd2qkUm6WYURzZC9KzyeM7L2VAOJ4BE5iZFA0sWQev2hB?=
 =?us-ascii?Q?TYmmjdkgBhBp/uv+yxVId57T5D9sctEUkWXlAv3PBG0KUdsH5jS1OyyNckCX?=
 =?us-ascii?Q?C+USA+aHdHVHQ01pz3cmwplUe4klgXfBChV/GPta00wObt3ewGg4p/F0Jhh5?=
 =?us-ascii?Q?m2UyPvwIjruZaCH/M1xyW7SoJU15OOD+SK4mzcRn11gchGrSA6wr/S3xbaad?=
 =?us-ascii?Q?Q9zgn7kmGBCUj/Pf8GZFo2ky/7bBoSxszu6ppqODAB9eD/x75Gyx7aAC0pWG?=
 =?us-ascii?Q?ycB0hdlTPWZ0g0O43nB8PzA2lD+vrRg/Nc8mog/U5qJoYCuubXFu4W0vWfzB?=
 =?us-ascii?Q?bzUc5Um8yBWk1QqoAxDLiDGFVFeHKPAncbiAyosz4230n7pJ4vkhotn/Vu/d?=
 =?us-ascii?Q?ZV5xJ7zZubqvDK83b4r8z21nymWSgMJbumguDJYqn/GbNwIpOQZXqKOyB6rY?=
 =?us-ascii?Q?SV/znymS+CHYpYy02X0/fR2hmdacDynFmHFHa2mSnYhiQ4oWu13zEdalHdQh?=
 =?us-ascii?Q?fc4YI+d8drN6kMQZMXUO4iWRl5nkX4BQR4l0+9EehRzUU+46XCUqAnYvpHCp?=
 =?us-ascii?Q?SifpBYZtVX2cPCc77D9mmfh6S/0sI7fxl0mqKQZiTg9byMKmDi7nnz3Umso9?=
 =?us-ascii?Q?tBX/ES/drThAdqpSVo+A2CGL9tx7ZYo5+WoG9S9A0xUJcm50EiY4mkPnVbh0?=
 =?us-ascii?Q?CRSVs8unMg+8JZVHoGOenmmXzjTilHyrfTC08WhWiwPXMpdVcrs0JgaiPlaR?=
 =?us-ascii?Q?Sjw/oPYi8xvlkRfrM0fBM/N+bIqy3ZeJcomMWKB+CnaVGXk8fIAg35zcdbvr?=
 =?us-ascii?Q?RdPNLlcRyB7buYlI38/L9fwWJcOkxtr1jlhIBR8OTvzgP25IIihnjkSnheCE?=
 =?us-ascii?Q?xGu22fDnv1Frx8z/8Ye3vwKOewAgEuMgU6v9vN1+fkOBxjwbu4Vw8ltIvT3m?=
 =?us-ascii?Q?mNJZ7T0OrtFESOcp3n89VqjSf9lBTGcPDC11sPp4XURghpLRhw/MbffSH4dK?=
 =?us-ascii?Q?8cyP2tp3SJe1Vyidf4JlIiwo8MYIvNyjWCyfDw6H2ZSyUSouGMLSKuaDqZXf?=
 =?us-ascii?Q?YLk9Kt6Cj/MQl3oTVJGQWM8B3XTXFRJQzVnyd2e0yTY/xDdcm1S7vmW3vkzD?=
 =?us-ascii?Q?9paQA56+IG45atazi74XO7yCybK1hSZTW7xe9cMrvkmNUexnzdBGPRJNXq4K?=
 =?us-ascii?Q?gsEbfxca8WrC9t1XKriBtzVM85O/VhZtjLchxHErjsP8/HJ8W4Md2PqNLwYf?=
 =?us-ascii?Q?zHTwUXOXFfrEbCjIg0kM3ALBydPX3lJNJFbY9xZzzjqfgQ4Laa/CtQLhBjuA?=
 =?us-ascii?Q?KdaPKb9fFz6//zp57Or7sGvSg7vf6xjaEr+pXcw3PBIiOYb/Hv8FFttjP239?=
 =?us-ascii?Q?4zGDMxytQD3LIj2hFurjD2NiaIl9VIVTDLkIbNLZ5JXRQrEdroctiCoabtuR?=
 =?us-ascii?Q?P8BmmqedpI/Q3ZU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 09:32:40.9772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ae83bc-c221-4eab-7cf5-08dd76804f15
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326

The sev_data_snp_launch_start structure should include a 4-byte
desired_tsc_khz field before the gosvw field, which was missed in the
initial implementation. As a result, the structure is 4 bytes shorter than
expected by the firmware, causing the gosvw field to start 4 bytes early.
Fix this by adding the missing 4-byte member for the desired TSC frequency.

Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
Cc: stable@vger.kernel.org
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 include/linux/psp-sev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index f3cad182d4ef..1f3620aaa4e7 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -594,6 +594,7 @@ struct sev_data_snp_addr {
  * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
  *          purpose of guest-assisted migration.
  * @rsvd: reserved
+ * @desired_tsc_khz: hypervisor desired mean TSC freq in kHz of the guest
  * @gosvw: guest OS-visible workarounds, as defined by hypervisor
  */
 struct sev_data_snp_launch_start {
@@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
 	u32 ma_en:1;				/* In */
 	u32 imi_en:1;				/* In */
 	u32 rsvd:30;
+	u32 desired_tsc_khz;			/* In */
 	u8 gosvw[16];				/* In */
 } __packed;
 
-- 
2.43.0


