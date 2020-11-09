Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085132AC88B
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbgKIW3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:29:25 -0500
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:12870
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732202AbgKIW3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:29:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWGkRTXzYbTpNznCClm65qHc/YGf/m/N7AWyWbwafwn01Qzfmrne6OoSENBFSxfY9m1MTqZfStzxA2Eo2J+mJZfHoQgMiw/ml9km/ZencAQnV9naKlpnvNlGIdOGzkmMYBTTRWTMjfVDnVR4jkU28sak0RIYMmIjDYxYAgpdNiwpvhgyFKBOMK1KHej+KXr4aB3AjlrAwSMCxmBI4O2kNMjs8cD0ZOFMf7jlvOOn17EKztx1y5120LlhyqJPjeHlvCo7u06HanY211ek9STRQaQ/NDH2ymdp+qHQTrRbdmf5yif7lMqA5vxb4567gQfMnTB3TZCUdn+EBp3jVMm1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3t0ooWW/AWxc/2KSuTFESC9pIwdiik+89jb0x0EjKQ=;
 b=abVJGaV/tG/jcRtES+cg+2PgpEKWibdDEMwfgVTofkzycEYvj59I3R1elqFrIs9n17m/cJfnKj684J16TyzYhj3DXUe0PPa355z0BGquedejAJ7gVk9z5WigfKW+4sTZpVuznetAN/tsSLW+5ZnteEAlMsegHBMwUzpf6E6OCbRd3MLwy2CLGLjCcmFPNWv0GP22slic0AnIZ0wDSXoo6FFDzzW1MA9nn9dAuvJLA6a54ex8RO630r5N9/uSIka3ccqwgLdJ0ITjnDQlhJvky0k3tQTAi3aUMOrrFXKmSCK+GMSNRXfbI0sqx+OL9/gTH+gwwF3zb7+YhuBfm7jtIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3t0ooWW/AWxc/2KSuTFESC9pIwdiik+89jb0x0EjKQ=;
 b=sbJLrGARE1X8ySD5HipgzcwNEtcKCys2L7iJgpsuYoISFLpnCEP7SY4WvsaisIUyPWupKopxcL2fYS3PuAlXZ3KLYTYb+JjgS9wLHsS6hRThXQGfvd0gx/h3/4sju40xGZa8OOlD2AQqdh+O3QlTYON3cFErD62H1e2yUP9jCJI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:29:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:29:22 +0000
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
Subject: [PATCH v3 24/34] KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES
Date:   Mon,  9 Nov 2020 16:25:50 -0600
Message-Id: <50a37267707383d4950adea65063f2c9365be44f.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR19CA0052.namprd19.prod.outlook.com
 (2603:10b6:3:116::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR19CA0052.namprd19.prod.outlook.com (2603:10b6:3:116::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:29:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee182507-4e59-4b6e-bb55-08d884fee7c6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058D26F814EBF16C8B4990AECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gLId/4HRLWLBeq6DqIEMypHPONqMRXe0SqfaQULGwqYjhICvNHBRR2r+8U6OYrP/MfMITJ/nKLck5R1PY3mSkoRkuD5XotS/7IQEkgX3Z7IxGcjUWu8fQfRVD4XYOq8j2lJy7VakHM+F4hywGPQlKQplyH+KANOOj6JppcLzJG2/WzbJP/w4Kgy+c2PhN58TbRqEhQLMv0N1wZI+FpTTl2F40yj251TvyEOJftTXIeBPtmlVtMYAgfzHY6B5lnik6H9yT/Vng9F33rkIDQwI5ZeBSfp+rT10PUknkVYONzdlTziYyUQWgUe1pJI8F92OkaJGFB68GQLXHc8q42rEBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(15650500001)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZtBgSWuAN0rOv2oo8l0vemINkdafUqpJ/krld61A1AkCSrw+u/MsIe1Ev2S5QPj/qA43/PO6jwKFOm1j9s2gEM5CiH86NKEfP81ar5abrtpqDo2WUYJVlPD3/pSABqqxLwAZpy7cAh6JqXc33SUdJYg38omGQBWE5ZbPFsZPWp+2aj0TFncbeErVKF4HHk4KmGw27QfFobjwxY2Mc3WYISTjJKD9dd2YaspEAt0BcrCevEoNB162H4HRbkIkMP7mc6ttb7u1YAezHNDpEbUootMh3ORx2n4lKBFEpSGAilSkNqTxb0QPnF73ozzCmJpVZRPpSMxc3yV5furBtPd0+2Q7lg2tIz0BEEIw8KsbjBkjN5mz1Vhu741T9Lupr4De8ZycEJpAL9Aj4uB6FDyj/wh7Pe+QiA9xTLxKvz1lUKcIFnqxa21mKCl2BFPgfwTq40rMaymPYAPjmSY5ssEvUCl5RHusuXfdgR/ka5ObyXUiCWvSUnAqhKH4hN7F0vvwdz8KXmWiSqII9nmx1RX4ZxsCkjqyyCnAKWUaI4bPF02OYkC9mFYn2pmWOar6OnQhbzeFLphW4UeaQmxePhXWexERY2BxgRBA0NJwpFSt8p4vRnPtf2RKAbtAj/6iL0R42yS+HaLUhbojJFzYdrWdMw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee182507-4e59-4b6e-bb55-08d884fee7c6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:29:21.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZOJX+61bREMtMrl6bJ2UL7jQSisEZkB19qJhiiOin9XCkkTLUtr7+A1MdNeW3R/7FYwkreFlPYwngyKNuaHhXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index b42bc0418f98..647d9e47195a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9432,6 +9432,9 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct desc_ptr dt;
 
+	if (vcpu->arch.guest_state_protected)
+		goto skip_protected_regs;
+
 	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
@@ -9449,9 +9452,11 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
@@ -9590,6 +9595,9 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		goto out;
 
+	if (vcpu->arch.guest_state_protected)
+		goto skip_protected_regs;
+
 	dt.size = sregs->idt.limit;
 	dt.address = sregs->idt.base;
 	kvm_x86_ops.set_idt(vcpu, &dt);
@@ -9628,14 +9636,6 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
@@ -9654,6 +9654,15 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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

