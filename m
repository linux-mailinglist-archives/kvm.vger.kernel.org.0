Return-Path: <kvm+bounces-25552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB96E966785
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 19:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62A1D287198
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441E016C68F;
	Fri, 30 Aug 2024 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S07qUyA8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE27D1509AE;
	Fri, 30 Aug 2024 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725037298; cv=fail; b=NIFRXovbJSov2kn16xYpHQO8K6PnvpQPxWeMnc0b2XViha+JKGU1wLXiK/mfDezgd8dDtvbfCeEZlEE5IUP7TtZxtJ47spbuKxTek5y79ev7QOgesU8jYuEMmyh1TO1zbNMMo/JEhpUjBIHwTzuZLS9Ol/qvBOzfTliLOkGkINk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725037298; c=relaxed/simple;
	bh=5WkAFc/A6RhmNyDp0osYPEUYTgi5idPoKX1skSWzy98=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjEwdZL2cia3EN2IMgzUSRHcXVUesuoxrkQ70LpSVV/VwxKIfcTtxiBSAqM+skFIX6lDxkudWM72XoN8P/MnlGreoKsLkC8fwbHQAXVx7Em+qnGb84pi4jiF6V2Ftnf5DNyKeqCmCNMvwArWEKUiMw2PjUgLI6tVc6i5OaZVkXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S07qUyA8; arc=fail smtp.client-ip=40.107.102.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vAzJ1O4EJIezj6B9InOWU4ts/gGEil0o7IgQPF3AHpDOhNMzvvxaI+nOARlmC4ybVIci7MaIHh5Pu3+DfysF9t5fPOBy8MeT+artrPjuGzFrOoyHBflPZPc0D8qInYoKURQhe/G9XX3dv8FFCqmXzeMBggJyt8CCr7KqKlcoMGakBA0gqeaZmCtjYyv2J/Zotfz263blbeidSees7AXLni30pDDijQfLiuk4NGOMmTN7DE647Os4Lacc9rsFa3RKoPEvw8aLSrWRmb0da3Wf9gYnkTnwV8PUuc8JO/ILw+4zWfjzc6+GeOQXNJiHFkNTFO0PcnJ0E3LsE/DOz7fXIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGkPVwFE8ed47bEAXwh8ZJ0Swmi3nNqrmDxnD6Z+Qi8=;
 b=VOmHE9Cdedq+ErwwqlhbDrXS6t2NM1wBSqp6q/RJAxcYP6GHhuKwWR+5iZCi8q43PGYZFXD7b8vWU2dHBqdJ0dc6fXit+hSDu7wXqcmZAxyaXnSoplBCrA4IBYAKU9iD6cd+3w7E24FGGajAF70NaoLGhzEilhR75Qhfe/WRNRZvTcS3CvKirvzVGybtgJWTgCnJ/ay4D8+u4oCal76JkDA34o+zuaMk2sE0YbWxaiV4jn4pPu6xth6ktc/mYBqnc8GoAmE9BSE5tqqAM7ebPVnjMj6MxclnlrtY0PyOAecomoxekX4rKHKKK4CFWvKcuoGLWgLPx4tpolkNLeFxrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGkPVwFE8ed47bEAXwh8ZJ0Swmi3nNqrmDxnD6Z+Qi8=;
 b=S07qUyA8aRNexh8Ka/2dFQlcak0a72usMOZqfnKRtAs3kvusce3hTBnr3kWbNasSzmP2by09w3i4gZAdiJ93qijj6wqir/3Hddc1yyuArRKR+tLPhEvRNZ9nWwB6EyIpHiA4WbnTRcy1eedxiCnwYTDh9LmN+KhfPwWySWgCVo2bnO0NsA9lO5vv1t8T/GpbpCLYXQGZqzvTcolOVoFwdZmtgvcfo1AIO51SVgogbAQJN0Kp5OIZS5tQo/ggrGPpYMK9VLUukRrGS22JsJdr6+lBR37P0cckXti98rMIZ+xPUAiA9F4f7rDOmhSZ2xxJo/4t0KDwAj80VcxvAj6FTA==
Received: from PH7PR17CA0023.namprd17.prod.outlook.com (2603:10b6:510:324::24)
 by PH7PR12MB8039.namprd12.prod.outlook.com (2603:10b6:510:26a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 17:01:31 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:510:324:cafe::e) by PH7PR17CA0023.outlook.office365.com
 (2603:10b6:510:324::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.21 via Frontend
 Transport; Fri, 30 Aug 2024 17:01:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 17:01:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 10:01:17 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 30 Aug 2024 10:01:16 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 30 Aug 2024 10:01:15 -0700
Date: Fri, 30 Aug 2024 10:01:14 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "Guohanjun (Hanjun Guo)"
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Message-ID: <ZtH62jiG43DHPWvm@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
 <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
 <cd36b0e460734df0ae95f5e82bfebaef@huawei.com>
 <Zs9ooZLNtPZ8PwJh@Asurada-Nvidia>
 <d2ad792fe9dd44d38396c5646fa956c6@huawei.com>
 <d1dc23f484784413bb3f6658717de516@huawei.com>
 <ZtCdXjkzVbFMBJjy@Asurada-Nvidia>
 <a008993d270b4cc381abbcc5c44e5bb9@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a008993d270b4cc381abbcc5c44e5bb9@huawei.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|PH7PR12MB8039:EE_
X-MS-Office365-Filtering-Correlation-Id: f0ff76d8-989c-4dac-bf57-08dcc915647b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TVnVxDZ/w/rvLXVVr2+vt1H/QV2IFyC2nKqzALZlThLy/cD2jKQNFOsp5HLW?=
 =?us-ascii?Q?eWoVhOeflsMyNGUAjVV9CAjy2MmgM53Mi9iabjz2BD/m1gEnCrK+yk6vaPpy?=
 =?us-ascii?Q?53yTlhL5EtlMjvhLfQswMnU9fzLCC3Je230OGVULV43vSHIfjL77Sc47foKI?=
 =?us-ascii?Q?BzL5D8P0JQ97nSjQzx7jo5UpjrJQFCMKnVj320y30KUpNUTHyk+rmKpg0WIh?=
 =?us-ascii?Q?3cUew87L3aHZ/dVTQTW/G+d64lp1+bilIZOgWpKZ8jzK2WgISrCmyvgIQqpk?=
 =?us-ascii?Q?adojPNBMKhtdbOQU9s545hrjPutmQlBci1rqAZxBCL5E+eerQ6L8Q/Mq7g07?=
 =?us-ascii?Q?HqyBpsFpG+fG1I5Edg7uFw+QY4xa2G6sdK+7oTXAqm21UUOERSIt10bp2QTe?=
 =?us-ascii?Q?wCa8FwzNCbDG4/qrPNqxQIVwdvxDNismX3P6P8xKomv8YAjsjxQ94DlAOyzb?=
 =?us-ascii?Q?UoEy+WW0q0n0OHvxVXh3faslZao2cGCvACrJqeS0u8AIaaVlRdGuFD6hSzz1?=
 =?us-ascii?Q?DZllsklDSe5IhjZurScQJLwxTebWlafpiE49wgacJhEtI0OU5RSWZeLDJPGG?=
 =?us-ascii?Q?FrA8elwi5F9BLEa7atdreFok2TjBKM/PcSeUUw4V/hYkSrsMobB7t5NlMTPJ?=
 =?us-ascii?Q?q/j4ZNA4gZMYmzWOkl6DlyShcYGHtnc/TA3mtbXAveSZonyc9KFXnirLP0Ap?=
 =?us-ascii?Q?UsDQWRex3SoEdNwkw9ikW/ZBd+4FeBp408KUHmD3oQ05bjnz6S0zt4vm32xy?=
 =?us-ascii?Q?FVRZm5Dtc/o5JjXugSfOSqbk0cG3B3qB9YUTtXjekeHRdwjaCqQrinUUBMfW?=
 =?us-ascii?Q?9oddUlU26XWTFa/uS5rXw7j4swHdumic7bM/e5gyZ0l5+lMwd6+aSKU5pDpJ?=
 =?us-ascii?Q?X+RHn0EJSi2VC8okRBbuhp95iVKqozzdcsgE3sxcSrXA60dshnkI3Bz28hVN?=
 =?us-ascii?Q?wFZMVh246KcLXglAnDRcGbl/AcBfZjek5fHGOHdJzgrJqZa5deis/ad+bDuw?=
 =?us-ascii?Q?TFfKJWfSyRBwwFaco2jzKJUVlvF57Zag2xYcG2pSfw1WSgZHovrVvVGfuOej?=
 =?us-ascii?Q?EaMjSdV46xf+22ymmch0c0hFuZ4o4OvVASYGMS3eJRSONVOK4cQqM6jneNLF?=
 =?us-ascii?Q?x0kX11Yh+E+Ve74mi6km63RDPk8IA+n11SsUNz4E8S8Fg7rv4sFyz1MXJ3Pm?=
 =?us-ascii?Q?1Js/BLrOuDjIOQU2xOSRIyEqK/wROPsMxzgbe18cBdsPAufBdwDdRsw8xccK?=
 =?us-ascii?Q?FXgSOfaOlsjoDtA4cOV5j4JGnq0lWQX9bpcqU9mhNC8afUQHlIGyRFiwKF4f?=
 =?us-ascii?Q?wCmc2vCujbu09ZqP6yetx67f0ydl85AvxPSj/lmDn3KNY2ILBcghYsU3+WKf?=
 =?us-ascii?Q?g1YsgRjlWSpCgK0KF12DIQfVMlLqCNFW6pgUB4KjErfeEP9AQC3Z8lmOk86u?=
 =?us-ascii?Q?l7FL0feBx+V3y2KA+0HUOx0BffCXMiJV?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 17:01:29.6158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ff76d8-989c-4dac-bf57-08dcc915647b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8039

On Fri, Aug 30, 2024 at 09:07:16AM +0000, Shameerali Kolothum Thodi wrote:

> Print shows everything fine:
> create_new_pcie_port: name_port smmu_bus0xca_port0, bus_nr 0xca chassis_nr 0xfd, nested_smmu->index 0x2, pci_bus_num 0xca, ret 1
> 
> It looks like a problem with old QEMU_EFI.fd(2022 build and before).
> I tried with 2023 QEMU_EFI.fd and with that it looks fine.
> 
> root@ubuntu:/# lspci -tv
> -+-[0000:ca]---00.0-[cb]----00.0  Huawei Technologies Co., Ltd. Device a251
>  \-[0000:00]-+-00.0  Red Hat, Inc. QEMU PCIe Host bridge
>              +-01.0  Red Hat, Inc Virtio network device
>              +-02.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-03.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-04.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-05.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-06.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-07.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-08.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              \-09.0  Red Hat, Inc. QEMU PCIe Expander bridge
> 
> So for now, I can proceed.

Nice! That's a relief, for now :)

Thanks
Nicolin

