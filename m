Return-Path: <kvm+bounces-51789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34AE7AFCF53
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F4E73AFFBD
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C732E1C52;
	Tue,  8 Jul 2025 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RFfVSAXa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487DD2E0B7A;
	Tue,  8 Jul 2025 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751988767; cv=fail; b=jnbAZpWBYVAPDTwVHJrBRlYWMdhoiNPFn7FxZ8bjK2LWvvXVTaXYO0zcT/8FYzGeBd60bQ+euBqCkseCbMbPC8tXABtLH//Cvdo2aMLA5jtH93ODmmSWS5MxFgIIyFIdD3SRbzQX1g8ljhW5q5RUgq4Eche7QxkTsR9aavLNIkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751988767; c=relaxed/simple;
	bh=hdryOPVSL1uFPirSNJSoUnS8DOzgcR89cvGSvknvRKQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UPPD+1shDBg9yD8kHCUqlaV6b2Dwkf+0Y/hirl+9mnpJKvEGtLO53FrvkjcTH86Pmq+kVs1/SiEstaO4LWVe/AsFhrtbol4boiPY7gFmWHtRR8iUCxM59UHn8qcjOmY0TwLmRlkzx2nKY0LtOJEmJFyhCZaxZlS4KJHjqLpPcnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RFfVSAXa; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751988766; x=1783524766;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hdryOPVSL1uFPirSNJSoUnS8DOzgcR89cvGSvknvRKQ=;
  b=RFfVSAXaqCt4i03hKuzZhTrgZrfAX0F3laOtD+KbSaIPmitY3Vbb14tn
   /b7tI0Z71TLNagRlKMaV84BOF1LMZczG32+yMdCELMRiButRgDzqIf3ST
   3/iVadDBB96JEkqH/Xj7BFHjgya9MQGermUxR9LhsrPAT5hb2fAdsgNok
   kCAwMfBk9QjTtt2+r/fbylHl9ihOZmfcKKwFw5HS5D4r+KosmpUKhK1be
   MGyy54QRLyw70Anu60jBVxgj5A6DWPWVs4qsMpPq2ZbIzAMiLKCW+ncBF
   Srh2tP+YwOBHcNR6zgW2mr2FNmOaXBcXoVn4OCtKjcEQIQEcuwXtaKFR4
   w==;
X-CSE-ConnectionGUID: S5dqwcKZRD+41mZ3m3h7BA==
X-CSE-MsgGUID: 7w4z1sLlR6C9OY8D6V/nUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="79664524"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="79664524"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 08:32:44 -0700
X-CSE-ConnectionGUID: Fq6OiMX2Rs6KEpob2MUX7g==
X-CSE-MsgGUID: W/sWj/BjSECdP7WNBluonQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="179206455"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 08:32:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 08:32:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 08:32:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.76) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 08:32:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tk3cqLApPm5dN30iyLc100YljugT5avflrN2o6JbHzgPopYTq0ElPghW5s7dK/JGhBsnt6OMb/1pTT1bVtzp9rw5tpULICswGkTg7dYzo6P2euZaFMttgWdsSP5gaTFhjHlMcTv6KA/bFgYA2xfkStrQpH/cAh1bpjIEJf369p160WiaKvQ/US9/i4SbUAU06mKONYzKvoqoNZTqJnbrBSBFClsezN7YgmUrQ+uzE9DCeRzoLRh88zD/B0BOJr+djrd25Y7D992vASIX7/l4CJnnbQR+P5MBwwOB1BenYdy4Do/rWFgtUmLXZd4cdHaMycxCp+GDmE5v+2whZosNaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdryOPVSL1uFPirSNJSoUnS8DOzgcR89cvGSvknvRKQ=;
 b=FQoPlwZZ5xlCovt2BB4Fp6QI7mVg8sOpUkQHLygs6DeRDRo81kASMs4+1SY3ZYJGlFRPCkn5fcd1CVSXg8bKqiKV0pRhGEHD71vFByiKTGlyhH6HzU5/VcAR0tRkqS6FT5BBsxaN7Qyp3jmHCVzz8bo2VsWVLjEzTGKOSp7A5UgeC9Xkw7mjt+tIqUVm3wHjKQX3hVyX/ei/VO5sRoJ0EL13tlZFDqX5Z6HwdS+/qH2tPqK1LjVJCG6GDRQJNtlM8wI9xJEeiFSiLsL+na6ni9C9E173qxKmfIWStEaYVjWAQGfismz7RbRryxnkDMv3rv9ysC9CbJT8rZcDFUJtwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Tue, 8 Jul
 2025 15:32:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 15:32:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Topic: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Index: AQHbtMXhHrhcZKCSdkuquayYYQc4lbQoYJcAgABV1QCAABpOgIAAAJ2A
Date: Tue, 8 Jul 2025 15:32:00 +0000
Message-ID: <c22f5684460f4e6a0adac3ff11f15b840b451d84.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030428.32687-1-yan.y.zhao@intel.com>
	 <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com>
	 <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
	 <CAGtprH8jTnuHtx1cMOT541r3igNA6=LbguXeJJOzzChYU_099Q@mail.gmail.com>
In-Reply-To: <CAGtprH8jTnuHtx1cMOT541r3igNA6=LbguXeJJOzzChYU_099Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6511:EE_
x-ms-office365-filtering-correlation-id: d96d4d4a-7abb-4124-20ba-08ddbe349562
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U3EyeUJyV253MGs1RjhTdHZadE9oL3BPY2ozZ2JQYUZvcDl1eVNxSUxyaDN5?=
 =?utf-8?B?dmo2SnBBL1JQWkxJVWRRaFpxcTBiMld1eFR3eXN3VVJYYTRqbklNeWVJL3NI?=
 =?utf-8?B?TkQwNEFSMGtIZ2JjRFM1T0VQcS9nWWFNZDdtdEZsQjFTL2VjUFFaZkJuMnIw?=
 =?utf-8?B?RFpUR0pIVzRJZWRVWTVFQlJFalZMS3ZKUEVnVGc3ZUlEc1dLRlRsaTlOL1Er?=
 =?utf-8?B?eFN6cDJxcUJaQzBUOG1WWE8zTTBPdHJhRktUZXVISGI1TWFnVDZxc3VPSThE?=
 =?utf-8?B?KzJXVGhtdlVuM0pPcjN2dXVIVVRTUzNGTGd4dTd4WnpEMTRibDd5NGk2NGxM?=
 =?utf-8?B?Rk9COXRxYUczUkVhR0NxVFRVak9KdGZGREk0T3VhNi9RTk1ONlpMQWFvMWVz?=
 =?utf-8?B?eFZyK2dXUmlqQkxJQUs0MEJUWWtSYnZPWjI2QzR0czdLOVduRWFJNVNoeGxi?=
 =?utf-8?B?Z2UvZit1d0R3N0M4M0pyTmFNQ25wK2R0WStkSkt3MUZyYzB3Z2VqakpWd1pL?=
 =?utf-8?B?V3g5TENodTM5TGtidHhib3BFQXo0OUtsa3VTYk14Q0twWXljOC9wWTJaUFYr?=
 =?utf-8?B?cngwZFNab0VjakF4b1I4enR6b3gxQXpITklXSmlwd09ZeWF2WjJHTWFKZStM?=
 =?utf-8?B?TG9LNjgwS3NHQldrRXdxY0szeWtUam9zaEhWd3Q3RGdLUHd3U2dFVFJJOUY1?=
 =?utf-8?B?UUdCQ3lDMVRWSmY5Z0p1b1JvcndXaUtSYW4vSXFLeDJuMW5OOE94bTNPY1hl?=
 =?utf-8?B?T0o1eGdWY1lMRzIvS0g1andmMExXcEVWVzVUUXpHTnl3Qkk0UkVaSlV6UWYw?=
 =?utf-8?B?bURDcm05NytubkdhMy9lVzZlTGtWYmZEWHRLblZxR1dsTUt1TkRhM2YwNy9T?=
 =?utf-8?B?ZWVsaWw2TS9MM1VHNWxpd3hsdmNsS3BTaXNnc3ZQSzh2RnBScG1MV1hZMG45?=
 =?utf-8?B?N0FGWUV1WDYzaFQ1SU45T3FSWGU3c3lGcUp0UzlIU1dDWXBFaDB3WjlqTGh6?=
 =?utf-8?B?T0FJbHVOZUVkZk1mYi81YkhIYnFLbEIwVVFDWGhaazZyUmJqemVVeW55aUtQ?=
 =?utf-8?B?aWlDQ2ZNWllneTcwcWJlY3dQWXgyQXNzRUF1d2FBSXlCalFRTTErRUhhcUlS?=
 =?utf-8?B?SHIrcHNUemU5WEtnd3ZsRVg4UUJiejcxRm5CU3cwSUtqK09lR3I4czBWd0hq?=
 =?utf-8?B?aDRadGVHOU9aRUlCWnJ2S1NwUTNMdFVlZCtza0YwTTVJbXVySnZ0bEhJcVFO?=
 =?utf-8?B?YXk0emNMcng3Z2VvL3k0c211ZXlzRTlJdk9DZWE5djlOM2RWWXZmWGIzdmtj?=
 =?utf-8?B?VmJLVkFQNnFoYzNJemg0SDBTNEMwMldQNks1SVdLd3AyWTN5My9KbjFWT1hS?=
 =?utf-8?B?TllZU0h6MnFTRC9pUENQN0xXTktodk95UCt5aXlXc1Q3R3pDWllEejI5T1ln?=
 =?utf-8?B?c1FXVjRvQUM2VUJjb29jSEJyaTdFQkFodXk2MnJiVzNyR1Q5am1RL0VqTEN5?=
 =?utf-8?B?Q0ovZlpiYjFvd1JScHZ6VTkxbVNDdnphUFUySDhzZno2ZHFBS1VEdmQxemdu?=
 =?utf-8?B?Q0ZtbWg1RGhpWHM3Zzd4QnZyaHpEVkp3RW1VRlB6R0xNZ0pyNDd3K084UkNI?=
 =?utf-8?B?ZytwVUJRWkdieE5BOFBiZC9VK0lIV2VBc3Yxb0U4YTErK1BwQTdpZVlGM1pC?=
 =?utf-8?B?UG1WbHZtcDdUdnNrUUo4ckNLSzBkcnZzMUI0MTY4WXdIV1N3dWlKUVppWmF6?=
 =?utf-8?B?WWJGZlZWd3RXMVUxQkFVdERDMmtzQmluVEs1L2l4b0NaRWdFZTJ0eDV3OVk1?=
 =?utf-8?B?WmlFQUZzaFBMVnJDWUdwVEI4a21LRElvQVhkMm0rdnBmTnB5SFVoeWwyTXFS?=
 =?utf-8?B?L3NRZHNucTkyeThOdDNZMWo3RjFDa2tQa29OMzJrY2Y4SWFIdC8rcTJOVjIy?=
 =?utf-8?B?cUxHK1VJOFZHMlZuMGxETnZTMUZIMFpoVDJPdVU1UnZ6ellnMVhHQzJzKzFF?=
 =?utf-8?B?V1hTVU5UNVR3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aElxdjdqdTZCdG1UUGVvb3JiT3Q0a1AvWEVyZmxjMXUyZUdQdXJDZ1N0U2dG?=
 =?utf-8?B?RksvNXpZaE5TeFdsa3crSk5nZlpuY1ZuUWRaKzhPMGxaeDN3R3k4UjZ2QVBH?=
 =?utf-8?B?dTBROFREVXVITXoyT3FCeGJXZjJ3aDQxSlFFN0RpemlUM3g4eGNzbVRZMVor?=
 =?utf-8?B?WE4vUStVVjZyUS9tazhjZ3hFMGFBOGQzczJWUlllQzlPKzl2cFA5eHZIem9u?=
 =?utf-8?B?OUhxQWRvWW8wclpWLzFraG1mNW9yb3JjM1U3UVB2ZWIvMnNSWU91QmhYc250?=
 =?utf-8?B?UlR6K21xSDlFdERVZm1oVmJ2bFpwcmU2SDlLVHlQTXRkbTQwOURPTGZtaXU1?=
 =?utf-8?B?OHNRVzVmeGxpT1ZtSzQwbktBbFo0R3dZNHVFam5LV0NRRGxsVUZUcU1GVHV3?=
 =?utf-8?B?UTJwNTFYWlVBK2Vnc0ZqakQyOFdUdWFxS25GdnAraXdSTUY4WHdLSk1sK2Y4?=
 =?utf-8?B?U0ppUFZJVDRsNldiUE1rbFdCMFJxd01KVGJsQ1ZEalR3b0FpRG04Q2dpLytS?=
 =?utf-8?B?Z0RaWkcvbytpREVoaUx4WWhWOTZDa0xpMlY1bTRHQ25IU0I5dkVJV1liWkNi?=
 =?utf-8?B?OUJVVWZXZUVzZGRZQXNCQTZmYzhQcEVZbHp4ZDZBdVJ0ZmxTekx1WWRsNitj?=
 =?utf-8?B?TkhwaSt2TnBCb1ZlTFlyby8ydGFQbEY2TURVMFVyWVV1RytaaTN4cEVTaE1M?=
 =?utf-8?B?Ry9VUkdubmFVY1p1ZzZxUGN6N3Zsb3JyLzJwQXFSK3QycEdOVEZHbmZKbGJU?=
 =?utf-8?B?TkNWaXg0QThMaW9NSkpkYkNHNDkxcTBjUWpJUXd1K21QT0RMNkdnaWs5aW1C?=
 =?utf-8?B?Ky8yMG1iYlBSSmtRbUN5NzZvWVFSTnBPZ2VqZUZsczdyemtPRkU0RjVVZmVm?=
 =?utf-8?B?VVVnNFFzdFozL1FoN08vYlBmK3hzeXNzL1JYY05tRFRTQ3I1ZXc0VzJFcFFp?=
 =?utf-8?B?TGVncGovR2lBd0MybTBkakpxQ2Y5QzBlczBqNmxBUGtTTzNIU2pSdHNKYUFO?=
 =?utf-8?B?MDlQdktHNkwzNWhOVDh2Tndta3pYUnlnWTZzeGxvZXNUbWtzMU1CR29ka2lq?=
 =?utf-8?B?bEU1N3pMY0ZVNWNwUW1ieklOWUE4Q1plbVltVUdsZDVVL05LOHp1dVRRWGFJ?=
 =?utf-8?B?SDVEQ2ppbEMvTTIzNHZnRkJLSWgzNWI0WWlCNXBGSnliczB1MmJHZkFmamdC?=
 =?utf-8?B?YXVaU0hIVFUyc2JLTElqU3EzKzJ2dUs4c0FnNkQ1YUVPRGc0UHoyVU9Rcjla?=
 =?utf-8?B?UlJNYzBWYWJnZ21NNWQ3T29ET0ZyajRYRHFBRmpvL3FaZDN0V2ZFNWIvS2w0?=
 =?utf-8?B?OVdMQzl0V0U0VmpjWWdCQ1ZUdWF5V2JSQTVhWjBTZi9YSndIWm8rdFVIZW5B?=
 =?utf-8?B?NjRPWXNjZUlCcUJtNmtCWmd3ZThFcmYxNjdSdEFyRGMwVHJYMm5FOFdWWkxD?=
 =?utf-8?B?VS9rR0xvQmZ3OWdHZSt6anZCT01lbXEzSTFidy9vRHVCbGd3T2gwOXdOSlVN?=
 =?utf-8?B?RWswV2pLSnNDZVBWT1dKZnZiaSs4bnZsSmJXY2pFM2d1MHpWM000QXlmeTI3?=
 =?utf-8?B?Z3Zuc25RSHpaamlRNmcxdHdGUGtOTGtSeEY4OUR1eEtuYklWMENxZWpHMTJT?=
 =?utf-8?B?U0RVbTVkYnB0ZW9NdTY1eDVqeWduSnBjaFdpZXF3NXV1UVNaZHlTbnVDODZZ?=
 =?utf-8?B?N1RkNzMzSE9GdzZaTmFhUFhGbXJHQjJLcHpPeUg1Rk1OTEY1eUQ1Q1I2Zjlz?=
 =?utf-8?B?WmFqdHBBZzB1SWpOQ1gvdlBaaTNqaFRIME92TmlINURXbmpuU2dDcndvaEVo?=
 =?utf-8?B?Rk02RDRrQmdIZ1cyelVyeFUyU0VGUVRKT05LNGdQWmJEcExaMmV3YUlxM2NY?=
 =?utf-8?B?K2pjMDdDRk5KR0ExTHYzdGdBSnNTeFlNTEpIWndrV2lYaTdNSHBEUFlPeWFM?=
 =?utf-8?B?ZHRUZXJudWp0SmlLMzBSZnMrT1V0R1BsbVRPS3V0SjFZaFE0c1hnT3pkWmNv?=
 =?utf-8?B?R2Nndkh2RWZSYmZpV2F3b0hvSTk4c0g5UXFvUmxheUJWQTlIYzRCd3NBRUdv?=
 =?utf-8?B?bVdaeXg4WWlZSHB0YUE4RlJyOWpvYjNaQjQxVFppZTlOQ3hWaUNKWGMrdWRB?=
 =?utf-8?B?QXFMbndPVm1JeThldnlLNzg1aFdEUkRRRHZnMXIwNEIzSnk4ci85TEIzd21P?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A102AA42D3ED3F47A651CDEB934D9B65@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d96d4d4a-7abb-4124-20ba-08ddbe349562
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 15:32:00.9992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PQfbqiHtP7AlP45ERM8sYLE4ORVM44J/olWg4w73Zcb6bnVoocZW0PjWKLb3hBEU1AkE68/cq1tZaG2la8lTXBgMTvmEQqNEL6LXVAJKprk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDA4OjI5IC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+IFRoZSBvcmlnaW5hbCBzZWFtY2FsbCB3cmFwcGVyIHBhdGNoZXMgdXNlZCAidTY0IGhw
YSIsIGV0YyBldmVyeXdoZXJlLiBUaGUNCj4gPiBmZWVkYmFjayB3YXMgdGhhdCBpdCB3YXMgdG9v
IGVycm9yIHByb25lIHRvIG5vdCBoYXZlIHR5cGVzLiBXZSBsb29rZWQgYXQNCj4gPiB1c2luZw0K
PiA+IGt2bSB0eXBlcyAoaHBhX3QsIGV0YyksIGJ1dCB0aGUgdHlwZSBjaGVja2luZyB3YXMgc3Rp
bGwganVzdCBzdXJmYWNlIGxldmVsDQo+ID4gWzBdLg0KPiA+IA0KPiA+IFNvIHRoZSBnb2FsIGlz
IHRvIHJlZHVjZSBlcnJvcnMgYW5kIGltcHJvdmUgY29kZSByZWFkYWJpbGl0eS4gV2UgY2FuDQo+
ID4gY29uc2lkZXINCj4gPiBicmVha2luZyBzeW1tZXRyeSBpZiBpdCBpcyBiZXR0ZXIgdGhhdCB3
YXkuIEluIHRoaXMgY2FzZSB0aG91Z2gsIHdoeSBub3QgdXNlDQo+ID4gc3RydWN0IGZvbGlvPw0K
PiANCj4gTXkgdm90ZSB3b3VsZCBiZSB0byBwcmVmZXIgdXNpbmcgImhwYSIgYW5kIG5vdCByZWx5
IG9uIGZvbGlvL3BhZ2UNCj4gc3RydWN0cyBmb3IgZ3Vlc3RfbWVtZmQgYWxsb2NhdGVkIG1lbW9y
eSB3aGVyZXZlciBwb3NzaWJsZS4NCg0KSXMgdGhpcyBiZWNhdXNlIHlvdSB3YW50IHRvIGVuYWJs
ZSBzdHJ1Y3QgcGFnZS1sZXNzIGdtZW1mZCBpbiB0aGUgZnV0dXJlPyBPcg0Kb3RoZXIgcmVhc29u
Pw0K

