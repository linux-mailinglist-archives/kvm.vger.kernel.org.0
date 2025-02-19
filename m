Return-Path: <kvm+bounces-38600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2570A3CA71
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C96207A4F9C
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD9F2505AD;
	Wed, 19 Feb 2025 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1eHErlWs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619DC24E4D6;
	Wed, 19 Feb 2025 20:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998444; cv=fail; b=rVy6t/Wo0q60G20t9q0U6RhguY4DRpea0e96Cvreo2ZN6Yu2imm8QCw96AUOkPIwnmgdy178HXz9/VoMLEKVZr09YU9F/2PfjYg74h2jMpgpR1Oe+Xlny/oqw3XEdLJwQThX59Y2jorv5oqAX08I7bBnTunD154/ngYZHYxhYIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998444; c=relaxed/simple;
	bh=W+zO5H/yBf0Y87amRVHWmTXBwTzyJ0I7tqfdus2z+CM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qpPmsjhMsWD+jO+p8EyBJvk6GkFmjs9+O33nQBL3BnulhUQHAGnohqOgWrghuLi0VH5j71/6EFDbLheEaxEzTqPAR2mzuTr7FWf00Sm6sRmz5F4JQnET4oz6BD5xECx7531ajsc39O8s2nViJVhBqa0TSy9gjtJNu7pX/aKVzrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1eHErlWs; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WsIjni8Uht+Iurk1CAy8M6x7M64i1MuSdtpPZ2OdTPHAHyGUIxggnKlusQVll7QUbo2vbPU4RvA3BWSxsNPAtyvJJCKs36OniIaoK3MJkJZt29x2Nk3KAIZrWSBhzkETDqBKoCUuENx5aqRbQLMC4DLPZm0LZX2e7+NZdzhJT0dsmK5eORjrGsW1TxeTARIWpFEwehzx5vP8BtXxn63bX/9pMpmv/ySp2vHc+8wMvTBuBrOcr4rubZjVFVUm/Mfv3/6aiqVyo/PXYOjEcD87irQZNsN8NkMNU6FcWXqyGsz4gJODTO8RQzZJadHdVSdi0RrAUyJl+ybo9moeXrlKgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57ZM5GRB6jlWiRwDBCaJDG0EsZvhM3yo2Ff9O9KJt5Q=;
 b=nFpWpoql+QemvwAAwjD5epWCVZVykLX16fa0VbZmhym3JM7quPtDdpUX+oyNUx561hZN3otbAgNP8gglpvAEeTCBEsSNDtvC4v53zDYRdWepZp6HcXY/kTlhAmO8zdP+G/hprtkc1DA5e1cdYwHtnG8//mTFCcdf3FM8wDB9SFa1NcqyUu0MzYbyq4jGw2YeE9bkKXd1Hen3RoendUq23wIvPrxkL0V2PSYXxJCpjaLMPzAlDq1YwWFivBHAbrkD7PLulU7JrVrXyWzyhP/OqQT1rFNS1Srsbdgo65sUWOrsc2N9ovAirxqnm5DfPKjXcw3KTWij48zG8xh2wUDtGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57ZM5GRB6jlWiRwDBCaJDG0EsZvhM3yo2Ff9O9KJt5Q=;
 b=1eHErlWsGrpjfouCfJhYzHYIItdxKjIfO6NDinYilFabK1Uv6Bc/2FbAkQAQTMCrxXYJyxRKiFWMuMs0i3n5zq5ew+6WfCFQY6WDABeOwKM7WAWDDOiIsQOz0ZwmVLJ3d6kjOfYkh8mexM55v9c22osPKfTWzVJSd0geC3VIhVk=
Received: from SA9PR11CA0029.namprd11.prod.outlook.com (2603:10b6:806:6e::34)
 by MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Wed, 19 Feb
 2025 20:53:58 +0000
Received: from SA2PEPF00003F63.namprd04.prod.outlook.com
 (2603:10b6:806:6e:cafe::94) by SA9PR11CA0029.outlook.office365.com
 (2603:10b6:806:6e::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.19 via Frontend Transport; Wed,
 19 Feb 2025 20:53:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F63.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 20:53:58 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 14:53:57 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v4 4/7] crypto: ccp: Register SNP panic notifier only if SNP is enabled
Date: Wed, 19 Feb 2025 20:53:47 +0000
Message-ID: <de3a9cc7808dcf3636e2bd2e48c2db06d3eab502.1739997129.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1739997129.git.ashish.kalra@amd.com>
References: <cover.1739997129.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F63:EE_|MW3PR12MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: 61599ddc-e851-4564-3d9f-08dd512787ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?clS1axELE+osr1LK/HtMUE1UY2O0YgV/18RSiccoR4Ax9reloPpfGzmkSgmK?=
 =?us-ascii?Q?sB+r34wG6BgiahcLrt1l58Es3YhH7tqkqX2xFW2R8wgPpD7XWuBcg75ai44E?=
 =?us-ascii?Q?rzW7s7wuz1KG9jt7sC7rl3GnPZJvKlnHcHxEiJxuq3yk1aL8XGjA5yXaVXjW?=
 =?us-ascii?Q?dpVUyVbmjAEkjpT29GZmkGex93dUcmmA2VO0SoG7TdjZ63Sfuc07kQfNL7HQ?=
 =?us-ascii?Q?r7kg8I6aqak4UXtXyNFYnRw6rgHIulren6mqAXpoygi4cq5GgroKhEIG4dc+?=
 =?us-ascii?Q?S2YdZtavTuy4MZ5TBbpMem2hu2r04j+v+61HTVFieg76LbStvd8xIFUtc/4U?=
 =?us-ascii?Q?On/8gHKYLOqHjVxrDXcZv9EQBEoxggOAnOA1B10I0ZZ9xphkhd33VHuuXpkH?=
 =?us-ascii?Q?93i/ajESuvwJUhSealSq7lvKHs9lQN6hrU5X3ydnbsTYVk3caKsIzZzQLyPh?=
 =?us-ascii?Q?Oog6+5NNs4I+//EFH20fZZ9WFZwCj2z0OiFWR+o4j+OYTaMLkQ2zyxJ9Nf6d?=
 =?us-ascii?Q?P09TWSw2Eda/71yr0rNJ8pcE3LcA8MCDkt8IPP+1PNjkkyssM+0ztH0Bz4Ux?=
 =?us-ascii?Q?HJCwm/QFOQqzEP1UU8kvFunAsbLlCIBjnwhjafl0q//fsrGJ7ydJBYGyJapa?=
 =?us-ascii?Q?P59UGi7Knilg+Q84EHzMiuc2wc7Wfpao+62RAz2PzvPJDvG2wYWznCrlrn+l?=
 =?us-ascii?Q?TffXkMg3dmdGHcZffQaplgI992J0cYjR0/YdVkMvYVgbNgfWtaN4oi3+4rsJ?=
 =?us-ascii?Q?SQKjQVKsyE+cmPj5FDp/RqvlWiw3JkJSCHnLqRLqj7p+VoJw4AlMnswrZtkm?=
 =?us-ascii?Q?KMhMFa56svunmSo/fpl1NmhOpGe29OKWNvB5w446YpNihIHR0BPZFU1LRy2/?=
 =?us-ascii?Q?kAvAkQXf13prDB0Azu81+gUXLkvWiW8aTkHovRgdDyLzM4LtPy+TlIP1dx2Y?=
 =?us-ascii?Q?PzO3nEjtvoYLYWV9qDSFdpDxXDcv7HCc29QlDFUn+GA3vCLrfFAma8EKU/Da?=
 =?us-ascii?Q?IiTmSk9Lv1xfDwpWjeIZlog8fmtvmebPHEHNurXGNI6y3OCdAtf3M4Mxb1hQ?=
 =?us-ascii?Q?U+vblJxCZ0oNEThuT9PWR7rdDuX/gcm9o8CtRpjxxF9MTNkmmvzJjrTUcPnO?=
 =?us-ascii?Q?514aD3OLevKkVa56N71CB8Gx2jvAWpW/P/SRtTxnZ57AyhQeygW3LWO4Slmd?=
 =?us-ascii?Q?p4fW4PAIrT2lDuHIzFgT1ASnDMtJZlmNadUbHj6dgeQX8MYrufToikK1dSGP?=
 =?us-ascii?Q?2Re8aG3dJvdOjUjDkC4EaYNhlCEY293jqNCwsln/jMCThMMt6PezPNrcZfQQ?=
 =?us-ascii?Q?EpPMvHJrsCQX1rWNAWD8srJKXpzNFc1k12ZC3cc9H7s6pq0OjjElUpvjkmXX?=
 =?us-ascii?Q?pGuwHIbxNt9TVxoxowhA8AnlJGFnFTHFku7J+aK7f9Rp8FtmOcMoUWioF9Dq?=
 =?us-ascii?Q?7oz1e7zXv3WXeVDlsHEXffXrZAf+P+anth4bZHhoawkSNQAx4NqfpsZr/0DP?=
 =?us-ascii?Q?5vhGHr/DwGqmCTmFru4UqwEB5CBopIv+LNG2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 20:53:58.1809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61599ddc-e851-4564-3d9f-08dd512787ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458

From: Ashish Kalra <ashish.kalra@amd.com>

Register the SNP panic notifier if and only if SNP is actually
initialized and deregistering the notifier when shutting down
SNP in PSP driver when KVM module is unloaded.

Currently the SNP panic notifier is being registered
irrespective of SNP being enabled/initialized and with this
change the SNP panic notifier is registered only if SNP
support is enabled and initialized.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index be8a84ce24c7..582304638319 100644
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
@@ -1197,6 +1204,9 @@ static int __sev_snp_init_locked(int *error)
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
 
@@ -2466,10 +2479,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block snp_panic_notifier = {
-	.notifier_call = snp_shutdown_on_panic,
-};
-
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2518,8 +2527,6 @@ void sev_pci_init(void)
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2536,7 +2543,4 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
-
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }
-- 
2.34.1


