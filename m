Return-Path: <kvm+bounces-41640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C70A6B2C0
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 02:57:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2685C486A68
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 01:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DF71E25EF;
	Fri, 21 Mar 2025 01:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HrvuBzKY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DA91DFD86;
	Fri, 21 Mar 2025 01:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742522270; cv=fail; b=B9LxaLuIyOjAW8ceYGLFbf/jTj5tsSZHup9A9vq6YEkUU9yWXSBslhj/ymsxzINsPbBBJk0aALegcANcQqukOu2wNbP4w0ZX6UB+DPpJUX762jvvyTHial4HYrd3GWuLkcp0aIBNJA0Xz/agZdHm8uKKNgvemU9dec5vvvz7frI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742522270; c=relaxed/simple;
	bh=lKOZXtLhYxn6RkS5gM9l27UYSXKiNI7CU5paKMxn+Ic=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jRWK7IZVded2U9EWBn6vDKdpaK8dxq4pUKoG+NS/RC7df430BV2xc9MXs/2wEu444bwHitydlLthfGlw0tdbJ+lZFaGZxRL/u3Lp4yEs95STsMe0LZanvduj4BMYkJRU//9h3YuWzGBNdWDwQCvFOoaLI3YqorXLv+4GcCGga1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HrvuBzKY; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742522268; x=1774058268;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lKOZXtLhYxn6RkS5gM9l27UYSXKiNI7CU5paKMxn+Ic=;
  b=HrvuBzKYdXUbYAEfwyyUmyvXtC1LxR6xW38sqpReaWigz4b5tdpm6h5p
   Ke/xotjx+OX0BckVB7jhUxm69nOVzWh5y47StopeKBlbxH/f6SkobcVfm
   bW6PpIS/shP2kRsqysV7KEDbQ/l+SvzW3IVN+N7j6+7R7xoMVGYeBnJ4g
   t/VsCKWLLg7JXKb52Cc5Wd+vBoComWwzKnYww6K0zYLgZmGnnbO+kIKME
   YhbHJCMbBdWI197m/lE9IFsuRDRH3Gry0cSiZx81Dw5hcYke4FSgxCZOI
   MEXtkuZGRVC6y2Y0xdKNlYsN5ecZAbQZ4i3TODf30IlV4xsnMBdBSkzNX
   g==;
X-CSE-ConnectionGUID: XJZvlz/NRJWaw3NrkI/siQ==
X-CSE-MsgGUID: I1wMdJC7RjKtcUSnBpaUnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11379"; a="46532476"
X-IronPort-AV: E=Sophos;i="6.14,263,1736841600"; 
   d="scan'208";a="46532476"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2025 18:57:47 -0700
X-CSE-ConnectionGUID: WKOa74b6T1m/D7rovv90HA==
X-CSE-MsgGUID: zJga1rsYQV6n4oQakIiyTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,263,1736841600"; 
   d="scan'208";a="127952284"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2025 18:57:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 20 Mar 2025 18:57:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Mar 2025 18:57:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Mar 2025 18:57:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vbba1yqtAyZ2/7gR/euYbVlpwBWuey/lmistFnVoO9H1/mjN9t9dVuMXHXOBZtXobSioPhkYtq9k3QjI1Zn4OA/krBEwWkJRUmZXCeWOvzW3MHjQhD6uOXU2HTO9f5XmwOfjXT/OUjcx8itciWlzyP/dlo8dS/xikWPExzg7XTjssS7DKDm+oPUkDrWUn8bGCgLvc0IxRzKpgYyM4ogo28DBLzBqZh9R0LXZlyWF3g5iRgptES5al8XoiPRREMb5aASmatmXBjCjyraLoiRp4B2cze0OctMI5rLkQxPbfPFVZTQ7dVn2ky+yXYB4ObYtJmlkgtroqrTO3Qj84wOAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7oe95otT25Ft+KvjzKVDUl8yb4qiFrHbV4RDTlbO/M=;
 b=irkhMv85yozVE3HGcPpkTtfwtgkHY0EsSZESDoNv6FK6jQZqdM/MDTajP+elkUXCGRX13RyWd6fouShX33EnV9w/WPL+/K9sE9vwlWvOKJjhAQ2OXIH+EYHcKB4F3j39sKFDl7iDM7YXMZdMxGhx+MmfA8SAW/SIRH2mEhi/8DEk/cwQU6pBakWDTrtpzJQf8UkT2yfNhKQf8zcNtqXXN/7+vuHXDU5fATOkiJoVdBqdo05RF9Ups0gBpclHp+aJ9CeQCOAimvt02zZw9FlgAGxkLwukHhLFjix0CZ5FjDY8ptuRPKXmQmhbhB5yQ+rXuLbjITEq6yi0E/qg27JUbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5158.namprd11.prod.outlook.com (2603:10b6:510:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Fri, 21 Mar
 2025 01:57:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 01:57:43 +0000
Date: Fri, 21 Mar 2025 09:57:34 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH v2 3/3] KVM: x86: Add a module param to control and
 enumerate device posted IRQs
Message-ID: <Z9zHju4PIJ+eunli@intel.com>
References: <20250320142022.766201-1-seanjc@google.com>
 <20250320142022.766201-4-seanjc@google.com>
 <Z9xXd5CoHh5Eo2TK@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z9xXd5CoHh5Eo2TK@google.com>
X-ClientProxiedBy: KL1PR01CA0016.apcprd01.prod.exchangelabs.com
 (2603:1096:820::28) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c9ef13d-afae-4b95-7417-08dd681bc526
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ioGfeQsTo+03y5MWt+UsoxNj4stdfH6zdkn83vQOrAxrt/dUcCAzbA4v3a+9?=
 =?us-ascii?Q?UqiZiny3qNyq+nKJ0uwT2Lbbcsuml7+eQ5W3bDFO69oJEUTOxkPEp3ft2Xl8?=
 =?us-ascii?Q?ujfHk7qX2VEJUIIgnG6gUKVhyL59VW+o6bJ3dWj1PuX0UNvKoYgUyLOKQUWS?=
 =?us-ascii?Q?PoFRnbZ9Jt8jVdBZXOAgZeu3O1HbCo420tpNb5GbQiOa+TWd5VmX7JZBT8Ii?=
 =?us-ascii?Q?LW5X91pik1LpNOt3hJD8xE/7uKvBZe+YBjgs+87ba/h2j9Yz/NFgIf38jwIK?=
 =?us-ascii?Q?KIUBpu0y6UlvqEYgyhywuni8zkhaLdcrP16cVcmQK00yhPLtG6EBc9OWt+gc?=
 =?us-ascii?Q?MYTtz8QxkPMemYaZIJfMbKeSdGsPopD8x80EreqzqMZZxf9CALywAinx09V+?=
 =?us-ascii?Q?FGF1wgIDicYsLvYX/aktaLiNnOANpnwQLjke1ElnFR3KGmY/WhafoKbqsDyt?=
 =?us-ascii?Q?vsnLxPclCk8mEEWYby72fgRHBiDSgTmZCzIqR5WUFiZZerSpNZY36A9E4E/e?=
 =?us-ascii?Q?nu3nlr8ngbDVuGyTkprnd/6+VKv5U0AstrmkQ8OzXylQCLkWO+gKva+MrtXl?=
 =?us-ascii?Q?VR99hTiCor3cvtaEYvNX710cseDCw3wgO72uu41uwYl6Qn9AwLGjpsTgVGEB?=
 =?us-ascii?Q?M4Ba0LusJ6qthJBpqB4yBd6f1ItrS/PH61fy2Sqo9bmp9yYhOMDliiP1B68L?=
 =?us-ascii?Q?88NIbcOnGpvzBTehMvmuZk5B5iepY8ylDhP6fg8g/Rjem9SWdtHoLrRektz7?=
 =?us-ascii?Q?Obl7dze1wJULOczdehBc5b6eUIkFiPuLFwcIpTeEh2RdAFXFQ/8uQyanr17K?=
 =?us-ascii?Q?J9iRf7S9d9iRh26ei6qho671mR/TQw9to1H0wMhXLXCmDF98LqOKant3R3+b?=
 =?us-ascii?Q?/7PNESF++90JBs24tobmUgFjuyqdFZrOGslfHRN8QplwIU+9zC7jh05JqqDW?=
 =?us-ascii?Q?bybViksbd6ZQoupZ/GaKYpcSv3AMSka9YlqcOLf9i6NCJfbAZH5PhaEHKBgu?=
 =?us-ascii?Q?C8BNaNLqX/JbG+a2jgv8wNo5eK/Cppzdm+bfOPRsiBkGgQSvfj156byB0jc5?=
 =?us-ascii?Q?HVVUCiDw0OvXRcWK2BKCBB35rvaCxj8Ji3EIlGBami+L6K0mfdVfZIUJRi2g?=
 =?us-ascii?Q?h7RiRnomrOF/REqDJwqZ+IshlECMtLUEKYO/TL5k8LxrhPvfUu8ttBXdmEa9?=
 =?us-ascii?Q?svR/2nByleXLXTmf43W/aX9ymnhYSCheuOvkLYq8lkhsRnR368msj4D88VXR?=
 =?us-ascii?Q?LDX3zz4gJzOtetdm9TUxRtG3xmBYhfERzkFOkRWvu135PB+OdgCho8SnnIqI?=
 =?us-ascii?Q?gnOlaLOWoTOiR0Oipp1La4Jp3mJElm/yZXD4qIZ+7YKHsIqEbQYSfEyW2Bf7?=
 =?us-ascii?Q?k8oGgRq7yiSkq400e6tRFP3oqRDh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sjPgxdg+GMYzRrOtHU6WnNbIGQJdt9jmjmU4NBmhwFtTIUjWnwRelwFuflmB?=
 =?us-ascii?Q?8+p0ubrSUjqWWKpFXxLW5fSxgyD0RhSLHK8F5iRNfMk5DbYvPETVkm0/OAO9?=
 =?us-ascii?Q?QxvhyeQKs7y+ILhrTUYWkMCcm0wQ1NWkWqOAuR0b/ZUZ7Oxf1vQ/2iSoLc9m?=
 =?us-ascii?Q?yxTq0fzuiZujPkeMoc/9NF9Ax+Grjh2GN8iVH8z2xfXkpP6AmGtePz6PLtU8?=
 =?us-ascii?Q?0vuO3o4v2htEDWmtjm6iz/JBPLs0PRmvAapybUSqUoTfhSoGzMHnlOq0OSEt?=
 =?us-ascii?Q?l30Ea93VLR2+qXjRM/XHRRcgovud/L3JVwXTTVE4l9dn3MS1Xb93DddP22A8?=
 =?us-ascii?Q?oCLPqz+xoj0MPlnx71bcqM/HloyZNNy5rIAcIT5sdz85vXLQMqBT7v+dyLda?=
 =?us-ascii?Q?ZgjU30dN/A1Mq+eW4ABd0NPtwM6s8SJuLFr8ctKQIU7aNHk8pHowBgY8f9C3?=
 =?us-ascii?Q?CSdES4Qe7mgc/ZNIZgD1c+WpeCSIprHC9jxxH7uC3N+phjYAHLQybP2VUuHM?=
 =?us-ascii?Q?R70nG2tirUDdBGF44iRP6JFLD0zSP5tyDEcLv61w4ehoqRLdBL7Zo7Nz4/kF?=
 =?us-ascii?Q?oo4dgrnZ/op9SSsSOS5L2yyZTUI+ZgBuYsnU0nZrF+k22UmaMOAOY8VyRKe3?=
 =?us-ascii?Q?1wfI1k0QkTYE3N62iNDzW4AA3cIbv2QnUkritafh6PDgGiVjXtKqlQKJ5JBF?=
 =?us-ascii?Q?w9JCWald+vJQEXkfQsDcmPdCplYs/VnRHZ5ri7XT1U3reeFszzWxDUU+mpXC?=
 =?us-ascii?Q?MrR5/btZYK6LRMjwQpv/txgIWgSOCDl3vm+JhdD+yCb4NN1YNfGcsAMwuScT?=
 =?us-ascii?Q?knOVcn8iYga2DPvLVp6+ui2RXV/8FiXGj/d92KVilaODzTB2gdecZ75WfHUb?=
 =?us-ascii?Q?xbq0ZjUIB6kDLs0TY7+QJr+/hu7BodvEdEz0aZ740ef3T1JBUxW8So2dwGOG?=
 =?us-ascii?Q?jUypaol2ac5Hp+j87nzRbFgkvg8u7DqCLkjA/MJJBOMOUQKTzbv7Pr9ygfPk?=
 =?us-ascii?Q?oVEWAizlYm7dLXmosHSc55lrtyOelU8AQmjt0JrJ/eKS6+n5RP5xYbtsrUtz?=
 =?us-ascii?Q?QbWB2d/ovxZ16gegogTjR3Zdhxxh6y7VgpMGkjEb8OMm7gClqZTaCxgNk2FE?=
 =?us-ascii?Q?pSDDrTOKugn0DlxxfJ9wFMZOUwC5JVGrxHuk/QYoLTjCcwmYvM3HOxE6AO/G?=
 =?us-ascii?Q?a3hZwHI9sShihzBVITmRHJQ1OpRvSeUSsW5/ybqktqvXm6lO49g2+nsoBjf1?=
 =?us-ascii?Q?iUxifH17oMDuXzXA+RNjqGDWxG/mlS+69/m+ZHL1hdt3JV5fCWooLMh4wIuG?=
 =?us-ascii?Q?lqY+lrD9SrR1pl8WP12uIQT1mjKHik6a4/1BQnsWWM9bayLaW47dhC6JPKlQ?=
 =?us-ascii?Q?TeaTAeKj1SVgnFNWq+Fr/HV2LK64DlYVELKnbQMvxphQujdnDXeSIl+boLDx?=
 =?us-ascii?Q?jJ2A8FdjVQvDuOfHlRHqvvSgkupiPfCIm8yL2Yt/xzJKA6giyoxnBehAQgRv?=
 =?us-ascii?Q?kodi6OI4KY0mgXVOr/QYshrga587mspjTpr2/9fXbxtOGkOy6L5RrN1nbhDo?=
 =?us-ascii?Q?fKUvBCkVI3zLBXQfeouq0RuOyriukEE2796J9DZQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9ef13d-afae-4b95-7417-08dd681bc526
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 01:57:43.8864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xYrWfUhszrhZ1ROzd5QXNlKInyLWOCDF5AZK9E7CElqrfumnJTPd+13JGQW39lJAfdTwkAEeA9X12esRZp+YJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5158
X-OriginatorOrg: intel.com

On Thu, Mar 20, 2025 at 10:59:19AM -0700, Sean Christopherson wrote:
>On Thu, Mar 20, 2025, Sean Christopherson wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index f76d655dc9a8..e7eb2198db26 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -227,6 +227,10 @@ EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
>>  bool __read_mostly enable_apicv = true;
>>  EXPORT_SYMBOL_GPL(enable_apicv);
>>  
>> +bool __read_mostly enable_device_posted_irqs = true;
>> +module_param(enable_device_posted_irqs, bool, 0444);
>> +EXPORT_SYMBOL_GPL(enable_device_posted_irqs);

can this variable be declared as static?

>> +
>>  const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
>>  	KVM_GENERIC_VM_STATS(),
>>  	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
>> @@ -9772,6 +9776,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>>  	if (r != 0)
>>  		goto out_mmu_exit;
>>  
>> +	enable_device_posted_irqs &= enable_apicv &&
>> +				     irq_remapping_cap(IRQ_POSTING_CAP);
>
>Drat, this is flawed.  Putting the module param in kvm.ko means that loading
>kvm.ko with enable_device_posted_irqs=true, but a vendor module with APICv/AVIC
>disabled, leaves enable_device_posted_irqs disabled for the lifetime of kvm.ko.
>I.e. reloading the vendor module with APICv/AVIC enabled can't enable device
>posted IRQs.
>
>Option #1 is to do what we do for enable_mmio_caching, and snapshot userspace's
>desire.
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index e7eb2198db26..c84ad9109108 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -228,6 +228,7 @@ bool __read_mostly enable_apicv = true;
> EXPORT_SYMBOL_GPL(enable_apicv);
> 
> bool __read_mostly enable_device_posted_irqs = true;
>+bool __ro_after_init allow_device_posted_irqs;
> module_param(enable_device_posted_irqs, bool, 0444);
> EXPORT_SYMBOL_GPL(enable_device_posted_irqs);
> 
>@@ -9776,8 +9777,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>        if (r != 0)
>                goto out_mmu_exit;
> 
>-       enable_device_posted_irqs &= enable_apicv &&
>-                                    irq_remapping_cap(IRQ_POSTING_CAP);
>+       enable_device_posted_irqs = allow_device_posted_irqs && enable_apicv &&
>+                                   irq_remapping_cap(IRQ_POSTING_CAP);

Can we simply drop this ...

> 
>        kvm_ops_update(ops);
> 
>@@ -14033,6 +14034,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
> 
> static int __init kvm_x86_init(void)
> {
>+       allow_device_posted_irqs = enable_device_posted_irqs;
>+
>        kvm_init_xstate_sizes();
> 
>        kvm_mmu_x86_module_init();
>
>
>Option #2 is to shove the module param into vendor code, but leave the variable
>in kvm.ko, like we do for enable_apicv.
>
>I'm leaning toward option #2, as it's more flexible, arguably more intuitive, and
>doesn't prevent putting the logic in kvm_x86_vendor_init().
>

and do

bool kvm_arch_has_irq_bypass(void)
{
	return enable_device_posted_irqs && enable_apicv &&
	       irq_remapping_cap(IRQ_POSTING_CAP);
}

