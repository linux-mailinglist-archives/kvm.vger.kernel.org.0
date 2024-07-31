Return-Path: <kvm+bounces-22773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D1E9432BC
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC3B0B28800
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3ABF1BC08E;
	Wed, 31 Jul 2024 15:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O7/BqpCW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810F01BC076;
	Wed, 31 Jul 2024 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438522; cv=fail; b=tmoHAHJJySfB1iDKuxZVOZ48o5YLoe/GtbaTc2jsi1A0/9ETMVmuOhDgsjukDzilEC1BQuuUOvcx7V6EEbGagD3e8NgrhnQK/qSlFUfhOkTmACkOvSOqhAyDKG6fn2S86XDAj0wfBa7WHrNMJvWN/UDGECLEBqwUJRZuICNJJKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438522; c=relaxed/simple;
	bh=apqqWgOfktwH1fXodVikRqHcQoXPo7DTRsEUrrc5Pgg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hmcQD/PQp3YCTw2mGhG5gOhQj7pn4QmGQytuvgUKPp+GyRcshtcpQ2bvHIFDy8y5PFJjaoEbajrtOHsnDj696gal+WNgH2OvVMusZb7jTqqlhKBwXmcfB+El3xRHAD8KkyeKi3WU6xAeVDeUj05ETNNkbuAaN3T6WEELgZRkKKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O7/BqpCW; arc=fail smtp.client-ip=40.107.92.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BCB3jC0iZPbfrsq0cQ+j9PQApex2RvGF6yGh1hV2P4rvrSWIqOhUQcNlnskG9THzGxJJEl8uILjbwxwQ6OGvQLsrKc8NsQmF7YbSMYHIn0p7OMwolSJ40jl228OblxkfTkFy1dZbi3UyPjWLucOcVK61zcRpEbou4RNpoTV/vlrHbxuJzjuZvsyM4P4v7s1Rqlicru6PJYEWwuBwPoHIZ0EbJY3VhYh3iZvIvMoRL+b9cRytpNrkZ6N1iHAZTmVmaywdx6lYdNVzUqzZpR4qyyuk/AiLCcDa3kTqOn6dP9WcdYUkmvCMyMTkraNEvXwmIEuYHrQ3h8fjELPBItx6WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sI+KQmNa1O0s/3SQT0PxzoU7ph/iN3D5qTwcnH+7Qh0=;
 b=X8KvYstJdW5qqDrTG457TNFzcm+jcEdlnR7p0C6O29GX/EbB8r1sSg7R7QZ6VRZMX2q+z0iBhtD+qnKFd4MDgKicVCDltWvNXtwnBAnbw8uRSQG9oABdrpVT/CVbzSgVyB4+TPytOmwXrPwRMkwQ9QjGDcJ+pNLgD2k76be6w86eFkI3p0wgoX9VRegkPZZkGuc7Qk9vRctGr+3WPGsuiGDhrQts0Z4IBDbSnO7TN9XCGDzqHDYvug1u1MP8cCJ/hokyX0MLm9Bo2QO6WK1kN8vMuQA33oKtkKG7w2Wh0Ew4XD1VUqOAsE18FOYNXPsmKvMt0qHAiHKVVTz2vfrJgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI+KQmNa1O0s/3SQT0PxzoU7ph/iN3D5qTwcnH+7Qh0=;
 b=O7/BqpCWZKkt5KQ+62Yu5TVR/mRN2foJncToyUIQ0eO4F19SaPIi27ZDdsGSYtl7dZ4I0n3vMlqRwP2YaBHGdOZcj6eIaXdbLu8lBJknPEtnVXeTIRp7eU2+fE5OsmQORHPFMWHbR3f/c9VN5gALjPfYN5Rrnfej8GQOD+RuNcc=
Received: from CH0P223CA0020.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::10)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.32; Wed, 31 Jul
 2024 15:08:33 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:610:116:cafe::8f) by CH0P223CA0020.outlook.office365.com
 (2603:10b6:610:116::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:32 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:28 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 01/20] virt: sev-guest: Replace dev_dbg with pr_debug
Date: Wed, 31 Jul 2024 20:37:52 +0530
Message-ID: <20240731150811.156771-2-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|DM6PR12MB4402:EE_
X-MS-Office365-Filtering-Correlation-Id: db08cde5-cf2b-49ca-e894-08dcb172a4e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3Zw6dlHh/khyurWK9U/lcw4mRLrxWjWqOWZRkAlnGD6t0S0UWR2dYe8immiy?=
 =?us-ascii?Q?M8O0rICLUdIWvxlgA50vg9j7+jKyk/1u2ugNEPSvJiKTjIS0mvFTxAaIoh/h?=
 =?us-ascii?Q?RpdhXHRyq2M1bGfrUTYutMl06YWEVMfYSfiIsRnIvcjDfutNdrzUCoy6qQqp?=
 =?us-ascii?Q?nT/Jh8poNgnzuOBqt2702kSpbeOqjNCEVha5YZrtWzoiBFHm9A3m24o4W5ES?=
 =?us-ascii?Q?23EAOVi3/lt7tSPd3nHM+WF+HMbYSJwCk0AJrMnnNRp8vieSwbnPWKiMZ6q3?=
 =?us-ascii?Q?LrE4LPgyI3wOrsVp30NWWP2UZMtAc6KkBrVwIn7/Qkq53AJyFkl3Vp8Pcl+7?=
 =?us-ascii?Q?gy/um1eVXlaqG/jzIpZluSyzFroAzHgaCI9n+W984X8BwjREE1w+0drcD5ik?=
 =?us-ascii?Q?GWtTKeZczc42rmBJgbSXVt5SDL5ElUP7AUujGRsOHVYcl+BLyxLbtxfPZcRJ?=
 =?us-ascii?Q?ClNCo6WEhFZHf8CHPin8VU9FYZQanNnYJhybhwJ9umO9ycbZFB5+OG1LpbCI?=
 =?us-ascii?Q?i/9w2VFoFUU4mVRbgIebzqfPk+gODZBg09YM1Ivj4TWADz1DqnGQwiOJcjy+?=
 =?us-ascii?Q?xa0jD2IhcOLrmjGwPgYvh6qrmFHbOj5uUvOXdILi0Z0WhPIx3zTeLaiwmUDG?=
 =?us-ascii?Q?PIRiV3FtOAx1Rsu8DCUQzLajuJXFQIsXliMvGhbQgnPHf5nVxyLl83A/U4Ob?=
 =?us-ascii?Q?IyIG4pstjWv56SonCy9LUR+SzT8P4kGSA5nkwFRdmEpbA3uowLm0obpWu37u?=
 =?us-ascii?Q?z9KfDE6qptwVHvp2BQD3Y7Xu5WNgAmmBZcoIqvnTKJNON6UjMsTbT5rYOQLX?=
 =?us-ascii?Q?S1DRr1+uxqS5D07MpfptE93GHoLQDnU/UmQv/P6uejyveLtZP8g7oyLaURE2?=
 =?us-ascii?Q?UZiWNE4hIPkx2Pf//IaXiZt8qm6BKVCfQuKfvQ9pRaX94600gpQVaRHRd7fh?=
 =?us-ascii?Q?WBSR++nm6UwLx2OWDId/Eyy8bjH8mg4RyeCBDq9Pt3cQV1Pc/XyBLF+K2Waj?=
 =?us-ascii?Q?EOgdEU2Mcmk/R2LDV6D8Fa2LBjaJlLXVRyXWWPIV+hco2mKrGdWirZWjbowG?=
 =?us-ascii?Q?E1AYS/QY6jfd8+yon2izieGpAHg10nBDO8PEoaaY4ryR1GfFX3S1eHAvI9/5?=
 =?us-ascii?Q?qpT3VY5nfrJu6QdXjh2de2+kT0cs9o7RgQxCAAUJHxLWsO8tU/8LG7RuLH49?=
 =?us-ascii?Q?eFqo/JkjOBGnERaZh36IbrIS0jQvEcAy28drjxPfoUIv2ZcA/iZiKU2WRLYu?=
 =?us-ascii?Q?a+JoLC8XEIX0G85FnS0WoMQDhceDUr9YpfSmnjSmk5CHsYuJqvpmEAKBnxtx?=
 =?us-ascii?Q?Y7hj04XCZOxkhbs1NIBlpXIBk1Zo+yyHicwRpABAiptHgRt+nfBOU+cOsGL7?=
 =?us-ascii?Q?AM77brZTG9yHTQdiTW/T5glxdQW72DKz6uPlU2/hea90BGDg5Cl2fr31idIF?=
 =?us-ascii?Q?V98gJ2AIHjog+I1sS6oGHICP4pILGsYP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:32.9033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db08cde5-cf2b-49ca-e894-08dcb172a4e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4402

In preparation of moving code to arch/x86/coco/sev/core.c,
replace dev_dbg with pr_debug.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 6fc7884ea0a1..7d343f2c6ef8 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -296,8 +296,9 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
 	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
 
-	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
-		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
+	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
+		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
+		 resp_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
 	memcpy(resp, snp_dev->response, sizeof(*resp));
@@ -343,8 +344,8 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	if (!hdr->msg_seqno)
 		return -ENOSR;
 
-	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
-		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
+	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
+		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
 	return __enc_payload(snp_dev, req, payload, sz);
 }
-- 
2.34.1


