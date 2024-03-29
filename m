Return-Path: <kvm+bounces-13118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D3D892763
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5C66B211DA
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0D513E414;
	Fri, 29 Mar 2024 23:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qxq8/8jE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BEC13D62A;
	Fri, 29 Mar 2024 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753273; cv=fail; b=O1wNugG7Q+DU1qzz0qTnsCqvEi1TbFcnu/EL/2eJXARiO5mfFTxz7AuX/oZqTcrLSHGZ0bWHkScQDQUVPYMIyea+fbSyMtCnJTPtoZQsGPPZr4K27xF/tqASIjdRyfvPFGOkLJppljEkeUsSBSVgc7XWCjI6+w+ofi1FHBUh/fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753273; c=relaxed/simple;
	bh=xc4qtt/v4+nzUadBkgKDEqy7glnnaooBx3sERvtoE74=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TEbcEvYAFsh+H+R8lzY7FL2+Y1WG+B+EGQ1iAkdAu1OP9QkrzCZD3T6N7vbF3QjBD0e1+ig5NkZdbB4LK5h3Y7UA4jLJkz6nNrWU9bukGre2Wtrdzmt7+STdWc3IziTR/UfBIMc8ZNNn5zTW2oTqKcLj9JL0rE71a/7qb1pVWPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qxq8/8jE; arc=fail smtp.client-ip=40.107.223.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iiTbvuyR0+WLhsJI79U3P2feGflgTgbaFRZ0pSAn3zaRVtrfxPlFnIHjO6Oz8/2he1CROBFEcVGyO+Krl3Izc0CZyS706vmJkM6PLpnqPoNixfnpBwkdpgWQftdx6usxauRoLwsAjMp0WK5rjDHUnArm24yYHEXMkPqcwGM5BBqfP7gzbzKM5MBsIaecbUAiGLtHM03qWm4jNyO5/uCvum1RaX20RXnQKm8cNlnzhxTrQg1O0c0E1cy96mTx8KyqSCqYTjrOwfjgSC7Um7PU8sXeZFfRdveGfl5Ue6QL0/Fyw7bP7zXGZXkk96M7VdrZsqzGlDdLMwuQ8/THrkO2oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQzP2QmDagMMe3sUqjIlu3uZxwjkBxnLqqQQ63rUPWs=;
 b=HkUvm/k6J9rrnnMEdT41e4nn/12fNv9ekWwFsGc0AwkAIWhhNw+PIsCarNqmmXXSQibwcEHlpjgt3xGV2UBHSSJ/l8xIDEaDvYjZ0qD73SNQUWGkasxVI+JBpKeSL1oqJ2NvwazKA4BSCfn0A+sLDnENTX8CjxxsDCV1kYP/cVl0cWul3nlcU5fvhXMhdI2PfAQzG2ajy18dvP9P9+Ql+svYbFKD/XlzQHystSkVkV+0R1VHjxB6qq+TCiSHOuYB0/LlHPU5eUNhMg2FqLPxHikc3xjUCYcYq3HLQPAzetLWbM7eoYumzJwcWne5LdlGBot3Cw7/ovRPdmisakxVKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQzP2QmDagMMe3sUqjIlu3uZxwjkBxnLqqQQ63rUPWs=;
 b=qxq8/8jE/g3Y3ZdivQDqA4US53xgz1hXF0ypMoY9VVk1dQAnGGkMe3rlEaPIzzHHW4PEUtooswoQOReuBQkeGesf/pmOf9TayUBa2rNValsBcayl5DpopzI8eEyGJ9yXENQX4HFPukItxxrelu56oYhcwqEjalJJn9XmmiEo6rw=
Received: from SJ0PR03CA0180.namprd03.prod.outlook.com (2603:10b6:a03:338::35)
 by CYYPR12MB8922.namprd12.prod.outlook.com (2603:10b6:930:b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:01:07 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::a0) by SJ0PR03CA0180.outlook.office365.com
 (2603:10b6:a03:338::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:01:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:01:07 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:01:06 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 14/29] KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
Date: Fri, 29 Mar 2024 17:58:20 -0500
Message-ID: <20240329225835.400662-15-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|CYYPR12MB8922:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e53f900-294f-471e-fb4d-08dc50441e41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bHQd6Ve5aNSi03mb86MU3dCfDW02jxWYHoGdY52QlL+BKUHhZdyNg8RKmpuOLZnKiL+l9DamUcKTJvVOtJl8sNmLdrUrs/kKKWUv1n/hfLWlWiT8yqT4nGXsHR0gNpa/a/Tc/+hTee3V7lIFt85cd3MrHaYOIxVEqVGSy6QhX19xyF1730sW4Yty7o1uNZR8DhRT2DIvfINoiPdNpJbhuilOgqtDHVsll9osiOUoCCDd9dgzhdIROkFEILrcxvAOoUZXft5W7QYNPvMb+dsZIJ59fjZNfEtML9b0SnubAvq1j/0dqpW6B44LEMHSfqaAKVKr5JSAmAsdLaVWRacodDo7zPxrsWO3ClRcAYcs7IsObOQrDv+WatghyFv45KRbg5RcspXFFKoMN8kR5U3HXDW3PHqLVgFGanSgcfqE/SM19QsnZ0rSROiU0jvMNPIfWznB6twID8PQDoyUCYQBq9evS5JOeb9JfMHxfM5Bxdhp5gcEKNHfREFcuIFiLlZ+G2jTS/KuU/dIB5lgL/RCAUouEEtm7zZUW18/xxvuYWAe7I5KdTCcChxFNThQ4Z4QXcsAC7F2OfsnHqds6AIi7oqzQBi8C24UPvrVu7rrvF3PDWpzQ1VGlSnW9n7BDNTzDYoyERoNCgPRGXlYJqO+EdyZ5A1D7wKPA59ywCYDabCEDlrnBu2TwGR24lV8tPqhveaMjZ17V7kZSHtPE57XBcwOGyAFOxSUFBbkRFaPCw4y26sHvpWTvT17+DsLIkM+
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:01:07.4000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e53f900-294f-471e-fb4d-08dc50441e41
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8922

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

When using gmem, private/shared memory is allocated through separate
pools, and KVM relies on userspace issuing a KVM_SET_MEMORY_ATTRIBUTES
KVM ioctl to tell the KVM MMU whether or not a particular GFN should be
backed by private memory or not.

Forward these page state change requests to userspace so that it can
issue the expected KVM ioctls. The KVM MMU will handle updating the RMP
entries when it is ready to map a private page into a guest.

Define a new KVM_EXIT_VMGEXIT for exits of this type, and structure it
so that it can be extended for other cases where VMGEXITs need some
level of handling in userspace.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst    | 33 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/sev-common.h |  6 ++++++
 arch/x86/kvm/svm/sev.c            | 33 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          | 17 ++++++++++++++++
 4 files changed, 89 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f0b76ff5030d..4a7a2945bc78 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7060,6 +7060,39 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_VMGEXIT */
+		struct kvm_user_vmgexit {
+		#define KVM_USER_VMGEXIT_PSC_MSR	1
+			__u32 type; /* KVM_USER_VMGEXIT_* type */
+			union {
+				struct {
+					__u64 gpa;
+		#define KVM_USER_VMGEXIT_PSC_MSR_OP_PRIVATE	1
+		#define KVM_USER_VMGEXIT_PSC_MSR_OP_SHARED	2
+					__u8 op;
+					__u32 ret;
+				} psc_msr;
+			};
+		};
+
+If exit reason is KVM_EXIT_VMGEXIT then it indicates that an SEV-SNP guest
+has issued a VMGEXIT instruction (as documented by the AMD Architecture
+Programmer's Manual (APM)) to the hypervisor that needs to be serviced by
+userspace. These are generally handled by the host kernel, but in some
+cases some aspects handling a VMGEXIT are handled by userspace.
+
+A kvm_user_vmgexit structure is defined to encapsulate the data to be
+sent to or returned by userspace. The type field defines the specific type
+of exit that needs to be serviced, and that type is used as a discriminator
+to determine which union type should be used for input/output.
+
+For the KVM_USER_VMGEXIT_PSC_MSR type, the psc_msr union type is used. The
+kernel will supply the 'gpa' and 'op' fields, and userspace is expected to
+update the private/shared state of the GPA using the corresponding
+KVM_SET_MEMORY_ATTRIBUTES ioctl. The 'ret' field is to be set to 0 by
+userpace on success, or some non-zero value on failure.
 
 6. Capabilities that can be enabled on vCPUs
 ============================================
diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 1006bfffe07a..6d68db812de1 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,11 +101,17 @@ enum psc_op {
 	/* GHCBData[11:0] */				\
 	GHCB_MSR_PSC_REQ)
 
+#define GHCB_MSR_PSC_REQ_TO_GFN(msr) (((msr) & GENMASK_ULL(51, 12)) >> 12)
+#define GHCB_MSR_PSC_REQ_TO_OP(msr) (((msr) & GENMASK_ULL(55, 52)) >> 52)
+
 #define GHCB_MSR_PSC_RESP		0x015
 #define GHCB_MSR_PSC_RESP_VAL(val)			\
 	/* GHCBData[63:32] */				\
 	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
 
+/* Set highest bit as a generic error response */
+#define GHCB_MSR_PSC_RESP_ERROR (BIT_ULL(63) | GHCB_MSR_PSC_RESP)
+
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b882f72a940a..1464edac2304 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3396,6 +3396,36 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 vmm_ret = vcpu->run->vmgexit.psc_msr.ret;
+
+	set_ghcb_msr(svm, (vmm_ret << 32) | GHCB_MSR_PSC_RESP);
+
+	return 1; /* resume guest */
+}
+
+static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
+{
+	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
+	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
+		return 1; /* resume guest */
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC_MSR;
+	vcpu->run->vmgexit.psc_msr.gpa = gpa;
+	vcpu->run->vmgexit.psc_msr.op = op;
+	vcpu->arch.complete_userspace_io = snp_complete_psc_msr;
+
+	return 0; /* forward request to userspace */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3494,6 +3524,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ:
+		ret = snp_begin_psc_msr(vcpu, control->ghcb_gpa);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..54b81e46a9fa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,20 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_user_vmgexit {
+#define KVM_USER_VMGEXIT_PSC_MSR	1
+	__u32 type; /* KVM_USER_VMGEXIT_* type */
+	union {
+		struct {
+			__u64 gpa;
+#define KVM_USER_VMGEXIT_PSC_MSR_OP_PRIVATE	1
+#define KVM_USER_VMGEXIT_PSC_MSR_OP_SHARED	2
+			__u8 op;
+			__u32 ret;
+		} psc_msr;
+	};
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +192,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_VMGEXIT          40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -433,6 +448,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_VMGEXIT */
+		struct kvm_user_vmgexit vmgexit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1


