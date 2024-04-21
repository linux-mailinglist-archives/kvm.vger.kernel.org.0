Return-Path: <kvm+bounces-15444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB068AC0A1
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FBFA1C2098C
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3303CF79;
	Sun, 21 Apr 2024 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dw+McJs7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69426383A5;
	Sun, 21 Apr 2024 18:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722992; cv=fail; b=h3bom4u2+aGdW9vUxavnJdO+hn+nSsfWs8mcBUalB91Oto3vHdqy8QPkLAzB7nHW1T0saVwSwcM6wngXEFWMhmRmD1OFqry/sN6KVuwgrvf/fTSJ9ZJ61fdYU34s+PZZcfV5ydRubVykFWNmyCLP/FfbjIczCMBXygYf8ZxGyKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722992; c=relaxed/simple;
	bh=7JeGrZPXit/c1i1OU07Zt6zNiWsezF7TrV5q87+gFM4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgQphwqGraj4EWj12eKoKE1iAOB2QcB4O8scOQPP4H8AhAGaX9EC3+YBaDXYJm0vTXH0sb0vlmrKtUzz9bVstrrPjZV/nLRiOiCQrO/uOEbUzaaG1X26mpS1kNK8R3TAk1U10dRxdHYDFvu8xW4+Fs0w8VCR8nY49aweShoy5p4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dw+McJs7; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOkDr7Owd8bltmHWBf/3CsuSG/hpTmZDPN8TfZwcsFNAG+OtPj8nz1PeexcnEowaLsiXvuG2wUpY63wQO9ddQarxTjLaVuXKNraocN51n7xySagJ9xcPrS/5QuiBGj+CXVOnuL6kKAxUXWlaM1Tsa2c25zAVl5pzNlIyl03dUe7IsKwz8/hbuRDp7O4/QSXaQqkwK/L5DnL/iPfPAVCDVgrMenp8irZZwIcX1DW/L0S1tFBSMuzG054dTTzDy7w1Qd7TwNZmG2itf7MAPdrkYeOJb4o/KruHHrtb1tmhwZQ/kG9uyj2MiF2yAQ9ViCR+WQDpDWPbs8fgx90IszpXUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jND0rIFSni1fzAPb7rFmVX0m2deMiEZ6Fpm7E+781BE=;
 b=UnDpZUEEAttZL9jOs81v9lBjM9C+VVUprqai/PpV6VI/1wLkfPkFm5VbbjrWEps3Ewm8euNKGbmUVzIZp+u2YMtyJKSXUu4ERFKOqs+WD0v8iTFVnmhSZ8YC7vUVVAjkcgUGerfvLQ01/uPVUStw3mZY5HRD7z0iOCUFw7hWfkcb4vKAB4o7AB0/4hdv4SgGtUsbyipyyp9bY+Bv87rpuheSPtyKcLxZgcq0eqOI/CX8kJhEUy4SpCTuGBfQ8zIcVGMGJvV5X19MT70B+QdIQoRnXp0aOLtIZgl6+q+0ZuYSY+1O1P30KDv+Vk0vboLplHrflr+V4A+JNq9SE41BNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jND0rIFSni1fzAPb7rFmVX0m2deMiEZ6Fpm7E+781BE=;
 b=dw+McJs76Lpvse3/QGtF2piy3q+sKkPjMdMvbKhSabfAOmiETPrUzwltBMa2MRx3LgCOi6rRK0t+djt09kQ22NYsnqyw6fuxcgj1FPg2HosJBJOSpBhkq344xLFP1nOuQVNjwwH0+oXUy7f7D1Zpc2IZHhJzdEKJR48AGIBywPY=
Received: from SJ0PR03CA0200.namprd03.prod.outlook.com (2603:10b6:a03:2ef::25)
 by CY5PR12MB6525.namprd12.prod.outlook.com (2603:10b6:930:32::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:09:46 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::3e) by SJ0PR03CA0200.outlook.office365.com
 (2603:10b6:a03:2ef::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.31 via Frontend
 Transport; Sun, 21 Apr 2024 18:09:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:09:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:09:45 -0500
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
Subject: [PATCH v14 04/22] KVM: SEV: Add initial SEV-SNP support
Date: Sun, 21 Apr 2024 13:01:04 -0500
Message-ID: <20240421180122.1650812-5-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|CY5PR12MB6525:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bb56b3f-0b07-4dee-9607-08dc622e3a2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N9uJPWQfKD2LksVi60ok3FruV3KGaWo5O4KpE+QDzQZlairD2IKOsUdnQ2FX?=
 =?us-ascii?Q?I9HKc6XQQh+F4TZfz7/C9nStlqBiLQ6XCf9cvP2AQvceYVXN6ua+wxI2UZuv?=
 =?us-ascii?Q?LsnuzV8yo4vSrD5cqjvqJGXmjU5KNTng6sxTcuF5ZFdNhZ+C52ZM31RLfy7/?=
 =?us-ascii?Q?YTdzzMGUFTTMj4iA6wBB7TlzaDLMRtg7TRs9NJ2ih9iWQKcfvveS673WlQt+?=
 =?us-ascii?Q?wlzLMPAp8b4cieYUvRnK2Ch4Z5nbtl+srYjcqiZ8ITsnGfcvRcQPSdNfStyB?=
 =?us-ascii?Q?/g6dC27G617Z4fskoLEnRP37pHpSu9X6kXbKHNny0epl+/YjR1y3DfuFNfkn?=
 =?us-ascii?Q?IBvrA+33Odjc640tEUtrwv2aOGU/10OwgymlSWZNHZHlIieZ1VK34NbK25IY?=
 =?us-ascii?Q?oZmc7uLQGQduSXLyQBZKxj1J9XgUTaejYR2xk75WwmfPYQPC6eprSHW4gvgf?=
 =?us-ascii?Q?b9mBSkjmKvCN8YKx9aHJ5fBMW92JIoaN2lXyNaonOc1Vcvgh/e5N07BnB6xZ?=
 =?us-ascii?Q?wLyMetvwkieYHIaqlcP+Sd8Av/tt36sMrhBieR6o2WmluiKuyQRnN+qnhktG?=
 =?us-ascii?Q?tpltCuzo2SW0kqEQlGO5CHsCsoGxG8l9jiPoa4jizC0Mn64kpAp35x2DGbju?=
 =?us-ascii?Q?s+WXnpaw1OGCQoK+5RXZifDLTUyS83BZXlUPH87LG4N3Y1msUuVmATfr41gx?=
 =?us-ascii?Q?uzi8WglH2dgDDkoGY/mCICSR1TAhu/HdP1yVEuCo7O2bMWFOWDWjVjG2QZkg?=
 =?us-ascii?Q?rB6BDvuO0TVdg+CbkiT+WScESB7ca3f635MsvDlo0IXeDnw/L7A8PS4AnIec?=
 =?us-ascii?Q?t+6kvZKDwVt0xSV7v8r8D5nMK3+CC/FKtdztQisL+5P6JpY/I9bZolMMz3uR?=
 =?us-ascii?Q?NUDOTFlu5YYv7gPaNQd8xBdakoPSFtcj5K/ceFseWv5wKBPDnODnCSIaYy0Z?=
 =?us-ascii?Q?/rBVs9FYWf5T8RDpABfLB7KbJl13qnUTHN9o7CSkIoWxRXRNc0D8lMgpsmhi?=
 =?us-ascii?Q?YtGDGvaS2iTvUPXjazPbZ+VBbMFD7xtPbILN14POoH5gCSS133CshEfs1MJC?=
 =?us-ascii?Q?hWcvryFkCYDRRGWQgKQuO5giHVZWq99iIp27ykdVk9G1ZenWn6Evk27M7JZa?=
 =?us-ascii?Q?tSRLPruKG8xPmCDkWbjHHDDirb2+ZeODo3GDHWzxM8N9Lz5eCTOddyv8dyvD?=
 =?us-ascii?Q?WY3Btdl9hjylJfBitVOFr4yqoRauUXafyTtzqLLYksHwlZ5HKicGjS1kwJuv?=
 =?us-ascii?Q?oQTUAwwmFl1t4rUjnzxObiS9KpPo06reht1UtSu7/TXXK7HoQ1gkEumIrcHP?=
 =?us-ascii?Q?XaFj3qMSWmnrEjeUM0NPZqFjJgDmpmKSw89c1OK25tbOR/j75Cbmx0dXbdqU?=
 =?us-ascii?Q?9cPssWK4wjEEfOXjbhfAbYUEdDRB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(82310400014)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:09:46.2692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb56b3f-0b07-4dee-9607-08dc622e3a2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6525

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based security protection. SEV-SNP adds strong memory
encryption and integrity protection to help prevent malicious
hypervisor-based attacks such as data replay, memory re-mapping, and
more, to create an isolated execution environment.

Define a new KVM_X86_SNP_VM type which makes use of these capabilities
and extend the KVM_SEV_INIT2 ioctl to support it. Also add a basic
helper to check whether SNP is enabled and set PFERR_PRIVATE_ACCESS for
private #NPFs so they are handled appropriately by KVM MMU.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/svm.h      |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 21 ++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  8 +++++++-
 arch/x86/kvm/svm/svm.h          | 12 ++++++++++++
 5 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 728c98175b9c..544a43c1cf11 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -285,7 +285,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 
-#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
+#define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
+#define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 72ad5ace118d..9a8b81d20314 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -872,5 +872,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1d2264e93afe..c41cc73a1efe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -46,6 +46,9 @@ module_param_named(sev, sev_enabled, bool, 0444);
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
@@ -275,6 +278,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev->es_active = es_active;
 	sev->vmsa_features = data->vmsa_features;
 
+	if (vm_type == KVM_X86_SNP_VM)
+		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	ret = sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -326,7 +332,8 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
-	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
+	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM &&
+	    kvm->arch.vm_type != KVM_X86_SNP_VM)
 		return -EINVAL;
 
 	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
@@ -2306,11 +2313,16 @@ void __init sev_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
 	}
+	if (sev_snp_enabled) {
+		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
+		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+	}
 }
 
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2391,6 +2403,7 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2403,9 +2416,15 @@ void __init sev_hardware_setup(void)
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
 			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
+		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
+			sev_snp_supported ? "enabled" : "disabled",
+			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	sev_snp_enabled = sev_snp_supported;
+
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 535018f152a3..422b452fbc3b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2056,6 +2056,9 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
 		error_code &= ~PFERR_SYNTHETIC_MASK;
 
+	if (sev_snp_guest(vcpu->kvm) && (error_code & PFERR_GUEST_ENC_MASK))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
 	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
@@ -4899,8 +4902,11 @@ static int svm_vm_init(struct kvm *kvm)
 
 	if (type != KVM_X86_DEFAULT_VM &&
 	    type != KVM_X86_SW_PROTECTED_VM) {
-		kvm->arch.has_protected_state = (type == KVM_X86_SEV_ES_VM);
+		kvm->arch.has_protected_state =
+			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init = true;
+
+		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6fd0f5862681..7f2e9c7fc4ca 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -348,6 +348,18 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
+static __always_inline bool sev_snp_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
+	       !WARN_ON_ONCE(!sev_es_guest(kvm));
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


