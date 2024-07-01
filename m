Return-Path: <kvm+bounces-20793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9698291DEAF
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 14:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FB491F23EC4
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80964147C60;
	Mon,  1 Jul 2024 12:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IXwhgqs/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785CC56B72;
	Mon,  1 Jul 2024 12:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719835411; cv=fail; b=lEXMr6hsKAAB3bSirFf1hFox+rzc3nyN9nGF27r90YJK0Ok1xQ9NOl/bF7gm4Oz5fJHqYqTv30TCHlPkKbhALNLTQ9gIK1qCrxCcReRQU3W8fhc33Riyb7lMHb815e80FJxljnAtJ4pqNAATEVuzW0rzq7+S4W/jPwzChkRYpCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719835411; c=relaxed/simple;
	bh=nmTets7yJAz5q8OBXtwxAHeMRGrn/B33q3WkxlZFxAw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gr92U7uNAsk8VUL13r4168sU5Z7br41+LHBSr+VkQnT8D/GKsHfg/NX/FUhyOpjIBox+iPU5RylOl9JzNVl4QhB8d6Cbfj8eru7FId+VSEX+twkq0DOw/9KYhIjk82zJ62J9VZ6rpsjwQqZNO2TxeKcUinzmrRwK0SbfBlidqq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IXwhgqs/; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719835409; x=1751371409;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nmTets7yJAz5q8OBXtwxAHeMRGrn/B33q3WkxlZFxAw=;
  b=IXwhgqs/aWct8+OJNhIjpboEp8wHGHcaqVP7wnNXz6cD82RrWeBCaxlr
   wg7JMmyKxZfJOARc2sa1ENGFGjAwoPPbOkP4+ulKznx4v2n3xas+Zuayv
   KtP9Lvwmi7EfCnViI+iI7NWiJgomI8dFzmLVj4/2KrNZAd5VoOkbwJPKr
   MV93QH+aPoEbaLs60+YsEIEy3//clQFvbjZT1IX5UTglmbbdCMsv8fs2M
   HwTo5ockBHJvohLNePCZjI7d2LXWGBa6HIEsXFgV7X6Yu0CKPyh68bFHE
   3vpTDvRxDh2HVban3w2OgmiLk2faFCDtgag0HUkpmn4upJf12IKhttJ4q
   A==;
X-CSE-ConnectionGUID: bsqyPcmPTRquSZp0PpVCTg==
X-CSE-MsgGUID: 5FhvUICJTBq7cY2GAzXMkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="19853405"
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="19853405"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 05:03:27 -0700
X-CSE-ConnectionGUID: ZKFV5BL8QKuVrlVAVGSFeA==
X-CSE-MsgGUID: L1irhAyzQbej/oZiDl3BdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="50100974"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 05:03:26 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 05:03:26 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 05:03:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 05:03:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 05:03:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdCd5msL1YlD9ewCW05HQxqTFobZr0G7DXLjvSKDyHMJ6cGfN73UoNN1pg83VllPd40z0nH0sKVMSfnhKNhQlogCtpLDtj9lK5+5RxdeZnF7TLWEzKp2k/k8NSFRw6LunTojfkNSFTrfXn8VJ/XJa9JO+VKJiqaDCqd/EAa0sVzZoRTCs8ZBHyzoJUqerVbsCHIOhveIhObWcQEmYUV7yBB9fj/aOIYfOfAPo94Fw3ev0eaCmBXgb2/fkw3il0cuos6CXkjb71N7dsgW9ueotCba7CwEyllwvSuHGGtm8DU66p79HNQlXoU4NqtWKZ2jP+f73IXTYfYuXM75wEYf9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leeHpyiPe4hdbqWViVRfi+owcUygsi2v1bi8bB+2ivQ=;
 b=YzGH08ALEIqhLZg63nmxxHimftCOA+Nmc1gL4GRmWJcYFucN4LU1A8ZXU/VZFGPbMIyuEEXjTQYVIUi12b/518bpFf9S3xEHjLaLu9AYa3YednAfb866Fh0ClbpLQgKBbFkrRHxrRLCZMdsx1j74eDiHFwPKuVe1SH7clfUp+h9ll4exM90yPHCklux4AZNSHlS2xwLY7cEs05asdQtp5n0JEyWW8WnaDyAGjOHBgnevapIFQicyICOROsZ2zhAX+yWzRNaI5weIMS6RrMpN3BVRYWNR2PwlTGpRloOSOCig8UPaGwO5OdhB2MfyUtW4XjB/AsyzflQ4a/bPpxl/KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7515.namprd11.prod.outlook.com (2603:10b6:510:278::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7719.29; Mon, 1 Jul 2024 12:03:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7719.029; Mon, 1 Jul 2024
 12:03:20 +0000
Date: Mon, 1 Jul 2024 20:02:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
Subject: Re: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
Message-ID: <ZoKavalggv/iXCPB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240628151845.22166-1-yan.y.zhao@intel.com>
 <BN9PR11MB5276059EAED001D833949DF88CD32@BN9PR11MB5276.namprd11.prod.outlook.com>
 <fddd5230-28ac-463b-8536-ee953072d973@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fddd5230-28ac-463b-8536-ee953072d973@intel.com>
X-ClientProxiedBy: SG2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:3:17::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: 4263aba3-1f51-47a1-28ab-08dc99c5ccd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fFOB8e0DPoXdgJIqi8JhavaVNEJAEpr2Dglk9wSCKEU+U72PcZij3vaA20t2?=
 =?us-ascii?Q?tkNxurLHBz8lbIreUzkrJhGd9Mwu6U7LOSZs/E+hKBxMFD9tQAXeP4Yx9ynI?=
 =?us-ascii?Q?azkAsIgjZx7YQd65bhW8uAsTJYhT54gJBnfw7o6A3TGje3SRDSS9vzDAL3dZ?=
 =?us-ascii?Q?l/4Lgqm0h887KLqy2q/iRPjPSXEt7ZBJtL527Rc52eSFiYS+/X3x9wLZS/Dd?=
 =?us-ascii?Q?El191k1vuFR8JODVlszGjP9PtFQnB8pGhoHg3AsRVK9IYfXBVNG7Pdli9C8U?=
 =?us-ascii?Q?LX/gG6xmYsUjWuAVdIHGKq+U/f55CGJ4mZ9Tf+l2P3cJBnZtFabvASuNf1xv?=
 =?us-ascii?Q?rvFpq32gSiRvLd8zfBrYQg54Rl5LkBIey9kMxF+9yu3BaMganSF9NHunYoal?=
 =?us-ascii?Q?E/fTYKl/vjez6tiYmAjjxCoW7q/hMZ0Ko7QnuxfCdOIc4UhVEu04r+FOZOel?=
 =?us-ascii?Q?2qzEOusARkSKE2K38HXtQZ69o0Fqhmk7WUieEHjLJa0b7fcHOt2Qw2VTyXMQ?=
 =?us-ascii?Q?EOj1CEDIsaYk1nUI2QvdAhxcMIVtiFPt1jEOHNBjGd61PkR7rLptkavXS/Yx?=
 =?us-ascii?Q?b3v8F+QpdQR1+2U92BL29HX48mcDbI1d41/tyqSRfwRpj6cUTPZ9xbCxX+cZ?=
 =?us-ascii?Q?hQ6fYOezUsYtZohL71+tF37eLdblClCTY0RRGMPYy1sE4nCJdDYGLM94j8bJ?=
 =?us-ascii?Q?LWY+O7UCk+njzuXYWjp+F5oPf3NXc8LiVwNXMH4wr7O6L3+Bd1CkivTnwZ0B?=
 =?us-ascii?Q?AuspFYdOjWLr78yv4ikGaD3D8t5vHHXGw5PniXfZdip7OGtddYo3yFfmYzx1?=
 =?us-ascii?Q?9MK/ruSP41MV2tY5BmaFEJeFUZLvqOh2g6KJ7HISta38KwjUA93qEhwT6Cze?=
 =?us-ascii?Q?P2FdXUX/FXMpLFXDS/aJpzq845Co2/VadR/CIHR5+4v5onerUOs7TGqge5rR?=
 =?us-ascii?Q?ye9BcfASluXl/O6ZdWpNjCCs3L1ItERQTRO7auneWcZ/tkCEscr3F9VOJvyC?=
 =?us-ascii?Q?pMOtfCbo8RcOk8ot7xg8GKpynqiFxNtAgGb64GnF7digEzK1dEvON+HA+EGL?=
 =?us-ascii?Q?P3YUq34VjK6ZStSLrfoaD48azrVOYBqih3I+Kx1p6+1rU6NQBfOriBobP3bK?=
 =?us-ascii?Q?eN9eugpBwNzAfERdjJzvnpP/tZqu+/kDlKC1EjcxLEdHV3XuX2ytaK6X3WuP?=
 =?us-ascii?Q?fkvw3nEf/6fNHj1CQqcxxUfvTjk10+qGhI/wyvwkOJ6m5BF5mNUjMqkTlYTA?=
 =?us-ascii?Q?RBYzp9ySEgzsx8H5Vf26wKqmfiyWBuz4f55xRkxo25/tZgG4pV4VhA0gA7dL?=
 =?us-ascii?Q?dCR+CzezbhVBhz5R/yEnzjpBiHVamWqM9VNlg5/7P+9BVg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mJK25Y+1sDtu3t1ZdKsK8LEkuRIm7qgL+Z/Rs8R2WiCga7X4ggKvshZvK6BT?=
 =?us-ascii?Q?j8E7f87yH5Fa15VF3gdt4Y8lSQNvEeMJKEGGwvbFls77Jemq2+C8nOcOZtpS?=
 =?us-ascii?Q?MX+W7VaoNx1v6x+0Jhe71fgVqil8hIbbHy/oex4iduhChn/mtjxHYPCIHSrI?=
 =?us-ascii?Q?gVt/WK8RoZmsi5HSaWZrhTEaQcM+p2+k5Ye5tvaTe5yZ9mRkrH2dZV1Vss0F?=
 =?us-ascii?Q?xhZLeFtip/+2D7SzMCM/g38Iz6QmLZXoKJZFuNZUZkgVVe+/JIwEP8MakcT4?=
 =?us-ascii?Q?1zeBb2XZ9TxD6Yp/zrwYl/+szbs/5sywgGlWaSOdGLzQKYfQ29X4Ueteymd6?=
 =?us-ascii?Q?DkwARO3Yby4npVUCGupAk5HlEwtN/tFXMoU1deVYXDkSHbpOD5ZQIJZifxUs?=
 =?us-ascii?Q?7fQPyuQXjUDoKGmEQTJQS28dqbPwFeB9kT5qVPIEyA3fsTevrLT7JrxBVO92?=
 =?us-ascii?Q?xyGgbv03PFuOlQUEmF4t3mpOMi5tA3W7i0l/EIMvFiVAkTiR2LByePG7CRpy?=
 =?us-ascii?Q?vXHFkTa1sXIJ6czOPvMfztTjC62K4D10mwsqZdpsiHD1AdLOThQwwQt0oguT?=
 =?us-ascii?Q?NWdq+34Yh3Jn1/d65rCG1o4KcrB7saM3eYQmpLEDyuGWQlzdGG2ruTk6riBK?=
 =?us-ascii?Q?4pPACyO9ZewF0s/wGQuIlyHP2A44hQu7oV38DL61SO4ZO2thkDSh4tH++Djh?=
 =?us-ascii?Q?2hkdAWxuVFpp4Jr77xPepSMtnz9YpvO/kWpdPw9abdhCUDQ3dtjobEqpUZQe?=
 =?us-ascii?Q?v1ANmvQu01DFp7gRN+H7Qyw8ibB46ZPbgZxJ6Oq78iDzDGagQIPW9hxaLnpx?=
 =?us-ascii?Q?hqryCV2aO1viH4fzuF/1ujOo2QFSXe2+RrOhNTs8tYVsNt+xZot2tZ2pKDao?=
 =?us-ascii?Q?uUxwCWHPUBpsaw4ZWdKutGEAnjwTz8K4iFoInVrGzCX4+p1akw8k5TduWqYa?=
 =?us-ascii?Q?oqskOYls77hfCRvgfLy/TvX8GEJqQT6eGBahuo1Z0kuHOb1UJVZVQ0azfSJw?=
 =?us-ascii?Q?Vssq5TR019nAa0b4RIQKkN2JaqI2kyS5drt/Y8qvTkHGYgyRwCPXDd9av+6z?=
 =?us-ascii?Q?cgHg0T7rFDiol8J5y3qqplXRsT2IuzFPJo0AdPzv2KIMt6pYRIWZyVUwDa3B?=
 =?us-ascii?Q?d/01zu8r4devUlveBUouQ/60PLIjMeqU/TDI1pNIsQkFZTo+8vfAWmvZJOz7?=
 =?us-ascii?Q?NFqc4qJpN9G99055NM/gEuIJonp/tkwzecQk+oxvpn2+2UHOIlpgya+HaJNu?=
 =?us-ascii?Q?IEIRdRjw8T4k4rLgyId8NFbshCcBtf+FUXOiEYgOzixzRxn9irQUMfhIo5xJ?=
 =?us-ascii?Q?LLa9iI08GkABMEJRqpwnDEV81Q4TNYFFcVnbsdCJVspm2Bmx/aA+immbAkZK?=
 =?us-ascii?Q?+GN+8W7sfumPqfkww944s4yediedGc0qZdfqlQzuhl08Gt+o1SkVn+z8Ect8?=
 =?us-ascii?Q?tCpY8YXZUJPowJqVVSuJs1TSuSSphUak3yUO8IUj0D16eDvZZvbpaO6ogM5v?=
 =?us-ascii?Q?LM59dpGrio3DXUFIrgkYc0jx6MHnruqo1ANyqivmLF+64wBZI0CXpQAXsdWu?=
 =?us-ascii?Q?70c33B5sSSemI3BduzzlZsg8m7G+Ru2yLJfV18Nc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4263aba3-1f51-47a1-28ab-08dc99c5ccd8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 12:03:20.5639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQKLOsKwbUc0pzZsSVPFJNHnDT6RfnqaeJo30enGAHbaohZoX66IKIOdJv3iqg4UV3EHB97vFMXPeLnsjnC2Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7515
X-OriginatorOrg: intel.com

On Mon, Jul 01, 2024 at 06:30:05PM +0800, Yi Liu wrote:
> On 2024/7/1 16:43, Tian, Kevin wrote:
> > > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > > Sent: Friday, June 28, 2024 11:19 PM
> > > 
> > > In the device cdev path, adjust the handling of the KVM reference count to
> > > only increment with the first vfio_df_open() and decrement after the final
> > > vfio_df_close(). This change addresses a KVM reference leak that occurs
> > > when a device cdev file is opened multiple times and attempts to bind to
> > > iommufd repeatedly.
> > > 
> > > Currently, vfio_df_get_kvm_safe() is invoked prior to each vfio_df_open()
> > > in the cdev path during iommufd binding. The corresponding
> > > vfio_device_put_kvm() is executed either when iommufd is unbound or if an
> > > error occurs during the binding process.
> > > 
> > > However, issues arise when a device binds to iommufd more than once. The
> > > second vfio_df_open() will fail during iommufd binding, and
> > > vfio_device_put_kvm() will be triggered, setting device->kvm to NULL.
> > > Consequently, when iommufd is unbound from the first successfully bound
> > > device, vfio_device_put_kvm() becomes ineffective, leading to a leak in the
> > > KVM reference count.
> > 
> > To be accurate this happens only when two binds are issued via different
> > fds otherwise below check will happen earlier when two binds are in a
> > same fd:
> > 
> > 	/* one device cannot be bound twice */
> > 	if (df->access_granted) {
> > 		ret = -EINVAL;
> > 		goto out_unlock;
> > 	}
> 
> yes
> 
> > > 
> > > Below is the calltrace that will be produced in this scenario when the KVM
> > > module is unloaded afterwards, reporting "BUG kvm_vcpu (Tainted: G S):
> > > Objects remaining in kvm_vcpu on __kmem_cache_shutdown()".
> > > 
> > > Call Trace:
> > >   <TASK>
> > >   dump_stack_lvl+0x80/0xc0
> > >   slab_err+0xb0/0xf0
> > >   ? __kmem_cache_shutdown+0xc1/0x4e0
> > >   ? rcu_is_watching+0x11/0x50
> > >   ? lock_acquired+0x144/0x3c0
> > >   __kmem_cache_shutdown+0x1b7/0x4e0
> > >   kmem_cache_destroy+0xa6/0x260
> > >   kvm_exit+0x80/0xc0 [kvm]
> > >   vmx_exit+0xe/0x20 [kvm_intel]
> > >   __x64_sys_delete_module+0x143/0x250
> > >   ? ktime_get_coarse_real_ts64+0xd3/0xe0
> > >   ? syscall_trace_enter+0x143/0x210
> > >   do_syscall_64+0x6f/0x140
> > >   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > 
> > > Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >   drivers/vfio/device_cdev.c | 13 +++++++++----
> > >   1 file changed, 9 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > > index bb1817bd4ff3..3b85d01d1b27 100644
> > > --- a/drivers/vfio/device_cdev.c
> > > +++ b/drivers/vfio/device_cdev.c
> > > @@ -65,6 +65,7 @@ long vfio_df_ioctl_bind_iommufd(struct
> > > vfio_device_file *df,
> > >   {
> > >   	struct vfio_device *device = df->device;
> > >   	struct vfio_device_bind_iommufd bind;
> > > +	bool put_kvm = false;
> > >   	unsigned long minsz;
> > >   	int ret;
> > > 
> > > @@ -101,12 +102,15 @@ long vfio_df_ioctl_bind_iommufd(struct
> > > vfio_device_file *df,
> > >   	}
> > > 
> > >   	/*
> > > -	 * Before the device open, get the KVM pointer currently
> > > +	 * Before the device's first open, get the KVM pointer currently
> > >   	 * associated with the device file (if there is) and obtain
> > > -	 * a reference.  This reference is held until device closed.
> > > +	 * a reference.  This reference is held until device's last closed.
> > >   	 * Save the pointer in the device for use by drivers.
> > >   	 */
> > > -	vfio_df_get_kvm_safe(df);
> > > +	if (device->open_count == 0) {
> > > +		vfio_df_get_kvm_safe(df);
> > > +		put_kvm = true;
> > > +	}
> > > 
> > >   	ret = vfio_df_open(df);
> > >   	if (ret)
> > > @@ -129,7 +133,8 @@ long vfio_df_ioctl_bind_iommufd(struct
> > > vfio_device_file *df,
> > >   out_close_device:
> > >   	vfio_df_close(df);
> > >   out_put_kvm:
> > > -	vfio_device_put_kvm(device);
> > > +	if (put_kvm)
> > > +		vfio_device_put_kvm(device);
> > >   	iommufd_ctx_put(df->iommufd);
> > >   	df->iommufd = NULL;
> > >   out_unlock:
> > > 
> > 
> > what about extending vfio_df_open() to unify the get/put_kvm()
> > and open_count trick in one place?
> > 
> > int vfio_df_open(struct vfio_device_file *df, struct kvm *kvm,
> > 	spinlock_t *kvm_ref_lock)
> > {
> 
> this should work. But need a comment to note why need pass in both kvm
> and kvm_ref_lock given df has both of them. :)
So why to pass them?

What about making vfio_device_group_get_kvm_safe() or vfio_df_get_kvm_safe()
not static and calling one of them in vfio_df_open() according to the df->group
?

> 
> > 	struct vfio_device *device = df->device;
> > 	int ret = 0;
> > 	
> > 	lockdep_assert_held(&device->dev_set->lock);
> > 
> > 	if (device->open_count == 0) {
> > 		spin_lock(kvm_ref_lock);
> > 		vfio_device_get_kvm_safe(device, kvm);
> > 		spin_unlock(kvm_ref_lock);
> > 	}
> 
> perhaps it can be put in the "if (device->open_count == 1)" branch, just
> before invoking vfio_df_device_first_open().
What about just moving the get/put_kvm into vfio_df_device_first_open()?

> > 
> > 	/*
> > 	 * Only the group path allows the device to be opened multiple
> > 	 * times.  The device cdev path doesn't have a secure way for it.
> > 	 */
> > 	if (device->open_count != 0 && !df->group)
> > 		return -EINVAL;
> > 
> > 	device->open_count++;
> > 	if (device->open_count == 1) {
> > 		ret = vfio_df_device_first_open(df);
> > 		if (ret)
> > 			device->open_count--;
> > 	}
> > 
> > 	if (ret)
> > 		vfio_device_put_kvm(device);
> > 	return ret;
> > }
> > 
> > void vfio_df_close(struct vfio_device_file *df)
> > {
> >   	struct vfio_device *device = df->device;
> > 
> > 	lockdep_assert_held(&device->dev_set->lock);
> > 
> > 	vfio_assert_device_open(device);
> > 	if (device->open_count == 1) {
> > 		vfio_df_device_last_close(df);
> > 		vfio_device_put_kvm(device);
> > 	}
> > 	device->open_count--;
> > }
> 
> -- 
> Regards,
> Yi Liu

