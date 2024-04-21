Return-Path: <kvm+bounces-15434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C458AC082
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DFC7B20B87
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D75A3CF79;
	Sun, 21 Apr 2024 18:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dVPOefbd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1498E3AC2B;
	Sun, 21 Apr 2024 18:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722778; cv=fail; b=uc5ZOi26u2IuYHfQ/AIZwgnE2vglZR8bp3ecrtuniiFCHqIf3uob0RX3Z3qVzqB1T93xSoIjjwrKRaMEsK0o9k3USMiWMj+6tj5sebAL2O0dDMzO6ADbVrWlfrSC5rdhjpvnE+ClCZEa59l5vH8JVyO49nqB6YGSTmVQXJ4fJE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722778; c=relaxed/simple;
	bh=BgLnFovC8CpTjpMCVpZumb6t+26S0UOpVmLngXjlPls=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l4CYHgyyg4OiWScdve+wmh2hku3bE03ObKYps00y90FbyratmvDyOkDGLxP4fYdecGyyWTsYoKG3GcReFZtIT9k/ofzJKF7TUKMtqin/Qo7nV8X2/3nTzcN7coKvockBgstP4MqJGxpC6oOASx9tPHtWcOl9TGddzK/ij+XNIj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dVPOefbd; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZ9MXYRG0BBxEVKhVyT5Z0fMvaBNYVNTnAgyaQWnCOLk8f31linBlwyNvubIVAONGshkJMwpwKpN3zMvLlfR0SNqNpDwCj1O2+0Fn43PdcFOKRbpEDotpYcRKtgMr5nJI+MlIOWEB0fvZOEhrIst+gqc2hzbyVCiby33PsPJSDmXycxmgdH47HHpYsppqzsteIeURea8zJFC5pXgkzvXJtHlNLBpldSH9AHo8h01fOpKd2rqWYEBaBeu45yEBwinSH7bwRjo3tXCjN0KV2H01Oqr7atlCGj0yCcJ79DSMA95/bLmsjZxssAKhcFkk2HKPV9c0MWgU37F1RZhLEXJQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIkMtRSRO7fH3cVhAkacQeEXCXRCe0mzWjsGllchBtU=;
 b=ZIQ6VU8vxxXO9IIdslJFCFMFYGxEoUZUGUXZw+jjIZaCAHZECUbrrwaO00U5h744v+BAaMLpjeCDD+UjegtU37+1JPDqaQbY2AmLjj0dzr3pLsd6r2G32mzTV8UbGaprhX+rEgSO178vVlUhZoPEg7d9WLLPYlTbWwyYl4Qdie3omtc4RVAaXNUdgiVDGZdk3Fm1Ix0RHke47QrTH9XR2tyIwGA1g3goF5OuX2YLUDd0/yoF8lZb/ELHXSt6UFlChVQf8JSK8awSgPgS4Y1dQnalSEJrSH+ybFe8Wdl1JDfFHdX4T1qZKmYOhU7nhT2LS6/OE2M1ji6XLA0JT2g20A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIkMtRSRO7fH3cVhAkacQeEXCXRCe0mzWjsGllchBtU=;
 b=dVPOefbdIpWbBZO/Z1RhRtuNxaDcl0zh7xkg0pFVTpheIp6NHPPQiaNVts2YKKx7QvENdGOfVHHH7vsZXbz64krAiJTG7zSy17T5cLF3wO/AqWnDap7lxseNSVdTGqF/gHB3ETHufoC7r9xHI12pZNjpIJyAzWx83VbNZEIqXIQ=
Received: from BLAPR05CA0036.namprd05.prod.outlook.com (2603:10b6:208:335::17)
 by SN7PR12MB7855.namprd12.prod.outlook.com (2603:10b6:806:343::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:06:13 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:208:335:cafe::b5) by BLAPR05CA0036.outlook.office365.com
 (2603:10b6:208:335::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20 via Frontend
 Transport; Sun, 21 Apr 2024 18:06:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:06:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:06:12 -0500
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
Subject: [PATCH v14 16/22] KVM: x86: Implement gmem hook for determining max NPT mapping level
Date: Sun, 21 Apr 2024 13:01:16 -0500
Message-ID: <20240421180122.1650812-17-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|SN7PR12MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: ebf4550d-c5e9-442d-29d0-08dc622dbb4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kuJRvVWvpkNCyoQBgjjAx1z3yn12tzygLsvdu2fAcwaSquc3FsXgyTGBHgOL?=
 =?us-ascii?Q?TXLMt057UuwF1AGq+C+kOFipSLSnWu9TfrdlcZUr0HZ8FLnKYTu+oUGi+zfk?=
 =?us-ascii?Q?xwaYUcPqOzbEhCtnNChHKP7YiQlfpwKo/9qSm3ceJ3WTiu7jPrUH9pWGexmy?=
 =?us-ascii?Q?kyzDK3PJcfBY912qR13AunLbypebDksJt1iKlUSqTv0FuXjhJoYVh0ST2dDQ?=
 =?us-ascii?Q?ymCjeYtnoT9EJIKNYBT+76t6kKgUV21Or801hwdPYuorCZUQDcFJjaF0y168?=
 =?us-ascii?Q?qj9yeeipkznjKSufxEqaNyJxGGl2vq/BjOnHl4LRcSWmGP0a/9+7he7rlHJd?=
 =?us-ascii?Q?C22DpVFUVkdihm+yH93AwyBhPwTJeGiYf8OGIei4kOkAR4oe2bAXllUz1MqT?=
 =?us-ascii?Q?Rj6L4pHgMLZw3ABTbx0Bp8MgLDVNXec7/JV1SmLXIHE46Uu0NL14uesLrvvF?=
 =?us-ascii?Q?NF79383vNUKTAyeOOKBty45AQ/8o6+YEJE36wiRnJp1E2TiKjUDeg2omQp7H?=
 =?us-ascii?Q?P2eoAHzfV8MiVzK2N+NKZWysiE7ylsVXwdnR7faRjDXC4PVZiQDVFw1JwjEM?=
 =?us-ascii?Q?jg8Wj3byoLfiIeotvnm5QMkVUGxAeO3z99Jn1qmxhSMByu5cpHXt7tCjYwjD?=
 =?us-ascii?Q?6+6LPxk7C5M4fPDfdyreqQkQ1jx1Xg3XrSymIEnaa6JvWdljhT8tGNNUYnHr?=
 =?us-ascii?Q?2lFgFybQ+sRZ7jeYvyoxYdrCl54U5PXnZ5pQhoEOwvv66PPAQiBBBnh8qdGJ?=
 =?us-ascii?Q?HG2DrRr1VWh/sM+fwysvEbEc2TM9MWKzent3fhVREVOIKP9kHraaRB9V3xiq?=
 =?us-ascii?Q?5AWI44H+zEtptK9yRKrabr2AUQT+kp3E3zMsOiPVAQUBZX0T9k1ZypPyDNAY?=
 =?us-ascii?Q?sIjr42KsA3Op2a+jipHZdrpC3hd/OaecyUs7uG6lUVcXUFDKIF0O6hVvxYHd?=
 =?us-ascii?Q?aMP75ZL/3nvRl1V0iQPC40kXi/ZfOuVL6APoOOoxfbBn6UJhXL+VZEGZCvGs?=
 =?us-ascii?Q?KNTM6jZCoWzIxnWoKKzQy+A22fRUwwjucQwwQ3Y3w+c4U2aTD/jAVXR/3uuV?=
 =?us-ascii?Q?FoOGXaIHunJe8b9eQQ5OfwzciFLhhdmlaqBzBilir81UueZXpFwZQcgpjr+9?=
 =?us-ascii?Q?NeVWpCYYAJT4tu9FjwxZJssHMkgjfiI4559cOhqRAeIP0auzHLhEyflymLj3?=
 =?us-ascii?Q?DWR1YkudVreVwoOmLmFusuqCHq9Fyo64bhLGPZ4oSFMrRrSWQwBMaASFIxx5?=
 =?us-ascii?Q?bJUATfcdmERIzikxCotj3m+mKIS8Jqo/iFADza5YcEqXdveDwSI7MrTHFYC+?=
 =?us-ascii?Q?eNKSjvtp9J7/CjEqkZMl7Ie9JtqzKvDArHEK2QAOjMvy2dAUyBMVzZfk3uV2?=
 =?us-ascii?Q?CVd+SrONLQRdBqXdEoumT62VW8Pj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:06:13.4459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf4550d-c5e9-442d-29d0-08dc622dbb4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7855

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
index ff9b8c68ae56..243369e302f4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4528,3 +4528,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
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
index 29dc5fa28d97..c26a7a933b93 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5088,6 +5088,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
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


