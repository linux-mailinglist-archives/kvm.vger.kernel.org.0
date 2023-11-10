Return-Path: <kvm+bounces-1436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAB67E7761
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 090091C20DCB
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C24139C;
	Fri, 10 Nov 2023 02:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Te/Efcmw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C100F10F2
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:24:09 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEC1420B;
	Thu,  9 Nov 2023 18:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699583049; x=1731119049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GVl79T7g1U4XhbxB41bHg0G5WMnMk7Ba8pIdbJQO5a0=;
  b=Te/Efcmwsk1/i0LaRJN6cnj00z/CkdfeIn3WUC37pa3IZgElHUNqE/X/
   PV/zyfOL7eSoAdPvT6BPyPe24eIxF00NBeNc1tnNRp9xpdilJboVG6lrN
   iYL5xnZ0nKSYNvBL7FVO+s8cdJagrBDcOTZTz6mqcQ9A9B4a7f9pfse2Y
   OOw2O3VOPCMGg9cZuCYLbL01hlvD5ja7gNj5H42hv0H9ZN8BXLU7d7aMr
   eEwSr5hfodOeT4ktks2791gHVBcG2vOkTOuMgT8h91SpAlsPVFjRwXlK1
   Ef7vswwbtBPBNnWERE0k8Y9PKUYSwuBXeHJJ20myf8tyeBdm1bAZAtBv2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="375158039"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="375158039"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 18:24:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="792739492"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="792739492"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Nov 2023 18:24:08 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 9 Nov 2023 18:24:07 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 9 Nov 2023 18:24:07 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 9 Nov 2023 18:24:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uy/mQGSfkVVBk6CJH3Gjxcwf8oBs2XYa0r8Y6Op+1dIjHzZikADH67+ZHGosGmRIJSB/gaC1b5toLF9kYiwGBuFWr13EhZ4XFKmlPm12GdjtN0Xw6xwED3rsaFGYM+tcN324OiNyyvTO33YoDICAE0Ywm/qk7GvoG70Pf82RFG3tL0rr4c45X0mVxlK83Tq2hYwSB0TWmWKhFvqWtJ3W3Jue8xXWEGbzPYqzEXHN77eGkDA7piC8cNpnXl0iYXgB5WXsqcNroUOtizHUI7DOOIc4TGeILNls3x7NROiVrxwvJZo6s9tVmowT7RQ7bUXqZwvGRnOCyl2gyczpp/OtuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVl79T7g1U4XhbxB41bHg0G5WMnMk7Ba8pIdbJQO5a0=;
 b=NRu9G2vE+JAcL1polCA65xv9SL5ugIxdq22pSsST7VEeFW11vNTXzUno+V0WeaMMnl/fYFqQyq7OA2aT5LwYC+jw6CXAvbjjrOuVXqFGBRDbuTw94L5z7x2/bWCfCGgYAez6jSiDGsPl9YCstjpUWbg3Yp8hMcG46GGG8vZ4eu6M+UcIsyMHbVpA2MyuMjxv7iPx0wjxPKZKD1oh+Af6jISnRhpdHgnvaRmEI9X/t4ay3CokIumMc8tZvEGvj0Qn7eRMMM+RWjEAWwsNQ5sGuZHvTB48fdqGokCz56bAhur6HaPJcxejn0/fJbENLYyJz0pRGP1xddossYauu0cesg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6507.namprd11.prod.outlook.com (2603:10b6:208:38e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Fri, 10 Nov
 2023 02:23:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%6]) with mapi id 15.20.6954.021; Fri, 10 Nov 2023
 02:23:57 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "david@redhat.com" <david@redhat.com>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Shahar, Sagi"
	<sagis@google.com>, "imammedo@redhat.com" <imammedo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "Brown, Len"
	<len.brown@intel.com>, "rafael@kernel.org" <rafael@kernel.org>, "Huang, Ying"
	<ying.huang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v15 09/23] x86/virt/tdx: Get module global metadata for
 module initialization
Thread-Topic: [PATCH v15 09/23] x86/virt/tdx: Get module global metadata for
 module initialization
Thread-Index: AQHaEwHk1WEU6GoyN0mDwyxXYrXi6bByowuAgAAw1QA=
Date: Fri, 10 Nov 2023 02:23:57 +0000
Message-ID: <ea8acecfe0e2194d5b9accd4888fbed11ca476ca.camel@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
	 <30906e3cf94fe48d713de21a04ffd260bd1a7268.1699527082.git.kai.huang@intel.com>
	 <96b0d0b4-4563-4012-8147-4318b096a435@intel.com>
In-Reply-To: <96b0d0b4-4563-4012-8147-4318b096a435@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL3PR11MB6507:EE_
x-ms-office365-filtering-correlation-id: da7ffe53-8d8a-4f69-1032-08dbe19417a8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m+Z9hPVgW22jRTD8iqadT2ct2eC0+NBL44/Q+dimKP/Mwy/KEhw4OklY61KYzDWa0kgNeJCwZT3JAKEmJNoaHFEzlI8Rp1yLh7bqCUwlPHU/BJ47J0YEfqlBt4wG/6yY78i9UUkZmaC/t7K4PhIgS4hP+qmuvETFANIexalomX687+AJBWd5uBQG+ztZv/CbHHyZbCwGVBT/koHflIuL1dDyEbAKWCxazP/Mp9NPGdMJBJgHE7AsLMU4nRWv026ObTkzJFfM6luNKILLHIInwuqLWlHmD7uAQ/xCVPxrWJf7rhOMfPSx1ofMZU7XzmmRTcFXURfd+gLPwrrSgcN+Wa0/u6aPoiwzLeXd+czMBpVz4echv7Fbs+eUW5Rvh3LA0dSLt5o7z1Og/34nhH8ClehyZ0eEpC+2Xg+RPHbioK7KQwEM6TYtqyETCJOT9TXy3/Blk/OBt9WPmyExwDwcc51rZwpLv+rsGXiQ9HSHdzEADzdrTAXN5fmE6//TmCSJ9pfx8SwRjAEHQe5GlaMzVUIp/+DmquBSleRyVcc8OULmSn0q74d//LVgOSmY8T/cZTKZQiMI1S51x6OMQ1muGAF2aw0J1NJSUCHYESvcn/c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(376002)(39860400002)(396003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(26005)(38100700002)(41300700001)(2906002)(38070700009)(36756003)(5660300002)(122000001)(82960400001)(66476007)(66556008)(66446008)(110136005)(91956017)(64756008)(54906003)(316002)(66946007)(2616005)(86362001)(7416002)(6506007)(478600001)(6512007)(71200400001)(6486002)(8936002)(76116006)(8676002)(53546011)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnRRUEF4WUdGMTY1aER4TG9TanU1WkxpOHdMMTVqcm05T0RaRUNMUG9sbU1h?=
 =?utf-8?B?cGNaOFJkdmdaUnZMZklDNmIvZlhQWGFON1BEYWxUVC9NVUJ1czhCaGZ4UG0r?=
 =?utf-8?B?TTErSE9sTGhXelVBaGdCWTVoVlFhamppUTBJdXFPeWl2ZVphTlJhTjhJU1k1?=
 =?utf-8?B?NEZtL2g2SHVBUi9SWEhOMmJoRTg0aERPckZTS05uYU0rdGNNVGVjS1d3VkJS?=
 =?utf-8?B?U3c2ZHZuTUVuaFFCRUlweUwwMngxMnlMYXE0dGdjQnFnNnhROE5mL1NIeDVL?=
 =?utf-8?B?TU5Wb1dLTVhreG0yUFVvaVY3S2FWR04vZGJhSnFlY2I1SnFMNTJZSTZYWnBT?=
 =?utf-8?B?amRua3RMTlUwU1FTNlZNWG8zZ0M1YS93bm80MlpiZFhLUU1ZV0x1b3o3T1pZ?=
 =?utf-8?B?aFRoS1Bua2JlNGRPN254L3BiZk9NTEovUFphTWtkbHRLbTRLNkIrcHpBUUx3?=
 =?utf-8?B?M1dzc2Y1Z1VhUHRmZy9iamR6WUJlWTB5T0c2a1dqOFBiRzN1UWMrZ2Y4ME9K?=
 =?utf-8?B?ZzcwT0VQWkp5WStFaFpwbXdMb1dnKzcwSTVFYlAwWHJ4MGRaQ2YvZXR0UUtP?=
 =?utf-8?B?bmZhOFltdjBEaHZWMDBWSXZKelFsdDFDR2RFQ09CcGlWMFQwd0dDb1l5c05y?=
 =?utf-8?B?clpiTG40SUFTVWt1WFRqZ0xhMGFhSVRrVytLWllFQWNCRk9hKzhTTUdXTnlz?=
 =?utf-8?B?cm1vdWl5c2d5S2MyZjdVb1l0WFVPTC9FVk1xd0p2UTYrTnh6S0JuN0hEbFpv?=
 =?utf-8?B?NWZDNndnNUpwTTFzeFJMLzJpYnA3UEFNMHVDMjZZM1J3c0s4YU5XeDBjZFZV?=
 =?utf-8?B?MVM1eWt4RnZkQm95WXJiRmJUU1pOVmhITldiRFhVd0RKY3NNODJyZmRwK3dI?=
 =?utf-8?B?SUtFcS82L0Q4c3JDRkJIc243Vk5HbjB2VXlnTi9QSEhMRmdlT3R1ZEg4TFA5?=
 =?utf-8?B?ZEE0SmZuTk1vclhtcWJCdnBwKzBoUW9wRDhUQWZvZ3ZDUldUa1lteUFpOVdt?=
 =?utf-8?B?K0ZLOXhQZlBkSzd4RC9hVE9qcTNOdHUwOTJtYy8xMUpvU280L3hES3pyWWFK?=
 =?utf-8?B?Q3o3U2d6bWhzSnh6Y1BJcGxteE80RVBya0RGS1o2eHp3MlVZRkUwR3BGZ2Jm?=
 =?utf-8?B?MmhITHUwbUZSZ2R3THRMbU9xOXVlMEN4UzBSZDRMQTF1MEgvQXNjVlQxbHRV?=
 =?utf-8?B?eEVOb3NnNUVNVTA5c0lqN3p5bDMyK1oxZlpvNVptd21ESVBZK3M2WnRUQ09q?=
 =?utf-8?B?VjduRFNtZkg3R3l0eEtFNThISyt3Vk9PV1g4TmZnQ1pweTBiZWJVREREZk8y?=
 =?utf-8?B?NFg0ajQzZzA2T2xGejBSd1F3SE82d1d1aW5sMmhDOW9sNW5pRlBEWDIxQjRq?=
 =?utf-8?B?eGZHNFVjL29hS1drL2RBWXQ5RHVJcTROWm1SL0kzTGhzZjhGcjd1Y1ZGRVhW?=
 =?utf-8?B?M2JlY1lUcUhRNTNzN08yMU9yblhwYXRudzNCTDAreFI4ZWVHY2wvRUZpb0w1?=
 =?utf-8?B?RS9zN3VzYzJUMUx2Y05QK0UzUkhiTDZtOTcwK2M1SG4xaUoxRG5SWDZTaU5x?=
 =?utf-8?B?ekFoa3ppaU5WeGJrWE4rMVh4dmNKelRGMnV4VFlVZUNHNWl0ZkJlbUFoMXpj?=
 =?utf-8?B?d0RGa0xkZzBsd0FRN1IxeGJGak5xL1o2TUxxcHp3WGR2TDltOUEyU3ZUMFA4?=
 =?utf-8?B?d3BLa3crZ25xYzBtd1g2RVZtQ0ZvQXBuTURRZFhScmovdGtzUzNjUU40blFh?=
 =?utf-8?B?WHkvaFZzODNtMjBaeFV1b0pwcnhqM0FqRVQyZ21XOGFDVlFIS1gzZHBLK2RL?=
 =?utf-8?B?RWdtenhsSVpNd3dZT2J3V2k4NWgwY0NXL2lBM1JDNzRMWDN6c3FkRG96OUVD?=
 =?utf-8?B?a2U2MEJiMy9KUVl1YnRFemkrMW5Vb1lRVlpEUEttOWd1WkNOc1lJZ29sa0lD?=
 =?utf-8?B?SW42QU9LNk1ONDVMUEZLZ09vaitPZDI5UEJDTm5IMlNWK0lRVlVmSVFTejJs?=
 =?utf-8?B?VFZicDNlNk1ON2ZmUE85M1JaL3BPUWF1VDhKc3hFcE9iQ1ZiU0hMcytLT24v?=
 =?utf-8?B?djExRnc0RWU4OHlHK3A3YmcxQ3ZZNVFKWlRTd0FZa0ZicHE3d2VaU05lTFMx?=
 =?utf-8?B?b2Y2VEI0dVZCb0JnUkxrcmltdUYzWkppczcrMFRDTDRITG1TN0V6ajVFcmtK?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B750687956C9B4E988AB86D55BBB8B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7ffe53-8d8a-4f69-1032-08dbe19417a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2023 02:23:57.1176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OJhFuIZeeTkdmfRbMZmy7WitM5nC56vQ7Dq1fXxgOwRnj0i3A2Bn5ZwdYdJkpS8hKsmPDDrI9eIMqF7+PCZObA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6507
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTExLTA5IGF0IDE1OjI5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvOS8yMyAwMzo1NSwgS2FpIEh1YW5nIHdyb3RlOg0KPiAuLi4+ICsJcmV0ID0gcmVhZF9z
eXNfbWV0YWRhdGFfZmllbGQxNihNRF9GSUVMRF9JRF9NQVhfVERNUlMsDQo+ID4gKwkJCSZ0ZG1y
X3N5c2luZm8tPm1heF90ZG1ycyk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiByZXQ7
DQo+ID4gKw0KPiA+ICsJcmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNihNRF9GSUVMRF9J
RF9NQVhfUkVTRVJWRURfUEVSX1RETVIsDQo+ID4gKwkJCSZ0ZG1yX3N5c2luZm8tPm1heF9yZXNl
cnZlZF9wZXJfdGRtcik7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4g
Kw0KPiA+ICsJcmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNihNRF9GSUVMRF9JRF9QQU1U
XzRLX0VOVFJZX1NJWkUsDQo+ID4gKwkJCSZ0ZG1yX3N5c2luZm8tPnBhbXRfZW50cnlfc2l6ZVtU
RFhfUFNfNEtdKTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiArDQo+
ID4gKwlyZXQgPSByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KE1EX0ZJRUxEX0lEX1BBTVRfMk1f
RU5UUllfU0laRSwNCj4gPiArCQkJJnRkbXJfc3lzaW5mby0+cGFtdF9lbnRyeV9zaXplW1REWF9Q
U18yTV0pOw0KPiA+ICsJaWYgKHJldCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiAr
CXJldHVybiByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KE1EX0ZJRUxEX0lEX1BBTVRfMUdfRU5U
UllfU0laRSwNCj4gPiArCQkJJnRkbXJfc3lzaW5mby0+cGFtdF9lbnRyeV9zaXplW1REWF9QU18x
R10pOw0KPiA+ICt9DQo+IA0KPiBJIGtpbmRhIGRlc3Bpc2UgaG93IHRoaXMgbG9va3MuICBJdCdz
IGltcG9zc2libGUgdG8gcmVhZC4NCj4gDQo+IEknZCBtdWNoIHJhdGhlciBkbyBzb21ldGhpbmcg
bGlrZSB0aGUgYXR0YWNoZWQgd2hlcmUgeW91IGp1c3QgbWFwIHRoZQ0KPiBmaWVsZCBudW1iZXIg
dG8gYSBzdHJ1Y3R1cmUgbWVtYmVyLiAgTm90ZSB0aGF0IHRoaXMga2luZCBvZiBzdHJ1Y3R1cmUN
Cj4gY291bGQgYWxzbyBiZSBjb252ZXJ0ZWQgdG8gbGV2ZXJhZ2UgdGhlIGJ1bGsgbWV0YWRhdGEg
cXVlcnkgaW4gdGhlIGZ1dHVyZS4NCj4gDQo+IEFueSBvYmplY3Rpb25zIHRvIGRvaW5nIHNvbWV0
aGluZyBtb3JlIGxpa2UgdGhlIGF0dGFjaGVkIGNvbXBsZXRlbHkNCj4gdW50ZXN0ZWQgcGF0Y2g/
DQoNCkhpIERhdmUsDQoNCk5vIG9iamVjdGlvbiBhbmQgdGhhbmtzISAgSSd2ZSBqdXN0IHRlc3Rl
ZCB3aXRoIHlvdXIgZGlmZiBJIGNhbiBzdWNjZXNzZnVsbHkNCmluaXRpYWxpemUgdGhlIFREWCBt
b2R1bGUuDQo=

