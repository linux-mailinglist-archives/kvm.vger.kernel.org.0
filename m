Return-Path: <kvm+bounces-12259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA80880DF3
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:55:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C45D8B23510
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF652BAF2;
	Wed, 20 Mar 2024 08:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DpaeRCEi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A46A3C68C
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924911; cv=fail; b=rXpRNmYva29SgCvluUwLzbKtgkFLuo4AudFzM/Ew30OOzzQR0ngpAP0GmCQ+a09IvRFsBxpFToMxZMkqrXTerMXcyual+MB3cJSnyCkZWAtKi25OYR+Ec4ixC7pFzC5vPaU07jETPkTVgzxFbxIr0qO+K3Kxar+7GtDgGclfjdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924911; c=relaxed/simple;
	bh=W0f6dqUj7ulnEpKN4MTZf0dwoFoQQ0jeMNMsWtGbtAM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uDyjtTDAs4+rkyVZ/TcqrFFkeG7LJXkj4AN6QzMKu6YOvcCzDsffpFtKOg2pbmnfFKMZEN1BWOcD6x7FO2uJQX3j6RVE0cZJpeJozAP26hCRTQw0MMcXsjWCEUOU8UtyCHvjnq1eYJ6xI5BHanWTFYtFHlOHL11ZIDMxZdNrCfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DpaeRCEi; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYfDGdp8lthSlUuwQbQANPKw6SeZ1Lap+iEYx/3zOSv43DziHzK0HOP8URgwBkWn7MzCT7Zs4dzSaF3QDLkgvb0VhcJ44GdLD5M0GjvrFjKOgkS9vNl2bm6Rgh9Ugk2OCz83GpM4NR/jU7Kyje4J7B7YodoIv1wKMHqV6itBwYLi5MngUW8xTlvr+zoHM/koUmL/+V8VgIxY1WYc8V4UVYLjyIEMxLdurd/b3zVcRJx8GWUQGSFHzoqLuYoGbM80bF2fbQHON3C5J7pxCy4P1YItOucy0y9EXJm6po6RzzBMl0DFgBIgD2agCUKaYSGS8hZ49zS0LBMirCf0Hu75Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6KoxQqYq+wpjnsKhlkfim38Whq3Vk1QO/1DYSyXHLw=;
 b=SAGXZoV2HUDfA6Nz8TqoC97EPzx4Od2M1DTSF3w+JeUOhiUaiIV2XE0jg7KLwQ1/8/7/v7EvJwQqUaXd9M358vB0oJvGdW+oe8ybAg+rcJkp9pDhEuCYS4KVK1VaxzXbMdc6l7GU2e4xWpmDWbzQW7b53TdSI3RecBr4rNhmCH8z8+h8uYn5Pf4+GAf13iJ4Fh6XWVQLjFvrP9LspnHp3m8nvYj3fzGoM2vXi1g705V+Jl2FUSHPFRy6ZvPGSpUjs6qAJvrGwtTEUlnNoVt+Vt9JWnSJrA58xqt9rHcSy+uT4lfmLNM5ATGhuU2QWSYU5oIuv8/2n49GmxxtsRN5Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6KoxQqYq+wpjnsKhlkfim38Whq3Vk1QO/1DYSyXHLw=;
 b=DpaeRCEioA2TL7DGLK3f7Yvzma6XrdolyC/iEqGLd2JcUFUoim7MyNY6XRmcdsNA5Z2S+EPefD/Da/nMWjp2k28qrLUFB35KlPUvxjsZSO5geGFftJ/7ooPFIH0gqfvn+JJPuWdH96onyo8fYx6/A+Hv24Xjv8W5zVKSJ2crdYc=
Received: from SJ0PR13CA0231.namprd13.prod.outlook.com (2603:10b6:a03:2c1::26)
 by DM6PR12MB4355.namprd12.prod.outlook.com (2603:10b6:5:2a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 08:55:08 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::24) by SJ0PR13CA0231.outlook.office365.com
 (2603:10b6:a03:2c1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11 via Frontend
 Transport; Wed, 20 Mar 2024 08:55:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:55:07 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:55:06 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Dov Murik <dovmurik@linux.ibm.com>
Subject: [PATCH v3 45/49] i386/sev: Reorder struct declarations
Date: Wed, 20 Mar 2024 03:39:41 -0500
Message-ID: <20240320083945.991426-46-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|DM6PR12MB4355:EE_
X-MS-Office365-Filtering-Correlation-Id: bd86d91d-fc20-4f38-342d-08dc48bb7162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NmnL58QzagbRXtqBA7UPMDy71LmWPm2oVkni8QXIeNh36SagQ2w4x1FLDmnfLHkRetGdMTyycMMiCD2eA7W6oS3GhUrStERq4gn7ImVnJRR7zy2vtut2TJQYwQWBFFvxU40MyS3HNVw0VNNUDehtG2JVoe/DONur3/S81aRGnI0D153WGkpa+zu+/2PNDUqtsvD3QjtahkfoPc7QNvIlnhzK6p3XxaqxMgh/6TzNpqFXzWQ9BhiVt6dy1jv9ccGhahjQTp9U5b4O0oBAXuOn0TYo/IytCfrYdzQrCXQzJ8EytjKJ2WFDCbHFSx/se2ZvDklkQ9UeF77I7l3CNZwm+Hv7cESKFg0VTTaj/Qa0rlAluWbKjbkav+ETmpPqCwzgjFpUJbKzpeiAs4kPY2Gy0uoyUfjwox/DG53wCeVSGwtLkAEUNRWOIEz/e9yfHqDcVI2soz0pOtenAMd7WW4ndeyo4abTRW1k9EjD1CT2PV1X0OC9U45Ty5eO86LaIp4+RbAbPfj4n5Hyw0h+egBAGrWpdoyZ0YN+q0S23ywlgcASjsbo4HJLSP7c+Odfpk4Bqz4lJpOEuP/ta3+0MGdYV5B9f/nXM8qOtgGrcmuo3L8BOpipcynhvv9lKsRUCbyNB1gYHpshZt92YyCbSMV4/4QxJBXBosdavoxFldFR1XglWOqMEOqpWaML2/fVpQF5TM57AyB9V/PWQYnitg9i51BMD85Fe7k4i0j8ddrVNXPr9eQgQPMIePwb5FBqQIbM
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:55:07.6707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd86d91d-fc20-4f38-342d-08dc48bb7162
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4355

From: Dov Murik <dovmurik@linux.ibm.com>

Move the declaration of PaddedSevHashTable before SevSnpGuest so
we can add a new such field to the latter.

No functional change intended.

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 56 +++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 0913cb7fed..4bc6004037 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -41,6 +41,34 @@
 #include "exec/address-spaces.h"
 #include "qemu/queue.h"
 
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
 OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
 OBJECT_DECLARE_SIMPLE_TYPE(SevSnpGuestState, SEV_SNP_GUEST)
@@ -131,34 +159,6 @@ typedef struct QEMU_PACKED SevHashTableDescriptor {
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
2.25.1


