Return-Path: <kvm+bounces-47376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EDD6AC0E91
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 16:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB0D74A1BE1
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 14:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F5D28D85C;
	Thu, 22 May 2025 14:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YAtIZZub"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C6028D82B;
	Thu, 22 May 2025 14:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747925108; cv=fail; b=bEIX8oM2/5owuke1l00bNkY2bAFwpxHjfOG19DNm3OJKkMd23zgPP4608T5+/cQ5NoU2tN4GQD6HtB2/E4qXYFPL67SKgZc5LsBUF4i2VjQj0/A0eLlNMzWPrus2vSQyp3S4lIGZv2yzoH35sR7T/onjoUmodw/BxTsNGe9fJEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747925108; c=relaxed/simple;
	bh=E3c+vaftugcMXP3mIF6qqyozpwL0Xrlq8pkjCoGmZso=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D3IgrHQm2iD63owzn78dD30bnJGPoZ3oNf6QE9G31uYuImfkIU4f/5CYusxeedubavSt6i5pG+BPOkXgwbdIKJtVY6Is4NnRYj7wS4V0SSTUlzFbPkqOEyk4AlfwKd8vjOW/3TpJ1nQ/rb3UY7ZltCJCSi6nnanwoT4L7LsAzZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YAtIZZub; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747925107; x=1779461107;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=E3c+vaftugcMXP3mIF6qqyozpwL0Xrlq8pkjCoGmZso=;
  b=YAtIZZubHsi+ragrbd6fZGeyqcZqLJe5r1EvLgsyzhPekaMvgQGQTTyi
   GOt3i+0W9GPJdbKN0bzwg1Bl9dGscX67gsBUdd+nEGxiiiXFboSPtHuMl
   W8MLmxGOp1era6975pFf2dBIAy2rMW4zFjQEu/P3G/AoEkHb7ac0SAwGo
   Ed5L1srw7BBFJ0qPmSKuo5tsTqQZocQNfDbtf2Fj4WGJHZRG80dkqSaG0
   KYySRUm3lp1FB0WS095iZtQv9PU1vrHtpa4cWRHNw0rZ7+7HoV7tKvxnW
   o7m9hBs+AgNoG8ubv6o/tQfObCyDIdz9k3P9wPSJBiDhFMGYh1d/WyXAT
   g==;
X-CSE-ConnectionGUID: to3HOwb1Q2qpMoQtVmcXJQ==
X-CSE-MsgGUID: HDP86JysTwOy3e//AZf/Xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50100767"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="50100767"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 07:45:01 -0700
X-CSE-ConnectionGUID: RZXVjHQ6SY6Q4K/ojTA2cA==
X-CSE-MsgGUID: qZSjmsDxSvqmtnT3IsNz5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="140705678"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 07:45:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 22 May 2025 07:45:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 22 May 2025 07:45:00 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 22 May 2025 07:45:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TvlIUeD/24BVKtHA6HgLb339xRDPDb17OHPHAxZ8VHmIOVRBeuUx0sE/1BeVhmepL4CCYQYeVIDpiprlq3EPKQTOKp+Cu1BLsmzLIvugbc8WU/Lxlbrz0lEhPJNOt/dEj5Eh7X3UsD4Fe4PYwqv+GNgBh8JoBdPjxONpkerT7a66qDiXRr4s5KLas9sFtlhwC3snFNxP/j1yz+UULh+bHST8BZfY40cONQcLBtCs8u/r0ifWiiHGev44Iy9FLpUnAR7SU71XPgc2BedWTnnVaWiybo7MaH0ZKz18AqEhOgo16s0BJ4L8bctaK8/JuXCySZ2pvFVJP6+JdgRCn9oqPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbZ+6p242Pl3YtRFa00fzHI2fe6Mc1pddSS8DGuEEYs=;
 b=MPc/v0bLzkEVcz9FVG7s2N4BL0CbXU/jqv+S59raxC8jCiK56+w2hzZptcdWfPjlrbOTzjPD9vO0YAhzWK6rDYvTLIDnoUcwI/cC60+ooVb4bW4u64ucU6imRaqspHZztaFoemvzi0xtVnKfJ2upC9N9THL6vWtHEZbvxjiwv9GehrAXrsS10GqwadcUrIS1qYJdFYs7xZg3U1paiih9aE4/FcclOrAZLGczT2l1NkOAHcWH50CB+xoAX+/5nVE+M8SiZGZcd8QpS8ctHZhE3sr5B38YLCAUnDZ9K1GEUaJARPhsuwRVCLUuMGf7XX2Qdo1ZAMwpN7KuK2uAEWUlwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL3PR11MB6364.namprd11.prod.outlook.com (2603:10b6:208:3b7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.20; Thu, 22 May
 2025 14:44:57 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8746.030; Thu, 22 May 2025
 14:44:57 +0000
Date: Thu, 22 May 2025 22:44:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <pbonzini@redhat.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<chang.seok.bae@intel.com>, <xin3.li@intel.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Samuel Holland <samuel.holland@sifive.com>, "Mitchell
 Levy" <levymitchell0@gmail.com>, Kees Cook <kees@kernel.org>, "Stanislav
 Spassov" <stanspas@amazon.de>, Eric Biggers <ebiggers@google.com>, "Nikolay
 Borisov" <nik.borisov@suse.com>, Oleg Nesterov <oleg@redhat.com>, "Vignesh
 Balasubramanian" <vigbalas@amd.com>
Subject: Re: [PATCH v7 1/6] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Message-ID: <aC84WRnMsIcozhbf@intel.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
 <20250512085735.564475-2-chao.gao@intel.com>
 <aC4ELHF73K4KIY27@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aC4ELHF73K4KIY27@google.com>
X-ClientProxiedBy: KU0P306CA0080.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL3PR11MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: 656fd8e8-9940-4da3-da8d-08dd993f38c8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?soR06dO1OPCSwKRpDYOqvJIDM3yDe7qhqB9C3GKvRqFXSpKnJkEFtgWe5iYm?=
 =?us-ascii?Q?nhv3I+2NwWBtCgDPE+a4P2uvMZY2qmx3nRu0xZXduzFHfmpO1FZkoDWIUZHV?=
 =?us-ascii?Q?qPyEAptnpROpejs86UL1oZ01KQFRTxGWbGfpERV+Z1q3ViWlOL48d2KxcJIn?=
 =?us-ascii?Q?/SCT5tRRJIaMAv8/jYTpAWWR/ToQ34lJQr5xUVbP6h6xXYPvaQw+bUnu3ZcD?=
 =?us-ascii?Q?xUwHwlIs+X+uBz5AsDawWEI9FqmKah1eEvkg67NOEYOIyB6FpNfaJ4idL9tN?=
 =?us-ascii?Q?a73EcWO9l4cIBXk/ewfPnRO2QAOKUzM6FvalEy0ENX1ET/W6EW8h1TMfetFL?=
 =?us-ascii?Q?ULMn7mvP/ySrvTJiHxWcQ453ENSAoXSAV4LOEJR6+WklqzxnnUt/ZV5l6Pib?=
 =?us-ascii?Q?9IvhPN+kz8EFt4r2sUNZpE9+aKWleIR8lNIWQqaaURpRHgSMaXaiwRQgN1YF?=
 =?us-ascii?Q?y3dC5OlCBUmJhwcRF8zq132s0kAh+0f8Kir/g5FUXb7PlAwqHzEzAcm+hNh8?=
 =?us-ascii?Q?MNWbYBVDliIQUBCfiIpRy/pV55X1Z32F/soT7OOrhV2IwqoSwKeK9j0emnXE?=
 =?us-ascii?Q?Bk39PnBNx3SWCVtKlczM6m0iL0S3loFJcchRSX8U4maqJKQwebrFVbaye0aj?=
 =?us-ascii?Q?USEH8ISVjAVET0kgKH1kT0Sr7O4xPqiMldAO3QUJcVir2biK3BdyZ3j6Fp7i?=
 =?us-ascii?Q?YLYfYWlog4gOKyCRJ34ZfEikKEkphGsuvrsXkdmq74m6duBITLGQEyz3FbWg?=
 =?us-ascii?Q?8xfXbnVInIfDWyv5JNOEEKqgYezQ43P6s0em0RctjCO96+mHN+OMYkZbKOCZ?=
 =?us-ascii?Q?huU1nTN17lcBBjm5YRWrjerCWkm7B8kga2YIdtOazu2ls4of7x/vIK5uUD2O?=
 =?us-ascii?Q?53K1QNfJQsF/yu6O3yStJE5ZtQ1nfZs/qagv5OyXjasAGI2sGdzaQm3Jrm6e?=
 =?us-ascii?Q?BMjzn6tcMwLOnylftKGomXWJaJ2GaefCv/BV6PupxklyCO70X3vqZ5zMhbow?=
 =?us-ascii?Q?xiZ324EUC4zmLR+pPMsOiKDbiu1iEMxyOmU2WnGobzWp7L2IL24x1jFDMhx1?=
 =?us-ascii?Q?DIjtj6eoRa/iw7Thg7bMe5zZXEUYCZBtUPWop8XK+W7sQhQFQt4Y6Q1b4wog?=
 =?us-ascii?Q?faBduaj5BdObkQf5I7WpTyKhQBxoTLR2ZrKsOs5jUGms6Mh6/MCKrOd9HE6p?=
 =?us-ascii?Q?LgEMAt9lS3bKiWt/0JGz6ltl8mBPO14I+pcFgpS2lZYfxgdsuu2Lzz+/2Ifq?=
 =?us-ascii?Q?IKkyEr2PC35FhbSPSrGFep/S2TAvFaB66rji2xTkvcD/h82EFY838ytnTRf8?=
 =?us-ascii?Q?CoGGUxjclMwaA4OtfEbMVKBWAr+bg922hoD1PUoYTLaF1xhjsk/HwM+bOgIF?=
 =?us-ascii?Q?KgCo5bxWsvBs5S6BZeTAN/0n47nPMKOn1hoZU7M78tvsfEUsyg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BY3E+zxQg7WCf4b5zxOo+HeODwjbHEB1o6mm03RjoFRjix8Ayh4ID+LnPzRG?=
 =?us-ascii?Q?RxIHAOiSjP0ysMXGciCsZuquQ4pbmG82R5vESOiZEUMHMPCfmrNo0QoYERzi?=
 =?us-ascii?Q?lokAqEw6vz7trNQHgHc9q0z54eJws9mmqdpxjt7hSYKjP1xAgK4SjC5mqLPO?=
 =?us-ascii?Q?w61MI12sbuBbvyM/GskYvizkKySyiOJzK1pReG2x+wHSD46Y8OdnC4YEB9A2?=
 =?us-ascii?Q?Fl5ljtpDdFiDxdEj1BWzyuId0O0JOLakLH86JAB3jlMtymTeZKfm+njdpIQH?=
 =?us-ascii?Q?1dJUyFPZ9HDXk+b3vILu0CBdbeHFizJntTpTGgOnRUpQHsYtFTmG83iD6Uxt?=
 =?us-ascii?Q?BPOk3FEsTN8Qa7TQ4KIv4Q7/RDT5g45WznCQAUVvBt5fIvVWRVWjKDvheHg6?=
 =?us-ascii?Q?uuQrAsuUreiA+c6Un0OpZzJ79MD2E3RA72QKM2rVK+/2r+96iKgUQEaMi6MJ?=
 =?us-ascii?Q?iIlgFPqmXwUy0x/jIO80nTkkgnHHuJ+XbxzSXy37YGvoQn408DUdb/Inn/VS?=
 =?us-ascii?Q?8xHY22imFexLSj3eV3ixDea7oCHefYyP/yCHYxHCtwXzj+WxuhzDTPw6SYst?=
 =?us-ascii?Q?vRdt1i2UVf7JD7LtKMaRhBfAonYOjCpyYH0spsqWMD54z/WYRp556ytjfT5/?=
 =?us-ascii?Q?hkJKZqZNRyAHHbIPXosB0XgfUf6KDy1uM0ET3n8T320vGoyMc3spQnJu8080?=
 =?us-ascii?Q?rNtKACK3eOHISjk59VxnfxpzaI9tdoczrRIJq3oG3VHLmEPMvcqYeEkCi/jy?=
 =?us-ascii?Q?6hYVdYI8RBDKf7jf7coi1M95U+5UPAqDIMP5MGCfE7PyZjaW6cYOZj6H0ANb?=
 =?us-ascii?Q?G39pfRPVE1B9Hrua4sY/hkWaqCQLtUkoUlb5vjzlMgyzpzPEZUh4LKDOh5kC?=
 =?us-ascii?Q?Ux7EbHi1/uFzQ8KjAq6INQJxTOseMB04p153QGMLdg+ZybAwAW3sZHsyyh1+?=
 =?us-ascii?Q?CtlEI2QcQ+Tr3/aLSefEBaVmQC90/ZgbltDu7Ekx4UrzhdtO+i2Zd/ynOhNt?=
 =?us-ascii?Q?YiDyxvIDLlT1F0lzB5mPPs8xtxy8IENUVZpogJTyMi7lgSJ98PZZ7bfz7Yex?=
 =?us-ascii?Q?9Qw42odIb7ioAxU/d1IdIxNdGbHF4zQIwJF4Cl2iZCul1S1rOrJX/cIbu+QN?=
 =?us-ascii?Q?Fp/ra75Amj7j+jFIqvF9lc923kNK2/T17vjVajVmK4Nh9Vzvd811TO8kir1r?=
 =?us-ascii?Q?dxiUiT8XMnJZVYl4kVtL5r5KJjh6jM44VVWnjiF68xEj0Z2Za7sFfcErS63q?=
 =?us-ascii?Q?hALpjbmqy66IGzTlZePBDxl/K2WOzlNaaYY/1kcTvKUl4BD2pMNdw35K4gtq?=
 =?us-ascii?Q?4g0hyoFIFuRhONfwU4tHSIpsZJjWB3mYPipZJmHc7sSVuUlOZ4hLkqLjN2LC?=
 =?us-ascii?Q?3pbqyeDs3ENU5GkkLScMpSvQNLhkQJLvMh0uJdJELpfyifrqq2wg8v3tZC2L?=
 =?us-ascii?Q?CjR0yxUHz6n9kUFmmjEUvgjUSxxogobyt+Y38UiGhxbzngK/6i8AXioQFH+q?=
 =?us-ascii?Q?AP+UpMDrB66Nf4lmt7PqbyUHRJv2BQl1AKdL6gtm/myTV6r2Md6Zaoaxl4tO?=
 =?us-ascii?Q?fLqSxmkBxY/kquRzychxBXt3dVxmPVKHW2Ad3v2F?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 656fd8e8-9940-4da3-da8d-08dd993f38c8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 14:44:57.4710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ox/XJMBmXv2RrNaafXzlN2WgsFXo0GIjbb8Hoxzr6P1UXhSicOET2j9Br5nPwCvYr3l5aQxgJawlSv07IPbPIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6364
X-OriginatorOrg: intel.com

On Wed, May 21, 2025 at 09:49:48AM -0700, Sean Christopherson wrote:
>On Mon, May 12, 2025, Chao Gao wrote:
>> @@ -772,6 +776,21 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
>>  	fpstate_reset(x86_task_fpu(current));
>>  }
>>  
>> +static void __init init_default_features(u64 kernel_max_features, u64 user_max_features)
>> +{
>> +	u64 kfeatures = kernel_max_features;
>> +	u64 ufeatures = user_max_features;
>> +
>> +	/* Default feature sets should not include dynamic xfeatures. */
>> +	kfeatures &= ~XFEATURE_MASK_USER_DYNAMIC;
>> +	ufeatures &= ~XFEATURE_MASK_USER_DYNAMIC;
>> +
>> +	fpu_kernel_cfg.default_features = kfeatures;
>> +	fpu_user_cfg.default_features   = ufeatures;
>> +
>> +	guest_default_cfg.features      = kfeatures;
>> +}
>> +
>>  /*
>>   * Enable and initialize the xsave feature.
>>   * Called once per system bootup.
>> @@ -854,12 +873,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>  	fpu_user_cfg.max_features = fpu_kernel_cfg.max_features;
>>  	fpu_user_cfg.max_features &= XFEATURE_MASK_USER_SUPPORTED;
>>  
>> -	/* Clean out dynamic features from default */
>> -	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>> -	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>> -
>> -	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>> -	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>> +	/* Now, given maximum feature set, determine default values */
>> +	init_default_features(fpu_kernel_cfg.max_features, fpu_user_cfg.max_features);
>
>Passing in max_features is rather odd.  I assume the intent is to capture the
>dependencies, but that falls apart by the end of series as the guest features
>are initialized as:
>
>	guest_default_cfg.features      = kfeatures | xfeatures_mask_guest_supervisor();
>
>where xfeatures_mask_guest_supervisor() sneakily consumes fpu_kernel_cfg.max_features,
>the very field this patch deliberately avoids consuming directly.
>
>  static inline u64 xfeatures_mask_guest_supervisor(void)
>  {
>	return fpu_kernel_cfg.max_features & XFEATURE_MASK_GUEST_SUPERVISOR;
>  }
>

Indeed, it is odd. And your suggestion looks good to me. Thanks.

I will fix this and the comment issue you pointed out and post a new version.

