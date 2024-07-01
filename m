Return-Path: <kvm+bounces-20752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5F591D79B
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4206E1F21032
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 05:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EE63BBF5;
	Mon,  1 Jul 2024 05:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KrC80Qy7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893E94BAA6;
	Mon,  1 Jul 2024 05:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719812616; cv=fail; b=I1y9QxLYL83dVonzTBkFukmjZT3y48Q0rV2hjwHHCASRQQeo/FuGiZZxnDozpJ5lIEWdJQf7ZY7shQvpdwJK+HmCt0exBHpZ73Csry6n7PAWDBq7cuE3BWVHCbG8mBhDrd0MMHMBJrRqsEcRiqmI1a6sw+dLh/wqLCZecXswIBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719812616; c=relaxed/simple;
	bh=Zve1FlKBbNFbbnPGgLHO6MtQWWw4JWv1a8PkM+6MpOY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u/PV8xa3cbaqHHFm6qK/mCjY6j3/EtCOxMw+QFHQxj/sKneIaiNSf9TwuAqCeQfFyFcmMGk4ycgqaKyArypTVB4udHulpFMW35VP/JLUIyEHb8ZToVAKRviEiZAlxNPn4zM1rOyyTCJX1w0thOHU1cZ06QXEdpVbmccEyGU7HCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KrC80Qy7; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719812615; x=1751348615;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Zve1FlKBbNFbbnPGgLHO6MtQWWw4JWv1a8PkM+6MpOY=;
  b=KrC80Qy7I8Nc+/W4nVq3NN4iEJZuAuAFlq3mXLip+pX1SNelFDTC+k+B
   rDTI3DiePXMBEcPZYLSY7kCtek/Jn9bJDVzn0KkpC/89SY1F69N/muaBE
   ZyONEjZCxPGETePp5LRNuBCFr42uW56sguOF5ANuQFkC/hzdvY6KSttZA
   5lzW0cshqMiFb+PeDVi9y18emlTnb8R+q9HMyqJqJFxuQ2eWxhu5tsoL0
   2iB3iOguXG25XkdC3ynf6PRmoAZ9u3HVNS/GdZ7Xl+h66Xqcu0STStx9j
   Qi5LZLFa5w5GsZgzCHuqF6jw9xy07bprPa4KUT8MsBSD4HecHrtP3rfr2
   g==;
X-CSE-ConnectionGUID: bE8sGMX6QlWbeS1QP3EqOw==
X-CSE-MsgGUID: sqQoYviVTFGVdr052iDj1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="28314653"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="28314653"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2024 22:43:34 -0700
X-CSE-ConnectionGUID: RX2FHfapSvehrK7TXFHQzA==
X-CSE-MsgGUID: 8gqYZnQqTQ2ZgVaEhqNeCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="76579146"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jun 2024 22:43:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 22:43:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 22:43:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 30 Jun 2024 22:43:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 30 Jun 2024 22:43:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1V5vuk3+FHxy9cwx1oxFQJYDXJfOmJg2p6KsNK3kf6xGnnIiybgTSMNoFnZwtRRmzfOrlOgby3kU7LhwJCnXVMwzT0bXb8QugjueqNPuAw9BCe6Ctt6LodLtoZSwwUKPZJmMA4CwMOa0IAqYk3Jlk9U3lVVp86w9eAJramimB9DsPCx01tI1FcnjGAGKTv4kKZ+pmKThOvTUc7ypTufXA6Zmt60jVlL8lbYFayQX0uf7F5kbxR4HPQ8/gzaOZmN2Yta00Zzrn9E9T21U+2Bn51XlZG/V9PqKbpGyNhiE+pq4iwylDe6tJLe9L5z6Yhcn53Qh6ryqka/H8v4F5Vhfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/3cfXDdOH9jTmiXiD7U0KqNBU6aogtXZAihfduM3CA=;
 b=HQM2DySSwFKncewHoHVO3yC9oxOiCfO0rrjsbYqZZdn1VB8+FjF6JP5PCiRKbGlk0Ydkh9ASh1xhM0Gzxe1W2cRdpFBB5aLNU4i58G4ld+qIhoZvVkm889scgIxNAqIITjWXOkauQfZFfUWPSdsSTyj8pmsmiCFPvZ+UVL2UgNTzXSsPl+wD784oRki66JEUMZeUXzvTfU4SKq2kZRsrX3Ev2Cx/Iia4Mt+dLJBYCfyjaVjgmgN7jsbXVoI/SNk04KrvEk5GdqgYFVwWLaIEhqflRlAShJzK1ZDYJhe6+9s7KRP0dXfTdEsr7kEQqwsWyrP5HAOL33iEN4FwHkx2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7612.namprd11.prod.outlook.com (2603:10b6:806:31b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.30; Mon, 1 Jul 2024 05:43:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7719.029; Mon, 1 Jul 2024
 05:43:29 +0000
Date: Mon, 1 Jul 2024 13:42:16 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
Subject: Re: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
Message-ID: <ZoJBuHuusbzeGoXZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240628151845.22166-1-yan.y.zhao@intel.com>
 <5187229e-3f0f-4af3-b3f9-4debf68220fd@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5187229e-3f0f-4af3-b3f9-4debf68220fd@intel.com>
X-ClientProxiedBy: SI2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:195::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7612:EE_
X-MS-Office365-Filtering-Correlation-Id: 271a6897-63c0-4f66-8d25-08dc9990bc5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0qc5R0jUEPZtgd2bqSu4x46AeID3FWiGNf6YeN1YoWkxl3ERPQb2HErlduSe?=
 =?us-ascii?Q?Qy51Z7ChXWObGZ8JqGi3IHRPOqzz4LuMLMdEC87mZcLlbA14gnbuWpA2a0KL?=
 =?us-ascii?Q?9Uddupm0TBierkHa6d/ORq3KaW4GGPrXOCxfpAQF5zm0TTyX+UfEF+nP2+3h?=
 =?us-ascii?Q?YaObVZEFx74ZKq37mPgVkTdsYwS+kxxhr4wuM9UhJnM020z3LxSMybko/cF5?=
 =?us-ascii?Q?OJxQpXvDzI9S9332g5f10npDIiZ/zH90K6IxxWIyfTJY339bhIl/mA7OJ5/3?=
 =?us-ascii?Q?G6FFB0pyVGT/QQtynVDdXSWzv3Fsj23B8oyFgp36smJ8neaqdtasS6LZMQff?=
 =?us-ascii?Q?y+DT4aBAXEgt3t51gHdPwQNW8vSWz/qCSRdYtL1IxFrL4yzXKuMwXgXXAqlg?=
 =?us-ascii?Q?8aNroMdskK8BQymO7iQwX9CRgeOE1OdIr/SXz0QQ/R7aasfYXTP/LAg2hD10?=
 =?us-ascii?Q?+xzNlTZUNZ4mu3/zTpx2IPoD4QJWG3Q78dVJK/TE8/DhZtEBikU5dfEVTpll?=
 =?us-ascii?Q?O3qn8zCestu4QbhiN5dXOT3K6iEyhkQdwspIYBU5dfoXkFtUbwSpjrS7RiJg?=
 =?us-ascii?Q?eu9nLfSns5lRlBRt+bAXXm9/BYy3wIqp/q58n5COmHMmr9AIo+a8xlN4/D+/?=
 =?us-ascii?Q?8Awn0vWYY7QdvRUmrhjxXH84W8BObT8sPoYx2BNR5alzvMWvpH5NYS0XuhRy?=
 =?us-ascii?Q?eGVx6HuOv/rTPvbWJk6vh+rTWPXLNmrOS1MV5F2YlyXg9YSMe3+2rRacKSVy?=
 =?us-ascii?Q?ictnDc2X0OKfEXAiy/xEZf48ZuHQitTnu3Yr2Rs/XhMQvDqNetgVyPwz9sJm?=
 =?us-ascii?Q?ktxGIYdnNPTdbmLFUfOjIBjzCnnm2N7QFy9kBMiIJ2gCdWVceIXwwzLdbHV8?=
 =?us-ascii?Q?ARikF5uAWncTkfy2EFgegVEAYBvA6qtAaa2sm7KgQ3Me0E8JjA6IcwtVdfI8?=
 =?us-ascii?Q?bHQFXQAbGcbQJ03TnAZ+hklVsLpWOAFiSGqhadfWTsB5K+EKjwphSQ8nDig+?=
 =?us-ascii?Q?dF+upfMo9OtmhJMEfMwVFMZqkGEYucEmUOSw1AFC4MoexLAXIkAveq10+IFP?=
 =?us-ascii?Q?dLzh4w8mCeqCT23a/1acpfx6rmEIpuBsilqjSGKF8L/aONqP3+rre0NfjRk7?=
 =?us-ascii?Q?xPJVHO7vNje7Nm158oihSPGi+MhYVD61vaC/3J7GHBvjWIDcusX9KPtHVKg8?=
 =?us-ascii?Q?FW5nnYp1uu0aNBe9It2MXViNNgO8F2NWTqZv2xV/m4ZDnVFUDH3QkWnobgzJ?=
 =?us-ascii?Q?GBBseYgXCqcH/Q8/hRU28v9VvYzy8CIT7LiqBJv7R7acTSrHVr6OYmW4A55h?=
 =?us-ascii?Q?qeM604tFyhlqASVgebVB9oYf/LpMZ9WLIucE19XXVXZ8DQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tgqj7XYMKaXJYoXDiaFfi+iTqDrfqW9h6l0VINy7pFjBRI2iol8HaoMqrLZ5?=
 =?us-ascii?Q?qe1ZpH3fTPx4t9Wm5l3WrkHxtfVery+EAUohHJ2oPSNFISUMvIfms1OiUhEA?=
 =?us-ascii?Q?CFI2E9xzgOW85yexIKB4jDNosKbMwBidp29j05ywk8cFYGa/1auigBskQuyY?=
 =?us-ascii?Q?/bWpRYpVJezvFYT4gscV4VPBsjnT5Lu0veSaKkoKF1UxPkUW27p4LCl+c1Qn?=
 =?us-ascii?Q?WLNEnRVc4qrSAvhZvD5/xgQY3RuVPbeX7wgYnT9kbvY5eN0aa7Q9NSvSG813?=
 =?us-ascii?Q?Nfa50J5x6oPywXY/ebKvCdpzJK2X0aUXkYLx7r8AZMh8HnyyXbJyqxSVdUuV?=
 =?us-ascii?Q?hVQOhFpk/nY9zYr5tsjLe1TQ/3qJ4dYBtoCMdTs9c5wZRux1C5Leb2x3Fr8O?=
 =?us-ascii?Q?AcI8iPGOJc2Na80szP3Uk8kER45+a0uFxT/J3PRoVsAnlfy8hRYBL7fDKYXk?=
 =?us-ascii?Q?CxDJynkojwoZRuFxqzGj0xNxUeSTMF+rbKpCitNDKVMaxn5+n7Xlgu9SekPS?=
 =?us-ascii?Q?N+wQqPnwj39itAaE4H/eCi+J4ywLdk3wrCkPca5SvSgFwgUcOL4u+t7kmY92?=
 =?us-ascii?Q?/HTFXpkrJky6XG9z5uSdv2hIPSd3BBf9PzYOQwwW4Moo2lPfGJwEvfoA8N99?=
 =?us-ascii?Q?un08oaKP05R4NiXVwROdyvqwg+sEabtSUbAnxLHlCR8C4V7I+P5EV3XIxXOs?=
 =?us-ascii?Q?yBrvvMgl+oLdSEOEUfGclY+9CdxFd5p92/YXBgM/gAmBERARlLSWKwbxWPPs?=
 =?us-ascii?Q?FbXF3QAJTk9H+Gzs+h7IUNmq82PWHwECXWgSHLAotqqGoe/I1ijfgNzE50dk?=
 =?us-ascii?Q?vCAJizLfocAltK4W0lzjzNn+9adOpwTW2Cnm2c1rUvU6dIheBpcyTthwYk5v?=
 =?us-ascii?Q?UQ+OUwOtCSl0Y10aYMNGcyXUZMuVHRs2gk8v6iy544PnYCsCJpQuzAPIJDbd?=
 =?us-ascii?Q?J5Q6EL+iAuVyyF0yxqJ9Gu9ItR7WMoEAG2m//3domTl/XH5VLGU3U1RWOV7H?=
 =?us-ascii?Q?QTxDzvhAxcyrinq8ol1DXjBFxkf2CHip+qngM1r5sRZ8D0NKO9wR5dpinNXT?=
 =?us-ascii?Q?A6xa26CKwAAH/KrfoT+e58YpsBbHyi2hzg3Sh2MdBzipk18g1YJTYXcOMuyH?=
 =?us-ascii?Q?Rthx2DB6rqvuPOHtiUk96RfKp4WQdCfKHd55T6hDMvQJqPgHalfMlYD5WrSv?=
 =?us-ascii?Q?KM+C1OWe95dKzQUoSsg8ICl/m8L6LL9sPNMdBg+tAPdFVsE+8Lceqn3KEICC?=
 =?us-ascii?Q?2ZownAl6x5/YExRjOoOtgrIUY2GVNDDTK4EbfyG9UyAmjPKjl/OyEt0IuoKw?=
 =?us-ascii?Q?yfjNOevKZOEiL0d/tHwTeELjRVXEA7xxC7lC8weKCAJzwtzdc0KPkq3b4GQ1?=
 =?us-ascii?Q?9C9aMBE3SOgDgtxgmo1nrU5BrBO4slzMVjE+kBGxEATKN5sFAxJoEfdQW3Nl?=
 =?us-ascii?Q?LPSkt5ualqRTZrlC4pQvR/2+mIDPBE8CdnREamUjQUcVfa0+B23VjpFSIjEs?=
 =?us-ascii?Q?VWOX5/RSWfq0bPR35TrqH93TeVp49LtEcU8FiC/0iBDu22P0TIYRgjNeDO6k?=
 =?us-ascii?Q?HfSGi8tcgHdaNDO1SP6ZG4hsx7Qt02+tGvRFRq9R?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 271a6897-63c0-4f66-8d25-08dc9990bc5f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 05:43:29.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cW7DYwb9PomULzUemIotvHPELdYZNgoMlJOLfnccgvdCPI7ursdqYGDYK77dfSQ1aQC7w1vq8+a6CKzGSfGWIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7612
X-OriginatorOrg: intel.com

On Mon, Jul 01, 2024 at 01:08:30PM +0800, Yi Liu wrote:
> On 2024/6/28 23:18, Yan Zhao wrote:
> > In the device cdev path, adjust the handling of the KVM reference count to
> > only increment with the first vfio_df_open() and decrement after the final
> > vfio_df_close(). This change addresses a KVM reference leak that occurs
> > when a device cdev file is opened multiple times and attempts to bind to
> > iommufd repeatedly.
> > 
> > Currently, vfio_df_get_kvm_safe() is invoked prior to each vfio_df_open()
> > in the cdev path during iommufd binding. The corresponding
> > vfio_device_put_kvm() is executed either when iommufd is unbound or if an
> > error occurs during the binding process.
> > 
> > However, issues arise when a device binds to iommufd more than once. The
> > second vfio_df_open() will fail during iommufd binding, and
> > vfio_device_put_kvm() will be triggered, setting device->kvm to NULL.
> > Consequently, when iommufd is unbound from the first successfully bound
> > device, vfio_device_put_kvm() becomes ineffective, leading to a leak in the
> > KVM reference count.
> 
> Good catch!!!
> 
> > Below is the calltrace that will be produced in this scenario when the KVM
> > module is unloaded afterwards, reporting "BUG kvm_vcpu (Tainted: G S):
> > Objects remaining in kvm_vcpu on __kmem_cache_shutdown()".
> > 
> > Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x80/0xc0
> >   slab_err+0xb0/0xf0
> >   ? __kmem_cache_shutdown+0xc1/0x4e0
> >   ? rcu_is_watching+0x11/0x50
> >   ? lock_acquired+0x144/0x3c0
> >   __kmem_cache_shutdown+0x1b7/0x4e0
> >   kmem_cache_destroy+0xa6/0x260
> >   kvm_exit+0x80/0xc0 [kvm]
> >   vmx_exit+0xe/0x20 [kvm_intel]
> >   __x64_sys_delete_module+0x143/0x250
> >   ? ktime_get_coarse_real_ts64+0xd3/0xe0
> >   ? syscall_trace_enter+0x143/0x210
> >   do_syscall_64+0x6f/0x140
> >   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > 
> > Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >   drivers/vfio/device_cdev.c | 13 +++++++++----
> >   1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index bb1817bd4ff3..3b85d01d1b27 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -65,6 +65,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> >   {
> >   	struct vfio_device *device = df->device;
> >   	struct vfio_device_bind_iommufd bind;
> > +	bool put_kvm = false;
> >   	unsigned long minsz;
> >   	int ret;
> > @@ -101,12 +102,15 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> >   	}
> >   	/*
> > -	 * Before the device open, get the KVM pointer currently
> > +	 * Before the device's first open, get the KVM pointer currently
> >   	 * associated with the device file (if there is) and obtain
> > -	 * a reference.  This reference is held until device closed.
> > +	 * a reference.  This reference is held until device's last closed.
> >   	 * Save the pointer in the device for use by drivers.
> >   	 */
> > -	vfio_df_get_kvm_safe(df);
> > +	if (device->open_count == 0) {
> > +		vfio_df_get_kvm_safe(df);
> > +		put_kvm = true;
> > +	}
> >   	ret = vfio_df_open(df);
> >   	if (ret)
> > @@ -129,7 +133,8 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> >   out_close_device:
> >   	vfio_df_close(df);
> >   out_put_kvm:
> > -	vfio_device_put_kvm(device);
> > +	if (put_kvm)
> 
> you may use if (device->open_count == 0) as well here to save a bool.
> Otherwise looks good to me.
Upon here, device->open_count is not necessarily 0 even for the first open.
The failure can be after a successful increment of device->open_count.

Maybe renaming "bool put_kvm" to "bool is_first_open" to save an assignment
in most common case?
 
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Thanks:)

> 
> > +		vfio_device_put_kvm(device);
> >   	iommufd_ctx_put(df->iommufd);
> >   	df->iommufd = NULL;
> >   out_unlock:
> > 
> > base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f
> 
> BTW. The vfio_device_get_kvm_safe() is not supposed to be invoked multiple
> times by design as the second call would override the device->put_kvm and
> device->kvm. This does not change the put_kvm nor the kvm though. But not a
"kvm" may also be changed if the second bind is from a different VM.

> good thing anyghow. maybe worth a warn like below.
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index ee72c0b61795..a4bead0e5820 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -408,6 +408,8 @@ void vfio_device_get_kvm_safe(struct vfio_device
> *device, struct kvm *kvm)
>  	if (!kvm)
>  		return;
> 
> +	WARN_ON(device->put_kvm || device->kvm);
Yes, better.

>  	pfn = symbol_get(kvm_put_kvm);
>  	if (WARN_ON(!pfn))
>  		return;
> 
> -- 
> Regards,
> Yi Liu

