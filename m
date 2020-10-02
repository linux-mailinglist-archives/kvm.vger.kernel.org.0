Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA152818A2
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388386AbgJBRFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:23 -0400
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:24518
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388412AbgJBRFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7jfWtn9yGJa9p3YL/PbW2q0hJUzU0riRsHL9fWU15pddIu9j2kXjBtA3w95asvHrGxsxJC9xuCIPhI5HkOqfRN46RL4rglwXPLS+6kiLsaD4QsIK447eX3Me4Z1q17aecq9dunZSM/kNtcjDycS9lIplsqvuBPTz9swqdERweNsJs7szeQHMj84c15JsLG/ZaLir8r0AN4g+5+g4wvtmUl1oe4rfbzNJttXlPEW96WCuSVdM4OL6FcOxWEAcgRDdJtOnmfFD1fzvIv4/nwQRdBaoZc7mZ0TKc0Q2QxavdGKHFQaglYKMWYh3nba7Mv7tduJNyoyJn6YT5qnp9Kc0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ysbYgpBXCio2xpB1QPfo7k/xaWLbo2pmCQLOhcHQG4=;
 b=R4Zj9mDxLtMhwxbYREsx7GKakE3xCtDwAslTzwCnyxkBgfrTOOV079hcShQc8JXI/Gil5orBT7h4v6Py8t5MZT2FWr12KPNtTFDkXiWKJaSin1SlsIBtHAx7y1WDZGH7vwBIjdX1m0mLfnP5dbkyzK+1OEv5FS83R7PTcIQmjy5ubWNcxlgfWqWZDof1xd9hgHE6JcyIrshoMbBaJ2DWFUG70KyxKQN9Uccw556NrAebBgpJfy3YU/VzAEnKqGJt750RyYSI9vuEvo9rkY0yPPAxHoO6Eb04r9Nz7xOvVzdqZT9fIb/NO113L/B67cnvZ2zIYzCYhDi6UPT84mki/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ysbYgpBXCio2xpB1QPfo7k/xaWLbo2pmCQLOhcHQG4=;
 b=gSNKyLvTwnwEs3t0bBNO+D6LRGNJ6PBsrheApT80jKHnRV+eGICWoSQg/3NElqNsPwlPmvmihZf2la++8VNM+YBCzs3VvPkIBZno4sMqjLAQ76Tb+vAXdyrF8pU2Xh5QYFdMKauHJXmKAEyT/w/pjZEwxu++mnkBuHIrYl21bco=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:05:11 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:05:11 +0000
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
Subject: [RFC PATCH v2 14/33] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004
Date:   Fri,  2 Oct 2020 12:02:38 -0500
Message-Id: <429ee4d53ff0e8a4197136054d2bb55d1cabf3a0.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:806:20::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR03CA0030.namprd03.prod.outlook.com (2603:10b6:806:20::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28 via Frontend Transport; Fri, 2 Oct 2020 17:05:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 92299c79-f16c-4491-76cc-08d866f55251
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218F0267219ADCCB381C14AEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QZBirJ2Yphb3VDXY1XdlQoDQJQno/NOQSN0EtBuR1xIxzOe0o5OIcXl8wxVIb9KD8eth3jKSrYuasqPCVMS9XQfCCVgjaZZkx728x5Cr0u8Hv7KZ0FximL6eprq+pfXJuUyMWjhlanPmcBF/uw4TFWvDFEwKUeSixVq9GzIxzv+SB2HTF94JO8mutTO8NZp9NdyUGnamuCUDCt2sY9qqfwTgP86mxSBMpHkG4LLMUF18Nxbo0l7SA6Ww7WzqcBDUSI423quVJ/plXLMGLQmXULPMgVByNmXdor7yZ0rb90rF81YQ6O9vzzMxi/DbrhsItipr7vN3hnOnsFdSjj5Maw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yjCy5bt8QR1Mdi7cDUFTLk3v38N5lPlQig2WHyOsoqhEkys6Rv94xXWOFHIVF/Xz5PjxlrX29rm1nlvDF5ilMRSyST2M8xsH6w/P987TpIi1az+CEuHa6agWlaL2/QNIkCY646rUdHVfyu0PrIePmXdJ0A0W+MgACSuBhAzhLGDCb+IVCUJYGXEEmAOagc0BrQUMiaB+V8gEG+RQeTAclxoA22FSajExDCpx6sshbjpUMP6B+94Kp+hCFQXu2NrE0JnqBX67l3yuY8GJUl3MOXtCevWvCaDLBoTvhBF1v7XJZ4ki6I81vsvgXkXcglXwPhmJ1ALgFkTu3dPLnzn/EE1eK4FvqlikihYEJ1pd3kKGo2SZ6b7pAmnF52liG1UT5TIQ/pOWW1mZqNnOPXP3t/439wyUhg3RtZppQtETjOKx6XFaxjGfJQGH6kJz3YakB+apcD8zg52l4cyzl/1bJZjaq02r7YHPre6iUkIqbS7hY3SyXk0uywTo5lq5SlwJUaWaKmYJDwsthiB6vIlWP6Ei1YLylFUQdBNJiKPd/R0oPvT3WdqNd8G1Dws5Arv5N8cKWjzGCwpep7pQW+6J7IWpMSqQ16kumQ+edBJr3IHnZ+T4+6JsuoBL9csjzV8kowj15PjEdccQPoYf6SayYQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92299c79-f16c-4491-76cc-08d866f55251
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:05:10.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0NxpqVQYkKyPEfYqpW6/2bnhyMAE5AFa2oYqxGasXqZ7cSRY/5qcOEkyRLf9iUSETk/qMzViu2m7Uc2zKqUtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
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
index fb0410fd2f68..f890f2e1650e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1412,6 +1412,18 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
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
@@ -1420,7 +1432,9 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u64 ghcb_info;
+	int ret = 1;
 
 	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
 
@@ -1430,11 +1444,49 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
index 487fdc0c986b..817fb3bd66c3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -525,6 +525,15 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
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

