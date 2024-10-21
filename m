Return-Path: <kvm+bounces-29232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D4E9A5A07
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D25FA2820B0
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CF31CF7C0;
	Mon, 21 Oct 2024 05:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ne9sbKsA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA9E1CF5E1;
	Mon, 21 Oct 2024 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490280; cv=fail; b=c6B7ZL4067m9B0oFy3tRovQ/vX7TYb1AVN/Ys1VJx4BLUQYQDSQxyhWDmzRTFIG1kASQHjV+rztbB/BIDb+u0bOceSYdz4qdNFJmRsf0KxQvJY5Or5OJMenoz/ZvUEJBCbHXv/X1FcUa8vW1KaNZ7tN/bjrXY/FSgIoqRN8XCkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490280; c=relaxed/simple;
	bh=wTiiW3zg+ZEXEs6HyoUwSSwd2a1sEJVoTxWCh49OUQg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IhUpztMP7gLAB9Rl9LBIYlmfxtCQykeBQSnQveNtuQ3AW6l2Gpx2Ar+HeX+xv0YfmraL9FYk9RD/tNTwhLiSsWEf9P1GJekyEEmgTdq4N1D6z1uBE5IhM4TFQy4PHz5BTjQqs/4tgrZa5osgcYU9ow92EJUkdSszKD+jaBr0tSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ne9sbKsA; arc=fail smtp.client-ip=40.107.237.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xOSU6zK84t6IdvsfjVtV+1aeElsbwN9SfBgljnatFTu0JVjoiu11CZ9cTLJholNG5vqaXHrGKwlQRRQKCAcudNICnwel+4uIRf99sPwdMh704R62wDO1QeBWfaWqjMlrzsrnVvLhzhYZdWPGjwkQewpUOT8lGWiVl5iLWwBOUntW+MROUpsTn/gsGquZIUUvq0pHXs51gf7E/r+jTAYucMoCp9C8LeqaqttFl4l1SVY18yCb1hOcVHf+9XpgFDDGkaQxLdNuKelabsfZRu5ncoE//w2dKkQx6pbpH+6anvy0+1bH9UA+ZcAkGeNUZxhVqIfuRYEknXSmOYmyp0G0ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJbrswFKIOzOu5VNK+d/iLVqlwq3bvmZy+UUG5Gjm70=;
 b=kMsH56VEXhmZAvWTdMSovWATaPuyND3x4PXHfQjKJ9W5u4I9fklAx7VmJlw4Fp4I+FpMoOMKKOHZ4PGDIQANIP33tGeKd3bzg1AzJ43kkGHZdfX0hcHl6cPKcQ1zddhD4uBu9d5Qv6xmYnC/X4gDBhCvvwyqebP/IZ1o3/zHJpabhqY5UxHnlIHTljVDLE0zcT0jOF26zZsHl7RFa+i9Ri8ysSopy7XgoO1rz58MJTsEsaqc8zlZJeiFL4YqPbjVH9IxhNPojldqcKHDfuDDEfbKYcfjvlYkSAawsui/zMazp16S1ykavp2vRaMFHLDJwXdoYjAmJvSoIPtlXdSyNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJbrswFKIOzOu5VNK+d/iLVqlwq3bvmZy+UUG5Gjm70=;
 b=Ne9sbKsAlTdhyrlZ4DgqM8VjBHE1GXa/b68aLZDCCXSu2zaS/uGuXy1g0k7mp04xTs7ExebdSFBNwi6Aw1+LaCyc0JWJAubVl4XkIPkkAhXFQR7ddZnGfR44p3ayNXisFIiNjzsP32jBI6TUz8l0IdROFQcValPCI3TqX2rxMcc=
Received: from BYAPR03CA0001.namprd03.prod.outlook.com (2603:10b6:a02:a8::14)
 by PH7PR12MB7796.namprd12.prod.outlook.com (2603:10b6:510:275::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.19; Mon, 21 Oct
 2024 05:57:54 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::4) by BYAPR03CA0001.outlook.office365.com
 (2603:10b6:a02:a8::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29 via Frontend
 Transport; Mon, 21 Oct 2024 05:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:57:53 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:57:39 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 07/13] x86/sev: Mark Secure TSC as reliable clocksource
Date: Mon, 21 Oct 2024 11:21:50 +0530
Message-ID: <20241021055156.2342564-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|PH7PR12MB7796:EE_
X-MS-Office365-Filtering-Correlation-Id: 3669d558-2210-4608-53bf-08dcf1954dde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1QwyJCDkbQs+/RFGoZFnbU11ntjkeCVnib06sq8dD6oUSEQP09ysY4fpvHrn?=
 =?us-ascii?Q?vAYWvjBwLfMRvZxEN/+IyLrnOO8ctD9ysDKhJJtqL9RZWPWSDDjJ0MgUGikA?=
 =?us-ascii?Q?o+jfu5uyg3jpkq7AOumxMuPgbaa93GkakT4weEVMkvFlNa5G3mjbAjbfuC3s?=
 =?us-ascii?Q?sQube4V3Wdwdc6S4sgYMAF0nhfxXnljIfjg4rlXbt2j3WFAiusrtoa7EtQLQ?=
 =?us-ascii?Q?KZFAffjTHpFfwgaS7RNRNpEBRr3sGIGxE5d0VEvqr/DfKGqrcNBQWBntY66J?=
 =?us-ascii?Q?RpGMrCgz2f/lpO+yglDZBNVZ+090Dc8Pd9u22TW9YcO2+CMeFIle3kNClebL?=
 =?us-ascii?Q?GkjM/9n5nxPLsGqiQL/e9rqyMmk4ND1QrAQR/YN3ek9o9sB+XLfMl5laF84A?=
 =?us-ascii?Q?WD14j59oO1GlqJiSV36moA3e/DG4feHnxHurAwN5D/8Cppbf3TxYZT9ZTlt4?=
 =?us-ascii?Q?0aqmdIOasNTH+YokaUTLr3qqcGWv+YOEDyLOma1itvuQFXEDzhIXGf4Qk/GZ?=
 =?us-ascii?Q?O/S2YVDe9oXaCPxzKAuC3ISyF0E1PlKVf4TmbxDUQi9Eq2HeF1vjmOZfo9UH?=
 =?us-ascii?Q?FpcE4W/Kd6QQMDnaabCF7N7kmEKi7NZ08bB7ghigq0TbU+O4soUMga1Vy1Al?=
 =?us-ascii?Q?Y8htthVKBEja2fCJSCBQZxj0F7HX+2zMTW9uEbMXWuII+6drRLQE1FZqh+tz?=
 =?us-ascii?Q?ydvmtLKG9dE7vzQlAGfHWg6qSS22DLIPWxCTPiNG3sDVYHarEohsYKGN6j9f?=
 =?us-ascii?Q?GGTSp/H7QLkK1evF1OWxsnrC3RMi3cL7F9RDw1cEV4KXNdQQ44Qwi9WBgNjw?=
 =?us-ascii?Q?/aIorMw9UlGNX9CcTgX9dzOgRErlUhEGBmItacaOGxuOhCb1bt23qFAC2css?=
 =?us-ascii?Q?jTadO0iNZo7BCa91P73/jqTv5F+5ACcNwdkql92V20Ow6u6vEDqoM8vyUDhL?=
 =?us-ascii?Q?xoalJq0hD39xY3b0/AvYuup3YZoFmtBd03heYhTH0Awg5xso7U/FOmeBS9y0?=
 =?us-ascii?Q?s3QhN9zW6LcjJXSPB5JteJRnGgpGYG9o5hYI5hdfLRTSEBjK5Ol42Qjio5Vq?=
 =?us-ascii?Q?exax1k86uwuBw6IHDwq/9WYT3HNCE49rAwq0M9F/HH7cMNYBrshhXdkVozIB?=
 =?us-ascii?Q?+FahxbJXLiUa1taRWnhGfTBeE+TSBycrvsvR8u1IC0kax3jzQEzpMVpTKhkr?=
 =?us-ascii?Q?3oGNWhbmQK1HbdK9U24GIVmqaX81kLylfWJCzNoZIfoFDbVYkF3ezmx6pIvT?=
 =?us-ascii?Q?jMEbiSTORXy5p312W9Qrc2ClnnpgTznOYolZrwzSpijfaiObvZRxvNAktfsx?=
 =?us-ascii?Q?5TcOeJeC/1KUUecbR1dFc7qKrbie1ssmPGoR3XyCqOvNXh7T4gQs2y2a4+ls?=
 =?us-ascii?Q?iVUJviBCTRQUzf2wKf9KXFpSpHvS0bhbcPKJYa7dc3cBCTAVwg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:57:53.7198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3669d558-2210-4608-53bf-08dcf1954dde
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7796

In SNP guest environment with Secure TSC enabled, unlike other clock
sources (such as HPET, ACPI timer, APIC, etc.), the RDTSC instruction is
handled without causing a VM exit, resulting in minimal overhead and
jitters. Hence, mark Secure TSC as the only reliable clock source,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 86a476a426c2..e9fb5f24703a 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -516,6 +516,10 @@ void __init sme_early_init(void)
 	 * kernel mapped.
 	 */
 	snp_update_svsm_ca();
+
+	/* Mark the TSC as reliable when Secure TSC is enabled */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


