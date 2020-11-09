Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C062AC89F
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732705AbgKIWal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:30:41 -0500
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:17376
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731843AbgKIWak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:30:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEUxWqpbKyRH360yg+UAxdtPW5+7ea+qg8jzLIIAB61fIt3iNQtmPYLFmwdU+J78LD7DxwQW5jNg76T8L8gBoYDQGOriF2r2YNAgXZXpNc5WVnDMN5KaA8SLYqz76SP9tMBWBxA9zLcOahbZEmCWB5mpxi8hwuClRiywbPuApBeLUsPnXXYTS3YsDGrtMlVpx/KPJjXLme6YxndMPZHoEbgHvRSxMpSYswLIdxQlzDCh8zPh1uGzy9lLcgKBqGKzGERqFKWY62taCmhgPX+Ee4zsRWn/T6rMF4NgHbDZieMg/vssnGTcZjIpn4qlDveWBVHcratYMkpj7c4Y8wsiOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkqzaV5wPbm4vaEUZ6Z8CrmnfJBiJnhbpaVRwsZ7GuU=;
 b=a5Kc4528MKQxs6ChTx+FhkdKb+cYJcC9BZM17ZsbsXLsDPNJGu9S7gH2LHWJIo1Ygi2eghp0dnO3JLYmOA2wbzjeqKfnRvh9w9/GmdvwjsFX5tJNbwoCLJh4Dfei39FtbC/fOiLVWG7mDW1Q7bsozRddKyNbGYXex5CxQgb4BOw/2SDMpMdg07XNHTj9XFHcplzibP5SBiTkQwy2APZ18U26+rKgIwa6Ee6Pji9gCT1XCIklXVVYSrqcM9n5tdXTexTj41HLss1MWj2/t7UUJ7mc7Hg5tCyQlwiyApKB7zG5T2jyGik/J7C1/PmKnSBDkmsbnn0KcZPiqBfF4FFuBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkqzaV5wPbm4vaEUZ6Z8CrmnfJBiJnhbpaVRwsZ7GuU=;
 b=AvcuYfc/EEc4ImxKxwl9r6XIRQtawtK0cH39U3dV+CmOijYXd/Q4yW1lihxNM3mHS2p/1t15X4Pteo+K/LlupWkB/E04R5K51RCFj27Wcg4ZiBC+Ef4DNRR+5xb8Y9aXyIeKIYITAXs803nDllFG5CVRuEuw8nMDavZU7/Twkwc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:30:37 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:30:36 +0000
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
Subject: [PATCH v3 34/34] KVM: SVM: Provide support to launch and run an SEV-ES guest
Date:   Mon,  9 Nov 2020 16:26:00 -0600
Message-Id: <dbe26b18be1240f332d342e9b33a11af38603cde.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR1401CA0008.namprd14.prod.outlook.com
 (2603:10b6:4:4a::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR1401CA0008.namprd14.prod.outlook.com (2603:10b6:4:4a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:30:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d119baa1-a825-465e-588d-08d884ff146d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058E74B7ECAB0E2A286058EECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgbRqUBALbfP6/N4yOdvWCjFLadnQsqWlGIHN9JAENSPwkaPAOHZR7g8dLG1iuK0WX2XdqMfHVeU+OIH3hmON5SJfZcI1foSGzLnzRBBgL93n5IVcr6113ZMdu/n8Qi90sig7imPyS0DJBRu77a8bBsjko2DP1XgPaCkJOrQfO+IfJhzjp7GS90tX8YDaIs8dyQgH2BTbzzMK6fZDtXlrI6n8eNvrd2YqzpeYUIMNmL2WaT01GlI5feWZmAtB70vtux7WfK9G18nvNehgPWAHKbyc3ikn+CO+MB3haChq8e2ZkMN6VU1fbGbaOIFvj6jFgcT25i1YmbWJSgk0uXesQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9xI9BTsaeeTvbAW3ClbkakZXbcJMe6FEw5WZqgkTrUrnVMn+6ifwPdjHKDAEEebdq3ZFbaDcsieUAWv+5ImB8ua7Rncu4MPy4GGrFDASR0NsuptzJvinDA+UZHuIh9Nu52QMgw5qEQC5Y6NI+ZCI9xcGP2THqoQys/33aOIxu2tI6HowtRFK1/W/Q8SNQytC1L9a1QJy76oJ6dbIqKP/ATGBTBqe49uhRshAAtVgsyPYtoMKxH8EXiVwvP12VwSBDbhA61x2Nwe98DRFm82pO9Zo/TukjtnHtovPrHPBdbX7kCitqm/PgDQVirqfeblS5VmtuAPdFdnnqL0LCBjcickWLRvq4+swXiiioyHH8V4BUYKqFPtX9Vg+7FZHySV6CYXQFGsEGynZuCVewSWWAaREmpyB0blXAzegsaaJjgiEgiGl0T4vv3da7VbligpE8Hyt8xuQaH5Nxng8yf4v1C6Dgc20B2wct6zMWMw9iYAaYPboPgWuWv1bKpqd/akyKJw7tuA3pzHOIYToedoEOmxuNemu87pOEGfI+NOgzRvN35D78MI4Igk6Yw2ZoREMQzaz3dKuZeZGDv+sHTYn681AM4xK+eq38qyYz4mXhZrytoki86BrH2b9/S0LxolhINWhWmTHYKG108hxYfQx5Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d119baa1-a825-465e-588d-08d884ff146d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:30:36.9141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eitHJD/2YuzsrxpOxtukoVhwHb3CEGW+x3wDW80ILh42mGcLv2krVhAdiyJW1LwK4FCKiswTNXYJ3v1JHukKwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index 235daadefd82..87e1c66228f7 100644
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

