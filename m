Return-Path: <kvm+bounces-2845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 344817FE8EA
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 07:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66E4B1C20CEB
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 06:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9641D55C;
	Thu, 30 Nov 2023 06:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aC+u6x+L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C1BD66;
	Wed, 29 Nov 2023 22:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701324113; x=1732860113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OQH0nvmEJSvasFIaO1fOumPkczomqch7ZkEg2gd4lN0=;
  b=aC+u6x+LuRphhD5zq+9NXrxHERVMQp6V8EbZ8n0EhkyzcNs+XlwRYwdt
   gDfQ0PMsN2uGhBoUTKsvNYHTu4NqgzLhq9ZtVzlOlkFStT8VH+i9bv41x
   iSR9ern92BoV0MX/5f2A2PwX95h7epff5byofjXZLlgB0aBA08A4eUQqy
   m0DoVXu0RIBt8bei/zbi66l6ikqREVLy1bdDB6xfnP8AE42/bTV9qRcbD
   0WCuPzrUQnKIB5681Hc8P+J2D5M5f5rkotWhcUlvgdVEaYjXSG/62qpvV
   q3tNlVUksqw69rOtjA79g5XNMESbRQn422UizUnja1u4iw9kF8IOkkJlh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="397166402"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="397166402"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2023 22:01:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="892699411"
X-IronPort-AV: E=Sophos;i="6.04,237,1695711600"; 
   d="scan'208";a="892699411"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Nov 2023 22:01:52 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 22:01:52 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 29 Nov 2023 22:01:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 29 Nov 2023 22:01:51 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 29 Nov 2023 22:01:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2Tb+VzD5d3XP4bpgKI4pyd7iYsHLR1A8zDsDxyHeOx4U95bnWZie1c7sLQ28sSUwzpQdclwd3Bd87d1QcW/fgE7c2V0RhBGCQKue/rJsHcafzuz76Rb62grqfsr8wi256BPG18irK3Uix0V7EfoU8gNTPETtYb40WUKp6anosqH+z+0QFtbnpR678PMdnFPpJwE7fVdO/uR0Ai24UrD9VwtjBMPi97pmulbqntfeKJM27nfWN81q7FkeqaZTYlr16W3hCeQB64G/Ep7NUOYpUkCelq65Jd/FIwDeSdhUDgGBjqZUjRimD61Mz+/CqnzmvCm4a73Etjy6UGOAm2sVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQH0nvmEJSvasFIaO1fOumPkczomqch7ZkEg2gd4lN0=;
 b=YEAK3RGg8VacNN+bq572Wjdg98LZ0Mz4MLHuJAU/c58MLzvdLgpitWJQAxBCGgv6Pv/eFc8hp7TXZOxQpabrSh7JbB4DghffwTdK6kF2q4v18m6WciqH1ExIlFcNGtSEkYoX+IQ8TErT7AMxuBcLY0fvtksE5yrx7AmKCbZJR6XSL2FMZj7NHMas1EWXwjZYhGMC43snc3WTnlMBgNgBWjfjBp2e+AVReIsk//EvqIKnnmIFXCzLB6/vFL1lgaZp2TtuSFgYm86rPNdKe2UNZ+Qs1AkOiaNUsuJ3VY/vS/CxWuRPtnK9SCQ/J8+B0UnFyfG8lX6tZr1Om3JQBhcHrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SN7PR11MB6677.namprd11.prod.outlook.com (2603:10b6:806:26b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Thu, 30 Nov
 2023 06:01:42 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.7046.023; Thu, 30 Nov 2023
 06:01:42 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "Li, Xin3" <xin3.li@intel.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Lutomirski, Andy"
	<luto@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Christopherson,, Sean" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gross, Jurgen" <jgross@suse.com>, "Shankar, Ravi V"
	<ravi.v.shankar@intel.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: RE: [PATCH v12 02/37] x86/opcode: Add the WRMSRNS instruction to the
 x86 opcode map
Thread-Topic: [PATCH v12 02/37] x86/opcode: Add the WRMSRNS instruction to the
 x86 opcode map
Thread-Index: AQHZ9caNSRx22/0yzUeT4gY0IluMT7CSuCFQ
Date: Thu, 30 Nov 2023 06:01:41 +0000
Message-ID: <SA1PR11MB6734FFBF0BE0CCC7532C2505A882A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-3-xin3.li@intel.com>
In-Reply-To: <20231003062458.23552-3-xin3.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SN7PR11MB6677:EE_
x-ms-office365-filtering-correlation-id: c08f1d2b-35a9-4d61-2be6-08dbf169d32d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TFRUNe31D7vVoVgVLE+Kbom2vwVKUpnUkidp9KDdYw46D5LDR6Dubx7t3YEmIhnHyGdqRDDKydcr25n6/3FdEeTC0DWoLeKlyuKugJMP4WGHdAiRtxzWLPpaToUQCm4c/FQkEYp6oXa6B+OVTNa2MujfrnBwwhPiUTC4b2rWX12FHZ3AYUl67yFJr365/imMuWOIomqMIesVXgByBcQCoReCK+UlsacWehP2eH94rlYWBmsCKf1rn+TJGTu1aCWLz89w1hc8wWOrE+jZfx84niB5QzREPnigqPMxdjBVTrY6zUzyy/BEySisDcy6KGee8md4aH/INaz7HKjkpEMSHVS9sb2/CplqZzk7r15fAWgflNvA2nm0rDzaeK0imGEdqr8iCd4Nncanv1Qyj60qNFRPJioBXHa8atYoaAwKxzodV8vt7MGtd8rMu8XIj5l14XAZHXbDwCUTnFB+oO/Xs4R5+O533q3yDxhe2sEjCd35hI0BMPLo5JkjqLb7mrYNrEc/yLtuysMRAjnrp4WMUCBjndpwcEubKwH35FBBK/7dTbSP9cRZE1z56N9OazSXjy+8vEdjBGaEGHQfssukqF84BMdaUdxuG+cCw9cxDIZFbVB5LPkRBl/9MQGbP+tu9PCvWdPfE9KwY1vLRw/GAWNiyEcn8kpJsKSumKbcglk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(346002)(136003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(26005)(83380400001)(6506007)(7696005)(9686003)(122000001)(5660300002)(4326008)(8676002)(52536014)(8936002)(41300700001)(4744005)(7416002)(2906002)(966005)(478600001)(316002)(110136005)(71200400001)(54906003)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(202311291699003)(86362001)(33656002)(38100700002)(82960400001)(38070700009)(55016003)(133343001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajZieWlzQVVtWVNLT1JEWWIvTlBtOGw3b3ZjK3Jka0VaU081QVcxaStReDNh?=
 =?utf-8?B?Sy9SWWdPWmhESU1GZUxpTVk2Vk5NY1dQNUw5cGE1T0IwMWRhYlZBM05lUEI1?=
 =?utf-8?B?WXRBZU1XdWJhZUFDcXIrenovcDRPclp2RndXK1llUzlxdmE0dmp5WDVta2hB?=
 =?utf-8?B?SUl4Q2xYSTlMWStFMjFyU296ZXJNQnl2K3R4SDhuOU5vUkRBVXNBM01Ec2xa?=
 =?utf-8?B?Zm9xN2ZnSEMwSDRYcnpKOVhzQm1KVFFKdi9QdFJRZUhRNDRzeXA1YTFwMHZY?=
 =?utf-8?B?TU1uckxQUGtIUG1SN3duQUlFWkpWSVRoeUIrd1hvL3ZjeHdkSFJKOXpmUEN2?=
 =?utf-8?B?bk9aUVJqWWNWUDFEdmxoVXhLNGxzOXRweHJqWFlYM3FnSGErcS9FN3pkYzQx?=
 =?utf-8?B?NkhlUnNlKzNxelFoQkxIUzZPd2t1Rm5Gbkh4MHZVRlhvTWIwdGRUSzQ0ZjdT?=
 =?utf-8?B?OVNUVm5vclhnd3lDZG9mTlN2eG9rWm1XditqS3UzQ0ZJcUxDYjdtWG9iTGJx?=
 =?utf-8?B?NUZBeUFYcWxDRUxtTFlrbEp4d1NCSVJOUHVhVmUreXhBWjFZOWh3bmloOEE1?=
 =?utf-8?B?MWFQQUI4MFd2L0VNOWxJbXVPZDRKS1lESVF5STQvZ3cxU3lZRyt1a1JDTmRq?=
 =?utf-8?B?QnRNL0FCUUhsY3h2WVp1OTk0MS9ZVHAzMUZpUmk0MUMvVHJ3QUdjMFZvbnlM?=
 =?utf-8?B?Z1QrUDhNV3M3SmV2Qnk5NlZXWW5MZXhjbFlNLzl5NGFpNVlLTGdTOWlqM3Z2?=
 =?utf-8?B?Y1N1c2lGQ3I2UzlvaDJQQkIrdkZlKzBFVnJFYXQ2NGkxeWxTOXh3TTdsbmFX?=
 =?utf-8?B?QTBRYmFGcFp4SFRtTm10dVZzWCtwd2pSVUlieGJsM3BJQittVnp6NjRQQ2Rj?=
 =?utf-8?B?eSt1di9QMk9GM09PSEZKMkMvYzNUUUYvcEdQL1IydUNzT1NPOGVkZVpIYUNz?=
 =?utf-8?B?RWMzM2dJSWNEK0d2MlE1NFVuWHVoNzkxSWxmaDNYL1ZkVnBVbGhmQ2FTR0o5?=
 =?utf-8?B?MUFTUk5jTWVBUkpGWGlXa2xsSDBjVHErOGlxTjhEQWxuM0JHOCs1QStCSGRq?=
 =?utf-8?B?WWNDS1FqR2lVL05MU0c2alMrc3hLVXRCT3pUdElhVERRSGowNFNLMEtObmJ4?=
 =?utf-8?B?V3k2OTlJK0FTUmxHcy90SFVMdG5zckNqVTJXbFJFbHJKU3hlbGZWS2d6RDlK?=
 =?utf-8?B?V1FGYTBjek85OWRqaC9YWnBhanBtbm5lcTlURVc1SnFDeEJTSmEwT0hGSU44?=
 =?utf-8?B?MTNEYUFmbDczN2F3ajhyTDlRQ1VCQXVXelZmbzlRL0hsbUpad1d1eWFpWGJI?=
 =?utf-8?B?emZmaTJqRzEvUkJ6dVA4aGxpblpZS1FCRytjTWViYTk0c1UrUTc5K2JaTk9K?=
 =?utf-8?B?enZrYTFBaHREWTN2NVI2em5aNDZucjZEVFJyKzE1TnlVWFl5VFNvM2w3Sytr?=
 =?utf-8?B?bWtPcDEzOWE5SGNObkhzMEFsVlNJNnB0YWYrd1gxVnNOMHJvV3hWdEtlaHFa?=
 =?utf-8?B?OFY2eVNqSzJ0em4zSm5RenZWbFd1TEwyOEcvSVgvVSttbzVVUUZUVE1ESmIx?=
 =?utf-8?B?eTdLN215RHQ0d1RLbjNGTjNCd1N3a0VUaWEyMVNmMGp3VUlIRXpLalJDNmdn?=
 =?utf-8?B?akNncU9lem9YUi9ZS05vcmhaSjR4eFd3RE1nMEtKQnBYVlpaVEZDd1lDaTBk?=
 =?utf-8?B?Q2JJeDZCOURJdGExcXdlTHpqWmRaVUJjRXNhaHNVMzQzaEE5SVhIdlFmUHZn?=
 =?utf-8?B?TGdrV3RwQ1AzOHE2dXlHNXIwM2ovOXdUakRkRld6NWRMamVRQmlSajQ4MkxU?=
 =?utf-8?B?b2M0blBjNWQzcjFpU3kvYVFQTm5HWmpIQjE5L2h2VnZ4Mkx1RFpMWkE3NWZw?=
 =?utf-8?B?dU1lUlVCalRWb0t2ZmphRHNQTmp4VE9RYW45bXB0bEoxWmNjQmFBRXpyY1h6?=
 =?utf-8?B?dnNJM09nc25idnhHV3FzdjVRK2ljaXNBYUY5dG1nNFMzdG9ITXJvYTdwbW4w?=
 =?utf-8?B?elNCR3NvT0FoRUd6QTdYVlpBcnh5OWJlVCt0Mk1HV0hzdThZWE51UC9FTFRw?=
 =?utf-8?B?bVpoS3A3djZ3VjI3SGNWM2xaeGNqUmF6OUNSbG5sVnJPZmphaUFRc2VDOWpl?=
 =?utf-8?Q?ZvZw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08f1d2b-35a9-4d61-2be6-08dbf169d32d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2023 06:01:41.9607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ueZgCKrh2BKcoTuAHXRNZWTShdBNzYIqtxArp/3ASZC+XHP78B6JtcTYEW5b7VQssVvk8jvpKVF3Pw3Jq85GKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6677
X-OriginatorOrg: intel.com

PiBBZGQgdGhlIG9wY29kZSB1c2VkIGJ5IFdSTVNSTlMsIHdoaWNoIGlzIHRoZSBub24tc2VyaWFs
aXppbmcgdmVyc2lvbiBvZg0KPiBXUk1TUiBhbmQgbWF5IHJlcGxhY2UgaXQgdG8gaW1wcm92ZSBw
ZXJmb3JtYW5jZSwgdG8gdGhlIHg4NiBvcGNvZGUgbWFwLg0KPiANCj4gVGVzdGVkLWJ5OiBTaGFu
IEthbmcgPHNoYW4ua2FuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFhpbiBMaSA8eGlu
My5saUBpbnRlbC5jb20+DQo+IEFja2VkLWJ5OiBNYXNhbWkgSGlyYW1hdHN1IChHb29nbGUpIDxt
aGlyYW1hdEBrZXJuZWwub3JnPg0KDQpIaSBNYXNhbWksDQoNCkJvcmlzIHByZWZlcnMgdG8gbWVy
Z2UgdGhlIGZpcnN0IDMgcGF0Y2hlcyBpbnRvIG9uZToNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xrbWwvMjAyMzExMDgxMjM2NDcuR0JaVXVBMzF6bnRveDBXMGd1QGZhdF9jcmF0ZS5sb2NhbC8j
dA0KDQpTbyBJJ20gdGhpbmtpbmcgY291bGQgeW91IHBsZWFzZSBhbHNvIGFjayB0aGUgb3RoZXIg
MiBwYXRjaGVzICgxc3QgYW5kIDNyZA0Kb2YgdGhpcyBwYXRjaCBzZXQpPw0KDQpUaHVzIEkgY2Fu
IGtlZXAgeW91ciBhY2tlZC1ieSDwn5iKDQoNClRoYW5rcyENCiAgICBYaW4NCg0KPiAtLS0NCj4g
IGFyY2gveDg2L2xpYi94ODYtb3Bjb2RlLW1hcC50eHQgICAgICAgfCAyICstDQo+ICB0b29scy9h
cmNoL3g4Ni9saWIveDg2LW9wY29kZS1tYXAudHh0IHwgMiArLQ0KPiAgMiBmaWxlcyBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo=

