Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630134BD3C6
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343620AbiBUCXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343547AbiBUCXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:17 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D97A3C70E;
        Sun, 20 Feb 2022 18:22:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRL7X14EO5GFK1kxAbG46wZ1AiVBOJ5gMFFFoHeGTRFcjKyq+zbreD1Ewhe99Jbmc2SQWBwulwv2xTQgB98UXAXjLMbN9c7cbQTCvRxM3GwE9czuJch9UwI4cjrDbGul1VQ+3rEiArScMJVkh607oNsgLIfAcYKVdpc4tQ0ICSFCiOHmiQl3rATblrlbzEuLLyB5zequuc/XNmjQyFfM1BFNqXLt/SPOkbVfaSOQWQ08BSpXPIDFEF2y2HYm+bYZiNhYOiQ++3RzkgDwzczNKS33IQ2m/5c/VMUuRhD4cJl43zBD+VAEwdXtQl8BcNEdMBCJZAyNlDagfowA71LHxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nUX5qKKqagVqGgnhfEpak/lYc53K8M4KRiWPlQ5GRA=;
 b=Kbiuj277uVArul9skXclhs0QrqHf+d28LtvZilITAmPpwFpzI82wMqSbdiLUe2Sifokb0L88UAPZFKI2/47W88Ra2TapipS8ySn8gQ2r2tUrL8VVk9GSirfksv/yHhoIAEQXFJjD88e1/tT+idEi5PlVRafY2zKRVMljGfdsG4MZzpIIJl2eIzd9F5YSbEnzt+tdJanNg0+sBr8y3Td4GbqRKplz57J5+svGz9CVGth4dCjvhBP2cbmC9AEC9gbXl7KYvpCJ2eiDTSqn9iDgUld065UvdLBM1kBXuQycojCb2GBlFY/5W2L2bVc2e1i8mZu1nWXlgvnAgMZWKCvUbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nUX5qKKqagVqGgnhfEpak/lYc53K8M4KRiWPlQ5GRA=;
 b=KxCdKvnT+0aM+UM3y4+og1FJgtUzE+gnUnPag/zp4anPxLMCjQq2sIMtcjWUc6uWti5NkjANPcGllZvL6jWXkHucTC6vGWVuz8b881WEzLiBLNbIAxGMM0hmXwLGaEWONjIe5p17n3NGMWIynU5MOSOdzVpy5q63rvj77XgHPIM=
Received: from MWHPR1401CA0004.namprd14.prod.outlook.com
 (2603:10b6:301:4b::14) by BN9PR12MB5099.namprd12.prod.outlook.com
 (2603:10b6:408:118::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 02:22:52 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::9f) by MWHPR1401CA0004.outlook.office365.com
 (2603:10b6:301:4b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:51 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:47 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 09/13] KVM: SVM: Introduce helper function avic_get_apic_id
Date:   Sun, 20 Feb 2022 20:19:18 -0600
Message-ID: <20220221021922.733373-10-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: ddf6afed-6185-4b9c-ba74-08d9f4e10f7d
X-MS-TrafficTypeDiagnostic: BN9PR12MB5099:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5099264ED8ECB89DBF696FEBF33A9@BN9PR12MB5099.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEYleusNSWMQTBGDl0/CvyEkKE9wn5pgsxvcrQ8kHANaNePluSVlw+tdSiW0PKqG0FGQh0n5cy7Kx0ccvRXH8JMjxEhDSQdia37pr0qYWTTFUB6CTxwATt+ZeuO0YSYHlPBKt+XvPK5ZjlkYPLxz+mQoVQ6rFYu3BC3naBHzpJToMQlR9CIJ2DJqmKqutSdohQqqAGrfz8aJA42g6KVzTfOHmw6JZt2vxyRg296tOkFT2GzQjMCOMUhDeA3+5OIdp6Jrchzo1Z9wqUFHpdTdD47OoXpl9lVxdBE/SxJjl59F3tGDD473kkpc0X/zdBn9r3ohd6ATVi417MGGEAKBqg+jA1oeYWQEDP+lLcM9m2tkrSmMAzxX6s1AaOyC9v8dm5/d17pgS4rzcQEf6zJr5iAKg/V2BYpXpe4RckXqDqxWZuzGc0VQRm0xatxZBmXVotvYqjkHH+s0l2um/dczWqUexsWAr/QCYjuy5UyLAEPI+T9brtmYm72kQA20b0PSGlLgxadooJK/t1m3zQF20RkTGCd/HGfDszBQBSGyg8g+54eNVagYnhT+PbPF0viPrh/qSjedZaJfn59WApXCZzaLeBnBPBjVwA+iaq2nYP+/NzuFKECeZzqkKHwNlq/rxs5J+h/6xrdDcmrtELPURYFhkjMeJ3+SISAR4PunVZLHmy/dbef/mmZnp0kLcpi0Wn6gDxmOBfiPeEsZvudd4w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(356005)(40460700003)(86362001)(8936002)(2906002)(44832011)(316002)(54906003)(508600001)(81166007)(110136005)(36756003)(6666004)(336012)(426003)(70206006)(70586007)(47076005)(1076003)(4326008)(5660300002)(8676002)(82310400004)(36860700001)(2616005)(186003)(26005)(16526019)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:51.2471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf6afed-6185-4b9c-ba74-08d9f4e10f7d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5099
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function returns the currently programmed guest physical
APIC ID of a vCPU in both xAPIC and x2APIC modes.
In case of invalid APIC ID based on the current mode,
the function returns X2APIC_BROADCAST.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 55b3b703b93b..3543b7a4514a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -450,16 +450,35 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
 
+static inline u32 avic_get_apic_id(struct kvm_vcpu *vcpu)
+{
+	u32 apic_id = kvm_lapic_get_reg(vcpu->arch.apic, APIC_ID);
+
+	if (!apic_x2apic_mode(vcpu->arch.apic)) {
+		/*
+		 * In case of xAPIC, we do not support
+		 * APIC ID larger than 254.
+		 */
+		if (vcpu->vcpu_id >= APIC_BROADCAST)
+			return X2APIC_BROADCAST;
+		return apic_id >> 24;
+	} else
+		return apic_id;
+}
+
 static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 {
 	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
-	u32 id = kvm_xapic_id(vcpu->arch.apic);
+	u32 id = avic_get_apic_id(vcpu);
 
 	if (ldr == svm->ldr_reg)
 		return 0;
 
+	if (id == X2APIC_BROADCAST)
+		return -EINVAL;
+
 	avic_invalidate_logical_id_entry(vcpu);
 
 	if (ldr)
@@ -475,7 +494,10 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 {
 	u64 *old, *new;
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 id = kvm_xapic_id(vcpu->arch.apic);
+	u32 id = avic_get_apic_id(vcpu);
+
+	if (id == X2APIC_BROADCAST)
+		return 1;
 
 	if (vcpu->vcpu_id == id)
 		return 0;
@@ -497,7 +519,8 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 	 * APIC ID table entry if already setup the LDR.
 	 */
 	if (svm->ldr_reg)
-		avic_handle_ldr_update(vcpu);
+		if (avic_handle_ldr_update(vcpu))
+			return 1;
 
 	return 0;
 }
-- 
2.25.1

