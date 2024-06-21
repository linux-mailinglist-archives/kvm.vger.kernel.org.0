Return-Path: <kvm+bounces-20271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E0B9125E0
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:48:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BA951F23096
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D18155A43;
	Fri, 21 Jun 2024 12:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PQCnAggQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2BE17B509;
	Fri, 21 Jun 2024 12:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973658; cv=fail; b=eZ+1v+JGCBNecVQPmjf0MoHnn8Zzz02i8fXNDOw2goCbhcC3crrdWSCnACgt0sdeQieja85cnPBGFnViDeVW0CtYyFqfwnPbKlAXyGNp+HBwQTLsL84RBQaqUu0tM9s+P0KvT864y+jOgKTxR15fYvBCFuWe/TQKde2BF/UNjVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973658; c=relaxed/simple;
	bh=cAC/VFJ4wEnAQpkNDwUveWrurfRumjkFBldmm9DGTEY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGeeHmT9ByyUDGifLAWgs2cpLTLShXoqUyrY+E3cw+rof+kY+j6svcTlBFW3OFjD/zd2wF+Izu4QqzPg1fSxi0slIwDbBqF+jTtYrlbMVqFA5qeH87ZnYMgwtpwmATQcJKbZRr7pmCoNMvFUh2MxUCfr3A5Rpytr7NkGc1Ox754=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PQCnAggQ; arc=fail smtp.client-ip=40.107.244.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRsaU/3AtdCbcAz2yZvrvKMzSm1cy9kQHrNcDQGXEPXk4FBOs0OwcSsIBIjGWlMM9lA4Mvsgm4UKWS5UkpI/RwoAH/rZPijb7HmORWBtIk8hb2DyOBX2prR6WFguUa0C0Xi3ETz5iv4vOhHDCSuP7ZLbRA0i+HLOD5PYsfWhRMKIT2Mq0kiinv6ZJAO1lznBVh8f2asxcevn/qkgR2eAaMz20u28wL09bZCKSlecrmHl+RnZnuCG5KTzMjMMakjZj9B3/H540L+CDI31PWHQnzUisjXpiU6rangcPSTbwrpZD0ByNZnryLon+j/qhVgJYLjWhWpQVj7QYfnRnofLiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNKGJqPN3gcI3Ygqznh20qY8AnS8F0rxhXhh636gblQ=;
 b=hhM2ftJlKfmJMz4gDrCcggQ8CxnzrfBUox8MQtjMJHIHyXvzzSftiCjakqwtYEQlizbCGkJOOWVfsLfXrpOEXaFzIWzxJjOniQyMDbGy5IIe9XmtWpRnszDommUwj4LlzQq7sNSKU/3ihHnuXupfUnjhdZL6PEK0BlYC9o4Phwz8rVA98yGRtzY/rq2taqAR8BtarsFxSc8o4nZZ6UkGcuVWLavFn2UgFfm3/LAM4m8o/n/uTcrc/YcXDyiS7i+rTIO/r2iGSTbUGHKmdPcaEymlmJqYIiaN0VFiRavLr6ufb24gyCVc+n8hbkcSjyr9XCqmNfxTpEAz7B9JDoM23Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNKGJqPN3gcI3Ygqznh20qY8AnS8F0rxhXhh636gblQ=;
 b=PQCnAggQ/RPx4bfBz44YzaGhEvbjzXr3tZ5DRk2t1fohoAOn/S+Sw6APEBJAt+7o2Qg7RXBglgeODwKf49La/so+jfoOcPVH9XNs6HBb85Idlpc32beiWJLtSzex+cv7mRgawereGirwG+po79Am4abjDnHCjhR3oYjpWs2tGXE=
Received: from DS0PR17CA0003.namprd17.prod.outlook.com (2603:10b6:8:191::17)
 by PH7PR12MB6761.namprd12.prod.outlook.com (2603:10b6:510:1ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 12:40:54 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:8:191:cafe::13) by DS0PR17CA0003.outlook.office365.com
 (2603:10b6:8:191::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:53 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:49 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 24/24] x86/sev: Enable Secure TSC for SNP guests
Date: Fri, 21 Jun 2024 18:09:03 +0530
Message-ID: <20240621123903.2411843-25-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|PH7PR12MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: beebb753-087b-4c8c-cf2d-08dc91ef6387
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|376011|82310400023|36860700010|1800799021|7416011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kB0EO1tiYgic1BSYaWI9QV7BGUv28sI4udalbcAbYWeU4ctrAWX2KrXXoZVJ?=
 =?us-ascii?Q?id0uGygl31gHAQ30/M9M+qn2CfyAirijKFZSJyOT2sEW57vT+OcEp8KXzmQz?=
 =?us-ascii?Q?aAT0vmsa/VfjxwaIVl4k4kfGoTAP9+Fd6QnI2wNiw+z8eSG8UbkeuZG0ENIp?=
 =?us-ascii?Q?DFFDHypIauMqnDNQh101JHDqolxMEPhUWpxpUHx1moLEVV6W4F/VxPoKYggg?=
 =?us-ascii?Q?eWL+EF2tBA3JNLc6eIsoOFmkn6HZLTT5AmumxtmkcEOCz+JQDi4JJHaZ/Odw?=
 =?us-ascii?Q?oVkGCkP3m09J+ymSJFlxxkgrwvi4degnq07rOLXaR4OsQtHpZBmnLA4G4bjz?=
 =?us-ascii?Q?viAz8IZj0+EugmS54nKOwqUAWAS4Zyo9wFkIP6vqPxmJo4wEhYaI/eP6XP7D?=
 =?us-ascii?Q?P0aZ8Fuf3seiBv+BS+8M4CuZnL5fTFIkQ780OoSV3n8f1LXCkXwAyPusDHbh?=
 =?us-ascii?Q?9u/93WqGd7jJxQcIe4Y8jlA56tQ+G4ZXjnd5cpvSknjqX0n3tkv5a9V/4CCN?=
 =?us-ascii?Q?9ehRiMmeZ5pGtVuhC7ZGu6JMOyuBl/PkTJMGhSYEyEzkk5lJA5pPrHUbTCzt?=
 =?us-ascii?Q?N5Izdvu7JfFmFhKWAqtkCE4E60knSpVkaaqe+DW5aG0nUhQy7YxU1a8JKVXj?=
 =?us-ascii?Q?AmuxydSh3a33gbl8l4iIytVODZ4N0vt42AW4mV/YWBvssCSB+yuB76oh5Vzl?=
 =?us-ascii?Q?qv94wpts12/l69md34dz3KW28l/a3/7jx0JBWjYuKrAawXjgDZtZ84UVAkAm?=
 =?us-ascii?Q?QKkrj+E+pQ52xSvRt0TK0yKD2ZaMp6pSHSC9ruNG3IFs5v6lBGGrUY9DwOTN?=
 =?us-ascii?Q?CX63GkcZxgqs+dFSWV9ktAIBmszDQnquQ5PRKWzNre6GEJVZn2ElF72hDHL9?=
 =?us-ascii?Q?RjFxZ//BtRUVNHsgJGdt/FahV8IND9L+0bhc4mxolf8nf3PPH41cQtE75DzT?=
 =?us-ascii?Q?5EwWql9a87S2bxyqpNqgrsOwJw23WQWuXhiWKEwFp5NV23xyc8jyPug/q7qU?=
 =?us-ascii?Q?0P+9kbEOCKDC5sarUb7a1JYhkxtomLfOb/TJr486yzWMH3SeIGuYpck51bgs?=
 =?us-ascii?Q?MqQHJFt38TGh6wHpeDa5BtHXIVmhm3R8W2KbU5CyTW2mapwTvialkebf36FV?=
 =?us-ascii?Q?3YoVnq8xSGlAA/rAlPii6B8MLyFY70fv1qA7Ns3Dx3gs7GQ2sXDvhGU+uhkK?=
 =?us-ascii?Q?XIVMMf//Dyhg85wDLh0BCO66srns/ym6aWE0I5SXCLFwIr4X37TWBBAtvUw5?=
 =?us-ascii?Q?4dMH8w+wixQX8pwTh4ab39LWDtqFFvPOze0syWj0om1FFxpoBVCyVaxyAvJw?=
 =?us-ascii?Q?JCzbCxxyD1Sg4w4grgJm5J7sGegjQuKGQL3Zt9DJEMdLL0eGgBGXj/xWkQ7Z?=
 =?us-ascii?Q?w4zN+XecyClXPc+K1ZvGHEmG9PVBfbgvdF0jGOrJO2cVQexYHw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(376011)(82310400023)(36860700010)(1800799021)(7416011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:53.1573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: beebb753-087b-4c8c-cf2d-08dc91ef6387
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6761

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to SNP features present list.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/boot/compressed/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index cd44e120fe53..bb55934c1cee 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -401,7 +401,8 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


