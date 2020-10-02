Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD50D2818B0
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbgJBRF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:05:59 -0400
Received: from mail-eopbgr770051.outbound.protection.outlook.com ([40.107.77.51]:48802
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388493AbgJBRFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:05:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SluBLR5V9LnvxxiA58tEGIfVm1zkKzCN3nYFFWu9H+DaXnXglojEQEmXeVAte1ATs62/zeb7r6SSen4Q8X39NI+8AchsLzreAYIhlinfhUPUx9nu17mTpIoWeSaUylOCV0o28rdHYiQsLatpvNUmgrDS2F4jcLsGTQXdN5TeOF2g5nrcpWsPnQmAZrbEL+dofLIHiO8IjC7IxX1iNKmeJWnCRXObiGk0F3xCX86ItblzjSWnlZJZBFlamIkSlMyzS3gq1/V8Epe7/7vt92V/dmYpTbQps4e/ADEe55KmR+D8JU9h/GLcx/d5qrMd5TfHL/MFJRrsPFODXm5pK9bZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gx+54sh1C6HOZl6AYbeqOwR5yWhd3zgEbsHB5AfUG3E=;
 b=b6KhSi/r8pJ6ns92FCk7oz3OiK8GSIu6YJbgbg9Z/MaZKY9YPPuqs6E4W2Edf3ZZ1C8+Ic48RbxRmXHJl8S/uJcBNGUHFj0I7MsrhT/e4Ly/3Ij77aQWEHXOMuGgeFBMVrvGUGL3y6jUzOXlKngVfS2XbmMTmGUm3iEWVaeVtI7LMDZzs5c0Hp7QwKGUUbsUykd57Ki9PQNP2LMe0fYukgg2sZDi3DS5/HUOdA2aQrh5CfObf9Z+CiSFt0cSaMyDzFLgU/qT+td6lLBUhwOz8crCJnJj4nWhPbaUWHEVOw0z/cutA3OQUpyrfsLYcwPxopmnqlNMi5lfEYmFzOZ6oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gx+54sh1C6HOZl6AYbeqOwR5yWhd3zgEbsHB5AfUG3E=;
 b=MSjISZrLfkN651ypY6EuiZMuIqV+/9P19YH6Cs/G3AgtXQNpzghjOsAZ75u43Cnn4TkvlFeKFiQsStiLkrCVzbYqe0K9oc2lkCg5kX4c22mbv/FGsB5Z4FH6cwPLN85yQ1Az5s9hOpACGr5VVSLhomhHfeSB2+5clJtkLSkreuc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Fri, 2 Oct 2020 17:05:53 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:05:53 +0000
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
Subject: [RFC PATCH v2 19/33] KVM: SVM: Add support for EFER write traps for an SEV-ES guest
Date:   Fri,  2 Oct 2020 12:02:43 -0500
Message-Id: <d8679ec5361871a07779e46cf0cb6cd69830d532.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0066.namprd02.prod.outlook.com
 (2603:10b6:803:20::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0201CA0066.namprd02.prod.outlook.com (2603:10b6:803:20::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Fri, 2 Oct 2020 17:05:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47e42867-7721-4aeb-8cdf-08d866f56b3d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4218CB3A4B30C135038CA5EEEC310@DM6PR12MB4218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tA3PqkTI2cZX3Qzudn/qUvEYyCnxD2miC3PE9t9SyElXJVIeiLUaKopdl9+koQLfOpr+pteroBLyb2gBKbB1Jo2U/3wJOg4SuElSwZtK1Zu9HdZ/CSTvDhuxKq1owa4IS2Bv6GBKSBPvJZq1gaYjYQxRm36asz3c5Bfqnw/STK7J0mhywaNZ1wha+kbKaye16VGDvfnGpckv2EjtqH0uHsGNpXof/D0IjixiT6FYqC61/L8MNlM1f9iQ49RMrvQXvf8+rTbLbK5SISEcF5Rr7+ayeRxCmcjVdK4QGy29DR8sNCkI5CSOMhGXexiBPaJfpmpVJtTAWGk8ZzyM+rHurQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(6666004)(8676002)(83380400001)(6486002)(2616005)(66556008)(956004)(66476007)(66946007)(52116002)(7696005)(4326008)(36756003)(5660300002)(8936002)(16526019)(186003)(2906002)(54906003)(316002)(26005)(7416002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KVDJdUTqXqvrsk0FkKRB0VXR3/K1ChxfXRLBJ/cGru0Y4oxDA3vJgRuxGl/j2YsG8hPt0/CaPmx9zNaMWBiWjKTq3B5wIOSNVWgcz6k655Dk6/X5l2QMhYOpTIuuCwD8LCtSKytvf6y2ZFAgmwiDjbp4qaf5EG0B0jaOmuUNYhOeji/NBBHQq4wtFB0df5bRC+Gy1Wr/2CuQl+QnGO/3lbSIOMy3kFnDgvXRRDb4lLttMWTCMSjm0Qb8nV9DpgFRaaHDyaXnyV86wZewHY8w20O3Wha/RWc71hzR44Vz4BBI4KXqtQrqq4GLk7a8HkpWHkW9cvhw0NPv2r8jE0ZdRlmDGoGkX8zmfOWK1vt90/Ftksu3KDyIFwXmrq7Oo8BjymQCiEfR2BzxQ3UNhMpaop+nLyhSAx0TEaAN1+Jxoug6Fc1sz4ncD4h3/AiWZ/EN/fUfiHW+VO0Sf2hk7BPVAxdEOrg4BnYnMxWa5x2zV+tmTeNJhWXzdHwiHf0Uy9tYGQ2BazEKjJz0Ehj1R0+wntJHHDOxGbyAr3MGCtzYDp2sbNuMRnekorPEmxxvRBv8Q5TQW2WJqq0D49AgJkcqY1G1bmhDkWqflGNHASVq6gsYeo6pfLNRKrZLKyujRvXWpWY6S1Erz4mma/0BOtntog==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e42867-7721-4aeb-8cdf-08d866f56b3d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:05:52.9369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w02HEOtYJJIsJ/Ix0cS/tqW4P8NBWKBygU7R6XAzA1cLg8VeVaZh+51PIQNdQXefjNtQBH4wKK0Kr2LtpI6xOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV-ES guests, the interception of EFER write access is not
recommended. EFER interception occurs prior to EFER being modified and
the hypervisor is unable to modify EFER itself because the register is
located in the encrypted register state.

SEV-ES support introduces a new EFER write trap. This trap provides
intercept support of an EFER write after it has been modified. The new
EFER value is provided in the VMCB EXITINFO1 field, allowing the
hypervisor to track the setting of the guest EFER.

Add support to track the value of the guest EFER value using the EFER
write trap so that the hypervisor understands the guest operating mode.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/svm.h |  2 ++
 arch/x86/kvm/svm/svm.c          | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 3a730238a646..73ff94a28911 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -77,6 +77,7 @@
 #define SVM_EXIT_MWAIT_COND    0x08c
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
+#define SVM_EXIT_EFER_WRITE_TRAP		0x08f
 #define SVM_EXIT_INVPCID       0x0a2
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
@@ -184,6 +185,7 @@
 	{ SVM_EXIT_MONITOR,     "monitor" }, \
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
+	{ SVM_EXIT_EFER_WRITE_TRAP,	"write_efer_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 14285bb832de..f5bf40c7ba74 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2531,6 +2531,25 @@ static int cr8_write_interception(struct vcpu_svm *svm)
 	return 0;
 }
 
+static int efer_trap(struct vcpu_svm *svm)
+{
+	struct msr_data msr_info;
+	int ret;
+
+	/*
+	 * Clear the EFER_SVME bit from EFER. The SVM code always sets this
+	 * bit in svm_set_efer(), but __kvm_valid_efer() checks it against
+	 * whether the guest has X86_FEATURE_SVM - this avoids a failure if
+	 * the guest doesn't have X86_FEATURE_SVM.
+	 */
+	msr_info.host_initiated = false;
+	msr_info.index = MSR_EFER;
+	msr_info.data = svm->vmcb->control.exit_info_1 & ~EFER_SVME;
+	ret = kvm_set_msr_common(&svm->vcpu, &msr_info);
+
+	return kvm_complete_insn_gp(&svm->vcpu, ret);
+}
+
 static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	msr->data = 0;
@@ -3039,6 +3058,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_EFER_WRITE_TRAP]		= efer_trap,
 	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
-- 
2.28.0

