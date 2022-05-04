Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A884E519848
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345480AbiEDHfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiEDHf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:29 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E414167DC;
        Wed,  4 May 2022 00:31:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aORYzBtYeTw43NxF/pyGrOdUCmbUr3aqHhE9VmQOSjzgpN1oYdzkgTtbzsFKTl2i9hojci13jRIujS7VszOCSA3kBtpfQkAcuZ5gOGaRNPrUmFI+sK4TAGH1W+2l9ywNeLmNAzd1RDQSAKbvtEpS1RuGYHcA3UOh0UEY0D/6RMPkrJCYHBhZie9OKfr30Y2C1LgBrvimaWoLnP9LqLoQGtnDkoiOM+4RafjTFpBAKl0EUvJAKY0NlNV1P0flHaqin2zNr5PodLYn+diTbGDm5Z5cO5jlXM1APlcreA02Fm2NTcv1YAFadZkBGFYp2h4i68yt43ARGuK8JtH3yQlGrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUwb6mBBN0KdHYBzaBuzqhj1XLsjUZTpdqob3bf9pHg=;
 b=ERtUpfUJV+EyjKf2CcInOdFRYF4IQSPUxqaPY9IbJQqrnv1g0yLk5aCE7ts80Gm4hamiaQTav/3MYIfFU/faEQQHoM5BNeYtrCM2qc8M5Pncr7WZvy3bVMzyEQyxtcdQtb4z82oYu1GXvkZSyQXr3BCV0X2EbVqqTUiKdqRDdg8rVxXHYqdGBJ28VHjxDx7hVEkaKw2YgFhjeGDQRGCxQIqXz+aJGJ85LP24pIxf46ybtJDNW4gWvcBHlUeOaWHE/2rkD9+CO1gwFVg0nxwHSOHa4N4+l8RreDHpExs6nJMDNLrFwefLraQzJjTNirJgB3+9Iu//nL8d7vBfsqrW5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUwb6mBBN0KdHYBzaBuzqhj1XLsjUZTpdqob3bf9pHg=;
 b=ksrm2fXS4LEv5dpEX0fPMv5S8t/PJEO+C7cNG1nwlS+F706YPSxUfwkGTP0P85KmGPflf1awS7uJHwvdKEPTUazzFTSu0vM+KGJ3ZnkfnJ+kipyOiHn3VbstnEB6YKEvhn6WEcxSsUj0VXDDPDUrTfV5ND/KajZ98VBzY+pDxAI=
Received: from BN1PR12CA0020.namprd12.prod.outlook.com (2603:10b6:408:e1::25)
 by DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Wed, 4 May
 2022 07:31:51 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::aa) by BN1PR12CA0020.outlook.office365.com
 (2603:10b6:408:e1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Wed, 4 May 2022 07:31:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:31:51 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:49 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 02/14] KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
Date:   Wed, 4 May 2022 02:31:16 -0500
Message-ID: <20220504073128.12031-3-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 978bb809-0e5f-4ddd-c655-08da2da027d9
X-MS-TrafficTypeDiagnostic: DS7PR12MB5743:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB574362BD6568027BD02B967EF3C39@DS7PR12MB5743.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8SkOCX9D4A8+j6+W1Lny73/JyljiN2wZBXtXxbgla+7+J/f09JuEZZbCzn2+tFLP4jJwhVfKVZ1NINCuzILtgsH2SIcUBMs3DGkAeYXAMYv+xwRNymHOaIbouh7huIlox6qimu3cXGtdXmmA2oJ2+TLMhoFCTB9yIIrgRJUaobr1a71buqyxm0Oq5hpUga6ctbAEOn6jBF4MEkkzyoRJX6dGAXw6IQU18sgRGftsqLbPIlPsYH9Y8GI5UBFsbqDsUkG9if39T8/SpMkwxwILDxJAeQnoIuawk9WEr8ZbRZ90AbG3i1Sf5jLZ8rzQITPKKAvW78m290oPvzN597GcPWgkVc3X/iFzC8s0QfZlTD8/a2GAacadQCH9RWBD9KfnkmYj67n+3GrsoqShU0JpZb6gv2n84ZrdEbcpYM6pJV/lh2sVMMJHLSPnl8BJEqSGXc4e1aiwAXQTILb0WtpkVT9DbgGtmUSBp7bK3ZB2tj1IJWzSxwyyYDLbXNcGwXIth9eVQ84XgY4HjndNK6J7XCJbN/PamrZNfqA3b06v28FDC01ub0IJNJvCybvGdZv5BMBAM52glzW8+2HaQisJKuv/1JSqon4CAdboLOD658cPXvQ+BFVV/Vf31Et31EYMoA3oh+HWDtG69Rou9UWlJSelvQh0BLljHiwGsxXaCuqP+SLKH1E93Ry41+b9c2IW8xz9mUje+W0ZoRi8d9c1Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(40460700003)(426003)(336012)(86362001)(26005)(186003)(82310400005)(47076005)(54906003)(44832011)(70586007)(16526019)(110136005)(83380400001)(1076003)(8676002)(5660300002)(70206006)(4326008)(2616005)(316002)(81166007)(508600001)(36860700001)(7696005)(356005)(6666004)(36756003)(2906002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:31:51.2166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 978bb809-0e5f-4ddd-c655-08da2da027d9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To signify that the macros only support 8-bit xAPIC destination ID.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/hyperv/hv_apic.c      | 2 +-
 arch/x86/include/asm/apicdef.h | 4 ++--
 arch/x86/kernel/apic/apic.c    | 2 +-
 arch/x86/kernel/apic/ipi.c     | 2 +-
 arch/x86/kvm/lapic.c           | 2 +-
 arch/x86/kvm/svm/avic.c        | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index db2d92fb44da..fb8b2c088681 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -46,7 +46,7 @@ static void hv_apic_icr_write(u32 low, u32 id)
 {
 	u64 reg_val;
 
-	reg_val = SET_APIC_DEST_FIELD(id);
+	reg_val = SET_XAPIC_DEST_FIELD(id);
 	reg_val = reg_val << 32;
 	reg_val |= low;
 
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 5716f22f81ac..863c2cad5872 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -89,8 +89,8 @@
 #define		APIC_DM_EXTINT		0x00700
 #define		APIC_VECTOR_MASK	0x000FF
 #define	APIC_ICR2	0x310
-#define		GET_APIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
-#define		SET_APIC_DEST_FIELD(x)	((x) << 24)
+#define		GET_XAPIC_DEST_FIELD(x)	(((x) >> 24) & 0xFF)
+#define		SET_XAPIC_DEST_FIELD(x)	((x) << 24)
 #define	APIC_LVTT	0x320
 #define	APIC_LVTTHMR	0x330
 #define	APIC_LVTPC	0x340
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..e6b754e43ed7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -275,7 +275,7 @@ void native_apic_icr_write(u32 low, u32 id)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
+	apic_write(APIC_ICR2, SET_XAPIC_DEST_FIELD(id));
 	apic_write(APIC_ICR, low);
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index d1fb874fbe64..2a6509e8c840 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -99,7 +99,7 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 
 static inline int __prepare_ICR2(unsigned int mask)
 {
-	return SET_APIC_DEST_FIELD(mask);
+	return SET_XAPIC_DEST_FIELD(mask);
 }
 
 static inline void __xapic_wait_icr_idle(void)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 137c3a2f5180..8b8c4a905976 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1326,7 +1326,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 	if (apic_x2apic_mode(apic))
 		irq.dest_id = icr_high;
 	else
-		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
+		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
 
 	trace_kvm_apic_ipi(icr_low, irq.dest_id);
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 54fe03714f8a..a8f514212b87 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -328,7 +328,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 	if (apic_x2apic_mode(vcpu->arch.apic))
 		dest = icrh;
 	else
-		dest = GET_APIC_DEST_FIELD(icrh);
+		dest = GET_XAPIC_DEST_FIELD(icrh);
 
 	/*
 	 * Try matching the destination APIC ID with the vCPU.
@@ -364,7 +364,7 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_APIC_DEST_FIELD(icrh),
+					GET_XAPIC_DEST_FIELD(icrh),
 					icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
-- 
2.25.1

