Return-Path: <kvm+bounces-18470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 536EF8D5962
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:32:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 856FEB2378F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75AC7D41C;
	Fri, 31 May 2024 04:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HxPmpN49"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F132135B;
	Fri, 31 May 2024 04:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129894; cv=fail; b=X/JWnMtGVt22WRa4rv+QKiIQ+73LSPZCuindtdUO8qoOZBx/T6C1VmeOSYY8dQ7WUSKxLv3A8+NNHO9/8myNMZJIKCfQpOI2JqAGZcry1ZrZjMJG8vDC5YKYCCIwp9ZDgI44bRg8KIU+cWNKulN4iFi/K1SFPEK0aF6XsssIAw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129894; c=relaxed/simple;
	bh=SNLYlOC5DNyzJwqEwdYfz5p/eK7UMeIhQt4EQDMoiIk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dg5S42xLKitzAd48/OaGxmtIkveWrEomxm7MGUMnjpywJgf/ITiL5sLdOCJe36xakgnMISoeTtGYiOULY213mSQqDcW2vmhxtpfEbdkSxTy/fODsun8gSkHnMWyyKSYbuWXveSiP+nqcBC0EBFJv+d6faih4z+Pq3xWThmaM0kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HxPmpN49; arc=fail smtp.client-ip=40.107.101.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1Dwsmm6w0W7Ax5D1YrGdA7QH3UXDzrb941jgjdbjoyQVxIzy3F9Aghi0fd/pw9uSSE/GYtdYdWLlNlrdKOIW6gisS1Lhp7DRMQBoWPRpeUXAfNbP3fo/Mo2Two2cI8dYDcjE/0u29AnHr1nShw73nKQ2x1IKbYO2AWNVeIuPoE8MiLo4t1aOCSDk2XhLxDUiLGbKX2isTTJpQtSYNKdUVrGzxnH6w8pG/HnDbW1dmHVpfwWQZfUeUOm1PQZclqpdq3r7hEVSg+VX+AtX2GTDxNu6KVZsjXs7+zoKXuvP8eHXcn+tiFrHHbjthcLSWBDMLxe7ugqB5UL8HvT3JV0Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFn4XLYAV1hqTrSmZJytKYJYyzmtJMlpElBMk/DoxG0=;
 b=JsobFe60JiCHs9GjD+vgbfU+xZRJImM/5dI1UBhMz/A/esWxsmUzvYpKXICe1J9VxZubxVtViTzALSzRSu05/eOWqvGDLCYR3k9pmaq3lAb//hm8MX0w1mP03MsTkhl4IEHAQIHdj1aows1CMQoIfItdXw3c4jFlXS3Cm5GiFpcbBu5CKgNSQVY9YSAUlfDBp2+z6hmheD5OPydjo8wj9Da8ldB+AsByqYVH16bIOmP+qzeuqOBucBbbhA0rdXN1vsAdbP+KbWQqo0rQ7hMNpjRvajGQsj9YZgV4ZlGL6FyUYT2/mDjC4P6xk7z4meAQT0oIE30o56OGK3F/cu5hFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zFn4XLYAV1hqTrSmZJytKYJYyzmtJMlpElBMk/DoxG0=;
 b=HxPmpN49fnQM49HPKciY6coM9iGUT23npoVv9bntYrVPjl3jKLZLZIj2+P1V4+ufA7g6dPAmSaF2WT7FR0e5FgrLz22ADkkAOmqitEj9KVmxnWQi1jb7n6TV77Vx9OcE/QdPGtxtJ3c9L7dUAgqBwV28IZjg85RbVnB+8udRTvo=
Received: from SJ0PR03CA0138.namprd03.prod.outlook.com (2603:10b6:a03:33c::23)
 by DM6PR12MB4313.namprd12.prod.outlook.com (2603:10b6:5:21e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 31 May
 2024 04:31:28 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::79) by SJ0PR03CA0138.outlook.office365.com
 (2603:10b6:a03:33c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Fri, 31 May 2024 04:31:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:31:28 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:31:24 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 02/24] virt: sev-guest: Replace dev_dbg with pr_debug
Date: Fri, 31 May 2024 10:00:16 +0530
Message-ID: <20240531043038.3370793-3-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|DM6PR12MB4313:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc11012-60a5-4ffd-d82a-08dc812a8a0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?52UTv/rrcE4KkVeKDYZqxfTGgd+6LXrgrvExjEDbnbDDc2Y1NcmZCqUT5rSB?=
 =?us-ascii?Q?7gFn/AJwPLooZRXC/zB679TYGo37pl37lQeXKe/IjQCPwbFdVkN6kRq/YdEB?=
 =?us-ascii?Q?ckCnczlKIzKd9Lo4d4jgIO+hPEk99asihxT7fMTIcRFp2MoVpt3izXnEYnXE?=
 =?us-ascii?Q?yYqMLh2zasAtMugrJ2VUAMiDihbQig7NWt/VkiLL5/l0ox2qDOiKJpyxPwrB?=
 =?us-ascii?Q?W4Qx+4oSW7UstiwNZ15NnlLMhiA9u545LynaCxPB1fmeTefqpl4lj3VkUZ6P?=
 =?us-ascii?Q?mZZi4ESD7k5soSJBy64TZiOmlby0A3usGj/wbqW21VUs4usyoLnVgHUHNnlk?=
 =?us-ascii?Q?OIve9VzZ3xZzr0tncQRTKW+i7qlElsvd0OvEZ4vjwp4In9IWro+o85slBrJ/?=
 =?us-ascii?Q?mQTU0gV9FvHM/NR0txP7LqZpZh2KPXor3WTmmr7lGmloJRBiWT6ggWURsCgj?=
 =?us-ascii?Q?FdJa1DPb2rTYcs0jvtXEyqCzHpjUgdy85qGKWBcOANYQ2432f3TOzqlWYXAX?=
 =?us-ascii?Q?vaSpvNmJimP/WsILJ+Qb40O+8Est9N9y7iwhLwiiHY9t2ZdrSCAXslruU//G?=
 =?us-ascii?Q?O4BaxBJsHgH1//LjQtYjBZ7GIXX1lLTM7QiXfYlHzJzcVUR/IRZzPo7i7q6p?=
 =?us-ascii?Q?jKxHgSmGgkIJpMu3JsGJBP7we668/I/eNAIvRSUuOmzNa1rbQFLi13Js8AC6?=
 =?us-ascii?Q?F1Ym7dZ6mWqZtALzI6U5z5F+7texFlZPKR53jpFxnMlygpcRQTclPqLGa+ov?=
 =?us-ascii?Q?bFshcgN8gieYcunUca6teNVS8eWS6mTCWqBZbgCEju4gc4l4eHa4HpanywYN?=
 =?us-ascii?Q?lCBbgmKkmXarvJkgoz5SQX5TZUv8shfV+s9iHSqgpE++/ZqRMFIcqN6O1w93?=
 =?us-ascii?Q?dpQl3Uo9lS08v5eVx4sTLv/A1z2YvZBnS6j6SAHl3HH2pmHqKnLU1uNTSL2/?=
 =?us-ascii?Q?OMnCSn9qK965PS/NO75GQgwOd8/dVNl+Cx3q/o/wEKxn+PBxTe8CuWjLILhw?=
 =?us-ascii?Q?TJ+rpWefFlsSdLTE+4+yzOMYV10KZtfykTf0eSNj51prxvDkW30IGT7PxNUl?=
 =?us-ascii?Q?VCo9OEeIWbzK/A/s7NeJRVwiKggusv6rgdg2uendMBFxHV5VG/e0bWZxzHoq?=
 =?us-ascii?Q?9/YeORaPzz3RbFha6xwzoZLgdeg+YFh6r5TAVBckAyrHl0w41Czy1q8O++sT?=
 =?us-ascii?Q?gA8+l7fXoTWhMbmFoCbKgVMQxB2PTCfjWxsCS4N7uPMqMVN2bUegD/2o8/nA?=
 =?us-ascii?Q?Qlls76XZj3fL3pQ8TN/y7Jsz7wsmIO4S8bfVkH4bmZG/dRETCoC/QReYVMU3?=
 =?us-ascii?Q?9ZGs0YCwxksykH/Bf177l/pHcpVtmsaDAR2CaY/qqwyX2xrutP4EI85SQQjW?=
 =?us-ascii?Q?Tp7c8oI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:31:28.3355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc11012-60a5-4ffd-d82a-08dc812a8a0e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4313

In preparation of moving code to arch/x86/kernel/sev.c,
replace dev_dbg with pr_debug.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 0768c6692483..7e1bf2056b47 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -178,8 +178,9 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
-	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
-		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
+	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
+		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
+		 resp_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
 	memcpy(resp, snp_dev->response, sizeof(*resp));
@@ -232,8 +233,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	if (!hdr->msg_seqno)
 		return -ENOSR;
 
-	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
-		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
+	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
+		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
 	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
 		return -EBADMSG;
-- 
2.34.1


