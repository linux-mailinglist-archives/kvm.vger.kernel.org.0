Return-Path: <kvm+bounces-18409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C3948D4A41
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5423D28250F
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD671822C6;
	Thu, 30 May 2024 11:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DutMLkzM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB4E17FAC2
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067823; cv=fail; b=jnFwz0URaRkggt2YQgHq8mF0Jzd5WIHyfQMl9UYKfreoeNpHoN6edRbPCDpmsJ+84Ineu+pEwOJV6szccAaWp4lHu5bC120/JFbRz4N1ZTn6N8hYTwsoxyC8ggPqde9Uts63wlv6n7v6QTlqKH/t6v0oiUnkPYvVeEhUihoXSTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067823; c=relaxed/simple;
	bh=0FJj5k82qCTHFWCHpCHu2dEVuQ0zjvp5fr+ASN0QT5E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tvmUEG/wpmON0A/h+E72A6Mrd4U01QnuhAV3sWGXd24Q62IV6YXa67BrUTVfUDfRkDgFfe+7Xl99UyZbkQ2mIOwPwMq+8yXgYOBxmT37aSiu2XLPTq3YyDH4HxBbKy90RmZVwLd2r4WDHwPX2EDDQtz4bWw9SJbjouF2OxBK5d4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DutMLkzM; arc=fail smtp.client-ip=40.107.236.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQnYN7ZvzyI6TqlGBSniwd1QGFqELh2J+lrIgHiTNXZYpF6gOwTHUK2Qvey/VkTiF76aPF9AiYpCajxXI3LRxOvfZjPgszDhQodSKECLz2wzInjEscdXuAkY3EXswW1e/y1l5WipUMCK/zRrEM57qgzF+lWeEX1wg0BNHYydJafohdbcvMMleqrZCdPIxei9rJxqLWbC01SnCxDdnbHzrG1rbQ12R2QzfjAfV28ZupKFLU7teTNoKVThc1mgPqhf536G11WHELkF38XWRsw/+KIXqa+L5Bz8PGgNtimFinjTCPNyaMkzVhguEdOQjFyl8OLJ8XVSJBXH5Pbg4qDHEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t8k002xUHSucSBrrK2ENNznXzTQLG5q5MC+/4YN/Sno=;
 b=h9ph1aMmLU2SXPyEf/vFl/loeahyDOKIAvR5QeQsToJZO8WD9spBz4RJJ3BF3SwkEVbefsCIsr9eXwU4u48Bku4aP5Qm/90roBhXSGzXT9Q797w5Us+Xta3fVGfpUxFyqa/LOETe1/HxSTVQHFtDNrFdNzB+L1mbP1sziQ69j7iklxwqhs31OoZRPLG9pvjo3iJ2UbN6aQnOfktyVD++JwgjQue/Ukf4GZtTMqSoXdJCANnwYufGn8vz7S7psSqjiANAwggsyL7+98DoE4E89j32XSdBOMmWQtXxJdJVWnPc8PGs/a6I9FfXsH7iWW8qFQjui3szVsj6jRrNhtAoDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8k002xUHSucSBrrK2ENNznXzTQLG5q5MC+/4YN/Sno=;
 b=DutMLkzM3Y7NulVNVOmkmvVPDXXg2TpuBlqe4DK3I6Fe2dsOM55GrbQP/5ISaHrlzf+tUTRX+ns95YZWGUTwOl/ErvqozW156w++jgoriby4fn4CXTm+UPWoSmPUrM4EgwXoPgx3izh6rutGvWMEBd+Zge89+WfGXAgIBcihnKg=
Received: from BN9PR03CA0680.namprd03.prod.outlook.com (2603:10b6:408:10e::25)
 by SJ1PR12MB6364.namprd12.prod.outlook.com (2603:10b6:a03:452::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.31; Thu, 30 May
 2024 11:16:57 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::b6) by BN9PR03CA0680.outlook.office365.com
 (2603:10b6:408:10e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Thu, 30 May 2024 11:16:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:56 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:56 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:56 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:55 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 19/31] i386/sev: Add support for populating OVMF metadata pages
Date: Thu, 30 May 2024 06:16:31 -0500
Message-ID: <20240530111643.1091816-20-pankaj.gupta@amd.com>
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
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|SJ1PR12MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bc05110-137c-4097-58cd-08dc809a049c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gmRoaL0VZ6JFZkxq/kxOYFfMs+kNqwjbaq6V49L8jeyvu+/uxlpGxLKJfsA/?=
 =?us-ascii?Q?ZxS2lGSm9iYVXtBu6+qZnBQwkSzrkzr+CpBZbUrYcQ729klgh8YQ4n4oPlvJ?=
 =?us-ascii?Q?YFzSeM67ofeYopygKTJs1I7LgOWxSgNueMXdQppG8cvHcgRE5UtLJ1M995e+?=
 =?us-ascii?Q?h9DPFcBJz7T1V3jscUpfcmQqkzEkdfBNpS4+0RtnZBWpjZg5Z6wK7AoOTT3j?=
 =?us-ascii?Q?Meo4TyVS+HaP9CpK7FwmN9WX0vdmRA9mKfMbQH6PgWcCXe+tqt+RZ8scbney?=
 =?us-ascii?Q?hc4SlEl18umV7Ld7pwwT7TwEUU02s+Evp+ym3v5+bgrmTkj2lNEpYKiwQCOQ?=
 =?us-ascii?Q?t+as07Te9CmMMKaIe2Pb+xOT3X0C3J9vx9V2pzScRrGzG8PzKwi168FPhL5K?=
 =?us-ascii?Q?JNNwZ0eNnxmGGxg/EQecjV61s5RnsSsbXHlHAToceC4PNr3WWm25zCGBAjKo?=
 =?us-ascii?Q?4iFHQT/Dy/4cIzA1xaJ0uIn0KICoNYUeZv1OBZvj7DYzHra7G59dff8twens?=
 =?us-ascii?Q?z3VQhiMghOT8GHR8+BwodjeQIWIISa4y72dbsCRjE0bWuOSDICPVeZwcPf29?=
 =?us-ascii?Q?7QQFraV+3XH1DIA0gVZ8N85ZAo/fduO1p/504YCMR4SxZm/N4OlG/hlM4VTW?=
 =?us-ascii?Q?cty4pEpEM6pG9+DCpcaATkjp3bFzmcV58677PhAJKysCetMfkQ3tzHR9T7I7?=
 =?us-ascii?Q?WbX0+uAiiMAHIFe1QXiRDzrwKAy5YscOxHC4IV66wUUHRW8K6Igj9Di/cjIG?=
 =?us-ascii?Q?N/XpAn9ZB9jQo8/foDHarzBnFkwO4NfQCEmINIRh/YIBKmt3RpxUJ1Eor4tH?=
 =?us-ascii?Q?hDX/Gb5JUFffzvGGG38ed7tfzafWQECb/LImigE8/ukioWFdmTLB9pHNKSZ6?=
 =?us-ascii?Q?RDqGQ0mkSkZ3CsUcs4Ir6eX6uwVjJzgodcWQQ3WeuBwq/cH+ldxSNIdqulVu?=
 =?us-ascii?Q?kHysdT4vrel8N+4K2E96M2JUKviiAXmR1yXq/Y3EQJtNxP2HOI64pQyA/m+v?=
 =?us-ascii?Q?Z0I32ZkgL/BuZwOIZ9XGwMvNggqcGJM148S3nQLhXNMmu2JouOftd7Iah6Lr?=
 =?us-ascii?Q?qxsjbZIHO1Cwz2VJ0Oq/pGE+jHqIEgNBjSLJ/mxDtHEnw/6qaA0tc11ugEAN?=
 =?us-ascii?Q?LaRivlDO0IsHxWeb7azDLsz6JmH0U4HAfqyWpeBcxJYBBn3imCc9giwGXHSc?=
 =?us-ascii?Q?/9InA5xYPxrOipz+THFQghPidYZNiAVCBinhvAkIxJsirZUtsPE2CJW1SO1F?=
 =?us-ascii?Q?Q0X91L7NAWj9dxEIZJaY5LCzbV8s3C5XxkdLzM/5qpppJkaUEFPQ3W4ku8QA?=
 =?us-ascii?Q?n/bSXZM6674zVSQDxnMK1oSuAdSYQHIEt03p9WazoNM5emZaN/pFbgLIQDaM?=
 =?us-ascii?Q?dg3rWdHtyTncfoSYk154aNnvUCdM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400017)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:56.9973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc05110-137c-4097-58cd-08dc809a049c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6364

From: Brijesh Singh <brijesh.singh@amd.com>

OVMF reserves various pages so they can be pre-initialized/validated
prior to launching the guest. Add support for populating these pages
with the expected content.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index d9d1d97f0c..504f641038 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1016,15 +1016,89 @@ sev_launch_finish(SevCommonState *sev_common)
     migrate_add_blocker(&sev_mig_blocker, &error_fatal);
 }
 
+static int
+snp_launch_update_data(uint64_t gpa, void *hva, uint32_t len, int type)
+{
+    SevLaunchUpdateData *data;
+
+    data = g_new0(SevLaunchUpdateData, 1);
+    data->gpa = gpa;
+    data->hva = hva;
+    data->len = len;
+    data->type = type;
+
+    QTAILQ_INSERT_TAIL(&launch_update, data, next);
+
+    return 0;
+}
+
+static int
+snp_metadata_desc_to_page_type(int desc_type)
+{
+    switch (desc_type) {
+    /* Add the umeasured prevalidated pages as a zero page */
+    case SEV_DESC_TYPE_SNP_SEC_MEM: return KVM_SEV_SNP_PAGE_TYPE_ZERO;
+    case SEV_DESC_TYPE_SNP_SECRETS: return KVM_SEV_SNP_PAGE_TYPE_SECRETS;
+    case SEV_DESC_TYPE_CPUID: return KVM_SEV_SNP_PAGE_TYPE_CPUID;
+    default:
+         return KVM_SEV_SNP_PAGE_TYPE_ZERO;
+    }
+}
+
+static void
+snp_populate_metadata_pages(SevSnpGuestState *sev_snp,
+                            OvmfSevMetadata *metadata)
+{
+    OvmfSevMetadataDesc *desc;
+    int type, ret, i;
+    void *hva;
+    MemoryRegion *mr = NULL;
+
+    for (i = 0; i < metadata->num_desc; i++) {
+        desc = &metadata->descs[i];
+
+        type = snp_metadata_desc_to_page_type(desc->type);
+
+        hva = gpa2hva(&mr, desc->base, desc->len, NULL);
+        if (!hva) {
+            error_report("%s: Failed to get HVA for GPA 0x%x sz 0x%x",
+                         __func__, desc->base, desc->len);
+            exit(1);
+        }
+
+        ret = snp_launch_update_data(desc->base, hva, desc->len, type);
+        if (ret) {
+            error_report("%s: Failed to add metadata page gpa 0x%x+%x type %d",
+                         __func__, desc->base, desc->len, desc->type);
+            exit(1);
+        }
+    }
+}
+
 static void
 sev_snp_launch_finish(SevCommonState *sev_common)
 {
     int ret, error;
     Error *local_err = NULL;
+    OvmfSevMetadata *metadata;
     SevLaunchUpdateData *data;
     SevSnpGuestState *sev_snp = SEV_SNP_GUEST(sev_common);
     struct kvm_sev_snp_launch_finish *finish = &sev_snp->kvm_finish_conf;
 
+    /*
+     * To boot the SNP guest, the hypervisor is required to populate the CPUID
+     * and Secrets page before finalizing the launch flow. The location of
+     * the secrets and CPUID page is available through the OVMF metadata GUID.
+     */
+    metadata = pc_system_get_ovmf_sev_metadata_ptr();
+    if (metadata == NULL) {
+        error_report("%s: Failed to locate SEV metadata header", __func__);
+        exit(1);
+    }
+
+    /* Populate all the metadata pages */
+    snp_populate_metadata_pages(sev_snp, metadata);
+
     QTAILQ_FOREACH(data, &launch_update, next) {
         ret = sev_snp_launch_update(sev_snp, data);
         if (ret) {
-- 
2.34.1


