Return-Path: <kvm+bounces-9136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E52CE85B40A
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C5D31F21909
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 07:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8625A7B1;
	Tue, 20 Feb 2024 07:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iQ1Ht/1l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3535A782;
	Tue, 20 Feb 2024 07:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708414270; cv=fail; b=TGBakWCevTppgc19SDtr3mr0CvCaHuctVK21UIHvoF2W8xjS+vYdnXOrADhMTDzGYNGde275ULISlpyIZlV2AJaYtkzBZpz/1c+ZHvl9aEEJY51FLklF6uN67mmpDsHylrPEkrGMEtc/2MphgE02nT78BZTJmTVGP+8hdcWfyUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708414270; c=relaxed/simple;
	bh=9RzRxBfa5I11CfKQeZZtLMvh43L/0jHGEDV2ZzU5hKs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQl4r6z1bcR37AbjmiuZrq0YJcXUEM5onmRPs+U8cw9uhKN7lG7WoXqVQ7wjma5yqOX9bkTcEv/pq0LgUJZHwawXrvp9KgVyEoTKW+NQXHn3wjQ6SnqIPfg8tmywxJRXJRQ+kufvK36wrvO3Hrtw5NySEmf2j22MWBWx9jycSbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iQ1Ht/1l; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hl3lYAmmFABsVsUk1SDzYUkVtZLoj1GgpwcxQOjAPyzsHV0uurKn4hYPQvhSuY7tV4HvE7yIrdx2qerPizygWuTuvj1lXZOkyv3qaThSUE0aNuEsfTz07SEfjLKZ3rTmXkuawA3+aneKswTEdDZKmZ3XqrGRZyoq2PSoQMiQSrbYxctBd2IvlGIbkzqQ2HzxT6iDIpTFLYRqa/zcPbVZc+ba67tgvuIhadXALYMim+QgTxv65+DGUR/JG7sBcy6ulPeBVeaAWJcyJz7LfnKRGGaUGJe05lMk/2qghuDKSdFcmDDY9dzmR4V8BSAuJ5oLBDqAVFLNuB0TOXFhpOFs9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnAqZkcNokEttrDLhF6HxAeD/JKRA/iQvz7b26LJdsc=;
 b=M39CV30MF/HSpEwVRamVqWQFdwS20GHXoJSaAM2p0Zdcr/uPgZDQ/E8+9RHFZnM2TBz7Xrs/lJXKzwR79AZYNeHS/dqnwvN+ivOjtnetM0Kgf9D0IoxxB08b7+BMCwGKeCwnibu3RyIBgb5RJgLbZ3hRDwAMUaycfeBLJEUXQveMm9tzePqRVc6Uy24/OO0AFL7Qz6+c78nZaKgspSXG05nOLl8ljWy9+vvnC+1j1/fIfHORzD8tzHXRU/y4csk9yBTwN20A1P3pkSpGMgUsY7wBXdFmLfpi+lFHbjJfLr0a1Exg11/D0pnQo70lgSUYZxOgrf1W0AaH3s/RM9KbOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnAqZkcNokEttrDLhF6HxAeD/JKRA/iQvz7b26LJdsc=;
 b=iQ1Ht/1lVZO8OZto6mOfBzOWGopZqaI5KTESNGP3TecPcSBOFNfBokJW6Xkd3SI0XMOOhAd3FBWMazX72IRXe4edWZOT1bdVk2Pa17LhNB3b/VZyA0RLtFNIRANprPwdfvXYETSskBEqfkFoeitg2AkE+lR48cwDldLA9uGE65wwYDuT9ALIDEjkCIcOG38Y2D4EVnfijMrecyxd09yS58Ck+JSaYIAza9GruN1+sWXZloMTFMuFT6HLRCXhlMOGqtKj2MeyVQGvgG1OhxcrXJfncTDVrmMvyqUG3hjntrNile3EGnjM+l0zj5WamvrDwKEINHYePAW54si3+OYHHQ==
Received: from CYXPR02CA0078.namprd02.prod.outlook.com (2603:10b6:930:ce::16)
 by CO6PR12MB5490.namprd12.prod.outlook.com (2603:10b6:303:13d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Tue, 20 Feb
 2024 07:31:06 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:930:ce:cafe::c4) by CYXPR02CA0078.outlook.office365.com
 (2603:10b6:930:ce::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39 via Frontend
 Transport; Tue, 20 Feb 2024 07:31:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Tue, 20 Feb 2024 07:31:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 19 Feb
 2024 23:30:37 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 19 Feb
 2024 23:30:37 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 19 Feb 2024 23:30:24 -0800
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
Subject: [PATCH v8 4/4] vfio: convey kvm that the vfio-pci device is wc safe
Date: Tue, 20 Feb 2024 12:59:26 +0530
Message-ID: <20240220072926.6466-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240220072926.6466-1-ankita@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|CO6PR12MB5490:EE_
X-MS-Office365-Filtering-Correlation-Id: ca6f1e37-2f67-42b9-2cc3-08dc31e5e61d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZPxQ8GbEkSvLOBerMzuGU69zQzy7PyYzNBC7d6g2WxpR9tao6hI77HbWfD2eEuu2k3TWrJ4HWzvHb9S4OLYHTJBUq2N/+FhdP7+bAnGZ5V0prD65XoFnqDMO1fCa5DmV2qZWBhDhU1aEY9z++Cu5+8J0hbE4J9+tjzzN6ghurQP/NMqCDU/ed9QR+vFckQAhnAfH5VAM+tTy464XkWX+UCKLlotcT+dZpMpeRh8oLe29A83EpMjj82LEPPiQ6dtJIWonyofQ48pcls5BR7Pomap/yf+ZsLSS3h2BPknECLU0iCG17AVE5rCNRUQmVwoDL9b71TN23kVdXE2Jq/YhCylFK7ztV8M+t3dadu7+unyYP2c5ORQ/r9jHoKA7rEM59LzCTSQAFytXelNOrFvpFOR6piyBmYyasXCWL74Z17o/7AIWXj0Pv/L7Ul1Hj7ZySgup/eulIMJ2tiNqVngTu0jS1bRTe7SVDTPCB8I7rHIP36i3hpUTZEUmsExgVfwaENjx+QHqLgBVL9Zz7Jn4GSi6RyMNKadKoFZNDHtKCp69oRvsrJEBrS8DWlVXoc87uux9Pb0Uu/SaACnnhS1yjF48g5m2rMjFQjYWONvmoQ327VGzZwqxMsyoozH6qKMdY1kbA4qrKSOYKag6blLUvGIYNoTLjn4k1TpCFXfy7tg=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(46966006)(40470700004)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 07:31:05.5367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6f1e37-2f67-42b9-2cc3-08dc31e5e61d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5490

From: Ankit Agrawal <ankita@nvidia.com>

The VM_ALLOW_ANY_UNCACHED flag is implemented for ARM64,
allowing KVM stage 2 device mapping attributes to use Normal-NC
rather than DEVICE_nGnRE, which allows guest mappings
supporting combining attributes (WC). ARM does not architecturally
guarantee this is safe, and indeed some MMIO regions like the GICv2
VCPU interface can trigger uncontained faults if Normal-NC is used.

To safely use VFIO in KVM the platform must guarantee full safety
in the guest where no action taken against a MMIO mapping can
trigger an uncontained failure. We belive that most VFIO PCI
platforms support this for both mapping types, at least in common
flows, based on some expectations of how PCI IP is integrated. So
make vfio-pci set the VM_ALLOW_ANY_UNCACHED flag.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1cbc990d42e0..c93bea18fc4b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1862,8 +1862,24 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	/*
 	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
 	 * change vm_flags within the fault handler.  Set them now.
+	 *
+	 * VM_ALLOW_ANY_UNCACHED: The VMA flag is implemented for ARM64,
+	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
+	 * rather than DEVICE_nGnRE, which allows guest mappings
+	 * supporting combining attributes (WC). ARM does not
+	 * architecturally guarantee this is safe, and indeed some MMIO
+	 * regions like the GICv2 VCPU interface can trigger uncontained
+	 * faults if Normal-NC is used.
+	 *
+	 * To safely use VFIO in KVM the platform must guarantee full
+	 * safety in the guest where no action taken against a MMIO
+	 * mapping can trigger an uncontained failure. We belive that
+	 * most VFIO PCI platforms support this for both mapping types,
+	 * at least in common flows, based on some expectations of how
+	 * PCI IP is integrated. So set VM_ALLOW_ANY_UNCACHED in VMA flags.
 	 */
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
+			VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vfio_pci_mmap_ops;
 
 	return 0;
-- 
2.34.1


