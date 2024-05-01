Return-Path: <kvm+bounces-16315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 745D28B8734
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B155281A0A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2172B51C4D;
	Wed,  1 May 2024 09:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="l9jrihWB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A364F881;
	Wed,  1 May 2024 09:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554335; cv=fail; b=CXvixME4tGwmRn1lvSLM+nGD+7FvznZXX/XLPYou70lEYIboHpSwP5/5TBuOnHVwjlwe/AD3zeKYsh2Ipcy3Mv89HvAKBA91OrKpx3L/au/dKYeEV67sZdokfQCDYZ+DGqdMXE5RJwS3PnSS9jaBYVafUkDEr0/+RJyjVRj8bzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554335; c=relaxed/simple;
	bh=eiwFA/WtOymC834NZHngmA22ERsSPKHLWV5Kcn8NcTE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ghPHcW1gc3qOx2bRLYkrd1whjTeXSt1G8W6O2ers7Bf1xeD3bGuA6AVYy9Jws2hkt7rWB4/BJbAA3p7zDJdAKcVr7k9Lp8S0hk2AETP+BeLwpR2O6KeSya2WJ6XuOOmw5rbCizkwTFZwUs9c9ESUAvEWAmh7f8hIusYjkzRmEFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=l9jrihWB; arc=fail smtp.client-ip=40.107.92.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QalWgB1Zn+TsHYgm70ySjNhuKkqgoZLB71HIH75C0fUh1/jlkwSIYdin6goVokzmmTxnWGUG9akMG/FwBAlP4hIsEcvaxz0BLy3fMTwFM6RzUeGkvn6jtCzXOJEiBxsMjSUVJsvrgG7CROupKeq/cGl+dKhzjnvY7TV2Z3uRgCjM1fe+TX0xLqTPE6X3KwjGmUWWSwz0XBNUJ+Xg927BYpskvFhK8lq/kqFgAB9mdyUItPNitqt5hByd8c00cGA4yUpIQJJpHAWEcnsiU/rFvn9p+fHs/SQbHYPgyfORafvdEoBTvSmI5ipjJxDvHEVdKcBXkIEd3iuSmVbKURoRdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+FNVfD9fNFkqi60nkH0uAzq1nrTCqNbeox2T52AD2c=;
 b=aqw1meTMsIoxPMwOo2ubzyzR+4BAnBHGGg+dCxYlucPQ09jyDI9c55im/xnM/EQlBaQ5F3anjWslz6qFq4dWIHAOFiQAi+hvFzJPgQ0TIoA1NkcU1+vSx1JzTDmihm16rM+64nPrzFiS3HI7pM+22FEbIAPK7IH9aZwcL083mYLfUziX1X+rSijX/1UdLZFLfv+zMX0i1fhflFc5jaPCtOr3pZLr8U6fz6vHVl/rnHfTfsajcdYMsBq6OFPPCNAt9n7OzKHrKBWq45DiiuYR8iUCtB7VXOER68Qa/uDhY69haBqxZynfMjbxi1RmFuH7X910fZdQ/+uTpDyrjeAIjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+FNVfD9fNFkqi60nkH0uAzq1nrTCqNbeox2T52AD2c=;
 b=l9jrihWB4tY98VUlHjoLDc5Mb60StL1LeHv0v9bvd59uksr1FVD59CnFMVUy9fySEq11f1F9mvff7/k1VQAnk5W8Gokw15C2ttLxmQgaeEZffDFS63mxvO9HLW3lY+LCBV0cJI6EzuxmLrqwMPq1QT++duvSQmvu82yVtxtzTF0=
Received: from BN9PR03CA0892.namprd03.prod.outlook.com (2603:10b6:408:13c::27)
 by SJ1PR12MB6220.namprd12.prod.outlook.com (2603:10b6:a03:455::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 09:05:30 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:13c:cafe::4e) by BN9PR03CA0892.outlook.office365.com
 (2603:10b6:408:13c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.34 via Frontend
 Transport; Wed, 1 May 2024 09:05:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:05:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:05:28 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v15 17/20] KVM: SVM: Add module parameter to enable SEV-SNP
Date: Wed, 1 May 2024 03:52:07 -0500
Message-ID: <20240501085210.2213060-18-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|SJ1PR12MB6220:EE_
X-MS-Office365-Filtering-Correlation-Id: 7242241f-b64d-43b0-4242-08dc69bdd949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400014|7416005|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Owcem0LFO1Xy5hTdrGqTXe9bK7gK1cF8+k57St/25NcVPKfM5ecyP8QtmWqP?=
 =?us-ascii?Q?4Wjas0dcrFeoSQnlAjacq8/3NjInnnLUh8WQXoq2RZyMtCnz1iyRzAFHdPbj?=
 =?us-ascii?Q?XeYulwRQjYtl+WQmPbH/yRqTk4lpkVlPues09UAodv6PphzHk0qjmBXC3Bu3?=
 =?us-ascii?Q?AzvNKY+C8o5nFIVZs2SBOolcvXwi/lwmfP45iqoH8vkPJkUVRjZ5Y/tVoriN?=
 =?us-ascii?Q?45MDX8kAtenQql62TWuRpphDgvFkyuNnPJyynlfsaueFgiSIPObzqqQnhGtH?=
 =?us-ascii?Q?JzTPJFFgm+sPpOZLfszaytQ8e1XctkPKu/9p5YC1SRM57nI6OLEubml4yV06?=
 =?us-ascii?Q?2HXsdIKwtawvyldyeqRUMpjeh7+o3u++WxBMFU4ChNt7uuwwFjWRAluYWcTy?=
 =?us-ascii?Q?xhRqrVaQVHAhvDkaQfWCrb3P9nrwBn+qnnqdUDtj1ILuVhfcrQCD2Ymql5cZ?=
 =?us-ascii?Q?jYNoSfHyN7j66divwIO9YefJJ0JBLcvYmY4sxsRmcjFfAphdM6XLz8xSZly+?=
 =?us-ascii?Q?tpVnVIEx5LqLawyGwy0zYsDsAtIz9lvDqyoqSWvPGj1i6rw8+rP5+UUMPtX0?=
 =?us-ascii?Q?tWe0I8JJF7dMZp3FUQtbpNPYYC9Bwr8axpGtueGVH+294HVTXw6vGR1in9oQ?=
 =?us-ascii?Q?zNLVSfYVauTaxvspi3bqN3KXbJlpVb3kDaZ0kWlmPqY60WfXJ3ydWJmTZ043?=
 =?us-ascii?Q?BdcQ6fA7jaW0tuwmXFSQyWJqqrX0r2GhpI7XMfAZRHW4r4+alLQUgxPVoT4J?=
 =?us-ascii?Q?6I1RAawTa+1TA4H2u3/rwV5UYTiaGd2DFHOln/TR71rUDwoWF4ccJExP/toG?=
 =?us-ascii?Q?KdX+7FbrVnQlvrJ15IWkaKFvsPM45tXZNZuOZfUPIZOAV0AFDESI5DGeLWaO?=
 =?us-ascii?Q?pXCQYNIcs+X1yLlyn4ClZioLO1wzFJaFMXAPTaUb+hpGLbc21njUR+UDly2I?=
 =?us-ascii?Q?MJLSqI1uVNtnTyG6/+y7RmMvmdqgPRs5drEaOhKEkat5RnsayLqfIQ5qBUjV?=
 =?us-ascii?Q?yTe9YWG8tQJO9uyFbYQYeDj7ijKO5/AekFRFkGya9Wv754N88HZnSby0RAR9?=
 =?us-ascii?Q?a43F2W+yWv/1aXlio6ZWNoLvSq7nkYbX7B7kn0hKi9P1FoMNgx2/ORwS/W/R?=
 =?us-ascii?Q?p9/X7WIXdfXgpba03legx/HwIjHvudh5v55VGTxZVyMLiI8c271jQBoPvA32?=
 =?us-ascii?Q?fshJmEZY0CdEHBO+1i9rua7hhWpO3TGLcM7N8qhJnMSbIDa0Zs0IaaPzwQpE?=
 =?us-ascii?Q?KaEBfJnH9Q3Kz/+STEIhFr90WMfQL8HqD6Pvt0x7ySCXSnob+umjN2jmDv3k?=
 =?us-ascii?Q?Eo/ndgpR8aZiCAyKq8NEHouHJr3kdUUTFgs39mD/r70El4xIexskJgnlfe3p?=
 =?us-ascii?Q?Ey/qeqw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(7416005)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:05:29.4335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7242241f-b64d-43b0-4242-08dc69bdd949
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6220

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e94e3aa4d932..112041ee55e9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -49,7 +49,8 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
-- 
2.25.1


