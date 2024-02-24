Return-Path: <kvm+bounces-9599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4BDC8625BC
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 16:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3140C2826E3
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 15:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2E147A7E;
	Sat, 24 Feb 2024 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KWIgJFKA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6233846448;
	Sat, 24 Feb 2024 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708787208; cv=fail; b=KFWGSWeCAygsZ3diD71DvHSg6vAWR/tYIppoR/qZPg1BWCzVB56z4l54pEjiYwdxLSZQrRyUW5ghUObmVUEKuZsm6bq2FPsY/dpnlMkrymw1XzrYDJDg6lsnFJOU0bUUBk9HHir0r7xLJXSHvnvLcNT1s1MXCrxFcJK2B9EJ90w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708787208; c=relaxed/simple;
	bh=vtNAZRRIQ7AEBOdIlt01kJsP5/rzP1tkZGu58xPi/2o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VBYSBBlVRcqPnowMKu6CdZcIDzxClzAyUMnPq7Dkd5KohruFoyVPBdKXFCJKo3CRBLEVlLi2LWLjKebZLRji6L6bwzDuc8CTFePT24bvbXkNdZsttkWdtdTUVUa8USPqRsyV8Bxvl1hiE9kepZ/oi5YeBmhK+td5+DRVW5Segn4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KWIgJFKA; arc=fail smtp.client-ip=40.107.96.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDf4fv7T1lBTifRrEkxcE9lFwwsVWk/VxSSJoTn/CSyRPJiGM9bCfSc+8oPkaI8ADDwG4gphbqX1L45LAF1z6tWjxAuf3a5DkREnMdTnDMondMdPwogj2WTEipeC9X6XuVPl0gqUrL60D2wQ0LDwlk+HeOrLw/UQD4Jez5CuSb/v7BKDuZAspZewFUAmJDM38vp7F/jD04aBQ9LdeopAXej2DsgH5afoJsxQ7h9xQr6YnEf1BPO+k98qmMHNWIVvY5PAJXXr5QiGzRpJyp5hhSQ3fCxzRB+TeBf1YHfTAJlmunF6mCseH1zRHF944fBhv3erBFpyJXeaPiOkyDkSGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRcaF52CMEO0QVAE1H8FtXam0Yy4RMg+DZcetOMVhQ8=;
 b=AcEN9N4YgN9T5qBSJ+XHE76bfjdsteSDNwPWHMPb4KaB/Eez2pXCbFG7+F7lFr5AZgLyN58hZL7NFSUWHa4alnam6KQ3RfxzZPQ+6nR4ba0qDNF5gt5BvW/DdNrrSXm6oIqZPj56q5nHgXFm1JcVE1UZTTdSD1g3Rv7Sg/7vMSspK2jFe6OV0azxbyBv7LY6sCxYj/Qd5YskVwOkgIYh2UMxnlHlgqsQxKz9I4WEUul8DW5gPRUY+RR717+N/JH47LAAplReQ4utOvXyMFKvPkNY2FXqB5i8u23hrx2KRHckfv0IOocLTNxO1JequSf7Pev1BEBT8f0TnbG+KJV3yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRcaF52CMEO0QVAE1H8FtXam0Yy4RMg+DZcetOMVhQ8=;
 b=KWIgJFKAjq4YPghbcHaSgnZJJjRCDw7gJ8zeBl/xNF+mXimwTgqlMeRl4LR9VfhFI3GiEswvn+FMOwPzgxiyzTi9KSeHAuytOU+SH7M6BhpRDpFv/gqXhWE82Qlo+fGUpZkiRVRr+6PQovoSkGR1hC+pEajdk0J+dwA4xy7DTYfrht68BhvCXHHTLye29174P0UHdFF0IGZNJG9+0LxE5RxaJZFAJ417EjPj1pkn4QyCTyqVm+Nh78CyDEBVcZ+QYrotoLIyv9kbaYWzk5OjUjdAabD9F+yPd6rsRS4WvFc9ihZJZ5ass3j+jXTWrWEhcX1xIUoFIFbGXNw4wL1eOw==
Received: from CH2PR19CA0003.namprd19.prod.outlook.com (2603:10b6:610:4d::13)
 by DM6PR12MB4894.namprd12.prod.outlook.com (2603:10b6:5:209::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.24; Sat, 24 Feb
 2024 15:06:43 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::99) by CH2PR19CA0003.outlook.office365.com
 (2603:10b6:610:4d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.48 via Frontend
 Transport; Sat, 24 Feb 2024 15:06:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Sat, 24 Feb 2024 15:06:43 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sat, 24 Feb
 2024 07:06:26 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Sat, 24 Feb
 2024 07:06:25 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sat, 24 Feb 2024 07:06:14 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <reinette.chatre@intel.com>, <surenb@google.com>,
	<stefanha@redhat.com>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <yi.l.liu@intel.com>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>, <gshan@redhat.com>, <shahuang@redhat.com>,
	<ricarkol@google.com>, <linux-mm@kvack.org>, <lpieralisi@kernel.org>,
	<rananta@google.com>, <ryan.roberts@arm.com>, <david@redhat.com>,
	<linus.walleij@linaro.org>, <bhe@redhat.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kvmarm@lists.linux.dev>, <mochs@nvidia.com>, <zhiw@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v9 2/4] mm: Introduce new flag to indicate wc safe
Date: Sat, 24 Feb 2024 20:35:44 +0530
Message-ID: <20240224150546.368-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240224150546.368-1-ankita@nvidia.com>
References: <20240224150546.368-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|DM6PR12MB4894:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a6cb5b3-b8d0-4c8f-13d7-08dc354a3645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nVrX1apBYdo/a+4PsEVLutRl/RKwgEa/DqzhLB8gwRjIFSeGeZSqMWG+l5LBjyCv5uCMM5Yrf5jJrikHd4W1iiT5gOWFwsOaNS64rlBLoLxKJBdIlrYflrqZ5O5t0THqvWjl79ehf6buiQvYONplBdhwg0gUBe9GqmnAzKsORGO2VEhIt4M4ARz2Dmp8JHB9BMUqNAmnJ1cXoql0Rj7fhiQgbgKnlD5BtTWe8f3f5+oI5rLXRk9d0PrV8STWr1paRjaWGrdKHi6UTwwZYH3Q+6I8Nd7Jorr6wpcqcbNM5MpGB0UnI4IRgu5Tkrcmd2RPzfwxaZFqi6YD+NVCZ/S3Z0s3ZwtVBSbOkagnxAffo8DefNuEbraKPqOFQpSOJxDXKcEjh77GcDMAzEBeKMtGI3F+igtd0D6qv3/yQjjl289mlZM0Bo47hVRLjfdfymE/rr7oQT5s/09MN1hJiGQDyaCEKLp1Pys/TWnAHE/0XUaRPHxi9ymCwuNL3MCbLaKCifiBfIDojuFEoDvpU7fIdoaz/VsWkR4eBec/i1xtPXzOKFT7rGiWIelYG91am0eCwVPx9ScbFKYsYLZuMqAPfAqheBFfjYIMBPrxFt8zICReux2eHC9GnlVhMJ6Qro3/y2fVXShUFHPH05qcXo+jGrPyzCAGrVKu6Ju6YH5UVgw=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2024 15:06:43.0054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a6cb5b3-b8d0-4c8f-13d7-08dc354a3645
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4894

From: Ankit Agrawal <ankita@nvidia.com>

The VM_ALLOW_ANY_UNCACHED flag is implemented for ARM64, allowing KVM
stage 2 device mapping attributes to use NormalNC rather than
DEVICE_nGnRE, which allows guest mappings supporting write-combining
attributes (WC). ARM does not architecturally guarantee this is safe,
and indeed some MMIO regions like the GICv2 VCPU interface can trigger
uncontained faults if NormalNC is used.

Even worse, the expectation is that there are platforms where even
DEVICE_nGnRE can allow uncontained faults in corner cases. Unfortunately
existing ARM IP requires platform integration to take responsibility to
prevent this.

To safely use VFIO in KVM the platform must guarantee full safety in the
guest where no action taken against a MMIO mapping can trigger an
uncontained failure. The assumption is that most VFIO PCI platforms
support this for both mapping types, at least in common flows, based
on some expectations of how PCI IP is integrated. This can be enabled
more broadly, for instance into vfio-platform drivers, but only after
the platform vendor completes auditing for safety.

The VMA flag VM_ALLOW_ANY_UNCACHED was found to be the simplest and
cleanest way to communicate the information from VFIO to KVM that
mapping the region in S2 as NormalNC is safe. KVM consumes it to
activate the code that does the S2 mapping as NormalNC.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/mm.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f5a97dec5169..59576e56c58b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -391,6 +391,20 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_UFFD_MINOR		VM_NONE
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
 
+/*
+ * This flag is used to connect VFIO to arch specific KVM code. It
+ * indicates that the memory under this VMA is safe for use with any
+ * non-cachable memory type inside KVM. Some VFIO devices, on some
+ * platforms, are thought to be unsafe and can cause machine crashes
+ * if KVM does not lock down the memory type.
+ */
+#ifdef CONFIG_64BIT
+#define VM_ALLOW_ANY_UNCACHED_BIT	39
+#define VM_ALLOW_ANY_UNCACHED		BIT(VM_ALLOW_ANY_UNCACHED_BIT)
+#else
+#define VM_ALLOW_ANY_UNCACHED		VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
-- 
2.34.1


