Return-Path: <kvm+bounces-17972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E028CC52F
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 18:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9359FB21955
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 16:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3811420CC;
	Wed, 22 May 2024 16:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fh1x0AEF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64922249F9;
	Wed, 22 May 2024 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716396748; cv=fail; b=eWY3dltMhfYHn3VaGeo91k8ffTItfO3P2P2U9DZMRRXCiIPvfxgfEW/u1fLO75eVVE09LHDVKASyjIuzkS4pzhNHiQc5+ambRMmejfjP8rwLvpTx/Derw4nZbKmz3jwOaswpXG23WcRDARVJKoD8YFO7IAKjcQJkEzccF+Dbe4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716396748; c=relaxed/simple;
	bh=0EgOuWQdDJHWbABwpzESWNMYM3JYvGX468QqvxPVu/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IZyK/TbYCd5HRCtVxKtehcX+MpqkPN/78GAqyMSBdDy+BPM//v4HH8yeV4ocv9MXXmHJd2xBCKhaTmsHZpoDB7Hf9kgikBUski/6ee4ej7YobQVJBzQ8rqd5r8xDv/hcjbiY/L3BIK+aUhC/3YjJHFfWqCa+2XUeAHyWP4NnCrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fh1x0AEF; arc=fail smtp.client-ip=40.107.243.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcrKFyABLwZzTYD3APQ4FCDy0RF+Kzw28qHEdb4ibhyUOC9oCLQbRcv14nWmmmH4X8MLuFQhPAzecEdhAGwyqlAi5pQMGq3/eBChzd4M9VIa3saUNHmojFgDUsa7QhkVpgC19JVlYX5F0sW+AICpoK/A9xfY+dPCctzEB9mS+YS2sOBbuAuxzA67Ahq2nMXTDkTLQFA+L8BpkknA4NyvUgSKVhOuR823RUWx8huXoKT5El/vXtgGMZDn3kl9aFI4Fjl+2y5jYC/bWbI9ZCQMp9R1+mHKf9DBeYcoaot5BaHCgI5FhazRYf0EMN4qAFoM+1gslLfTO6s7IabHF1UTQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EgOuWQdDJHWbABwpzESWNMYM3JYvGX468QqvxPVu/Q=;
 b=aRdImhkBj5U1f9lm6if4od7iNt1ExHNISUZfjsyxqOJu7uG8FZe9v5aPCMQgFGCqJJPXYdRBcG8+8wYblKWyfsiWmRY2FpgvsMchK9V+S1/HP8lkMZI01r9Hd0vHVrqP/+zpcr9Cz9HrEayBGot9e/1Kv3+OAm2dm/CvSK2PrOzyAaPqVGZPk5stKM94VGw5/uZsgJ4iOEfjzXTECRnOO2CDVE/zImxaIjW+Dxd9e7w52RmAFPGbGLbqRboLBQ1skmbAm4P7JQZ8FATdlM+Cl6jexSVa19y54LK1u2YUyCZxZ6EIQzahMie5hDgsEp+R8LXGVTDcxjyTHLK/C5mHCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EgOuWQdDJHWbABwpzESWNMYM3JYvGX468QqvxPVu/Q=;
 b=fh1x0AEFe0QJv0+DOOOS0mNDKfullHLvsicpnCg6O6JMN4yvppwPvOOhUWf2btZOdMplM8c7jcfA+Zz2p2gX+3zNWMhz2GM3qPfdXGKeAfxdxuRz+MsWmaUCArAqbjaouXT8ev36jiLBbzrDQIeG5EwYuZu82pQPEf/R+Bh1h77TWa2loPWRkTsleFlXNrZlouEYz1mnyqOI7aRmgkTbqjig015dXeMiJqS9Bd99bGQi1nE6hvJdI11bUlXjfZWasewJmhI+c8mbE+A2fKHpvdWF3ZB7eLvrXerASwU0p7CBfTu/lSZZfmnK37So32FxEt+eRrGKKmS137CRK95Fdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH0PR12MB7094.namprd12.prod.outlook.com (2603:10b6:510:21d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 16:52:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 16:52:24 +0000
Date: Wed, 22 May 2024 13:52:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20240522165221.GC20229@nvidia.com>
References: <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
 <20240521183745.GP20229@nvidia.com>
 <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522122939.GT20229@nvidia.com>
 <20240522084318.43e0dbb1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522084318.43e0dbb1.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0234.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH0PR12MB7094:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e634c2a-b1bd-4d0d-557f-08dc7a7f8dfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2RP1YnbuwCdcJfipJ0Sk25+PmyxiO+Xoj7Gdyea+weiuLgLNJGluMGcEEDzt?=
 =?us-ascii?Q?L107X3pt9b6/Ybkxh2BlBHhDgrSnwphlGQ8w/l+8GalJZMysNatLYyWFwdGK?=
 =?us-ascii?Q?5nQmK7XIXCi8DPWNs3aaO0bJd5YNsJUmQOh7eS3DKcylAPaJvTM3REfSekxP?=
 =?us-ascii?Q?zHX/3B/3wFA39FUzUcC8QfcBhiQfVd3VAo5e/r0GO+0y/b/re2FINuU2RCs3?=
 =?us-ascii?Q?KxThwasAka7EXeZLZeYR0s2SAzh8SSwirRQtM9J3xF4pgM5J2882WbnZ7t+K?=
 =?us-ascii?Q?WauNg2hWjk+nXXwW9CQ/kim/QIsbqMtY0fe5PjRXv++7mt2DKF/0LyfOGBg1?=
 =?us-ascii?Q?oq/cvrJQVLyaBYvvIEfONgBFjzmWvCLkR2DV2bPfUPARnLedQdsCpyyj3n4b?=
 =?us-ascii?Q?utBsL7dyvyr4CRrM8mwcdAE6Rlzh+wtXx8f7W/MENydt2nPahnyRzT1L0CPV?=
 =?us-ascii?Q?6ZMjM7JpQjKtsiP28ZlzdWc8UbkVvndK17oXLuAuABtABOz0Z94ukszoJnLr?=
 =?us-ascii?Q?vL4TW1ANJLBKFDDaYrJOkPqVDLo+WSTn39K6CJpK/hM8/H1Jx+HLubMsg7HN?=
 =?us-ascii?Q?iIGzc0WmuKDfwJtUwnUW1z34tqIHucx56X0/6x/9cV0OK1iO32dTkLb42xf6?=
 =?us-ascii?Q?YUkhWAbydEgCByoF05liOYGYXhQxhQTuKdvPuqKjs3jUyRuA9r6heigpwejU?=
 =?us-ascii?Q?f+vCiFmGfD5rRl++eMUlWBObA1CwHUBqPE5QpS5jWGErSZz14kk1oBDVXoOa?=
 =?us-ascii?Q?4fBZsrqabtoeq6G8jS7zYrWNp0tHV4J2cTP63xyxIbvfdIMOqDDIQRGgNoXt?=
 =?us-ascii?Q?rY8M3Ee+8FDHefqirJMnSCErHmdNSUpHwQdV1AqZgFxFygk5TfgRLBIdNdKu?=
 =?us-ascii?Q?aKz/7vJ+gPxS4kFWO0jTI14VtOGgE0F3m7Rmnk5isptgHxHNm4VvCOOW7tmK?=
 =?us-ascii?Q?jjMe1TFTAB7noCNYi97TPgtjVR6Jdl9SBJl0hTDgZyYg6zNISSYlaIBl7l5Q?=
 =?us-ascii?Q?KZ/5tUEa0wT+Kgk/yP5C2CIIvVmQHqLDlikScIostq+I2qANayIfaILpqn/C?=
 =?us-ascii?Q?cST39htaFP0iaeZ6Dcdt+/VR5zdRcTUeH0neMWowCGgGrme3LnA04hXOIw0N?=
 =?us-ascii?Q?7Z4RU+MFySks9S2D5L3vTOUwTksnKDoptvj4n+Malij2hBj+OMojCUPVpyew?=
 =?us-ascii?Q?z0LCU/Ph/EsdTmehRnnWC2beerysywgLInFO+UgVk0EY/XjlyfxziBNtaR2q?=
 =?us-ascii?Q?h0kteSZA7JTlo3NwWeOnIBAud1ZKMVCgwNCs9xXeUA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t2swGWIkcAp+E9dcrR+KEVwsCEZq4iM1NhlRMoIw1npadt2/XpPETOyaf6Rt?=
 =?us-ascii?Q?XduOzZWRjHnFeUeqcjp9lDPe6VxuxQGlJmorIyWGReVI+3bVuu/a4chzM4xY?=
 =?us-ascii?Q?haif1K6RZRmvC43RMjOj1QzoQA2ikZcSwqeUQKgCpl+nheow2i5X6q3o8zWc?=
 =?us-ascii?Q?zDyTF6RaTsphYk7uNAo1Q0EsAr0sq0XO7x0f9uNf7+jOfwwVxa8uGSfVfbYt?=
 =?us-ascii?Q?e49a79zQ3d3fjgeFvi/0UdszUbBX4fP2dX+MaZnfqQ30YFNQhblPlgtr+NUq?=
 =?us-ascii?Q?Ira62MEQILaz8qind747Rj7Vl3pfUxI4azjy/IAZNv6fE0u11bJszhK5z35w?=
 =?us-ascii?Q?yOjpF8XUp+BfYgbBuxRF9y4eFCKhj+doInWSEywVd6SNCaDkV7yr64/phlJg?=
 =?us-ascii?Q?NU689rFGkPjz1v5J8mLjSYqv1xJrbiUA0LYNtuz6Z8pDsqVnEqZ9XZOf8A9T?=
 =?us-ascii?Q?S0gH5dtXjHFXSyE50vTu3UZk2AxewJDcbsCyWopR8GUTh1/uC4JM24RJNGeh?=
 =?us-ascii?Q?UT0ZA7uGINHhXdKI6cjtnC4bFsM9NLf3u9PCOK5Xq1ZFsLwzRrRjZK36Vhs+?=
 =?us-ascii?Q?7Cw8Nfzn7RwUAddzFxJFPZizbbZhiVxIs/qiKYDrkcXSQEM+8EU/sStfZzEi?=
 =?us-ascii?Q?I+2sJvO9i+tClv74lTi97N/iwUf9PdS3sMeSWg/kY/SixmEVScaGBq0wPQk+?=
 =?us-ascii?Q?+unYvASeUb4ANR7AMOpJ/V1f3QlyXDnd4+xD+SwxRgWGXN0UHbMLeAlq1UqR?=
 =?us-ascii?Q?SflDjRuSeJeCC4FBKhOM1kbDd5g3Qrpqa4kg9236cV8M9i2DfDXCMId2nivw?=
 =?us-ascii?Q?M8SG7zUHGzj1SXK5ITsCyqncYfufjpdtTgLt+ojCcUMod0r4BdSY24xntX8J?=
 =?us-ascii?Q?7LfKT5e/cGhNAwbeF1SlyAHhOc2C+ypJESzdqd1jWqCmFjrQKCiJv1Cp05iU?=
 =?us-ascii?Q?NYN9ybSHNERpCWLMMDSxnWWFMp6SP/2aajaJQQoKtIbGHjSDQKynDX3sPejM?=
 =?us-ascii?Q?iQjs6jDk66dSTvLqMmLO/7AY7WA76DV7jTl9GuC8BgDvPg4ENFnWkutVM1ay?=
 =?us-ascii?Q?jXzxfbudTe/YQvT4gKggZzRD3zJeDvKxOPnj3vT/FbDQ2rdMWMuTplSwdPiJ?=
 =?us-ascii?Q?W3jhTfkAmuDYda0QFZYxueKAlBqKFPb7mN2Oot8m48EnAiaZrG5GCrAYoWxF?=
 =?us-ascii?Q?KqJLwxxUhBYB7sk4V1b4Dgn9pjWyB4KsbnOlkKhgm+/raF9FBInjXKs8IPj5?=
 =?us-ascii?Q?46cO/dWDCDXuh6HZjW2ZZKty8JWSMXWvSJs+xW5UK6138gsl8Tfu43W9Ou98?=
 =?us-ascii?Q?Qq4LAfzrM+0XtQcPI5APuVMS41kIeowiCH6mZ2FUWmPdqscbv5oHY8U8lOmp?=
 =?us-ascii?Q?4XJdn0cDn19FTOy1oAg9GBbyBwy/nL/7n86Ba5sz4Pj+0vsaYGKlg3yUO3r2?=
 =?us-ascii?Q?MTB9KKDuwSNNpU62HfMQBbDEiGbFg+OgkgQRBiRUk0RgJFcV3PhWGHk3sAM3?=
 =?us-ascii?Q?nyff/xm7sxSQ9qW80YtVQq/M/DsFh+gSpfBpt8TNSQGPcpC/eeaooFDS/Yp4?=
 =?us-ascii?Q?VvUXSzuCE+hDRGFfa9o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e634c2a-b1bd-4d0d-557f-08dc7a7f8dfe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 16:52:24.2552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ccOMmMXrz1k3sfFWeLRVCmE5zfRRetM23O9G3QIuhLQOVMaLpJbvymhW21YUQlp8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7094

On Wed, May 22, 2024 at 08:43:18AM -0600, Alex Williamson wrote:

> But I think this also means that regardless of virtualizing
> PCI_EXP_DEVCTL_NOSNOOP_EN, there will be momentary gaps around device
> resets where a device could legitimately perform no-snoop
> transactions.

Isn't memory enable turned off after FLR? If not do we have to make it
off before doing FLR?

I'm not sure how a no-snoop could leak out around FLR?

Jason

