Return-Path: <kvm+bounces-36389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17E7BA1A6D5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9152188262D
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C722212D65;
	Thu, 23 Jan 2025 15:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bwl40UdI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2086.outbound.protection.outlook.com [40.107.100.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246F81CA8D;
	Thu, 23 Jan 2025 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737645275; cv=fail; b=BuworGutyaXr3WId0vrF058UqgfPLbGKluo7+5r0a44LVeoRELXpZ9B02wjsXCj5Ql5OVHSyUO6ATiU0NNFbvTG5b8BpSa8ABrovj8GZ25nZFe7aJ1KLaFy5jamZuF/rDaRcSHvjJ52Fi9f7jhZFKYcpDP96VknmQAiNEW14prA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737645275; c=relaxed/simple;
	bh=cyICcqVV1c9jHcXr5oN8MJj+OIe1TaIqF2B5g20IRyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A2jgET92nkYRR+1SCPP/qT+4HX4xSUPKUoILU2FDhAxF0DcwDXaRCUkul00V5D3nrJ/O4DtGIeNNrsIiqRAgixNKWV0acbeb56WX+dihgDrIVzPe+jqwDqRKoi2lLY5vuYhm5kOvT0HAQeFAay2qM2b7iSGpww0sOZo7YkfuiLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bwl40UdI; arc=fail smtp.client-ip=40.107.100.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZ+4XKyq2pUul1K1t21RbwoqcmajDNLul/78prKdVkXIDeEPJ18tcPDFN4ybTDujPHmtcpWOhXyFOHOqhkhGgp9nBrU8C/gGQE9soGmcBNivyUhcBsw0bJ8/Sd+hmGDfeCcneo2+0NFT0zFZMpSsb9Be9BhEq1BhH3kGCcZwvlX8m4bwg10/fxcIfq3I3eXrcLS32uzbWMCwqRSNq43cDJ8YzqOTRiNOJlxbBRkJgWPD5KEUOh9JoJ2MSIUatT1tI05urzJu/imUhoI6S9auW/wvvqVOThGcSkuEGP/3D9f2nPi/AhhOCgezRiZcPY4Ok6xgk7Dj/olEBrRdkqBsDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUz2sUGivytbo8InDCpC1BD2k2wJqFvmrXNeXjHnbs0=;
 b=tcEfcjxfIxusoVTyqguIEaACDxfJ3nxQa+vfn5ek1xRcoEb5s8LRgEOlZw48HcKi0n/vu9Cwk6Plhme0nXC4C+o5NgtWzL5xpXB2PktWpjr4He4zuISuuH9reagKcCmjn345t8HeMJdxaPjSq0U+Nu/vDBTFFdn4biUFChzxxDckIntLNYCUOadyU00p2ZvWsLt+q7+4GSjtJZDxu5x2tm/FxmTJF7HM0TGjFOC6PJDTvXgmkONVWRb+V17Jm3M8pCclQmIhxTPD1T7cjTJX853ThRuLWtFvEp9YZuRn8JEAsSjp9Q9+h6KvArmcRB8AUECg8Uhb4gWyouV/dNskrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUz2sUGivytbo8InDCpC1BD2k2wJqFvmrXNeXjHnbs0=;
 b=Bwl40UdIaItoWdWcKWsQzLk7uyWqvV6JZ6aqJAZANq8TCudsjTDPJMx2bXDeVmSulgej1+jLarFKmPjgukKiDJ7oJTbo4ye3TnybmIX8YIyqNZpyVsuxRMro9PQoCx7y9vaNACtsGhkNjwkFjjFK3lMWK64Ti5OReT1k45XGiW1CCnefboHDJ5nNqHDNAwYJO/JqTosUxld4uL7DduZ95X6QE5ToPxD2vt3jThCVw5wBV6l2PBpHNBdUBTRbZSTTiA4dULLD78o5+2J7EejbnCNWP81+1nIKWfoPFtVTSJif+9Cdm+Vqa2LGtEak+ZV7GfnttxmSUy9S3IKtXkAErQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12)
 by LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Thu, 23 Jan
 2025 15:14:29 +0000
Received: from MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e]) by MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e%4]) with mapi id 15.20.8377.009; Thu, 23 Jan 2025
 15:14:28 +0000
Date: Thu, 23 Jan 2025 09:14:21 -0600
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
Message-ID: <Z5JczeFgDtX35nV3@6121402-lcelt>
References: <20250106215231.2104123-1-naravamudan@nvidia.com>
 <20250113204200.GZ5556@nvidia.com>
 <Z5E1alwzi4YnJFLI@6121402-lcelt>
 <20250123133312.GL5556@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123133312.GL5556@nvidia.com>
X-ClientProxiedBy: SN6PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:805:ca::33) To MW3PR12MB4524.namprd12.prod.outlook.com
 (2603:10b6:303:2d::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4524:EE_|LV3PR12MB9404:EE_
X-MS-Office365-Filtering-Correlation-Id: f14350cd-f8e7-4d32-1592-08dd3bc0a17f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q261r/72TMdpS0+xoHpZR3U8uIRrn+7YsIrRgIAMYHWEEy2pP2y0KoWoOvb+?=
 =?us-ascii?Q?SoiM1rfnHCQoFZNaYLYyrSw6yqiBpsJuoZuPt8ZTt9TTQnRnA9eWpCEGL2H6?=
 =?us-ascii?Q?NhU5pGNXXCgHhc6reqfzNlFN1tRzECIg7QHqjDDxd7jQuoCaVtDWgtZjqZ9D?=
 =?us-ascii?Q?MtTJ/8HViR9ruhfUB+DZXdHWEAYPkxCkuaKRmUMdeCHhMM/fC5Wwatks43Pw?=
 =?us-ascii?Q?sc3GUrLCRgvxpjVh9FcGdPRrC9A9S2Ymf4iatAuz08MpL/U78ax9u1wwRuih?=
 =?us-ascii?Q?T3miq6pMKlhJaRkY1Cor+Qnx6EaanM0jhgybJd5owh/nSvpHEaYLiw7XfGAv?=
 =?us-ascii?Q?svTu5bYjxL9kG5b2xucWOufj7l1kF6MVnVcof5ZaKVs4PqL8ZVZUOF6yc3jZ?=
 =?us-ascii?Q?KGs35WvYuhltAabyQGBOnC09JoLuFzqCzZjE3ms7iXO26cLCwKMap8RPEBTJ?=
 =?us-ascii?Q?mDr7N72eyGI7xLtX+GvS9CgFgXZAu5mGWsOSrDw7Gy179tcNLBAbuWH0zSlB?=
 =?us-ascii?Q?q1MYWko21d9fckI8xUZ2QMeY1NIasTNBgCfLhQn8Ki3K27LM4t3Ur7YWmm20?=
 =?us-ascii?Q?OLklBz4tNU1nenA+fkR5n11AGLkMVB/zyc492iVOkHTBIN/6ZxHRWiFbvVb4?=
 =?us-ascii?Q?YLuE76MOaDXsq2rkYzKkeYEqeiiQQfN/nuY+5ScitFsfAC3WmlxDaqbDNYdd?=
 =?us-ascii?Q?c0J24ZBMuye/fFGAGu0va2RZwLC2cd/YM1PlZHAF61OgXPjXUILdYVcp+/4m?=
 =?us-ascii?Q?oIo/lhQNTOSeTWjxzxwmkVbB9bWBdT6j7waLZ347eeWGRm17t3mQ0vY0ldHZ?=
 =?us-ascii?Q?bsuwkI3FY68tSnkqEOfQAHYS9o4sho7Wx1JgiQhjLdeKW5xpVynjnajDVJ6k?=
 =?us-ascii?Q?2LvIWHHNltXIBH225wtNU7lI5KZOHL/Qc5X3NU6bioAjokff+/EAxTDMAxJq?=
 =?us-ascii?Q?QmU95sdQcAZd12WQmFyd02jPoz+aALgnTwqRVCq6pVImkyLrDG1ZgY3jwybG?=
 =?us-ascii?Q?sOVDqbd9o1tDJyZFrb4dT5faBWlmLxBbA7+LEkEVGi4pJWM2sFfe9WghoYTM?=
 =?us-ascii?Q?uW+Cc+Z/ZpQJo8unlZgraPXNJe3CzOs/ch0cJ38S0o2Dj7POK2dt/dUDzQUu?=
 =?us-ascii?Q?a4EqPPTj7qZrhaiv0Pw/mMlXUM+3KDVbL6LMVBEzVhWv6Xd/Zu0C/jK+/htG?=
 =?us-ascii?Q?GRocom9ZzpLVwrGK6R8PL+JuuaGyJMGhjk15hzx288GvDrV/Iw84gA7S5QeT?=
 =?us-ascii?Q?n3eGa3AqYmZS7vlifVRnYnhoIxl45NcffBwc5omnoEWcX7avtb+IxZ8t/tyA?=
 =?us-ascii?Q?H/2zsP8PC4oMRmpKx5ftNDikecrCslNQ+ywKj46k0iQdsFU83iFBbuAmq4Jo?=
 =?us-ascii?Q?6KEUaLF4LiRZgUC9dqQrLvSfAlfo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4524.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xndj85whfozZLmtj7UbV8aNrDiXX0Wjv98LUjrqHGtH39/ZC/C6hJQqBNzok?=
 =?us-ascii?Q?zp3nxrjYiOPAVxZ7oo3bGgN7wn8W17uR7m4rBiJHJIN+WixYm02owFf4XCph?=
 =?us-ascii?Q?Tz/5E3qXbB/INewowIDKHfoVhgJ2HMBpsbUVkpSvBcAU+DpYoLzkRrqPdaxO?=
 =?us-ascii?Q?kQHLugLvCfl2iQSwOGrA6mthfPe+N0pd7aWEuCbv+F4tvflDv0zeIe7mfQ4k?=
 =?us-ascii?Q?g8tVH3WpIQWeh7gusE+w2zZJfYmsKsNAz+bbDoeTftDNA18fM1wzaHPbL3w/?=
 =?us-ascii?Q?0OqTjZUXhoyRgaI/wYJdqm3dJmhQ18if+u3Ss9spwBrrqqQfv8Wyf6Y+QDB2?=
 =?us-ascii?Q?IyjFySCJZdkR23Zk/vXjjztmhJndvTIKt730kLUonVArswWR5KcQTCc6l9yE?=
 =?us-ascii?Q?6C/T2Ty3kl+S1+XDBuCeoM3PykEtK5+AqRf8vRIDAO8BQjECeoK/qVd7dbtl?=
 =?us-ascii?Q?ItYxkJK5UIo37Yqutd2fSBq8WShQOuiv3UB5C9DrFvlW0rQyyisMPy3+O2qg?=
 =?us-ascii?Q?C3kv8j0g0xIwUJs1Pt8nLOmrMxm0spJgbvloXyIRbzgIj6negmy7d2JDTO4S?=
 =?us-ascii?Q?75i9VGUQBezQ6CsDjqCr9uIuXH7Q+GJOh0zfBkZP91gQnRtM5XuCLBMWTktm?=
 =?us-ascii?Q?TIrD9ZfKXyGvb/jF0gcOorPObz2TKe+PSODeVkNURc/grTcas1iFnn7iDJEM?=
 =?us-ascii?Q?5bKPLC2s9Bw8fkcWayc/BF2NzSQDJCbChaSFHFdSTFVulYDHw+/lMr9+2NJh?=
 =?us-ascii?Q?V1xArQ0wX9EZjPNjviN9qRWJCZ6QPDXli7F2CI2/yw9cKz95GXwHQnqSq73M?=
 =?us-ascii?Q?n6Tj7RxLit3NtwfNDEGokL52zT2uR7eXwWvbS2IPCOEdKI+DCmkubeTkqXu2?=
 =?us-ascii?Q?6wIuiT+OaoRt3YDdbVR4mCO0RJC5Fii85t4Tn/An1S9IWSwiDE7yxtXKZZYI?=
 =?us-ascii?Q?dIDJL2GYD+HCO9mBrz8Ifjorqpe5Q9uwBVn8u9KWlzBrnp/VgpfSmN1rZYnW?=
 =?us-ascii?Q?mrTWMXJBpXsUCH0O6jxqLZaa4IyT6GtZkRrLK3qvIzl9iVSajYy5dbrKIZ6c?=
 =?us-ascii?Q?V+Y5fcRp55+uKtVYf3EsB84KB2/kTdcGav+8t1ccnjRyVBLpHQeHRreeiiIY?=
 =?us-ascii?Q?OvE6FLWLpyWIGKzH8Q9IT9Gfi6oIwXW8lVyH7cxO4twAKGyQp5yooQmCcUfu?=
 =?us-ascii?Q?hjgT9YQ98X6Gm2cgjMQbz7VjHRNMFXy9l1PNmIYcs7upJ5RQgnlduSauRohC?=
 =?us-ascii?Q?p9bK9ewF+dehdY8DFYGmu10WOkhJqA1B45DyggmejUuXGl0yW4g5T3QpvKKS?=
 =?us-ascii?Q?XynMKHFKWUgVvDQrT+B8I70tbaD7Ul7Zn2oplBJziGUsEaqf7AMp7P1JKRl+?=
 =?us-ascii?Q?l8WcI8reOGiF77i3dOdACl1rPG3zqIR/J4bVOKVKwEG/o70eh05Ks9/SRslL?=
 =?us-ascii?Q?42UF4BWnpYHsgjADaCMv42HSAtXdgPpRKeW2/YRjX2ptSiUjLiDne+0t8ZnK?=
 =?us-ascii?Q?MjuH60jGLhlefcZeAJ5Jilu3ixjnMwpDbqCK+GUGD5YzyvDtgRIEZE5N57No?=
 =?us-ascii?Q?uXMIsiPgmvINwtmZgZQT1tZ1/KRXsGB3zQEcMZ0EY2uopLQ7UPt5rIBMVa+a?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14350cd-f8e7-4d32-1592-08dd3bc0a17f
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4524.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 15:14:28.7853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdiIJVmu/+MzPooKKu7DjD9osVuKvekb2GVHBeCNQByhnyWSxy8P37QbGEEOQ+g+TlZYBKbFpC9jqHyfCiAXqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9404

On Thu, Jan 23, 2025 at 09:33:12AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 22, 2025 at 12:14:02PM -0600, Nishanth Aravamudan wrote:
> > On Mon, Jan 13, 2025 at 04:42:00PM -0400, Jason Gunthorpe wrote:
> > > On Mon, Jan 06, 2025 at 03:52:31PM -0600, Nishanth Aravamudan wrote:
> > > > vfio_pci_ioctl_get_pci_hot_reset_info checks if either the vdev's slot
> > > > or bus is not resettable by calling pci_probe_reset_{slot,bus}. Those
> > > > functions in turn call pci_{slot,bus}_resettable() to see if the PCI
> > > > device supports reset.
> > > 
> > > This change makes sense to me, but..
> > > 
> > > > However, commit d88f521da3ef ("PCI: Allow userspace to query and set
> > > > device reset mechanism") added support for userspace to disable reset of
> > > > specific PCI devices (by echo'ing "" into reset_method) and
> > > > pci_{slot,bus}_resettable methods do not check pci_reset_supported() to
> > > > see if userspace has disabled reset. Therefore, if an administrator
> > > > disables PCI reset of a specific device, but then uses vfio-pci with
> > > > that device (e.g. with qemu), vfio-pci will happily end up issuing a
> > > > reset to that device.
> > > 
> > > How does vfio-pci endup issuing a reset? It looked like all the paths
> > > are blocked in the pci core with pci_reset_supported()? Is there also
> > > a path that vfio is calling that is missing a pci_reset_supported()
> > > check? If yes that should probably be fixed in another patch.
> > 
> > This is the path I observed:
> 
> You didn't answer the question, I didn't ask about pci_probe_*() I
> asked why doesn't pci_reset_supported() directly block the actual
> reset?

Sorry, I misunderstood your question.

__pci_reset_bus()
	-> pci_bus_reset(..., PCI_RESET_PROBE)
		-> pci_bus_resettable()

__pci_reset_slot()
	-> pci_slot_reset(..., PCI_RESET_PROBE)
		-> pci_slot_resettable()

pci_reset_bus()
	-> pci_probe_reset_slot()
		-> pci_slot_reset(..., PCI_RESET_PROBE)
			-> pci_bus_resettable()
	if true:
		__pci_reset_slot()
	else:
		__pci_reset_bus()

Before my change, both call paths would end up calling
pci_slot_resettable() and not checking the sysfs file-contents.

Please let me know if that addresses your concern, I think my changes
fixes the paths you are talking about as well. If I need to clarify this
in the commit message, I can.

-Nish

