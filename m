Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9042C2D631C
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392413AbgLJRKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:10:18 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:38097
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392515AbgLJRKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:10:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOLUI83jK98+u8oKnGe1xakY7dr48KUar5Qur9UHu6Uam/LKvkiUPYkSnB/2JD7XM1wdLGYy/CpnMZv0LHlHmXlmxJSWnWVGANVZVDqqGpPaS6Lra6kq2VVXum1NPvZeXYnQOImqO2q2ZspNoIpHT6QyNsOQyLQy9hMvl2OntVRo10hf1Ti/Stk0DbLO0NpjneySkRZpPA/O8VrZUr1HC34X+TgBHMt0R5bf7OsqduW07CloiTpONGxGgvY3GcCIdZLvHOHV12muwHCrNYt23YPUm1rV7dbZW+DSJAEM74E1hWyVJ8jYc9IjDdBfaM5uNkekrbUhCtRQua3813szQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNpGrI8E+zoQzAPMKkV6Q6EDhfv6bqXT4aefVvOLq8Y=;
 b=n0ctL0Q3/AMA/8cdJ/jqWB0qLXhW/RoyLyIJP4pGNTJDG5Y/jVOu40vButhnHiqm4UszmkSTu+3HTthg6Xpa4GB4Vox6Hir+KSsqIexh72Foekgkbgv45ry5PO4otXkMHIJEfcS28y6OEpHIkwzwqK46OQxUNt7MvaMm9tgrUDiNgMDLo4i0Cp7TNpxiD2rG/vGFzwfjZYEZhYKxAm3y05cvjr54luL/F5jKUsNy3TvNNm/afX1NNzRab/Rkljr561trI4vWyeX/qS6urTdu9Y+dgu0+l8lGYtJliIS3ry++/XuDfN8MDfyaAV2zqs4CxQf3pFVnxRbbHUcV19ndFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNpGrI8E+zoQzAPMKkV6Q6EDhfv6bqXT4aefVvOLq8Y=;
 b=0LObXw/Awz0iaGIhwvIQFv+ooweHAHkW/XTmy2mYAvey9Sl8JbWLSOmGmI3OdUBjlLTmFCZVf7KWg/kL7dUT9CafSiFoDccEzaUteXM+7v890Vw42k84xL6/3GSSNLkzav/an+6iVrKhJ5cg38676OVX67UzM3KVcGZG/05hb6Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1493.namprd12.prod.outlook.com (2603:10b6:910:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:08:27 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:08:27 +0000
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
Subject: [PATCH v5 06/34] KVM: x86: Mark GPRs dirty when written
Date:   Thu, 10 Dec 2020 11:06:50 -0600
Message-Id: <7ca2a1cdb61456f2fe9c64193e34d601e395c133.1607620037.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620037.git.thomas.lendacky@amd.com>
References: <cover.1607620037.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:610:59::13) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR03CA0003.namprd03.prod.outlook.com (2603:10b6:610:59::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:08:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6ecac00-19e0-437c-9aea-08d89d2e362c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1493EB20B610B7E6BBF6E6B7ECCB0@CY4PR12MB1493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sUD4NtZ/1+jMHXq972kk4+zo5kAOtwkrKddCpsurTGpfT/TebsZ1FVz+0ob/gEEVYwmdulvwF9N6Vvegl6Fv1tlfyJABHU0+PoZBeZK5QlGwVQAlUaTyghbs7sn0d4GH7QRcSByYane98oEyh2dcaWNys73CDipyFhDzt4J9PssCPkus7pbU4jx4PGyymGWO8lJol/o9Tmb1k1TDZznikwfIxpBVKA5ubW7/2hE9yPFCK9SFDhzrQMABt24n15J+hJyt9nOsDQ1IF9zFb5K+AZtwIrg65CDsXuRVUk0ZFjjypAWCPFxldf8OxasAUDXwb/ow+ii2MqQWPCsuls5MzIaRWTAUiO6wydMOQeuP0UHvH1/KVOU2RfpaONjrVsyYWt6zcXkT5LaBQVvTZd7ZPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(5660300002)(66476007)(186003)(52116002)(8676002)(36756003)(8936002)(4326008)(86362001)(2906002)(66946007)(6666004)(66556008)(26005)(508600001)(34490700003)(7416002)(2616005)(16526019)(54906003)(7696005)(83380400001)(956004)(6486002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?i7IAL47yuFq5kkGQWAdWFv+WRphw8lMLvN2aICliUUlUTKo/ZmqHnk9+31C4?=
 =?us-ascii?Q?jDDSxPVhb98c4gy/rI1Tz3FopcgxaY/MKbRVNzzHyeSZUpXrNVnmnAI/AhO3?=
 =?us-ascii?Q?4XszJ0wUWkyPFKNnvwvP6xJc1d1ukb9/EPKaRRG1/dbGSoWKtaQKIruRUejx?=
 =?us-ascii?Q?aLn6bSG1W94kVbSsc+QNvr7sTFjm5hvxOleaE9+XdhOA1L7siufjKxUVsNj4?=
 =?us-ascii?Q?S1yRlwvXHzzCtHozWHjYiBk0PTufk4C/0mYiUA1Z9a2/yXLRRBRcNh+HSAX8?=
 =?us-ascii?Q?NC+aaeQvlInculHizkJDA7nWoECZRryfoEqagEocJyQsiqIGQRok2gD4+a7s?=
 =?us-ascii?Q?V3E5g1yngAwQbCdp1nfovR5dc3cN/dsfqrw7pI2r+LGQdYiR5nSjGtLcdwsY?=
 =?us-ascii?Q?VKaTErvfVVy8utIP3/obVOvkPsZp3cVP2mJ1884IlYiQ+8AlymQEtJNQ8SIs?=
 =?us-ascii?Q?fDNli8PBeLabmVym/Dgp5VBfmU1nP4gvD44TUI1yOrhEhlj1AglQP4b9OgiB?=
 =?us-ascii?Q?VZBPt3aoXBB179CXuDN1db3JqKLSnh8Ma/z7yu3RRipp0pKf2zcNYaDN715f?=
 =?us-ascii?Q?LUsA70ZB6b/UxvbHwm7OFh0JieotzUlW7dXkMSBkIcasIm6jOJFCxsTcc3yK?=
 =?us-ascii?Q?tkv58MSpwGmo4zDQasMePS49OiHlI3BTBdJHI+JWGOm4Yt5z7ZjOBaCp3FLO?=
 =?us-ascii?Q?CC0vsmuIdSEXp2exbK0UNMuKBkbRf5NiiciRJhhaLQS+1Ask2cUQGQ3viWBI?=
 =?us-ascii?Q?qTFM9RHdpy4M4x78jqSPKEX4+FFIrQU9HsLpnSFKU1rZaG+xCBnxrphGINIL?=
 =?us-ascii?Q?CbIdIujpeqY9mpIX96Lx9zC4rle87JhdfZqrYDl8ddrOl0adX+xwUXzaedGV?=
 =?us-ascii?Q?xi+pgvPn4lqY/Pi8A53qKY9DTejomJ6frA7OV15ypDRa71IZVxpEDxmtgTgf?=
 =?us-ascii?Q?sdJIOz+ylraGO1tfGJKcP2cBbLGDSiN7TpuVInXRGiC157R2uZlUcXWP+yug?=
 =?us-ascii?Q?V5kU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:08:27.4895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ecac00-19e0-437c-9aea-08d89d2e362c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CFBPdGDWGeiFNzy3Hgf9c8rjhJNY21sqIHazmLpbAuDpFlJT9BSYPlhtoEa8OCnZcL7LhR1DAW/BbRJmNHmuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1493
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

