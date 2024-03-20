Return-Path: <kvm+bounces-12255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09364880DEC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:54:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B448F1F26B16
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB977381AC;
	Wed, 20 Mar 2024 08:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tx+Y4hbt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92713BB29
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924829; cv=fail; b=ZCpE/kvcI8JLCkR7o0TBb53nL4jTdjfcLj0IDBC108iO/l1p4N0lKOAkMVMEPaHJKl3LH5c7iMLKRMSTA8uOV/5Mq5yhJI21yyvSxUYTX0WnY6qHX3JEGU45/91Mv9CWbr3+1Qg9UmKlRzoPwQY/j4lA4DACbZA3MDwe+P8HLmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924829; c=relaxed/simple;
	bh=WwF8zIfnZxEP1Pa8q1yjrnN++F8Iwom4YchB2heSMPQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FgaIoP7xGcsGhb2csOVIww7Fv9wJbqLGRxJbgw8hIwiNg93FBulwSZYMQ2ddkYwESlWXNAAJYRvEJD2yYxoRn6NfdlYuO9XumOqs9tjSsdqt0IuRCsbj1Zsc8UybDJJ/DJ/QpTjulH0yJcE5NThh49K12OINqhojE3vtOpgGTzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tx+Y4hbt; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RL61Kf3hIv5765WCfjCioYH/bQ+OVIfL2FgDaQsOQiIL6GOd6q0Vg7D6OPVrTh3o7aJ0S6Hh/i5TM365mftp7QDYebgXZ6W81LAC08IQ38LAqQQS9MsoXUbuoJhgVMkNC4mf+jQd0ijNioBPMFMybyOTj9uEbdDOnY8VinyeCTVYekiQm+Nf2iGZo+3v6aqU9m4RJ4BYuUR20aB8bvBTmKdzk0czqJVn4kveHcv++vWmiUXPkTGhSnDyVD2/qVy+lOYC3vzRrt/qITIQSEyvXXWt/Zs6++WJoTEGF0+98bjxH5ElzH1Tj8PHq1LQ7R1M61Cr1ku9YOOtZgJdY2l56A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnTjo2V+1LHsI1rt+5gOeerFr+ojKCKSZXbbVpHBn8M=;
 b=n2Ga9b4H2g47XJcC5UvAqmylYGMxg6mq8ugOstDrarcrzpl1rcQuxMqJX4ggM7zvuzC8Fe2zG0wTaJ6EO/0ETUE3618CFRehDtraZlV5Cp/h/FMakQ0zhlesEGlc7FSE8bHbpo42XtYdo+qU05MJTUYHJvemahvqy/mmO3qZ4+sLuzuF/ZsfpJBzFJzvgyvJzpX3xJDBZdSOVHVVQKNLTab4SYgHer1Uy409mL0fUdSN6Bp/wDY9d0m6P45OfdVqcZ//hdgMonHJl0mVjZ7XMaXI3pLg9NKeDbrP6I1TX1t+VR/2Tv4PMytE4ziI+MEd+5DVzLn96eHLQi5B5dkdYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnTjo2V+1LHsI1rt+5gOeerFr+ojKCKSZXbbVpHBn8M=;
 b=tx+Y4hbtYePp6or0mSpkcIB0DkoRp8nUd6Yy8pK0+tkPAU/qRynuUorpbFyHFuoGrQlVyRgXloIsdHF7QIfoXJ9tdLZX3pxKgpXjTFPoW07mY28/csqnjHsFy+mpDyAm0juUhxnw8DuQWKKp4noMwHeQ6YR3CkxvqP3/+oNDIxI=
Received: from BN9PR03CA0207.namprd03.prod.outlook.com (2603:10b6:408:f9::32)
 by DS0PR12MB7898.namprd12.prod.outlook.com (2603:10b6:8:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:53:43 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:f9:cafe::c3) by BN9PR03CA0207.outlook.office365.com
 (2603:10b6:408:f9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.25 via Frontend
 Transport; Wed, 20 Mar 2024 08:53:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:53:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:53:42 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 41/49] i386/sev: Add support for populating OVMF metadata pages
Date: Wed, 20 Mar 2024 03:39:37 -0500
Message-ID: <20240320083945.991426-42-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|DS0PR12MB7898:EE_
X-MS-Office365-Filtering-Correlation-Id: fc741a56-c424-4c3f-f0c8-08dc48bb3f17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fOBNrZJ5dZt4KsZPlb2gXooAcSQTLaXmNtKh14a1NK6VzzUHAQL5kF9Hi4sGwgwb7YtKaYEeX7kSq/9kVcMsiZ8pJ9FQobO1SmaAlPqLLZk1nvhL6l+QlpgqnkSr+GFbj4JhaW/gq5dOMA9pX3xHu+honn2kzAwhLeZFnHqc9ZQhkj7ulZe/EHP47fd0B/tb3L7b7Dg5KIKM2DhXbJOhYCr8S2f9agErfyvINSpAp1v9yjKg+ehl7n2KM69oOHNrR2Z+KHKv8bXHoq5sYSic3wv4HMpvTzCR9vWKjezTM0ci9a73WLGpF8IeIXwuSEHyt7UKXNJ2msh9PMMiCC0O5X4aHEheZYw8fk1/Z4b7L0lGIRV+LbeFcnfqVUkvqm4LpQyKxe5al0GmBGDXna7WR15t2hK7D+zZCvFwOHwQ8kuvvIsaPTgGtVHfKD6Wzbt5yt4plOR7duLYWX7W6ncSdNujgJlzvaeJaTeUoktDAcxuz7vlwEI1+dqUehXOqpIqFrtoepapj6+o3cJL4Bh68IiEsRmJWg92f6+RHqdc8qeB9R8ZwMbIJnEGSg+cm+kI/dZahxaroHoFWH4jEWcNRId8AurnpUuyzGuGUJEDCp9c1frmLwZzgH6j+Kh8t9/JzQpdT5SFiTOnpQflYU/OhUkVbHuXwlQzJIhShNH3FTtxnjb3QWS+GB5beKn1yQyKrbJ94HO6OlZMKKkP56KYRB2hz7Hzyx5qduq6agBMXAySXclAYLa18Md14zSw8V3u
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:53:43.3916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc741a56-c424-4c3f-f0c8-08dc48bb3f17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7898

From: Brijesh Singh <brijesh.singh@amd.com>

OVMF reserves various pages so they can be pre-initialized/validated
prior to launching the guest. Add support for populating these pages
with the expected content.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 4d862eef78..6c5166c729 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -949,6 +949,67 @@ sev_launch_finish(SevGuestState *sev_guest)
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
+    switch(desc_type) {
+    /* Add the umeasured prevalidated pages as a zero page */
+    case SEV_DESC_TYPE_SNP_SEC_MEM: return KVM_SEV_SNP_PAGE_TYPE_ZERO;
+    case SEV_DESC_TYPE_SNP_SECRETS: return KVM_SEV_SNP_PAGE_TYPE_SECRETS;
+    case SEV_DESC_TYPE_CPUID: return KVM_SEV_SNP_PAGE_TYPE_CPUID;
+    default: return -1;
+    }
+}
+
+static void
+snp_populate_metadata_pages(SevSnpGuestState *sev_snp, OvmfSevMetadata *metadata)
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
+        if (type < 0) {
+            error_report("%s: Invalid memory type '%d'\n", __func__, desc->type);
+            exit(1);
+        }
+
+        hva = gpa2hva(&mr, desc->base, desc->len, NULL);
+        if (!hva) {
+            error_report("%s: Failed to get HVA for GPA 0x%x sz 0x%x\n",
+                         __func__, desc->base, desc->len);
+            exit(1);
+        }
+
+        ret = snp_launch_update_data(desc->base, hva, desc->len, type);
+        if (ret) {
+            error_report("%s: Failed to add metadata page gpa 0x%x+%x type %d\n",
+                         __func__, desc->base, desc->len, desc->type);
+            exit(1);
+        }
+    }
+}
+
 static void
 sev_snp_launch_finish(SevSnpGuestState *sev_snp)
 {
@@ -958,6 +1019,20 @@ sev_snp_launch_finish(SevSnpGuestState *sev_snp)
     SevLaunchUpdateData *data;
     struct kvm_sev_snp_launch_finish *finish = &sev_snp->kvm_finish_conf;
 
+    /*
+     * To boot the SNP guest, the hypervisor is required to populate the CPUID
+     * and Secrets page before finalizing the launch flow. The location of
+     * the secrets and CPUID page is available through the OVMF metadata GUID.
+     */
+    metadata = pc_system_get_ovmf_sev_metadata_ptr();
+    if (metadata == NULL) {
+        error_report("%s: Failed to locate SEV metadata header\n", __func__);
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
2.25.1


