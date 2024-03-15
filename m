Return-Path: <kvm+bounces-11907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6B687CE70
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 381F02822C1
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 14:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1B736AF1;
	Fri, 15 Mar 2024 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aTvmgwrE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623A42C1BF;
	Fri, 15 Mar 2024 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710511315; cv=fail; b=EgObx/6J+ijTAPl3KDJSMFGX1IahwgbpKrccSJ0qMOZGKbAVlOG1c95c/7egyuEPySoAhgi/t5cReA/Bf9SLqsaPaWrp+btqc4R2Sm6gmudVJo8Ljxwm12UTpCdl97qVya6omR18heqP5SIbl1RTl6LRdrRlFku7TAz1QfJGsPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710511315; c=relaxed/simple;
	bh=7sjWY2UFGNkL+T8rDORUHcqbdwsQglDPoIMO/5eywOA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TcMM2HH3uAjv+jIK66ss/WVt6k9Hhh7fo7TGHmaJGeTpax5zRvB1s50ChUnfCd9oavKD/NYUup2eOTwqIROqwr1KALfK/hsyOkPRg0tAZeh0+TWCiMUehXs4yc0/T9ibRw/HANqGs6foaePeal/zd1lRADbA+ZuXRtEERrfKAyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aTvmgwrE; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710511314; x=1742047314;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7sjWY2UFGNkL+T8rDORUHcqbdwsQglDPoIMO/5eywOA=;
  b=aTvmgwrElFmW4oG7vMs2jZiFHtdDj5WUC/ZctdImxbo951rxRRfgaRJm
   A+f7L1AQofIXANEm23MMclxEVmgTCEBOLc8loPza0hKWU0tjcH7PQSBoi
   RN6DFN7/hexYbuftXUX0jNzBxLNOgUPC/4xvtD7rdRzA+uiLljewkZhQs
   V+H0AKhGqENHARKkECEC5sMEX15yxoO4bHQQCQ1yF+PJUWoEJYS0VAApP
   5GAdOIiedxd2QQ+ljRt54GP2ixkptWf4xFB8DoFlSLGjPT8C/SrN/Vsrm
   wfa1RfKa6zMdnU0qN8Danfa037W4esGsXc0CZrtvqekOCHYKOYxkVA86o
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="16780123"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="16780123"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 07:01:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="12590017"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Mar 2024 07:01:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 15 Mar 2024 07:01:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 15 Mar 2024 07:01:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 15 Mar 2024 07:01:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFFDP4qkcHT7P6U3RXEp6P8FnAgnFs5Ktvu8Mz9HRrpasoMVqv70r7Et9dHW0tlRrBWCFjDJhqIsQroBdC3oqvDCqJ3NacJN6t9ur2Zwu17eSWoF4hmiUBhGOFKWiKA3SH7mgNtpIGaNdXVXxc8yRnx21cEx0qNPxX44V/InQtVmD90RxqDmuBSEfmVr7prAwWbhfRD+LEi4D2fBTYZCHJFgyBOf1S8hYRIhjl977gsdIm0ocIOC5ClhjCMijCHcJAhlEJsmhZwQBeVf8SDkBGJjRTU/n0JFEcS8uaSKwwhl/cH92Yc4fHsVT6xQW0Q5GPU9vKPFLbDX3MbvIThUSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7sjWY2UFGNkL+T8rDORUHcqbdwsQglDPoIMO/5eywOA=;
 b=ka2ZQAz5jndBEw4vvIQrbuldY8JV5QYiJr1WI2ArVR5xs9EyTGaKlSrEzedPzueE+MCP86VaeFUWtsLk94U27BKYeW1ZTQ8C9AyI7MMYb8AiRGALBzsxpVuKDR01TGLv+PBj+6YN+n7JNFnUjsrS/09/ee9vJstxVtI0zf+SJUjZAvHTazceaxCXYxSV8Dw+xVsTWAVUzNSTfuzThqPaOBeleOMguPaOVfpwVUE8wWnwCSA1Nk5ycsQWQ5CA3tthmd2KGExSEhzOBISuCPLZ9kn4GFFHH0TRrw4PujrsHFn45xXwerlG1+bbuQi8mbgFskOLp0RqvAbLSLhEwyzjWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7560.namprd11.prod.outlook.com (2603:10b6:8:14b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Fri, 15 Mar
 2024 14:01:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.008; Fri, 15 Mar 2024
 14:01:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Thread-Topic: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Thread-Index: AQHadmyiHbz3BdiqjUa/DQsd0Q/1DbE4BTCAgADQlAA=
Date: Fri, 15 Mar 2024 14:01:43 +0000
Message-ID: <fc6278a55deeccf8c67fba818647829a1dddcf0a.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
	 <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>
	 <20240315013511.GF1258280@ls.amr.corp.intel.com>
In-Reply-To: <20240315013511.GF1258280@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7560:EE_
x-ms-office365-filtering-correlation-id: 3af3dd17-3a21-4b45-6bd6-08dc44f87235
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TNVwwklkj8xhFss0lNBQZwPgdP6XLUMfh78JTMbRwi5ZU2nSoxAuLOt93lfvzBYNooeG09IIbeAn/zpmiFOpwHuAGmlgEXgUNceJZY07LxyTmaw7ANGJ07GnnCBgpBzJVC6USycijSsec10hEuzytUI8JM1MeytiswBdLmD+AonICJDK5wmNxy++aNSIHBa6c5wYzR3EvHihlMWSh/F36+jHc+gVXvIUZXsFZk/xP6UVxBUH49wWx9iRnVFNrtkJsz3aRfbO9IGyWRs5LsVWw7vkmagd4nKeFGVrBkgz8iG0fp2n0cbQ6SBlGK4ifMFYJ+mN1rErGfSPdC6QZJVDwODZfcPtlwUo1parnreEHec3l8I2dddPi1/iva9cJfCunTlaVl8Hs8ghUZavC4ArbpBayKcNpxmVflHelSXp5nFd2qAWz1Ywl4+Gm4KlyeSTAc/nwdXuH22BQNaWVYqtNbAyZgBb8g5MfSMGxmiFpTS+ktDFX+O8e/ZZD1pwkG7h8mBaAkyykZy4EOVbHl2so77qo/v/cvabexj9U+wPaf/AmlVkftSOlreyJnYA1Jsds4OupUsk97BDamVoDBbeBGQKlvmG5m23St7n2/bHYWKm24dH9UkFulDm3IkL7kfBy5HNRmaK/yPLa8eUi6eqyX+vFxi8M3dK+vV5+Zkhieqo8mr5xHDtRSPB1voGZef+TUPL6x5iiju1TfGEXV/ia7bqPCu9BE5eK+EZTZ0y1Hk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1JKQXRtalRhY095NGdJZmZHYklxaEZRRkM1bVp0MkMwUHFWbnJVbDRTN0xO?=
 =?utf-8?B?ZWdyMFJranc5NVZjamFYVE4yYlBKZS92NHlka0dHaFpFeXVvOXQxTTd2cjcy?=
 =?utf-8?B?TStERTA0ZDU1QW5WcTh1SjVrdldnME5KM20zamc5SFc4dFIwbVBxZ0xHLzlF?=
 =?utf-8?B?OXRkSDNMWkNVcVcySzUzMDRpdUM5L3JCQ2JLczBOUTRTU0lGZEpDLzdTV3pY?=
 =?utf-8?B?ekNCdjhDWFIxbkxoOWVwNDVsRm8vek40Qys1bVVxL3JOSzBIeTRId3BFcXMv?=
 =?utf-8?B?USticHcyQXBoNnpBZWVOQmlQRHZSc2Joa3R2UEYyMXAwTlVFYjE3RU5vVUNQ?=
 =?utf-8?B?cXJPMmtMelNNeDlmTTJDaVNXck1TdFlGc20rUjEzdmRta2FQTjdiMUpmUERv?=
 =?utf-8?B?Y1FoemJlRXZLVWJjUnpiY2I5KzZ5S1NzK1B5anIwVVVVTDlyT1QwcFZNc0N0?=
 =?utf-8?B?Q3dNOWtyOHhIMFViZlM3ZXBkUmFWbGhjY3JJR1VsRjhtUFdFM084aTJES3ZP?=
 =?utf-8?B?ODNFc2Q2N1VudUJoQ0xOMm9ZVUl1N3lXYlVQWW5CNE4rYnVPa21SckR3WTll?=
 =?utf-8?B?WUN5TmZuampRdVY2Y01mdXpzeWZibmlBR0lEclhqZi9UYVNZeVNvL3dLT1N4?=
 =?utf-8?B?eUZoaFV2Q0liL1BkaWJXU0pyL05YSTBETW0zU3hJY3VzK2k5ckhiWks2a3RW?=
 =?utf-8?B?Nmt0SmR0Z3NMVU05enlwcjU2TStwSDhGQWQvNmhpaG1LZ05ib3ZJWDhhMXdo?=
 =?utf-8?B?bld2Y1lBUnBCbVlHV2tYUFd2NUkrVzVIbFRzUVVWNGRsMkpQR1BqU3JGQjRi?=
 =?utf-8?B?VlV4WWJsV0FpclRzayt6R2kySzl6UFBEU2M4Y2NKL3BtZ1NzWkJudGFvU3dJ?=
 =?utf-8?B?SHhuRTVxTGlCWC82L0JGL0VCOW45bHdOZkhqV2pod0tUZ1NmU3Y4cTlJQUlM?=
 =?utf-8?B?VzNxMzhGc0pyNWdxYnllM3pQU3JFa0VLMTQ4b2VRU2h2NmQrTU8vaG9lWk9l?=
 =?utf-8?B?eDN3NkVLUkdGeXAzWlFENDhHWWhscWwwQnFnUUk5cHpHQ2V5b0NjK1YyYXdv?=
 =?utf-8?B?OXBqLy9NZ3I3K3RBUVl2Q2o3SytXTzRLbXlRUi9IcVY0RXd6a2lHdlRsanJW?=
 =?utf-8?B?d2txK05tb0lUdEZaWmlCQWRobHpSbnlBZGMrd3dXTkNUOE1aaEZob1VmS0hh?=
 =?utf-8?B?VjNkYlhkUVlRNHhrbGFrdUFqV3p4cTljQnhOb0NtQy9KaVlXSTB6Z28vcUx2?=
 =?utf-8?B?bERkOEJsZzdVMHRHR2dXVW4wMDQ0UXA4VkhSb0h2eHFvVURya0U0Y0d1cGR3?=
 =?utf-8?B?bVdkWkxnT1hTeFFOdmVGSDFQbDRveVd2alR3UmlrRTVpV2FlZnhlQ0tMK2hx?=
 =?utf-8?B?cjI5MXJTSjlsNFNXZzVLR2xJMlAvbWUvVlprbWZ4bGE3MHE5NEt0TE1oOXU1?=
 =?utf-8?B?WUd6UFY4dmFLbHQ0WTQza1dzQWx5OHpLMUJIdVN4ZGtSOGU4WTNCV3FqMTZy?=
 =?utf-8?B?d2Zmb1l2L1p0d0Rha3QwV3EwV3VFRkhsemJmVnpQQ29rWjIwalEzNGEyMnB3?=
 =?utf-8?B?NkVNc2w5dVRTaDFIZTFLLzkwWVJEYlR5cjQyMitQTFR3UHFuSVcxQUxNRFFO?=
 =?utf-8?B?RExFM013ZWt3MXhRZEttdGtRYjdkb3hnbUVrdFM1WGRqT1E5d3QrdWhETytz?=
 =?utf-8?B?V3FYRWtYTVpKODk5Sk5FRjIxbkFVZm9kbUlHTjEyUE1BQnpkQXFHNFpiSUVk?=
 =?utf-8?B?aDZHUXo3d2MvUU42dThjak95UE9PNjdQWFQ1SkFuUHNWODROeEkrRnZ3Mm5F?=
 =?utf-8?B?Z0xwbzB5Ym5LTDBBUVREdUlTZDJxMkE2TlJkWXNJK2VIeHFLcVlDRE1wZjBR?=
 =?utf-8?B?dVYxcVZ3OVJITlRjWjVoNDgwQ1c2aktBTHRyczlQMW1sV1ZFT3dDY0swVVVp?=
 =?utf-8?B?dzJGN052OFEwUkVNaVBZRDlweEV3NFVTY0E2UWRyeVJwTFljU2lmbm9vM2dU?=
 =?utf-8?B?MmdiU0JRYjNPbEhOcmdNSDhXVzBWZGRGSlloUitEd09MR1RvSHkzcVNlNlRG?=
 =?utf-8?B?QmhVTWJOaExPekd3Z2VMejZFOU1vVDdYb1BRY1FJQVV4WUpmMTRZK2ZmVits?=
 =?utf-8?B?and4S2RjZE5FamY2L2gybm9UZCtPdDhyL1ptbVFWNXFyemxsczByVEhIZWxY?=
 =?utf-8?Q?LGDqYs+lT+DAKe8yF+bF4ws=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B705CE65214CD4A988C0001595A6B17@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3af3dd17-3a21-4b45-6bd6-08dc44f87235
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 14:01:43.8245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f+OJ9Ruhmiy7FF118rSlpjcjx+Bt3WAR1JaSKSlCjN450+KUBYScu4dKMOQsSAPZgIS5sB8+XHjGxK6b8Pg5tpUixqW05px8CPcZq0kCpbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7560
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTE0IGF0IDE4OjM1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBPbiB0aGUgc3ViamVjdCBvZiB3YXJuaW5ncyBhbmQgS1ZNX0JVR19PTigpLCBteSBmZWVs
aW5nIHNvIGZhciBpcw0KPiA+IHRoYXQNCj4gPiB0aGlzIHNlcmllcyBpcyBxdWl0ZSBhZ2dyZXNz
aXZlIGFib3V0IHRoZXNlLiBJcyBpdCBkdWUgdGhlDQo+ID4gY29tcGxleGl0eQ0KPiA+IG9mIHRo
ZSBzZXJpZXM/IEkgdGhpbmsgbWF5YmUgd2UgY2FuIHJlbW92ZSBzb21lIG9mIHRoZSBzaW1wbGUg
b25lcywNCj4gPiBidXQNCj4gPiBub3Qgc3VyZSBpZiB0aGVyZSB3YXMgYWxyZWFkeSBzb21lIGRp
c2N1c3Npb24gb24gd2hhdCBsZXZlbCBpcw0KPiA+IGFwcHJvcHJpYXRlLg0KPiANCj4gS1ZNX0JV
R19PTigpIHdhcyBoZWxwZnVsIGF0IHRoZSBlYXJseSBzdGFnZS7CoCBCZWNhdXNlIHdlIGRvbid0
IGhpdA0KPiB0aGVtDQo+IHJlY2VudGx5LCBpdCdzIG9rYXkgdG8gcmVtb3ZlIHRoZW0uwqAgV2ls
bCByZW1vdmUgdGhlbS4NCg0KSG1tLiBXZSBwcm9iYWJseSBuZWVkIHRvIGRvIGl0IGNhc2UgYnkg
Y2FzZS4NCg==

