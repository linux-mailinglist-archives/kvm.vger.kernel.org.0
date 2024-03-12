Return-Path: <kvm+bounces-11698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2A0879DD9
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 22:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C1D4282AE4
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 21:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98CA143C48;
	Tue, 12 Mar 2024 21:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bLBZPgMh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7882F4CDE0;
	Tue, 12 Mar 2024 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279983; cv=fail; b=YtFfkVsdSFVZF6zU12oXX0Yo/tUi4vhhGjESIu9L2EidO/Zn6Kn+rHxDMtR6sEGQx+GMR52lnj+wnosIdiLpo0s4ErrjITZko1hQOtyVdaeQUWgWjcrgy/+KPMRpGYnAhaZig/thZ0gzzMH9wOYwhITr6+fy+DuPxx25sWw5UDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279983; c=relaxed/simple;
	bh=zlxVAhsukIf1a9pXFVhW7l5d0HASrA2w59OLIt/YWmE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FCJIkG2fosAPLbtmu5ABUFOshZUfXIIIXFXEvX0AxLHOxEbhMsM8V6QxGOHUAyfJPutU7fOYayfTor9dLzb6c4NNj39X1BC8GIhWP05gVq/+Mkq4y6WRmDY6SHxTAKlnoVrn4U3oraI62A89JSDi2eoDV43Ez+BnmuY8ZlLtdXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bLBZPgMh; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710279981; x=1741815981;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zlxVAhsukIf1a9pXFVhW7l5d0HASrA2w59OLIt/YWmE=;
  b=bLBZPgMhs/7Ov0azGlDhn7snrmWZU6CtglOEx/1oSGhee9ZwVlM7Jnnq
   lAB72oA8qDs6ugDP/ejuarFusqB1id2AC1d0rwlpnwq3DbnDZ3dGUkPYa
   OzO66o/++sisfSZmzzmCIPIZ3B2/yas7dO9TZWcy/F57k6QzvgtMxFVC1
   +R29pJxkfOrGZ6CiVWmZ8+oAOVXd23mnyqd0lr4na/Kq6ycefNte/sBrk
   6i/JJT7NQmM9jkvd8Y5GME4NV2mtceC4fOiHp8OtSeuUElXreaBFedvVm
   9YgS8SVPsmdtALUT60PJq3/hVvcrpxT6nev1CNblzm4HtvenOT9+IWPSV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="15743960"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="15743960"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 14:46:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="42618139"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Mar 2024 14:46:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 14:46:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Mar 2024 14:46:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Mar 2024 14:46:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fzzn/7+jcwxOqPzJK9b8P15NHIiUrYHIr/QJ19cg5VM69xxKEIcWc2BInWhD6cP+BevCNGds2sOfZHUNqYqZO5+9urQ20DZbMS3z1g3p1s/RFKezf5S+7E/P9bpyCfS8Mfxp1lTsqY6re/V5DuaDubSX23jPWjowAKRsNmPzNh+54q2oX4VMkIYWe6+iHNl3GV5QAXeresAgc3WTGszoScoEG2Mv/3bKWHE09SNCzaXhdOkFk1svW5ixQxRgXDmN/F+UA9bSuXgsIihv3SfFUmRo6eXoZRLmSuJI4pkXdq2ahe11O3l2g0iqOc8aqouafw+JVVfROioKeDJucgELsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zlxVAhsukIf1a9pXFVhW7l5d0HASrA2w59OLIt/YWmE=;
 b=oCSTpEGoTUQ2K49L7ufcI+mDyZ8sxYA/yCT8qeM67cB2Vwsw5jYgITZtXT1/GSUwRTCYWSGoJ5n6sy0n5jssLTvC1Ewa528LqQGHgq6NhxW2CleGNS3+Mua3HX5z1NY6eEI2zlzG/hjNBjZqAIzN/B4Nzv2TUtA0Wzq5gKfaFOG9M1Z3NssFKWwTIu0R0SD6S56cAEIw5NzZofNtp3IXA4DjCo2do8RvT+tLLbyD9ETwHTf5Ev5iG+ioWyaOmBpuOLlDmiqg584Da2cpTmD6Mlk7mn865BH7AMeazG6QErOoJwX0JCpsv4v9u18AOOFMxJRXvt3bTRjooRpRYoaS8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6885.namprd11.prod.outlook.com (2603:10b6:303:21b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Tue, 12 Mar
 2024 21:46:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Tue, 12 Mar 2024
 21:46:16 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Thread-Topic: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Thread-Index: AQHaa/6D7nn573Vr+E2nz60+bAfcD7EzPxoAgADdMoCAABx4gIAAezgAgAABbQA=
Date: Tue, 12 Mar 2024 21:46:16 +0000
Message-ID: <fc3102f42ef6a1efa93d5bc75c9ed8653554cde2.camel@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
	 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
	 <Ze-TJh0BBOWm9spT@google.com>
	 <6b38d1ea3073cdda0f106313d9f0e032345b8b75.camel@intel.com>
	 <ZfBkle1eZFfjPI8l@google.com>
	 <3c840ebd9b14d7a9abe0a563e2b6847273369dcd.camel@intel.com>
In-Reply-To: <3c840ebd9b14d7a9abe0a563e2b6847273369dcd.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6885:EE_
x-ms-office365-filtering-correlation-id: c554246b-e38b-49e6-321d-08dc42ddd852
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nEPgK7/6CFGTN+3XMEjqsnByNubX++IP6t9/UJT5ajHoDo9rh7PCsZVYtmKKsAEYPfFw/F2PkzRahYjdKDbR7UZG+80SpLm+hWZXH6mAEaTnGq9/EMFwOe6nKVYQA4TOVcfBjoRVaS7626dkKItPR89mPG7XmeUry7VZbLOPTRIrD7zep5uVRi2LBTiGyq7BSApKvncH8rZk3DRoqbaavA1yHEgSWS4eCQWbQCslWqYuwQjxCUkv1kGfw6zuwo9dlDTqGxi9XNqFLr1hllIoaHe415U5MpBVLE61urq8M77alh2KOiP3mavjRgcq1+bzCG33iuBcUmw1ttn7xG/m2kFFKMQKFsNxrmjWJDUOcF3MqVNOCza/JLWjzlUEdlkLRW1vtqnCxN7Xtsijzrf3z++ZVh6amkijvfhmXtq/TzL9zG2t7S2TuKKT6zbA0RQhwpwCEubGe3VetMnKPUrTKN800uOiWOxvgKMacTcQfMT4ukaOjdcMfK+9hg3G5KJupmNgevTbt+4NORDqN5kYFK7vDzOOgmQ0h9Om9DHl3XqzH3Tm5xCKAvnDO3vAvzQHaGq4QFsiY6doK+QNce2FjkgUtRFR3puCBTkZYu+/dlMMLW3JmwOzHacmLuflLplStjlQJilUC/kDNbD/s60YCH1cqtlnd0gNfhSyX+EYAoA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWtJeTgyYnROOXd3czJNUlk0Y2J1UUtuSHE3SHZJVFZ6Yk5KMUZ1UWxBbjR0?=
 =?utf-8?B?RGVrY25tRHQwTldueFhSYTAyaXlYaVFvNlEzd1FYSWxydkVJakNJYmFNQngz?=
 =?utf-8?B?Mm5ZZlhySGZ3OTRnSkR1bXBDeXZSd1lQbE5oWEhzbDhDMFpEK0lzTU14dEpU?=
 =?utf-8?B?SDJwcFpoNzNFdHBhS3Q0d3cwaHRsc01vUmNVN1d5c3RJVFY0cVR0S2s5ZVdK?=
 =?utf-8?B?YXhva3ZoYktTbUdnNU9nbkhERWJ5ZFhnV1dhWk5YNytCQVQ0TW9FTWVjeHBX?=
 =?utf-8?B?U1gyTjhheHM4ME1rdGFCVnl1MmNwd0xqN0lOTmpHZkRNTFJXU2ttNHE1TWlt?=
 =?utf-8?B?eTJ2RzdnbWM1dTUwWCtIRHZURmZFWVBGOU16THRXTEZOZVM4NktSUEZQRFdC?=
 =?utf-8?B?a3JuYU1CdkxIcFNmQmxwTGlQd05zZGtWSjdEbDVMeVpQQ1g3a3MyYnROVTlU?=
 =?utf-8?B?dmtKLzZjUFJBWjA0VVlaNUsxOU5WNjdoSTVLTkRyTmd4dHo0bzcyekRHMHla?=
 =?utf-8?B?K2JnM2cwZVZXOTZXTUZwWEJKZ25uazhVUCtOZ1A5MkgvaEdxN0J6ZDZ6eHpJ?=
 =?utf-8?B?dy81S2gwM3kyM2kvZzRDem9KZlF6Z0p5WEtLeGVRTnM3a2F3cGJHdkFKMzB4?=
 =?utf-8?B?YkpzSlg5MUJNbkZ2R3Facjl5amcvYnc4c2MrZzJScXhHTDZHazEySXBnZDVY?=
 =?utf-8?B?K2dCUFE5RC9KcjFLbE9kcWlTRHRkUWJkZjhQcHpQWTlpTmxEa0x5QmJUdlps?=
 =?utf-8?B?VkxIM21Bb21GMDQ4MTdUU1VyRmtTaUVWMUdCamFjLzVFaHQxa0VyWjBTNmt4?=
 =?utf-8?B?aEYvZU02N1N0Z3dHV0NlNkFORmdjWnJSZ3pXT3RxWC9CT28wTE1OSThFR2R6?=
 =?utf-8?B?dHZzYUVDQTVkTWxpbCtQYXVvWEU0WVBSNnUraDg2QlE4cjNPRUNVY1IwOXNG?=
 =?utf-8?B?enduSWpmUkUveEpxYnpaakh1c3A5L0ljTGRZbmZ3cUc5OHFyYUNyMjRSZHpQ?=
 =?utf-8?B?YWd5MVlBWTNlYnp5QkNUUEhmWVl6L1lyK0dzUHR1TnVndGUxdGt6RjJKM3I2?=
 =?utf-8?B?Yk4xVnRzbFpXeGF3NmNqU0ppTDB5NFA2SnVKQS90Ym13d3EyTHV2L3Z4NXJk?=
 =?utf-8?B?TkF4cGc4K3E5K2RyNmtrMGVOZG5zOUdzQk5qQ3hGZnZxaFh5UVRqQ0RucUN6?=
 =?utf-8?B?Sm5UMjNvaDJ0WHJlTVY4WC9pMDUzT2lwRjhDVHhxcU00RzYwd1kyTlRTVlIy?=
 =?utf-8?B?ZzQ5MWx0MnRDMkFXbGFVSVpicmZuc2pRdFYydXh1NEJOZ1RUY0pzRmgvYmx6?=
 =?utf-8?B?dzluNDV6SVU2OW9RTlNaTEtFRHBKYkdsU2duV0ExTXNzTno2YWlPSFFQVUdy?=
 =?utf-8?B?MXNaWVZHZDlnM3BLN3cxTmdEaTUxN0JuY0ROQksvdDBpaWVKdWJYU0N1eGJm?=
 =?utf-8?B?a1ROTUVNQXI1VlFzUEpCUDdmOHpteWY0a1NReVVuS2J4MXlnUHd3bnR1WEUv?=
 =?utf-8?B?Z1lxdThYMDNWRHhNV3lIWDkvUWFtMkJncitKYXVISHVTQUpnMWxWSFV3bWI0?=
 =?utf-8?B?Vk1UYWhwWXhxcWxhZHhIaFBRdlpQaGtnQzYwSnlKMGZCREI3ZVI3ZFd0OE14?=
 =?utf-8?B?RDBhNUtEZTY2aXhjVjBDa09nckNNeWRTSnJaQ2FSZzlrajFpNnpNanpDZXd5?=
 =?utf-8?B?Z0dYWWxIa0dyb1NmdW4rNVU5NlFXR2ltYmNpVklEOE9ZSHhKcEhqbE9jKzJm?=
 =?utf-8?B?SVpmdUEwc0hHOFFHb2xSM29SVGdBRG1yUVJYYXhMbGdVRTRnblRuZkhnQjZy?=
 =?utf-8?B?VG41dlpwMHRXZExrM1laaXhQd1loc3lGOUdsYVR1b1NWVGg5L2dQSkhXdUU5?=
 =?utf-8?B?Nm1kNFI5RHhET1I2ZUtVOWVZTzRPNU5RSS9GUHg4d25YZXlqcDhQd3NwdEp2?=
 =?utf-8?B?M0hDYzJveUJycFZQS3lwV2dwMXd3ZTU4aEVDWW9nSFBYZk9DbE9pR3ArR2d6?=
 =?utf-8?B?cjNKMzlaNnB3TFkrVjRtNzZzRG9DRENzamkwVWhQbFBQekpmN2tHOHZHcXV0?=
 =?utf-8?B?d3ppR3dqQysrMW5sZFQ1NWFiZ1lDVlR6dzVIdlJWOHErVlpjU05jZVlzZHRK?=
 =?utf-8?B?K2M5YW81VWYrYWYzcFJybllTWnhZYmNoREQ3ZmpjRzBFQkZqc1NxN2xINXIr?=
 =?utf-8?B?elE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69EDDAC4C38123438DEA38A18CD82C6A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c554246b-e38b-49e6-321d-08dc42ddd852
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2024 21:46:16.3864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mDqZAGMFMa66w3QitFlqMpPV45eelmx5smcilHlqfAe0iF2uUyz9c7MBPnE8+L4mkr5t5Kj/umpMaDSvWKrbEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6885
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTEyIGF0IDIxOjQxICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUdWUsIDIwMjQtMDMtMTIgYXQgMDc6MjAgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gT24gVHVlLCBNYXIgMTIsIDIwMjQsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+ID4g
V2FpdC4gS1ZNIGRvZXNuJ3QgKm5lZWQqIHRvIGRvIFBBR0UuQUREIGZyb20gZGVlcCBpbiB0aGUg
TU1VLiAgVGhlIG9ubHkgaW5wdXRzIHRvDQo+ID4gPiA+IFBBR0UuQUREIGFyZSB0aGUgZ2ZuLCBw
Zm4sIHRkciAodm0pLCBhbmQgc291cmNlLiAgVGhlIFMtRVBUIHN0cnVjdHVyZXMgbmVlZCB0byBi
ZQ0KPiA+ID4gPiBwcmUtYnVpbHQsIGJ1dCB3aGVuIHRoZXkgYXJlIGJ1aWx0IGlzIGlycmVsZXZh
bnQsIHNvIGxvbmcgYXMgdGhleSBhcmUgaW4gcGxhY2UNCj4gPiA+ID4gYmVmb3JlIFBBR0UuQURE
Lg0KPiA+ID4gPiANCj4gPiA+ID4gQ3JhenkgaWRlYS4gIEZvciBURFggUy1FUFQsIHdoYXQgaWYg
S1ZNX01BUF9NRU1PUlkgZG9lcyBhbGwgb2YgdGhlIFNFUFQuQUREIHN0dWZmLA0KPiA+ID4gPiB3
aGljaCBkb2Vzbid0IGFmZmVjdCB0aGUgbWVhc3VyZW1lbnQsIGFuZCBldmVuIGZpbGxzIGluIEtW
TSdzIGNvcHkgb2YgdGhlIGxlYWYgRVBURSwgDQo+ID4gPiA+IGJ1dCB0ZHhfc2VwdF9zZXRfcHJp
dmF0ZV9zcHRlKCkgZG9lc24ndCBkbyBhbnl0aGluZyBpZiB0aGUgVEQgaXNuJ3QgZmluYWxpemVk
Pw0KPiA+ID4gPiANCj4gPiA+ID4gVGhlbiBLVk0gcHJvdmlkZXMgYSBkZWRpY2F0ZWQgVERYIGlv
Y3RsKCksIGkuZS4gd2hhdCBpcy93YXMgS1ZNX1REWF9JTklUX01FTV9SRUdJT04sDQo+ID4gPiA+
IHRvIGRvIFBBR0UuQURELiAgS1ZNX1REWF9JTklUX01FTV9SRUdJT04gd291bGRuJ3QgbmVlZCB0
byBtYXAgYW55dGhpbmcsIGl0IHdvdWxkDQo+ID4gPiA+IHNpbXBseSBuZWVkIHRvIHZlcmlmeSB0
aGF0IHRoZSBwZm4gZnJvbSBndWVzdF9tZW1mZCgpIGlzIHRoZSBzYW1lIGFzIHdoYXQncyBpbg0K
PiA+ID4gPiB0aGUgVERQIE1NVS4NCj4gPiA+IA0KPiA+ID4gT25lIHNtYWxsIHF1ZXN0aW9uOg0K
PiA+ID4gDQo+ID4gPiBXaGF0IGlmIHRoZSBtZW1vcnkgcmVnaW9uIHBhc3NlZCB0byBLVk1fVERY
X0lOSVRfTUVNX1JFR0lPTiBoYXNuJ3QgYmVlbiBwcmUtDQo+ID4gPiBwb3B1bGF0ZWQ/ICBJZiB3
ZSB3YW50IHRvIG1ha2UgS1ZNX1REWF9JTklUX01FTV9SRUdJT04gd29yayB3aXRoIHRoZXNlIHJl
Z2lvbnMsDQo+ID4gPiB0aGVuIHdlIHN0aWxsIG5lZWQgdG8gZG8gdGhlIHJlYWwgbWFwLiAgT3Ig
d2UgY2FuIG1ha2UgS1ZNX1REWF9JTklUX01FTV9SRUdJT04NCj4gPiA+IHJldHVybiBlcnJvciB3
aGVuIGl0IGZpbmRzIHRoZSByZWdpb24gaGFzbid0IGJlZW4gcHJlLXBvcHVsYXRlZD8NCj4gPiAN
Cj4gPiBSZXR1cm4gYW4gZXJyb3IuICBJIGRvbid0IGxvdmUgdGhlIGlkZWEgb2YgYmxlZWRpbmcg
c28gbWFueSBURFggZGV0YWlscyBpbnRvDQo+ID4gdXNlcnNwYWNlLCBidXQgSSdtIHByZXR0eSBz
dXJlIHRoYXQgc2hpcCBzYWlsZWQgYSBsb25nLCBsb25nIHRpbWUgYWdvLg0KPiANCj4gSW4gdGhp
cyBjYXNlLCBJSVVDIHRoZSBLVk1fTUFQX01FTU9SWSBpb2N0bCgpIHdpbGwgYmUgbWFuZGF0b3J5
IGZvciBURFgNCj4gKHByZXN1bWJseSBhbHNvIFNOUCkgZ3Vlc3RzLCBidXQgX29wdGlvbmFsXyBm
b3Igb3RoZXIgVk1zLiAgTm90IHN1cmUgd2hldGhlcg0KPiB0aGlzIGlzIGlkZWFsLg0KPiANCj4g
QW5kIGp1c3Qgd2FudCB0byBtYWtlIHN1cmUgSSB1bmRlcnN0YW5kIHRoZSBiYWNrZ3JvdW5kIGNv
cnJlY3RseToNCj4gDQo+IFRoZSBLVk1fTUFQX01FTU9SWSBpb2N0bCgpIGlzIHN1cHBvc2VkIHRv
IGJlIGdlbmVyaWMsIGFuZCBpdCBzaG91bGQgYmUgYWJsZSB0bw0KPiBiZSB1c2VkIGJ5IGFueSBW
TSBidXQgbm90IGp1c3QgQ29DbyBWTXMgKGluY2x1ZGluZyBTV19QUk9URUNURUQgb25lcyk/DQo+
IA0KPiBCdXQgaXQgaXMgb25seSBzdXBwb3NlZCB0byBiZSB1c2VkIGJ5IHRoZSBWTXMgd2hpY2gg
dXNlIGd1ZXN0X21lbWZkKCk/ICBCZWNhdXNlDQo+IElJVUMgZm9yIG5vcm1hbCBWTXMgdXNpbmcg
bW1hcCgpIHdlIGFscmVhZHkgaGF2ZSBNQVBfUE9QVUxBVEUgZm9yIHRoaXMgcHVycG9zZS4NCj4g
DQo+IExvb2tpbmcgYXQgWypdLCBpdCBkb2Vzbid0IHNheSB3aGF0IGtpbmQgb2YgVk0gdGhlIHNl
bmRlciB3YXMgdHJ5aW5nIHRvIHVzZS4NCj4gDQo+IFRoZXJlZm9yZSBjYW4gd2UgaW50ZXJwcmV0
IEtWTV9NQVBfTUVNT1JZIGlvY3RsKCkgaXMgZWZmZWN0aXZlbHkgZm9yIENvQ28gVk1zPyANCj4g
U1dfUFJPVEVDVEVEIFZNcyBjYW4gYWxzbyB1c2UgZ3Vlc3RfbWVtZmQoKSwgYnV0IEkgYmVsaWV2
ZSBub2JvZHkgaXMgZ29pbmcgdG8NCj4gdXNlIGl0IHNlcmlvdXNseS4NCj4gDQo+IFsqXSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvNjUyNjJlNjctNzg4NS05NzFhLTg5NmQtYWQ5YzBhNzYw
OTA3QHBvbGl0by5pdC8NCj4gDQo+IA0KDQpIbW0uLiBKdXN0IGFmdGVyIHNlbmRpbmcgSSByZWFs
aXplZCB0aGUgTUFQX1BPUFVMQVRFIG9ubHkgcHJlLXBvcHVsYXRlIHBhZ2UNCnRhYmxlIGF0IGhv
c3Qgc2lkZSwgbm90IEVQVC4uLg0KDQpTbyB0aGUgS1ZNX01BUF9NRU1PUlkgaXMgaW5kZWVkIGNh
biBiZSB1c2VkIGJ5IF9BTExfIFZNcy4gIE15IGJhZCA6LSgNCg==

