Return-Path: <kvm+bounces-26116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5050D971AC1
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:21:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5DE81F2190B
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AEF41B9B24;
	Mon,  9 Sep 2024 13:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KeS0C+LH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD571B86E6;
	Mon,  9 Sep 2024 13:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725888075; cv=fail; b=nzJ1rTF78A94IaY63QjA1RSdFlAjaO9VEkEYPLjppqT67Vzn5nuVXo8WAMkIP28K/ACLlZAyZh3J6d3Ea8vAR7dWmQDuIMxmvv1PDB+GoqikGoLWNKKzApUPXMKllEPvj4AZC2Ae+v3SlDBWuRNApYpIIyr+bR1+QZjwq+HuzcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725888075; c=relaxed/simple;
	bh=uwUvw/v/vgATc+wBmY4eI9cvOefTd/HIpghB41CNa3M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hvuzdxtJTtVK1Xhi8I/DEKar4A5bc2rv6rKU+kV0mDNRzhmO/i6vw7HRL1QzTVIbZBoL8rTwgd0FRa8INWQ58aM5kyy2oqQzVFRtR+CSbBJU5U0EtVj+W+p9Q/XsaoQ1xk2wB+5fnz7lGiSwf7woDJHBlGezodTVCnLY2uOsDp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KeS0C+LH; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725888074; x=1757424074;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uwUvw/v/vgATc+wBmY4eI9cvOefTd/HIpghB41CNa3M=;
  b=KeS0C+LHs+Dj85K3/Gr6UNO881eu7e9IytP+YKJId3JHNytirENWJIy3
   qZOLB3AIOLyIqEWysWt9hgZcboMk0HzMTW5E4MVuR0z2ouK1jKKAJOI97
   HUY+kUn1jPq9xEfiJhJ06wgK81Lm0zBwPAnEvNK53bS5QQianVIJ6iLGK
   p5iXSP5Oe8XZtax4JYojqmmLC2fPh/7UlMEfrYBb1XnZC1Iyi2i+63RJI
   CwV0hY2OBs0voZILSWNnqZmbUv3AEjq1uZsFHX8iHXZld4iTKtd5KlzPW
   ewPMDZo+dUczqjCUPYKnAfHN9FttixAF2Kk7GrZ+S/bDbsHYt5X0yccjx
   Q==;
X-CSE-ConnectionGUID: BpCYDWGOTDGIPcm4HdZUXg==
X-CSE-MsgGUID: E26hL4orT2OeltMp/93SKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24693204"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="24693204"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 06:21:13 -0700
X-CSE-ConnectionGUID: vvWuhZORRM+uX861DtLkDw==
X-CSE-MsgGUID: 7aEMbCfGQgisIRoyu1qAlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="66675802"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 06:21:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 06:21:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 06:21:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 06:21:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 06:21:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fx/xdz6ljp36IWDHZ6CevOML/lWVKA9nGW93qbe8E6c5css38DWdi8SJXL/4DFS1kGBwjX8P/Qb7ql1NTTy3Q7oU+Rwsluw6ay46OAxP37mS98PIilfNoc6X6T5yYN4dGTb+xmHiPElw/cWBGrjJrrgFP95lak2+QYxB1dwXlKWpBy0DDrxUCt6aA+X4QSpf5R/eVk409th/6aKA69d3nJDGMsP1+/N3GwRpQfgasTyYNjqpzkBZvWdVdgOLQ7Rf+n+RM/B/JpF1NXT0YOoVmsOPn44mVAYwdy/bqcrhGvMh6C+1FZv68POlQ19LVUsYnd4DlDhDovQjerHjRgkkEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPrHCYcy0anBdislJnDBACEIv9hHvJ499aUoIA/vQCk=;
 b=DTJss6BuiOoAorTOH+3at7mLzLmVhdBtOpMAj8tajbmFYjBT1fyvMGkPP7ef4/4XsXiRKNAymYn9OwClDD6mHBvgNlJxyzJkLD2OQzXZggTgVQCOJgDvKsHPV1qsOk0+4mCNlRKrH4mEvML6pBf2r7cJO/uznp8Ywja9TMzzuK2w2jVYtbzuG4pYdZ5IRX6KdtyTyCJB4xfAHIgCsxcUuMbfEYd6R1MLIS6m/XpWQgTJar8miAHUpCnqNh/r3x4ExIEv/lXd0ayaf538LLACOsQSpkAFfYL3hXV/D/7fPhX7RKT4m8cTCtb7c/2EutNfVvpad1YTqbPBCTkntM+eng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6093.namprd11.prod.outlook.com (2603:10b6:8:b0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7939.17; Mon, 9 Sep 2024 13:21:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 13:21:09 +0000
Date: Mon, 9 Sep 2024 21:19:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
CC: <kraxel@redhat.com>, <maarten.lankhorst@linux.intel.com>,
	<mripard@kernel.org>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<virtualization@lists.linux.dev>, <dri-devel@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, Kevin Tian
	<kevin.tian@intel.com>
Subject: Re: [PATCH] drm/bochs: use ioremap_wc() to map framebuffer during
 driver probing
Message-ID: <Zt710MSzAAcVEw0n@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240909051529.26776-1-yan.y.zhao@intel.com>
 <78cf5ef4-09a1-4f7e-ab88-cbffdd967af3@suse.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <78cf5ef4-09a1-4f7e-ab88-cbffdd967af3@suse.de>
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6093:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bdaadc1-9997-415f-028e-08dcd0d244a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6bdxEt/rDHEX7l/wMTqRkJwKNc1cYxPpREqKTpYLvEvm0oOTQ0bBzGc7Qc67?=
 =?us-ascii?Q?UUiwKohd7RJ/4gNWuh9tsWcP9R/y5rlBe6I/XNOzFkpUZuFoAZCoPfTt0yo3?=
 =?us-ascii?Q?N/8sLHMjgVfhfBSjQniSZnSCvhKXb/i1oQnIiOcO/SonS1OmGZgYO36h28g+?=
 =?us-ascii?Q?yy65XnyF8wfqrzrl1/2LcU7kZUsdpuj3nCeti64QFrVuey9BZYZ54xssSVqr?=
 =?us-ascii?Q?4E9+z7DJO7xe66OVd99ZLvwhYjbo0C3aqSjBpECtYSZ8xAMhVcdl+RDMMJwc?=
 =?us-ascii?Q?cYkmAHik1h89R9XGsfSkQVsAo5zPgvcBdwXPRZVUXmJeGOVE/sclJI6lNp8V?=
 =?us-ascii?Q?Ri/290PB2xt5tzPR3GetItaq35fB+kYGoOwFdBQRg+kYnqdzO7FhtVZiUTOY?=
 =?us-ascii?Q?cuFweJ5D/MQu8PKk8fouaHQIhz9LXuhzlrUQECXi9bWMX/7dsCDInx7mhtPY?=
 =?us-ascii?Q?7IIPxh37vs6oJYUlT9rJi9ifUhieituvXwtYbGmhMLKNt9vxSvmlzZy4a/hU?=
 =?us-ascii?Q?HfQuZkKjlWGummM067Y9V3GHe0W58ZOg+bp2487QFtcKNQ5yVj9b5dndECZw?=
 =?us-ascii?Q?TQDpjhXomW9N/kco4YD9QObGLN8Mu051V3x0Vz6bhZn/i1OCrEQ/N93wCty2?=
 =?us-ascii?Q?mvjvL3FlIAia0qwWf1egFTwo14owKOgdOletbrwatQe4XimSTqAnaM87vP8g?=
 =?us-ascii?Q?r7Ao3n57YrZ5483F0FSF5IwpEdlCM99iT5LX14nzClKcojh917Cth6dcR/Tz?=
 =?us-ascii?Q?dwmaBpT91S6ZQsip34TCk0YBFuRuJZt6AnNDAs1LPNiYZVS8Px2f92UAGKDP?=
 =?us-ascii?Q?0bNsjpLupvywLg1imknMZyZyR4fMx8N2sMQV4PFANmPqs8f3i0P//ImPB4DV?=
 =?us-ascii?Q?IbCP86NSdyWgUTDn1O5bui3OUIywnJjMCfEYLy0j2emEVuS6w5m33mO86qHi?=
 =?us-ascii?Q?OeFxRJgyil2OmcSC0gVMmOYn18rI/Fw+ozJBx3PLERWFd3g7qdqIJtCMFnpd?=
 =?us-ascii?Q?vIAnCD3PikldPxFp1jjRMJWNrsegGwHXBa18ZRuT9+eUWg/rtZDqqB1plAhm?=
 =?us-ascii?Q?44zxqFgxlaJzdBmXB+IfPqBAwxgbGwAEEvq92bU7xp+rdZtCSCw/XKCKOa4+?=
 =?us-ascii?Q?bM3p3GNIy+HRP61fUUkYPlQuQFMgx68lGERnDXYEO+6bEii7UAs9iTPw2WvB?=
 =?us-ascii?Q?Y92g2nKOayePd/UngsKcCoymzR05XG07frZaew3cgLc9YtHUACdP0fQH9Kxd?=
 =?us-ascii?Q?aVqmKYVuc94fk2858Bpe++OHXVAqkwoMiypRzbUrGXNVrEY8nYclduTpXz6p?=
 =?us-ascii?Q?VZ8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3E38oJSch/Siyvoki4GxdWmqNrWOABRdrLXDhCw0xabf5Kki+de6jC9UFMOO?=
 =?us-ascii?Q?HsQe/6sbjQJPqkcGao9WKvt61kLm66P4mtlblMUDx11QExvdthu1nQNx0WHU?=
 =?us-ascii?Q?0Wp93UwDbGu867ShhclSW+ckqm28Gekx6WueEv0sOaudW9RkI/irLZNRXlFp?=
 =?us-ascii?Q?gMdnlUttCm7BKd2fZBdqw57XBvW4TsAhsN45GwRk1dtWk3c3wEUotw3Td17B?=
 =?us-ascii?Q?7VIhz0qqXv3ayJNodReQch0Zb3rVXd1CAc6ZcxyY6ZKJ8VQj/kvmcBbcnHe/?=
 =?us-ascii?Q?mL16o1DoWhsnA09twgq7pnQrcEV56bjS33tK1IqBOi2dKmuOeZziX6Eppa2R?=
 =?us-ascii?Q?19ULk/KfLIBleTJBTb8LuJ9I9C6moy6QwJRwLXe0ScnoQJHLDkoMci1VwAhh?=
 =?us-ascii?Q?kLegLVUEEb2d4vnfE4srP1rzU8uBx3s0oMysgQb1DOObSySJsRBKV9ZtMdaM?=
 =?us-ascii?Q?djdlMK43WggJ3tA2dS44gF47zWxRZxwhi5VJ/qVJGNuRRb5SjVL72BkcLu9c?=
 =?us-ascii?Q?oaWh14YUejw3QQoBCQZ+U+Kka4+iXe8HwVy0liqZXxA6ygB6OacipOz1C8Bq?=
 =?us-ascii?Q?UFKf9yB7EnNE4pOxma4mGx1DRm7wLhynTIUYsxezv+8eZRcYxqwA0+xq84qr?=
 =?us-ascii?Q?t9u0kFvFMR6euOnTXMZbNJp6K/npwq2hXp0NjPp05Ni3TJy9Mf79/YLcMssd?=
 =?us-ascii?Q?HGvvCvS7X4LrlZwoWdjD6OAnQX/38HzuB0YCEMzKpo9zPQQrGqEguRZaaNFp?=
 =?us-ascii?Q?gNH/vCNKT5lXdbCrhsKW5mYTxTm+2VceyKCl9b/pLcCx+2VkvSdubuDYiOUK?=
 =?us-ascii?Q?2K8rkzuhNJxb/2RJ3leyAYLwoX1wLGgSJAi2HH7QqHnVr3xooTZvtstoL7R5?=
 =?us-ascii?Q?k4axW2uioJODXt7n18lk+UpGH76esJNodjDWmu/hzIichmPhBa1stg5hpzxZ?=
 =?us-ascii?Q?JzO3/UJZKHwHxCctLu2wXbhYuZMjhv4oIxq3jDOwU39ySwEq/cOS9HjlQXGm?=
 =?us-ascii?Q?YCGGPvuXVVPrjCZE9wHjbJ7xOm3L5PgJ8EGLZCWqrwdyLnTIC7zoziQZhg8f?=
 =?us-ascii?Q?WudyJwbDxXqykb8srSbLXXJv1OWCcIlxFgwlLm5p+5Yf88R3h1vsi4gII2tp?=
 =?us-ascii?Q?V90gMSiAgLC7BAh2qeI/+8IktgCdXktjSWoGPdDH9/FrupjpTfh+CujXlf67?=
 =?us-ascii?Q?qZTY3/KfPnmc8QA/AwkRq1iH06PbX6flI3pN1cT4XrB97roNjv+Inhrbk7+s?=
 =?us-ascii?Q?YzcEF6ypnXCQ9DnzdtnA3n45XTAFNZJN0gMcR4bnSQzArXzhCwciIUml6DUL?=
 =?us-ascii?Q?a6MpaoW3DbK1hUaR+KHD+kYyUlO6zD/s4soEpqNMfVlwwiIte86f6JjIZAkP?=
 =?us-ascii?Q?Y8ehr0ojGz35vhoGifVpAslq0clN9idqisDFSoGTbTveLOxm9Fom6dm7kgrH?=
 =?us-ascii?Q?8iERa8YZd+QvdzNrvZ6Oga8y7w2BL+1mVpuPQpYBj3ZDZgQhr6tUsZ6yHQTV?=
 =?us-ascii?Q?EV+93fDQW23IDjtfP/wD7Bh9UIevv6p+vMBASHXkj9wgRADQV3VLDESIUJag?=
 =?us-ascii?Q?RRwSgA6P556TZp57xvsedyFr99bd/AtmjHs0g4cA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdaadc1-9997-415f-028e-08dcd0d244a8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 13:21:09.4747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESUsckCSq8vDDzEIMqcxRzGPNYWaTyZFxSQZbYDRBS3oMGu+i76SRPjf3HvJB5tlNwmv4eQmaW8nb1eJBHyeCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6093
X-OriginatorOrg: intel.com

On Mon, Sep 09, 2024 at 08:40:30AM +0200, Thomas Zimmermann wrote:
> Hi
> 
> Am 09.09.24 um 07:15 schrieb Yan Zhao:
> > Use ioremap_wc() instead of ioremap() to map framebuffer during driver
> > probing phase.
> > 
> > Using ioremap() results in a VA being mapped with PAT=UC-. Additionally,
> > on x86 architectures, ioremap() invokes memtype_reserve() to reserve the
> > memory type as UC- for the physical range. This reservation can cause
> > subsequent calls to ioremap_wc() to fail to map the VA with PAT=WC to the
> > same physical range for framebuffre in ttm_kmap_iter_linear_io_init().
> > Consequently, the operation drm_gem_vram_bo_driver_move() ->
> > ttm_bo_move_memcpy() -> ttm_move_memcpy() becomes significantly slow on
> > platforms where UC memory access is slow.
> 
> I've noticed this too and pushed a major update that replaces the entire
> memory management. [1]
> 
> The patch is still welcome, I think, but you may want to rebase onto the
> latest drm-misc-next branch. [2]
> 
> Best regards
> Thomas
> 
> [1] https://patchwork.freedesktop.org/series/138086/
> [2] https://gitlab.freedesktop.org/drm/misc/kernel/-/tree/drm-misc-next
Thanks!

The updated version is at
https://lore.kernel.org/all/20240909131643.28915-1-yan.y.zhao@intel.com

