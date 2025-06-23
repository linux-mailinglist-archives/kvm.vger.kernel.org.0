Return-Path: <kvm+bounces-50396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F15AE4CB3
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC9D77AA1E1
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5C32D3A66;
	Mon, 23 Jun 2025 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S8nUNa8u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEAE1D61BB;
	Mon, 23 Jun 2025 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750702840; cv=fail; b=Cbj886GRebAt9DkJ3vnAc6N7J4ZEoolFaSMKhBPH7pKwB1QGSexS31beiWGcYph4o37OYja+sCklwK6G1/E2gvmqDGcZzVi2WMA7a7rc3GNJ+3K091+2dQGDRgj04n353sas3d1Vklwykp/W+e8dWRcesw3AqoUMwR/tL8nQrtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750702840; c=relaxed/simple;
	bh=Q8G2B2Je1RtggKVTD25nrGAu/Ihj0lUXnJ5NWdPFqz4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=szsPrck63Hhll04E2mOtZ2N9SSj7Ph+pF4XocIbHp6UXh82v6MaMQqxn2aOEbPKl13h4yLwBDIO3hgNn4lrQDUOJiSA689d0Su/IDBXLDhpPkc9MXgvGHnAePWyhEJXa5W5Bt5EEUXnKQ9eZ0Y5S70hSWHm8cfE8JcFcV5loZ6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S8nUNa8u; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750702840; x=1782238840;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q8G2B2Je1RtggKVTD25nrGAu/Ihj0lUXnJ5NWdPFqz4=;
  b=S8nUNa8uleyVXAsGNMScVDn6tDjWtyRO17x3KuicaZE2nKSqYxFKX8ll
   2QXAUGgm44wmERstyKasKWb9XPa7GZLP3ubjGTmoNSokip0psHV8pJtfF
   Vcu6VnafEyFklQWKHTGbFnymH7KDGuYf2/4A9+4u/J80E5nIgUAB9QMJ/
   7ioT9VN1Dqw+w6SZXNQSFcvvrkDZb1O1NGmUg8eZcCCzz1GcGEKgLJ6EO
   tyr9O57d98U9Akct5v3XhpyRJ4CKHqe/HG27K2TWoa/BBZX48DMiWsKef
   2dr1xuOQ4n521wfmii4QdtLHaWF8904qjS9k4t0BViHM2+ER8RL9Pmme3
   Q==;
X-CSE-ConnectionGUID: MR5ycsZtS9SB7eYd6W/ezQ==
X-CSE-MsgGUID: j/LUNcmjR2Opwz1X/N7UUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="56701752"
X-IronPort-AV: E=Sophos;i="6.16,259,1744095600"; 
   d="scan'208";a="56701752"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 11:20:39 -0700
X-CSE-ConnectionGUID: giuULv47RZu8qxN+N5Gdhw==
X-CSE-MsgGUID: 76PaYSl0Taqr2X8bme3dzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,259,1744095600"; 
   d="scan'208";a="151825207"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 11:20:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 11:20:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 23 Jun 2025 11:20:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 11:20:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lb7mbEvwnQKO2GoH7GUG8OTVYT55vOIjyETJcyNbd1oSiX0Fz77Mim/0eMnWbol+kVhG0lgoJeVKq1Dh62zjkPio9xSTY8KvMp5SAk6EhYDbYaln20u/X5CGFZkmNljro5ccUOMShIQ4XeZHKEmvVX4b49Dg++hXsST5XVTHuD7eZFboqBGp6S1fPJbpE+406DnWFkhBBeSVKpCZImGgClgCEcsTXcDI8aP4a5cKTOfwLq9UgAzgPpAtcgDkPdpj/BOPHP0rzb0tMbMmKhNYs25FVBhPxXlmkFPUvCdqhij28WUVu5Yn0MF1MCQyAOVjKbs8wobRaVWiopsS98PYtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8G2B2Je1RtggKVTD25nrGAu/Ihj0lUXnJ5NWdPFqz4=;
 b=LGbZHbQ9XZn3YMUWK6tNHWtRHQHZ4PaM7BAp25H+f64KvZLfqZtGFAj2nJWQZkCN12A58/0XYXpbM+++ao4/HUQCp+paFjMJX7mWjA5N68sG1HQUxcXD+kQydkn5d0VxY52SUTK2yL1bh8kMOGGMi7Cz3M1KF9Feu3B4nANEayFPjHvsA4crB+AOXyiKG/CFFa+p6q/Axykhkbny7tJzAyJtXir52BIPKrOm8NnrmEQuTKv9p0bzEYBM/sS1hx8iwxIZWgqTKY3G5e6k8xsJSl45pMSFAJl/Q/QdGeCjZI+7RY/76oBJOevv7TRZxgmJP/6+rdryoaJwcTcYS89A7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4945.namprd11.prod.outlook.com (2603:10b6:303:9c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Mon, 23 Jun
 2025 18:20:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Mon, 23 Jun 2025
 18:20:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
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
	"ackerleytng@google.com" <ackerleytng@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAAlOOA
Date: Mon, 23 Jun 2025 18:20:28 +0000
Message-ID: <eb46af1c081f4177dd79ea70c1bef5ca733c63d2.camel@intel.com>
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
In-Reply-To: <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4945:EE_
x-ms-office365-filtering-correlation-id: 379a6fe0-5ff4-46e0-cd27-08ddb282a1b5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TmQxTjRPVmlUTDYzUU91YzkxWFdCWDRjNmJaeG5YYWpXRkFxTGwwZFRJYXVT?=
 =?utf-8?B?Vm5ndkk0RDU2ZlNxL1NJeHY0cmhVVUYwL2lCUVlGUW5JV1lyblJmcTdyRkZ6?=
 =?utf-8?B?SUFLNkROZ1VtYlljNHY3RUFWd21tWmdOTDhkOTJqWGsvbDR4by95ZWdiM0ht?=
 =?utf-8?B?TzlMODlSNHNVdTBHQzhpUHUxVm9aVFVJY1hCcnZoOWplbnVwVDJ3eHdENnBG?=
 =?utf-8?B?dEt6ZGlaU3Vid2dqL3B5VlBaNlZGTTVkWmhwRjdpbVFCQmZVVWoyTEpORzhn?=
 =?utf-8?B?Mm5La0FJOVBnQXZkQ2V1R2N4TWtBYk80QXdSYTFjbWRHRjdYUUVDNldxRkN4?=
 =?utf-8?B?WGthTFhkWHRPTDVwNVNVNlNpSUFoaENyZGxRaisyVDV5ZkRxY3JoQ3dMM1RV?=
 =?utf-8?B?dXBwNEMxMkVIWmNJZnFZUkEzTk0zLzhxdVdTbEdsbTAwdXd0MkdRTmkvVUFr?=
 =?utf-8?B?a0djRnBCOXVMVnZHUjlhZCtDVWhuS1MrTXM0bWxlemthSUdSZDNHZThqczdx?=
 =?utf-8?B?bW9KK2Ivc2hGckFoM2N0ZXVSbUcyOGRzUzBOaWNsRWtRSjlvYU5WUzJrZzRZ?=
 =?utf-8?B?YVM2LzlFVFZHeHVQTVcyT0I2R0JDelFGVUxnVFFkRHp4SWVrMEdmZS93U2xh?=
 =?utf-8?B?NFMzNnNTMUtUY3hYR1JlNjVhWG1zMFpieGlNVWZJbW1LUEcrQlZQY0ZmZHlP?=
 =?utf-8?B?U09OZGk3bTNUTHBhL2xlU0ZNUzJEWkN6NUFQZmdlbnpBWHlqTVZ5R2Q1UTBl?=
 =?utf-8?B?UDVSSExjU0hYM3ltbmJaNitubTFMNElqbUpEQ2F0b3JldG01d3k1LzdBekRw?=
 =?utf-8?B?NEJJbE1ldnk4OWxqK01OZ09BVTA4cStVbjJwVytJa2tOL2NsTm91SVVzclhp?=
 =?utf-8?B?R09EZGNHRmgrRlJRdzBtZHd6eWl3V2JtMk9jbjg0RDlxUFo3VzhhSThBYXpM?=
 =?utf-8?B?ZWUvTXRvOWhGZHBsMnpOR0Z6T3phWnVXTEhudVdPbm5BRGg5cHdQWUxlWFM5?=
 =?utf-8?B?TWRhNDdmT2pZbjJUVXlBZHJqV2F5SnF6SGpCVXJKTmNXbkZpZTFLc3d4NEFX?=
 =?utf-8?B?L01oTkdKNDV1U0R5ZnIzclZtY0xkSERFcWZBV3krSmdkQ25Mc1l6Um9Cc2s4?=
 =?utf-8?B?L1VKR2tLNG8yTWxLYkRLTjhZY1NzTXlJTlVjaCsyZE9adXg1VkJ4ekY2Tkh6?=
 =?utf-8?B?KzZuaGlHb0VEMTBUNklycjlISGlQcE03VG0wS1p6V2lTK3lpbHAyUGxHOEo4?=
 =?utf-8?B?VzdGUkU1MmhCVkVoVHAwNyszc010VFNlc3NGWi9mMS94SkpNQ2FnZVRneDRn?=
 =?utf-8?B?SzFlaXNaZFlhd0o0b2p5VUFCTkhJa0xxMmtjV3pISzQvN2Y1dXJkODllWlJk?=
 =?utf-8?B?UER2MGo4UEhrM3JhOVdxMnllc3RWeXdpemJFdmdieVNOcVlzVHh5cGI5SDVw?=
 =?utf-8?B?WHhNQTlhdkVjUGlIQzVIMDJicmJZODNOdzhHc2J1R2daWXJZTE93M1lBTy9o?=
 =?utf-8?B?aGZYQzBmcGNidXNEdFdabWduZStPRHhGSjI0RGtqK0ZzRXJsMVdlVTVzc0Y4?=
 =?utf-8?B?RTBkbHpMTWJaajlESnJQajlDZjJ2S2JQSDYxbHNaZlZXQjF0dEhaMS81SEZL?=
 =?utf-8?B?dEFubG1zaUx3ZW1YSENxbXdCdDJBaTJEZ0IvVUdXcStkR2ZkaysrSnpLWUJv?=
 =?utf-8?B?NjRHRC9NelRWR2lpekozdE5PVGpwcHo2UHIzRlB6dGRPaUdheDFhbXFESFJU?=
 =?utf-8?B?Q3hROWJ0OGc1d1VXUit3RU9FKzVUM25HR1BUTEptUGdwYmNFVkdKWEFUd3Vr?=
 =?utf-8?B?bW5jTHBtWXhQNExGaHJYNC9VS3lvUjZjdG9ieWtyVmxVNmY2VlBjMlFBTkV0?=
 =?utf-8?B?a1BTUjAyVENseWdiY1VkU3ltQVJFREtBSW8zc0RQcDA3SU5KVlJMQ29ISmtn?=
 =?utf-8?B?UUh6TERVc0NRWWhQT1YxYkxqbzNZa25LaVVlbTluMCtRdmdJc2Z4UHpvT2VW?=
 =?utf-8?Q?D61UhI4BqrdvnHrGfHAaSdHjkr+Ax8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1NDbEcrekdvUEFDQm00R3NDWGJEeXBaVkloUitzdlcxNGZHaWlkMkpZNzEz?=
 =?utf-8?B?MHVyQUYwc2JzbzBKaHVZL0JlWGJPb3l1WGZiWjI0MHFBWVhQTDFzdW1tbVNJ?=
 =?utf-8?B?NG5YWnpDRG5YWi9nT1VnL1Y5S005SGJiVFo3SjRoa3p3YVl0TFVORWxmbDZD?=
 =?utf-8?B?MXNvTmNUTmdJY2IzYTJhVGs3RUgyMGxEOWVFbUI1NGU3S010a3AvdEk2c3cx?=
 =?utf-8?B?ZU1CR3BUbFVkQjRMS1dGRVRPNDEzamJvc3c5dXh3VUhEMkNIRDE3VXdoTUNz?=
 =?utf-8?B?L21iWWRJMk9TSHFsd0owRXozRWgwOGVLdVlVdjhHcmhibnIzKzQzanRLTmhp?=
 =?utf-8?B?L3dmblF3RUVWanNMdlQzQ2VxUHhHSjU2Ynl5cTJTVS85L3dxbnlrRGpiMG5j?=
 =?utf-8?B?bmxzUjVxYlliRGVyNkdicTg5WDVHMnJSQzFNczlkNk9EcEpReVQwOHpJYzJy?=
 =?utf-8?B?a2s5QWJ2RlJQR21vTUQwVkp1azlHOExybS9hbi9CKzU0YUN5VUdYcHRnSDBT?=
 =?utf-8?B?WUZIQ1dxaDVWWkdkc0lLVXZ1M1A5Yi91YzRVVnEySXVkbW9sN01jNCtKdUxR?=
 =?utf-8?B?c0gveTFYN3hONlQ5UjhtdG9qWVNYUmt3aGMvaU52a0dtajRSWGgzUHNJUjk5?=
 =?utf-8?B?Ri83QXlPbUV3ZngxczhDeVZKWi8rVFNLNGhHcFZGOUtSMEFLeFMrOENtcXpr?=
 =?utf-8?B?ak1qUlFFRG1NZ3ovQ1AvZFhnb25uOVlOV3phMnFiTGRUaDZNcVBqU051VG9Q?=
 =?utf-8?B?cGRVT01KY0g4dUxYZEtnemhRVWgvQkpXT05mNFkyK041d1M2dC9wWU9BWG9u?=
 =?utf-8?B?MHEzUVV0SmsweXZFNUc1eklrcHFFakJlYUJYcWFXSHBobFlwdmludU5kVUZS?=
 =?utf-8?B?M1ArckNTT3gyRSt1RXdnMytnWVN2WWhxZHFIT29rVzVaU3BxcVUrSFEvTEtJ?=
 =?utf-8?B?UjArbjljTG9jbGVmZDVRamx4R05SdUptNGxPSE8wSGtlUFJwSmkrS1hrdlpv?=
 =?utf-8?B?eUhXUVhaam9ZaHQwMm9xR1RCYURvcnNPSTdRMjhUY0VCUGx2ZHFMOG4yR0Vm?=
 =?utf-8?B?NGFmWEtVTU9hQ2RyUER6ckN1UUZSd3lNOWVIamNYOXFPbHlIMlVUYUpDWHMr?=
 =?utf-8?B?c2RRWTVETWgyb2NMamErUVlacG5BNGtuWk8zbXhGa2E0enR5dmRsZmlsWTE3?=
 =?utf-8?B?UlJDUGdoRG40RE4yOEI0eW9EaHBla2lsc1A3TndYT0RNTDVnQ3JjeXhsb21U?=
 =?utf-8?B?Zy92MFFxWGVTYVZjM2VVVVU2QXljNzJsYW1tQTVOT1lEek1lZXByaVFhWEQv?=
 =?utf-8?B?am4ydXZpcC9mNmU0bXk2azJTdVNVUHkrUlNDNGxkUEc0Rms3blIxT1BES1Rr?=
 =?utf-8?B?OFRQYWxVYTZqdlhUcGNnYm5nZ0JwamZBeVpnK3JGV29oQWFIRVk5WnlucFBj?=
 =?utf-8?B?Z21KYjBzWmJ3Wi80T1cvbi9vSkpGKzY3N05zUWliNVdyOFR1MVNtd3NLZHEz?=
 =?utf-8?B?SUxBRzIwOEJUcHdEUEdmdERvQUJMLy9qeHgyMnlzTFQxbnVybDBiVmpTblpn?=
 =?utf-8?B?Y2VmQU9Lc090WDZtZHZaR0xOV0U4V09ybm1UMC9zQWhWaVMwWGJKSnlWSlVN?=
 =?utf-8?B?YmlLbnA0SEkzUmhvTW9SWkY3RDNJQVprRWgrOEw4V3JFZ3RmNWg2VWF3ZjVH?=
 =?utf-8?B?b3NhQUoxdG5FNnE4TlFIVnppUHFOSnc4NmtSOWQ2S2l1cHNTcjZUNTZ5YUZt?=
 =?utf-8?B?ZHUxKzdpNGhGRWVTYlVXTEtLeElYb0dhYnlWdFZST1lZNVhlUHNtSm1wRHF0?=
 =?utf-8?B?dmhrbmRHNnM5NGlZRWlma2JmcnVYdzkwTTJaMnhBSVQwSlY1U1JMSXY3Qy9a?=
 =?utf-8?B?d2I5aFpQeTFzU2Y0VUNTaTljOGhZYWFEQjZENlY5TC9xeXVMOW9ZUWJkdlR0?=
 =?utf-8?B?cVpjVDI1RUFacitLc0FvbWYzQUI0NkRadDBqckZqRVVaT0Z5SUlHaWJNczYz?=
 =?utf-8?B?QU9qYTFWbXVMRXd4dmZjYW54aWNJRGtNWkU1SXl3QVRKQW9qNEpoR2dQY2xo?=
 =?utf-8?B?TGIrcWs4NEJhTjF1dysrN0ZKMG1YOS9BTlN0Q3czUGJESTNqNmZGUDEvTFhV?=
 =?utf-8?B?TmRaelk0S0hSVFl6Z1JZN3RLd1kzeFlVOHV1TnN4QlppMGIwOGxHbldsNXFV?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D8AE4167BE0AE42847BE8EC9FDA13ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379a6fe0-5ff4-46e0-cd27-08ddb282a1b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2025 18:20:28.4871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VGlk8bVAM8s5jDhPDitr/kw/7fRb7GrweOUjv8nsrS5JzS8OcXJLlOXeJQhg6lwcnrBv7IHLGnOL64C7U664gbuCNX0RN/TviC4Nz8y+6Tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4945
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTIzIGF0IDE3OjI3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gVG8g
dXNlIHBhZ2VfZXh0LCBzaG91bGQgd2UgaW50cm9kdWNlIGEgbmV3IGZsYWcgUEFHRV9FWFRfRklS
TVdBUkVfSU5fVVNFLA0KPiBzaW1pbGFyIHRvIFBBR0VfRVhUX1lPVU5HPw0KPiANCj4gRHVlIHRv
IHNpbWlsYXIgaXNzdWVzIGFzIHRob3NlIHdpdGggbm9ybWFsIHBhZ2UvZm9saW8gZmxhZ3MgKHNl
ZSB0aGUgbmV4dA0KPiBjb21tZW50IGZvciBkZXRhaWxzKSwgVERYIG5lZWRzIHRvIHNldCBQQUdF
X0VYVF9GSVJNV0FSRV9JTl9VU0Ugb24gYQ0KPiBwYWdlLWJ5LXBhZ2UgYmFzaXMgcmF0aGVyIHRo
YW4gZm9saW8tYnktZm9saW8uDQo+IA0KPiBBZGRpdGlvbmFsbHksIGl0IHNlZW1zIHJlYXNvbmFi
bGUgZm9yIGd1ZXN0X21lbWZkIG5vdCB0byBjb3B5IHRoZQ0KPiBQQUdFX0VYVF9GSVJNV0FSRV9J
Tl9VU0UgZmxhZyB3aGVuIHNwbGl0dGluZyBhIGh1Z2UgZm9saW8/DQo+IChpbiBfX2ZvbGlvX3Nw
bGl0KCkgLS0+IHNwbGl0X2ZvbGlvX3RvX29yZGVyKCksIFBBR0VfRVhUX1lPVU5HIGFuZA0KPiBQ
QUdFX0VYVF9JRExFIGFyZSBjb3BpZWQgdG8gdGhlIG5ldyBmb2xpb3MgdGhvdWdoKS4NCj4gDQo+
IEZ1cnRoZXJtb3JlLCBwYWdlX2V4dCB1c2VzIGV4dHJhIG1lbW9yeS4gV2l0aCBDT05GSUdfNjRC
SVQsIHNob3VsZCB3ZSBpbnN0ZWFkDQo+IGludHJvZHVjZSBhIFBHX2Zpcm13YXJlX2luX3VzZSBp
biBwYWdlIGZsYWdzLCBzaW1pbGFyIHRvIFBHX3lvdW5nIGFuZCBQR19pZGxlPw0KDQpQYWdlIGZs
YWdzIGFyZSBhIHNjYXJjZSByZXNvdXJjZS4gSWYgd2UgY291bGQgaGF2ZSB1c2VkIGFuIGV4aXN0
aW5nIG9uZSwgaXQNCndvdWxkIGhhdmUgYmVlbiBuaWNlLiBCdXQgb3RoZXJ3aXNlLCBJIHdvdWxk
IGd1ZXNzIHRoZSB1c2UgY2FzZSBpcyBub3Qgc3Ryb25nDQplbm91Z2ggdG8ganVzdGlmeSBhZGRp
bmcgb25lLg0KDQpTbyBQQUdFX0VYVF9GSVJNV0FSRV9JTl9VU0UgaXMgcHJvYmFibHkgYSBiZXR0
ZXIgd2F5IHRvIGdvLiBEdWUgdG8gdGhlIG1lbW9yeQ0KdXNlLCBpdCB3b3VsZCBoYXZlIHRvIGJl
IGEgZGVidWcgY29uZmlnIGxpa2UgdGhlIG90aGVycy4gSWYgd2UgaGF2ZSBsaW5lIG9mDQpzaWdo
dCB0byBhIHNvbHV0aW9uLCBob3cgZG8geW91IGZlZWwgYWJvdXQgdGhlIGZvbGxvd2luZyBkaXJl
Y3Rpb24gdG8gbW92ZSBwYXN0DQp0aGlzIGlzc3VlOg0KMS4gR28gd2l0aCByZWZjb3VudCBvbiBl
cnJvciBhcHByb2FjaCBmb3Igbm93IChpLmUuIHRkeF9ob2xkX3BhZ2Vfb25fZXJyb3IoKSkNCjIu
IEluIGEgcGZuLW9ubHkgZnV0dXJlLCBwbGFuIHRvIHN3aXRjaCB0byBndWVzdG1lbWZkIGNhbGxi
YWNrIGluc3RlYWQgb2YNCnRkeF9ob2xkX3BhZ2Vfb25fZXJyb3IoKS4gV2UgZG9uJ3QgdW5kZXJz
dGFuZCB0aGUgcGZuLW9ubHkgZmVhdHVyZSBlbm91Z2ggdG8NCnByb3Blcmx5IGRlc2lnbiBmb3Ig
aXQgYW55d2F5Lg0KMy4gUGxhbiBmb3IgYSBQQUdFX0VYVF9GSVJNV0FSRV9JTl9VU0UgYXMgZm9s
bG93IG9uIHdvcmsgdG8gaHVnZSBwYWdlcy4gVGhlDQpyZWFzb24gd2h5IGl0IHNob3VsZCBub3Qg
YmUgcmVxdWlyZWQgYmVmb3JlIGh1Z2UgcGFnZXMgaXMgYmVjYXVzZSBpdCBpcyBub3QNCm5lY2Vz
c2FyeSBmb3IgY29ycmVjdCBjb2RlLCBvbmx5IHRvIGNhdGNoIGluY29ycmVjdCBjb2RlIHNsaXBw
aW5nIGluLg0KDQpUaGF0IGlzIGJhc2VkIG9uIHRoZSBhc3Nlc3NtZW50IHRoYXQgdGhlIGVmZm9y
dCB0byBjaGFuZ2UgdGhlIHphcCBwYXRoIHRvDQpjb21tdW5pY2F0ZSBmYWlsdXJlIGlzIHRvbyBt
dWNoIGNodXJuLiBEbyB5b3UgaGFwcGVuIHRvIGhhdmUgYSBkaWZmc3RhdCBmb3IgYQ0KUE9DIG9u
IHRoaXMgQlRXPw0KDQo+IA0KPiA+IGJ5IHRoZSBURFggbW9kdWxlLiBUaGVyZSB3YXMgYWxzbyBz
b21lIGRpc2N1c3Npb24gb2YgdXNpbmcgYSBub3JtYWwgcGFnZSBmbGFnLA0KPiA+IGFuZCB0aGF0
IHRoZSByZXNlcnZlZCBwYWdlIGZsYWcgbWlnaHQgcHJldmVudCBzb21lIG9mIHRoZSBNTSBvcGVy
YXRpb25zIHRoYXQNCj4gPiB3b3VsZCBiZSBuZWVkZWQgb24gZ3Vlc3RtZW1mZCBwYWdlcy4gSSBk
aWRuJ3Qgc2VlIHRoZSBwcm9ibGVtIHdoZW4gSSBsb29rZWQuDQo+ID4gDQo+ID4gRm9yIHRoZSBz
b2x1dGlvbiwgYmFzaWNhbGx5IHRoZSBTRUFNQ0FMTCB3cmFwcGVycyBzZXQgYSBmbGFnIHdoZW4g
dGhleSBoYW5kIGENCj4gPiBwYWdlIHRvIHRoZSBURFggbW9kdWxlLCBhbmQgY2xlYXIgaXQgd2hl
biB0aGV5IHN1Y2Nlc3NmdWxseSByZWNsYWltIGl0IHZpYQ0KPiA+IHRkaF9tZW1fcGFnZV9yZW1v
dmUoKSBvciB0ZGhfcGh5bWVtX3BhZ2VfcmVjbGFpbSgpLiBUaGVuIGlmIHRoZSBwYWdlIG1ha2Vz
IGl0DQo+ID4gYmFjayB0byB0aGUgcGFnZSBhbGxvY2F0b3IsIGEgd2FybmluZyBpcyBnZW5lcmF0
ZWQuDQo+IEFmdGVyIHNvbWUgdGVzdGluZywgdG8gdXNlIGEgbm9ybWFsIHBhZ2UgZmxhZywgd2Ug
bWF5IG5lZWQgdG8gc2V0IGl0IG9uIGENCj4gcGFnZS1ieS1wYWdlIGJhc2lzIHJhdGhlciB0aGFu
IGZvbGlvLWJ5LWZvbGlvLiBTZWUgIlNjaGVtZSAxIi4NCj4gQW5kIGd1ZXN0X21lbWZkIG1heSBu
ZWVkIHRvIHNlbGVjdGl2ZWx5IGNvcHkgcGFnZSBmbGFncyB3aGVuIHNwbGl0dGluZyBodWdlDQo+
IGZvbGlvcy4gU2VlICJTY2hlbWUgMiIuDQoNCldpdGggcGFnZV9leHQsIGl0IHNlZW1zIHdlIGNv
dWxkIGhhdmUgaXQgYmUgcGVyIHBhZ2UgZnJvbSB0aGUgYmVnaW5uaW5nPw0K

