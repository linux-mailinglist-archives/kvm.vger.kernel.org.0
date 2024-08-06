Return-Path: <kvm+bounces-23351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3012E948EF4
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B13771F2584C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084701C4622;
	Tue,  6 Aug 2024 12:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y99VeHd3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1501C3F39;
	Tue,  6 Aug 2024 12:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722946716; cv=fail; b=HQwsWOJCPDU3CWAHf0/Ibmk22JUkUjZ6u6gaSUTLfGzAh2pRXnSzwFB7wwydhgkvNdILey9e/9cjzMFYeOLo3e3pKVYtr0E1dv2/aF+6a6vNooGQE5tOHPu+CjBKUe1kJkdmllH5ZM3dZks2fbI3MJCNbJCR+tlF2DqcpxhLuBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722946716; c=relaxed/simple;
	bh=kRDgA/aoXnevcX38D25nhutamFCEzLrbiknWo1RhG8g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bz0NSX1pHh35lG70tYXVbjbdG9nRfOTNi960726oi+BPEnMPqHHc2+h+DgLnBkqwyc8vG+0b28PIUxmjLP2IvnwY2W+DfNGM51eOXfetkVaU9kJ5ymLwH17yg4bVjc8YMATFfvVdkGTnR8zBy6z/4dPZrULULwYAfs/0ecTKUug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y99VeHd3; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722946715; x=1754482715;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kRDgA/aoXnevcX38D25nhutamFCEzLrbiknWo1RhG8g=;
  b=Y99VeHd39ohm45sqgWA3mVaYQWszmezPRbaJdTV9yMTfQBqvlx4niY+w
   Pgk7DTMQJYBQhF0QoOlr9WjXsMuhkcKxCqnBm/wjA5iMXHtklWJljmIbH
   lGyod+eYTOFVEcx/i/eAHp/H0G4sdCNNVONogfXE4OmiJS27oM/d5JAni
   r6CaqpUB9fT02RfLxK+YYWmwluVD1Kd+93fIt1ECmk/y06DF/5xvNn4xW
   c4Cs9bwYZ8i+un7rN3KxFFhNaiyTI4U1Mpn3eCGuUB2zp78edIGb9gd9A
   nQfBdENXDErMU2qpOK+hWX2mdWxUShCrwxsUcIfy7sacKTCvp65BOptQ0
   A==;
X-CSE-ConnectionGUID: FkWotjvGSxCYrUQ3vOPQ7w==
X-CSE-MsgGUID: a7/Iay+8R/ypv9fvTVCx5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11156"; a="38463069"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="38463069"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 05:18:34 -0700
X-CSE-ConnectionGUID: VArkHB0OQE2B5vmUUZh98Q==
X-CSE-MsgGUID: cGbL0PYVQ3yo+W8Um+my9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="56380993"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 05:18:33 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 05:18:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 05:18:33 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 05:18:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X3HkESBVEATW79iMZyQKzMJ6gUcSkhr3lhw8WlZqx6hl4K0eU6ygFFOV9bGsFLxX/lxcq5DGOl1JLuxsSlGfZetTTwutxXazDTMYsloH8CnfObTzkPRN8WNqQ449cW6i/KHALiJIEe0phNaQckMvvokdowVuj8Hf7XoMtJPUMMVVtvWWgoZLy917xGCc/py0JYYWWhShkN+hDSa4jEiZbgveKi/A8pXGr2bNUCDDEWMz6xZoD0CujSUibMxWghDfOyObuondbWTb7UcusAKzu8g2I5Gz9LtTx3z93D+yC6DHkyh6IkSkWPvGs4ZSaECAsXxNXMceMPUGJjhrog1a7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRDgA/aoXnevcX38D25nhutamFCEzLrbiknWo1RhG8g=;
 b=YgL4ViQeXzAyHUeOJptG5j3t9Nye73VgMotutJ/4nCDlZeyhuQsc36bzDDBmrwWc/sEuvOgJ/V8lOh0qcr4+sLa4Eb8syWaifIbIwuiuJzUpb5lYPWWV0nJxtKBwPgsANn515CuVBMgfkTfv1BTaKWx9D7qzWkinek1esqkOxV/RqMTQ06vSlXfsbuvRkt5RQ4gxcziZ42SQzYMV9KeIp4doPMbAiJQNlda2YmAnuExBXUYZdpCOaDP/iCnRUKwOVYas2+y/zQpPo5Fzwox/yDOtkH6Kyb9FjDRcbml/+xf4ycjAXaIvcI3DE3ESr49R3baFfYh8M7lq+DVqg0MIiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB7627.namprd11.prod.outlook.com (2603:10b6:806:320::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Tue, 6 Aug
 2024 12:18:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 12:18:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 10/10] x86/virt/tdx: Don't initialize module that
 doesn't support NO_RBP_MOD feature
Thread-Topic: [PATCH v2 10/10] x86/virt/tdx: Don't initialize module that
 doesn't support NO_RBP_MOD feature
Thread-Index: AQHa1/rK9HyHuA1nvEqit8kR1l5WVLIZyaWAgAB73QA=
Date: Tue, 6 Aug 2024 12:18:29 +0000
Message-ID: <cc6e40872469ccfc58e7648f12bba5a0b1a54c65.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <d307d82a52ef604cfff8c7745ad8613d3ddfa0c8.1721186590.git.kai.huang@intel.com>
	 <66b1aca950924_4fc7294f2@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b1aca950924_4fc7294f2@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA3PR11MB7627:EE_
x-ms-office365-filtering-correlation-id: ae8cd401-104f-45ea-5b29-08dcb611e1d8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?N0k2QlhWUTh5ellydjZ1SnBPUE5sK2JoWjZLNVowSmZ3a2hNSThGZkZYSWRS?=
 =?utf-8?B?a3dvcmlJWDNPV2owVEJuL1Mza1EwZHRTRVErSnM2RFdvcHlIaTR6a2NJL2g2?=
 =?utf-8?B?bGhOT1V2RWdJLzhyeXc2UGdKeStuSldzTlJBcUJnTS9McVAwT0R4OE1Zd1VW?=
 =?utf-8?B?ZzBEZlNzRDJsSjhUNDZYMzE2clVSUVZwTXNPTGlBQ0Y3L2pBYlV5TEU2N1dh?=
 =?utf-8?B?WUxOV09GUHBHQTZiRjZqTkt3dllUMFJEQUgvN1RLb1EzemdPSVg3ZzFRS0du?=
 =?utf-8?B?dzVVb2ovbzgvY2x4MzJMaHdtbWpaOTF2WXd5L2pQajJCdUNDK1VncjZzSkpp?=
 =?utf-8?B?bFovL2ozUU5FQlpxUEFkcmVuMWNFS3JJOWVjNHJVeUJmVktUQS9OdnRqQytJ?=
 =?utf-8?B?SWt5bXhOVkFKNE15dGVlb1BXbWl2emtoYUZOVTBRaTQ1bVVZNnA5M1B2a2oy?=
 =?utf-8?B?NDNJSk8rUllpMjJlcTVCbEpSaGhmdkJoZzJvM0xjR0FTMGJyS1JlWnV3Vk5O?=
 =?utf-8?B?NFJNNHowOGV3ZkZlMTlyV3VpTkZjdk14LzlLczgrQzRqNE83REJXOVRCTmtD?=
 =?utf-8?B?UGR2aUZLakgvSTdtQlpYcGdydjJmWGdlMW5zc05ibHZKc0pPb0NKZ1JZWWk0?=
 =?utf-8?B?bFUxSEs5SUFoR1VIS3lmdHB2SVMyQXdkR1ZHUjlCeWk0Q2NES09GUGRvSkxI?=
 =?utf-8?B?QWxIcC9GZjN2eFdOOTdBTWhBc1lyRjFWcWRqdkYzaHdjVEdLbE45STgyY3JY?=
 =?utf-8?B?anc5a2c5L2NXU0NWTm9oMXozeUZ4QXJCdnpPVVB0YlY5SUYzUkpoeU96RWFW?=
 =?utf-8?B?dlh3WjcwSFZ1cEJvcmZsSFg2dkIyS0p0YlZQbmFJRC9zRlcza3ZJRXI5N210?=
 =?utf-8?B?TWxhc2VHUVRVbHJjNGtpTGRzMEowNytDbHZjKzJIbWNjNEM3dlRWYnRiVE4x?=
 =?utf-8?B?cXd6dHlTcDcrdG12Yk4xRGtrSzQyTmIvbjhRQVRraysybytRM2o4MDVDQXBG?=
 =?utf-8?B?UmFuUTZTMnA3dE5mUU5FQ2UvOUVFYU9SZlNtOERocm1CQTFvZE15aUtaSHBV?=
 =?utf-8?B?U1FkNTl3d2FUWGFRT2wzeUhSN3RFWlhMVk8vZlFOTDc0ZkNXMklZMTdYYmJq?=
 =?utf-8?B?UWtSL3RMdXFkQllxYzlFeTZIRVhqNTBuNzhlM3JDc3JxZlhRNzV1UGJVOWY3?=
 =?utf-8?B?eGw5RERweEVyTnNtNTBwelY3WWxXT3NMeUwrUTZXTnhLZWZJTkZTU3B3OGIw?=
 =?utf-8?B?VGFaVzgxaWNCMWRrc1V1OWNNRDlqeWJVeFlRUXJ2SUJXYjhEUUc1TDhFR2RL?=
 =?utf-8?B?cGJkTnAxdE1QNlB5bEE5WGNJSkE3Tlk2blQrM1dwZ2JkTWlVc0xaVkZqV0VZ?=
 =?utf-8?B?eEgvd2N1em5GT3ZnSFhVdGdGNjhHR2NzaVM4WlE5MGpYekFKK0tNUWFxOXpI?=
 =?utf-8?B?WVIvM2VEdVZvbUllYTdGL1BWcmxOL3BmbW53eWdkMmloRW02a1hETlVFZm1X?=
 =?utf-8?B?V2Rzalo4Z1pxQ0tJdU90U21wR09FdEF5MTkxMGE1cVZXSGFzc2JOMGJMdHVv?=
 =?utf-8?B?ZHA5NklZOHNoVm5BUXlLY3d1bkdnekV0MDNNcC93amdKdmlwS05TUDVXUEk3?=
 =?utf-8?B?TVVBMlhKalMvSDR3NFVia3loT0xvZTgvalRqNWdKdnlzV0lVQWxuOUVJVXh5?=
 =?utf-8?B?cjB0WjdOVU9Fb3FhNHZwd1FFMVZHWUNrb2ZSaXlweVRyeXNLVWZXRGJmZHQr?=
 =?utf-8?B?K0JRRmdHZzNTeDd2cE0yN1FTVzFPMXJqcTJvUW5oUytvN0U2bzhqRk9nVHRq?=
 =?utf-8?B?TllKZDNWd1d2dlV5dlUrNE50TWNxOERzSm5zaUJhSlh6S3RnQ2Npa2JrSUpW?=
 =?utf-8?Q?fiT+qiYT9zr7o?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2RBNWZ4MDE4TktQbkxlRzBONUtHeGFqbmgxVktubTRVK1gwdWtRdHdJbWdr?=
 =?utf-8?B?N0xyTFFQWHBnUkRnN0pyRmtScUZMaFU1MDhkWjc3bWxFd2lhdVo2WWpmT2RJ?=
 =?utf-8?B?Q3AyQ0JMd3J3djFpUVI5bWFRVW9aNzlHRnNFRHd2MWFGSy9rclh1K0FxcWpq?=
 =?utf-8?B?TG11Q21JWU5FM2NNSWo5OUVaTGhOOGVhVGMzaEZlLzlYR3VJUUt3VnBnclVF?=
 =?utf-8?B?UStjWWlyMGluNnN1dTUvTExrRC92ZElMK2VlY0ZTc1FuWFk2OFM1eDk5NU1a?=
 =?utf-8?B?S05xMjdCcXg2aVIxMFV1cjgzL3BkRzJtRXQ5NFZMbEpXd2twRDVJVTVIb3Zw?=
 =?utf-8?B?dktBYkZ3bG5NSkdZa2FHbWNZZUlPb2dUTXN5ZGdEK3pWMFU4NFFDcGVnNlFW?=
 =?utf-8?B?dmdBaDROb3JBaGw3Z2pOT0R1UHZlWXZYVFIwTjVlQlRpVkY0UjZNK0M3R3A0?=
 =?utf-8?B?Nzl1dmt3d1JrNVlTSE9CeUkvUWR6TkJrSjVISkhaMjdZc3NTNEwzbWQ4bGdn?=
 =?utf-8?B?Vkoyd1A1MmNqekh0bVRuZkNsaXNuS1JXU1FqanQ5UlNqbkE1N3lZUGJsL2Vv?=
 =?utf-8?B?dm9mRCtrSVBmcU5FNTl4SzA4SjFlVitnaXNiUkJDT2g3azRsSEx3WE9BeEo4?=
 =?utf-8?B?aFZtcEhNeExYblphcjB1eG1OU0hrWjFxckJ0RGh0bVJ0NHJUWGk1SDhyTUZD?=
 =?utf-8?B?VXExc1EyS1ptKzJvVzhtUTNMbFZKa2xiUkRuQWk4TExnVEtvdThnNWhSOUhN?=
 =?utf-8?B?VS9QbVBpOUVoVjN1cElKell1cDJQUndzLzlKZlRiekhhRUFRUXo4Z0FGMGVM?=
 =?utf-8?B?N1hQWjg4a3V3L2xaUFRwa0hQV2Y2dUlVemFhWmtFL3hrTVFjSHBlYlNDTENS?=
 =?utf-8?B?d3pKZGZGWmFCZ1V0WE55Y1BFaVJsTEhJZExOQTVqV3Y0YlBSODdid1N5SUhH?=
 =?utf-8?B?R1B0TG9SUmZQNXVzTXJQYnZIWXhxT1RybXBiSGxuWiswZHczWUJZR255UW53?=
 =?utf-8?B?VTcvNC9sVzAySkplVHRJQ1BOMU0vYnhoOGhrem5QbzZEVzBXczRTeXdNa0RM?=
 =?utf-8?B?TEg2MXd4cm9IVXVuRDZxdXFMZGtKV2tSOVk1Q3M3eTNEVGg3azFCUkVXSk02?=
 =?utf-8?B?REhLTTZQUEt2MmZMdTdNY2ZDQU1ZWEQwSjZDK2NhU0tnS2hXbmxRclV5ejJw?=
 =?utf-8?B?ZmQ2b2VRQUNzbGlRS2ZLSXhMWkxCS1RTTGZNcTI3TXF1MktVcWtZYkNwUWpQ?=
 =?utf-8?B?WUlXaWVsMkJISHZOR1UxOVRmOUdkQmtIekV5WE5DL25zenJadVNQM3Ewam9O?=
 =?utf-8?B?Qlh3MTJLVkJqVVFiL05EKytsbVdoWEpNVGQ4NjRoTy95QUdqWGFBcDUyaFZJ?=
 =?utf-8?B?MVpSZFJyOXpoU3VZYjFoYkVwOE9qVjQyVEwycHdLVlIvOTMwZVlOOGJZZmQ2?=
 =?utf-8?B?MHhsNzZLdGd6Y1E4MFFoQzFhQmh3VmZWcXJzUlgzUnpNL1FINEw5Q3dvWUNo?=
 =?utf-8?B?V212UmpTa1pHZUI0TUJYV014aEtYdGdXd1lvbVBseG81TUpnWE1QRWFRN3BF?=
 =?utf-8?B?eDM2My8rWHZtaWwxL2ZtWEtiY01NUG14RnplVU82WXJocGdIRVgyOW1wMnpE?=
 =?utf-8?B?QXpvYnpxd3EwUVc5RWxmcXBaWTVDMFVCc1BGaDBsbEJCN0pac0F4YVpPQ1Ns?=
 =?utf-8?B?TWdnSys0NVNTM081dmtuclZNMlZRTzFOQmFxanRtSjhaTjJYUXZ2YmxlRG5Q?=
 =?utf-8?B?ZGlrOHVNZmVtQzdXZzZVT2VwVlhmNUNud3dxd210d3VTM3RsUVVkdDZrbzJ3?=
 =?utf-8?B?eGcrUDdzMExUVDF0dTcwRzFGTUNzU2N6Q1BHaTFQQjgzWWJWTkxaM003TjNO?=
 =?utf-8?B?OTk1MEtRVlpWWENjQjUzOFh0ckd1anNNcEgvNmo4MDJqK2s4eTlhNE1CUUpI?=
 =?utf-8?B?blMwMGVrNitIdElTcVVmVjZ5SWN4WTZtTjh1RVlhNnRxemNTS3l0VjRvL1ZF?=
 =?utf-8?B?Y0tVV2R4aWsyb0VoWWlKblRCeXdRNDBualg0WUs5R0NSaFU2a2hqc3JxSGoy?=
 =?utf-8?B?eEVJMHNaSnhDM0I0b2I0dzBRTi80aTAwZ25GZGxGRWNhQXRWQzRqdmNjRFlY?=
 =?utf-8?Q?ugiOZm3rmaGFfkWS0Tmv7Q71A?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC9ACC08F607CD4BA26C95933E134930@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8cd401-104f-45ea-5b29-08dcb611e1d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 12:18:29.9143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H4rUkONLmRka8cHjB64FAKUrKi+Muyn7aeAstIPb8SRlxoN9O6OYH4n8Gwm2S07XnQWPRmjlaSCqP2YWbA05tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7627
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTA1IGF0IDIxOjU1IC0wNzAwLCBXaWxsaWFtcywgRGFuIEogd3JvdGU6
DQo+IEthaSBIdWFuZyB3cm90ZToNCj4gPiBPbGQgVERYIG1vZHVsZXMgY2FuIGNsb2JiZXIgUkJQ
IGluIHRoZSBUREguVlAuRU5URVIgU0VBTUNBTEwuICBIb3dldmVyDQo+ID4gUkJQIGlzIHVzZWQg
YXMgZnJhbWUgcG9pbnRlciBpbiB0aGUgeDg2XzY0IGNhbGxpbmcgY29udmVudGlvbiwgYW5kDQo+
ID4gY2xvYmJlcmluZyBSQlAgY291bGQgcmVzdWx0IGluIGJhZCB0aGluZ3MgbGlrZSBiZWluZyB1
bmFibGUgdG8gdW53aW5kDQo+ID4gdGhlIHN0YWNrIGlmIGFueSBub24tbWFza2FibGUgZXhjZXB0
aW9ucyAoTk1JLCAjTUMgZXRjKSBoYXBwZW5zIGluIHRoYXQNCj4gPiBnYXAuDQo+ID4gDQo+ID4g
QSBuZXcgIk5PX1JCUF9NT0QiIGZlYXR1cmUgd2FzIGludHJvZHVjZWQgdG8gbW9yZSByZWNlbnQg
VERYIG1vZHVsZXMgdG8NCj4gPiBub3QgY2xvYmJlciBSQlAuICBUaGlzIGZlYXR1cmUgaXMgcmVw
b3J0ZWQgaW4gdGhlIFREWF9GRUFUVVJFUzAgZ2xvYmFsDQo+ID4gbWV0YWRhdGEgZmllbGQgdmlh
IGJpdCAxOC4NCj4gPiANCj4gPiBEb24ndCBpbml0aWFsaXplIHRoZSBURFggbW9kdWxlIGlmIHRo
aXMgZmVhdHVyZSBpcyBub3Qgc3VwcG9ydGVkIFsxXS4NCj4gPiANCj4gPiBMaW5rOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvYzAwNjczMTktMjY1My00Y2JkLThmZWUtMWNjZjIxYjFlNjQ2
QHN1c2UuY29tL1QvI21lZjk4NDY5YzUxZTIzODJlYWQyYzUzN2VhMTg5NzUyMzYwYmQyYmVmIFsx
XQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4g
PiBSZXZpZXdlZC1ieTogTmlrb2xheSBCb3Jpc292IDxuaWsuYm9yaXNvdkBzdXNlLmNvbT4NCj4g
PiAtLS0NCj4gPiANCj4gPiB2MSAtPiB2MjoNCj4gPiAgLSBBZGQgdGFnIGZyb20gTmlrb2xheS4N
Cj4gPiANCj4gPiAtLS0NCj4gPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIHwgMTcgKysr
KysrKysrKysrKysrKysNCj4gPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIHwgIDEgKw0K
PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4
L3RkeC5jDQo+ID4gaW5kZXggM2MxOTI5NWYxZjhmLi5lYzYxNTY3Mjg0MjMgMTAwNjQ0DQo+ID4g
LS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5jDQo+ID4gQEAgLTQ4NCw2ICs0ODQsMTggQEAgc3RhdGljIGludCBnZXRf
dGR4X3N5c2luZm8oc3RydWN0IHRkeF9zeXNpbmZvICpzeXNpbmZvKQ0KPiA+ICAJcmV0dXJuIGdl
dF90ZHhfdGRtcl9zeXNpbmZvKCZzeXNpbmZvLT50ZG1yX2luZm8pOw0KPiA+ICB9DQo+ID4gIA0K
PiA+ICtzdGF0aWMgaW50IGNoZWNrX21vZHVsZV9jb21wYXRpYmlsaXR5KHN0cnVjdCB0ZHhfc3lz
aW5mbyAqc3lzaW5mbykNCj4gDQo+IEhvdyBhYm91dCBjaGVja19mZWF0dXJlcygpPyBBbG1vc3Qg
ZXZlcnl0aGluZyBoYXZpbmcgdG8gZG8gd2l0aCBURFgNCj4gY29uY2VybnMgdGhlIFREWCBtb2R1
bGUsIHNvIHVzaW5nICJtb2R1bGUiIGluIGEgc3ltYm9sIG5hbWUgcmFyZWx5IGFkZHMNCj4gYW55
IHVzZWZ1bCBjb250ZXh0Lg0KDQpZZWFoIGZpbmUgdG8gbWUuICBXaWxsIGRvLg0KPiANCj4gPiAr
ew0KPiA+ICsJdTY0IHRkeF9mZWF0dXJlczAgPSBzeXNpbmZvLT5tb2R1bGVfaW5mby50ZHhfZmVh
dHVyZXMwOw0KPiA+ICsNCj4gPiArCWlmICghKHRkeF9mZWF0dXJlczAgJiBURFhfRkVBVFVSRVMw
X05PX1JCUF9NT0QpKSB7DQo+ID4gKwkJcHJfZXJyKCJOT19SQlBfTU9EIGZlYXR1cmUgaXMgbm90
IHN1cHBvcnRlZFxuIik7DQo+IA0KPiBBIHVzZXIgd291bGQgaGF2ZSBubyBpZGVhIHdpdGggdGhp
cyBlcnJvciBtZXNzYWdlIGhvdyBhYm91dCBzb21ldGhpbmcNCj4gbGlrZToNCj4gDQo+IHByX2Vy
cigiZnJhbWUgcG9pbnRlciAoUkJQKSBjbG9iYmVyIGJ1ZyBwcmVzZW50LCB1cGdyYWRlIFREWCBt
b2R1bGVcbiIpOw0KDQpZZWFoIHRoaXMgaXMgY2VydGFpbmx5IGJldHRlci4gIFdpbGwgZG8uICBU
aGFua3MhDQo=

