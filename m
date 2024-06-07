Return-Path: <kvm+bounces-19092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07843900CB7
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 22:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E0231C21210
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 20:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D3314D45B;
	Fri,  7 Jun 2024 20:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xcf1QyvS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BA8143756;
	Fri,  7 Jun 2024 20:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717790810; cv=fail; b=VlkYk7en+HWpR4fUm4Ft9gsM45qEAAIKu+A3qcnQJtNZK7XvvHPZVM3EEPJgxkCSfclvAjnIdvwYaayUYZ0e66Gkw/3u4OU/Ic2khH9ahwBZTsMgb2C85yIx9ztJOrHFga71n5Y6FV5j3a03ObTnb2Axk1aFNGPkoRo9aZ3Az8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717790810; c=relaxed/simple;
	bh=6R0ogLnYtAth5Wtxf+9SF0ixt/ny0mIzgpqX7oPTlgU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hlotd96Nhcg+fdvHcYmAF0N7URNiuYfn5Xsg2wf2qHqsvc1Eyu4ifXi217/cor3PwC7YOMxjTqnR72dH1MA8IxFMmB0z0Kh4HgwRa9aXNrKjVss76ai/UV6A0EnOrHMLyQYpppnZmR/F73ijA7yzT18f8oHSfVDjg/O03rxmjR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xcf1QyvS; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717790808; x=1749326808;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6R0ogLnYtAth5Wtxf+9SF0ixt/ny0mIzgpqX7oPTlgU=;
  b=Xcf1QyvSQSFTpS3l/cDZErR5BQ5XDxvsG1EDDYWNyjvfOYcZ/CZJfcqg
   UvUHu0t3oz+sQCZLjmWSPegvQybTCmzz6sbial5ad9nFf8g41I62ZnXyA
   HwaTUVMM16zWF7o4Z/ki+EQHHJHkL0cWylfXy5GEZzmX6OsMkQE1vl7Fl
   7lCEtCkQtA6rCRc/BHA8lGyqEMs1YEZwnOGSnEbffa+pR1iW/+M+3ld28
   FdepqiOIMKq3mlRANqE2pcFDNmwCjm2GcUD180hT9ou8C0r3sW6rc7s11
   +ca+ecN+OsncV45imclDbeCovejsUcM1JIORCvc89D5F5jyP7K8JZru3F
   w==;
X-CSE-ConnectionGUID: wmrLf3veQgiKbM/rEhHc1A==
X-CSE-MsgGUID: SmXBDcD4Rn2FERahlv+dFQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14269634"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14269634"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 13:06:48 -0700
X-CSE-ConnectionGUID: wMevPxVrR8OetYW90yPc9A==
X-CSE-MsgGUID: pMq/QeCCSkmGRQzsnfsGLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="69205198"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 13:06:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 13:06:46 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 13:06:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 13:06:46 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 13:06:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8s1jtJNumpGME5T6Ot/5nRlx/qSO+OZ00NNunYSlKY25KOktyL+qcDa/yiLU+qAPu/3QT796GjlCCil6KkHSqKwGUTl95gzCeTG/NhCmWusqux0nZBFSLeK92lqBbCk+ctZFiepoDlND8df465N8pAsVcagvQnGEo4j+M7llQSk8tSOEZRSWIA0XjYNb+155S36b7KMRliClmmOrCLSthpB5qisygtedeeuuMgulrsiTa8lpSV50m+NRlOBb6GxmO9EEK+pXRlKQo0Q5+mXOTVoKSdaH4Ji5wLrlMwDRtmBRhJZ0nvDC2NdMb5B4QUcyhbjDnpo5UMU9XiBIEaNiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6R0ogLnYtAth5Wtxf+9SF0ixt/ny0mIzgpqX7oPTlgU=;
 b=juLLMBrM/65aJXoOLi6icFlY5yj+ha0bOSXTFmxnfWKko8KFsqxe1vdaEw2kq48Jo/b1y4IBTs46SVgq7KFNU5c2Ugy3jQTxjtQW7aW/05mvQG2K9h25AklR8QmDxan1F/gfoCP8o493A5fwqwTsZ7Uxm4txgb7jZgXyXQ0zDi3LO/kUdBJkppCrYgN7P+n7US2tCQLoImWqG/GZzgJEDx6Pj0FoAJkjN66iXEbFiDdw+GNYy7ICnKbRvIv6Hvh+z+R93I3Yw8II+6kMs1XMfVhShdNNyk84m71oNDvaTH3PrdQms5BqTc5JXYX9m8m045vusBf+mM8o4X1kslw4KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5173.namprd11.prod.outlook.com (2603:10b6:510:39::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.35; Fri, 7 Jun
 2024 20:06:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 20:06:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 08/15] KVM: x86/tdp_mmu: Introduce KVM MMU root types
 to specify page table type
Thread-Topic: [PATCH v2 08/15] KVM: x86/tdp_mmu: Introduce KVM MMU root types
 to specify page table type
Thread-Index: AQHastVqGgCafwg8REiM3P50709K9LG7/qUAgADIHIA=
Date: Fri, 7 Jun 2024 20:06:42 +0000
Message-ID: <628dcac82f5b1113d50b9d59ef58267f744ec867.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-9-rick.p.edgecombe@intel.com>
	 <CABgObfZr_YNcymua7ejapiL0+M=0CQhroheerj-1_YYxisp=Ug@mail.gmail.com>
In-Reply-To: <CABgObfZr_YNcymua7ejapiL0+M=0CQhroheerj-1_YYxisp=Ug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5173:EE_
x-ms-office365-filtering-correlation-id: 49c264c0-94a7-4b8b-1771-08dc872d59a7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?b2Jkb3VLRzMwQkRReHBzYjRzTlUxeW4zYjVaNUVKak95VmV1YXAzVjZLTnc4?=
 =?utf-8?B?eFJtb1dESzJJTStVQ21uVm9HRlZqMW1OSERUeTY5SEVycnoyaDZsejFxdkJx?=
 =?utf-8?B?OGh4cUJSVGR1QXRoOWlpc1MvRXNhQkRmeGl1KzMzWHZCemVBOE1YZ2JLK3Nw?=
 =?utf-8?B?dTVqekhmVUdyOU1nTmt6WHJkdVkwNW45OExWU3dUTnJ0N1IrTjREaE5ocGJ6?=
 =?utf-8?B?WlFXS3lQeW5tQnplcDJxTHFvcWtCc2dKU3BoaE52R0dPeUZ3SjZjZzRoNXRD?=
 =?utf-8?B?QnB3MWl1OWkwalZoRU5xMkxUQkRSdTVpTkVHQnZnMHk4ckc4YkU1bjR0bFQw?=
 =?utf-8?B?OVMrMERPSDJmdGNDMGprYXI0K3FHaUI4bTNERDZsdVc4RU04Zkg0UkhOTGdC?=
 =?utf-8?B?VTcwd2VkUEcwN0JzTW1lMUFtMHZJa25DRkpCOFFpUGVNTjF6UEdpSVdtT0NU?=
 =?utf-8?B?MlQyVytrbi94ZTVFV2ZrLzU2RFp0THlIazFJUGsyT0gwRU1yNk5qZXhYNE50?=
 =?utf-8?B?czJwYmpYZk14TGp0dEEvS1g2cWZ1MDNMK0Z5aWlieFFQcGZPNFIxRktUNGVq?=
 =?utf-8?B?TE53VG05aXpKa1NlOHZLa3BuS09tcnY0NHZmUWk5bUV6WW8ybUxSaUVIc1B5?=
 =?utf-8?B?S1lOMlQwT3FLSzJtWmNqdVlDVzZhaGtIcUF1WnpzNllQdldNejdHd2VJeGlX?=
 =?utf-8?B?a1ZhSmp6QWZWVDI4YXkrMXk1VzFSWW1QWmx4OC9UUnJRRVVnSEJqWDVUNWpa?=
 =?utf-8?B?bmVZMmFrbHZHSFV0d1ZwVGRaSzRmTTFaWVgzOFlDbTQwd2kvcUFsQitaYUZZ?=
 =?utf-8?B?UmVqdndTNHI3UmRzaHQyQWdYUmNsSTVENmh2YmpsdjBHRmIycmVOQk5uV3Rk?=
 =?utf-8?B?b1Rtd1ZqQm5lanJXV0Y5NGxWdGl3dzRlbjdBOGsvZEUxbWV0ZnBpdFJzZHVM?=
 =?utf-8?B?NGFRdThsNXAzNXByLzg5TVpzcnZjV2w0cXgzOTlWT1Vjb2NBcG5KTnErUE12?=
 =?utf-8?B?MnM0Q3pUQXMydWdXNkxLRXZWMis1YlJkK1NpOFQzTEgweG15VEJ0MTNsQkhh?=
 =?utf-8?B?Q1Nxckg2TDJnOFNWRy9zL3VBbUlodlcyVHcwZ2VRQitPTjlBYTdBcUR3VWhj?=
 =?utf-8?B?eUNiNWtJQjJ6R1FDRVIrMlMrSTN6WVhDa2dnNEU4VVIySmhscVJFY0xzY04y?=
 =?utf-8?B?VXZ1MG11OEQreEdDUGRsN0l4alZGN2U4a0x6Um1EdENHSkpxVDNjS0N5N2hr?=
 =?utf-8?B?UlliTzBqTlk0Ky9Ydk92Y3QwZ2tHcUl5NDZocDJsV2pCRFNTb1lXQW5yYmpB?=
 =?utf-8?B?cG5La201eFByZ2RIclJScGVpMTkvcXFrWE5ZUUlNTWpiNndRNlNYSWVITlJa?=
 =?utf-8?B?THBwOWFOS2lNb2tFQzZ5UUgyOE93cWtseEVsTzJtcDhTUGg1WGxKM2lpVWRo?=
 =?utf-8?B?Q3JRVERnbjB2ZXhWaTlQTmI4K2ZMZFArVFpTNXJHUEh1N3grbXBZWTFadk5i?=
 =?utf-8?B?Zi9Ia2hxVUc1V0xUcm5Vcnp0Q1IyY2M5QmpkbjNHcE5ONjJYYW9LRzBZaTNr?=
 =?utf-8?B?ZUJMWWhzd1N4TzFXVkp6YnBlRitjeS9UbXlEd3A0cUN0b2pLS1JIMHZkMGM1?=
 =?utf-8?B?L0tMTEE5d0FVOCtSTGE1MTBxLy9iQ0E3cGw3RjZ6KzliOXd3ZVNkdS84aS84?=
 =?utf-8?B?UndYVXVTR21EL2haU1VNV3I4UDlnSWNZU2lVYWlaR3FSZDVRUnVoNXN4VHJy?=
 =?utf-8?B?bUhQcGI4R0lySXdTM0E1SGp1ejhpVjdwYjVTenZHWG9aemtLZHZnd1FtNXNB?=
 =?utf-8?Q?LFNK6EAzG/Ufme8bLgVNV7O7IGkELAgu114Lg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlhNeWVSSlJyTjBBR2gvYXN1TjhUdlI0cUkremRxQkhIRlE4NjRDbVJwRmRS?=
 =?utf-8?B?ZHROTUlaZEhCZXVEcmxENG12a2JMRjZMN2hvU3dGSnltNGtQTjFuUVdvbTJT?=
 =?utf-8?B?ZVkwUGFWZ01zV1dSUjlHbEZtbk1POEIrRHlSN1FIcVBqZ3l5Sm9jRXB3bUJr?=
 =?utf-8?B?OStLZzNVQnVFR3pReXJHVEdBL2lIVDNIVUxJYXFRdFRhaytsWm8xcUUxazJu?=
 =?utf-8?B?TXowNmIzUWZUZzhmdWF6YnIvNGlzUlFxNndOOXhwdEpIU0VkWWdPSkhVd2pm?=
 =?utf-8?B?R0hBc0RlNHYzTFVoVTI4b0xCSEZETlJrQ2dKNjBOUWxsd0RTeStsdEl0ZzB4?=
 =?utf-8?B?bHcxNndYd1RyeTNmN08wZ0V0MERnZGpKKzhsZlBaZTk2NnFWdExGcnp0L3RO?=
 =?utf-8?B?VTJtUXI2b2RJWUVMM3lIV0hlVlVpQ0pSYURXU3FHc29PWWdhMGF3ekkzU2Ra?=
 =?utf-8?B?NHl5T1gyUVEzK0lCb214QnhCTzRnMnZBSy9NMUdzbTl3bitab3ZoOWJEZzFh?=
 =?utf-8?B?SEFhR095VTBaNXRBNTZacnkxQitISkl3MlBXbTkxak1jZ1RNVERNdk5iaEd6?=
 =?utf-8?B?dU9HVDU3cXNmNFFUYlFRVzRPNE1TUGRpOUN3eVZieXQyRnhiOWs4OXgraDF5?=
 =?utf-8?B?TWg2UHFxZ0djejR6N3VVSFJSL2VJWkFXMHlqaUJPT1NObWw4bmVZSXpYZ0Iv?=
 =?utf-8?B?SHJTMWxtTHZ3cXRGemxNL1BhVitMaHRxVnN6WWxNN0NoSTJmMU1ZZkZSZnRw?=
 =?utf-8?B?aERxNTlSSlJiZ3VaTGE1ZllKZk02aTNwZ2c2OGZtRFYwLzc4enBEVTN5Q25H?=
 =?utf-8?B?NmVXbXRWWm0xT0FTaEtiS2h4Y05qK0YxOGxYZXoySlZKUVVES2xOcVFCejFO?=
 =?utf-8?B?bWdlMFZGQSt5Tm1tV3B6NWJycnlFK25oNjhLaTBJOTlQb1dHdWNkUkc3aTZ2?=
 =?utf-8?B?bGVrdTh6ajNxSUNJaGRMUGhPU0N2cW1pWkRTNDhyV1B2SDRSanZUYS9raTZh?=
 =?utf-8?B?TWpZQ3FhaFcxb1dsa3IvWWROZlpKUGtRaGI3RHZPNWF3cEVNLzJEaWFpWEJM?=
 =?utf-8?B?NVNVejRTcDN5N0FQWkt0VEhnM2YyTVdsUmpTWkl1aFR4TVk1WTBUU2pVd1Ex?=
 =?utf-8?B?eFFFQWtvdzltRCsrNlppQjlDdFFmZHpmbHlZSHJpR1VXOWdDQklaSitRRC9h?=
 =?utf-8?B?TTRML21XMk1WVHR6RjF6SmoyYmRmbHFqaEJIUzFnT2JtYWt6TkV0VGl2aHhS?=
 =?utf-8?B?aFdLSytuODBvQW1ZVnh4RWNLQnhRTEVhWmFhQ0FqbGwvMHJCdkk2K1UybHpR?=
 =?utf-8?B?Vmx2eTZyVmlWd1pXZnVCRGhHRkF4Unk5SDJsdW1jZEw3YXMrS01NMzFwVUpw?=
 =?utf-8?B?QXZWTlNPaklmaHRsdlJNV0h0eEdYdWFEeWVEYkpEWEVqSHpDOE44dTNtVU45?=
 =?utf-8?B?NVhOYis3VjU3OFZ0MmdFeHljMlU0Uk5zN0sxYWlRQTRlcVhXUjZsTmRNTUY1?=
 =?utf-8?B?WjFBSHNHZkRRanBxN0Zrd2YyTU5ROEFTeVJwL2w4WEVPU0lNSGFnbTFpMnUy?=
 =?utf-8?B?Ry9Ta2VINXcvQzdYYkwzWUZLVGNWVzhHSWZqdU1YSnNYdHkrcFJZczFkYk5K?=
 =?utf-8?B?STR2UEFxRnhMTExxOVRBV2VhVHdiQTZTWWVaR3Z4L243Smo5V3FQUEhJZlNa?=
 =?utf-8?B?aXRhQ1pBeE5RQU9keGNycU5mclBLYzVWdXFqNGx3cHpseHJ2NG5wMTJSNFh4?=
 =?utf-8?B?WC9jY3VVVEk5ZE9Jb21QdmpQV0dkT25qRWg0ajBSOUx4K2dYS2NLMTRkZEJy?=
 =?utf-8?B?cE96aXZremlYTnlxYnZQUHZudVpvblVzektLTzFQZkZqQ25Nb0ZtNklPNmhy?=
 =?utf-8?B?YWZMTzYvMXBIMFB5ZWFzeGdWN2dlQllMZXcvRG80bXJjbUVQY3J2c0RBSFNh?=
 =?utf-8?B?UHhrdlJSNTlXWGk4MDdHVGswd1FZS0lJbWpLQVZQTUFOUnR5U1FNY3VNN2la?=
 =?utf-8?B?RXRLSjZWNGMwbktibHlUK2VlZ1pvUndVNWpoY3MrRENpRTN3OGV4YTZOTm5R?=
 =?utf-8?B?ak1kTnNlMEN0TG51eWNvQjYvTTA5YnpJa3UvQXdadllMZkFEd09ZS0w1TzQ4?=
 =?utf-8?B?bnRjanhWREt1a2JEZ3ZUOHFnQU5wbGN1bDRZb2FaaDBWaU9ZUXhzUERnQlcv?=
 =?utf-8?B?Z2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3793871440DE70478EFFB6430965E5DE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c264c0-94a7-4b8b-1771-08dc872d59a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 20:06:42.6786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4QYVG2eIvyyJnS1cKQJGNyFV4M2So3e5eFkVuSeRFFJq0r61wKW/oGOEpL/rqQHXlFKNdIiWhXfLQvLcNluj/scNrFgghcLIlxL02+matjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5173
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDEwOjEwICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiBUaHUsIE1heSAzMCwgMjAyNCBhdCAxMTowN+KAr1BNIFJpY2sgRWRnZWNvbWJlDQo+IDxy
aWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gK2VudW0ga3ZtX3RkcF9tbXVf
cm9vdF90eXBlcyB7DQo+ID4gK8KgwqDCoMKgwqDCoCBLVk1fVkFMSURfUk9PVFMgPSBCSVQoMCks
DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqAgS1ZNX0FOWV9ST09UUyA9IDAsDQo+ID4gK8KgwqDC
oMKgwqDCoCBLVk1fQU5ZX1ZBTElEX1JPT1RTID0gS1ZNX1ZBTElEX1JPT1RTLA0KPiANCj4gSSB3
b3VsZCBpbnN0ZWFkIGRlZmluZSBpdCBhcw0KPiANCj4gwqDCoMKgIEtWTV9JTlZBTElEX1JPT1RT
ID0gQklUKDApLA0KPiDCoMKgwqAgS1ZNX1ZBTElEX1JPT1RTID0gQklUKDEpLA0KPiDCoMKgwqAg
S1ZNX0FMTF9ST09UUyA9IEtWTV9WQUxJRF9ST09UUyB8IEtWTV9JTlZBTElEX1JPT1RTLA0KPiAN
Cj4gYW5kIHRoZW4NCj4gDQo+IMKgIGlmIChyb290LT5yb2xlLmludmFsaWQpDQo+IMKgwqDCoCBy
ZXR1cm4gdHlwZXMgJiBLVk1fSU5WQUxJRF9ST09UUzsNCj4gwqAgZWxzZQ0KPiDCoMKgwqAgcmV0
dXJuIHR5cGVzICYgS1ZNX1ZBTElEX1JPT1RTOw0KPiANCj4gVGhlbiBpbiB0aGUgbmV4dCBwYXRj
aCB5b3UgY2FuIGRvDQo+IA0KPiDCoMKgwqDCoCBLVk1fSU5WQUxJRF9ST09UUyA9IEJJVCgwKSwN
Cj4gLcKgwqDCoCBLVk1fVkFMSURfUk9PVFMgPSBCSVQoMSksDQo+ICvCoMKgIEtWTV9ESVJFQ1Rf
Uk9PVFMgPSBCSVQoMSksDQo+ICvCoMKgIEtWTV9NSVJST1JfUk9PVFMgPSBCSVQoMiksDQo+ICvC
oMKgIEtWTV9WQUxJRF9ST09UUyA9IEtWTV9ESVJFQ1RfUk9PVFMgfCBLVk1fTUlSUk9SX1JPT1RT
LA0KPiDCoMKgwqDCoCBLVk1fQUxMX1JPT1RTID0gS1ZNX1ZBTElEX1JPT1RTIHwgS1ZNX0lOVkFM
SURfUk9PVFMsDQo+IA0KPiBhbmQgbGlrZXdpc2UNCj4gDQo+IMKgIGlmIChyb290LT5yb2xlLmlu
dmFsaWQpDQo+IMKgwqDCoCByZXR1cm4gdHlwZXMgJiBLVk1fSU5WQUxJRF9ST09UUzsNCj4gwqAg
ZWxzZSBpZiAobGlrZWx5KCFpc19taXJyb3Jfc3Aocm9vdCkpKQ0KPiDCoMKgwqAgcmV0dXJuIHR5
cGVzICYgS1ZNX0RJUkVDVF9ST09UUzsNCj4gwqAgZWxzZQ0KPiDCoMKgwqAgcmV0dXJuIHR5cGVz
ICYgS1ZNX01JUlJPUl9ST09UUzsNCj4gDQo+IFRoaXMgcmVtb3ZlcyB0aGUgbmVlZCBmb3IgS1ZN
X0FOWV9WQUxJRF9ST09UUyAoYnR3IEkgZG9uJ3Qga25vdyBpZg0KPiBpdCdzIG1lLCBidXQgQUxM
IHNvdW5kcyBtb3JlIGdyYW1tYXRpY2FsIHRoYW4gQU5ZIGluIHRoaXMgY29udGV4dCkuIFNvDQo+
IHRoZSByZXN1bHRpbmcgY29kZSBzaG91bGQgYmUgYSBiaXQgY2xlYXJlci4NCj4gDQo+IEFwYXJ0
IGZyb20gdGhpcyBzbWFsbCB0d2VhaywgdGhlIG92ZXJhbGwgaWRlYSBpcyByZWFsbHkgZ29vZC4N
Cg0KWWVzLCB0aGlzIG1ha2VzIG1vcmUgc2Vuc2UuIFRoYW5rcy4NCg==

