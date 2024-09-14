Return-Path: <kvm+bounces-26892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE00978D7E
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E37A91C225B6
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 05:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F11374C3;
	Sat, 14 Sep 2024 05:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p6Y9AXic"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1190917BBF;
	Sat, 14 Sep 2024 05:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726291197; cv=fail; b=F6BV+q6bP5SLSmBLTczfQTmkYylhGQ8U/e2UwmwwbhuWLVQF7V41hIIeMtYiIVJq75SqfD9p0e07nsMzontcpkPtJOfgK3M/ZqaMJBFe/LZMXSJ+FDpnLkUylQ40ABiqqIoAqseh33kN3zQTb9IKQ+MDjZa4ogPWFSjc80e/GyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726291197; c=relaxed/simple;
	bh=eyMGYVu739aNH7Ue0QjA3zV/5CXJrLNvV2WnvDezZnM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YMbkl8FrWa8GNIFfkLTYwbI0/aag+e5l0oxojg5EXOslIxIqwwoM4M91OGufVjhHWusPza5Z3R9oyFYnE2YzwDpplBeohTiTd0kxYxIeW/bjK4GBvG4PJQz1yhzwa49hP30fSnDnS2KwditfWDqAKMrJnwB3F2CbsxFvAeJQ9CM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p6Y9AXic; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E56Bq6zdBiXG0FbMwtBl9vQRgGUWGzOB3VtnjNInr/qNagOAj5HZRf29gjo6/OTc3bgm6VTmCq7CAS7vEbKKifVmvWqErxMZfFym6rvBXdr+7cxRkSZgZ9DvxR9j3yxptQyYUhPq/wp4QpHntqZHWOwyd2A/vMkEZS48jqm5gKBp6Ct8KuFbYH8yqDCdMcGIK1YGcux5owr90U1D9ttqs2jxFXawP3bX9JUvky/8Pp+hgnem4XCh4IjfE7tdGDem8I4AMF9o/2bOjuW977ZafqdQqj9855WpOotFeKw5k1p7skGM3yi9SsCq/+NlGwog6I2wA+fqXjw/jM5BhjocDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLoaRkU5Utgm8w6CiVJcCn/Dn5HjvsePTBgWLbEanD0=;
 b=PguLN/L3CpkeJ2WbKNQ6LRAUXZi+6UNlIDIEgV8GN0Rf1bXv3bQPTUfQWhWrxostozojrhNS72zL24p+vDob06EdIkBwY4TJ2WFNagiskTNoEYvIgXLOt1HC9OTnVGRtA86rP9oD3XjiX3chrhTcYlQtO4LSLTYiIL757/R+sUm6HEUDMl23T2l633bt5cSywkU+WOJNEPVOe5pF7BY+hM8hJ+2RaOiGwVamb0FLTgIYrxmABccczKF1L0axuQ3fC0ppNy1eDZDn4l/oS88IzngUk3WN9rYzzatkudeRAUHfen4KHHMKfVxb/7PzMWkZFyaW2Oordlst51Y4ODhcow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLoaRkU5Utgm8w6CiVJcCn/Dn5HjvsePTBgWLbEanD0=;
 b=p6Y9AXicZZ9A770waztS8+r/P36xulcktjwgo78dNHrIfWpP2VhfAHLUk3gm+dyaQMUwuVeYpT2twdzyUj4JRo1cvD0NRSHFCa9Hd2URL+KRkduCjuGbRlVnBZlQpQedzWPEXFsfZVUcAuZ+JxFShMyvyVZ88nbLsNzs2N4Axm9PinHLISHyeCb5dxiLRNtPR7hK7FFNMDbkGsAW9OF7YlmFxaqwvrDyxrFI8cv0m9fO8D7WrbpseQ7BbkUlSvQLQFKWiI91KanvXwC5aE741hoBcYm49ysP1j5YvlC1u4tAtCxgoUvhQ8Uq5T4WaJMewSCtrnhmV/55QMPY7rwjzA==
Received: from CH0P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::15)
 by PH8PR12MB6820.namprd12.prod.outlook.com (2603:10b6:510:1cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Sat, 14 Sep
 2024 05:19:51 +0000
Received: from CH2PEPF00000144.namprd02.prod.outlook.com
 (2603:10b6:610:11c:cafe::16) by CH0P221CA0010.outlook.office365.com
 (2603:10b6:610:11c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.26 via Frontend
 Transport; Sat, 14 Sep 2024 05:19:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF00000144.mail.protection.outlook.com (10.167.244.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sat, 14 Sep 2024 05:19:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Sep
 2024 22:19:49 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 13 Sep 2024 22:19:49 -0700
Received: from localhost (10.127.8.11) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Fri, 13 Sep
 2024 22:19:44 -0700
Date: Sat, 14 Sep 2024 08:19:46 +0300
From: Zhi Wang <zhiw@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, Zhi Wang
	<zhiwang@kernel.org>, Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
	Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, "Vasant
 Hegde" <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Message-ID: <20240914081946.000079ae.zhiw@nvidia.com>
In-Reply-To: <BN9PR11MB527607712924E6574159C4908C662@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
	<20240823132137.336874-12-aik@amd.com>
	<20240913165011.000028f4.zhiwang@kernel.org>
	<66e4b7fabf8df_ae21294c7@dwillia2-mobl3.amr.corp.intel.com.notmuch>
	<BN9PR11MB527607712924E6574159C4908C662@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: NVIDIA
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000144:EE_|PH8PR12MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: b7360809-5f26-46c4-0454-08dcd47cdb72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PL8PgwCYOPuI2fny16LGJiyaoc2FFSVIi9bP8TzggpN8lPSacNtTL6Cvls+L?=
 =?us-ascii?Q?oiv2+XK0hArtiuUn40j9QJiQ8+5avDxYLZH+9cd6LQR+p//1L3ltixF4OOI0?=
 =?us-ascii?Q?uIIUGLx14s+ToUAGUVoPZvMugBfdPNx0m7lFYr1IFYdmr2t8cPVYcngSNXGN?=
 =?us-ascii?Q?O7/D8J3pAWG8kGg9S7UBe4LAVS81Mk/uc8EevR1TqQwL6NcLgQlp/LuX2nC4?=
 =?us-ascii?Q?i+t+azRoKNZg/f1ORygaoRkJi+zbNZbpOeolc6w0qvRCy5WlZLAkvbvHa7SK?=
 =?us-ascii?Q?Z1H9K4UMuiv973NxRVyJ6iGW75wmp2KvyqVKicuQGXf5PQ018jCsW0v/XZF8?=
 =?us-ascii?Q?QBVMwYb03TLHZ7y8VU6s0HcRJWkWdGBkaqz6Ai3aT/cDgSuZkDTYWTnMFt21?=
 =?us-ascii?Q?E3+8NZFFzK2IVu50B9GtchWOOkjMNlk5o2iCqVVYpqd+zxZkJTfLDGLcTL2i?=
 =?us-ascii?Q?nsMFa8z/FkgL/Q5B1E+/EV70MWqVHpsZbtWvyYPQx6AWaRJtETdXRS9biltW?=
 =?us-ascii?Q?al+ywXrvVcOfajHeKJBCyCPM3TYceoI/hWQMJ7MCfaegO4Ib8aPL/mGTfVuD?=
 =?us-ascii?Q?8D4cBzkUnuKP2iz9jla5u4/nMapkENwLHc4kKVYi11mjzFPl9E+lJbXfZtpf?=
 =?us-ascii?Q?9LJfi1cEZXvgEDnso/W+wsoJ00GznZJAIXHBkmUps+EECYkLWFeM8STUnFm5?=
 =?us-ascii?Q?aND+h0h8QCWbptyv7b742EoCUSGKnzn+WHqpQbEkBGq/sceE/fhn0t9gwp6S?=
 =?us-ascii?Q?uJjHuH/Wf6DII67WLp8uCyJZHeMXbdQ8lFVaC1QabFeGKeRUz4jHwHJuCyyI?=
 =?us-ascii?Q?gu5uDnCJwynrltcTMpL8mrWqoOEP51ZIqAzzVg1LN14Z+Hf4+YTF9yZZX8cE?=
 =?us-ascii?Q?/yhtYpZtA/EtA8Su/wHKdND2oRokaVjfmaTzXX4ZLFFuC0bf4EnX6qzq6XvN?=
 =?us-ascii?Q?abfQfXcg8FlbujYPuM+DP3QvK41YGuW8xDoXN3JHI80+yeZKkFD1JP4nchnF?=
 =?us-ascii?Q?xag+AnG2Znk8s5VGsDLwS4fBPfpFneyOhTJNS3SkqAH7U4kQwQqdvwnh30BS?=
 =?us-ascii?Q?RL3msRZqTA5aX8+SarNmUrk1A6Yp6x2oNrRnczMDpul7HWGFy6+133i7ZGmr?=
 =?us-ascii?Q?a5YKseME2EE5WfJsMKKXt0ebB1eo4gZt1y0zKX1W33nw5p7vRzgRs+euF4gT?=
 =?us-ascii?Q?1Q8ka33I9aO/Eu76uDKL1oN/ydj2EVaTUNd2lCiW9HTkzLYpXUzJBAnE1wxH?=
 =?us-ascii?Q?0lA5mA/1gtZXqjg7HJyNiu3Le8vL0cBrQOTstpkKg1pFknWDjs7PmVJCFNM0?=
 =?us-ascii?Q?TzjlW1IDlgJIwmeVSPNna8mY9ziAIzpoiyYXY5gmskTAB7ICdf8OAZsRSfgG?=
 =?us-ascii?Q?1xhlBztRcY3c1XSSINO8WZpkrxEfFci8MEJpbUkaBkjZI35CmyUBAesgXTqN?=
 =?us-ascii?Q?SC12bUNVAQjsPt9oBmOjAtxX19mMYLsV?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2024 05:19:50.0921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7360809-5f26-46c4-0454-08dcd47cdb72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000144.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6820

On Sat, 14 Sep 2024 02:47:27 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Saturday, September 14, 2024 6:09 AM
> > 
> > Zhi Wang wrote:
> > > On Fri, 23 Aug 2024 23:21:25 +1000
> > > Alexey Kardashevskiy <aik@amd.com> wrote:
> > >
> > > > The SEV TIO spec defines a new TIO_GUEST_MESSAGE message to
> > > > provide a secure communication channel between a SNP VM and
> > > > the PSP.
> > > >
> > > > The defined messages provide way to read TDI info and do secure
> > > > MMIO/DMA setup.
> > > >
> > > > On top of this, GHCB defines an extension to return
> > > > certificates/ measurements/report and TDI run status to the VM.
> > > >
> > > > The TIO_GUEST_MESSAGE handler also checks if a specific TDI
> > > > bound to the VM and exits the KVM to allow the userspace to
> > > > bind it.
> > > >
> > >
> > > Out of curiosity, do we have to handle the TDI bind/unbind in the
> > > kernel space? It seems we are get the relationship between
> > > modules more complicated. What is the design concern that letting
> > > QEMU to handle the TDI bind/unbind message, because QEMU can talk
> > > to VFIO/KVM and also
> > TSM.
> > 
> > Hmm, the flow I have in mind is:
> > 
> > Guest GHCx(BIND) => KVM => TSM GHCx handler => VFIO state update +
> > TSM low-level BIND
> > 
> > vs this: (if I undertand your question correctly?)
> > 
> > Guest GHCx(BIND) => KVM => TSM GHCx handler => QEMU => VFIO => TSM
> > low-level BIND
> 
> Reading this patch appears that it's implemented this way except QEMU
> calls a KVM_DEV uAPI instead of going through VFIO (as Yilun
> suggested).
> 
> > 
> > Why exit to QEMU only to turn around and call back into the kernel?
> > VFIO should already have the context from establishing the vPCI
> > device as "bind-capable" at setup time.
> > 
> 
> The general practice in VFIO is to design things around userspace
> driver control over the device w/o assuming the existence of KVM.
> When VMM comes to the picture the interaction with KVM is minimized
> unless for functional or perf reasons.
> 
> e.g. KVM needs to know whether an assigned device allows non-coherent
> DMA for proper cache control, or mdev/new vIOMMU object needs
> a reference to struct kvm, etc. 
> 
> sometimes frequent trap-emulates is too costly then KVM/VFIO may
> enable in-kernel acceleration to skip Qemu via eventfd, but in 
> this case the slow-path via Qemu has been firstly implemented.
> 
> Ideally BIND/UNBIND is not a frequent operation, so falling back to
> Qemu in a longer path is not a real problem. If no specific
> functionality or security reason for doing it in-kernel, I'm inclined
> to agree with Zhi here (though not about complexity).
> 
> 

Exactly what I was thinking. Folks had been spending quite some efforts
on keeping VFIO and KVM independent. The existing shortcut calling
between two modules is there because there is no other better way to do
it.

TSM BIND/UNBIND should not be a performance critical path. Thus falling
back to QEMU would be fine. Besides, not sure about others' opinion, I
don't think adding tsm_{bind, unbind} in kvm_x86_ops is a good idea.

If we have to stick to the current approach, I think we need more
justifications.

