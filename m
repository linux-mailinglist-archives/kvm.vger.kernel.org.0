Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A201519862
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbiEDHhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345658AbiEDHgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:36:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE0A24589;
        Wed,  4 May 2022 00:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4Op0ERfa6BbgwEvD8SRLAK5ekHzA89tn8TkWCNINXaLghJnv4ydTfhXTaMTVQEDoWU/sjFDvHEt0KMWluj63v+PeH5s0HWJR+CmXD3/A3HultSFfNSdSK5QCq1W0eEN2vhjzq83a9sHBQhpS1KHDoZnFCWKqVqYaACXniz/0idaOniJnAM2ZsfqSEkhnT4AyHysF7uZH9G/xJDdZs5O23hej2yT4oFs5XFOeDSo8KIBxg8u8IEX4NtsU2iSy3geEzHnicJXex4CYtJrM/wXv36DXoWMCvv6ua8sdrHyDUzPagkTTaoCg7Hbc7U9RBV8MpR88CrO8PuWJMNdU9cCEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zLEyZnzgUJ/seGaW57olObKvwk+ZcDptsE21MdgluM=;
 b=RpI7A+Cx38whW1zlquFQMJU/14m0qdUVuWDxBZir0U58qTjxSWt4ASUIYwZ/R7fsNTrn4LgGMqvSMv8DX4/cWg6WWy8J/IvXmIoYVwBQHgoQUjAFVay5gKi+EARcMNk4axiPygFq9pSKcVvU5VJ8V6QG1wl9vy4YoMjSzKZwy6dxrO5jwQCv6ni029NPwBjaL9kMZOsY6lfySChXZv6jvnUc18brELIfVaPoUO2z0Q9/4sfNgjU1OBrk9nWRF7M0Xs5Z3h7wJ2TBJdJ6PSCNJ3mH8tnlyXqWoqAXdWaZxKa0buF90Z57P9U566fSJlazXCCswDWcQLBE4lQ6/cl+TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zLEyZnzgUJ/seGaW57olObKvwk+ZcDptsE21MdgluM=;
 b=SU5k6SGgzxTsgUxLIMuhADjrXmXtk7DZ+rT/0qSzfPzsR24x2uFo0JMm7lDVCNY7kenMNNHkQ03W24x2JFQu1zxi660UMqyMz+Kub4wLOOhoyd0JsE/goT0VDfbJgWeMoW+AzxNdzXGUBDQv/B+llKBKjFQgqK+Y50D/3cwEAQ0=
Received: from BN0PR04CA0149.namprd04.prod.outlook.com (2603:10b6:408:ed::34)
 by MWHPR12MB1135.namprd12.prod.outlook.com (2603:10b6:300:e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.19; Wed, 4 May
 2022 07:32:08 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::c9) by BN0PR04CA0149.outlook.office365.com
 (2603:10b6:408:ed::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Wed, 4 May 2022 07:32:08 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:32:06 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:54 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 06/14] KVM: SVM: Do not support updating APIC ID when in x2APIC mode
Date:   Wed, 4 May 2022 02:31:20 -0500
Message-ID: <20220504073128.12031-7-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50733351-256f-47df-0b24-08da2da03128
X-MS-TrafficTypeDiagnostic: MWHPR12MB1135:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB11353D22FDBECA0834A1E17FF3C39@MWHPR12MB1135.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhuQP7aGOdOW36aX7HHb8Hrb0SQRFPpkwuXabq5ipPXrxntzy1FZ9ZWi1FN17CYwPecw1b6R4magiW5ODFvb7d9djs9/ftAWaVji3n2aYFKCSYZ46RzhpDQ4jyTLxrRlA0mdxcDwJWnq+sjGukwwT/QFczAcSL+G16XyV52Kc9ko9mlAli69r4lh2J0stT2KSo2qM33oQAd7MYO7JrlMw2IOCc7+g5iWSlBta+5PpsUJ+wEq2b1aTbyNRmLdy7oICb0HcnIqapDn2R+FfB/nDDWpfZXnlcd42+Fpj7wlXm7V6h6hseztU/kw4HDowjwz7mK609zZbWxRolGFj5kPJHv0gwZvmXmhLPdaKQETwuPpJRCx4dnSpbqbflnGFKTbOHURqzHU4MF6H1RT9ZyI18HGgwmHf5G/XTJ7BdUAWbbfXSSMaknyYMD6nHada9scbQEGPzdhvlj6d3++iy//ln8LfMO7mSfR4+3JQdVApZNg39NcDXYe9T3wxtX6MB1yuFun0XgXPZ5XcUt2QjPW31WKmFwtnaGxCV65jB143o3MIRbmZnwZ24cAevqH3G6AEnVL4B+IITT2g3X+pVpXocE8yv1EoIL1aBlSEHyhJnpDq7fUN8Ah/dIo7nlwxHVIwTZHlovDZCSZbrtkCpamdYu8mDqfoWKwggdd2Xo6paWKtVtzzuJg7S0uIdyDWrrmKcipP55W+urDp1Fs3a8G5g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(508600001)(54906003)(110136005)(2616005)(36860700001)(7696005)(26005)(86362001)(63350400001)(83380400001)(63370400001)(1076003)(16526019)(186003)(336012)(8676002)(47076005)(4326008)(82310400005)(70586007)(70206006)(36756003)(2906002)(44832011)(40460700003)(8936002)(5660300002)(356005)(81166007)(316002)(6666004)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:06.3447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50733351-256f-47df-0b24-08da2da03128
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In X2APIC mode, the Logical Destination Register is read-only,
which provides a fixed mapping between the logical and physical
APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
and the processor uses the X2APIC ID in the backing page to create
a vCPU’s logical ID.

In addition, KVM does not support updating APIC ID in x2APIC mode,
which means AVIC does not need to handle this case.

Therefore, check x2APIC mode when handling physical and logical
APIC ID update, and when invalidating logical APIC ID table.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 9213e9d113dd..3ebeea19b487 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -499,8 +499,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
-	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
+	u32 *entry;
 
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return;
+
+	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
 	if (entry)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
@@ -512,6 +517,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/* AVIC does not support LDR update for x2APIC */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return 0;
+
 	if (ldr == svm->ldr_reg)
 		return 0;
 
@@ -532,6 +541,14 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/*
+	 * KVM does not support apic ID update for x2APIC.
+	 * Also, need to check if the APIC ID exceed 254.
+	 */
+	if (apic_x2apic_mode(vcpu->arch.apic) ||
+	    (vcpu->vcpu_id >= APIC_BROADCAST))
+		return 0;
+
 	if (vcpu->vcpu_id == id)
 		return 0;
 
-- 
2.25.1

