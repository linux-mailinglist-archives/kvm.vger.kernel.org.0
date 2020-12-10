Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CB72D6343
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404151AbgLJRQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:16:14 -0500
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:9021
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404130AbgLJRQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:16:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ooq9BfjHrTc+dQmCPPFQAi4KPPpPigaFsGA1XJVZ0eqGfuUv2/rMcF1xJ6KVnvL6el0RftgjTd03Xfmcsz2mZFG5ncvRa92aaq6rYDl2LCPXA7vAQOjW2DzsPWnox3XJfxHWt/1IuaoDRcf+u47g2SdMRK9BsYm19b7RZ7rOKhW1skDzUu/MSkcXsp6iCmd2Tihk5Xa6P69naoxnEb+E+kq6EmUfkrnmM+JekQDJ2gRcSXqnL6ooFQcZHcSqYge36uFLG3holGFeCA49yomRT/HmSgyl4H2cK6Sq2H+bYV4XoDoLrPJGpjmTmsAmU4ot9gO8OYxnaIZylm9/GBpe0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZovOgVb0hmJ8DFzpQsLf/kBXrs4YPV44ddXEyTeCt8=;
 b=aNHFh8ybyQ+b5EV1zOsBv9IgFV5HCatSvju//VWDhn2487ESUioadXeXiVt7w5Vi+RZzglhQ4uR9jPq4K9nSf5Ji9nwL2Bq4Mhx/6+GyQnuKGKDBkNCGFKMFjfMsRwpGW8VU2HZmKJ+NhDGYENupTGp8DINhWUY7lMAP9d5Fkqk4ER7BFBYnwGSRUW8Neh25w2AWVkGZQO6XLaMXOXiHnUfB6C2nA5WOy6KsVtBuN8jdAf7wZyaMxe5RCtpFJAQYsjvbgGwIBSzu3r5Q47+s0Ly0ngDsMv2kABWub30u1kDtQ8vESt3xS6zsJK33fXmVVZMwU7Q3HvsuwRa9CeM/3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZovOgVb0hmJ8DFzpQsLf/kBXrs4YPV44ddXEyTeCt8=;
 b=mH6zRnWFJa7fPvZZOpqjyxZk+5g0SS+GdiAuQwi0R9wi/1Pv6O9rl3MqysaexoRsur3xAia8OfnleJJCp0cWys2AwKi42MirOmrSMSchvPCE7fkzMLvnR1wwyiChdtsp1rT9ACtT9mhSVuXS79tHPjVC8qw0m6Xn7u2COh1lr28=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:13:55 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:13:55 +0000
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
Subject: [PATCH v5 24/34] KVM: x86: Update __get_sregs() / __set_sregs() to support SEV-ES
Date:   Thu, 10 Dec 2020 11:09:59 -0600
Message-Id: <23051868db76400a9b07a2020525483a1e62dbcf.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:610:20::16) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR07CA0003.namprd07.prod.outlook.com (2603:10b6:610:20::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:13:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2322ec50-53af-42e6-f490-08d89d2ef9b4
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01492C906EAE40972AADF576ECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bl+EnqDCJSELRssmoXYBlEnI28SipzpCk8ryjOkmiify/RxU/q5SEo1zukBObxG7BnTIzXjuXZNZAJsbcyB8PuvRusq4fNbCVW8ZkoVuQNyafR5EsfH48PjuarutrY2qUZsh6+h6LFvuBKq+k+1NiRHfkSwY4X/wJlI1TQ0pyHYAkbEglbzNOBdkYlxkzoGmMNoiEKT7k4D8h5SxeMSL7KCKGI+cTx44Tk11u9SsrVtjxtMtqrQefexcza0iJy0OPMMKnrIuIj5KZzPagweesUa9hKn7TjtjlpBoVcR1YPL91agOsTVwIukciFCsEg8/0hBlwUgVIvpXoQ76SXDs/VG9EeJlxh9Zd1wKAD9OJhIbjnizovclvNiFX146hDuJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(15650500001)(2906002)(5660300002)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zfPyNqIYKRs4UjHdkf3nJ9aAHbAX8o9AnwwyCTRmnAcrGw/rBi0eZqf//fRr?=
 =?us-ascii?Q?Q0sK6NH/XKWAdDoHcsVCiJHkBxKpQUUddCS/cbGZ9mbw7IiZeGKzt/AnPMqi?=
 =?us-ascii?Q?SBBmW4xw70fBY2IO9npFqU7yVBqjDtcduYTLsdfLZWlp7MYD6ED/7bvvzx5q?=
 =?us-ascii?Q?XrQhj1nJSVILYJegpFXFwViCWeHY9AeGlGYNF5J4SMlP17hMF1ZswZHoSeo0?=
 =?us-ascii?Q?2dhcLUrGjQnt0Wd4swbDv6rJP/J6ZxDUkBlTVfI1mMdtg8ZCOhhs9hKcNhLO?=
 =?us-ascii?Q?Jw+mdXsBe5LPebAj3h5m9Y/MoQqs6JAlI7dRgwBxH5iYlUVZnvLhi3A5+KVx?=
 =?us-ascii?Q?z25sCI+Cqc95FLqjOPZANpsiupWrnq9cxeB/9mEVmIg8mScCdNa6S+RS8+xP?=
 =?us-ascii?Q?y9IgN73JuVM2P7js73EojWvIfI4PYnwxcQElEjddXFQUGwpu3ZT5hdqwQi+U?=
 =?us-ascii?Q?8//S6H6VdKAx3+eQ5u691vDilrR3NmoDeL6S7IdPI9FI2jUnQrHUvgo19XRM?=
 =?us-ascii?Q?RhBSBbLQfQNkoNy+BnLMWoa9aCLre70eUUyb9ngptRqJolqFgH+pYwKmdCh3?=
 =?us-ascii?Q?V4ebU35cWYWSHbkzftwFx6620AhLzT7qIfAsubLeONexALRw54TQJBszyV3E?=
 =?us-ascii?Q?LDaz0W7PyO545gDkOeAw/+1O/GaVwcLvCJ2x0l57oB+ys+lLaf7jTy8cdkML?=
 =?us-ascii?Q?NytuKEwtIWQYWt8meaRvbtK23RUwQKjnmjGX6NsNIXCH3knYtxIdMkD/ZLL5?=
 =?us-ascii?Q?UHYw1frpx9aq1zAHbcoF66UD3fsd/MGOETgRXz6x9AniDfLqx7A4ymby20Ek?=
 =?us-ascii?Q?m+Er6l6kDiZKoQmQC3daeh8LoWglIQq/kYltCpMLoVxKM01+5cKFOTkdi9S9?=
 =?us-ascii?Q?DwM7+G1y5xeS+HSmVXrqAA7Z2qqS0MBLYKD3J4a83kkxxOAJa0KGfCo+RkwX?=
 =?us-ascii?Q?INrb7dHRHK8soT2o6Iy79PZPGj+mMspwxJbrkhVuKHomY+l9QRWNoiDo6Hww?=
 =?us-ascii?Q?m24q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:13:55.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 2322ec50-53af-42e6-f490-08d89d2ef9b4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0SeDCIycQ90Ndz/kS3JlUo8pT1A2/RJe1kBmZLrMXqfXzDfLU5UNuGDnxigrBD+bPZwrWjreSt/maNV4Dab1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
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
index c46da0d0f7f2..8665e7609040 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9446,6 +9446,9 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct desc_ptr dt;
 
+	if (vcpu->arch.guest_state_protected)
+		goto skip_protected_regs;
+
 	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
@@ -9463,9 +9466,11 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
@@ -9602,6 +9607,9 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		goto out;
 
+	if (vcpu->arch.guest_state_protected)
+		goto skip_protected_regs;
+
 	dt.size = sregs->idt.limit;
 	dt.address = sregs->idt.base;
 	kvm_x86_ops.set_idt(vcpu, &dt);
@@ -9636,14 +9644,6 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
@@ -9662,6 +9662,15 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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

