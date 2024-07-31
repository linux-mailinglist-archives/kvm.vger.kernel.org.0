Return-Path: <kvm+bounces-22782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 784D99432CF
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CD6E282E53
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BEB41BF338;
	Wed, 31 Jul 2024 15:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jigwKcfX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395D91BF32D;
	Wed, 31 Jul 2024 15:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438555; cv=fail; b=VSOQXSUA5a/pVBetm2zF04kCynOqJXB7KM8o5kK7K2VRXRq4hzXARtiBKfKQcs2QRbjI2lW6NxS8mwpuzhnLSE64ZSZ/Mof+k9ymVGAqHaTExdCaEh0BaqsogC96qEdhwKVetk0PhLxYmwDzoUdQHBpArBg0hlcR180saJYi65s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438555; c=relaxed/simple;
	bh=rxCYyydYurEGQ452jDl2JXd3rWp6Rk52l2zHhsMneyM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KqAM/cLzEcEilSnYNf0lD64uvHIlImq+eQHbITBhEhZzwCAvWyHVbiN9scZ/r7Vjn2PaiXGj7zYvgZ4JWXbGPtI47Tc9B147GEol785Z+CiDQQQlS+qHK/2cvh2t3z9SUY/Ujhubs8FBMUDqZn1SjFV6hx9U44nmnX0J0nsJkcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jigwKcfX; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UMFfUGbUhEyXzKTETtAOdFewQDpu98u0C0WCj147lefHNkgy5Yyeq0PEc91fvI4Sy1eUOLtzTiDnH00qe93sMgzqMtjthVuJlm759OqieBJZQ2wsKglc2yKymq0jBierop2JUdjz0ETtp8FLzjB6+olOBfafwo9vyY1nGYPbTXemQq2eK8MIo2zVdAFhANeuU5g7klS1yAUITOq0JlDKo51pD51Aqow1Rn6IvpObBJ+XMA/A0Sl3eqikrr5vsHZtTlxlSSTW6P0nR1U4bcEeWe6yPFKgdI9FkjfknLc+yLeCmSjK6Rr7KH//EG1crY8lMVcDRjUyjdYSTNsXoxuOhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XxOGg4Vub8SIqF4B9jWB+UnotZ7bk4T7E34wGTTAs8=;
 b=rrMjS6AwUt5Jip8VpJ/W6vGTXjFyKBForS6eB2sLoCoUZWBEnB+POtS7DLXODHDVKkktjU6tBRnYSFGHm6MnRm5O5NoAjKt1u21A5EYHfmgWMF5lVcIe60g2y5j6DqHoscyHVSFVUWYxa+Y+7BoV7LDK62YribHqVnXLvXsDbJ9UnAsLuT5tm6mIo6PUZcH87x/cxYPQSlpmq9jd/5VIeQJzn5VCgHgrzMT0IFXEJDs06e478Cgz2ORKUfW6u/aEWDVgikbLG/fgWNZ86yBxS4ybzQObOBQ94ExegIup/Tz8Cwq3Zf3w2/oh0s0mg2Plcwfq/WLyu5fzBaS9f9Oyjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XxOGg4Vub8SIqF4B9jWB+UnotZ7bk4T7E34wGTTAs8=;
 b=jigwKcfXsdPBbaIy8mc4jHeSwFPTDevxg+Vw0f5Knj2ogIqp8zSurK46NQa9whhQ92Qb1fTlQeKAUe3LWQsTwSKht+p34IjJMM9L/aua4kVVtSSf9bXdLtdcymB7a4VDNAO1TSMxEF8tJreMQTwK6I3sNY8WD9+BhE7hfd4poAw=
Received: from CH0P223CA0002.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::21)
 by DS0PR12MB6437.namprd12.prod.outlook.com (2603:10b6:8:cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Wed, 31 Jul
 2024 15:09:09 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:610:116:cafe::1b) by CH0P223CA0002.outlook.office365.com
 (2603:10b6:610:116::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:09 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:02 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 10/20] virt: sev-guest: Carve out SNP message context structure
Date: Wed, 31 Jul 2024 20:38:01 +0530
Message-ID: <20240731150811.156771-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|DS0PR12MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: 90a359ec-906e-4648-4117-08dcb172ba82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y0K48bHlhKtJHczgzSy7q772uUd5plnt2L/NxWiCCmtfZglZdygV5R6Clnd1?=
 =?us-ascii?Q?1B9oyhL1U1qbR3oU34iCHfoV5i8TC1cSIl0KdvONMvZbnTtndd2gi+v0aoLf?=
 =?us-ascii?Q?EtKVrkrZX2RMibvAvmmI5TBIHQdnN3ngiC93xFg36Hfn8MAGFYBbiBjeCL91?=
 =?us-ascii?Q?wjDWNyNElen0LIdM36YmDjn0PRKPB+n6PERRu22tzxBQFB293AI7Xrc1U3bj?=
 =?us-ascii?Q?p99SE1WhZoJkMcPyMnOQl7XK8np/SGFZLoml+j7OxxfyxghfrRBFadKB3m4R?=
 =?us-ascii?Q?q1vYyR6oF2JOAHX5iBn1AkVvGWmandDyOEd6LfmAwVHFpgEb0WXsRNb/UoJZ?=
 =?us-ascii?Q?qVMRwB9CB5+zoe4JAuKecrppnMZaiqYy63fIn8awGFDSdIOZIuCrEzL7yV90?=
 =?us-ascii?Q?5sMJpXjoryMxtBKn42mur7XkMTm7qBIUo3EmAdb8kiWMhbmQT+Xm9ngL+HjS?=
 =?us-ascii?Q?0pnzlMRHif3HIIJM27vcLN+WHh8aKewyWQF2s2KmKAz3qJvOTlC2L/Gf7z6U?=
 =?us-ascii?Q?ep8ojDmcWyhOoglffEriquS5PZzzUY8ncESVzeM1AyLgx4e+8WiwyHm0TKH9?=
 =?us-ascii?Q?HrI33nG7x3XaJ3f7m9/k5qoxq8JBdU2lqjer/+4ObP805K00uzNCq/GSKFgr?=
 =?us-ascii?Q?dkFtvtp9WlVKM2O/ldUE4ko2aJwCXt2XJABoGlWS76zxGF20CrxSvZ/Ti5J4?=
 =?us-ascii?Q?3wu19MUDVzlPTMwdKnXmZ6OaFCn0XnED2w3QZgRRXsOwP2VtktRV4688CmhR?=
 =?us-ascii?Q?g6V4ThudD3aOSpWB0xL1gFJvng7AIGR9IQgCKiZhi2lT3Gy84Mzp1hCo1+kK?=
 =?us-ascii?Q?dEGyycJTuGQjgrXMFPgInsvY2Ce20R5LbxtU+PhHPvMUurtzg0BywCciu6mr?=
 =?us-ascii?Q?Pe25mILQif1DlJ2xqa7SRxxvkRDmFUNawqaUsFz/Zoa0hYgIQeginc+2Q70f?=
 =?us-ascii?Q?+LqPNnsZCgbttqkVhl5nBjtKgjN+K1OX5x8Q61GF8LekhX0ve1Cr5uKXlO+J?=
 =?us-ascii?Q?I/CDs79RvtYEWyUsuAPEVOKk1VyCQuDVQ+3bUj+sC/tIGADeQFbD0PgMQIXD?=
 =?us-ascii?Q?T50TSu1wWtqXedzpinCiyc4CabqElMzpUCPSyk/bGcdLoWaemmtvQHFXf2X1?=
 =?us-ascii?Q?xi1tM2rcSCtMaOj7xzkHzLJa8R0i0cJPkvsVfaZyXoPUx7AKuOW7Qoc0r7Pv?=
 =?us-ascii?Q?kUSCJ2GpUSl4cZSUS81uEITreXi2g2A2QvkcCcFp2l4ubHCwuo7jNT+/Mka4?=
 =?us-ascii?Q?i7bvE8QTz6TbptOyXmhfne/zt5FUOauo7SjhLpIS3H9btuZzKTF9YZ2i1YBD?=
 =?us-ascii?Q?DfdJrGa+ckHjMRKyRIK0JRYuzYLr2kyS8eccpnT3qPFiprVaaw9LKtPVtsWo?=
 =?us-ascii?Q?FeHJ8Anz0ASjatFXUUrqsj2lePl7I48W/VKkbGw4lQi+O+FwHgrKfpdL+fYj?=
 =?us-ascii?Q?ughyJsppe99cXL+E3rW8sq0iBLd5AYIA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:09.2160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a359ec-906e-4648-4117-08dcb172ba82
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6437

Currently, the sev-guest driver is the only user of SNP guest messaging.
snp_guest_dev structure holds all the allocated buffers, secrets page and
VMPCK details. In preparation of adding messaging allocation and
initialization APIs, decouple snp_guest_dev from messaging-related
information by carving out guest message context structure(snp_msg_desc).

Incorporate this newly added context into snp_send_guest_request() and all
related functions, replacing the use of the snp_guest_dev.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              |  21 +++
 drivers/virt/coco/sev-guest/sev-guest.c | 183 ++++++++++++------------
 2 files changed, 111 insertions(+), 93 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 27fa1c9c3465..2e49c4a9e7fe 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -234,6 +234,27 @@ struct snp_secrets_page {
 	u8 rsvd4[3744];
 } __packed;
 
+struct snp_msg_desc {
+	/* request and response are in unencrypted memory */
+	struct snp_guest_msg *request, *response;
+
+	/*
+	 * Avoid information leakage by double-buffering shared messages
+	 * in fields that are in regular encrypted memory.
+	 */
+	struct snp_guest_msg secret_request, secret_response;
+
+	struct snp_secrets_page *secrets;
+	struct snp_req_data input;
+
+	void *certs_data;
+
+	struct aesgcm_ctx *ctx;
+
+	u32 *os_area_msg_seqno;
+	u8 *vmpck;
+};
+
 /*
  * The SVSM Calling Area (CA) related structures.
  */
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 42f7126f1718..38ddabcd7ba3 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -40,26 +40,13 @@ struct snp_guest_dev {
 	struct device *dev;
 	struct miscdevice misc;
 
-	void *certs_data;
-	struct aesgcm_ctx *ctx;
-	/* request and response are in unencrypted memory */
-	struct snp_guest_msg *request, *response;
-
-	/*
-	 * Avoid information leakage by double-buffering shared messages
-	 * in fields that are in regular encrypted memory.
-	 */
-	struct snp_guest_msg secret_request, secret_response;
+	struct snp_msg_desc *msg_desc;
 
-	struct snp_secrets_page *secrets;
-	struct snp_req_data input;
 	union {
 		struct snp_report_req report;
 		struct snp_derived_key_req derived_key;
 		struct snp_ext_report_req ext_report;
 	} req;
-	u32 *os_area_msg_seqno;
-	u8 *vmpck;
 };
 
 /*
@@ -76,12 +63,12 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
-static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
+static bool is_vmpck_empty(struct snp_msg_desc *mdesc)
 {
 	char zero_key[VMPCK_KEY_LEN] = {0};
 
-	if (snp_dev->vmpck)
-		return !memcmp(snp_dev->vmpck, zero_key, VMPCK_KEY_LEN);
+	if (mdesc->vmpck)
+		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
 
 	return true;
 }
@@ -103,30 +90,30 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  * vulnerable. If the sequence number were incremented for a fresh IV the ASP
  * will reject the request.
  */
-static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
+static void snp_disable_vmpck(struct snp_msg_desc *mdesc)
 {
-	dev_alert(snp_dev->dev, "Disabling VMPCK%d communication key to prevent IV reuse.\n",
+	pr_alert("Disabling VMPCK%d communication key to prevent IV reuse.\n",
 		  vmpck_id);
-	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
-	snp_dev->vmpck = NULL;
+	memzero_explicit(mdesc->vmpck, VMPCK_KEY_LEN);
+	mdesc->vmpck = NULL;
 }
 
-static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
+static inline u64 __snp_get_msg_seqno(struct snp_msg_desc *mdesc)
 {
 	u64 count;
 
 	lockdep_assert_held(&snp_cmd_mutex);
 
 	/* Read the current message sequence counter from secrets pages */
-	count = *snp_dev->os_area_msg_seqno;
+	count = *mdesc->os_area_msg_seqno;
 
 	return count + 1;
 }
 
 /* Return a non-zero on success */
-static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
+static u64 snp_get_msg_seqno(struct snp_msg_desc *mdesc)
 {
-	u64 count = __snp_get_msg_seqno(snp_dev);
+	u64 count = __snp_get_msg_seqno(mdesc);
 
 	/*
 	 * The message sequence counter for the SNP guest request is a  64-bit
@@ -137,20 +124,20 @@ static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
 	 * invalid number and will fail the  message request.
 	 */
 	if (count >= UINT_MAX) {
-		dev_err(snp_dev->dev, "request message sequence counter overflow\n");
+		pr_err("request message sequence counter overflow\n");
 		return 0;
 	}
 
 	return count;
 }
 
-static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
+static void snp_inc_msg_seqno(struct snp_msg_desc *mdesc)
 {
 	/*
 	 * The counter is also incremented by the PSP, so increment it by 2
 	 * and save in secrets page.
 	 */
-	*snp_dev->os_area_msg_seqno += 2;
+	*mdesc->os_area_msg_seqno += 2;
 }
 
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
@@ -177,13 +164,13 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 	return ctx;
 }
 
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
+static int verify_and_dec_payload(struct snp_msg_desc *mdesc, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
-	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
+	struct snp_guest_msg *resp_msg = &mdesc->secret_response;
+	struct snp_guest_msg *req_msg = &mdesc->secret_request;
 	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
 	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
-	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	struct aesgcm_ctx *ctx = mdesc->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
@@ -191,7 +178,7 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_gues
 		 resp_msg_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
-	memcpy(resp_msg, snp_dev->response, sizeof(*resp_msg));
+	memcpy(resp_msg, mdesc->response, sizeof(*resp_msg));
 
 	/* Verify that the sequence counter is incremented by 1 */
 	if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
@@ -218,11 +205,11 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_gues
 	return 0;
 }
 
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
+static int enc_payload(struct snp_msg_desc *mdesc, u64 seqno, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg *msg = &mdesc->secret_request;
 	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	struct aesgcm_ctx *ctx = mdesc->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	memset(msg, 0, sizeof(*msg));
@@ -253,7 +240,7 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_gues
 	return 0;
 }
 
-static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+static int __handle_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
 	unsigned long req_start = jiffies;
@@ -268,7 +255,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
+	rc = snp_issue_guest_request(req, &mdesc->input, rio);
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -278,7 +265,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 		 * order to increment the sequence number and thus avoid
 		 * IV reuse.
 		 */
-		override_npages = snp_dev->input.data_npages;
+		override_npages = mdesc->input.data_npages;
 		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
 		/*
@@ -318,7 +305,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	 * structure and any failure will wipe the VMPCK, preventing further
 	 * use anyway.
 	 */
-	snp_inc_msg_seqno(snp_dev);
+	snp_inc_msg_seqno(mdesc);
 
 	if (override_err) {
 		rio->exitinfo2 = override_err;
@@ -334,12 +321,12 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	}
 
 	if (override_npages)
-		snp_dev->input.data_npages = override_npages;
+		mdesc->input.data_npages = override_npages;
 
 	return rc;
 }
 
-static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+static int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
 	u64 seqno;
@@ -348,15 +335,15 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	guard(mutex)(&snp_cmd_mutex);
 
 	/* Get message sequence and verify that its a non-zero */
-	seqno = snp_get_msg_seqno(snp_dev);
+	seqno = snp_get_msg_seqno(mdesc);
 	if (!seqno)
 		return -EIO;
 
 	/* Clear shared memory's response for the host to populate. */
-	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
+	memset(mdesc->response, 0, sizeof(struct snp_guest_msg));
 
-	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, req);
+	/* Encrypt the userspace provided payload in mdesc->secret_request. */
+	rc = enc_payload(mdesc, seqno, req);
 	if (rc)
 		return rc;
 
@@ -364,34 +351,33 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	 * Write the fully encrypted request to the shared unencrypted
 	 * request page.
 	 */
-	memcpy(snp_dev->request, &snp_dev->secret_request,
-	       sizeof(snp_dev->secret_request));
+	memcpy(mdesc->request, &mdesc->secret_request,
+	       sizeof(mdesc->secret_request));
 
-	rc = __handle_guest_request(snp_dev, req, rio);
+	rc = __handle_guest_request(mdesc, req, rio);
 	if (rc) {
 		if (rc == -EIO &&
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
 			return rc;
 
-		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
-			  rc, rio->exitinfo2);
+		pr_alert("Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
+			 rc, rio->exitinfo2);
 
-		snp_disable_vmpck(snp_dev);
+		snp_disable_vmpck(mdesc);
 		return rc;
 	}
 
-	rc = verify_and_dec_payload(snp_dev, req);
+	rc = verify_and_dec_payload(mdesc, req);
 	if (rc) {
-		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
-		snp_disable_vmpck(snp_dev);
+		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
+		snp_disable_vmpck(mdesc);
 		return rc;
 	}
 
 	return 0;
 }
 
-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+static int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code,
 				struct snp_guest_request_ioctl *rio, u8 type,
 				void *req_buf, size_t req_sz, void *resp_buf,
 				u32 resp_sz)
@@ -407,7 +393,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		.exit_code	= exit_code,
 	};
 
-	return snp_send_guest_request(snp_dev, &req, rio);
+	return snp_send_guest_request(mdesc, &req, rio);
 }
 
 struct snp_req_resp {
@@ -418,6 +404,7 @@ struct snp_req_resp {
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
 	struct snp_report_req *report_req = &snp_dev->req.report;
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
@@ -432,12 +419,12 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
 	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!report_resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
+	rc = handle_guest_request(mdesc, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
 				  report_req, sizeof(*report_req), report_resp->data, resp_len);
 	if (rc)
 		goto e_free;
@@ -454,6 +441,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 {
 	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
 	struct snp_derived_key_resp derived_key_resp = {0};
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
@@ -466,7 +454,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(derived_key_resp.data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(derived_key_resp.data) + mdesc->ctx->authsize;
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
@@ -474,7 +462,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 			   sizeof(*derived_key_req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_KEY_REQ,
+	rc = handle_guest_request(mdesc, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_KEY_REQ,
 				  derived_key_req, sizeof(*derived_key_req), buf, resp_len);
 	if (rc)
 		return rc;
@@ -495,6 +483,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 
 {
 	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_report_resp *report_resp;
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
@@ -527,7 +516,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * the host. If host does not supply any certs in it, then copy
 	 * zeros to indicate that certificate data was not provided.
 	 */
-	memset(snp_dev->certs_data, 0, report_req->certs_len);
+	memset(mdesc->certs_data, 0, report_req->certs_len);
 	npages = report_req->certs_len >> PAGE_SHIFT;
 cmd:
 	/*
@@ -535,19 +524,19 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
 	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
 	if (!report_resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
+	mdesc->input.data_npages = npages;
+	ret = handle_guest_request(mdesc, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
 				   &report_req->data, sizeof(report_req->data),
 				   report_resp->data, resp_len);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-		report_req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		report_req->certs_len = mdesc->input.data_npages << PAGE_SHIFT;
 
 		if (copy_to_sockptr(io->req_data, report_req, sizeof(*report_req)))
 			ret = -EFAULT;
@@ -556,7 +545,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	if (ret)
 		goto e_free;
 
-	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, report_req->certs_len)) {
+	if (npages && copy_to_sockptr(certs_address, mdesc->certs_data, report_req->certs_len)) {
 		ret = -EFAULT;
 		goto e_free;
 	}
@@ -572,6 +561,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	struct snp_guest_dev *snp_dev = to_snp_dev(file);
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	void __user *argp = (void __user *)arg;
 	struct snp_guest_request_ioctl input;
 	struct snp_req_resp io;
@@ -587,7 +577,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 		return -EINVAL;
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (is_vmpck_empty(mdesc)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -862,7 +852,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
 		return -ENOMEM;
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(snp_dev)) {
+	if (is_vmpck_empty(snp_dev->msg_desc)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -992,6 +982,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	struct snp_secrets_page *secrets;
 	struct device *dev = &pdev->dev;
 	struct snp_guest_dev *snp_dev;
+	struct snp_msg_desc *mdesc;
 	struct miscdevice *misc;
 	void __iomem *mapping;
 	int ret;
@@ -1014,46 +1005,50 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (!snp_dev)
 		goto e_unmap;
 
+	mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);
+	if (!mdesc)
+		goto e_unmap;
+
 	/* Adjust the default VMPCK key based on the executing VMPL level */
 	if (vmpck_id == -1)
 		vmpck_id = snp_vmpl;
 
 	ret = -EINVAL;
-	snp_dev->vmpck = get_vmpck(vmpck_id, secrets, &snp_dev->os_area_msg_seqno);
-	if (!snp_dev->vmpck) {
+	mdesc->vmpck = get_vmpck(vmpck_id, secrets, &mdesc->os_area_msg_seqno);
+	if (!mdesc->vmpck) {
 		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	/* Verify that VMPCK is not zero. */
-	if (is_vmpck_empty(snp_dev)) {
+	if (is_vmpck_empty(mdesc)) {
 		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
-	snp_dev->secrets = secrets;
+	mdesc->secrets = secrets;
 
 	/* Ensure SNP guest messages do not span more than a page */
 	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
 
 	/* Allocate the shared page used for the request and response message. */
-	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
-	if (!snp_dev->request)
+	mdesc->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
+	if (!mdesc->request)
 		goto e_unmap;
 
-	snp_dev->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
-	if (!snp_dev->response)
+	mdesc->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
+	if (!mdesc->response)
 		goto e_free_request;
 
-	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
-	if (!snp_dev->certs_data)
+	mdesc->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
+	if (!mdesc->certs_data)
 		goto e_free_response;
 
 	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
-	if (!snp_dev->ctx)
+	mdesc->ctx = snp_init_crypto(mdesc->vmpck, VMPCK_KEY_LEN);
+	if (!mdesc->ctx)
 		goto e_free_cert_data;
 
 	misc = &snp_dev->misc;
@@ -1062,9 +1057,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	misc->fops = &snp_guest_fops;
 
 	/* Initialize the input addresses for guest request */
-	snp_dev->input.req_gpa = __pa(snp_dev->request);
-	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
+	mdesc->input.req_gpa = __pa(mdesc->request);
+	mdesc->input.resp_gpa = __pa(mdesc->response);
+	mdesc->input.data_gpa = __pa(mdesc->certs_data);
 
 	/* Set the privlevel_floor attribute based on the vmpck_id */
 	sev_tsm_ops.privlevel_floor = vmpck_id;
@@ -1081,17 +1076,18 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_ctx;
 
+	snp_dev->msg_desc = mdesc;
 	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
 	return 0;
 
 e_free_ctx:
-	kfree(snp_dev->ctx);
+	kfree(mdesc->ctx);
 e_free_cert_data:
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
 e_free_response:
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
 e_free_request:
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
 e_unmap:
 	iounmap(mapping);
 	return ret;
@@ -1100,11 +1096,12 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 static void __exit sev_guest_remove(struct platform_device *pdev)
 {
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
-	kfree(snp_dev->ctx);
+	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
+	kfree(mdesc->ctx);
 	misc_deregister(&snp_dev->misc);
 }
 
-- 
2.34.1


