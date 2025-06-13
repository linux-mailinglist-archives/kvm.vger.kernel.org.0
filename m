Return-Path: <kvm+bounces-49350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2813AD7FE3
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A49121E1F7D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88FA1DACA7;
	Fri, 13 Jun 2025 00:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pqReFbiJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D581CDFD4;
	Fri, 13 Jun 2025 00:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749776234; cv=fail; b=iFJLqRUAu6UoBAMgaIFy2V24QRdUzUWFlZzcx15EcbkS3avWSXGj27QQWASWgw5UjNWVYeYhhY4iQU8aDItVZ5P+/48cr0HiHVAJnqiwUeqwL58OgFEe4qeC3pce2IjhGlTAIkILEDE6FRgfEmMah+Nl9725m90/uDVe10dzwu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749776234; c=relaxed/simple;
	bh=Z5xrTxphxd/wqzxCxS98+TykdekWtcvM48A8SGzKilo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qMBDiQ8yiyF08BiDSV0X3oI5rmxTP5F7qDRhphp0F3/dVpOhk66OZvmIoe1BtmGQDE3GTCLrH1UZtUH3CzxaoH9+S7h6JNVbhwcPnSj6SaokUWv/9rO4SOP7h7OOcH3cCrfhmH817PO0ZZ93EZRcBtygReYty2PPMA9YB9O0fvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pqReFbiJ; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lR/UVPs3tF78Z5X1b57pqFroLql74xpSHIpP8dtTRZ+72HmKfQNu1LFyc86EnSIhqDdC69ASDw2i5FRKUpY/i3/5+NjyNBkbuYPDbBrHgJu7ES6F+X7UIhpnJU7XyaJwBdGzVC/ATm7gJ9oPhE/OhefKOJAHLy462LO2Cu5bq28R1XQm2qKKg6SQTLhy/ofB3qSsudwfa1qdD51NMS/wpQr06IpwbtdNwlY0Qf479bU8WLVpNICCkUL8kL+cfrb3KQXp0eaN4n9IGxIIl825RcQuejTX5nUEmkKl+5A8Y0LCeC2Y6jXsAA+8RdtFhwq2tAwimBSLhb8P//MiZUcibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAZzbD9j3n8HWY3PrqVrnzusGcum50ZsLzNdeyLkIGI=;
 b=Ju9H2a11j7p13DXVpt/sh1zGIsDFPj8iZTDYRWct6Q/PN6ETcAyjnBJacAjWM9lVFg8weFEWFrl0UR60CcbHljKs7zv1MpH+4z2e4MebEDmPnPgpuVEKUuNui3gNTb/Unk7PUMLxE5q+8ksEd2tcm+bRg0NPGZ1WbXLJZ7PUgp/S222VhyEylEZ0imglTvC7HpZZoz32BOSlqXimV1nEizGcREtmh5/i2V09uwZY9QsSbDnEFUqmE/6Ub69+pMRIxPFM38IKUkcpaH75GSKjRWeBWt9aFHRLvWKI9xTqn/ctgLgDVlu/7RvuH61kQ2fGMHrHvhP/j52FyXKtR7ayrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAZzbD9j3n8HWY3PrqVrnzusGcum50ZsLzNdeyLkIGI=;
 b=pqReFbiJQc2zJLI/P/3Q6i1bFFjBB3DMA18NqzMNKJHRGQcLUfrsUJc1ome9qjPvciatyJ9cmss1zROLgpnvkrqd3UiHthDRPultfECJD9w9tc7wXlGawhDQUR4FbkHJg+H+tiiXTe5D8ubffMZswbvwoE80HfSm+FiZnzFRNWM=
Received: from SJ0PR05CA0106.namprd05.prod.outlook.com (2603:10b6:a03:334::21)
 by DS4PR12MB9660.namprd12.prod.outlook.com (2603:10b6:8:281::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Fri, 13 Jun
 2025 00:57:08 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:334:cafe::de) by SJ0PR05CA0106.outlook.office365.com
 (2603:10b6:a03:334::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.25 via Frontend Transport; Fri,
 13 Jun 2025 00:57:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 00:57:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 19:57:05 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <ira.weiny@intel.com>,
	<thomas.lendacky@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vbabka@suse.cz>, <joro@8bytes.org>, <pratikrajesh.sampat@amd.com>,
	<liam.merwick@oracle.com>, <yan.y.zhao@intel.com>, <aik@amd.com>
Subject: [PATCH RFC v1 5/5] KVM: SEV: Make SNP_LAUNCH_UPDATE ignore 'uaddr' if guest_memfd is shareable
Date: Thu, 12 Jun 2025 19:54:00 -0500
Message-ID: <20250613005400.3694904-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250613005400.3694904-1-michael.roth@amd.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|DS4PR12MB9660:EE_
X-MS-Office365-Filtering-Correlation-Id: 009874e5-a210-4d96-c938-08ddaa1538f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bLA63iJkwiYyrnc8nk8CjZG26aptUYvvkcfj/dqAiTudZSGMSTZU5ieXhKA3?=
 =?us-ascii?Q?BLFTRKZZC1RZGtCta9BZRwpgVftBwBxCKMd6nO5Dwv2x698KNEbjbMlZk6WW?=
 =?us-ascii?Q?197uBlrN7bakTr8YPD+QdVAJxUwkErj1SRyFwGRVPdg8TJtFt17K14FyxqNh?=
 =?us-ascii?Q?x2qzCqLwQBGBMb066Ajz9OG9jrqjgnJk5/pL/mQvWUSPIeWLiU/xGf6vvD1/?=
 =?us-ascii?Q?KfMZEIz1ISI+TWUdizrFCFnB02fKvlvQWAI0RKcP+Ti/472aVhIi+iRa+xiy?=
 =?us-ascii?Q?CDPE/70w+BzDlX1ItlDvHk6aG017wzN3Jh2d2gXt9NHBmV9tAQ6Lcjgy4AkO?=
 =?us-ascii?Q?A+N65M+dxDW1UCT88+Qt/waIhNSqsB776v1vcYJfo/43KzwDD/CFnxxLfnpX?=
 =?us-ascii?Q?KLsfWt7LHb2pwZGmiGApqCslHdJvtHX2kQylMs0ZTJyXwYtZjB4x0FCLbyIN?=
 =?us-ascii?Q?nKxZZjeaL83wXRHB6C+DXIBVG/paLpsWcMXjcqgpEmqr8UD0ORITWnMQMJEg?=
 =?us-ascii?Q?iszY2D6F5eCi2x1S0FTF1Bicw/ZYMhO/ceNPsPl4AXsFXFJepOCd+xlDGVbD?=
 =?us-ascii?Q?N7nI+cNYs5NET5tPGq0d9Wk9Y8mNeYCr/DobyHNnz+pfmTpQ6DdB141aZp9o?=
 =?us-ascii?Q?9mX9MT91C/RwiPPDv2DyebxwLTTG+0keneMTXUTcN+Eqbj8vsj/7OvWLnz88?=
 =?us-ascii?Q?VNgY9g6NVtT6IIVRj2aB/5veTNlQ3I/+V7KjzUR7TFtB/BKsosWlZe6lTzzy?=
 =?us-ascii?Q?OKjxiCf8zc6le0/BFy7I3BIkOw/6kCUN/eUWvsLU13dUi8yeCwWC+6+nuhAx?=
 =?us-ascii?Q?8R/BIgTdgr+lXbrBQyTtiPIwbg6yfXfvgVZNEQ58hhBMzdTedHA6hDhZEZQt?=
 =?us-ascii?Q?F/3bwwkNWg7Zwo0CGizOlsN4Mr4UP1g455tC+wdiJvAUnGvOmp4eDMee0CQN?=
 =?us-ascii?Q?o5RCjeBAcGd5rThjpSa/Gd2eqICQBS27gyYLx5aK7esvgQEvSiGWkEqHhS6M?=
 =?us-ascii?Q?B4CZSwlMGi+OHUhmI6iNmd6f1ie0m5gTzrmveuuSEvA9Piqf3ESa5s9U5tjO?=
 =?us-ascii?Q?x9zKd9pWWe8+lSeQdhO7hB7/3pMAsAWidgQpLsPQliJXXlz93V7k+rzC1Gg9?=
 =?us-ascii?Q?niq+CPSHdKHAtV7xilbu0W6+f/X5lcOji2uMF4sTiLku/1+jC5zGTORdn68X?=
 =?us-ascii?Q?eysQprnU4P5JHalzWysizooikYKu1PFzK75NeuE36Hbh5JNdm/eYhvLzZ0bh?=
 =?us-ascii?Q?8wej5ISroypQGUeEKNv2fTxFiG8z8c7WlGQ+tmZjLpbR5L+sXvCXmc/1jCom?=
 =?us-ascii?Q?LdfgCNVGemPWRx73XJKqqSi3EdbLf16syaxKYC4PM9QQOMwGHyE0KwVQ/joK?=
 =?us-ascii?Q?KFWAQgijER09ZqXJbDyABzHT1/XqVvUWAHsIQL48C2vIsP7h6Ys+kVTNFu3S?=
 =?us-ascii?Q?paWO3lNmjSFmrbp0ktp7oxIoiwZkko2cLNqXhF9qx1A/+5SvgCmzKpTT+C61?=
 =?us-ascii?Q?LKDD8T7SrJqOC7k9T49v0opQAZXj/7MXh5HI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 00:57:08.1728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 009874e5-a210-4d96-c938-08ddaa1538f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9660

There is no need to copy in the data for initial guest memory payload
in the case of shareable gmem instances since userspace can just
initialize the contents directly. Ignore the 'uaddr' parameter in cases
where KVM_MEMSLOT_SUPPORTS_SHARED is set for the GPA's memslot.

Also incorporate similar expectations into kvm_gmem_populate() to avoid
dealing with potential issues where guest_memfd's shared fault handler
might trigger when issuing callbacks to populate pages and not know how
to deal the index being marked as private.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst         |  4 +++-
 arch/x86/kvm/svm/sev.c                             | 14 ++++++++++----
 virt/kvm/guest_memfd.c                             |  8 ++++++++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..399b331a523f 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -513,7 +513,9 @@ calling this command until those fields indicate the entire range has been
 processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
 range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
 buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
-``uaddr`` will be ignored completely.
+``uaddr`` will be ignored completely. If the guest_memfd instance backing the
+GFN range has the GUEST_MEMFD_FLAG_SUPPORT_SHARED flag set, then ``uaddr`` will
+be ignored for all KVM_SEV_SNP_PAGE_TYPE_*'s.
 
 Parameters (in): struct  kvm_sev_snp_launch_update
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ed85634eb2bd..6e4473e8db6d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2174,6 +2174,7 @@ struct sev_gmem_populate_args {
 	__u8 type;
 	int sev_fd;
 	int fw_error;
+	bool gmem_supports_shared;
 };
 
 static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
@@ -2185,7 +2186,8 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 	int npages = (1 << order);
 	gfn_t gfn;
 
-	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
+	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+			 !sev_populate_args->gmem_supports_shared && !src))
 		return -EINVAL;
 
 	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
@@ -2275,7 +2277,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	struct kvm_sev_snp_launch_update params;
 	struct kvm_memory_slot *memslot;
 	long npages, count;
-	void __user *src;
+	void __user *src = NULL;
 	int ret = 0;
 
 	if (!sev_snp_guest(kvm) || !sev->snp_context)
@@ -2326,7 +2328,10 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev_populate_args.sev_fd = argp->sev_fd;
 	sev_populate_args.type = params.type;
-	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
+	sev_populate_args.gmem_supports_shared = kvm_gmem_memslot_supports_shared(memslot);
+
+	if (!kvm_gmem_memslot_supports_shared(memslot))
+		src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
 
 	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
 				  sev_gmem_post_populate, &sev_populate_args);
@@ -2338,7 +2343,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	} else {
 		params.gfn_start += count;
 		params.len -= count * PAGE_SIZE;
-		if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+		if (!kvm_gmem_memslot_supports_shared(memslot) &&
+		    params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
 			params.uaddr += count * PAGE_SIZE;
 
 		ret = 0;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a912b00776f1..309455e44e96 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1462,6 +1462,14 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			}
 		} else {
 			max_order = 0;
+
+			/*
+			 * If shared memory is available, it is expected that
+			 * userspace will populate memory contents directly and
+			 * not provide an intermediate buffer to copy from.
+			 */
+			if (src)
+				return -EINVAL;
 		}
 
 		p = src ? src + i * PAGE_SIZE : NULL;
-- 
2.25.1


