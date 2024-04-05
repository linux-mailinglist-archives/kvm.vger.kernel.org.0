Return-Path: <kvm+bounces-13748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE1AD89A402
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 20:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46198B21A4E
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 18:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC541171E64;
	Fri,  5 Apr 2024 18:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KRzxh5Mu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2103.outbound.protection.outlook.com [40.107.243.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B3C171E54
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712341085; cv=fail; b=GS9gaCq6w+vHatKba8ciwCR5JlBgfkcKrDp0wQm1Iqs3RV3W6PRBjmgij/BJwtMzXpdQw+UCtcFl4d/ktW/C0lmqC4wwEKnSAiGJqYDS79+a/svT6aeMvxDkePOE+z/iq6zVFbZTuFPagXYiTN0dcXmebGRy4xjBY3ZZFRRZ3JI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712341085; c=relaxed/simple;
	bh=AktZo+p+Izp4YxNpkfjlRgw/RekL4XJXvwdt+rlyRLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N/n0kpkZQFZvk0DnQNd/vuirDPH0yfD/gJOyx8lcSTcBOtSlNW1MtYe0A3adar3h40vy3DUoSMIvF+j5uCsx+qNiMaYw2C2hT+MKh+oWp3ty21YCYM5IcKoefsZgpq5wZtkia0IWocow+zwnQNjmmiFzNUaOpcJCkxSlPTqhC6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KRzxh5Mu; arc=fail smtp.client-ip=40.107.243.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlW1k3X669SkkLRoiD6r9ZuSQRmDu4A071yx0U4Z9xrl2cYML+rjxg9KyQWYhC1lF3G30WnFsmgbkNRtkpy4b0b4oaUTh3WfsCcZypKmkN1Y98Bvvr2/WlA+GAJLSvGCuTl4Szvvj3FO6aAbX6HbGbrflZNdvJ+j7xelDh+8qJfpsOQUa1ZkiMlYf0ACm3tNbbyPdqbY0mgIk3pp1Skw5/bBsBSWyR4ds9Wa6b8cD3xdR2/DLLv8VsU1J36++bc559obQuOyAGmjGSdfadCsXjemwYsEgOn4EUorfYwGVf9VNuGZj736yIrMuY1QUy9ffsxA6NHgdlVUZIWf1nMeTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ihn6yG5h32jMQ+iJ6FsgSfqqFl4iZZob958RXo6S04=;
 b=WcarITvyfEPOmmeRdsvvpbL/+mzevv0PpaA95JXummePkKmjTb9psTTdN7cWEdZtLbpISR0MdlnfW4yL0U+EMpSIT53BlZYxzC5xXJ+E0acUes/qOJLcC0LRVAdqoy7qduY9uQn6hMYlvtOeFxXVLxfJwEB3ung6+YpAaR0I+quneESKEDXShsqBbpCOYxUo4wzNtxo8X6lDzxxtHrzn7UbqEdkiQlWPXuI63PRoY+XSpjRcYVfwXfSEZyDyOafWe401ZmYk21w/OfSEB+Xo4sxV9LUwaMogLcgSC1kKMeCof/SpM6ZQt/s9R4JyvbxUqEXjndoHOyldnBhWv3qD8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ihn6yG5h32jMQ+iJ6FsgSfqqFl4iZZob958RXo6S04=;
 b=KRzxh5Muqrmy4/FNhx/9Vw4cJhxpqsdXnmlJp22owJzABG5EyFZ5SNyUe8Z8DpFtgprn3lvv1Xmwi561vn0vadMzL8b+kBanx/hPEec/uoMtdrzdum75opNatq/Kruapr0VTXWIyFzog1evJ/g1ViOaik+JGg1RU73Qp/s0zTbYQUJ4ij+HE4oz+xUWd5YfvAaN22RBlYnoKonURLYm3GflBMx7IkHQ6yopkdY54vJsD04Y71rwb4E/6pb7A2OmsouDIe3God2qc9Vqbygn28QyEojcKzyvekI4+CkquU68cAYOSj/VBX1yexWn6oYs2i7WUJhNVCyzIHfNUE1kk+Q==
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA3PR12MB7831.namprd12.prod.outlook.com (2603:10b6:806:311::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 5 Apr
 2024 18:18:01 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.042; Fri, 5 Apr 2024
 18:18:00 +0000
Date: Fri, 5 Apr 2024 15:17:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, joro@8bytes.org,
	kevin.tian@intel.com, alex.williamson@redhat.com,
	robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
	kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
	iommu@lists.linux.dev, zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 2/2] iommu: Pass domain to remove_dev_pasid() op
Message-ID: <20240405181759.GI5383@nvidia.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
 <20240328122958.83332-3-yi.l.liu@intel.com>
 <ffa58b7e-aada-4ff7-a645-f946e658785a@linux.intel.com>
 <735f81a8-a605-41c0-8252-15715e4d8884@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <735f81a8-a605-41c0-8252-15715e4d8884@intel.com>
X-ClientProxiedBy: BL1PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:208:256::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA3PR12MB7831:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U97wOas5MoG8Dwvskel5ojbsVV/iZnYMDE9HaHmNxv5bNxjsVsLsEPkkvkflkGjJ3ym5agOgNEiH7I2kXI0CJECQWJKIzGIzb4lxmhaWz5NUZ+CNww7Jz4eg3mg8DeaXXI5C9hQk4pbEIgf0blVT5k7bj2XaGDXP98VOgsXsKWyzBeTKIZZwB8JvO+HcR4tk4YHEGIVoIIaLIoof+1lqUxEt0ktkZPxqqso9bbC/KEock3XuCqD4Q4xPqLkpOSS6CHouwZDW2pjujxXdpaxF9gqvhXyawuOamMIQQxpNOtgx80BOOjMg9mq3g7ECAvckBQUuyoPdcXz/YEPYXAcO7a4pFQqzp2RHqLv7z66DX5JghF8mdgOZTrYoRS2I7tcsMku0hGPaZ/8xenUWtM6TzAioQmXZf6jQpw91rZOid6FaoxZ6Tmxb4qgGNfZ4giaJCASJpo4Dh60QO0MXTQYrz+i8tddP2vAVucCE+vnto3jlvNeiTuYmphdgJX8XBOFnOb6nlZcfGCNkLdWDRPdTe073knLHsHYXAYPiUtgnpZrEwcjaRM0V6qCil/djzI36exUp5OkDArzvyAMaIvHHYZtPHr5jtu3mSDQSRH2m/sntvUka41jgceJLXlICxL8W67xSrADaWC//5S/ppbsVf+BDNFIqmFBJJaDqg2OtJ9E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHVJZW12Mm1pcmVhZE0xTTFyL3paSENjMWxzUFZUTXFZTzJhMEFBeElFTXFZ?=
 =?utf-8?B?b1VXQTZRSHJtL013NzV3OG5IR3QzOUVjaDdWTlJpMDZZTk1aU0NkM1lXT0VE?=
 =?utf-8?B?QndEbHFkYnpIckM1RHVrMFgyQ05RaVB4aW4xZ214bk5TbG42NnBlUHloaGt3?=
 =?utf-8?B?SzAzQWJwMC9IaG5iMXZKUHBNTWlSWnhkbm83STlKb0dRN1RIT2kzdzhyOTI5?=
 =?utf-8?B?VHJ3VlN4ZjR6bkV4T04vNGdqa2ovUUl1TGg2c2p0WUo2NnlIeURBQkc3OGhC?=
 =?utf-8?B?dTJvcXBKWGdheWNzcjVqZHF3MUpmVUpnV1lxbllxWWJtdXBucm1hd3JtWGky?=
 =?utf-8?B?SVdNdElqbE56OHFKUThQRDloNS9pbHBHS3dGcXpBWEZKWXRId1dJdVR2YlY5?=
 =?utf-8?B?VUJwelljdlRudjFoUmFqNUJQeXZDQlROWWUva1BaT2tUY250RVlyTjNxdGFr?=
 =?utf-8?B?c2JzSWU0azROSDlzS2kwSC9Eb2w1QlFXSEJYa2s5a2M1czc5WXphLzZ6Y2sy?=
 =?utf-8?B?M0c5YnlMbUhNQXNuSnJFVmpPYTBJSktaNmxQRSs3YUwrS0J2WGs5RTJMRHRQ?=
 =?utf-8?B?dFduS2dlemYxQ1JTU3pBa0J6VEVGMHorZmcxaml3bmUyU3c2cFdXM2JvUnNU?=
 =?utf-8?B?MnVzSTBXQ2lmbHBPcHpNWnY5akNaUzNXVEdVWGNtOGs4c3NRZFdibmhJYVYx?=
 =?utf-8?B?dmt0V3grRm5ndTBFaHF0cUh3OXIvcVVVNW0yMGdQTlRQYXVFeWlYM1crcTdF?=
 =?utf-8?B?bHJGZFh1N1RPVXQ5c2l0ekl4WENGWjlYb0o1cHY5dWJwcFJQMC9vR0g1Nm9J?=
 =?utf-8?B?OTNuSndINHI0MVhrdjZjejNIUWJpUk9NVVliVVdOUU9XdHB6NXBDK2pTeHp6?=
 =?utf-8?B?Rm10UjlPM1lTMzhKb0JEcjJ0Zk5SRnhpSzdJNkdTbE1EUDE0ZlNBWU1xR2c2?=
 =?utf-8?B?Sk9saVVyUmdxUmE0bGRXeFhSM0k1a2ZXeEdRblBEZ1M1L3hPVUNEWWtrZHVs?=
 =?utf-8?B?c05HUU13UmtJOUlOb09UL0pPTjJmZmRWdmJxWlNJMFF0RVFYWkNJT3hreHVz?=
 =?utf-8?B?VkhMZ052Z0tMSkdzZ2UvZ0FqeG1tZUxZZ2V4cEFNR2hnWlpRM0srQWZRNTND?=
 =?utf-8?B?c3hRQkZ2SllacEV5RlNNVHdwM01xR0txWWpJUzhBUzFLZjgvQXNkTms5QkNX?=
 =?utf-8?B?U0ozdHBYM3Fmbk9oVko1NGMxcUx1UERlWElvemJ3R0FyNUcySHJqR25XT0ZG?=
 =?utf-8?B?VytQNGhKZVpTNFg1NW1mWHNKQi9salZGamZQSFo2VDJNZWFaaTkyMWwzYTNk?=
 =?utf-8?B?THpxK2pabmhaVnUvbEorYnlZZ2FuYWpqaFRhNjNzOVdiQmxtWldYYVBJL1pE?=
 =?utf-8?B?bXhvbUtoUGtSNFlaNTNmN3NEbVhSTVU0bm1Ld3RhZHdhM2kzSkhHNHQxdEds?=
 =?utf-8?B?UTdCNHpuWDY3YWlhd2hRUUs4dU9RUnJxa0E3eGRON1FXMDZkWlFPSFlyd1V5?=
 =?utf-8?B?Z3YyVHJlL05pSE12d1cwaHl0NFBZaWlvMEN0SDV4elZnblVWVUFyMzI2c1c4?=
 =?utf-8?B?UHBGQmFONkJyRFJkNE9GSjMxRGl4SFdUbG5RRnBUM2NDR3EyRjdNbE0vUjNn?=
 =?utf-8?B?NGF0VmlSRGtXWWlPM3hMdWpOU0VMVWJpRDZrbG5jMCtzNTlVTmhReGhkM2dn?=
 =?utf-8?B?d2VNV0x4QlJwdThuL0NPR0NsUzE0MXo3VEZNUUlNVDA5S3dZVXF4bWFtZ3hG?=
 =?utf-8?B?ZjlFcmhEUSs5VGI0aTQwU255ZjBIUnd0MWNUZDhOZU1SMDF1S1Axd2pxOXMr?=
 =?utf-8?B?ejEybndSdlhOVWM2SHQzcDNwK1RGNzVaa0tOMi8rYkorYmZXUzVJbmVadDlQ?=
 =?utf-8?B?NUhVOXNsZ0ZQRjY0OEsrNDE5MXhOKzNDeklET1l4eWVseGN6RGtsTEdNTWM4?=
 =?utf-8?B?RWFqdzVtQTErYndHajdOaEFtWUFDaU1nSkVEMEswQUdJenhMYXJUZ1lkVmFn?=
 =?utf-8?B?TVhJS0hqVGxBMGVMRWoxbytnbG56dEQ3NHJ0Zk0rZGtyMGxyUjEzTkxDZllv?=
 =?utf-8?B?RTVJQlRBZitmVERJNWNnNmdJNFoxSFp1aC9XaGpRb2MrN2VCZ1pvN2d1UDNO?=
 =?utf-8?Q?kA58tvGqDY874zXJLt0jV87HC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87015e9b-3f48-4cf9-a474-08dc559cba38
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2024 18:18:00.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3dm9jIV42KcijCCRVh/mN8s3LiCDJ1CEmDpjxpE4gKmWY4RoNHYBECCo1dUcfwnP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7831

On Wed, Apr 03, 2024 at 11:25:35AM +0800, Yi Liu wrote:
> On 2024/4/3 11:04, Baolu Lu wrote:
> > On 3/28/24 8:29 PM, Yi Liu wrote:
> > > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > > index 2e925b5eba53..40dd439307e8 100644
> > > --- a/include/linux/iommu.h
> > > +++ b/include/linux/iommu.h
> > > @@ -578,7 +578,8 @@ struct iommu_ops {
> > >                     struct iommu_page_response *msg);
> > >       int (*def_domain_type)(struct device *dev);
> > > -    void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
> > > +    void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid,
> > > +                 struct iommu_domain *domain);
> > 
> > Previously, this callback said "Hey, remove any domain associated with
> > this pasid".
> > 
> > Now this callback changes to "Hey, please remove *this* domain from the
> > pasid". What the driver should do if it doesn't match the previously
> > attached domain, or the pasid hasn't been attached to any domain?
> 
> I think the caller of this callback should know very well whether
> a pasid has been attached to this domain or not. So the problem
> you described should not happen at all. Otherwise, it is a bug in
> the iommu layer.
> 
> Actually, there is similar concern in the iommu_detach_device_pasid().
> The input domain may be different with what iommu layer tracks. If
> so there is a warn. This means the external callers of this API are
> buggy. While, I have more faith on iommu layer. :)

Yeah, the iommu layer should obtain the domain from the pasid xarray
and every driver today also obtains the domain from the pasid
xarray. It is not something different, it is just moving code around.

The core code should guarentee the invariant.

Jason

