Return-Path: <kvm+bounces-1637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 462507EAA62
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 06:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6D201F240CE
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 05:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8571311732;
	Tue, 14 Nov 2023 05:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8wdR/34"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EDA101CC;
	Tue, 14 Nov 2023 05:58:39 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685E9D42;
	Mon, 13 Nov 2023 21:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699941517; x=1731477517;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P9rGz1PDhD2G2QNpTxzOiF7kPZ6vzZvmIboEtV5fAPY=;
  b=Z8wdR/34HYZzW/DyRwTDDJrkLtVcQ7VVsSUi5MbXoUVf4kqH60S8wbMj
   AlZcXJzPwPI/GGeC8N/lFL3gSZUflG6X/EMHIcqImd7O9M+ZmEk7gjB+U
   eiPAq4ePQrzfQcKKapcOCqdguaNIXKZ1BH3Fncx7e54WSb05zEoz0VsTC
   nRNGozLw15J0And33txGXTAO/N0eAVZdWpIVvqX3gTaNzaugyh0bGM5VX
   QjwSx3sAJtGNGNnPNhpyrzofEBxrLTAG8860/I+t/30aJepM/OqqUt8Za
   cZiRzgPgfiQ/aRvabB/WmxR+kNf5KkNYzdTMS+7GNKqpd3oHAe+RnFdOf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="394500840"
X-IronPort-AV: E=Sophos;i="6.03,301,1694761200"; 
   d="scan'208";a="394500840"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 21:58:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="830482989"
X-IronPort-AV: E=Sophos;i="6.03,301,1694761200"; 
   d="scan'208";a="830482989"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2023 21:58:36 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 13 Nov 2023 21:58:36 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 13 Nov 2023 21:58:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 13 Nov 2023 21:58:35 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 13 Nov 2023 21:58:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ9+sqvegs0a8U3tXT0H2wz72q+elbU0Fp31Lqi+s3FQUSmZwjfWGSNMq60ssmq+0MgwC0sg38gJBvQerC3N12rYtewLgcej11GDpkg8uVwxjXq1Kh/wbPzE6o5xzlklm+PxoZGK81lsv5HiwBsoUzuynImerqgZ6qvhDUqFyfqU18cuAoEAYOuWd8NWPm+/hu/FxA5gsA72t3yqFGZ0DUT82bb8Q3r4k7VD17nyI+cJ9PqpNLzQxmdreB56RSI+Dv60PiV9iYQbF2d+s22BR8/CywmHFV5rvs1SZJaPi+U/yEgWn1Boc4xeeYIZ7JNvluzc0KQJedI5WsKlrAZFQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9rGz1PDhD2G2QNpTxzOiF7kPZ6vzZvmIboEtV5fAPY=;
 b=ml3xu00WhlKYLv4MEmPCFg+nYfGBDSilTtB9wCpCJdRhw8QKTCGyAgCJZgl41SqZq0hECqMUXVPcMyZ9zQ7GuzaRmZn6XHXbJ+IqV1/M/MJ2P1ROKN35wCz7Byekqdiy7SjwwFnIh4RgU7Hm4sGTo2/BiJc8nxKNssXN41fvd5yvDjFD4xUrd+4J/liNpGkRWK5pHKpAlCSSAph9Iyl3ihHqP+ItM+9t+wF/76V7BCsUFShaTzH7IWYRaWINwWuUINYH3xb8FWkGUwUXuMVpK3FuwS2S5YGjBYQYk1AHl9ILAeD8hZjfGm9OV82yf0CANB7ndC2AmgrOPyYTty2gTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB6676.namprd11.prod.outlook.com (2603:10b6:510:1ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 05:58:32 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 05:58:32 +0000
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
Thread-Index: AQHZ9caG3VIRGozoEkidJJiXW1l1kbBwlOyAgAieqDCAAFBGgIAADvEQ
Date: Tue, 14 Nov 2023 05:58:32 +0000
Message-ID: <SA1PR11MB67340C23AF350C8CB4119090A8B2A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
 <20231003062458.23552-2-xin3.li@intel.com>
 <20231108123647.GBZUuA31zntox0W0gu@fat_crate.local>
 <SA1PR11MB673495967E44583FC36B5E39A8B2A@SA1PR11MB6734.namprd11.prod.outlook.com>
 <20231114050201.GAZVL/Sd/yLIdON9la@fat_crate.local>
In-Reply-To: <20231114050201.GAZVL/Sd/yLIdON9la@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB6676:EE_
x-ms-office365-filtering-correlation-id: e3dca745-c4a4-49cc-f94f-08dbe4d6bb7a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: myHYBNkoItwvVvYuz6gG/2fQ0l6uaBqiVaeqDGGlzZdvBYlBsgFU84FIy2E1Bdq9ToXrmiCLLKq7Aroqbq1rqX0Sp5lA2kjtp6wFXMGKijuMRecwDnSQDQrmDetXFd2SX0dgjjhoOX3bPyQ7Gv8od5INiz+MKDDlZ6u6Mbj+NZKVqLL71TYIezVmlcjtdGTe11hbYq8+/68Rg1UxmVoREuq4gF8HgR3rWyqPu0zwoVrTfELyUFrd4g4kuBFVn1imYmxLQpHqsMFUI8grYqv9fglPee58b24d2p9fQFPp4TUhE0Xpq1Byds00Ub59ublZNHhi1Vb7ywM/+WQyDEx2zRAEbDuh8VxejNvQY/0mWufY8GR5490rv07KdLCx+fE2SrWICarVjDQ2HIbOfrePrwF7AmT6854EF9tDLQG6hLNaZX7oj6v3e7ZlYVkKkmtuJbWDXNV1JuORRzrrlDbtvlby8uEZSY2pd7dEJmh9ibwgT8sasBOQ8Sjxi21lVXwfs5XDM/h/xM+Uu+zHqKlZZ4SKLAgmBq8v6T5Drrj5E/ec/6vSDtHd1kQBnYa8v2bpVQWj5AnTc+RXMo7MXYw3ExMPfmIUqdSKgRQhOBpY2jropDan3oUblMFKSR673uQc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(366004)(396003)(376002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(8676002)(8936002)(55016003)(41300700001)(4744005)(5660300002)(7416002)(2906002)(316002)(52536014)(38070700009)(4326008)(33656002)(66446008)(66476007)(64756008)(54906003)(6916009)(66946007)(66556008)(86362001)(38100700002)(9686003)(7696005)(6506007)(71200400001)(76116006)(122000001)(82960400001)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3VMMVY4WTAwcE8xTlhOd2VUbWl2enJWT1JRc1AwT3EzaWtIbzNVazFFMENy?=
 =?utf-8?B?NEhvc2Fnai9FVVZKNkExc0tOWndyUGVZSGUxdjAyR1M4OTU4Q2daYTU0aVFV?=
 =?utf-8?B?WDkxN2haRTJGUWgvbXppQ3dMV1VMaFlCMTdHeHJQODNFWGtmaTA3YTh1SnF3?=
 =?utf-8?B?YXhuaDRzV0NDZTIrbFJsa0h6RVhGaWxCRUx6L09KWUhsdXdGVXU4aHBadHQr?=
 =?utf-8?B?ZXBpNDNrTlZQN0hhWWJQWTk4OU1LcHhsUkZ4RnRhcUhidm9HWjZpYWU2eFV2?=
 =?utf-8?B?OFRWbkxFVlRRa0hEWGNrZWhJZE9GQ1pCYURmTjBNYXdFeU4wMUYvQVpaWWpq?=
 =?utf-8?B?cVZTZ2RHTG1hd3oxdEJDS3ZGVWkySGRSUWlqdmJHKzlGQnlrWXRhNy9sZGln?=
 =?utf-8?B?TmJGbDYrMkdqa0RjblhLNFVNMFNyU09XQ2p0V2J3SThNdXZsU1BMQXhhTnFN?=
 =?utf-8?B?Z3JKNU5McjRIRktpOTR2WFhYQ2ZRUXNUR3VUSEVZdDFCbTgyMVdacWduZElC?=
 =?utf-8?B?ZEFPOFFIam9vZDJzUlFCY1Ayd3JCRmVMd05jL0c0Nmwvc2RxOWYyc05mRTJX?=
 =?utf-8?B?VWlleDZCdmdPbFEyQWZpRmNvZlNtTkx6dGJGeTVodkg0dFFZU0ZTVjlJR1lC?=
 =?utf-8?B?dzg1YytHajdrQjBtOFhxeWJjVm01SDhIcy9EZHlGMkhJbjdHTnRwL3JPQmVR?=
 =?utf-8?B?S0d6aC9IMStVWXJxS3pXNDFnOGRGRHM5MU5WMjJvaGxSSjdkLzFKVXZJQW9i?=
 =?utf-8?B?N0R2U3U0Z2kwZUdqZEsxSnNuY1JqRzVLaTQyQjZTVWhGczk4djdMTkRWNUJC?=
 =?utf-8?B?dmFQbXh4alRkNkJyZnVoaDF0OWxUdENETnl2djVsU085Mk5qUVVnQjJuOThG?=
 =?utf-8?B?MS9aNkxvQ3pXVDhUUGkwTTVEbXR6MWlSTDNpaG1qdlhVUnZIWFRRZXlMQS8y?=
 =?utf-8?B?VzlQa0NJYkhOOEdhTlY1WmlQU1E5QWh1QlVKaFFPVWwyQkk3UjMwUGtKblpS?=
 =?utf-8?B?Nlp1R1oxcmVZeUNrejlZZTl3eXU0M2NjR09keWtQcWR1aEZlbkZ1VHNVRXhq?=
 =?utf-8?B?Z1Y5OVl4QVhDMmVRZkhqTWVuRHp1TUFPUitpb3Jxend3eE1zY0cyR05OTjF5?=
 =?utf-8?B?cHRmUUw5RTcwVzJoRHVYZDBTb2RQQk90bGNkd2lydE5jTElGNXdYZlhOZlJO?=
 =?utf-8?B?TXVBdExXVG45NHdESDlTRFVCS0IvckcxbVIwUG5qaDhCcTc1cDJKZk1VcDI1?=
 =?utf-8?B?SWV4TWJRa1JIWjNWUE82ZXh5ZWN4YWRIOW80bk5iSjVGTUU0Uk4xWnAvSVVW?=
 =?utf-8?B?QzNZc2xjRlYwL3FhZmMyUFVCUUxoNjBaTkFLQ2ZLcU5Oa0lvNHArY2RrQk9B?=
 =?utf-8?B?SW9ISUlHUG9pcjQrZmsyU0RqY1B3ZzZ2ajI4NzhYTk16bTR3OVF3WXJUQ3hE?=
 =?utf-8?B?UVdCWjQ4QmtjekVDK1V5Vm1XK1Q2ZWN3T1RuRW9ZdDNVd0daWmsvUDBtQkFT?=
 =?utf-8?B?dzUzLzJQUUU4RG4yMnBDWHR5OFhlTUtZM0N0bXFNc0xhS2Y1WW5UUGE4aGF2?=
 =?utf-8?B?L1VEQWlWNDRqME9zOHFEQ3FWSWlxU1B4aVhRRWw5ZjVyQUF5VnpYMkNRS3FZ?=
 =?utf-8?B?TEpCYXdEcGV3QjlIbUJjOU1IWnc0d2FpaGNSTzBNZ3lpU2tLc3c3K1NzeW5R?=
 =?utf-8?B?VlhGdTk2N2c2L2Q0TnVxNVJRM3lNUlNaUTRMalk5RGtmMHY0Z1RVRWVGTmVs?=
 =?utf-8?B?ZXNqazVWTWkrZGpVSW5VOXBLTmxMQlZiSlpFSyt5Y3NTak9DR2JwNmk2dnRG?=
 =?utf-8?B?Q1paMWpkYXZvU2lCL3JwSG1JSlNGMnNkYTYrd1ZWZ1pHUE1DSTBkRHhFSW1V?=
 =?utf-8?B?cjZDcXJydHdvUHJsRDNjSjk0UXRGdDNIVGdibzh6a2s5Y0RVd2VOWEZKbmN1?=
 =?utf-8?B?NmdReVdCRjNESFUxMEtRb1FUUjJFMm5mTjFPam9pSHFqZ25BWFBxbU4vV0Nr?=
 =?utf-8?B?R3h2dHE2eGFTeWZJcFZVS01FbWkvMnhwYmpsWDJhbTV3RXRsOElHb0JhZklk?=
 =?utf-8?B?OXpyUE0rUDB6OXh6K0FPMnYvekh5T1RmNmxLWlhOMHJwVXUxQlQyblJmbGNt?=
 =?utf-8?Q?gqOU=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e3dca745-c4a4-49cc-f94f-08dbe4d6bb7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2023 05:58:32.2039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rv84rYJZYZYUabTA7zFEUMZUiMqAajsSmZmry1Hx4rcDHfR4LIkyNWP7+E+JH9atOGV+FFpEQpGbDX4hzZHHtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6676
X-OriginatorOrg: intel.com

PiBhbmQgaWYgeW91IGhhZCB0byBiZSBwcmVjaXNlLCB0aGUgY29kZSBzaG91bGQgZG86DQo+IA0K
PiAJaWYgKGNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfRlJFRCkpIHsNCj4gCQlpZiAo
Y3B1X2ZlYXR1cmVfZW5hYmxlZChYODZfRkVBVFVSRV9XUk1TUk5TKSkNCj4gCQkJd3Jtc3JucyhN
U1JfSUEzMl9GUkVEX1JTUDAsICh1bnNpZ25lZA0KPiBsb25nKXRhc2tfc3RhY2tfcGFnZSh0YXNr
KSArIFRIUkVBRF9TSVpFKTsNCj4gCQllbHNlDQo+IAkJCXdybXNyKE1TUl9JQTMyX0ZSRURfUlNQ
MCwgKHVuc2lnbmVkDQo+IGxvbmcpdGFza19zdGFja19wYWdlKHRhc2spICsgVEhSRUFEX1NJWkUp
Ow0KPiAJfQ0KDQpUaGlzIGlzIGV4YWN0bHkgd2hhdCB0Z2x4IHdhbnRlZCB0byBhdm9pZC4NCg0K
QW5kIEkgbG92ZSB0aGUgaWRlYSAiYmFzZWxpbmUiLCBlc3BlY2lhbGx5IHdlIGhhdmUgYSB0b24g
b2YgQ1BVIGZlYXR1cmVzLg0KDQo+IA0KPiA+IEFub3RoZXIgcGF0Y2ggc2V0IHNob3VsZCByZXBs
YWNlIFdSTVNSIHdpdGggV1JNU1JOUywgd2l0aCBTRVJJQUxJWkUNCj4gPiBhZGRlZCB3aGVuIG5l
ZWRlZC4NCj4gDQo+IEkgc2Vuc2Ugc29tZW9uZSB3YW50cyB0byBvcHRpbWl6ZSBNU1Igd3JpdGVz
IC4uLiA6LSkNCg0KOi0pDQo=

