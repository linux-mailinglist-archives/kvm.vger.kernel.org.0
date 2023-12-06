Return-Path: <kvm+bounces-3668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 510938068E2
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:45:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B03B0B2124C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 07:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED77518657;
	Wed,  6 Dec 2023 07:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zz1Jz8Nx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4459D72;
	Tue,  5 Dec 2023 23:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701848737; x=1733384737;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PeR6bfBpgy18QpMpfJJ3D6YjFpIWK8tJNg91Z0TInUI=;
  b=Zz1Jz8NxDpisYc9GFKFAU4jt961XMAsRpBbI2wqtZ3UQK2PE8bQNQ2pP
   yAoYZZ8NbN0t95mRaJQzWQTtqM0tEtBZNM4dLm2Bfp4dE0z+7zDNN7CGB
   aVFkE4SZQo9q1goBO/2EvnZXtj58ZQf8PBynZdeduzCxINHzOxPdrYcC/
   rMx5Uiwc2JHyIMDbBqoyTfUFcuNuIZk6A99YCkUyMzH6nUnUQIEMjAKD7
   ITaSBGzO3wy5VGWUeDDNSc9O7fIeUCf+hbEVXMQ+6PlwZY6XF1Q4+P3yw
   2yuRoIVNLHqZssjx6DrFeOJvOpG6WWq2VVYJO4GsbXLi9wYxHdR2KhLiZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="397910770"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="397910770"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 23:45:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="12598909"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 23:45:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 23:45:35 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 23:45:35 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 5 Dec 2023 23:45:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVZHYk9Q13Uhn+F7sPTzIKSiDe90t9NKXQz0C1VMjVR601Qt6nyit1gsdQOIAszDszuVZdWc/R7VQhPe7O/2PdDcBW+RlpkDl/w9BRSNnTv2x07USSXAb6fUmGW0T3GenZi0qWeSn2aOONgvsMvInzA2TL4Au9+tpQfQVPZtycGmqnPIhmw/xfU9dCrWG7FhW3qUH/sN85eTttUGSwbLbb7PQ0abp5vBUzasyb7e1FT238LYwf++jpjqKPZfyATBvBI2r4owDh5OqoZj+E7l5TsyY/04mz/4M0M1/ctnftnIM4Dm7Rttkl1MLHgQK7EAUvKJ5Pr/enBWyfyiZUw3+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PeR6bfBpgy18QpMpfJJ3D6YjFpIWK8tJNg91Z0TInUI=;
 b=lMtaN3+WAsD7naYRe0lGo44GESQjyThugLMQqwVSa7Q8DienZ+dnsZ8Np0xxfT1i0IbVEd/Tk6SPxgfiJOrouujyzfRg4fmsbRTy91ZcwWcIxYfWhu4DayG2CY6SOsRmzZ34AmMbpQlhYDOD5SXzsF2LatCOFKQC45Tq2dNV5fp0V1tZaDlOFbNuHccsRuaQjz/EmJMAG2x7PcvP1PYVgD0P9so7R2s4GKy4mfEON4InmL7ia+ISlXmcinWpKbSktLU2HVAo9Lm8m/jyJGdwe52RIs2u8e6OQD4ndXreWNrpLDRK5LWk+K7IqfFlh1VPYIUCPyen+jTGvpWFBOzY4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SN7PR11MB7044.namprd11.prod.outlook.com (2603:10b6:806:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Wed, 6 Dec
 2023 07:45:32 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d98:6afd:a4b2:49e3%7]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 07:45:31 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Lutomirski, Andy"
	<luto@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gross, Jurgen" <jgross@suse.com>, "Shankar, Ravi V"
	<ravi.v.shankar@intel.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>,
	"jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v13 26/35] x86/fred: FRED entry/exit and dispatch code
Thread-Topic: [PATCH v13 26/35] x86/fred: FRED entry/exit and dispatch code
Thread-Index: AQHaJ215PhEOYu43sEObVSTXzfHZOLCanWSAgAE5e5A=
Date: Wed, 6 Dec 2023 07:45:31 +0000
Message-ID: <SA1PR11MB67343544B0CEB6C82002790DA884A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
 <20231205105030.8698-27-xin3.li@intel.com>
 <f260ddf9-be67-48e0-8121-6f58d46f7978@citrix.com>
In-Reply-To: <f260ddf9-be67-48e0-8121-6f58d46f7978@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SN7PR11MB7044:EE_
x-ms-office365-filtering-correlation-id: 76fc45d0-5732-4589-5cfa-08dbf62f52ab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 46KCXT5r6ViK0ZWH+jRPSxl5hdKQd2gPv4ifQs68ksYTCPaaQrf40TjQfGIsBV3VSWfEDwHDJck/xDEBow6pErYqz9mg11323qr8SvOcBc+6x/KhIY5B0ovDIjucorh8VAFYM/9VLqX9A1zY4ewkDU0qHLiyTg22fz70BuGjIcz1L/gHII+lOdohU7uZ/1WkSfCgh0ssZBUJDThLVIZILDHRnL0zNitmWgUcyDwQISZFP698hSnPnVxyeMJ6JK+LAtTu8FpYrOktvCyoRbuevt8Wc7DB3VGQSF625T75VyzFTOpuLrjcnHiQ3ymwCRANyuB414ePa5bVNT8QrvxeKI0OPwbq+sPRJyLIQPMwboHFQfpL07B94xkmbAJrZ4LQCWa5EpuMGrPYXr8UzenTzV5onb6SqhdRAe+sOavsUeULOZbWCeEltMYDxC6C8ollTBfQIO76l6hgQ9JGLoeAqU+AiWbn2XP6wxTAn1nZeb5V/ZBTSxip7TaobqsfTEcwCtLV88fP36eBJxIKRVhX7PBcZLrR9W70uNQr90cVvVrYvAqucv7o7S86advkEDUDYhjrHRcVoluvWM8zqBii0xblJ8X1/J59SCpo/GP3Tgq9uW7niaDYATLKTx/RFym4ue/GhTya6fFXKGbviBZUsFNg7V3tmaaC/oa2HXHUiDI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(366004)(346002)(396003)(230273577357003)(230922051799003)(230173577357003)(1800799012)(451199024)(186009)(64100799003)(83380400001)(38100700002)(122000001)(86362001)(7696005)(76116006)(6506007)(64756008)(5660300002)(52536014)(8676002)(82960400001)(4326008)(478600001)(66476007)(110136005)(7416002)(54906003)(66446008)(66946007)(71200400001)(316002)(41300700001)(33656002)(9686003)(2906002)(8936002)(55016003)(38070700009)(26005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bE1TVkRWOU5jT1JkdDJ3MUdZR1dNTjR2S2NzMU50aXRqRFV3eFJSUXZBR2RU?=
 =?utf-8?B?TnFXdlJ3azVYWlM2TjRveitaTnBDMzRwRVpNbm1wTDJrRjQxcjBxMi9aczF1?=
 =?utf-8?B?K09udHJubnRIb1IwQzUwM0VXMmw2Yms0dU96WFgrN1Q2bGNPdjhDQURRblRq?=
 =?utf-8?B?RlRiOE1PVkZOWVdRc3NZWUZTRElEYStHWk15Uk1GRGNYRHlWVGF4RHpSRkMx?=
 =?utf-8?B?ckFwa0NMdnVKRmFwbktRR1BvRzIyTEZiS1QvUnlYQTJjUU53Q29SOUZnV05s?=
 =?utf-8?B?UThLVkJobFY2cENscFZUNWdDUm5HQjVQcG5pUFpuMytrVXZTZG1KMWQyZVNw?=
 =?utf-8?B?aFZZU2c3a1I4YXNsSEx6WGZYZmk0UjlJN0wvSEU4OEdGb0hQSWlVOU5DKyta?=
 =?utf-8?B?dkx4L21YamtNdi9kamFJU3ZIcUQzRCtoQ0FLK0tQR1Q3bDhYVW9LSUVpVDY1?=
 =?utf-8?B?eEN5Um9xYnR5bUdNbzVWS3ZnWVhTOXNWY2Z4cW5kZjUxb1lrQnF2aHU3Vm84?=
 =?utf-8?B?OUFFQmZxSzhVTkRNZTV3Nzh3NGI1QzRHdHZaOGlMeEQ1M3pLdmxxbXFveTFR?=
 =?utf-8?B?TEFsRCt2dVdKVTVrdTlIMU1xOFVLUFFtU3BnZEVObnRvT21ZYnczRVU3VEg3?=
 =?utf-8?B?dzJjb1dwWUttTEgvWHJiOXNmWGZ6Y1FTcVlycTcrUWxDKzkydG1GeEhoWEIy?=
 =?utf-8?B?NlR1UUU4TGdpZUlsVk5FK29qUHkzUEsybzg2V0dqVERyMUc4UWd6VWp1Umsv?=
 =?utf-8?B?TGl4RkNubGlKMDNGa1Juc1lkUURyWnlFTDhpU1hPbVI5SnM0RE1HaksvRXVU?=
 =?utf-8?B?WEg4ak1EYURSS21BNi9XVklTdU1VVVlFcXRuVXNZMTBaalhETEluTmR2OW1M?=
 =?utf-8?B?SW1LQU52Um5xQnlXalZJdWhETmxpUm1DMjRSaExEakZuOWQ3ZldCMmtJRVdq?=
 =?utf-8?B?OGNZdkJqSWlQSHBaOTFkWUhkYm8vWSs5TkFaTy9ueG12MEZwaGYwVVppMlBQ?=
 =?utf-8?B?Y1pJWndwRHZ1anZHSWErMi9zdHR6ekhsS2lsUndXVG1zT0NMMDErZWRlc0Iy?=
 =?utf-8?B?YWRiaDhsSGF1OVVLSEFBMVVEbERadEJMS0tDUlNoN2gzZHl1SUxuOTBBRHJn?=
 =?utf-8?B?MURQT3dtM0tObDdKanA0a3BaYWVvUXNuYVkrS21LVGJqYi8vMy9kSFlZZFps?=
 =?utf-8?B?ZzRMN1pRbWxxSEZzeVMwN3BZNHU0U25TbHN4TjltRXBlbzJLRW40c0VUaWV0?=
 =?utf-8?B?czRBYWlLc3FtSGFYb2RwSmlyTmcxNno1NnRqazFSVFFib1lPOVdvelV5R3VC?=
 =?utf-8?B?UkJhcjNQZjVwbHBMVUpnVUxuRjZJQkV4ZW1VbThpM3pmTkNQMklhdExvdlpr?=
 =?utf-8?B?N05EbkJ2YWFNd3l1UDJ1dFNybTFlOWhQaCtYcGIzU1NzTGY0Y3ZaSHN6Q09V?=
 =?utf-8?B?TVc5WW9qSjdVeXU5Yk01dENVcVpEM0tiVkVhMktqYlEvejV3cjNyUEFHblhQ?=
 =?utf-8?B?R3VQTXVDMUZnYjVTREpSc2pZcDl1cHF6VTRnSzRqTEpKaGNLR2NhNGhIaWpI?=
 =?utf-8?B?QXQ5MVNLRjBMTzNPeG4vK21jODNzZmhFeng3VG9FM1plMnVmaHdnTUhyS1pP?=
 =?utf-8?B?QndBU1FTdHhnN2xrNTZmQnhaYTNoTUw3aDdURFRraGF2bmNOVUJ4dWtPYlVW?=
 =?utf-8?B?TnR4MEVBb0wwSCt4bkNJcnVUNm55Y0pxR21hVnBDQVFUMlBmb3RvT3FoR1Bx?=
 =?utf-8?B?dmszNVRENVd6ZHpJODNpTmVaUmplN1FXcFloTWlTaFQ1S1FmbHlqaWhJb1Ra?=
 =?utf-8?B?WGdLaWw1WS9GVk16NkloWDBHay9IZ0JCT2JDVzF0eEFtUEdTNFNpQmtWRHcv?=
 =?utf-8?B?WklXU2sweVdQRnFOVGtPeVhISlVJU0YxS3JoQVI1Q09SSHNvKzFaaWRDK2pK?=
 =?utf-8?B?NUZwRWhUOTZVZW1MWkwxUlZWbFpaa2dFRjVhaTVxQVpvUVJYUGVRZklkSVQr?=
 =?utf-8?B?ZFJtcnViMlFIVUdlTzZ1NDRMdHVmbTNaSDg3ZTB1eitEdjA3ZXpHaDNpTFlj?=
 =?utf-8?B?K0NzeTJmU3FxOVZudnJyQzFvZzJ3TnI5YlV5WUxhdnZRTVVEVnk4d1RLUHZ5?=
 =?utf-8?Q?2uoE=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 76fc45d0-5732-4589-5cfa-08dbf62f52ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2023 07:45:31.3863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hag3xuHnGtyFf8+FTc3INUhzPOqCJ8ZzP0bMF1d8a8QVHiKooVYrZDad4Xyb9Tffw68hTiUqwBXl3uCanOdBOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7044
X-OriginatorOrg: intel.com

PiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9lbnRyeS9lbnRyeV9mcmVkLmMgYi9hcmNoL3g4Ni9l
bnRyeS9lbnRyeV9mcmVkLmMNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NCBpbmRleCAwMDAwMDAw
MDAwMDAuLjIxNTg4M2U5MGY5NA0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9hcmNoL3g4
Ni9lbnRyeS9lbnRyeV9mcmVkLmMNCj4gPiBAQCAtMCwwICsxLDIzMCBAQA0KPiA+IC4uLg0KPiA+
ICtzdGF0aWMgbm9pbnN0ciB2b2lkIGZyZWRfaW50eChzdHJ1Y3QgcHRfcmVncyAqcmVncykgew0K
PiA+ICsJc3dpdGNoIChyZWdzLT5mcmVkX3NzLnZlY3Rvcikgew0KPiA+ICsJLyogSU5UMCAqLw0K
PiANCj4gSU5UTyAoZm9yIG92ZXJmbG93KSwgbm90IElOVC16ZXJvLsKgIEhvd2V2ZXIuLi4NCg0K
TXkgYmFkIGFnYWluLi4uDQoNCj4gPiArCWNhc2UgWDg2X1RSQVBfT0Y6DQo+ID4gKwkJZXhjX292
ZXJmbG93KHJlZ3MpOw0KPiA+ICsJCXJldHVybjsNCj4gPiArDQo+ID4gKwkvKiBJTlQzICovDQo+
ID4gKwljYXNlIFg4Nl9UUkFQX0JQOg0KPiA+ICsJCWV4Y19pbnQzKHJlZ3MpOw0KPiA+ICsJCXJl
dHVybjsNCj4gDQo+IC4uLiBuZWl0aGVyIE9GIG5vciBCUCB3aWxsIGV2ZXIgZW50ZXIgZnJlZF9p
bnR4KCkgYmVjYXVzZSB0aGV5J3JlIHR5cGUgU1dFWEMgbm90DQo+IFNXSU5ULg0KDQpQZXIgRlJF
RCBzcGVjIDUuMCwgc2VjdGlvbiA3LjMgU29mdHdhcmUgSW50ZXJydXB0cyBhbmQgUmVsYXRlZCBJ
bnN0cnVjdGlvbnM6DQpJTlQgbiAob3Bjb2RlIENEIGZvbGxvd2VkIGJ5IGFuIGltbWVkaWF0ZSBi
eXRlKTogVGhlcmUgYXJlIDI1NiBzdWNoDQpzb2Z0d2FyZSBpbnRlcnJ1cHQgaW5zdHJ1Y3Rpb25z
LCBvbmUgZm9yIGVhY2ggdmFsdWUgbiBvZiB0aGUgaW1tZWRpYXRlDQpieXRlICgw4oCTMjU1KS4N
Cg0KQW5kIGFwcGVuZGl4IEIgRXZlbnQgU3RhY2sgTGV2ZWxzOg0KSWYgdGhlIGV2ZW50IGlzIGFu
IGV4ZWN1dGlvbiBvZiBJTlQgbiAob3Bjb2RlIENEIG4gZm9yIDgtYml0IHZhbHVlIG4pLA0KdGhl
IGV2ZW50IHN0YWNrIGxldmVsIGlzIDAuIFRoZSBldmVudCB0eXBlIGlzIDQgKHNvZnR3YXJlIGlu
dGVycnVwdCkNCmFuZCB0aGUgdmVjdG9yIGlzIG4uDQoNClNvIGludCAkMHg0IGFuZCBpbnQgJDB4
MyAodXNlIGFzbSgiLmJ5dGUgMHhDRCwgMHgwMyIpKSBnZXQgaGVyZS4NCg0KQnV0IGludG8gKDB4
Q0UpIGFuZCBpbnQzICgweENDKSBkbyB1c2UgZXZlbnQgdHlwZSBTV0VYQy4gDQoNCkJUVywgaW50
byBpcyBOT1QgYWxsb3dlZCBpbiA2NC1iaXQgbW9kZSBidXQgImludCAkMHg0IiBpcyBhbGxvd2Vk
Lg0KDQo+IA0KPiBTV0lOVCBpcyBzdHJpY3RseSB0aGUgSU5UICRpbW04IGluc3RydWN0aW9uLg0K
PiANCj4gPiAuLi4NCj4gPiArc3RhdGljIG5vaW5zdHIgdm9pZCBmcmVkX2V4dGludChzdHJ1Y3Qg
cHRfcmVncyAqcmVncykgew0KPiA+ICsJdW5zaWduZWQgaW50IHZlY3RvciA9IHJlZ3MtPmZyZWRf
c3MudmVjdG9yOw0KPiA+ICsNCj4gPiArCWlmIChXQVJOX09OX09OQ0UodmVjdG9yIDwgRklSU1Rf
RVhURVJOQUxfVkVDVE9SKSkNCj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJaWYgKGxpa2Vs
eSh2ZWN0b3IgPj0gRklSU1RfU1lTVEVNX1ZFQ1RPUikpIHsNCj4gPiArCQlpcnFlbnRyeV9zdGF0
ZV90IHN0YXRlID0gaXJxZW50cnlfZW50ZXIocmVncyk7DQo+ID4gKw0KPiA+ICsJCWluc3RydW1l
bnRhdGlvbl9iZWdpbigpOw0KPiA+ICsJCXN5c3ZlY190YWJsZVt2ZWN0b3IgLSBGSVJTVF9TWVNU
RU1fVkVDVE9SXShyZWdzKTsNCj4gDQo+IGFycmF5X2luZGV4X21hc2tfbm9zcGVjKCkNCj4gDQo+
IFRoaXMgaXMgZWFzeSBmb3IgYW4gYXR0YWNrZXIgdG8gYWJ1c2UsIHRvIGluc3RhbGwgbm9uLWZ1
bmN0aW9uLXBvaW50ZXIgdGFyZ2V0cyBpbnRvDQo+IHRoZSBpbmRpcmVjdCBwcmVkaWN0b3IuDQoN
CkhQQSBkaWQgdXNlIGFycmF5X2luZGV4X25vc3BlYygpIGF0IHRoZSBiZWdpbm5pbmcsIGJ1dCBJ
IGZvcmdvdCBpdCBsYXRlci4NCg0KPiANCj4gPiArCQlpbnN0cnVtZW50YXRpb25fZW5kKCk7DQo+
ID4gKwkJaXJxZW50cnlfZXhpdChyZWdzLCBzdGF0ZSk7DQo+ID4gKwl9IGVsc2Ugew0KPiA+ICsJ
CWNvbW1vbl9pbnRlcnJ1cHQocmVncywgdmVjdG9yKTsNCj4gPiArCX0NCj4gPiArfQ0KPiA+ICsN
Cj4gPiArc3RhdGljIG5vaW5zdHIgdm9pZCBmcmVkX2V4Y2VwdGlvbihzdHJ1Y3QgcHRfcmVncyAq
cmVncywgdW5zaWduZWQNCj4gPiArbG9uZyBlcnJvcl9jb2RlKSB7DQo+ID4gKwkvKiBPcHRpbWl6
ZSBmb3IgI1BGLiBUaGF0J3MgdGhlIG9ubHkgZXhjZXB0aW9uIHdoaWNoIG1hdHRlcnMgcGVyZm9y
bWFuY2UNCj4gd2lzZSAqLw0KPiA+ICsJaWYgKGxpa2VseShyZWdzLT5mcmVkX3NzLnZlY3RvciA9
PSBYODZfVFJBUF9QRikpIHsNCj4gPiArCQlleGNfcGFnZV9mYXVsdChyZWdzLCBlcnJvcl9jb2Rl
KTsNCj4gPiArCQlyZXR1cm47DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJc3dpdGNoIChyZWdzLT5m
cmVkX3NzLnZlY3Rvcikgew0KPiA+ICsJY2FzZSBYODZfVFJBUF9ERTogcmV0dXJuIGV4Y19kaXZp
ZGVfZXJyb3IocmVncyk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX0RCOiByZXR1cm4gZnJlZF9leGNf
ZGVidWcocmVncyk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX0JQOiByZXR1cm4gZXhjX2ludDMocmVn
cyk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX09GOiByZXR1cm4gZXhjX292ZXJmbG93KHJlZ3MpOw0K
PiANCj4gRGVwZW5kaW5nIG9uIHdoYXQgeW91IHdhbnQgdG8gZG8gd2l0aCBCUC9PRiB2cyBmcmVk
X2ludHgoKSwgdGhpcyBtYXkgbmVlZA0KPiBhZGp1c3RpbmcuDQo+IA0KPiBJZiB5b3UgYXJlIGNy
b3NzLWNoZWNraW5nIHR5cGUgYW5kIHZlY3RvciwgdGhlbiB0aGVzZSBzaG91bGQgYmUgcmVqZWN0
ZWQgZm9yIG5vdA0KPiBiZWluZyBvZiB0eXBlIEhXRVhDLg0KDQpZb3UncmUgcmlnaHQsIHRoZSBl
dmVudCB0eXBlIG5lZWRzIHRvIGJlIFNXRVhDIGZvciBpbnRvIGFuZCBpbnQzLg0KDQpIb3dldmVy
LCB3b3VsZCBpdCBiZSBvdmVya2lsbGluZz8gIEFzc3VtaW5nIGhhcmR3YXJlIGFuZCBWTU0gYXJl
IHNhbmUuDQoNCj4gDQo+ID4gKwljYXNlIFg4Nl9UUkFQX0JSOiByZXR1cm4gZXhjX2JvdW5kcyhy
ZWdzKTsNCj4gPiArCWNhc2UgWDg2X1RSQVBfVUQ6IHJldHVybiBleGNfaW52YWxpZF9vcChyZWdz
KTsNCj4gPiArCWNhc2UgWDg2X1RSQVBfTk06IHJldHVybiBleGNfZGV2aWNlX25vdF9hdmFpbGFi
bGUocmVncyk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX0RGOiByZXR1cm4gZXhjX2RvdWJsZV9mYXVs
dChyZWdzLCBlcnJvcl9jb2RlKTsNCj4gPiArCWNhc2UgWDg2X1RSQVBfVFM6IHJldHVybiBleGNf
aW52YWxpZF90c3MocmVncywgZXJyb3JfY29kZSk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX05QOiBy
ZXR1cm4gZXhjX3NlZ21lbnRfbm90X3ByZXNlbnQocmVncywgZXJyb3JfY29kZSk7DQo+ID4gKwlj
YXNlIFg4Nl9UUkFQX1NTOiByZXR1cm4gZXhjX3N0YWNrX3NlZ21lbnQocmVncywgZXJyb3JfY29k
ZSk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX0dQOiByZXR1cm4gZXhjX2dlbmVyYWxfcHJvdGVjdGlv
bihyZWdzLCBlcnJvcl9jb2RlKTsNCj4gPiArCWNhc2UgWDg2X1RSQVBfTUY6IHJldHVybiBleGNf
Y29wcm9jZXNzb3JfZXJyb3IocmVncyk7DQo+ID4gKwljYXNlIFg4Nl9UUkFQX0FDOiByZXR1cm4g
ZXhjX2FsaWdubWVudF9jaGVjayhyZWdzLCBlcnJvcl9jb2RlKTsNCj4gPiArCWNhc2UgWDg2X1RS
QVBfWEY6IHJldHVybiBleGNfc2ltZF9jb3Byb2Nlc3Nvcl9lcnJvcihyZWdzKTsNCj4gPiArDQo+
ID4gKyNpZmRlZiBDT05GSUdfWDg2X01DRQ0KPiA+ICsJY2FzZSBYODZfVFJBUF9NQzogcmV0dXJu
IGZyZWRfZXhjX21hY2hpbmVfY2hlY2socmVncyk7ICNlbmRpZiAjaWZkZWYNCj4gPiArQ09ORklH
X0lOVEVMX1REWF9HVUVTVA0KPiA+ICsJY2FzZSBYODZfVFJBUF9WRTogcmV0dXJuIGV4Y192aXJ0
dWFsaXphdGlvbl9leGNlcHRpb24ocmVncyk7DQo+ID4gKyNlbmRpZg0KPiA+ICsjaWZkZWYgQ09O
RklHX1g4Nl9LRVJORUxfSUJUDQo+IA0KPiBDT05GSUdfWDg2X0NFVA0KPiANCj4gVXNlcnNwYWNl
IGNhbiB1c2UgQ0VUIGV2ZW4gaWYgdGhlIGtlcm5lbCBpc24ndCBjb21waWxlZCB3aXRoIElCVCwg
c28gdGhpcw0KPiBleGNlcHRpb24gbmVlZHMgaGFuZGxpbmcuDQoNCkFic29sdXRlbHkgY29ycmVj
dCENCg0KPiANCj4gPiArCWNhc2UgWDg2X1RSQVBfQ1A6IHJldHVybiBleGNfY29udHJvbF9wcm90
ZWN0aW9uKHJlZ3MsIGVycm9yX2NvZGUpOw0KPiA+ICsjZW5kaWYNCj4gPiArCWRlZmF1bHQ6IHJl
dHVybiBmcmVkX2JhZF90eXBlKHJlZ3MsIGVycm9yX2NvZGUpOw0KPiA+ICsJfQ0KPiA+ICt9DQo+
ID4gKw0KPiA+ICtfX3Zpc2libGUgbm9pbnN0ciB2b2lkIGZyZWRfZW50cnlfZnJvbV91c2VyKHN0
cnVjdCBwdF9yZWdzICpyZWdzKSB7DQo+ID4gKwl1bnNpZ25lZCBsb25nIGVycm9yX2NvZGUgPSBy
ZWdzLT5vcmlnX2F4Ow0KPiA+ICsNCj4gPiArCS8qIEludmFsaWRhdGUgb3JpZ19heCBzbyB0aGF0
IHN5c2NhbGxfZ2V0X25yKCkgd29ya3MgY29ycmVjdGx5ICovDQo+ID4gKwlyZWdzLT5vcmlnX2F4
ID0gLTE7DQo+ID4gKw0KPiA+ICsJc3dpdGNoIChyZWdzLT5mcmVkX3NzLnR5cGUpIHsNCj4gPiAr
CWNhc2UgRVZFTlRfVFlQRV9FWFRJTlQ6DQo+ID4gKwkJcmV0dXJuIGZyZWRfZXh0aW50KHJlZ3Mp
Ow0KPiA+ICsJY2FzZSBFVkVOVF9UWVBFX05NSToNCj4gPiArCQlyZXR1cm4gZnJlZF9leGNfbm1p
KHJlZ3MpOw0KPiA+ICsJY2FzZSBFVkVOVF9UWVBFX1NXSU5UOg0KPiA+ICsJCXJldHVybiBmcmVk
X2ludHgocmVncyk7DQo+ID4gKwljYXNlIEVWRU5UX1RZUEVfSFdFWEM6DQo+ID4gKwljYXNlIEVW
RU5UX1RZUEVfU1dFWEM6DQo+ID4gKwljYXNlIEVWRU5UX1RZUEVfUFJJVl9TV0VYQzoNCj4gPiAr
CQlyZXR1cm4gZnJlZF9leGNlcHRpb24ocmVncywgZXJyb3JfY29kZSk7DQo+IA0KPiBQUklWX1NX
RVhDIHNob3VsZCBoYXZlIGl0J3Mgb3duIGZ1bmN0aW9uIGFuZCBub3QgZmFsbCBpbnRvIGZyZWRf
ZXhjZXB0aW9uKCkuDQo+IA0KPiBJdCBpcyBzdHJpY3RseSBvbmx5IHRoZSBJQ0VCUCAoSU5UMSkg
aW5zdHJ1Y3Rpb24gYXQgdGhlIG1vbWVudCwgc28gc2hvdWxkIGZhbGwgaW50bw0KPiBiYWRfdHlw
ZSgpIGZvciBhbnkgdmVjdG9yIG90aGVyIHRoYW4gWDg2X1RSQVBfREIuDQoNCkdvb2QgcG9pbnQh
DQoNCkl0J3MgbGlrZSBOTUksIG9uZSBldmVudCB0eXBlIHdpdGggb25seSBvbmUgdmFsaWQgZXZl
bnQgdmVjdG9yIG5vdy4NCg0KPiANCj4gPiArCWNhc2UgRVZFTlRfVFlQRV9PVEhFUjoNCj4gPiAr
CQlyZXR1cm4gZnJlZF9vdGhlcihyZWdzKTsNCj4gPiArCWRlZmF1bHQ6DQo+ID4gKwkJcmV0dXJu
IGZyZWRfYmFkX3R5cGUocmVncywgZXJyb3JfY29kZSk7DQo+ID4gKwl9DQo+ID4gK30NCj4gDQo+
IH5BbmRyZXcNCg0KVGhhbmtzIQ0KICAgIFhpbg0KDQo=

