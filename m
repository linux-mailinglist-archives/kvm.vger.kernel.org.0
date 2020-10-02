Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F53D2818BB
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388267AbgJBRGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:06:34 -0400
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:54269
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388538AbgJBRG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:06:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADc4bfufvZDxY8+tsrFS1oyLVoJXb2U3MhdOAOqwuOK62qY006fes4eUE/DYBDmDEUo6ph81Qt3zRpFw61zTOA1wX29wyZP2nVN2ZAnqLIdZfyIFttBR26xu+Dz7q0Uj0YSoOWvpAFWpexRO8kCrhOC1h3Lx8/z4QBbPqX+uCaH4GNbMwXRlJ5MZZ96muXl1Ln7S8MAcKXEdP61FOzDg8AoLWtltnrYdfLeweM7VPMrbQP0z2MGK/w/rk/kJJClQ4cqCqI86TFmdwZdeLxpZM0Jjr0mLecKKUY62NMdxgn3xd3uAERHFpdUPPPunRGq9dyO9W9aqechcDmZG1sZ1TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwLT9m3A7VKjYXWfYHNrGo+BsRyTjny+E+CbYW9sUac=;
 b=jU9lLuAZy+96Y51qnkcLkFh0wPzRTSoYUWKL2pHqtk4qntsztIPqtqeppbh9n0Q0eEhuSDw5f7al5NQYMVIZK8S4L3t+tHGzJVoT8oe1t3onv3SbIj5R4ye1+B/Gj0hM4ygSFjOU5ssxFJFQRW6u6ru0aFS6PF2ZLYI7+CM4ZLxQxGTqmIZKqbw5tFuAv6ku64ZHro1dZGJA+w260WP8BvGLQXi8c/uF43ITnBuKDXvEuyGCXZVMCS190Uqh+m+gsmDWh5oPzFhRKzJ1nD59ZVutcR5PoyLBgDuijF44vRsrNS7Jy70ogxAGNDndYn9GhqdXCsnZNB4h1EtflwLaxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwLT9m3A7VKjYXWfYHNrGo+BsRyTjny+E+CbYW9sUac=;
 b=psG81C/WnzM751hlSMRzA4NKpNRV3wHfo1Did1ukTB7nh7yiSgY4U7ZeUakOozsWqu54K5TtG+linrQfh7qRwS7sd0McviPcJDBzyAZaPUxC+4xdbNeHvJ5WHl86QqSkJEP7eegy6UKhDGfVtxKwtVIq26/uwaJyxYXEVncSLQg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:06:26 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:06:26 +0000
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
Subject: [RFC PATCH v2 23/33] KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES
Date:   Fri,  2 Oct 2020 12:02:47 -0500
Message-Id: <e0ea5ef4c8ba9226735437f05db5ea2546f97a57.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:805:ca::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR16CA0058.namprd16.prod.outlook.com (2603:10b6:805:ca::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Fri, 2 Oct 2020 17:06:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12abd91b-b2bc-499f-ba80-08d866f57f59
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218432E0FEE131F724F2D00EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tfQs1VpxnGnWyQ2e/2bGhQzBKnjJa4eJNlZ0bUqmaWw3XwWtjCvTnXR+RYW+a/U7bKHPN1/a907yhIWA2c/Lc4WMtQpxhdGtp2uSM7gdqvKDMT1vVQs+7zoJ/jhXzMlFh0fdQ5C9vY/wKnrDbBRVFcaqxMh+zq+KeJeQ4bCCvft5p0TprrV4YdB0yUPl5Z3dlYHWxLceJhwHdpAwCzLWLDF3wa7iEG6ZRJWmus0mP0ejyg4234A6UCeoHT6BP6umn4KpSR2oiQSjYAagQUwCoNZK1OHiyF1yfSlKYQ4bKGDKwe+64ObvoF9oH55QmXqX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(15650500001)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iv90OPLcrr++F0HEiZb+n0hyuKHJKAYA7C5co6IyDryWSL/53N6nQP7UwFvNB64AVQ5dBknvRG4uIWWkUR7V7WghsW9L2xDL2mVwtQzxQb0zAQVxe7Q/pjkEVZiNgMIhuFilCAsMu7ZIEhwZPgZDT+1qHw1SVBIYLt75HYg4FyRzia+MW0mkkxAfQLsvVAc9jtKexouTDPoFx+7nHkWqzG2lPkz/0Go1S9IJP7Z4mZ1cJXwGow5orufdHT5SGLvFJDwYgeGTNGhka/tCGL56wVIIcbN0gDgC65E2pzqzQmJo3lNvJqxDKyvu1gKmRj/GvbRNiu50DJ486NxxDmhTB73nYK7wBSjpQQpz9VY4N0DTCfsQae6LDFWAhnvLU8idNjMQ+olRntZ/Nm4byVyxw2kzkQ1dnbynUZ0pyA4HVq45f7K/auevdeWlcjYY7SFXWCOlorpiII4l3B/2BgV5pyKvrDmHBbIMuBnee8Y7ck8O2wcoK7Fsu+z3cyo0jTXFYZc8zFQg3pFbwyUe+zy6wJbBAwA5/ez1n1exKQRy6XKbl9HAZJ17sBntCqQ92zNLP0mKekZuCAMtQ/6lmRArsUgxDXka+jhuvSUJlnuTJkCzwLwt612Fo+jDBOCRmPHfDpR92Qq36kEe7o2qx3LHPQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12abd91b-b2bc-499f-ba80-08d866f57f59
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:06:26.4231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BedXGxvxz9S0kiadbHRAgwzmr73vN3lvY5gmVGxQwXAICkw/wfKF2TQnv4LX74gJXCW83EWq3ykQkpTqWZ2JhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Since many of the registers used by the SEV-ES are encrypted and cannot
be read or written, adjust the __get_sregs() / __set_sregs() to take into
account whether the VMSA/guest state is encrypted.

For __get_sregs(), return the actual value that is in use by the guest
for all registers being tracked using the write trap support.

For __set_sregs(), skip setting of all guest registers values.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/x86.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 90a551360207..39c8d9a311d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9320,6 +9320,9 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct desc_ptr dt;
 
+	if (vcpu->arch.guest_state_protected)
+		goto skip_protected_regs;
+
 	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
@@ -9337,9 +9340,11 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	sregs->gdt.limit = dt.size;
 	sregs->gdt.base = dt.address;
 
-	sregs->cr0 = kvm_read_cr0(vcpu);
 	sregs->cr2 = vcpu->arch.cr2;
 	sregs->cr3 = kvm_read_cr3(vcpu);
+
+skip_protected_regs:
+	sregs->cr0 = kvm_read_cr0(vcpu);
 	sregs->cr4 = kvm_read_cr4(vcpu);
 	sregs->cr8 = kvm_get_cr8(vcpu);
 	sregs->efer = vcpu->arch.efer;
@@ -9478,6 +9483,9 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		goto out;
 
+	if (vcpu->arch.guest_state_protected)
+		goto skip_protected_regs;
+
 	dt.size = sregs->idt.limit;
 	dt.address = sregs->idt.base;
 	kvm_x86_ops.set_idt(vcpu, &dt);
@@ -9516,14 +9524,6 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
 
-	max_bits = KVM_NR_INTERRUPTS;
-	pending_vec = find_first_bit(
-		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
-	if (pending_vec < max_bits) {
-		kvm_queue_interrupt(vcpu, pending_vec, false);
-		pr_debug("Set back pending irq %d\n", pending_vec);
-	}
-
 	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
@@ -9542,6 +9542,15 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	    !is_protmode(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
+skip_protected_regs:
+	max_bits = KVM_NR_INTERRUPTS;
+	pending_vec = find_first_bit(
+		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
+	if (pending_vec < max_bits) {
+		kvm_queue_interrupt(vcpu, pending_vec, false);
+		pr_debug("Set back pending irq %d\n", pending_vec);
+	}
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	ret = 0;
-- 
2.28.0

