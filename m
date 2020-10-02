Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25E22818AE
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388484AbgJBRFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:50 -0400
Received: from mail-eopbgr770073.outbound.protection.outlook.com ([40.107.77.73]:3432
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388161AbgJBRFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrwSdv+OjhqGPIkdCr+GyjYBZ46t1lNgbbQJwveHL0S3NvuaUOT0qfa3wgvDXLfH+JNLzOoovgutEOGczT60VYcpnQKit598QmBysecBqEzI5W1BTIs5SLbu7lmsfCON3vjCiL+d38dB9FvLCKIQPW4qnS075ZL4TnSnJs/1iSgvyuJZxwDPPHxtCCL/3Oi742M3T0fGS8RSk2bywWxiXgD8WduDbmmbrGLd66CWZ0F3+jByfUX0zQdS0ifCIArg1TfuvNWibEnjmpKw3+EVVENtHVA7dQMNDD5Pv7gFvhd1jyuOfeJHOc+KK2vxH90KbPU5qXJBnCNjvj1+MU7euA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/+MSdgo73quNyBE/bEuHk+vN9LM0uMLyeQKImJwLy4=;
 b=VRWW5kg1gPloBJVlazc+k5HzO90f651BHkMvAC4HVvSsTsJKQIKq9EkD4Zl/tOSxLIAjuodaVz9pCYhgjX3b9bcj1wfYW1LKCLygCMj8NjDlN/0nl1DZjgzYWyMMIEPj9ZVAvvb+6wDagBMPjtlSYh/Edxj229fpkRg1JDAjFtvICZvXbOI1TkNCY20ljoDWnFS1jEKwc/tJ3zNRDzWmF+denasTMWyGLFemg9resyhX1HzhdVhCdrKDarhtPEJ6BVDIhzfTpvaeGzXCwUVnwldMNPCIEDCeEulikfCE8JPQM/ctvwamekUnUEeK85RomZyVBqMz4PppbojNSp4mfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/+MSdgo73quNyBE/bEuHk+vN9LM0uMLyeQKImJwLy4=;
 b=FPWXsGMXOflHZ2cJMif5HQO1kJMecvqz2nizHSEKEAqHFXI9Ht9PxMtx7By2CqEhM124EqlVDacUBtGIWyI8QDBc0RztEuOttqTP6ZHsg1sChuIlbBQz2pkPWBSJVJWJ1kJhPvt85iD2U9uP1AxJaIFwCY32vr/9XoE6OhQSusk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:05:44 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:05:44 +0000
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
Subject: [RFC PATCH v2 18/33] KVM: SVM: Support port IO operations for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:42 -0500
Message-Id: <778c960c37cdec80ecf2785e062154e53b5bcb85.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0065.namprd12.prod.outlook.com
 (2603:10b6:802:20::36) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0065.namprd12.prod.outlook.com (2603:10b6:802:20::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Fri, 2 Oct 2020 17:05:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0b826be1-09b7-428a-efa6-08d866f56642
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218188CCBA53E388468E8DFEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqEqNMzN5jh+CxGQIPcikDHmHZ4H7jPyniiGkYQrfxFAnB5Re18v3iyN+d2SMTfkn3cpI18Jw+k4CbAisE5wVeIwhx+f6gLwSM1yWFdZd3DQGp1v3xL1BcMidX9qZZvJ3izHAS1vuj1JCPkT32aWz/uSMhqyElK9RAyGBD3q7DFd9nJey+3cWd2qBubohCLPZw72+AoiOkIu15eN4ZmFfqjyK9syj/MqVesIh9/+OUPzKy0XHfa8rm7tcKYpFk+I18Xi4awsitJjKGoyvmssA1Pdg44FQIW9TiSMXImafFyWaEIIwPnQhtJnwsa7Lz0E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SLoui02HoqpWL/aQn72HaBmEmUV1ilslhf4LIV0+nbbWzYIxlbP2J/aUBC+R++2qKABs3FGvBPsepQDkOpTofkXSNez5AJJbONU9NQGxHyhQ2TgsmN/ogqrezvCNNuMVcp1D9GgSjQSZhB6piHXm7ghTiH4TFvEcwGjBLEWQEHEH6CBDetrpWaoqKd8xBuEgna1voBbCm58EFfEKOwIq24tk/FQoFxZliItru3UhnhgWJCpLGFD8Regxq5l5UUjPbTjzzLUVuZPjVjOsOSQIX2fKv+8B294aHRylumFxmkpxqQf+KFu9aph/I+Jwd8ZjVQjac3MP4LjSQpzIdXFRrTUor2sMpNRLzsa35aCDRM54dXUG3lCrWTIO0cyAVH4IVW8tRWZw4G0BoMH9AOLfaHezU7TQvrqZMyEVJF+YMoUuoWRwlURZAmeMddS4AAZx59l015z6UB+xRKo69RNAAjlWZaKp9jz8cnPZOtBC+y07i876j0mz79yTUXqZkFNgOkgdJwZ+EmI7KD+CMdjNXsm3hFt0VhU8uacXQ/ITBlDdNROVHQZUDEOBKj2NahtcpG64gPUji9i42hoVX1t4dgCFCpuQqVTv+TKZ0Ofmfg8qVvmExoOSm/bcKZUbO0+LIunOOOkEoU5Z/JfxFpgTcw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b826be1-09b7-428a-efa6-08d866f56642
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:05:44.4117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +t5ICygKPtnOdVSe6qpg0FdTx6Aej0e93cIotFXFfhL9LieOgLHOuB0MR9hafI1SHHO5KZ9BrLw6cyrL6hoEUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For an SEV-ES guest, string-based port IO is performed to a shared
(un-encrypted) page so that both the hypervisor and guest can read or
write to it and each see the contents.

For string-based port IO operations, invoke SEV-ES specific routines that
can complete the operation using common KVM port IO support.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/sev.c          | 13 +++++++++
 arch/x86/kvm/svm/svm.c          | 11 +++++--
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 51 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  3 ++
 6 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 355fef2cd4e2..7e7ae3b85663 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -614,6 +614,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_pio_request pio;
 	void *pio_data;
+	void *guest_ins_data;
 
 	u8 event_exit_inst_len;
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1d287f5cffac..f6f1bb93f172 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1320,6 +1320,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!(ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_TYPE_MASK))
 			if (!ghcb_rax_is_valid(ghcb))
 				goto vmgexit_err;
+
+		if (ghcb_get_sw_exit_info_1(ghcb) & SVM_IOIO_STR_MASK)
+			if (!ghcb_sw_scratch_is_valid(ghcb))
+				goto vmgexit_err;
 		break;
 	case SVM_EXIT_MSR:
 		if (!ghcb_rcx_is_valid(ghcb))
@@ -1680,3 +1684,12 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 
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
index ac5288a14f18..14285bb832de 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2072,11 +2072,16 @@ static int io_interception(struct vcpu_svm *svm)
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
index 386b6b21d93a..084ba4dfd9e2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -563,5 +563,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 762f57ca059f..a5e747f80865 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10643,6 +10643,10 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
 {
+	/* Can't read the RIP when guest state is protected, just return 0 */
+	if (vcpu->arch.guest_state_protected)
+		return 0;
+
 	if (is_64_bit_mode(vcpu))
 		return kvm_rip_read(vcpu);
 	return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
@@ -11275,6 +11279,53 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
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
index 65396753b6ab..7edcb068fb69 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -405,5 +405,8 @@ int kvm_sev_es_mmio_write(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 			  void *dst);
 int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 			 void *dst);
+int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
+			 unsigned int port, void *data,  unsigned int count,
+			 int in);
 
 #endif
-- 
2.28.0

