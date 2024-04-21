Return-Path: <kvm+bounces-15426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 856638AC06A
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A87F41C2039F
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9703BBDF;
	Sun, 21 Apr 2024 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YFCO0C5m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E55C376FC;
	Sun, 21 Apr 2024 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722611; cv=fail; b=YHFCfjiZlUIpvxD0ocbYNRJbVoQr4Hg+zm1rl8rMOlsRwSzt612JYqytDvhrZ37llmUvPzXC+GED651V2yDX6juDO9Ni0jxRpCxA/AaJVbm3ZbHUZKb3zIEEM0zIluIFhAZ3QctLOFM+c3Q4ii/6PizYWir9wD65d+YrDwHeB/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722611; c=relaxed/simple;
	bh=76qVH3yW00COXdlwOgMgNQTZM25IBEI0g3tTHYBdRPU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=do1OWzrIf8zgAtheKV4xAXHwv00Mk49qpTllnmIzZmfb1i3/xeOmE2gEVH8V207HOkOexxt7CGp+raJTwaDWGPrxMYoKxF8y3EZLTkGIvksymT5uQr3FogaCm5+1RxCW+VM8t4XIkQ4WmMFl6IHJLZPqtK5pqli18fZLFWS5Jt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YFCO0C5m; arc=fail smtp.client-ip=40.107.92.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1Ob2u4hYIQwx7XQsuZcqfU3lKx77awx2LtzQUcvijOqymTfTRy62O6RAYg+0KlrvvVyC3RVCi+nGAUvy64/NEQ7wfoEmjF1/SnYrEwZDU6W+uuqEcJwaP6Hlw8/aLnp/GiNZ/OG6a9EM0qXn09Js8i7NFrG3vSG0BJiXG/diyEPQdE88vFuHzYtr4LHPlz7XhFNjQTeEwcvvEuNXvdIh9L9hJkkzJgrIY6cvtPJzhqBIXo8ZQNdpUveElPqj3uNXhKxk+C1gEMSjz/X8kv3O5gTHoOJQu/YFsS577ymx/kjGjIvyWq+r/o+pQW9rTjkp5bqaNvOnpzJ5BhrizmAiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgK+wk8bsGy4rKToqYdvg77hh1L0DI8bg/xj6fFNtII=;
 b=dM5Gp2RRTIqXkTszcVjwcnd1MjLTkJcHo9aqpbRpTA+9Dwrp3V0WE6VuU1Jiw3c3tTXty4/+qLZptE+5tiSvQjsSdTmCcI8g4GPA7wn3CKMI6NeXCiwZOQ0d0hDKdZ49LyIoQDCbavI5z7HIgcGB3SVtrAbP1vX8VUN07plflCd1xr/YE4sMl4A+9kHv51N34b1G5ruvx/jYFwspE19bb+r8vMBhFX8CM41q1mlORAKa8elGrva72vfY2ymRvAN589UcsFeezwaAyrxUa/RluvIjULPfyzKYCg4HlegXXanVa0Rl/iMkIjDdq5yTVe+erEkE8k2AGxjW/ga0ea8dAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgK+wk8bsGy4rKToqYdvg77hh1L0DI8bg/xj6fFNtII=;
 b=YFCO0C5me/uC1nCLz7623r5zrSUP06rrAsAFVIR2DqAo8Ra54jBqfWr0+VOntkpCowgMo2RWHPTDYYJcbAENP6FPwv0uKIiWg34Ab8rAkfpRzTpEny0Ixne6M/hzchDfVrWrlnS5xEmhph+OBSjKsycRelukhfPNpclhsGPtFV4=
Received: from BL6PEPF00013DF7.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:9) by MW4PR12MB5668.namprd12.prod.outlook.com
 (2603:10b6:303:16b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:03:22 +0000
Received: from MN1PEPF0000ECD8.namprd02.prod.outlook.com
 (2a01:111:f403:f902::2) by BL6PEPF00013DF7.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:03:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD8.mail.protection.outlook.com (10.167.242.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:03:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:03:21 -0500
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
Subject: [PATCH v14 09/22] KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
Date: Sun, 21 Apr 2024 13:01:09 -0500
Message-ID: <20240421180122.1650812-10-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD8:EE_|MW4PR12MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b0fb1f0-ec97-47af-16c7-08dc622d551b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vdq+VbfFpAn/rUDNdZCcdlEJ6yXayKY1o9aEnCfKtdsF9jvlsM2+fl0xafx4?=
 =?us-ascii?Q?yzOAIqzV7XBpafsu0NsAkPFgzglpX8OPzngCluUjfNTbMmGPdlTXe1ZXUP9b?=
 =?us-ascii?Q?SwaBt31TDqH/X5m6rrVP7b2+Gl6Uix4q0ePHgwy7s5seVXjmRUcWil4xNjna?=
 =?us-ascii?Q?Aaokj/Mrhb1R1txAzNnCrZ+oT8ZFHnuU9t42B50JiF9oggisCz824t7PGzOs?=
 =?us-ascii?Q?fifpHmfDr7qJsqksez7DomUYxYF8LQi0nripBSqHUM257RQNnT05bzRoaNOT?=
 =?us-ascii?Q?8ujMm8T4gUYoxbG9DrTkzpetGoJrfuVLa75L85A8BTfWJpc76C+EZD5+wzAA?=
 =?us-ascii?Q?tBhyLKqMUm5VTCbwaX0c1qZgcFgKP2J/DFS6zd6eSADFNT1Ig80g27eG21zC?=
 =?us-ascii?Q?pK9zGZtX3w6y9G54EkBlQSBtqBktFpS+VuWRGl1KAryq2MNgOEDHCPcohxxs?=
 =?us-ascii?Q?9XCdTkyn3ZuIO4qgLoWRYxhTtrOscSKXEqFkYHnJ70lIfPBTU+70njyLS+9B?=
 =?us-ascii?Q?bF+2fnFnptWBR07ZxZqnzryYMBJHRNdt6XcMhv8oJBnsDNtt1OgMz7RlYMJH?=
 =?us-ascii?Q?iqEQrCc+MwZjAYfehTULkLLS4W14u7Z9mRC/hsGKwryF+UfaWmCbXt+4s8rL?=
 =?us-ascii?Q?+Az2PGxEV5ADaczY9u1mULVQbvxRfaCk1b7vNTtV067jNqG/L95JWJBJ80bp?=
 =?us-ascii?Q?XA55OpSTCNnNMfJoJEMU8LMi9L0SlcYndcolAXj4C+TKAxZJUoghkEm6CYqv?=
 =?us-ascii?Q?JKJm3AvmEa4DY81iCqXKdhbOLR2gvCXd2lCIEO0JbjPIzAbrhV6qyFo43ccO?=
 =?us-ascii?Q?0Pcm0lyozDiPzpzamp3/BxqYPi7noZUTIoIw+A1ICoXEnul0tuFcsW7fOy1x?=
 =?us-ascii?Q?blu0gPm4KSaSrtd1k17sx6VK54sIvZVwRaqzx+iJI+5ltzAj6kmcZ0ohx7WD?=
 =?us-ascii?Q?jhA2sy5lTtAnCv3lWWQkE/cXZrCMUSfKuLKzF2iNOBvcyt3pPGp+hFQ8FfoV?=
 =?us-ascii?Q?1XpfO0iuv70ViQUWxJaiu1Q6FIASmFselt9whh8vSke9IND/87jCdv35XFll?=
 =?us-ascii?Q?npokilukwvtaZ2yu90YQCi7KD3xgXJAX0wK1uo2GU2Io35MfseBSJ7ipkVqT?=
 =?us-ascii?Q?Bu8EBvgtwTfeDa0hdm7T/7gmnxuDV0BhOTEU1rVnCPSOprGaVHOIq1mm+0y2?=
 =?us-ascii?Q?l5vc/IGPkN1Y4rUpfDR/qIrS6iwqS/JwXrfLkjRWaasABPNSYE2RQBI9C2vJ?=
 =?us-ascii?Q?SHM7vkiR5yAvvDSmOTGWuNFuUli+izUYbY41sxfBlDfofV5bNzBo/6RXyIH6?=
 =?us-ascii?Q?PRNsWFj5EgpNj4IBi/X55hJmTKajWdlwgvWsGlosFeXaRdjuowytA7vPzN50?=
 =?us-ascii?Q?jgeZdbUp3H/HgoJO9aLolIWIWlDB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:03:22.0188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0fb1f0-ec97-47af-16c7-08dc622d551b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5668

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
index 76084e109f66..f6f54a889fde 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3463,6 +3463,36 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
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
@@ -3561,6 +3591,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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


