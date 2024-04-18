Return-Path: <kvm+bounces-15142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E6AF8AA32A
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:45:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 884E31F2344E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FAD8184118;
	Thu, 18 Apr 2024 19:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c790ecvn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7928184115;
	Thu, 18 Apr 2024 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469433; cv=fail; b=qYj/yl7s8DPJWJ/mVYba7Ah4BQxOZnC8+Owac72xAnvdxuFxYONNbamtQDNi+PQHvh2XTmp0i0mOKxx+nZposfKQ6wtm5RudbEdVirDewPp8RldAaRRKDId2XlXqG82yeyfHXl9ndrX8T8IkBY102sXBFAGCB4wk2gg2t+ymq6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469433; c=relaxed/simple;
	bh=rLAq34XMEVQv8c0Z/o5+oPhKMFTrzjOcOrsNpb5ISYg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=twuU22AmTTkZXqqcyNUYmYgVsKPnsY3mw8q0C1y0r9kO9Bx440Q/Jzs9++slgHVtOATcHy2KDJM5nGjKU+eFQYtqNf5Zx/qu4gwUQXWvMeyWpvv4AJL0sIpzbqZ9Tmmf/R6yo9aOWhmYG9yBve/TG4xc4/cgcsQn5IAnIfskAK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c790ecvn; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1zZ6Cq2hz+Qa/LbONgG/j29dgq/XqJivPydJ/U4ean7tjTmRiHXMcSlOvgNkylkk5pXZtDT1dF+B8lHtVFtwrKcrBY0s03Lf+d1czU/ekZx9IseqxpxKvJBy8YSIJ6EJKgMJ2N8Joltv/F8T8S07Q3D4jtgs7YDVXLPeBd2HHWuTh10tTvU1oQGfDS6WlJGi90sg/ZomI/cjY7CGXSp3ZnXaEXToH80LXKjnggV606vhdt39EcZ7eDsgJHOyq2UJB12szvv1as3f1V+NTonUMRcxB33qudHOyib252qaK+VUocbolb76MEnVPRmq3EFWghx5ubvf7TqXEicRVwcmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12gx8ZJ/+J9ECH2zomhP0cJOn0P844ugNmMM4dsuM0g=;
 b=hJ8MpYuelRRT2CnloRTUmxr+P/lB0gLWZw1IhnAITd5OG78QMa/pJAze41bTGbrTeHpjmb0JkjXxzmHSJVYLOJhIkWoIvwNnFu7opYymnrZlHVYCg372hsSJ2B88TTkiz9/BvqN4i7noh6dY687I43iBgp1vABgE+wbm3wPhV2O7Va91uhagedCHivpsR96X3zAINvr9P9p6vIrUrBuXRjP4/KOw9As9mN9HMSYjUnyQh307sncaN+0FM08x1OMPuffnVdHOBBtujfJVrQDxTonMGrfYb7R3bfU6JiWBsFxqSFA7YEmwzvWSzOCchu4D+O5xXrDHempdqpRe+gg1Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12gx8ZJ/+J9ECH2zomhP0cJOn0P844ugNmMM4dsuM0g=;
 b=c790ecvnJHjlTya/uwjAcYXBjLuVXD97xjTAU60wnE1a47ZsNoL8oy6koDIijOmQhHpOvmI8+UWLmAY2HjtcT1YLIMSfwKjK/wZ1bcbOuyVL3mqHYa+1E0/S4h1mdipy2duwDvehxackE9B6SK6YOiVmMfyMQ26Tmt1rMJdF/tQ=
Received: from SJ0PR13CA0100.namprd13.prod.outlook.com (2603:10b6:a03:2c5::15)
 by SJ2PR12MB7919.namprd12.prod.outlook.com (2603:10b6:a03:4cc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Thu, 18 Apr
 2024 19:43:48 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::ea) by SJ0PR13CA0100.outlook.office365.com
 (2603:10b6:a03:2c5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.12 via Frontend
 Transport; Thu, 18 Apr 2024 19:43:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:43:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:43:47 -0500
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
Subject: [PATCH v13 13/26] KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
Date: Thu, 18 Apr 2024 14:41:20 -0500
Message-ID: <20240418194133.1452059-14-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|SJ2PR12MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b8be7ef-3f76-4bb7-1d0c-08dc5fdfdde2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VKcms8zrtwP4cFSxEkBN8aLMjqLu0aDFFJt3dPogWTdfsOEOanSkzNsYJJeU7H0ZYlxo62xq6ljYM+xKrN7hoq3My5yVbGClxZ8lNF7eTSfQhORBzhlzfkY6WAhkbL2tiRH5kaa//rhoZHmLtY5J1yWf05y/mZRxt7H7qbwUxjXHs2Vy9ioh1jid5Ndx1ikyct9KPSUZU3ltcVq+O00PO7218HD59gKD50BEx86RxbErqM4GmeKr2UlplHIm1D519trNdX8vqUuigMIACpgdE/p0zYgMmBYsG+Q0jTn8tEzafvC8x23rGqiFgEm/KZtY55JOk1XRoyaPueaaVLmZu9zpSBS0jguq1ykDJwCnjXEN6OKzqqZBvrTww3qxo0j5JC186sWdj7/Te9K5CKRtB4o/LSwKCkSBq1KoM/lLz9ZipAqr9cUkkYXRFBeFL57kbkqNzjXNg9iuKQ/ShxvdfRBahb9fcwVXl/6Jf5KPlHmOZkF97fYvEC02XMVkxghcFOVuxZeOxAX/GTUR4H065VE2CSHQF6gg0pWsc8bKLAtExQvM3P6SpACLqUThbTfnuLjsqT7CakjQAF97CD5TKTPyEj3EXz7h968q4KGZ4Xk9wkP5J8qL7QheiRJGhnj1MVCKmRng6YrhD+GNqTh+FdKsKV5U0cD7lCjEBQBgUj9wcA+KZg4GRQYVni+DF4EePRlaYXE+zE52eUFa1b9iABuyQstNGAiVtnp/ChppWFWAFEwvihQm/fYRQogxdF+e
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400014)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:43:48.3446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8be7ef-3f76-4bb7-1d0c-08dc5fdfdde2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7919

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
index bd7f46c61c64..e982468554cb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3454,6 +3454,36 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
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
@@ -3552,6 +3582,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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


