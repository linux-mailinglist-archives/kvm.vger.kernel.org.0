Return-Path: <kvm+bounces-16997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FAA8BFD15
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35487B20FBC
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 12:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E91E81ABF;
	Wed,  8 May 2024 12:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ipr35MbN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5E3FB38
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715171163; cv=fail; b=TcQZYVDYmmVtsiNFEuXI1iN+KYSvdm2g639EWCuhTeO99fLeB4IqvRUAS5Q9lWdqgkhWmIhL7kPSFX6WZxgw4+0pRcsyy8hmZ+36+rw/XEbF942GikAIsZqOxCzimyZFxqlAxx8u76fhez/Xu/Hjy4pAGFB83d/xCI9f+nrgKLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715171163; c=relaxed/simple;
	bh=aFFRPdxutlh9M5Yoj8cQmhryi0a+k8GDXFDhrTYFXL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dW20bZgS0GH/DFlGULQE+d/5j2PbY0qm8UiOp/dMVD25yXxzVZQ8c5E3IYey8qGjr5x97pGHpU8UZq4hA0fnB0yE21CiV4liWd18TcEwHwVjamYafTwdfJOVGX1wY338eGNtuzrLsFHTNqqMzUnfpWZmFIEVu5GcdcW7U0JwUFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ipr35MbN; arc=fail smtp.client-ip=40.107.96.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PosogptFVMbj5zVC7rD2bEsDvAks0vuZmy8kAt1H1pcLaNAgdWx17SH2kZZjPH0CSjpfqEzMmUHM4gGpYlq0eW9LX86Ti0A957ailMPMWEIsktdUl2Wlic1o9jcB6vonmBJ7qVY/feOdAKpKrHnTEb/olau8oEVAhGdXBpAQnwUFospeS2dr3OvqusqJEi/tkqLad3YvQqMez+YaecfFoC3Y+7hzEuxXCDN/JiUXMJzeJ3MweSDERx4y/WQOoudsNGQaAu9RoDxaW3bJWUn9AcUryiMIPAu3F25O/q8R2EhMlAUL/iC2nB4Rr4cLdNBoPRcwIuh9U48rqBv6gHiaYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBrAQq2YhGdeSx3ntUbXvuBkfxoIZzLkzEzUdcQ8pb0=;
 b=l44pwTjWN+iqlUVCSNWLEQgvFu5M0SKUhybAhZhoNec06+whcR0MH/k7SXjK43as51UkuK8jvie7wRZq/0FhYDe+YzQgUHw8csI/5BCSdNHHa86a7sOke2Clc2RrIHctZgYmHmSNOsjqZOcmpG6ZRWr1Jkni+MQoCAc2UMvntd6vMPR34leY+/CytZ78K0zbdM/lcJ0FjCtsaLe6B5fCvJyZvt5lyx1L138+ZGRTvCaaw4ySxc+8DN3DPR6KVc2qV5rmlZplkDdM7GcfuS52EA9T/lBqRTSpTSDIR/YsNNNKhY+s8L7tz/3GanjPs2YQTe4eSUXjMVQ2qF96lNLR3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBrAQq2YhGdeSx3ntUbXvuBkfxoIZzLkzEzUdcQ8pb0=;
 b=ipr35MbNJncq/4cEQVNcpCTL/x2dU773X1NHfxsPjJ8cWwBQX3wtlKmZKL+rpDZ3bjXOnz2SJ2n8bm35XUEJJE3UBPC2I4ngCSt2sGvNBCKPamWonLlXfhUwdSAGOu0JlTQeV4HDZ5vWjUKTZYoXNgORRfKt6VNEb35Xe1Fia9uAOXls34NGZZFDFLyQxbDx6ECESg/bwWN8L9LCF/APeHK4uV8sg2nVkrFDg6IeVbTTZn1tvMbds+RnWBd1mt4kc62fpHwPma1rSAoQ3QWAq5LXoaQkmY9L/0/HcEIiUMIPcdICNcdu1mvEhW7akz8xDCGuVmFazg9DGakH2Cp44Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Wed, 8 May
 2024 12:25:58 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 12:25:58 +0000
Date: Wed, 8 May 2024 09:25:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 12/12] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
Message-ID: <20240508122556.GF4650@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
 <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
 <20240506133635.GJ3341011@nvidia.com>
 <14a7b83e-0e5b-4518-a5d5-5f4d48aa6f2b@intel.com>
 <20240507151847.GQ3341011@nvidia.com>
 <07e0547d-1ece-4848-8e59-393013b75da8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07e0547d-1ece-4848-8e59-393013b75da8@intel.com>
X-ClientProxiedBy: BL1PR13CA0376.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: eeada624-36e6-4ecf-3bf4-08dc6f5a03c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GL0YMtt4ajNcw+0Dc1Rjt34vcABVLpOb0lczgUi7vw9L5rOLeHUgIbBeBkvI?=
 =?us-ascii?Q?Y7PAA6g6YThZloezsHsHFEAXthVzywGHYYzHQKA4rX14EWJ1s+r+O6Tu5Shx?=
 =?us-ascii?Q?ugEUE4qRywJX1F5eSoApbPpPjunMkmFWB7KluKbqS5kbkApK7D9RRLp0vRN5?=
 =?us-ascii?Q?6BovRrYEWKkFToMa9/fqQh6zLIsPTFY2wS3QzalAM4zGl/V6AKYXeoHdjUUv?=
 =?us-ascii?Q?t3s3w4e2TL4QC4CH0teXkE/D6sHDMJZSpcmgb/W9OZMv5p6IflrsiY2IcwWE?=
 =?us-ascii?Q?PGm8SfZql/Md6A9k++zNk7aLmpOlc2iXd+0GtZGRhZrgNIQVDb0EUVMNHI3r?=
 =?us-ascii?Q?WNksiZMxU06Lz5YvPUWEKt63KcTGCcdqALtbSP6zQ5rRUy9xR7RXcvgreWyR?=
 =?us-ascii?Q?YjMzszKiYN8sJ/FsAnSt3x/G14Um6Z53nvI6duPegup6q5DAVyGpHbp3Aka0?=
 =?us-ascii?Q?NI7eLRpXMsS23oBkAvDRamtWUKqPZcVFmHSERL1hI1EAylyM2hVQ9oTiK8LN?=
 =?us-ascii?Q?z2jblMXs4U0UdNLnn9qYOAlEqABYftNG/u/wUqx8DIPGgeVlYP1Be4HC7bAM?=
 =?us-ascii?Q?ZPF8yl5s14pWdbUZzXyCeDmH+NP64dyV0glNAwD8CBbt/svx1m8XZfC8iTSM?=
 =?us-ascii?Q?BvHTgNRJaUFYET016XD0Damp9mOXNqM574RLBg3Gv6kztOJ3x4uN5uGiYRFH?=
 =?us-ascii?Q?1shZa42CeW0qLfx8s8F4r8QXzHkb4B3jYAzvTA0U2QIwO9vURJh5rzPP/6YJ?=
 =?us-ascii?Q?3IjZGd24SSdfN1HnRtHDqBn8Bv4IruImBePa2PKcIMJznNerM/eRHiHX3BZ3?=
 =?us-ascii?Q?PPMgpub1sb/tAuNkjx52PH9zXBBJqXUOcPPs58C1+Ks4sPs5WIS77NhXG/6x?=
 =?us-ascii?Q?exbTp2klVOmDPA4YuUT/FuRnzVAxHKkGIpyzzNota8wrj5brRBCPeNBOKVqd?=
 =?us-ascii?Q?+x7aAX2lmU+sNBIn8UKttvtJqr3IcNGa0CjpBgA5TyP0DJ7B/KUx9QvBEtHn?=
 =?us-ascii?Q?ziwW1sHPCNnWR9rJgmFdZDRjn3A3B0+JtS9JLdHG1/EIdyl84rieYVYx9FNY?=
 =?us-ascii?Q?RB0qMFJAfKWdXjJJN2O4EmHzHLyhafZNXn3BtP89q9+aRlCQ5YuRVJaVEaTb?=
 =?us-ascii?Q?vAwc4lLhwwDFc2coK9ztW+xi4Kz2BingczV9iXnZPH2Fvi9383Q8jnl8gfXZ?=
 =?us-ascii?Q?YuaFDafz9Hz++3q38sQd+Ys3ZZ9CJGs95ma+jWdpOuwg/NhCHSYyrYb2Uuyy?=
 =?us-ascii?Q?BzfMHsANkeUs+oOflxVCt9IdoKHRDQfsbXdcXFHeYQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VsyqScP7qaaqLr/J4AA2rQEQa+Vh+/HZUVWuyW7Nbo7FWUam165kyq1Zw5vm?=
 =?us-ascii?Q?MvaSf9CNoI4IzvUkQ5j6lxrBVRHV1YMfoz+B//lZ8LUJK+eFcE1yABW0a0VJ?=
 =?us-ascii?Q?jxvsRAmfm5VbrZYiwTWqYqO8EYCkZCTtN3CpJ6tW2MX2pMUqrZx1cYMaFqqc?=
 =?us-ascii?Q?J0DtNZ7/waPNMfqG4FB6VnUsm56qs8N2aJBEj/PiV5kKsW+H1PKiBDDBJIeZ?=
 =?us-ascii?Q?KXKGqle9LdinBHsCBo/FfaaGWqSHrdf0nSfgE18BCLsJV0v6hctuCfZUiyQI?=
 =?us-ascii?Q?Wd4+rF6sVBY7Dnh8joV407EZLo7oE6YU/0NSxAf9q8waty4H6XNUZOI+9m9l?=
 =?us-ascii?Q?kQU5HFjAt4sq9iBbnjWBSzaG2yDQ1WWAXpBa9EYHjR5nWrTJKtBQ4G+rzZsv?=
 =?us-ascii?Q?/LnM1Crb3z3BmR8ji8nHz5+Ine+DxqRSRhsUop4PpqeNNSlpb3Nzx4MW/dSL?=
 =?us-ascii?Q?vCLvIg8E2/6ik7pd2GYn3SaaBOUu3aqgNXBLxh5GMGv/Myxi5rTF4SS64j0v?=
 =?us-ascii?Q?vgBbVEdqUQO3ibJE8QJswnrlQGtB7wGvDYe8VPrjRZ9uUl9do9r6u5Auyg8W?=
 =?us-ascii?Q?NDpgtD5sAlZchKFZczJ519J8DUkwtSpPnlecnAVymLxSzU3G2FJXadrA6lCw?=
 =?us-ascii?Q?1l3tAXbDPguMzxgJ4CplGAwAU1wqIU1Ij4sTYrIjvEZcNtdPjkJlmIOWJe8y?=
 =?us-ascii?Q?CzgRQEjkH2yCykUfKtjDbrdOu5Xin8RX2oc3QUEDsZgcEilFZqwovhn/H05I?=
 =?us-ascii?Q?zwQlLwbHsnGnaVlo2r++1jm6NdVOuugZp3otHbwO0qPwkeNA5dKShGvipC7s?=
 =?us-ascii?Q?3xsyoCH5vhyJiIGhS283FKmbvnsjygTgU5xSBpW0RQ0jREptaWlYKu2739vS?=
 =?us-ascii?Q?hDhUDdK2K2ESkWk/Zr5rrMJJf0ArFXxyy2NNknPXIi5ZLivJejaPasi3Bzre?=
 =?us-ascii?Q?yb+Y2siWf/Vj3p/ntfzACFwB6UPQLMLvjQ0UKB/wdInZ5z05CN4MBfp1JZNE?=
 =?us-ascii?Q?uqt96r7ufWwj/QVC0TjwgkAQb8i98BrcuEK7yCy5D3T8/cAoVASA3E48W/L7?=
 =?us-ascii?Q?DjPMe8FU6jVCp3NKTnnCgDjNkUARbHh6z292SqAf5znXxT07R99zbC09DBwu?=
 =?us-ascii?Q?lnsN6rz9yAPYag34wIt+Q7fSN7VAQP1M7H5Zo/CWxl1JLyr4cPF97W+gSR7T?=
 =?us-ascii?Q?iotvDvM02utWjEaY4i1PQu51cExXNZ2Sp7gldU5Xi7m/X33nN0gFL56hl8it?=
 =?us-ascii?Q?RGrO5SMh7MCnS0xCM7gq+Uv8SmI16pIcs1YWZQxOhmmeVy2ZZ+mPib6R5mYm?=
 =?us-ascii?Q?r5hepg24twU7cktRTCgwX/T/3V639N9cUu3qBqq0OLIgpD7YDd1r09UBR4KO?=
 =?us-ascii?Q?C89HmRpyXEFoq1Si1McSJUzbv8i1pcuiXsrw7IdEdZQm/UUNVxEm5sGfcWJA?=
 =?us-ascii?Q?82JyjCGA9NWzaAjyrQyw9Lmd/Si77SuKtwtDj7e6O1d260ONJ51nz3IL7nYf?=
 =?us-ascii?Q?1x2tbh2EyLnDOu+AtJssHH1pqOpxzyJrO34bO9H2dD/Aj6lGVNZdAYokdl2v?=
 =?us-ascii?Q?3oK4mHhBgMIRJpKIhQr+u3KwWy47YhzlTtt4gKSf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeada624-36e6-4ecf-3bf4-08dc6f5a03c6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 12:25:58.2724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nIzG+6vEyCTYKNcWejQgq+lqrhxPUwA0TxIKOrLcWpiZutGsRSmgrVMq6nzuT6Uo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688

On Wed, May 08, 2024 at 02:10:05PM +0800, Yi Liu wrote:
> On 2024/5/7 23:18, Jason Gunthorpe wrote:
> > On Tue, May 07, 2024 at 10:28:34AM +0800, Yi Liu wrote:
> > > > > We still need something to do before we can safely remove this check.
> > > > > All the domain allocation interfaces should eventually have the device
> > > > > pointer as the input, and all domain attributions could be initialized
> > > > > during domain allocation. In the attach paths, it should return -EINVAL
> > > > > directly if the domain is not compatible with the iommu for the device.
> > > > 
> > > > Yes, and this is already true for PASID.
> > > 
> > > I'm not quite get why it is already true for PASID. I think Baolu's remark
> > > is general to domains attached to either RID or PASID.
> > > 
> > > > I feel we could reasonably insist that domanis used with PASID are
> > > > allocated with a non-NULL dev.
> > > 
> > > Any special reason for this disclaim?
> > 
> > If it makes the driver easier, why not?
> 
> yep.
> 
> > PASID is special since PASID is barely used, we could insist that
> > new PASID users also use the new domian_alloc API.
> 
> Ok. I have one doubt on how to make it in iommufd core. Shall the iommufd
> core call ops->domain_alloc_paging() directly or still call
> ops->domain_alloc_user() while ops->domain_alloc_user() flows into the
> paging domain allocation with non-null dev?

I mostly figured we'd need a new iommu_domain_alloc_dev() sort of
thing? VFIO should be changed over too.

Jason

