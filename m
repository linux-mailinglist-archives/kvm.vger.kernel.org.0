Return-Path: <kvm+bounces-65799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 82967CB7326
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 22:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 956383030932
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 21:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FADD26A1B9;
	Thu, 11 Dec 2025 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5GgyouL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981181DE8BE;
	Thu, 11 Dec 2025 21:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765487110; cv=fail; b=PVmMtV0CO/Fkb5TklKAQfCkszCWFv3cxa+S16caruqy5IT+spFxLfSe7XjtwcKQF+oIzsM26e9RLW6shtadUWNQaI3ne/WlkrqBXVqyag6k1GZUYQw7XEt+Jv46jFFlYjNzmdjyhuRyr1xWVUk5I6qXZqm/t58UYJfxobnhu7b4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765487110; c=relaxed/simple;
	bh=BzAkdTwgIUGe/8TbMLOiZ2o9z/00JZiQz2L+DaSYD1o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bmsqpMY0lRXie/VECq2joIcaLufAhKujswWxl7X8Kc2iqsO79QAOFdQhZ0YA82SKhLkGfNlUb/2wY5d4w2b5EInzT78fX2mfgJCw1bazqnkzW0axm84rArjisi3Uzcu1ByH8ud9Ov/064+A4qhXRnCJbuupqpZEV76NmAlg3Vjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5GgyouL; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765487109; x=1797023109;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BzAkdTwgIUGe/8TbMLOiZ2o9z/00JZiQz2L+DaSYD1o=;
  b=G5GgyouLrmCmTXPAmYHAGbgK8DXAN3S2+6pZYLgxmfJRv/G0CgaKfslu
   211FFpbNGhviwg1MBPaH0v980CZtJt7CQ7dvhMFv9XJUMQjz97Qr8sKho
   /dqEd155NB0SpDJPN8PQoS11e1SGeymo1hibZ4F7Bmh9I1RULOqx1dijL
   OY2Igpl+MhmgbZLxrYho6wV4++YjVWZOo/VEiA1rlXnCljcI4tHGdLgmf
   UN9qnYDdN29hJbV2Bo6hAxwkd7ynq6Kx68c3yUeUUOrVAbw2BhYoxGVBg
   HWYNB+HrXd5oUUcU4zcBTR/hKVil2MnbLKkGXFOg48IavM9Wl3m7QvVuy
   A==;
X-CSE-ConnectionGUID: U6chWypWREqFuF/CGHGrEQ==
X-CSE-MsgGUID: mUAnBeSvS8mgX+9C77Ja6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="55026817"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="55026817"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 13:05:08 -0800
X-CSE-ConnectionGUID: PbASbXqBQ4qXr7nhIoqg5Q==
X-CSE-MsgGUID: 755CfcglRpS6EHPu+OuILg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="220282028"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 13:05:07 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 13:05:07 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 13:05:07 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.68) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 13:05:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYu4Bj+sTLlQ+0ie5BPw7HaZgvgxAOJaFiv+aaCN18rN3xyNkz1an2/jstHMYuRUrv7vNccfDIXll+ZmtyU44o/J/lHjTjpKvLyA2rqwQSEbv5jDKveWnGkbCOpNQ2L7dbbruYu2wF48x0Ts0aOzesPEua+xhGix5pcZ0hl0KnPovhjcC1F6t8knuYqFeyQoLQjgy/MFBuZL6wdUarZuciVV4tLRR3g7PhOrU9Uv8cDqK7l74MckYQlkuNUjswxsuktG5iIT5fUzpDQzjIm8idR79bySLhmJvn3vyCDMCz1VGiETi2xGNBxsjHE4GwtrR0hG0Lg3DhxA1D6/kWSdLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzAkdTwgIUGe/8TbMLOiZ2o9z/00JZiQz2L+DaSYD1o=;
 b=ORCYAJ3PgLf6ZSYpJLSEMxXYgjU/8TQEhEaAPTfSQdvTHhWAWXNERlXxlTelaQlRnmetvQVxr9fgcrnvu7CVPVfasx1m397AlzrXyw/I7Syafo84LKIoFxGf7rVtTaINruQWccthKKolps/9CaCttubzsjw2WmomPze6aenNRleV8tBaTQsC4iCns8rlFczg8pB2+L9x01kDdp9JhBoML96pwloSdKx+YueH7DXhuNhcIhceHSrcNGCzw1YuYf1yWosFJO0OKalo34spdlOiHTP0fHJogJX+EXWHEV9h3D/S1HMkKQ9XpOUJFLeyKFAuj2+HX7grt8Ye2MtGRaAnNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY5PR11MB6138.namprd11.prod.outlook.com (2603:10b6:930:2a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Thu, 11 Dec
 2025 21:05:04 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 21:05:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "khushit.shah@nutanix.com"
	<khushit.shah@nutanix.com>, "seanjc@google.com" <seanjc@google.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>, "x86@kernel.org"
	<x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>, "Kohler, Jon"
	<jon@nutanix.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcao2DZOfQgSyNM0SHQsXF1rUDp7Uc7oQA
Date: Thu, 11 Dec 2025 21:05:03 +0000
Message-ID: <8d1bba3b8e1ae5bd40a2470417b5580a64027ec5.camel@intel.com>
References: <20251211110024.1409489-1-khushit.shah@nutanix.com>
In-Reply-To: <20251211110024.1409489-1-khushit.shah@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY5PR11MB6138:EE_
x-ms-office365-filtering-correlation-id: 1919eee9-e8b5-4545-8fc4-08de38f8f49a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RkJrQ2FtYTBCTkdRRWpEc0RPQWlrUDc3NkFSWnNCeEp5bG96bGRLOXpLcCtL?=
 =?utf-8?B?SW5kQ2ZMUlNNSmYwYmVvaG4zWTBFZ1RhQ2ZnRnBNL3p4NGI2YjVPYkNjdENK?=
 =?utf-8?B?R0RtRWFHdVQ3dVVFNmhPWEVrblMwUWpJK1BwVWJ5REZRbXVrWkZNSXBlZ3Rm?=
 =?utf-8?B?cHNKdm5NRWIvM05kdElOMlJBRVkxZG1VL25DM29LL3Y3SjI5Sm9IdDEvd3Mx?=
 =?utf-8?B?dlhsVWhza2Z6N1c4cHk0L0wrOE9vem02SUwyUUJxOTlraTRMZEljdm12MS9K?=
 =?utf-8?B?QUt1VDE2ZnRyUlF1UlhYNU1HTDl5aHprM29yQ0NVWTlnd2F0TXA5WUxjSjVF?=
 =?utf-8?B?aWlVUWY4TzFram1KNmVQWUpMNENjS1VtUmNHT0dMRkJCYUxJYWRVWHVpbWw1?=
 =?utf-8?B?TUdlZjNBS0ZVbGN5TTE3aW11ekdlaGlrKzRQbW02eVd3ZnN6ZnVqWTd5dy9q?=
 =?utf-8?B?dDNaQVlITjBHUm04MExYSUp1eWVWVDBNaVo5QkRXUkdrZlNmQldWK1JmL3ZF?=
 =?utf-8?B?VkN5UDBKVnZ2VlBBTm1nSVZ2cWlQTlNnNFRjMzFlR1paRGRmaDNvd3R4eGsy?=
 =?utf-8?B?SEZ1SExyVmN0VFRsdHpxbGpXcFZ4YXBnbkNQRGplQklOTEdFTDJubFhmZWJh?=
 =?utf-8?B?YkYzV2s2dXI4RWdMbGpVeFp6eW03ZS9NNnB2Q1BsTEVuRnFVeHVSenB1bitH?=
 =?utf-8?B?MjJKdm5GNko2elgrYk1Yd20yYnZvUXV3NWtiM29ISS9CaGRTd1Z3SDFlZjhT?=
 =?utf-8?B?ZDdTekxnT215TDUxQmh0c0EvLzRuakFZY2s4enV5RXZwT3A5Nm9wLzI1RmY2?=
 =?utf-8?B?MDJET0ZtK2RuZXFNYlNZU3hUQ1hwN21JQUJNWU42QVJ1Zk5pclFvVFRDd2M2?=
 =?utf-8?B?MkJsN0FyTnU3bFU0MGpTMCtFNktUMjZEbUJRb0JoR1NTVThsclEvQjBFY2xm?=
 =?utf-8?B?eS84emYxOGFHTm5qK2pkNDQyTWZmR3g4UTllSm9zR0ppRVR3ZzZib05xeDJ5?=
 =?utf-8?B?Nzl6UHlMd3MxQnRESU9jQVJCMkhxZElJMWpTcjVVcHpSQ1hDMVhZcVVQdnFW?=
 =?utf-8?B?N3pOT3VNNk1ENTluR0xOckNaQ0JXanlLN0p4VmU4QWFZMnpBR2FrbkFTclVy?=
 =?utf-8?B?OERHSE5MRHpzV1FBUjgvZFBITGFybW10OWtaOFdlSDRaSnBKWUZtQ0lWeG9H?=
 =?utf-8?B?NFM5OUlwbklOSDVTc25mNWIxd21oOGlDWWtPOU5IN1Q5TWhxcFNXK0xSeVk1?=
 =?utf-8?B?a3BrR0ZuOGVCbzZESzdueVdrVTMxbmhxc09wS0VZajg0TVRKQ0VzQXJneUZr?=
 =?utf-8?B?aktybE5mYVVJTURWS0k4RmZGQ21uaW8xb3hNaS9SdmNQSnk0V0UrOHZjdS9D?=
 =?utf-8?B?SitETTJ1L0tQZ25QQ0VvNjFyRUtVcTZQMmMvVWZEdmRtdEVZMGpCR3QxRVFk?=
 =?utf-8?B?Wm5LVGx2ZjBhNkQ5MU14OFhMYjZQblJYTFJhNERQVVpmQ1RPTjdCZ1o0NlFX?=
 =?utf-8?B?TDQzWGRyNUgwb205dnFhaWZFTnRNMHhYTmt6REdhT005NzJNVDR2ZzdmTk95?=
 =?utf-8?B?MG1ZT0ZNMTRNVmxvNVUzMWVJQlluVDFhVXBwQkRWSjFpMXRUdEpPakp2citV?=
 =?utf-8?B?dHcwYXg5dzFMcXlOc240T2hzcHBNb2t4YW1YSEphSVovWStWT3dwQTVnUG0y?=
 =?utf-8?B?YzF0SUZJNm1oWkl6TzRUOG5jZlZ3M3JJSTg3dWRBRTlqYVF0cVBoQzlQWWFv?=
 =?utf-8?B?aXdSY1d5TGFiSGE0MVMrYWtGVm9MaExYYVpoaG5xN1JFeWI5MzJjbFQ4R1hp?=
 =?utf-8?B?OGNLbU9uVy84c2U2QWd0KzZ1Y1VId21URHpSTnpOdHNSejlOYVRqV3NGYm1M?=
 =?utf-8?B?NStPKzNudDdHdFNwVzd6eExBczZteWpJcUpKSkpxZFpHRGZWUWZHOHlDWEV4?=
 =?utf-8?B?OXZEZ3dib2NQQSs3WG9uRGpVSzVnNVV5QjZmYW1BeWViMEUxMlM4Wlhoc3BO?=
 =?utf-8?B?a0wyQkUrVCs3VnlHUWNnY1NwTU5tUlprVjh2UTFSL1NXeXJuMEJzaWFJVGtN?=
 =?utf-8?Q?s65fNP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGJ6Mkw1Sm9vNDdqaXBrQTdFQ2RuUUV2RTNBWU9LaWx4M2NDM0pqcUhhd2Fu?=
 =?utf-8?B?RThmNjY0U0ZmT3BOVW1PR3ltdmNrazZDQ25TSllsalBGVHQvRC80aGNpSXlQ?=
 =?utf-8?B?VWhvTFl4M2FvQ3dJQkU2N3RvbWxuODhmUTg1ZEZFSm9qcFE2aHo1MkFYWmJ4?=
 =?utf-8?B?a2tVTnF0TFBWNmJBZkNMbU1wdHpvMXJReVJPUW5tVW1OTk5PQnM4SnBJT0g5?=
 =?utf-8?B?dUVHeDQxcUEzTGtBajVYWDNMTkdON0N0Uml5cUpjWmlxYncxY1M5blBBT2JK?=
 =?utf-8?B?Ymxla1Ywb0ZrVkd4RlhQWmM1cWg4MUgzZnV5VGJFajdQTkRER3NzRUVEdjFL?=
 =?utf-8?B?R3dFc3FlbFBacnBVOTJVRzlzTGV4YTdOVFB3MkVtNUFnS1RnQ3VFZTRLdGhv?=
 =?utf-8?B?NW1jU3NPS0I4SU9sZkJIWWQ2NlhTMmlpZ3ErRkFUVm1ERnJJV0JmYy8zVjlm?=
 =?utf-8?B?ZEp6OWdyK3piMmdmbHdVSW1EbExMa2E1RmFHejFIK2xNTWhLaHA4N0t3cENP?=
 =?utf-8?B?dXBaV2NlaW9JSVFjRjVRb0I4eThjU2duZzJ6QTkxV0ptSGMxL1lOb2k1Ukxm?=
 =?utf-8?B?N3UvUnJSY1NETStkcWFHWVZKWGJRdWFJSFZlL1ZTemcwTUxpNmwzcHVjU2hC?=
 =?utf-8?B?N2Nac2kvWVdZUGVURGdsektDZEp3amdkeUJWWG9RMXBZbDdXQXp0ZDhQT0dX?=
 =?utf-8?B?Zmt5eHAvVDJvUHNvWElYcTgzV1ZpMm83SENLZ0tJMWYzS2Q0NW5TNk40bW1J?=
 =?utf-8?B?US9oTGpEQW9Rc2ZhY0habS9ONWpWZzVxRTlpVzJQcUxuZFl4U0lYYjQ1SG1n?=
 =?utf-8?B?SGswU25MdGU0WmpyMDlDK1MzT3JNd3Z3V29MbWI0RExDak1PYVVqM0hOc1Mz?=
 =?utf-8?B?alg1WGVqeWRLRzRLYkFoaTN5VFlpOTNSV1lWbnl1aCtITUpHSHJhVVJKUVdQ?=
 =?utf-8?B?ZmREM1Y4TjF6Smt4TlE2NGRzUXdzZStibVowKzNUd3pxQlZiTVc1NkhsZXlB?=
 =?utf-8?B?MFdSRWJ2WWhHUnRjaTQ1alBXYVRJdjJKT3hHcDV6NHgyN2twdFhaZGw3VThB?=
 =?utf-8?B?c0QxV2poamRvOVRyTndUOHpWcm5HaHlkNjRTbmQrSFErcEZBR21jSCtHZXh0?=
 =?utf-8?B?bGJHcEpQNFREVTQwVTFpMTBJbmI2V05YbnFtaCtPcXdXYlo2a0xzdTRTcnVx?=
 =?utf-8?B?WW5hS2VuYnZ2dHlORmJUR0pUTEtZUWhHanU4U0k1T2tWS3JEMXl5VG9hUUdp?=
 =?utf-8?B?czVDL3YyaWdBMUlFMFpJUUIwTi9uN2ZQTmJRMzIwZFpuUDdIeTczeXE1RlZa?=
 =?utf-8?B?R1VaTHF2WHFIQWY2Vi8rcEFFWURBQ1FQMnVWbmExUW1UU25FQW1lVkZYVVcx?=
 =?utf-8?B?V1ArUElvTHNPb2VYWDFDbnZUS3Q0WDUzcklvbUovYzZ0cHZvUENmV0I4UGpH?=
 =?utf-8?B?VituTjF6eXE5YWRTUCtZOHhST1FKV0xNb0ZLL2ZKRnhjUDRwS0dPOXVXUUZk?=
 =?utf-8?B?cFBpT0s4eEx6VmpRN0s2RmNMSzRZd2pXUnBTZFU3Q3FTQU80d2J0aHJmUHNq?=
 =?utf-8?B?blhuSmwxTmVSdWNlQ0plTlFQR2cxVGtFM1hMdVJwdTRNWG56Tk5ZMEQ0Zkox?=
 =?utf-8?B?SU5yVHpFRlBscnpUOEJLT2tkTEpQMXMwYmVJN0VSN1VFYm10NTJONWFHeUNr?=
 =?utf-8?B?Yyt0QmF3cDE3YW5OMXhJOFozbmpobXZRcXVtY3hkV1B5MEJGdElYR3lCUHZs?=
 =?utf-8?B?ZUloUU51VXRnSjBaN0o4Vnp6NC9vYnB3emZBTmZ0MHMzS3lXWmh4S2E1RkEz?=
 =?utf-8?B?bDBTMHVaTnhET3Q0WlR1blJhR0dUbkxwcjNrR1RNdUhiMmc3eWUrY0ZkL2c4?=
 =?utf-8?B?YkFEWVNKVUZUdDA5bFZFbWU0SEE0c2ZzWXVSWEZkMVpFd0xkbEQ3bGRFNEpx?=
 =?utf-8?B?VXhnclNwNGRTVVZ1M3h6MTFxYmsxNDF2dldKUHdBZGZmald0YVZCMFJvY1Q5?=
 =?utf-8?B?NitXRlphVXBEMi81cTZxUDhIWE4zM3h1RWE1WnB2TnNYT01wU0tySGcyTmhy?=
 =?utf-8?B?RDlLQkE5NVo5Vzk4QVhwTmdQK0NlTmNYUlZNOC9HbjhLeXB0VDJNWFUyaUQ1?=
 =?utf-8?Q?26mD/DjYQXHIcMq9OkCgz6bLL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <037477CAE26466439738E8A14B009FCE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1919eee9-e8b5-4545-8fc4-08de38f8f49a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2025 21:05:03.9293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q8szajmioom1zF/nPzqAHxFEAEosi2RWjr5ihm6nV8LCv/xjTmdzPEgnsU+hFIMG4HfYqlITvVp4I/YGktwSQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6138
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEyLTExIGF0IDEwOjU5ICswMDAwLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+
IEFkZCB0d28gZmxhZ3MgZm9yIEtWTV9DQVBfWDJBUElDX0FQSSB0byBhbGxvdyB1c2Vyc3BhY2Ug
dG8gY29udHJvbCBzdXBwb3J0DQo+IGZvciBTdXBwcmVzcyBFT0kgQnJvYWRjYXN0cywgd2hpY2gg
S1ZNIGNvbXBsZXRlbHkgbWlzaGFuZGxlcy4gIFdoZW4geDJBUElDDQo+IHN1cHBvcnQgd2FzIGZp
cnN0IGFkZGVkLCBLVk0gaW5jb3JyZWN0bHkgYWR2ZXJ0aXNlZCBhbmQgImVuYWJsZWQiIFN1cHBy
ZXNzDQo+IEVPSSBCcm9hZGNhc3QsIHdpdGhvdXQgZnVsbHkgc3VwcG9ydGluZyB0aGUgSS9PIEFQ
SUMgc2lkZSBvZiB0aGUgZXF1YXRpb24sDQo+IGkuZS4gd2l0aG91dCBhZGRpbmcgZGlyZWN0ZWQg
RU9JIHRvIEtWTSdzIGluLWtlcm5lbCBJL08gQVBJQy4NCj4gDQo+IFRoYXQgZmxhdyB3YXMgY2Fy
cmllZCBvdmVyIHRvIHNwbGl0IElSUUNISVAgc3VwcG9ydCwgaS5lLiBLVk0gYWR2ZXJ0aXNlZA0K
PiBzdXBwb3J0IGZvciBTdXBwcmVzcyBFT0kgQnJvYWRjYXN0cyBpcnJlc3BlY3RpdmUgb2Ygd2hl
dGhlciBvciBub3QgdGhlDQo+IHVzZXJzcGFjZSBJL08gQVBJQyBpbXBsZW1lbnRhdGlvbiBzdXBw
b3J0ZWQgZGlyZWN0ZWQgRU9Jcy4gIEV2ZW4gd29yc2UsDQo+IEtWTSBkaWRuJ3QgYWN0dWFsbHkg
c3VwcHJlc3MgRU9JIGJyb2FkY2FzdHMsIGkuZS4gdXNlcnNwYWNlIFZNTXMgd2l0aG91dA0KPiBz
dXBwb3J0IGZvciBkaXJlY3RlZCBFT0kgY2FtZSB0byByZWx5IG9uIHRoZSAic3B1cmlvdXMiIGJy
b2FkY2FzdHMuDQo+IA0KPiBLVk0gImZpeGVkIiB0aGUgaW4ta2VybmVsIEkvTyBBUElDIGltcGxl
bWVudGF0aW9uIGJ5IGNvbXBsZXRlbHkgZGlzYWJsaW5nDQo+IHN1cHBvcnQgZm9yIFN1cHByZXNz
IEVPSSBCcm9hZGNhc3RzIGluIGNvbW1pdCAwYmNjM2ZiOTViOTcgKCJLVk06IGxhcGljOg0KPiBz
dG9wIGFkdmVydGlzaW5nIERJUkVDVEVEX0VPSSB3aGVuIGluLWtlcm5lbCBJT0FQSUMgaXMgaW4g
dXNlIiksIGJ1dA0KPiBkaWRuJ3QgZG8gYW55dGhpbmcgdG8gcmVtZWR5IHVzZXJzcGFjZSBJL08g
QVBJQyBpbXBsZW1lbnRhdGlvbnMuDQo+IA0KPiBLVk0ncyBib2d1cyBoYW5kbGluZyBvZiBTdXBw
cmVzcyBFT0kgQnJvYWRjYXN0IGlzIHByb2JsZW1hdGljIHdoZW4gdGhlDQo+IGd1ZXN0IHJlbGll
cyBvbiBpbnRlcnJ1cHRzIGJlaW5nIG1hc2tlZCBpbiB0aGUgSS9PIEFQSUMgdW50aWwgd2VsbCBh
ZnRlcg0KPiB0aGUgaW5pdGlhbCBsb2NhbCBBUElDIEVPSS4gIEUuZy4gV2luZG93cyB3aXRoIENy
ZWRlbnRpYWwgR3VhcmQgZW5hYmxlZA0KPiBoYW5kbGVzIGludGVycnVwdHMgaW4gdGhlIGZvbGxv
d2luZyBvcmRlcjoNCj4gICAxLiBJbnRlcnJ1cHQgZm9yIEwyIGFycml2ZXMuDQo+ICAgMi4gTDEg
QVBJQyBFT0lzIHRoZSBpbnRlcnJ1cHQuDQo+ICAgMy4gTDEgcmVzdW1lcyBMMiBhbmQgaW5qZWN0
cyB0aGUgaW50ZXJydXB0Lg0KPiAgIDQuIEwyIEVPSXMgYWZ0ZXIgc2VydmljaW5nLg0KPiAgIDUu
IEwxIHBlcmZvcm1zIHRoZSBJL08gQVBJQyBFT0kuDQo+IA0KPiBCZWNhdXNlIEtWTSBFT0lzIHRo
ZSBJL08gQVBJQyBhdCBzdGVwICMyLCB0aGUgZ3Vlc3QgY2FuIGdldCBhbiBpbnRlcnJ1cHQNCj4g
c3Rvcm0sIGUuZy4gaWYgdGhlIElSUSBsaW5lIGlzIHN0aWxsIGFzc2VydGVkIGFuZCB1c2Vyc3Bh
Y2UgcmVhY3RzIHRvIHRoZQ0KPiBFT0kgYnkgcmUtaW5qZWN0aW5nIHRoZSBJUlEsIGJlY2F1c2Ug
dGhlIGd1ZXN0IGRvZXNuJ3QgZGUtYXNzZXJ0IHRoZSBsaW5lDQo+IHVudGlsIHN0ZXAgIzQsIGFu
ZCBkb2Vzbid0IGV4cGVjdCB0aGUgaW50ZXJydXB0IHRvIGJlIHJlLWVuYWJsZWQgdW50aWwNCj4g
c3RlcCAjNS4NCj4gDQo+IFVuZm9ydHVuYXRlbHksIHNpbXBseSAiZml4aW5nIiB0aGUgYnVnIGlz
bid0IGFuIG9wdGlvbiwgYXMgS1ZNIGhhcyBubyB3YXkNCj4gb2Yga25vd2luZyBpZiB0aGUgdXNl
cnNwYWNlIEkvTyBBUElDIHN1cHBvcnRzIGRpcmVjdGVkIEVPSXMsIGkuZS4NCj4gc3VwcHJlc3Np
bmcgRU9JIGJyb2FkY2FzdHMgd291bGQgcmVzdWx0IGluIGludGVycnVwdHMgYmVpbmcgc3R1Y2sg
bWFza2VkDQo+IGluIHRoZSB1c2Vyc3BhY2UgSS9PIEFQSUMgZHVlIHRvIHN0ZXAgIzUgYmVpbmcg
aWdub3JlZCBieSB1c2Vyc3BhY2UuICBBbmQNCj4gZnVsbHkgZGlzYWJsaW5nIHN1cHBvcnQgZm9y
IFN1cHByZXNzIEVPSSBCcm9hZGNhc3QgaXMgYWxzbyB1bmRlc2lyYWJsZSwgYXMNCj4gcGlja2lu
ZyB1cCB0aGUgZml4IHdvdWxkIHJlcXVpcmUgYSBndWVzdCByZWJvb3QsICphbmQqIG1vcmUgaW1w
b3J0YW50bHkNCj4gd291bGQgY2hhbmdlIHRoZSB2aXJ0dWFsIENQVSBtb2RlbCBleHBvc2VkIHRv
IHRoZSBndWVzdCB3aXRob3V0IGFueSBidXktaW4NCj4gZnJvbSB1c2Vyc3BhY2UuDQo+IA0KPiBB
ZGQgS1ZNX1gyQVBJQ19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCBhbmQNCj4gS1ZNX1gy
QVBJQ19ESVNBQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1QgZmxhZ3MgdG8gYWxsb3cgdXNlcnNw
YWNlIHRvDQo+IGV4cGxpY2l0bHkgZW5hYmxlIG9yIGRpc2FibGUgc3VwcG9ydCBmb3IgU3VwcHJl
c3MgRU9JIEJyb2FkY2FzdHMgd2hpbGUNCj4gdXNpbmcgc3BsaXQgSVJRQ0hJUCBtb2RlLiAgVGhp
cyBnaXZlcyB1c2Vyc3BhY2UgY29udHJvbCBvdmVyIHRoZSB2aXJ0dWFsDQo+IENQVSBtb2RlbCBl
eHBvc2VkIHRvIHRoZSBndWVzdCwgYXMgS1ZNIHNob3VsZCBuZXZlciBoYXZlIGVuYWJsZWQgc3Vw
cG9ydA0KPiBmb3IgU3VwcHJlc3MgRU9JIEJyb2FkY2FzdCB3aXRob3V0IGEgdXNlcnNwYWNlIG9w
dC1pbi4gTm90IHNldHRpbmcNCj4gZWl0aGVyIGZsYWcgd2lsbCByZXN1bHQgaW4gbGVnYWN5IHF1
aXJreSBiZWhhdmlvciBmb3IgYmFja3dhcmQNCj4gY29tcGF0aWJpbGl0eS4NCj4gDQo+IE5vdGUs
IFN1cHByZXNzIEVPSSBCcm9hZGNhc3RzIGlzIGRlZmluZWQgb25seSBpbiBJbnRlbCdzIFNETSwg
bm90IGluIEFNRCdzDQo+IEFQTS4gIEJ1dCB0aGUgYml0IGlzIHdyaXRhYmxlIG9uIHNvbWUgQU1E
IENQVXMsIGUuZy4gVHVyaW4sIGFuZCBLVk0ncyBBQkkNCj4gaXMgdG8gc3VwcG9ydCBEaXJlY3Rl
ZCBFT0kgKEtWTSdzIG5hbWUpIGlycmVzcGVjdGl2ZSBvZiBndWVzdCBDUFUgdmVuZG9yLg0KPiAN
Cj4gRml4ZXM6IDc1NDNhNjM1YWEwOSAoIktWTTogeDg2OiBBZGQgS1ZNIGV4aXQgZm9yIElPQVBJ
QyBFT0lzIikNCj4gQ2xvc2VzOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vN0Q0OTdFRjEt
NjA3RC00RDM3LTk4RTctREFGOTVGMDk5MzQyQG51dGFuaXguY29tDQo+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+IFN1Z2dlc3RlZC1ieTogRGF2aWQgV29vZGhvdXNlIDxkd213MkBpbmZy
YWRlYWQub3JnPg0KPiBDby1kZXZlbG9wZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNo
YWhAbnV0YW5peC5jb20+DQo+IC0tLQ0KPiB2NDoNCj4gLSBBZGQgS1ZNX1gyQVBJQ19FTkFCTEVf
U1VQUFJFU1NfRU9JX0JST0FEQ0FTVCBhbmQNCj4gICBLVk1fWDJBUElDX0RJU0FCTEVfU1VQUFJF
U1NfRU9JX0JST0FEQ0FTVCBmbGFncyB0byBhbGxvdyB1c2Vyc3BhY2UgdG8NCj4gICBleHBsaWNp
dGx5IGVuYWJsZSBvciBkaXNhYmxlIHN1cHBvcnQgZm9yIFN1cHByZXNzIEVPSSBCcm9hZGNhc3Rz
IHdoaWxlDQo+ICAgdXNpbmcgc3BsaXQgSVJRQ0hJUCBtb2RlLg0KPiANCj4gQWZ0ZXIgdGhlIGlu
Y2x1c2lvbiBvZiBEYXZpZCBXb29kaG91c2UncyBwYXRjaCB0byBzdXBwb3J0IElPQVBJQyB2ZXJz
aW9uIDB4MjAsDQo+IHdlIGNhbiB0d2VhayB0aGUgdUFQSSB0byBzdXBwb3J0IGtlcm5lbCBJUlFD
SElQIG1vZGUgYXMgd2VsbC4NCj4gDQoNCkkgc3VwcG9zZSBhZGRpbmcgc3VjaCBzdXBwb3J0IHRv
IGFsbG93IHVzZXJzcGFjZSB0byBhcHBseSBlaXRoZXIgZmxhZyBpcw0Kbm90IGNvbnNpZGVyZWQg
YXMgImJyZWFraW5nIHVzZXJzcGFjZSBBQkkiLCBzbzoNCg0KQWNrZWQtYnk6IEthaSBIdWFuZyA8
a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K

