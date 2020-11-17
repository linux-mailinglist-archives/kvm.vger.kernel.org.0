Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBA82B6B47
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgKQRKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:10:24 -0500
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:45280
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729215AbgKQRKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:10:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqhmuWXc7e99lWqnot8U3ZrojDr6QPVz3KRjxLc02uDCWq/n7nksu1yWr3WXOSIUvM4CKG0Ii7FGlWzxITHQlQEvWqF9r7/gWk2Pcc+eutqfReWu864h6S+S6XnyDo6NuFWoVq4MuOQwSS7fSwyK6+rOeRqx7HDCTn/FtEdJW8jPKjHhVgLIu6lIF3unqkpD2WUA/fq/DUYimSwDwNhmnJ9ksFwPm9emsUyfTukdwQUKnBR3jMUM71R8B9QJ/JQ1DGR4eEBOUXJRlXA4wAEX+nMfR5kr7RQ3zJOP/ldFIL1HAANpzyh9EqhjtLiq4uUrbsnJI3eCUZjCND8/MYlNFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8F99g1Y3mUaaZmB47pJOv+GvK/IH+oa1tBsdlw75Wk=;
 b=cZMRbGOQpn46SrHgoLg5hD3D2AGwNKJB4pW4+gFITHGK5529VY9cz4wvsXK7Ww5yNDjuYJ2GyeEK9MkJJi4I/RBeE9ECOs6EtQFVtj9h/6GOlrwbF6d72WlAXZWnkpAdGd1d7E9UisTwHNjjmLvzAZ5FVd+edxyT/sZtI6mJiYqouD5QcRZwtRyQRptWEFgIKNqUZdbQmPHKuGn0Owvg9S1YugCxKKKEE2Bu32Fq7KSwUxGGHlr0wJBmO1g3P+fjcNXwoiuFeQTstMxjZmm0yPNPMYEzcHdgnf1TgAJvgg2YBY5BEsbtSAsmWJmr+RF8zwUftM6sygp2nRPM+SCD9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8F99g1Y3mUaaZmB47pJOv+GvK/IH+oa1tBsdlw75Wk=;
 b=qyPKFvsZL+FI2jWQIeT0ZLlMkRVNeileZJrtUv/+Pgmm9bAWd3GbrxSJHqpbLLD1Th/GmPgj1nPCyeWv3o7ZHfDeQtm+jF81G0I/spwFsA1cV/tDsrJ75+puYtBfWRkNEwppjNR8XTEk+VPAo1evUoFo2c88+xk5X6iQQQo24lA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:10:18 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:10:18 +0000
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
        Brijesh Singh <brijesh.singh@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v4 19/34] KVM: SVM: Support string IO operations for an SEV-ES guest
Date:   Tue, 17 Nov 2020 11:07:22 -0600
Message-Id: <a0b840d8bc0720e0e89d47db2cca23db183a2533.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR04CA0081.namprd04.prod.outlook.com
 (2603:10b6:805:f2::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR04CA0081.namprd04.prod.outlook.com (2603:10b6:805:f2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:10:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ceff8be6-1e9d-4aa5-8272-08d88b1ba871
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17724007AA7C698FC425E14CECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6YPQYvt5iC2OeBQ9WD3Ujvw2yKixBjE/rlfeiBlFGrzTfTcNyOkIwK8JwGQm/q19YNcbA7t2XxUqPU0fJFWrTciEcUf0D6YzzDI5IhDHrcEsr00ZO51HuXJdkV9jQwLl+6Jf0SY//yuiTNJOw6ZHxtPJ1SNXqIAMFSQcZvEZRvaRAlo7BSmlzqfVYFKECCy8oiN0TYO0R+j1ViAbjRW8PITRWpRNJTpxgNJWJqMewTXRmKSxmrq+gxMSx+ZzPxEtx9wRcUL+rGwJOaXH2cQ35fqraKM3qI6meL/g3fAW5sxxc/GRHaqZfQCyawUvfiyl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iYUeOhPbQiYfSap7DplVWrzveYKJv6Ds17Om0R8arkHuBpvtrn09h5wT8k18lDaMYlER0apD56lrGA/WHHOmNEgD4pqEwKvHJRC0tEhK12xGpqt8i8m4lVQqR+rnBSxl+baVSFprcVPT07wb5GiL+aJO9xeu9AKjBmdS9QNaFWHMuBdr5Zwt6huGfJ6pjauigalsyOWbhPQFlqGrBHIuHwIfgK0/eVdyyQNDP2P4QXxa8IHfU1S2kXLH1W2cDR/V1M7aV5u0HgOhz/VZx5Z/DF4G41bXJd5d/2MWL1AysBywc7qns3YKw0uraBGd9eQ3XukNbEEieLkwrNmd3d+M217KaWgZymUVsOAYrXpuPy8jkp+WeXY+HuWZT4vxdSpscU2D17pTT3NpdiMpLBwfq+gwdrU+pdc+Pbre1biaQADZYQztcDqcNNxVlRWbtmAtKUsz8O6I9FP2l24Dg8250VHw29XfY8C/NkgLR2Nh8NXXtIRE+t2KJnc/pbb42vuSpu/91wTgISebu8LkjK2h4ygHE0vq5jelDCSQq5KIfd+gvcYusNU1NXUG7/ClJpFpBjOhzuQsHl9pYysGwQFGrj7qoMW05N/cdEiDu4DVSBSisN/WDKhT+miQGBLLFJ5Wy++KYeJSoa/NgV5K3sFKHw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceff8be6-1e9d-4aa5-8272-08d88b1ba871
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:10:18.1773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwoG95Hf5UXzrQsbpIb/AINvCIIxRKtZdB2ptHBcT8M7c9zhRqeIdC0GIZAhYhe69SHcS2X3FX07S76qUgJXqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For an SEV-ES guest, string-based port IO is performed to a shared
(un-encrypted) page so that both the hypervisor and guest can read or
write to it and each see the contents.

For string-based port IO operations, invoke SEV-ES specific routines that
can complete the operation using common KVM port IO support.

[ set but not used variable ]
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 18 +++++++++--
 arch/x86/kvm/svm/svm.c          | 11 +++++--
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 54 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  3 ++
 6 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7776bb18e29d..4fe718e339c9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -614,6 +614,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_pio_request pio;
 	void *pio_data;
+	void *guest_ins_data;
 
 	u8 event_exit_inst_len;
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 63f20be4bc69..a7531de760b5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1406,9 +1406,14 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_EXIT_INVD:
 		break;
 	case SVM_EXIT_IOIO:
-		if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
-			if (!ghcb_rax_is_valid(ghcb))
+		if (ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_STR_MASK) {
+			if (!ghcb_sw_scratch_is_valid(ghcb))
 				goto vmgexit_err;
+		} else {
+			if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
+				if (!ghcb_rax_is_valid(ghcb))
+					goto vmgexit_err;
+		}
 		break;
 	case SVM_EXIT_MSR:
 		if (!ghcb_rcx_is_valid(ghcb))
@@ -1776,3 +1781,12 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 
 	return ret;
 }
+
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
+{
+	if (!setup_vmgexit_scratch(svm, in, svm->vmcb->control.exit_info_2))
+		return -EINVAL;
+
+	return kvm_sev_es_string_io(&svm->vcpu, size, port,
+				    svm->ghcb_sa, svm->ghcb_sa_len, in);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6fa36afbbad1..02a8035dd6b2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2054,11 +2054,16 @@ static int io_interception(struct vcpu_svm *svm)
 	++svm->vcpu.stat.io_exits;
 	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
-	if (string)
-		return kvm_emulate_instruction(vcpu, 0);
-
 	port = io_info >> 16;
 	size = (io_info & SVM_IOIO_SIZE_MASK) >> SVM_IOIO_SIZE_SHIFT;
+
+	if (string) {
+		if (sev_es_guest(vcpu->kvm))
+			return sev_es_string_io(svm, size, port, in);
+		else
+			return kvm_emulate_instruction(vcpu, 0);
+	}
+
 	svm->next_rip = svm->vmcb->control.exit_info_2;
 
 	return kvm_fast_pio(&svm->vcpu, size, port, in);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f5e5b91e06d3..1c1399b9516a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -572,5 +572,6 @@ void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe9064a8139f..46bd83f0dbc3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10757,6 +10757,10 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
 {
+	/* Can't read the RIP when guest state is protected, just return 0 */
+	if (vcpu->arch.guest_state_protected)
+		return 0;
+
 	if (is_64_bit_mode(vcpu))
 		return kvm_rip_read(vcpu);
 	return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
@@ -11389,6 +11393,56 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
 
+static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
+{
+	memcpy(vcpu->arch.guest_ins_data, vcpu->arch.pio_data,
+	       vcpu->arch.pio.count * vcpu->arch.pio.size);
+	vcpu->arch.pio.count = 0;
+
+	return 1;
+}
+
+static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
+			   unsigned int port, void *data,  unsigned int count)
+{
+	int ret;
+
+	ret = emulator_pio_out_emulated(vcpu->arch.emulate_ctxt, size, port,
+					data, count);
+	if (ret)
+		return ret;
+
+	vcpu->arch.pio.count = 0;
+
+	return 0;
+}
+
+static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
+			  unsigned int port, void *data, unsigned int count)
+{
+	int ret;
+
+	ret = emulator_pio_in_emulated(vcpu->arch.emulate_ctxt, size, port,
+				       data, count);
+	if (ret) {
+		vcpu->arch.pio.count = 0;
+	} else {
+		vcpu->arch.guest_ins_data = data;
+		vcpu->arch.complete_userspace_io = complete_sev_es_emulated_ins;
+	}
+
+	return 0;
+}
+
+int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
+			 unsigned int port, void *data,  unsigned int count,
+			 int in)
+{
+	return in ? kvm_sev_es_ins(vcpu, size, port, data, count)
+		  : kvm_sev_es_outs(vcpu, size, port, data, count);
+}
+EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4a98b1317cf4..f46bb286def5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -411,5 +411,8 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 			  void *dst);
 int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 			 void *dst);
+int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
+			 unsigned int port, void *data,  unsigned int count,
+			 int in);
 
 #endif
-- 
2.28.0

