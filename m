Return-Path: <kvm+bounces-56833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B817B440DA
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 17:44:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3460EA42D48
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 15:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAD928134C;
	Thu,  4 Sep 2025 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Cua2O8Iz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3AD26B955
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757000646; cv=fail; b=AD96XRLbQD8ct1005/LZpYlYKfNSmsojeohq3mV2M4YahHa/9jZNGt4QBAx0/opAojFbYvF7CdA/avkosyzhFDCdES4ZXZY2gGcqLcmFY8ZVxtg+78PKsBQVDj2yWLV7kOmyBNK7JFsWYQCnIzmpHtkKqAbUpAjmJAU5vuyRpUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757000646; c=relaxed/simple;
	bh=wC8XWrr8X/ikcYXPEJ7gme050sXW2ptEIvpdoqdJgSw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N5QgC4jTsdKkE3PohM/ImG6d1IhiV1NjclBvvyTJmSPx3/s/wxf8c38f05CDarfuzXRAJsetc076hJstxrIJSIe/njTAKQOBAA3vbQRqVyoGYVNlzGn/YyJx6v1E89GYCwXFOTAwzhd6a+NIh2WZUNtvZ5Tvub3avgBYQWBnL18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Cua2O8Iz; arc=fail smtp.client-ip=40.107.243.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WsTU0ioA/da5iQ2CXAqo5/hTvaR0+DSoyyrcNjPN8rDzy1ZS+muMtbcw2YHy/Z2nvkMAn6nCMRuIgu2ixUxC340Gnekdmuss7VHFOYCYuM28aS7yAoz45nM7liJXzISPw5JssK9V/MLgvcJNlTyg+JvLunogkxDF+boDYLoTXEUNTMy8WpKyTjJg9X779+6fk4ydkQM2hH0rQZFYPFCAd3JmyJGI6nqgikHAVv3iVQZ1qnourrP0aF4zpVQM/Oo3sKRO+p0clQjpgbdDM0ViGt1l9/Q435Eyp5ZonmrFeWdiltklWZn4nNuUUrC6kJHLa3mWP1M5AtCQaZ/CJHUKBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JvniuTair3uIaDX9vZaq0o/QqMvWGBv8YuMIFoUhz9E=;
 b=u5NpcUKQQeKT8Or7luZc+7FnWc/HYbj54NSKlBnrMbXFDaghMQJkV3Ok4s9tIO/g1jRrvV8hf6MXnWvNLzIU/W4Co/1rl30L1w75/nYleMS5SLkeuzkyhPC3PTcIYQb4ebb5qbES7r0pnDLAHWXeQcKml+LRrrfHx/IRkITtQE7HO6/+guFUzpNFgVN2sitUHB0zDc/8oVumZ6YExRsOMdM/1ZqTQanfZhtQyF0QiwXKTNjtYJTxZ9GxjWL8tf9c5V1ab9QeA1SiEoc6FSyPcKlX5yri6xe6RFPIHVkqv8i9Tl2Sa2WwWSn7JtA4lHkVacwHIBiPSM2rWkMQ2jjoEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvniuTair3uIaDX9vZaq0o/QqMvWGBv8YuMIFoUhz9E=;
 b=Cua2O8Izl/gY7HFPgYc+Ah3NxIuR9Oqc5gQSTB1Amyn8ekhsTb+oB+W8JVhs6pwwPZQop3xDmiqXq+Frc6zfeDvpOYMteVL4RPf1A2W7XN4DIK76zSq9yICtTmHXCJAF3/LAy8AQOUnYifuV42CoKHZpLglxIPxIQdUPiAl8IqZFCtgXGCx0Ie/7PAx5T1P8uDlmzKZZ9WW9p+XrafSz7vmC5Wy2aT1i1xjr8Vr3pVEBGt7zW9uwLVoxdoFbSVy7DsE+ItFdsErMY/9OtS4x/S9ZjkBFcn5nJ0wkInaKQmAQZH3UkCPquI9+Ro0X9Bil1OuhMip2QKhJA7VV1tZ/fw==
Received: from BY3PR03CA0028.namprd03.prod.outlook.com (2603:10b6:a03:39a::33)
 by DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 15:43:58 +0000
Received: from SJ5PEPF000001D0.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::8a) by BY3PR03CA0028.outlook.office365.com
 (2603:10b6:a03:39a::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Thu,
 4 Sep 2025 15:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D0.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 15:43:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 4 Sep
 2025 08:43:33 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 4 Sep
 2025 08:43:32 -0700
Received: from localhost (10.127.8.9) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Thu, 4 Sep 2025
 08:43:26 -0700
Date: Thu, 4 Sep 2025 17:43:24 +0200
From: Zhi Wang <zhiw@nvidia.com>
To: Danilo Krummrich <dakr@kernel.org>
CC: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <jgg@nvidia.com>, <airlied@gmail.com>,
	<daniel@ffwll.ch>, <acurrid@nvidia.com>, <cjia@nvidia.com>,
	<smitra@nvidia.com>, <ankita@nvidia.com>, <aniketa@nvidia.com>,
	<kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiwang@kernel.org>,
	<acourbot@nvidia.com>, <joelagnelf@nvidia.com>, <apopple@nvidia.com>,
	<jhubbard@nvidia.com>, <nouveau@lists.freedesktop.org>
Subject: Re: [RFC v2 03/14] vfio/nvidia-vgpu: introduce vGPU type uploading
Message-ID: <20250904174213.00003c38@nvidia.com>
In-Reply-To: <DCJX0ZBB1ATN.1WPXONLVV8RYD@kernel.org>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
	<20250903221111.3866249-4-zhiw@nvidia.com>
	<DCJWXVLI2GWB.3UBHWIZCZXKD2@kernel.org>
	<DCJX0ZBB1ATN.1WPXONLVV8RYD@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D0:EE_|DM6PR12MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 01bfaa70-dc0a-4aab-3c78-08ddebc9dcfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NztsJYPxSV0JsrTAVC8d5Xt4fcMZGGCNfHucf3tx+dARbQzX4SAkPiRgoRkh?=
 =?us-ascii?Q?84ca1jbQkIabE5BXvj2xVklWABlvelsp1gMYletb5IlInjQoPJUsymg2a1SX?=
 =?us-ascii?Q?k4rdGnoNapuSni2C19DjzxHrSK5rwSPkz04nRLweDD410xBwI0Qg1HILaDlR?=
 =?us-ascii?Q?KjAmBbYrSSpVsaEBhvrXKu75PNFPpKDv8KtcP2B/1LGbzq3jeO3K4oHpQQuT?=
 =?us-ascii?Q?MZrhdKaicOFP/YR4rku0UzYu5BjX6zw6Zbh2qHHtw4Vn7zSZ922DoZpgb/E1?=
 =?us-ascii?Q?gNyQXoFcMcS53Rn7oJtrtamyhO+iRiSUjUAInWsbcItiCo/Eui7kFewh1K7L?=
 =?us-ascii?Q?Wu5KcDaFvfkgU8nd3ytAPrdol5XXpCfrPVKzT2uPfdl/+7Y7jmN7DUN4ntI5?=
 =?us-ascii?Q?Eja9CVdrK1+BOsZZ7u2zuCkkegj4IrszgJFvHZfsinkXuNht7FCT2jznAd+r?=
 =?us-ascii?Q?7ZXNryi9cDd+qTbVunZ+7G8TUUFSXg/q6kqHeFPOEONmTa7HtFUc+4moJCmE?=
 =?us-ascii?Q?BvRg/+q0D/wWGak5/3MZGEHinKuTpyYZdqB1cw8GF0jjLBpNmo+B+aixlTB7?=
 =?us-ascii?Q?hot18ygmYbJ29SOgxoh8YQxZhUSkYuNzXQVxjHc2bR1TdrouTHoF5Zafeznv?=
 =?us-ascii?Q?0YkLbcavcYAFa5G1FNDr+FqnWq8fAm+2eluQafFMGqqW8CX9ec0vRRsxLqAH?=
 =?us-ascii?Q?bKGFzUmCcGh1q1FujsK9r3phv+PzwNdE6tR9nxTERwxS2biXGrFKWg63HIJp?=
 =?us-ascii?Q?/qnHpcVve3gLr4cojN5WOBjcCSn9ES3Geb7v5P/6blLkcjlnsSWtSJbcIpT8?=
 =?us-ascii?Q?2htYf3e9KaWvi55YXLfUyK18R/r0D/aO0HgvygY/rYV6nyO2vkWzdP3p6E9s?=
 =?us-ascii?Q?ztF1Cm71CgU7iOpsAJy6yu1h1NZfcYaHV8uLsKcR8nHDvtj4UqTecUxuLadu?=
 =?us-ascii?Q?BzwITIi6tcMMS4uaFtw/plmV9JpjIZl+J+Q3W4zI0EfgS3gVGgIIlNz7Jjl6?=
 =?us-ascii?Q?paywv88nzHrlJqnfWv9BdJEFBSl0aeo+dLDVhQmE337qnkiLOoxhfzDUJtEk?=
 =?us-ascii?Q?3HzgLDiL5Eg/6fPHW/lq6NMzL5ytKSkKidf8WVstPjD0YwcyCOj/l9IceHvh?=
 =?us-ascii?Q?YvL0jdvRBHwa1qPv1PrzqgHrp4ee2cPhJLQbuNvYUlk33zbGYq8pgS3+EvcH?=
 =?us-ascii?Q?tl1hTFaPplEKs0cU6zGdGYsfR5aePGIBhW5sNcUQiZQ7TABnk8I7gGy6F1JG?=
 =?us-ascii?Q?rfWlnsMz20gATiyLgG4/1pPnEXHUyb6fEad5z0MerImeAbuYUcJviQyo2NFY?=
 =?us-ascii?Q?7C+8p3qvk9iVBedd2fOC+im8+45XJP2CPlAXNHABQoJ0GBYFsH3qflj9SGDS?=
 =?us-ascii?Q?I2E2qqjIGDDiriASf8DaxgJYzKczOwIbdpwN/Tnu6znH9XXYEiO0Bb16COuL?=
 =?us-ascii?Q?mObXZnhFvPZwZ3Fit67xIlVZB2kMkZEBuAk8i/sxe8GSXbDehRDpGQMW5VqK?=
 =?us-ascii?Q?rFwATdqqWzyLgWU+tjhG62H2bS4Nh7ZzTf+F5GoOnkEaV8atvZQwocdmZA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 15:43:58.3647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01bfaa70-dc0a-4aab-3c78-08ddebc9dcfc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4170

On Thu, 04 Sep 2025 11:41:03 +0200
"Danilo Krummrich" <dakr@kernel.org> wrote:

> (Cc: Alex, John, Joel, Alistair, nouveau)
> 
> On Thu Sep 4, 2025 at 11:37 AM CEST, Danilo Krummrich wrote:
> > On Thu Sep 4, 2025 at 12:11 AM CEST, Zhi Wang wrote:
> >> diff --git a/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h
> >> new file mode 100644
> >> index 000000000000..c3fb7b299533
> >> --- /dev/null
> >> +++ b/drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h
> >> @@ -0,0 +1,18 @@
> >> +/* SPDX-License-Identifier: MIT */
> >> +#ifndef __NVRM_GSP_H__
> >> +#define __NVRM_GSP_H__
> >> +
> >> +#include <nvrm/nvtypes.h>
> >> +
> >> +/* Excerpt of RM headers from https://github.com/NVIDIA/open-gpu-kernel-modules/tree/570 */
> >> +
> >> +#define NV2080_CTRL_CMD_GSP_GET_FEATURES (0x20803601)
> >> +
> >> +typedef struct NV2080_CTRL_GSP_GET_FEATURES_PARAMS {
> >> +	NvU32  gspFeatures;
> >> +	NvBool bValid;
> >> +	NvBool bDefaultGspRmGpu;
> >> +	NvU8   firmwareVersion[GSP_MAX_BUILD_VERSION_LENGTH];
> >> +} NV2080_CTRL_GSP_GET_FEATURES_PARAMS;
> >> +
> >> +#endif
> >
> > <snip>
> >

The RFC v2 is based on the same architecture of RFC V1 but switching the
core driver from NVKM to nova-core. Yet the new architecture and auxiliary
bus is WIP. So it doesn't represent the final picture, e.g. the rust code
I wrote in the nova-core. The main idea is to demonstrate the progress
of the vGPU development.

> >> +static struct version supported_version_list[] = {
> >> +	{ 18, 1, "570.144" },
> >> +};
> >
> > nova-core won't provide any firmware specific APIs, it is meant to serve as a
> > hardware and firmware abstraction layer for higher level drivers, such as vGPU
> > or nova-drm.
> >
> > As a general rule the interface between nova-core and higher level drivers must
> > not leak any hardware or firmware specific details, but work on a higher level
> > abstraction layer.
> >

It is more a matter of where we are going to place vGPU specific
functionality in the whole picture. In this case, if we are thinking about
the requirement of vGPU type loading, which requires the GSP version
number and checking. Are we leaning towards putting some vGPU specific
functionality also in nova-core?

Regarding not leaking any of the hardware details, is that doable? 
Looking at {nv04 * _fence}.c {chan*}.c in the current NVIF interfaces, I
think we will expose the HW concept somehow.

> > Now, I recognize that at some point it might be necessary to do some kind of
> > versioning in this API anyways. For instance, when the semantics of the firmware
> > API changes too significantly.
> >
> > However, this would be a separte API where nova-core, at the initial handshake,
> > then asks clients to use e.g. v2 of the nova-core API, still hiding any firmware
> > and hardware details from the client.
> >
> > Some more general notes, since I also had a look at the nova-core <-> vGPU
> > interface patches in your tree (even though I'm aware that they're not part of
> > the RFC of course):
> >
> > The interface for the general lifecycle management for any clients attaching to
> > nova-core (VGPU, nova-drm) should be common and not specific to vGPU. (The same
> > goes for interfaces that will be used by vGPU and nova-drm.)
> >
> > The interface nova-core provides for that should be designed in Rust, so we can
> > take advantage of all the features the type system provides us with connecting
> > to Rust clients (nova-drm).
> >
> > For vGPU, we can then monomorphize those types into the corresponding C
> > structures and provide the corresponding functions very easily.
> >
> > Doing it the other way around would be a very bad idea, since the Rust type
> > system is much more powerful and hence it'd be very hard to avoid introducing
> > limitations on the Rust side of things.
> >
> > Hence, I recommend to start with some patches defining the API in nova-core for
> > the general lifecycle (in Rust), so we can take it from there.
> >
> > Another note: I don't see any use of the auxiliary bus in vGPU, any clients
> > should attach via the auxiliary bus API, it provides proper matching where
> > there's more than on compatible GPU in the system. nova-core already registers
> > an auxiliary device for each bound PCI device.
> >
> > Please don't re-implement what the auxiliary bus already does for us.
> >
> > - Danilo
> 
> 


