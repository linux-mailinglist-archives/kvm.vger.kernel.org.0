Return-Path: <kvm+bounces-39221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F23B6A453CA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 04:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF3957A6BE0
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 03:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757EB236442;
	Wed, 26 Feb 2025 03:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VsTJAZLs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF6B22A4F7;
	Wed, 26 Feb 2025 03:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740539419; cv=fail; b=KsJoiVG6rWWlI0KZi7aI7oajIcABSWeSWCSTQX+CIj0OjarfEvjO6sh/IW3smdSaBo8Re3DRKzxSd9P8FRi39SKyQDp5chT3xZbSERSRCETB8RQZLx57FQ1Ehf19T01EyMp/wuUA+ioKIyyET6EmUtd80z/XN4ZXldLC8R4p4Io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740539419; c=relaxed/simple;
	bh=eOWvWhAKVTGrwznicqlZYQiDeICtlpGVZpDjBauhpEg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XLDmY3M6S18d9UJSTd60GFpUZN8Ta2rc5ZxqQ9V721IaNy0djofSOvOGtM7zF8QsZHDRmdEPLS4RMMgPIf0/Dgc3CkRP3hkhzg38BYj2sOTU4Nx8wIlqAXE0gJ+R0h5p4ETDmrVDHhQB7Zl3IuMXulGIViPHPh2sER62oC81+PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VsTJAZLs; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740539417; x=1772075417;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=eOWvWhAKVTGrwznicqlZYQiDeICtlpGVZpDjBauhpEg=;
  b=VsTJAZLsc7Hj18TM0T6wXlnMZ8SbgiJih9kXcfJoar9S2Kb222j6SxyI
   2ZkXZEqY4DjVxmE9Df1W2Dj4XT+YuFxfFAjEKXGt5JFl5IYHBfxzU+/2R
   tOsfOf0L4eHWZeeGQiHvmGWAeQo4hW3Lh0UTlzxL5R+QYU/FMP3NL2/+E
   xYr4dJOZLonXDWlUWvVpjppCQliRqqor/iBol014poiO8wvhmo5eh6+oU
   gjck8kgYbciYDu2rt7fe34zoafUj0En79X8Cc/FWHsCAXbZZ050aPkrQt
   v7LUMo6Fs5ArsL/G/y8MO7gD9mCol0QjYxY/UHI0xCtmbFBR5bkEf69LB
   A==;
X-CSE-ConnectionGUID: I/0qtjcLTfqA6zeMV22Q7g==
X-CSE-MsgGUID: G6NyQKA0Rp2i4Z9MHPJXVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="41392086"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="41392086"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 19:10:14 -0800
X-CSE-ConnectionGUID: If5UTLNQQeabTLfRNzd/+w==
X-CSE-MsgGUID: PGUDgsRCSyeNn07MzTJQSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116434331"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 19:10:13 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 25 Feb 2025 19:10:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 25 Feb 2025 19:10:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 25 Feb 2025 19:10:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OX/awCL1rCx49MeRetLYt3qmy/BlmmK3Uo2/P+uDGydB2tjYRrhShaYc6eKiVc8BaISjKT3nEW/cBswW/6NEQSHrZ09jDTrI9+So4QDM2ZeWam4K4bc9wxsSOL+5TI/BWmxIGeP26rhoCMUGFRWoF8nfY+vCyGyCh43TMV/wVYZFtL8JFbujTjbusK2saolY6hiVQSAZUvRWAL+YRu/oWAmRUqmtbs0SdKoCCdNoo1uvVTULzB1C0S2EGJmWnd1VbWdKxthbho/fqFGXuc7WggZQyAzNVEquX8okqx+NTvihV73lXBp+qln1FSHUHzLHuYVe5E9iLHR71DhjUyK0OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxIrVoX7juO24uKSEqxmppmtkwD6cJ3osK3meIwIxjg=;
 b=vfrbRio1gA+DxL0XVHtYTK5kuUmB1v1ef//WZfxpjh+Fb1NT3gd32GkgsTYcED40+qm7nXLW4zGtIxSfWyDh71jaG+MZXJ77JU1gj3uBSdr5Y3pki6obnrty3OFDMGbluHkkhw9JbCPMz0uoxqAQarl6R3TzTtML4Vb9KWxr6Z2LpB34Tk0fkFxgSfcdXHApATUu2eCGFjtxhrijFjKzHET/F3DID+pxckbGUbmm2jQqxVTtR54JtYQygwNbNCGR0TQcIrToSjWEc60VOsJDY+U7weofdfY4qNhair32EECxrGCbOScBReP28Wx91jYvaKEOEsYrzXjWNR5FqX077g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PR11MB8758.namprd11.prod.outlook.com (2603:10b6:0:47::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.18; Wed, 26 Feb 2025 03:10:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 03:10:10 +0000
Date: Wed, 26 Feb 2025 11:08:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Message-ID: <Z76FxYfZlhDG/J3s@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
 <Z75y90KM_fE6H1cJ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z75y90KM_fE6H1cJ@google.com>
X-ClientProxiedBy: SGXP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::14)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PR11MB8758:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a82ce55-67b1-49db-dd7c-08dd5613149b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?N42aAi5s1zQtMDf5WH1Gw04ZUEOdZ+hlZo//wfdRHzewNWp6GLpR3xb/CBhk?=
 =?us-ascii?Q?5knkkyPi0FkLj4M9aFhigYPn5nbgSuoKVdWhe2qft9Ol01Dyh95K0Mq3/4+4?=
 =?us-ascii?Q?aQdSz8u/Ocrz4reu0MW2AKrnHCPvAD/BYjUcINIQuCOTLS+GBRY4VifRIVLh?=
 =?us-ascii?Q?RttPp7ZUUE6/BIUo3M9+24pqii0kclzkHAn77Ehsj7uMR98jG3dwqQaCEPt6?=
 =?us-ascii?Q?OvGtW4pgQfvX65VWS9PSdUW0WvOmrdhLNOGhfXB64daOILwDxy0jbXNzTesD?=
 =?us-ascii?Q?w3Czj1D3xd9tMW9pKmMVKVm/ttr9jPTIM7PN+dkzE9C1UBFZbJhuh13WCJYL?=
 =?us-ascii?Q?57lRwbjpxI20SaUzUWELFvPXwm1usJW+NRS6b0/tmVMq8Tg3wLuk3ciFK/rA?=
 =?us-ascii?Q?JMPIykZFtAUjfJSqXDuY/L2E8YfNiS8tDKQQUOs4fl7t6HYuCAx21OC5e3Xk?=
 =?us-ascii?Q?lxGvetaQdT6e9xbzYJtxiN8VCOaNOPzwk+/5N2KFWYqlNzOA8Q2V+kFTmlcb?=
 =?us-ascii?Q?+TRt7ddus7ipw5pK4dUd1R3aMK+3roAijNyhAatPggBdrdCNYHwADj2BGed9?=
 =?us-ascii?Q?0++W44EoZspOIzhPRRZRJiQ9PrWPvXS4f9sYmUjF0FFNe9rF92vWjOin1FU/?=
 =?us-ascii?Q?YgGY34fi+uglGzbhidxLE+iT6vss2oNwCZTMJR1tfqeARkvKfXRuU9dhVJQs?=
 =?us-ascii?Q?RjSz38asAJj51JkOl9w4rocMRFCLeS4Cw7EaBWOVitELnxjm6WTkKu7KZfYw?=
 =?us-ascii?Q?wDfOoNOQ7Tl4uPkXdYyGgXyelSjkb23zMmMz8k2yMzwbGEjRc6H8GtwHfV05?=
 =?us-ascii?Q?Qpwmi28AK4NLOPVMdXevKo+s6FmDdmqIlwqRUVOGR4onDguu/LwJGCvTITg/?=
 =?us-ascii?Q?hdEt/gPAPIkbQQLudMtKgGBeHWDevAZCFJvBUeOJvFWAdwQl63aMt5YAUqdU?=
 =?us-ascii?Q?zT97X0vIFzZjIu3rnY1x0crK+02v68QTayZt/Q7R22LflFIEj1483xpPQcnV?=
 =?us-ascii?Q?c8v2Y1GfTsRTSvn92WIjEtJXTwvUTyT1p9xK3cdWSUl+MGe5EbEHUdKxf1mH?=
 =?us-ascii?Q?tIEruagTKtGYyWn1bhr81awhgO975XWbNkeSufkA/w1qckAe3QiblHhQeqHM?=
 =?us-ascii?Q?/XOKFjW4wsk7Eh+htInxCMf2JZmVJGSDFOPL3f/B4BbbDsSYMICa4cUq+rZx?=
 =?us-ascii?Q?CRe6/mwq0JGfalOaHbiDmwBjxN2Ok79NV4VUQwyHlqjs2DgCTjt8Dinx0UJh?=
 =?us-ascii?Q?7wFvMxPlPPuSigJFgFY7SBHziB3srgjGFjcXCkCOyOrYUrWbBFq+fW8HrUPF?=
 =?us-ascii?Q?j6VuN/KK2CfAWukt3JQKRm8UD08giSGRBUqQbEOnThfNjllLKtQf3/XF6YrJ?=
 =?us-ascii?Q?2cSTZQhTwidvz+q00Aql+twgliKZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vaOFAHPWC9PWuzSfbmuZX++SYFYXfWlO8CR5qnLVRQycKNZ/Ttr5485qq4Lr?=
 =?us-ascii?Q?xPSkB1H5Q6yZE0CYQxk+7Bhfg01ze2ECx6Q1yPsFnoNwuc8vMKHw0/7ELhu5?=
 =?us-ascii?Q?CCDNFaZC0ac5xDxqzuPTLRJtoYvgkkQ4iiPLsCw0PQmp4AFUeMcAR7j4yUm3?=
 =?us-ascii?Q?YMPC7C3KcS+oE7whtiW+yYJID+/I4sVu6EkSCi+vFqp9uwyNdXfwIntiTbqQ?=
 =?us-ascii?Q?5jXZdU4Gd2YikktrDHlg31rtncBw64e9MGQPt0k1derlt3f5thFXDZaOvH8D?=
 =?us-ascii?Q?TkqrQyWisrVg6Cj6KMCfpeFwLoVGmLtuLbMl68XcQscbnTbMQ52c9y+SCj0V?=
 =?us-ascii?Q?GKe33Uo+k59Q/OUKAxY/oNmmCc+YBdJAT7xXBLcVxdK3xUyLpstW9QnR0UYe?=
 =?us-ascii?Q?Wa9Zcu0oLn0Rt59rPZ7s+oe/22aoef+gJgWThXbDRzV8+48Sych3ylWEpAx3?=
 =?us-ascii?Q?zdQB3s0/2ZPrnKnSXJ1GWg9Dq0pwflPWPFSL0Lh8Chm1BDM1Bwf3k1sHQ7zt?=
 =?us-ascii?Q?GkWljOw96smBnRsVPLPpte7m1isL/LJCqtweDEy0JmcNCYp5qtozw7Zmvz4/?=
 =?us-ascii?Q?SjE22xOAjwuq2dwLLN94OGxWYVq/pwstgpB42HGGCm3p/2khVMeebZ7IDuX9?=
 =?us-ascii?Q?RdsEQTRfrzf7GHaSpIhFP+5uTCja6KczIpQyrtWVbdKv/b4+TzwjpYSkjD0i?=
 =?us-ascii?Q?r+Fl65AIQ6KqCBQHxMhsIKpnYsM4Xpct9/IGpFGtsXFJ++XqdExZEctQR1h+?=
 =?us-ascii?Q?a7c7OeK0pGYqlsRYiP9D0UkqF0sI1hrkra/ALpXFrFFxbFfIVmDTyY1a72MR?=
 =?us-ascii?Q?s26nELEeVt6dUnUeqcSz9AqpKJSlvHsLqbP0k3iOiWXUJsELIpY/ifU9o+4k?=
 =?us-ascii?Q?wHuP47T0gR9fs0yAe37WnAFm1BarNEvPa9XVfECgx2KzhOQmTfzd4QVy48bg?=
 =?us-ascii?Q?F/4a4xhqe2Rhtc55//dU0lC5OWsVlC3WDGnykNwJxHM/uElCy82945O6xugq?=
 =?us-ascii?Q?dA2mpcN2s+ThAJxQjyu9wjdTVXdisrelE4snMBLCXXbgP2lxbLiRwevlxsst?=
 =?us-ascii?Q?cb9CwHvrp2eX4/s0UVwHcbCQzo7UBXgS8uEKseWBHoaco5xFT7lFZmhg2DfP?=
 =?us-ascii?Q?A0gyzPwsS65jWaUwEN3d3/oucaVVgsNIm7lhJ8VftUZjZJI9iQJqyk8i2F4W?=
 =?us-ascii?Q?LTAXcKjvgwn6mC4DTzMoMenMzzQzyuXTYqFp3HJ8+cwWzu7jOG8TKHa4J4i9?=
 =?us-ascii?Q?GKhkxNMjn6lKdIPI29cQmPkIonQ89bPIK1gJuBIQWKSwUVwDbQ9TzAKol9z4?=
 =?us-ascii?Q?1DFw5KhQm/x92tENBhGgXHgxvQwqqa+ICpxZcF+aukw+MQuBqP34yDa/itjY?=
 =?us-ascii?Q?H5iy4uSYglQIsS54GlZFizv5aNsSdrR5kQbIdpyNQFGuZEpQ6UteS5IO1rSS?=
 =?us-ascii?Q?4EA0Pu0gJvTTvWmRVkXsEpmNF3iXWIDZeAZO8FejnTJS9vN5tTjspoymBWUN?=
 =?us-ascii?Q?2jWxSNa4o9MP+7Mc9GbPg0vymH6fvLqomT7JQB81V8iLtITkuHJP1Cj+vJxh?=
 =?us-ascii?Q?7YGtkMdlQ01DFzoA02jfJDfJktEbsgPm0+WGb7H0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a82ce55-67b1-49db-dd7c-08dd5613149b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 03:10:10.7620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUNsR9BLwGgiZqpL8yK3O3LhdIqL0v/zfm9a0I26hCtDiLVPuRnZI58IwANFV510xQZcbEfDbQA64psBA+4L3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8758
X-OriginatorOrg: intel.com

On Tue, Feb 25, 2025 at 05:48:39PM -0800, Sean Christopherson wrote:
> On Sat, Feb 08, 2025, Yan Zhao wrote:
> > In the read-only mprotect() phase of mmu_stress_test, ensure that
> > mprotect(PROT_READ) has completed before the guest starts writing to the
> > read-only mprotect() memory.
> > 
> > Without waiting for mprotect_ro_done before the guest starts writing in
> > stage 3 (the stage for read-only mprotect()), the host's assertion of stage
> > 3 could fail if mprotect_ro_done is set to true in the window between the
> > guest finishing writes to all GPAs and executing GUEST_SYNC(3).
> > 
> > This scenario is easy to occur especially when there are hundred of vCPUs.
> > 
> > CPU 0                  CPU 1 guest     CPU 1 host
> >                                        enter stage 3's 1st loop
> >                        //in stage 3
> >                        write all GPAs
> >                        @rip 0x4025f0
> > 
> > mprotect(PROT_READ)
> > mprotect_ro_done=true
> >                        GUEST_SYNC(3)
> >                                        r=0, continue stage 3's 1st loop
> > 
> >                        //in stage 4
> >                        write GPA
> >                        @rip 0x402635
> > 
> >                                        -EFAULT, jump out stage 3's 1st loop
> >                                        enter stage 3's 2nd loop
> >                        write GPA
> >                        @rip 0x402635
> >                                        -EFAULT, continue stage 3's 2nd loop
> >                                        guest rip += 3
> > 
> > The test then fails and reports "Unhandled exception '0xe' at guest RIP
> > '0x402638'", since the next valid guest rip address is 0x402639, i.e. the
> > "(mem) = val" in vcpu_arch_put_guest() is compiled into a mov instruction
> > of length 4.
> 
> This shouldn't happen.  On x86, stage 3 is a hand-coded "mov %rax, (%rax)", not
> vcpu_arch_put_guest().  Either something else is going on, or __x86_64__ isn't
> defined?
stage 3 is hand-coded "mov %rax, (%rax)", but stage 4 is with
vcpu_arch_put_guest().

The original code expects that "mov %rax, (%rax)" in stage 3 can produce
-EFAULT, so that in the host thread can jump out of stage 3's 1st vcpu_run()
loop.

	/*
         * Stage 3, write guest memory and verify KVM returns -EFAULT for once
         * the mprotect(PROT_READ) lands.  Only architectures that support
         * validating *all* of guest memory sync for this stage, as vCPUs will
         * be stuck on the faulting instruction for other architectures.  Go to
         * stage 3 without a rendezvous
         */
        do {
                r = _vcpu_run(vcpu);
        } while (!r);
        TEST_ASSERT(r == -1 && errno == EFAULT,
                    "Expected EFAULT on write to RO memory, got r = %d, errno = %d", r, errno);


Then, in host stage 3's 2st vcpu_run() loop, rip += 3 is performed to skip
"mov %rax, (%rax)" in guest.


        for (;;) {                                                                             
                r = _vcpu_run(vcpu);                                                           
                if (!r)                                                                        
                        break;                                                   
                TEST_ASSERT_EQ(errno, EFAULT);                                   
#if defined(__x86_64__)                                                          
                WRITE_ONCE(vcpu->run->kvm_dirty_regs, KVM_SYNC_X86_REGS);        
                vcpu->run->s.regs.regs.rip += 3;                                 
#elif defined(__aarch64__)                                                       
                vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc),                      
                             vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc)) + 4);   
#endif                                                                           
                                                                                 
        } 

Finally, guest can call GUEST_SYNC(3) to let host jump out of the 2nd vcpu_run()
loop and host assert_sync_stage(vcpu, 3).


However, there're chances that all "mov %rax, (%rax)" in stage 3 does not cause
any -EFAULT. The guest then leaves stage 3 after finding mprotect_ro_done=true.

GUEST_SYNC(3) causes r=0, so host continues stage 3's first vcpu_run() loop.

Then mprotect(PROT_READ) takes effect after the guest enters stage 4.

vcpu_arch_put_guest() in guest stage 4 produces -EFAULT and host jumps out of
stage 3's first vcpu_run() loop.
The rip+=3 in host stage 3's second vcpu_run() loop does not match
vcpu_arch_put_guest(), producing the "Unhandled exception '0xe'" error.


> 
> 	do {
> 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> #ifdef __x86_64__
> 			asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) : "memory"); /* mov %rax, (%rax) */
> #elif defined(__aarch64__)
> 			asm volatile("str %0, [%0]" :: "r" (gpa) : "memory");
> #else
> 			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
> #endif
> 	} while (!READ_ONCE(mprotect_ro_done));
> 
> 	/*
> 	 * Only architectures that write the entire range can explicitly sync,
> 	 * as other architectures will be stuck on the write fault.
> 	 */
> #if defined(__x86_64__) || defined(__aarch64__)
> 	GUEST_SYNC(3);
> #endif
> 
> 	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> 		vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
> 	GUEST_SYNC(4);
> 
> 
> 
> > Even if it could be compiled into a mov instruction of length 3, the
> > following execution of GUEST_SYNC(4) in guest could still cause the host
> > failure of the assertion of stage 3.
> 
> Sorry, I don't follow.  The guest doesn't get "released" from GUEST_SYNC(3) until
> the host runs the vCPU again, and that happens after asserting on stage 3 and
> synchronizing with the main thread.


//guest stage 3 
do {
    for (...)  
    	mov %rax, (%rax)  3.1 ==> host mprotect(PROT_READ) does not yet
	                          take effect, mprotect_ro_done=false

} while (!READ_ONCE(mprotect_ro_done)); ==> 3.2 host mprotect(PROT_READ) takes
                                            effect here. mprotect_ro_done=true

GUEST_SYNC(3);                ==> host stage 3's vcpu_run() returns 0. so host
                                  is still in stage 3's first vcpu_run() loop


//guest stage 4. with host mprotect(PROT_READ) in effect, vcpu_arch_put_guest()
  will cause -EFAULT. host enters host stage 3's second vcpu_run() loop.

for (...)
    vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa); ==> wrong for rip += 3

GUEST_SYNC(4); ==> since host still in stage 3, even if we change
                   vcpu_arch_put_guest() in guest stage 4 to "mov %rax, (%rax)",
		   this cannot pass host's assert_sync_stage(vcpu, 3);

> 
> 	assert_sync_stage(vcpu, 3);
> #endif /* __x86_64__ || __aarch64__ */
> 	rendezvous_with_boss();
> 
> 	/*
> 	 * Stage 4.  Run to completion, waiting for mprotect(PROT_WRITE) to
> 	 * make the memory writable again.
> 	 */
> 	do {
> 		r = _vcpu_run(vcpu);
> 	} while (r && errno == EFAULT);

