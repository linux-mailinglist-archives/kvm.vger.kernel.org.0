Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804FE4F85AD
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 19:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiDGRSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 13:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiDGRSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 13:18:08 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD02131961;
        Thu,  7 Apr 2022 10:16:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAOqbvCXwI55akKR/7tTzCykm0iFtKUNZ9GvWtG/9sWAPw42rij44tJsd5F0FKnrDoRLeGFrNysNMUgJZfcRQd0XLo13zwd8bhwnXIJ23652nwzZ7j9HkrONPJs44CMmGEkT/APTuKTJTFfgojLYW1W8KK4WY9V82dcE8Q06bCNu8wfIC99hPVvtvMViUzWxvWDOMRsXsC7aEoobo0l7/qFSyOMxPTiq3ust0lxkXY+P4jFN75JnPFbkaPDE4dFGVHecHXk/dyE7XX4J/VjVug/gPdAjzszjHlfS2DV++rwa06YDS8rb674K8CumqS8hjNVuB/J064wD3+B2fPZ6Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzCCCVAny7OuLqMgtV9HiXWJsp6Jrlh8RoCXSMlVklQ=;
 b=BH2AwwrB/dM1IGggHvrGBFDHaLwEVlwR2TcA5+BxmtIvrKYGjjYqSrckvq7OKWZNOjWNZEt5cCopbTJud0ZQmGyexdgk78YKdT+al1CkugirPAuFk9f069M0ZdUgxRPGrb0Djw73umCrbWQLHj++dOjed0gRSjoC1Knaq8vJVl1psUBb5rBbJ3cpSEPZaPNKnxGX61p/h0XIzZ2piylLNYfWHLNY/bepMXD930TzYPB/SYEs7SLa6BZ6/AFebqcVQaK3WgLKPj8hgxqCZEntUuOLTu17NqbiMXg28v5pGeqRCUsFNpCS1HC351ret1sxg7XIQR8p1SxgPfrMEi1Ddg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzCCCVAny7OuLqMgtV9HiXWJsp6Jrlh8RoCXSMlVklQ=;
 b=LA8LUzVFsx/5QELmGPuC/3ae+SO+al/r3TVAa2roFNht6C07F6W7bK7iFya3yR6zRfCf8qdchkQ0KBCtPFIdu/qyvfjbaY14IPsQrgH5RHc3uAXYQtEra2cq+4Gdxji/U5URvUYvds+eAO0/ViC41XvDxHtgrWkLSGhy5SivR3U=
Received: from BN0PR04CA0021.namprd04.prod.outlook.com (2603:10b6:408:ee::26)
 by DM4PR12MB5746.namprd12.prod.outlook.com (2603:10b6:8:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 17:16:05 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::14) by BN0PR04CA0021.outlook.office365.com
 (2603:10b6:408:ee::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Thu, 7 Apr 2022 17:16:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Thu, 7 Apr 2022 17:16:04 +0000
Received: from ethanolx5673host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 7 Apr
 2022 12:16:04 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <jon.grimm@amd.com>, <brijesh.singh@amd.com>,
        <thomas.lendacky@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Do not activate AVIC for SEV-enabled guest
Date:   Thu, 7 Apr 2022 12:55:10 -0500
Message-ID: <20220407175510.54264-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f900c0b-cfed-4c52-a545-08da18ba4c49
X-MS-TrafficTypeDiagnostic: DM4PR12MB5746:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB574605F647F39DAB79C4AE4BF3E69@DM4PR12MB5746.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pDIkreaI51Os9ZW56VI5qOiaA6KpTImQ0TeoIAG1zW21WKgO0bzp3/bim3W/lR0YNkCQpJSOKbNnAmq+/yDMSE7cmevTV95PGIWzrciwyhEtBIDtw8vjPKLG47jMzerDy/1ZP4ChXEO4eFGXOttshjbncEIdemgJbcAwR8/5gi9J4z5Nbz5M5cYfNP27GBegURJn37NURDuarLIv2H6uZeA7IpmDRXKVmpO5gXELTOlow9s58hbvvCPhgtE+UaH6onutRyovFoJs6MzL5TwxS/EDzu0paPMxB5Z3GtLO3lTspj4NMk/0gPPnFAlagBani52l0IdTkFbUuukYwtn56qJtZBd3I1Fp7TzXaFBkRG7jO7Ja6pnpspV8KjXanJH+bXGGKEnU2mAnTJJhqcf2XqM0/6tqjtvpxfwMi6VEqC7vAWXQDiWgj/GpZicDvAUAPc6f/XFrf719M03WyLrlOZh3o3mtCb+n45EoiiOkweDJriXOoQMU0d1GoCsFjTV1m/zVefKYy9dHUUQXSsI5C2R3f2L9TCsb/QaE/X8Mqv/TlGttJVrvBzreKRVK5xbuv/NP1loiqPM/slXeguYKorCdvePOPbc5BKLmv2vmlm6qe0nhJ1WdkJmWWmjT0r1hDc5Ff5xgbjVfGslrSjt0XwxLgzo17Dnk3A/Wb9iFHYF0ImIU1AsSQxK5+/wyREr+LNzZhCkUJL0qWvN6wd3NKQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(336012)(426003)(47076005)(36860700001)(2616005)(508600001)(81166007)(356005)(8676002)(70586007)(70206006)(4326008)(16526019)(6666004)(7696005)(83380400001)(2906002)(40460700003)(5660300002)(86362001)(8936002)(1076003)(82310400005)(316002)(44832011)(186003)(26005)(54906003)(110136005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 17:16:04.8443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f900c0b-cfed-4c52-a545-08da18ba4c49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since current AVIC implementation cannot support encrypted memory,
inhibit AVIC for SEV-enabled guest.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/avic.c         | 3 ++-
 arch/x86/kvm/svm/sev.c          | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 59fc339ba528..6801a0c3890f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1037,6 +1037,7 @@ struct kvm_x86_msr_filter {
 #define APICV_INHIBIT_REASON_X2APIC	5
 #define APICV_INHIBIT_REASON_BLOCKIRQ	6
 #define APICV_INHIBIT_REASON_ABSENT	7
+#define APICV_INHIBIT_REASON_SEV	8
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4dae5e79f53b..6ffac1b88487 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1086,7 +1086,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
-			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
+			  BIT(APICV_INHIBIT_REASON_SEV);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index be2883141220..c3af579fcb91 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -259,6 +259,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	INIT_LIST_HEAD(&sev->regions_list);
 
+	kvm_request_apicv_update(kvm, false, APICV_INHIBIT_REASON_SEV);
+
 	return 0;
 
 e_free:
-- 
2.25.1

