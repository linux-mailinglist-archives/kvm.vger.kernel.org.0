Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614492D6345
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392707AbgLJRRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:17:01 -0500
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:61760
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404156AbgLJRQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:16:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhoNZPZEXYoNZTcyxVV4m9KDcNKz0JlVUEQXCjR/1/YKo7i5N/lEUAbzEcG4OUYsTGwEVhnCaT7fStJboZPszFEP84saaQDKWWoHVwGmxw9RfVbwTsVLM4J9swdC6q6DcwEjDdfs93EHj2Wb6fpSqzNfHrGvinLDAWJ3v1YY4pRXqo+WgOJfiJPYtxHRiwozRsYsMILEcpEbJL2RPXoD4vuGFww21T3ZvSJdh/cm5q7kTIHaqHtviKZHZ9/lBmr5Vd9l395MphVSubLNg/eNqLqrpMkl4iplwMOktxFJ7MQA4+W/7hI4dVeRCKhnoRUXwPun/xt2y4a60MBU213gUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/VswT3pXWCkvWU8IrE4vGOPu7VEZmb7FZDaWOIngMQ=;
 b=VSKtuuk72Bm7xDSvxeKNycQg/dPQsyudVExHmh4SOjYW2rcYfJO8a5aF58jfZDYG7BedcyQsVVPggKa3dVrv6UWxAu4hfl07l38iArjmJ1bB3podYY67YId7udwW9heDoeJVVDWl+72vQDeyQ/xjaM3cDy9Tn6QEXNAFyYk94zczIsDzO58rcCEIkt/+JdB4VwZ8xWufe5tW9VARQ4URFEQozDE2ZTRJmuGWA0Q9l/TLpdvuePHt7nsJ4wDDp0wLQK85K7AId0l9seM+R2codZh2l3MEqn+2Fd9jtGE60FC/hsPhWMKNqlLDG7UzxgbruMPYHg449Ulrw6fd/ZKPOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/VswT3pXWCkvWU8IrE4vGOPu7VEZmb7FZDaWOIngMQ=;
 b=OlcDKDcmKOaHSPuWSRvhxtDpszr7yl6u8i03gLQS/nqJ8I/nLusxmwD+vdAoamoud4UjADp5263Ly/GulYdeEegD+4oHtOswRby3eBWevDC3kFr6mglchFvzymJ56CPpPhPqDCCZBh5W7LhC1E+TULC9aRWhbUnBuiA4cbcQlio=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1350.namprd12.prod.outlook.com (2603:10b6:903:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Thu, 10 Dec
 2020 17:15:24 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:15:24 +0000
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
Subject: [PATCH v5 34/34] KVM: SVM: Provide support to launch and run an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:10:09 -0600
Message-Id: <e9643245adb809caf3a87c09997926d2f3d6ff41.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR14CA0031.namprd14.prod.outlook.com
 (2603:10b6:610:56::11) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR14CA0031.namprd14.prod.outlook.com (2603:10b6:610:56::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:15:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60e466f3-1337-4804-86f9-08d89d2f2e6f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1350:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB13505A8F710DB3054DEF5A1BECCB0@CY4PR12MB1350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgC2ExQdKhEBX4Pr8N/cWZkXxq4ydnR+SN+H2czMWTXhoqa/5WhAUcju9aYZ5gsIIuV6qB43VDF5XkLJ6I9wSbVR0pNckeZLAvch6q6Xs9/N6P7Jc0m6T1KhkaEWMeOonav4FESgTtbOoIpbZHwihy5HNOF+4L0+VRipFKPp7WNIJj+roP6UO3OxSZm2nu8Ev4VOiAsmbDWKhUv2yQ9Z9AZkw0JKcjf4KR1uOEy1oxbTlxDtul5AjpY/xNDcuhFylHiJMCknrOmXrUHb9LyGoIekoRiWnw9dceOY2yYg7OeGS62FNjZd9de6E1f8Fo/rlM4HGFiLrrNp54GH+GyOOwZTsjVCNHTUKHqM+u1GFCZ1Sjl5c9l4hhqdns8kxtrv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(6486002)(8936002)(16526019)(2906002)(2616005)(54906003)(508600001)(86362001)(52116002)(66946007)(36756003)(6666004)(8676002)(7696005)(83380400001)(4326008)(34490700003)(956004)(26005)(66556008)(66476007)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ilUfpCBUk+HrcmoedlK9PB/UPG7wdNDKs3oY6/2pc9SxHAwHXWSdTsnpc0wu?=
 =?us-ascii?Q?TXWxPL3jtrsk0IZq0c1ydoDHWuETS7DdM0jClIgg9bluG8JLwoNH3yPDF9Xc?=
 =?us-ascii?Q?pCWttafC4BEkfCP00y3Z/9uztXv1oEeR9Oj/zHns8sP3ycq84yomh+qoJFka?=
 =?us-ascii?Q?tcKHC2+y0sIxrS7eSsGUimmwtYWJKlAaUhE5gKFWOCPTs3rljXk5kKmRS5W7?=
 =?us-ascii?Q?SqKdCMP34lFXdIk9GXPK65P2MMQCgcntI6Bl3+tK1OB/f2IHtcmjq8emT7us?=
 =?us-ascii?Q?PgmqeQ1l6NYpYeM45XNrZREJwy5fV7UVVo5pj1I8wIqUi6A/mdRZuAso4Y5a?=
 =?us-ascii?Q?luogtOgcmus3pXvzecMOnP3W8yl+jQCuCqA9DCWQKTK3v+5ypGJ6EcmXAVsg?=
 =?us-ascii?Q?l1Z0g0HEL0bZxI3K+cKX4JeOd/RWqLYtQASVKIbHUHfuTikEEFOiNoBqY3i/?=
 =?us-ascii?Q?UygRp//YSE417hDbnNQ4Vist4JNvCXtk1MSjiV8U3YDvZ96QqEOCVwx75BmH?=
 =?us-ascii?Q?XpBHkmr+ML6xhWimHbXqGOiVKcD8DBLQe+4QeODy570U+AFZm0v59gocHWE1?=
 =?us-ascii?Q?OapgiDGYnrEePS65YpCfdBr16Igv5fMRVEziP0672L37fPgbnEw4pjN/lrs9?=
 =?us-ascii?Q?pdKzNfRIyo+UdEct01dFzGMfaUnN3MTifP3yIqwwV3wXONeW5pG2FLLvYXU6?=
 =?us-ascii?Q?wN1NViD9m+kLaABSTzL7W1HTY1tvAKUz2UdClxygipAlWe+Vnq+7oMu7uyFB?=
 =?us-ascii?Q?RoAYDMdhadwmAhgOWtGgT/5on/nF/NTxymhVCJM3ypjyTnUdVAX6Ia5O9kK+?=
 =?us-ascii?Q?3xe4CV/oZ9KC2kC8bj2RdgJ8PJEI3Ub8MONPkkRuo/43AJN+XyaPccVSwOah?=
 =?us-ascii?Q?bc3o5R5JaYU6Ejb6CWzVstVAR+j/W4Xnag5esCCBff65grLYkSPhAVAynh8k?=
 =?us-ascii?Q?/gKbW5rRI5pF/CmytZMm3cIhqf+7KB/pDLUp0/uKsMrHR9pf7LOooxznArH8?=
 =?us-ascii?Q?shf1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:15:23.9760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e466f3-1337-4804-86f9-08d89d2f2e6f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2xXVz8+p+Sx7oPp3EDVPM7jkk3Pkjb63hQiWStexxUNkGRYJc5saHMkvCaUJha3I7vSzA0Ku25Frsw4CJoy7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1350
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

