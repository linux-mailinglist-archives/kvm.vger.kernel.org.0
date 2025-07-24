Return-Path: <kvm+bounces-53410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B0FB113E5
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 00:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 499081CE4698
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 22:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D2D23C4F4;
	Thu, 24 Jul 2025 22:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GP4TwSw2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD1323ABB2;
	Thu, 24 Jul 2025 22:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753396202; cv=fail; b=fkv2Jmg4cGdmpqBM/XDc94I3IU6u3ZNgLBmbOKr1fq4nAogpzXi3FT2hdHQSDCmkrYhVd5XrCiBXwcWHPp3Xk3os7dg/0qTbPR9VwRRnfU2bMQtCQk92yFyw6SxsvFbXYICjgjKtw0qgAskxhs/+i0W6m1/lcewDmzrC13cAlxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753396202; c=relaxed/simple;
	bh=KtCCgSjT0RKQu8A9JSnj9GckBSmS2WHAXmGEN62RERE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LK1dZDFSPPO/E5rdsmDhK5lEgZgzkLIH2gecMQAbESi90L0IIVI0AEAVwHdR0LIXzIkZqs4hTPT1edoiNWEfLX1kAn+MUf7XdPS8iGOjAouogEsOdv8YohIPm06I6v8HrlcfX2mnbOXGBsSuzqi6tmuBriox1TWW5BONi3OPBFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GP4TwSw2; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753396201; x=1784932201;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KtCCgSjT0RKQu8A9JSnj9GckBSmS2WHAXmGEN62RERE=;
  b=GP4TwSw2ZKFtSbn5YXQ/o2tKD4pUD/5Ze8I2rHptitgGs3yWOqjya4BF
   67IMx4+H5w9huyTeZxpKrweZd7PNAHx6Et4xx7tmPbX2/nYd+nUgN/Gsa
   bxIC7d9MtFQS7jqu6GBrJ9wO7lyAR9J8Iq/nr7mUxURB81cYp7NklTib+
   AKlhl2H39HEPmUcjANdHwgkkhaigUcbau/D/YQ6b7fTzPZ8ND0hnBGc2F
   6/qKBePY6UhwDwnA1gNow3J2uJ59W+s8UTCIvJvFn1fP/+jOhini7F6s4
   mzu2nNybmU9ao4OIFCalrWuj04jd+G7tmCq5SR9re7aLuxpDZJHi8BCPA
   A==;
X-CSE-ConnectionGUID: Me3C39o4TACzg5z1PlhRGQ==
X-CSE-MsgGUID: CUZMCQ0DTEGz9zhXG6lupw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="58349634"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="58349634"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:29:54 -0700
X-CSE-ConnectionGUID: izxD/PBKSU6c6EtuUd0NwA==
X-CSE-MsgGUID: PYHfMFZuQHu79ZE5hyA3Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="164520514"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:29:54 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 15:29:53 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 15:29:53 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.57) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 24 Jul 2025 15:29:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W+2GxH2okhYQbjh5odFOsATJUOHXY3utaKDNM2Hl8PZe4zx+ncKefHVovtq4UYxjMGhGyarXI+gRSP1sHVAaqgqBPMPuHsPQ3dKJceU5hP5c2u+3IQqFW+quz7tqG6smSrldo2Yc3yRwcI/mPq5AEcyjJbLk2K2lb+0vuq01YDMNz8gO2+19L5Zj87ehLmRYJjetl6S/H6Fou38cc3TdeaMX41NUFwJSekdoASNSnYwgJIToIjDuoqRJebH7TMinar6Rjl07CFIn84YuJaX2TGYcKsU6dxPnavs87np2QHZw3/SBeiv1Z+bd/RyC3M6qPc4cFSCb/lZKP5AxRxIcqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtCCgSjT0RKQu8A9JSnj9GckBSmS2WHAXmGEN62RERE=;
 b=TTydX44OZ0+WBdK/FahrplsirDGjtiyLNb+kcoHwEUnJrn4iOvGkbg80fV4h1C3eN7rIrlVN3EUY+r2L5BT4OXBTfL1ap7kO4QbrUlzEuM9QKeOw15UBsViuZROwsCJ9CaC099XJr4dqjZ4l+UNbRQvwp5xxz8C82j871r7+zZhhOXMV1kDLWgIjcoaRqulJCa/RGK+CfN20lguI+bmOyQnUG1JvRrfFxblecZ83XVLYLWumSI/WNDk/XpA8yS/CF6g1Y7ERDnUXPRV406iPHwzOK5yv1u7GhvFlI0f+BANv7zwlxqivn9M90fa7K364D/PFjVzcS14hR1+9k02gOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7651.namprd11.prod.outlook.com (2603:10b6:8:149::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Thu, 24 Jul
 2025 22:29:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 22:29:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de"
	<bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH V6 0/3] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Topic: [PATCH V6 0/3] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Thread-Index: AQHb/Jt8pwMruFqQmki5OSGjKkoUmbRB27gA
Date: Thu, 24 Jul 2025 22:29:50 +0000
Message-ID: <f86ae5d16a57fb3e220f801b9e67bed909958b69.camel@intel.com>
References: <20250724130354.79392-1-adrian.hunter@intel.com>
In-Reply-To: <20250724130354.79392-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7651:EE_
x-ms-office365-filtering-correlation-id: dc42d1d2-d138-4e92-b845-08ddcb019adf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y1FqMnYzVWxWMFhKejY1ZkZYUGplbDV0OEE2UHo2aGNHTnVNMTRXYXhodTZh?=
 =?utf-8?B?Q3psNDFDYVhRR2o0aFV4RnBpU3E5dUlOVXkyYzVuMUlFTG1PekE1WnhpMnp0?=
 =?utf-8?B?YmZTQjJMQ1JzSHNtbSt3cFZ4WUZHTUVmM3lQT2IyQU9WejRzeG0wemR1NjBw?=
 =?utf-8?B?dHRySWg1VkttSXgxd0YxSitLMmNQcVdibHAxNmhZbTYrSkxBdE9qMVVHTkVa?=
 =?utf-8?B?U2hyRTZOejlhMXJSK1JINUN4WkJTaDRGNVdTc1dmZVRiZmkvRUovemwvanVB?=
 =?utf-8?B?UzlVTnhCNGVQYUpPME81SWVnbk9xVU1WbllscFlaeTVtRjVReUh4c3h1bWwy?=
 =?utf-8?B?QmVOQkFmN0hHT0IyUFF4TWhTazF2UEEwYTFOYkxaNkQ3SmpkK3JOd3hRTzlk?=
 =?utf-8?B?ZXNkRnpaRnhHbDJDaG1NNzFTNzI0aDUzZHRlbmVxbnd3TE9keHdLMFoydTRQ?=
 =?utf-8?B?djk0RDJyMElodDJJZXhsM2RacC9PQmJJTEkwTmZmR2k2NEFoQ2IwcjBEUHkr?=
 =?utf-8?B?MmhzQm9ES2NEVkN6dmQzYmwrYlNtUkxwVjNtbWRLZG1zSDBjVGU5a25lMjRO?=
 =?utf-8?B?OEVpaDBTWmt3RC9mL0lGWHlWaDhod3liT0RaU3VyNU5nSkFEdVoyS3BhUmpP?=
 =?utf-8?B?S1dNejVnVDJ0NEFuMi83ZWJXUStrSUEzRTJUVzZUVDFwdFZ2L0Z2V1hwblRo?=
 =?utf-8?B?R0FERk9LZExrMUhCdkFxWEhYbUhVL0g2a1dSb1BMTWpQRFhMcTB1VlBUMUhX?=
 =?utf-8?B?dUNzT243bjY5VXc3QnBaVTZ0SDBUb2FQcW12U29pMG5Qc3dUVjcvc1ZqbEha?=
 =?utf-8?B?NUtvNW5XMTZ5ZUQ0WnAvbTR4QWZqTVVTRnR6Q0dweEF3KzlJREFqaVU0ZXlk?=
 =?utf-8?B?L2grQisvdVJzN1BsaHRKUlF5WVBPZHQxenRTZ3Z2UmV0b2dqOTd2RWgwS2w5?=
 =?utf-8?B?TW5LSXZSTXJ2L08wL2phTFV3ckl6VEhYNG1oUWtDSUU3UkVHN1R1dnlPZEZR?=
 =?utf-8?B?a055SmdHdDh6S3owTDVLbmU2RlN5SHMvbUpubTVUTS9IWUtrNHhDclNPRnE5?=
 =?utf-8?B?L2NIY0U0ZkJObCtIcmVXNXU3SEMwTzMzSGFVbHZCdlc1TFBQZ1M2OCtqaUFm?=
 =?utf-8?B?MnpVamYvVWdQc1Eybkl5M3hUclNSRVpMcW1TS1d5WmEwSUNJZXRhWjNaRm12?=
 =?utf-8?B?VVFWdlh1d2t0TkRGRDU4bEpzR3B0NVQzK016dUJnd25BZnE3dmI2dS9hS0VJ?=
 =?utf-8?B?NHg2Mk9GUzFjZFcwSnhpVnFzUzh2U0hYdDVML20xN2xkcUlXVmcyelhtNzVN?=
 =?utf-8?B?UFM0eUUwdkxPZG55Rlg5WFNoVFZwcFQwN2FpRDdPa0FYczMxT1RkYmpTNHF3?=
 =?utf-8?B?ZngxaFNXZUVSenJoSHh3Z3p1TUVqVDJJUUVSWGI1Vnh6TEl0bjFzdENBYlBD?=
 =?utf-8?B?OHJjZXpVMTdpTy8ybzRPczdqa0RxQ2VxTENxcnNkZURiK01ndEpjN3lVYUlQ?=
 =?utf-8?B?TTdYTnpVcWpTb0JzcDFCSzBhekN4WHJtZHhiNDBhSnQxYkhVdmMvVnlPMHRT?=
 =?utf-8?B?SytDNG9rZnpaNjVnMHB5eWYwdXBvMDZhVWhBTXBlWFZjN2hET0VWTXFuUmpr?=
 =?utf-8?B?M251YW1oR1NudzVycWhFV0RPekM0ZHlTQVpPRzkzdjQvUVhBaVJoZVR3Njho?=
 =?utf-8?B?VHJOeHVyOVZtZGMvL043bXNHS3V6bTZIVnhCQ3VZMys2L0xJck4wTlNGRWZw?=
 =?utf-8?B?Zk82UXNEd3R6cERpUTlSSkdJTWF0bzlvOEtKemcxSk02NzFITk9CZXBnTXl0?=
 =?utf-8?B?SHNDT29rWk9pMWQzTVpJUzBUS2MvYTM4ei9hZlF0eG5XL0ZwOUpsd25XV0tM?=
 =?utf-8?B?allLZ3NNZ2FtTG5acndBVVBvbThFdlhlMFQwckI3dTBkV0RBVWZxWjIvK0FI?=
 =?utf-8?B?T3ErSTA3MDRkY2hJSzg1ekxHL2hXTnlZN05BYnFZK2c1WmM1TjljdUw4clk1?=
 =?utf-8?Q?ZYQyaBeefP7zVK5Akt4zQvF0rbr3jk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnJMNGxkeDEzOHhkZDAyQ05HWHB0WHoxVVNBdWpndXB3cGp5SjJ6VHhxWnBM?=
 =?utf-8?B?U3JWNFFCY3p4amdXVEVVSkZiM0Q0TnZDbGhqT2RiaVJWTTlRNlVoNTRJQUR6?=
 =?utf-8?B?MFJmWmRkQmZmMWxIUkxIWUtpYnl4L0t0aEw0eEFvRDYra01xMFNHaHJ2SDgx?=
 =?utf-8?B?QlZGaERQcGx0MDJrUldBSlFFVjFQSXhPMzJPQXpWUmJOaXNHZVowT1BUVy8w?=
 =?utf-8?B?bXZnUEl5UW9hWTZhVVB1WEU1MVNiWCtyQzcxVjV0dVZ4bytIU1hyRmFwbkwv?=
 =?utf-8?B?NTFQT08xRWhHZkRSQWxja0VZV0tBWTl5OTdyREI4UnJTMmtnVEpmaVFINlVD?=
 =?utf-8?B?VXRCUVFxN25aamV0aFIyNGhad3RHenV1REhHVGFKY29JL2szb2xHaVBYejNa?=
 =?utf-8?B?V1k0aUJ5Ly9TeVBMdXNCMGRwbCtVUXV4M2thQjF1MjIyZk5EdTA3ckRENDht?=
 =?utf-8?B?cG1FRE1IaEl6VCtWMmxpaVB1bmdNQUx5NlNyaSs5cTY3dHFqNFNUTkszSjRj?=
 =?utf-8?B?RDF1T3BhMmRPL2tUSU55T3FRakVnaTFqWS9HNE1pUmtUSTZ5a0J3UVE1bmlr?=
 =?utf-8?B?VVpoUGxuYXFpV2xsM3FyK201ajl5aG5LcTRTK2N1dm5rMnM0aHh3MFh6TTQr?=
 =?utf-8?B?M3NHeVdkWUJ3VS8wSVZic0c3QWpjUHVDenJ4QnR6bGtWeWtjUE55THRhbmZL?=
 =?utf-8?B?Zm5UbnNRbE1nS0Z0cVFpK1dJdFNTT0QrV3lzeHJzVTlPNzNsWm1ZOVpreEhC?=
 =?utf-8?B?Uk1EcmxLSTB3VUNqK3VkZU1ZZTg0ZE43cml2Y0VYdllWdUsvWndwMnY1aGIx?=
 =?utf-8?B?S29PTGNhN3k1MWZXeUZJV2d4UW0wZ0VYcmZaZlREYTQ4Z1pwb2hQUWg3Qmkx?=
 =?utf-8?B?aWFWUTdvRk85MnUrVU9Ldzdkd2NRNnpJN2NiSldpMkhsUzNRZFNhQndjekcz?=
 =?utf-8?B?L0VOQjV0VzBSVmIxSEtNUnNrak8yQ0hHbFFMWDI1emxpcUpkUlBDSjBXRWpt?=
 =?utf-8?B?a2g2VXFnb21VWDdTQ3BHTmRqMVZOVEdnT2ZDamtzajFBNXhZa1MvUGVsVHVU?=
 =?utf-8?B?cExXeHVqdDBqM243R29nSXdncFREMFp6Z1FwK3IxWFdNd3lOV1hLM05OdzBP?=
 =?utf-8?B?ZVJRZFFNcGZxNi93UEtZWU1IWHJ2dTd2VTVHbkF0elFQRkNQMnh1UnJKRHVZ?=
 =?utf-8?B?dXZzOWlFaE5uKzZXUzd1bFM1NndhTU9oRldwOW9WbzJXaVc2TTdDQVREVkdn?=
 =?utf-8?B?UDNxS0lTUnY2TUdUQXc2c0pKLzJld0lBeUFtVVdUWHJOY0M0UHZTaStmUFBC?=
 =?utf-8?B?bnVwbWJkZ1lNMmJLeWxvc2tBL0p6L24zc2FKZXA4anZDOXM1SUlISVdNMDEw?=
 =?utf-8?B?Qm9ldzY5UTlxN2wyVWdlTUttMFZGN0RkclEwaUwreHBXT0tJSmlnYlZPczJL?=
 =?utf-8?B?aTlaZEFZcTlIRVhLaHZmdlpkay9qblFvZFdmYVVXdHdVVkpyL3ZkSDU5VUNR?=
 =?utf-8?B?c0R2ZjBtbU9MbTd2TDI0VzRHR1VXSU9EQkIrTDNEUlNpMmpEWVJ4R3M2NzZz?=
 =?utf-8?B?ckxVQlk4bHpwd3RLMmdzZ0VRUWxNd2hkdExuZ3k4WFBnaU13eU1ab1p5L1Bl?=
 =?utf-8?B?R1N3VlhSV0ZDNFh6dDhQcGxHQlhROEFJOG5sQW82bGM4NzRnbUVVNzlkRTh5?=
 =?utf-8?B?NUNBakNyOGI0WFZXeEkrR0Zab2pTcHlNSzVJOHJSNDM0RmJlSHZhOTdQdEJq?=
 =?utf-8?B?L2xtT00vU1hOcmN0S0NWQUo1eHE4emFSWVdPNnk0OEZmdEFXUGcrbVozcGlv?=
 =?utf-8?B?bDhoREd4UHhiRVEyWVFuVVpaVS9acFNkblhLOHFFRXhZekJNaSszSTB3QWc0?=
 =?utf-8?B?RUVBVldEL2pTN1hMYWlXeEpJWnNVOEpJZ3V5QjZab3lXTXhPN2xqTmFoU0dZ?=
 =?utf-8?B?MFI1eHlnNnVRbktZZnRpa3JjaEpFNUVjVWxUVmpNVlNXWEh2Q3JVZEZWd1hx?=
 =?utf-8?B?WFBTb3loTWZuY1JQNmhnMVpKSFpYb1FOQmNRd0p4UUJQMVlkU0hMeVcyNVpJ?=
 =?utf-8?B?Tk9nb0RQVjgzMzBwWlgwNGZ1ZDFrUm5YcCtuVjdUUnFhVU9MYkRpNVJnUWE1?=
 =?utf-8?B?a1hFL3pTTmVyYmxCSTZoRTlOcTQyblhWY241dklPajc3K0hYWXNqQU9odG9O?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D024B60E3C548645899941DCB27BC234@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc42d1d2-d138-4e92-b845-08ddcb019adf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 22:29:50.9861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pC2W9HifMnMX5uG/PSgs6ESAAT5CLgh+w7QAt5HY1jPG1+YnzN9kVNpFhgBECDmlEIHeH6Yk72XbxYsEjcZgHv604UYNLwobXTnjB46gB3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7651
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTI0IGF0IDE2OjAzICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBBZHJpYW4gSHVudGVyICgzKToNCj4gwqDCoMKgwqDCoCB4ODYvdGR4OiBFbGltaW5hdGUgZHVw
bGljYXRlIGNvZGUgaW4gdGR4X2NsZWFyX3BhZ2UoKQ0KPiDCoMKgwqDCoMKgIHg4Ni90ZHg6IFRp
ZHkgcmVzZXRfcGFtdCBmdW5jdGlvbnMNCj4gwqDCoMKgwqDCoCB4ODYvdGR4OiBTa2lwIGNsZWFy
aW5nIHJlY2xhaW1lZCBwYWdlcyB1bmxlc3MgWDg2X0JVR19URFhfUFdfTUNFIGlzIHByZXNlbnQN
Cg0KVGhhbmtzIGZvciB0aGUgb3JkZXJpbmcuDQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21i
ZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

