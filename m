Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C244FE083
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353470AbiDLMlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354991AbiDLMir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459901FA44;
        Tue, 12 Apr 2022 04:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRgV9yquhz0p51dOeN5oX3P2b/kJuNu3OhMwC71Eq5pSq157ME/cQV/iv0VakzLfvYUKA0eaCzY8KEjf4eBya9KcxCC9Z51WPd7tHGc9U6NJVUlfYCgAJl8Du/WvKbwHPM+OMDTH7PEzyI7y9MvjoOBtPiKQZXNrRS3wMxQugcL7Cs4NWzo9Yj9EijlMV+G34Mxvfspl3jxhKCjqE9REGdZgErShq5NovRh4MRPeynvkABbn1U8pfaS3ULC6SAcxQ9feAQ/ASAwMBIOm9Wl14ZCgKbPRqJyqoQR9LF6fsrnH20JiCw6dfW20Owu27FTUArZzOTGXTR7lNkSxMRZUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWf+Q1aCWrU4RY9t+xXGlWz4FHX0nHFi9U3en7GG6Fc=;
 b=j/6FIe+MRQIR6cIzj1P2JcOpISCWIA1abadQ37QAKYo9AL0gNiwkrRU6u4wn/BgEOPkTj6nMHWnwJX37hePYIGP4igI7JOe7IdIhW1cYs/wkjCi5UxLAquPl5d/xIaIs/TY2dGOwBgObX6Ra/bIhm96pu5mCo4BERn8Tl1vcjpjSNBXq3PmsdyaBdcm2KqGO1T7zLC0+ErADbpfpMjuclNd/aGhhrlDiO/KEdcEEiX8OGHpwFPigpxDHIQxIFmJp51sFx7UGCyyT24UB8ccXzBPeoYNnOzPQG+JNFwll3kNoyjIDw5a/XqSpRl+GVYLgdMPTUKOaRrSCr9v28Lk7Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWf+Q1aCWrU4RY9t+xXGlWz4FHX0nHFi9U3en7GG6Fc=;
 b=g4MjwEEGh5H91is1Z1Qvx8odv710qEM9ca/J2HvEjtEJMSlcHdVGuHGGqS5DkXRtJOf2nrZMOKQbZJrmYzQ+vmPJ9e0GVkkMLIwOkS+TT9pp9ZRr7JiKrJaqnpA1r803bkRqnfo3mvNj1pJUe/goTOF8QkJhXQgWxkLA3FZQvfo=
Received: from BN6PR2001CA0007.namprd20.prod.outlook.com
 (2603:10b6:404:b4::17) by CH0PR12MB5092.namprd12.prod.outlook.com
 (2603:10b6:610:bf::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:10 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::25) by BN6PR2001CA0007.outlook.office365.com
 (2603:10b6:404:b4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:10 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:09 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 04/12] KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
Date:   Tue, 12 Apr 2022 06:58:14 -0500
Message-ID: <20220412115822.14351-5-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee8bff20-dedf-42b0-1ff4-08da1c7bdaf7
X-MS-TrafficTypeDiagnostic: CH0PR12MB5092:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB509287EE6755A480E67A7F92F3ED9@CH0PR12MB5092.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cnJCnAKhDJ9qgI4yKihIa0UTC5jbHdxUliuZvVBKNVJZxf9+SsmPx/JaIA4i+PX/ewrA+/Golizh8+uWmM0pBaOpU0ChuZv4tojgoVPAltgwJoYima/156Ev8KPkJxEgYqQ/xltjbksaTxL9Mxfyxiq//uHvxq3MD9WE4KYA5RXHuSn3r/xhmsou2+wIKwJuIpQ6UWOlXbkixYgH6gg4GVGJD9+iNCBDnGUBugzssLZAvJverXgF89IcrPvKCsD+2iKY1wPOsIC18Q2yT7gu92wDub5r1fE8PqES9RrW4Zh4rYl0lXm/r6qsaAiurmgYqBnzbgd8qajWUPXtI58cPKVyeW30AaIebiP5nIAxzkByMRX2xXjvuzxLwaK/a9Oaf3jj8m+/S94/2cRd/gnctF7VFyf9mU2xUMusZQmoeWUOJlsYm/kbMS8/OuFjIVfVVFxv76CHQsmpfEaYvrMhEl0WriVEcn6jSKqQxgPuIxT9+LkK+xpsIv6PFn8yuS383ZGS18Cdxu8+zN1gF7JH7en9+urcW/efHCo9s0SMfR0vHbXtERRe+tV1H8pUyBpPZjdR+IUnwLjE/MzWmxlGPKIEHENHcDyVYg2K+9T0J/iIVp5FZbdEZXjGQkUt84cYx4BlvfMqd9plL3PtlAZaIfLxl9uy9nqcxEEGUgxskeBjXQrDFmbP4txxntBJD6so1ePmBJeb+2EmSgqxwHtdHg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(8676002)(40460700003)(8936002)(186003)(5660300002)(81166007)(356005)(44832011)(2906002)(15650500001)(83380400001)(6666004)(7696005)(4326008)(70206006)(70586007)(426003)(2616005)(1076003)(16526019)(336012)(26005)(316002)(110136005)(54906003)(47076005)(36860700001)(508600001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:10.5905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8bff20-dedf-42b0-1ff4-08da1c7bdaf7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 2c2a104b777e..4c26b0d47d76 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -258,10 +258,16 @@ enum avic_ipi_failure_cause {
 
 
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
index fefac51063d3..6c4519db3fc3 100644
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

