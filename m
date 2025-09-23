Return-Path: <kvm+bounces-58518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA058B94E7B
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 10:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F109483323
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 08:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CFD30FF2B;
	Tue, 23 Sep 2025 08:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HqwJ3fGK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF7D2DEA79;
	Tue, 23 Sep 2025 08:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758614614; cv=fail; b=SpqiPAm86eQv6PNgzHRRAgbD25g+MYA145FDDrnWyrcEb0WXXMu5dMaYwmkK5Skg/rOTunW854r4cxG80k1vN4hfSh5enxRWOikKgZOXhmrFy/GEm+8SINQ9XYYzhUWq9YqmmVu1hCwG3Ln+hi65YLtWwX/CdvjLcR5cP9cnz6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758614614; c=relaxed/simple;
	bh=YSxMHWJNY+6StEe/1HFvuNZvRnG43W+0hdu2IXQLCHs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Pmz4ciG2UP60gafd7DBqCvjgbsDCLH/Vfjo1EflKwHs2BXgyVyxA9A/s4Bn23pYwgH/8RuihYH/lJaHBddNyxzYguSW+FL28Rtf1mNJ+blD5P+s0t1B7KJsaQAYZvdBuThphQwmx7i76hxzj2p4oBmPODGtbQgE4RQ6TZCO8Gtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HqwJ3fGK; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758614613; x=1790150613;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YSxMHWJNY+6StEe/1HFvuNZvRnG43W+0hdu2IXQLCHs=;
  b=HqwJ3fGKvVZVRDQSPfylp/M4qpaIu2UMi5XdHd0Qv0VY9rF/5eAoXNkf
   Y+tx22HwH4unzypPJdeu5VZtoLN4s7LAo4hwhnwk6oexHAr4wCEFR3G5e
   iMnJ+CAwTlBzlhYLNjfEIfwbjBCWrtmFV/A4mvnHt93spL0qwJGJ7VrOT
   SjaLSjg9fUSLFhkv+qCeDyPqfFNy9fIFWo45Xp+mY2XL9JvKf+bYWZvVn
   M29DgYx16suuH5LB0VfpxeRvbw+U1PdGWKARFRmkutrQ8camfOiriwfGJ
   Wx5rQu+ca51AA63VYR1cLjD8VUVOI2SWDhwmmK7+8mVlF7T83eJSxJTv4
   w==;
X-CSE-ConnectionGUID: SQkhaTpFRU6KW6vmQxGLyA==
X-CSE-MsgGUID: 7aeuKSg1RtiVsYZE16qxTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71509069"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="71509069"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 01:03:26 -0700
X-CSE-ConnectionGUID: FyhQ1fm1SI2oJmpiU2paSA==
X-CSE-MsgGUID: 2ACcwZWHRramt5JkI/F/VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="175989822"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 01:03:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 01:03:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 23 Sep 2025 01:03:24 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.1) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 23 Sep 2025 01:03:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFZUYcoeoKgGq0aR7Ykuxnl4LAmHjXEoeJPypY9Yt1cAVGvWSnKfNY2x3Wmg2XfL+YaqEyZloPBvJZXrr6s1XzfenoTDr6ZyP6NsGm86wpmM1sjwznKMqE2+RpKvZWRQfNQDbwJ8yfUps5CIay1TXpttmLS0zhiEPym5H7HQi4uZ/ZR2zuWphdY2PTe9MT5hQvs+2Tv0YSkqzRLYpV2cHcge6IxcEicEOuAHVI6krROkJ2Vy8uGN3i4fyIhGn30ErHksHn/aD0qoMSr2UfcF5rCMtyotw+DIaVXmb7MklFhjOMNgBHz687U6wkbJjLQdFsgLdwIWkXwa/mVG/1TClQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZpGSl6Jd+jr6hQy9zxU6WvwTIkRiEKnszNyQ/xaZds=;
 b=syExC7UGCHbx4FXSTG5G4ena7ewwVDwmH6HL9oqZ2Tfua0U3uoKGaqfNnId9+B4hDnXGvwFooU3f9HISqEoNPb3eZ9RGBHrkMKje2obhmdQAgwo4e5u/kob7JpUM5MJLMHYbg45MfMSlopnkVy/CMl5R8jK8NxRLF6zXHc9+nOVorLFcbjdskuSj02Mc3w0rWPuJjiFE1PQ2gbSgF4QXEkxRXA5dNjtkxhugdLUavu6otMlO4GHygqLwZezGZbWd9Cto/WWuY7OGI2quJ8fOS35KVEVqxzmp4FFosMBYJuo4/qCqhDGQQNmBgYPPEyG21JAIfpNOej4gyzCSIjvy0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7971.namprd11.prod.outlook.com (2603:10b6:8:122::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 08:03:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 08:03:22 +0000
Date: Tue, 23 Sep 2025 16:03:10 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 45/51] KVM: selftests: Add an MSR test to exercise
 guest/host and read/write
Message-ID: <aNJUPjdRoqtiXYp+@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-46-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-46-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7971:EE_
X-MS-Office365-Filtering-Correlation-Id: c76ae23e-8050-4821-e356-08ddfa77aa00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EUG+DtApm9s5rLfm7c7/f5dcbchTNgx6BVRD4sG2mg1FoB0351wei7NdJpj+?=
 =?us-ascii?Q?nJVsIOKARolk+LPS9Ue9Yp56EwEQuSsja8c39SXka+sTnzZW+zIeI5YGS8b4?=
 =?us-ascii?Q?EDru/I9VlmIh4hFncPz1ivU0giQZK1Rw5scj0W77OtABF2V5F8Q3e5P8E7Ni?=
 =?us-ascii?Q?a6KgvU13jd9gnKsdNcbxk0tB+FlCnx1xtiZZsOx62Ea3DrOlVAp7mcBm3j6P?=
 =?us-ascii?Q?RFaYK/7yMGfb/TV5AQicnklfT7fLjoYJi1uPOGLTv5zuPQxXZQxnIcrki66Y?=
 =?us-ascii?Q?c6yD121aT9BLswa7NldFduukaEjN+upvEavhpUmgEiHpSnQyTNBLMyEN7/lM?=
 =?us-ascii?Q?4l/TfPslAkTD91u8mg57tz+KarXHFyV3BASGwEgX7CrY5b4lMzQ//e3S//x9?=
 =?us-ascii?Q?OHDR4CcfEbcZCB4Zy29lUcwPNYYCdr6AUm0GhYszcKQuVrW+X9rsXkceKfQL?=
 =?us-ascii?Q?lLeGEmgHmRHgJrjz9Ui0PIts59zFsnslCljIdj3dvWwlRU7cFnhnkLbBf2dx?=
 =?us-ascii?Q?B4Dxm2lY0iYMW4f3UHk3nwaPEAZg1avFRvoKvR+o5D11J6pkP27LhxumDle/?=
 =?us-ascii?Q?QtylfdwZjjJsQG80Ny3jJecXFagGhUEElMs+8pv92RTt78+dqaKM92o9P7f5?=
 =?us-ascii?Q?NrB9j9qbQlO7kf0LffJKjJ3TlY9pcED/EZG5IK+hoiZmYbzZgaw25SHgSknx?=
 =?us-ascii?Q?CHF/KDuhybQJSBkyuYhTSFJb47UCDksBOCuNNTVkhsPMYnor9U+rxn0TljJk?=
 =?us-ascii?Q?LMuA3wosqZV2SpYyW53vUW28djxc+0qgu+8et0TCQ8haeVJeRmSWEWqZJ2Ew?=
 =?us-ascii?Q?tJkympFM2qWxv5xEHnPpzh2oLsN6uxr9IJXlgYG9XfbTOzulYCsSDn8e5rhl?=
 =?us-ascii?Q?HsR40GNlJAAqaXnP+rz4HIF3wGG/VTyWoex2V+4MjvSO7kuc0yQaS2N1HhYb?=
 =?us-ascii?Q?sMc7jbnWrQYRDa5Ueea+5PK4fCHY5ZVBpktEoXEoNwybt8//L+1k+XvimGiY?=
 =?us-ascii?Q?xckWiVfbtM+ZLYt5qWzIYvw4evCErpgd7OmknXIi/EaZ2E4dn+jxU0YTJ1wH?=
 =?us-ascii?Q?tY1HgRkFovGBzqqDWQIpbGPLWQXlsjKtMCorQ2i4art94+pI+AOTEWM97Unp?=
 =?us-ascii?Q?YnFShzKhdCpHp3HNbcVXXRserMlXugMW8WAFBNR0CILZL6O8djqm0l8aSK94?=
 =?us-ascii?Q?lICC07a/3zHlFKmd7JUgbt5wIfGEA2wM+JpfFSLi7+5wvMR2vFGbn3KCOzPr?=
 =?us-ascii?Q?nQmA2rqTAe6RJyw0Prc4E4jJG5jlxELEOghTManFquU6teS5DbHtx6g5MYVO?=
 =?us-ascii?Q?LW42+wMVC6pqTpK2kinxjZmzBSTPZvnK+/c43lTadf2RH78hFg1cMKtBaOSk?=
 =?us-ascii?Q?6wegVpQgI3XVR7ofJVsZfKN5XFJjBvtQg9FktABWbGIPBS2op7EmG9gjpav9?=
 =?us-ascii?Q?sJRfy5hNivk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vdL3BpZU2cQFMtU3VxAsNTsRq/liSTXazhKq0/2ZkxmHfnl4hZmRRZDOuaVq?=
 =?us-ascii?Q?ZsL2tS+/VQf9D7722SsbkDfM2FF7Svbx4RjgN5Q4RBpXxtHQVXHTQWiEPDVS?=
 =?us-ascii?Q?tgqkW8yvplp9A2AdFPWKXwZizKz3avC+loCPvBVMWDsyt4/YspzXn8MhJA6j?=
 =?us-ascii?Q?d2kQNEDlbLIh7+x7YF6xPhMn6EIzTVksqpY7m+BWtMwosBw5xH7gEU0kZS2w?=
 =?us-ascii?Q?u9ggH39GIvqX5Jv1uTtZYzQFSG/ZTrwhhVJYcCLFHZuFttv9AOOvVRQ4irsm?=
 =?us-ascii?Q?ySatYKwIhtWXaiyIQGrslesPfngmZ0Pj/wI7+BlRc/gKAg1IoRDCjEOoJ+bH?=
 =?us-ascii?Q?+62LqcrX/lUAdV83xh/PVfQI4808p/a5AZz/uo04TsbsqBRKunKyWg8j17pI?=
 =?us-ascii?Q?yWW6H/p2xPvFd2XKxQCHdoU6KCZEAGfkNRmR+732kd4MiZvjhHXsUDFMwOwL?=
 =?us-ascii?Q?LvPwsONLba1Bu99e3AruNpA7pRaE7n35gDUzyLXggzIy5iZjtZRmWzqgAPEW?=
 =?us-ascii?Q?EVCr5DPmghZrtC36/cUOMacyAT2u2IkiMdWy6iXwIYRrmJzeaXZn5h0uk1ut?=
 =?us-ascii?Q?n1yOGaH2W8wISf96DfYOLbhhpOlFyDOzSNvxHDRIsetPKUZBy83mLvGU5xS/?=
 =?us-ascii?Q?gLw7GKNixqVmcFWejt1Zq2Y0I5F3KrXiYnprPQPFZWj6VpbUvo4A89IPvK9T?=
 =?us-ascii?Q?8AieuOcMaG1P0ie7GHAi4k5/2ItU0m53V0PW1pttCDvnqyZv0jVwIDogChdV?=
 =?us-ascii?Q?B6CRlr8mvMojK10JfM6vrlX10zA0mDJKbHxBUVlfWxZ8asMI+yhri+JrT9/P?=
 =?us-ascii?Q?c7qxGxF3Z+x4f7Zj10z40QWPg6rj+lCji3c5o9t72uMufABAwgohhETJCJRD?=
 =?us-ascii?Q?aTLENOuXBLwI5Luonmo+NZBxJcq/4EaeOBowoFtCFgzMnem6eBvGq/qtzhFb?=
 =?us-ascii?Q?gMVr7fWj76HpvHI1GzxIrit7GG0B1DzFYtqHhjBTnsgpqhve55EJKgTi0Hgh?=
 =?us-ascii?Q?SWnoTpk0wQ/Mzeh54ukHNYtvJcEi3cyXVRTlttu54Sh5QkTxX9M3215EdQkN?=
 =?us-ascii?Q?WuAtNGb7kUdTwUMKi4GDrEHlcldFzrQLFpeIxCCOuO4y327OJSiiLgT1uHi9?=
 =?us-ascii?Q?TyJiKnnGxbSPbE6o2PfZBQPRP6yogEW/rjTbEAtu9bcvXKd9H8jMeWeVFmLv?=
 =?us-ascii?Q?SwjIknHvhJDZ/166nVp4Aw/v8+DiC6aQXF9ipXZtIq8KggbMilLOhmYjMKXY?=
 =?us-ascii?Q?txuCeGS4ClmSl/ylHwH+giRcLNx42iu4ut7PG5EkCns+gqdZodMJDXf4PXgo?=
 =?us-ascii?Q?bx47W6rMmqFAD/8DC5tx+1ZpfXhNUrG7OddwojVf7vgP/ED82nE1KahJarlL?=
 =?us-ascii?Q?31jJ0rJw80nfX8yWtHY9BRxcwj+1laiGjvEROuNIeRjFc/Wu2UXReqiZn98t?=
 =?us-ascii?Q?jz3+bPLRbSuLJhbkvmHwZTmQQCesxHkaGLJvPhZ222jB7dN42JntGdYoGVEn?=
 =?us-ascii?Q?yIEcE5t8PvASJKReI/OiZj6BTm9nTSXFR3+2GVf6qIeI/QDsoNrQC3icJ5hW?=
 =?us-ascii?Q?uRRq2TfjFifHy6T8YLHP6T1IJ3Kdrq7L9BEKy34o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c76ae23e-8050-4821-e356-08ddfa77aa00
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 08:03:22.0841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwmDXqcwhcHN20wNK9VJzfRSIBLPqmNc2ZX7/FJMtzhBR23uBj7gOlIUFClrnPH3+JUb2FXT061Pha/1nbtlXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7971
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:52PM -0700, Sean Christopherson wrote:
>Add a selftest to verify reads and writes to various MSRs, from both the
>guest and host, and expect success/failure based on whether or not the
>vCPU supports the MSR according to supported CPUID.
>
>Note, this test is extremely similar to KVM-Unit-Test's "msr" test, but
>provides more coverage with respect to host accesses, and will be extended
>to provide addition testing of CPUID-based features, save/restore lists,
>and KVM_{G,S}ET_ONE_REG, all which are extremely difficult to validate in
>KUT.
>
>If kvm.ignore_msrs=true, skip the unsupported and reserved testcases as
>KVM's ABI is a mess; what exactly is supposed to be ignored, and when,
>varies wildly.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

<snip>
>+/*
>+ * Note, use a page aligned value for the canonical value so that the value
>+ * is compatible with MSRs that use bits 11:0 for things other than addresses.
>+ */
>+static const u64 canonical_val = 0x123456789000ull;

...

>+{
>+	const struct kvm_msr __msrs[] = {
>+		MSR_TEST_NON_ZERO(MSR_IA32_MISC_ENABLE,
>+				  MISC_ENABLES_RESET_VAL | MSR_IA32_MISC_ENABLE_FAST_STRING,
>+				  MSR_IA32_MISC_ENABLE_FAST_STRING, MISC_ENABLES_RESET_VAL, NONE),
>+		MSR_TEST_NON_ZERO(MSR_IA32_CR_PAT, 0x07070707, 0, 0x7040600070406, NONE),
>+
>+		/*
>+		 * TSC_AUX is supported if RDTSCP *or* RDPID is supported.  Add
>+		 * entries for each features so that TSC_AUX doesn't exists for
>+		 * the "unsupported" vCPU, and obviously to test both cases.
>+		 */
>+		MSR_TEST2(MSR_TSC_AUX, 0x12345678, canonical_val, RDTSCP, RDPID),
>+		MSR_TEST2(MSR_TSC_AUX, 0x12345678, canonical_val, RDPID, RDTSCP),

At first glance, it's unclear to me why canonical_val is invalid for
MSR_TSC_AUX, especially since it is valid for a few other MSRs in this
test. Should we add a note to the above comment? e.g.,

canonical_val is invalid for MSR_TSC_AUX because its high 32 bits must be 0.

>+
>+		MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234, 0, NONE),
>+		/*
>+		 * SYSENTER_{ESP,EIP} are technically non-canonical on Intel,
>+		 * but KVM doesn't emulate that behavior on emulated writes,
>+		 * i.e. this test will observe different behavior if the MSR
>+		 * writes are handed by hardware vs. KVM.  KVM's behavior is
>+		 * intended (though far from ideal), so don't bother testing
>+		 * non-canonical values.
>+		 */
>+		MSR_TEST(MSR_IA32_SYSENTER_ESP, canonical_val, 0, NONE),
>+		MSR_TEST(MSR_IA32_SYSENTER_EIP, canonical_val, 0, NONE),
>+
>+		MSR_TEST_CANONICAL(MSR_FS_BASE, LM),
>+		MSR_TEST_CANONICAL(MSR_GS_BASE, LM),
>+		MSR_TEST_CANONICAL(MSR_KERNEL_GS_BASE, LM),
>+		MSR_TEST_CANONICAL(MSR_LSTAR, LM),
>+		MSR_TEST_CANONICAL(MSR_CSTAR, LM),
>+		MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff, 0, LM),
>+
>+		MSR_TEST_CANONICAL(MSR_IA32_PL0_SSP, SHSTK),
>+		MSR_TEST(MSR_IA32_PL0_SSP, canonical_val, canonical_val | 1, SHSTK),
>+		MSR_TEST_CANONICAL(MSR_IA32_PL1_SSP, SHSTK),
>+		MSR_TEST(MSR_IA32_PL1_SSP, canonical_val, canonical_val | 1, SHSTK),
>+		MSR_TEST_CANONICAL(MSR_IA32_PL2_SSP, SHSTK),
>+		MSR_TEST(MSR_IA32_PL2_SSP, canonical_val, canonical_val | 1, SHSTK),
>+		MSR_TEST_CANONICAL(MSR_IA32_PL3_SSP, SHSTK),
>+		MSR_TEST(MSR_IA32_PL3_SSP, canonical_val, canonical_val | 1, SHSTK),
>+	};
>+
>+	/*
>+	 * Create two vCPUs, but run them on the same task, to validate KVM's
>+	 * context switching of MSR state.  Don't pin the task to a pCPU to
>+	 * also validate KVM's handling of cross-pCPU migration.
>+	 */
>+	const int NR_VCPUS = 2;
>+	struct kvm_vcpu *vcpus[NR_VCPUS];
>+	struct kvm_vm *vm;
>+
>+	kvm_static_assert(sizeof(__msrs) <= sizeof(msrs));
>+	kvm_static_assert(ARRAY_SIZE(__msrs) <= ARRAY_SIZE(msrs));
>+	memcpy(msrs, __msrs, sizeof(__msrs));
>+
>+	ignore_unsupported_msrs = kvm_is_ignore_msrs();
>+
>+	vm = vm_create_with_vcpus(NR_VCPUS, guest_main, vcpus);
>+
>+	sync_global_to_guest(vm, msrs);
>+	sync_global_to_guest(vm, ignore_unsupported_msrs);
>+
>+	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
>+		sync_global_to_guest(vm, idx);
>+
>+		vcpus_run(vcpus, NR_VCPUS);
>+		vcpus_run(vcpus, NR_VCPUS);
>+	}
>+
>+	kvm_vm_free(vm);
>+}
>+
>+int main(void)
>+{
>+	test_msrs();
>+}
>-- 
>2.51.0.470.ga7dc726c21-goog
>

