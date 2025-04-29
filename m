Return-Path: <kvm+bounces-44628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E76F5A9FED1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39FCD7ACDD1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 01:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCD217A2E2;
	Tue, 29 Apr 2025 01:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZZ6jzlJE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEEE367;
	Tue, 29 Apr 2025 01:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745889096; cv=fail; b=vClSCYC9ykPz88ep+YtujkKzmCtNMLONmBiJap/C0Y+RROdxe7QWRM15zyjHXlIYZLVrSIRtYRDsoDAKCbUAFTqmtPQ51B1kK1QTDjvnOHC95NUty7O5AuR4DiJW7Vk8eDZJhTE42nq2MCsOzEDoTsGuGpqJBLogE6CJIyzHSGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745889096; c=relaxed/simple;
	bh=ZGJ90nk9FNyd5aE6qCg7H3lktCAg+9qXKZ9ycWs9Pwc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vz9OzCnWBZqB+1czn/Hc9H6Q+mPwv4Wj6F2JVXW0wLmeMrBXMvjUTWaDBmNtXaO4wV9tzkz3IsfQ4rfI7c/cCCjJX25PEiUZT2tAi/jVjxl93madG7W+Ac6DDt16G+gBGj8sB+0CnQepc1h+x6JG14eu8sRhRrE5QkEEX23gb+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZZ6jzlJE; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745889094; x=1777425094;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZGJ90nk9FNyd5aE6qCg7H3lktCAg+9qXKZ9ycWs9Pwc=;
  b=ZZ6jzlJEH4uKVS9aBUjGA/55yxJ34bAcVdjHMcpiPalD5xR33DMETawF
   +jUPOdQD226XLHQD2YFuUT/7qIC0hlMlfOr7Gdr3W+tglsSGKj8ITRKUz
   6NDa9zKQIpN3k7VgTjLIg7Ir1Ly03JUzQIxDvU4qXqzCrlmhLGn0WPQ4a
   d6e8MymmclqVMdh1wByA+vdYZezFeV4EEghAhy5QOKTng7ITm91ZOuNDu
   eyLmpU7S14nHndgiSD/3gzjaZZ9N5uKl2ELziN5kV8E2gS/fWsS08sCcR
   EvlmOWzuZxoTeMbtoBaiU328dvVyNRo5ZYSdzSVwv26hJ9nVZgF4rkirt
   Q==;
X-CSE-ConnectionGUID: 4tgLO9R5SjOwjKK4PSi8Dw==
X-CSE-MsgGUID: l+NpAshQTkWIoMfceBg5hQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="47407584"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="47407584"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 18:11:33 -0700
X-CSE-ConnectionGUID: PwQlxMbXQhuBl8GglAKkcw==
X-CSE-MsgGUID: WStP35LWT1a2IqxH7rf9Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="138667284"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 18:11:33 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 18:11:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 18:11:32 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 18:11:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=guWB94+S9KMZrCkrXPgQCfsaeeImYBPg7lpjzhidM1BZrF/EcAkgJasjwJIJCn/mttZ2H8hOvpyx4sPC/plS7nENWAkr1tnqiuKbZtS5mUGLnPLTyjK2YSbPtPTY5qyJxv9B0FfVfJCnz/eYV0Fy/PsK6psndHUwbccArn9TYzEoBr/DpRRVUQetIOUjeLkoe1KU4cnDTuSfSnzSeJlz5ZyS39qNuL02ArQigBNxpC6TDDjCg1uCboJLS5vIWCFTX7GhlNr48ikKIaxiS5CnK6oqoLdt61GhRjmLKYG7krwQ3UKbzXqLXZQC9j9+y/95aieXhRqdKoG9yVI8d/4X8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIijzd7dzonyW5bxeUvqKLyQf0OTWhPRg+CCfbGDgyU=;
 b=LKue5XLd+XLSvlVX4NUYJmk3WezZ8TBvq5t39jJXo3czWlKPzeR1LvS8gsh4D6tS3RubGmFqMA61eAj0MTo3zo/J6Vsk19AgueDomlmksHX7DcrNEy+JLRLEXl988UY5MIrL4ad50IQllm/+ZBYRQiNe6OziToAgA3cMlqPAISZ4ZulqGBlXTeoYtjbGC4PFATlFtrdTEhGZRk2vGE9am3vrEJuNQwWZlx/eFlfc35EO8fI7gGeKq5b0wijxgSRljNxsE3oHlFWpAQR5E7goMDZpn5nel9+C0yHAhtZ4eVTxRrB6wqCtous5ApgunEji+DoytkwaVS5Td+Tosdj8oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH7PR11MB7477.namprd11.prod.outlook.com (2603:10b6:510:279::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 01:11:29 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%4]) with mapi id 15.20.8678.021; Tue, 29 Apr 2025
 01:11:29 +0000
Message-ID: <9925d172-94e1-4e7a-947e-46261ac83864@intel.com>
Date: Mon, 28 Apr 2025 18:11:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ebiggers@google.com"
	<ebiggers@google.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Spassov,
 Stanislav" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "vigbalas@amd.com"
	<vigbalas@amd.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "Gao, Chao" <chao.gao@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "x86@kernel.org" <x86@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-4-chao.gao@intel.com>
 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
 <aAtG13wd35yMNahd@intel.com>
 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
 <aAwdQ759Y6V7SGhv@google.com>
 <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0064.namprd07.prod.outlook.com
 (2603:10b6:a03:60::41) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH7PR11MB7477:EE_
X-MS-Office365-Filtering-Correlation-Id: e041f4a8-1fe6-4d4a-e22a-08dd86bac543
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y1lwYVEySHNxcFA0bWNKTnpxQzdReUVXMHNxRGlLS0FhZjUxTUtWU1RtcXpP?=
 =?utf-8?B?ZC91ejFvK1ZJRjZYMWRPU3RRaDV0cHR0WGVZWHd5cjR5UzBvMTFKQ0h1VWdy?=
 =?utf-8?B?OS9YdlhtUEN3TjY0V05Sb1p5VjVITGJ1YWc1aEpRL1crcnVPVm84YWR1bjlP?=
 =?utf-8?B?WHRYaGNsRDdPbmhDTnJiMWQ3ODJVWVc5Z1ZqczRjUDBMU0JZUWlGamhsbm4x?=
 =?utf-8?B?VWpCMUIyWWl0TzF5Z0pkQ054cDBNZjk3dC9xWDB6T1dLZzY3bU5rdDExU1Nt?=
 =?utf-8?B?anhNTkl1WjFvMi8rZHhJcWpVbHE4S09ITldnZEFmODM3bUNUcERjYjFDbVBi?=
 =?utf-8?B?WjBDZm8yajZUZkVCWGN1ZmR6ZmpQT1FranFmZjZLdzE5eXl4MlFOcTk0aVpW?=
 =?utf-8?B?Z3B1NnlFYURVYzZrYmF6Z1NHOEJXeUVzVklRdzlXaHFsS1NuNWNjK01nSXNw?=
 =?utf-8?B?UFBQWjhWOGpOYkFTRmRveEl6MzVGUWhHYTBJekExUjAxOXdIVGlncjNYWHN4?=
 =?utf-8?B?aU9qd3JxRWR3elVmTC81akdCUGxIL0pZVTkweDhadXJGVGFjeGVmK3ZyTk9N?=
 =?utf-8?B?QWd2dDZFWFh0WWxabjdLOGtYSG5ObEVFMUE1NHJGWE5naTVCcXpKRTladUJa?=
 =?utf-8?B?cU1UeDlJdjNLNGVveUhheDh4d3c1KzhmK0NRUUVnQmE1N2NYeXFZank2bENB?=
 =?utf-8?B?eDJYUm12c0U3T2N3andocFZkNURhcS9tM1hYNitkNXJpMGNjVHNEUkh3a1Nh?=
 =?utf-8?B?R1dabjYxUTZ0cUlYY2wxTFRyY200bUlreC90MStyUm5lSmg1TmpzRUxVZjcz?=
 =?utf-8?B?VE0rbFpORTU5WkVOc2NjNTY4SmxNVEhZdEZrWG9MMnJxRE1tTkZrQ3hKaWUy?=
 =?utf-8?B?bThUTWNZNVp2aGxJY3JkSFE0NXlGazF6QXVVOWdCUHNmMjhJb0FYakJuck1L?=
 =?utf-8?B?Um5FYVlBT0VJNVJTWUE3cWc0UndpN2FscVA4K29ybkg3QlRJVG9QUzdTMXg0?=
 =?utf-8?B?YllLR1J0NFpYS1Y3Vy9qdFZUMm52cmY2ZXdlblRCRksyQ3FXSmlqNWYyTEEr?=
 =?utf-8?B?OXRyUnMvbFpwNlJGQm5TL3BzVzVZQ1JXVldYWU82cWtka0dxYXlJeHRpM0Nn?=
 =?utf-8?B?c0xHdTNiTTl2eUFXcVJPbkh4QjU5YWlRbTEyUnhWTVlLOG90RENXbmNxRFlq?=
 =?utf-8?B?bFNsbVBYVWpDeHgzZGN0elIzWG9tRndFd28rZUkwZEoxOGtya05ZL1Jsd1Ny?=
 =?utf-8?B?N3JyY1ptVFdTb0ZwZ0ovRG1oa2lSVElFVmcrY3NKNXQ0YzhNNE9iSnZxS2Fn?=
 =?utf-8?B?c3owdGlRWGFybEIxRDk3T0I3cTRRbHJjNjBuZkNnUVNlaXUzVkYrWm01V2d4?=
 =?utf-8?B?R1Y5QlBnejFCSEhtSXVVTTJLaFd5ZXlFMS9kNkJ6Z2NuejJBVE5NeUk5RWMr?=
 =?utf-8?B?am9WOEJNV2xJU2dvVnphVkdzUWhxYU9YYXlpZWxLb0JwWUlkU1JYN3R2aUVE?=
 =?utf-8?B?K3h2VkI4YWxoNU9WQVJnSHNnbVdHeWJXQmVwWkdLWWZmMlpLOXYzcWdYRndY?=
 =?utf-8?B?em5KbCs1aE9SZlNuVGNPdm0rYXVkSEdVZTFFeXd4R0hGMUdBRjQwY3ZqbitP?=
 =?utf-8?B?M2VuV3Awamk2N1o0S05XMzVpRzNqbWVsK3RqRWRtcTNORTRsZUtMMnVadWIx?=
 =?utf-8?B?ZHN1WnlnYW1QRmpMK0J0YnlIaS9MM1NqenJiM2Y5bGhocmhFMDA1MElrV3k2?=
 =?utf-8?B?SFVnVWh6UVRucXQ4Ym1MU2k2Wm56dCsxMWJpVTB2VXRqa09TZHhnNjNWNkQ1?=
 =?utf-8?B?a0ZKV1dKcFViYi9kOE5raFc3UHN4Q3VqTWJrQVI5YlBodU9JbCtMWWlwd1J3?=
 =?utf-8?B?Q1BqYjQxU2FUa2ZWVy96cUk2M1R0aEJOaWtYMi9lR3c5Tmc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2MwckcwL0NWbm9DQkxOZzJLeVVpZzlhcjB5RHlXN3Z5LzZRTmpIV3k3Y2VW?=
 =?utf-8?B?akpFUEhjMU81NGh3V0xET1N5RFM0OTF2c2RtNCtEOHd2L3h0ODhPMXpjcEEz?=
 =?utf-8?B?SjJhOEZabEwwMXo4SFI0ZllDZm5SZU9RSDQ4QkthK3NzbDdueHJZZEFWeXVi?=
 =?utf-8?B?SG1aZzJkcmhMR2lLS2FNTWxTNmswQUtnTzI0cklXdDdIM0hxOFNxcUgyUUhV?=
 =?utf-8?B?VFdNQThQMFlYV3d1Ujh4REkraEM1N3dtUitvNG0remZLQ2VRUW12WmJhWksx?=
 =?utf-8?B?bHFBSE9NMDUrU1JZNHp1cytGdXJHM3UwdktRbzY4YXdRUThTNFJRNjdaWHg0?=
 =?utf-8?B?NG5uM1V0NVE1Lys4ZmlGK002TFYrMnZlVmYxazlkNnR0bFR6OG45Q0lSbERY?=
 =?utf-8?B?NkkyR09xMnRWVFdFWUIzbGx5Qis0NHR3RGxkV1FSZGFncjNHUFNSQlp4ZFdX?=
 =?utf-8?B?UVNMUTRnQVNJV3hKeWxqSlRBVE5VQmhYOWlFV2dxckcra3JIcXlLWUF1Tnds?=
 =?utf-8?B?STQrNEFjdkVzV3JzUWZ1bHJZUmpsK1VjY29XLzljWnRlRTA0ZmR6ZCtBMmFJ?=
 =?utf-8?B?K1grenNtMVRCTkttZW9rT1RYcDV3MHE0QUFxYks3OVRRUVRmMGZhL1ZYMTdy?=
 =?utf-8?B?dE84dlVHN3h0RjR6MTBEM2F6bDRPV2pZbHlzNWp5eGZsRjYvL3dDOHdaMXNp?=
 =?utf-8?B?OUJkM1ZKNW44cUIzRHplU0FRMFVENVdqTXV1cHJPeDdWUkhIMHYyV2k0ckpE?=
 =?utf-8?B?NWxDYmcrV1lmNkhhQ2ROcjNDZUJKWGs3Y0lMUDMvL1NlL1ZmMEdpUis1Zzh6?=
 =?utf-8?B?NVprbFVWak1DYnV6Qmt2Wk1nZnNURXM3ZVRPdGdGWjN1VE5hcFdjaEZ0eTlL?=
 =?utf-8?B?NzNFay9zL3NRRjFJRXhkOURjanVhZVR5UzU4VGxKMTVQdDFpd0trdk4yb3ZO?=
 =?utf-8?B?YTZaL2s3elZMNmVQNFRzRk4xbkFPcSt5T0RrWnQwaGk4YVZhSnBZeDNUYk1x?=
 =?utf-8?B?dVIzdy9IU3NBSmxlQjJ2OTczV0ZibFdvdi95cnV3azN2Nk9ONldoNC9WOHJR?=
 =?utf-8?B?ZWQvZUJmWEFndlE5OXRKRHczYk5XSkVQbkw5Tm5WL2lyby9Qa0ZOSkpwd2E4?=
 =?utf-8?B?ZGkzTFh0R2RRWjg2clg1SEx2MzhIYWFIV05GQjdLc29UUnZsRkFORkpPaFl2?=
 =?utf-8?B?MjBwaEwrL2c2STlDL1kvRFJyTGIzT0hHL1l2dW9UREx4eU9xbVhQbEtDdGhh?=
 =?utf-8?B?NUQza2lsS0t3QjRxVVBtOXlROVIybkdvUlJyUWNJNHRlNUpQNGRHemFDTFVN?=
 =?utf-8?B?b2tHUE9XcmwrVlJwNVkwRVlUUFRFcksySHNWZ0lhR0ExdTQrcEdlci9IRDdV?=
 =?utf-8?B?cnJuaER0K2RiRzVSdjVOMkQva01GdDVDYjZKM0ErZkQzdFNrbVpTZHl2TU1p?=
 =?utf-8?B?dkk3RHhBZWxTZXUwZFV6QmRRNkJpN1RCTUh2TVI3MnozWU41NktBOU50RStl?=
 =?utf-8?B?Wi9KSVY0Q2JTbWQwVzlldlA0RGNuMmxlVDhJeHd0V1VzdnJid1pOMHdwbjlU?=
 =?utf-8?B?c0tpakhobU5zd0RWcjdHZ0NZZUJjR3RNYXFhMG9OSGNEM0xDd0RkRTNXNnZV?=
 =?utf-8?B?OUd2eXRJU3JvMjIrQmhvaURUMzcxdEdaR2ltZlFzL01yZVJqS0U3WllVMVdI?=
 =?utf-8?B?UG1DaUg1bFVHb2ZDM1lZK1RkSVRzRnVNSXpTcDA2b00rWFpPUWhaSDNCQzFW?=
 =?utf-8?B?d0FzQkdyZEdoNGkzQ2xLeVdvakZBeWMySVVHY2FBRGRYMWd1QlBod3JFbThi?=
 =?utf-8?B?TWZucTZnbHNxSnpKbVBrRVVDRHRFcWdLck0zcFp3di91SXdjQmdrdE1FcDlE?=
 =?utf-8?B?VzdRMjV2V1RSb0VBdWtVNFA1UG1EUEhIQXVxZ3Fvc2ZrMkVPZk5RZFJqN1Z3?=
 =?utf-8?B?dEc5VmdUTnNMWTdidE9YYzQ4VVRncGV1WGZhbWNWclBxcVJHYVNMVTJiUCt3?=
 =?utf-8?B?dHNvMm05SzlwYUNQdTM4T3dZTTdnM2V3d0VxT0hoNXNlZGd3YU0yOUQ0aHVW?=
 =?utf-8?B?eVYrQU5ZbnJ0UWFhM3ROTEZ0bm8wZ3RzdS9mQmdvTzcrVzB3eld4Wml2bGQ0?=
 =?utf-8?B?TEJEU0MrWEJubzdUelJYVnFVUkV3Mm9hM3IvbEF0VHFiSHVSTmwxUTFSdnJV?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e041f4a8-1fe6-4d4a-e22a-08dd86bac543
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:11:29.0480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHmTZ7h9I5VrRuyRGBO99OyyNAEStIYtymKArDyXwUURxpS7JiXsKVTBdR/qwvmfBWDOhp/gPMY3amUQ7MZZU0xnW6nTYIX3d1L7uyTy8QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7477
X-OriginatorOrg: intel.com

On 4/28/2025 8:42 AM, Edgecombe, Rick P wrote:
> 
> Right, so there should be no need to keep a separate features and buffer size
> for KVM's xsave UABI, as this patch does. Let's just leave it using the core
> kernels UABI version.

Hmm, why so?

As I see it, the vcpu->arch.guest_fpu structure is already exposed to 
KVM. This series doesn’t modify those structures (fpu_guest and 
fpstate), other than removing a dead field (patch 2).

Both ->usersize and ->user_xfeatures fields are already exposed -- 
currently KVM just doesn’t reference them at all.

All the changes introduced here are transparent to KVM. Organizing the 
initial values and wiring up guest_perm and fpstate are entirely 
internal to the x86 core, no?

