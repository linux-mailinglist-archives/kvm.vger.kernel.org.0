Return-Path: <kvm+bounces-17226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6DB78C2BC4
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63B8F1F2763A
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EBB13C917;
	Fri, 10 May 2024 21:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Cw+sIMd0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B730013BACA;
	Fri, 10 May 2024 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376105; cv=fail; b=Qp0bhrXimBsCO4IYaXH0YEEpp59+xdFTvdf/frpOg5L3zZOWYaOKy+K+zFm+AK3I8ZsdibGwSM3hOAmTobsq8rb2Cdv5CstNQg4NlJQttUTVw2O0//tG7S2HLRsI84ixjRx4A689QH/PDeimpyAHFGThGhZP7zaLbRR3lbRqWXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376105; c=relaxed/simple;
	bh=JEny4vs4b4p3nsrcI1mVhMv2rZOY5aB8o5erWsbR41o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qOe65ZU1N5WH/3nBYblZO0MUSBh51JuihGb2YfXayxZhfojrMeTUr8uQVOhuNKVvyuM/Fi3/+DphGhuiijUVYDNpRsxsKozkq+C0dlxkqJTEDD4kbeFcbB3U2crwXuR5nklHcTEIuBYS3yGYXKqwp9ZlhvleqZk129wBRAwFqM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Cw+sIMd0; arc=fail smtp.client-ip=40.107.102.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zsgjlm4AvVuB8kW6GA0ke5UPnPAnF3CaY9S3DvBARUjh1fVwCL6ZFjWRjLuBn9aN8wGERde3oe0MdjiO16v//WB508SXz5h4xRjW1ew6bG3XLg08LCz3FwEY7TQXwxtxi2Qfe4/ci/XQ6/Ggc12GqHJ0Bqq0Y5ExwpDl19ZlzUtO69WccRyVfkqGgXQ7FOpy/qEbbucS60uhcxrpnVslNc9fG1cmk5j+18HhgbT6jMkaPkfVNY6Z3kkX2LWGItvQe/5BSDcp0iqUCNOshaffMvhw4aYbLFzlyhmb8ncsmBGrJE+YF6t6rTBYRFf/effePNhuw6/nI5nSK7pdWttheQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uC/eh7Tszyeo3AcJrOXq4KfmQHshjD/x6jIrrxrYco=;
 b=FXc1XLDhug/X9PR1XLASi7R4XOHUb+oNZqa1RFfnJZS+XlLk1k/0AGmZYp/geCnQ1rcUaFO4K2SPkN/kYKrS4HEnG14eWlNG2Ktak3FiYUzVkZVlT+Q2Fjf84f+tQgwKhrtlw3cq1hY5+UYAVSeWxI7+SD6HxERxhGH+9KLdJtH5Nvp2a9Y6UCAjo6AyBx+42wR/C2ektr2adbLBEDuhwTW/fAmP0pr5CjuXHD3ecqw6yc403SuSPZb9ZknBtL9siNslcaHi+cSPlGMWw3bKX8+bkSXXQfSI5JsJop14uM5T2Z7TBpbDZ8jXVu1amA4vGdLVTrWLL/qGvxjOIrMpUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uC/eh7Tszyeo3AcJrOXq4KfmQHshjD/x6jIrrxrYco=;
 b=Cw+sIMd0cAi61oQhd5jyyMfgscSF5fPVROn5Kr4YhLC2BPBFHLtPIPFkjiJqSyvJZwWEbFiIvGPVc6thFxpqdSwV2TsYX09v0Urhv/pMFeubAKgGlDC/de5hJQ6TW0AySM6HLSp1jGd3xZLj0/5RD1Mc8yZNofRYG8LgcY99JMU=
Received: from BN9PR03CA0269.namprd03.prod.outlook.com (2603:10b6:408:ff::34)
 by CY5PR12MB6597.namprd12.prod.outlook.com (2603:10b6:930:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48; Fri, 10 May
 2024 21:21:40 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:ff:cafe::f5) by BN9PR03CA0269.outlook.office365.com
 (2603:10b6:408:ff::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46 via Frontend
 Transport; Fri, 10 May 2024 21:21:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:21:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:21:39 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>
Subject: [PULL 03/19] KVM: SEV: Add initial SEV-SNP support
Date: Fri, 10 May 2024 16:10:08 -0500
Message-ID: <20240510211024.556136-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|CY5PR12MB6597:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e06e9c7-916e-430e-4fc4-08dc71372eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5yhQscy9QfVqufj3gozZtmNYMbXU6yU0D9fgCk/TH/yaenGwicc0iJp52gZ5?=
 =?us-ascii?Q?aMHkvhmsw9vBnesKDzJwadgyd29J/GkB2x2ydGKeC0ZMdUBmwE8vp03dEAjk?=
 =?us-ascii?Q?5CCW4OWR0XBHBbchX9T2sYe+p/a4EGxscJLnKIBVWsHsR50HRQ7So12NyuJW?=
 =?us-ascii?Q?4WqPOCuUnSgVx0v3ot06SsvHPJ43eHi310qP4cGzGs+54mXqsZX3QnIo3BFG?=
 =?us-ascii?Q?3PWKWDLrx28Z9rhlG+FhnuYpXR7ioQxCi8AbtKHfnoleDvHBhYIYp4+xnG8o?=
 =?us-ascii?Q?H76mC5vJyZe+t5SCmhoNLfqgd0PKsOnaE9E0kR8HIZZaoKzWMA0NM2mohtyh?=
 =?us-ascii?Q?YsV0hya1pkwq9r+2M35ldCTKNV783k1xGyKShX6/aVsuzQjJIF/XNbgTzsjh?=
 =?us-ascii?Q?RXXQ6EHtBBPqaDf2EfMISj0i9cyPi7hdJGawxO8GH6sbSKu+fBN1hFwldnwS?=
 =?us-ascii?Q?O/MHxT5TeKgVuDn1SBtk37fTNnpvHo0scXLVOcfWLFhUhBEaovnj0De3JBF8?=
 =?us-ascii?Q?1PK4N6H4nHHhoHy1ar474K2AA42g4k4N/ikEz+Kt0lYMO8LJv+DM0Dm5oX1N?=
 =?us-ascii?Q?qAsJ4hu4bq8s5yNqCj0gZu94BBJWliMkMa19Xo54d1DkbodhQdRAnQXfbvvK?=
 =?us-ascii?Q?hpkIrhazYSneMWVC50maW5EwmnJ6DlRhjTuthFZusWyVVs/BBy5XV9jlbjAK?=
 =?us-ascii?Q?g8xnWo8bF7HjrElHk3zYvDiMEyiSwfiWal5fLdm8AGZFZcZVTJk+vCG5A1rB?=
 =?us-ascii?Q?/etJ9F9yXu9mXwmyB7GftRaQU1xNRuPNhO/5PS+lUdNUw24Yh5UozeB0LkOY?=
 =?us-ascii?Q?jxrdtV8yO49g8Mz4yv7AF/0ps11H9/vlgOy0RMd5KyndxC4RFZ6VBmp3wZU8?=
 =?us-ascii?Q?CWrAt5XxFq5WPwvpjdoZ6SJXsIX0vz8JilSgex3i8SPuofGRtzy3Tz15CpXW?=
 =?us-ascii?Q?sYUL1+/2Ea2VGdpkjWMSygWfjiVP6izw1AU0HNd1tlPlRHO0jkaLHBD60jfd?=
 =?us-ascii?Q?vNdzl3IiBhq+vgOtxNmnkJqmLO0QXwGRSZg09O+dAuPwU13S3q9s1Zt89kfI?=
 =?us-ascii?Q?OgAnIKbyeb35ATJTsr0pJLt1SAWY73oMt4VkKkPe1eJ0Kw6NG9PZ87zUOHYo?=
 =?us-ascii?Q?IgE1H3+T8XJRNob3hhzDluH9fUQksFVU6sXSr8HdRQ6aLziZkBnCwG7RVpny?=
 =?us-ascii?Q?PAh6z3VPGghTmgqYEFngNNFyuNem+Xx6ionYGaxBRa/PGDvHFtzZ+n/zVCvL?=
 =?us-ascii?Q?0zgA6dzIBwrq6j6PVZyNgLu/8sbY2Cq2baLwu8egSHSRTCwkq8kfjfkjBFrQ?=
 =?us-ascii?Q?7CBE7RwpU3Tt7SkZ/WG/gass8YuvvWu7bdVTKbr6UhM4nUrpdDyEDuJVFheE?=
 =?us-ascii?Q?4chwU3c006eTYA5jdMYPLcpQxXKj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:21:39.9826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e06e9c7-916e-430e-4fc4-08dc71372eb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6597

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
Message-ID: <20240501085210.2213060-5-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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
index 9fae1b73b529..d2ae5fcc0275 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -874,5 +874,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0623cfaa7bb0..b3345d45b989 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -47,6 +47,9 @@ module_param_named(sev, sev_enabled, bool, 0444);
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
@@ -288,6 +291,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (sev->es_active && !sev->ghcb_version)
 		sev->ghcb_version = GHCB_VERSION_DEFAULT;
 
+	if (vm_type == KVM_X86_SNP_VM)
+		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	ret = sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -348,7 +354,8 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
-	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
+	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM &&
+	    kvm->arch.vm_type != KVM_X86_SNP_VM)
 		return -EINVAL;
 
 	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
@@ -2328,11 +2335,16 @@ void __init sev_set_cpu_caps(void)
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
 
@@ -2413,6 +2425,7 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2425,9 +2438,15 @@ void __init sev_hardware_setup(void)
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
index c8dc25886c16..66d5e2e46a66 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2057,6 +2057,9 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
 		error_code &= ~PFERR_SYNTHETIC_MASK;
 
+	if (sev_snp_guest(vcpu->kvm) && (error_code & PFERR_GUEST_ENC_MASK))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
 	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
@@ -4902,8 +4905,11 @@ static int svm_vm_init(struct kvm *kvm)
 
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
index be57213cd295..583e035d38f8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -349,6 +349,18 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
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


