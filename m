Return-Path: <kvm+bounces-24390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A58DB954AB4
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 15:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7AF8B21264
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 13:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E84E1B86D4;
	Fri, 16 Aug 2024 13:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HWWxWMJu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092C41E4AF
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 13:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723813395; cv=fail; b=BP8hcwOUTWiRYWmhwxtoLvYapCpnX2rYaUeh3Ci9dZXxefdSER9/+elwKiHLWjwSXCh1u3T1sKquI8w8h6yJ8yYpw0g44sgI3OXOAnugX5nCJAbHhwg6hiRFyD7gSQBYiRf7nAyrEfzJHOu85gSHV+cwMm/HADBOmb9XesJ9l3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723813395; c=relaxed/simple;
	bh=MYSv9mUXpu5+S1K5jG2bvoWmr/QWTPgthd2+RQAhyU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KNaX9rPivPUHWl0XVRF1RoepD0fjvZzlyK/eqe9ruwcDbXvoj6wBUfBMOVlxsh4m6jqpsarnI/yFahcGtFzxQ9i3WWv+QRlLdsP2SQaWztMqnc8P8GsHNQdkQMhflS+JMDS5bpTeejIiLXdlJcIogOoPdCf2TS1Sv4/4ICSIlNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HWWxWMJu; arc=fail smtp.client-ip=40.107.236.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pVe4M+rt7YogSzrkdlZna0j5dRiktNTtkYc5FtRHYoIPaMHvT+0s3CwRUEgNwTKgPr1LBCIREbqHE9I9QvoHGQjESZv+ECAsDS60qfAogJA63xZiqq0qCqXlV9tyjQn8kIoiJkvFdu4Jtbgm6QF/3iiN8IEJN2l4JEjLJrUorf+CE5spTFCekstWgmWPfw1aEZaG07ewRJKUH4KinoYD/2AKMbdOWtS9Ld+QPe59K/u/hxENOrWDmW6cBZtFD0DPZGop7WoGnQgGgHszzrHF/QVlhM4z6wPwxQ6Zf6Gr77Pa406Axo/2PdvbPPnG0MyoDcCH8VqnAnpFX8BLXEXc9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypUe6j9ihktcVz5o8BxE73otKdNAsvg251FpwIC4SG8=;
 b=cA564Oeu2zeEYScuRcOU4MzzG6MsnkU5N35+7iQ4aZAdKJi4sPJ1ofQVT/poRRRrGSq36IAot3Kwxda5ULnBr9alOib6H0Scp/dkrbqkHJixabIywmqJWeL+FRo+XvDVliIi0SljqOIAFgYM7Mkf2l3XUluaeq2NBkrVD+lwJ3azRGHUsh4Uu8/F071BEcUiPl1F48GxrMs657E1Cx4LZ3Jlyr/Lck7ddiuaDlGhOoC9v4Cu8vltdDizp7ah/aw1H9oPiaBRVrsSGf581286FzOnLv7QBSvZ9s6YvqXxVvoYdLNEITbaWPAE74w1EhV4ORPD8CO28jSrGOovmNVfjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypUe6j9ihktcVz5o8BxE73otKdNAsvg251FpwIC4SG8=;
 b=HWWxWMJuvPRH9hoxPqIc9cvtuy4Nm4dihbPsKImRTFDdqht7ovz/YqadmqIibCaVWuP2eHAy9MjDVjNOdooOGQdM0bSrpsf6p1MqSa7C0MwSTXIgi23K87H5xc9XFNC5SZ/AwSfB/RQsGIaAAjahzZUxDoUicKpKbmixT5pI33ddkCLLjipwnlbOnxQWdSGuGW0A560/ry+WFfvWXByyuypjg5FqDDAV6sTEJVfTGSFxjNBKlFEAOo/csGaB/5DoSy7SmdIrkYIfuahf3C9bRmXl+JE3iefwUwEGcrzrGFe3WnJ9/Xz38s5c3sK7c75v34X165siYpHHh/4+p+cN8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA1PR12MB6185.namprd12.prod.outlook.com (2603:10b6:208:3e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 13:03:09 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 13:03:09 +0000
Date: Fri, 16 Aug 2024 10:02:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] iommu: Introduce a replace API for device pasid
Message-ID: <20240816130202.GB2032816@nvidia.com>
References: <20240628090557.50898-1-yi.l.liu@intel.com>
 <20240628090557.50898-2-yi.l.liu@intel.com>
 <BN9PR11MB5276B4AF6321A083C3C2D2648CAC2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <1a825f1b-be9d-4de1-948a-be0cce3175be@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a825f1b-be9d-4de1-948a-be0cce3175be@intel.com>
X-ClientProxiedBy: BL0PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:207:3c::33) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA1PR12MB6185:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e57036c-4b8b-4ca2-85a8-08dcbdf3c6ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5p42IEizupuOa2SpxPhHSSdz7RqXz1EdlxahxmzJhF6j5j3s3Oikj2xn2znx?=
 =?us-ascii?Q?zXFxf+f+lNPAj+hGBIYjiKOWwE99Q/oFDizozi/N6Rfxv/+E3D4k6pvDZsn8?=
 =?us-ascii?Q?+BJ4NBcU1AMzyQTeoZfv8pOPiB+HJcCJ/K0DMaRVev/7FwfDVskT7OPWE960?=
 =?us-ascii?Q?EM0nMyGdISyeUJq7P5pRCYbKrfG9ZXak50OoaXfZi4l6Dw/0EWMYHCXbKSM9?=
 =?us-ascii?Q?4NfCQhvUb2wtaO/18dJ1EISdFw6B6GIGxto4R0QL1nFzKnG7n78Fbmfv0p1k?=
 =?us-ascii?Q?KxCwCfMBaFtLf62URpls276g6my0xFl6lIRQuNtmY2mCVtOXCelY3DEh3OlM?=
 =?us-ascii?Q?3o5aV716cn2Tvf8uzwFUgGmKHqH9mA8UvzRaEK6h7uoSFMBdoPqgCuOO7cbi?=
 =?us-ascii?Q?/XG9t+tCy+fn/O9SfbePeUuxOhkwoRlVWPJX/LvZEci+aga7RRehRWBwj1Q0?=
 =?us-ascii?Q?fE7GntUAkvDsS87l99H/glJcRIK/wbedTYRHeK9IblZimyJ3WKYiKKI6biz1?=
 =?us-ascii?Q?kxcRQYZksRDnSA8fg+qzTzMuiMgEqJ+gu8raWQXss15DfSSuFlUys4x7/1rM?=
 =?us-ascii?Q?XqOgE9pVBEt48T80xmBs8TAm6LxKtfSZNsm6tyZMIl9jYQ273qm78kfTzV6w?=
 =?us-ascii?Q?z4D/G/SYvgJ3qscLe2VYM/B5F72ATaiX4kgMiMuc8pp1gTvokf21rqML+op5?=
 =?us-ascii?Q?gYgcdRm+DMi3G/Nr/oWNpd6/A19vtiG1gsP8t2kG1udR8jI/BdxbDbG/pE1D?=
 =?us-ascii?Q?koC/4Wl0cUglzXJsbp5x8JYvBSlb8sqFVH1hjLhMps90NXuwQ+e3eG3dGt0U?=
 =?us-ascii?Q?a5voYj+ZkBUsq0tgzwBpGM/wBqLW318h2YWD+K05csi16o9d2cAkmziIfOqm?=
 =?us-ascii?Q?R3JP4x+QVwOE87xN6ltvuMmXbvrTKnFc0TEtQkduCV0+m9nOUgAdJokl/J9O?=
 =?us-ascii?Q?xMZJqXPaHNCJTk6QUCF+L0UlpyoNf45Zks/zH37Ykqjyh8F4SlNmVw5TeELv?=
 =?us-ascii?Q?VkfUY/wo6PFbqMX/PNlpScYz5RlhcILDH+dT7nMyDkt7HTSIBgVxItJM/K25?=
 =?us-ascii?Q?pkUv007uCNxRdnf1l/W4urmiC6WR4icW6QowV3TjBznFOmLtwlWhBLWLgRIP?=
 =?us-ascii?Q?q5iiOWjRywO7Kb5AWCKEr+bdHjorJinaPpb/8p/dqU2O97WLtZvm/QAZ0wEp?=
 =?us-ascii?Q?bdkPELyTz7oAGVrc+WXBmcG8R1HYgjSxcOih+Amw/jPeQxDZIyC3QbYnAKVA?=
 =?us-ascii?Q?343wJbr/ECjc2kthqgg9HVJj86nyHSVaCt6O6eUjus6Afpq6Y5tPMEOpwdaa?=
 =?us-ascii?Q?iLhaomcwZE+Rllzcyt6Za46S40ESamarJNSG/AgTFPneXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5wk3gq/scvhCfCvhAJJrohIHHQunCTPRgyuMi+2w1znd9pUj1lIq6qhWGfXj?=
 =?us-ascii?Q?u+tJkc9yJ4GSNcF0mE1QmtzkPboU79epuHUxeP31m1X6yrUzQytURmHo4SER?=
 =?us-ascii?Q?xFTTzx4oOwvfOiEQrsT5yCz1wuxdnxz7wb/s3fiajnjrMjahHfSlkBw0Zwgw?=
 =?us-ascii?Q?jXjtenjuIZr4+XZ+v350jZwDnAkCWvbbKyx6bMMGqB7rnhu4oDm8KBNKx9fI?=
 =?us-ascii?Q?8rsxtUt78BlcXPHEoxHcxF/CwmXNYk8uj8XXc6V5k6m41MwBD5zewE9KH+3u?=
 =?us-ascii?Q?q1MvmnOheI5v2IKGsinEj99dLrqwOgzkhg3PxalTno+lkQJSTl0kOXO1jo7w?=
 =?us-ascii?Q?Isl6ngwQUFV3Sl4PWGy4gKcxShkU4+mPXooEcZ/DEpmeC+c2rjQhs14UnXTR?=
 =?us-ascii?Q?ceJ8MKIVCbgxdedQ2eVGrLsRy6zssI0oY1SxGQXfoEXJsUUQ2/Cv98UHzuUP?=
 =?us-ascii?Q?19uVgUqgtVJON9USnxNJoRMLZMIzT+HIfB6scba7XrOf7ZEAQOF/7DMpprde?=
 =?us-ascii?Q?t0lEwLf82yk3y4MMYOanxl0N6eXmNF7BuOhCfnCCJ4eik+PHLn9z2e2aIHXq?=
 =?us-ascii?Q?EhoA/bIlae6/v/DHm3TaW2EVtGiJbTYf+oP+SThefZ8Mxp4t4xko/YeHcbay?=
 =?us-ascii?Q?D/bOLnqiHaNigjhJ7W16S6x0TKBNDNmHflGhfd5CPnq0VUwjqcIzBRII0tcA?=
 =?us-ascii?Q?JvQuK2qvk8c9LzEwL6R3dA8tUM8qW4cUQDQ5lq1kN339Y1iQ7jBBHYfS0btr?=
 =?us-ascii?Q?OB4aC+xl4BInBs+ZLm9gbix/3fGad0xiGnGgnaBn9QhkzANrjdjqATlNpwFD?=
 =?us-ascii?Q?qxSPyNILuhXj5FyR0L35+WckPlOFZBk5QEU/hZza79ij/P5kVXDnZ9lmJM+k?=
 =?us-ascii?Q?P0xfSUnldeGM8BslwKRtrnr+ukhhizDt2vQkIz/may++j1+5b3QyRhqxpXH8?=
 =?us-ascii?Q?6uBDUX/FAol+lDapYzO3va5togKZx/E7pxX2l9dc3SxcZfkk3GbAcs5sOwNV?=
 =?us-ascii?Q?plDttZYLaznI8IctkD3k05e/IhT8Gk4KuuCjywCipxyhoVZnj83C8J7fRbcq?=
 =?us-ascii?Q?EHxp/29Dpf/rOPQxX4sPnib1zLh/1L/U/6PGMqJG1uYvRAc0PWtePs1lASTE?=
 =?us-ascii?Q?sIsNK9lCCGegV0X81iATeBUbxL2X+NCmzgqLuKNjOT54enDZqliGxBsvYQdf?=
 =?us-ascii?Q?gqvXrGGG0Hjh5jvKwwtyT2zezgzCfCL+BHjqGSw7l/v0d1ipymBtXi/QBCl5?=
 =?us-ascii?Q?Ivtw63e0NNX6BeSO0KF+RTuY7gxFHLsDVlX/HVuNo58p5nzI32tBOq7OjtHT?=
 =?us-ascii?Q?7whgo6/4fKbCBKLA0oy8hPKdDHov7AszR1Kx3zZ8TApbZgpiwJIYAH1u2FNU?=
 =?us-ascii?Q?7qHcq762phfnOb49jYvQVNLl5q13GI1MGq4UVJPC1QsV1e9Bt2mcLIj4fg8E?=
 =?us-ascii?Q?XYwxTftlxMEN7+D1CJVNNX0F32yd6kHy3zQvW4TjBH0eZOKuQuXLf3fioFPv?=
 =?us-ascii?Q?aqstIvYlO2dzSxW7m56w1KdiWCml9P7IJ2rX+GSGKdUFB4sNYyhgZgHaP/E3?=
 =?us-ascii?Q?Lm39k7tEcOWTLtCSz4E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e57036c-4b8b-4ca2-85a8-08dcbdf3c6ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 13:03:08.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UmKbny+uhFtFMJ9hJjOHQQGfnUVWv06P2+kONL/2PSpeJEroKo/f+XwKWGOyDQm0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6185

On Fri, Aug 16, 2024 at 05:43:18PM +0800, Yi Liu wrote:
> On 2024/7/18 16:27, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Friday, June 28, 2024 5:06 PM
> > > 
> > > @@ -3289,7 +3290,20 @@ static int __iommu_set_group_pasid(struct
> > > iommu_domain *domain,
> > > 
> > >   		if (device == last_gdev)
> > >   			break;
> > > -		ops->remove_dev_pasid(device->dev, pasid, domain);
> > > +		/* If no old domain, undo the succeeded devices/pasid */
> > > +		if (!old) {
> > > +			ops->remove_dev_pasid(device->dev, pasid, domain);
> > > +			continue;
> > > +		}
> > > +
> > > +		/*
> > > +		 * Rollback the succeeded devices/pasid to the old domain.
> > > +		 * And it is a driver bug to fail attaching with a previously
> > > +		 * good domain.
> > > +		 */
> > > +		if (WARN_ON(old->ops->set_dev_pasid(old, device->dev,
> > > +						    pasid, domain)))
> > > +			ops->remove_dev_pasid(device->dev, pasid, domain);
> > 
> > I wonder whether @remove_dev_pasid() can be replaced by having
> > blocking_domain support @set_dev_pasid?
> 
> how about your thought, @Jason?

I think we talked about doing that once before, I forget why it was
not done. Maybe there was an issue?

But it seems worth trying.

I would like to see set_dev_pasid pass in the old domain first:

	int (*set_dev_pasid)(struct iommu_domain *new_domain,
                             struct iommu_domain *old_domain,
                             struct device *dev,
			     ioasid_t pasid);

Replace includes the old_domain as an argument and it is necessary
information..

A quick try on SMMUv3 seems reasonable:

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9bc50bded5af72..f512bfe5cd202c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2931,13 +2931,12 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
        return ret;
 }
 
-static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-                                     struct iommu_domain *domain)
+static void arm_smmu_blocking_set_dev_pasid(struct iommu_domain *new_domain,
+                                           struct iommu_domain *old_domain,
+                                           struct device *dev, ioasid_t pasid)
 {
        struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-       struct arm_smmu_domain *smmu_domain;
-
-       smmu_domain = to_smmu_domain(domain);
+       struct arm_smmu_domain *smmu_domain = to_smmu_domain(old_domain);
 
        mutex_lock(&arm_smmu_asid_lock);
        arm_smmu_clear_cd(master, pasid);
@@ -3039,6 +3038,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
        .attach_dev = arm_smmu_attach_dev_blocked,
+       .set_dev_pasid = arm_smmu_blocked_set_dev_pasid,
 };
 
 static struct iommu_domain arm_smmu_blocked_domain = {
@@ -3487,7 +3487,6 @@ static struct iommu_ops arm_smmu_ops = {
        .device_group           = arm_smmu_device_group,
        .of_xlate               = arm_smmu_of_xlate,
        .get_resv_regions       = arm_smmu_get_resv_regions,
-       .remove_dev_pasid       = arm_smmu_remove_dev_pasid,
        .dev_enable_feat        = arm_smmu_dev_enable_feature,
        .dev_disable_feat       = arm_smmu_dev_disable_feature,
        .page_response          = arm_smmu_page_response,

Jason

