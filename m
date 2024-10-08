Return-Path: <kvm+bounces-28095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A84D3993D27
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 04:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 231641F2490F
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 02:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4CB273F9;
	Tue,  8 Oct 2024 02:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B/uaAjr7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D55C1EA85;
	Tue,  8 Oct 2024 02:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728356366; cv=fail; b=N4ZG7lSR2Ifz+RzpPClpQ86QvqOCyS6xgCLpTWi4wpscdMZ2OL7XjwEU49g3vwa86NVTz5rP54FyNcZXNt2T3TUxxCs9Q4SlSeQx49exPaOxemXL1Gj40GJ8onUVgq4Kyd8V7sFwlQhdVOS2iUKTzIxTNEXhgVSvbd99zXn9pkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728356366; c=relaxed/simple;
	bh=FHGzfqQ5DdB1qlKC9ZREfJ3ifXaHTG8btg9uRDy4tlg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qsXG2/Oezog7F/poK7E24VCjNyEPWu0/IouFEDh/JnwjtMC5u/+Si2hDVHKDZTnTQ8b4Ob417WqFoRybrXkhunmC1MEWrzZqnDk2qjfuw+CphZg7pBY1fD0DIDWBFo0Jy33LLqgnYy0e0viboRCAWni6tuLUMpMpSt7Cl8+4JRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B/uaAjr7; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728356365; x=1759892365;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=FHGzfqQ5DdB1qlKC9ZREfJ3ifXaHTG8btg9uRDy4tlg=;
  b=B/uaAjr7YyEspsCqrAbouOtLRJ2yB1m1GHxZn5gjCAUcU9thNKyn43SB
   69sPqtNctKWxvHOaW/u1zWtBZT+m32L5iu2PF/font5LUc2pX+5T7ZKxy
   MgE6xiP403CT8dXhc6vtD/ALGv632dZaucFWej1ixZDWgoNkm7ySGz/mH
   tvc0kXwkZne80DlEEbPv6wwgKRlXCak0XyjRUXw61g+1xfFJIllcRV/LU
   p1BHef8njAz7uyGvKOUjhAg5AkZXKUcdh6tdvko2US5cXXYLh0+qrZcZn
   a1EgavEq4kWRT17+aaDfXED0N3D6CPzYuUvMkKFXvdntu6gTHWrIS0iQD
   g==;
X-CSE-ConnectionGUID: gFFKt2r2RwaK2Cpx4A5KoQ==
X-CSE-MsgGUID: IOWL8g4eTBG9nqy9MVet5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="27337378"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="27337378"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 19:59:24 -0700
X-CSE-ConnectionGUID: luGbWwYLSmmQdn38MGethg==
X-CSE-MsgGUID: KQ9/0ZyAQjiQbC2uSqeOIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="75783783"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Oct 2024 19:59:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 7 Oct 2024 19:59:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 7 Oct 2024 19:59:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 7 Oct 2024 19:59:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F5dI9j9Adidss8fUxXOwte5ZgK4HExdeiViPTzD6+NGCTUv9OcxVXCN5UFqjqFvYWFazva4IfB3B7YfDg6Rsn1DZCaPulrgKc6CfxZnxk4eaNHPj4GAXuinbndkisLgkJOlkIKrxsQ1uoyI/CnNKhHI/C+ncEHniLwAS9nRnaJh9RIU5YgTZASykg0BGaSqMcR6yJ2avLHPVCB9avZp6kye0K32d5frvIBsMYQeioklDvYNZdm4/ouVNViqj0Je4Cur/O6lcP868hazdUcdx4+txJ87exzWWkVzaMEOdVSptpAFFHqsxclKv2sSXktvl5BpakIucj4LKZFO9kN6KFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IkojUNrtCGxe2bQFd5EotCsCi0RJtxm0I6UQ61GzWk=;
 b=Ov/7Trl+yPmF2dPTs9P4dskoDsHUmoeNqXYG3DQRdgNpL9Bq+9Aon18pwQg3B71z+aOBurH9+nXDaZ4uoq2F4QyUgOC5WYpl4h08GooYC2dIzma9JAe8r+oiWvOEFOBJr/KysyFs0SAWsVaizaR2+ZWclEv6z6bhHkcdghWkBcY+bULwENcEYkoVFw9KclAI9YLc7k1WT9tUwSJZSNTpFNkVFN3akiufmWy6uZF4OeiYAF8QH4PzZTDkni019q9QB7hxpRWidKKr3RLj0PaukyOB2jzIDxb9//OezIOrmP6V/pR8ZPgxMAfX4qag+LoT/iU1BswV83sUYXsf3YY3zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6240.namprd11.prod.outlook.com (2603:10b6:8:a6::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.23; Tue, 8 Oct 2024 02:59:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 02:59:21 +0000
Date: Tue, 8 Oct 2024 10:57:08 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Isaku Yamahata <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<sagis@google.com>, <chao.gao@intel.com>, <pbonzini@redhat.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
Message-ID: <ZwSfhF1h608vS2y1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com>
 <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
 <Zva4aORxE9ljlMNe@google.com>
 <ZvbB6s6MYZ2dmQxr@google.com>
 <ZvbJ7sJKmw1rWPsq@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZvbJ7sJKmw1rWPsq@google.com>
X-ClientProxiedBy: SG2PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:3:17::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6240:EE_
X-MS-Office365-Filtering-Correlation-Id: 367aa47d-7aab-4665-ef1d-08dce745353d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ioshj8UdKl456oX7Rvai931d+aj6mEKGYzLIeq+sUEdTWzb+OJ/NqsHPA4wp?=
 =?us-ascii?Q?fjw+4jdLWHKsEjMV0h5ye3uWvSziNRzmog10o8tbngXsMS51Nn1UV0Wmr+sh?=
 =?us-ascii?Q?bPD3SLfZBwCF9J/eLByILWZd484Rh8Ae0TJ1WnbbC2lzLc0q5ryAE2nX2m4J?=
 =?us-ascii?Q?CE6o0HeVBYugXlLk5nsovlZh/a4Gp8wOx2rn6t5wn4/Y2Av+asGRkHzacVsN?=
 =?us-ascii?Q?n4KcqFc+gmH9/VhC6Li8IcbsKcpp/IkiXVG36+gtC2z9Tkz5MhYeqXGlw/XZ?=
 =?us-ascii?Q?YHxtGCx5S+KR58A5hWJnWLs2uM34XET+zB+WvfO3wB9/R1zvtQrJ4HnqHXzZ?=
 =?us-ascii?Q?qpeZK3/umHWJAMju46PE20MehpiWOTSz847JVoR25GYRVRlGq6llrq4BDtIn?=
 =?us-ascii?Q?OtMlQmnqgE15IGnpBRpXp+fjRYytE//kPz4dDddbYwqcB5/old+QsDRh6KRX?=
 =?us-ascii?Q?6vl8Q+cd70RWuQ3O33WfJIRUBkh0WWf8GnOHDN3IEf6Jw2hBrjAk+IdcB5se?=
 =?us-ascii?Q?lGPGbdfpRKgtqL0af8SUQnxng22lCag7G4HKSHbLz+bbNEtBLGmXIty4UxLm?=
 =?us-ascii?Q?hhfzSTx1HX8iZiPURQDdFiiTnH35A8MknN0OyHhnvql/C9MWWti9jwrEOV4P?=
 =?us-ascii?Q?YuXRy3ryUIain/YgUKUMZPR4M9UidliTGlroUtMUFUEAXzEGWC/aJSOu6T3p?=
 =?us-ascii?Q?dLKi26FojR5HA3kmeYfx/XK7Mjia4HeXgPVQmQH+RBVNYlyqRMk8CV49vB1B?=
 =?us-ascii?Q?h3t9vYIhu3lLQGQOM/lx/VXsL6EXcaVyoslRVUZQx364yskmA6vN2rRMDEkv?=
 =?us-ascii?Q?Yq9/1xZQPXx1NeF1Q9e4CPzDrXwGvcw8/bEfWYxI8ktoFDDShuOr3dd4STYT?=
 =?us-ascii?Q?wVwtzSbEndSQaYfCOw3d9c/1GnGMmZfOtaOt6zxWm9ZzXZZyDlBFsdGiq6kv?=
 =?us-ascii?Q?oPkkGYyEqSQnpTStQB+RoEtIKF7qq0zccXHT/Cv0C1RodDD4+PbUQaawWgDp?=
 =?us-ascii?Q?3CRpAC4opArlcBot2Bnw6Pn7vUHIDpAU1E/s/XoogCn/11skfeJu8MPRoovh?=
 =?us-ascii?Q?OqoaFNj7aX2NN2uOXQ3wn3m6u87BvoX375ws1N79lBjUsjLUZXKVRGCRD1Xn?=
 =?us-ascii?Q?jTsUeJnSSDlLrMgZ7TDRuZ+qdQ2N1gONqnFAVUMcUsLwFAN2/89BlYL/kDhi?=
 =?us-ascii?Q?doFG1J9yB9+FPk4DOgUGLzFMDLWIw0eFu3g3ea37/IizaoUForBhlq49Bul+?=
 =?us-ascii?Q?n37uuoqnWc1idZWTS6MIH0HyiIpOEzAoP557nb9d+w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bEiiH9VRQJKGQYQNd+R2FzR/E17ipPRlUfGy7m6jVBJ4JMlPklceRRJ5jP4S?=
 =?us-ascii?Q?e9yLYRjXLYses/hgDl3c5MqG8z2R1oC+tIahiDzp//PPGjXeoJHDtejlL19N?=
 =?us-ascii?Q?Axs3dEGXJiNkVUymzRPArMRbyvJV/p26fCFLA1SfdzttK1culpVWK6LiTN/Q?=
 =?us-ascii?Q?EClWjFhHGUMYiA5hurJ/hVZESkN5cnWx3zxdrwDvR38EqNpW457HBDNSDOfR?=
 =?us-ascii?Q?DFMuiVWv24IKfC6Th6PbMaikBqujXROlBHMbpsIEiHRZtx8IVtOh9zRMgLf4?=
 =?us-ascii?Q?0vEbWpdNU31dKL3qC9vBE4yfg6RzA1XH2UqJY+JTg/VZ3Wk/sKoEDhWyNa/6?=
 =?us-ascii?Q?tYSzUZZxkfSb6Y0M6LqXNxXYnfvdLCd4bs399jvWQeQ7QBmzKP51q2CzzZmN?=
 =?us-ascii?Q?pSjEx8ICUYIOHx+rdxXUi1jftM1KhsFgaAOFu5eauSkL7Do6GIz0lMqDSVen?=
 =?us-ascii?Q?oQqRjZ4+AlavO3a3UhW98/MaOHp5C7EK6YuAhImSVqH8zYTwce79fN3zzWWp?=
 =?us-ascii?Q?j218lquZkCSQ9MxO3AXN9IEbBB93t4u+xmfUKGynAejjo/WDreIWnFa6+Oet?=
 =?us-ascii?Q?Trj80hxwv6HlI7WP4pko9Go+ZTxSYNSaeOP2A17s9Qs/UrK6vDXZDV6aMwqm?=
 =?us-ascii?Q?eAzR2sne8f6kVY3hAg1f/MkJLG9Gb4gt/dTWo7LwS7nRgckhv9OvSlTmrlWg?=
 =?us-ascii?Q?Jp/qhjaJfYzXs43u8A9OULajmQnBd6/47TZH4Fl7sV5bWgmRc9m8Q5QeL9k0?=
 =?us-ascii?Q?gVk4VYyqvf/qACZcQK/YjVZNUpjxeccrye7SQCg2JpXAlzxAbYcX4EeGipsc?=
 =?us-ascii?Q?/SK6kamCa2lCKGtvg4GSaIzJe/UOXJgf/vgjh+pZ+QsQyGcEOz4nkk9///ax?=
 =?us-ascii?Q?etSdxy6dA9ewBMRb8K+wi5FDttsUPjt+uWaZuNkXvFViHa7MdVnUdL6L/S6W?=
 =?us-ascii?Q?Xm+GQXdmiJiWDLOwR0GjTU5f+fl7LS/Kp4uP2Ox8wExrxfElsgMZXm+06CUb?=
 =?us-ascii?Q?BM4KX7oa5ZtGGY+mJiDg2TZWrpG2pW3BKH14JrTtyWzNZgqmYIc2PPNktsx/?=
 =?us-ascii?Q?SPMj89s9LT9xrXzm+bQdI4O2l6t17oPwyGEeaAyka0YNu9ZcKVgvSB+/Idt9?=
 =?us-ascii?Q?0XNOi54t9LoeLQFkYqSYkYAWjfGwYXt6eHJ1GZZD928LPKT7ZUNzpZThIw8s?=
 =?us-ascii?Q?T+dAcjZUJITLFcwSUtIAFjXABG+ixGcEgjJORUsZaOplp0H8lm+ppbUh573H?=
 =?us-ascii?Q?eqmSdt8IMqXGGwwOuzdEsyLogag0yA7ZHkM2pUNNSPw4o4Fsod7rXVGzV2GJ?=
 =?us-ascii?Q?KsbNbhKgPoBEFsDwQrQeF/1zvcKejNbIQJ/fQxgm8+84rgojz+5zsTf3iQlO?=
 =?us-ascii?Q?XW/W6qjRIOCWsOECHDyGRWD1I9UfXUHDt02mkOA9L9jtbxmEOyD+JWhlU0Lo?=
 =?us-ascii?Q?c96tiZT83qxcdfBu5HD0AOlxkIuHNnHmgZWSbNKAkIA19UkPcuUqFLaAvfoc?=
 =?us-ascii?Q?fFckm+ERPsUoboQzHkTnIuSaY+V8/5g4cKBWk1UEO5v2xxJzPGQ6Uz5ypUPZ?=
 =?us-ascii?Q?N/3ervimEfrTp75NuuGUj6Fghkk9/bV5YVKxgWGu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 367aa47d-7aab-4665-ef1d-08dce745353d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2024 02:59:21.3476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JpZ6A5WHBnVx+Ygut11FHjOcPYF5EhrjTQBGUxLQjzSxHY2hfBK8grvJL1adMawE/xm2h2LJ7vIVUTUzSsRPCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6240
X-OriginatorOrg: intel.com

On Fri, Sep 27, 2024 at 08:06:22AM -0700, Sean Christopherson wrote:
> On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > > On Thu, Sep 26, 2024, Yan Zhao wrote:
> > > > On Thu, Sep 12, 2024 at 05:07:57PM -0700, Sean Christopherson wrote:
> > > > > On Thu, Sep 12, 2024, Isaku Yamahata wrote:
> > > > > Right now, the fixes for make_spte() are sitting toward the end of the massive
> > > > > kvm_follow_pfn() rework (80+ patches and counting), but despite the size, I am
> > > > > fairly confident that series can land in 6.13 (lots and lots of small patches).
> > > > > 
> > > > > ---
> > > > > Author:     Sean Christopherson <seanjc@google.com>
> > > > > AuthorDate: Thu Sep 12 16:23:21 2024 -0700
> > > > > Commit:     Sean Christopherson <seanjc@google.com>
> > > > > CommitDate: Thu Sep 12 16:35:06 2024 -0700
> > > > > 
> > > > >     KVM: x86/mmu: Flush TLBs if resolving a TDP MMU fault clears W or D bits
> > > > >     
> > > > >     Do a remote TLB flush if installing a leaf SPTE overwrites an existing
> > > > >     leaf SPTE (with the same target pfn) and clears the Writable bit or the
> > > > >     Dirty bit.  KVM isn't _supposed_ to clear Writable or Dirty bits in such
> > > > >     a scenario, but make_spte() has a flaw where it will fail to set the Dirty
> > > > >     if the existing SPTE is writable.
> > > > >     
> > > > >     E.g. if two vCPUs race to handle faults, the KVM will install a W=1,D=1
> > > > >     SPTE for the first vCPU, and then overwrite it with a W=1,D=0 SPTE for the
> > > > >     second vCPU.  If the first vCPU (or another vCPU) accesses memory using
> > > > >     the W=1,D=1 SPTE, i.e. creates a writable, dirty TLB entry, and that is
> > > > >     the only SPTE that is dirty at the time of the next relevant clearing of
> > > > >     the dirty logs, then clear_dirty_gfn_range() will not modify any SPTEs
> > > > >     because it sees the D=0 SPTE, and thus will complete the clearing of the
> > > > >     dirty logs without performing a TLB flush.
> > > > But it looks that kvm_flush_remote_tlbs_memslot() will always be invoked no
> > > > matter clear_dirty_gfn_range() finds a D bit or not.
> > > 
> > > Oh, right, I forgot about that.  I'll tweak the changelog to call that out before
> > > posting.  Hmm, and I'll drop the Cc: stable@ too, as commit b64d740ea7dd ("kvm:
> > > x86: mmu: Always flush TLBs when enabling dirty logging") was a bug fix, i.e. if
> > > anything should be backported it's that commit.
> > 
> > Actually, a better idea.  I think it makes sense to fully commit to not flushing
> > when overwriting SPTEs, and instead rely on the dirty logging logic to do a remote
> > TLB flush.
> 
> Oooh, but there's a bug.  KVM can tolerate/handle stale Dirty/Writable TLB entries
> when dirty logging, but KVM cannot tolerate stale Writable TLB entries when write-
> protecting for shadow paging.  The TDP MMU always flushes when clearing the MMU-
> writable flag (modulo a bug that would cause KVM to make the SPTE !MMU-writable
> in the page fault path), but the shadow MMU does not.
> 
> So I'm pretty sure we need the below, and then it may or may not make sense to have
> a common "flush needed" helper (outside of the write-protecting flows, KVM probably
> should WARN if MMU-writable is cleared).
> 
> ---
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ce8323354d2d..7bd9c296f70e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -514,9 +514,12 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
>  /* Rules for using mmu_spte_update:
>   * Update the state bits, it means the mapped pfn is not changed.
>   *
> - * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
> - * TLBs must be flushed. Otherwise rmap_write_protect will find a read-only
> - * spte, even though the writable spte might be cached on a CPU's TLB.
> + * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected for
> + * write-tracking, remote TLBs must be flushed, even if the SPTE was read-only,
> + * as KVM allows stale Writable TLB entries to exist.  When dirty logging, KVM
> + * flushes TLBs based on whether or not dirty bitmap/ring entries were reaped,
> + * not whether or not SPTEs were modified, i.e. only the write-protected case
> + * needs to precisely flush when modifying SPTEs.
>   *
>   * Returns true if the TLB needs to be flushed
>   */
> @@ -533,8 +536,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
Given all callers of mmu_spte_update() except mmu_set_spte() have handled TLB
flushes by themselves, could we just remove mmu_spte_update() and have
mmu_set_spte() directly checks
"if (is_mmu_writable_spte(old_spte) && !is_mmu_writable_pte(new_spte))" instead?

Then maybe the old checking of
"if (is_mmu_writable_spte(old_spte) && !is_writable_pte(new_spte))" is also
good in mmu_set_spte() due to shadow_mmu_writable_mask and PT_WRITABLE_MASK
appearing in pairs.

>          * we always atomically update it, see the comments in
>          * spte_has_volatile_bits().
>          */
> -       if (is_mmu_writable_spte(old_spte) &&
> -             !is_writable_pte(new_spte))
> +       if (is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte))
>                 flush = true;
>  
>         /*
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 345c7115b632..aa1ca24d1168 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -133,12 +133,6 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
>   */
>  bool spte_has_volatile_bits(u64 spte)
>  {
> -       /*
> -        * Always atomically update spte if it can be updated
> -        * out of mmu-lock, it can ensure dirty bit is not lost,
> -        * also, it can help us to get a stable is_writable_pte()
> -        * to ensure tlb flush is not missed.
> -        */
>         if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
>                 return true;

