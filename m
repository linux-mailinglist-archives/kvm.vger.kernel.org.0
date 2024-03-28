Return-Path: <kvm+bounces-13033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 347BE890833
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 19:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2F3B2992E1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 18:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B39134723;
	Thu, 28 Mar 2024 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UR0bppbp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E026212DDAF;
	Thu, 28 Mar 2024 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711650417; cv=fail; b=YcL0DbvvwTjNyj5C83jUkjbE9E5iWaKcJ9IevoMIsnn16lTSWUyF0rMKsAPPjBD0twhyLP3vMqn8VIW9kH6+aJbXKkz2TVWgsjPBfSKUSQYBFrYMbF4YPMSKWltQXQGwe743dS+0nerZiNLog/Sff2m1EWDdWpm7HUZrv7R4lGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711650417; c=relaxed/simple;
	bh=sY4I/CZv5EA/DJeix9k9CmeoGFVVIE++UbiDBarUV0M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Invj+i3IgYdp+Sad/F+ao46AAfgf3uRoMLx3gQDXUpnJe3E14tIJy+XnJfoatCrAxGKP0uCK1+U+HoGuGFPdCi5vC99WiwDaYEPU6z4utb+oz9yXVCsN3AcvuDv946+g3rxjvUaY4vAyaVR2z5NBKSl+4MArJJxF+5/mTi5CpKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UR0bppbp; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711650415; x=1743186415;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sY4I/CZv5EA/DJeix9k9CmeoGFVVIE++UbiDBarUV0M=;
  b=UR0bppbpzoz2WZeuOcBzG/m13jMhTJ9BxdmOrYP0H+AKODzm2K6F2DGc
   nE29mkacHnZZSv74cSPqwDBMPMmfsROzsroB4qjq0hkqzc9g9YLrwQtAE
   2CgVxMnUqz4LJZjH+56IwMXtTAMgAbmaDy+CE+IvoSSKda1dE6BgGLpBL
   xJWeEbq56gWe5HMcxpPELZtgF7pxl2pwDIwhlFpwzsocmo6fmDYycrKZH
   w6SES4gAeT+rGYj+cfWxqlp7z1QVQGX2jzqBKj5qTVwDX9zz6biSsy3Zi
   pUr4hQKjMncoEf8MOHoH2NrhXKTAj4kFxPJ489Tqguz1vkcrbF4+V8D4r
   g==;
X-CSE-ConnectionGUID: o7TgxPGOQRGNwMThdt5Wrw==
X-CSE-MsgGUID: 1XNQQ1YRRc6AjCjWkWR+pg==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24273037"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24273037"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 11:26:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16762127"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 11:26:54 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 11:26:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 11:26:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 11:26:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 11:26:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XllE/rdC1R3Qb+zec1qDgG6y+IGBMebbZJidXaod2sS5iPHvrso2wrk5Lx5h32L1wq//DDwbcxfZuQp3fM0Ccf7rn18U1enY8+0O5YOIjjYodoks+UgZ4ABqoIB7YawSA6G1WrVp8pqA5TDuA2rqeRH2fgMravGaBLsaOy2w8wx5pU6vTOsHaOXS9jYgUD62dp6AYwCchvbd8+7QIcnGguvtNaHXnpvfym09dxDVUR68xu0GxZEeY1y5G3cmIRUbIcyInAll2qDLT3vbfGKwvmk8Qp2mmigK07eL62yVsYaxK77+DnR5SQ0d4/jFoJQFSY/hpQLrg1vIfFQ/OFXNPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sY4I/CZv5EA/DJeix9k9CmeoGFVVIE++UbiDBarUV0M=;
 b=AqIBlyU8WC5FERW5H6tEk/vtIejHDyoblxROa7YhyBH59UqVR8q/h4WlKLUZW/4CorC14x+WsyFMvJt3echuU4sPuE9BpW5VnO1qhABwxCfDi06Km8UFLDPiSKKnTAFITm/H471zikiUdaB0sNsW87+FKCJCKKZosLeqH9I8ASf6OGtu45DwLgLr8w1ibLMMZ2GHG9Ve6VrZ9OnhK+/bHwbcbInR3ZQPr5Ass+sT/KGHGigz7kxawr2FtoI921+Y2yzvDbifqWV+l8Ifw0u/SXAJ538BXQ1a2s1imE+RkKh2pFHhWwLkTLd4RC3fcrGIYphk+R52P3R4X81e5vD88w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6976.namprd11.prod.outlook.com (2603:10b6:510:223::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 18:26:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 18:26:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHadnqikJftpAPTRECy6a/NFCG2mbFMc7eAgAEaUoA=
Date: Thu, 28 Mar 2024 18:26:50 +0000
Message-ID: <482bd937c52cf79c49f1c666cbc8d28c11af7c4a.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
	 <Zfp+YWzHV0DxVf1+@chao-email>
	 <20240321155513.GL1994522@ls.amr.corp.intel.com>
	 <5470570d804b52dcf24b454d5fdfc2320f735e80.camel@intel.com>
	 <b065cf99-74bc-42d1-95a3-8a0b018218ee@intel.com>
In-Reply-To: <b065cf99-74bc-42d1-95a3-8a0b018218ee@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6976:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AcmbRSuoprMdcCwWpocJ1epFYMUccLbkk3BnIHekuZAN7TVsYZ2doPodLU6lfmMmPLG3+e9/akcT6pmTm4ItZ/oHNPNnRLGaKJOMfBkC5JuU4DMukRhhrILDVPB9QNsPGRdOMuPJSde3hwutGwHg54bQhuMO0C2Xunzah4c8lfuyBQzccHKe/HblR3eMvjr1ayA67HWr4QJXfQhClCmMOzlor/f7oknlYVEHmr/B8VBmpEAavfpntbBAZy6s1mzG5QiIqACalRP06pnaJxPCGBGEixw302GxRd49OQzeH7HqFubN5G8Ubu/1udH5FZ2YEXosiQjbpmBuhe72T5BFxSv+uLwVgOgZFvVdw6+P33lvm+gJnri3LLJiAHV5nqThtqs1zP8n7fecyehND9VhXMBMlhcVEHIAtVsjwchVKpjSuwagYiEA8MYz4IbWaJ/mOp5t6LmhNVno7Bp0KEkv67c5CzNxgLvIdsm92vNLBfshZ3aArckvkb65ryRjVK8Npo0PX5iAFHOMeQR13RhOFTvQSe5ySQ3tYk5ukvjBUMSBNGK0XTZ7u7cvkVrsooZSuXqeqUXsIYY/2nhYUxh7hyhYiG6K94TZtpu1NaCW8OaP/0tl7RzTLpirsEn0Yz05Cdw1w/3Nz5VO8XGEuR2hWH7FxZ589FU0fqvR/9H87qs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjhvSGdDbWtKSmRzTTFZZm5yQzVVV2VSakxydjN6QkxucXdSTDExS0xTemZW?=
 =?utf-8?B?dHc0cHU2NzNYdVB4aURBL1RHdHNWOC9hb2RsZkFNcStFL0dCSDVReU9LdVZF?=
 =?utf-8?B?Q0czM0p6ZklJZXFPVzRSQVAxWDNNbnRvTTVhS2syUkdsOEw2Q21PRGZTUVZ4?=
 =?utf-8?B?ODFadVhjbHo5Z2M5WjRIYVRRbzZ4RUU4ZUpGVXA5UlBYeC9aUUI3LzhiVTdJ?=
 =?utf-8?B?MXFWaUdYNkZFeUxKK3NCNllOdWZCN3ZxNk9wNDQvdURzWE9YR2UzNzZWWjl5?=
 =?utf-8?B?eCtSY3R6a0NaSGYwOE5YWDZuUnYwN3JvMnVCNVVTYjJGaWpXRDlXMnJBTFUx?=
 =?utf-8?B?WnQ1TUI5bWhjVy9UWmdGbkNRUFNoWEVvSm5ENXltQ0hKdFlNbkI3c3hmU1lM?=
 =?utf-8?B?L0YzVnpISHJ2NStIZDN3Kzg2dHpWdUtvRzhVMTJxZG5oOHNUU1lHb3hxaFpK?=
 =?utf-8?B?VlBWYzVOcjhVRDF2SDJrMWtUOWxKVHdHZjZiZ2psUmJSdzBTQzBkYVBkK2xZ?=
 =?utf-8?B?d1hMOEhLemxVUVhHMHNCNHNnenFtQlpuTVQySzhuVEZ3K1h5NThIWU1yd1ZI?=
 =?utf-8?B?VFUyNVRNZE1BQ2pZOUE0QWVoYmJMYk1BR0F3akVNaUg0YTJIeWVPamxoNlFu?=
 =?utf-8?B?UDdoZjdBSENwWXU5NjFNME41aWhiaTlxcUlBZGNBRTN1eDdjVlVOQVAxb1p0?=
 =?utf-8?B?SldqN2t3VDZkQ0J3ck9tTzNZOG15SUxpOVB3QW9LNXhrcjRtbmJ3bkhwSWdK?=
 =?utf-8?B?U0JHaUg5RnBzNXlMRDhrbWl6OXo4TENZQVNGVGRhekNreEhFUCtlRXU5OVk4?=
 =?utf-8?B?N1J1eXBQSGpYdkNWK1VIRUJxUlN1aUlTSnZWV0RZQUNQSEdqYjJQN3dkMHNj?=
 =?utf-8?B?dkdZSXVNNTRaVkRzdFVOU2lUV3l0aWlvMEtqUkRaVkFzNi81UFZEdGJHY3Ax?=
 =?utf-8?B?ZW0zYnhVM3FCVlR4Rnk0N2VGcXAyWXp1U3Z5WGhuRlNDSE9INDllYjFzTm9F?=
 =?utf-8?B?UFB6WlVQS1hWckY4V2xUaUV1dlRCVHExN3NleDgxQjVqR1dxOEhEVHpCK0c5?=
 =?utf-8?B?SGplcWRXbXpXT01KOE5OMEdFZjllaWdRNnIxY0FVMW92K1ZLalhPbURtUGxp?=
 =?utf-8?B?WjBJVXpuNTk0ZElvMk5OTE4xQkxHbCtEVFE0WmV5UVJLYnhTT3RNRWJqc21P?=
 =?utf-8?B?Z1RSdjhlOXpkbGpvbW5OT2hMSkFUL1hmRFI1dlRZcnBTeG54Z3dzKythZ2JJ?=
 =?utf-8?B?elFWbUIzM1B4QkhGUUFPMkhQcnBCRmU2amdIV25idzJNNkFwU2h4cUNYTVZL?=
 =?utf-8?B?SEpybHJ0aDVONTJBZXdqSkZSWFJITG5WSVhnOUY3YlZFZXc1QWZmalRkWUxa?=
 =?utf-8?B?S2FZOU9WREg3QlB5aGxvVFlua0RRWHIrY2dHZDVZN0hDTWNJRmlTekVYSnlY?=
 =?utf-8?B?Z0E2YVptMU9NUmpiekFZYTNzbmdNTitKUjJ1RE04UmlhMWJ0U1ZhVHJFV0NZ?=
 =?utf-8?B?TjdFcUZBcm5waHMyUVdnU0dJMGdrdjNGRmZsWnV0S2U2NFUvRDIyTHFsdWZS?=
 =?utf-8?B?UEhZVzB1RkxZTmU0clNoa285Mm1FMlQrWlZndExYaDIwZWU1VDE1ZHpKd1hp?=
 =?utf-8?B?QmtUN3RQazVQRTlHRkx1MjdlZTlhTUlhb0JaSUlFMkF3WUZ4YnExQmtWVFc0?=
 =?utf-8?B?Z0dXcVk5S0RtRk83UTdRdHZodXhYZ3dnQjNRNnppTFlkR0NEL1hHcmJhYU1l?=
 =?utf-8?B?K3YwTXVGNS9uaUxLT1FudGhzQzhTMm1nV0kreFozK0hzVVp1MXhoV0U0SHpp?=
 =?utf-8?B?TnhxN3dkRW9Oc2RJU3ZZK1lneWwrSkNzRVdmNmhVemdVSldQRWxLUUk2eDJP?=
 =?utf-8?B?WEt5a2t0Y05xekNlYUk3Y2tFam81UUpOaVh3cFJjTVFoK3dUYUowenY5dkFv?=
 =?utf-8?B?U1VWcHRDNEtXQ0VSQU5lOVgxanNvTVRRV3JuS2dxVWZuRmkybmRkYmg0aXFn?=
 =?utf-8?B?UUt6TERYSngvOG1oaEV2d29mQ3haMDFGSjhaU1JTVmFVbnVob2Nuc1hFeU9U?=
 =?utf-8?B?VzRDSDRxNSs5UnYxY21vMXBVTlM0SDRFbWVFb3VCT3FPbkRHRWhCZlJqc2JV?=
 =?utf-8?B?bldKcUJhaWl0M1RyZVlQUzZSZHFiZEF6RmVGazBTdGdHYVlYa1poL0VoSVJY?=
 =?utf-8?Q?GrfHDVvzoToz/kpShSDt/4w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <557C22B1CF8D6F45BA6B283C78A216CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b07678f-d74a-4e26-ffc7-08dc4f54a2c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 18:26:50.5948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 63X6YYGxrbj/qBa0LMcj52QRkh+9V3QA/QIXegew6gKJVE9GgfHRnTI0A3BD8TSDaMEkjz1S6sYZqgoxGzEs8uy+KEd9MA2D5RhbhjbTnxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6976
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTI4IGF0IDA5OjM2ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
ID4gPiBBbnkgcmVhc29uIHRvIG1hc2sgb2ZmIG5vbi1jb25maWd1cmFibGUgYml0cyByYXRoZXIg
dGhhbiByZXR1cm4gYW4gZXJyb3I/IHRoaXMNCj4gPiA+ID4gaXMgbWlzbGVhZGluZyB0byB1c2Vy
c3BhY2UgYmVjYXVzZSBndWVzdCBzZWVzIHRoZSB2YWx1ZXMgZW11bGF0ZWQgYnkgVERYIG1vZHVs
ZQ0KPiA+ID4gPiBpbnN0ZWFkIG9mIHRoZSB2YWx1ZXMgcGFzc2VkIGZyb20gdXNlcnNwYWNlIChp
LmUuLCB0aGUgcmVxdWVzdCBmcm9tIHVzZXJzcGFjZQ0KPiA+ID4gPiBpc24ndCBkb25lIGJ1dCB0
aGVyZSBpcyBubyBpbmRpY2F0aW9uIG9mIHRoYXQgdG8gdXNlcnNwYWNlKS4NCj4gPiA+IA0KPiA+
ID4gT2ssIEknbGwgZWxpbWluYXRlIHRoZW0uwqAgSWYgdXNlciBzcGFjZSBwYXNzZXMgd3Jvbmcg
Y3B1aWRzLCBURFggbW9kdWxlIHdpbGwNCj4gPiA+IHJldHVybiBlcnJvci4gSSdsbCBsZWF2ZSB0
aGUgZXJyb3IgY2hlY2sgdG8gdGhlIFREWCBtb2R1bGUuDQo+ID4gDQo+ID4gSSB3YXMganVzdCBs
b29raW5nIGF0IHRoaXMuIEFncmVlZC4gSXQgYnJlYWtzIHRoZSBzZWxmdGVzdHMgdGhvdWdoLg0K
PiANCj4gSWYgYWxsIHlvdSBwcmVmZXIgdG8gZ28gdGhpcyBkaXJlY3Rpb24sIHRoZW4gcGxlYXNl
IHVwZGF0ZSB0aGUgZXJyb3IgDQo+IGhhbmRsaW5nIG9mIHRoaXMgc3BlY2lmaWMgU0VBTUNBTEwu
DQoNCldoYXQgZG8geW91IG1lYW4gYnkgU0VBTUNBTEwsIFRESF9NTkdfSU5JVD8gQ2FuIHlvdSBi
ZSBtb3JlIHNwZWNpZmljPw0K

