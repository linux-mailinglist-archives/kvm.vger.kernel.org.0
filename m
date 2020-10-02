Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2462818D1
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388590AbgJBRHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:07:50 -0400
Received: from mail-eopbgr770087.outbound.protection.outlook.com ([40.107.77.87]:26558
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388295AbgJBRHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:07:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQV8w2pmUwi+UTYcwd8I4kuCIx1BOe1jhVPQshyE6pSQbNEsstXsyl9AQw6aG9UrLc3k9jxmZgrRJvNElQ+vSnkwXjrVs+v2rWkw5isey8GhVRN1qVddip3dS8TC+htyH4kgweEfr9hCBT+DkATQ4z/DKV9d1av41NeaVy7QxU6qPMCZCb3Etm/ylwgi3+5lbs2ZrlCNI9bSI1FkrKeoirz/dZa3Mcw4Df1cSczIAQQJUNu3T9CFungWmt84fZli1KKS1kqejBelr7ke01NmmBAmWDWj1FqDFzAIYlH7AgApsrNHS3r848qBOM9HYLx+1cf4KvkihFJnIWswTT9yaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tr7+PK29WcBTY5TdJenpgTfVVmdKnj+9cNPt+rt8nGc=;
 b=dDI6VkhdEBDkus1nD4G6JZ4RtDpEdk6GKKMToaD/3J4HtRKRjcqo2ndQrW/PQQAPYqFDCna8Nh/YDk22X1IQptipqcPlQ9cwfuwSj0AaTwDfnvvA7e8XLUIlFI6E0EG2o2ezGfWUEfW08Da9Bjq6/C5aM8pyH/MtKbc1V6USSex4qV4q9Q64DzrrJs3zopHMLQG90fwD7Xdy5Rv3Kbo1uUcBQAuit2izacN0shtdf5aiJp3Uq9GqG0w3LnsR+v4aUv+sPb0lGScm8F9x+i/3RoHB0FFZAgKppLro9Cm5fJr8ImuRCBeCTPAIL3KRLE2iuWBAsBe9LO8Y4+xYVCoxmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tr7+PK29WcBTY5TdJenpgTfVVmdKnj+9cNPt+rt8nGc=;
 b=QuOsRib+kTz4xZ1iFmhxreNVE4eM1D6fGUeVXL6/TBB11AElYH8dE1L7I3D52hzq0R/j9g/e1bf2WZApWqayA/Gsq2CdCG3WhRva4JIA633aIo79lscV/1VzUdHXm4diJ6XP+zr2psU25O/eEHCN+saZo2AzKWmizwgTuOgkSYY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:07:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:07:46 +0000
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
Subject: [RFC PATCH v2 33/33] KVM: SVM: Provide support to launch and run an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:57 -0500
Message-Id: <aa7c1443b61df6ab2d3b5f4deeaf9e9925b65469.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR02CA0128.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR02CA0128.namprd02.prod.outlook.com (2603:10b6:5:1b4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38 via Frontend Transport; Fri, 2 Oct 2020 17:07:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1821dd38-200a-4baa-7f6c-08d866f5aeea
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218909161FDFE9991CFCC94EC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MGUymbzQo6qxeTeva0j/64AWewv2OvT8RrKr1pusF178xT2ToDLE0wiC3gsz2sSFKc4FhK7c3uwh7H1IEIlCPJOvsbbH2gIDbZZW3Qm0MSD1R6Wj+uwXYNX5AVWEYbbhGKcYRrxOySHC+cf4+DTmTKizg6w6hPjK2tQNp9hljs80MjFnvKsQ+fUZK+Uk6rXTT0tvdYgo3KYaafWkD8k48F8kMoJ5y1eE4ElYmpXQTh7KzPoah6/HvEJgRJp9xm+shXC9qE3pb5wzx4dYqanXhQwz9t753quF7T+ognOr0tB2LSzGIqYtkih1Mf7itruWmcK75o+zMV31Pit7wr79Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fseGMTQqW/lUUjh+ms65UoN0IjhvsqDkfkslZ3JfsW5XBrtp2AhyELt/GAjfw7V7Up659J3qM2d+rvESJR8IvVdzFKwWCQ8OLAGb7GZ3KKgyQByAeME9bTTv55RN1Z/Jh4YzoNyxqZrUgTiVbgLhYBOoG5e9S7fEvjNpj03E9TAyDJkd4uVDDBXLmK5EPORsk6j4gA5Bb2v32avnpDVw0M4udcLaU5We1+2qFNHIPHHGp/bs7xSXVlqm/JTJ4UAMqQtwGOs+4TonKlLx01G1CL4sI0i7ZjGjuD2XSadcfepBvw6Rts6Dfr4hTdh3MJyPA6vhLSROIU/C+ru9elX2dKVrbSjdbJy4UgHUS289n36IrrBdLgaTcjHGj8yzexk1fMwoBacEpWn8VG5SX+dRBz87VtKKwEADucW9M5Q43VfAXUpwsEm7Mmlj+Xg+GWzdUh42fKDZ8X0Sb4ZMENC+tUWJY9C/YTaoM6rKLCgaGQ2umB9+qzm5sm4NraKCM3ULhTtryNF3SWslqCi8IfObTh3Hr4cHBaCVPT5uC5JxwHXyvLl+kBe1k0PYMayPbph1DVevZrZDNn4x45pdrWspey5xF6wsf9VY32+xyTyHI32WwBxd/qoOVvUUWYiENc8Hls/4sQVkSxVvCzM95l7A2Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1821dd38-200a-4baa-7f6c-08d866f5aeea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:07:46.2768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kuyyzp9qByWpCl9QpdF2Q1OYKYXaIHEhuE6PFCOuffoEuvD85U91nRJPBj/Q/98XM/D/EL4pd5mY99g5NFoagw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index 6be4f0cbf09d..db8ccb3270f2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -202,6 +202,16 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -500,6 +510,94 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -957,12 +1055,18 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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

