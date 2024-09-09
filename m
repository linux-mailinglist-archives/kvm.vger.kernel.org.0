Return-Path: <kvm+bounces-26114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFD9971A4E
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54602285F96
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5D9F1B81DC;
	Mon,  9 Sep 2024 13:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="psj1oniw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5869E1B790E
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725887084; cv=fail; b=WnQtuMfYH/UxvJE4dewj0NVfljwHCDPA4sixfEPlkoxBx5vnsW7QUWqGSPcJPXkrb8uhW78HJ6WOak7h/EMOcZrcgR05XW+CH85Mr1s79+jpcPUlVDArBcKn84A7Z/3aW/SkD79/9nQUxGxIXt/PUD6s3BlZT0G54wki2fGwXLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725887084; c=relaxed/simple;
	bh=s3xlpHkxwrfmGG4SiIrDZykUWUJCely0xugg7yjrb7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IKktIyjskFZcNSsEU/g1v6HtMDRYJb1AioykIG6FbBIyd7ZoqBaNQAE2rMAa0yKAQQYD3SLF7V+Pv1cBAdaRav2xnF9AQ6rvGqTg/8IMIoBUfqgpg04ulk4WGsvuZSSrCfhHX4l8y21Jbjp0oPmtDISvcyGHYDXMWvofKD8Yvbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=psj1oniw; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gO6Yw5SZ9DTs/bOJ0AIPJTb02V1+jn1RlpbJgZ7yYTGgWXyK0C7FQ5lWTJDfKB/MuvXqLCL90s8l9UPL6f/0JYmRGbWZPE6F6z8sMjMkACkTYMzkXzOX4oiwDFfi6/nye2qXjQVD1Wv24jywD0rfo7i7nQTPaQqB/50A8bHS/zTSCPax1GgdLMj/E+177HCQrD4dREtFATT0iHvt2Mqd0XFlmLTLx69Lgn7xIWDlsWwT3aaemgAYyEz2NPqzORaeHCNyvch8XtSkDEG+P6H5AId0P1MPeEjY1bJXV3z9DEFbRZVu8+xC4tvtyQAoHw7kPOFEv6s2iVF/WgqaVxFKDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJ8g6h+0rn1wMhThdpsR9QS/p3H/vDl/2xfCPLsOmyo=;
 b=kYM4GYiIwVU8caT+/S2/rU00Ig2IFMxNPKCTo5m2QAFuu9Fy7ckl6LniU2CibTgS4tG+1KVA4LUG8f6TeRLkb3JHVS34ArDgNPo52jKcax/Oo+1TjN1/NOChOWh3RPhTklK6Jjf/S2WQ/14OxuLkJfPCNuNRnijyGfrLJ30M5YrAA1ZCeK5t2aIUsWZIJdey80dFFSbaOF0ETQjACoBhL279kiaWMEZCrtdkOkz0Y0aUEVznrw6UPLyH88OeCXIooOuuS+YoaL6cUONqheRuoBxtKivaFcqlybVzpMHlVzMCbbCbGjw11QBD5+ZcYGV7hZebq3cwjOIMv5isIfo3TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJ8g6h+0rn1wMhThdpsR9QS/p3H/vDl/2xfCPLsOmyo=;
 b=psj1oniwMdxegB9b5p5rIiSIuP2Bd5pTcgakiH2KYpFhYsb3r5SmET2+RxDTnn08w5WKr9yM+Hd5n6Vd4X6mjKOZWbgyjU9yqAR4dd933Z97yr5jOdroyEUnBn4IKPSc0qhWItcYPezLmdo/+rcsV4p2IcNMCaMH96mzFyxQF2B2sJIOw+IMiHCdc/CSWhiOOlzIB3d9jvNtNPNt9P9+PoZ8vTKH+OHJBXmuqjrgGW+yQhmDJNKpm+5DWc+/w24tFK31gDKzEgPwjwapdsgkJV4PsunQ6wiKjPDT0rcl1o73nu5uxNCRa+3qOxYAL8u2ciq86f6Nfxl7plcfe7EL/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB7130.namprd12.prod.outlook.com (2603:10b6:806:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Mon, 9 Sep
 2024 13:04:39 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 13:04:39 +0000
Date: Mon, 9 Sep 2024 10:04:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20240909130437.GB58321@nvidia.com>
References: <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com>
X-ClientProxiedBy: BL1PR13CA0313.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::18) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB7130:EE_
X-MS-Office365-Filtering-Correlation-Id: e72fa31b-b711-4650-ac6d-08dcd0cff62e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WrPKGWs2uM928/v1zv1mKObuEwF7Nv159hO4faUtdG8Q8EvoZxcU46Ds9Jzr?=
 =?us-ascii?Q?WBdgmzSdeTenBqwwLWvg8LH0pOwiMeDhK+RAoLNMFaYJJMud4C8iMQUoBVRk?=
 =?us-ascii?Q?YLVOfoynHSkQrtiB8h98Rv0j25Yhlxi6jYz05Iy6eVoQ5eCwbjzvN0EXnQn0?=
 =?us-ascii?Q?Rv6ktUkdPMKGAG2KVNDUy76Kt3OlUP9vXgesurieMxxMjCeo/mHXI6JddvEI?=
 =?us-ascii?Q?iuWLEhp8A/TvFgMilLIwTLvdaU7xjTU3GlIj9CIVkFa5HM+Nbyt/6E0r8gZD?=
 =?us-ascii?Q?AIaqX5g+imQq9FurDuXaypbNJJ/mhT5pd0chc+Irb0t9dVmhmL3ctGy3pTfr?=
 =?us-ascii?Q?tPZQJSo+hLkb4OCj53hkC2pCJYpk51LJ8MdkIdt0fyh59B3yIRF+DZS2XWtY?=
 =?us-ascii?Q?eHCkrhdEEckOnHvuNPDqd6oP4SlphjeaQ20yo6QNEVBonoVaYnp7rhXHqo63?=
 =?us-ascii?Q?sa7CrWWyFCL/hN6B0PxVxEl0cqKy4NNkRflFKkCZmwFzLuqXHWwpIZujN/U3?=
 =?us-ascii?Q?13DqMZbnqgMchaXNvK8GWIt0Zwh+PhSVNpoiZzDeW7Aq3BXRNKduWpWNIdwP?=
 =?us-ascii?Q?uz7ZIq6hmpH5I8txGVkKPLzvaokIs4KjmfcpothyViJ/8ADMhF9cFPN+g3Ht?=
 =?us-ascii?Q?WUDkwJ/5DgR3dzQNLiYnm2/y3CrvWLXnjeo0kgarEveBAtx4yKSXfciQ+hDP?=
 =?us-ascii?Q?rfKc7xOuNmujwGezCx+VNKjMXKyyfyr9CMnRXpK4EIAI42HUPfy4pNQ/STzC?=
 =?us-ascii?Q?Na6hjzU8Gsu6VNY8M0wjox+ZqpXTFQVwwvvHCKwozVEH5dbJzyi0pCvVQBWR?=
 =?us-ascii?Q?slJ0ZJsBZjn39M2H/5t6BZIFZuQffE01NItxW1cP+Q/ppKWy3zv0bZoEubxS?=
 =?us-ascii?Q?fWn7a3DDh94ziqrt1UhPQBjVF7Co3NEG5FwSVWoiNSJOq6PGliriLN8wkDEC?=
 =?us-ascii?Q?OLwSoyDWtfi+liTaOk3J8hSIOFdJmbY0wx6FqUUnYsaTCYtKhzmbA9rBCl4S?=
 =?us-ascii?Q?mI0SVmDbHWiuIC3t/0nLSv3x6gbGU72xPnYjuxUcrnd0yTHSRvbOhVoYMLgp?=
 =?us-ascii?Q?X5fo11jwkyo1HXuKJPn0QPAeElH/ySzl0JNIEwhsCMOiBkM6ZZiFEjk2Jxkf?=
 =?us-ascii?Q?JaxM1uuQdTHNYZ/wWAqVJ47ohrNB8z92huUsWU1Gh/Nafwd0Xu6Hbm8juCz0?=
 =?us-ascii?Q?ff+7sK1+rVsQHzjU0idQ2VaFzRrOHED2nHk/VYF8S84zAle9ntVR9EZ5KAJA?=
 =?us-ascii?Q?zXMiUdgvm2DfCURQ/mRXHLpjqoIke+/qlRIYpzGBOdRy+C9IVOFDEm/NfxYf?=
 =?us-ascii?Q?VH3iuLlhayo+saWFwail9eeD9mIZJ5K1Ivfcc8R7csa0pA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aMkk/fbJO7CrYKT0NG4TpQ/xBqhlgWVaOQ+wcu/uKU2d2b2+eJsIZvmPW0Yy?=
 =?us-ascii?Q?u94dPo41elx58cKD09MEfHmvQnpE+3LyzaKozneB41S9zOn7fIollwLO3h++?=
 =?us-ascii?Q?Lwo1pNnLGA0E+UufPV65fTHSP8s/ulHHKshGveH579X3DITsLr6qEpbXfR7W?=
 =?us-ascii?Q?7WK8seM5j234nguhIIlUVlKFfokmRn9w+m8vFflgzOYBBQIfrjHG0ot2ZrcY?=
 =?us-ascii?Q?DWQ+3cOgltLu4Ddq4bvyBar39qFahbCmp8HHXbzSUzffsK8Kg/akZDOr5RM0?=
 =?us-ascii?Q?0+qGcnIjA/UM5QxGk48JZavZ7Ue8O/Iz6sy5ssFkip1lUC3VY3QoUasdNhg/?=
 =?us-ascii?Q?OmDfrMLYVvWvOaX4mHUmRoAi+bmhqI9x7ALj3+pVh/snhBxUFbiV9/aIlzmt?=
 =?us-ascii?Q?N0wcF5NhN69jS+l2bbkhNp0bR/e/zHOKw7rVG4j97VOgegoYwJBSLq0ndktN?=
 =?us-ascii?Q?tcZe/UX7yby6tPgu24ZTQy6efFvZOj7Xwat0lZNAa2NuTp20y7bxXCN/qbk8?=
 =?us-ascii?Q?RSHXyjb8l/Oki3fUFbTEMr37oWocHVI9VVvxpEZCvAiLHJkSx2oJ/HyhbGes?=
 =?us-ascii?Q?jWcLg+j+56kU9OQxetGqkfnT56yjIZLYiNrrcdyj+8O3z3F0Fy8jqA+bhzjl?=
 =?us-ascii?Q?wZMsZHdkBOwf7gKDqnqSlbL7FM7MPgP7SV59Uqshx9YLMph3gr0zvDkhE4/d?=
 =?us-ascii?Q?lUP7eWN0W8fH8uuZRzcSxsvi384iyVyQSL7lI+AJnArXxPZkjwvS6ttoyTJK?=
 =?us-ascii?Q?pMFzVhKV9fKfsWfhhnjvtgVA9IlDei6pFS1tzp7QEnvZg/xr8p4dd6WndW0p?=
 =?us-ascii?Q?+sDixDKOvLaByyMrzzDVFNd64/JCTyCA4nr4t/kWskXK3+WPgYjwLUnOPAM6?=
 =?us-ascii?Q?QHTUpoukWiHx8lSe7E6+R3+UiX4/0h4chr8ljhqEy/qHeugD1s+bTLHtTFi6?=
 =?us-ascii?Q?MkSeFRHxS59CbrJnkf42Mq8Wc2vUH4n/7s1xzaqjs2E9bgprGAk+n8SqhLS6?=
 =?us-ascii?Q?p8DdAtmJ41mbwdsQLVbiuzNTFi1E6YvE10izOE5Uxt9IG8TFbA491njEaK6P?=
 =?us-ascii?Q?EUSxkK5GNi32nI1sqo3wBoTp9T+qcZTV5FsMmHWni0NLLTwrs01avViXDrUC?=
 =?us-ascii?Q?rUd/5E1XMLHAwvAYLT1semt5UT9yZe/dwt7U7BzGn3Lt3kTKTzumtWO4kfFn?=
 =?us-ascii?Q?AmKGEz33N/NxW3rCYDiVkX3UYcBazLper5v30nlu2QBN/t5FSYFiA/IBvfDC?=
 =?us-ascii?Q?POIcbqW6rNCwVTCg+SPabQK2rAbKSbi7JTCvkaeX0BYzf/FXYjvcEmuDaLwU?=
 =?us-ascii?Q?RxOx6yNIDHrlRB6PFyPPEUVZCYtBhsZop7hHPAndW9MSh0SpqylGvkcxW+Ne?=
 =?us-ascii?Q?Zy+Uq93qQ/Bkbc5PGCw/OlK2aNf/tbOa175JcMO+lLyFs36by379pqeMrdsx?=
 =?us-ascii?Q?09EIPI6UBDqS6K2AEpGZ9kI/YQ0rF+ON3l8MvpTQY8386Pyp7Xq1RoaddCm6?=
 =?us-ascii?Q?eSOFBU0Bvgc0nrhA9uY1/2L4dig2P9t9GwrTdgCGmh5ozJ1NCMmPL27xz5h3?=
 =?us-ascii?Q?A2uaKMiLkhj3Cz2jPVY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72fa31b-b711-4650-ac6d-08dcd0cff62e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 13:04:38.9229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOUSEbAYaepbC0tgja0HY+vtThgT0pMJGgYjfMKdRfBFCmPuKVhtB1QWMo5Fhbe/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7130

On Mon, Sep 09, 2024 at 08:59:32PM +0800, Yi Liu wrote:

> In order to synthesize the vPASID cap, the VMM should get to know the
> capabilities like Privilege mode, Execute permission from the physical
> device's config space. We have two choices as well. vfio or iommufd.
> 
> It appears to be better reporting the capabilities via vfio uapi (e.g.
> VFIO_DEVICE_FEATURE). If we want to go through iommufd, then we need to
> add a pair of data_uptr/data_size fields in the GET_HW_INFO to report the
> PASID capabilities to userspace. Please let me know your preference. :)

I don't think you'd need a new data_uptr, that doesn't quite make
sense

What struct data do you imagine needing?

Jason

