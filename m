Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75387CAA1D
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbjJPNpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbjJPNpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:45:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D6B181;
        Mon, 16 Oct 2023 06:45:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NW7a/Rn0j5mtiZeNq7rfqLh+HOdFZpjz1soCAgSi3/2RstS60P0MmoI7hXtnxykT0jn6pq2JTGrMzWmiXXccMwtHNlsF6bVJZaJrPeq6acIr46+3ayBATvF/E7taluDrxGPhECInYZdT6PSKS1/U+rr8275h5+C4HF+0gvPmQAMj0FOGIWp3tUXS1rj/XOzFf6OnwnBDwfNqrdG83OX7r7i2g/vsSu+aZNyx/FaYmD+k6+UvXcq0SZQjgzGPD66mvn7zOZhj12RAeIwCDdn1b/u6vJopIDuXJ8VsBqNgowX4f8+4GNdjCarwRHEL4uruxBfBWFdXHiJxOUVJdFSGTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wn6oZhIubfwD460mmy6EzHlgZAJwJei5Qlwu7zMEaUc=;
 b=EdHWATlDjPfwGIjf7ediyIn/C63QfWibF0Wo14DR3+vnUz44uxeOVGlFbQwxglUYpEZ5Rc8lbmHJoBYBhagmY3qUiLtvfCp/+2I9aRmCmsIVTT0eVF/2TKS/Yd1okkjdL4ln0CwRQ+z0V6XOo900r0foVjGwST2GXfVwaqLz3WMsXafMx3iLtBsJ0mNy6JtwjjjL99tD6daZb1EN1JBhJn4x9sBkP/Cx7972/ajJotnMKcoRJROTvndo1QhVHAAjzH5s8b2AOZBIIV6/zCss4pI1cgGRiU7fy2zAu4pp0luJYh4GwJBmGkf0fzO/VlAYtJP9vsbwh3R/DOqCCJf9aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wn6oZhIubfwD460mmy6EzHlgZAJwJei5Qlwu7zMEaUc=;
 b=fVx0knoeiJA6wADXijerP92Iew9vjUVgKfB27qofb7288O9KvjyTaA6NXblPe2CCwzAqQd86gBatXaBQ4sfOAn2BeObNXjGwiscmKk/A3FrPGzgYWDdDVWHM1yMaOH6OANRGk/j3TuSKK3MDNgVunwzUrfmsiuQA/a4BYVhx0G0=
Received: from PH8PR15CA0003.namprd15.prod.outlook.com (2603:10b6:510:2d2::25)
 by PH0PR12MB5632.namprd12.prod.outlook.com (2603:10b6:510:14c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:45:13 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::d1) by PH8PR15CA0003.outlook.office365.com
 (2603:10b6:510:2d2::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 13:45:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:45:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:45:07 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 43/50] KVM: SVM: Add module parameter to enable the SEV-SNP
Date:   Mon, 16 Oct 2023 08:28:12 -0500
Message-ID: <20231016132819.1002933-44-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|PH0PR12MB5632:EE_
X-MS-Office365-Filtering-Correlation-Id: 00a42e22-6fd2-430c-3be3-08dbce4e1f34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: taYt3IUZQZ2aT1MT6570IjErHCJno++QfAnwehwAl1TAFpqm81DrKix1oLcczhbinAZfDAK5Qm4rRt8+sgVKPv0HLE//3sl840crs5YJHKJdbCHRB6FBGWA8MZKbdFh7Y0G51p+uUoGBKqISbBLnT1JYMXYsB2g5A+Ps+32RgSOZZ3KetTV6yG9nUSFKc8EigdbXd2M0VRSCx/2Ssn87hK5ShDk6AAHza9PuyJe5lChQDw093OMUSGiUBeQrt4+zYFVASSWgxIn5EontMwn7MgThRjgMm3R0Gbqn0VisMsxiJf2Jn5D+T+3hG/Ukp0QnzOp7Tt3Z2F4vSkz5Qq3ayu7xNIw/t4erW0BEAeOvstt//Erk9+mrj6xbxv94yFjcNdW5sPlekIF6zCqkJqslVv+bUHCrcQeqjBcZN4Yyca7xcvSxIHJlAJTbWUv6I8eX5/dwwZXOz7SFpZXN5RG2RMbaqSJdLIkQ+cbav5Rx1DqLfaER6WV2T4UQBUHvPyBFSOt9nyc68ze+cfIIZDfEv7/7/zspeyxVyeDMIzuQQ4OwUJObOA8PuYAG9Al/qsw+yYVQcaw5RbuuoPKFxXuO49OUSMHPqr61FtxF2t0Wjn9+fz2aIlbS3zih1/SaDy1gObYLbZlaF+lk5f0lm+Q2vqxz1ceSuRGNAt075Db4pdszjsrj5ZhZoNkhIdErxQnsVhgfO5jN0GBWr14fEJxp6zj6XeYd2YYQVqID220k6Tj/+/UUDu/e1qPcLU3Cp1pn6XD/cjR6oP4PwP8LbmMQvw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(186009)(82310400011)(1800799009)(451199024)(64100799003)(40470700004)(36840700001)(46966006)(41300700001)(70206006)(478600001)(70586007)(54906003)(6666004)(6916009)(1076003)(26005)(16526019)(336012)(426003)(316002)(2616005)(7406005)(8936002)(7416002)(4326008)(8676002)(4744005)(2906002)(5660300002)(36756003)(44832011)(81166007)(86362001)(47076005)(36860700001)(83380400001)(82740400003)(356005)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:45:12.8563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a42e22-6fd2-430c-3be3-08dbce4e1f34
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5632
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f027def3a79e..efe879524b6c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -62,7 +62,8 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 
 /* enable/disable SEV-SNP support */
-static bool sev_snp_enabled;
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
-- 
2.25.1

