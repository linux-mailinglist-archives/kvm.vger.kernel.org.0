Return-Path: <kvm+bounces-17018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADA038BFFC6
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 16:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 623B5285D3F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AFD84D30;
	Wed,  8 May 2024 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k8TCiiGN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B285279
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715177523; cv=fail; b=kiapOtReRQn4DWEcUkfAAeteHNNdVQ34s8lzao/AQswCuZo+X4AG/2JaPMWw5ysy3a4mdn9xmVgO45c2cqDaDDyyTkbxmXQLWhpDlpG1mek53f0HM6S7tnWohm1U8NHtp0Ytd5krxXIgNIbm2iBNYYBGiupvWxAx8Q+L6r1V8Sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715177523; c=relaxed/simple;
	bh=5i9K1YWeGBLfZnJ5SbHSlElz3wDNOMHj0dlNvHqGvi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I3GvYa0BHLGWt6EDfnM57Ade6MT35/42QdsufcGBrfhwFSJ2TKF7ERP8/YrR7ZT9XYLSnsBjlSvcOJkjfvXMQgY/oFNUYifMa5qm9C413L5ZL7vlnBh7CDLZICSaFgDenl/nkuIXr1Gdninai0jaUPTfMtjsls6NwawJRYpp7uQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k8TCiiGN; arc=fail smtp.client-ip=40.107.95.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WILGgfb7hsoYvRnkdU87Ftii0HHVzvOgyC7iKRubi/qkHfnYbWoYSC/snB2cITimeLkhGsskhyE/MQdlcclGs+DgSkhMlP/17TNVTt2tYCJ/v6gNp+ghNfs/WlkzuTDBYVMF19ih+6FdGLtcSNg2QldtihiIyicD4c8NRja8wv6AG8g17wVuCMQKlRjwRhy6ejeJ+BrjNLgOFOW6GxuYmBVuU+YaY3bEvlDJBE/PJmswHZN1zwV1qRi43vnzCFmCBvQpM3gdmubJ+lYF0SNJL8fyedK/06Sg20k7M89tX/AU1gIlbIOzltwPy8fVCOdJI/gqmGX17BFm6YG9Ku0Avg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bG9npWUiJjbX1moo7jDhfAu+wG1zEg4Xw1pwtww3qVE=;
 b=JnF58xHN4NtK6WlvBqkSZZeXEy0PPy2emFwMT+5alNQpPh+kf+JIxO2K3ltkKmdJfR3QNoFPXXEK7Z0baxYUMzK/jVWG7wPCV/rkvQJbgFXtOuoGSfGM0PYT3LuhFf2cxsHGBtqII/syYhKNiDsEwetqhBPtw+UFZwcofmeiDaRmBiNpDTZKJYUByp+IfsaVlzdE21ZLdTuHea59KSOENX1r/QwoPx0obigcyZPp8s2wscoufHwbte8zcT8M7iPxdlHN40WMaESO9Z603TkIa/KNv1CfHYGlgV+W87MKgCsAOt9NgJpuEDDu/MOELwS+sDVvwHMDVatcMG1taKYd5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bG9npWUiJjbX1moo7jDhfAu+wG1zEg4Xw1pwtww3qVE=;
 b=k8TCiiGNiuGEy0DbaD7xB7YwBR/OKqfubSM26mnYU1pXumwcVAEopDDIipUsM0DnGnHFI3vOcid8UnblTsNCzXgyuL0UCfBG9Gl9+aWw6K/04qaI4bl/PB6uIXLNwLHPrr63Z/GPUr01KsHwlzKpMQFLbR8g7VLHuQT72lrf+HXqghIIcjCol0RyD60MQvox6pnMGEqJLeqrzwzltrgv559SEz6Evtx8JiLSYWM+n87gSX9gSs6zk8BPY93NYCoeChsravJgrvqmll+DPAuGM4SXcfqDizsfw/9xNIOOL43aqLVZm7+nFnEwbzNWNcEj5Lpe711VOV8oq/CPrjlzbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB6328.namprd12.prod.outlook.com (2603:10b6:8:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 14:11:58 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 14:11:58 +0000
Date: Wed, 8 May 2024 11:11:56 -0300
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
Message-ID: <20240508141156.GJ4650@nvidia.com>
References: <20240412081516.31168-13-yi.l.liu@intel.com>
 <BN9PR11MB5276E97AECE1A58D9714B0C38C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d466eb97-8c2b-4262-8213-b6a9987f59ea@intel.com>
 <b4fe7b7c-d988-4c71-a34c-6e3806327b27@linux.intel.com>
 <20240506133635.GJ3341011@nvidia.com>
 <14a7b83e-0e5b-4518-a5d5-5f4d48aa6f2b@intel.com>
 <20240507151847.GQ3341011@nvidia.com>
 <07e0547d-1ece-4848-8e59-393013b75da8@intel.com>
 <20240508122556.GF4650@nvidia.com>
 <5efdd36d-2759-4f71-92f6-4b639fc9dbc8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5efdd36d-2759-4f71-92f6-4b639fc9dbc8@intel.com>
X-ClientProxiedBy: MN2PR19CA0060.namprd19.prod.outlook.com
 (2603:10b6:208:19b::37) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB6328:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c3ee8e3-ba1d-46d1-8c89-08dc6f68d290
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4GOYURA6oAc8vBRnmqdABWouWyaoQOCAceLckl9ZGfNAz2xnEgSLIcDVMv+6?=
 =?us-ascii?Q?b4sJtxXEMu3O54yFG9utfEP9F5N4ijMYy8CFNUmPzuEa2f0PQ4/psQRdRk82?=
 =?us-ascii?Q?RaFWfTLO5bLG1u4lcA3FU6tkv3PxXviTHu1N/fAkkVGUUGFuPKWNOoBmfyQo?=
 =?us-ascii?Q?Gc4/UGj/fcqq22IFQHnRPjzKr9qpBgGAszGDw4GWFuS6xk17+0dUjk0xjqvP?=
 =?us-ascii?Q?BZ2BqiAzfpeEATCHubN//C9YPR7hz5dzHy/CV82NTSfHcPopluBEJhpdGAdh?=
 =?us-ascii?Q?7QLMiG2obR7IFEW3eDeJLoHI53WXBGSfnyoRzo49nqsBmWqdDPQHnGVQvOpH?=
 =?us-ascii?Q?oLvUeR8mvuRF6jT//i/aZVWowlxGE+Khlpqdchi6ZHeCCeBJc29ZiVThdpg2?=
 =?us-ascii?Q?aK78nCkPUS5qlrWQix1HJBRiOV6iPZvV/WqAeVqhUeZ7peInHfO5OZWHYi2e?=
 =?us-ascii?Q?4YZsz74mHXqH4FCH3U0wI3f3j+R+2mnI6J2Q7VqoLqNIAGZK4TMc8YE6cAvq?=
 =?us-ascii?Q?G0IIOmGsHnonSlS6fKEMlG1YvHp5kWLk6UdiaWnXudICMxcWibizg07mYrDU?=
 =?us-ascii?Q?WzQ1gc/IQ+p6CABBhTQbZpPwUEzR4huHNoSF2a8HChB2i0ZC5K+CuYDCmCR7?=
 =?us-ascii?Q?1Vi4y9pZ+Z4nN6z+hF/dv8XCrtzQHQ0cwthaSt3hodNgUszKGTYl/rOlR7S+?=
 =?us-ascii?Q?iT2vhE/KrJXZzyO+segbH8Ikm/StMVBGdRRVlOJk3RVk3AscZRqY4CdN6jB9?=
 =?us-ascii?Q?e0cNgQ4a6e7/eDV5nWJXt5k4iTEjgfmE6k8C9CAzXlHjJsjXiLeuPmXq5Sbu?=
 =?us-ascii?Q?cHBTqbJZgCpcFtAE4hNb8hIBGf6gw85WLlysrQrbCzP8hLxUIKl+sqDXFFc/?=
 =?us-ascii?Q?pPCxaE2KeGBSfDu8fx1d2devDOu7KOXEhrnVm/9yxUdqOWqwEVdxheJoRyLV?=
 =?us-ascii?Q?AabtPvIWuEdqUcO9fUyXE/Vapign0oWQJA8auGqSch1hU8dW2B0rOv/4z8Mn?=
 =?us-ascii?Q?Ax5IytO4LGrMTtp2OVqXjTl7eo68/IWAPZtS+FflGHKJCnf3OS5RWbRdwtzZ?=
 =?us-ascii?Q?x6QlY8EVlHS6GE0Q9+hql+1d9js+r/FxUExExDGA6Trs0nezFXauHwUKb+1c?=
 =?us-ascii?Q?IoJRKY6uFifhbd/nYk4vmB5dVuohEz4HCiuQzpM34gblZqmmnQ87q3Fv2JdU?=
 =?us-ascii?Q?Y+w0l9OvWm3AS95z6ej312TjOFroiY+0yEHjBgLRkJtJMtXxTJh/5nL3w16q?=
 =?us-ascii?Q?ppRy1MXFvI1W/Asxfpz5VVmXcxnWM9vCwaTILkVwtQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/sBv4n0x8DMFJdYcSDzclBz8L1jw1VgQvXZVdCR2pcG+xVNQSVRV56cd4N2I?=
 =?us-ascii?Q?mp9NYmsUea5HIML1g1sl5+jBraHgEqX4sqGL4u0nf8tEze3YGUnPmQxiFaP0?=
 =?us-ascii?Q?TL9ZDzZPutd0C8sRArUcHjkauh90qZGopuAUhL8aOWG0rW3JgIxs5PckaXcm?=
 =?us-ascii?Q?wufc0iiCyaIRziobvORKvtrkCKkNs+xIe5c63y2wEaDm2aotLzESTsYj1U6R?=
 =?us-ascii?Q?dBV5+/Lw3BYZqXL6fVKt0l15Vw3Z9xc560bP8TEO6azirUWe2jrRYK1KMuIs?=
 =?us-ascii?Q?dClGxFwAWyLInnh8IBxAAuSfdkBHg91o7WonC0hKZ3qvpxiLO4N+gJn9QnQg?=
 =?us-ascii?Q?rZXy4zvqI+KXHfihv4EcqSeZ7cgaZ4U9wQlWvYkZ2lik8vJtXLio/BNlW4ic?=
 =?us-ascii?Q?zGhYE42yeSIvBvjTxNJMyvLCbcW57sjlqHdEFxhrorC1y8YhmuFWtP37luSF?=
 =?us-ascii?Q?bvbocmzYXgvLzLNODTIamgjI5hiqoj8JkkrjxXrNmEwl+W4uCOgY43O4IKzX?=
 =?us-ascii?Q?RE4rxtfks9LpMxTuQLmz6VlORdOtfrHJpgJARfI1xY2tI6HDvUpG7SDepMSk?=
 =?us-ascii?Q?n9s9eQuH2sFeLv1088t/GpNt0alRzpnNwqJq4APdy5rxOY+sLoqDZeL5hkEa?=
 =?us-ascii?Q?tmjef29qJIIBXA/27Pfo63/GLq1W4lmb9EE+g029g3nMxrCXBHYJ+vd8KIXX?=
 =?us-ascii?Q?+mwCrt7XLZjiONHyZIDr60zBwyvbXZT1KkgHELg2T36LtxJK+mOgvYwB1Oxm?=
 =?us-ascii?Q?ehGLyxujWEq82rmXByjGv6OQGoontRQ/2qP/Yjd8GcoGbdx+tHNOekbM4OBZ?=
 =?us-ascii?Q?PNRlmiLCMKl2yx/ovBy8qhAlCDXhBqPZyItECBBj9WRgjyqGc6S+/pnvaVp4?=
 =?us-ascii?Q?DR1hicGu5Yso3VyZFMR8qScxy0I0acLLZtZGLoObMffemiPfC+/AFaX7q0CN?=
 =?us-ascii?Q?MEaKxk0xEe2reO2hjeiKyQocUMN52YEq+8eHD8S5y+9tqKu2z4ZPL1rs85go?=
 =?us-ascii?Q?lrUeioIEhXr0pZob+iVLkukSVvMYiNII/e4np5YGGU9qnXIZl4UckomkD+eg?=
 =?us-ascii?Q?8R3PToRh+CaKLcyextTCm1297FKC2xo61KHhPmzleFZHUYUycOAUvfuD8vmC?=
 =?us-ascii?Q?WnUgmYBaDDRb6ZuxTKWaoNsB1qoUeX8U+mKwf6VpF6mB2DvYmP1ekR6FsMCF?=
 =?us-ascii?Q?o+PQrNFX9eh4uSBMW5YgAUxwpsLm6d49drrSi7kk+lbk/yEkLGObObuJdO2y?=
 =?us-ascii?Q?Si6yp3avtMBoeE+lE76GW3VMAGY+4+JpfB9pZSAZJEN/n29k2MM/OuGtq4xF?=
 =?us-ascii?Q?DjBEKw1irkWJXxLS+WeeickVDJHA8NS6GKiS67K3EkRRBm6S0DDCQany+yFi?=
 =?us-ascii?Q?BMNsOCEwL6dOIkDDRUb4tSSMQ7bDFpKrQe1jQut9g32GbVDRha5J4mHxX34f?=
 =?us-ascii?Q?tPPal410IQGdP6R5xxMZX7Rud7olTSGGuaWd+H6gColbYE1tEL8JCJhSZ3kZ?=
 =?us-ascii?Q?hXzwBaBB1nlpBznXyEtN/v02xg24IEoeWlKKYnEqLmOxNYhOfPWJRl0taHI2?=
 =?us-ascii?Q?mEQB8bVd1MWmlvlju5u1Ppp0F1fTs4HCa+lBzP8g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3ee8e3-ba1d-46d1-8c89-08dc6f68d290
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 14:11:58.0850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmLFojZ/BIzo1h3JGjAZIl4T45swKHIMViO+3pvgUUBKmfYHAqJ4iAreW5rga1NL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6328

On Wed, May 08, 2024 at 09:26:47PM +0800, Yi Liu wrote:
> On 2024/5/8 20:25, Jason Gunthorpe wrote:
> > On Wed, May 08, 2024 at 02:10:05PM +0800, Yi Liu wrote:
> > > On 2024/5/7 23:18, Jason Gunthorpe wrote:
> > > > On Tue, May 07, 2024 at 10:28:34AM +0800, Yi Liu wrote:
> > > > > > > We still need something to do before we can safely remove this check.
> > > > > > > All the domain allocation interfaces should eventually have the device
> > > > > > > pointer as the input, and all domain attributions could be initialized
> > > > > > > during domain allocation. In the attach paths, it should return -EINVAL
> > > > > > > directly if the domain is not compatible with the iommu for the device.
> > > > > > 
> > > > > > Yes, and this is already true for PASID.
> > > > > 
> > > > > I'm not quite get why it is already true for PASID. I think Baolu's remark
> > > > > is general to domains attached to either RID or PASID.
> > > > > 
> > > > > > I feel we could reasonably insist that domanis used with PASID are
> > > > > > allocated with a non-NULL dev.
> > > > > 
> > > > > Any special reason for this disclaim?
> > > > 
> > > > If it makes the driver easier, why not?
> > > 
> > > yep.
> > > 
> > > > PASID is special since PASID is barely used, we could insist that
> > > > new PASID users also use the new domian_alloc API.
> > > 
> > > Ok. I have one doubt on how to make it in iommufd core. Shall the iommufd
> > > core call ops->domain_alloc_paging() directly or still call
> > > ops->domain_alloc_user() while ops->domain_alloc_user() flows into the
> > > paging domain allocation with non-null dev?
> > 
> > I mostly figured we'd need a new iommu_domain_alloc_dev() sort of
> > thing? VFIO should be changed over too.
> 
> Would this new iommu-domain_alloc_dev() have flags and user_data
> input?

No, it would be an in-kernel replacement for the existing API.

> As below code snippet, the existing iommufd core uses domain_alloc_user
> op to allocate the s2 domain (paging domain), and will fall back to
> iommu_domain_alloc() only if the domain_alloc_user op does not exist. The

Oh, right. Yeah we built it like that so that drivers would have
consistency that iommufd always uses the _user version if it exists.

> typical reason is to use domain_alloc_user op is to allocate a paging
> domain with NESTED_PARENT flag. I suppose the new iommu_domain_alloc_dev()
> shall allow allocating s2 domain with NESTED_PARENT as well. right?

No, it is just a simple replacement for iommu_domain_alloc() that does
exactly the same thing. We don't have any in-kernel use for anything
more fancy than a simple domain right now.

Jason

