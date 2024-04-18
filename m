Return-Path: <kvm+bounces-15150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9B28AA34A
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51B46288C5D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F8D190665;
	Thu, 18 Apr 2024 19:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1VCrZiVo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2072.outbound.protection.outlook.com [40.107.96.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A9E17BB31;
	Thu, 18 Apr 2024 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469588; cv=fail; b=N+praSJZBw13PFX4bGKCpublIkz1eT4XSPCvhdZAn6TFUlQfolVl+0+iaTlR+yuEi8DDBPDDthnc3jWW69nR2lwGfady5Iscl9bhVKFSSMnSgrbm5sgXymKnPgbJUtEktivNehp7sRCZqJvnjnouD++ZIGXyW8GdiqaXap9ygTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469588; c=relaxed/simple;
	bh=FtWvnEJyr7QT98Ab9ADr01NGTnpTZzRt8UEiG3TXk9U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TEcZUEBixsV3O/xhI4WbyZEJsa9BGbFrOZcl+4FMzVFW00HYn9LUfjA4fjHYwt571/9TpsNtoZtykH9nG4LX/FA1WdV8JlCrWBRMebtKcAHgH6swMd9+PY+OQbdhXVogxU9JYPPvy9PiZfGrbKfOtj82WphTe0Vb+HyiFO0ZevI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1VCrZiVo; arc=fail smtp.client-ip=40.107.96.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGGB1lupOv9/AedCouE+OjkytGKCdC1PquBQ2yDmF6SeyiHRcq92ZpMGXRk/uksF6VxezsPgXQQDGj3JXVZXedKwPbZxIDH41ZqUESzicGiU5QPblndTITrpmpt490iJ2zmKslW71cWrfj+b74h+wP6qZRjJpxKWC/fZ+lFZNHH5WFPWaBG5Zn1TbllhHPp0QzJGzIdFPRCO+sVA5CUSxq8ogueJMZhA9tc6Ffgkw7CWh3XFVVvKKGYtF1LRMyNHd+dELc38T2uNqye57+MSOY0NWMOhMQb9wcfEqm3n4tT9exSrSHqjvgEpwNdnFq8T5D2caJYHVv7b6izIg8UxgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01TAlTG+4iBkE8EHH54F2/lq8N43H8eYojPkXkwF0WY=;
 b=iYSNVk1uw+YTvC4FjhBluyKxyEBChnm/a5QbIrdyonkafuAa/ug1vF7EtQAhfh+U0DIpyp9pD9rlc8Z+2K5TvLe932QihrSgacis2UhOGT1BbzKE07tQxybtRsoS735/uxEtKjIlN7N7Iv5ul/KHSMGt9JLrR0OONGFxRlgq9MHVMlw9wn0WwnFzvPaxK8hwp+xDpMCWYmnI8tl2lBE1hm2y2ofqySylt6CKgVbUwWszbl9BzgexwfKvD8/QEmYstFVBVHhBmiBro4Zn4G23CEhG7Q2sYQSRRwvWNQhk1C1TAcqwb1kLc9D0tfMdKMtx7NDO+xwbSXYTWOmowLplKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01TAlTG+4iBkE8EHH54F2/lq8N43H8eYojPkXkwF0WY=;
 b=1VCrZiVo70BaKuGnaQUUrJ3xw5I040RZ6wQoukqwGURj7/vhnGb63hxn7xiRxBRFlQIzr+wYJYaHOQ8iH0BtGHu+1nOvet7hBUVtQSJEjePvNtYRNBJa0l2+ZdZjS8s8iw11butqCkWr/8iJsR5u7R85n2fG9Nybwa72tnKUVBg=
Received: from PH7PR17CA0040.namprd17.prod.outlook.com (2603:10b6:510:323::26)
 by IA0PR12MB8713.namprd12.prod.outlook.com (2603:10b6:208:48e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.40; Thu, 18 Apr
 2024 19:46:23 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:510:323:cafe::c0) by PH7PR17CA0040.outlook.office365.com
 (2603:10b6:510:323::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.28 via Frontend
 Transport; Thu, 18 Apr 2024 19:46:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:46:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:46:21 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v13 20/26] KVM: x86: Implement gmem hook for determining max NPT mapping level
Date: Thu, 18 Apr 2024 14:41:27 -0500
Message-ID: <20240418194133.1452059-21-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|IA0PR12MB8713:EE_
X-MS-Office365-Filtering-Correlation-Id: 01120960-070d-4c0d-fb2c-08dc5fe039f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eupQh/X5952KQoryRR/dikatdPGzgRlikufwCdcY7VB1sYHkWTIJM21g+jzHDDBUFejDvZtchywP6+krDjEdardhStcQTyElMplGB7xw8OPaeMjMm+HI8d7GSRptaHkxw6sdyC2uEQjXVoNn/+Lk+cISZEoR63zNY46uMvFMYsaAjG144UotQr/j45TwbSsoSBv4+pE7l2Ds5Ja7ChbWsXnRymR3+OQUqcajBZtQ/j3ifYxpOxmvi8sHLbF4H1cmQOLmuRKWSg1JvTbTM25K0sdmQP2Y5ZLENDzeIZmVRYORuLX8u/rugyR4N4R+K1oXMCbuqQeth4rADTmcFMDCDhLbfktTahCMtFFJJpDARcgrmga78gAArs1d8aE21ZmhuaegIT3ddjye4U3ds3eCkoKtt8CZRjxijUkkF9GSK0SqaM6rkotH3pRBzldz35qwga4Jvx7UwPPTe9BqAEBVxC7l0ltkc06Cs6alNkqaw57J8058+r4dM8dRmCVGDoojQ42ik5hf8D9TFC0n4poEyVcmbD1eMecWInV4SPy1ndINW3cS3mAtDqJl3asFtAbKmRA0SiwlIZ4SWIAYG1tx82CL5qjKDo8dbNrQxAgSPHcoltMt2lfJuGKSnk3diSuOmujsRu04xFNjIL6h+2gaKIaU/JXgGISCMa4v2VUxpkbqgohSai8x071U5qII8CPigq7t4TwN6++M9u7EF3eLs2hpVw9cWTJBTZGBjQwYCaSp0wM9ZVDyba5RcQlpddLX
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(36860700004)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:46:22.8721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01120960-070d-4c0d-fb2c-08dc5fe039f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8713

In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
2MB mapping in the guest's nested page table depends on whether or not
any subpages within the range have already been initialized as private
in the RMP table. The existing mixed-attribute tracking in KVM is
insufficient here, for instance:

  - gmem allocates 2MB page
  - guest issues PVALIDATE on 2MB page
  - guest later converts a subpage to shared
  - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
  - KVM MMU splits NPT mapping to 4K
  - guest later converts that shared page back to private

At this point there are no mixed attributes, and KVM would normally
allow for 2MB NPT mappings again, but this is actually not allowed
because the RMP table mappings are 4K and cannot be promoted on the
hypervisor side, so the NPT mappings must still be limited to 4K to
match this.

Implement a kvm_x86_ops.gmem_validate_fault() hook for SEV that checks
for this condition and adjusts the mapping level accordingly.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  7 +++++++
 3 files changed, 40 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f60bb8291494..3fabd1ee718f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4519,3 +4519,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 		cond_resched();
 	}
 }
+
+/*
+ * Re-check whether an #NPF for a private/gmem page can still be serviced, and
+ * adjust maximum mapping level if needed.
+ */
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
+			    u8 *max_level)
+{
+	int level, rc;
+	bool assigned;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
+	if (rc) {
+		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level %d error %d\n",
+				   gfn, pfn, level, rc);
+		return -ENOENT;
+	}
+
+	if (!assigned) {
+		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx level %d\n",
+				   gfn, pfn, level);
+		return -EINVAL;
+	}
+
+	if (level < *max_level)
+		*max_level = level;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 60d121250b0d..4b330b5ba4c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5083,6 +5083,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.gmem_prepare = sev_gmem_prepare,
 	.gmem_invalidate = sev_gmem_invalidate,
+	.gmem_validate_fault = sev_gmem_validate_fault,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6721e5c6cf73..8a8ee475ad86 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
+int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
+			    u8 *max_level);
 #else
 static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
 	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
@@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
+static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
+					  bool is_private, u8 *max_level)
+{
+	return 0;
+}
 
 #endif
 
-- 
2.25.1


