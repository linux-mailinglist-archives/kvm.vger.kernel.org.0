Return-Path: <kvm+bounces-20255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D329125B5
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 009D91F24C3C
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A5215FA96;
	Fri, 21 Jun 2024 12:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i+c8r5j8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F4A15F41E;
	Fri, 21 Jun 2024 12:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973599; cv=fail; b=kFp1Gqc/omMu8f4/u4mSlxCCm6xEiWwQX5UZaF3q4I52vUvfCt1DOQmFYig4p1tfNLCrGdw76RybvvbrzWpbqN8M7wGXdM179HMjQkp7wlwi9QAcIM6pTiThxCbTQCV8XHBbjx4BzzZ348rnemzcOthrxqIxGI5LtoWAVUPVsjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973599; c=relaxed/simple;
	bh=v48RcdVmnEvMzGgLyfteKN++wvVFIZShzXzHU58GC/4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVA6lFSM9s5niR87te0oa6GogFp3UIeYXXscT6BQMr4pFqf0lD9AjMclLyU2HaDv/FaWEpdQ5HF9XpBgMg2gl6L3jgXKRHutlPs2cXrZvInyykyHJu6xdioqGnQyllcB/aLrllW0B7YNSVc0+d3eCR7/9phUYpVaXBm+VBCAwQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i+c8r5j8; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oe+6itLL1vzbltvAsmhMigSs7XiD3NIT2itbRT5jhfGFnNykQbLAQySYOwwMcXEMLKKsKovcnV6XRqG2wQ2q/D9ULi55/lk+KIruU0qbRT70/solujIgwVKUkGtJuVsiGDNCgQpNeih/Vl/Ahbg1UWp3cOvU8yXDDC4pAzqEhoxfwEgF0AgnLEwQkwyJgalZlYlSHkHS4+8oiEtIdNdHRIzo44o2LRDCAu9wyq9yBSGnk/8k8V/Ec4PZkq1cVpqd29piR0loykkG/OoXnnYXmOuSHjCHvYjY10j++CgSpx9JRDl0fd/ZUKYM2GKA5GVrNKd5M9MZvh3t7K2PTcDaNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lGSRY1U41Oqj/0fj0ULYA+LHHRrMAFErMUg+URhHacQ=;
 b=OT89oumkJ7NBcx560Qh/5mMtOa9+xPI4xGZ5FLrkpkRYEEQrYPR5D9id4rKu23bnJzoaeZrSJSO/lvp2/K1E2fJZQoLMtcwudK1BYFcyNFoLX9eSpfucRstJc2nx7pvc8nOuAcphscMYpVGqFJyLk8DGgbIGmHE3/pOzyblb/x0XADAN0gApMzbm2Jbddkdp+bWFg0nrhJGWwUBPR+n0aW+rHg3tH1Ktt+JBuQ8PCW5sh/LQIV7ofuSAXQ70rm+yQMpgTXV4gB4yufPP+pg9FYlQDn9tx+aUvW+VsKUmv/2ALo6jcO26I0KHtjKNPCX+v+O1AgXp2J1Evpkt7cAeDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGSRY1U41Oqj/0fj0ULYA+LHHRrMAFErMUg+URhHacQ=;
 b=i+c8r5j8nl1gChXKsMPhIHkW7GpZEFabSLj7BYVAFLJRKOty6SaT/3lb5ppeO0HFcu/rtLUvQvRd5gqM0xcjhvnvslL013owUzapWiJnRwGfKQw4BDZhCdNepzPQhSTnfibVWZTPNzw1IDW5FPApwD61hnOuJlxT4+GkN7WjJXo=
Received: from SN6PR05CA0011.namprd05.prod.outlook.com (2603:10b6:805:de::24)
 by DM6PR12MB4059.namprd12.prod.outlook.com (2603:10b6:5:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 12:39:55 +0000
Received: from SN1PEPF00036F40.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::80) by SN6PR05CA0011.outlook.office365.com
 (2603:10b6:805:de::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.34 via Frontend
 Transport; Fri, 21 Jun 2024 12:39:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F40.mail.protection.outlook.com (10.167.248.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:39:55 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:39:51 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 08/24] virt: sev-guest: Take mutex in snp_send_guest_request()
Date: Fri, 21 Jun 2024 18:08:47 +0530
Message-ID: <20240621123903.2411843-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F40:EE_|DM6PR12MB4059:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c477c49-dfdd-4235-f697-08dc91ef4123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|82310400023|7416011|376011|36860700010;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8bqT4ed0hcsPoKYH/4/Bm+LRUnqIqxrStaBaUU1qhhvK//3Voq6oC7dgc5sa?=
 =?us-ascii?Q?Uh/+Yoah4moS7XZYAPXQU7zQER2RF4F6YWfvHekqBR7OU5Rn3DoybmSXoDz3?=
 =?us-ascii?Q?DD8N0nioznZC9sbuvspoXqHJMrZn5hd1L2UuMf+yz5oB0ZXbQO27LDWb3kmQ?=
 =?us-ascii?Q?cDT+gUAokw5yCo0JFOi8iRwN2+F46KEIPJDeKYLpPuJEtxlJ3vO2gM0DU+Sr?=
 =?us-ascii?Q?P4CpVvMlB/4OaGIWcmBVaP3WDMpBdLBDNuRMOIucwVDU+H7zf+y+v3QscWkd?=
 =?us-ascii?Q?GZsO9ZC0sPEQOAa9dSv6/Bn2/S74qYCtCzIRVsRD4kH0LDWiAHSOIYQsPqJ/?=
 =?us-ascii?Q?ItAmQqgTy8byrGx9FSwPOseRW9bLQEtBTixfVG9CuiVcJGD6ohjFX8zDwuuS?=
 =?us-ascii?Q?Xa7Iv9VYyBTfdn2Bx0vukdbIkHbbbv76wMOnb/td9waVbJMVe/7RcclOssRI?=
 =?us-ascii?Q?nFSBzaB2Wt/0dG2/BZigBjmA8no2i5z5FFPr23E50lnomtfJqkFO3wdY1Q6X?=
 =?us-ascii?Q?f/ijf/VDC1zgG/BYWoum4TuwE/Bxn9G4JLzMla5IREIVM37L32wi19JQBBNb?=
 =?us-ascii?Q?GnHoRwIjFzuRaY+iEA21+CgLRQRBm3H4nPBh8/R5gFcOFRK+vTh+cTQQ55t4?=
 =?us-ascii?Q?ztutb21a8F0XbakHcxpj5lW1uzlrCfBpGelq0SywGS1e1PfmwqX6egu4lIug?=
 =?us-ascii?Q?tqAgJjTaNUTHqP49XOi7o1sBJzOmdIqmSQpvHR54jOHcJ1rf5dzvUnNjTKTJ?=
 =?us-ascii?Q?v78negyBo6r1BJJiiEYx9CP4JRRGI6b/0smAkaUqGUvnArn+Krk+S0USGSwK?=
 =?us-ascii?Q?+5VtY5v2xbIPfX948AlbqRoihVTVU22UVLAaw4QEC+iI1O0i6UeKWFalZuNF?=
 =?us-ascii?Q?BCp/9PXavNVtTcwA+gxKmYkxdVTE0ZGpQjzLUBwX2Gsc1NcOR9/1DnOmp++7?=
 =?us-ascii?Q?JJXg5m3OUtYAZ4NVfJLo0tIvmLRp4p10y0fwJPVM5WiTAHzVKV0briImomhw?=
 =?us-ascii?Q?8jk+G6/FFilzEVFmfDe/rR1OHtwE9UbbANrQTGG5UneOlv8/hntckH0OSyuY?=
 =?us-ascii?Q?KTMS4mWfxQvaWN8IwXiMb5wjEGkDJxHSEQ4359unenPVGleAWQ52ts4zoRSZ?=
 =?us-ascii?Q?GJcNpIOx/of8vU7yKKMxFQDnohGArFthV+vjlGfEON8C+IYM/aQ5pwXk7xEm?=
 =?us-ascii?Q?4XvPnsxbhiG6rU64zxTmMBlw52iwdoOPJq0ByCumLVsXDfNvC9VUIBTk81MR?=
 =?us-ascii?Q?wniwz4T1Na/vVYGjAgY5TS+q0XF0SjPZj7aMXJoJ3wvlkttohh6fza3fArAu?=
 =?us-ascii?Q?RLA3Ro2BnKWAm7h78nnQrSXl+rg8f+KcSUgYs+YsGD6Q9taI93jcT01aZXpZ?=
 =?us-ascii?Q?8rd8ZjTOVJGkqx+ByknQNWo3u3TQuQPedl//Gvb0142FwxbVKA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(1800799021)(82310400023)(7416011)(376011)(36860700010);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:39:55.3198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c477c49-dfdd-4235-f697-08dc91ef4123
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F40.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4059

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
 drivers/virt/coco/sev-guest/sev-guest.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index fcd61df08702..ed00c21ca821 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -122,8 +122,6 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 {
 	u64 count;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	count = snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] + 1;
 
 	/*
@@ -345,6 +343,8 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	u64 seqno;
 	int rc;
 
+	guard(mutex)(&snp_cmd_mutex);
+
 	/* Get message sequence and verify that its a non-zero */
 	seqno = snp_get_msg_seqno(snp_dev);
 	if (!seqno)
@@ -399,8 +399,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -447,8 +445,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -499,8 +495,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	sockptr_t certs_address;
 	int ret, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
@@ -596,12 +590,9 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
 
@@ -626,8 +617,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		break;
 	}
 
-	mutex_unlock(&snp_cmd_mutex);
-
 	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
 
@@ -724,8 +713,6 @@ static int sev_svsm_report_new(struct tsm_report *report, void *data)
 	man_len = SZ_4K;
 	certs_len = SEV_FW_BLOB_MAX_SIZE;
 
-	guard(mutex)(&snp_cmd_mutex);
-
 	if (guid_is_null(&desc->service_guid)) {
 		call_id = SVSM_ATTEST_CALL(SVSM_ATTEST_SERVICES);
 	} else {
@@ -860,8 +847,6 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	if (!buf)
 		return -ENOMEM;
 
-	guard(mutex)(&snp_cmd_mutex);
-
 	/* Check if the VMPCK is not empty */
 	if (is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-- 
2.34.1


