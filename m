Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44C030444C
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 18:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389808AbhAZIUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 03:20:54 -0500
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:25316
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389801AbhAZIUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 03:20:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Deoxl0JwdIlTG5ZtphPdbZ3xwceAhswmryq1rBBHiQsOLsQay8L7Xz8A6MPe+/KOO7tt+tbddAvuFHoS0LaRThRBJI1bZ0G6//nXv1wLc2T6nZTQ/CifuN8cPrOQKYfxfFk+XxMEo4Qek0kyp/JtXGzxpflySzO3ZjG867dutavOTDXnX8E8RQHaL5KwQj912vaDEPesLomo2/zEF/32jRiMRG0l2cHMVMRjcMEsGZNsP3dE0ufDqlV3PxGcx8/tlGZPZHwovfoVRMAPW4POyzkEYYO47CNkmSGUQd1diFE1w36sSJxp+avoCR0S515U7yaBugsSdTlkd0ZUPS7I/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Pgn5UNdvAPrDKA99TEBy7v0D5r818gcqKfPK27X6QM=;
 b=gxvIE19OPx7kGg69TjyqZK+nYd3NH0gj2CAdq+fsToOlnJDezFRses6qxvSyh+B/MU/bnJ8WE1om4prq6ZbtnEZh+zOvnnrF8u74emn9n4wZD+Rpfk4TgKWlMEhd+ALJfAhKfxn4ikIpnHR1WlCwqi5vt7jyjV32VjTf9UPqtuiEW6cBqjA0/nAZsxvNCb61i6s4XFphg/JQwXYRImH+Fn4Kdn8LVV+rZpNRIfUGCDIkUM7FrhRZKcgyqzGBzFsXaSQqbYEvXmRL48XoK6gx/LgRgke7I6Eo2Zs4slYyqDRJXyISEVjBf3ahbBOLCP1BbZuf87xx38dlWegMv9FrNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Pgn5UNdvAPrDKA99TEBy7v0D5r818gcqKfPK27X6QM=;
 b=YQx6dl1nq3+RXRDkOONcJG4OoIoy1ivoWwnjWP9SQZRfjRP4nPWIX/MJzZoeLaa+Ame5KOnFHrdHRPpYaahjqCi0PKsvQ2JIDYH8v++ZbAuNLWtoEoK8eFiot122G4vdbLYwogWNGIcInyQnoOHSf3lmegqivPcCGmIMS6niyZI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB0214.namprd12.prod.outlook.com (2603:10b6:910:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 26 Jan
 2021 08:19:26 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 08:19:26 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v3 2/4] KVM: SVM: Add emulation support for #GP triggered by SVM instructions
Date:   Tue, 26 Jan 2021 03:18:29 -0500
Message-Id: <20210126081831.570253-3-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126081831.570253-1-wei.huang2@amd.com>
References: <20210126081831.570253-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: AM4P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::20) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by AM4P190CA0010.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Tue, 26 Jan 2021 08:19:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f00ee8e8-8bf6-4b77-d3cd-08d8c1d3180f
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB021422A02485B3B42832AEE5CFBC0@CY4PR1201MB0214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WYiLdz9fgDeJWSrVYHyzkP+r/7Kyb04IoMVJrIqdds3jU1B5B1TlYZLnwye0y7FmsHl1TNVZWoWhtPt61h6kBJ+nLSM4LneT9gAeTN3yWaqwJYpLWfc+r2VfeftkwM5JxD/rX4EIGmCMAAxem35eZDEcFOaG4yRGxsyKd30Vea0UTWopAuVKHrasXzJNKw6ygq/rUD+ORiJbBn7ONqtvHhmcTNSDiztNoG4b9YndspgLHyJgpdClqtMB6B2y5RsbLwmwLw3u7Ji6aIqvWQtDbnFNLreOyNsizZkUcC6RJPc6yO4hy7m3eRxu99Dz1z2iANWiPugbl+b9TiQb2VnDdSl+gwPnsRFUqIRJ+tJODXH2j2+zKEP3Z1Awfrss42Wv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(36756003)(66556008)(6486002)(8676002)(66476007)(66946007)(52116002)(86362001)(5660300002)(6512007)(2906002)(956004)(186003)(26005)(16526019)(478600001)(83380400001)(8936002)(4326008)(6916009)(316002)(6506007)(7416002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ibsYtXjuFRKqqttI0nHDfree0VWwrz2V6yrNvaijugYv9pc7k2dp8rCt0jdA?=
 =?us-ascii?Q?FExT1Jxs/jiNtWJ8ak8SxlJifMjhnLnuiQRt0Ia1Gqi9cyS5Bq1H5rCr2dty?=
 =?us-ascii?Q?dkpAvCPVtmR73LZcPLoHa0L6/kt1h/Jhm1MsXDrhGrfYGExe1Y+tV7klQcnN?=
 =?us-ascii?Q?BA7ml9ZJMncO+m/HO5+ViDSNbhJJAp9ssIZlpgr0aZaakBjkF7P9wguGaept?=
 =?us-ascii?Q?gTmO7485tfhpdBfkEU1IB8N7odoQfMTbronxJqyRbuMMlhhpj1JCC5FT0H0z?=
 =?us-ascii?Q?BuvwnStc9GADE4+z4NhKRTt5qAehYareCkLiRBpgKg5Ywp2wyd3UvRikpesl?=
 =?us-ascii?Q?Kuw0BayrulDZ6Mm96Nr2IEoJBMqW4X5j6yeZ4lD395vKYVhlDIUgE8DmvVSK?=
 =?us-ascii?Q?jZJSkAe/VvlHFSXXl5LM+gID6s0c+KR6lOUFEthcakGEXQsdtJO8WuAAoD7b?=
 =?us-ascii?Q?vTg522N+hvOJumModS6nlyEinM183wgQcSBlz1AwV813BfxzqYyn96C/afJK?=
 =?us-ascii?Q?bPTktwMePxhL8s5O59Ot8xo1ILIGQx08DcXpAyzqeKkfScVFrCLvZLZKlli/?=
 =?us-ascii?Q?xyl2I3DN2j3xLg4vAdfRNaquC6Bc7Kpc4uKbFiMgIZ7CommPwLxCYama+ren?=
 =?us-ascii?Q?9IDaoa4pUIgrl6FDhat77A/vIK5hGlbbnIaFpORBSnPDn/qf8cbd5oqPQX9C?=
 =?us-ascii?Q?kSiDULmCMsFACqXLHAZ5PkOfN11YF8VeU1b+YmsjabhKw+V+sO8N3yQ+Lfom?=
 =?us-ascii?Q?pMV8vSkRbdjhV7pLauOT+/sp41VV0IOLhqI6E21vVQi2qTztmJu28nvEBgOW?=
 =?us-ascii?Q?gcCr8A2wOrYyJVEjRTtLaHJIsepraDlryVvCfw/NVklrYVISsRyJIi3KZgAc?=
 =?us-ascii?Q?92bpoZqLWsWBXSExD0PlS48BQt+TpUc9ovd3pEg1nhN3zxxdF6ACya5kp4vc?=
 =?us-ascii?Q?9aLya/GtB1iH2+84gx9GhdBc6eiDg1D1IvurCRux9Jmih7o2qNdmzGWvgVjI?=
 =?us-ascii?Q?M3MIG4NGYa+4jI4D5APZYcKx0bDPFoiOWievXwnuHSVoVpjqIo0sKPwfr4H9?=
 =?us-ascii?Q?j99ydPW2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f00ee8e8-8bf6-4b77-d3cd-08d8c1d3180f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 08:19:26.1204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1dbCZj2Qq9Rq/RQ+TZeMtLQCGYargZX6k89oEBN85xSZNitdaaxWQSAgenizEnm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0214
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bandan Das <bsd@redhat.com>

While running SVM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
before checking VMCB's instruction intercept. If EAX falls into such
memory areas, #GP is triggered before VMEXIT. This causes problem under
nested virtualization. To solve this problem, KVM needs to trap #GP and
check the instructions triggering #GP. For VM execution instructions,
KVM emulates these instructions.

Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 109 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ef171790d02..e5ca01e25e89 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -200,6 +200,8 @@ module_param(sev_es, int, 0444);
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
+bool svm_gp_erratum_intercept = true;
+
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
 static void svm_complete_interrupts(struct vcpu_svm *svm);
@@ -288,6 +290,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		if (!(efer & EFER_SVME)) {
 			svm_leave_nested(svm);
 			svm_set_gif(svm, true);
+			/* #GP intercept is still needed in vmware_backdoor */
+			if (!enable_vmware_backdoor)
+				clr_exception_intercept(svm, GP_VECTOR);
 
 			/*
 			 * Free the nested guest state, unless we are in SMM.
@@ -309,6 +314,10 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
+	/* Enable #GP interception for SVM instructions */
+	if (svm_gp_erratum_intercept)
+		set_exception_intercept(svm, GP_VECTOR);
+
 	return 0;
 }
 
@@ -1957,24 +1966,6 @@ static int ac_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
-static int gp_interception(struct vcpu_svm *svm)
-{
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	u32 error_code = svm->vmcb->control.exit_info_1;
-
-	WARN_ON_ONCE(!enable_vmware_backdoor);
-
-	/*
-	 * VMware backdoor emulation on #GP interception only handles IN{S},
-	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
-	 */
-	if (error_code) {
-		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
-		return 1;
-	}
-	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
-}
-
 static bool is_erratum_383(void)
 {
 	int err, i;
@@ -2173,6 +2164,88 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	return nested_svm_vmrun(svm);
 }
 
+enum {
+	NONE_SVM_INSTR,
+	SVM_INSTR_VMRUN,
+	SVM_INSTR_VMLOAD,
+	SVM_INSTR_VMSAVE,
+};
+
+/* Return NONE_SVM_INSTR if not SVM instrs, otherwise return decode result */
+static int svm_instr_opcode(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
+	if (ctxt->b != 0x1 || ctxt->opcode_len != 2)
+		return NONE_SVM_INSTR;
+
+	switch (ctxt->modrm) {
+	case 0xd8: /* VMRUN */
+		return SVM_INSTR_VMRUN;
+	case 0xda: /* VMLOAD */
+		return SVM_INSTR_VMLOAD;
+	case 0xdb: /* VMSAVE */
+		return SVM_INSTR_VMSAVE;
+	default:
+		break;
+	}
+
+	return NONE_SVM_INSTR;
+}
+
+static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
+{
+	int (*const svm_instr_handlers[])(struct vcpu_svm *svm) = {
+		[SVM_INSTR_VMRUN] = vmrun_interception,
+		[SVM_INSTR_VMLOAD] = vmload_interception,
+		[SVM_INSTR_VMSAVE] = vmsave_interception,
+	};
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm_instr_handlers[opcode](svm);
+}
+
+/*
+ * #GP handling code. Note that #GP can be triggered under the following two
+ * cases:
+ *   1) SVM VM-related instructions (VMRUN/VMSAVE/VMLOAD) that trigger #GP on
+ *      some AMD CPUs when EAX of these instructions are in the reserved memory
+ *      regions (e.g. SMM memory on host).
+ *   2) VMware backdoor
+ */
+static int gp_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	u32 error_code = svm->vmcb->control.exit_info_1;
+	int opcode;
+
+	/* Both #GP cases have zero error_code */
+	if (error_code)
+		goto reinject;
+
+	/* Decode the instruction for usage later */
+	if (x86_decode_emulated_instruction(vcpu, 0, NULL, 0) != EMULATION_OK)
+		goto reinject;
+
+	opcode = svm_instr_opcode(vcpu);
+
+	if (opcode == NONE_SVM_INSTR) {
+		WARN_ON_ONCE(!enable_vmware_backdoor);
+
+		/*
+		 * VMware backdoor emulation on #GP interception only handles
+		 * IN{S}, OUT{S}, and RDPMC.
+		 */
+		return kvm_emulate_instruction(vcpu,
+				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
+	} else
+		return emulate_svm_instr(vcpu, opcode);
+
+reinject:
+	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+	return 1;
+}
+
 void svm_set_gif(struct vcpu_svm *svm, bool value)
 {
 	if (value) {
-- 
2.27.0

