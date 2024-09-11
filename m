Return-Path: <kvm+bounces-26494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE51C975003
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 12:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F9561F239C8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCD3185B7B;
	Wed, 11 Sep 2024 10:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Huou/F35"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC239FE5;
	Wed, 11 Sep 2024 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726051566; cv=fail; b=jhbTs5o9qGaDQSGqtwXVfHvx7ZCbo5IdQdVNf8B1dx8/3GPOLD69rKSV6wm0xAfmGwwjJNyf6jXelt3T84ukJi4STgMirQ8sKA2DLalbGxYixJp7oGInn7TqACEjGp1yossbIgq08QcWYrQ9fIvBcfqMYa8LbdAKtcslB1rBBXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726051566; c=relaxed/simple;
	bh=tz/9bpEpvXTAg2mfR1fAVqlda74CddBEF3JFdV+ZXbg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bX4ewcnaCxzUOsiE3pRYgUYq7gGZyiN0h+E9bNz2FdC1DSwU7+dV8xSiNzCkiULRKy/UWnBTzex8LbZ1YKQXo6ycPyf31RSHn3fXXbVIiC28wz5AvQpBQHW9juIyXc6uyYHhID4eXrEirxOr91S22u3nmiU6rHff0RedMq4XmdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Huou/F35; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726051565; x=1757587565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tz/9bpEpvXTAg2mfR1fAVqlda74CddBEF3JFdV+ZXbg=;
  b=Huou/F35bWgM4VjfZplp/FBYSfJbyQk7sTo20avsoBorQA/BZSif4CNU
   JOpv/xi6J/di7ewNGBPRH+Q2itk7T0Yas2P/hlw5UER3pxy8NzGwCqZMZ
   xl3Iyg5UE5LP3M7Gj0+IzpFx983OMQQQV6Odg8iYPpZz2GDU8WaSkUl4R
   wEfLf3bAn/VLzHC+fd4q8bGv+3soJKq8T/hv3UY3vLtEi79BJGRK2ByR3
   26k7sU0HbLY626GAfGpBxS95IcMySwoW6H4a13D3DYrnu698GjzoD7V4S
   JL+fE+xDCNhpnxXgxAZRPZvR5vypgDuJjPZgQ6/fqpnIQkEWqFrWafKXw
   g==;
X-CSE-ConnectionGUID: 8IPEXZESQYmp24nSPW/Wkg==
X-CSE-MsgGUID: fWaCSjU1QRWF+s1GoTZVsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="24989649"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="24989649"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 03:45:40 -0700
X-CSE-ConnectionGUID: HgCZHvMJRZSiV0SwbbvQXA==
X-CSE-MsgGUID: itJKT1J2QpCha9lDCroe0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="68102351"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 03:45:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 03:45:39 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 03:45:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 03:45:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 03:45:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tx+XoG3N8l64abIm39fS5t1S6ARuXHDS6kE6CWHmnCeaAu3JUH0hYMypsYEYjx0LtFT5+qqWqJmPEzcbVJcdntn9uCiwwJakltjHrE66t5NXkC4COMLRM8k+uTO9kRPpMqUfwGlez2EslV5QY4imWio+hd3MUfcHxtiFvZWBdfL93wCa2hMbCDQCJvWLbC1b10H45pczCqUqOEHZratRDOtWKiCUSRgoGF/XUG+n50jr1wXE6E1Qf/nSU9HgXshX2pliXTlGue1Hbo2oaZ2J73mXDNcWdeZnm2jlJqKY+85lkMLocyqNwQapENAa5MO/8SzdKKjgaCUnTAjsnkj8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tz/9bpEpvXTAg2mfR1fAVqlda74CddBEF3JFdV+ZXbg=;
 b=JW8RarRFKSoxd/1TZewadArNOmkHOngE1r6rDkdtcXqh6fBlMrdKU089FngVNhOWJ9CIpuMb5UpuhkgHm9Voreov583zg79K4g1fFn4z4cgRYHwyIt1jcafSzJxFKT4kHbBnoMHE3kaIzIcFV4PxA4WkvTuVOyQYYXxowF2Xwi6nYJBSeKp9eKYW7SvLbSt0WAKo8ji12iWpaZ3lFBWbckyrvH7XFOuRt2UyhcBI9rZagNv93q955CoodO2zjjYNxS/9mRbCXHUedwZB9+IMOJGwOOZRs3jWUSBL6Q7/AUDBEoDvwLejJ0N4EmpVB5B6q3FH6+gY2GDyHjXUThtnLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17)
 by MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Wed, 11 Sep
 2024 10:45:30 +0000
Received: from BL1PR11MB5368.namprd11.prod.outlook.com
 ([fe80::49e7:97ee:b593:9856]) by BL1PR11MB5368.namprd11.prod.outlook.com
 ([fe80::49e7:97ee:b593:9856%3]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 10:45:28 +0000
From: "Ma, Yongwei" <yongwei.ma@intel.com>
To: "Zhang, Mingwei" <mizhang@google.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, "Zhang, Xiong Y"
	<xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, "Liang,
 Kan" <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
CC: Jim Mattson <jmattson@google.com>, "Eranian, Stephane"
	<eranian@google.com>, Ian Rogers <irogers@google.com>, Namhyung Kim
	<namhyung@kernel.org>, "gce-passthrou-pmu-dev@google.com"
	<gce-passthrou-pmu-dev@google.com>, "Alt, Samantha" <samantha.alt@intel.com>,
	"Lv, Zhiyuan" <zhiyuan.lv@intel.com>, "Xu, Yanfei" <yanfei.xu@intel.com>,
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Raghavendra Rao Ananta <rananta@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>
Subject: RE: [RFC PATCH v3 00/58] Mediated Passthrough vPMU 3.0 for x86
Thread-Topic: [RFC PATCH v3 00/58] Mediated Passthrough vPMU 3.0 for x86
Thread-Index: AQHa48+chp9hqS2WVUqJshpe+IlziLJSp3Pw
Date: Wed, 11 Sep 2024 10:45:28 +0000
Message-ID: <BL1PR11MB53687F5CA44247655601E74F899B2@BL1PR11MB5368.namprd11.prod.outlook.com>
References: <20240801045907.4010984-1-mizhang@google.com>
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5368:EE_|MW4PR11MB8289:EE_
x-ms-office365-filtering-correlation-id: 81a0530a-f222-4b5d-b7ee-08dcd24ed9a9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?cWVkSlRLb3A4UXhnaEhQbVoraTAycEpOVUJsWXI4V0lRZGZYOUpkM2Z4VEVO?=
 =?utf-8?B?YU1YQmc3VWx4N2I3eW0yVU9qUCtmek1ONEp4c0lvYjdpcnQ2NjBWK2JOcmRY?=
 =?utf-8?B?Y1BRTWpDVUJkYVM5eVVwRTRyd0U0MWpkZklwUTAySTVSeXVLdlhlNWxwb1FS?=
 =?utf-8?B?R0JJN1dOMWlZQzFiVnhQdHRuSmJ0d3drbUVTdU91REk0YUlkaUE4N1l5VWpD?=
 =?utf-8?B?R0JBZXl6UUNsd2Jha0FSc1FYcnZKbWFEL0JVSCtHZmFUNnVmSmxqdnZseFFa?=
 =?utf-8?B?R0daNC9kNlc3dU84NDJWVlF1SWttbWptR1NNZEc3Qm9Jc2V4Wk9tUHczc3FX?=
 =?utf-8?B?c1JSM0NRUm5aK01FL3VEVk1OM2RMWXR0UmpwVC9aWmdKNTlScG1rMk1WOWYx?=
 =?utf-8?B?RkhBMlYzR092Myt3VnkxTU9RcFoveUVrcDNONThiU01yak93N1dYM0UycWw5?=
 =?utf-8?B?U2NUYTdxQXhPMzlUZTBnRnhCalBqaUYyUzFiTVpncFlMelE3UnZkU2JsVVAy?=
 =?utf-8?B?T2ZDbUVxQklGMWdValZkb1V6Ymg3aDUxU1huWVlKODU3TStEakpuSTF3YTZT?=
 =?utf-8?B?eDRsMElVTlE3L3RXdUhKVXRzRXFNTnIvcE5VZk1WR2ZoTkJVaXV0WnM4bTBt?=
 =?utf-8?B?NEJWNDB4OUp6YnJUaTF1Z1ExbGs3THZ6VHdRTklOUkdTT24yblEzVDV1NEdY?=
 =?utf-8?B?QmtRd1hNaTVERDBWNHNvNkJGL2t4VUdPYUJXRW9FYWZCN0Z0c0pXdjNubE5l?=
 =?utf-8?B?MFZndEJmNjQrNUJJQ3lqR2NGdStrWVcxZUY4VGdobzdJTUlxMjF3enpZaGxN?=
 =?utf-8?B?bHMvSk0wZElSVGRpRHNZdUc2YXdxTzBwTjNmUllaU1BVeXRmOEJXbzZrY2ox?=
 =?utf-8?B?VHQ3UkxSc1pKZWdZTXJjKzJRb1Zicml2RWMva2UwQ2ZNcEIyUjYxT2plYzMy?=
 =?utf-8?B?R3RxbEIzZjBvOVZudENzRkhCenpDT2dkNXBPMWI0bEVsbSt5MGppUGR2Z2kr?=
 =?utf-8?B?UXNnTlBpQlFyQWVPTW43Ympxa0dadkNhSG5jMXdmTHlEL3dpUllwN1lUdEJE?=
 =?utf-8?B?R3JwRjlkekZpU0N0ZWQ1N2pUTzZ2cmVFZUxIMlVkQUlMRUk1Y3crYWJKZmZs?=
 =?utf-8?B?LzVyWkJYY25rSzJBMVp0Qk11WnhFNDRGZVVWaXVDYXdRWXhnYU9vd2dIT3ZL?=
 =?utf-8?B?Wkhvdy9lNmY1VTBTY1N3bTB5TGN2Q0dsVlpHdlUwT285SktZSWpZSlZLK1Bv?=
 =?utf-8?B?L1hwNk96MmwyRHBKb2dkS0hsWG5HODlaSFBzZ25jTXNhUW00OUx5aERqWVpP?=
 =?utf-8?B?VktWYmRobjVMNjNuaHNDMVVyUkVmMTczSTZWYWY0dWkvZjZVb2dyQzg4dGxu?=
 =?utf-8?B?VE5mTG1MMmxjYTkzcWxxMHNyWmhyaTVSMWdsb3ZQSEpVdU56Znk3VVQ5MDJx?=
 =?utf-8?B?V1FHR0VZTlJpTWdQSE1peU1uVmcyWHpaVEorbTlyanJJUE1NOVVUcWVaMjln?=
 =?utf-8?B?UkNrRFJiME84aWVkclVncy9sTVIrU2pXeEM1OTRMTFZHbk5iV2hEN0JrSVhQ?=
 =?utf-8?B?YmtMYXBoNEJMMXJpSnYrb2J4NVgyV2RtNXgvMHpsK1ZuNDJVYlg1QUU4RUFJ?=
 =?utf-8?B?RGNWVFkxZlVINndkaHFZWk1SMHgxVXNDN2QzdGV4Q0xPU1lQT2pvUVJmbGFl?=
 =?utf-8?B?MUE4T28zcHhGd2VKeGJVbWk5UXEzNEZST29uRWVwYTZjMnNNL0hEMml1UDM3?=
 =?utf-8?B?dlQvS01VTHZycXJURmhoSlBaZ3gzMEY5NFlYN3hvM25tcUJGWEJYOGI0RUZo?=
 =?utf-8?B?eUNKckZvT0x2eG5SMFZ0VG1VSWJHRjlsYXF1QjZGYm83QzEraUN1ZzRYUy9Z?=
 =?utf-8?B?ZkcvalBsU2dqZk9Da3laOC83cTJvZk96c3JLdnBJTjd3c3V0QUNka01aaWY3?=
 =?utf-8?Q?B+mRmThPpy5QDAMlUdC11Ebl1c0hTJ/W?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5368.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S3gycGJERlRiTmNHMVJFdEsySjlTbHErVDN3SGlqU1NnUUc5aTdES25xV29W?=
 =?utf-8?B?K0trMjRLOEloRG1uMzNKU2NJVmdFZmE3ZUhhOXRnUHBhUWtTTW1jNUtHYjNW?=
 =?utf-8?B?L1NNaE1wb0J1L0VsVjNlNlBDbHdjaHcvVytsWWlkTW92azZkaTFScmRQb25J?=
 =?utf-8?B?WGFQMnJtTVpmUVNzb1o1L3VhVHNwRC95eG5pSDRJNlJRNklHc1JoMWJxRURs?=
 =?utf-8?B?YUcvUEFUMjFUV3h6U1dtSVl1MzBVQnNnMnRUQW1DN3h3ZHN3V2lsWEpXU2Nw?=
 =?utf-8?B?U0NGVmpIVGF0M2pXQzJrcGo0bGs4UlVWSnVRL21TaEYzQmdUWWQ5VDdwT0JP?=
 =?utf-8?B?YUpyUjhRL2FjZ3dGd3ZWNGhKQmhZaERwOVcxNWV1UGlod21BM3EyTHo0UzAw?=
 =?utf-8?B?RGxpY3hEUGtoQlBFdGRIazBEaktOS1F6T2ZYS2pzc3VheDl1bkFURUNpTVgv?=
 =?utf-8?B?aTkvbnFvdElpRUplQnZja0JxN2dLWXgweHRyQXlNVmIxRjRuWDZNMlZDTXZy?=
 =?utf-8?B?NXM3Rlc0VjVrejRvWUdyL1E2ZUp0L05aRlk3ZkpDTXVQdHpSQ01xMTNXWTg3?=
 =?utf-8?B?UEg1eFJHWnFJQVlEbTUwR2ZzRWZzQnBWTy9hYWxNWE1qeSthWWRuZ2lCYk1w?=
 =?utf-8?B?MFVSdm5hemZZQ1AzMGlwWmpTeEhOd3BpNTZNTEs0L2JkS0dMSkFSdUk1OFU2?=
 =?utf-8?B?Q0M1WEZWNlptak1McTNleiswSlVhVzhOS0x2ZVRyVmswV3VSd2tFOG1oYzRr?=
 =?utf-8?B?SFUwVXovWlBPYlFlL2ozRVZEUWc5Z1NBNXhTbmZkNlFmb3JuSUREMWV0NFc5?=
 =?utf-8?B?RlIwcHhuVDBMd3czdWM2WG5tWFdMbmdqTk81QmdJTFFLUXdSZGtLR2tpOFM2?=
 =?utf-8?B?WkdPaGlBenVjTzlmRzU3QzFkSmdsQy9KYmxsblIzc3VTZWxGSWpxSm00NW5I?=
 =?utf-8?B?a2FlbGJaWmpCM3E0K1RZaStidTUwTy9DRFdPOExGd0E2K0ZaaTlIanBkVTcr?=
 =?utf-8?B?WVZnbW9LREIwM25PRklPY0ZLSTR0NnRYcENPamJGMzF1K0hDR1N0NC9EYjl3?=
 =?utf-8?B?REN5cHZLaFRlV3E0YjRUUERJMDFKUzhHKzc2ZzZlUW42Z1JPQWU2N1M5aVhM?=
 =?utf-8?B?UUdRN0Vwdjd6S01xYU44ZGE2eDl4UFVDMFRYazJpNi9xMHVXclBOb2ZtNXJI?=
 =?utf-8?B?a1g2ME1ROG1qU2VDZ0ZzRkt4TEFBK0JQM0lQUm1LOUtnMTd0VUROR29jQU5k?=
 =?utf-8?B?aGZpeUw2ZGdEbm5xS0xockJVSDcxNExqMWQ3RTN0NXRTWmdBcjNuR2JsWVd3?=
 =?utf-8?B?RFlFbmc3bGVrbHNyOFFFM2IyVmVDS3JObDFibTQ0bG1rZ3ZTYXZ1d0ZrOXZM?=
 =?utf-8?B?RE9RTlZuMXBVSWRVNjRENWh0NE1Gayt0NWx1L0pLdFBzRTVPdEM0QjZNS0tu?=
 =?utf-8?B?YzBQbjdGdy9pa1F2MllET0lPRGc5ZUNVcGREeTFpSG92aGo5cE5iQytMdkFD?=
 =?utf-8?B?V3RnRDZuTkt5VkJEQS8yc1dFd295T3lxR3BtMHdLQ1k5dWZPVUg3dTEvdHVG?=
 =?utf-8?B?d01sRmw5U1FaclhHMHNuaE12eWFHdXoxc05MNWg0a2N4UHR4RkJyUFR2VkR4?=
 =?utf-8?B?RmdHWExuTU5ZV0pNV0MvejZvSE4wK3ZRRWlDVS9kdXdlaGprNDFQZEo0MjJQ?=
 =?utf-8?B?QVBDbEdMMFJscDJ0a1NZajNab2NCS21QRzNkdk45dlZteFk3LzU1d1RMeW1X?=
 =?utf-8?B?eG5ZMEN1T21YMEI3c2xHUS9BN1RHOUxTTUYwUEx1bVNrVG02dFB1WkplZkg1?=
 =?utf-8?B?NTR2TFlsWnQva25TVng2dkU5NlQwWFZyL0hzYlk2aVdvNjZkOS9qMVBlbGRJ?=
 =?utf-8?B?K251UW42M2xKQVBxaXlIaSsrR1Y1ZnhRY3VpeUJvL0tpU0h3RmE5YS9ibzhH?=
 =?utf-8?B?TWhSdGpiZ2FrdmpqWHlIeHdBRnVSNExMWlE3UEdPamRzOEJ2akM1QWV3MHhv?=
 =?utf-8?B?RFhYS08xYUtrdDQxNGtZTlJCNmVKV2s0Q1U3eGN4a2FMYVZsWm5WYWZIeXl3?=
 =?utf-8?B?Vy9mZTJDQnQvZXV6K1I0Z2lYSnBQOEUzZzFQRkhxbzJ3R2ZMWHlNV3NIeHNl?=
 =?utf-8?Q?eErgCuXVJYY2DHTg1xzsu87O/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5368.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a0530a-f222-4b5d-b7ee-08dcd24ed9a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 10:45:28.0520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4jDjjK1w7XOQp+yhmbFnA4d6WV2fBUWFsn15cw0atk98QMFZAda4gCA2lYYKNjb+OsX5VOqKhUAC4DOLebtgSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8289
X-OriginatorOrg: intel.com

T24gMjAyNC85LzExIDE2OjE2LCBZb25nd2VpIE1hIHdyb3RlOg0KPiBUaGlzIHNlcmllcyBjb250
YWlucyBwZXJmIGludGVyZmFjZSBpbXByb3ZlbWVudHMgdG8gYWRkcmVzcyBQZXRlcidzDQo+IGNv
bW1lbnRzLiBJbiBhZGRpdGlvbiwgZml4IHNldmVyYWwgYnVncyBmb3IgdjIuIFRoaXMgdmVyc2lv
biBpcyBiYXNlZCBvbiA2LjEwLQ0KPiByYzQuIFRoZSBtYWluIGNoYW5nZXMgYXJlOg0KPiANCj4g
IC0gVXNlIGF0b21pY3MgdG8gcmVwbGFjZSByZWZjb3VudHMgdG8gdHJhY2sgdGhlIG5yX21lZGlh
dGVkX3BtdV92bXMuDQo+ICAtIFVzZSB0aGUgZ2VuZXJpYyBjdHhfc2NoZWRfe2luLG91dH0oKSB0
byBzd2l0Y2ggUE1VIHJlc291cmNlcyB3aGVuIGENCj4gICAgZ3Vlc3QgaXMgZW50ZXJpbmcgYW5k
IGV4aXRpbmcuDQo+ICAtIEFkZCBhIG5ldyBFVkVOVF9HVUVTVCBmbGFnIHRvIGluZGljYXRlIHRo
ZSBjb250ZXh0IHN3aXRjaCBjYXNlIG9mDQo+ICAgIGVudGVyaW5nIGFuZCBleGl0aW5nIGEgZ3Vl
c3QuIFVwZGF0ZXMgdGhlIGdlbmVyaWMgY3R4X3NjaGVkX3tpbixvdXR9DQo+ICAgIHRvIHNwZWNp
ZmljYWxseSBoYW5kbGUgdGhpcyBjYXNlLCBlc3BlY2lhbGx5IGZvciB0aW1lIG1hbmFnZW1lbnQu
DQo+ICAtIFN3aXRjaCBQTUkgdmVjdG9yIGluIHBlcmZfZ3Vlc3Rfe2VudGVyLGV4aXR9KCkgYXMg
d2VsbC4gQWRkIGEgbmV3DQo+ICAgIGRyaXZlci1zcGVjaWZpYyBpbnRlcmZhY2UgdG8gZmFjaWxp
dGF0ZSB0aGUgc3dpdGNoLg0KPiAgLSBSZW1vdmUgdGhlIFBNVV9GTF9QQVNTVEhST1VHSCBmbGFn
IGFuZCB1c2VzIHRoZSBQQVNTVEhST1VHSCBwbXUNCj4gICAgY2FwYWJpbGl0eSBpbnN0ZWFkLg0K
PiAgLSBBZGp1c3QgY29tbWl0IHNlcXVlbmNlIGluIFBFUkYgYW5kIEtWTSBQTUkgaW50ZXJydXB0
IGZ1bmN0aW9ucy4NCj4gIC0gVXNlIHBtY19pc19nbG9iYWxseV9lbmFibGVkKCkgY2hlY2sgaW4g
ZW11bGF0ZWQgY291bnRlciBpbmNyZW1lbnQgWzFdDQo+ICAtIEZpeCBQTVUgY29udGV4dCBzd2l0
Y2ggWzJdIGJ5IHVzaW5nIHJkcG1jKCkgaW5zdGVhZCBvZiByZG1zcigpLg0KPiANCj4gQU1EIGZp
eGVzOg0KPiAgLSBBZGQgc3VwcG9ydCBmb3IgbGVnYWN5IFBNVSBNU1JzIGluIE1TUiBpbnRlcmNl
cHRpb24uDQo+ICAtIE1ha2UgTVNSIHVzYWdlIGNvbnNpc3RlbnQgaWYgUGVyZk1vblYyIGlzIGF2
YWlsYWJsZS4NCj4gIC0gQXZvaWQgZW5hYmxpbmcgcGFzc3Rocm91Z2ggdlBNVSB3aGVuIGxvY2Fs
IEFQSUMgaXMgbm90IGluIGtlcm5lbC4NCj4gIC0gaW5jcmVtZW50IGNvdW50ZXJzIGluIGVtdWxh
dGlvbiBtb2RlLg0KPiANCj4gVGhpcyBzZXJpZXMgaXMgb3JnYW5pemVkIGluIHRoZSBmb2xsb3dp
bmcgb3JkZXI6DQo+IA0KPiBQYXRjaGVzIDEtMzoNCj4gIC0gSW1tZWRpYXRlIGJ1ZyBmaXhlcyB0
aGF0IGNhbiBiZSBhcHBsaWVkIHRvIExpbnV4IHRpcC4NCj4gIC0gTm90ZTogd2lsbCBwdXQgaW1t
ZWRpYXRlIGZpeGVzIGFoZWFkIGluIHRoZSBmdXR1cmUuIFRoZXNlIHBhdGNoZXMNCj4gICAgbWln
aHQgYmUgZHVwbGljYXRlZCB3aXRoIGV4aXN0aW5nIHBvc3RzLg0KPiAgLSBOb3RlOiBwYXRjaGVz
IDEtMiBhcmUgbmVlZGVkIGZvciBBTUQgd2hlbiBob3N0IGtlcm5lbCBlbmFibGVzDQo+ICAgIHBy
ZWVtcHRpb24uIE90aGVyd2lzZSwgZ3Vlc3Qgd2lsbCBzdWZmZXIgZnJvbSBzb2Z0bG9ja3VwLg0K
PiANCj4gUGF0Y2hlcyA0LTE3Og0KPiAgLSBQZXJmIHNpZGUgY2hhbmdlcywgaW5mcmEgY2hhbmdl
cyBpbiBjb3JlIHBtdSB3aXRoIEFQSSBmb3IgS1ZNLg0KPiANCj4gUGF0Y2hlcyAxOC00ODoNCj4g
IC0gS1ZNIG1lZGlhdGVkIHBhc3N0aHJvdWdoIHZQTVUgZnJhbWV3b3JrICsgSW50ZWwgQ1BVIGlt
cGxlbWVudGF0aW9uLg0KPiANCj4gUGF0Y2hlcyA0OS01ODoNCj4gIC0gQU1EIENQVSBpbXBsZW1l
bnRhdGlvbiBmb3IgdlBNVS4NCj4gDQo+IFJlZmVyZW5jZSAocGF0Y2hlcyBpbiB2Mik6DQo+IFsx
XSBbUEFUQ0ggdjIgNDIvNTRdIEtWTTogeDg2L3BtdTogSW1wbGVtZW50IGVtdWxhdGVkIGNvdW50
ZXINCj4gaW5jcmVtZW50IGZvciBwYXNzdGhyb3VnaCBQTVUNCj4gIC0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzIwMjQwNTA2MDUzMDIwLjM5MTE5NDAtNDMtDQo+IG1pemhhbmdAZ29vZ2xl
LmNvbS8NCj4gWzJdIFtQQVRDSCB2MiAzMC81NF0gS1ZNOiB4ODYvcG11OiBJbXBsZW1lbnQgdGhl
IHNhdmUvcmVzdG9yZSBvZiBQTVUNCj4gc3RhdGUgZm9yIEludGVsIENQVQ0KPiAgLSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNDA1MDYwNTMwMjAuMzkxMTk0MC0zMS0NCj4gbWl6aGFu
Z0Bnb29nbGUuY29tLw0KPiANCj4gVjI6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI0
MDUwNjA1MzAyMC4zOTExOTQwLTEtDQo+IG1pemhhbmdAZ29vZ2xlLmNvbS8NCj4gDQo+IERhcGVu
ZyBNaSAoMyk6DQo+ICAgeDg2L21zcjogSW50cm9kdWNlIE1TUl9DT1JFX1BFUkZfR0xPQkFMX1NU
QVRVU19TRVQNCj4gICBLVk06IHg4Ni9wbXU6IEludHJvZHVjZSBtYWNybyBQTVVfQ0FQX1BFUkZf
TUVUUklDUw0KPiAgIEtWTTogeDg2L3BtdTogQWRkIGludGVsX3Bhc3N0aHJvdWdoX3BtdV9tc3Jz
KCkgdG8gcGFzcy10aHJvdWdoIFBNVQ0KPiAgICAgTVNScw0KPiANCj4gS2FuIExpYW5nICg4KToN
Cj4gICBwZXJmOiBTdXBwb3J0IGdldC9wdXQgcGFzc3Rocm91Z2ggUE1VIGludGVyZmFjZXMNCj4g
ICBwZXJmOiBTa2lwIHBtdV9jdHggYmFzZWQgb24gZXZlbnRfdHlwZQ0KPiAgIHBlcmY6IENsZWFu
IHVwIHBlcmYgY3R4IHRpbWUNCj4gICBwZXJmOiBBZGQgYSBFVkVOVF9HVUVTVCBmbGFnDQo+ICAg
cGVyZjogQWRkIGdlbmVyaWMgZXhjbHVkZV9ndWVzdCBzdXBwb3J0DQo+ICAgcGVyZjogQWRkIHN3
aXRjaF9pbnRlcnJ1cHQoKSBpbnRlcmZhY2UNCj4gICBwZXJmL3g4NjogU3VwcG9ydCBzd2l0Y2hf
aW50ZXJydXB0IGludGVyZmFjZQ0KPiAgIHBlcmYveDg2L2ludGVsOiBTdXBwb3J0IFBFUkZfUE1V
X0NBUF9QQVNTVEhST1VHSF9WUE1VDQo+IA0KPiBNYW5hbGkgU2h1a2xhICgxKToNCj4gICBLVk06
IHg4Ni9wbXUvc3ZtOiBXaXJlIHVwIFBNVSBmaWx0ZXJpbmcgZnVuY3Rpb25hbGl0eSBmb3IgcGFz
c3Rocm91Z2gNCj4gICAgIFBNVQ0KPiANCj4gTWluZ3dlaSBaaGFuZyAoMjQpOg0KPiAgIHBlcmYv
eDg2OiBGb3JiaWQgUE1JIGhhbmRsZXIgd2hlbiBndWVzdCBvd24gUE1VDQo+ICAgcGVyZjogY29y
ZS94ODY6IFBsdW1iIHBhc3N0aHJvdWdoIFBNVSBjYXBhYmlsaXR5IGZyb20geDg2X3BtdSB0bw0K
PiAgICAgeDg2X3BtdV9jYXANCj4gICBLVk06IHg4Ni9wbXU6IEludHJvZHVjZSBlbmFibGVfcGFz
c3Rocm91Z2hfcG11IG1vZHVsZSBwYXJhbWV0ZXINCj4gICBLVk06IHg4Ni9wbXU6IFBsdW1iIHRo
cm91Z2ggcGFzcy10aHJvdWdoIFBNVSB0byB2Y3B1IGZvciBJbnRlbCBDUFVzDQo+ICAgS1ZNOiB4
ODYvcG11OiBBZGQgYSBoZWxwZXIgdG8gY2hlY2sgaWYgcGFzc3Rocm91Z2ggUE1VIGlzIGVuYWJs
ZWQNCj4gICBLVk06IHg4Ni9wbXU6IEFkZCBob3N0X3BlcmZfY2FwIGFuZCBpbml0aWFsaXplIGl0
IGluDQo+ICAgICBrdm1feDg2X3ZlbmRvcl9pbml0KCkNCj4gICBLVk06IHg4Ni9wbXU6IEFsbG93
IFJEUE1DIHBhc3MgdGhyb3VnaCB3aGVuIGFsbCBjb3VudGVycyBleHBvc2VkIHRvDQo+ICAgICBn
dWVzdA0KPiAgIEtWTTogeDg2L3BtdTogSW50cm9kdWNlIFBNVSBvcGVyYXRvciB0byBjaGVjayBp
ZiByZHBtYyBwYXNzdGhyb3VnaA0KPiAgICAgYWxsb3dlZA0KPiAgIEtWTTogeDg2L3BtdTogQ3Jl
YXRlIGEgZnVuY3Rpb24gcHJvdG90eXBlIHRvIGRpc2FibGUgTVNSIGludGVyY2VwdGlvbg0KPiAg
IEtWTTogeDg2L3BtdTogQXZvaWQgbGVnYWN5IHZQTVUgY29kZSB3aGVuIGFjY2Vzc2luZyBnbG9i
YWxfY3RybCBpbg0KPiAgICAgcGFzc3Rocm91Z2ggdlBNVQ0KPiAgIEtWTTogeDg2L3BtdTogRXhj
bHVkZSBQTVUgTVNScyBpbiB2bXhfZ2V0X3Bhc3N0aHJvdWdoX21zcl9zbG90KCkNCj4gICBLVk06
IHg4Ni9wbXU6IEFkZCBjb3VudGVyIE1TUiBhbmQgc2VsZWN0b3IgTVNSIGluZGV4IGludG8gc3Ry
dWN0DQo+ICAgICBrdm1fcG1jDQo+ICAgS1ZNOiB4ODYvcG11OiBJbnRyb2R1Y2UgUE1VIG9wZXJh
dGlvbiBwcm90b3R5cGVzIGZvciBzYXZlL3Jlc3RvcmUgUE1VDQo+ICAgICBjb250ZXh0DQo+ICAg
S1ZNOiB4ODYvcG11OiBJbXBsZW1lbnQgdGhlIHNhdmUvcmVzdG9yZSBvZiBQTVUgc3RhdGUgZm9y
IEludGVsIENQVQ0KPiAgIEtWTTogeDg2L3BtdTogTWFrZSBjaGVja19wbXVfZXZlbnRfZmlsdGVy
KCkgYW4gZXhwb3J0ZWQgZnVuY3Rpb24NCj4gICBLVk06IHg4Ni9wbXU6IEFsbG93IHdyaXRpbmcg
dG8gZXZlbnQgc2VsZWN0b3IgZm9yIEdQIGNvdW50ZXJzIGlmIGV2ZW50DQo+ICAgICBpcyBhbGxv
d2VkDQo+ICAgS1ZNOiB4ODYvcG11OiBBbGxvdyB3cml0aW5nIHRvIGZpeGVkIGNvdW50ZXIgc2Vs
ZWN0b3IgaWYgY291bnRlciBpcw0KPiAgICAgZXhwb3NlZA0KPiAgIEtWTTogeDg2L3BtdTogRXhj
bHVkZSBleGlzdGluZyB2TEJSIGxvZ2ljIGZyb20gdGhlIHBhc3N0aHJvdWdoIFBNVQ0KPiAgIEtW
TTogeDg2L3BtdTogSW50cm9kdWNlIFBNVSBvcGVyYXRvciB0byBpbmNyZW1lbnQgY291bnRlcg0K
PiAgIEtWTTogeDg2L3BtdTogSW50cm9kdWNlIFBNVSBvcGVyYXRvciBmb3Igc2V0dGluZyBjb3Vu
dGVyIG92ZXJmbG93DQo+ICAgS1ZNOiB4ODYvcG11OiBJbXBsZW1lbnQgZW11bGF0ZWQgY291bnRl
ciBpbmNyZW1lbnQgZm9yIHBhc3N0aHJvdWdoDQo+IFBNVQ0KPiAgIEtWTTogeDg2L3BtdTogVXBk
YXRlIHBtY197cmVhZCx3cml0ZX1fY291bnRlcigpIHRvIGRpc2Nvbm5lY3QgcGVyZiBBUEkNCj4g
ICBLVk06IHg4Ni9wbXU6IERpc2Nvbm5lY3QgY291bnRlciByZXByb2dyYW0gbG9naWMgZnJvbSBw
YXNzdGhyb3VnaCBQTVUNCj4gICBLVk06IG5WTVg6IEFkZCBuZXN0ZWQgdmlydHVhbGl6YXRpb24g
c3VwcG9ydCBmb3IgcGFzc3Rocm91Z2ggUE1VDQo+IA0KPiBTYW5kaXBhbiBEYXMgKDEyKToNCj4g
ICBwZXJmL3g4NjogRG8gbm90IHNldCBiaXQgd2lkdGggZm9yIHVuYXZhaWxhYmxlIGNvdW50ZXJz
DQo+ICAgeDg2L21zcjogRGVmaW5lIFBlcmZDbnRyR2xvYmFsU3RhdHVzU2V0IHJlZ2lzdGVyDQo+
ICAgS1ZNOiB4ODYvcG11OiBBbHdheXMgc2V0IGdsb2JhbCBlbmFibGUgYml0cyBpbiBwYXNzdGhy
b3VnaCBtb2RlDQo+ICAgS1ZNOiB4ODYvcG11L3N2bTogU2V0IHBhc3N0aHJvdWdoIGNhcGFiaWxp
dHkgZm9yIHZjcHVzDQo+ICAgS1ZNOiB4ODYvcG11L3N2bTogU2V0IGVuYWJsZV9wYXNzdGhyb3Vn
aF9wbXUgbW9kdWxlIHBhcmFtZXRlcg0KPiAgIEtWTTogeDg2L3BtdS9zdm06IEFsbG93IFJEUE1D
IHBhc3MgdGhyb3VnaCB3aGVuIGFsbCBjb3VudGVycyBleHBvc2VkDQo+ICAgICB0byBndWVzdA0K
PiAgIEtWTTogeDg2L3BtdS9zdm06IEltcGxlbWVudCBjYWxsYmFjayB0byBkaXNhYmxlIE1TUiBp
bnRlcmNlcHRpb24NCj4gICBLVk06IHg4Ni9wbXUvc3ZtOiBTZXQgR3Vlc3RPbmx5IGJpdCBhbmQg
Y2xlYXIgSG9zdE9ubHkgYml0IHdoZW4gZ3Vlc3QNCj4gICAgIHdyaXRlIHRvIGV2ZW50IHNlbGVj
dG9ycw0KPiAgIEtWTTogeDg2L3BtdS9zdm06IEFkZCByZWdpc3RlcnMgdG8gZGlyZWN0IGFjY2Vz
cyBsaXN0DQo+ICAgS1ZNOiB4ODYvcG11L3N2bTogSW1wbGVtZW50IGhhbmRsZXJzIHRvIHNhdmUg
YW5kIHJlc3RvcmUgY29udGV4dA0KPiAgIEtWTTogeDg2L3BtdS9zdm06IEltcGxlbWVudCBjYWxs
YmFjayB0byBpbmNyZW1lbnQgY291bnRlcnMNCj4gICBwZXJmL3g4Ni9hbWQ6IFN1cHBvcnQgUEVS
Rl9QTVVfQ0FQX1BBU1NUSFJPVUdIX1ZQTVUgZm9yIEFNRA0KPiBob3N0DQo+IA0KPiBTZWFuIENo
cmlzdG9waGVyc29uICgyKToNCj4gICBzY2hlZC9jb3JlOiBNb3ZlIHByZWVtcHRfbW9kZWxfKigp
IGhlbHBlcnMgZnJvbSBzY2hlZC5oIHRvIHByZWVtcHQuaA0KPiAgIHNjaGVkL2NvcmU6IERyb3Ag
c3BpbmxvY2tzIG9uIGNvbnRlbnRpb24gaWZmIGtlcm5lbCBpcyBwcmVlbXB0aWJsZQ0KPiANCj4g
WGlvbmcgWmhhbmcgKDgpOg0KPiAgIHg4Ni9pcnE6IEZhY3RvciBvdXQgY29tbW9uIGNvZGUgZm9y
IGluc3RhbGxpbmcga3ZtIGlycSBoYW5kbGVyDQo+ICAgcGVyZjogY29yZS94ODY6IFJlZ2lzdGVy
IGEgbmV3IHZlY3RvciBmb3IgS1ZNIEdVRVNUIFBNSQ0KPiAgIEtWTTogeDg2L3BtdTogUmVnaXN0
ZXIgS1ZNX0dVRVNUX1BNSV9WRUNUT1IgaGFuZGxlcg0KPiAgIEtWTTogeDg2L3BtdTogTWFuYWdl
IE1TUiBpbnRlcmNlcHRpb24gZm9yIElBMzJfUEVSRl9HTE9CQUxfQ1RSTA0KPiAgIEtWTTogeDg2
L3BtdTogU3dpdGNoIElBMzJfUEVSRl9HTE9CQUxfQ1RSTCBhdCBWTSBib3VuZGFyeQ0KPiAgIEtW
TTogeDg2L3BtdTogTm90aWZ5IHBlcmYgY29yZSBhdCBLVk0gY29udGV4dCBzd2l0Y2ggYm91bmRh
cnkNCj4gICBLVk06IHg4Ni9wbXU6IEdyYWIgeDg2IGNvcmUgUE1VIGZvciBwYXNzdGhyb3VnaCBQ
TVUgVk0NCj4gICBLVk06IHg4Ni9wbXU6IEFkZCBzdXBwb3J0IGZvciBQTVUgY29udGV4dCBzd2l0
Y2ggYXQgVk0tZXhpdC9lbnRlcg0KPiANCj4gIC4uLi9hZG1pbi1ndWlkZS9rZXJuZWwtcGFyYW1l
dGVycy50eHQgICAgICAgICB8ICAgNCArLQ0KPiAgYXJjaC94ODYvZXZlbnRzL2FtZC9jb3JlLmMg
ICAgICAgICAgICAgICAgICAgIHwgICAyICsNCj4gIGFyY2gveDg2L2V2ZW50cy9jb3JlLmMgICAg
ICAgICAgICAgICAgICAgICAgICB8ICA0NCArLQ0KPiAgYXJjaC94ODYvZXZlbnRzL2ludGVsL2Nv
cmUuYyAgICAgICAgICAgICAgICAgIHwgICA1ICsNCj4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2hh
cmRpcnEuaCAgICAgICAgICAgICAgICB8ICAgMSArDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9p
ZHRlbnRyeS5oICAgICAgICAgICAgICAgfCAgIDEgKw0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20v
aXJxLmggICAgICAgICAgICAgICAgICAgIHwgICAyICstDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9pcnFfdmVjdG9ycy5oICAgICAgICAgICAgfCAgIDUgKy0NCj4gIGFyY2gveDg2L2luY2x1ZGUv
YXNtL2t2bS14ODYtcG11LW9wcy5oICAgICAgICB8ICAgNiArDQo+ICBhcmNoL3g4Ni9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oICAgICAgICAgICAgICAgfCAgIDkgKw0KPiAgYXJjaC94ODYvaW5jbHVk
ZS9hc20vbXNyLWluZGV4LmggICAgICAgICAgICAgIHwgICAyICsNCj4gIGFyY2gveDg2L2luY2x1
ZGUvYXNtL3BlcmZfZXZlbnQuaCAgICAgICAgICAgICB8ICAgMSArDQo+ICBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS92bXguaCAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiAgYXJjaC94ODYva2Vy
bmVsL2lkdC5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gIGFyY2gveDg2L2tl
cm5lbC9pcnEuYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICAzOSArLQ0KPiAgYXJjaC94ODYv
a3ZtL2NwdWlkLmMgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAzICsNCj4gIGFyY2gveDg2
L2t2bS9wbXUuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDE1NCArKysrKy0NCj4gIGFy
Y2gveDg2L2t2bS9wbXUuaCAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA0OSArKw0KPiAg
YXJjaC94ODYva3ZtL3N2bS9wbXUuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgMTM2ICsrKysr
LQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9zdm0uYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDMx
ICsrDQo+ICBhcmNoL3g4Ni9rdm0vc3ZtL3N2bS5oICAgICAgICAgICAgICAgICAgICAgICAgfCAg
IDIgKy0NCj4gIGFyY2gveDg2L2t2bS92bXgvY2FwYWJpbGl0aWVzLmggICAgICAgICAgICAgICB8
ICAgMSArDQo+ICBhcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jICAgICAgICAgICAgICAgICAgICAg
fCAgNTIgKysrDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3BtdV9pbnRlbC5jICAgICAgICAgICAgICAg
ICAgfCAxOTIgKysrKysrKy0NCj4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgICAgICAgICAgICAg
ICAgICAgICAgICB8IDE5NyArKysrKystLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC92bXguaCAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICAzICstDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgNDUgKysNCj4gIGFyY2gveDg2L2t2bS94ODYuaCAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+ICBpbmNsdWRlL2xpbnV4L3BlcmZfZXZl
bnQuaCAgICAgICAgICAgICAgICAgICAgfCAgMzggKy0NCj4gIGluY2x1ZGUvbGludXgvcHJlZW1w
dC5oICAgICAgICAgICAgICAgICAgICAgICB8ICA0MSArKw0KPiAgaW5jbHVkZS9saW51eC9zY2hl
ZC5oICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDQxIC0tDQo+ICBpbmNsdWRlL2xpbnV4L3Nw
aW5sb2NrLmggICAgICAgICAgICAgICAgICAgICAgfCAgMTQgKy0NCj4gIGtlcm5lbC9ldmVudHMv
Y29yZS5jICAgICAgICAgICAgICAgICAgICAgICAgICB8IDQ0MSArKysrKysrKysrKysrKy0tLS0N
Cj4gIC4uLi9iZWF1dHkvYXJjaC94ODYvaW5jbHVkZS9hc20vaXJxX3ZlY3RvcnMuaCB8ICAgNSAr
LQ0KPiAgMzQgZmlsZXMgY2hhbmdlZCwgMTM3MyBpbnNlcnRpb25zKCspLCAxOTYgZGVsZXRpb25z
KC0pDQo+IA0KPiANCj4gYmFzZS1jb21taXQ6IDZiYTU5ZmY0MjI3OTI3ZDNhODUzMGZjMjk3M2I4
MGU5NGI1NGQ1OGYNCj4gLS0NCj4gMi40Ni4wLnJjMS4yMzIuZzk3NTJmOWUxMjMtZ29vZw0KPiAN
ClRlc3RlZCBvbiBJbnRlbCBJY2UgTGFrZSBhbmQgU2t5IExha2UgcGxhdGZvcm1zLiANClJ1biBr
dm0tdW5pdC10ZXN0LCBrc2VsZnRlc3QgYW5kIHBlcmYgZnV6eiB0ZXN0LiANCkNvbXBhcmVkIHdp
dGggdGhlIG5vIG1lZGlhdGVkIHZwbXUgc29sdXRpb24sIGRpZCBub3Qgc2VlIGFueSBvYnZpb3Vz
IGlzc3VlLg0KVGVzdGVkLWJ5OiBZb25nd2VpIE1hIDx5b25nd2VpLm1hQGludGVsLmNvbT4NCg0K
QmVzdCBSZWdhcmQsDQpZb25nd2VpIE1hDQo=

