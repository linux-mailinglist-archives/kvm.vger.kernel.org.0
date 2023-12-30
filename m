Return-Path: <kvm+bounces-5384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A238207CD
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD1DD1C216F8
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF08214F67;
	Sat, 30 Dec 2023 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Cz867nR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9C014283;
	Sat, 30 Dec 2023 17:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijmVIxxAaaxZw/Rl/3nTxwUpV4AsQxIOh8fmn2vuojJO9J9wbrEj4TKLuFqZjFy8QjISu8/OWhQUOjrcs1VUuJM2lfh0dN2L7vbBOZ9n3QQAGGTGQe2xpeTj4zWVx6QbQEZXsw/weyt7KL7F2epLyv1T/jXatgf/VfcThNdtirzgb/s/4Sec4fra1GKtmgUmUbpPrkCFOVmZHhfKnM9dRoYnhuOABVaVEDsFPxWElDutzTmU11nJJY35oz967gK110Ij4+5KMp5MvL5uv/EdMTn3Loc+/7ljhYvWa7a+aHva29NpSY2pJIzu0k1LpJXWPPxhSqmh42LjN6dthJaNBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1E6m6r2qCIjTuRhxUoXmpVTjHurvP0i/fRDMy6wjg1c=;
 b=D0N/ruIyYQamMRp6RL78d1catN9xsKv5vY1lUSpJ0zS9RKBiH6yRScXoH9QNKUkT5SbpMjswePsHfJ0OzenYXpYO2snMebwa2w2/TY7C10akJaRLt821dvw/fqcueG6+B7Mb+cMLTTttzR2VeFYP2l38fNqW/CtLHEr9X8QhP2sxOE0hu5tt3vCgW8hTWCVUw+S7wmT6f7TL/FyUUZyiplQ38DJpiLYqo1SX9Ug5al3DOW08Zmp0NoxJ6cEwvLEsN8vpjcAFUUitKmKbdv7MtOyrhmWPSSD5u0i5eC0aNvuu7wPVdpULiH6rIhsGqzu4v9I929c5fdPN+nNUC8hswg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E6m6r2qCIjTuRhxUoXmpVTjHurvP0i/fRDMy6wjg1c=;
 b=4Cz867nRhZPJieIJwDNMbfSmbfe/rQKXI10KVaUI/nbKazviUsFBDUr/mDqwsdTsHkK63PfMUwph6Xa2OVPluLk6Bf5IOEsMkjXOhyzov35NrjGmU8aIPkwbfHfFpR/WqJltAsVQ4roCnS9MmZGqnWLwpWnpZz35TkltOvwK6lI=
Received: from BL0PR02CA0034.namprd02.prod.outlook.com (2603:10b6:207:3c::47)
 by CY8PR12MB7585.namprd12.prod.outlook.com (2603:10b6:930:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:29:13 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::dd) by BL0PR02CA0034.outlook.office365.com
 (2603:10b6:207:3c::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.18 via Frontend
 Transport; Sat, 30 Dec 2023 17:29:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:29:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:29:12 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 21/35] KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
Date: Sat, 30 Dec 2023 11:23:37 -0600
Message-ID: <20231230172351.574091-22-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|CY8PR12MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: 761419dc-8abc-4a1f-ef02-08dc095cd727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hFiSWSoZqH3eyjNHSg/FZ+PZ4A11RPwgTr3kks44gDpSRMiQS6eh5MaeNTYDizLW8z0vUXxeAvFgJaYRVdZ2gJs3bamo/GD6u8II32zzyYT+xZSKPH4keJi4/V84IPuI4RUdfbNMdsZlB4dJJB6ZcrswGc/1YWbEHf7ASM7y223J4CDCmekg2PIk9dgIp9VWYeTMXbyc66+JAvadfqYIDuegpZliHT0UrQpxEbicQtGyvcKEnO2PwWK6jyJwbNLwfQrvTL9AU6EVvVeIGqjOL8L8JyVvbowfc9QZvSaXdIMlFFTxyk1zPUSXTBieDDsuXKLzMOER/ikyLJWlZWNCRb6iA7XP8kXuCylY07KkvKy4KKAJ9zZhtnLqy/AAR+jMR5BbRuhYanh2XHV1Kr0FZ4Rum1XEx7ug+EymMzie+9+lXfI346bhvzyAAQ4Fmh3nW9WAlAfxbRXeanrD/3fNoTR92EUULjESmnKnGYG8wK1JgxCoxWBNScvpDf035kv8a7DO0lBK5cDXw3o9aQSQDfTIem8Z1zxg6hmkEt7zQQ86MdZBwzgLqxrUYIdmbDN0NL23Qs2kN745TS/OBYX2GQbieL9lSeoWL3LwW9zbHq4nzX/2IqT8PYdlPdzt3vo2SUeNdhP+enXWs6TkOGjNIRW2X02oGg4iKA1+fH7tKS8sVszzdsW1ZGGbx1wtFq16J7F7VFAMtgsUtkwwSqn713+H3bgiZuD5aiyZKzdulbB8BD0WTiPwSeshIYUGyz8dSB2XEtDoeViH+iLWV1+x0A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(346002)(136003)(396003)(230922051799003)(82310400011)(451199024)(186009)(1800799012)(64100799003)(40470700004)(36840700001)(46966006)(336012)(426003)(83380400001)(26005)(16526019)(1076003)(2616005)(47076005)(36860700001)(5660300002)(44832011)(8936002)(8676002)(4326008)(41300700001)(7406005)(7416002)(2906002)(478600001)(6666004)(316002)(6916009)(54906003)(70206006)(70586007)(36756003)(82740400003)(356005)(81166007)(86362001)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:29:13.0658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 761419dc-8abc-4a1f-ef02-08dc095cd727
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7585

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
index 3ec0b7a455a0..682490230feb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7031,6 +7031,39 @@ Please note that the kernel is allowed to use the kvm_run structure as the
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
index 0b8837e21705..37e65d5700b8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3275,6 +3275,36 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
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
@@ -3373,6 +3403,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ:
+		ret = snp_begin_psc_msr(vcpu, control->ghcb_gpa);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5218075fe1f4..62093ddf7ec3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -167,6 +167,20 @@ struct kvm_xen_exit {
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
 
@@ -210,6 +224,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_VMGEXIT          40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -470,6 +485,8 @@ struct kvm_run {
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


