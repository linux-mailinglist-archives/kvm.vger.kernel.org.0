Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7DE4BD3B5
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343644AbiBUCXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbiBUCXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:31 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2055.outbound.protection.outlook.com [40.107.96.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1F33B2A3;
        Sun, 20 Feb 2022 18:22:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJmSxVGCdrlqxImDpDuEQBKSisGegkL/OMJU72c9t0F6PJRNh1TpJ8WJ+2hAbTq5LvIlE1wbJIALIrSyaOuh33Rukg1z4AjP4GrlgWDSWzTqHKx1l/7D0CHUSe4laN5Bk1VfJGwpoYqDzr2mJkTxnLlZP+b+2SRyvvHiwPK3oxYiMcD54iY6mCN1p2JIpAwvdsckes/CoEasFZhTEC3OvDVJsVPxIgg8ismTQF1XoHRppftMHQAiUFMd3IvExNSG/7kgPT4P489Tps9S9S8U12uTBaz/b8riLbk/yqiRONTgR0IpDnNjFvZyE4BmwZdyvr+Ozznoz1dhti2a7uEvpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5+AchF8R/9EBNGr4pc3ejqWM4Y7xsN6CWXA0xqDppE=;
 b=ejhb9lCuyagsrSyMAE3FSF4D0gxzbWL92jEy8uuIQjEa79ILt2gGW0SvvKziZqicPgZ7NvCO8YytJdNCjuWKrND0DWSxaugwLJRkNtjbvoH4HcZ9sN6l+0S4uPgH+YwILy0F8ufhAzqfXcfucUoMizme5zFB0nsgFijJtVpK1d4kqULgR/rZWw9E6aQZc+R9FpqHJfD1q5ZkdSc0YRPMSSHwzxO3jlnlrR9PFos+bti55Oo0ya/N1BEdgcNhEIAnTeThyJkRb00cYHS9MbIV1EKjhbWrPIWQ3qmsjfJPMpDwqoAH4mfzxa8BoridDxqhLR3hhmIxBcioPv4z1XP3yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5+AchF8R/9EBNGr4pc3ejqWM4Y7xsN6CWXA0xqDppE=;
 b=klGNEEYRcBGONMjzgADbUpgGvH0jC7Mqz2PR3wElY6sRnr/qGvuyxead98Op22ASPQf9YdlIkvSdK+V3t0LfNMNlztZQZCxTF6XJftdGbMlqPFaJ715Y4Ivpm2DT2EI72UgFkgUtkwIblddDc9SHGRYENBkvId4SBx8JYUetYUU=
Received: from MWHPR1401CA0008.namprd14.prod.outlook.com
 (2603:10b6:301:4b::18) by MN0PR12MB5812.namprd12.prod.outlook.com
 (2603:10b6:208:378::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 02:22:54 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::1c) by MWHPR1401CA0008.outlook.office365.com
 (2603:10b6:301:4b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.20 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:54 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:50 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 13/13] KVM: SVM: Use fastpath x2apic IPI emulation when #vmexit with x2AVIC
Date:   Sun, 20 Feb 2022 20:19:22 -0600
Message-ID: <20220221021922.733373-14-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: c5c67978-c007-4d0f-e53f-08d9f4e11135
X-MS-TrafficTypeDiagnostic: MN0PR12MB5812:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB58126C1D170268721661DFA3F33A9@MN0PR12MB5812.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1kc2Qd3LeQjZD8fucGmh3NDcld8AP7lvTeUWSRTsUfvQXS2hLKUgIkewR7NH8WwwKEdKljlwL/L6lZKAw1sMAfIOKPKLCpcahn2snI0DkZEcMFQN9164rEbUIP4dBaL93m9E7Ycd0OzFc8sjRUwVLM7jyXFdt4QMbjLlsCLLVwtKZ9xbvWXCJvGP/RZqstWlDOGcZB+FxGJ44ugWG1Ys8X4HG+f52JUJi4Jf5OKS5n386E+PpHD3LviaunlEKehA4838WTgp9194wGmMpiK6zgOsBaEgK6VoHTu80GnQISDqZcBDBSICfmTSGI9VblfITUU12wuwgoXmZnRu8PpXuIRmY04ij98HgdA4goDJkNSIgHEuuPchvG2FnJvn44NBMRpI5/nUw1V619Mu/b4mMmmMiXYLpSqvQvxnJPfCFmYOCbJjqgxUniBvjyzglEmQSQULQPtr1KfrDQ50eQyaRKIw7/Izm2AWRlq+9/Krlj8aRPFt2BevE34w2JBbyZlDHqc423HhbZuzlxwHcs0KSTszsWNM5HAhLLKQAtT+U8Wmaxx73Up4s6bqj/kO6Q7UAWE+VKfMDwZMX8RzwfqlpVMMEoTqtaUDGoEta0AV1zTtJbf56+63d5b9iX1t+QLawgfzv0skHLpO37gAeQgVj7GbTsbM/a3LxvjoUm8ISJ3+3VzL4Omt3y/VHBWrRdT/ayux9CsBWUyp5TT8D08ZGg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(83380400001)(2906002)(6666004)(54906003)(110136005)(7696005)(40460700003)(44832011)(426003)(336012)(47076005)(8936002)(5660300002)(36756003)(36860700001)(26005)(186003)(16526019)(508600001)(2616005)(82310400004)(70206006)(70586007)(4326008)(8676002)(1076003)(356005)(86362001)(316002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:54.1324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c67978-c007-4d0f-e53f-08d9f4e11135
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5812
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When sends IPI to a halting vCPU, the hardware generates
avic_incomplete_ipi #vmexit with the
AVIC_IPI_FAILURE_TARGET_NOT_RUNNING reason.

For x2AVIC, enable fastpath emulation.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 2 ++
 arch/x86/kvm/x86.c      | 3 ++-
 arch/x86/kvm/x86.h      | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 874c89f8fd47..758a79ee7f99 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -428,6 +428,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		kvm_lapic_reg_write(apic, APIC_ICR, icrl);
 		break;
 	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
+		handle_fastpath_set_x2apic_icr_irqoff(vcpu, svm->vmcb->control.exit_info_1);
+
 		/*
 		 * At this point, we expect that the AVIC HW has already
 		 * set the appropriate IRR bits on the valid target
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 641044db415d..c293027c7c10 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2008,7 +2008,7 @@ static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
  * from guest to host, e.g. reacquiring KVM's SRCU lock. In contrast to the
  * other cases which must be called after interrupts are enabled on the host.
  */
-static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data)
+int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data)
 {
 	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic))
 		return 1;
@@ -2028,6 +2028,7 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(handle_fastpath_set_x2apic_icr_irqoff);
 
 static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 767ec7f99516..035d20f83ca6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -286,6 +286,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
+int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data);
 
 extern u64 host_xcr0;
 extern u64 supported_xcr0;
-- 
2.25.1

