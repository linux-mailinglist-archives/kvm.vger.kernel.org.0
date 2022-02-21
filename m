Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D170D4BD3CA
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343587AbiBUCXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343564AbiBUCXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:13 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787EF3C704;
        Sun, 20 Feb 2022 18:22:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qa/SpH0bgnwByqhFccUVZutSpqLSW3YQg0Q5zuwq+3hX1Cr3RacWudi1neSx8v6jMYskEME43xVJp6H04Cb+xgQyEDWig661jIwdmyXndjidxzuVSJa8Rr5qfLKHurUD7Idat409awsMBIikO1ppDJZ2bRHKXolgFefRs8/wnQZxTDJsgcSNxmW74npnx2cCocNReMk+1z5ygiTn7HncgV9utC9xaLm9npsdTI5nCOvWu3NF0NfdO2AySRKicM/jdhWGSHWqXMvIOfAhu6CGU4JYPvmjEt4Zdyy5J6auT6tgxbEXXCwqcoepY9YNMRrVjeceU2wt5TGV7PNpUEnkTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDZZgxbnepXVTbFkhvGIX7DV+z0V9L8wa8YVFoQDpXs=;
 b=bMUHvf8IEa/EEuHi9taePfmXUINLtrNvOCadq6oWQUw/+BZe1KvbtcO1gFv94iLbLOzZYPTj5m4UbX6RdqunIpCx6ecu9X+kTTfBhk6c3Solxsn9JBehjpUrf4g4YChfkMkgWsIJ8ZhUGbj/2fM40qh7Pnbc30WAjVvfLs1XFeeHHzufR6GIndGiZkngqPRzr0oWawJZokXCSAPozmVyMwmLUFnjI9SXvmS7SUDuz65rPgRk/+/zDQJYLhuwEdUlc3M8Qpg/wut+zBnPo19v3ex/vtfZU9YdORplfx7VuVGuuMl9FJcOULcWY7s/XKrT2PqLwAXMzBlIaY1BeEqc8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDZZgxbnepXVTbFkhvGIX7DV+z0V9L8wa8YVFoQDpXs=;
 b=t/wxlHKIE9T+uBTqOGg3Tg1mWU14XB5KNoz/LA7j610gpwanXC6vHs2Qr9QQIYsnTtfHmvtkApnJEtAUAc/a6XKSvFOoVT8hrbbDQVhES0daLJTvwGW0xc7Q1G1EkOcRukK5wWicPzG7V6ZPf5MsLG+02fmJrgDH6P+ybn7OC9M=
Received: from MWHPR1401CA0021.namprd14.prod.outlook.com
 (2603:10b6:301:4b::31) by SA0PR12MB4559.namprd12.prod.outlook.com
 (2603:10b6:806:9e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 02:22:49 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::15) by MWHPR1401CA0021.outlook.office365.com
 (2603:10b6:301:4b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:49 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:45 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 05/13] KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
Date:   Sun, 20 Feb 2022 20:19:14 -0600
Message-ID: <20220221021922.733373-6-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 18e70e5c-7e79-4d56-b3ef-08d9f4e10e66
X-MS-TrafficTypeDiagnostic: SA0PR12MB4559:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB45597D76D51329486D36DAFBF33A9@SA0PR12MB4559.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09eGPDF/d0/D2vH+H2ZSS5zTzOBIsXl4r3zjMYvxCj3xJoO0wJ2ZR5C+1nUe2fj/Bws4NiYVYemM8ng1OUK9/R/GmcDXondsHkyc8nhhKp4cPYXQ1zjOEyRkuBkpJ0GE6FWB4SzTeRnc7rzXVklxzG9fa+WJOiaYTgaeBZ3UG7jazy8T3YAElcosBKwTbx/q1J8w02dOPgXNG8JlduqC4Y7mYGDKYhAOVJw+vcAOUW7tZHVT+gMmDjhnepXrq8Y7Csy1HZVOygBpz6Vo3WZjPoic2oJIeUbR424iP46HAfOqb8tzkZNz/X388uMTWmj0L+rtQ7LG+JnTOChp0hhjHI1+6+oTbZSId3+ITWZUMSxmnLPZ5sJtSfSC7d5i14H2K6dtOqBgoaRKHC5RnO1XQZX6QXwAIYDBamh8z3lQa5xaL4nAeeJbap4GRqBd0NeMZBvemAn4YLNxY8Wds8l/a9oT/u8OC3+g0PEhwC8aiIqxdF+4uQNZ5SKenzyXlsRJ5LtpVTncbPkkXCk1rIasLRXUBThe0GWByv53cDKcXYhMqQyOJVntO18DU+c8B1ZCkcz/tq5ZXRBsiIPKDZln1Cm+zh4YfVHiaZxRz68MtG9tu1rEnOHoBKTOqdzOKN+tQjL3pEQqaWa1wdjIYRq5VzDErrJwfpGdF/aueUoPsCv4CjDfGukjxECrDrJuVy9PfSzQqaPdX2RvawhSf30Jig==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(16526019)(186003)(26005)(7696005)(2616005)(1076003)(70206006)(70586007)(8676002)(54906003)(110136005)(86362001)(6666004)(316002)(508600001)(82310400004)(36860700001)(81166007)(356005)(40460700003)(83380400001)(426003)(336012)(4326008)(47076005)(5660300002)(8936002)(2906002)(15650500001)(36756003)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:49.4035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e70e5c-7e79-4d56-b3ef-08d9f4e10e66
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4559
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

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/svm.h | 12 +++++++++---
 arch/x86/kvm/svm/avic.c    |  8 +++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 7a7a2297165b..681a348a9365 100644
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
+#define AVIC_MAX_PHYSICAL_ID		0XFFULL
+
+/*
+ * For x2AVIC, the max index allowed for physical APIC ID
+ * table is 0x1ff (511).
+ */
+#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0040824e4376..1999076966fd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -195,7 +195,7 @@ void avic_init_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
 	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
 	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID_COUNT;
+	vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE & VMCB_AVIC_APIC_BAR_MASK;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -210,7 +210,8 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
 	u64 *avic_physical_id_table;
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 
-	if (index >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && index > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && index > X2AVIC_MAX_PHYSICAL_ID))
 		return NULL;
 
 	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
@@ -257,7 +258,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (id >= AVIC_MAX_PHYSICAL_ID_COUNT)
+	if ((avic_mode == AVIC_MODE_X1 && id > AVIC_MAX_PHYSICAL_ID) ||
+	    (avic_mode == AVIC_MODE_X2 && id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
 	if (!vcpu->arch.apic->regs)
-- 
2.25.1

