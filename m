Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05B52B6B4F
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgKQRLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:11:05 -0500
Received: from mail-dm6nam12on2058.outbound.protection.outlook.com ([40.107.243.58]:33065
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727145AbgKQRLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:11:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lt6cpvQ1wJITdcjo6fhWYRSgPeGXfE/N2P9mhtLdNEVvXOa0aC0YPqk+JvB7qU3OPcuD8VKeNzTD7C/DSxSXZdYGfDGWbb3vsnDPz+A8UMLWVa+feNbui3XHOco66cF0RDxzEUrtCcTVgq2iUPdy0nAU4FRALj3i+t2zp9jVxByXP4lEDIcur4yLNixgB2XS/4k6eXfQ70W6EqDgvS7b8+kQJC0Nf8Eq+mqoEsEj2tZ96WkmJ/Fs73sRfFyLvOzIF/Gpi0esd0g38K2w0e++45nIy5J1uc0l0h6qeVg2xFrWgo/bUNJyKfFQDo8cqP7sip5iCIWa/dRxOYQX1Oamkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hg4xuD0QJqcjDNbNObSHN9TvGbwkV9TmYhzWzTL9eiM=;
 b=Z2jGHJVpZAvSUsUkrdP/YjOV7BEDqU90IbHktrZzvATasfa3Dj+x+01n2Ms58VTJ2LkYaKB2S9XKfhuzCJtcUERxQgSMyFoElqVTYm76xqau44YKIea6nCf0nsAaY5Sc10ocFAk3AvrggsNlH+EAwQdNPjwkHnhwcSbt9E7aazln/sN+b3zgaT5+y9YUCuCOxrInsMUV7MeFoTBv8wVAYyLv/EBSqx0e6w7n6hlZ8QK7R33ZVc0FSZ9VqXXPH4fHgNC9ubcRTZ7ywb5tLvaLiuK1fBwqhGlPFiUupsulwGKmqWUAmzi5HOaHN51RVv4hDEqpACRj5TmCppJZ5Q/OYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hg4xuD0QJqcjDNbNObSHN9TvGbwkV9TmYhzWzTL9eiM=;
 b=K/8rhDysMqHAObOwk4tHdylnHh6u9+rcCtq0BPZ+XGjcysqqkzYnoc2ZTSsUWQMZ1cWcGrUp1i5PKcIgSRtotOKcUaN7OLK5KiY+FVAKtYWYSknyQeLttwvity56uFfQM7SUJ6wpil1NkE8pxD4XKEkVD0dlrxJhXlmvsjhdNU8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:10:58 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:10:58 +0000
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
Subject: [PATCH v4 24/34] KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES
Date:   Tue, 17 Nov 2020 11:07:27 -0600
Message-Id: <fb77da2761aae714000d8a23c7c178196f6462e7.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:803:2e::26) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0201CA0040.namprd02.prod.outlook.com (2603:10b6:803:2e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:10:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1755dac5-4167-4814-239d-08d88b1bc097
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17726491BB65BC36CD82931EECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V5ei6dnPTqcElsaqNXUzyHknRsQ/uIkpHJOkeJSyLY3WU+0WyZ1XPCHrgl9BrIAQUvQkQY+02aSUCasqQGT5AJ4lyS7D7ONkvTpmQg7yOsSpPQzmcS6hqPUB7DsUTU4+3n8VgdpdgfWbk62S5CD4pMK0fLBxuDVbMa0HUo0/Elw5aaEhnXbxNGHvG1+HZd15r44dh6P4oAqybtuO1uBkOFnApwdZtKXlgO3vtJqSKwX9GEISEzEJ51z4mJx4ykn6+F7weoA1ZGZuOlhT37Qa0SFVntJkk96vFpY0h8c3KQT+Xk5XnByeKX6Z7FZN7l1x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(15650500001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sjEB7aHpF2MlwA9ccUEZ+WwCloh2r1zEFjB16KXOdysMdp6vpgSrWtDkshnluuc8vci3PAn3nsQigBJg3/sztonCwrnzSUz1O+XwOMYPRsSH+05e1LZRMYWhosFZ5ZkTFWmcNFR4lloTRRTNQvZNVrR4NLAZSaNvjGy8c0EzjeixvgrQETenO4xegQv9q6Ltf4PRNfVdTpi1dvVk2A5vvd9HKtGSHdoGiIuuyDj5B/Pg1DHweZr7kX2eJ+kyEGvAC73kxbUMW4QCCNmX2eBZS2OOo1ioHqQJ1o0rUOlyWZ0YQ3Vlhg+f3+rve0V3COWB6rV219SuH22KeIULuvGIEDq5GKoo/Nmapt000TwXei97B8kvIzg1QfY+9N5wG/aMOuyYlbRucc+BanFinUSpLSf55nfIW7ku8KhhMCQAQ2OBh02yqX8i9dYuxIQ69/3dIibhWZTaH/aCMZx8dSRGFjy5T9v1P4n+CEeP/9rRL1XdJFDcKlNfNks0FsbMZNgFe4fIAoZOip5pXHe5iO1aNcb5hmofsn5HPyxXEahlcFCQALMFUDCDFOqM0KGR/Epa6b4CyenWeCVa19jXWpREvthLImM1dZLH6L3ggY+mmilj2Rbek2Or+rYJJDQR3tEcBJfggdS3X8Pn3U0bANKTgg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1755dac5-4167-4814-239d-08d88b1bc097
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:10:58.7312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toCZvQJ5EB4pqkqBkS0lXDZYQZcMqhA8BzjqItJdNPqEJI8n1wgTjeo69ADe8vWkRgMPsjAFt7EIKabG9aX/hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index 0305a97abf28..e848fa947d1d 100644
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

