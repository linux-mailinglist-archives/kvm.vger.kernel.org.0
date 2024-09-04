Return-Path: <kvm+bounces-25830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A232496B030
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 06:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58A5F2846C9
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 04:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B05F824A0;
	Wed,  4 Sep 2024 04:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NthS2Ch/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390A2433A9;
	Wed,  4 Sep 2024 04:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725425757; cv=fail; b=CvXmbQwLxE/rTmHsthLbJVFrg+L7gxI8ha1tlR5l5Omjcwp1uEJeT6edbZibr/JtG1G38m7UO1akWdcwMfrKhkX3lcJkIy4oHKvklZs69rUqQzH6mzN/fP2Yi5dvaOAMBoD1DddA5h6eGTeSNgyxthliXipmUf6/SaBkGGKwFI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725425757; c=relaxed/simple;
	bh=OZrvAwXNBKtcCfaPkRnG+KhRwSu4jfnzsnZMy0EkKPA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ng/MToYVhB478jLBnj9f1rfmzc172NTEaN3UFzpsMhz+z4bv5ryuKLJfEf1jeUZ1w17l43ZBJC2p+2k7y4FxSj1KNgbhn1JDPHXhgDR5+1IikhkgPrRjgYs0ERD4sM62v0cf/J5P+ZKQyxMza26zeUW77ZEXmPxHZ2EyM0xx1qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NthS2Ch/; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725425755; x=1756961755;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OZrvAwXNBKtcCfaPkRnG+KhRwSu4jfnzsnZMy0EkKPA=;
  b=NthS2Ch/Mcphe5UzdE7fE6CQe0fPlPj3GRzVl7jQwBcVNukbUfxdF83a
   ODEVNGRsick1w9JVIZbcdyIZW48+wOG66BNexDYuCi0tweO6P5nYN3kVi
   moVQ6momUZ8nPHcamtfrwe5Ih3FuqbotG9uteitLamvfY0RvR3iTTtJxW
   5RIwoOHgco3khGwe1tsoIq4kRWepycok3NdRlX1/e7sX3c/cU7lWzsR14
   +WekuH6ICPPMZhYBp03BfKwtjFzf8Y7Ux+tAaYgVkf5oAGU4L3pCpU9dc
   LZU+SuMSWk35QW5SyIiSXmvFP/FDExISPqHxo6VkHNOmlX0fYlPC8S9iA
   w==;
X-CSE-ConnectionGUID: MjZEbJiFQ6mNPrbJ3rh4uw==
X-CSE-MsgGUID: AcbMQThJQ2CxnnCjBtD8DQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="35420481"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="35420481"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 21:55:54 -0700
X-CSE-ConnectionGUID: wQv9mz6PQb+FmCAZZ39h7A==
X-CSE-MsgGUID: Q/iZOg6qSTaK6wL50gqbEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="64956439"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 21:55:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 21:55:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 21:55:54 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 21:55:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mZcFxERuVcLlho1vTi1XbL5GNGkn12fLw+0hdDXBlqEsomrMErK2MqirkRqtwBBVVnkPjCTw7cf3YAb4sGIx/j2XZvgJ8eDXLlXJ5XZtSjz1CrXu1rL5qFf6DUEX9n9mOdypISU2IwMpxx4wzKeepVCKsOveYOqHIw8iOoDWeaxY2EMC8L8CR8H8FmuKUuEFuA787vIVHh38B8nGhCYZ2Okn7T5y6akJSh/ZIsFz3NRm2w/aoh7NbfLku9CXc1EiuLxiCHyqsozqqZnALRlrnK/e5csIZauboz9i78EdZllO4rx1T+WhRkSw0dfhMhzjbCvkhuwXFp9LjTSAoUacGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ou6d1HW7TO0/IBDm117YJ91RBeYQil3RuLcZWekQg00=;
 b=Pyj7bgbyrV5/0THui3HC7CrSHqP403xjNg2rgD42khCuqLK3VXaMoy2a098BGWa/iZRGAKicAxXfiD15BUHZOHZMnIw5bn5R5YyJBgMgzEdCkrMWl9Wj3K/ZiP2XrBLG1Y1+Xvdt9pEvQmSpPArm2lyZm0C+rfaVqbKcC6khLLCFcdA7ffxuiQ717TDsFYeSsIr0Nxgopcy5xQcekFXFe6mSVAPV80D0AspcGYs2FYeapO36uos4nohtz9aHflqUevwGg6MWjAYiZiTw/PovYphxzfwCG3nHedQhuKbHhXgSMZ1UAOapulGVgpTUkD291JWMnFhLHmwb/XeU0yWcUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6948.namprd11.prod.outlook.com (2603:10b6:806:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 04:55:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 04:55:50 +0000
Date: Wed, 4 Sep 2024 12:53:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <dmatlack@google.com>, <isaku.yamahata@gmail.com>,
	<nik.borisov@suse.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Message-ID: <Ztfn5gh5888PmEIe@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240904030751.117579-20-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::6)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ee6f041-00cc-48a8-bcb3-08dccc9dd8ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NXw3r+8291NOTRWq1o2Wd5oCIovpn7guTpX4LR77jwAF2K38f02U0KYY8E74?=
 =?us-ascii?Q?YBEx78V7xIxZnEw2KMivzTLg2toC3Hv9B8fMlgfuv6kROcF9T/NRPMGNiBtv?=
 =?us-ascii?Q?vlhRbj/z19PEbj0xT3Foe++heRq9KJVvww1hNdIZIZe6L7guBwCLImdW/56x?=
 =?us-ascii?Q?2t8F2zstQztrmPB4fc6Ots1vH8RCcyPIj/YY8XuXvXe3wcYIxzkA4ilrkx8Q?=
 =?us-ascii?Q?4bpxRy8lay3dm2568+p1IvORyWrSrs46W0zHP8FJuQCFc1XITLoUE7NlxbDe?=
 =?us-ascii?Q?VYS75x7k4NSPsxtBvCLjZYvhmY+JoavmsOCRknpJj3Eryn+YEQHk/F4W3gKG?=
 =?us-ascii?Q?zq8SuoLb6SjD0atPdZqXFyqHp474u89QtONLMwctJsGwLJz2ilV0juOzT6IE?=
 =?us-ascii?Q?81ApliYbZ9Oc/QRoQPMDaKtzgl8qn92onqJFKZC+bmlEA/iZXMyt8dSAs8h5?=
 =?us-ascii?Q?7abPG16hplMU2+AlgGhZmf5V1qaFGnc+2SzXOu9ltyelEzMcPqQJqtgYrDIW?=
 =?us-ascii?Q?JzdYTRTP4/Hn6Dndk74MyJ8sknM4FGVPH1jCufsrhST49I8OXCbBrAo/vhQf?=
 =?us-ascii?Q?vQ3E9icISMpqd1DM+0Mv9Abp+6GpzqmpyLfbOMX9wW8kssFFC4fcdSi6Lcko?=
 =?us-ascii?Q?4FHm8HKOpAw+s8Pr2IjvGzmM7teWP6O83/Fs4ytESNb4UVVEOeoSKmrIpTXc?=
 =?us-ascii?Q?KcfXh/rHpGOk8A+apwp+CAUuETz1l51iNQpLTqQ/aCMAl8G5sNjbNaHesC1C?=
 =?us-ascii?Q?hVQa8uT/JlIMZqKm3KgjXCU/QPPrGkoU1BeztJ7M/DkIgFQmbRjL1Aujsrcu?=
 =?us-ascii?Q?DMyWZwB+m+ZGBHZqYxzSHHP9lKO2ESiYxrkK6fV0hOxQewYtuSbjgiKy4Kkd?=
 =?us-ascii?Q?fMlATqv+lhI72r1cSubuu6or9/camdiwPzojGX2JtlROOXoP1W8Kj2BhiOr6?=
 =?us-ascii?Q?ymJ9ysMek4lDkpcdzsPCtrgScRL9eRJxKCawWd9A4JZMlq0u/2WHqKv7rIrQ?=
 =?us-ascii?Q?7CO+6tv0fgXn0KFj2ZmE0glyMmVCT1Q5wUwgS7eN4gK9NjA5OgR6NOW2Ya6b?=
 =?us-ascii?Q?N59phixarHDPkwPSyZHhrhG3IZHNGCY+8Asqi9yEWbGHfLeetJZEuqH0iPqX?=
 =?us-ascii?Q?D6DO7eWX3CzHRYvTUIBiab0oCNuF8SNTmO7H2dH/In4cZvphYD2pCfb1+1M0?=
 =?us-ascii?Q?y2IYo5k1RniqSBPuJOBLf/yBp7WQtv0RT8+YlG6Td68QdL3squCV62mvMKYr?=
 =?us-ascii?Q?9SurLR8FZ/1A1fbXE4rXcy9Hnvr4zSWRMoK/13PEJxe4HJD+PPUIv7Y1mKVx?=
 =?us-ascii?Q?5El+6LiYl9zXaqzFcHatXlb6mb40o2fC7QwexufLGg+dpliDdmznD6r3uEmh?=
 =?us-ascii?Q?ENvgd/4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6RD2ANPbJskc+1w3BdxjxAUuk7Tn4K+ISpqEWLlGC1bVVF0m6HI4esEXQt3m?=
 =?us-ascii?Q?ap4pPcLZchEp32ELuVemADNW4lERU/mBbLPEu4PsQLur19wl7UZzjdyrgyDD?=
 =?us-ascii?Q?qFV5wiqTQ8l8LHuynKmsbHFeAbNJ1mwqhkYmpJicmYYVWMFmxt6oOZs9/vrI?=
 =?us-ascii?Q?1IwnXkjhbdQ2M8VGZCXKOc34Nj3Pr55+j8toyBCAIla2/eb5K19QQGZDJCsD?=
 =?us-ascii?Q?DOeK4W0owhl18wavzQfMLf85CqZ8Iy4RplabMc9Opfzsc5xfCWFAyRu59WN7?=
 =?us-ascii?Q?w1ylfi1DqUv5RYyM9dnNXAQjSEHEaweCIG+LOPoIIszRi9SYvXDopi+JNSE3?=
 =?us-ascii?Q?jfmI5NC+uCeAFQeBUR19V0XCuOOfMgkdB051RGyl4TaCviTwPriaczclRc+y?=
 =?us-ascii?Q?qCZGy3C/GfN7d1yoSxgXRMWKmXBoDwBpUQrtAKiImIHibKWnegto0f3/Bk3v?=
 =?us-ascii?Q?s8K/ABdd/EwLzPa2KK9xau068uvo85LzHFzilKJAa7L3dYzG5UF9cOoBa4I1?=
 =?us-ascii?Q?gFti4d10wLQGPE+7L9Ycov+TW9xv5XafPa6xT7GSlfFM+UUkS6ABJLA0Scb7?=
 =?us-ascii?Q?lLQUZQ5ktLA2JKbi1+7keh3IF6EfJTHdc46O0xlEt9bYQ/Qnk1NyXRFI0nIo?=
 =?us-ascii?Q?sa7qxlLJ70ehT2i1sF2zxsIgrJ8uEbBWtvzw5veD8qo252K9Bfse/gL/VsAy?=
 =?us-ascii?Q?wlDIJNzIvIsRCGVJD5iveX6H3QOHbsqSUHy47a0Ji4DJ310KFhXDwOBo+kv8?=
 =?us-ascii?Q?BImTDva/vSQ2MZK8WXkFXZTqzx98SZ2y+1LgGXTKEARUHoHWJBU5ja1by6dt?=
 =?us-ascii?Q?QyTIUPWPq2zldrT4gnfyV4733XsQWiaEaRjbUCnhhyWImTulp3N0GozVhmA7?=
 =?us-ascii?Q?7lRUK8AZAth/+vJcq7zS1WTm+Rc+NC1nddbVeWielyyPwbiLA3jbNsDbhIFh?=
 =?us-ascii?Q?BUKi7O4aJG/Wk9LrC4aH48tXUcvp+3xIiJ8Lqa9vUfN3sO+gTmRqi0UNXvzJ?=
 =?us-ascii?Q?DxKSa4+pjzQibhY/lwhsnTeh/+vw8DXkcLqAaip0/vTsCrt3hx8IZJwu6TgC?=
 =?us-ascii?Q?3MDlQgndXgDwHGHJYFF+1kB/gPZPW2kO9L9ux0CxIGVYLAD2JrJlNmMQeDjb?=
 =?us-ascii?Q?2jQLz2UfTOYLup0+tlwvrwI8fFd731qKw+cMY5AS1yS0D989uvbx+5L66mR9?=
 =?us-ascii?Q?gGEjM9wI19tp5d4Xrzdq4CMdp5MHwhYKRrxcblqfUcUtpyYZA0P9x614d8cz?=
 =?us-ascii?Q?McKc06Xqd5xiao/7BNusqz7y5AFL0bj3tXeqSElwJfL4tfUMFBrRpZ4CrlQ/?=
 =?us-ascii?Q?0TJ604dbsXJbdUXHvRiIjWXqKUsujcG2x7++6Mb+P5SIVowlKN4HyEHRGonu?=
 =?us-ascii?Q?SIHJpUVw1x6yWxVkAUaiMIMHkDpr2J6V5A51WjLfTta7faOwZF6JFCXtnk6n?=
 =?us-ascii?Q?qoqiXWb0TyQ5Plu0u7CD6G1TssrJsFPB/lg7f5/FDx9ynaHeg0Zh0SoBhVc3?=
 =?us-ascii?Q?OQclLC/dpBxSXsg7xreUBadH9T+e3ip2fRRXZ1ThLSG8I7UcOhWBWSHEYL06?=
 =?us-ascii?Q?q5P3jLFAyJm67zOB6doUPu2K0iIVNSG2QkWxFB0v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee6f041-00cc-48a8-bcb3-08dccc9dd8ea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 04:55:50.2362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u7PsR+IDPnb4YzmIlgn0bGCFc01KM1qg+4qJrDpxhnOL4vCyVAf6ledlsBYGAC0N/ePNRmTfYqCj2rtjgksS/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6948
X-OriginatorOrg: intel.com

On Tue, Sep 03, 2024 at 08:07:49PM -0700, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a new ioctl for the user space VMM to initialize guest memory with the
> specified memory contents.
> 
> Because TDX protects the guest's memory, the creation of the initial guest
> memory requires a dedicated TDX module API, TDH.MEM.PAGE.ADD(), instead of
> directly copying the memory contents into the guest's memory in the case of
> the default VM type.
> 
> Define a new subcommand, KVM_TDX_INIT_MEM_REGION, of vCPU-scoped
> KVM_MEMORY_ENCRYPT_OP.  Check if the GFN is already pre-allocated, assign
> the guest page in Secure-EPT, copy the initial memory contents into the
> guest memory, and encrypt the guest memory.  Optionally, extend the memory
> measurement of the TDX guest.
> 
> Discussion history:
> - Originally, KVM_TDX_INIT_MEM_REGION used the callback of the TDP MMU of
>   the KVM page fault handler.  It issues TDX SEAMCALL deep in the call
>   stack, and the ioctl passes down the necessary parameters.  [2] rejected
>   it.  [3] suggests that the call to the TDX module should be invoked in a
>   shallow call stack.
> 
> - Instead, introduce guest memory pre-population [1] that doesn't update
>   vendor-specific part (Secure-EPT in TDX case) and the vendor-specific
>   code (KVM_TDX_INIT_MEM_REGION) updates only vendor-specific parts without
>   modifying the KVM TDP MMU suggested at [4]
> 
>     Crazy idea.  For TDX S-EPT, what if KVM_MAP_MEMORY does all of the
>     SEPT.ADD stuff, which doesn't affect the measurement, and even fills in
>     KVM's copy of the leaf EPTE, but tdx_sept_set_private_spte() doesn't do
>     anything if the TD isn't finalized?
> 
>     Then KVM provides a dedicated TDX ioctl(), i.e. what is/was
>     KVM_TDX_INIT_MEM_REGION, to do PAGE.ADD.  KVM_TDX_INIT_MEM_REGION
>     wouldn't need to map anything, it would simply need to verify that the
>     pfn from guest_memfd() is the same as what's in the TDP MMU.
> 
> - Use the common guest_memfd population function, kvm_gmem_populate()
>   instead of a custom function.  It should check whether the PFN
>   from TDP MMU is the same as the one from guest_memfd. [1]
> 
> - Instead of forcing userspace to do two passes, pre-map the guest
>   initial memory in tdx_gmem_post_populate. [5]
> 
> Link: https://lore.kernel.org/kvm/20240419085927.3648704-1-pbonzini@redhat.com/ [1]
> Link: https://lore.kernel.org/kvm/Zbrj5WKVgMsUFDtb@google.com/ [2]
> Link: https://lore.kernel.org/kvm/Zh8DHbb8FzoVErgX@google.com/ [3]
> Link: https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/ [4]
> Link: https://lore.kernel.org/kvm/CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com/ [5]
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>  - Update the code according to latest gmem update.
>    https://lore.kernel.org/kvm/CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com/
>  - Fixup a aligment bug reported by Binbin.
>  - Rename KVM_MEMORY_MAPPING => KVM_MAP_MEMORY (Sean)
>  - Drop issueing TDH.MEM.PAGE.ADD() on KVM_MAP_MEMORY(), defer it to
>    KVM_TDX_INIT_MEM_REGION. (Sean)
>  - Added nr_premapped to track the number of premapped pages
>  - Drop tdx_post_mmu_map_page().
>  - Drop kvm_slot_can_be_private() check (Paolo)
>  - Use kvm_tdp_mmu_gpa_is_mapped() (Paolo)
> 
> v19:
>  - Switched to use KVM_MEMORY_MAPPING
>  - Dropped measurement extension
>  - updated commit message. private_page_add() => set_private_spte()
> ---
>  arch/x86/include/uapi/asm/kvm.h |   9 ++
>  arch/x86/kvm/vmx/tdx.c          | 150 ++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c             |   1 +
>  3 files changed, 160 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 39636be5c891..789d1d821b4f 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -931,6 +931,7 @@ enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
>  	KVM_TDX_INIT_VM,
>  	KVM_TDX_INIT_VCPU,
> +	KVM_TDX_INIT_MEM_REGION,
>  	KVM_TDX_GET_CPUID,
>  
>  	KVM_TDX_CMD_NR_MAX,
> @@ -996,4 +997,12 @@ struct kvm_tdx_init_vm {
>  	struct kvm_cpuid2 cpuid;
>  };
>  
> +#define KVM_TDX_MEASURE_MEMORY_REGION   _BITULL(0)
> +
> +struct kvm_tdx_init_mem_region {
> +	__u64 source_addr;
> +	__u64 gpa;
> +	__u64 nr_pages;
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 50ce24905062..796d1a495a66 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -8,6 +8,7 @@
>  #include "tdx_ops.h"
>  #include "vmx.h"
>  #include "mmu/spte.h"
> +#include "common.h"
>  
>  #undef pr_fmt
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -1586,6 +1587,152 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>  	return 0;
>  }
>  
> +struct tdx_gmem_post_populate_arg {
> +	struct kvm_vcpu *vcpu;
> +	__u32 flags;
> +};
> +
> +static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +				  void __user *src, int order, void *_arg)
> +{
> +	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct tdx_gmem_post_populate_arg *arg = _arg;
> +	struct kvm_vcpu *vcpu = arg->vcpu;
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	u8 level = PG_LEVEL_4K;
> +	struct page *page;
> +	int ret, i;
> +	u64 err, entry, level_state;
> +
> +	/*
> +	 * Get the source page if it has been faulted in. Return failure if the
> +	 * source page has been swapped out or unmapped in primary memory.
> +	 */
> +	ret = get_user_pages_fast((unsigned long)src, 1, 0, &page);
> +	if (ret < 0)
> +		return ret;
> +	if (ret != 1)
> +		return -ENOMEM;
> +
> +	if (!kvm_mem_is_private(kvm, gfn)) {
> +		ret = -EFAULT;
> +		goto out_put_page;
> +	}
> +
> +	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> +	if (ret < 0)
> +		goto out_put_page;
> +
> +	read_lock(&kvm->mmu_lock);
Although mirrored root can't be zapped with shared lock currently, is it
better to hold write_lock() here?

It should bring no extra overhead in a normal condition when the
tdx_gmem_post_populate() is called.

> +
> +	if (!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa)) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	ret = 0;
> +	do {
> +		err = tdh_mem_page_add(kvm_tdx, gpa, pfn_to_hpa(pfn),
> +				       pfn_to_hpa(page_to_pfn(page)),
> +				       &entry, &level_state);
> +	} while (err == TDX_ERROR_SEPT_BUSY);
> +	if (err) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
> +	atomic64_dec(&kvm_tdx->nr_premapped);
> +
> +	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
> +		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> +			err = tdh_mr_extend(kvm_tdx, gpa + i, &entry,
> +					&level_state);
> +			if (err) {
> +				ret = -EIO;
> +				break;
> +			}
> +		}
> +	}
> +
> +out:
> +	read_unlock(&kvm->mmu_lock);
> +out_put_page:
> +	put_page(page);
> +	return ret;
> +}
> +
> +static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_mem_region region;
> +	struct tdx_gmem_post_populate_arg arg;
> +	long gmem_ret;
> +	int ret;
> +
> +	if (!to_tdx(vcpu)->initialized)
> +		return -EINVAL;
> +
> +	/* Once TD is finalized, the initial guest memory is fixed. */
> +	if (is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
> +		return -EFAULT;
> +
> +	if (!PAGE_ALIGNED(region.source_addr) || !PAGE_ALIGNED(region.gpa) ||
> +	    !region.nr_pages ||
> +	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
> +	    !kvm_is_private_gpa(kvm, region.gpa) ||
> +	    !kvm_is_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	kvm_mmu_reload(vcpu);
> +	ret = 0;
> +	while (region.nr_pages) {
> +		if (signal_pending(current)) {
> +			ret = -EINTR;
> +			break;
> +		}
> +
> +		arg = (struct tdx_gmem_post_populate_arg) {
> +			.vcpu = vcpu,
> +			.flags = cmd->flags,
> +		};
> +		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
> +					     u64_to_user_ptr(region.source_addr),
> +					     1, tdx_gmem_post_populate, &arg);
> +		if (gmem_ret < 0) {
> +			ret = gmem_ret;
> +			break;
> +		}
> +
> +		if (gmem_ret != 1) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		region.source_addr += PAGE_SIZE;
> +		region.gpa += PAGE_SIZE;
> +		region.nr_pages--;
> +
> +		cond_resched();
> +	}
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
> +		ret = -EFAULT;
> +	return ret;
> +}
> +
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -1605,6 +1752,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	case KVM_TDX_INIT_VCPU:
>  		ret = tdx_vcpu_init(vcpu, &cmd);
>  		break;
> +	case KVM_TDX_INIT_MEM_REGION:
> +		ret = tdx_vcpu_init_mem_region(vcpu, &cmd);
> +		break;
>  	case KVM_TDX_GET_CPUID:
>  		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
>  		break;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 73fc3334721d..0822db480719 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2639,6 +2639,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>  
>  	return NULL;
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>  
>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>  {
> -- 
> 2.34.1
> 

