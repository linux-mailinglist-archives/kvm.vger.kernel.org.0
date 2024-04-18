Return-Path: <kvm+bounces-15133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5868AA301
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 830AA1C21836
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD222180A83;
	Thu, 18 Apr 2024 19:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SSY5jCbx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2047.outbound.protection.outlook.com [40.107.95.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1528917AD73;
	Thu, 18 Apr 2024 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469322; cv=fail; b=FMY1mJyptExFLrKliFkw2GEr9Tt9FMJpMcDmDIvH1wtS4ZZXNBE4giqkkO4404om5Yydi0+kkIWeIgpzs2WtEhSx+B3iLsbwpB1aF0MQ0NUcTeg7Gsvd96ZT4fDqijA3/6ZuE3j5XnuxN1wcbco9fZzzlLl3AYsFmm6ZA94Pgdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469322; c=relaxed/simple;
	bh=IHoE5bFS1zgpjTQsF907XoZGW9kuF9IYuIbU++keYrQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sWCeQpMd+UMcShWiHomBF6/pg8qWBsp4Ux1JWdOWPfr/gIDKjUGtC3RBMgSfRFm5vp3tiCKP2mImeHhNJ8+Vj3pFk8DiH5cNpRlnv/wb6z4zPTHXs7S6LB53yiwCsVuZY70r6ORKtYCyd4qpbILFCJvtsR8/C4K2exP7eY8evR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SSY5jCbx; arc=fail smtp.client-ip=40.107.95.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGGXa34Vlm6qsFN29Ukrw6LqxxxVYKX0TSa4qBHde0mQGrVbSReZBMOxX+v04ktjt2e0vOE59sPRvM/PcESyXq+kSUwlrBfmHLDnOWIq28FCmmI0g3bHv8dhHlMB4NDLqoZRs3FLBURJordrdQDFhRCw+OGC8TtN+fXz5aWI+8vboHksJiERCMphppGXORAeoS7lhkQDaoSYQjhZ6GkPQu/gInc2JSFilZyiyfvH6JPgtEgewjbX70HiBIyfyA6DxBSd+cT6Xc3BCxJJz2BIFvKFYdDr3fZE6HmHLDlIT9RDOf1I6noA5spy9DhIlPtDRid6NLR9eoEya5+8gMa1CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwF9IK56mh1wJ554yRT71IaCpxzk5DIZCkdhWhMgydQ=;
 b=Veqijc+2iD13xwDbJof+PM+lPq6dhf2N52ZJbMEwJHOzgC6ggdPbNG1zNu6nvn36+1FnHJfZ+NBdyM72CU6kdiYx6ob5WQgp/OZnrHjRE/q3EG5cAw0F4rCxc9577GYYuOmcxZNuAEcX7t8zOroUCnuL0VNvdWFZxRGBTIacSTLcOJc6rbAfQxcmmOIX/n6HLwMF1boQWM542jbQFfk2W+NBZd/odFyw9xsDgbVsdhtXLUQUsXceSSxx/bErpwfMHO3HDAsaTKhWfw29/HocheVnDyyTr4WetijwiWF+OwcVch9/larRogntuba0rkhGjQmocoUkPnqmS7ES7c2oHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwF9IK56mh1wJ554yRT71IaCpxzk5DIZCkdhWhMgydQ=;
 b=SSY5jCbxkkmL9QO/8bg7XU8hQmbzESr0bvbgsw4ZYSI9j4Nep+v+UnYN2EA6s78A3VP+6HL5aHlLoJIRjoErmVL2YE0lIxM1cUuqDipXcAtp2rofgFVN5szthlElDrP38ZXAtHn+7LfXIQ/h/PS7veMP0mZpD20HYcHylIBW5wA=
Received: from SJ0PR03CA0350.namprd03.prod.outlook.com (2603:10b6:a03:39c::25)
 by DM4PR12MB6328.namprd12.prod.outlook.com (2603:10b6:8:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Thu, 18 Apr
 2024 19:41:58 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:a03:39c:cafe::f9) by SJ0PR03CA0350.outlook.office365.com
 (2603:10b6:a03:39c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.33 via Frontend
 Transport; Thu, 18 Apr 2024 19:41:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:41:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:41:56 -0500
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
Subject: [PATCH v13 09/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
Date: Thu, 18 Apr 2024 14:41:16 -0500
Message-ID: <20240418194133.1452059-10-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|DM4PR12MB6328:EE_
X-MS-Office365-Filtering-Correlation-Id: 1af3a718-dfa9-4ec8-2d4f-08dc5fdf9bf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0JO4F1D0R0BcCbj+5CsEIipaSB1FwCt2RzVX040K96zj3aQw6pjmQHW26f+gEtU8YcGiXHJuOymommwipsPHVLbwT/GVLaST7BzciLuc4QQV+RaeALW7ZQJKtzjjaLXmWx4+hGojwT9V8v2VNcLazDvrwdYdi2mSHg9qN2d9b74tgfLy0rhENY0ltA53HLgpoJKjbfJgKqOdaL1jyeI1tnQYsD4F4ocZ+J3tJJsty3AqcvLkBiko5auE+S3yXbmJrdiPx2cli3fU0DCcCOkG4TlUWKoV873gxNqjLL0U4o48l9bG6nTSJIA/rwpkUZNEjlot+TdVDuMdQNbrotGUlazxxOBVmhwiHJ23+VhVJII4bpg08FDt0zjlAlfFmjg5fUfyY84sXsZ7ZlymoZpB/ZtPFU8Nf+KfrZGei8eeln+Pu8aodT3KBkkBqIuCpIC+zrSddObr6CSEQFzSd69Nu5bu2LkIakS/LqbWFQ6jeyDjW6C2r6lZ04cMl/o5bWquRyKOD5rUFImx0Gh/4Mq2pw71dJFbdQcXeZKatbb0nlJvUrjBeaDmw6lBfvoEGvNXrultxG3/nGzc3BfmIvRc+QWD6R949BXG4vYK6qR62xkA5gu1e3BOexT+Hkiga2/vPa9sqoUrSWakgxLRQE16XxQjBdE/XL7+4aYn8bzBR3PLQlEHTNFvWLQDpNX2lBxYELN3jbsicboEqcJpANztJA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(1800799015)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:41:57.7203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af3a718-dfa9-4ec8-2d4f-08dc5fdf9bf2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6328

From: Brijesh Singh <brijesh.singh@amd.com>

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct
the measurement of the guest. Other commands can then at that point be
used to load/encrypt data into the guest's initial launch image.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  23 +-
 arch/x86/include/uapi/asm/kvm.h               |   8 +
 arch/x86/kvm/svm/sev.c                        | 208 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 4 files changed, 236 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 3381556d596d..1b042f827eab 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -459,6 +459,25 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+18. KVM_SEV_SNP_LAUNCH_START
+----------------------------
+
+The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
+context for the SEV-SNP guest.
+
+Parameters (in): struct  kvm_sev_snp_launch_start
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_start {
+                __u64 policy;           /* Guest policy to use. */
+                __u8 gosvw[16];         /* Guest OS visible workarounds. */
+        };
+
+See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
+
 Device attribute API
 ====================
 
@@ -490,9 +509,11 @@ References
 ==========
 
 
-See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
+See [white-paper]_, [api-spec]_, [amd-apm]_, [kvm-forum]_, and [snp-fw-abi]_
+for more info.
 
 .. [white-paper] https://developer.amd.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
 .. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
 .. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
 .. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
+.. [snp-fw-abi] https://www.amd.com/system/files/TechDocs/56860.pdf
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9a8b81d20314..bdf8c5461a36 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -697,6 +697,9 @@ enum sev_cmd_id {
 	/* Second time is the charm; improved versions of the above ioctls.  */
 	KVM_SEV_INIT2,
 
+	/* SNP-specific commands */
+	KVM_SEV_SNP_LAUNCH_START = 100,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -822,6 +825,11 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c41cc73a1efe..4c5abc0e7806 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include <asm/fpu/xcr.h>
 #include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
+#include <asm/sev.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -58,6 +59,25 @@ static u64 sev_supported_vmsa_features;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
+/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
+#define SNP_POLICY_MASK_SMT		BIT_ULL(16)
+#define SNP_POLICY_MASK_RSVD_MBO	BIT_ULL(17)
+#define SNP_POLICY_MASK_DEBUG		BIT_ULL(19)
+#define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
+#define SNP_POLICY_MASK_API_MAJOR	GENMASK_ULL(15, 8)
+#define SNP_POLICY_MASK_API_MINOR	GENMASK_ULL(7, 0)
+
+#define SNP_POLICY_MASK_VALID		(SNP_POLICY_MASK_SMT		| \
+					 SNP_POLICY_MASK_RSVD_MBO	| \
+					 SNP_POLICY_MASK_DEBUG		| \
+					 SNP_POLICY_MASK_SINGLE_SOCKET	| \
+					 SNP_POLICY_MASK_API_MAJOR	| \
+					 SNP_POLICY_MASK_API_MINOR)
+
+/* KVM's SNP support is compatible with 1.51 of the SEV-SNP Firmware ABI. */
+#define SNP_POLICY_API_MAJOR		1
+#define SNP_POLICY_API_MINOR		51
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -68,6 +88,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -94,12 +116,17 @@ static int sev_flush_asids(unsigned int min_asid, unsigned int max_asid)
 	down_write(&sev_deactivate_lock);
 
 	wbinvd_on_all_cpus();
-	ret = sev_guest_df_flush(&error);
+
+	if (sev_snp_enabled)
+		ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
+	else
+		ret = sev_guest_df_flush(&error);
 
 	up_write(&sev_deactivate_lock);
 
 	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
+		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
+		       sev_snp_enabled ? "-SNP" : "", ret, error);
 
 	return ret;
 }
@@ -1976,6 +2003,134 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 	}
 }
 
+/*
+ * The guest context contains all the information, keys and metadata
+ * associated with the guest that the firmware tracks to implement SEV
+ * and SNP features. The firmware stores the guest context in hypervisor
+ * provide page via the SNP_GCTX_CREATE command.
+ */
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_addr data = {};
+	void *context;
+	int rc;
+
+	/* Allocate memory for context page */
+	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return NULL;
+
+	data.address = __psp_pa(context);
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
+	if (rc) {
+		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
+			rc, argp->error);
+		snp_free_firmware_page(context);
+		return NULL;
+	}
+
+	return context;
+}
+
+static int snp_bind_asid(struct kvm *kvm, int *error)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate data = {0};
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.asid = sev_get_asid(kvm);
+	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+}
+
+static inline bool sev_version_greater_or_equal(u8 major, u8 minor)
+{
+	if (major < SNP_POLICY_API_MAJOR)
+		return true;
+
+	if (major == SNP_POLICY_API_MAJOR && minor <= SNP_POLICY_API_MINOR)
+		return true;
+
+	return false;
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start = {0};
+	struct kvm_sev_snp_launch_start params;
+	u8 major, minor;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Don't allow userspace to allocate memory for more than 1 SNP context. */
+	if (sev->snp_context) {
+		pr_debug("SEV-SNP context already exists. Refusing to allocate an additional one.\n");
+		return -EINVAL;
+	}
+
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	if (params.policy & ~SNP_POLICY_MASK_VALID) {
+		pr_debug("SEV-SNP hypervisor does not support requested policy %llx (supported %llx).\n",
+			 params.policy, SNP_POLICY_MASK_VALID);
+		return -EINVAL;
+	}
+
+	if (!(params.policy & SNP_POLICY_MASK_RSVD_MBO)) {
+		pr_debug("SEV-SNP hypervisor does not support requested policy %llx (must be set %llx).\n",
+			 params.policy, SNP_POLICY_MASK_RSVD_MBO);
+		return -EINVAL;
+	}
+
+	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET) {
+		pr_debug("SEV-SNP hypervisor does not support limiting guests to a single socket.\n");
+		return -EINVAL;
+	}
+
+	if (!(params.policy & SNP_POLICY_MASK_SMT)) {
+		pr_debug("SEV-SNP hypervisor does not support limiting guests to a single SMT thread.\n");
+		return -EINVAL;
+	}
+
+	major = (params.policy & SNP_POLICY_MASK_API_MAJOR);
+	minor = (params.policy & SNP_POLICY_MASK_API_MINOR);
+	if (!sev_version_greater_or_equal(major, minor)) {
+		pr_debug("SEV-SNP hypervisor does not support requested version %d.%d (have %d,%d).\n",
+			 major, minor, SNP_POLICY_API_MAJOR, SNP_POLICY_API_MINOR);
+		return -EINVAL;
+	}
+
+	start.gctx_paddr = __psp_pa(sev->snp_context);
+	start.policy = params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
+	if (rc) {
+		pr_debug("SEV_CMD_SNP_LAUNCH_START firmware command failed, rc %d\n", rc);
+		goto e_free_context;
+	}
+
+	sev->fd = argp->sev_fd;
+	rc = snp_bind_asid(kvm, &argp->error);
+	if (rc) {
+		pr_debug("Failed to bind ASID to SEV-SNP context, rc %d\n", rc);
+		goto e_free_context;
+	}
+
+	return 0;
+
+e_free_context:
+	snp_decommission_context(kvm);
+
+	return rc;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1999,6 +2154,15 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 		goto out;
 	}
 
+	/*
+	 * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, only
+	 * allow the use of SNP-specific commands.
+	 */
+	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START) {
+		r = -EPERM;
+		goto out;
+	}
+
 	switch (sev_cmd.id) {
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
@@ -2063,6 +2227,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2258,6 +2425,33 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_addr data = {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	data.address = __sme_pa(sev->snp_context);
+	down_write(&sev_deactivate_lock);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	if (WARN_ONCE(ret, "failed to release guest context")) {
+		up_write(&sev_deactivate_lock);
+		return ret;
+	}
+
+	up_write(&sev_deactivate_lock);
+
+	/* free the context page now */
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context = NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -2299,7 +2493,15 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		if (snp_decommission_context(kvm)) {
+			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
+			return;
+		}
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7f2e9c7fc4ca..0654fc91d4db 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -92,6 +92,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
-- 
2.25.1


