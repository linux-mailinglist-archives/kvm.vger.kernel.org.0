Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DDC4BD3BE
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245563AbiBUCXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343566AbiBUCXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:14 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9111D3C707;
        Sun, 20 Feb 2022 18:22:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRtMAIRnXEWrRnXcItbV6rj5T/Z6WoY8t8lzevmiEud/SslhKEmChjWZR7H9OPM8XZTfgkZ0wzJHgQkG0u3lrXr0UHKDR2ENCXWP/MkgBPawqVJZx0BkELAEbV+OT3IFu2HuqcaJ8PcxXec0mI+J502L4pO6yiY7qhJqcNvErFb/G/jUa3P3ZtboLdcAMSHkdn6wCEA9QLAbp5j30hssq+ibswiDZ5BbrrxLbM1jzfbREglZpvvfy+/B5JagsqsmAMO9iPaj5uG6ciOq+ih+i8Ze6om4jDhtwRev7XxEj+L0PFiIqDWDNRk3b0HVT3mKfN0DiAiTBgddhDLJoNdNdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWXXMkQEQ8tqazigpao9VWa844NVwWLMBVAnrywxG8M=;
 b=AREsvDrxOwwZ8pFVah9U3nhGb6pIs9srXiyXTcO/MZts9KX3hODgHz1GYCdUA4p9rrJDYNNmp5SZFcL1jyV/PF2Yxdwc3tIa4SawGEazEjLrXsisJ+dugmWtDEgKPWl3t6llhstZVnezVMITCe96CD3h4hYbLfL4pMDID56neyiXparDHvlk3T7haeQUu2XIt9hGL+WjSLI9YY8rQ9Glw42AVLVi1wVWMSSO8qcLTGgXZ1Hel3XDVlzyzTEij2MpkHOkMGk2QRpOlXa2IvJ0GoH7flYMhzYYTwpQVt/wfWb2pSr9ejBPH52zXalLuyRSJJ0svxURajujuFNxw5kyHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWXXMkQEQ8tqazigpao9VWa844NVwWLMBVAnrywxG8M=;
 b=0cAJuIpKSnfZGwlahAl2K6nyCo+nJAwRSOkFsmZ2rdYUoYaOL6/UMnDB23QNciFJZvYQHuMRf9hTRBXrlbiSbeaWMx7cRjqktrmA0I7ynyUnIoIrlIK81sh9/3bVQCL8X4sfBFrX4g8slK7fupbNn2dTCbM+z1TD9QWQ5fyijYM=
Received: from MWHPR1401CA0003.namprd14.prod.outlook.com
 (2603:10b6:301:4b::13) by BY5PR12MB4115.namprd12.prod.outlook.com
 (2603:10b6:a03:20f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Mon, 21 Feb
 2022 02:22:50 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::ba) by MWHPR1401CA0003.outlook.office365.com
 (2603:10b6:301:4b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:50 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:46 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 08/13] KVM: SVM: Do not update logical APIC ID table when in x2APIC mode
Date:   Sun, 20 Feb 2022 20:19:17 -0600
Message-ID: <20220221021922.733373-9-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6098490b-1f0a-42a9-8136-08d9f4e10efe
X-MS-TrafficTypeDiagnostic: BY5PR12MB4115:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4115ACC1BA26C1E1F609BCC6F33A9@BY5PR12MB4115.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySsIRvd9gPMbtsupU7/hWEmkMNk9Qi7/b0F8xRUGYwsts9dwZFrTxQQfhrJi8YV+2eXluxDGBQSzgLboWsWJOcKtR8g2ycNViobgKP7kK0jxx/FmiPSpOuJQZuWBKo7TL0Nlk0jHNqplJ/8xMByIjBOHWjzsW0tjVXDub18iZIi3i1Vmz7gsfQOZlYJEB04SuMMw0RpYsb+ggnIGLHR22BVco+VOS/PyCkjd1jnNC2eOqWb1QLNUGoSenZ0ZGB59kwc/0ukbxFqYfuricNxmSE1qcAg1vQXh9VL+AnGm3D+BV44vKI7i3kwI963ePIxca6rZ69BzA1BInH7JJSVulEbGFxpgogvEhVS/ShQhLlpn1vz2snablSw6vxZ2VAzvrXmX2mcBrUVn90rXfPBNvpuuXrDYozsvpGifoRlXENaleHdAJmKGkBKcE4buw9XWeGEnB8aGVDpBZCf38jG2OIFb2QTSM/k/EkijNIg4pWVSl3R/+WcDOnenePuM9nlqxKxOL1vM8rWQImCLO2RsuS1dZLXnt6S3HLx7OF00qTwwz9KorLI6liOzEjV4dsemXVIMmnz4PTb7pLq05FHcm7gQmLwjOzrbb1W5HvSbPbW8d1wY8rdsTrrpx2Kzo+upzQW4ToL+8kiV3ntE2QZ+wPDYawvRFPJVb70z1+lrx6O2rvhrEPZFSC7X0TFHshYjATr033jWFWJQSKn7toAQ0w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36756003)(1076003)(426003)(336012)(83380400001)(16526019)(26005)(186003)(82310400004)(81166007)(2906002)(47076005)(40460700003)(44832011)(356005)(5660300002)(36860700001)(8936002)(316002)(2616005)(6666004)(7696005)(70586007)(70206006)(4326008)(8676002)(110136005)(86362001)(508600001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:50.4140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6098490b-1f0a-42a9-8136-08d9f4e10efe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In X2APIC mode the Logical Destination Register is read-only,
which provides a fixed mapping between the logical and physical
APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
and the processor uses the X2APIC ID in the backing page to create
a vCPU’s logical ID.

Therefore, add logic to check x2APIC mode before updating logical
APIC ID table.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 215d8a7dbc1d..55b3b703b93b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -417,6 +417,10 @@ static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
 	bool flat;
 	u32 *entry, new_entry;
 
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return 0;
+
 	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
 	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
 	if (!entry)
@@ -435,8 +439,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
-	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
+	u32 *entry;
+
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return;
 
+	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
 	if (entry)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
-- 
2.25.1

