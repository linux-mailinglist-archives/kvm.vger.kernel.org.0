Return-Path: <kvm+bounces-20267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B29349125D5
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67DE31F22AA7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4501178CE4;
	Fri, 21 Jun 2024 12:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j3w9rlum"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6733155739;
	Fri, 21 Jun 2024 12:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973643; cv=fail; b=hFp+YLxxWbkMIdzq7jlAFPDz6B/YPiJzXkIXU4w4kbH7kgagMysJ12ZC0sZJdluhT1uKzLMncxvMRQCczUKYCo/oc8DzyqInfN/jEhw8C/cUBGFh3AM1plal0rUe4ihN6dR4d3CJ66ug9xv7EECCLaTqCBr7YpjdVQOW2BwA1rI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973643; c=relaxed/simple;
	bh=FEbHX3j7c5ug4PfkWWvrTqkjOzigIiRJ02uFB2S9eb8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRIs0c/ZQILKNHyGibRBcqzbc76H4vQipehmUhskr/1xWab6AWH6jAfUtEKW9PH5y2ToPAOGGtqHVoxMdrzoeL9XfKlvOisOJICuRdM5JTtsbHQ0MYXzQ0gJkxY9TI6jY9XdyOzCM2CsPbKlNX/EqZ08xUbK4Djp5dFMCPTrJjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j3w9rlum; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efkptuiyN97QzOenj18uVnmXxqkH5RX+v2PlN9bY6akldujC87pro3wm34tW0YztXOhC6U9c09KTmQJz5yITVFRAPncPSu7TTqQlyNCN+3J5UDR2P+rivKXNwCsrYerLT0/axYvUlbT0CoUxqDESPf07IGdhoe6SGR4wyCFhIPESSPqIQMadYRGtRq9YJ/uGq4JQI1cJWym/qe7r5o4Je/d/yGEvHSMioI6dsasRb18gcmte06wLc9Bjo9OoiZZ34ZnVMYsXRLVgxoeGTJH7Hc1LhdMDNvYuoZ6Px80/eAPrKI4ZwyloPzvgS7VsNiQwo+F1XLbvyqncTqp+aITIHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3r6ckwFv6qalMabkjn+qV10EDFSrhKV0JviLhz7s2tQ=;
 b=MwYJkclbT8OxDUuyRIsx4gAkpHpzOxE51hv+FC36pFs+u9bfAZvqekZ24B5kNEXAWhrCgC91wCJG1plceetcwxxpf8AjWadYnNCt0gEzSknCIFCt75OKKy7VloCPC3aA4Y+3gTV3gZ96VeRLOaWvwYsSmE3DEHWgxllKv3L3q4iby3LzzU85riaLfXhg2efO6CU9QksXB7X6F+uYICaGt6aoAkxWA9YX0QFT+KGIAYfxRexuxjJ+2uNQj7LHvA5cuL5Rqc4Qc1p6FKxzkvn+iBYnvGy+3T9Fj/23GQL5NaltqV+dIvy34IllswZuFdLLk2CpsZPHkfCgf+UaVxcTvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3r6ckwFv6qalMabkjn+qV10EDFSrhKV0JviLhz7s2tQ=;
 b=j3w9rlumeIHMQz6wJdGWpxNUAQM34BnjKPXGWNSvJLyPhHzhtMOKG90wUYTY0gTPUpnLZAbt9iS/WAgKV0AukuNq21eWAiI8XGTkqguu7yMkg7AoelYE9k8SIr4RcX8H6CutZv7j5d32OJEm2DjfxFmIaKlI/QMYzREzgiCCecU=
Received: from DS7PR03CA0242.namprd03.prod.outlook.com (2603:10b6:5:3b3::7) by
 CH0PR12MB8531.namprd12.prod.outlook.com (2603:10b6:610:181::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.37; Fri, 21 Jun 2024 12:40:39 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:3b3:cafe::d7) by DS7PR03CA0242.outlook.office365.com
 (2603:10b6:5:3b3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:38 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:34 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 20/24] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Fri, 21 Jun 2024 18:08:59 +0530
Message-ID: <20240621123903.2411843-21-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|CH0PR12MB8531:EE_
X-MS-Office365-Filtering-Correlation-Id: c1a6ade7-6111-48be-6c74-08dc91ef5acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|7416011|376011|1800799021|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J/5qsbQ3qTRxt/s4nK1s96cbASIcCLUN1XFZHZiZHmKIdXMhjmXlj59h/awB?=
 =?us-ascii?Q?lfVipggSV6NJMHeLZ+Xgp3Zh0NwZQj15JAtsuMVTxKOYUTAsGzh3HM3GkG4Q?=
 =?us-ascii?Q?C4E7IZlP4yBVhwSAPDJ3NQzqSDQtH35DMtTKI4xUXHql6+v/cpesZh4lE30b?=
 =?us-ascii?Q?r7lNppuPjPEqB5QvfcbUByezlk+ecw4Sxkx3D/C0hLyIGpCNJNa3QhTXe/jn?=
 =?us-ascii?Q?eK9Y7F8zl1r4A2UfGk0EK3ii2pwCJF4p9ifRRnf3gAxBiAxDJxamOvLai2I4?=
 =?us-ascii?Q?OiqEXI2yofu7X4lkGIChKfojsBeM3Wm+WlBA71HgGOyqRCC1E85dgkgBNLB5?=
 =?us-ascii?Q?ZUz5UDhWfxKvv8hVhtPzyD5GOEg6iwDM40SVPkG1L82wd3GQHoyKHf9cdXzQ?=
 =?us-ascii?Q?AZIea7XpR0cwZvzZEGGQdL9hYbe02DRRTZF/ATli3spDdaRoXi0r5OSMU7zN?=
 =?us-ascii?Q?H4nXuPQ9GjYVeP47QAwLpvUwVF9JHQLGqbpTczAdm68uDxLvI45EJ9j2tb1A?=
 =?us-ascii?Q?hAtS00nGyKk/pRsjNX058DfT37bxJlDsgOCz/BUT/0D4j9DWiN5+zPDzOiET?=
 =?us-ascii?Q?TTbZBqz6Mp/u2BBqoZgjlQDDedYq0ygtgBO6ghGBWDcQWRMggvKMXsrv6Boc?=
 =?us-ascii?Q?uGNDqcCYyy8SKhslhqJJkudAMgAM91cktEm5Ilc8ZZ3V/rjYWL+zjfyUTWXF?=
 =?us-ascii?Q?NG4Zz3jDkGwUHlT0gLjVpWBHr//VFs2Lnm0DKkDv+bfwzHqvgC0Jysa8Wkt6?=
 =?us-ascii?Q?IN6HhmpxF6caeRu1ElmVrADcMMrGN6fkPSqEgxhfeK5rj8PwLF5ckWOn5KNa?=
 =?us-ascii?Q?vnF1o8wOYnRpNdwbb+KsZ6qZzE22/mGQ+7ldmlY2CJ8pelN+8X4WmJQd+H2f?=
 =?us-ascii?Q?mtYzVBgrnjmQ0ISwpF/osT1u+aVjmiUAFIduMtBBk5jLkjLMJROUxlFPXta7?=
 =?us-ascii?Q?Ae7CWxEhvTso6DEzhGlyauiTb7MFS/v1Hb9XhwkFRECwhJhrPfXr2UuRvWVo?=
 =?us-ascii?Q?KZWoGJ75KldSxrVG35/l52cUVVJzH0GEm5IQ+7TE1pEju8jY1VM2Mv6EiG03?=
 =?us-ascii?Q?T2f7kqRSLcleJ28ewYOHPDW3qFdGRZyIfHv9eyw4kYAKdllRXQqH0fN+rrTG?=
 =?us-ascii?Q?HKRXabmYWt6GqX0BCkFlspGUV7BuvMNErlf9UqzZR4tMuyNw5DVF+aIWVQ+K?=
 =?us-ascii?Q?JhFNeHI+KfaQIMYefnPRmbzD6zTym2U3WoGXHrfOH7/Ml84PXv30A8mexzRR?=
 =?us-ascii?Q?q4qQL6IAruStQwC+DOe60oLOZ0gj4fa2BJqXj+xQUl7zHasxnSe9TTPDh79G?=
 =?us-ascii?Q?AnsNamEjkY0L5u+eD7Lq2b8LM7n7ki65U4VtJsIhk6Sbez2urgHehyT1pevM?=
 =?us-ascii?Q?j1R0b0IWolFiBRjOXCxlU6zNNg6zn8klDLXHIBJVtFGpLNCkfw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(36860700010)(7416011)(376011)(1800799021)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:38.5322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a6ade7-6111-48be-6c74-08dc91ef5acb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8531

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
instructions are being intercepted. If this should occur and Secure
TSC is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/coco/sev/shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 71de53194089..c2a9e2ada659 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1140,6 +1140,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cc_platform_has() is not available when
+	 * compiling boot/compressed/sev.c.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1


