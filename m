Return-Path: <kvm+bounces-34545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35C33A00EBC
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 21:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFED73A0859
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D46F1BCA0E;
	Fri,  3 Jan 2025 20:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P0NTGel9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5871B4F17;
	Fri,  3 Jan 2025 20:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934493; cv=fail; b=qp6zAKUOrVkZKNv96b+uMxA+y8z+Ad9JunHFdFUPqir8BwGSVSRqeFnyfJB4ycJUWoUbPjYEa4vw98TVyM+K2Ff0ofrg3n8fusY9Ujk5WtccyDUYGFkWBxSOGESK+BM0ikrAPLo5ZKby5d/GdxqqZU2bzhcKhYPz7IZQzzmAltY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934493; c=relaxed/simple;
	bh=syGqMyaizm6LEec9pfcxvi7BPhvLcG+T+ty2iLvU3mk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/eKXcEeWWmXxfpQE5V9cbnBk/+/O5EL/B5Lh3lVK0L855TGT3vOGsqGJpll4TkjKQE+V24YdCjnAI/biAIHaX3lHx+VTVgoYuN9KfnIKMCmqtiC7e1xUhuNEI9CUq8Fz2JqLQEDiHs1VycBH5RxEHzS63QZV72vAlYJZtUNXk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P0NTGel9; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MbKt8ze1EE0jx9AWGi3ahQ+u1zK0qY13r1ViBSPx0LCq/tERER7fF3rJNMigwsO3L5dkYQszZmCDbPTIQ9RW/W7JuPCJiJqze6xzt36T3SgTvrcqUGTBmLS/P//2uHBZNABKppCPGjIwmDOAF2fGt08L3620f1wHqUjrQQpjqi1Fr1mcL/7JjTiR4UqVmQc0sAC+WLaOH5EmfFAN8dcmx2yT9AOgl+sCo/axhhDmgiF0GC40Kdfxd64vyjJKUY2nyMPxsZoiIDA2L08kM9PFOIghqkIAloq/KVuHZdo6QgpJwm3t5ABqTBmDpBy5BRdt6v+MqZqPiNoRl9HfYplrtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhTHE/dT4zAyu9CTo6Xv6Y3HGPzAIfnLVVr2hn0wfg4=;
 b=V2cJSz8VTuzTiiFKoCPYHA9nmOwDjNykAep4WUr+bKRMmWlD8GJqUMUFa5he+ZnHpqE4rlAO/67UxxWFQMFk56NOrOPIA8wgSQgyuc65py3NIWAqeBmUkebCyMjJ+FibMtuiscnasKGTPkjapB9pD8Xjn96Kyz2PeKAdZxPUdN5lUIqXovrRme8AxL/LvAw9pqsRwK1i7jUC4akB89Jp4PLaSkYSYyvdcgOgK8mqUMTFxouIDyefnPk3YbPlttxwp6rwlb6djhFsJc/EQCuj5Dn3tQGeg/Mk3Btyt/Gcl4b3OoOvxyoZENHWZoJg+e8JCQEr/aUoPD+L6XGOViFCSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhTHE/dT4zAyu9CTo6Xv6Y3HGPzAIfnLVVr2hn0wfg4=;
 b=P0NTGel9h7vYvvq63ZLZf1+IUoQNU4emGqOpgCJS04LsSUCwyT+DEeyv7korkDkMnEcZ0+UfsFnUge+9z9OwpuAtBO0WKhubz32JIIQ71sv9mYu9MRm3qdD66KHfaHNRFmEkE+ZtYQcfJpI9TeXFEfTegkX41y1KD/wkmQqkOlA=
Received: from CH0P223CA0024.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::12)
 by PH7PR12MB7985.namprd12.prod.outlook.com (2603:10b6:510:27b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Fri, 3 Jan
 2025 20:01:16 +0000
Received: from CH1PEPF0000A34C.namprd04.prod.outlook.com
 (2603:10b6:610:116:cafe::b7) by CH0P223CA0024.outlook.office365.com
 (2603:10b6:610:116::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.14 via Frontend Transport; Fri,
 3 Jan 2025 20:01:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34C.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Fri, 3 Jan 2025 20:01:16 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 3 Jan
 2025 14:01:15 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 4/7] crypto: ccp: Register SNP panic notifier only if SNP is enabled
Date: Fri, 3 Jan 2025 20:00:59 +0000
Message-ID: <674affc649968994f95b6259f162d5f0732b102c.1735931639.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34C:EE_|PH7PR12MB7985:EE_
X-MS-Office365-Filtering-Correlation-Id: ecab5043-c0bb-4a1f-cc8f-08dd2c316220
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M6xfg7RMdNuyrZDl6oT0/BQ1xKLPaqVTW6iGZ8oQ8xi2ZUGE/p285YKcxZH9?=
 =?us-ascii?Q?FCAcn1VZtvVyLlftUF5RtqiZprELcmSeVmuFLZe024Za8UIaFgwVxrIlWjSn?=
 =?us-ascii?Q?cECTKL+ee0g8gBbmdnu4ne7GjcyuBAbkHhe6szspjT2HcYENxrj7tmNYzoUT?=
 =?us-ascii?Q?7J8fX5l5G4aRZNLm/OPVvhHWKsQo3ojaEFHKY4csMjWwP1vd7Yra1xJNhH1X?=
 =?us-ascii?Q?pDdLqTOxHNZijjGkziOALH/KHM4t30B8NAMmJ4F1NVomSfYYQYGEbMflN5sN?=
 =?us-ascii?Q?9t+1hYOM76hIWjwb2xxc9hL1IPlfY8zl65HTkODSRRH1/yqYovF2vZmJCBSZ?=
 =?us-ascii?Q?C8hTfw/8Qk7ztfNVft7qTN4TVdPlvEMwx/uN5sNiVIL5SF9NrG91zGzzKmWt?=
 =?us-ascii?Q?Ku+H1dN0NoBwOq/959WhGc3ht+1bnCFxFRPvYb3d6etbZzWAsleejKpe4IRf?=
 =?us-ascii?Q?yNe26D0XKMGZbTLXcFVjekVAPFbeEYi0dDL+I6RIN8fU/qYWEQJzRKNlJ+km?=
 =?us-ascii?Q?uTKMNxVcRkfSpLOlGT0Nt2EldSQjJYz1szt2X0G0+wOUUlFyNSW0iAUjy9M3?=
 =?us-ascii?Q?3FWVKn+JmL/vozmHtTAJ05gJs2oLt8qPQdOae6AKMrnNrZinuWAuKWnDQcXF?=
 =?us-ascii?Q?zQFCDSVgBoiLWXD9+e8WIeZhCmU7Tw8wOtoMFbIwRjEXFnuefbNXXNhGOPNa?=
 =?us-ascii?Q?kk2dCyrtVW1C3BRP32YHbUqkMqroM4hOvkhFPZ5UtwrEjEOWp761+VlVNwow?=
 =?us-ascii?Q?XFLwWCU1scsl8yUvhTvnuTuEXY0iX5gOde9D1ZaBlfFU4MZwJnGXYbp7PmC5?=
 =?us-ascii?Q?Efpg7Fatyjtzhj5JPphVB3DLNvqJX3dt/hX2whRAFYD1QMXzdw1735WmZD43?=
 =?us-ascii?Q?gVve6O5JNxg3fw2XLbCjJvI3VljaBiEaIi/mRVSw2W6f6thge3zNreWf9EHk?=
 =?us-ascii?Q?qkmAywSQQ/ddoT+tKOsUUUhOh9SyAY5+GyJzfoRT33ZPe0N9kSvZ7aekVs4V?=
 =?us-ascii?Q?8HHyb5s8r3BQZJ/y5ESYnUqTaCy4rbvVutiAY8SA7pkOruC3AkQi2M6yfPJt?=
 =?us-ascii?Q?xApw+oVLXYkFeQVVY/56dFpg2xXPGDdeKZs5oPyseWfFaKWDRyTm0sCj8JJ0?=
 =?us-ascii?Q?FvzUd58ax8fC2mvmrg1gOj0iOs7EVB1Z6TCHH0o8K8kBjcBgCVo0tkJ3LChw?=
 =?us-ascii?Q?D02Kxz14QOhau7KuGRFhAbWbGiAQVReZ7mHJtwdU9qfRQLCRTgFG1v/m+wju?=
 =?us-ascii?Q?i4QVePmZkhm63Ydz8U+mbrc6UEhu/03vAm2v3Lxd/+RwIvra09I3M76k3tJC?=
 =?us-ascii?Q?ylj6DTYY6kwYDh07NJLbuyj3Gku+HElhE+MDYdI6vREJOMz5ZjbMCJjl/SWx?=
 =?us-ascii?Q?zgv9wdJq2msls1iemh1j+is0MB+G/3b/Bar71/m1yuhXIN23kPIgFvEbbOij?=
 =?us-ascii?Q?nXFGwl2TQfTxJM7tRJdWvGz5fvJ/F6/F5q7io0z+EHxz47RiZLHRm3YVRBsE?=
 =?us-ascii?Q?O3otm01cJ1ecibwHXmSk8P+y1Naf2kO6ld4n?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 20:01:16.7033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecab5043-c0bb-4a1f-cc8f-08dd2c316220
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7985

From: Ashish Kalra <ashish.kalra@amd.com>

Register the SNP panic notifier if and only if SNP is actually
initialized and deregistering the notifier when shutting down
SNP in PSP driver when KVM module is unloaded.

Currently the SNP panic notifier is being registered
irrespective of SNP being enabled/initialized and with this
change the SNP panic notifier is registered only if SNP
support is enabled and initialized.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9632a9a5c92e..7c15dec55f58 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -109,6 +109,13 @@ static void *sev_init_ex_buffer;
  */
 static struct sev_data_range_list *snp_range_list;
 
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
@@ -1191,6 +1198,9 @@ static int __sev_snp_init_locked(int *error)
 	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &snp_panic_notifier);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
 	return 0;
@@ -1751,6 +1761,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
+
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
 
@@ -2490,10 +2503,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block snp_panic_notifier = {
-	.notifier_call = snp_shutdown_on_panic,
-};
-
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2542,8 +2551,6 @@ void sev_pci_init(void)
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2561,6 +2568,4 @@ void sev_pci_exit(void)
 
 	sev_firmware_shutdown(sev);
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }
-- 
2.34.1


