Return-Path: <kvm+bounces-20259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7529125C3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFAF01C2555A
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C0116A943;
	Fri, 21 Jun 2024 12:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DY0KCh1d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCCA16A927;
	Fri, 21 Jun 2024 12:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973618; cv=fail; b=oMQyOfN0wcO8S98Eafb+oza49QCi8pmTYM9k8Fx4i3Ck28UhlpHvxdfKEo9zYQluQgHvBLJFfBeBExlyOzlOO7+kU5Il0bxAF9womMg7m874YKnXwr/NZ97yhtIw4QFbq4wIW5EgYyuraCqnVjqMu0cBwGlcs/de0i71W/QixRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973618; c=relaxed/simple;
	bh=hw2ypxsU/OlQ5hhLoV4eAWgO4O4WTs5u+bGflflLMiU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFPxrz1N6/X5z4OG/n8n29+pOHdnaAKThVVefeXP8npgTEn/LmdpzxTHbO/KC9nlUFaOwxLaoKysBcuSOSQoKfXCFlo9kb7gaRjMsT+cnryHTEKJeKDNbo3U9LTdW0LDSVnj1ej+jsznAyg9X6+GdsK5uEOZ/bXuWJis/ciTUsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DY0KCh1d; arc=fail smtp.client-ip=40.107.94.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UR+TiMmiyExvyYapPRF57lZiEn8ptT6u7b1ytpNiCKocr6o253GR2aZQqFNkiaMlH0+UijPGWoa3qJq4+SVuQVsrky3Yh+2K4Yy+bQd7GHIJgcW9apmhDCvWc+8NrW1MSIOxbs/SAWpAUP/e/72vVQjHLejoMItIXBfCcLoMxxSCnRouQ0NrFoP2M79aI0YOxDWb4O/U62HE9zVYogKfdyRlJktI05NKAjunm4pjed1U+e3PTVXxW39yT/GP0Lb0MnHYMeFmICXfEgh4Ojjj6lUUM0wIyZZEZcUdwo4kTm2+0ClC76dDoU7zmDp5fDicSAhwykxEFOXA83a610aJ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTwQYQKrrnyJMvBHp5qT/wTb0qk42zn2W+TQxdpC3Lc=;
 b=muezCZQ9uMo9KXhZ3lZsCUe3a7f6/NzPI2b848Z8uAP3NV0rukz4oFRJsthDcZAYdRpqakVwab9rG010QkbZ6M6H3OT5LSqR1b+3SQmMHI4ssIOlfdOwY0VMcq9TdQvBiobfYitk2AWmYeCM3k6YGXc5s0dQ+XFp5vpinNguneIgrWAS9PLRxC/toMrsTOgbMxYW15ASFWEGUt6QGu0bdKsg1Mhyk4yyBtX8KdvB6LjVUcBNZ+XQbR2VzlQd0ZANkstKpRElElzTJZ5viahPt6KjsOMJ1PtU/YqPprE7dbgA4brn4gARtrZwLgwBiyCtlzm/0wqLNTdNRUqOOZ2XzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTwQYQKrrnyJMvBHp5qT/wTb0qk42zn2W+TQxdpC3Lc=;
 b=DY0KCh1dANpuFuw4/rJcA/bfJYt86MT+6eMFtjYHEVvE0joUMtBTsKqO8Qnm2DUjc4w3KW+NFZFR6K9fwP0Ggl67BZWw7bECExUg0opKQMFVGMqxdVqyp+AZ3F+TQHOy+FvhN+O0fZ/nkm4Kf2XDHWZRqyi/Q/3OxPVPjxJyCUQ=
Received: from SN6PR05CA0026.namprd05.prod.outlook.com (2603:10b6:805:de::39)
 by SN7PR12MB7204.namprd12.prod.outlook.com (2603:10b6:806:2ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.22; Fri, 21 Jun
 2024 12:40:14 +0000
Received: from SN1PEPF00036F40.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::3b) by SN6PR05CA0026.outlook.office365.com
 (2603:10b6:805:de::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F40.mail.protection.outlook.com (10.167.248.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:14 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:09 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 13/24] x86/sev: Make sev-guest driver functional again
Date: Fri, 21 Jun 2024 18:08:52 +0530
Message-ID: <20240621123903.2411843-14-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F40:EE_|SN7PR12MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: e4b6c551-b60d-4ab7-d2ba-08dc91ef4c36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|376011|7416011|36860700010|82310400023|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QTydMQbtMktRJi4mgcTobNUlfG4O1XXy/f0KZHLL++vJ7AbFEKpSdKsodUMa?=
 =?us-ascii?Q?DAediq9JzfvrrvIfNjwcxw+ex7qlpfMxnfKynVfVIikNN+qTVFCob8IxLVgM?=
 =?us-ascii?Q?dyrhBjlnFrjiHCdp46xN5DbretWo3zXRI4JcTz9+trZOfD4l6uD5wZwg6JTJ?=
 =?us-ascii?Q?4y72eyYdFZ+zJgS//TCFNibSeTAFcRWeBj+9WM1owuIwSVfmfI13fyeQuKXh?=
 =?us-ascii?Q?03ca6i/vc1TeJav4ECIwu9zs/UqzpTRhZeu+e06FiO7xVFSUwVimb8YbGpmH?=
 =?us-ascii?Q?9w2/L38RBQxRNZAEMzHKaghCVwitMNvcWws/3Au8r/33ol41V9u0lFH8JJNf?=
 =?us-ascii?Q?2jyGkzA92YvtPA2EZjIttbM261HCiOOaJDmmujipp1mF48j83xdsCsrh1u/d?=
 =?us-ascii?Q?Xj/DqhH0++rr8aXCpKItBtQv7NcjYxKgMe36vLRY7gNm9PKg1rE0J4HvzDKt?=
 =?us-ascii?Q?Bw/xgXQQhq9P+bfpmYFTqvGpW7zSI5ESloZT0gn8pI0UfRTV0RHa2Gxrs8aI?=
 =?us-ascii?Q?IcTVYGXGOJ958Xic8cpIbM6sk1RvuTqUIiJ749KUeGv+MZnZIYmGbPCk3cl2?=
 =?us-ascii?Q?6gxvEYTteN00Bzlg3gXnbt98UjKfOiG5BBauysskLTXIyj7ATSmOd06jpNhu?=
 =?us-ascii?Q?ZqK/MOBL+4hO+wuxny+EavXBU2t/+yU3jjMLApCChKbzCccJa09KX3xIqQah?=
 =?us-ascii?Q?V17NZ/oBFutnqo3mUEtor4WmV5aXkrUkiJ0Ot6ajR9DzPwvTNdpoZ24SnG7A?=
 =?us-ascii?Q?jkmbnIsKulolM3c+hf5nUwGmLarcZKVXRJR/H6tO1UaPjANGcjdQwDqRnM6j?=
 =?us-ascii?Q?XogYzv/HTRe4lmz5vyMG7jg4A05lo2PZU9Z0nMXkURhyc4GmjaMaQxToolcl?=
 =?us-ascii?Q?IdHw0a0tOLHGUHgXQYEw6tYiYUR3Eh9lyEcGPhVwe1bvDHhJgRW6zWed35BG?=
 =?us-ascii?Q?LnlrdL0mNxsFFd5KH1c/3ebwok3/M46IVoJVS6LLDhUm4lr+fE8XZxHAlJ4X?=
 =?us-ascii?Q?yYZyMhh5n3+h8il2b1DyivGbkaUo+EHztL/HcDVnxcMWjcnTcmZi4rbP8Efj?=
 =?us-ascii?Q?5JNblXelFCEp9uQEKvHTjkVAei/LW3kwulZlIDP372pHiub1do6mi+OH7HL4?=
 =?us-ascii?Q?fqyXJVR8S3pr+ZRzJmnlpObYrxgqbvQX0iSfiaLgGqxMCZvYR/e+cCeKgjF5?=
 =?us-ascii?Q?PLonJRfdFL/hmKgGNNmo/QEIrZAbJ62QVOuGhSMcf6tM4YUZ04n2eWsdW6eG?=
 =?us-ascii?Q?xMRyy/2Kv0NtO0T1tx/wqlVJkoqKGpTdOQOrwX8BESVpXyRxKIShIm4S3qK/?=
 =?us-ascii?Q?MhZiRsfeGHPcxeM+saJmCn1mzzqeiLZoJujRuQKLwdKFdl6fx+fKIMoRnEHn?=
 =?us-ascii?Q?iyMhypNwPFqD5YIs5XFKGRWu0kx5K0gEpw8ySdPIZsYFXlcX8g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(376011)(7416011)(36860700010)(82310400023)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:14.0859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b6c551-b60d-4ab7-d2ba-08dc91ef4c36
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F40.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7204

After the pure mechanical code movement of core SEV guest driver routines,
SEV guest driver is not yet functional. Export SNP guest messaging APIs for
the sev-guest driver. Drop the stubbed routines in sev-guest driver and use
the newly exported APIs

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              | 14 ++++++++++
 arch/x86/coco/sev/core.c                | 23 +++++++++------
 drivers/virt/coco/sev-guest/sev-guest.c | 37 ++-----------------------
 3 files changed, 31 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index f16dd1900206..cdd37ad9e4b8 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -441,6 +441,12 @@ u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
 void snp_update_svsm_ca(void);
+bool snp_assign_vmpck(struct snp_guest_dev *snp_dev, unsigned int vmpck_id);
+bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev);
+int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa);
+void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev);
+int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio);
 
 static inline void free_shared_pages(void *buf, size_t sz)
 {
@@ -511,6 +517,14 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
 static inline void snp_update_svsm_ca(void) { }
+static inline bool snp_assign_vmpck(struct snp_guest_dev *snp_dev,
+				    unsigned int vmpck_id) { return false; }
+static inline bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev) { return true; }
+static inline int
+snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa) { return -EINVAL; }
+static inline void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev) { }
+static inline int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+					 struct snp_guest_request_ioctl *rio) { return -EINVAL; }
 static inline void free_shared_pages(void *buf, size_t sz) { }
 static inline void *alloc_shared_pages(size_t sz) { return NULL; }
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 5f5339eda4a9..9f0f8819529c 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2614,7 +2614,7 @@ static inline u8 *get_vmpck(struct snp_guest_dev *snp_dev)
 	return snp_dev->secrets->vmpck[snp_dev->vmpck_id];
 }
 
-static bool __maybe_unused assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
+bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
 {
 	if (!(vmpck_id < VMPCK_MAX_NUM))
 		return false;
@@ -2623,14 +2623,16 @@ static bool __maybe_unused assign_vmpck(struct snp_guest_dev *dev, unsigned int
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(snp_assign_vmpck);
 
-static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
+bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
 {
 	char zero_key[VMPCK_KEY_LEN] = {0};
 	u8 *key = get_vmpck(snp_dev);
 
 	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
 }
+EXPORT_SYMBOL_GPL(snp_is_vmpck_empty);
 
 /*
  * If an error is received from the host or AMD Secure Processor (ASP) there
@@ -2653,7 +2655,7 @@ static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
 	u8 *key = get_vmpck(snp_dev);
 
-	if (is_vmpck_empty(snp_dev))
+	if (snp_is_vmpck_empty(snp_dev))
 		return;
 
 	pr_alert("Disabling VMPCK%u communication key to prevent IV reuse.\n", snp_dev->vmpck_id);
@@ -2697,7 +2699,7 @@ static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
 	struct aesgcm_ctx *ctx;
 	u8 *key;
 
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		pr_err("VM communication key VMPCK%u is invalid\n", snp_dev->vmpck_id);
 		return NULL;
 	}
@@ -2878,9 +2880,9 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	return rc;
 }
 
-static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
-						 struct snp_guest_req *req,
-						 struct snp_guest_request_ioctl *rio)
+int snp_send_guest_request(struct snp_guest_dev *snp_dev,
+			   struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio)
 {
 	u64 seqno;
 	int rc;
@@ -2927,8 +2929,9 @@ static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(snp_send_guest_request);
 
-static int __maybe_unused snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
+int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
 {
 	int ret = -ENOMEM;
 
@@ -2982,8 +2985,9 @@ static int __maybe_unused snp_guest_messaging_init(struct snp_guest_dev *snp_dev
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(snp_guest_messaging_init);
 
-static void __maybe_unused snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
+void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
 {
 	if (!snp_dev)
 		return;
@@ -2995,3 +2999,4 @@ static void __maybe_unused snp_guest_messaging_exit(struct snp_guest_dev *snp_de
 	kfree(snp_dev->secret_request);
 	iounmap(snp_dev->secrets);
 }
+EXPORT_SYMBOL_GPL(snp_guest_messaging_exit);
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 228bf0db93b3..0631271e5b9c 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -44,12 +44,6 @@ static u32 vmpck_id = VMPCK_MAX_NUM;
 module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
-static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
-{
-	/* Place holder function to be removed after code movement */
-	return true;
-}
-
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 {
 	struct miscdevice *dev = file->private_data;
@@ -57,13 +51,6 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
-				  struct snp_guest_request_ioctl *rio)
-{
-	/* Place holder function to be removed after code movement */
-	return -EIO;
-}
-
 struct snp_req_resp {
 	sockptr_t req_data;
 	sockptr_t resp_data;
@@ -268,7 +255,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		return -EINVAL;
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -305,12 +292,6 @@ static const struct file_operations snp_guest_fops = {
 	.unlocked_ioctl = snp_guest_ioctl,
 };
 
-static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
-{
-	/* Place holder function to be removed after code movement */
-	return false;
-}
-
 struct snp_msg_report_resp_hdr {
 	u32 status;
 	u32 report_size;
@@ -484,7 +465,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
 		return -ENOMEM;
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -608,18 +589,6 @@ static void unregister_sev_tsm(void *data)
 	tsm_unregister(&sev_tsm_ops);
 }
 
-static int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
-{
-	/* Place holder function to be removed after code movement */
-	return 0;
-}
-
-static void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
-{
-	/* Place holder function to be removed after code movement */
-	return;
-}
-
 static int __init sev_guest_probe(struct platform_device *pdev)
 {
 	struct sev_guest_platform_data *data;
@@ -645,7 +614,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		vmpck_id = snp_vmpl;
 
 	ret = -EINVAL;
-	if (!assign_vmpck(snp_dev, vmpck_id)) {
+	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
 		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
 		return ret;
 	}
-- 
2.34.1


