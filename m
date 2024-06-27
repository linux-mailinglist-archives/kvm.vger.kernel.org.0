Return-Path: <kvm+bounces-20605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D28991A684
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 14:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48C7AB20BD6
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 12:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D9F1591E3;
	Thu, 27 Jun 2024 12:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L0tB6Fzq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D8413A276;
	Thu, 27 Jun 2024 12:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719491201; cv=fail; b=MZZdffSaS/v1Y950h8CJp27PE6KaUH1vyuEVG53EMTGwzBEQtG3kz+qcjuucy1OXIJNry/f61MLqbvunZhTApHXiHmJYOOEiOcHCG8EO7roSq1MXWlzO0Q0Gu1OPpaUSQCRBIzR32tL/B4Sv6itNcIDt6Vz7JHGqN/0KHJyWjjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719491201; c=relaxed/simple;
	bh=N3LOhSIOOYAWMfU/NExr6EYAFqxCDkpf20Q6METuXNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nb0px66hGsP2FoiZ9I7nPnfPagTuotU5avkmc+lnTz6Xp92+5hZIhC9hZgg+UxfycL//CyBEa1V9Ye5ICTJaFU7fx2mIy0MLDDYsowdGL7ZBTUGMwo3qkx0PH0n2DRlaMBaNZnarw/uQxhQmHdVKkCZrG+RBSDIn2+42pNjvAsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L0tB6Fzq; arc=fail smtp.client-ip=40.107.92.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqR3Lv53uQ2/aCwjBW0c/O/iwHlEEcU1/dOZah0riqPpe4oe0Gu9g76gswF0PkkHBr7HM1jXxO84KYwhx+8n44YAByqtEI7QI94JMHHxe5Xbk74AXxpt5Nc9J5MprjzuqQr3k/D+rOUsXYjhuU0tu/GOag65NhO18ETnjChMzjGXGUF35GkQHj0vkw59r3s78Ejw/00wEGtDIM7QRhECzmna17n4krUKnV/ilFNQ8DZGq0YfxpC/YdueN4AzGWMotIawVdke6b9KktcI+bj6rxucLyFzxchx2xWFVTiofB0PpKa8/fsIF8/r0O7vHkTJUGXFzgXkNCF1JMwyoKKGMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihq7S8VaJNLwcv3Ex7gv1w19VH7wuCE8lRr9g/C8Uk4=;
 b=Uxp2IqxGqDWNTQZ044iV3HmcJoukaQeWXhKCYSl42nu+ag5D3AMstMJaGVNOs0sPASNhdShDqpzSTNdYaosdBB4q5j44DYbrNgemixPFKCT6wLS7mb6TDxaZohvXpq7xA9C2qqL0kZMH2AGH5xcF7EGAK+Aboz28jMFBnMUiu4nabnmMvE896ddwbnB7ELyq9AooPJpfwPbl3cYA3s2lQCWzN3VLLPmQzqvgRYXxJR47dOg4UExklPjSLIbsFZbG2FINgwprIt4ufBJYctpIicjUfywexPMxiSNjFclcuXALQuUGYxp+Ag5HZCXouFZ3Ez6xv3QVWxkqf06nHvr4nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihq7S8VaJNLwcv3Ex7gv1w19VH7wuCE8lRr9g/C8Uk4=;
 b=L0tB6FzqHKMLfZFA6onGGAXx3VjfgG7LPgiYaXuN3fPmnURCx4ca2ur40R4hZQB7/GG6MTaUvv6TvrhZ9Ntt6WA1O/zDAT0ACt7+qbnafXxN4if5t0MkZLJnRi3BQ4F9YSnADYhinxYo5D2TRfOKAspBGVSXOQh7S2C5Xoei/rN8BLPg1iqcrkE0NqmFhpIarMOom676UhSRYTyR2U7aF2E4lWwdCYN3tpXdjp+mmUt6+yBS/PgJAmvSBa/YBhLYfFG+zdRsb+WENkpx8dz4D6Fl/hELG0u6veRsTdYRtDrZYpRsmWArefBSPDObv2jumoGq/3P0lRL9/ur9zJDRsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 12:26:36 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7719.022; Thu, 27 Jun 2024
 12:26:36 +0000
Date: Thu, 27 Jun 2024 09:26:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <20240627122634.GJ2494510@nvidia.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276951FB77A98CBD6CCF79C8CD62@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276951FB77A98CBD6CCF79C8CD62@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:208:120::42) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e275c25-81d7-4e4d-4054-08dc96a46326
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pqIY+zTdrFpBlg08aKjBXBdzt9kDaZ6fCmjDSEEcTPysJXRFMlkEb7+jx/Ug?=
 =?us-ascii?Q?4mYEYtzdi/hQMljDxe719WGz4bG/FSzEPPGoN9ORg7k2xfkCLucmi+Qe7qyR?=
 =?us-ascii?Q?DHoKovsn8VEWzv8nD9/vBtxrDqIuvEGIU9W+VmINFTn/BWu+ALKRCVx2FCkf?=
 =?us-ascii?Q?QC0u0OXLToH9G8if2qTGqI4NcTWom40zFTiL2HmspcTUgd7NWpM+qLvBTUwH?=
 =?us-ascii?Q?vJnBhhdKb5i8hFd1qYZ6c8COQVg9XAxXfUBL7yWbqrl/8Zsxs0nXmj610dCC?=
 =?us-ascii?Q?uf1hJufsq8crUxNhJuV3ACTkUGOKgoG1Jy0n/5mh5NbNlMwV8ob5AnfOWF3U?=
 =?us-ascii?Q?FBLkJ9XFAN7/7cfIa5IFfWDC6du1au3D/nLkOzOGlg4zubjg/dI/f2QMLmGp?=
 =?us-ascii?Q?BtYGwUIezAMK6vgYl8CHgwAV5KywzzmCGfmz+rfYVpC2io0rWQdCdCq0wMCT?=
 =?us-ascii?Q?CtEeOKR9mzBOGopa5GGsXsd9MH1a6JxSCb7iL4jxndh+Hy9bVPEO9Dx9cHnU?=
 =?us-ascii?Q?i/lkDohtx+PS0NHD3kuCwHLWo94V2syAGWpB1OWlnddmqabbd/IGV7p8px8b?=
 =?us-ascii?Q?Oedb7/t2VdxNVGOXtvHDmOno1RNthM2hPSp2selsq53CrfNrMpz+O8b8vxmx?=
 =?us-ascii?Q?H6xUO1HgfSGkbSt40TNgwAAiqiupWB0K41wBLcwuduCzpd5fpVH792Q5Gh4b?=
 =?us-ascii?Q?8+SwYhbV6y6Hl8oLChMpI4UhWb5e2DPQYUqHjb/xG3V+YMFbLwBFRq/Ej1LJ?=
 =?us-ascii?Q?UJrcYJ5e/w5IBSGysJSjxR4RqfDrz8nKivZGiugLOMIKglaQo8UvUjxSDhd9?=
 =?us-ascii?Q?QYio7cjvRwq31XzQ+KNeBFes+NtNnp4Yw55PTRUU5zJuItK+baqNIoNwOiPg?=
 =?us-ascii?Q?jIcWozHWXaosFgUcCZdeLNkfaO4pvipni7QQ4mH46w7Ni8+Eoy6jYaaPu27J?=
 =?us-ascii?Q?HwxF4xIsl2OluhT+RGlFerpvbUDvHDQQpfUTjLiowZPDlJgY50C8ZOtnJPjE?=
 =?us-ascii?Q?SoFTbgBlr9CaVxsehTizu3ZX50Oppz9/ZIG+XeyOsNRBVxm7E/x1S/ItAhar?=
 =?us-ascii?Q?GS47RkQoAZPrN5HqeTE4niMzFOqho69HkeRKQg8kzvA2AM6AqvmpEHTP4mz0?=
 =?us-ascii?Q?d/yRzVJzP+9gdFZ51f1LJi6fSQM25bDj4Dap8cwSSJ+OCOlerM0goeER5Hh/?=
 =?us-ascii?Q?fYVMN14oxvEJ2IDmGbeHPeesVkYph0OzPtDSXBB15+suh8zWiD48Uye+fagz?=
 =?us-ascii?Q?iLlhXQOuACaZmCIfucsU8FAQWidEOkgcpt7hvXmjL/Xjlk22fGon7SrhHVST?=
 =?us-ascii?Q?7Hcd2pCiuI0/N+oAv4SoB4tbykJhlYMSDJ57o6P7+tDfrg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jp0L16oLnNbXOa2l1ZfUyaM1wd3DJIO62XAiFp0xrtRedYWPcgDRWTt+qJSO?=
 =?us-ascii?Q?ubRirX2h9LveZl/DvDlDa6paDGOvBJ8J0LzA11GsnjI1bpBsM5nn6986kixB?=
 =?us-ascii?Q?eMmzMtWoPq9MTX5isRP6jtjy3N0kyfESdM4HuNtB9SOXYK++glz4VdNcXm+/?=
 =?us-ascii?Q?kh822qI+8axnJOlrdzAIAwKZyY/NrUFMN6wf9lQH6Fgf4hNBvxUyCfVOyWi+?=
 =?us-ascii?Q?uVHenBYC3oUQo1fT6zZwVHLCyXBKL0wHH/MJ0X3Lb2L9vTs3565i/mSm+OlD?=
 =?us-ascii?Q?0Rx4F+XwgWiC7U3lnvG5fJas8BZvS+GsBaTRU0Jfe7kcgdNmPMp9xrF50tFT?=
 =?us-ascii?Q?VbAiaKbmwPoEfsiACJfJKL0ZKjMHNxA1ZWst7kSzUP0PBmuyEkNRwZZB0IWo?=
 =?us-ascii?Q?Xv3d99qB7tm7CN5Sr/yfFepwsQxuuLytzDt+LbVFFR1L4iBrsJ3BzjbHfbHc?=
 =?us-ascii?Q?om0g4vm94La6+5H+TCBaT75jVxp+KkNkyXHpJ1LJBk3IODD1Pv09xY9BGrjy?=
 =?us-ascii?Q?cQP46rGx/yykRyf94+J8glVA0f4VUFKsC5PB6f4yQ4eaXhhHFTnVTIwFvnoe?=
 =?us-ascii?Q?aFIKxRUpYKmJDHaenMk2YHvu7Gs7WBe5iCe7ZrvH8HIi8/lMDZaT15TVTWGa?=
 =?us-ascii?Q?pB+PCav7n3SxG/bCqpX+hyouPn7Gvq6KbLOvOmkKjF2sEeR0QkByw/5puml2?=
 =?us-ascii?Q?c9iRQcuWmduCu5a6Ru0LZvva5mf3XyUsifoj/55AP+Vg28oO9c9u7URM3IT5?=
 =?us-ascii?Q?8vwP4+ouSzO0IZoBptmxtuxeqYhCqgcLR3qCuxjXUjAAqoFXGBRwAxrf8B0E?=
 =?us-ascii?Q?dQgms26OBFpOD0GP1AF3ewjUQPWqEqasJg6Bkk70eC5BLl7thX1IRVLoRvDt?=
 =?us-ascii?Q?/V7cQ8XBFWy7Zu9CIgOR+5ztJMS1bZjU4BkzrJDrFB7EAK9cowLQIF4vWLFH?=
 =?us-ascii?Q?G7hxuYp3NErAVttcSGkrPENqCASQpdXVirg3Gmjc++GIoLVoWrGusL/luwy9?=
 =?us-ascii?Q?ThDu4CcFJqb91T+Dy8FDZeSKE0wL6ejFc6pdm65K3Tq6AKsmzuRTsApT6J+2?=
 =?us-ascii?Q?4vDJgg4wuGO4o6WLZg8f7YCfAxUKtbyNxKNDfXy+xhnfvANla8Pev2nDcGBI?=
 =?us-ascii?Q?fGPUub0iusVafEDVDbrczp6reRRXbxklqUxCDIMaIfpjHKWJSO+wW0MdWTwC?=
 =?us-ascii?Q?1IJ4uKfMCRpoSLnNTHQfEaFWpSAp16Q9vy87EKpfJYEFfmu1AaOoq78hCrsB?=
 =?us-ascii?Q?rIZuENsEtihFo8kStbEvUBF9z/lJOChau7aFmRLKCIfRxMPCMgmWCPn6G2rZ?=
 =?us-ascii?Q?AZ3vNO4jGb2zGDCeAeQABwWpWZ9aUSLQduwsPYMhULpkkXKAfTfGVcM3zZSm?=
 =?us-ascii?Q?SdVjgyoNOARwEoMpEBj2DwJx0OY7XoWiEb0BBR8uVfrw5993NLxngpTmAdb4?=
 =?us-ascii?Q?m9MDMW+PXsfTpBmWqIlwW8hzsGOAr6QxuZbcpds6uc5VLRtnbvfWBgkSnXGq?=
 =?us-ascii?Q?23KoAqbDeyMkxllgK2CFOzi/85fMV59LAUJ+fK7gw5h3O+HPjGHqeFow4juO?=
 =?us-ascii?Q?ZpKWqhgIn5+j4uyGxrBcbyxjACYz7VG3qx6wMXNn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e275c25-81d7-4e4d-4054-08dc96a46326
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 12:26:36.3442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8blNECyvxia+s67zvEzJt9nVXR9GON9l9k92C2Ybb9bYmb8wv5PvyR+P+m3KL/L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520

On Wed, Jun 26, 2024 at 11:55:59PM +0000, Tian, Kevin wrote:

> > > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > > index bb1817bd4ff3..a4eec8e88f5c 100644
> > > --- a/drivers/vfio/device_cdev.c
> > > +++ b/drivers/vfio/device_cdev.c
> > > @@ -40,12 +40,11 @@ int vfio_device_fops_cdev_open(struct inode
> > *inode, struct file *filep)
> > >  	filep->private_data = df;
> > >
> > >  	/*
> > > -	 * Use the pseudo fs inode on the device to link all mmaps
> > > -	 * to the same address space, allowing us to unmap all vmas
> > > -	 * associated to this device using unmap_mapping_range().
> > > +	 * mmaps are linked to the address space of the inode of device cdev.
> > > +	 * Save the inode of device cdev in device->inode to allow
> > > +	 * unmap_mapping_range() to unmap all vmas.
> > >  	 */
> > > -	filep->f_mapping = device->inode->i_mapping;
> > > -
> > > +	device->inode = inode;
> > 
> > This doesn't seem right.. There is only one device but multiple file
> > can be opened on that device.
> > 
> > We expect every open file to have a unique inode otherwise the
> > unmap_mapping_range() will not function properly.
> 
> Does it mean that the existing code is already broken? there is only
> one vfio-fs inode per device (allocated at vfio_init_device()).

I may have gone too far, it is not that we expect evey FD to have a
unique inode, but we expect that there is only one active FD using the
mmap and only that inode will be invalidated.

So changing the inode above before we know that this is an active FD
that can do mmap isn't going to entirely work. ie someone could open
the cdev FD (and fail to make it active) while an active VFIO is using
the legacy path and clobber the invalidation inode.

Having per-FD inodes is just one answer (it is what my similar RDMA
patches were going to do), we could also move the above to the first
mmap so that the one and only active FD also sets the correct inode
for the invalidations.

Jason

