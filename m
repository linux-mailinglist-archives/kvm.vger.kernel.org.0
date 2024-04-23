Return-Path: <kvm+bounces-15642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C36758AE590
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7489C28479A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA998625A;
	Tue, 23 Apr 2024 12:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pB7rAlkH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D90C641
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713873938; cv=fail; b=KaCdqiuPB2rXnxbIe58xQU1+vg9X5bluyLnJ03fkC1c5xHodnEXLh+YOu3gcJ5JYKmssfPYdDPBuhnXjhWBjR4O1RlWktgQrX6kl4q8ye32jdhP+OFVeFjk5e/UICLYf33gHqD8kqIorR9CcGiD2OlxMWKFeeuVx8disidhXEFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713873938; c=relaxed/simple;
	bh=HtAtHqeYdoND5cPbPCzPE5H62xxAMArh/uT76XhcU+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cvf7Hb30oflvN4xPzizreBHl2MYds65U7Y49pLShiUi/14ysJTWGh5d8RqT6tg1aI7q+yPIaTnRQwJIgokMtrTQrq879LVIL9xys45EjS9cND9ZZPDGF3OLxc4b/4G9roZieUChd/KXTrEX/87r3yNOyzQZ0md4c7W/Qnpohqsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pB7rAlkH; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mB1BusyACxNrvG+mcVnWS5XFIkBJVGeKlclcNbGQaHdRSICFUxXVnmc1hIXjYmXsuFVaR6FHQ1AQSV4UkCaObsHnhiljBhVU7YOoDPLvI/4NHwqKsdLokk2uXF/1aHaUddy4aMKfLUA06F3KwVUb3lGI8YQ9Uj+0hRQ/EEKCj4SHEr6M18gjhn/5TsduEm/DK6ZRZKNnYaHwVYqaOjZowRKPD4LB54B02eC2mh+FKQF4uWAKhstm5ht49kHsk5UlP158sRvQ1lUytutMY+CGCy9dzyVdRvGRoq1cW+0QwV5VT5p0wNv/5d2oU1ShPMbVn0Bstq1MBJlX+vNB5C6/bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkBhjKAUI3arsSuKGviBd2zWHZgsMkmxmtPhbpyvXts=;
 b=IpDLeehbd4TvLkJ59CeE8WbceHj/TljVAEel2stJ6Dp/AUUopBl+raVLC4q4TVgzr6E2W4CjLVKThMIB4Mtp0tOX66GSdmgMZhkxlgZBS9PyJBM3jb35CDeFuAr322KjgUu7qoN28AEUlFXWcXP0L7mMLaF+wFVI8H4L4FHcXnNSkhBttyElj0hGg9kpnAKzGRLflL0Oek51Li+0wwJHRM5yZS5Z81laVrn/CgMoNDI5ZYQWm+BnhJP3TBQ/09XDeGCHJPktdmjzq1Wquc6yLYic/zS2685BUQaoMR3V5TUiCm5J+lRp76QdkqaSNBnX3btF3txBq2howLoVImO5dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkBhjKAUI3arsSuKGviBd2zWHZgsMkmxmtPhbpyvXts=;
 b=pB7rAlkHSKEJaTBz4L4cm2XSAI1tzWUYIAQDOV/jmAcZnDRHEYYkpArWfduuqKVUSyRoe06IAsguArXA1GBUemO95vD2FXs8dcb9y4n3qJctvzH2D35Z+7e3l7Q3uIbZL1bPm6/QbLhsdoQEPCBuOVe5ennR4nMZeV58zk3ji07LR13Nu4+xYfOuSo7uWjZig3Dfrox42vclD1e9jIWMEWFlW2egODEFUeQbdQHlbh1PxNXkb9knl6B/LNiIuXve7NsszT1Xm+S/rM35pWganuLxGnXhc4G6XRNCTk/eO7ocm/bxOOvVGmOqy/SRMvkH3T0IhZ2lXstOOjMlmEVjng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH0PR12MB8100.namprd12.prod.outlook.com (2603:10b6:510:29b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 12:05:32 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 12:05:32 +0000
Date: Tue, 23 Apr 2024 09:05:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240423120530.GE194812@nvidia.com>
References: <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240416175018.GJ3637727@nvidia.com>
 <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <20240419135925.GE3050601@nvidia.com>
 <8e372b68-90b5-4fa6-88a5-79ee0cb4c41f@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e372b68-90b5-4fa6-88a5-79ee0cb4c41f@intel.com>
X-ClientProxiedBy: BL0PR1501CA0014.namprd15.prod.outlook.com
 (2603:10b6:207:17::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH0PR12MB8100:EE_
X-MS-Office365-Filtering-Correlation-Id: cc195d4d-0ba0-4df9-ca15-08dc638daca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AbTY/Ek92HRkZnDu3LU116cW/ht3RpuHXsIoUQDD5JeT7rAeCgohMB17q+ZI?=
 =?us-ascii?Q?NhhW4d4juNQy7wxoA6O/u675zhnXidRP6dd54mc1gbn7SelWL9EtvxXrBTCt?=
 =?us-ascii?Q?YOTMJ6XVPWHaZZ6uQ01Rnhj53DP2WihtaWUD8qqFG6ulC6H0tmHrVgpsvsOM?=
 =?us-ascii?Q?HWUnxhusjrOv+1pIQDxh51lHdJQUeo8g5Kn7WAGMR3ULYY8VhENAiCkU+kku?=
 =?us-ascii?Q?WJ93DDOzWrl+0Zd83g6XwlKf9lvoGBgH+mSLoWFcVunQR5EiT61TvyRkB8ZE?=
 =?us-ascii?Q?mr7U8kIRrNIQtAjcHCcTUCnAzt7Iem8NRUop7xtbwokO6dWaAD6uc7qdKzyW?=
 =?us-ascii?Q?jDoyliwC5z6xgOcCdVTD5G66lxYMrzwIO195nu/PV2K8G5Rq1v9noC5/nvVy?=
 =?us-ascii?Q?xKTRoTDsP6aRFv5xUDwMr1TXjKEFBkv0R9pf6cIZKqdPF7ubKst6b1xoOckX?=
 =?us-ascii?Q?Coeap9v/VNTyV6ighD0WzaVQA76H+K2KFlh1dOSi36puGk4FMwUf/1QOBbzd?=
 =?us-ascii?Q?5kHr0QAP4Rz5P/Pxxv5MJFvVwn4UKhe6HxKmkxXBstLn6zV/zx4sAFxlvqmE?=
 =?us-ascii?Q?2lgHsQnaabYBsgs4kXl7N14P5lXna2jwfbj2yUOGM+rXKXWPmMr+c0S7heZo?=
 =?us-ascii?Q?F1PTGHlDVW0wpJsya+yL3SIsYhQsV0IwBsX3LEuk2IcPldAPqndqGrJ1B6JT?=
 =?us-ascii?Q?7gaIYkpdB+riTQBPlyP2RiNbEJSdapCs9ZtU/OuVbRxIIyRtQFm1PhpYjV/o?=
 =?us-ascii?Q?X9RzmsDUaOJ1TNrbWxyM7pBquJfgVzg4Ff3jqsZxKgD+2agkY2LenhXdIoow?=
 =?us-ascii?Q?Wz3WScAjxV1ohdMgmT7s3GVIpTcQtDtQHjm5nAXAsHnHDYF4t1vgX3OPCC+P?=
 =?us-ascii?Q?lJ2dYKJ/PEc/MFYTrEo56FJbKmVfYEc+YE9C2F9C6aAF/CdX+fBsinZ68Cxh?=
 =?us-ascii?Q?6w0Np8lyjC9SwWYzmrFhtVkuR2MDS03A9nIinLQEVrRAGyPI+0S07JOMyNGm?=
 =?us-ascii?Q?WxcBfe5k68QWeayh9Ln9QOaii88sVru+YJyNJoYH3J7q32+MdIsqsGzF7Yak?=
 =?us-ascii?Q?I2wdQYZ9VYuuIQLMyuphsR03stN+uNOTHdAbk4Lfn+flVZQWa1/Om7l2cjPK?=
 =?us-ascii?Q?USuoBJeXBkxmkYuu4TkXQICp4fnaV4Gty3hhR1Vi9sJUoaBYk8RSECRTw0pY?=
 =?us-ascii?Q?p7KsrrplJTKd0N5A6T2EqAaYwuZRgyWChOcqE7+N2yVhNiNV70GPojGVUKLs?=
 =?us-ascii?Q?X/sKUc0Rsnr3/bQXmh+lya1OBZ/v2ypmpGQP+ZPwPg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QkWx6Yhic6pVCh0AG2YcxYX3JbxktLkTUfYm4Oq7/qBCSngOfzI/5dYoZfO8?=
 =?us-ascii?Q?yAcLabwBeFluAlDq/1V2vVmZMsh4a9xI0EIJR//hPQd3kP9OB8l1Qf1D5Kf+?=
 =?us-ascii?Q?6Hgd1G9obH4zDa78ShTxThPB6p2MC4VlD2ozo1akQwYo+Fu+eCyKjYeRZ/Rj?=
 =?us-ascii?Q?BiGychsSDYNWbpzZJruPwNenMx0xC4TQWQl7ybik2+0na4vXH87inSBvH7e4?=
 =?us-ascii?Q?hWoMlqxcmD3HxaXiHWXqjh8E8UTxr9QRCDX31cUWP06h5R6ymFI0OlocKKnJ?=
 =?us-ascii?Q?8qgjFmnt/p5BLWyq6Zqv8/fSk+8Xtd7XYzwi7gwW67tuA43NnU13vOfCKcv3?=
 =?us-ascii?Q?OwzCXm9aud+x2B6aPSSxCoBuq2/cIZCH/qpOhRMfktOb2ioox3i3Eclf/Jak?=
 =?us-ascii?Q?Bh/KxCpyrHTo4RXB3WMbx1TuJ68u0Iqg2lP2jRAtbFhpfvfElTrkpnFYpHQi?=
 =?us-ascii?Q?IAosA8YvNPvK8srwxByFhcMcaVAKk/lUSdHr6b/ABaYRSh1qFVZnuavm8StC?=
 =?us-ascii?Q?2Y/sxUBVHgXiqEErZhzGMEeLivcCqwrSoSlhEp7UruBI4kiaY6A8CVfk23NW?=
 =?us-ascii?Q?oh1RMThNyxYKJ+4SwO3MVGfMFVgHEh2H/kjYOCHFCIXEtS7DQXVGfIVQIPvZ?=
 =?us-ascii?Q?Sk8XRxH/y27rQlf9CirUAYLXrNmSfKGY5WwtEfJsXTxk+4hhjH/t6eQjEQJc?=
 =?us-ascii?Q?Rh7ruHFKPWEU3LfvW8BNaSmyfgStoXIQvVkqq8iz+3SwPo8/rYsnM0J4blFS?=
 =?us-ascii?Q?IWqF0mq8rN7/lbCzK/X5Ys5AHvs1tWNtLFiMISqAwrmQFStqTmO5nGwiZx+o?=
 =?us-ascii?Q?mfGpvGvOjvvm+OJ3IW+6feSzmpiVGLYd4HOixu74+XvSCx+kFz9YVHNBNsjQ?=
 =?us-ascii?Q?npnQ+s9hLmX90tLc/67qqgniC52ikWY3Rdog63fotnVRLK1GCaJvc8i07S0W?=
 =?us-ascii?Q?58RgcfNTrjIQAgk5Jt6kLV2TwGdUP2NOwLe4+tizkiHo4ExZi9/y5PosAoKa?=
 =?us-ascii?Q?P0vT3pLxMqQck/G+goSGQGmAawQ6dhDsKYIwRWR0FMXR5yLlGiZYfS5i2idd?=
 =?us-ascii?Q?cRyxRKWjFg1YSZhaWNvaqxNM1kO/rGs4gN1KSBwCUgZf/K6UBZ/WBkfi5lMl?=
 =?us-ascii?Q?/1KXDtm43xj9XlJ/Ydl5p4RbgfZl/2FiS36/bPT+UPHp9hAyWrhibjaAKNcC?=
 =?us-ascii?Q?+egiUAfD9P24zrzcNorTYjczSZZI7hzK9//WeBuSibtp2la7vKeVida/ssOS?=
 =?us-ascii?Q?wcpCf0z9xn8qFrmvBR1W3Z9dzfNLZJBeg/s57mbseTWScMoQdlcBpOvZu4x8?=
 =?us-ascii?Q?V8RnazdnXY0DeTNCOm6YHBXUqAwP2n3xGhdJtSWcSBvODfAvwrzjJSUkeaa2?=
 =?us-ascii?Q?lOlP5DWcfxREsH0k/CD+mthzboBDI35ufOq7VzNrqxMGQtq7G1fcaSAZVQ+X?=
 =?us-ascii?Q?ZIKJ4u6MBmI/gMIkjpQYw8c/Zvq+Gh327E9y/ZI+/JrR6Ssp5jQBsSsJfbhs?=
 =?us-ascii?Q?XRgC7m+724kVgkuMDsPR5O/hwA/owlSFMbrGS0BbEWGeBlWU9/SW9atHvHts?=
 =?us-ascii?Q?cmaUc3R1t+tzSG7K/dvztlSzBvMS2XHLTOQlk52T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc195d4d-0ba0-4df9-ca15-08dc638daca0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 12:05:31.9780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DGfN73BazdBhUPXWhILlKn7wYmQ9zvw0pxdQvquclqJwLlpCHp09jR+lZi+MniqV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8100

On Tue, Apr 23, 2024 at 03:58:17PM +0800, Yi Liu wrote:
> > > > 1) Check if a pasid cap is already present in the virtual config space
> > > >      read from kernel. If no, but user wants pasid, then goto step 2).
> > > > 2) Userspace invokes VFIO_DEVICE_FETURE to check if the device support
> > > >      pasid cap. If yes, goto step 3).
> > > 
> > > Why do we need the vfio feature interface if a physical or virtual PASID
> > > capability on the device exposes the same info?
> > 
> > Still need to check if the platform, os, iommu, etc are all OK with
> > enabling PASID support before the viommu advertises it.
> 
> This means we don't expose physical or virtual PASID cap, is it?

Yeah keep hiding both still works. Some kind of test to see if PASID
and ATS are supportable on the device. Probably via
IOMMUFD_CMD_GET_HW_INFO

If they are supported then the VMM will find empty space and generate
the missing caps. The VMM will have means to fix the location during
migration.

Jason

