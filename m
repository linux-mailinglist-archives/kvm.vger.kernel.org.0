Return-Path: <kvm+bounces-33320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAC29E99C8
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 16:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A512188957B
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 15:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38101C5CB8;
	Mon,  9 Dec 2024 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jbhwDnx9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CCD1BEF84
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756244; cv=fail; b=mjJZsD9chpZWEA2GxdcqpdgiIPLDEOW8F35g37I/QIBi4ONgXL++qHRNFekAXxa5d+pvxvOEiBEaaYa1MOWkIXemcuAZbgjlND23EHzc5t9plu8r+fNnIK2r3DFEvHUqjP9Z+xBf791ArgXl/oahKHh2c+XWUztAD2ySxS+K2a4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756244; c=relaxed/simple;
	bh=oRDZredwHyZ92XLLXnxxzlAXjxAU4txbIoITdvWha3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O5IJnthvegjGvt+i5LSeVqfrKqsDdBrOIWV0ejAl6jJUcgTgcCfVPmHnAmbzlyxzPANrQDQg89RL82QLVbdFmVG56R9B+bQn3AucgwL7Igv77Ntp1hVmXx41VOWguEqKUweSH0qWs16MqOHKW/L3WPt0vjUAswS1mhZXr+0SmcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jbhwDnx9; arc=fail smtp.client-ip=40.107.94.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WsEFWj9hsVuq0b4Z7zy0lGuVk3PZXnrMv+sTpCUC89u30+RLxlCJRTBxSvUufIMUKHiwcxSvR4vLEK8pKr5gViNKVUhiUQLvm8MdFXwGl2qy9sLTcsU44IYUk82CrgycrPtP83hEvGwtz9u1BjiPjwD1KGHTDlb8zsDeRauW1hPvStAcJqfXwCc2XocB+qvO+jC+lj2oFTPePm5I2Jdh226RR5dJub8+XgtwX+OcJu0AXfOtTB14M1ZTYbSAX/S+iEvLbBWQBVRN2XrQvxoG9zRSHPnorNanA8S3nRQkc3Re7m5sGz4sipWxIhdbtFFCriU2n51x0k7eRBqDH07Zmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdBCJyeXNEPbOm5fUhAU/IP7xrBZsnJH16bZN5POOe8=;
 b=eQ5o5o0kQ1wL87mkEoRRYPTD3lRukp9UIrXHHiQIrpkrYZT1loXJe648gd4CmwH2PKXk1sHwDTtOEgvoVu+EpwXlhFlltQJyoX2phbsc87ty3Ff9KBcSHJH8/qtKByul6TscuvwxmV4FiAszXETsPIdupjPh36N+i1h6Z1Eu1w4tqbbxXF5Zkg5BJUppyAEobWIXHkbLnqdt/uVmudjOUVf+UW+rKePc4cdRhQpMtlm2WFt6l7l8PING7NcaaMW2cA6w1EDH+18JlkBj8cwDwW6x8pUgoDKru84iux74XI+W254wroHYODIFQlREmuUwNanEadmnFinDZtrNITSa0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdBCJyeXNEPbOm5fUhAU/IP7xrBZsnJH16bZN5POOe8=;
 b=jbhwDnx9PcpouTPpAfTKse/lHoMojjpXCIsH7ob2P0PTzWlBwMm2dBEJ3El6ndWzI6MAdx5oYKMtqn5FfSeqsSybsQeL4PYpSCprltww70mqNTndHv/65ox29vtysKiPc+4SeI334GarW6rk67/Ajw79kuRLd5ZCpxtb5p8JvNbV3FoStelHcr4IQzvyRoOrZW+d81OsUQgQ4+hS2MbRaHg5vVFU4FAB6gQ6L30JW+ohgpXOHdTe/v0PL6B4SyJI3xFSCDZQQ6YNi2zFPEIyRkxsvcoXMA0F/vx+HZE7d0OrTq1tvMk204/nRz382Nb9DCW8S1Emr/L6nncbsLIgiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB8598.namprd12.prod.outlook.com (2603:10b6:806:253::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Mon, 9 Dec
 2024 14:57:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Mon, 9 Dec 2024
 14:57:19 +0000
Date: Mon, 9 Dec 2024 10:57:18 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Message-ID: <20241209145718.GC2347147@nvidia.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
X-ClientProxiedBy: BLAP220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB8598:EE_
X-MS-Office365-Filtering-Correlation-Id: e08c7e55-88e8-4612-1414-08dd1861c76b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mteidKhAfhcWg76sdpOzt2TYqA/y5yuPdhFtlUzuWV2mU7mDTrUX4P+IQVdC?=
 =?us-ascii?Q?JYuKRtOP9LQRxu9ewgSsISScQf6UsadL5jyaIqzp4T4ohkGE5enc4oPx2G6i?=
 =?us-ascii?Q?B9t0EDRQT3Lw5C6DWEFQYeB7UIqzSsl9EWaJDzi7hg0WVrbqxgmTsTZr//lq?=
 =?us-ascii?Q?Mqm/PhZRIin0DBhMBKDMy9H0TaRpBCYAXss3fFLtgq3fJOB2l213itv/Bvw6?=
 =?us-ascii?Q?iGe1WHukaq2d841ECpoR/ugM33RMg4hBQb3xwqd9oBPc7v69FZ6DwdoK9btL?=
 =?us-ascii?Q?bKvJYdtydJWBrJcPUOtIoDW7Rf+aZ1yumZG6ja7uUCpgiinwpz4HdyxCQmP5?=
 =?us-ascii?Q?xn7XR+EqEvtxuJBhsUQd6U0jZJ3kgBLq2g/7MKyDNlWpu3zdSH8tIw8ZLHF9?=
 =?us-ascii?Q?DkPcgc5TRNw0O6Tc3TKVfSB8o/D/EgQbVKWWeFneameE/S/NQcPunfASXgtB?=
 =?us-ascii?Q?7NsVm351jFSe7RZnOYkCcRzespWj+dqT3DEzZSdQeQqY4Bc4E/ugbLeZExFt?=
 =?us-ascii?Q?bxGjl8TW3XysGUqmzKlnk8fomEJ8mujS13SL4K0vVH9ea728G7finXjq7gda?=
 =?us-ascii?Q?x2uW2ADnM0u928fuCO3CCYyYKGMS2NiW2d/LRs4MtDBJ/nEEGo0/u3H+YE2n?=
 =?us-ascii?Q?UaV0a24cSibc5gpkeOqHWJwMfF8VUq5rwHb3gEBfm54n5DhFASDGcAhHlUh9?=
 =?us-ascii?Q?3zisUCCOqSWa3AuF/jAsA+Xx3qM6M0nlJiWnkj3D+MkDXmD+v+3tYcdhqc01?=
 =?us-ascii?Q?fnSxYVyIunjzIi1WuZctBsK0YtPRXhYQouIWzs/vsFbob8yfv43CGIa6fF+V?=
 =?us-ascii?Q?iHVvpergjD1CvTTtZPTDlupdb3ACpFD0oYGtRRvhJ7jKSUhKdmmk2jqVBv8m?=
 =?us-ascii?Q?O1GvsMhIGBfnREuJKPC4U4uCRKpwIIg+ULGkncaaHpz+Y417embDhu1T4yfd?=
 =?us-ascii?Q?wZUyySTXhyTSafsfVI8tcEK/NW2vqiJJ87B5uG0CIg/BQEQGPOUdjYVkAEP0?=
 =?us-ascii?Q?FZnPP4Na/5L20AStLb8N8GobyEHAjKk4F36qxEkYnHQhekwS2t9D8lSt9h/+?=
 =?us-ascii?Q?bR87AG5zG5d8FfLUYXCBc/hkV104cAjC6SwOPCprRXlh+1fmdX6ON+OzpLX5?=
 =?us-ascii?Q?la5tKC5WIwQL6dDmnOBvOBnkBeFnpOy/HDp+hHZqLrJLWudMj3A3gAs8H+KP?=
 =?us-ascii?Q?zFEbW7gY7/WH6tqQ7B5lPZXSepGjXhv1acmF/W9XqOFB4bFhTRetfqml4QfA?=
 =?us-ascii?Q?RfzZA52i4aXnAlxtPvkrqYzhmNJBETLEOuGDDiVJZ1maPhRuJbGMaFqvn8YR?=
 =?us-ascii?Q?CpQwju5KHwj4Odpemn2jd/kbwzBc7NcFg3wENLa1Qv+Kxw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CQSiRx02O26LQLXA0DZo0+AaYTY6cbgZo6A3emWZvk3C/O/TDDLqHg8UDwO2?=
 =?us-ascii?Q?y3QKTJvCc48M5Ur+uWar8+0EAjfqJ+oOIYgTSpYkuzs5nC6xcYW0nZeK/jeQ?=
 =?us-ascii?Q?AUZ7pKjunxJ02StNEEFn0A66i7YVeGuYflXKCbTuvFxgfcjSCat8jZtgacvc?=
 =?us-ascii?Q?rGhTz2AyczLWSxgBTUTV4MH9ZfAjidjX6sxjLeckJ7TmZUpfcyCO7KyaFiBs?=
 =?us-ascii?Q?7DRvuBAIqOUEt6nVfTCd4+VfJ9RP7PtIrmz8Y+Gseul+Q/uC1u6wSYI/CScS?=
 =?us-ascii?Q?3CLXaAqzonMtI4XcE1kDD3zYedGGWmQYjwW40SNiSilnss2pIykubDz9/3cc?=
 =?us-ascii?Q?tQIYmDfCecwmF6rMPTGfVsRsErh+TZSuiyxCz+Htt9lpGoQ9vVkzc9cMr/KT?=
 =?us-ascii?Q?5PX68dueBgpJLKreFi6XuIHrliXO2AmJeJ7OFRRUngI24PZME8KsSfI2Fpby?=
 =?us-ascii?Q?cVCTx+KzxdJIE2Fy0FSTOyVxXYk3CRzONfZJMMTCQST+SjkH8BBscF/W2OLZ?=
 =?us-ascii?Q?KQhptPIxb7TsmQKdzrDGsNgCe3ofy/pEAPYX6wgCR/UJdR/6zkCQHsI3tbbm?=
 =?us-ascii?Q?8BNShDPLhYzO3bh0bmVGvi//totEHyjJv1RMo7oWZjpckV7CwROGpqRlumZD?=
 =?us-ascii?Q?Bo9TY1wKjHMKF2oBW93JYakS1bxRVMEjQtTCATgMULlffl6xH0ryDLAWIJ6H?=
 =?us-ascii?Q?YXfKNybv1mLrq+lXEzHRdr4/uhXyOPwrnrtYlblbYtOiqlSbEJqBSjGeB4Pm?=
 =?us-ascii?Q?XL5AWr6J8auTKOhUMFt4qV8ZXBMQVPm6irQAioOeiW2RcfFYGSbhlcZnIy6K?=
 =?us-ascii?Q?KkuMSh+GqenNljkgpCxMD5lbjxKwaJNS8E4Ni1vSiQV3Fm9HgJIFSPRWEWTx?=
 =?us-ascii?Q?4ur7GK5oUaq3665xLnmppX5nqRA3iV6B/5LA9wetdtKOWVamDd0/5nLDwQsa?=
 =?us-ascii?Q?YHHZJO+7NtgVblDlXBRDdCaryD3O+tk76rtZMuhdIXeF4tjWP/QskH8JzHVD?=
 =?us-ascii?Q?YpX29n2XZyFY8kV66HGzMCDRR/+eSuX3FzgDJsHQZxHOevKPYRc2alojA59X?=
 =?us-ascii?Q?bra2KTmjovJ7TwlqcUx5ANZY+ztdYdJJGrRPACroNwViuvhFGOfpLIQ15hbc?=
 =?us-ascii?Q?9Y7EtwJezFgSJDwyuQ/RrAbcg4nhkEXF3xr+WzvwrHCRqb22ypNL14RQQz6I?=
 =?us-ascii?Q?tczxK2QRUluero+6wLlMXE7exvtv0HXBk3w0chi5vqH5rOBzAqQVeLu+ri8E?=
 =?us-ascii?Q?A9gry0NpLEHOvZmE6YxcgBaShe7pwaDcHoggtIs5uDn0rQCM8eF8tquGJkS2?=
 =?us-ascii?Q?/T4mr6USGUxP7EQVZvPHYxSF8bX9adC61MaiUDi4z+TGW1ItdLAbmsFTFoZM?=
 =?us-ascii?Q?voMYLHX0e00smUM1F6tSapeDEWQzFCDOQW+IPaK6FxzsgbJkd0yKJBOdpUmd?=
 =?us-ascii?Q?gxji6nykWmiofVe8oD6+U+mL7piYA2ktA1EBPjzUZokKSM+edPUoBiRWSTko?=
 =?us-ascii?Q?iSZq1kcf2kB1VW0+omPrKF0KkGVXbGutAAhIt2ih8pgSYOdMlMgwYgx1n72h?=
 =?us-ascii?Q?f+coxsrXps8VXmLF39sP9gr2IMiLbvS1Ba1ptT85?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e08c7e55-88e8-4612-1414-08dd1861c76b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:57:19.4940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkVSj5XibkfdkjXZtcMF49OkIhXkVaYGz1AX/GepYwtvfoD1nvPr5ocnBUjTa5yM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8598

On Sat, Dec 07, 2024 at 06:49:04PM +0800, Yi Liu wrote:
> yeah, the dev->iommu->max_pasids indicates if a device can enable pasid
> or not. It already counts in the iommu support. Since all known iommu
> drivers will enable it once it is supported, can we say
> dev->iommu->max_pasids also means enabled? If so, in the HW_INFO path[1],
> we only need check it instead of checking pci config space.

That would be nice, and it is better than checking config space

> 
> > > - Nest parent domain should never be pasid-compatible?
> > 
> > Up to the driver.
> > 
> > >    I think the AMD iommu uses the V1 page table format for the parent
> > >    domain. Hence parent domain should not be allocated with the
> > >    IOMMU_HWPT_ALLOC_PASID flag. Otherwise, it does not work. Should this
> > >    be enforced in iommufd?
> > 
> > Enforced in the driver.
> 
> ok. BTW. Should we update the below description to be "the rule is only
> applied to the domains that will be attached to pasid-capable device"?
> Otherwise, a 'poor' userspace might consider any domains allocated for
> pasid-capable device must use this flag.
> 
>  * @IOMMU_HWPT_ALLOC_PASID: Requests a domain that can be used with PASID. The
>  *                          domain can be attached to any PASID on the device.
>  *                          Any domain attached to the non-PASID part of the
>  *                          device must also be flaged, otherwise attaching a
>  *                          PASID will blocked.
>  *                          If IOMMU does not support PASID it will return
>  *                          error (-EOPNOTSUPP).

I'm not sure, I think we should not make it dependent on the device
capability. There may be multiple devices in the iommufd and some of
them may be PASID capable. The PASID capable domains should interwork
with all of the devices. Thus I'd also expect to be able to allocate a
PASID capable domain on a non-pasid capable device. Even though that
would be pointless on its own.

> > iommufd should enforce that the domain was created with
> > IOMMU_HWPT_ALLOC_PASID before passing the HWPT to any pasid
> > attach/replace function.
> 
> This seems much simpler enforcement than I did in this patch. I even
> enforced the domains used in the non-pasid path to be flagged with
> _ALLOC_PASID.

That seems good too, if it isn't too hard to do.

> on AMD is not able to be used by pasid, a sane userspace won't do it. So
> such a domain won't appear in the pasid path on AMD platform. But it can be
> on Intel as we support attaching nested domain to pasid. So we would need
> the nested domain be flagged in order to pass this check. Looks like we
> cannot do this enforcement in iommufd. Put it in the iommu drivers would be
> better. Is it?

Why can't it be in iommufd? A PASID domain should be a hwpt_paging
with the ALLOC_PASID flag, just put a bit in the hwpt_paging struct
and be done with it. That automatically rejects nested domains from
pasid.

I would like to keep this detail out of the drivers as I think drivers
will have a hard time getting it right. Drivers should implement their
HW restrictions and if they are more permissive than the iommufd model
that is OK.

We want some reasonable compromise to encourage applications to use
IOMMU_HWPT_ALLOC_PASID properly, but not build too much complexity to
reject driver-specific behavior.

Jason

