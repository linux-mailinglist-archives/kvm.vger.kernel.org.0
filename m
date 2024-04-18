Return-Path: <kvm+bounces-15138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 685808AA315
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F72A2878B4
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD23190661;
	Thu, 18 Apr 2024 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gRz+w7pD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED541802A1;
	Thu, 18 Apr 2024 19:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469388; cv=fail; b=Fj1JqBN4ku2Rl2W+1vSXKr+KwWpT2eAMrGLrDf5FTnRO01RuNrkQT5Yykq03FURe+0bSFfWR/+RgnjbtwKtPKzfqceZSHLgB3YSSq/qfiMW04xFPFU4YLEIqqUXjj0n2hnprdnqbmsgpjfBLQV8ZzP5utCpxKk+oOtL1/10e42Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469388; c=relaxed/simple;
	bh=Q6cWs2VsGOQGBmLHmT7yPdiwV7ZlVSgYt+ytJL60XN8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkHUBxkTtGBhcPoOE0ySLyRrZgjSXVsXLqehw5dnIAezc6ziIWKhLGs8tAq0Q64R9IJFDatiL+sVv/9rPWoA+Kv+Hs0+/eq/D1Fn78RdizqR6eJFm8XSjfFHp61SfUvdV24H2ZhWZFMLgeM5XGvuFen0TZvQQH8x5kGimlyIrxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gRz+w7pD; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMEo8ffD/RcexWMrfcLCnbiqRqKOzj1M+7z5N9mepEzeEidCocoJtlAeNZXdbTbLS6ZlizEb8ph2/CS5W/IAINH3gsWgvy1BFDDfyPRnDC7I8KWfyNz+k1IqL9+Mu61kHq74llWKm2VLeBmtLJPgNiFlYjE647bHmBtfrbD1ZnUBxGu31FLvDU5ScJgHil/GKGfbyBMgpD+gbZJvAm641WrcizEDY1UbV1MFScebBE+V0EZGDEg/Aa1dVURsuYwutV1BTDuE8LaEli+b2jTBbeB7W1TwnOh8lG4JrEH4F+S9Ha6/3S7Te3n1Nf/Z99AXkkKX04o/kjAQmjTsj0lH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kuj1lGUvBaBYHpJdgusufrHcacwMwYIxdcX39fXMHgc=;
 b=CzqYCB7BGjIt/HS2stQhHwWupnWvjSSjaGJLuSvbhOiba8og0Qwuvj9gghxSFbJzEMoDlf5XmBdv997EgJUjZ5OwEMJLfvBrUzLp9FJFS+yCPA8ltbaq1PJESSsOkyihTOFamL+1q2YY32hzpaBIhP1wvtWZXIEhriRj8ZkgBp4RKWXIYR8J2RpRRI6gUFWvmCSkQhpBlrNom+LwGHPaJffM1TU34KS8t37du8VVfSKaF/1xXP1knzB7Ci2YXiR3af5LqYrvEL7eYNYsDa+Rbg6RZDIwUSlsf62OYpQPG0Y+S/fQN9LpURblZzHA/Jv0QE2mp3CymwHKB9sZWSlENg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kuj1lGUvBaBYHpJdgusufrHcacwMwYIxdcX39fXMHgc=;
 b=gRz+w7pD5X9+pn3wqUqxZ80fFE0JsWOfSqFwa+dLj94FFBgdYoX2xFDCErcTMpvSFzwjb7OhxpGYOMK+NUuN07GxNKGBm43zQ+OmKqcjFI/G3VUDomTfdU7pQcewQPTnZct/yx3T8P6bQptu3SiP8czHXtja58T/fzJZhWD+wLI=
Received: from SJ0PR05CA0171.namprd05.prod.outlook.com (2603:10b6:a03:339::26)
 by DM4PR12MB5867.namprd12.prod.outlook.com (2603:10b6:8:66::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.40; Thu, 18 Apr
 2024 19:43:04 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::a) by SJ0PR05CA0171.outlook.office365.com
 (2603:10b6:a03:339::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.23 via Frontend
 Transport; Thu, 18 Apr 2024 19:43:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:43:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:43:02 -0500
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
Subject: [PATCH v13 11/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Thu, 18 Apr 2024 14:41:18 -0500
Message-ID: <20240418194133.1452059-12-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|DM4PR12MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f8a2e6a-6785-4e39-a625-08dc5fdfc37e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UpjE8AjM/uSDpgbTAKgAA+d0HMX6rJfGrvmllu4aNYSJ8RyLSw2tgtYw0SOHRsb9S5iZajYvmGWjfHHNJQnHAgGZORRZqqYQFqubyA0x20wJdaaezvb9NGrcyUFPjFwecjktkrpzOJBGxh1s2P/pWtvDmouw9q0CL48IXvoDfm4UlrLcyEs05aBA2Zn9+CDDOsuM/WMB057cFWKsRBJqWgI+WuLWXkwb0I8IbM7xbVLzf7d1OsTx9p9Txd0Go972GE0+F9j2WCjD6VVnFnpXKauHqycFMbxNSvjJp2O741+ZzmkLg6JVYT9/SqFu7bXTxSMMgWaMzhDY0/PnzCm+vCO3hEujE6NiRFiLxLm9zoT141AvyD3LZZgyVlMEnQ2rxoW5yvrcfhv6b12K/y33blkcEaDhdFbd9fFfsLgJe09Y7z0CJIv9cOmdqsMA5efy3tVWh+aouJL9dvlRAreZbHh6GHrtG6Sh8g0IRR1gjyi3Fei67UFPE84dvNowvGmRQwI+w2JWlQB5QExmBLmzMCwGN2Fy4vcE638G2y+wbEVG18jY8WWWKQu3aQLJJmqGviH8OAdrqLGrGiIMEl3ok7qPSY9ls5e56M4HCjx5bHPat+3057LX1GZFYfTeaSFunfqc0M/hdKOvPuVcfzb9jKE6MW25zyRlBKp1oXswQG9F6qkn9XgJBMmr0Kar96/L70ODA+uAHuK7dcicRiC6anyBP7urwRInylUb83kvZkhfYH16o1+zBDTE68+Xf4Mn
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:43:04.0564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8a2e6a-6785-4e39-a625-08dc5fdfc37e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5867

From: Brijesh Singh <brijesh.singh@amd.com>

Add a KVM_SEV_SNP_LAUNCH_FINISH command to finalize the cryptographic
launch digest which stores the measurement of the guest at launch time.
Also extend the existing SNP firmware data structures to support
disabling the use of Versioned Chip Endorsement Keys (VCEK) by guests as
part of this command.

While finalizing the launch flow, the code also issues the LAUNCH_UPDATE
SNP firmware commands to encrypt/measure the initial VMSA pages for each
configured vCPU, which requires setting the RMP entries for those pages
to private, so also add handling to clean up the RMP entries for these
pages whening freeing vCPUs during shutdown.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Harald Hoyer <harald@profian.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  26 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 +++
 arch/x86/kvm/svm/sev.c                        | 123 ++++++++++++++++++
 include/linux/psp-sev.h                       |   4 +-
 4 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ee8401de72d..d2fea9874f68 100644
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
+                __u8 vcek_disabled;
+                __u8 host_data[32];
+                __u8 pad0[5];
+        };
+
+
+See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
+details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 8612aec97f55..1d1f149d035e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -700,6 +700,7 @@ enum sev_cmd_id {
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -845,6 +846,20 @@ struct kvm_sev_snp_launch_update {
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
+	__u8 vcek_disabled;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad0[5];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e721152bae00..78412c7c6708 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -78,6 +78,8 @@ static u64 sev_supported_vmsa_features;
 #define SNP_POLICY_API_MAJOR		1
 #define SNP_POLICY_API_MINOR		51
 
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2346,6 +2348,111 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {};
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int ret;
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.page_type = SNP_PAGE_TYPE_VMSA;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm = to_svm(vcpu);
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
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
+	data->vcek_disabled = params.vcek_disabled;
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
@@ -2448,6 +2555,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2938,11 +3048,24 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
 	svm = to_svm(vcpu);
 
+	/*
+	 * If it's an SNP guest, then the VMSA was marked in the RMP table as
+	 * a guest-owned page. Transition the page to hypervisor state before
+	 * releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+
+		if (host_rmp_make_shared(pfn, PG_LEVEL_4K))
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


