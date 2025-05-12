Return-Path: <kvm+bounces-46271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 93166AB470A
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 00:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E58EC7AFCC7
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4213A25CC5D;
	Mon, 12 May 2025 22:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JfGKMmT7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFD524DFF1;
	Mon, 12 May 2025 22:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747087217; cv=fail; b=aDBuqrSbkxBcXmch9m6U7imM0fXiK98w8pAyuDRf0v8a5oRE5Y3DPB6HJbznk0MMGITO6JA5BetfVl0oquyz7SMQ6mta3w5PlqVW05lz2XQE2+TqdBpQ3VS8gZx+zOFNBMso4lxcoo6fvtvG5XprkBk+T6P9TBzfDELGnuv+IKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747087217; c=relaxed/simple;
	bh=/8MOIyDKl5ArXQ1tCAR8PeP9CNV6Twktf5/hi/yqsLU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FPV7JaHg2RWMO/EMKfXhNhiDRBzTjper3YVrXW6S5aXEQs10zw9K8th4wYE5cx09fkW0gvMPVbTQvLl6hQa2CU/oO2NI0Mz7zAr6ybAL83uFE0ZKDdIZL/KLzLbqVMmD5RXDH4oEy7THGeHPhzL14qVBXTnMJpxa7tSim5NNO/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JfGKMmT7; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747087216; x=1778623216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/8MOIyDKl5ArXQ1tCAR8PeP9CNV6Twktf5/hi/yqsLU=;
  b=JfGKMmT7lwxvV7kLus85x51H9mBeQGAX4kt+nQWeuLQFzS5gljAb2iCw
   A4M09rEDdqLc/HtZrKT1Y1y5BYzBx1JLiWEBCqRgCV3iEqULzmcmYasaZ
   QpOT9dBZS+WiMtbPkCCPm55xWWm9cBGGd4SUd0q/l2DWVrsU3+blxFG+P
   XhIzA4XvsUhUKBn19mvk/Soksw2EOEzC8Nhl3P2FFKB1xzQdW3ChM/qWK
   VSdXcSZOqSJIola714wLRVKhoTvXPklsTL8bUFjCvaOziGNz42UFZwsm1
   Uyy+FlYYu1Vziqt0+4znAI2kDw7qhe7ZE/QwAvJjh1Sn4F1BiAaPteXYs
   Q==;
X-CSE-ConnectionGUID: auHYB77xQ6CaFtSpJZpNtQ==
X-CSE-MsgGUID: pgaH1GPaQ4O1Nl1/H4y+Sg==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="59911434"
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="59911434"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 15:00:01 -0700
X-CSE-ConnectionGUID: iJj/DwSnR+2BxbI92iUkDg==
X-CSE-MsgGUID: /gMqzd2sTmS8K6fWIZr2Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="138016808"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 15:00:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 15:00:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 15:00:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 14:59:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RPT1e/+v7ABquyKSAtwp9DaAwEZBjiNwM4DiPUU2o46MxuFibHn62qnz24cNMkY9bYCfN/E2PR7dO9W4AqB8d1hgTIu1kQvXA1cnh18PMPsGxji6DhPbIgwRSIhFBwszPjf8kj37AgfakVVSikTaJ8U4Cnw+rVnSsNA1SXm1sjPokozlPSEUZswqJjJa4VDcfjmMQPUQ7gp/xSdUfCeBXhfaIoD07SPmLihcUFixlRSudxPhosSvFk0Q4vNK54sYXv5WRiciAEnoCOQAkigQYa3nX0gf76IQwdP0kEMXPHUD8xEx7038/yHOdYzUaT1bk8y8TmCYZbUmARBPmGuPbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8MOIyDKl5ArXQ1tCAR8PeP9CNV6Twktf5/hi/yqsLU=;
 b=c6+mbcth5iKLdahPMSNKQXqhH4PGD9q52S8aPo5GQ0rFEOaL84JPOvC/1+IoOvqK6zS+JSUF025fXk+W59v7rSxNWykQkcQg0Dg0nUec33lGg3aT+y0aOJKlQWBHEk9AWIk2jtcmK2OOCcxC8l4T3I3lxZKkr9Tnyqgq3kPLmPXZzB/nRsMpyPQIvse2xVTZjkrFyVwZkjlnObk+Nx5VbhsGGcfrHyeHs6tbPwNGwvKUwZHCbYGWSOtiROvQwCk7crcDnklczcMPHvZ34gF67eHNirEgC6Hk62F8urstcNArAzfbNqPiIr+DrmgOp8rdDw01Uk0EoSfe5i/WIIxasg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9134.namprd11.prod.outlook.com (2603:10b6:208:573::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Mon, 12 May
 2025 21:59:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Mon, 12 May 2025
 21:59:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jroedel@suse.de" <jroedel@suse.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHbtMYat5kS3vWoBkCnVGDzEELKMbO5zpMAgAAI7ACAANlQgIAKKDEAgABHPQCAAA/NAIAAeT+AgAEy5oCAAHqYAIAAsR8AgADUaYCAANzJAIAAuGQAgACdt4CAAA+uAIAEifcA
Date: Mon, 12 May 2025 21:59:57 +0000
Message-ID: <d8f79605c0089049d8b942227fd9523c14fbef91.camel@intel.com>
References: <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com>
	 <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
	 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
	 <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
	 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com>
	 <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
	 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com>
	 <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
	 <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com>
	 <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
	 <aB10gNcmsw0TSrqh@yzhao56-desk.sh.intel.com>
	 <CAGtprH8=-70DU2e52OJe=w0HfuW5Zg6wGHV32FWD_hQzYBa=fA@mail.gmail.com>
	 <8d8f4d0ec970fc7c16341ee994d177d9e042c860.camel@intel.com>
	 <CAGtprH8sn48pNC29SSNqCCV88O8mjU1JiOFvLbLrm_7LGjGRuQ@mail.gmail.com>
In-Reply-To: <CAGtprH8sn48pNC29SSNqCCV88O8mjU1JiOFvLbLrm_7LGjGRuQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9134:EE_
x-ms-office365-filtering-correlation-id: 83b108de-381a-4eae-4e8c-08dd91a055a4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RS9Ea1kvUlRZai9Hdno3OE9TZjlOUUQ3SVNTeUxjVzZvUWYyK0F3NlIwTG4x?=
 =?utf-8?B?WFJCeSsrd1JBMzNkd0hveld2WjdVdmhva2JHY3REYzcyMlZaRlZkSEhJalhU?=
 =?utf-8?B?NjFJSjloSlYzV0U4T3VobVZmNE03di94YTJkajlpZzVVRUEwTFhBQURad3RV?=
 =?utf-8?B?d051ZzFJUUtlS2NsY2ZmSHNaN3p6YTZpOFUybnBIQVZoaEdPNE0wZWRyMEkx?=
 =?utf-8?B?LzMxZVFYaFVoZDdHSitJN3pmU2tEbTh2K2tWVTd1QjhLR3BsSWlOUEZBMFgv?=
 =?utf-8?B?YmM5NEl4MmpuWTNlU2NHMXRsVGd3R2VMRGRyM08vQncybzJoZzNTSllnRzBk?=
 =?utf-8?B?OHRkNWhndHpXeW1JNXJoempSbG5TeGxhMldFdjE0TzB0c3JrcTlaSlVuZmR2?=
 =?utf-8?B?MUFoTUJ4azA4Q3N3Qkp5VldzUERxdkIyQURlQnBBbHlPRjdjYTBiQzZzaEov?=
 =?utf-8?B?TDRpYWNxNXlQT3ZNR1B0SE1IYmhQRnZubXZNbW1jWXluSDQrcEdoVW4ydE1G?=
 =?utf-8?B?ZHBTc3ZHQ01RZVJuZDRncHJ1a3hKM0RpNDRZbXQ4aEhpODNmMS9sOHZINnZP?=
 =?utf-8?B?STAyYlBJbis3WjAzd2Q4dE5ianZLYkh4b1NQcTIyNVFSdmp3dVVMdHNTbXNU?=
 =?utf-8?B?TVh6b0ZSazlyUWtCRzhBVzQvZ2IrVnVLb1RybU9Qbk1lVGVKZlBxUi9ha2Y1?=
 =?utf-8?B?cmhJeWxoM3BsTG5vczJ4WEMveklCK1Z2KzBqeHZnQUk5L252VmRDOURLWk1x?=
 =?utf-8?B?bWxvVU1DdjcyRlJUdFBPeXVTaGU4alUzYnNOeHE5TWdSbmpzTjRybG43OTJQ?=
 =?utf-8?B?NWpFdDgwa01XNFI2cjZHWFhRSXNsUTVLek9tVW5WMEwrRzArOHY5RVkvMlBo?=
 =?utf-8?B?UEJDdDdsK3IyOUdBRCthNXRxTWtLcmZkUm9WQUxVTVZqTEZUbEFJUGJqQTVs?=
 =?utf-8?B?TVNWbDZVOEVMMTliclNqRzdXNDJJYjZnL01DdXVzMzZvQWRLaEZrL2J1MDRH?=
 =?utf-8?B?OGVoQWg5UzQ3djkxd0ZBSjIrT2pUUktFRlVNNWdWOTJhaFBUeU1tNUF2bFJO?=
 =?utf-8?B?bFFWalZYRkczR2dxTW5sd3dwRlVKK2ZCOEN3bFY0bEwrMVpLVGNYdEhRNWVL?=
 =?utf-8?B?QWczNHZYaUNOR1VnMjN5OUFiY01MTi9CTER2K2huSlhLWVR3UWVkOXJKMjVH?=
 =?utf-8?B?dTYwUThndXVmc2JIWjNJR2wrZ3RSN3QzRmtiR0NiWnJNTEkzSzZ2Z2Nzc3p5?=
 =?utf-8?B?Q1d4YU5vQXRyUjdidEc5bm9UWnhBMTFZK1NHR3JPU1poNU1sN2tHR3V2Mjhz?=
 =?utf-8?B?a1pJdEFLSkpJVVlJM0JwaEIwK1NLL2dsdWUvUVdJMXhRSExXczkrd0tTWjlD?=
 =?utf-8?B?dmYrd3pzWjBCcG11bG4rcVFGY0hBbUJuRmRwU2tjdDFBRnJmQ3hra0tqMUs4?=
 =?utf-8?B?bzJ3ZytQVE9TanZpUi9wL2diQW13NitKdFA1aDRiUmVEdHROdUF3WVZQcW4z?=
 =?utf-8?B?YmhaZTdLWDZNaGM1a0paWElvdzZNVXF0WkFYbUphOXBrNU1iR3RyaVBWY0VC?=
 =?utf-8?B?YnhNdUFxdFRkN0hJa2pjbFcwRWpQYllSa3Zsb0lldmRFOEFSalFxNWRHQk1k?=
 =?utf-8?B?M0FndW8wdTE1VUZkREgrbWQ0cU5XL1pOSjMwRTFkdm5KWHFnVzJZOGlEelFF?=
 =?utf-8?B?M2Eyd0pOb2g4dkozNTI1SkhBS2FSa0lpMHovWXQrMU1HWUcvcGMrY0xaWlJD?=
 =?utf-8?B?NEx3cW5WZGxUM1hxbzEvNnlwdjJjRklFMWJnMjgrcU1ZbTFra1JFbUNuM3Bi?=
 =?utf-8?B?bURIQkFhZTZsdjh0QkJ3ZzUrdm5JVllZV0NrbkVzcnJtR1VVMlRKZW54TExp?=
 =?utf-8?B?ckd0Y2p1VW9ndUdESWZzcTVheVFyNmJWWlM3RzRxTUNZdXJhdUE4V3lmaFA5?=
 =?utf-8?B?WlBPOTBzY2RraUphbTNiY3BxYmRwcm5NTFFPOFpRd0pCZTUvcE92b3laQzJE?=
 =?utf-8?Q?VbymzKiANbMXyWkRkDt9IksFerauWc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mkd6TTAxeENXbGMySGs1NVlDakYzVk1nUFl6ODNNM3lRcHJIcGJza2VCbXVo?=
 =?utf-8?B?NWF0T0R5YWVMZ1FSeHgvVGxUcFRTWmlvcGoyUnFNaG9Bem4wVEZ6bnY1bkRy?=
 =?utf-8?B?bXllR2I2TEdVRHd3OTd1akNqb2JSZzVZK2tGRHV0NnlxamgzUXBSMXhXRXQ2?=
 =?utf-8?B?S1EvRWFkNFlZdkpOTEIrME1ncmM1TnJpTHp6QnQ2ZTZqeVFuRDdpTG4zOSs2?=
 =?utf-8?B?c04yTll1ZyswdjR5VWgzY1RJcjA2bWF2YS9EeERHVm9CZGZHdE5BRUZXUmh5?=
 =?utf-8?B?amsyVDUzZkVmb01Ka0pBVzdKWVN3MnhJNzRxci8ycjVPbXBLU2t4d2pWTkRL?=
 =?utf-8?B?bS9ZeHJVbmY2bVAvRk5JQmxkWWpObVZISEliODk5RG9WRE9UVGNENzk0bU85?=
 =?utf-8?B?cWhVdHpKd0J0VHpzSDhxOWpBV3ZQRmxPZWV4RGxVUGV1a016OG42aUVKeWcz?=
 =?utf-8?B?bC9OekwraDhsdXk0dGY5SWgxZzZhZU5EcDlmdUY4azQ1K1h3c0N2bWhKTEN6?=
 =?utf-8?B?M0NxVU5oMDVIWUNkci9uREE2ZG9oWDl0VzA3MnZtWG5PeFZOL3BBZnNPdk93?=
 =?utf-8?B?UUJhN1g1dWhrcUVLaWFMMUhScjVpYWVDdFErUnhsTloxWHNZYlNyc0NsNVhN?=
 =?utf-8?B?cFhTYXRhYUlhSGo3aU1seW42NW5idmpURms3SkUrQ0R1OFBvTVB3QTd2UU16?=
 =?utf-8?B?dGtRMTNldlE3WUt3NTdsaFM2WEFyZlVLS25SRXl1bXlFeHVXejJYZForT1Rw?=
 =?utf-8?B?N0JvNXFkMk5zclppbEx4ZHBJY2E1Q3hNNi9FellSLzN6YVdURU9wTStZSGpK?=
 =?utf-8?B?Vlg4TnppTjlYdm5aWEVPQW10NlBVOUErZlI0SjU5a3NJMGdtN0d5K3E5V3A3?=
 =?utf-8?B?Vm1rSE9YbHYxTitsZVhhR2Q2a3hOVzl5d0VWdTRaZ29hbEtnREV1SkNPT1dq?=
 =?utf-8?B?cnF2ZVY2T2tnTXVmaDU4RmxWRkpEQXQ2WnViNTZsbUZFa1E4azU1dDd3ZU1G?=
 =?utf-8?B?eENMY3FBWXZ5a3JiUFoxVUZtVHVodjFYWEx3eUFaVzVsYjB0SWFKS1QzNkFh?=
 =?utf-8?B?aGZibmNNb3NObzNub01JcWhPOVNXWVU4Qm82NnpPZjZWVW9IVkdLU25xZ203?=
 =?utf-8?B?M2YwRzBYUVNZRTdSaldlMlVuVHptOWcvTmxrVVRLSGdDc2ZUanJlRDZFMkFs?=
 =?utf-8?B?c05hek5pelhIbG4rQjNUTi96RWZCbmt6R2RrZHNtQzBaYjhtQ0NyZTVMUWl5?=
 =?utf-8?B?NkVpb0VnM2tVa2U3S295d0lXcjdkSlNrWjBGbk9jOXhYRXF4d2hac0N0cHAv?=
 =?utf-8?B?ZnQweThEZWg3NjZZMkQ3SHBEd1RyMGFjWlRINFp6MHRhMDk3ZFRzekh6Skxp?=
 =?utf-8?B?Q21VRXIrSlpVMUJNckxYMWhhTzQyeXhXK01jQVVnVlNDblVFd214dGcvcVJt?=
 =?utf-8?B?d3NiTjM2cngxNXJmSGVYbDJMblhLWGZNc0FaL3hiSUVGY3BrQTF6Unl6Zkk5?=
 =?utf-8?B?MVZJdEtxZlpTWWZRVWUvb21HeTJKL0Z6VmtWN29SQ3dVeHlYL3NpQnFJMDdZ?=
 =?utf-8?B?clZyNmJXVU50MXc5MWtsQTJVZFlZc0tjTzNPU2VJNDlHdnJXZkNmUE1hTzli?=
 =?utf-8?B?U2wvVEIvNDBVays1aEVrSjBEcWRBdkdHVWQrUGt6c2RsM1ZyckNtdWdmdkkw?=
 =?utf-8?B?WnE1UHlrNzlDRmVGOWhLQ3dtdGQ2QWZjMzNRTkpOeHg4VTdDZEg0QWpnei9i?=
 =?utf-8?B?OUtTR2EvaVp5b0c3NWlkUmU3RGtmOEpUUytUdTBhRk1NQ0xlRUpnZG5VL2Jl?=
 =?utf-8?B?Q3N0TFExL09sTE9odU1VQ3hpRkpFYmI0elQxcVR6elRoL3pwMHJweCtVaHE3?=
 =?utf-8?B?YzhMN21tSFBPc21vaHdVSGRRVnp4amlFaHFZRTJGNGRtUE0wM1dnWVRtS0ps?=
 =?utf-8?B?Ni9mRXIrWXdKeE9sWDFoSmxSVzRQbWF2S25iQ1NOb1lVNHdYcy9nQUJIV0lH?=
 =?utf-8?B?YURIY1lBVUtUcGFCSkpGdTJCY2dneEZFRmhNcUNDSko0VGZBZ1J0VTM3YVRx?=
 =?utf-8?B?SHpRb3Bybk41QzY3U2ZienVodVpJaXZjeUxMTkhJSFcyUC9SaFFiRnNTbTFk?=
 =?utf-8?B?ZDUvVmRhSGJXSW4vUjhzVGUvbWdCclVoTDI1Q0txZXl6WkZLY0JrN2ZNL1A4?=
 =?utf-8?B?Mnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F0C3C4CFC33FF4487022C8DED034D20@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b108de-381a-4eae-4e8c-08dd91a055a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 21:59:57.3880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: btrfLKPcOimj710CHZVt0YX8+baXrtn4EkInjSWDmKp9w5n8rvVcy8gt1ieTCQoswVsRpPivtlQlK1caXdFlK60Rhx+zURj6GutYZSF+hl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9134
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTA5IGF0IDE3OjQxIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiA+ID4gPiBJIHNlZSB0aGUgcG9pbnQgYWJvdXQgaG93IG9wZXJhdGluZyBvbiBQRk5zIGNh
biBhbGxvdyBzbW9vdGhlcg0KPiA+ID4gPiB0cmFuc2l0aW9uIHRvID4gPiBhDQo+ID4gPiA+IHNv
bHV0aW9uIHRoYXQgc2F2ZXMgc3RydWN0IHBhZ2UgbWVtb3J5LCBidXQgSSB3b25kZXIgYWJvdXQg
dGhlIHdpc2RvbSBvZg0KPiA+ID4gPiBidWlsZGluZyB0aGlzIDJNQiBURFggY29kZSBhZ2FpbnN0
IGV2ZW50dWFsIGdvYWxzLg0KPiA+IA0KPiA+IFRoaXMgZGlzY3Vzc2lvbiB3YXMgbW9yZSBpbiBy
ZXNwb25zZSB0byBhIGZldyBxdWVzdGlvbnMgZnJvbSBZYW4gWzFdLg0KDQpSaWdodCwgSSBmb2xs
b3cuDQoNCj4gPiANCj4gPiBNeSBwb2ludCBvZiB0aGlzIGRpc2N1c3Npb24gd2FzIHRvIGVuc3Vy
ZSB0aGF0Og0KPiA+IDEpIFRoZXJlIGlzIG1vcmUgYXdhcmVuZXNzIGFib3V0IHRoZSBmdXR1cmUg
cm9hZG1hcC4NCj4gPiAyKSBUaGVyZSBpcyBhIGxpbmUgb2Ygc2lnaHQgdG93YXJkcyBzdXBwb3J0
aW5nIGd1ZXN0IG1lbW9yeSAoYXQgbGVhc3QNCj4gPiBndWVzdCBwcml2YXRlIG1lbW9yeSkgd2l0
aG91dCBwYWdlIHN0cnVjdHMuDQo+ID4gDQo+ID4gTm8gbmVlZCB0byBzb2x2ZSB0aGVzZSBwcm9i
bGVtcyByaWdodCBhd2F5LCBidXQgaXQgd291bGQgYmUgZ29vZCB0bw0KPiA+IGVuc3VyZSB0aGF0
IHRoZSBkZXNpZ24gY2hvaWNlcyBhcmUgYWxpZ25lZCB0b3dhcmRzIHRoZSBmdXR1cmUNCj4gPiBk
aXJlY3Rpb24uDQoNCkknbSBub3Qgc3VyZSBob3cgbXVjaCB3ZSBzaG91bGQgY29uc2lkZXIgaXQg
YXQgdGhpcyBzdGFnZS4gVGhlIGtlcm5lbCBpcyBub3Qgc2V0DQppbiBzdG9uZSwgc28gaXQncyBh
Ym91dCBob3cgbXVjaCB5b3Ugd2FudCB0byBkbyBhdCBvbmNlLiBGb3IgdXMgd2hvIGhhdmUgYmVl
bg0Kd29ya2luZyBvbiB0aGUgZ2lhbnQgVERYIGJhc2Ugc2VyaWVzLCBkb2luZyB0aGluZ3Mgb24g
YSBtb3JlIGluY3JlbWVudGFsIHNtYWxsZXINCnNpemUgc291bmRzIG5pY2UgOikuIFRoYXQgc2Fp
ZCwgdGhlIG5lY2Vzc2FyeSBjaGFuZ2VzIG1heSBoYXZlIG90aGVyIGdvb2QNCnJlYXNvbnMsIGFz
IGRpc2N1c3NlZC4NCg0KPiA+IA0KPiA+IE9uZSB0aGluZyB0aGF0IG5lZWRzIHRvIGJlIHJlc29s
dmVkIHJpZ2h0IGF3YXkgaXMgLSBubyByZWZjb3VudHMgb24NCj4gPiBndWVzdCBtZW1vcnkgZnJv
bSBvdXRzaWRlIGd1ZXN0X21lbWZkIFsyXS4gKERpc2NvdW50aW5nIHRoZSBlcnJvcg0KPiA+IHNp
dHVhdGlvbnMpDQoNClNvdW5kcyBmaW5lLg0KDQo+ID4gDQo+ID4gWzFdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2xrbWwvYUJsZGhuVEs5MytlS2NNcUB5emhhbzU2LWRlc2suc2guaW50ZWwuY29t
Lw0KPiA+IFsyXSA+DQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9DQUd0cHJIX2dn
bThOLVI5UWJWMWY4bW84LWNRa3F5RXRhM1c9aDJqcnktTlJEN182T0FAbWFpbC5nbWFpbC5jb20v
DQoNCg0K

