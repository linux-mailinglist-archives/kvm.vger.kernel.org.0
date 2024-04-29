Return-Path: <kvm+bounces-16179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C78D8B5FDA
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 19:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F8DF1C22000
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0D28663A;
	Mon, 29 Apr 2024 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XpLMozBF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCD985C41
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410923; cv=fail; b=akHL/eCnZ2AaMo28uUlqPs4B7YRyZO7Q16TsdpRZ3a+aIxwSrHCROd8JQvDftyWvH6ktR8odhDMMhXkn4A1EJ/ZcqX/kHiJOy+Uz3NtwgOE47Pv1csjOrfmqNe8G17oa7mAUthVdyFgOPr1iLtTMCND33ufNm8lm4xyKFxr4AF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410923; c=relaxed/simple;
	bh=o689VdwwTeJSxxUOv/B3KZAmfBipDLcpJEde+4byNrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NyLRCzOAupth3qg9lzXUtGC/4jPIjB8wbPvztMUDdcwJqTtH1TaBcwgOrr/1id3nHc77/Fi9amxoeQa4n/RpJ/3WZwiy4D7c4yz756bh+nWWL02hTjcL11x8GeUsh+se2erxUG6Yp73YnSytIws/0VSbxIBLbVX+u0BYZGwkI7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XpLMozBF; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUmYgSE6usyUt9VkbXqh3KO/HizL2revtsKRBwM9OqA8Ld8x9JvjoHevetrCZSwvYa4JhujT7EbYDgvzyVari8WFid37JBQifTqe2MhI/yw5cc98gwAwRsmUm06/1QfW+OhfThCWFwnZeVVGIxLkQf8hCgOxiOzYiO+uq1pMZXu7l39Xse+rRmX9HscFI9eCEkGNewIUD1MrHSzUW0y6gq5nYhXb8kfdHVPb85QkqDfLZjdf09dw8xFvyb9p9FjcbGzNhPj17BiGK/yZJrLj62yo8EV/L/nX5ANGTH5bO0aYueMRWe1W9Y0Xzw95RJwP8rmv9kdZL2+K9xD44nIOYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wLSwk4HRamJ73z26XGBkJnlnVBE8cM6YNCAnTqRfbk=;
 b=gOaWgwcSyth2ZNjmST1NLQCkbRtFi4hVp6/4UzPKv7IJdRNwYMpp6U8hUjInlAf1D21QEz0BLMu7C/uGh75aE/9np4bMOQ1+KMKvKy/f+gZudhMw+TD52Qbuisl/a08jf7iORcyfOw/6ayTLtwxjDRxPq1i/n32fGYhaWbY0xQj3fCb0MDmvjKCltdssY8WCI/9cLeSfycphfpm9OUNdKyZD/vgqdrjEf8kPchQBOHmoIim6b3lgk+h5Njh0XeXh1kDM9Eu4/DH34ZL7h3Narl0eOYVrfU9efH95nJG0YL76Ay2A4SLD0pEPUGzKcWtrjUOOxmBeKHBSWt7j3uXtoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wLSwk4HRamJ73z26XGBkJnlnVBE8cM6YNCAnTqRfbk=;
 b=XpLMozBFY9SPhwyfCLFab10LPiNC7EfatJiSfs0huaq331gKWCPRqM52PcW8sniOaOklow5ZTBC87Xp4rp7zEHYmL1Wyxb44pBtKMf5J/5azrgykoUz/Ra7ILZr7mmL4Zf9VvSuJY9heKjBK+6qbqi0eYZPiO3SsgtoZtS0aIKFGdSPh0TZkAirSI3adOTn+NV4Dep0nC8uckUn810evwWD3AZXfAI5RUmHoMOM8Apr4gA4Q29o1R9FwUdV9xXpOzRsE9nFkvNPfr598+4wNtZvX0TCXBxZsAS8fCDUzAx/1JLORYBUj/jB4d62eGgl5aWKgDbKBr9LF2tnmbgX4ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Mon, 29 Apr
 2024 17:15:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 17:15:17 +0000
Date: Mon, 29 Apr 2024 14:15:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <20240429171515.GI941030@nvidia.com>
References: <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <BL1PR11MB527133859BC129E2F65A61718C142@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB527133859BC129E2F65A61718C142@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:208:329::9) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b3281ab-df33-4edd-4fe7-08dc686ff0bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U2t1zBzZQd57G+aUKhiRvkZ/ONvxxjkHeziBl1CjosNJ1DTj1kNwSWSIlm1k?=
 =?us-ascii?Q?Ix8K5y+DWrHi5VIJNYO06uUYHab6BeMFdtX6CvxCrhbIsVahNvGa9C38cfGy?=
 =?us-ascii?Q?UdCHdt7sOwIiUSY3i13I63WpXeUDap34PzfIRHq247ZTb8HssXuHebj3xpgl?=
 =?us-ascii?Q?PCTzFAYdj7082R3gTclghvU3ynH9m+yCFP7JMMi/nQq6DzU3nA5sr3ZOVPys?=
 =?us-ascii?Q?UhqpNAQZ4cVWRPA2eLfbIH7QSaWDGJNcys5glS06+q8If0tj36ns/tuSWtN/?=
 =?us-ascii?Q?xtBdE31mh5CqcIDC4pc+4RV6rz6Cg8TMZbyU+LJxyEH6357xelaI2DCz7yKf?=
 =?us-ascii?Q?X9aVs6ByxXwAM/Jn8+NctR54JlcKDvkQyjEQexAxnb+0pvwuR12rnXGmP3dn?=
 =?us-ascii?Q?oBlX35eANb/sordpUWcPZ90hmOAaYp1ffU1jgMe2DQFURs3/0ru8Gpbv1SIK?=
 =?us-ascii?Q?f1beGKmCG2DxWsMnSLHvuO/Z4rhL3vRWhtpsrLn24prKPBOFsEGP+3ua1tOa?=
 =?us-ascii?Q?KTapKRSYmZTJfaiMhOiuoEK3dYSukZMK/+wJWeN1viVvkcQiRc3cpfOeqyOa?=
 =?us-ascii?Q?2fwIrJRzQLoON5hr0H1/7Nb1y/lHlfnZvQB+ksF6piWQt01ibS5lRs0aHrJG?=
 =?us-ascii?Q?52pkjLnZbGN/S+IFhVCTR0p7A1QqhflN/Aa1hVolooT7kSoTRIpE/TT51xzL?=
 =?us-ascii?Q?YLj2O8/OhZqHksE5rUVXLcwuAvYlJt3TSerkua7yQbVmnPKByoSsn84miRB9?=
 =?us-ascii?Q?vxtefT41XPah/riG8A/AicgC0g+3fuy3n+Dc+VG83Z2aXDWquKCGF3JCMurI?=
 =?us-ascii?Q?HbFn+51TdhgESKtAMAdP6t262nlF6Sk7UwUiMcWpjz32Szl0KNXzmJK2ba4o?=
 =?us-ascii?Q?87VqfBhnB6cGPs3sxGxvVEL8sPf3oJfxH+B3U7WO9D1lvQOwM/JiapMkkw4q?=
 =?us-ascii?Q?4om/p8WqahSkQTXBhljZrRpGuGo9Rb9R4pDmx9Wx1k060hLMq+x7GVvChneo?=
 =?us-ascii?Q?0C5VjTk5iYG/yRIOL+2EctlrRauIRvBKtbCyd9HEW0S7+LtrZsjx7boRg6Uc?=
 =?us-ascii?Q?L0KinnTa4U+1fgsBHy2ePq5cgvqBnrqLOJKHgI2dr6fGV9lz8im40uBlAVnU?=
 =?us-ascii?Q?Fmh+9vsmPWwsW28vWPV6Z0eL3/pCnPjWNEOdcZT9GuEZFo3R2Zzcl/LsuK9d?=
 =?us-ascii?Q?t0x0DlQB+x/Lz7a4wWPmVjs4iFPba29jjSUjh9+CtlGSqqDs/qdcscQ4HcRY?=
 =?us-ascii?Q?q5LEN5m7EZ5jb8Zhc39aDSbXdE8sXvdFhyH6ZSZhCw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/cPJbb9sTZeW1DTFGDf8I5cdDNmOEw2LAwSRT5coNtMlAz2L0sN/MCZxbcNs?=
 =?us-ascii?Q?+B4mxYVo5CbppL/fcKUfd9z0eCfWmOLTU5LiA+n1tWNxhermewmjUF5wqxCy?=
 =?us-ascii?Q?IYcVqIcB+H+HNtsZsq1Qw6t/MHbV8EfIK6tWL7lddSwqZPyjCViCChuumYOF?=
 =?us-ascii?Q?ldgy62xshviaWYAJqTy7UOmCKX7KJuYvhr/B+HJ8rPRyywSEvlxNVvv4Vds8?=
 =?us-ascii?Q?ukukhCJJy2lDQDcZ6l7+Aj3DDqOY/uf6HGl/QEuc7LST1N9eivAHXoF8W3E7?=
 =?us-ascii?Q?CqLr/mzx69zvozukvCI2J+9DbD8jIvVu0/ZefZyVtwanYbefSfZ5muhTC9ol?=
 =?us-ascii?Q?SKXpEF7MmPyjwORJ2Wl3sn7gDJTUNLODoDIgK1jy6X1QMmYVG0YyvzHQPNb3?=
 =?us-ascii?Q?aRR7y8c/zMi/cQYQBoRBxXx1muQqB129SS3aI6Xtd9fNvse3xiqhnSyzKbZE?=
 =?us-ascii?Q?mC7j+Ext3DYv62/2mj2wto4dRSkDoG3RJpyVz1PN/fuizbMtG62ORSLC0c1J?=
 =?us-ascii?Q?GwdAJ8Ac+eMalFH26FYAH4FClbh549AWm/BYrMaGqJPpCIWYukes/0TbKNwJ?=
 =?us-ascii?Q?VXTDQF51X0epxb3CtvO8aeYyp7fpVg5EBx1+qaY5tm6sGNDI36oF0c7M/TTg?=
 =?us-ascii?Q?V31WYzOepArjVWBKQlrR70LRk5lWHfbTfTSIlnZKjPTYCnJRTEjVVUOGY0oV?=
 =?us-ascii?Q?utGszfjve7QtFppJb3Tqqzu5PCEb2U2mEouTYOXXjcGHMKufLkZ+/ac3Tdsd?=
 =?us-ascii?Q?v/266uzTt+KaLJoXEk3RJTrcLAE751y2JAWPQYuEt9l7q3NTmbuOhCikmKV5?=
 =?us-ascii?Q?IBMTVZq4ms1DJPBca0BCEn1emdSv3pN5NeBE9L3lpO9oJf+IMnkSGIdlVtvL?=
 =?us-ascii?Q?hRDKV9YlpMXDl1fEWYFkY5BOdbqDlZbmdPWcDjOV5+szde28XR6e7jkSdzdP?=
 =?us-ascii?Q?M2NzXGCN9s6aHNWalqecVPzJWj/DjESz0qqnwwFpMofMhm1nVILZJW34Z2kn?=
 =?us-ascii?Q?8aBpSWsvQx7Ab6nmxUmhCM1Yf2JIud/nAG4Y7ZMJCaVUDOwYhmKLhNpe1LGa?=
 =?us-ascii?Q?pYBxqoojUTJIe3aq5W4IXsP71x3tmVQ4fHz7zoo87yIGGZ8UW7MCGpud9aBO?=
 =?us-ascii?Q?MMf8xv7NTsS2ouVEYQ1zdjist4kG4b4nNGgAnf/6XXoTdeRNRdZWBV15oi35?=
 =?us-ascii?Q?0dtlIfR+qX/ZNLuhcR77aVN4sw0Xm9d6dY+voL7Gve400rRTZ+5zbSUuN+Bf?=
 =?us-ascii?Q?heAZdSA/Ca2tkkhEjT/yYVL612FZ4WKIxI4rPySBw1hhhER/gXddIYxUEa+Q?=
 =?us-ascii?Q?1U5wvii4oth8++NBI81TfkV9qVPoE37qRX0P2Gp6P+t+MBUInRAsqIooXtKJ?=
 =?us-ascii?Q?Itf2gkfLJSe40/0d/foXVFBkvX6udBVyESxaMv1xT+v3clGAA8qhktUboDTo?=
 =?us-ascii?Q?F8Pm2+6ZFM2iFMUeC7zoEvqD1amkFq6UK9tbgMMGmSk2wuAOF/MQv6vNt7to?=
 =?us-ascii?Q?LIYWRB9iIHv7bXe4pDgSSl96sBnQChdYoz+Sy6lKrnYDIe8Wxkb9KBzLu4DR?=
 =?us-ascii?Q?H7pygReebhKYJIwMPXTuHKhg1AsIWk+zgAmoRD/C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3281ab-df33-4edd-4fe7-08dc686ff0bd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 17:15:17.1197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2eK5XaKhLJLaEZ3oiJPIUPFSigH+fR12S2+mWcrSU4sOxPGsU8wxY9lj2CGCryJb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768

On Sun, Apr 28, 2024 at 06:19:29AM +0000, Tian, Kevin wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Saturday, April 27, 2024 4:14 AM
> > 
> > On Fri, 26 Apr 2024 11:11:17 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Wed, Apr 24, 2024 at 02:13:49PM -0600, Alex Williamson wrote:
> > >
> > > > This is kind of an absurd example to portray as a ubiquitous problem.
> > > > Typically the config space layout is a reflection of hardware whether
> > > > the device supports migration or not.
> > >
> > > Er, all our HW has FW constructed config space. It changes with FW
> > > upgrades. We change it during the life of the product. This has to be
> > > considered..
> > 
> > So as I understand it, the concern is that you have firmware that
> > supports migration, but it also openly hostile to the fundamental
> > aspects of exposing a stable device ABI in support of migration.
> > 
> > > > If a driver were to insert a
> > > > virtual capability, then yes it would want to be consistent about it if
> > > > it also cares about migration.  If the driver needs to change the
> > > > location of a virtual capability, problems will arise, but that's also
> > > > not something that every driver needs to do.
> > >
> > > Well, mlx5 has to cope with this. It supports so many devices with so
> > > many config space layouts :( I don't know if we can just hard wire an
> > > offset to stick in a PASID cap and expect that to work...
> 
> Are those config space layout differences usually also coming with
> mmio-side interface change? 

Not really

> If yes there are more to handle for
> running V1 instance on V2 device and it'd make sense to manage
> everything about compatibility in one place.

It's complicated :|

The config space layout can't change once the device is discovered by
the OS and I have a feeling it can't differ between VFs in a SRIOV.

So even if we did say that a device HW/FW will change it's personality
on the fly, I'm not sure we actually can and still conform to the
PCI specs?

> If we pursue the direction deciding the vconfig layout in VMM, does
> it imply that anything related to mmio layout would also be put in
> VMM too?

I'd guess no, MMIO doesn't have the OS and standards entanglements. If
the FW can reprogram the MMIO layout then when it loads the migration
state, or provisions the device, it should put the MMIO to the right
configuration.

> Do we envision things like above in the variant driver or in VMM?

In the device itself. I think it would be an extreme case for someone
to make a device that had a different MMIO layout that could be
backwards compatible to an old layout and NOT provide a way for the
device HW to go back to the old layout directly. If so that device
would have to mediate MMIO in the VMM or kernel. Depends on the
complexity I suppose where to do it.

> > > Consider standards based migration between wildly different
> > > devices. The devices will not standardize their physical config space,
> > > but an operator could generate a consistent vPCI config space that
> > > works with all the devices in their fleet.
> 
> It's hard to believe that 'wildly different' devices only have difference
> in the layout of vPCI config space. 

Well, I mean a device from vendor A and another device from vendor
B. They don't have anything in common except implementing the
standard.

The standard perscribes the MMIO layout. Both devices have a way to
accept a migration stream defined by a standard. The MMIO will be
adjusted as the standard requires after loading the migration stream.

Config space primiarily remains a problem in this imagined world.

My best view is that it needs to be solved by config space synthesis
in the hypervisor and not via HW/FW on the physical device.

> and looks this community lacks of a clear criteria on what burden
> should be put in the kernel vs. in the VMM.

Right, we've always discussed this. I've fairly consistently wanted to
push things to userspace, principally for security.

> e.g. in earlier nvgrace-gpu discussion a major open was whether
> the PCI bar emulation should be done by the variant driver or
> by the VMM (with variant driver providing a device feature).

Sort of, this was actually also about config space synthesis. If we
had this kind of scheme then perhaps the argument would be different.

> It ends up to be in the variant driver with one major argument
> that doing so avoids the burden in various VMMs.

Yes, that has always been the argument that has won out.

> btw while this discussion may continue some time, I wonder whether
> this vPASID reporting open can be handled separately from the
> pasid attach/detach series so we can move the ball and merge
> something already in agreement. anyway it's just a read-only cap so
> won't affect how VFIO/IOMMUFD handles the pasid related requests.

Yes, this makes sense to me. Ultimately we all agree the config space
will have to be synthesized.

Jason

