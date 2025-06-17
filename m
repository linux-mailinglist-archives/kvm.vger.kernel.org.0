Return-Path: <kvm+bounces-49725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27CDDADD26E
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07A3F3BDC22
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CBE2ECE84;
	Tue, 17 Jun 2025 15:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QcncC70b"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDFD2ECD2F;
	Tue, 17 Jun 2025 15:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174924; cv=fail; b=pUE0COAvCM+91bwENMprISPy1i7OGMB6BMbF2/EZueBfsk9NnQEctgAn+FyTYBBZCDgidTJVUOn9Bwj8FlL1DVl8jwIz86vhjIa3Q7E0q2MhVsNoqtbeCqxXPmEbgupOwrkb5iHOA5xlcKBuP/dFmKpxPuWpLy+MaMQKI3sIb98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174924; c=relaxed/simple;
	bh=J1GhZKF6kPfguMXhnUaKjvosIVZFUhSHMHCM+rIoDzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o7RTlU3f7cqjKOJ063ZPcFfGaRcY0jfZnoSHIOgx/jL21O+l3dzH5M2EatSXwN/fZffFge/41BiBjh91wfaFgH1oOOO8GdnK2FRa5DWmbjIxjAoJSLogab6QVqaHxjS+V8+RZX8fcdcnjzwfhB68gLXUJogSrFp+Z7UXsowPkOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QcncC70b; arc=fail smtp.client-ip=40.107.236.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jirvKFtS6LrRkdTUMGO0UR7OMJfrqnIZ+O8HALnCQQScD7PIb/c/fM7AWh9rcl/65TDjEvOE+/edKEPIb4Mb56H9hKQkM34X1oNCoZqSSN3c/loYm8zDC40cb9jon3jtRS5qCOMwpUMuwteI8JpyW5iD5DVIriuTZx+mZDujpE3nrLkQnQuVTTtJf0fJVy4TMMZ2jlSnM2l9Rz4dHKffL1SZ+r61gUAeTouao3AA/GW6DtQU1J4ddxTOoAEWktm3qRBsWBgUCOyER91bDWyHUhgcpVferWc96efopXoQjS3kVzUgM+lIkOkUEcjnX4DipF0le4BpmMOQyOf6ChBSxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DZfUSq0InTuKiEQl3/mCmwxVcjmVv1M+d28d6c4GU0=;
 b=WhZp0yZNtV1ydeNenGVX2G8wL1PVIca6/MsIxkk9B1fxOSamGmNiowhYDYKQE7pnp3NalFZiQ2fVhoPnoo8MILKYaD6OFYstGA1qXWFqF7DmTSkU4WO6j76CvMcNUWdhuNO/Fs4sSJNkjxxE9JLb4ECBYe1fRoD6efy/QJfH+UJ2eaYen/Yb8HPe25x34lpwtoTa41vSSD5x0TBCU+oMH9SS0zZ9DcflI1/05K28Zhm5db3RWMPYdEXPcmwp905wbctKNd3+AOe+oYCKWkIxBjR8ZuQ7fOrUFNyAaT5RQFZeAZSmPqEEPAo8sgUqn2Jr+ofV4g6+Q7fUQy3X5PArlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DZfUSq0InTuKiEQl3/mCmwxVcjmVv1M+d28d6c4GU0=;
 b=QcncC70b7NKVPwzy14UoKIA/wpstdsq4DbQ6ibkLKaCxbuHuEUxgKrLl0ru9RRRiBKPNEl3e3y06Ganno5/z9OsLmNd9Xvdm6qISLxTppnaaWokTEc9DhU4XekEdOSZkBfFHLytbBPB4XzZaZdAfktJom0hpbIfEOvC4YrTVLmYgsxRjI/ioA1vryUWNby47vaqhgJP4pDXYFi52YPhrEKQMH+7cKOzQz7KmMz7pQHOnfqHdm/ZhWT3TU7OYqgIM3LkyUOTTuDthPYRWNvfJK/5MokINH5BcJBtPzEdGj4WsDF1F0ifS/nxhsDPDu5IUoCjNi0nddi5HkX9PiPsDFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB7279.namprd12.prod.outlook.com (2603:10b6:510:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Tue, 17 Jun
 2025 15:41:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Tue, 17 Jun 2025
 15:41:59 +0000
Date: Tue, 17 Jun 2025 12:41:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <20250617154157.GY1174925@nvidia.com>
References: <20250613134111.469884-5-peterx@redhat.com>
 <202506142215.koMEU2rT-lkp@intel.com>
 <aFGMG3763eSv9l8b@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFGMG3763eSv9l8b@x1.local>
X-ClientProxiedBy: YT3PR01CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: 72241979-1cb1-46cc-0b3f-08ddadb57ef7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ULDOamojsm/nL8jSghYUGO/ef6PHglMqRFt4wY9tzvmDt8Xc6p8jTuo/X3O/?=
 =?us-ascii?Q?QDjdRoIJk0KVMDKyPT17YgzvivHSrHMhPYA48l9dMqlfobRjLf/rl+IqFgYb?=
 =?us-ascii?Q?jv5z+7LNPY2HVs02Kqr6r3Tu2k0as8RuPrMi1O02XSVaZRJyru2LC8zKHvDj?=
 =?us-ascii?Q?ZMLrpOxOHochxDrVtZrZrv9DGvtcUADEIQWn2DLZFVUpvxAgcRKesGsI20WK?=
 =?us-ascii?Q?bK0f+UoHfkrAZbRJXOClNjF1bsOFxDQjHn8BOyVnUs2JTUUX4d5I5r79wsn1?=
 =?us-ascii?Q?N+111kDWRpTKXP6MvCU+9keFlaDfHye33wISuIUpVRw8mBjx1Oz1+smLt+rq?=
 =?us-ascii?Q?eX82HBbqp72aLC8nugl8IQD32u5NO+StDraQ9Ws39mo0+nOYeEK+p+MeWMhI?=
 =?us-ascii?Q?oBo/9rbHmAjd5/SxFea2lLg7udm9ENW2opsn2CdLLXM5WJ54y9scbr36hafY?=
 =?us-ascii?Q?B5KqwAvx8AcJgGJ+kENrDnBmVycN9/Xs12wv1au8JZxVFH2lttgWCr/3CnoJ?=
 =?us-ascii?Q?I0/4IUIk0D7mW7WtFYbprekx+/vEr+gwjv4fhOB+VIcpo09b4q5UUO0bbbtZ?=
 =?us-ascii?Q?b8TKKpHdFo78TkoRvs75rIn7SyQbSLbQesd+PL1Xgw/Rya+3m1Q4m7t19Bnk?=
 =?us-ascii?Q?fH2K/Fbr8DEnl0VtQQ9TdOMfjgl5sXR/k96ftm2ZdU+0YMCts8DOijvYiVh7?=
 =?us-ascii?Q?j13wre7Kx0zPLKTyBSEqBbjlcMuotiEHr0hg6Amu22cKGdjuWr9MNXpUghsU?=
 =?us-ascii?Q?qCd+rFi7Kyvk+a2xa1Xg4SB54Lv+BytKW/zrMCVyZp5Jmce2Uic7HqvCA/Em?=
 =?us-ascii?Q?P7HINli03m+A6SDugP1Zh5tSmGdg31tcOSZymRUThPX0U9jR7nCw9SLxE2PS?=
 =?us-ascii?Q?iBPzCmWiDckaqEyj0H5QeUNu3wqOl2ViTEWX/ixWgTYkxJ39lNiCrik7CgJu?=
 =?us-ascii?Q?P1UsYUGSbGF2N1E/OG0JlTdLNtMBOzaP5zWeqUCnWMc8O7NOLwZ78Ku90bQz?=
 =?us-ascii?Q?TpzC1gkvGVzZGznqF4qcVUONGhqRe7k5U5Mhx2bLydcwlz3OtwbuNZR0D9p5?=
 =?us-ascii?Q?7jBATteFN9lTh+U3TAlXD07lLsyORD6rg5+SHBh+PTwD62H9Ihavkt22TOSG?=
 =?us-ascii?Q?YDTn2qzLHf3ACHBgmVBkjlQNckx/TCAqQGcijVw/HlaRjD9Fsv+IssCUV0pL?=
 =?us-ascii?Q?K9cL+ztNguzmc9MW1MOXzEWsSport1tPqhK3MO/bdV+TwDmuP4I9RN9AgxP+?=
 =?us-ascii?Q?vr6Siy53OdgzxDwcq+8b0cXzyiirxd/0iviqYBNMso7aSkh0gp6jlSvA5bSE?=
 =?us-ascii?Q?tcykOYgniFqptmE/RBDiVEQQOp7IL1BMQi6RHCDhFW5Q+OnZe5kOxWRQMo4n?=
 =?us-ascii?Q?zT8iqljAFOL0GrrKeBVAU5quzSxMNT6rgXeZql5ITZfXBn9VH2yugHHZ/Gmu?=
 =?us-ascii?Q?Fj2LlNDS740=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LoKynOFGtGbB8jKhHKW4c3DGuRR90wn7tbX1DA1zW1D0rDagB0gBqw3Bg+dO?=
 =?us-ascii?Q?hEFe2OvioQDjrrp9/wqwdYSGW78k+qW+w1/4eFVoKbgGm1TcLgNBlvo+8E41?=
 =?us-ascii?Q?b4Os4e+aRwhIcugJ7Sz64s0nxsJSc+UVA8zzZD9oZa8f6EulYlm9o4L4LyRu?=
 =?us-ascii?Q?ok6Pnfp0r1oI02x7b5hn+ALSMEE3MNu3mOKhtEZHvvOzwcRJPR0R65GB82oI?=
 =?us-ascii?Q?XyG6CnnFg52+KiNuLCBH5L83KIbwZrpQbKW8zajRQ3ZrdI5CawqmE6Qt8Nt5?=
 =?us-ascii?Q?/YB/O42cWhcrQN47tKcyhDWC/0qzUVo/4CDxS/LiXKumwYDQ7THnuvlDHUtG?=
 =?us-ascii?Q?G2xOyerxg2edtyrzF6EGyzbZWtGXd38dGD9P5b4BH5tbWoxNfPRZ4HLz4S07?=
 =?us-ascii?Q?83QmPRogKHwga1OR+Y0fKbB7hU5ZCax5ovLc7+messtUvoXOpiYo2nv9bewu?=
 =?us-ascii?Q?l8uVrje/DbgwZZMz3h8HE0FpgPSotE9wgjMrmP+/dv4kocmrEge/85e172Pf?=
 =?us-ascii?Q?Ks9P2kO4IGXvaf+MWk+mWBhANSHzB1JExIUFweNKnxHfur0K5VXrsxYcVB20?=
 =?us-ascii?Q?Gy4W6ArCqcyDgh6l66vHHJsB8JLav+JIbx/z+6mzWX0bv+/NluAnr7hcZJ5P?=
 =?us-ascii?Q?HPv2l4VJ6WHHty9OiU077HNGaNDZg+l63+4YxpV5oo0o8xl8fQ4giYw5yscC?=
 =?us-ascii?Q?ulBA/X9pZxN5ttYJlyFmv5PlaJhiBuimoQCVdUu1PYxrtEANUI4Sa4mj60OB?=
 =?us-ascii?Q?QwLqavIqdzOktXuh9hH8JX4NLYNyZ2nvmZAwcg+dmui4dg4O2CJVxEewMENs?=
 =?us-ascii?Q?DsJbpiwsJJu6NWhab2vXlt/FPkgb0SyMKuVZoX5eaDi7rWNkXEGr99Esnd44?=
 =?us-ascii?Q?GnPV84UzPENCX7T1HHsI+JFq/5napqipLlrDXqQNZ0DLyF1FyS1gaAPTbD9V?=
 =?us-ascii?Q?PDvMn/luQyc+rGwGE7kAUlESMyDFzlfk1GAdLZVw/nFG2xX5rWZHdLe95IC5?=
 =?us-ascii?Q?vkz0OZV9vpe7+nzOYYHneGdm99pKc6K1+S8xsNvrhHcrO7SDuzk9RUc1OvrG?=
 =?us-ascii?Q?iwXjmpaWhqM/zBmY1TCDTut2qldK14nOxmhept1I/en77AzCkKqw0/b5bILc?=
 =?us-ascii?Q?2LkTFXEj5zi6hUAbd7aoQH85SLk/nYSu11xxm1G3HeiQBy5Tyf4aq7P6KhI8?=
 =?us-ascii?Q?Dhm6Hi3PYSgTvlFynM0O/zM3Kzkmc5zJTUrjepLxdOaQlnFRgaEBuoeyv4dl?=
 =?us-ascii?Q?AsijcphtXCsqtPQnAraX4kuwmHX4krnBcuq07SJPxF0BBswP4X8/g+OZYSmq?=
 =?us-ascii?Q?Qu1Fri03JlKctz6SCuMilHg+uqV1rw4LjuqAiONn1glUFP39KC74mbYc+TnK?=
 =?us-ascii?Q?NF/lxEfkIZTftWKuQfxAwlL+YnKvTyuloDc1YqorwdH0KwbpvKMC7GHPvija?=
 =?us-ascii?Q?A8b+fa0/swa2oKzI3j55okytBhJR+iRicktRKVqnWsYpAXWHAcaTen9Lr24a?=
 =?us-ascii?Q?k3xvr/pOcmbWtHfMPYdTFoXGTXTgoQ44MBFr5gXShL8ERmzSQCFZJxapaM9f?=
 =?us-ascii?Q?LVhx/frHx65z8yeFMEQ91Fl/6m52q9iO3jKTZZ9F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72241979-1cb1-46cc-0b3f-08ddadb57ef7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 15:41:59.1415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jHapo+Bz3Xe6GEhSoP/1V2SLCIyAH591wLrrhzFk8jXWLc6Q7bu8FSUDez2wccCL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7279

On Tue, Jun 17, 2025 at 11:39:07AM -0400, Peter Xu wrote:
>  
> +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
>  static unsigned long vfio_device_get_unmapped_area(struct file *file,
>                                                    unsigned long addr,
>                                                    unsigned long len,
> @@ -1370,6 +1371,7 @@ static unsigned long vfio_device_get_unmapped_area(struct file *file,
>         return device->ops->get_unmapped_area(device, file, addr, len,
>                                               pgoff, flags);
>  }
> +#endif
>  
>  const struct file_operations vfio_device_fops = {
>         .owner          = THIS_MODULE,
> @@ -1380,7 +1382,9 @@ const struct file_operations vfio_device_fops = {
>         .unlocked_ioctl = vfio_device_fops_unl_ioctl,
>         .compat_ioctl   = compat_ptr_ioctl,
>         .mmap           = vfio_device_fops_mmap,
> +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
>         .get_unmapped_area = vfio_device_get_unmapped_area,
> +#endif
>  };

IMHO this also seems like something the core code should be dealing
with and not putting weird ifdefs in drivers.

Jason

