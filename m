Return-Path: <kvm+bounces-5741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5539825ADE
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 19:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EA102878FE
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 18:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4240439AD7;
	Fri,  5 Jan 2024 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AdDHe1tU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180FA39AC5;
	Fri,  5 Jan 2024 18:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704480716; x=1736016716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IMIhoe+j/f9rBex1PFLbiC4k1JRAnW3KU/gJ1EeL/HM=;
  b=AdDHe1tUNmx35K745BbL8KcrReBPe7FGlx1JHZVpQy9AkUmjjP3nzeOW
   IIZ/WwTz0fxTOgwtqa0AgskbP13eDBdzENWpqW2VA2n7ZtId6Cw12Udgl
   JsgIBZiGHD5+Jpv6RxcmjSozD4JJrIYYEuFPYLD6+hgsIVcUq6wOW2g7s
   QMCyLnI1wM/dx3ge9dv7PTUC0Uq1c8mpDrFcrKclBDz/caHsUO7WI3+Lg
   uHZ0gL2uREjSnEIDRw7c8a67AoqVmocriU6csiZYSYkzdeREElrNK8miN
   73HL/PJvE/Ie5yPrw8b+4HGW8PJ2zYLR86Udp8tYMuv4aW5eiSWyaTjwM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10944"; a="401348096"
X-IronPort-AV: E=Sophos;i="6.04,334,1695711600"; 
   d="scan'208";a="401348096"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 10:51:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10944"; a="924291033"
X-IronPort-AV: E=Sophos;i="6.04,334,1695711600"; 
   d="scan'208";a="924291033"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jan 2024 10:51:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 10:51:54 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 10:51:53 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 5 Jan 2024 10:51:53 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 5 Jan 2024 10:51:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwJvtWvosY3cPRaQq720gj3mGAGkgQRWnBKxzuLnaBqdw4kSPi75QB1LFylFJ5dIt5Cbv7kcuXVaUG5y6WN8B0MnCXjs8LyyUR1D3E4ZH7//K2NM7V9Nwf5Lb2tLKXkYZWXCKTFXUeaC5/z4bs6qEjKfemXOC49C72AMIEtZOQi57RIPfGBqRSYOLnCztUtkvoNonePv5YrddimpGW4L3cZgHsAh4uL0uMCj7oMHr4XUUpgV3KN1l+Z7ZB8hvUl/z5ojHAShLMMUvRokrTVDN3IwjDPc32Wgz8RvHfjsi5xeVMRJ8PQDk56LvdKekroBQvUscxg3KWTRAz3HAc+lWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMIhoe+j/f9rBex1PFLbiC4k1JRAnW3KU/gJ1EeL/HM=;
 b=gqEQEoa4bebrhp1dH1RWk8XhyxcSfGLEBzFQHr6B4bHo22ILs4T1FJb5T6CWUE523NMAVPe5C3VBZmy++9ZR/+g2sdLK1GutNzBaMVWA+Nzs82Jt/hMgEK8rh/S+3kjC6ZkIfoRQnbbE9mUlpeUf4mJ6EGzAr0oIdXi4+V/EdPi0JIDsppZo08565L5wA8jcF6zoKunJC8kohYJx4lF/Jp9zH+7YooHCyGNTSYe36UXD3dGSklXxRqv1zaWacsEnXGjgYyjlIvpIY2EibxeioXcrN4IQDTAKk3FF4nbqcEiZe2zf590SVS674f+E6YDK0ABotJo/yDnc4l4MpTT3gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4956.namprd11.prod.outlook.com (2603:10b6:806:112::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.16; Fri, 5 Jan
 2024 18:51:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7159.015; Fri, 5 Jan 2024
 18:51:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jmattson@google.com" <jmattson@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Thread-Topic: [PATCH v8 00/26] Enable CET Virtualization
Thread-Index: AQHaM+ybd3H3II6aZU6KWHt3rvxkNLDIg7MAgADO/oCAAOpTAIAANboAgAADMYCAAAXLgIAAj3+AgABzaACAABlggIAABMoAgAAL1wA=
Date: Fri, 5 Jan 2024 18:51:50 +0000
Message-ID: <b6ed5961a3a73de532e2ff0610f43ca129151199.camel@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
	 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
	 <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
	 <ZZdLG5W5u19PsnTo@google.com>
	 <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
	 <ZZdSSzCqvd-3sdBL@google.com>
	 <8f070910-2b2e-425d-995e-dfa03a7695de@intel.com>
	 <ZZgsipXoXTKyvCZT@google.com>
	 <9abd8400d25835dd2a6fd41b0104e3c666ee8a13.camel@intel.com>
	 <CALMp9eRMoWOS5oAywQCdEsCuTkDqmsVG=Do11FkthD5amr96WA@mail.gmail.com>
In-Reply-To: <CALMp9eRMoWOS5oAywQCdEsCuTkDqmsVG=Do11FkthD5amr96WA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4956:EE_
x-ms-office365-filtering-correlation-id: d9347710-8135-43d9-4c12-08dc0e1f60be
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h/NJ3ZosTOztA/nvExD8Aq9okZzIrwQuI06iyQ2jkR0fiKgWy38y5/VUxwJ8rTpw8s6rMUmsT9yT+rd5hZatAMkrd8vTpAjus5pWTiKK5Bf1pAP89NCcSxvHjdi8IV4O7Mj02WXTpuA0sJ1vZPamNn4r2pNvCT4MsIesmY8fCyjNmAn9bTPY4FK2gRf/38YT3cZC516rnTRoGtl0wD7NQNrIx12EXEUfzInbdoenXn+4K2wGHf+b3FrV74xEDtyksv3PKxHAcDs5HYDI1BEuRaOetQFG0SpANihn5pdhIPwuKnSERT+R/BAibnAWnLB/oejDbSAfSsxW1aC3ORZ+IzYIHntv6UZVhVEJY+7CcxxCStWJBGhNE1aytcmq+ysfGWM9edaYcvzskRKHSPoNaSDGunDmaN3IIeTRjBShaJYrTFoaxUVwijU0TSRAPjrs5QAE01TfftdB82SXAIdW5WSxwVT7PWSXcRJ9Y6XYC6cZ7n+82Ufi2wo298A69GRUTYkm8Bz+FZxSLAfLPYfjDX5xXFtgbxMw9dIqVBowPFjn440TmJuJQsd4q+F0e/fw1LWiqvaGDkrMjhmANjNAiGzffSRb/ATvXS3tFpQfGfgaWQovlBXrK5/D3H+AYJej
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(366004)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(2616005)(26005)(5660300002)(478600001)(71200400001)(6512007)(6486002)(6506007)(38100700002)(122000001)(82960400001)(86362001)(36756003)(2906002)(4744005)(316002)(41300700001)(83380400001)(54906003)(38070700009)(76116006)(91956017)(6916009)(66446008)(66556008)(66476007)(66946007)(8676002)(8936002)(64756008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bitkRkhOWHY4elM1bGl0aG1LMWcwcUV2Szd0TExFMGFnNEtNeTdhMEtHYjdP?=
 =?utf-8?B?RnRJV2xXZDhYeXFsR2xqOFB4VmFPdEQyZTRQQURSTDlqenFOS3pvMURmOXh0?=
 =?utf-8?B?MVNDaWk0VFNRWWVUTlRnV0RPZ1ZhWTVHZHl1eGJ6SW4zd0h6WjI0eGoraXFO?=
 =?utf-8?B?Yk1LaTlWamgvWUhycTFYcFRMQnVuMGJKN0dyYU03QThKWVRUakZscVBpMlpo?=
 =?utf-8?B?ZnV3dXRwT3JaditzVFBnTEJ2a29RZjZjWGVlNkN2QmU4czZjK3BLSUQ0Smlt?=
 =?utf-8?B?eHVxTjR5cERESjhNYTlqUXdWblhCaVBvd2YrdFgvUGRLbDByaHFxT09JTVMv?=
 =?utf-8?B?S1pMRmdzQzNEeXZheEN3U3VRVytOSFhjTi9Ya0Q3WU5KS3Y0c1ZFQTdrTG1x?=
 =?utf-8?B?SDU4MW9BUzhIWjJ5MWJRRWcxSW1BS1FvazFHZDJwTWdLbkl0QWdOaXM3Q1Za?=
 =?utf-8?B?QmUrUnFYdGpzdlNEWUhXNFZ0Qy9HbHVQZ0U2aVlaZ0JvMm1BUVpTTHkwbFFL?=
 =?utf-8?B?QUNpVGtudlY0R0J4SlQxWXBqb241bFNVQzA3cUswRmp3a2kyWnlESDVQNzlV?=
 =?utf-8?B?dHR3UCtjSitSb2NZaythU2FEaGlXSy9ONk1nSFlQbVdodmpaaW9yMXVZZXZs?=
 =?utf-8?B?WmFkZ3M0QXF0aG1Za1NIV1AyREpSZnkwT3B5a3M2OHpGdjZZYmE4QWdGV3or?=
 =?utf-8?B?MnFPY3RHenFaZThQWEpacjk1bnBNck9WM0s4cUo1enV0dXBEb1E4UVdHKzJ5?=
 =?utf-8?B?dkFvSFNqUC9qN2V1YlJ5UUcvbmJaWnZab2swSHdzV3dUYnoybU1mdEFtWWxp?=
 =?utf-8?B?YlBGd1VoL1hTUTdXUHpDWmRCUnYyVnNubWxCNnh1eGFWNndVbW01VVRHak0r?=
 =?utf-8?B?cjA4ZHJlMElyQyszck9CNlJpMGRqZU1ybER2Z0JXQm1IMzRacnVxSFJpampo?=
 =?utf-8?B?SXFDKzZKYlRoMXRaeDNxSU92VVpiaUx2dDZXZjI4VDRraDUvNnhiNnFZMGhw?=
 =?utf-8?B?OHBBMkExUFFuU0UvdmZjNkdGOCtXdnMweUYzSmJmdzd4NXB1c0lQdk9QL3dr?=
 =?utf-8?B?L2RQWUczMUZ6dkhyK2EzMVZLYnp5VlhXOXVsZWhpVGdpWUgxYm9jM1B2L1d4?=
 =?utf-8?B?bEo2VE1kdEIvaXJlbHhFQkIwZUVVczlEQlF4QXFoa1J3NFltMGx0SjZSRXJ3?=
 =?utf-8?B?QndVVW93MlNkVW1MbUNXK2xrV1Z2M0YyMHEwOVJPQ0lKelljMUZaYnNhbUN1?=
 =?utf-8?B?Qktua01ZanJGamJta2IvNEpVbUxOWFQvWDZnMStycGFSUTNwSkdWaDBLMHpy?=
 =?utf-8?B?bjB3K3hpN083WkYrTDdCOTMzeXNqQ3ZtWGs3aTFuTjcyRlljaEVsaksySnhR?=
 =?utf-8?B?SVRMTTA5UVQ1RmJTcDFOYlRQVXJVVGhNVWhtV2pBay9rN1VWVG12d09TVFhJ?=
 =?utf-8?B?UkZYWlNNTW11MGRGM0w3amFqK0FLNWFhTG8xMW8yRE52ZVhaMkc2cVpIbElG?=
 =?utf-8?B?MEFxamtQeE1wNG5GY3J0NitYQVUwSWNpY09LTUluMHhZQ2w2MGRINUswalla?=
 =?utf-8?B?ZzM1WGhmbGZnMUpaNjhYZzI0ZDB4MmEzdWxmNVNZN0FXeWRQOG1JQm1ISjhs?=
 =?utf-8?B?Wm9YcUtFWGNxbXkxd25DcURvTjhZaVpNNkVEY1NPNkRFSTFiTUlnU0h4aU1U?=
 =?utf-8?B?ZDNyTnJmeHQ4d0NVNSsrWURKR2JPV2RqV1ZtbG53Mko0bnBFNFpOSTdlM2lu?=
 =?utf-8?B?U1dsMTB0aCtpcnU5SlVBMzFnaC80OVU5eFg4aVlBa0lxVUdPZUZpcmlVTXZU?=
 =?utf-8?B?RVNBZXExc2prQkFRWGJGL1BCZmYybUVDMit1Nk9iOVhCcmdhbXZSL1VSb1Vk?=
 =?utf-8?B?aXNwdEpGNVJ5TlJrbHJrOHlxb0ovOXMyUlQ5djV0MDJFTmhKV2hHOHpOeHU4?=
 =?utf-8?B?bnQ1UlVUVHRaZElWangvVTl3QTRjaE1naFB2UVVJaEtCcHNHSkNHb2I3Tm9a?=
 =?utf-8?B?KzJ6WXRXK3N4Vnc4Qnd5ZEtjcGRsZEY0S3JwSUhjelQ5UGh2K0FTbklXdGdy?=
 =?utf-8?B?d1pBT2owNHg4SVl2bDBoZHdBRXZpdzFFNDNnZElSL3M3dTRYbnhSS2FVZzA5?=
 =?utf-8?B?MElORFNDYzljdFZIWG5XdkwxZ3MrZ3FwU0prcFdvclhwNDZGM3NWS0RaV0Mv?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB95D429044FE94DADB957ED1DFB33A0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9347710-8135-43d9-4c12-08dc0e1f60be
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2024 18:51:50.9328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18avsFztGuKbgqD3ud67FOQLFL4oRXtvQZnJrOKbFW5iyvjNyItw+D21dhdnSGaznGMpr5qwR6/k7wE7qMdmQsp++5bPgL4zY49GU0Nec9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4956
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAxLTA1IGF0IDEwOjA5IC0wODAwLCBKaW0gTWF0dHNvbiB3cm90ZToNCj4g
PiAzLiBUYXNrIHN3aXRjaGluZw0KPiANCj4gU2lnaC4gS1ZNIGlzIGZvcmNlZCB0byBlbXVsYXRl
IHRhc2sgc3dpdGNoLCBiZWNhdXNlIHRoZSBoYXJkd2FyZSBpcw0KPiBpbmNhcGFibGUgb2Ygdmly
dHVhbGl6aW5nIGl0LiBIb3cgaGFyZCB3b3VsZCBpdCBiZSB0byBtYWtlIEtWTSdzDQo+IHRhc2st
c3dpdGNoIGVtdWxhdGlvbiBDRVQtYXdhcmU/DQoNCihJIGFtIG5vdCB0b28gZmFtaWxpYXIgd2l0
aCB0aGlzIHBhcnQgb2YgdGhlIGFyY2gpLg0KDQpTZWUgU0RNIFZvbCAzYSwgY2hhcHRlciA3LjMs
IG51bWJlciA4IGFuZCAxNS4gVGhlIGJlaGF2aW9yIGlzIGFyb3VuZA0KYWN0dWFsIHRhc2sgc3dp
dGNoaW5nLiBBdCBmaXJzdCBnbGFuY2UsIGl0IGxvb2tzIGFubm95aW5nIGF0IGxlYXN0LiBJdA0K
d291bGQgbmVlZCB0byBkbyBhIENNUFhDSEcgdG8gZ3Vlc3QgbWVtb3J5IGF0IHNvbWUgcG9pbnRz
IGFuZCB0YWtlIGNhcmUNCnRvIG5vdCBpbXBsZW1lbnQgdGhlICJDb21wbGV4IFNoYWRvdy1TdGFj
ayBVcGRhdGVzIiBiZWhhdmlvci4NCg0KQnV0LCB3b3VsZCBhbnlvbmUgdXNlIGl0PyBJJ20gbm90
IGF3YXJlIG9mIGFueSAzMiBiaXQgc3VwZXJ2aXNvciBzaGFkb3cNCnN0YWNrIHN1cHBvcnQgb3V0
IHRoZXJlLiBTbyBtYXliZSBpdCBpcyBvayB0byBqdXN0IHB1bnQgdG8gdXNlcnNwYWNlIGluDQp0
aGlzIGNhc2U/DQoNCg0K

