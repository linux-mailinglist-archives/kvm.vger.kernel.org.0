Return-Path: <kvm+bounces-9602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B8C8625C2
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 16:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7FFF1C211C7
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 15:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902824E1C6;
	Sat, 24 Feb 2024 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k8Z5dSS1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073F54E1C5;
	Sat, 24 Feb 2024 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708787231; cv=fail; b=LpJHhop8QJLeqIchuN65SZa+gnkSKRVWCne1BKgeO9nRlJScf9CDwlaqAgb89Wg374TVJ0XOZHLy/c/igKrJBXt4ry4M53rh7YainhCuUU5Y4osA861wj16MlXewWJd0EHT76m3P/iyykGffsONpmJ++3DIrXWMCLX/pbDsHl20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708787231; c=relaxed/simple;
	bh=e0FhdWZczG3jNlJwaIceTYNLqtq7kTP1clVnsfufh/Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CXHExDqyHOM88LQWkwJwZtCVlLgMKDLZQqc5qvwe0AUOVgHRzw3OH6vJQvphYFWt9EDR8Zn7s+9gIGLUPDJ5aMQnky8dnAkmpUdYbYbeeZR5NGHTVkFVGfJSYNM/WpJ5jt4LvTiPfTprNV9v+rrlG0SCQI62JJ9EBDNB68cCcL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k8Z5dSS1; arc=fail smtp.client-ip=40.107.95.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcnfSWyOFQggSiPTsES65PhBheOmwfvj3zgWuTC9GWHqsJ2j2mjY4ZwNU4SJUwhc9x53l1C6biFXWtziQw+WxYDOpWWnrbUjItzDBD1qLLs1+qt5I/FYjojRZmqkBbWNeSP3GebSLtthUIt6fMEGQuv2XuoHLDYl5bztSPdR0p07cciaTEaMvlsIcqUGPRzqf9SHjgZOqDG2ph5IJvqINHVfwYwLG+zMpWW1pu/8nPX8wqe6X0Mc3mUkMJSOVIcBd41zIycC4Dp410PSG9loxEx08tWvvgIOhDb9wk09hEqj0Y9OTmv+0Pda7VgDDmLjZmEu/1Tr4+NVc0swjTgRwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrVed4bH4ZNo5+WAlGpRDDR5GnNw8bBIVXunyFMfGm8=;
 b=imUB0lDCeJbrMEpP74471V1uwXeC6zSjztnlULNvXgyu0dv3ZBz5AKFRnmvIbvzmYKO4kokxcRkX3vtJY9M1eLn54YsvQ3HNr4qUfKV8zwsMG9SlFd3LUqhokzJ4HmZpc4cpI83shk39unNjyXFjFFD4OygZJKHv3+ji6S2n9qKnYeK0QoNx/xZrTnsP4tCURd1GJ39WkVciDPEP2CNlSb5DeRLOl1fxoO9CNaUl1W6mw1kM/Qq7AAvLdD+JMmEcJ6R9AelNZhpNc0E4tQyRrjqt8tynH7EmxphT0QJE3U7oFi8P1uXlzlViBXb2MlaCjwFm66aktIEcKpyznax8CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrVed4bH4ZNo5+WAlGpRDDR5GnNw8bBIVXunyFMfGm8=;
 b=k8Z5dSS1+XZWFfeyb7JtGwpF6xBbsOykuKYdSiI4lG1DjI2pLyD//987TA9VAmaEbOW4OqO7/nuY/0+wLeYfUe9mH7PqW6E9Ndo4XEI5Ycv4naE+HCJyn26NiadmBQZYr0cehi8skRdt2O9W4E+IhZp3sgMmCgu2qjOy748G/qGnEg4iOjTRiF9Z+F5kUUjUqB7oJG95Ow6JasVtqYxlKXRwyL946X4dBBBFPgHl8b30BS+1ZPCRo5MA3NmcgdHB4PmuPJ6eee0pUWyL/7zBuXeGpakWYlI7dtfN8z+lVw2CbkK7sKGkd2p+Eit51cjIaxuyKXh3cI232QcVzrtlDw==
Received: from DM5PR08CA0052.namprd08.prod.outlook.com (2603:10b6:4:60::41) by
 BY5PR12MB5511.namprd12.prod.outlook.com (2603:10b6:a03:1d8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Sat, 24 Feb
 2024 15:07:04 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:4:60:cafe::71) by DM5PR08CA0052.outlook.office365.com
 (2603:10b6:4:60::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.48 via Frontend
 Transport; Sat, 24 Feb 2024 15:07:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Sat, 24 Feb 2024 15:07:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sat, 24 Feb
 2024 07:06:52 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Sat, 24 Feb
 2024 07:06:50 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Sat, 24 Feb 2024 07:06:38 -0800
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
Subject: [PATCH v9 4/4] vfio: Convey kvm that the vfio-pci device is wc safe
Date: Sat, 24 Feb 2024 20:35:46 +0530
Message-ID: <20240224150546.368-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|BY5PR12MB5511:EE_
X-MS-Office365-Filtering-Correlation-Id: a1b01687-e8ad-4423-fd11-08dc354a4307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GxjN7Bwq1Hwv/A/mtDSKWWm4FjbCfLkQvpJEyuKbzX9Y6HdylNrePnfdtgf55bu9XhhbP6bLnOFqWF9i6xaIvdW7BvhuCWgdvoxhyq43q5a7orbA/0bSt95gkrspg2sPSGRrQuzL5mCEwyzmBYEgtTHmsSEm2yH4jU+N+H+Pjfb9EgWy/wHIHVRrvCxzQDccTcqD4WfTgWGZ7b5g38jcfd/asoc8kboPe1C/BMJTk/n8DCAwHf0xjRhCAD09b1KrNMA0zc9kmK5PnNvMmIOa7Vqbbad+RwMFuZDbDYjMg1c2bmomp7ZacCqQquXLOuinEn3dLlssscL0qF6deYGQOwyTIjNFDuib/i7Ld1xpwPEtIczzLZ3ab/KFz3/o8xb5C+5SU7ttaTD93P/ggwca9IGPRjSxe9eFv8JpCZVyzPI6KOoFc5N7KwTJvGunhtl/5QjGRPfMMENd6K4s+dYtIUfPo1ynL2fcxG+v4lMwFRaO/82ttdnhFvM/1JBG+wnMc9JxzTtJqSTtZU+fjzEzIxiOB0jrZEB3lE1XS28DR/fhn/1+MAN4k9ZRLRWUKaQ2yvtvU0QoU/J4u7xe9HnxmV2Q95zJgJbXPfbSbi/7bdKFH6Tlwwc9kS+nhkfk/mmdsaS8elePZESo6uhoynwlMKv7pHgt6TVbfCObTclF/JA=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2024 15:07:04.6499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b01687-e8ad-4423-fd11-08dc354a4307
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5511

From: Ankit Agrawal <ankita@nvidia.com>

The VM_ALLOW_ANY_UNCACHED flag is implemented for ARM64,
allowing KVM stage 2 device mapping attributes to use Normal-NC
rather than DEVICE_nGnRE, which allows guest mappings supporting
write-combining attributes (WC). ARM does not architecturally
guarantee this is safe, and indeed some MMIO regions like the GICv2
VCPU interface can trigger uncontained faults if Normal-NC is used.

To safely use VFIO in KVM the platform must guarantee full safety
in the guest where no action taken against a MMIO mapping can
trigger an uncontained failure. The expectation is that most VFIO PCI
platforms support this for both mapping types, at least in common
flows, based on some expectations of how PCI IP is integrated. So
make vfio-pci set the VM_ALLOW_ANY_UNCACHED flag.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1cbc990d42e0..df6f99bdf70d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1862,8 +1862,25 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	/*
 	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
 	 * change vm_flags within the fault handler.  Set them now.
+	 *
+	 * VM_ALLOW_ANY_UNCACHED: The VMA flag is implemented for ARM64,
+	 * allowing KVM stage 2 device mapping attributes to use Normal-NC
+	 * rather than DEVICE_nGnRE, which allows guest mappings
+	 * supporting write-combining attributes (WC). ARM does not
+	 * architecturally guarantee this is safe, and indeed some MMIO
+	 * regions like the GICv2 VCPU interface can trigger uncontained
+	 * faults if Normal-NC is used.
+	 *
+	 * To safely use VFIO in KVM the platform must guarantee full
+	 * safety in the guest where no action taken against a MMIO
+	 * mapping can trigger an uncontained failure. The assumption is
+	 * that most VFIO PCI platforms support this for both mapping types,
+	 * at least in common flows, based on some expectations of how
+	 * PCI IP is integrated. Hence VM_ALLOW_ANY_UNCACHED is set in
+	 * the VMA flags.
 	 */
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
+			VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vfio_pci_mmap_ops;
 
 	return 0;
-- 
2.34.1


