Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6781C7187
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgEFNS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:18:26 -0400
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:6525
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728058AbgEFNSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:18:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaiveEjBBb2NP5972vQSN42xFJnTtjJtah2sZSiawn0Pu1+9ygmTSPpdV380CajAE5n0hWCSVTtACperjgq456nB0NZ6Rgbzs5TXzEuj6/hqIdh75k2NaCQ68mpBy4v+DXnyK5bO+Q0BR3L8HeCsbbHzfyl4ZUkX4kULjGGbzByqUFwrp29isFnE04jKVjmoJ0YCYBipyrNopqrPhGv+J8QyOQ9cVMFynVhkYZHFVv6VAL6rDqJlmJQDu6g02ctBSRK+0Vug+y91n7yUtLXXIazdA8BgFPa8oE7Edbg8du/pVSEEVrZBxVAQNXWqEAqw4u5Bo34sET+BnG2zTWgk9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCN90VEGSaDcFGSY6+1mmQr2KrSwEV3suuKpMuPANYc=;
 b=XveEzeYihtd6o8PqHqCbz3g+m1Omjpl0Tbb4aTEE7VbFJGCmRrdYDhDhT6yDoyV0VLxDYTa7gR5q81ovgXHejlYK7MKUPygbMq3Zg6O/3z5Gpdn5lOV/21bzNydeEurNwpUjfXSoyJUbinL2rD+etedgvgKhhyUWYd+6R+fRlkM56SZaqh3rBqaZJNNWET5IqkuR4mAqPH/rnEw2/0g6mYAaP3AROu0LA7HmMd2Jumvaayt5V5iwoLn7skkRph6GWx4T2iCBAOCNr0DzcZl4bPRkM5ymCshRMTUV1aRPJM8Js90/BEQ0mjFu+B0e5DWRTbKgSlvjoww8hQbQ3rsOdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCN90VEGSaDcFGSY6+1mmQr2KrSwEV3suuKpMuPANYc=;
 b=OdcBtE/MpW4i67axp7OaIAz1mwWXZBc/bWoj2pCuZMOACgAgtrtCyA8/jAAGei5C0zxEJR/7togz8iFzMJ5Z3+X9s8wy2MmcqkgO4bvuU6C42XVSewBSqp7yaVajueb6vadsb+fBIpP3ANlwuIUswtx0jF9YIwQ8ORn4BYwOpBU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1258.namprd12.prod.outlook.com (2603:10b6:3:79::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Wed, 6 May 2020 13:18:15 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 13:18:15 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        mlevitsk@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/4] KVM: SVM: Fixes setting V_IRQ while AVIC is still enabled
Date:   Wed,  6 May 2020 08:17:54 -0500
Message-Id: <1588771076-73790-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:3:103::33) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM5PR12CA0071.namprd12.prod.outlook.com (2603:10b6:3:103::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 13:18:15 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1526ccf9-c622-4e32-b1c1-08d7f1bfef83
X-MS-TrafficTypeDiagnostic: DM5PR12MB1258:|DM5PR12MB1258:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1258FAD688CBA73A89995031F3A40@DM5PR12MB1258.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JfkGFSfkAnWCW3eLMLn46k/9al5E0rV/zrRLHVtAz68xvcdDfla4jVwK2LZvQHKkuhE2WtnoLxZ0UpkHE/U2Avu9RrD7PmPEgdBHWcFh6PoBgRH+gKDfUIPaiGqbG97UxYbCct5lto3uLOLjmYcu4Cyabn9kuJaSo3MqFySeBqWJelWsqLegDAKEmTQ3Nbsi87D+MkVGZIxCGegXVHkvrwIGY7xQVKl0IUcI68U6DiU1xT6jLKil/BhxXd88X5/eE+cK1chIf31dEYzEVx4UYarSSOXNBYClnTz824JhgTvUVKJaiKb9DdqFcNXa3WDevZ6PTAxTPwTyatH66p77S8ACqhSgeQv2yXlDJUQzo5yPGGlxaqtw9cvZ/MldFdpS+TwFNnUvsVcWQ6Sr3T6rX0KUEwCXOzNJqB6XuDoSnM/szL40g2WZnTWO+MEWTeIU0re8aZ959DLfx019kwHYk6p7ZPU2vnFVtnqf8JFyTSpfdkiQ9L/k0bFZFoit6pyIPRBDkBFG5zziAdIatxxRIN1DztAW23WHRWuGtVPb7kd48xJuXRqS0grHE+pK3vXeg9YWWqyYPSgLx6GdM5TK2rdBoULbJXnesdyGJe/rYhE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(33430700001)(966005)(5660300002)(66556008)(66476007)(66946007)(7696005)(52116002)(8676002)(478600001)(8936002)(44832011)(6666004)(2906002)(2616005)(956004)(6486002)(86362001)(316002)(33440700001)(26005)(16526019)(186003)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GJPE93vQDM/N1VS/FcSr2qV0QXfLdYVJq576lTWlLtmJQG5NW096y7M9GrbXUUXBfaZ0hREIyttycqO9yBBMsvQvYhjCCVZAVeaNoFHCmDpmGGt4OFvSbvF13juHSO1YbgOPfoQavwHieiVvxQ579oHm8nOSSIheZckhUuhZfMloo+QCD6qvkAhNg3naLQHfzOGdnjk5dSe0+tfG5+8IsHSHIeC7bOEx/XZoNorkUe7h8tCM142/cLnbqHzyQw99CTXa2ZybIHFVJgEuy+p9m2uaYKXHHCaz29vdVCOwSsc7O5xkkZnrYP1r9qypSD1+ajntqSR4+l4wkk6fDw5tZa0Gz+8Oe6ZWvQ5JIXLgNotHtm8f8hjlqOsXCpygXxMT1yK5bGiPFKXdcNVWZnWMyn/bxviPw+d5QhEymZIaizmwHXsmBmPAxBCNqaulSo21VhUBOYFx2zBUmn7zHlyxV1/MwZsrQu08q3YjaH6HMkCiRGLvxms/WygthBBcb2HuzMRSWNVaacIbPMe4ZHAXpLfAQ13Kb/EFVMiY3cAlOGqjitBHlRdSg3l0sl+vNgjC0BNbe0GinslVEe/z2aecqGbZdF1+WMHLgqH+lNbHy5lyXUSBeLQe9x0joJ3wZoZgERO65af0t8+FFZs/XK6rwGCxKaAoQiu89jfxF9QC4VkEPJKU7SxQcbEqjRVizD7dC4/JGhX3C9yZBSZTK0XBTqewhX+wjGH4smfiOux9OIwLpFr+yhp+CJCMWGC/ZLyZH822xVDUfpqrRV2jDZ/D7F21yi+qClc5G0gs6cFrKNQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1526ccf9-c622-4e32-b1c1-08d7f1bfef83
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 13:18:15.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oTOyIaFmG4zfGg9j1jNCWHXVARFRypxKRzdA+MM5/m9AHkZXiw0cq57TEVgDyYaY4kzjcQnJFlTtRa7UoHvHnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1258
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The commit 64b5bd270426 ("KVM: nSVM: ignore L1 interrupt window
while running L2 with V_INTR_MASKING=1") introduced a WARN_ON,
which checks if AVIC is enabled when trying to set V_IRQ
in the VMCB for enabling irq window.

The following warning is triggered because the requesting vcpu
(to deactivate AVIC) does not get to process APICv update request
for itself until the next #vmexit.

WARNING: CPU: 0 PID: 118232 at arch/x86/kvm/svm/svm.c:1372 enable_irq_window+0x6a/0xa0 [kvm_amd]
 RIP: 0010:enable_irq_window+0x6a/0xa0 [kvm_amd]
 Call Trace:
  kvm_arch_vcpu_ioctl_run+0x6e3/0x1b50 [kvm]
  ? kvm_vm_ioctl_irq_line+0x27/0x40 [kvm]
  ? _copy_to_user+0x26/0x30
  ? kvm_vm_ioctl+0xb3e/0xd90 [kvm]
  ? set_next_entity+0x78/0xc0
  kvm_vcpu_ioctl+0x236/0x610 [kvm]
  ksys_ioctl+0x8a/0xc0
  __x64_sys_ioctl+0x1a/0x20
  do_syscall_64+0x58/0x210
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes by sending APICV update request to all other vcpus, and
immediately update APIC for itself.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lkml.org/lkml/2020/5/2/167
Fixes: 64b5bd270426 ("KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1")
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/hyperv.c           |  4 +++-
 arch/x86/kvm/i8254.c            |  4 ++--
 arch/x86/kvm/svm/avic.c         |  2 +-
 arch/x86/kvm/svm/svm.c          |  6 ++++--
 arch/x86/kvm/x86.c              | 14 ++++++++++++--
 6 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dd84085..e7115dd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1503,7 +1503,7 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
 void kvm_request_apicv_update(struct kvm *kvm, bool activate,
-			      unsigned long bit);
+			      unsigned long bit, struct kvm_vcpu *except);
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 54d4b98..a007ca5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -779,7 +779,9 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 	 * not compatible with APICV, so request
 	 * to deactivate APICV permanently.
 	 */
-	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
+	kvm_request_apicv_update(vcpu->kvm, false,
+				 APICV_INHIBIT_REASON_HYPERV,
+				 vcpu);
 	synic->active = true;
 	synic->dont_zero_synic_pages = dont_zero_synic_pages;
 	return 0;
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index febca33..c524081 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -305,14 +305,14 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
 	 */
 	if (reinject) {
 		kvm_request_apicv_update(kvm, false,
-					 APICV_INHIBIT_REASON_PIT_REINJ);
+					 APICV_INHIBIT_REASON_PIT_REINJ, NULL);
 		/* The initial state is preserved while ps->reinject == 0. */
 		kvm_pit_reset_reinject(pit);
 		kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	} else {
 		kvm_request_apicv_update(kvm, true,
-					 APICV_INHIBIT_REASON_PIT_REINJ);
+					 APICV_INHIBIT_REASON_PIT_REINJ, NULL);
 		kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	}
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index e80daa9..4b1574e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -594,7 +594,7 @@ void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
 
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	kvm_request_apicv_update(vcpu->kvm, activate,
-				 APICV_INHIBIT_REASON_IRQWIN);
+				 APICV_INHIBIT_REASON_IRQWIN, vcpu);
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f379ba..c2117cd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3502,7 +3502,8 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	 */
 	if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
 		kvm_request_apicv_update(vcpu->kvm, false,
-					 APICV_INHIBIT_REASON_X2APIC);
+					 APICV_INHIBIT_REASON_X2APIC,
+					 vcpu);
 
 	/*
 	 * Currently, AVIC does not work with nested virtualization.
@@ -3510,7 +3511,8 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	 */
 	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
 		kvm_request_apicv_update(vcpu->kvm, false,
-					 APICV_INHIBIT_REASON_NESTED);
+					 APICV_INHIBIT_REASON_NESTED,
+					 vcpu);
 }
 
 static bool svm_has_wbinvd_exit(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df473f9..8f69ad0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8083,7 +8083,8 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
  * locked, because it calls __x86_set_memory_region() which does
  * synchronize_srcu(&kvm->srcu).
  */
-void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
+void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit,
+			      struct kvm_vcpu *except)
 {
 	unsigned long old, new, expected;
 
@@ -8110,7 +8111,16 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	trace_kvm_apicv_update_request(activate, bit);
 	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
 		kvm_x86_ops.pre_update_apicv_exec_ctrl(kvm, activate);
-	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
+
+	/*
+	 * Sending request to update APICV for all other vcpus,
+	 * while update the calling vcpu immediately instead of
+	 * waiting for another #VMEXIT to handle the request.
+	 */
+	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
+					 except);
+	if (except)
+		kvm_vcpu_update_apicv(except);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
-- 
1.8.3.1

