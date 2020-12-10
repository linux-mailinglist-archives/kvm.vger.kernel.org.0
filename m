Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE242D6456
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404076AbgLJRMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:12:46 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404067AbgLJRMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:12:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8kr7HOR0GEFKJIYFeUnp7AUyYCgmMt8HufJRNU4/g8myLn3SDbWPEV+aiZ5Uth4fDhBpw1Umjsn764uFJeZKzfAqK5bL9qHRLQVfbrtPSyx8MnWjd27neFCiGMzTzfhVAC4AocyoxTLUe88vSz7Ye/hjqRHliO0Gz1PE6/uSSQJDoPtD+AvEAtpCNRe4L0UeN0EoeiLxj2qBBUdwh+In9o0baKA6fY6nBjloVy2MeAOoffk3mI8m3Zv6RZOu9Jy5P29XaT61XUJBpxu5POiI93ZMsA2Ki26oPkwdZvmW9FrtAYFV0j9K+nU4nXgI3Iule/9AbMzB83GTo7teM7LCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNpGrI8E+zoQzAPMKkV6Q6EDhfv6bqXT4aefVvOLq8Y=;
 b=lC1RiTWLg07pi+cWXk3XxHGU26IzZOxTJd8wGCh0ALFoHoFaDhR0Vl50PGH+65QKcXXtHNd933w6nao1mMKjBERhEWhBcvCXGPxYc+PocQSiqMqjtuu9Dl7tZGZOIRUwYuOfDaWIjvIZ5beamZqI9FqR4Y/qek6kTLZXnD+pXkCiHtzYJ++s3XwZQKMTRYQP2/bdvzAkYkulDsqe75a9ZGRPDHE0GkqNQ/jPjHzMwjBZaAklUUgkairSrQclRZ2TZ/DuDeU3dwYQZyY64vxnOG7SX8wRB+ZXZOO0G1DLngHXx/T2CBKrhauc4ILb7epV+OZQzCwZvH2Ffthc0Cd/ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNpGrI8E+zoQzAPMKkV6Q6EDhfv6bqXT4aefVvOLq8Y=;
 b=oG5nN/l/m9hpmXfNzWu+AG4Tpm7/zXCVGILQnXfoezzivZ/mYYAMJ0gUvwAgXjVKKMuLTnXL2ptXwxYNfJOEpPPeq6QUn123ixJn9/vZRVHF6wfKlOhcM2raU006PORDk5/Bbzgn47BMai1duBr2BOfHAzXdjNrs4m/pbkSzVeY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:11:11 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:11:11 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 06/34] KVM: x86: Mark GPRs dirty when written
Date:   Thu, 10 Dec 2020 11:09:41 -0600
Message-Id: <7ca2a1cdb61456f2fe9c64193e34d601e395c133.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0027.namprd10.prod.outlook.com
 (2603:10b6:610:4c::37) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0027.namprd10.prod.outlook.com (2603:10b6:610:4c::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:11:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c7499dcb-f2dc-4b9c-17ce-08d89d2e97a9
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149AFE5346FEB5AFAD9B04AECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QVZXdyBclx/patpUSftfXXtfQ0SJqZG/FcYV3CkiGrfA9R9x65b3b73GGsIyP6aCVAXGDg8VS/MvByHflvbgE1KAJu1cEFS8ctalQoHhOuLnI7F6Lni1olJ41XXcqmiygmGUDMIzSUdZtgWtDT317gxjaOZkNDFtURM6HXDuIC+bRFojR7MePcwngpNqyj4DlBt2uoSCVJ/ND0UyQAn9u452eK7ddcPIiSLeX9FVZrvMvCkrbNV8JRjacovUJXL8K8f5lOEAU3U0Qi37gaaWI2/LSvViJlvP45L5o1g4eL6i6R0mSNbU2QwD4U7jYPHfIHu838qW7FYoyN9LFAeXpwJdEHq3wSwznGpOqKsfBQRtMR11sdlTLqKC7frLtQvr24S9fPj9LLeSDqeyFBnDGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p12KSEZymiKGpklUtAZRnBhILFkOEBhJsRBUcr/nh+bm8y+y5333fpmuFdWi?=
 =?us-ascii?Q?/M0knM88+Fdcug/XRQtcTpB2n58/pozSL2fTjh6ODpgsOB7e6fdTtmP0eGm5?=
 =?us-ascii?Q?x0R25QOi2+ZWEVkuWt4wPbntClEEQ9X4bJdghMMt1IxNvcJWfj/lKmdeRtjR?=
 =?us-ascii?Q?JvrE7EEuZdT0FEjiAUIbSPSn9L0aINsPyCQDwub+JjarN+gwYL6CLOqfEHHD?=
 =?us-ascii?Q?JQvH8M/axgfCZjZxRZtE1TbKeTmzD1+Q88mus0c0sO1fDCwYiqgJI7oUtAov?=
 =?us-ascii?Q?KilntZCoPemwPHxBVLsToFCmT+xE2/5Gj/HYK2SUUbCK5M9csp16rUlNtQ+X?=
 =?us-ascii?Q?lIcSxxgCwNX+QlA3DNSRwgvf9Q/YljuJ6OYXmiay4UdYvotmpoJ2QAWD5olG?=
 =?us-ascii?Q?Mvpx/5eu08V4LfiZWtH0bxyVVrhObVjFwmDzN7dnOlI9mEqvUceFi6eOrzto?=
 =?us-ascii?Q?qdlY2ULTZvuRzyzzpzuC2t9NCsKKM0EhNtf5aODq8U6BKEZ1MuFzmj3tRteP?=
 =?us-ascii?Q?cShR1uqNy/97Aarxs0QSoCsMP5s15vEliaGD0EJ06k6s83K0FPYYYmrNKTc8?=
 =?us-ascii?Q?EOpfvnS+OAMbXLdSPC9BeFl4etSRzsgCgnLAql9V8CihoKXEiZTu1M42/eCp?=
 =?us-ascii?Q?vjM8213V6t1hopveJinWkagGgHfCQLUxN6eQs+IjkqupidaEIYuwoJWow/9d?=
 =?us-ascii?Q?53paWS9q+PBY2GTPyT2lYCCkClaitGEMlEPP4t0wK0jZwjfMNU7FF4EsYABx?=
 =?us-ascii?Q?IzeSzCgYtXUUcekC+1AMx2stLUvl1yWVIraNykS64eODADfZawuV5c710eZV?=
 =?us-ascii?Q?v5ckwWlixCGSzA/CQlznXV5whv6H90xZBucfCPBr6S2JVxJdKWJt/hEN4OM+?=
 =?us-ascii?Q?8Wy8l1Bp21sMmLpaTLXIP/caCJI85wei9jsFMcr9j2peG3ZKYlgxz/mcKzit?=
 =?us-ascii?Q?/GkKz/UbpOR8pCwiNjUfbNDTikwUUqXQ5hoqahUZbFiyIq8lBvFm47ii1HHb?=
 =?us-ascii?Q?Dwle?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:11:11.0453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: c7499dcb-f2dc-4b9c-17ce-08d89d2e97a9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HAxP/xSxuwLGn24+IsN4JSFX/oVnwLYp0QRRZuTihYk3lmB3tRig445BJKfMLm5PZdrDPMWZhSofwByCiZSwcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
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

