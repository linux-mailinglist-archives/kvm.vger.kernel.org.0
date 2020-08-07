Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EB223E55D
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 02:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgHGArs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 20:47:48 -0400
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:12897
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726933AbgHGArp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 20:47:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBT4sgyve1ja0W9Mf9IgGNzdwfQZoiIz8wjgEuEH0NDkHpU0pQcakLw30Y8r1819m4US5gD/BjA+7Q7TrlhO4C5dxVMiQ6P2COWDETS1aj40fBQ4Qy6u65WzhvLqWjoPYYg5WVWxaLA0dOPh9LJbjuq6CgOQb2sv7AgFmnngBfbuDEQJxngR/vH32HNgqUBY6ivm5dd1GV3/jTnLESy/NV5xuyiIfKbI17S5sf0KSTwPihoveln6ZhQBs5B6yMCmFyR2A5is1DjDU+JF88UFE+O3hqQsaw/2695499GcDzS6kpQu5jb8XIz55NYET/bMnheWeA3R0POjf6PJ/LxRRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtemhJXG++vrCo084ayRfMhauo89lXnlsKI/xI4+f7Y=;
 b=OUGOaqHnkBQFMJrCu7nxKixfjAHeQAUwSI3zx90mVCakJEpnwuw+QgzEd06zcCeLWv+4r08CLi4zIUrZzvXMYv6aqYhBKayDDBvWt+gSvXGk12c6LcCVIxVzvAHO9PLg/yPi+vE4AREnBe4ww4ROV4Rbg+Lb/qrobChVr9jXr6DUbgddM3IXEzzZKeWEhf+AezepJzlbbtf7s6sXEBop2sviNKNMy9sLW3pjltUv4iVEiZlN4T2sQRQZOJfEA5dT/o+F0oAP31GRLu9hmS6ttBvjtDcw780aGd/0dsysR8Je6vcAhPJQfwGC+7jSpVTa5zMAgcOrGRLeDLWmmBALTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtemhJXG++vrCo084ayRfMhauo89lXnlsKI/xI4+f7Y=;
 b=wRI/oGBR1leYNCcEuQ745D/YT4Os0b52lCSyIWF8bie4FCEhk8JnCR4aD5660u51IGt+/cKn04+ZNst3UVHCKHe6dUCy6jertTvkE39ZdA9IvPIUeK6bKNRw/aZiAZ/dFRJHN4xaOz7nSG121WkrQaL+hlXtmVTu5MsJvLjcQro=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4479.namprd12.prod.outlook.com (2603:10b6:806:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 00:47:42 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3239.023; Fri, 7 Aug 2020
 00:47:42 +0000
Subject: [PATCH v4 12/12] KVM:SVM: Enable INVPCID feature on AMD
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de
Date:   Thu, 06 Aug 2020 19:47:40 -0500
Message-ID: <159676126090.12805.5961438692882905158.stgit@bmoger-ubuntu>
In-Reply-To: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
References: <159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0009.namprd08.prod.outlook.com
 (2603:10b6:803:29::19) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN4PR0801CA0009.namprd08.prod.outlook.com (2603:10b6:803:29::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 00:47:41 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b660ee9d-d818-4088-0e7d-08d83a6b7dc3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44798BB86038D694F3AF9D6595490@SA0PR12MB4479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lYaPpkStke8ozVIdwaCXs5F2FLKtlbzRwXsndweFAg9L1MgSVs5jvMC1Whw1k/BZEE2FU903mno9iq/mU3DgvQKBYV4apmXWwDIjb5JQRA7qIHrb+VWFlm62gBFK82/MM/uVUqsSd+6h0OB6ArDvb8+PiULv7RFPL1Ax5Ydatbv2JHOf7vCHG+sc5JSTQ5RyMUvRXFOFJQyYilqbSIVI/nlftFzvskXz95vPVkuCWhOC3m0HssSbgmZiUpfSBs7T2ow2dHq4YZlLo81F9uEIVYFcAF9d7NJIRTngbwnt3H0VQ/kMqnGppPB8mwbWE5SBM4hV2bBxwtgKFCdbf+9otQr+r4gjV7bri4OnwvHdkhyANUVBi9JVA7mbi+nU6vVeF9E5tkDjF+B/Vort2/6gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(5660300002)(6486002)(52116002)(2906002)(16576012)(4326008)(83380400001)(7416002)(956004)(44832011)(33716001)(26005)(9686003)(8676002)(966005)(66476007)(66556008)(103116003)(66946007)(8936002)(86362001)(16526019)(186003)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gJctfP2enpbrkVw3I6/7JQX8Gq7H4FdSpCmFjJWvKNXTTQqyIYL7NGoYepdEGwViIBv/1LmOyi0qWipNo8em3ZVb3gKweGYBFT3kqeNJO7JcbP+hFC83+M8m9OJ/idfd7+sVcdi0IzdnXc5hpJkj+dHEbG1lNpCJfBd5VQUcpfamxVIO3NwGiE6m/qHk/gWy9mAdB0VPfWYXI+YSkgiKiDGb2Ha0iM4m/xJq65S88Q/XcSTK+j3owLok+fMwYOK7b2WACPTIXnX6Cj7UQdWCB2sbTZnD0MvTXy+1Wz0E29WRtyTIt+gihBHh3rff+RuU4tQN8WFQAfyKCmFp1oVi1hclIxTTxXw+bJxdVJdsFC9Ru6BNZHR+GM6TPXTSmRLJgkCHRfe79wIFdV0UvhzbJ84HSNq+bmV9WQjlfVT1OpxVnThL1LNUsx7Qt4CmWiRtmBLwvb3WyWb58yd29Sowo1c+NtwHaV+XdhfgrN9KeCePHD4b7IEZ5VRY+m3Xe73kqy/8c4wIDbuK/aCnjx2tpKIk4miFpg0rEMmk4fq4ZMT6BO+EwFJfPYJgxd5IxPX6y4ln4qRF7OCFo2RlO+LAKkgbvt58l4tnQuCiHT5oomyajDJCQbwVaMOFy+n2hAkQaWxkDeu/LvYMA4wax46DVA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b660ee9d-d818-4088-0e7d-08d83a6b7dc3
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 00:47:42.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +43hnExN+6VM4IOOepB0bfI7wm2Mhx4Vzf5E3yYRvgM1qWThMU+4hhdfsubsWPMe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4479
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following intercept bit has been added to support VMEXIT
for INVPCID instruction:
Code    Name            Cause
A2h     VMEXIT_INVPCID  INVPCID instruction

The following bit has been added to the VMCB layout control area
to control intercept of INVPCID:
Byte Offset     Bit(s)    Function
14h             2         intercept INVPCID

Enable the interceptions when the the guest is running with shadow
page table enabled and handle the tlbflush based on the invpcid
instruction type.

For the guests with nested page table (NPT) support, the INVPCID
feature works as running it natively. KVM does not need to do any
special handling in this case.

AMD documentation for INVPCID feature is available at "AMD64
Architecture Programmer’s Manual Volume 2: System Programming,
Pub. 24593 Rev. 3.34(or later)"

The documentation can be obtained at the links below:
Link: https://www.amd.com/system/files/TechDocs/24593.pdf
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/uapi/asm/svm.h |    2 ++
 arch/x86/kvm/svm/svm.c          |   51 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 2e8a30f06c74..522d42dfc28c 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -76,6 +76,7 @@
 #define SVM_EXIT_MWAIT_COND    0x08c
 #define SVM_EXIT_XSETBV        0x08d
 #define SVM_EXIT_RDPRU         0x08e
+#define SVM_EXIT_INVPCID       0x0a2
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
@@ -171,6 +172,7 @@
 	{ SVM_EXIT_MONITOR,     "monitor" }, \
 	{ SVM_EXIT_MWAIT,       "mwait" }, \
 	{ SVM_EXIT_XSETBV,      "xsetbv" }, \
+	{ SVM_EXIT_INVPCID,     "invpcid" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3c718caa3b99..053dfd00efa1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -813,6 +813,9 @@ static __init void svm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
+	/* Enable INVPCID feature */
+	kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 }
 
 static __init int svm_hardware_setup(void)
@@ -970,6 +973,21 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	return svm->vmcb->control.tsc_offset;
 }
 
+static void svm_check_invpcid(struct vcpu_svm *svm)
+{
+	/*
+	 * Intercept INVPCID instruction only if shadow page table is
+	 * enabled. Interception is not required with nested page table
+	 * enabled.
+	 */
+	if (kvm_cpu_cap_has(X86_FEATURE_INVPCID)) {
+		if (!npt_enabled)
+			set_intercept(svm, INTERCEPT_INVPCID);
+		else
+			clr_intercept(svm, INTERCEPT_INVPCID);
+	}
+}
+
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -1099,6 +1117,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
+	svm_check_invpcid(svm);
+
 	if (kvm_vcpu_apicv_active(&svm->vcpu))
 		avic_init_vmcb(svm);
 
@@ -2714,6 +2734,33 @@ static int mwait_interception(struct vcpu_svm *svm)
 	return nop_interception(svm);
 }
 
+static int invpcid_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	unsigned long type;
+	gva_t gva;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	/*
+	 * For an INVPCID intercept:
+	 * EXITINFO1 provides the linear address of the memory operand.
+	 * EXITINFO2 provides the contents of the register operand.
+	 */
+	type = svm->vmcb->control.exit_info_2;
+	gva = svm->vmcb->control.exit_info_1;
+
+	if (type > 3) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	return kvm_handle_invpcid(vcpu, type, gva);
+}
+
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -2776,6 +2823,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
 	[SVM_EXIT_RDPRU]			= rdpru_interception,
+	[SVM_EXIT_INVPCID]                      = invpcid_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
@@ -3561,6 +3609,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
 			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
+	/* Check again if INVPCID interception if required */
+	svm_check_invpcid(svm);
+
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 

