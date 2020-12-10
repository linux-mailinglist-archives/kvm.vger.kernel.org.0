Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8682D6411
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392961AbgLJRur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:50:47 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:37494
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392280AbgLJRNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:13:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjRHGjt+1X4rkuxVL8mmhRaCvbfmBkzuGIJqyClHnUr4MYZy98rQZK2OCttMalOSeUf8Cg8jxrvhaer+qgMvw8mYaRCiPcO7NuT95P0a6C9aZkeNZkZo+5VYTEwq2L/FpF0szW5Tu8igFrXxeRHd/SuKQ373CaEXiNdGDnhJ+ve3Vc/A3DyParAZTri3HH8kPdhsie9wjRf7LXwynV1sNrQV2jTHAFE7p+4hCArBO6DsxOOyyna3M5q37H50HWRYgLs6lNrFH4Idm5l0QBxS0JouYrokzsQUwSD2//VQLvpdfLkaUwmLEbjYamUpyRN+GFrxjplQ24offNYyTF07NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNKg7hVt9h/LYwnzTCAU1cmq++UR2WpUr1K8Y+oPAns=;
 b=VuS5MGJoARIAxhy/mY7Q9+b9C/llhLh1I89wk0FqjobWVd9ZDGyHTVpQ7LemTWaXqXCBYrziwIPlLDe8ZpTXguUumtGzuT8L5BWST1s7IjEEQ4NVCJsH74EvRY57Rz6jEpehyvbhTRwSl3jGBxA7NMP3sbZ+Feaox4vNH0gfzWnvPW/x2D+BH27AGkR3PydQvr/87QI5DYiXBW6cOCpCFvnULOuDri09LcR/kMixdpQT6R87jJmfIb8jWsEHCG65toHEg6CBeAM4HgCmzXh/GJHUXbzXqswM7xIllTrJ7XpJCL4Bz+32iWL1n2/zMq4AcKj3SxgqkXjkvTraT1y2LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNKg7hVt9h/LYwnzTCAU1cmq++UR2WpUr1K8Y+oPAns=;
 b=a0ObQkm6MMvspvKtsLlSzb1xC/YBrzc3EFDl8lGwao6hzaBpWPqrPh4Fk1vFD9+TRYONXhp2pQfn9tm6v9nAB8FymY1CP+66vnsc3n4PwAVIEy2xUVMJutAf2SUYAqXNqMomRT9WSPrGVzNzZl5HZAYGLS+I0QGmNkRgwKZdCHA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:12:31 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:12:31 +0000
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
Subject: [PATCH v5 15/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004
Date:   Thu, 10 Dec 2020 11:09:50 -0600
Message-Id: <fd7ee347d3936e484c06e9001e340bf6387092cd.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:610:4c::34) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0024.namprd10.prod.outlook.com (2603:10b6:610:4c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:12:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 67157776-c80d-4211-f490-08d89d2ec79c
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0168EB74BBC6B99E290669CDECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SM+03omNLxkTQU5z66Zrl0SRXMF9NgmcPRgiZzXF7FRm7b6Gj8H9BiLmYYfOgPibl1LI72T8DuaIm7vtjuMGzT96PL31+vxhCPNPKsFYKk9XKqb1Q588K0eO+wxiQ1M7ehYg9qIGzCWt64ayhNMW+diFX0aU/OoBfU8m/xtdyj5dZigAcLRkqVNy5xA76/ntyLu656fgvgEGRrzSV6mh1PkHTZFRWq+90WiUsgQTf9FSNj099sqsTnVoq01aKIaI8Fr3vvrrZPSdAtMUDWHoX7ci5W3BcJ0VPe7p6hQSGI2iMOLb5SgOMq040FFy4idalyY4xzA2IwogwpI/GKchAnWHQoXn4ZlzJdWMpOAfifa+2/hfxnWzkxF0srMgvYFK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(6666004)(26005)(16526019)(34490700003)(66556008)(8936002)(83380400001)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TpaEv75o5LTW+jNETNsMBFpZgpgCg0siob2R7vdxHZU8yNwSPreREM69pcRu?=
 =?us-ascii?Q?LIekcdEFxyQMMcCi7WNJ3fPUDsFbcNV7Fz7qyFZXohhOxhMPWk9TBGeiUfyX?=
 =?us-ascii?Q?VSAA/BLRHOsHPrjWVFPGWZiZpzWZVNctLDurvr7IiOl5q0LzCMTw5KOIybe+?=
 =?us-ascii?Q?P1ytCderNZq0LuqJ5hz8ALVco017iPWdYic6w6h/CLzUdT7ke+Ex3rwadjDr?=
 =?us-ascii?Q?J+r86J3cVOscnSNy+sYN2MM+3uIYk7orlc5fJ5Gjh0ggSx+WS0DF3mTWp0s4?=
 =?us-ascii?Q?lpKrirXagXvs7iU4GzbSIHRyu4AR+l0zHn3+RaB5pwFbNLElkZdT0ClEAkEJ?=
 =?us-ascii?Q?q0/FdqN5kcKBAp/wJFYkNXPN1/lLlbcLV37mSxKGeysqRvMz1HO2iebO0uXZ?=
 =?us-ascii?Q?Is2y5x7SmHeySAatUJGDWD2s5BftuuHaW14Bks+oE586llfsOcpl4XqhOSWq?=
 =?us-ascii?Q?Q5Ef4u6Y5z+jPb967MwjIYK+co3LNl4aLNyfxRFMF+W/7EiVT7qD67y1kUkh?=
 =?us-ascii?Q?OgF2RpDAzbl2VbOewuCsWQrtlxszyhLid4SfHxMdMS+a6Bn9KPgku5z2RWJM?=
 =?us-ascii?Q?RKMjk+DBBRymH+HpT+VT0DMEffecX7QQIHkT5NoF4Gj1+AtmV6TF5o6hsunl?=
 =?us-ascii?Q?51Lu10d+URetIIZrJ6Wi762Z7O4pxA03XjGlb2Bi2ci2YkGqJNgoEpKL+6mf?=
 =?us-ascii?Q?olgz5wYozYmC4w65oaVSItwSRxj9WufvTo5bnLj3aZKu0Fcv7gu2eSSPHPms?=
 =?us-ascii?Q?DMqXDb1De7se8PL+0VH7rlAbQspptIz0MnO5N5IrhtI5ohxkK/3CpXOg/jS+?=
 =?us-ascii?Q?aXTpu4hg12Rw7486A7Xf+VZVIFLlTRouP+vZD+I3mCYrOof4QjvNi/a2WdXj?=
 =?us-ascii?Q?QqppCip/qcTAGGzg2XaZQN9DsvwCRkP3azTxsFle/hHGu8EuQmuwBSNpqc+3?=
 =?us-ascii?Q?EK24N6u1ImLdOCy9sYOuNzwbUiPswwKMQrmLrTxA/Z3TEuVbXAGwq5GZLpER?=
 =?us-ascii?Q?DRcn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:12:31.5134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 67157776-c80d-4211-f490-08d89d2ec79c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNnO2aztepFVZa2g+is6Tdlb1ak7T2Ha6VuKF7zPQQFaH6557uV+7LEejzc8FZFQbSnbxgUJyA5I6laEPCER+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The GHCB specification defines a GHCB MSR protocol using the lower
12-bits of the GHCB MSR (in the hypervisor this corresponds to the
GHCB GPA field in the VMCB).

Function 0x004 is a request for CPUID information. Only a single CPUID
result register can be sent per invocation, so the protocol defines the
register that is requested. The GHCB MSR value is set to the CPUID
register value as per the specification via the VMCB GHCB GPA field.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 56 ++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h |  9 +++++++
 2 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 58861515d3e3..53bf3ff1d9cc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1504,6 +1504,18 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
 
+static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
+			      unsigned int pos)
+{
+	svm->vmcb->control.ghcb_gpa &= ~(mask << pos);
+	svm->vmcb->control.ghcb_gpa |= (value & mask) << pos;
+}
+
+static u64 get_ghcb_msr_bits(struct vcpu_svm *svm, u64 mask, unsigned int pos)
+{
+	return (svm->vmcb->control.ghcb_gpa >> pos) & mask;
+}
+
 static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 {
 	svm->vmcb->control.ghcb_gpa = value;
@@ -1512,7 +1524,9 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u64 ghcb_info;
+	int ret = 1;
 
 	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
 
@@ -1522,11 +1536,49 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 						    GHCB_VERSION_MIN,
 						    sev_enc_bit));
 		break;
+	case GHCB_MSR_CPUID_REQ: {
+		u64 cpuid_fn, cpuid_reg, cpuid_value;
+
+		cpuid_fn = get_ghcb_msr_bits(svm,
+					     GHCB_MSR_CPUID_FUNC_MASK,
+					     GHCB_MSR_CPUID_FUNC_POS);
+
+		/* Initialize the registers needed by the CPUID intercept */
+		vcpu->arch.regs[VCPU_REGS_RAX] = cpuid_fn;
+		vcpu->arch.regs[VCPU_REGS_RCX] = 0;
+
+		ret = svm_invoke_exit_handler(svm, SVM_EXIT_CPUID);
+		if (!ret) {
+			ret = -EINVAL;
+			break;
+		}
+
+		cpuid_reg = get_ghcb_msr_bits(svm,
+					      GHCB_MSR_CPUID_REG_MASK,
+					      GHCB_MSR_CPUID_REG_POS);
+		if (cpuid_reg == 0)
+			cpuid_value = vcpu->arch.regs[VCPU_REGS_RAX];
+		else if (cpuid_reg == 1)
+			cpuid_value = vcpu->arch.regs[VCPU_REGS_RBX];
+		else if (cpuid_reg == 2)
+			cpuid_value = vcpu->arch.regs[VCPU_REGS_RCX];
+		else
+			cpuid_value = vcpu->arch.regs[VCPU_REGS_RDX];
+
+		set_ghcb_msr_bits(svm, cpuid_value,
+				  GHCB_MSR_CPUID_VALUE_MASK,
+				  GHCB_MSR_CPUID_VALUE_POS);
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_CPUID_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return 1;
+	return ret;
 }
 
 int sev_handle_vmgexit(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 546f8d05e81e..9dd8429f2b27 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -534,6 +534,15 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 	 (((_cbit) & GHCB_MSR_CBIT_MASK) << GHCB_MSR_CBIT_POS) |	\
 	 GHCB_MSR_SEV_INFO_RESP)
 
+#define GHCB_MSR_CPUID_REQ		0x004
+#define GHCB_MSR_CPUID_RESP		0x005
+#define GHCB_MSR_CPUID_FUNC_POS		32
+#define GHCB_MSR_CPUID_FUNC_MASK	0xffffffff
+#define GHCB_MSR_CPUID_VALUE_POS	32
+#define GHCB_MSR_CPUID_VALUE_MASK	0xffffffff
+#define GHCB_MSR_CPUID_REG_POS		30
+#define GHCB_MSR_CPUID_REG_MASK		0x3
+
 extern unsigned int max_sev_asid;
 
 static inline bool svm_sev_enabled(void)
-- 
2.28.0

