Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580CF4F551B
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456935AbiDFF3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451494AbiDFBQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:54 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2045.outbound.protection.outlook.com [40.107.100.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEF950459;
        Tue,  5 Apr 2022 16:09:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ng7ayQd7Zn00kBeVv+T3cmBi3bbWOdm6Oo7e6PAj+BIm6EIQhhexp9FlD1xAbuyoPs7oLjdnzd++0OUoVZ8RMGnjShrIT+7z6jusSFLSBmeLaeHhVH3muijs5THq1ugz8xVHZxOY4BoQBMGU7Mo52jWgeTfsTridhmkO4F0V9Kw4BPnZyQp5zJtjTug+MxwpPnOrqEPD0B72KDZ98MzREFhzD78wsqA+2G1CULLe53VUtMe+6Mu1jB9bzLbam2NFYqLGxMmHdlJc6qK96zEPexLKvmxnRbxl34AOrJ51UQ2DO1OBGAOVdVSIg6IXYuDeyr5ejaPI1BRzFAPREt43eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJnZ8HgiqgKVG6R5eAGjsRJ9zlWR8cbIUXNBy8fM6FY=;
 b=Qa3aDNvJwTn3ElShMetgmKtZ5kKK2MO90qdL6WT2HUBeMZZOvVl6kS2cqGlQ6WSzuuzRKSVgfg0t/BKjTHgxwCAdf0gugRhayTimcG8eAt1ech4iS9IT/Uj3BwKLVZZNr5fznrou9obWLeQJlk0e8vKYTtGoZyqUciqRLvCLoyUqXcPlq+gQAaNEC+3YPMzPAR0A3YD+EsaaNJaQ5zfF1vtu7loYTL7Fbg6bSNwqS3TQxV87OMsmDZD4rbNxaGZQ/sKv4ktcF103tuWy4SXunZpu9g3A3KJSHS8Ml0989GAXoh5To7Ux6Iv9pvnmqF9EZJ7sbIQEnZsx/93pHDTB9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJnZ8HgiqgKVG6R5eAGjsRJ9zlWR8cbIUXNBy8fM6FY=;
 b=QV+aK8jqr4ejWJAUx1owGIzKZPkdR/JRSUW5KOZcUK5hkNipEVMiE2H6UZ8BovLx6Ayfej52MlyD7TuHsvIQwgaT6pbFWpMWGrrRInAaS6HCtkcJsyXax5vhpltKyQwRjaGb7h3022uP+9XzuPG+OigpPOUFrScf5emOiUy49to=
Received: from MW4PR04CA0074.namprd04.prod.outlook.com (2603:10b6:303:6b::19)
 by BYAPR12MB2773.namprd12.prod.outlook.com (2603:10b6:a03:72::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:28 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::1) by MW4PR04CA0074.outlook.office365.com
 (2603:10b6:303:6b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:28 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:21 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 05/12] KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
Date:   Tue, 5 Apr 2022 18:08:48 -0500
Message-ID: <20220405230855.15376-6-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82150e88-adb0-4987-ad43-08da175955bd
X-MS-TrafficTypeDiagnostic: BYAPR12MB2773:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB27731D5957481AE51D9A2A66F3E49@BYAPR12MB2773.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0vIrKWQ9OPWA7DMPzQWE5sQFD9G+3diXl+Bscc9wCpYOPRkNeAxF/nfqmhfx2Y42rUMXouMlbU83sD3ggF1lK1kpACFKxN2fFmpG455YbXaNjI0eSziBCzlSBNDtJQ9EuEC0xQqXL++6FSIT0CzfVuME/TV65flYrk1cCTSZ0WVH6Q50fqyXRtssUhua6Evylmq9b0OKnPb5Wc9SBjmwhtkO56RLsoCSo7FDolzueUVzqQVJ0TRH1B5/TIP6a2XRqh322NCS9QRTDS+vvk7vb9GaOpta4BldOGhu0ftK8NcOZqNSihzcRBPItd7WOJd9Wqhqgg8z9ih/gpQ25L7DjVeaUypw77ZKgz5KbL9/4FOtBXHMn1RU3Q+mZnytaD2xF/svTLJ167Vm17mPmiPpoeMcKzXGjHU76IOfNiFlbCoeVcGqPztJ/5ZKfqN0hNLAzfVV6exWYslJ4d+3e68zOsecl4ribpRNAIbWmCZiJswijVD6FhaLsOPVfUAo5aMSNSG1n/E6OaFrsBjpumA81vYf4kRxziAM0TQJCnJsGZWpIY2QmqW5kLqSENpKHy0AAr3gK3WLZZqxoGTFmPJQUD2nlJy59ft5giIUvAAU9/eXLGl6Dassdtr5/AtCy5RF0tmO04RIg0zajaDBuAclQRFOEc0nsaNdYA0wcXhvZ82h7e4e7ST/6m42Or1j0Ykbhgjjmc7sm5qI2Frf5AP7w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(86362001)(1076003)(316002)(16526019)(36756003)(82310400005)(186003)(40460700003)(8936002)(54906003)(26005)(110136005)(81166007)(356005)(6666004)(2616005)(70206006)(426003)(508600001)(83380400001)(36860700001)(7696005)(70586007)(336012)(4326008)(47076005)(8676002)(44832011)(5660300002)(7416002)(15650500001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:28.2025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82150e88-adb0-4987-ad43-08da175955bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2773
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In x2APIC mode, ICRH contains 32-bit destination APIC ID.
So, update the avic_kick_target_vcpus() accordingly.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 571de2d4232d..c36a236e1e8a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -307,9 +307,15 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u32 dest;
+
+		if (apic_x2apic_mode(vcpu->arch.apic))
+			dest = icrh;
+		else
+			dest = GET_XAPIC_DEST_FIELD(icrh);
+
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_XAPIC_DEST_FIELD(icrh),
-					icrl & APIC_DEST_MASK)) {
+					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
 							icrl & APIC_MODE_MASK,
-- 
2.25.1

