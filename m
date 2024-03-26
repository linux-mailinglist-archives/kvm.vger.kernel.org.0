Return-Path: <kvm+bounces-12642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 155F988B808
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 04:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C35802C2CE5
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 03:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3415128833;
	Tue, 26 Mar 2024 03:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HbrMg0ix"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6554D28EA;
	Tue, 26 Mar 2024 03:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422623; cv=fail; b=OMMVhZ1418VMZ+rtiQ+2NJM+frvnrCCvzpZs87xeybyhKo1GCzWvQQRTO+Il7UOYzD6eq+PtLeb27Hlhg5Arys072e9aQiOeUwdrYPHpWQvTKeHo+SlLbFt5kneeUwCn71M5Pj2QCcmDN7qk0WSBOqoAJIFIHWUD7BYdB0/FVdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422623; c=relaxed/simple;
	bh=q05PX+cMZiXyTtHilqiGNLUIz5meLXS519rMDV6/Tzc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pkk7T5OWUfVFfozTkQkcItkloNSBMM+QBq1tzmECXhEv0/bWihrnQLBI/lnt+YD+ORm1sTKcaClBpRcuafIX+uVT5njdhOysZhUWzhs/2I+JBU7WvA3IADGkuNRx5Qf7hBUBVtMGKHf7houe0WfafmxfeVicBmhUg8XhkoyyJVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HbrMg0ix; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711422621; x=1742958621;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q05PX+cMZiXyTtHilqiGNLUIz5meLXS519rMDV6/Tzc=;
  b=HbrMg0ixsfzx2IDdQxagrhTb63Zy7/maxjXfaCQWYu6/KnygE3nU4IkS
   TAN7K3j+XAO303UcJPfkoN44pJnDo8fcSF+XllcyUzrtjGkpYNrvKIpPt
   nSSWn5YsbUMKJsNieH+ikuZNXBovQj4yofKk/IsV3/sT1aCQMqJU949Ze
   9EFQv060WLuOWmMDzXj6XI1pFmQhQ6tTgf/bvKHYboZuZ61MCTUnbg22R
   UPxqizclj/I0RiwFs0/9uFEGfrZZ1K+ULzHNtRiw03DLJmiKbFfEawhLY
   bhbrwc7189uAMGJ2Zx8DGccg3YPstXLsdiPa92KSxeyrPWuxpqu7oAUs9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17186169"
X-IronPort-AV: E=Sophos;i="6.07,155,1708416000"; 
   d="scan'208";a="17186169"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 20:10:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,155,1708416000"; 
   d="scan'208";a="20384541"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 20:10:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 20:10:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 20:10:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 20:10:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcdiicDkr5oeMqR2llJoXsd4d/4NzS7ku8KjsaMDUwmcr0dJaDgTKIDV/cM3PVIkVWsYuHkXDYYi+QjcVXIp/yN2TMWaL4NCMSq6gABy57AgiTb5gSV4fGyTDEa4jxrdiDGNtOk0fBbUkk7sY3TsxE2GWZ+Y9+v3kQ/ApnUwHzWyaXRSjnwsx1Xkmz/h4IcLY+PP6ZIhFJKtmuW54Ye78nSGx7ednko5jze1wtJEKlDi4B4FRl16eyyy7r0Gh3/V65fReiFjKZ/Ril4IlbEZwHDR3GXtrNt/8hFyhg17ettWsbRGowuGhmI62SarTmZQ1kffVvdOmQtY5twshRq35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q05PX+cMZiXyTtHilqiGNLUIz5meLXS519rMDV6/Tzc=;
 b=KFCSUWKZQhm5Wo88Hq2dEiJfMAG4eZgycC6Rm9dXVVJKxZhyZt/VoY62P0/mkq+XjPpQW3RGhEe08IaCm7vp9och+fxYNsN2APUo2bft7LUO1YKqbw7o32ifzq+zAVRUOqK96boqRYJ9zzjNvFdz6WAjQBYoWDCFtNsovA8AGNsE6PpDm//cJh7W0SzBS5PQbLNR6FZjwESzw/xV0vXZoS3ks12wAggCtcpU6eEeFs6UbMGKWCDsE9LUeXjlpFW/t2a7XMmqnSc8VpuAQf4EDH1frl/NIjj63vO2nVZVhAEVROptYSsCrRf604LLr9N/C2LniFGYh2A76GYnqvBgew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6886.namprd11.prod.outlook.com (2603:10b6:303:224::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Tue, 26 Mar
 2024 03:10:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Tue, 26 Mar 2024
 03:10:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 035/130] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Thread-Topic: [PATCH v19 035/130] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Thread-Index: AQHadnqgg2vk3yqEfEyQbpTSKKE14w==
Date: Tue, 26 Mar 2024 03:10:13 +0000
Message-ID: <572cb899055de0f272b48964ae959e5a977126fd.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <079540d563ab0f5d8991ad4d3b1546c05dc2fb01.1708933498.git.isaku.yamahata@intel.com>
	 <9c35ecd7-e737-441a-99ff-27bda2a9b25d@intel.com>
	 <20240322233658.GG1994522@ls.amr.corp.intel.com>
	 <a021b0779bd23624bedf7d9b854963fb4edd90ba.camel@intel.com>
In-Reply-To: <a021b0779bd23624bedf7d9b854963fb4edd90ba.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6886:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2tpghiP88mA+Z7e5yNBz7bDhMby826BapMjPsvBrRINuxFdUNgwUbhUhkh+fQL1ss9CrNqOSyKnGlJPmQ50pHNd67TtqofcKVj81JC1cWeI5Fe9XzZU/wnPIX4izkZMb1L5XfNH1MTiyxSzpl68BGmgwsyNm+JMcoGM8v2TJfGjcrxth/Guj4Ro6pTc8i+q5qKUkaMOyNshpuB8JRvtSWmiiVE7mUV2A+6U+edwwQR0Vl1JLWhLsEO0olc9kxLsDxrtM3mMv+hl/0cEYL0a+ylOWGUpRpB4T/E02EVmVSdxbCOSJq/1BCK+rpwmz1lrIa9bNZzrI47F3BlpCQWh9LyN3ixr/5BEaos8ge7PXtbDyqIEmDnqcMee36mbXWhpnnPGkSgaT9ykXcJdDBMsxXMXHe/rIf0LOcOzaAeSArFNCXw0uM2CJlbuSdSKzdQJBHVLEz2aJa4Ov0V2OIwz3ZM7717NGBCwG38bJQEr3bXImKyUO5FK1vVkpaBDBxMnQ5FPB9m4SERWYXhEy/qynpn9je/KB5eVIzsJR8k8dJexfcjPlSmNjXhbXt2l5vE2+yRgTqUiomDABDxPWkvJIrLLOAgXeeGy+z3LYWigUsFg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkcxQ29zMWUzN3h6aVVIVzhlcEw2eUlNNGc4UDh4anY1RU1RdUNRV2ZNOUFp?=
 =?utf-8?B?T1ZZb0oyUnJlbk5HRHZGRnhuTnhVZ1B6RzBmU3dhcW16SjRvWDRWYndDMTl4?=
 =?utf-8?B?M1d0SmRKa0pSdGkzL080NXFiWDlnZlVFRGFldHl3bTV3a0puL3hKUEM3M2c4?=
 =?utf-8?B?QUZYT3l0WHlBd0tUaDFMUEUydEEyS00zbmZBVDVaRkJ5L0JuMjhDbjRqbUJ1?=
 =?utf-8?B?ZG5IaHJGMGpHMVpQMW9Fd1dUMlozaU1tVkZDWGV6V1UvMXRCd2puS0p2MGZ2?=
 =?utf-8?B?b2Z3Q0pDdXFDN1FNdVBwL2QxclV4ME8yajIrcGN6Q2lGY1NCWlBRZjhaL1VR?=
 =?utf-8?B?Z1FSRnh3cmM5S2lPLzc1TEhYYnVqbjhkS3JzYjdYR3Z2QU03dmtISWpJQWZS?=
 =?utf-8?B?bkxkN295WW04alY4VU5PbnRlRW1oL2RzZ2V2SFFPQ1oxWTE0TDFPVTF1cTA5?=
 =?utf-8?B?NTVlTWtUbkxBZGovQ2VFWHg3N1BsWEs3QitjbkRodDBrNWhOaGE3VzUvSWxP?=
 =?utf-8?B?UXVSaXEzOVhqTkxVeEsrTGt6cUxyUU03cjBPN2VCVERTUDJOQXJxTDlrOVc3?=
 =?utf-8?B?TGw4M090REJ5bDFSMHpxQTZLSWhXNGhERDBuRmE5cDNFa3grNXdaSi9weE9U?=
 =?utf-8?B?MFRWazZpQVJkN1cyRU5VWTV3UDhyZnhOZFBqL0lORzNGWEJmdm4zWWNZU3VO?=
 =?utf-8?B?UCtTWkd4Nzd1akdyL2xUdStiZDJJMnJhMUhMQnFPTFhVaHkvR3RkL3h1VFhw?=
 =?utf-8?B?a2ZURHl5cS8va0FGNmpWVnFHZDdDVkEwWG1PSEJ3OW1Fa25BV2MzdnVzOGNy?=
 =?utf-8?B?U1RVZG05UzlGWW9iTDBndDlEU3YxS05IVzY0REdpdjFObVFhK3N0TmY4ZTd2?=
 =?utf-8?B?NzZKSU1aMEV6Sk8xN2JBMG5VeklHRUwzaDRWR1NSTTEwd29CMHZHczdOMFFM?=
 =?utf-8?B?NlJRVUJ5M0llc1p4dEh0eUFxS3pIYWNYM050ZmxqSW5BMEhQNlExejZWczNa?=
 =?utf-8?B?c0ZJeUJhRlJmSlkvYzRJVjU3SDVRWC8yT3RvaDFTdzRuc0I0Z0FQVmxsUStR?=
 =?utf-8?B?OGJBU3FRNmFDY2wrdGFoOGRWSytKaGNXaW9mVnpBVEhOMHhqblZYQ3RHd0t2?=
 =?utf-8?B?aGR2N01OTDVDMDJ2QnlzSzBRNllSVDFqWEYweUpTMDlna2tDck5YcHJna1dD?=
 =?utf-8?B?a21rZVVVajhVTEd0aXhHWGowNWNBbU5ROERMcFFmTEpoWFM3S3BxN1VsRmYx?=
 =?utf-8?B?YjZTV3VGR0xyRWhGTE01Ny92NkUxWlZzMHBLOExCSFREWkgvMTJ1dDRGWStF?=
 =?utf-8?B?NHNKNEJmN1VwRm5uT2ovTVVVSG9XRENNakIxUEI1bENoQkhtMkRkekdpamJo?=
 =?utf-8?B?a3ZPYitBQlhZOTM4Z1ZmUWZ2Uk5XRlVvd0JBQ2NoSWoxSE9ZNlJsNEdnVUxs?=
 =?utf-8?B?T0NtTTNqZlN3clBRVkM1ZVRvV2J1bEhESjBYcDRCaExad0hFQ0g3cnBkRGpD?=
 =?utf-8?B?V0p0VFB6TzVOampTbEc0OGhwR21JM09BNnliSGZ1b1hiL0hiYk1WMGczdkpL?=
 =?utf-8?B?THlVVUZPclYyTVM1U0dxV0JkWUxxMXBVdm9ydWZzeHA0ZjIxbWpwakM3OWVw?=
 =?utf-8?B?ZVZjTHE1L1pwKzdwYVgyQ084ME9QdnRpK1kydmxzYmxuTms3U2VWSXdDRTQx?=
 =?utf-8?B?SmV6Q2VIZkUrVnBJYThkNEFHUkt4UTRLaWZEYmtVVkxYamJZZHNjTzlNY2dh?=
 =?utf-8?B?cEYvVnFJVitKN2pTM3RHQnJrYk5BNHpzT0NSNkIxVi9iVmpJSE1VUU5WdUdT?=
 =?utf-8?B?Yy94ZlIzZ2h2OFVBZzJLZmpWVkpqYzdkRmxpUWdZYkNiOU5pYnY3aVBkVlYw?=
 =?utf-8?B?TjF0YmpYWkpnUEZyNlM0Z1Q4NEhtUzlpQkJaOUhXQWFOOUI1dnJiYzhKamlz?=
 =?utf-8?B?dkUwKytvT0hPaVFjanRQckYvWnZQbmhFUzR6VFZxVldrbi90WlZveWtzcUhL?=
 =?utf-8?B?M05JRUpHcWltSmxFbHhJME1rbmt2SFJoQkFsaHpQeFc4SlBZS0xkVG94ajdh?=
 =?utf-8?B?a0xiTnVxR2RZRlM4aVAreFlKZWlPWFZvMlBuNEtDWnpDY2VSeHFTMXNWNWJG?=
 =?utf-8?B?MXZSM2xRa05FbWJNQmI1RUJyaEJXcnNiY05oeHdmeGMrR3QzaUhZUGNMTnZB?=
 =?utf-8?Q?2LtpbqyJebZjrmFitbth97s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55824EE9A13F5544B60B9EA968A3A519@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a8e9ec-102b-4867-228a-08dc4d424161
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2024 03:10:13.9447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a1PLWoI9mrMdqGc6LlTZnOJtBTWnwJa+sPvGsWDU8l7MKzwX4d/yg+5owlDViMd9o98IRXvdQLnzl8aew3hBczhAcySe4WyBZNSKv4nvCbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6886
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTAzLTIzIGF0IDA0OjI3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IHZ0X3ZjcHVfbWVtX2VuY19pb2N0bCgpIGNoZWNrcyBub24tVERYIGNhc2UgYW5kIHJldHVybnMg
LUVOT1RUWS7CoCBXZSBrbm93IHRoYXQNCj4gPiB0aGUgZ3Vlc3QgaXMgVEQuDQo+IA0KPiBCdXQg
dGhlIGNvbW1hbmQgaXMgbm90IHN1cHBvcnRlZCwgcmlnaHQ/DQo+IA0KPiBJIHJvdWdobHkgcmVj
YWxsIEkgc2F3IHNvbWV3aGVyZSB0aGF0IGluIHN1Y2ggY2FzZSB3ZSBzaG91bGQgcmV0dXJuIC1F
Tk9UVFksIGJ1dA0KPiBJIGNhbm5vdCBmaW5kIHRoZSBsaW5rIG5vdy4NCj4gDQo+IEJ1dCBJIGZv
dW5kIHRoaXMgb2xkIGxpbmsgdXNlcyAtRU5PVFRZOg0KPiANCj4gaHR0cHM6Ly9sd24ubmV0L0Fy
dGljbGVzLzU4NzE5Lw0KPiANCj4gU28sIGp1c3QgZnlpLg0KDQpUaGUgQU1EIHZlcnNpb24gb2Yg
dGhpcyByZXR1cm5zIC1FSU5WQUwgd2hlbiB0aGUgc3ViY29tbWFuZCBpcyBub3QgaW1wbGVtZW50
ZWQuIEkgZG9uJ3QgdGhpbmsgdGhlDQpURFggc2lkZSBzaG91bGQgbmVlZCB0byBuZWNlc3Nhcmls
eSBtYXRjaCB0aGF0LiBJcyB0aGUgY2FzZSBvZiBjb25jZXJuIHdoZW4gaW4gYSBmdXR1cmUgd2hl
cmUgdGhlcmUNCmFyZSBtb3JlIHN1YmNvbW1hbmRzIHRoYXQgYXJlIG9ubHkgc3VwcG9ydGVkIHdo
ZW4gc29tZSBvdGhlciBtb2RlIGlzIGVuYWJsZWQ/DQoNClRoZSBtYW4gcGFnZSBzYXlzOg0KICAg
ICAgIEVOT1RUWSBUaGUgc3BlY2lmaWVkIHJlcXVlc3QgZG9lcyBub3QgYXBwbHkgdG8gdGhlIGtp
bmQgb2Ygb2JqZWN0DQogICAgICAgICAgICAgIHRoYXQgdGhlIGZpbGUgZGVzY3JpcHRvciBmZCBy
ZWZlcmVuY2VzLg0KDQpJZiBhIGZ1dHVyZSBjb21tYW5kIGRvZXMgbm90IGFwcGx5IGZvciB0aGUg
VERYIG1vZGUsIHRoZW4gYW4gdXBncmFkZWQga2VybmVsIGNvdWxkIHN0YXJ0IHJldHVybmluZw0K
RU5PVFRZIGluc3RlYWQgb2YgRUlOVkFMLiBIbW0uIFdlIGNvdWxkIGFsd2F5cyBoYXZlIHRoZSBv
cHRpb24gb2YgbWFraW5nIEtWTV9NRU1PUllfRU5DUllQVF9PUF9GT08NCmZvciBzb21lIGZ1dHVy
ZSBtb2RlIGZvbyBpZiB0aGVyZSB3ZXJlIGNvbXBhdGliaWxpdHkgaXNzdWVzLCBzbyBJIGRvbid0
IHRoaW5rIHdlIHdvdWxkIGJlIHN0dWNrDQplaXRoZXIgd2F5LsKgDQoNCkFmdGVyIHRoaW5raW5n
IGFib3V0IGl0LCBJJ2QgbWFrZSBhIHdlYWsgdm90ZSB0byBsZWF2ZSBpdC4gTm8gc3Ryb25nIG9w
aW5pb24gdGhvdWdoLg0K

