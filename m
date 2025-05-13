Return-Path: <kvm+bounces-46378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B58AB5CE2
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:53:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BDEF4C08FA
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E0F2BFC78;
	Tue, 13 May 2025 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xq8LNYw1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D002B2BF3E9;
	Tue, 13 May 2025 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747162389; cv=fail; b=UqNdEiuvzuQi8XLK9B4G0JPgTCcCBoKNMeEG92Vg20MVes5gGlWAiE4Fl8Krohp6Sk8BYbdbs4SnU2Kh5JWE9zpYSnSo4Jiz528wRpH3jPNTcfLT0ASQw+CMsEkSnGoD/25q3BtL0a0LcFVI6C/VKQBby77qmJSqpBA8DFRDZ4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747162389; c=relaxed/simple;
	bh=q5kdLcSs4AhCeRncGEcUhmspX1XneTfIH4aJkhcw0TA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A/292gnvYxq6d9000KCglrydr+joRUtIhyD/YrXE5o5DyYZ+c09gjLWG4vr6IZ0UcVHusN6hpLNwikpBXdTD20jkD3iY97fONVJq+DTqgQiMnRiyIVMfS0EqO1AEme3WjNTCC35D74GQbTLlhif3mzV9I7ascDrGaeoXL4rzXpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xq8LNYw1; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747162388; x=1778698388;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q5kdLcSs4AhCeRncGEcUhmspX1XneTfIH4aJkhcw0TA=;
  b=Xq8LNYw1XhdJj49wClhyWdXknpKAGo9zQSz4r6QqwqVBvAqXoGnmzkxu
   UqNr515i/jvulOjlaynxrFDr+XyA6aYWW9OmO2/bojBX7q+36LhvA6EO1
   ihWvoh0CTxLnUWX8iIZPI4z5O0fq3cxAQYzcLCut0EXIebLpfDCh7vjFa
   rS7cyxxuoM7vlqDI+bfo11q0Gt9MgVeUcDYoSmw7WV607yL/OvdrM2Dm9
   sVOlpP/93RVbE0pF8Dc3Dd19udlvJYafcB4IY0GmhtkZ5cpEFaUGcGhou
   O5JC+0spiMU9MWQO6vMoqrghs5cx6f2pDferQ06z50uFRp8LIdhWggZ0j
   Q==;
X-CSE-ConnectionGUID: IIfoLbbtRzKQOzdGZDvcCQ==
X-CSE-MsgGUID: ecmK4OyxTByZ77dU93Q6VQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="74425779"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="74425779"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 11:53:07 -0700
X-CSE-ConnectionGUID: 3ccqF5rlSK+2qnQ9mnruOA==
X-CSE-MsgGUID: QwSR5lhQQ0G7dAU8k98Jbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="137525664"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 11:53:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 11:53:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 11:53:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 11:53:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ox5gA3Rd7w60fPzmF+vwW1Hr2VQXSbnCbTDT/sOj0xBQETN+JzwOhuJkL5LOKJupjncbw77gLzgj5FPyKwCnTLNDCnt+mNj4gK57SEvzOKCakcONi/LpzbbISpGB/C1hBB221BUydlmSLPxG0ZwookqBeKMyFPvBEN1yi3I+u5umxEq27dyed3akE4Qu8OUKV8ZgkZGd9HbAa7cmFbP3uwlWhKFwts3pv85JAd0v5CyIVf1nlwlPqZilolBEDIVqjNPiavj8XevnAdNk+n2Uh0ES7AYQUhFw48qPxxgiD/sS9wcfNoU47d/AWD1ao3mWEuw0clobJGpLJf+7LVvV9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5kdLcSs4AhCeRncGEcUhmspX1XneTfIH4aJkhcw0TA=;
 b=IRyvWUIwsbRQsjiHxoOTTPVMjuBvAXGkQLyz7mDlDf3/8a6qQo3LQiFnqNXpQeL1uasEQCyXH/PIzP1ReyLtuIyAWERu7f7fw43Nbb7sg1jr79B13O7ndlM88PTEM2+bcZDfN1mB/l43BoYugCy0AE35TJQMOu5+Cy8PEdejWRBiPYMolvoTzWuDXH+IBg+cq6CFuSCzrcdMsNVNxzG005ru97AvDIQj5cxyvrwzVdCQKfH4jFeRe27Z1MBPOH2q702f2Jk7ZjCYEMj2zltT2cKYR6gVDhv2msIyyIfOfSw3+EE3lWhSEeHy5WXmUGBV41qBk7D6PDulEFHeArSDHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7630.namprd11.prod.outlook.com (2603:10b6:8:149::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Tue, 13 May
 2025 18:52:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 18:52:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Topic: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Index: AQHbtMXhHrhcZKCSdkuquayYYQc4lbPRBuIA
Date: Tue, 13 May 2025 18:52:49 +0000
Message-ID: <a36db21a224a2314723f7681ad585cbbcfdc2e40.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030428.32687-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030428.32687-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7630:EE_
x-ms-office365-filtering-correlation-id: 36893458-f8c9-4469-d1bb-08dd924f5bfa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q1JENDhxQ2E5TXBvY0hsWEtPY1cwQzJLV1BTNDFXMnA3OUNXY0hNYk8rVXRk?=
 =?utf-8?B?TEluUjdhUU1GSFlyeHVqVTNWTjZvYVBJYWk2dW9oTWZNVGdiMXUzeDFrUnJh?=
 =?utf-8?B?SWIzaFdaME5HY2FBNUpoS0ZhUk9heGVPZVc5VGpnVk1oeWJiaG45MXFIMGtP?=
 =?utf-8?B?ZnhseWFHa1pIcXBRSlczaXQ2OWk2RmdhdVZyc2RaZm45eE1iVlpRWmJMRXVM?=
 =?utf-8?B?c04veGt5OWZxU2NQTmlCL2xGdFhHL0ltSzFZcFo5ZWJVaTg5YjhQY3hLY0Fq?=
 =?utf-8?B?a0h6ZUMzWEQzY3VFeXF5Vlg0bXdiM2JTTHV3OXJjTldrR0pnTXhIUHkzSEFB?=
 =?utf-8?B?ekJaNFRxNVNjWGFjNDhMMWVUWFo1V3VZOEJ4Vk8zaHMrRlpudWZ2ZHFYWjBw?=
 =?utf-8?B?SVlhY0xUNGlxMW5iODkzQVgxY2Q2eUN6elpaVEV6ak5IdTgxSVo5RVpmNFdz?=
 =?utf-8?B?NUN5SU1sTGNER3ZZUjVsMVl0TTh2K3ZrVG9ZejdOQmVQUVZHMmkwa2cxNXM1?=
 =?utf-8?B?RHFVL1FMNzQ4ZzRwRE4yRUZMd3d6SzMzVnBwalBjcUFLUGtQQklJa05aWFR0?=
 =?utf-8?B?cEZzelA1VWMvZ1JxL05UUVh1a2FvK2FIT05FQkxFRjVoaWdlUHlFbXZ0aEFs?=
 =?utf-8?B?dDlsWUNBSW84UEF4czN3WHRsSXlXdlF5UDNpOXREaVUvdXZQM3krc1ZNOVhC?=
 =?utf-8?B?UUhBdDJzbzlJRHFlZjl1OHJPQ3FDUWhwbGM1VVdLL0N6R2ZBa1U3bzRjL0pt?=
 =?utf-8?B?U0hVRlBnWFcwamt0SExqOWdZallzYUZTcWNEZTBoK2xtbldjVDhsbWllUW1P?=
 =?utf-8?B?TXFpNFlJb01iT2tMV1Qwa1F4NlhJMWhyc0tRempPZVg1U0tZNFp2OU42OXFp?=
 =?utf-8?B?ZElUN3VXM2VSajQwYUFOcUVTZU03bldKK1lXRDBQOEFoV1hGYzB4b3NjKzNv?=
 =?utf-8?B?WHM2dTUyVUNHU1hxd0dtQ1ZuRVh0dTYyS0ViQnB2S1YxM25NSUwwYVFSVDZN?=
 =?utf-8?B?QjVHSFdOVEJuMGMweGdRYVc3eWNtcGhObmNhZzd1ZDRObElBNDdSbUJvdmRa?=
 =?utf-8?B?SHg0aVczREIvTXFVMUNzeGhkM2xKWElNenY3SllXKzNVZW1ObXpJSFpzY0Zs?=
 =?utf-8?B?NkJLcW9HajFFRkNJWEw1V05VVmlNakd2cU12ODZlV1VQNzRnV1ZiTGNPMVpx?=
 =?utf-8?B?bjJ2MEdPbzZyZ3loVE02UmdJSXRtV053YkxOUGJaV2VIc0x0OC9nR0xNZjBZ?=
 =?utf-8?B?bzhzUGFSUXpQZDlSYWhUaHlTM3BVVnhza1ZPZTN1Vmd2RzNwRXl1UWh1Vm9i?=
 =?utf-8?B?VUszRlBvUDNvWDl4dVE4QnA4Q2Q3aXVmYXVMektLb09JeFBUcDgzWTZ5NndX?=
 =?utf-8?B?cnBtTUdNTlJRbE96cVN4NnJUUjV6d1FxMzVkUlVhdE1hVzIxRDBHRmdSRWIz?=
 =?utf-8?B?YXQ1Q2JFN1N5ZjVMRGtKMy9Qa1g2VEZhM0ZBaWQ1U1AydWF4RjFiNVlIZElZ?=
 =?utf-8?B?TmQyVDV1bDhqMnVZK0FzSHVOWlJNUlZmKzNoY0prWVJpaEtVRjVPbGtxaC9J?=
 =?utf-8?B?SGJaTk5ZQ1Q0NVBCYjFRQzRGdUVoTzBzKzlqOHdUN0d2RGY0SnpGRlRGbW5X?=
 =?utf-8?B?bkpPK3lNNndZL3Q4NGRxYXo3dHpPWFZpM2g5Y0c1MHRlUndYV3V4cDYwMGd4?=
 =?utf-8?B?cWwzcVlwd2xxS2V6NlVjNzFuV1IzTVVsUzhzdWJ2c1VFR1RVVzlRK0ttZG1F?=
 =?utf-8?B?V0QxdERzbXk2ZjR1a3BqYXpLczIrNldFUktnMFZvbWJMbTBvVE5uUWx2UmdX?=
 =?utf-8?B?emxramNJd0dWY3JmMjhkTUoydTlMRk9WQ2dQdk5uYTc5bUJ5UWl3cXdTWVIz?=
 =?utf-8?B?eXVqQnpyRjBlbUUvUmxVZDF3aHcxMkorczZJdU5uVWFVVTBuNzlpY1BURDBT?=
 =?utf-8?B?K3lXTVhLeFZ2ZjhhQnZ3UHFiaStlZWR5WmpWUVAwalFxNlFJL2RoZTRmZUEw?=
 =?utf-8?Q?6mziPeXlPQfWHz1mWZ8C5ipkDsB9/U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGh2bER5NmZIWm43NmFYMnBkd3JoNlFxdGhlWkJUNG1ZeU1WMU5qUTRpM2g5?=
 =?utf-8?B?eWRVNzd1L0F1VTJaL2hsNisvbmdBMWF0WDVCQlFKRVNMZnNYd2l1MWx5MEp1?=
 =?utf-8?B?N2VQdHd6WHlXRDRjeUQ0d2hPMWw0bldOMHI3ZFgzQktxamxhZGxjMUtQcTcz?=
 =?utf-8?B?VUJjRDlpUUZQS2N6MmJ0bnVyWWQ5L3VMQjBSUFQvYTRHMXRTOUxFc3dQNmdo?=
 =?utf-8?B?WEw0N212OExWL3VRdnFoQ0xxUXM4UGdCbXZrOGdvdllDT3RUNFpyU2pYWTdZ?=
 =?utf-8?B?TENPREM0a2dSOUpVWm9sTmwwUkxKSDhDV1BBTzVpL2lMSXpGMnU0ZExpRlI5?=
 =?utf-8?B?Z1FIbVRLeC91cjRvVnNUcVY5TEhGb2R4YXZDR2pRcjZhaGgwV2FKSHBkcWVB?=
 =?utf-8?B?MmROTmJXbzc4ZXhORGhSVk5uMEVBNUZ4QWlEUG1YK2NxczYzT1NJQnoxOENw?=
 =?utf-8?B?U0Y1WHBQd1g3WFo4dlZqcmU2ZEFvcmNPU1Y2eHVxWDNyL25WbGpJU2doa3RO?=
 =?utf-8?B?azltS2JhT0k0U0RNNGJvTmhkY0FVelhFTmRNK0lDQVlSQVpONHgwL0dxWmMv?=
 =?utf-8?B?TjRMQ29yZ1RaTFVzUTRGVTlZNnpWdFdHUGlZaGl5VURpaXpNZGtDMnhkcEFn?=
 =?utf-8?B?Yk5ibHNMYlBOZzJXeFdEUk8xR1NUYnUxOHY1c2JXd3RzL01LVC84bXZWTDFH?=
 =?utf-8?B?cHc4QlNDdzNkYkRoZnVrMnRPWVNrWm5ObjZtdkI4K3JQT0MwbGx2SXZMTVJJ?=
 =?utf-8?B?TVFBZEZhbUhJTWNuQ2ZKZ3dtRVZvemFNbGZqYU5qR3hoRDFXbGV5V2hNVlVI?=
 =?utf-8?B?UzJJeGtTT3ZXMmIzZkFuMC9pSlBodmp6d2tCcit5bmczZEFMY2ROcG1qZjln?=
 =?utf-8?B?YVdMSXlUQlpnay9xanJIbzhST3FlMVAzTzg4RTdsVWVVS1lDRzF5Y2tOS0x1?=
 =?utf-8?B?SkpoZEVPQmc0ZFlxazBpa2lUOHpKKzV1NnhJbmo2QzdNNVhpOGVOMUhqTkNz?=
 =?utf-8?B?bGlMRE8zZ3hpMGJpQXpRL2NHYm0vbjdXN3FPNW9oZEdKbE95S01kS1BiWmtX?=
 =?utf-8?B?YWlFTmNVVG82T0RRVlVBbTlYVmtHRWdhN05OQ0xxVS9qeG1ZdGdBY0xiZWg1?=
 =?utf-8?B?T21JbExuSTBUc0NIbTZoeUIyREphQUNlQXFoMk9seU5HRFBDK2VJSFVjbHNJ?=
 =?utf-8?B?d3dJdXdDOUJ3SmN3L2YzaXNXdVEyZzJYeXZmd0tjOU8wZ1daODZVMVl4QVhx?=
 =?utf-8?B?TWJIQVhVYm1ZcjhidmR0a0JQVG5jWDJwN3RVcmJTbUhqZkZaTzl1Zi9Wb3h0?=
 =?utf-8?B?eEVRcXUraU52S1orNXMyVFppbnNJSkVsWHlZa3BhYmF1UGZuUEhjVGF6Y3A4?=
 =?utf-8?B?WEg0Y0IyTmswOEJYUmxZekRaWFY0NWVzYkUzbTI0RU5XbjhCUWZJek4rYTRn?=
 =?utf-8?B?UkkrSkw3M25MNkZoY1FZeGNEajNQUi93RDRMUTlpVUdsV3VpNXJUa043VUVy?=
 =?utf-8?B?bHhKb2V2dXpnUXJFanYzODAzL0cvN29XMmZxMU01ZGsyNEpmR3k2dU0wQS9U?=
 =?utf-8?B?ZnJ5Sm5NclZJcUxnVUsvQ2JGZFg2VFNlcTU4VlVWRTQ4RTBJQkZXS01BZjZk?=
 =?utf-8?B?d1ZJdkczcVhDY3pjekNjckZjdXNOazhaV2xad2k5c3pnVmM0dHpMN09IYlRQ?=
 =?utf-8?B?YkpLN2ZWTjlwb2ZkajhDaSt2ZDQxUU1iYUdkR2ZiY1NGWUVXY3R3Y2hFeWR6?=
 =?utf-8?B?c2E3WWNzbmlraHdxOVMxYTZIQlk0eWF5MlozdnA0VWcyOWV0L2xVRDFOYk9a?=
 =?utf-8?B?K1RyUCtoaDhOMVE4ampTUzBZYXc1TXFhR2J5L2w4c29zcEJuUS9aQXNhb3ph?=
 =?utf-8?B?UjBtY0twUVl4bk45Y0xCZkZZbzI2S0ljbDhLSnRJYnpETmxOZGE3YzlKa3RR?=
 =?utf-8?B?ZG5xZjBjaGdveW5Ka1U0V25oUCsraXh1MmZOODVsY2tIZXBaZ3Y4OWRNOHVk?=
 =?utf-8?B?a2tOL2xKWDNHekJqTXpWSWduRXkwdktBZWpIY2RUa3RRN2tGTVhRWVpTRkVF?=
 =?utf-8?B?TXNLcnJVYnhWTFhRQWxTUDhJblo3VXFMdUpsYVdISlU0cVBsRldUTW9mcllm?=
 =?utf-8?B?NDd0VGplT05Pb0NSYnE1RW1COU9IR1dSbVowWUtocTRvSUR1Mkh4V0pEMG9B?=
 =?utf-8?Q?B3q+FQDXEVftsBR9xVuFy5A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DC40A4934ED9044B2D108A56CE13E0C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36893458-f8c9-4469-d1bb-08dd924f5bfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 18:52:49.9421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xHtR285ZdpZYu+JKR5w6ua6DXjig0R9Vj+lAG2L+s4njTxR6WiTdJ9XcMXuHoZmo1ZpXnV31/scSjtpDoHLR01zxzi/YfBU3MJevtefffQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7630
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRW5o
YW5jZSB0aGUgU0VBTUNBTEwgd3JhcHBlciB0ZGhfbWVtX3BhZ2VfYXVnKCkgdG8gc3VwcG9ydCBo
dWdlIHBhZ2VzLg0KPiANCj4gVmVyaWZ5IHRoZSB2YWxpZGl0eSBvZiB0aGUgbGV2ZWwgYW5kIGVu
c3VyZSB0aGF0IHRoZSBtYXBwaW5nIHJhbmdlIGlzIGZ1bGx5DQo+IGNvbnRhaW5lZCB3aXRoaW4g
dGhlIHBhZ2UgZm9saW8uDQo+IA0KPiBBcyBhIGNvbnNlcnZhdGl2ZSBzb2x1dGlvbiwgcGVyZm9y
bSBDTEZMVVNIIG9uIGFsbCBwYWdlcyB0byBiZSBtYXBwZWQgaW50bw0KPiB0aGUgVEQgYmVmb3Jl
IGludm9raW5nIHRoZSBTRUFNQ0FMTCBUREhfTUVNX1BBR0VfQVVHLiBUaGlzIGVuc3VyZXMgdGhh
dCBhbnkNCj4gZGlydHkgY2FjaGUgbGluZXMgZG8gbm90IHdyaXRlIGJhY2sgbGF0ZXIgYW5kIGNs
b2JiZXIgVEQgbWVtb3J5Lg0KDQpUaGlzIHNob3VsZCBoYXZlIGEgYnJpZWYgYmFja2dyb3VuZCBv
biB3aHkgaXQgZG9lc24ndCB1c2UgdGhlIGFyZyAtIHdoYXQgaXMNCmRlZmljaWVudCB0b2RheS4g
QWxzbywgYW4gZXhwbGFuYXRpb24gb2YgaG93IGl0IHdpbGwgYmUgdXNlZCAoaS5lLiB3aGF0IHR5
cGVzIG9mDQpwYWdlcyB3aWxsIGJlIHBhc3NlZCkNCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWGlh
b3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlh
bWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFlhbiBa
aGFvIDx5YW4ueS56aGFvQGludGVsLmNvbT4NCj4gLS0tDQo+IMKgYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5jIHwgMTEgKysrKysrKysrKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBpbmRleCBmNWUy
YTkzN2MxZTcuLmE2NmQ1MDFiNTY3NyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBAQCAtMTU5
NSw5ICsxNTk1LDE4IEBAIHU2NCB0ZGhfbWVtX3BhZ2VfYXVnKHN0cnVjdCB0ZHhfdGQgKnRkLCB1
NjQgZ3BhLCBpbnQgbGV2ZWwsIHN0cnVjdCBwYWdlICpwYWdlLCB1DQo+IMKgCQkucmR4ID0gdGR4
X3Rkcl9wYSh0ZCksDQo+IMKgCQkucjggPSBwYWdlX3RvX3BoeXMocGFnZSksDQo+IMKgCX07DQo+
ICsJdW5zaWduZWQgbG9uZyBucl9wYWdlcyA9IDEgPDwgKGxldmVsICogOSk7DQo+ICsJc3RydWN0
IGZvbGlvICpmb2xpbyA9IHBhZ2VfZm9saW8ocGFnZSk7DQo+ICsJdW5zaWduZWQgbG9uZyBpZHgg
PSAwOw0KPiDCoAl1NjQgcmV0Ow0KPiDCoA0KPiAtCXRkeF9jbGZsdXNoX3BhZ2UocGFnZSk7DQo+
ICsJaWYgKCEobGV2ZWwgPj0gVERYX1BTXzRLICYmIGxldmVsIDwgVERYX1BTX05SKSB8fA0KPiAr
CcKgwqDCoCAoZm9saW9fcGFnZV9pZHgoZm9saW8sIHBhZ2UpICsgbnJfcGFnZXMgPiBmb2xpb19u
cl9wYWdlcyhmb2xpbykpKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCg0KU2hvdWxkbid0IEtWTSBu
b3QgdHJ5IHRvIG1hcCBhIGh1Z2UgcGFnZSBpbiB0aGlzIHNpdHVhdGlvbj8gRG9lc24ndCBzZWVt
IGxpa2UgYQ0Kam9iIGZvciB0aGUgU0VBTUNBTEwgd3JhcHBlci4NCg0KPiArDQo+ICsJd2hpbGUg
KG5yX3BhZ2VzLS0pDQo+ICsJCXRkeF9jbGZsdXNoX3BhZ2UobnRoX3BhZ2UocGFnZSwgaWR4Kysp
KTsNCg0KY2xmbHVzaF9jYWNoZV9yYW5nZSgpIGlzOg0Kc3RhdGljIHZvaWQgdGR4X2NsZmx1c2hf
cGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkNCnsNCgljbGZsdXNoX2NhY2hlX3JhbmdlKHBhZ2VfdG9f
dmlydChwYWdlKSwgUEFHRV9TSVpFKTsNCn0NCg0KU28gd2UgaGF2ZSBsb29wcyB3aXRoaW4gbG9v
cHMuLi4gIEJldHRlciB0byBhZGQgYW4gYXJnIHRvIHRkeF9jbGZsdXNoX3BhZ2UoKSBvcg0KYWRk
IGEgdmFyaWFudCB0aGF0IHRha2VzIG9uZS4NCg0KPiArDQo+IMKgCXJldCA9IHNlYW1jYWxsX3Jl
dChUREhfTUVNX1BBR0VfQVVHLCAmYXJncyk7DQo+IMKgDQo+IMKgCSpleHRfZXJyMSA9IGFyZ3Mu
cmN4Ow0KDQo=

