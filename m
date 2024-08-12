Return-Path: <kvm+bounces-23855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAC394EF40
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F611B23FB0
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6030F17E47A;
	Mon, 12 Aug 2024 14:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NRUWQd8f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1D033C5;
	Mon, 12 Aug 2024 14:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472021; cv=fail; b=rRwiNhAOl6YV414VMQOzfhB9qLLAvLfwz0gkbEnt2JzXDUH32N95paR2TAxmO+hpxQeQf1e4e36U2ctpnO/MzqIayLGjeXduF/3fGwlDwsXfXaTjWIsKcwMmhGJFwMZWq9OF3qJQQncFWfRQV8ptolRf6pKNXrsOIruiCq5VNeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472021; c=relaxed/simple;
	bh=eAIkemGwtqUnTcHTbo0jnAOwLQECDTmPThz6/509TjM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jPLpBNwfpDZJh1xF4AQj3sMnK2SeeopeQx3tR5UUqFgbSZJ6Bqrx2icLYo1mkENTTthVpUoBXdF7CC96VG5Se85avAsYLozWvUKlc4RlMrNi1WDwQHSQMrzaWS3c2FzNWmmQMoLrhG2STEtn4hgMXiE/2f/W6nKAQDEaEgVsv6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NRUWQd8f; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723472020; x=1755008020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eAIkemGwtqUnTcHTbo0jnAOwLQECDTmPThz6/509TjM=;
  b=NRUWQd8fCSmh0uwwuAwLVxvqA96EQQKt+KT91czuJMMktAGmLneBC3Fo
   wp8QDgfjavE/u1xiSPng19E2xdDGwAW6boIwGpuPhlTgCxYE9NKlIKiOH
   i0xJafwfMf9tTjZqDJkRf7kjzoVQ5saeifjFkRpEZDyf19o3qO6fJE/5k
   rEwoyoMLStQdtdEIBDoQPX3QnABYGwYea5iYGaAEpz7HJnMhUWCK8zKlI
   9ccMjeRuz1gkIB9OoWIB9wgKc4QcQTm5qzLGbx5bL7Q9eVVQLXY315xz3
   RrpYjO+cAIX3lQArWKvZmaCVZigB/vjbfRGSdfxruTf8GldkdUywJ3MaI
   w==;
X-CSE-ConnectionGUID: A8xRfX4CRXy8f9irw9jObg==
X-CSE-MsgGUID: xwCe1oQvQHyDab/psWwwTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21443585"
X-IronPort-AV: E=Sophos;i="6.09,283,1716274800"; 
   d="scan'208";a="21443585"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 07:12:33 -0700
X-CSE-ConnectionGUID: /Wd3hcVRSt2NZKfRRoPthA==
X-CSE-MsgGUID: gB2RW2bhRauvESY03F4j7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,283,1716274800"; 
   d="scan'208";a="57923530"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 07:12:33 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 07:12:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 07:12:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 07:12:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITWAF/yk3/1Fu17d8tDiHg75mnfLRU0N6tao5wFRmWirKzn7VZZ2IjgwX0KconYcQBVj+IYlszSRcFe4zmWoNW1dtnlgVUiG2u/O1iWJgXmrEVHyx00ygqMTEI/X3Kuk+iFZEKZ6J1nX/dhudgdb6c7NkokvLfEc5qsOa900MQAWYD2z5PeO7UH/FJxikY51BV9ocNcJw9JNYEvSK9IH4qajktpCuqg+sKQyTQbZAPb+hG9PCW3G1KTt7CNiqWwlkcWKHdXNvCTm68pSYRobV0ClcKC0DiiC9dUUd11qrnxL+czDXdOQDQuXsKsXJzFwFUEhBEyEA2XnNtyf4qrwnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAIkemGwtqUnTcHTbo0jnAOwLQECDTmPThz6/509TjM=;
 b=GLGpKab1opDCCPJM5fA7oM3uMYbdb53kf6e0KJ0O6sC+wjvP6kni1EYPtATK5wwTUS3/7LPbo9RTgoqJStCQGe8Mv0LMMIv0epGfCAx+YROs7tlrO4PwQsz9hr5eMYIEQiE73JoiJFjIzm4udCkiBj3tKww6TUTr+Z195ZF3thJMw2lmenW8B28IMgh4GWJwE4dpWbAWyl7je/Q+GTz49ozzwCRUWxlYNPWTFK+NgiNqe6D9i5r4jVkftKB2Vjav+1X51KkiQSXFkoBi6eCKUOCR0zTNaJa6AYglTKMjteqRqNQMS2NOHeeRvOkk4nvPl3Qf9epZoRcJ8lMzLwS6eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH7PR11MB5864.namprd11.prod.outlook.com (2603:10b6:510:136::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Mon, 12 Aug
 2024 14:12:29 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%3]) with mapi id 15.20.7828.030; Mon, 12 Aug 2024
 14:12:29 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: James Houghton <jthoughton@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, Axel Rasmussen
	<axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, "Anish
 Moorthy" <amoorthy@google.com>
Subject: RE: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
Thread-Index: AQHa5GRjQjpjZsmMrUu/bdIMjsA4ErIcE86AgADaINCAANTngIAAZhTAgAEsPoCAAJX0cA==
Date: Mon, 12 Aug 2024 14:12:29 +0000
Message-ID: <DS0PR11MB63734864431AD2783C229C57DC852@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240801224349.25325-1-seanjc@google.com>
 <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
 <DS0PR11MB63733F7AEC9B2E80A52C33D4DCB92@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CADrL8HWH3d2r12xWv+fYM5mfUnnavLBhHDhof0MwGKeroJHWHA@mail.gmail.com>
 <DS0PR11MB6373A1908092810E99F387F7DCBA2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZrZoQZEfTffvVT75@google.com>
In-Reply-To: <ZrZoQZEfTffvVT75@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH7PR11MB5864:EE_
x-ms-office365-filtering-correlation-id: 344f3ef2-1390-4d2d-3474-08dcbad8ccef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bmx6alpRd3BhRUNOOHR4Zi9vQ01zQ2l5dFNkd3dpSVZUSnhLbFdCUUNsT2VP?=
 =?utf-8?B?eFZxNUx6QWpUVXFTZzdYQ2l6dG1BWGxwRXMwWEZDclRRNXNPWU9ZVHlKSGtx?=
 =?utf-8?B?Z3R2bUFyNXlJamdrcjE3NjZEblZjdTRwMjJZRW9INk1HUDVkd2dYWmJZVzVa?=
 =?utf-8?B?WWRwV1g0SStLamdFbWZ5SWtnZGdTSkUxd1BTNGpFV3F3a200VlNUamprVFpH?=
 =?utf-8?B?NGVzekRxbDRreC93ZDR0L0ZuR1lxVk9TMFBFcHJCNURENVZpZUdaVHV5MjdZ?=
 =?utf-8?B?NG8rVlcveldFLy9EQXpCcXNhU3pOMENXdnNKYmhWWXBwaFVqOWVsTERrMWNs?=
 =?utf-8?B?akg4ZGh0NldPVER0RStkMEdaRjBIWm5EMDNKUWZ3YXpqSk42MElWY1hlbnBO?=
 =?utf-8?B?OXJiSkh3Z3dDLytUTHpCZ2ZZK243OWsvZVNIWlV2d2NwWk0xcndwZ0ZWYTJ0?=
 =?utf-8?B?L1pLZTRtc3g1L3ZaY0wyK3VzVkxlWkw4TWVZd2xLM0swektxNzdlang4Q29W?=
 =?utf-8?B?cncvOUhqSmxlYzBFSjBNL2hCT1MwbDhSYnpEZktkUjIwdE1JdkNsOVF3ZUtq?=
 =?utf-8?B?VjdZdy9OWEUyRDFLM0NOQ2NRbTMzaVFvYVQ3T1VJTVhzT2FKMkNjUzcxcjJC?=
 =?utf-8?B?a1JNL1ZUSk9iUkFVT0pxeEpYRjZnMmxrZGhJeFBOaDA2dllrQ0xHOHMzbUxX?=
 =?utf-8?B?NTNuZ0lobWpmTTNPUXpXNy8vbGU3VWRMUkppQStLSUQ3Wk4zWTNabndFSkVC?=
 =?utf-8?B?RytjT2dWUUJ6czV4dXozOXZjbjNWbENFZkVEQTE5RStVUjVqMnJ5SnN6NmRi?=
 =?utf-8?B?MjNaUUdPUE00dmNGVWU2VGNoTTh0QzFlYjZNOUdIMnU0aW4vczBLcS82YnBv?=
 =?utf-8?B?elpPNHZIak4zb1RpUjRzdjdScEhTQXpDWWQwbi9uM2o0Y3VUZzdUaXgxSTNP?=
 =?utf-8?B?N3l1M1g2Tlp2WU5mNVVrTnJBUWFNU1gvY3pTSDlRSlRLMmlvUEtPQndQVmMv?=
 =?utf-8?B?T28yb0J0bStXa1FOajl6ZWtNQXkwandINXhNNG5NOFh3UlVEbkc3ekU1VGdw?=
 =?utf-8?B?QXRCQmNFZUFOc3gxTmJhUE85aGdlUTduT3RSV0xMVXE5dXByNWdISmpRWjk1?=
 =?utf-8?B?dTRYOUE1YjdZM3hWa3VId0k5bVd6ZWlBN0Z4cDVrcDJlVk11WktubGZKTGQw?=
 =?utf-8?B?ZUxxczJTVUlSQ05xL3VWYWY4SW00dEpKVTdzNXRtOURHOE1LdGpua0oxQUFP?=
 =?utf-8?B?MnhUZVlIZDc3eTNrZ3lBOW9SQUNLU2REWnEvZWFIUEFPN3Z5cVp5NTFkdG1D?=
 =?utf-8?B?L0hQUzZoamNEVjYvUllMUVhmT0xQWno5TkU1Ym9mQXQ0M0luL1B6UmJPVG5R?=
 =?utf-8?B?NGxudEJoVHRsdEMxMWMvUHBaZncvMkllTmxJNjBDK2QyTU41QlZmdGNRWTAr?=
 =?utf-8?B?WWE2NWpRY0hRUUNIbmdhU2R4QS9EOVBnQnR2d0lnWkdabXJMTWMrZGNOalht?=
 =?utf-8?B?bnpDYmJtVXR4Qk9scURhZHpvVmFKZEJFVlZ0Qm0xdldZRjdKaURqMVBMWW9C?=
 =?utf-8?B?TzJUaEpYMDlvNW5KZGJFajlwOHN3YlEzdzh3Q242YWpUTW9BN2xZVC9LWE1t?=
 =?utf-8?B?T2g2VDNTWFFoVmg3b0VGTUQySlptVm51NWxHK0I0a0JDWUtqZytoUzMxUEtC?=
 =?utf-8?B?VUE4T3B0NTJWMmtCTFplR1kxaFVUa2tESnhiamFlOERMSTVLM2ZJMlpDK3Fi?=
 =?utf-8?B?bVFtRXpVbjNCRXlETGFDMWdVbm0yd2FSbkZtMGo2TWd4YUFPQTlMdjR1VkJW?=
 =?utf-8?B?dmZDTUx4UHphNnFaYmd5cTFpUW5oUkhEa3VXOU4rcTdma1ZYeU9RbUF3SUxG?=
 =?utf-8?B?alp6eUpjUXlKQURvV0ZOT2g1Y1J3aGFIS1lCeHg5cXU4MGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlUwY3ZXU0ZVTi9sRWxXekU1cHlid0gyb00vWXVleldKRnlRaVBmWW9JS2dJ?=
 =?utf-8?B?RHhEWlB6WW1mNUU3Rlg2a2dqN0xreE1SQWo5ZnQ1Y3B4aEpYMlNkN1JrUTJY?=
 =?utf-8?B?Y01VRFpLd25vNTZDUGVvMlRHMGdMUXdsaFE4ZlEya2ljM0F0RG1vSWl0dmxs?=
 =?utf-8?B?QndyOWUzbUFCd21IN2EyN1JMUmdRc1NJV29tNE9ZQ3Y2VjlzRGpBY2NrcDND?=
 =?utf-8?B?Q0xiN1crMk5ZeVl0ZzFsTzFuUmdjWjZnODMyei96UE01Z0hhQTdoajBoTDli?=
 =?utf-8?B?eDI0OGRmQ2dsSFdkRFpzeTZqZzBCL0lpbk5MeGhXVVRVMDVUU1dvZmRhUmxm?=
 =?utf-8?B?WC92NjhuamJaYmk2QitURmlQOGk1WFFxbkErSEw5cFF1VFpxcHd5Z0VxakVz?=
 =?utf-8?B?cC9abU8xdjdGNzlqaU9TQzFtR1NRTjFhVlpwQlQ4ejFxeEhoVDlWMWdvUytp?=
 =?utf-8?B?WGEyTldaajFYZGdzNzI4TUdDVFlvUEJCMVpsV1BYUjhQWnBxZHFZamxkaUI0?=
 =?utf-8?B?L2hpZWFBd21EdnhvUDFrYlAwNVdiWFVaWnByOVdoeXJ1YUxCM2V1bTJuQzBp?=
 =?utf-8?B?M09nY2djRmREOXBRa0hId2cyQWZhQkxjZCt3RkZLZE9VODk4cktqVmZNVFlC?=
 =?utf-8?B?VHBHYXhJazNPVkxKTEFORnVPTHpLekJ2Z3ZJeGV2RXlkR21XZHlnaWZjQmtN?=
 =?utf-8?B?Ym9iOERyTEFIOENTRlhqYkRRWHVER0tLYmdseG1JZ0xJeTdNWk9VdHFQRity?=
 =?utf-8?B?eFFUTmJ5VmhrSXg3OWFqRDF3d2Y0UzFmeFF2L1dtVGpKU0owT3NUN1hjK2Ro?=
 =?utf-8?B?TlU0L3NjbFZRRUl1aWlGcW10bGRpTlAvZzU1eDU2UVh3bnJuNWRmOXJyQUo5?=
 =?utf-8?B?RitHWFN1S2RKWmNnTzdyVnFZVWdnOGM1bGVXTVlHS2dZL0RtY0lxRlM5dUdn?=
 =?utf-8?B?YjBnZDI3MG5HTWVzSVB4bUxLVXdoakhsV0NBalpkMnBSL0s5c1lFZXdWdi9v?=
 =?utf-8?B?Mzh2ckdJVFhXRTlhQ2lERzJBYkpvQnIvbUNnUVpZd0tVWHhxeVRwWko3YkJi?=
 =?utf-8?B?WHdmMithUkZNOU5oUDNzM0w5bTdMR2srcHpoTzdZUXR0MnhzWDk2WkErTDRH?=
 =?utf-8?B?bUJXNDNvK0JhdE9xNHRLamMrRnVXbWxCUy9TejkweEZoY0IzWUFJeWFmdWht?=
 =?utf-8?B?MTlMTmdjK1hMN3VDczhNV25HZmk5blhyVVRLYUJOMllMeVFMbTBqbXhGQ2Nu?=
 =?utf-8?B?RTEvejhTcjRIQkJrb0NqdFZrSThGRFIrU2dNOFlOM0IwTUxpOXE5ZDZJbld1?=
 =?utf-8?B?elQ3dWt3U3k2YmxRa096WG9UK2piYWVyNXA0S2hGY2ZGUHk3cXA3M1U5NmYx?=
 =?utf-8?B?NWFXRjgxYXljTS9LNjFSRnR6em8xSHZSMTRibUhFMklNU1JuYktCS3JuaHI1?=
 =?utf-8?B?TnR6YU1kUEJlNko5NndOQ252TUlsNE1tV2xIUUNPS1d1WkJLcCtkWnNXMytW?=
 =?utf-8?B?YVhoWEVrVFZNRlBSOVFxSEFJVWVQdS9IbXlRZ2pJaWYvdnBvWGsraURQOW5u?=
 =?utf-8?B?d2VOakVJR2YzdlNPK1ZuNW14K3U3SVQwRklpdm9jTW1xR0YzSVo0SUJhalV0?=
 =?utf-8?B?eW40OTEzeW5ERjlXNkVwMldzODRkeDBxU2dOWElDSTFUTktHT1grSkwyTis2?=
 =?utf-8?B?MEFpNWVOcHFMYUNLZXB0LzRMUjd1cjVXNnZkSTZiSTBUZ25jbmdFMkFHZVgv?=
 =?utf-8?B?RWM3cnVZUWpVUHBlVnNDdGFpUW1OZGlGRUhKM3RVWTJGNFg0NTJQKzJjdDdC?=
 =?utf-8?B?enB6alg0c1ZOdEdqc2RCeTRPQUQ4dEVDN0JMMlZudnpjTjk3ZWRLZDVNaHBw?=
 =?utf-8?B?R1pBUHRaZE93V29admVyMGNhSm15SklucEZLUVVBdHVDbEZTSXBmSU9mdFVh?=
 =?utf-8?B?eVBCdWxOdjhEeHZGdlN1MkUxbzNTMVR3TE1aN0s3dFpTcktzTlNGR05ycUg4?=
 =?utf-8?B?TGNBS3dMWXhkQlhvaVN2RVFxQ0ZpcDdFcG5OM0hvZHFuY1JKTFZiL2FQanBR?=
 =?utf-8?B?TkVCaWtQNUpiNEc3eVVFZ2ZJUG9sL0Y3RDRISGRCMWpTN3YxVjBMVit2Vk4y?=
 =?utf-8?Q?YeW7mc8tFXv7ogYg+jVwc0j7s?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 344f3ef2-1390-4d2d-3474-08dcbad8ccef
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2024 14:12:29.3364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TDWPL/1IPjnjWgsxMkexrcZmuxkBESTxUdwrv8kmVcqd2Sf59kuyQoVRdgWijV0dWN5Ks8z8Te0tAuksHhM9mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5864
X-OriginatorOrg: intel.com

T24gU2F0dXJkYXksIEF1Z3VzdCAxMCwgMjAyNCAzOjA1IEFNLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOg0KPiBPbiBGcmksIEF1ZyAwOSwgMjAyNCwgV2VpIFcgV2FuZyB3cm90ZToNCj4gPiBP
biBGcmlkYXksIEF1Z3VzdCA5LCAyMDI0IDM6MDUgQU0sIEphbWVzIEhvdWdodG9uIHdyb3RlOg0K
PiA+ID4gT24gVGh1LCBBdWcgOCwgMjAyNCBhdCA1OjE14oCvQU0gV2FuZywgV2VpIFcgPHdlaS53
LndhbmdAaW50ZWwuY29tPg0KPiB3cm90ZToNCj4gPiBUaGVyZSBhbHNvIHNlZW1zIHRvIGJlIGEg
cmFjZSBjb25kaXRpb24gYmV0d2VlbiBLVk0gdXNlcmZhdWx0IGFuZA0KPiB1c2VyZmF1bHRmZC4N
Cj4gPiBGb3IgZXhhbXBsZSwgZ3Vlc3QgYWNjZXNzIHRvIGEgZ3Vlc3Qtc2hhcmVkIHBhZ2UgdHJp
Z2dlcnMgS1ZNDQo+ID4gdXNlcmZhdWx0IHRvIHVzZXJzcGFjZSB3aGlsZSB2aG9zdCAob3IgS1ZN
KSBjb3VsZCBhY2Nlc3MgdG8gdGhlIHNhbWUNCj4gPiBwYWdlIGR1cmluZyB0aGUgd2luZG93IHRo
YXQgS1ZNIHVzZXJmYXVsdCBpcyBoYW5kbGluZyB0aGUgcGFnZSwgdGhlbg0KPiA+IHRoZXJlIHdp
bGwgYmUgdHdvIHNpbXVsdGFuZW91cyBmYXVsdHMgb24gdGhlIHNhbWUgcGFnZS4NCj4gPiBJJ20g
dGhpbmtpbmcgaG93IHdvdWxkIHRoaXMgY2FzZSBiZSBoYW5kbGVkPyAobGVhdmluZyBpdCB0byB1
c2Vyc3BhY2UNCj4gPiB0byBkZXRlY3QgYW5kIGhhbmRsZSBzdWNoIGNhc2VzIHdvdWxkIGJlIGFu
IGNvbXBsZXgpDQo+IA0KPiBVc2Vyc3BhY2UgaXMgZ29pbmcgdG8gaGF2ZSB0byBoYW5kbGUgcmFj
aW5nICJmYXVsdHMiIG5vIG1hdHRlciB3aGF0LCBlLmcuIGlmDQo+IG11bHRpcGxlIHZDUFVzIGhp
dCB0aGUgc2FtZSBmYXVsdCBhbmQgZXhpdCBhdCB0aGUgc2FtZSB0aW1lLiAgSSBkb24ndCB0aGlu
ayBpdCdsbA0KPiBiZSB0b28gY29tcGxleCB0byBkZXRlY3Qgc3B1cmlvdXMvZml4ZWQgZmF1bHRz
IGFuZCByZXRyeS4NCg0KWWVzLCB0aGUgY2FzZSBvZiBtdWx0aXBsZSB2Q1BVcyBoaXR0aW5nIHRo
ZSBzYW1lIGZhdWx0IHNob3VsZG4ndCBiZSBkaWZmaWN1bHQNCnRvIGhhbmRsZSBhcyB0aGV5IGZh
bGwgaW50byB0aGUgc2FtZSBoYW5kbGluZyBwYXRoIChpLmUuLCBLVk0gdXNlcmZhdWx0KS4gQnV0
IGlmDQp2Q1BVcyBhbmQgdmhvc3QgaGl0IHRoZSBzYW1lIGZhdWx0cywgdGhlIHR3byB0eXBlcyBv
ZiBmYXVsdCBleGl0IChpLmUuLCBLVk0NCnVzZXJmYXVsdCBhbmQgdXNlcmZhdWx0ZmQpIHdpbGwg
b2NjdXIgYXQgdGhlIHNhbWUgdGltZSAoSUlVQywgdGhlIHZDUFUgYWNjZXNzDQp0cmlnZ2VycyBL
Vk0gdXNlcmZhdWx0IGFuZCB0aGUgdmhvc3QgYWNjZXNzIHRyaWdnZXJzIHVzZXJmYXVsdGZkKS4N
Cg0KU28sIHRoZSB1c2Vyc3BhY2UgVk1NIHdvdWxkIGJlIHJlcXVpcmVkIHRvIGNvb3JkaW5hdGUg
YmV0d2VlbiB0aGUgdHdvIHR5cGVzIG9mDQp1c2VyZmF1bHQuIEZvciBleGFtcGxlLCB3aGVuIHRo
ZSBwYWdlIGRhdGEgaXMgZmV0Y2hlZCBmcm9tIHRoZSBzb3VyY2UsIFZNTSBmaXJzdA0KbmVlZHMg
dG8gZGV0ZXJtaW5lIHdoZXRoZXIgdGhlIHBhZ2Ugc2hvdWxkIGJlIGluc3RhbGxlZCB2aWEgVUZG
RElPX0NPUFkgKGZvciB0aGUNCnVzZXJmYXVsdGZkIGNhc2UpIGFuZC9vciB0aGUgbmV3IHVBUEks
IHNheSBLVk1fVVNFUkZBVUxUX0NPUFkgKGZvciB0aGUgS1ZNDQp1c2VyZmF1bHQgY2FzZSkuDQoN
CkluIHRoZSBleGFtcGxlIGFib3ZlLCBib3RoIFVGRkRJT19DT1BZIGFuZCBLVk1fVVNFUkZBVUxU
X0NPUFkgbmVlZCB0byBiZQ0KaW52b2tlZCwgZS5nLjoNCiMxIGludm9rZSBLVk1fVVNFUkZBVUxU
X0NPUFkNCiMyIGludm9rZSBVRkZESU9fQ09QWQ0KDQpUaGlzIHJlcXVpcmVzIHRoYXQgVUZGRElP
X0NPUFkgZG9lcyBub3QgY29uZmxpY3Qgd2l0aCBLVk1fVVNFUkZBVUxUX0NPUFkuIEN1cnJlbnQN
ClVGRkRJT19DT1BZIHdpbGwgZmFpbCAodGh1cyBub3Qgd2FraW5nIHVwIHRoZSB0aHJlYWRzIG9u
IHRoZSB3YWl0cSkgd2hlbiBpdCBmYWlscyB0bw0KaW5zdGFsbCB0aGUgUFRFIGludG8gdGhlIHBh
Z2UgdGFibGUgKGluIHRoZSBhYm92ZSBleGFtcGxlIHRoZSBQVEUgaGFzIGFscmVhZHkgYmVlbg0K
aW5zdGFsbGVkIGludG8gdGhlIHBhZ2UgdGFibGUgYnkgS1ZNX1VTRVJGQVVMVF9DT1BZIGF0ICMx
KS4NCg==

