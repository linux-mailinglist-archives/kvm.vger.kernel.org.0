Return-Path: <kvm+bounces-18404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 947598D4A38
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:18:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B75551C222F3
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D802517FAA4;
	Thu, 30 May 2024 11:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ecg5kFXk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4BC17E46C
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067820; cv=fail; b=rtYtO6FZKetKtEvhUy8osiXctZw4OO0yMAHWrCMzbsdLRmvKLD7ac7F4+MHCCx6LWsl6OsLVCn5NdeuCOUeV5C2AbRa61VqbinOIz54n5BVKVdPzwICb6Z0LOXZoPXdTGVDQ5c3gea6LJq7Cd9qLdzU6Fhv/3s511muj9kIFEPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067820; c=relaxed/simple;
	bh=Giu0+ad6EmkvSzyYCzOXEkWyy/IBYUmy8NCdAGBoWrA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IsOs/IQSpOGGz0CMvwq68k51EkmoFYrzf5DTHEQM80ycjhvU51yFzjiAJ1L7Z5gUzOpX5+4+QpgBvggZNecDUG4vK6W2B0qkkTTkXRQE0vcilF9gsjwb28R+wo/8UZ8a35+1mFo33d9NmX/xBtKKhM2RXSqC+6X9hknGqaM+3h8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ecg5kFXk; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSzBCIsil9SHOHRU93RJmulD0zkSk2HgBz7j3mcWevowwczEMpZ/+kemd0B3iQCgrALPEDUnI3leS+CG8mInGTEuSJ6r18cPfOAsWn1Axi++Oeh0VYJ+BpJD3zAXUi94+GpXcj+fxCG/aXaLNNxTOOBFAifcEQIDwyfPQZwWJ8FgdxBJcBT660S6aboFwY6bSO7VuL95VbzdEju43SPfJHf+MbJ9nEfwsBcccyUyywxblG5O9iWAK/ugcMhmdbulovJvRwGB4qCeDUsgk7jiWsUAYF8SPRJ9hI8Uj10zlqF4X5MziCRyHr0ZmHXLQU6beWk23L1x+GR9vCVkXgEToQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+AsKJ/rgkkCDkjUvL6JMGrlId+MVOcgn7iEWTgFrJeo=;
 b=YTXRWw51uW2tUD4G1+lgornRfaEbzS+YLSC4djn0X5x4oxs/7Za45JaLaoaAUxht9rLFuAFpXFTxmviVehz271OIDf4NmrdDXr8aaeE2UUY2oEughwHLaTH+PbD9FsujjU91D2nEg7pNawsP6XF8Z9YiwZbLafMb9/Zj4v6nlxUYrtwAzeNEyEnQi1Q7TN/m4TuZnqSEqudQUegqArVFQJ+GY+HUJcel8Dz+bC6xjl41StuNyGWNfrvzi8WwL+XaxFPfoCw7sOJ39NwIzNfqtrQnPz4W9Xxj+ktWdMOD+fN3IgtCqbgClVFiEYv9+qiTHhN8L4akD9/fbmX9egjzDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AsKJ/rgkkCDkjUvL6JMGrlId+MVOcgn7iEWTgFrJeo=;
 b=ecg5kFXktMShrHUJxoapTgNyFjG/CrjXp5kQVzw2DUat+Eq2Hc2jP9OJOPMnZ0Fd2byRcyVDwBJBZlLn04xpPxg2GwuqrblkKX2HupB2jhv2z36VolCYvTOeTSRCgH8/gTQFI51HQzcBmuBS6tUhrbc0apHqIk7K3OdytJ5S2Ic=
Received: from BN1PR14CA0007.namprd14.prod.outlook.com (2603:10b6:408:e3::12)
 by IA1PR12MB6138.namprd12.prod.outlook.com (2603:10b6:208:3ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Thu, 30 May
 2024 11:16:55 +0000
Received: from BN3PEPF0000B073.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::94) by BN1PR14CA0007.outlook.office365.com
 (2603:10b6:408:e3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21 via Frontend
 Transport; Thu, 30 May 2024 11:16:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B073.mail.protection.outlook.com (10.167.243.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:55 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:55 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:55 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:54 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 17/31] i386/sev: Set CPU state to protected once SNP guest payload is finalized
Date: Thu, 30 May 2024 06:16:29 -0500
Message-ID: <20240530111643.1091816-18-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B073:EE_|IA1PR12MB6138:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d4fcfdd-5688-4ebe-1e4c-08dc809a03df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DxorTXMApDvWirNZOeVL2LgXvZCO9EWNaMqu1PLJP3iCeug+lFTide30Tb+o?=
 =?us-ascii?Q?lPAJBjz6wTxepBBWfwY0pbn67qEIcx9/6dax9yjNIPtMnV5Ne3hPqZYs61c7?=
 =?us-ascii?Q?xVla2Ug1AJAvMC4XlvUkLTcZYhRfNxf3inO5d6u6QxYuGvbtxUf2koeflu6z?=
 =?us-ascii?Q?ASoGLZeW1kIhJXtWKMpITYwFZs6stI6UgtlSGkotG83m0KcwQeUtuCXzi9da?=
 =?us-ascii?Q?H15wGm/urAIfJZeLjfaQRf6Msf+12bL6JjkCP0YvMgFJ0C3YMd0IjhRO2EME?=
 =?us-ascii?Q?LWgH/mDpWxUxFzZFKgr4q23lXyPO7zQUrEIIt/O3jlKCk8fAHzaSNojxFCbn?=
 =?us-ascii?Q?wKO1dctTaDSxv44SS2KtOxoe1mr0uzerMzGXIwGRpkGYdAI20BQrrvIA4MJD?=
 =?us-ascii?Q?14wP6CrK3G5fZ6s2MVUAbk8W3MdhPODadAz35bWRcPzV65BzgVWWJMl1u5eA?=
 =?us-ascii?Q?pvrjojhEYwxmLPVK340vUiJbtFh9lvaO1O5GXfEBTidnsWjjvn1hwH+WOOKJ?=
 =?us-ascii?Q?GE/KI4uA2RPv/OYIDplzBTIgD2skRRxmOjpSf37ZnLOvD8VouNDjbLzwq4+r?=
 =?us-ascii?Q?Dczg5vtCIkrJ6AcD9XLFl93Yp7jb5Qkedg9tdr+cDRCnrhD+qGObq8DfnzdX?=
 =?us-ascii?Q?Mw5/po556NgCIqZUiVktiMQfpyMj9cF16tVXhpOQyZOYZhyKPsj/di3SccTA?=
 =?us-ascii?Q?frL3Z3iKWVbptUhH2X2G1H803phqRIIZvOkHji7bgZwk+09EPWYKhQcLxGmg?=
 =?us-ascii?Q?sQSjrwEEEQj9vEes7ZlFf+rXFHpyzISEEDhFKuE1XJutyWbxIGo0Fb1ISah9?=
 =?us-ascii?Q?mhnW95K3bMo8qQ7wfO8e9Oz4MuAE3brpYxXyOIhd4vV+p1JcvxIV1LuyAiQ2?=
 =?us-ascii?Q?9HyWSqWkfOVCAaQlGIXNuqk7UBieGtJcVM1fHc8pP7Y2OURPpLLrCWNfTKJi?=
 =?us-ascii?Q?Lf8UI7OdEoXJR15aruYrzdSPw1cjqTDoZvpqv1SKy9NIPTV+YZU0z4O4BV7M?=
 =?us-ascii?Q?Hh2Jgn5ws1mwDLAXNKq6qaBdmgtJ0WHaTwUTu3iW6SwzlcFURHcqg1UHCDrX?=
 =?us-ascii?Q?zT1cG97wBFujwyvivi9LK6DikQa/oNVUXlwG4fDnYlEfbLtweMTFuX5hOiwU?=
 =?us-ascii?Q?kamcblcO3BMmKJewS0eqWdmmgXzZJCx4L+O93tGfHBg7Lh6+0Hl6AbFNVBmV?=
 =?us-ascii?Q?GqJEYoiSZYysKdX4tze+rVeHWfQ8qj7s9cKFHVQ+0igf/rbHV4yhirxOafoQ?=
 =?us-ascii?Q?fvm+PbwxQXK1t3azQmyNBLc3r10R0YE8NQvbSeWYeiTuyGCRSHxTKy56eL/p?=
 =?us-ascii?Q?/LUKq1By48RPWglP/VqPZdL2v2s8UVDqnCrnfxZ2TaaZTAiL+4x0Z/f6GmRf?=
 =?us-ascii?Q?YL16OMjvS0qaj70lBP1AMTC/P5eI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:55.7571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d4fcfdd-5688-4ebe-1e4c-08dc809a03df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B073.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6138

From: Michael Roth <michael.roth@amd.com>

Once KVM_SNP_LAUNCH_FINISH is called the vCPU state is copied into the
vCPU's VMSA page and measured/encrypted. Any attempt to read/write CPU
state afterward will only be acting on the initial data and so are
effectively no-ops.

Set the vCPU state to protected at this point so that QEMU don't
continue trying to re-sync vCPU data during guest runtime.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index cd47c195cd..2ca9a86bf3 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1011,6 +1011,7 @@ sev_snp_launch_finish(SevCommonState *sev_common)
         exit(1);
     }
 
+    kvm_mark_guest_state_protected();
     sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
 
     /* add migration blocker */
-- 
2.34.1


