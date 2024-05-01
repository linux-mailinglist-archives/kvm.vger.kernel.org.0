Return-Path: <kvm+bounces-16325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC69D8B8752
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 980BE28124D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4313451C3B;
	Wed,  1 May 2024 09:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dtwkBlX+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAEF2C853;
	Wed,  1 May 2024 09:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554553; cv=fail; b=SXgM445q+Km7NTgUPx0IdTe2QMzWc+XFCKmIMiuAjgsfDvgflM/y7bD11TuxCJRRPMrN6UfwOUFXQyhFgYCtJZTbukYTMY2xfcCNmCQUeLDkqALd2WC5e8U6OFypyhZ5/sxPVyF1iaCig2Cwl5QBqvpbrPeMeFYaM2/mJuWoi9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554553; c=relaxed/simple;
	bh=5SXTk4ZwXeEZDw7TUL8qxCNH2s/qKRSP1Wben3jPzqo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TtkLTYSrJEEIcdtGVX8RLAKUcE2oBTQUTNA3Z2nTW4nyGbGPZ8ekH1Iy48JlJbS7cCXqFa2qxDrRQw9Q6pIQyxvdpnuOnqbOUNHPjRO29SsoU0YttC+dOQNhuPs72StLwLz0Gmr7FIYiczV/EoGktPrfSJDq45DdBRzi9zX4v3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dtwkBlX+; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAl0Q8JY0GCH40JK+81sA+6jxeK3gsIJoUi4qed+Ee0lz1c65tF+VbDNbUNHtHjL7ijD0SbH3w54opLxXF+pisYC7u2eSZpAdgRG20+mRmT58LztSfwMncLJSUdqWvuTV6pSa3M7cplbOIoBGhehEKOjneKMDjwBXHeteasSg1LsMUaJrOd9AM0esbe2FegUmbM+DyUbekjRuJkg/Cw8y2f9Q132kkgIEuTBtx8jkoDR+AuLDg5lyyU/yzCKmFqS083Ds/MQUF5gTWYmplII0EVSEjm0Hc4JnR+/balXzZfcmBtqCTPAqg8IT+rvkldgBFWLYzeVWe2/ebzcEYh7Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYQYofULTsvq+RGAK48Bsi2yQW2HzXb5HOdHe6aXetE=;
 b=J8L/pyVOK9vKZGde06f3kT1ftJhwPTyA2f27OhMxB1p5/pEgACbegtmDa9po8RrB4Cgf3taA6y58xQ5ar1ZIEroFuPCsEACAdHMmUd7A7YQCxYYFVJYrClTvZy2qMn4jhD81I400K11Xj60HoATOXZYsUFTBmZKQh4Hhys2Q5baAWxg0xBY8QOFk8V7GyvmT1KdETmGRTpdlPbNjZnWhppk3Ok8NMIeBD/Do/tFHLtU0RZSKZ6bkTV7QilMN4f+/TJLS+bwCcmhu3NpmSRwBaoRrdRwP+xBqO8j6aYk+Dhduf9yps2Tep5tXeoiXb5KK3Xbqc7EG6iwG0/ra5g8Gng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYQYofULTsvq+RGAK48Bsi2yQW2HzXb5HOdHe6aXetE=;
 b=dtwkBlX+5bkBElTr6Wj+jvmJyoNUiRLK89bfKXhM2BwnzaYpzjqSpuY0j4/znIPrakRd0AgkAdegUTNbi4AXzh2HG1eU8cPiWH+oNu3mvsefgHZtsbBTYxxTOP4CoX70RzokWWlEJRzlAityLiKrFADB7rmHFF2IPzA+focIMig=
Received: from BN9PR03CA0601.namprd03.prod.outlook.com (2603:10b6:408:106::6)
 by IA1PR12MB7733.namprd12.prod.outlook.com (2603:10b6:208:423::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 09:09:08 +0000
Received: from BN2PEPF0000449E.namprd02.prod.outlook.com
 (2603:10b6:408:106:cafe::8c) by BN9PR03CA0601.outlook.office365.com
 (2603:10b6:408:106::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.29 via Frontend
 Transport; Wed, 1 May 2024 09:09:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449E.mail.protection.outlook.com (10.167.243.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:09:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:09:07 -0500
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
Subject: [PATCH v15 07/20] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Wed, 1 May 2024 03:51:57 -0500
Message-ID: <20240501085210.2213060-8-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449E:EE_|IA1PR12MB7733:EE_
X-MS-Office365-Filtering-Correlation-Id: 794f380b-3a05-4235-0915-08dc69be5bc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|36860700004|82310400014|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sWCowbIWfbJmJGNSiizYeGpGUwCk0iftfK0FREu4oVMlqcd6nYhes/xdE4XF?=
 =?us-ascii?Q?+dduVXbj8oiLce1A83aG1MMufiQFoM3//CxkhkjrzbIcxPuze2qRgSGC2d5N?=
 =?us-ascii?Q?WbaPCnhOLtWetburlDY8OGuygESDcABKmu7nIGQvgI32b8vkIUyPXeBEUJWg?=
 =?us-ascii?Q?rfQpb3h1r8iH7WevHzM+YhWgriCei8ajLXFQo5q0R4ELG6Hd93Yhxkxo2Dwb?=
 =?us-ascii?Q?qzDNabPx6bYdEDSSrj7VpcQu7YwBCYvUSClNb60J1ae2hOowaW6kYmvK9UA+?=
 =?us-ascii?Q?F5a1YwVEWBofwStwtW7cCf1a/MqGDPTaNPoSlHnPQ6k6Vr5EtA6+gCoPDpDq?=
 =?us-ascii?Q?N5tdVs8YcnH3/N342bDJDhV81NvbaC5yWmJV0Cj1zmdmVY+RjGPbh7uLyjUD?=
 =?us-ascii?Q?v/WBtoI4e5tqq26XJgpP+su5kweo5LDEYZZJsIrZcNNTPjzuf8t6u4JQgkVy?=
 =?us-ascii?Q?n0rLUH4yVE3dF7hqMpf4tF+PfgppZuWlBV2D/afKvaDwKaMgbwCYPWUk/AF3?=
 =?us-ascii?Q?soyV395E11N8G5HQeylkKSqm6KLj9q/ZytSxCOBrVNxJIu6/HZF9RgX14Eua?=
 =?us-ascii?Q?RIir7r4vVrBNQySJbMWjIUsMMHzZxPr78w08y5FeAgGt4hPvPfLk/7RovsKL?=
 =?us-ascii?Q?gGpxPcGKcCjgV1lcVfkpyez7jyS1s0bM0ul9NwzCsSFQ0abW/iqh4zMelS3F?=
 =?us-ascii?Q?pwgGx9B705zmuTCRsr5sW+RlHPIFLfD1fe4ZptzqTA1SGSPw1nJURL7+GK9l?=
 =?us-ascii?Q?1Li9B1oVQTMteHW2ufTjaPTySduepKIZS9v91ZPPAQKHCi96iWo0iLWv5b6U?=
 =?us-ascii?Q?SgzgZpVeJbYflBY5MtaxZ2wdxmIrigyX4+kpiagt8NvnJ288biRONW2SUtk8?=
 =?us-ascii?Q?0CxjXJUaexPzMP55pCs0y08XstQ6WJmLPCZw6GCr2uYHADdXOj26SkLQeWEh?=
 =?us-ascii?Q?bS2oIG5BC5/udDmDgpz+PRdIrYRdM9+X9zy4JtT6jHubaWTS0DhrYYQXbnmj?=
 =?us-ascii?Q?HWVmYKKphRKoj2+bL4/MVmmPnHuz3ujgG4PEK3td33d44JrAQYP0WVJdXozF?=
 =?us-ascii?Q?wY9RXdTQNxw5uj72lxP+b6cQX5R1kKwoNPISn0NyUNKliUMZAZNjE0n0cpcE?=
 =?us-ascii?Q?30+uAOT80Ioeo6jwBNS0n+B9Ph0ZcKxn56nKfHRlfF2OAwdeuPZTPrh6y2+z?=
 =?us-ascii?Q?VM0D+pmJOoImO9y4SFE9Gmay6GrnH6JOZrc3hqoULPNTH0ehVPC26RLguKkn?=
 =?us-ascii?Q?npmBG4hF2zeaWQsdfbvMXRrLw5T9ofh9SDFiCtiMlQQebufowdzfw8iPcYrL?=
 =?us-ascii?Q?uI7wrLj85GUJ2/6eei1VxDv1zR0QJX8n4IKtJypK2houSs8QbDcGxoL963Lc?=
 =?us-ascii?Q?QK6CIBWgCA28s4cXHevzu9Oib/WG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(82310400014)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:09:08.3066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 794f380b-3a05-4235-0915-08dc69be5bc1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7733

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
 .../virt/kvm/x86/amd-memory-encryption.rst    |  28 ++++
 arch/x86/include/uapi/asm/kvm.h               |  17 +++
 arch/x86/kvm/svm/sev.c                        | 127 ++++++++++++++++++
 include/linux/psp-sev.h                       |   4 +-
 4 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index cc16a7426d18..1ddb6a86ce7f 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -544,6 +544,34 @@ where the allowed values for page_type are #define'd as::
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
+                __u8 pad0[3];
+                __u16 flags;                    /* Must be zero */
+                __u64 pad1[4];
+        };
+
+
+See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
+details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5935dc8a7e02..988b5204d636 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -700,6 +700,7 @@ enum sev_cmd_id {
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -854,6 +855,22 @@ struct kvm_sev_snp_launch_update {
 	__u64 pad2[4];
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
+	__u8 pad0[3];
+	__u16 flags;
+	__u64 pad1[4];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f31f87655a67..797230f810f8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -75,6 +75,8 @@ static u64 sev_supported_vmsa_features;
 					 SNP_POLICY_MASK_DEBUG		| \
 					 SNP_POLICY_MASK_SINGLE_SOCKET)
 
+#define INITIAL_VMSA_GPA 0xFFFFFFFFF000
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -2348,6 +2350,115 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+			if (!snp_page_reclaim(pfn))
+				host_rmp_make_shared(pfn, PG_LEVEL_4K);
+
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
+	if (params.flags)
+		return -EINVAL;
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
@@ -2450,6 +2561,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2940,11 +3054,24 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
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


