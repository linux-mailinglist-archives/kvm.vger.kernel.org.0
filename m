Return-Path: <kvm+bounces-52184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 135D4B02176
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD03B1887060
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69C52EF641;
	Fri, 11 Jul 2025 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2HqwxEE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D662EF2A3;
	Fri, 11 Jul 2025 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752250505; cv=fail; b=YGF1VvpgoNs6QTujOVUZ0IMDbp2ex4yJ3Oa/PHj2AGh8r6fXj9M5mZWmaVzf6WOuf13yLlvJ6ROoImai814O7+3UV1MUfa13HvuyLNRl1Km6o/dI8SfEeBo6dZw3KvPREkInQ8TPFw7WeTny2q8JmckY+D2dXvDX2YbjL6oxK3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752250505; c=relaxed/simple;
	bh=t7qus5rw4tMPL4Qbpu8Q30l0YicypP8wum8E5dRNApY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QJ3PPEGmDeROIbDxizMIc4kNFJIzDEdEfHqhippppwmoHERMk760E4K16N/sQ05Gbwnp7PTRHfnYLPfA9iHtSG3h0AckQCmzeS3jvzM1e/yCaE7p2nKiutHx2xehgRczIFJKGZGa7BSrhqLgakuGf4IU0hdiBRcHRPOI1X1thYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2HqwxEE; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752250503; x=1783786503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t7qus5rw4tMPL4Qbpu8Q30l0YicypP8wum8E5dRNApY=;
  b=O2HqwxEEJ5ir1Xd1ZdU4hJ4J6ILv2DuMhiCEmj7U//P7aICQPVo6K4Kx
   Yl/A/ilHwKniRSczMaz4tVi4gYW5o7ncpPYGiDW9esepfwuISnvakZg/c
   Ff+M8+MdlxPQtwL/vouTrb9uRIYtiFK6GJCLgk9pw0NR84lNkOjByyGKe
   H/oNPpkxmz29LoYRYvMUjktQast+nXtgfpZf43fq3oiinMw5C4FyGDUt7
   +SSTW19AE0Y1V9ASCgEoGT1xES+w+Wy7eaZ/pPBQtVManHFG4hfT1Gq2y
   AHWkxhWD39KdDT4Y4c5P0KvbD3XaBBUe2h2TwRSo9o8Rind2UJq6vGMC1
   w==;
X-CSE-ConnectionGUID: cYjJjyXJT7eZsHTYJ1XVzA==
X-CSE-MsgGUID: +hJLyrv5T6yVLw+ZoAR5kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54408464"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="54408464"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:15:02 -0700
X-CSE-ConnectionGUID: H23n7mIcTSCthHUKBVQt0A==
X-CSE-MsgGUID: 6ZgepQLjS4+0XpmgtkPomQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="156735748"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:15:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 09:15:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 09:15:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 09:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DJzv7ff3u2lz6yhH4t+ybuAWzRko9h5QagjWP95pixYTC+4FyKJexDnrCc+yR9c601uSu7M7lkx1kVHnFLsqbKbYsb1FK/D8JtTdFF9csTCS+ICE34BFP6c8+rmi27dViCazF45bOTVwohPTavHDkg69kk+AvD/st9/4CMy37ZzVUY+Ikykbp6zCUyyPOBunBs/rqGWBrRUqHSYnW4d1igF3ulcZX4zAGXioKtS7M9JeQnGyo23/+54XUpmHAcAXFv+BcmS5mHIo9zoTyH0ZHKbk0pfsB5AsczItsDStaixujdpj6VTJxGlbQJUfNKNgYujQBQZR1ylOKztvxOOWOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7qus5rw4tMPL4Qbpu8Q30l0YicypP8wum8E5dRNApY=;
 b=PhJpmDqawhYau1Xz0Ftq7u9+DePdxA7H3Yg5cuvuAk+FixtYDav2rKadHaOPnWTiOy87aTQhmKNzfCuhW79niKpLlQqd16do8UrBItn1ta4HcxxU9Q7OE1Ym4iJPmM6vL1Ue4A4rhU9/fYKZzu81BBzvZM8kmbuEdZ/aXiFaA5w4H44Qsw9EMjjL2emqJ8mN/OwSVzX2fUQrpKk17u8/hcINmZh/TgVLXFpv2xQP0WOQJRyRRdZd+rD7JPQ65LnTds448yLML58+jGBqkaccQv017ILtugW0/qkrcsnw4Noot66fRivQrC3VmnZqA0o2vHxOdesI5QY0tbGnPTgA0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6563.namprd11.prod.outlook.com (2603:10b6:510:1c2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Fri, 11 Jul
 2025 16:14:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 16:14:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "tabba@google.com"
	<tabba@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQAgAB5m4CAALvngIAAXakAgAANiACAAXZuAIAAMLoAgAlDjYCAA28yAIAAOYQAgAC45IA=
Date: Fri, 11 Jul 2025 16:14:22 +0000
Message-ID: <4c70424ab8bc076142e5f6e8423f207539602ff1.camel@intel.com>
References: <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
	 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
	 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
	 <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
	 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
	 <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
	 <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com>
	 <a9affa03c7cdc8109d0ed6b5ca30ec69269e2f34.camel@intel.com>
	 <diqz1pqq5qio.fsf@ackerleytng-ctop.c.googlers.com>
	 <53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com>
	 <aHCdRF10S0fU/EY2@yzhao56-desk>
In-Reply-To: <aHCdRF10S0fU/EY2@yzhao56-desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6563:EE_
x-ms-office365-filtering-correlation-id: a227c451-d038-4681-93f6-08ddc095ffab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NDlHNEZPQmh2alp2NTNSMVQ5YmU4UkJodDRoYVNxSUV0c3R0YTY3OC9rckRY?=
 =?utf-8?B?RkNjL1gzbm9OVVNHVTVpQktNUnZNODJEaGtHWjlsQjRWaTBpVDB4SHlDdFVz?=
 =?utf-8?B?bmZsY2RCVnpvSkk5NW9wcEQzbWVZMmtweWRQVWF0OFRCS094d1ZvbHlkTWps?=
 =?utf-8?B?cHA2Q2txa3M1eWIrc1MxNmJGRk9GVk1VUmRsbWw1a05kSkhIRmd5SGM0L3Vs?=
 =?utf-8?B?VGE1dk9LQ3pIVkdLMkU2MmdLV09nYzFNRnQ2a2IwbE80M2d3TFJVUGhTNWJB?=
 =?utf-8?B?L3hZakcvcWtpdEZFa3RzV1pVTVJtSUZ5eFB5eDRqaHdmNjQ4RFpsdWEveVF6?=
 =?utf-8?B?MnVLd1VleE5SQ1hRd2g0UmVBcWV1L3RKTkpOdGo2OG1KQXU4YkNXRXFLZHNj?=
 =?utf-8?B?WXhRL0RNVTJJemt1S05BU0hyS1FKVFlWM04wQzNiZFV6alNsb05HUG9TRTdY?=
 =?utf-8?B?dnJXY0NVV2Z2Q2RoNnFYSk9ST0srQkdHbGFBZzB1cTdQUjJCNFJNYkF2ck8z?=
 =?utf-8?B?Nk43Z1lvUnRuT3VFREJHakhlVUNVUGVGdEV6eG1CV1RyblArVFBXNnhuMTlt?=
 =?utf-8?B?TCtmSk1UWUllcFNhalRDeWtZZmtReDBSNW93S2VHOVJaRE4vZEUxUWhoWlho?=
 =?utf-8?B?UlA2MWJERWhDVms5cmNDMSt5TWo3eERpd0hhUVhkQ3dZQVZQaDE0NGp2cmRp?=
 =?utf-8?B?VVFiUTZEWTRPSFhsdjNZaUpxRythbXdGckpIaGVuNk1DcTViYUlyTm5Cb0R5?=
 =?utf-8?B?dVhxQUJZQ0FPclh2QWY1YXVkbHlzZ2dPQUR5OVNRZG1ZUys1ZDg5QlMvbjhI?=
 =?utf-8?B?N2MyS0tmYStJRDlmQjZTUThIVzVKTHlna1FHODBZdWZRWTc1M3VEN1FMb2pw?=
 =?utf-8?B?RVpUaEs5WGNDUG5jTHN1Ukh1Y2NHNGEwRE1CUXB0Si94bG5ybndxZnNDaHMw?=
 =?utf-8?B?amhqVVhLVE9jeldHWWtkajlqbWkraWRVZWg2TmZkQU9XbllRNHNiRlU4czVh?=
 =?utf-8?B?WGVYRXZEdFBhRE5NUEZSMGg0RnR4d3FzWTFQVkN5TmNrb3NyaTg3NkpJYW82?=
 =?utf-8?B?T2luYS9LVEM1Y201VWJRazlRY2E3ZDQ0VGdKZXdYNjFLTHc2RE92alo2OG5U?=
 =?utf-8?B?Ui9zamlrTkhMWFFRbTJmYVFnRHRTQytZVFJBUlhtNjdaTlJGKytxNEJCRk9n?=
 =?utf-8?B?N3pkMDJNWDhlTVc0YmczdWlzdnJKUmFwWWx2UCtPcHB0VlFZeWJVR29LdDJ2?=
 =?utf-8?B?SG5BTGI0SEZwODFkeW1GM2dTVXFYNzJ1Z2JRa2FxQ1J5SzVmckRtMlMvWnYz?=
 =?utf-8?B?SWo3Zi8xVDJkVWdySU0zRmpVc25kTjFPVjhuRUlmbHBrak1XSTM0OXRoenBn?=
 =?utf-8?B?OW9VMVliNnFQUXREYUxycTdMWklxWXROVDlrMENWRlU5VFRwOW05b1hnMmlW?=
 =?utf-8?B?V2RuZFdIbEdaWjV6Zk9HS0s4TmR2ZmdoeHdMWmx3MVZuSnU5bEtyZWNhMHdi?=
 =?utf-8?B?RGE5R05rYitYWnJiNEhCQzRjMTlvTnNkOU5qWGszT2M0czE5M3B5czVLb0U4?=
 =?utf-8?B?bU9wWTNmMlF2MDhUMmkrY2w4MXl6R2MwaXlaWFo1UnFzT1djTEpsWG5nUTZz?=
 =?utf-8?B?YVJKK2IyU1VQeVpLM3hmYzRKaStRS3phVUduN2RvMFRkdUNJU1AxQndVcmRH?=
 =?utf-8?B?dUROZlIvVGh3QVUxckZlTDhEWG1ZaFlKZU54dmFaNVhOVFJSVVFWVDFJZW1y?=
 =?utf-8?B?NU1Tb245Qi9vaFprNm1zaDUxT0RsR3BlbEFNRTE5RmxtWnBZdHc5Y3NZTzdr?=
 =?utf-8?B?L0UwRi9qbFhOK0haZ0htMW1RT3RpQWd6YVA1YnoyVHh1SE0yMFpJTWxLVTBa?=
 =?utf-8?B?NnJHbmdLVm9ER2VGOWcxYmQxd0JZZHZsVVN5aytNcHZ0RCsyc2dZMjNmYkJ3?=
 =?utf-8?B?UWZiVUt3eWVjalZiY2k3RHY0ejl3RnViNmE5cTdGVXk1MFY4ZVVmaE4yVVph?=
 =?utf-8?B?SGlUb1N3ZnhRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2MyK0hxL1VNbEFnRUtzNWYrOW9wdEViN3FvdlpDYjJTWkRzRmVTOEpUbzRa?=
 =?utf-8?B?NU55ZjFYNXhTQ1lqOTAreG1QMHBDZkE3R0hQLzlKaFE3QW9VQktMbGZVaTBt?=
 =?utf-8?B?OEszYjlpd3FxN1Y3NGJZWkJXZjNhK2tvNHBZNkZMV2xIV0NMa2JnSGdPbFhP?=
 =?utf-8?B?VjByc2l1ZER1NDV3SjlGR2QrRW5ObjN5UW9ZcGFZM2FNckt2c2tOWHdTaG8r?=
 =?utf-8?B?cnFUWHZ5c2Y2NHVFWjVVLzVhM0hya0hhdVZjOXRiUXl3RUsrNVdnZUY3SUdR?=
 =?utf-8?B?VU1ZeXBubUIrcGZoQk5HdlVLWWVueVNUNEdwdnlOclJhZ0lUZ1Jqa3hQN3ZU?=
 =?utf-8?B?NFk3WmVLRzVMbXR4UzE5VjNIZzVtT0ExZ0hvWnFvSzl6bUJ4b0I3QlQyV3gv?=
 =?utf-8?B?U1FUSzZmZnovQnF2ZHRXaml0K1dpNm5Pb2F1RGkrS001K2wvQWVvMWpJZ2hl?=
 =?utf-8?B?bTdwOXdkc0phQ0k4TTNsQmZxNjlwOEhITmtORjlaeWFBd3AvdFB2UE1wRXE4?=
 =?utf-8?B?Y0FaN3dFcjAva3ZjTkttbFZSUlFUQUNkSDM1bVhpTDNzWWlMT1FDS1JzRmQ2?=
 =?utf-8?B?a2ZCVURhK3JmdFFYV0YxTVFvMEV0WldTb0ZLNCtqd2c5ZFFlVDZPd0F1U0Zq?=
 =?utf-8?B?VER5YkxJSEd1Vkd2NENQTS9hUWd1S0NGYjBVQjVTRFZVU2pwcHdrUktCYU52?=
 =?utf-8?B?Njd5MVhRbXF5bVY4TmhjeGhvalc2SFdnNk5pYnlmVEFNR00yZk5JT0N2WlZr?=
 =?utf-8?B?VmV5ejFhaStCOGtWTVExM2JXQ0p2bEtMVkx6dkhVMmh1VGlUcjAxNGJQM3Ix?=
 =?utf-8?B?ZUFYRFliMFJjK3NCTHp2bjVvSWpNaW5GWUdUUjdjRm9keTBDRFdWOTZLd2lS?=
 =?utf-8?B?cWcvS0p1NGk1Z05xcGhxczlRYUlaSmhjNW1HL3o2RXUyQ2E3cjdVbiswZXdt?=
 =?utf-8?B?aS9aVE9EcVlDWWdMTUxXWXMwOGZoOHRTNEY0NW4zQ0hqdEptc3hBTnk3Rm5l?=
 =?utf-8?B?ZlVSSTN0dC9oTmc0clJsdFpuQWk5Q0lXMjQ4RitVbVBHc0JyVEFrV1lhM21X?=
 =?utf-8?B?eElXS3NIWUNNeE1oRnpORlV6TEY0dGFGZFFPcVlTWVpva0N2Y0pHTXZkSmds?=
 =?utf-8?B?RE9lUlFJMEIxVDFBVnNweGlydG85TU41ZStINlFlYUNGek9JOUpsaDFrcmhi?=
 =?utf-8?B?TGQ0WVlXeVYyTE9nQ2JoSWFaampwam05K3h4UFc5MjV5b01QMWJlVUgwbDlH?=
 =?utf-8?B?T0h2WWd0WitxQzVONTZOUFpJeUFxY25PNmtxMHJsSDBwNjlZNnU4UlREZ21k?=
 =?utf-8?B?bHczNkk2Q0pqandRU2lmdEJoMFBIbVNvb3RqV0FHTTFqbngwYk9nckhzaUJx?=
 =?utf-8?B?dFdiWmM0SExNRHgxbVFvaTQ4M2t1SDk5QS8rWDBnRmNvWVBDM21lQVcyRmg0?=
 =?utf-8?B?TXJsVTdGaURlOG5tZDZJbzVLOFo1bHlHdXNWbnNUb2lSQ09GYk82Zk10d1Rl?=
 =?utf-8?B?MnRadnJPeGpLM1hCNmttMjl3ZnZhajM4WUNtUkRxMDlSZlloVmRNTS9VTWhq?=
 =?utf-8?B?NDhsdWN0Y002aGc4WmN0Tmg4Mkdic05Sd3BkUVV1bmFMTStaalJEcEZKSjY4?=
 =?utf-8?B?OXlJdUc4M1F2U1l5N0tUS0FrVFNaaVlINHh0eFh0TVlhd2U5R0JEKzVWYVRh?=
 =?utf-8?B?TTNMYkc4WXJoUkcraWZCNTJQSkgvQjBjaFN0VnNldlFzRXg4L2R6ZUVJWUlE?=
 =?utf-8?B?cGM1azNvR2d1ZXlpdWtvaUh1SDQ0b01PdU9DeEZYOUpmM3ZHVEJZVzdjQ082?=
 =?utf-8?B?VzFQWDZCamtTbkV5YnNKb2svdSswRkpqZytDcVlqb3lSSHA5akFFcWJ5b2lI?=
 =?utf-8?B?UzJFaDA3c3RuSWpzLzNEeFdhTDRxendNQlhWdXltTHRuNWxqTjVrTUdsRW5x?=
 =?utf-8?B?QzZxWmdEL2R3ZW9FcmkxTDNaYzJFbmpHa0U2RVZxVnVhamg1b0xJK0hkWnJl?=
 =?utf-8?B?Z0x4Vk1hUEpBeC9YK2M0RWt1bHhRaUI4OVk3K1dEeFZkN1cwU2h6MzRlbEtS?=
 =?utf-8?B?eENYTXlwWGhYd2NtZklFL1ZtRWUxMDdERWQrM3hCMWg0M053dnlBQVNkT3Vr?=
 =?utf-8?B?VXUvZTRKamh6NkRBWkRhdTk2TG1mK01TYXQ5OTZQSy85TndvMEV0cjBFTlJR?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BED04CC71A89D84C812097904D3CEE96@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a227c451-d038-4681-93f6-08ddc095ffab
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 16:14:22.8231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +GF3qkFgwqmcKvlixxbfAOQ0eusrVu50r5PhrT8WRnxcA0ft5Cp1S8V9caqlXBgNv0ufwf40GF//M2XlDP/C1dTti+rR+k8qNl4ZiO5PLMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6563
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDEzOjEyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBZ
YW4sIGlzIHRoYXQgeW91ciByZWNvbGxlY3Rpb24/IEkgZ3Vlc3MgdGhlIG90aGVyIHBvaW50cyB3
ZXJlIHRoYXQgYWx0aG91Z2gNCj4gPiBURFgNCj4gSSdtIG9rIGlmIEtWTV9CVUdfT04oKSBpcyBj
b25zaWRlcmVkIGxvdWQgZW5vdWdoIHRvIHdhcm4gYWJvdXQgdGhlIHJhcmUNCj4gcG90ZW50aWFs
IGNvcnJ1cHRpb24sIHRoZXJlYnkgbWFraW5nIFREWCBsZXNzIHNwZWNpYWwuDQo+IA0KPiA+IGRv
ZXNuJ3QgbmVlZCBpdCB0b2RheSwgZm9yIGxvbmcgdGVybSwgdXNlcnNwYWNlIEFCSSBhcm91bmQg
aW52YWxpZGF0aW9ucw0KPiA+IHNob3VsZA0KPiA+IHN1cHBvcnQgZmFpbHVyZS4gQnV0IHRoZSBh
Y3R1YWwgZ21lbS9rdm0gaW50ZXJmYWNlIGZvciB0aGlzIGNhbiBiZSBmaWd1cmVkDQo+ID4gb3V0
DQo+IENvdWxkIHdlIGVsYWJvcmF0ZSB3aGF0J3JlIGluY2x1ZGVkIGluIHVzZXJzcGFjZSBBQkkg
YXJvdW5kIGludmFsaWRhdGlvbnM/DQoNCkxldCdzIHNlZSB3aGF0IEFja2VybGV5IHNheXMuDQoN
Cj4gDQo+IEknbSBhIGJpdCBjb25mdXNlZCBhcyBJIHRoaW5rIHRoZSB1c2Vyc3BhY2UgQUJJIHRv
ZGF5IHN1cHBvcnRzIGZhaWx1cmUNCj4gYWxyZWFkeS4NCj4gDQo+IEN1cnJlbnRseSwgdGhlIHVu
bWFwIEFQSSBiZXR3ZWVuIGdtZW0gYW5kIEtWTSBkb2VzIG5vdCBzdXBwb3J0IGZhaWx1cmUuDQoN
CkdyZWF0LiBJJ20ganVzdCB0cnlpbmcgdG8gc3VtbWFyaXplIHRoZSBpbnRlcm5hbCBjb252ZXJz
YXRpb25zLiBJIHRoaW5rIHRoZQ0KcG9pbnQgd2FzIGZvciBhIGZ1dHVyZSBsb29raW5nIHVzZXIg
QUJJLCBzdXBwb3J0aW5nIGZhaWx1cmUgaXMgaW1wb3J0YW50LiBCdXQgd2UNCmRvbid0IG5lZWQg
dGhlIEtWTS9nbWVtIGludGVyZmFjZSBmaWd1cmVkIG91dCB5ZXQuDQoNCj4gDQo+IEluIHRoZSBm
dXR1cmUsIHdlIGhvcGUgZ21lbSBjYW4gY2hlY2sgaWYgS1ZNIGFsbG93cyBhIHBhZ2UgdG8gYmUg
dW5tYXBwZWQNCj4gYmVmb3JlDQo+IHRyaWdnZXJpbmcgdGhlIGFjdHVhbCB1bm1hcC4NCg0KDQo=

