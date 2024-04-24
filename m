Return-Path: <kvm+bounces-15861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5148B12C6
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64852283DF4
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307072C1B8;
	Wed, 24 Apr 2024 18:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oYDKzNnk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A242B9D1
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713984357; cv=fail; b=rYQiuHwoR8IYBwi5t1Rxgl48bAyIsAK8xmWPuk4iEruUA0H9LXM0l7+3kA5OEAkdQXV5OYh8vAl4nWwDP3r3j232XIdbm/a9rZTOTSie2TVSd/aEDxGtYrfIuDX2zbOLCRKLn3uqiEhDN7sabc/kQtemFMGszpLmT//ltBfxhTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713984357; c=relaxed/simple;
	bh=vlATrwa55dG00UHOD81SvIBBNqvjy6YZO+amzUiIOGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ByBFIDmQ/b5BCtcAhbLnDp/QMkLbPQmUCJE9nMokWDsv465XNGqkoPCk2hd68vE0/J10v2l5zz79Se0nVTrZE9yGvdApWxK3HZpmGFvDXj9wnfWIUyJ2zQVBNSyhmmiB9fZA0gnGYsf/1eVLgFJDge/1Is84/UQCrbzrk29yV5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oYDKzNnk; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7zPELH/mIJ/ByrFaCDr87QFw7x99Qj5JnxUEcIhWyQ3UBsEhpTAgTTzmB49WBSrs4i9XbdPoy0HQhuqYB71NzBdjgoJKGKx0/JUHbfOWUb+yxLHT1uekwW7iy9BJgEnVELv4P5yt7y+2IhtSALKAJ7L0stqAKWfbAWe8uO1mISJLiPd3KB2t6KLYofpH1IaWTDIH+94dl3a+H6XDH/F98jeWS56O1aMdG08642+/Yfp6HAK33ufk+661x5CIi/ukh5KBSy0yTqnTPqB9TU4RJrOpAOS3OWtpodLBgwe2eGDxqwr5HXf7rBU0ozBlNjR2ZLLgB4bEl50Om0t2FwHWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anATDYfrDgD4ff8Y8adcIaSWYHz0hXXw7hs4yL9gcNk=;
 b=WyiwBpjsfczu2gcdLXsqCVnjQHxtUHQn1ruQ4WfkTTe26seEF8g7Ue10NIlVDi1KpcpJHthcNxqLF7+J5ohhP07naZAXz1bZTvtMXaahSp0ZQqrcN/7/+BEe6ufC7XS0YTtMQgo0401IThkjxh25SJICic1MLTisti3q5KaM4WV8c1bpIb2BxRXONQ97AbDSny6NtUC90eNYoTCFAjbl8inOAfCZnov6xwkKzZXCRc+0UeB2SgoF7zb3FKsC4fjDOGVfFLO8CKsgiEBtLTzbJe9pLstRtaoB/t4uzWH+kDEenFlSwbO4VggFFfnHqYpYmrlhxRUIijaahk1A97YiQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anATDYfrDgD4ff8Y8adcIaSWYHz0hXXw7hs4yL9gcNk=;
 b=oYDKzNnksb0fmmL04mERjFKEaX+zrHi74woRVyadaPGF/nhgvwInejrcAalhOtvRKUWXsL/UUN++Nz8A+Gp6QX+vQ8AI6/s/LbK79jxUZJvJcBCMi1Sw6ff0k/VngPioaSlYbwZgbb4xwWg8XPMeNPGYXXXenj/vgNTxRcCt0BPPE+xu3zj3sp9hmvX71MOeI3+W+YwZzxpLhv4Jstc+ePK5eCJw8lNTAD1j+6VX40ZuIhBqVq/7RhDU/4f2UjyXFJIjPnZzJsyOqxM807yDE5D1P18RaQH9Bhk+R1M+xQjsUQDcAIUitdBC9mj2VDsuvNm/e+zhyRhTU0PFODIKEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.23; Wed, 24 Apr
 2024 18:45:52 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 18:45:52 +0000
Date: Wed, 24 Apr 2024 15:45:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <20240424184550.GU941030@nvidia.com>
References: <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <BN9PR11MB5276183377A6D053EFC837FD8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424141525.GN941030@nvidia.com>
 <20240424123851.09a32cdf.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424123851.09a32cdf.alex.williamson@redhat.com>
X-ClientProxiedBy: SN4PR0501CA0054.namprd05.prod.outlook.com
 (2603:10b6:803:41::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fdd2487-72a4-4b5e-f57b-08dc648ec4a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LAyu2gr8ZZ9iQzMkLDRXU4sZX4afbn0n5adlmTUD8/GDm1pT29lmnGRsGtef?=
 =?us-ascii?Q?EJVDghD3ziaynWEDbS559aGlSVCuLVQrMhvXxirvXeKUDzh2fUcHVl7rt4US?=
 =?us-ascii?Q?pLmKlbhWUd9OeBENiN5MK2KuQYEG0kEuIBlhUSg4gB4zSs99eWWgl2rq1n7r?=
 =?us-ascii?Q?jAgOLA+900N9gQOun/V8ZS14BjHKO0OOJck0ESZkOi8pU4UEfzjEvCpUUR3E?=
 =?us-ascii?Q?aJc9gd/A8pLZYOC0q70NL1VJzLlOfBTk6AUuftCu79gfpPhk6D2rPvH5tEPq?=
 =?us-ascii?Q?laBq65aothXyZBqbQN3qpepgkZy+3WMw3mCefp0DaN6jJeGwgGrBTE5e0U14?=
 =?us-ascii?Q?NdoMGIVEwbUYU5eXxAb64SW71VzK5w3rxGkR9SHG6aiK0Lp09OiEpK8vioNJ?=
 =?us-ascii?Q?/XgCFH6Kkfw91m6kQEHEIe1+lxsUCcGZAKTsIcVosilYxzxWFAa4lA7ls/bp?=
 =?us-ascii?Q?BLiZHHQNqWmk5yoplTxpeRm6N0F/r8XO9UjyCDaBdXg+7ZkXkz3oRZVGAUl9?=
 =?us-ascii?Q?d/P+BWgHIhiVXP6YCk0IwsAGtVgPeSuh6am4VtZ6F20nrsYnzT4wxbKJ/U3/?=
 =?us-ascii?Q?qsZuijo54yHDhp6MrWcf5zI05N7+0jJ17m6WZ7AQElvJIFKZjvxQx1/4+2/h?=
 =?us-ascii?Q?ryipvV39fioekK7sC4t8YypnRzG8tLGpFu0885NtCKv3ilFnFe/KBa0dSknj?=
 =?us-ascii?Q?zFdhF65Cw4NIu7sHWLsR8YauYmYjmxFPWJ5NI8G5bEvNXLg6qvJiNUaEP8a2?=
 =?us-ascii?Q?Mr48Q+KSmm3PGN2KhgxjD5i/MubDI7f67SO/uOshMzIniEV+lERkyDREIhOM?=
 =?us-ascii?Q?Di3Bm5JCFUrzREVb2lyqCMIilmPOBOjioVmsSo85+soAPLy7oeFIEi3TWpu9?=
 =?us-ascii?Q?F8bjYHkJIANyLryNkypGXKwabQP+NmEs7q6xzpVUlcJRVovKwuhZjN41wzVT?=
 =?us-ascii?Q?yGM7VvtZwCqlFOoN7naawyjzRpxk6mv8ESnuuODSl97TgI5Jn7VfFZq3WreH?=
 =?us-ascii?Q?2okaB8YczG8No5KMuilH24/WuBbFV/HeEgy1/CC2kHJsY5tYiMau4RTxLq7s?=
 =?us-ascii?Q?/bDVARyBkMKn5+hUYLbAf4pU6K1hcv+LHTOO1Si99MuZXjnvWOP3G/zunFdP?=
 =?us-ascii?Q?i6kXbFvSM0I0Rc1AS3k35ycqW8ec3Xbeh9zBng9Wjt3XvK7majM5NDe0KCMs?=
 =?us-ascii?Q?lBwv0QHJfUb98+P7U0DBi97N5DO4+I8VvVXhlxfwtUJNnq1z8e/A07oIdIUB?=
 =?us-ascii?Q?91J7R9GfXlkzgx/Xk3DAS0McpT3K2tfeFIbB7PhM1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9NCdkZ0m9lImVK0QoX1KO6WkwpTWEWNsWD7zwJg3l5Szs/sttFvqxyDsfPSI?=
 =?us-ascii?Q?AaKrqrGuO63fOhNuglTX7U5oDjYLsq5vmFScyArn8feab0uozpWTNV+VdkXw?=
 =?us-ascii?Q?X+8M6Rfc4GbCnvvjZa1OBL+/x4pXWE8QgMcTMgSQiHgNjsJd+yFi/1U0b5QI?=
 =?us-ascii?Q?sCBoj445Zk0u0X2yixy8xOyTMyqID8Wa3Evz4eD3AQQCVxK3fqw1pprVWqgw?=
 =?us-ascii?Q?H08iD2YSP0zE6c68lYALtiZ28Xk4sRfHe+yzQC8cRUMs+6EhmY7CvoJFjaXY?=
 =?us-ascii?Q?T+RbWZRnqUGds2NGIaEOyAZioIQZEpzzfan/2/as2W+DUIsokaM1GC3YKL/k?=
 =?us-ascii?Q?+Bt2HNhCy/PUcsq4WHkOtQIg5rpdebnkkgxBVBLF6cIBqu030Q4mhTYp94xj?=
 =?us-ascii?Q?d7I+DWiXO/h4haIWv1SNfsPf4VsnRS9n/qU6CwhyuV1g0HW0C+D1t8Z6OPC4?=
 =?us-ascii?Q?vj4kno8tx4Sacc4cjB4BWJLkZ1MLoNhmguOA3ZVXEZ/Y0s5Cq4R0odkf8qln?=
 =?us-ascii?Q?u4zZanVgArEaX/OBmnlUQp9ZUNiygnmahHuvu3o3YkjId/lDZCAMaAIo6cXu?=
 =?us-ascii?Q?eeK1Gsp+bdu5ypSXiPaBMmPrS2ndSeCACPPe2mdFwNay33BLMVGTKNJ4uUvn?=
 =?us-ascii?Q?SXVYHUZ1/VJ66oIOgt6YiwuGNXaU918CKX9Rxxux7gyUAXL+yzEWieDzhEWE?=
 =?us-ascii?Q?U+Ld7NIKPM0QrpT2Skd15M40F7cUGE20ORrJ93ppv0Te3HHxssfwKtqHk8qO?=
 =?us-ascii?Q?hAz2bo4ymZ53BWmSgt+vOOCmQJGAYMLaY5GnUWcLYKaHhBi46ZzQcleCR3Yn?=
 =?us-ascii?Q?siqtyOG9nPQmJnL0rHO1bTKMfKzjQGtkxuVOKMqR1jXPJvqcIHXF4xNGs/NH?=
 =?us-ascii?Q?qpbVW4tLinTVNit9Ccqb5fD0i0Kx3HDvBMwN90TAmWFFQWDUJRTrQiecePJy?=
 =?us-ascii?Q?qtB5mHaFDdUYDH+MvlBnBOIitlzCD7jAlPU0xOlelPsOj5l6FfpjUGB4+Cvn?=
 =?us-ascii?Q?ntayTonJl5HT4KyKpx5P7RcrpEsIkGy1MmLCjuInJyncLlu/nwglXHa8VOXM?=
 =?us-ascii?Q?I8gn0a6jkFdO9Zq/HUIKs5lpqqeFi5KKSHIx796QL96oOmH5fTeplWiCzSzp?=
 =?us-ascii?Q?209Qa8sr2zEyzslfx6UMMEkkuNf1KGF62dRtl4qz+nsvOVdOuhSg5ukFK5BQ?=
 =?us-ascii?Q?waGz17yooaZEjWaRvINEXAX/PGaOuULUSkaNANVB0WMJkXBA9ElMXIqwmYgI?=
 =?us-ascii?Q?YgUhPbPoCABjKSy5JyBtvm70faLUKxnJL+0tCV85WQVeTJgXEc5yfuG95Hgt?=
 =?us-ascii?Q?vvkrg7p2xghvScJ6JgtXHLyWLJC+YKH+TuvOWvkmYwXQnfTH6MxZqTmsyw+H?=
 =?us-ascii?Q?a0HjmrDwg5lQjajMX+5uWQgEBydo8fWcTyZ8GPNoIP1QJZekQ2kfI2CG2xCH?=
 =?us-ascii?Q?PQdPxjBQsOroO7VvfW5xbGaaLsD1U0zJTf4+J4WW6LZmvzes3Lmgg/onxSwp?=
 =?us-ascii?Q?4SUOKx6MiySEswfrwVZeYWJ6dHdGY7hAKFr3zdeptdWp0DbhT6QqIK2iCUa6?=
 =?us-ascii?Q?W5+jp0zjostvYlYO+DQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fdd2487-72a4-4b5e-f57b-08dc648ec4a5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 18:45:52.8350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ouun3SOR8OOCFsJ9UztFP78yTBEMruUYjoVs2/kDHAe1Gmc++Tp0GXvHPfdBOlDb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733

On Wed, Apr 24, 2024 at 12:38:51PM -0600, Alex Williamson wrote:
> On Wed, 24 Apr 2024 11:15:25 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Apr 24, 2024 at 05:19:31AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, April 24, 2024 8:12 AM
> > > > 
> > > > On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:  
> > > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > Sent: Tuesday, April 23, 2024 8:02 PM
> > > > > >
> > > > > > It feels simpler if the indicates if PASID and ATS can be supported
> > > > > > and userspace builds the capability blocks.  
> > > > >
> > > > > this routes back to Alex's original question about using different
> > > > > interfaces (a device feature vs. PCI PASID cap) for VF and PF.  
> > > > 
> > > > I'm not sure it is different interfaces..
> > > > 
> > > > The only reason to pass the PF's PASID cap is to give free space to
> > > > the VMM. If we are saying that gaps are free space (excluding a list
> > > > of bad devices) then we don't acutally need to do that anymore.
> > > > 
> > > > VMM will always create a synthetic PASID cap and kernel will always
> > > > suppress a real one.  
> > > 
> > > oh you suggest that there won't even be a 1:1 map for PF!  
> > 
> > Right. No real need..
> > 
> > > kind of continue with the device_feature method as this series does.
> > > and it could include all VMM-emulated capabilities which are not
> > > enumerated properly from vfio pci config space.  
> > 
> > 1) VFIO creates the iommufd idev
> > 2) VMM queries IOMMUFD_CMD_GET_HW_INFO to learn if PASID, PRI, etc,
> >    etc is supported
> > 3) VMM locates empty space in the config space
> > 4) VMM figures out where and what cap blocks to create (considering
> >    migration needs/etc)
> > 5) VMM synthesizes the blocks and ties emulation to other iommufd things
> > 
> > This works generically for any synthetic vPCI function including a
> > non-vfio-pci one.
> 
> Maybe this is the actual value in implementing this in the VMM, one
> implementation can support multiple device interfaces.
> 
> > Most likely due to migration needs the exact layout of the PCI config
> > space should be configured to the VMM, including the location of any
> > blocks copied from physical and any blocks synthezied. This is the
> > only way to be sure the config space is actually 100% consistent.
> 
> Where is this concern about config space arbitrarily changing coming
> from?

It is important for migration.

Today with the drivers we have the devices have to take care of their
own config space layout only in HW. We are not expecting migration
drivers to worry about any SW created config space. SW config space is
a new thing.

> > We may also want a DVSEC to indicate free space - but if vendors are
> > going to change their devices I'd rather them change to mark the used
> > space with DVSEC then mark the free space :)
> 
> Sure, had we proposed this and had vendor buy-in 10+yrs ago, that'd be
> great

We are applying this going forward to PASID, and PRI, which barely
exist on devices at all today. We don't need to worry about those
10+yr old devices that don't support PASID/PRI in the first place.

I think this makes the problem much smaller.

Jason

