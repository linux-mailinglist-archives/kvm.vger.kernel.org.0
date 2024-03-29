Return-Path: <kvm+bounces-13116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0DC89275C
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18C8C1F25786
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E786B13EFFB;
	Fri, 29 Mar 2024 23:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xnn0YoyP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513D513E401;
	Fri, 29 Mar 2024 23:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753230; cv=fail; b=uZhgEsPvzM/O5hYoPvgVIjlWXaSncWu/gH+CMWkulPd23+p3QPC07Xcnvdc1pEegop+1fw5FWQt9xrKIhggwnnc/cJxhZmvY+efDK8zTDVGgPMZ1OBnPCJ1svuKjpe/xapUf2zfGgrB87DdADrHQzinKcE/FLI1mCdSAohMJ7OM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753230; c=relaxed/simple;
	bh=q4vzPdo0+oii9a1ZolELIlylzfsIrazGRpbjD/k5aUY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ko9KEZg3yLMXSxkN960Y/B2POJkn5tv0c1SE4wQqMBJNeTCF+VtC3I5Rs/cG3vbuvj3mVK5BMvEK9Yegm31H3BjyyNl7K1T0LCemXg4usQSAgVIu4IbicWvb3FBKu3DMFE8ZSoRJpC6bFHCBONslTx3MM6W14Bvvg8XrK8Um0Lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xnn0YoyP; arc=fail smtp.client-ip=40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koAhSHTroS7Six8Mk2ptjimEuKhzjh+UOZ0BKjgCc81mT+BeIOoN5WsMBdVaZUUy0R+PvNTm4fC8i+uwFGBJV8NQMJkhjHeFNHs9v7dqfn1NGIFcfGChcbS/FPOvmOVVYpB/pw5U7oG2gLnAwxc20CK7NLojtWh4NCJ6M9OY8OY2nW344YP5M7kPGqBhcAq4W9kwvwslxNGFFGDAer3lswUX447A9LE0/fnMv5jbJ83rm5ix4N0K58GDPEx9VUGhhOgggVbAfXgKVio1kRzvNH8kJtZzXieWO/wEifcUb+WRXxN3ZBE88A4zgVuKZm7/Oqe/HvOr/XrFZWS7gVA25Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrYjCWIu6wNf/NkduP5S/uOo7LBR9vnyryH5vZHAlfA=;
 b=LVmfJFAum0chfh8MZAu/WI+/8Q1sh2O9o7TULA0rPfys5d3XWI3rdAqs/rYpjoaI+XLbCnHEgvanj9y++g3Pa/6WeAuyuUZZP+r2ZuuqLZc6edOigte0P3F00JsEgpwhi4L//QOMpICtIepUxvGLpwvRyID4b85yTfLiPEsYzfzxDzMtwa6xyDWidl6wddXopfSMfQOn4cp+NLLaX0CGH64ADEMNjDgJRUx5k4b/vRjK7TOLrW1vnz5Ty62s6kgRDA13YMF0niFXxzCeK2SekIWp/623ludL5H2O+JvT+5Bk3UU6+HQWzVWe4SzWyVmdcw+PiS9jlTsjHpiAmnR1Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrYjCWIu6wNf/NkduP5S/uOo7LBR9vnyryH5vZHAlfA=;
 b=Xnn0YoyPydUttY9jZm4o1iMO+E8KBjfMOPusb4Vj5axJk8hQRG/osW1QECRxvBowisK2iaRPpIm14+OOzYXxmMPkAt9nxcFBlrEsW8iRuNHSFxG83FlEnCf0xJ4+jqhhyl6Gtqjia8oulEv9c2cH+koDudTK+LTVXbryYxTNGZM=
Received: from SJ0PR03CA0173.namprd03.prod.outlook.com (2603:10b6:a03:338::28)
 by DS0PR12MB8197.namprd12.prod.outlook.com (2603:10b6:8:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:00:26 +0000
Received: from SJ1PEPF00001CE2.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::51) by SJ0PR03CA0173.outlook.office365.com
 (2603:10b6:a03:338::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:00:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE2.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:00:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:00:24 -0500
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
	<brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
Subject: [PATCH v12 12/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Fri, 29 Mar 2024 17:58:18 -0500
Message-ID: <20240329225835.400662-13-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE2:EE_|DS0PR12MB8197:EE_
X-MS-Office365-Filtering-Correlation-Id: 640e01f2-0a92-4152-816e-08dc50440591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	maS+wkIOrEV5dsQi+1Ucl7Dek3wbv2EkPTvamXV0iSrN3blKHKdzKy2sIgDkiuuCucCw1OYKPEXgE5LMW8sdaz4286tIVkN+6PYuPsOVvp7iv1rneuIp9shRSXhmHDARnXxJmXnr0iJa+9y2ATf3fTJJo5La1aeAucorCGMUeZYKun+1WQUJA1HQ3EOcWxwO84rEOPNsqnSbmycdcDtS590W5Ec83CUA4agPDbAh4zj2CzuSejnH/9AfsThwsQHoNe6C0wP3YOSooNdigv7LS1g8Gv/K22w1hhc+2MjW7fKBuX9EGyBoPr2TiquiVGKTnfSA5CUdNUY8ebM82UWYw4VCzSjz8oNq06u7n8KmAJsEuQ+xDxDZ9+8UlUNuQmxbCqDLfOyyZTLQjuhoDsTsM7dZuGpqkAcvYHMMabFFq/mztOspe6IHwNWZuktMUfkhQT7jfXyNaEZMCch7qF1cFC/up6WcdI0HYTFJ1UW7LBjeIob+EJ9kPY8h7Mga93hhX3a55AynoannyjJkB/w916AFKVrRl53kdOW6ZUE+bCya4N3zsIQugolgebJDaVz3Zpt1Fdmee3h+45NUEoPhjIZIHrNfM8rK95aSy6fqixSHZ+oWPMkaTbYOYHhxpFXjMNlLe99ies3YgJ497umzrqGnQvGumS2jFNXz7xNkuKy2goBVtLNt3XHkMtD/fCYNc3oZE47i9tYjl+Soj5sN/JHUGL8jIuyLlq4kRQ30VQqSLpzThuTSB+XGQ31m+C8/
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:25.9312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 640e01f2-0a92-4152-816e-08dc50440591
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8197

Add a KVM_SEV_SNP_LAUNCH_FINISH command to finalize the cryptographic
launch digest and stores it as the measurement of the guest at launch
time. Also extend the existing SNP firmware data structures to support
enforcing the use of Version Loaded Endorsement Keys by guests as part
of this command.

While finalizing the launch flow, it also issues the LAUNCH_UPDATE SNP
firmware commands to encrypt/measure the initial VMSA pages for each
configured vCPU. This involves setting the RMP entries for those pages
to provide, so also add handling to clean up the RMP entries for these
pages whening free'ing vCPUs.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: always measure BSP first to get consistent launch measurements]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  26 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 137 ++++++++++++++++++
 include/linux/psp-sev.h                       |   4 +-
 4 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 4268aa5c380e..a49e8cff9133 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -517,6 +517,32 @@ where the allowed values for page_type are #define'd as::
 See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page type is
 used/measured.
 
+20. KVM_SEV_SNP_LAUNCH_FINISH
+-----------------------------
+
+After completion of the SNP guest launch flow, the KVM_SEV_SNP_LAUNCH_FINISH
+command can be issued to make the guest ready for execution.
+
+Parameters (in): struct kvm_sev_snp_launch_finish
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_finish {
+                __u64 id_block_uaddr;
+                __u64 id_auth_uaddr;
+                __u8 id_block_en;
+                __u8 auth_key_en;
+                __u8 vlek_required;
+                __u8 host_data[32];
+                __u8 pad[6];
+        };
+
+
+See SEV-SNP specification [snp-fw-abi]_ for SNP_LAUNCH_FINISH further details
+on launch finish input parameters.
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 956eb548c08e..2b08fcbe039a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -696,6 +696,7 @@ enum sev_cmd_id {
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -841,6 +842,20 @@ struct kvm_sev_snp_launch_update {
 	__u8 type;
 };
 
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 vlek_required;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad[6];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a8a8a285b4a4..3d6c030091c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -63,6 +63,8 @@ static u64 sev_supported_vmsa_features;
 #define SNP_POLICY_MASK_SMT		BIT_ULL(16)
 #define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
 
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2283,6 +2285,125 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {};
+	bool boot_vcpu_handled = false;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int ret;
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.page_type = SNP_PAGE_TYPE_VMSA;
+
+handle_remaining_vcpus:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm = to_svm(vcpu);
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		/* Handle boot vCPU first to ensure consistent measurement of initial state. */
+		if (!boot_vcpu_handled && vcpu->vcpu_id != 0)
+			continue;
+
+		if (boot_vcpu_handled && vcpu->vcpu_id == 0)
+			continue;
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret = sev_es_sync_vmsa(svm);
+		if (ret)
+			return ret;
+
+		/* Transition the VMSA page to a firmware state. */
+		ret = rmp_make_private(pfn, INITIAL_VMSA_GPA, PG_LEVEL_4K, sev->asid, true);
+		if (ret)
+			return ret;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data.address = __sme_pa(svm->sev_es.vmsa);
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(pfn);
+			return ret;
+		}
+
+		svm->vcpu.arch.guest_state_protected = true;
+
+		if (!boot_vcpu_handled) {
+			boot_vcpu_handled = true;
+			goto handle_remaining_vcpus;
+		}
+	}
+
+	return 0;
+}
+
+static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_snp_launch_finish params;
+	struct sev_data_snp_launch_finish *data;
+	void *id_block = NULL, *id_auth = NULL;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	/* Measure all vCPUs using LAUNCH_UPDATE before finalizing the launch flow. */
+	ret = snp_launch_update_vmsa(kvm, argp);
+	if (ret)
+		return ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	if (params.id_block_en) {
+		id_block = psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BLOCK_SIZE);
+		if (IS_ERR(id_block)) {
+			ret = PTR_ERR(id_block);
+			goto e_free;
+		}
+
+		data->id_block_en = 1;
+		data->id_block_paddr = __sme_pa(id_block);
+
+		id_auth = psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH_SIZE);
+		if (IS_ERR(id_auth)) {
+			ret = PTR_ERR(id_auth);
+			goto e_free_id_block;
+		}
+
+		data->id_auth_paddr = __sme_pa(id_auth);
+
+		if (params.auth_key_en)
+			data->auth_key_en = 1;
+	}
+
+	data->vcek_disabled = params.vlek_required;
+
+	memcpy(data->host_data, params.host_data, KVM_SEV_SNP_FINISH_DATA_SIZE);
+	data->gctx_paddr = __psp_pa(sev->snp_context);
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
+
+	kfree(id_auth);
+
+e_free_id_block:
+	kfree(id_block);
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2376,6 +2497,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2866,11 +2990,24 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
 	svm = to_svm(vcpu);
 
+	/*
+	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
+	 * a guest-owned page. Transition the page to hypervisor state before
+	 * releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		if (host_rmp_make_shared(pfn, PG_LEVEL_4K, true))
+			goto skip_vmsa_free;
+	}
+
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
 
 	__free_page(virt_to_page(svm->sev_es.vmsa));
 
+skip_vmsa_free:
 	if (svm->sev_es.ghcb_sa_free)
 		kvfree(svm->sev_es.ghcb_sa);
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 3705c2044fc0..903ddfea8585 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -658,6 +658,7 @@ struct sev_data_snp_launch_update {
  * @id_auth_paddr: system physical address of ID block authentication structure
  * @id_block_en: indicates whether ID block is present
  * @auth_key_en: indicates whether author key is present in authentication structure
+ * @vcek_disabled: indicates whether use of VCEK is allowed for attestation reports
  * @rsvd: reserved
  * @host_data: host-supplied data for guest, not interpreted by firmware
  */
@@ -667,7 +668,8 @@ struct sev_data_snp_launch_finish {
 	u64 id_auth_paddr;
 	u8 id_block_en:1;
 	u8 auth_key_en:1;
-	u64 rsvd:62;
+	u8 vcek_disabled:1;
+	u64 rsvd:61;
 	u8 host_data[32];
 } __packed;
 
-- 
2.25.1


