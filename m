Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA15269645
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgINUUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:20:14 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:16225
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbgINUT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:19:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPKr/0XsYwc75ivqZBEnAHRHiaZ6UCmCaTuofcT++5j0veFTmPbtKBQKG3F+Eh6LYB0EF2LPPyfcSJbMk3iwM0orHiY1C6kJDOutuUy+/CeNmz9DcE8rkCkwCYuO40lZbD+X64UIlFrfZ/vafZUERI5ZnQ0RzNU9SITlS+eZqjHxKU9EtP137ktYrfwOyYHl3A0F+jZIukaa9TRaTl0SqQ7l0rhr0XBfoxY5gzrcYpnL1EYkrqZ0mha9M59Mc8VQY7v4Bn7g3s5vXfJZBxB5ACc59YCqBfK8FB4qJNkDs6+nNmVotjlga0Az02Qy7ZwKWHVwMzDrkYonsDwg+XZiqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KR65iSw/H1Douj4v4mXpHnY6Z6UJeYg8cdJyUNEbB7c=;
 b=To3XC3w0pkCGZwH6ZyvXELISfDplCtvPR7Wgu+1FmAUYL3dYQoyqXBEyCwam1REERstcRUnbnnNCAhzEtU2V/DlKMNaZmWNfgb6dw72wfN85wMiWghW4nlB2sooD9/Km/C9wvQqDwKlPhMMMQ8/u6Yj0zuNJrVm5yGPnhGGVE7gtUyZg44FEqfCEUOBa+co0+R+pu2IZXxEPlvbA2BlHFeybxJHphbSQ+SMeLnyqUK9TJe8hN9Af5ZQ4ThUptekKezL9ny97iOw1tR1kWmctqv660TUBJgLgJIykY5pBrfk5YXFCus43veaNX+c1UJsu4Y0cirKpBSSUVSOeZIwOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KR65iSw/H1Douj4v4mXpHnY6Z6UJeYg8cdJyUNEbB7c=;
 b=2Zx/kgLqlueH8C2st7mNe9YTerY1fTP3nbzlE7y60tuI2m6RfD4zhI/AtCE3pbDx+na5KAdRNU11/hEPK7qDGLG5I9E2LiyBFKHlDRxMBXKcaI5a9n6QZubmLFqpCPFYoEUUTc6sjwrZyGQgP3OGLRxwN77bXQ+vANzMZER7ESU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2828.namprd12.prod.outlook.com (2603:10b6:5:77::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Mon, 14 Sep 2020 20:19:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:19:19 +0000
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
Subject: [RFC PATCH 25/35] KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES
Date:   Mon, 14 Sep 2020 15:15:39 -0500
Message-Id: <e08f56496a52a3a974310fbe05bb19100fd6c1d8.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0042.namprd05.prod.outlook.com
 (2603:10b6:803:41::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0501CA0042.namprd05.prod.outlook.com (2603:10b6:803:41::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Mon, 14 Sep 2020 20:19:18 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61b11bf1-53a3-4919-bd61-08d858eb760f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2828:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB28284A5F9B068D734854CEFBEC230@DM6PR12MB2828.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWa4QGDe97mSUpJjJu8yg9pOLyGz8Z4S5EPvX920OvsuWBaNkcVksUUi9Tfv2960y76ZUeHk7qml9ViZx7C8Be6Kza8sdN9jSS9aiVixy66odSRuYatrjMbID/zeNjo23wWO8XtvYgrgnZSTvyPjsZCnVoo9RPo3aggcErfQwqTaBq7l11QQGyjDK7oL8gtpercj0e3elVoHdthd/QTD742q8OP7msaWxE8XoVEhKitE75KM3tNcAcSdId5JSGLoODx1+YgXTe9heXs0JJYEaLuqQNR8wyEH5fW+3LiFzFdLy5sRkzomzo3TR7RTlAIYl7lTn3Srv6RyXpZLRfknHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(83380400001)(52116002)(6486002)(478600001)(7696005)(956004)(4326008)(2616005)(6666004)(2906002)(316002)(54906003)(16526019)(26005)(186003)(36756003)(66946007)(5660300002)(66556008)(66476007)(8676002)(7416002)(8936002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zUIzAqucUmoA6ga33H9p7hSuxDYZWZQ1E2IJ0yRrxnIoz63RO7wd6tctwdFGYxi4VXU7XJCm6UUSgrXY6iI12eumdKx7iylIG/W1TEe7DPkAFeLlsa9zTa7cYJJOsUHK3WqNIHRVhTwCbOVsEtXZUPW2Ps32MxrDmJ93jWUMIwWn3QGnSfwRAcZSCM1PXfd2Xp4QsfZ1doVMAMuhXgK1/6DBeUD5PTpVID1f9RRtlwNeRuQ/acMyUk7YpqvshPo03DtlS5Gj+yKM7AY7gZATi8KdrzZdjDz+YIzCV31l7YIG8Erj0o7Ll606PpRfr0G5IUDNUDcigJxjEq04nkAHfDSJlBtWG8lVbDheu0tuideyAs7WNbrEcyr7h7MOqpffgL+WvQRLu5fVlENmmU0vMn4yVF+GxgQVB7btJkUWAncxHIBko10FNIVplkruamIaQ+ySfP6hPCKs1wjbmKqvOI0d2LLeiT9AKmxW1a9/Von7TBfmyc6QZHrUHSl944j5ppmWwDl+2oPQoTG1+rneLagB8sc9bwS7S5pGCrhZRppcisL9drLRRltq4J6zPOC53qmCLw3xo0Z2hBjihDZ5L/L9/KhvVgbGnSM1XKD04VfJMP1zL1gPSy3pJ82gM3GX6kMC8X0bhEc4CvNavkk51Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b11bf1-53a3-4919-bd61-08d858eb760f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:19:19.5976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnFbJYg5K1/q6KBogXXltMJcc0zH6h/6DESUHUQWIZRK8tlNbQ0WWLK69KKvKH5foUmYhtVXyq9wcdu+hJv9iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2828
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Since many of the registers used by the SEV-ES are encrypted and cannot
be read or written, adjust the __get_sregs() / __set_sregs() to only get
or set the registers being tracked (efer, cr0, cr4 and cr8) once the VMSA
is encrypted.

For __get_sregs(), return the actual value that is in use by the guest
as determined by the write trap support of the registers.

For __set_sregs(), set the arch specific value that KVM believes the guest
to be using. Note, this will not set the guest's actual value so it might
only be useful for such things as live migration.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/x86.c | 56 +++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e445a76b691..76efe70cd635 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9090,6 +9090,9 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct desc_ptr dt;
 
+	if (vcpu->arch.vmsa_encrypted)
+		goto tracking_regs;
+
 	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
@@ -9107,12 +9110,15 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	sregs->gdt.limit = dt.size;
 	sregs->gdt.base = dt.address;
 
-	sregs->cr0 = kvm_read_cr0(vcpu);
 	sregs->cr2 = vcpu->arch.cr2;
 	sregs->cr3 = kvm_read_cr3(vcpu);
+
+tracking_regs:
+	sregs->cr0 = kvm_read_cr0(vcpu);
 	sregs->cr4 = kvm_read_cr4(vcpu);
 	sregs->cr8 = kvm_get_cr8(vcpu);
 	sregs->efer = vcpu->arch.efer;
+
 	sregs->apic_base = kvm_get_apic_base(vcpu);
 
 	memset(sregs->interrupt_bitmap, 0, sizeof(sregs->interrupt_bitmap));
@@ -9248,18 +9254,6 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		goto out;
 
-	dt.size = sregs->idt.limit;
-	dt.address = sregs->idt.base;
-	kvm_x86_ops.set_idt(vcpu, &dt);
-	dt.size = sregs->gdt.limit;
-	dt.address = sregs->gdt.base;
-	kvm_x86_ops.set_gdt(vcpu, &dt);
-
-	vcpu->arch.cr2 = sregs->cr2;
-	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
-	vcpu->arch.cr3 = sregs->cr3;
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
-
 	kvm_set_cr8(vcpu, sregs->cr8);
 
 	mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
@@ -9276,6 +9270,14 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (cpuid_update_needed)
 		kvm_update_cpuid_runtime(vcpu);
 
+	if (vcpu->arch.vmsa_encrypted)
+		goto tracking_regs;
+
+	vcpu->arch.cr2 = sregs->cr2;
+	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
+	vcpu->arch.cr3 = sregs->cr3;
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
+
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (is_pae_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
@@ -9283,16 +9285,12 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	}
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
-	if (mmu_reset_needed)
-		kvm_mmu_reset_context(vcpu);
-
-	max_bits = KVM_NR_INTERRUPTS;
-	pending_vec = find_first_bit(
-		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
-	if (pending_vec < max_bits) {
-		kvm_queue_interrupt(vcpu, pending_vec, false);
-		pr_debug("Set back pending irq %d\n", pending_vec);
-	}
+	dt.size = sregs->idt.limit;
+	dt.address = sregs->idt.base;
+	kvm_x86_ops.set_idt(vcpu, &dt);
+	dt.size = sregs->gdt.limit;
+	dt.address = sregs->gdt.base;
+	kvm_x86_ops.set_gdt(vcpu, &dt);
 
 	kvm_set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
@@ -9312,6 +9310,18 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	    !is_protmode(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
+tracking_regs:
+	if (mmu_reset_needed)
+		kvm_mmu_reset_context(vcpu);
+
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

