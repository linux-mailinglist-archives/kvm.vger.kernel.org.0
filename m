Return-Path: <kvm+bounces-6220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9FA282D889
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 12:46:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA5CD1C21A60
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 11:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3A82C697;
	Mon, 15 Jan 2024 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M9wV8+3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A162555F;
	Mon, 15 Jan 2024 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705319188; x=1736855188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MwPdDtywtuYQEcG8AWhio5PU2WjE8wmL9uUSe9TVvRY=;
  b=M9wV8+3YEez1OfcaqmVN7R5S2CCRbbvjBMyAevGYDjXU0TH6oMoupaQR
   ywiJrbux0aqG3l6/2StyJtV70cnJEkqeCNziAs4NN+gTjRm8kNCA5OCZ/
   8F7ZtFsyiBzCZX5lHiH+uLAnqwMh4RzPnExIrdamST2EC4F7yJmuoWH+C
   PdTQq5lGn4awR+3ZNa8eEmAeA7PsXv4bivlAnWVBmMyQ9Lxoxm8jCIccL
   Az8gr0fT1POoIl4BkRxkk94C6rMYyNeujdZ1PVi4UKBlrYfHSfLDev7+R
   D8IkiUHmCfp5TEBTHryAfVQpxmkvmtQ4nxy4nCPz3mitMZeSbo1z1GFI0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="6689834"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="6689834"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 03:46:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="902754541"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="902754541"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2024 03:46:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 03:46:26 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Jan 2024 03:46:26 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Jan 2024 03:46:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pobn0VtsvqLDDECCXRbnZmrnbHiTQuzNSk+bxljkxdpu+0EkJknz54/NM2BTKq6UW5RNbv8o5x+Bzeve+NHf1T7PCXUbtiIN6g/RJQbYpkF00xSWUn5OzyAwZYWDnn1xhDl4m9aIKmjPyQ3twh/Wy1vdRecMB6d+VfRDsJydPzylJKlSYr/VtSvO0DTCCy0O+ooWKqE3wkQBdRVWAlrs8zkxmuIJ3YFU4ibEqipNL/gqU0N73JBPSHfJEBu2j4NH8PmA2/RGY4p1j9ua/iJgqyiIXhLWaSguduUqyeI//eGWpmotgYA77XMCvFmoYA2XUs5bxjyp+pX1MpA5J+qGZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwPdDtywtuYQEcG8AWhio5PU2WjE8wmL9uUSe9TVvRY=;
 b=Sj0mEhSVpbzbZxW7gQSFtmJoUPXvzMTqTjlDZvVi4rKojjG9fxX7QKB1Jj1EgnB7cceBo5MgA/pCRnfJd3vrJ0EMacpWQC0A49EsseoFNWIXggZGX7wlx0ophynqxgFcn6kmW2KM69PQQt/JQxG+BLTSiWixktcxNoJNcEW8LhE4Srm59ZKL6caeAQvN1Eq8BLWeQRyFcg+NIQsy7O/eYcb6DdYeiK7Kkc1F2Wf6EOlM/uXBLSwsFqeYm3NGhaTHYirA1kuBRyWuZev+DmCmlEAGbIwKUXeOLnmfy/9QIYzQGXY/TLVK9xim/dqpg6jFUu7WFWd9JX3A2kxr268xlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Mon, 15 Jan
 2024 11:46:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ca1e:db:ee01:887]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ca1e:db:ee01:887%5]) with mapi id 15.20.7181.019; Mon, 15 Jan 2024
 11:46:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaRT8Fg8dZJ6KNyk+kWUJ6VvYyeLDaxlgA
Date: Mon, 15 Jan 2024 11:46:08 +0000
Message-ID: <4374f38331e2c7261618f0bda5b50edc83077b8a.camel@intel.com>
References: <20240112093449.88583-1-xin3.li@intel.com>
In-Reply-To: <20240112093449.88583-1-xin3.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5933:EE_
x-ms-office365-filtering-correlation-id: 23813102-30da-4ab5-2235-08dc15bf9047
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: osemTpXlCtKzSk+r1bHxS5R3VnZTNnLY/RiQTDly7sEonPrP4Yip0OYZWxYy5+lOQCCa00k+NGdRK/0kbe9AVRHAaV9KpU6BjRyjjjML62BwL+yG/xJgQfP6VQS7N1UklIfTFoY1Z48hXn9oLhC6NhprRF2zKi4CkAjLDto7XDsfnMW0HTPgdve818053ipqRU4i7SeJCWb3hZSgVy/Xl+TLWdBTBrz1jGGVUZlhzAGBnlM1CMJdrjahTDeEBJXXqBEptCrtEQoXglnAPAsbYp6LWdJ5L/oKFAFYkycLPvcjon7w/BBxrBE153444FELSDx6AblgTKdWc+cczs/nby72NSJvEwg/UgVekTj4N6Qisc484all7c3lk2xk8/UOAX1kKJUbJhU0QI6ufImUIq5ygJRRSOvJ+lJ6sNgVDTv08nCMTIlGvfU5f8dSxza3EhjA8PPl4awbq5M0eXEH82z8MwVNK0oE1IRHDH/yPG4W3c4WM5G+UY2tGha/OY496uoYcarjAGjfxOJjh8ntErQais1g8N1yapc8jcIjNisgFMp/Y2rYLCOGGXWVuHMTEsjx0mmOqsSQD67yPgL8IjtXHZKYs1we5Rm9Dyek8U8OFNGWuTy/arjqD8ITlQ1j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(346002)(39860400002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(71200400001)(2616005)(26005)(478600001)(6506007)(6512007)(91956017)(5660300002)(76116006)(41300700001)(2906002)(4326008)(7416002)(6486002)(8676002)(64756008)(54906003)(316002)(8936002)(110136005)(66476007)(66446008)(66556008)(66946007)(82960400001)(86362001)(38070700009)(122000001)(38100700002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUhDNjNyeGVqQ3RHVFo0Sno0MGo2S2NYTmFVYjczMW5SYUx6VkM1ZWtoSUU5?=
 =?utf-8?B?STQ4S2ZmeThsVEVUbXhNWkF6cWp3RVRZMC9UYWtuVmxlRFI0cHJlOUVOb2dh?=
 =?utf-8?B?ZVREV2FlTWdNd01ncFI4MDJVME5kekp2WUhDVGJkRXRlUUFjd0RxQmlaWVZE?=
 =?utf-8?B?V2RqeWZXdHNsbjI1Q1lnMisxRzNOSE1rVDdYUlJkZkdQaXFUN3RETmNiV043?=
 =?utf-8?B?NmlSRGltemMzYkFuTjZkWXB5WVVlS3lzTnM4cHUvaVpyQnBIL0xsZ0xTVUZ3?=
 =?utf-8?B?T3pzcFd3TVBTMUh3ejdhdlN3elYwcGQyYm1iaEhHUTB1aHlRdmpXbXhVTjRC?=
 =?utf-8?B?Z0UyY3FxdGNXNTdOMTl6V2gzbVRuckpZcHp0NFRacVA2MXFNQStmVm83QkpT?=
 =?utf-8?B?dCtPaFp6VklKdlFHamd3OGVsMmRsREZ0WjROV2pyRitLdjVETVBBdFlQRGpG?=
 =?utf-8?B?L3RaL1czZVVORlh6eUd6OXEySEhORSszaTRwWC9mRXcvYytOSW56aVNxeG9M?=
 =?utf-8?B?UkJPU2RHMDJxZGllVFhSVi9CRTZ1QUV5eHdick5DYUpQUmIxMHNKSVhqSWYv?=
 =?utf-8?B?V2NCRlhIZGpkam8zTkNpMll0SThTLzBqQ0hxOVBEcFpReGc0RU00L25RbVJS?=
 =?utf-8?B?UGdhVlBCME05cnVEa3J6NW5hV1YwZ2RicElmcHZzMFdJaU1wOFVXc3VTVGxW?=
 =?utf-8?B?bW9GT1RlOWV3SU9vMnBiSnVweWg0U0NSSC84aWxPTVhqeURpd0YxUm1jb2Ft?=
 =?utf-8?B?S3ZYSzlkTGxQbmRaMlJqemlsb3dCN3VpRWJLOUJDdE5kT2dMWVEvWFJHV2pZ?=
 =?utf-8?B?cUYybW9SL1krdS9zUFpvUlRlTHdJaVBSQ2s5SEV6dDdsS2h3WnJpb0M1cHNG?=
 =?utf-8?B?SzNlMWN1S2dTd09Pejg2Smd3OG9NY2NBWjRaaERGNkJBeWkybHBJM3pLcjZR?=
 =?utf-8?B?dTM1RktHSEx1RXJ2Sk5FeTN4amltTExGTnY4TnBaSUw3bWYxSzRxUUdGSVFt?=
 =?utf-8?B?VnpJVjZDSjlobWVwdmY1T0JZdmRQdjFxQkt6aGZQQmZoSWdrZlBUS2RuTTg4?=
 =?utf-8?B?RWk0UWdoaWZ6dndURG9kNFJORytaenYwVW1xTGZOYS9INkZWZUM5SHJSanh6?=
 =?utf-8?B?QlNCT21SdzZFcUZQdUtDcHh3WCt4NXphU0tVaEp1dXRVaDFnR20xbFQyVWdj?=
 =?utf-8?B?b3Nhc1JpeWd3WFRQdjk4dUlFaW1XbkVvSjdIb29SUzNrSStibnNhUXd4OG5i?=
 =?utf-8?B?ZEpHanprc1FHYUFkbUFjM3c4Q1UxbHB0ZytFbWdFNkRocTZlV0pROE1XRGh6?=
 =?utf-8?B?eHZUY3NjVy9HK1RQS0VKQk5KeWdSc3loMk05SWo4bGlsQlcwZG9QUURZeFk5?=
 =?utf-8?B?VGd6SHBpSktTYnpQdFduWDlnM1dyWXdET1hmZlg4RHk5S2R3ZDdpQ1V0K04z?=
 =?utf-8?B?eC8vY21odGVSeDNMQmdNR3g5VWl4TzQ4cS9vT3FIU0pmSXZTTDFSYjlDSXdK?=
 =?utf-8?B?TXBLVEVXSFc4UEVxekRxRVFEQ01jakRyU1VjTzEzOE1ZMWNTSGdpd3NCUXVP?=
 =?utf-8?B?RlBYVnlEY092ZUh5aVBQSFVySVRib3RVNk02KzRMMGpqaGl6QVRselJQT3Qx?=
 =?utf-8?B?Q2pCYjZuRjRrQ285bVJrdk4rK3Jpd2s2bzhvMjV5bk1iY1dmVXJTTW1lYW5h?=
 =?utf-8?B?UWNrZVdsaFMxTmdEenRzVTZkZFcycnV2aG9BQ3ZDZE92MGtER3dHNnZVdk5o?=
 =?utf-8?B?SGRKemRwTDJMa2o4UEovSk82VWxyd3BqZHpub09ZcEp3eWNWUnlzZnZRemRt?=
 =?utf-8?B?SmJIQmR2QkE2RVJlK3FoSlZnVHZEelN5akRPVWczbFZ5SnNOdUQzblVnRE9J?=
 =?utf-8?B?YW9SVnhSQWRZZU0zYUFISEF2YWdZY3QzbzRQZDcrRWhQbUxxMnBpdk5BQWJs?=
 =?utf-8?B?a0MzenMxblc3Q3VqSmdQeTdpa2UwYVk4R2oxY1dvU2ZCcEt6cmlLVE9NS1dH?=
 =?utf-8?B?d0NHUWdEcUtsdFlubUdaejk1UkpRR0FRNXdUdnhvRHhLOFU4b2dBQUtLSUla?=
 =?utf-8?B?S0FvUnlRZTJKTlBwL3hMSCt0UEVGN29RNTZXVndBbEt5aVhialFLelhPZU04?=
 =?utf-8?B?a3phOFhQbjc5RDVkcEl4MFI3UjJ3NEI5bzJNM3ZhNTQyYVo5bnRzeXk1Tm1J?=
 =?utf-8?B?OXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BE9B52348017446B47F97DBD63227EE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23813102-30da-4ab5-2235-08dc15bf9047
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2024 11:46:08.2987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UK6nYZns73Z9EwYq2V6874R0O7PR190XW4ZGVdmlAiXUxv3SQahdg6LzHKtKdH5zP6HGlf2vSTTzmzunFJoojw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5933
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAxLTEyIGF0IDAxOjM0IC0wODAwLCBMaSwgWGluMyB3cm90ZToNCj4gRGVm
aW5lIFZNWCBiYXNpYyBpbmZvcm1hdGlvbiBmaWVsZHMgd2l0aCBCSVRfVUxMKCkvR0VOTUFTS19V
TEwoKSwgYW5kDQo+IHJlcGxhY2UgaGFyZGNvZGVkIFZNWCBiYXNpYyBudW1iZXJzIHdpdGggdGhl
c2UgZmllbGQgbWFjcm9zLg0KPiANCj4gUGVyIFNlYW4ncyBhc2ssIHNhdmUgdGhlIGZ1bGwvcmF3
IHZhbHVlIG9mIE1TUl9JQTMyX1ZNWF9CQVNJQyBpbiB0aGUNCj4gZ2xvYmFsIHZtY3NfY29uZmln
IGFzIHR5cGUgdTY0IHRvIGdldCByaWQgb2YgdGhlIGhpL2xvIGNydWQsIGFuZCB0aGVuDQo+IHVz
ZSBWTVhfQkFTSUMgaGVscGVycyB0byBleHRyYWN0IGluZm8gYXMgbmVlZGVkLg0KDQpGb3IgdGhl
IHNha2Ugb2Ygd2FudGluZyBhIHNpbmdsZSAndTY0IHZteF9iYXNpYycsIGZlZWwgZnJlZSB0byBh
ZGQ6DQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCkFsdGhv
dWdoIEkgc3RpbGwgZG9uJ3QgbGlrZSBzcGxpdHRpbmcgIC4uLg0KDQpbLi4uXQ0KDQoNCj4gLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdm14LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vdm14LmgNCj4gQEAgLTEyMCw2ICsxMjAsMTQgQEANCj4gIA0KLi4uDQoNCj4gKy8qIFZNWF9C
QVNJQyBiaXRzIGFuZCBiaXRtYXNrcyAqLw0KPiArI2RlZmluZSBWTVhfQkFTSUNfMzJCSVRfUEhZ
U19BRERSX09OTFkJCUJJVF9VTEwoNDgpDQo+ICsjZGVmaW5lIFZNWF9CQVNJQ19JTk9VVAkJCQlC
SVRfVUxMKDU0KQ0KPiArDQo+IA0KLi4uDQoNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9uZXN0
ZWQuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+IEBAIC0xMjI2LDIzICsx
MjI2LDMyIEBAIHN0YXRpYyBib29sIGlzX2JpdHdpc2Vfc3Vic2V0KHU2NCBzdXBlcnNldCwgdTY0
IHN1YnNldCwgdTY0IG1hc2spDQo+ICAJcmV0dXJuIChzdXBlcnNldCB8IHN1YnNldCkgPT0gc3Vw
ZXJzZXQ7DQo+ICB9DQo+ICANCj4gKyNkZWZpbmUgVk1YX0JBU0lDX0RVQUxfTU9OSVRPUl9UUkVB
VE1FTlQJQklUX1VMTCg0OSkNCj4gKyNkZWZpbmUgVk1YX0JBU0lDX1RSVUVfQ1RMUwkJCUJJVF9V
TEwoNTUpDQoNCi4uLiB0aGVzZSBWTVhfQkFTSUMgYml0IGRlZmluaXRpb25zIGFjcm9zcyBtdWx0
aXBsZSBmaWxlcy4NCg0KWy4uLl0NCg0KDQo+ICsjZGVmaW5lIFZNWF9CQVNJQ19NRU1fVFlQRV9X
QgkoTUVNX1RZUEVfV0IgPDwgNTApOw0KDQpBbHNvLCBwbGVhc2UgZml4IHRoaXMgb25lLg0K

