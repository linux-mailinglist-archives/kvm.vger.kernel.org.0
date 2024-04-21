Return-Path: <kvm+bounces-15441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE808AC098
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8C451F20AA7
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B34405F8;
	Sun, 21 Apr 2024 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tlSEWCCc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6003B1A2;
	Sun, 21 Apr 2024 18:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722929; cv=fail; b=Na46PLI/s0JmNyDALJt0+LU2dAplpfNan/Jd1HCWWoek/CketJLdtu39qDLPbuxzAfkQD51s4gSHLnFOoObwiaynYTnxqggug6YjTmImBsK15GBEQRYT4b7KyQVgXOs9J8nT6Sr6xytxuqB8H2n13LUdODwAs/kIx6KF/7Uq3AA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722929; c=relaxed/simple;
	bh=WBYBeeZLBm/B2DESUsVDrDULDXseq+v+B1b1Grfieq8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNQLGTE+TL0f3wih1GPzAV7VjxWqmKe/X3dBYkQomw3+eaMpUmWzmusDvyXERJkEMBlJosGQvniTzlgszUBJ1Y1i64PQD0jS4W0SXvMKikCdAChjn33jgnFLLBmtTAt5kXomrHWl1IjIm6Lxqd27lf9ORXTzHvKJGL3lijfJ/Uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tlSEWCCc; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHPlmFiD4JG39A65gyJ/7H3XKSvChChPfFo/CDn4f4pplozAzPjVjUhonKHGiZakGJvf2iOPTnQ+Ghyv2V2inW0MmkpLxMBCwC4gF+IRFIfXmfhHehMRWDjsarIFzDEKwi23FU5iVmyiVpvoJu4WdEfD7N6eV6WAbO5amIpW04GRgwB63+A8Ea1u/7XNntxgsePMWuB76DWPDz3Bsp66qnQJew7m4VcJ4/0YIkoCS8lHp6AKjcoCYod5ZKPdamabjMCYxTUWmEgpDnPPC8uYlv96xqJGWVCrHztUeb8odXNUAKqle4TYoWiQAbX0MWi2no321kQufYEPn5lJlZtr/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agCuD0cvtD6/j72PtGo3DJ5+sXz548I6rxzD/SUBvFY=;
 b=G9gYeka2ZYYr67ui0/51G0jgTPMQ2Vp5ka/PIOQqQi70VDK+lYdQ2bjgZdQZ9zuynmbFR2vMzrKHWZce095Vx3otdco72K1fSnWHegIv/gG5T1AmUI0JabgchMmlQrhnXYYhEDum6A69wgek14Ss97DvPg7+ib+h+0L5BjvRfjKTBYXIE+Lngi0H0wj1s0UVUfM+6/ZVid+gZGoa4Tfo5mUAbRNAwoCgFRtsbP0OByGVvfgMmJVT8f6uX5RnQ2Xnc0DT/0H+/5NpkQwOCl8JK5dEA9BSPg0QJZpBdDX6az9tA4Qs/lChemPkYe6+sWQ7WxmIr1hkF0rJr52v843scQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agCuD0cvtD6/j72PtGo3DJ5+sXz548I6rxzD/SUBvFY=;
 b=tlSEWCCcsu4BzPgUAxmtkzS3zf/DsMPTwPN9l0A7H31v0j/YYEF7p6N46BLKJCFb1lM6/uxlcg90So6ouLuPRo+2pmPwP0BlMbQ63jUHv4Uzm8v7CltbSyhKdrqIJhUHZz6fYbOHRxn0m0Raz+6TtnJdJJPeU1OnBzqghY1UVaU=
Received: from DS7PR07CA0014.namprd07.prod.outlook.com (2603:10b6:5:3af::17)
 by SJ0PR12MB6877.namprd12.prod.outlook.com (2603:10b6:a03:47f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:08:43 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:5:3af:cafe::41) by DS7PR07CA0014.outlook.office365.com
 (2603:10b6:5:3af::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:08:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:08:42 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:08:41 -0500
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
Subject: [PATCH v14 22/22] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Sun, 21 Apr 2024 13:01:22 -0500
Message-ID: <20240421180122.1650812-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|SJ0PR12MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: cdce3836-cdfc-449e-85e1-08dc622e142b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h+/5bJsUiNDrDBBLQN8Xlp1hZ8JUS8GdykALPHwCO8xk4i8EJw6thevATD0m?=
 =?us-ascii?Q?ZXt5xExYSB4pys/qB5R1Jvi4NrW7q/a+hfywRjU/wb2pxtB5w3yw6dFJFfMz?=
 =?us-ascii?Q?MEu5GdhL5kdBYsFX+tcZvhRVZSO4pmK6BH1OUcnyvZn09KXisc0zl9xFH/m6?=
 =?us-ascii?Q?PZh8o9UjRFShEAc4JIsQiCpjnEuGLjioBthfeOabX8JdUHkT31sz0cCpQh5I?=
 =?us-ascii?Q?R8jfGnxa9ZRhISXgfjQq84XAXNcTdL8xi56PePv9AkncXKgajEc3chSabbfo?=
 =?us-ascii?Q?ADREsvTAKVdO2IPmhYQGo9QyuKNEO442Oy9fm4HCUFi8q8ry1D+oAog1bITF?=
 =?us-ascii?Q?PbnFvO7sKECw2G1oOyEkcUOue1BkG1lYJOp4/8vupoae4HocjqesEDHIHXJL?=
 =?us-ascii?Q?qTV1d4CjiowqxaQdtoJUIzqE9+EOsLiws1pCzbaB7E4qTa8IVCWT6YKVTNVR?=
 =?us-ascii?Q?D/KgOWV3dlz1M3lGMTxQ2fVzWGlXqv+7sQyIovnHelCrGkqmiSOCuu0s++m1?=
 =?us-ascii?Q?cHMuIcSozeTxF+SNKChM4cSMup6O2XqlzirQMvZzspZKKvpi88cBCKUO5wt9?=
 =?us-ascii?Q?KvfsMeufB4luzsOHF242IEIAgFQaTeZni8OZcNtBcwLK9nW59pGIFoGMwT9q?=
 =?us-ascii?Q?KJ26faQmID35p09wKvRdLip3Dcj/iX5YBsPT3lrfCrVwYUXHkNRY4csn5VVP?=
 =?us-ascii?Q?1Mb0frpKR3nWIJimMBNeYIFc552LFEgLR04WH+ZIgNhmbSWTGf/eLfB824ul?=
 =?us-ascii?Q?t90yC7L3P76sGQV8nVb8oSmvuTrPFU17ih3pDv9eJFXV62RB/ULGeCcBCyzA?=
 =?us-ascii?Q?/Cl+cZ1Swm5fmX8is5UOW59ouWqwwL2HKlQOw1qDgZbYxPztGU8pafoYOJPU?=
 =?us-ascii?Q?8TbkzqLsggVO/syEHr4kl/w9cpnXGFblEOjnRAUtG//PWqAehYl9iIhfGyEn?=
 =?us-ascii?Q?GzI148fSBqf66qfNVLLrExs2QRXr2IjdwgK970ielHajFN3KxDFcoOndDBZ7?=
 =?us-ascii?Q?sktjlA3ZnkGSNlPrlUGxtUcFB/UF5N82CriArHn21S1fzOsKaZSh3WYXrMnS?=
 =?us-ascii?Q?1o2XAwLYPG/5yF9OYmC4mqnQ/MDiLUn6Oc568G7ORaiik6k5jGCYKPrvf2SE?=
 =?us-ascii?Q?SD0lJGF7pQtr1Klrpv0F6uRyTaRfZ8D+Gcg/GrQ2jk4j2o8LXFWoBrraBOtI?=
 =?us-ascii?Q?brgtZYmxljEy8V8ENX6PRAHK1ZMuBEPtedEYBUoJa7Ibqv6+ONqFxrDjHPnH?=
 =?us-ascii?Q?1kSsVkyAWnsQRQ+XBliGTszxCQqgzm3iI/gDXZxfzGsQtSmvTBLCzMtkhDDO?=
 =?us-ascii?Q?CIu2LQdbNWj9IkNR+1ckwwG6AxWh2BtQo6J+RhcFaQw4eh1MMBdh4UXkaoC8?=
 =?us-ascii?Q?+F/OVwzCOvvG20RqbmvcrjLqtrEZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:08:42.5088
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdce3836-cdfc-449e-85e1-08dc622e142b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6877

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
index ee24ef815e35..dfc28ac4dd0e 100644
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
index 68db390b19d0..1cec466e593b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3292,6 +3292,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
 	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3812,6 +3813,84 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
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
@@ -4076,6 +4155,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


