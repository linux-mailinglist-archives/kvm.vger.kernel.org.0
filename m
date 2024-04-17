Return-Path: <kvm+bounces-14956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CA78A82FD
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:17:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C57641F22661
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F87613D51E;
	Wed, 17 Apr 2024 12:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mySDvbDR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2057.outbound.protection.outlook.com [40.107.96.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D50713C69C
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 12:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713356226; cv=fail; b=nq8C9w68rDcmE4R0fAcJjNTQYKOtvPX3GG79S5UC7nVMp/BNo1LdtNq5zUcL+an2cirSmqwCIkw1OZIpIEKYWAMU9MKVGNhWFgIPxvzwOnbz9m0eXmZxHBQEAXZED9wUt9JNs6xOtAZBUI3kcb+IFAoAP5/FPLR0EnKhGeohyG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713356226; c=relaxed/simple;
	bh=c+fQVmLZMhVh823bTNC1y5yVsHCS7NMYQJVYp95iJwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m1XfEt6RD0bEdgpVwN9742BVd+u/6E60g5A5THIkaEaBsD0eCfjhLBI6oj3JnK8hjpH6A4CPLckwwOzeen0vg7KJl7sRxG0qmse8QaTfpAqqc5jPP16Ie/sjHv9LXQ7DtvHmjMuAI2Y1bEHmMY10oPD/j76mAxUZb0VgAu90C7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mySDvbDR; arc=fail smtp.client-ip=40.107.96.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/AEgnVE7YWxCIsG9/jqeR55r0a+aXoBqMXE+Lc1gm2vrvkobz/P66m5JS32UoOSqgN5MAXgS2BxMVguGZaSFz0mTjY09yzjDP5ONBXAfySsPtK/deEaoC9Feq+HkuWsFskh78yhNuNkhARqtS3rnN7pEc6B+geThnXzUHGNP+W+YRd8Z+0k+80GVAxLxrPj8D8YRg09w3MDZLIGlB3+wMgBpXWbxGGm0FiSsstwNC+NmyKpLhV5SAWu9aTWOZJ1DRaFZJzq8/vnFG8zK7nVKC1B4Cvr8CppRs55CrTohUnaKrAJ+MJYG9R5RQtK+bSgtGfNbVCufBbtZtKX2w9fqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6F21tSEzhQgx/nMKNW36XGh6EnXgDwQ02Er9v1rd/c=;
 b=jPRHixbY/oNnaeMGa71zRt0y2iYWRbtcm1Qvc5FTQuZIHv2A9NkIhwZxog8HF1PYOsdkvwO4Xmbk+zJ4/cs/F8UYmBbEbXYcOVQi2wdnid7JRxK/FV81X3/vUc+rmeUfcnUT3puLsrGAX0Z1zWFHFGykrzzfZH9vwhQe4A3hhPz9lS/DaPVrUXgIhW52y4f7wFjLHmiMvlAmJuUxtqR4pwsg5lBOSo7bU5PuzIqNr1ZzAeKwOWlVZai8klmmwJdhxImfSpU/yRcMFKznbSQkBhpARWXuuAqlvvkGYYN0J5xdPAtkJGCb9n8P7TbIc9fTIr/cI2D0JuuiZss8UyzAZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6F21tSEzhQgx/nMKNW36XGh6EnXgDwQ02Er9v1rd/c=;
 b=mySDvbDRVzh8EZJ2GUoBY7groEM+ocDbR3Zbw4BfLMaWXPlcfwIWLc0vBkEIqnvLmQAgPbTptzSoHvBGgMYX4cOegvr3a/ctZaS3rNvDcGwYjneoQkzIJHwikKEayucup4qg2jETlZTKglvTKx+uwqLy2oHEpZ7LsY4oX4Yq+e3Bd2HG6paltUMow+JPlgV77MFN2IE5zzc6tRLiiTP3jytv1bFX+GeTkI2gB/w2TRCxzH+VHSl5AHBYjLYvSRIOaFNejc9YlJ4Sokey8CQrq7rCI7ckO4Nt71doG7YiaqLF4BZtObV0vcyJk9OC5y7iwkRmhmLKovtUgJplxwrj1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB6918.namprd12.prod.outlook.com (2603:10b6:806:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 12:17:01 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Wed, 17 Apr 2024
 12:17:01 +0000
Date: Wed, 17 Apr 2024 09:17:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 02/12] iommu: Introduce a replace API for device pasid
Message-ID: <20240417121700.GL3637727@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-3-yi.l.liu@intel.com>
 <BN9PR11MB52761DF58AE1C9AAD4C3A46E8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52761DF58AE1C9AAD4C3A46E8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: DS7PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:5:3af::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB6918:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f02629f-9852-42cf-67fb-08dc5ed8492c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CRpZwwMjdm6oUHgKCC6VQYdyQkQdvQGLdMe6XG8Htp/s3PTFa1UfYMh80CBEfsdQz1YmVs6tBU5XWjgvImfnPXrcoaYDQsVSeBAzy1NS72uUD9hm2YGg9ne9KxHyO2ivQ4sz2bcd85xotYvdZT8yw/dr7LUPIJZYOcwtG3u/gKSYPbooLyf5/h7ejvHifvQZG4pJiUVMezmJTBKu8qLOjQhQS8yRRLXZItC7/65uAX35fCiCmgje7JL2vpGGNH+KsCH0ThEWbBuovTJtnY1vyWGQF/xxEuXytlPOZEeu8gU6riM7v66rs2MLrB77lqEgTChWqIgHnPlCKXyl1jgc9w7jRycubklwOmKIrmABrDPTWquer0eNmeCAW+1AfU3midpZAcjFpJe/kd6+pL+qC5nHrjwF/MKVOp3YOmLNU2hue1Iwq18Yc5JjiykSdGJk4NA6WJp2XLkM6hv+4gDd9xc0IBRBnnhXyXjoGaiIqCfpcMIITQI45tMPko9RbZK95h+3xICFiPmL1Pd+f0kiS3rDciswvqkJ90i+g2gfXpYGM+GW55FSzSekMSayfdN1SQ4NN2Q5rqSbgaQx/5CRfwIbS+AU9V/dgVrhsunk06plNCqWCs1sX5gnADKkZ0fS+faKS0ciLU2Z+B149pgkcUqrqNTycEWT2SNfonS0iRI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s2qEb5cvedwKROTHl+gCpF9Rr6ggmpuTpoUk43ZoosY1TG+I7Vuj5qV6IsEm?=
 =?us-ascii?Q?OWlrDVxy9J1v84YWNyDV8sII2ULzLItMFcLmu733Iw01+dlnyHbLswCnofDy?=
 =?us-ascii?Q?DdNqsenXVuT2zK8egj3fS7rgDSaC9I1ruCmjQu+buVzPqevUaTktTS+C0PVo?=
 =?us-ascii?Q?OB16UhqSlQ0nCL+SKRKjDGLhKIBMtj/JPHDlV45DJ5EpLiiiix/pHvgFZN71?=
 =?us-ascii?Q?UyAMVQq9Q8J3DmseKDvALGNlgZcP1YY0khQGo+Eardyr6Y8Se7AcZrSiQCL3?=
 =?us-ascii?Q?zU8t7euzFlfAFzSJcdabiQuW+GBtBSSk66daZPf9gdmRMhzZwBO/zhdFyjAI?=
 =?us-ascii?Q?t2JEmTnkBBWIjY0pZ2SCFm5ioFa3nrqTI/jBjNB3swhlZYTsN97kO/6GbYY3?=
 =?us-ascii?Q?ECxr2jTkInhv12TBaizxSeNESFRpqaREwOe26TT1vePB2sj/CPWrjCZU43VI?=
 =?us-ascii?Q?ST5Lu0H2S/0aBBXc3qvq2U+/yNMyAiOeKJP9n9DmWbwPWsw5IcJ2storW+f1?=
 =?us-ascii?Q?W4zXeqEWfQaVc7AMbA08j0UvXzkhXgkm3ih7jJXnAZ/shFYoU7AEi5dgGARb?=
 =?us-ascii?Q?e5iMJReMbvl9AEjnqIcdxdbJbPkn+SeKiTHbzIpy7L93oqF+T6vuRs/l9vCK?=
 =?us-ascii?Q?1ncci2dJ+K3QrdNgYRrXbu8SzCVmZm5orK8nM0V2I+bdZEQwzGVNNHwVr9PU?=
 =?us-ascii?Q?FFyEGJmluknFrIByMCiQnPDWLkIl2evLip1lGIl0USghLj3EkxpuqNZ+zXDf?=
 =?us-ascii?Q?WaqOv7wL7jbkZ2MOwcHMa7HWcTU8ITheIs/RGNltv6EStkyW4QV+yBBU2bqr?=
 =?us-ascii?Q?1clEPt7/CSVJ9G41bdq3EkF1Gpaci30qOt3COjidF2fsMPbsoExdvlL0q/2R?=
 =?us-ascii?Q?nlVmNdlwTSqc3BQLiGJ9ZTssr3CHgHf77Kql2S+ZfKfD2AaGX4Z14NrgkD82?=
 =?us-ascii?Q?WU2gPZBH1C2s/uuPyG5q7mVVSYvo4U608iX/VPy5FIrv60oSjKqbkgleINU4?=
 =?us-ascii?Q?sbEIM690+IU0+WbZAyQRcDmqib/AVwOcaH5RILtf+HP+qOfbt20qrdi6qmor?=
 =?us-ascii?Q?w1OQsMThwLD27E0l1NHKm9VqwsIhRJx/W7V/Tfn34n1iSpe1glk3ux5Bqnmb?=
 =?us-ascii?Q?Kx1YEt2ecruhOTT5g+K+hy2BAuORi/Srw0Lh29s5hkDiITj0duYBVVqcq7Iu?=
 =?us-ascii?Q?4mWD9UR1LCql9rvRZDzSN8cmQptKI+5H23dQetNGPL7gGvimc77xRZBJG8gd?=
 =?us-ascii?Q?ZWMv7G+raSA10a2W+lDfYuvV2+fOx6dUfOTx4+oou8U42fiLvbBPRrmR0FPQ?=
 =?us-ascii?Q?6z61CH7QlWDRrCWF0dHO3H/8xQlXHQ5UBPaPu+Oi9xVkRHxREpqNIxcJ6ARs?=
 =?us-ascii?Q?/zBlyZZYzmLUiQbLnx6P4qi3Ti+/ZJEsS/evNa2VDQsNdhRUEnL5zCBJM145?=
 =?us-ascii?Q?Nzogc/IZwh4ucNDBzgiFtYbrtPkyJAZSO9ESyHb+3XpdZiP6KooVtjb/jF83?=
 =?us-ascii?Q?rAAQbMUWZWuj6vvLi2T8Z4F6He5uYV9o767pDu+MJQ447i77M5mW33HUeqKR?=
 =?us-ascii?Q?j117V1E2Jny29Zi3HoVpiWpyexO/N5O0p2jA1kuk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f02629f-9852-42cf-67fb-08dc5ed8492c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 12:17:01.5031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xf82qtEE1YNuky82G5i7EDTGAqDgz7hfLobqBuYpnq7fz0ENeDHe7Q1CBvSZF+vy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6918

On Wed, Apr 17, 2024 at 08:44:11AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Friday, April 12, 2024 4:15 PM
> >
> > @@ -3332,11 +3333,34 @@ static int __iommu_set_group_pasid(struct
> > iommu_domain *domain,
> >  err_revert:
> >  	last_gdev = device;
> >  	for_each_group_device(group, device) {
> > -		const struct iommu_ops *ops = dev_iommu_ops(device-
> > >dev);
> > +		/*
> > +		 * If no old domain, just undo all the devices/pasid that
> > +		 * have attached to the new domain.
> > +		 */
> > +		if (!old) {
> > +			const struct iommu_ops *ops =
> > +						dev_iommu_ops(device-
> > >dev);
> > +
> > +			if (device == last_gdev)
> > +				break;
> > +			ops = dev_iommu_ops(device->dev);
> 
> 'ops' is already assigned
> 
> > +			ops->remove_dev_pasid(device->dev, pasid, domain);
> > +			continue;
> > +		}
> > 
> > -		if (device == last_gdev)
> > +		/*
> > +		 * Rollback the devices/pasid that have attached to the new
> > +		 * domain. And it is a driver bug to fail attaching with a
> > +		 * previously good domain.
> > +		 */
> > +		if (device == last_gdev) {
> > +			WARN_ON(old->ops->set_dev_pasid(old, device-
> > >dev,
> > +							pasid, NULL));
> 
> do we have a clear definition that @set_dev_pasid callback should
> leave the device detached (as 'NULL' indicates) or we just don't 
> care the currently-attached domain at this point?

If set_dev_pasid fails I would expect to to have done nothing so the
failing device should be left in the old config and we should just not
call it at all.

The RID path is wonky here because so many drivers don't do that, so
we poke them again to hopefully get it right. I think for PASID we
should try to make the drivers work properly from the start. Failure
means no change.

I would summarize this in a comment..

Jason

