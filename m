Return-Path: <kvm+bounces-18053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E5F8CD660
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 16:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99D9E286408
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E17FB67F;
	Thu, 23 May 2024 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RF2YfXCQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B33AD2C;
	Thu, 23 May 2024 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716476337; cv=fail; b=BvvtEU6/Ln2T3UglQ7ai5mWTiUhZqXHWPJKJK1SfkyPwWa94xQvSLbB23fnc/xcCQLDX+WC4lmwbTDjwjP5lCR6geNBLSgJbSDkpFCH884zoT0KxR4kr/6tTwNBBl6tcDgfOx4QXjSuiZK6stzzkFIT0apySZIYlemuHi1QERJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716476337; c=relaxed/simple;
	bh=4K+v5RXO332ltIWF9OAanmyxfQdcNtBamoaQaZpgMs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tmr/CVCCzrWN83/5DvVHNPvBgMVVj2YdU0b/Zf0lcUKCGKqhCS7iXCkpwez31LwFqKvEf/xJtllx4Q5tekoHSM/X4SLEmm/rZYuoYdvV1zdav5HBttQuwN0zB5tYT7XT6RuIGHc/K+yuBb10y6OLciSSUZIArpBPG5t4yKmcObE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RF2YfXCQ; arc=fail smtp.client-ip=40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeG/oOIYznhn6rN3vXT1/QuLlqwWvmQtAccCY1W3qkZCQFC/J9kJGWwHj0Ra2/8W5xn1d4VElmS/a9F30uESwpLemAseYNcF7QpUVV0bqcNOuexdS3wR81y77Soy4mkw8IcrlqA/1byuccnlarasWUhuktEJrGcHT/4pofCHgXG+335Hp2bl9DZYqNrgxkQGgAi55m3fY7Ak44fEev8dDD+KYZVUCPrpa9UbXkTVkFPFea3IrB65TOqgN7cTFFD4o2VB43VKG2ajBsZC7QO3WGEKfqDpYIm1FVSOpaU7k3Ju3rBqnzJR6zLJt9+ZhMg/mGGpoOfncFiMDlx91Nln+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8++VBg1agQTiGKWOhILE1ijDRpUdZrr8SuE3a/3q8I=;
 b=GKnPMxcWXFkMBi/LzioGxuZ1606q8FWCdsTB2B5QbVGaCFtj4a3v5oFsIzjMY9UQv3Y1zMxc7/ogQqE/hHElP0pi0rI7n6Hj/2BzVtnWmueG8cPT2Tl3obTZkkeTy/vnOULnM/FHc2aLmpTXz9ttqXIRnU08HdJazkuCNKsEVxL4KhWPpFj7DCf2KMEQlyfxkNzAjVxdLKxQr9Ge4pe4yR5mqWgvuZIGBBU/gSbjA9NDbWaqxLn8tU4mO3e95Y4RVTqYyJBCRH8o/RGfjSZEXO2R3OuB/ftBtrT3rkI2T/y994tIv5ymJQFA4EnU0rXa9P5c3eP2DeURL4cjwAvJNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8++VBg1agQTiGKWOhILE1ijDRpUdZrr8SuE3a/3q8I=;
 b=RF2YfXCQ7jGawjkY4gr5A3NTT7cJ+SgcDfUzD57/+tXdb+G6lTmbOuAz3UVHGBulHsXn0upwEDH5H6gQgl3cJ4ycSH7B4A5tgZBCkWsshBzUN8GWNDAmfaON+k4RZAo74cLxbugnuGaP8r3mvq9Tx9lFGgDlkVmayuLznc9168F9tJMEWVpO5hgpa78IQDUeCjmxYsBZUwEQR4es7TM2RvnFSGEoJMjTkikKhS3JyjqO6P1qRlj4tkjyQAjVIm1wm9nL6ajeN9rfjvWy418/RHFGNCNA+xKNGQN7ioi8x7OKpTA8olWr4INYW9nH6WO6pzashqTIk5/eff9dnmfWmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB8073.namprd12.prod.outlook.com (2603:10b6:610:126::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Thu, 23 May
 2024 14:58:50 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 14:58:50 +0000
Date: Thu, 23 May 2024 11:58:48 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240523145848.GN20229@nvidia.com>
References: <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
 <20240521183745.GP20229@nvidia.com>
 <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522122939.GT20229@nvidia.com>
 <BN9PR11MB527604CDF2E7FA49176200028CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522233213.GI20229@nvidia.com>
 <BN9PR11MB5276C2DD3F924ED2EB6AD3988CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C2DD3F924ED2EB6AD3988CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0327.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::32) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: bd185a79-42d0-44f8-31e8-08dc7b38db11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nQ33JfajdpJ67TcklgDgXOGNV/a7ZErihsBtspEihhVuMctI9kItB9zRVexl?=
 =?us-ascii?Q?bNkt0NzXJGltUu752XPzZtBIMoJhLrl3l7uasd1SmNdAmIeZjI8L1qMAQeNR?=
 =?us-ascii?Q?sNONUVwm+nAlNrH4+ytB3aTxdrq8CY1/PUrwcJ9yE5sTg2sgLDA5t7pUkIzU?=
 =?us-ascii?Q?jo8RBx1yajiMoRp1yRCFAoJtqSvsaQa88bcPVKWnEdrl/W1eyU/EYVA70uOg?=
 =?us-ascii?Q?9yTOTrr9+ge5Qa7ADeI7NBp3Z3adj2fe0S8m4tadOrQIGNiNxI3VVTkBbKP6?=
 =?us-ascii?Q?L4ZEbcVQi2STnWIqnWWkf5GY5BWRync9/i49pceLoO/N40RFIKppA2GGHmra?=
 =?us-ascii?Q?h5yyiuSVx2j3yg0GAuMSTCvI/cpGlN6Hx0qJzBtyPxFDNpxsL05JReA7fGh0?=
 =?us-ascii?Q?idat6XwEJWiZMWg232r1YMb4DmduUYT3lztDm3GYsmQKYoH0VMCed8xy5Fpo?=
 =?us-ascii?Q?Wz40un8G+bShOQXo4TSsEXyVTrQuBTPkBj96Aqc1WRroeAp7IPuph791iAjO?=
 =?us-ascii?Q?FD2txq9e4xlXd9fO6+Un1LtUm4yB1+ICB1P1n11q3iXHonGTgN03y7NaZEbx?=
 =?us-ascii?Q?nG+e4im6bqlvm1IZ/7vbWJS5q7yzTv5MJhVWsySgC1XZCL3lmaCEJhCBzoaA?=
 =?us-ascii?Q?nwr7Ua12SfE7jiRfwJq8YZE9/hY5PWVjZU9kcUztYnYxqQ3uYCOcZoYGYNeb?=
 =?us-ascii?Q?IxEsnRPhmsEM01tqiDOTp40aqHS8QYx94vDPTJpIuHycMenTHjZIB4KL2DXi?=
 =?us-ascii?Q?lzKADEAUIorzsCJX+y7uvoIg89UV/3U05oCYeCaelGnW1HfazgCxHtVRxyl8?=
 =?us-ascii?Q?exYYxcJGLTz18/JFrn/2QTBFN7Guwsdv1z5y8Y63+4Xh/9i88B/LclQCiuq8?=
 =?us-ascii?Q?bpaNNbrslDTgs73JzbDCcsUetuQLW+uQ/duXVMt7Z6vX1UuhWfilduF+DDA/?=
 =?us-ascii?Q?YUazL+oKkaGw0q9ChTo68ASsfOHbSrxe4IDG1fGxiIprztiC+W+yX591r/io?=
 =?us-ascii?Q?gyTw/s8ppAJg32auuR8yFIwso2CG+88WZrcTmow4DG0DynWIYQa70JRfeohH?=
 =?us-ascii?Q?N35f5rxen6PsWLDTTv5S+5MuOX2D0cE10xLO8mvs9Kbe/M+gcPpQ4wSsUSXk?=
 =?us-ascii?Q?M88qNooFJnDQhvUWdFpt+74XnXd9OQJU8QAZT/5ROs2eHTBZ8nkCWypOQOkg?=
 =?us-ascii?Q?eOkUP2WCTn13WYTu1f3lANf/iw5GOMLCbbvA3OOwdSE7Pkov0/wNRbBMA4xb?=
 =?us-ascii?Q?B1anv7CrX88Um8ERZKH9ksXonrcNBAZSfkZnl9bm1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fOmzRvcmRcddxcmxr3Gqh5P0PIXCWVZzFnS7xHS3jwePW99YOqn68v+qQcTJ?=
 =?us-ascii?Q?gvqzsjn64mkGAq1a2LU+8GYLvu7i20mi5Nf5yifRfvpSXMpGFCraWE5Pb8Yn?=
 =?us-ascii?Q?yDsL8hmUMzglr5JJ82dwaJWXlakTE0IGHziRKAJ1hkjfes/XWTO75++kzfr3?=
 =?us-ascii?Q?HNSMr/hPsA7h98Q9PSXA820T897YgTUM9n5uRzP+MzbahvoV46GWNChfpnYn?=
 =?us-ascii?Q?Lb7YO+nksSfU0JTuhjlkGslxKcCnFYyecX6MZtNKdor6gdo4535+WCo7fvBS?=
 =?us-ascii?Q?J0jBh78igdZlpcabehxct4aIlRlGkPsneFtpVD1O+EOp+liccd+ShRH1TbuC?=
 =?us-ascii?Q?6p4tIM3gTryenkCOZvtknQNhC1MVymnXKRytkKeS0clnVgRU9K1NsYqGoaRo?=
 =?us-ascii?Q?GmCo2zgolNCX6pnW4KTfa2GE0eSK2YQ5z9hQVYa+TehmzLUm/A1Bn9LPxiDf?=
 =?us-ascii?Q?YR2Ed0c9OVPPLlbG5JyZ3qVqfDsxlgCHl5GmEzXNMO6UPF5CiRu3mYRarELL?=
 =?us-ascii?Q?PE3xwi2oO5khz7C3uDsvC+hjanm+X6HxTagsQTOQEf4zUk0TXMkCfoKq6DiJ?=
 =?us-ascii?Q?aDVmL8p5hdFiHjXqGKBiq70YJ75BXzrYCQgp+eYEnaXa+qCJ70AQN6ktBLPh?=
 =?us-ascii?Q?K9VHD4YFu9OZKrnp/PMMCE0240geD6T8AlsuirHc5N016ZCdmVdryt8B9Hzw?=
 =?us-ascii?Q?Bx/TEzVHWLpAeAVz5EGkqEy06qBeXBZKs+eurq0FH22Khuke1nHuDfhpAKbx?=
 =?us-ascii?Q?iAm4cAf7MzqdMiF+kWPbdf6ehtIMnWo+5ug62b1GC0FRJKsBCeSAPih4FZBU?=
 =?us-ascii?Q?U1onVRwNSFtnjqnIRMfTiXRWZ+GH9KrJYwyTjd9gismKCLJAWsgD1k+xeLoE?=
 =?us-ascii?Q?qKMTWpiGCmwZi45DSYi1G/9DKvnAIUONA+lNjVVU6SwvM8rI5Ck1XwElLUiu?=
 =?us-ascii?Q?mHAUWVqsH0mqwzjbke1WIBNBNqCVxP9JSlLRrdAuiRlCn0muVLUTnZKypuJL?=
 =?us-ascii?Q?UL8UlOvnBl4yVL4VuNke0tbaaQdcaHqKJr/yqexqw7Eaxsu6ZxJ/gegMZZgz?=
 =?us-ascii?Q?vllhG3FxKNC0HN/QofBwdGjZ1OIYbtP2NX6/FXKeyZw+A3vC80z50facoccc?=
 =?us-ascii?Q?bOGwpuOrbVpHwibPSGvT1Gd7kiA3GRh4OkDsVF3Sm8HQ/eRA2NTlAzU0/xC7?=
 =?us-ascii?Q?yDSuEVIG3XOuGgpMxxL+9OFZx/+ivUcgOGFh5POzAw9H5X49UT1SgqVLyz8U?=
 =?us-ascii?Q?0OrkA9nj5rwLqYmJ0KWVZTpv1/BkctyKNyQrJsO0fdQ35HTRv/faqJup4iEM?=
 =?us-ascii?Q?MejJoHAejeMNlLhhaXsUkbgFBKb33k6ZVlTxkH+4FBGlBUl6L6guAqPOb6N8?=
 =?us-ascii?Q?JdDIbm5xNz8KHys0V7KlqIsx2IscX1jzdDj/htveQsdKWRVPPQHOb5icape+?=
 =?us-ascii?Q?x8EhDjFCAdlvb6fmRk4zp/p5EqklVSZL0VHDbnZOiUkZdLoFnGNPzBeFodcI?=
 =?us-ascii?Q?pj7MaEbELHuqvtGBIrtVuQQnBkD/xABchpM9g3elQHt/XWKawtfMmZGxjQn2?=
 =?us-ascii?Q?BtnA+alYtByrd6PgISU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd185a79-42d0-44f8-31e8-08dc7b38db11
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 14:58:50.4825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: naiJYk7qZ0wOff2k2ot138dQuHyCDf1Pfj/8R06hpXQlvDZSZD+c1bRIvoxnSMcT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8073

On Wed, May 22, 2024 at 11:40:58PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, May 23, 2024 7:32 AM
> > 
> > On Wed, May 22, 2024 at 11:26:21PM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, May 22, 2024 8:30 PM
> > > >
> > > > On Wed, May 22, 2024 at 06:24:14AM +0000, Tian, Kevin wrote:
> > > > > I'm fine to do a special check in the attach path to enable the flush
> > > > > only for Intel GPU.
> > > >
> > > > We already effectively do this already by checking the domain
> > > > capabilities. Only the Intel GPU will have a non-coherent domain.
> > > >
> > >
> > > I'm confused. In earlier discussions you wanted to find a way to not
> > > publish others due to the check of non-coherent domain, e.g. some
> > > ARM SMMU cannot force snoop.
> > >
> > > Then you and Alex discussed the possibility of reducing pessimistic
> > > flushes by virtualizing the PCI NOSNOOP bit.
> > >
> > > With that in mind I was thinking whether we explicitly enable this
> > > flush only for Intel GPU instead of checking non-coherent domain
> > > in the attach path, since it's the only device with such requirement.
> > 
> > I am suggesting to do both checks:
> >  - If the iommu domain indicates it has force coherency then leave PCI
> >    no-snoop alone and no flush
> >  - If the PCI NOSNOOP bit is or can be 0 then no flush
> >  - Otherwise flush
> 
> How to judge whether PCI NOSNOOP can be 0? If following PCI spec
> it can always be set to 0 but then we break the requirement for Intel
> GPU. If we explicitly exempt Intel GPU in 2nd check  then what'd be
> the value of doing that generic check?

Non-PCI environments still have this problem, and the first check does
help them since we don't have PCI config space there.

PCI can supply more information (no snoop impossible) and variant
drivers can add in too (want no snoop)

Jason

