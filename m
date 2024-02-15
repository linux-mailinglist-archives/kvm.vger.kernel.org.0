Return-Path: <kvm+bounces-8758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 512F38561B8
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:36:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B14141F22648
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120C4130ADD;
	Thu, 15 Feb 2024 11:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JQrksdsa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9749130AC1;
	Thu, 15 Feb 2024 11:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996769; cv=fail; b=HBWYuJ9+7DT6JyL1QenS4DvoYEDiCy5CgCVjqjM3L+90nZ4aO2AS9QBN7VILoiSYnnD0BOrM80J3VxHE0OOtrb/s+G0lrPxjn0ZNHAfRiday+ItRXPexkgoIa0yZtZb24zKbP51mt6a5w6mVS0H7Hilc+O5g6SSk4FzBS7XzTgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996769; c=relaxed/simple;
	bh=pZdHHDMxL7vufEq3LHsXXoUMsAXqrtPfOyvCqvrDtQY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L7J36fAuWelTnoEWj7XY9icJP5Kfx2oveZKK9qZnZnn262uSomQqIAF2n8vQ2nYbfJJUmivwwEakKlkDRONytkHieBbhaSp98EEXGeSrRgimiAAebs/ZctJAA6q07z/LUuOCgXoOpTdNY+LH1b5THQ/X1PkCVD0uBQFC8FEe6+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JQrksdsa; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGsAdj5+mt1XnOg65tPlJLkNN5iY6/3Rp0dVW8OudAAJAC/pT/eYGaA/fh94dqneN6PUuOACqC6KpAs3E8czdo5hCJkTwM1sEiv/2q9zM+qqPzdFaRFJxNY085DJ1tNjZZ28gAZxVmcxxdchEIGbq9esYrHTjXx/A9vm8sjUJSYv7kYz+cisJoSZiIUMBp9JGWLAi2gE7OwVdCm90P7ZgrN86Dx9aE1qkW/uRprNKsQXfXsNiwR8e2wDFQS5J2MUQLDLJRokU04nqZaGfP6qSyMu7v8ENulgROJ0gSVWFM+wxc/iwLMDZxcPY7LE+Mp07bB019m/T6UawXEm0WO50A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XC4RswF2VCSuEWVb878r6noR3A6lLusx9iRKPmf+WsA=;
 b=h4X9gRU5WA1mH38ERLnTkW6mhU1sbyzKSWqZ6UkSM+w5W+6qO1VF1YcKtwZl7Fy7GnWPpqe6pzcYBl5iZ5dMr8vBftVpINKsUhTgqVfzDdJ4/oaoLLJTiDrjQxM0SyFoWjoadRLniZeda+gKT0oAezMfIbmfQYQMrgJFjbmB76FfNZ/iF6hSDNnmcMz9dZrmxT9y3xqcILAnHClTYsF0hO0hP8P0TJL3y3M7KpljZ73E4xgXjvzyp6/pI90WN0KC7qrbYv0a5WX2uwfW23PPJvPzRJspJDNd+OKqDbpDwKpvMxcvry6CKKx/ZRzYhv6ZJ2OW6fZrZ3RZ/qacVzCuVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XC4RswF2VCSuEWVb878r6noR3A6lLusx9iRKPmf+WsA=;
 b=JQrksdsaMQyUSGyE9rrABE0uyOs7W5TDM/evMAQzGicQXDohc/x11I90QEOPJA2+nbBNg7rE2cJOj1wd5VP8AdCr/non1+0C9ejEJvShrsyY+PxafkWAwr6pOvy5rjOEgfbMG4OKc01F24bVpvFIv2MFQGfZ2cRQ8EzrG8D9eVA=
Received: from PR3P250CA0020.EURP250.PROD.OUTLOOK.COM (2603:10a6:102:57::25)
 by BL1PR12MB5045.namprd12.prod.outlook.com (2603:10b6:208:310::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.27; Thu, 15 Feb
 2024 11:32:45 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10a6:102:57:cafe::c7) by PR3P250CA0020.outlook.office365.com
 (2603:10a6:102:57::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:44 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:38 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 12/16] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Thu, 15 Feb 2024 17:01:24 +0530
Message-ID: <20240215113128.275608-13-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|BL1PR12MB5045:EE_
X-MS-Office365-Filtering-Correlation-Id: f5dfff7e-04eb-44a2-5316-08dc2e19d3e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v4DwwQ2nEtZsut0ohDDXWWq7ECynNh0NUybL5a8FUYWVZuSmfne6mWOA1LtfjlFT0gU8wIOYp8FcfdnEk+LmRgtu/ja7EfXCGlrYwZnse144RLnAMAzlylQsb4e6GkxP4TwqtnQ7qJJwgXKQ2Y94ioW1p1fPg5PVASGw4NNsYvZAnFC19wFTf6rCmT9QyzOSKE40PONmg/zidj4fWlLTagrtgRufj9ckoz8G/Br4FNUbEdrzOPkl5dTu0aW4jhRnldaoT8zlq1/EwNeFm0NRKQiZU04U850vESi1iaCU7/0d14VY6wXj6f5LvTIn+h3n2IiZSxB6QaI3FXFJ0Ut51o/eYZ7l+Gb1sBmvcTgg7s15ZdGZmq6yOY7DvtN0ayqsEjlyau9g5GOsANnfr+3oIZ58DPlhg57npSMGCAX9rHm5OiF/bATmDtajxEfwkb242tTQRDnuaaF8iHtapivNGmGcKpF8W6vZQx4qVqAsIj6HIoX8f3jlsH1wZV/ONF44SdNOYKoZXrDa3Hs8vzocmFEg+Ttmh7mewEfsapUTZTvYQBqqljxnQGosDAEa/6z+go+wTGny+FoNhW8M+oBAIG3f6SPBPzH8MGUJaxgBjp9pzk4XP+ktiUe9QMkweeAaJwZcP02HcR2pRCMi2Zm4AcOkixGGJtB4nzEds1f17MM=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(136003)(396003)(376002)(230922051799003)(186009)(451199024)(64100799003)(82310400011)(1800799012)(36860700004)(46966006)(40470700004)(356005)(81166007)(26005)(16526019)(82740400003)(426003)(7416002)(4326008)(8676002)(5660300002)(2906002)(41300700001)(8936002)(1076003)(336012)(478600001)(7696005)(2616005)(6666004)(54906003)(316002)(110136005)(70586007)(36756003)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:44.3421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dfff7e-04eb-44a2-5316-08dc2e19d3e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5045

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
instructions are being intercepted. If this should occur and Secure
TSC is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/sev-shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index ae79f9505298..26379c70878b 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -1000,6 +1000,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cpu_feature_enabled() is not available when
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


