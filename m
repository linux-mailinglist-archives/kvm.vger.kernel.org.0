Return-Path: <kvm+bounces-17229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A138C2BCA
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BEB5B25AF2
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF2513C3D0;
	Fri, 10 May 2024 21:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nNMKU5xG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEFA101E3;
	Fri, 10 May 2024 21:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376174; cv=fail; b=pyyvEXLCaBJvFx2zMPlKfckR7fmrQZ2V+/D2/QF/OWIOVnFY6aLu3vQNQDZFPoTKea+aQ1az3xyR3hsqG9kQit5fr4j2VdSay4P7irk9+hhBm6rICNq29g12dIM77wLPy2Srrh5t7m37h6twErrZaHbRHe+kH9OdFdTYOX0eMk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376174; c=relaxed/simple;
	bh=kXuO2PguL+6y37tazI+DhqEvcLxVKuhQx+Bt4z7DLXE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iWf7dgj7crz+0hlYJXevsdL3ZQVIZXo+DW4xN8ifsrnZOgDRihH6jfIUecc3dr4BOIw+65WPZ0DIQtnJiSa65qflhSR17cgl1kUPsZirYauY2mrMfmZ9t4SbHbSBYgnY8rL2Odt48WP8w6m7qpQ3qwjrkWy9sXyKgak9QJDRx/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nNMKU5xG; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ko2a3UtbNhBPdaxaamhrCbwWGm3OoUihYSc8FZAItFvfCqV9JK1R1Rs+Kq9Q6e66MiZ0zRbzUZOF1AJG+fcHl0sQSCMvR/tnJrax74szTUGqx1WEvArqEtiEJlF2Psi4318sqBVyt+B856EPwShv2NuYXKxhF8wiZJAVRCVK1mi9Ln9Rrn41VZxsnVxglN/1MNdLNaeUB6vA6mb/In82yJ0QjUBLpJkwVBa3QepKlD5j+GfsjVfk9SF8eztElfm6PEPAIR8LFAyZY47GtJoWDnR9FzS0C3LdChsvZFq2UkJfVap0qW+Ie2HptRKuC6SwEcrtEHeCd6UjTUrqUoSeag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BalY2yO3hco544+u2I2ziT93lRp0HqnIZddf65pI6Q=;
 b=E4kW48e6eo6juTUfIQOKXmHNR8vlFQ4FUNkKFeZRQPFoW/Hobjnf3rnGeOFYKW2f5lJJy36KRGi809D9wMYLTczPOdcrKnH6vU3GDkPjLUd0jbhrOLVjN5AfzgPYuNYFSQmk0VSu2BN+I2Hh0+nCWO7VaVswrdpyxosKSqb4CEVA1i+pDVHIaYZwEQpRj0eDOeYsyfeGjf1ZeiIX0LqyhiOFZupZ71sd61tIKodQrCMAX2s9sumAUxlCZA7TEqDDm8GC2oFFPw5sDrYmqNpxbtlRbGJcmkjdOEWeP2QBIqyaejPl78MxY0psTevUu8BdNwB1GA/uG/i+wMmmq7Vkig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BalY2yO3hco544+u2I2ziT93lRp0HqnIZddf65pI6Q=;
 b=nNMKU5xGC6KNR9EGXJLut08XcKvsjP3db1+Dmk2zzemzgJaqlxQriem3Sg4QHH7tsmlVfVMNdVFQCHdJEMXXDslCXjS/xo6m2xHY8/IUt8PjEvbIKJi0UGLMvs01RAnMFXfbXQjc0rkCZUh4yDFOLlxSIU4QeOz51dxOEQGZWLU=
Received: from BN1PR12CA0022.namprd12.prod.outlook.com (2603:10b6:408:e1::27)
 by CH2PR12MB4167.namprd12.prod.outlook.com (2603:10b6:610:7a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 21:22:50 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:e1:cafe::ca) by BN1PR12CA0022.outlook.office365.com
 (2603:10b6:408:e1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45 via Frontend
 Transport; Fri, 10 May 2024 21:22:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:22:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:22:50 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Harald Hoyer
	<harald@profian.com>, Ashish Kalra <ashish.kalra@amd.com>
Subject: [PULL 06/19] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date: Fri, 10 May 2024 16:10:11 -0500
Message-ID: <20240510211024.556136-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|CH2PR12MB4167:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ada507-8570-4c84-2fa6-08dc713758b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T43wZQ7VnwORwcMc+zd28TG+Q5n7J8yxAU1u4I+ceeMLWkk+nyIZwg88GEC4?=
 =?us-ascii?Q?iAAHCPFuR56zOJTdIxWbUFs1VtKK3mE42P7iYUmql7XO5t9hwxrXfF4qgLDx?=
 =?us-ascii?Q?JcaeMUOk5Rf1yUiueKe4YaxVib2UUrk3/Fs+kwGQxwA4HuF7Ms+30TE9sfds?=
 =?us-ascii?Q?eeNmEDKLLFSaGWn2+zofA97I+4Au2iATV/TiMhbVPgENoqSydRpSXx83hrgG?=
 =?us-ascii?Q?8CuALlvNmXuaL0SYjnsXdf7rq2lBvLtRVlw1ng0dy8OBu3+k/BR4hdyMe3lQ?=
 =?us-ascii?Q?C2gOtCtQo2lMJscjCOijX3o099nRNePUz9QKVKpfSpqP5gf+kBjgw6f3yRq+?=
 =?us-ascii?Q?Whl2U3I+KvGVZzWCZ4hlAkekG0I5diTfaJ0Wfj0+U3c5pDL5L/ZrQNYpBjFF?=
 =?us-ascii?Q?ffPogGlIlXu+mjVB2bxY2I9xhCxlR5z1j6J9OIH0Q8JczX++5WefmFAHhyIa?=
 =?us-ascii?Q?3Iukgqx4xW+2IPebVebXUth9UpO7mqygZXWSNL3gQ2FhjNQUtY3TKT87wCuq?=
 =?us-ascii?Q?RYp++juf14yj/cW4gKMDgRH+b3qhgrfunLGnuluvf++fojpa+7YACjyoWT1T?=
 =?us-ascii?Q?4x/U/GpkPV++kKUfI7+al3czAFQDnE23OCrrixuWGCn3wEZIoVLClZzhkrD3?=
 =?us-ascii?Q?9T99pf/2arwZeIWfp6HhNdsN+d9cQ14f7BaenBnyVJyAhErErwwhrflREBvM?=
 =?us-ascii?Q?0hMIveQPBGqh4hoJa0sNADUOIISBo0oAEAeTYxvdloXWqptBG4NvsgPEnXiJ?=
 =?us-ascii?Q?NY8QScSMhZum/EfEB2G4ciamV3koXpI7S+YZythlxgI8+b++WnoIlUzRcMvd?=
 =?us-ascii?Q?aJhsH89cneetVauE0Ea78bpD7UuJLfFU9V7vR181Z+iJUPyuVXKcZ1xudL87?=
 =?us-ascii?Q?fUGXNC4VXe2cuJEJt/VVrCLZYOSNFtfxplWeGUWsLNVLOEUjvQQhXiTF6pP1?=
 =?us-ascii?Q?Zk6zhEGruMCuSLO4t9TEZAENU9hDPDOnqda+M9z6MRT3x2ZYVUG0DLo/JpN2?=
 =?us-ascii?Q?OsFNgWJj3VQLJ6+xdtWLcMbLEoRrAdk/Qxt8kP5sztE+eG0BiLCrmYqUqDnI?=
 =?us-ascii?Q?eF5d6jlyq0+dAYHkC/O2qKUDdLGBhiAn8A1W03QJvHIYJuDcQvzjIdCxRn7J?=
 =?us-ascii?Q?iAiClrID6eW+4y2uEDp7wFz718/BdqBI4FGc/ItNOxCcdP7zFscZJrf76ewu?=
 =?us-ascii?Q?2UrPM1YSexsqckbXOdij1TkrXCijKLQpB4SYSfCV8rnhPhKRAZ55cpkA8gDA?=
 =?us-ascii?Q?xHgvhQbbIGCSB5VcBBYbPsJW9LPj3RNF4Aputjz9h2PDjJOAU6raTWf6mpyb?=
 =?us-ascii?Q?OQO8ALgGdn694252RdgqlimSquclWZRABTs75GRDtY8TIVever3iskyTzQHo?=
 =?us-ascii?Q?CCdrqEY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:22:50.4667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ada507-8570-4c84-2fa6-08dc713758b2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4167

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
Message-ID: <20240501085210.2213060-8-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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
index c966f2224624..208bb8170d3f 100644
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


