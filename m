Return-Path: <kvm+bounces-63347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EAEA7C632EC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DBDFD4EB048
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE74326D6D;
	Mon, 17 Nov 2025 09:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q+SOUsNb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD732324B12;
	Mon, 17 Nov 2025 09:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763371740; cv=fail; b=qaG9wvWZmfka9rY+2PeSXc94LZIBW/oMZHWg3XqQmyjL5UMK7jmqhmVGZubHFaE8yIKklYqdyYNUEOJQR3emOGnFccE+hnrDB2gXo2Ni+gIUBi1or9T2JYR/hoGGY7lqEiyGBNMxoDlclLanwZlnZK4xcRVIvM9eTmlUvERpe4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763371740; c=relaxed/simple;
	bh=opozqoLs7vxlSUPQw6s3XWj8r5VzZOHkvFcF3z8pMOI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hhkq4+iNnDqHDQt22HDuKWQ4CWqdWQnvR4nb+IouaCMSwzsZRSXDqa/7d6kJh94PN3w9L1bzS3QQ0ISeGbeUEESnonz3Lpag+x6uaCpb6Xj7asAcYNPrAwKKzk6XuLpLIph0JJOe6j57BiUbNgTQ39RYUSboAj0/VHaoJYe7Eps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q+SOUsNb; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763371739; x=1794907739;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=opozqoLs7vxlSUPQw6s3XWj8r5VzZOHkvFcF3z8pMOI=;
  b=Q+SOUsNbN3U6Rkf8L/OCCVThLg5STmknH3gVInSJAKgTZlxKVlqswUYs
   TsEdAD7vIaElhRs7KXCTa/9htAPc5CMtp3iKD5OEPIERnuHv3joB6211R
   sWhSWqsOZAqoMsMpPzk4o7aJ37UN/+64PGEzqg9by7mScm5UrHsoXZUMt
   LQeR9IPX9NjG3Wcb3V6ypkenGiLt/Y5TeDglnLsz219TSbApj1l5BdNwI
   V3tX5uuC9C7FWEGyV5jiDc7LJqfuvTgTbTpr5qStAp71vz957SASixZkX
   ugEpalgjdMCGtTpAr5FPUQPVLnXzzi7E+R4HYoVQwRhUk8CS4xv9CxEWh
   Q==;
X-CSE-ConnectionGUID: cYHdtE7zTp+T+nhzncQH0w==
X-CSE-MsgGUID: QWKlPNSHQiyln2R4E6x1Lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="65299320"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="65299320"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 01:28:58 -0800
X-CSE-ConnectionGUID: eLPHlQLVRL2d8aGnwqAajg==
X-CSE-MsgGUID: k/3qpDHgTEePXQK44vIIwA==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 01:28:56 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 01:28:56 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 01:28:56 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.6) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 01:28:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fBenGQ46Z5E2F3r8RCr8kWk/nv9R2zuG6XDNMN/8ucx3Bp60D22kEM9CiPG8f7tulMTl6Wm2/R79UNaQuZxj3cS4HUW8fealZQt8Wdj3y8t6vYE5xMA81M00eLQVVN39JrI9MRbiMjn2sJw+KB35aXmIF6dSpds2U8KiwqrYx3atj1TqgEJn1pA3vT+VgYOb/SIZ/7Ge0+s/LHPEVtDUsq1+fVB4i21ignk/Rws6wKz6Byauc//oMAejJ2C6P8vjHmdHPr4wTt8OdFp385lKg+kZw035QHUiMDj3bG1yb/mBDLioIz486h3JceDlFbE+2t1PH2RFK0iRq+nsnM5oRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpUVGwVPo7bFblIi+Y2eubHyiVUC8mz+q+F9vN77eAw=;
 b=CmezvoDqSV4ZFwbEnAYdtsV/NoEhLHgGtzIuFsbiYUZqYPgK/YBROf79x4IjGQhpUwz7KYxzInksUX79dOyvEnUZnqQyjgP5GXoJoJtP2Cmc5Dc4+JqWj4r4g0Sjf2pftl1WIe5xd0eD9HFipPcjRdraUVCKipuShfZStpBSJKpB+S++dMVTZDq43/0/y+Cg0kF71tl1cybZqQQovyPqYfzsx+ueFxQ7CWML7juFiFvwytN2Q7moT8Eshpt7+INr2gM05FgJZDfv9+U3PVhbT1alxPzF6zrTn6JWY8we0c4N89Xm9zZvbbXMBZBymarQ3IFjJmV/dxsSI3/udliqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL4PR11MB8824.namprd11.prod.outlook.com (2603:10b6:208:5a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 09:28:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 09:28:50 +0000
Date: Mon, 17 Nov 2025 17:26:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: TDX: Enable huge page splitting under
 write kvm->mmu_lock
Message-ID: <aRrqUXlHfCoPHqsg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094333.4579-1-yan.y.zhao@intel.com>
 <9aa8b3967af614142c6d2ce7d12773fa2bc18478.camel@intel.com>
 <aRVyYdBlnS7DD1SS@yzhao56-desk.sh.intel.com>
 <3d452a46-451d-4e68-be3b-90f4bdec07d9@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3d452a46-451d-4e68-be3b-90f4bdec07d9@linux.intel.com>
X-ClientProxiedBy: KU2P306CA0045.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL4PR11MB8824:EE_
X-MS-Office365-Filtering-Correlation-Id: b6241fc8-dbeb-4660-608f-08de25bbb7c6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RuSwD0b7Dam5+t+l2KSYO0eA0RgBqa+93TTgUE3ou8tLhRFTgZENnYSlMwkA?=
 =?us-ascii?Q?A/8FbBQwOQxuquT8e+EsuOp2wkEYIgFNPXaMnUPQ8STNclNahpuRYcTDKgvR?=
 =?us-ascii?Q?zrhSUtv9E6j5BlVB/NOA+gB4T/h0tIw/yIiaktsaCB3WNHZHHcZ/ajY9aj0o?=
 =?us-ascii?Q?v16ztuqWB2FgbgMb6uzhwlEEDcSTFxdqHp3bN750HlQM8z3flW/htLmKpZdG?=
 =?us-ascii?Q?Yopu6t+lQV56E4AiIb5aZInOKsfHOs8YrE9ylhkKRL24rUZprg+KZWPrXej3?=
 =?us-ascii?Q?wQT4Vwq3KFYNUCuy/gYk56enBuZbJEooFqx/ZymWDgbGnaQK6w0KRrzmokV6?=
 =?us-ascii?Q?yl3rSaF4qo1lpGmHNz/ufL11rYD5TusJ0C3K0OI4D8/+MrMT6tgM+/vP7jP4?=
 =?us-ascii?Q?VyKNWob0lCsfyTb2Lnw4ZL52VVBWTj5GNklY44o0vQk9pGIfJwG7Ip0xfhQR?=
 =?us-ascii?Q?g0wyUZyUbAbt0nG4ZHdQ3rxR7uRA6YLI0T1KkwkAh7+nSDbKqVEhtUiB/Q/U?=
 =?us-ascii?Q?HGkGA28MpGEzOun6JSILyK+e/qxz528ybWsSe0oRKU7RSpk/qS9MNN/dM+9o?=
 =?us-ascii?Q?KZM2N+k45IOYYV3bq9o53wzjeBSk5rIbotxLSkD+bIrD8sTlcsa7ARfJgqU2?=
 =?us-ascii?Q?XLnsJG0SwwOhmygx4aYFVy+0kNvLyaaGafs1GEoeuhJ6LVup3ZmXZwniyQzl?=
 =?us-ascii?Q?TOtuA/ey32IssA8oeQ/huzWfu/d0Tt+GYgTWC+MA9z2Tod6o+WDmAlf5YUug?=
 =?us-ascii?Q?F20KMctbn5DuyR9zey04+RkgHwoICVh9LwD3weT+eCUzetNWjzlMmHTQL9Tu?=
 =?us-ascii?Q?xxx05vp7o0eJnGvUTUcnGJaI2YBiY17hs2M4bTeOLB5uq+t/2SOT7X7QB2G8?=
 =?us-ascii?Q?QMUweAkLsboz1OXSvFxFAR6hiG7bPOyXyqQ7dmgCu0PouK5y+aj0e/95sYgS?=
 =?us-ascii?Q?02ClJYygzQ5TOrWh3P6qQY/EPZNR7TLGlxAqvmKurmODvyhxqMjO376pDbmb?=
 =?us-ascii?Q?eEfQzOyBThbi/iUBzfHp2tOGZzwKn5F/6axm8IWwVqleLPzCSS6pWRPx7e4r?=
 =?us-ascii?Q?ZC/RMz0TXucv8p0p+vGUqpY3pL4dPA9aPyUGvVTfTh5tKJm/dCK+cl9UQw+i?=
 =?us-ascii?Q?xL5uEWGxZUwQDpgJFAAHRz9c+/QbExspuW9N4AGOQ8MOqRo5P5FVVJJas/s9?=
 =?us-ascii?Q?fKLR4DxbAYDQYn5RgZ8PgdxfuF1ZViIqnCthY3/JFBqbPbXeZLGwHIIJa7qi?=
 =?us-ascii?Q?bA5eFHBxauPi3fivXU3sYoj+EyEWjeMiv3Gt/PLc4Pfr/ricva5NkT1e+xcx?=
 =?us-ascii?Q?xPVkTj2XvPhktUqY5S4ArHp8yw8zJJK+9FSd+97jIza8jRmID2nAMDBh1oSE?=
 =?us-ascii?Q?dQ221cWipH3C8I5ldRo3QwN1zO3FQF0ii4onE4WjsS5GGLcUvSsZNmUGfcZE?=
 =?us-ascii?Q?JvYjBjcrrczbF9qnbMf7npcvIWiRDqwY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rIZftHY6LkluMAuGBwwJHt1yYcwfWWhyjNG5cBq+aO5pU1Nlgca98oLQZaOA?=
 =?us-ascii?Q?4miLy1klra/Fu5ldYSFSBig5uIP/oCfnrfjC0+XbCvPAYEjKI0UzfHw1jTAI?=
 =?us-ascii?Q?arfy6d9nnHpkBIt3p8HFSVcSArHsVAksbWZSyC4UdzKQ54+rz1CEyulzk7mF?=
 =?us-ascii?Q?gx4DE+w8EnwRYvGVXeK86aVxOE4MAjQZjB0u4sWK6gSg51t0i/AIr5eKai6p?=
 =?us-ascii?Q?IhOhvO0J740ZawNcva/EI1xRGQXJN7m5/+r1XelfdeASFZSZu3noqEk68ijo?=
 =?us-ascii?Q?aHBM1UgUvOezTmdVFd7eES045FgKNVjMGybX42a1GnbnyA+yKyLrHBSqYOXh?=
 =?us-ascii?Q?PHvDFb2tGFhFnB8I71a+rmPnV8UFqpkK83buiW/v2ZdkDPzUXZs1Q1OD+VfN?=
 =?us-ascii?Q?R0ocXvNrBnv5AGR2kuSX1xJQyBBUIgjKGV7rg4hhlSp2T9aTJ3cfEfsLh744?=
 =?us-ascii?Q?/ZQGLLBIDTo4mGDIz5pEnQMdPyqk/dO6xpm7VLXZ/Ce2N/6nmGg+2rzHZA0B?=
 =?us-ascii?Q?/SYw74fWXgH9oZcsO1dvoneJ3UimvmrXowP8yWgwVjWZpaTmY35jZPShAmSz?=
 =?us-ascii?Q?kxqA0oh6o0PVaBKcQkF1aTG8vREU2RjecSPIlCmxwwkkSGO1ds3oUFVP39YY?=
 =?us-ascii?Q?7Ydi9W582KPllpon6ZDYzlqrPQGyV1odSrnCyjURyovz981iD667mgcqyIwE?=
 =?us-ascii?Q?+Zo6OMNc6p3cguBnabxkkg+CaOK4d8MuXQQVI8R7nIzxjwu3F1lrZ6VMF5IJ?=
 =?us-ascii?Q?dg8unJNXljqrD8zgZ69oj7lhZJl0ms+y+zKSCgf69FLUey2plSyJjTSo51Xp?=
 =?us-ascii?Q?jN1/M/fAQ1NIkGsNAJGsmqnmdlwXH3F8q2kaSrrpr5oJEXWZcC9XNQrxcA1H?=
 =?us-ascii?Q?+h7xxWwihvtizdOfk2TLTuLcfS1b/UXhkVSS4kBJAzSh0IRd180zOXgx2jEL?=
 =?us-ascii?Q?o0BT8r4//a4dBY4h1DU/957ZW9mAVZVfcxzFy1Jftct5chbWPjXoaewvwaMA?=
 =?us-ascii?Q?BxoIU/R1so9Mer9roYJp7u+7K9QAms0reqSlilF8o8HkbPntfmi98Xi/y9Oo?=
 =?us-ascii?Q?9CbkIyen8foAdN+EXntM2BgniouQcAhIYp71BsJnzinFSUiizMTPESu4Gw0m?=
 =?us-ascii?Q?5MZxaFaqoz2SFOZPqfprelqWFNM10hcyUYKyVN4RTXW1T5jYfDdV6FkU2jWT?=
 =?us-ascii?Q?2k0hw3RykEHb+lqZc11QOG3wXWj83FgBeXr2CQzhUCZDCpUmVlDDm8iotaQw?=
 =?us-ascii?Q?77mcu/p6hvpELkUDDoWwo2uRYOtYt3h4ZXQ52BddKcuFMp2Wl3ifm/93liI7?=
 =?us-ascii?Q?4EiI7yhNMC7CGEqMcJn4bXWk3mAXsKLsG44HmgHed1iNgkYUHjr1duQDysOR?=
 =?us-ascii?Q?VnfeXpK4JWJKZUjt6g0Nm+eEzCPwAxOK3bmVyo+JihLy4L2ZJc7AxWPkAWNA?=
 =?us-ascii?Q?tsvvioB1xEd9bpcMSQVgQxSM3ru4JpV4fygVZPzJr75KQMpuKu/6f7KdYpMm?=
 =?us-ascii?Q?ZCiR0f9fJQPhtuUsP7lPpouZ+/Rg+xgZ1agQOIpPO955z/TxxEmug0yer7cc?=
 =?us-ascii?Q?o6RumN2kzBdJWzx/HfOzXshs6pakHcT6RpR6xD4D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6241fc8-dbeb-4660-608f-08de25bbb7c6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 09:28:50.7442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUw9x8fIhbMRWGpl4c0s4PQhp73wMc8BdUSTqM0jmOyfoiEFnx2H9ckQlLp3kqR5GqU5rQbhRWpviiNdAkS+mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8824
X-OriginatorOrg: intel.com

On Mon, Nov 17, 2025 at 05:17:27PM +0800, Binbin Wu wrote:
> 
> 
> On 11/13/2025 1:53 PM, Yan Zhao wrote:
> > On Tue, Nov 11, 2025 at 06:20:40PM +0800, Huang, Kai wrote:
> > > On Thu, 2025-08-07 at 17:43 +0800, Yan Zhao wrote:
> > > > Implement the split_external_spt hook to enable huge page splitting for
> 
> Nit:
> split_external_spt(), similar as Kai mentioned in patch 9.
Ok. I'll refer it to kvm_x86_ops.split_external_spt().
 

