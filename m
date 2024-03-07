Return-Path: <kvm+bounces-11299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE227874F0E
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 13:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DFFF1C243E1
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 12:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3631CA97;
	Thu,  7 Mar 2024 12:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMoyjo6R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F72846C;
	Thu,  7 Mar 2024 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814610; cv=fail; b=XkOWqnDUajCpo55SZtkelV6cFqgAiaSCWIJo776g5q80PrpdmWp2RDVg1Gwj4OaYRF4EHYbtwWIqEt45cea53IcDHgrFZjzGe6jvST79fTVt91fZWjtB63f8qTzwEjU0zsIDP9iqiIAU0V1T36cjpsz9GvsoPxabdpAuzTfolB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814610; c=relaxed/simple;
	bh=rik+6+4z2BM8YkqH3+O/aGSK/GJZxVI4ZUCpgp+trz8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p3vZsK7+n8ryHyhiru7DK+EYdXfEUXuAvx1Hj/mcBsuUKMNffvCpwXV9Twk1QmSEGAfod0k4ylb9n13ORzG5Sb+Pfk9MdcW0nKiQfDfoyn1dy1h3G1nfDBb/1sqEapjmtjtYdt9B1VtrbJRT7vjYzxpvfwIQoVyOHy4pYxHhJWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMoyjo6R; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709814608; x=1741350608;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rik+6+4z2BM8YkqH3+O/aGSK/GJZxVI4ZUCpgp+trz8=;
  b=gMoyjo6R6GrB3++o+OlrxHlB36D0ghsXZsjw9sThEmGplXWk7P2mwqBG
   jxpcixi7cJkjOKVDr3sx2ovU9rITH4O50beUiiiJjhcUC10b1L3yeGWKl
   tZYxvcHGVpVhPO26bstjPEDKpChBukPP9geemni990o1+HPkFstELhGth
   YREBAscPodSfSoDOWmXt6Nf/jHm26Lrxy1Bg2RdFmdf/o1zDY1H89E88y
   tXGn1pdtENO8nrJdtNQiTAgzTrCJ1ztYwB8a2HPAIqmpvx6vCNXspcepQ
   WF0JW3FVGywjkFVjH6RDBHW+HEX1cDJ0Adk0LxlrJqK8TsjvD9j0h4Z2i
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4409054"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="4409054"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 04:30:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="14696753"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 04:30:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 04:30:06 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 04:30:06 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 04:30:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3NbHPj1HKs0ro/sUfGhOziPJm+oLI0I74yvZLUn+WliqpQwpZ6aK69ZJD/Ppu6Gwv9Vdh8hHP+zoDdDPloWYSArgxNhGbgrDnT7IAehRVkxxGCQTpd8XCRog0YGBO/6hd14bk++JyK5qBxKQHaRz9ltpC1z4ZmFPGtUu/Vm/elN0HBqTchOd8/skzG7qkmxeMbNPfP/ggetuXP4z45nRSp3u0Ty+vRSQVb/mhM6q9KHA2XGHEoXHjZPZfXpFzmYmpvT2PAdCa/lEfgTfvWV2KUF5wIaksR7COYilBLJx6mxIxTibHnURuMPMdQMuu29QJFcHj7dKbcHts/6mw9PmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rik+6+4z2BM8YkqH3+O/aGSK/GJZxVI4ZUCpgp+trz8=;
 b=NsoLUJrqD7c1zVy4G+Kh5wvumYok7GPpKkldXw6EOhg60zZiqOfJXXX6q+333hjLaMghgzBT/Rb6QjuXcXDCqTbsskOd6Lvx1BLYQNNvn8BoDK8p0gwW/njGGwRIhh+xg7XSC2FIckAwtRMvHGAW6bBORFcc9zX89FgBRKK1+rVAml1//MH/qDpUmoOkawfl3vTFo1g9101agkw9RyZmPcDEd6yE7i8lxmqaFJQGrE62a3njzuTk7hSjDtmyekGMWAjzyyxO08u37lefFNEP0awB1uZfVnYy2ApahKRPsYZh9sH9mFwa9fA5Hlsl+hed7bY4WkL9RtdX72N4JqmJKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5077.namprd11.prod.outlook.com (2603:10b6:510:3b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.6; Thu, 7 Mar
 2024 12:30:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 12:30:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Thread-Topic: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
Thread-Index: AQHaa/4rmsaNLqB4SE290Rjzl3NphrEsPlsA
Date: Thu, 7 Mar 2024 12:30:04 +0000
Message-ID: <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
	 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
In-Reply-To: <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5077:EE_
x-ms-office365-filtering-correlation-id: bd71f19f-b246-4bf1-9970-08dc3ea2512b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BP9V+CJx0Sb7U3itCy9sGltB06ifs/AOJaRE6KbDGEaQnA5Pa3Lkv3Pg/OW4/HEWV9F0zJ5+lJTxl6z6cyHuBfy7cNYdqTMV7XjxcSFQ3ARWqhXWaAiLcg1rVuRq3WzmwASRX9w5j47DAYuWelQSjRX/Ir3nPYGw9+53JCmZDE8Im+te0VA92ARcUxCfOyqO3bMIfhgkz8BiaRqeEP/D9dVa1j4unntdSwe0n5thclrU6Snl5vbUZt0DiW8h2U2eg19klb7fhBSuc0TEPD9xBXtKmvQ6/kVFr4QZTrnJl6AeSSfJh6wDaJN/tE+1oKf9C/qjOjhyWZi55/qg/lK0BLF4wzRv9NDJ/UotZBjmeHfnKh0uzRNaWZLk3nQkAhvDTI0gbfAPGZE7dXSD/W+zu6iAftVfRpPfq4TN/1JqU6FYsDKEDTtI7i9lseJBHah79M/hWC2DLH2lRDQHzxfU8pRAL6JNmgOAwzCT1ZK7UEu6VEbsEVpHGr6eYpKtZHjLT1xutX5iiqvpC3xT/Q7c4JAceL3tF0vAFsAAhkxwV9U/+3km6k6ISy2uwL+dss03NbjXQFhI2BPnLtRW4Sw9RIu9aDwa6zujijICKhqRgXA/zYu9alJCdApNdWlvi1fPDz6tHMix5v9e49gDtdNmGvn18ormXSMcrfBXz2nwc88HHNooYGWHcKWqiE8ZPqhLq3EcLN1tjSyi4i4BoF4vkczxiUaiqKbMsETydSBubHA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHFJRlZGQUdqV1hHS3hiak15SlFEazVrdC8xNHBQQzQrbWQ3dFdwcW03dy9w?=
 =?utf-8?B?NEx0bCt1UjQ0ekZCL2ZqTTlMTkQ3cTFqMmZQWnJXNXBJUW1UaTFaa2Y4STBQ?=
 =?utf-8?B?aE1DbTJmRVlDcGNkOE0rVGNTY2hoRHBsN0o0cWVnbTNSL0E3SXZOMVVTUXFK?=
 =?utf-8?B?OTZJTkJQTGpBRTZvcnVNeXZlbklicVI4cWNwemJmazZ4TDIzZWhvWFN2c0Vi?=
 =?utf-8?B?MU01amNFOCs2Z2ZvODlOMEZSRld4ZUQxcE9vQnNQakpMY0lYZXdLWnMyc2JV?=
 =?utf-8?B?SkprQ2VralNJaU9FS3VIUXE4MCtZLy9kajVodGRGcjdCajhTOGNWSE5DalNF?=
 =?utf-8?B?cmxGTWFDL1lGMFB4SDRSU2F3S291NlBETkoyN0ZWdUxsOFhvb1ZRVjRvWWd0?=
 =?utf-8?B?U1RpSzBIaFJ2bWxqbHJMQ01PRE5LZ2h2TnJpbm1WakFodm9mbkNQdzJCTHdw?=
 =?utf-8?B?NFB2TDBlMXRVZTY1b04xR3BYRzd0WFZiOTE1VzJ0bjBCQVFQMUdXVDZNQWxE?=
 =?utf-8?B?NzdGd29BRFlPcmx3ZWhBNFBhTzlvY1pxZGJlcTRBWDdJMG1sR2VtV1Z2S0pT?=
 =?utf-8?B?eUdjV0VOUHZxZWRyMmRLTVJodS9oU1RxQmlnRW9TMjZTMWNLYkQweEI1L0VX?=
 =?utf-8?B?WlJVUFI4T0NGMUFkbTl0Tk1qNVlVZE13UGt5S01BSnphRkNMYzdhemowbmJW?=
 =?utf-8?B?bk5YRHY2NkVmSy9qOWN1S2FscXpZRTdmcFY2enplVDYzanBNYWpKQjR6c1Ji?=
 =?utf-8?B?YytLVEhETlNLWVZkQnMwUVpiOWo1ZnRPM1hNK3JrYUxnakVHNjY0dStHcHJo?=
 =?utf-8?B?aUY5TkY3dUdveHhjNW5QcVhNNzhaTWpMUzN5dHJjU3JpaitVaHk3QUtsNTc0?=
 =?utf-8?B?ckg1ckhWd3IrbTU2WVg2aUo2dUYzakFOcUR0MWRyMW45MW5zVG9rd3J5T01J?=
 =?utf-8?B?TGF0Ym9tNzROVHNWMlY0eVpZS0daQ3psSXAyNGx3a09ZemljT1lEOFFweGk3?=
 =?utf-8?B?OWpvZDJYOTc3a2RZSEdxdGFlRC9IV21Sa01ZSmkyZ0YwT0hvWTQ1WUdFaHVv?=
 =?utf-8?B?SmZta0hPQS8vUGFyM2VnZjIzZmRPOHIrdFI1TTFoSkFMMWp1OEFHOHg3dzZH?=
 =?utf-8?B?a0VXTkhuNzRDY2NPS1JmdFB6NFhNT09NOEhSVkJnMW1wc0ttOXVCd2tCeWpk?=
 =?utf-8?B?SEVsckN0YklYZCt2UzJhcUJPRlNuV001U2tvMTg5ckJQSURvNmpqcXJQZUJ6?=
 =?utf-8?B?V3Fwc0U1Nk1mVjVSOUc4YUVqT3V4UHZjZWdBMHRrRlE2cThYNmkrRkFVN1Vm?=
 =?utf-8?B?QWI2bi85Uk9vS3VxeFkyOVZZRy9tTXJ6ZnpGRVR3a3ZWbFdvb1J4SDBtUEdV?=
 =?utf-8?B?R0VQVDMwZVg3OUdjK2ZlWjJkM21OeVZjeXJOZzRuZ0pkZG15RTdWdlJ5aGhx?=
 =?utf-8?B?MEd5cEtZWllJMG9BbTRId0lHeDBOVGdOMmhYUU9Dd3lQWis5OVBJUjNPT2o4?=
 =?utf-8?B?MW5uLzRVaWp4QmhnTDJwUzdPYmRPUVlUUlZ6ZEpOcURYdFRHbDg5VjQ2Z1lX?=
 =?utf-8?B?dUtLUHNsOUZMbGl0c3oyV2ZGVHVHalFGYTZ3MEoyL2tkN0JOQThFcWZtZGo3?=
 =?utf-8?B?UDBIOEVUdXNJRUhCc1pMNmNDNnpGTDlkdGdSUStXeStKSjZuQ1lMTVFFOWNx?=
 =?utf-8?B?aEFrVzF1dWVPVjN6S1RkaUJkeSs5a0d3ZHRMbUhDdlpiek1HUFc3bDBSNmVa?=
 =?utf-8?B?Qkd0WFdvNUsvaHZJdVpBQ1pERUdoVUhxMnBPZE5iVFZyY2NZZG9FRkV5b0l3?=
 =?utf-8?B?V2htWXBLR256b09jb2dCM1lJVmZUd0ZpeW0zaTh6L3BSTDd5akI3bVhrSlNX?=
 =?utf-8?B?bnFPYzdMOHMvTnZZRkJuNG1HWVpFYWFUQUJBOHVoc3VjMlZtQTdPY0RZT2RQ?=
 =?utf-8?B?OC9ydUg5dUxKdk1lVDRrTlBreVEyaWNCUjc3Y0V3bE94ZHlVWGI2SkcvY0JX?=
 =?utf-8?B?UVAzK29tbWJkbXIxL0NrWXdHMEFHWjdaTEJBZXpWVXovdnpVWjh0Q1hpcCtX?=
 =?utf-8?B?SStKS3lMOTQwcFFsbHJHK3IwZFQ3c2RGMWtabFNLSDJheFpwREVxRzFiMVoy?=
 =?utf-8?B?MFRJR3hrY2hqUkRTK092eEtQQzJiWFY2QzFlVytaUXJWaW5SZmcxWStjbmhZ?=
 =?utf-8?B?VkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5AB8AB506A1DF47BB64ED7A0A0A6090@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd71f19f-b246-4bf1-9970-08dc3ea2512b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2024 12:30:04.6701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /gsZOcLmEcFYNppjP15bLKea+j1PLlMywMo1CYNaoUJctJFYpWwWWEw2fw99BiD69FlicCjt4tkWMqNMJVk70Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5077
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTAxIGF0IDA5OjI4IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBBZGRzIGRvY3VtZW50YXRpb24gb2YgS1ZNX01BUF9NRU1PUlkgaW9jdGwuDQo+
IA0KPiBJdCBwcmUtcG9wdWxhdGVzIGd1ZXN0IG1lbW9yeS4gQW5kIHBvdGVudGlhbGx5IGRvIGlu
aXRpYWxpemVkIG1lbW9yeQ0KPiBjb250ZW50cyB3aXRoIGVuY3J5cHRpb24gYW5kIG1lYXN1cmVt
ZW50IGRlcGVuZGluZyBvbiB1bmRlcmx5aW5nDQo+IHRlY2hub2xvZ3kuDQo+IA0KPiBTdWdnZXN0
ZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0N
Cj4gIERvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdCB8IDM2ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0IGIvRG9jdW1l
bnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0DQo+IGluZGV4IDBiNWEzM2VlNzFlZS4uMzNkMmI2M2Y3
ZGJmIDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCj4gKysr
IGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0DQo+IEBAIC02MzUyLDYgKzYzNTIsNDIg
QEAgYSBzaW5nbGUgZ3Vlc3RfbWVtZmQgZmlsZSwgYnV0IHRoZSBib3VuZCByYW5nZXMgbXVzdCBu
b3Qgb3ZlcmxhcCkuDQo+ICANCj4gIFNlZSBLVk1fU0VUX1VTRVJfTUVNT1JZX1JFR0lPTjIgZm9y
IGFkZGl0aW9uYWwgZGV0YWlscy4NCj4gIA0KPiArNC4xNDMgS1ZNX01BUF9NRU1PUlkNCj4gKy0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiArDQo+ICs6Q2FwYWJpbGl0eTogS1ZNX0NBUF9NQVBf
TUVNT1JZDQo+ICs6QXJjaGl0ZWN0dXJlczogbm9uZQ0KPiArOlR5cGU6IHZjcHUgaW9jdGwNCg0K
SSB0aGluayAidmNwdSBpb2N0bCIgbWVhbnMgdGhlb3JldGljYWxseSBpdCBjYW4gYmUgY2FsbGVk
IG9uIG11bHRpcGxlIHZjcHVzLg0KDQpXaGF0IGhhcHBlbnMgaW4gdGhhdCBjYXNlPw0KDQo+ICs6
UGFyYW1ldGVyczogc3RydWN0IGt2bV9tZW1vcnlfbWFwcGluZyhpbi9vdXQpDQo+ICs6UmV0dXJu
czogMCBvbiBzdWNjZXNzLCA8MCBvbiBlcnJvcg0KPiArDQo+ICtLVk1fTUFQX01FTU9SWSBwb3B1
bGF0ZXMgZ3Vlc3QgbWVtb3J5IHdpdGhvdXQgcnVubmluZyB2Y3B1Lg0KPiArDQo+ICs6Og0KPiAr
DQo+ICsgIHN0cnVjdCBrdm1fbWVtb3J5X21hcHBpbmcgew0KPiArCV9fdTY0IGJhc2VfZ2ZuOw0K
PiArCV9fdTY0IG5yX3BhZ2VzOw0KPiArCV9fdTY0IGZsYWdzOw0KPiArCV9fdTY0IHNvdXJjZTsN
Cj4gKyAgfTsNCj4gKw0KPiArICAvKiBGb3Iga3ZtX21lbW9yeV9tYXBwaW5nOjogZmxhZ3MgKi8N
Cj4gKyAgI2RlZmluZSBLVk1fTUVNT1JZX01BUFBJTkdfRkxBR19XUklURSAgICAgICAgIF9CSVRV
TEwoMCkNCj4gKyAgI2RlZmluZSBLVk1fTUVNT1JZX01BUFBJTkdfRkxBR19FWEVDICAgICAgICAg
IF9CSVRVTEwoMSkNCj4gKyAgI2RlZmluZSBLVk1fTUVNT1JZX01BUFBJTkdfRkxBR19VU0VSICAg
ICAgICAgIF9CSVRVTEwoMikNCg0KSSBhbSBub3Qgc3VyZSB3aGF0J3MgdGhlIGdvb2Qgb2YgaGF2
aW5nICJGTEFHX1VTRVIiPw0KDQpUaGlzIGlvY3RsIGlzIGNhbGxlZCBmcm9tIHVzZXJzcGFjZSwg
dGh1cyBJIHRoaW5rIHdlIGNhbiBqdXN0IHRyZWF0IHRoaXMgYWx3YXlzDQphcyB1c2VyLWZhdWx0
Pw0KDQo+ICsgICNkZWZpbmUgS1ZNX01FTU9SWV9NQVBQSU5HX0ZMQUdfUFJJVkFURSAgICAgICBf
QklUVUxMKDMpDQo+ICsNCj4gK0tWTV9NQVBfTUVNT1JZIHBvcHVsYXRlcyBndWVzdCBtZW1vcnkg
aW4gdGhlIHVuZGVybHlpbmcgbWFwcGluZy4gSWYgc291cmNlIGlzDQo+ICtub3QgemVybyBhbmQg
aXQncyBzdXBwb3J0ZWQgKGRlcGVuZGluZyBvbiB1bmRlcmx5aW5nIHRlY2hub2xvZ3kpLCB0aGUg
Z3Vlc3QNCj4gK21lbW9yeSBjb250ZW50IGlzIHBvcHVsYXRlZCB3aXRoIHRoZSBzb3VyY2UuICBU
aGUgZmxhZ3MgZmllbGQgc3VwcG9ydHMgdGhyZWUNCj4gK2ZsYWdzOiBLVk1fTUVNT1JZX01BUFBJ
TkdfRkxBR19XUklURSwgS1ZNX01FTU9SWV9NQVBQSU5HX0ZMQUdfRVhFQywgYW5kDQo+ICtLVk1f
TUVNT1JZX01BUFBJTkdfRkxBR19VU0VSLiAgV2hpY2ggY29ycmVzcG9uZHMgdG8gZmF1bHQgY29k
ZSBmb3Iga3ZtIHBhZ2UNCj4gK2ZhdWx0IHRvIHBvcHVsYXRlIGd1ZXN0IG1lbW9yeS4gd3JpdGUg
ZmF1bHQsIGZldGNoIGZhdWx0IGFuZCB1c2VyIGZhdWx0Lg0KPiArV2hlbiBpdCByZXR1cm5lZCwg
dGhlIGlucHV0IGlzIHVwZGF0ZWQuICBJZiBucl9wYWdlcyBpcyBsYXJnZSwgaXQgbWF5DQo+ICty
ZXR1cm4gLUVBR0FJTiBhbmQgdXBkYXRlIHRoZSB2YWx1ZXMgKGJhc2VfZ2ZuIGFuZCBucl9wYWdl
cy4gc291cmNlIGlmIG5vdCB6ZXJvKQ0KPiArdG8gcG9pbnQgdGhlIHJlbWFpbmluZyByYW5nZS4N
Cj4gKw0KPiAgNS4gVGhlIGt2bV9ydW4gc3RydWN0dXJlDQo+ICA9PT09PT09PT09PT09PT09PT09
PT09PT0NCj4gIA0KDQo=

