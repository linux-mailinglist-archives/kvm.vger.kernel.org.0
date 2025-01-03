Return-Path: <kvm+bounces-34542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58877A00EB0
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 21:00:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 248091642E2
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4CEB1BD004;
	Fri,  3 Jan 2025 19:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZKQavZXe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579DC1BBBE5;
	Fri,  3 Jan 2025 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934399; cv=fail; b=iGn89iYYmC8l7pxV0lUhB3jmXZfaPS0ecERSvFUToeAUAdHZB/0GAtaeNK4q0mwp8Sj6KvnE7DpsNcPPElZ9et+d1CHfeav7G2AVoOLqfb4pHcOsmlN5yvYnhPewIGzgL16PsZqKjn4vspffqkjybJLGo8gWLblkX3vC3efvuu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934399; c=relaxed/simple;
	bh=6FdxdC3qNIfl5cXPz6sqwQFZCfSEJDOg8y/TwaTsY/8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OPYBzhUUepKdB3DvCHBZ2JqO7YqQOKSmGDGGXhjYmtG/RDr3sXqr/+hSSasXiY7OFX4s/vQajL28SSORHOs8ab/Tlf8ul+Utkq0C5d/YnIYuu/atwwNefRtOJG0VWFvk8wuJT57ZSDSEOGhL8eNxbigmNw95nt8izY0O4hCCvgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZKQavZXe; arc=fail smtp.client-ip=40.107.93.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wn/5x8w2eCpQYpfXAaW8E+eblcVCrUnQqHBSnxlzdTJ2V7SdZcicD0pyE0k8dzSWKYrhaMhLoTc/EkTqRdFroafVUhThlADOi23PWSLfvug84OL04koQ3DtMZCEF6Sua/QCMosPyPimnknL956ajgKkou0ZApqV+zWjQkNmZpxJO90x41dtrAsbtRY5zTt+Yf7kIqg18c/+nN01uSwVKL+jtc8tqu53IbxWUZoA/Ks1PUciqAcwcPRRtQDYhZRaNn6Ui5LRFM7LEWxlGZsbusrGrJGAT7E0xO714ZRtDfNIqp9Qmxn3UrWaPl3q8lkoDTVGN/ipsDsE8UC/cIRXc4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y28cJaSX8GxadSnRF6IQ3KU7BGogRdcwSui/xAVveOs=;
 b=o0O6wG67UAgtV8pnsiw8qrjFRqF6D2hFwTMCGR8VFQl78qSlwDc8+GRNd9tN8K67yzRQd3kieikIJdJ7Oi3jMfusIUlC7TOiQXLi4gWuRGBLTnIdEzPnNfLn3NW6JOpOXwc+1DFBNeiQ5+F47D/IqK/ZIbHqLRX8EjjWwffuyFCKkQzfAfNXzFx+wSu4p+tdA6O5v4hUfSt1v7FqH7mZ7XYfG5zCaAXTISWrovg91DqvArYqlw92JHHWR9PyG0Gm0zwvw6iumfEVvVWrKOUhP4r27b2Q1GB4FOnE6UeqlsOEjFfOF6eW1gWgQ2R61Vzgk9YHbvpuj8iCJzG+VVU0AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y28cJaSX8GxadSnRF6IQ3KU7BGogRdcwSui/xAVveOs=;
 b=ZKQavZXeY6hWYMKOHa2T36cC5dY0DpxEN9310ZjqVYEJeY/o/W7HxGgJFr8Ur9ixDwdnFwnDRTdUY/1RnbYDVw9bmKUsOmLpl9GVPISrRKhShAGehvH2yWjEnmQWHdPINMuo2uPpFsw8TW36IZ24BjgaBBchXczbit1HLGZYTb8=
Received: from SJ0PR13CA0031.namprd13.prod.outlook.com (2603:10b6:a03:2c2::6)
 by IA0PR12MB8253.namprd12.prod.outlook.com (2603:10b6:208:402::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.11; Fri, 3 Jan
 2025 19:59:46 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::bf) by SJ0PR13CA0031.outlook.office365.com
 (2603:10b6:a03:2c2::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.6 via Frontend Transport; Fri, 3
 Jan 2025 19:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Fri, 3 Jan 2025 19:59:45 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 3 Jan
 2025 13:59:44 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 1/7] crypto: ccp: Move dev_info/err messages for SEV/SNP initialization
Date: Fri, 3 Jan 2025 19:59:17 +0000
Message-ID: <707efae1123d13115bd8517324b58c763e9377d8.1735931639.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1735931639.git.ashish.kalra@amd.com>
References: <cover.1735931639.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|IA0PR12MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: b29372ac-5b35-4599-c075-08dd2c312c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I8Oe3DbiBsenMHQ/YdKqwetXPo5MywI06onhexf05HQDMYDjiJT8rpymJHQr?=
 =?us-ascii?Q?tA0+ucu3IHX7fAUUlbqUfLO3cpcaVot24NIYW/a8r/S042tMTMTXpvrU4ehT?=
 =?us-ascii?Q?5dpGbwUbisU79MxndgAoefbmeWiaQOAfIejUFbky7DSspDnBwz09KfxgGyKS?=
 =?us-ascii?Q?wRspt3TZdVgeHAcucOwp2cmwVq4o/qS1C6TjgMMEztSAHWpSUcnCkXwGrQnr?=
 =?us-ascii?Q?v3dB7Oy9B/SxcaEzPgqNtYazdqTddWisQx1RJZLKrUAugLJaPkjOVWPjjCSt?=
 =?us-ascii?Q?3BPQsTmoB+kuyThBT9hY/Ef5PN3L4g0ZQbHJosY5yR0aR/BUj3qZBhbaijc2?=
 =?us-ascii?Q?EpS6Mcw+dvRU1MXl1/XQCYEzIP+91jDXluayguaATX6TimK9sun/hWgIM7qr?=
 =?us-ascii?Q?eklZoKq6a2r2cWfI7vJMnS6YnfoY/LTe/BfgvDmCQP0idiLAcV6ud5RB8HWs?=
 =?us-ascii?Q?5aghiwtnBPsBaeYvKkQtEHpgaPu8drH+1w1zipke3j/xlwX4pDZr5140N91Q?=
 =?us-ascii?Q?RPEptixxxktvjKCJMEqMwqTWaHncbwLnvoBALlXXplruqw9kmbcihRjydcx3?=
 =?us-ascii?Q?nPHUvUv/RyQEmicK85OrGGHTiO4pKqMkbX4g6CYBV4QecCCHFa9DjS/kl8XC?=
 =?us-ascii?Q?qxWHBL8V4hgJ1bZgFasmQb5vgBS13Z6ZaxlFGJ/oH8OXj1uxw+EhEL9vWLs3?=
 =?us-ascii?Q?2IsKwh8YUbcU9px35rk3NPjUoBd+0Z0NwSa9vupCZtXiOTXXGuEx3UAqgoan?=
 =?us-ascii?Q?ILkdCmrmHyyvv0Tk1a67jADGU3pxxG3gmEg7CyCB84ISexNRLx1v6lYR1FUG?=
 =?us-ascii?Q?eWCco/cpznex1owS9pPgRXoIutJIblqD8f508n5Kuo6fK/jZH4L3hMfTck+M?=
 =?us-ascii?Q?O0sJ9huF0lWFdO5GVAaxnpy+pmRPtcDVhe++4QVtaaLqLQS+ccg49fWSAQzx?=
 =?us-ascii?Q?MXG7FlzeZupwJQTKL+JWgbgJK9NR97OhnUUdG6qPCjcCaaxJq06f5EjZGECn?=
 =?us-ascii?Q?+ORo9LU5Cs/FziIx3ZqkUHNOAlwqMX1vJ3S7ElnAeEqtYiPHFisdOYhtBmLz?=
 =?us-ascii?Q?bPQsmmhUkMQTS2ZZoorzTr3EbXDvDPe2N/FIDIFUD6cRlyI/0hSLR38Rg/nt?=
 =?us-ascii?Q?3qB6ZdQCMp7epDihSzhs/JpSpyIcq82fonVKn0kOx09z2XJqVskHIt+dmPG1?=
 =?us-ascii?Q?0wv45EnSMXDQk7eCAkXLOuidGvTnHnj9Iw/YzfjXXNHUQrTygsHwy3iFb5lK?=
 =?us-ascii?Q?D8253KZ0h+ddKIAMk1iURlZyX9Vn+HDR7bS8KraadBwpz1cwn8DuPsxzghT1?=
 =?us-ascii?Q?nCaR6MOuH1/ulvy8bmGzXxa4lgQ807RcONkEaOGC8srb9+dNcK3pdi7/E0io?=
 =?us-ascii?Q?RoqZ0MtcOx3iiZJt2M8LnSd5XitQM0mWuVkW1MXsZqfRFDIGg7z4TK2e0jpq?=
 =?us-ascii?Q?8tePdd4kQR0BDGjZzS/JDcyOtQjhM7Cid5b8dPcYzacQCFWD0SWqUClAqPaT?=
 =?us-ascii?Q?iIz2SJ2xZgbaW60vmJcFSq1dY233CSeKwMUs?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 19:59:45.9951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b29372ac-5b35-4599-c075-08dd2c312c1b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8253

From: Ashish Kalra <ashish.kalra@amd.com>

Remove dev_info and dev_err messages related to SEV/SNP initialization
from callers and instead move those inside __sev_platform_init_locked()
and __sev_snp_init_locked().

This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
to call __sev_platform_init_locked() and __sev_snp_init_locked() for
implicit SEV/SNP initialization and shutdown without additionally
printing any errors/success messages.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index af018afd9cd7..1c1c33d3ed9a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1177,19 +1177,27 @@ static int __sev_snp_init_locked(int *error)
 
 	rc = __sev_do_cmd_locked(cmd, arg, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	/* Prepare for first SNP guest launch after INIT. */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
+		 sev->api_minor, sev->build);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	return 0;
+
+err:
+	dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
+		rc, *error);
 	return rc;
 }
 
@@ -1268,7 +1276,7 @@ static int __sev_platform_init_locked(int *error)
 
 	rc = __sev_platform_init_handle_init_ex_path(sev);
 	if (rc)
-		return rc;
+		goto err;
 
 	rc = __sev_do_init_locked(&psp_ret);
 	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
@@ -1288,7 +1296,7 @@ static int __sev_platform_init_locked(int *error)
 		*error = psp_ret;
 
 	if (rc)
-		return rc;
+		goto err;
 
 	sev->state = SEV_STATE_INIT;
 
@@ -1296,7 +1304,7 @@ static int __sev_platform_init_locked(int *error)
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -1304,6 +1312,11 @@ static int __sev_platform_init_locked(int *error)
 		 sev->api_minor, sev->build);
 
 	return 0;
+
+err:
+	dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
+		psp_ret, rc);
+	return rc;
 }
 
 static int _sev_platform_init_locked(struct sev_platform_init_args *args)
-- 
2.34.1


