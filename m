Return-Path: <kvm+bounces-25512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0B9696607B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E3E7B2F018
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2531A4ADC;
	Fri, 30 Aug 2024 11:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iTz+dQUQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313251D131D;
	Fri, 30 Aug 2024 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725016264; cv=fail; b=NyTyXlJMNnuea/QqFLz32ZGtJZCKKlxvUXSLucgjVK6bEeQIouUNLrtVfeey3qMj9zqP4o7DEfMhTIBLbDM6JdoFY8TV362FVfXAJ1LRV8fo0fVEn1Tpw17+b64druxqriTrL0tcgLhRl7tluDPp1M/37Yo5fK3esbOosngkItE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725016264; c=relaxed/simple;
	bh=ATTfJ10kCswAVmzY2v7ckyIDQxXw6hooSMparuhxS6E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SXPTpz5+a0iZ62+AwmQqjRWuBGrj6V6Pid4qNmFFHUyYagdv9dzuFfVzdEFLrSwnMTqZS0OSFA35BfqRFXqbiS/BF/EyLuqJIBkbmcIyFWHZ96opEm6vWc9QB5iOsz9IztAtZnl4hpxv39XHMotWznDc1n4wu3x1Oosq51MTYCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iTz+dQUQ; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725016261; x=1756552261;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ATTfJ10kCswAVmzY2v7ckyIDQxXw6hooSMparuhxS6E=;
  b=iTz+dQUQnrSa3t4Nbl14+5YzKanmy872AwI9sz4D0ah7lBnhfzc7pAuo
   xsZC1P+tBWWegpZH0kwaQD4EvfALi3h5bibot5KzEF6BnH7JqTJ+2gT/T
   s+U1FuO/2T0LDT8StfN+gIXI/s6hW3XDsIn0RNM0Elu/9uWl0y29TWmuq
   Y62VaVvOUfUNgXtGLlkBzmNtFlSo2P1Fx/X2ORdFU3Hd/VC8sX+z2Wsqz
   HH0XsPUT591geYNpF5J2zni58CQwSVo6+MD8x+QIUw/6XXe8z477WwVKa
   SVSeKhRejckCAHFeT490z01vbJXblMXDrbzqVEesCxPXaEg6jaJFlU3db
   g==;
X-CSE-ConnectionGUID: Ls8S+B9XSFKTywnzMG9NAg==
X-CSE-MsgGUID: 2ine/UDpSO60Jo+OQaazPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34267441"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="34267441"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:11:00 -0700
X-CSE-ConnectionGUID: jDM5nwmNSp+vTrPGIQJNMg==
X-CSE-MsgGUID: lhBAoTuERHmLux2CV6sHCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63825828"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 04:11:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 04:10:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 04:10:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 04:10:59 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 04:10:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YIiRPhOagE0l8UhHBD1yfZSHbaFT+Og2gKFLWsvub1w7+rq+Djfce0kDULgIzXmAj/eftvzB2UOJi4JXgdD9aLZqVxilS8kFFTNqOlgxh19zJtv+deZygQ5YM2wj22DABJ2g68WgkfJUzyGapZUzCvD0UafWFXnV/89QjpzzgRnm7T6I1hfHo4sjCuXJwwehZUDKe/7sxLsZe7GPSFj6nEej1u8nUS1Ub1Is55gWBb1oqn//CjfbTTKVrWbjXd/zk9BDidHf8JOs6XKC0LjDlxTLeqQHDyEpNP7nPCLuwj4NJLyjHcV9w2lSPVZM8IXFJCnguva1tioXPNdrh5cdLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATTfJ10kCswAVmzY2v7ckyIDQxXw6hooSMparuhxS6E=;
 b=GqNnLsggdkapkDsSlV8N2Re8GbMBYzuMh/z5k6eEQL2uetpxKRr7gfr3dr7sod780TKyxuKaBcMbu4iU3O0XfMqeR3BRrWTXg4osXplCYpQOH7iBrQuclHD6+ajBn40AtQw7fdJjCNwC43A+Xikt9K4Bl+3tuJKOJADVAw9zyNpzXMIoMvRjuXb2/SONestSeGvYGmrQ9WyEa+MTi5uGwk8Vkw/dgzdxKqyOO4Np9NaCLOl1Uuh7fR2CIhP/EhbbHIzLLCE5q5LLbOWWvNxv0vbJtnqeUvSwgEZx4y+QgeowiDpWCltWdnMZ8T6APCQgHVdM4uyILMEa30AVqAWnCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB7488.namprd11.prod.outlook.com (2603:10b6:806:313::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 11:10:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 11:10:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 5/8] x86/virt/tdx: Start to track all global metadata
 in one structure
Thread-Topic: [PATCH v3 5/8] x86/virt/tdx: Start to track all global metadata
 in one structure
Thread-Index: AQHa+E/ztH1XiJgYrk6z/1dEW3k+47I/ZIKAgABFZ4A=
Date: Fri, 30 Aug 2024 11:10:52 +0000
Message-ID: <f50df3ec1fdec310fadff823af670c000b58d9bb.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <994a0df50534c404d1b243a95067860fc296172a.1724741926.git.kai.huang@intel.com>
	 <f7f66da8-7698-4511-900e-5e73af01517b@intel.com>
In-Reply-To: <f7f66da8-7698-4511-900e-5e73af01517b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA3PR11MB7488:EE_
x-ms-office365-filtering-correlation-id: 4988cade-18e1-4f2a-e89e-08dcc8e4693b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L3ozRTlNS2Q5YlFmOThpZ1lFS3c1UTk2bnM3LzhXUk1pT2FOTk96T0h0L2Ex?=
 =?utf-8?B?RlhvdEZDNkNtZDFEWU5kZ21IK3p5Vm9zeWM0aGRUY2Zyd0RGOGdQaFZ3a2I2?=
 =?utf-8?B?YzBQTVdlbVhQTURmL1Q4QlEzV0hRRk9jMlMwQTFDakl5cWFSWEpaNEh2V2F6?=
 =?utf-8?B?dDIrM2prbWQvTnRnenRXV0NYZTBidVhFSlZFb1ZVZGp4akN4eityT1pjdDF3?=
 =?utf-8?B?Skc1NXkzTU5XUHpTc25nT1hta3ZtczJyRUxVclh3T2prREg2ZkJIdkxzakNS?=
 =?utf-8?B?L282aUdQZ1p0c0dIb3Z5eS9BMEJSN0VCWVFZOFE5ckV4blFaVG1MdmR3emdp?=
 =?utf-8?B?USttdC9UTTRJS1ZGVFZjSm9ORXk2K0QxMll4MU1lRUtzdmlWWHFKTjRqNVB5?=
 =?utf-8?B?YThiTkswc2pLUXE5cUdWejczcm4xRUQ3UlJrR0hUcDlDUmo3M3lKKyt2QjhU?=
 =?utf-8?B?bHZzKzlUQTRFWW42N296azNYbkVtUUlJY2pkalpGWUN1UW40YjJIbk55SUM0?=
 =?utf-8?B?WjZGaXV6aUJ1OU5xMnRkUjV1eUs1cjFPZTV0RWhkcjJrQklNd21mOTh1bkRl?=
 =?utf-8?B?cDQvbzFjekZYdkg0TEJJdHZpOUM3Q2krMjFRbDd4L1JtYlFMRDFoNTFwL2dM?=
 =?utf-8?B?Vjh2Rkduckxsbm5HVWs4YjB0VU9DWUNNWlphdiszdTFjNzFIRHFtMC9KY3NY?=
 =?utf-8?B?cmZPejFCWXR6d1N3ejBMMnFVelZzdTNsSGJBSDh0TkhKeVVBRkF4ckl4bnFN?=
 =?utf-8?B?cHd6bXVxeGpJTlBFUmVtK2VKNHNRNzFGRjI0NlVlbzlhM0VCUVNHWTR4MjlB?=
 =?utf-8?B?RXVOaW50YmJsRzQvUmlsMnk0OWEzMXRBNDJnamJjVC9BRDlTeklYR2xyQmgv?=
 =?utf-8?B?am9VQnRpeSt3Y0FLRzBzZk1wMGMvZWFpajlBQzlqNVNHZHJ6MzcvUHlUMElv?=
 =?utf-8?B?YTJzelo2K3h1TzVQbEFkUzdwWUtlak5WMkN0VWd5bS9nUGFpVTVJUHN1VkNU?=
 =?utf-8?B?VGNEdEQ5QVRJL0Rpc2g0STEydEVJbWJleHdLK3JRR1BNNjIvL1ZBVUhzL0N5?=
 =?utf-8?B?TlVIUzVDS2tRWEhicUFtNXJ3T3IrNnRkaDZ0c1kwK1UzcUVnc0tKSE93N0ZX?=
 =?utf-8?B?SlhWMjlDaEgzRGJXVVluQ2wrb0N0K2E4TEhaRlVIb2RtcTVFUHRZc1p1dE1z?=
 =?utf-8?B?aEpIM0tyZzhxa2RYbVhNOFFRMzFmTXcvRkV1WHM1WHp5eVNNczhkek1LaVJs?=
 =?utf-8?B?VHhXTm9qcjNHWTNZQTVJRGZyVW10cFBKV2tXUVAxZEhGTFNVRVNDQ2N2QUo0?=
 =?utf-8?B?b2FQK0RLekswS3psZnFnaVhpUnpWemYvSjFpb3JIWWV4bkJvZ0cyaDlnZ2ly?=
 =?utf-8?B?ODc1WmNhT240SWNCUmxJRXBlNlRoR0xqVUl2aXhhMC9CcWtFTVA1WGJ5VFBV?=
 =?utf-8?B?WHh0RHBBeXR2dHJPMC9DR0xsdTZ0dENvR1cwQUcyZzViUGI0dFkxdWRBR3RT?=
 =?utf-8?B?U0RwNytyU25nMjg2akRBLy9xZ3QzNkhnMGt6cGpRK1dObFJpU3NXMklSczVn?=
 =?utf-8?B?SGc1aCtyVjM5QUZWT3hhWkRrR1VKaXNQRWJIa04wcGpwWnpsV2Q3ZUhYczRz?=
 =?utf-8?B?L1VtdDB2THBYYVppcDF2L1hrM1FGUDYzcjNGTVA4bDd0TEsycy9tUDhFS3hQ?=
 =?utf-8?B?Tm9qd3RaSGpmZ2FHcUp6ZnMzYXByak0wYXczdmxRa1JhVHFDUnMwUmpLRFdV?=
 =?utf-8?B?NDNyc0d5QTY3U0tlb3VJT29lWnlaR2docDlKWEVnUmRqNEFvMjdjbVg4elN3?=
 =?utf-8?B?SFZhTi9jWmV0SGNBMnZTTkJsY3JWaXlqRXV2UzFZb3ArRjhmNHZwdk9mSks0?=
 =?utf-8?B?Qkkvd0NtZ3VnOTF2dWVsbHNmVWNRM21uQ0twVEVrOHdXZ0dUZTZWQTMvSVZw?=
 =?utf-8?Q?9yiNqsC/ZhE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjVkZkdkQ2lQOHJ2ckdZaGxwb1I1MnZZdnY1b1FvUUNrVzJvTGlHVVVROVE5?=
 =?utf-8?B?UHNoM2kvSHIzYnpnVzdvSmUyOWFhZE96d2lHeitTNTV5REsyZFZGZ29SYXpY?=
 =?utf-8?B?NHZtS1EvRmYrbVg4MnlmVUxzVHFZMDBjMG1zMjdXa0FzcUhqL201bGRacEEw?=
 =?utf-8?B?SDlKbmY1YnFhTHZlQm9adG4rcFJoT2RwN0huZlFZVGlCbXoxT09HNDc1R0RL?=
 =?utf-8?B?bjZnZzN0eWpkTWNqT3VMbFhKQVplYTB5VFhJTjhabjVQVktadmxReGt6UTlz?=
 =?utf-8?B?TExvTFpkeWVlYlk1c1pDS3Y4dC9IV2M5Ujlyb0Q1SkppNVpLbnVNV1lOWmVC?=
 =?utf-8?B?NnJqWkh2QTAzbjNFQ0p6T0E5UkZSSm5RZGQ4bkRuRTQzYzN3eWFDLzhCMVZI?=
 =?utf-8?B?OTI0NlZlVHB2TGRseEs5REc1a1RONjk2ekJQckRlNXVMV1RDVE5oVFlSQ0Y4?=
 =?utf-8?B?N0tSQUo4U0tJakh0MDJaWDVsL3g0bTRUd1I3K2JyYzNnSXlRQ2FaM3U5TFZD?=
 =?utf-8?B?bHcrbWZ0cUNhTS9PSXVnQ2xYQWltSnZhWlIyY1dqODVtck9BRTNRbWg3dFVN?=
 =?utf-8?B?RWRnUjIxTm5LdnliaGRkTVdaMjJab1FlbVNwdW5lOW4yekJaeUZCdjQxMi9F?=
 =?utf-8?B?VEdPc1h2QWRCbUp3c2JreWE2eXZ1WlRjUEk5dGRsdms1dWNTVFVGeDRSc2do?=
 =?utf-8?B?T0FraC9ZNHlKN0JiRzlkL1MrOXFjZ0R0b2pUR09aVmQ1UVRzVXFVQ2tneUdo?=
 =?utf-8?B?dkdWZ2ZLK0dHUkxPSGdnRmozNHN1bitIampsOU5hdzFsQUdEV1NwQmI1Q1gy?=
 =?utf-8?B?N0xhQitsMUUwN1BuRWlZeVo3UHAwVEJWck9IZll0RmZUNHdWdXN0Q01WUWR2?=
 =?utf-8?B?Unc1SHc5TTRFWFRsMzE4bWhYZ2R3MTl1ZGxUbVJGSDJ6MzZkQUdRMWNRTisv?=
 =?utf-8?B?N2tOT0ZFU25ndlBsVlFydVFqWlo4SG9KNU5IOXpCLy9sUkEwUnRNUmtOWEZO?=
 =?utf-8?B?YXZON2JJdTN5NmtGaWROMC9iNWk5NCtNbVF0alNSbTEyelZjT2JKelR4Sm9j?=
 =?utf-8?B?R1BJdENML0llT0Y1YkZ4ZlJaaW4ySkF4Zm00MVRqQ2Z1Vm1QNGFVcWZkUFk4?=
 =?utf-8?B?ams5U2ZpZG1qUldWR3BYQUtRdEdjSGM5WWowaDgwalJuWEd2cmdrMzlJa0RS?=
 =?utf-8?B?OUtDSFZhekhTRk9VNTNJZk9USkVZRTBlTWJTNFgyRFJGZ0hhRng4ZEhrMjFD?=
 =?utf-8?B?UVVMWG00NFlHZnkzbGk0aFZma083S25ZR1VTV2N4cE91RjY3UDVqc3IzN2xD?=
 =?utf-8?B?SkprbTdRRTkvbVZjN0psbUN3Y1NjeGI3Z2pUOU1scnhMYk53cHZuZHNMS3Mx?=
 =?utf-8?B?V3BnNlBEVUZUS0JUdU40YTVGSkMwWUNiS1RncXFNV2V3d0JwdkhodTE4Z2Nm?=
 =?utf-8?B?YTQzL3I3Qit6ejFnNmdGNGdvMXpGeGdPQ1B1alVuNWJjdUQ2YkxSM3lzTTZM?=
 =?utf-8?B?UjhHYldscnJVeEF2OGhBMkduenNqNDF1UStEVmhjM1dvYkRuNXlFSTFvMW9l?=
 =?utf-8?B?QkxIQTd1VTBSUGRpdFN5Tm1kR0NxOWdCSzFrMlBmdUpkQzc3ZFBqcEVlZVM5?=
 =?utf-8?B?cmNyazFkTU83d0dORXZqS29EQXlUamlkVGhtZldIaXV0OUlTZWhzR2hXbWNU?=
 =?utf-8?B?LzdSWUtucnNDZkhVclVFRng2aEMzL0NhOFgwN01JQUZ3cFVyQW9MVktIK0Ju?=
 =?utf-8?B?Z1B6OHVCSkI1aWErRlNhT0ZhRVJyVXN1TkNwcmw5RmRuUitpLzhJRVJXRmxk?=
 =?utf-8?B?YjJhTjJpZFYyRlZ4ZEgvV2krTlh2R3N3RnZCVmluV1R0NDlOaXpXMjdCZEV0?=
 =?utf-8?B?Vmp6dE9OanFXZzIzZzkyOVFIZkZRczBWKzlrYWgzcERXYlhtY0k5aEtTeEVx?=
 =?utf-8?B?RnYwNjdNZ2JRMlZjYXNYeEV1dVJDQS9oWGtyVTR3eVNlUzhZSEo3Yi9QSjNh?=
 =?utf-8?B?aXQ5bXJLK3kvUGNxdDdoTnlHdVdBeFVubEk1S0x3QVBpNzRpcjRYQ0JOVEtO?=
 =?utf-8?B?OTB3UGhCYzBwWDdQaExESkExUGt5RldXY09va0thaDZUQk1hUDNDVVFiWjRQ?=
 =?utf-8?Q?ifWnuhpwKldOvbZjE5mJUSzlr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE18510665F2A34180688EBCED010B6B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4988cade-18e1-4f2a-e89e-08dcc8e4693b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 11:10:52.2983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cRwdvmQOb6GLHmO4DeS+PM09APTrp2b9injbtbCFsCUDaJq3o1gFwURrrSAAKu88IIzEm1w7HjFRhp5CHdJqKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7488
X-OriginatorOrg: intel.com

DQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29t
Pg0KPiANCj4gTm90d2l0aHN0YW5kaW5nIG1pbm9yIGNvc21ldGljIHR3ZWFrczoNCg0KV2lsbCBm
aXguDQoNCj4gDQo+IFJldmlld2VkLWJ5OiBBZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVudGVyQGlu
dGVsLmNvbT4NCg0KVGhhbmtzLg0KDQoNCg==

