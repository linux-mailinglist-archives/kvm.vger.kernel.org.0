Return-Path: <kvm+bounces-71607-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAGQNfZ6nWmAQAQAu9opvQ
	(envelope-from <kvm+bounces-71607-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:18:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 574CD18537A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 42A57304FF7E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DF03783C2;
	Tue, 24 Feb 2026 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V4UbeBxX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6134334C141;
	Tue, 24 Feb 2026 10:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771928303; cv=fail; b=UJtNzLayEj0R5crHl0sEd8W92SgODVN9AnTpABN8NisiQ/gTkh27z5B53+y6TUFnhD1tTBSzwjHG90IpuUDukZy7On4OSMIdo5BSa6/tPpVevEcKEdoset5ZlaDtN6p0OIkt7fzkoYaHF/hcWn9bbT7+u0avMvFqUk8xglGY69I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771928303; c=relaxed/simple;
	bh=gmDRRATxBvJ4SR/mNVYVD18nRLk5plzSmsqqo+/3WvM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oIgaQ0HX+eB31t/+CEq8o++j9I4NQNUq8q0pMDyQlXXeRWcNTZ2N0S4pf5ioDxVqHjxcEGZ5jyYPfudTOdqnDhyNxftElW8cYOIprpQVmIbA9KLILcA1aAleT0OOxyaacDhsjV5ckEIrJtEAbiQNI8y1T89cweGGT86FIAveB1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V4UbeBxX; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771928303; x=1803464303;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gmDRRATxBvJ4SR/mNVYVD18nRLk5plzSmsqqo+/3WvM=;
  b=V4UbeBxXFNRwFL8pnYVNVdgZxouaLy2FUAClu4yzVRTvL8cdfgQJz5yk
   VSXaYgk0lmGV+D8kWYe8isN/yz9HzPwc9blq2fYF2eWZnt50l7qQ1/nyi
   CrJD+s3kAJbb3Rgqb/aflfX1ucYdmFYPUVIud/qOwVKmzCQVZyqWeCaY9
   r843Xwfx58pH0sOwVHlZ+LwjKyNUJlXqgv7EaN+uPC57r61Egzmqi4Sk+
   +5ENVnbjtxn6FUfla3rOjP3GVph9VlKKfuXS1lOMjU6a3IsZwIZNu8Sdh
   cHb9pzz8/LtWyinceZ3yr7gtigqjDaWLoBnaIbz5EAUU0i5B3TtJXIIK3
   g==;
X-CSE-ConnectionGUID: 9y+ffYbuQQe7D2midMwjkA==
X-CSE-MsgGUID: In9k3zyJSO6Je7ZMliOb6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72842108"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="72842108"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:18:18 -0800
X-CSE-ConnectionGUID: z+FOU3VDRzi4w6R/Kdy2pw==
X-CSE-MsgGUID: r8/FYXvtSFCvdbiOzOyxwA==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:18:18 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:18:17 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 02:18:17 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.52) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:18:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmtkLQkjz3ijWoPAiQkxgaXY6k6NA5HCntqAe44UYARhpZ1Vt+pt8wGuEWyfDVbp1l5tnB8+NEJbz5gC2E8tI2jxBS5IzAqqHpbipt0RrEJE2S4VM3qF4nAmYfkMv9GtzmTFz7QAy6Oih5lbr2mBKfXCcBEHd6OVC6RuPPYpiEx3m84QfnlMj5ub4N9rpCDM5vPq2PTADMjBLGoQYSXmQ+FWG1GNH4XpzMVySR9RfZwdkZ19SG2dzf+R0DKEjOskHdXDJANP1NbfwtylXazz5AwBlBmUZGHEpbezrWXSQvueZnCS3J/XSRLtR2R7xLDODesv37Fmg2tII0BOW/NlRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmDRRATxBvJ4SR/mNVYVD18nRLk5plzSmsqqo+/3WvM=;
 b=DPAOuha+sd3zXceGKQ8HsJ88tIs9YU/26waYzbplWFqabxIooeVq1M9YuUL+BoNNv0BSK+bQ+/BpD80UCdmJMt9aU93v/AnLCfRT8bNhSB9Zwr7kB7izU6SOJ3MdDARByXdqY68ZQ2FtBK/TP7DQEAyyHoJ2JYZCnkGfbd308Y6i2lf+sDItHypnoHwvwfiQJtVyc046CeDke1X3eDWzvUqqxOGdR7yqleQayUXo4RBuIVATvXoVTxGBPxqzqeQr/6C4M6z/lL2883FlEtH5pN5JmYbYt45PE/MX0mrqzenioGVfOTaABB84i30OwlXzWM1L/gj9TviKSEmFv5ifRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 IA1PR11MB7320.namprd11.prod.outlook.com (2603:10b6:208:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 10:18:12 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 10:18:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 03/24] coco/tdx-host: Expose TDX Module version
Thread-Topic: [PATCH v4 03/24] coco/tdx-host: Expose TDX Module version
Thread-Index: AQHcnCz4ZiVFmLmZwkuE/IZIhNL+V7WKypaAgAZgM4CAAIqdAA==
Date: Tue, 24 Feb 2026 10:18:12 +0000
Message-ID: <3e2e46c8a6e9e636ae30396f6e5f4907c02a83e6.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-4-chao.gao@intel.com>
	 <3a8feb5470bd964e421969918b5553259abdd493.camel@intel.com>
	 <aZ0Gm5/xpBnhOeod@intel.com>
In-Reply-To: <aZ0Gm5/xpBnhOeod@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|IA1PR11MB7320:EE_
x-ms-office365-filtering-correlation-id: a3b4cdcb-00b6-4539-e888-08de738e0431
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eXhsbDJIbm15VlBtaVA5Zi92N0QxYXlxRFA0cWFMYWh2cW1JK2tKUEU1QnEw?=
 =?utf-8?B?QUpPQ2drTmVrbDJTdXFoSDhFOEJ4TEhyWFlEekpDT2hrbnltejJRMzRzUVpT?=
 =?utf-8?B?bnFwVFRFRGhSMHViVjRQNXV2WWxiRTU4aUxuT3pLMEQvbkYvMXh0R3BTRTln?=
 =?utf-8?B?TUZJZ3VhTGdHQksvcXpmRG5POC84U0M0UHA0S0Nuazd5T0xrdEczN0dQNVcv?=
 =?utf-8?B?SW44M0ltZU9Jb1BaTVpTaGlJNG5oWlpjb09CaE9SS1NkK25STG9NZlo2aTQ5?=
 =?utf-8?B?SzZicXhnR25xaGptYWFzbkZBdzFvMFFVbTdobGF4bVJrcHdtbzJISUNlQkNq?=
 =?utf-8?B?KzhGS0J0Y3VrT2Z1Sk16aEtWRnkvNkU4Mmw3U1oycnRpTEFTSG8ydzdMUTJx?=
 =?utf-8?B?Zk5LM3VLeUR3MXdzZXg3SFAvNUFYTVNoME1GTDFsNzNYZTY3KzNLSUFhenhE?=
 =?utf-8?B?ZDc5VGdiNzJ2RGxUVVhKQ0dyQlhESldzM1FqVVV1YVNHOFJTUnQ2WU50R3JM?=
 =?utf-8?B?bHhzTHBid2JkNXhGRVNscCtPY2hoL0lQY1pTQWpZa1Zhc0NOTThyM2RYM0RK?=
 =?utf-8?B?UU9jOWMvVG4zemhNTDljYTVFUW9reEJkUmo2Wk0yZjQ3UmREbGM0L05waC9Y?=
 =?utf-8?B?REdOTXhTZWJEeEpUQk1OYjdxSjNyeEVQWUdST0tqQ1dZU2k1TjVnYUV0dkhI?=
 =?utf-8?B?UmZoNzdTZjhnZEQ2QkVxZ2Y1OURCQTBNT2M1dlN0cUdWS0tMOERBZ2V0NkVK?=
 =?utf-8?B?MVd1My90VXo4TldRYlRjOXlGaUxyYU5IQ3ordEFyalcxVXZmREVLYVB3YTZX?=
 =?utf-8?B?YkJwSEZUNDdGVjlQR0RaTzA2SjMrcDhPWWRDWUhNZkxmNjFoSjRSVG15NFV5?=
 =?utf-8?B?dkJaVGs5V05HOGZYZ1JtckYvVXFvRWJmZjM2Sk9tclRhWTE4NFlUWURQa1FK?=
 =?utf-8?B?WlIwNEtzcHE0cjRWbWsxcW5JUkpwRnJEVXBxdXp5UEpHWGIrdzRjSHAxQnMr?=
 =?utf-8?B?Q3VUeGk0RFZtNU9WeVZLbkxsVU5URE1ncUVjWEdqZDdSeW1LVmgrY1dtUVdW?=
 =?utf-8?B?RGdic1I2eXJkWWsxOTNsaFNReEFXc0pBTXZZemRxSU1rYU1YZGRnaFVrV241?=
 =?utf-8?B?WUtIOXdGSUhrM3I1a0NwS0hDdU9TYUVHc1EzT3BUK1MrczM1K2w5aGNMTnU5?=
 =?utf-8?B?RDdOMTk1WDAwZWhhdkQ3dTVHN1pxWmswcUsySklHdndRSmRWODZjMWdLSDJJ?=
 =?utf-8?B?bDBqTkRpSjRxcC9KQU5qOXFKU05RU2xNVGF5WHdkaUoyMVI5VjdXSTlmek5Q?=
 =?utf-8?B?Ky9GL2I5ZjVqMm40dXVjLzhmc3dPeFI1cmtseXV1MFAvYUF6SGNqS240RXZu?=
 =?utf-8?B?ZzlPbmxTVjR0dnduS1djRkJDQnZsVzZ5RzZEKzZmSTk2WG1Mc25ka3pTZEY5?=
 =?utf-8?B?U1l6NTVFS005bG9udVhkVHNNeEwrN0NrZkFFT2l4bmsxeGxnZmY0U05yN2pI?=
 =?utf-8?B?RWNPNFQ5U2RONUZ1LzJnT1FvUXZIUEFidStTUEt1bmlYTEJ0blJOL0dsTmxI?=
 =?utf-8?B?Vld2cjNmUWI2VkJUdmQyZG5td29hNnhDVWVLZ3ZLUGF0TS9VaHF3dmc4MWNx?=
 =?utf-8?B?MlI4U29QOTlBQk91WGVTZjBRNWF2bmFPV1NpM2JkKzBYVEVNZ3ZVbDd1MEp3?=
 =?utf-8?B?RjFSQyttWWFmSEdWZjFNNG1tM3hMMlN6SEpCdXVOd3FsbFFPdmVjNTk3VldM?=
 =?utf-8?B?cS9lU1NUOXZGK2VCWGxjb0NwK2cvbDByQlFoM0RmR1ZKNzBJRDNsZEFiZUQ4?=
 =?utf-8?B?THBEQm8rWUpIbmQ1RERmb29MVnVVV2dGRWhtbjNvcEFPQkxPYnBEUzA4VHBv?=
 =?utf-8?B?SUIweU5yOHhodXFENWtTR0pVOWEyenNhamVrWXgySU9oRGttUzB3UitqdTlI?=
 =?utf-8?B?YWFPb21Sb2RkeHBvY3pmVGZRSUVreVc1UTcvWUYySXBSL25SMU5oZ0o5NUpT?=
 =?utf-8?B?cDEvRTBjaXFjTUZUOGlSNGV6Vlh5RUVMS254K3N4UDNicDdma0gwTWxLTjhN?=
 =?utf-8?B?QUYzNTJNczcvWmxUQ0RGWi9XejFuN25kN2lSUjZDdjd1Q0FoZWhZMGQwY3Y1?=
 =?utf-8?B?YTl3bjFRclU0andNYmx1aXBkMEh2c3JtYzRCb3dsYmhzMkRORHBnK1ZPeGVJ?=
 =?utf-8?Q?lm8hRQ60iHHQaYLlC3QXV8I=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXE1bk1EdVR4VVpsSE1McmFxM3ZYNUNpS3Q5RzNtTUdjemw0TklOdTF3aUNB?=
 =?utf-8?B?NWZvS2xuTFM2NEpZcG1MWVhpNnBISTEwbEhMNjBybzlRdTJGM0xDYXpSUHRC?=
 =?utf-8?B?MkIzcGIyNmFRekNZa2JzR3Jqc1ZidGtCcnJHeHUvTCsrR0FETW95VC9xOXM3?=
 =?utf-8?B?TlJTcEl3NG5pOEtGME8rTjhQK0s4SFlkTEd2ZGpVSHdFQmgwS0J6bVlzcWFk?=
 =?utf-8?B?aGNDeWdYMElNTUdqcE1JTDBTUFQ5R3RmKzc3WWcvbGlRTURTRnkra2lrMU5j?=
 =?utf-8?B?dDFJbmpoUXJCRWt3Y0tnZGJnUDBtVDRBbVIyNTRjNm0xSXFYV0U1NHZldE9n?=
 =?utf-8?B?bnN5aXhKUTA2b3l2OVJMbTVRZ3AzYktGdFZCZFpGQ1owZkg2NmplaHRRS2JG?=
 =?utf-8?B?cnA5UlY5UThKdmp4dEExTmFNblg0bzhNcXdjUFdraGN5c013bG1mQy9nclpX?=
 =?utf-8?B?aG54Q2IrbWMzbzkrcDdPV25EMVFSZ29tOE9yRmxoTFFpYVdJQSsrVEZmZDVx?=
 =?utf-8?B?MVZCUEZEMENNNUkrQzBkZlZ3MEJpdllEZVdrMk50MEdENythYUZnWTJiSy8v?=
 =?utf-8?B?TDc3ajVDa3JWMjdtSjhZWFMrbEtCWlUxa2c0MzBzR2tIa1NtZk90Tk9yYVB3?=
 =?utf-8?B?cnpjcHcvcE1id2ozQ2JTbmVnZzhZbUlTUUVsRE9UaXdyVVNxSEhWbXQzQS9v?=
 =?utf-8?B?SFdpVC9ML2c2M2ZyZnIwR2Y0dHJJdzF1STBjUE9SSGdKTFZIOHZrd0dtcXo4?=
 =?utf-8?B?ZVVQVnZQcmN6RGtRbVBPVW5tWThYdDZMdXZSa2I4N2NKcitJbitsUm5oR2F0?=
 =?utf-8?B?WTdVMnp4dnYza0NQUE54L1k3VnBrRUVxaFdjaHZ1V0Ftc3pUQ2JGdHhxbENy?=
 =?utf-8?B?L21IMTdDWlh0VUw0Yzh3UnlvYXBoUHgrY2VRRW9pUERkbFRsOTZLb1dGdDZp?=
 =?utf-8?B?WmsrSjNuQ1RjcGQxN0RNQXEwVGpMU3pxeWdlZjY2YXA2d2FuRU0yUitwNkht?=
 =?utf-8?B?d3R2S0N4eUlCYlNmNzVkZVlRQk5HTEgxa1U2NkRQd3VucVBUckdsL3l4NS8z?=
 =?utf-8?B?U2txRW9vSDRmbjRJLzRHdnZUT2srK3FMQVM3eCtRTUdUYy9FSzVYeHI1STJm?=
 =?utf-8?B?NDJoOU5QMzdhcVFHUzdJWVpiV0FqdWh1MkQrS2JZNDh1bHllL1hld1o0dXhk?=
 =?utf-8?B?UHQ3V3ErbmcrbE8wYkt5eTR1VmhJd3haM01yYXhYbmlnZ3JLUHdoMDJDV3Vo?=
 =?utf-8?B?cWtvZElkM1MrcmhMY05yNVc0K3RsWnBzN3QxN1RNZkh0M0dxVlZmWHE5cWh2?=
 =?utf-8?B?N1VCVURlLzVCQ3NWSmlEQ2xXdVlYVnFvdmlvbm4zaTlrQVZGU2R3eFQxYlF3?=
 =?utf-8?B?ZTJVNkJLb3JZMGRJd1N0dHFlNXNKSWZOL2NzelloN2tsSTJ0S0QydFF0YnRW?=
 =?utf-8?B?bm5PRnFScUZXU0pmdm43RGFaUlIvbHR0TUpvMzNXT2lXMUZIaVNOeDdrd3gx?=
 =?utf-8?B?QTFxbklKczltU1RFQ0RFc2tKOU5CYy9WZGo5RjdkalRHMVlVeGc4MldFZ2xx?=
 =?utf-8?B?aHFYRTBlOTFzMkk3ZkQraWxKU240TlZCSkhkNitTaEJXa0FyTWNrTzQxQi9q?=
 =?utf-8?B?Tm42amZHVmdPQ0xzQ2Z5ck9ZMmcxY1Juc2t0KzZsc0RmUERMcWhON25oaFJZ?=
 =?utf-8?B?b3cvMGRIMjRsNEozUXlYUEQ0RGtnUDdCUTZFVWZpeUhCSFRyRUQ4OVlpRmJ5?=
 =?utf-8?B?Zks4L3pnMjlVQTdtZkRHOE91VzBiY1lFN0RoOE9qa3A5dk9mSk9PNndVcHRV?=
 =?utf-8?B?VjQxZUdzcGFvbDNqbFhybFF2UUp6WFBaZHZJUnUwT0ZXZTNMT3VualNvc1Zx?=
 =?utf-8?B?K3Q5TDd1ZEpWTG9wNXJRTXlEc1hEZmozN2hyc091T1l6M1h2UEdiYzdnbkpv?=
 =?utf-8?B?MjFSNGFCZFZadDdhZU1EUkVJVUszT0tMMnRpbUF4YnNNNXpLb28wYi9mSVkr?=
 =?utf-8?B?ZUVUMDQzSE1KS2I0Vm0yNHZ2Z1htSUFveVNtN1ExQ2s1U1kvNzJlNjRtOEt6?=
 =?utf-8?B?OFFHQVYxTjF1Qi9RRUo4WjVweFE2ZUZTRkhLMXZtc1N6aTMrMlMzNmJUWU5Q?=
 =?utf-8?B?SVBVZTF0OEN6cmdOMS9PUFpZU1hlZEF2QzZwSmN2dko5bC9pa3NsdDY1UHQ0?=
 =?utf-8?B?d3FpMnNhVmdMdE91YW9RVXN2Q1p3LzFvaHNLQXkzQzB0S2NQblpSZHBxUDlq?=
 =?utf-8?B?TjNRUThkU3FqWkZhbFUrZmZMS0dmanFDZ1hVay91TzVGNVZaVFVXNVpFSURy?=
 =?utf-8?B?azBMak5GdGFBaER4QXJ1V0hiaEJlVWZ4VkN6TGFzaTk0cmVETkZFUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CEBAFF3DDC11B41BBD0480A213C0D7C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b4cdcb-00b6-4539-e888-08de738e0431
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 10:18:12.6073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jhFctcWPczYyW5wRyJN/LDfuf4NkG/N3aJstmM+Pm/RXEQbADsz1Jhfuo11Z1Gz9kSqREoeQE6RdY2dZP7X2bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7320
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71607-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 574CD18537A
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDEwOjAyICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
RnJpLCBGZWIgMjAsIDIwMjYgYXQgMDg6NDA6MTNBTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBUaHUsIDIwMjYtMDItMTIgYXQgMDY6MzUgLTA4MDAsIENoYW8gR2FvIHdyb3RlOg0K
PiA+ID4gRm9yIFREWCBNb2R1bGUgdXBkYXRlcywgdXNlcnNwYWNlIG5lZWRzIHRvIHNlbGVjdCBj
b21wYXRpYmxlIHVwZGF0ZQ0KPiA+ID4gdmVyc2lvbnMgYmFzZWQgb24gdGhlIGN1cnJlbnQgbW9k
dWxlIHZlcnNpb24uIFRoaXMgZGVzaWduIGRlbGVnYXRlcw0KPiA+ID4gbW9kdWxlIHNlbGVjdGlv
biBjb21wbGV4aXR5IHRvIHVzZXJzcGFjZSBiZWNhdXNlIFREWCBNb2R1bGUgdXBkYXRlDQo+ID4g
PiBwb2xpY2llcyBhcmUgY29tcGxleCBhbmQgdmVyc2lvbiBzZXJpZXMgYXJlIHBsYXRmb3JtLXNw
ZWNpZmljLg0KPiA+ID4gDQo+ID4gPiBGb3IgZXhhbXBsZSwgdGhlIDEuNS54IHNlcmllcyBpcyBm
b3IgY2VydGFpbiBwbGF0Zm9ybSBnZW5lcmF0aW9ucywgd2hpbGUNCj4gPiA+IHRoZSAyLjAueCBz
ZXJpZXMgaXMgaW50ZW5kZWQgZm9yIG90aGVycy4gQW5kIFREWCBNb2R1bGUgMS41LnggbWF5IGJl
DQo+ID4gPiB1cGRhdGVkIHRvIDEuNS55IGJ1dCBub3QgdG8gMS41LnkrMS4NCj4gPiA+IA0KPiA+
ID4gRXhwb3NlIHRoZSBURFggTW9kdWxlIHZlcnNpb24gdG8gdXNlcnNwYWNlIHZpYSBzeXNmcyB0
byBhaWQgbW9kdWxlDQo+ID4gPiBzZWxlY3Rpb24uIFNpbmNlIHRoZSBURFggZmF1eCBkZXZpY2Ug
d2lsbCBkcml2ZSBtb2R1bGUgdXBkYXRlcywgZXhwb3NlDQo+ID4gPiB0aGUgdmVyc2lvbiBhcyBp
dHMgYXR0cmlidXRlLg0KPiA+ID4gDQo+ID4gPiBPbmUgYm9udXMgb2YgZXhwb3NpbmcgVERYIE1v
ZHVsZSB2ZXJzaW9uIHZpYSBzeXNmcyBpczogVERYIE1vZHVsZQ0KPiA+ID4gdmVyc2lvbiBpbmZv
cm1hdGlvbiByZW1haW5zIGF2YWlsYWJsZSBldmVuIGFmdGVyIGRtZXNnIGxvZ3MgYXJlIGNsZWFy
ZWQuDQo+ID4gPiANCj4gPiA+ID09IEJhY2tncm91bmQgPT0NCj4gPiA+IA0KPiA+ID4gVGhlICJm
YXV4IGRldmljZSArIGRldmljZSBhdHRyaWJ1dGUiIGFwcHJvYWNoIGNvbXBhcmVzIHRvIG90aGVy
IHVwZGF0ZQ0KPiA+ID4gbWVjaGFuaXNtcyBhcyBmb2xsb3dzOg0KPiA+IA0KPiA+IFRoaXMgImZh
dXggZGV2aWNlICsgZGV2aWNlIGF0dHJpYnV0ZSIgYXBwcm9hY2ggc2VlbXMgdG8gYmUgYSB3aWRl
ciBkZXNpZ24NCj4gPiBjaG9pY2UgaW5zdGVhZCBvZiBob3cgdG8gZXhwb3NlIG1vZHVsZSB2ZXJz
aW9uICh3aGljaCBpcyB0aGUgc2NvcGUgb2YgdGhpcw0KPiA+IHBhdGNoKS4gIE92ZXJhbGwsIHNo
b3VsZG4ndCB0aGlzIGJlIGluIHRoZSBjaGFuZ2Vsb2cgb2YgdGhlIHByZXZpb3VzIHBhdGNoDQo+
ID4gd2hpY2ggYWN0dWFsbHkgaW50cm9kdWNlcyAiZmF1eCBkZXZpY2UiIChhbGJlaXQgbm8gYXR0
cmlidXRlIGlzIGludHJvZHVjZWQNCj4gPiBpbiB0aGF0IHBhdGNoKT8NCj4gLCANCj4gWWVzLCBp
dCdzIG1lbnRpb25lZCBicmllZmx5IGluIHRoZSBwcmV2aW91cyBwYXRjaDoNCj4gDQo+ICIiIg0K
PiBDcmVhdGUgYSB2aXJ0dWFsIGRldmljZSBub3Qgb25seSB0byBhbGlnbiB3aXRoIG90aGVyIGlt
cGxlbWVudGF0aW9ucyBidXQNCj4gYWxzbyB0byBtYWtlIGl0IGVhc2llciB0bw0KPiANCj4gIC0g
ZXhwb3NlIG1ldGFkYXRhIChlLmcuLCBURFggbW9kdWxlIHZlcnNpb24sIHNlYW1sZHIgdmVyc2lv
biBldGMpIHRvDQo+ICAgIHRoZSB1c2Vyc3BhY2UgYXMgZGV2aWNlIGF0dHJpYnV0ZXMNCj4gDQo+
ICAuLi4NCj4gIiIiDQo+IA0KPiBUaGUgcHJldmlvdXMgcGF0Y2ggZG9lc24ndCBwcm92aWRlIGRl
dGFpbHMgZm9yIHZlcnNpb24gaW5mb3JtYXRpb24NCj4gZXhwb3N1cmUsIGFzIHZlcnNpb24gYXR0
cmlidXRlcyBhcmUganVzdCBvbmUgb2Ygc2V2ZXJhbCBwdXJwb3NlcyBmb3IgdGhlDQo+IHZpcnR1
YWwgZGV2aWNlLg0KPiANCj4gPiANCj4gPiA+IA0KPiA+ID4gMS4gQU1EIFNFViBsZXZlcmFnZXMg
YW4gZXhpc3RpbmcgUENJIGRldmljZSBmb3IgdGhlIFBTUCB0byBleHBvc2UNCj4gPiA+ICAgIG1l
dGFkYXRhLiBURFggdXNlcyBhIGZhdXggZGV2aWNlIGFzIGl0IGRvZXNuJ3QgaGF2ZSBQQ0kgZGV2
aWNlDQo+ID4gPiAgICBpbiBpdHMgYXJjaGl0ZWN0dXJlLg0KPiA+IA0KPiA+IEUuZy4sIHRoaXMg
c291bmRzIHRvIGp1c3RpZnkgIndoeSB0byB1c2UgZmF1eCBkZXZpY2UgZm9yIFREWCIsIGJ1dCBu
b3QgInRvDQo+ID4gZXhwb3NlIG1vZHVsZSB2ZXJzaW9uIHZpYSBmYXV4IGRldmljZSBhdHRyaWJ1
dGVzIi4NCj4gDQo+IFRoaXMgcHJvdmlkZXMgYWRkaXRpb25hbCBjb250ZXh0IGFzIHN1Z2dlc3Rl
ZCBieSBEYXZlOg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2FhM2YwMjZiLWFk
NjktNDA3MC04NDMzLTg5NTBlNTI1MGVkYkBpbnRlbC5jb20vDQo+IA0KPiBEYXZlIGFza2VkOg0K
PiANCj4gIiIiDQo+IFdoYXQgYXJlIG90aGVyIENQVSB2ZW5kb3JzIGRvaW5nIGZvciB0aGlzPyBT
RVY/IENDQT8gUzM5MD8gSG93IGFyZSB0aGVpcg0KPiBmaXJtd2FyZSB2ZXJzaW9ucyBleHBvc2Vk
PyBXaGF0IGFib3V0IG90aGVyIHRoaW5ncyBpbiB0aGUgSW50ZWwgd29ybGQNCj4gbGlrZSBDUFUg
bWljcm9jb2RlIG9yIHRoZSBiaWxsaW9uIG90aGVyIGNodW5rcyBvZiBmaXJtd2FyZT8gLi4uDQo+
ICIiIg0KDQpJIGZ1bGx5IGFncmVlIHdpdGggdGhpcy4gIFdlIG5lZWQganVzdGlmaWNhdGlvbiBv
ZiB3aHkgd2UgbmVlZCB0byBleHBvc2UgVERYDQptb2R1bGUgdmVyc2lvbiB0byBzb21ld2hlcmUg
aW4gL3N5c2ZzLCBhbmQgdGhlIGNob2ljZSBvZiB0aGF0IHNvbWV3aGVyZSBpcw0KdGhlIGZhdXgg
ZGV2aWNlIGF0dHJpYnV0ZXMuDQoNCkJ1dCBteSBpbnRlcnByZXRhdGlvbiBpcyBEYXZlIGlzIGFz
a2luZyB0byBwcm92aWRlIHN1Y2gganVzdGlmaWNhdGlvbiBpbg0KZ2VuZXJhbCwgYnV0IG5vdCBz
cGVjaWZpY2FsbHkgaW4gX3RoaXNfIHBhdGNoLg0KDQpJbiB0aGlzIHBhdGNoLCB5b3UgaGF2ZSBh
bHJlYWR5IGFkZXF1YXRlbHkgcHV0IHdoeSB0byBleHBvc2UgdmVyc2lvbiBpbmZvDQp2aWEgL3N5
c2ZzLiAgVGhlICJiYWNrZ3JvdW5kIiBpcyByZWFsbHkgZXhwbGFpbmluZyB3aHkgdG8gY2hvb3Nl
ICJmYXV4DQpkZXZpY2UiIGFzIHRoZSAvc3lzZnMgZW50cnkuDQoNCkJ1dCB5b3UgaGF2ZSBhbHJl
YWR5IG1hZGUgdGhlIGNob2ljZSB0byB1c2UgZmF1eCBkZXZpY2UgKGFuZCBtZW50aW9uZWQNCmV4
cG9zaW5nIHZlcnNpb24gaXMgb25lIHB1cnBvc2UpIGluIHRoZSBwcmV2aW91cyBwYXRjaCwgc28g
dG8gbWUgdGhlDQoiYmFja2dyb3VuZCIgcGFydCBpcyBhIGJpdCB3ZWlyZCB0byBiZSBoZXJlLCBi
dXQgbm90IGluIHByZXZpb3VzIHBhdGNoLg0KDQpCdXQgSSBhbHNvIHNlZSB0aGVyZSdzIHNvbWUg
Y29ubmVjdGlvbiBoZXJlIC0tIGFuZCBhbnl3YXkgdGhpcyBpcyBqdXN0IG15DQppbnRlcnByZXRh
dGlvbiwgc28gZmVlbCBmcmVlIHRvIGlnbm9yZSA6LSkNCg==

