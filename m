Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD21A7B541F
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 15:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbjJBNek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 09:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbjJBNei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 09:34:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045F494;
        Mon,  2 Oct 2023 06:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJgrPJ8sFlzHwxOrCkoRMLZBboucFio/n7lnd5AvNj9rveLBP++1es2nEpeXxA1GcAneZj1Egb7EQxpJnWRPTjAeXh8JRevLvtB75DWOv9fdhSa1pfxBifALYmnrkYjb0b/aBKH1m5EwK94eMsUoWnijj4+cOMjJDwd61Ulg01MBWlfazxOWzFI6S4qYG/ujT3pMmd0qLpUAynns+ZyfgbpCllFGRfCtRDzo5HMBAsQ2n2wii0EqE0l5V0bS3mlL25Cm/2KGzzDX8fGz2kbkwW63KKSjabUhIuyspKLPco2IoPX+wOSR4QPlqjGXxiRueq2mIXH2x4FlnX0ZAEX52Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W92tPJvIM4y4LnkdZKUOs17nZH03CMesLhtgPRbzVdo=;
 b=nxomC8A08AjQe7OJAMcUPNZ1soRF8gaJ5LOv1FYBebo2PQaX5x7Ox+5WQZEGNwZOMrFpcjpLi6Hs5tl2aofVBdmIa1Ss0TqAWsb2ReK0Mej1CyqtyNh0PYydqo+d3sSVX6Katah8lzzeE4S5HlYZc/hCoTs/Ax2o6DtB0WH7V8Feuj2y9rohHZj7wtSaucGOfGmOAgvF4YC+IcYinPXX2N2mIHLyUs/dJOaWjvdXWZna3IfODeYK9mPpdoTR/uqhP5j5g7xAPc3Bue0fsAf+zQ8gnAamLViT+3rR7YZOBu6h0UswWoFQCNEfJTIQqJYniCAlKhmANTXiNyqaVs86KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W92tPJvIM4y4LnkdZKUOs17nZH03CMesLhtgPRbzVdo=;
 b=Pa8IQIppWys88fHXVD/lJkcmUyA4KyT48acUbPecbZm/CO2coLInBmLzDKmDwgSGgCb6BsRciaMXTizoGSpc+L2oce2DzE0hWpf5+AX4GCjIedAIwXPOMJmdMKAS2pUKQkhcq+dKHTVWKkyg3TJl9YGnH3X4Pk6Vb+1eXmK6UkY=
Received: from MN2PR03CA0008.namprd03.prod.outlook.com (2603:10b6:208:23a::13)
 by DM6PR12MB4880.namprd12.prod.outlook.com (2603:10b6:5:1bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.30; Mon, 2 Oct
 2023 13:34:32 +0000
Received: from BL6PEPF0001AB4C.namprd04.prod.outlook.com
 (2603:10b6:208:23a:cafe::ca) by MN2PR03CA0008.outlook.office365.com
 (2603:10b6:208:23a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.30 via Frontend
 Transport; Mon, 2 Oct 2023 13:34:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4C.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.14 via Frontend Transport; Mon, 2 Oct 2023 13:34:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 2 Oct
 2023 08:34:32 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <seanjc@google.com>
Subject: [PATCH gmem] KVM: Relax guest_memfd restrictions on hugepages
Date:   Mon, 2 Oct 2023 08:33:42 -0500
Message-ID: <20231002133342.195882-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4C:EE_|DM6PR12MB4880:EE_
X-MS-Office365-Filtering-Correlation-Id: b4a87d02-cc07-4c80-0f51-08dbc34c4fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jArnsZ1izX8maN6vJ2rjEtK2Yft/x2Cza3zEsF1xESzRmyTFx3vYnK0+J63yV3naXQcO6Fy4dp9xJKthP/oKTCL55Bm3CegDd4klDWc89t+vr9kmIOI98l4SbvfVCHP/DlseFxa44bi4Kij4eAxMUKTIyQZB2ihyHtx3qpyeUaYuYtrsfj1ozKJEbPaWssKkdeJABQnwN+fczJPalTCubTq2KpeT4ZFOw8haWdvCdVAaqm3Iwm8vZGRN94JdwiY5tRT1NXRoFEinzwXNr9XgpeuVPkQAGEQmgL4mA5HeEAsHuqFOvJ+TNqnrFeKwhrrr8ONlzoQx65kIJnvDaEc63VE9td+TSvIL42QWdr/K8BSin6ope7RQGObcpcqVWqOwzGQdXPUmJO1eWmjdcDVtLz7WgDUAso/HKGht1/wt3TazOdQsM9ibrmVRbdMsCyD+gm40nHuYmp3/mQL00JYDwj12mqGTxwBTKP0Qt1selgwosfys5iEsSL1oXyPDvCPx2Br6iET1B0ae5O4CsNCBapsRiTCkFcrjYYAD61LjBhS0GJHDcx2UYcOOPl+0Al9fTTFQs1gJ/u48RdlvX8dYK4ElC3Hj3eufZpLkCTDkP1XrNzmsY8LudPqaKewfcHs3UzpcietQaFy02i30U3glCT867GHE13Qt4gKn0F7KS+UgIPECuMgYBDbEn1o33Y+W4Xc7tk+0oQ9jKY772ZFNRHYXotkmyPNUsjUcgSG+mCQWZyw8Niutv8Qu7FiHrXqfI3u3clS6Y0Wp4r+RcXHnSw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(396003)(346002)(230922051799003)(451199024)(64100799003)(1800799009)(82310400011)(186009)(36840700001)(40470700004)(46966006)(40460700003)(40480700001)(6666004)(478600001)(47076005)(81166007)(356005)(86362001)(36860700001)(82740400003)(2906002)(41300700001)(426003)(1076003)(336012)(83380400001)(2616005)(26005)(16526019)(36756003)(44832011)(5660300002)(54906003)(70586007)(70206006)(316002)(6916009)(4326008)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 13:34:32.6710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a87d02-cc07-4c80-0f51-08dbc34c4fd0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB4C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4880
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than requiring an entire memslot's gmem binding to be
hugepage-aligned to make use of hugepages, relax the check to simply
ensure that a large folio is completely contained by the range the
memslot is bound to. Otherwise, userspace components like QEMU may
inadvertantly disable the use of hugepages depending on how they handle
splitting up regions of guest memory for legacy regions, ROMs, etc.

Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4d74b66cfbf7..de5d72e21d63 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -535,6 +535,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
+	pgoff_t huge_index;
 	struct kvm_gmem *gmem;
 	struct folio *folio;
 	struct page *page;
@@ -574,13 +575,12 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto success;
 
 	/*
-	 * For simplicity, allow mapping a hugepage if and only if the entire
-	 * binding is compatible, i.e. don't bother supporting mapping interior
-	 * sub-ranges with hugepages (unless userspace comes up with a *really*
-	 * strong use case for needing hugepages within unaligned bindings).
+	 * Only report the true order of the backing folio if it is fully
+	 * contained by the range this GFN's memslot is bound to.
 	 */
-	if (!IS_ALIGNED(slot->gmem.pgoff, 1ull << *max_order) ||
-	    !IS_ALIGNED(slot->npages, 1ull << *max_order))
+	huge_index = ALIGN(index, 1ull << *max_order);
+	if (huge_index < ALIGN(slot->gmem.pgoff, 1ull << *max_order) ||
+	    huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages)
 		*max_order = 0;
 success:
 	r = 0;
-- 
2.25.1

