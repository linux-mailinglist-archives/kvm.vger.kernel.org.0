Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7287E2B6B2A
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgKQRIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:08:43 -0500
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:23521
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728754AbgKQRIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:08:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=latRbGd3lgdUdOMzszcueMjvKUztLbSQTFjBBAV7qBeHIRveHoyoVgzwcCN76rCAfHtTPYG7cuLZFkgVSE6elh1sixW0hV6QBBC/JW+BCWtNaKnGv3MfEKJaO+IL+QQ8jI2CP+Yn5+ztVsSijjspmfGVfHFJwesZjWqTD5E2k1daIce2eajufoLfEAYK4aM0z7lglRR31Nr4KaZ09mrodWz8MQ6gV2jSGgrd+/agYQspiOUADmMlaCZxf4zeFsGRVB1ZJxW0y/9vIS/8FLrPv0jBalsMxlftFPCCFrZ7T3wMMgKYA2d+qvpLWpl7yLpyORNvp+5WlHxK4C6ElCG/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNpGrI8E+zoQzAPMKkV6Q6EDhfv6bqXT4aefVvOLq8Y=;
 b=PWNKRONfyRf8ZPox8zxLVmKZVmMtq2pMzmT+TFyQl7hHVq2Y+NbFM2yz6IYxo4cTXo+jTRRXE/slCJKhYHJi0jI+BTnBhoDxspj4U4Mjq1/GxVXzh6d6l0oInkgdbHKG2z1YptTUD/jIV7AcssvazTEQVlIfRvumXVZfE1jXXwjAZAa1yX5Bfy0tvjd4hd/N70J+X+3OaHRY3TepmUbleiFD6zZgmCxGlLm3Qh+ERuTPkd1p0G6EmAvo/8BAI03MlMKKtilGcX4opYWqtuyqyXbwM3MJ660eL2h0O6VfV9fupBRPL7gzvt+BDTJZ4B4Nj4wPtHVZOEZR+8jUNGPu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNpGrI8E+zoQzAPMKkV6Q6EDhfv6bqXT4aefVvOLq8Y=;
 b=F5mDKM80c8SG9+D/U50l356u08UNdJCFkqjpDKxJW5ZRrnqRZtgdGPpBWweG2I0dn8uTVyrRwg2j4TgW8HihE1/CkIuh07KIxN7tI1pdtNP8Mq82xaGvV1+6ohqXRR7NNBOIacUvL4tfjtq38dSMoJ+bj9uh+R1OJXoJso/1Y7Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:08:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:08:36 +0000
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
Subject: [PATCH v4 06/34] KVM: x86: Mark GPRs dirty when written
Date:   Tue, 17 Nov 2020 11:07:09 -0600
Message-Id: <19e72c9b1a02ca43aef7a359e296646ba8130809.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:5:bc::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR13CA0022.namprd13.prod.outlook.com (2603:10b6:5:bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:08:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4b9249ee-7f77-4dae-b732-08d88b1b6b82
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772E4B377AE26B6254408BDECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nz2LFaKgg+z5NlsXz7rIbVpYH0wLr24Y0aq0VvJqRKWSgwHC2Srfc+RYtz+HKh1rkB9KNnnJKlxtKBQvsiwKt3KLUj3COivwXIaw/Rv17M9aMc9XINAoWMDvURha2/ja0IDnTLABi7gWu04xI0sG8Rm2w1/8I6unX010WgYdY4imGRmZPok9av8+DQejgioQGDC3A7Ca4tBblQdge4ybqadNWojhUxSmP2xvcfppik2z0g6vyhrj5NGRS88e7S8/Fggno4nx+lPK0/BZHmIJYGF5k1vblT4U4bsXMAVcu/uRCc0mIuihxWhN1W3WE1h0d+CB3KRPeb0GgCNAMK/dQWTQQ/zcvxThbIqPemjsG8di6GaQsXqX+r9L1JFSpTPq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aks/LRHLG3V1z6c6KjblZUvgQuGnhdu/FMEbn7ckDezyCpWBwws2U78xD5IZfB4+1W9lzsmxdbsa03mxfp8lnmiLqtCvV//iBUiUAuq+mXcU5tsxt6gzMr9oZeqMdYuBtGkCjzsgcF1+wTsGgA1f/bPsKqVYYc4BsqwRr6q0ejYalo+8GgDIQrr04+3Et9jDstXM+Rdui01wITzCbVkGW5gqR9oMucOMEU1H5vdJgATLrxgluYYSvhe0ds0Cw9vfSRigNd41nRWyLfuTJ79IK7noGqkR+zipkbbWqwupeKUGTPPMBUz3C0pRoGyuCi2euMjJuVaYt9iTztvKI7lenCzUcqJiYzKZfsnoKtT/gEnOLhpQNXcc7ycnz7HnzHXvMj5GdudiCRY8yt8iTFHXmchp7PCUsMgOhF4/SXceC9uSiNAs0inJMzQMm+lhsoWNKV3gISuIh7+rL3axGvWXwG6ljo+Rve/6lJsmD+C82UBvy2Xun5ldYWtGhja0cr9XEAOjiV0mSyQ7CRcooASKEikk1Sc69T5ZTjZ7pt3P8Dzhdw+t/XGPWPMYaNAkLtXc2/2oJe1JfGUhTsx9k0ZJzAbLGne+kxHxuO1MR6TXl5XEde0PgLYiJU17ohsdh89vXaNc7v4fV+nzs54eudTI6Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9249ee-7f77-4dae-b732-08d88b1b6b82
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:08:35.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7PV+iDp8QXe1n3GVSdU4HVxv6sm+zfyz/I9kGkeAqJO9Xe3wjtEHckZX8WRBY7XgGPLhFCo42yBKUH4HEMy+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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

