Return-Path: <kvm+bounces-24909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA4695CDE5
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6960B23383
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAAE1187FE0;
	Fri, 23 Aug 2024 13:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xpEUZJSt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2043.outbound.protection.outlook.com [40.107.101.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD989185949;
	Fri, 23 Aug 2024 13:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419841; cv=fail; b=THij8Oq5B6gpZgsD2AluT9+mZ5OI0tpwknW83OJMsHtUiNAuA8LrUOpai24HWpYr52H0j9UBLSisxPXhKJ7Blk6wGZ+v6U5FWoPmXd5OdzvsPVFHOvWd7r/fXPkwSC0VVoMlmfB7zeQhQ3OPBedjQ8Q7hVXBYBvKerUBIzAIsu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419841; c=relaxed/simple;
	bh=cocLMsMWaRNgSdr+uQduvVjEnrlMIiHHDWVFAN/UJCI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1txIpMIKgu7SKf/BEMPjaJAzCMFrpeBcbkK/ZFm4A3yzNefShcDIMe2NzAIxsn8djKTtV7o076k1wbebjBy2cre0kfcWJEiAIm1ll/EUCswTEI3tOJ4+CaeQ1E80fxjEaAnUsw7ZblVXzuEDX844Z65QfXPzmq2AmGRk6yk2xM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xpEUZJSt; arc=fail smtp.client-ip=40.107.101.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jw0MhiN52LuAp6ejinUv029puQa6QQQgXi9KoX+dtEzjCso9gdyx9Oozhoo0HxrXSGqeOdzztuT+svMdQY0oxYO/zXUxPEjU98DEmXhgwcCFWgM9HAz7aQkKQqHrKBQPADT1fnymoenibCNFPA35QPFAFr6bi27uQ2FVKn6vyLLmLjlyI4/7LW584d9ooWUJ9UysCyFamKj2yBVoG2VwC2rWEwhSLZQMz6YMTFqm4kr/mMhA4Kn2tC+k8w/u9HSzGPT+IWB8+iSMabcQA52lhEVs6TshR3vJZhnMbLwWTZRtyrQzheFophpAVqQH+uGalNpHvo+PzEbbREwtCjQvIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jp3W9Ms+8s69jLkLidccRUN6d27jBOKK6hXWgOq51EU=;
 b=ornoXJjFxg9kU5cAkZunqBZY4iOhEwyrSbALQdaYuBwznMKFcKzRwJQmhILfKUTH33jsxrDFjJEeynh+rNeCUbXAl9AdA9SiS+o+X4lI0wdvjVB9QftFusfKuuZhu2M69txy3cptIDkyMOWPq1B2PYQdGx2zl3rVT11D1wnA3vy3SSIBd85aeUk8r7zA5N6U+YioHv5deCis4FOoNJMYbHrdMI1uugLtxboV2jY0g10uD7IL/h6bIq8/5YXykJPRrXR1TCbH/J52w83JRktge3MRvcmSVPn4SjnV/aTW5UCk2yU/Vy9gu/9gIMUtJI7IpsmZ+mz7hRsc8750J7F0aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jp3W9Ms+8s69jLkLidccRUN6d27jBOKK6hXWgOq51EU=;
 b=xpEUZJStF4WnQmM6+lsvBtfmIcRaQBBX/OZjA9X69REeeP5IRGNDT+nXEVJ3Cq24uRSX5VK5ZLi3PjhzhQwyJmpLud3FI7IUmQwsyAV64ZxzGDtbh0SLv/XXCFT1X4sRpTWRbCp29zIBY3kacwS+MgSng0zfqpg+AvkC7dgSHlc=
Received: from SJ0PR03CA0009.namprd03.prod.outlook.com (2603:10b6:a03:33a::14)
 by DS0PR12MB7629.namprd12.prod.outlook.com (2603:10b6:8:13e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:30:34 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::26) by SJ0PR03CA0009.outlook.office365.com
 (2603:10b6:a03:33a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Fri, 23 Aug 2024 13:30:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:30:34 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:30:28 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Date: Fri, 23 Aug 2024 23:21:25 +1000
Message-ID: <20240823132137.336874-12-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|DS0PR12MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: 7be304de-c390-4682-fde3-08dcc377c46d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k2EfKnV4sd3jTrRYYA8p5lL1MOP+ZjcZhRDIy8Swh8DURixWboy70+O5pO7M?=
 =?us-ascii?Q?4H2HBwNLXZYwZSA3yBgarDz1jUoEC0kNJf+KJANkCe1TviVUpg9lSCLjp/yh?=
 =?us-ascii?Q?lcxkd9y6SNZspkmkAFkGfx9DHvGWpgVe943sFMooLvwcDQQvv6H6/1bUxeXk?=
 =?us-ascii?Q?yGTJEWHhUOATxvvglBrRODsrZnFAK1mqW4lQgGa6KhcjlyJNIuRgnHmBQFPX?=
 =?us-ascii?Q?Y4tyjOAACIVedESqLevOsMqh+zqSgv7KbkTbqmHvdq585HjBPAgWq2FcJ/SD?=
 =?us-ascii?Q?jITZZxYF/VPFpcnynlfYNRpWd4YYoA5HkqWMTOJn94TOpYUbuLyuxcrG9tcT?=
 =?us-ascii?Q?x4oFaB2hV7kCRgQIIsXDZ3+wd6kKO8ei4E8tik7MItfZWkhlfl7xw6Oj2KWg?=
 =?us-ascii?Q?81GMWLOOWMXpXpjTgbfrBf4zuXw26hy0MQj0+7kZEikD+qgDDh2VP8FpKi7q?=
 =?us-ascii?Q?/bXUzmBmljUFfnraFUBbiAVq6odJdjb7utMDLPkwe/FOaXF0U0+pQqgKfKzz?=
 =?us-ascii?Q?segQIGI8rU6Hmpaw4s27Mq90lGB+c1xm26S43Hc83Mhvllx73M5Whsk6vSgX?=
 =?us-ascii?Q?8I/8LhXRIpW1cQtprfFVEhIgbq7ys80O3HTLmDZzzO0yXRAckma2qB4ODtGB?=
 =?us-ascii?Q?vWVtEfvT2jAzPbUeftOiOUmp4jhAdg+FEillbvv7Pv+HWa9Fa45kR4ixb7mv?=
 =?us-ascii?Q?iCgLLvoC5I99Z834NFpDo/UZ3s59w0uiVX4oVpP96JyLbjTi66csT6yGDgjA?=
 =?us-ascii?Q?cQMRUgQ9Nud1wzJyIF1YpFAU6Zufy7TwOceJnkvZ3Zd8W1IAsI30z4rI965R?=
 =?us-ascii?Q?cKC5jYfvYNKB+nbehjaXXGXKP/rzV8EzWKK+/aY6fhbw0d+pTnlBZwZlE/I+?=
 =?us-ascii?Q?GD4X8/LxOnu8t+WpIflDcZgpEdHx1DGQvo9b6RVxbu+wwEgzKJOy2zrRxIh0?=
 =?us-ascii?Q?lYzG83XflONlzF2AjrfJ/HcnY7sakT3YqEi/s3Kmew/3dpT54Kno61TRhPsz?=
 =?us-ascii?Q?qeHXmkSoM9n5BFYlSEq8YDz9vfW/fMsFovRkNnNfxXymc3UHpsLh3NgLo3Sz?=
 =?us-ascii?Q?rL5Z2fCrHdFSdKadTRFUN6kLYzKxSmR7/stDM+f6t+1JfaQrwLEQlJ1Kzsgg?=
 =?us-ascii?Q?zPK4aZ0FIjeJD4MU+5zHYC3SZxw1q01jWJF7JGWoaEtpNWXi0gaLVF52LQ0E?=
 =?us-ascii?Q?7IU1YStNNECCgHstrKBNZYN7G+d5eVKhdJrgcbjp+jRGdHxWKlqn4lK+8RS4?=
 =?us-ascii?Q?g8RpaJk+8UIo/LWIKM+c2SZrDkRMM1QPcgrAccHdVaxYmU/0nfkmUOLy100m?=
 =?us-ascii?Q?H9/dTGiTyAVYU8/Z8jPaEXkHCHr459bylz5u7caZdizTKBO3NU9WPsT9ZruR?=
 =?us-ascii?Q?1PRahA1TsBiyxXZAe1WvPFgFpcVbXV1ruUgbYKEFjj48VIDD23K/xiQXaI7o?=
 =?us-ascii?Q?1LavMJtLfvRz1RE4jaX6gbIje8r1hiAJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:30:34.2897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be304de-c390-4682-fde3-08dcc377c46d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7629

The SEV TIO spec defines a new TIO_GUEST_MESSAGE message to
provide a secure communication channel between a SNP VM and
the PSP.

The defined messages provide way to read TDI info and do secure
MMIO/DMA setup.

On top of this, GHCB defines an extension to return certificates/
measurements/report and TDI run status to the VM.

The TIO_GUEST_MESSAGE handler also checks if a specific TDI bound
to the VM and exits the KVM to allow the userspace to bind it.

Skip adjust_direct_map() in rmpupdate() for now as it fails on MMIO.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |   2 +
 arch/x86/include/asm/sev.h         |   1 +
 arch/x86/include/uapi/asm/svm.h    |   2 +
 arch/x86/kvm/svm/svm.h             |   2 +
 include/linux/kvm_host.h           |   2 +
 include/uapi/linux/kvm.h           |  29 +++
 arch/x86/kvm/svm/sev.c             | 217 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |   3 +
 arch/x86/kvm/x86.c                 |  12 ++
 arch/x86/virt/svm/sev.c            |  23 ++-
 virt/kvm/vfio.c                    | 139 +++++++++++++
 arch/x86/kvm/Kconfig               |   1 +
 13 files changed, 431 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 68ad4f923664..80e8176a4ea0 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -139,6 +139,8 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
+KVM_X86_OP_OPTIONAL(tsm_bind)
+KVM_X86_OP_OPTIONAL(tsm_unbind)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a68cb3eba78..80bdac4e47ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1830,6 +1830,8 @@ struct kvm_x86_ops {
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
 	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
+	int (*tsm_bind)(struct kvm *kvm, struct device *dev, u32 guest_rid);
+	void (*tsm_unbind)(struct kvm *kvm, struct device *dev);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 80d9aa16fe61..8edd7bccabf2 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -464,6 +464,7 @@ int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
 void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
+int rmp_make_private_mmio(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
 void snp_leak_pages(u64 pfn, unsigned int npages);
 void kdump_sev_callback(void);
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 1814b413fd57..ac90a69e6327 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -116,6 +116,7 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST	0x80000020
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
@@ -237,6 +238,7 @@
 	{ SVM_VMGEXIT_GUEST_REQUEST,	"vmgexit_guest_request" }, \
 	{ SVM_VMGEXIT_EXT_GUEST_REQUEST, "vmgexit_ext_guest_request" }, \
 	{ SVM_VMGEXIT_AP_CREATION,	"vmgexit_ap_creation" }, \
+	{ SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST, "vmgexit_sev_tio_guest_request" }, \
 	{ SVM_VMGEXIT_HV_FEATURES,	"vmgexit_hypervisor_feature" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 76107c7d0595..d04d583c1741 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -749,6 +749,8 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+int sev_tsm_bind(struct kvm *kvm, struct device *dev, u32 guest_rid);
+void sev_tsm_unbind(struct kvm *kvm, struct device *dev);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d004d96c2ace..fdb331b3e0d3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2497,5 +2497,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
+int kvm_arch_tsm_bind(struct kvm *kvm, struct device *dev, u32 guest_rid);
+void kvm_arch_tsm_unbind(struct kvm *kvm, struct device *dev);
 
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..37f76bbdfa9b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,17 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_user_vmgexit {
+#define KVM_USER_VMGEXIT_TIO_REQ	4
+	__u32 type; /* KVM_USER_VMGEXIT_* type */
+	union {
+		struct {
+			__u32 guest_rid;
+			__u32 ret;
+		} tio_req;
+	};
+} __packed;
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +189,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_VMGEXIT          40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -446,6 +458,7 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		struct kvm_user_vmgexit vmgexit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1166,6 +1179,22 @@ struct kvm_vfio_spapr_tce {
 	__s32	tablefd;
 };
 
+#define  KVM_DEV_VFIO_DEVICE			2
+#define   KVM_DEV_VFIO_DEVICE_TDI_BIND			1
+#define   KVM_DEV_VFIO_DEVICE_TDI_UNBIND		2
+
+/*
+ * struct kvm_vfio_tsm_bind
+ *
+ * @guest_rid: Hypervisor provided identifier used by the guest to identify
+ *             the TDI in guest messages
+ * @devfd: a fd of VFIO device
+ */
+struct kvm_vfio_tsm_bind {
+	__u32 guest_rid;
+	__s32 devfd;
+} __packed;
+
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9badf4fa7e1d..e36b93b9cc2b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -20,6 +20,8 @@
 #include <linux/processor.h>
 #include <linux/trace_events.h>
 #include <uapi/linux/sev-guest.h>
+#include <linux/tsm.h>
+#include <linux/pci.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -3413,6 +3415,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		    control->exit_info_1 == control->exit_info_2)
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST:
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -4128,6 +4132,182 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return 1; /* resume guest */
 }
 
+static int tio_make_mmio_private(struct vcpu_svm *svm, struct pci_dev *pdev,
+				 phys_addr_t mmio_gpa, phys_addr_t mmio_size,
+				 unsigned int rangeid)
+{
+	int ret = 0;
+
+	if (!mmio_gpa || !mmio_size || mmio_size != pci_resource_len(pdev, rangeid)) {
+		pci_err(pdev, "Invalid MMIO #%d gpa=%llx..%llx\n",
+			rangeid, mmio_gpa, mmio_gpa + mmio_size);
+		return SEV_RET_INVALID_PARAM;
+	}
+
+	/* Could as well exit to the userspace and ioctl(KVM_MEMORY_ATTRIBUTE_PRIVATE) */
+	ret = kvm_vm_set_mem_attributes(svm->vcpu.kvm, mmio_gpa >> PAGE_SHIFT,
+					(mmio_gpa + mmio_size) >> PAGE_SHIFT,
+					KVM_MEMORY_ATTRIBUTE_PRIVATE);
+	if (ret)
+		pci_err(pdev, "Failed to mark MMIO #%d gpa=%llx..%llx as private, ret=%d\n",
+			rangeid, mmio_gpa, mmio_gpa + mmio_size, ret);
+	else
+		pci_notice(pdev, "Marked MMIO#%d gpa=%llx..%llx as private\n",
+			   rangeid, mmio_gpa, mmio_gpa + mmio_size);
+
+	for (phys_addr_t off = 0; off < mmio_size; off += PAGE_SIZE) {
+		ret = rmp_make_private_mmio((pci_resource_start(pdev, rangeid) + off) >> PAGE_SHIFT,
+					    (mmio_gpa + off), PG_LEVEL_4K, svm->asid,
+					    false/*Immutable*/);
+		if (ret)
+			pci_err(pdev, "Failed to map TIO #%d %pR +%llx %llx -> gpa=%llx ret=%d\n",
+				rangeid, pci_resource_n(pdev, rangeid), off, mmio_size,
+				mmio_gpa + off, ret);
+	}
+
+	return SEV_RET_SUCCESS;
+}
+
+static int snp_complete_sev_tio_guest_request(struct kvm_vcpu *vcpu, struct tsm_tdi *tdi)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	enum tsm_tdisp_state state = TDISP_STATE_UNAVAIL;
+	unsigned long exitcode = 0, data_npages;
+	struct tio_guest_request tioreq = { 0 };
+	struct snp_guest_msg_hdr *req_hdr;
+	gpa_t req_gpa, resp_gpa;
+	struct fd sevfd;
+	u64 data_gpa;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -EINVAL;
+
+	mutex_lock(&sev->guest_req_mutex);
+
+	req_gpa = control->exit_info_1;
+	resp_gpa = control->exit_info_2;
+
+	ret = kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE);
+	if (ret)
+		goto out_unlock;
+
+	tioreq.data.gctx_paddr = __psp_pa(sev->snp_context);
+	tioreq.data.req_paddr = __psp_pa(sev->guest_req_buf);
+	tioreq.data.res_paddr = __psp_pa(sev->guest_resp_buf);
+
+	sevfd = fdget(sev->fd);
+	if (!sevfd.file)
+		goto out_unlock;
+
+	req_hdr = sev->guest_req_buf;
+	if (req_hdr->msg_type == TIO_MSG_MMIO_VALIDATE_REQ) {
+		const u64 raw_gpa = vcpu->arch.regs[VCPU_REGS_RDX];
+
+		ret = tio_make_mmio_private(svm, tdi->pdev,
+					    MMIO_VALIDATE_GPA(raw_gpa),
+					    MMIO_VALIDATE_LEN(raw_gpa),
+					    MMIO_VALIDATE_RANGEID(raw_gpa));
+		if (ret != SEV_RET_SUCCESS)
+			goto put_unlock;
+	}
+
+	ret = tsm_guest_request(tdi,
+				(req_hdr->msg_type == TIO_MSG_TDI_INFO_REQ) ? &state : NULL,
+				&tioreq);
+	if (ret)
+		goto put_unlock;
+
+	struct tio_blob_table_entry t[4] = {
+		{ .guid = TIO_GUID_MEASUREMENTS,
+		  .offset = sizeof(t),
+		  .length = tdi->tdev->meas ? tdi->tdev->meas->len : 0 },
+		{ .guid = TIO_GUID_CERTIFICATES,
+		  .offset = sizeof(t) + t[0].length,
+		  .length = tdi->tdev->certs ? tdi->tdev->certs->len : 0 },
+		{ .guid = TIO_GUID_REPORT,
+		  .offset = sizeof(t) + t[0].length + t[1].length,
+		  .length = tdi->report ? tdi->report->len : 0 },
+		{ .guid.b = { 0 } }
+	};
+	void *tp[4] = {
+		tdi->tdev->meas ? tdi->tdev->meas->data : NULL,
+		tdi->tdev->certs ? tdi->tdev->certs->data  : NULL,
+		tdi->report ? tdi->report->data : NULL
+	};
+
+	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+	vcpu->arch.regs[VCPU_REGS_RBX] = PAGE_ALIGN(t[0].length + t[1].length +
+						    t[2].length + sizeof(t)) >> PAGE_SHIFT;
+	if (data_gpa && ((data_npages << PAGE_SHIFT) >= vcpu->arch.regs[VCPU_REGS_RBX])) {
+		if (kvm_write_guest(kvm, data_gpa + 0, &t, sizeof(t)) ||
+		    kvm_write_guest(kvm, data_gpa + t[0].offset, tp[0], t[0].length) ||
+		    kvm_write_guest(kvm, data_gpa + t[1].offset, tp[1], t[1].length) ||
+		    kvm_write_guest(kvm, data_gpa + t[2].offset, tp[2], t[2].length))
+			exitcode = SEV_RET_INVALID_ADDRESS;
+	}
+
+	if (req_hdr->msg_type == TIO_MSG_TDI_INFO_REQ)
+		vcpu->arch.regs[VCPU_REGS_RDX] = state;
+
+	ret = kvm_write_guest(kvm, resp_gpa, sev->guest_resp_buf, PAGE_SIZE);
+	if (ret)
+		goto put_unlock;
+
+	ret = 1; /* Resume guest */
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(0, tioreq.fw_err));
+
+put_unlock:
+	fdput(sevfd);
+out_unlock:
+	mutex_unlock(&sev->guest_req_mutex);
+
+	return ret;
+}
+
+static int snp_try_complete_sev_tio_guest_request(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	u32 guest_rid = vcpu->arch.regs[VCPU_REGS_RCX];
+	struct tsm_tdi *tdi = tsm_tdi_find(guest_rid, (u64) __psp_pa(sev->snp_context));
+
+	if (!tdi) {
+		pr_err("TDI is not bound to %x:%02x.%d\n",
+		       PCI_BUS_NUM(guest_rid), PCI_SLOT(guest_rid), PCI_FUNC(guest_rid));
+		return 1; /* Resume guest */
+	}
+
+	return snp_complete_sev_tio_guest_request(vcpu, tdi);
+}
+
+static int snp_sev_tio_guest_request(struct kvm_vcpu *vcpu)
+{
+	u32 guest_rid = vcpu->arch.regs[VCPU_REGS_RCX];
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sev_info *sev;
+	struct tsm_tdi *tdi;
+
+	if (!sev_snp_guest(kvm))
+		return SEV_RET_INVALID_GUEST;
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+	tdi = tsm_tdi_find(guest_rid, (u64) __psp_pa(sev->snp_context));
+	if (!tdi) {
+		vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+		vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_TIO_REQ;
+		vcpu->run->vmgexit.tio_req.guest_rid = guest_rid;
+		vcpu->arch.complete_userspace_io = snp_try_complete_sev_tio_guest_request;
+		return 0; /* Exit KVM */
+	}
+
+	return snp_complete_sev_tio_guest_request(vcpu, tdi);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4408,6 +4588,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		ret = snp_handle_ext_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		break;
+	case SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST:
+		ret = snp_sev_tio_guest_request(vcpu);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -5000,3 +5183,37 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
 	return level;
 }
+
+int sev_tsm_bind(struct kvm *kvm, struct device *dev, u32 guest_rid)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct tsm_tdi *tdi = tsm_tdi_get(dev);
+	struct fd sevfd;
+	int ret;
+
+	if (!tdi)
+		return -ENODEV;
+
+	sevfd = fdget(sev->fd);
+	if (!sevfd.file)
+		return -EPERM;
+
+	dev_info(dev, "Binding guest=%x:%02x.%d\n",
+		 PCI_BUS_NUM(guest_rid), PCI_SLOT(guest_rid), PCI_FUNC(guest_rid));
+	ret = tsm_tdi_bind(tdi, guest_rid, (u64) __psp_pa(sev->snp_context), sev->asid);
+	fdput(sevfd);
+
+	return ret;
+}
+
+void sev_tsm_unbind(struct kvm *kvm, struct device *dev)
+{
+	struct tsm_tdi *tdi = tsm_tdi_get(dev);
+
+	if (!tdi)
+		return;
+
+	dev_notice(dev, "Unbinding guest=%x:%02x.%d\n",
+		   PCI_BUS_NUM(tdi->guest_rid), PCI_SLOT(tdi->guest_rid), PCI_FUNC(tdi->guest_rid));
+	tsm_tdi_unbind(tdi);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6f252555ab3..ab6e41eed697 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5093,6 +5093,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
 	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
+
+	.tsm_bind = sev_tsm_bind,
+	.tsm_unbind = sev_tsm_unbind,
 #endif
 	.check_emulate_instruction = svm_check_emulate_instruction,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70219e406987..97261cffa9ad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14055,3 +14055,15 @@ static void __exit kvm_x86_exit(void)
 	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
 }
 module_exit(kvm_x86_exit);
+
+int kvm_arch_tsm_bind(struct kvm *kvm, struct device *dev, u32 guest_rid)
+{
+	return static_call(kvm_x86_tsm_bind)(kvm, dev, guest_rid);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_tsm_bind);
+
+void kvm_arch_tsm_unbind(struct kvm *kvm, struct device *dev)
+{
+	static_call(kvm_x86_tsm_unbind)(kvm, dev);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_tsm_unbind);
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 44e7609c9bd6..91f5729dfcad 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -945,7 +945,7 @@ static int adjust_direct_map(u64 pfn, int rmp_level)
  * The optimal solution would be range locking to avoid locking disjoint
  * regions unnecessarily but there's no support for that yet.
  */
-static int rmpupdate(u64 pfn, struct rmp_state *state)
+static int rmpupdate(u64 pfn, struct rmp_state *state, bool mmio)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
 	int ret, level;
@@ -955,7 +955,7 @@ static int rmpupdate(u64 pfn, struct rmp_state *state)
 
 	level = RMP_TO_PG_LEVEL(state->pagesize);
 
-	if (adjust_direct_map(pfn, level))
+	if (!mmio && adjust_direct_map(pfn, level))
 		return -EFAULT;
 
 	do {
@@ -989,10 +989,25 @@ int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immut
 	state.gpa = gpa;
 	state.pagesize = PG_LEVEL_TO_RMP(level);
 
-	return rmpupdate(pfn, &state);
+	return rmpupdate(pfn, &state, false);
 }
 EXPORT_SYMBOL_GPL(rmp_make_private);
 
+int rmp_make_private_mmio(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable)
+{
+	struct rmp_state state;
+
+	memset(&state, 0, sizeof(state));
+	state.assigned = 1;
+	state.asid = asid;
+	state.immutable = immutable;
+	state.gpa = gpa;
+	state.pagesize = PG_LEVEL_TO_RMP(level);
+
+	return rmpupdate(pfn, &state, true);
+}
+EXPORT_SYMBOL_GPL(rmp_make_private_mmio);
+
 /* Transition a page to hypervisor-owned/shared state in the RMP table. */
 int rmp_make_shared(u64 pfn, enum pg_level level)
 {
@@ -1001,7 +1016,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 	memset(&state, 0, sizeof(state));
 	state.pagesize = PG_LEVEL_TO_RMP(level);
 
-	return rmpupdate(pfn, &state);
+	return rmpupdate(pfn, &state, false);
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
 
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 76b7f6085dcd..a4e9db212adc 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
+#include <linux/tsm.h>
 #include "vfio.h"
 
 #ifdef CONFIG_SPAPR_TCE_IOMMU
@@ -29,8 +30,14 @@ struct kvm_vfio_file {
 #endif
 };
 
+struct kvm_vfio_tdi {
+	struct list_head node;
+	struct vfio_device *vdev;
+};
+
 struct kvm_vfio {
 	struct list_head file_list;
+	struct list_head tdi_list;
 	struct mutex lock;
 	bool noncoherent;
 };
@@ -80,6 +87,22 @@ static bool kvm_vfio_file_is_valid(struct file *file)
 	return ret;
 }
 
+static struct vfio_device *kvm_vfio_file_device(struct file *file)
+{
+	struct vfio_device *(*fn)(struct file *file);
+	struct vfio_device *ret;
+
+	fn = symbol_get(vfio_file_device);
+	if (!fn)
+		return NULL;
+
+	ret = fn(file);
+
+	symbol_put(vfio_file_device);
+
+	return ret;
+}
+
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 {
@@ -297,6 +320,103 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
 	return -ENXIO;
 }
 
+static int kvm_dev_tsm_bind(struct kvm_device *dev, void __user *arg)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_tsm_bind tb;
+	struct kvm_vfio_tdi *ktdi;
+	struct vfio_device *vdev;
+	struct fd fdev;
+	int ret;
+
+	if (copy_from_user(&tb, arg, sizeof(tb)))
+		return -EFAULT;
+
+	ktdi = kzalloc(sizeof(*ktdi), GFP_KERNEL_ACCOUNT);
+	if (!ktdi)
+		return -ENOMEM;
+
+	fdev = fdget(tb.devfd);
+	if (!fdev.file)
+		return -EBADF;
+
+	ret = -ENOENT;
+
+	mutex_lock(&kv->lock);
+
+	vdev = kvm_vfio_file_device(fdev.file);
+	if (vdev) {
+		ret = kvm_arch_tsm_bind(dev->kvm, vdev->dev, tb.guest_rid);
+		if (!ret) {
+			ktdi->vdev = vdev;
+			list_add_tail(&ktdi->node, &kv->tdi_list);
+		} else {
+			vfio_put_device(vdev);
+		}
+	}
+
+	fdput(fdev);
+	mutex_unlock(&kv->lock);
+	if (ret)
+		kfree(ktdi);
+
+	return ret;
+}
+
+static int kvm_dev_tsm_unbind(struct kvm_device *dev, void __user *arg)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_tsm_bind tb;
+	struct kvm_vfio_tdi *ktdi;
+	struct vfio_device *vdev;
+	struct fd fdev;
+	int ret;
+
+	if (copy_from_user(&tb, arg, sizeof(tb)))
+		return -EFAULT;
+
+	fdev = fdget(tb.devfd);
+	if (!fdev.file)
+		return -EBADF;
+
+	ret = -ENOENT;
+
+	mutex_lock(&kv->lock);
+
+	vdev = kvm_vfio_file_device(fdev.file);
+	if (vdev) {
+		list_for_each_entry(ktdi, &kv->tdi_list, node) {
+			if (ktdi->vdev != vdev)
+				continue;
+
+			kvm_arch_tsm_unbind(dev->kvm, vdev->dev);
+			list_del(&ktdi->node);
+			kfree(ktdi);
+			vfio_put_device(vdev);
+			ret = 0;
+			break;
+		}
+		vfio_put_device(vdev);
+	}
+
+	fdput(fdev);
+	mutex_unlock(&kv->lock);
+	return ret;
+}
+
+static int kvm_vfio_set_device(struct kvm_device *dev, long attr,
+			       void __user *arg)
+{
+	switch (attr) {
+	case KVM_DEV_VFIO_DEVICE_TDI_BIND:
+		return kvm_dev_tsm_bind(dev, arg);
+	case KVM_DEV_VFIO_DEVICE_TDI_UNBIND:
+		return kvm_dev_tsm_unbind(dev, arg);
+	}
+
+	return -ENXIO;
+}
+
 static int kvm_vfio_set_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
@@ -304,6 +424,9 @@ static int kvm_vfio_set_attr(struct kvm_device *dev,
 	case KVM_DEV_VFIO_FILE:
 		return kvm_vfio_set_file(dev, attr->attr,
 					 u64_to_user_ptr(attr->addr));
+	case KVM_DEV_VFIO_DEVICE:
+		return kvm_vfio_set_device(dev, attr->attr,
+					   u64_to_user_ptr(attr->addr));
 	}
 
 	return -ENXIO;
@@ -323,6 +446,13 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 
+		break;
+	case KVM_DEV_VFIO_DEVICE:
+		switch (attr->attr) {
+		case KVM_DEV_VFIO_DEVICE_TDI_BIND:
+		case KVM_DEV_VFIO_DEVICE_TDI_UNBIND:
+			return 0;
+		}
 		break;
 	}
 
@@ -332,8 +462,16 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 static void kvm_vfio_release(struct kvm_device *dev)
 {
 	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_tdi *ktdi, *tmp2;
 	struct kvm_vfio_file *kvf, *tmp;
 
+	list_for_each_entry_safe(ktdi, tmp2, &kv->tdi_list, node) {
+		kvm_arch_tsm_unbind(dev->kvm, ktdi->vdev->dev);
+		list_del(&ktdi->node);
+		vfio_put_device(ktdi->vdev);
+		kfree(ktdi);
+	}
+
 	list_for_each_entry_safe(kvf, tmp, &kv->file_list, node) {
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvf);
@@ -379,6 +517,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
 
 	INIT_LIST_HEAD(&kv->file_list);
 	mutex_init(&kv->lock);
+	INIT_LIST_HEAD(&kv->tdi_list);
 
 	dev->private = kv;
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 472a1537b7a9..5e07a1fddb67 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -143,6 +143,7 @@ config KVM_AMD_SEV
 	select KVM_GENERIC_PRIVATE_MEM
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
+	select KVM_VFIO
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.45.2


