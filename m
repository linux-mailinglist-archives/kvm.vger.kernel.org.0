Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586DF2B6B6B
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgKQRMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:12:45 -0500
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:62368
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728775AbgKQRMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:12:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGXiO1Sw6yKfqWAdFKaWJk1VGo0XzGKqY38MxxaIuyvKzNTipDCvHXOwoHAuask/paIvedBupb/B4qOaj/UrOU7wqP2yjAjRVGMbujxYhzTPKDEn8kUrV2NL1YiErlgK+k93gnDHhhO4JcwGE1PoaOjpK9BUJ96UyfeCbrILitZyC9hJ8i83SsuVZlyteVQRnrOUX0ZN5khEth113+bdd7rE3PWcSGRpCkUG7osq36Ih6d7p9Os6LSU4cDC0NuXlPj+EgRJ3nshAlxHf6WiPEoJv3l1GCIBLn6qQVd3CgMyyImX/ftPZxDu8nhYb+mKp5kHV+KmSa+NWHRqWG98/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/VswT3pXWCkvWU8IrE4vGOPu7VEZmb7FZDaWOIngMQ=;
 b=Ja+/xPJsRpvWg9aAqs/uCOlkZerGBn6UKW0sFIHpqtC/OKrLlscmN4XUfe/L7rW3fds2rJwjOpMDo0iDabODvTLmk20C3dxnmPGYuKoKBs6H4WAL1ntsQ9osfGxNEZpbDKleIktdtmePAKHLxhcfwdSl0U0BPiDbQhhJwo0Cz+SjM3Deazg6MrkueEgyUkGz17MbyyB/4aFRvu9tBfABjdgGwwhNfGncQSrNhrDUSy2ZP8gbBcVNxmw/kgWfc8BAPxo3+nzdfeLfl5uHU0g9ir51YOAw9kGynVG3iDpnJHAr3kpcwmIjr9tC++OJMvAmfU2tfBTVxSh5ynEJkbCTzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/VswT3pXWCkvWU8IrE4vGOPu7VEZmb7FZDaWOIngMQ=;
 b=2rZDly+GByqYltbXvlhZWHTERwz8yybPwZHVMgAvCgkxvlpUiomsGkz2aefoVfFyggyBmPZkmKihMz2oeVF9SXLOZ7Bz3J3dkDtVdSTiV0Ilrnmzx4YkJMcE1qHGFyJKmuGG7d+s5ybCPcpLYLcl+GSFppcLHVGZizLHYgp52SI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:12:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:12:36 +0000
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
Subject: [PATCH v4 34/34] KVM: SVM: Provide support to launch and run an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:37 -0600
Message-Id: <55440503952763bef59d653413396cce5e8527da.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0071.namprd02.prod.outlook.com
 (2603:10b6:803:20::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0201CA0071.namprd02.prod.outlook.com (2603:10b6:803:20::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:12:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d65409ba-6e7b-4bfa-0a69-08d88b1bfaba
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772EF57EA983E1DF79930B7ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6U/xGoNpEOn7lE/9iyB6rSCNyeVfiImo1I+vgmOSYlUJY6lkiLYB73ii9SXKIUXjcVIBW0m9RUXW+negS0NW9Mjrn3G9NVX05scgzZOA1ZAOeD1DKOpBCFWpQ5zumYr1vyXf+oMzvzi28RwPXXb/VUxOJiLq9yBYGJFjmA+3bL0gOPx34L6gUvIxNy/oHKrVuukJ8Hx5fRznIgzHt6CbxiLu/5j5xmFwwfz60OA886jd8Dw2VfhiN2epFJNh1wQXftDkeSzWTRa3q1NjkpbU48qmxrUkwaJ1A7xxeqHxhx+pNz2v2rcX+gbiHKgg0N5lhyOj0+lz7w7llCOJ4J7S0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qLqQBHxsXoYvSKLN9KmZPYevLclFuATSTnqMy8P7okd9x5xny1otMX9Rmr3b6apXyKdmQgkDXkbxWxF624EqjNRkTH8mTo7YQcX+Ooke4CvSppJkRZzHSKZlYHbFdICCq9ugcTdJoBsOiU6dsux/cMJdF9h+oQ4l+Yp64ykstIGd94FMxsX/AA7ZBNVYjXH89NmHy6ToOEglradM7yd0u1laIVd2z1YaUDIeyEUUNcaX/6aeiQeRFyR/julCKoAOJbWHOqGALRqlmVsWYT8zHzl655wzTBqo+lu/lmLOMhf1mSDNpeelS4BJgXB0bqhv1byB+aPt9xUqBh5t9hJgtyWIEOUcfPoC8Fs6En5v4/MYvNH7K07y+XZTFWywdYw2NXKxVgyoWs63fakqGiLqLo5tBtwmnJzpJvLiA/lWxFeYBGSTWKTB9Y/COOjsHqpPdAZUDINYIcHtl6iFJ8aKPLZeJuwbbAK8fxhCp8akHfbAHCR8nma5h7dD84njr3YdWbIApXX0XaXb3G1Cp5Bd+rRqWiBIRO8fXuBkdXRUKxIhA2TH5spekYOsVDLu0q7SMGqrsHjgygLZiLo2tX4h0gy6POkFgVx3eQGOYtemC226byELdSwyaRRR1kbA6Rcz76oOBOV3ofArqst9cZpuqQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d65409ba-6e7b-4bfa-0a69-08d88b1bfaba
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:12:36.4687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxva7Knp91jPSc8f3AukIg8U+H8aa6KvIc6LsXzJBhK9ZwE8kFQ0BOukVHUUguAH+aeKs0Lln4QbGevRGat54Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES guest is started by invoking a new SEV initialization ioctl,
KVM_SEV_ES_INIT. This identifies the guest as an SEV-ES guest, which is
used to drive the appropriate ASID allocation, VMSA encryption, etc.

Before being able to run an SEV-ES vCPU, the vCPU VMSA must be encrypted
and measured. This is done using the LAUNCH_UPDATE_VMSA command after all
calls to LAUNCH_UPDATE_DATA have been performed, but before LAUNCH_MEASURE
has been performed. In order to establish the encrypted VMSA, the current
(traditional) VMSA and the GPRs are synced to the page that will hold the
encrypted VMSA and then LAUNCH_UPDATE_VMSA is invoked. The vCPU is then
marked as having protected guest state.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 104 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 225f18dbf522..89f6fe4468c5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -203,6 +203,16 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_es_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	if (!sev_es)
+		return -ENOTTY;
+
+	to_kvm_svm(kvm)->sev_info.es_active = true;
+
+	return sev_guest_init(kvm, argp);
+}
+
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
 	struct sev_data_activate *data;
@@ -502,6 +512,94 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_es_sync_vmsa(struct vcpu_svm *svm)
+{
+	struct vmcb_save_area *save = &svm->vmcb->save;
+
+	/* Check some debug related fields before encrypting the VMSA */
+	if (svm->vcpu.guest_debug || (save->dr7 & ~DR7_FIXED_1))
+		return -EINVAL;
+
+	/* Sync registgers */
+	save->rax = svm->vcpu.arch.regs[VCPU_REGS_RAX];
+	save->rbx = svm->vcpu.arch.regs[VCPU_REGS_RBX];
+	save->rcx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	save->rdx = svm->vcpu.arch.regs[VCPU_REGS_RDX];
+	save->rsp = svm->vcpu.arch.regs[VCPU_REGS_RSP];
+	save->rbp = svm->vcpu.arch.regs[VCPU_REGS_RBP];
+	save->rsi = svm->vcpu.arch.regs[VCPU_REGS_RSI];
+	save->rdi = svm->vcpu.arch.regs[VCPU_REGS_RDI];
+	save->r8  = svm->vcpu.arch.regs[VCPU_REGS_R8];
+	save->r9  = svm->vcpu.arch.regs[VCPU_REGS_R9];
+	save->r10 = svm->vcpu.arch.regs[VCPU_REGS_R10];
+	save->r11 = svm->vcpu.arch.regs[VCPU_REGS_R11];
+	save->r12 = svm->vcpu.arch.regs[VCPU_REGS_R12];
+	save->r13 = svm->vcpu.arch.regs[VCPU_REGS_R13];
+	save->r14 = svm->vcpu.arch.regs[VCPU_REGS_R14];
+	save->r15 = svm->vcpu.arch.regs[VCPU_REGS_R15];
+	save->rip = svm->vcpu.arch.regs[VCPU_REGS_RIP];
+
+	/* Sync some non-GPR registers before encrypting */
+	save->xcr0 = svm->vcpu.arch.xcr0;
+	save->pkru = svm->vcpu.arch.pkru;
+	save->xss  = svm->vcpu.arch.ia32_xss;
+
+	/*
+	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
+	 * the traditional VMSA that is part of the VMCB. Copy the
+	 * traditional VMSA as it has been built so far (in prep
+	 * for LAUNCH_UPDATE_VMSA) to be the initial SEV-ES state.
+	 */
+	memcpy(svm->vmsa, save, sizeof(*save));
+
+	return 0;
+}
+
+static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_launch_update_vmsa *vmsa;
+	int i, ret;
+
+	if (!sev_es_guest(kvm))
+		return -ENOTTY;
+
+	vmsa = kzalloc(sizeof(*vmsa), GFP_KERNEL);
+	if (!vmsa)
+		return -ENOMEM;
+
+	for (i = 0; i < kvm->created_vcpus; i++) {
+		struct vcpu_svm *svm = to_svm(kvm->vcpus[i]);
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret = sev_es_sync_vmsa(svm);
+		if (ret)
+			goto e_free;
+
+		/*
+		 * The LAUNCH_UPDATE_VMSA command will perform in-place
+		 * encryption of the VMSA memory content (i.e it will write
+		 * the same memory region with the guest's key), so invalidate
+		 * it first.
+		 */
+		clflush_cache_range(svm->vmsa, PAGE_SIZE);
+
+		vmsa->handle = sev->handle;
+		vmsa->address = __sme_pa(svm->vmsa);
+		vmsa->len = PAGE_SIZE;
+		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, vmsa,
+				    &argp->error);
+		if (ret)
+			goto e_free;
+
+		svm->vcpu.arch.guest_state_protected = true;
+	}
+
+e_free:
+	kfree(vmsa);
+	return ret;
+}
+
 static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	void __user *measure = (void __user *)(uintptr_t)argp->data;
@@ -959,12 +1057,18 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_INIT:
 		r = sev_guest_init(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_ES_INIT:
+		r = sev_es_guest_init(kvm, &sev_cmd);
+		break;
 	case KVM_SEV_LAUNCH_START:
 		r = sev_launch_start(kvm, &sev_cmd);
 		break;
 	case KVM_SEV_LAUNCH_UPDATE_DATA:
 		r = sev_launch_update_data(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_LAUNCH_UPDATE_VMSA:
+		r = sev_launch_update_vmsa(kvm, &sev_cmd);
+		break;
 	case KVM_SEV_LAUNCH_MEASURE:
 		r = sev_launch_measure(kvm, &sev_cmd);
 		break;
-- 
2.28.0

