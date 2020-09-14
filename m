Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24471269643
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgINUTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:19:49 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:3544
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbgINUTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:19:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLBG/MzvK4VehvzVxSrvnbZQ4gbbT2WDOPYFFi8JLTwm/cOpB07BKxBF4WXP0W+6SX5mpD4IVGJmg6NOURLdKw6AuTJt1gkdzv2rDaMu25CYKMii8+udl7Odm5xFcrBf9rm6tgkqp8gTO7BSYGmV35nGarKWNQXRx2s16f4xli4OW/ahjhPfSDvbsls/z/EC7M+jCpWIa6IuQEL/vkpWeqU+EoJ4HgC2bIDdPx/VRPIvRoqJ39Z4cTHMlpGcmjfs/kTi7T5myd6IlOjrCm4g6Kx9fQ6eXqL3BUnlliTULM6VXNZP9yOLqrF0iqSCRYsVucgljM5xTJR0zjRH3rE30A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35w8E58b9dhvpvgobJTsgN+taG0QHz/zkZ5Qz6w34Y0=;
 b=AKUylFCgYnaJovhkQnL6cyC4A2wuG/BsGlrLeVGVw+8XfhStE8x0yWs+kQ2Vai04kVmYwhaNMd8LS/ebMMenIIYOAM62S9S1YU15Q7DzhaP9AWXwO7sKdjHZ0FMYGQU5PXRSTXtnZhouzJNeAFAbNWFpCjE62OOtxB1b8EDea9+0Ap8JDZYijvO1ubMMmOKy9kgXAKpq31FwPR8wqV1rbH9v+sg0/RYOtQ+uio89mYJpIyYDURAJHjV3JI/mfP5dGl/nZFdioZY4sDlCulB9M4WcEpEAQQPI9nkX4KhwbZrmSQGC6UotfheoLtYh0QfdW7j9JaX3HQNkAH6h/Upf/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35w8E58b9dhvpvgobJTsgN+taG0QHz/zkZ5Qz6w34Y0=;
 b=Bbi6rN9v2tj1XFS7CM6QZM6a+S3yXXu6H0rnvTbY5P7xEqHYXVZfk7fHLSO6QpA1y/EMTbf2Pqw1XL80a/WdcL93EfTUx13UcDCcj4+ifuTxKu+302HnK8YOxQZtM/WmW0jnJkWxQhZ8fmkTaabp8d6KwIGbXUODUHUMfVppSb4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:18:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:18:46 +0000
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
Subject: [RFC PATCH 21/35] KVM: SVM: Add support for EFER write traps for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:35 -0500
Message-Id: <240ce8d7c9bd84adf66a4a0625150a1ae215345e.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0082.namprd12.prod.outlook.com
 (2603:10b6:802:21::17) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0082.namprd12.prod.outlook.com (2603:10b6:802:21::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:18:45 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85853039-1052-4ad0-7b07-08d858eb6265
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29881F8061401226DB12B031EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NjvM3rDEHRCKKFneHV6sadmU58MIj9WIrOih7p1zQ6wpniiMNXw4YGtS3D02rUVcIvbEaNOsKurAoSl+x9nce1AaudFua2Zw+ttZrBYU0JzIhwecN090sJ0c8/6SHFAxvDlmy6ksbsqmDc8WtFyr8NM4Z0CwBa57KT8+3R+pefpJZUY/F2ZzsUVtgW0sPL4KgjAYj4Tcti7EMKJWOPUUzwLP3vjaAxUpQuae9iriknZCBzjcA727YQZEeYVB0B3lAXpwQc1fCbYZBQssrEfcvIa8cNlQj6Lygs5DKQHQPFQR7PyDze7OdAcjmG0M9xmHzBcixISbT61CgMy5coKPuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qAKgg8xcjIbSh+pTrSbJrc658oPayChCOzw4Y02m35lYh72d1MjItkui+YVcMgTyITN87exeLlWl+f1avJkV637b+NKIPWZ7PWSqfETgx3RNnPHBV7WDytSI4mZFcR9Le8hoBVKjIv1DDYQJj+VxD3FU6En+p+vsLC8n0OCC0x9vexywS1y/SG/Wbv1cDChylwjz6DDj60pjXVkhGZiGFhj1dUIO/l46qU7vHomwWY4hwUmOI5/y3Cjd01jRwzFWFihLNIXvfXcfgQ4xL7PnueYo8Z64QEUTDYPYVLwQe3M3ft5aW5RN5NenagOPoeb6Fr0aYYFSGhPTbe684pm+Nm4Tu8zwosiT0104K/pADqtH5I+ZdPrPiJgXvqW2+W2mpkdIZlXwdWZe8XFJhqK97DvwjDcs/QrAcR9X1quNFfDjmvfITZi9dYhTi+2ss51yrRipCCdaU8Z40qU/yQlz9du1gE3FdcDSEk99Hs8IBVhsdsiBgUTCew9DIJv0Tn6quBRCEguucMBeT3rET3WeXxzYezKIY+3BiO2d+4ZQKNiMEvsLmkPCHncMwHBxmcDkdVKP1Q6ib35eyjf828jtAZQIylgwteshfajkpiYLiMveiaV/ypWL2tHBg2wQh0r7oazW7B3buff2sUJFUj+AFA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85853039-1052-4ad0-7b07-08d858eb6265
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:18:46.5931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSDFLNJtfz2pSs4mGwFUrr4Ct53WR6QzbVrZYn5pkDtWUWoUz22PDo2rLCUtUutUuz2+Yal/MFZ4dUFBSj/7rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of EFER write access is not
recommended. EFER interception occurs prior to EFER being modified and
the hypervisor is unable to modify EFER itself because the register is
located in the encrypted register state.

SEV-ES guests introduce a new EFER write trap. This trap provides
intercept support of an EFER write after it has been modified. The new
EFER value is provided in the VMCB EXITINFO1 field, allowing the
hypervisor to track the setting of the guest EFER.

Add support to track the value of the guest EFER value using the EFER
write trap so that the hypervisor understands the guest operating mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/svm.h |  2 ++
 arch/x86/kvm/svm/svm.c          | 12 ++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 4 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7320a9c68a5a..b535b690eb66 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1427,6 +1427,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
+int kvm_track_efer(struct kvm_vcpu *vcpu, u64 efer);
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 0bc3942ffdd3..ce937a242995 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -77,6 +77,7 @@
 #define SVM_EXIT_MWAIT_COND    0x08c
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
+#define SVM_EXIT_EFER_WRITE_TRAP		0x08f
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
@@ -183,6 +184,7 @@
 	{ SVM_EXIT_MONITOR,     "monitor" }, \
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
+	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ac64a5b128b2..ac467225a51d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2466,6 +2466,17 @@ static int cr8_write_interception(struct vcpu_svm *svm)
 	return 0;
 }
 
+static int efer_trap(struct vcpu_svm *svm)
+{
+	int ret;
+
+	ret = kvm_track_efer(&svm->vcpu, svm->vmcb->control.exit_info_1);
+	if (ret)
+		return ret;
+
+	return kvm_complete_insn_gp(&svm->vcpu, 0);
+}
+
 static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	msr->data = 0;
@@ -2944,6 +2955,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 674719d801d2..b65bd0c986d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1480,6 +1480,18 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
+int kvm_track_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	struct msr_data msr_info;
+
+	msr_info.host_initiated = false;
+	msr_info.index = MSR_EFER;
+	msr_info.data = efer;
+
+	return set_efer(vcpu, &msr_info);
+}
+EXPORT_SYMBOL_GPL(kvm_track_efer);
+
 void kvm_enable_efer_bits(u64 mask)
 {
        efer_reserved_bits &= ~mask;
-- 
2.28.0

