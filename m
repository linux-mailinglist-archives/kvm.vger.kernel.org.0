Return-Path: <kvm+bounces-46320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC8FAB50EE
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80BB0188E1AE
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06E024466C;
	Tue, 13 May 2025 10:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Aa++FkZ3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321BA239E76;
	Tue, 13 May 2025 10:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130619; cv=fail; b=cHHFi8Mj2V/TzRNT2pov9g+b+7UjuMcO19yYMkO0MKhsJDOTD0qs4xtPlvd8rACk2gd3nstHNO/u2A2jvwHErKgLikdAQLzFm+VQYETac/RwCZUXmiVCdQtdGNgoiA92WCj72MiKL2esvBTUbxUmIv6HPBt61Mqf174ha+T7m1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130619; c=relaxed/simple;
	bh=Yzk0QWfAN2OR4a259aYE6qQ7N1ZEOe8wWjRZJNkYAHw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oqO6AlUmxlXxPczTQFvZSCHBPVHJr94P9f786RNY2U24Y4blmHAoyGsJbVPyZ8BkRc4+pd55f7+gqzwhswjW7y7+xfqtsQT/UCYnGYTRL/7VD1Pbkdjf/kJrS0f3ftuRwd3jV9TjxUOVOoVxbf2orBlohXSGdXn5MnhS/5ucuy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Aa++FkZ3; arc=fail smtp.client-ip=40.107.94.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jG3qt3hZWek46HEC9STrzKH2CWs/wUKJaSA7D95vk4VTDfT//EB/sLLVBR+YVODeY+fLV/gpDKhSFd7AC8Hl4K++4ZKxSVlaUZsVCSV45KgyP2Bz5kNjSNqeVDiZpefulArGk+/A4yTkNDNlhXQii3wGSWLdJLKsUTCNKdpSaGobFeMZjsxsJzFv2+PtcgGvk0TY2iIe68B0l0z/Uh6Xxd9bzMWUFBt+2BhFhnZcC9OuPXCUF2N9QS+ETzLkxRcKzw3WqX4nz7Irc2fxBW99zo/agKHwrQeZnchNoJdh+oIiwKxZfBWG68sOHWZakbflAyylOldaptVbF5KvIMTSHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gaRObd/VWs1UcjVD7ye9pl5tS6hdkHEnfs4rsHAcpHI=;
 b=r1uPCNmUmIm4tom1OSg6m1ErVFLHQ5ZrrNjkXZWtO4xQCFX4au0EVA/mpPySp2LM0u7TEPaTGNonkSlCFZ7mE+TIw0N3GeLg5XmfpTW4r60I5U23AXfWcjzkEhjdOw9JTrGmYFuyrePK6MS1bY75NET8Oug6aDD4RW+3aOYqFt5OLAFPPQxVaRRD3Vqa6FPIM2gVQQyMR4sPXrwywK1bzaYONZyyJ12Mw8usp1SB/bVeYQ2NYGCyicBwI5E7BorW3ITMtMPToqu9FN3vNa8hKWseUBV7UCuydhEo6MBuFHnYWoKJv5y8/mmo6XGYliKBJuMpfOihZJR+vipIDgVRZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaRObd/VWs1UcjVD7ye9pl5tS6hdkHEnfs4rsHAcpHI=;
 b=Aa++FkZ3N6hnjcCokh6AoYXGrio1pA6TKNt3Frcuete+s6255sUwel6LQBAEx9G3UNRoA+pEriqFPNtUkLXTkTtAH8EBftuA4U55RmQM7Q43rYitg1sfTk+5D+wZIC+Dxa7ZqoI2TkJ3/zrLJd7jkEBwjQqtf3WbKbuTr7TcwqbrLSzkaReVU1HkUXimJiBEI9yqA2OSZDrAA9Lzexocw95gWQch657W4cuLl8frmmu3MOxBKwPc3hUgYZ5Ao+VlzArB27iHKplbuQoq8tHrtJzWDDdhG0h0aM3pMwHqls6W4A0PPVNZNVK/5wIh5B4yh0BcxwsakTrmWcUeK1RbRw==
Received: from PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::19)
 by DS7PR12MB6311.namprd12.prod.outlook.com (2603:10b6:8:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 10:03:32 +0000
Received: from SJ1PEPF000023DA.namprd21.prod.outlook.com
 (2603:10b6:510:d3:cafe::1) by PH0P220CA0016.outlook.office365.com
 (2603:10b6:510:d3::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.28 via Frontend Transport; Tue,
 13 May 2025 10:03:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000023DA.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.1 via Frontend Transport; Tue, 13 May 2025 10:03:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 13 May
 2025 03:03:21 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 13 May
 2025 03:03:21 -0700
Received: from inno-thin-client (10.127.8.11) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Tue, 13
 May 2025 03:03:16 -0700
Date: Tue, 13 May 2025 13:03:15 +0300
From: Zhi Wang <zhiw@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	<kvm@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linux-media@vger.kernel.org>, <linaro-mm-sig@lists.linaro.org>,
	<sumit.semwal@linaro.org>, <christian.koenig@amd.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <alex.williamson@redhat.com>,
	<vivek.kasireddy@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@intel.com>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <lukas@wunner.de>, <yan.y.zhao@intel.com>,
	<daniel.vetter@ffwll.ch>, <leon@kernel.org>, <baolu.lu@linux.intel.com>,
	<zhenzhong.duan@intel.com>, <tao1.su@intel.com>
Subject: Re: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Message-ID: <20250513130315.0158a626.zhiw@nvidia.com>
In-Reply-To: <20250512140617.GA285583@nvidia.com>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
	<371ab632-d167-4720-8f0d-57be1e3fee84@amd.com>
	<4b6dc759-86fd-47a7-a206-66b25a0ccc6d@amd.com>
	<c10bf9c2-e073-479d-ad1c-6796c592d333@amd.com>
	<aB3jLmlUKKziwdeG@yilunxu-OptiPlex-7050>
	<aB4tQHmHzHooDeTE@yilunxu-OptiPlex-7050>
	<20250509184318.GD5657@nvidia.com>
	<aB7Ma84WXATiu5O1@yilunxu-OptiPlex-7050>
	<2c4713b0-3d6c-4705-841b-1cb58cd9a0f5@amd.com>
	<20250512140617.GA285583@nvidia.com>
Organization: NVIDIA
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023DA:EE_|DS7PR12MB6311:EE_
X-MS-Office365-Filtering-Correlation-Id: ab41a2ea-b404-49b8-8b3c-08dd92056b04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FBTRgrdUa0Lxh/Xzv9W87W2IrSm8hADYDkDTZgWQO2Fjoqj94ZGT5jcsun7f?=
 =?us-ascii?Q?Xz/iHR3fxcEwkRJq8zlWbGdeHqKyfBrHuFvRLd8J77SwrXYFAyzgHQgr1dJM?=
 =?us-ascii?Q?dx8a+RZvBMH6/qdDGclf9stdKN6lZLVqy2fMXYmun0/ILGyiFbLa1vxoYF4r?=
 =?us-ascii?Q?s7K5LDAeyN4qBD0d1SF3v/sMJ3+MJN7AoEtVYFiwMHn0yCjkJn3bMuavDstz?=
 =?us-ascii?Q?mGCCRvLsEo+AhfDGcrk9HOcyYGiEKyg1hsMBqOoGO9yh+0sOPX7UDD1x7AQ2?=
 =?us-ascii?Q?f95EXU4CDaD2oDRoNMuFZihUL0P3+/KEB9jDGKbiBQFHCANcttz2LGs9sE6e?=
 =?us-ascii?Q?fUV0m3AApF+2YejhPcMetpu60XnMXjfG1QbVbYcSnCz7NwezJBfa+xuHPYLv?=
 =?us-ascii?Q?3YFsFyoKX2Z9U2GWiHmih821aiVo+wiEZL+MZzrpXmuSb62PRmL4t56/opRF?=
 =?us-ascii?Q?VWGbaYc/yszVi6JrkUH0fprI1k7Vmu9uLwAdEciMsY4tCdYCFZguAlXPidpu?=
 =?us-ascii?Q?m2wQudVjM/i5QQ361qDyW1Kd3JQummIn7mTS2X7vPAA8qLWWDTHUpSkqR4KC?=
 =?us-ascii?Q?vk/sd7E/Qb1UQcNj3v4kg2qfVWlA4KvzemCQ1Oh1mJEy6kSCJ93oFCL2rLm4?=
 =?us-ascii?Q?nsmeHe9GOOb0Y43Q2EX2tMZwS432P8RomM9g/VbCgS3oxsV9cms3fa1IMd6y?=
 =?us-ascii?Q?PhcyK5iI7ld+AdIslGE0dLI0WuWkA1tdVNijQeJSu9qNPdLDarC0C58IL1At?=
 =?us-ascii?Q?mEWoHRe5PUKWKU1ogLAwR0Um47pbkaPEGuk1hK0flDPlte+hunxH+lujCF25?=
 =?us-ascii?Q?kn0cJhILpP+LjMyIINMmv7mj+y8iNhgA+JMG8NhiRMf6UR9rmbAekplfy9PV?=
 =?us-ascii?Q?+xPoW3RXhY9CYfcx1iIoqqK5JBS6P5ZDFlVAN34JSWFUIzhbrpsx7Vyvl6XP?=
 =?us-ascii?Q?Ji1Qoc6uXzTFJ//TRvxCDdTLKGR8MrFiIGQat5IcUdGjgBQX24FxNvTx5kwY?=
 =?us-ascii?Q?joaou6v2evInAWr/u71vVpWTx1VgbwhvqBeeU/qhhh4g/1qBG0RdesDhs9P4?=
 =?us-ascii?Q?cPK43o5c+Y/2qCDVsL+2Ca0RNEVQgjw+A53NFX9CBmntVtZATni0ksMT8IAw?=
 =?us-ascii?Q?Jrp+Ow9yuscgYFM4zdsKhW98iQwnnoA+XZM2GYKdToiFNdW8LVTIgcWyp5hX?=
 =?us-ascii?Q?BC/EUbZcgIYROH0He/pj9TJRG/M3CIzASEtMbZN98clMOfMjzqQI9/GMddm9?=
 =?us-ascii?Q?CwPiBCoCOFVHqFFk9XkeDhAmGsjQo2uG7fVeus9xaOSnLRUZcTnpyfBQ+rVj?=
 =?us-ascii?Q?hwoZXmKY+r9i3pQcyVZCRZIdB/F+5MahYzCUXczecD1h5eaTQDKRYAfJAzVs?=
 =?us-ascii?Q?djuFVeLPu7IsbF03zXtTg5OBipU2JKfsS3kW7BKG3xCsesxVpFTiq/VrZNJL?=
 =?us-ascii?Q?K0YFxdzKclSkYtd3MOln5D1mkWbthZ0Y8HNuyTcCaO73QAbULyjUT/Plw4xU?=
 =?us-ascii?Q?5k9Fsw2T1+ligEV/AJFZtbrXyGIfw3xmK2Fa?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 10:03:32.3387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab41a2ea-b404-49b8-8b3c-08dd92056b04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6311

On Mon, 12 May 2025 11:06:17 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, May 12, 2025 at 07:30:21PM +1000, Alexey Kardashevskiy wrote:
> 
> > > > I'm surprised by this.. iommufd shouldn't be doing PCI stuff,
> > > > it is just about managing the translation control of the device.
> > > 
> > > I have a little difficulty to understand. Is TSM bind PCI stuff?
> > > To me it is. Host sends PCI TDISP messages via PCI DOE to put the
> > > device in TDISP LOCKED state, so that device behaves differently
> > > from before. Then why put it in IOMMUFD?
> > 
> > 
> > "TSM bind" sets up the CPU side of it, it binds a VM to a piece of
> > IOMMU on the host CPU. The device does not know about the VM, it
> > just enables/disables encryption by a request from the CPU (those
> > start/stop interface commands). And IOMMUFD won't be doing DOE, the
> > platform driver (such as AMD CCP) will. Nothing to do for VFIO here.
> > 
> > We probably should notify VFIO about the state transition but I do
> > not know VFIO would want to do in response.
> 
> We have an awkward fit for what CCA people are doing to the various
> Linux APIs. Looking somewhat maximally across all the arches a "bind"
> for a CC vPCI device creation operation does:
> 
>  - Setup the CPU page tables for the VM to have access to the MMIO
>  - Revoke hypervisor access to the MMIO
>  - Setup the vIOMMU to understand the vPCI device
>  - Take over control of some of the IOVA translation, at least for
> T=1, and route to the the vIOMMU
>  - Register the vPCI with any attestation functions the VM might use
>  - Do some DOE stuff to manage/validate TDSIP/etc
> 
> So we have interactions of things controlled by PCI, KVM, VFIO, and
> iommufd all mushed together.
> 
> iommufd is the only area that already has a handle to all the required
> objects:
>  - The physical PCI function
>  - The CC vIOMMU object
>  - The KVM FD
>  - The CC vPCI object
> 
> Which is why I have been thinking it is the right place to manage
> this.
> 
> It doesn't mean that iommufd is suddenly doing PCI stuff, no, that
> stays in VFIO.
> 
> > > > So your issue is you need to shoot down the dmabuf during vPCI
> > > > device destruction?
> > > 
> > > I assume "vPCI device" refers to assigned device in both shared
> > > mode & prvate mode. So no, I need to shoot down the dmabuf during
> > > TSM unbind, a.k.a. when assigned device is converting from
> > > private to shared. Then recover the dmabuf after TSM unbind. The
> > > device could still work in VM in shared mode.
> 
> What are you trying to protect with this? Is there some intelism where
> you can't have references to encrypted MMIO pages?
> 

I think it is a matter of design choice. The encrypted MMIO page is
related to the TDI context and secure second level translation table
(S-EPT). and S-EPT is related to the confidential VM's context.

AMD and ARM have another level of HW control, together
with a TSM-owned meta table, can simply mask out the access to those
encrypted MMIO pages. Thus, the life cycle of the encrypted mappings in
the second level translation table can be de-coupled from the TDI
unbound. They can be reaped un-harmfully later by hypervisor in another
path.

While on Intel platform, it doesn't have that additional level of
HW control by design. Thus, the cleanup of encrypted MMIO page mapping
in the S-EPT has to be coupled tightly with TDI context destruction in
the TDI unbind process.

If the TDI unbind is triggered in VFIO/IOMMUFD, there has be a
cross-module notification to KVM to do cleanup in the S-EPT.

So shooting down the DMABUF object (encrypted MMIO page) means shooting
down the S-EPT mapping and recovering the DMABUF object means
re-construct the non-encrypted MMIO mapping in the EPT after the TDI is
unbound. 

Z.

> > > What I really want is, one SW component to manage MMIO dmabuf,
> > > secure iommu & TSM bind/unbind. So easier coordinate these 3
> > > operations cause these ops are interconnected according to secure
> > > firmware's requirement.
> >
> > This SW component is QEMU. It knows about FLRs and other config
> > space things, it can destroy all these IOMMUFD objects and talk to
> > VFIO too, I've tried, so far it is looking easier to manage. Thanks,
> 
> Yes, qemu should be sequencing this. The kernel only needs to enforce
> any rules required to keep the system from crashing.
> 
> Jason
> 


