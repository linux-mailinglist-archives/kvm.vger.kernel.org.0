Return-Path: <kvm+bounces-49684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 084BFADC3CF
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F71617533C
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 07:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1C428F523;
	Tue, 17 Jun 2025 07:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C+W71DVO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AB228CF65;
	Tue, 17 Jun 2025 07:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750146944; cv=fail; b=SG3d5nMUm5g3flFp/RgczF11X3Kou2FjkfMJ113JwSpm0KleMRAlM5o0eJPnoLFlylKpiJ7dR6afM3TEgOojVuU4bzZfKK+OUAJhjxIn2dCzy8Xds/fnc9DhcO3u3CdxQAmAbiHwfrRs2R53rQU3xXyCU6P9awkMZik+Wts37sM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750146944; c=relaxed/simple;
	bh=gv1GXWN5mxQXRkSi63afNBkJE115CU01P85wIeSNngM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GLZFB4k+VqsPyFdOcEMDzpXFHcudh22H6DB0fde1Th92X4wMCugZk6pP48fuqI+2uSE626q4fSU5MU+yXy5VjFdPrnR40FvkzOuCiiu3XXn/AHLq0Cnw5s4VBKVcgiInBwUVQVyRI8dODbAJfbdqNdvlIsVCdO3unTSbEhkoedY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C+W71DVO; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750146942; x=1781682942;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gv1GXWN5mxQXRkSi63afNBkJE115CU01P85wIeSNngM=;
  b=C+W71DVO69tRVN/oIp32DOwwmYtN5mWUh0yo8Enkcu1Ta7o619UqTr+l
   C0uVJ4Y3gjbLhykBPM+XdPiIE33CRZwnPAnWDCWlF8mlDlRB8tq4pqjAM
   Yigpq4chxhDM0OJE3WklrEXdOwc7E0BXIGmC/Xr0PZ/fS+pX5aequ54QA
   4w4NPpY8LFnch2h+GlooFj8dwkgHr0Eo5GJkpMTJWBmrGMFMVZlHFHk3A
   AjWY/oc2UWGv7NYGoEzZlDNzFKU7b83ZVje+GWTlZKSddoBuwp4Dj7O8r
   SY/aqAA8s5poUjXfCZuWnnYAXnF58v5l0Q5UCBsoMmqh62rLcqokya3Bj
   w==;
X-CSE-ConnectionGUID: n2+8AKAuSeCgei4cth6Scw==
X-CSE-MsgGUID: 9xRymWojR0ebBvTMCmyDZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52293218"
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="52293218"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 00:55:41 -0700
X-CSE-ConnectionGUID: 6hF7VKSRTlGKv3puYaYS3Q==
X-CSE-MsgGUID: tN/MQ1beT3+tVrINDqxu6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,242,1744095600"; 
   d="scan'208";a="148539038"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 00:55:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 00:55:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 00:55:40 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.51)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 00:55:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lw1dfQ4Vik8W0Emm9//q+c8LjHJfB5JPzWqZg7zinijCYw9F8c7QVKLeBg9qRwKGLtP7JIDP1LICq1YUehClo+3gIU42CM5MC5ICg6dlN+Sz7X+ZAvc6oOhgrXpucPm7gmbcQG3jHMI3k354ID1+0VU/PJ9ycYT2pwx6wBW7OrJsWpCQ+9UYpWAnSPzLvxwoi9jaD60YpGBEYbw3bN6+Iset8jbw+Dg4/cfc/7iYYG79m+a76d2IRMV8ZDFo1kashWtqg6PV2NZfZ0LfTGlvdiyx6d/hgMFerxTfBanR6hO6Pv0SKtfqHANs/f7m0IZmn9xt49u2IUMngIQjRhndtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCNuOY2C665RdRWxwlBE/SLEXlvm+Ygm1F+5cqpIjm8=;
 b=P3/ScCeS0csg1XETJ3kz/Kb5HQyK/GPms3tBJEqw70dmmrnH36fPybhEnwbP8i7VTuqJ0PSUj3rXuXUmT1PCVb+KnrQm79YY0hw6K3bhyvd/wYkPmuEgp2/3C+TAUIZJYb5QRm7zecInpGI3sBH446xju45jhL+oI8INQYOVsTX0qFn2hx1Rcy8xXSji8KaHkHXOXrMmMg3C/alB8er4q3q3i9dHsS+h27U7zoLwJzn0u3Ild7Yaibz+9s+T2oqdfkkhnz92kn/+NpangUa45eRDm4QpaG/i6RCNidcFOEzU1JprcoPr0hPyyw1npzdcIGgiN6gYml7l4+l62oyEVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ5PPFF6F855567.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::861) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Tue, 17 Jun
 2025 07:55:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Tue, 17 Jun 2025
 07:55:21 +0000
Date: Tue, 17 Jun 2025 15:55:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sagi Shahar <sagis@google.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Farrah Chen <farrah.chen@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 08/20] x86/virt/seamldr: Implement FW_UPLOAD sysfs
 ABI for TD-Preserving Updates
Message-ID: <aFEfVX1GKDa6QHox@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-9-chao.gao@intel.com>
 <CAAhR5DGFxidA=MuhLrixdHv+D_=KYQquBE2quNCNMZvzijXLiw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAhR5DGFxidA=MuhLrixdHv+D_=KYQquBE2quNCNMZvzijXLiw@mail.gmail.com>
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ5PPFF6F855567:EE_
X-MS-Office365-Filtering-Correlation-Id: fdb66ea1-d84c-4918-4dd3-08ddad744f22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lWKzepaQEdk1srbZuJxgA0F1w3Q54mNQPtF+05GA4CmFiObFzQQGWO1XCFG1?=
 =?us-ascii?Q?LM0Ym/G9Mazj+1t7Yzfvlv6+HJSHVLofAX9xbqRmulvhqvHiZbPTls6dofP6?=
 =?us-ascii?Q?uIjgqnW5AYC8YTQYHymgvUhgmNP5knlxQ7mkp8vbUONcA2sE2lUTxdxrXsCA?=
 =?us-ascii?Q?ywUubYWyo5Cbe9/TajbehPwWZElFfp+2QiPkcpYam0RUfdALtY/uOU4OWQYY?=
 =?us-ascii?Q?nEXlrTVHdIYNm0Wj1N3sRm8+z1zG8uHrhnRtr0FM5sXqPB7UqHS3ud3veS3D?=
 =?us-ascii?Q?oWIbiBT3zhdwtN8BliTdLAaplR6y1qaAmO95uWpXh3Pnu/ovNpd9qA4SCw49?=
 =?us-ascii?Q?Ry2G28fh/roPOZROR/xoJmMHIpHAPZcXja4GbfjiI2KPXg5zWkTGcfrP4hgH?=
 =?us-ascii?Q?4pA7NE2Iu2lTXEMm6PqCmLzOOR5u2/+b14BBRfbHPBVm9o5XVIUU91of53Bn?=
 =?us-ascii?Q?Oi9QEUTvWHhph8YPMvqO3tc+10iQcqOmcUf0UWm6k2D/MZwSmLc2zS6JLDFi?=
 =?us-ascii?Q?iM2nb89T+N1YsCwURnQeZtjiN51u0KbIS1n7mb9UCemAbsu3DaX8Sf0/jssu?=
 =?us-ascii?Q?atfWlIrffmaJ3Z1wpetDmhjB901wPLRvSdqw/2NQDP5b79niuSM+oawmUBLw?=
 =?us-ascii?Q?/l3IpmepfykPnXjKq6Ogw6htCVleR6THQvuwFCZbmNW6ERzuDqatxYlp1i14?=
 =?us-ascii?Q?Ipc+vyX10lsrGqX3qX6Ja8O0IFs7nHGXJN54oGQgbbM8P3JwYo9XXIeXUjA1?=
 =?us-ascii?Q?iYhFbpyaQx+CFvl5UVWYN2Vi1ojXu65Zkk0AsqdykW+c+KxOotNE35J0mc6y?=
 =?us-ascii?Q?sT+DybKJ0Hrrvvvr9+bSUQgr68NcLpgaCnlJbCg3wC608nlhv+wBtGnk78sB?=
 =?us-ascii?Q?CQAkhT2YQv4eBqAJ3bSpbisnNYSY/8f4wShLoUwadHPb9ge65zE9ByPUtbdj?=
 =?us-ascii?Q?1A64ug5DQ4gxJtAxVtQiloDbp/lB3VlNCnpSVTeJ+QR5bxw/IS3jpuQKZkk7?=
 =?us-ascii?Q?u6OwwJo3rm0AdTRb6XixWYftsBxgakt3kQ7oJdM3/GxD0cZN0rLflvXHi1Kr?=
 =?us-ascii?Q?uNrF8luNOaE9c+nzXKAlk52VW7mlyn2zsMIbQabIDl7sxHlDjjZCx1MZhPL8?=
 =?us-ascii?Q?FPFeweID45fjNqhVrrb6ugfebILE9Nh1JGe1Ludvue3uMwAYnaYAA8Gz8pve?=
 =?us-ascii?Q?puKT5d9Fmc4VQspK24Ntmm07OyE+O9aKvGHd4k7ogM3O5Md/Max9H9pwSZ17?=
 =?us-ascii?Q?0Q9jtlWVFY6/pMW9thB1HySr9g7c78g3WN/yJtFtOwQfMIKi7pJfKnGphFDk?=
 =?us-ascii?Q?46la9Ljlk6F7ZSAtSMZmIW0r+UzVNH7RIboPKebrbn7gorz2peN7KnRjOlGn?=
 =?us-ascii?Q?POeelTxvgZA6Y7iyGZ+dWJFrIs5++pLN9VDfQnXnEDbNXuknMubrx/3r2XSv?=
 =?us-ascii?Q?o8+stIda4w8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PK9nYQolYCYNmhaZj3b/7JI8bgLiI1YCTD8VOHzMP5o1TDRUvpnAbg6tcW2W?=
 =?us-ascii?Q?K1VmET/ndkMoHCCOL1sov2JGGqd2WAl3AIgHWjQIJTa/xMsAHxc6iQof3uLg?=
 =?us-ascii?Q?FbNj7N9MKje8V4fRQbN6lgOibYxj4IWcXsdzbRJtTD1K4dOwWQ8xY1eRtsGr?=
 =?us-ascii?Q?ak7FF6WKzrKngbh7YAgYOGkC3Foq5G0e5FEGmU+uy5nAtklTD+IhllAyqGz/?=
 =?us-ascii?Q?yrCvVneTWWDFJo3iMiAmovQ4Aci6o+Tc1sh5GRfyGhkL9GjnGCI/W7xNqddi?=
 =?us-ascii?Q?cwJ9C52s5U2vi3RSKnc0ws7uQXV2yLqbjYFvudGng+pGkYxZz3werL/UtUZ8?=
 =?us-ascii?Q?w3TkJXC1qdRu4Sh9mDMSBNVd5jJSk3gfnnro60DOeWJsZxg4umte9IGYf+ek?=
 =?us-ascii?Q?WS9Q8dG4/TNzMm5djC7J3hSWZcqdPGa3RFxqVW/nupP0hA3QLeAH2WUsZFzk?=
 =?us-ascii?Q?THdRlvrb8WoaWoeHKJXYBZ8s9PBvAiWf3eLV0+lxwpxn29P9g8uewtbdR9pR?=
 =?us-ascii?Q?7vkGGW+oYArDUaCig4+otzYZV1og5aRZgc/mFCUPnRhi45XY0wzwVRtSgyMc?=
 =?us-ascii?Q?sWuv8UR/eBN0JV4oioCSTu5Y9wo3a6ffWXr5K+qj0wEqCm5vVV0JxYXIv9u9?=
 =?us-ascii?Q?sU+dhocZYu86CVxdPsJZpBhc2iSV9TFAIhFHUQuCN2XWtser/lom3GiI+Zc9?=
 =?us-ascii?Q?LZ6bWm+/5Xc/a+zHHNuTBOJyWPlPma0dCOd0jlan9GC7g8zscSrT/YZVbUAB?=
 =?us-ascii?Q?xisLD9gEwu95hea/4ZfXGdJWy1yHLZ9ZnB9Ly2GnrX56bMS70xuTtq8Fz+G9?=
 =?us-ascii?Q?SLdFuFeyOLVTv2/6nPVp0LOf8uyfSjojL5Z2PRZsjDDASQN+LTb6iN6ytE4a?=
 =?us-ascii?Q?MnrTVdx795r5/26eO2/49rlfIgq6csWy2E+uTLxuj1Io0cVf9jnCZu+sYyZf?=
 =?us-ascii?Q?/0r8xTNnPjf5+eILzGmi+FKAOPpSsVlpjxWzRFrfvNAh3+IDmSbwUZcjXuul?=
 =?us-ascii?Q?XyBC24sFmxSsOzHkugYFBlujsQbR78QRHaesSGRmIyD+DoMotrhA30fUD/rY?=
 =?us-ascii?Q?X+kxTdavQzsUqDT7DKfA2TuJimiwQQC2ne3iA4UoIta8Rr1wigFukToVFXOL?=
 =?us-ascii?Q?rr5LEzOpyEoYEsHJwVC/NM+ePC7mxhVS0hhAbgp8MVFzQhsHT+p1w9Fx2oDE?=
 =?us-ascii?Q?FnX8Z9bT19M8aNZKLWty/UWVkTQCNeTw2fP1b9Y+c4BhxI7MuBxnIwY+oph5?=
 =?us-ascii?Q?QEHOVw8OtMJWNLwU9loliDRj6T/cpbULYqAhAeGc0OGclDRqMRTmEu69fepz?=
 =?us-ascii?Q?/5cmjuKIvv4LGR0iNkWt67c+BJV75hRxxq1JmzaVoWsRCOPrmMFHdhL5JCpn?=
 =?us-ascii?Q?+qgF3Yu+MlyjTZfy6JtdYGDsWbbrTFuxdn0ZamENq6mt4TDHNUGGAnm4Oj3G?=
 =?us-ascii?Q?Fk7fuktr4ThX4xZQvz+lX0TP9D+B/wMA60dHCu7xcy779HHDH4XIHKkPe1gv?=
 =?us-ascii?Q?NsEnmjwD1AieHrzYyYACNUqUlz4JRlHf70sKYBvzUVLv+JATdyXlYRcIw/YF?=
 =?us-ascii?Q?dGQuIduEoM6q7dtm1PuNZUHAdcoQhjy+cpqs8aKU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb66ea1-d84c-4918-4dd3-08ddad744f22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 07:55:21.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OSXjt4A8WiRQr23gzbg5SIaj/v9jiU/IkV0FJ4l32q5S8si5D/WjhbYnn/gbkodMGDNSCLOLRjVtScbrsH6ROg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF6F855567
X-OriginatorOrg: intel.com

On Mon, Jun 16, 2025 at 05:55:50PM -0500, Sagi Shahar wrote:
>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>> index aa6a23d46494..22ffc15b4299 100644
>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>> @@ -1178,6 +1178,10 @@ static void tdx_subsys_init(void)
>>                 goto err_bus;
>>         }
>>
>> +       struct device *dev_root __free(put_device) = bus_get_dev_root(&tdx_subsys);
>
>dev_root definition here causes compilation error:
>
>arch/x86/virt/vmx/tdx/tdx.c:1181:3: error: cannot jump from this goto
>statement to its label
>                goto err_bus;
>                ^
>arch/x86/virt/vmx/tdx/tdx.c:1184:17: note: jump bypasses
>initialization of variable with __attribute__((cleanup))
>        struct device *dev_root __free(put_device) =
>bus_get_dev_root(&tdx_subsys);

Thank you for reporting this. The goto label is unnecessary, and I'll remove it
from patch 4 (which adds this goto).

I'm curious about which compiler you are using because I don't encounter this
error with "gcc version 11.5.0 20240719 (Red Hat 11.5.0-5) (GCC)".

>
>> +       if (dev_root)
>> +               seamldr_init(dev_root);
>> +
>>         return;
>>
>>  err_bus:
>> --
>> 2.47.1
>>
>>
>

