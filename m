Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7FC519864
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345582AbiEDHhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345587AbiEDHf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5373723BEE;
        Wed,  4 May 2022 00:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+GgcLjEzkFQVBWtXdk3+tvq/So8Nt4LRWnI7eNuBRtdS/vqYGtAfArZRX0ngFiKkDtHT5Jz/M1a36o34/tEHiqBGph7r09XqA85oG5i+si9PFnvA19x/9ckqPqrsQSya+L7VOa9KHEusa7zCFIsjuszo/JB8iizFeJa963ZfrG2U4xz5zksgYT9vPY0Jt0zHD2KF8K3BfuhrZ1CAyJrIShIOYcSvByEN540x6CwPsowtytRtBQTI9zB0CUsBYT4oBPMI8DkcQRdCQUQwDRbi/yfE/1psOSJBYU1+HlqT0eJwewLJF4DWnTo6zr0DstacfBWj034xq9I2pDuiDBn6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwtOgpiXJ3IA45DgWr96HIvAUT2y3tBHa0Y6sbVjlSw=;
 b=MeKP+Zj55ECrFihRJ+PspeKBd7ywTI8NAS0r4+A2y1tKx91BKwIr2AZAwPZiUpP7DzGWw9X+B+edTrBgpHwJxkubyD+KwvKOHMjJCxj019s0iXCDyT0d4NJyT019U//rjou8aqzTaicyQeWI3JizTHO5K5XhNde3ISgo1qwFu8U4r3i5xSXpnPwLsBD6TQKSSoh2XxfPMlpkqgdxm5HvZSrg1OGOI66bcjx7owEf09jTL89r6aAOYmCNrFZoqHXy11VxDX2LSV0sh+NWv8Dce0IEoLs+vDT2l1jFk11kLWATyM+R5jgc4YEbdA7DUhc1zwW/OBnZTcqojCug8x1kwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwtOgpiXJ3IA45DgWr96HIvAUT2y3tBHa0Y6sbVjlSw=;
 b=lYN85jIDfvEbVm7/xsX6aGDJRZGYJgT+ISRG8+zFVqDymqDD+fUd+gSMXc4hFhBo/DFQ6Qv7p9QIsmwjWXhh8f22KSHyy1gvdan63ZgXccGMYQZa4DNaV1nQWvAtrO5VDB48ILhRn2i4QjudlwNZlcSO4h1zK7/8EiAlvozw4Tw=
Received: from BN9P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::23)
 by BN6PR1201MB0161.namprd12.prod.outlook.com (2603:10b6:405:55::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 07:32:05 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::e0) by BN9P220CA0018.outlook.office365.com
 (2603:10b6:408:13e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25 via Frontend
 Transport; Wed, 4 May 2022 07:32:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:32:05 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:59 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 10/14] KVM: SVM: Do not throw warning when calling avic_vcpu_load on a running vcpu
Date:   Wed, 4 May 2022 02:31:24 -0500
Message-ID: <20220504073128.12031-11-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed641400-c680-4e5b-fe80-08da2da0301f
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0161:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0161DDE1E59D6DF7BC8C1F37F3C39@BN6PR1201MB0161.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JmO1WaOCU91USRKmlGtfZ7C0jfVx0OR9wgPKv+cUDgJqDXSU/13o+iykFfgDiwNdD2V3CS5Swt7Q0kevLfSB2KuPG4wdNvFCTLlxAcPPWH1MX/B1iuRTcQKsoysMsO1g/REewUtbB0HdApTpBl5dzzfp5OJj8naQqpjB38MKuEzSQvK7IAibUWqL2/CBvZ54r290b3KZ7nIGdV549L0cBCVcriLn/iJNVxOwwZAbgQ2FzTicIDrt8mFZdTnnqFYXU78aVPAQirTzrkHC1XPM5I+LZ6rCX4sIIo/SpeSB620LHEOwC66cb+vRirRMLvWk3wxcCmVgOWFX8g4v6TT0FGIwGtg3dJ5ThO/4hwYWm4UPn/3VLHdfokvoJJzgv3Dkt3Fyc2Fg7uJyy8cZqpgY22/0fqmtEhUsZbF/FP3hHzI7u9x2Klgm22ZGhG6CgkwZT2Q/XDwjnjtYSx1gbfSZJl30I2O+ZPaOVPVHxZCeJmwHKuX8OxAoLr0uNSohJLqSn+tMQjRD70jSFIYxZaRnwy5e4fXQuM9b5NBWKYhiYpl1iJ6AtNUgoEANvchr5KAxnpniuxELq74VpLG5M5oHIdyrUoX3aV4r2IN/91R47d1mIBpWkj7btv+e1gRGgtlRsTCu31LqdyYloLNZzDcci7cFddXECcUUajihUsYso+wlxfOlOr+WW56XKkkz42mRMC+7lXAgHAod97vctp2pzw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2906002)(6666004)(356005)(110136005)(26005)(81166007)(316002)(1076003)(54906003)(86362001)(186003)(426003)(336012)(47076005)(2616005)(83380400001)(16526019)(40460700003)(36756003)(7696005)(82310400005)(36860700001)(5660300002)(44832011)(8676002)(8936002)(70206006)(70586007)(4326008)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:05.1141
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed641400-c680-4e5b-fe80-08da2da0301f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0161
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originalliy, this WARN_ON is designed to detect when calling
avic_vcpu_load() on an already running vcpu in AVIC mode (i.e. the AVIC
is_running bit is set).

However, for x2AVIC, the vCPU can switch from xAPIC to x2APIC mode while in
running state, in which the avic_vcpu_load() will be called from
svm_refresh_apicv_exec_ctrl().

Therefore, remove this warning since it is no longer appropriate.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f255ca221e56..d07c58f06bed 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1063,7 +1063,6 @@ void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
-	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
-- 
2.25.1

