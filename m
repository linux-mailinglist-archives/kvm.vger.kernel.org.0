Return-Path: <kvm+bounces-18411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF10F8D4A44
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E24DB1C221D7
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D6E1822D4;
	Thu, 30 May 2024 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pHwJIGPE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2062.outbound.protection.outlook.com [40.107.101.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8618174ED7
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067824; cv=fail; b=In7r9bVyEyMf0Sus/3hE7ONrZb//eOXYzWIH3haCXOOeK6W8GggxAJrSVzQ2K9v/SJaGVOn7dJ7vrTPaFXmExzYdUFZ1KVJTDGnVjQuaV2H8wmCkl3MiEsKgW6O5iW1xXn8R4T8sHycLJlvCWokNiM07ytp6moVe+Kyb31Mtmhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067824; c=relaxed/simple;
	bh=FVJKOIBu77Gl7kDxyBMCUKM0ZXFXTifH3XewloDo8Bg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAwCDzQbnZoe0bCgWioeXxY3fKI0n8cZ8R92TPICWsXzfUBqh6MZlV8x27PQm9idF9bvW/9XGxZpN/2Fm9RFjAjHZOw6NTux1LQw0pMks1pfPTSx57SOAbSo+WRjLbKZDVAcowRYTh2ArJs8tK2Q1NwQfKom3exKAuyKB8pQnt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pHwJIGPE; arc=fail smtp.client-ip=40.107.101.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deFVHARsoKXEhhQNrIJI9WpLmI0Cth79mP7DOokyEH+9cr5ILm9BFW8XQTuE5C/zb2ZwZB7b8MP3TgyAzZjjBwAWiDR6lRseHoDdYwgzh088v6miEvJxB0065RxeHMig5Hpe4F0m1jsU4YvtdEiKkK1awtcDCUNZ0Z7ih6NMBuzW+1e0N50eAGbFojcckGQoActD57ZXwJ0m6Z6XkcsDo9M8E2pHimtlmfFSyiQqH8xc1YdecAtdYCdmNiu3S2C6+ukSVRy2N5SJADaMx+8ZmYTQDv/RxDvIfdun8KHREtztuIz0mkXyhIKqn7wjZ/2Ag8n7t3lGfIEeJLobSu0qaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hio30L+gaL8Hs9rnhopAJkQw3InmhiLjJwr19Q0Ln50=;
 b=VwZGRI3h+BRUrb9nZDQ/WtaGZ+i+892NqUU38AO1L3gCXkStYxo3GT+cgV4DHxRqW0zQQlsjQIUiNkpENIDosVIGa0GczieIkkKG1ogy8V0S3K/bMijSxSwb52khpEMD8Y1Cf1YKo+fTLMvXSgHjEJQjIA5Bb4uBetccl55P1hu1KaK4aAmLg37wrevfub451phHiD/Fjt+1FmbO7x3HIFC8YMwMzGHNPnXlUSz9jzzPX6s++yfubHCSsYdvyrtg3pEOjudFi5ctJSZC29Of7Yi1tQOziqh4F1m5lShOAGTIVypm9n+OOMyRtuw39fHHdUNX1S17AL3wFbbNj3Qwgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hio30L+gaL8Hs9rnhopAJkQw3InmhiLjJwr19Q0Ln50=;
 b=pHwJIGPES+ADjKDYARdXh1PueLHBO/sWNXwrBNr4/6/sNQFjZW+sSL/PZJOsBZGZdC2MoLYGIlm/X0zFDsASsVu2xyjM+06dEKJHMQ3pExfpCUrSYVCGoO2CjBjQoYSwrFkM7RHojFkbHTqJbpMGGMLIqlcOBeoBQryGuY0SORA=
Received: from BN9PR03CA0669.namprd03.prod.outlook.com (2603:10b6:408:10e::14)
 by IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 30 May
 2024 11:16:59 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::6b) by BN9PR03CA0669.outlook.office365.com
 (2603:10b6:408:10e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:16:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:58 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:58 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:57 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 22/31] i386/sev: Reorder struct declarations
Date: Thu, 30 May 2024 06:16:34 -0500
Message-ID: <20240530111643.1091816-23-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: 72db8b64-d36e-4502-376e-08dc809a05bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XNwZXRlNVGu1j6d4y/5nrfUqas5mxUNT3B/dwbG5/3/DY4XRBKWxMkzgu7rF?=
 =?us-ascii?Q?HwYMVk8PtPTJpBzbvBMBrrX0D2z50wZP44EJm8O+mrwwkrJY60CjWnBsGx5V?=
 =?us-ascii?Q?kM8Pn1igQD05m2AuAZ1qQvMA//3XFohA9jfYezDUdgBeXYQSb9Hwp8Uruz+n?=
 =?us-ascii?Q?8qRG/UknTQsmQqqLm4S3yA92fMopwEBy+Q+J4zWIH1bjzsLmVo7/RmpCLefq?=
 =?us-ascii?Q?iyTsYX+zdfef9MUBa5OCYLCmBlJBXYgZnWE0q56dFyOCX6bcAk/09YOBjy/Z?=
 =?us-ascii?Q?lefPLzk7USsHoBvtkepwpPTBjOUH3H1v6/AP+q0Dnc9h+TC2W/DykEJ7hGPZ?=
 =?us-ascii?Q?5AWfbAD7O+5TvAHkA6IDWw9mQY34dM6PdDc3wTWoJQCNnq3WRgSOLM/alLAm?=
 =?us-ascii?Q?ds5zBwHMdx3R+7jbK50wm6upa90WVRg9zj2ohUlrrdooVqi+5iFmSSLA5gRE?=
 =?us-ascii?Q?groYxyPD+7SxVlYtl9wS8jXhOb2RKWweWJYLCdV+wlCjPuu9xxYWprY/z8Rz?=
 =?us-ascii?Q?Q9d/eTZom3tTnQGtgBvhvDfrGyFosamT6+ywG7zOgonFwUoaj/3sG+dEq9vb?=
 =?us-ascii?Q?CMeR5mIhEAo8QEy4LUboSIkJggeolCYT0KU+TUvjOSk1RPT1yV7WRYOdpR1X?=
 =?us-ascii?Q?A0Z1eQCviq0OKpoifa1hFBgw+E0shKgAdiPDfRHIOX5VaOncSdct8mzSEk8J?=
 =?us-ascii?Q?LgYJKvNYQeBFM+X09gBj3V4UtTWTJbWqX8hWkW5P9RDasTQ/plfJMZU3cTiA?=
 =?us-ascii?Q?fXh8B2eikcGA6bjqsDCMtnYSOZq/PCpojQR3A0fPIjujxV+TA02CFD/0+UvP?=
 =?us-ascii?Q?lQRQWhlzqQgkUv2IUnV84lLs/mwppqOmRUHHJepuhCn4V/J2pIW/qPEbtess?=
 =?us-ascii?Q?apZFcFSqjYWNBwH5/7rQFxlUyTYh+zUTn9BGdpltPQgBTA3WuRmk3SnrXXlb?=
 =?us-ascii?Q?3uAoXBvdI3DzgB5iiRJRb6vXFm03+aAW6byMTrYZMwCBJ7sjWxzt5FZiJrg7?=
 =?us-ascii?Q?HVLXgV6ERGnJBDObYWD+NJSoalqqIB1JoWIzJ4ZgoA/RM+AuWs9dkI3p9wFi?=
 =?us-ascii?Q?uqTCXEB8+FaWhySpLbnB+iJp37VYMwu9fNnN9uX/JD4oHFfyq7B/+wpJFCK5?=
 =?us-ascii?Q?14WcktGCjiW1khfgopbXvSgo8wcaOfp5HDVj9hJOukcLQ8Vo8F/DsM15Ew2I?=
 =?us-ascii?Q?n35Z/UjNJeEN8OsKw/j/7RYpFGNy1ozydpMq/ecxFdEsksQ+mtmx5nWR6XOr?=
 =?us-ascii?Q?YVtmibZ35okcqGjBRoixGL1Tb6RgxGTgRvPlgzWRJu2aFY6iwfpqp+oNVJU0?=
 =?us-ascii?Q?EKIckSRkezEDCGhKVSIJUWwvWbjiKrT3gWVBnbpnKinaefRbZvrjY2e/hiuY?=
 =?us-ascii?Q?S1DiFLjPrXAY2f6+P2kWVUvNdmzw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400017)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:58.9035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72db8b64-d36e-4502-376e-08dc809a05bf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312

From: Dov Murik <dovmurik@linux.ibm.com>

Move the declaration of PaddedSevHashTable before SevSnpGuest so
we can add a new such field to the latter.

No functional change intended.

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 56 +++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 831745c02a..1b29fdbc9a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -45,6 +45,34 @@ OBJECT_DECLARE_TYPE(SevCommonState, SevCommonStateClass, SEV_COMMON)
 OBJECT_DECLARE_TYPE(SevGuestState, SevGuestStateClass, SEV_GUEST)
 OBJECT_DECLARE_TYPE(SevSnpGuestState, SevSnpGuestStateClass, SEV_SNP_GUEST)
 
+/* hard code sha256 digest size */
+#define HASH_SIZE 32
+
+typedef struct QEMU_PACKED SevHashTableEntry {
+    QemuUUID guid;
+    uint16_t len;
+    uint8_t hash[HASH_SIZE];
+} SevHashTableEntry;
+
+typedef struct QEMU_PACKED SevHashTable {
+    QemuUUID guid;
+    uint16_t len;
+    SevHashTableEntry cmdline;
+    SevHashTableEntry initrd;
+    SevHashTableEntry kernel;
+} SevHashTable;
+
+/*
+ * Data encrypted by sev_encrypt_flash() must be padded to a multiple of
+ * 16 bytes.
+ */
+typedef struct QEMU_PACKED PaddedSevHashTable {
+    SevHashTable ht;
+    uint8_t padding[ROUND_UP(sizeof(SevHashTable), 16) - sizeof(SevHashTable)];
+} PaddedSevHashTable;
+
+QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
+
 struct SevCommonState {
     X86ConfidentialGuest parent_obj;
 
@@ -154,34 +182,6 @@ typedef struct QEMU_PACKED SevHashTableDescriptor {
     uint32_t size;
 } SevHashTableDescriptor;
 
-/* hard code sha256 digest size */
-#define HASH_SIZE 32
-
-typedef struct QEMU_PACKED SevHashTableEntry {
-    QemuUUID guid;
-    uint16_t len;
-    uint8_t hash[HASH_SIZE];
-} SevHashTableEntry;
-
-typedef struct QEMU_PACKED SevHashTable {
-    QemuUUID guid;
-    uint16_t len;
-    SevHashTableEntry cmdline;
-    SevHashTableEntry initrd;
-    SevHashTableEntry kernel;
-} SevHashTable;
-
-/*
- * Data encrypted by sev_encrypt_flash() must be padded to a multiple of
- * 16 bytes.
- */
-typedef struct QEMU_PACKED PaddedSevHashTable {
-    SevHashTable ht;
-    uint8_t padding[ROUND_UP(sizeof(SevHashTable), 16) - sizeof(SevHashTable)];
-} PaddedSevHashTable;
-
-QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
-
 static Error *sev_mig_blocker;
 
 static const char *const sev_fw_errlist[] = {
-- 
2.34.1


