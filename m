Return-Path: <kvm+bounces-35504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F185A118AB
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 06:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A07F188A193
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 05:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457FE22F3A0;
	Wed, 15 Jan 2025 05:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y/cMQDsZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5F322E414;
	Wed, 15 Jan 2025 05:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736917246; cv=fail; b=P0J4ikPlFr8EqPlRY2FdB56g3IJx/y92kQMv2onOHhL9AtBLxD70+mfqWqOX5Zy0rljK4GOFZ6al135DHTjl6YqN9F3WTUlyj9yNlrpPmVdChn2wZE/LMzkSJevM8NvmdLv66P1CvdgmqQVhwGtLMg2H7tiwlLgKM1OSVI2fc+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736917246; c=relaxed/simple;
	bh=mgxDes2bUPMur7JAkM73x2qx4PgP0zs7DW1mbgL2wuQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q3WFE+huuOvDIkjxmuQL538Davp8QHj6LC01oUpFld67XzEnalH4ibsKS6nZvzUUV/mBnxJHjbhNzjAyDqaCe0TUwEsosTDK+9L7COhfD+eKoOXsM2Aoq5IRpXsr4jr7Kxy/Na8YYMELOA8jon0dzr24E85LmkRR/S9uQ7eBXRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y/cMQDsZ; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736917245; x=1768453245;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=mgxDes2bUPMur7JAkM73x2qx4PgP0zs7DW1mbgL2wuQ=;
  b=Y/cMQDsZF7ScWIoqw8oE9Rdqk9ePkDwKiE0yg08V6T1F7htRFzOUfGUj
   5fQDEXHCAw9iuC8xCdrl7ugsO7xoZd7l84U/RVuhdJy+0Pexki4oUcs3S
   I2md2oorid7oCcfXpqgrUqt0535Z5Wl3dL9zQyId9YrGPfvqvmXQXDNo2
   afKsK/7onCJBnDIBe32fxM7lIap7t+ZkQj1pgPYNCzWra/OzUdONLrnwY
   00ObHs/0/u776dpGg93uvvIL0/WsTzQKYr9CjwAe2Nu78qFxp/cTiaMit
   NqCznrLbxLtzbZttPsiMr3T2XS5JgRj9bhSF0ueo8udzyUKZUtng3g1yX
   A==;
X-CSE-ConnectionGUID: QTTlv8DQRhyxmiBCuwy0qA==
X-CSE-MsgGUID: Qb+8M83TSmCFVktJq8IB0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="41002757"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="41002757"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 21:00:44 -0800
X-CSE-ConnectionGUID: xRTDNf3AQ1aCThgQpMFCGQ==
X-CSE-MsgGUID: DsoOBagbQ6CQFIwpcSe/kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105894222"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 21:00:43 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 21:00:43 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 21:00:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 21:00:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AbYAxzQLkNTSeWaNCcKcP3k0XpQLBKu98/mO9A4J19yANMqr5fQ3Zo+rlXd+A0d2hB2ejGJjHnyEneBiphz4vgT3ROPFx2AghsCJJ+QhxtW+AuW1qY+GPdescB4rGTDdSaRXmgrXQO6kQJbERjDeh51iWks8/UE4MouBKRIvPaEmF5yKFuDEepoEXO87GaMzNf2P9rqBWeds7vbRB5CyiW/oOml7Q/GDHMs8XAOwsY4KCC1HeLww4DcS5DXz6JXCvKWfcpVDh53nLsL3ieLZzPaS8W+F6bx0GKprw+i3BxPn0eTQNVgKBuMPR6DOK6ghgG9aby7XwJlu+j5ICkxung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haSgLKvt3O5vIHfm/k+LFUjbYMsz2youFlAHZWxEp+Q=;
 b=UloyIl84GNn2t45QF3MJmvEli77gxYWoFqwRMu8ihAcfsiQK0SKodMwo+gYAK7ZrQ6MJxLkV+5/CBJRi1t2I30mXARdib2f3Jin/FFpjZ9cXGLmLMmTcmXzqUQEerh4mL6aIQlx02EDUDsDFUFQPmrK38OO7E0k6MsiPPiTVjpuzM8vCGKHHi1VetFJwhM/kuzSfmiSIikn55IxrCTImxYwPNX7si+SbM6T5Z/H6xH37a4tOF+HdoRsQC/UK/G/m5UWLR6Ssl2hRR1BAoe/qxreSrIiVD60d963/34ZtznigNXEFeD1+Jkp7+WmmKPIpQ3+grzGGI+VBZlCSqkK7dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6609.namprd11.prod.outlook.com (2603:10b6:510:1cc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 05:00:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 05:00:22 +0000
Date: Wed, 15 Jan 2025 12:59:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH 1/7] KVM: TDX: Return -EBUSY when tdh_mem_page_add()
 encounters TDX_OPERAND_BUSY
Message-ID: <Z4dAru7SlXKfckZx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021050.18828-1-yan.y.zhao@intel.com>
 <9b34f2a0ce2b530efbb12c03f1b40ccf33b318dc.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b34f2a0ce2b530efbb12c03f1b40ccf33b318dc.camel@intel.com>
X-ClientProxiedBy: SI2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:4:186::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: 7815c800-30d8-4651-3cff-08dd3521841f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?++AKV/zlsIS+/tO9bTFei9PgsUVmerPiWm7FYeZG6lmIZsheL6PvbQr7v3?=
 =?iso-8859-1?Q?x1AfuBdBTl5t8r6MTwkyO5NjgCbTBURc+D2yXxMS+S5F1PMc8xKRE8hIuJ?=
 =?iso-8859-1?Q?YtUJQdlOOc8OyFmHtCqcnuYiTxGQPhmgGVB593Cr8ecHM/z5UQ5VffQXjA?=
 =?iso-8859-1?Q?yL0jz7TRodKlsbxvhk/j9YxccQGsIYA5VjUXxHIG5/Vf+UKUe7i9yNuuQX?=
 =?iso-8859-1?Q?2NZM5u6dLBpVedZ/KQAtZngV3KH41onfKrSFHcEh2H7ZoB/IDOK5s78rYa?=
 =?iso-8859-1?Q?AVBH6dFl+pDI4XELcRfHgfR36fAr1d++SN0Tn5fdWsN6YtCp1oYFM0BvwO?=
 =?iso-8859-1?Q?4LXZvjq3FVvuSYuyGZfTmh+nuXwZg95hnOTjpDwmdd6PonvJHynuIwcrEl?=
 =?iso-8859-1?Q?SdBcMF9Sna5ja0gdkKrqZuX1BVJsleVF6t/07vI1Gzmx4guLxNNAj+SuHe?=
 =?iso-8859-1?Q?dlW5QlgNOAOVhh5glgUARw5xWCVjxcjj20woLVwD7la6JnNUMf4ezzJBn9?=
 =?iso-8859-1?Q?tUmjehWGo3ADS7J3RYinXnXFp409ZHwdmIhTeJq6JEMeZjKNIBWpVBQZ7Q?=
 =?iso-8859-1?Q?Kn23bQ3VpbJ1DHfpyUe8vTif48orrNMAWxawzBoSp5ijbjFioGKTmkVnqq?=
 =?iso-8859-1?Q?7WYCZPY8m3XgRo/om25ph0oyrZjvehirbObPId/CAc7ollW1gqU67zpmFU?=
 =?iso-8859-1?Q?A9WLRJ1L/oi6QcJWbqZuKB8WokWvoKSsInUtb1IQodQahkzmiRnRJiC32s?=
 =?iso-8859-1?Q?LhijdTbfVE2omQHfN9sLjpPuUs/TuLPAOVpBIiDcD2jxbzUzq9jG8bRC7F?=
 =?iso-8859-1?Q?pmHfEMQHK9EEUyxn3psFgYCeeMmPTobpfI6S1ve5yzqVAdUembBeRPCDH4?=
 =?iso-8859-1?Q?AZjvCO9IIBW34T313nrUUHLpMdJPQ0yuav/i+m2K0Zh4WxQbKAvZQ4jjTX?=
 =?iso-8859-1?Q?OFxAYO7mKe0z/vOAQTKxMGuiztGgJq/n1rRHdMGOoZcNkBLBbGeD6mGTMn?=
 =?iso-8859-1?Q?r/g7MmpAl/ihX2ttJe9iAmnnKM03KWJGK121JOuQ2QFdNU1lsLHiG8kCtV?=
 =?iso-8859-1?Q?pwBfn2YEzyNAULU9vqQUR0eKzRhBj/avyojau8y3aaImnLLrXMmQ+1KVj7?=
 =?iso-8859-1?Q?P5BU3zAoc2UqOVHZ6Q5QWfsQSjfWiCl6t4z20SLzYbaZhYeO9Iken60mz2?=
 =?iso-8859-1?Q?1sz6+KXjs1AYqw6OJvGdGLzbASOkPvHMhtbPF5C1GqgtKfUEZpJWn17LgW?=
 =?iso-8859-1?Q?Fk7YU5Jd45plog6enZZ/llbI/l80s72F2a3U7wlqgkvHxjIBF1h0sSbh+P?=
 =?iso-8859-1?Q?NJIKcgPr37DG65iftHwRdgr9cUteRFMeArxvDtmi2Mf6e8KtmsHHAXYkKE?=
 =?iso-8859-1?Q?Klw5w3qDeAbcChnEpT0JWJhn8fiacn+WcpL8sd7Y5d3TauhZyhbhJDuHxm?=
 =?iso-8859-1?Q?EoldQZpHgfRG96b1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?diZZoCHQpBo91KnIrXJc1OT6ztwd70wKVow8PLddPoEnI7h4PipAAsWo+6?=
 =?iso-8859-1?Q?LDSXzkHTVwsUxx9woTg1lsZD79ykhvWtgR39kfnJw98kn6iu4/4Knzy2P/?=
 =?iso-8859-1?Q?SvDKLTyvdnW0dsAxx80Ke1LTCpJZfe20yKqNzfUlXGGZOz6jrECMC42Df4?=
 =?iso-8859-1?Q?RyHp5eKh73BdUf62+2D/USUVnwgEIgo5bDLBr7XBBP6g+jS4cbEWQMBIE3?=
 =?iso-8859-1?Q?Va4ovjWeeJVaG4nOf+sieosdKOkXLwzhBZWc0P/26EZAYZCKJAZXpi19on?=
 =?iso-8859-1?Q?gTM+xudhqPpt5/RQAfC/9/S1/xEkZ1vc+68Y4kpHwN7zanhPAXs6JCLxvP?=
 =?iso-8859-1?Q?6Nfy2s05de+yjOb6eAx27ZAK6gwHIFJA1goYjM1irzjCxgUaEty5+unVn2?=
 =?iso-8859-1?Q?l8Zlp5/kHHp2T95lg6ICH5DBaCGZjDxbl8I3gw4QB7vrsVIJYJklpuYpcx?=
 =?iso-8859-1?Q?LM3ekXzAl8BtSk2FIHxppQJ96pD8M9FOOAO8N46aGuh0Y9vsAdDYmBf+qt?=
 =?iso-8859-1?Q?A89+nCi6NLZotNwyfh8aLw1soU35JcNT1IeIrU8yzo+IEbn85fjz93GT9O?=
 =?iso-8859-1?Q?4UF5eu8RerlvCl5z4GQKnZe9HM0RJN9hr9B7kHsyPqnKokTHTHGDGVdOnL?=
 =?iso-8859-1?Q?AMU9VOy0volxe+4HKx4Xj/MMyiu3D+4KBWGz8Ebc2djpffA8bHQSuNa2Bz?=
 =?iso-8859-1?Q?0DDrfmkOAA6EndTBRydpv6miNHZ/opUI55JnsBwfzO930faN+Y+/1THkDy?=
 =?iso-8859-1?Q?nImmAOBU0xpnLac4KwRwG5hjUVNzUYXwYHwj64JBH21dsd+vS+LY9Kd/bO?=
 =?iso-8859-1?Q?s0+HEUZ4Ua8hbEku7YsW6Lzkw5HIMQ1y1l6Je2UwBb22vK5kstw3mPSXs3?=
 =?iso-8859-1?Q?U8oUjbV6D/92POCFlxiIQVPWW9PqP1dIX3N4wrzUbzGwIWF0kpBRWOANJp?=
 =?iso-8859-1?Q?ch2O0oK/raN3C2uiPn+OC64bQIHdkxlEvwUst0IXAziAzPq0JgUSn41h0G?=
 =?iso-8859-1?Q?t44wnRFoe3b8uAdcjsTN9XdO1s00nVbK4Msy/sj0e5sEJHqee5Qi4TX3+Z?=
 =?iso-8859-1?Q?FC8y22d+2SAk9mawEmC5pqVbSw3FwE8nSaHy5m+JRqz4OrGb/KJJjRh5ov?=
 =?iso-8859-1?Q?eOaKk101jYwRknjDpg5AAs7R9su+YLdHSvfziWdR1Xq790/ljP8FcPwlQj?=
 =?iso-8859-1?Q?ZM3kCwFO3tWPaXJ3VHUd4cnWiw+nV7wZEDilpdxO3wlkTIBlh7tRpUsnzg?=
 =?iso-8859-1?Q?VRduAWcLJxuZX7Q6nyschKTCNrMwrMM7DYQz1FSlyCnd0PMGXrZuSOy33Z?=
 =?iso-8859-1?Q?aFACal7ZbF3swy3N21gqtfICTpTm0fh/19ZMH8npNWpdWbnejJqrcZCjS2?=
 =?iso-8859-1?Q?g7OyNqwgTUXiivFhpGojeH67BJ7Q271m6+VJP74LGyy9TXcVELbWUnSfDS?=
 =?iso-8859-1?Q?A56EnbVX0STnMFnZjB+Rkbhc8kBGDkbvCd7VIaTKdsA/Kf9y5e9QFYrDWC?=
 =?iso-8859-1?Q?Bnlu8bv8DSvLJIj7mj5YlDSdqiO3di2UaWs7cBtn5Y8f3HX3n/K7JH/Jlb?=
 =?iso-8859-1?Q?EBjb0pJRUNxQm7N2u4OqcjRUp+pq5nhMS6g5U5/rjxS1P1A0plIJW7m53O?=
 =?iso-8859-1?Q?LtJnYmxcjd+oT0JEKFFEgJJea/vk6OBC38tmjoifdMW+G781nwxpuNbg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7815c800-30d8-4651-3cff-08dd3521841f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 05:00:22.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7mr+BGiziFPGoKbimwIQAFdy9Sc5dtFj057qy8Iu1Fy1cS4QkDfH+F79OtsKytTaGooucBzymteidCmASobJPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6609
X-OriginatorOrg: intel.com

On Wed, Jan 15, 2025 at 06:24:34AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-01-13 at 10:10 +0800, Yan Zhao wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index d0dc3200fa37..1cf3ef0faff7 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -3024,13 +3024,11 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >  	}
> >  
> >  	ret = 0;
> > -	do {
> > -		err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, pfn_to_hpa(pfn),
> > -				       pfn_to_hpa(page_to_pfn(page)),
> > -				       &entry, &level_state);
> > -	} while (err == TDX_ERROR_SEPT_BUSY);
> > +	err = tdh_mem_page_add(kvm_tdx->tdr_pa, gpa, pfn_to_hpa(pfn),
> > +			       pfn_to_hpa(page_to_pfn(page)),
> > +			       &entry, &level_state);
> >  	if (err) {
> > -		ret = -EIO;
> > +		ret = unlikely(err & TDX_OPERAND_BUSY) ? -EBUSY : -EIO;
> >  		goto out;
> >  	}
> 
> Should we just squash this into "KVM: TDX: Add an ioctl to create initial guest
> memory"? I guess we get a little more specific log history on this corner as a
> separate patch, but seems strange to add and remove a loop before it even can
> get exercised.
No problem to me.

