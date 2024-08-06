Return-Path: <kvm+bounces-23373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 995AE949249
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 15:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 171D91F27102
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4912F201242;
	Tue,  6 Aug 2024 13:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fGLGL3rW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E792B1D47C5
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722952505; cv=fail; b=OR4oY9HgO4phTDNI+vjGTirn+tfkiR2+yEy+ENvSiPmVpIxxRnHiWX+NdZRy9SGI5UQGYYpA+24MhfesaXdN5oxmsZbsh2W7Eg+5GojN4KxQirnsxm69Nad5MdwJbu2/TTZsl6YcAF4bznlE3EYYtqjSklC5qgZW3kWa4zEi4r8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722952505; c=relaxed/simple;
	bh=PgTrdWGBdId6Zkldrh9mVG0FBRkAnhKVsgAXzXXF9co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dOelFmrxYrdod6ujrzzx2tP89ZaS0eu8N7mxgfwzbqLyUwb+zds/KMuyCXn5chmXGNE8fNg4Y/74E0QO2RvNCT16wcSITPOnifaxYQWgW4hrVOg80Mvk+FHYKp5ZCAUKKt3qEnKONM2gUMv0Jt/S73gP+Pou2nSe5KdrP9eQN3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fGLGL3rW; arc=fail smtp.client-ip=40.107.236.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhByoFoVthAiyMV4dVJe1eBnl0CvkP369bSM9fCVgwqoR/ifSKt0KnJlcT01MWdt2GSpUe55Wr7TRhDkSfqsr8ZfBifKLigFhbxDLe9+2vXE7RAHQgmpx+KDKGxs4mDkk6S0Z1WsvU00iqSRriS6/i93ulPnXccAOmu563bmzd/BWN3lpICFJi7mZVYEWusoyHl9urjZdPwLFjcwQDhOFbXbfBIF1vPWoJy/HhoEHHJQ3yBD4TOYO9rCX8xgk352MKiXCIEG8ZUhqNiKQHzk//WlxMtjB0D0ZozC1KG6d7kNsKBTkOMUzmeXrzwJJgT1XCcLdw9E6q+eVqbGCmwRbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrmGm/AsHPzMOT3JW1KgID6ZPOCL1XIRfDwSnq0xOZo=;
 b=aC1wPrrHqeGDKLOAmasYHXNtygAjqSc/LVvzlRVCqsaiq4Is0mqc1WPP3Oy2TQaSLAIB3ccxlxsxvruRlRu/MFXABqe+cFAqxnR9isUxswDBhbsn59Bm+IBJBUBmk6KsAFNjiV3NBEKqUZErS50K3HV+S5GsZlDD4DOif+9Tx0zMOYZSm4zKMV7Ffu4LEMSmA7W6Q8H1APRoGXroGmd1aVCg0ZvHkJ3sLVypdpSFMd1rOytnEJyaBtIak0xbgdyWCU3zbu4FcbF/TBUAWaocWdTA4ROQIlfxmCyeDAbBSY9EbAlSUwUObgBOfca0AWDGwkA6S6b970onPI7zapsSOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrmGm/AsHPzMOT3JW1KgID6ZPOCL1XIRfDwSnq0xOZo=;
 b=fGLGL3rW5oWBJZCLzFuQ81skDRz0d/O3ijJ0RjqCkFbzdQBBXCHG4kvv58jv5xjUcR74HJvPb0sfGvLyxFFPHuQCBswMzxm32Gb+Ch4XmCRAKZxXTqhv9Y2CFOG3pTZN7vUkjfnTz78SKlTJtZW8cTQrOh/xSQbweag32/aq9Cs3ipk0ZQXmtwKgnk+x7/Fk0fG2CKcR4Q39oc0nYnuqvh0Cr5SS77Q9n/x6RWRtMP24w/ysFCjIBI/ji3DR91cTaKOVyMznxsWJcFL2LGDrZJOlSOXvMoiohhBWZPg5HBveKeP21EoEdkkpN3jpuXX52Ysa5LAG8hEK5t22yW64TQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 13:55:00 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 13:55:00 +0000
Date: Tue, 6 Aug 2024 10:54:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <20240806135459.GL478300@nvidia.com>
References: <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731110436.7a569ce0.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:208:178::19) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DM6PR12MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: c8f5c13d-f107-4883-d591-08dcb61f5d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H+IBr4lQrE7hzq8bkEfe8po+EGYpfnfeOVGFtehHgpbIfiCR6XeD8/WL+FOH?=
 =?us-ascii?Q?rVj47Daj8sPIlpBbhtIJN+KisDX/d66HqMo4zgjti3MKllriYT8+PxHLQxnl?=
 =?us-ascii?Q?fCLdmK93bF2mAtjL5xrIN/FawGwRlIYBMDISndwinAIgbqmr83J/m1SKCyaF?=
 =?us-ascii?Q?BFPbUmwYZZAQIwLcHsmbIlPOR4pN47qIRfI25l7gsfDpHBWqYYmAwT0CI3Bs?=
 =?us-ascii?Q?0a+Nr3OGvnxs4Upv0MdueYbpC+7soBaTfojppcDU4oSiPJSZfuAadMFs8A8Z?=
 =?us-ascii?Q?il85bM+2ov67q05ur6rFUTH0zHzJEyYfGP7uPJvvkJbGL+UE3Ttiftwv0h7M?=
 =?us-ascii?Q?HNHNPjdQknTqRuHqPbQWZ+Q4fFo0sKkFMI4mNnK0t0D2x9Ot6r87fuqZUAo1?=
 =?us-ascii?Q?1O3PRY8A++ioXAEBqRx1XNuk9DRAidU2cyUnErXYpvWlkchZgS/0aSeQMwdI?=
 =?us-ascii?Q?xpsg7MhzmyfhMqWqHtX4G1qEGu80e9TGHCMhljq4W00H7zD07I1rW0aX1zJq?=
 =?us-ascii?Q?QKjqD7hdiIqlWKWGe/SDh5RXxI+Bt9Y8iROLcsLGIyBScxJGidxAKSncldCr?=
 =?us-ascii?Q?9XUtXljRJQkihkY4PTLSfxsOM4gyYoWrvuwRHc64AZkA17MKVL0KTvpnYQ5V?=
 =?us-ascii?Q?pxMqQVBc23isTBal6PfkXrdD6G9su9clRVOuC/6cHK1tL/xwZ6y+BmTP474g?=
 =?us-ascii?Q?m+4GJOboTjta7qtamWQRsENwAQjrcN9mLpmgqIpp+2zNYdC5VWHltsz5DnM1?=
 =?us-ascii?Q?QBspdmpFeArjUTDEkjK4IboJ5cm0YXdoNoAIp9ru62mz5ty7X1ewsjZVglnE?=
 =?us-ascii?Q?feRg3vt5VBFFhb9rCHOEcEMorXRe9WUxd/KU/P6Yjo8kLl7K+8jyeMte9Sn1?=
 =?us-ascii?Q?NsadYzFXRjiGtB9UHS9x3D/bR/WlJt3GfCN0NCwsVX040Eedia+DP6CXv2zL?=
 =?us-ascii?Q?PuMap4okW3RDWIyxxWf7I35qQVmV6a3jpEAN+FmzncHj0ERyr6OXZIm9jv3/?=
 =?us-ascii?Q?Erd9ZCp795bn2HH8D7gnzd4rYStOVZWmAaFnK4aal7oMR6NgJRriTmjNBayi?=
 =?us-ascii?Q?6xqpdTFpR7kybhPlUzCXXxuk5DNToOqN395CIQeIuivD7mtS1A+9KWMWUjAE?=
 =?us-ascii?Q?b7ifeuuX8q0RU6WCsu9sHYrWS7ORNeODTyXqoXk/gQDyWpw2Mbn/GYkG5rU4?=
 =?us-ascii?Q?nFBA+ABI09qoOhr84Vcig4Xr05cAkwGqluU1NK3/3sB/7FfTZYLCe2LTaAIR?=
 =?us-ascii?Q?62uZkD2afYssJj8DBNvzlR+WCHBic+ktU3AUhTXxhz3XsQlbGjUOL17c4EoF?=
 =?us-ascii?Q?/DRArGSIko4NMPA73cnHmH40kWvqTVBtaniCE8qnnBRriw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?od4zaTjCOX1fklcIi0I8bUbactnrK8iovQZfiBdSuFKi/rwz0aJOlEdEFGbG?=
 =?us-ascii?Q?QA1S4oKkwv3JMkgfrrtl4Bm6V8sgLXWGDsIa2D5kF5TEgxycOb6RiawTmLhJ?=
 =?us-ascii?Q?v6YqpZAPRhVYarMh7eiijv2xAOk773zym+rQbLaN79yNBQp9s4w9NJf/5Vdx?=
 =?us-ascii?Q?dnZpv/WfBH1TdTXJg6oqPatbPRWOGfaN69GfUPVr0Colccxn80v6y78U14dt?=
 =?us-ascii?Q?OZjW/43ZsVLVG3u+IBAdBV/vNLcaj8ihxG0aeAefuDCAnhQx1uyXk2x89V8v?=
 =?us-ascii?Q?LkYBOhvOYDHFQJgAlX/DgDavNaTioT6K5jG80en0jtrL1qYyR+aR/wIKGS3z?=
 =?us-ascii?Q?2vVZ59oR+bNfi4azkuHeLqIApauQ5ER/dWx2jeZjEDXgGXsu97I4bfddkK+/?=
 =?us-ascii?Q?h5GcKRPAhar1ek2Kl04YdIsh5/EppcpKcUNh7BMqh+L65yLd8lBaorjAB1rI?=
 =?us-ascii?Q?nDsHLVIdvBYrExzBmBia+Ty7n4KpqscrKWJijTQ87nvsyn3r1Pv8nyg+2n7P?=
 =?us-ascii?Q?gDEWbSdzZ2GaJw6+iFUpioZK4WtuqdykOP+82x/5eT9HNRIURL6rk676xmoY?=
 =?us-ascii?Q?hwNFqzO1uUAK1cPc4t7+gr8Stwj+N5fU85pyBAB6v50W+auCwO3FitbERcBk?=
 =?us-ascii?Q?XxcdL1OPtX/wJuW6r3JFWKWulyeLoe7GD6VKYLHRfAA7Fw8ADMF94aPNtLGy?=
 =?us-ascii?Q?KOl/B5aS07zIjanRip0YXa6GC34FkVUfWSAVtbuODHiNP05V7NBlPIDYuqyL?=
 =?us-ascii?Q?XvsDuJdWjnX5LEsV8qkDaT1p8UOKLuLKmi3a0903lhZ12MbeV2dbL1Uj58Kr?=
 =?us-ascii?Q?/3iCNx4eLFKj1NMOlgxNLXPXhZ1ingxzIisvRTW1w20FJrJYs+d2rC51ec3d?=
 =?us-ascii?Q?sWbaOgDXK04t0qAkL7umqUWfTEnj/rXlKxdNZJB54wD4yKTY4D/qfN4REbeG?=
 =?us-ascii?Q?jo7ss+sKKGASoQQDGS1rT9QbVLDLw2BFA62mlFBNDpc9zsEI52vQF6rS76LL?=
 =?us-ascii?Q?G+FjMAnCisHxrI/QjHjnblhGNlnbOpb3Q04jop2alTVD69w3k/y6KHZ6y3Xd?=
 =?us-ascii?Q?gkM5CnCGfQULTYlEHbYlXK75P/rDLof1tA/1duoyARgpiXjWnPPCug6kzi7M?=
 =?us-ascii?Q?6JJgpvRr6eImnS8nr6VOwJOlc4Ledo9bhHQVrKJP78zUS/vTPrK0sZXSYz0p?=
 =?us-ascii?Q?7GYR4Kb7KtD2RoX7HeoaFFS0WG2mStupR77STwblQE8SCIm3ST4oO6Fs5nB6?=
 =?us-ascii?Q?tm2iuuRkgR60UJjnuAWJJMxkLWBB0pfzWIwOxQTFFIcWQIZwD18JXXle3jQ8?=
 =?us-ascii?Q?h4ikOUq0ttO3ZNuQMWtH28OIeVUkeLYBoTpvBLJMX3aID4232RZhWLJh5j4J?=
 =?us-ascii?Q?gUY1p6ldhkntxGgW3A4sxYIgOCz0xNY2XHX0B79AGs1F+eWD7reLjeoI4bqr?=
 =?us-ascii?Q?FDICyxzMczYK8g/TTRArg2Ql+46+wrrMTBx4k4JxMptditTne2XAeJ/VZjFu?=
 =?us-ascii?Q?fiKz0SgvyvezyqzpXYBe3qMfGGGk3tbxBjbBEIN28nanV4vyxhFtFMqCoPgk?=
 =?us-ascii?Q?YXpKqBf74azzY47jpb8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f5c13d-f107-4883-d591-08dcb61f5d0b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 13:55:00.3119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ormW+JXRFo46h//tV/UHwpUoluagiyf151spFjtl9h5Iawuw4xUiHZIrBqvHDsUu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4220

On Wed, Jul 31, 2024 at 11:04:36AM -0600, Alex Williamson wrote:

> I'd also be careful about command line parameters.  I think we require
> one for the vIOMMU to enable PASID support, but I'd prefer to avoid one
> on the vfio-pci device, instead simply enabling support when both the
> vIOMMU support is enabled and the device is detected to support it.
> Each command line option requires support in the upper level tools to
> enable it.

FWIW AMD seems to have an issue here where if they don't intend to use
PASID then they get a bunch more performance if they leave it turned
off. 

So cases like no vIOMMU, or a vIOMMU with no PASID capability, should
automatically tell the kernel to disable PASID support for the
device. These decisions needs to be made when the HWPT's are first
allocated.

Jason

