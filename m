Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FEF26968B
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgINU1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:27:50 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:56449
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726048AbgINUUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:20:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcWfW7Xxu40/AdSIuMoo5wZQcwNRm1msJzc/gKytm1OqCv7xoBVpOj1Z4aXCCUqVpD3huXP4M2qbcduZs6cuKJbjczfkk57AlWW2bjMIcepyoJY+wLNJFtqBZFWs6RC2P4xUkVBCeRXIsCtEysLwUqM7BgWfSwtn7QLaveiD31HkaenkuLMmglZo5k/aswdm1+QraFrwHK6t+pW/xfupLl4SX6boCojvWhKC7nUoivN6OLy2OttGXWE5cZLAGgpnD0cq3tPGDoEvrd3Ao2lck/l0SWvgx6iYNKD6uEqxvEOX5DnWj2LlBFiDOmIRj+GWVZxg+CbqU1ndIVf3KIW1Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCFwC7skNF7LPhLoCU8DZb5CDciLp3xPg6AZz+CB/Dg=;
 b=WbVdsK6+aVS/+RI+4ty3PaFPPsDzjqOE/TR3NUGwq+/SPEedG6Wd/SJ7qozZnhC5JxZVaH16PIjnkzi2rE+nX0UzJVdZBWPYrPRadFedqotR9NGV9bmO2wmqH6y2KlfmTtF/Amgb93QX4/WVjT3/sPGosG5Dzq2ZN5jgR7O1Gz/aJMolChwgZUchUUEHumjZawlnaSlahbplF6nTJF8AYgSKbc7YhzCQL1jYDpN6XSLdjOYJ3e6LEhfLNhMRumn5pglpqKrPRjRaZpiffaOgD7MA65yyX0Xj/bOlnOhbK+GBTd/FhuRw/yc17Wj0H0+p4wsGwfq6q6y4TWMHqb4uTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCFwC7skNF7LPhLoCU8DZb5CDciLp3xPg6AZz+CB/Dg=;
 b=xbf6cTzm2BqXGwNxchvvL3MwrhsqqvzZRCKKnmO4oMxxML4g6Bj25InQ+GipAdJHPbmOfea6tDcD9ETqtqRpXH5iDG0uznmGrKmPLjU2rtqAHCgEsix5Q9WZYqrbhOoPhpHIVLXzTw8iSkk6CZhjrxwexHXT7VKKQbLa8wLkQyU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:19:28 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:19:28 +0000
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
Subject: [RFC PATCH 26/35] KVM: SVM: Guest FPU state save/restore not needed for SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:40 -0500
Message-Id: <ac35a419e395d355d86f3b44ce219dc63864db00.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:806:a7::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR10CA0017.namprd10.prod.outlook.com (2603:10b6:806:a7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:19:27 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ded8d0a-b333-4457-63f6-08d858eb7b0f
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2988D7C98586B3DA86EC6395EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zhF0dkFrPocVATIrOgwCjMQ82nA0bYZJjKT4rilJpO4k4r9X9DAdE5bOSuEy6w9eJIDE22m9oeSfr4qgM4LCEbMqUC1FAd6utGBChYwb99piXlFXcNtF7xcA0fU3NaS/OM8lrXgIwysL7+tvGvtPc+flKGZa31ZimzipfGrbFJATp7l9iUwP1pqlQsvTcgljZvtXhUAaNfxLHjJnchnxqUXsGOoNQbitrHgM+/BbClwjCBHHJQYAD9Dk5j+014uHfyl6dtjIMKM328RyhNcHXOMOG9pFIcBCYL0B7rK50FcEPlDFhR1W8MOnqmjMd9VTeyUc/WraRbMMkl8FhS8rlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cpaFE0+mb6n/mAS3wb7fi3N+VP9eRD23rNR69hwscwPCIdE4bZ6f47aGgu2PlDvLW1fcEBF2Dryy+ysjQnVvvhNITSFkTuwefDMQJ+HrwFzgREECQw7RNvGoy/kRr4+xUHCntSAFuQIcKV4YYCtAQQ2NhiyTU8rmKOitXnR+0c05gJIVRgg43fIn1/do3sDmoa0wRZ/KsfifniOHK/IkdOzNRdVBx292UgulF9neZLwU2BgGUFe9U32x4Ms9RNyYFwPkrrC4HSp2b/redqbHfeGh/+9UHxWLI+EAgxhdhtaU/cnAG0okSOH9kttSei2uQqGmlz5EEXdvqGfn4S8GQXGxF5okwBA33JOi749Y2K4w/lA8xlJn0hcBYG3geJvJd4o7zMBIKW2HceC963URyq5HpywPR2hfLVWvKHnXKNRWbxlsX1x18fASUxpYLY2TIX/LLBSOp+8gxtvpXgrBdkQgYfW+bq7XvoOGErURlXUDW3sshJzmBgtVBIh7h57S/vlaVnwVLioeXUT9BjhHJ5H4LF/ir8sISfxAQ2mzTEWKSJQPgtJsXywJl8/ERzjZgD+UI22tnfiOd+++16plkR0MMUHvhZ8PtRm7x87OYdr1TlYbXtQIzWzJPjzx19dW3e7Tdq8TILU6ivwaqzEzWA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ded8d0a-b333-4457-63f6-08d858eb7b0f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:19:27.9829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZzp1oKQwF7PbmDk32jbl6jH/hZRf2R9xahjSEp8XXGpv66ZN6Mv1ebMNXAG5QfIfPTdN9QsJ06a/g9IbQO+RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The guest FPU is automatically restored on VMRUN and saved on VMEXIT by
the hardware, so there is no reason to do this in KVM.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c |  8 ++++++--
 arch/x86/kvm/x86.c     | 18 ++++++++++++++----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b35c2de1130c..48699c41b62a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3682,7 +3682,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM);
 
 	clgi();
-	kvm_load_guest_xsave_state(vcpu);
+
+	if (!sev_es_guest(svm->vcpu.kvm))
+		kvm_load_guest_xsave_state(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
@@ -3728,7 +3730,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
 
-	kvm_load_host_xsave_state(vcpu);
+	if (!sev_es_guest(svm->vcpu.kvm))
+		kvm_load_host_xsave_state(vcpu);
+
 	stgi();
 
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76efe70cd635..a53e24c1c5d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8896,9 +8896,14 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.user_fpu);
 
-	/* PKRU is separately restored in kvm_x86_ops.run.  */
-	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
-				~XFEATURE_MASK_PKRU);
+	/*
+	 * An encrypted save area means that the guest state can't be
+	 * set by the hypervisor, so skip trying to set it.
+	 */
+	if (!vcpu->arch.vmsa_encrypted)
+		/* PKRU is separately restored in kvm_x86_ops.run. */
+		__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
+					~XFEATURE_MASK_PKRU);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
@@ -8911,7 +8916,12 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	kvm_save_current_fpu(vcpu->arch.guest_fpu);
+	/*
+	 * An encrypted save area means that the guest state can't be
+	 * read/saved by the hypervisor, so skip trying to save it.
+	 */
+	if (!vcpu->arch.vmsa_encrypted)
+		kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
 	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
 
-- 
2.28.0

