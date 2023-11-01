Return-Path: <kvm+bounces-277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 277247DDBB3
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 04:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE16828193B
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9802415A8;
	Wed,  1 Nov 2023 03:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JZHw6G7v"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDC5ED5
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 03:53:56 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF38A4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 20:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698810832; x=1730346832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/t5GRH2r1K9CVA1UVdDe2q8VWnTTcPJJrxBo0OzXqBA=;
  b=JZHw6G7vJlVbWzS2EYUBBfvioVpCAWUm3k7/YY7R/Jz88YdaBQd1+YLT
   0kP7lrP3S/2/DzTRx9FAxR1xmdNvl9GIBa4zsOtpYhKFd+49Qj5DBCqXa
   tPtlBzf8YXAA/fNmB4gE/MwgEpPNW4INhPNlvEfC8yn7twR7u8FxsV8HM
   qKyM157i3Bwk4XriW9iYw1v/KsxLai9t0VOcXrm6YlsfDYaZ62KkCCE6d
   Mt7mfNKZXlnmL1V0jefw0mmVZz7SD6XUPMNC98x2jYwBoInXWeLwUcvC8
   jtZ+Lx16Ulb+9X3z5YfU/crYO4whPOav1E/82rJZklTXdbDE9yLCnhWiO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="392286259"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="392286259"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 20:53:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="2060009"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 20:53:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 20:53:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 20:53:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 20:53:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOotq8X10FvRQmLexhVZPeLFDzzSeC+hF0LIZfS6i7qSwvE3JS9IDOITozAxlKezuCzu8owbfSCBG2PvGmIdykg+qL32pHYq8RL+L1QhZJ5i5FlaOETnyBPYoAMg/j30BAMMgiBQsrOV5niV5XoA7k24/Bt+nkIk+zunH5WpeSBOap6S53gbcy6zQWnQkHFdyuWn+SuE3sIJ/8onkoQAgEAI5JfQB+Pwn+VMJUmbWJ3Y+gD3Wq2FPXt6LK/LKZhAyBk8Y+qL2aZ6fDszvfSy2bbwB/adm0f8s10bDB0S0VthfiLngmHgyCoMJtCGdM7lFDWjxiQSf9sKGyGInIIicA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/t5GRH2r1K9CVA1UVdDe2q8VWnTTcPJJrxBo0OzXqBA=;
 b=PXfbHEAh1BpMKhbWhZGx2qAnU79v3KCbw2Ttx22IRcUYq/LAUdEbFh5U5EuovZF3Qz03W1sde5ZPlJYEiF00jXs9EiPWL8aNqoEC/b5I7F1hZP+9sjlX9DmzQVVIqWJJk+hBe9u1rSRs2zvL8tMia+5ivdUyQTcMZGI07OXdFTCIWr/6mJ+64QwC0+Zq6QQRYMh9YYsp4Z0P5OwtFvdkrflOKFvTIAeakn1RXQtC9tadHiHTnckLNps86/nt3TprUqIfoRW2MRBemN7i08TrQ/QVGLhOi4+WiN/+qJxtJm0raz8PnG+BplXETMFHYmOMa/UAI8bsejRMWHSBqo9bpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB6049.namprd11.prod.outlook.com (2603:10b6:208:391::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.24; Wed, 1 Nov
 2023 03:53:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%6]) with mapi id 15.20.6954.019; Wed, 1 Nov 2023
 03:53:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Christopherson,, Sean" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "ybhuang@cs.utexas.edu" <ybhuang@cs.utexas.edu>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
Thread-Topic: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
Thread-Index: AQHZzXFfx7vudry270KTMc1jVuqn57Beu4kAgAP/UACAAHeLAIAA9QeAgABXo4CAANQFAA==
Date: Wed, 1 Nov 2023 03:53:36 +0000
Message-ID: <bd61959b6cbcff3458cac8b1aa3f0f4b35328116.camel@intel.com>
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
	 <ZTxEIGmq69mUraOD@google.com> <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
	 <ZUAC0jvFE0auohL4@google.com> <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
	 <ZUEZ4QRjUcu7y3gN@google.com>
In-Reply-To: <ZUEZ4QRjUcu7y3gN@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB6049:EE_
x-ms-office365-filtering-correlation-id: ce904e66-5e6b-497d-c668-08dbda8e203c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UTNl9VFsdYN0HlbZPsjo/pKQAmY/7zyPY6uSB9VYA+1n9/LkiHjdvd5NAuhpj5Fq8VW8Pl6r0bKZSt7OdA7ygb9aCjPoGzvr3OxQsWcxuHngheNpknXNasvaVSOJRKR22CnRuYr4CvIwjxjuaTJJ0KRsuQEIgxba1Tgn+itkQ8rp4CmiHiQHdLKTJEm/qoAcFrjCbCq5zUCniECsA9w9yXAlx/xU12ZE7vkfecVqtgpeUy0CsN0FawNCQ7oG16AJ8Mndyte+KhxNK1LxkwFJ2ycaYfBXXjrgbRRwyFf5RTjmzG4DrorOagyUaimyyin1/V2YMrTwC2tLsChLOb0v5vTKflgIakacNJPH/ZsVgv/LOOQD3w0OiNeuNJPxURp4ZyFZ4nIxTaKG7qVQh7bHcv7GnYY7/+1DzNowdY8vBNTjjVemVFIsyagk233rgIr8GgaIqcw7mUiRqpaVNbEyul9EVe2vilFwnQsKeOBy/fHu5KQtJ8S5tzOAQlIJiSUu3K1gYpWRRMWxnUu8Ej7ZkQTDTq/FEs6c9A0tFnY7+e48GWj0RhV4PF9psuDI+y2AWwHFaR3iMN080KQCUo8GqtS6shgh+zU0NiCfG06ZLRCMO4SQ44HlPiGQ+Tolo7Bk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(26005)(2616005)(6506007)(6512007)(86362001)(38100700002)(36756003)(82960400001)(122000001)(83380400001)(5660300002)(66556008)(54906003)(316002)(64756008)(6636002)(66946007)(41300700001)(66446008)(66476007)(76116006)(110136005)(4001150100001)(71200400001)(8936002)(4326008)(2906002)(38070700009)(6486002)(478600001)(91956017)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkNXaUpjNFBTamVRTDlrZDlzYkJmajdubGYrYWhaTWJxK0JVdTdsb3FwNHNm?=
 =?utf-8?B?dVRLakZlc1VnYzNxRFUyU0Z2U0xsQi9GZkd0aDgxT0E0cHdmaFF5OFJSalRF?=
 =?utf-8?B?bWNCNmFIbWtwUGF5cmg5ejM5dVJTL3hLbjZvQkRsYm5EMzVndUoySzF3TVZ2?=
 =?utf-8?B?b2QyYm0yaktHa3dTTk1XaFJ2VlN5OU9tMU55WCtoRVo4TVdudWpuWnBlaDZT?=
 =?utf-8?B?SlA1aXFOYXFHQlVEczVxR24zS2llejF2anRTc2t0WjlCclNZZURCTDNmWWtP?=
 =?utf-8?B?YUgwSllEeVdocjI4aWZjSzY4aFRTZGpBaFFYOFNVaE16aCsxQmVHMFVjbHZV?=
 =?utf-8?B?Yy96SjNnNWo3TER3ODJKZ0hIbTh2Y0lMZ2RvWW9XaXJGNkhEU01SQlA3elps?=
 =?utf-8?B?dHZybU8xWUlsdStrUjFHdlJtR1N1ZmpqdHJveVpyVUptemZOZWY5aG9KYy9C?=
 =?utf-8?B?b1A5dEdqeWRWSWJiYk9VQVNYUFFDQjJhR0EwMmg0WktwVmpwSXVpMWRrU2R0?=
 =?utf-8?B?WkxBWEN0RFE3RXZlZERhZGRra0lnUEVsWjJEYkVqUGp6NUJmQ2dna0Qwdkty?=
 =?utf-8?B?dDJiR1BKOVcrY1RFSlR3QXg0Zlp1MDdLNmVHVCtLdFoxMHJVVEl1dFRMLzVl?=
 =?utf-8?B?VW5tbndjWUY3RmxLUlNOcFVVZVcyNjQxSUtJd3JKd21nTEtWRzdSYmFWZlBE?=
 =?utf-8?B?elczaDNLZDVPamJBYzdod2ZnZk8reHNDVHZzaFY1Z0FzTzZ5TkZhRG4wd3Rp?=
 =?utf-8?B?T01NaUVVdEFBNzZ1UytEMjVtT0V1S1V3bUhIU2FhTmM2bXJBYjFQQnlFdVRC?=
 =?utf-8?B?K0NpMStiMW4vSW1kTXRZZTFkb0dQSFdmZ0hGVGFZY2VqWEFJSEJlRkJaaXBx?=
 =?utf-8?B?NzhVSEQ2QXQ4WXJsRDlqdjNDSTBnQkpsZ2tOQVAyZ1ZWNXBRb1dTNFI4T09m?=
 =?utf-8?B?MnN6Q1JSWm84cEtHbTEwUjVTMHN0U1JlcENvYmZ4dEdSOC8yUEJodDNnN1FU?=
 =?utf-8?B?K3A1cExWLzJzQzhHdG12U1ZkdkJMN21QZ1luTHdod2MvMmk2b2tEc1o0TEE0?=
 =?utf-8?B?bm9nanMxcWlIcmtqeFpsUXZTTjRwbTJZZ2ZJS0NHblY4dXhXZmM2OVR3ck80?=
 =?utf-8?B?R0dmNkx4T1VhSjZSWWNOS2IrK1N5OEhTNzlNVlJUTkhnMzJTYzVEemcrYTNR?=
 =?utf-8?B?bmRaNnFJVUF6bU01ekdwQTFVL3B5NWFzbEtVNTh0VVlVc0grOS8ra1QzYVBi?=
 =?utf-8?B?bStVa1hDZkhqMGpiZTFxRDFCa21ra2oydEJ3OTBKeHFVU0pWa2VMMTNNK09I?=
 =?utf-8?B?MFBPdzg2Qkgya0JiTTZ4aHVCcTBZRVU3OTA0eDZ2b0U2dExEd1dWd1I5R01H?=
 =?utf-8?B?bW03RE4xblRSSnp3bU9FeGJaL1RlRm1ycXdCcmk4MU93UDAxNGNCN0pWdlYv?=
 =?utf-8?B?OVk0NzBMNXdGWWJzU3B1dFVhRURVRlBxNVJNeUhUVlBXeVI5TWVXSzlqTWFU?=
 =?utf-8?B?akZXZXBpZFU0VDVaREdTeHBJdHh4dDZzR0Y0YXd6clQ0Q1oxVjlYM3hHMmFO?=
 =?utf-8?B?QXhnMFV5QkZqMHpJbWhvY2pYYVZyRVF6VGMvVTBkV2tlTVA5elk0UVU5QmNo?=
 =?utf-8?B?UHNqb2d0RVB3djBPUmVQNnQ5MUxOMitEL0lZaEVlRnAzUURZSnVtdy9VejJQ?=
 =?utf-8?B?NnpBNmJFN0pUWUJJVVk4S0lsQXQrVWxyMXU4WlpQNWFXVlQvZnU5elpYWStm?=
 =?utf-8?B?NmJaQ1RlNHd3VEZ3RVhRVjFHb29kdE5VeXBjUGg4Q2xKTnQ2Y3FvSi90cU4v?=
 =?utf-8?B?eEZkd0NYVkZvVk5lTFUzbCtob1FCbGZ2UklLUnRSOUJPbVQycmhXQ2Evbldm?=
 =?utf-8?B?ZVNyUmxVbGZVem9WWjZyenF6Y0FiUHl1Y3BYZUJSQnA1ejNVRlpIU00yQW82?=
 =?utf-8?B?TDFIL0srSFV5ODBBMW11TVUxU0VHOHZMTVFHbmJPUjVZZnRON09pcUtTbmVI?=
 =?utf-8?B?a05aaFQzWkt6ZTZwSXI1VkRReStGMnlQVmNMNmsrdTlKdGNqRVUreFZiMFY1?=
 =?utf-8?B?bVJGZU00VTEyY2MzOW9NUjdyM1lFYmtTNC84ZHM3WU5PNUhnVTFvWXJjelR6?=
 =?utf-8?B?bG5Xb3VwYzFGUmRMbkVzWmN2eHFEVDlsd1J2SExwWDhTQUFIQ0g4U3RzVXdj?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDE7C600B344CA4B865FD77F5E4BB676@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce904e66-5e6b-497d-c668-08dbda8e203c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2023 03:53:36.4078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cPigCkS+t2gFfOR7l5of28e580zXxOZsJ+PW+VAncm5R72jYso07pFBZ+gAn8mx7QbGJmkEfFfsLzj1/MI9pjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6049
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTEwLTMxIGF0IDA4OjE0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gRGlzY3Vzc2lvbiBmcm9tIHRoZSBFUFQrTVRSUiBlbmFibGluZyB0aHJlYWRb
Kl0gbW9yZSBvciBsZXNzIGNvbmZpcm1zIHRoYXQgU2hlbmcNCj4gPiA+IFlhbmcgd2FzIHRyeWlu
ZyB0byByZXNvbHZlIGlzc3VlcyB3aXRoIHBhc3N0aHJvdWdoIE1NSU8uDQo+ID4gPiANCj4gPiA+
IMKgICogU2hlbmcgWWFuZyANCj4gPiA+IMKgwqAgOiBEbyB5b3UgbWVhbiBob3N0KHFlbXUpIHdv
dWxkIGFjY2VzcyB0aGlzIG1lbW9yeSBhbmQgaWYgd2Ugc2V0IGl0IHRvIGd1ZXN0IA0KPiA+ID4g
wqDCoCA6IE1UUlIsIGhvc3QgYWNjZXNzIHdvdWxkIGJlIGJyb2tlbj8gV2Ugd291bGQgY292ZXIg
dGhpcyBpbiBvdXIgc2hhZG93IE1UUlIgDQo+ID4gPiDCoMKgIDogcGF0Y2gsIGZvciB3ZSBlbmNv
dW50ZXJlZCB0aGlzIGluIHZpZGVvIHJhbSB3aGVuIGRvaW5nIHNvbWUgZXhwZXJpbWVudCB3aXRo
IA0KPiA+ID4gwqDCoCA6IFZHQSBhc3NpZ25tZW50LiANCg0KTm90IHN1cmUgd2hhdCBkb2VzIHRo
ZSAiVkdBIGFzc2lnbm1lbnQiIG1lYW4sIGJ1dCBJIGhhdmUgYSBkb3VidCB3aGV0aGVyIGl0IHdh
cw0KYWJvdXQgcGFzc3Rocm91Z2ggTU1JTy7CoCBUaGVvcmV0aWNhbGx5IGlmIGl0IHdhcyBwYXNz
dGhyb3VnaCBNTUlPLCB0aGUgaG9zdA0Kc2hvdWxkbid0IG5lZWQgdG8gYWNjZXNzIGl0LiAgQnV0
IHRoZSBhYm92ZSB0ZXh0IHNlZW1zIHRoZSBpc3N1ZSB3ZXJlIGhvc3QvZ3Vlc3QNCmFjY2Vzc2lu
ZyBtZW1vcnkgdG9nZXRoZXIuDQoNCklmIHdlIGFyZSB0YWxraW5nIGFib3V0IHRoZSB2aWRlbyBy
YW0gaGVyZSAoZS5nLiwgZm9yIGZyYW1lYnVmZmVyKSBJSVVDIGl0IGlzbid0DQpwYXNzdGhyb3Vn
aCBNTUlPLCBidXQganVzdCBzb21lIG1lbW9yeSB0aGF0IHVzZWQgYnkgZ3Vlc3QgYXMgdmlkZW8g
cmFtLiAgS1ZNDQpuZWVkcyB0byBwZXJpb2RpY2FsbHkgd3JpdGUgcHJvdGVjdCBpdCAoYW5kIGNs
ZWFyIGRpcnR5KSBzbyB0aGF0IFFlbXUgY2FuIGJlDQphd2FyZSBvZiBleGFjdCB3aGF0IHZpZGVv
IHJhbSBoYXMgYmVlbiB1cGRhdGVkIHRvIGNvcnJlY3RseSBlbXVsYXRlIHRoZSB2aWRlbw0KcmFt
LCBpLmUuLCBzaG93aW5nIG9uIHRoZSBjb25zb2xlIG9mIHRoZSBWTS4NCg0KU28gSSBndWVzcyB0
aGUgaXNzdWUgd2FzIGJvdGggaG9zdCBhbmQgZ3Vlc3QgYWNjZXNzIG9mIHZpZGVvIHJhbSwgd2hp
bGUgZ3Vlc3QNCnNldHMgaXRzIG1lbW9yeSB0eXBlIHRvIFdDIG9yIFVDLg0KDQpCdXQgSUlVQyBo
b3N0IG9ubHkgKnJlYWRzKiBmcm9tIHZpZGVvIHJhbSwgYnV0IG5ldmVyICp3cml0ZXMqLCB0aHVz
IEkgZG9uJ3Qgc2VlDQp0aGVyZSdzIGFueSByZWFsIHByb2JsZW0gaWYgaG9zdCBpcyBhY2Nlc3Np
bmcgdmlhIFdCIGFuZCBndWVzdCBpcyBhY2Nlc3NpbmcgdmlhDQpXQyBvciBVQy4NCg0KQU1EIFNE
TToNCgkNCglWTVJVTiBhbmQgI1ZNRVhJVCBmbHVzaCB0aGUgd3JpdGUgY29tYmluZXJzLiBUaGlz
IGVuc3VyZXMgdGhhdCBhbGzCoA0KCXdyaXRlcyB0byBXQyBtZW1vcnkgYnkgdGhlIGd1ZXN0IGFy
ZSB2aXNpYmxlIHRvIHRoZSBob3N0IChvcg0KCXZpY2UtdmVyc2EpwqByZWdhcmRsZXNzIG9mIG1l
bW9yeSB0eXBlLiAoSXQgZG9lcyBub3QgZW5zdXJlIHRoYXQNCgljYWNoZWFibGUgd3JpdGVzIGJ5
IG9uZSBhZ2VudCBhcmUgcHJvcGVybHkgb2JzZXJ2ZWQgYnkgV0MgcmVhZHMgb3LCoA0KCXdyaXRl
cyBieSB0aGUgb3RoZXIgYWdlbnQuKQ0KDQo+ID4gPiANCj4gPiA+IEFuZCBpbiB0aGUgc2FtZSB0
aHJlYWQsIHRoZXJlJ3MgYWxzbyB3aGF0IGFwcGVhcnMgdG8gYmUgY29uZmlybWF0aW9uIG9mIElu
dGVsDQo+ID4gPiBydW5uaW5nIGludG8gaXNzdWVzIHdpdGggV2luZG93cyBYUCByZWxhdGVkIHRv
IGEgZ3Vlc3QgZGV2aWNlIGRyaXZlciBtYXBwaW5nDQo+ID4gPiBETUEgd2l0aCBXQyBpbiB0aGUg
UEFULsKgIEhpbGFyaW91c2x5LCBBdmkgZWZmZWN0aXZlbHkgc2FpZCAiS1ZNIGNhbid0IG1vZGlm
eSB0aGUNCj4gPiA+IFNQVEUgbWVtdHlwZSB0byBtYXRjaCB0aGUgZ3Vlc3QgZm9yIEVQVC9OUFQi
LCB3aGljaCB3aGlsZSB0cnVlLCBjb21wbGV0ZWx5IG92ZXJsb29rcw0KPiA+ID4gdGhlIGZhY3Qg
dGhhdCBFUFQgYW5kIE5QVCBib3RoIGhvbm9yIGd1ZXN0IFBBVCBieSBkZWZhdWx0LsKgIC9mYWNl
cGFsbQ0KDQpJIHRoaW5rIEF2aSB3YXMgbm90IHRhbGtpbmcgYWJvdXQgZ3Vlc3QgUEFUIGJ1dCBn
dWVzdCBNVFJSLCB3aGljaCBpcyBub3QgaG9ub3JlZA0KYnkgTlBUL0VQVCBhdCBhbGwuID8NCg0K
PiA+IA0KPiA+IE15IGludGVycHJldGF0aW9uIGlzIHRoYXQgdGhlIHNpbmNlIGd1ZXN0IFBBVHMg
YXJlIGluIGd1ZXN0IHBhZ2UgdGFibGVzLA0KPiA+IHdoaWxlIHdpdGggRVBUL05QVCwgZ3Vlc3Qg
cGFnZSB0YWJsZXMgYXJlIG5vdCBzaGFkb3dlZCwgaXQncyBub3QgZWFzeSB0bw0KPiA+IGNoZWNr
IGd1ZXN0IFBBVHPCoCB0byBkaXNhbGxvdyBob3N0IFFFTVUgYWNjZXNzIHRvIG5vbi1XQiBndWVz
dCBSQU0uDQo+IA0KPiBBaCwgeWVhaCwgeW91ciBpbnRlcnByZXRhdGlvbiBtYWtlcyBzZW5zZS4N
Cj4gDQo+IFRoZSBiZXN0IGlkZWEgSSBjYW4gdGhpbmsgb2YgdG8gc3VwcG9ydCB0aGluZ3MgbGlr
ZSB0aGlzIGlzIHRvIGhhdmUgS1ZNIGdyYWIgdGhlDQo+IGVmZmVjdGl2ZSBQQVQgbWVtdHlwZSBm
cm9tIHRoZSBob3N0IHVzZXJzcGFjZSBwYWdlIHRhYmxlcywgc2hvdmUgdGhhdCBpbnRvIHRoZQ0K
PiBFUFQvTlBUIG1lbXR5cGUsIGFuZCB0aGVuIGlnbm9yZSBndWVzdCBQQVQuwqAgSSBkb24ndCBp
ZiB0aGF0IHdvdWxkIGFjdHVhbGx5IHdvcmsNCj4gdGhvdWdoLg0KDQpJIHRoaW5rIHlvdSBhcmUg
YXNzdW1pbmcgImhvc3QgdXNlcnNwYWNlIHBhZ2UgdGFibGVzIiB3aWxsIGFsd2F5cyBoYXZlIHRo
ZSBzYW1lDQptZW1vcnkgdHlwZSBpbiBndWVzdCdzIE1UUlI/DQoNCkkgYW0gbm90IHN1cmUgd2hl
dGhlciBpdCB3aWxsIGFsd2F5cyBiZSB0aGUgY2FzZS4gIEkgaGF2ZW4ndCBjaGVja2VkIHRoZSBR
ZW11DQpjb2RlLCBidXQgdGhlb3JldGljYWxseSwgZm9yIHRoaW5ncyBsaWtlIHZpZGVvIHJhbSwg
dGhlIGd1ZXN0IGNhbiBoYXZlIGl0cw0KbWVtb3J5IGFzIFdDL1VDIGluIE1UUlIgYnV0IGhvc3Qg
Y2FuIG1hcCBpdCBhcyBXQiBwZXJmZWN0bHksIGJlY2F1c2UgaG9zdCBvbmx5DQpuZWVkcyB0byBy
ZWFkIGZyb20gaXQuDQoNCkkgdGhpbmsgd2UgY2FuIGp1c3QgZ2V0IHJpZCBvZiBndWVzdCBNVFJS
IHN0YWZmIGNvbXBsZXRlbHksIGkuZS4gZW5mb3JjZSBLVk0gdG8NCmV4cG9zZSAwIGZpeGVkIGFu
ZCBkeW5hbWljIE1UUlJzLiAgVGhlbiB3ZSBkb24ndCBuZWVkIHRvICJsb29rIGF0IG1lbW9yeSB0
eXBlDQpmcm9tIGhvc3QgdXNlcnNwYWNlIHBhZ2UgdGFibGVzIiwgYnV0IHNpbXBseSBzZXQgV0Ig
dG8gTlBUL0VQVC4NCg0KVGhlIHJlYXNvbiBpcyBhcyB5b3Ugc2FpZCBOUFQvRVBUIGhvbm9yIGd1
ZXN0J3MgUEFUIGJ5IGRlZmF1bHQuICBJZiBndWVzdCB3YW50cw0KV0MgdGhlbiBpdCBzZXRzIFdD
IHRvIFBBVCB0aGVuIGd1ZXN0IHdpbGwgYWNjZXNzIGl0IHVzaW5nIFdDLiAgSG9zdCBzaWRlIGZv
cg0KcGFzc3Rocm91Z2ggTU1JTyBob3N0IHNob3VsZCBuZXZlciBhY2Nlc3MgaXQgYW55d2F5LCBh
bmQgZm9yIHRoaW5ncyBsaWtlIHZpZGVvDQpyYW0gaG9zdCB3aWxsIG9ubHkgcmVhZCBmcm9tIGl0
LCB0aHVzIGl0IHNob3VsZCBiZSBzYWZlIHRvIG1hcCBXQiBpbiB0aGUgaG9zdC4NCg0KT3IgZG8g
d2UgbmVlZCB0byBjb25zaWRlciBob3N0IGJlaW5nIGFibGUgdG8gd3JpdGUgdXNpbmcgV0Igc29t
ZSBtZW1vcnkgd2hpbGUgaXQNCmlzIGFjY2Vzc2VkIGFzIFdDL1VDIGluIHRoZSBndWVzdD8NCg0K
QW5kIGRvZXMga2VybmVsLWRpcmVjdCBtYXBwaW5nIHdvcnRoIGNvbnNpZGVyYXRpb24/DQoNCkht
bS4uIEJ1dCBpdCdzIHBvc3NpYmxlIEkgYW0gdGFsa2luZyBub24tc2Vuc2UuLiA6LSkNCg==

