Return-Path: <kvm+bounces-5382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 750558207C7
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB9AAB21758
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413FC14F7F;
	Sat, 30 Dec 2023 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KlHN4gmt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0298F14F65;
	Sat, 30 Dec 2023 17:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hxm+8tTzPLuQePT/FGpLqF+Cf8KBajqOC9jRRYm8g1uB3XT9RpASGpnw1UcIoZoa7q+vSDay1d03mk1gucQzPHtM72CHT5D1iavSby0kDfB1aiyB7FQ1rXmakDAigmdbaKgsGg+QTnQHlVjOKJPvP6sRrBjfJgAlmFq7oRHlWSwU5D3WIj7DhlVB+N1ezCobwzEtQDmuCpt5lpDZD01s/fFPTbRNiVTD2B20TlunR2+kVRyFLZYldXb3NwPpJhZMWU4cePZEA49aS1L+esSSiNEx1p7+CXJ2WwMfrWxUmL67pfP3ByT7dTZTLo3GhYas+OMIDbkdl14CTScuvbMeWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miccLJVGBi3hbb9h/1elk9nM/dQlCyC1MwhXZ8fGuyU=;
 b=AoXMc2OmbekzYGxROIaISkN+xIpzIR1JDsI2Hbvc4HrtYr7oMaqot/3dklOXlCuQ6+HeanilPn9WSi0GvBI2J8Gq0NVskpBK1Rup4H0d1Hp7/THvC1r0UrXpH8dbj25iNd5X/wGGmVhOhO04Bs6hHpiCB9m1R8Z+O9bZEEZvdQ15fEF7lpl63ET7CQddIwxrRMdLW9buPsRXSbVAJMIJ9zSt7kU4R/JxN38oNKWcpR0u33ymwvyOtbfWcib1Z5czpdYRbmMS3Piv+/+uhrf7R8wpFFaZMauSIda6WIHHz5A/Twvvat745+S5pIU7OGlgIf3Bi4FAV0p/LGqKZGnCqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miccLJVGBi3hbb9h/1elk9nM/dQlCyC1MwhXZ8fGuyU=;
 b=KlHN4gmtrr2xm6qstH9x9SxoI7YittIPIf/04xJIY3Knx0VSKKyfkZJdkgLVExVYlpqW08Ik0erby7dbMpb9QUV3RY8WegE9sQfY+fgxP6iUQ4Y9BnCGj9BJXkgJmYGj9AJiuqmUwWsAP0ZJ1qbBzx7Y3iXcsXPYs2uxMthYHOw=
Received: from BL0PR02CA0009.namprd02.prod.outlook.com (2603:10b6:207:3c::22)
 by CY8PR12MB8339.namprd12.prod.outlook.com (2603:10b6:930:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:28:31 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::4a) by BL0PR02CA0009.outlook.office365.com
 (2603:10b6:207:3c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:28:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:28:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:28:30 -0600
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
Subject: [PATCH v11 20/35] KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
Date: Sat, 30 Dec 2023 11:23:36 -0600
Message-ID: <20231230172351.574091-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|CY8PR12MB8339:EE_
X-MS-Office365-Filtering-Correlation-Id: 5aaa916a-244c-4652-7fcb-08dc095cbe58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6mfs5Bd1KVGTrsjXDCCqfw6IP7FU36s80CzQcCiwLD+WfzFbAtwYB+osCrUufjm3CKvUKjdHWs3yIWJntNb+0lEU55+wz3shLcp9UQDqyNzftj9BFuaAYTqO8ydtmYq53lnIP72WIyJh8MEQI2L3uEDEdZ7+0Pj1LnIVJIfH6h8cChGqhM6rwC2djTBlzNg3QgDnWAxCfw4XspjMWWA55Zj13ZC4QhdYhhegRc4lEfJZpBlWA2mpfDR2ea6Af3KzLR35UzEd7MZyxL6sp7UfhDanrkMs9yPadYweAhFmqgKY/5Q6ZyTxzNIHBx5ZsCcwhRmYemhhTGTVEGTr9S0NYrZE0C4jCqnlgZmHHBmzkmNUFvp3rdJ4U83G7wDBVkL8LWnbwFCn5r7VmjI3E8bvDQL0oHzNKbu9LsDUjRT6f+5/rduHWTRy9/aV6bJnKCFKOr3M+BnzGeqzkOeD3P92Y3FP7KC5rQAd5VP5+sPPpUYOVrQl8H5ubebdrnsbjKhlCAwrx6maD5asq3xEtmiY9k/SQk5rzC7a1PRmh3/lHBGtRkZjY2kLxZkxfT51pIeRNPMQ0H1D/ih+cETggAbdSPV+uMYYSD5ehh61WUSqI+TyiRMBVjEXVLuzlx3ECgSPqqpic0QfgFzrIo+G3FaF7DMg9bEoQKdt6NdbciN6DRCdzFsTmYl2LOtZIUat+DpPztGsaEB29tdocr0W0CadRFSO2B5h4tmGZ8Qn5nmWRhhVCjl6jU4w79Vov8YIWV0jDC+4Y7njqHeK1HlRlof/0w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(451199024)(186009)(82310400011)(1800799012)(64100799003)(36840700001)(40470700004)(46966006)(2616005)(36756003)(2906002)(86362001)(70586007)(40480700001)(478600001)(6916009)(70206006)(5660300002)(7416002)(7406005)(83380400001)(426003)(336012)(16526019)(26005)(1076003)(54906003)(8936002)(8676002)(316002)(40460700003)(4326008)(44832011)(47076005)(36860700001)(41300700001)(356005)(82740400003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:28:31.4254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aaa916a-244c-4652-7fcb-08dc095cbe58
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8339

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, verify that the GHCB GPA matches with the registered value.
If a mismatch is detected, then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 5a8246dd532f..1006bfffe07a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ada40a79b2f7..0b8837e21705 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3353,6 +3353,26 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_PREF_GPA_REQ:
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3416,6 +3436,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, svm->sev_es.ghcb);
 
 	sev_es_sync_from_ghcb(svm);
+
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9c633173b779..2bee24017bae 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -211,6 +211,8 @@ struct vcpu_sev_es_state {
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct vcpu_svm {
@@ -354,6 +356,11 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 	return sev_es_guest(kvm) && sev->snp_active;
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


