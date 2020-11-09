Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DB42AC874
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbgKIW2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:28:19 -0500
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:3355
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732176AbgKIW2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:28:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwR4dnO53bJf8br+YrBQzSAzlchdx6RAWaG0uqvmXo0HRYsYRdFOQmMBHdv4pI/94XPYNGdueg2+IuMg/x4PhmYByeBki9a1Hlwfy40BLmg6BHaK6mzp+nmGlDVPCK6k3VzG57b6hgeiRNksii8rGxdn0dryqg5BpVdaAKV29T0033abSEaMyTHJYIJPL2sPC5MvhgdHAV9PdX78kAQtETU24UpuE5PQjkyp8g7ZM0DCfxE1jQ9YFlSaQwc2fMFwrE0iixHNFNntCoWLNyee9tYlXa1x0wqhc/Z76grnwuRhuvhUtHN2hdVify8mc2KVCb7gwCqQe7Ixtmo5cdHraw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPdu51igmv2D758xgqKuGyo+UdzxKKa6KflQI2vPM/A=;
 b=CBrbjzIJxBBrBsZp0yPNMDPRs1jyDNDSp3MHsBQwiuBTPP2xM4kF4iPKMqfwFvaMhgBM8FWf++CWUu1jk4e9zz0UW5tFlf00dPTcfMyyxGEQgSBi8YC9RZQoyhrEGKMbERcYgkcErRQmWwG/l1MpJu33oAk94F8T0D6LKL+S4c1QpMNZ8UPtcMTeFotaL08EvOxDZR8a4PIP4fohfAwj2kxknYTG/MlPBq30+u+qs4KBsDaKfaKWXleJnoDHJAZEgs+/1LcXSxD1GSuacJF3sxa1P7jy2qBSDkgOM6V8JO+iiMRzgyeNX+XY9TTUDHs8aAAdnWZtlCzJ/NX+5AEhRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPdu51igmv2D758xgqKuGyo+UdzxKKa6KflQI2vPM/A=;
 b=3T45RgAt/hOCmsI/0sc4PV3ZuQ/V/fONzuCZbBOTrOTYkfqbHc+OMP99gIjqwmsJvOyZZosGTmuiAo0Vot4uoEWw000ZictxhKhyNzShnrnWmLh8dAR/ys+Aqt4mnE3YNSkqgd+hGBuQn3EGsG4VWK+s7KZRR3OzvkHw/8CoOj4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:28:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:28:14 +0000
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
Subject: [PATCH v3 15/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004
Date:   Mon,  9 Nov 2020 16:25:41 -0600
Message-Id: <1d65fb0d2cd0c0a99102935ff6632d0e7e8ce25a.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR1101CA0020.namprd11.prod.outlook.com
 (2603:10b6:4:4c::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR1101CA0020.namprd11.prod.outlook.com (2603:10b6:4:4c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:28:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d84d19d6-0093-4f5d-705f-08d884febf4b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB40589F41B8B11D247FBDFCFCECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SB8K0Tm1gFMfgQ0htojSQnlamWESuJ9KaAru97Spg7htWRhJdWMKFySc9a6G63S2Gws9WtCZ3hTHZTNftfodBPc+6CIU9rSNgvC8Tw/5erOyHPWxctnq5Iqm5troGUMGCVikjwsM5p5FxAqvdenKcosq6tAtPJ4JgtRBPS4ffc4i9SfBhk8cYHSZrrWtR7zB88KPIVKk29Ji0Nf20VOMB3XjtC5AIWSlYmNIr3ibW9htd9brMYwsWDfjfIzqaa8NgRYG2Iwe3uyZouylW/ayKZlAb2t3NLkfDZYC54ENlrbxdjsbNuI+gDo4sIMXHwTkKUuqHCP4HItMeDruoTdzOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SqOK3u2Rj1mlVA1XoJNAwKcc0MR+5FhQOy8rTwyScQSj1D7G4nT1WoTfX9IfQDG14kcrHd721BlH6QAciR+GXTQnAI75BdcZ3PlZt1cWy0juMe7fCV/YrGCKDtjkFQ2EaxKPqqu9HSwjNdoj3fbdfihjcY4Ixs4aVxxnsANy7hRtbdVd4aEtTNkvq5bc49aSkJhytGCjvHc3hUZY6DFJubnVMXHeIa5ZkbWkajIL1YXiMF8a1e+iFy35GYAOQcLDP/NwKvioqejXH6eD2a6eEvOJ+pV+YFJFx7GFgNZai+3PMmKqT7Rq7Gc5mx+hPr32WUV6nZZmFdIY/Vkj9Zpg4EwRAAUeCyzVQnV03ut2vKy/90QRvBZ+Ty8x8OXlMXoFepRNLgINFO7rKiedS0kMoOndAGpiywH4Aa12J0qQOZ/36d8QsGeMJw8JriCrTTm1uJ+wu2wo7APEpt8cAHsXiyrQ0ERvh7InjbZAM8EbYaAkia4xIC9mt3wPVzejd12CH1WebTR6ywMJc+JkB8qM0xbHAzH8PlIdsw121DeDrgdsIC6y9SnlJaIAsKRDWLo9956/KU8HITI1gBnARX/Sj8aGgpI5TetOJXfk+lDDwxh0AZDHbDjnUah/eCswev/dTta3f882k9Km/bYeOPorZA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d84d19d6-0093-4f5d-705f-08d884febf4b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:28:14.0866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ChRLseIeuqkrvCJcP2WnllApK1KhaXC0AhqUJQmP8n7ga/7SmggnRPvVCcQnrJiCQAD5dTuHugwtKhNpZZ/8iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index 204ea9422af5..24df6f784a2e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1501,6 +1501,18 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
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
@@ -1509,7 +1521,9 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	u64 ghcb_info;
+	int ret = 1;
 
 	ghcb_info = control->ghcb_gpa & GHCB_MSR_INFO_MASK;
 
@@ -1519,11 +1533,49 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
index b975c0819819..0df18bdef4ef 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -533,6 +533,15 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
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

