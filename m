Return-Path: <kvm+bounces-33983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06F729F5183
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 18:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FD94169351
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 17:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A751F757B;
	Tue, 17 Dec 2024 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TIeS0EdZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB391494A9;
	Tue, 17 Dec 2024 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734454979; cv=fail; b=Bxwc6ujtAXc1BJkJm2vJkAII1upuauaV+oHnuCXN7T7MnGKNngq+/foaomIsZOtZ9s7Qk1fkJJnUAXPQSAgR24Tzg/vHLAMK7IkKZYzLWoPjoUDJnrGbJMjYd5xE2CprIb+r4nxdEjsFm9jxfcN30nc0Kt1ZMzzEX9TtVLzNep4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734454979; c=relaxed/simple;
	bh=Qg07B7PWJi3xw7ozxYGXG0IDtHqXDhX9GEee+2szPpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tTbCYdHuChUSNxwfdXj9i//xnysFrGYf+AyS/q9OKDrOfRaZYKChRAq06wXF+4w6GnkIYbZE+FluZN4vNF+XGoSDu33MDrU06XBOBuw7dQFebYD+st0tiW8Xvw5mK3VyAvvYYBlMAMYrWmiSmoho7XWBFwxyGG+szrq7WZXRepk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TIeS0EdZ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734454977; x=1765990977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Qg07B7PWJi3xw7ozxYGXG0IDtHqXDhX9GEee+2szPpE=;
  b=TIeS0EdZGs73a4npj+CLT7nJ9AH+DoyjX4NzK+jlQXlpmdzyJb0K4FlQ
   FpikDsqQjPOdX7bRPmVLHNFdY81R+OccRoYimLPx42MxkbC7Q6DNdINF/
   ZxER5tnbJr9WcZh7lS4ypwAgsUTHhb8gmeLRw3FI76bb5v/9IfwvHpqLD
   KuT3u5fMSJVkc9zEhx9fpVH088/wFKLjPkjyryPN16492SUOXteoCGKRV
   s5FhD9mcdbqQd1HGhgcXmRJR1wI09s5c/lyB5ezY7kxYwC4kroWmXSQz/
   IypYTNYFZ7du5VWjHRcTT7411uHMfNHgBvHefxg8QmW1EoEbbENKONVfi
   g==;
X-CSE-ConnectionGUID: 12xELAtFQfOUlR0q69FICg==
X-CSE-MsgGUID: 60nV3sQhS1eBsmf2wwSo/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11289"; a="38566018"
X-IronPort-AV: E=Sophos;i="6.12,242,1728975600"; 
   d="scan'208";a="38566018"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 09:01:41 -0800
X-CSE-ConnectionGUID: i1n7MeI9SQ28byn0cbD1dg==
X-CSE-MsgGUID: vZ2Fr6JdRXG99FcTqaMp9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,242,1728975600"; 
   d="scan'208";a="97624596"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2024 09:01:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 17 Dec 2024 09:01:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 17 Dec 2024 09:01:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 17 Dec 2024 09:01:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FtAtE8QUgVfcPPl93VNk93Jy6dGewZ8mdG9z0ukFbpZ5ARc6XHnaE5hw8dWAkFxHxNK1eNnDexRxG6dwoLnRU1UE7laes2FBZfK+yupWXxOtg0NknDlECpLf6CKzuTuRVulTsQqwbATDuHZ+kob2QjkUM1gl/iEobjec1SFCXRzpg7INIR6Oz1c1wnxQ3Oo5/mkHYFA6jF36UzeV8uTrDaognVgIknBkDGgRc+adSFOBRHvzxyUKBUyyCZJUgVKplPG0YTtHANl8tL6Q8rBvvs0NCCEhEQyKI+GRfz5DdNIeaeDaoPVQ5iu+VIWxG5Wrn7RLeNzYRuH5tg8y7L3E5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qg07B7PWJi3xw7ozxYGXG0IDtHqXDhX9GEee+2szPpE=;
 b=dBmlYVgvxPnXWh/xOsto+vVl1v0C+ii9n2TZAS7IbA4bePkXjbnDkRi5WWxnz03AhBRvL/Urq8HJ0pfrpZe2b7npalffbkVA+vB3yCTAHfHL5eeMOWFMkLEVEGpru8TQifQK1pYKGYs2x0o3x4iSAoeNAaIUOqTnTkCeUWVD8AFZCbK39ClA4+m0QMpTjecbkKME/Xir2/Ao5kAvujLWoGKlD0x+KQ5kMXL8MAYt8TDgOvGH72TEG4wKzEkFj1y+9GLuwQrboy2wM4LdYFFItRKcI4RZXm+4Kxa+gRAAPGVSEq0lvHYpgzzfFFSiFbPqIZynzoYZtdIYNbpR3qaFaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB5977.namprd11.prod.outlook.com (2603:10b6:208:384::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 17:00:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8272.005; Tue, 17 Dec 2024
 17:00:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [RFC PATCH 0/2] SEPT SEAMCALL retry proposal
Thread-Topic: [RFC PATCH 0/2] SEPT SEAMCALL retry proposal
Thread-Index: AQHbPAwn74Wd+qQVFUagGKKQXm+TfLLq0l6A
Date: Tue, 17 Dec 2024 17:00:55 +0000
Message-ID: <de7bc23ec1e40ad880c053f884200b4870e18986.camel@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
	 <20241121115139.26338-1-yan.y.zhao@intel.com>
In-Reply-To: <20241121115139.26338-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB5977:EE_
x-ms-office365-filtering-correlation-id: 160e2de8-b65c-42ff-d985-08dd1ebc5eff
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|3613699012|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NGFGR014d1F2QVUya1d4Zkp2MmNVR25ua0w2L2VMM1N6dGVKTGR2ZHBFUWFX?=
 =?utf-8?B?OHZFREpOQzRwOXEvNUk3c3ZJUjZwdjZsVS9IK2VrNkZIdXpsbUg3bFEzVzN6?=
 =?utf-8?B?N0gvQ2FZeHM1bUhRSHB6WktuRm9rWGlqZzRmOXFYVk9VUWVyMGF5RzhVR2lm?=
 =?utf-8?B?V3hSNE5lNG8zcXNaM0hhSTlEeHdLRThHKzIzZmQzUyt3YzNacjRQNnhxK3cy?=
 =?utf-8?B?YTI2VlVPRXVHKzdrVzk5cWZVR3NmejNkV0c0a0V1OUU0K0JhanNDSWdjK1ll?=
 =?utf-8?B?M25UWXNXMW1HRDFYT1o5WWNuaGNsMTRQK0xGZ2hwN20xWXR2V2duUkhvQ2Fo?=
 =?utf-8?B?RzBGM1RXeFQ4Sy85dXBlNXVEOXdON2MxRjJyMVVMRVdwNEZBMGRaZC9DaVBI?=
 =?utf-8?B?MUtocjY5SHJMdW92MkNmU3JHQllFclo1ZVpxaDQ0Z3VZMVcrZ0VXVVhrTmVL?=
 =?utf-8?B?ZGlXMnRBZ1p4cFhDMzJZRkdMR0pBTnJyRnkvVGQ4UjB3ZWxYb0pVbXk3RC9R?=
 =?utf-8?B?c1VIM1NRTXFzaFYzbVNxWU9ESURKeE9NNm5GSTJaUkNQWS9NbExzMERIQTdY?=
 =?utf-8?B?ZGtLVDcxMk9oc2RhcTVvRHJiMEJScjNzeVFleHlPV215RWVxd010TnZkZGNH?=
 =?utf-8?B?blNkWmtxajB5aDJzQ3dVWERhQ3M0STlUOG9tVFhNYnliZG5VbDliWllhTzhq?=
 =?utf-8?B?eGhUQmhkZEk3NzlZclBxVnUxYkI0N29UWGcyM2UvQTl5eFBzMlRTTTBRMzBN?=
 =?utf-8?B?UnB1b0ZuQURwNGFYMThEMFdwSllnUmxOTVpzVEYvNEtkNVlBVXplT3dGZk9M?=
 =?utf-8?B?NmY0MEc2bFkycjVmVkdBUGNOZWpMMVNPa1ozWEk0ZlpWaDdHTTlqWWNjVzM3?=
 =?utf-8?B?SDZrS1RPSktDN2h0UGkzbkRJTUt1YmhnOXVIbnYvZGpRcHlBS0l1bkNNb0hI?=
 =?utf-8?B?Q2RVTGVQdW1pWFMxTnJBMVBCSDdrd28wbmtiNzluc0gzZnl3bFVuMmE0NU1v?=
 =?utf-8?B?Vlk3RkNHRHVYWjdWanRRT1M5ZmRiOWtwbUdzWWRrMmVoZzduNU1teVRDd0Js?=
 =?utf-8?B?RlNsek03RThWdUMxQ0Z3RmUrZEtyc09mcXhqaVFzSmlZenNiMzY5QVdCZU90?=
 =?utf-8?B?eWtaYWVVZnR1dS9jeXk4Yi9ZMGVmOWhJbzZETktBT1lscTRIMlRlZ1dDd1Ro?=
 =?utf-8?B?STg2aWlJRGtVRG8wTk1sbTFZNWlibU5URE42eVVFVkl1SjdNSkZsYkFLSWxL?=
 =?utf-8?B?LzYyZW50QzJucXZmbjUxaWhuVHV4VmVmZFBLWXkyZmRYeWZIZVFsTSt2NjZa?=
 =?utf-8?B?dFdHZ2hCb2wyNTlTRWkzaUI1Y1Y3Y3JFK1d1clc0NG4zSUd5RVlMSlQ4SURt?=
 =?utf-8?B?TTdia2hBS0lFS2cvVlVLNWIwN0N1cnQxOVVMeDIrSUNpQjltamNyanFpRHpH?=
 =?utf-8?B?WGxKbCtXZXNldXAzNWRDdWhId2FrWHpaRUEweWJWN09rQlB4czM2QkYrTG5N?=
 =?utf-8?B?eC9HWHdPTys4d0JZYjVLQ1ZTbEd5aEtmY2JkYm1uMGRIcmJEZkN6OFg2SUpZ?=
 =?utf-8?B?VjVTRmdwY3laY2ExenlEUlRWenBkL2hIZUZoVWNZMEZKNlNEMXBjTDVZV3Mx?=
 =?utf-8?B?Z3ZrcVloenlZczZvT0J3Q3pNamQzeUZHVkk3cHhXRUlkZWtoS2FPMUxFMFFW?=
 =?utf-8?B?K2FWdE8vUUhuc1I5bXZaQnRhcE1Hc2FwZllPeUtIcW9NQ3kxVTVIVFhiS2lL?=
 =?utf-8?B?SGFpZk91U1N3YkEzWXdmT2k2SzN3NitRZjd3TFJUZElVQ3VRQ3ZaUm1SQWhM?=
 =?utf-8?B?SlNNUFpqMWpsUzNOS1ZCbUZGYzNWZ29jYlYzVThUMm8za2FTcldIenRONUFj?=
 =?utf-8?B?WGx5QVBZUGtMN0RjR3NLZGtiRjI5SjdJcjZwbmplNjJQQUFxVjNSenpzRjRl?=
 =?utf-8?B?M1ZTQTg1VUQ5bVBzbVhPR0duSVBld0VSY0pGZUFjMVo1bHVQZ2VYbXU3d01i?=
 =?utf-8?B?L2ZtVGFZYk13PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(3613699012)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXMxSjVtZlR2dXIwV0xuNTBQeUZGZmg5WVJhWkVxeWFCandGU2d2R0VqM09z?=
 =?utf-8?B?dTRUcFl1SVFFc2NTSWpDaVZRVHdHLzdzdDZ1VEtPQ082NUM1a2ZnQ09HY0ht?=
 =?utf-8?B?ZHR3QUpzZFlMVjF2V3RTdDE5dmZsZERlVlJSODdJMENzbUliODlnNmY1WVBl?=
 =?utf-8?B?VVozZHZUSG1ZVkQvTmFsS3hqNnVpQm9uVkxadmdJLys2aUIzMWRmUlF5aHJk?=
 =?utf-8?B?S0xhKzdoRGQ3SFFxcGFtR3k4Q1Z1aDN2cUFEd3FyMmRJejR3V2R2ZTY2TmFE?=
 =?utf-8?B?QlJZcWMwQkdLUDZJZm5EbDA1Uzcxemh3Rmdza3pzZThWczFwclphVjA1dVZj?=
 =?utf-8?B?dzkyTzRwSWVzQktRcjgwaHRyeGZPc2VRV0VsMnhoT0wzQ0FoNkRvK0tvR0VX?=
 =?utf-8?B?c0RLYmo1QVoxcTU5cm5hL3A5dEV4RHpmdzI1K2dZcWEzZ1M2R1VQbXlqUFhv?=
 =?utf-8?B?Ujd3ODBobnIyU1FrWWFzcUZISVBRM1p5KzJvQ0FGWU9rWEpIdzNEQ2hiSkRO?=
 =?utf-8?B?SUxvMW9KNTh6RUU0cWRPbWlWYTcwUndSaGpuTWowdmcwWlJjTUtIV1dCVVZi?=
 =?utf-8?B?WkVxSm05dFZsclJjOFI0WnZSRnhYYytKclNVbTY0ZWtaRHZCd1RUUzN6L3ZK?=
 =?utf-8?B?Z216WjR2UFdUWnNIZm9jWWRuYytQV2hQT1JGeVUzeGRFMUxwVDdGY2RmWGxu?=
 =?utf-8?B?amh1MWU5OVc2L01sdk9KNGxpc0xCY2pmaXFXdUxXZkJNWHNIaE15YmQ3SWF3?=
 =?utf-8?B?aTF4ZkkzTmZvcnozZUMvUVRiaVYydzZzVlIwVjUrdUtnL0xLN2Jjd0JxblBa?=
 =?utf-8?B?S09jcktrMnRmZC9TNTBtYXVmZ1E5ZDhqMURLSUUzM0crdFVoVTBqWWV4MFVr?=
 =?utf-8?B?QXFscjB0R3hRYVBXWGE5RU5UWUdRNlUwdGxBeWpxbHB0WWRpZW5wc3d0WUpR?=
 =?utf-8?B?L0QrQTQ0S3dlWWRCdlZxVFhicGdHRTkwRGltRXRaczB2UG5WamNwektWdUZT?=
 =?utf-8?B?aWRTVFErdkJzYUJKZUdNODRJYllvR2VhT3pyZUwremRoMHhuWENBd1dOTVJU?=
 =?utf-8?B?UkNKeUdFRGV2Y0NtYzhLQzlMUGJPNnFTRGk3WjhOWGF3TlJrTlBiaVovbmtH?=
 =?utf-8?B?MDA0OXMrSVVLV0drVXVQdG9DMUtEYjJ2K1dPUjU4UXBqN0tJQ01CMk5zMGFD?=
 =?utf-8?B?Sk0vRUc4N1Z0SEplNEhVODZCOExNRFdKWHRodlNUdEZxOW5OOWVlaGJwRklZ?=
 =?utf-8?B?YWRpa2s4VzJHNk92aldGZUcrWmFwWjBlb3k3a0V0STVvN08xalZ1T2VIN3Fk?=
 =?utf-8?B?ZUFLUDJscW42R2dLVzJsS3N6UWw1THVuS1BISmRmUC95a3d5d0lBb1hFM3BI?=
 =?utf-8?B?TUtlZk5jVE1hY3BwRXl4OVJPL3M0b0FrT3lWQ1hnVkRsOGZqOVBXT1BKSmZU?=
 =?utf-8?B?MmFRQURHVVVHTldZTFV3NEtuOUoxaVlWWmJSdmEzV3V1L3Qrb1d4SXpJdjd5?=
 =?utf-8?B?K0oxNHZWZWI5MDhmLyszNWhDSXpzWjRDSVhKdno1RmFtRmltOFZEYU9PdWRy?=
 =?utf-8?B?RjVlQ2FJMDY3WlZ6dHU5SXZaajNWUTVabEFDUFhYQ1NIeWFUdDN0RE5taTZh?=
 =?utf-8?B?QTFnMzNmMENSZVBIdFlYK25TTmZwdkVEKzU0YnlTMlQybHhxMEUwYWdKOVNE?=
 =?utf-8?B?bEdTU2FEUzI3YjlOdDZ4VjRlLytzNWgxc1l3NmRXQ1dsSnRia0IvbktvOGNU?=
 =?utf-8?B?MThNUks2Mld0bk9TanlZTkhTL1pvNmF5RmFhZHZ3eisxNW1pbUxscHg5cThV?=
 =?utf-8?B?ekswTW5jK3hKWU5lNWMweTFEQUJtNkowU0pqSC9YTHprbm1SSG1oeFhIR2tx?=
 =?utf-8?B?UTVGcVhsQ0VBbk9IeE9IdEVhcCtFL2FDUnc2dzFaM3hrTkhBQnVTalEzcERX?=
 =?utf-8?B?bnZkU3JpZjNmUlRjdnZab1FtRlBQVzEyYzc4TDlzSFIzTk1sVkxGS1hRVitx?=
 =?utf-8?B?UHpqVHZOb2VneHE2dkwvU0RuY2FiWDYwTk0xcHFsVkNCSTFId1ZrUEM4UXA0?=
 =?utf-8?B?bGY1dEszdUJiZW4zbDhKR3AzdTFXTTZ6d0NYbWtPeW9YMUtBQWdrQlRtN0Fa?=
 =?utf-8?B?Q1l0TVV4VHBTSXFpVUhFc3RUajNGeG5oRStpNFVWeHZDN1B4N3JVNk13eC80?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <385EB94F8741D34E90FC033F72E1B399@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160e2de8-b65c-42ff-d985-08dd1ebc5eff
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2024 17:00:55.2752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBKdd1IL6srbZeCQGQLle9yobX+WFZPauGwpZDdYxchQt37T4dpMAitD8fwWPYBjKFjN3xcBKKaqNisFwRABJZTwQJgbf5JEKXeQADUGbEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5977
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTExLTIxIGF0IDE5OjUxICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gVGhp
cyBTRVBUIFNFQU1DQUxMIHJldHJ5IHByb3Bvc2FsIGFpbXMgdG8gcmVtb3ZlIHBhdGNoDQo+ICJb
SEFDS10gS1ZNOiBURFg6IFJldHJ5IHNlYW1jYWxsIHdoZW4gVERYX09QRVJBTkRfQlVTWSB3aXRo
IG9wZXJhbmQgU0VQVCINCj4gWzFdIGF0IHRoZSB0YWlsIG9mIHYyIHNlcmllcyAiVERYIE1NVSBQ
YXJ0IDIiLg0KDQpXZSBkaXNjdXNzZWQgdGhpcyBvbiB0aGUgUFVDSyBjYWxsLiBBIGNvdXBsZSBh
bHRlcm5hdGl2ZXMgd2VyZSBjb25zaWRlcmVkOg0KIC0gQXZvaWRpbmcgMC1zdGVwLiBUbyBoYW5k
bGUgc2lnbmFscyBraWNraW5nIHRvIHVzZXJzcGFjZSB3ZSBjb3VsZCB0cnkgdG8gYWRkDQpjb2Rl
IHRvIGdlbmVyYXRlIHN5bnRoZXRpYyBFUFQgdmlvbGF0aW9ucyBpZiBLVk0gdGhpbmtzIHRoZSAw
LXN0ZXAgbWl0aWdhdGlvbg0KbWlnaHQgYmUgYWN0aXZlIChpLmUuIHRoZSBmYXVsdCB3YXMgbm90
IHJlc29sdmVkKS4gVGhlIGNvbnNlbnN1cyB3YXMgdGhhdCB0aGlzDQp3b3VsZCBiZSBjb250aW51
aW5nIGJhdHRsZSBhbmQgcG9zc2libHkgaW1wb3NzaWJsZSBkdWUgbm9ybWFsIGd1ZXN0IGJlaGF2
aW9yDQp0cmlnZ2VyaW5nIHRoZSBtaXRpZ2F0aW9uLiANCiAtIFByZS1mYXVsdGluZyBhbGwgUy1F
UFQsIHN1Y2ggdGhhdCBjb250ZW50aW9uIHdpdGggQVVHIHdvbid0IGhhcHBlbi4gVGhlDQpkaXNj
dXNzaW9uIHdhcyB0aGF0IHRoaXMgd291bGQgb25seSBiZSBhIHRlbXBvcmFyeSBzb2x1dGlvbiBh
cyB0aGUgTU1VDQpvcGVyYXRpb25zIGdldCBtb3JlIGNvbXBsaWNhdGVkIChodWdlIHBhZ2VzLCBl
dGMpLiBBbHNvIHRoZXJlIGlzIGFsc28NCnByaXZhdGUvc2hhcmVkIGNvbnZlcnNpb25zIGFuZCBt
ZW1vcnkgaG90cGx1ZyBhbHJlYWR5Lg0KDQpTbyB3ZSB3aWxsIHByb2NlZWQgd2l0aCB0aGlzIGtp
Y2srbG9jaytyZXRyeSBzb2x1dGlvbi4gVGhlIHJlYXNvbmluZyBpcyB0bw0Kb3B0aW1pemUgZm9y
IHRoZSBub3JtYWwgbm9uLWNvbnRlbnRpb24gcGF0aCwgd2l0aG91dCBoYXZpbmcgYW4gb3Zlcmx5
DQpjb21wbGljYXRlZCBzb2x1dGlvbiBmb3IgS1ZNLg0KDQpJbiBhbGwgdGhlIGJyYW5jaCBjb21t
b3Rpb24gcmVjZW50bHksIHRoZXNlIHBhdGNoZXMgZmVsbCBvdXQgb2Ygb3VyIGRldiBicmFuY2gu
DQpTbyB3ZSBqdXN0IHJlY2VudGx5IGludGVncmF0ZWQgdGhlbiBpbnRvIGEgNi4xMyBrdm0tY29j
by1xdWV1ZSBiYXNlZCBicmFuY2guIFdlDQpuZWVkIHRvIHBlcmZvcm0gc29tZSByZWdyZXNzaW9u
IHRlc3RzIGJhc2VkIG9uIDYuMTMgVERQIE1NVSBjaGFuZ2VzLiBBc3N1bWluZyBubw0KaXNzdWVz
LCB3ZSBjYW4gcG9zdCB0aGUgNi4xMyByZWJhc2UgdG8gaW5jbHVkZWQgaW4ga3ZtLWNvY28tcXVl
dWUgd2l0aA0KaW5zdHJ1Y3Rpb25zIG9uIHdoaWNoIHBhdGNoZXMgdG8gcmVtb3ZlIGZyb20ga3Zt
LWNvY28tcXVldWUgKGkuZS4gdGhlIDE2DQpyZXRyaWVzKS4NCg0KDQpXZSBhbHNvIGJyaWVmbHkg
dG91Y2hlZCBvbiB0aGUgVERYIG1vZHVsZSBiZWhhdmlvciB3aGVyZSBndWVzdCBvcGVyYXRpb25z
IGNhbg0KbG9jayBOUCBQVEVzLiBUaGUga2ljayBzb2x1dGlvbiBkb2Vzbid0IHJlcXVpcmUgY2hh
bmdpbmcgdGhpcyBmdW5jdGlvbmFsbHksIGJ1dA0KaXQgc2hvdWxkIHN0aWxsIGJlIGRvbmUgdG8g
aGVscCB3aXRoIGRlYnVnZ2luZyBpc3N1ZXMgcmVsYXRlZCB0byBLVk0ncw0KY29udGVudGlvbiBz
b2x1dGlvbi4NCg0KVGhhbmtzIGFsbCBmb3IgdGhlIGRpc2N1c3Npb24hDQo=

