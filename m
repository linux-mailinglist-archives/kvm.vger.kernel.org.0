Return-Path: <kvm+bounces-28206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E442996563
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF36F2811EB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C4318FC85;
	Wed,  9 Oct 2024 09:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kMNx58L5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDE718F2FB;
	Wed,  9 Oct 2024 09:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466175; cv=fail; b=jSfDwMQL2yu2fBQgrRzV6BjEWgypoIusG205RzsEFPU4O1CUD6aiv8S1rZSminJMJMRZaJb6FAd5uYcFez1/s+880j7kk/wu3uCc16A24fK26+baqklOgo/I7SCLFxulKNXzmHvzkWdSxFREZyora087uHuGxzm8QuUc9/xUTjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466175; c=relaxed/simple;
	bh=o/6AhPVwyqeUl94NBZjr66E1BmydBq2j39gihku7/hg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fS6TEYhKZmVnyv2ium6AArW2Xfaa5dyHW1KkMs2YQFdvP2rYfT28+7a8/+U3+qX0zFMEAPwPhcMt3oEQKUAHmo5DbgQvh2R+zqU8Kn77RpZwFj9thj3J3W+I+cMQAyOZYXpQS9aHBKcYQyQa+zyuL8aVGWGEdgz++IRo+NCGanY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kMNx58L5; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lrVY3KzsysmYEZOwvvF7xlcKmLMngB9XvXX1u7Ie5NZlmzqylo8fXvaSE2EfTByqsmunnG0UqqE2s9l9WvJ+BFQW0XIzfxialy4S5cK8Bjv9c64YxpBU1a1BWNXcCl65hyl9Fk/A+jTtsaewPnWQ3+J0znCyGYPjCdtqbZw+KBBV5DtTvNMoKS5gSRt8mabytoYkJdVPF+pbek0pEs3fpXt2ROP1k39Ufhdz3teAenx12dE+LoMqvggxMdD1LKeMsK6RfRt6pcIsdmDOBUkC2VkSYfMjP6tX81xALc5Vu82jwd9WrNUHIRSi/A6iL1x2pfXVxWAxnZjHS4TZujRU4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UjdmSX5W1Hyk0hbh5ld9DBv55Wdk8K0oJsrX1zxfuE=;
 b=OhZ8MkmhsI88d665TbV6PsnMFEYW5cLDQID/otXV02gieFpTrkZk1DuLecr0TYb26cr9kfM7ZeedY+mh9Qw1phjlpdeJl9b5EM2+qc4AXMvYHY/pu4P3r4vt/ztmgNjK33X8NX6j7Ch6AD0CSKbUK9+ga03nz1YNNqh64Ya4NfpdDyHrA4CLkEDQDG5upXE2FAxkBsxCNwOkUpcckjZUcgWFsomjI+DvQFbVMHbCUHR+Pl4nW2XpmA4LsR+i2NLWYfuXY+18GvLIk45oz6R1j1cQJHXyqOvUOVxeY62xZEinAJ8gIMtS2XYyoFsF54VpX7DpoMOqLdUgEDfY4u7arA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UjdmSX5W1Hyk0hbh5ld9DBv55Wdk8K0oJsrX1zxfuE=;
 b=kMNx58L5Wkc9gN7Rb9B1GXzlYwUtWLKO5gUot8a9eFVpQibzCXDupxA0bygDBelpBkSCWltQZnfKNWZRdpN1vPfHO/kBdsNdwx8mBdAIM8clFXTsNUsrrE1KO6xpdnN9QLcVdMEi/LMBGF3Z/tqa06X0G6NetrNkcu468kg5vxs=
Received: from BN0PR04CA0101.namprd04.prod.outlook.com (2603:10b6:408:ec::16)
 by CY8PR12MB7658.namprd12.prod.outlook.com (2603:10b6:930:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 09:29:29 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:408:ec:cafe::c6) by BN0PR04CA0101.outlook.office365.com
 (2603:10b6:408:ec::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:29 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:25 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 05/19] virt: sev-guest: Reduce the scope of SNP command mutex
Date: Wed, 9 Oct 2024 14:58:36 +0530
Message-ID: <20241009092850.197575-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|CY8PR12MB7658:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ab2b70-f68b-4500-e8ad-08dce844e003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1i4aUxa4HTFKLD3jRB1TJ03H4icX5dDGCEPC7psqepbw6B0hgr4xF3RvagQI?=
 =?us-ascii?Q?HI5Em77j9raz9JeByeF/vM4cWhMUxYvqtkEwG88ys/t6gqwZRzNl1CtTH5K+?=
 =?us-ascii?Q?LqpwpY+KI/voj3A9hzL084EdhR+XiXOe4JK7MJznam5+wvrsLUxJONIUcZ0Y?=
 =?us-ascii?Q?YrltPTm1bswwo0/bQ8HCcWOYE/5QkXnjJovl/U7Jn2cX0AkHSw35Cr9s5nbd?=
 =?us-ascii?Q?0iu3z2pwGWkLFyqmbZYw3Op7Bxr7WL3HJySgkKlVw2Ne7Vu30YUGee/GSbOp?=
 =?us-ascii?Q?I2OfKncYEHIH5ckS+GY/T5dUdJzmbbyCWHto025BIZXirLvV1GZeUJId5qgk?=
 =?us-ascii?Q?a9mBFYiGHIYjeHEFOj71BYXEkKTFwf7jtuJQGxovc3fe7HzZmnl5zvXSPjp5?=
 =?us-ascii?Q?eRWrCGrz3vR5/0MIx4aOArIF0lw7tPwbuLzskkCS9fkub4BHbstB2OlVzNfH?=
 =?us-ascii?Q?LhN7sciMhO586GxfagchCFI71bvBO99k2/drOgIzJaC4IRnPT8kj0qhxKNNh?=
 =?us-ascii?Q?PjL81Zm6YVlvRYGti8upH0HbTHDGsS+1crQQHP457Rz+tw/S8qrPHvPHM929?=
 =?us-ascii?Q?tgAkeCE8AHaynaU7EzZ+u2mKespl37zbrcfZ7QOgtVpRtD5BOnq5GVKHZECM?=
 =?us-ascii?Q?bXKoQD/c4icqmMjTv6TWvrxOPZGSrtCXGfY/CpI7tOdpsp6f7b21P0cPy0xT?=
 =?us-ascii?Q?jtAYy0DvGivyKzjxNe9G5djme91proaeGX16LsWP9OX74jtGxBnlqTqJJ2Ij?=
 =?us-ascii?Q?w/yTCeZc8M6QFeqoUUsyEinv6Bazv1BQW2VxrJroKzbumwn/XMKupDpa73UD?=
 =?us-ascii?Q?24udCm4mQObuDRQyfVzpTrf4O103qCXMreoRMCBWvQaG2hfIDOAGbeMdktqF?=
 =?us-ascii?Q?jflLxEAJXZA6hbGtp1sW0KwvDYxX2mERrsyomz11T7j+ndpIAQG5VAiJGYcG?=
 =?us-ascii?Q?7syEKTTd3+VCHXeZViXXo74IoqoYAMF8OAfkU7MwoAUfcm02LXuzlekgfhWt?=
 =?us-ascii?Q?G/g8fo3cFBYPk1jphnjKz+LTlK7rTDAch2TTXbmvDdccDbdzN2egRD1qbGwr?=
 =?us-ascii?Q?hHx9ibllDN0ohtALDWlZUG+UaVWvdq11RlydMchB5T2hp5BimvDkaLEpLoGM?=
 =?us-ascii?Q?Ml56h5PvzHWMCecZCqvGMPWxFIMfIZaFZwPXSUVPo8hZcHGot0eNxN/c8TV3?=
 =?us-ascii?Q?u3r5Zn7LIENbBKNvpjOx9ldRWdB7KOFURwiyWhxfAIMRfEEK62D4LkPkL+Dg?=
 =?us-ascii?Q?xEdKlvydV53YQRyB88cvtv3d57ClWQF8FwVu5pR+1ShUZbdbw5C/PRDrx/TR?=
 =?us-ascii?Q?fiP+Hmetq9j4Y1eLjf3DSrVOnUVgXVM5uQPas4KKLGOSJRIkbOyz4YR5+hCC?=
 =?us-ascii?Q?WA9pUfkfvfeQo3U/DGOOcpgKE6Dr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:29.2603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ab2b70-f68b-4500-e8ad-08dce844e003
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7658

The SNP command mutex is used to serialize access to the shared buffer,
command handling, and message sequence number.

All shared buffer, command handling, and message sequence updates are done
within snp_send_guest_request(), so moving the mutex to this function is
appropriate and maintains the critical section.

Since the mutex is now taken at a later point in time, remove the lockdep
checks that occur before taking the mutex.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 35 ++++++-------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 2a1b542168b1..1bddef822446 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -345,6 +345,14 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	u64 seqno;
 	int rc;
 
+	guard(mutex)(&snp_cmd_mutex);
+
+	/* Check if the VMPCK is not empty */
+	if (is_vmpck_empty(snp_dev)) {
+		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
+		return -ENOTTY;
+	}
+
 	/* Get message sequence and verify that its a non-zero */
 	seqno = snp_get_msg_seqno(snp_dev);
 	if (!seqno)
@@ -401,8 +409,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	struct snp_guest_req req = {};
 	int rc, resp_len;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -449,8 +455,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
@@ -501,8 +505,6 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
 
-	lockdep_assert_held(&snp_cmd_mutex);
-
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
@@ -598,15 +600,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	if (!input.msg_version)
 		return -EINVAL;
 
-	mutex_lock(&snp_cmd_mutex);
-
-	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
-		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-		mutex_unlock(&snp_cmd_mutex);
-		return -ENOTTY;
-	}
-
 	switch (ioctl) {
 	case SNP_GET_REPORT:
 		ret = get_report(snp_dev, &input);
@@ -628,8 +621,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		break;
 	}
 
-	mutex_unlock(&snp_cmd_mutex);
-
 	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
 
@@ -744,8 +735,6 @@ static int sev_svsm_report_new(struct tsm_report *report, void *data)
 	man_len = SZ_4K;
 	certs_len = SEV_FW_BLOB_MAX_SIZE;
 
-	guard(mutex)(&snp_cmd_mutex);
-
 	if (guid_is_null(&desc->service_guid)) {
 		call_id = SVSM_ATTEST_CALL(SVSM_ATTEST_SERVICES);
 	} else {
@@ -880,14 +869,6 @@ static int sev_report_new(struct tsm_report *report, void *data)
 	if (!buf)
 		return -ENOMEM;
 
-	guard(mutex)(&snp_cmd_mutex);
-
-	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
-		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
-		return -ENOTTY;
-	}
-
 	cert_table = buf + report_size;
 	struct snp_ext_report_req ext_req = {
 		.data = { .vmpl = desc->privlevel },
-- 
2.34.1


