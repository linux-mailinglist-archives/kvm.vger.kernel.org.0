Return-Path: <kvm+bounces-16055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8EB8B3988
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 16:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF5BB1F23C83
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 14:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42320148831;
	Fri, 26 Apr 2024 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hgi42lR0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822A61465A1
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714140683; cv=fail; b=aCejLiMC13OEjkVIyTMyhUgOp5DGwnbp+0t2iegtMOrsv0v/wZX+SRUS91pmdwtRBVk6OuPQJU1Iz25IsiPK80X6iS4dVn9uUvQ0n1fluRXFxkMMKP4v9JVHE/pgSE9Rl6CKwGBGL4AMnA0p5nisd6WBwlBaJErteO+Do3UKTr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714140683; c=relaxed/simple;
	bh=XSxcp3x85LUzNrcjFke397TcbP92309xH9hTN7PkdwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QT04A/vnB5oyoBRHcA7w3CrL8Z1hf/BpvG/5HEe2n/oksKL+EbRvFC3nzfIVsA1r5FnNMmXZfkmO8lHyPjqF4/Qvr7F1MU2Ix14nO6zzH0LeaQRITNLBWlFwhl5bo+oTI9mAJxFU+5h299fw6URdEZvZ9UBkaIWSJqfIp8wG0FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hgi42lR0; arc=fail smtp.client-ip=40.107.102.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcQsG+JgJyUG3flFTWMZ8CuIdM48ibX9WbODpPH4Z0GPFvgB895y+TOBqzI46OJS0BZLMF1WoFdDGrkDzohi1xfroXebVM6cl2jM1BCvjCmW144lyC9Ccc7JZt2p6LdON77xhY2SzneutZr1Abu+7LxfcoW9rFxckLOx0z5DoZ4aceabuhb0fnACyLYx7jx23x66EPSBGsFEcF7TOwuBMjHQYHpwn7uLkr2rvimbOZ2wqexp/dH7fn7n0QxTs6qyPACaUZY//Eyh44TuLkk2SGpcd3WY2nTnT6N83kA4T8p7Ij1WcaMo4/EwkmzFvzlqMBi2Se2Luv2LSMyBNwkpeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdkM9BTEo6pjMoXqpWHn2lg8qCWYSw607nSpyG8frNs=;
 b=hguKZlmEYMnISqpCJqaHeWn/zKEpx0D59LQIjcZ5JTcnMrlyx65Qt6VXgo1Tt1bbclF7P/DNicuwDKQcun7xO0kRTNSDWEztS/9bJ8X9mQPHSGgC0+VmyQjNbVfhpiy1UYmDjvyN0Cd/5uZDhCHc9e/Y3Sdxs5Zh1rGfGRaZy/BpgKCZduW37PF2KbvcvqRE0itrOzwyn8Uxys84NjeM8SqdhSxfpLzRSZlCK3xzNMQ/mkKEomqoGF201bLI07V0tyiQmPW+dwDHr+5tIzMdhFIJGS09wLtkWQmpXupi55IoJQk4cjIwQDKXzXuS8KivbYd54MgRdqpvI33IVR33Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdkM9BTEo6pjMoXqpWHn2lg8qCWYSw607nSpyG8frNs=;
 b=hgi42lR0Efj/dQ+ommZ2o9yaVmF9LQs674g/+vPyPg7yfXOzdzeH8uiaKTjClOYC7JIPY9ONUhJrOjAPF2QCQTDdxre2SGOITnHWgZpIgTeSmoaxcwMp4R6IuGgWrRVJsNEhqHiSU7cVGDhPStwQsLxJ3yPGpeZSFCg0jNGsyLr+1UWGbb0mE7zqsLUXEVMNEgzEV0TFeqk0+cTMt3zFMn/iDX03eIXNiVXBUZZ5peoD6EYcpcpdW9UZUUGIxuJc/E4oSyYFmB0U5CojEZE59bPnA8RUizsNqVpyK7jYAPJzUnv0isLDVBxu/IlJCiZkCCzZ1SQ6KDJaWXq0k+aSEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB6544.namprd12.prod.outlook.com (2603:10b6:8:8d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.44; Fri, 26 Apr 2024 14:11:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 14:11:18 +0000
Date: Fri, 26 Apr 2024 11:11:17 -0300
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
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240426141117.GY941030@nvidia.com>
References: <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424141349.376bdbf9.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR20CA0031.namprd20.prod.outlook.com
 (2603:10b6:208:e8::44) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: fef6e622-ddbd-41d3-3d5b-08dc65fabe00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5fMiwEAxlrFKES/LRe3NlTImMwTOF78kUj3FP6ZjipSRSnlOgYhjKioXrP1h?=
 =?us-ascii?Q?yeygDFGIb52eVlJkMgT1q5rByDLcHZxDvJG2ItrTE+QqU0jQY9hYgUEih54c?=
 =?us-ascii?Q?PpdksXFZHZl+dv0bsIuxiBD4v84AWBDmnV9LuHtkI97RMm3osxKnVFJ1R+YB?=
 =?us-ascii?Q?IpQGMAOmoDv8rlvN31ByPykVVV043ADWWQwAihJ7On+6kqAZlBHjV+CcY7wI?=
 =?us-ascii?Q?B2X3TCvZNAfDD9YNHlFwIkRvnSqW7WGbNtCenBSOfADIEccitTt2ObvxTj2V?=
 =?us-ascii?Q?tgJMchCVk0WPrIkBM8eAxxW74EJHyu/3PRFRjLXaSf+E41xyTyUoUAjHHlpt?=
 =?us-ascii?Q?Fn+eUGXWvBryRGLuULXHSwM+VRlyaW/VhGzcKEliUkJczKU/kNDrprBOW/Iu?=
 =?us-ascii?Q?FO7bnk364GTDgrdlguUxC8AVfRubKIwUTcD54W4dKqOh2tZzpK0FGT8fbjNs?=
 =?us-ascii?Q?uoBnFKXCkSETrK0ImYDMdF5Irc7OiExjT7GmufhdSnJ/bOpocnKb+CPGpoIA?=
 =?us-ascii?Q?8KrXMU7v0Dntyfhobet5HnxvB7UDmWX0ea7YBzrburNmWE90fZzVEDMSjWuE?=
 =?us-ascii?Q?Ibs4/92wei3yrEzNl3kAgn+3jWb60G+3N75lh5Z+rQIp5UgJmZyY+aDU42wD?=
 =?us-ascii?Q?6e7EJzNo/k3E9HceL55yOEJZusFSs4+cPEGn9x8Jen8lV4A6mHimRcDaGwAk?=
 =?us-ascii?Q?5S24TbjcNpAHM1VsNUOTpQXaZhCfAGD4As9NqVFnndFShMk9+Jyoinlkismw?=
 =?us-ascii?Q?IMPSgOPPByU5reqdCiINU2Dvmmlbk+3Fd8/DYu8yKyjrdPD7+iUGxKmZ8s/z?=
 =?us-ascii?Q?etdNh6n/f9NvIXWKMH6iUxhECC8Pu1SDiJDR3J4ad/aPcyJIidiEbh05t/O/?=
 =?us-ascii?Q?iQ/L0QgyRj+1Oyq410odaYuXtKC1Cs3vSHbgJfwsz8USwPaYlbg9KnrF0BIM?=
 =?us-ascii?Q?qqtmBovVko7TGi5m4A9Au2VYCf2aEmyFXkp0NDf3xxXTwMOVux4dwi61lG+/?=
 =?us-ascii?Q?svpcgxQILNSdcDQ0X1SY9ftzKT3ckfAsbzAHRgJHOaTolktx7Qnd6ZyY5b1w?=
 =?us-ascii?Q?/LgZe+joxfZIakfPlUBCjSkFU9W6DtrJiQw/XTcvRKtdHbNQyIyHPwygu8KL?=
 =?us-ascii?Q?zOVa3Q/Q3fm7LtNUWiTy1mgMUUoXuuqbTZl6zEpSKhW+zOej+kIcJwaeJqjV?=
 =?us-ascii?Q?zrRaKD0sIaL9/B19bD/N7V6LlfLrjwk+5lAbTBnHYnCvIW8Phk3WZsECHBiH?=
 =?us-ascii?Q?XxMVh0NKi/ktgza6HA3Q4W9DBTg3NrgB/qEuiQY8og=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AMIiTp2FzMOYjyB+48tjhgFKSM1WsvAIyg64qTxcT0fltqvi0LvYYpvrvgPd?=
 =?us-ascii?Q?SjT7N/wLwZcQkKYSuAgylEnc1LD90RaMPI1rfCdKRF/nO79DOG3S7MT78rxW?=
 =?us-ascii?Q?Xg8zZtcdj7uANHQdDE1Q/aT58vRiEpD8FWpg50Ggmtu4N7YpsjJfglu/mEgi?=
 =?us-ascii?Q?4tUhl8B3mDMCGVKMjPIgwYtkooVDpk2C4EaIFe5ZA0HHLRa4H6KcUa/Czq39?=
 =?us-ascii?Q?wPvmmtq7vS/zr3WeVKvj7F5vuCo0DtwoFrpcL2S6l1QRkmk2qB71JpT/+vMC?=
 =?us-ascii?Q?cTOhoXZMSzo3WmNYgPRG71LEMm4FnK1JiPYC8RBMBJI7VjA0EguBkPPu8rRi?=
 =?us-ascii?Q?L8SJZMSSAZkd6L0Yp9KjT5SdxraZ+IF2UHZgSYByOzesZ1my1dX+a9pqkce5?=
 =?us-ascii?Q?/tf7Lqbayl7op8oihH5Dz3xV0S2dyLpVp7nW0DFhEgPONn8I61QEfPhMmyzH?=
 =?us-ascii?Q?jl+912NEI9tohHQxnDFyW3CN0r6u/Sh8STboSFHrOXzgykrr90+hkf/veF9X?=
 =?us-ascii?Q?6SjNd6cDcsmmQuCb75/GAVlhaaxjZ5dd0vmc0/x6yS/fH1iceJZ/sqCjbMeq?=
 =?us-ascii?Q?pYlV0Fgsqti04uGyrNDN1KxpcHWsRaTGqWMuASKXBJqdxN2CxF+nG9jiO50x?=
 =?us-ascii?Q?yZc9LNoeE3lG20Ma0W5yrwpsfyLAlvIRZAO6FFusW5dp2oEAImpNyJH0u5h6?=
 =?us-ascii?Q?PGj/hOwRjHJf8xgPUg5NKTwXulpSP62dUjtxkEBGySf89vJlJXFC4KL2UZYI?=
 =?us-ascii?Q?jJn1wnIPySxsITFbjWBQeFW+gMJuTxVQQxYJ0fBGfpn398cKzrH7OrkvE+ar?=
 =?us-ascii?Q?5jpO+K0GnzGFPWkctVYZAodkuSA1EVksMLtb857HHki0nk1RyAJ98PNH9mQo?=
 =?us-ascii?Q?umI7GlnbWn2/7GqQHSzguHEFVDBG6yM3w9aKlX4P9REeEJBY9kS/Q53m2U4P?=
 =?us-ascii?Q?GaRodolYBKrsU3IQ/+8/grcowd7KYUi1fEJpodEzBqOVtusIeqBWu9VMvwjl?=
 =?us-ascii?Q?xRlpsVHNBKUhl13sV0lemxiFBzAG5ZjasQgD6MpHBm+BnKtkJRKrmSpMwaRU?=
 =?us-ascii?Q?mtDbsKiMeHfWyJ3OZJi3YqRU+9v+TFy6H7y5mrJC3F6CXNNagENKQOQqK4Rz?=
 =?us-ascii?Q?ba6NJ86ZgyCDNF4sh9dlD8RssOwZ9q+yHy66gJovcbCqWutHAE1pOQyKvFA+?=
 =?us-ascii?Q?DRYZHUlWJsHUWjMnoQpED4/ITUWM645zMhGxpFZ58quyM/82ue4mb9QrjPfB?=
 =?us-ascii?Q?fmSHI0C8ixrPWUHa/ZgMlv1wGVWKtOGewc5eqKjHlOKRegHQnfyd/2YYYtNz?=
 =?us-ascii?Q?LOxlh6Co0Yf5xUt+v2mMcdQE76C9miRGf77XoeLgFv0PpC7XtMdsb2CwTMHb?=
 =?us-ascii?Q?tuK94uLcT3PfbSuRKPX1lsKc6TIUbzUUsLs8rmwM0JwFpnOJ+PqtwHTeiqz1?=
 =?us-ascii?Q?u8im6/QR9FDDFCSnnwHBURo6ZFI6AbnwheYM952oqQidYhNuVLzfTIBjjcaf?=
 =?us-ascii?Q?fzwPYsb6Fvjzi/rkTSYstU/8FQnUYj7TCeFBj6D0Jfe5LiGNdqgyxHTAx/nD?=
 =?us-ascii?Q?XQ7E2pI6Qm5AHowzu1k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fef6e622-ddbd-41d3-3d5b-08dc65fabe00
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 14:11:18.5251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pfMRoasEhzTkNu6CpWti16TGZ45eJXVvMCde0AlB5gQ9oYugAaOGEq+EHzP0exoO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6544

On Wed, Apr 24, 2024 at 02:13:49PM -0600, Alex Williamson wrote:

> This is kind of an absurd example to portray as a ubiquitous problem.
> Typically the config space layout is a reflection of hardware whether
> the device supports migration or not.

Er, all our HW has FW constructed config space. It changes with FW
upgrades. We change it during the life of the product. This has to be
considered..

> If a driver were to insert a
> virtual capability, then yes it would want to be consistent about it if
> it also cares about migration.  If the driver needs to change the
> location of a virtual capability, problems will arise, but that's also
> not something that every driver needs to do.

Well, mlx5 has to cope with this. It supports so many devices with so
many config space layouts :( I don't know if we can just hard wire an
offset to stick in a PASID cap and expect that to work...

> Also, how exactly does emulating the capability in the VMM solve this
> problem?  Currently QEMU migration simply applies state to an identical
> VM on the target.  QEMU doesn't modify the target VM to conform to the
> data stream.  So in either case, the problem might be more along the
> lines of how to make a V1 device from a V2 driver, which is more the
> device type/flavor/persona problem.

Yes, it doesn't solve anything, it just puts the responsibility for
something that is very complicated in userspace where there are more
options to configure and customize it to the environment.

> Currently QEMU replies on determinism that a given command line results
> in an identical machine configuration and identical devices.  State of
> that target VM is then populated, not defined by, the migration stream.

But that won't be true if the kernel is making decisions. The config
space layout depends now on the kernel driver version too.

> > I think we need to decide, either only the VMM or only the kernel
> > should do this.
> 
> What are you actually proposing?

Okay, what I'm thinking about is a text file that describes the vPCI
function configuration space to create. The community will standardize
this and VMMs will have to implement to get PASID/etc. Maybe the
community will provide a BSD licensed library to do this job.

The text file allows the operator to specify exactly the configuration
space the VFIO function should have. It would not be derived
automatically from physical. AFAIK qemu does not have this capability
currently.

This reflects my observation and discussions around the live migration
standardization. I belive we are fast reaching a point where this is
required.

Consider standards based migration between wildly different
devices. The devices will not standardize their physical config space,
but an operator could generate a consistent vPCI config space that
works with all the devices in their fleet.

Consider the usual working model of the large operators - they define
instance types with some regularity. But an instance type is fixed in
concrete once it is specified, things like the vPCI config space are
fixed.

Running Instance A on newer hardware with a changed physical config
space should continue to present Instance A's vPCI config layout
regardless. Ie Instance A might not support PASID but Instance B can
run on newer HW that does. The config space layout depends on the
requested Instance Type, not the physical layout.

The auto-configuration of the config layout from physical is a nice
feature and is excellent for development/small scale, but it shouldn't
be the only way to work.

So - if we accept that text file configuration should be something the
VMM supports then let's reconsider how to solve the PASID problem.

I'd say the way to solve it should be via a text file specifying a
full config space layout that includes the PASID cap. From the VMM
perspective this works fine, and it ports to every VMM directly via
processing the text file.

The autoconfiguration use case can be done by making a tool build the
text file by deriving it from physical, much like today. The single
instance of that tool could have device specific knowledge to avoid
quirks. This way the smarts can still be shared by all the VMMs
without going into the kernel. Special devices with hidden config
space could get special quirks or special reference text files into
the tool repo.

Serious operators doing production SRIOV/etc would negotiate the text
file with the HW vendors when they define their Instance Type. Ideally
these reference text files would be contributed to the tool repo
above. I think there would be some nice idea to define fully open
source Instance Types that include VFIO devices too.

Is it too much of a fantasy?

Jason

