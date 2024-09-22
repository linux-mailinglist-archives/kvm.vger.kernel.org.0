Return-Path: <kvm+bounces-27277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FBDA97E1C6
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 15:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 988D2280FF9
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 13:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A3F28EE;
	Sun, 22 Sep 2024 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qmkSbYjE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653D363D
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727010699; cv=fail; b=qSawrXl7TBgaa3Dxa5QT00hm5El4tYX0qlHU1zihgDIahI8Jcgg50uOv1hXvrQBY36BIjQql2diGGDGA7CTRRSTDFg9y4z4SMLDEnXrFJ3osE/ASy5o0ck7qMbICs0SqqNaVALKusGAC3JjFAd3BDZ5Pt4Ghabul0+xY4VEu5Y0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727010699; c=relaxed/simple;
	bh=Yaisr4SQnPXvgZmO1DkJdIXjd7zUktRsP6I3QghcBuo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SDjnFETkMLrkq0ACKJBBgIhhIkoJE+wGUTJPCNkmaBzjJ8k3RKklHMZNyUfSCMaMRSu2H2PRVrkTN0S2Q0gcjSJk7amBbwkU0x6gt1RzCqtVsGv11o7anG8nZPfui213MGaIgFQW6f8CvoaNXz/VsMI25fSgAe66YcWCRrJNM0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qmkSbYjE; arc=fail smtp.client-ip=40.107.102.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJieYsAVg9Ck1pbAGMOucZV35IaCOcw3iTl53daU9qRPbZzH+rFI3YWUn7kdTcm2TmXvUQ5TpDCwXcibgaOAZS6+y4FHQeny2CMpILsTVe4y8kYwWbYYttAqwHywj1G87zPjrR4dFA4WIk8EdZXm9QcbveTxwhOwjEN/9s5Lx40kM+vIdieJv7jzR9GFiSibGrioiqrD3AuaFDr8EcSwmb9qqIQF+hHRMmIG1Z11SeQ/qQMIMItTAhonFUdhHui+zeafLNmHe9rBkjFJwn1gA1rEnJ95Y24D6+dBYge/qEd5JbLgKffWiXijEmfzBLe9ifpIbriikVQud9awd8bi+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwMBdJuZPlHG+FZbM2Z4U8yWW6bsnyNKmbk/1pTjli0=;
 b=NT8S4eU1j5x0nmVuQLb3hQ6w8jUrjTswMRlWwRvVnZSjCi+9+Tfcnlvbcik4CQ76vU9exRKDdMjYgHgkRMveu3ok15yfEwWfTpxYHNBLP7E9qxDV2A1vEE4NG5UsPz/CqJiwLt/OizhkBuVjsaRIjJ/S605X5twqKS29+/yZ+G2KO829qaHCBCLqZSDFbRevoFSgCwWGVLlVWFXQp8jdd6ssAla28Yuz6hgMGNITpfnwQkChel/vuwsubZfTZbqV6lY2QdUwYxVxE2+6AK1OTUU0YLh67WeruLqdtw/BekK0SzFi0+7ufQfzePiQPf+Ba/PF6cPNYpNf4rHwBC2fZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwMBdJuZPlHG+FZbM2Z4U8yWW6bsnyNKmbk/1pTjli0=;
 b=qmkSbYjEepWrjDhcgAMp7tl/PpT6MPoR05ADkmGNdh72hIWZ3aUJMB9ayYChb5nsJZnxVa4qZnAfbIfHzbihmuzJ8NtALJcpePagmiJ6EnLFyYgEyC/Z/I3GMMPgIrA3KLaTRUvO0HPxVvp7NpBj4nOTqsOZMMXh1XQGxodLd+hv2olNvZ/gM1yKj4GXsj+ulH8U1FtcbnH9pZFOsJLKiLFhPNmEr4saxVJv7llz0chLSOcd3beavijwV73AOL8HowSQhE//jsQSyq01FdcvlMDeKJLu1O0yC0OcXo8sbddEsw0Pe6048hLkCuPwSqYlcDGiFH+MC5n+pYnnfhhsqA==
Received: from CH0PR03CA0360.namprd03.prod.outlook.com (2603:10b6:610:11a::11)
 by SJ0PR12MB8092.namprd12.prod.outlook.com (2603:10b6:a03:4ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 13:11:30 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:610:11a:cafe::7d) by CH0PR03CA0360.outlook.office365.com
 (2603:10b6:610:11a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.26 via Frontend
 Transport; Sun, 22 Sep 2024 13:11:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 13:11:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 06:11:26 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 06:11:26 -0700
Received: from localhost (10.127.8.11) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 22 Sep
 2024 06:11:22 -0700
Date: Sun, 22 Sep 2024 16:11:21 +0300
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiwang@kernel.org>, <bskeggs@nvidia.com>
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240922161121.000060a0.zhiw@nvidia.com>
In-Reply-To: <20240922124951.1946072-1-zhiw@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
Organization: NVIDIA
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|SJ0PR12MB8092:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e8e3a53-b85c-4515-8d0f-08dcdb0812cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anFUZVpHUlRKajNDSSttUFJzV3NIbW5sNnRvUmZMR2haUis4aFM3VXB1a3lq?=
 =?utf-8?B?UG1MNVBPekNRamVhem1ibzU5Tk5rZGgvOEg4OGk3aVlDMWtvbjZDQ3IzenN5?=
 =?utf-8?B?Vkw0OStmbm01WHA5TXFlZ3dzTmYzTWhNQWdxa1hxYmgza3lVaXBWbW5GTzhs?=
 =?utf-8?B?V1dtZlFGQkJOTWxuR3FGd2JReE1kUnBvQXZqUG5iVHF6MGhhVkZNanRHZGFn?=
 =?utf-8?B?dm11TWZHNGowOXVHdGx6RnZSSENUZUYzQkFmM1JWbWowRk9DQ2c0ejJoQWk4?=
 =?utf-8?B?SENyS2hzS1JTYTQ4YTFlSlJUZTEvR2JSZ2IxbVRiSUNHQnlKK2JnODlJRFlP?=
 =?utf-8?B?cVVrY2xhZXBIMzBGK0JGdUdYcSs4NHpHK2RLd1l1bC92YjB4NUt6SnhXbW5I?=
 =?utf-8?B?K05hQUkxS291NzR2QW0zRTYzWUJqdHNuSjBVSG13LzNNK21aaUU0SGUwK0ZF?=
 =?utf-8?B?c3Y5NGtjOGlCb2NNNFRtSHVkcHk3OWJBQVpvbFByUzBZeXZPcjFsSEdQRUtC?=
 =?utf-8?B?SDVsNEd2aWU2N1gxcHZmOTY4M2dmMStnQ3B0NlZVb2tjb1ZobUJUaGZWQnE3?=
 =?utf-8?B?dnhWYmc1bVI3blVTQ29wUkVYOUdyZUF3WnJNVm9QbE40ZjdzS2hHTk0zd2lY?=
 =?utf-8?B?TndNaWwzdElDSkJjWGU3RkRTRkVCVkNBdlo4cTNoc212dHVwNHVoVnFIcmYv?=
 =?utf-8?B?T3NublU4ODhvUEM1MXFNTkIrMWl3b2NFYzFoOWhPZU5DQkZ5ZmxTZWlFb3hH?=
 =?utf-8?B?UllRUk9wVEIxY3lldVhtdytxdm4yVjJwN2NEdVZLTllxbTZFb3Z6MlQzRjdh?=
 =?utf-8?B?VGt0RHJkbk1sQXhHK0s4MkRGLzlKcm9DVTdZMzBITE5CL3Q0WTNRaVl4SFlQ?=
 =?utf-8?B?V2x1dHBVbk9wdFF2L3RTTEoycjQ2Tm1wbGpVUFAvN3d5YzdsWmR6YTdQWmJF?=
 =?utf-8?B?dFNDU3gwTjhSdjU3QTFLV1NUc1JMZExHNWVNZG5NdGpSdTRLeFQ4NGxlbjJT?=
 =?utf-8?B?YUQ1Q2cwR05KTWROZXlsaW1ZcG9DelV0UThRU1o4M21nYy83UFhzdGdKUWt5?=
 =?utf-8?B?Ui8vTUdoRERZN011ZUVYMXpBbHRZOUJ1akkvU1RBbWJ0RkhFYkNwV3FxUTB0?=
 =?utf-8?B?aHNxai85ZVIxYlgwaTNKWUdiTzZSRUZNUDJqZERWNytBT3hmSGtBSWU1M3ZB?=
 =?utf-8?B?M3gyWGxrT3ptQjZvQmZhWnk5Sml1cnE1d3dUUCt0aUVTc003MVVNVWt6VFc5?=
 =?utf-8?B?MTd5djBveVBaam1PVDhsOFFNM3A0YVprYmxiNG9zWjJxYVRpdk04bGM5MlRN?=
 =?utf-8?B?U2ZWSGx0R3BhYXBSbkZ0VkgzVzR2eGVOamR3T1NlbXUxUTViYmcreUJZWkpl?=
 =?utf-8?B?Z3o1bUkyYmJ4OXUydjdOQmdmNU9XM2lGazZZTXRSY3pPYUNqT0xlRWQzNGhx?=
 =?utf-8?B?ZXZNL2dwbkhqdnhBUnpVb2VqZWhtS0Z6Z2o0QTgxSWRQUTVlVVVjMWNDR2pP?=
 =?utf-8?B?MUpjZVRIbUZVRXkxSUZ3YXZxekxPYXV0Y0gweWI5Q083aU9RVyt2dXhwcUxZ?=
 =?utf-8?B?NVFHd3hXcDlWSDZISUROR3NmbktjcEtxWUpjTkdhd2VqZk0rY0l2WENFQW52?=
 =?utf-8?B?T05kc09RdkV2cTNDdHZWa29ZRCtGYlJWSUZTaXhSblZ0QThVSzkraWVLYnp4?=
 =?utf-8?B?OXRLek0xN2JnNXVYUCs3YUgvR1JyZklFRi8rZVhGY001K0VrTGtaNG9WK1hG?=
 =?utf-8?B?c1d4Y1Y0NUlWSnd2WERRcG1IV3JhSjRodWd6MnBTRDJ5ODhaTVAwb2dwM0JO?=
 =?utf-8?B?ME14eVZrUWRxd1IzMGlEcGJzNVNCUGs2TnZTb1V6SjRBVTk5SjVSSEw3dUZN?=
 =?utf-8?B?ZHdCTGpDVDJFYXphTmRpNDdCVlhLY0JHYytqZGxFODNic3FwZEFLUGhRZmZF?=
 =?utf-8?Q?RrVXX2i6e0VZHm4UI1ogqWD5Wu99NOmE?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 13:11:30.0225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e8e3a53-b85c-4515-8d0f-08dcdb0812cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8092

On Sun, 22 Sep 2024 05:49:22 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

+Ben.

Forget to add you. My bad.=20
=20

> 1. Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> NVIDIA vGPU[1] software enables powerful GPU performance for workloads
> ranging from graphics-rich virtual workstations to data science and
> AI, enabling IT to leverage the management and security benefits of
> virtualization as well as the performance of NVIDIA GPUs required for
> modern workloads. Installed on a physical GPU in a cloud or enterprise
> data center server, NVIDIA vGPU software creates virtual GPUs that can
> be shared across multiple virtual machines.
>=20
> The vGPU architecture[2] can be illustrated as follow:
>=20
>  +--------------------+    +--------------------+
> +--------------------+ +--------------------+ | Hypervisor         |
>   | Guest VM           | | Guest VM           | | Guest VM
> | |                    |    | +----------------+ | |
> +----------------+ | | +----------------+ | | +----------------+ |
> | |Applications... | | | |Applications... | | | |Applications... | |
> | |  NVIDIA        | |    | +----------------+ | | +----------------+
> | | +----------------+ | | |  Virtual GPU   | |    |
> +----------------+ | | +----------------+ | | +----------------+ | |
> |  Manager       | |    | |  Guest Driver  | | | |  Guest Driver  | |
> | |  Guest Driver  | | | +------^---------+ |    | +----------------+
> | | +----------------+ | | +----------------+ | |        |
> |    +---------^----------+ +----------^---------+
> +----------^---------+ |        |           |              |
>              |                      | |        |
> +--------------+-----------------------+----------------------+---------+
> |        |                          |                       |
>              |         | |        |                          |
>                |                      |         |
> +--------+--------------------------+-----------------------+------------=
----------+---------+
> +---------v--------------------------+-----------------------+-----------=
-----------+----------+
> | NVIDIA                  +----------v---------+
> +-----------v--------+ +-----------v--------+ | | Physical GPU
>     |   Virtual GPU      | |   Virtual GPU      | |   Virtual GPU
>  | | |                         +--------------------+
> +--------------------+ +--------------------+ |
> +------------------------------------------------------------------------=
----------------------+
>=20
> Each NVIDIA vGPU is analogous to a conventional GPU, having a fixed
> amount of GPU framebuffer, and one or more virtual display outputs or
> "heads". The vGPU=E2=80=99s framebuffer is allocated out of the physical
> GPU=E2=80=99s framebuffer at the time the vGPU is created, and the vGPU
> retains exclusive use of that framebuffer until it is destroyed.
>=20
> The number of physical GPUs that a board has depends on the board.
> Each physical GPU can support several different types of virtual GPU
> (vGPU). vGPU types have a fixed amount of frame buffer, number of
> supported display heads, and maximum resolutions. They are grouped
> into different series according to the different classes of workload
> for which they are optimized. Each series is identified by the last
> letter of the vGPU type name.
>=20
> NVIDIA vGPU supports Windows and Linux guest VM operating systems. The
> supported vGPU types depend on the guest VM OS.
>=20
> 2. Proposal for upstream
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 2.1 Architecture
> ----------------
>=20
> Moving to the upstream, the proposed architecture can be illustrated
> as followings:
>=20
>                             +--------------------+
> +--------------------+ +--------------------+ | Linux VM           |
> | Windows VM         | | Guest VM           | | +----------------+ |
> | +----------------+ | | +----------------+ | | |Applications... | |
> | |Applications... | | | |Applications... | | | +----------------+ |
> | +----------------+ | | +----------------+ | ... |
> +----------------+ | | +----------------+ | | +----------------+ | |
> |  Guest Driver  | | | |  Guest Driver  | | | |  Guest Driver  | | |
> +----------------+ | | +----------------+ | | +----------------+ |
> +---------^----------+ +----------^---------+ +----------^---------+
> |                       |                      |
> +--------------------------------------------------------------------+
> |+--------------------+ +--------------------+
> +--------------------+| ||       QEMU         | |       QEMU
> | |       QEMU         || ||                    | |
>  | |                    || |+--------------------+
> +--------------------+ +--------------------+|
> +--------------------------------------------------------------------+
> |                       |                      |
> +------------------------------------------------------------------------=
-----------------------+
> |
> +----------------------------------------------------------------+  |
> |                           |                                VFIO
>                        |  | |                           |
>                                                    |  | |
> +-----------------------+ | +------------------------+
> +---------------------------------+|  | | |  Core Driver vGPU     | |
> |                        |  |                                 ||  | |
> |       Support        <--->|                       <---->
>                     ||  | | +-----------------------+ | | NVIDIA vGPU
> Manager    |  | NVIDIA vGPU VFIO Variant Driver ||  | | |    NVIDIA
> GPU Core    | | |                        |  |
>         ||  | | |        Driver         | |
> +------------------------+  +---------------------------------+|  | |
> +--------^--------------+
> +----------------------------------------------------------------+  |
> |          |                          |                       |
>                |          |
> +------------------------------------------------------------------------=
-----------------------+
> |                          |                       |
>     |
> +----------|--------------------------|-----------------------|----------=
------------|----------+
> |          v               +----------v---------+
> +-----------v--------+ +-----------v--------+ | |  NVIDIA
>      |       PCI VF       | |       PCI VF       | |       PCI VF
>   | | |  Physical GPU            |                    | |
>        | |                    | | |                          |
> (Virtual GPU)    | |   (Virtual GPU)    | |    (Virtual GPU)   | | |
>                         +--------------------+ +--------------------+
> +--------------------+ |
> +------------------------------------------------------------------------=
-----------------------+
>=20
> The supported GPU generations will be Ada which come with the
> supported GPU architecture. Each vGPU is backed by a PCI virtual
> function.
>=20
> The NVIDIA vGPU VFIO module together with VFIO sits on VFs, provides
> extended management and features, e.g. selecting the vGPU types,
> support live migration and driver warm update.
>=20
> Like other devices that VFIO supports, VFIO provides the standard
> userspace APIs for device lifecycle management and advance feature
> support.
>=20
> The NVIDIA vGPU manager provides necessary support to the NVIDIA vGPU
> VFIO variant driver to create/destroy vGPUs, query available vGPU
> types, select the vGPU type, etc.
>=20
> On the other side, NVIDIA vGPU manager talks to the NVIDIA GPU core
> driver, which provide necessary support to reach the HW functions.
>=20
> 2.2 Requirements to the NVIDIA GPU core driver
> ----------------------------------------------
>=20
> The primary use case of CSP and enterprise is a standalone minimal
> drivers of vGPU manager and other necessary components.
>=20
> NVIDIA vGPU manager talks to the NVIDIA GPU core driver, which provide
> necessary support to:
>=20
> - Load the GSP firmware, boot the GSP, provide commnication channel.
> - Manage the shared/partitioned HW resources. E.g. reserving FB
> memory, channels for the vGPU mananger to create vGPUs.
> - Exception handling. E.g. delivering the GSP events to vGPU manager.
> - Host event dispatch. E.g. suspend/resume.
> - Enumerations of HW configuration.
>=20
> The NVIDIA GPU core driver, which sits on the PCI device interface of
> NVIDIA GPU, provides support to both DRM driver and the vGPU manager.
>=20
> In this RFC, the split nouveau GPU driver[3] is used as an example to
> demostrate the requirements of vGPU manager to the core driver. The
> nouveau driver is split into nouveau (the DRM driver) and nvkm (the
> core driver).
>=20
> 3 Try the RFC patches
> -----------------------
>=20
> The RFC supports to create one VM to test the simple GPU workload.
>=20
> - Host kernel:
> https://github.com/zhiwang-nvidia/linux/tree/zhi/vgpu-mgr-rfc
> - Guest driver package: NVIDIA-Linux-x86_64-535.154.05.run [4]
>=20
>   Install guest driver:
>   # export GRID_BUILD=3D1
>   # ./NVIDIA-Linux-x86_64-535.154.05.run
>=20
> - Tested platforms: L40.
> - Tested guest OS: Ubutnu 24.04 LTS.
> - Supported experience: Linux rich desktop experience with simple 3D
>   workload, e.g. glmark2
>=20
> 4 Demo
> ------
>=20
> A demo video can be found at: https://youtu.be/YwgIvvk-V94
>=20
> [1] https://www.nvidia.com/en-us/data-center/virtual-solutions/
> [2]
> https://docs.nvidia.com/vgpu/17.0/grid-vgpu-user-guide/index.html#archite=
cture-grid-vgpu
> [3]
> https://lore.kernel.org/dri-devel/20240613170211.88779-1-bskeggs@nvidia.c=
om/T/
> [4]
> https://us.download.nvidia.com/XFree86/Linux-x86_64/535.154.05/NVIDIA-Lin=
ux-x86_64-535.154.05.run
>=20
> Zhi Wang (29):
>   nvkm/vgpu: introduce NVIDIA vGPU support prelude
>   nvkm/vgpu: attach to nvkm as a nvkm client
>   nvkm/vgpu: reserve a larger GSP heap when NVIDIA vGPU is enabled
>   nvkm/vgpu: set the VF partition count when NVIDIA vGPU is enabled
>   nvkm/vgpu: populate GSP_VF_INFO when NVIDIA vGPU is enabled
>   nvkm/vgpu: set RMSetSriovMode when NVIDIA vGPU is enabled
>   nvkm/gsp: add a notify handler for GSP event
>     GPUACCT_PERFMON_UTIL_SAMPLES
>   nvkm/vgpu: get the size VMMU segment from GSP firmware
>   nvkm/vgpu: introduce the reserved channel allocator
>   nvkm/vgpu: introduce interfaces for NVIDIA vGPU VFIO module
>   nvkm/vgpu: introduce GSP RM client alloc and free for vGPU
>   nvkm/vgpu: introduce GSP RM control interface for vGPU
>   nvkm: move chid.h to nvkm/engine.
>   nvkm/vgpu: introduce channel allocation for vGPU
>   nvkm/vgpu: introduce FB memory allocation for vGPU
>   nvkm/vgpu: introduce BAR1 map routines for vGPUs
>   nvkm/vgpu: introduce engine bitmap for vGPU
>   nvkm/vgpu: introduce pci_driver.sriov_configure() in nvkm
>   vfio/vgpu_mgr: introdcue vGPU lifecycle management prelude
>   vfio/vgpu_mgr: allocate GSP RM client for NVIDIA vGPU manager
>   vfio/vgpu_mgr: introduce vGPU type uploading
>   vfio/vgpu_mgr: allocate vGPU FB memory when creating vGPUs
>   vfio/vgpu_mgr: allocate vGPU channels when creating vGPUs
>   vfio/vgpu_mgr: allocate mgmt heap when creating vGPUs
>   vfio/vgpu_mgr: map mgmt heap when creating a vGPU
>   vfio/vgpu_mgr: allocate GSP RM client when creating vGPUs
>   vfio/vgpu_mgr: bootload the new vGPU
>   vfio/vgpu_mgr: introduce vGPU host RPC channel
>   vfio/vgpu_mgr: introduce NVIDIA vGPU VFIO variant driver
>=20
>  .../drm/nouveau/include/nvkm/core/device.h    |   3 +
>  .../drm/nouveau/include/nvkm/engine/chid.h    |  29 +
>  .../gpu/drm/nouveau/include/nvkm/subdev/gsp.h |   1 +
>  .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  45 ++
>  .../nvidia/inc/ctrl/ctrl2080/ctrl2080gpu.h    |  12 +
>  drivers/gpu/drm/nouveau/nvkm/Kbuild           |   1 +
>  drivers/gpu/drm/nouveau/nvkm/device/pci.c     |  33 +-
>  .../gpu/drm/nouveau/nvkm/engine/fifo/chid.c   |  49 +-
>  .../gpu/drm/nouveau/nvkm/engine/fifo/chid.h   |  26 +-
>  .../gpu/drm/nouveau/nvkm/engine/fifo/r535.c   |   3 +
>  .../gpu/drm/nouveau/nvkm/subdev/gsp/r535.c    |  14 +-
>  drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild  |   3 +
>  drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c  | 302 +++++++++++
>  .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 234 ++++++++
>  drivers/vfio/pci/Kconfig                      |   2 +
>  drivers/vfio/pci/Makefile                     |   2 +
>  drivers/vfio/pci/nvidia-vgpu/Kconfig          |  13 +
>  drivers/vfio/pci/nvidia-vgpu/Makefile         |   8 +
>  drivers/vfio/pci/nvidia-vgpu/debug.h          |  18 +
>  .../nvidia/inc/ctrl/ctrl0000/ctrl0000system.h |  30 +
>  .../nvidia/inc/ctrl/ctrl2080/ctrl2080gpu.h    |  33 ++
>  .../ctrl/ctrl2080/ctrl2080vgpumgrinternal.h   | 152 ++++++
>  .../common/sdk/nvidia/inc/ctrl/ctrla081.h     | 109 ++++
>  .../nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h | 213 ++++++++
>  .../common/sdk/nvidia/inc/nv_vgpu_types.h     |  51 ++
>  .../common/sdk/vmioplugin/inc/vmioplugin.h    |  26 +
>  .../pci/nvidia-vgpu/include/nvrm/nvtypes.h    |  24 +
>  drivers/vfio/pci/nvidia-vgpu/nvkm.h           |  94 ++++
>  drivers/vfio/pci/nvidia-vgpu/rpc.c            | 242 +++++++++
>  drivers/vfio/pci/nvidia-vgpu/vfio.h           |  43 ++
>  drivers/vfio/pci/nvidia-vgpu/vfio_access.c    | 297 ++++++++++
>  drivers/vfio/pci/nvidia-vgpu/vfio_main.c      | 511
> ++++++++++++++++++ drivers/vfio/pci/nvidia-vgpu/vgpu.c           |
> 352 ++++++++++++ drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       | 144
> +++++ drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  89 +++
>  drivers/vfio/pci/nvidia-vgpu/vgpu_types.c     | 466 ++++++++++++++++
>  include/drm/nvkm_vgpu_mgr_vfio.h              |  61 +++
>  37 files changed, 3702 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/gpu/drm/nouveau/include/nvkm/engine/chid.h
>  create mode 100644
> drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h create mode
> 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild create mode
> 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c create mode
> 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c create mode
> 100644 drivers/vfio/pci/nvidia-vgpu/Kconfig create mode 100644
> drivers/vfio/pci/nvidia-vgpu/Makefile create mode 100644
> drivers/vfio/pci/nvidia-vgpu/debug.h create mode 100644
> drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl=
0000/ctrl0000system.h
> create mode 100644
> drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl=
2080/ctrl2080gpu.h
> create mode 100644
> drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl=
2080/ctrl2080vgpumgrinternal.h
> create mode 100644
> drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl=
a081.h
> create mode 100644
> drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/dev_vgpu_=
gsp.h
> create mode 100644
> drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/nv_vgpu_t=
ypes.h
> create mode 100644
> drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/vmioplugin/inc/vmiop=
lugin.h
> create mode 100644
> drivers/vfio/pci/nvidia-vgpu/include/nvrm/nvtypes.h create mode
> 100644 drivers/vfio/pci/nvidia-vgpu/nvkm.h create mode 100644
> drivers/vfio/pci/nvidia-vgpu/rpc.c create mode 100644
> drivers/vfio/pci/nvidia-vgpu/vfio.h create mode 100644
> drivers/vfio/pci/nvidia-vgpu/vfio_access.c create mode 100644
> drivers/vfio/pci/nvidia-vgpu/vfio_main.c create mode 100644
> drivers/vfio/pci/nvidia-vgpu/vgpu.c create mode 100644
> drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c create mode 100644
> drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h create mode 100644
> drivers/vfio/pci/nvidia-vgpu/vgpu_types.c create mode 100644
> include/drm/nvkm_vgpu_mgr_vfio.h
>=20


