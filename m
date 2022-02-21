Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34C4BD3B4
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244553AbiBUCXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343571AbiBUCXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:17 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF73B3C710;
        Sun, 20 Feb 2022 18:22:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNpZ7fAtWM1+1geQJTUiUYdT7r+Jwj0BNVceSdV8zgzIdFlBCV1FODU4XdiR+VKqni4v7fvLSrjGpolwcRaN43C1dVVyMqc/zoZ+lZsWOt2L9pNykSKS/03hSxhdBPxf8bT+gLXewXZOdN1qet0OkIRUGRlC746HM/3GlkvUTp2ekVxJ3u1W7r63BuRTJTpbDnhVh9uOKd/ty5zcxoBRRkt9cEYUeoBa8d/p4XvzxLltA0EsnvDSoiWtF7rrmJixGFzehUb478iup4Msyym3sK0P+M5YT/+KBJwDCIsKqNXYWlQUH+aoYId+Ga7EpLrzJIbAwxB3okrAh8ZI82Hk/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nxbfSwEDCXyoJQh7SpRg1pGu0L+AUHU8E7uK67WhCc=;
 b=DC2dDVfNcRvuBv1VFsh+m0/jd8WWYsZrje/yoM+q9GVNBLvcfPtyJm905+1Ua/8QOnLbdMfUIs8LXigO3ZKB0Z0RWjITyRAiLIZX3zcnwT74mSzRccVjWtAbIwUtyKSy8zqQpbP8PcAyb/1ANl4VdLg4nv/2+sOWIItsGUtEHbCP6gZprrB8d4emREqW04g35bKzds8n0H6v5jEpq2n70yuS5lg+l3Wb1Vh2VbwOLb8v6O4AL4mysKT6MQ451cubE67Tp5N29GCBLz/Mqd5FKHvfkPk6C6G/khwzTFZ0aFPeU6vUf4qf7x5VUQczZkh/jReEMF5hNDcr7ijPi9lwrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nxbfSwEDCXyoJQh7SpRg1pGu0L+AUHU8E7uK67WhCc=;
 b=axmFIJPjxMk9dID383wBS9Ignn/Gqwlw2D39blqnJHXc9ALZxcJww7Y2a4LorfD5Xph+SKk7SsTEJLBDr5pA3DjQC216aoK3iwhBDYf+Ko92gRJg3uLl65MuFYU7zI/f8cMvtCW1f6fDNpoR5TuRy3U4nI5qRKYUjYMnyNrR63g=
Received: from MWHPR1401CA0010.namprd14.prod.outlook.com
 (2603:10b6:301:4b::20) by DM5PR12MB1529.namprd12.prod.outlook.com
 (2603:10b6:4:3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Mon, 21 Feb
 2022 02:22:50 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::20) by MWHPR1401CA0010.outlook.office365.com
 (2603:10b6:301:4b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:49 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:46 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 07/13] KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
Date:   Sun, 20 Feb 2022 20:19:16 -0600
Message-ID: <20220221021922.733373-8-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e055e3b-7c8d-406f-0044-08d9f4e10e79
X-MS-TrafficTypeDiagnostic: DM5PR12MB1529:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB15292607AC78F58D015C7D10F33A9@DM5PR12MB1529.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5eK9WwNVxbAf438oXraY5nUNSXVllTY+W3Zb3STYRlfYAfZcHuypbsHd2tvjfcZQogwj31M46sJTx1nl2TQuzg1xXixujBvK5xcuzFEhVmu1n7G4rFfONZaHpcse5oC6Mgqs0EV+UKDe49tZuhf7whQKmbTP66RTWGst4fyFDtKpE0SHPfaLXBny1wi0hq96w0dBOi/ElXiZR+Z1m9FDw5XUSeUGr7objtC11t7DupqMqY4HdlN4ysUvZHkQGt1S1Abn12NA0xd9iwA097ALZYnayMQdnyYKQJyoKjjiFLlWvdoo3f1HWR2qtz08cJ9sCmaMnZghLO+jAhBrA2j7AJvMZtHKes946JKMXZSveReiEvtnBVsOk/JL+Xv75zxtgWHCaWp4Ya5ciHjX4sMBB6FZ2Th/MLQU3Q0ndIQ6V4/JOZ/4jZyKscBq2yS659cVlqYYBfd68MWvuFgEoEhRYnNQaAXLW34aU7Wr0wqFYlKEJImc30oLpZObv+sHCoOBNvI8AdgUyeBn5JQQ3ZDVIjD8vF8ZHIIRQThtX79Wxr1y0+aalG0lc2DHQGQkf1gcdoYVLSOD/gbHcDIvtgSljT0DgFwjaduw4imlhyk/8kcaV4E0CCm7PpPE4j0vIDJvfeaP9cVF0MjOSD24xOJnoEu3dL4LtJlxTUnYH8cc1VE947fJpBfHx3X9Puglrhhc7NzmhNJaRn8TZIyxQZcV3A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(81166007)(36756003)(110136005)(86362001)(26005)(15650500001)(47076005)(44832011)(16526019)(40460700003)(316002)(356005)(54906003)(508600001)(83380400001)(1076003)(2906002)(2616005)(70206006)(70586007)(8676002)(4326008)(82310400004)(6666004)(8936002)(186003)(5660300002)(7696005)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:49.5390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e055e3b-7c8d-406f-0044-08d9f4e10e79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1529
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In x2APIC mode, ICRH contains 32-bit destination APIC ID.
So, update the avic_kick_target_vcpus() accordingly.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 60f30e48d816..215d8a7dbc1d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -307,10 +307,16 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 }
 
 static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
-				   u32 icrl, u32 icrh)
+				   u32 icrl, u32 icrh, bool x2apic_enabled)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
+	u32 dest;
+
+	if (x2apic_enabled)
+		dest = icrh;
+	else
+		dest = GET_APIC_DEST_FIELD(icrh);
 
 	/*
 	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
@@ -320,8 +326,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_APIC_DEST_FIELD(icrh),
-					icrl & APIC_DEST_MASK)) {
+					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
 							icrl & APIC_MODE_MASK,
@@ -364,7 +369,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		 * set the appropriate IRR bits on the valid target
 		 * vcpus. So, we just need to kick the appropriate vcpu.
 		 */
-		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
+		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, svm->x2apic_enabled);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
 		break;
-- 
2.25.1

