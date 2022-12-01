Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0AC63E7C8
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiLACWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiLACWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:22:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C8D4D5ED;
        Wed, 30 Nov 2022 18:22:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLnLt1pH5PWaBN6Git3lZRX0UqB4teeux9K00ryBFaZypCEcFo3SFX2y2vR2JS2dJIuM9VaCovYKyZrLdFH/vHsOE05OYhm3bvor9Y3YCLKNtz0SToc4GPLDc1ZUZV4KmwINz7NlxUX7VZN/CpgWRkJtGJPkMb+62QzSseOIcalBBrfAmHJ5HdGhux+32MwFXPWinvMfWP8eWU7HLwfL5mf/oVbl5zXngOMV8eRxXb9yMrC5DNPAqPOjqn71sRHSqkvJGwtT2KrJhlE9ft15GAq1Wu1P9h3bUIEcrpbtHSC9fLjGIWy2WzH4DLy0L4Xpp5fUS7mqVkpbPU6/en3RvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQAjlAPKNRKc521/wzfFqzadKeyxrglYxiNICeUux10=;
 b=d47hrrRkkWduhOTxyA4rmMKFKLmUPOyAFtZKIFAHwYhss6OEIRwqL//q/qV+aPAfVK4jzz4zh/bBHnW8p7DlTkisDcTgzVgSJqZ8Cik122JJn6bN5YaaXqcYuybJdzj7VEWcexrT16fpwbudrHMgq0vatIGTizqueNdbPdjxk67vRkxnqy2dvB82r7vK0lIMDAYOmrxwJoqaiQuvpa7uP5uahcH8U4Nogq9URDxBYabo0MEr+LqM5Z5Lk0hqf34TrmV3Jgfl+3pr/mfN5RR3W5uqxVyuZRH6LEMxAYTTN0vb1ezlyraBN/MwZREZMoDcPt6oMKgpzx901oylpS4v+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQAjlAPKNRKc521/wzfFqzadKeyxrglYxiNICeUux10=;
 b=wX5bzKRs6pqFsH9if6xZwOpWh7HwD859nKEGDdW66yhPAyOi6e3uc9gaxys0VNjy74TOgoeRWSp+/Y5pUPXCr8h8nk0OJfu0XHRYBAaI3fFLKNEBCKpRNNFBG6UA3cDfOkvwTCU0Yi0v8MeRreTY7T79l1t4z4Ju1BS4Im87Al8=
Received: from DS7PR03CA0151.namprd03.prod.outlook.com (2603:10b6:5:3b2::6) by
 MW4PR12MB7214.namprd12.prod.outlook.com (2603:10b6:303:229::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Thu, 1 Dec 2022 02:22:00 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::5e) by DS7PR03CA0151.outlook.office365.com
 (2603:10b6:5:3b2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 02:22:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.21 via Frontend Transport; Thu, 1 Dec 2022 02:22:00 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 20:21:33 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH kernel 3/3] x86/sev: Do not handle #VC for DR7 read/write
Date:   Thu, 1 Dec 2022 13:19:48 +1100
Message-ID: <20221201021948.9259-4-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221201021948.9259-1-aik@amd.com>
References: <20221201021948.9259-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT038:EE_|MW4PR12MB7214:EE_
X-MS-Office365-Filtering-Correlation-Id: c81b5452-bf0a-4fc0-3408-08dad342d409
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zheap7xYOfCbmkLtVg9HUZdNaYmGapmYz7Cn9Rs1RK9fPbHGAjyQprLZItWGppGxGQFZT8dDxsOv7ykO8JdgOEg7TMncNxu6Bo6fd5byTH20alVgDWuB2gAG23NQppqRUkR7boqrUObmfq/XXNLhMNCnvisf/kLL87EEz7lf95bxUTHVjKGcbp+IGkNA7XpFtD2PVxAh/WdNofsoQ6Hu57QpPu5mAr1D7yI+dz5Ictw/Jwx5ozhkrhDgyFXYcy62U2h0Geb2MEUcxGxwJGX1pLiiBrcZ06/sXqWrw4Pb2gwsqWfj/o/EfcvfOBAFkiyX5Li1TeFFmUD5wS6qL3PW3unX61SdrcoElZgu+JKkFvbKiwAZejSoXdlH22Kxb6yH5hoo51ViTFz7w12L/em31bAu5OHVp4sa6ul8B6DqisoV9lsuAbZ19W2xoapE8mW+oAbkNc+wRzJE0D3BsLLEh23z0bQYXMVoaUSR/9xyi7+LmICVx4POSEXdYCdnB2/HqFvK25czYeOvQV5GzoCj0sv9n+INGUnxgp2rj8hYxY7/2qe45NemyQn2qKoo3T3aXov4viV7OZR1AoRr+vvX9VqmJn2AyBrYxzGxU2o8GyB4lecZZzc84XSGX9DvsJ+uFdBrSwy7kTkHA7N8vSyEQyuWmsd8aTCijyC3Pq/wIMjKdhUGhLYl0DlvBR6989+oQ7NvuuCWiJB1Jb4voND6wCe+88T/LpOYnjP/FeQVmFw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(478600001)(2906002)(6200100001)(6666004)(37006003)(7416002)(356005)(54906003)(81166007)(82740400003)(5660300002)(4744005)(40460700003)(426003)(82310400005)(47076005)(36756003)(8936002)(41300700001)(7049001)(1076003)(6862004)(2616005)(8676002)(336012)(4326008)(26005)(40480700001)(316002)(16526019)(186003)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 02:22:00.4240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c81b5452-bf0a-4fc0-3408-08dad342d409
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7214
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With SVM_SEV_FEAT_DEBUG_SWAP enabled, the VM should not get #VC events
for DR7 read/write which it rather avoided.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/kernel/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a428c62330d3..4e91b9f8742c 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1618,6 +1618,9 @@ static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
 	long val, *reg = vc_insn_get_rm(ctxt);
 	enum es_result ret;
 
+	if ((sev_status >> 2) & SVM_SEV_FEAT_DEBUG_SWAP)
+		return ES_VMM_ERROR;
+
 	if (!reg)
 		return ES_DECODE_FAILED;
 
@@ -1655,6 +1658,9 @@ static enum es_result vc_handle_dr7_read(struct ghcb *ghcb,
 	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
 	long *reg = vc_insn_get_rm(ctxt);
 
+	if ((sev_status >> 2) & SVM_SEV_FEAT_DEBUG_SWAP)
+		return ES_VMM_ERROR;
+
 	if (!reg)
 		return ES_DECODE_FAILED;
 
-- 
2.38.1

