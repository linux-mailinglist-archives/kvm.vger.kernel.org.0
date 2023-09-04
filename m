Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428DB791546
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237573AbjIDJ5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbjIDJ5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:57:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54FDCD8;
        Mon,  4 Sep 2023 02:57:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VajvsAwxc5Lfvudq3tCT4xFhrFFdOU9d4J4EL0xu3zcPjoWQAk3M2TssvJX2dPBJupDt0Ts+dKldrFlBsmAFIYdSY+JN42yglZkGzO92TdBOxH25yTodEuTUC0HwHKITnTIG+2dRulqZ369S9ZqT3rXxWa9mMTMdjwrjsM5a6O5rPDGW8BCgw/YpntgNTSMJOPIPq+emYMxRQjiMR2cSc5lyU8HsoNrZgjbLn4eLWNPUpXnwJeDd7xuQobA2572vQmZN77dpymBTtGRAX1vnirdAQFuDAAXnejbgt71Uz1n0kFVPQKNOoVIlwNiE/UEj6ep8fyB9Pw4bEInpXFvsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6akqhtljF1NHy+0XwWvGpX8Rj+0MYE+H/Pi62+ChTw=;
 b=U0UxAnmHBZk9ebtW7KRb9IsynI5khmxHFDTzex4PGh+61g6B0iI9Li9FnErCrnltHF4ORUZGypKLBRkLub1mvVOoJQaA4bO/a9gghQT6F3dttOOvPvH/CgQPUw2mzgKvOwdMQDpNptCY8NGxqTB+OzNP2nKy8HnNpqroKWzXNLPlDjZLxl8lFeWaYvYbqIXu5gXwZoMCyUNNVy7X9wdvPQscPZ3oYE4u9Y4/kf5L9i09ohLq/1wXlzDwTvg0JAIiy6ilHaNGx5j2KdSql+tA2c934Hyozt/0dYSdLYMPpJINipze5F1M4yNRBSttmDjKP4wqdoY9gcjpbSuIuAkqpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6akqhtljF1NHy+0XwWvGpX8Rj+0MYE+H/Pi62+ChTw=;
 b=YDuyLiY/c4cVshEsQqzmWJAxt+mkAiF9cqHnz0uHeUPfqjpRwx+KKPtEEaZ1YoB5DMPS8wXY3Quap9x69R0sB6kxhQYMTkhK2IhfvCn7UcaG4V65RM/cu6VtByzBzjKLOXCoaTGRwedj5PldWM8sDM1Gj6+i+P+xEpLrAWj3NT4=
Received: from CH2PR03CA0010.namprd03.prod.outlook.com (2603:10b6:610:59::20)
 by SJ0PR12MB7459.namprd12.prod.outlook.com (2603:10b6:a03:48d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 09:57:07 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:610:59:cafe::ae) by CH2PR03CA0010.outlook.office365.com
 (2603:10b6:610:59::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32 via Frontend
 Transport; Mon, 4 Sep 2023 09:57:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:57:07 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:55:40 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 09/13] KVM: SVM: add support for IBS virtualization for non SEV-ES guests
Date:   Mon, 4 Sep 2023 09:53:43 +0000
Message-ID: <20230904095347.14994-10-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|SJ0PR12MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 433bc5f8-1cf0-448b-8687-08dbad2d4c9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UXrD4SCMBCh+ob3lgwVyrqok/6cNSecOZYVMfq9XoSdW68EZWFXkuoY1U8SuISMX9faEjC68REiWqGJHLz13wqJt+6O7vXHvrMBh+Ad/CQ5IZs9wiIyrZnNkTmxS4RDQut5DAZV4/kzBrILbv+igxyVp5Io5G2v8RCACdkV3AoxnxIaTgDM4aOkaT6PzV2j+IIafVuZnN1DXox65+nLtvjWlK81WK0YAjEeCdZQG4KdwPy4MDBZAIIZZCBRYnqmnuZ8QuoX0QoMVygzC8azjG699e82nL7TNDgRYjLB5F4B6/18MzIX+ZGLAkNSewWRPqLBaFVeTiT0IlB3AQ/H343jvQCsaT0/czpBEv97yIH3lmfxcv9LfI1jljkQRkUF948dAKyv5/uPvSPErbEdgr5/o/LZhp6rOC1TfVuLau004Kk6wSk229Rt3QyPeEfg2E+NLAwrEK27k3liNNiTKNg65zcAOHF24R5OXZPIZNsMEAYfjwROETF1iDPRk7V7qjpjmHvs+JCBU1sFBViMwlwyJby8zZLKlaZsPUzkn5hU3FZpvLzPFeRPTtn6ps+mLSHe3ULdZ73UUs4uZ1Dg9vZwLApigtuyPmgEHdkup+hCmqMHh0h2kE4rN6CzW55wU0GxM6A1U6vXoOYzEofxDebq79XNhCVYVJogpUc7RZCByvDmOqBw15XvsNuP4NrKOVshZMvRSVEWm/bcXswQ69klU+hLkclphnOXpmBDEyDVtXYqmDCmKCrAINBMNYlkd
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199024)(186009)(1800799009)(82310400011)(36840700001)(40470700004)(46966006)(26005)(44832011)(426003)(336012)(16526019)(40480700001)(8936002)(8676002)(4326008)(36860700001)(47076005)(83380400001)(5660300002)(2616005)(1076003)(54906003)(7696005)(40460700003)(41300700001)(110136005)(478600001)(70206006)(70586007)(86362001)(316002)(356005)(36756003)(2906002)(966005)(81166007)(82740400003)(30864003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:57:07.2670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 433bc5f8-1cf0-448b-8687-08dbad2d4c9b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7459
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Santosh Shukla <santosh.shukla@amd.com>

IBS virtualization (VIBS) [1] feature allows the guest to collect IBS
samples without exiting the guest.

There are 2 parts to this feature
- Virtualizing the IBS register state.
- Ensuring the IBS interrupt is handled in the guest without exiting
  to the hypervisor.

IBS virtualization requires the use of AVIC or NMI virtualization for
delivery of a virtualized interrupt from IBS hardware in the guest.
Without the virtualized interrupt delivery, the IBS interrupt
occurring in the guest will not be delivered to either the guest or
the hypervisor.  When AVIC is enabled, IBS LVT entry (Extended
Interrupt 0 LVT) message type should be programmed to INTR or NMI.

So, when the sampled interval for the data collection for IBS fetch/op
block is over, VIBS hardware is going to generate a Virtual NMI, but
the source of Virtual NMI is different in both AVIC enabled/disabled
case.
1) when AVIC is enabled, Virtual NMI is generated via AVIC using
   extended LVT (EXTLVT).
2) When AVIC is disabled, Virtual NMI is directly generated from
   hardware.

Since IBS registers falls under swap type C [2], only the guest state is
saved and restored automatically by the hardware. Host state needs to be
saved and restored manually by the hypervisor. Note that, saving and
restoring of host IBS state happens only when IBS is active on host.  to
avoid unnecessary rdmsrs/wrmsrs. Hypervisor needs to disable host IBS
before VMRUN and re-enable it after VMEXIT [1].

The IBS virtualization feature for non SEV-ES guests is not enabled in
this patch. Later patches enable VIBS for non SEV-ES guests.

[1]: https://bugzilla.kernel.org/attachment.cgi?id=304653
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
     Instruction-Based Sampling Virtualization.

[2]: https://bugzilla.kernel.org/attachment.cgi?id=304653
     AMD64 Architecture Programmer’s Manual, Vol 2, Appendix B Layout
     of VMCB, Table B-3 Swap Types.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Co-developed-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 172 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h |   4 +-
 2 files changed, 173 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 20fe83eb32ee..6f566ed93f4c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -139,6 +139,22 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_AMD64_IBSFETCHCTL,		.always = false },
+	{ .index = MSR_AMD64_IBSFETCHLINAD,		.always = false },
+	{ .index = MSR_AMD64_IBSOPCTL,			.always = false },
+	{ .index = MSR_AMD64_IBSOPRIP,			.always = false },
+	{ .index = MSR_AMD64_IBSOPDATA,			.always = false },
+	{ .index = MSR_AMD64_IBSOPDATA2,		.always = false },
+	{ .index = MSR_AMD64_IBSOPDATA3,		.always = false },
+	{ .index = MSR_AMD64_IBSDCLINAD,		.always = false },
+	{ .index = MSR_AMD64_IBSBRTARGET,		.always = false },
+	{ .index = MSR_AMD64_ICIBSEXTDCTL,		.always = false },
+	{ .index = X2APIC_MSR(APIC_EFEAT),		.always = false },
+	{ .index = X2APIC_MSR(APIC_ECTRL),		.always = false },
+	{ .index = X2APIC_MSR(APIC_EILVTn(0)),		.always = false },
+	{ .index = X2APIC_MSR(APIC_EILVTn(1)),		.always = false },
+	{ .index = X2APIC_MSR(APIC_EILVTn(2)),		.always = false },
+	{ .index = X2APIC_MSR(APIC_EILVTn(3)),		.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
@@ -217,6 +233,10 @@ module_param(vgif, int, 0444);
 static int lbrv = true;
 module_param(lbrv, int, 0444);
 
+/* enable/disable IBS virtualization */
+static int vibs;
+module_param(vibs, int, 0444);
+
 static int tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
@@ -1050,6 +1070,20 @@ void disable_nmi_singlestep(struct vcpu_svm *svm)
 	}
 }
 
+void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept)
+{
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSFETCHCTL, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSFETCHLINAD, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPCTL, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPRIP, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA2, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSOPDATA3, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSDCLINAD, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_IBSBRTARGET, !intercept, !intercept);
+	set_msr_interception(&svm->vcpu, svm->msrpm, MSR_AMD64_ICIBSEXTDCTL, !intercept, !intercept);
+}
+
 static void grow_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1207,6 +1241,29 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		/* No need to intercept these MSRs */
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+
+		/*
+		 * If hardware supports VIBS then no need to intercept IBS MSRS
+		 * when VIBS is enabled in guest.
+		 */
+		if (vibs) {
+			if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_IBS)) {
+				svm_ibs_msr_interception(svm, false);
+				svm->ibs_enabled = true;
+
+				/*
+				 * In order to enable VIBS, AVIC/VNMI must be enabled to handle the
+				 * interrupt generated by IBS driver. When AVIC is enabled, once
+				 * data collection for IBS fetch/op block for sampled interval
+				 * provided is done, hardware signals VNMI which is generated via
+				 * AVIC which uses extended LVT registers. That is why extended LVT
+				 * registers are initialized at guest startup.
+				 */
+				kvm_apic_init_eilvt_regs(vcpu);
+			} else {
+				svm->ibs_enabled = false;
+			}
+		}
 	}
 }
 
@@ -2888,6 +2945,11 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
+
+	case MSR_AMD64_IBSCTL:
+		rdmsrl(MSR_AMD64_IBSCTL, msr_info->data);
+		break;
+
 	default:
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
@@ -4038,19 +4100,111 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
+/*
+ * Since the IBS state is swap type C, the hypervisor is responsible for saving
+ * its own IBS state before VMRUN.
+ */
+static void svm_save_host_ibs_msrs(struct vmcb_save_area *hostsa)
+{
+	rdmsrl(MSR_AMD64_IBSFETCHLINAD, hostsa->ibs_fetch_linear_addr);
+	rdmsrl(MSR_AMD64_IBSOPRIP, hostsa->ibs_op_rip);
+	rdmsrl(MSR_AMD64_IBSOPDATA, hostsa->ibs_op_data);
+	rdmsrl(MSR_AMD64_IBSOPDATA2, hostsa->ibs_op_data2);
+	rdmsrl(MSR_AMD64_IBSOPDATA3, hostsa->ibs_op_data3);
+	rdmsrl(MSR_AMD64_IBSDCLINAD, hostsa->ibs_dc_linear_addr);
+	rdmsrl(MSR_AMD64_IBSBRTARGET, hostsa->ibs_br_target);
+	rdmsrl(MSR_AMD64_ICIBSEXTDCTL, hostsa->ibs_fetch_extd_ctl);
+}
+
+/*
+ * Since the IBS state is swap type C, the hypervisor is responsible for
+ * restoring its own IBS state after VMEXIT.
+ */
+static void svm_restore_host_ibs_msrs(struct vmcb_save_area *hostsa)
+{
+	wrmsrl(MSR_AMD64_IBSFETCHLINAD, hostsa->ibs_fetch_linear_addr);
+	wrmsrl(MSR_AMD64_IBSOPRIP, hostsa->ibs_op_rip);
+	wrmsrl(MSR_AMD64_IBSOPDATA, hostsa->ibs_op_data);
+	wrmsrl(MSR_AMD64_IBSOPDATA2, hostsa->ibs_op_data2);
+	wrmsrl(MSR_AMD64_IBSOPDATA3, hostsa->ibs_op_data3);
+	wrmsrl(MSR_AMD64_IBSDCLINAD, hostsa->ibs_dc_linear_addr);
+	wrmsrl(MSR_AMD64_IBSBRTARGET, hostsa->ibs_br_target);
+	wrmsrl(MSR_AMD64_ICIBSEXTDCTL, hostsa->ibs_fetch_extd_ctl);
+}
+
+/*
+ * Host states are categorized into three swap types based on how it is
+ * handled by hardware during a switch.
+ * Below enum represent host states which are categorized as Swap type C
+ *
+ * C: VMRUN:  Host state _NOT_ saved in host save area
+ *    VMEXIT: Host state initializard to default values.
+ *
+ * Swap type C state is not loaded by VMEXIT and is not saved by VMRUN.
+ * It needs to be saved/restored manually.
+ */
+enum {
+	SWAP_TYPE_C_IBS = 0,
+	SWAP_TYPE_C_MAX
+};
+
+/*
+ * Since IBS state is swap type C, hypervisor needs to disable IBS, then save
+ * IBS MSRs before VMRUN and re-enable it, then restore IBS MSRs after VMEXIT.
+ * This order is important, if not followed, software ends up reading inaccurate
+ * IBS registers.
+ */
+static noinstr u32 svm_save_swap_type_c(struct kvm_vcpu *vcpu)
+{
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
+	struct vmcb_save_area *hostsa;
+	u32 restore_mask = 0;
+
+	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
+
+	if (to_svm(vcpu)->ibs_enabled) {
+		bool en = amd_vibs_window(WINDOW_START, &hostsa->ibs_fetch_ctl, &hostsa->ibs_op_ctl);
+
+		if (en) {
+			svm_save_host_ibs_msrs(hostsa);
+			restore_mask |= 1 << SWAP_TYPE_C_IBS;
+		}
+	}
+	return restore_mask;
+}
+
+static noinstr void svm_restore_swap_type_c(struct kvm_vcpu *vcpu, u32 restore_mask)
+{
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
+	struct vmcb_save_area *hostsa;
+
+	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
+
+	if (restore_mask & (1 << SWAP_TYPE_C_IBS)) {
+		svm_restore_host_ibs_msrs(hostsa);
+		amd_vibs_window(WINDOW_STOPPING, &hostsa->ibs_fetch_ctl, &hostsa->ibs_op_ctl);
+	}
+}
+
 static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 restore_mask;
 
 	guest_state_enter_irqoff();
 
 	amd_clear_divider();
 
-	if (sev_es_guest(vcpu->kvm))
+	if (sev_es_guest(vcpu->kvm)) {
 		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
-	else
+	} else {
+		restore_mask = svm_save_swap_type_c(vcpu);
 		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
+		if (restore_mask)
+			svm_restore_swap_type_c(vcpu, restore_mask);
+	}
+
 	guest_state_exit_irqoff();
 }
 
@@ -4137,6 +4291,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	/* Any pending NMI will happen here */
 
+	/*
+	 * Disable the IBS window since any pending IBS NMIs will have been
+	 * handled.
+	 */
+	if (svm->ibs_enabled)
+		amd_vibs_window(WINDOW_STOPPED, NULL, NULL);
+
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_after_interrupt(vcpu);
 
@@ -5225,6 +5386,13 @@ static __init int svm_hardware_setup(void)
 			pr_info("LBR virtualization supported\n");
 	}
 
+	if (vibs) {
+		if ((vnmi || avic) && boot_cpu_has(X86_FEATURE_VIBS))
+			pr_info("IBS virtualization supported\n");
+		else
+			vibs = false;
+	}
+
 	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c7eb82a78127..c2a02629a1d1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	46
+#define MAX_DIRECT_ACCESS_MSRS	62
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -260,6 +260,7 @@ struct vcpu_svm {
 	unsigned long soft_int_old_rip;
 	unsigned long soft_int_next_rip;
 	bool soft_int_injected;
+	bool ibs_enabled;
 
 	u32 ldr_reg;
 	u32 dfr_reg;
@@ -732,6 +733,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept);
 
 /* vmenter.S */
 
-- 
2.34.1

