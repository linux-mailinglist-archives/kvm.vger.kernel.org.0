Return-Path: <kvm+bounces-33170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7629E5D35
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 18:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3242F1883D8E
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 17:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4588226ECA;
	Thu,  5 Dec 2024 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X3uzpXym"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300E821A42B;
	Thu,  5 Dec 2024 17:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733420011; cv=fail; b=HYhn1RlD4UQ4w9dn6cq1+Ca2hDAyHoqQaFQC4sblu2SxaN5OdSbjqZW090sGAezh0EMTdgTjigdg8NQ2p10WemgcPjwTQZxiDPNP2u5yqLdr+uHCO86aFilhAGjBum/i/PV3WBGdjkEbXIAQtFE4XfiDlhuAFgmNMeqV8GXnpPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733420011; c=relaxed/simple;
	bh=bQL+gxOV0jHdf0UNw+UmlryBqAWGEWUO7FSzhHypdWs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QMcHXJk8Y5qXXsXtFsc01mnEmG+4E9JiKIPhEkZSIzSqGnPkgFSbIRupa0h2lqS6NbRUhbuQ3Qx6/YbbGtpcMrveuYXVIPrnJZ6mFiSOqm25BncxW3J/oMaEAzfSHNkNkByehNBr9eE9P8+hGP0zJZjrzzbqhyqC294nrlH3aGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X3uzpXym; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733420010; x=1764956010;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bQL+gxOV0jHdf0UNw+UmlryBqAWGEWUO7FSzhHypdWs=;
  b=X3uzpXymSp284lx7Mf+d2qZWdTGpAR2mA/DeOOPPKATca8o8Z0HsvTHD
   M6RsXSx9vtftrwt70n6AQYOhyuh9Tat/CqWhY7v9rld1w5h3bZuhKiFhV
   yLAamfvtdJD242+E3A8eCl9mc49sCxiZ3te1ols9PHs2ZnlG5VJuM0Vy/
   on6JZWG4WoG81QK+TxLI/5I/MeyzBdqTKJUR3Q6VSy0jCbP8OpcpyJ5C9
   QMG0X0Mf0LqgJsiXLytVMc3ohOa6jKIRJijG9vODZxb5UAjBdksOLOutl
   dfn8sQvYNwmNLfBSgsdwQwtWOQooGRfIn5mloLiOOe5V1iqSJjWlcoKHy
   g==;
X-CSE-ConnectionGUID: uolYYgWHTRWxVoA8RFaFkw==
X-CSE-MsgGUID: q+Pd78tYScStOTurMsxO7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="45128464"
X-IronPort-AV: E=Sophos;i="6.12,211,1728975600"; 
   d="scan'208";a="45128464"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 09:33:29 -0800
X-CSE-ConnectionGUID: XzpJ8jrGQcKrgtKUHBTC5w==
X-CSE-MsgGUID: GRvOARrVSpm4s35U4FAQxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="99203123"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2024 09:33:28 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Dec 2024 09:33:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Dec 2024 09:33:28 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Dec 2024 09:33:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wxYOTuEn+yQFDGu2CM1HTOOcJw8Nd6CXryWqAmE0nv9jeVi2dTnzyTAwSuHyN8HPcuhTfh+ij1dfW5xmY/5k+XT2LRN/LIP10BC5M/a5bOTCF5cfAHNN2BFRCe20PaEodyWLQnV8gYJkZ9OeFcdTmmjTIGzd8dDGDiv9mim7vSa0s+EH7c4NKl9N4LrQzeCvtQVzNtsmX/6Zqal5IvLq2KNP5JqaxxwtHg2wdetjd7J2SbwpUcizq5P34ziOlOEipdvJdyg4SYdncJaYr0eq0C0uPY7vHl1KWUsSWm1wYomfBAFH3LvOHsEFUk5l8Sgw2QfCZOh8bpidhgtJchcmUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQL+gxOV0jHdf0UNw+UmlryBqAWGEWUO7FSzhHypdWs=;
 b=EPvemYXSQM+/5Zi4bVIgUImKVHn9tQA5S/9PeEKGU/Vj0XNlEhr42YdFZ66imfrOyQqf12e+QoVeZdftsSg+VfwQDqXeZ6xaMWOHgWYHWs8FUQhJ+VAdxhVx3S55i1SU5Kxe/WJVqmfnB1DMX1dgjiN0IxncXzwWtUbrHu6PFqzk4yBNpvT7YzA5GUp4C6l8Jcyt63TxAsrLRn8m9CxE7EwNaEQu1GFspuO4bF+4pordQ9knV8rmMq7u3Mf38Mzvp+h2dDKye9VsE+VKHGxORGPvBWY6slJg0RlN3RoorrNbiwzJ6IzowsB9jq020i7eZ4WJuINAvzMb/BzHNW3G3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5298.namprd11.prod.outlook.com (2603:10b6:610:bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 17:33:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 17:33:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v2 5/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 VM/vCPU field access
Thread-Topic: [RFC PATCH v2 5/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 VM/vCPU field access
Thread-Index: AQHbRR86Q+o9HIydfUmDba/ePwzm07LWg0KAgAFqDwA=
Date: Thu, 5 Dec 2024 17:33:23 +0000
Message-ID: <a93dbbb7f80d1e02fe811e8a00049a8ed37c9792.camel@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
	 <20241203010317.827803-6-rick.p.edgecombe@intel.com>
	 <0854fbf0-c885-4331-8e9d-30eaa557b266@intel.com>
In-Reply-To: <0854fbf0-c885-4331-8e9d-30eaa557b266@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5298:EE_
x-ms-office365-filtering-correlation-id: f97ac9ec-c0de-439c-9cb3-08dd1552eb48
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZWdXWml0MmxVUnoySEx4MiszQUozLzhlcko1RjlKWG12Y2wvZ1U0N1B5dk8y?=
 =?utf-8?B?dEJYMDRyZUF6RXdaTURXd0RuejRLWGh2L0p6Y3VXWFdyUnN6TnlqRGFnR012?=
 =?utf-8?B?eXlTV1hQbEtxRjRsa1VPKzcrRXpQTkFwZXFqN1J3V0lVeTk2UHhYMFVIL1Bn?=
 =?utf-8?B?SlNnbzVuOGhScXArYktFZ0xoWldrWEhtT2NOK053NEh5MHF2anVobkg0OHBk?=
 =?utf-8?B?RWJaRHdEa0w0dkFlY1JBUDF2bmZoYzl6d1FtRG1zTEVNNjZBS2lrQ0dBV3Zq?=
 =?utf-8?B?a2R4ZWNaenZxV3BtK3pWSGFWUGFBTGZpRkdXWHVFQUY4dno2SjRCejFqMkJH?=
 =?utf-8?B?VnhHWVQ4enhCQ004ODA3VFplc2pXaDNxd0FMSGJscWRqWjBqWDhUMjI1MFhu?=
 =?utf-8?B?Nnd2amd2L0lsYjJLdlZyNEFBdkdrV2drZzYzU3FueDBZWEErZEZsWEJEWXJD?=
 =?utf-8?B?Q1lFRXVOeVFETDRkTk9sbS9vbUQ2SVk5TUZvbVdWS21wRUhLaWROZ1pqR3Nn?=
 =?utf-8?B?Z1EyL1BqM2R2clU1UkFtNVA5TGROQTVXUDNyRTBiZnBDbDBxZVN6T1Q2Q3RU?=
 =?utf-8?B?MExScG5YZ01sc2JnbGhIZ3JuOVNjWmJ2M1p2M2ZLVjdWbEFENXk5Zk90OHA5?=
 =?utf-8?B?U2wyczRuMFF0SC93b2I0cU1vTDdGN01qdlkxOUpzUDdXTFNWaW1PQU9YSmg1?=
 =?utf-8?B?L1FWTkIrVXM4K0xMSSt3MGEyZlMwUnhPRmRjelhkZmUwZkhRelZsTjVjTTNz?=
 =?utf-8?B?WnhuUHpBU29XUTZkbmZsNDFmai9VU2lLckxFSExMbTFlSzFRZVRkTXJjUHJ2?=
 =?utf-8?B?K2prWXFabndvL0JPQklxRVZwNlgzTlBvenk0NkFjM1o0ZUtibUllOWM5YWhE?=
 =?utf-8?B?UGM1VjN3YitEeVhPUUhxNWVwVy84eW5uZnhrZ2xYNytwcm0vNC9MZTNFaVhy?=
 =?utf-8?B?WGFVUEcvQ3VxRFROOXdSM3Z1YTNRVUE3TzR1MWRSQm9hUjk1dGJ2NmFrSEhQ?=
 =?utf-8?B?M29JWmlMa24xV1ZoaXJMWUN6NVJIcmZYMW55R0MyUm1lWGtmUDZoQUQ1NVBs?=
 =?utf-8?B?aWRlYTA1Qmh1cXdjSFUzZ000Z1p2dzJNWHZIajQ3RTlic2dFMzdBdDFFdHZH?=
 =?utf-8?B?bzVJb2phU2JMMXIwSE5aUjI3VE5HNnlrTFNrTSsyQWw0T3NGaUFVYjdjK1R5?=
 =?utf-8?B?WC83QVNJaUZjQkZqa3hLb2thSGRwT2dFdjNVV1J5NVlSVGRzSnQ1TzRQUGh3?=
 =?utf-8?B?WnNvSkJYL1NiZXMraGlvMWlRbURCN01YVExjUVFvYkJqVkxNUjRYRVY3cXRz?=
 =?utf-8?B?eUdaREFCcXEycVg5Y1haZVhFcjh2cHdVMTRWRVJsbkdXdWNLdlRWUXVKRytp?=
 =?utf-8?B?UWpOcXpoeHRGbVgrT3U5aVJiUHNZN04vb01hQ3BwZ2llU3VRbGMrSXBsajUw?=
 =?utf-8?B?aDVKZnBCYVZVaEdoVVJhengvVTJIWERFWTZnMFVQRUI3anhxcWlJemFzQUFh?=
 =?utf-8?B?N0pvSmdFbVp5R1BFZS94RXhkc0E3YktyZ1pPNkd5VmxnQmtJV2JsVyt5OEd1?=
 =?utf-8?B?SmdTbmZKblNST3RLNkdscDBhek4weVhLVW9haTRVWDdVN3dSUkRsRWdQYmlD?=
 =?utf-8?B?Z1FoTjM0UTBjRkpuczI1cHlmSExXRXJQVmMzN2NjSStPbmJWUG9RT243cTFZ?=
 =?utf-8?B?QnBoazVmL3p5YXdCNmZwM0JJWlRlZFdVVnJHNnBvNkNZRjdKSkkyaldIVndD?=
 =?utf-8?B?T3EwRHB5ZWtTWmREK2JPYXVKU29zTzRzTEs3eGw2dGNoMEZ5bDNuM2htaUsr?=
 =?utf-8?B?N0p4cjhHclRJK2dKZlhVdUxlTjExMEFIY0pza3YzajBEUEZ2bi9KOHdyTXpv?=
 =?utf-8?B?ejdQSm4xUi9IS2p5YTRzVHJkaU5FZlBIMDgzRjJNUmQrbkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0RtT0NoUnlwM2VHY2FZZEhBQnVOWnR3SnREUEhFUDdLVzloZlEyaE5sUEpD?=
 =?utf-8?B?ZHdoNFl5NGlOZVBNOHBza3hiay83Y1ZMU2ZQVGJ1d0FQbFBLSWo0Q091LzI3?=
 =?utf-8?B?NE5BSXBTN2RnbTRnR053Vjcwa1A3d3hzQU5vamhIVXMrRkhTOWhiMUlyVzBn?=
 =?utf-8?B?Tm04T0Nab1FIa2gwMDR0bFpxdmo1bVFsbGZPUHZnZXo0SlNKZVZzUHZPRXdQ?=
 =?utf-8?B?dFh4ejdiaG1LSVFFYy9Danpnb21UNmdkVkthcmNuNkJ5NXE4WnVrc2Z5czgx?=
 =?utf-8?B?Y1c4VjQxeHFiSnFXR0o1bEtEQ0VqTzVGbnNNbXBwWENPTFB1eStsWmFLVERQ?=
 =?utf-8?B?ZTdXUXdtL0tTbW9mcXFwYWhmTXIyejBicTZ3UmNjQzlIMmpjeUJuNU1XdTVD?=
 =?utf-8?B?L2ZwQ0RVa3o3RFN5SHlNTUdLNjd0SkRxeEdaZUFTU1U2SFRMK2I2ZTlQaUVS?=
 =?utf-8?B?S2R2SDEvTTlZM21meE4zTWV1S0dMNjZ1TGp0cXBoQ1VFem5ZT3FXeGoyMmZq?=
 =?utf-8?B?bkVTdk9hNk9PWVJSZUNkaFRxTzdBd0xoaGRuSEwzcDhYck1iNzhBdktyY0Mz?=
 =?utf-8?B?YUZzZmVRR2NZSTIrKzlIb0hsUXgzeFFLT3JJL3hmeERGZkZOYUZzUlEvUjk4?=
 =?utf-8?B?Nmtib3ZWRUIyZVdub0lrQ0FOSU5Ib0ZzMGZScjZEZys3dHJTck0wY3RVZ091?=
 =?utf-8?B?YTZPdVVGQ0xuZWVNQnVLL3l2Szk4UW9JbmFuSUtIeUg5ckxFdTA3QWFsYTNG?=
 =?utf-8?B?R3p2MmNIUmVVajhCcHQvbXBJS0xodUdXYTZiSzRFc1pvZUxuTEtYdmNXdzFt?=
 =?utf-8?B?ZG1tOFltT1E0MUhKeDhzcEViUXBwMkpRaUhmOE1EbUJzdDEvTVlyd1ZSNzNX?=
 =?utf-8?B?Z1VyVVN3SUVtdlFHMzN6SXBGNlBTU1hJTDd3czI1OUpvSFpVN0swSDJ5T2Y1?=
 =?utf-8?B?UWJWd2hMVmM0TlRlc09xS3VJU3oxTVNqZlZpeDV6cEkzVjgxV3dIblVSRU16?=
 =?utf-8?B?djJXRlptREF0SnprSzNpcFp5bGFNekJZbjg0bVNIaUFtemN4U3hOY2ROemFN?=
 =?utf-8?B?NldKMUg2SDZHcUo0WnpLcnJHL0FQUjgvWitUSVBwRlVxNUlENnNzTm04ck5k?=
 =?utf-8?B?QWVWek1LdGNsM1I5cnE1UkxvVzl1SWxkUWdTOEJ2bTI0dTQ5YjNxVEpzc1hr?=
 =?utf-8?B?UGl5U1IyUWdsSUhyKzBzYWJnRmZXQkZxUXFtcjlISTF6bnp2bmRhQ21qa081?=
 =?utf-8?B?dS9OVGM0amhsZjRmWDFjOGIxWWxYcjJEUnlDRmo5S3pmTDlzU1B0K3FyTjdN?=
 =?utf-8?B?UVFiVWVhWnV1U0ZBZU1zaWx2OFJPY3JuL1RvQXJhZ1lhMlpxV3lHeGFpcStD?=
 =?utf-8?B?WE9CQmJScnlsNllmb2dWdXFWVnpXQUJ5NkRSYkJVMDZycWxmcnNCSk1RY3FD?=
 =?utf-8?B?SlU5UVluZmZnL3Z6QjB5SU1jbEtpSzAvZ21sQm11Y0xXMlVlUEwrajYxUVp6?=
 =?utf-8?B?ZkJDMFNxdzNGeWRoNjRVYm1uQ0V2TGZjOVFTYS9xZzA1TVlyTFQvUmU0STcr?=
 =?utf-8?B?Q1dYQXJTV014cUlBRzB1RzdETFhMbU1qZzFxQVFJUCs2UFUrTFl3T2tQVUNQ?=
 =?utf-8?B?MGgvbjdqMjhiVGp2Uk1MMWpENy9CeG1ZUUttalBzNk10MEdZWXlXNFlBYkVZ?=
 =?utf-8?B?WlhVR3lQWFg0RFNtT2QxSEwxdWg1blI5dHgvWjlrbG9vZ3FkSWJ4RndNUU1x?=
 =?utf-8?B?YTNtemNJVUlPck96K3p4cEZ6enNtRmRDSDNvOWVZRmdGb01pazBYWnFYVm1L?=
 =?utf-8?B?M2k3YUMvS3JEbjRQWHFERzJ4RzlYeFFtekhzbzd6VStnUHd0WmdNQzE2b2pU?=
 =?utf-8?B?UHhwVjllSnVxenFmb2FtUGFwbUdPUFVMNmhWWHFTR3VlQWFWWjlCUE1IRjZT?=
 =?utf-8?B?MGZvbWNDcXl6WGtDbTJ0d2w5c01ibUhwZXA5dUF4VWZMZElJYmVpWUV2bExp?=
 =?utf-8?B?RnVLeEtmVFE3MHh4aXVpWEp6TjlyNGYyalZJQk9MdFg5N0g3MjRtdkRybHBq?=
 =?utf-8?B?N08rUmlCMmpsTjNMczJnMVRWNVd2anNzWTZFZGFaTnZCNXQ3KzhYMStDVlMr?=
 =?utf-8?B?V2Q0TDFIUm5DVkpERTNLRlNQNlpFRVR2SXI1V3F5WGZSQ0ZZZ1ZuVC9rbVFy?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <98094AB4E4C03F40B074E9F2EA4A18E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97ac9ec-c0de-439c-9cb3-08dd1552eb48
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2024 17:33:23.4834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: scccC5YSiM6qMRdOAiSTS6rDaTIvIHSDh0G4Ynx/0VKIUEq44LdAe7/215HBvLeJJdV9vrBH+iOyrwphFkn/UwRXixUCqK4G9Ws6BTeG5MY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5298
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEyLTA0IGF0IDExOjU3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvMi8yNCAxNzowMywgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gK3U2NCB0ZGhfdnBf
d3Ioc3RydWN0IHRkeF92cCAqdnAsIHU2NCBmaWVsZCwgdTY0IGRhdGEsIHU2NCBtYXNrKQ0KPiA+
ICt7DQo+ID4gKwlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+ID4gKwkJLnJjeCA9
IHRkeF90ZHZwcl9wYSh2cCksDQo+ID4gKwkJLnJkeCA9IGZpZWxkLA0KPiA+ICsJCS5yOCA9IGRh
dGEsDQo+ID4gKwkJLnI5ID0gbWFzaywNCj4gPiArCX07DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHNl
YW1jYWxsKFRESF9WUF9XUiwgJmFyZ3MpOw0KPiA+ICt9DQo+ID4gK0VYUE9SVF9TWU1CT0xfR1BM
KHRkaF92cF93cik7DQo+IA0KPiBUaGVyZSdzIGEgYml0IG1vcmUgdHdlYWtpbmcgeW91IGNvdWxk
IF9wcm9iYWJseV8gZG8gaGVyZSBsaWtlIGdpdmluZw0KPiAnZmllbGQnIGEgcmVhbCB0eXBlIHRo
YXQgbWVhbnMgc29tZXRoaW5nLCBwcm9iYWJseSBhbiBlbnVtLiBCdXQgdGhhdCdzDQo+IHdlbGwg
aW50byBuaXRwaWNreSB0ZXJyaXRvcnkgYW5kIG1pZ2h0IG5vdCBidXkgYW55dGhpbmcgaW4gcHJh
Y3RpY2UuDQo+IA0KPiBPdmVyYWxsIHRoaXMgc2V0IGxvb2tzIGZpbmUgdG8gbWUuIFRoZSB0eXBl
cyBhcmUgbXVjaCBtb3JlIHNhZmUgYW5kDQo+IGhlbHBlcnMgYXJlIG11Y2ggbW9yZSBzZWxmLWV4
cGxhbmF0b3J5LsKgIFNvLCBmb3IgdGhlIHNlcmllczoNCj4gDQo+IEFja2VkLWJ5OiBEYXZlIEhh
bnNlbiA8ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tPg0KDQpUaGFua3MgRGF2ZSENCg0KV2Ug
aGF2ZSB0d28gbW9yZSBiYXRjaGVzIG9mIFNFQU1DQUxMcyByZXF1aXJlZCBmb3IgYmFzZSBzdXBw
b3J0LiBBIGJ1bmNoIGZvcg0KbWFuYWdpbmcgdGhlIFMtRVBULCBhbmQgdGhlIHNpbmdsZSBtdWx0
aXBsZXhlZCBUREguVlAuRU5URVIgb25lLg0KDQpOZXh0LCBZYW4gaXMgZ29pbmcgdG8gdGFrZSB0
aGlzIGdlbmVyYWwgc2NoZW1lIGFuZCBwb3N0IGFub3RoZXIgUkZDIHNlcmllcyB3aXRoDQp0aGUg
Uy1FUFQgb25lcyBmb3IgcmV2aWV3Lg0K

