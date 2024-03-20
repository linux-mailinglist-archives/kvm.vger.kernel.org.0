Return-Path: <kvm+bounces-12206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B528808CA
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03015B21A3F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ECE11388;
	Wed, 20 Mar 2024 00:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LP1fkPOX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4168A3F;
	Wed, 20 Mar 2024 00:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710896205; cv=fail; b=nIhOQUcQkQsgWFka58ODPU4K8YmJgEoQ/nnxZ4qB8+z77rxS79eZvWQTaskjLEYt1Kh/2dPCnz5gRbT+T+7NbtkTYNx7HIDic3qrp5m6K9SqfcXNd5Rl+XrOxiy2aIq0AlaHGmSqedPnzQxAvzcYsVnh1e+h2eWhBIqX2/M0yFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710896205; c=relaxed/simple;
	bh=lSFzr74R/bsBf6N2wehwwmacef2E073t8oAqXFeiOjA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HHMxo1x4laDphFAFDQJwKA6255q9y36H31Wx+ONf1CnV8vqWvkqUd5yEQ48arLw23fgTRJkvWE4Ig3quuE0RPf70lqcZxEywW7ita2fPeNP1dp6XtDk3cQY1pzW5AVjpFEry8Boxnl3blmdXunjPz77WSDspN8AXOEHsZYPWDBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LP1fkPOX; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710896203; x=1742432203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lSFzr74R/bsBf6N2wehwwmacef2E073t8oAqXFeiOjA=;
  b=LP1fkPOXwUJWPDR1CllFFhXLByhubNvKkRdFsDWaEsBGv066mM459oES
   Agzfsk0bERLSfDG+OkTPACykK5/1gPf5p7DoJlVUcoF6qZFF/MPTibPl+
   zCp1okPpMeyKZLIrLMifAlzqlpHsQvoWiK2BosJkHSfoihjwbHLS0fQKh
   PoPYzNde0ZSizEpbwAp0pPMb2gN/j8qlV7KjdSD97zOMTKF3oOlRxfGe+
   4VzjuY1fDpnxBfdsdNTOqMBq84SC4O0NY98qvpUN6Usj+nT0woCj1kq9v
   VfxhvyXRWT+WN74Sxp0DgCOQmEuRk8DQD4k09ptS82r/Luj4MsywoQBdv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="9621161"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="9621161"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 17:56:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="18443941"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2024 17:56:42 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 17:56:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 17:56:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Mar 2024 17:56:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Mar 2024 17:56:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNd05Gqyw8BREWSsuBzPpb26WqX8cGAnm/ZezcU54ixrmbKlFhxYTG07iXP5EpCiKiV15My91CJz4bDty3T8Ok38p78718yIxLO0DMDkYssXp4rrupN/TxgZefdgXKzl3ewzm6mGvPChlGOB30DLoL0jJ/hk7QB/jD32FJ4lNGm/7+wodK+K/FZLRmZgN4pVT2TA6/sV84hkGuwEyH8D0ZqgipyS0YyaqzFJCg8oXH/v6ECGfS2eRujM94I7tqRDCfswpOVDLvTsUECdokbHnOzteT0XxN4lds7Rt7hePvdAPeVQaCSxM4nFHmqUfhEdlDRCXJUYJMQZ5204AQIiIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSFzr74R/bsBf6N2wehwwmacef2E073t8oAqXFeiOjA=;
 b=O3ErI+dmRNOgnghAzdxaSxpnUuJisLyBptxtwVOaWXZ19kvDmMT3piWTnO40NoapJRxoPexdYC2EZi1Wj+JpVedt2XqW1vyE6LIYMGkTTCnCuNOCzIgkyQnYb+EZoq4dbDQOBlyCiIbGkgLyLAH6fZeVSdN86FSeg5lsTTSuG/5PK3LwWgihi9SUiZJvifSlUYB9L2pgcdfLd6gZvh0nRKtaWyviBO8yF70tsVMv/BXFfn9fJ8iLZUtCM+vlDDOXQRF+y3yc3BW/Mj+scoSZqm3QFtLbO4bfT2UOjjm6dqCTN1dhmySH9WViLSrgrVa4VS+LTsNZVU+DO+sORtbZhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB8354.namprd11.prod.outlook.com (2603:10b6:208:48c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 00:56:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 00:56:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgA==
Date: Wed, 20 Mar 2024 00:56:38 +0000
Message-ID: <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
	 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
	 <20240319235654.GC1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240319235654.GC1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB8354:EE_
x-ms-office365-filtering-correlation-id: a7c7ade5-def0-4442-ff22-08dc4878994e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: goq1sOQ8g+2O8WVTiXnJ3Uu9Oa8j/0n3BrcwsbgUriwrQSXHzpdsA1Yd9pBlbz73MYLRwqukPigEbv51zRc83lDRERMfhd7DxJyUhDjd4Wbloyp40XPtY5ZDwhC/+efI9TpBdexpFaK9nun9SsikIk6YM5apN71sjSPYH84dRJgTRBL0Uy4lWEk0OAqb+VaomyUnyb1JK/qnrgHmcWgjky60gCHM9tMEkkwrGMdu5JQ0OSyA4+pWNJXMOrXWdbyZfIGqbuSucttzf6Co9++GE0Awu8wmd3vGQIVNIdZbA2PTY+umlOVAyPR+cxjrFaEL08wCx4FlND5XsXBneHsg995/E+L6M9OuhlVgM/FSAGbqFeSifAsnoEnJHyYhczdZEyS7Gt0FvvSh96SpHnHNS7KVT8FV5Tldll+HA0kcG3wP4kiSQWb+T9u/Z0glem0dKelijUVPaUt0znsfF8hqH3070zsaz6gKEH/1ginKUl1DNzkK9tdsQYw8D6kc6ENifwCb81gTSc/jXVxVKt0O1E313AfdnC92JVVQSxrsO3QGoorwOxLT4p4eN4S8zHINA3ZWD6hx/gmiCLlz2CeOxG22Wy32D2EAN7akldCq/eraS6UzymZ5Yf4AepXsThi0lrcBNE58JZZJiqDAxvUhokwBEg21XkjtBCgjHI4kGKszqTjrRSFiO+b6Xi8ggagvw8KGgwcai7x3nupqL7dg4rTG82tqrqriJN8JFQxGBbQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ky9qbVJEQlRZb2hXMVlocG9TcnNIWXFnYWJKaFRzRjJma3MxK29rQ0R4ZzZF?=
 =?utf-8?B?RzQrQVRyNVg5UklGNWJHU1JSaXEySDh3RzVlL2IvNGR2T1lGRCsyWjVxMVFP?=
 =?utf-8?B?b29LOG1lcUJOUy94Nk5XazlEd3A2U0w2allDQmx1d3puVk5BVnlGV25tQTFZ?=
 =?utf-8?B?dTlFQUg1ejZTbE11RndsVWw5bVIzeFlKejUvMTEwcGFyOW8xbno0YkVNckND?=
 =?utf-8?B?UTRvZFM0RXQxamlvN3FkdkQrOUFWa0N3Sjh2YXRjc2xldGJmKzNuUTBtNzQ1?=
 =?utf-8?B?UHd5UlJ1Z3J6Ym4vQXBzMW9VOHgvd2R3Q1R4MldoS0hnbWEzNTB2dUZ1YStI?=
 =?utf-8?B?NHFacEQzOUhwTFdMWGN3MW5SRDdlQjIvZ29uOTFFWld3ajRBNUtsc3pxeGZS?=
 =?utf-8?B?RkRBZVBLeVora3F4eHFoT05qTGNTVzJuRElraEFYeDhFU1VmKzhsb1FUaGNE?=
 =?utf-8?B?WlVuYU84U1ZZTERMSXB4SjZPVUJ5Umt4TVUxWnlmYUFhQmpMRlZTM3NGMWNu?=
 =?utf-8?B?NmRYOXVKNHVuZU5jaEVxaGZWWk00YWFlMWdkL0Z2eTgweXVtc01mWHFLSzVD?=
 =?utf-8?B?ZkhhQ3dKVHpGMTZqQmVIZmxXSGJRLzFybjRCV3Zic1RyTWdZaXNpZUhpTVdM?=
 =?utf-8?B?T29aTFZMcjlaMnllVFpoVEZsS1dkZjRMakFBeEVsdkNVR2xRNTlxQW1ZYlY4?=
 =?utf-8?B?OElla095Vlcxbllrdlo5eUpIZmgzek1BcW5RL2tQaFRpaDhjU3QybGxRMzdQ?=
 =?utf-8?B?RE9YWGkyRHcxdGI3ODMwdldmSmdaaHZ1TWxKN0N6bXJmcmtoTkhBYndEalpn?=
 =?utf-8?B?L3JWVThBNVZGZ1p4Nmx5aFRENmVGZjFpa0ZkNzdEMkZsYW1nY0hrbkhtTlZ6?=
 =?utf-8?B?UkpoRXptbTJEaHB5WUQyeEdacXRSaHo2V0JYTUxZOGRYYnZlcFo5YlE5Nm5D?=
 =?utf-8?B?TSttZ1gxSVBUQzNpRkRKbUFsOUQzbmlhZGNMUlJBMG9YV0huUFl2TkxaQ3Mr?=
 =?utf-8?B?RHRGdmNUcXgrTURoRmdlQ3Z4c3A3NGJ4Zkk3VGpSbUV3M0F6VXZlL3VDUXBX?=
 =?utf-8?B?RDg5NERPYVBtQnlMYXNnR2FsQkZYQ0xCU3ZsVTIxMlhEbXVCcE5MSkpOZmxF?=
 =?utf-8?B?cE5sOTRUN3RSMDVOQk80OFlmNS9rY1VmNkFzNG9kOEIxV0JmQ0ZhdmMyMW03?=
 =?utf-8?B?MnpqYXJ0ZkozaGNEZXh0S2tXd2ZzMFBodkxBckEzLzJMLzc5ZHZhbjJsLzNN?=
 =?utf-8?B?cEhaVjVyWldSZHg2WmVvT1Y5YjY3VGUwdEt4SjdkQ2VrbHhjM01zalNNRHdo?=
 =?utf-8?B?Mjg0RzNjK1BnTit5bUcwMUJQNVZPRHdMaWx2cVM0VERPbHBzOFZ6T1orUThR?=
 =?utf-8?B?eGllZlc3VmhvaVFLbHUvaEVXcmVJNFQyN0VwUEtONm9RSVo3OFVSc1VweDhX?=
 =?utf-8?B?cm41dlNreXlpV0x6cmpUZ1BRZHR5WVJtV242dWF5aXdjWVZwZUFSNnpkTXRj?=
 =?utf-8?B?RjdEczArZVFTTzc5UVdYcGM4QjBZYThoR3dma2FYZ1pKTVV1b3V4VlAreXM1?=
 =?utf-8?B?THBSQ1NsYkMzVUZHVWw0Z1ZsamdYMjh2U3JCQUhFTHlDR3lPRVFuR3l5OHl1?=
 =?utf-8?B?d1BZVXBINzVWR2lBWFBMb0kzM2I1MXZhY1ZST09rSTdVZk1xOFF2TGwvblJq?=
 =?utf-8?B?OEFwMVJHeG1XUm8rOCtsdXE5bHZibVMrV3FkNG5KWU1IMDdUMW52bVVFVXpu?=
 =?utf-8?B?ZE9ST0dJc1B6QTgzQXZRZEk4RTFBNnlWeEdiVEFXaEV6eWc2UmlWSVFTckZ2?=
 =?utf-8?B?M2g5WUZDNFdxbUJiU0VOMUpLd29uRWxHNnp4UDJjeGxXTmd2QkFzSmNMR242?=
 =?utf-8?B?ZExOeSt1OGx4VXI1V2poY2ZSUEFhT0d0MFJrTjFIQ1dtUWJrN1g2YlJQTlNJ?=
 =?utf-8?B?VGhKTEI0aUlGNXRPbld5NDVnMTVYYlhtNktTYWhOOUFIQ1VtZEE3bmxKaDNU?=
 =?utf-8?B?Z0J6N0Z6SERqd1FjY2xQd2JUQUUwd0FEN3RzNksvekJCTW1xNWNkRjhQL0xG?=
 =?utf-8?B?aFNCd3RvUm0yQWtFb1dOYjZTcnBndDh5YkloYytxSGN6NVVhbnNod2ZaU0pJ?=
 =?utf-8?B?WEhzazJscVZkOENuMDFsOUk3cEUyZFdBTkJBTVRSNmhXNVgydWMwbThRZU03?=
 =?utf-8?B?bFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08E594A5FF75C44CAAE9B8F29DE087D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c7ade5-def0-4442-ff22-08dc4878994e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2024 00:56:38.4591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JurgKCVHrDtWf+SO5Qek2N1tSMHhebQQHM0rDiDocxHFXEq9WGLkFv+vBOzRPFpgOCrrKfFx17cRIL3CxV1U978pN3S4EdLVTSOXUpaBgTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8354
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTE5IGF0IDE2OjU2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gV2hlbiB3ZSB6YXAgYSBwYWdlIGZyb20gdGhlIGd1ZXN0LCBhbmQgYWRkIGl0IGFnYWluIG9u
IFREWCBldmVuIHdpdGgNCj4gdGhlIHNhbWUNCj4gR1BBLCB0aGUgcGFnZSBpcyB6ZXJvZWQuwqAg
V2UnZCBsaWtlIHRvIGtlZXAgbWVtb3J5IGNvbnRlbnRzIGZvciB0aG9zZQ0KPiBjYXNlcy4NCj4g
DQo+IE9rLCBsZXQgbWUgYWRkIHRob3NlIHdoeXMgYW5kIGRyb3AgbWlncmF0aW9uIHBhcnQuIEhl
cmUgaXMgdGhlDQo+IHVwZGF0ZWQgb25lLg0KPiANCj4gVERYIHN1cHBvcnRzIG9ubHkgd3JpdGUt
YmFjayhXQikgbWVtb3J5IHR5cGUgZm9yIHByaXZhdGUgbWVtb3J5DQo+IGFyY2hpdGVjdHVyYWxs
eSBzbyB0aGF0ICh2aXJ0dWFsaXplZCkgbWVtb3J5IHR5cGUgY2hhbmdlIGRvZXNuJ3QgbWFrZQ0K
PiBzZW5zZSBmb3IgcHJpdmF0ZSBtZW1vcnkuwqAgV2hlbiB3ZSByZW1vdmUgdGhlIHByaXZhdGUg
cGFnZSBmcm9tIHRoZQ0KPiBndWVzdA0KPiBhbmQgcmUtYWRkIGl0IHdpdGggdGhlIHNhbWUgR1BB
LCB0aGUgcGFnZSBpcyB6ZXJvZWQuDQo+IA0KPiBSZWdhcmRpbmcgbWVtb3J5IHR5cGUgY2hhbmdl
IChtdHJyIHZpcnR1YWxpemF0aW9uIGFuZCBsYXBpYyBwYWdlDQo+IG1hcHBpbmcgY2hhbmdlKSwg
dGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb24gemFwcyBwYWdlcywgYW5kIHBvcHVsYXRlDQogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBzXg0KPiB0aGUgcGFnZSB3aXRoIG5ldyBtZW1vcnkgdHlwZSBvbiB0aGUgbmV4dCBL
Vk0gcGFnZSBmYXVsdC7CoMKgDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXnMNCg0K
PiBJdCBkb2Vzbid0IHdvcmsgZm9yIFREWCB0byBoYXZlIHplcm9lZCBwYWdlcy4NCldoYXQgZG9l
cyB0aGlzIG1lYW4/IEFib3ZlIHlvdSBtZW50aW9uIGhvdyBhbGwgdGhlIHBhZ2VzIGFyZSB6ZXJv
ZWQuIERvDQp5b3UgbWVhbiBpdCBkb2Vzbid0IHdvcmsgZm9yIFREWCB0byB6ZXJvIGEgcnVubmlu
ZyBndWVzdCdzIHBhZ2VzLiBXaGljaA0Kd291bGQgaGFwcGVuIGZvciB0aGUgb3BlcmF0aW9ucyB0
aGF0IHdvdWxkIGV4cGVjdCB0aGUgcGFnZXMgY291bGQgZ2V0DQpmYXVsdGVkIGluIGFnYWluIGp1
c3QgZmluZS4NCg0KDQo+IEJlY2F1c2UgVERYIHN1cHBvcnRzIG9ubHkgV0IsIHdlDQo+IGlnbm9y
ZSB0aGUgcmVxdWVzdCBmb3IgTVRSUiBhbmQgbGFwaWMgcGFnZSBjaGFuZ2UgdG8gbm90IHphcCBw
cml2YXRlDQo+IHBhZ2VzIG9uIHVubWFwcGluZyBmb3IgdGhvc2UgdHdvIGNhc2VzDQoNCkhtbS4g
SSBuZWVkIHRvIGdvIGJhY2sgYW5kIGxvb2sgYXQgdGhpcyBhZ2Fpbi4gSXQncyBub3QgY2xlYXIg
ZnJvbSB0aGUNCmRlc2NyaXB0aW9uIHdoeSBpdCBpcyBzYWZlIGZvciB0aGUgaG9zdCB0byBub3Qg
emFwIHBhZ2VzIGlmIHJlcXVlc3RlZA0KdG8uIEkgc2VlIHdoeSB0aGUgZ3Vlc3Qgd291bGRuJ3Qg
d2FudCB0aGVtIHRvIGJlIHphcHBlZC4NCg0KPiANCj4gVERYIFNlY3VyZS1FUFQgcmVxdWlyZXMg
cmVtb3ZpbmcgdGhlIGd1ZXN0IHBhZ2VzIGZpcnN0IGFuZCBsZWFmDQo+IFNlY3VyZS1FUFQgcGFn
ZXMgaW4gb3JkZXIuIEl0IGRvZXNuJ3QgYWxsb3cgemFwIGEgU2VjdXJlLUVQVCBlbnRyeQ0KPiB0
aGF0IGhhcyBjaGlsZCBwYWdlcy7CoCBJdCBkb2Vzbid0IHdvcmsgd2l0aCB0aGUgY3VycmVudCBU
RFAgTU1VDQo+IHphcHBpbmcgbG9naWMgdGhhdCB6YXBzIHRoZSByb290IHBhZ2UgdGFibGUgd2l0
aG91dCB0b3VjaGluZyBjaGlsZA0KPiBwYWdlcy7CoCBJbnN0ZWFkLCB6YXAgb25seSBsZWFmIFNQ
VEVzIGZvciBLVk0gbW11IHRoYXQgaGFzIGEgc2hhcmVkDQo+IGJpdA0KPiBtYXNrLg0KDQpDb3Vs
ZCB0aGlzIGJlIGJldHRlciBhcyB0d28gcGF0Y2hlcyB0aGF0IGVhY2ggYWRkcmVzcyBhIHNlcGFy
YXRlIHRoaW5nPw0KMS4gTGVhZiBvbmx5IHphcHBpbmcNCjIuIERvbid0IHphcCBmb3IgTVRSUiwg
ZXRjLg0KDQo+ID4gDQo+ID4gVGhlcmUgc2VlbXMgdG8gYmUgYW4gYXR0ZW1wdCB0byBhYnN0cmFj
dCBhd2F5IHRoZSBleGlzdGVuY2Ugb2YNCj4gPiBTZWN1cmUtDQo+ID4gRVBUIGluIG1tdS5jLCB0
aGF0IGlzIG5vdCBmdWxseSBzdWNjZXNzZnVsLiBJbiB0aGlzIGNhc2UgdGhlIGNvZGUNCj4gPiBj
aGVja3Mga3ZtX2dmbl9zaGFyZWRfbWFzaygpIHRvIHNlZSBpZiBpdCBuZWVkcyB0byBoYW5kbGUg
dGhlDQo+ID4gemFwcGluZw0KPiA+IGluIGEgd2F5IHNwZWNpZmljIG5lZWRlZCBieSBTLUVQVC4g
SXQgZW5kcyB1cCBiZWluZyBhIGxpdHRsZQ0KPiA+IGNvbmZ1c2luZw0KPiA+IGJlY2F1c2UgdGhl
IGFjdHVhbCBjaGVjayBpcyBhYm91dCB3aGV0aGVyIHRoZXJlIGlzIGEgc2hhcmVkIGJpdC4gSXQN
Cj4gPiBvbmx5IHdvcmtzIGJlY2F1c2Ugb25seSBTLUVQVCBpcyB0aGUgb25seSB0aGluZyB0aGF0
IGhhcyBhDQo+ID4ga3ZtX2dmbl9zaGFyZWRfbWFzaygpLg0KPiA+IA0KPiA+IERvaW5nIHNvbWV0
aGluZyBsaWtlIChrdm0tPmFyY2gudm1fdHlwZSA9PSBLVk1fWDg2X1REWF9WTSkgbG9va3MNCj4g
PiB3cm9uZywNCj4gPiBidXQgaXMgbW9yZSBob25lc3QgYWJvdXQgd2hhdCB3ZSBhcmUgZ2V0dGlu
ZyB1cCB0byBoZXJlLiBJJ20gbm90DQo+ID4gc3VyZQ0KPiA+IHRob3VnaCwgd2hhdCBkbyB5b3Ug
dGhpbms/DQo+IA0KPiBSaWdodCwgSSBhdHRlbXB0ZWQgYW5kIGZhaWxlZCBpbiB6YXBwaW5nIGNh
c2UuwqAgVGhpcyBpcyBkdWUgdG8gdGhlDQo+IHJlc3RyaWN0aW9uDQo+IHRoYXQgdGhlIFNlY3Vy
ZS1FUFQgcGFnZXMgbXVzdCBiZSByZW1vdmVkIGZyb20gdGhlIGxlYXZlcy7CoCB0aGUgVk1YDQo+
IGNhc2UgKGFsc28NCj4gTlBULCBldmVuIFNOUCkgaGVhdmlseSBkZXBlbmRzIG9uIHphcHBpbmcg
cm9vdCBlbnRyeSBhcyBvcHRpbWl6YXRpb24uDQo+IA0KPiBJIGNhbiB0aGluayBvZg0KPiAtIGFk
ZCBURFggY2hlY2suIExvb2tzIHdyb25nDQo+IC0gVXNlIGt2bV9nZm5fc2hhcmVkX21hc2soa3Zt
KS4gY29uZnVzaW5nDQo+IC0gR2l2ZSBvdGhlciBuYW1lIGZvciB0aGlzIGNoZWNrIGxpa2UgemFw
X2Zyb21fbGVhZnMgKG9yIGJldHRlcg0KPiBuYW1lPykNCj4gwqAgVGhlIGltcGxlbWVudGF0aW9u
IGlzIHNhbWUgdG8ga3ZtX2dmbl9zaGFyZWRfbWFzaygpIHdpdGggY29tbWVudC4NCj4gwqAgLSBP
ciB3ZSBjYW4gYWRkIGEgYm9vbGVhbiB2YXJpYWJsZSB0byBzdHJ1Y3Qga3ZtDQoNCkhtbSwgbWF5
YmUgd3JhcCBpdCBpbiBhIGZ1bmN0aW9uIGxpa2U6DQpzdGF0aWMgaW5saW5lIGJvb2wga3ZtX2Nh
bl9vbmx5X3phcF9sZWFmcyhjb25zdCBzdHJ1Y3Qga3ZtICprdm0pDQp7DQoJLyogQSBjb21tZW50
IGV4cGxhaW5pbmcgd2hhdCBpcyBnb2luZyBvbiAqLw0KCXJldHVybiBrdm0tPmFyY2gudm1fdHlw
ZSA9PSBLVk1fWDg2X1REWF9WTTsNCn0NCg0KQnV0IEtWTSBzZWVtcyB0byBiZSBhIGJpdCBtb3Jl
IG9uIHRoZSBvcGVuIGNvZGVkIHNpZGUgd2hlbiBpdCBjb21lcyB0bw0KdGhpbmdzIGxpa2UgdGhp
cywgc28gbm90IHN1cmUgd2hhdCBtYWludGFpbmVycyB3b3VsZCBwcmVmZXIuIE15IG9waW5pb24N
CmlzIHRoZSBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkgY2hlY2sgaXMgdG9vIHN0cmFuZ2UgYW5kIGl0
J3Mgd29ydGggYSBuZXcNCmhlbHBlci4gSWYgdGhhdCBpcyBiYWQsIHRoZW4ganVzdCBvcGVuIGNv
ZGVkIGt2bS0+YXJjaC52bV90eXBlID09DQpLVk1fWDg2X1REWF9WTSBpcyB0aGUgc2Vjb25kIGJl
c3QgSSB0aGluay4NCg0KSSBmZWVsIGJvdGggc3Ryb25nbHkgdGhhdCBpdCBzaG91bGQgYmUgY2hh
bmdlZCwgYW5kIHVuc3VyZSB3aGF0DQptYWludGFpbmVycyB3b3VsZCBwcmVmZXIuIEhvcGVmdWxs
eSBvbmUgd2lsbCBjaGltZSBpbi4NCg0KDQo=

