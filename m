Return-Path: <kvm+bounces-27220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0B297DA91
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:35:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C8B31F225A8
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02EBD18CC11;
	Fri, 20 Sep 2024 22:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lVzDf+oe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0397136341;
	Fri, 20 Sep 2024 22:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871714; cv=fail; b=OQUTxxMl2l0+Jxsra+wPh3Cf40X9G9y877DWEdua/wPP4XijIbNRLF4imQoMvzSLNliKhtakZR2QF8Y50eLwttJb2NY5UGoZlS3p9yKiaUfKettrZqnj4UtGoozkcq+85YrFviKsM/jZZNuutevJ+GuBi9ACLkMNGpDLo1tsl0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871714; c=relaxed/simple;
	bh=PmghE8EF4D/P6wqeWfPbQmzWGuHPIdPCJyNVdpJeWQc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=djZks0vaS2ELMAHog85vCdkvAfzLQwt9al3fI+KX8NsMMC/e5GnWD/OXjMAmwG8tCgW/ZSGM08OvzT2YbFlmzb4Oizef0s4br5GQbwZRN9lWnrO3eTBDO5BsL81HgMuguXRz+8PE8+V/yTywGAx1xIIQuTKV/YHtcaa63MpnTHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lVzDf+oe; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x9ynmaagbmnycA4ejNmuEMtDsW5WmEsazV8E0cgIZGDLE2ZjCUxnLIdd7hCIGVGoZhS1p0M8j8Vzone0pA5rzrY+oO+zvrihYR9nMgrHutKa8aGGxkdRH8iryYrSmGOaWEqMbL6IEG6R3Crv02ww6S+dHr4LNCWAm3MJDCV0C3+R6hDteovrjmP/X6VFYAhi6nkKynoq37uIf1psPIOrVpLjlQwVqLSOCAYyPpMCqzrkdWf8mMdWubKN3t7ZerYRqcyGl4KdRQAaJfuV70JUr8IjwtXLyjlEOuCjeUo0Ryj7oxwp+r/s1JrdGcnFDuI5bAMLxTffr7xIl2VPevZJ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJX1O3hPIB9f0XoO+MZTauO3or+zr8Cbelv1Fzu77uA=;
 b=DS458aYIARsUOnA6gjUsfHjDUuVnScucImAU074EAD+0KUzJ/Bu+EiPR1/b3JyzcUlq01C+7NdhCu7MjQlb8nZoUgJZUUQbTW9ErZJmlReao3EkR1bMszoj4md2t8dDZ92gYJfR1lDanJF7meZFPfTQ7MLoU9ucnOhTb28RL7CiQpjrFgnXKJeg6TAcQlvAbPqoCP6ut846iIJ0cRExO0OlJmHq8vJflW+ETTX9YP2oJFdf/EwfcUkqWWEtkWnd1XcVrZHqE7tFudx2za3ujRC7FPMQ4MElvX4pfEtCN8nW22D8r0DzaG5O3b/CqUJaqYhEwKxOrcJxwTXhie4PgMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJX1O3hPIB9f0XoO+MZTauO3or+zr8Cbelv1Fzu77uA=;
 b=lVzDf+oenxVyVXakkRXDBD4CYXCIC0vDU4GKNPJ287tlR6NTX8sNTb+pERa4J0VGjSdgHjMdSF1SunnCoJn6gDq6JyIY50PXqJAE+tPI8Q/RfYaI4zvqoDwFg03VkP1PzP3fa1vTAAsIGfP0ZBGVJN1V3MTFanx0/FCmmYvuHXgWwARFvdm9Ali7dCqB4jeJ+i9suieoHsZ4aA+h7CbxEua7lv60hpHOitytMcd3x3fPCoqcJ2PiITxtkryzy5jRnQgmViqDYEq5d5s89alzSAEe+QvEv5D9vafGHrOvJiKTcffDuxdyneR7EMMKbELHktD998TLPyc7jjD+65WzZg==
Received: from DM6PR02CA0160.namprd02.prod.outlook.com (2603:10b6:5:332::27)
 by PH8PR12MB7279.namprd12.prod.outlook.com (2603:10b6:510:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.21; Fri, 20 Sep
 2024 22:35:06 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:5:332:cafe::d1) by DM6PR02CA0160.outlook.office365.com
 (2603:10b6:5:332::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.29 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:51 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:50 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:34:50 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2 accelerator passthrough
Date: Fri, 20 Sep 2024 15:34:33 -0700
Message-ID: <20240920223446.1908673-1-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|PH8PR12MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ba25f6-82b1-4c67-370e-08dcd9c47a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I7v+6DHmsWGFhIdnDvilpqOqgq0matWTy6eycfYsEF6WNzhqfMHKdYm52wSz?=
 =?us-ascii?Q?j9JRA5iPlOtZj2LhN8VKq9q2GPjOZ/zpQOA2c91aOu3JJQBvIuAF5GE8wuu3?=
 =?us-ascii?Q?ZXAibJevhEIker/bV5m2tTCyAf2qlpK9VMiwHhLbQv+pf4wmc7aCwcMZBznP?=
 =?us-ascii?Q?da1NXVHYJ8CxxISxsih2skHYb9QS1mBUg8WdOBNX2i4Co5Y6ebSmWTi9uwqZ?=
 =?us-ascii?Q?hpwCZMbi1aep1N4ce28pUwvn1/J4FWQsk02IPpSyRnWAkpQogaM3BXBCla88?=
 =?us-ascii?Q?VFSJ7atD9XXx48H7kMx+3+9l2s3aJtzBkCCZgtkq8bAwYFKHXvguLJ9u23rl?=
 =?us-ascii?Q?s2GyPympodja0L++u4ZkmBWxl11Cu4/fuY1TygpPsDKGad/ywPagfgiTVmCQ?=
 =?us-ascii?Q?duBWDg5ECzrcKx2Ct6bs+3K7xbeMQGStr2bUHNB4htHmTMjtMSK6m5lN3f/J?=
 =?us-ascii?Q?nGCOEvbBRv5E0NpADEuk4CM91KEnpe39w+ELnKVINkoLJMEmPKOo7ny3Iab2?=
 =?us-ascii?Q?ss+JzJyEKI9BKB/am/udicVOKi2hC06p2sKTokb9v21U0NRJ5/oChD+9BohO?=
 =?us-ascii?Q?IHdn0ksFVsLXGfMUoe9vS2ZHvC4YC9nlty+8ea2paKcG5y+apkUAdFGShcCx?=
 =?us-ascii?Q?UVwI9pZHfUp8ujAnYvfuuc0SX/NQ7uyZV070qVKdNmEoCXS63BrCvhwqrTdy?=
 =?us-ascii?Q?81CZL/ulLHNvRUpw9yGfGmKah6FmqabL6WVyJlbzDzDEV8IrMx0irnc7PYMu?=
 =?us-ascii?Q?hlFvAqejxLUJ1foA6dwuaJO41BzwGTEka5melQD0MjZRV4JDjUGRHpYwishX?=
 =?us-ascii?Q?P1czgfwpjPxxbG29q3mZHTe3Ain5arjjpbVBF4mLqFUFIsyGiPFItvhxnGRm?=
 =?us-ascii?Q?d5MBUtA7vYNpkW/NKAxFLBgWqL9xBni0bkg6Hnk647uUgR4wkK77XRtrk65S?=
 =?us-ascii?Q?XWsbZvz54uu6oaRv11REHEEMadugAzb8vuvz9T/un3yNf/pfysCChZz7yPPA?=
 =?us-ascii?Q?hYerWOMHy9FboxeQ/9M7TOJicqWR5mX46g2U2x/+h42yHXYkD0oIL5vY2HgW?=
 =?us-ascii?Q?OeWAiLUi+URFqVb5E8PV9zSBwCxskf69aMnNKoDJRMkvYsnbmUmTQXtur2pG?=
 =?us-ascii?Q?EN3M/3McJ5nwFnNjnvlJeOQ3unOrjy5Vq8/NfT9Lx1vxomh2ANOW7B4Um+Xd?=
 =?us-ascii?Q?rL6E+3KPCTFyGx7wh5HPBU3VPsV3rR9nEQWmiQkeCrWNRm9Jye7nfhh4rH0t?=
 =?us-ascii?Q?P0j3J2I/DkOTx/k+YZqBmKMcJH2OjQAyfGXUrjGma3hQHfVDbMJ3gIDZFPSG?=
 =?us-ascii?Q?xPGfHqJibs5yHcKZiKqYcjczq5iSfpaxkWLljBaLBb/1sRMF+3wYmK8VUrzm?=
 =?us-ascii?Q?qAueSXLvP1Aw4Lm2nfzf50DewY0l7FRWWuVUwsAs49cYo571WnWK75QMyfZ0?=
 =?us-ascii?Q?1g0vqcNPAiJUkw6ZtNfBGhFVJ5wKakwd?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:06.3258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ba25f6-82b1-4c67-370e-08dcd9c47a13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7279

Hi folks:

As promised in the LPC, here are all you need (patches, repos, guiding
video, kernel config) to build a environment to test the vfio-cxl-core.

Thanks so much for the discussions! Enjoy and see you in the next one.

Background
==========

Compute Express Link (CXL) is an open standard interconnect built upon
industrial PCI layers to enhance the performance and efficiency of data
centers by enabling high-speed, low-latency communication between CPUs
and various types of devices such as accelerators, memory.

It supports three key protocols: CXL.io as the control protocol, CXL.cache
as the cache-coherent host-device data transfer protocol, and CXL.mem as
memory expansion protocol. CXL Type 2 devices leverage the three protocols
to seamlessly integrate with host CPUs, providing a unified and efficient
interface for high-speed data transfer and memory sharing. This integration
is crucial for heterogeneous computing environments where accelerators,
such as GPUs, and other specialized processors, are used to handle
intensive workloads.

Goal
====

Although CXL is built upon the PCI layers, passing a CXL type-2 device can
be different than PCI devices according to CXL specification[1]:

- CXL type-2 device initialization. CXL type-2 device requires an
additional initialization sequence besides the PCI device initialization.
CXL type-2 device initialization can be pretty complicated due to its
hierarchy of register interfaces. Thus, a standard CXL type-2 driver
initialization sequence provided by the kernel CXL core is used.

- Create a CXL region and map it to the VM. A mapping between HPA and DPA
(Device PA) needs to be created to access the device memory directly. HDM
decoders in the CXL topology need to be configured level by level to
manage the mapping. After the region is created, it needs to be mapped to
GPA in the virtual HDM decoders configured by the VM.

- CXL reset. The CXL device reset is different from the PCI device reset.
A CXL reset sequence is introduced by the CXL spec.

- Emulating CXL DVSECs. CXL spec defines a set of DVSECs registers in the
configuration for device enumeration and device control. (E.g. if a device
is capable of CXL.mem CXL.cache, enable/disable capability) They are owned
by the kernel CXL core, and the VM can not modify them.

- Emulate CXL MMIO registers. CXL spec defines a set of CXL MMIO registers
that can sit in a PCI BAR. The location of register groups sit in the PCI
BAR is indicated by the register locator in the CXL DVSECs. They are also
owned by the kernel CXL core. Some of them need to be emulated.

Design
======

To achieve the purpose above, the vfio-cxl-core is introduced to host the
common routines that variant driver requires for device passthrough.
Similar with the vfio-pci-core, the vfio-cxl-core provides common
routines of vfio_device_ops for the variant driver to hook and perform the
CXL routines behind it.

Besides, several extra APIs are introduced for the variant driver to
provide the necessary information the kernel CXL core to initialize
the CXL device. E.g., Device DPA.

CXL is built upon the PCI layers but with differences. Thus, the
vfio-pci-core is aimed to be re-used as much as possible with the
awareness of operating on a CXL device.

A new VFIO device region is introduced to expose the CXL region to the
userspace. A new CXL VFIO device cap has also been introduced to convey
the necessary CXL device information to the userspace.

Patches
=======

The patches are based on the cxl-type2 support RFCv2 patchset[2]. Will
rebase them to V3 once the cxl-type2 support v3 patch review is done.

PATCH 1-3: Expose the necessary routines required by vfio-cxl.

PATCH 4: Introduce the preludes of vfio-cxl, including CXL device
initialization, CXL region creation.

PATCH 5: Expose the CXL region to the userspace.

PATCH 6-7: Prepare to emulate the HDM decoder registers.

PATCH 8: Emulate the HDM decoder registers.

PATCH 9: Tweak vfio-cxl to be aware of working on a CXL device.

PATCH 10: Tell vfio-pci-core to emulate CXL DVSECs.

PATCH 11: Expose the CXL device information that userspace needs.

PATCH 12: An example variant driver to demonstrate the usage of
vfio-cxl-core from the perspective of the VFIO variant driver.

PATCH 13: A workaround needs suggestions.

Test
====

To test the patches and hack around, a virtual passthrough with nested
virtualization approach is used.

The host QEMU emulates a CXL type-2 accel device based on Ira's patches
with the changes to emulate HDM decoders.

While running the vfio-cxl in the L1 guest, an example VFIO variant
driver is used to attach with the QEMU CXL access device.

The L2 guest can be booted via the QEMU with the vfio-cxl support in the
VFIOStub.

In the L2 guest, a dummy CXL device driver is provided to attach to the
virtual pass-thru device.

The dummy CXL type-2 device driver can successfully be loaded with the
kernel cxl core type2 support, create CXL region by requesting the CXL
core to allocate HPA and DPA and configure the HDM decoders.

To make sure everyone can test the patches, the kernel config of L1 and
L2 are provided in the repos, the required kernel command params and
qemu command line can be found from the demostration video.[5]

Repos
=====

QEMU host: https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-host
L1 Kernel: https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l1-kernel-rfc
L1 QEMU: https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-l1-rfc
L2 Kernel: https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l2

[1] https://computeexpresslink.org/cxl-specification/
[2] https://lore.kernel.org/netdev/20240715172835.24757-1-alejandro.lucero-palau@amd.com/T/
[3] https://patchew.org/QEMU/20230517-rfc-type2-dev-v1-0-6eb2e470981b@intel.com/
[4] https://youtu.be/zlk_ecX9bxs?si=hc8P58AdhGXff3Q7

Feedback expected
=================

- Archtiecture level between vfio-pci-core and vfio-cxl-core.
- Variant driver requirements from more hardware vendors.
- vfio-cxl-core UABI to QEMU.

Moving foward
=============

- Rebase the patches on top of Alejandro's PATCH v3.
- Get Ira's type-2 emulated device patch into upstream as CXL folks and RH
  folks both came to talk and expect this. I had a chat with Ira and he
  expected me to take it over. Will start a discussion in the CXL discord
  group for the desgin of V1.
- Sparse map in vfio-cxl-core.

Known issues
============

- Teardown path. Missing teardown paths have been implements in Alejandor's
  PATCH v3. It should be solved after the rebase.

- Powerdown L1 guest instead of reboot it. The QEMU reset handler is missing
  in the Ira's patch. When rebooting L1, many CXL registers are not reset.
  This will be addressed in the formal review of emulated CXL type-2 device
  support.

Zhi Wang (13):
  cxl: allow a type-2 device not to have memory device registers
  cxl: introduce cxl_get_hdm_info()
  cxl: introduce cxl_find_comp_reglock_offset()
  vfio: introduce vfio-cxl core preludes
  vfio/cxl: expose CXL region to the usersapce via a new VFIO device
    region
  vfio/pci: expose vfio_pci_rw()
  vfio/cxl: introduce vfio_cxl_core_{read, write}()
  vfio/cxl: emulate HDM decoder registers
  vfio/pci: introduce CXL device awareness
  vfio/pci: emulate CXL DVSEC registers in the configuration space
  vfio/cxl: introduce VFIO CXL device cap
  vfio/cxl: VFIO variant driver for QEMU CXL accel device
  vfio/cxl: workaround: don't take resource region when cxl is enabled.

 drivers/cxl/core/pci.c              |  28 ++
 drivers/cxl/core/regs.c             |  22 +
 drivers/cxl/cxl.h                   |   1 +
 drivers/cxl/cxlpci.h                |   3 +
 drivers/cxl/pci.c                   |  14 +-
 drivers/vfio/pci/Kconfig            |   6 +
 drivers/vfio/pci/Makefile           |   5 +
 drivers/vfio/pci/cxl-accel/Kconfig  |   6 +
 drivers/vfio/pci/cxl-accel/Makefile |   3 +
 drivers/vfio/pci/cxl-accel/main.c   | 116 +++++
 drivers/vfio/pci/vfio_cxl_core.c    | 647 ++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c  |  10 +
 drivers/vfio/pci/vfio_pci_core.c    |  79 +++-
 drivers/vfio/pci/vfio_pci_rdwr.c    |   8 +-
 include/linux/cxl_accel_mem.h       |   3 +
 include/linux/cxl_accel_pci.h       |   6 +
 include/linux/vfio_pci_core.h       |  53 +++
 include/uapi/linux/vfio.h           |  14 +
 18 files changed, 992 insertions(+), 32 deletions(-)
 create mode 100644 drivers/vfio/pci/cxl-accel/Kconfig
 create mode 100644 drivers/vfio/pci/cxl-accel/Makefile
 create mode 100644 drivers/vfio/pci/cxl-accel/main.c
 create mode 100644 drivers/vfio/pci/vfio_cxl_core.c

-- 
2.34.1


