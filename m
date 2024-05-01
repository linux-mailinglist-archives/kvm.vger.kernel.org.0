Return-Path: <kvm+bounces-16310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD958B8722
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 552851F22FBA
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5571502AC;
	Wed,  1 May 2024 09:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HrcAlvMI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6F750298;
	Wed,  1 May 2024 09:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554224; cv=fail; b=g6RRyUWeJ96kZiAADfYO/+Sb/nS64nJKMWo0KaRmd7jWhQqJboXZQ4r+RaXj0HfDJDJLLX27RPtQfb2Wx8LVO8FIk7pAhoxYLZS+OSErHho8FaNe+uKDS8MSrkd7y+wRp+mRaHaSu6pJbb+PjmdaJV5RawoDmExr4DfY5vgNw9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554224; c=relaxed/simple;
	bh=dOTaswYI57u15PKqcKRohV/wBsRQafuCXu5A6G7ZDnc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJ8eLqQbC3QpRBObxLgdb8p1eJWwaiY5+We6lfiwewnyTtv5StwLjEcQ31fBaTU+Rqa/4sKJVtnUEBNtT49SYrokHjvn4KZyZZ7iJnlfaL3nZLKAzz6j5wg6wTH0uo85VKNqySzwexOT4Z8WomBCNrx5Uuz2g73YgrOrE5Gx5lM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HrcAlvMI; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hagtb1E5PufxIsCMNj+5tXOpBN+fGI/uWA0hQkFIiCOA6/rNaQzJvc3PVZE+KSuA3wDdR9U0uiR7CHTTa6TInRimhRir+/AFQlzzKXDdEGskj2caMS0/0ZWrn3QQ1VgslujIb3pNBFA06vuqiIrSkyve8Q41i9G8xbJXIVjQawr3svIHpHz/W2N4Sa+U3ejy58iMYpIO1RfyRWCmQD03KqxOQh09EfjNHkHkGab/lnYNhCH0Li/qMF0eoIvzVBOvd6bTLBasqW48dyBk0CJqWVx/LUPlx5QCqTeSA6O0wN9+Dg8LjFafg6esKDeQioB1I8A60Jv1/A7zp73GiAPczA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cQRxjWkX0ns1Fxh0GJaedpqgPFyIsP2jvvzy9GSh+E=;
 b=gywnxsjhBG1MsZIxof7m+MVBGqLiZoL7VAtkbCtqtH7CoeYaHJZvOMgqPB7g/BXNjUllCxdQoIQTDOV/cXpBFUbnOuCr1GkzVM91zq6HDdxC6WPLSEEzbr9coxZ+Q3SJ13wqcfQEYBD2fPfqdqDm4Z/6F2bLm9Fw7EvqOEQ1bKzRpHy1aT3VKB+jcJ9xzLNIpkK60JS0eewGHL7vk8B4MF7pNuLtWsSKz7IfjYAw5IUmy9qFtNgYPbt2qYkUTpD+79T9hhKr7v90dA1aXcI5TiniQyfbVglW6yDyd2/g5BtWoxB6lEr0eLK8PiH7eUs9irsOoCHKxzCTf5Yz1eRXVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cQRxjWkX0ns1Fxh0GJaedpqgPFyIsP2jvvzy9GSh+E=;
 b=HrcAlvMI/5zptcjXzR2eYdBAj7mt1oDsHaWhZwwGNJPHlm78WSspFUcfUTP9lIqZehbyH2u5jh00Xef+tygen5k08fmV2Mv2wHQEojg1v7VAyxoDrxWyuI9qV6JrpPz8GzjuE4kSvPItLAE+gEpsE19KQK1rHn+OhtUwRfWD4Eg=
Received: from SJ0PR05CA0166.namprd05.prod.outlook.com (2603:10b6:a03:339::21)
 by SJ0PR12MB6734.namprd12.prod.outlook.com (2603:10b6:a03:478::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 1 May
 2024 09:03:39 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::ff) by SJ0PR05CA0166.outlook.office365.com
 (2603:10b6:a03:339::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.25 via Frontend
 Transport; Wed, 1 May 2024 09:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:03:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:03:38 -0500
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
Subject: [PATCH v15 12/20] KVM: SEV: Support SEV-SNP AP Creation NAE event
Date: Wed, 1 May 2024 03:52:02 -0500
Message-ID: <20240501085210.2213060-13-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|SJ0PR12MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f99f4e3-02c3-4b0f-2161-08dc69bd97b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|82310400014|36860700004|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ARAnaOL1+wRHK+YhFmwKaKVd6DAyAfn8eQ/8TDdC7q/Mtzx6WLahIzEuWS0c?=
 =?us-ascii?Q?kpSfIDtwihHjxGnY5RpsLIPsBOh44Udk3T850r3UooRQj4lkMEz7mvH9u81Y?=
 =?us-ascii?Q?nCeRKmyMx5X9CQfPch1Wdm/nldhTtskqbI2oLfmBCYIM6sRqxrdcK0aSnNpD?=
 =?us-ascii?Q?DGHvS6UNvR3uSBAbu+b1o6aeo7S688HyQRuqpwLBjbjOqhjc3F5OcTzRg/i1?=
 =?us-ascii?Q?MuE+VHU1YPo4F/XHjZboIxTD/nv1QxFN1kc1xAwdNydR8heBrArAmenACUTR?=
 =?us-ascii?Q?ZxemJ7ZbCLMDf3HJdeD1yXIosmYNsYLxzy2xJPOxORQszo7rsBPzTwXlwd4m?=
 =?us-ascii?Q?XCipKmlwv4MbFzXFoVOk11756lNGMA6eubwTWhUJ3ky6JbcGF1/SHK3I/9YB?=
 =?us-ascii?Q?ZnohYiFZ1lRE8rzLK366lrt1TwlNSHImzb99OHTbOt6RHpP1Pf67sSeEuold?=
 =?us-ascii?Q?+siGp/pA9WVtijIH8xz49pWlRMOxyCt4fJcy1PMGtjPb/MNl1ER+ELyy41WA?=
 =?us-ascii?Q?qVogZIo2RQ2QjZz3Hir8aie4QXin4Pt8RmT90zYHabKVftJbjD+ViRMg5m3Y?=
 =?us-ascii?Q?MfBql2ZhmlJ1WRBViT3Fl16442nORbmmRLq2sspQftHywSiqHIcCBckVG5Un?=
 =?us-ascii?Q?QHyV4e1HFU373Xo15jYtgEiUXE+AsmBg8TkTjYKIfik6LIF36A7eAJM75C4e?=
 =?us-ascii?Q?PLc/CCmQD2w2sKCMSm6ZCwXyZsAEqhjw2+RBFv7BLeDxWshJY/iaLAjGtY9r?=
 =?us-ascii?Q?bUuyGMeYylQXbbMmgzsVs4y0QIgBiUkOPb6dofUnBfGFYXOWWX9nrYUGrKQU?=
 =?us-ascii?Q?rFGFPDxaNWxhltcvFhAba69GeqjWLNnwYXvMPHJvRkE/RQbZIfhCnwme6UTH?=
 =?us-ascii?Q?Wli43kbwx85paTJiVW+P4E9HVRSlVlY1v/8V4yeApVgr/mSNz8vbgzTRe4K4?=
 =?us-ascii?Q?1XMOzGNix6n0qjtDP4EOrAGoUp3VBgEnyw6ATrra5NDT90pDdKbCU9ibJNin?=
 =?us-ascii?Q?aKTTpS/QfWijI8Rk8V9cwOVAxjr3BYt6oNJ5zF9B4LU/yxHkeiJawicLJXxB?=
 =?us-ascii?Q?oy2mDvCB6Lq6nyycA+hUTvVkGEyr5DEV0R6p9DBnxbkwazhBMSDFB/GuDYZm?=
 =?us-ascii?Q?u1ObAOKKaagUKi6W1j2uqwbCI1GB/cN0bcoJssECRD+noQSS48eIdIzEKTi1?=
 =?us-ascii?Q?bqX16dzoXj9zVuTYQvCk5OC3Iv4iJVqibXIYPfLQBVfBxnI/EKYKPlnU1XzC?=
 =?us-ascii?Q?11kJWxc5oi+1r0yPULTgPyNALbF1nycUMor9VtAUGDx/Wi9P33WFKni0uYUE?=
 =?us-ascii?Q?BpnipQqIXHrTDTuo3cV+t7rbNXRDXGS/IuDgkoW0Kr4UG1v6o5cT0N3nwQGR?=
 =?us-ascii?Q?YZDUZJA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:03:39.2974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f99f4e3-02c3-4b0f-2161-08dc69bd97b2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6734

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
 arch/x86/kvm/svm/sev.c          | 231 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  11 +-
 arch/x86/kvm/svm/svm.h          |   9 ++
 arch/x86/kvm/x86.c              |  11 ++
 6 files changed, 266 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8a414fc972f8..cd5f99a8891e 100644
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
index 7f5ddd92113e..69ec8f577763 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -38,7 +38,7 @@
 #define GHCB_VERSION_DEFAULT	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
-#define GHCB_HV_FT_SUPPORTED	GHCB_HV_FT_SNP
+#define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
 /* enable/disable SEV support */
 static bool sev_enabled = true;
@@ -3267,6 +3267,13 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		if (lower_32_bits(control->exit_info_1) != SVM_VMGEXIT_AP_DESTROY)
+			if (!kvm_ghcb_rax_is_valid(svm))
+				goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -3693,6 +3700,205 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
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
@@ -3958,6 +4164,15 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = snp_begin_psc(svm, svm->sev_es.ghcb_sa);
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
@@ -4052,7 +4267,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * the VMSA will be NULL if this vCPU is the destination for intrahost
 	 * migration, and will be copied later.
 	 */
-	if (svm->sev_es.vmsa)
+	if (svm->sev_es.vmsa && !svm->sev_es.snp_has_guest_vmsa)
 		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
@@ -4128,6 +4343,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO((__u64)sev->ghcb_version,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->sev_es.snp_vmsa_mutex);
 }
 
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
@@ -4239,6 +4456,16 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
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
index d779f1f431af..858e74a26fab 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -216,6 +216,11 @@ struct vcpu_sev_es_state {
 	bool psc_2m;
 
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
+	gpa_t snp_vmsa_gpa;
+	bool snp_ap_waiting_for_reset;
+	bool snp_has_guest_vmsa;
 };
 
 struct vcpu_svm {
@@ -729,6 +734,8 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
+void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -743,6 +750,8 @@ static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
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


