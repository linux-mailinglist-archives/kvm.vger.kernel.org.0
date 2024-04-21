Return-Path: <kvm+bounces-15446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8254F8AC0A7
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5C9B1C20ACB
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156003CF40;
	Sun, 21 Apr 2024 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pThR3fq4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63929376FC;
	Sun, 21 Apr 2024 18:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713723034; cv=fail; b=Ry2spbQuugqxDyL5AU1q13+5YALgwKg/lplZLSQ5tGs8fxNGIv6mzBDMPnWtmRwqnrK5trtHZWfRPmAMvgcntUx1pSYGsP2mpbST0Uge/Ea9MrYQXPDQGm1eFwg895ZajTZ+ICbMeYlmNp95e8ZqwZfslw1e0nOrLB9GPNsGsjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713723034; c=relaxed/simple;
	bh=0oq3AhxM027EkbObfVaLWeztQlVmcQ2Z7g66k7JhEFU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSd/EF6kEg0ChQqV+RwFIwLtqmhvpok9iScxayB/yxfSEMAfaAaql8XSrIpHJGHdoKxbyG8x7TWYWZmFFa772w5AvI1/8JXaDQbTHZhx3f0syj3+h0xmyWIbVIfpGzcXM+cIP7dufM9HFdDzIIAmZ6Neoc5UcalEziq0SsHcWF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pThR3fq4; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNKbjQGF4t8OKoxuxFp6Qh8zIiaM9TI6Fx1wN8TN/8fe0BUcqwfC7+u3vr5MHRDpyDjSDOS29w5lACEmNh5FLzBfSw2RgP9z/pZg4Q+GC8rxg86boNHnESjoTDkeNtKM5SyaOYfaTt675WziSisaOSkDnG5+7ryG1E1yOHMODZOTLyok6uX7oMF08vvqyYIJr9ie78bc06vgP7qvYcZU6EkTOQJPkeMURTiYBF6Zw8Wx136E6fFfFsypLbA/SO8ioBWzC6GlA3JX3BVGgD8Wu2TXhiF3Q1He/1JfVZ8dJOWgoexs4t6rC52TuTjnODHNI5ZscV/0k1J8OyDqyi5kJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ifoIm3z3q+4x9tHjaEAojEBO0qTFnu+1pfl6Hw9N6I=;
 b=ZhiMS4P6a+ZgLhI42TSNjsWaT78nYxC0zQ0jLRLf5zvQ5qttUT52+DctRyuIMuJM3wcssycl98fjkOQQmXVenzeUBByE6yRIljfSXqpCR4W+yxFBRNYcg/XQfJGl5B0ehw+wj+XvafXLXUIp5SzYe6PZlV2O2vPir33IM5BzDW3Or0BgqYVNGGbn7O3StExd53zDFw8mDrJdZ5jetwaWzB6EhqPCzzDgACB8oxt3CP/B0zzn8RCB7eocjkrJY0nu6IWk+34/w+DSiylaljo/JMX91HBj2ahmM8FGaJ9iD9XZPlWTeZyWVzOfcEgFPXarmc285e6/qJnoxO9XWX/ufA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ifoIm3z3q+4x9tHjaEAojEBO0qTFnu+1pfl6Hw9N6I=;
 b=pThR3fq4k4TRaHhoEBQH61V4lr+oXfsBDlN8woxM5MGda7X8+TU8OHTrPP8JWBDWZ/I44GQrNQ89CKaeQeoJD/TlQ8dxt1i6IVtfm5AnTKHBMrYkBsxSHZf9O5cHAnIPTngpB1QnrNS7rAv00N4ojgwRIbOzNmuNLkstflfei4k=
Received: from DS7PR07CA0012.namprd07.prod.outlook.com (2603:10b6:5:3af::20)
 by CY8PR12MB8242.namprd12.prod.outlook.com (2603:10b6:930:77::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:10:29 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:5:3af:cafe::63) by DS7PR07CA0012.outlook.office365.com
 (2603:10b6:5:3af::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:10:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:10:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:10:28 -0500
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
Subject: [PATCH v14 06/22] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date: Sun, 21 Apr 2024 13:01:06 -0500
Message-ID: <20240421180122.1650812-7-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|CY8PR12MB8242:EE_
X-MS-Office365-Filtering-Correlation-Id: 3744ae5d-1643-45f3-5007-08dc622e539a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W3D2AZZTPw6plIHUVp5KnTClhw/ewUem7wzLaiYf5NxkfSfuCswAb95XruQ+?=
 =?us-ascii?Q?6zfdcNayGDPuIgaoJctETK9Hgm+YoCsZAbSAPoSWTXQ4/0BPUubA15VZM8Lr?=
 =?us-ascii?Q?Afmtmdd6trogXEx3re/eUp3AoJ36OyaV652oDZF/AW2zwIjE4OW5j+ijsIuk?=
 =?us-ascii?Q?/ON9zitd5AWjxsQ1QeunMwzAUW4zOdV8CLFmWNBmAevHFdtDvaQHHhO8klrL?=
 =?us-ascii?Q?jlerTGRaIk+agxL6hT1DeMCJxLUHw78GWGocNCPiA/mZjJk81ILIt9o5YNOu?=
 =?us-ascii?Q?Q2q6Fq/71Tz0TS/ovj6fAP1iSZmnQ8PgxYsX3hxg4LkcmVVY3H1l56AMFy76?=
 =?us-ascii?Q?9lvbIU9vG+vn2HOPaseOZJcCCZNX/Y6mViaC9+GBH04aFlMLNh6OUrl9cAJk?=
 =?us-ascii?Q?dCIYW3XZU7mbrYbcydl+7+xoti5HAiuEEkyYDW3Z22PsVLJ9kqHkNgapFmjx?=
 =?us-ascii?Q?PSipyEhVAL0xfio52pl7ni5ri/ksRRstq945tlNL+qdwjvZ4HfNd8Wra/5b2?=
 =?us-ascii?Q?wUa7ARECo7kQyr4te76BwWWvEe4ejiGuifVbaX09VxrfT2U7E/4XxZ+4AXI9?=
 =?us-ascii?Q?pz8HyuJvV6yHY9WdtnxKaKgOiWsAEJ4QxJgugq33zUKpP5+hklMcvukhtL4Y?=
 =?us-ascii?Q?QzMt89/iwrKDLirMCRtK02nre2qsIcOdFAQ1bXiox0sa60d7b7c3B8Rbtrj3?=
 =?us-ascii?Q?swMjS5/hp21GM0ZXQwYGJremkNODTBQ9DVlSKldq9v5eUhy9OhMZkMX6P7AX?=
 =?us-ascii?Q?7Glvgxk6PKRJB7ijo9SirCk7np0vArJCUngqbRaS1ckS7jJWniy3N7j9pPPq?=
 =?us-ascii?Q?TF1MYALFMQwPU5Isj7v4OUmIMUB0fmRZOXGBynU9F22DD/CTpFhamrkWIcEU?=
 =?us-ascii?Q?5uZKw/1sH+hnWrSF9Fb0vdGyJuUQWl75+XNUlVgiVlOEVvC4cI+BKqJNnOtf?=
 =?us-ascii?Q?4sj15XcJfSnjSYid+NHb/s5DY8rfNfh+WUaGjuallPohlnjPCu9edoQEqLoV?=
 =?us-ascii?Q?Bf2eVzCkISjZ2bt1Yl9seHzIGtwkPR2FZxgSr7kdz/hTQAKOvFrG+SfdoO5h?=
 =?us-ascii?Q?6WUNoU0/Z0p5rBqdQoG8+bHsfcVCrUZZEtuEwYx4Z29nQHoWulDSRGwiF9cI?=
 =?us-ascii?Q?7FHCdbChpRbUHfgTY+UEC/5dNxEBiJNfDmX33+UO1gps+J1SlWa/xdUmc08C?=
 =?us-ascii?Q?FmoGWyCL1vvrF+Q08dcv3BXP1YexcOKLtSOYt8kcwmeLWFIdDsbvy5iVgd/W?=
 =?us-ascii?Q?eycmaXLEeUYyojWGsjq3H3UYLsz8QGKZYDReThRsWLJoSzxkLQjOsKiYqKpk?=
 =?us-ascii?Q?iqZqUQL3klLAdvGKusWKoP/LEBsfWFl/JSqzheDFDTv1LmBSWGUw/QjFbKXi?=
 =?us-ascii?Q?6nty/yoHApURuycRofiJHBmANv9C?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(7416005)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:10:28.9313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3744ae5d-1643-45f3-5007-08dc622e539a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8242

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
 .../virt/kvm/x86/amd-memory-encryption.rst    |  54 ++++
 arch/x86/include/uapi/asm/kvm.h               |  19 ++
 arch/x86/kvm/svm/sev.c                        | 237 ++++++++++++++++++
 3 files changed, 310 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index d4c4a0b90bc9..60728868c5c6 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -483,6 +483,60 @@ Returns: 0 on success, -negative on error
 See SNP_LAUNCH_START in the SEV-SNP specification [snp-fw-abi]_ for further
 details on the input parameters in ``struct kvm_sev_snp_launch_start``.
 
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
+Upon success, this command is not guaranteed to have processed the entire
+range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
+``struct kvm_sev_snp_launch_update`` will be updated to correspond to the
+remaining range that has yet to be processed. The caller should continue
+calling this command until those fields indicate the entire range has been
+processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
+range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
+buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
+``uaddr`` will be ignored completely.
+
+Parameters (in): struct  kvm_sev_snp_launch_update
+
+Returns: 0 on success, < 0 on error, -EAGAIN if caller should retry
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 gfn_start;        /* Guest page number to load/encrypt data into. */
+                __u64 uaddr;            /* Userspace address of data to be loaded/encrypted. */
+                __u64 len;              /* 4k-aligned length in bytes to copy into guest memory.*/
+                __u8 type;              /* The type of the guest pages being initialized. */
+                __u8 pad0;
+                __u16 flags;            /* Must be zero. */
+                __u32 pad1;
+                __u64 pad2[4];
+
+        };
+
+where the allowed values for page_type are #define'd as::
+
+        KVM_SEV_SNP_PAGE_TYPE_NORMAL
+        KVM_SEV_SNP_PAGE_TYPE_ZERO
+        KVM_SEV_SNP_PAGE_TYPE_UNMEASURED
+        KVM_SEV_SNP_PAGE_TYPE_SECRETS
+        KVM_SEV_SNP_PAGE_TYPE_CPUID
+
+See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page type is
+used/measured.
+
 Device attribute API
 ====================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5765391f0fdb..3c9255de76db 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -699,6 +699,7 @@ enum sev_cmd_id {
 
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START = 100,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -833,6 +834,24 @@ struct kvm_sev_snp_launch_start {
 	__u64 pad1[4];
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
+	__u64 len;
+	__u8 type;
+	__u8 pad0;
+	__u16 flags;
+	__u32 pad1;
+	__u64 pad2[4];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9d08d1202544..d3ae4ded91df 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -258,6 +258,35 @@ static void sev_decommission(unsigned int handle)
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
+static int host_rmp_make_shared(u64 pfn, enum pg_level level)
+{
+	int rc;
+
+	rc = rmp_make_shared(pfn, level);
+	if (rc)
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -2118,6 +2147,211 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+struct sev_gmem_populate_args {
+	__u8 type;
+	int sev_fd;
+	int fw_error;
+};
+
+static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
+				  void __user *src, int order, void *opaque)
+{
+	struct sev_gmem_populate_args *sev_populate_args = opaque;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	int n_private = 0, ret, i;
+	int npages = (1 << order);
+	gfn_t gfn;
+
+	pr_debug("%s: gfn_start 0x%llx pfn_start 0x%llx npages %d\n",
+		 __func__, gfn_start, pfn, npages);
+
+	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
+		struct sev_data_snp_launch_update fw_args = {0};
+		bool assigned;
+		void *vaddr;
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
+			ret = -EINVAL;
+			break;
+		}
+
+		if (src) {
+			vaddr = kmap_local_pfn(pfn + i);
+			ret = copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE);
+			if (ret) {
+				pr_debug("Failed to copy source page into GFN 0x%llx\n", gfn);
+				goto out_unmap;
+			}
+		}
+
+		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+				       sev_get_asid(kvm), true);
+		if (ret) {
+			pr_debug("%s: Failed to mark RMP entry for GFN 0x%llx as private, ret: %d\n",
+				 __func__, gfn, ret);
+			goto out_unmap;
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
+			if (WARN_ON_ONCE(snp_page_reclaim(pfn + i)))
+				goto out_unmap;
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
+				if (WARN_ON_ONCE(host_rmp_make_shared(pfn + i, PG_LEVEL_4K)))
+					goto out_unmap;
+
+				if (copy_to_user(src + i * PAGE_SIZE, vaddr,
+						 PAGE_SIZE))
+					pr_debug("Failed to write CPUID page back to userspace\n");
+
+				/* PFN is hypervisor-owned at this point, skip cleanup for it. */
+				n_private--;
+			}
+		}
+
+out_unmap:
+		kunmap_local(vaddr);
+		if (ret)
+			break;
+	}
+
+out:
+	if (ret) {
+		pr_debug("%s: exiting with error ret %d, restoring %d gmem PFNs to shared.\n",
+			 __func__, ret, n_private);
+		for (i = 0; i < n_private; i++)
+			WARN_ON_ONCE(host_rmp_make_shared(pfn + i, PG_LEVEL_4K));
+	}
+
+	return ret;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_gmem_populate_args sev_populate_args = {0};
+	struct kvm_sev_snp_launch_update params;
+	struct kvm_memory_slot *memslot;
+	long npages, count;
+	void __user *src;
+	int ret = 0;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
+		 params.gfn_start, params.len, params.type, params.flags);
+
+	if (!PAGE_ALIGNED(params.len) || params.flags ||
+	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
+	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
+		return -EINVAL;
+
+	npages = params.len / PAGE_SIZE;
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
+	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
+
+	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
+				  sev_gmem_post_populate, &sev_populate_args);
+	if (count < 0) {
+		argp->error = sev_populate_args.fw_error;
+		pr_debug("%s: kvm_gmem_populate failed, ret %ld (fw_error %d)\n",
+			 __func__, count, argp->error);
+		ret = -EIO;
+	} else if (count <= npages) {
+		params.gfn_start += count;
+		params.len -= count * PAGE_SIZE;
+		if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+			params.uaddr += count * PAGE_SIZE;
+
+		ret = copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params))
+		      ? -EIO : 0;
+	} else {
+		WARN_ONCE(1, "Completed page count %ld exceeds requested amount %ld",
+			  count, npages);
+		ret = -EINVAL;
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
@@ -2217,6 +2451,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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


