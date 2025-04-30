Return-Path: <kvm+bounces-44962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F28EAA53AA
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 669549C5B94
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B76A26982E;
	Wed, 30 Apr 2025 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YbBw9Av5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDEF265CC8;
	Wed, 30 Apr 2025 18:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746037809; cv=fail; b=lgENccFvpAfFr/2uAtOupeGTU20eXJU7exTCkrjEfhBJdINJEvdwmD0Png1NiEREnVLAiHio5nc/plyGVLvYb9gwol709NQi3bEj26+LSDDqGUbd1OsAWpBs8F1P5QDj+ZpVBFgFGTKPU6IMuelbLi9lPF5obDlygUxkuiuxuA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746037809; c=relaxed/simple;
	bh=ryz7I08ypM0pLFXCZlf4vaucGNydyJLc8w7C+OTSYDk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J9Q3e6v9WUoFa6qVJ56Z3rBVk9up9gJRBH4p1IfamQ9Zh3RTJiktZlDRnrnF7VdA/Zf6wIf0g2sI3dmYmKpvgEzDQs9nuUArMDVUcABe5A+3IMYFbPWnEbnuE6LR9y3MBmMSfCEmzd030w7zrOvMNwGqSyn8SfSLv1knWynHoEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YbBw9Av5; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746037807; x=1777573807;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ryz7I08ypM0pLFXCZlf4vaucGNydyJLc8w7C+OTSYDk=;
  b=YbBw9Av5HhEuz1RWVLjDrLZEBVwhQW7OmiGjrkT5ocgKbBcZOk/1edjt
   IVSlErIOcYCUi1l7olpuhug/y+eJwaK9zIE0PBBARjqIzEXKyp/PRy40c
   s+1G6idvg+VhAV6RoWCSV2FKS0DERu+XCwm52oLueAmpWogziiVdb0AF+
   E+yvGSOLgus9voxGQS6zwrM3QevcRhTn1MdSMXV1D+1iGCyBGpSdflQtW
   d4BTEA9iUs95RpN/RMhCrI6qA6ZW94lj/HzEtDLHboYzGufcMAfvaXZb6
   D0WZ33Vg3LqsqSloCwvPCQrqDdKbsjJNcIBLGkly58vn4kvRCPu6pAWoC
   w==;
X-CSE-ConnectionGUID: Z5pnIaEfSF+4zx9/nnVF0w==
X-CSE-MsgGUID: OhIrgbHXRUG7CpJWCRkykg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="70214543"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="70214543"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 11:30:06 -0700
X-CSE-ConnectionGUID: LVsUMvbMSzGw/tmdvFo8MQ==
X-CSE-MsgGUID: 2BySYgwfSTyHZZNDa/d/Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138210178"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 11:30:06 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 11:30:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 11:30:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 11:30:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4FxQG6KGuzV3/KJU7Yeu0oWY7qGWSY5/A44ljhrPc2S+NlgJEWAU46egWzkRL+8QiX9bfvTeoxTVWTvfpHSeBVHVwZBBfx31Anind+VjsHAzQlsl8Luf7zXGdsn75nd3Ow26qkNR5KEpVOG1LnSBD43hy/2WTkPRE0GvzWOS/i/CT7GyqIDKFUyJ6OO2pvDFi0Vk03SPkJ6SmXApAuczuQnQglRpmUlg6nT0sXIByf60GgUXvGrea2jSJ9kuecc7WfJsi96h6KySiIzU7eDJAgcng0T1jLTiPGfI7gQteVmSApAtEUOzCSXQvWRuLSgrkt8Rk9cLxHk80QNenOWJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryz7I08ypM0pLFXCZlf4vaucGNydyJLc8w7C+OTSYDk=;
 b=MrA86+nEbIi+3Q0StobarQgY2MXivvvkz5/D1rFs3EeN98d7768ZCqRl7pIq9pKKhOyi1vYZsaGBjhvCiI02m4dsnRbJ1gio+ZrdPGKJcgQTfG5ts0oyOLnxzCvf5fLtTgiOZYjAQ9z/dk8SGPdrMC6p/77ZPVDVgAmIHieZlL/amgnC5N2yh/5CrNvP58WKl7uzaZtrahqYXOnULBRVTIUnUVOxjkhOjR4l85yqwTH2zQFvU6HprCOgCCdZKHqvSATtDTFq+yUKNN1kvi3dwRRGRJtdlxxk3iLo4rpjefgdShWdXu3rbcYAlDsGuBypQegcKgId+aPqjtHhcOkggA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4532.namprd11.prod.outlook.com (2603:10b6:5:2aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 18:29:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8699.019; Wed, 30 Apr 2025
 18:29:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "Li, Xin3"
	<xin3.li@intel.com>, "ebiggers@google.com" <ebiggers@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"john.allen@amd.com" <john.allen@amd.com>, "Bae, Chang Seok"
	<chang.seok.bae@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "Spassov, Stanislav" <stanspas@amazon.de>
Subject: Re: [PATCH v5 5/7] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
Thread-Topic: [PATCH v5 5/7] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
Thread-Index: AQHbqelh9BAKbHkAUkOuAzzHHcyXxrO8p+kA
Date: Wed, 30 Apr 2025 18:29:55 +0000
Message-ID: <9ca17e1169805f35168eb722734fbf3579187886.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-6-chao.gao@intel.com>
In-Reply-To: <20250410072605.2358393-6-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4532:EE_
x-ms-office365-filtering-correlation-id: 20ab938b-4fb9-41f9-bc6b-08dd88150156
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?czZzRXo0dVc5QTZwc0lPS0FTT2lFWkNXQlVpSmswd3BxNHNsc1F1bG9abEk4?=
 =?utf-8?B?ZE8wbGt5anI5QmJMWmQzVFpUTGZueC9zKzZ3M3JBeDJLTytGbHk3bTNjOE12?=
 =?utf-8?B?UWg5VEJIVmZINjVtQm0veElpN0ZWK2JBMVkzdUhvekxGKzJDVlVLM0Z3Wlh1?=
 =?utf-8?B?VGh3QnJ5Ui9pRG5Ea0U4Q29uRGxHSnZxVzNkeFNaaGgyTWNtQzFzaksxWjhS?=
 =?utf-8?B?SHhQanhNamxoUFcwNTVpbGhNL2ZJNTBEcC9OMHRXT2J6OUdSUXJOR2Y5bkQ0?=
 =?utf-8?B?TGxqNm9jVExlSmdHZWplbHRBQmQ2K3VreVV0OU9CNDFhaFJuaWZLejZ1dkJs?=
 =?utf-8?B?NXJ1NkUzZUR3U2JlbzB0MjhqN2I4Q2hRVlRxcVRteFNHbVI3OFFJRVVlSStC?=
 =?utf-8?B?Ync2K0h3R0FDYWJIYVNaYS9MS3g0M1k5bVkxdTJ4dDNsMHMzWG9iNXAwQWpG?=
 =?utf-8?B?LzViZkE1WE4rUm1lT0xDOUFoQ2hnWWV3VEJsSFdieitub3JBUGlza28wV2Qy?=
 =?utf-8?B?N1E4TzJIYnpkZVFBenAzVXM1MGc3bVRmUi8zZ29pdEsxN3BpM0dFNTVCQ1Bl?=
 =?utf-8?B?SUdCQ012YVZTVG5vb2cyZ3NlYThuYTZ5ZnhTUmsrRUNaM3lOOE5ObzNHaXcz?=
 =?utf-8?B?bi9nNjREaUlhU1dHWGJwZi9rQnNCZ3FVamtLUVJCQWxCRkhmN1JMTjczTzdH?=
 =?utf-8?B?VHkxb09JQUZ4VE9OVVZ0K2lhL3hrWGp6Ym4wdUc2aDFiRUl4MXBmaTBUK0dW?=
 =?utf-8?B?dGRhS0c5dVluVXVmd1lHZ1F1dGRTd0tFMEF2dXp5bFJGMklmT3BkTXBtL2RO?=
 =?utf-8?B?SjU2enR3ZWMxRTQ2MWZjMkhNVnVsMWxmZG1UUEJWSFczWTI4UGlFOUhaQ1VS?=
 =?utf-8?B?UmJvMTBwNlRIdmRZYytOS3l5RTM4Zi9qMFNaMS8yejhTK3ExTEZab0JLNkRS?=
 =?utf-8?B?WDdOejFRRE5NZkRUZkdVT2c5MzRKSlQzTUI4OVhXcTlsYkRiWEVJeUM0QVp4?=
 =?utf-8?B?R3lBeGwzRWRrVnRZc0lMRnZqV09JZTI3U2RyTzNRK21Rdll4SDVqNTZHWklT?=
 =?utf-8?B?K3duU2cvQk85c0dIdXZFWks1ZFJlR3hQUEl6b2NvRVRZN3B4UXlSak1wOFFa?=
 =?utf-8?B?WXQxQ2xxUjB4VzRsV204SmVZLzZWZElCeFFIUkE5bmlRTnRURlhWNGd0ZFpY?=
 =?utf-8?B?b3dzbEMvVG1vMHVIWW1iY0RTSHB4ZXdEdDBIUlp2bTVMLyt3OW9yUHZheE44?=
 =?utf-8?B?VEpab0kyd2FlamhHcDdaRkdzdWRyQlpLMkNmLzc5UTRqUlZEU0hlNHUwc3ow?=
 =?utf-8?B?MkV3VEZCQ214K2h5eS8zME01MWR0QUNWeVlkNjNwNkNPb1k4OEF0TFBsVGNa?=
 =?utf-8?B?M2o4ajFISUY1bDBxZ0Rrd0tabk5NdnlPMXhSNnBsTnhzTTlQdWlUbCszUGV4?=
 =?utf-8?B?STVIVndMb0tqaHNDeStNenV6OEYxK2t4dENIWnFBek9pVE9PbnkxSE5mOWJq?=
 =?utf-8?B?VzBZZXMyRFJ3aHllZllhVSt0NlJvWTdyd2RRNXFoeTU4eFJFNmRBWS95eHNo?=
 =?utf-8?B?cVViYUt0aGU3Q1QrSmltdTl2OVU5UGtsT2RyWVpFdnNKSktxazlMUjdqa1FM?=
 =?utf-8?B?aHB5d08xRXZrUUF0Z2gyNERKVENBTlpFK25jdXFTanRpNHIxSkd0cEpDVGF0?=
 =?utf-8?B?Y1YwRkh6Q0lVb3lCNFBiQXNJN1FZc3kyekxIZGZmWGU3a1grV0xPa3pkL2ZV?=
 =?utf-8?B?NHJvdFFCVEQ3cjF6YXIrb2NWdkZNWkVoSlZ1OGF2dUlaVWVFVC9ESDRSbVVk?=
 =?utf-8?B?bUlNcmo4NTUxeHdiTzRzVkYxZDR1djRwcDlFQVR1QzA0T0k5REpLMVdoU0dk?=
 =?utf-8?B?NE9CWTBWVWgxVnZhVkZlZW9xeDByMWgreHNzNGQrTFEvOWREQzJvV0hRZDVF?=
 =?utf-8?B?bkVPZTNkN1Nka1pyWmRKVGZxVGlVdFBHN1p3bHpNdHFBNzMzUGJVRExpRGly?=
 =?utf-8?Q?iDN0sAwwbTXB3QoWYvZqTSJgugll+A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzQzS0JBMEYyajY5Um1zUUROR3RHaGR2VTJpdkloQkdMZENJaVNyZWtmSXYv?=
 =?utf-8?B?QUpmWFB4L3VmTlYrQWVFcGFMUzh6b3FUbGEvSjlJVzZNUlcyYzJ5dGQyUlJy?=
 =?utf-8?B?RFdydTQra0lPQy9sQzlpRUVSKzBDMS95MU1BVVd2eVFWcUNxcUN1emUyTWR4?=
 =?utf-8?B?WUV6aTBmcG9wM056bXVDTEhyQ2lSM0licnRmZlN3UENJM29YVjJlVkVnSGht?=
 =?utf-8?B?bTlzekVhbE84eHRnMTR1SmxaYndrU3FwNkhVdTBOT0NuRUlLelZqZUs0NGdB?=
 =?utf-8?B?VXg5SFhYQ3FyR3ZDazZ6SE1FZkx5M1dBbWFVbnhUaE1PaXBCc3ZpM0M1RWtZ?=
 =?utf-8?B?bTJ1SWRIVmtMTjhyUE9yYTlDVnJDK3BFMFFkbkxOeGl1amgwbHBmRlR0eDR4?=
 =?utf-8?B?Slp3RXFYNUw1U3VxN1ZBSWJqUWhZWU1GdGJuZVZLZTBmS1V1N051bzB0TWdR?=
 =?utf-8?B?NWZCU1FqbkFDOXRkclBKMnZVbmhndERpcnJEWHlVVE9ZcmtxajdlNXJmT3ZV?=
 =?utf-8?B?QWZZQU52M3NBTkhSZ25vV2tnc3pKYXZsRHB6NjM3cnhocHYxajF6RUhsWVpj?=
 =?utf-8?B?OUFWTHZmTXo5Qlc1TU1xcG5ia01KeW1xLzhqZ1FRVTEyUXl1RjAzUUszd2pL?=
 =?utf-8?B?YnJJNEluVzVjSCtKRWc2Wks2eWdHbnB5NUNoVGt1MGx5akV1MnYybXF0aElG?=
 =?utf-8?B?eG4rNTVPMDJJS0pkSHBqdU5QTk4vdTlvWkJ2d3ZJZVZiblZndFIwZHR5UWxu?=
 =?utf-8?B?QytvbWQ0MmpWVG1uYU81eXBoWGVzY0RRTytBTWNEMzFSWFg4ekF3RnVpUW9I?=
 =?utf-8?B?VWM5MFpqRmZxYjBLbG8wcjhxYU85OW9XRmEzbWliWVVGUEJuallYaE1kNkRH?=
 =?utf-8?B?Y2orbW4wRG1ORWc3TnRZa3dxUzBtRU5UeHU4SVJJSldrUVZqbEZxSWlQRUhQ?=
 =?utf-8?B?RlNXeXdBNFRFZGc1K1dnU0d3UlQ0S0FLYmoyRDhGUUpkM2hlWGdWOVlIODRs?=
 =?utf-8?B?KzJmeGVGdHlXUXlFVG9kYlZaanlYMGlSSFJ3Tjk3NGJsWkNDTzh6eXpCbkFQ?=
 =?utf-8?B?UWd4N3ZMck82eE0vOG5TWUZzdWROWWdXOHNKd216OFF3RmpMRzFxWFJBbXoy?=
 =?utf-8?B?cHo0YmVYV1lPUnBrYVZrbjhPMVpYNlFtQ0RvVE1Bc054YnhETjFmYmtVZkVz?=
 =?utf-8?B?aGJWRnJFbXV4aTFVVjYxQlh5bkJNaEhmbFVqY2UyUGdmdlZqVXR3SW0zT0NH?=
 =?utf-8?B?VGF6NUE3VHdXN0dEc1ZRODZJWnU0Mk01bzVSK1lyTkdoZUhSVlZPdDBIMXVY?=
 =?utf-8?B?cUo2dldDeUhLOWFYNmVoaER3QnJvMXhBZmlHVTBZVUtsRHd1ZGFxem1HYTRv?=
 =?utf-8?B?VnJ5NlJ1Q2h5NHdmWmtPMk1WZys4dStXQS9SekxnekY1ZERDaW8waDBjeFFX?=
 =?utf-8?B?dk9XTmRoNnhGWUtPTHpXdkpIamhxakFVVm9xNUpXcmtUb0VMZ0twN1pKSWNs?=
 =?utf-8?B?RUhiOVBObGxZTlB5TENCZElNNXNXM0hkdUN1bEliZEN1cWJxcExHSHFYeWNY?=
 =?utf-8?B?K21rTm9EK3dFYUc3Szcrdmx5cSs3YUhObVZMTyt1Q2NRekpFUmh6UXBJb0FR?=
 =?utf-8?B?QlVnMUlWQUJWY245WG4yZHpnL0V0UmNNaGRaeHVrNytHcnRZYmhKREcvc29Z?=
 =?utf-8?B?UUZuR05qMm8xM2Z4S3VHc1BRMERPRlEvOWFJRkloK2JxT1EzUFF5NGRMdlRr?=
 =?utf-8?B?Tm91eDNZZHJxdG03QVlpVWZsMS9sUU5NVFpBaCtDQ2RhMDhrNWtZQkcyYWtq?=
 =?utf-8?B?WHlZR0pzNHIvZkc0SFVWbHlCdGxyQTdEYmQ1ck8rdy9XQlRaU0ZwYk9lQS9j?=
 =?utf-8?B?QXdINTJ6bElPTDhCRFQ2RUlDZzNRZFNlczBrNWJWNmJGbmlGL01iNVJFbUVy?=
 =?utf-8?B?d2ViV01DWDhLYVVkUGdhSjFvRmNRWEswQ3phaWlPbjNjRWxjZE9YdE9paDhY?=
 =?utf-8?B?Uk5QcVNvdTI1VFp0ZGJScTU0Y2dTU0xOdk05TGdIakVRZkMxRm41aWNXWnZK?=
 =?utf-8?B?MkNRRHVDeVB6WDRKa0xibXdaeDhPOFA4SXRVUFJ6aHF1WHhNMU9hanpYWTJW?=
 =?utf-8?B?MzFtUUJiUzRMSkFPNjBBZ1ZMVzViWXBIT2x6Y0M1NjdCeUhDanBRNUhvTTlC?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5253DDD628DD684EA372A2EA7BEBB05F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ab938b-4fb9-41f9-bc6b-08dd88150156
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 18:29:55.4100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Vf7U+kKsNmL74gqSNNJ8v88+65bhGxFYpsAI9KTCX1E6/uRitA0LZ7cXmL7Fpypjze+S2gUyywmDYdOC+zUgJ9xjeV/lNhTH4VwiEI3n2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4532
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTEwIGF0IDE1OjI0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gZnB1
X2FsbG9jX2d1ZXN0X2Zwc3RhdGUoKSBjdXJyZW50bHkgdXNlcyBob3N0IGRlZmF1bHRzIHRvIGlu
aXRpYWxpemUgZ3Vlc3QNCj4gZnBzdGF0ZSBhbmQgcHNldWRvIGNvbnRhaW5lcnMuIEd1ZXN0IGRl
ZmF1bHRzIHdlcmUgaW50cm9kdWNlZCB0bw0KPiBkaWZmZXJlbnRpYXRlIHRoZSBmZWF0dXJlcyBh
bmQgc2l6ZXMgb2YgaG9zdCBhbmQgZ3Vlc3QgRlBVcy4gU3dpdGNoIHRvDQo+IHVzaW5nIGd1ZXN0
IGRlZmF1bHRzIGluc3RlYWQuDQo+IA0KPiBBZGRpdGlvbmFsbHksIGluY29ycG9yYXRlIHRoZSBp
bml0aWFsaXphdGlvbiBvZiBpbmRpY2F0b3JzIChpc192YWxsb2MgYW5kDQo+IGlzX2d1ZXN0KSBp
bnRvIHRoZSBuZXdseSBhZGRlZCBndWVzdC1zcGVjaWZpYyByZXNldCBmdW5jdGlvbiB0byBjZW50
cmFsaXplDQo+IHRoZSByZXNldHRpbmcgb2YgZ3Vlc3QgZnBzdGF0ZS4NCj4gDQo+IFN1Z2dlc3Rl
ZC1ieTogQ2hhbmcgUy4gQmFlIDxjaGFuZy5zZW9rLmJhZUBpbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IC0tLQ0KPiB2NTogaW5pdCBp
c192YWxsb2MvaXNfZ3Vlc3QgaW4gdGhlIGd1ZXN0LXNwZWNpZmljIHJlc2V0IGZ1bmN0aW9uIChD
aGFuZykNCj4gLS0tDQo+ICBhcmNoL3g4Ni9rZXJuZWwvZnB1L2NvcmUuYyB8IDI4ICsrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCsp
LCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9mcHUv
Y29yZS5jIGIvYXJjaC94ODYva2VybmVsL2ZwdS9jb3JlLmMNCj4gaW5kZXggZTIzZTQzNWI4NWM0
Li5mNTU5M2Y2MDA5YTQgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9mcHUvY29yZS5j
DQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9mcHUvY29yZS5jDQo+IEBAIC0yMDEsNyArMjAxLDIw
IEBAIHZvaWQgZnB1X3Jlc2V0X2Zyb21fZXhjZXB0aW9uX2ZpeHVwKHZvaWQpDQo+ICB9DQo+ICAN
Cj4gICNpZiBJU19FTkFCTEVEKENPTkZJR19LVk0pDQo+IC1zdGF0aWMgdm9pZCBfX2Zwc3RhdGVf
cmVzZXQoc3RydWN0IGZwc3RhdGUgKmZwc3RhdGUsIHU2NCB4ZmQpOw0KPiArc3RhdGljIHZvaWQg
X19ndWVzdF9mcHN0YXRlX3Jlc2V0KHN0cnVjdCBmcHN0YXRlICpmcHN0YXRlLCB1NjQgeGZkKQ0K
PiArew0KPiArCS8qIEluaXRpYWxpemUgc2l6ZXMgYW5kIGZlYXR1cmUgbWFza3MgKi8NCj4gKwlm
cHN0YXRlLT5zaXplCQk9IGd1ZXN0X2RlZmF1bHRfY2ZnLnNpemU7DQo+ICsJZnBzdGF0ZS0+dXNl
cl9zaXplCT0gZ3Vlc3RfZGVmYXVsdF9jZmcudXNlcl9zaXplOw0KPiArCWZwc3RhdGUtPnhmZWF0
dXJlcwk9IGd1ZXN0X2RlZmF1bHRfY2ZnLmZlYXR1cmVzOw0KPiArCWZwc3RhdGUtPnVzZXJfeGZl
YXR1cmVzCT0gZ3Vlc3RfZGVmYXVsdF9jZmcudXNlcl9mZWF0dXJlczsNCj4gKwlmcHN0YXRlLT54
ZmQJCT0geGZkOw0KPiArDQo+ICsJLyogSW5pdGlhbGl6ZSBpbmRpY2F0b3JzIHRvIHJlZmxlY3Qg
cHJvcGVydGllcyBvZiB0aGUgZnBzdGF0ZSAqLw0KPiArCWZwc3RhdGUtPmlzX3ZhbGxvYwk9IHRy
dWU7DQo+ICsJZnBzdGF0ZS0+aXNfZ3Vlc3QJPSB0cnVlOw0KPiArfQ0KPiArDQo+ICANCj4gIHN0
YXRpYyB2b2lkIGZwdV9sb2NrX2d1ZXN0X3Blcm1pc3Npb25zKHZvaWQpDQo+ICB7DQo+IEBAIC0y
MjYsMTkgKzIzOSwxOCBAQCBib29sIGZwdV9hbGxvY19ndWVzdF9mcHN0YXRlKHN0cnVjdCBmcHVf
Z3Vlc3QgKmdmcHUpDQo+ICAJc3RydWN0IGZwc3RhdGUgKmZwc3RhdGU7DQo+ICAJdW5zaWduZWQg
aW50IHNpemU7DQo+ICANCj4gLQlzaXplID0gZnB1X2tlcm5lbF9jZmcuZGVmYXVsdF9zaXplICsg
QUxJR04ob2Zmc2V0b2Yoc3RydWN0IGZwc3RhdGUsIHJlZ3MpLCA2NCk7DQo+ICsJc2l6ZSA9IGd1
ZXN0X2RlZmF1bHRfY2ZnLnNpemUgKyBBTElHTihvZmZzZXRvZihzdHJ1Y3QgZnBzdGF0ZSwgcmVn
cyksIDY0KTsNCj4gKw0KPiAgCWZwc3RhdGUgPSB2emFsbG9jKHNpemUpOw0KPiAgCWlmICghZnBz
dGF0ZSkNCj4gIAkJcmV0dXJuIGZhbHNlOw0KPiAgDQo+ICAJLyogTGVhdmUgeGZkIHRvIDAgKHRo
ZSByZXNldCB2YWx1ZSBkZWZpbmVkIGJ5IHNwZWMpICovDQo+IC0JX19mcHN0YXRlX3Jlc2V0KGZw
c3RhdGUsIDApOw0KPiArCV9fZ3Vlc3RfZnBzdGF0ZV9yZXNldChmcHN0YXRlLCAwKTsNCj4gIAlm
cHN0YXRlX2luaXRfdXNlcihmcHN0YXRlKTsNCj4gLQlmcHN0YXRlLT5pc192YWxsb2MJPSB0cnVl
Ow0KPiAtCWZwc3RhdGUtPmlzX2d1ZXN0CT0gdHJ1ZTsNCj4gIA0KPiAgCWdmcHUtPmZwc3RhdGUJ
CT0gZnBzdGF0ZTsNCj4gLQlnZnB1LT54ZmVhdHVyZXMJCT0gZnB1X2tlcm5lbF9jZmcuZGVmYXVs
dF9mZWF0dXJlczsNCj4gKwlnZnB1LT54ZmVhdHVyZXMJCT0gZ3Vlc3RfZGVmYXVsdF9jZmcuZmVh
dHVyZXM7DQo+ICANCj4gIAkvKg0KPiAgCSAqIEtWTSBzZXRzIHRoZSBGUCtTU0UgYml0cyBpbiB0
aGUgWFNBVkUgaGVhZGVyIHdoZW4gY29weWluZyBGUFUgc3RhdGUNCj4gQEAgLTI1MCw4ICsyNjIs
OCBAQCBib29sIGZwdV9hbGxvY19ndWVzdF9mcHN0YXRlKHN0cnVjdCBmcHVfZ3Vlc3QgKmdmcHUp
DQo+ICAJICogYWxsIGZlYXR1cmVzIHRoYXQgY2FuIGV4cGFuZCB0aGUgdUFCSSBzaXplIG11c3Qg
YmUgb3B0LWluLg0KPiAgCSAqLw0KDQpUaGUgYWJvdmUgY29tbWVudCBpcyBlbmxpZ2h0ZW5pbmcg
dG8gdGhlIGRlYmF0ZSBhYm91dCB3aGV0aGVyIGd1ZXN0IG5lZWRzIGENCnNlcGFyYXRlIHVzZXIg
c2l6ZSBhbmQgZmVhdHVyZXM6DQoNCgkvKg0KCSAqIEtWTSBzZXRzIHRoZSBGUCtTU0UgYml0cyBp
biB0aGUgWFNBVkUgaGVhZGVyIHdoZW4gY29weWluZyBGUFUgc3RhdGUNCgkgKiB0byB1c2Vyc3Bh
Y2UsIGV2ZW4gd2hlbiBYU0FWRSBpcyB1bnN1cHBvcnRlZCwgc28gdGhhdCByZXN0b3JpbmcgRlBV
DQoJICogc3RhdGUgb24gYSBkaWZmZXJlbnQgQ1BVIHRoYXQgZG9lcyBzdXBwb3J0IFhTQVZFIGNh
biBjbGVhbmx5IGxvYWQNCgkgKiB0aGUgaW5jb21pbmcgc3RhdGUgdXNpbmcgaXRzIG5hdHVyYWwg
WFNBVkUuICBJbiBvdGhlciB3b3JkcywgS1ZNJ3MNCgkgKiB1QUJJIHNpemUgbWF5IGJlIGxhcmdl
ciB0aGFuIHRoaXMgaG9zdCdzIGRlZmF1bHQgc2l6ZS4gIENvbnZlcnNlbHksDQoJICogdGhlIGRl
ZmF1bHQgc2l6ZSBzaG91bGQgbmV2ZXIgYmUgbGFyZ2VyIHRoYW4gS1ZNJ3MgYmFzZSB1QUJJIHNp
emU7DQoJICogYWxsIGZlYXR1cmVzIHRoYXQgY2FuIGV4cGFuZCB0aGUgdUFCSSBzaXplIG11c3Qg
YmUgb3B0LWluLg0KCSAqLw0KDQoNClRoZSBLVk0gRlBVIHVzZXIgeHNhdmUgYmVoYXZpb3IgKmlz
KiBkaWZmZXJlbnQsIGp1c3Qgbm90IGluIHRoZSB3YXkgdGhhbiB3ZSBoYXZlDQpiZWVuIGRpc2N1
c3NpbmcuIFNvIHRoZSBiZWxvdyBjb2RlIHJlc3BvbmRzIHRvIG1pc21hdGNoIGJldHdlZW4NCmZw
dV91c2VyX2NmZy5kZWZhdWx0X3NpemUgYW5kIEtWTSdzIEFCSS4NCg0KVGhlIGZpeCB0aGF0IGFk
ZGVkIGl0LCBkMTg3YmE1MzEyMzAgKCJ4ODYvZnB1OiBLVk06IFNldCB0aGUgYmFzZSBndWVzdCBG
UFUgdUFCSQ0Kc2l6ZSB0byBzaXplb2Yoc3RydWN0IGt2bV94c2F2ZSkiKSwgc2VlbXMgbGlrZSBx
dWljayBmaXggdGhhdCBjb3VsZCBoYXZlIGluc3RlYWQNCmJlZW4gZml4ZWQgbW9yZSBwcm9wZXJs
eSBieSBzb21ldGhpbmcgbGlrZSBwcm9wb3NlZCBpbiB0aGlzIHNlcmllcy4NCg0KSSBwcm9wb3Nl
IHdlIGRyb3AgaXQgZnJvbSB0aGlzIHNlcmllcyBhbmQgZm9sbG93IHVwIHdpdGggYSBwcm9wZXIg
Y2xlYW51cC4gSXQNCmRlc2VydmVzIG1vcmUgdGhhbiBjdXJyZW50bHkgZG9uZSBoZXJlLiBGb3Ig
ZXhhbXBsZSBpbiB0aGUgYmVsb3cgaHVuayBpdCdzIG5vdw0KY29tcGFyaW5nIGd1ZXN0X2RlZmF1
bHRfY2ZnLnVzZXJfc2l6ZSB3aGljaCBpcyBhIGd1ZXN0IG9ubHkgdGhpbmcuIEkgYWxzbyB3b25k
ZXINCmlmIHdlIHJlYWxseSBuZWVkIGdmcHUtPnVhYmlfc2l6ZS4NCg0KU28gbGV0J3MgZHJvcCB0
aGUgY29kZSBidXQgbm90IHRoZSBpZGVhLiBDaGFuZyB3aGF0IGRvIHlvdSB0aGluayBvZiB0aGF0
Pw0KDQo+ICAJZ2ZwdS0+dWFiaV9zaXplCQk9IHNpemVvZihzdHJ1Y3Qga3ZtX3hzYXZlKTsNCj4g
LQlpZiAoV0FSTl9PTl9PTkNFKGZwdV91c2VyX2NmZy5kZWZhdWx0X3NpemUgPiBnZnB1LT51YWJp
X3NpemUpKQ0KPiAtCQlnZnB1LT51YWJpX3NpemUgPSBmcHVfdXNlcl9jZmcuZGVmYXVsdF9zaXpl
Ow0KPiArCWlmIChXQVJOX09OX09OQ0UoZ3Vlc3RfZGVmYXVsdF9jZmcudXNlcl9zaXplID4gZ2Zw
dS0+dWFiaV9zaXplKSkNCj4gKwkJZ2ZwdS0+dWFiaV9zaXplID0gZ3Vlc3RfZGVmYXVsdF9jZmcu
dXNlcl9zaXplOw0KPiAgDQo+ICAJZnB1X2xvY2tfZ3Vlc3RfcGVybWlzc2lvbnMoKTsNCj4gIA0K
DQo=

