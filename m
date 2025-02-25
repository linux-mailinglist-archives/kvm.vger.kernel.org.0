Return-Path: <kvm+bounces-39178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE51AA44E27
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0B247AB22A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 20:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F5E20C022;
	Tue, 25 Feb 2025 21:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FhfMrn1W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595781A2567;
	Tue, 25 Feb 2025 21:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740517204; cv=fail; b=cdjKlwMb2JDS+5lcSEz/XvzpCQ3QgwVGaZ3xz2JjnUh15eCt7YF9JKOiTGdtRfp5IOFS2+PtYCWlU/Gu3FfxDVn9D++uNb22R01DQLWi8EefmPMqyGW80rFAooK3aEoA+UyXU3PIZwx8fGT+nY70417osQnESliJEU0HEZcmmPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740517204; c=relaxed/simple;
	bh=bEyFiy3ekGlFAljPhFCJa0E+PVtUvdJYtCZqfqL9bPw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRy4RMuEHJ+i/96HeRUmqTySs6y3LnGd1C5Yx7gHLI4J5LInM5+mc5RsIPKTt74egqX1HZcxSx5WPMhzYF7JbNe57IULR3m9aC/IswGf2teiTTm+XUKB+rvdJEz4eMlI5HcPWW3/F+v3g33XkrBurbnqUmUVOox+UMrcm7tEJYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FhfMrn1W; arc=fail smtp.client-ip=40.107.243.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=boQQV+EY6iQtpIvG7o85yNL8WACuKC6v2tRkan7G4zEsHNv1xGNJdIL1k/Hf8iu4W7JNeeF4APyjrIQdZno00nnMjN2jmgi6YIv6E0DrNRv8v0NQaN5MbQfAa7JhEq85awa5aFI9+pSrdfRjaea1r0mm3v9bXHiaYO777f1RiQ9egbuo7UhE8eunec+7oTPlbGJWvnMiSmh/kexOQqzu0m+gghPrLJaQ4ObEwRUQ97hZHU3Wja7+66zX7h6jC3WPpTm9fp6H7QeyvindBJksbZmKdXgjg8ixsbJXhJEtDTt5PW9y+B338QH46CWNLnA6gcC/E4kCTM2A2wZHCdVRIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aLZfhr+XVgYPjl49TVnBIX6s1uS+Y+CGkVb5FAvXzk=;
 b=WczRCcxekCt2W1DC/HjY7UT2Whmvp0/sXheKZwVF5ZyeNZLZkhX+G0Q4R7m6Ump2+gSD6Ulw4GDA+AhnjtHfgQWFyuksyyFiEErsEpXl+r2JOtg4QdGyjEbilFRRf8E+D7hcCLuGQ0yfgVPjKHTSF6hqcJkpto3V7ExHXWY1JvKqVgrhvednBA1MPFyG5GAMy2T6whQARMj3p8KUVrwbJh7fywWo7iFQTr6C7QaVQ9peiGwvzV74l7q006EJBx8dkQAnOF0DKK9R6qPTGblLjS7ElmXVW0lzJ3J5X6+JgqUCHg2/a18nYINuLm9XGlLQgfS0CU5jtm8h2g/ZhOkieQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aLZfhr+XVgYPjl49TVnBIX6s1uS+Y+CGkVb5FAvXzk=;
 b=FhfMrn1Ws5FYFqaTELo/YJiwSVnKMYQ2vnJEAObyS94qCkDgOrg3036g3BF8HRM8vAbGBVQqaO2HvD8Z2i6Lf+9uZZjpL7Hlz9DlTA9lJiH1vTepQTn1EUcu3W102sf1ApQc02JsXmXt0zEQ5bBQkDdsNxw2FcPGQf82hZQCa0Y=
Received: from BY1P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::10)
 by SJ2PR12MB9138.namprd12.prod.outlook.com (2603:10b6:a03:565::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 20:59:58 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::c2) by BY1P220CA0015.outlook.office365.com
 (2603:10b6:a03:5c3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.19 via Frontend Transport; Tue,
 25 Feb 2025 20:59:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 20:59:57 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 14:59:56 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v5 1/7] crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
Date: Tue, 25 Feb 2025 20:59:47 +0000
Message-ID: <52a878930a84fa0d5905a26d230baeb0ce554fc1.1740512583.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1740512583.git.ashish.kalra@amd.com>
References: <cover.1740512583.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|SJ2PR12MB9138:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f6a8747-afda-4f48-ecdf-08dd55df5cbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CDBTGAnKLzUkR9O2w4xy6KofZcHlZ90cvb45gdifZc3KXX/W0HUUdvNKXb5C?=
 =?us-ascii?Q?NKkAAJxmpNUB8wuVjT21l7nryzq/A3vMPyjdYKBOTO5t8k+E7ofwpndZslGh?=
 =?us-ascii?Q?B0stcY1xtEGyG1ZYas36IvuTefGnLLe0rwJ9n3ws/lF717H9WnszbQQpm4uu?=
 =?us-ascii?Q?fgBlKZ1aFIA5uC9s5G4jiF+gLD8b3zQMT2EpVGsFs0tvze1RwRqHQIkGG2GU?=
 =?us-ascii?Q?vfmJEu8rp6ReAL3/FfSHhiPVsYX37IzSSNSQ0ZQEhjnHqFJcIR2hsXFvRybq?=
 =?us-ascii?Q?q2M+OV1DHPQNS5Ufd7LcaukUSocLajJCGKmHFMuc8RbHteCurcO9hf8mYc0o?=
 =?us-ascii?Q?Wy68NKdVEmf2VraQ2B4PFgzVUfryDV7kXqea5+Jjxi6ZtNaxUwr8IU7EpWi2?=
 =?us-ascii?Q?ZJd/a3Yl7+7FbV0jjtwlAjzVw1DqzCKcV2fpCF7XoyNUAAImITFaRHz0xeSB?=
 =?us-ascii?Q?qb6GWv4Ifmah++tPbNGySqZBEiJQOBtB1CBezXlgLXK6sEtS9ap9+pM4A6Pj?=
 =?us-ascii?Q?ChWstyMu+rF/Cj4iSwH1JiYVQxhx0mqORc3efYJ8NsZoHSycxnhch8dEt7Bd?=
 =?us-ascii?Q?/ote1MfAsg/fWvK64AbF9b74d38DS0G5QBCEOg+IDvKh3NZQKLWqm0L1rb+m?=
 =?us-ascii?Q?8PE461zotQT/+CBue9WpTmnYqSTyIM7jBy/GUXE/Us2f1JvIGWsSP849j01X?=
 =?us-ascii?Q?DvEjmbvBAXhMUA1uXSzAnWmO6f4B+Xoqxo4/ojxxGQbVBWPqfehjRZQiI8Yx?=
 =?us-ascii?Q?+pB6r8ftFfLPps/HwA6AVSUDc7RjAp4hk0+J840ol+ih3nErOWCsXGfY0TlK?=
 =?us-ascii?Q?va5A8XUnJ/yKiaIrW6kfR3I8gqNIPr/N9io3tCSd5sdLGQEe6lTqkNxzxB4A?=
 =?us-ascii?Q?6HZXgHIPWtke1HWcgikAgq0s0DMJD4MQhme/g+JaiqgCFyGimgRssGXp4t6c?=
 =?us-ascii?Q?GEkkqbBcHjO3r8HcvRSylbLYqHtZuGV3oXpJkqQvJSfovQloJ/iJKbssaA5j?=
 =?us-ascii?Q?mq+s1IzJuN6mZFp+fdut1z0ceSFwsWWY8bV2E5VKT1IFMzj6pOxLQtdsL7o7?=
 =?us-ascii?Q?L9jammZE2e5o1NxIcOGheV3RVklUeD/a97X+dS9/YzqluVhi1lz3g1oxWJQy?=
 =?us-ascii?Q?mly1MZY/j20PMSUW/ivVGTkYxYDTly1v5lDhm2jRP4L+dscCzZ8tkCCav2+K?=
 =?us-ascii?Q?LrPItEmV2Q1ZfUhouhsayGhOWcGhRSIf75LZcDFOa+UhNcLDU874EMIT+Q5m?=
 =?us-ascii?Q?6sj3TLQRwXL0QVJg7QrpQPOv6qbonXC0Z9MH1785RakdriilaUXZEmQrVYHK?=
 =?us-ascii?Q?FMBTpFpVFI3GPs/cFkJ/T/KvymWEgSnQ+iRt9SR+iLx0r9OUVg6zjkQqjaqR?=
 =?us-ascii?Q?y8n8XRt557f84ldEFJS2ID5WdvQr/5+YP64u+gpWuFGwxMBDAetu5i/0r0Dp?=
 =?us-ascii?Q?zZV+IfSh51uvFAGRs5STSM6j5eXpVf64c1z7zQ9zDIUP2TsClr4KOU4nihZd?=
 =?us-ascii?Q?26fs3KYIzh9J1Hhc9QAev2Nscko3K7OzRduA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 20:59:57.7000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6a8747-afda-4f48-ecdf-08dd55df5cbe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9138

From: Ashish Kalra <ashish.kalra@amd.com>

Move dev_info and dev_err messages related to SEV/SNP initialization
and shutdown into __sev_platform_init_locked(), __sev_snp_init_locked()
and __sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() so
that they don't need to be issued from callers.

This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
to call __sev_platform_init_locked(), __sev_snp_init_locked() and
__sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() for
implicit SEV/SNP initialization and shutdown without additionally
printing any errors/success messages.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 44 ++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2e87ca0e292a..8962a0dbc66f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1176,21 +1176,31 @@ static int __sev_snp_init_locked(int *error)
 	wbinvd_on_all_cpus();
 
 	rc = __sev_do_cmd_locked(cmd, arg, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV-SNP: %s failed rc %d, error %#x\n",
+			cmd == SEV_CMD_SNP_INIT_EX ? "SNP_INIT_EX" : "SNP_INIT",
+			rc, *error);
 		return rc;
+	}
 
 	/* Prepare for first SNP guest launch after INIT. */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV-SNP: SNP_DF_FLUSH failed rc %d, error %#x\n",
+			rc, *error);
 		return rc;
+	}
 
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
+		 sev->api_minor, sev->build);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
-	return rc;
+	return 0;
 }
 
 static void __sev_platform_init_handle_tmr(struct sev_device *sev)
@@ -1287,16 +1297,22 @@ static int __sev_platform_init_locked(int *error)
 	if (error)
 		*error = psp_ret;
 
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: %s failed %#x, rc %d\n",
+			sev_init_ex_buffer ? "INIT_EX" : "INIT", psp_ret, rc);
 		return rc;
+	}
 
 	sev->state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
+			*error, rc);
 		return rc;
+	}
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -1329,8 +1345,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 		 * Don't abort the probe if SNP INIT failed,
 		 * continue to initialize the legacy SEV firmware.
 		 */
-		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
-			rc, args->error);
+		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");
 	}
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
@@ -1367,8 +1382,11 @@ static int __sev_platform_shutdown_locked(int *error)
 		return 0;
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
-	if (ret)
+	if (ret) {
+		dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
+			*error, ret);
 		return ret;
+	}
 
 	sev->state = SEV_STATE_UNINIT;
 	dev_dbg(sev->dev, "SEV firmware shutdown\n");
@@ -1654,7 +1672,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
 	struct sev_data_snp_shutdown_ex data;
-	int ret;
+	int ret, psp_error;
 
 	if (!psp || !psp->sev_data)
 		return 0;
@@ -1682,9 +1700,10 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
 	/* SHUTDOWN may require DF_FLUSH */
 	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
-		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &psp_error);
 		if (ret) {
-			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
+			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed, ret = %d, error = %#x\n",
+				ret, psp_error);
 			return ret;
 		}
 		/* reissue the shutdown command */
@@ -1692,7 +1711,8 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 					  error);
 	}
 	if (ret) {
-		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
+		dev_err(sev->dev, "SEV-SNP firmware shutdown failed, rc %d, error %#x\n",
+			ret, *error);
 		return ret;
 	}
 
-- 
2.34.1


