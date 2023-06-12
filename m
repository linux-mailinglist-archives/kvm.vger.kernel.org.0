Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A156272B6DF
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbjFLEwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbjFLEwZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:52:25 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2056.outbound.protection.outlook.com [40.107.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B201BCD;
        Sun, 11 Jun 2023 21:52:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxeWqIGdkhCYuov+4xBX1NWAVaVJCAfokYratb0heeYvUMHzHTF5qI+5ncuR5OhpPRWCMAGSAT6x0mMWE50uYPtu4SG0vTlefL/JFOHTnVNT1I6nAkkEH9NdSmfk8lkH9unQ9KptzrrgKu8D1WuggZmbgffMGFTq4PyJ/rJPIkieOiLr+RdUd3OS2nz+TCvg/3tPtdk4MfsQYa+Kk91xS5vHY60O9YEKoICMOsfSthn9DbfykXEbt/5qV6+utA03Xk0zEUQzlO06gKASTXNr0hv766Gr77R1rveq1p9z0DfRCHEvgTzV6Z2AzZKLBsFP4extTM8TUlpihu8gqr+vBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sKJx0R4sv5FkQcubDKo/v4xIgCFKS+E772CH7PG+a7A=;
 b=O3mm5XdQKg5O959KSCIKfa7DPmR8cuoHkQkwM9OS2Tl/tM+VmpmHhWBP07PLCsGpPggqHbjZpuUCA2tq2NQdb69YHc65W10CP3ivVjPiBzKQNeU0XnN9sEq1/pbhIp7ylS0wHSo43RCo0ZFn/JeyKmXHaGefuKIZD9Kx3sMg53fpJF30KBRc0Y7+selMZqPDpsWQe52wH1c8CS77/KgZ72eKqskQmb7mL2ThRf8Tuwoyj31+kDlDE3Lk0at5UHE0IhrBDmeQJAM8XbPjbssBcrYCOcI89pk1A7kqQRFfk0zIEEmdF8cjqT73FAAbdWQeX6dvsrvHm41OmDtgCnBNrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKJx0R4sv5FkQcubDKo/v4xIgCFKS+E772CH7PG+a7A=;
 b=EfGg3KHUhajVvLRs0Lb2DIVSrMtwI1r38XO3vQidQ8jN5aHTYavFvJw3TRk4FTF9HCHS/fq6W95K5CFIioLtlbDWEpjWd+Ov0b07SRLs/0VSu+ADd+at1OCklAfVnelrlnuuas95u/1LBjs9tkq+uEhyT+Mzkcv0etHOz/NmpFs=
Received: from SN6PR08CA0004.namprd08.prod.outlook.com (2603:10b6:805:66::17)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Mon, 12 Jun
 2023 04:52:08 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:805:66:cafe::f1) by SN6PR08CA0004.outlook.office365.com
 (2603:10b6:805:66::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:52:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:52:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:52:02 -0500
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 43/51] KVM: SEV: Configure MMU to check for private fault flags
Date:   Sun, 11 Jun 2023 23:25:51 -0500
Message-ID: <20230612042559.375660-44-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: c99a4267-3fa7-436a-e8e3-08db6b00c6fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HyjRnG38AX9bs9UjcbW9XGreVbmQQPpE2V285In5KT1Ed79j7kE+Xm5rXnl8lMChvClUNfaCvP2DSEJtSIglR0ilpyt+/caOv9KLN6UIERaj0s4yCuc4a1QD3CPh7DFbfVkY/JVJDkco6PyqWmA+VYiI+l2ja/1lgW5UBBDEXC0enWCCdeEhyHqzVfx66loCtGk01Gkw0QxvGnHnVWHCyOA9fTszysabp7thQyjBC49n0RIaUNNxQ45QM2ofTc3RSlogrsZPsd/D2LugMKP+og5pM2POU1ab/btlpZubaYaLwq35dd/Zczk5c06eQ8d7HU9Yrf2FPML8junDaueXN+crEnVfW0dmW9CUHSd05ioHCqghJsCx1UVGZohqSiNSAE17BJqQPSQy/8N7WJFW5W4Y2OyTetSbAHS9SgLCtv+76nLaakMwxliG+kQkoOOkpqGt5dZ1Vc0vE/sdqazJAvuF3hTgM6r/qiR2FWYu864AHpfGKHc8UWhUf/tv0Sehdz1wdBUqei+TiESI5jHFrsNactQ4ru+LNvCdOsMhI9Tmbl0AOKntM/TQVM14gHYnh+Lm3OXjIRbqRfg+d3eVNvf1nsdatB3cO92reQOe+kS2KDsNntQu7zsZoaATe6rGq2lByDIJ/3pA78K/AOdVQZ+Wr2ZdW8QF+qONO6IWzQVpgCLODNKDHtPBryApihzHzaq8TEEVFaGJOOHY6IV42XMfGME1TelH32bv1tvG75SkbjbVH2/v2ECBmKgFSrryT+rqtNxC771LK/Np4vYJ9g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(47076005)(16526019)(426003)(336012)(86362001)(186003)(4744005)(82740400003)(36756003)(40480700001)(316002)(81166007)(356005)(7406005)(26005)(1076003)(2906002)(44832011)(2616005)(36860700001)(5660300002)(82310400005)(7416002)(41300700001)(6916009)(54906003)(4326008)(70206006)(6666004)(478600001)(70586007)(8936002)(8676002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:52:08.4780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c99a4267-3fa7-436a-e8e3-08db6b00c6fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP uses a #NPF flag to indicate whether the guest expects a shared
or a private page, which in turn dictates whether the KVM MMU should
map a normal page or a gmem page. Set the appropriate mask to enable
this handling for SEV-SNP guests.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ec74ff5e09c7..909ecd90d199 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2006,6 +2006,8 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (rc)
 		goto e_free_context;
 
+	kvm->arch.mmu_private_fault_mask = PFERR_GUEST_ENC_MASK;
+
 	return 0;
 
 e_free_context:
-- 
2.25.1

