Return-Path: <kvm+bounces-1618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DABEC7EA7BE
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 01:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A0421F23B72
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 00:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35C846B0;
	Tue, 14 Nov 2023 00:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EyJlDdcP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5FB747B;
	Tue, 14 Nov 2023 00:43:46 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A00CD5A;
	Mon, 13 Nov 2023 16:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699922624; x=1731458624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NKtNRhIUg7Mr+IyCpRpr8MQo5ET9Z7oU1fIbXO8JoU8=;
  b=EyJlDdcPxXms6ymFlIx0pCzU2vgizm5kLrQINDv8R97iwBT+W2IA4bk3
   QqTXvwxvqpuEmZOvqAM8CGZh054bSwMz39n5igbSgideDM5Va3TKZJFXj
   5zXFDrFnjA43HuyTVbT5UKL1qwQCM5ORKsDsjJib4Yd9xdOaeKaVCVuMi
   oejR7tF26APkonm6uqfG2RYB7dUb5iEdDb9aWpCQXjYerETagpNcp3Dof
   CFYZyjcPKmlO3h/A6qOrOE3ylVWTsoWLMUiJ3a+fRn6lYEDUlwfcmZ82J
   RolOk9caYhFRUAJtxifaBk+vRI9X9NQQUukiUiaDkp6m2aAWFDaWKT632
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="394446543"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="394446543"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 16:43:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="799340171"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="799340171"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2023 16:43:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 13 Nov 2023 16:43:43 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 13 Nov 2023 16:43:43 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 13 Nov 2023 16:43:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSPDeNCoXl3IHtoQGb8wPENcO4t60WfRnst39UGMz8Dbw96e0glvk8ZLEwcYIWXniWMZpTGqTay0zOU++PPGmQUGXQ5vrokx+C6yKv6goAIt413lNuWv7H/4Dxb8v8E/WdDanocvby+i6juv5NTps6fxBSladgKacSGvclVluZ88J9LUyStAfAt+SBwtUi1RUXjnk//Q1gSASrREdo4iTYpMZnslPd53onrqarkUC93ONnQ+unPFKP7v0l4bbzDN4hP/WuCIfpFnUavXIIgbkcAfU7ElVCL5lGnEGVTSun6AU5kLj3wWCPD2AzgdDsF8QdQymo09lYzQWRQM1dXWDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKtNRhIUg7Mr+IyCpRpr8MQo5ET9Z7oU1fIbXO8JoU8=;
 b=jc/3kFpfvuGw7Y2GYmYDcSspPl2spaF7pmqmTyw8biUWeMJqCPSrqxFi6ai9yT/il1qr8KRzaNo4Ggo4OU7SQJr2amqWZgir3xnlzfB5gt7BzUUHINkqAEg1J0ZGm4FE88XYwlvZ0p2pFHyBK/ZA3fMI8Un3nZ+mIj63bocnEz28GbSf+SIuLtZNyAURKOL/X5tDftLhAU5tl1bxVDw7EcKwMBgDNufMfpBTvypiC6k2a38P+y1/4F4OX9SsL5VvBkdKCx9P6OAAPpKFdkeJeAKZOetkJ93crSAR4evA1c1N5YoV5MsN5WseL9SNC1O75ce1LCmnNFJZg2BzzKTaAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by MN2PR11MB4518.namprd11.prod.outlook.com (2603:10b6:208:24f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 00:43:38 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 00:43:38 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "Lutomirski, Andy" <luto@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Christopherson,, Sean"
	<seanjc@google.com>, "peterz@infradead.org" <peterz@infradead.org>, "Gross,
 Jurgen" <jgross@suse.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "jiangshanlai@gmail.com"
	<jiangshanlai@gmail.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: RE: [PATCH v12 01/37] x86/cpufeatures: Add the cpu feature bit for
 WRMSRNS
Thread-Topic: [PATCH v12 01/37] x86/cpufeatures: Add the cpu feature bit for
 WRMSRNS
Thread-Index: AQHZ9caG3VIRGozoEkidJJiXW1l1kbBwlOyAgAieqDA=
Date: Tue, 14 Nov 2023 00:43:38 +0000
Message-ID: <SA1PR11MB673495967E44583FC36B5E39A8B2A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-2-xin3.li@intel.com>
 <20231108123647.GBZUuA31zntox0W0gu@fat_crate.local>
In-Reply-To: <20231108123647.GBZUuA31zntox0W0gu@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|MN2PR11MB4518:EE_
x-ms-office365-filtering-correlation-id: 9a6e5578-8a6c-45f6-3d07-08dbe4aabdb7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 191my9q75Ck1wvghTTQhs1geZ00xzBfZU0e4D/aVd7PoVcZxC0WozSdBEfVQjVAWjs7+VFxIvug0cgNR9khJgjkD9Mq78a+OkDhvzg5BPlWhfqtx1Ye7K6mFvhpP89GJEgGXwaC5kRX7uwOA5Gyvjf1gzLIeWXoBfaRPICjpBhVbop6orATmkAIxW1L9t29NOVmb8mcTLPBKEB9tSVkQFP13rlh/P72R/o8s+ZoRp0ZqRieAnuJ9ug/PDpvsFUS8t3rO5A9PZnQnu5IEVCt6UPd2WytZr37CebQb16ITGQerAX4BVTfkYQEBOFhOGjAg5yWqaUjeiSfwJV5CMU7dsxT1FGfD45c1t8Lqma4qsjFGK14pt2Klr1ZM1C5wwC+lHs8sP8TawWGgcvfr4xgQx8R1rkTtvyOA4xvVNK4tbnPmHBJ369yAJ5Xq84++BCaiQKqeKSnkJW4r2nnDpbLCYI8VquRrvkmuqBD4/Ot7Ab+WJWMy2D5W8tX3XhDGc3Hy+/CqfROVtZqSXr4VbYB3G9r7b/iAq9qeRy2zMIV9x2Q+vu0XW00WD9AZTDODEHSDTVLxXzuCKJ6vi1NEwB7dWzSRbkT7YwGtKFyO2VmfLrfnOhRr3SHVFx9lnfpgiRxiykFfMDNK9FZ7akziBqNRiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(366004)(136003)(346002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(38070700009)(122000001)(82960400001)(26005)(6506007)(478600001)(7696005)(71200400001)(966005)(9686003)(86362001)(55016003)(7416002)(5660300002)(52536014)(33656002)(41300700001)(2906002)(38100700002)(8676002)(8936002)(64756008)(316002)(6916009)(66476007)(66446008)(76116006)(4326008)(54906003)(66556008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVdvRmZ6TG9MNjR1cE5CRGRqZjZ5R3RGeWlRK1FUYW9BVldMMmg2UmFpcjlL?=
 =?utf-8?B?eG0vOXZyUy8vQm9xeVlvWkFlMGpNQldDTDNIRllRWnVZVk1LYi84MkZiL25m?=
 =?utf-8?B?dU0zSm1PeEhyd29aWElQbW9McVY1VUcwY0VVcE9kRTFGeW93Q2QrYitZc2RM?=
 =?utf-8?B?bDFYa3cvZjBTV2tOQVloS3ZSUXhCVEpNZ05Kbk40RWUwR2tOWWRVUklSL3lM?=
 =?utf-8?B?NTRvQUU0V1NuOHo1cmxydTMyejlxNVVCQjI4SVQvU2kxdWFVMkpKMTZUMnBH?=
 =?utf-8?B?WmNmZjhXdktRZEZtZFYvNDRHM0JVODg1VGRycUNONmJMK3Y2UXgrLzRUdUZQ?=
 =?utf-8?B?UlByOWZwSExlWFpWdFZhbThLbVl5UW9xN09LVm9wakxQUFRiY3ZTNXJlTWJU?=
 =?utf-8?B?UjQyTG1VQXQ2SmpUcFlDamxZYi9tSndjY3QxSUMxZmRBTU1ibzhQR2JPNExH?=
 =?utf-8?B?cFBqUWFNM3pTelZ5VDFrS3NRcHhUQ1FRd1VtNGxzd3c1UWZyUU53M1QzbEFx?=
 =?utf-8?B?L0tUMlZid0FYbDFzOEo0eXJPa2hUK1BJKzNkd0MyMTREZUNic29NOC8wSkFR?=
 =?utf-8?B?ayt1ekl0elpRQUtHeVZGN254LzVDY1lFeERsbytqeVNIVmVIQ2Y3OUE1OXpP?=
 =?utf-8?B?Y1dvUXZURHFOUTNsMG9Fd29DdEVkRWMvYlZQS2JxWVcwWDZtOXdIN2R5SEUv?=
 =?utf-8?B?aE1oYlFZZWVXYXYzUzdFVDhxNlJWMTV5WWs2a0JYRk51NHMva3hVd3Bpdjgr?=
 =?utf-8?B?UmtpVHAwRjArMzdXeG1oQitOZUJ4VW5TNU5GdlN5TXNDRkFaR1BXMFRwVzJL?=
 =?utf-8?B?bm9SZ2lEY2loU2ZnaENTUEpMYUJKRFJBc0pkaXVFUlJwODVFR21oWSt3Rzd0?=
 =?utf-8?B?eWUzeXZ1VjUrbFU0M3RNRHlNYktDbXA3WGtsZHFUQUpTdjc0Q2VoanVVOWRG?=
 =?utf-8?B?TEUzelRuTEpYNU9oSm5BSG5odFdCQSt3U1RGZXJiTUdQZ0o2Y2t4WEI4UVRC?=
 =?utf-8?B?dDRjUDNYL0VwbzloZkRzSVd0ZXdMS2daY1AwbzdqRTFzbE80T1BqalA1MS9S?=
 =?utf-8?B?dFphb0R6WThwK0hQMnpDcFZHaFN6dmkwYW5USHB2OEM1bmRIRU5MSjJPR25w?=
 =?utf-8?B?dmNkSmRQRXdpakV5emZ0MTNiUDFjOUFMMlNhMm5GdWV4VGRLVVJKQWUxRWhF?=
 =?utf-8?B?eTI4bzUrSlNoN1NDWHQvUENKTGRhcVNzOHl3WjdjV29zOGpKbTh5clErSDJr?=
 =?utf-8?B?K3BMMG8vcnFva0FUSjlqMjVhQ1QrV0cwU1JtYUNrYlZteHBsRUZwekZJS08v?=
 =?utf-8?B?eEFEdU56WlhPd0ZkKzBJTitzVnR3b1JtYlBqb2hRT0pYR2MyRGRvN2I2d1dj?=
 =?utf-8?B?SDdiNC9XbmsrUmlZaUVGc2RDL25SYWRUUzk5MXdwQnJoVm1YamwvYW0xZlRT?=
 =?utf-8?B?TEtKQUVWV0xHWHNKWk5wQnRvbkNSSkV6NzVrSndlR2Q3bHAwUGRMd2IyL1B1?=
 =?utf-8?B?cXYvNmk3VFdjd2xTc2Y0Wk9RT21ObjIraEc0T0ZvQTM4UTBuSTREL3A1ek81?=
 =?utf-8?B?Uy84ajNNZzBMNEZIR1JPQXpUeWI5dEY4ZkkraGV4ZDF5cHp4NFNFenhFZUlp?=
 =?utf-8?B?YXFrdnFoOSs5aEhaeFl2NVV3U0dZUU9Rek00YTEwWFZrN0gwbHprUEora3BV?=
 =?utf-8?B?NHZ1UHlqLzVRNVA3REJFdzZzOWZBSmZSQ1h0ZUdiOFdFQ2ExZFVqUUxVQWRx?=
 =?utf-8?B?UkNaaWxCY0RLNy92T0RsR0xmV00wOU9VTmcyR1VhTlVtYjNNK1k4UURjU2Nk?=
 =?utf-8?B?ZVpDSlNsQU1DeWg1WUZXcUdBUUlSUjBLenpSNE9oVlE3NFpXeHpWM1h2U0Ro?=
 =?utf-8?B?eEpHUHpLREVNVEVPbkRLRkx5ak50YXN0NkRtMG5MeTh4MHZaZXBCaHBvQTZK?=
 =?utf-8?B?WTNEWDBkbkRFWTBlb3I5dG1MYk1OaWpqUjVTUWN1TTNJYVo5d2dGSlRGb3FB?=
 =?utf-8?B?T1M3SHFiVjNsTzJJS1poZWlCUnVDTDhDR1A5UnRKMU1mOFFPL09CREdiNDlI?=
 =?utf-8?B?ZVBybExrRE9kZVdFdlEzQ2ZQNGw0TlNJcTlGcHl4QXRPTEZEQnV5ZnNBMlRa?=
 =?utf-8?Q?hssM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6e5578-8a6c-45f6-3d07-08dbe4aabdb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2023 00:43:38.1514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: klIHhrmQhTRhSjfJiHg4VlmRUYuZgdNQwVS0Rsltj7dt88KeT5qPeyp0yOAq6vKQkILvatMQItVYEU6DFVV+aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4518
X-OriginatorOrg: intel.com

PiBUaGVuLCBmdXJ0aGVyIGRvd24gaW4gdGhlIHBhdGNoc2V0LCBpdCBzYXlzOg0KPiANCj4gKwlp
ZiAoY3B1X2ZlYXR1cmVfZW5hYmxlZChYODZfRkVBVFVSRV9GUkVEKSkgew0KPiArCQkvKiBXUk1T
Uk5TIGlzIGEgYmFzZWxpbmUgZmVhdHVyZSBmb3IgRlJFRC4gKi8NCj4gDQo+IGJ1dCBXUk1TUk5T
IGlzIG5vdCBtZW50aW9uZWQgaW4gdGhlIEZSRUQgc3BlYyAiRG9jdW1lbnQgTnVtYmVyOg0KPiAz
NDY0NDYtMDA1VVMsIFJldmlzaW9uOiA1LjAiIHdoaWNoLCBhY2NvcmRpbmcgdG8NCj4gDQo+IGh0
dHBzOi8vd3d3LmludGVsLmNvbS9jb250ZW50L3d3dy91cy9lbi9jb250ZW50LWRldGFpbHMvNzgw
MTIxL2ZsZXhpYmxlLQ0KPiByZXR1cm4tYW5kLWV2ZW50LWRlbGl2ZXJ5LWZyZWQtc3BlY2lmaWNh
dGlvbi5odG1sDQo+IA0KPiBpcyB0aGUgbGF0ZXN0Lg0KPiANCj4gQW0gSSBsb29raW5nIGF0IHRo
ZSB3cm9uZyBvbmU/DQoNCk5vLiAgdGdseCBhc2tlZCBmb3IgaXQ6DQpodHRwczovL2xrbWwua2Vy
bmVsLm9yZy9rdm0vODd5MWg4MWh0NC5mZnNAdGdseC8NCg0KPiANCj4gQW5kIG5vdyBJJ20gd29u
ZGVyaW5nOiB3aGVuIHlvdSdyZSBhZGRpbmcgYSBzZXBhcmF0ZSBDUFVJRCBiaXQsIHRoZW4gdGhl
DQo+IGFib3ZlIHNob3VsZCBiZQ0KPiANCj4gKyAgICAgICBpZiAoY3B1X2ZlYXR1cmVfZW5hYmxl
ZChYODZfRkVBVFVSRV9XUk1TUk5TKSkgew0KPiArICAgICAgICAgICAgICAgLyogV1JNU1JOUyBp
cyBhIGJhc2VsaW5lIGZlYXR1cmUgZm9yIEZSRUQuICovDQoNCkJlY2F1c2Ugd2UgYXJlIGRvaW5n
IA0KCQl3cm1zcm5zKE1TUl9JQTMyX0ZSRURfUlNQMCwgLi4uKQ0KaGVyZSwgYW5kIFg4Nl9GRUFU
VVJFX1dSTVNSTlMgZG9lc24ndCBndWFyYW50ZWUgTVNSX0lBMzJfRlJFRF9SU1AwIGV4aXN0cy4N
Cg0KT3IgSSBtaXNzZWQgc29tZXRoaW5nPw0KDQo+IA0KPiBJIHNlZSB0aGF0IHlvdSdyZSBhZGRp
bmcgYSBkZXBlbmRlbmN5Og0KPiANCj4gKwl7IFg4Nl9GRUFUVVJFX0ZSRUQsCQkJWDg2X0ZFQVRV
UkVfV1JNU1JOUyAgIH0sDQo+IA0KPiB3aGljaCB0aGVuIG1lYW5zIHlvdSBkb24ndCBuZWVkIHRo
ZSBYODZfRkVBVFVSRV9XUk1TUk5TIGRlZmluaXRpb24gYXQgYWxsDQo+IGFuZCBjYW4gdXNlIFg4
Nl9GRUFUVVJFX0ZSRUQgb25seS4NCj4gDQo+IFNvLCB3aGF0J3MgdXA/DQoNCkZSRUQganVzdCBn
ZXRzIHRoZSBob25vciB0byBpbnRyb2R1Y2UgV1JNU1JOUyBhbmQgaXRzIGZpcnN0IHVzYWdlOg0K
aHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcva3ZtL2IwNWUzMDkyLThiYTMtZjRlMS1iNWEzLTIxMjU5
NDQ5MzZmZEB6eXRvci5jb20vDQoNCkFub3RoZXIgcGF0Y2ggc2V0IHNob3VsZCByZXBsYWNlIFdS
TVNSIHdpdGggV1JNU1JOUywgd2l0aCBTRVJJQUxJWkUgYWRkZWQNCndoZW4gbmVlZGVkLg0KDQpT
b3JyeSBmb3IgdGhlIGxhdGUgcmVzcG9uc2UsIGl0IHdhcyBhIGxvbmcgd2Vla2VuZCBpbiB0aGUg
VVMuDQoNClRoYW5rcyENCiAgICBYaW4NCg0K

