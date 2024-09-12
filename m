Return-Path: <kvm+bounces-26732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23952976D0B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D005B217CA
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE42F1B982F;
	Thu, 12 Sep 2024 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jk2LDje/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C69D1ACDE3;
	Thu, 12 Sep 2024 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153695; cv=fail; b=f12Q4o6BxnQVQy9zSMksj9wGhwAsmq//b5vWHaOMZ3kLj6ucDBepyCqi6ZLfkIJhYJOomwdBHeR02Bk4+UmLTk7CbZ1u+rWU6Rcb+rFh6drDkjEFM5txx/OlO2/eua8Vqx2HTsf0F+D/lXm/FRC9Ru1V8owzMuXZrwL18CjXvlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153695; c=relaxed/simple;
	bh=PmFqFW/JxxTmx5Z/CBpg8f7a8Y00p3B6rVqVqywee0k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qh+t7wC/rvK1SQzaP1JnjCExJib4TCxz5pm7dgXC/jkpf9qxHfSpWRX8fRac6L+AVmGslbjalTpf592jjf/jU+oEm7VDZxsZfLhEIi6C+BoInV8WttnM52mzakVl9xoJ6KOIOPSEhesk4pof252m15XroALGT1ATldD74Ypfwmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jk2LDje/; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726153693; x=1757689693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PmFqFW/JxxTmx5Z/CBpg8f7a8Y00p3B6rVqVqywee0k=;
  b=Jk2LDje/GwKboR78w8Qc623IMEf3sL+LO/uUwrDLIMoIab4X3tdA6xU7
   kGfnVQlbdPpuZPygz0nIn7V4S0sE1RNXdUZJFaLPz0m8F6i8P7R95H494
   Zpj8TxjgEaStSmIOzFdwNnaqM4DhAwcIdpmhJiszDUGyXlu416WnG4cao
   ROcW5cXW8uhbI+tAT/O6E5jsfITjgs2ukpM60sZK3A4S8ygABdKP3FrDa
   zyNTZW3kYC/JHsiGVU7E3H4+Azke+KLyTpVunopSx0Xyc7B3ZWR0l3paH
   kbcI1ow2LYMCxU6W1nGxBguxni9oZrR09jSxkiRL86yuDiGplVhk+zNOA
   Q==;
X-CSE-ConnectionGUID: jfhZVvlRRbar8Wj5TVQerg==
X-CSE-MsgGUID: 0/G42TuLSVm1B+G8x2s9Bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="35606772"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="35606772"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 08:07:59 -0700
X-CSE-ConnectionGUID: QAHDoyOIQrisp6TGpHCoOA==
X-CSE-MsgGUID: c0C1QSU9TJW+kxUUIzLWIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="67575747"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 08:07:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 08:07:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 08:07:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 08:07:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 08:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+q8VXZHCBfHV4wX275Mvjf4MTtioo3mOGgXpxt6gW5bzXb9k64K5z9jnUJMdgm6P9Zp38EgGqt5YhZePTiKRjxel1EGs9kwUm9PfWfYGHyvOFoY/vDlWoJvSR3w5VRU6CuB2UJN2wu6S3Xob4bAJZvjgjbYbDkLKxISujAHPTicWMuqzQs3mMhqy2EHqv+rEH8e5Tq7owqfVPl+a5rLeYaOzXVHnk79JfLjrfpXtZ7JQjnTHQhnsta02mjgN9FFyQZS5pXlM/OEVMehRqonG2jor0B6uSeHJQVaIqWYhGTobcENDhE7amm/UOHELCHNcO7iOKiRuHeYY9RF9k8FUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmFqFW/JxxTmx5Z/CBpg8f7a8Y00p3B6rVqVqywee0k=;
 b=NacSOAqrqqC7pALbzpm+kzTMvLzFo7I795gUsWAHaychxGDFCS6KO/YBWKyXPqUbUKyii9+02xWSAp8+vrpkzTIQJhzIk5NXfVLxZUgfU2rpIqVkE7cOCOpO76pbL6LDXolTz/IBeqGpZdtONbO0dPr50X3OqrtHY82NpUnALVdHIB5gk5UwA0jRkt5b0zriZCfRJzg1a2c0/YMDvEGeyqHye1jA3T2ZQuzd+iTkwHb5O/z9C/GK/5Ev/m6N1IZa9xixOjQfevEuXwaZ1X6B6Y/tTeDQJraf8x8XjrAWknodRj7gSPXDNzloIPmsWtcqBA5nyjfwGvR7XVVtHOYO4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5880.namprd11.prod.outlook.com (2603:10b6:510:143::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Thu, 12 Sep
 2024 15:07:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Thu, 12 Sep 2024
 15:07:39 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Topic: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Index: AQHa7QnThnZIMHm/AkW0hgwbYo+0yrJRemKAgAJ7zwCAAGp1gIAAEEkA
Date: Thu, 12 Sep 2024 15:07:39 +0000
Message-ID: <c2b1da5ac7641b1c9ff80dc288f0420e7aa43950.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
	 <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
	 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
	 <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
In-Reply-To: <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5880:EE_
x-ms-office365-filtering-correlation-id: 03d0593e-e044-4515-7824-08dcd33ca499
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?THR0UXphcFY4Q2tmWUxydis1Q3c5QW1YdlU2Z0xsQVdWZWx4RFZQZFNGUHcw?=
 =?utf-8?B?R1lDM3RvbjB0SVQyYXF4d1QyeWdQK2kyajBYN2hZTFI3MUUwN2pTT0E2Y1d0?=
 =?utf-8?B?UnJRSjlSaDNDT2lzVzF4NWIrY0dkSTBkcDU2d1VWN1c3NW1XSUt4cEZJa0d6?=
 =?utf-8?B?VGlEU0tmbmJOUGVxMzlwbjZQN0YyazA2OEJLMWhCV2NDWVVja3JEaU52dXhj?=
 =?utf-8?B?bHRRUW54MXVqamVFZUc2eUkyK2FCYzRmaVhuVURNWGh0SlpubmlUM2srUXFG?=
 =?utf-8?B?bEMwYkZ6QURBd1pMU1J5UjFjMkttanFORU1aK3BVQUhQOG13WlFad055Rko4?=
 =?utf-8?B?bjdWcDE2bHhCaGozNE1QWXN2QXNyNnNwU0NzTm53MTRGYXVPT0h3REF2NTVQ?=
 =?utf-8?B?OUFIRFJQd0gvQlMzU2xtM2ZLR2p5dEZDVkt0aC94Qmo2RFpWbTRCOHFXTkFu?=
 =?utf-8?B?TlpmNXBDZGJvYUpvd1pLRGVCNS8weFZqajdFci9rcS9wNTBFNUx1MW9sUkdY?=
 =?utf-8?B?Q2F0NlJraGRpZjBuelByRnJaUStYWTJJK0YyWFRMcXpDZS9FRktUOTJCVHl5?=
 =?utf-8?B?dkxZTGUwSHNTbkZHTkd0WnZKTDl1ZmJMV3pIZXg1eTM4NEFMOHB3bjIzNTJD?=
 =?utf-8?B?RjkvV05JWi9xNnlmK3ZuUEw3Vyt0OExsYlU1YnhodVJXcVcybjBKVmhLa3g4?=
 =?utf-8?B?OWptWGRoR3lWeGl4cDBZcjlRTEJ5RHViVFFYUUlqZS92NHROUTdnNDloeTBR?=
 =?utf-8?B?Q2tkNHVYcmtkTC9qUEh2TkM2MHlCTXYvdmRsSURFOElNQXliM0pYVVBqeFQx?=
 =?utf-8?B?K1RzbjNTS2hXczlET21oaWxIb3JGWVQvcGVySWw0MGR4SW83WG9LU05yajBp?=
 =?utf-8?B?OGcveGRyajg2S3ZOelBFSkl0SDd2UkVyWGtIK1BwMFhpeDVxeUl3Mk9lZWor?=
 =?utf-8?B?UVVFVFRSMTZQSFFyUW0zU013cnhndVNQTDQvZk45VnJyNG52VmloT3Fid2d2?=
 =?utf-8?B?ekR1NEZQakw4eXh6Y1JaWkxPc2ExdTNRWHN2STJLOERBNDlCRERaeDhXZEVr?=
 =?utf-8?B?SlExYUllcUFlV0s1NGtWd3U3NEFFRUZSbGtnMksrSDhvS3J4TDUyOGVBYkhY?=
 =?utf-8?B?bFB3a3BCTlVqOTZPQ1BOM2FLVkpVa0Z5UnVDVXg3bk1vVDEwODdRaFdYWk8r?=
 =?utf-8?B?UnNkc2VtNlBiVXNoT1FlVUpEYVh2enJ4TXdlVWVPQ1RFVmhacmduOCttMi9l?=
 =?utf-8?B?NjRiRjcxdUN5YnRCekZFdkFBMEd4Uno2RVh0ZUZGY083V2J4T04zYWFGY0ZN?=
 =?utf-8?B?bUNWMzk2NlFkYjJ0MUhia3BwMlJScE1URkR1ZC84WWdyTkNwQjRtamFYTTlF?=
 =?utf-8?B?eW1yb3BvWE1ISVNkWEd5Smc2OW9PTjlXQzlHWnNQbXlKU0lQdXFHeEhJaW1p?=
 =?utf-8?B?amxNV3orV29mMkNFbXRNV1Z6Q21KU2hmSTQyc1JmeG1TVmtsc1FacUkzMFYy?=
 =?utf-8?B?bjJDQWUxT0J5VGVrNWNQK2Zvc3FlNlljTFExWlRKMjBTa0JNa1M5U3dTWWx0?=
 =?utf-8?B?SlhUS1BPZk9RcWVER25ZVTdTUk40cGpLMWxRT3UrVXJPM1NrZ1Y5eHlEcUZw?=
 =?utf-8?B?WWRZSnZUdzFidVpZV1lrdlJtdDhxYThZWmtsWTlDYUw1R1A0dzM5WGRqVE9r?=
 =?utf-8?B?aFZsRGFyTXViTU5vbEtDSk1rNUFudmNpUlBCWHJJL0lvbk1CQjNGcUNHS0x4?=
 =?utf-8?B?OXZmYkcxaVc3b3M2WkNVL1pEUUtSOXRqMis2aldyMjNsaG1UQmljNmhkLzhW?=
 =?utf-8?B?SnMyVEpCL3RYVDMwMk94ejA1V0FMY1JmZDlBSzRFOTdGUHA2cU82ZzZxK01x?=
 =?utf-8?B?dk5TZkZ1V291YncvaTQ2c2o1ZWRXZi9ZK0ExVmowRjNyYlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aG1VY0YxWmRwODJrTldFV1BCYWdtTWw5TG9oVkRyRUExeUI1S1hMWWpnUldP?=
 =?utf-8?B?M0ZWbmNsUXZ4bDNBeTFIZTBqYzdiVkJGNlZrbVlwaVNiTHA0ZmU4L1BtenYx?=
 =?utf-8?B?dEpBd3dIRTdINzIwdSs3UzlwMk1yNnJ0RENBelY4MzBZQVp0UXhIZFJiN0E3?=
 =?utf-8?B?MnhvanZDM29yV25Kb0FEOEVRNXpCQXdrVDV6ZGEzZ29DVEkzeER2QkhKVldX?=
 =?utf-8?B?Y25SRktmTlFYN0MyV2Qwb1QrYncyRk5SUUF0eDAvQW9lc0o5VjlHMWhqNzZO?=
 =?utf-8?B?a1Q1dVlTeUZvWE1xMHIwbjRLb242MkJ4b0wya0E3T0EyeGs5bjZoaGYvbkFN?=
 =?utf-8?B?S1ZzK0hmSlFYTFd4Ri9kVFN4eU9MWVQzQWd5YTBDK1dzZG90MnVERU94cjl2?=
 =?utf-8?B?K09PVHVnV29sMmVNaUUxRjg5c3lGdFBlYXlFZ1RQVkhoTkpwbWVRTjJGVUpD?=
 =?utf-8?B?ZlVsUm0yL3hDTS9oZEpmQ2xBZ05GVHV1SFJvZ0RwcXhMc0hWWG8xSUpQOEhQ?=
 =?utf-8?B?V1kzaEJlQkNwTWFRdkNSelNVaGhqemNuL1JXY1BlRW15ajZvWENwREZTVExL?=
 =?utf-8?B?cEJWR2FIcFZxb2NQdEcrY3dPQlE1eU9uNGxyaElEVFRTdHJieFI0STFFRFZl?=
 =?utf-8?B?S3ZWc1hiMERSN1RlZlhhTjVvOW00b3NDV1hFRWJjVU1Oem1Ob3UwU2JRUFlV?=
 =?utf-8?B?bC9zWUdpazBPTkdCdE1rQ0lzQjNyWVJxMEpzSWYwZFNZR3BGelZ0RXIyZmFh?=
 =?utf-8?B?RHRSUDRhRWdsY251MDZLMGE3dnhtaERlRE5ldk1pVkN2VGY3UzI1NU1NODhi?=
 =?utf-8?B?YW9qRGl0cXdTd3ZWdmZvMTNsRDBJRDZBYkZmV2RjcjBOVjFTWW1LSEhRdW5K?=
 =?utf-8?B?MkxBazNBRGE1VmFlaEhaTHpRdDRsUFpPYkxEMU9LV0NTOVNkbUplQjh0RWU4?=
 =?utf-8?B?dEJsUHY1RnM3YXFSdjZTTGJTNGlVVTFQbE1uVThjRER4N0d0VlgwKzRRZkEr?=
 =?utf-8?B?VU1zaURsakNWbWlnWHdwenRCVGlwWjc4eU9XV25sdjRCbHV0UmhpbjZwdWhB?=
 =?utf-8?B?b0dwMVJDNHZsMng4eCtSU2FPM2RjSGZKUDhPdjZ6cFhLYUpqVEl0c0ExZDY2?=
 =?utf-8?B?OUNnWnRYSHgrQk1rQ1JVLzdNZGpzNlA4RWpXYUs1QlZwZ3h5U0JZOWM2M29u?=
 =?utf-8?B?NDNNK2ExUXFCd1UxU0luYkpxcnJQVlErdlBQZEpjRm84U3ZCcjdiMGIvQk5j?=
 =?utf-8?B?RzhSTUJiVWlpRGc5WUpyNmkrNDlhUTUvMkRpSHRsTVdXUWVueHVBNGZCNjI3?=
 =?utf-8?B?SEU1UVlPYW1oSjFGOTZYVUtuM0RQcG1Ub0VCT293VkliOUwwOHVCZ2pxYXh0?=
 =?utf-8?B?QjgwUHkxZ1Y1L0kybWlHZlNQc2xLZ3dBSkhNbndWSGRpMGdTMUxiL1RMQjVq?=
 =?utf-8?B?UVFjSm9UNmlVaHZXeWd5MHlCSERwNFJzQ3lkV1hiRVRqcHFmZUtHVFZENXh6?=
 =?utf-8?B?R2REZGYvOGNoemwwS1VRM0Y5ZUcrTmlWd2l2N1FHK3pRR1ViQTZjMnRndkVR?=
 =?utf-8?B?UHV2UWp5YXNzOEhnSG1KdS94Y0cxaFpWL2NyKzkyWmQxRzJWV2pMdGZTRTNj?=
 =?utf-8?B?UEgwTXNWbE1NTm5PYk54ZlJraTBPczV4L08yL1BMdm9ucDNLUjdsdklWWjZz?=
 =?utf-8?B?bk9qOXczRG14OTdRdzljM3JMMnVNM1c4dVh2K3BxUFVhRnRqMnc3Z0o4SEkv?=
 =?utf-8?B?WDVETW55TFF2SmYxbEFkUGVuRldwZkM4dFlRUjNXTk9XTVZJdkcwTHptdlNz?=
 =?utf-8?B?QUdjL0szMzg3a2xseHluM0xJaWRVcDBzZGtrS0EvMDBGcFVyNUxXZ3kvTmhp?=
 =?utf-8?B?OGxDT3h2czRCRTdvRkN2Z29OQmVnSjFwN1hveFlCZ3RRVjlwM29wK3VtUmtx?=
 =?utf-8?B?aDllNHpqYzlIU0ZlMUI1ZDRaamR0Zk9CMWlZdVBkQjl1MmRlNkw2UC9WRUgx?=
 =?utf-8?B?VkZ3bUdPbUkvVlFaYWJCcnZJZkdjWW1iL2R3ZU8rcUlBQklCNjdLSUc0T3d5?=
 =?utf-8?B?TzBlRmxJWWpRaFdISFNlNUxNVWZacmM2aFk0Ky9UU01MeHdYbHkxU2RObFhR?=
 =?utf-8?B?NW80ckRKU2k1eGQvRGorNU5zd1JqbEx6cnpsYXJzaXFsN2xPaFVBRnNXSzVF?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EE031EB85251E4EAFA51C2D8C72C39C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d0593e-e044-4515-7824-08dcd33ca499
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 15:07:39.2734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: duj/g7JAKtp/s1sQ3Xys5YQi2t2SCRGsB1iKqQAf7IUYyzTsuocRzYKH8r6bftZ7jO629eHiPgOI6r87fct5bDmrPQ/0wCLw14XrmjLGAaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5880
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDE2OjA5ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiANCj4gPiBUaGUgcHJvYmxlbSBpcywgVERYIG1vZHVsZSBhbmQgdGhlIGhhcmR3YXJlIGFsbG93
IHRoZXNlIGJpdHMgYmUNCj4gPiBjb25maWd1cmVkIGZvciBURCBndWVzdCwgYnV0IEtWTSBkb2Vz
bid0IGFsbG93LiBJdCBsZWFkcyB0byB1c2VycyBjYW5ub3QNCj4gPiBjcmVhdGUgYSBURCB3aXRo
IHRoZXNlIGJpdHMgb24uDQo+IA0KPiBLVk0gaXMgbm90IGdvaW5nIHRvIGhhdmUgYW55IGNoZWNr
cywgaXQncyBvbmx5IGdvaW5nIHRvIHBhc3MgdGhlDQo+IENQVUlEIHRvIHRoZSBURFggbW9kdWxl
IGFuZCByZXR1cm4gYW4gZXJyb3IgaWYgdGhlIGNoZWNrIGZhaWxzDQo+IGluIHRoZSBURFggbW9k
dWxlLg0KDQpPay4gDQoNCj4gDQo+IEtWTSBjYW4gaGF2ZSBhIFREWC1zcGVjaWZpYyB2ZXJzaW9u
IG9mIEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlELCBzbw0KPiB0aGF0IHdlIGNhbiBrZWVwIGEgdmFy
aWFudCBvZiB0aGUgImdldCBzdXBwb3J0ZWQgYml0cyBhbmQgcGFzcyB0aGVtDQo+IHRvIEtWTV9T
RVRfQ1BVSUQyIiBsb2dpYywgYnV0IHRoYXQncyBpdC4NCg0KQ2FuIHlvdSBjbGFyaWZ5IHdoYXQg
eW91IG1lYW4gaGVyZSB3aGVuIHlvdSBzYXkgVERYLXNwZWNpZmljIHZlcnNpb24gb2YNCktWTV9H
RVRfU1VQUE9SVEVEX0NQVUlEPw0KDQpXZSBoYXZlIHR3byB0aGluZ3Mga2luZCBvZiBsaWtlIHRo
YXQgaW1wbGVtZW50ZWQgaW4gdGhpcyBzZXJpZXM6DQoxLiBLVk1fVERYX0dFVF9DUFVJRCwgd2hp
Y2ggcmV0dXJucyB0aGUgQ1BVSUQgYml0cyBhY3R1YWxseSBzZXQgaW4gdGhlIFREDQoyLiBLVk1f
VERYX0NBUEFCSUxJVElFUywgd2hpY2ggcmV0dXJucyBDUFVJRCBiaXRzIHRoYXQgVERYIG1vZHVs
ZSBhbGxvd3MgZnVsbA0KY29udHJvbCBvdmVyIChpLmUuIHdoYXQgd2UgaGF2ZSBiZWVuIGNhbGxp
bmcgZGlyZWN0bHkgY29uZmlndXJhYmxlIENQVUlEIGJpdHMpDQoNCktWTV9URFhfR0VUX0NQVUlE
LT5LVk1fU0VUX0NQVUlEMiBraW5kIG9mIHdvcmtzIGxpa2UNCktWTV9HRVRfU1VQUE9SVEVEX0NQ
VUlELT5LVk1fU0VUX0NQVUlEMiwgc28gSSB0aGluayB0aGF0IGlzIHdoYXQgeW91IG1lYW4sIGJ1
dA0KanVzdCB3YW50IHRvIGNvbmZpcm0uDQoNCldlIGNhbid0IGdldCB0aGUgbmVlZGVkIGluZm9y
bWF0aW9uIChmaXhlZCBiaXRzLCBldGMpIHRvIGNyZWF0ZSBhIFREWA0KS1ZNX0dFVF9TVVBQT1JU
RURfQ1BVSUQgdG9kYXkgZnJvbSB0aGUgVERYIG1vZHVsZSwgc28gd2Ugd291bGQgaGF2ZSB0byBl
bmNvZGUgaXQNCmludG8gS1ZNLiBUaGlzIHdhcyBOQUtlZCBieSBTZWFuIGF0IHNvbWUgcG9pbnQu
IFdlIGhhdmUgc3RhcnRlZCBsb29raW5nIGludG8NCmV4cG9zaW5nIHRoZSBuZWVkZWQgaW5mbyBp
biB0aGUgVERYIG1vZHVsZSwgYnV0IGl0IGlzIGp1c3Qgc3RhcnRpbmcuDQo=

