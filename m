Return-Path: <kvm+bounces-52367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9158DB04AD4
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B910F1AA0312
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4BF85103F;
	Mon, 14 Jul 2025 22:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ebwsnViq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2842D23ABB9;
	Mon, 14 Jul 2025 22:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752532801; cv=fail; b=PNOXbZkBcdnLlGlAi8JAfSGLPd4wePog+gJzVIRG/ixV6mvsv46aEE4Ev4n0cEaXmM+vtx+zWNqB8RnjqRv90fmnSe7ONhghK516ja5sm94+GwoBuWrgWZQn2yGYrovbvmylAWWi7tCNXiCcvaV343W8UpK91FqVyWfBJN4Hn5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752532801; c=relaxed/simple;
	bh=6qWq0iY1vj8BVVAWKLvKpxS6hB4nytt/u11JQdBH2oc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EGZfub7aZb34BkLtqY/l3gVyZweZErAJs7k4cgjChe34QF1zqTu94xw8la0rOIUZs6BjlpL0/7ELvLsu7CPM8aX1q2pI+VjCsMk3OhfVxAdGHm0ezvLWfCTBR6HJVtBfg12uANAhOPU2SxEIV/EgC2jvNESBVAlMuT1LgQkA1Gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ebwsnViq; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykbLecUJgY3c0g85fyxb/fQld8+lbKwQpxKK16k3QxjA9uBTCG72y+n6+qoAJdQgm+JfmgD7TQUtCSCX+20TS06SIKFu/gDsB3pbLhG9DTkGYUbf7Eul2QbGzlsdeIdM4aYIf9HvXccM67RZkayxu6RGul4mtspZjQX2d+Ok3dU/W5KfiUH5wJOb7/3klqZIXK+gUTUbL+Q0gsOtueOIGq8dpBn/Cx9p+dmeYvmYiuN8XnnlpwlHQ0TK3T+tQXcFwcbfBZMUK42JormP+Rm2sLuLlEB31qVu0OszEkqz0NlObkuh9Y1eKuhv58vIPDCm9pBAiQ0Bm8xfP4e1GkC9KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmVMMcDneRK2iE1QcHklTDa33H/bBW96LFaSTQxc5nA=;
 b=ITZwrLgPMtsKOAip6sGa07e6jCQ7F4GiGkOGZXHBWkUnZ/zfkd8sVSnwfKDNr+Gag7F7Gf1FD59S3sF/vH7IbaXcIr6RPsIm+xXeoHq53JP4RXn5VDyHjhVDV/cn2M5NtRx8xLGzci/5eiNvtvpmpqqz/CqEIpNump1tWyf+ngOXwDkf9CCfIZ5wp247iC3DYs4EfG4H+tnuTydSm2MwstmSo6kZw8I6xPKRiSrKmx301IJqwv9gJSlV7iYU8KAivCnzhBdfCqMaaVjKDWQjpLbWhRpI2CX1auXSdxZOSH0BXNualGAw/GI5HkJfSwdoxuP1qO5hoTgxLUzkEfAiRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmVMMcDneRK2iE1QcHklTDa33H/bBW96LFaSTQxc5nA=;
 b=ebwsnViq0hdyFqK1wAJXCqBbgyEcBSahDtUGr4ME7uWgZpCN3VqJHWun9V93Xm074vQWsZNjGUkpE8Uu/T9ew73lZnec2tK7FjMU7nU6UXUX8EBZURVPvNTvhKZsG3/U7vBXfU5iTc4ov6sqgwjqXfwSpEF9MuudLMTtgqNjHQI=
Received: from SA1PR04CA0001.namprd04.prod.outlook.com (2603:10b6:806:2ce::8)
 by SA1PR12MB7247.namprd12.prod.outlook.com (2603:10b6:806:2bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Mon, 14 Jul
 2025 22:39:54 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:806:2ce:cafe::9a) by SA1PR04CA0001.outlook.office365.com
 (2603:10b6:806:2ce::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.33 via Frontend Transport; Mon,
 14 Jul 2025 22:39:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Mon, 14 Jul 2025 22:39:54 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 14 Jul
 2025 17:39:52 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <corbet@lwn.net>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v6 2/7] crypto: ccp - Cache SEV platform status and platform state
Date: Mon, 14 Jul 2025 22:39:42 +0000
Message-ID: <fb1367ab6e6ba6220dc310424d4750266c51dfb8.1752531191.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752531191.git.ashish.kalra@amd.com>
References: <cover.1752531191.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|SA1PR12MB7247:EE_
X-MS-Office365-Filtering-Correlation-Id: b1636ef2-1fd2-4dc6-13b6-08ddc3275a7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BWMpoM8H4kZ8JcOT21z2JRnZkPMmoCEDefopimtspk3XvLJIQ5HQFie8SHzU?=
 =?us-ascii?Q?pGryPo8xY2/U1b/q38h/uCVkaB5KdhmmD1WWCWXJC1doLBotsZkZZ0nxLLRu?=
 =?us-ascii?Q?kF5Q8TokVtHWraJBrt3EfLFlIkGRMGqW4FpJNQ1SlDksSpDvAzNui60cUWQ1?=
 =?us-ascii?Q?rVcQd6vYUxy1yvtXsueLj7klzdOdRl7TA4sXBKLZ6aLf+V2ZqeH80rB85RVf?=
 =?us-ascii?Q?s66PxKftPG3s70lXZZOdMobEmht6TbpDZ+cdk3RjH9ZBnDfrniRqfVKp56Ma?=
 =?us-ascii?Q?+DQ8f4399K+G+HNae902+12rMoIbpUyRwKW2XJ/30so46W6IaLtI85eJ//a2?=
 =?us-ascii?Q?7RxT3cCYrTqMQD4Rx/qttXgir3E2xaXFhgdQzajnndPcg9GvxBMooUdF2fNr?=
 =?us-ascii?Q?b2jJfqfYyLEplBPqTovVgcJ7pM0Kj2Q8zmpuEc3l8aqQwZyV8zJe7AHSI11X?=
 =?us-ascii?Q?+DhTwizr7qAg+M2+qs4VF4JcY6h82IR2UXACgN5quSXByPA3ukOJL8y5jN08?=
 =?us-ascii?Q?6NhVNPI4QeYQd6cwji1UlyawI5Qb9Ygm+otICZaTQbVoVxfAEwweH/WW9u86?=
 =?us-ascii?Q?6FAZZzsltx2Eebg/pOts9RFLswBR/2zNfT0Yiok+GxyAkSkGwEbTpIlODWqG?=
 =?us-ascii?Q?C8tqn5zwQ9hehklQ9q7ilhkobCx5o1PkboDiekvo9GuDRlpbWvw3O/GpaiVA?=
 =?us-ascii?Q?VtwAHxjBkWXvRiUMZ7z/ow5BqUijDu8r0Di0ht4jVIemiG5qrMMuOId72t0z?=
 =?us-ascii?Q?EywQNtqpl5mV3LWns87FuKagu4icWALj5JGTY/E96rrgBZ00Ezq452AOnL9Q?=
 =?us-ascii?Q?GueDDA8CTRoO6ypjOEQ0c0gSwj2J9i0whxpk960JvQ2YYNKNmtklW/Dv13jZ?=
 =?us-ascii?Q?GR+QZLh9wUde8lCwLROgiXFtl8Waduqb9PHUdiD1Y/JbBUCDRNBOo+06PuNH?=
 =?us-ascii?Q?8l3slDtbCDVhTh89cYdFywGYun35GjagYbHDftvb5IdJjfivXZ/WUj6yrE7a?=
 =?us-ascii?Q?6HDvphAdVrnFJDFVOrRAZ9qIepEHUFRB6NI087/qO6lpLcekDWmABzGA+wFj?=
 =?us-ascii?Q?hOlR6fxnD4fVvZG6wUhoo/ejSoTyKljyjHYYnbaSyj9LorvlIZOKJ1AOH5t8?=
 =?us-ascii?Q?lOie0OC3O8l1j0uYTXujcZ0tNQtvgc29ccH3uxVsiSLHoBTFW+gr45tuGNQ+?=
 =?us-ascii?Q?NeiB9TKIcJwIJpCd292KzfZ85gjIEh8Rzo4mAfrn/64Jf4Uruep19c36eUJN?=
 =?us-ascii?Q?aKYGdenoW1BrZRx512cLj3Z6IL/rb6xd0t81VBvTAsfEgVH4ygHMzce8OnBm?=
 =?us-ascii?Q?RD3sc/gV2co8H6+lxWx+4HUTABrYjrhJY4vgpif3rJln2k/+pVRd6KX7aMmu?=
 =?us-ascii?Q?baa8SLhNX31oJOb2yxDOAEcjmKPFexUH53n3DY3Lvo1EqOtHmPEIoEOqx6zF?=
 =?us-ascii?Q?wfItxftjG5pLbyx0FFrcMjBc7TRsQ56u1Yhfqlpu4n8NSvvmoQ8J/TM2lNIB?=
 =?us-ascii?Q?HPz6ewNp3v+QXPSW9o9Lra+4l6kf/8+S5R4F+mujCT06mnbV4V//44duCg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 22:39:54.5118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1636ef2-1fd2-4dc6-13b6-08ddc3275a7d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7247

From: Ashish Kalra <ashish.kalra@amd.com>

Cache the SEV platform status into sev_device structure and use this
cached SEV platform status for api_major/minor/build.

The platform state is unique between SEV and SNP and hence needs to be
tracked independently.

Remove the state field from sev_device structure and instead track SEV
state from the cached SEV platform status.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 22 ++++++++++++----------
 drivers/crypto/ccp/sev-dev.h |  3 ++-
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e058ba027792..528013be1c0a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1286,7 +1286,7 @@ static int __sev_platform_init_locked(int *error)
 
 	sev = psp_master->sev_data;
 
-	if (sev->state == SEV_STATE_INIT)
+	if (sev->sev_plat_status.state == SEV_STATE_INIT)
 		return 0;
 
 	__sev_platform_init_handle_tmr(sev);
@@ -1318,7 +1318,7 @@ static int __sev_platform_init_locked(int *error)
 		return rc;
 	}
 
-	sev->state = SEV_STATE_INIT;
+	sev->sev_plat_status.state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
@@ -1347,7 +1347,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 
 	sev = psp_master->sev_data;
 
-	if (sev->state == SEV_STATE_INIT)
+	if (sev->sev_plat_status.state == SEV_STATE_INIT)
 		return 0;
 
 	rc = __sev_snp_init_locked(&args->error);
@@ -1384,7 +1384,7 @@ static int __sev_platform_shutdown_locked(int *error)
 
 	sev = psp->sev_data;
 
-	if (sev->state == SEV_STATE_UNINIT)
+	if (sev->sev_plat_status.state == SEV_STATE_UNINIT)
 		return 0;
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
@@ -1394,7 +1394,7 @@ static int __sev_platform_shutdown_locked(int *error)
 		return ret;
 	}
 
-	sev->state = SEV_STATE_UNINIT;
+	sev->sev_plat_status.state = SEV_STATE_UNINIT;
 	dev_dbg(sev->dev, "SEV firmware shutdown\n");
 
 	return ret;
@@ -1502,7 +1502,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 	if (!writable)
 		return -EPERM;
 
-	if (sev->state == SEV_STATE_UNINIT) {
+	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
 		rc = sev_move_to_init_state(argp, &shutdown_required);
 		if (rc)
 			return rc;
@@ -1551,7 +1551,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	data.len = input.length;
 
 cmd:
-	if (sev->state == SEV_STATE_UNINIT) {
+	if (sev->sev_plat_status.state == SEV_STATE_UNINIT) {
 		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
 			goto e_free_blob;
@@ -1606,10 +1606,12 @@ static int sev_get_api_version(void)
 		return 1;
 	}
 
+	/* Cache SEV platform status */
+	sev->sev_plat_status = status;
+
 	sev->api_major = status.api_major;
 	sev->api_minor = status.api_minor;
 	sev->build = status.build;
-	sev->state = status.state;
 
 	return 0;
 }
@@ -1837,7 +1839,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	data.oca_cert_len = input.oca_cert_len;
 
 	/* If platform is not in INIT state then transition it to INIT */
-	if (sev->state != SEV_STATE_INIT) {
+	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
 		ret = sev_move_to_init_state(argp, &shutdown_required);
 		if (ret)
 			goto e_free_oca;
@@ -2008,7 +2010,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 
 cmd:
 	/* If platform is not in INIT state then transition it to INIT. */
-	if (sev->state != SEV_STATE_INIT) {
+	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
 		if (!writable) {
 			ret = -EPERM;
 			goto e_free_cert;
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a..24dd8ff8afaa 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -42,7 +42,6 @@ struct sev_device {
 
 	struct sev_vdata *vdata;
 
-	int state;
 	unsigned int int_rcvd;
 	wait_queue_head_t int_queue;
 	struct sev_misc_dev *misc;
@@ -57,6 +56,8 @@ struct sev_device {
 	bool cmd_buf_backup_active;
 
 	bool snp_initialized;
+
+	struct sev_user_data_status sev_plat_status;
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.34.1


