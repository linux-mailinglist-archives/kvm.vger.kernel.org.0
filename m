Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC8D7CAA3F
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbjJPNqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbjJPNqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:46:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30CB173C;
        Mon, 16 Oct 2023 06:45:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bb+mXakwkt3Vpfojnzc2AoW8ppWKxGA5I85WNtP2Vh95gbGYbx7570465CrF3M9Rt/buoBQd+S1EUbWKpmdDola2cibgzjeA5lMQGEJILxMfeeJ70DiMD67ci7AXm/m5B6HHkTheZ+gtJLVOpSTYoxnOXIjXtEolH4Kq5//8nLUGszTFx/52zl3t/Mb4gWo7WDgERyDT3NHaOL5WbLyAcIKhUIPHGNRT+kneDQh2qRDelD9m8SoDZoRcE9+OqnKsVXHaIKDe8GxBFaKTdecn3jYju/LSOlF4Xne05H3pyoO4UePwmAqMkGisnbuODX/EmKyMViLkSYZvebAi7Ona5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=retcVBgoec4s2lvshZW6r7nIrpxt4YSPaZoLpkyaMjA=;
 b=RktMGwfoT5H/Tcz4+tMTAd/BR9sKcBIHl0wFEjv6uZGDtbFs9ZWoSKUhbxLNcnXZDKIXMqgrSA7YGEHJGBA7kpMlfOiS4+hdWWNqMAfzTWFcD1Fx+1loe85wcgzKDPgmJn3A1Srop9FjeUf2JorK/mVOzXOTEzcpZ3UeARnFktmVyPjks2Btc6z6bxQdIzCoKVhB4tBxF7OcUGDiPUuJLP8uFSwKdgo+q3ESif0Z30OR6cywN+4zJ5fryEC+2Y+8rhBWGsgLcv6H0cBLMTDp6JuIsm8bOyw/9ssExz2sbKLY1wZLmUzTaTKY5igpB3FKYYRKF+H6mK+GQCeoYZGLzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=retcVBgoec4s2lvshZW6r7nIrpxt4YSPaZoLpkyaMjA=;
 b=RXs5sY063xNzWQc1OZKF5OLoELPuf305AlpdUYjqobfkicB44nCkAriuaZWCnFSy6IIOQ8L7oE3Peer/i69c9AfAVvMTUBhLzdY9jbyOIWIb60Zjon416m/RqSWGo71j0GADnqMVswA0cww03xdSxnTDa4J+HWmWTcRVkbdRTtk=
Received: from SA9PR13CA0137.namprd13.prod.outlook.com (2603:10b6:806:27::22)
 by SJ0PR12MB5612.namprd12.prod.outlook.com (2603:10b6:a03:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 13:45:56 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:806:27:cafe::fe) by SA9PR13CA0137.outlook.office365.com
 (2603:10b6:806:27::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:45:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:45:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:45:54 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 45/50] iommu/amd: Report all cases inhibiting SNP enablement
Date:   Mon, 16 Oct 2023 08:28:14 -0500
Message-ID: <20231016132819.1002933-46-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|SJ0PR12MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 227392e5-21e8-4ff1-6233-08dbce4e3944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/DihYQHPNn+8j+xgwjOh2OvUidIBuPytkdZBX9jUoT3fZPvFe9KRU6Hyr2NYGtdqe/v+Zf/zU4OQTxZDRtcZJkL/4J7rU6FAzoPvL0ZfcErSEywRF+nzNo9vA1lb8jy2xNEm0AOO1fI4RadQ3pXlJu6VOKzOPuVaukYvgzkzVUu5B1ounIKBKuB6egNCuUGws9jH3QnCrzl3jGOK0jl8dOwkn/ffo1sZxHe1AZSSiIBj0xPVg0qLwVvlZsBtFmx9N5fA71/7Z0F6e7iubQRvVys5ihM3oGCj/8fD4Pz7l6EiW8VhFe+4VU16Kz9ZXcY1rK2r+FZqsp1W21pW6S7oaWUh5DGYbeYlZSUW70NtHCBeNb7otFsv9NdVNTYj0oTdqX3EHjLw6MM/b9ItY69B9wHj+jo6cqtWlT4+Z+v5/vhPkVa+pNlQyqUCKcS/eBNYDYiqlVYPoDNLZnUjo+HodjfFAvETAvfgMBA0HNwdJ5UuGPdaKtup3CQUmVYLQyaDecuxsLnjSoSqrgKgyAiyWth/3xa+JuISy9Z8HvtyIrYGwPZlutswQL/sg9uGl9ShHsntIT+++nf/78gUdcw5enRH6q/NX55Ae56Zqrp98nzGQClercdF/SfVU3uw/LKJbGWA+UkwbPMS6zd4LE/Uvp4Y3H6QhjEXx/eWkMN+ljP8sPnLjsIA85hyVCQfEAzyKc79TQz66Ce367Fz8f1DlkZ+gswt99IZRaZCovE4F0Fe1Fj8M26ygyVtS7WrcMY9JTAbm58IJFQWCf1cgXLiA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(82310400011)(40470700004)(36840700001)(46966006)(40460700003)(40480700001)(478600001)(6666004)(70586007)(70206006)(54906003)(6916009)(356005)(47076005)(83380400001)(36860700001)(86362001)(1076003)(82740400003)(336012)(316002)(426003)(16526019)(26005)(2616005)(36756003)(44832011)(41300700001)(81166007)(5660300002)(8936002)(8676002)(4326008)(7406005)(7416002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:45:56.5829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 227392e5-21e8-4ff1-6233-08dbce4e3944
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5612
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enabling SNP relies on various IOMMU-related checks in
amd_iommu_snp_enable(). In most cases, when the host supports SNP, any
IOMMU-related details that prevent enabling SNP are reported. One case
where it is not reported is when the IOMMU doesn't support the SNP
feature. Often this is the result of the corresponding BIOS option not
being enabled, so report that case along with the others.

While here, fix up the reporting to be more consistent about using
periods to end sentences, and always printing a newline afterward.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/iommu/amd/init.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 6af208a4f66b..121092f0a48a 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3811,7 +3811,7 @@ int amd_iommu_snp_enable(void)
 	 * not configured in the passthrough mode.
 	 */
 	if (no_iommu || iommu_default_passthrough()) {
-		pr_err("SNP: IOMMU is disabled or configured in passthrough mode, SNP cannot be supported");
+		pr_err("SNP: IOMMU is disabled or configured in passthrough mode, SNP cannot be supported.\n");
 		return -EINVAL;
 	}
 
@@ -3826,14 +3826,16 @@ int amd_iommu_snp_enable(void)
 	}
 
 	amd_iommu_snp_en = check_feature_on_all_iommus(FEATURE_SNP);
-	if (!amd_iommu_snp_en)
+	if (!amd_iommu_snp_en) {
+		pr_err("SNP: IOMMU SNP feature is not enabled, SNP cannot be supported.\n");
 		return -EINVAL;
+	}
 
 	pr_info("SNP enabled\n");
 
 	/* Enforce IOMMU v1 pagetable when SNP is enabled. */
 	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
-		pr_warn("Force to using AMD IOMMU v1 page table due to SNP\n");
+		pr_warn("Force to using AMD IOMMU v1 page table due to SNP.\n");
 		amd_iommu_pgtable = AMD_IOMMU_V1;
 	}
 
-- 
2.25.1

