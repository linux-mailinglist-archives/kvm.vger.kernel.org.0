Return-Path: <kvm+bounces-30765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3389BD47D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD6931C2224D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB8F1E7C28;
	Tue,  5 Nov 2024 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="drGzZw5a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C719213D52E;
	Tue,  5 Nov 2024 18:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831126; cv=fail; b=DUp1c/Cb3/G5MF5B4BQUGBfYxgr9taHwe19k0890F9V2mCgzMEvyCBLIYkJwH4hoMw0M1pNI9D4rwMXChkZJF8C2zfd9ghAX2SzCs9ORAIz3qu9kieq6OUXsOJTrbqeluCsASvr95qkge2d3LrNqrVGn79UX6r+4/J2Qd4uFD3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831126; c=relaxed/simple;
	bh=0SJdL4oeEJh4ZG4mZKjGW29jURuZVYEj5rx/tb90PVw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K0O9MUnWXvbtBuqwS2p0fjrRwkCfq8jOpCtdzFeeXERNqmUQkOZPQaRgKJi6y/wLq8Oik7uxWgn+2VkLSksGIXrVChs0FYdu7iw867ucue9JEOch0yh4mPmr+aGkiw/L8MGnXcQ3lHXa/M82fk225DtURuQaQQ5VNmFNClpPBtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=drGzZw5a; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831125; x=1762367125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0SJdL4oeEJh4ZG4mZKjGW29jURuZVYEj5rx/tb90PVw=;
  b=drGzZw5aUHXlIdbICOokEafXYSQePYE8sPfXK9y357kKfRZp1f0xh6u/
   GFhT2EDf6nZrAvQuBadBBtCbv/ZRGnuxLTj9Q1eTAI7/CInLJMuDXs+z1
   GLYD9qq5wwwf457f+5kyjMh+l6g5OqwwVzwmCuGXp+2r4BfRulGUyujug
   poorv1PSalTaZ9clpFaCNJYouR44V0vqkxaahTy028iQWoB1P8ndZFV4X
   2pJZJsm85LGtJRJjejgBBRelGqZHD0DkQwWBSXf19sQyTDNEP1DCLb3rR
   Izf57z1uaTHvBL/mg+RNlliTA1+KI2fJoqrHoZqNFrHT0mArtdubsSN4G
   g==;
X-CSE-ConnectionGUID: Zc2g4ZDBSua7R/4dR/K1PA==
X-CSE-MsgGUID: jtM2i/G4TUyJ97KRqa44Pg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48058942"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48058942"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:25:24 -0800
X-CSE-ConnectionGUID: tPzh3RtWSJieQXQ5WAMX+w==
X-CSE-MsgGUID: 2L6XaMzZSbinWrgeXHC4Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84025454"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 10:25:23 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 10:25:22 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 10:25:22 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 10:25:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V1fKd6W9CaS1pecOqQ+P18Nn+5b6gKhxCdTghH0yci17qpu612PwC7a0eAbvCOmb3uaZ2NkzFvJ5GCPiLTc7lyvbbS/l5Vj/14/gpWbHbYbX2VTXlU08IK/doc80O9xii+IQhMAlaee8MhDLs6ubpFXBWkDsLqgPZH0aeYKzleE8HFH1SkvA+vVretXeIy4fLikBlnfptKCFLrSBP10w75itHxCoae8Jk7Ciu2IrNNVMwDyoO86oJC7HnNPAzWLjuaBaHAMrhQvOaM6gftnzStIhb+91GFBGuQX/hYtSMDoNDbezckfkQDvxLhG5gkmx4pZt8pFA7pMj55NyrDfe+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SJdL4oeEJh4ZG4mZKjGW29jURuZVYEj5rx/tb90PVw=;
 b=jwWxwP+APsGDPiUnzuHTJieH9T2OwqKFEnJCU9ohZDGDlHSNfK49pBwSbC+Ick9gfxYhdMqKWgkDwSd3TGVBZJBIbhrFozPFl1f7NMT9epTDDpmgYeIIpCLiI2JzvveYBBQMQ+yhqEtD8EdC8GM2zOmJV0P3pP6MAVZr1E1biv+5zpSgnNoXmCu+3oMz/6DV3fpJjFtLctPsnvmZCNxNuZEZiiGmVAFvk2PwL8gLr8tmkxqKUKTN9GIAdNk/zliOuRdCKq5YxyVzNWAlvP+UYcMS7hD/PFbKW+nczOkLUJRTAH0PjRIPbUNwoVRoaCIZnWk5EkPWZyYZRbDLNKqwIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Tue, 5 Nov
 2024 18:25:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 18:25:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
Thread-Topic: [PATCH v10 00/27] Enable CET Virtualization
Thread-Index: AQHaYwfwUq77Vfr47kSTqCeNyaqv3bGDeEgAgAbx4wCBIC/lgA==
Date: Tue, 5 Nov 2024 18:25:18 +0000
Message-ID: <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <ZjLP8jLWGOWnNnau@google.com>
	 <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
In-Reply-To: <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4886:EE_
x-ms-office365-filtering-correlation-id: 1e83e2e1-1e0d-4848-e69f-08dcfdc733a5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bDRBWVFtRG5wNkh4Z0dWczRadmhDL3VUaVg1bHJESSt2MVZ6SGRDNGUreFZS?=
 =?utf-8?B?NElMVG9jaTA5SHhFUVJjczlYVFdaazEvZ2RVNG5Na2lHRWxCZDZCL1FaVFpU?=
 =?utf-8?B?VTczNDJEMmlyS3NSY1QyU0QvcVBlaDNBT2ZEdzJEcTBBNmVnc2phaGxGZEZQ?=
 =?utf-8?B?U0c5MkM4Q05nU0FnMHd1R3ppU1MrTmhOU2luNFB2SzFyVlF2bms5cWdrcHNw?=
 =?utf-8?B?M1NsaTJPc3VFazZqYnl0UDMrb0FjRlpibnFMYmVoMkVwOThmZ1lGU25qcUZh?=
 =?utf-8?B?KzZNQTVpZ1RpNVg1MVdDMDBlYkgyWHFFSVpScnJlNUN1Z3NodDE5NE5JUm42?=
 =?utf-8?B?QytsUkdBaVFPVkcvOEd4MWJ1WXFFQ1JmZGx5RW4wZlJraUJrNkg4Zjc0Ulha?=
 =?utf-8?B?NlRrSEgyYms2M3AydWV6b1AxcG4wK3pIUTl5MU5mYVpDck5DK2VyQXZKWGsv?=
 =?utf-8?B?SmVCSHAzNzRKTDFwYXM0WTlKaEFrYlNVS3VJeWI0Mk9CRE9ndVJtM3VneDhO?=
 =?utf-8?B?NjRic3NpdzU0bVd0NFUxWEhwUVJERTZkZVNhMjltK1R3SlRGczVLTzU1MVB4?=
 =?utf-8?B?U3RiOWpFblZRY1BTS0Ztcm5FdVRqdS9TZS81blQ4TC9YUEQwUVdabVNtSGtU?=
 =?utf-8?B?UmdJVGpoZ3VMQXdlK2lSZ2FUM051WDZZcm1QNndnUWl3WHJXeFNqV1BaVzhM?=
 =?utf-8?B?SXhuQ0ZYWFJ4clpUTWEyQzBqaGNidEhkL3Zid0JZNXdLTHc3R1cybDNWRlFV?=
 =?utf-8?B?c0lxOWVUWlhpTFpMT21nRlJBYUQzY2NZWnc2QXExTE15d0xYSnNselYyTUpI?=
 =?utf-8?B?b2htMHptbDg3V3R2TXhzcncyY1ptdDR4cTZIZlh2TUcrWjJtVktLVjhlZXcy?=
 =?utf-8?B?TXZFMzZpeUpVaUpMQmEybUU1NjFsSm0xVWs2UE5xbnlsalNabFRlcjFFbnFq?=
 =?utf-8?B?Mzh5SFFEb2FQWTZqQ0tlK0ZUZVRId2h1K0tydWRrSXBGY1BTTm9ZQzh2cjJy?=
 =?utf-8?B?OHQxa0J2MzJhanN0c21QOURobC9ZNXZjdkNTckRuRGwvTEZ2WHIvS3lSV2hQ?=
 =?utf-8?B?cU1DVVhWV2htSlV0dFY4WFpRb3hESmdSU2Q5RVhscjQvUTQzTHlkdXRRQzNN?=
 =?utf-8?B?anB2ZEdTeFlldFRHaDNVeVpoVTVpQWFINHp1QTBsLzRUZTc4NFlhOEduNG05?=
 =?utf-8?B?T2pYdzZBQUtxcDBEVmR5M1RaZUlBU2JmVGt6UUNqMXJHckhndGd5TDcwa1Jm?=
 =?utf-8?B?dUhxV1RQYjRJdkdaT3JNTEJlRTRMa013TWQzMGZMN29UM0w3YVEzWkplMkJP?=
 =?utf-8?B?NXd1RTd0bmN3Mk4vbzdqZ1VFdmJKc0ZGWDE4TkFWVS9JWXUwTUxxY0hmaEht?=
 =?utf-8?B?VzdKbEpnd2JUTHhTU0hqVmk3eHNaVGNLZzEwd0U0M3RUN2NyRnpsd3JyZkZu?=
 =?utf-8?B?dEQ2ZXY0Ni8rWUFxc3dRZi9rWkJwRnVjMTNvbHF1MTNIT1ZuMjk4L3VEN1VL?=
 =?utf-8?B?L2xKeUlWRE45Ukh2cTIrV000dm9yaWUvZDZaY2Y5eDd0ZmpBYzBjYVVlYVRx?=
 =?utf-8?B?VEJWcmpOakw4cVdUS1l2YS9ua0NaeDRleUo0dk4vR1BqQ0pWaXY0UTdIb3B0?=
 =?utf-8?B?ZmpEanJQdCs3TXNHYTVZT3JFcHRMb2FYc0M2TmtYUjJsQWEvK290QTkxZkVt?=
 =?utf-8?B?YjgyVElDcndoakdhVnhZZ0hjV2RMWUVFaVdLVHBtNmV6NEM5VFJvZEhaa1I2?=
 =?utf-8?B?SEtLQlRLT090RUZTeUdIYXd1NHZxZmMvMGZoS21iRjJvV2REcFZ5dFFOd2tM?=
 =?utf-8?B?dHFpOTArTkxjSGNxbUx0a21xOU5KcG4zR0IxRzB5S2hMaEFTWEg1eWRXbEdl?=
 =?utf-8?Q?3sgx5FROJszot?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWJycG5vbEpTaEgxSWIwK0ZSenVvQWhobnFpSlRtWUxnTVZXNExNYlBTSjEr?=
 =?utf-8?B?T3lUTWo2WFNOemdJQ1NyeENLQXd1WExTN05xNk1qazg2TlkxT3UzRGxwa3F4?=
 =?utf-8?B?VGZnOGxIRVpzNGg1T1gwU2NrS1dPK0kwalNIMks3UEs4ZkZSWUlNM0Q0MjN0?=
 =?utf-8?B?bzZCUitUUXlsbE8rZWJYNENUN280OVJXaldnMkFhT0U2cFRtK2RhS0hmTG04?=
 =?utf-8?B?UVdxckdZb3lsVzYrV2ZFK0VzR0d0STJudHlSQ005OE1QanROeE1qVXowTFda?=
 =?utf-8?B?VTJURElHdWRuNHRYeG0rWVhabmowWHhxQ0NzUUdUZFk0Vk1qUWFITW9uY3Ny?=
 =?utf-8?B?YjN4djVXbitxSVhscVFsTWFjYjloMGpCbGNoU0tjUnh0b2NhTmNSaWNWR2k5?=
 =?utf-8?B?TXduVm9MOUtVWFE2VGRkWjhwTkVrVzJpdG9jaUx1UTJOYzlRUnU1VUNESHE3?=
 =?utf-8?B?Ly83SVRpVG5SK2M5OERoQW94T1JRZ2xpYXhjcnZ5VzV1UnBucERabTNYVDFY?=
 =?utf-8?B?MFVOUG1EL1V4UEFoTTlWTmphN29BTkhvb2U3WG9RNG44ZkJmVWtBTVBzbGJ0?=
 =?utf-8?B?NEI1bnFhRS9WOVVWQ0lZemY5RWhWZWdsUkQreVNuYTFGelRvOU8reTBQMGh6?=
 =?utf-8?B?dDVMTkpndDA3Z3A1MjNLaDEvR1VXNnVhVE4vT2d0U0lqUXJKSTFMN0pLSVky?=
 =?utf-8?B?ajJEaDRXMUFzcGNWend4amVLWmJZMHBlYmxKR1R5Q0FJTW1jZndobEFhRG4v?=
 =?utf-8?B?aXAvUWRZT296bDIzTTBORkdkM0lBbndmV2h2VzFWRG1iaG54dGxxSW1uRFZa?=
 =?utf-8?B?dG02enZ0TklvY2xVK0xmUXdveWNIQXdBVnlvQlNaY29Rb0orajQ0dGlqOC9w?=
 =?utf-8?B?cGlPTit4aXZQY3lqSU1wOUVydXBJYTk4NGduWkhpRkhqb1FCalpCWFhVaUVs?=
 =?utf-8?B?SnlkZi9yUHJXbHJaZi9XYnNRZWFqZ3hpRUs5bVpheXFpWExrNXkwc3doT3pt?=
 =?utf-8?B?dGRyV0RqRmlpMFNjWm9jQ2hYTERBTVh0UWswc0pBekhIL0l4YnJySGN4WUVa?=
 =?utf-8?B?VUxXbHhKaTg3andhQnRScU1ZZ0dlNkVnaVFmOGFmZ1Y5ZEtGWDkxQ0VGOUU1?=
 =?utf-8?B?L1FBMFZ4cWN5ZzR4QjJoYks5aUZzSE1JQzdod2NRVFdJbjl0bUxRMm1IREx1?=
 =?utf-8?B?R1F3UndpL3AyNk9ldUdtS1g1UEgwUTQxSEpCenJrODdiWTFWM3Q4dytPTVQ1?=
 =?utf-8?B?bURtYWUxMUN0Z3ZmallUTmdUUEdQc0gySmxGV0x1NmZaK0lEeXVseDJEOWhN?=
 =?utf-8?B?dDBSci9BZm1sOWd6ekhYY2dHTDlzQWIxa2FaMWVEM0YrcHEvYmRDZU9PUzN5?=
 =?utf-8?B?b3pXMnVhZjdzaFRWSVFnNVRKdFdOTk5za3RMWStzeTk1MzNnaE5rRDdRaDNw?=
 =?utf-8?B?cjdXbTVRSWNlOGl1ZWl0MGx6dDhXcWh0RnJhZElkc0xKVWMyTjhzR00zdXZw?=
 =?utf-8?B?N0U4cWFIQlhsNEpzbVppbnhEUUIvL0c4cXBrYkVtUENjNXg4ZjF4MmQ5OWR3?=
 =?utf-8?B?N1NUVlZBd1hGaVNJelJOZVl4WGJQOGxWZnFRc0pMZktiaVF5ZWhHWGFSQkNa?=
 =?utf-8?B?a3UwY0ljWmRIZThKWU9WdkU1NUkrUVA5N0RsRVVjRXFKMThiWlJWeW5KSEpa?=
 =?utf-8?B?OFdLTXoxeW1IYm1jb0ltK2NMWk9udjBNeWRadU92ZW5FNGdCQ2JyTDZQQ09U?=
 =?utf-8?B?di9YR1liTTJIczJiZjQyOTBuTFBDMC9hTThlZERJZFBiNUhYRkpYMk5uV3NH?=
 =?utf-8?B?MWQ2RkgxLzRqN0VoUVRvMUhGOEh1RkVjZ2lURVJPNHFBS3BmTjJjRTRWZmda?=
 =?utf-8?B?QXV1SHpzYmQxWVRMUG5NdHYxZyt4SzFKSHozK2YwckdJTEJNUWJ0WXlCRUdp?=
 =?utf-8?B?Y1ZhNTcvcjRoakMvR3VMUjNKUk5PYnpab2loZ1Z3am9kYkdaL1RXM2dqb2ZK?=
 =?utf-8?B?RVdIWDhYUFpZN1lnREV4ZUNLV243VFBkY2d4UGZSRjFXcThtUDRkNUY0U1Z4?=
 =?utf-8?B?Z2hVTXVyWWlOMkVBc1QwYmtxMDZWYlAzV3ZieW5MZnVWczhTNTZyalFDWDJG?=
 =?utf-8?B?M3BWbzlJem5pRllBU3RaZVVyU0ZTR3h4U0I2VGlvdGg5MEtOalV0OS9wYkpi?=
 =?utf-8?B?dkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67E8BEDBAC107244970D52ED42003C1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e83e2e1-1e0d-4848-e69f-08dcfdc733a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2024 18:25:18.5978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W5myd8sk4bL3WBljmzeJEQDmeYSxqWsUDi/KzeQuiT46uHHF+vnkGUu4uATGBarx7y+e5JokF/Wwajp+jxUnNVVMUKLaqqcqXMmQoHLAxRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4886
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA1LTA2IGF0IDE3OjMxICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gPiBBIGRlY2VudCBudW1iZXIgb2YgY29tbWVudHMsIGJ1dCBhbG1vc3QgYWxsIG9mIHRoZW0g
YXJlIHF1aXRlIG1pbm9yLsKgIFRoZQ0KPiA+IGJpZw0KPiA+IG9wZW4gaXMgaG93IHRvIGhhbmRs
ZSBzYXZlL3Jlc3RvcmUgb2YgU1NQIGZyb20gdXNlcnNwYWNlLg0KPiA+IA0KPiA+IEluc3RlYWQg
b2Ygc3Bpbm5pbmcgYSBmdWxsIHYxMCwgbWF5YmUgc2VuZCBhbiBSRkMgZm9yIEtWTV97RyxTfUVU
X09ORV9SRUcNCj4gPiBpZGVhPw0KPiANCj4gT0ssIEknbGwgc2VuZCBhbiBSRkMgcGF0Y2ggYWZ0
ZXIgcmVsZXZhbnQgZGlzY3Vzc2lvbiBpcyBzZXR0bGVkLg0KPiANCj4gPiBUaGF0IHdpbGwgbWFr
ZSBpdCBlYXNpZXIgdG8gcmV2aWV3LCBhbmQgaWYgeW91IGRlbGF5IHYxMSBhIGJpdCwgSSBzaG91
bGQgYmUNCj4gPiBhYmxlDQo+ID4gdG8gZ2V0IHZhcmlvdXMgc2VyaWVzIGFwcGxpZWQgdGhhdCBo
YXZlIG1pbm9yIGNvbmZsaWN0cy9kZXBlbmRlbmNpZXMsIGUuZy4NCj4gPiB0aGUNCj4gPiBNU1Ig
YWNjZXNzIGFuZCB0aGUga3ZtX2hvc3Qgc2VyaWVzLg0KPiBJIGNhbiB3YWl0IHVudGlsIHRoZSBz
ZXJpZXMgbGFuZGVkIGluIHg4Ni1rdm0gdHJlZS4NCj4gQXBwcmVjaWF0ZWQgZm9yIHlvdXIgcmV2
aWV3IGFuZCBjb21tZW50cyENCg0KSXQgbG9va3MgbGlrZSB0aGlzIHNlcmllcyBpcyB2ZXJ5IGNs
b3NlLiBTaW5jZSB0aGlzIHYxMCwgdGhlcmUgd2FzIHNvbWUNCmRpc2N1c3Npb24gb24gdGhlIEZQ
VSBwYXJ0IHRoYXQgc2VlbWVkIHNldHRsZWQ6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21s
LzFjMmZkMDZlLTJlOTctNDcyNC04MGFiLTg2OTVhYTQzMzRlN0BpbnRlbC5jb20vDQoNClRoZW4g
dGhlcmUgd2FzIGFsc28gc29tZSBkaXNjdXNzaW9uIG9uIHRoZSBzeW50aGV0aWMgTVNSIHNvbHV0
aW9uLCB3aGljaCBzZWVtZWQNCnByZXNjcmlwdGl2ZSBlbm91Z2g6DQpodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9rdm0vMjAyNDA1MDkwNzU0MjMuMTU2ODU4LTEtd2VpamlhbmcueWFuZ0BpbnRlbC5j
b20vDQoNCldlaWppYW5nLCBoYWQgeW91IHN0YXJ0ZWQgYSB2MiBvbiB0aGUgc3ludGhldGljIE1T
UiBzZXJpZXM/IFdoZXJlIGRpZCB5b3UgZ2V0IHRvDQpvbiBpbmNvcnBvcmF0aW5nIHRoZSBvdGhl
ciBzbWFsbCB2MTAgZmVlZGJhY2s/DQo=

