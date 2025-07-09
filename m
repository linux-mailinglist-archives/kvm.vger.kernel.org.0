Return-Path: <kvm+bounces-51975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B67E3AFECCB
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:56:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFD8A1888DF9
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402852EA172;
	Wed,  9 Jul 2025 14:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D9aH8DRY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA512E9ECC;
	Wed,  9 Jul 2025 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072762; cv=fail; b=mbNuwY4JlPpgR30LfNUljz0zfnDrMEndNzQZxeBaL4pwz99hjHJduv4KAqbG6rC/PSgw38ON0Fz9XreFLhPe8YrA985oUGE/0dnd0M/UuxQ4xBc1YpnkNxY7M73+5p0eBlVx6IB39hx/AMeYLYaxucNcQQ5BhgeImPhdrzlciSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072762; c=relaxed/simple;
	bh=DuSTBViRYI+r+QrrclSqdVAEsfryHFwMKoA2KUKhTpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ODLlQzTVW1U0Fc6kP9NVX2ct2iEFvfiHqmFENjG5+IGfOmKMuHCA944R3eQEFEfyO5t3OBNZ+4Vu6fk7s6gc/a6705v7CrqicHy7eNsiEo5irUjOn2dKJv7D6Zlwow5ZhOe/i0wsAp6e0x0XFdWtyHvh7/5v62yJmq/5QCmdUTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D9aH8DRY; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MC0rFyYd+77RP33Kf2hQiivIaiq4RczOQIzWb0K4R0EJnXb6CZPhz750z60Wy508koudO1eIEpQcCBBzt/jFqYqIrd7wo495sGwN0Dt1W2SY2iS9m6oEm81PaFkJf23LlcyFhdeGDm3tjgVgTSkQY0fm59NAyO2vBYxK6NO2BSD3lb5nR0G3MSOfDGA8TZ+8fLPRKwcegUHm+fm29H89KjKB4y6mWorxAVypCGA6Ke50VOI7lOwdi3tnrbRriU27/B+9CblEpJCTVQqOuX2239qtCejGfFLQabyxX/QR0w2htQOCaqfP9t4pWEwRp1H/ZV0w0MpNf4+YGc5YzX+aQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urUKKavlJ9CE6XWecKbCsHYsIjCEjk67Q46MOfLczOM=;
 b=YYIN8CM5F7mOZr15PKWNEsNF7NgWDD3dpHabBuexgfNinLMLvZniI20NQxeOiUhsfTElmM3zQOH5K1O+gOQvW1TdpewftHaMimfXU9hl/TbyZ+Vp+hPssM0/Gf1trhzJ123HOuPwi2RQrmMIfcKO5sfei9Fjoj/OX5JMEOKFsgLgtyGTC7dnXUa0ws4ki8J9JuEYJt0EL3/WSUOU7mBN8EUVq0vIjZ6jn8lUuAsGdaH0uaqu9e2Ce5YsfgcN8r8rU7oogYkDai0PZUYVhjK1AX0T7KYHrmqEBLsTyl/Acu2PJHOjuWpJxDQ2pQU7/NN1HEk504RpZDMgO5v04oCl/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urUKKavlJ9CE6XWecKbCsHYsIjCEjk67Q46MOfLczOM=;
 b=D9aH8DRYImV6wFTxdrVOiw9YaGD0/EuVcSHjIles931K9dyDoakxmM/2V4sBHt8t8I7lgZcjbr+ahPtmkU5F8CpQJMDn/JDFBUOEBvAWGU8jZborYjN1u9oYl3pWmggzf9QauADkk237pC8r0QDgJksdRzAIwghquG19+Uly6ZJHjfpDEICOj59+p6PfnQK/WZF7xtpcLHedTrktQ2UIbcaB9X/jp2UhQk7ghwVDaURPhUct5BJpQWHdUsI7Ls9oNxX7KRekb2MI5rRNNn7CWhwQm2hwt1cE8KfHt3XFvm6AIgLObA3Ef7xP97tKC8fYqo+yfp4W0qZYgDWshmDomQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 14:52:29 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v2 02/16] PCI: Add pci_bus_isolation()
Date: Wed,  9 Jul 2025 11:52:05 -0300
Message-ID: <2-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ba1a9a6-0438-42c1-f2cd-08ddbef83806
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LFciMVWdAHt9PGL73z0oaAzCaQepEPD7OAZMB3Dh8Nxg8qbEJq1+tliu2GJF?=
 =?us-ascii?Q?SA2HYMEOVo6Y8Ohym8xabRDq7nfgS7LdmxHecFUnEutCi9UT5K/BLBiHstXs?=
 =?us-ascii?Q?boDlHnPrrPpyRSO2TIzeLVD3XgDBOKhKkddr5SXcqPi1+1EO8Z5ci06XyWnL?=
 =?us-ascii?Q?fWj2cHnUxiAF2uLDfzQVgynnFak37h6clhIMbRFfDXRqloFyUuc/nkLiHjP7?=
 =?us-ascii?Q?nPPy7MrytG2nOhOLyDwjxB1P1hWcAt+hN+upasLxEByUfBn5BIk5Qbxt0niv?=
 =?us-ascii?Q?uG107POp8wPxh+I1X9EHxjC/eiVpkuX42ePdKXh5b+ouD+QIXQaHX4M8+4aF?=
 =?us-ascii?Q?LRllvpysyQculK5q0EWDx5E+sI+NM5RlaLqwpcPhseTpmIaLsKSI6e+sWtF5?=
 =?us-ascii?Q?2ZJPc6c/LweRFgSgHo1hIn04l2ZrEiEneh21wzfiVwz0Nzsb9On9F45FbS1a?=
 =?us-ascii?Q?MHpVdkBXUDvjA/ymHtP+ahSVD1Zq+HclJ4ChEbApePPS7RR0tlQT0zmucabF?=
 =?us-ascii?Q?hUocVzzHPkYom4wBibSeiU6+LpTKe72sZ8UAsCjlFGnxty191Nxzo9nIqjij?=
 =?us-ascii?Q?CZwwbFn342y9s7mO4m49RRm6u/vgmw3IyWGlU3NhDI1qzVaiZLsNa5OGAGBs?=
 =?us-ascii?Q?FTY1Cz5I0Z1hYgKkGCQof4lkJ+OfmV6gu7bWmJg28L+2g2GGRoeb8Hm2pPSh?=
 =?us-ascii?Q?zIraGKSRsuB4Rz+WHupj9g9Fr0lw2CDXGJYW8JHd3drv5RPBePaiYTCTyQHT?=
 =?us-ascii?Q?xH4sr0SvqVzCo0zVWS8n94OcWfrJzH9yfWa8lLSJp1JgdKniC2++Zhrv+ya7?=
 =?us-ascii?Q?sp88PlCIx33Auy5BRUIL9G2hlNukO34pmRLa9sXMoiVRGjh0MlFqgHvUkRX8?=
 =?us-ascii?Q?X7fKs77Bp8eV/59JaF3FRKn9/4h6CuZQVQ58X8TOFCr6X+qS6ACLRZQwJj49?=
 =?us-ascii?Q?aCX93vRjAC8I3gGFwc7+F3cZPMd/xUlw0VmsO0o4tCrm0XWVmKQTlNOAJRHe?=
 =?us-ascii?Q?oP/ADm/Ae0iTtPkgO7Rb4DAU/NT72L3qRpfMHosiZLjwDz91/kKLRoJF1KRF?=
 =?us-ascii?Q?heLn4wJKov8XAzC7NNuznnXPiw9ja1m9rXEGGiw5Zyqr7ICLiWEmYTXvwMt/?=
 =?us-ascii?Q?/zrxaA+kwKhh39kz5QMVBktYQADIuA0rQ6fccu2mGXtIiDRqpnpeGu0eqrEF?=
 =?us-ascii?Q?tsjVDcUy35qKDAOTZl5/u5eUQgQjJX0Rdq0/2+aPnYnNA7e/WauXk3uBmqw1?=
 =?us-ascii?Q?161MaksGcuu5F1daKlWda8xsu3rAyipWzWsBuRzGXm3cc/ZN6DJgLaA2tVew?=
 =?us-ascii?Q?cObXqCkRJLVpR2b6zTuW6Y+Eisrr71pjjwyKch8+bV7l7DzuTtpPJyIbLqqj?=
 =?us-ascii?Q?/tcNC2IZ/umAhpHASReJ568e05zEZjWEJodN05LuPXgXHVza9sZKsa3PH/V6?=
 =?us-ascii?Q?Ml/TDAoOvsU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JZkqmgE6dYNeqWjrjiAljIkBg3LcWYCiZnynxBYCsdV8M7LOga89IMx26pdP?=
 =?us-ascii?Q?5dzaorqFNyAw1yWlw0XvbVvv1Z3XJ4cW2Zq5V3QpcZe/YvOzb+s1mMuXjreI?=
 =?us-ascii?Q?QSLCYNxHJg+3i3kmt8wc+wQt+mIuuRD5Uh8DHOzXJYBtGdF9kYlOEe/Sgsqx?=
 =?us-ascii?Q?GHDimNTEVRofUdfiGK0QIqw+IeQYyycAutymshAK3M4YM3ZT1Jv+w4RgcoDN?=
 =?us-ascii?Q?/eC2yXY0fuPne/HeB9jb0eKEgC76JMoSZT9n+O0z5St/9VylnwEr7RmyceFU?=
 =?us-ascii?Q?wCMJFQCsnqgIrFmwBlkJvEyTe00AgZAukbebidhwFn+hpYyMePgsEThG04y5?=
 =?us-ascii?Q?1Fs/9/a2fi8wLlDDkWphuIUeJ7GGjzhdwOdvArRezN+C91Qeg4PmOA3u8VV4?=
 =?us-ascii?Q?e7e2OmTsglgy1hsE9GKsotgqE9NgM9xQAsCjfY3Xq7WbY/BEaDQb4OlsYoiU?=
 =?us-ascii?Q?7HeuAsWHZdBdTLwJcTK2w2xJe9h2Ztlw31Ido/BEbrdLSQEHT0KgQc778jw7?=
 =?us-ascii?Q?uKoynHz1oOPNRo29F/WDIYHA5YZ8Gpb2rZy1U4F4Xrx4/Q8ObMOaiQ5jHeij?=
 =?us-ascii?Q?8qUxyUqVPBOtkx6Vgv99Wz62PAIGQEwDmekmDL4ZDpFS1RCd3aurtexHk2BT?=
 =?us-ascii?Q?EhWZxp97hR0G78OANgsY8r7lZ37qKtkRb6JKiOMp6O8Aq5+ZsDsS+Y9Bxjki?=
 =?us-ascii?Q?C5u+d1cXf84R/YTZfB2Qq76pU0RZ47jDBq9I3vgmaClRK8W85GHL67HmInKD?=
 =?us-ascii?Q?WR5ty8X/WA0YVSocOKf75kIsHIzvHbX4WXjZlF4f1+fmy/pSx3K2Hm1nrPOB?=
 =?us-ascii?Q?IFwmhY3Z5lGgeuYplzVFqD+Rcg01XHrYFOgKhOxhp1pspKPYxnpuQhuMqDMI?=
 =?us-ascii?Q?vkxdU/ocpDp8qhUDLIvU+Y58GUEj3FOm705/CymflZwS2RJMUcZOEoGrZdx/?=
 =?us-ascii?Q?nonHhRGYB1nqT4kdsLtvr0X54FqFWrpXsKT/ug2YNx8wjzvLRiM+cFTA3XVU?=
 =?us-ascii?Q?cd/I0sO1Uv87e36pt6soYdTGW5FVZNuvq/rQFlddDx8SO/PsKomLXRe4GVlX?=
 =?us-ascii?Q?WzKW7QpCFYn03O3oQMHRSOFJMskgU8Ta/JogYriniwms6/8x7h3TAsKf9UkI?=
 =?us-ascii?Q?wd0+DJzjLLmnEPdQnsp46Bhx22eFJ0QO6iun8Rrc10sIsN2nNjZEMepH/g+0?=
 =?us-ascii?Q?brOp+WM5p0Buf4J9F2Q6Y7ivckxnmErnOKnIo+Km/Rw4E1P2CLBG0SGPMP6g?=
 =?us-ascii?Q?qmZRuUICAaUAf5uRHptTiz8V6pht1VLumyYd47LtTyrE5bRJaht7FcdqoflL?=
 =?us-ascii?Q?ODOoerKXG6L2y8QFNZNdq9viK6VlkutEkyGVNh3RBqFs0CHCRC+oYtKyq1jN?=
 =?us-ascii?Q?ZFad5t7SHPper7PMBC8ZisM4msBsaFwsVK0F5oAxQVetyo5q2AlsWtnEfyo3?=
 =?us-ascii?Q?XZ4WXqU/g7kMuPQjU0xOXWs1tUmtadssuL3ttSnX5Rw91Rnv/kuMrRW28t2w?=
 =?us-ascii?Q?w8VRlq73+55xICb3B8u/4E2Mu2JhhJdMkVyuelmUVv9O2TaUO25G4TKCc6iP?=
 =?us-ascii?Q?Yb7Yh6411+YOgaC0wYlEP3PAgq+2CrIY/CAdSjBx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba1a9a6-0438-42c1-f2cd-08ddbef83806
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:26.1221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZnJgpxmV10fLQCbVMafOMxv88gQtUnt32de/HcFdU17Uv59wIIPyQ3d99lw08bm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125

Prepare to move the calculation of the bus P2P isolation out of the iommu
code and into the PCI core. This allows using the faster list iteration
under the pci_bus_sem, and the code has a kinship with the logic in
pci_for_each_dma_alias().

Bus isolation is the concept that drives the iommu_groups for the purposes
of VFIO. Stated simply, if device A can send traffic to device B then they
must be in the same group.

Only PCIe provides isolation. The multi-drop electrical topology in
classical PCI allows any bus member to claim the transaction.

In PCIe isolation comes out of ACS. If a PCIe Switch and Root Complex has
ACS flags that prevent peer to peer traffic and funnel all operations to
the IOMMU then devices can be isolated.

If a multi-function devices has ACS flags preventing self loop back then
that device is isolated, though pci_bus_isolation() does not deal with
devices.

As a property of a bus, there are several positive cases:

 - The point to point "bus" on a physical PCIe link is isolated if the
   bridge/root device has something preventing self-access to its own
   MMIO.

 - A Root Port is usually isolated

 - A PCIe switch can be isolated if all it's Down Stream Ports have good
   ACS flags

pci_bus_isolation() implements these rules and returns an enum indicating
the level of isolation the bus has, with five possibilies:

 PCIE_ISOLATED: Traffic on this PCIE bus can not do any P2P.

 PCIE_SWITCH_DSP_NON_ISOLATED: The bus is the internal bus of a PCIE
     switch and the USP is isolated but the DSPs are not.

 PCIE_NON_ISOLATED: The PCIe bus has no isolation between the bridge or
     any downstream devices.

 PCI_BUS_NON_ISOLATED: It is a PCI/PCI-X but the bridge is PCIe, has no
     aliases and is isolated.

 PCI_BRIDGE_NON_ISOLATED: It is a PCI/PCI-X bus and has no isolation, the
     bridge is part of the group.

The calculation is done per-bus, so it is possible for a transactions from
a PCI device to travel through different bus isolation types on its way
upstream. PCIE_SWITCH_DSP_NON_ISOLATED/PCI_BUS_NON_ISOLATED and
PCIE_NON_ISOLATED/PCI_BRIDGE_NON_ISOLATED are the same for the purposes of
creating iommu groups. The distinction between PCIe and PCI allows for
easier understanding and debugging as to why the groups are chosen.

For the iommu groups if all busses on the upstream path are PCIE_ISOLATED
then the end device has a chance to have a single-device iommu_group. Once
any non-isolated bus segment is found that bus segment will have an
iommu_group that captures all downstream devices, and sometimes the
upstream bridge.

pci_bus_isolation() is principally about isolation, but there is an
overlap with grouping requirements for legacy PCI aliasing. For purely
legacy PCI environments pci_bus_isolation() returns
PCI_BRIDGE_NON_ISOLATED for everything and all devices within a hierarchy
are in one group. No need to worry about bridge aliasing.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/search.c | 164 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |  31 ++++++++
 2 files changed, 195 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 53840634fbfc2b..a13fad53e44df9 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -113,6 +113,170 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 	return ret;
 }
 
+static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
+{
+	struct pci_dev *pdev;
+
+	/*
+	 * Within a PCIe switch we have an interior bus that has the Upstream
+	 * port as the bridge and a set of Downstream port bridging to the
+	 * egress ports.
+	 *
+	 * Each DSP has an ACS setting which controls where its traffic is
+	 * permitted to go. Any DSP with a permissive ACS setting can send
+	 * traffic flowing upstream back downstream through another DSP.
+	 *
+	 * Thus any non-permissive DSP spoils the whole bus.
+	 */
+	guard(rwsem_read)(&pci_bus_sem);
+	list_for_each_entry(pdev, &bus->devices, bus_list) {
+		/* Don't understand what this is, be conservative */
+		if (!pci_is_pcie(pdev) ||
+		    pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM ||
+		    pdev->dma_alias_mask)
+			return PCIE_NON_ISOLATED;
+
+		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
+			return PCIE_SWITCH_DSP_NON_ISOLATED;
+	}
+	return PCIE_ISOLATED;
+}
+
+static bool pci_has_mmio(struct pci_dev *pdev)
+{
+	unsigned int i;
+
+	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
+		struct resource *res = pci_resource_n(pdev, i);
+
+		if (resource_size(res) && resource_type(res) == IORESOURCE_MEM)
+			return true;
+	}
+	return false;
+}
+
+/**
+ * pci_bus_isolated - Determine how isolated connected devices are
+ * @bus: The bus to check
+ *
+ * Isolation is the ability of devices to talk to each other. Full isolation
+ * means that a device can only communicate with the IOMMU and can not do peer
+ * to peer within the fabric.
+ *
+ * We consider isolation on a bus by bus basis. If the bus will permit a
+ * transaction originated downstream to complete on anything other than the
+ * IOMMU then the bus is not isolated.
+ *
+ * Non-isolation includes all the downstream devices on this bus, and it may
+ * include the upstream bridge or port that is creating this bus.
+ *
+ * The various cases are returned in an enum.
+ *
+ * Broadly speaking this function evaluates the ACS settings in a PCI switch to
+ * determine if a PCI switch is configured to have full isolation.
+ *
+ * Old PCI/PCI-X busses cannot have isolation due to their physical properties,
+ * but they do have some aliasing properties that effect group creation.
+ *
+ * pci_bus_isolated() does not consider loopback internal to devices, like
+ * multi-function devices performing a self-loopback. The caller must check
+ * this separately. It does not considering alasing within the bus.
+ *
+ * It does not currently support the ACS P2P Egress Control Vector, Linux does
+ * not yet have any way to enable this feature. EC will create subsets of the
+ * bus that are isolated from other subsets.
+ */
+enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
+	int type;
+
+	/*
+	 * This bus was created by pci_register_host_bridge(). The spec provides
+	 * no way to tell what kind of bus this is, for PCIe we expect this to
+	 * be internal to the root complex and not covered by any spec behavior.
+	 * Linux has historically been optimistic about this bus and treated it
+	 * as isolating. Given that the behavior of the root complex and the ACS
+	 * behavior of RCiEP's is explicitly not specified we hope that the
+	 * implementation is directing everything that reaches the root bus to
+	 * the IOMMU.
+	 */
+	if (pci_is_root_bus(bus))
+		return PCIE_ISOLATED;
+
+	/*
+	 * bus->self is only NULL for SRIOV VFs, it represents a "virtual" bus
+	 * within Linux to hold any bus numbers consumed by VF RIDs. Caller must
+	 * use pci_physfn() to get the bus for calling this function.
+	 */
+	if (WARN_ON(!bridge))
+		return PCI_BRIDGE_NON_ISOLATED;
+
+	/*
+	 * The bridge is not a PCIe bridge therefore this bus is PCI/PCI-X.
+	 *
+	 * PCI does not have anything like ACS. Any down stream device can bus
+	 * master an address that any other downstream device can claim. No
+	 * isolation is possible.
+	 */
+	if (!pci_is_pcie(bridge)) {
+		if (bridge->dev_flags & PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS)
+			type = PCI_EXP_TYPE_PCI_BRIDGE;
+		else
+			return PCI_BRIDGE_NON_ISOLATED;
+	} else {
+		type = pci_pcie_type(bridge);
+	}
+
+	switch (type) {
+	/*
+	 * Since PCIe links are point to point root and downstream ports are
+	 * isolated if their own MMIO cannot be reached.
+	 */
+	case PCI_EXP_TYPE_ROOT_PORT:
+	case PCI_EXP_TYPE_DOWNSTREAM:
+		if (!pci_acs_enabled(bridge, PCI_ACS_ISOLATED))
+			return PCIE_NON_ISOLATED;
+		return PCIE_ISOLATED;
+
+	/*
+	 * bus is the interior bus of a PCI-E switch where ACS rules apply.
+	 */
+	case PCI_EXP_TYPE_UPSTREAM:
+		return pcie_switch_isolated(bus);
+
+	/*
+	 * PCIe to PCI/PCI-X - this bus is PCI.
+	 */
+	case PCI_EXP_TYPE_PCI_BRIDGE:
+		/*
+		 * A PCIe express bridge will use the subordinate bus number
+		 * with a 0 devfn as the RID in some cases. This causes all
+		 * subordinate devfns to alias with 0, which is the same
+		 * grouping as PCI_BUS_NON_ISOLATED. The RID of the bridge
+		 * itself is only used by the bridge.
+		 *
+		 * However, if the bridge has MMIO then we will assume the MMIO
+		 * is not isolated due to no ACS controls on this bridge type.
+		 */
+		if (pci_has_mmio(bridge))
+			return PCI_BRIDGE_NON_ISOLATED;
+		return PCI_BUS_NON_ISOLATED;
+
+	/*
+	 * PCI/PCI-X to PCIe - this bus is PCIe. We already know there must be a
+	 * PCI bus upstream of this bus, so just return non-isolated. If
+	 * upstream is PCI-X the PCIe RID should be preserved, but for PCI the
+	 * RID will be lost.
+	 */
+	case PCI_EXP_TYPE_PCIE_BRIDGE:
+		return PCI_BRIDGE_NON_ISOLATED;
+
+	default:
+		return PCI_BRIDGE_NON_ISOLATED;
+	}
+}
+
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
 	struct pci_bus *child;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 05e68f35f39238..0b1e28dcf9187d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -834,6 +834,32 @@ struct pci_dynids {
 	struct list_head	list;	/* For IDs added at runtime */
 };
 
+enum pci_bus_isolation {
+	/*
+	 * The bus is off a root port and the root port has isolated ACS flags
+	 * or the bus is part of a PCIe switch and the switch has isolated ACS
+	 * flags.
+	 */
+	PCIE_ISOLATED,
+	/*
+	 * The switch's DSP's are not isolated from each other but are isolated
+	 * from the USP.
+	 */
+	PCIE_SWITCH_DSP_NON_ISOLATED,
+	/* The above and the USP's MMIO is not isolated. */
+	PCIE_NON_ISOLATED,
+	/*
+	 * A PCI/PCI-X bus, no isolation. This is like
+	 * PCIE_SWITCH_DSP_NON_ISOLATED in that the upstream bridge is isolated
+	 * from the bus. The bus itself may also have a shared alias of devfn=0.
+	 */
+	PCI_BUS_NON_ISOLATED,
+	/*
+	 * The above and the bridge's MMIO is not isolated and the bridge's RID
+	 * may be an alias.
+	 */
+	PCI_BRIDGE_NON_ISOLATED,
+};
 
 /*
  * PCI Error Recovery System (PCI-ERS).  If a PCI device driver provides
@@ -1222,6 +1248,8 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
 
+enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
+
 int pci_dev_present(const struct pci_device_id *ids);
 
 int pci_bus_read_config_byte(struct pci_bus *bus, unsigned int devfn,
@@ -2035,6 +2063,9 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
 						 struct pci_dev *from)
 { return NULL; }
 
+static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
+{ return PCIE_NON_ISOLATED; }
+
 static inline int pci_dev_present(const struct pci_device_id *ids)
 { return 0; }
 
-- 
2.43.0


