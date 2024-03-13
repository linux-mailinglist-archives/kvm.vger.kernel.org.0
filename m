Return-Path: <kvm+bounces-11707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 275DB87A035
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 01:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A140D1F21C19
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 00:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11D28C1E;
	Wed, 13 Mar 2024 00:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PHapQLgm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68A96107;
	Wed, 13 Mar 2024 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710290664; cv=fail; b=ULacrC1DjnesOSGrL1yqkgpIbyeZ/XudqB+B6RcfhcDQIGuWZPbrKwoao/HlPUNWiVf/pKBsYKDmzByKC5YOMqUbBvM8+2+fL98vLQnB4GsBYRkcbl9NpiytJr5WHlx9qpIpwtyTSGLvJ9MmetKReIecpCmdccrF1fYeGdyyq7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710290664; c=relaxed/simple;
	bh=MyLPTAdICsHUyf2ZpNAr3Tf4wZ5SoP/73UyTCAo8Je4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e6x7Go4adM37WyFBD09HezGCgKLKagMKdcbQr7/mu7YclZ9cS7A3qOGej39rUuRLhkRYXlUvgJ4ACwuW83PcmzS2AoUPodnIr2AdLDTa9yv8CezlCIGL0lf3v715C/YtXwtoMGGsjmTvFoCYbSLApDICEylCfwknf/GmFyEff1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PHapQLgm; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710290662; x=1741826662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MyLPTAdICsHUyf2ZpNAr3Tf4wZ5SoP/73UyTCAo8Je4=;
  b=PHapQLgmJD4p7t4guJlKv28hW4OtszWWVH4tWXPUm6mQPXkHvXc8bU5c
   5DLzIhkS9yUOGBE9Ftvj+3VZVO1Vg8H5w1yjSbSe24UePVS7sqCqGLdPJ
   JnAthJUBWxuK3pNu+vlMQOrFzQliaUogVkppLjtqYUmMpnqPG/yT61t/H
   na0s0IPok0PU+b0CVSNOrk3xdYtSZh3Yvsflefa6QbSxetrP5YEgmizpU
   EcpwwRQW99yC/ckJBtBa82+aUcAFKPViaCRHiyO4wpXo6FfI273POGX5m
   Bcqja/Asavkljm1BLAXbIkn7lftJgsbs0fHrfRaiexkI8iHDzIwgo0Kge
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="4881983"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="4881983"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 17:44:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="11657088"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Mar 2024 17:44:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 17:44:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Mar 2024 17:44:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Mar 2024 17:44:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfHQlRTGNkkIxEUtw9b3jpuL4h6sGWEgUrsoCXh7uQS7W6biXFFQFIf/MTt5rbpP/FH3utitDzjD0x6gkgmqU38pvhyHJ8g9fk5wVwXodRc7TRamZqdRZ8nDGqeu6ywBevC/8cNCjetPfT6iDngXCaUAtDhDMGICkLqaJDFm+KhTU3higxxQ1XH6PjBew3S21ZogqYpQmpC6sCsjlaMWzqemcW1YgvGU7FFjmAP/J9bfnRV0cERyGfyE2ypoqv51r4s7QwMaY2puBjaJLo8FDwi4q53axZxx3ajIRAGuKr9Qd7aL0tN5KlTmCHlaBKBv1JjzHLpOaY00N738WG86aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MyLPTAdICsHUyf2ZpNAr3Tf4wZ5SoP/73UyTCAo8Je4=;
 b=XIcSMluWWFThYc5ulkNJFTgorNS0//A3QQqdnPMS0Vvk7UdqHaRuBT3KX0/N1ValSmCmzLdZFhYMhHH991sRBD2+KPZX8QUlSeUbFAd1DbajaEpYKeB6miPok60AiDg1gUIu+m0fUaoGirZoVxDk5E7kUUik+9Y4FoBapN6cbE6iqIbqSIfZtsPkU9hWfktT4dWRyqp6OOOdRqY3MVctGPovEfn4CSZfbbYcgOLUKxeg1nM1p7QgW0BvmXFXki0nfPm7FkQ4nbYUAn+OXjbJ4L9GXWFAYREf0k8HBTqrR9/6YgIUVNTZvUEO3WIv06yOS4c2IeV3uKBK0cObf0B1xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PR11MB8671.namprd11.prod.outlook.com (2603:10b6:0:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Wed, 13 Mar
 2024 00:44:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::fc9e:b72f:eeb5:6c7b]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::fc9e:b72f:eeb5:6c7b%5]) with mapi id 15.20.7386.016; Wed, 13 Mar 2024
 00:44:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 032/130] KVM: TDX: Add helper functions to
 allocate/free TDX private host key id
Thread-Topic: [PATCH v19 032/130] KVM: TDX: Add helper functions to
 allocate/free TDX private host key id
Thread-Index: AQHadN+SqbEZXqxiWEOvGy+2Xmjg2A==
Date: Wed, 13 Mar 2024 00:44:14 +0000
Message-ID: <075322c9db65e2fa19d809357a98fe6067c80508.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <7348e22ba8d0eeab7ba093f3e83bfa7ee4da1928.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <7348e22ba8d0eeab7ba093f3e83bfa7ee4da1928.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PR11MB8671:EE_
x-ms-office365-filtering-correlation-id: c26a00c1-0a65-4905-cdd9-08dc42f6b518
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SSKj8p885U4W9BW5SVjYjLOBbnIT0QCBPUDa76IYBDSOhuaoKj28rx9Folw3f/V+SluEjgkQH4thPg3Bkw9Cs0HuMI3GP09StgAySZ6FGVOCckBEypOMWasm1Yp0urwV7ZMHrfsUyudDezmIdr9G8lW1RIaLcWA+B4cUmF1pehEcJIAePmlOpEoBJDFwWepeDxQSOVlCghQn1AIXEWQoL0vzO/ESkxog3/H2MjlbNCRajquM8MSa97Zvemuok8t+0jkdHrla98LPtZpCCMLmuGzda+yE5ujRkn6KE5gL4JwUjBMrRtBbsLK7QnvVxIk4iEp/Z74I0UFqYaOcOpwBfpqObJEdNfPALTD3mh+2MnlAWsVsrhpWf4/OQh5Ebnhr8HoSfPLDrco7BUv7I+K5piEyAsNFO7qKPd6Lc64bI0G8nAvNtFEKoIwmbag2/QIyAUsf2asBGdJNw8P9RJFwjS7iN43fGZ7rI8HH1MuZX3ajd6+23bBDEgbVAKSbL7gSUsI22nCO+HZIT6Zo5J1Dx6CY+JndG0Q5fib1+2MwDN+gKrjRCuNxcwHBzipgBb/pzrv1UELs1ROuAeylcnGYEGlq9RSWFnBj1/wlVKkDiqcfCGLPUe50i/TRS/qde8Y0N/2bKI5rnkvVi8XwPjXQmJjoNkRnWDhLdnM4dS+x0KCupp7h+X/v8vggENqq3Fpm176iVJ6gP2eo0sb84tX1IQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk9OUzJLd2dJSlFzTTRRWlZPM25TRlFJV2ZhRG1vMmxENGdlTHNOUHJ2bHpN?=
 =?utf-8?B?WFlzV2puZHh6SEF4NFgyN1BCZFJUNFdHUmhxSFBUU1FqWVFSL0lnanMrakJN?=
 =?utf-8?B?VkZYZDMrUzluZDFMcDJ0RmI0YVRGc2k0MS8ya25iY3BmblZmQlV2Vy9JU1hs?=
 =?utf-8?B?NjVnWjdzT0pscEFneFFES3R0ZElGdktvMExveWUxYnhhOW44amJ0V2JITW1o?=
 =?utf-8?B?SGc1SEFXSmdSVVprS1UxOFV4TXVPOWgrQ3pEMUk2SGFyRnJHMDhUSUJZY0V5?=
 =?utf-8?B?aWNFbllGbW1iZE40YWFPUFZ1Mm5vT2FIVTdzK3I3SklUNU9paElnMzcvbkpa?=
 =?utf-8?B?Mi9oL1kxb0dDeS9Bc2t3cEh6S3YyRi9uRHdKK0R1N05JYkVOM2RXWlNBYURw?=
 =?utf-8?B?SjlZNTFsRzEweGRjbzhtMUM0Rnc5SzR3YndPNjZCTExKRmU5Wk9jMDhwU25w?=
 =?utf-8?B?VjFtUFo1MEEwWlhya0dlL29SSVI1aytHNWxZMHpkTStUMGFqU0poVXVLV1Zn?=
 =?utf-8?B?K0tUUzEzSTZkd2c5czdxemhwTkY1ejVnUU94OThUWGM4c3Zra2xsbmt0OElD?=
 =?utf-8?B?anBobEtDWEhGb05HK3hIREFmMlZwNk1uUmdVOHdOL0lwWkgxb1ZtZnJKQ2Mz?=
 =?utf-8?B?Tmx0by85Y25GdElpUjNsdkRrN2htOWtTanRPNnkzdE9BSVJUUk5YbERBaTRZ?=
 =?utf-8?B?UzdYdjUyTUZNZlZNelZOT2NISjFGMkFIRXR5TGJ1NGhwc3pHVjdpeWhNS2xy?=
 =?utf-8?B?ZHZDcmEzUlhadnZLRTF3azdyRGhCSFJYK1hiL1NxN2J4SXQwQytub1BlNkE4?=
 =?utf-8?B?cUk5VzNuNVB4YlMvbEdIT09KSzVWZSt6SzZ5cW9MRENhbUQwTXRidmU2dFJM?=
 =?utf-8?B?ajdKZ1dZMlpLREtQOVNJNXllQUNURXF4UldKRXBIMGdXRXdkOThHeEMvc01T?=
 =?utf-8?B?VXpJV2xxMUZpcldzUFN6bE9QeEhWdC9zWlNGSyt4UlB6Znc1SXJ0U2tJcVhW?=
 =?utf-8?B?bDVqcC9pcWZJZVJ0NmRQQy8zWGpyeWhnUEVXTEV6Q1hVREt2dVFjKzdVWnFo?=
 =?utf-8?B?WlNWT0w1Y2VjdUtOZ2s4Vy82RzUveCt2MC82UGpXTXBNSXpGbWhuMDJka3No?=
 =?utf-8?B?K1dDY1hIbFZ5SVplVWUvM3pGZTJtVEZXNy96UDR1WHFnRXBUemE3SzQxMVJq?=
 =?utf-8?B?Mkk5UHZoQjdlaERjTjZkRHJYZFJUTGY1cDU1enJ6QUpMVGg4ZWgxL0pjNEJ1?=
 =?utf-8?B?V0FmWUh1aHRibTNvVVh1dXdXR3UrYjRxQ2xja0ZXWktvYitSZnorVTNxdEti?=
 =?utf-8?B?cFd0TmtORzhOdDg0aEh3bTQ1emZFUUFNK1MveEVYK2F2cm0rbDlCckdxNGta?=
 =?utf-8?B?YTd5WHJRZ2JVUnRBdEZDWUlhb2xOeTkxL050UjVHakdBaFh6SlN6NTEweS9h?=
 =?utf-8?B?TVdJenJjOUdGTDdacmpIYm5rZDJMTkNKY0NLZ0J5TVArREhHRjlPa05ueisx?=
 =?utf-8?B?Q3NLZVM1Q3dpeTVvWFlOYUoxRGplWUhmem4xZzRIZ1VsdmRHc011eVdYLy9j?=
 =?utf-8?B?RWdMYVBKRk1hR2tlRVNrOUNPaFpuK0lKWlJ3V2c5Y0Ntb1pTQTUraUhrYjNZ?=
 =?utf-8?B?Y1hBcmtNOElDSUwyTnBIRVp6RHF6VXlRVGxsbmowM2RZY1lVd1dSMjQ2UnlP?=
 =?utf-8?B?Zm81OHd6emcyNnpmQ2lMY25vNnllNzE1b3pKUDd6d1dnZ1dCSE1EUjEvd3hG?=
 =?utf-8?B?WEFhOGc3eTJ6c3ZPb3hNUzRheEM4TzNmSFFEVGlZUnJxNnMxbW8rN2ZNazBF?=
 =?utf-8?B?UEw2c2tQZTYraHFwZFB3bHFKY0pkOGhHUkkvdjk1T0FhZkN2aS9vbzZaNVE3?=
 =?utf-8?B?OVdkWDVEeGFLbWtjVG9wUDMzTFUwditzVEJKT0REQWthclhrTHowQ0hSVHRV?=
 =?utf-8?B?Qm1CMVZPbEdEbEFkQlhxWWt1YkU0bUtGalZ2YUg0cTRZT0c4bkxrTWdTOWNu?=
 =?utf-8?B?Zk1OMWhyajRhYXV2aVNoTTIrT240clVUMFZ1Sm9Ea3BZVHRQazdhVXg4dmRC?=
 =?utf-8?B?TUJuT2pWNURDYXQwN3JId0ozNnFGRTRvUkJxak9SOGVqRXpqUUNVbXpyYTVz?=
 =?utf-8?B?UjlhUkYvQzFCbXk5YW9tT1ZRRmlvaXA2MjFvRlJpT041SHc2QjR6WWUwa2R1?=
 =?utf-8?Q?gBmyyLt6kDH/FvOJvxp1dfQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95B71CD710BFA549A968C1076109A744@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c26a00c1-0a65-4905-cdd9-08dc42f6b518
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2024 00:44:14.6912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1OSvWE0GMhYXjfH4o8H1CPv7G459IXPf86B/7kdrrwIpvUIRztweXrbWWEpzwnxmigw/Qwb9ahegUqzQDU9K0Ef8CLyceJ2XZ6vJWx+Zbi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8671
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBBZGQgaGVscGVyIGZ1bmN0aW9ucyB0byBhbGxvY2F0ZS9mcmVlIFREWCBwcml2
YXRlIGhvc3Qga2V5IGlkIChIS0lEKS4NCj4gDQo+IFRoZSBtZW1vcnkgY29udHJvbGxlciBlbmNy
eXB0cyBURFggbWVtb3J5IHdpdGggdGhlIGFzc2lnbmVkIFREWA0KPiBIS0lEcy7CoCBUaGUNCj4g
Z2xvYmFsIFREWCBIS0lEIGlzIHRvIGVuY3J5cHQgdGhlIFREWCBtb2R1bGUsIGl0cyBtZW1vcnks
IGFuZCBzb21lDQo+IGR5bmFtaWMNCj4gZGF0YSAoVERSKS7CoA0KDQpJIGRvbid0IHNlZSBhbnkg
Y29kZSBhYm91dCB0aGUgZ2xvYmFsIGtleSBpZC4NCg0KPiAgVGhlIHByaXZhdGUgVERYIEhLSUQg
aXMgYXNzaWduZWQgdG8gZ3Vlc3QgVEQgdG8gZW5jcnlwdCBndWVzdA0KPiBtZW1vcnkgYW5kIHRo
ZSByZWxhdGVkIGRhdGEuwqAgV2hlbiBWTU0gcmVsZWFzZXMgYW4gZW5jcnlwdGVkIHBhZ2UgZm9y
DQo+IHJldXNlLCB0aGUgcGFnZSBuZWVkcyBhIGNhY2hlIGZsdXNoIHdpdGggdGhlIHVzZWQgSEtJ
RC4NCg0KTm90IHN1cmUgdGhlIGNhY2hlIHBhcnQgaXMgcGVydGluZW50IHRvIHRoaXMgcGF0Y2gu
IFNvdW5kcyBnb29kIGZvcg0Kc29tZSBvdGhlciBwYXRjaC4NCg0KPiDCoCBWTU0gbmVlZHMgdGhl
DQo+IGdsb2JhbCBURFggSEtJRCBhbmQgdGhlIHByaXZhdGUgVERYIEhLSURzIHRvIGZsdXNoIGVu
Y3J5cHRlZCBwYWdlcy4NCg0KSSB0aGluayB0aGUgY29tbWl0IGxvZyBjb3VsZCBoYXZlIGEgYml0
IG1vcmUgYWJvdXQgd2hhdCBjb2RlIGlzIGFkZGVkLg0KV2hhdCBhYm91dCBhZGRpbmcgc29tZXRo
aW5nIGxpa2UgdGhpcyAoc29tZSB2ZXJiaWFnZSBmcm9tIEthaSdzIHNldHVwDQpwYXRjaCk6DQoN
ClRoZSBtZW1vcnkgY29udHJvbGxlciBlbmNyeXB0cyBURFggbWVtb3J5IHdpdGggdGhlIGFzc2ln
bmVkIFREWA0KSEtJRHMuIEVhY2ggVERYIGd1ZXN0IG11c3QgYmUgcHJvdGVjdGVkIGJ5IGl0cyBv
d24gdW5pcXVlIFREWCBIS0lELg0KDQpUaGUgSFcgaGFzIGEgZml4ZWQgc2V0IG9mIHRoZXNlIEhL
SUQga2V5cy4gT3V0IG9mIHRob3NlLCBzb21lIGFyZSBzZXQNCmFzaWRlIGZvciB1c2UgYnkgZm9y
IG90aGVyIFREWCBjb21wb25lbnRzLCBidXQgbW9zdCBhcmUgc2F2ZWQgZm9yIGd1ZXN0DQp1c2Uu
IFRoZSBjb2RlIHRoYXQgZG9lcyB0aGlzIHBhcnRpdGlvbmluZywgcmVjb3JkcyB0aGUgcmFuZ2Ug
Y2hvc2VuIHRvDQpiZSBhdmFpbGFibGUgZm9yIGd1ZXN0IHVzZSBpbiB0aGUgdGR4X2d1ZXN0X2tl
eWlkX3N0YXJ0IGFuZA0KdGR4X25yX2d1ZXN0X2tleWlkcyB2YXJpYWJsZXMuDQoNClVzZSB0aGlz
IHJhbmdlIG9mIEhLSURzIHJlc2VydmVkIGZvciBndWVzdCB1c2Ugd2l0aCB0aGUga2VybmVsJ3Mg
SURBDQphbGxvY2F0b3IgbGlicmFyeSBoZWxwZXIgdG8gY3JlYXRlIGEgbWluaSBURFggSEtJRCBh
bGxvY2F0b3IgdGhhdCBjYW4NCmJlIGNhbGxlZCB3aGVuIHNldHRpbmcgdXAgYSBURC4gVGhpcyB3
YXkgaXQgY2FuIGhhdmUgYW4gZXhjbHVzaXZlIEhLSUQsDQphcyBpcyByZXF1aXJlZC4gVGhpcyBh
bGxvY2F0b3Igd2lsbCBiZSB1c2VkIGluIGZ1dHVyZSBjaGFuZ2VzLg0KDQoNCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IC0t
LQ0KPiB2MTk6DQo+IC0gUmVtb3ZlZCBzdGFsZSBjb21tZW50IGluIHRkeF9ndWVzdF9rZXlpZF9h
bGxvYygpIGJ5IEJpbmJpbg0KPiAtIFVwZGF0ZSBzYW5pdHkgY2hlY2sgaW4gdGR4X2d1ZXN0X2tl
eWlkX2ZyZWUoKSBieSBCaW5iaW4NCj4gDQo+IHYxODoNCj4gLSBNb3ZlZCB0aGUgZnVuY3Rpb25z
IHRvIGt2bSB0ZHggZnJvbSBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvDQo+IC0gRHJvcCBleHBvcnRp
bmcgc3ltYm9scyBhcyB0aGUgaG9zdCB0ZHggZG9lcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElz
YWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoGFyY2gv
eDg2L2t2bS92bXgvdGR4LmMgfCAyOCArKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+IMKg
MSBmaWxlIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBpbmRleCBhN2Uw
OTZmZDgzNjEuLmNkZTk3MTEyMmMxZSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90
ZHguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IEBAIC0xMSw2ICsxMSwzNCBA
QA0KPiDCoCN1bmRlZiBwcl9mbXQNCj4gwqAjZGVmaW5lIHByX2ZtdChmbXQpIEtCVUlMRF9NT0RO
QU1FICI6ICIgZm10DQo+IMKgDQo+ICsvKg0KPiArICogS2V5IGlkIGdsb2JhbGx5IHVzZWQgYnkg
VERYIG1vZHVsZTogVERYIG1vZHVsZSBtYXBzIFREUiB3aXRoIHRoaXMNCj4gVERYIGdsb2JhbA0K
PiArICoga2V5IGlkLsKgIFREUiBpbmNsdWRlcyBrZXkgaWQgYXNzaWduZWQgdG8gdGhlIFRELsKg
IFRoZW4gVERYIG1vZHVsZQ0KPiBtYXBzIG90aGVyDQo+ICsgKiBURC1yZWxhdGVkIHBhZ2VzIHdp
dGggdGhlIGFzc2lnbmVkIGtleSBpZC7CoCBURFIgcmVxdWlyZXMgdGhpcyBURFgNCj4gZ2xvYmFs
IGtleQ0KPiArICogaWQgZm9yIGNhY2hlIGZsdXNoIHVubGlrZSBvdGhlciBURC1yZWxhdGVkIHBh
Z2VzLg0KPiArICovDQoNClRoZSBhYm92ZSBjb21tZW50IGlzIGFib3V0IHRkeF9nbG9iYWxfa2V5
aWQsIHdoaWNoIGlzIHVucmVsYXRlZCB0byB0aGUNCnBhdGNoIGFuZCBjb2RlLg0KDQo+ICsvKiBU
RFggS2V5SUQgcG9vbCAqLw0KPiArc3RhdGljIERFRklORV9JREEodGR4X2d1ZXN0X2tleWlkX3Bv
b2wpOw0KPiArDQo+ICtzdGF0aWMgaW50IF9fdXNlZCB0ZHhfZ3Vlc3Rfa2V5aWRfYWxsb2Modm9p
ZCkNCj4gK3sNCj4gK8KgwqDCoMKgwqDCoMKgaWYgKFdBUk5fT05fT05DRSghdGR4X2d1ZXN0X2tl
eWlkX3N0YXJ0IHx8DQo+ICF0ZHhfbnJfZ3Vlc3Rfa2V5aWRzKSkNCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUlOVkFMOw0KDQpJIHRoaW5rIHRoZSBpZGVhIG9mIHRo
aXMgd2FybmluZ3MgaXMgdG8gY2hlY2sgaWYgVERYIGZhaWxlZCB0byBpbml0PyBJdA0KY291bGQg
Y2hlY2sgWDg2X0ZFQVRVUkVfVERYX0hPU1RfUExBVEZPUk0gb3IgZW5hYmxlX3RkeCwgYnV0IHRo
YXQgc2VlbXMNCnRvIGJlIGEgd2VpcmQgdGhpbmcgdG8gY2hlY2sgaW4gYSBsb3cgbGV2ZWwgZnVu
Y3Rpb24gdGhhdCBpcyBjYWxsZWQgaW4NCnRoZSBtaWRkbGUgb2YgaW4gcHJvZ3Jlc3Mgc2V0dXAu
DQoNCkRvbid0IGtub3csIEknZCBwcm9iYWJseSBkcm9wIHRoaXMgd2FybmluZy4NCg0KPiArDQo+
ICvCoMKgwqDCoMKgwqDCoHJldHVybiBpZGFfYWxsb2NfcmFuZ2UoJnRkeF9ndWVzdF9rZXlpZF9w
b29sLA0KPiB0ZHhfZ3Vlc3Rfa2V5aWRfc3RhcnQsDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRkeF9ndWVzdF9rZXlpZF9zdGFy
dCArDQo+IHRkeF9ucl9ndWVzdF9rZXlpZHMgLSAxLA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBHRlBfS0VSTkVMKTsNCj4gK30N
Cj4gKw0KPiArc3RhdGljIHZvaWQgX191c2VkIHRkeF9ndWVzdF9rZXlpZF9mcmVlKGludCBrZXlp
ZCkNCj4gK3sNCj4gK8KgwqDCoMKgwqDCoMKgaWYgKFdBUk5fT05fT05DRShrZXlpZCA8IHRkeF9n
dWVzdF9rZXlpZF9zdGFydCB8fA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBrZXlpZCA+IHRkeF9ndWVzdF9rZXlpZF9zdGFydCArDQo+IHRkeF9ucl9n
dWVzdF9rZXlpZHMgLSAxKSkNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVy
bjsNCg0KVGhpcyBzZWVtcyBsaWtlIGEgbW9yZSB1c2VmdWwgd2FybmluZywgYnV0IHN0aWxsIG5v
dCBzdXJlIGl0J3MgdGhhdA0Kcmlza3kuIEkgZ3Vlc3MgdGhlIHBvaW50IGlzIHRvIGNoZWNrIGZv
ciByZXR1cm5pbmcgZ2FyYmFnZS4gQmVjYXVzZSBhDQpkb3VibGUgZnJlZSB3b3VsZCBub3QgYmUg
Y2F1Z2h0LCBidXQgd291bGQgYmUgcG9zc2libGUgdG8gdXNpbmcNCmlkcl9maW5kKCkuIEkgd291
bGQgdGhpbmsgaWYgd2UgYXJlIHdvcnJpZWQgd2Ugc2hvdWxkIGRvIHRoZSBmdWxsDQpjaGVjaywg
YnV0IEknbSBub3Qgc3VyZSB3ZSBjYW4ndCBqdXN0IGRyb3AgdGhpcy4gVGhlcmUgYXJlIHZlcnkg
bGltaXRlZA0KY2FsbGVycyBvciB0aGluZ3MgdGhhdCBjaGFuZ2UgdGhlIGNoZWNrZWQgY29uZmln
dXJhdGlvbiAoMSBvZiBlYWNoKS4NCg0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoGlkYV9mcmVlKCZ0
ZHhfZ3Vlc3Rfa2V5aWRfcG9vbCwga2V5aWQpOw0KPiArfQ0KPiArDQo+IMKgc3RhdGljIGludCBf
X2luaXQgdGR4X21vZHVsZV9zZXR1cCh2b2lkKQ0KPiDCoHsNCj4gwqDCoMKgwqDCoMKgwqDCoGlu
dCByZXQ7DQoNCg==

