Return-Path: <kvm+bounces-70475-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MEQzJlg3hmmHLAQAu9opvQ
	(envelope-from <kvm+bounces-70475-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:47:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BC81023A4
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 19:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 973AB30AB20F
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 18:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25232426D07;
	Fri,  6 Feb 2026 18:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MZiSakju"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B4C3AE6E6;
	Fri,  6 Feb 2026 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402966; cv=fail; b=HdmrtzOAXbqM90fleawBtniFujx8WYrXFD9xCKo/e35WSPdPiF/3obzgMRrwfdzzpwNIvab7oZYjFsPK8WeS0NWaZXuwiHsUaooTESq8GNrti2iR+34QdUl65xSgIQdkhCk0rg+x/cMrE4MQ2n8dAvx5LMrI7NUuaUbpw1iE5Hg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402966; c=relaxed/simple;
	bh=ZEX8oIkAamzEU65eF2ZbA6u2iMoKIIOulwZno9hCCtk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SQPjonKZOvQGvwqSqY3O2xWpqAhHK4neBj0Qv04VihB+dXU7oEmFShqqLyd7/zfli8ZtocPiaRB3akLbw5qZM7N542JWHhAJXmQzWzfqa/DXpZwlR+yfB3XzMmucYlHIRsu+MOEl58b8ngDgnieXoJ5V4dUGVlEY4VTXI+QdMlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MZiSakju; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770402966; x=1801938966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZEX8oIkAamzEU65eF2ZbA6u2iMoKIIOulwZno9hCCtk=;
  b=MZiSakjuXoANU2gEQIk49ZLMg89aPFdOyKoXk47D7x2wby9ogb1ibotP
   ZuDY0RagJevwo4QwGoid6tch0PgbKhNCa251/ZhnB+pmkPzWR0FwZyGhG
   fa3M02Q5doS81fWahCUAuZBAFYlpeq53+AjOZVEQaeB5eoh8gkNlPim2d
   fIpG7GhjX7KUEGJ0drcatKrYHwP8uZ7i/KmgZAMOdbAYdR67l7SeXLYqw
   ofg806uMeuRsEkMcTk00X7MPnGRzKQQPRleh68I+rptQcHDNcaWYQppbv
   FQiQ7lY7Oki+xDLTlZoNvl0zuLdreSC3lvyEuVlyLTdpJzFJIsrThHW3y
   w==;
X-CSE-ConnectionGUID: CuvwWcNKQAy8mB80Dht3mw==
X-CSE-MsgGUID: r7e0bbzfRmK7/iJLw41CYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="75236491"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="75236491"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 10:35:58 -0800
X-CSE-ConnectionGUID: A12KI28+S3eND1mPAhBeoA==
X-CSE-MsgGUID: zxvFEzZtQOmFrflLhazgNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="210729176"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 10:35:57 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 10:35:56 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 10:35:56 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.54) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 10:35:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pIw21njfFQ2+6/l++LC2I/S4+tjKtS5T0O6C1IGsmUy+F92nG0aocpqjG/tkvMhBhPU9BWEPwWNi45wKsJg/QFqS1Q2iaqYikKlZrEn+skI8IQ1Eo7L3gL+Mi80JxXrCy5bAIgnV2i0G7RNTcaNanDxAMNOmvw9z9kYbfyXYVPZLYKDbqlURX8TPuds3JNQa4I0oQiR5iZtsV6AKeOJuhoCBLQ4560m4hV8t174ShU+kUlmRkfpxZ/VcscxX+4Kw96gTdBxDQLA4zVjoj8jVz3uaBBaeAMOHOpO249DTxE995ai9A9p3NnLPJdnoytlruDbKYu0FXca5er9U02iKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEX8oIkAamzEU65eF2ZbA6u2iMoKIIOulwZno9hCCtk=;
 b=yjCFYF5SNzf2TnGcBRvum+ZJIwZbUjyilwF4/FTOGDS8wiMavwXSnfSTY9uW/86dG0d9Ce5R+Cog3L/DqTtyaA7kv7tQJ+vCAnbbdaRZApZPBVH9BP7zuhXH1MLYJIASTd4nLco7bFqxbmGG0m0t/wCQO2XnWWMY/YUtqt7pmYmpoU0NXJSxyIAexn8SOmj/a1czpMHNY+e6Pged0ymf45AAIjkwnHL4orBJQLRrnZV7ibPdounTAQrAGFcUVwegcFTTg9XXhyjvBZRahfgdQWX8kkOMO8px0zuDZEwLS3OoaeNap7HkRkPi/hrG3/m0XopvMEyZ88P1sJPZ9MfS5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN6PR11MB8147.namprd11.prod.outlook.com (2603:10b6:208:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 18:35:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 18:35:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "kas@kernel.org" <kas@kernel.org>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "Huang, Kai" <kai.huang@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Thread-Topic: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Thread-Index: AQHcgZw99irMrzSa1E+mlK8nBdVLrLV0oZyAgAEVl4CAADssAIAAOT0A
Date: Fri, 6 Feb 2026 18:35:51 +0000
Message-ID: <6f9653dca9fee3e8dc804c005c0a87ebe13160c1.camel@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
	 <6d8d37740459963e6fd7f16a890a837b34ebdf17.camel@intel.com>
	 <aYXSd8B00OtKZcAU@thinkstation>
	 <2235a1cf-7ccf-4134-80b5-8056537c6d33@intel.com>
In-Reply-To: <2235a1cf-7ccf-4134-80b5-8056537c6d33@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN6PR11MB8147:EE_
x-ms-office365-filtering-correlation-id: c929998a-b752-4324-a72e-08de65ae8dfc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NXFlK3hRNmNrMmRRM0JwZDFxQWc3Qk9jczY4V3MrTURBdm9PQXZxQVhCdTZj?=
 =?utf-8?B?Z1RMSVlTcW1pdEVPOXVzLzkzK1gyVjRlMlBscmpGdFlBMXJ3OXhyV3lISVlu?=
 =?utf-8?B?WDdGYTh2Nnd1NjFFZTdOdWNiV1RVemZVNEJPb2dhRWtiNEJuR2R6d3Y4eUhu?=
 =?utf-8?B?bUoxaW5KcEtPV1BGRlRyRkM4cE5Yak5ZS1ZwUVNMWnlEZjk3RXhrZ0ZrYVc3?=
 =?utf-8?B?K3RZVlg1aVBpMVRzV0M5NHNnbnF5bWdkM0tmZVJMZlUrYThzc0pvMmlhTFBC?=
 =?utf-8?B?MUIvNzJoRmlHaXZBK3ZWTThvUUtjeko5ZWdmQjQ1RTFTVW9Qa1ovaVA4QVRE?=
 =?utf-8?B?bGdIOFUrRXZCNFRtcDZQS0lBdmNTWUh6aFdQZ2tMMFBZYVU5TmlLMUw2Y2RJ?=
 =?utf-8?B?bk1ZWkFudFNEbnhoMk1DVW1vL2hkbjZOQ2FzZmxIbmJ5T0Z6bVhWcVlLTURh?=
 =?utf-8?B?MXh5Y3lWaFdXRmJzTjdGVDFrWW54eWpodFMyN2JTTGl1SldLSmhOaXpsdU9V?=
 =?utf-8?B?aU5kaS9sbW9ZS2J6M21ZWEJVN1Z0ZWhZeG5GMUtCcjBGOU9IYytJRHVzcndr?=
 =?utf-8?B?Q3J2bWZnUUIvZ053a1ByUThpcVJhZEMrdU1LWkM3NUQxR1VPWVRqQXY4dHZl?=
 =?utf-8?B?RTRJMUJ2RVhISHQycXk0QlFycDA2akxpZmcyOVVpanlCcmxQVlNXdm81RFgv?=
 =?utf-8?B?RkxJbWJ2MkhVVjdFMW16ME5XdmFkMU5VWmF2N3VWMnUvMi9nZzhzVld3SEpR?=
 =?utf-8?B?R3prSlZVR2ZYQ3lLS29UYmwyRlJVNnNHcEMrVnRydGdtdXkxazBldGlWeEN6?=
 =?utf-8?B?R1hFdXF6a1F1OE9ieHdpU2x2bWtaNG5aS21sa1BSd3pGQlJwOXloemhmQUJj?=
 =?utf-8?B?OWxxV2wzTC9xY2RRb05nVEZ1b0RsY0dNM3NqRU44SjNvRUo5MnREWkVKc1Yv?=
 =?utf-8?B?MFFtd3VGbERZbWk0dXRYdHhlbEJCUWhhaGxIRnFGOTVoOXpTWlE0RktLejdH?=
 =?utf-8?B?bHlZL2NzMytLRzNqNHB1TjZPOEpuc1ZBRlNqK1NlYWxOa2hDR1hjVVhIMGhS?=
 =?utf-8?B?NWdITUZ1SlV6OXNlOXNnVmNWSnAvZkRoYWdQdnBaMEx6Q0pMVSt3REVTSnB1?=
 =?utf-8?B?WmNMU2ppZ3poMm5PYlJZOTJJSVd2L2RGNC85ZDEweFkrMllwTmxHWGNmMStq?=
 =?utf-8?B?YTJVSmt6ei8zeG9HM0E2VkdhWVZWVjArRVNIbDV5aHlvczEwTTF4Z05XYXo4?=
 =?utf-8?B?YkFSb3BTYzFPWGJtQWxaaTNXLzUzRFlRNXI0eDJobU1GOFpHaUFxbHljYWV4?=
 =?utf-8?B?OTdacmRjVmxhMmRJRnlrWnRtVmYvUTg4ZVl6d0R1ZHdGMHhiQVNscHN5S0xV?=
 =?utf-8?B?bVlNSVhZam9IOGdiMUZ2bDJFenRZRllVVE93WkVyMUZKZGRvWFFOZ0JwdzN6?=
 =?utf-8?B?c09vSG5HcGt1NVN6cUtjK3NHQ0NOQTNzcTJtVXJ5bTVrd0lGWDRXNDlGRnY4?=
 =?utf-8?B?UG9RTjNXYndmTUdNUnhFWXh4QUh6aXRFcVhPNE9vdWFtMC96V1JTak13bUtB?=
 =?utf-8?B?djBFditqR1VDOEIwanptWC9NMExnTDF1VWF6ZXFvZWlJUXl6QVh0NkdsZnE5?=
 =?utf-8?B?NnhXSHpiYkJzM0JzemNyS210RVlmYWhVV01kUzlHbms0UTR1V0tSaGIwR20r?=
 =?utf-8?B?QytrcUtBemVwYTZWaGxVSVlHSENENXNyZng0bWlEeW92MkVadDhVZFc3UHBB?=
 =?utf-8?B?dDhjQmtxdzUrNWxxZ0ltdzdrU2hlS3Y2WjB6U0VFMnVsY0RpQWxLeDM2cUR6?=
 =?utf-8?B?ZWxMc1U3cVc2R2doNlNydVNVUXgwSGx5N3Eyd054b1dFcE9jdy9Ha0N2SXNL?=
 =?utf-8?B?WW56YXJNVHJqYTEzQzhnTmtQK0N5aWxZS0pCVTFmbU1JcWpxdUpNaXZFV0xC?=
 =?utf-8?B?akJDK0o4SEF3ZzFhTDBMZXVndUlLRTVpd2E4OGNiU0hTbHRWZlNIMzlWMHU5?=
 =?utf-8?B?bTZLdnlkYWlFSjBJa0Vuc3hTYXZsR3F3bU9NUkxsNG5pT1VzSnEvOWdqdVdp?=
 =?utf-8?B?ZWdkaFJIRytna2JmZE9tMFFrS09tZmVkc0VkMVBWZXJHLzBsVzVvSDlEVmt1?=
 =?utf-8?B?dy92NnhLZlJNR1VzcDI2WnlCbHVwMXVYMTgvMHptSVhlQjg0YUNUSDg2T2RL?=
 =?utf-8?Q?3T6N9sinX6bwzgdvxfMhuYQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVMrWE9MZXZDQlhiU0pneHJRSXY0MEJ5ZURFNTlHWFBIWFEwNFlOUUVhaW1M?=
 =?utf-8?B?azkxYUQ4RUIzcFdxaERJRjhUNmh6WDB6L1R0TStKM1VwbWt1YlU5bWowcGdv?=
 =?utf-8?B?TWRyLzA3ekszelpNK0xJK3RmNFkyeUZUa21TWmQ2UWdQSzRoVWlKT1I5QzZ4?=
 =?utf-8?B?R2lMUHhQZDY3UEJtcXpxek9Fck8vSHBQcytUaVFOU1VUYzFGRWg4RHA2S3Bi?=
 =?utf-8?B?dzBYTXZuUElNNTl3dG9UN3FoMStZWnBVQjJkWkduZERoUHBnc2tidWJOZWx1?=
 =?utf-8?B?WHB2NkJQUTFHSFVoREV5L3NIVlJ5Zi9kTWd5MENxckQvMUQ3dmFPdHhKNTlD?=
 =?utf-8?B?a201MnZocDU0K05tMFIxaTN2ZEJZRkM0THNNcDlSajVxMS9xdm1aQy90YTBS?=
 =?utf-8?B?RmpwY1g3MExjWkM5djVPUlpQVlJrNmo2SHhmMS93UFZEcXVGcWtxUjVyb3Vx?=
 =?utf-8?B?OElISHA3R1JRV3BpVFdDemlWZXlhbGY4VERmUDRRWjdLSndxZ0NlbEtQRXFz?=
 =?utf-8?B?RE1wY2ZvWjVrQUtWaFdSTWtPYlhwZHlGelN0dW5pMHh2R3ZHWG5OaGx1dE41?=
 =?utf-8?B?WVRmZUFUemptUjY1VVlia1RnTk14TTF4K3dOSllRZ0VzTzdMUm1Wbk9kRDRU?=
 =?utf-8?B?QTdiUWplcmFoNHVHZ0tXcDJIak9aMk9WSTlpR0VDR1R5N1RweFpSRXdhYmNL?=
 =?utf-8?B?ci9FVmNMVzQvOXpGYVIvRU80cUROMS9welVXU29LMFdSQ0NlMEwrbTE0Tk1j?=
 =?utf-8?B?TW5kSk1FVkNqVnhla3pTbEVKSEZuL240ZzVKOHRYQWRrbkl5UHlFcFlldG1p?=
 =?utf-8?B?b2tsZ05qbXE5ZkptOTgzM0J6dzZJdmxXWE9PTUJ0bjhOdWtyS2UvMXo4Q1o0?=
 =?utf-8?B?MEUzdHdMWG1YVzBwUy9aSHlFV3BMTGxtWVFRKzZZdU91U0ZXVEZNakRCdlpm?=
 =?utf-8?B?bnMwT0Eza3VDeUc5YnhUNi9VTG1OaWxSNWZhcTBaSzh6OE9PSE5PVVFsQ1FU?=
 =?utf-8?B?eEpZaVlmTG95WFg5RGNHSVhqVEpuRFZPdnFvZTJYQ051MUJFWDVNZEdtaEdT?=
 =?utf-8?B?cEN0T3JXZHZHcW4rOXVPWXA3VG1VQWN5WXUrcVp6d0xMeUR3YnpWM3IxMXp0?=
 =?utf-8?B?d0NPbHg3bDgrUExwaERZbmNvM2Vmalc2RlFBUS9FR2syc05ERXY2U3h3bTEr?=
 =?utf-8?B?WWt1VmxZTUhESmduaEpvSFE4Y0h5UjlaUlhBYlM1VTBvTDhDNk5pVjRQYzZR?=
 =?utf-8?B?T0ppWk5wNkE1Z0h6WXZzTG5XaGJhWEZRWVZHVCtreEJ0cUExTUpyUC81emd2?=
 =?utf-8?B?eGh0emtnUTFyY1lLNXMwOFpFODJ0NXdOa0wycTI4SzJLL2c3eXJkb0l6ai9x?=
 =?utf-8?B?KzhLZDBZa2ZoZjdxVjVycHdqWXlkVmg3OGJ0RjlQQWtBNERZNGl3ODh2RTI3?=
 =?utf-8?B?VklnQjZTcC94emc5TzM1U3RMVlZud05FMU1kMXFGMVlWdW0xeGNHRzNCL2o1?=
 =?utf-8?B?RmNzQTFvdHBObWJvSU9aRDJTYnN3VEUvdDBRdXc5Z0djY0lCUXZtNkVoNlBQ?=
 =?utf-8?B?VWZUZlg3eGFLMDRMazQrVnd0ZjNlcVI3aXlKdm9mc2VZRkNKREpiTXBPMm9Q?=
 =?utf-8?B?c2E4dHRmYlQ4WGdpZG1UZklCc2tCZDRGaUdTMUxYcTBGRUNSaVhLUnNqckg4?=
 =?utf-8?B?ZVZ2ZU94TWkyVW10bkJmWXhjeWZtUEdJMFVzM1FxejBiTWlhWm5MUUozaU1t?=
 =?utf-8?B?eHNOTnhKSzRsZ3dmVkxUdjhMNmFlU2FBSVFUV3BLZmdFUFpLUFRCTFFIRjg0?=
 =?utf-8?B?SDJSWXUzSEEvU2JRbExsVkJKZVBqNzA4MXUvZ0JCWHFqUGNYc05Ub2sxbkVD?=
 =?utf-8?B?WktQaFdNdVd2anlOMlJmWGdxQjJPdW5GdW9hNGNzVWdRUHFqVXQySXppd3hl?=
 =?utf-8?B?TDAyR0I0NU9jVzdmOUhKRlpQejhVaCtLeVJTZ0dXU3pZQUtVU0ZidTBDZDg0?=
 =?utf-8?B?cElqQlVlWTlyeUhXeDNqcXdkbUZyRHFuZ0FZS1A4Zy96T2VqaUxqbzQvS3RR?=
 =?utf-8?B?cTIxeWMwMFVFdllzcHFZV0l3VEQ3Myt0UUFkOUJYcnJQWmQ5VnBYdE9FWlNC?=
 =?utf-8?B?RGU4TEltS0xSNXEzbFAzMTl2OWhGNU53NXA1VDB2WHRBdHZIRzdPNDFzMVFC?=
 =?utf-8?B?M0RySFRGMjB6dTY1OFdnV1V3ek5sWG9Zd0MyMkp1ZFh5eE1MZklWbkkzSldO?=
 =?utf-8?B?bkFQWGNpY2FYcDZQOFBOeTdTQkZIOEZuTTlGbGdjWW9PRXkxdVN6MkhqWXdw?=
 =?utf-8?B?ZHdpeWwxaDhpRUxoYm9mQjhrUjVNekw2eUNTanhFdHp3cHA1OEtWaVp3Y1lZ?=
 =?utf-8?Q?QzWavI1gJZgR4HQY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <700265E7E25D9F4796356983AE066BD9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c929998a-b752-4324-a72e-08de65ae8dfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2026 18:35:51.3798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CwnXRfZA+T+J5w3SueeB1ndEmDWgBx5pJJNw6HHq1WDz6gv9MYU0AnPogLmbSIaY5mdf+uENlltSKA/gxTdouVDHRlUue/pja3LtSIfwh9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8147
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70475-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 05BC81023A4
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAyLTA2IGF0IDA3OjEwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
SXMgdGhlcmUgYW55IG90aGVyIFREWCBzdHVmZiB0aGF0IG5lZWRzIHRvIGdldCBwaWNrZWQgdXAg
YXQgdGhlIHNhbWUNCj4gdGltZSB0aGF0J3MgYmVlbiBsYW5ndWlzaGluZz8NCg0KWGlhb3lhbyBp
cyBnb2luZyB0byBzZW5kIGEgcmViYXNlIG9mIHRoaXMgYWZ0ZXIgUkMxOg0KaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcva3ZtLzIwMjUwNzE1MDkxMzEyLjU2Mzc3My0xLXhpYW95YW8ubGlAaW50ZWwu
Y29tLw0KDQpJdCBoYXMgcHJldHR5IHdpZGUgYWdyZWVtZW50LCBhbmQgYWNrJ3MgZnJvbSB0aGUg
S1ZNIHNpZGUuIEFsc28sIHdlIGhhdmUNCmludGVybmFsIGJyYW5jaGVzIHRoYXQgYXJlIGNhcnJ5
aW5nIGZvcm1zIG9mIGl0LiBTbyBpZiB3ZSBtZXJnZSBpdCBub3cgd2UgY2FuDQpoYXZlIGxlc3Mg
ZGVwZW5kZW5jaWVzIGxhdGVyLg0KDQoNCg0K

