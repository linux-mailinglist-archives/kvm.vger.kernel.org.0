Return-Path: <kvm+bounces-38445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEC4A39D10
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 14:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB7601795B6
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 13:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6996D2698A0;
	Tue, 18 Feb 2025 13:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uSlvq+iL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6669265CDB;
	Tue, 18 Feb 2025 13:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739883819; cv=fail; b=LEPAORUetBBybBFC3WJ8bLWksVlSD6EJUZ763JkLSp3ykgbZBvgPBPV5r0lCzqA4Or9JQAaf50kh3HimEelg5WBjzeMyCjGpz0PQBdiVaRGcnfC5Fm/sWzFeNKK7ci1Epq9SGy8B4iEmwusCUawA1AHrZJAljGiZpY42ppbQhK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739883819; c=relaxed/simple;
	bh=KM2FoLADZLaxKpCPJnAbILUusZPIy1GLjT4YwVuJ7FY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WxUuyBIYJ/+qM/FHKKaRmRNkXlLx6L/aTvyrLa2bMR2iIZqA5LzVDaZmBnYGLHQfCDFRGt8UMZ9no0rVHDg9vis82uPg9c1oZdRSp6BSV4bDsCmmaV8dgh+UJVHvOewSkY+YoXp+fEQqskBeXEZNAaxTNfAlcd1XLyr3FFX9hq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uSlvq+iL; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPSBIWjVoZnetdBrKg86dH3UcydConk8IZw50y3ERfBFcMuFASPZV/ziMYGjd++bbOX14vj++ZKCXzf0s5t3D+/dpRIIHPVSHDniyxrVlw+9wlTxPyBDXKjgr4cDVQeOxjoBVJdLVTJQ4a2bltKclCKyaaJzXfuvEXLd6ah9o53QnByyLgGwlTF+MYR5rsiKwP3ZhM5sm1XhxxEdT49Fqj9yqs/t9dF3k9SP7A6aH5FMj5u0mfAH/83StL0I8RxNcfia7ycCMm1oIYfyNugtH2t/5U4/kt5P8Ft3tKcsIYfyBctpDQ76dvXdxSeBILLuPe+oegm6B2wA4PdVcyyVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4EHT70QvnguHtLNkEFqJ6klgp+RFJca8isYxzQWiVA=;
 b=Hi+WYB43NIjtW45L2OrBu9GEFy3dWUo7TEx/AKXPCSC4m7MqMSTXSs+CKvIdwdvEDjHAb1ccoD8OECVf2CEhyFt4f+IZareuAp8S/7HZBXmHKwtjB0ZSYqzUsO2rDS/FUGjOaRkLZ/oOBpCM0OxenzRQ4kcYSK3Sc1Z2cNb7+OngFrHZe4NVEIJMc/Fk4w8as2PnY4cNRhiSOP5PV8vQmTi5UVHJGfgJL8S+RWoE6ifETPuUABQPJw7WJJlq+FgQadKo7i0xwLZWNHiwKy6b2RnfOJwNlsoEXr0+lnWucgQEbAoDjmVnpZMiMKD6ND99A8D9Ip3cttcYje/5FhyDNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4EHT70QvnguHtLNkEFqJ6klgp+RFJca8isYxzQWiVA=;
 b=uSlvq+iLv/W+h31sdGSzK8vXEbibu+ya75M6Su5IozRaXxECZI4yoVYZEvgPLBPR0yaQupDy5HesrKpdBPnOof0Iclfc7Loa9uWwDbKWYGHOZeDF37iYeiKhKgSj41UJvAi+TEZ/vre9cl7I2pc3iRF4eUB1mzARjS0ACvifYmM5TuyYgyq+mjZ99GSBzfTnn+ijqphDO2U3GgHLZOOfARCDJ23N8Ly0aQ40mK5K3yxCutfnZqk/F10SDY+SCEnfXHiybLskaMFYR41bBlM8fiEBBc9qdx10TE7E/e8DLcZUYlMZS0CuYTAzKkwP9T2AkU8zT5fSXsYB2Otahx6UMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4122.namprd12.prod.outlook.com (2603:10b6:5:214::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 13:03:34 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8445.019; Tue, 18 Feb 2025
 13:03:34 +0000
Date: Tue, 18 Feb 2025 09:03:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20250218130333.GA4099685@nvidia.com>
References: <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com>
 <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
 <20250213184317.GB3886819@nvidia.com>
 <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
 <20250214124150.GF3886819@nvidia.com>
 <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0357.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4122:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a4646b-72d5-4df4-aea8-08dd501ca68e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4j5BOeIE14S4WP9mgUR9jqPLjDXr/U+p4xpcptE0ar36Qd9CIxRS+m7lo3V2?=
 =?us-ascii?Q?j3m5rzXNROFOAV+0tTse3LPRgJjrPrsC1RiNvDUbUTKIyE+h99L5Gz2j/rsM?=
 =?us-ascii?Q?iEYaTLUVzVZx6xktY7u8DdRaNg9ymySwVrzP4/Uv839Z/g8q8ri52mRZF3WL?=
 =?us-ascii?Q?qOtVETvzcPe1+EEfBE9OrDxy3UHHiffNBJxLG6hEaFJc5GlLotDP88ilOwYJ?=
 =?us-ascii?Q?R6dG6PK7SDQSLsrzt5/tdeO7qWMVEKQmdmhlUcVMrjH0EBrw0C3NHUEeD+DM?=
 =?us-ascii?Q?FbPGxjMUxX4SQsHBuDoR/Pk9QiJjfeWmwogvUGyOxygmAKlnJrsKu2/3fKXL?=
 =?us-ascii?Q?qRWgQ0JqliFhrdwd/OmgyYtZuBHvNlnO7hwvxIpckkUl23EFtiB/RhQZViPB?=
 =?us-ascii?Q?XTT5uAfyCVaAfmbVMEx9yI0MMH8uR0HC5L9v/q8bp0U7j8k6JP2d4ZtruLFp?=
 =?us-ascii?Q?fD/FB5+T+zPFtQHige7DU7jrxJPVV6PsgErbt7j0ZXwSSupGJBePdUk1XSEF?=
 =?us-ascii?Q?8vyhHDzP1DFz2uFwkj//d7dJFV2FZXMURG/grvWKioCBU9UcVQLfl1xgGsBh?=
 =?us-ascii?Q?xK1/GW1ILCi5GPKUfkx5mPay+ajPbEEtns7gSmbgVAOZFJTdsECbeyMnMl8l?=
 =?us-ascii?Q?H5/5Q5IFYs0uhd4pKDC3iO92AngnFQAxLewr6dzQ2uDiouRx5NJxN/xGtLxH?=
 =?us-ascii?Q?lt1SRJ9qdQDFvS5hrL4fdIEiebRjDVfCdr8ytiDQQIMuuFbwgouMe7q63z1r?=
 =?us-ascii?Q?ckHNvdwgl7n+CY7e9+m0GY1e5+x5e9w00DTpva6p3ahTjMOUAI4R70NonTlT?=
 =?us-ascii?Q?WFBq4K9SGUnh3FPSt7T9WUquNs73F/RYzPTJgC8MasQRF2BUC8H2oY8JMEN7?=
 =?us-ascii?Q?FeWkFcdqTVzawqPSavSvfyYmLxQooFDiXGrPKaJZOxJYxu1dA6Ebo6XrJaN1?=
 =?us-ascii?Q?EPgV+LYDp+l1Oac2NfSwjVmEnk719Zx8weD6Y/ZrRzY+v8GI0gmHDrlubU/z?=
 =?us-ascii?Q?dn4ErSh1CqPVjzXyhgT99Jeyy9E15L6NdoWXYs0csjr7xL6aiKqTbukmzIK3?=
 =?us-ascii?Q?DLqKX8gzs3GrhK3zQhGunokPx0wIy92ywkYhv3f2MzrcJIhC0h/yzgXkllM7?=
 =?us-ascii?Q?W9bw2frWrGRGOQfi6s0cVqKsmRhf5ScWUDmv4bmbYwV4hlh8IOOGqFiZFi94?=
 =?us-ascii?Q?oQnDXmBIN4KFYoPPdKvBsmTHydFnjlIFl9lyQC0kGSXaE4chH8bux4XJFGGQ?=
 =?us-ascii?Q?hF2Vt1uiDKF0TY/6NJIJX29TasI4xBoTLTXG9C+4NiVI98PBaRdHNiljLeq1?=
 =?us-ascii?Q?qEYakWTscQqXcOv+2chgSVKsFbl4iav1fYQM2ShI0dCvmuqbq3EpD0E/ZtTr?=
 =?us-ascii?Q?UXNt5GXHqEhuhvFbOaLgN+Seryee?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8YD3FT7FGdkmRmgANsh6ws3V2XUEUjdzkESm1aMCRm9AWk1NCRCqbLkrDLgX?=
 =?us-ascii?Q?7Sut7LcE7RnK0GRRAw/1B/j8yAzq2hLbiWggdUl1zY2XdLNj+7XzbxOwZE3S?=
 =?us-ascii?Q?9E0QaLKvSTeHQS3CaQsllmudJH0r6VRCTiqBW/p4+dpXmnUmbBh7K1ah8Bgi?=
 =?us-ascii?Q?epdH1oNibhr8Nx2nNxuH4qKZPwdaYtjEvHUgtFtU1RYGqWxE54hWdEYwN1qE?=
 =?us-ascii?Q?Ulu1URqYPuut4gt1pkXk21xu+tlan3ExX1xycd6Dp6pVrPanO9eZEPaszD8H?=
 =?us-ascii?Q?JGCL2wWuaC/pxPl0UWxzJpzyiNWRanohdRMAv85586DwEMCF7991/PFmubqZ?=
 =?us-ascii?Q?XiTjH88B/6RJu3f8/3il4IR5so7xr3LDN4keKPPwQ/ogJ0Qxzv+IF10zlwhU?=
 =?us-ascii?Q?5sdejL2nS0LTso+y/oM1YNigpQwwi/OGqPItG4+v3gP04SxlCCNi938u5c9i?=
 =?us-ascii?Q?k7Brg9DqebvMfalyH7r/shTYbMSpozUwto6catXowGy+qS/jlmNUCVoLlpPA?=
 =?us-ascii?Q?93/qf+Y3WcvJuEdVJ6kRA7rCy5/aI8Nc6uTAd03hw7ZVq8CqwQ8pKL43mpSv?=
 =?us-ascii?Q?K67KThE3c1Ps7xxDWuOmLlYrkbFBULMuOdxD6LYjeoxGxAGRPJ2SQGrBia2U?=
 =?us-ascii?Q?TX/YpFingnO///9l4IJbyvSLqdy9LJVtSlJu6+Z58ZIUna27z/zma4j2ENdc?=
 =?us-ascii?Q?ewd3bF8SOV9iuP1JPw4NhNBuGhCykU1jUBSri5RmHMuyTVwsSk5zyqxPSvts?=
 =?us-ascii?Q?+fxSaq/isYM5oWi1i6Q3JqfGGWBNnyKjCkGuFrLdM0p0wVLSgf9fWGH2vj1s?=
 =?us-ascii?Q?5WItdnAMGPVz+cGdabUz+/eYX2wp639md4S1hNiJ7OnOn8MHFWQsuOhvra+A?=
 =?us-ascii?Q?NBslBWfy3clwHnFWEfayPd7mAzThuEKQenS/ODI1G+OS1Noenz95P4Ue8vFR?=
 =?us-ascii?Q?4sqQbaHVKmG4ew/ikXxmr5yIF7KgSh2qqqhV2Pfhg35jQM8Hy6MPiCsbkNP2?=
 =?us-ascii?Q?ZrTTld/YkfWQKLcV/Q3jfaghY0JSHaU06twT4QCJ0EmZm6E3HtfMLRWCPPxi?=
 =?us-ascii?Q?v3JxtJNbPPB5rDZpWkNf2Ln3tGKC6WoprE4ouqjQdE236K9lKE4QK7Spoqam?=
 =?us-ascii?Q?38TT0txQYNpV1PGp86Tgi1d81jfjRW8uJ/x5rbMKiaPYjOfkZj/FT7d9sE94?=
 =?us-ascii?Q?taMlrnte4q0TgoCnzlPnnN/FFUsnW9WRjKKWqXGN/gT7RBu4fOzTgqQNy7Zq?=
 =?us-ascii?Q?f+y13AclZtu7bK4bbmjqpaK5bufSMLgUKjitrhCGb/rmqbB9e4/v1hcst/PC?=
 =?us-ascii?Q?nWFvMVrrxFeJxFYiLzsyUIkWGAo/ICggxGAgIBUsK+zaPqdezz2PNsagW8Yn?=
 =?us-ascii?Q?45rO4PGpYxW8ZCYRnjO3iD2HWD9DYRTVweThs0BYy0MGcpszeLNbmyRh1WfM?=
 =?us-ascii?Q?Gi0CLDArDbJtVO4WuG8hqIobXWs4kY/eluZzFipkuQcSMtEJNpwDAnR877mQ?=
 =?us-ascii?Q?DwgmzJokKxSW1mdeO4WSXlhi0ulo6zL840iOqHp3xliyE9JEKjZyNQwL39Gx?=
 =?us-ascii?Q?3gFhJG/z9JHlDSo3has=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a4646b-72d5-4df4-aea8-08dd501ca68e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 13:03:34.2538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bvn67RUXSln3UYkiiOZt7WhaAbnDtxzIcv5XqHzwiZsUDsnGAkt3Ca9o3cHR4Fm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4122

On Sat, Feb 15, 2025 at 05:53:13PM +0800, Baolu Lu wrote:
> On 2/14/25 20:41, Jason Gunthorpe wrote:
> > On Fri, Feb 14, 2025 at 01:39:52PM +0800, Baolu Lu wrote:
> > 
> > > When the IOMMU is working in scalable mode, PASID and PRI are supported.
> > > ATS will always be enabled, even if the identity domain is attached to
> > > the device, because the PASID might use PRI, which depends on ATS
> > > functionality. This might not be the best choice, but it is the
> > > simplest and functional.
> > The arm driver keeps track of things and enables ATS when PASIDs are
> > present
> 
> I am not aware of any VT-d hardware implementation that supports
> scalable mode but not PASID. If there were one, it would be worthwhile
> to add an optimization to avoid enabling ATS during probe if PASID is
> not supported.

I mean domains attached to PASIDs that need PRI/ATS/etc

> > Although, I'm wondering now, that check should be on the SVA paths as
> > well as the iommufd path..
> 
> That appears to be a fix.

Does SVA have the same issue?

Jason

