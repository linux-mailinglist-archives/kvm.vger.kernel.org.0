Return-Path: <kvm+bounces-4798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57011818574
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 11:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2BB71F23A96
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9179714ABC;
	Tue, 19 Dec 2023 10:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lc2nRRhj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0631E14A84;
	Tue, 19 Dec 2023 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702982521; x=1734518521;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=H0074zXz3tnpay8fGNoQUTtH8+Lokjgk88IFd29RWXI=;
  b=lc2nRRhj5egGL1nMnE/YLKo67yKXypj/gzKMJnVXaFoUQ0Ch1nzv9jeF
   nwwLb5g5FO+7cXd7F3xhBCa50FYJ4r5Ysp0Xah6biYgfaY0rZBYOZK+9F
   WThPffhJuwcpa7cGN806BfMcSxCXZfxVKGyBjH8slDbgngF5SGIpclNFj
   3zFHULLzeT7dvnRvZkSEHcrjeFbXb8alteEJqy1pqwnLLWjmvAiCXWNbv
   J+2e++qOYZhjhRCJ53Up6VYQyD8nsetS2ppE1eROGjbrUsT5etWcg2wYY
   etZU2lskt/tS2v+1HW/IBahtxrhcCwhQwdzwVtvcAbWxLKVglglnTJXj+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="14327444"
X-IronPort-AV: E=Sophos;i="6.04,288,1695711600"; 
   d="scan'208";a="14327444"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 02:42:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="769187024"
X-IronPort-AV: E=Sophos;i="6.04,288,1695711600"; 
   d="scan'208";a="769187024"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Dec 2023 02:42:00 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Dec 2023 02:41:59 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Dec 2023 02:41:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Dec 2023 02:41:59 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Dec 2023 02:41:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIIsPvFjl+5FB5Yo2tjtj/6T4KIgHDhJqPFgMCR8l4Dxwrmb6BML59C4C7Q3BpXcnXsRgJNBSRUM6irMjcAE24KJVYcuyXlzvtve8LaSjJC8fG+86JFbieQbcq65bwl2ibyhMqFvCXPziIU+9+LPSZIrh0B+N5syDc3fA4z5sjXVgv2gN/TeDEiQjOfNQAwL4/IHrebEjGzunTUk3Pe5cwdycDk+OAeEX2KoE5YNEENBhUupepyT27HEQyAINhYw7Q9qAD0Q1v0RLY1CxUjS755U9FNbdPn3+TNppMLLwgxQt6XdJ097eMysiBOGjZ4ap0oCCnDqap5vhKK8/AFpjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0074zXz3tnpay8fGNoQUTtH8+Lokjgk88IFd29RWXI=;
 b=SlA3UCF6Sb5N+K/pW6dKx3VG83mggcrnec0965m494E7C+U1hs8kJbk3EWrVPCxR/rNMB/oJ8M+UB1TehFzPRzhQ0gGRh3Q629F6PwOEEqnRfRfPp/wMvBMugq5rGHCgatDXPkIp78iGocFc8Cmb14O6IIstswiYNu6RGLlWBZ6mZUZT0hzkKnbGyLm6buOl/iEoImQ5rcZvLJ5xwjCFUISw3MBvkZA2nwzMPN329jaZVs50KlLLlgmI7HnRrxRSC9hItj/HriOuVm7nGs13ggBXIISue+xvpmYfpr2qzed+Tc8GmBLG7k/2O+Gs7tuU0fy17IwHouReyps/C3FocQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5862.namprd11.prod.outlook.com (2603:10b6:510:134::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Tue, 19 Dec
 2023 10:41:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 10:41:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "zhi.wang.linux@gmail.com"
	<zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v17 012/116] KVM: TDX: Retry SEAMCALL on the lack of
 entropy error
Thread-Topic: [PATCH v17 012/116] KVM: TDX: Retry SEAMCALL on the lack of
 entropy error
Thread-Index: AQHaEYrM15F3Z9AddUmFKMCxmHjnz7CwrNwA
Date: Tue, 19 Dec 2023 10:41:55 +0000
Message-ID: <abec59a8e732ecd815723a8f8cee1378ce4d1618.camel@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
	 <a67c877521a6913911bd569c38c772ade6a1403b.1699368322.git.isaku.yamahata@intel.com>
In-Reply-To: <a67c877521a6913911bd569c38c772ade6a1403b.1699368322.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5862:EE_
x-ms-office365-filtering-correlation-id: d097028c-6238-49b1-4e48-08dc007f1e90
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oT4iwPj4s6amQqKCyqF+5KtKv3kz4eCAcNpfkdj4+VceJS8zuslP3HD3oVMrjKl65Q8AWcMALdHyYLdx1ZXZgX7GlcoC3yYkJj2akbyjNbXlZNlhzAnl3lkFRxyoHnV0ArJg4KudGfDlyxNa+WCq/bAWFtgyozfe+GqYREb5o93H2H727LMiLMbMvZ/nlXcL9E5rIUkh4ZpJ20tBXzUqkXLWmtuvFrAU5OZ+2kr7Z4O06E3x/6F8D7a02VdVgDFh+k90/hzjTn+n2Z1Kohwi0G1w/jAgceer36zGKOtbxJiPD20yVE0acmftXmAumzlxTSU0iE/PeXatnuv/zndWOoDrT0wdFZx45sUubwJKrakfK4FhA3JH2YCoqOzZvEFmNjv8xb02JISLYG04WF9EqX8GCvckdUMVxuVhZE6CCqyB/xBULHqv6sQTexQln0/nr1gvCKkL2n03BB+k5LkI4r2xNlKbs1JeH8jISAAwoIjfLAkLG7XofpboQ1z7rzB3shGxNwOFZVRGRNacarEemyh4f2KKFcTyLKnIEBpI3lyVYDJX2Vg65GJt70B04Q26X8ycwN7fTbpoUtssVcDSmtUcK7Rrv2mlt+2biPVz+TrRtd4eWbz8FvBgNlGBDWoj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(316002)(6636002)(66556008)(76116006)(91956017)(110136005)(8936002)(4326008)(8676002)(66946007)(66446008)(64756008)(66476007)(54906003)(26005)(41300700001)(2616005)(82960400001)(122000001)(83380400001)(38100700002)(5660300002)(6486002)(6506007)(86362001)(36756003)(6512007)(71200400001)(2906002)(478600001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkkzbEs1cktWT0t4MVpwYkF5UUpaUGtRbit2U2NZYklYRzByQndmRkR5SlhV?=
 =?utf-8?B?UjNNL1lYVThkUklVelluK1ZmcXJXWnFPT2hqVThTUEhMZmZuZWExUVFyazZP?=
 =?utf-8?B?OUdIeHBDVnBiSzl4SklJOXlxQnd3YXBDekpQQktBbXhVMUlXYkpUMjhaWjlj?=
 =?utf-8?B?dkZLNlJBL29aM3pmU1FVN2hxVytVWllvbnpOWTRLTWJ0bjgra3VvVnY2VVpL?=
 =?utf-8?B?VjI0RERkYm1ZODNzcEVrK1Y3dG9UK1Q0QWg0Um1aSzRCcDFsVkJBL1dMNUpG?=
 =?utf-8?B?MzdWRzBMUDluT3BFb2g4ZlIxNWR0YWZYU0FDbU9vQklLdTJPWlpQaExRbGNY?=
 =?utf-8?B?THFma3FiU0JqRWZianl2aDVrbDkrZGdvYVJ2R1J4ZHNjVTRzYXJ2aFFQR05p?=
 =?utf-8?B?UUpoeXpUWk1yWDlhRXJRQktmODMrci96bStFMVRBcDZOWDZFeEQxQWtoUGtT?=
 =?utf-8?B?TjZHOERQOWRuVVdkbTRWNGdhTnh0QlZ2ZUJwdktzd2UwYVF1WGxCalZFeHJS?=
 =?utf-8?B?WGtpMys4SnhiUUFyQ3laZ2RKMFlqVFFqNVJGM3V5Wkl1Q1VwS3kzSzczQmRa?=
 =?utf-8?B?Qnh6RVlHTnNOaWtSSERFZGZQVHFmQzdIQ1ZJZ1pEOUR2ckQ5czBBeFVVd3A2?=
 =?utf-8?B?Z1Z5akZ6eXlJVHBDY01YRUtxWXJUQkZxTTJkS3FEQkRrYXUwYXljTm0wOUVs?=
 =?utf-8?B?RjduRE93MVE3ZVRYVHNtelU1citNejV1WU5NWlVUZGtLOVUzdmtDckw0ZVVv?=
 =?utf-8?B?ZVhkaG1mS2tyOFpYWmJnMFpiSlZBVkJEVVNxSmJGV2V4US9XMDhKMVc1Y0NX?=
 =?utf-8?B?RlNITG9TSU9oNGFqT0MyZ2ZEY2d4WlVBNUhlc1NJTVVZTXluNXBrS3FUOUFa?=
 =?utf-8?B?a3d2T05zeDIyWEQ5ZkdRcU1tN1N6aDN3Y2Vpdlp4aUlQMld4VExLUm9aeExW?=
 =?utf-8?B?QnJHWVVDQ095cEIzQ21oLzVPOTBIcGkvS1RObmFEY2ZsNnRZVEtDd0F3TkpQ?=
 =?utf-8?B?M0ErZThSWWJjWUw4R0I0Y29pSG1NVU85WVc0ZDF2OGFKTEd3Zm56b3NpOXJV?=
 =?utf-8?B?MStCVi9BUHhtNGxCcG41aXRDSFhmcHN5QktPdWFkSDhONjQ0U3pYSVh6RlFT?=
 =?utf-8?B?Q1J3SnQ5MzVFU1JWcEQ2dERRMXI5MG5acFhIalJGVzAzZnlLWHEwV1B5cTZ6?=
 =?utf-8?B?Nml1TXZqak9IbjlmdUVXWXlqQ2pxbnJUNTMzakNNZEthaG9LUGtGNmRMeEJ3?=
 =?utf-8?B?M2M1bmZYYUFhZ2MzRmovSXNYbUlpaGJqOW02MldTbFMydGpoWDJtL0ViUU1h?=
 =?utf-8?B?NmtkZjd4d3dlVjZ0M1JMNDM0M2gzSG5EUkg2S0xQandnVTFYcHA1d093SFdx?=
 =?utf-8?B?L2tnSG9nRC9Rb0VuMDk3Z2ExMWJVU3hXMFVTQW9IZzdJcTJXS2VxQzdhbzNs?=
 =?utf-8?B?aWVMQzB4bTF0QmM3NENETzdVb2k2dlhacVRtU0MwSDZCaWdqcS9LUmpvR0Fx?=
 =?utf-8?B?TTlQN0JKaTNCM3dKS1dmNWRacm5BZEh4b1VpSDNOa3BqaXptKzRiVG45M3Y2?=
 =?utf-8?B?THo3MFlzZXdXQjVEZWlZWnIrdkpTTmtOUDcrYU83VjVWclFITU1nNW1KT01K?=
 =?utf-8?B?YWtEVmZDWjNTY1FGSHpDeEp1bFZUUjIyZ2poOEhjV3lFOVp6NWZITzNzeXdE?=
 =?utf-8?B?dkpmWk95REp1bmJpZW95T3lMSUZKWnhvZXk0bFg0elhhblhMNVBZcUFKRXFE?=
 =?utf-8?B?a05Jc2xsaWozRmcrQXpZU2ZZSCtXM3FHWGYvekNydDZFSFhFSWVicW1QLzk3?=
 =?utf-8?B?M3hmSUxZNE1uOWFqUHZEbVh0bEFTZEphanU4WlhxRUNVSDA3WFQ4UTBJM1pW?=
 =?utf-8?B?TkJ4L21TOWNmY2xyQ3JIY0ZXVnRMdFJPZUo5SzZqSm9aTkFuSGxDc2luclpj?=
 =?utf-8?B?OG9sc1pkd3h1SFI3SlJONmZiMHY3MkwwbDJnM1A5elRxbW83QTBnb1Q3SDBm?=
 =?utf-8?B?am9YcW5QMmkzdTJ3aDNxelYyVXh6ZmZPUWVPWW12K1hoa3lKanZYS0MzSVBv?=
 =?utf-8?B?OTlkcjVuN1BjVlVEUjltTzQvTGZ3a3pUL0NRUjhIZDNEbG15ZURkbXhlS2NI?=
 =?utf-8?B?TU1pYmhJZVZEdHdxeW9VYUxSdlpKSk1POXFrZkRnakhoQTM0a2tYcVY1ZHQv?=
 =?utf-8?B?Ymc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D014D73DD10D941BFF314A15B679556@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d097028c-6238-49b1-4e48-08dc007f1e90
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2023 10:41:55.3165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yDeCUjvS98pDJiSF5CGTs6fUVOhbYovAZ6GCFep1a1Ah7MVjKFWmLirdpn9FXaLO5U4a1iiw3GGK/gcLbXmSWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5862
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTExLTA3IGF0IDA2OjU1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBTb21lIFNFQU1DQUxMIG1heSByZXR1cm4gVERYX1JORF9OT19FTlRST1BZIGVy
cm9yIHdoZW4gdGhlIGVudHJvcHkgaXMNCj4gbGFja2luZy4gIFJldHJ5IFNFQU1DQUxMIG9uIHRo
ZSBlcnJvciBmb2xsb3dpbmcgcmRyYW5kX2xvbmcoKSB0byByZXRyeQ0KPiBSRFJBTkRfUkVUUllf
TE9PUFMgdGltZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3Uu
eWFtYWhhdGFAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvdGR4X2Vycm5v
LmggfCAgMSArDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3RkeF9vcHMuaCAgIHwgNDAgKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDI0IGluc2Vy
dGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2
bS92bXgvdGR4X2Vycm5vLmggYi9hcmNoL3g4Ni9rdm0vdm14L3RkeF9lcnJuby5oDQo+IGluZGV4
IDdmOTY2OTZiOGU3Yy4uYmIwOTNlMjkyZmVmIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
dm14L3RkeF9lcnJuby5oDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4X2Vycm5vLmgNCj4g
QEAgLTE0LDYgKzE0LDcgQEANCj4gICNkZWZpbmUgVERYX09QRVJBTkRfSU5WQUxJRAkJCTB4QzAw
MDAxMDAwMDAwMDAwMFVMTA0KPiAgI2RlZmluZSBURFhfT1BFUkFORF9CVVNZCQkJMHg4MDAwMDIw
MDAwMDAwMDAwVUxMDQo+ICAjZGVmaW5lIFREWF9QUkVWSU9VU19UTEJfRVBPQ0hfQlVTWQkJMHg4
MDAwMDIwMTAwMDAwMDAwVUxMDQo+ICsjZGVmaW5lIFREWF9STkRfTk9fRU5UUk9QWQkJCTB4ODAw
MDAyMDMwMDAwMDAwMFVMTA0KPiAgI2RlZmluZSBURFhfVkNQVV9OT1RfQVNTT0NJQVRFRAkJCTB4
ODAwMDA3MDIwMDAwMDAwMFVMTA0KPiAgI2RlZmluZSBURFhfS0VZX0dFTkVSQVRJT05fRkFJTEVE
CQkweDgwMDAwODAwMDAwMDAwMDBVTEwNCj4gICNkZWZpbmUgVERYX0tFWV9TVEFURV9JTkNPUlJF
Q1QJCQkweEMwMDAwODExMDAwMDAwMDBVTEwNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92
bXgvdGR4X29wcy5oIGIvYXJjaC94ODYva3ZtL3ZteC90ZHhfb3BzLmgNCj4gaW5kZXggMTJmZDZi
OGQ0OWUwLi5hNTU5Nzc2MjZhZTMgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4
X29wcy5oDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4X29wcy5oDQo+IEBAIC02LDYgKzYs
NyBAQA0KPiAgDQo+ICAjaW5jbHVkZSA8bGludXgvY29tcGlsZXIuaD4NCj4gIA0KPiArI2luY2x1
ZGUgPGFzbS9hcmNocmFuZG9tLmg+DQo+ICAjaW5jbHVkZSA8YXNtL2NhY2hlZmx1c2guaD4NCj4g
ICNpbmNsdWRlIDxhc20vYXNtLmg+DQo+ICAjaW5jbHVkZSA8YXNtL2t2bV9ob3N0Lmg+DQo+IEBA
IC0xNywyNSArMTgsMzAgQEANCj4gIHN0YXRpYyBpbmxpbmUgdTY0IHRkeF9zZWFtY2FsbCh1NjQg
b3AsIHU2NCByY3gsIHU2NCByZHgsIHU2NCByOCwgdTY0IHI5LA0KPiAgCQkJICAgICAgIHN0cnVj
dCB0ZHhfbW9kdWxlX2FyZ3MgKm91dCkNCj4gIHsNCj4gKwlpbnQgcmV0cnk7DQo+ICAJdTY0IHJl
dDsNCj4gIA0KPiAtCWlmIChvdXQpIHsNCj4gLQkJKm91dCA9IChzdHJ1Y3QgdGR4X21vZHVsZV9h
cmdzKSB7DQo+IC0JCQkucmN4ID0gcmN4LA0KPiAtCQkJLnJkeCA9IHJkeCwNCj4gLQkJCS5yOCA9
IHI4LA0KPiAtCQkJLnI5ID0gcjksDQo+IC0JCX07DQo+IC0JCXJldCA9IF9fc2VhbWNhbGxfcmV0
KG9wLCBvdXQpOw0KPiAtCX0gZWxzZSB7DQo+IC0JCXN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJn
cyA9IHsNCj4gLQkJCS5yY3ggPSByY3gsDQo+IC0JCQkucmR4ID0gcmR4LA0KPiAtCQkJLnI4ID0g
cjgsDQo+IC0JCQkucjkgPSByOSwNCj4gLQkJfTsNCj4gLQkJcmV0ID0gX19zZWFtY2FsbChvcCwg
JmFyZ3MpOw0KPiAtCX0NCj4gKwkvKiBNaW1pYyB0aGUgZXhpc3RpbmcgcmRyYW5kX2xvbmcoKSB0
byByZXRyeSBSRFJBTkRfUkVUUllfTE9PUFMgdGltZXMuICovDQo+ICsJcmV0cnkgPSBSRFJBTkRf
UkVUUllfTE9PUFM7DQo+ICsJZG8gew0KPiArCQlpZiAob3V0KSB7DQo+ICsJCQkqb3V0ID0gKHN0
cnVjdCB0ZHhfbW9kdWxlX2FyZ3MpIHsNCj4gKwkJCQkucmN4ID0gcmN4LA0KPiArCQkJCS5yZHgg
PSByZHgsDQo+ICsJCQkJLnI4ID0gcjgsDQo+ICsJCQkJLnI5ID0gcjksDQo+ICsJCQl9Ow0KPiAr
CQkJcmV0ID0gX19zZWFtY2FsbF9yZXQob3AsIG91dCk7DQo+ICsJCX0gZWxzZSB7DQo+ICsJCQlz
dHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFyZ3MgPSB7DQo+ICsJCQkJLnJjeCA9IHJjeCwNCj4gKwkJ
CQkucmR4ID0gcmR4LA0KPiArCQkJCS5yOCA9IHI4LA0KPiArCQkJCS5yOSA9IHI5LA0KPiArCQkJ
fTsNCj4gKwkJCXJldCA9IF9fc2VhbWNhbGwob3AsICZhcmdzKTsNCj4gKwkJfQ0KPiArCX0gd2hp
bGUgKHVubGlrZWx5KHJldCA9PSBURFhfUk5EX05PX0VOVFJPUFkpICYmIC0tcmV0cnkpOw0KPiAg
CWlmICh1bmxpa2VseShyZXQgPT0gVERYX1NFQU1DQUxMX1VEKSkgew0KPiAgCQkvKg0KPiAgCQkg
KiBTRUFNQ0FMTHMgZmFpbCB3aXRoIFREWF9TRUFNQ0FMTF9VRCByZXR1cm5lZCB3aGVuIFZNWCBp
cyBvZmYuDQoNCldoeSB3ZSBjYW5ub3QgdXNlIHNlYW1jYWxsKigpIHZhcmlhbnRzIGRpcmVjdGx5
IHdoaWNoIGFscmVhZHkgaGFuZGxlcyBydW5uaW5nDQpvdXQgb2YgZW50cm9weSBlcnJvcj8NCg==

