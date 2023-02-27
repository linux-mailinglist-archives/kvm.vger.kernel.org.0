Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F716A3D79
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjB0Ixf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjB0IxG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:53:06 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACB723C78;
        Mon, 27 Feb 2023 00:45:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ge2Z2nuZdx1fDBuWC1035CtT+M7aUu202tP41Xy2PLxz0zINcpXWuPBWLB/EdXoWXYMeYpWcqlKLlPcghWXDJTb200z4I8NJylYr1b8jdDXurIplR6v9w7XU1h/fO4C9zt0BvSV/FEon+uZQZqB39Nk5ukrV56aEimkKXIVXEWutN7x5d1xFltB7etOLlc5dRU4Zrd+KsTs0IPiiEkSvZ31eXdRd+1spoqfoJPZggSfq8vG4IE9FegfHyCy6xOsvEhwCz+tsRmb9EXsLrJtLBKdP3m0J2ilqFrBfj49SGGf19jmXX57SGS1wbYaRDcONN6uzJbHNv8Y2epwGXia9EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oR7zheTrX5qMmDFyKQ7qK0DSOkugApnTFBoUnooBEdU=;
 b=iNBDsLGlbEWgN4fDZBw7WhBuqy4D8ASL1wzQyOv64I0plE+Qcj0gHEouXCCFfBhBXlFC82PHSB2Nhwx9c13ov627NWBP7WAHodhZ0H5JUiaFlEn9Ag+cN0vvyMQIlU5eqOewNTKngkG1dxMn2uofJu1E9OgPO9wDHD6OyIgXsAbwLJ0DLU8PmIjr9I30Z/PYVj8u1pvS7eFtaLp9CPX/heML9MvHeXiJpBf4+G1iYxkiwZLrOLxBtL30FBwW82FTYI+ByHCzhmxGud5j8z0bPTIYyBx5GL9LHzulc/ew7WZrYHIfwfLxeC9n9Km70NSUEQFZY2j97oGBmpkHoi9MzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oR7zheTrX5qMmDFyKQ7qK0DSOkugApnTFBoUnooBEdU=;
 b=TnzVFfo//PYFxS+9Fh0jVITgki1BYRkzlgq027E4pFCGdLEQ4napLN7nBJqe5zXxg3hmYIdqywfrOgfYtfJOHoOOehubeG+hRtDBsd9eZZI5S5cs/v2FLTs/2blo6sx9GmCjdtW+zp+TF2dYWChJe+8gF1W7X7hy9J65PNzArww=
Received: from MW4PR03CA0291.namprd03.prod.outlook.com (2603:10b6:303:b5::26)
 by DM6PR12MB4108.namprd12.prod.outlook.com (2603:10b6:5:220::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 08:43:03 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::be) by MW4PR03CA0291.outlook.office365.com
 (2603:10b6:303:b5::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Mon, 27 Feb 2023 08:43:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.12 via Frontend Transport; Mon, 27 Feb 2023 08:43:02 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:42:58 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 06/11] KVM: x86: Tweak the code and comment related to handling concurrent NMIs
Date:   Mon, 27 Feb 2023 14:10:11 +0530
Message-ID: <20230227084016.3368-7-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
References: <20230227084016.3368-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|DM6PR12MB4108:EE_
X-MS-Office365-Filtering-Correlation-Id: d54c9dd8-3f85-4f7c-5081-08db189ea381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3LKgvx6RKAC0mWAp3cNY/9ourjEjufUmq1ziWhoqHcXp6rrspRIoDndA97F+HbCLj0KgL8NWuBINYlJ3W+BJ/9vpCzqP8Tacw6HkD95zQmugK5HOdeyXIszuXoqfW+TysI+vPfTeEreScXQjkaqwjIJpbVpWvE6KsZ0pKrQcgb6lPc1KGFWBusbuhNNnaWrGLoPzHNP2i3XDV9UflYQk6PxjY66s7F3RCJRsGX2bT2NXumM0RVNrG6+4x7lGJRkcKDSUMBD2cUMRuvLt8VdRk3hNxUWgtKEsA1bv5bLYvGUNNpj8euQOKGfOqh344FwJ8hXj1cxLeKDzQuj7Bze5TmA5TygLK9BN2MyWiUUxUNBcRMocL3EO3KD2TTWVS7IRPH6IymIYaifvpPwNZWReKgCygvQjp0jrHTYWuia5lh0cHOIhmTL3L/yoqLK3fB/4vz3wRrTGnaCfOQf43o7Qcef0IUQyM0aQR43ipQTXMSTl+W2w9ge/zoeYWfBX4aEw4RvJCd3J0RWxZnbQcbhlTe/Dm7kp21LJqwNBrBQ9i+IL3kzanRpE3zE0+eZduz2O3qs6yZf3skdFdv8PNje/5zPbNBt7OSi5yj+PpP0a8KMUpnfbW//JaPQW236wdPRJaPiLYrvsqA0OIt/myCU4NrTNN2v6c6x7btAQAciguPjdXfQkMtQop7JAw5z0HQ7mxXdYyjlnMV6tbrQWCVezPyVEkPQqfi1ggJQpGC4PrB0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(66899018)(83380400001)(16526019)(426003)(47076005)(44832011)(2906002)(36756003)(6666004)(26005)(1076003)(54906003)(86362001)(478600001)(110136005)(966005)(41300700001)(82310400005)(7696005)(36860700001)(81166007)(82740400003)(186003)(40480700001)(5660300002)(356005)(70206006)(336012)(2616005)(316002)(4326008)(8676002)(40460700003)(8936002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:43:02.8398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d54c9dd8-3f85-4f7c-5081-08db189ea381
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4108
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Tweak the code and comment that deals with concurrent NMIs to explicitly
call out that x86 allows exactly one pending NMI, but that KVM needs to
temporarily allow two pending NMIs in order to workaround the fact that
the target vCPU cannot immediately recognize an incoming NMI, unlike bare
metal.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---
v3:
https://lore.kernel.org/all/Y9mtGV+q0P2U9+M1@google.com/
from Sean comment.

 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1cd9cadc82af..16590e094899 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10136,15 +10136,22 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 
 static void process_nmi(struct kvm_vcpu *vcpu)
 {
-	unsigned limit = 2;
+	unsigned int limit;
 
 	/*
-	 * x86 is limited to one NMI running, and one NMI pending after it.
-	 * If an NMI is already in progress, limit further NMIs to just one.
-	 * Otherwise, allow two (and we'll inject the first one immediately).
+	 * x86 is limited to one NMI pending, but because KVM can't react to
+	 * incoming NMIs as quickly as bare metal, e.g. if the vCPU is
+	 * scheduled out, KVM needs to play nice with two queued NMIs showing
+	 * up at the same time.  To handle this scenario, allow two NMIs to be
+	 * (temporarily) pending so long as NMIs are not blocked and KVM is not
+	 * waiting for a previous NMI injection to complete (which effectively
+	 * blocks NMIs).  KVM will immediately inject one of the two NMIs, and
+	 * will request an NMI window to handle the second NMI.
 	 */
 	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
 		limit = 1;
+	else
+		limit = 2;
 
 	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
 	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
-- 
2.25.1

