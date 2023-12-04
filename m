Return-Path: <kvm+bounces-3415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DD3804286
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 00:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 030DD280EEF
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 23:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5052FE23;
	Mon,  4 Dec 2023 23:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lHioa4Ia"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D92C4;
	Mon,  4 Dec 2023 15:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701732279; x=1733268279;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E2djVI5i9xRzrWVvRtlubuPfb/eOMrGb7PzYaJ7jen4=;
  b=lHioa4Iag5L8W0JlmGxhoEYhFLww1Gmzt6W3uIc2wJyuctqOfJec5RjX
   qUzS3Y5yEkyN2Eeia+7JiWmawVHi5A2knAwLPpgHpw+n5oxUZQbV9+XRI
   IKQ3fR8UYTzDRx3ddqbpki5WBpgMDM9OtrSaWAOJD5JSMKm6X6Bes7R4v
   rT2W5OeZVLUJ/FI+DNfFUmSQWLwX2aUJcKdlcJwxCgsnWo5sQXEKI4nki
   gnTYObWJZu+tDaF7fbJae9DncjECrefynJ/lAXZTfmfBIGIeZGqLYgcic
   UWiKQRJUXHWxUM0Kw6lHf+wys+Tc5a/gunw/AWDrTlhCZ5Y1KQEo/neaF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="384216548"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="384216548"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 15:24:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="805063183"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="805063183"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 15:24:34 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 15:24:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 15:24:33 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 15:24:33 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 15:24:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0ocrtGK3qU3kNbepWlcLPBgnRFimskxHoukVpckgMIJblRI/StBI93WLT+aZZPX1wpJ+Vg6Ym1VgPD5m9WFW5w/wUVrmoKmPzfKNh9AKjyGlfM31zxyzX8lftef1tIIw9mbQGGkb73TONggyoU7nHejvgJdoKjW9X9wErvsjzKmj90N2LRhFf1Ot/rdoicV7iGqzNaR1T3nE7jfUqJH9DbJT+Xd82vADZnlziR3XBes0dgbosYycibujZqTnmeGH3i1VxDqoRqXlqYD8YGYul1jrMqf+xnJKIz0ZVeEAYtrymVp1fv/UjAGAn1ryntm38GwFdAFUD7ckHLeN2ZJXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E2djVI5i9xRzrWVvRtlubuPfb/eOMrGb7PzYaJ7jen4=;
 b=KQFXXb4AUEsNEqcSVHHn/nDbMukJiIqldc90ABXWFo6ZkcXVeTOniMo8HE9R0SKdg3qki2z7dekahOjL3wrZQ86HQyE4l+4KUxjNjuiq/tcVMOTgQ218cdwqg8agx8RM/z6gEVGCR5Ek9Luro4+onU/Jpc76yyFXWzmoVvao9fZpQaYr9Pa07aKCt/bS7kN+gPnU/lEgRezHC4hvA3G3O55wotL0gYX3PMLzIYNuvbRE0yfIg5d12J8aD9vRRbQ7uKFLb6AxpB+EkG8IIXq0hs3QdkCML9U88fXKWdcpHFgsDc1C7XfnbmQaB1Xm2nTh3ux5ZVyFjcOutpaz6dZ1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6330.namprd11.prod.outlook.com (2603:10b6:510:1fe::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 23:24:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 23:24:19 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "rafael@kernel.org" <rafael@kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"Brown, Len" <len.brown@intel.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Huang, Ying"
	<ying.huang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Topic: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Thread-Index: AQHaEwHtT+sYH5Rms0yY5S8b++o88LCVBfCAgAKQDACAAeyrgIAAQREAgAASGACAABYpgA==
Date: Mon, 4 Dec 2023 23:24:19 +0000
Message-ID: <c12073937fcca2c2e72f9964675ef4ac5dddb6fb.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
	 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
	 <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
	 <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com>
	 <dfbfe327704f65575219d8b895cf9f55985758da.camel@intel.com>
	 <9b221937-42df-4381-b79f-05fb41155f7a@intel.com>
In-Reply-To: <9b221937-42df-4381-b79f-05fb41155f7a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6330:EE_
x-ms-office365-filtering-correlation-id: 8be498d5-4408-40e7-e5da-08dbf52023d3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ccXlZ4ZK1FNtA511fmPIpVY4VS14J1eeaGsd5bK0jk46QfpYtDKRZoKhfqtd6rtsurQ5iXJi6qe0u7y5PK6f85d5L6od+b6BGmx191ewcBQxDAKY2NNKzIrG2OXqEC9h3QWkQerCgBnEt5wz38H8kWCx1l0V2JXfvNgUS8Jlm/iyhvkCxTjNplc/VAqd1++USjOEW+NTXTeuxE5zxIOxrv9wYMl4zct3xPNV2I1tP65dZzH+RgbEKJGdypaSnTcOjlDNAbzG+h40k9E99yXwOhaxUezBoZ0IZIOCNkxldb9LlTssQ65vV6fEDAtCoWeESyoEqP1jn9fbHIpuf8DGz2b8xAdSLcwBDvFNfY+jX2dKhWKFQqwEYfz3b9b37Xvl7fQaSXSUo5MzyjI+IJiFnJGikG4hY1ACs7XiBKMzkXW0SZZtwdEQwHi4Rq45ljWri2yVGxgRwJ1hW801xSIi+gDf1q9ee8DtvX33AwVH//80oJrbxUhd996TUaf8D/KqvbU67Heya9GmNee0Rtds2Y20Skmw44MbYPo4P0AXWOdp+kbsuee99p6XvxBfrk0UatUCVp7GdUGiarxd8+cDQ4O2rnkKNsb2QOAZLoZMtXWMK49usIoCHYJKCS4tA3jC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(346002)(376002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(54906003)(91956017)(66556008)(64756008)(66476007)(66446008)(66946007)(76116006)(4326008)(8676002)(8936002)(316002)(110136005)(6486002)(478600001)(71200400001)(66899024)(7416002)(5660300002)(38070700009)(36756003)(41300700001)(2906002)(86362001)(83380400001)(82960400001)(2616005)(26005)(122000001)(38100700002)(6506007)(6512007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVlmUHBWbml0QlZCbWVxamFoRGJSMVpBWW5tZFI0aEY0cTBlSHBVejdISmJS?=
 =?utf-8?B?bU5hNi9pb1FGRnN5UTlmblRVaUVQdTNiclloZElnKzNiSlJ6bGpZb3hkZ2NH?=
 =?utf-8?B?QUQ1K2JMallpd2FFcVhmanZxNTJTenBTT05TazhKRW5XYlNKMzJweTJoNlFv?=
 =?utf-8?B?SW1qZStBOW55MVVjUlFweWgyVGl6VjRsSHBJSXFFZVpnNVBQRnBpNkhPVmFt?=
 =?utf-8?B?V2Q3alZjeDZLNlkrTzhJSmliaUoxejZFeXVsaFZFLzhCVkQvNDM0dC96cEZI?=
 =?utf-8?B?ZnhJYXBTd2t4ZlJnb1JjRjNqRGdIKzBJMjYxTHM0MTA1SUZpaHFuTGU4Ym41?=
 =?utf-8?B?S3owZjBDZXVzWGFZU2d5NElWVmVMN2Qzb3F5cmFXSlJPZG9xVW10Wm40ME9O?=
 =?utf-8?B?a29ENVUxZUg2RmxjT0gwMHB6U3NUOUE0dTVIWFU3Sk5YWnFtRW5RVG1aUW95?=
 =?utf-8?B?ZE5VK2pVUTcybmp3K1c1M2o3Rm1RZU8vZkRGbzVTS1hoYm1QSWFXK3pIRFRJ?=
 =?utf-8?B?L0dvL3MzazFMTHFlMDdwTXZLNXRtTXF1NklLMzlqL2lzRTVFbXRtL1ZKNHR3?=
 =?utf-8?B?K1Z5M2QxOUNpU2xxL0lyNUFva3Zrbjg3MC82ZFNZQ0tjZUhiSk8xb3pSY1E0?=
 =?utf-8?B?K0pXdlZoQTRKNm9aMVpYTXZjcXh1V0dEQ2tnWlJ4TDRYeGl5TzdscTAwT1g5?=
 =?utf-8?B?ZWZtMHIxZ0Fkc20xQTVIeVdCallCSjhPUkthN3JDYmdxdEJCRUlKLzNyNG5y?=
 =?utf-8?B?d2JINktSWTl6NW1JbTF5TFdCNFBBM3N0WjRUdXNkMERIZzR2SzREcUVaL3I2?=
 =?utf-8?B?Q3hzYzN4TUxJT2xjYmM2UUg0TTJxd1Vncm1CZkdrOENtWDhHdjdCVDFEa1dZ?=
 =?utf-8?B?KzJmWHlIRUQ4bVluOGFteTJDakRqSEJuWWpYRWx0UUJRYkhYc0JUUjVOTGsv?=
 =?utf-8?B?Y2Zva3dkLzR4cWtJZXg2NWhXVW9UOG9SWFVyYy8vYXpXVzJMMlJ0czFrZ0o2?=
 =?utf-8?B?Q3JJOFh0TExnSU1GbldlV1Q0czV1V2Y3WTlhRlBlQXlsL1hEWmdFdVh1a2ZX?=
 =?utf-8?B?N1I4bVh6ZjZLZDMwYittb2NHcVAxUlBGaysrWkEwbGhYS3dsYlVvQ1doSWg0?=
 =?utf-8?B?QkJNZ1pabkVEV2ROSVlVb01oS3k5VVVNK0c4NmxUQVBjWUNacnNWdTFOa0p5?=
 =?utf-8?B?cUEwWGFUWlF0ZGtmK2NBQ2pnbWk4TzB1WUd6M3hNS2hmZmJadndGSldPWlpa?=
 =?utf-8?B?c3lCN2tEUlJCZG1zTFVaTjJCZWV5QnNsNnV2SVJqcWJPc0QrdzNNbmFEL2Zn?=
 =?utf-8?B?NER1U1RNbWZFWU15M0hYRWNPWWg0OWluSWdaY0IvVUU4ZW92NzVDQTloS2xk?=
 =?utf-8?B?Y1AwdEZ1NkcydWdFZ1U1eThpYkxsUzl0K3lEa2F4M1E5RlBqUUcyNzg2M3BD?=
 =?utf-8?B?azF1akJlYW01R2s0KzBWZlRjM21tcS9MWm9zNGpZaXdEcEVpVml6aXkvc05w?=
 =?utf-8?B?TkpDZVpSNVhsMXRIR2ZsNzU1K2h1VFl3TnNmZFdaZEZwMWwvZ0JuNWhQdEJN?=
 =?utf-8?B?V3NvK0oxTWJ0cGxlZU5Ra2xIVDZjNmNxMU5pa0lCaFdhUTY1TUNNWEJ4WGJF?=
 =?utf-8?B?d0dHMEtheUZwMStabXNmNW1DdU9zd05WVDZoK0FtMWliRWh3ZEl6UkYvZmNw?=
 =?utf-8?B?ZkY5NmQrRnVPZTc5bmliSzZ3QlAwZzR5SWs5dFRGZnk2ZHJ1c2w3bFNRNkJV?=
 =?utf-8?B?UDJ6UGpWUVRjQmJGa2pIMnNSamZGY24xWUxDc3ZubTV6OGpJempSTElmR3hx?=
 =?utf-8?B?aC9mQ0UvSDlza0hCdXd5Wlg2NjdVcUd6dkxBbEUwYmlTYUtaN0xzdlV5UERw?=
 =?utf-8?B?dUFIdnZIN21YU3FUandUdHJnbkgvWVU0L1ZUOTBTdTlsaG10YWs4elJuNXg1?=
 =?utf-8?B?eVhzcCtwM2VueW1nRGE5NTVlV05lY1BocnIwZ3hnUlRCa2VOTC82aFljcmlw?=
 =?utf-8?B?Yko1RDJLQTFrVTVaVTVUZEZBK2V4MEloSjc2OHZWRHhpaW14TEFQZnlocXBQ?=
 =?utf-8?B?WVJzSTVvdUE4N2hqMnlYNFZOZ1hsRGUzUWdYNWVBOTNRNWw5MUkvTGorVG5K?=
 =?utf-8?B?WVltcWlmNzFNWGJGRThYQnJWS0huRUp0RFhxa0ZOQUJtc2pSMWpZWFRJTHJq?=
 =?utf-8?B?OFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30127AC5EF17F748B27BF1D5938CA9AA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be498d5-4408-40e7-e5da-08dbf52023d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 23:24:19.1719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dg8HEeNyKdVb/L/2IyX3D5au9XP+cRgK5WEbphZDZ8KP/d97mq5n03NLTLq6KNIC0uoFTIrkZugXbNMTxaGqWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6330
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTEyLTA0IGF0IDE0OjA0IC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDEyLzQvMjMgMTM6MDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiB0bDtkcjogSSB0aGlu
ayBldmVuIGxvb2tpbmcgYSAjTUMgb24gdGhlIFBBTVQgYWZ0ZXIgdGhlIGt2bSBtb2R1bGUgaXMN
Cj4gPiA+IHJlbW92ZWQgaXMgYSBmb29sJ3MgZXJyYW5kLg0KPiA+IFNvcnJ5IEkgd2Fzbid0IGNs
ZWFyIGVub3VnaC4gIEtWTSBhY3R1YWxseSB0dXJucyBvZmYgVk1YIHdoZW4gaXQgZGVzdHJveXMg
dGhlDQo+ID4gbGFzdCBWTSwgc28gdGhlIEtWTSBtb2R1bGUgZG9lc24ndCBuZWVkIHRvIGJlIHJl
bW92ZWQgdG8gdHVybiBvZmYgVk1YLiAgSSB1c2VkDQo+ID4gIktWTSBjYW4gYmUgdW5sb2FkZWQi
IGFzIGFuIGV4YW1wbGUgdG8gZXhwbGFpbiB0aGUgUEFNVCBjYW4gYmUgd29ya2luZyB3aGVuIFZN
WA0KPiA+IGlzIG9mZi4NCj4gDQo+IENhbid0IHdlIGp1c3QgZml4IHRoaXMgYnkgaGF2aW5nIEtW
TSBkbyBhbiAiZXh0cmEiIGhhcmR3YXJlX2VuYWJsZV9hbGwoKQ0KPiBiZWZvcmUgaW5pdGlhbGl6
aW5nIHRoZSBURFggbW9kdWxlPyDCoA0KPiANCg0KWWVzIEtWTSBuZWVkcyB0byBkbyBoYXJkd2Fy
ZV9lbmFibGVfYWxsKCkgYW55d2F5IGJlZm9yZSBpbml0aWFsaXppbmcgdGhlIFREWA0KbW9kdWxl
LiDCoA0KDQpJIGJlbGlldmUgeW91IG1lYW4gd2UgY2FuIGtlZXAgVk1YIGVuYWJsZWQgYWZ0ZXIg
aW5pdGlhbGl6aW5nIHRoZSBURFggbW9kdWxlLA0KaS5lLiwgbm90IGNhbGxpbmcgaGFyZHdhcmVf
ZGlzYWJsZV9hbGwoKSBhZnRlciB0aGF0LCBzbyB0aGF0IGt2bV91c2FnZV9jb3VudA0Kd2lsbCBy
ZW1haW4gbm9uLXplcm8gZXZlbiB3aGVuIGxhc3QgVk0gaXMgZGVzdHJveWVkPw0KDQpUaGUgY3Vy
cmVudCBiZWhhdmlvdXIgdGhhdCBLVk0gb25seSBlbmFibGUgVk1YIHdoZW4gdGhlcmUncyBhY3Rp
dmUgVk0gaXMgYmVjYXVzZQ0KaXQgKG9yIHRoZSBrZXJuZWwpIHdhbnRzIHRvIGFsbG93IHRvIGJl
IGFibGUgdG8gbG9hZCBhbmQgcnVuIHRoaXJkLXBhcnR5IFZNWA0KbW9kdWxlICh5ZXMgdGhlIHZp
cnR1YWwgQk9YKSB3aGVuIEtWTSBtb2R1bGUgaXMgbG9hZGVkLiAgT25seSBvbmUgb2YgdGhlbSBj
YW4NCmFjdHVhbGx5IHVzZSB0aGUgVk1YIGhhcmR3YXJlIGJ1dCB0aGV5IGNhbiBiZSBib3RoIGxv
YWRlZC4NCg0KSW4gYW5jaWVudCB0aW1lIEtWTSB1c2VkIHRvIGltbWVkaWF0ZWx5IGVuYWJsZSBW
TVggd2hlbiBpdCBpcyBsb2FkZWQsIGJ1dCBsYXRlcg0KaXQgd2FzIGNoYW5nZWQgdG8gb25seSBl
bmFibGUgVk1YIHdoZW4gdGhlcmUncyBhY3RpdmUgVk0gYmVjYXVzZSBvZiB0aGUgYWJvdmUNCnJl
YXNvbi4NCg0KU2VlIGNvbW1pdCAxMDQ3NGFlODk0NWNlICgiS1ZNOiBBY3RpdmF0ZSBWaXJ0dWFs
aXphdGlvbiBPbiBEZW1hbmQiKS4NCg0KPiBJdCdzIG5vdCB3cm9uZyB0byBzYXkgdGhhdCBURFgg
aXMgYQ0KPiBLVk0gdXNlci4gIElmIEtWbSB3YW50cyAna3ZtX3VzYWdlX2NvdW50JyB0byBnbyBi
YWNrIHRvIDAsIGl0IGNhbiBzaHV0DQo+IGRvd24gdGhlIFREWCBtb2R1bGUuICBUaGVuIHRoZXJl
J3Mgbm8gUEFNVCB0byB3b3JyeSBhYm91dC4NCj4gDQo+IFRoZSBzaHV0ZG93biB3b3VsZCBiZSBz
b21ldGhpbmcgbGlrZToNCj4gDQo+IAkxLiBURFggbW9kdWxlIHNodXRkb3duDQo+IAkyLiBEZWFs
bG9jYXRlL0NvbnZlcnQgUEFNVA0KPiAJMy4gdm14b2ZmDQo+IA0KPiBUaGVuLCBubyBTRUFNQ0FM
TCBmYWlsdXJlIGJlY2F1c2Ugb2Ygdm14b2ZmIGNhbiBjYXVzZSBhIFBBTVQtaW5kdWNlZCAjTUMN
Cj4gdG8gYmUgbWlzc2VkLg0KDQpUaGUgbGltaXRhdGlvbiBpcyBvbmNlIHRoZSBURFggbW9kdWxl
IGlzIHNodXRkb3duLCBpdCBjYW5ub3QgYmUgaW5pdGlhbGl6ZWQNCmFnYWluIHVubGVzcyBpdCBp
cyBydW50aW1lbHkgdXBkYXRlZC4NCg0KTG9uZy10ZXJtbHksIGlmIHdlIGdvIHRoaXMgZGVzaWdu
IHRoZW4gdGhlcmUgbWlnaHQgYmUgb3RoZXIgcHJvYmxlbXMgd2hlbiBvdGhlcg0Ka2VybmVsIGNv
bXBvbmVudHMgYXJlIHVzaW5nIFREWC4gIEZvciBleGFtcGxlLCB0aGUgVlQtZCBkcml2ZXIgd2ls
bCBuZWVkIHRvIGJlDQpjaGFuZ2VkIHRvIHN1cHBvcnQgVERYLUlPLCBhbmQgaXQgd2lsbCBuZWVk
IHRvIGVuYWJsZSBURFggbW9kdWxlIG11Y2ggZWFybGllcg0KdGhhbiBLVk0gdG8gZG8gc29tZSBp
bml0aWFsaXphdGlvbi4gIEl0IG1pZ2h0IG5lZWQgdG8gc29tZSBURFggd29yayAoZS5nLiwNCmNs
ZWFudXApIHdoaWxlIEtWTSBpcyB1bmxvYWRlZC4gIEkgYW0gbm90IHN1cGVyIGZhbWlsaWFyIHdp
dGggVERYLUlPIGJ1dCBsb29rcw0Kd2UgbWlnaHQgaGF2ZSBzb21lIHByb2JsZW0gaGVyZSBpZiB3
ZSBnbyB3aXRoIHN1Y2ggZGVzaWduLiANCg0K

