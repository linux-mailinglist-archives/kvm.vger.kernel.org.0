Return-Path: <kvm+bounces-73206-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YJ3GMZeAq2mwdgEAu9opvQ
	(envelope-from <kvm+bounces-73206-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:34:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 34054229618
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E706D30B4820
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327F12ED872;
	Sat,  7 Mar 2026 01:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nlDoKNJq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496F824A078;
	Sat,  7 Mar 2026 01:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847157; cv=fail; b=EO+c8eHQB5mriO/rWXsiZQFBcPcpiS8Ah4UOLYP17Vj5wgQM/gZsbdwWV/kz0dqa9QPiJ1hwB+AJKXbgauOFnUUwPqTmzpD5lHMp5zgrppC4UIh/IvpgnIYkPrZtFb+xvq6+aUYnAdd1cK6/Vc0FRfHz1bZOvFQzS+0VVzIAHLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847157; c=relaxed/simple;
	bh=t7eyEk/bK+dHjKfN5eKhWKQbmk0QGsNYs59KqrXMyhQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qjumWKJLGVdpYPtDIxN6bJFmjAqjX4rPmCrT9UVk0eV2V2OR4lLCiwZNstJHJUKik/1nZrEEg4SNwHwnr0gwfldC+iCK6Y6SWwqD2BIFabDqutnanykRHf+ZDiIvOi/EyVvtUfOzQZJ+bTZOXpUPtFeEgKY2yTb/ErhRvGKDBAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nlDoKNJq; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772847156; x=1804383156;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t7eyEk/bK+dHjKfN5eKhWKQbmk0QGsNYs59KqrXMyhQ=;
  b=nlDoKNJq5GrNwB35oprJw/e8IPCOnRM0e7JGW4iZsQlJNl2qGeHgzOjZ
   PVNCj9qQRaP2zWfnm6wkmceDFx6B/ICmWGq5OlIfRQ1zEIV1tz9eCTtyE
   e5oqlosZMhI6dyZ0nLeJoVOP3vdKEQ/W4p185YES9YySxGRX3o3tWfpxR
   zfni3QK9G3OsRLKeNnLWkcNrBzzcZhSKpr436A7ZMOxISffYZIqBjjuZg
   3FdQcitCFmrA73ovqJFq/ruM/8/c1mg8yuIw/rLOyyERY3hxNgC9+hvT3
   Dt4TZNyjgpMASUeUuIW51+8t3kO723uYm9cctUQlWIVW4mNACcYPHYnba
   Q==;
X-CSE-ConnectionGUID: S4rOl4hVQSOfhJU+8Ay98Q==
X-CSE-MsgGUID: 80UlijKjT0izDozgCLmEkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="77837982"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="77837982"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:32:36 -0800
X-CSE-ConnectionGUID: NMvveqxKTs6PxOrQ51zoaw==
X-CSE-MsgGUID: bzHBIIMoTPeQ3ZrAFRs/LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="221959720"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:32:35 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:32:34 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 17:32:34 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.62) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:32:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npGlqXM/ev+GcpqYtjYehVhM1uhtuHolpFq0fNHLF3AujQNh2RYmwD95QwtE0Y3aNwHSU3IDKuN5VPppxvUmK1y+ucfYYsh7rEgM2fyeabwTX32Ek3asqQyXo19usC9TLxyMs/GrGCGn6hpMUMN1eNo5N7ZSbcrGTcNgXMkPt9gpxPHAqgDKcOGqvl1VSytDeV+RrsaBoGpUdj0Nwu8pTYRZjWJD5B9e0nki9I4Dh+yw7JCe57Kj5QKPkldwSVMqXg/kTWI2NTbsXIlbPc3o3kI2auWKf6wyRSku1iK5SdyKUlWWKTQoIcU6WMSQJmUVlTo5H3EbhQoA6v6il3e2cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JD5kyvBtQwFmEBuWp2EcBDpDOBmg0AdsEYZX/+sJn8U=;
 b=oVcI/qtrRhAbnUtS92QMv2Q60V7sxYk9vjak2NMP0PE012npQBTMrty4kBxmeYPSDLcWweQbtaiF8LoG8KmybYAId3vaFtTCDO5Uv/s5J7miE0vzCwtglBWYHWIDSF9Jio7XpHl4eEyADVMk20ZMLSN7yLy8/13awWlZ15WdQQFx/j5qHbeTw8/4xH9iiTEeZUkgfLfyCmG/YXpbbNsn304IWCJAn0q62P5oW3XoURzTluyf7Rsb50M5O/39HTa4ZXnKi9w6w9yzVrz0J/Dm+jOL0p7w8iyIyp8OM0UvB3soxvtZRnNXo30rwKNpv/Br4ffqPcncgc+GBPMVBPEHEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS7PR11MB6040.namprd11.prod.outlook.com (2603:10b6:8:77::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.5; Sat, 7 Mar 2026 01:32:31 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84%3]) with mapi id 15.20.9700.003; Sat, 7 Mar 2026
 01:32:31 +0000
Message-ID: <c350c984-451f-46c1-afcb-e5e235aa308d@intel.com>
Date: Fri, 6 Mar 2026 17:32:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/16] KVM: x86: Implement accessors for extended GPRs
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <chao.gao@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
 <20260112235408.168200-4-chang.seok.bae@intel.com>
 <aajfW5k7H78FDHJC@google.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aajfW5k7H78FDHJC@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0111.namprd05.prod.outlook.com
 (2603:10b6:a03:334::26) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS7PR11MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: db2cacfe-b308-4a73-ec4b-08de7be966db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: IUlqj3ErWljw7+HE8E+OsfHdKu+BS4EcByXyetgHCUJIKiafS1ZJvGdfmeP30tvtKULzQRozWV24qC35EWOEzLHml3j02LhTIw8s7DGwaUUEGEA0Q3dQgFNQCeLqgsaoW6d1GpHDHeVTu1aFrTnJ6KWS7QyPnBE5uZYFE5jYN3Back8SQRdemaARtn2gunei9jbudfOVjxPSUK84mt1iV4NfiiVuX3LVxYPUO+wyM/yVmaefMpeUZ7OwX68SRAuZ+Ka4SKqjJFsqw0BolzYFO/5XRnjG68VgcA3R4KnVgV+xFO83A7wscfBpjrFgmGIYipxC+ldw9RlAfBc4xjbNG44BGNgJnE102fVEhDUuoeNLqwrocaDF3tZkgJsIBux0GQiPaKBJmyNUh4UdtskgpUFta6WaqHmPMkkf/d29vokt52cSgi5bmvPctVWrRHyWpHLsrzDaaIC+9mEzf9aivhy/N9Wu/+RGk6Ut404DpbPnCBE/z1kWcpylJ3G2HSZTAqXgGsQKjfIxdafIMwq5UhR2wFy8KVVrmSpAn4cCba+isP3cWlYbbMcuFX64dfv02WRlfGFmgDS0zLQrOo/OsZ4w7of8I48IC4aj5YpKyr5mGzqI+XyaFRCMVRmcj+vZCDIad4P+YWBM4aKfiD1jJAKEkC6b7qqDj2C31A0IHEnBSe88WYLAMQo9/7zsVWz0K62VzBIXaASFCGlflORWyRrnEBmZCAN1pY3QVYN3bFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0oySEVxbHVMT3hwYzk5WFZtcGJkcis3bzJyMWVSUjhsSG9vekY0WjlocWRK?=
 =?utf-8?B?dVl5elhGYS9RcVJ3MWFxZ25JWlJ1ZHlCbEZtc2U1OTJseHNGRThVVEMzZ0d1?=
 =?utf-8?B?bERYdXh5RVpVbXlSZG5OUjRGK0U1SU9LUXc0Q2FkWXJkVjJzTnljR09tYTNP?=
 =?utf-8?B?d0ZEVlJjKzNKMDdjUThLTkYzOGl6T2ZEeEVvVXNhamdXczlVK1dFQ2FMZmVq?=
 =?utf-8?B?UjkrWFI1eGFxZmRyVFE4a24zL21SREJhVVByNU1rQlpqOXN6dFdHa2ZicFh5?=
 =?utf-8?B?Y2NUM0FCLzFYeEZpL0ZFMzJTemVYaUpYdDd1WitTVDdWbUd2TGp1S1FYTGcx?=
 =?utf-8?B?MDFBR212ZXZPT3d2VDBzNzBvaWxBdEhFVU5ySm9YZ1V3K25Da1lXNXhldjRi?=
 =?utf-8?B?WjFOanZYamhCQU93WG91OUJPamtYK29WUU1UWENFbjc2S2EyMStTN0g3V3Fa?=
 =?utf-8?B?c2lEQUo5ckJlMllSY0Q3YmdKT0ltTHdpTFI3OERjVVBxYTB5ZzRhTUw1N0dU?=
 =?utf-8?B?UFYxbStiZXRMemxpMTVaa3JHbXJDcEUzTysvUHVYQjhEZEFkUjYzWVUyTW9W?=
 =?utf-8?B?YmZ4K1hFWlBhNUFyK2Rlai9UWXhoamxya2RYRC8zSnYzMXZvb2RUSWxJL3h0?=
 =?utf-8?B?T29qUTBPbllrbldISzErWnVsVVlZbFZCWW4vM1krSUpUS3YwQzhMcnkxY0Fw?=
 =?utf-8?B?L0JFdnJSYjYxcUgreEtPUlplTWIrN000NU4ySnhnN2pMczl6TkFLQ3dJbXFh?=
 =?utf-8?B?S09TT2Y3N0pGRmg4Y3U0WW1NazJ6cU8rNXFTWWpKa3l2R1JHNjU3SWc2RGdI?=
 =?utf-8?B?T1ZuS1lQVVlGMzJtQlpwYkJNYzFRalNoWmQwL1IwRnJaOFRNbkhiTENxSkpX?=
 =?utf-8?B?azJmdWpNOS9rNkFlbXF3dk5KN3NkclRJMTZHVWZMS3V5dUdWd1JMc2VyR1d6?=
 =?utf-8?B?OXpzaVAxdGw4V2ZIZ3ZrQkNqS2FNdkZUSDkyY2h3enlDZGlTTkdVZmNxallZ?=
 =?utf-8?B?N2t2L1NMMEg5OXo1b0xLMFFsZktiaEpHWTRWcUFaemtFalNoZUtpcU5hN3NP?=
 =?utf-8?B?c25oN3dCTFdFbkdNVmlnTk9BR3VSKzRGejJHQ3ZWRzFCbFpwNERHQU9UVUVH?=
 =?utf-8?B?cmx3REVlRE1DdWF0aFJDbHF0WkY2WUYydnB5ZElMSWYzRkw3S3huKytUVmhk?=
 =?utf-8?B?Mm83SjhCczFtUGViSDZSalMzU0FDZ3p4SnUwSmg3QTBOaTd2OGk2b0xPend0?=
 =?utf-8?B?dGV0MFRtVC9rcTE1SHB1SGRRQzV3NFMrS3lCRFFIVDZaNXRvQzFNdkVPYVJT?=
 =?utf-8?B?V3pmOC9mMGhPT04xMUlYWEhFRFNSUTc5OEJ1VmhCVWlHa242RlV2QzdKQ1o5?=
 =?utf-8?B?UmlZRGFvMXBNb3ZMLzdzVmNXbVZLTTU3R0lmRHJzUEJ6QkxPb2wwMzg4bml2?=
 =?utf-8?B?eFB0VHczRFE5eE41c2xHNXh4bXAySXptK1VVc0pWdzdxY053Ri9vRmV1Nm9n?=
 =?utf-8?B?alBKWGRablVrY1UrRE54WG1XZitONFphUjFYc2pjLzJYU2Q1dWx3MGJ3RlFs?=
 =?utf-8?B?VDd6LzlpM0dmU0Vab2Q5cmVJSGlWbmpYcmMwcFBBZnVZeTRnSHFxbmFSNXB3?=
 =?utf-8?B?aCsxU2JnUys3am4yelcrM0xWVlhaM0RSZEdXQlN6ZDNaT2JxV01uMTI0UWZi?=
 =?utf-8?B?WnM0N1dEeWNna3pzVjVVYVUwREJoY0lBSTZGVDA0YzF3UXZmT3pLTkxIM0g3?=
 =?utf-8?B?MUpFK1BMR29qbWxGQ0NFM2ZtaTJRcW55RndEcGpkdnJ0cFNWUE4ybDlTWmdZ?=
 =?utf-8?B?SGhqem9oM0pBbXJvMTlXUzlBdjRhdHc0SGtSK1paOWN0aGhXTjYybVV3OGp2?=
 =?utf-8?B?V1RyQ094NVJkUWZWajFlOVRuZysySDlrSFZtdjBnWC9qbVdNOXVBLzV6Zkxk?=
 =?utf-8?B?amo5THlUeWVrTU1pd1cyWlh5cE1qWjBwSVZ4ajJwQ2FRWlJJa0ltb25CRkNE?=
 =?utf-8?B?RllhSFlWbWsyd043c2tZaXJwd3hjd2JoWmIyeitxZlFXR0VwTVlQeWRHbUoy?=
 =?utf-8?B?aTQ1bHRNSUQ0dUl4SGRXVGY5dlRMSldVOVBTRDd1YmRHd0xVWTUvUWdTTFM2?=
 =?utf-8?B?OFkveEdJaWxnbGFmZHk1VUVhb0JFVWtsWEpqVStQSCs5NHBhMEtNMVprN1Yx?=
 =?utf-8?B?bmVuRzlQcis0NU9DVDFmVDJlS04zbkJyRDU5STg2SnZid1hDN20zNTNnYjhm?=
 =?utf-8?B?d0dIZnp5bTdCNXRyNGw1UEJCYTBTcWI5SmxMUlVxQWFCdHY3Q2Z4MVFldkFJ?=
 =?utf-8?B?TkV2K0ErNHdmZUk4WDZVd1NSZkxRNjRENkVtdW1zdFhnbjJCVHhjUT09?=
X-Exchange-RoutingPolicyChecked: FAD2aIOCnlx9eOGkraIT5heY3E3Ea0zocmNJLJ4p7pazuUXVdnDuVs7lKZ8KMiqivJp04mNKpGLFjBRWhbuYPoVdebydrG4EDN9c7alaI3lPFXRAr8JMR0vZ7z2+ZY/sFoWqxc5fxXuERYmfEnl6e0Zj7ZqPByRSMcBQVVWGFtWLTClCfhvzHnR3aKs/2GX62ZO4wjQcJh52n7b1C7YYNbZ9A8L6PW0W5qTcx0ECU3vrm0ClSSr/2iuXURwJwI+gLtjKnpx2SSQM5388ape/yH3XgkXmUz+0vLjwyJ4fmJ2lj9cZkXIPiq25pe1QH4lcDByBXpmKKkpALWRaVVQ2wg==
X-MS-Exchange-CrossTenant-Network-Message-Id: db2cacfe-b308-4a73-ec4b-08de7be966db
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 01:32:31.7715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrg6B+aipKnYMBuCiszvBI8E3aY5XppvD2ZnR6JHeb5P17l13vAwGx1Z8eUzFu7DIbJJYqsaGom0MxRhBXmJCts3EWufGRqqwqdjk4mcLG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6040
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 34054229618
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73206-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chang.seok.bae@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.975];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

On 3/4/2026 5:41 PM, Sean Christopherson wrote:
> 
> Oof, is this really the most effecient way to encode this?  I guess so since that's
> what all the SIMD instruction do, but ugh.

Perhaps, a macro that converts to a bytecode string, or a script. But I 
was not convinced that adds much value, so ended up with that.

