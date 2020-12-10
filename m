Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C442D6409
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392878AbgLJRsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:48:30 -0500
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:12128
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392642AbgLJROr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:14:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKnVl4o2GvFEYToU8lby56ZscMpLnyncLpHkRCkBUWlAaCcsMp1Vpcu3rllBeoQgzCRvODPofxQjE+esB1B9Yhy65pOiTd5Dknjfqe9VE1XxxIo2HPFMYYwWth0ayJZJoEJsbnrXvjgSjSWzUnvo9Fcd/IICViOEilOzrZ2KvbSB4Jd3mPFgUEfZZqIlS+wW31gVCtGaOmoBJILKGgcgkCRc4lsTkvKz7VhTPR/0oYyel1QVE0a1GkRI5DLSjJMdCXsiESRe1bHJpMOUxJ7rhe8zovuIin6JB+qmIJgbB28gbxvHlRmIymHmX5WrZmHAKR0gs9T3JoBiRfp3A0lmHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEnZGGj5x+/PnxnEsZAKrM4KM5tnVeiQzhb/gnVASjY=;
 b=g0mYq3YmQRkaTziUq6t1wI/b/0lFtAgxglFxHuxa/iNp2vjDb+LrEEXIIOKap1VRGxeeEG6kmlOCDclzaZAiuPE+fFTWG4zAWWA4GEMjyyTJm6PLmcaJoAhrQIqfXEG+hUKRR/t8/5JSu+J6UOP3TT+7pAUClI0F8ugNltaBz2W0OFxyaFGyYUHdhsfpdjic3HVU1wfvdjbP4ZO1rLw58qtsE0tlbKCjhBmGA01IUT5JH8RLc4fbIK2QX1pZ8LHqQfm6MW5NE9mxyIo4d2mreH1EFXx+/Jk6SWtTups1Zy3lTO/RPLPWUHL7nSirp9wRya4FuU0Kas69yLJuAYoVGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEnZGGj5x+/PnxnEsZAKrM4KM5tnVeiQzhb/gnVASjY=;
 b=JqoAYMDVyrHxs12bhcCTHYmGkThKv0Dza3nT1dowHRoqqfMxToUIyppOPM5uG6CI19+BpV8bMib2G616WZo+V3LPFw5YrrJ7Adns6wutGo08y5QSQhOOUDOn6GqF6e7bMD6MrWsknE8FCoUo7lZzyQNjeheel4pwrHydHA5O3DY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:13:07 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:13:07 +0000
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
        Brijesh Singh <brijesh.singh@amd.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v5 19/34] KVM: SVM: Support string IO operations for an SEV-ES guest
Date:   Thu, 10 Dec 2020 11:09:54 -0600
Message-Id: <9d61daf0ffda496703717218f415cdc8fd487100.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0028.namprd18.prod.outlook.com
 (2603:10b6:610:4f::38) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR18CA0028.namprd18.prod.outlook.com (2603:10b6:610:4f::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:13:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85a725bf-a7aa-486e-4705-08d89d2edd13
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149B1D06C6D2D1D3FD345BAECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NP7QiYn0vowqVOWRPJmk77OEw6INRNNaWVkW36+ZIm8taLKMsBYZRkYjwzmlfO9WjjDvs3x3g80M2L1HPc9cgUmorzKkODSTOZt+N/SPccFHP6Q/EHqapOMczgjCdQRajCaPnUpHtRbqMzZ+i3pxHCMMxZBvcs9YVWjiwIPISgdy88wz9EnGIoZSB9bWaSZH5WnFKxz2ej+da1hVYBs8c7ZlI7b1OVMX42xKSup8E9G84A7jG8K2IX9AR4iqfNL+T2zHIolerjrlLf44yFTRXYrcMpfeQ4v3nVffmJ+tf3XrurzJFJz325hYNzDNu1YhUxS8YuQUT3V6oUVky7qAsitD2oquXv9LhYqSHZgwTFltkEewUuEJJ7Io70c+CpO9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(6666004)(26005)(52116002)(186003)(83380400001)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2p0NsodCd5xN+07k069ZyZi+O4f5BpQG2AsNaVQEkUjaxNBtPGyVkV/tn2gy?=
 =?us-ascii?Q?0IkGmGCmZugZn8IH81i/aUCknqt5i8qoVun1L4RYOHkRgtT6rupBWG1gKmXR?=
 =?us-ascii?Q?M8Gcrw/CB32zNA3zpw1faSvWrehSVCa77HAyCWQg71QuMV9UiGMydQx09ni2?=
 =?us-ascii?Q?FmlAIzP+akWfo8NIpcZtR4k7VqTNgKrwdRMoxBHFIItnHqUsBLquc18y+oIU?=
 =?us-ascii?Q?cnQhTPDUdK8yrLS6mM2AuEeBJ7jALX6W3S/IE+yQVaLKGGg6tKZFOizEma4n?=
 =?us-ascii?Q?S4Ia4sNkKDBbTC14LNkvXFmNak5WBPlQ8aY6ht3m8htsrk8tBaVKY1af97HI?=
 =?us-ascii?Q?tMaN4d1zO3DorGGLGGUcB9OcyKaS7jOhE8PF9BDcuFwlRlxw3LZaoBi4osSR?=
 =?us-ascii?Q?gisM3M80NPIZC8L3f1RzMHGZdpHTJG6CnkqODSuNd9ILIf+XBmBbnL2CR4TH?=
 =?us-ascii?Q?oAbtx9E9cjgcmaG+qq+ZcNcrTkHhAjbs1zUK7UGnvYSrvbBjvjRj29qKuHS4?=
 =?us-ascii?Q?241tfNeEmryOwC8PYTe610vrCD1XcxfhZta2cHy+0sZgg6SsQp5+YgQOz7ML?=
 =?us-ascii?Q?/UtLkKnocQvPo9McKZmnBwDlwNg31Vsd6JpO10pdQIz0y5RSqsJfZWCDlvID?=
 =?us-ascii?Q?z6zM4xDVewF+s4PjlPQJXbqKRYYfPx0VnjAzjBrO67wLuCxno3aGUpNHevkM?=
 =?us-ascii?Q?0ZYK/yr3dnnIQsC3hsLuNbcsJ/KNKipyuEtoTCVG6sSAE0bxZpqAU7yNzg9Q?=
 =?us-ascii?Q?G0ouF7LANzE+WthCDnXqAzk1m1phGl+8vaw3aZVb+7ryDAdy+Ee1rejxPMFX?=
 =?us-ascii?Q?zjwz9iX/CcXa8/M3+qP1OzGfil72vZTcklHhHs/FXfxfTzNaYdy0ipmkzHh2?=
 =?us-ascii?Q?3aTWQ5iAJO//a8TNVNdzBlrEs8IIEGRfw5EvyvpragAApMLNIgJH2LRZ7/J2?=
 =?us-ascii?Q?H1nuwsbQlVA6C+BeO5YMV0W49NyCgHausQHC3CNxrK0SwQrvleIZ/c7LYZbN?=
 =?us-ascii?Q?KNRP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:13:07.5090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a725bf-a7aa-486e-4705-08d89d2edd13
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CUnBxlbbgyOtcPVZM5ZGxR4tPCktlP22s43MmRkjW47LVe4IXSS9xwh84kE45TgfQmaVXwsGyidXprxi6b20uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
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
index 8cf6b0493d49..26f937111226 100644
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
index ad1ec6ad558e..32502c4b091d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2058,11 +2058,16 @@ static int io_interception(struct vcpu_svm *svm)
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
index 9019ad6a8138..b3f03dede6ac 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -573,5 +573,6 @@ void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 78e8c8b36f9b..fcd862f5a2b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10790,6 +10790,10 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
 {
+	/* Can't read the RIP when guest state is protected, just return 0 */
+	if (vcpu->arch.guest_state_protected)
+		return 0;
+
 	if (is_64_bit_mode(vcpu))
 		return kvm_rip_read(vcpu);
 	return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
@@ -11422,6 +11426,56 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
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
index 804369fe45e3..0e8fe766a4c5 100644
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

