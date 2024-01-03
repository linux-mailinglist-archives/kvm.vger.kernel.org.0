Return-Path: <kvm+bounces-5590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE70182342E
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 19:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7F5F1C23D4F
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550911C6A5;
	Wed,  3 Jan 2024 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4pi0Ki0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D65B1C68D;
	Wed,  3 Jan 2024 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704305815; x=1735841815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SSFFTFPl1+hzZQJ7pR1uIPWgGY+ULkb+B3dOluNXkoU=;
  b=E4pi0Ki0AZZynY+LJlpx6QdhRP0d4NokG3yvCCKzId8Rq+t7J2omRwvN
   FF/u9YFNv7Qd+56IZGGyrUQM1I6ZZ07ViY5FxvnecXIFws6XwM8glb6nZ
   0+Rw+NxC4vRdTQ03w1RCVUXugzebJXxTyzkOeKTqg109sjr/vMScD0EPz
   7YFW0CFEc8hnuHyaEkdKQhch4siwArlLGybfq7jdKIB/oH1txQxilOBTd
   RC3+urBA0in9n4RhJqaZYouO70wFRtUxkluDnqSs7logyPAQalyQ3qAUT
   jE0hxEVwErQFVEh4brFjh2CRmz4G0+uSNhknHurcNJSFoNdOw72AlB6Tu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="463446990"
X-IronPort-AV: E=Sophos;i="6.04,328,1695711600"; 
   d="scan'208";a="463446990"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 10:16:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="1027143826"
X-IronPort-AV: E=Sophos;i="6.04,328,1695711600"; 
   d="scan'208";a="1027143826"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2024 10:16:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 10:16:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Jan 2024 10:16:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Jan 2024 10:16:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUqCQfj8bAr2VUjSlh84ntEUYMr2XBp0uzWopkfNq1ywTCKBZz4Yivtjt847ZtSSKRV76rkt0KPElW68y8CaQ4N9YPuuOeO2tYKdMNw+7boQhZCfIW9AfvnzIHxRAqdMzBCgKKMG1rilqsSo1lvfAxYifv+riq11NEQHbKhZhtR9EesM3/tIkddmtey5CRFZZMx/KwCS1xDu8H0t2d/vThIDiNzoSJFbNGhzJDnp/l9rN/w8yuOrRBJtZP5f+ACEZEYMg588D2m9eiqLlHPc+cx9dts84HOoii0VLdvuOsyc0PZM2DrBfh3EnnJrgInlWlxa/V4fUhb6hDt9rVr4iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSFFTFPl1+hzZQJ7pR1uIPWgGY+ULkb+B3dOluNXkoU=;
 b=Mp2A19oK2LqH9sJ8LhgayXSEouht9pYUGH2S+U3Y3gYF0UmrTqZL4tEK8iJBCmqVLQmtZ8xK8ikWTLBawiKyypBGBFqfy9264TIHcNWjXICyMkmLqz7SdU5mbDkDyL8dh7bX+KaqEQ45TNMnzCUKjAMEqyKn4spf6Go/aYd1ArgRrfy3vITHmQCpyR7NnOqgFot8ntDyyLz2SCWsxrxoCJJa1x8Ope62HuMhZ1XEpgT23PtCnjR+JzX8+QhE05o069+tgpOkqxNhE/FFzERzHdobPGcwIVVTZzHUfdn34U/8swnCo90Kl99kUQzLHyJYY/Ipgx35zQK6SsQNhKWnHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB7495.namprd11.prod.outlook.com (2603:10b6:510:289::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Wed, 3 Jan
 2024 18:16:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7135.023; Wed, 3 Jan 2024
 18:16:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v8 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Thread-Topic: [PATCH v8 06/26] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Thread-Index: AQHaM+ylBC/+E0ccDEaCk+hVFG6RhLDIei2A
Date: Wed, 3 Jan 2024 18:16:48 +0000
Message-ID: <bc19422761014edceffac971ec66d7a9a77f5ad1.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-7-weijiang.yang@intel.com>
In-Reply-To: <20231221140239.4349-7-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB7495:EE_
x-ms-office365-filtering-correlation-id: 3826be90-6e4b-4841-abe7-08dc0c8826d0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BoOI3ON7N32nUPLRWKby2QQBBxlwf2SfB+V07mz8zSM0CjlQqJePiCjXRUpZp+5Y4fFEmRamcDB+Azjc3cw7rU4VDohAAJmzLpN2G8c78yBivmjSFxKX2tE2H7SKdZ5XV2Zb84GcGTFrKbcmvlFZ5RXB8AmePt2tQ+QO/C4sUvjVPc/EeQp8d/N9z6rZ2Rxx32yfMqN6YHk9rxI0VprsVQUh9MbaGDeTbRr73rVAeW9ynGln2LJEYovePLmobCajhT9MWMNv5KyH2ctnKuitu5pV60CGYOEWjQu4sgPtKHAEe3SmYSuZHO/13VWy3BiKiOMBZ6LXFzM6S8KqC/EW54RoaWGDatirLqnJ1c6v5TXhgMOmEpu8A0XFxRWlr/xqbS7Nzg9cTLJfS7/Oo7hoI89OxUnquanRR8EF/d+ea5NQpD8H1NQB4bjAw/GiKmvI1TX7A2VETdZRduNWxfAlcbewYI5qfR4FQMlQh85mcggOleUGEvyFLZ58d5HO1+SKKqzFg9BBIbNvuDEV41bKMZ0boncZ6lyTrRqZISaBP6uCjeC+w2x1XyfMwbTGXOJuiQhZ4ox5c85VGCFG88XXbNH2NiNxGfNtFppboRxhxvkrZTKxuKIu1qnGa+7Xj8rk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(366004)(346002)(376002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(2616005)(41300700001)(26005)(6636002)(122000001)(5660300002)(82960400001)(4744005)(6486002)(2906002)(316002)(54906003)(83380400001)(4326008)(8676002)(110136005)(478600001)(8936002)(4001150100001)(71200400001)(66446008)(6506007)(64756008)(91956017)(38100700002)(6512007)(76116006)(66476007)(66556008)(66946007)(86362001)(38070700009)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmZPUEVIY0crcGdVei85ckJaTEJmTEZGbjZKZVdmaEVjUGNHUWRkS3ZYekQz?=
 =?utf-8?B?Ly9MMGFOdXVGdGZQZ3JMb2ZtdVdJTUU3cjc0TzlrY1loNWhrb1NsemxlWHhz?=
 =?utf-8?B?aDRWY2I4VDN2bjVNaTdHNjEzd1lIRkFXR00zSUZYeGY3UkRIeWdNcjRvenI2?=
 =?utf-8?B?Z0tQT0NFUzU4NXRCZU56cmlrazVydXQvc1hycXRhVjVoZHEwd2ZKQzVDTWc5?=
 =?utf-8?B?d3luR1loMFBGY2taak9qWFhnNFduMWtKZzJDOGJpWnQ4R1BsL1g4dHRDaWht?=
 =?utf-8?B?M0lnNGx6U0NQZ1JjalRiWUFZeTVKbE51Q1JoL0tIV1hEUkJWMG8ydkNWSXFs?=
 =?utf-8?B?KzdCN1F2REszb21PeU0rYmd2MnBLN2pURnlEelJ3UG9nbnd1SjYxKzBtcEpU?=
 =?utf-8?B?NmNicWRNaEU1cHQ4VGY3R29DNU5GQ21ZcG5GN0VZNFJoeDlmVFRjbU50Q1ZM?=
 =?utf-8?B?Q3NpOGxURHQzRmlUQldXclYrczZNL0ZKUk1abTlId2lVZzN2R0ZzbWxjcHk5?=
 =?utf-8?B?WHhiVGRhOXoxdENIRmZjMlhTZzlvbDArdjhMV2RSeXU5YU5yWHdIaE5TMzl0?=
 =?utf-8?B?cmcrSkJoTUh2VzBEQkVkQThJditxRzRaSG0vNXZWVHdDWEVxYVo5b0VSYkNm?=
 =?utf-8?B?ai91c2dvL2NFdStVODJQWE9kdEQwZ3I2VlJramN0RmNQUXZDVnBCWWpQL1BO?=
 =?utf-8?B?VWxoRGlWOUo5Z0lFSGl6V0t3NDZnZHMzTWM1QnJ1cXV6d254aFJRdmROeWZM?=
 =?utf-8?B?Szh4UXE2Z3gxck1CWk45N2ZnODdpb1JHUjhCSFIwaGM4SGsxSTBobzNWWUxP?=
 =?utf-8?B?c1piTHJMRnI0VWVjQWVUWVJzbGRVR0FRMkR3K0dPNzA3U0psRVpvOVdodU1V?=
 =?utf-8?B?bVdtblYzZUdnSUZYbmlnM0pnVWZ4d3ZoeFhtYWFmRWxWU1FsQ21SMTBocjdz?=
 =?utf-8?B?QXJMWFkrN0N5MDE4RWUwUVNHclJGa2NsWi9RUG1URlp0TFNqNGhubXhqcEpI?=
 =?utf-8?B?WGozWCs3MnQvMHdHWTNTU2hWVWNIWDFUTTRITklZOHJpK1p0a2RmRFZyMkg3?=
 =?utf-8?B?NHA5UGhvRHFqdmxoWmkvanR6MzQvTkJNK1BsRUZZRU9EZWc3eHlaVGRMQllF?=
 =?utf-8?B?aVFFekJJK0hrSWhyUU5WNFBRQzhhQ0owWjdYTzdCamx6NmNZT1dkNzlHeG1I?=
 =?utf-8?B?WVB0Ymt2SXFhWXJXaXpKdmFNdFFZMHNqTGZlSHozekNOQ21zRVhpYkk5UHQr?=
 =?utf-8?B?WFNHTjJrVTJrekp6VUE4UjRRcXUvRE1HSS9sSEVRY2pseWRQMXRhelVYczU0?=
 =?utf-8?B?T2ZKS3ZHdXVmRW10bVdEelhIRFd0K2RZV2puL3ZIbkVzTUJnbDdWaTBId2tU?=
 =?utf-8?B?aXJ4Qy9HRGxuYkFlUU9BcDJaMkl6VzJTTDVaVm1ORUM3RlRJVjBJNXUyNDZC?=
 =?utf-8?B?SFNPWXcxaEdGOVdOWUNBWUFBTVBWRDcrWlZUSHVWays0NERtbElSNWJyMTlp?=
 =?utf-8?B?N1JnYllnWStGRWVVcEhSUnZzenBua1VQOGJ3bVZna01SNFIrTnFmeHZJZmNP?=
 =?utf-8?B?WXQzRG9SU3dtQ3lrc1VNSm5JbmhKY0F3QzVlRXRmQUlSWjNMNGtYUTNUME55?=
 =?utf-8?B?UC9pN2tKUHdDaVJOZUxFR3J4NXVnNnUzcXZsY1lJRjh3U2tBMUxqYjh1UzY5?=
 =?utf-8?B?amZFRXFwTDh0dElJb1hLNHdEYWhHV3lTblVUbjFqYWFIcVdmdzlyVkM3Mk1a?=
 =?utf-8?B?bjFjY0pPV1dOeTNJSk1pVXJISWpuK01MUGVPYld6WERnenMrb1VwMklpN29V?=
 =?utf-8?B?VEdGb1ViTVBwb2M2elhLdHprUkN6WmRjMUlrT0dtQnJobzFheEVqbGhBWkNC?=
 =?utf-8?B?cjRQc3Z0ejZNcFpjTVMwSDUxRW5VdUdCb2N1WlRmOU1RYU52YTVHNW51YVdm?=
 =?utf-8?B?aWx5KzNqeUlXSzJZY1B5cEE5Z2p4MU9SdGc3STRObnRYOVo1NkVUdktsU1Mr?=
 =?utf-8?B?R1g1UDBxeHprVGRHdVlTaTZXV1BMSlA2WEx5cDhuU0hscVlJQWQ0UmlHZERH?=
 =?utf-8?B?VzFPZU5aYlZKV2NmSGJOaGx4dytEMFRidHU0MW9SdkR2TlJoNFpRazNtVXcr?=
 =?utf-8?B?Q09rQkozRVpxai9XNWNqRzE1WnBNQ2dyQUJQNUpyNm1EeDNabU0xTm1FOFpU?=
 =?utf-8?B?Rnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BD48B8A7F788E4D900351DBA2C4A2F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3826be90-6e4b-4841-abe7-08dc0c8826d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2024 18:16:48.5785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5knegGRD/QBDUotrqS8ywXd4y7xHlMifrItie7oi6TNiIcYFY0BuREC9jIOPbpDThqs6ckuWiDr+ZorAE6smRWgcpbvKxU7iTDhibL7f3uM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7495
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDA5OjAyIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiDCoCNpZiBJU19FTkFCTEVEKENPTkZJR19LVk0pDQo+IC1zdGF0aWMgdm9pZCBfX2Zwc3RhdGVf
cmVzZXQoc3RydWN0IGZwc3RhdGUgKmZwc3RhdGUsIHU2NCB4ZmQpOw0KPiAtDQo+IMKgc3RhdGlj
IHZvaWQgZnB1X2luaXRfZ3Vlc3RfcGVybWlzc2lvbnMoc3RydWN0IGZwdV9ndWVzdCAqZ2ZwdSkN
Cj4gwqB7DQo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZnB1X3N0YXRlX3Blcm0gKmZwdXBlcm07
DQo+IEBAIC0yNzIsMjUgKzI3MCw1NCBAQCBzdGF0aWMgdm9pZCBmcHVfaW5pdF9ndWVzdF9wZXJt
aXNzaW9ucyhzdHJ1Y3QNCj4gZnB1X2d1ZXN0ICpnZnB1KQ0KPiDCoMKgwqDCoMKgwqDCoMKgZ2Zw
dS0+cGVybSA9IHBlcm0gJiB+RlBVX0dVRVNUX1BFUk1fTE9DS0VEOw0KPiDCoH0NCj4gwqANCj4g
LWJvb2wgZnB1X2FsbG9jX2d1ZXN0X2Zwc3RhdGUoc3RydWN0IGZwdV9ndWVzdCAqZ2ZwdSkNCj4g
K3N0YXRpYyBzdHJ1Y3QgZnBzdGF0ZSAqX19mcHVfYWxsb2NfaW5pdF9ndWVzdF9mcHN0YXRlKHN0
cnVjdA0KPiBmcHVfZ3Vlc3QgKmdmcHUpDQo+IMKgew0KPiArwqDCoMKgwqDCoMKgwqBib29sIGNv
bXBhY3RlZCA9IGNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfWENPTVBBQ1RFRCk7DQoN
CldpdGggQ09ORklHX1dFUlJPUiBJIGdldDoNCmFyY2gveDg2L2tlcm5lbC9mcHUvY29yZS5jOiBJ
biBmdW5jdGlvbg0K4oCYX19mcHVfYWxsb2NfaW5pdF9ndWVzdF9mcHN0YXRl4oCZOg0KYXJjaC94
ODYva2VybmVsL2ZwdS9jb3JlLmM6Mjc1OjE0OiBlcnJvcjogdW51c2VkIHZhcmlhYmxlIOKAmGNv
bXBhY3RlZOKAmQ0KWy1XZXJyb3I9dW51c2VkLXZhcmlhYmxlXQ0KMjc1IHwgICAgICAgICBib29s
IGNvbXBhY3RlZCA9DQpjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1hDT01QQUNURUQp
Ow0KDQo=

