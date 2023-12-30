Return-Path: <kvm+bounces-5399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9A28207FB
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:36:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73EDCB22546
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECFCDC2FD;
	Sat, 30 Dec 2023 17:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dEAGLnKo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCBDD29F;
	Sat, 30 Dec 2023 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpSyfscAP5ew+obYFDBjAj66rjGsPWXQNmJDz7XXxmvbhbaSVF0sjt+EQghCAqazXuzXxV4psY7560FF9W/KGMPAqStjk3DWhYMuR7urdauK1IV9jSeezlJo85mtmM5q5KVUZnh1kZEXUBWOGt0x7ub5s/9s1luJkYH58NvLJRhpO7+NLStDE+0wEAYabb9xM/njEY8MUBsRbUeHju5iytPTTngLoOSqBA71GfRKLwClamKs4fs/qrfWpWcajA8TJzhEtqKDwkvjfD0Q2wnHkaYHG5kxoZ+dBdwmgUZLpUwr4GQYJ7lb9MEWoeUcBlorJ0RIJveK6voLIw1Y2y0ofA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FraUpaS9l6U3ZDvNj1uyAcaXSYZFmTy9tuFYu3AMFic=;
 b=Nds6MSzRtwMcms6RVWzjvlJMT3QbPIGPjbX4S+k+LvwAMwIiBxAf8pNxMuZWlqtoTiJJ87vMM9FYGs4LuG+siUAzf1jMI55PRhQEWPMaJh4cBW/GhZILGLcCGbBJe7gnM3jh6c8rUG3d011szPZNYZQysz46wV0BkmGoEn73eS3ZFZMHYY/hwb18QZTzvUMe3c/Xbdob+UxEk5GdJ/yyoZrXiJ+eLV5ElyZwlZNCImYWEp+++RiE0nAox1HmYitn3Ipk+FFtieFTECkJyhDEzDRlX22OhmSd5kmJx4JD+NzCqdIGy4FrE71G4gApGkCd8PvfDMUgUDLKWNrja93Zwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FraUpaS9l6U3ZDvNj1uyAcaXSYZFmTy9tuFYu3AMFic=;
 b=dEAGLnKouXyvBhboReYlHhJBzIFybiGTZ833vRMRI5xCdKYfx6EMz5DS6G0Kz2YGvvhJLVAA9mnPar+lV0fsnDkAc09EHWz6RQIvDvnfkP6KXgMYGOOByoPU27bsZJxqwVDa0TKEMyWvxGNVBm+X4a2gKZLXJANO2jiZpZaCDzU=
Received: from MW4PR03CA0138.namprd03.prod.outlook.com (2603:10b6:303:8c::23)
 by IA1PR12MB8190.namprd12.prod.outlook.com (2603:10b6:208:3f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:34:26 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:303:8c:cafe::91) by MW4PR03CA0138.outlook.office365.com
 (2603:10b6:303:8c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:34:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:34:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:34:24 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 35/35] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Sat, 30 Dec 2023 11:23:51 -0600
Message-ID: <20231230172351.574091-36-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|IA1PR12MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cd22ee4-a4bf-4328-c24b-08dc095d91aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k5yfa+1E6gwKsl/ZyGfXGW4lv+vEtMDIfxiKSVSKnwOqtrks7iC+0f4Z0ejoDqpWUhDXmreILOmv9Ozxz7ASMLBhojrV8QcV3EOsUSTQJZ9lASkwgmChYvSpRt+a8EeFrdWgfLl7pigkiaMMMos+ONtt0eJO6UQCW4gmCD+5maQevVRBD2OJ9gANhopLPqZ2NprXib5/jXqB8HwkwVUue30ef2trvTVTM4Sw1Ne2bxehKgAsNFWFHdHNA9/ypfmIAqWQUIFYbVg2GyTWc7U8P2CSYzuozpUTJQ7gI2ksJNLTkPNnnhjCcUpmd7/MWzcwQn6cLpA8xlHnisirnycU1wEugXYDnELEKFO/IOg+vvhzqJE8cxLkNc2c4fZ/9bm0/C64kvtm7ur3NsGJ+KTIon3VfoczlwERo+xs5tvUbE9uio5c760qP608CR5UqmwAFq35kF3uSRFnceFvtuSIQD9Zg3Wl/yU9A99HMJbISidB0tndQMx5igTnOy9rGLeabWKACeNQL0eLj5o5SlZkjh4nfzTuxouLOQXQFkmnr5Aa8aCdxnTL6IVJJnN0Jn2mvAMEHWGPt7kIszNMYOS1p4olAb22smRIcEV7SXfEqZs8mikoYN0fcflxxjFQxYM/vYiFdOkybaXliDMjoFs2p8zg/qrYwaibbIU31VU6tDJZj+8CwfXl3uoxVPIU0tk100YNrLjc2X1mhHM8VoqDZIQjidrCoOzC5TP//+srAg+2M1RRv+CnBzpgoY3YO/8ltG/Z/YkMJb6w+r7QbeqaNA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(346002)(396003)(230922051799003)(64100799003)(82310400011)(186009)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(40460700003)(40480700001)(16526019)(426003)(336012)(1076003)(26005)(83380400001)(86362001)(36756003)(81166007)(356005)(82740400003)(47076005)(4326008)(44832011)(5660300002)(7416002)(7406005)(2616005)(36860700001)(6666004)(54906003)(8936002)(8676002)(70206006)(70586007)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:34:25.8700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd22ee4-a4bf-4328-c24b-08dc095d91aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8190

Version 2 of GHCB specification added support for the SNP Extended Guest
Request Message NAE event. This event serves a nearly identical purpose
to the previously-added SNP_GUEST_REQUEST event, but allows for
additional certificate data to be supplied via an additional
guest-supplied buffer to be used mainly for verifying the signature of
an attestation report as returned by firmware.

This certificate data is supplied by userspace, so unlike with
SNP_GUEST_REQUEST events, SNP_EXTENDED_GUEST_REQUEST events are first
forwarded to userspace via a KVM_EXIT_VMGEXIT exit type, and then the
firmware request is made only afterward.

Implement handling for these events.

Since there is a potential for race conditions where the
userspace-supplied certificate data may be out-of-sync relative to the
reported TCB that firmware will use when signing attestation reports,
make use of the transaction/synchronization mechanisms added by the
SNP_SET_CONFIG_{START,END} SEV device ioctls such that the guest will be
told to retry the request when an update to reported TCB or
userspace-supplied certificates may have occurred or is in progress
while an extended guest request is being processed.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst | 26 ++++++++++++
 arch/x86/include/asm/sev.h     |  4 ++
 arch/x86/kvm/svm/sev.c         | 75 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h         |  3 ++
 arch/x86/virt/svm/sev.c        | 20 +++++++++
 include/uapi/linux/kvm.h       |  6 +++
 6 files changed, 134 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2a526b4f8e06..960e2153d468 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7037,6 +7037,7 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 		struct kvm_user_vmgexit {
 		#define KVM_USER_VMGEXIT_PSC_MSR	1
 		#define KVM_USER_VMGEXIT_PSC		2
+		#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
 			__u32 type; /* KVM_USER_VMGEXIT_* type */
 			union {
 				struct {
@@ -7050,6 +7051,11 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 					__u64 shared_gpa;
 					__u64 ret;
 				} psc;
+				struct {
+					__u64 data_gpa;
+					__u64 data_npages;
+					__u32 ret;
+				} ext_guest_req;
 			};
 		};
 
@@ -7079,6 +7085,26 @@ private/shared state. Userspace will return a value in 'ret' that is in
 agreement with the GHCB-defined return values that the guest will expect
 in the SW_EXITINFO2 field of the GHCB in response to these requests.
 
+For the KVM_USER_VMGEXIT_EXT_GUEST_REQ type, the ext_guest_req union type
+is used. The kernel will supply in 'data_gpa' the value the guest supplies
+via the RAX field of the GHCB when issued extended guest requests.
+'data_npages' will similarly contain the value the guest supplies in RBX
+denoting the number of shared pages available to write the certificate
+data into.
+
+  - If the supplied number of pages is sufficient, userspace should write
+    the certificate data blob (in the format defined by the GHCB spec) in
+    the address indicated by 'data_gpa' and set 'ret' to 0.
+
+  - If the number of pages supplied is not sufficient, userspace must write
+    the required number of pages in 'data_npages' and then set 'ret' to 1.
+
+  - If userspace is temporarily unable to handle the request, 'ret' should
+    be set to 2 to inform the guest to retry later.
+
+  - If some other error occurred, userspace should set 'ret' to a non-zero
+    value that is distinct from the specific return values mentioned above.
+
 6. Capabilities that can be enabled on vCPUs
 ============================================
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 925578ad34e6..25f533827d62 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -270,6 +270,8 @@ int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
 u64 snp_config_transaction_start(void);
 u64 snp_config_transaction_end(void);
+u64 snp_config_transaction_get_id(void);
+bool snp_config_transaction_is_stale(u64 id);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -284,6 +286,8 @@ static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline u64 snp_config_transaction_start(void) { return 0; }
 static inline u64 snp_config_transaction_end(void) { return 0; }
+static inline u64 snp_config_transaction_get_id(void) { return 0; }
+static inline bool snp_config_transaction_is_stale(u64 id) { return false; }
 #endif
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 05051e36926d..dda195999c42 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3111,6 +3111,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
 	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3618,6 +3619,77 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
 }
 
+static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control;
+	struct kvm *kvm = vcpu->kvm;
+	sev_ret_code fw_err = 0;
+	int vmm_ret;
+
+	vmm_ret = vcpu->run->vmgexit.ext_guest_req.ret;
+	if (vmm_ret) {
+		if (vmm_ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
+			vcpu->arch.regs[VCPU_REGS_RBX] =
+				vcpu->run->vmgexit.ext_guest_req.data_npages;
+		goto abort_request;
+	}
+
+	control = &svm->vmcb->control;
+
+	if (!__snp_handle_guest_req(kvm, control->exit_info_1, control->exit_info_2,
+				    &fw_err))
+		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+
+	/*
+	 * Give errors related to stale transactions precedence to provide more
+	 * potential options for servicing firmware while guests are running.
+	 */
+	if (snp_config_transaction_is_stale(svm->snp_transaction_id))
+		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
+
+abort_request:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+
+	return 1; /* resume guest */
+}
+
+static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
+{
+	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long data_npages;
+	sev_ret_code fw_err;
+	gpa_t data_gpa;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		goto abort_request;
+
+	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+
+	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
+		goto abort_request;
+
+	svm->snp_transaction_id = snp_config_transaction_get_id();
+	if (snp_config_transaction_is_stale(svm->snp_transaction_id)) {
+		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
+		goto abort_request;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_EXT_GUEST_REQ;
+	vcpu->run->vmgexit.ext_guest_req.data_gpa = data_gpa;
+	vcpu->run->vmgexit.ext_guest_req.data_npages = data_npages;
+	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_req;
+
+	return 0; /* forward request to userspace */
+
+abort_request:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3882,6 +3954,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		ret = snp_begin_ext_guest_req(vcpu);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a56109e100ac..a2ac6dc3a79a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -307,6 +307,9 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	/* Transaction ID associated with SNP config updates */
+	u64 snp_transaction_id;
 };
 
 struct svm_cpu_data {
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index fc9e1b7fc187..fee273a84030 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -542,3 +542,23 @@ u64 snp_config_transaction_end(void)
 	return id;
 }
 EXPORT_SYMBOL_GPL(snp_config_transaction_end);
+
+u64 snp_config_transaction_get_id(void)
+{
+	return snp_transaction_id;
+}
+EXPORT_SYMBOL_GPL(snp_config_transaction_get_id);
+
+bool snp_config_transaction_is_stale(u64 id)
+{
+	bool stale = false;
+
+	mutex_lock(&snp_transaction_lock);
+	if (snp_transaction_pending ||
+	    id != snp_transaction_id)
+		stale = true;
+	mutex_unlock(&snp_transaction_lock);
+
+	return stale;
+}
+EXPORT_SYMBOL_GPL(snp_config_transaction_is_stale);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e0599144387b..fe8994b95de9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -170,6 +170,7 @@ struct kvm_xen_exit {
 struct kvm_user_vmgexit {
 #define KVM_USER_VMGEXIT_PSC_MSR	1
 #define KVM_USER_VMGEXIT_PSC		2
+#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
 	__u32 type; /* KVM_USER_VMGEXIT_* type */
 	union {
 		struct {
@@ -183,6 +184,11 @@ struct kvm_user_vmgexit {
 			__u64 shared_gpa;
 			__u64 ret;
 		} psc;
+		struct {
+			__u64 data_gpa;
+			__u64 data_npages;
+			__u32 ret;
+		} ext_guest_req;
 	};
 };
 
-- 
2.25.1


