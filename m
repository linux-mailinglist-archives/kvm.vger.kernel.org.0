Return-Path: <kvm+bounces-1813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8012F7EC0DF
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0078B1F26AFE
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59ADB156D4;
	Wed, 15 Nov 2023 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l4q3mxF6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B3A14F60
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:41:57 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4170C2;
	Wed, 15 Nov 2023 02:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700044916; x=1731580916;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OTh++LmvkaJZFqIOFxKitBqd741l2d7CiRwjLl7sG9E=;
  b=l4q3mxF6GAvVEJWtIFqXbRNJoZfKF+hPXOybwKi/rVJpS/qyFu6yTt3m
   1A4kBB70yAENRNIVYLioDfUVLwJ7u/GIWYKVeX5K1UZI5hsoo8wNeV6e/
   tp27B3Yjx5OcPJ/2d/xNDIHO3u2hcUEMlTjY8BH5/nHCd21TrqmUiVMgz
   0adkYkm13heTnbVwqiaMhbNsAT0zqH88Y9jLIXzuB/Zg3eMAOYYVum5bD
   8m6/DaxuFjoghk2UyS1DcGWvrdKFjLppUucNtnBX/72Ybi4/bqxKrscqH
   mEAae65jL+wzkIZ/eScNJ3qzx8QNfISjpVGiY8kyp31jMPsR/VYLMGRM9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390649868"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390649868"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 02:41:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="794109132"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="794109132"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2023 02:41:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 02:41:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 15 Nov 2023 02:41:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 15 Nov 2023 02:41:54 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 15 Nov 2023 02:41:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjSY9n3kejkiY9HJ5Lbyer2WOAZ099Brg8GpCsUmWLh+dOzPmpm8rxYV6I6CheNUUf+7uHO16+HerTry8+r391odQmbVzgj4ohEZjKO7im+kSR6UaMTtOEOhv/HnEUpUXagp9q3o919nduad1p9aeC7FDmWHzFCPE3RgO6JWgNgAs8W3tbKMEOi2OYb2n/7NTrVPIXsgDWjtBb3Xl0luwiwPdYG9WmZCK1i4pQ+Dzt1A9UJoQzSfOH/blPiYGUTjrX2Va+Xdx7WvdzkDphHOjsueCqGWaYpE+IIGB3k+X+XPOCWJjLxyTpZIErpUcP2x8L0VZJTZfU81iSzrAY1O8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTh++LmvkaJZFqIOFxKitBqd741l2d7CiRwjLl7sG9E=;
 b=ZYYky+8Z4tVjGWdia/W9Vk9vKnjx4va61m7fxB8F8TUX3tKY6XgOc+9b03PwW2CAM+RYgL/wpsGhxrr1wrYLgmc9RR29BqJBLGS+T4q10EM2K8ioRzavGmbBsKQntaDSgQxuy1gVfl4x395Xo4iur/gNxeFTrIe0PxZ9x28KJ3tlywjrx0E2wopTA4ksTe5CkzO1ze+FEPIJtZkbBlaisEg0jQn0FBYm169ylJs7ZlOqiCLIEizSAoLHQealcpIhdf85o915h7+2/QM2emzcbn/omGE1xPRlLWn4QfLQ61y1odqEusScO76gTTrQC0n+9aWf2F9SxPCGbVHLACHk3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DM4PR11MB8225.namprd11.prod.outlook.com (2603:10b6:8:188::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Wed, 15 Nov
 2023 10:41:49 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::64e:c72b:e390:6248]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::64e:c72b:e390:6248%7]) with mapi id 15.20.6977.029; Wed, 15 Nov 2023
 10:41:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "Luck, Tony"
	<tony.luck@intel.com>, "ak@linux.intel.com" <ak@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Shahar, Sagi"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"rafael@kernel.org" <rafael@kernel.org>, "Brown, Len" <len.brown@intel.com>,
	"Huang, Ying" <ying.huang@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 05/23] x86/virt/tdx: Handle SEAMCALL no entropy error
 in common code
Thread-Topic: [PATCH v15 05/23] x86/virt/tdx: Handle SEAMCALL no entropy error
 in common code
Thread-Index: AQHaEwHm+KsibtgJD02EneVLO/7rh7B6OnGAgAEAMIA=
Date: Wed, 15 Nov 2023 10:41:46 +0000
Message-ID: <63e9754ec059190cd1734650b8968952cbe00ee9.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <9565b2ccc347752607039e036fd8d19d78401b53.1699527082.git.kai.huang@intel.com>
	 <20231114192447.GA1109547@ls.amr.corp.intel.com>
In-Reply-To: <20231114192447.GA1109547@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DM4PR11MB8225:EE_
x-ms-office365-filtering-correlation-id: 4ef14b46-2031-4f0a-199c-08dbe5c77792
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ban+87dwW/Tv27gU/GvOGTT7N5KVGdii/8vhWedsCSREjWDhDgNxzaEo2L1DTTjdS02xxykVTMVyHCvNiu0fIjYFLm8T4AU/LuFJ/+FXKrnBAx4pAGmyfgCuzt1D59IaAG/APvDq/EO8JbIug9Qk12+zgm91bafdd3A59WcBZZE/YQyUWvMQzcsIG4LR6QUksrlBT+05Yi6VNNlRaN+3T793aaU0oKrD3aAD7SR4kQ6pf8byRviEX8odXbpEar39/leewQ9NDeKiohZifqLpNmBKzu9cWRQL+jP7KhKDcbif2OeYzL289MNbKn0N08dWa5m4cUawzNfDkqU0YXOAX82V70dDSy3Zipq5uuCBjPKCAg++8TV8YkWtnYRC65aKl8L1SSHkumlEHj9j9PYESJ/L6J6ly3UlNgK4kVh6gcu6XROp51F9otcH83Uu4Nqjg+ye6Am/ZrVSdIYSKvR5jgQGENgp+JadrCCt5msvRfvGD8z2sjgA12LUr06ftYTs1kthD8oRsrIHNZ3V7MYZya3+eR/HuKcnESVLmY51eyyBrb7HPgUHMC7vYoneq8whzNnX+ZdptqEqKjpKdHrnqbiM+for12ZnitBn049u+7+tJOPvdovCOMNTPgF3Nz8n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(346002)(396003)(376002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(7416002)(5660300002)(2616005)(6506007)(6512007)(26005)(2906002)(36756003)(83380400001)(66446008)(66556008)(64756008)(66476007)(91956017)(478600001)(54906003)(316002)(76116006)(66946007)(41300700001)(6916009)(8936002)(122000001)(4326008)(8676002)(71200400001)(38100700002)(6486002)(82960400001)(86362001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ditaRThiN0tsd243YWU1dWUrK0c5RHFTM0F0V2lCY2JydDBMSlhhL0wvV1NB?=
 =?utf-8?B?Yk8vY3FqRDlmZnRwdnlvem5UUCtwTEc5K2pETEZESXVhRHkxdUJUQmNZaWxX?=
 =?utf-8?B?SjFOd01aSnhJN0JYaWw5WktrdENDNVU0YkxOUTFOb2daSFVSbzE1eDN1SG5a?=
 =?utf-8?B?d25XMjM3WjhjM1o4M1F3OFB1Skx3U1ZROGV3RjhPWG96RS82V3ZqZGxBSWpD?=
 =?utf-8?B?UDAyUjdGV0tPVTAzb3dXd2tIKytKbVVYSGpYRmVuaUkzTlZHSWswNTI0TkM2?=
 =?utf-8?B?UjdzaFNEQk5FOUV5bFNBemFhNE9TV0xwcUJaTW1Ha0wxbFk5ZE9UZzZGRXhH?=
 =?utf-8?B?Y0t1L0s4aU5jMFFPSUJPZU96UmpNMGtrQ29COGFielNnMEZxb2pkY3pYbEhx?=
 =?utf-8?B?aGJpSlFnUzZ0VU5XMGllcWJBcEU5US9sMjJkRDdvaWFsK3VLcHVxVy9rQ2E5?=
 =?utf-8?B?UVNkYmtQU2ZVa1FxMTh2VzNLeHo1OFNxbW9kcVBqRDBTNU5FejlXY3grOHJt?=
 =?utf-8?B?MVdubHpjR2dnK2VaSXRCKzFxTHZVMXhzaEoxN0ZIc2ZHdjRvdHF0bXB0WU9z?=
 =?utf-8?B?R3lNelo5cmFDbmE3eVhHYzNLR1RCa3NLb1J1UTdvUTlTRm5rOXdoQkNDa2NI?=
 =?utf-8?B?VFZnMWlWeW5JS3IrZnZPRTEzTHZ5Rmk2emkvMkh3TG1ITjByVEd0VXgrUkpL?=
 =?utf-8?B?d0lpK0FxQnVURXFKdlhpbHpMUXAwL0t4bGxoTzlodWJOdzVXVzJUcE1Qemdr?=
 =?utf-8?B?WlhlSGtSTTBMMzBHNzhlMW5WTGkyajZ1T3pCaVYvM0paREZMZU9XRnRlRjBC?=
 =?utf-8?B?dE9QRWhwZHY2eDlLZUsva0NWdlB0R1VhdEt2TUcvdnhSUVBYWm4zR0ZNV0NV?=
 =?utf-8?B?bEVRem81bndQR0RYUml4OUNqNXdUUkVFUTJCM1ZZblhrMzdjQnFtcDZOaUhX?=
 =?utf-8?B?SWszS0k5R2VOWEFGS0lSMjZiQzB4RTgxRldRWllNaTdOZkJoVzBaSjhsSWxP?=
 =?utf-8?B?UHZrYkQ3R3FjdHY0RW8vZ2k2SkVOQnU2QkRTdXRkblVxUktaZUVoZzV1bEJy?=
 =?utf-8?B?YVNsa0c5OWx4Q1hEalpQQTJUN01HRmg2MzdBY1hKMGU4TktUQmdQd253czI1?=
 =?utf-8?B?MndoM1ZxU3lzdWZTRGQ1SjNpVHlQN1pIZGlqMHdubTNNdkJoUlRKU3lJUEMv?=
 =?utf-8?B?UWhlWi9WK0wvZm1QVWZkZ2F2dUJMZXZWanBVR0VOSmZUeWovTDMxalRnR3JO?=
 =?utf-8?B?ajE1S3hCM0hrMkdJSEpkUEdzVFBtcGJvRW5YeUdsbnJYTmUwQ2NLaEtXUjVV?=
 =?utf-8?B?Qk90UlV3NnlFbGxBTWlWcjk5MDQxMWtBUms0eXhUdDB3NGtwNFY0c2c4cjlB?=
 =?utf-8?B?cHRTL0xkMnpTaXdvWjUvcUt2ZWZlcWF6YjEzZkUyV2ZaK29PWjZ1MlRJa2lW?=
 =?utf-8?B?TnBPbmlDUXVIV0pDV1MyS0NnR0trdTZhOGpzZlREVTYzS0ptR21KYm5CUElq?=
 =?utf-8?B?aml2ME9FQzNuVnYwOGNydTFZT1dSWUdOU3hLUzdmMzU3Y1FYai9lU1BEZHFQ?=
 =?utf-8?B?ZHRTV1pBMGF6MHp2WmtRWUVWYk0wc215bnpjMDczTzhaMCtvZVc1ZXBoSkVB?=
 =?utf-8?B?aE04S1BKcHRtQVYwZEdhMHBwbWRsWStxSExlV3pPOWhEWXNQaytNdkZ2ZjE4?=
 =?utf-8?B?QzR3U1NXU3FSS212ekY2S2t4K3NTYmdvZjlPTFBEdTV3VDJhK2RnOFhHVkZy?=
 =?utf-8?B?ZXAxYTQ4RHZHNU4zRTQ0M2kwaHROamZxWkdBbTBUQXFXRy94Zyt4K2kxRDAv?=
 =?utf-8?B?VE0zVzY3RHVpNXBnQVlGc0I1VWhYeCtBbm1EemFkeC95OThMRGNyMjJDdHBM?=
 =?utf-8?B?NmJXMHRva1ZwTVVudE5ZUHNKYkFQeGNENElvK05OcTAybUNjWWhNNzVoRDFr?=
 =?utf-8?B?eUZ5VW9TQ0JMcnVLUzczWmE4cmdOUU1OYXBTOHJTVGNLOGJxU1hjdDlrWXdE?=
 =?utf-8?B?T1J5TkpCdnJqTGFWM01hV1U3R3BPWHovdDhpWUhTMFYrem51Y0lpaXdobDhm?=
 =?utf-8?B?NG81YUdXcGpqd2ZTc3AxMDRVRmQ4SVRiWEhzNkpmV0E5bWRhNmNWR1hYWkJ4?=
 =?utf-8?B?OTFQdjRQR1MzdnpsUjdwNU05OWhYRE5vNE1EV2hiYlF4ZHc2aGRzeHhoWkhS?=
 =?utf-8?B?ZXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F40177E2F2EE374C9A721E02DF7B361A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef14b46-2031-4f0a-199c-08dbe5c77792
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2023 10:41:46.9924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +SWjYjOyQen5oxAKsPN3M0fcaRvDRZ0CNT7qPf8K6xVhfpZ94AeyXuN9ShTABuMShmGPRJNZA2aJU5iLo7qA4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8225
X-OriginatorOrg: intel.com

DQo+ID4gKyNpbmNsdWRlIDxhc20vYXJjaHJhbmRvbS5oPg0KPiA+ICsNCj4gPiArdHlwZWRlZiB1
NjQgKCpzY19mdW5jX3QpKHU2NCBmbiwgc3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXJncyk7DQo+
ID4gKw0KPiA+ICtzdGF0aWMgaW5saW5lIHU2NCBzY19yZXRyeShzY19mdW5jX3QgZnVuYywgdTY0
IGZuLA0KPiA+ICsJCQkgICBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKQ0KPiA+ICt7DQo+
ID4gKwlpbnQgcmV0cnkgPSBSRFJBTkRfUkVUUllfTE9PUFM7DQo+ID4gKwl1NjQgcmV0Ow0KPiA+
ICsNCj4gPiArCWRvIHsNCj4gPiArCQlyZXQgPSBmdW5jKGZuLCBhcmdzKTsNCj4gPiArCX0gd2hp
bGUgKHJldCA9PSBURFhfUk5EX05PX0VOVFJPUFkgJiYgLS1yZXRyeSk7DQo+IA0KPiBUaGlzIGxv
b3AgYXNzdW1lcyB0aGF0IGFyZ3MgaXNuJ3QgdG91Y2hlZCB3aGVuIFREWF9STkRfTk9fRU5UUllQ
T1kgaXMgcmV0dXJuZWQuDQo+IEl0J3Mgbm90IHRydWUuICBUREguU1lTLklOSVQoKSBhbmQgVERI
LlNZUy5MUC5JTklUKCkgY2xlYXIgUkNYLCBSRFgsIGV0YyBvbg0KPiBlcnJvciBpbmNsdWRpbmcg
VERYX1JORF9OT19FTlRSWS4gIEJlY2F1c2UgVERILlNZUy5JTklUKCkgdGFrZXMgUkNYIGFzIGlu
cHV0LA0KPiB0aGlzIHdyYXBwZXIgZG9lc24ndCB3b3JrLiAgVERILlNZUy5MUC5JTklUKCkgZG9l
c24ndCB1c2UgUkNYLCBSRFggLi4uIGFzDQo+IGlucHV0LiBTbyBpdCBkb2Vzbid0IG1hdHRlci4N
Cj4gDQo+IE90aGVyIFNFQU1DQUxMcyBkb2Vzbid0IHRvdWNoIHJlZ2lzdGVycyBvbiB0aGUgbm8g
ZW50cm9weSBlcnJvci4NCj4gVERILkVYUE9SVFMuU1RBVEUuSU1NVVRBQkxFKCksIFRESC5JTVBP
UlRTLlNUQVRFLklNTVVUQUJMRSgpLCBUREguTU5HLkFERENYKCksDQo+IGFuZCBURFguTU5HLkNS
RUFURSgpLiAgVERILlNZUy5JTklUKCkgaXMgYW4gZXhjZXB0aW9uLg0KDQpJZiBJIGFtIHJlYWRp
bmcgdGhlIHNwZWMgKFREWCBtb2R1bGUgMS41IEFCSSkgY29ycmVjdGx5IHRoZSBUREguU1lTLklO
SVQgZG9lc24ndA0KcmV0dXJuIFREWF9STkRfTk9fRU5UUk9QWS4gIFRESC5TWVMuTFAuSU5JVCBp
bmRlZWQgY2FuIHJldHVybiBOT19FTlRST1BZIGJ1dCBhcw0KeW91IHNhaWQgaXQgZG9lc24ndCB0
YWtlIGFueSByZWdpc3RlciBhcyBpbnB1dC4gIFNvIHRlY2huaWNhbGx5IHRoZSBjb2RlIHdvcmtz
DQpmaW5lLiAgKEV2ZW4gdGhlIFRESC5TWVMuSU5JVCBjYW4gcmV0dXJuIE5PX0VOVFJPUFkgdGhl
IGNvZGUgc3RpbGwgd29ya3MgZmluZQ0KYmVjYXVzZSB0aGUgUkNYIG11c3QgYmUgMCBmb3IgVERI
LlNZUy5JTklULikNCg0KQWxzbywgSSBjYW4gaGFyZGx5IHRoaW5rIG91dCBvZiBhbnkgcmVhc29u
IHdoeSBURFggbW9kdWxlIG5lZWRzIHRvIGNsb2JiZXIgaW5wdXQNCnJlZ2lzdGVycyBpbiBjYXNl
IG9mIE5PX0VOVFJPUFkgZm9yICpBTlkqIFNFQU1DQUxMLiAgQnV0IGRlc3BpdGUgdGhhdCwgSSBh
bSBub3QNCm9wcG9zaW5nIHRoZSBpZGVhIHRoYXQgaXQgKk1JR0hUKiBiZSBiZXR0ZXIgdG8gIm5v
dCBhc3N1bWUiIE5PX0VOVFJPUFkgd2lsbA0KbmV2ZXIgY2xvYmJlciByZWdpc3RlcnMgZWl0aGVy
LCBlLmcuLCBmb3IgdGhlIHNha2Ugb2YgZnV0dXJlIGV4dGVuZGliaWxpdHkuICBJbg0KdGhpcyBj
YXNlLCB0aGUgYmVsb3cgZGlmZiBzaG91bGQgYWRkcmVzczoNCg0KZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCmluZGV4
IGE2MjE3MjFmNjNkZC4uOTYyYTdhNmJlNzIxIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vdGR4LmgNCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQpAQCAtOTcsMTIg
Kzk3LDIzIEBAIHR5cGVkZWYgdTY0ICgqc2NfZnVuY190KSh1NjQgZm4sIHN0cnVjdCB0ZHhfbW9k
dWxlX2FyZ3MNCiphcmdzKTsNCiBzdGF0aWMgaW5saW5lIHU2NCBzY19yZXRyeShzY19mdW5jX3Qg
ZnVuYywgdTY0IGZuLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHRkeF9tb2R1
bGVfYXJncyAqYXJncykNCiB7DQorICAgICAgIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgX2FyZ3Mg
PSAqYXJnczsNCiAgICAgICAgaW50IHJldHJ5ID0gUkRSQU5EX1JFVFJZX0xPT1BTOw0KICAgICAg
ICB1NjQgcmV0Ow0KIA0KLSAgICAgICBkbyB7DQotICAgICAgICAgICAgICAgcmV0ID0gZnVuYyhm
biwgYXJncyk7DQotICAgICAgIH0gd2hpbGUgKHJldCA9PSBURFhfUk5EX05PX0VOVFJPUFkgJiYg
LS1yZXRyeSk7DQorYWdhaW46DQorICAgICAgIHJldCA9IGZ1bmMoZm4sIGFyZ3MpOw0KKyAgICAg
ICBpZiAocmV0ID09IFREWF9STkRfTk9fRU5UUk9QWSAmJiAtLXJldHJ5KSB7DQorICAgICAgICAg
ICAgICAgLyoNCisgICAgICAgICAgICAgICAgKiBEbyBub3QgYXNzdW1lIFREWCBtb2R1bGUgd2ls
bCBuZXZlciBjbG9iYmVyIHRoZSBpbnB1dA0KKyAgICAgICAgICAgICAgICAqIHJlZ2lzdGVycyB3
aGVuIGFueSBTRUFNQ0FMTCBmYWlscyB3aXRoIG91dCBvZiBlbnRyb3B5Lg0KKyAgICAgICAgICAg
ICAgICAqIEluIHRoaXMgY2FzZSB0aGUgb3JpZ2luYWwgaW5wdXQgcmVnaXN0ZXJzIGluIEBhcmdz
DQorICAgICAgICAgICAgICAgICogYXJlIGNsb2JiZXJlZC4gIEFsd2F5cyByZXN0b3JlIHRoZSBp
bnB1dCByZWdpc3RlcnMNCisgICAgICAgICAgICAgICAgKiBiZWZvcmUgcmV0cnlpbmcgdGhlIFNF
QU1DQUxMLg0KKyAgICAgICAgICAgICAgICAqLw0KKyAgICAgICAgICAgICAgICphcmdzID0gX2Fy
Z3M7DQorICAgICAgICAgICAgICAgZ290byBhZ2FpbjsNCisgICAgICAgfQ0KIA0KICAgICAgICBy
ZXR1cm4gcmV0Ow0KIH0NCg0KDQpUaGUgZG93bnNpZGUgaXMgd2Ugd2lsbCBoYXZlIGFuIGFkZGl0
aW9uYWwgbWVtb3J5IGNvcHkgb2YgJ3N0cnVjdA0KdGR4X21vZHVsZV9hcmdzJyBmb3IgZWFjaCBT
RUFNQ0FMTCwgYnV0IEkgZG9uJ3QgYmVsaWV2ZSB0aGlzIHdpbGwgaGF2ZSBhbnkNCmRpZmZlcmVu
Y2UgaW4gcHJhY3RpY2UuDQoNCk9yLCB3ZSBjYW4gZ28gYW5kIGFzayBURFggbW9kdWxlIGd1eXMg
dG8gcHJvbWlzZSBubyBpbnB1dCByZWdpc3RlcnMgd2lsbCBiZQ0KY2xvYmJlcmVkIGluIGNhc2Ug
b2YgTk9fRU5UUk9QWS4NCg0KSGkgRGF2ZSwNCg0KRG8geW91IGhhdmUgYW55IG9waW5pb24/DQo=

