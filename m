Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105ED2B6B3C
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgKQRJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:09:51 -0500
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:39456
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728921AbgKQRJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:09:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hW4SWu3wb+USqt3AEqx1F+J4YuGumqJ/q4RplN8PKqKES/YIq6WRajQGESPhWbSEzInwBpYwgsHxtTuyXGogUlD5fgHExQ2tiNJtgVuGYOPn1Vlw9I96rv2eVtUWFVkLZPcGsR3agj4DCUgw3rb2TntuTZ8/tBPds46k5/mG8FyWpEGLWcGOc9UgLE8QAUFNXKD6cKP8D0tiyWypKGYZJ8jQbxhqIdXubcRK7eFbKaCtF5ALxC5lqEub5e7Me18UCeXKLAiaHsGj/vohYJiYD94ozkHHmWEDZr5D4lnFy1Dzf8G4lTkCTz3ZOzZ/nG4GLSkmt6smBMeyaeT3SxTgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hi8BDTTvds8h6wUhMF709e2OGBX5FY+PKxb6AjE0yw=;
 b=IlWCjFLAKLm4Ul0itQLYRewSnL5pklvEFPKaWc49hVW7lHRWY3ju/eTJq4ir1pjIM+cEgzFnIC2QNPGwPYSGM1cu/wYP8om6/5ED2adnl6Xhw8wn1LWwZ/I+bZ7GjTsmDxa324grP2UnbdLinBTKDGf2igVbb7WlNbo2qrnX9GkQHnV3xZ52odxUP23ZQKq/2PFBw1oGJQso1cs18alq6AF4egce8FbRVhETNcTagZoYDtK5TxB3ZZlZCMuLrTwiM/XlQ2BzJZAOYUEIJ6Y9U/SWbGvE0K7dySOyRUmx/fVezt3Hsx/eFS7dAY2sHcFRNnCP6G/1yvx/q/xfzie/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+hi8BDTTvds8h6wUhMF709e2OGBX5FY+PKxb6AjE0yw=;
 b=tkcJFXP6Z6yaGt7kjQh1emTLAI2nLEi74U4mbVU5BIFwv2sGVeXh5VWatjfeCeMjFGtvZcFBhEBUGFOX+zK14AEYWaInqTlLV8Kefc5RP+gWAE/p1lzkyOphFHyH4E+Neg1Q++g3LTNNUH9whexv8UxTPDhbMDmSa6IOsRdtdJU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:09:45 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:09:45 +0000
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
Subject: [PATCH v4 15/34] KVM: SVM: Add support for SEV-ES GHCB MSR protocol function 0x004
Date:   Tue, 17 Nov 2020 11:07:18 -0600
Message-Id: <ea60201ce6755c1ecfd3197b94fd647eb87a283a.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:5:334::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR04CA0007.namprd04.prod.outlook.com (2603:10b6:5:334::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Tue, 17 Nov 2020 17:09:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ed0f043-5bda-4c19-06f9-08d88b1b9500
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772A6ECD02ED54B76766AA7ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJLc0IsslKbNErjjSG5bYuF0BG761lutDva01wuz6/Pk09sGS5b07iEANg2SRAToDwD2ulUNKImooS5wgUmDhwHsF+1QlyTcMr9wE7Va19QcQXOna05zbdnhLV8qkUZKparIkXsYlYQCh26OaJ+4st5cyQAPARks3WVa850scZ90yOlxM7RwTskn2fy8Lx9ayR3GmOLdjPTNME0Ne6KhsVMHw3QWTUBbGhA/sF2GuLUV3YrvFhTmfbkrMJqUt7GybryVlna63ETq/UsTnBdfq1EzVimYypkxy9x8sOPpp3l72MXaHRxh8HcWd3r1KvhthYxhtD82+8c/UkKCYdbmrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FXJQXdEfPZ2eJTgI89sejPi4qTNl2g4rTsgSdVSDLtZ1YLWvoWnn2cJUkj0uVnwXrsE+OioNUPnbTgMaXUiLTm1xaUfExVCdgyztU6B3AqNjxYzKVXD+7Gwfo3rDtEuDF1aFznFpMvPUx80y69lHTvf5MRJVxk7pmEItZfVNGI1xO0kQ4PLKl58sbfNmNKC/eIOHqm6EUEXUkAZyJ0JCGMS+6WAS2N1XRvEguf3E8Fz2I5fzF76Cj79Kv2UYqafgg8e0GPoVdCN1ULGYdwcn1u5kK3y1Xn0mBz//2gFBbeT93EkEcCYJaEWyXMLxlFbVtDzZQxkquQ4aGrXRXsSbnKH50Cy7Aw7KiF1Yg3LFEAtV/wXNI7sDljyWUIc8K+/roQjhkYWwVduWE1deEtIPcxR22hwbbndOpbQUP2b213mzmys1wyL64KhzwJEuwq+xXKnbSk5HnfHFi6e3a9AajLprGUB3YHuHNB2GCJHvcjEvRGHyged4cUdCLxkColZMENLKZtX1MNcUE700sWXTzvuo76qL7/RlRV442gI/kTKthluUgm4g36wjR4DurHtCGgnrUFv26j/vZCaq+RlgTujDIswbftjdVap1HTsLWCPDN8a2kJTV/Vivp9sL9vpukOPdaKIhSws2bzjnPPbiPg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed0f043-5bda-4c19-06f9-08d88b1b9500
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:09:45.4819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ygURiMbnxKJa85xeTuCgFsRToWBsoeUnu60bHlHaOlvDE5ONRGsz2fFg/gVekhfhB+sEfeAvB7fIfuqfKfyYsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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

