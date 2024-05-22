Return-Path: <kvm+bounces-17917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4D68CB9D4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 05:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6077D1C215FC
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8078274BE0;
	Wed, 22 May 2024 03:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jTOS1oIR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3784056773;
	Wed, 22 May 2024 03:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348881; cv=fail; b=OoxQ7p566KLSsWGw+ISB1QkD2UkPXJvYlymyTEmR1Dp8aIuhyU06Cpt+8CAiRHVRgdnPWwBdNoIwQpyiSM5hXR/zLdUzlz6/2TvmSlzBn7EC27owB2Tj9nhbvq1CfBaWxhsah9U5bRBI6e59mqiGyxr43t5xGCH617rouNYoEMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348881; c=relaxed/simple;
	bh=rq198IPZUXaY7CEaJMW0J93jzd3IJrf/NGJ0c8kBmr0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LI1UnS+DdryRQRTRfHAx5JfSyHygQWSqdeeVHBlYPQgeibkbPVDt4JP6JEjE6tCIZ6zkrMaZLjdNX94Lc/3dHtOFBH8KDiv1xZv8uYUwRmmtooGqXvgy4YCwemR7bge664aOLom9yS0Wva2qXnSHF26Ym0+572f0BudaKJ0fKYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jTOS1oIR; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716348880; x=1747884880;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=rq198IPZUXaY7CEaJMW0J93jzd3IJrf/NGJ0c8kBmr0=;
  b=jTOS1oIRJEq1P/N4F1TTLYX9uf4DoTdNPhUxY/NRXQrtH2ra71Rl8fIX
   68cNGShZE79LwOxKGBz1vrcKo4x9Zbn8PgZ+VpZWRdhfscGiVV9oKgpIR
   0yFG339bscl//dcvOKBSBi09j9gmk9iHC4sIFdZL6Rb4rjmIQLGUyDDhp
   ZKkrhp4D2R/nmwBz+qeN/a+qqIs0+nd9rs8X7XBE6coBT0lxnvf+l0dHX
   j/fzaPYArb+O+HC6F8y3lk+lIht0Ck2bLwNHanPUtZPTFxS6zA1LIHPe4
   PmVsJtz00D0ZOWq0d2pKiQO40QQqQ1F3rDQwlA/d5/VFzC0Qw3Wt/fkTn
   g==;
X-CSE-ConnectionGUID: ab812RC4Qj6eN6CdjufDTw==
X-CSE-MsgGUID: TB3oBnBSQAqpH7n9aa67UA==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12750718"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12750718"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 20:34:39 -0700
X-CSE-ConnectionGUID: 8c58zWI9RQ6/3tFCPq7nZw==
X-CSE-MsgGUID: 7VdB/eeLSNS6QtrcBIpfww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33269918"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 20:34:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 20:34:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 20:34:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 20:34:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNl1KflV4cnNl4nsGX36Jq7HIQ5770gMRJOhzLq3MJKjlNEVlzquw9sKTljyVMoW1YfBqB6h6Swb+L0+HZiWzGrI6+cKoczICYd2tkWZ3D/YzuLCK6vgdl9F6Fbw8m2OZTyt3sERLr9qL2DQsZ6dbnvAPbxOH34U9iqDx+etHSX2ZV4hFWiJfnm+Ut4rSh1ph0PYA24KEhPs52UCm3NRMCz+qYqiMYFWq1nVLOC9Cx5P4PBdt0cVAonQ3PDZC2TWbBblzi5Eud529gHKcABCB6tNqnpGv9jpNc5AcutqahWsrZ3GuFtqdG62BOj1S2J26hszFQva96sziWRVjt/GcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TulC0dogpJD6i9SSzVs2C1ENKcFymif08S5+7dZMOqE=;
 b=Zbaw1Ux8o0IVNjhw9agsO6qNHl0a/rUOcHwWAVpf+XdiuiAkeNoDERfEaCU16XL2OGJuoVF7+DBt1Y5KpUyHjbNv1fRSp/NJcgwr4buHhOHyAqEZC99OdKrL9X3XbdUDtG6hoIYtMBt2EKq3yOAIBYl6a++1zCygUCaspsL6ZS1nZrZztYxAmkacWCs6nkmwqG/zfvcTm51bX90qY7bmHQ7j+ZoTngtO7s6CQmYGdPskT5i9GUS8s/5LDHL2+hpSdNPrkkWlEMjuw7/c4g+i9cRdE5EPIVV6b4Oe2/+PdzN4ufMZzX+nSIwEjOf1XkK7dSTR3bCWGx0z/2IMumkkXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7331.namprd11.prod.outlook.com (2603:10b6:208:435::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 03:34:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.030; Wed, 22 May 2024
 03:34:35 +0000
Date: Wed, 22 May 2024 11:33:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <Zk1nleN3kvHTbiov@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240521121945.7f144230.alex.williamson@redhat.com>
X-ClientProxiedBy: KL1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:820:c::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7331:EE_
X-MS-Office365-Filtering-Correlation-Id: e835fd18-f9ce-431f-921a-08dc7a1019a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ySihpLievCuy15uXLRpWcOQU26nRTWGKCPWkrAcU+AnH68kLZY1zMHUzaVyn?=
 =?us-ascii?Q?dy0Agz+aq4aSnVfTHLpscyTnVOnKDvVdXk/8ufUDk2TvjYcsTuSMS0J+gq+6?=
 =?us-ascii?Q?5yDqBqQIcqUgsJBFy6RPmkFXuKxSJyfQ8eVSgEBEHOjDJ5h1iMzWCKfOYz23?=
 =?us-ascii?Q?7/pAfd51LQ/dyf7JtSyy97heLA6VzGMeDwhu58pPbe74amix8p9ShTWVmYqp?=
 =?us-ascii?Q?QWciMGagXrkTIYAbvmv5btHF0ZHoO4le/6JlyewKnKRTXld+Zdz31ELiOLdg?=
 =?us-ascii?Q?0rYbMj3oRAU4nNxVxbrrX/5LNfBd5vAr+9yim0M63jCb0grUpDoib5Ol3DPH?=
 =?us-ascii?Q?JsENTG6A+fJYTziauXMLQVUrFSluFo8Nvjbq3UTPRkk1tHl2UFtK+YPjxqw7?=
 =?us-ascii?Q?OUt4bnIunm7tQlUWirgH/vG9XADeokdk6mcPBnQH5rqo+KfS5wvCWY9oEZBw?=
 =?us-ascii?Q?loSXFY23HxAVta4ecLNwRkRo+b4O/K8CuImqgduqctwGLXgqbB3XY36eBDr9?=
 =?us-ascii?Q?j8Jwb1rcTY6En4e9ZspSZtWF4V6EXIvSjA0pmMH+dV5F1sHn4t4+1kTBPTSX?=
 =?us-ascii?Q?3QEWWdj5dDp45Tdv4sTIDFS6TzDn2H6FzTS7FhUGEuQPzW313Ol/eccgB7dx?=
 =?us-ascii?Q?sRBRN72Mmm/UVDB7+P3LBhXOEYJdd0FtzV91/LBCOojRxrKftdv4h4jNqx59?=
 =?us-ascii?Q?cnfMBZQbwkAsepGop9LJj3+79QwriilYT8c5kZl43QyG+vp+tFAfiFdBo+dL?=
 =?us-ascii?Q?P7EDUq6f9NhKPWari9EVYm6J4lRvpPZWpD349FORAV+L85OsY8GKvBngEHL4?=
 =?us-ascii?Q?Q1FLGrLGB4UtPpdpjq3yVlQV6Cclw8b2qgW8gZr84zGIJJNCNi3CBqWymtHm?=
 =?us-ascii?Q?AmWUapwPaspNh8yVkgop5xhLdzaQpwbqQXG+qdRhTUgGKy5LK8FJ815aR7+m?=
 =?us-ascii?Q?I6kt4/xfNSGCCgAQ3yElv9BmFSEHO3HXDDT1V6su9+3cgvqDQ9DMBVVJ6UtI?=
 =?us-ascii?Q?4u98n3Luo57LY2Fx9U9nPQkrh7iXk5fcRBg5xRMNZXLDmzGSDH34IX6RRQLI?=
 =?us-ascii?Q?c4i/LfluHMnWwYMJYlrKTTVEw9ykP39vZZh41+bvxi8V1hlMxyu+7FwQltzk?=
 =?us-ascii?Q?MVQnwvuMb2UpyoE3SzMFD+pc+o9GpA8jEMVchuyta0e0IF6+J3CQnXyUfgH3?=
 =?us-ascii?Q?DJoGOAYhkSdp0e3y2zQe9gqEnZbQ0IQG0WeV3acVb9pqhY4Dy1GLIJBecUSh?=
 =?us-ascii?Q?S627/zdqedbeCI0N0ao7jS+QqHfl+F8WLH1zHd9j1w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ukrdpM5euWZuBwN9GbF/ymmqk0ieyyVB+f8zsbZRIJ4ToAMlyVuZlq087W+F?=
 =?us-ascii?Q?BLj60nKoVqmTHcQWsR3wvZml7NAdY6V9jc2x/pU7gdUPe5CeFXR28jPFBdhB?=
 =?us-ascii?Q?CXl7wk4MNCi5n+T8+HLIKTtcoi3XLl9jHfPl+JbTug2USPUliPRHaK1S+Tvp?=
 =?us-ascii?Q?JWUrc7TuBozoCjT8taY19/wAAAuYvvHSYKUez06TcGVP6wOP2jafurJ8mnxc?=
 =?us-ascii?Q?K3jpv5AzJGCA3jiWSNxEJMge4/CvYcyCnmQu8JWbqrgl/+yZFiT8BbjVjF2t?=
 =?us-ascii?Q?2AnpxF/B9KFNUvkAF/vAgtsf1m78PdquGYZ/n+eQxrNFrYBY5LUvnOIPpHEA?=
 =?us-ascii?Q?SEDjYXpMmzW+6Lm6MpTqdtSrOOruoOm2nqbHLsk8WXCUzpFcC0Fz5v/09ft3?=
 =?us-ascii?Q?SiEI4Ral3fBqDm0ciUFDhP9rXcCDn2klOEI4zIz4LAEv6IfhtzS6x7Ot/yRg?=
 =?us-ascii?Q?nNRJWF0/wcDDvvw1oL0v8uBRPnnicWWuv+rM88jRZ89bV1EpcScwspzenL6r?=
 =?us-ascii?Q?aGPPpi8zZf+vlG5hvLGkYReNRnnBXkSKtw78v0goVT1el/EZqVPM3WMosIwX?=
 =?us-ascii?Q?xSPyiKXovvG5AemjM4xv++FZWHl4AmaW5euShN+RuuLQZLQuuPe6B0WkytPB?=
 =?us-ascii?Q?QsWJqOpEwrYBrnu4yZNZa0MHpjvnYz6Q3ems/QpMTJse1aeefEeU4MtTBqvj?=
 =?us-ascii?Q?pbe2r+ySIlrWL6vgT+cO22S1wRDnR7rtHOxqkg+WnA98haheN+6/SmH3CG3/?=
 =?us-ascii?Q?4gzUMaJyxdX4VtWMMTK/8vGf6LZBFtPILsmqZTlF30yhoUxCoX5DLmi/BMGM?=
 =?us-ascii?Q?nv2ONHjXww9hxpWACnqH5Oqi7LEW66OUqSuVp0sSjez6YVi65mgoX1Lrf3qV?=
 =?us-ascii?Q?Sn3+krC4aYFeNM0CHaVViUkyi42V8Pns1rqtmy2qev3H8QPk5CQDtT5gCVNF?=
 =?us-ascii?Q?ZlkhmN++LPictcGpbUClrS976DQPE0GT8yvr5Jf2Mbeb3xAj0TDLpNv+DDb8?=
 =?us-ascii?Q?7QUon94a8rxJz1SjO/ksCj1fteLohM2xEVX0uFxK+9FnX7+UFCDLY1HAX+gs?=
 =?us-ascii?Q?eLylc3aJ1eMq4Z4k2PZBZuNWL1EATiNh6yyz8K6/8BfuUOPNF99AmcuZgc1o?=
 =?us-ascii?Q?ymeLcQG1dMxCkgx22SPSmmQN5u2QCBeaooQriHNyDpAKs/pgi6CM203coKWs?=
 =?us-ascii?Q?gFcRMqEaeszY99NFJCU9RmNLVAGnG7bEahAdInGK6uTINDYfNLmBOdz4uL1c?=
 =?us-ascii?Q?NMRF+D208BIJW+grPIWsvpIEGrze8gc6Ufq7iwfQnwpMOzW8vV/KahveGamR?=
 =?us-ascii?Q?tV1AZap6e4dl5yWxuqI1suOG6nx4q5UvIEwikAZp/2v2Lp5hxb6Kyd9hrb0P?=
 =?us-ascii?Q?u96EmfN746b7S4sDvTQAcZWyeeEz6dap7ga4abfyRC0dI+kfqgNdApIa4Pa3?=
 =?us-ascii?Q?tnk04eyrZJIe57IMenkjP/FehQIvwxu2kWc6TjmwpxFbmbE7B0ia4MmW19NI?=
 =?us-ascii?Q?M0lXuv64fx2Y6s5Dw/3Ohae1qBO/XP5mz9U7OvGu/Snc7bvTgYfdS34WgMcx?=
 =?us-ascii?Q?Ii4Jj258ktJRV3+UKeNePv5Hj/8D3wXANG+lL/zf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e835fd18-f9ce-431f-921a-08dc7a1019a1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 03:34:34.9331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 21lhu4mUq/9B4r1VFg+AOrEXByKi/HCGz40C8ik0rmQKgZZFEKaCKuIbeJ8gs4HjeUM0DGLHCOMsmSbjfASFXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7331
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 12:19:45PM -0600, Alex Williamson wrote:
> On Tue, 21 May 2024 13:34:00 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, May 21, 2024 at 10:21:23AM -0600, Alex Williamson wrote:
 
> Intel folks might be able to comment on the performance hit relative to
> iGPU assignment of denying the device the ability to use no-snoop
> transactions (assuming the device control bit is actually honored).
I don't have direct data for iGPU assignment. But I have a reference
data regarding to virtio GPU.

When backend GPU is iGPU for a virtio GPU, follow non-coherent path could
increase performance up to 20%+ for some platforms.

> The latency of flushing caches on touching no-snoop enable might be
> prohibitive in the latter case.  Thanks,

