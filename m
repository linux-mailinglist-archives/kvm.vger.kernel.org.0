Return-Path: <kvm+bounces-15158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0AD98AA369
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E1FB1F22AFE
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD4821A0B19;
	Thu, 18 Apr 2024 19:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b0+dBFW+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C86184127;
	Thu, 18 Apr 2024 19:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469744; cv=fail; b=Efp4kTeCWVFwCs+rcQqHwdGWxarabRW0if0z8BTzcwo3kZIjmoch0kfMnD+ia12ma8dG7LwtoJwdj6s1uOf26W6sUOitbWE1T5xL49QhIBjpQRZZ4QFKVKGElcAdecV+0T94J+Ywfutbc5b14V7nj2aByOilXLyhWs75ctkW3DA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469744; c=relaxed/simple;
	bh=TywdgYIs4nzhUrcOYx8QmJwkMBIybxLXfN7cAZwuPGc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bmBjr20y/L3tlhOk9lhaYoNwECX94jMQk9zXkH5QjM1r2FRWvxkMjejLzamwf5LYsjcFIHwqKCM5ntIPBm6Poy8pWbP0XztjtcWFo/SDWpYEK9VxIu5Iocny6Z1nFyaLNmg3Dii6JdyOGFBR+DK5V2NjxflBkkXN3RjWpO+LyLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b0+dBFW+; arc=fail smtp.client-ip=40.107.93.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMoEDIqQYfw291/yF01mkDVXoLBSzF/ibImjNp3z/d84AAiB4S0pPQLfD35Wyb6/fJcXBYrCTZe02BJLgvLsG2ZTAtvCWUEHfG4devi7QkequBoG/Cu79s7OYtBlP8MUDag0fuJ8ThC4L+hVz/JqYMR1+6L32YIdHpG57wBVv+AQN8ieyJVS2LugCsnEudkOIupKZqwnLc67qW2W6bnfpVA4qgL+yFglX9gXd32u1TvEDtlOhv21hCW6lQdSIiMahPeQFQhvsr4X/yQK6+27IUh4/CidzwfZh+MVA28thDHHTyW2Fl4+7R1oceQTZ1HilnE0FIRttShezBE1cyQggw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odYMF9wN/jQkyJ9bByOpgiL8veyUMzdfUThcHu7U1Dk=;
 b=KzuYDijxY2gkxt9slmJCGkW2RVhn4EMbMrjVOjfKXR+IRYtQiPHexKXEbj0vch8mbBmaCpXZyCBHSIOT1GwdbS6KXcZMNhWf2dRSzzSUkEFs4eDQJuHzeJiNljqW1CMwKgPJ/Ah94M9+PaH7Thxy3WAlAhdJvg6abkREyPUF1wudg2L0lruS/FnL9RgQqIWFz2bNHppoSUcagQDEeflqLor8OkWkpq2M9VI5JHHsgL5LKQwRrDk7iPhMnD8gB2JrQFeFkMeshgiJ4DWDOqH/m0ywD8WSqYPcRjGuKm/MiAv9+/z4a2Lp2DZ1PvgU7WpBRb6hFi5iBaxUeoLPaLgE4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odYMF9wN/jQkyJ9bByOpgiL8veyUMzdfUThcHu7U1Dk=;
 b=b0+dBFW+W3QcO0F/vx/v8xqRJ9xOI65wRz2HpVqEoBr0rB5GkfBEW4Aeavi3kJTT+CFAJWW3iu6o3ZTc+w9H6VY9dsoAh9aw8HMtFIZPblCwLW6nLfY3nEtbhNN7ZqsXb0kSe885dLyEJ9AamR+qS/o3x35+UBJmuhHaapjtjxA=
Received: from SN6PR08CA0010.namprd08.prod.outlook.com (2603:10b6:805:66::23)
 by SN7PR12MB7227.namprd12.prod.outlook.com (2603:10b6:806:2aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 19:48:58 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:805:66:cafe::4f) by SN6PR08CA0010.outlook.office365.com
 (2603:10b6:805:66::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.28 via Frontend
 Transport; Thu, 18 Apr 2024 19:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:48:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:48:57 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v13 26/26] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Thu, 18 Apr 2024 14:41:33 -0500
Message-ID: <20240418194133.1452059-27-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|SN7PR12MB7227:EE_
X-MS-Office365-Filtering-Correlation-Id: 34b4a03a-5cf5-43ec-a3b6-08dc5fe09664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3OVYTlmvENaANFfoxB4n1wqPWAUjtqCfG5HFAcLl2vjWTMQXpTMLFpAQfLCUZpXdpjVSyhqYaSzdzaKY6bPupzx/BBUa4qF9X/6PBaS9rO0ImvoGtIyoysu4L5pxx6MINC2NwimjMa45OQUg6p59BnXlNPfKXuqk6LgkNUPNLz/5KaVgQ3cyXtmmp5aoSG2+cNmdSZMyjkOe0nXI+iRenB+sIXBvGfS38Vj8dhwvY0gxymWu16rjdNsGO59bkVF7YDy3kl0KkJ61OhsFIcSA6fahhXvxTdIW2tbTKqrdFlCh8htbQpw6SW2i1r811yvN1kGTa8S13jsWktJsT9VBLaOln11pU0iRhSWPXBayzbleyixVhyQLdNS2KVfU2AddumM84jT/xwdykF29kSAVo/FMNi0L/JWZgQS8f5mVMvbCAgyaRSTjsKlPegcmi9z9JK2ggaD/XYbdrCTE6ubNJkbBEcaVAfeISija0SLDXqkYJyiQCKgXXVullGgJh3wTIT6CzMuEyqDFVJDI8oCQKNh4q2kxIZiOlqiqeX4OgojUfD8dw7M8bETqqsajaBEQj/XinI1PONSHzPratyS4m4d3kaO87zY/DO2aybu7pu2rlPFrmK+cYzN6ILr63xjdvAMMR+Di+AzksTkvjmwKzdPcC0zMtMbMDivnYZwIUW5h3RdgM+g307PYSQEc2HJcMf1DM+DjXnTkcBXNIpRbv3y6/epFVPIyzpa+0e0yXQvrpYcJZTyX+bOctIRAVBjJ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400014)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:48:57.9633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b4a03a-5cf5-43ec-a3b6-08dc5fe09664
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7227

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
reported TCB or VLEK that firmware will use when signing attestation
reports, make use of the synchronization mechanisms wired up to the
SNP_{PAUSE,RESUME}_ATTESTATION SEV device ioctls such that the guest
will be told to retry the request while attestation has been paused due
to an update being underway on the system.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst | 26 +++++++++++
 arch/x86/include/asm/sev.h     |  6 +++
 arch/x86/kvm/svm/sev.c         | 82 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h         |  3 ++
 arch/x86/virt/svm/sev.c        | 37 +++++++++++++++
 include/uapi/linux/kvm.h       |  6 +++
 6 files changed, 160 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85099198a10f..6cf186ed8f66 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7066,6 +7066,7 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 		struct kvm_user_vmgexit {
 		#define KVM_USER_VMGEXIT_PSC_MSR	1
 		#define KVM_USER_VMGEXIT_PSC		2
+		#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
 			__u32 type; /* KVM_USER_VMGEXIT_* type */
 			union {
 				struct {
@@ -7079,6 +7080,11 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
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
 
@@ -7108,6 +7114,26 @@ private/shared state. Userspace will return a value in 'ret' that is in
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
index baf223eb5633..65a012f6bcb4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -276,6 +276,9 @@ void snp_leak_pages(u64 pfn, unsigned int npages);
 void kdump_sev_callback(void);
 int snp_pause_attestation(u64 *transaction_id);
 void snp_resume_attestation(u64 *transaction_id);
+u64 snp_transaction_get_id(void);
+bool __snp_transaction_is_stale(u64 transaction_id);
+bool snp_transaction_is_stale(u64 transaction_id);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level) { return -ENODEV; }
@@ -291,6 +294,9 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline int snp_pause_attestation(u64 *transaction_id) { return 0; }
 static inline void snp_resume_attestation(u64 *transaction_id) {}
+static inline u64 snp_transaction_get_id(void) { return 0; }
+static inline bool __snp_transaction_is_stale(u64 transaction_id) { return false; }
+static inline bool snp_transaction_is_stale(u64 transaction_id) { return false; }
 #endif
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 953f00ddf31b..8ba29b2b2b0a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3283,6 +3283,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
 	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3803,6 +3804,84 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
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
+	/*
+	 * To avoid the message sequence number getting out of sync between the
+	 * actual value seen by firmware verses the value expected by the guest,
+	 * make sure attestations can't get paused on the write-side at this
+	 * point by holding the lock for the entire duration of the firmware
+	 * request so that there is no situation where SNP_GUEST_VMM_ERR_BUSY
+	 * would need to be returned after firmware sees the request.
+	 */
+	mutex_lock(&snp_pause_attestation_lock);
+
+	if (__snp_transaction_is_stale(svm->snp_transaction_id))
+		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
+	else if (!__snp_handle_guest_req(kvm, control->exit_info_1,
+					 control->exit_info_2, &fw_err))
+		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+
+	mutex_unlock(&snp_pause_attestation_lock);
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
+	svm->snp_transaction_id = snp_transaction_get_id();
+	if (snp_transaction_is_stale(svm->snp_transaction_id)) {
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
@@ -4067,6 +4146,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
index 8a8ee475ad86..28140bc8af27 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -303,6 +303,9 @@ struct vcpu_svm {
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;
+
+	/* Transaction ID associated with SNP config updates */
+	u64 snp_transaction_id;
 };
 
 struct svm_cpu_data {
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index b75f2e7d4012..f1f7486a3dcf 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -72,6 +72,7 @@ static unsigned long snp_nr_leaked_pages;
 
 /* For synchronizing TCB/certificate updates with extended guest requests */
 DEFINE_MUTEX(snp_pause_attestation_lock);
+EXPORT_SYMBOL_GPL(snp_pause_attestation_lock);
 static u64 snp_transaction_id;
 static bool snp_attestation_paused;
 
@@ -611,3 +612,39 @@ void snp_resume_attestation(u64 *transaction_id)
 	mutex_unlock(&snp_pause_attestation_lock);
 }
 EXPORT_SYMBOL_GPL(snp_resume_attestation);
+
+u64 snp_transaction_get_id(void)
+{
+	u64 id;
+
+	mutex_lock(&snp_pause_attestation_lock);
+	id = snp_transaction_id;
+	mutex_unlock(&snp_pause_attestation_lock);
+
+	return id;
+}
+EXPORT_SYMBOL_GPL(snp_transaction_get_id);
+
+/* Must be called with snp_pause_attestion_lock held */
+bool __snp_transaction_is_stale(u64 transaction_id)
+{
+	lockdep_assert_held(&snp_pause_attestation_lock);
+
+	return (snp_attestation_paused ||
+		transaction_id != snp_transaction_id);
+}
+EXPORT_SYMBOL_GPL(__snp_transaction_is_stale);
+
+bool snp_transaction_is_stale(u64 transaction_id)
+{
+	bool stale;
+
+	mutex_lock(&snp_pause_attestation_lock);
+
+	stale = __snp_transaction_is_stale(transaction_id);
+
+	mutex_unlock(&snp_pause_attestation_lock);
+
+	return stale;
+}
+EXPORT_SYMBOL_GPL(snp_transaction_is_stale);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e33c48bfbd67..585de3a2591e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -138,6 +138,7 @@ struct kvm_xen_exit {
 struct kvm_user_vmgexit {
 #define KVM_USER_VMGEXIT_PSC_MSR	1
 #define KVM_USER_VMGEXIT_PSC		2
+#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
 	__u32 type; /* KVM_USER_VMGEXIT_* type */
 	union {
 		struct {
@@ -151,6 +152,11 @@ struct kvm_user_vmgexit {
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


