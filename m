Return-Path: <kvm+bounces-25201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E969618A3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:41:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDDA7284EC4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 20:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5A31D175E;
	Tue, 27 Aug 2024 20:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FZVqKM1f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D83183CCF;
	Tue, 27 Aug 2024 20:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724791265; cv=fail; b=KwawYoLod+ptTgNiJRKvI9Vvj4N18ZxADCt29wabVjvUfKV2WM49ZTbKvlRTejDVepc1u4elfJLBiZUDG6wPkAT2GEvKwzByOau8hK1GEud4KAV9x8pxxGb3lgoH2TJkeRWPvEIaD+8hmUwXjWiPP4XRQO2jDev/4vEYjaw8NoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724791265; c=relaxed/simple;
	bh=DRwn8P111+b8PqEdpN6aJESxtMLQ/HAmqZxm4hz3q6E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UXlD9anWjdK22DmvSupcwMndSByMAk/7w3wpf9bmhuFShUZpVZCloIWjAJ52ezoARc7RKSo2ofIBbGUdm9IKfNyQEz32ObM4rmKeRwm0dEVN8F6VtNKbwja5uYqbO5ZAk24agcA/Ijw9U/xDFsWIEmHuQJT5ItBpL9gyM1bytwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FZVqKM1f; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724791263; x=1756327263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DRwn8P111+b8PqEdpN6aJESxtMLQ/HAmqZxm4hz3q6E=;
  b=FZVqKM1foY804Fkz5bs/3/eRGdwTu9jblUVeplY6MwVGshEVk0x02oRu
   /dcZPFdx5qCaGOyrDb3/mWN2YbYwXunmplweL9yhY7X2X7gWW0w1ruNxJ
   DkPYtse40uBQHUgr+yMwTkdQQ3KpjvLKMX5hOeKj3Z0bAY3FNb8y4eu7B
   bqYT9YR55PYIjkTSqrSr+FYSOsFHuG/hFGMZw29ftzw/xsDHqKuNMnTe0
   h6QWP4BGEVL+0xHOnLIckt0OPr5CQtFeuGx0o0NQ9vWGGUW3LVRJd8EMC
   ybjS7VFJKR7qY0OJ6NcfgXI3KTwOeJKLCSXdSyZUy0WFHS8Hir0cLXFRk
   w==;
X-CSE-ConnectionGUID: X1FeZuMiRKS3VpRYgatkBQ==
X-CSE-MsgGUID: oS//S073RACjBVDh4rKI+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="34451596"
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="34451596"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 13:41:02 -0700
X-CSE-ConnectionGUID: WTC+CenZRI65f/Vmh1rxtw==
X-CSE-MsgGUID: BWX8zixnR1mB3ckpkIxXgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="86186675"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Aug 2024 13:41:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 27 Aug 2024 13:41:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 27 Aug 2024 13:41:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 27 Aug 2024 13:41:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+1zz9zFFztK6GRSKed7H2i3oaooZwk1BsdZplzWA2T4a1/qyJOL3x5LlZJM5DXV983OkLzC26ARPdeCSUBbguIQXB5q5fTVhAmtMKF0fc70teNf09IObIsxTnhngzbF61LYXSDWTuG4EBugBnEFCddMjOaZlxCX+gtQgNiR5aabL23aDLngzlJ44lLdze6a4H88aeqVWvYgAi6ScKp5HZQvsu9EmodITs7l5xMFaHPKJMcvTyOPtSiDLbCL8NdL0tATT6zJmtqerhfA29A01oqBN9EJHbEq3AyZpJ1fNPrHI3oMLI0Gp6Bzj/mOhkS7OkvDgFbBKGL2/QECOKHCSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRwn8P111+b8PqEdpN6aJESxtMLQ/HAmqZxm4hz3q6E=;
 b=vhvsTg+rBuz84HIKuTQwrPRVjkdafRT6BcTogkOtS+G0L9B6dTl+ZNWi9G/PliH/YyfJDnfrRVMnDAdhSFYRFx5J1XD+RH6tWl6sB4eA3tICin1HNydYDsjh3dbiDvi7Kao9V64xD2JO49FNYoqJZKV4Nc5i2RoAF3XHN92HVunSl2BGb+IvwZwgEh5luTFNzmR92ANZUVf7gBQiXsqJsL0nbXrxsEplVro+Gvqxx17P8CYoQqW7nm/LYgn42o2HCZHlhV7USH9lbYs0cKLY5ULdKl8pvMxlcLrU+m6Av/PaDxxnQGKwsPaViEEkARkL9CZPuxKrdEvEe34L6iLebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5233.namprd11.prod.outlook.com (2603:10b6:610:e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 20:40:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 20:40:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Topic: [PATCH 21/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Index: AQHa7QnRzseVoCBaJESngrUu+eI1nLI5qPIAgAA8uICAATcLgIAAjA4A
Date: Tue, 27 Aug 2024 20:40:58 +0000
Message-ID: <61e8b41970f0feddef3d6c3114d40ae8e4992784.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-22-rick.p.edgecombe@intel.com>
	 <a52010f2-d71c-47ee-aa56-b74fd716ec7b@suse.com>
	 <2f9dd848f8ea5092a206906aa99928c2fa47389d.camel@intel.com>
	 <40fe0a1d-9ab8-4662-a781-002d70a1587b@suse.com>
In-Reply-To: <40fe0a1d-9ab8-4662-a781-002d70a1587b@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5233:EE_
x-ms-office365-filtering-correlation-id: ecacb85a-0792-4c3d-e957-08dcc6d88e94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NTNFRXRhc2N4clJOUVVPSk9UeWIvTHRiRTVBNEZVc0Jmb2hhcjBiWWJMb1Mv?=
 =?utf-8?B?aEhXZ3BaazhreUFvUUtWNjNadWJVUzZUQWc1dWZVdHNjWURoQk16MGVyS0dM?=
 =?utf-8?B?amt2Z1lWRXBpNGh1bmVSRjFmWC9iVitCWktRMytiTzJyOUxYQkVzMFc3cXB5?=
 =?utf-8?B?UkQrMjROODdJclEwdTlvcnc0UTcyZXlxdWNmWXJ2dXROOUtZRm9ZY3grRWxs?=
 =?utf-8?B?TlJEVnZxVjc0Ukk5Q0RjR0xYdHNQS1NOUldvUlNqNGZvZW00eTAyWTF5bzg1?=
 =?utf-8?B?SE1QeGNGTmlNaTV5c1JNdDdJb21KTUZJSkJxWmNFOXZxT3RENmxNTXZlMUto?=
 =?utf-8?B?M0tnSU1sdjZ2MGJzUnFidWhnODFuUjNHa1EyWDBadjlUcXBIeHVMQ0tUdG5D?=
 =?utf-8?B?S045Nk5WbktPZDR6aVZJZVZJd2ticGpSelJrMDhYeDZRWWpGQ1hJWUJTc2Fa?=
 =?utf-8?B?aXl1TWN4NDlnU1BuVmJ6ckNiUGg2Ry9rRFN5OFZnTlhwOUVlN1JFWXBRblUv?=
 =?utf-8?B?aHNVQ3hIK1BlUnl6YXc2NkVTeFF1RThLdTJQVDhFSzFzSFFYVElaNFJVYnJE?=
 =?utf-8?B?MkpxUUJtODZzNlZOOHhQYk81SUFLN0JmTzhuRk80R1FaUlROYXRyYW10T1kv?=
 =?utf-8?B?L0pMMEJXNFF6ZjI2RXlMeDBWZDNLWE9Pbko3QkVZTTQyK0tHbUwzWmE5cmNF?=
 =?utf-8?B?clV3UTdodmpjbUxsa2UzS1ppZTdVUDBFaXpwZWpBRjhXZnBTRVhXTWFTUXpE?=
 =?utf-8?B?RU9GL1lRNHFPZ24yZXY4ZFdmZUZXb2wxSDJ1dmdJKzN1ZHYxSDl5V1lNaWFl?=
 =?utf-8?B?MEJUbHdCdVJFOUE0ZWh2V2JXVVhFZGwzb3F2eGZJdnRIYlNoeCtKMzBHR0tK?=
 =?utf-8?B?SlFVM25ZL2IzYXpweUE2UEQ4MXZGZDc0MGdjZ0hBcVM5VDd0UlI4N1VNRWFr?=
 =?utf-8?B?WkFRRkxtb3BJWUJDRnhJN0R5SktQVFRqZzZhcE1UZS9CUTdwcU52ajh6SVZ1?=
 =?utf-8?B?K2VWQ1Q1VVBPd3lTNmJiTEpueHdqeHRaZHpaTWFlWTNhMldkUXJaNjh1M2JK?=
 =?utf-8?B?eVJnbWR1STZVdDJ6OFg0SFZFam13UnN5UnFvdXcyZnFMOUZKeEhqU1Q0MUdv?=
 =?utf-8?B?d0RQZkpHTk94SkgveGNFZWZwYWZzV25RNi90bXdaSDltYjVWSzhoVUt0c2Mr?=
 =?utf-8?B?UjAwTjcxVUpiRUFWYWJ2bWQ2WDhtblVVTVpmdStmb2UrMkh1Z1A4R2g1b1Zs?=
 =?utf-8?B?Z0ozemlCSjVMWklKN0IyQ2k1S084STB6NExzbWFZNEdjdEhUSDRBcTFEYXls?=
 =?utf-8?B?SkJORXFOQzJmMkpzeWxWazhTRldvZnVmejlSb1Aydk0yb2FlemsySXBURkNG?=
 =?utf-8?B?Zm1qWE1nQVRHM3BiT1RHVndzNC9PSmFWUnloVVZZK2RmVndqRkZqd2ZMaE91?=
 =?utf-8?B?bCtIcmZ3R2hIZFc4Q3pyb3FPOE5YMVdWN2Uvb2w4aERKclpnOGRLNTJxakR6?=
 =?utf-8?B?UkN0K1NQb2RvQ2daNWZ0VDI4dDRwZHZnRHpXazVvajJ1anBsYThhWEJVWXVM?=
 =?utf-8?B?MTNTdlhobVZlOUt4Q2I1L0xxQ3VGcVhuNUZjTXNvYkgzK3JFRWNreTdFQUx5?=
 =?utf-8?B?WVNhVWVUVHFWOFRjREFURE9pald5dTJnK094Ums2a3ZnYUlDRW5VaHNZUnJk?=
 =?utf-8?B?Vm5iREpiVXNGZlVKQVRiVVNyd3poZzk4ZUc2L0svQk5NaS9WMHBtUkdyTG94?=
 =?utf-8?B?Y291TDZpanNLdkxOT0FMb05TMTBjbnZ2bFJVOWxjNHRwVDlpV0t2QlE4VmFY?=
 =?utf-8?B?NjYyYnpPaFdsRnc3cHVmSU5RbE51a3p3dVdVK2NzaEdFTWJzMzd5cE80dDBj?=
 =?utf-8?B?cEtZaWNjYW1xMzF5YVF6ZlJYL2l6Ty9hbXZYU2R0SjIyNGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXBHZm9HblBTb0VKQmdoNG9IZnExb3ErVHZzNDlLWW1JaDR3RXFHMWxrd3ds?=
 =?utf-8?B?dTRSV1o1OTM0VjVIV0NXYktqT3BxZlB0TkFTaUNwcklJbTFVUDdoNjZyM2x6?=
 =?utf-8?B?OFBsa0hJVjBwemtCUngxTi9kSGlhUCtpdmo0VkhvNFpNSDhPQWRET0Zrby9Z?=
 =?utf-8?B?cTdVSjJhcklvTnBKR0N4Nk5TQXdqd3RZRVo1eXlLTlJaWWRQMk9PWHBlN2VO?=
 =?utf-8?B?MVNQYmF2SXhzN0F3SmZ5UzNVMklacC9NSTVRb2ZMMWpMRkp4dDYwbTVpT3c4?=
 =?utf-8?B?bHRDK3MxOXNTOUZsaG9LQkJ0aG1YZGVha0puRXVySzFQK2ZoeitjcE1Jdi9q?=
 =?utf-8?B?R1o3aFZWeTB4TmhndDhYdGZuNjdmb0lLd3ZmNVdsSi9xZ3hLbkRwY2QxQ0pZ?=
 =?utf-8?B?NFlXb2Exclo5djY4dlQ3TlhldGkzUitxeHJuM3BIWm5zTi9LTHFVWkt6UFZs?=
 =?utf-8?B?eVpDYlRQRURENW55aE9hNlhwSUhSK0xIU0VqYUoxaVRXUnVlZ0xtMDlGMGx5?=
 =?utf-8?B?ODBtWjVqUzcrZDBGMFRoK1BUa1NvYmxtOTJKZHJ5V2xRZkdJaC9CcU9CZUhy?=
 =?utf-8?B?aS9wcUIvM1hhSWN4RlhyVDFicFBBeWVyMXdFMXdCem1saWFlcFh4SW50NXhU?=
 =?utf-8?B?Qm1xaXkzZ3AvVjRMK2FPRjJrTkUwZXg3VkpmQXhnOUxDN29Mcjcyc1FIenZB?=
 =?utf-8?B?NlAzTFhjeFU4b1hpSU1MK0Q5dDdDZW95djhuS1BOV0R5RVlVY21QMDlhTlE4?=
 =?utf-8?B?WGgyNVFBblRxMjdXZUJRVXYrMklvci95dDhKUWlyeVpEQ0VQU3FyUTF4THFa?=
 =?utf-8?B?Mlk1UWdmTmFwNnNBbk10MDUwMThZQ3hYMVJjcDRXeEsrMWFlTDJSalZVZCtL?=
 =?utf-8?B?NXZ4T3dDNFFHUkFzY3lRMzVCa001dnpzeHRobnR3Zy9Ma25VOWxtVElyMEN5?=
 =?utf-8?B?aHhoWC94NG56ckhUQkc5dW1JNDR6ZVdFVlVrekVjakJpLzM3RTB6YjdkRk93?=
 =?utf-8?B?VGhPRnprUDVEZVJoeU8rY2RYVjIwWGZIZ1dxTHRMYTYxdGtlbnhjU0o1V2U5?=
 =?utf-8?B?cDBlQVdqMjhDdmFwK2p1TVFsOG5NTWk2czNEQy9hRFB3b211bUVidkwwTkZF?=
 =?utf-8?B?YUdmWFBoeVFMWEliQjhwTHRJUGl4Z25sWVBFaU1NZzlwVWJ6Y3A5Ukgxd3JS?=
 =?utf-8?B?V3RmQlZhV1czajNoaWhEUjB3bVdhcWxXb0k5UXRobnlBM0tDYkZOYlhpVStt?=
 =?utf-8?B?cmsyYkxUQmVMNm1TMXQxTnFWOVAxYW5uYkZTNk9wZ1dzdVJLRVJ4cnREY2N2?=
 =?utf-8?B?UUh0alc1ZlJLZTgrUGFuUmtoVGwxZnpYMGdEbXFobHBveHYxaTI0V3plZjFa?=
 =?utf-8?B?Z2ZOMlY2SVZNZURNVXozL0RRTExENzBscGxNNTJhNUd2MlEyL2lMWjRUSFk1?=
 =?utf-8?B?Um9adzd3ZHUrcXVtYnBvV2YwK0NXejBXVTkzL2xkZmVwZnFCbWllSXUwV2c1?=
 =?utf-8?B?OG95K3dIN0NCQllqL1M1cm5XclUyUDFSb0ZqWUtmUzhIQjRBUlY4ejg0RUxP?=
 =?utf-8?B?WVprVjdnakRsQ2VRZWZmUm1tRUVTcjJVVlZUbXhUL0xienRyOERSaGtJbW52?=
 =?utf-8?B?aFgwN1h4cHpQS25MZkZjZm5zWlc2RGlUS0NQdGprRUNobnQxVjdzMjJJak0v?=
 =?utf-8?B?clZLTmxBd0w0dFVGVE9iTmxBd0VQNzVKN3J3N2FuclVaSG5ja0YyS3Q2enhQ?=
 =?utf-8?B?Qzg1dHBZKzVKNjhua0NyTjRtMWd6K0tRMmNGOXc5b3FrWE1Fa05QbUdVRTQ5?=
 =?utf-8?B?TFNwY0pnaUI2UWxnZ05BRWUyZWtuaWJmaTRleWtYTDN1UDJWcHlMYnNnS0Yv?=
 =?utf-8?B?VDkzc0tLRlQzNDFrRUNacjQzVUY2VHNHS3BjVjd3Q2dVZ0tKckhSU3dTemNZ?=
 =?utf-8?B?VVc4ZDJsVGwrbTlrVkNtb2xTM0JHb1U3UG5pVkVHdjVqSUI0WUJ3S3JsU2Zi?=
 =?utf-8?B?amVSVU5zTUtjYXlUZ2xFYjZGTzR3OVowWU52ZDZZRS9hWlYxOFFBT2JPSHV6?=
 =?utf-8?B?UW5KZ25vb2xzRnNKUzg0TVJ6VTlGbVRYVGpKUVpxVDdkakhxRFU2OUxpNVd4?=
 =?utf-8?B?Q3FieEl0T284ZW5NemxhRXZlKzIxMU13UUI3YVY3ZUZuVk9OVXlVdDJHT1Uy?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F9AC509DB06524097937CE6FB70A10A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecacb85a-0792-4c3d-e957-08dcc6d88e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2024 20:40:58.6904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jrkSKgJ6xwyB/SL9hZSfu5Z5/FYiyCg6464mJsvR/nG5UhcYEEda+tUrbP6gw5n8zPKwnNXGfCxsIBnzcBxUZGPydbTV0JCrhfD9Oi0K6iE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5233
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTI3IGF0IDE1OjE5ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQoNCj4gPiANCj4gPiBCdXQgYmV5b25kIGNoZWNraW5nIGZvciBzdXBwb3J0ZWQgZmVhdHVyZXMs
IHRoZXJlIGFyZSBhbHNvIGJ1ZyBmaXhlcyB0aGF0DQo+ID4gY2FuDQo+ID4gYWZmZWN0IHVzYWJp
bGl0eS4gSW4gdGhlIE5PX1JCUF9NT0QgY2FzZSB3ZSBuZWVkIGEgc3BlY2lmaWMgcmVjZW50IFRE
WA0KPiA+IG1vZHVsZSBpbg0KPiA+IG9yZGVyIHRvIHJlbW92ZSB0aGUgUkJQIHdvcmthcm91bmQg
cGF0Y2hlcy4NCj4gDQo+IE15IHBvaW50IHdhcyB0aGF0IGlmIGhhdmluZyB0aGUgTk9fUlBCX01P
RCBpbXBsaWVkIHRoYXQgdGhlIENQVUlEIA0KPiAweDgwMDAwMDAgY29uZmlndXJhdGlvbiBjYXBh
YmlsaXR5IGlzIGFsc28gdGhlcmUgKG5vdCB0aGF0IHRoZXJlIGlzIGEgDQo+IGRpcmVjdCBjb25u
ZWN0aW9uIGJldHdlZW4gdGhlIHRvbyBidXQgaXQgc2VlbXMgdGhlIFREWCBtb2R1bGUgaXNuJ3Qg
DQo+IGJlaW5nIHVwZGF0ZWQgdGhhdCBvZnRlbiwgSSBtaWdodCBiZSB3cm9uZyBvZiBjb3Vyc2Uh
KSwgdGhlcmUgaXMgbm8gDQo+IHBvaW50IGluIGhhdmluZyB0aGUgd29ya2Fyb3VuZCBhcyBOT19S
UEJfTU9EIGlzIHRoZSBtaW5pbXVtIHJlcXVpcmVkIA0KPiB2ZXJzaW9uLg0KDQpIYXZpbmcgTk9f
UkJQX01PRCB3b24ndCBpbXBseSAweDgwMDAwMDA4IGNvbmZpZ3VyYXRpb24gY2FwYWJpbGl0eS4g
V2Ugd2lsbCBoYXZlDQp0byBjaGVjayBmb3IgYSBuZXcgZmVhdHVyZSBiaXQgZm9yIHRoYXQuIFdl
IHNob3VsZCB3YWl0IHVudGlsIGl0J3MgZmluYWxpemVkIHRvDQphZGQgdGhlIGNvZGUuDQo=

