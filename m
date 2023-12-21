Return-Path: <kvm+bounces-5072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BE181B900
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 14:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 542AA28C16B
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 13:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 770DB64A94;
	Thu, 21 Dec 2023 13:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IvOhgl0Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0537F62815
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 13:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703166465; x=1734702465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P/yUnZ0axFKfH9G9umh5zzxdyPZ7h5lih//1cdpsRJ8=;
  b=IvOhgl0YRDOx3nw251QTJajZxi+XSDkoaoQplGdebN8MF0o7Otw4UnR/
   F088c3eFzWknvTC8slTi4cGHwj8b9x6OZ5qk3wnTg5e85+Eew5S7z17qg
   NXK4j6VQFX2oaBLQqbKgZ6sXoz2xJjXVBeJN5adcCxZ8b+QxmpImBp/O0
   O7T4JfbUgQSOB7kChgF7IfmHipx8HbHWKe/0rXShTFq8WoRbrbFHdkF0M
   bV1N5xHKAuuD3LBb/3NG2rJb0YIRIEf6SLiIDRFj8tCuEIfpGML87FEia
   da8ZWsRODJykxk4wskyQQwksrN6L96lSttGeQA+tEBakU5WTzLixFbOfa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398760617"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398760617"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 05:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="805608379"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="805608379"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Dec 2023 05:47:43 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Dec 2023 05:47:43 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Dec 2023 05:47:43 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Dec 2023 05:47:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akpjJeFhvUnNILHWCNqUEZPXq3sjmSOos0IDYoERpw9PURy6oaka+H4TbFwldUf0yuKlg8yhUtXfZsZmoBV7L8WaTeFZ5zzeqNATZ53IB+bW0SuD2ylNC4+APT/TwV0r74kdmA6UoiZwLRDU8qi5ajnBx0+P+7gnY760gtdHYuxagbHQHZDcm2mb5Yg+CqBgz9Qf/944Geky49BQQrLEYaLlivQJrFX8uXirQZh/6SfWbbw2fxqDWbDymssg3jMw003DYaWf1A5YcMNQ5LT63C4cHwpksJQkmDUbSwsKitibNv/j2tbuaqnE5rHgBuwEXKPw9a30Znr8rA6AyE3EJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/yUnZ0axFKfH9G9umh5zzxdyPZ7h5lih//1cdpsRJ8=;
 b=RcaXSVHgd0/qXa28KsyCxLvjOvit0OE8sPbwZ1LhucP0U5iVbQ0vIdmoby5AFxteaZE4fXI4Oo9UYGJ3fz0JtQ7pWFoisqOHMJL7EZgyA2xhOo5sHQR/LV5b6A9iE+bOfj3jplH1+hL3dB6UuOO/SYKhKaCTENv4wQsbhG2qvXCUY/EUtoi+GxhyEnqFsDYNKDGqxlOkYTRTrFpSzoiUFUOs7QfMiJRCn7bLl5PlubtdCKt4/Tuc6GRS9Qs9b8JRmZEFiQ4IGNrsFwiav0RAxh2VU1Vgad+KN0FfUqUhthS7Uz15JKDhKBjcL4Hl7E1r7u5UiaM+hdmRrpTjcac36Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DS0PR11MB8688.namprd11.prod.outlook.com (2603:10b6:8:1a0::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.18; Thu, 21 Dec 2023 13:47:41 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a%4]) with mapi id 15.20.7113.019; Thu, 21 Dec 2023
 13:47:41 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, Richard Henderson
	<richard.henderson@linaro.org>, Peter Xu <peterx@redhat.com>,
	=?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, "Cornelia
 Huck" <cohuck@redhat.com>, =?utf-8?B?RGFuaWVsIFAgLiBCZXJyYW5nw6k=?=
	<berrange@redhat.com>, Eric Blake <eblake@redhat.com>, Markus Armbruster
	<armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Sean
 Christopherson" <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>, Gerd
 Hoffmann <kraxel@redhat.com>, Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Qiang, Chenyi" <chenyi.qiang@intel.com>
Subject: RE: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Thread-Topic: [PATCH v3 06/70] kvm: Introduce support for memory_attributes
Thread-Index: AQHaF5O24VxNhOyFz0ifdu/xEp7Ej7Cl0dCggA2oA4CAAEbrQIAAGMwAgAAVlUA=
Date: Thu, 21 Dec 2023 13:47:41 +0000
Message-ID: <DS0PR11MB63730289975875A5B90D078CDC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-7-xiaoyao.li@intel.com>
 <DS0PR11MB6373D69ABBF4BDF7120438ACDC8EA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <cc568b63-a129-4b23-8ac8-313193ea8126@intel.com>
 <DS0PR11MB63737AFCA458FA78423C0BB7DC95A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <a0289f6d-2008-48d7-95fb-492066c38461@intel.com>
In-Reply-To: <a0289f6d-2008-48d7-95fb-492066c38461@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DS0PR11MB8688:EE_
x-ms-office365-filtering-correlation-id: 0e1b381b-55bc-4ebd-aa98-08dc022b6730
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n9+kPkOo4leWtE52gkWIIuqnK8ojA/j7OwTPDUpUukeQjhSuu9LMUorA8AJAvu7KW57XXnqaxPUHGAqJ0WZ5u/7XyGXytMn0cMHIiEC2kLhk8oSR6xzRWrJ3sC1dI6zr9101OnO0ITNRMBblLhxA+x8LOtwH5XaC2QiGYhBSQ1MK1WhQ1HcEAbrKoxufU8nSMMqD97dovmUFXJmIMcS0G+xzwDSaP93CJBOr4ZDt4j9d/gumE69YLkDSg7N8QofBtf7ldnb97kia+STO0Ki/auOampttFIkQvAGXrkQSkS3A96AVpXikslp2albj1hEPzq5tUxB6mCbGUXq7dlf6jdzbrTDXSTFO1vTXbnmk22QeMi2HzoH1u7ItfGnVXIyw0XEd8IevZDbEhp0MW5KmyaVScAoZzZmTyjWj/9QoF4U/H+m5z/FrFyoEp4Q9LIs8eoI5ZBiOOr18PQI782FN/YuWg3jddHR4n1PS3RPZF49/tK0OERXUc/qACT2mhYlx705+IzdLXBWZwkJCkLXzLcxf5Te/WWngC1apo7UJrsqax7HsIUPDohXc3aVyhYRwNFR6A3MA64tQ+V+ogW43uVoQFwAV1qrxJ6rg2cNIwZbhDvjGtsbXHEeP9SyHXwNATL6KGXsddd75zeVbXftKhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(136003)(346002)(39860400002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(8676002)(4326008)(8936002)(26005)(2906002)(478600001)(316002)(52536014)(54906003)(110136005)(66946007)(66446008)(66476007)(64756008)(66556008)(76116006)(71200400001)(6506007)(7696005)(53546011)(55016003)(9686003)(5660300002)(86362001)(38100700002)(33656002)(122000001)(7416002)(107886003)(921008)(38070700009)(41300700001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDlBcUtNczZOQ2FYZmVxcSs0RU85SFRlNUMwSTlGZUp5b01xVHZQTzRLY1dJ?=
 =?utf-8?B?enpvaWVwOG15TGN3QkJZUDFYZldaVStJc25wR1JzZk5oVDhEVUNRVWQ1ZG81?=
 =?utf-8?B?NHBrY1QzNGVsam5QcENSQytXU2hDeTJNZDc2aG16UGpZMnVWcklaeXViN2ti?=
 =?utf-8?B?QzB3clNIWkNRY3VPQlRLOXZVWEcrN1VsZnU3NEdEQkdUaEFucU9VWWQ2bGs3?=
 =?utf-8?B?RjJLZGZaYUlEOW1RUXd2VWVSdVpud3EzTU1EZ0hUU0xXS245SWxQZVc5ckZl?=
 =?utf-8?B?RjEvVGJ5TmxXcDFma0IvK1JQTG1ETUJqSmpiZ0x1ZGIyWFN6NU0xaGdrTnl2?=
 =?utf-8?B?N09YOFUxYnJibHFJRzlHNGtzSU1hNUVPNXpxSm9jeFg4OWl5aGhPMVlXcmVo?=
 =?utf-8?B?eVlsZnZKZHFIcHg4d1BFTTVtSUMzT2ZPcDJSVDl0d2lISHZSaHhaTFlramlH?=
 =?utf-8?B?NFdhbDJRQ2xxT2ErNHNmN3hIL1RZL1VDdHNOMlk5bmpmZWpDRFRaRHlGcmFs?=
 =?utf-8?B?RXg0cjJtcWRzQUhTc0poNWFxdXl4MlU0Umg4ZWpEOXNVU2NFbFJxM1RqNitr?=
 =?utf-8?B?WjYvU0tONWZpQjBZbHNmTkIrQkVpK2dhOVVGRlV1LzBNODQxNVp6c3RJYWdW?=
 =?utf-8?B?a21rUzlHUEpiTFlmNDB0QVAvOTg1bDAzRnhxMVpoTURCaDhEdzIvSjZuWWJM?=
 =?utf-8?B?RmNJTWdsNDM5YWxXSXFPWGdoVEppM0lUNkRVRWc2eWFiaE55dGxRTWhnaTQy?=
 =?utf-8?B?U2pBYmZqUHNVNnVCOG5KUVNycmNlUGEweEg2amNDaFBnajlpYjBoR0JlUFBD?=
 =?utf-8?B?Yk5KdmJRMUJTYWcrQnYxTHRtZ2VGRWZZbTlVVmwwTTA3YkEwdHhxcDJOOWQ3?=
 =?utf-8?B?V1U4TTFIcHp1cmNXbVZCOHYxMlIzMHZuYWkxZVk1N0ZjTHl0QThLUHlBYytS?=
 =?utf-8?B?RVlXSmZtN1ozakRwZ0xYMVJqUzN4MEdhYUg2cHg1M3VLK1Fncko3eS9UQWxD?=
 =?utf-8?B?SjUzQzNyOUNaQlRnSUFrYU9DWlpFb0x6Q3VGYlNXeTFUYTBpK0ZTR0JoQnZq?=
 =?utf-8?B?ZkRCdGhhQ3VWaFlBaTZ3TmlLL3BmWTNCRFM3bklQUEpWY3d4NHI0amRveTZt?=
 =?utf-8?B?dDJWcG93Y0FyVm9iYk0zU0xKWk5BTHdhbE1FeFNwT1h1SVROYWpacGdOQVFB?=
 =?utf-8?B?OU9kTDQzUzcxWU9KVTBXTmRZZ3E0MHk1MUtoVnFmalI0U0s5ODAwTWtiaTly?=
 =?utf-8?B?Z05sd0VrdDJnR1prS2VjYzM5dFhwdm85MXhsL1hQZ3hpcUUweC9RMUJCWE9M?=
 =?utf-8?B?YUNNUFNhakFUbTA5R0FoRkxwUFovWERVRTE0Vnd1S2U0KzFZbERsNEpYTnR5?=
 =?utf-8?B?bWk2T0Q2OFh4dUhiY0E0eHNabzBTNHBpNzJ1UEpIeFVnYjdLK1lTU080Z2lW?=
 =?utf-8?B?cUxyYjRmRHhjYkRkblppT1hjR3ZtZXpnRW9jWGFTYXMwaXBJd1dncHQyc2I4?=
 =?utf-8?B?cHpwZHlTRDhPWE5KVHRaQkR1NjdGaS9NUG9SaEZjS0x4dmxBb1FVVVAxR01G?=
 =?utf-8?B?VFgzTTNKK0gvYmFPTWxvUGp1aFN1QXpsSWk4ZHhZWlk4Tldnc00wdjBqRTRY?=
 =?utf-8?B?SUJHdmNYV0dUL3FXc0ZEUk1Kdzg2SFV2VThGY0xZUDB3M29zM3FzVnJhSURV?=
 =?utf-8?B?V3hKOE5lQWwvOXVQM3NEVml3bjNscnNhSHBCOEorMG53VmRzcmxJUW9heVFT?=
 =?utf-8?B?VXVkU1hZRk0wVGFLc3hVRm1sckIrc0duanlBTk9DNDZGSGNiRi9NWm45OE9n?=
 =?utf-8?B?VlRFbHRWVEhHMHM2NEcxVkdSbmFWSXF6eGh1OEQvVzY4NEpkQU9PdTRuajRL?=
 =?utf-8?B?QkM3U2FxaUxDdURBYTZnRUt6SWVzNU1xKy9LWWkwWXRBbWxqcndsRkw5Nk9I?=
 =?utf-8?B?OWg2SHUweU5sTEt1NElzYUdiMlRPWG1kcHpKdUg3VGw3WUdXT2JoYk5RRGtX?=
 =?utf-8?B?RW9ZbFM0K0Q5clB1VDR6Um9ML2tucEwrWTFra0FJSWlnZXNKbkJqSnFPQXdQ?=
 =?utf-8?B?VkEzdE1pdmtwRVhrbDFKVkxsbi9lU0NsUlFvaEVIU1Y2SXlMcjdwaGhlc2NB?=
 =?utf-8?Q?o1abI1HRiSyI5QKZGN6gXLDu+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1b381b-55bc-4ebd-aa98-08dc022b6730
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2023 13:47:41.7322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xDfLPjc29rkEyxXaGaRrMdxKCSNa6Bsrt1GerriGS0gkGyo2CBk0NwkRuN4BWB0MdBVUGWWHnoRop59mTPKlBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8688
X-OriginatorOrg: intel.com

T24gVGh1cnNkYXksIERlY2VtYmVyIDIxLCAyMDIzIDc6NTQgUE0sIExpLCBYaWFveWFvIHdyb3Rl
Og0KPiBPbiAxMi8yMS8yMDIzIDY6MzYgUE0sIFdhbmcsIFdlaSBXIHdyb3RlOg0KPiA+IE5vIG5l
ZWQgdG8gc3BlY2lmaWNhbGx5IGNoZWNrIGZvciBLVk1fTUVNT1JZX0FUVFJJQlVURV9QUklWQVRF
IHRoZXJlLg0KPiA+IEknbSBzdWdnZXN0aW5nIGJlbG93Og0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L2FjY2VsL2t2bS9rdm0tYWxsLmMgYi9hY2NlbC9rdm0va3ZtLWFsbC5jIGluZGV4DQo+ID4gMmQ5
YTI0NTVkZS4uNjNiYTc0YjIyMSAxMDA2NDQNCj4gPiAtLS0gYS9hY2NlbC9rdm0va3ZtLWFsbC5j
DQo+ID4gKysrIGIvYWNjZWwva3ZtL2t2bS1hbGwuYw0KPiA+IEBAIC0xMzc1LDYgKzEzNzUsMTEg
QEAgc3RhdGljIGludCBrdm1fc2V0X21lbW9yeV9hdHRyaWJ1dGVzKGh3YWRkcg0KPiBzdGFydCwg
aHdhZGRyIHNpemUsIHVpbnQ2NF90IGF0dHIpDQo+ID4gICAgICAgc3RydWN0IGt2bV9tZW1vcnlf
YXR0cmlidXRlcyBhdHRyczsNCj4gPiAgICAgICBpbnQgcjsNCj4gPg0KPiA+ICsgICAgaWYgKChh
dHRyICYga3ZtX3N1cHBvcnRlZF9tZW1vcnlfYXR0cmlidXRlcykgIT0gYXR0cikgew0KPiA+ICsg
ICAgICAgIGVycm9yX3JlcG9ydCgiS1ZNIGRvZXNuJ3Qgc3VwcG9ydCBtZW1vcnkgYXR0ciAlbHhc
biIsIGF0dHIpOw0KPiA+ICsgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+ICsgICAgfQ0KPiAN
Cj4gSW4gdGhlIGNhc2Ugb2Ygc2V0dGluZyBhIHJhbmdlIG9mIG1lbW9yeSB0byBzaGFyZWQgd2hp
bGUgS1ZNIGRvZXNuJ3Qgc3VwcG9ydA0KPiBwcml2YXRlIG1lbW9yeS4gQWJvdmUgY2hlY2sgZG9l
c24ndCB3b3JrLiBhbmQgZm9sbG93aW5nIElPQ1RMIGZhaWxzLg0KDQpTSEFSRUQgYXR0cmlidXRl
IHVzZXMgdGhlIHZhbHVlIDAsIHdoaWNoIGluZGljYXRlcyBpdCdzIGFsd2F5cyBzdXBwb3J0ZWQs
IG5vPw0KRm9yIHRoZSBpbXBsZW1lbnRhdGlvbiwgY2FuIHlvdSBmaW5kIGluIHRoZSBLVk0gc2lk
ZSB3aGVyZSB0aGUgaW9jdGwNCndvdWxkIGdldCBmYWlsZWQgaW4gdGhhdCBjYXNlPw0KDQpzdGF0
aWMgaW50IGt2bV92bV9pb2N0bF9zZXRfbWVtX2F0dHJpYnV0ZXMoc3RydWN0IGt2bSAqa3ZtLA0K
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBrdm1fbWVt
b3J5X2F0dHJpYnV0ZXMgKmF0dHJzKQ0Kew0KICAgICAgICBnZm5fdCBzdGFydCwgZW5kOw0KDQog
ICAgICAgIC8qIGZsYWdzIGlzIGN1cnJlbnRseSBub3QgdXNlZC4gKi8NCiAgICAgICAgaWYgKGF0
dHJzLT5mbGFncykNCiAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCiAgICAgICAgaWYg
KGF0dHJzLT5hdHRyaWJ1dGVzICYgfmt2bV9zdXBwb3J0ZWRfbWVtX2F0dHJpYnV0ZXMoa3ZtKSkg
PT0+IDAgaGVyZQ0KICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KICAgICAgICBpZiAo
YXR0cnMtPnNpemUgPT0gMCB8fCBhdHRycy0+YWRkcmVzcyArIGF0dHJzLT5zaXplIDwgYXR0cnMt
PmFkZHJlc3MpDQogICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQogICAgICAgIGlmICgh
UEFHRV9BTElHTkVEKGF0dHJzLT5hZGRyZXNzKSB8fCAhUEFHRV9BTElHTkVEKGF0dHJzLT5zaXpl
KSkNCiAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCg==

