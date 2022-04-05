Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C66A4F551A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450757AbiDFF31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450767AbiDFBQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B750062;
        Tue,  5 Apr 2022 16:09:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGI1Txo3A/gFvqnU3Khj2adZ5ECDzG6g00mXeKvid6mkAU8OQYVzHcnH9QKlfUj5UNWH/fzN+I1vnHYOIUI/xgq4tC/YIE2T9mtUC33ag5++/TXxsHSUupNXTsxx+byx2UU5nwNVoseucfAfErGzcYHSde5/swCV8jDPbdab7hPE802GvXzvNnt+S3x3Uh46XsFGnGhCX/vAmJ87dZbILJQI/8i0hRiAn5nNg2DjPc1KziGsyrnZs7aM0oy8aE5WkD7qrXCwIpAqyC+QvMGERfgV9b5ceFfNjeQ3Bgbc1EM/IjHn8Joe6+m+ClgN2M8qGCzLBTSAjQ7f7u/W0yt+WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0F1Ez1dBd0tyUiK4FCbN5ebk6TTaC0Q8zRB9oIPjIrU=;
 b=UDtXV1yfZcANkwGyTnFyMvAhjuhm/rnohqVHQAfbDEpVlgSFl2U3BljyNF2dfT81YXL9mmBXgwY7gPYkl6hct2Yg1LpnJCkF0NtocPqxml7iYHi33zP0Ba4yavUxoOqr9Kc4ckdAogcs/A/osYqzdAh9SBh4Y4fstUxlE6f4njmnLGxmCDIiJkjESOy2RCJzbQxsSuzVhNeMasORi4lRA/U3Q8LlCWDxdRHDFwmGd63s+Lvembm+rYaon92lU67gtBkIpktdjF4fFj4IVjErGCU4FIoNxtWonzxWPYyC0MjABjTMj5Ae3E1nSjGxe/KvXNsASlRvKDO0N9ICn9XVQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0F1Ez1dBd0tyUiK4FCbN5ebk6TTaC0Q8zRB9oIPjIrU=;
 b=XhsUsqRqaHDsoOXKZo14nJqrrEgUPW1FDveoFwNU84BJ8BbkpMKeYSg+Id5CKsjES69YAMjZyxSQIyABUBf2fUNfWOhyWjNeo/tEpA7wYt/4T6CKO/yQTDF3g5SAdcSvADZm31USgmrUJeHfLLLQ/vMXH7fMzQJJoCx9xfNgvrU=
Received: from MW4PR04CA0062.namprd04.prod.outlook.com (2603:10b6:303:6b::7)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 23:09:27 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::37) by MW4PR04CA0062.outlook.office365.com
 (2603:10b6:303:6b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:27 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:20 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 04/12] KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
Date:   Tue, 5 Apr 2022 18:08:47 -0500
Message-ID: <20220405230855.15376-5-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: e501b66b-6a37-470d-1769-08da17595544
X-MS-TrafficTypeDiagnostic: BL1PR12MB5110:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB51100027C2BE73DE65BAFF12F3E49@BL1PR12MB5110.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+ducNj4hH42c+9iegwg4qOvoQNRdc9yXwlviN4nlA87eJ4WcVYD7Zfxt9VESlCJdfwN4YLpJLblaXOhYguVm2N84Fxtlny1cCQ7+jnn/egh3WlcG0vqX6XfW/3JtWknKGutJW7gckaTPpkQ0o6WD2ebB1E50nzzImxtRJfFB+MjNhMq6awJbJ03gNUSwHvDR68CF5QH0d5ernpLdlaWZwMi760ywVV8GDK3v7Z2RVFtK24naNPxW47rID+Lg1aPytKkdQCR5qTOOpUn9AV4t+TfGWNdXKsC9b9/iE/H4QHXrPvx2b5+d4tuOqjK+hOtoJ6taLaujQIomqpalxjpEllg454Cdf7F9MEy8WqqngXykzhBR1YkXqGBlEkOM+UJRWb5/gQLKtWKwQjdmAovoGNhscNc9yT5IOD3Z+it8aqz7M+xOwqqo09XTwB5IPYL9pk/JUReJ1bYmukJIn+/vQeQkjL4RVTfTmIGYJG79bFORiHn0izIt5NL16kaUqs9whQR+eTUh+GqAKyIBGfbmC1Pe/M0foUkhcY38L6nAbVlA2e3KqqDDKmV0Ca3YdL7MDbiOfSR5k3xKw015b13xDFhYlHe8XXe8eyLb5eggzwXu4/vhfzs/vbExobLOzi706QKrmqjsSgU2mUNlxLnfGEKUSlga3qw1xkHxD7CCf6el299qa7WYdH3Jcf/yfv5CM5FQ+P16B7amjpOQojJFg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(54906003)(2616005)(1076003)(2906002)(186003)(336012)(316002)(82310400005)(110136005)(47076005)(15650500001)(36860700001)(426003)(81166007)(356005)(26005)(5660300002)(40460700003)(16526019)(8676002)(36756003)(7696005)(7416002)(6666004)(508600001)(70586007)(70206006)(8936002)(86362001)(44832011)(83380400001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:27.4056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e501b66b-6a37-470d-1769-08da17595544
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

xAVIC and x2AVIC modes can support diffferent number of vcpus.
Update existing logics to support each mode accordingly.

Also, modify the maximum physical APIC ID for AVIC to 255 to reflect
the actual value supported by the architecture.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h | 12 +++++++++---
 arch/x86/kvm/svm/avic.c    |  8 +++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 7a7a2297165b..1ccf301648a0 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -250,10 +250,16 @@ enum avic_ipi_failure_cause {
 
 
 /*
- * 0xff is broadcast, so the max index allowed for physical APIC ID
- * table is 0xfe.  APIC IDs above 0xff are reserved.
+ * For AVIC, the max index allowed for physical APIC ID
+ * table is 0xff (255).
  */
-#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
+#define AVIC_MAX_PHYSICAL_ID		0XFEULL
+
+/*
+ * For x2AVIC, the max index allowed for physical APIC ID
+ * table is 0x1ff (511).
+ */
+#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 3dd345ec3345..571de2d4232d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -183,7 +183,7 @@ void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
+	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -198,7 +198,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	u64 *avic_physical_id_table;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
-	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -245,7 +246,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
-- 
2.25.1

