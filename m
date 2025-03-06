Return-Path: <kvm+bounces-40295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D501CA55AC2
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:11:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D12A23A8C66
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD7027E1B8;
	Thu,  6 Mar 2025 23:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Inq+f9j8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2363027D776;
	Thu,  6 Mar 2025 23:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302648; cv=fail; b=Bf4Py4z6GM5D/Gz0ddp5yWDy5cBGySY+kwjx3XURBSWslUdnV/z//PNxZp4+P5fqJWiJSFi59+Hb1//F5qDbaG7woFwpDOYla3NqtvsH+nErYSA42IBCHq6V0H/+/alqYfMGtPIVSH8jzTIvgaIjH6TBwAm5eH13ITEfdNDUQSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302648; c=relaxed/simple;
	bh=2+Gl0E7T4TNASlzyyCu3MCRazEvBzjGW2+VNIxnkrD8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/EfuiJCInMZTSWfX0nGBLmub77sjFzwo/io2d1hS3GFj+Pb9//08Bfl9P7LwpMdC57yaN7E3NGLY7QXDGJekG8yfM20wiXt5sjcF3qOeIWcgsMQ4K+vaQQ5h9f42gtbZvjSBSSDgxX1Yv+IESZOrzdfHIXN418A2tnj0uCUQpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Inq+f9j8; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3g1mcxfKeNPTn19rfDAI15ePOfSxRg78cZlKVG5ogPhmQB6vcIICq88mJSobTxUq5f8v16jUsjdPAAS0KPSjkruJI3D7sUNlEv1WZBsgVq90q8yHJHsmJdl13HkD81WLC/SYKWgZEv2D7thFTdgUYY4m25jbeqE6ni3UTjWNnsATdjVdpYkcAEqXLMf81xb2XUHXHFvyzJIz15bnwvReR0vdqm48e59Q+oFKOmDR3glXkif2KzOKqhmanHMxeGtNOkMjM0rso5LX8T+GGDOrw2Dy3h7qwO0dEI1MYue1Y5edq86yD+b/OJfyUGhWBZgQ7s07GDJL+gVHDdO6syZlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bJbOEd4dBzMu6JORQwK8OBcxVge5eG3OIbRLz/wOSKs=;
 b=KsfGYlOwwP0BiS8921/iQN79shJfr3CuP1tf5SV04Krwdxblgupq0IyB0XJI2u28X8VvcVZBVSNZfwujb25ET0fywf1lEYk2JfCesbL54HXr7ngeWE9KvpxJvKp8p+LpdwYMiCX/pyeuR2/KctajU8z8sfrO/JytAH4b2bcCyLpOK8p7Q8wcHKsirpAVz02h9kTprMBvP7r/UQt847KDcsDLnT0tFiOfbbc2UPk2dtYYMeuNrjV7MAAc4JCb/MUUCdv9nXGFB4dqihB2+gcl1Qy6PPNdFFoZslI2W+cEmOZ8ZmVfH9p2WMG/RzYbHCXIJjD8U3wb/GcNemuyaoYqeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJbOEd4dBzMu6JORQwK8OBcxVge5eG3OIbRLz/wOSKs=;
 b=Inq+f9j8KyqukdZO++Qw6V5INYhNT/54S0yewOilco8TIjFg2t4snh+CqG415+cJ3lo8SB6H1M7s33LdipektlwLhPo/8WZCSLBXW1zNOX7qJ2NrxXYKb9cANCeXHp8uz/lVIpw1ZIhF0Sy6xVvtWsg1b6AilqmKO8ug/swPn0o=
Received: from SA1P222CA0033.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::6)
 by PH7PR12MB9128.namprd12.prod.outlook.com (2603:10b6:510:2f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Thu, 6 Mar
 2025 23:10:42 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:806:2d0:cafe::3) by SA1P222CA0033.outlook.office365.com
 (2603:10b6:806:2d0::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.17 via Frontend Transport; Thu,
 6 Mar 2025 23:10:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:10:41 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:10:40 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 5/8] crypto: ccp: Register SNP panic notifier only if SNP is enabled
Date: Thu, 6 Mar 2025 23:10:31 +0000
Message-ID: <e86b490e6b890368f666343182c4bcfc5584e881.1741300901.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1741300901.git.ashish.kalra@amd.com>
References: <cover.1741300901.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|PH7PR12MB9128:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b734cc-5e70-4b79-07f1-08dd5d041db4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sq/UAWapXdeb6B+jZiZ2MUwCtkn0S1tcXwQ5NtHvYnVhecW91QXNjq0QAvdy?=
 =?us-ascii?Q?Hfti/HNeM0/GJq76vrQgFVAK8vrKFViIo3xNEZ5tfcvsbac2WgTPVr2V9ut3?=
 =?us-ascii?Q?oK071xe+bWcw6v3gR1zwjvqDsxuBB4mtbX7oZjj2SzVbrVEdyg16iYKVP5KC?=
 =?us-ascii?Q?su1x3kMTYm5zdhdx6FZhV5u8U29fBN16lPmC/+1ctFUYzqJMErjEOxXifqyb?=
 =?us-ascii?Q?NO8rvFDkLdCvSaXyxcB+THg7vczTkTmPT05DGDb6pfNFm9z7nM5UoZT82rxQ?=
 =?us-ascii?Q?AWEON+0RuZLVlrSHo0qoFgU/fzn2CHXL1dIu8vSwD1lMrWtZF7zQvlmLmD/6?=
 =?us-ascii?Q?O4XISeS3DwmABBdhoYhilEkY7imBqLlvLkcnRH5HIgKXtaBSfS+xnIt4tiw1?=
 =?us-ascii?Q?/JDNXHGZJapWxZcLyCCgFVDvRcl/N5HtIWmBZJIGAfEIlr4paWTGViG0CIei?=
 =?us-ascii?Q?QnWIyxYpQEKvBkSFBXzTBSAUDoMKum6JJuf6G0G53+7NEXeyLgh3tsniS/+c?=
 =?us-ascii?Q?z6o/gqsvwO1QNvYu8SyVBWdXDyMgdYgc7dJwAVanaDQ+Vgc7xPSyGHxG62LJ?=
 =?us-ascii?Q?3PPYKo27IJ1kFoHHTUUOj+xp2oPnQ1L21h4FeiAeSnWNZlgnABXXo/kpwtvV?=
 =?us-ascii?Q?+ks4MKApRgipWA2lEyOJKUEUE/Ph3wW7uYn/d/VkFMZUgUhrQ1U/NXsDGAkY?=
 =?us-ascii?Q?hzi+pGobHkaFJdE0dnsl6zUN0q+imHUD1XxmvcCgJtXrjhiH9SCqbn8jkqjh?=
 =?us-ascii?Q?fve6JhGPYPo/KVkZUHjZROKt80VX8+IEFAVIxDC0YAhfQz4iXaQk2SR3x0Ec?=
 =?us-ascii?Q?78oHTVMXXuoSYTokaNg4yFB04uWh3CTdrm09+oixPUZAJ1BbOc8PmtXykA6o?=
 =?us-ascii?Q?4ofA1IkSxKiAgZKjmnRUhsmBSDPnwgooPZo0qoYA//BfgO0Tvw2o0Zb527Gr?=
 =?us-ascii?Q?0FwsGmTN5GqgJ77REfWOq69FPflGYLOq9SU20IlGLx9OOzTRTc8jmM+ckLPq?=
 =?us-ascii?Q?FZXLUhTETC8llaOWZ3K6kpaVhMxVojyFR+CXPQR8RF0PWlO2xQYCNIgfaSRe?=
 =?us-ascii?Q?tNpv/YjR+9pjIkQ/6eZbwLHSiBO7JIMQOR5MxkXoVcbwn6x2pnlp39BTu+BM?=
 =?us-ascii?Q?IA6F5pw4W5s5uESff/f5XVW6ZOtBYQypVX/OjXVRdw332xT7XR+zhlAwxejT?=
 =?us-ascii?Q?eqJtsE5HqYoIPO5vkOohsS/1uYd1gZhBxkjAuljHHIPCn5ILyUcsJiPrvsIa?=
 =?us-ascii?Q?MFHoj3qSuInNbwyCnc2izsYDRu08y2R/ADvzehHwZ2nuMdbx4GMoeK51mQE6?=
 =?us-ascii?Q?mmYrru1ZjivomDkGY/XCpy8BCsFbBct+f13AEdcBTEJIg6i0OKz7+yntZAMV?=
 =?us-ascii?Q?KTrgurK5mbD137tyZD6k0rbCdfwNZWrLySXuUyKm9FpO2hM9HRNdH7AGKALX?=
 =?us-ascii?Q?ZIxYfMd3aKJAuoWmzjbJXkLrVl3qgq1LdK+vq8vC3zFQhl5NJKODnL5HlYPs?=
 =?us-ascii?Q?Uz67Ypn/yLnQEhPcaaK0u+LiftnMAuwgk9Rr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:10:41.5131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b734cc-5e70-4b79-07f1-08dd5d041db4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9128

From: Ashish Kalra <ashish.kalra@amd.com>

Currently, the SNP panic notifier is registered on module initialization
regardless of whether SNP is being enabled or initialized.

Instead, register the SNP panic notifier only when SNP is actually
initialized and unregister the notifier when SNP is shutdown.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 08a6160f0072..6fdbb3bf44b5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -111,6 +111,13 @@ static struct sev_data_range_list *snp_range_list;
 
 static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
 
+static int snp_shutdown_on_panic(struct notifier_block *nb,
+				 unsigned long reason, void *arg);
+
+static struct notifier_block snp_panic_notifier = {
+	.notifier_call = snp_shutdown_on_panic,
+};
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1200,6 +1207,9 @@ static int __sev_snp_init_locked(int *error)
 	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &snp_panic_notifier);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
 	return 0;
@@ -1778,6 +1788,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
+
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
 
@@ -2489,10 +2502,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block snp_panic_notifier = {
-	.notifier_call = snp_shutdown_on_panic,
-};
-
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2538,8 +2547,6 @@ void sev_pci_init(void)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			args.error, rc);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2556,7 +2563,4 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
-
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }
-- 
2.34.1


