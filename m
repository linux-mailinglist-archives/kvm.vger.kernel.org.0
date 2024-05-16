Return-Path: <kvm+bounces-17515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4A98C7176
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 07:53:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D6751C226A7
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 05:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBCD623765;
	Thu, 16 May 2024 05:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ks2SSCAo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529B521104;
	Thu, 16 May 2024 05:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715838793; cv=fail; b=OBjJv+2YkLIgXSNwpNl6Tpr7SRfmzUykaOC1w6uMqtdAVgtFguPKbPD4Ky6e67Bv+saT+ySjSoaJSdJ561yeRHa4DNY7Shhzls4h11ZNj/4JTebvDWtBYPlPNu0y9AyZ4tR5NmG4Ouwp4BDdewUmhDCKXkPYaCPZu45Ovp5FpMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715838793; c=relaxed/simple;
	bh=QzlzCXKePyuL2H/xpFi9DeM4kofg5fd9mZYC2+zWS8M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NMMIYdvethZw1Jo4JLwxHe0YQ8oyIlbw6N7nzuu44ZtlAtUTAsERB+je8cEd8vfJ01JzhAX8yQSoDQKKk9y3jTwyZ0bqDZ0IsYes7yLX6USS5fEXo3wOifu1Oxkm1GuOmTwp6OiEycN9SocuBBYi867hkesk6f4CDDQ4eXWsUas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ks2SSCAo; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715838790; x=1747374790;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=QzlzCXKePyuL2H/xpFi9DeM4kofg5fd9mZYC2+zWS8M=;
  b=Ks2SSCAou0rhC1ejbyXCwwPSNfd2DJVK/7Q2z7CgbU3z4aX6dq4RVWen
   Mj2FZFLfE2lSR8u23KvrwMNB/zIi3iaYtQp/XKa5MOUtGvYruOBlBgvaq
   5wmpuFknmPnnV5SWAgooWLnvs6zqhFx5zxs+CCFkgBy+HnRNv6zI23Bk4
   fDUxjYwIIM3e2+59A6vH7fo0teR7eLqyimdjzM/uy97Tq8gVC5JT/cmMm
   Ml40VKrR5ldKNBEx7ZUfFX3iVEWzaQMGqBZRPFOZ+cFJdDdoAjPKLaMqt
   ILN1i7eQKAq2qG/AwBO4ZZ5Jn6K9QZEGeo2Kxm9WpuEtv4g7OzVPkHd5q
   g==;
X-CSE-ConnectionGUID: Yrjn8SLmTQOuwcpwJ5weOg==
X-CSE-MsgGUID: /bJWb1eITneFIFSeouG7vw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15754070"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="15754070"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 22:53:09 -0700
X-CSE-ConnectionGUID: 9ezaEPUNQ0K0UP61syEZOw==
X-CSE-MsgGUID: /NCKCxgSQfOhnCEOltGc6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="62511351"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 22:53:09 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 22:53:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 22:53:09 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 22:53:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bby1LxvApymh6RC9U6zXhJpt2yG56RbRZMJhnEJtikSgMKOFZ/5j3jPRk32aaYEULW6DnTfbKtJQ9p0KsJM0uhIUobyWZRimvpQbkN7b1ftfV0+twZ5rInFMwXNTCAKikXhM1ea7fizydMkKi3WruA+cY5tXJA31lqm3r2JxHFSzgxLTZthsgasU7UjWdZvahjzSoWXpEwvYqkKw0oZBvxhq3TgelXkfxqQoD3YkGVX75UqW+w7LefhHJTtq0L0S6TqS4EHXD5sq3Dpf2gu7sCCwqFgI4jjvUHFTQ3D3aC6DQjgkH3Oer7si6NxyB9xdUl28v5Ilpzvt3mhW/pmzzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uwZOIzLq7BX1Nt2evGGEMKPlu4kpTPp+gb/eQ32V9U=;
 b=noLNo/8gjXSlBAOyddziE3fvY73se7JWtsV5xd6zyK4NIpFmsLhdRnA9oZ90OzWFZLYbnk0LntAk/3zcVE0xcm4xRnZrwKOKJkuBsjFyoUAdnBaBqO3I5TmkQzp7v+lpxeNohoPHF4h1glPmD/gJ150QcXTp6b19IbDmm3hlbz6uMSniP/fOdClxVynK2kb0zHCyiLUDtHqwGbPzLnv05wru7NL6OdeW+T+Q99choYtQmT49q8hDwS4ucC9Ogf33+KWq4mRBEBwEnYw+lST98X/h0qkXAN9DIKpOZI7iMcvl13hrsb98wOVueQ8Tkna61CQR2/JNESgeynvzqwMNJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7089.namprd11.prod.outlook.com (2603:10b6:806:298::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 05:53:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 05:53:06 +0000
Date: Thu, 16 May 2024 13:52:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com"
	<dmatlack@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Message-ID: <ZkWfE2KSpPgv6RND@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
 <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
 <d8ff5e19-85a7-46bf-9dad-7221b54d8502@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8ff5e19-85a7-46bf-9dad-7221b54d8502@intel.com>
X-ClientProxiedBy: KU1PR03CA0005.apcprd03.prod.outlook.com
 (2603:1096:802:18::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b5403d-8506-4250-5158-08dc756c7502
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?dh4wDyZFvLUDvv/1BOMXA0cTGjmxFFI9AAYjIMIabwekIPFQ76xXiFOR02?=
 =?iso-8859-1?Q?1YD2usSj+5ZCjo/BtzGZ6UyOcg4WbfMh4sXJZPZWokFDabgEZL4/XRP55u?=
 =?iso-8859-1?Q?sQuBNUxYUGTE2f0JSEjgu63/bQBN/HpA6gOxafVfnSUL5JOi7LgIpUsnM8?=
 =?iso-8859-1?Q?ATZW/8jxSIIq813yBYrD21SqFOncmNEOinRuQuQBjJ/3Ac857X1FkpPXP8?=
 =?iso-8859-1?Q?qLDCuoilFlVVuVa37NIV/XUU48jx6Vkfxu6TRu1HNQKoG0PDUzRPzNvMgc?=
 =?iso-8859-1?Q?CaEO7Rih1GySqpkraSYP4v2KI/pBVJ5c8cpTORn9XfekNTrjSiD2YFLVwv?=
 =?iso-8859-1?Q?qMfDx9n5kWhPfb5gJLweaxyip2S3ph/abvr7EWrOs9wnAjkP2Eguuz18eu?=
 =?iso-8859-1?Q?IFyWT+2ErWEQ2+FWf5qYI7BqfFPS2/0OQ11eg2jVV/OJvKYSwjoTuDcfCF?=
 =?iso-8859-1?Q?IxjjP1HMkqZwWu4q43XebDyLdRHW1yK6iKcDEN0CVkSsYae3/Sgg/C+soz?=
 =?iso-8859-1?Q?omlt/RU4uk73w+MYFlWaT5UsusZXQae30ODGHg7vGk+t1PB4YfO3ekwBUK?=
 =?iso-8859-1?Q?tqLHyNmCCuwHCkbA1LODi5rRuhNdgOXe2xdsx0266dMBEVx968zlzXngxd?=
 =?iso-8859-1?Q?yfL9iUvE+9cCc3SLZfDrM12dXqtnLznShcx8joEiaRdRSoHMy7b6/fS2/+?=
 =?iso-8859-1?Q?wkAok41Q8AxaerEH5ElYOncQ4n5OdnaWzG0LmWXRoOQFRrLU92/K+8ftTA?=
 =?iso-8859-1?Q?SO0bKTHyiqi/Pcypjf/u/8cm9TbEzOI79GVziWjeXT4jVFjMuWxHUmXz8d?=
 =?iso-8859-1?Q?iK4IcI/zjeo2wrKrMBuZ6ae5jqXXp3GKHNiACs8Ti8Oq2kcsjERMQ2spdo?=
 =?iso-8859-1?Q?MvKEHiOkdaNoZzKhu1chg/k9+Lyrp0Cm1oZ0lwIGiykCrN3OdzQetIfTey?=
 =?iso-8859-1?Q?DZ+OPuX0LDIZul9JqPU5lnU+brFSt6t+ambcwPG2KQj4oupQFYKRr6zL+5?=
 =?iso-8859-1?Q?121g2bj4/QU81PPF/BD7YCllKtsf6czxKKYVXfLkEjjF9MYvnXn2sAukon?=
 =?iso-8859-1?Q?GYYnbNWlSMmm0JWFwvnF0z4KEx17OBa7kRvinwKUOVp5wsZg9/F3U8rS7w?=
 =?iso-8859-1?Q?lhAuCam+Lgg1s+ZBZZj0ZyY5OqV5nKj51kwxXnoVvHtfYZwR6Q/+/sXqpO?=
 =?iso-8859-1?Q?vDMLwxxYiTdW852i3fn82tmCmo5MjfKKBJMSIeFUL9ImmmHoBjigsKpPdj?=
 =?iso-8859-1?Q?EhGicGsd38pcLH5G/30wKw90KC5kv36tKbH2lrAOWkjbGAh+p4qlSRcprz?=
 =?iso-8859-1?Q?mqZnsB4kVcJMrhuBvFjR5wfPzQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?zD5jUxnDPYxZB6ezqZ7D0l2LvuSyWrBvEuSroiAI9K5VPTgRu8m28ejlAZ?=
 =?iso-8859-1?Q?uHD+zaCbbVFPCbM3yX25dmWpfRqz5E5O48pDCiOj1ZDFMtRCpvuN8cA/yf?=
 =?iso-8859-1?Q?ZokdQl4UVvhBi29zwgAXJNpoSa5lfMvIT7qW7epHJhrMh8NI3QSA1Ri31p?=
 =?iso-8859-1?Q?LyQ8sXUuiZSNUuuKEZCtNSH56yp1fQ0DRfK9X/fGdZpVtqb3BwtsKZ3/56?=
 =?iso-8859-1?Q?mquSrs/oRDH8eE7KEBbgyg3U6py5y2vH2V/IzKQZ1FG0Nk4ik0B2vwTgst?=
 =?iso-8859-1?Q?szRAdd/xUGiVkdMPSkrmdLL6xVNHH3/60Z3MGFkUw+LuXxH6/dEzX/KFD0?=
 =?iso-8859-1?Q?wCXGnrceOf8kTS49HudhDnZNnHBceY6pqqnh6jlHonmTDLRK7PvauyxAMn?=
 =?iso-8859-1?Q?+rFzb0zzpY1qPkY8Lo0hn7WNf3yK3O2RIffEtu7gPvSFU6siPcwJqcA04b?=
 =?iso-8859-1?Q?rJbLwewWpryD/YL1XHSYccoCi4doscpVxXqcyjoJ/yj9WB1YeGaq45P/sX?=
 =?iso-8859-1?Q?NSs//hRK9+H7HO7YbluvHqXr5Ef0qwo0GduoY/2HWJsKkZKt1dz4V0qsqn?=
 =?iso-8859-1?Q?3YMPMVMgZ6spOr8oMpPvQ10nicZaJO8JQbn0a9jsfzgcOKf8GfDSMlE/xo?=
 =?iso-8859-1?Q?1+gROcx9MiG8yFt6jpEUG1mwOt+tx7vsJGCWi2bxbIw30tFjyBtZShFret?=
 =?iso-8859-1?Q?Cuyymv4miSNZuzHk9Lhk9rmrX8DTdz0NJ96yea8hp8HfUX5CsAQI+t8kDJ?=
 =?iso-8859-1?Q?/Boo+LlYIEJjMniZePhgnnM2Nfimqn1pw6qlBotWUySYP/GBpg7NkCrGz/?=
 =?iso-8859-1?Q?rZKH8BH4cZZDGj+2depePEUOT+7TDGoTEEwxm0YtWYH5SjPEyWza+LAtXK?=
 =?iso-8859-1?Q?aYPfCnYMBK+pEAtNfTz3ie0u0T00J1Lq+MFZ+3QoEF9IYCGQSVDNZo8OJQ?=
 =?iso-8859-1?Q?ngRb+MJ5TDGOs5uKo96ivxdgrxYIBByP9zD5BCoLy4oDsCRBSSjup7qrd5?=
 =?iso-8859-1?Q?jHapuC8cb1vfTxNwaLeVp6u+42yIiAEK4ifZfR+Pwo/+x3jo2A2ROjrP5P?=
 =?iso-8859-1?Q?D4iCQZke1pVADt0k6CssMmNdGiDOFigx/XOtZCc5vtQtIW+vkJounK9fvb?=
 =?iso-8859-1?Q?0CJ77l5btMqHFM9GkUKiGPRLk11HinKDo1wwQp+THYZfyhVT025w6RVUnt?=
 =?iso-8859-1?Q?KpR5QfUxwSEZZ7r/+d8VpSPx+fGEriITsf/ND5ed3/mIHdx2qNLELov7IV?=
 =?iso-8859-1?Q?5OOXIcl8ivwIymzBSvkPowXsKlrR+WwDEdgE6s7LqxQNjzsy2CnHYCLdiU?=
 =?iso-8859-1?Q?hR54DyOdq4be88EFwhrwDKEwfQVy3Pd/aBoyipidZ5hJIDKlQvEhvWW5/x?=
 =?iso-8859-1?Q?HNJFwpePqgc6uEi/HXLtFEdrtCTTuqtVIFXhY53uWCwu3+he9GGH0sABpZ?=
 =?iso-8859-1?Q?8znoPtGrdiRZW4HKu0qj2s3UYyrmtzhaiEPtCAiJX02B4h9ThyRvC826QX?=
 =?iso-8859-1?Q?4TqHAOEtL/IbqBgdezVyarPMVFN6zV9mg7mg+YjeKQmeNnnmlwaEFJZqkL?=
 =?iso-8859-1?Q?VqeKgUO04h/oidxCXU6PAgUu3u38kSJV0xSYu+CPyTl5d245JgzacMyqMz?=
 =?iso-8859-1?Q?6sSnDJ/y4ymFlomsIW9D40o7h/QQHwR5es?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b5403d-8506-4250-5158-08dc756c7502
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 05:53:06.0936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AO8bOhk0r3sudzKYyZmrcjUBdLQZo09zltpL4NVlsNW6qa6C8g36p51g3dp7r8Wqp1/V7lgvn4FnM2CqEm12jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7089
X-OriginatorOrg: intel.com

On Thu, May 16, 2024 at 01:40:41PM +1200, Huang, Kai wrote:
> 
> 
> On 16/05/2024 1:20 pm, Edgecombe, Rick P wrote:
> > On Thu, 2024-05-16 at 13:04 +1200, Huang, Kai wrote:
> > > 
> > > I really don't see difference between ...
> > > 
> > >          is_private_mem(gpa)
> > > 
> > > ... and
> > > 
> > >          is_private_gpa(gpa)
> > > 
> > > If it confuses me, it can confuses other people.
> > 
> > Again, point taken. I'll try to think of a better name. Please share if you do.
> > 
> > > 
> > > The point is there's really no need to distinguish the two.  The GPA is
> > > only meaningful when it refers to the memory that it points to.
> > > 
> > > So far I am not convinced we need this helper, because such info we can
> > > already get from:
> > > 
> > >     1) fault->is_private;
> > >     2) Xarray which records memtype for given GFN.
> > > 
> > > So we should just get rid of it.
> > 
> > Kai, can you got look through the dev branch a bit more before making the same
> > point on every patch?
> > 
> > kvm_is_private_gpa() is used to set PFERR_PRIVATE_ACCESS, which in turn sets
> > fault->is_private. So you are saying we can use these other things that are
> > dependent on it. Look at the other callers too.
> 
> Well, I think I didn't make myself clear.
> 
> I don't object to have this helper.  If it helps, then we can have it.
> 
> My objection is the current implementation of it, because it is
> *conceptually* wrong for SEV-SNP.
> 
> Btw, I just look at the dev branch.
> 
> For the common code, it is used in kvm_tdp_mmu_map() and
> kvm_tdp_mmu_fast_pf_get_last_sptep() to get whether a GPA is private.
> 
> As said above, I don't see why we need a helper with the "current
> implementation" (which consults kvm_shared_gfn_mask()) for them.  We can
> just use fault->gfn + fault->is_private for such purpose.
What about a name like kvm_is_private_and_mirrored_gpa()?
Only TDX's private memory is mirrored and the common code needs a way to
tell that.


> It is also used in the TDX code like TDX variant handle_ept_violation() and
> tdx_vcpu_init_mem_region().  For them to be honest I don't quite care
> whether a helper is used.  We can have a helper if we have multiple callers,
> but this helper should be in TDX code, but not common MMU code.
> 

