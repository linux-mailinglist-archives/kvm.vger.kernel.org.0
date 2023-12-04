Return-Path: <kvm+bounces-3420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F1AD8042F4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 00:57:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02C1A1F21397
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 23:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164473B293;
	Mon,  4 Dec 2023 23:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kp1mjpXt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DE4F0;
	Mon,  4 Dec 2023 15:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701734217; x=1733270217;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j7uCfJYXCn0Uc4JyOegCbNqoQfQnl9WdwtFYrgkok+0=;
  b=Kp1mjpXtV2y9FoI/k/qBIc91DmHICtzG+VCszsHvfPiU8FGCJE0ZWLpT
   PyWmV1coSIUnRgQb7x2L3rZOgnnjCiBeq9pHrIAj1dpXtzmaAvJXYzKmm
   8cAl5z9r2j6juZMPbPi8X8YGTdDsu7i2hKejyfkmb+1PWMwiIWtowBVRx
   AKz3/hlbktqE/OfK6fvl+wI2aianefYrinWd4Lt+XuGgzmDVLWyn65OAq
   ThiNmVMjxCflP09j0ePpK2GvVW6aWMqtwHinGhn2gNo6VJJXc7N8Ulesp
   GGRPHG2B7FnUvsmctOQOyncaswZLHh7gknTOw7PWRIBX53QyIy6Rl1BGZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="393550753"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="393550753"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 15:56:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="764131957"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="764131957"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 15:56:56 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 15:56:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 15:56:55 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 15:56:55 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 15:56:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmdIcm5saX/3UxqrYuoze7cT9U+dbpLH1U/rAgEyc8RYY28zZ8YcrkqH3Wbee0GLHI+vQopGx3w0PZFV9iSe/F/hcRf82PHGtgvM0ISPcnw/LRLW6lAM/vtUVrCdfc6ovzPs44qXGp/8wAkdT2E1r6Nw64Pw5C15XfoA1hKN7NYBFAr+wMZTvUn9buqJS/yJFBCabK9RAmTX1e9mwNb6VTHo55dZLv6UFPr9h+xWL8ipvsJdDiY4+fqMmMcFyfKwDFYA8TTVNn7UHXlmcZgVN+wm7MFhW5OIXssOAyISNp8vzBq6NlnsvuIvCIQRiAIIGM+HIyOm8zQei8v+WT5IUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7uCfJYXCn0Uc4JyOegCbNqoQfQnl9WdwtFYrgkok+0=;
 b=ilW7UYulDNKLyqm9LSrd77tAnLrkPdaX2wqeHsvsjbelTnrlvTxNSPAAwykMOT5DEo92G6Qb+graXA+DYWY7UaTz6PlgqDZjLGNxj/E4GjpTKl2ZzpDaTof+s/xQHvleyDvkTOGJDL41G2Aw0jzwNiVN0pymeVXRm8QYGJGUkWH/oYe0rf0gDKbfsE9/swzk0jttDu7U6IwUBx7SlB2S4A6mudF8qZGhrgP+8wrPLG4zkv3xSftTxX1qyLISJpdhDJN7s6Kya8w5WI6b/UM9KHVFXlVYIx7RQ+WSnzNK7DJ1+mNH9msubhbM4sLPcrm0lWMEbd5L0wKfbn5KpdR6Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5448.namprd11.prod.outlook.com (2603:10b6:208:319::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 23:56:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 23:56:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Huang, Ying" <ying.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Luck, Tony" <tony.luck@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org"
	<rafael@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Brown, Len"
	<len.brown@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCVBfCAgAKQDACAAeyrgIAAQREAgAASGACAABYpgIAABCcAgAAE8gA=
Date: Mon, 4 Dec 2023 23:56:53 +0000
Message-ID: <9e31b17547c03b89d71992db192028a41a373e0b.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
	 <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
	 <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com>
	 <dfbfe327704f65575219d8b895cf9f55985758da.camel@intel.com>
	 <9b221937-42df-4381-b79f-05fb41155f7a@intel.com>
	 <c12073937fcca2c2e72f9964675ef4ac5dddb6fb.camel@intel.com>
	 <1a5b18b2-3072-46d9-9d44-38589cb54e40@intel.com>
In-Reply-To: <1a5b18b2-3072-46d9-9d44-38589cb54e40@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5448:EE_
x-ms-office365-filtering-correlation-id: d2683721-fcdc-4b97-c68e-08dbf524b08d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +nNx+DR+uiaEFeZkXcnbf9ovH7vuD/GfbeDR0GSXo9KubNTg5KU3wSWOyEEFcZKGxF+A9jAwjPu4kjlTw/8sJ0HL3aSK/hMBu/81vu9fo7zc4R2CPXVM8HMm3CFo7IisWMoppGMBdZ1B22EkinUKPjOsGok5XTLIrEPIion+b4BSQXroQQnipIadoEXBhDs9NwbIOuJmLk/Umbbj6YImma9zwyyQOSfCrGr0/cYo8jQ3b853EnHLwg6skf9d/V2xkNlSkV9q0tlp8J8WK4AZpIKcqzaEWdQR1q8zQ6TkTIYAbC5a/GyKCPBhuJESfQ7ZdQEZq8SNt1GIo64kNnKilDUCeXBYASb0YeHtCgvOee75cRlKpLI8Ie5KlZ0yBm7rfH4bRCQ8XEInW5o4rzrEXfPSafr63u+CDkCatQ7JJ1x+S7iU4D6GNqN2/OLnPxDjhA6GnOmbLiF5Fn6tkYOmPBs5/n26VBlFej0J8qODnVB66x9FZGTPMvCkMp6hmPgeny/oQ7PC0v83dcKTWOu1YzEa16CHvrtgqj6v5gdU9O7vgE64cF+892UA2WvGDVYXk4tbZv7huzTA/Vj8A3l2H4iUDHjXa1vyswUZpT/LIFdX+znDP4tAwJJ0RJDIODS5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(66899024)(82960400001)(2906002)(5660300002)(7416002)(36756003)(38070700009)(86362001)(41300700001)(6506007)(71200400001)(478600001)(6486002)(6512007)(53546011)(38100700002)(122000001)(83380400001)(26005)(2616005)(8676002)(4326008)(8936002)(76116006)(66476007)(66556008)(66946007)(66446008)(110136005)(91956017)(54906003)(64756008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alFhejdKVXFYUFNZK3ZkYUU2cmVrcXExZmtvYm8reTFHTHV6eFdyc3luYkxo?=
 =?utf-8?B?eFRQQ0tkdFNPY2xSdHJrTUU1L0NJZE9rems4elN5eUc4d0pYVEJvK2tQODA4?=
 =?utf-8?B?V1l1MVBWL2YzeHcwTTd4NnJPYnRXSmNLZjJKTFVLUnJzeHJNMXV6aHB3ekt3?=
 =?utf-8?B?UkdUWElFL0VZNmllUStmaUJpMWgyWlY1YlRhVm83cWZaS2ptQStuVCs1MTdl?=
 =?utf-8?B?ckFDaUIvN01jWG9uajJWSnN6TmlVdWlpRFBMaEprNDRRVDMvS2hwcXVuZ09J?=
 =?utf-8?B?dTc1Rlo0RFphUkpkckJKVVgzdEdNYTZvL01uM3lyN3RJL0x4Vk5qOGhoM1Jz?=
 =?utf-8?B?dTVhejJha1ZsbXhGZDl1Vys0N3dBWXhRSVk1QklQaTVlVGEyTGNRdW9oY1JL?=
 =?utf-8?B?a3lYdmprL25ycTdLU2ZGNXZwWEV1RUpHMTkxcEFmQUlFdkhkRVRhYk9GTTFw?=
 =?utf-8?B?cndhcGR6YzRSK2hnRkJjRllQQWwrWEgrY2lCMGx5eTM4VmpOU05ZKzRlbW9l?=
 =?utf-8?B?SFZMTnZIemdERHMrSEVNeFU4YXgrTkVrdTcra25pV08yNkJFOHRqN1gzdzVw?=
 =?utf-8?B?a09ra1A0dkE1QnVQRnVZdWdvTHZ5ajl1UThxWXh3VkpmUVd4aTRVL3ZyZFRL?=
 =?utf-8?B?NWdYOVV1blgxUUtINTZhQ05QeFdOTmp3RmdESWFVT0tlSWlMbjFZQzRnUVFH?=
 =?utf-8?B?bjd1alVzMWp2T3NEalQvVFFGc1dGdWxaQkthbmMyZ2M3U0s3R2dqTkx4MExL?=
 =?utf-8?B?NzVTbDl2a2FQd3pHL1c4cDg5d1dTNGR2dFJ3VjkrUjM4L3pIekhxZVV5TGpt?=
 =?utf-8?B?cDhUbnRZaFlGR2NPekEzNGFVR2gvdndDRHVic0dJdlY0Mm1EakU0d3B6aHhz?=
 =?utf-8?B?Q2k2QVcwakgrMTVCaFpSSkdOQmJoekhldUtWdTdiMGFEZzVia2NrMytEUVhF?=
 =?utf-8?B?MWpVTE04U253NUpjTUVBdElpZzUxUmdVd0FXVXhmbFlwMUZBb1YyN3ZhV3Er?=
 =?utf-8?B?ZENFS2VReEdmMDBFTG9ETTZIRXAzVHVLdlBIbUVXS0xEd3hzZFhYK0dZMXV3?=
 =?utf-8?B?RGJUMkNDL0hZNmNTV0trdC8vWXNNOXdTalMvQ09hTnNqWGl3MXlXQlRMRGNz?=
 =?utf-8?B?WCsvekV4SEtyQ3FnM0lGNUtkZ1RwZWV0WWF2TDVaU0tWV0t3UjVIQ0ZiUEFs?=
 =?utf-8?B?dWxMM2R1QTJhTytqOHRrTURpeTFROEdiZHFjbVdSZWpWdnNXMWNtOWI2NHBU?=
 =?utf-8?B?Sjc5N2N5TGxaZHVLaEt5U3NINS8zcnBjVnhWOXlEOXZCV1dsMldqSUVnejFM?=
 =?utf-8?B?Z3Z6STAvOVFxb1hwVEV3ZmpqSkZnb2I2cjVRSzRhVzRZYWN1K2dlSzVNaTJa?=
 =?utf-8?B?WFJJcXRaS3p4NU8vTmR3b01xVXZreTdSbWIrVnZqc1MzRVhLdEFWcU11T29x?=
 =?utf-8?B?a2VEcExCQ2JJWmJNSzNOMnBjL01reW1McWpzTm1wWkdCdklvK1RaUHNCTWhw?=
 =?utf-8?B?bExZUEJ2UXhqZVpIbVk0elQ1MGh1L1hJTWRhdUpwTytxUUo1NHRROTdBOW9E?=
 =?utf-8?B?NXpydEpsNG1pYVpBVHZiaWFXaHV1YmJYVEllTTd2ODFkK0tZWk9aTnBpNXM4?=
 =?utf-8?B?eFNpRnRTZ3lLNHk0VkdFSXlGZGlHOE85TFVaZkk1R3pCQitNYkljZ29MSDBK?=
 =?utf-8?B?dlVtdmp0YlN1MDk5WEtWWENFZHZKVnR6MlBua1RoazZvVjR6N0F1QlVKTjRj?=
 =?utf-8?B?ZXlDWXZWd3M5dlpKbzdBWlBMSzFoMmxNdEIwczBKbHM0VHdLVTBiS1dZUE1s?=
 =?utf-8?B?OGw5YkI4dVVrM0QwTFdUZUZlbGJtZUsyWWdwVTVOSzQvZEVhTGhYdHdrYXU1?=
 =?utf-8?B?Y1prOG96T2hzQm0wVU9xTlh5OFRKMTkrSXRqa1lKQTBIY1hJNUdMTUhtYTgx?=
 =?utf-8?B?RGtBcktjVXZqUEE3aGhtc2wyNmt2TnlWREJZcGlWOG5rWjdpc0pPYnFGais2?=
 =?utf-8?B?K3FEMWhhajRrYWp6dlBkKzJwNGpGVFl1RFN4NTVwSW1aSFZKUWpWckNXc0Mx?=
 =?utf-8?B?Ukl0Q0hjUHR6Q3JneUVjSGVudUNzV0FiOEFwVkczRFhQQnFDQmtUc2NKMG8x?=
 =?utf-8?B?aFpTWnNrL05LcTdHREpKYk5saEZUbVVtUGdMU1llbzNUbFZwVW5wTlQ1R29T?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B48D55F1AABA4F41ADFB865C208AAB99@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2683721-fcdc-4b97-c68e-08dbf524b08d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 23:56:53.2162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yTKkaLHco6k2ZVuS8D0bsdb7wXiF0+bjePTid9vL92zLNLB7sUpUIFADqpXOorLCT3R7BjPgChuyScicSz+YPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5448
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTEyLTA0IGF0IDE1OjM5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTIvNC8yMyAxNToyNCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjMtMTIt
MDQgYXQgMTQ6MDQgLTA4MDAsIEhhbnNlbiwgRGF2ZSB3cm90ZToNCj4gLi4uDQo+ID4gSW4gYW5j
aWVudCB0aW1lIEtWTSB1c2VkIHRvIGltbWVkaWF0ZWx5IGVuYWJsZSBWTVggd2hlbiBpdCBpcyBs
b2FkZWQsIGJ1dCBsYXRlcg0KPiA+IGl0IHdhcyBjaGFuZ2VkIHRvIG9ubHkgZW5hYmxlIFZNWCB3
aGVuIHRoZXJlJ3MgYWN0aXZlIFZNIGJlY2F1c2Ugb2YgdGhlIGFib3ZlDQo+ID4gcmVhc29uLg0K
PiA+IA0KPiA+IFNlZSBjb21taXQgMTA0NzRhZTg5NDVjZSAoIktWTTogQWN0aXZhdGUgVmlydHVh
bGl6YXRpb24gT24gRGVtYW5kIikuDQo+IA0KPiBGaW5lLiAgVGhpcyBkb2Vzbid0IG5lZWQgdG8g
Y2hhbmdlIC4uLiB1bnRpbCB5b3UgbG9hZCBURFguICBPbmNlIHlvdQ0KPiBpbml0aWFsaXplIHRo
ZSBURFggbW9kdWxlLCBubyBtb3JlIG91dC1vZi10cmVlIFZNTXMgZm9yIHlvdS4NCj4gDQo+IFRo
YXQgZG9lc24ndCBzZWVtIHRvbyBpbnNhbmUuICBUaGlzIGlzIHlldCAqQU5PVEhFUiogcmVhc29u
IHRoYXQgZG9pbmcNCj4gZHluYW1pYyBURFggbW9kdWxlIGluaXRpYWxpemF0aW9uIGlzIGEgZ29v
ZCBpZGVhLg0KDQpJIGRvbid0IGhhdmUgb2JqZWN0aW9uIHRvIHRoaXMuDQoNCj4gDQo+ID4gPiBJ
dCdzIG5vdCB3cm9uZyB0byBzYXkgdGhhdCBURFggaXMgYQ0KPiA+ID4gS1ZNIHVzZXIuICBJZiBL
Vm0gd2FudHMgJ2t2bV91c2FnZV9jb3VudCcgdG8gZ28gYmFjayB0byAwLCBpdCBjYW4gc2h1dA0K
PiA+ID4gZG93biB0aGUgVERYIG1vZHVsZS4gIFRoZW4gdGhlcmUncyBubyBQQU1UIHRvIHdvcnJ5
IGFib3V0Lg0KPiA+ID4gDQo+ID4gPiBUaGUgc2h1dGRvd24gd291bGQgYmUgc29tZXRoaW5nIGxp
a2U6DQo+ID4gPiANCj4gPiA+ICAgICAgIDEuIFREWCBtb2R1bGUgc2h1dGRvd24NCj4gPiA+ICAg
ICAgIDIuIERlYWxsb2NhdGUvQ29udmVydCBQQU1UDQo+ID4gPiAgICAgICAzLiB2bXhvZmYNCj4g
PiA+IA0KPiA+ID4gVGhlbiwgbm8gU0VBTUNBTEwgZmFpbHVyZSBiZWNhdXNlIG9mIHZteG9mZiBj
YW4gY2F1c2UgYSBQQU1ULWluZHVjZWQgI01DDQo+ID4gPiB0byBiZSBtaXNzZWQuDQo+ID4gDQo+
ID4gVGhlIGxpbWl0YXRpb24gaXMgb25jZSB0aGUgVERYIG1vZHVsZSBpcyBzaHV0ZG93biwgaXQg
Y2Fubm90IGJlIGluaXRpYWxpemVkDQo+ID4gYWdhaW4gdW5sZXNzIGl0IGlzIHJ1bnRpbWVseSB1
cGRhdGVkLg0KPiA+IA0KPiA+IExvbmctdGVybWx5LCBpZiB3ZSBnbyB0aGlzIGRlc2lnbiB0aGVu
IHRoZXJlIG1pZ2h0IGJlIG90aGVyIHByb2JsZW1zIHdoZW4gb3RoZXINCj4gPiBrZXJuZWwgY29t
cG9uZW50cyBhcmUgdXNpbmcgVERYLiAgRm9yIGV4YW1wbGUsIHRoZSBWVC1kIGRyaXZlciB3aWxs
IG5lZWQgdG8gYmUNCj4gPiBjaGFuZ2VkIHRvIHN1cHBvcnQgVERYLUlPLCBhbmQgaXQgd2lsbCBu
ZWVkIHRvIGVuYWJsZSBURFggbW9kdWxlIG11Y2ggZWFybGllcg0KPiA+IHRoYW4gS1ZNIHRvIGRv
IHNvbWUgaW5pdGlhbGl6YXRpb24uICBJdCBtaWdodCBuZWVkIHRvIHNvbWUgVERYIHdvcmsgKGUu
Zy4sDQo+ID4gY2xlYW51cCkgd2hpbGUgS1ZNIGlzIHVubG9hZGVkLiAgSSBhbSBub3Qgc3VwZXIg
ZmFtaWxpYXIgd2l0aCBURFgtSU8gYnV0IGxvb2tzDQo+ID4gd2UgbWlnaHQgaGF2ZSBzb21lIHBy
b2JsZW0gaGVyZSBpZiB3ZSBnbyB3aXRoIHN1Y2ggZGVzaWduLg0KPiANCj4gVGhlIGJ1cmRlbiBm
b3Igd2hvIGRvZXMgdm14b24gd2lsbCBzaW1wbHkgbmVlZCB0byBjaGFuZ2UgZnJvbSBLVk0gaXRz
ZWxmDQo+IHRvIHNvbWUgY29tbW9uIGNvZGUgdGhhdCBLVk0gZGVwZW5kcyBvbi4gIFByb2JhYmx5
IG5vdCBkaXNzaW1pbGFyIHRvDQo+IHRob3NlIG51dHR5IChzb3JyeSBmb2xrcywganVzdCBjYWxs
aW5nIGl0IGFzIEkgc2VlICdlbSkgbXVsdGktS1ZNIG1vZHVsZQ0KPiBwYXRjaGVzIHRoYXQgYXJl
IGZsb2F0aW5nIGFyb3VuZC4NCj4gDQoNClJpZ2h0IHdlIHdpbGwgbmVlZCB0byBtb3ZlIFZNWCBv
bi9vZmYgb3V0IG9mIEtWTSBmb3IgdGhhdCBwdXJwb3NlLiAgSSB0aGluayB0aGUNCnBvaW50IGlz
IGl0J3MgYmV0dGVyIHRvIG5vdCBhc3N1bWUgaG93IHRoZXNlIGtlcm5lbCBjb21wb25lbnRzIHdp
bGwgdXNlIFZNWA0Kb24vb2ZmLiAgRS5nLiwgaXQgbWF5IGp1c3QgY2hvb3NlIHRvIHNpbXBseSB0
dXJuIG9uIFZNWCwgZG8gU0VNQUNBTEwsIGFuZA0KdGhlbiB0dXJuIG9mZiBWTVggaW1tZWRpYXRl
bHksIHdoaWxlIHRoZSBURFggbW9kdWxlIHdpbGwgYmUgYWxpdmUgYWxsIHRoZSB0aW1lLg0KDQpP
ciB3ZSByZXF1aXJlIHRoZXkgYWxsIG5lZWQgdG86IDEpIGVuYWJsZSBWTVg7IDIpIGVuYWJsZS91
c2UgVERYOyAzKSBkaXNhYmxlIFREWA0Kd2hlbiBubyBuZWVkOyA0KSBkaXNhYmxlIFZNWC4NCg0K
QnV0IEkgZG9uJ3QgaGF2ZSBzdHJvbmcgb3BpbmlvbiBoZXJlIHRvby4NCg0K

