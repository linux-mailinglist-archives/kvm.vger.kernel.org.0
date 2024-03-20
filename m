Return-Path: <kvm+bounces-12241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 827F3880DBB
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A24AF1C203BE
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054BC3F8F6;
	Wed, 20 Mar 2024 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XL9SfU1v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912353EA76
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924534; cv=fail; b=S7xkRSaekPAkT0OxQG9ePn3wgfsln00XKl//W9jl1KdMywuHcSGmQovfcrvDbgS1UoRRFkXTi9wJpAnJetvhNVrg+BxmGQhP2XrSOw0Emo6QmPz5FBdyfctyQJSV8mNl9u0sEsCjCB/IekIh7UbushPesKiODVWBl/nufjMBUdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924534; c=relaxed/simple;
	bh=JtbMd4rpOG8frzW/O5iHqKkoRW0yrHJCtQ+ZCV78Rqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IAaL3Pw5nv+04vSdy6v2jPO4jtWJfT4J5Xr7ZtH5Pke9IJGJwdrACoE07tWxV3Ukwn4H50wzytwl6evd0m01HgLNHJ2y3JoF3sg8mXMbA3NIhTDWG3NGoNfXAroR0lsBD2tTXzUcfOjXk54a6dg2lUgxIST8K68In/kOT2o+is8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XL9SfU1v; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBpF8sjA1/x6p8GYIL6ucaJMkgt9Qn/3HmC9CZr51A5MXRLyqQZ9ff3Mst9q5xD/QNK+JbD3J+eqmwn8SJJJsYHg1xNczbiebOZoyFMnX0xXlT3uYFltsgiJhGQszGhxgLk3RlQBlYRrtIOIVrTHOKbQ/KUC6IXUJ+fnR1L5/dg8AprCrgDtqIV5ZzZu7KrbAD6mLeofJNmEThjlzISLXLbTeg4i0O41Tt6Xq8k3+llKeKCE0lh4HBcJFdre+vjBeMt/HmCTMsjZw3lfAILeHDunWxj6sROFhVek7O9McW4u0OE0uFjybm5U2iykhV3VO92hgQAChLq/313e1O8FKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmlEPPQJRqOq6Z/gGS5LaiJnbCESGk5Pdm6g1pJHzV8=;
 b=FrVEo2ZbBB7rzGmRaElevRwbtlioNCMf2B5ybcmwvM3l/4wtOH0/7pI0KkM73j9iQKdJJIW6bexbh372nVHGDjhMDD5eBm0ehGPZAJBf2rjxy3Nbk98BegXHAYG6icmqKm4mMiEuyoDBMSQtDIIaunbLbwQ8CEm7q0f/q2t1dIDA8JEkrc6BLPMzbst6yB/qMfSu+gVepGuptgy9OS1YhLYdy1L0iaut2qt2qVgT8CA7dGme+M3FmkcbUiH9ZlQLApqGMtwMoiqeUP6MvOQevGGmU0aA5C/qWIaXOSo3X/3C5gUCPHloKyF3mek4hOQm9UryXCX5i4BsaBq9rwwEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmlEPPQJRqOq6Z/gGS5LaiJnbCESGk5Pdm6g1pJHzV8=;
 b=XL9SfU1va//tIBlRWTVaiA5kIx50t8Zh4PA4TfCUHvxkGQ50l02joj3kbAXogm0UA+ldaa/S4K5keJU9Sn7EZ6UbdvfFb+9ndbbPUQvD+/MWtnce9tKVEKA/J30de3NSlvippk0jP7mY6yHR9i9T4Z9r1MPLxTmPH9JQTY0L94k=
Received: from BYAPR05CA0024.namprd05.prod.outlook.com (2603:10b6:a03:c0::37)
 by CYYPR12MB8871.namprd12.prod.outlook.com (2603:10b6:930:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:48:50 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:c0:cafe::ec) by BYAPR05CA0024.outlook.office365.com
 (2603:10b6:a03:c0::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 08:48:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:48:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:48:49 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 29/49] i386/sev: Don't disable block discarding for SNP
Date: Wed, 20 Mar 2024 03:39:25 -0500
Message-ID: <20240320083945.991426-30-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|CYYPR12MB8871:EE_
X-MS-Office365-Filtering-Correlation-Id: bd038284-1131-4317-2d77-08dc48ba9038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5Fz64ZhVuhXBo7MhkvkhAeArfNYU24gch9xQEHb6EN8Abs5krahsCZsidOxyIyFdld5RumreJo1rXfv9B3UvOHL/+Vrg+CZv4x4av/IRhKVH0IFvmEXhpQ6mZGutgvelEbttM6UB52y4prLIUyHYwqLgrpfcmuLs6nsktwK5V8LpT2QNoPygpn5UXCxICEW4i1x9Dk46TFrSRVOvKRk6+OVHbBj5e5wgTJPMDgKJOoaBNWQ2VO+/2pAGtYDGLlRCyyYNVu+ypobeC3CuYxLDSeJ8zBd8NiTeqoSkgp6eYoknCwS0Rh16AaAlLFmARU1L7LPnjRAOq8Gj3q1/FIqQ5x784XH8Brad4EonMkYOZRH31BGVnbq/Hi6vPZOuoElyLRDhvLtX6kjqf4BV6/+sBK1iqxx2BGDx10rD6mOCqsYgjeoAyIK/9zG7tpfh9B5gLdICZwMJ7RCe6EgQCZ9U+CCgvjwFTPyyb1j6K8cLBD/z9o3I/E5U20n9G2+qtd1FofXMgewSzdkW+SfeFSk2MyOpwXPsoVgr6FrVW9CPtRo00z6Sg0uw6mglJFNPjA9aZ1FHV3bvShucN1lzMOoz2YKon0OlDc78LS+hmNilKE9EEAr38e6dbAQeWZiOu3hdi67Ae+7/s7trFTFa1XHd/JI9XNbMIuHRHSE2i0nlMGRVrVXUC5/5zyr2ScVPLKfRIZiH4D9ju50zfGcB6d6ZM70EMHk53rzAZhfe3l2Fdp9q962OTCWp7MQ5ylvdbpXU
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:48:49.8922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd038284-1131-4317-2d77-08dc48ba9038
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8871

SEV/SEV-ES rely on pinned memory to back guest RAM so discarding
isn't actually possible. With SNP, only guest_memfd pages are used
for private guest memory, so discarding of shared memory is still
possible, so only disable discard for SEV/SEV-ES.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 134e8f7c22..43e6c0172f 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -888,10 +888,18 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
 
-    ret = ram_block_discard_disable(true);
-    if (ret) {
-        error_report("%s: cannot disable RAM discard", __func__);
-        return -1;
+    /*
+     * SEV/SEV-ES rely on pinned memory to back guest RAM so discarding
+     * isn't actually possible. With SNP, only guest_memfd pages are used
+     * for private guest memory, so discarding of shared memory is still
+     * possible..
+     */
+    if (!sev_snp_enabled()) {
+        ret = ram_block_discard_disable(true);
+        if (ret) {
+            error_report("%s: cannot disable RAM discard", __func__);
+            return -1;
+        }
     }
 
     sev_common->state = SEV_STATE_UNINIT;
-- 
2.25.1


