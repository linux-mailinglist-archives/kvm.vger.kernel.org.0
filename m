Return-Path: <kvm+bounces-38543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B19EBA3AF6F
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 03:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC7347A4470
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD19189B8C;
	Wed, 19 Feb 2025 02:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUrS0BYt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136922BAF4;
	Wed, 19 Feb 2025 02:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739931537; cv=fail; b=E3HUwJbWihlPFpieW4hwzOIYBW/omVHQ5i1c+6xYZsC2HlG1iMp//2lSmVGjv78hPUPJz31OrbRLM9MCaDhWDKIhBqiQKlXHuzBLigNtv7kl4zM4TAWxos8tcpLKPDOsbjOeonWeBh72i67VNWT6EmBS8moHsOTIbT76ULSkGQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739931537; c=relaxed/simple;
	bh=3KxPhcjWhr0DBvR+1wqlsPrjSFZ8zxUMhGGW10fJUG4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oiN0T9B4HVjSiCb0LQ8iHJY6GXXQ1ZDSYSX5pOoV+s812cbRu8joSk+L1aTfHNGqDZLhD2B23i7BalcrTd0CVqitMAOgqD/XZxpcG/OlE5ghoC1hyUBBy8d5OmNBHrcsWKcv3vnpJdo/IH4EKEYUJW3DIro4xiuZLcWjyIF/Pso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUrS0BYt; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739931535; x=1771467535;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3KxPhcjWhr0DBvR+1wqlsPrjSFZ8zxUMhGGW10fJUG4=;
  b=aUrS0BYtH1mtwyX6XV0e8E5q4W1dTtQrr7haO/EqMyrNscoolkFlqU5c
   nbGTha62Ry/+OM9S4IsFdHQ8ALpLKF5Rj3dB2g4oV+xMDeoXTFn2qObTT
   MDaTK399P69LEqOyrvqxl06a8Qx0uZ4ytrN9bFXMisLWAVf05G/5YHI1U
   SFYsKU/MdYvut2ToAaCDJbqxXJiBcPmEqeyHWmq0BvtaAdSJz8fMJ4H7s
   G8svur922cde3zUaBuVLWyTXoKsd9qAVvXi3SZHwfA8wyC9DYwzxASD/j
   Jy1FVHilhLpt5XhFWPIi8vmWGKEDaLQZM7MGtb/16uqylJKpR3ABo9sDv
   g==;
X-CSE-ConnectionGUID: ffs9R8xFRviwG9pPVnUJPg==
X-CSE-MsgGUID: p+KHwFuURiS81ACFebgBrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="44303742"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="44303742"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 18:18:53 -0800
X-CSE-ConnectionGUID: kawTZEPlSha0adWIR51Q5A==
X-CSE-MsgGUID: CFSfk9UmRaaamVQ2THb3HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="137811549"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Feb 2025 18:18:44 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Feb 2025 18:18:43 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Feb 2025 18:18:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 18:18:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ythL3NKq3YgA9oxwtqq+X9n6tdeUwUZtUFPZzjBFdkG8MilnnLOELrgaMqQFeReibPFsAY0WCvsew+feEeHxH3gTsuBUlzs8r83AiJOuoQ88dUj2bR8IancS9ar+Ay6hn3efxzsLips8xKvh8yWA6GwZxkfLqS37PVDj7li/FXKQpZy+sk7oIN8g1eoBu13fKc/TTvvqGC3g/GTiyBL8qTk9MtUaSObff94jJ2LtI8tybHYK5iMHaCyd/O42WC97Sda3fVm2OBdEZ08QTfjpsGYZ9mJMC/1KnJ/+LX6UfR17XcA8OFbvUMc5yrkygWcTzdKKAi7KwY/M8Xz/3ZwsxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skrnIgWNxf2mR++BVGUHRG6sueY4uesV4tFpi6vVL8k=;
 b=TMPWMRn7lQdgECic4/H6X20dV+Csigl5ny1MD99z4OYoP9teOmAU2f3vf1hqRwiKoTNhH6od+m0MomxdhH486vpMkQr8L332f4Jj8jzaJYUN7L/tpynCqqJnNWhG2+Dkm28q7nerW5rffWjIPRTKAmi9bOvupASk3GiUOHYHl3dzhTTwWDtx9C883AGkGJ4ETM9SBfNFa3N/DuSmy1sEsYKCIGzqwMoWSnmo0nEJu38GEAC6qhsgZ/CaZ971pFrGXNKFhXEhKju7WqAjJWnPJyHno+RDBgDtWrFod99P6CHvPiQMaZfLSUuIxuSBVc3U5CnokeykUD9yEiDyyeH55A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.14; Wed, 19 Feb 2025 02:18:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8445.015; Wed, 19 Feb 2025
 02:18:19 +0000
Date: Wed, 19 Feb 2025 10:17:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM
 dead
Message-ID: <Z7U/IlUEcdmxSs90@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250217085535.19614-1-yan.y.zhao@intel.com>
 <20250217085731.19733-1-yan.y.zhao@intel.com>
 <Z7SvbSHe74HUXvz4@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z7SvbSHe74HUXvz4@google.com>
X-ClientProxiedBy: SI1PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 29d96644-2b24-4afc-d81b-08dd508bacf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hrxo4mh5myQwfFxvWrC83MR870wjYmv5q4010yo8NMZSfRz9wvOOofKD9/Di?=
 =?us-ascii?Q?XalYVSwNKV9gEPMhySHwYz7sLDXSL5DWIREsdixfg9AL73JSKC1YT7w0EX4d?=
 =?us-ascii?Q?Sb/dqfjKP/PyaFghir8gBKYNFhIau5VDgAjFYQttzNAScrPnC3yoY6K29cAX?=
 =?us-ascii?Q?hpJi/mDfggDNF7iPk9J2dBI6eMullgc3dbMHY4gVLMEp1r+wk6klHJ7TSw5z?=
 =?us-ascii?Q?Gr+vkyWVb9grblkGpgLyXoqrc7OJvzXx36xAWcBvfs5ZOu9uQOU5J2CxEiF0?=
 =?us-ascii?Q?2c2KH3wgIMvylmpHNZV+HevW20gWtHHSZz1oZSCAfcR6dVnuqi5S8voD+aFW?=
 =?us-ascii?Q?OW+GnH/FRMGzHLotuI+HHulL4WP/Xf1tIO77IVCsiKIZ2lTYHEMFcPuXUa3M?=
 =?us-ascii?Q?oFDTxIg3PJb2cPn61YA0TK5OZSgrQaNQVWVv5cU2ioko6X4zv7QkEbTnrmkg?=
 =?us-ascii?Q?MYD8SxsYLieMQc4syAmJlUuEwF16Fu6mEp3YR9HcAYv740EiFkrkloDSAxWV?=
 =?us-ascii?Q?/CfF1edxiiXZP7vDPibQyue6/BsXgdkIPEKubVXT5P1e46L01klQLsb3m75R?=
 =?us-ascii?Q?qrNPszlZ2GTIb10uKtbIJj4TqQaNRoZKK3Y3nW0vr314/YUuLKoYCgzYe8MU?=
 =?us-ascii?Q?IuxfWe0YOK5lwK1LKZ2OC11fP/mQoJVGBWMLCxxR5IGXvY7XSE7dEdPJVXmY?=
 =?us-ascii?Q?pHOFKG0syJHMkqNTIt/DKuWeL2m0oJAYFv2FqR2lo/2064Cm54G6yE9CHsZl?=
 =?us-ascii?Q?/dv1Q6sBKPL8vATRR4RrJFRjfGcx9gzbzhR46QAXm0ppSmxSIOEwCnTLnaIR?=
 =?us-ascii?Q?78kuYGxwZg/VboL9FA1mhbSTSdBdiU67adZH1htDqpD3V8dr07hnYqb2DNhv?=
 =?us-ascii?Q?zZtu86/fwR+eMN0DDLJKqezPbnF2TcqR6oj0NuvYpN2/Q3IuneAjTJkC+Y5N?=
 =?us-ascii?Q?rm2IVPOA3VRRbX4KvGoC8WAlPy1QTOQJI78J4VyrcLfsSn3ounLsje2APzGh?=
 =?us-ascii?Q?fZD9TR/SRjCu5kzxwAx1pBmuoOFf+ngksPFgT6UYBHVGGAJ5UM3Mu/HOkoO0?=
 =?us-ascii?Q?6ZoEXz96ZRQKWZ3nOScHEq2cId2XodPT9SYs97d6zJqSMhYRSAWbHte2xM/R?=
 =?us-ascii?Q?8rnnTiF96fS73ZpJzxZ5v0M/Rs5237/YBcPtb7fw0oxhjrqas2RZhZALKAmD?=
 =?us-ascii?Q?3mpD1kY8tDI2h1tDt+aBWbcihm1qznZQSuEpkk03qJqO3LWI++FUhti/PyOi?=
 =?us-ascii?Q?rY2JnBEhyUAOzVkzCbWqErc0+MfC5Enge785G0gcTCexQQzWEyaEFMLtiy1U?=
 =?us-ascii?Q?14v2Iyg9Ch0ahPDkBCkHAuZYEsgorEeddWnKx+UC2hs2v5omY6P8bbanUPJM?=
 =?us-ascii?Q?q3DQSCKD3zAN8jCyxo/HJQJzR58H?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?acWFFypGRmRe51tz6jZXNJDCf3yFTbfHINDy7xz6UoTZ/LXRTp9dB+i4DELj?=
 =?us-ascii?Q?PepGuI6QGPn0DhOEdnsWEsJxp6/GYSfVaeXngO+VO35JPu/lqRKHl2RSHdg7?=
 =?us-ascii?Q?dqYp4i4YoY+mEIqO0h+jUol2GukJbvcOVgFDBTmqQ2fxpECD3gt40ArhzvEm?=
 =?us-ascii?Q?II+Z0ZcFY9KUXBHu9CvVHhmVJyDAE1/53CE7ib8F1MlTecRF/eIRTFKW9Bu5?=
 =?us-ascii?Q?PUjqJ3H9311lFejSqEPWvKwRy+0ALEsrAj/5DRslRYKpYxe0mQv1U9Rs0vbZ?=
 =?us-ascii?Q?7Wg+XTtmJr9TZoVgWoKu4Y/xx2r+hJ/a+hRvL9KPV9EigvSyyvUtZDCEN4AV?=
 =?us-ascii?Q?ZQJWE/pX2tM+IeVaIXltH5nsmWb56I3g5/XOoIyNGGEoZyw6hFdVvI8JHi6O?=
 =?us-ascii?Q?iRq4RWvpBlXqo7HRDO7+8y3vOp8VQMqy5xXS5ZB+tzY7WGYdZrjCxEn9/TGI?=
 =?us-ascii?Q?eyOzpySd2R/p4zf5S7hkQaFcr8Q2GtI/OKa6Fbnv0l/tOWjtiw2VOc5N2DL3?=
 =?us-ascii?Q?O7SKFiGdafUxYtMrsN0q78heqAceck2zTuOAY6ZLMMqI0Sxc67uKDHuo37kQ?=
 =?us-ascii?Q?GPWLfGYjbSZ7WWKP/IsSF8huJkvpOUD5c4W/AAkez+bjOdVCHUV4SpmzXx/K?=
 =?us-ascii?Q?83aTNH/0etUjoo7B1O6OEMxzX+/Nvm1kh2qc9TGXhKVPhsWTTK/CmeGSKsU/?=
 =?us-ascii?Q?364MQoO3WgOAoPH9+OyPR0baoszCoIEdVOLMHi68Zw+b//vY7hivTgs7O8sz?=
 =?us-ascii?Q?QN8ICA4wmf0Tz7eNNnyt7XCn32SCohwlAOmBMKGaYgZI3jV5qE1CRrK3kgmV?=
 =?us-ascii?Q?v9pmqnQIAD89gAUu2UhtUWC7P0hckJXp/53kMxgdcq6J5oeOCKKRyV+Z87k8?=
 =?us-ascii?Q?XvOhygcYFBXZMqcUhyY0nNuqVxx10/0kphJQo6VZQshhxbDSJJC8WQONcqET?=
 =?us-ascii?Q?n184ioM4Ixadgk6ATK3Y5wH6Qzh3XwZbl0Neoeu3w9GwKnLck7pL0QFB+Fdb?=
 =?us-ascii?Q?y9QwVB3IH/Ve03NtoCPIyYEr+a58ufAGGl2+AKd9qbu/qgqgsitbjHVDm8AW?=
 =?us-ascii?Q?/vLG7LD9ugB3Nk+N25BzsgRz8AMEuvv6PnzJJ6tdghtOs5P7TV2pWfi80IpK?=
 =?us-ascii?Q?abt2nIENL6EVhqOvjKIU46Z3TB+Z1rv+kHRwghXAybuIIq/OrbPr47ZrwmoD?=
 =?us-ascii?Q?C4k00RKG40G+xmXJHBsMQPiLhf5i9q8j9MtnxySxFmHwP8exy664ff6uJ+/f?=
 =?us-ascii?Q?fKCw3pss6PRkRj5+bMKVFpv6hlGXz5RjqLG0W8sXrGKJZMgW+56C/Hx6Er0e?=
 =?us-ascii?Q?x8vbpDCp9/8YBo3CCHUigXrbnIQUSyjGbWE5y/qqHeS/tyAk1F1s8XFpfsF0?=
 =?us-ascii?Q?50E5KXd+LKcg1Vjcmk4iL/nzncn5EXHRIxJFuO/ys4fmN28sU00vpcCC+9wO?=
 =?us-ascii?Q?YGkzI0NDWieP+OPEILxTvSK6bbKkG4G6v5ADk2wBRHpiRzn8zu8+wzZOT3aj?=
 =?us-ascii?Q?HGqrWZjTKhIgkgIJ/fNM5n8lQDF4xft2360qBBlazMtoieVPvqycTokGn7KT?=
 =?us-ascii?Q?Z/lXVdRUGo0JXhb4t9YJHyLluUZklzXSAWnp3NW+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d96644-2b24-4afc-d81b-08dd508bacf3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 02:18:19.1424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RmYIAv4pmdFrr/niNV1qYrr0gXxcjei3gPyqCOK0yZkrsaeYXi/L4aMet44c6EK7LT+x5Rjy6U6guH1sKvBEZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com

On Tue, Feb 18, 2025 at 08:03:57AM -0800, Sean Christopherson wrote:
> On Mon, Feb 17, 2025, Yan Zhao wrote:
> > Bail out of the loop in kvm_tdp_map_page() when a VM is dead. Otherwise,
> > kvm_tdp_map_page() may get stuck in the kernel loop when there's only one
> > vCPU in the VM (or if the other vCPUs are not executing ioctls), even if
> > fatal errors have occurred.
> > 
> > kvm_tdp_map_page() is called by the ioctl KVM_PRE_FAULT_MEMORY or the TDX
> > ioctl KVM_TDX_INIT_MEM_REGION. It loops in the kernel whenever RET_PF_RETRY
> > is returned. In the TDP MMU, kvm_tdp_mmu_map() always returns RET_PF_RETRY,
> > regardless of the specific error code from tdp_mmu_set_spte_atomic(),
> > tdp_mmu_link_sp(), or tdp_mmu_split_huge_page(). While this is acceptable
> > in general cases where the only possible error code from these functions is
> > -EBUSY, TDX introduces an additional error code, -EIO, due to SEAMCALL
> > errors.
> > 
> > Since this -EIO error is also a fatal error, check for VM dead in the
> > kvm_tdp_map_page() to avoid unnecessary retries until a signal is pending.
> > 
> > The error -EIO is uncommon and has not been observed in real workloads.
> > Currently, it is only hypothetically triggered by bypassing the real
> > SEAMCALL and faking an error in the SEAMCALL wrapper.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 08ed5092c15a..3a8d735939b5 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4700,6 +4700,10 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
> >  	do {
> >  		if (signal_pending(current))
> >  			return -EINTR;
> > +
> > +		if (vcpu->kvm->vm_dead)
> 
> This needs to be READ_ONCE().  Along those lines, I think I'd prefer
Indeed.

> 
> 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
> 			return -EIO;
> 
> or
> 
> 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) 
> 			return -EIO;
Hmm, what's the difference between the two cases?
Paste error?

> so that if more terminal requests come long, we can bundle everything into a
> single check via a selective version of kvm_request_pending().
Makes sense!
I'll update it to
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) 
 			return -EIO;
in v2.

