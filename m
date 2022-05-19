Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070FB52D075
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiESK1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiESK1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDBDA7E1B;
        Thu, 19 May 2022 03:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvN2qGBoNmt5E50xPwyTpW/aLkR2L6KqKZivsrWzsoQ7MN2W0E0u2nb/DTqhOBaJaacJ7cq/BtlDqp8aC3+ZrYEuWOOuZ3H3GyCdiEou9HfLy93xsK9Q4rebNxHWIavXzWbPy+IP72ZNNAyoiv82AzLFPcsX3TqZ3m2IiggJ/qctf7G9gYgFQ/tpxLDR8JpvUdBiHRlnw201fAGVlsqT2vtLWai6e1DUv9ngeDA1ddib33bmo5VZ2rNmpJlYB8UBNV70Eabp8Ea7q2iGvd4MhJKCYuiOA+nMcpaukmbGlGQwL1iPSnf0lRmzijjyzsuHqrUmG+IV8BeTpPQggjOXnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnglCy/xPXrLNOnm93nCreZT2JM/mgwXu4AHQzkO224=;
 b=HkV0DUhW57ViXd9Obcn4XaUSjPsJbwQSXA5pol+3zu3/uCesQa/QyqPhb1sbJqPDKJDPWGGLLKV1LsKj5PJce7MYJ9fCCy72+Yr7OxCTGr42+eY+Q9CjRI4Nr7rlfK/YY87XGKWw2ocwgeRWFxI6PoPwUeQV98Et1AfViqkNPYYXPNSsUNYSR0o8jMTT9UPsSoDQ4OwIFvhb0chnKCjcGaqrFVopKVRcbzzXmQaML9jG8zF8IHKZdXYWjCyv8cfO7hT11LsCJq5y5og8La0GSo4U5PY1OMldnb9fHbKMUgmEKSAcJpPmTfbLvqfMd5/kyfHWiKB8BwTnvxh2GUY7DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnglCy/xPXrLNOnm93nCreZT2JM/mgwXu4AHQzkO224=;
 b=nA8rVfE92tm2O6IM3fiFswArss5fjMsaze2yMPAB9r3oN3hOrCNiao/pizqmrTGw4uDE+di7kCIZsh6D7jSiLeqbu6RhVNYab/6rWJNXyKW1V3h13ZYgWHXn0ksFYDa+tjSAeQPHK0TLL6omoRWwsI36TXEaIBgLUd488qcP+y4=
Received: from DM5PR11CA0020.namprd11.prod.outlook.com (2603:10b6:3:115::30)
 by DM6PR12MB2825.namprd12.prod.outlook.com (2603:10b6:5:75::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15; Thu, 19 May
 2022 10:27:28 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::f2) by DM5PR11CA0020.outlook.office365.com
 (2603:10b6:3:115::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27 via Frontend
 Transport; Thu, 19 May 2022 10:27:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:28 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:27 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v6 02/17] KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to [GET/SET]_XAPIC_DEST_FIELD
Date:   Thu, 19 May 2022 05:26:54 -0500
Message-ID: <20220519102709.24125-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1178770-6107-43ee-60e3-08da39822ceb
X-MS-TrafficTypeDiagnostic: DM6PR12MB2825:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB28258F0D0953EE33CFE61C4AF3D09@DM6PR12MB2825.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRMQOf0mzvUtxbo+DCCy/O0Fj+2RoqeZGwjFxwJCYrIBkpPUnitepFytToGn8agncSdMI4S9r7HOo0BgJnIjIiUE039w4US75PFreFdnXHQ34PeYtIvsFKHzaM/x5APIuXERAW8KZrr2QjXgp8hcRN6sXsiJ4P0gglmx1lQEmhBFIBuONxzXI65sMjcTHq1xbvLxp3/j7WPmO6wSyPlphcXyYYLpd4AflgOo2PcvtMufCbVeUQRQ9uI1/1V8RWeMuld5bf5ZE8YCopxjIeaFdGKlPzikAJqGd/p18ti/LzjrSweFuq4FS4/JoGdxEsPVJwm+m6RnjWe2uUBqntSxCEB6WujVUnYdo9INnpzz67ChUgdB/Ty/0rrt3ZzEacPIwZv0hJSW808aXtOMo5ZJjKmyxBoIfaXS9q5UasPgZGs3vOKBVQOCi/+zs+ztsCC5FCSxDmAE6V6+tHcn8aYG/YtrXnMmc7V1zV/o/Tk3BJcEEw+E4OtfB6xkEakACzBw/0cL2jyXdifbR7V4noqElopNkkrY8BOhbEMPDp82jvzb7FKzGO+nMNw8+Cp6lUG72Py3nWuPVWYj44BBr64YepBiUbleXbVoOSkY3fP1GMZnvSQvBKveT5DOs7ng2AOMgVfgqyokQ8GlElSMO5gKVpkvaRE+qkMicx8P4ciAXCVzWkCo4n3//HPptiWU5K5hmiDhFR8B6GubJdvRHKuFaQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(508600001)(86362001)(8936002)(2616005)(8676002)(26005)(4326008)(16526019)(36860700001)(1076003)(81166007)(40460700003)(70586007)(426003)(47076005)(336012)(2906002)(7696005)(83380400001)(6666004)(82310400005)(36756003)(316002)(44832011)(5660300002)(110136005)(70206006)(356005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:28.7564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1178770-6107-43ee-60e3-08da39822ceb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2825
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
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
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

