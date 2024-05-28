Return-Path: <kvm+bounces-18188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 276F18D1223
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 04:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E018B2127A
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 02:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D55910957;
	Tue, 28 May 2024 02:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZkU2O0b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD3A9450;
	Tue, 28 May 2024 02:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716863732; cv=fail; b=CQmYESA+g2o/A4Zj6BeYUHIrfcU8qzPpaPlHxon90gWGAI+6uj+LZUaiwsOOHEQ/0y9maGWuO1jsrh7zp1oVDuENgOR7hjiknXYTRjAZjm37kD4urVTrwqlb8eQusiHkFFvK6kaZKTYjE7eKF1XRm2oMHaKSvKJZuYI/r6QcXqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716863732; c=relaxed/simple;
	bh=LEnKnTwgbHpLVD34DGV5gILitwFTIKYv0XXO8Bt0AfA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=snKOUVtjelKyQ6JowAPjJQ8D+ZfhmUizkiLrZ3QJLxHQsO49Zrh/rpiDrdJIFkCuqdT5VFpJZRgGbUHLXqCx9MejFUlLcodaRj9HPxK9hxHzMAOt/pjWzFZRcJQzWWqqaKUaCZzEQSHyQ8cNPyTBY0pQgn+TDELdn06PNjD1piM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZkU2O0b; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716863730; x=1748399730;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LEnKnTwgbHpLVD34DGV5gILitwFTIKYv0XXO8Bt0AfA=;
  b=IZkU2O0bcS3LTbkYYpEofH2hpyymQz6RMQqb8F0jeTsYNZ7H0LADNugZ
   Mo1ISU9XwsQQnCGRMtCUnXn1k915FkUc+fqk4K0QbEOPg95LZHW/FLWEy
   hzNmX/A/u4OXXMW0Xa/slTKnvhA/BkPiV9Gl762hO/vsGrkT05LH3ewwB
   //0mf+0huXvpRunfyE+6K7MffE/ehMYx3w4/FA409Nb7nRrHOpku+9Vv0
   tdNAmKZ4MgSNefsbXgeBQIvPqT12yHm5aOet03Irj1nDGx8snBiUoKvmJ
   s41wbP6RCmnWQUSzwpNSWX9/WPs4QUQ4e2SuwcYXc8Fy4Sr/UcGzEibrf
   w==;
X-CSE-ConnectionGUID: p9xQbHqgTPqIQ3SX6xMqhQ==
X-CSE-MsgGUID: HEAQ/BpdSGCEWJTv6uBdAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13057388"
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="13057388"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 19:35:30 -0700
X-CSE-ConnectionGUID: apLY+IruSXiZAG76+8FHJw==
X-CSE-MsgGUID: gNJf1qxPRrOQDWJOCD39Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="34940379"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 May 2024 19:35:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 19:35:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 19:35:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 27 May 2024 19:35:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 27 May 2024 19:35:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oULhEenHdG/47V9UKQ58oECTu2qmkHrG3o5NuLVsU+iRkD53kA/9d35exH60QM241VzqXIlD0AopSNumthNF+Smkdhorm63xwGUZLGl9OAdjeiQ3mDi44Zf26Qr9/+pmyRXHIuAniwl7cFBtQ6EGXNI4LfPbZ9bj26+XkxQP6GsP972sr8J10BFRB3VrF4xWbfZqtc3fDXIfZNa1Xnsdz5ANan/o/0t5Qijhfd0jg4IyDPnGAnA1HqtXTj8Z67iXE5AxKW6Bf4NzH94WMbMhp/IP3W0w8pCRwtfETfsYcGuWWW/0zrXo80zxXU3tCrkvLG6D48iK1z2jv2UwrZ2HIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LEnKnTwgbHpLVD34DGV5gILitwFTIKYv0XXO8Bt0AfA=;
 b=Emhl3lp5Qm+c7zPx+FM3m/MYlaPKVInMT2/RXmK8xGQGvvL6ZE+WMAllkMkBWzK7ZOra/ecXu37YGFbjiMI744hTuJLnFvFMYNYYfEilNs7TbfEA0avexw7kvCgw1Bn29KTPRBxZvR/VC9vSIwPo3zsylezzBtgDHcVZtkQWS5lcozRaxYvNiI+c2zAkEqNcaELJsGXBhA3Ecrwgtc3/MmWUuessmnAywr8nRKHVUNcM0esEQIGkOTnmCoFulBixNtNl9X/mNlCRY060CsYIB7w1vMpc90Bhbg7IY5oyNUsoIUU8XwftgKrCy7VgrDoZjRYD1k2hdOxEhkwWK6ggAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17)
 by BL3PR11MB6412.namprd11.prod.outlook.com (2603:10b6:208:3bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.27; Tue, 28 May
 2024 02:35:24 +0000
Received: from BL1PR11MB5368.namprd11.prod.outlook.com
 ([fe80::49e7:97ee:b593:9856]) by BL1PR11MB5368.namprd11.prod.outlook.com
 ([fe80::49e7:97ee:b593:9856%3]) with mapi id 15.20.7611.016; Tue, 28 May 2024
 02:35:24 +0000
From: "Ma, Yongwei" <yongwei.ma@intel.com>
To: Mingwei Zhang <mizhang@google.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, "Zhang, Xiong Y"
	<xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, "Liang,
 Kan" <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
CC: Jim Mattson <jmattson@google.com>, "Eranian, Stephane"
	<eranian@google.com>, Ian Rogers <irogers@google.com>, Namhyung Kim
	<namhyung@kernel.org>, "gce-passthrou-pmu-dev@google.com"
	<gce-passthrou-pmu-dev@google.com>, "Alt, Samantha" <samantha.alt@intel.com>,
	"Lv, Zhiyuan" <zhiyuan.lv@intel.com>, "Xu, Yanfei" <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>
Subject: RE: [PATCH v2 00/54] Mediated Passthrough vPMU 2.0 for x86
Thread-Topic: [PATCH v2 00/54] Mediated Passthrough vPMU 2.0 for x86
Thread-Index: AQHan3aRPwDxi4xjaEGG76w3kTN9UrGsEDEQ
Date: Tue, 28 May 2024 02:35:24 +0000
Message-ID: <BL1PR11MB53685328CBAA3E444370D7AC89F12@BL1PR11MB5368.namprd11.prod.outlook.com>
References: <20240506053020.3911940-1-mizhang@google.com>
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5368:EE_|BL3PR11MB6412:EE_
x-ms-office365-filtering-correlation-id: bcfa811a-44c0-4387-6cb5-08dc7ebed3d6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009|921011;
x-microsoft-antispam-message-info: =?utf-8?B?SDF3TG5aZnc1M0U2OVJjTFNyMmxtQ2gzOXlLVXpJYWNielZoOHZNRWNwZVgz?=
 =?utf-8?B?MnRXOGQxQVBjOFdCNUdXeWlzUGIzWEtlUjVJSW54K29mT1RadncrQXFlT0tm?=
 =?utf-8?B?N0x1SGlId3hZcWtIOVMrZlpwY0t1OS8yN1FWbWY3Zjl5akpzS2h6WGx5UU8x?=
 =?utf-8?B?VTgwQk9vZElvV3FTbnc4ck9XVkExTTY3dnBDR3k0Tk1CNGRZcHlXdXRSSWh1?=
 =?utf-8?B?QlZ4Tk54V3hkUkpmalB5SGd5a3RUemVpRFhZNk51cWRlclFqWlAwRGZCZndF?=
 =?utf-8?B?OVFhcTJUM1JHOXZnZEY5UXMxaWpkK2I1cTg3aWllZHB1dGpDT21VMEhZVU5y?=
 =?utf-8?B?aGhMUmVyTnZ0VENmSDM2eUpuYk1zWW5jWkVFN0cvTzY5cTl4dXhiVFhlUW1k?=
 =?utf-8?B?RE9qbldQZDUyd1k5OFpXblRKTyt6UlhlWGZDVlZweCtRK2pNTE16d1lHMzIx?=
 =?utf-8?B?aGpGM0pBVTR2VnBOa1VqdHNncmlhMWs3RlRBbkIrMjl2ZXVpZUgwWDFYdmhp?=
 =?utf-8?B?Vjg1czJrN1dyZWZra0VJcnpEbmFyMmtjbEpleGk2RFk0bHVzS3JwWDZLWXhi?=
 =?utf-8?B?azh2ZGkvc2d6L0NFVjBialZsdkNUUWNDbWxrTU1WSFlUWmF0TVd3UEZIakJj?=
 =?utf-8?B?OVZhZFpnOC83b3p3SG1xSEJwNTFWNTJMZWl2V2VxNG9sa0ZuSStVckRJS2h6?=
 =?utf-8?B?SHU5bnpVeHpjcWtRdXJiZ3BKQkZoM3R0OUZrcWUxUjRGTmdwQVhsNUlkNkUy?=
 =?utf-8?B?eWFpR25pRG5zeGpEdExvYkhIeVp1aExrQnpob25WZ01kQXB6eW5oTVNwbHJk?=
 =?utf-8?B?TlVCL0JuQlcrZjh4bGZxZHZVTXBOLzBQejEzL3JTenhiTHBxU2Rtc0hFajlF?=
 =?utf-8?B?S3hycTJSUHh2RERNc25SeU92aDJIWXlhUGNWTjZkNFYyOFpsSkRtODNOeCtF?=
 =?utf-8?B?ZytWLzNYY0UvMm9IdTljWXhUbDBwSkp5SENMamtDZUNoSERnTU5yamRKTmxJ?=
 =?utf-8?B?aThqNG5XY2R5Qk93ZXdCYS9hQ2ZlZ3c5Q3JWa0podmZFYnIvK2lFVzZURTZs?=
 =?utf-8?B?Vkl5dHdwL2FjalRKbE9XS0J5V3JWMnhJNGREQkg0b2MxRExHWGk0M3ZNUXVZ?=
 =?utf-8?B?cENrMDE0Zk5XTHVJdnVOMW1xVXh4QmMxOEFvTHBFMDYrY0ZUd1M4R3lieWlW?=
 =?utf-8?B?RXZBanNka3IzWHRmYmtsbUIwVWVzbjBVbUNSMk1PU3dEdFQ3Z203OFVXY2Fa?=
 =?utf-8?B?dnRrV3V1WW96bzFEQmJENkQ5M01ubzl6d3A0c0FMZXhMbzhRWjdLUXZINFBq?=
 =?utf-8?B?aUV0UVN3NlEyVjE0Nkc0bm5IWWJROS8yRDN2ODNwdGtKVDIxMDFwWVlJQ2tG?=
 =?utf-8?B?aWp6aHRwR05RU1J1L2FPM2NtcDdNODJPSzRWSlBPZlV6WEIrMWFqU2JZVkNK?=
 =?utf-8?B?RVN4ankxZ2JndlpMY2ovSTZidW5LMGtJaFExY1VFd3Q4a2Exd3UrbjltUGo3?=
 =?utf-8?B?Sm9RWTVPYXpGbHFhaXJ6VWJvUy90dG5CQy9YVmlYRHREYUVIeHNEUnNrUklJ?=
 =?utf-8?B?UUVQbWRMVXlYQWZnazIzMHJWdytSUU9jSjcwN202bUxoK0YzTU1HUXNNZTBP?=
 =?utf-8?B?MmgrcXVEU0trcXAvVEhQN2JoUjNXVVBYaXlDODNMUFpOYkFEaGt6SUFkZzRR?=
 =?utf-8?B?VythaWtMVnhaRUZOcmVoRzBLYWM0Z3MyRFNXakM5KzNHWGhySEcyTmNpdk4z?=
 =?utf-8?Q?m/5C+RTLZkXwCMJrJY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5368.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjFTVXlLR0JOdCtySHh0WjZidEJ6d0FYVnA2dmdhWHNEOWJ5UVF3bmJ1U012?=
 =?utf-8?B?ODlCUERQRk90OWtKQno0TEtzV3BoUktrNWNEaHArQjJ1di9GL1BjbFRjTjZN?=
 =?utf-8?B?OGRQL0VBcDkreGpvK1AydUI5c0VUQmpFRlpRWE5NUDZzR1JKRnU5bitIRGRh?=
 =?utf-8?B?VkhML2NnTXN0b3FqL1dyMVhjcDRzMWdFRTRkYS9CM1RaWUNWV3VZOVA2Z0ww?=
 =?utf-8?B?TGc1RFFodGFMQVIxN1NHaHBQMDBhNWZDYk52WFRBSFMwaVk0SmZDQW9ZLys5?=
 =?utf-8?B?RUVORlc4OHRoVnJqdUVQdzlKMUlUTTBjNFpBeG5EK0JicVdPVk1Mb3hyZjhK?=
 =?utf-8?B?azdYZmZIQis5a2dDdHB3bzJKa0J6dWRxb01GVzRhK01EYnE4RnNOa0p0RWtZ?=
 =?utf-8?B?NExxM2hNaGdXaW1YMFRMSmo2bDEwM01YdUNrckEvQzVGRXBFWnVPeUFmSG1I?=
 =?utf-8?B?TDgyb2psRzZPL0Nqbjd6ZGhLRHJ4d3pUcXArbWtRTGxHSWk1T0dtSXZtS24r?=
 =?utf-8?B?eVpPVXJDcEVCVktDWmpnY2xNdVVYVVRqMVRhRmtwclFsVW5MdkF0RTVaSFRR?=
 =?utf-8?B?akUvM0RMRUNaNzRPS1hySkVvVmtMZTdFUnc4eDZEQW5EcDRhQUpBNjk2ZVVj?=
 =?utf-8?B?QTFmLzU2WlE3M3VtVGd3R0dwR3BZUGNBd016Qm9BU0l4Tk1BWGhVbmtla0pQ?=
 =?utf-8?B?NEw3M1Q3WjVzZGRaSm01V0JXVHBHYTM4OHZQTHFqS2FrZ0gwMjFjTmFEb2Fu?=
 =?utf-8?B?ejYyNVV1M2xGMUtaS0pYUkJSaU1WRnBlekFhRjd1OXpRckFGVEJscldoOTcz?=
 =?utf-8?B?MzZCTDVzSkM3RU44clIyR0d2OE5OV043QlBhcHRYdXVaQWFUSmdlSVozek5K?=
 =?utf-8?B?SXpmajFaY3lYS1QwU3hpMUFETE90eXg1d1lKa3lXN01hRGZsVGtGWklPTGtJ?=
 =?utf-8?B?UzIrTm1oMXJSS2d5cEl0dDFHUWVQSmdHbEhNLzVGdDBGUlBGOEE5WW1zYUdw?=
 =?utf-8?B?MXU0RzhwSHpUQ2tBMmU0Mmc5MnRwclBwUjVTUEFnNkxRMVhvZE8zNDNJSXYr?=
 =?utf-8?B?amVRbVNsTGFVa29XRUg3dk1YbWhDOXdQTmpDMUZXSmtPL2lQVFJ5WkVpWnFN?=
 =?utf-8?B?dGJwcER1K25XNzVjRXh3MVBtNU1HUEN1VjBMVTRMeUhlanVDdjNhL05SUkli?=
 =?utf-8?B?QUJLcmR1VTRFd3dQaFYwaEF4Uzk1STM3MjNBVDJCcVZ0WjBSQzVGaDVMU0lB?=
 =?utf-8?B?bWxnZytHTy9JQ1dBekNaa0tob1BETk5kOW1GdjlKVUgwZnJpUGludUQyNml2?=
 =?utf-8?B?WEtkeXBCaWtCTHc2Q1F2cmNiQ1dVZXNpZWo3VWgrenBSZmFqMzlwelpKcy9x?=
 =?utf-8?B?eGxVTGYvUm9icjRZU25VSzNJVmlycmJUemhCRTdXT0J3N1VqNVZpRWJHYWk3?=
 =?utf-8?B?WGU2enY4eThsMWZaMmt0bk9aZ2k1cko3TzR6OXFjbXNmRm8xbXZNUnlBeFls?=
 =?utf-8?B?MDNtcU1MbUliTGd1dkVINVNacGJURVBENzA0S1JrTDQyemJ6UnBUQ0dVU0tl?=
 =?utf-8?B?RklBMnBpTTJJZStma3pkZmFkelFXZlhNc3B0cFNIYk00c3VJT1grc0ZSMUFQ?=
 =?utf-8?B?K1c1eTFsL21YbW5PS1ZPdXJjNWQ0R1VYaW9nZnEveStUY3pZUlFWb0RCakll?=
 =?utf-8?B?a3d0WmZLY1lOQ0trTkxuNDBWT3hSTC9lVU1NUjlTb3lCelloaTFCaElOSmRJ?=
 =?utf-8?B?Ukc1WjJ3Q241c0tBeDZxZXdpSEhCVXZza2lMWFc5eEtWNUNDYmp6dDd4VUtE?=
 =?utf-8?B?djRQZmh2dnh6T3pwY01DTE5nNUJZZFp1Z3lxQ0pkc1VvaTl5TWhlbFpUZGxp?=
 =?utf-8?B?ejlqdWd4RTJ1MkM0djJtUkhMZlBSU3d0ajdmd0JXa0pjRFJaTW93bUxqdHRp?=
 =?utf-8?B?R290REpuMjMrMTMvRXVUd2I3S2FqamFPNnBpcFgwTVB4aFBlL0lubE5FZStE?=
 =?utf-8?B?UXlIdWNkMnNPT0t0a3pqeUZHSUcvUFdtOHJENlJmaWJpMmVHbms5RjhlOEJF?=
 =?utf-8?B?RWpIYXJ1bSsrL3lwSTZYemdlODdObDZJaDFBU2wvc1NueXRmZ1BsR2FUMVIy?=
 =?utf-8?Q?tKM/rMYlbSzanOcpE4n/+zb7v?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bcfa811a-44c0-4387-6cb5-08dc7ebed3d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 02:35:24.2438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEFrrsHL1LVARvYguKy0swDVKM4kYss5WUJdHHzM72g9xhFQDSyvXQnQcyF3TTVu6OKQ0wPjmWLEB7j1KYWiZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6412
X-OriginatorOrg: intel.com

PiBJbiB0aGlzIHZlcnNpb24sIHdlIGFkZGVkIHRoZSBtZWRpYXRlZCBwYXNzdGhyb3VnaCB2UE1V
IHN1cHBvcnQgZm9yIEFNRC4NCj4gVGhpcyBpcyAxc3QgdmVyc2lvbiB0aGF0IGNvbWVzIHVwIHdp
dGggYSBmdWxsIHg4NiBzdXBwb3J0IG9uIHRoZSB2UE1VIG5ldw0KPiBkZXNpZ24uDQo+IA0KPiBN
YWpvciBjaGFuZ2VzOg0KPiAgLSBBTUQgc3VwcG9ydCBpbnRlZ3JhdGlvbi4gU3VwcG9ydGluZyBn
dWVzdCBQZXJmTW9uIHYxIGFuZCB2Mi4NCj4gIC0gRW5zdXJlICFleGNsdWRlX2d1ZXN0IGV2ZW50
cyBvbmx5IGV4aXN0IHByaW9yIHRvIG1lZGlhdGUgcGFzc3Rocm91Z2gNCj4gICAgdlBNVSBsb2Fk
ZWQuIFtzZWFuXQ0KPiAgLSBVcGRhdGUgUE1VIE1TUiBpbnRlcmNlcHRpb24gYWNjb3JkaW5nIHRv
IGV4cG9zZWQgY291bnRlcnMgYW5kIHBtdQ0KPiAgICB2ZXJzaW9uLiBbbWluZ3dlaSByZXBvcnRl
ZCBwbXVfY291bnRlcnNfdGVzdCBmYWlsc10NCj4gIC0gRW5mb3JjZSBSRFBNQyBpbnRlcmNlcHRp
b24gdW5sZXNzIGFsbCBjb3VudGVycyBleHBvc2VkIHRvIGd1ZXN0LiBUaGlzDQo+ICAgIHJlbW92
ZXMgYSBoYWNrIGluIFJGQ3YxIHdoZXJlIHdlIHBhc3MgdGhyb3VnaCBSRFBNQyBhbmQgemVybw0K
PiAgICB1bmV4cG9zZWQgY291bnRlcnMuIFtqaW0vc2Vhbl0NCj4gIC0gQ29tYmluZSB0aGUgUE1V
IGNvbnRleHQgc3dpdGNoIGZvciBib3RoIEFNRCBhbmQgSW50ZWwuDQo+ICAtIEJlY2F1c2Ugb2Yg
UkRQTUMgaW50ZXJjZXB0aW9uLCB1cGRhdGUgUE1VIGNvbnRleHQgc3dpdGNoIGNvZGUgYnkNCj4g
ICAgcmVtb3ZpbmcgdGhlICJ6ZXJvaW5nIG91dCIgbG9naWMgd2hlbiByZXN0b3JpbmcgdGhlIGd1
ZXN0IGNvbnRleHQuDQo+ICAgIFtqaW0vc2VhbjogaW50ZXJjZXB0IHJkcG1jXQ0KPiANCj4gTWlu
b3IgY2hhbmdlczoNCj4gIC0gRmxpcCBlbmFibGVfcGFzc3Rocm91Z2hfcG11IHRvIGZhbHNlIGFu
ZCBjaGFuZ2UgdG8gYSB2ZW5kb3IgcGFyYW0uDQo+ICAtIFJlbW92ZSAiSW50ZXJjZXB0IGZ1bGwt
d2lkdGggR1AgY291bnRlciBNU1JzIGJ5IGNoZWNraW5nIHdpdGggcGVyZg0KPiAgICBjYXBhYmls
aXRpZXMiLg0KPiAgLSBSZW1vdmUgdGhlIHdyaXRlIHRvIHBtYyBwYXRjaC4NCj4gIC0gTW92ZSBo
b3N0X3BlcmZfY2FwIGFzIGFuIGluZGVwZW5kZW50IHZhcmlhYmxlLCB3aWxsIHVwZGF0ZSBhZnRl
cg0KPiAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNDA0MjMyMjE1MjEuMjkyMzc1
OS0xLQ0KPiBzZWFuamNAZ29vZ2xlLmNvbS8NCj4gDQo+IFRPRE9zOg0KPiAgLSBTaW1wbGlmeSBl
bmFibGluZyBjb2RlIGZvciBtZWRpYXRlZCBwYXNzdGhyb3VnaCB2UE1VLg0KPiAgLSBGdXJ0aGVy
IG9wdGltaXphdGlvbiBvbiBQTVUgY29udGV4dCBzd2l0Y2guDQo+IA0KPiBPbi1nb2luZyBkaXNj
dXNzaW9uczoNCj4gIC0gRmluYWwgbmFtZSBvZiBtZWRpYXRlZCBwYXNzdGhyb3VnaCB2UE1VLg0K
PiAgLSBQTVUgY29udGV4dCBzd2l0Y2ggb3B0aW1pemF0aW9ucy4NCj4gDQo+IFRlc3Rpbmc6DQo+
ICAtIFRlc3RjYXNlczoNCj4gICAgLSBzZWxmdGVzdDogcG11X2NvdW50ZXJzX3Rlc3QNCj4gICAg
LSBzZWxmdGVzdDogcG11X2V2ZW50X2ZpbHRlcl90ZXN0DQo+ICAgIC0ga3ZtLXVuaXQtdGVzdHM6
IHBtdQ0KPiAgICAtIHFlbXUgYmFzZWQgdWJ1bnR1IDIwLjA0IChndWVzdCBrZXJuZWw6IDUuMTAg
YW5kIDYuNy45KQ0KPiAgLSBQbGF0Zm9ybXM6DQo+ICAgIC0gZ2Vub2ENCj4gICAgLSBza3lsYWtl
DQo+ICAgIC0gaWNlbGFrZQ0KPiAgICAtIHNhcHBoaXJlcmFwaWRzDQo+ICAgIC0gZW1lcmFsZHJh
cGlkcw0KPiANCj4gT25nb2luZyBJc3N1ZXM6DQo+ICAtIEFNRCBwbGF0Zm9ybSBbbWlsYW5dOg0K
PiAgIC0gLi9wbXVfZXZlbnRfZmlsdGVyX3Rlc3QgZXJyb3I6DQo+ICAgICAtIHRlc3RfYW1kX2Rl
bnlfbGlzdDogQnJhbmNoIGluc3RydWN0aW9ucyByZXRpcmVkID0gNDQgKGV4cGVjdGVkIDQyKQ0K
PiAgICAgLSB0ZXN0X3dpdGhvdXRfZmlsdGVyOiBCcmFuY2ggaW5zdHJ1Y3Rpb25zIHJldGlyZWQg
PSA0NCAoZXhwZWN0ZWQgNDIpDQo+ICAgICAtIHRlc3RfbWVtYmVyX2FsbG93X2xpc3Q6IEJyYW5j
aCBpbnN0cnVjdGlvbnMgcmV0aXJlZCA9IDQ0IChleHBlY3RlZCA0MikNCj4gICAgIC0gdGVzdF9u
b3RfbWVtYmVyX2RlbnlfbGlzdDogQnJhbmNoIGluc3RydWN0aW9ucyByZXRpcmVkID0gNDQgKGV4
cGVjdGVkDQo+IDQyKQ0KPiAgLSBJbnRlbCBwbGF0Zm9ybSBbc2t5bGFrZV06DQo+ICAgLSBrdm0t
dW5pdC10ZXN0cy9wbXUgZmFpbHMgd2l0aCB0d28gZXJyb3JzOg0KPiAgICAgLSBGQUlMOiBJbnRl
bDogVFNYIGN5Y2xlczogZ3AgY250ci0zIHdpdGggYSB2YWx1ZSBvZiAwDQo+ICAgICAtIEZBSUw6
IEludGVsOiBmdWxsLXdpZHRoIHdyaXRlczogVFNYIGN5Y2xlczogZ3AgY250ci0zIHdpdGggYSB2
YWx1ZSBvZiAwDQo+IA0KPiBJbnN0YWxsYXRpb24gZ3VpZGFuY2U6DQo+ICAtIGVjaG8gMCA+IC9w
cm9jL3N5cy9rZXJuZWwvbm1pX3dhdGNoZG9nDQo+ICAtIG1vZHByb2JlIGt2bV97YW1kLGludGVs
fSBlbmFibGVfcGFzc3Rocm91Z2hfcG11PVkgMj4vZGV2L251bGwNCj4gDQo+IHYxOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNDAxMjYwODU0NDQuMzI0OTE4LTEtDQo+IHhpb25nLnku
emhhbmdAbGludXguaW50ZWwuY29tLw0KPiANCj4gDQo+IERhcGVuZyBNaSAoMyk6DQo+ICAgeDg2
L21zcjogSW50cm9kdWNlIE1TUl9DT1JFX1BFUkZfR0xPQkFMX1NUQVRVU19TRVQNCj4gICBLVk06
IHg4Ni9wbXU6IEludHJvZHVjZSBtYWNybyBQTVVfQ0FQX1BFUkZfTUVUUklDUw0KPiAgIEtWTTog
eDg2L3BtdTogQWRkIGludGVsX3Bhc3N0aHJvdWdoX3BtdV9tc3JzKCkgdG8gcGFzcy10aHJvdWdo
IFBNVQ0KPiAgICAgTVNScw0KPiANCj4gS2FuIExpYW5nICgzKToNCj4gICBwZXJmOiBTdXBwb3J0
IGdldC9wdXQgcGFzc3Rocm91Z2ggUE1VIGludGVyZmFjZXMNCj4gICBwZXJmOiBBZGQgZ2VuZXJp
YyBleGNsdWRlX2d1ZXN0IHN1cHBvcnQNCj4gICBwZXJmL3g4Ni9pbnRlbDogU3VwcG9ydCBQRVJG
X1BNVV9DQVBfUEFTU1RIUk9VR0hfVlBNVQ0KPiANCj4gTWFuYWxpIFNodWtsYSAoMSk6DQo+ICAg
S1ZNOiB4ODYvcG11L3N2bTogV2lyZSB1cCBQTVUgZmlsdGVyaW5nIGZ1bmN0aW9uYWxpdHkgZm9y
IHBhc3N0aHJvdWdoDQo+ICAgICBQTVUNCj4gDQo+IE1pbmd3ZWkgWmhhbmcgKDI0KToNCj4gICBw
ZXJmOiBjb3JlL3g4NjogRm9yYmlkIFBNSSBoYW5kbGVyIHdoZW4gZ3Vlc3Qgb3duIFBNVQ0KPiAg
IHBlcmY6IGNvcmUveDg2OiBQbHVtYiBwYXNzdGhyb3VnaCBQTVUgY2FwYWJpbGl0eSBmcm9tIHg4
Nl9wbXUgdG8NCj4gICAgIHg4Nl9wbXVfY2FwDQo+ICAgS1ZNOiB4ODYvcG11OiBJbnRyb2R1Y2Ug
ZW5hYmxlX3Bhc3N0aHJvdWdoX3BtdSBtb2R1bGUgcGFyYW1ldGVyDQo+ICAgS1ZNOiB4ODYvcG11
OiBQbHVtYiB0aHJvdWdoIHBhc3MtdGhyb3VnaCBQTVUgdG8gdmNwdSBmb3IgSW50ZWwgQ1BVcw0K
PiAgIEtWTTogeDg2L3BtdTogQWRkIGEgaGVscGVyIHRvIGNoZWNrIGlmIHBhc3N0aHJvdWdoIFBN
VSBpcyBlbmFibGVkDQo+ICAgS1ZNOiB4ODYvcG11OiBBZGQgaG9zdF9wZXJmX2NhcCBhbmQgaW5p
dGlhbGl6ZSBpdCBpbg0KPiAgICAga3ZtX3g4Nl92ZW5kb3JfaW5pdCgpDQo+ICAgS1ZNOiB4ODYv
cG11OiBBbGxvdyBSRFBNQyBwYXNzIHRocm91Z2ggd2hlbiBhbGwgY291bnRlcnMgZXhwb3NlZCB0
bw0KPiAgICAgZ3Vlc3QNCj4gICBLVk06IHg4Ni9wbXU6IEludHJvZHVjZSBQTVUgb3BlcmF0b3Ig
dG8gY2hlY2sgaWYgcmRwbWMgcGFzc3Rocm91Z2gNCj4gICAgIGFsbG93ZWQNCj4gICBLVk06IHg4
Ni9wbXU6IENyZWF0ZSBhIGZ1bmN0aW9uIHByb3RvdHlwZSB0byBkaXNhYmxlIE1TUiBpbnRlcmNl
cHRpb24NCj4gICBLVk06IHg4Ni9wbXU6IEF2b2lkIGxlZ2FjeSB2UE1VIGNvZGUgd2hlbiBhY2Nl
c3NpbmcgZ2xvYmFsX2N0cmwgaW4NCj4gICAgIHBhc3N0aHJvdWdoIHZQTVUNCj4gICBLVk06IHg4
Ni9wbXU6IEV4Y2x1ZGUgUE1VIE1TUnMgaW4gdm14X2dldF9wYXNzdGhyb3VnaF9tc3Jfc2xvdCgp
DQo+ICAgS1ZNOiB4ODYvcG11OiBBZGQgY291bnRlciBNU1IgYW5kIHNlbGVjdG9yIE1TUiBpbmRl
eCBpbnRvIHN0cnVjdA0KPiAgICAga3ZtX3BtYw0KPiAgIEtWTTogeDg2L3BtdTogSW50cm9kdWNl
IFBNVSBvcGVyYXRpb24gcHJvdG90eXBlcyBmb3Igc2F2ZS9yZXN0b3JlIFBNVQ0KPiAgICAgY29u
dGV4dA0KPiAgIEtWTTogeDg2L3BtdTogSW1wbGVtZW50IHRoZSBzYXZlL3Jlc3RvcmUgb2YgUE1V
IHN0YXRlIGZvciBJbnRlbCBDUFUNCj4gICBLVk06IHg4Ni9wbXU6IE1ha2UgY2hlY2tfcG11X2V2
ZW50X2ZpbHRlcigpIGFuIGV4cG9ydGVkIGZ1bmN0aW9uDQo+ICAgS1ZNOiB4ODYvcG11OiBBbGxv
dyB3cml0aW5nIHRvIGV2ZW50IHNlbGVjdG9yIGZvciBHUCBjb3VudGVycyBpZiBldmVudA0KPiAg
ICAgaXMgYWxsb3dlZA0KPiAgIEtWTTogeDg2L3BtdTogQWxsb3cgd3JpdGluZyB0byBmaXhlZCBj
b3VudGVyIHNlbGVjdG9yIGlmIGNvdW50ZXIgaXMNCj4gICAgIGV4cG9zZWQNCj4gICBLVk06IHg4
Ni9wbXU6IEV4Y2x1ZGUgZXhpc3RpbmcgdkxCUiBsb2dpYyBmcm9tIHRoZSBwYXNzdGhyb3VnaCBQ
TVUNCj4gICBLVk06IHg4Ni9wbXU6IEludHJvZHVjZSBQTVUgb3BlcmF0b3IgdG8gaW5jcmVtZW50
IGNvdW50ZXINCj4gICBLVk06IHg4Ni9wbXU6IEludHJvZHVjZSBQTVUgb3BlcmF0b3IgZm9yIHNl
dHRpbmcgY291bnRlciBvdmVyZmxvdw0KPiAgIEtWTTogeDg2L3BtdTogSW1wbGVtZW50IGVtdWxh
dGVkIGNvdW50ZXIgaW5jcmVtZW50IGZvciBwYXNzdGhyb3VnaA0KPiBQTVUNCj4gICBLVk06IHg4
Ni9wbXU6IFVwZGF0ZSBwbWNfe3JlYWQsd3JpdGV9X2NvdW50ZXIoKSB0byBkaXNjb25uZWN0IHBl
cmYgQVBJDQo+ICAgS1ZNOiB4ODYvcG11OiBEaXNjb25uZWN0IGNvdW50ZXIgcmVwcm9ncmFtIGxv
Z2ljIGZyb20gcGFzc3Rocm91Z2ggUE1VDQo+ICAgS1ZNOiBuVk1YOiBBZGQgbmVzdGVkIHZpcnR1
YWxpemF0aW9uIHN1cHBvcnQgZm9yIHBhc3N0aHJvdWdoIFBNVQ0KPiANCj4gU2FuZGlwYW4gRGFz
ICgxMSk6DQo+ICAgS1ZNOiB4ODYvcG11OiBEbyBub3QgbWFzayBMVlRQQyB3aGVuIGhhbmRsaW5n
IGEgUE1JIG9uIEFNRCBwbGF0Zm9ybXMNCj4gICB4ODYvbXNyOiBEZWZpbmUgUGVyZkNudHJHbG9i
YWxTdGF0dXNTZXQgcmVnaXN0ZXINCj4gICBLVk06IHg4Ni9wbXU6IEFsd2F5cyBzZXQgZ2xvYmFs
IGVuYWJsZSBiaXRzIGluIHBhc3N0aHJvdWdoIG1vZGUNCj4gICBwZXJmL3g4Ni9hbWQvY29yZTog
U2V0IHBhc3N0aHJvdWdoIGNhcGFiaWxpdHkgZm9yIGhvc3QNCj4gICBLVk06IHg4Ni9wbXUvc3Zt
OiBTZXQgcGFzc3Rocm91Z2ggY2FwYWJpbGl0eSBmb3IgdmNwdXMNCj4gICBLVk06IHg4Ni9wbXUv
c3ZtOiBTZXQgZW5hYmxlX3Bhc3N0aHJvdWdoX3BtdSBtb2R1bGUgcGFyYW1ldGVyDQo+ICAgS1ZN
OiB4ODYvcG11L3N2bTogQWxsb3cgUkRQTUMgcGFzcyB0aHJvdWdoIHdoZW4gYWxsIGNvdW50ZXJz
IGV4cG9zZWQNCj4gICAgIHRvIGd1ZXN0DQo+ICAgS1ZNOiB4ODYvcG11L3N2bTogSW1wbGVtZW50
IGNhbGxiYWNrIHRvIGRpc2FibGUgTVNSIGludGVyY2VwdGlvbg0KPiAgIEtWTTogeDg2L3BtdS9z
dm06IFNldCBHdWVzdE9ubHkgYml0IGFuZCBjbGVhciBIb3N0T25seSBiaXQgd2hlbiBndWVzdA0K
PiAgICAgd3JpdGUgdG8gZXZlbnQgc2VsZWN0b3JzDQo+ICAgS1ZNOiB4ODYvcG11L3N2bTogQWRk
IHJlZ2lzdGVycyB0byBkaXJlY3QgYWNjZXNzIGxpc3QNCj4gICBLVk06IHg4Ni9wbXUvc3ZtOiBJ
bXBsZW1lbnQgaGFuZGxlcnMgdG8gc2F2ZSBhbmQgcmVzdG9yZSBjb250ZXh0DQo+IA0KPiBTZWFu
IENocmlzdG9waGVyc29uICgyKToNCj4gICBLVk06IHg4Ni9wbXU6IFNldCBlbmFibGUgYml0cyBm
b3IgR1AgY291bnRlcnMgaW4gUEVSRl9HTE9CQUxfQ1RSTCBhdA0KPiAgICAgIlJFU0VUIg0KPiAg
IEtWTTogeDg2OiBTbmFwc2hvdCBpZiBhIHZDUFUncyB2ZW5kb3IgbW9kZWwgaXMgQU1EIHZzLiBJ
bnRlbA0KPiAgICAgY29tcGF0aWJsZQ0KPiANCj4gWGlvbmcgWmhhbmcgKDEwKToNCj4gICBwZXJm
OiBjb3JlL3g4NjogUmVnaXN0ZXIgYSBuZXcgdmVjdG9yIGZvciBLVk0gR1VFU1QgUE1JDQo+ICAg
S1ZNOiB4ODY6IEV4dHJhY3QgeDg2X3NldF9rdm1faXJxX2hhbmRsZXIoKSBmdW5jdGlvbg0KPiAg
IEtWTTogeDg2L3BtdTogUmVnaXN0ZXIgZ3Vlc3QgcG1pIGhhbmRsZXIgZm9yIGVtdWxhdGVkIFBN
VQ0KPiAgIHBlcmY6IHg4NjogQWRkIHg4NiBmdW5jdGlvbiB0byBzd2l0Y2ggUE1JIGhhbmRsZXIN
Cj4gICBLVk06IHg4Ni9wbXU6IE1hbmFnZSBNU1IgaW50ZXJjZXB0aW9uIGZvciBJQTMyX1BFUkZf
R0xPQkFMX0NUUkwNCj4gICBLVk06IHg4Ni9wbXU6IFN3aXRjaCBJQTMyX1BFUkZfR0xPQkFMX0NU
UkwgYXQgVk0gYm91bmRhcnkNCj4gICBLVk06IHg4Ni9wbXU6IFN3aXRjaCBQTUkgaGFuZGxlciBh
dCBLVk0gY29udGV4dCBzd2l0Y2ggYm91bmRhcnkNCj4gICBLVk06IHg4Ni9wbXU6IEdyYWIgeDg2
IGNvcmUgUE1VIGZvciBwYXNzdGhyb3VnaCBQTVUgVk0NCj4gICBLVk06IHg4Ni9wbXU6IENhbGwg
cGVyZl9ndWVzdF9lbnRlcigpIGF0IFBNVSBjb250ZXh0IHN3aXRjaA0KPiAgIEtWTTogeDg2L3Bt
dTogQWRkIHN1cHBvcnQgZm9yIFBNVSBjb250ZXh0IHN3aXRjaCBhdCBWTS1leGl0L2VudGVyDQo+
IA0KPiAgYXJjaC94ODYvZXZlbnRzL2FtZC9jb3JlLmMgICAgICAgICAgICAgICB8ICAgMyArDQo+
ICBhcmNoL3g4Ni9ldmVudHMvY29yZS5jICAgICAgICAgICAgICAgICAgIHwgIDQxICsrKystDQo+
ICBhcmNoL3g4Ni9ldmVudHMvaW50ZWwvY29yZS5jICAgICAgICAgICAgIHwgICA2ICsNCj4gIGFy
Y2gveDg2L2V2ZW50cy9wZXJmX2V2ZW50LmggICAgICAgICAgICAgfCAgIDEgKw0KPiAgYXJjaC94
ODYvaW5jbHVkZS9hc20vaGFyZGlycS5oICAgICAgICAgICB8ICAgMSArDQo+ICBhcmNoL3g4Ni9p
bmNsdWRlL2FzbS9pZHRlbnRyeS5oICAgICAgICAgIHwgICAxICsNCj4gIGFyY2gveDg2L2luY2x1
ZGUvYXNtL2lycS5oICAgICAgICAgICAgICAgfCAgIDIgKy0NCj4gIGFyY2gveDg2L2luY2x1ZGUv
YXNtL2lycV92ZWN0b3JzLmggICAgICAgfCAgIDUgKy0NCj4gIGFyY2gveDg2L2luY2x1ZGUvYXNt
L2t2bS14ODYtcG11LW9wcy5oICAgfCAgIDYgKw0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20va3Zt
X2hvc3QuaCAgICAgICAgICB8ICAxMCArKw0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vbXNyLWlu
ZGV4LmggICAgICAgICB8ICAgMiArDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZXJmX2V2ZW50
LmggICAgICAgIHwgICA0ICsNCj4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL3ZteC5oICAgICAgICAg
ICAgICAgfCAgIDEgKw0KPiAgYXJjaC94ODYva2VybmVsL2lkdC5jICAgICAgICAgICAgICAgICAg
ICB8ICAgMSArDQo+ICBhcmNoL3g4Ni9rZXJuZWwvaXJxLmMgICAgICAgICAgICAgICAgICAgIHwg
IDM2ICsrKystDQo+ICBhcmNoL3g4Ni9rdm0vY3B1aWQuYyAgICAgICAgICAgICAgICAgICAgIHwg
ICA0ICsNCj4gIGFyY2gveDg2L2t2bS9jcHVpZC5oICAgICAgICAgICAgICAgICAgICAgfCAgMTAg
KysNCj4gIGFyY2gveDg2L2t2bS9sYXBpYy5jICAgICAgICAgICAgICAgICAgICAgfCAgIDMgKy0N
Cj4gIGFyY2gveDg2L2t2bS9tbXUvbW11LmMgICAgICAgICAgICAgICAgICAgfCAgIDIgKy0NCj4g
IGFyY2gveDg2L2t2bS9wbXUuYyAgICAgICAgICAgICAgICAgICAgICAgfCAxNjggKysrKysrKysr
KysrKysrKysrLQ0KPiAgYXJjaC94ODYva3ZtL3BtdS5oICAgICAgICAgICAgICAgICAgICAgICB8
ICA0NyArKysrKysNCj4gIGFyY2gveDg2L2t2bS9zdm0vcG11LmMgICAgICAgICAgICAgICAgICAg
fCAxMTIgKysrKysrKysrKysrLQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9zdm0uYyAgICAgICAgICAg
ICAgICAgICB8ICAyMyArKysNCj4gIGFyY2gveDg2L2t2bS9zdm0vc3ZtLmggICAgICAgICAgICAg
ICAgICAgfCAgIDIgKy0NCj4gIGFyY2gveDg2L2t2bS92bXgvY2FwYWJpbGl0aWVzLmggICAgICAg
ICAgfCAgIDEgKw0KPiAgYXJjaC94ODYva3ZtL3ZteC9uZXN0ZWQuYyAgICAgICAgICAgICAgICB8
ICA1MiArKysrKysNCj4gIGFyY2gveDg2L2t2bS92bXgvcG11X2ludGVsLmMgICAgICAgICAgICAg
fCAxOTIgKysrKysrKysrKysrKysrKysrKystLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC92bXguYyAg
ICAgICAgICAgICAgICAgICB8IDE5NyArKysrKysrKysrKysrKysrKysrLS0tLQ0KPiAgYXJjaC94
ODYva3ZtL3ZteC92bXguaCAgICAgICAgICAgICAgICAgICB8ICAgMyArLQ0KPiAgYXJjaC94ODYv
a3ZtL3g4Ni5jICAgICAgICAgICAgICAgICAgICAgICB8ICA0NyArKysrKy0NCj4gIGFyY2gveDg2
L2t2bS94ODYuaCAgICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiAgaW5jbHVkZS9saW51
eC9wZXJmX2V2ZW50LmggICAgICAgICAgICAgICB8ICAxOCArKysNCj4gIGtlcm5lbC9ldmVudHMv
Y29yZS5jICAgICAgICAgICAgICAgICAgICAgfCAxNzYgKysrKysrKysrKysrKysrKysrKysNCj4g
IHRvb2xzL2FyY2gveDg2L2luY2x1ZGUvYXNtL2lycV92ZWN0b3JzLmggfCAgIDMgKy0NCj4gIDM0
IGZpbGVzIGNoYW5nZWQsIDExMjAgaW5zZXJ0aW9ucygrKSwgNjEgZGVsZXRpb25zKC0pDQo+IA0K
PiANCj4gYmFzZS1jb21taXQ6IGZlYzUwZGI3MDMzZWE0Nzg3NzNiMTU5ZTBlMmVmYjEzNTI3MGUz
YjcNCj4gLS0NCj4gMi40NS4wLnJjMS4yMjUuZzJhM2FlODdlN2YtZ29vZw0KPiANCkhpIE1pbmd3
ZWksDQpSZWdhcmRpbmcgdGhlIG9uZ29pbmcgaXNzdWUgeW91IG1lbnRpb25lZCBvbiBJbnRlbCBT
a3lsYWtlIHBsYXRmb3JtLCBJIHRyaWVkIHRvIHJlcHJvZHVjZSBpdCAuSG93ZXZlciwgdGhlc2Ug
dHdvIGNhc2VzIGNvdWxkIFBBU1Mgb24gbXkgU2t5bGFrZSBtYWNoaW5lLiBDb3VsZCB5b3UgZG91
YmxlIGNoZWNrIGl0IHdpdGggdGhlIGxhdGVzdCBrdm0tdW5pdC10ZXN0cyBvciBzaGFyZSBtZSB5
b3VyIFNLTCBDUFUgbW9kZWw/DQoNCkNQVSBtb2RlbCBvbiBteSBTS0wgOg0KCSAnSW50ZWwoUikg
WGVvbihSKSBHb2xkIDYxNDAgQ1BVIEAgMi4zMEdIeicuDQpQYXNzdGhyb3VnaCBQTVUgc3RhdHVz
Og0KCSRjYXQgL3N5cy9tb2R1bGUva3ZtX2ludGVsL3BhcmFtZXRlcnMvZW5hYmxlX3Bhc3N0aHJv
dWdoX3BtdQ0KCSRZDQpLdm0tdW5pdC10ZXN0czoNCglodHRwczovL2dpdGxhYi5jb20va3ZtLXVu
aXQtdGVzdHMva3ZtLXVuaXQtdGVzdHMuZ2l0DQpSZXN1bHQ6DQoJUEFTUzogSW50ZWw6IFRTWCBj
eWNsZXM6IGdwIGNudHItMyB3aXRoIGEgdmFsdWUgb2YgMzcNCglQQVNTOiBJbnRlbDogZnVsbC13
aWR0aCB3cml0ZXM6IFRTWCBjeWNsZXM6IGdwIGNudHItMyB3aXRoIGEgdmFsdWUgb2YgMzYNCg0K
VGVzdGVkLWJ5OiBZb25nd2VpIE1hIDx5b25nd2VpLm1hQGludGVsLmNvbT4NCg0KVGhhbmtzIGFu
ZCBCZXN0IFJlZ2FyZHMsDQpZb25nd2VpIE1hDQo=

