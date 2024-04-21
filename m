Return-Path: <kvm+bounces-15430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A10438AC076
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45DF1C203E3
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65DE3C684;
	Sun, 21 Apr 2024 18:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JGQNNVJ7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104183A8D2;
	Sun, 21 Apr 2024 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722694; cv=fail; b=IQHomuvO5gJHpfOrebaCXMAfHcaX4GsqUHTiriYKY90fpfpqELiEcCicfxJJt9P51DHDpUK4LqeMI06VQ/8Kyr4CPykS0zOBfVs5EAk/4sbeYd45BL4F+hOySMgK29sPS6yEgmGB9ctLyhX3+Qfrn7hoVRYRNVMdIOVC0eSt01c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722694; c=relaxed/simple;
	bh=Db5rwgn5Pj9YWeHIdOCy8PEe15elJp+PRGjImLgWs/k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MnPtfmMYu/Q5oRyUPy9UFxtprVMJbtSPHFuXZiqZH7WjMH5bSz81SY72ki0f+xvwfFdm9sWks/ZgSlRcWp24bj0ujr3AKrzjmXfUxe6/8sVVBQzEgpQlai9vbdTjdXIpcfjv7GMqmm1a1Rcqy6P6Ur2PdovcLydVkQqxsSfD1VA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JGQNNVJ7; arc=fail smtp.client-ip=40.107.220.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kb7MrtS6RQb5UAmLAN4bKBJFZLeoa5H4W7FDrgYQk+9SyEQxoETRACvXZb+KHegM6dl4m+NnUYlFDRBhX+Cg5JnAXSzJ2nxzBkjPCKUzlf0wZhWj22veKwpLD4mZFs3ypy4HOIleAsUx/fCfDWO3NGj61HnhS5V0U3eBpG5VYOZs0CzBy7wAEBHE/r6yZkuVKM08tKU27jZ+aAECEN//KriDmRXCoyV2BljTNW1fI94YxAKnn5zOxco1OV86KzP6Sih3jVNjpAek2nDkDpM6CaL9QTz/XnTu7F30NprMp+1BTOl/jt+V56iBtfrF0yt4r5AXmiM4MwEWG0RjWMuppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQAiXfOM/3SgxppVrmPGEZoI09fg6zDss3nrFIdmRvo=;
 b=YZZmcpQ3/MR5SDIbWvCLB/wPoNRZkGEqUxktFbYKO4QBk0xsSGbXxUea17OLZXZ3nEIwDpvGxFA9StUSQNtlXuvC4jmV6JieYxc1DhMLjAgiM1+6PvkGGXyBOPxdFp2ro2PUetdjIurNl1Jr28NaNoov8y848GbRDT+zQkkcVbDEqEuc3CyzA6UCBAma3kLmvpThBz1v85Q3Td9PnH7dgV8IPwLgGys6NzmPp9FdKeyqgzDKFe80iYc0SSCwv6fl8zeVXCN6tKTEC+0rtvdjcj/VWmrvZApjoChOkJdtHEVNWdzx69aJjr8vUDb46A4pA9P/eHRwJd0wlJkoyjLxFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQAiXfOM/3SgxppVrmPGEZoI09fg6zDss3nrFIdmRvo=;
 b=JGQNNVJ7DvRzsAS3eKmM10UECCZeBZ+cK9VM0AtXI0ZDYYTELL1ugJ2ef9yu3SgGNUgiKZwj8k4uA4WqEhcb0alqRgdWVdbpF857Zs9HSR5zYgeOrwd9cqinqDZpiurdepBYD4ysye5XiAMFw2UCdQr+y1qHRsGu9sE3bFCF3vs=
Received: from BL1PR13CA0158.namprd13.prod.outlook.com (2603:10b6:208:2bd::13)
 by PH0PR12MB7908.namprd12.prod.outlook.com (2603:10b6:510:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:04:47 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:2bd:cafe::b3) by BL1PR13CA0158.outlook.office365.com
 (2603:10b6:208:2bd::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20 via Frontend
 Transport; Sun, 21 Apr 2024 18:04:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:04:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:04:46 -0500
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
Subject: [PATCH v14 12/22] KVM: SEV: Support SEV-SNP AP Creation NAE event
Date: Sun, 21 Apr 2024 13:01:12 -0500
Message-ID: <20240421180122.1650812-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|PH0PR12MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: c882ede4-bebd-4011-11e1-08dc622d87f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HuniGN1ApAj8XiJPiySfSE1OL1aBZ0T+OCmplsq8BZund/NZiiflxOPpWzco?=
 =?us-ascii?Q?Vn4OEKxNrDGcWv484hiCcbQaqaJRIXisOVKKJl4UYPmXW5OD7PAlVqmnKU78?=
 =?us-ascii?Q?OXNT3GVuXi4SbbEZX9tGN1uooai14ED6YVubsjRa/Eby5vqQF/X+Z66QLYjk?=
 =?us-ascii?Q?/kut4z85J+c7edXpDO5y4b3wA7uzvGVefMvJLW8RfvL8E5hta0tHA9oOfrsz?=
 =?us-ascii?Q?8s5GgD82H4rTm4tKdwcldOVBHUOWxnhnO62+zzOakz1BkwqATAIW2NqqUYY1?=
 =?us-ascii?Q?pOD3UOoHkVo6Livp+yv+LerJv5hWAHUj9ZbXPy61AvezuTVbHBVCdVHZm0wa?=
 =?us-ascii?Q?fqklRAeNHSe5Hy0/4V6S6W21ADSALOZhfPzFnJGro/JFx2dSfoNO9To9dcIL?=
 =?us-ascii?Q?4Adt/93BUu08qHEDz5kmE+YYBb3sm+tT251Ri/grncixAV1tV+dH1g3Un3Mn?=
 =?us-ascii?Q?HvbKByy27l3sWWQ0cfIqjAKB/Ilyv10WJNEiGC3ZUt/38U9DLJNSoxjwMpkW?=
 =?us-ascii?Q?5qL34kb2THEB49jRlmBDbBWsgTUVyeAiw/TXf+vnhFpbFTjOSGAYOPtk4GvR?=
 =?us-ascii?Q?QqmAIgW10EZmhvK4RbA1wlDi6npNOBawoyFYelM4pg3iQAD6pB0ibfJacg8v?=
 =?us-ascii?Q?BAOBFkCLuoGU5cwDDko/aFoPkND/IHvvwGi8zTY0pSqPLfeVXSaDUiKXybFU?=
 =?us-ascii?Q?Isoet8jSRvXTNhilyvPPyuHXZcp2+5YCy0D6EANXsf1iKFFfrygc8DUP7m01?=
 =?us-ascii?Q?k36cec7UqIGwV4pEzRFj6N3EQbDT52hSdg9em5BRWXMqcauCe0L168oQ/SHp?=
 =?us-ascii?Q?YasOzLV5xjGBGuvHEgZPmnx4ByIGOTLXWk6fFiXYE/SYoYE97L8CDBy2D4Ss?=
 =?us-ascii?Q?2+MmsE6IPgefxGG0Tc/RY9j8ETEDkvjqN+h3NZgDOXQGX95X3EWnHWlHW+sn?=
 =?us-ascii?Q?NtyZoPxLuE1bvk3ejsjfzgHlRXfip1dxOBdI8TwXVy7wa1qls1dbl72yskzH?=
 =?us-ascii?Q?oXFdDNxS5bEd8ARttyIpS5JVZZ3z66k57KomgNfMW4zWSs8Ep8rJbpYAgEPY?=
 =?us-ascii?Q?kBxo48Pe7108p+xCCJroHh2ljP90L17tF8ShrGbt4x/jRbAeK8Hx3motBOh0?=
 =?us-ascii?Q?3u6Ur2agjfuYLxwH98XcxEpTpn75/WucgFnA73I9JfRfyQtb+OlNRtK1lIsD?=
 =?us-ascii?Q?XBpXcVKBAZBFOf4k0z2EYFPMhTs27SO1llVH+orDTTocuOcxS6TBkQp4Ziv7?=
 =?us-ascii?Q?L6phIIskulgDHqpwyLKx6oEmJmhcen05RMlMsylQ1guBEhFi1Oqt2LnOrsCn?=
 =?us-ascii?Q?/Z6no0LhM1PDjfmno/nCYIYdwMGcdG22dCHpFYAZBJRS08HuoFtzL7LfcRZO?=
 =?us-ascii?Q?9JMvnQY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(82310400014)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:04:47.3596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c882ede4-bebd-4011-11e1-08dc622d87f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7908

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
guests to alter the register state of the APs on their own. This allows
the guest a way of simulating INIT-SIPI.

A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
so as to avoid updating the VMSA pointer while the vCPU is running.

For CREATE
  The guest supplies the GPA of the VMSA to be used for the vCPU with
  the specified APIC ID. The GPA is saved in the svm struct of the
  target vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
  to the vCPU and then the vCPU is kicked.

For CREATE_ON_INIT:
  The guest supplies the GPA of the VMSA to be used for the vCPU with
  the specified APIC ID the next time an INIT is performed. The GPA is
  saved in the svm struct of the target vCPU.

For DESTROY:
  The guest indicates it wishes to stop the vCPU. The GPA is cleared
  from the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is
  added to vCPU and then the vCPU is kicked.

The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked
as a result of the event or as a result of an INIT. If a new VMSA is to
be installed, the VMSA guest page is set as the VMSA in the vCPU VMCB
and the vCPU state is set to KVM_MP_STATE_RUNNABLE. If a new VMSA is not
to be installed, the VMSA is cleared in the vCPU VMCB and the vCPU state
is set to KVM_MP_STATE_HALTED to prevent it from being run.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/include/asm/svm.h      |   6 +
 arch/x86/kvm/svm/sev.c          | 229 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  11 +-
 arch/x86/kvm/svm/svm.h          |   9 ++
 arch/x86/kvm/x86.c              |  11 ++
 6 files changed, 264 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 90f0de2b8645..54aafcb50d8b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -121,6 +121,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 544a43c1cf11..f0dea3750ca9 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -286,8 +286,14 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 
 #define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
+#define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
+#define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
 
+#define SVM_SEV_FEAT_INT_INJ_MODES		\
+	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
+	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 65882033a82f..67e245a0d2bb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -37,7 +37,7 @@
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 /* enable/disable SEV support */
 static bool sev_enabled = true;
@@ -3270,6 +3270,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		if (lower_32_bits(control->exit_info_1) != SVM_VMGEXIT_AP_DESTROY)
+			if (!kvm_ghcb_rax_is_valid(svm))
+				goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -3520,6 +3525,205 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
 	return 1; /* resume guest */
 }
 
+static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	WARN_ON(!mutex_is_locked(&svm->sev_es.snp_vmsa_mutex));
+
+	/* Mark the vCPU as offline and not runnable */
+	vcpu->arch.pv.pv_unhalted = false;
+	vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+
+	/* Clear use of the VMSA */
+	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
+
+	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
+		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
+		struct kvm_memory_slot *slot;
+		kvm_pfn_t pfn;
+
+		slot = gfn_to_memslot(vcpu->kvm, gfn);
+		if (!slot)
+			return -EINVAL;
+
+		/*
+		 * The new VMSA will be private memory guest memory, so
+		 * retrieve the PFN from the gmem backend.
+		 */
+		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
+			return -EINVAL;
+
+		/*
+		 * From this point forward, the VMSA will always be a
+		 * guest-mapped page rather than the initial one allocated
+		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
+		 * could be free'd and cleaned up here, but that involves
+		 * cleanups like wbinvd_on_all_cpus() which would ideally
+		 * be handled during teardown rather than guest boot.
+		 * Deferring that also allows the existing logic for SEV-ES
+		 * VMSAs to be re-used with minimal SNP-specific changes.
+		 */
+		svm->sev_es.snp_has_guest_vmsa = true;
+
+		/* Use the new VMSA */
+		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
+
+		/* Mark the vCPU as runnable */
+		vcpu->arch.pv.pv_unhalted = false;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+		svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+
+		/*
+		 * gmem pages aren't currently migratable, but if this ever
+		 * changes then care should be taken to ensure
+		 * svm->sev_es.vmsa is pinned through some other means.
+		 */
+		kvm_release_pfn_clean(pfn);
+	}
+
+	/*
+	 * When replacing the VMSA during SEV-SNP AP creation,
+	 * mark the VMCB dirty so that full state is always reloaded.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
+	return 0;
+}
+
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
+
+	if (!svm->sev_es.snp_ap_waiting_for_reset)
+		goto unlock;
+
+	svm->sev_es.snp_ap_waiting_for_reset = false;
+
+	ret = __sev_snp_update_protected_guest_state(vcpu);
+	if (ret)
+		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
+
+unlock:
+	mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
+}
+
+static int sev_snp_ap_creation(struct vcpu_svm *svm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_vcpu *target_vcpu;
+	struct vcpu_svm *target_svm;
+	unsigned int request;
+	unsigned int apic_id;
+	bool kick;
+	int ret;
+
+	request = lower_32_bits(svm->vmcb->control.exit_info_1);
+	apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
+
+	/* Validate the APIC ID */
+	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
+	if (!target_vcpu) {
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from guest\n",
+			    apic_id);
+		return -EINVAL;
+	}
+
+	ret = 0;
+
+	target_svm = to_svm(target_vcpu);
+
+	/*
+	 * The target vCPU is valid, so the vCPU will be kicked unless the
+	 * request is for CREATE_ON_INIT. For any errors at this stage, the
+	 * kick will place the vCPU in an non-runnable state.
+	 */
+	kick = true;
+
+	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
+
+	target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+	target_svm->sev_es.snp_ap_waiting_for_reset = true;
+
+	/* Interrupt injection mode shouldn't change for AP creation */
+	if (request < SVM_VMGEXIT_AP_DESTROY) {
+		u64 sev_features;
+
+		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
+		sev_features ^= sev->vmsa_features;
+
+		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
+				    vcpu->arch.regs[VCPU_REGS_RAX]);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	switch (request) {
+	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
+		kick = false;
+		fallthrough;
+	case SVM_VMGEXIT_AP_CREATE:
+		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
+				    svm->vmcb->control.exit_info_2);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		/*
+		 * Malicious guest can RMPADJUST a large page into VMSA which
+		 * will hit the SNP erratum where the CPU will incorrectly signal
+		 * an RMP violation #PF if a hugepage collides with the RMP entry
+		 * of VMSA page, reject the AP CREATE request if VMSA address from
+		 * guest is 2M aligned.
+		 */
+		if (IS_ALIGNED(svm->vmcb->control.exit_info_2, PMD_SIZE)) {
+			vcpu_unimpl(vcpu,
+				    "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M aligned\n",
+				    svm->vmcb->control.exit_info_2);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
+		break;
+	case SVM_VMGEXIT_AP_DESTROY:
+		break;
+	default:
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
+			    request);
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	if (kick) {
+		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
+
+		if (target_vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)
+			kvm_make_request(KVM_REQ_UNBLOCK, target_vcpu);
+
+		kvm_vcpu_kick(target_vcpu);
+	}
+
+	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
+
+	return ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3763,6 +3967,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->vmgexit.psc.shared_gpa = svm->sev_es.sw_scratch;
 		vcpu->arch.complete_userspace_io = snp_complete_psc;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		ret = sev_snp_ap_creation(svm);
+		if (ret) {
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+		}
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -3857,7 +4070,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * the VMSA will be NULL if this vCPU is the destination for intrahost
 	 * migration, and will be copied later.
 	 */
-	if (svm->sev_es.vmsa)
+	if (svm->sev_es.vmsa && !svm->sev_es.snp_has_guest_vmsa)
 		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
@@ -3930,6 +4143,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
 }
 
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
@@ -4041,6 +4256,16 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
 	return p;
 }
 
+void sev_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu) &&
+	    vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+}
+
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 {
 	struct kvm_memory_slot *slot;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7c9807fdafc3..b70556608e8d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1398,6 +1398,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
+	if (init_event)
+		sev_snp_init_protected_guest_state(vcpu);
+
 	init_vmcb(vcpu);
 
 	if (!init_event)
@@ -4944,6 +4947,12 @@ static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
 	return page_address(page);
 }
 
+static void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+	sev_vcpu_unblocking(vcpu);
+	avic_vcpu_unblocking(vcpu);
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -4966,7 +4975,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
 	.vcpu_blocking = avic_vcpu_blocking,
-	.vcpu_unblocking = avic_vcpu_unblocking,
+	.vcpu_unblocking = svm_vcpu_unblocking,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d2b0ec27d4fe..81e335dca281 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -210,6 +210,11 @@ struct vcpu_sev_es_state {
 	bool ghcb_sa_free;
 
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
+	gpa_t snp_vmsa_gpa;
+	bool snp_ap_waiting_for_reset;
+	bool snp_has_guest_vmsa;
 };
 
 struct vcpu_svm {
@@ -723,6 +728,8 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
+void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -737,6 +744,8 @@ static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
+static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
+static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
 
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 14693effec6b..b20f6c1b8214 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10938,6 +10938,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
+			kvm_vcpu_reset(vcpu, true);
+			if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE) {
+				r = 1;
+				goto out;
+			}
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -13145,6 +13153,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (kvm_test_request(KVM_REQ_PMI, vcpu))
 		return true;
 
+	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
+		return true;
+
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
 	    kvm_guest_apic_has_interrupt(vcpu)))
-- 
2.25.1


