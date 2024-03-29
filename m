Return-Path: <kvm+bounces-13115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AEF5892759
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 411EA282D59
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E5313E6B8;
	Fri, 29 Mar 2024 23:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nc26yfw6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03713CF91;
	Fri, 29 Mar 2024 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753215; cv=fail; b=fjdA/KPuC/sIeqaVY0oi6TFRyIES80fOAdBPMtaMQ9A82xaK722jPMpDP5uRpw1TDRnbpyFznjP9/Wx21YefB827hdm3kEvIx74zjcXiunSTLqHcgzJwIztYjf1ofsZc2kKi6AWLKfuspBDhUx8scQLyGT8+MjjyUfS7WXaUfwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753215; c=relaxed/simple;
	bh=GxarBB3QQXDtAmxKX8+rgDQfQVE3hghOjKcRWraa+k4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsE8q9F6LYfYnMlfLKuLnv9O+oEuUbw9RNotxN5x8lROSKV36F8erowkx3T8A7TuDXzr6O+kU4CrCEBqJ710cdP0htYrMyVI1mRWa6lOwWkBhSGSmyBwm2ctHe9IpUAvbJoSHIn4mjehfry30ZOKzrAsZESfAH+1dlC89lUeS94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nc26yfw6; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BElzFv0DBW0MUfZQD8UJs5q9+EA6fwy/roXbmEq+TK27HwkmLuLGaSnZEaC4z7LizwxFP+9CcgtZSYe3Ii/x3Qmyx2+qpZC8UzOKYuThs/JgABKZIcsDlHgXuf91vyYHD+eNeDFavLFzfMdZo2aHfXt6nbKGXqbANG1fHpmqqa/XuV/gj8KYH5rwG+G2KsejSM58/o+SoRJo4tf0r7lMElBZNkVB7ERvDWxQuuE+2+oUQLMCIXrnckx38ToRkbf0LSv3pwmBSoITpf9FxRved2imYa055K8dViM8qFqfybVrwd9UIQYfHaZdKZ1RO+Q8fGV/oNpLYiqpqYBgwaOOtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRM0X1XPmrPHJ/xejsVZHGx/fhXzSZlUOWEIzd5vxwg=;
 b=napnASBwyJG2prTZxam5z33xxl91ON59wzWY5AlObaNMOHV0cnd5AXmXzslMwl1QfB6IKjCNbGRvKeaSztlCXq1EJmJRKNxP/QGz33VOQxT6Ba77MSmZ9Gvharo7064GKpA8UYIMK8cOKZHtCpeZ7KJoUep/ZNRgl6SMVToBBAzcZaOe+6QjxVtGP0/o8HuSAW/+wy96FFUxfFexc0D6205fpRzXzn5uVuIzoZMwGPSHuh88nLjcONk5HXY29Ev4ytXUbmwKtvwDnx/Q0QAqKpocUh5NtX8894m8J5EScyJE5OVIw+bypKeljQQaBmiv3JPmTl+HzucpKl9Fw5SmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRM0X1XPmrPHJ/xejsVZHGx/fhXzSZlUOWEIzd5vxwg=;
 b=nc26yfw6BEddsMoLxmBknQWv7NoJVdW5TsUPbDB5WD56lIuKOC7ktJ7shNNMaS3nlkqYjDppMlO0nis5MV9UNDgd2MVhA+tVr1V4K8Zjyb8ngbfZX76ombAOPObrwYT1QJa3l86MicBWrhhigVCjwXVrKkwqgm6WOguSMG1TIU0=
Received: from BYAPR02CA0060.namprd02.prod.outlook.com (2603:10b6:a03:54::37)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 Mar
 2024 23:00:10 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:54:cafe::66) by BYAPR02CA0060.outlook.office365.com
 (2603:10b6:a03:54::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 23:00:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:00:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:00:03 -0500
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
Subject: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date: Fri, 29 Mar 2024 17:58:17 -0500
Message-ID: <20240329225835.400662-12-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DM6PR12MB4106:EE_
X-MS-Office365-Filtering-Correlation-Id: c27c7199-0608-4e58-824a-08dc5043fc68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3CPhwmHFRTbcoEsG1eJurOstXAgzf72Ze7qRd5sd1y6H95KtLVWAy00ly7s0y7UOv9/Fa0d8LCHeobZEAV2wMHMBwvDPt5XAgtaP9QWZ+6Pr3bZziTFcZgcMbr04m8pJ+cA9GwKvf6S/OMzrLt1uriEl9sVG2Bf4VpxzIMljD40wtDfDmpx31u8s23d/bIMGv6jQFVj3JsuuUr7+HOjkJs/H2mEbB7cC3VTL0Er3ZMCNT6/L4bqA37k9zeBppe0b5nePPH2UflxHzfh4xMNZ6ttcvsy6mHWLMBExEFEIQhgQ1TOSYMs8niYK+J7Io8C7NWgJtTPqSs9KwMJTb6+9bCVfzJj/ZLfHIJofmlifP5hfGvMx93ymUl3BiC9gNvHQiHNEoEJzJao3IpwR3tvvhnaU3WR7e+uryr7q7iOu9+JcYiXmTkCvbv2nJKeo8lbfwacgdTl6AOMDpdHAitMLR2yKnrPiwH9iJqUttjiJRr0tl6Nw0MUpWYJdQmvO2WKorsDgqWLh1Kh7yCTmsLHo3/F5EQ95LrJUpo/oDYlT4Y8rCFA8M/0cQ/BoREHUAEIJf31yyt0jDtOkCL3L4IuUvAGqIRGTU2nEaPf0gSnJ2SZa7+lm1s/2tb6l75eI+PLBLm7LdN75fg4zFqX9400AtenkM7z03+WcUgV0uQT6QARZn2e8eElJMYIpPr3dLb7aqYFKckjQdmJgdLdQvqbbyTfg7fdW4eBNPlSyVZ81qEcbrDLftDw463QUQ57VRGBO
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:10.6256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c27c7199-0608-4e58-824a-08dc5043fc68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106

From: Brijesh Singh <brijesh.singh@amd.com>

A key aspect of a launching an SNP guest is initializing it with a
known/measured payload which is then encrypted into guest memory as
pre-validated private pages and then measured into the cryptographic
launch context created with KVM_SEV_SNP_LAUNCH_START so that the guest
can attest itself after booting.

Since all private pages are provided by guest_memfd, make use of the
kvm_gmem_populate() interface to handle this. The general flow is that
guest_memfd will handle allocating the pages associated with the GPA
ranges being initialized by each particular call of
KVM_SEV_SNP_LAUNCH_UPDATE, copying data from userspace into those pages,
and then the post_populate callback will do the work of setting the
RMP entries for these pages to private and issuing the SNP firmware
calls to encrypt/measure them.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  39 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 211 ++++++++++++++++++
 3 files changed, 265 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index a10b817c162d..4268aa5c380e 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -478,6 +478,45 @@ Returns: 0 on success, -negative on error
 
 See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
 
+19. KVM_SEV_SNP_LAUNCH_UPDATE
+-----------------------------
+
+The KVM_SEV_SNP_LAUNCH_UPDATE command is used for loading userspace-provided
+data into a guest GPA range, measuring the contents into the SNP guest context
+created by KVM_SEV_SNP_LAUNCH_START, and then encrypting/validating that GPA
+range so that it will be immediately readable using the encryption key
+associated with the guest context once it is booted, after which point it can
+attest the measurement associated with its context before unlocking any
+secrets.
+
+It is required that the GPA ranges initialized by this command have had the
+KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
+for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+
+Parameters (in): struct  kvm_sev_snp_launch_update
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 gfn_start;        /* Guest page number to load/encrypt data into. */
+                __u64 uaddr;            /* Userspace address of data to be loaded/encrypted. */
+                __u32 len;              /* 4k-aligned length in bytes to copy into guest memory.*/
+                __u8 type;              /* The type of the guest pages being initialized. */
+        };
+
+where the allowed values for page_type are #define'd as::
+
+	KVM_SEV_SNP_PAGE_TYPE_NORMAL
+	KVM_SEV_SNP_PAGE_TYPE_ZERO
+	KVM_SEV_SNP_PAGE_TYPE_UNMEASURED
+	KVM_SEV_SNP_PAGE_TYPE_SECRETS
+	KVM_SEV_SNP_PAGE_TYPE_CPUID
+
+See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page type is
+used/measured.
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 350ddd5264ea..956eb548c08e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -695,6 +695,7 @@ enum sev_cmd_id {
 
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -826,6 +827,20 @@ struct kvm_sev_snp_launch_start {
 	__u8 gosvw[16];
 };
 
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u32 len;
+	__u8 type;
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6c7c77e33e62..a8a8a285b4a4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -247,6 +247,35 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
 
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data = {0};
+	int err, rc;
+
+	data.paddr = __sme_set(pfn << PAGE_SHIFT);
+	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+	if (WARN_ON_ONCE(rc)) {
+		/*
+		 * This shouldn't happen under normal circumstances, but if the
+		 * reclaim failed, then the page is no longer safe to use.
+		 */
+		snp_leak_pages(pfn, 1);
+	}
+
+	return rc;
+}
+
+static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
+{
+	int rc;
+
+	rc = rmp_make_shared(pfn, level);
+	if (rc && leak)
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -2075,6 +2104,185 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+struct sev_gmem_populate_args {
+	__u8 type;
+	int sev_fd;
+	int fw_error;
+};
+
+static int sev_gmem_post_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
+				  gfn_t gfn_start, kvm_pfn_t pfn, void __user *src,
+				  int order, void *opaque)
+{
+	struct sev_gmem_populate_args *sev_populate_args = opaque;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	int npages = (1 << order);
+	int n_private = 0;
+	int ret, i;
+	gfn_t gfn;
+
+	pr_debug("%s: gfn_start %llx pfn_start %llx npages %d\n",
+		 __func__, gfn_start, pfn, npages);
+
+	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
+		struct sev_data_snp_launch_update fw_args = {0};
+		bool assigned;
+		int level;
+
+		if (!kvm_mem_is_private(kvm, gfn)) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx has private memory attribute set\n",
+				 __func__, gfn);
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
+		if (ret || assigned) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
+				 __func__, gfn, ret, assigned);
+			break;
+		}
+
+		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+				       sev_get_asid(kvm), true);
+		if (ret) {
+			pr_debug("%s: Failed to convert GFN 0x%llx to private, ret: %d\n",
+				 __func__, gfn, ret);
+			break;
+		}
+
+		n_private++;
+
+		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
+		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
+		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+		fw_args.page_type = sev_populate_args->type;
+		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &fw_args, &sev_populate_args->fw_error);
+		if (ret) {
+			pr_debug("%s: SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
+				 __func__, ret, sev_populate_args->fw_error);
+
+			if (snp_page_reclaim(pfn + i))
+				break;
+
+			/*
+			 * When invalid CPUID function entries are detected,
+			 * firmware writes the expected values into the page and
+			 * leaves it unencrypted so it can be used for debugging
+			 * and error-reporting.
+			 *
+			 * Copy this page back into the source buffer so
+			 * userspace can use this information to provide
+			 * information on which CPUID leaves/fields failed CPUID
+			 * validation.
+			 */
+			if (sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
+			    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
+				void *vaddr;
+
+				host_rmp_make_shared(pfn + i, PG_LEVEL_4K, true);
+				vaddr = kmap_local_pfn(pfn + i);
+
+				if (copy_to_user(src + i * PAGE_SIZE,
+						 vaddr, PAGE_SIZE))
+					pr_debug("Failed to write CPUID page back to userspace\n");
+
+				kunmap_local(vaddr);
+			}
+
+			break;
+		}
+	}
+
+	if (ret) {
+		pr_debug("%s: exiting with error ret %d, undoing %d populated gmem pages.\n",
+			 __func__, ret, n_private);
+		for (i = 0; i < n_private; i++)
+			host_rmp_make_shared(pfn + i, PG_LEVEL_4K, true);
+	}
+
+	return ret;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_gmem_populate_args sev_populate_args = {0};
+	struct kvm_gmem_populate_args populate_args = {0};
+	struct kvm_sev_snp_launch_update params;
+	struct kvm_memory_slot *memslot;
+	unsigned int npages;
+	int ret = 0;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	if (!IS_ALIGNED(params.len, PAGE_SIZE) ||
+	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
+		return -EINVAL;
+
+	npages = params.len / PAGE_SIZE;
+
+	pr_debug("%s: GFN range 0x%llx-0x%llx type %d\n", __func__,
+		 params.gfn_start, params.gfn_start + npages, params.type);
+
+	/*
+	 * For each GFN that's being prepared as part of the initial guest
+	 * state, the following pre-conditions are verified:
+	 *
+	 *   1) The backing memslot is a valid private memslot.
+	 *   2) The GFN has been set to private via KVM_SET_MEMORY_ATTRIBUTES
+	 *      beforehand.
+	 *   3) The PFN of the guest_memfd has not already been set to private
+	 *      in the RMP table.
+	 *
+	 * The KVM MMU relies on kvm->mmu_invalidate_seq to retry nested page
+	 * faults if there's a race between a fault and an attribute update via
+	 * KVM_SET_MEMORY_ATTRIBUTES, and a similar approach could be utilized
+	 * here. However, kvm->slots_lock guards against both this as well as
+	 * concurrent memslot updates occurring while these checks are being
+	 * performed, so use that here to make it easier to reason about the
+	 * initial expected state and better guard against unexpected
+	 * situations.
+	 */
+	mutex_lock(&kvm->slots_lock);
+
+	memslot = gfn_to_memslot(kvm, params.gfn_start);
+	if (!kvm_slot_can_be_private(memslot)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	sev_populate_args.sev_fd = argp->sev_fd;
+	sev_populate_args.type = params.type;
+
+	populate_args.opaque = &sev_populate_args;
+	populate_args.gfn = params.gfn_start;
+	populate_args.src = u64_to_user_ptr(params.uaddr);
+	populate_args.npages = npages;
+	populate_args.do_memcpy = params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO;
+	populate_args.post_populate = sev_gmem_post_populate;
+
+	ret = kvm_gmem_populate(kvm, memslot, &populate_args);
+	if (ret) {
+		argp->error = sev_populate_args.fw_error;
+		pr_debug("%s: kvm_gmem_populate failed, ret %d\n", __func__, ret);
+	}
+
+out:
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2165,6 +2373,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r = snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r = snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.25.1


