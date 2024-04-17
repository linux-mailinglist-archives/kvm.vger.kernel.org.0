Return-Path: <kvm+bounces-14926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EA5E8A7B35
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 06:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 075E8282F2E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 04:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4231B41C84;
	Wed, 17 Apr 2024 04:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c1Rx3Hio"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAA840847;
	Wed, 17 Apr 2024 04:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713326611; cv=fail; b=N0cXCC3GJio7MVG4CoDM30RSDPcCKkfTiqiwD7fBN/dsKW1bSTs+12gE5/4X6vqzeAjiailVhdAlvzPYWTOjXObRGqeTcDdNwY2enkpQMeqchbp4GjVbdGl7vmIEEproT+l9IrYxyVbStUW8/3BIxMHNeHnwKyGxcEp8WYw1bGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713326611; c=relaxed/simple;
	bh=ZzAYDpPFwydenJ//2kkHt70XJpAcTjT/y/dNVluKvjU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lgvYdlfYTwWNt3PNar9akoHheFxm83e3dfoydQlJn/e8XUcGOOCdx1BUI41DwRj+F9xyq/JkyKm2EkqIx2S+VUp432/xGdCHBzVclPibt7/ubDU7IJ6irHE2APWhdDnqhPY9BcUOgEvaN7JF5LIWiRnqOI8LUD+DVxVkteCJA9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c1Rx3Hio; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713326610; x=1744862610;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZzAYDpPFwydenJ//2kkHt70XJpAcTjT/y/dNVluKvjU=;
  b=c1Rx3Hiov+bO4k3WhLQGUKgO4EZB6Eyn85fEBH9Fe7ktbvx7LJnfd7BQ
   VEKH5I4vPdP79E5AZqRc4TWXTT8JWpmkGjO8Tk/wy8d6zm3o/Bs6BVH+T
   zAzA7hWjbht6nnmiS8M6nsHREsxwx7CuuC4XVktF5wMMUv6dvxYq1bx7H
   FhMscjX/tLAGX/eNuLTMSFWz4P43TaU2bvPvjMw0R8H+SxUPh/hDYxbjG
   kqFUV7Ij5aqtgWPTL/x57YtJFLPRq3Cq623bxxayyAEbR2DI4KkKZXJBm
   Tigo7SE1kbOoAn+m5rBi56JVE1h1T/DrbfcfyqT/uTMAZa7PxV+HtGesL
   A==;
X-CSE-ConnectionGUID: H8qwLw/pQ2CoeJMONgTJlA==
X-CSE-MsgGUID: YK3/C4cnQTWAHQghXqqXGw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="20221424"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="20221424"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 21:03:29 -0700
X-CSE-ConnectionGUID: BPheQ0nmSpWbDOgVJO54Vg==
X-CSE-MsgGUID: I5TpHfjoRB2AHtZT6X99Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="26926731"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 21:03:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 21:03:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 21:03:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 21:03:28 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 21:03:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBjMnjWfBUsQsPEhbVRXtIRT3n17Rh9mKtYXUtqMWOyn6k2AervRnUbNQZw4i+IsEX0Z8ocNujrv6TPbi1Zfjxw7tkn/RNFZ7TEVQbxIhIu/6cmOLK0OMWX2awgv8ZyD24c8lNIjR0XwJnIRocP4tz7Byzf8FVLpBWY5fbarqSISpsfX+2DIFcjX9PiLF/qm8KEv6aEFxqBUYWeoVfIwmL9VaQgFB2I1lCbJPqzL+bY1nnczjfsXZQ1l9Jlwzm4dOUNR9uMj9b+FzQkqufRTWy9ISSx3sdVoWPUwGy7ULCLfEa3RtBshhVR1gh+ObrA/ykRbPQng7VYqm4XC9Vbcgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0DHLEdaX0GSWCRLh3iXeaeKe/I5UQZ2GgNIh0w22OM=;
 b=OGsZ+SMpMOOsxauomn8r3JlXZo8Sw1epJ91PQpr0xcyZ740+YgmxURDrqptI0t47fPa/lLlqq9qL18QWihVZ5FoW3bEFIf+3xI1T3jA40l5HNEYFrKQzO+rqtoircVQw6Oi8leZ/8XQUa24D8FfJPr9OMjokbrFvMD9T8iO12bpV54SrCM3i/1b48xMiSJGmWLK1P40HShRjsB+hyrq9UxA1ES6oee/QGT3dYLYheuygjOl57Nt8mCm7wUyzHEQESBnJjlTFmwjrxcCydi/sqnlSNIP5lPNSSbroaOAjR9WeUvklSC4vjdoh4nWbD/fuTaYDh7xVk8IfyLa3394lZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7396.namprd11.prod.outlook.com (2603:10b6:930:87::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.49; Wed, 17 Apr
 2024 04:03:25 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 04:03:25 +0000
Date: Wed, 17 Apr 2024 12:03:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang
	<kai.huang@intel.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>
Subject: Re: [PATCH v19 086/130] KVM: TDX: restore debug store when TD exit
Message-ID: <Zh9KA/BjAEZamEAo@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b7a96654fa46593417afa6153959b2989a507842.1708933498.git.isaku.yamahata@intel.com>
 <9785680f-1c30-456f-af49-b6d26dd38fdf@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9785680f-1c30-456f-af49-b6d26dd38fdf@intel.com>
X-ClientProxiedBy: SG2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:54::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7396:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c26d405-5862-4599-7ee2-08dc5e9354af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vtviAtYghySj5vmpo5Q1Xyzp879urQ4Pdii2SjEZeefS3NDo9fW0YaE1CO9kiGuqikFwrjFSGLk6Naam/3c1Z3RpVllni1xC5++FoKPrREdjDcfHUwL+E3nu7+FVHduvXs9DFr4rl6UiRIJWUk9VvQWGec0zavDS63FgjGk9UtGg1HoZ1LLHqenHXtqRgtWxtB5On8wQXRLqcELR2E1kAn+IdFxBLbwm2mw/wxS5/tE4W9TPvbGNlw06kKI5lmwoOXVEZV5zw+fw7FS+AmDx+S3I8s2g4v+eFZrAOyWspp5YR1wPBEIYYUYWvIGhD8v4K+T9Eea7K+/SzRtb9nvMuHjYYKULVpaHql+XDIqu3OxACK5UngVO5V2YIUKxSfsWyDLEgZEjZgRVpgPxE7aohAt14/jKdvchQ6Tuu4Vo9J26JBwE0CoPlbcSp8Y6qgM9A9rW512klFcnIKPya35tb2vb6GIJk9t4TfZ59KHUNYnX0kvNGhhkz5TY3e0PwGlXr6PqI2ljfdTgT4WW69eVqVoAD6R+/hbBzWbyze14ZDvOyYfAXqxBSrmfvua7yMoxlF3qEUlhLMrh5/qfzn9jhYIa6Ol+lhXvn0E4/RiW7fJrs3J85i5pE1osgEKjf601m9ZD93v9m9rGvu0bVchLYK2LNmeF/bXzpTjWsMWS4Mw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oRVorRd7LGgnBgz4tImzfV7y4kjBM2e8200Ag0efxOodEaKRN8+RthooeSJI?=
 =?us-ascii?Q?jtaUx783+KvZg2xv+DwJtrt//I/yvZNeNMIRVfqiATa+Dhj92X9raXrGRvXg?=
 =?us-ascii?Q?o/2N60d5rXmhtTkQz31lmHXuf5tJeCNhTx1H/V2zHC9mYncRVxVt9HLMOyTs?=
 =?us-ascii?Q?aoHh7MVoKCFsQpkRSJ3i8HJQPxLMStbk1lTZLWGgCLA8SnIYQxZOXkMXwO0q?=
 =?us-ascii?Q?B7CwXzopadWP8V052ek4EwMaOsD2w14xf381ijFi5ZquWcldXHyS/OIIdwEH?=
 =?us-ascii?Q?D1+lzL9baem+E+4lYqYGh/8Iw8+MBE1zrM0MgiJDVbF9VoMtggT5YPdG9ePs?=
 =?us-ascii?Q?VhvK/iLLxvWskpMozurHRv4/2Zg/Udw9XUSfL/sdJowdB8fP6MYO6wY9LxzB?=
 =?us-ascii?Q?vdAEqzJRd4wwpeq8OGXwL6F5RuphxBHurnZg4obCqXX4QnRMBosPMYXwnGsi?=
 =?us-ascii?Q?jQAoV66Xhd4JUWmM60DHBcnEKOMfEuOU4SYeAgr7iOMpIh8YrbRr7cgHcf6y?=
 =?us-ascii?Q?cDAhABQ350tpJMn9FR+hZ9YH1a5FCXEFM5dzS3UDchI8oKBWgPYe1DXphEtD?=
 =?us-ascii?Q?ZarbvM6NNG+meblJJtYS25AAXlRii+/AGL59hDQb1zdYMdCVs35ASLEurweu?=
 =?us-ascii?Q?mdgCpFUMaSa+3npN8cjNKXcdCqg7HdIXWjc8hQVBMRYM5BbYn8UBUFc0bX3P?=
 =?us-ascii?Q?O26vxvhrkvkNLFwxbIFzJK5Q2S2iblKolkD+4m3ZuO9Scif9r/2GZmUyO1As?=
 =?us-ascii?Q?8+FFFxNt9ov0qPa73mCdZiYc/xboofZapvZb+GLxHz/NE9HM1kfNTWLpBpVQ?=
 =?us-ascii?Q?GB3cjX5T4JvZbVzo34L2fZGmVJE/Eq/NZVyMSFHUeAhx6+2iO4twj3i+4+5P?=
 =?us-ascii?Q?WPVmRN9q3SFjW7a9oy9H1Avpow83xjlY9y4KltebOtkS+pM2Yc6hiSxfz+s8?=
 =?us-ascii?Q?bTI1IQKDSnWLo7/UpfxwyKZ5AQ32Mj1PfgQfzXp3g5fxmxhv3Zl606Emql2I?=
 =?us-ascii?Q?MO1PUaEsgW7bTlp7qKkqAYBjYE/87yadA5Lq8OLbB3Ic0FenV3l5452lu0VA?=
 =?us-ascii?Q?surLYJBV64Vv3kVwTMcWKFq+0kSgGk9o9BWl9zBX9e+RXPU0T4Y8LEyh9MzB?=
 =?us-ascii?Q?ZK9/te3Gv4/DXFP/LcIT31T/uDjCAj4bPvM8OIzR0IdLSUHdY5AJ5c5u8jk3?=
 =?us-ascii?Q?gwDjK8ygsMOxEDEdWSggpbp7Pf8w35mPsMyJTjkqJMSDyTWLr19hhc6IznIS?=
 =?us-ascii?Q?zdZNeCbiNBxTHBcTlvaCvGtfrDrYfcmx0+45rVG1rUjwU7C7UGyjnX80erpF?=
 =?us-ascii?Q?FhBJRHldhH/u4uCiyY9GpeNar4iLwvf8PKeu3sPwrp5XdVoIvML31GpZyMno?=
 =?us-ascii?Q?uq/HD+SydTWFSqOObouxicBbtrXa9LTr0wTy+Ihcje+P4q4obz6B7cI1lEgp?=
 =?us-ascii?Q?xBJc4yGUCDSuMx0AyxQ7k/hexvj8y0Se5JTagh8BEjsPEErUopmoFI4rPkCg?=
 =?us-ascii?Q?U0YkrsAZbkHOzKN9WBmPrY5bagW6/Lo9g0SRYg9kkIRvmRyL8r5JlJOeabbs?=
 =?us-ascii?Q?oIj2hoJJFXtPZ+JvujXZ0gr6lhUIp+OqAJ2rU9j3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c26d405-5862-4599-7ee2-08dc5e9354af
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 04:03:25.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMkSS2OJ45TUOi+zg712RMyx7aLjpg9HZDzSI/PU70dKPS5YR9Gai0oJrAJ/kxed9CRSvoZbe3Rl6eFN33QI9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7396
X-OriginatorOrg: intel.com

On Tue, Apr 16, 2024 at 11:24:16AM -0700, Reinette Chatre wrote:
>Hi Isaku,
>
>On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>> 
>> Because debug store is clobbered, restore it on TD exit.
>> 
>
>I am trying to understand why this is needed and finding a few
>places that seem to indicate that this is not needed.
>
>For example, in the TX base spec, section 15.2 "On-TD Performance
>Monitoring", subsection "15.2.1 Overview":
> * IA32_DS_AREA MSR is context-switched across TD entry and exit transitions.
>
>To confirm I peeked at the TDX module code and found (if I understand this
>correctly) that IA32_DS_AREA is saved on TD entry (see [1]) and restored on 
>TD exit (see [2]).

Hi Reinette,

You are right. I asked TDX module to preserve IA32_DS_AREA across TD transitions
and they made this change. So, this patch can be dropped now.

