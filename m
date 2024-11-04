Return-Path: <kvm+bounces-30481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B392A9BB029
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71FDF282680
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9C11AF0AC;
	Mon,  4 Nov 2024 09:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b+9jQDWf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D7B1ABEDC;
	Mon,  4 Nov 2024 09:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713701; cv=fail; b=Ci9HKI0MzNnF3aDx9TzR6EY8KnJoAp5WWKQ+tid+d3LA0RpsY2YD1HO5NPhSEb6wbNoMz9qKdseP3ut1993zB2gwweqTX70FQu2kZ0L8RP8gLAUHjWtjvsY3Lg6legZWOBtejVEeKiQAS3V6+gNGsmsz2dSXN8ndbmuHcz0i9Oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713701; c=relaxed/simple;
	bh=zeQHOueAzHFR1jw7cw+dnR3Pm6FBsWGJeW5oxJdS33A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZJVFUUZjfYweqjOhDVLn0dah9rhGl3N1CVVB+hzkm/UwvD7xI0XPeGObdCCCGohgrqJXbtO7MzUHqPO/XIurDSlVN25VT/v2TLbn1F3ua0SCqZ1mLb7oPXRLqQV6jkp+UCw821ramvAXxelEN4RF7JxcLw315/IHu2xcVv4vAH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b+9jQDWf; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730713699; x=1762249699;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zeQHOueAzHFR1jw7cw+dnR3Pm6FBsWGJeW5oxJdS33A=;
  b=b+9jQDWfmXun5VDwprkeGizwJzEMDPDSOUI9A2Mheh3nWEdah4cB2lGL
   8wPcCMnw1vWrd61i85Ev8AOz28NVhE6Bx8v7MYY9mnc+GnxVVbMKmwJlu
   HLNNUrbiSV6nj8rAXofEjoiPuKXw6SsDTNZHy5uvjv3Z+KOPRbAZNd4Yy
   mBGF0oy9OL3Uufd4kA+Fszn53dQqgrkVIlMK3UXW2umM6eFhbbFZSP7OL
   b9DJATdH/sa+c8u5TIRx6mU9N23n4n4llRm2wvWwDY8Eaxs0GAJ5iKxVd
   VVLZ/eXhtrCD/MnGe4QLxYVI9mFObucLIF09wZMJCwlb0OJQnr2AHBSEg
   Q==;
X-CSE-ConnectionGUID: cKG+a1aPRQOjhbjqPrCs1Q==
X-CSE-MsgGUID: m+msh57SQMSXcMH8eVH7uA==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41034355"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41034355"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 01:48:19 -0800
X-CSE-ConnectionGUID: A2vdiTmaT/evORVueUw6lA==
X-CSE-MsgGUID: 3FDR4y1iRuiNtHrmg83mGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="121067382"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 01:48:19 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 01:48:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 01:48:18 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 01:48:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DmXWISCA2YnZNTziErjiqiHjXodufDFff+94P5EqAEyTCScnHY4ZiF9UIdVxWCYCUiDRsJ+cWNVMYHOhs56q7MyqaXacvkmeWSChPmzNerv7Rh5eA9AL/5hBpXqC2nN4CXs6ZxiVNuvjR+SB0yr0udJ+4Fqq3yxIIrOHPe9HadGTm/5HtjNHKByn44w0SnJjSXjlcz55EaJTGKqxwoB2DkUH768PQkmrYTFcUHbSRUlixA5RhKJzgYPr6hsHqB1YTa9N4iDnnKV2tjowHipmBmnorHQPqKncrPCQifabI3JJaoSEDf9Gjj4Nm3VqG/AyBdbJPZ6qY93/v/X01BTL+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LIOPzdQeCBRULae5bdtIULZ76bTEmfomb8v1RhLHuXQ=;
 b=Xyr/yVUXemvwSUgegt968b7JL529L+C0A0JXJ25Exgxv/9+nnDkRx8cR1ZqZpkNX5YIrSkBUv0UlKrnxwtFNdFsjr5lwLUO/Ljwlpml4u6D0s6VqWF2g+0+dOAEHOEKhmSCKDyNQ06iUjbmUTs+kPWzYM7Xxsvk06hMA0u+z22903UQ8heNlzdrefTHLtAIqiULnrQSWCn9DA4VVrgW1liGm1rQgHcBTmgvgFFhvyiTWqebidtlYDzYQ3puv7njL6AuSmlCWOGZCxdxEPDHdOFxDs/iwln1pI8XTuin2hgAU3aNuF82p4Cvav/S/SivynvZmF3SiGS0TZL+Xje/55g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.26; Mon, 4 Nov 2024 09:48:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 09:48:15 +0000
Date: Mon, 4 Nov 2024 17:45:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, <kai.huang@intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@gmail.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] KVM: TDX: Handle vCPU dissociation
Message-ID: <ZyiXyqVyi8HUf/8E@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-22-rick.p.edgecombe@intel.com>
 <7fab7177-078e-4921-a07e-87c81303a71d@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7fab7177-078e-4921-a07e-87c81303a71d@redhat.com>
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ac1b03-8ac2-4bd9-7cf9-08dcfcb5cdf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jCuzGyaw0lW1SbrtcHW0fKp74RD5KlWKE4YY1T0QhTd7A8qXy0sFwa4eN9o9?=
 =?us-ascii?Q?fRj0x0h+hz7m0vNCIc/ziu2mfRJf0pZoBysmgaIpGaTbnVGQcPmhBuzeqd61?=
 =?us-ascii?Q?0VJtvkrBQu9wWtNl81PJUTAP0xWlQ63wk3GUrmompUuB4MN1/dDZbH89V6EJ?=
 =?us-ascii?Q?8fKe9ViGsGhhbD40tZpLFp8v14w8lrWYbrVzYIGxPOgsOaxc5b8C8i7T2XKR?=
 =?us-ascii?Q?vKBixyZgJRgZuFXHUHhS2rNyNW2qrYr9287+Kr4zcZoLtni261KPSEssos4Y?=
 =?us-ascii?Q?r1wdRzba3heH8xD2KOJLo35HIct7RbRTzaOYNtBiU0uMJAyDGX6Os7EZ9CBm?=
 =?us-ascii?Q?aW0jtMJBG1Q30SdNJzLlCmwgL3qEhoX0vZy8wvxLMU6CJmeE13W9j7o8Lzst?=
 =?us-ascii?Q?DezA6gJK5Jc1TBIpTAEkENRiDq0bKqJ0YOgWxQML9qloWGpYTChXYIeZ6qaB?=
 =?us-ascii?Q?jVCRCnSNJX+DJFHbfwSJU4UEo+JBOoIiJD83BUWaf9qlnIExjRqIW/gEVlGq?=
 =?us-ascii?Q?93b8gtaWGZUx6z5bA0TURCECN0fXdkOTux3H1gBdEytg29l1uCDTWeZTOKKj?=
 =?us-ascii?Q?Cz+zGfLK09o3x+Bc+uc82l34r8LQ5OE4yQUkBkQCQEy/HaVZS6gOXnlwwx+a?=
 =?us-ascii?Q?+stRBz+g0IupWP44VtsPXmfH4DulCWOA6Ap367CnrutYUBhUQuyQSi27m9C4?=
 =?us-ascii?Q?B783Qku9f6WeDm24qO+L++5DAlEQxiDbxH0/ql3E91KK0HIA9JKIOTzgL4s3?=
 =?us-ascii?Q?Mg77iU0vqIg8YaMDEKde+md4eRY9FOLg8TY62YvRZJY0WHR410cYSktp4bGK?=
 =?us-ascii?Q?3w8NRsy5n3Cmf+TUnKjEfe+NsV/mwj0wgxW4GcAcWK6oLGe/awl400If2B4U?=
 =?us-ascii?Q?YXW5vPwhcn2TZEyU+KyuqgDxzmTwRHdhI855bGmsLfr0HI8m97LQC1+cH9u8?=
 =?us-ascii?Q?VDtiVbIkJnN5BDaK/Ek4aTOv5qXkiwijGfnpcCkXplrLZIBIy/vkYmXBULKW?=
 =?us-ascii?Q?4VCbewJrsvclOtlXvcZVkJ4BCkfecBnx4HLLRPzke6TPJ/I3ZQxQDRt8uy2K?=
 =?us-ascii?Q?X/BWmhbViCx0Unip5NJrTaBJPnFSv1Ie+IWQ89Hku2S4OjgksUqgde655P2V?=
 =?us-ascii?Q?mOsnydn6av61EStRxtm8vwwH9KZ3R2xj5UxODthXJ0k69Lavvj/2ocMWXE2B?=
 =?us-ascii?Q?IwE27/dicYRz9OM0kXVsAI28o2hWR4SQ0Nd3eSqGczGfJjJWCNInz8KxmAo2?=
 =?us-ascii?Q?WBwzXBQlVUcLQGMNrGFmjCHnTUFruKkYISaklu3pZD24aiNTmrUdaiTJSv+k?=
 =?us-ascii?Q?ZOT5rKWvhOpzOBEF1SYujgEf?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CUImOOpPUqh+KOsNoOD0J7KoaUr8ugmI7TQK9qkfjqB4WJfk7I6ov21+WMT+?=
 =?us-ascii?Q?p0fTUQ3GDwmiXkNQidWUp2ipGQzHcQFd4DzpaugHTYgYiyL+Jyqx1ZNYa6Pm?=
 =?us-ascii?Q?OLPDCiwbULeZN1bkZVtaBIahCQL0PFttysb7QF2KkSkqnh64BCM8+ClIfu9Z?=
 =?us-ascii?Q?J9WYVbtSh9qAuOoEhNkYNpAqKqbFB4Mgh3pTScjJ4LMBat5el+DuOHbBHgYm?=
 =?us-ascii?Q?jl1vBJ3gP8XSee3YJBsdFoy04RztDV3lSvRfrrIoP8CWdc+Kf/OeLWnGs/MS?=
 =?us-ascii?Q?pk3Eyk8N7nPJmJk+SIRMPi/NUwJy4dFQp4cuylqstxgbOEnGSCPhNAL/1QgJ?=
 =?us-ascii?Q?9B6rVWDkB8yLCwJ2w1CpJjfe8dIxn1lAEzAwqTct+Q2K4hu3nD0hdq0523n1?=
 =?us-ascii?Q?/TNy3fo5y2CyCAbVBbA2EyfHwhh+Ij9TdRshqTv0grSDNqQHCZ2aQizFy5si?=
 =?us-ascii?Q?9pVYmUnZLqsIGm7jpOjLPAxwXtqAINsgNyJTATU/rfN3zm7L2nWjgzwq9uap?=
 =?us-ascii?Q?2Kpfo/SK1TPmP+LyqyzsLExUUEkUIkrOqaZzhFogBMNaC7bjvISPv4oD4jOm?=
 =?us-ascii?Q?UGRDd3c0FiaY+tujN8Tf77WtIIhtc6XIloX3+VjeMtI8EoAimczkVKGrMThh?=
 =?us-ascii?Q?2+8etqViJy1IkVQvl3PbozOYG5wisSZUJ4LSal0JsXMOovAwV2/c4cYliL5Y?=
 =?us-ascii?Q?h/hTwj6eFi/ZJhtvtiipjYqm1w95C9ydqgFLue4a5/3vRS81lickQXekG8xR?=
 =?us-ascii?Q?rq+LgJmB1XG5ew5vz97tiqgWW1joG26BZzCJ+2aHKllkYasLs8BGixb5mZ7p?=
 =?us-ascii?Q?Pdjn0imu3kwOuF+OKGBNynaql9M9o0cPxmKklJRkAbMFAP+rTHZWNFhUfYGL?=
 =?us-ascii?Q?2zexFAbsmAFnau15ezITeV6CFRefy2+j0wEMHpvl5+qMb5WNqFWD0fPNIIJD?=
 =?us-ascii?Q?s9kCOXqupWFq+lD7bX4Jt8tr3kPFGCk74luf/Rm19FBoT5xHv6bzAjLFi6Jy?=
 =?us-ascii?Q?rvHUBoCgvQ3ZKezPCGaYxf2JclFtRYfIKGK+0bzUhOHfs/sYSfU5mut56+c8?=
 =?us-ascii?Q?sbiQvLDec85NM/K/IppzFnVtOjX5WPl823Bo26BEaXyH9SJQlHB1Ydkl0IaD?=
 =?us-ascii?Q?EfIsmMuGlQBW2E4yQAmB+5Pec9Or0MZZOAPSNsHAyAOrbSAb6V9o6RdOWIki?=
 =?us-ascii?Q?yftWwN23npUPzNaYBse7sdYtYCIQpvd3FkDCjL0sQD6wvauavGyvfSeUO20R?=
 =?us-ascii?Q?ZGCP5CIsFuX/XFdktDzaeneCsTlDDgaFYnRLYKXYc+HBxRKq2ROgGJKOCtG9?=
 =?us-ascii?Q?fK3A9TyZANwe2n+E+15EwC3yAUApfFeKCx0W/tGIuPPxgr8djIlUnA7gzJzW?=
 =?us-ascii?Q?tN6t1oag/jJW3ohKLOlZPEru2xFnX6ZQeO2dR6/SCnnydLoWEW0AyZe3Wc0M?=
 =?us-ascii?Q?40InKlGEuIw18CW32auCfpL3dKA+maJh8wH+B3wsQzmwKhV7eIzIeBOYs9YH?=
 =?us-ascii?Q?/NuLXrfwBkeOrywb4Z4nN8eWO2x/0nMrTcpxKBLIhx6tdJkFW4ahy6wCWFHZ?=
 =?us-ascii?Q?I5elt8ZXfJGg4/U2EEXpUwjqucUHGvTfdXYyHQ8h?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ac1b03-8ac2-4bd9-7cf9-08dcfcb5cdf3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 09:48:15.5743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQPgtyqbYGoEjAW5/9NWa1D2WOgTS2AwG028svayD4Bx3wodkqWmgmLBixpcUEyfhHQnSzmc3N95utoyanp13w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com

On Tue, Sep 10, 2024 at 12:45:07PM +0200, Paolo Bonzini wrote:
> On 9/4/24 05:07, Rick Edgecombe wrote:
> > +/*
> > + * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
> > + * is brought down to invoke TDH_VP_FLUSH on the appropriate TD vCPUS.
> 
> ... or when a vCPU is migrated.
> 
> > + * Protected by interrupt mask.  This list is manipulated in process context
> > + * of vCPU and IPI callback.  See tdx_flush_vp_on_cpu().
> > + */
> > +static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
> 
> It may be a bit more modern, or cleaner, to use a local_lock here instead of
> just relying on local_irq_disable/enable.
Hi Paolo,
After converting local_irq_disable/enable to local_lock (as the fixup patch at
the bottom), lockdep reported "BUG: Invalid wait context" to the kvm_shutdown
path.

This is because local_lock_irqsave() internally holds a spinlock, which is not
raw_spin_lock, and therefore is regarded by lockdep as sleepable in an atomic
context introduced by on_each_cpu() in kvm_shutdown().

kvm_shutdown
  |->on_each_cpu(__kvm_disable_virtualization, NULL, 1);

__kvm_disable_virtualization
  kvm_arch_hardware_disable
    tdx_hardware_disable
      local_lock_irqsave


Given that
(1) tdx_hardware_disable() is called per-cpu and will only manipulate the
    per-cpu list of its running cpu;
(2) tdx_vcpu_load() also only updates the per-cpu list of its running cpu,

do you think we can keep on just using local_irq_disable/enable?
We can add an bug on in tdx_vcpu_load() to ensure (2).
       KVM_BUG_ON(cpu != raw_smp_processor_id(), vcpu->kvm);

Or do you still prefer a per-vcpu raw_spin_lock + local_irq_disable/enable?

Thanks
Yan

+struct associated_tdvcpus {
+       struct list_head list;
+       local_lock_t lock;
+};
+
 /*
  * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
  * is brought down to invoke TDH_VP_FLUSH on the appropriate TD vCPUS.
- * Protected by interrupt mask.  This list is manipulated in process context
+ * Protected by local lock.  This list is manipulated in process context
  * of vCPU and IPI callback.  See tdx_flush_vp_on_cpu().
  */
-static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
+static DEFINE_PER_CPU(struct associated_tdvcpus, associated_tdvcpus);

 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
@@ -338,19 +344,18 @@ static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)

 void tdx_hardware_disable(void)
 {
-       int cpu = raw_smp_processor_id();
-       struct list_head *tdvcpus = &per_cpu(associated_tdvcpus, cpu);
+       struct list_head *tdvcpus = this_cpu_ptr(&associated_tdvcpus.list);
        struct tdx_flush_vp_arg arg;
        struct vcpu_tdx *tdx, *tmp;
        unsigned long flags;

-       local_irq_save(flags);
+       local_lock_irqsave(&associated_tdvcpus.lock, flags);
        /* Safe variant needed as tdx_disassociate_vp() deletes the entry. */
        list_for_each_entry_safe(tdx, tmp, tdvcpus, cpu_list) {
                arg.vcpu = &tdx->vcpu;
                tdx_flush_vp(&arg);
        }
-       local_irq_restore(flags);
+       local_unlock_irqrestore(&associated_tdvcpus.lock, flags);
 }

 static void smp_func_do_phymem_cache_wb(void *unused)
@@ -609,15 +614,16 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)

        tdx_flush_vp_on_cpu(vcpu);

-       local_irq_disable();
+       KVM_BUG_ON(cpu != raw_smp_processor_id(), vcpu->kvm);
+       local_lock_irq(&associated_tdvcpus.lock);
        /*
         * Pairs with the smp_wmb() in tdx_disassociate_vp() to ensure
         * vcpu->cpu is read before tdx->cpu_list.
         */
        smp_rmb();

-       list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu));
-       local_irq_enable();
+       list_add(&tdx->cpu_list, this_cpu_ptr(&associated_tdvcpus.list));
+       local_unlock_irq(&associated_tdvcpus.lock);
 }

 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
@@ -2091,8 +2097,10 @@ static int __init __tdx_bringup(void)
        }

        /* tdx_hardware_disable() uses associated_tdvcpus. */
-       for_each_possible_cpu(i)
-               INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, i));
+       for_each_possible_cpu(i) {
+               INIT_LIST_HEAD(&per_cpu(associated_tdvcpus.list, i));
+               local_lock_init(&per_cpu(associated_tdvcpus.lock, i));
+       }

        /*
         * Enabling TDX requires enabling hardware virtualization first,


