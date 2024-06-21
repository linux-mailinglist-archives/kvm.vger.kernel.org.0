Return-Path: <kvm+bounces-20270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 321679125DD
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:48:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6294F1C20F0D
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAFF317B4E8;
	Fri, 21 Jun 2024 12:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZJlWVgrH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5082D155A43;
	Fri, 21 Jun 2024 12:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973654; cv=fail; b=rdN/mdeCqFIA/bknPZOIo/jEtwRmFvUSGL/cmybEWzlmwyQS+xl3FkRYro9M08m5CLMQHPvDK4MhQPmRknN34nLhaTq2o++gNaU3rFSH52nqjQaQNt3d+2fZTV0zeDlt3c56unka/nF7WANzpw2v5W21IwTAEplsYLMdIxO7B7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973654; c=relaxed/simple;
	bh=NjtLdLL/fizBHeKJ9hNhhOGJEnNvjH/UY0HtJMj6jnc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NKhn6WzXBzIIkucuJ0HVnpHHz1pZZThhzFGktOKWwsfLbBzZcOks4gxfns7uyf0xE6JmVb1Jsg5DcKlhGzVST3aBC9U7eBfzVhLGhERqvJp3Zp65aeOgIMqkh7l+SYNRJ8GTRlka61oz2E8JgfqD54IyAtF+EAzt8Ui0aKBR0vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZJlWVgrH; arc=fail smtp.client-ip=40.107.212.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSUzzUpvBmyqpDh+PAmLQey0sjvzKAMbMsikLXpAb/2bSWy6RUzUCI45IENwNCkLIKeCp4zW1a/jPv25INW6zYx0hxrRiIRCf6pZ6QrHeQtZstk/s8Vs6L9Z8rO3X7hoZv1u30vgJTUeHQznLEp37rvsz2mHwBI/TtKOXyjCoXNRcVGI1MPMkYFN3m6gJYtN1L06anqeo/NFpqlx4CNtY9sQSy37VMknXTD7CHdiE4jmpabOMhWcm26qqTI9g/UnB3UNDGuJURpZOVp2UgDfqUfYLPika0NOcgHLaHjZgSAFhIdkL2n0wxPydCmrY6B0QIs6YFikU6MR3upO/91lrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwMhuWhXBTLejC/8NnGn9qapu7ahiSKE8vXxKfognq4=;
 b=IkNvHJgozXwMy9UZ71z68msuYJ06pRINKt8p+SD6AeehjF3KG88JMw8/0Q4cdg6b0qFQpvTJqa2Eq8fIV/4SXgUicnqeA4KWTrHi4FkON0vn8uLas5qM+4H1e8ffnx7L63cPV+Xd2fFu6pcNDnDsAgU7FRJu5ZbRKn+5rYKxxE9fKcgloYJU5hCaCu8TsvjbDldM6fTFnr2VL7U5g9DorttzoqWUNwo1h8lQQ76oEfwyrnAkROuHHkBdLxaffK5XIOI2wsUteUWMwHQ5NmlpbC3SiFuQMapGJmf3k3Fx5iUBak5O35BBHrIvsEBt+HJmVB9e+Gr2JcRue2UYtGde6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwMhuWhXBTLejC/8NnGn9qapu7ahiSKE8vXxKfognq4=;
 b=ZJlWVgrHyQWU0UoiWYfNIU7DqzUQN14JVXeEl8vh5+q710xPSX/GK/ijTdhNXItvMreLdQwhPWyi6ORPbY4OpG2+KHO8mRD1HD0BvcNSpxQUT/sLgmJxqlU6kPbUWi6L6xn4WSvX12k2yQBqWaFcGcvP2tCOraWsWszYJEd2t70=
Received: from DS7PR03CA0233.namprd03.prod.outlook.com (2603:10b6:5:3ba::28)
 by PH0PR12MB8051.namprd12.prod.outlook.com (2603:10b6:510:26d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37; Fri, 21 Jun
 2024 12:40:46 +0000
Received: from DS3PEPF0000C37C.namprd04.prod.outlook.com
 (2603:10b6:5:3ba:cafe::cc) by DS7PR03CA0233.outlook.office365.com
 (2603:10b6:5:3ba::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37C.mail.protection.outlook.com (10.167.23.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:45 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:41 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 22/24] x86/sev: Mark Secure TSC as reliable
Date: Fri, 21 Jun 2024 18:09:01 +0530
Message-ID: <20240621123903.2411843-23-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37C:EE_|PH0PR12MB8051:EE_
X-MS-Office365-Filtering-Correlation-Id: 23deef32-92cf-4992-af07-08dc91ef5f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|1800799021|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aTefokz2F3KuIgfgA8/GFnMJ7dWFw4cAs3Q4unOZrvRLv0fUwuUtQiWw3yNH?=
 =?us-ascii?Q?Aux3tLyZ3NB0eEZvYngBNwpRiPN7xXq2+XvT5IHPvPsAqHqdh4vZ93dbJXsn?=
 =?us-ascii?Q?0iIoNADnqZC3cWUj47wXBtZ38Umbu4sjujWMpCUGzSj4DUUS6Nsmkg/Mqhmh?=
 =?us-ascii?Q?JP5obr7m8pWoUB7Phct9lTFDgIGqLU2/IZeng4BKQOr9EU7h4aixIwgSlhQP?=
 =?us-ascii?Q?3rj7wI36ZXKGoszSsh/cdHL8dlnHcPabsjkvw8FLfvOsgbAVyUD7FkVszl2D?=
 =?us-ascii?Q?XIK52A06NzVCq/2B3ZJH6dZd6AjjX+seMhbRch0ZS865Htx0Rl3TvRTwin1J?=
 =?us-ascii?Q?emZPpiwQmDgoKhsg/ORod62bmLl7FKOHjodNCJ7SyzVkiqQT0R6JE83m2VfI?=
 =?us-ascii?Q?8Ib0aYm5rrc8ag8TnRBqkBcLnfMGY2u9ekJzixqPuck/nu2/dlDbaWfKeorX?=
 =?us-ascii?Q?u602M11z514qm6WmhVhd9szvtjozeWXuJJZUPzroRZl9QVQzxTBb2n5lvNn1?=
 =?us-ascii?Q?RziAYfajF83T0N+zhPqVSIEAWB+70W2B46p6ROL2gB7pKxGj758OyOGS5ehn?=
 =?us-ascii?Q?XO407Gg6saADRcHCLut93tBX9Lu7NW/FIJa9xk/Jcq8vcKzXIHIcfILQ+WkE?=
 =?us-ascii?Q?mTRsyJ9jFs3SQ59dObkVCSIOptOPvNkI0gQ2Z1TzHRvLZf4/yDGgrYe3jav/?=
 =?us-ascii?Q?oMfamzB1y/muVH4eGXEuYbwDYxqKbJw5EWzvgdX6yEvzQtmw+edgY2R+YMKA?=
 =?us-ascii?Q?hnJ4gthDdCbtvA/Pkcy2HIUObINoPU/9ZyHOxw3vHuboNTaqlcoyPmNvZMks?=
 =?us-ascii?Q?gibCe9jo/g3JqFiM70Zuy2WlOXpGulR4x+FYxW9dmRczn5o/PSCkQKrVdgpl?=
 =?us-ascii?Q?pvnjAwDn43j3aghwSvzj3jj2tqm8oqSI6OeGko+S53jm4Q4BVUtvDWOUgqp5?=
 =?us-ascii?Q?sptReyEncEmWaKL1OJFIe+eNViiLDaUiaBt8yQfLlFOI47TnnpbX2FCqMWmI?=
 =?us-ascii?Q?Xv3+k8hEieCk7wV5HVJZVMsVyuBzpz1yRnwwtWGLPtFU7E1tCTD7siV8wXPP?=
 =?us-ascii?Q?pzdPdE/mCwXw0poH5JnCFvfRkSLZ0fYfFEJ+nrUdvBFxRo1vlKJeLdsuIsVk?=
 =?us-ascii?Q?8YpkmBYPrBq+YAbNXJfjKP8aPGDcm8HU1WPjSNtmdupBIZO6vq9gbFV9gzqN?=
 =?us-ascii?Q?DyUmQeFdsGw0//D0AXPlNqWwK1qTQTmULgL50aCGFG5XPA6Nsj/yr6GCGanI?=
 =?us-ascii?Q?FKd/Ufkn5KF4GJuN4f1DQ/OjvzimieDp0V6cKoTA/twzNM3z29DNVzXzpqR+?=
 =?us-ascii?Q?ZhCRlfT5x8LRNwbSsCDYCT30Ypi4ohLzQFqofoeANNAlWhCNi7y8hknVTFM5?=
 =?us-ascii?Q?8B13dUaCXtFRAZTtNnuPSzqVhS68YVxw8d4z2qjV+DbNtW1yUg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(1800799021)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:45.9859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23deef32-92cf-4992-af07-08dc91ef5f48
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8051

AMD SNP guests may have Secure TSC feature enabled. Use the Secure TSC
as the only reliable clock source in SEV-SNP guests when enabled,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 84624ae83b71..8331bd02000f 100644
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


