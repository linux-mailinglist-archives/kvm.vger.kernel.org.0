Return-Path: <kvm+bounces-50580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91725AE720C
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E0A91891CDB
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D80425A63D;
	Tue, 24 Jun 2025 22:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VTE72rhm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B71B3D994;
	Tue, 24 Jun 2025 22:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750802626; cv=fail; b=JLgKym8rRHVwS1Msz3+IHqufI6GXm7x6uQWQT89HCuhWLrl6AEVOndMAEtheHl9ikl6h1KKHJH9ErQI7SnSUDmivCqMW82mrs1F5NSL0+Hc5Ju6r4Ud4y7hT/+mKqkss2Tp7/EVg9gWvIMpCZ1gUXMfKlywN0BWio9VEaMwKc04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750802626; c=relaxed/simple;
	bh=JDbWKgHiA0GvEbbW/wCi4LAtPXp4ZgE2gSJueDKdklg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JfTqqqu7ezC9dLIxt0AV8euH+trJQ1yH72sPBVwYmpiLTAEwhv6Cw7igXI3547O96KIv5P4iXniVTTd6RhJ/TKKkRgvqqwow9B4JykX0ZqIj4DIW4K5fj2eRq3UN2B8+pdzDXwaTie3SjUAKO9oVF2Uc13lA0Qo9p+tMYmVX+d8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VTE72rhm; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750802624; x=1782338624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JDbWKgHiA0GvEbbW/wCi4LAtPXp4ZgE2gSJueDKdklg=;
  b=VTE72rhmQv1xS3M/8geZX8H+b7cAAgH1WGK4s3L3hRa+sLmAQ4GMzS8P
   x7Swi73zEaVA0/ZWzO4eom3J8NqCdCKErUJ76YHlEobsnPc+8P/88CGKE
   eHf0MQxkaazcwmBBg75vGUIn7mGO7h8R8oofPwudWhYeWHHO6GP07wdlD
   OfGE4DmNkHCcCGM317nD0P5Kvq6LM+Fi9iMQbfwjKTby4uEMYVGvzaKK+
   uzSBRs1kQNlcpaSG0XLFp8l679M84bctcjObeg//N7+0cY7MGkTHuXsvN
   7Lx7BkmyRp63f07YoOLxBQBphjYhDKcSruKpzbFpS1tQU9paYsh6xzPqx
   w==;
X-CSE-ConnectionGUID: MjhE9PBlQGW0koV+f7yz5w==
X-CSE-MsgGUID: yYzeG3FcTlmIN4E8dsCPjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="53198997"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="53198997"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 15:03:43 -0700
X-CSE-ConnectionGUID: g5UMc6rvQXmnevVf4u9r5Q==
X-CSE-MsgGUID: JnUMKtU2R9OH+vajpobg9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="152557608"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 15:03:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 15:03:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 15:03:42 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.71)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 15:03:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pYFrcS1E/hAEZskefn4u3VAg6a7iXHXWV+DXtiCHsIoHx5zvyZDbZUqwMC1mPCg1mOVKtsroYXMBYwG2+qMKjiJ8MvZHx91F/3C7SJuY2mqo6ndXKRruroA3IhpPCdVLgxOTaeWNrZ0YNT6nmUUCasm74HY1LJ5RUbylHCNzA74AB4velThI9MN23nzHmug8BFXg5COwm+eZ7bfgp2ojnJrEA6jwS7UVXLbXXWU/ZRjFVGjnyuTkxvdrTf8y918Khg63abEUOAlTX7GV1oEanBahrwyuIr4iEcl9pmNd/NVR5VsQFuZPKj6maPXQPBVoinXljznNAzVvlczmblYnlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JDbWKgHiA0GvEbbW/wCi4LAtPXp4ZgE2gSJueDKdklg=;
 b=YI1iHNbpIOlha6KxJ0Mc3VBJkGWOqUAjO1m1hgLIlnej6xtFTqGzvjeLgpEgW2JfFq5HwEeHWygpJLofBIL54b74J9gVpNMn09LPzQmq8M2xAtMy1OZ0OzlGBCPVIx3sRk+nQWvHKj/74eeDE82WOEs4/3mQ7kPjykSVd0XE7S0Qr6VAtMH8CLQ3wRLC+ThEQFetzdWLoGf+74M2TDbV0Xpa89Mf6NKRbDoTTgNreO4rQAU2h3bQ+v2H2MZe5VNfTu1y++MgvPZjDwGbfiaLOGsSN7rbE+POzlQj+8NEi2TCN1peuNk1v6Uir6FqzuoKnLRf8JCzpdMxQBuzgXXDXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Tue, 24 Jun
 2025 22:03:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Tue, 24 Jun 2025
 22:03:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGFk4A=
Date: Tue, 24 Jun 2025 22:03:24 +0000
Message-ID: <4bb2617db9919859e8d7249fb72bcabae18ebc92.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
	 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
	 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
	 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
	 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
	 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
	 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4937:EE_
x-ms-office365-filtering-correlation-id: 3279b1d6-ef23-47a2-d6bc-08ddb36af0d8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L0hsQWU0TmdkYjRyMTRDMmw3RWpCZEZITitKLzZud3Bab3E4OXIrckFXb0NF?=
 =?utf-8?B?UEQ4eWZEakkrdDN2Q08yWlhETkpLNkNqSCthTEJUdm54TUZFcUU3WEdWMExY?=
 =?utf-8?B?dVVGRWhsNG84bFVnUDhwMEFKTUNkQ2RZWXEybnVEckpLM0hhNHc0MTloZ1k3?=
 =?utf-8?B?dDNOZGJaUzBYT0o4YzdRMCtsV2FJSGFpQXhlUUZEMUwrUDZVbjhnNWk3VVZG?=
 =?utf-8?B?NFVXQWtSOEs0L3M0VlRCN1djQVJVL1VheGljQ3BuNHh2V3h5SkM2ZjlwNllD?=
 =?utf-8?B?YS8yNXVCeVBNcFFrdmVMRXgybzMvUFFqbE4yekpabmFKU01sbGdYcjN1bWVC?=
 =?utf-8?B?L3Vsc2ZacUlBZW1FWnphYTFiUTRMVHJLdndtbEZyM3FPNVVxK3VLbnFvQ1Fu?=
 =?utf-8?B?TkIzVFNzYlZ1emRoMW1SUGRsazdoUDVFejNrTTdHZEdpQlBDMTNILzUvTVB2?=
 =?utf-8?B?cmRaS3U5aGJyeFpWTnVSQm1VdFlScnlZajhQMWM4cjhBcDNCUmZPdFo0dWV4?=
 =?utf-8?B?YVEweTF2M25kczV3cUlyR2orZkhHeVBBcEY4d0dEUUVLZ1YxUElQK0F6a0Iy?=
 =?utf-8?B?c3RBVEJyT3BDL0duRTc4V3ZZbEN2ZlFRTEF2YjVxSTJLWWFSSFhLeERSUkFw?=
 =?utf-8?B?YmhnZDBFTm1JVWdKSDJySnhFMzJCUTgzdTFJalBEWlRwaHhmeUhaTCt4UWR2?=
 =?utf-8?B?WHZQUXdKbWdPUUVhRWJPUkRiL2p5SkFLVlkxSFp1bERmZGRoSldHSERvaE4x?=
 =?utf-8?B?ZThpVzdxY3JzWVgwNlYzNUJpbStRKzRyWXMwM3NUL29hOHI3NkZ4d05xRnpE?=
 =?utf-8?B?dUthb1RVVnRydllLclZ5R0NpSlRUZjYrN1BoUjIwZHVCK09jeGdQbFpHQTc3?=
 =?utf-8?B?SlVCVFp3dE9BbU9NQWhWbWpaMXFhTDhtZDZRMXRXQWQ2ZVhGb0NjVjVQTWxl?=
 =?utf-8?B?RGZMQWF3RWJoUnFDcWpPT2VoNkt2OXlsbFVJWCtCcEJQa0M3U243WjhTUjd0?=
 =?utf-8?B?bmE3cUlhVHh6WUFtT1I2MUN5WXcrSDhJVi8veWhWUnNPck5HaGtJb1QrcG11?=
 =?utf-8?B?MWhNeFd6U0gvWXJhMkpIQ3FwVmdJMFo5azRobFBEelU5OWtKVFVCZzU0Rlha?=
 =?utf-8?B?dzNHdHAyMVppeDBzWE1LdndvSzgvMG5VNXZvM1drL1o0UjZ5NkJ2YTFGREk2?=
 =?utf-8?B?T1FUZG9Ea1JOcUl5QnE1QWtBU01WRG5TK0t3MjlLUTB3YzlQbDBYZytmWlFy?=
 =?utf-8?B?TERXSXV6aWRFNXdsbmpKYVl3Mlh5S3p3UkIzeUpGY2krYXA3STRTalYwMmQx?=
 =?utf-8?B?TnB3bDZ5M0VGRXFEb1ExTWRBajVnV2lKbkU3QnNqTFQ1R1RybVZrcXJxSmNj?=
 =?utf-8?B?K2JiaWtmWUJaVVJMOW9KVXdYYVZ0RXEySkJZOVNkQ1FCUTVhbnhaUlB6STF6?=
 =?utf-8?B?b0JUSGkveGNGRUQ2OHVXTkFSR284eDN0UDl0UHkraW9ramFQZFNqRWpBS0Zx?=
 =?utf-8?B?c0FGWDc4Uy9BV0lNTGhOL3p0TEQ5QWhzV3FPbmRhdzg1MnZmcjNEaTNHN0d4?=
 =?utf-8?B?bWFROEFLLzNrU0F6eW5uVENTT3RFZ0NEZk50azd5dHRYV3BOVGhBV0hCcmZU?=
 =?utf-8?B?Zi9NSUtRZC9YalJqejFqMEVodElVRDh6SUJwRnRXSVNvSDdUTWpHSy9MOGxs?=
 =?utf-8?B?akhNVHkyS204QnM4SXBTNUZyNlhZM2h0eUc1blZwZE1lOTU2V3E0eG02NHgy?=
 =?utf-8?B?SVhpNVVacHRaK1k1QjBlTFhLK25lcm5jWXJpSnpSQ2t5ci92b2tIN05qcFFi?=
 =?utf-8?B?amFhVWlRVUpsUUg3ZFZ6NnZubno2Yk1yWDN4bC9ONklpdlpwUEFFRjRIVzN4?=
 =?utf-8?B?eWZhNUEyN3RDRDcwNm41U3pDY1pnMldlbnZZTEZoU3E4eG1ZY0R1RGNQUGFh?=
 =?utf-8?B?THpidytyWHQ0RFM4UEJiMjRJV0V3c2hhSDZOK3Jab0RTOFhiM2U4amgvTFc5?=
 =?utf-8?Q?uWV05zb9Lhu0df9bcZkZTRQVwrL4QA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmpmR1Rzd2lkUkRKQnJDaTNDam1zbFdOR3N1NC9rSFJoSUxuNjZ3TjdyUnFr?=
 =?utf-8?B?c1paTXVvNU1IM2JINFRFMkxaTTlmQS9vRlk4aTltazErVUdiUzkrNnhjN2NI?=
 =?utf-8?B?dFpJVFRhOTBEeWpYTk9nWEFqbkFndk5aU1YxUi8zL1o5MzNGMGJURGo0aWNZ?=
 =?utf-8?B?SENIM2lpVnZzUGg5ZnN0MEF3M0NtTkZsS2NFb0ZBZW9BdVJ6N3FJRlg1aFNR?=
 =?utf-8?B?UTNNcmU4OFVuYVh2WGpBNmU1ZlJNdGdPRnVKS0Q1RXRrcmU3NGtnNEprWHFk?=
 =?utf-8?B?U3NFdmFNOS81Ni9HZ08rY1V1Q1FhWlN0UzJTVStxa1NrNXJMWEwzdmljY2RE?=
 =?utf-8?B?Q2U5RHNKeUlCcUcvQ3Rnc0swQnhEWFFQUHNCUGVNUkc4OXVQdUhSQzI4amhp?=
 =?utf-8?B?Qlp3VGxwMUtadm5lMzVxRFlCTzNINUFTV3pjNys0bFFrQU9jRGpiQlB3WFBT?=
 =?utf-8?B?L2pNdkZOY2lyeVpHVURlVHRyZzkrbE5UTEo2NStNd2ZUTExqUHFqbDhlL1dD?=
 =?utf-8?B?ZEJ5S2hxbTdSREQyakhaODd4aTJlZ2xTK244Mjg4cG00bHFrKzJKOHFISm1P?=
 =?utf-8?B?MU9RVmpubG1oYno0dXphbDJUdXZzVS91enJ5MjRjcTA3ZmNYcmpPc2E1VXRS?=
 =?utf-8?B?Q2REakJPZ3QyU3Jkak0vbDhOVTRHeDNjdk1IREpENTdRQy9ra0wxaXppUTJU?=
 =?utf-8?B?MXo0YWFqMS9CMzhEZVA1V0phNnMraldUZTI2SVBXSjdmUEZCNzF4bmVRdEJR?=
 =?utf-8?B?NXAwRnNmY3RheHlUUVh3VXEvRjNpMWlOQVlYWVpwOXRYL20yaHlGakpSUHh6?=
 =?utf-8?B?WjBKSVJabGMwNGRmTUZKQk5VRFljUlMrcGJ0TlorbE5FUkdvQXJrSkpUYVkz?=
 =?utf-8?B?emJvdEcrU1V1OHRXdEl6VnZadmlRSWV3d1hOWW5FK2hrNm9LYWw1amRoNllS?=
 =?utf-8?B?d0h3RWsxNU1SUWRncjlsb0dLVSt5Z3h4b20rb3UwOGVRa1FYV2VaWnplQXJB?=
 =?utf-8?B?dWJhdXpvc2hVMUx3RUFGZGVZQnpvWUxvWUlHaS9iVVA1SmlnVmJUZHZ1a3U1?=
 =?utf-8?B?VmxvbEEwNEhRYUFQejZkZ0hkeTl2MmJIdWVhaVlreGhjVCtBTCt6dFR6UkFC?=
 =?utf-8?B?WXFpQ2c3UG9TZkpzYmI0WTBaZ2VqSWc1SWcwZnc5VFhYN3NRU254b25UUDQ4?=
 =?utf-8?B?Z1g0cHlTMDhWdWU5VHZnMTJqSmZzSG9JYlRFWkdXZzJZakpZN01VekV0eFZs?=
 =?utf-8?B?VmVBeG44ZVdPUUZjVnU3UkM0STFaYWRxSnhZY0pmcUtObTlDMFg3QS9kQXpa?=
 =?utf-8?B?VW9vOHA5V2JRb0hJYkpLdFprejRZd0RZMU1UdDFSbWxzMTNVc2dsNEllc3dU?=
 =?utf-8?B?ekd1bWs1RDNndlVJc2pJa2JCS1RENkIyam9zQmlRUUVERzNwdHNGamYrQ0Jl?=
 =?utf-8?B?VVdTM1QxM1BVWERaeUd6UXBORDBvYngxN1NXaTFvZXl2QVNwV25xdFE0UFR1?=
 =?utf-8?B?YU41VVR5dit2R25YcFJQU2ROUWFUd0VMakdhNk1GQ2llaHRyVzR3aWRpaktw?=
 =?utf-8?B?ajNnRE9wdVoyUHVoSWpoR1g3eXVLclkvQ21NRXBRblB2bmYrYW5hSmlwUVhr?=
 =?utf-8?B?UENLaUhGbzdMVklDM1FWWGk4MmpKa29zM1NleEV1T1NJSXRRbCtHYUhZMmls?=
 =?utf-8?B?YkFQUDI0ekRtR1gya3I2ZEpDZlQ5RnJjV1RQQW9tT1NsU285Rjd2N2tnYk9I?=
 =?utf-8?B?MnhJN3ZHM3ZXcEZlaWpaWVJHR1crTHlkdmVIcjJxdnJmMS9WUlY4cXZ5ZFMv?=
 =?utf-8?B?SXlaaVByeEdUZW56S0M4Q3piVmpmTUpNQmYyblRIdkpkTGlsaXhXaFhFV1c0?=
 =?utf-8?B?VFAzb3F1VUQvTzVBaU00dFYvRFZmL3U4K2krb3UycEFydmVMbUsvb2J3bDBU?=
 =?utf-8?B?WDQ5cU9vSjNtUUZhYzBBVlRwazFLdDVFOFFSNHFXd002UzJvbnN3ZUxwZU9p?=
 =?utf-8?B?V3M3UG9RbDdpdHpjM2NnbG8zTWZTK2dxNTVDVUVIZFBRalJZZlAxMjcwbE1J?=
 =?utf-8?B?TFQzMkZ6ZHhLd3hoalBtbG1lZjBlQTFXbzE5UFczU2x5RE51c2RHQXpjU0ZY?=
 =?utf-8?B?ZzVCQjNRV2dGdkNsaU5PbDA0SG8xMXNRTUdoRFRQc0pBMnk4YzhpN09IaW0z?=
 =?utf-8?Q?+Ld6uEfH3yh4GEjKtf30ISs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48B9F0952C780F47A9B7C95B3275AB2A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3279b1d6-ef23-47a2-d6bc-08ddb36af0d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2025 22:03:24.4677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bw6sNTxGRK4gx/cPLKs0Lz/vzBL35zw8gfr2HjMZYD8d/5MZkmLcjf8xbBULnOsL9ha9+RoA++Xu1dtb0EvNtGqaIVNNBY6IihW+7yB0AE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTIzIGF0IDE1OjQ4IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
IGEuIFJlZmNvdW50czogd29uJ3Qgd29yayAtIG1vc3RseSBkaXNjdXNzZWQgaW4gdGhpcyAoc3Vi
LSl0aHJlYWQNCj4gwqDCoCBbM10uIFVzaW5nIHJlZmNvdW50cyBtYWtlcyBpdCBpbXBvc3NpYmxl
IHRvIGRpc3Rpbmd1aXNoIGJldHdlZW4NCj4gwqDCoCB0cmFuc2llbnQgcmVmY291bnRzIGFuZCBy
ZWZjb3VudHMgZHVlIHRvIGVycm9ycy4NCg0KWzNdIHlvdSBwb2ludGVkIHRvIHRoaXMgdGhyZWFk
LCB3aGljaCBpcyB0aGUgb25lIHdlIGFyZSBkaXNjdXNzaW5nIG9uLiBJcyB0aGF0DQp0aGUgbGlu
ayB5b3UgbWVhbnQ/DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvYUZKalpGRmhyTVdFUGpR
R0B5emhhbzU2LWRlc2suc2guaW50ZWwuY29tLw0KDQoNCg==

