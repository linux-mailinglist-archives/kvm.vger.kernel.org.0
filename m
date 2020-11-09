Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C908E2AC85F
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731768AbgKIW1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:27:08 -0500
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:38369
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729451AbgKIW1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:27:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PE/liKfbXOitNU2ae5yFjkUBoY7quYErZjsV5TVl562wZFJnC6ytYiFc+pjn7sDJWtrNg3WKU1ttxOn+GZwGAiVSnc+yKPPOK/GKfp6SMLdeexzDOX06Z1CGULzl2l/LEqlT03lkvXNsOZKCnJit7AOSONT6+teZb2M60a3QYQjChZpYcLEvWjxCTBhpHZG8B2fUmtuOabIpA1hPqL2rpeNgK3S9tJGvGdJa6QtE7GXH1b4AixSbghUVvPXUA0bvfGb4JZivJ7S7OhvYt0+KMNCvFkVU3gltC0Vi4OsmypbkqU7mhsqe0ESrAGdRXi0SyagEXjPdK8jeH7OWEmpNiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNpGrI8E+zoQzAPMKkV6Q6EDhfv6bqXT4aefVvOLq8Y=;
 b=P4PhZPmnEnrRHW/+PwGe+sJtylx2gpsaAczlWjZGLAOUFrjMgUrSt9Rs5MZEra/uLE14e1F3dYvWBOJzOCDzuXZWETQgjaxggfWJg05gNd72qX4siXVFaOfh7wxQGLYIfptmrwOulRdxhm6T89FV36SxBfZHz6VqQSLqtlN1XpuOJU77LIZyyvLMS5XVtuoM0xsCK0LJLvAbwbzDQ+GIMvlEpxganRzbGYz3kcUHfUIAphUMRJyOMwuA5bonC6ZGn54A/VTnMR41tg8c44bZPWBvfnvZfT4FOVfOCWwOLVfUSZMW0xJxi67AcC2hvkMrMgvLAWzaIJZ3TeTZIVVoBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNpGrI8E+zoQzAPMKkV6Q6EDhfv6bqXT4aefVvOLq8Y=;
 b=aDuuPxyQ+DG+aAGrxOcc6V01PxjsJKo6FYLFSlD1TovyFhKbSk65qDUMb57e32eP4K+qm4Mef9z3C5x7O7eBxc7wCRogtCwBdn99WdxaSM3hlzeUZhOef8+1ZYYhxDt04GPx7hjBAUx71qjR4N5qavgQhZVWqQWZuQsaXqBHhII=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:27:04 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:27:04 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 06/34] KVM: x86: Mark GPRs dirty when written
Date:   Mon,  9 Nov 2020 16:25:32 -0600
Message-Id: <a3420e28ecbe3215aa3a321dacbb14e24cee30fd.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0049.namprd16.prod.outlook.com
 (2603:10b6:805:ca::26) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR16CA0049.namprd16.prod.outlook.com (2603:10b6:805:ca::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:27:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6dbe29a-f233-4b73-e7e3-08d884fe95cb
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058EA8F61136C288DFB63E4ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eKGLEt5+IvHy8CVIg0EibjssO4q/8/AkDet6mucU7rCWBUohzQ1Jogq5+NXcHhv3g1W1bBL5xqp8CNuxdEjjwfyQls73e82XSopjAEt2Dl5Irzhh6ptqXd5PU22WejwwTYxWR77ah1dckfLV9DxO/jOTh2cMPeQGQHeUqo8/YtFIz7IPa7/CcGRsda4lAlLRFm58+05qRzsZAUe3NWVZ3HOSE8T7r7t4vRdub4PORz9dsOchAT39pteJJn+KE8J/VNaubF+7+ZrVAqS/xZNjwfj/ax8kXpnc34qaV5Sfua+sg3H/uaLIC08H95sCSkZtbv270ENB8b2T45tSKdD7gQwqAlm6OST1SGIt2tSoJZIp/nlZuxvUohwq8cqs1n0Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hp8zNIV0R/W6gAY0KuV1fEy69UtgHKNuwRTxgKyI5ipmCUyt4TW6H4YKEld+WtbVw19wfLnYvkwIlNwA/c+JI1vJkDr41yq1g0ig/GAnkYDZJgNO2c0cq1BmMtByey1StW7DtBtTu80QvoPClERpyzBZ6+EH94LBqY74E5FXjYngWHxTJSzdyuKES6C/kRy+2kazjQMQQxe00V2d9ujex2SsvPDQfEr/MxBG/X28l6oMdXJka2sU4SnkhjRU0BYyf+iQoczll+6d078hEkRu+WcV/nhYO32RUIb5RrRFgYIV9r6uXpE53zt0oDo+i7BhaLMTVLOzGDzS/3jXUubOdH5CqEUkIBgHzNkWMawE1UdnJMpzVMhDNtfhuZzwtgQ01q2ea7Hvn7cnXvI1h8D1yIcJaMCR2zYuMlG8TxuKKSbM6q14zSAV/E6peZrqUNZLPSIqwze36XiOQYOH1prUFDr4UWMM142zjtsB7gZ8ZEaQA7yNyd0rnScsAtBHnhDWlh1QE24tXmA1Ubc3yA7LYQXHyDHnepRydWokAGYdwHCI/fSfCpGsV7qlYhpb8KkfFAxoFfhP8RuCT6r+B50PLU/Yjd7+bKaCyfn6tYm4aZbC+cC+o3dtAb2pEtjIOPQOFs5MGsv7CJH9RAiT7X7c1A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6dbe29a-f233-4b73-e7e3-08d884fe95cb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:27:04.4352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iBTEhzUKSuaqOFpp9z9N3iywFAYvsVrVOdqfI482dsniG/YS3ZsmYILwcMgEtUlC/yJdjTyAmIH52bUL0vf+jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When performing VMGEXIT processing for an SEV-ES guest, register values
will be synced between KVM and the GHCB. Prepare for detecting when a GPR
has been updated (marked dirty) in order to determine whether to sync the
register to the GHCB.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 51 ++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index a889563ad02d..f15bc16de07c 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -9,6 +9,31 @@
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
 
+static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
+					     enum kvm_reg reg)
+{
+	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
+static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
+					 enum kvm_reg reg)
+{
+	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+}
+
+static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
+					       enum kvm_reg reg)
+{
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
+static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
+					   enum kvm_reg reg)
+{
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+}
+
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
 {									      \
@@ -18,6 +43,7 @@ static __always_inline void kvm_##lname##_write(struct kvm_vcpu *vcpu,	      \
 						unsigned long val)	      \
 {									      \
 	vcpu->arch.regs[VCPU_REGS_##uname] = val;			      \
+	kvm_register_mark_dirty(vcpu, VCPU_REGS_##uname);		      \
 }
 BUILD_KVM_GPR_ACCESSORS(rax, RAX)
 BUILD_KVM_GPR_ACCESSORS(rbx, RBX)
@@ -37,31 +63,6 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
 BUILD_KVM_GPR_ACCESSORS(r15, R15)
 #endif
 
-static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
-					     enum kvm_reg reg)
-{
-	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-}
-
-static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
-					 enum kvm_reg reg)
-{
-	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
-}
-
-static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
-					       enum kvm_reg reg)
-{
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-}
-
-static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
-					   enum kvm_reg reg)
-{
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
-}
-
 static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 {
 	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
-- 
2.28.0

