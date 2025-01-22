Return-Path: <kvm+bounces-36286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0F4A1983E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 19:14:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACCE37A4C4F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 18:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACEDA2153F3;
	Wed, 22 Jan 2025 18:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TR6Zw25J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387D1215079;
	Wed, 22 Jan 2025 18:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737569656; cv=fail; b=o9SR18HD9jCjlTOGMvh1AyWzJu97fR39PPGsLW3rtfT1YOdHQg7GJ3uG+wwt/J9zSktv7l1+d5XdodFdmUWqDR1kgsXFE7BrdXeMQ9qmsbiHgPfTmKBkcLeETOc9rcXZPoRr3rDNR/9uud9Jx6TFlhTl3yZTVOwjE4B/OdVDqqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737569656; c=relaxed/simple;
	bh=vvyiD6pjrhLtXPYrtcWTADYtH/Z0h6ziSLXrex2OZIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZKDz3BNsXNVlmh31NmkLtgFUiNufIQUHeLv4W+1B55HRuCPxbGXQ9Ww0yyg0N1/iKxQZM5HcXM1S9FZdeEgwr9DPIKN4CRu8OicbiL9smSxSDsbIVJ2k1vdcGlHa4aCZHU4RQJDp2NsF6Hwjb9fa0FpotkR/hJ46EWiuU10mzTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TR6Zw25J; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KQnWhlqui2ll5dMMG439qPGOKH8HhzpKRREiJC4V1en7a/G9ymxIzCzjM2oBD8QaPGFnjRA2gaf74LvS0qYfjIOOodge3YkmulX3Jf1MyQfRZ9dx3xqUPsK6EbhFAM70+DhYfo6/xagjE08lWn2iDsUDCjSM9RePbj+OZ8Pmm4GVpL9hStDg6nIgg7tcHRHy8YmL3WUfeV5zWfFHn+P0kfWH/aihbie99YM46sAgZXZ8idQCEKnmhMi7jIxilXo161Pj7Bfclj90W7yzJgOaiTPKxf97lH8j3kfzQmhWs8j12C7L4IoznFgBCCPLj7C5pj56iEhV5vYNnAfta99plw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/7J0MSg/7ggIOOk4oV1fkCjSTbl9LlfAMHm4hzX+38=;
 b=TNaHjzCHrFSAPTa/uGjhsz23k94vptqQZc639x/T9UHHqFyX7DP5zjPmOuAfI5OusPkDuKCoCpS83S4NdT3iwbj4/n8rjEGrGiXUrIZOfJOkzbHv3UxzsoslEKYPsG+p+UFNP5gV6gYxCggl/zb3Njp121rVoC8+eFmSMke25lMrv/B8BgsOW/biyJwDH91ZzQvEifq0i2BcYvBW8L/gQeWQuKAWxUhhFf3bUcx/y8jv9gHxMZj49+YXxXQSiD6TYKS5kujO3OVoAgJNzBBe4e8BIxYH2A1wNLzlDeZD0EvjKJZ8xJg1fRM9PLgfCvHtL8hyBBKK+vqIxtpPdfiEXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/7J0MSg/7ggIOOk4oV1fkCjSTbl9LlfAMHm4hzX+38=;
 b=TR6Zw25JrHb5btMODbNb6mYbeiQdbpTIaHPVmd50kjri1oE+Mu0EruR1GvM6iD7hKIQyAxu0IGMKQ3pDhHMjH5rwQ6A7uJinGZhx+UIU6f7XhDIdnxyDirV6AZJYyKM+fo2BR1ZyUeJ7MFAXxqbqM/D8M8tnUzQvTuc72scxuBMazoNS8IISuwJuHlpaFms0zI5q0nIfRSeM+BorQ5rFlGUerRwjsYwb0iTRanZKjtsrn+0G948mME2K5j+IVYzd+COND0vpYNebzwoW/7oEttPy9TK1PlIlS3eAAFzx2pY3mUwLJmKmbc/vgSFOzPSPvC5FKaJgEBD143RN/nfOeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12)
 by SA3PR12MB7860.namprd12.prod.outlook.com (2603:10b6:806:307::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 18:14:10 +0000
Received: from MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e]) by MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e%4]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 18:14:10 +0000
Date: Wed, 22 Jan 2025 12:14:02 -0600
From: Nishanth Aravamudan <naravamudan@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] pci: account for sysfs-disabled reset in
 pci_{slot,bus}_resettable
Message-ID: <Z5E1alwzi4YnJFLI@6121402-lcelt>
References: <20250106215231.2104123-1-naravamudan@nvidia.com>
 <20250113204200.GZ5556@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113204200.GZ5556@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:a03:333::24) To MW3PR12MB4524.namprd12.prod.outlook.com
 (2603:10b6:303:2d::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4524:EE_|SA3PR12MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: 9846722f-cc53-4a7c-7cf8-08dd3b109146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MpLHDdIDIboJoXTTt7OT/dcRZj2HEDZL17rhFjSmCfdVqEJvIRHkLpHxdUAc?=
 =?us-ascii?Q?Ixa3AEUWZfDwLQfNBBlAVK9cwgBR4naT3KNt419OqDLdIR1kisK1rx08MPhK?=
 =?us-ascii?Q?mysvraHXAroLMZVu4iESwJ1XtnY4KTO/YwKCkb/Dk+N3JhPtBktRw/RCuoU1?=
 =?us-ascii?Q?ujRJRiKFUkNofICUJ8UZRDrZ+sl+BUZJjPUxCj/I9yvsO/4RY7o5OpFSy9xO?=
 =?us-ascii?Q?wetbbD2TOEW1MILh5leHrUHadbF1NjLZxHPGm98CR/I1m+sjRJzV3FyBPYZ9?=
 =?us-ascii?Q?aVyTYb4ptQuLHjtI13ECyviYEetqvYIy6JLdl8Sj8jtI+GPHzJIyJA4RXAyJ?=
 =?us-ascii?Q?nX6Rpd/iUx7Alc5YxEFc/+0pMa9s2ttHXvX2+I4rfJIUGooCaTRXuFfRQ1xS?=
 =?us-ascii?Q?vQQ2oZlnBA3OPN4Ik36HHuPfZ9iqUFHfP87kHB/NcKxow2tOQdW2Y9OBTgi4?=
 =?us-ascii?Q?9J8iiWkpEM/FHXKvvfdWOpsLV9bYp2Sf3NKk/s8oKxFdHNHt4eiU3mmBcXL4?=
 =?us-ascii?Q?cyRivejEq4TCUBztBDS6uQCEnKaHc6A0GnUKp1mIT0225JMzPDI7UGGoFPfm?=
 =?us-ascii?Q?vqOpDB2A8Elwx7Ewz7BTi1kKaozMP1L9V2mrQyQ2f0lk80JExWtXxARJ2fhH?=
 =?us-ascii?Q?iIWWs4p+69M3F8Kjk8+P4PMnAiSpL6tXiWBMd37SpL/lg5R3WUSd1FqU5USK?=
 =?us-ascii?Q?lCsMKWu7om7mnWUoY72bA8P3dpBj/BdcVT0VYcyEkwxYBNU15HEhdefI/mEa?=
 =?us-ascii?Q?KzJIXKzJ+A/qWgzguzLvqsDFkrOng+JD3Rfhf8+QZWTzlSIFwkHSOpSgbyAO?=
 =?us-ascii?Q?MmgrGIWtQrzkON7+MBDk5JUS6BCS6qOXDzrQjF4TnYQmz6DOid25DzK4Nt86?=
 =?us-ascii?Q?0OsMojJZizHAegtypdn7T26bJVNqoTM0Xdpv80bFlyPL1PRI8aadCyA3JhY1?=
 =?us-ascii?Q?hTslK4Cbn9q+70WGHTMAiQMZtbVvqgk7RFYL993Hef6Jn5TaB/3Zbo5gOdbY?=
 =?us-ascii?Q?QCUISrhTuUzLzQXULPtDGhUzEVTzs8Lyerz+/+CiF5sAL3rrvshizYf3N385?=
 =?us-ascii?Q?KEDEZx3wq2ZSioffoM6PQJQolOTJOAZKlNkMVilJDvQTNrtqnf+Zu1FtVgju?=
 =?us-ascii?Q?S0U/aL1admllsRodL+sTsUoB2XWQazhy6yU8AbUw3CTpwGDadMy7TuVfQE/G?=
 =?us-ascii?Q?my9zEGQEO5hgA/Aqr+eE9SmG1y5x7mF/fzjNKn951Mglyy+gw/JwmpH4KjD+?=
 =?us-ascii?Q?O8MeTRdOlElRINfePpeL05w6AGs6oLO2qamSoU15e6I59cJo49Hf2p/XLYCE?=
 =?us-ascii?Q?vdaMeL539+jbTqef0s9SJeAIRfJcK4lKSMIvg/jP1FHqozgaioL1XTp3VJmp?=
 =?us-ascii?Q?q2BRtw3M8mE0OHUx2vG5NsVRonB3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4524.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1QkwX1w/+92darD9pqTy01zMiGuB1Htopf8uK91D1tOd2gutudGpJcQYYg4T?=
 =?us-ascii?Q?niR4EMQBmJLxgmCfthAfq05nGRipxOcU1M+IOXKKh+PdmokOx2U75xlUUhuh?=
 =?us-ascii?Q?lK6rUe8Khecm2e9f+lnr89qrMCv88zCQtwEka0odN999BBTppXuxIy/GzNJr?=
 =?us-ascii?Q?Cy5C4cltkgNVDdvdF55Fn0wVQUGz7QL652dLOIOiYjVhIzzUHtI8wFqygSfO?=
 =?us-ascii?Q?wdN/IRljLI/RQfrStFDTxR6zP0w8nAo98L0FrafAYS6osOPeCb75iM9Y6GbF?=
 =?us-ascii?Q?fGbDbULO+SBIY9HwuTrlT+HQPdHZDXZflDatT0Emtk87K25vaGID4bbn4637?=
 =?us-ascii?Q?9uuhF4yClXt3Uu6SluxURbJ+u1qsq7ftpHag5rmzRWGX3KFcmrHKGbRr0I6O?=
 =?us-ascii?Q?1qSWwKUq6KkZBspfza36Uq1G7mXyZ8T9w/qeaDWYucuVGB0Eh06P0exzjhcg?=
 =?us-ascii?Q?wJURfCl9G+VaUZcRAo48QQy+bNGiyvv/e1vjKLGGyxmGnkr4ogse9cZcvgzw?=
 =?us-ascii?Q?rUi44LoAL6KGKFcrHZY9PHf3Q9M/4f2WIKXHLIhmnrxWbX2OiPS+jhiqye9i?=
 =?us-ascii?Q?jxpjGG8KIUvuWl4mIN716OofGqLQK5KlpXZKgad1nZ7aPSzuv3FCcYsacIA1?=
 =?us-ascii?Q?5N/JZh+L7luZuQkQ9iT4m6+FPg3T0uwU3lvz/yRGtEHHKE4YCTCQAXgKYQ+e?=
 =?us-ascii?Q?zYdw/kkryeOBnQKGb46b+pzwzEOeSzxnBZ2oKdRelfeAnbBGfcXirhQX1frY?=
 =?us-ascii?Q?Tg9Cayr2xeW/L7p6F6FFuTv3pN/oiJHehtORv+wvaxJqnzqNZrV9Gk5ysk4p?=
 =?us-ascii?Q?XScb0bP/Wi64HdNkG5kkPPcbn4RJA/rET9AdxNmPpt8XuS4jUDIWGCl/blWk?=
 =?us-ascii?Q?JLMOkcQVlquF9xzf9dLTvkRGzFs0gel6q779KvyB5vTjm+1y/Ag+O/pMr428?=
 =?us-ascii?Q?ycfgg7CGukXlUq+cRdLDwpgAdnVkz9hJeDgjc7ru5oMRsdQ+75fIYDZuOAXT?=
 =?us-ascii?Q?I9b2BKHvdRl69kj4cx2GADpL9NRvQj1rI1KrqtehsW0aFFHQj0tWtPhbOvET?=
 =?us-ascii?Q?cvnMSjAyLE+Y48DbPHjGW55QhuSdPAMmh1Vgpcafca3WqJ4/gYs27P18RkgW?=
 =?us-ascii?Q?966hlUkJHoH2uF0DyOIZy2BKThVDJx+FFZsZ0YWiDi9Y26m3Bm6wmSZV/f7b?=
 =?us-ascii?Q?HmEtUxPW2RYswdgn78x5SnPD+SFXbrbPCWeD28OfukckII9RfIx3f37aVUe7?=
 =?us-ascii?Q?p6dIOicbI+CqJBOcSsij1RBiPLXuopHmXmp7T0Bb4BhGz15w3cJflyJfy9bv?=
 =?us-ascii?Q?c9XNpQVG37esT8mR35x6d3AorEP7MYl4OjO6fBkjedJwhQrCDSHBD3kv56vu?=
 =?us-ascii?Q?YJK9kJpMvOFUo+Arox9lvsuiziL2gK+n+rZU0YGYovXLFIg9t3cEXKu4AujE?=
 =?us-ascii?Q?S2QUa6hxWePJa46tdNy9GssGC1gB+N6l7nZNw/2eNTx78l6h+lBj15QqV9Ll?=
 =?us-ascii?Q?ofxY+OVttf3BEU2/q9zzIN49b4QZREmZzoosyunjfkKGlJHUJ18RxQJLiag8?=
 =?us-ascii?Q?FeVAMf5luMX+dZmCjK60/vHijEBTrcqyjZc0K+Tk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9846722f-cc53-4a7c-7cf8-08dd3b109146
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4524.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 18:14:10.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UWER3bZYDaGv4VZVyCQGRRssaFBAx5jpg6bYoK9DPSBNjVeb4+7VMeuvAcViC9UaFYwu2fPFWSsVgIpLCdov7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7860

On Mon, Jan 13, 2025 at 04:42:00PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 06, 2025 at 03:52:31PM -0600, Nishanth Aravamudan wrote:
> > vfio_pci_ioctl_get_pci_hot_reset_info checks if either the vdev's slot
> > or bus is not resettable by calling pci_probe_reset_{slot,bus}. Those
> > functions in turn call pci_{slot,bus}_resettable() to see if the PCI
> > device supports reset.
> 
> This change makes sense to me, but..
> 
> > However, commit d88f521da3ef ("PCI: Allow userspace to query and set
> > device reset mechanism") added support for userspace to disable reset of
> > specific PCI devices (by echo'ing "" into reset_method) and
> > pci_{slot,bus}_resettable methods do not check pci_reset_supported() to
> > see if userspace has disabled reset. Therefore, if an administrator
> > disables PCI reset of a specific device, but then uses vfio-pci with
> > that device (e.g. with qemu), vfio-pci will happily end up issuing a
> > reset to that device.
> 
> How does vfio-pci endup issuing a reset? It looked like all the paths
> are blocked in the pci core with pci_reset_supported()? Is there also
> a path that vfio is calling that is missing a pci_reset_supported()
> check? If yes that should probably be fixed in another patch.

This is the path I observed:

drivers/vfio/vfio_pci_core::vfio_pci_ioctl_get_pci_hot_reset_info()
	indicates a reset is possible if either
	-> drivers/pci/pci.c::pci_probe_reset_slot() ||
	-> drivers/pci/pci.c::pci_probe_reset_bus()
	returns 0

drivers/pci/pci.c::pci_probe_reset_slot()
	-> pci_slot_reset(..., PCI_RESET_PROBE)
		-> pci_slot_resettable()
drivers/pci/pci.c::pci_probe_reset_bus()
	-> pci_bus_reset(..., PCI_RESET_PROBE)
		-> pci_bus_resettable()

Both pci_{slot,bus}_resettable() before my change returned true even if the
sysfs files indicated resets were disabled.

Separate from this path, e.g., a poorly-behaving userspace that ignores
or does not execute the VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before
issuing a VFIO_DEVICE_PCI_HOT_RESET ioctl, actual resets check the same
return values:

drivers/vfio/vfio_pci_core::vfio_pci_ioctl_pci_hot_reset()
	indicates a reset is possible if either
	-> drivers/pci/pci.c::pci_probe_reset_slot() ||
	-> drivers/pci/pci.c::pci_probe_reset_bus()
	returns 0

	and will then issue a reset to the device via either
	-> vfio_pci_ioctl_pci_hot_reset_groups() ||
	-> vfio_pci_dev_set_hot_reset()

Thanks,
Nish

