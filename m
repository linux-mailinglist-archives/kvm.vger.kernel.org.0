Return-Path: <kvm+bounces-18412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2EE8D4A45
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E614B22684
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D0B17FAC7;
	Thu, 30 May 2024 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gy722Ung"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB5B174EDE
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067824; cv=fail; b=SzF3d7vaVFGiujCWsnOAp/xvlYwWNUvUeCoN3yNKQsOIDeG9lRBx0UjFvIPWFt4LaWtljlv3BbPZY/FTGPaaDUKNHX0VXamsSfjyWplHWLn9HBZQci7ZYlOR58jUC7DvU0zQBjy6Wr2S9vfV/4pGLe3xs9WEYgzBb/cHYmo5y4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067824; c=relaxed/simple;
	bh=iKdK8kvcXDUavDuvOkw3X6LjU0D4RihjeCASaG3YP1o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAFApC52GRi9migRy6pla+pZ/POBRbQ9l1YkVRN5184RUYiKhiEB6nwWB2CrMEikQmfoczBgaSoegFBA+sd3aQlpBeT3UKJPqXtEZUIzYMKDcxyf/kIgiiQKEevxaM4iiBu/KMhBshub+hJGATU4PLBgwxKtgTQoKe0ZPGrc3bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gy722Ung; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDL6gDkJdFlqiIGAwIsHdYee1fB3d4WaTt+Qr7i2Cnf6j5P5jmUCh0bDrcs37unfF3CWnO7lhGfqAElGx4c8PVfgo+qkF3peku9nbHuVkiUNoP9xu0ILxVj/pv28oVAN+c8eGZ1q7NvmvW2SrF9mJNlb3cuWokoi8o+/K6dY7eUYyyLhjoQ+Z6W1xKE+B5JDUwPbS/T+3DizaVqDqY8IGU3/TQzYm9bGCAHjvq994QXpRn6z9hnO2tk4aGK1CuSrxsoRMP763EGGkGDea99k21TT0/pyxDuDd18/kSNq1mstFK7IWDS1PwAQF7EpSFpC9rrIMbMeH6fMpvspsVLK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xrzbnp78z95riMCqIKt+ABuF+pa0XZeiRGljoGNt/Cc=;
 b=f8zLYS8a+qU1e+/S1cDYeVf/Xg8o1mZC2IcejMvfvW2o7G1Im4xnonsu4uE+FyARHl00/b4Ensw7j/zytgaRMGVRLSYx7s7UIi7WerEZ97sjh/LjRCAxlHWk2CTua7wWbcxGw9eYxtRsfOKqehuL8vSuoMpVqxpmkMN7R6Yd1mH35cYe4ahyKju60UUO3nWoTU1H3mIFc3LUPSIgyFHASSMfhQY1YU+42igRCklq1P80pxZ4kWOKA+1iFJiI/+M7qDeATG53VupQjWqaZKqJSo22r2fZUTSkfSdsa+aNHfQGqAff0pjgIcNa70li2H78dNAUUvoFLKhX/9CHhT4FPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xrzbnp78z95riMCqIKt+ABuF+pa0XZeiRGljoGNt/Cc=;
 b=gy722UngWKvz769igOo5DWAQJdnDJl7S9RD55TJ3Zr7s82gLwfinutVrzsVjS2tuQtNw9dePnPPjGsOADSnsctoIWT8x7RL5XYQoy4nsKW7u2WPRD2syFOsR2fAWJZ3OQAM1ZM1ujjglC7Yw1xOv5YKnxDqi8kWRp0hiLK1nMAY=
Received: from BN9PR03CA0689.namprd03.prod.outlook.com (2603:10b6:408:10e::34)
 by CY8PR12MB7684.namprd12.prod.outlook.com (2603:10b6:930:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Thu, 30 May
 2024 11:17:01 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::7c) by BN9PR03CA0689.outlook.office365.com
 (2603:10b6:408:10e::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21 via Frontend
 Transport; Thu, 30 May 2024 11:17:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:17:00 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:00 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:00 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:59 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 25/31] i386/sev: Invoke launch_updata_data() for SEV class
Date: Thu, 30 May 2024 06:16:37 -0500
Message-ID: <20240530111643.1091816-26-pankaj.gupta@amd.com>
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
Received-SPF: None (SATLEXMB05.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|CY8PR12MB7684:EE_
X-MS-Office365-Filtering-Correlation-Id: 71110890-7b11-4ca2-b283-08dc809a06fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BK5BiQ4Ol0eAQDPBypaX0FT3mTQ+8++ZoGIK/P8eCXxG63EEQB5IdDmksun4?=
 =?us-ascii?Q?8mok1FI1B/eGUX4ZEzlmMr0K68+3s7b6BSI+PTlp74blz7G0DxoHE3vfzNCN?=
 =?us-ascii?Q?0seWrQohh0ED+AWX6rN3kbal6DHqLS5ux4SlDIHH3Nl/FhmxseTJskZCYSo8?=
 =?us-ascii?Q?WsBMQhgAl4BNtJatCRnZT/k81DAUZ28USR7AbtH4lelP7l5o27bh0cQp3sUs?=
 =?us-ascii?Q?96KKB6Wt50emRkxgFtMXG1UhoRqwps9DEePNfyzu6Ck1n3t/tPrnkHG0Ow+S?=
 =?us-ascii?Q?GSCVqAidDFpo/v4SaqGJa5ZifE+8674rUuhCN0FQkziCtrRYAAAHnwlDfEXd?=
 =?us-ascii?Q?KgDZoa6aFX0brjojnny8ZUrgvwgXa6px9ijPgiOzxv38TrLPgHQDy/wtfJ+k?=
 =?us-ascii?Q?8Dz67lTQJdXJjGAEWx10nAKAye6fpvcem0ppUszFOkDC1OohpxdwFTEcgx0z?=
 =?us-ascii?Q?e7q4vaJklH1ZcQJygEq1AkCZGdrboS+Dfz65dyO0Kta2EQ9Zod274DHguFru?=
 =?us-ascii?Q?Vf+2nCcBfJKRBCZqK6FM4mx+DVSYGv1VEB7B6TygmChRWNLrgbDiYKRdP8PJ?=
 =?us-ascii?Q?fT07vxbZtkXjoUBUVccdbDbYAaq8fCdWqeZoDgqv9QZ3w3yJluenkrt0UGyK?=
 =?us-ascii?Q?pfCsifWUmf5chAbvfVNPFKbxV14B9/0kihVGc2aQPPQ/i6CQlP7MaejIMYyZ?=
 =?us-ascii?Q?z2GtbwE9gLmuJ/3ED7BpoaChjofdIvqzJOHfkIAk+xsm5LHNM+9/sJ4+Xn63?=
 =?us-ascii?Q?zoMiTAn5dbqYicQDCvBtkeifKTT5LiMVevjXS0AIVtKN+MSJHg0tfb/31LOe?=
 =?us-ascii?Q?zWpHUYcakCfESCz2truawc6ZjdR7Fko/sJvnSZy7NEyrwAPVdlzbZKm+F+jW?=
 =?us-ascii?Q?3lxYXe2avnlhbMP/nktajBQ0Qf4jKf6+3Fd7oXXH+d4tT0AnRe8qY/5IwWdy?=
 =?us-ascii?Q?9KxNeC37/39TfWjvnzgQ4yRD6rVfxducJe4awYyHIm1Ft49MgWtOak6rUhnb?=
 =?us-ascii?Q?AmCelIZjR5iEkyS77BnFkYcvXqRrl4LJVjtOBgUxEQ0sR8LI6hQ00lZ4kzSY?=
 =?us-ascii?Q?ncoYvlwa8E+cxLOp+puR7kLAc1WkumARNLMS8wEVa7QSfTTjD6c6jrwrYCOg?=
 =?us-ascii?Q?+iHJn71d0FoQ/81iPyRNVc1ekzS4YHDm6AMZT9bpzH0UYs50DDEKeEyv0NFB?=
 =?us-ascii?Q?Rs+Glee/shRg5XI5pJ/tWG/Dl94XDmnmYQRqP5Yi+YYeRl+CESqSEwvQ++IR?=
 =?us-ascii?Q?CePP9HOf2Q9Cz9mJOK5uLxaOmxURHJieLmy0X5eLZnDx2UtrPqEETrlnOZ2g?=
 =?us-ascii?Q?nykLQcRe1kKhyt+MRm16l4ra39WVxFPTxsZYO0op7pk6h04sDt/KKp2AMoKx?=
 =?us-ascii?Q?q9UE7S7wBBiovcjF1UoMHvsJN9QD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:17:00.9973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71110890-7b11-4ca2-b283-08dc809a06fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7684

Add launch_update_data() in SevCommonStateClass and
invoke as sev_launch_update_data() for SEV object.

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index c5c703bc8d..7a0c2ee10f 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -102,6 +102,7 @@ struct SevCommonStateClass {
     /* public */
     int (*launch_start)(SevCommonState *sev_common);
     void (*launch_finish)(SevCommonState *sev_common);
+    int (*launch_update_data)(hwaddr gpa, uint8_t *ptr, uint64_t len);
     int (*kvm_init)(ConfidentialGuestSupport *cgs, Error **errp);
 };
 
@@ -945,10 +946,11 @@ out:
 }
 
 static int
-sev_launch_update_data(SevGuestState *sev_guest, uint8_t *addr, uint64_t len)
+sev_launch_update_data(hwaddr gpa, uint8_t *addr, uint64_t len)
 {
     int ret, fw_error;
     struct kvm_sev_launch_update_data update;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
     if (!addr || !len) {
         return 1;
@@ -957,7 +959,7 @@ sev_launch_update_data(SevGuestState *sev_guest, uint8_t *addr, uint64_t len)
     update.uaddr = (uintptr_t)addr;
     update.len = len;
     trace_kvm_sev_launch_update_data(addr, len);
-    ret = sev_ioctl(SEV_COMMON(sev_guest)->sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
                     &update, &fw_error);
     if (ret) {
         error_report("%s: LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
@@ -1525,6 +1527,7 @@ int
 sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
 {
     SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(sev_common);
 
     if (!sev_common) {
         return 0;
@@ -1534,12 +1537,7 @@ sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp)
     if (sev_check_state(sev_common, SEV_STATE_LAUNCH_UPDATE)) {
         int ret;
 
-        if (sev_snp_enabled()) {
-            ret = snp_launch_update_data(gpa, ptr, len,
-                                         KVM_SEV_SNP_PAGE_TYPE_NORMAL);
-        } else {
-            ret = sev_launch_update_data(SEV_GUEST(sev_common), ptr, len);
-        }
+        ret = klass->launch_update_data(gpa, ptr, len);
         if (ret < 0) {
             error_setg(errp, "SEV: Failed to encrypt pflash rom");
             return ret;
@@ -2039,6 +2037,7 @@ sev_guest_class_init(ObjectClass *oc, void *data)
 
     klass->launch_start = sev_launch_start;
     klass->launch_finish = sev_launch_finish;
+    klass->launch_update_data = sev_launch_update_data;
     klass->kvm_init = sev_kvm_init;
     x86_klass->kvm_type = sev_kvm_type;
 
-- 
2.34.1


