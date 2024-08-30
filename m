Return-Path: <kvm+bounces-25515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A0C96611D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 686AF1C216CF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA4419992D;
	Fri, 30 Aug 2024 11:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K2aBoxhL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E6114EC41;
	Fri, 30 Aug 2024 11:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725019044; cv=fail; b=G0mvBlvVSSRYjcFQ/QLnbHoi5yTWSad+8kEsXu1aQZGjJvlqLr1eDYLfaUdgI40woUsB268Fp1LCKqRj1FwQmiStL61joQRA9v1lPZO20HBAghcE9+E9R6amoFunybeRip0gm/m9tCb6APcX9E2H0aublMH52FnZg/nGfQUS8lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725019044; c=relaxed/simple;
	bh=LbF5AfPx87cB2LMMYkL61vHg3rGR92gQpJMVA2K/1SM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=awPinPxxGbTXPC9oSJcf+cZDKbBcWBvzzaPSrP0lE5XY6sXo6TJTu974H3rUI4rlwq/IeVPanzoy798lkw9x7Qzpm3QDRC3zZDGqmT7DYV5ZRgJnRnQF6le2pOQKLF1mXX7eKTete40ic2/6UGHFGE/Pj9rXuJI7o8vVYD0ACSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K2aBoxhL; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725019043; x=1756555043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LbF5AfPx87cB2LMMYkL61vHg3rGR92gQpJMVA2K/1SM=;
  b=K2aBoxhLe5tSU9YDzqFIJdP2PzxvR4vOzh8mFRFpICyKUu5DWfMSEQHm
   G5MUrmv/7EyHWdWO9fjZ5AV2rOkYUisgc15SSqU5hJ7uPSXr2jfhexrL6
   uhJlUnD+frhdhi9VBNuxxi31T9wtwhUPTFjFDkgW2A4fQQgr6lr4xZjvT
   5jMwqu8M/h3dGaChXLX7AXG1DXjYlBFW8ZCqgD6q7XfybdLolcfuRHryo
   lvJETtgZZmU8tfpKwn261feS0INaQ14QbszvP3G4mvm/HQUhsxENakaLD
   LExdo5801iMZIa9/J9CkFOI8rtYEXW2V56RVMiLEuutcshN6PrRMlTsi2
   g==;
X-CSE-ConnectionGUID: 3ydXzIYbSGausPP9V0oA2A==
X-CSE-MsgGUID: ETYLm/8TS56WWU6pTLZwOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23173615"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23173615"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:57:22 -0700
X-CSE-ConnectionGUID: 50hvgH3zRwWA3F4nm43JZg==
X-CSE-MsgGUID: sQZScd6sRsCbut051a3jcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="87120284"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 04:57:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 04:57:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 04:57:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 04:57:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 04:57:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DLYTBallDPDh+NCQwwnKj7SSUxsVQSZ9VaujzpGrvMEZQ68zZRnLfBvpkC9sQQKFdxciWzkkUP0MhKdUIAQIDYgj1jCYoFxRA9zWf/OPRno55O6AJwaC1iJjbEbLTL/mlAPOnPQHYgVgAU9Ry003E/OQXcSuZe/TfvvN21A+nwfqjl4ot9px2OQ79xbv+I03yVtBRPJpUVZFlK0MN0Twg9h2ppR3bNuqesg85Av0Y+RhDxXXbTri5IuBPLr928PE73AKSr8CAf0VVCoI9iR8N7KsphWDswiAYhAaZ4x8S+RhW8jtkhJjzY+biWQgf28MtbiVwClekiWdv+0Px/EIKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LbF5AfPx87cB2LMMYkL61vHg3rGR92gQpJMVA2K/1SM=;
 b=NGI+2ePslDeklSiQAMY5sslyvkJ05UgyPSqdYuebcBLvQw1CmCgElU5180VyvBU6ZC9EYgJv79/8pWR8iJeIyg3x0F97ymC+gKmHXMG+61ni3h60jgx6PIMgfHHCyxNgl0CsDw/u76lE9uMNI2boKgkNRadtlOvvdwRu9lokp8rgbKJBNWYBmMQVLbEdbr9dqy/GNx1B4UsVBkdJiYwxnlc+CPiNuIrIhHKg/SpiIicamE4i9EokdCw9DHJgMcMZsdva0RiNawK4niBjdhNByHYFC7TBS6B3IKQ0C6eQivRpdDPYGQHktkJQ37Y8Eq488zDULxMyrU1uKmYG0tn4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7872.namprd11.prod.outlook.com (2603:10b6:208:3fe::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 11:57:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 11:57:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 5/8] x86/virt/tdx: Start to track all global metadata
 in one structure
Thread-Topic: [PATCH v3 5/8] x86/virt/tdx: Start to track all global metadata
 in one structure
Thread-Index: AQHa+E/ztH1XiJgYrk6z/1dEW3k+47I/p16AgAAPhgA=
Date: Fri, 30 Aug 2024 11:57:18 +0000
Message-ID: <d976bfa87b7c608ebaf1a209952d6ac0020d8470.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <994a0df50534c404d1b243a95067860fc296172a.1724741926.git.kai.huang@intel.com>
	 <412ea31c-5edb-4985-9bc5-3e3f628d4945@suse.com>
In-Reply-To: <412ea31c-5edb-4985-9bc5-3e3f628d4945@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7872:EE_
x-ms-office365-filtering-correlation-id: 0dac912f-3589-46af-4fb9-08dcc8eae626
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bUw5dXhsU3dvTS8zZndyTXJpSE9wcTVOaXJ3UTZua1NVY1VJZUlieVA1dEYw?=
 =?utf-8?B?WFFWMTgyVnIzSHZXcnpUcDgwUlNhWFRiR2tYMVZVdEtvZXY0ZGZ4K1FxNVZI?=
 =?utf-8?B?V042YklJWGtjRjVkZVh5dXlpV0J3aG04N3E3NDR1di9OUUtFSEJFSllldG5u?=
 =?utf-8?B?Q2VoUU5tN2RJanVKemh0NnBMOHB0WTlSVGtoRzBHSHhvQXFHVW5vMCt4ZzNR?=
 =?utf-8?B?Z3FCK2J3eTVHM0FpeWlQYkF1eTVWbUh5Ym81YmxLYmJNVGNrWWJUUFl2c0hI?=
 =?utf-8?B?TWdkSldQUm9UN05GRW55aGY3S2prL1Q4d0R3TjVSTUljbUcvdVZKbi92b2F6?=
 =?utf-8?B?UUZCd0ZWZmpBTnFMLyt5WWdtOHNuS2toNmtOMk9EYVdhUmlsaGVZTmZNTlFx?=
 =?utf-8?B?VU1zU1ViekVCaklrSlgzUkV4V1hDQitING85V3k2a1p0enJEVXJwcVdUSXNJ?=
 =?utf-8?B?MldMdEdyRWlZU3Zqc3ZwMUNOL2htTVVNT2JGUVBEV3lBR0krZHFwVmppZnd6?=
 =?utf-8?B?eG1Bd2JQQlRjVWovVXZRRUdNUkZBRDRpbS9iQ01IcWJsYUU5c01MWVB6b0pX?=
 =?utf-8?B?Nng3K0gvdFVQOGdBUk5ZL0lUNzF2alIxYmcvZEZVNzQ2ZG5FTUFDNW1YVi80?=
 =?utf-8?B?ZVdPTVA4WTJSc3UyRXZBV0lQdzZGa05pY2U0MXZsbUt3U2svbTB4RkJCbGFY?=
 =?utf-8?B?Z1UzZWFNd1ZSZHNZYUJ3OGY4Z3dnMU1BVnQzSFptOXk0U0kwWlducTdGK2lp?=
 =?utf-8?B?bjVjbjV1WkxhdzhYTTVpMWZGanpYSzVVUk1tcW1zNnZBdUNzMkgzSnUwQSs4?=
 =?utf-8?B?blNOSk5kUVNxeUdJYVV6ZkdpOGM3azRsNDlvZ0hTTGROa0pDYU5TYmlqcVVL?=
 =?utf-8?B?eldtMjBoYW1CdGlxcGNVUU94YkVWNGc0S0hGWUh1UjJramFJQUQ2WElZdEpM?=
 =?utf-8?B?bGdDa0FVRzBXR3dKeFJTNXRsdkxMVEV1L3lUc0UzMi93dGRqbWgvMTZYUzVU?=
 =?utf-8?B?NEcrQ3dxalJ5ZnV0SWNTMkJCdm5FN0V6WWt1WHJsZElyNXlSMmk2RzhOOFhP?=
 =?utf-8?B?Sm10TW1PVTlHeXhLVFpsdWNrYUZ6VWJSUVdrQ0xhRXhESXNkQW5aYmcwTkNz?=
 =?utf-8?B?QkZLVGR5MGxvcXJiaUlEK1RCUHZKdWNra3pPNU84bXVGbURhNDQzREZBQnRG?=
 =?utf-8?B?TWdTWjlDR2NKL0VMa1FFOVRKakdyaUl1MkQ2Skd3MC9FaktodXFkTFRkMGJv?=
 =?utf-8?B?WTdiU09ZSkhhSUN3MTV4Uk1NMys4T0t2eWdReUhWdnFNaUZESjg2WTVEa3Bx?=
 =?utf-8?B?MTlHQWJNenNvc2Q4NVdnejBQMllFajhHTlR4dmZrd1p1aEN1cHJpTmkxYWJm?=
 =?utf-8?B?QlV5dUx4MkxMNm1tQXRSOTdFQnFTMDNQbGlqYSsxL0wxSm9iVGdJNWcySVN6?=
 =?utf-8?B?TFlvejNxSnR0T3NraW5RcmQ2TWwxSEpoNVM2dHQ2cDJrSXJTVnlrSjlwbDRR?=
 =?utf-8?B?VUM5Ti9YMEtHSHRoVnFVd3hyQXBMeHZ3bmxPcFNIREVRL1JBZjNlcEU3Q1l0?=
 =?utf-8?B?cEw5dXU4OEFaQnNyZGJFNkJxZEhpcHdXZjZTdEN4MS9VMHhERmN3QnVjbERj?=
 =?utf-8?B?U3JFZ1pmalRleGplTGJ2VXRwWTNVRmtDek5EYlllaGJqTkdBaUEwWFZkS1hn?=
 =?utf-8?B?bEpsV1ppUzhWcGhaYjNZVjRjS3E1L1hXNS9rTWRoK1RrRjNFQ0J6MGxGVEJk?=
 =?utf-8?B?UlFCM2pKRWpGVGcrT25RY0dWcUpvbHR1RDdmWnluckNpaWJ4NUFWR3pBbVdp?=
 =?utf-8?B?a05ucE94RENqYkhIUnVvNHFibzFaVi9GQ0xiM2h3Y0VUSml4ZXB4aVF1R0lV?=
 =?utf-8?B?cVRiK0RiVGJubG5zM0ZMQmo1ZkNaR3c4VmxsRmZpUDV3VlFGcGNVY3QxWk1U?=
 =?utf-8?Q?eDgQrWbVHoM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVorSm5Idkx3eUVZYlRTUFNmTTRSMk5xdnZwVml1NnVkV2hFOTJaSHlCRTdT?=
 =?utf-8?B?eS9iQ0NheUpsQ1BtRHRRU0Q0ZDY1SzJ6b1ZETnZuK3ZuNmJreUtJZHI0SWdk?=
 =?utf-8?B?azAxUFNsSkt2QVhadjNiYVlJRWkvTFg4T00rKzRySUJMMExLUzJ5UTFGMkhp?=
 =?utf-8?B?NE1PMGMxV3pHdEhQYTBoQ3ZmTENPMHM3TmE1ZTUyMnRaMHlTTnJNdUNuYWpN?=
 =?utf-8?B?S1ZCd0djNWMzVHhjUll3eXh1dXdDSjdPTm9YbXVHNEhDT1RCaTJpOSt6aFJa?=
 =?utf-8?B?Z1Z1ZmtXUFBWMmZ2WWwrMVc2MG0zc1dJWVJMVHJnSFNnUjB2L2t5QjlrTWN1?=
 =?utf-8?B?N1R0RWRFZ1V3TThVUGVxZzVtR1R2VFhmSlJHQy8xTlh2bjRiMW9GTGM3R0xp?=
 =?utf-8?B?NGlCMVM5NERybmU2VCtTeU9JMEp1Y2JtLzhlTzJVb0dtVmVhZlRBRHlDMGFj?=
 =?utf-8?B?d1F5Tm9oalBBTFJtT0Z0ZHFOM0oyVUdpaEF6bE5qMmNRdjh3M2x5QmY4SE1Z?=
 =?utf-8?B?WTN2VWUxNU9Kb1pNcnd5VWlIMXd0V054T0lMOGVUY1JPSlk0T0h2cC9TdzBz?=
 =?utf-8?B?M3d3bUk2bUZqaGhudkg5dTFSeVlFRmNkQWJkQ1AzWmY3d04xbmIwSlNJUStC?=
 =?utf-8?B?RkZQVFJWNG8vcC9EU1dZRC84ZENyQU9Fc2VSNVFhTXhrdkxKZERtOVhzYUJ1?=
 =?utf-8?B?QmFqL0piUDdMZHZiUk9ONVh1UjQyYUh4dU9lZ1gvU3A5VVNZT3JZWTZMRitP?=
 =?utf-8?B?L0xFVGdwTFJRMHkwUS9TaEg3RlMyam14UXBqWVdwU2tBeVZsNUhQdVFlL2lQ?=
 =?utf-8?B?VksvYVNMeWdzR1hQMnM2Z1pidzI2U0VXZzVKUzR6K2xSUDQwQlcwYnYweHQ1?=
 =?utf-8?B?eUVqTjloT0xmZFh3N3Z5OVFkaWJnWkpBMXBYd3FLQlZtWldEamZzS3U5RVRH?=
 =?utf-8?B?ZzNDN2RveTZVS2VQQ3NCVW1OMVpKN3ZYdFRUSVpyeWN3YnB6eUd3SGRTMzlp?=
 =?utf-8?B?YTM0c2hrWWlTUTQva3BFOUZwTVR1M3ZYODBNK1VKR0NjRE9wTUVyK0JCZlhR?=
 =?utf-8?B?ckVOVmxibDlhNTg0djlQYStGZmFNbGpYbFNOc2lxQ2luWE9tYm5tSGxvaU5P?=
 =?utf-8?B?dFJxYW4raUZRd0oveHdQSEJaaTRCc1NQaGJ2NDRlbXV3cCt5TVRoQWxFNVJC?=
 =?utf-8?B?bFdFVys1UE1aTllvOWkvcS9aRC9SdEY0Z0lBbkhTNHNDWEN6eWliS1c5bHVO?=
 =?utf-8?B?NVVwSzdlQ0ZFOGJVM3NoYWJ1TUVMMFRYdGFPWnh4ZFpNMWc1aVk5YS84eDlu?=
 =?utf-8?B?WnRIb1RNdFZiUlk1eXdyOWtHMGlTbnh0WjI4MDBEZjQ3L1RNemJzSzd6SGJO?=
 =?utf-8?B?UXZhMExoMDJacWNjNTlhcTZocTFNcERMTFFWOGF0UWVxTGM5TE4zL1hoMXFH?=
 =?utf-8?B?c3gza0NHYUZBOTV6dU5pUGNKOTQvdTVnUmQyZCtpSlpqNXdpbEhOWnY4OXpU?=
 =?utf-8?B?ZW14TTBrOTNIdVpnRmRqS0tiZjFNSHhSMW5adzNvNmZOcXdZVk16d1RsOGwr?=
 =?utf-8?B?T1hyREJyYk9mNCttT2xqMll5YklReTBlTldQSEdOenNBK0gwcWFTVU9jYllL?=
 =?utf-8?B?OE5rVmxscjd1enFPRDZwdWR2NEZsU3J0K2gyQ0RaQ1A4TVBtenBVTkVSb21D?=
 =?utf-8?B?U2xGQUcvVzM4VERHQUVWamRIYVpPWXllbjZQTmF1WFhlRXNud1hEY1EzdFZh?=
 =?utf-8?B?N01FbEp0aWNxN083V2xDSUxCK1JtY0lZSlVzbzhza2xySzd4aFhXbXdwMUJa?=
 =?utf-8?B?ckcrYlc4YzVGNk9DRnhVZkZrZ1FLR2xabTE5NlJVa0tzYjNNcjFkSTZCRi9T?=
 =?utf-8?B?QjQ5NjY2RnFqWERHVEd5UEtIK1hPOGtPNE9XNVpjSVpDUi9ndjMxbUdiOE12?=
 =?utf-8?B?NVJZdUJlSFZtakdzMWMzcGNPeiswSGQxcjBvRmg1NUxSRHprcVFDd3A3eWc2?=
 =?utf-8?B?VE4wQldINnhUV2V4a2xqQlBHY3pOOWJqaVNuK2JyakNBSU5ScElLWnJESmNL?=
 =?utf-8?B?MWEvUFYxR3FKSUZLWTJlZUIvUHRRdjVTNVo5eVlidXY4eFpCZ1NBdlYyR2JQ?=
 =?utf-8?Q?MEHoaOqjNZRWCGjpX4niOU5BE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E3ECDFEF1FCC347BFF05AC540D675CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dac912f-3589-46af-4fb9-08dcc8eae626
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 11:57:18.8857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UZVOcvi/SQAb4eS3ewitZnSNCFjxiT5k1n+P1RxtrkyinWDXJ1uVpzxedH87FYt3q/aElJZiI8a3gj7tmEKHHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7872
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTMwIGF0IDE0OjAxICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAyNy4wOC4yNCDQsy4gMTA6MTQg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
VGhlIFREWCBtb2R1bGUgcHJvdmlkZXMgYSBzZXQgb2YgImdsb2JhbCBtZXRhZGF0YSBmaWVsZHMi
LiAgVGhleSByZXBvcnQNCj4gPiB0aGluZ3MgbGlrZSBURFggbW9kdWxlIHZlcnNpb24sIHN1cHBv
cnRlZCBmZWF0dXJlcywgYW5kIGZpZWxkcyByZWxhdGVkDQo+ID4gdG8gY3JlYXRlL3J1biBURFgg
Z3Vlc3RzIGFuZCBzbyBvbi4NCj4gPiANCj4gPiBDdXJyZW50bHkgdGhlIGtlcm5lbCBvbmx5IHJl
YWRzICJURCBNZW1vcnkgUmVnaW9uIiAoVERNUikgcmVsYXRlZCBmaWVsZHMNCj4gPiBmb3IgbW9k
dWxlIGluaXRpYWxpemF0aW9uLiAgVGhlcmUgYXJlIGltbWVkaWF0ZSBuZWVkcyB3aGljaCByZXF1
aXJlIHRoZQ0KPiA+IFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gdG8gcmVhZCBtb3JlIGdsb2Jh
bCBtZXRhZGF0YSBpbmNsdWRpbmcgbW9kdWxlDQo+ID4gdmVyc2lvbiwgc3VwcG9ydGVkIGZlYXR1
cmVzIGFuZCAiQ29udmVydGlibGUgTWVtb3J5IFJlZ2lvbnMiIChDTVJzKS4NCj4gPiANCj4gPiBB
bHNvLCBLVk0gd2lsbCBuZWVkIHRvIHJlYWQgbW9yZSBtZXRhZGF0YSBmaWVsZHMgdG8gc3VwcG9y
dCBiYXNlbGluZSBURFgNCj4gPiBndWVzdHMuICBJbiB0aGUgbG9uZ2VyIHRlcm0sIG90aGVyIFRE
WCBmZWF0dXJlcyBsaWtlIFREWCBDb25uZWN0ICh3aGljaA0KPiA+IHN1cHBvcnRzIGFzc2lnbmlu
ZyB0cnVzdGVkIElPIGRldmljZXMgdG8gVERYIGd1ZXN0KSBtYXkgYWxzbyByZXF1aXJlDQo+ID4g
b3RoZXIga2VybmVsIGNvbXBvbmVudHMgc3VjaCBhcyBwY2kvdnQtZCB0byBhY2Nlc3MgZ2xvYmFs
IG1ldGFkYXRhLg0KPiA+IA0KPiA+IFRvIG1lZXQgYWxsIHRob3NlIHJlcXVpcmVtZW50cywgdGhl
IGlkZWEgaXMgdGhlIFREWCBob3N0IGNvcmUta2VybmVsIHRvDQo+ID4gdG8gcHJvdmlkZSBhIGNl
bnRyYWxpemVkLCBjYW5vbmljYWwsIGFuZCByZWFkLW9ubHkgc3RydWN0dXJlIGZvciB0aGUNCj4g
PiBnbG9iYWwgbWV0YWRhdGEgdGhhdCBjb21lcyBvdXQgZnJvbSB0aGUgVERYIG1vZHVsZSBmb3Ig
YWxsIGtlcm5lbA0KPiA+IGNvbXBvbmVudHMgdG8gdXNlLg0KPiA+IA0KPiA+IEFzIHRoZSBmaXJz
dCBzdGVwLCBpbnRyb2R1Y2UgYSBuZXcgJ3N0cnVjdCB0ZHhfc3lzX2luZm8nIHRvIHRyYWNrIGFs
bA0KPiA+IGdsb2JhbCBtZXRhZGF0YSBmaWVsZHMuDQo+ID4gDQo+ID4gVERYIGNhdGVnb3JpZXMg
Z2xvYmFsIG1ldGFkYXRhIGZpZWxkcyBpbnRvIGRpZmZlcmVudCAiQ2xhc3MiZXMuICBFLmcuLA0K
PiA+IHRoZSBURE1SIHJlbGF0ZWQgZmllbGRzIGFyZSB1bmRlciBjbGFzcyAiVERNUiBJbmZvIi4g
IEluc3RlYWQgb2YgbWFraW5nDQo+ID4gJ3N0cnVjdCB0ZHhfc3lzX2luZm8nIGEgcGxhaW4gc3Ry
dWN0dXJlIHRvIGNvbnRhaW4gYWxsIG1ldGFkYXRhIGZpZWxkcywNCj4gPiBvcmdhbml6ZSB0aGVt
IGluIHNtYWxsZXIgc3RydWN0dXJlcyBiYXNlZCBvbiB0aGUgIkNsYXNzIi4NCj4gPiANCj4gPiBU
aGlzIGFsbG93cyB0aG9zZSBtZXRhZGF0YSBmaWVsZHMgdG8gYmUgdXNlZCBpbiBmaW5lciBncmFu
dWxhcml0eSB0aHVzDQo+ID4gbWFrZXMgdGhlIGNvZGUgbW9yZSBjbGVhci4gIEUuZy4sIHRoZSBj
b25zdHJ1Y3RfdGRtcigpIGNhbiBqdXN0IHRha2UgdGhlDQo+ID4gc3RydWN0dXJlIHdoaWNoIGNv
bnRhaW5zICJURE1SIEluZm8iIG1ldGFkYXRhIGZpZWxkcy4NCj4gPiANCj4gPiBBZGQgYSBuZXcg
ZnVuY3Rpb24gZ2V0X3RkeF9zeXNfaW5mbygpIGFzIHRoZSBwbGFjZWhvbGRlciB0byByZWFkIGFs
bA0KPiA+IG1ldGFkYXRhIGZpZWxkcywgYW5kIGNhbGwgaXQgYXQgdGhlIGJlZ2lubmluZyBvZiBp
bml0X3RkeF9tb2R1bGUoKS4gIEZvcg0KPiA+IG5vdyBpdCBvbmx5IGNhbGxzIGdldF90ZHhfc3lz
X2luZm9fdGRtcigpIHRvIHJlYWQgVERNUiByZWxhdGVkIGZpZWxkcy4NCj4gPiANCj4gPiBOb3Rl
IHRoZXJlIGlzIGEgZnVuY3Rpb25hbCBjaGFuZ2U6IGdldF90ZHhfc3lzX2luZm9fdGRtcigpIGlz
IG1vdmVkIGZyb20NCj4gPiBhZnRlciBidWlsZF90ZHhfbWVtbGlzdCgpIHRvIGJlZm9yZSBpdCwg
YnV0IGl0IGlzIGZpbmUgdG8gZG8gc28uDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogS2FpIEh1
YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IA0KPiA+IHYyIC0+IHYzOg0K
PiA+ICAgLSBTcGxpdCBvdXQgdGhlIHBhcnQgdG8gcmVuYW1lICdzdHJ1Y3QgdGR4X3RkbXJfc3lz
aW5mbycgdG8gJ3N0cnVjdA0KPiA+ICAgICB0ZHhfc3lzX2luZm9fdGRtcicuDQo+ID4gDQo+ID4g
DQo+ID4gLS0tDQo+ID4gICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCAxOSArKysrKysr
KysrKystLS0tLS0tDQo+ID4gICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggfCAzNiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0NCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwg
NDEgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
Yw0KPiA+IGluZGV4IDFjZDkwMzVjNzgzZi4uMjRlYjI4OWM4MGU4IDEwMDY0NA0KPiA+IC0tLSBh
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiA+IEBAIC0zMTgsNiArMzE4LDExIEBAIHN0YXRpYyBpbnQgZ2V0X3RkeF9z
eXNfaW5mb190ZG1yKHN0cnVjdCB0ZHhfc3lzX2luZm9fdGRtciAqc3lzaW5mb190ZG1yKQ0KPiA+
ICAgCXJldHVybiByZXQ7DQo+ID4gICB9DQo+ID4gICANCj4gPiArc3RhdGljIGludCBnZXRfdGR4
X3N5c19pbmZvKHN0cnVjdCB0ZHhfc3lzX2luZm8gKnN5c2luZm8pDQo+IA0KPiBBIG1vcmUgYXB0
IG5hbWUgZm9yIHRoaXMgZnVuY3Rpb24gd291bGQgYmUgaW5pdF90ZHhfc3lzX2luZm8sIGJlY2F1
c2UgaXQgDQo+IHdpbGwgYmUgZXhlY3V0ZWQgb25seSBvbmNlIGR1cmluZyBtb2R1bGUgaW5pdGlh
bGl6YXRpb24gYW5kIGl0J3MgcmVhbGx5IA0KPiBpbml0aWFsaXNpbmcgdGhvc2UgdmFsdWVzLg0K
PiANCj4gR2l2ZW4gaG93IGNvbXBsZXggVERYIHR1cm5zIG91dCB0byBiZSBpdCB3aWxsIGJlIGJl
c3QgaWYgb25lIG9mZiBpbml0IA0KPiBmdW5jdGlvbnMgYXJlIHByZWZpeGVkIHdpdGggJ2luaXRf
Jy4NCj4gDQoNClNpbmNlIHRoZSBmdW5jdGlvbiBpcyBvbmx5IGNhbGxlZCBvbmNlLCBJIGRvbid0
IHNlZSBiaWcgZGlmZmVyZW5jZSBiZXR3ZWVuDQpnZXRfeHgoKSB2cyBpbml0X3h4KCkuDQoNCklz
IGluaXRfeHgoKSBzbGlnaHRseSBiZXR0ZXI/ICBNYXliZS4gIEJ1dCB0byBtZSB3ZSBhcmUgbm90
IGF0IHRoYXQgcG9pbnQgdGhhdA0KZ2V0X3h4KCkgbmVlZHMgdG8gYmUgcmVuYW1lZC4NCg0KT25l
IHJlYXNvbiBJIGRvbid0IHdhbnQgdG8gZG8gc3VjaCBjaGFuZ2UgaXMgdGhlIGN1cnJlbnQgdXBz
dHJlYW0gY29kZSBpcw0KYWxyZWFkeSB1c2luZyBnZXRfdGR4X3RkbXJfc3lzaW5mbygpLiAgSSBk
b24ndCB3YW50IHRvIHJlbmFtZSB1c2luZyBpbml0X3h4KCkuDQo=

