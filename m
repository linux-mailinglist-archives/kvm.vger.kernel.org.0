Return-Path: <kvm+bounces-23268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8988948579
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC75C1C21F91
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2193B16E892;
	Mon,  5 Aug 2024 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XwE81F3R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFC8153800;
	Mon,  5 Aug 2024 22:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722897445; cv=fail; b=DCKOiZfy/Zqzjn3SU8fKH6KiUItsuqZy+bv5/zorG18zYo6Y+04erouH5z7/F+Er0c0s8/Lq3RBVhN6NI+CxjOR62VN5GT3GBubSe/eWeAzhg19B4Jf6Lj0/6SaAB5h/buI7wOCeHnT6QqK30mAzmxELhdbPU/5WTZZJ3Ot8LZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722897445; c=relaxed/simple;
	bh=+oPfuhMra1oRAgROZkednkPyyQfod57BL46sHyQ0cOE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HZSiyPKAKZ8dMjvhiV3Anq8IIzlRMHy6jnwJugt+FFhatzcoVVlbRsWf51qmHi+M/nEb0NLsJ8BA3th85rvMqscSGuROcYOjfdKWbmxYihI2PrcLaXiyJmk/nEemIWyP70mOChv4UlHTk/tZ8s0DEp667ZTvldXQgbuSAN3uVFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XwE81F3R; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722897443; x=1754433443;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+oPfuhMra1oRAgROZkednkPyyQfod57BL46sHyQ0cOE=;
  b=XwE81F3RZXkFoHNpqekkBsIOdbJQ+lesSWC5hDIWfqtqxDEp6f6eZBiq
   r01xsmkJdkcJB1hLeFPsh/vWXBkN9ErZtfZRWEhgXahuTMZOS73Uj75EZ
   QPx4tiUuHcIahfl46A2veGglHXK+mbV2pEgBC5TI+0k+yDFoX3QD8h419
   XFVG9+BOser61461irZwh7LO39217qKZ+0REk2ExWcMngIlSFwkV/ta56
   QjM9LXvX5TAS0kW/5pgpa2cfJ/vOMYz4t54Bvo8LiPGWrXzVCFhUalaK2
   ui11/ZMBPRX+LCz0uN1Nx4NsimxTRJ8FdQdO2+crMcnx7UPwScAxso1OW
   Q==;
X-CSE-ConnectionGUID: gIWsoo06TmOMHvoP/hGKAQ==
X-CSE-MsgGUID: oWzi+3wVSA+9Nge084yrJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="38395097"
X-IronPort-AV: E=Sophos;i="6.09,265,1716274800"; 
   d="scan'208";a="38395097"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 15:37:22 -0700
X-CSE-ConnectionGUID: KYvYs0GGThG18gHmwglEzQ==
X-CSE-MsgGUID: VsILM1oBSr2pDzlyguKnWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,265,1716274800"; 
   d="scan'208";a="57014184"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 15:37:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 15:37:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 15:37:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 15:37:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h+/f7x3Szh3/CxN6btEOnDAnxm+UPv99sfLKfPgU4MlJYbqE518JO8rAIKvhQAJxw01U40uC9TedwVmnUxfZmUbbu8cgDKS8pqE+wuLFLwzVMR8q6UfdfRrDgpl1c/EJDWH2Jc1Xfx2s21VIoCKASf0IDZq2h3HOYfkNIm52s9siAbkgrgYSJYn1uhhQ9rY7GXPck2EIuDH2ZEf2n7tZ8U9UAKNClEgKTMLPTosimKXYtGIFpvlnExkLeL/HPtIsrmAepyVu+gzeIkKTR88xGDedXsYaIXoPWZlc24H2gLbax8k3dM/zn2YzFK9GuNa9YHFz4N26raFutew8IphVqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVd8hLXUFvGRjq3rEnFY57+wUyzV5ZEkQweNtvY08q8=;
 b=AVpeR7Td6tptyoRnL6v1WIEOghxOOckJF2afTIY0bTglhSWZoQJBRJU+MCWTxmsS4w7UCuF8BbNgbqjKZmyUvR5e+O8TI1rnp6ypMvXNyy4lbotssNWcnLDACr9794KrQi9rnXDaLV4F/wEH8vNQNj63RPCnXAr/33lJ9LHFXWcRojCFMooCkuHMiZBXpHDqCxYiE61h+eHTVdmxk7f2Qd7D/aaCg5q6der4tvMhYs944DG+L0R72agalqxtmnmh8QaecsCrB3tUBkTJNU9KNzd9r6Xr3QzWI+s+V2QghruIttioqgPeMSIzLygCjmKOJzzF7oN55fQgA0vmyeEzuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by LV3PR11MB8694.namprd11.prod.outlook.com (2603:10b6:408:21b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Mon, 5 Aug
 2024 22:37:16 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Mon, 5 Aug 2024
 22:37:16 +0000
Date: Mon, 5 Aug 2024 15:37:13 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 01/10] x86/virt/tdx: Rename _offset to _member for
 TD_SYSINFO_MAP() macro
Message-ID: <66b154197e9e5_4fc729414@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <ce378ce8cdcc2b2ab6c8cffd6a6187c2001d138d.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ce378ce8cdcc2b2ab6c8cffd6a6187c2001d138d.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|LV3PR11MB8694:EE_
X-MS-Office365-Filtering-Correlation-Id: 09a75856-53bd-4574-e9c2-08dcb59f28b1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eJubp2+uVHdP/c63s7M8nYNosqOY+DjLm9o0BRSgvqsEpJOzgKaqr494zBVJ?=
 =?us-ascii?Q?9ETKoQl/icyU3OUXWZP3d/FTjUxQdLo/u38kRCfaD+5i71i92aQYRVCIwyHL?=
 =?us-ascii?Q?uU9CbrWaByeJRgNjV5nsRbW+7jaWl+7z0Dof5l4SV7/YFL9+JIqgElfk5R4k?=
 =?us-ascii?Q?6e01MN0e9wQC5UiBZy2jfO6XtWm7avoc4gceK7zkI19G607nueJTrMKkfilt?=
 =?us-ascii?Q?T0OtQwPR/bHNdVRjZmIV0K6mtBlkFm+N+CO+T8Stel3i2POjFyLG9e7CvfDF?=
 =?us-ascii?Q?Z2csEdO+ajNy+2j2SVLvYDAM59FbmpV1nFm9/7g141XJjzC9XdtQyvx94Ncn?=
 =?us-ascii?Q?zBldRKQRZFIdmJQpBBXaZ4nzR5eB71CfWGaMnaskyMxU8QV2LHsoHA4dCILK?=
 =?us-ascii?Q?AIPqG+no3ovgSjdtOPE+ZwFQrI7/4prkanBPf5WCGZXSaOyoTsqcCdF7oc/I?=
 =?us-ascii?Q?epIa6ij/p24om3j/+bYmQU775L/PNT6q/OEDuae7umlCpVR097HCnde7wVlo?=
 =?us-ascii?Q?ABa7IPx3v12cqwPpd1liIS7SIU/GYDhb70CWOEQ0lorM5fTzbMQkHovpIs0z?=
 =?us-ascii?Q?49loOVJcy7YizbQGAMgaVRkxNYuSeAuqtyPifvPZU7H6NkWvC7m+oVTh4RRx?=
 =?us-ascii?Q?YKnnz+9vGanOh7CYdoSsc63H8FF3QP8pckis8ffEp0sbGqCYMSzflcVfT7su?=
 =?us-ascii?Q?qDtwqV1VniABuw4nObIZiXmnm80ooPJ0t4a5lFuBjGObrFAMuWU2hB46Ryv7?=
 =?us-ascii?Q?20ogd90XrKgrmDQyZgpOVGSG6IV5ISYx8L0nDzG1xK8EIxy56MigVDhqQiJb?=
 =?us-ascii?Q?UNCslwrYUE+dwKRJ8y/qdYM7Zvv7AhrBRDE2PEiykKTQkawto+S82SLcwbDl?=
 =?us-ascii?Q?NzLRnsYaGm86dhLk80KKY6cet8vhjNusl9zM2RUtntMM/zGgfbtEG0l3I8qg?=
 =?us-ascii?Q?xvm5But55YZTuY7zPlyylBBa0HaUKcQRHcTUlIj882EmgxQgo6GwxRS8kelA?=
 =?us-ascii?Q?4S8QqdzcraAIukyffHO48eJuDVo4Uhh7w8v/25kmIVX63+uiUZlwx1//dVRG?=
 =?us-ascii?Q?dxjyvLj2YZX1My8Fg8vyx1YsyXAD+0d60cYXDjNOVOK2hc5pI5YjRJWIyeyQ?=
 =?us-ascii?Q?lgS6ZOetCTPMkKmp3I55V54alRstid3BH/4DARQPpjejE6cyuQoNSa2nZpm+?=
 =?us-ascii?Q?KK7OrlERMgwY3sHf0OveypiMoaT/TAtavk5WP7kVb4IErBJSQBHxVfQwKrzc?=
 =?us-ascii?Q?C+FDMlGPFqEUV3vUTy6YKMnv636FTFDu3/BSc8ZDsPimrqPnHZq1boH3/fpt?=
 =?us-ascii?Q?dRO70NoYEFCcAixbJPM0gebvhZ+IvuFa2DkaCGo5IlmdcttvZ64i8RqBSmWI?=
 =?us-ascii?Q?A6+mooJ9JqjWk6OrPkmaPeXn6jGR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sLSlwNOpUg+oahISbRh1hHy9B66i0DDXAt6wPeyPH89Mm84672svyyEv+IMd?=
 =?us-ascii?Q?jDXF7TOAZhWqZqCH3bgi9gPzPVdJ3QiKO8NuufGERwj+qhC//z45yDJETLGs?=
 =?us-ascii?Q?KgnUgMApUGYuZptdnbsRX/kg2feV7KRagWbzGrd3Ee5Z/6xGfhqDiJQ6gYvY?=
 =?us-ascii?Q?5GMMoA/wRbTlWoNXgbQZB/A/RtGb//1PNd7mmfs2HbGuxLZqYiEWFBq3hMI3?=
 =?us-ascii?Q?1IXy1Icqq2Lrk2ekIIEaSd5XTKPBGZuKWYJz+iUtr9SyvJiTB300cG1uPmWj?=
 =?us-ascii?Q?YDpsxYRJdTk0nPW5Wm0HNWFQVgZaatw0Mn8F9pCcU21b1SStBV6qsvkNLf5s?=
 =?us-ascii?Q?EfMuYjzW+0yi3/0xhZ6GnFCA5LpByiOBDZM47MNKscaF1RGqwSqYtmlUnXAt?=
 =?us-ascii?Q?oFIxU5Rhc8N8kKhq5jnQsq/jOrlHOb4RPC7ERboc4BTqysC2SCaGzTC1naRB?=
 =?us-ascii?Q?T33DncwryHVMGF7rq0vEzV0vDqINK9GfoNzoQd8imDZZYsyUiAR6HB7jr1Lf?=
 =?us-ascii?Q?WuY2sqhZ3Fw4p2dK9UOFgERTFPy1Ru9e6vfysQ8LHbEmZmJdJlWAcedh3hUa?=
 =?us-ascii?Q?3N7X0XI8JtJnACrGR4CoaNoE+lcs+491Szc4w6ey6Au3dKWAcWI4Rq/XUKyu?=
 =?us-ascii?Q?docCCdoaGe33YO24QOZYj6ZaXysZGKvVVC4LsVydYR2Vq63rKltN6/vXgYFK?=
 =?us-ascii?Q?yLYoqgT3c9ILSZ8mEmmJQ9BpwrylVT3K7AsyVGyI55D6nwfrv+4pfBjEpFD1?=
 =?us-ascii?Q?7kASdwKUXnxPZReLJFqDObtLkjaSFt2Yijbdw/dHUercGWhiUFO2FEk3IptL?=
 =?us-ascii?Q?ZsPntJ7NsOg+hhbxrclhRc9bLlfl/aG5MlDhZl4nyeqOoFOOawQ/w3eRgop+?=
 =?us-ascii?Q?+eWk+zwfhw6bIKpMwol7FnRNoKHmQeJKa7M4hOiRXQXnVpnBkH9fVUJi04+A?=
 =?us-ascii?Q?dngnlopDdaobbXiRn9bncWSoNgUdLBQ5lqbTkQpQDJKh7o5Ie+lpRdZARte6?=
 =?us-ascii?Q?MxAwMoKuJGCJ4tmZW9uITNHFz1P0V+/VP/ooq0feyQn2QusjVcxIc0kwzjyS?=
 =?us-ascii?Q?96a0QmYk4gHXbuKFK1KXrL8ehbrVH5bRaZ1vWplc08zZBM1/F+0za/Dt91eQ?=
 =?us-ascii?Q?q0iPhA0ekn0bERXakg4xDge53p6oxi6qqmA7XRtlmMrbPKl5xUjpm+nR3GdB?=
 =?us-ascii?Q?bfFE+8g7sG9u1dcW8fYwKvn5IbYZL62tYzsu5j6yX2rpTfUDDr9MuW6gnmRw?=
 =?us-ascii?Q?XrEOXh4OiJ2VNXkqe2UJLLt44W8AsykxSt9bfx2y4VIRAJdAp4DAi2PoJ15b?=
 =?us-ascii?Q?+UEsYBh+29oxCTEAIyk4mzO7MaA9ojvoJ4uI39ZZmizGfgxfqmYVr85b8SN8?=
 =?us-ascii?Q?CuKTsUgPnrXaV55YbUE5jt1bGE94DeH0q/Y31oOTt8w5VDKPAkXdfshS8iWY?=
 =?us-ascii?Q?c1SNp/yYPr6HZZUFP4yAF+sm38dTLC0MjhgQOBr99Pa1EoH1H8neoJMZ/wC2?=
 =?us-ascii?Q?7DPI5dKwwzv921yQnzGC1v9X/R0LhBO/fhmrXfewywJwFzGAVUAWoxkaQ3Oy?=
 =?us-ascii?Q?Qb2tJ283iPA/o5vYl0YmirlnLnl2U8ouHD47wvsVak+33OWvkH0J9rMobYLy?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a75856-53bd-4574-e9c2-08dcb59f28b1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 22:37:16.8235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JifsYj1pDM/XCM7KM0hOw2otB3cfKSUVMkhQcDsRBoMppKwjOhRfTKLZOZ3KuWAHdvdwNFNO5rcmVNndKv4b7Qs6DZri3IXgWQUCDI4fXTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8694
X-OriginatorOrg: intel.com

Kai Huang wrote:
> TD_SYSINFO_MAP() macro actually takes the member of the 'struct
> tdx_tdmr_sysinfo' as the second argument and uses the offsetof() to
> calculate the offset for that member.
> 
> Rename the macro argument _offset to _member to reflect this.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

Makes sense

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

