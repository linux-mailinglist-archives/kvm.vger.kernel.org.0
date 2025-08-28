Return-Path: <kvm+bounces-56033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A22B3946E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 08:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADB699828E2
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 06:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6882C2376;
	Thu, 28 Aug 2025 06:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GkMJJAyf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D4619FA8D;
	Thu, 28 Aug 2025 06:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756364183; cv=fail; b=HF0oKZ1D+BnRpSkELDeLUu9ZgwMRMiY5Xk0bTdgW3MwS3kSaF0yJYQypRJ9z9U11itreFpZcgl1eyaBle9Ld3neBkXBvSYePm7iIn0k0V33Id1horjH2+Q/isbULbLlFh0YylmDQ323ClrK7Wx/R26t9WexCpTcLcO8e6H7Hdp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756364183; c=relaxed/simple;
	bh=WUF0334rjnHAn1clpq0HDEiaRSI+0kIo9Y0YPfrTfeg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LVqqa9gzqm/HlTN+zOkLk4oob8NndbhcSrRN3UrSYjpx0fuKeZH6imba7AYc7eR/oS7LSt6GtsHdrmTJlNJqLyTzwOBxq/iSkv+/vtro762Momg7sMB0D3xOa/IyRZjnaJGtjmqJ/42Gfw9lYZb0VinMRiVuTgqZtewlQREHdoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GkMJJAyf; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756364182; x=1787900182;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=WUF0334rjnHAn1clpq0HDEiaRSI+0kIo9Y0YPfrTfeg=;
  b=GkMJJAyf3jvEbaZMjbrcrKTFzweu07gdvu0SriFueN0p9ZvPpwYfdyfj
   c6mn+8yO4BmGGY49QZ66xMJX+lJo8cHM/olRGyTdazT8xUCCkEoMYkArr
   Y/eJ5gTjN2Sh6qqygk4AVbTxMm/TTJX/wA+tswEDZiQElsOOcLEG7ZqI7
   kxYYWUc+2dbvaY6Z1W6ks5/B+kMoCO/aRO/X0hrIYuSUhJhefwqFXN8ry
   q+PKsOu34fGCYqlXbfJSHVX3jivxxh5PmJ1NcQBzeaM/KPiT9futrNBbj
   gjmwQ3L84SX5ctGsi+JNIWOCz/XFSfo8UXQCcI0p1s5AbZ1EEqVCQ9KRi
   Q==;
X-CSE-ConnectionGUID: nLY3udvfRdWhZ39szCMLTA==
X-CSE-MsgGUID: MDnWiOTuQhi36ZjvH9aDZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="62446818"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="62446818"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 23:56:21 -0700
X-CSE-ConnectionGUID: PSyH80AXTRCEvnxUhqIRhg==
X-CSE-MsgGUID: /h9WM0H8Q4mYNMQyQN/h8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174415576"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 23:56:22 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 23:56:20 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 23:56:20 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.88)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 23:56:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qj4+BrfARAw7UlnnUDhIxYT1I7ocYy/xFICXGSbJpbMiyX6hO5tYJ2p3qawILDSzEfEmCkq/N/l6rxclync4BThYLdvYdJQ844Eki/X5mPg4sNxHqOxjsq1t0VezJTXaOKJb6+FJn/c8aUTuHdnN8kSm9IWgSp8iHM772Flst3cnoj90dZmUO3R7fk6mINz1EXrUoPP8SsYmMQwQYQk1eKjdGwxU5WIhJ8eoj69001wvMyOodbYM92md/rgSksHEpPCdowvwTxAilLBKiEhRS7hquMkt1u0V8yE/0RHN+Y9BCWgP5eNeYnEzSj0AfqY9QK0jRopEVjPzK+kC0xmgSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/o/DQIDlZD+yGWkXVQReFnYvlmWiXWiXhCmLJObv6I=;
 b=QHWaUk2cSeXLuIlRVvggqRt6nQILPsA+4BWIJG/TZ9TPxcaZJonqyc0kiTk7GiExkYWC/esvyOP/E2PYIqq3wbKHZrEGtARpWqY1/ET9X+4djrBK5g/kwIU2lT3IKTyGWA5/BFnauNfd5gmjAgT0DyJS01LAntOuq3OLafJqcQZAVLBIQkvxDrR/K06DrNjYWpOYcSRSCy5WXoxlWKOcKHROMJ8COch0I4UM1E4p0Wp0wtRC/jKQiyvUUWPU1r0ijtDRwsOSCl/zJR/QDn1OMt/5INMvYC6u3V5oVJtQ/aDtSKpWSJU0Nm26j/Gggh/iiamBHPaPVgpBwXATji2sMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6834.namprd11.prod.outlook.com (2603:10b6:510:1ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 28 Aug
 2025 06:56:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Thu, 28 Aug 2025
 06:56:17 +0000
Date: Thu, 28 Aug 2025 14:55:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Message-ID: <aK/9YF6UTHUiOFR6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-3-seanjc@google.com>
 <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com>
 <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: ced3a5fd-b428-4562-4875-08dde5fffc56
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6dGmuvX+GFDrJcdIS8pGXZK74gS37nggzzLj6sV78hbj+yx1VzBfzHt7Bw05?=
 =?us-ascii?Q?sq2qsr4gxkfzL6cq7QSqf7+GTO7sau/HwTGH3cKq1z3wrjSCNkZP0ZGEzdJV?=
 =?us-ascii?Q?c6UuF9oa9Ws8tgi574TlYCM9XnYC97uzGW7kGuFG5h38BDpTDLcq+wejgrwu?=
 =?us-ascii?Q?/p2jZiqZrMUaqiLu3G6DmK9Koo1sqm46HViSDQK0tJSB3CvkU5AmknXp5ji4?=
 =?us-ascii?Q?uuG3p4cEftfkZnELgNq4oVhhYiQhAmQ/4SdOXuIHtvb5KAcZOFBO+okrMUEV?=
 =?us-ascii?Q?Y9hC1ROn/QolFRGjbJAZZwFIs6J25t4ERxItYPAMzmdnq92Qj8QEKENsC+si?=
 =?us-ascii?Q?QjVO2FYfLI+rUDtpqPxmQAOS/8WXSuCNHEK82t1LiTDcI5fVexd+AiN0oXdx?=
 =?us-ascii?Q?zjkWAfevks1n2LeiynnyzTYokm2hdMif039+svitIB3bEar8At5tBE79ETvg?=
 =?us-ascii?Q?HyvIUqr44Xf1eQu8lMpzr7ntLHd1qyaxRnujHqfEBt8wIlflVBQWWLrEuxSR?=
 =?us-ascii?Q?ui+kE+NSpNnsR1f9A/PSdOTrenNYRTwzUak7pfHH1iUu0vPJSKx3T81eAKV8?=
 =?us-ascii?Q?VEql1BeB4nDkVSJlIbrDnZ2j+MDj+LdT+8mNugjAbXoNDmXVdfYuW8P3bLVG?=
 =?us-ascii?Q?zXmdAZ2JTJIDFGPpLa9vXgv36kVxaL/QuHUVaxmTGoS0nbdw18rQbf4AGsWC?=
 =?us-ascii?Q?dgZMQzv9XURVqHKpaW1KocKKOr/UDi4LI+uahnaWYyLBvbFjuwiDeh6RZUOC?=
 =?us-ascii?Q?tJx3II7u5yVDaRWhmL0uS4rYuZBK88yM2ongU3/uMcY0XFlcDOLituMklk7e?=
 =?us-ascii?Q?nNMYAjkk62h51oPAoKNVo5BH5Em2OTa+lDY5ST90rmaYTAfoDjjCg8DraHX2?=
 =?us-ascii?Q?ZDQ+R4vEqOL1Fao/PaxUiCufLrTIYyvMacQ2+Mrk/yBUGSs56gFmTJnDrMXU?=
 =?us-ascii?Q?tU+p4tTKdTannSmsqeL6/4LQ3FQbIzIXqRlF3I1fvm30MlW/uiQCFBFO77+u?=
 =?us-ascii?Q?uON4yZ5L+37rZPTR4wygkIcqaTB8I0MjPdstwL6yCuKBNx6kHKakQbcLEq4S?=
 =?us-ascii?Q?EzAFR1ySNoxEhuMnWu/SPaICYp4808isQamIw+kqadkDn0zGGeBmWd9DpMcj?=
 =?us-ascii?Q?skUPeVTgs5jT9MtUz3bqWbR7Yb5wEIwo55adiMw2cGCxock1tQbqcSnOcUPH?=
 =?us-ascii?Q?950TJC+8rwt+P+yrWtmRaYGKuP8gTPcEYkBxs/aIo0oOBMiGNnsCM6vDcuSh?=
 =?us-ascii?Q?BrHtEC59PxAYaIGMOYCuc+XUfxdD0PsRRRzIhVy8ys1+MZ3p9MliyWoZG//t?=
 =?us-ascii?Q?U/+4cD/6QM5S32hJYc4TSic38ebDsDOLG5KT77YARFuBXi2CH3S41qSVe2dW?=
 =?us-ascii?Q?/vMP3YCeZ0a2LSAwRuBm8kCO3Gf7KJmLEGgLgOvEE29faEDZmA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B4cEsbIrrp3sdyUS9FiqAwiTwqracbECVjcQ80mvWZrXCG1Rh/vtqmgf0ZOG?=
 =?us-ascii?Q?KJ/VSbdDZEIgeGWT0JywYnIDTNHZ6ghswtaIigW+05PVcv5yTJhfK3GvnKt/?=
 =?us-ascii?Q?yV7lMEAMri0o7vpkX+hn9PkVxEJn7Z1UxTtKvmSzReCyEFeqadxxxn7mRIQS?=
 =?us-ascii?Q?suxkEOucg5fHq2lmTZ90MX32d1OZImWe4n/spsiEaZ6iXdazOUvDPgMDpFL0?=
 =?us-ascii?Q?9BHC8XaRrTSGm7+6uNjNJD7WxgjDlYFcZEwgV+5xuf1vTXL7TJMnICScW3Bd?=
 =?us-ascii?Q?ga7/muam5dX3Qr0304FUSvO3/adL747GCqvKnbi7QtspgFmg8Pi6VLuWTUKh?=
 =?us-ascii?Q?5FKwe7+COfSq/v+SwESg34BSrfr6o8l+AQjPstmFC1Zes4FvTv5nvNerAkie?=
 =?us-ascii?Q?VGFOiFjhDkWH/l93cpkT0QxFuEBElW4g9l2wjIJFxJYk26eav3sroZGsuE6y?=
 =?us-ascii?Q?UD9c6NNrkNhM7T2kLWMyFQYN7lbWghe8rfbT0jldJ+uTTkhCIAuIZPD7+sgD?=
 =?us-ascii?Q?G0+vwU16lhGj0IT3rSSeJx83noqfMqIU3KvEfeKuUCpenb9gJRB83r2xf4tb?=
 =?us-ascii?Q?i6op393i5SFsQdo9hRgeJFnml3sPFcRZSFoYWYpwBifIUvJkEkKEi/OEk+Gq?=
 =?us-ascii?Q?EoOZGiV7RDdsABLyesYetmpyvsrX4xO4B4d0d3cw8llX//bqipv2e8xk6wNa?=
 =?us-ascii?Q?EspDMM4feBktfge7KPnOJJL1CwTQ/VI6XRNJ0l0n1jU4exTANcA1WUXF+0hY?=
 =?us-ascii?Q?wPw2Sp4QlCR94RznqRxkoJPjzorLLIIVAMmfX5Rs4ttZFzIDpeNlQes1FdAK?=
 =?us-ascii?Q?ADtIFUjYCqCdsGtirmqUR/qwPKHNJnZj3RMpRAjgzHbeD+JzI1lhVpdWHnkJ?=
 =?us-ascii?Q?nzn1m5ckvtVdhndUBWNzZt1cK3NxqupKWYOzQ6ptp5vh7rt9WibXsyfeDilU?=
 =?us-ascii?Q?0iACFfcwvCwvWbF4Yjgy1UhvZphXu1zNfP6FMWY7XrQnkZAqRT3Ykw2k/S7F?=
 =?us-ascii?Q?Z+3NAZUOrA9fdyLoBJoWEB/n40yfcz/h+jeVbRzJyiDX5VQ1wLHkvkIYsd9K?=
 =?us-ascii?Q?dcRhA7Rhmo7YE2o/9394HfMQOcYntdqxJhcBfBZpyCsIxOo8n5BXx3FGrhXv?=
 =?us-ascii?Q?Nk1RTPg/fNz8Nxaf/9ixz3+CHmWEhL9uGAfVhVU52Kn7VgqZCOFwW31sGl7t?=
 =?us-ascii?Q?PAgwa6mdHAvz+BKXlCH1WCE+VtN97OsOAEgvOfrNNxMVTeKmSTLHnSFOa1CT?=
 =?us-ascii?Q?p/ebsm8DS4Ex787uT9Sgs+Rife2K2NkaL4RIgM719pHX+wF1HTwPvXRsuQDd?=
 =?us-ascii?Q?6VzlAq5XMjXNZg4dR/06Ka5hBGjPIatVFYMkEapgDnW9RLUcrhaalZ/4KiuO?=
 =?us-ascii?Q?Z4MSxmjH8lXtu/X5OaoURbp8qIe7bUsFURo38jTV7w2ax0g/2aeAw9EjTpDI?=
 =?us-ascii?Q?zTRSuCRzuoAQ2ooyurCP81bYv8LXQ3D7xP3LXKmx2RSbWnI+OBNpvDp914ld?=
 =?us-ascii?Q?B2airh99RnGfgD+F2Ayr+uaSr0kAtLcP5KSyTS5wwhl7OZZj4IptOhWI9knf?=
 =?us-ascii?Q?bUZ87v5IH4LmXg07Km8qafWtMuU2wJJR7nTowfyg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ced3a5fd-b428-4562-4875-08dde5fffc56
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 06:56:17.0452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJIdgQ0mYRmzCrI91LyFUBCsbViGvCQGbspt/FOwSdr5fEgaMLmlUZazYMLDS9xiMKNWdo5V5EXsUrt5L+aZlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6834
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 08:54:48AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-08-27 at 16:25 +0800, Yan Zhao wrote:
> > > +{
> > > +	struct kvm_page_fault fault = {
> > > +		.addr = gfn_to_gpa(gfn),
> > > +		.error_code = PFERR_GUEST_FINAL_MASK |
> > > PFERR_PRIVATE_ACCESS,
> > > +		.prefetch = true,
> > > +		.is_tdp = true,
> > > +		.nx_huge_page_workaround_enabled =
> > > is_nx_huge_page_enabled(vcpu->kvm),
> > > +
> > > +		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
> > Looks the kvm_tdp_mmu_map_private_pfn() is only for initial memory mapping,
> > given that ".prefetch = true" and RET_PF_SPURIOUS is not a valid return value.
> 
> Hmm, what are you referring to regarding RET_PF_SPURIOUS?
If kvm_tdp_mmu_map_private_pfn() can also be invoked after initial memory
mapping stage, RET_PF_SPURIOUS is a valid return case.

But in this patch, only RET_PF_RETRY and RET_PF_FIXED are valid.
So, I think it's expected to be invoked only by initial memory mapping stage :)
 

