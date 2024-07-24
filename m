Return-Path: <kvm+bounces-22161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 403D793B1EF
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 15:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA293282DE7
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 13:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03D5158DBF;
	Wed, 24 Jul 2024 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tagw9xsC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0051413E020;
	Wed, 24 Jul 2024 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721828938; cv=fail; b=SawlA3ZLBtLU/fEnZnSz6F5GPQVRGzRCBKKM12sA3aOBGL40/PQhj5G3en5ef8epcuJBK4eTKSYAOfm95e8u3C9sqJ4qZvSJLNWNS0n+p1XXev7Nmz3fRW28Jo3SC4lN3bK/9khnPz5PGxDyjgyrP+iJ+d6Yd6fI4eNm6o/xpDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721828938; c=relaxed/simple;
	bh=APok05qFtTDyMXMwmB4YxDVLk2ZsXQJZRs92g3lMmqQ=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qk+bBLQEge8L0yADK785dLKa6MBRdDrujUfBgdfrTB4Bl0MEnLvcvjXwNiD75nEOr0APA3RbAsdJFKWSnc61J3FSSV4CZdMtJvVwimOnNqGU6uYLgKkS81iww7712j/Yow69TLCwrZ/e3382OK9sgtDOq50s3KmeTqZS2I+IHrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tagw9xsC; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721828937; x=1753364937;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=APok05qFtTDyMXMwmB4YxDVLk2ZsXQJZRs92g3lMmqQ=;
  b=Tagw9xsCNaAyNNCaq5GAf1+MRxG4fZko1i+ufAedOh9P+iqqKhr9DZzk
   xCQBmARzm1n7LpozFn2V+s8g4Iz2eM3HqTmkvRFhYcbeEA0dPUUCC63JH
   rNJ+2D8LG41+7OImfs8FQeTj3HPbsAx4RbxVsQl7Yuv670M27jKoO6zUO
   nV1caM2AYynIgHrcEt26nYsJylclEHHurMauuOKYDSbCQr0GY++p8G0Du
   zIu9PBg8cdHM17p50yjQc65oCOfmvEfoU+n46hRX3RUvX6bJiN1FIlZsu
   ZmrI1CPhrgIC3qgwBWYqqR35/U3w3fFvUkWD8VoJDqmyo0fhG+gT6hPwz
   Q==;
X-CSE-ConnectionGUID: D6uQBmfyQtuBGvdNFAmd9Q==
X-CSE-MsgGUID: PLeoXqMdRuK94wZCSFWOxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="19201532"
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="19201532"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 06:48:56 -0700
X-CSE-ConnectionGUID: yPHmwO9tRMGXB9kV14px4g==
X-CSE-MsgGUID: a0M6UNyMRFiePGjm0b3N6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="52274230"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jul 2024 06:48:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 24 Jul 2024 06:48:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 24 Jul 2024 06:48:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 24 Jul 2024 06:48:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tESHbvkv1SwrNRcPQNPiWasmII6q17L9Q6RuNsXqyjlhNREg7zav+OCTByVaGjiEuPM0iV2l7sQDAorfXlp/UAY9ny4SsDpQZBajjL+9CDFvtI2wuM5iLDEaKxNjdygQgeKH2dvlwnEz712kb8h7KFTgrhEYMJRM503n+ACHjvAaZhFBkeGvBGU5LY8DnViyCBAFrCARDhl3V0AL1ogiOo0sUDFcvmzDuIJKDzQYWVT7BHS6u6wEgwuEblCCX1rJVVFmsCfTFrUzsCbHvuUKsBoAW4RCdDApKoVcdtMFhcYYhKl14vGMDeMpLGWbTCc7/RAQgRHRc/40ayzRtJTrNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48/dIv5laMAxINTFatWKuCn3zUC0jzcAwkK7vN1gVZk=;
 b=BwymLWsx865QloXqn9KG2XMrP0WwcXaLk5yUSCJQOved0X6J+yNx340M3P/SsNA6PrZpcEilVe2Jmlulv02WCVyZmWWpeOObPn+NJAxQ6mP4pora+BqwT+Q1TF8CIKhYEHf3T3E6KnisrzFLIAhJncVmBOWcF/S3DDrXac+TSAthCUsL0GUqivNmVXFz7EKAo60TgKB+hy0Y6XXj3QTIXwoAyIFzyjj9w88VooAzZEm7s85KTCkQ7L9/xttDTd/FqjoTDce6vFl+PYDrXJPOQc2Mz1+2vNeyVX1KUHGcpCFbbBrGDLdQ4WP3t9RzMpIXdpDHhHpu6+Ws7wzsSMqdIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB5944.namprd11.prod.outlook.com (2603:10b6:510:124::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 13:48:53 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7762.027; Wed, 24 Jul 2024
 13:48:52 +0000
Date: Wed, 24 Jul 2024 21:48:42 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<isaku.yamahata@intel.com>, <michael.roth@amd.com>,
	<binbin.wu@linux.intel.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Message-ID: <202407242159.893be500-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240708092150.1799371-2-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: 30ef564f-3530-4830-786f-08dcabe75aa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hwC02l+g+ZZ9UpoThGhJY2Dx4TWt5Gqvh5XG512Yjcne8K9CXoaAGQHdggCA?=
 =?us-ascii?Q?RRN2SP3yKnxZ6HoO3SKKd5sbFBzYz6OJqWxF0Ia96Riu/5I4iruyuf1/tryV?=
 =?us-ascii?Q?SeZdRqltnjjSW5xG5xFwL0F/isAEqzccdDSRo357xb99ItEbYhvpXFc2UY0o?=
 =?us-ascii?Q?rieXh48r6Ci/9KzUOyrXsdzQZk9jZgqoiO5XAYUoR2YaJhd7okLp2n/4ot1o?=
 =?us-ascii?Q?vBfyWvPru7RLIeQkpCp7KqDEvKZNxRBefKOxDzuD/pjKgW9lrR3Mw1b1Yq3d?=
 =?us-ascii?Q?ZkVnyifnq+mZVQEdNcxcBiaCsCRQqU1m0DZF1a93n4uGScw1ahSXRmEXEpnR?=
 =?us-ascii?Q?MJsdn+vtBaa6eidRzG/eqF6YlpSZcMwQbHtco4g21e3b3LAapyCgLocoG9D7?=
 =?us-ascii?Q?fmZyd6NcxquOOCJBHeFyStRRVBzcV5fU1F2iflVqyP/T/2XgihIBlB7KAd/G?=
 =?us-ascii?Q?DiXNgbxWIDADsVrikTT0ZZin0yjmponqhwMteTHe1z6l1BNXvazRpbB61+1M?=
 =?us-ascii?Q?+3COEDHTJLUDtkR/fntgbU14glb5pxkPFuXBuWoF/jsPLrB+3AE/QfJq2dSr?=
 =?us-ascii?Q?YscPPTczqfVD51n9K2i9uh7SeX4qfwvfwuJyD74T0FHnnl973f/EaALKt994?=
 =?us-ascii?Q?t0qfXpVdbqKAaXgjmtA0qvjzgHVUkexOxNmPm6on3j278pRdiLmSOlqYGK5V?=
 =?us-ascii?Q?QgaWFaoycrI96orz9arJzO3AG0EgLmZHTDl7+rrCoBqnTzghAzNR5drxcm6K?=
 =?us-ascii?Q?7rN0ntaAfpSNu1qCAVY1wuyKL4ZdErLM+NC6t2SLznq+VRpuyH+dH1Ofp0hB?=
 =?us-ascii?Q?oSq/c0OMc0NKXGDqnswPsbxesYrXmeRn6FN8T9cHbL/f/C4OCUJuqHgLxD7S?=
 =?us-ascii?Q?2PZ7tH3lTi3l1IrQ26nq8aI6ikXzVs/N22/CcYByh6plmrMQsKeY11g3B3CH?=
 =?us-ascii?Q?R8OSmh7LR1t5q8kTZ5Wg7m1HsC57W8Us8B10928U7q17w3Bl6XXyuM63O9+H?=
 =?us-ascii?Q?7HG1nsfFI7UtZOO3GiyfbClBIeJmL6ZSVxVMihf6ehZ65ItVuma2LDff1Mif?=
 =?us-ascii?Q?YOby6+YyeDbNqNmSjRPoqDfvmUKV8gbHeD7fpnhAgz/S2xZ268YbzNqEIu9A?=
 =?us-ascii?Q?1qogN8HOQl6ttM0x0+v07kKf9aVwkC3jjqWDddUx6agl+gLw3Litg7SpGv6R?=
 =?us-ascii?Q?LwLr3seiucw/TkIbgM6enx/PUOjWsykfQFr8Z5L+8nBKFcmX47U5OIF0lpGK?=
 =?us-ascii?Q?1nZoBRHPWB5bUKgm7uHEtQGdNfqni0EOgt5SvF1fz3KLiQLnBrmeLVNtkGT/?=
 =?us-ascii?Q?uDY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kZdaWZHq8nLhGKacWaBpAcFEB6za9qHQos7whlvJ1an+/LBw66LsNzcztn2P?=
 =?us-ascii?Q?xi4U7Vmxdi33re8bZ9mYmxsKuVqmW1u7HPK0thTZ8OAMvJLBA/n7JpZOjp8M?=
 =?us-ascii?Q?9PGdQRA8fekhGfKGUnx8F8bBNY+KIWt45O8Drkgtseam3sS67EOmHwJFFVAh?=
 =?us-ascii?Q?E7cma9x64aZVZ2AvVVe0pp+cQAz1iVGAd94C/skVAe7uqTuMRKyQb7Gy6Vtn?=
 =?us-ascii?Q?w52ouOTjtx/q1aCwoiAvbNM6yCH6QYPyKZMRqWa2er1npAl7uJ83rpfCZed9?=
 =?us-ascii?Q?Xsvz7qHkL++XQN7i+S9z/HKXC4oY/eMGkVWq2DSRSe38ZzWC7OiMuqxLWJL/?=
 =?us-ascii?Q?pTbLKp9NB7MyOKICZr0+T08rjxlBKvovnuf50TESgdnTJo+XwhMA9cN2mydg?=
 =?us-ascii?Q?XmypuVk7nwsiyFDyeuvVYNZA9zg+XC+kLxX53hgtQs9qzd1bS1WpSDByC7kl?=
 =?us-ascii?Q?/yJ1VlTs4XJSNQ2degtyncL3xMXpP8/dD6n1a4IfCxHJnH3F+vh2ZLabYSk2?=
 =?us-ascii?Q?RM2Mh40hwnU5G40+JfRB/zMtJkt3BVKxOFC5OF6dRKs+31PQfeaOqdMOvjsh?=
 =?us-ascii?Q?pQGoQRS119l8NfNtcY+df/RdZNFk5IQWDnzRXSgCKZqBJ4FKugipQ4mlyhUK?=
 =?us-ascii?Q?hNsNAm85TCBSgQS4YpggUkU8+lWN5Ms6G0po1+dcU/Um3vl2m0439ylvv0m7?=
 =?us-ascii?Q?G2vR36UUZ/AWizx6tx5Ai0hJk9DMftcHpFxQ5Iif6PkkUeirYYKV8m3WLkCz?=
 =?us-ascii?Q?otAyc9gsqtPmWhWXP/vrKvcgnHkc3c/Ddss5RTZHoxnK0PQeIDzTT8OICtUG?=
 =?us-ascii?Q?jmSzxV2/Ctw98k3sNfAuZDSrIe/4/NMVFHIX3wU5aMV7+4h1aBdNGrtGyDIC?=
 =?us-ascii?Q?UhBW+YAgilTT3ocGBxn19wTS6LU/NYwVmWnCZkzuJFCcpKC4k3EdJcrBH/0u?=
 =?us-ascii?Q?rALNSjJdIAYx/BcMFIPe9IJFZK30i52W7DUSEUGSuMzfzVksCEAMpoTNgMM2?=
 =?us-ascii?Q?qV9fT63hQFfBQY3rfEThZeJ3HS/l/3twIkhFg9v0sjruBVZJJHZ6POBJzoM5?=
 =?us-ascii?Q?8ENLlXScvTj9wnrnqTI6qgHgusaBM2bbHpWAaQEB9wsAm/udUKWcf522q1e1?=
 =?us-ascii?Q?yAftxDNnVZk+9GgFpz6zj7i8x4JaJ0bsfq1jtlTxeLs+0gjnjnFlesH0W56x?=
 =?us-ascii?Q?rQsuTzd0mQ2diJg7nqg2xdEy3HjhT29qZa7YTvZXRf5yBko7YfwvUxlaAcTI?=
 =?us-ascii?Q?cleMBs4sF7NCwIlnuCu9AFj5heKo83ye0/Jjv9RXoKZtJdlkWwaL3arTO3vT?=
 =?us-ascii?Q?5UJSunKCKdcT95+zJ4b6kBfVBBAV3bFRxVRw0KCRsjfOfz3OI6gGS8P/PleJ?=
 =?us-ascii?Q?uULgN9ZXTaEi4FuHiy5M3eHUZX6Pk8Krt93dfEwEZD9wxZGIJ6KefIVQvtVF?=
 =?us-ascii?Q?rnilRWncmLblPGkOhSrWqP6Etm5scc1wPf8Zn8nE/vFakM2Hi1EIo/t1rzVU?=
 =?us-ascii?Q?8b5tkBa/5M9y2DiNVcZMKumDgZcYnM2KvHWcnCpMnPrHCPSzk6oe6ddiHJ/2?=
 =?us-ascii?Q?H+BwjXF1uWjQTHE3eZ/KhQpAz98huU0+S6IEwB4bJMA7nayh92u3L2LDZyYD?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ef564f-3530-4830-786f-08dcabe75aa7
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 13:48:52.8177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yEEe1OHfA23ECLkRZoy5oEFxjuE1KoXNbTlRKygZ+34kG1J8ibkwZ/PX3jAIvjvylPoEnhGErbHGi4aSMYxBKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5944
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "UBSAN:shift-out-of-bounds_in_arch/x86/kvm#h" on:

commit: 1635eb4564804d324e91d78e8e5ed206e006e3a6 ("[PATCH 1/2] KVM: x86: Check hypercall's exit to userspace generically")
url: https://github.com/intel-lab-lkp/linux/commits/Binbin-Wu/KVM-x86-Check-hypercall-s-exit-to-userspace-generically/20240708-172555
patch link: https://lore.kernel.org/all/20240708092150.1799371-2-binbin.wu@linux.intel.com/
patch subject: [PATCH 1/2] KVM: x86: Check hypercall's exit to userspace generically

in testcase: kvm-unit-tests-qemu
version: 
with following parameters:




compiler: gcc-13
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202407242159.893be500-oliver.sang@intel.com


[  414.980354][T21255] ------------[ cut here ]------------
[  414.989024][T21255] UBSAN: shift-out-of-bounds in arch/x86/kvm/x86.h:552:47
[  415.001167][T21255] shift exponent 4294967295 is too large for 32-bit type 'int'
[  415.011803][T21255] CPU: 107 PID: 21255 Comm: qemu-system-x86 Not tainted 6.10.0-rc2-00186-g1635eb456480 #1
[  415.024716][T21255] Call Trace:
[  415.030982][T21255]  <TASK>
[415.036836][T21255] dump_stack_lvl (lib/dump_stack.c:117) 
[415.044268][T21255] __ubsan_handle_shift_out_of_bounds (lib/ubsan.c:232 lib/ubsan.c:468) 
[415.053610][T21255] kvm_emulate_hypercall.cold (include/trace/events/kvm.h:213 (discriminator 6)) kvm
[415.063097][T21255] ? __pfx_kvm_emulate_hypercall (arch/x86/kvm/x86.c:10206) kvm
[415.073104][T21255] ? __vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:6469) kvm_intel
[415.082284][T21255] vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:6632 (discriminator 1)) kvm_intel
[415.090893][T21255] vcpu_enter_guest+0x130f/0x3350 kvm
[415.100855][T21255] ? vmx_segment_cache_test_set (arch/x86/include/asm/bitops.h:206 (discriminator 1) arch/x86/include/asm/bitops.h:238 (discriminator 1) include/asm-generic/bitops/instrumented-non-atomic.h:142 (discriminator 1) arch/x86/kvm/vmx/../kvm_cache_regs.h:56 (discriminator 1) arch/x86/kvm/vmx/vmx.c:825 (discriminator 1)) kvm_intel
[415.110593][T21255] ? __pfx_vcpu_enter_guest+0x10/0x10 kvm
[415.120837][T21255] ? vmx_read_guest_seg_ar (arch/x86/kvm/vmx/vmx.c:865 (discriminator 1)) kvm_intel
[415.130124][T21255] ? skip_emulated_instruction (arch/x86/kvm/vmx/vmx.c:1775) kvm_intel
[415.139821][T21255] ? __pfx_skip_emulated_instruction (arch/x86/kvm/vmx/vmx.c:1715) kvm_intel
[415.149853][T21255] ? __pfx_kvm_get_linear_rip (arch/x86/kvm/x86.c:13256) kvm
[415.159211][T21255] vcpu_run (arch/x86/kvm/x86.c:11311) kvm
[415.167028][T21255] kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:11537) kvm
[415.176327][T21255] ? __pfx_do_vfs_ioctl (fs/ioctl.c:805) 
[415.184065][T21255] kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4440) kvm
[415.192450][T21255] ? __pfx_kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4394) kvm
[415.201351][T21255] ? down_read_trylock (arch/x86/include/asm/atomic64_64.h:20 include/linux/atomic/atomic-arch-fallback.h:2629 include/linux/atomic/atomic-long.h:79 include/linux/atomic/atomic-instrumented.h:3224 kernel/locking/rwsem.c:176 kernel/locking/rwsem.c:181 kernel/locking/rwsem.c:1288 kernel/locking/rwsem.c:1565) 
[415.209117][T21255] ? __fget_light (fs/file.c:1154) 
[415.216411][T21255] ? fput (arch/x86/include/asm/atomic64_64.h:61 (discriminator 1) include/linux/atomic/atomic-arch-fallback.h:4404 (discriminator 1) include/linux/atomic/atomic-long.h:1571 (discriminator 1) include/linux/atomic/atomic-instrumented.h:4540 (discriminator 1) fs/file_table.c:473 (discriminator 1)) 
[415.222864][T21255] ? __fget_light (fs/file.c:1154) 
[415.230119][T21255] __x64_sys_ioctl (fs/ioctl.c:51 fs/ioctl.c:907 fs/ioctl.c:893 fs/ioctl.c:893) 
[415.237407][T21255] do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1)) 
[415.244400][T21255] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[  415.252801][T21255] RIP: 0033:0x7f12912f8c5b
[ 415.259801][T21255] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
All code
========
   0:	00 48 89             	add    %cl,-0x77(%rax)
   3:	44 24 18             	rex.R and $0x18,%al
   6:	31 c0                	xor    %eax,%eax
   8:	48 8d 44 24 60       	lea    0x60(%rsp),%rax
   d:	c7 04 24 10 00 00 00 	movl   $0x10,(%rsp)
  14:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  19:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  1e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  23:	b8 10 00 00 00       	mov    $0x10,%eax
  28:	0f 05                	syscall 
  2a:*	89 c2                	mov    %eax,%edx		<-- trapping instruction
  2c:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  31:	77 1c                	ja     0x4f
  33:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  38:	64                   	fs
  39:	48                   	rex.W
  3a:	2b                   	.byte 0x2b
  3b:	04 25                	add    $0x25,%al
  3d:	28 00                	sub    %al,(%rax)
	...

Code starting with the faulting instruction
===========================================
   0:	89 c2                	mov    %eax,%edx
   2:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
   7:	77 1c                	ja     0x25
   9:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   e:	64                   	fs
   f:	48                   	rex.W
  10:	2b                   	.byte 0x2b
  11:	04 25                	add    $0x25,%al
  13:	28 00                	sub    %al,(%rax)
	...
[  415.282007][T21255] RSP: 002b:00007f128e7ff5e0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  415.293025][T21255] RAX: ffffffffffffffda RBX: 000055cecae83b00 RCX: 00007f12912f8c5b
[  415.303708][T21255] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000c
[  415.314228][T21255] RBP: 000000000000ae80 R08: 0000000000000000 R09: 0000000000000000
[  415.324787][T21255] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  415.335326][T21255] R13: 0000000000000001 R14: 00000000000003f8 R15: 0000000000000000
[  415.345809][T21255]  </TASK>
[  415.351386][T21255] ---[ end trace ]---



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240724/202407242159.893be500-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


