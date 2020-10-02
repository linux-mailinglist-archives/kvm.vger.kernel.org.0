Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4901628188E
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388320AbgJBRD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:03:59 -0400
Received: from mail-eopbgr760082.outbound.protection.outlook.com ([40.107.76.82]:50474
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388286AbgJBRD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:03:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnkJEeXoZDt8W0bUYggI2/YyT+1J6VtUzob3M2qPWdR/uU7Lscveu7te3pSK53YvPlVoVw6ez85JpGr34lJlRdvsXx+spFikcjFTEcclAR2A6fwW1rqKpoZ9mTph5BSyDT+TWXRSLNi4tIxC+oaRi9yQhsiYYk87Ia8cCLRk9qFIRIBqTuE9+gNOO4+7oAmUtEumSpS61sxqyidmPtaZ4xaajAahDHMmK8cV5fz3556PiePL4E8fDAHqYhjjC54vgv63EOMcHkZmPcQPuwH48sB8b88t+sLHP10+9TMfGyyaUGKnCHl2K4Qqh/yUp/WNFqNM7sxtfT3xQR+uuBzZAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYIAMyPta2GWkKi9MUuqhPAqCE1EuLVxP5K5brW+Dfo=;
 b=AE/KbXMbCh8Hzb7MJES927UiWbBumtFyVw2jQF6xZTmUvQK4HMVJaNrLPYaOTZsptIPteukN4bAKddjpCWc6pRalosQ845QXvHaySDx2Wj2KwuTZ3IUsKTAa1eozRF0wydwZ4BCNWcx5nec5JSgupGa6k9s389JVFqiq9p+7667pmC5SR+zFJc2Q6RSU90H33OuP2xgUgLSXVs1KBaLEdJswFu1FwFHBOnfG6WP6SEklZp3fpzsHMm5lxW4cl8641VAjdMH7cLB/Y7p1fWrtDou4n/VY3IZVN1OpfvvWRkhtNaGa2DiIEU/zmWs+YD4e9SHfgavfVb1iUFIdjS59aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYIAMyPta2GWkKi9MUuqhPAqCE1EuLVxP5K5brW+Dfo=;
 b=DLDWsrigMlBrBuEtZbAAQp13Rm+ccYIDXkhsYdlSeXG59wECsefXsCVLUpmT471X97aiy36BYabNHxotrEsZ+t4P3aEUzr4rqHktuG2tI6nUJGISR8hqMINU+AFA2CTERwrPJFExt9fG0ET5OfYNHir2P1pjeW0zP5hwLxokw34=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:03:56 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:03:56 +0000
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
Subject: [RFC PATCH v2 05/33] KVM: x86: Mark GPRs dirty when written
Date:   Fri,  2 Oct 2020 12:02:29 -0500
Message-Id: <bae8164b19549b7e53e547b4194df5609ca67181.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:805:de::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR05CA0015.namprd05.prod.outlook.com (2603:10b6:805:de::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 17:03:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d245cb06-cb59-487d-c8d5-08d866f52593
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1706608955F74E69D338D71AEC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9sxZt22UHi23uk/JmiGdKRQNt5hnKQ3ioX+cFSY1zhuUJa47LIqMcntajo99jUyQTReVKxhi/0fgakIYLc/XxOonv22/wDAkP1BIlhMHWxXfgq35MZ+J7BMwnSA+EhmwMoOT0t6AWruFDCzze7XFdI8IlM0MQBdgjNYfBh2BgZRuGGDREUigXjB+Gbqv1fY9PL8vrpwPCahWOjWCMIGHf8mAvPOIIES9EnRAMeAyz7baEftCC73bh6Zj1lWMXNWUN7oT6S5C0VGh8HNX7C9hpzfuNIO2u+yDRW4GSkGiZGSoCbFkFpX1sFyF4+e8770LikX+mukG3w2hK2++aaqFaLv7N7xLQXu0cNyKIF9RFTtSrUOiJCrGPw+nIXASsHvR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vrHbaF6OsHzlEaTrB9s6kZC2rgUQ+pVuEBnCKbhU5RIk/moSde4K9tY25JnUACbUz1HwEwb0mTK4QxHAnU7+aM8IJVKzGEFjik0bjGk6495LHSNmBdz2KX+JIsaG61eBJAvJifeVKXIFoSe7oxasNINNrhdKoy9uysLd/Mh+Phii9KR5DT3lZerk7oyOcOScxio+Sf2/WErGnOSnkk2DAiBJiTSNCnmnOnPSZJ5lxO35teV6i5OsLYt+iy525ZyXlZT8TPexCwRDWDEJdd9X53wHXuTSOr502da6/kgXw88TEInPAlc12G9NmGNTT2mZv7WrzXivmdf433dFGW0kT9y5XUT2xJqbYh5aOMlcyMEQgIM0O8t5pykfMA8P/jRgYfUeR8Lm1ocG5NVJLewedf6+fmhoYXr3eRq661JuU6MGelEDUSuPTEiwqXh2cW+TmwUrzvV5jubUhajvxreLjBhymthcCuq2YLyaET2AYrSxrby9NdWNTiTxqodPPkUNR4Xb13hgFDzMntAmo6qJIhEm9rtB3EaXmbZ/K0EG8B7XTgY4OxElQ5WCyEaiq39xC4fzZEYD9VLONdkGOYS8nI+2xM2B/3otDyBFeTcHMTHB3R1PP6JH3IyWsPVipp9ZdBRndwwfxJREkcOlzWT61Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d245cb06-cb59-487d-c8d5-08d866f52593
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:03:55.8896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6juE6CZ1scikvrt+LFaDFa7EXQ2p0/Oo8hCg3OTU7GMLYnOc/Qco0rR1I6U5+m6rDIncgDj7/gIkLOxv69sBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
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
index cfe83d4ae625..9ab7974857cd 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -9,6 +9,31 @@
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
 
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

