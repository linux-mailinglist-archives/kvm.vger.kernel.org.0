Return-Path: <kvm+bounces-5686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E265B824A06
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 22:10:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF0AF1C22A53
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 21:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F67D2C6A2;
	Thu,  4 Jan 2024 21:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qvg0EGJ2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FFE2C191;
	Thu,  4 Jan 2024 21:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704402629; x=1735938629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GpyI2D82/9F5jEUBq4O3R5yvEmXZx7A+72j9EcRYfE8=;
  b=Qvg0EGJ2vADk5TRqiOx36SY/gzguYNX8jA3JtUqw28TqNmDBPtB7sGi3
   P27Nk8sRHE0KZHt+cNPfP2nt/X/g42pzRWYU8CkIYfRllbUEA1bV9aOdK
   fo4YSOVqEWoWR4NT26b7YW2H3/y+LuXQTiTSryUlcoGsfY9p+PaHS63cL
   aF+O2I5bZI6VvAgr/A4JQT17vrNMaIgLqxyJ8vCY5S3TlPYpO/Ewf1xIl
   s7gYPLJ0cIZEm6HH4gsTY/4RBHBlEXuf+LECoJqUwHYlI3dEClLnh9Ph+
   0+CO3gR38/bQ4wuI/uuBIJgXJFSBx2zCmvxA/tBuQGhJnYd4OJ4cRt8yL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="376849474"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="376849474"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 13:10:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="1027568850"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="1027568850"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jan 2024 13:10:28 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Jan 2024 13:10:27 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Jan 2024 13:10:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Jan 2024 13:10:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5Z+8H5Zjd3CU+7No843vba0oILvA8wLVSPaBFXBN4jxxDWDVxU/YLpBVSZVZP0NV6NxTLeB81mmx76cIA8pkbBarDqRY0PRG5UO5+N/QxNcvW4e7lSMybtMThJUXS8S+EyDcWIuxjxtrlFYcxB/KsNoiuc+0tSGOBgXwOLxJEvvc136Vugquec+8bwYtC/OuY3TEVcdAh2HT0zzyke0a/bd9i7hjbRNVxe1bXjspeNAOgrwzFRhBvVuR+DeW/rrMWnyBH8rIdcDOSec9HAVEZhNPbnd58ZwODVoJ+LW9YAkSH/EtQZ9cZh2kbsvM1Cze1Wen0S0B3jQmOc4IUsDyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpyI2D82/9F5jEUBq4O3R5yvEmXZx7A+72j9EcRYfE8=;
 b=esYo98ZUNWPe3t1EISxu+y0iq/qiEiDqU6VHvz3yR2J17JQt1qDFqbHhTVvClkPf+oejkVSRPOOABR9Ov2RjAclmmA5Qt/ToOxCJNO7I670t5T6OPW3U00bMXdgslnJZcSXvD7/Hd8dsuEuobcZMlxo/vl5I1Tr+51nCXiElpPxu/l4WsesmnNScDPBrLbs8+/C/LFKsRzL++1qK4dyMhfLIBWa47NWCcc38+Cbu4lx+jCbIPWocY/vBjAa0+BPyk3653N1IUuv4crPi1Fr+QxZRnFnoNQLdOHVcD/q9OfdXJe4qG0D1p8gBBzO6uv1nLo1t0J9AaxKJuSSsX52Nmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6481.namprd11.prod.outlook.com (2603:10b6:208:3bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.27; Thu, 4 Jan
 2024 21:10:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.028; Thu, 4 Jan 2024
 21:10:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Thread-Topic: [PATCH v8 00/26] Enable CET Virtualization
Thread-Index: AQHaM+ybd3H3II6aZU6KWHt3rvxkNLDIg7MAgADO/oCAAOpTAA==
Date: Thu, 4 Jan 2024 21:10:24 +0000
Message-ID: <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
	 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
In-Reply-To: <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6481:EE_
x-ms-office365-filtering-correlation-id: c84c8076-c6ee-458c-e769-08dc0d6991e1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3kjzfxOEu7aNQXHWTnQTyWkrjsLSHSUpTJBFebmt4HDtn9QSQ9TqW4VhkTG5vdrfTSrNtJ/Q9dHsc4VCGdYA9Hiovcjtt8OB0q0z1NY6Sp4HAiK4QACo9C+RwsLb4h3tYQ79ZlrPnckj2NwLrlGuXJECO2JpV+LYa3gCQfXGLfmA9IzzWxQwfX0rVdAFSlvkCGlH5+JRoklvjeYtpgUKcSOVqtUX6BmzNtmZuIb8UrDucLVcsG5YFfmfc+hNyGZyF7NDsvQ4qvKtWiMqxCAWkPQpIhTjVppzpWd/rvZAmPAtE7c4Kj9pQgzOHWJ2TaZLok2xoA6flRRZK4XoTTRN8aMe/DuT3vPhHweqahk+sfCXxazfuhdkjL319I5QYSUbtWkVhRQX2BWPPLkTnBDLigE51lXU1rBSLTdt92Kfw8g7nYbBBKSuj8UTAjyAlEVRanj6w3jIkBByus0yoDcWF75tNxyv3emQUsAdbdcl1LJDXktw2Es+J471lR8bn75yTYVAu3g+btyST9yJ7TsoQpClhDJoU6pwSGG4utJ+0/O4EHEjgOeuX2ZHFpgFQCbfx1Fgtkpcq7lZHDRP8bb3mVShmw1iZt3CqbDzhLbTV5wrgtTRQpEwGYRscifMebOW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(2906002)(38100700002)(82960400001)(86362001)(38070700009)(36756003)(41300700001)(2616005)(54906003)(8676002)(8936002)(71200400001)(66556008)(6486002)(6636002)(66476007)(66446008)(64756008)(316002)(26005)(76116006)(37006003)(478600001)(91956017)(5660300002)(122000001)(66946007)(6862004)(4326008)(6506007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1hZbmVZMWJWU2hncmt1c0RFR200Z3U2WHgyV0hXUmlaVE90bEgzY2kreThy?=
 =?utf-8?B?aFJtSDBLVUMyZ1BjTGF0dlpDK0x1VXNCK0NSdWNLTlYzVUdtZlZ0SkZrQXpw?=
 =?utf-8?B?czJuMDBHTXVaK0ZaeCs3SWVON2YyelhKUnBMM1hmQldwdkF3NnVqQS9pODRk?=
 =?utf-8?B?cThsOG83bXRMSmdXRW1BNCtSTUZreGFDMS92bjA2aURyV1EwdUIvcUdFSk1l?=
 =?utf-8?B?cGhLaVFQSW5IT1ZQUVdoTkhqdWs2WUozSzRTN29UUk56Z3g0U0xNdTBpbExz?=
 =?utf-8?B?Z2t6VHdXdUV6MjFrelF3NHhsZXpBdnAyZUtTa1Q0RGVNcUg4TGhmaTBtZEhD?=
 =?utf-8?B?aEhob2M4dHQzdDVUaEtrMDNmTzRMN1EvSEhYdERHbDUyaGw3bG1SNG1oQktw?=
 =?utf-8?B?N3ZuaTVnQ2F5d1Q3UVlpOG9NVWNXNnluaU05dTN2T0puOHl0OFdtYlZmTXNa?=
 =?utf-8?B?R2UxdWlhdmc2YWVoVWIrZExLT25qYXhRTTFLUE9ZK2xpUVlyc3picXE4V3Ro?=
 =?utf-8?B?a1M3YUN0Y25JVkhCSS9YR0RET2tEWU1ITlI3SUo2U0E4bHdlbEhGZmVkNjhW?=
 =?utf-8?B?a2hPTEtIZFlyeWNiczJMVm9RWFZ1V3BRNi9QYmhwZDk0ME1mTnNGYVdaR3hp?=
 =?utf-8?B?d1gzbDQvT3FUTTFEcFZyU24vM2tXSWNlNTl6ZndGbTZQSmRDdCtDQVEzUHU1?=
 =?utf-8?B?bTN0bDNEK0tlY3pzMmF1Zi9URllqV2NPb3FBV1gwU1ZINGV5QXRvMnVuQ3Av?=
 =?utf-8?B?UVMxMnk2clgvMkI4QjVsSHZ4TFpkREVzY0VmV040dlRPRXBZTHk3L3lUcFZq?=
 =?utf-8?B?Uk5jb2dsQklFL0FvaW9FSGdEdTRxSGtYRWloRDgrdEZXQWJBWDRNYUNSUSts?=
 =?utf-8?B?SnJCcjU4WWx0VkhZM3YzQ1Y3bVFiUHhsVHpONHlrakxxTjFZOGdLbTBmbGpi?=
 =?utf-8?B?cktmT0R2aW5JVXhuUVlXUUVyS1lBNjhqaEhpY0tOc0orMGNKUzhZaHo1aTh0?=
 =?utf-8?B?d1pnTm9QUVRyR01sUE1qdEs0b3FtWlJBTjFrS2dibWFnVlE2TXZhYTkrZGZE?=
 =?utf-8?B?eE84UXZ3N3RSRXYrQXh5djlaYVVidE9nQzlvWi94Wi91NlFrd0JKWGZtekpE?=
 =?utf-8?B?Qm1KaUJhdnNhMVE2THpyaFJLV3BkSkQ2WXY4NWtUbko5V0tvVnhiTDl2YlJz?=
 =?utf-8?B?enFmeWVOSU1ya0RCOWIyUDY4ckxWb2dtNFh0eDVGc0gzbHgveFVJbnFibDNV?=
 =?utf-8?B?N3BwelRlTVFybWRYd0tKMERxWUJZZjNKNXNNUktmS1B6WjFSZEZFdWdlR2hl?=
 =?utf-8?B?bi9rWE9ENWMwSWwxbWNMQ1oxNER5TllTUEhRWUlaUlo5VllORmdhM1JXaGt4?=
 =?utf-8?B?ckoyT2t3aW4yQmhObWVkQjdMOGF6R3Z4NHJtMmxtaVBBNmlUVnpnay9MbWlz?=
 =?utf-8?B?VG13T0E4L2lsMnR4cVJVenpjdWliUVdud1Z3dzY0bC9McUJkcmcwcWJuNGtY?=
 =?utf-8?B?Wk9zTzNKQlFTN1FVU1lJNlhkQXlqRGoxOVRZWEV6WjBwa016cnZPenFZamdT?=
 =?utf-8?B?QUZDcWtReWdlRkRaQytIVFV6WDZUSVIzWnhyckQ0VDdwQnNzUW05eWpQeWlL?=
 =?utf-8?B?RWFEeVFQYXpXMjBMRjBZUnRrVUZNSDYvdElqenVheDVIWlBIYmJKcUtMbERj?=
 =?utf-8?B?aDI2TmtwVVBlV1d0TFVzWWlxZWRaa2hTR3U4U2huSXdtYTJWMmtIeWVtZHBi?=
 =?utf-8?B?UXhGUkg0WXl2dVIzOWx3bHBkV2QyRm9NdHBkcVFJRDN6eDcvNnJLUG9oOVJQ?=
 =?utf-8?B?bndzdklXOE93Qm0zbDVnR3plUnZNeDNiUXF1TGVRcUVtcDhEdVRuOTFrYmM3?=
 =?utf-8?B?YUtNRUJZMVdzN2JkQ0M3bW5SdjRBY1AwUzl1dTE0WXlrQm5XM3ZWRGRMNDQ1?=
 =?utf-8?B?R3FPTDZkTjZYaUdpRVphZlQzaU95RzdZWHpMRVYrVCsweHJGS1dXajF5VG1D?=
 =?utf-8?B?U0ZxcVJabnNNSG9wVHpua2p1ekFNRnRoOFB1V25kT243UkFKZHFpa2tpcnR0?=
 =?utf-8?B?dFYxbzk4cjVQK0JXV2tUTlI1UU9ZcXM5Ryt1elQ0clNwVHNPYjNrUG5KQlla?=
 =?utf-8?B?cnlTaE85aEhzdklWc29HRzJjbXpvdXlBbFMrU2trL3pmNUE1ODVCWVRwWXBs?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9C123792B26504FB611A6EC30FF92C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c84c8076-c6ee-458c-e769-08dc0d6991e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 21:10:24.9433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0pGxFGfB4AhZaVcqGECUkuiHid/xFgTC5U2gLbsGB9OPInRSRLu1BxREDVgws05Loxa2b2OnDbsj4NGq2AzbAmoQlJS7dLeNAD7BDDFPVl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6481
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAxLTA0IGF0IDE1OjExICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gPiBXaGF0IGlzIHRoZSBkZXNpZ24gYXJvdW5kIENFVCBhbmQgdGhlIEtWTSBlbXVsYXRvcj8N
Cj4gDQo+IEtWTSBkb2Vzbid0IGVtdWxhdGUgQ0VUIEhXIGJlaGF2aW9yIGZvciBndWVzdCBDRVQs
IGluc3RlYWQgaXQgbGVhdmVzDQo+IENFVCByZWxhdGVkDQo+IGNoZWNrcyBhbmQgaGFuZGxpbmcg
aW4gZ3Vlc3Qga2VybmVsLiBFLmcuLCBpZiBlbXVsYXRlZCBKTVAvQ0FMTCBpbg0KPiBlbXVsYXRv
ciB0cmlnZ2Vycw0KPiBtaXNtYXRjaCBvZiBkYXRhIHN0YWNrIGFuZCBzaGFkb3cgc3RhY2sgY29u
dGVudHMsICNDUCBpcyBnZW5lcmF0ZWQgaW4NCj4gbm9uLXJvb3QNCj4gbW9kZSBpbnN0ZWFkIG9m
IGJlaW5nIGluamVjdGVkIGJ5IEtWTS7CoCBLVk0gb25seSBlbXVsYXRlcyBiYXNpYyB4ODYNCj4g
SFcgYmVoYXZpb3JzLA0KPiBlLmcuLCBjYWxsL2ptcC9yZXQvaW4vb3V0IGV0Yy4NCg0KUmlnaHQu
IEluIHRoZSBjYXNlIG9mIENFVCB0aG9zZSBiYXNpYyBiZWhhdmlvcnMgKGNhbGwvam1wL3JldCkg
bm93IGhhdmUNCmhvc3QgZW11bGF0aW9uIGJlaGF2aW9yIHRoYXQgZG9lc24ndCBtYXRjaCB3aGF0
IGd1ZXN0IGV4ZWN1dGlvbiB3b3VsZA0KZG8uDQoNCj4gDQo+ID4gTXkgdW5kZXJzdGFuZGluZyBp
cyB0aGF0IHRoZSBLVk0gZW11bGF0b3Iga2luZCBvZiBkb2VzIHdoYXQgaXQgaGFzDQo+ID4gdG8N
Cj4gPiBrZWVwIHRoaW5ncyBydW5uaW5nLCBhbmQgaXNuJ3QgZXhwZWN0ZWQgdG8gZW11bGF0ZSBl
dmVyeSBwb3NzaWJsZQ0KPiA+IGluc3RydWN0aW9uLiBXaXRoIENFVCB0aG91Z2gsIGl0IGlzIGNo
YW5naW5nIHRoZSBiZWhhdmlvciBvZg0KPiA+IGV4aXN0aW5nDQo+ID4gc3VwcG9ydGVkIGluc3Ry
dWN0aW9ucy4gSSBjb3VsZCBpbWFnaW5lIGEgZ3Vlc3QgY291bGQgc2tpcCBvdmVyIENFVA0KPiA+
IGVuZm9yY2VtZW50IGJ5IGNhdXNpbmcgYW4gTU1JTyBleGl0IGFuZCByYWNpbmcgdG8gb3Zlcndy
aXRlIHRoZQ0KPiA+IGV4aXQtDQo+ID4gY2F1c2luZyBpbnN0cnVjdGlvbiBmcm9tIGEgZGlmZmVy
ZW50IHZjcHUgdG8gYmUgYW4gaW5kaXJlY3QNCj4gPiBDQUxML1JFVCwNCj4gPiBldGMuDQo+IA0K
PiBDYW4geW91IGVsYWJvcmF0ZSB0aGUgY2FzZT8gSSBjYW5ub3QgZmlndXJlIG91dCBob3cgaXQg
d29ya3MuDQoNClRoZSBwb2ludCB0aGF0IGl0IHNob3VsZCBiZSBwb3NzaWJsZSBmb3IgS1ZNIHRv
IGVtdWxhdGUgY2FsbC9yZXQgd2l0aA0KQ0VUIGVuYWJsZWQuIE5vdCBzYXlpbmcgdGhlIHNwZWNp
ZmljIGNhc2UgaXMgY3JpdGljYWwsIGJ1dCB0aGUgb25lIEkNCnVzZWQgYXMgYW4gZXhhbXBsZSB3
YXMgdGhhdCB0aGUgS1ZNIGVtdWxhdG9yIGNhbiAob3IgYXQgbGVhc3QgaW4gdGhlDQpub3QgdG9v
IGRpc3RhbnQgcGFzdCkgYmUgZm9yY2VkIHRvIGVtdWxhdGUgYXJiaXRyYXJ5IGluc3RydWN0aW9u
cyBpZg0KdGhlIGd1ZXN0IG92ZXJ3cml0ZXMgdGhlIGluc3RydWN0aW9uIGJldHdlZW4gdGhlIGV4
aXQgYW5kIHRoZSBTVyBmZXRjaA0KZnJvbSB0aGUgaG9zdC7CoA0KDQpUaGUgc3RlcHMgYXJlOg0K
dmNwdSAxICAgICAgICAgICAgICAgICAgICAgICAgIHZjcHUgMg0KLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KbW92IHRvIG1taW8gYWRkcg0Kdm0gZXhpdCBlcHRfbWlzY29u
ZmlnDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgb3ZlcndyaXRlIG1vdiBpbnN0cnVj
dGlvbiB0byBjYWxsICVyYXgNCmhvc3QgZW11bGF0b3IgZmV0Y2hlcw0KaG9zdCBlbXVsYXRlcyBj
YWxsIGluc3RydWN0aW9uDQoNClNvIHRoZW4gdGhlIGd1ZXN0IGNhbGwgb3BlcmF0aW9uIHdpbGwg
c2tpcCB0aGUgZW5kYnJhbmNoIGNoZWNrLiBCdXQgSSdtDQpub3Qgc3VyZSB0aGF0IHRoZXJlIGFy
ZSBub3QgbGVzcyBleG90aWMgY2FzZXMgdGhhdCB3b3VsZCBydW4gYWNyb3NzIGl0Lg0KSSBzZWUg
YSBidW5jaCBvZiBjYXNlcyB3aGVyZSB3cml0ZSBwcm90ZWN0ZWQgbWVtb3J5IGtpY2tzIHRvIHRo
ZQ0KZW11bGF0b3IgYXMgd2VsbC4gTm90IHN1cmUgdGhlIGV4YWN0IHNjZW5hcmlvcyBhbmQgd2hl
dGhlciB0aGlzIGNvdWxkDQpoYXBwZW4gbmF0dXJhbGx5IGluIHJhY2VzIGR1cmluZyBsaXZlIG1p
Z3JhdGlvbiwgZGlydHkgdHJhY2tpbmcsIGV0Yy4NCkFnYWluLCBJJ20gbW9yZSBqdXN0IGFza2lu
ZyB0aGUgZXhwb3N1cmUgYW5kIHRoaW5raW5nIG9uIGl0Lg0KDQo+IA0KPiA+IFdpdGggcmVhc29u
YWJsZSBhc3N1bXB0aW9ucyBhcm91bmQgdGhlIHRocmVhdCBtb2RlbCBpbiB1c2UgYnkgdGhlDQo+
ID4gZ3Vlc3QgdGhpcyBpcyBwcm9iYWJseSBub3QgYSBodWdlIHByb2JsZW0uIEFuZCBJIGd1ZXNz
IGFsc28NCj4gPiByZWFzb25hYmxlDQo+ID4gYXNzdW1wdGlvbnMgYWJvdXQgZnVuY3Rpb25hbCBl
eHBlY3RhdGlvbnMsIGFzIGEgbWlzc2hhbmRsZWQgQ0FMTCBvcg0KPiA+IFJFVA0KPiA+IGJ5IHRo
ZSBlbXVsYXRvciB3b3VsZCBjb3JydXB0IHRoZSBzaGFkb3cgc3RhY2suDQo+IA0KPiBLVk0gZW11
bGF0ZXMgZ2VuZXJhbCB4ODYgSFcgYmVoYXZpb3JzLCBpZiBzb21ldGhpbmcgd3JvbmcgaGFwcGVu
cw0KPiBhZnRlciBlbXVsYXRpb24NCj4gdGhlbiBpdCBjYW4gaGFwcGVuIGV2ZW4gb24gYmFyZSBt
ZXRhbCwgaS5lLiwgZ3Vlc3QgU1cgbW9zdCBsaWtlbHkNCj4gZ2V0cyB3cm9uZyBzb21ld2hlcmUN
Cj4gYW5kIGl0J3MgZXhwZWN0ZWQgdG8gdHJpZ2dlciBDRVQgZXhjZXB0aW9ucyBpbiBndWVzdCBr
ZXJuZWwuDQo+IA0KPiA+IEJ1dCwgYW5vdGhlciB0aGluZyB0byBkbyBjb3VsZCBiZSB0byBqdXN0
IHJldHVybg0KPiA+IFg4NkVNVUxfVU5IQU5ETEVBQkxFDQo+ID4gb3IgWDg2RU1VTF9SRVRSWV9J
TlNUUiB3aGVuIENFVCBpcyBhY3RpdmUgYW5kIFJFVCBvciBDQUxMIGFyZQ0KPiA+IGVtdWxhdGVk
Lg0KPiANCj4gSU1ITywgdHJhbnNsYXRpbmcgdGhlIENFVCBpbmR1Y2VkIGV4Y2VwdGlvbnMgaW50
bw0KPiBYODZFTVVMX1VOSEFORExFQUJMRSBvciBYODZFTVVMX1JFVFJZX0lOU1RSIHdvdWxkIGNv
bmZ1c2UgZ3Vlc3QNCj4ga2VybmVsIG9yIGV2ZW4gVk1NLCBJIHByZWZlciBsZXR0aW5nIGd1ZXN0
IGtlcm5lbCBoYW5kbGUgI0NQDQo+IGRpcmVjdGx5Lg0KDQpEb2Vzbid0IFg4NkVNVUxfUkVUUllf
SU5TVFIga2ljayBpdCBiYWNrIHRvIHRoZSBndWVzdCB3aGljaCBpcyB3aGF0IHlvdQ0Kd2FudD8g
VG9kYXkgaXQgd2lsbCBkbyB0aGUgb3BlcmF0aW9ucyB3aXRob3V0IHRoZSBzcGVjaWFsIENFVCBi
ZWhhdmlvci4NCg0KQnV0IEkgZG8gc2VlIGhvdyB0aGlzIGNvdWxkIGJlIHRyaWNreSB0byBhdm9p
ZCB0aGUgZ3Vlc3QgZ2V0dGluZyBzdHVjaw0KaW4gYSBsb29wIHdpdGggWDg2RU1VTF9SRVRSWV9J
TlNUUi4gSSBndWVzcyB0aGUgcXVlc3Rpb24gaXMgaWYgdGhpcw0Kc2l0dWF0aW9uIGlzIGVuY291
bnRlcmVkLCB3aGVuIEtWTSBjYW4ndCBoYW5kbGUgdGhlIGVtdWxhdGlvbg0KY29ycmVjdGx5LCB3
aGF0IHNob3VsZCBoYXBwZW4/IEkgdGhpbmsgdXN1YWxseSBpdCByZXR1cm5zDQpLVk1fSU5URVJO
QUxfRVJST1JfRU1VTEFUSU9OIHRvIHVzZXJzcGFjZT8gU28gSSBkb24ndCBzZWUgd2h5IHRoZSBD
RVQNCmNhc2UgaXMgZGlmZmVyZW50Lg0KDQpJZiB0aGUgc2NlbmFyaW8gKGNhbGwvcmV0IGVtdWxh
dGlvbiB3aXRoIENFVCBlbmFibGVkKSBkb2Vzbid0IGhhcHBlbiwNCmhvdyBjYW4gdGhlIGd1ZXN0
IGJlIGNvbmZ1c2VkPyBJZiBpdCBkb2VzIGhhcHBlbiwgd29uJ3QgaXQgYmUgYW4gaXNzdWU/DQoN
Cj4gPiBBbmQgSSBndWVzcyBhbHNvIGZvciBhbGwgaW5zdHJ1Y3Rpb25zIGlmIHRoZSBUUkFDS0VS
IGJpdCBpcyBzZXQuIEl0DQo+ID4gbWlnaHQgdGllIHVwIHRoYXQgbG9vc2UgZW5kIHdpdGhvdXQg
dG9vIG11Y2ggdHJvdWJsZS4NCj4gPiANCj4gPiBBbnl3YXksIHdhcyB0aGVyZSBhIGNvbnNjaW91
cyBkZWNpc2lvbiB0byBqdXN0IHB1bnQgb24gQ0VUDQo+ID4gZW5mb3JjZW1lbnQNCj4gPiBpbiB0
aGUgZW11bGF0b3I/DQo+IA0KPiBJIGRvbid0IHJlbWVtYmVyIHdlIGV2ZXIgZGlzY3Vzc2VkIGl0
IGluIGNvbW11bml0eSwgYnV0IHNpbmNlIEtWTQ0KPiBtYWludGFpbmVycyByZXZpZXdlZA0KPiB0
aGUgQ0VUIHZpcnR1YWxpemF0aW9uIHNlcmllcyBmb3IgYSBsb25nIHRpbWUsIEkgYXNzdW1lIHdl
J3JlIG1vdmluZw0KPiBvbiB0aGUgcmlnaHQgd2F5IDotKQ0KDQpJdCBzZWVtcyBsaWtlIGtpbmQg
b2YgbGVhcCB0aGF0IGlmIGl0IG5ldmVyIGNhbWUgdXAgdGhhdCB0aGV5IG11c3QgYmUNCmFwcHJv
dmluZyBvZiB0aGUgc3BlY2lmaWMgZGV0YWlsLiBEb24ndCBrbm93LiBNYXliZSB0aGV5IHdpbGwg
Y2hpbWUgaW4uDQo=

