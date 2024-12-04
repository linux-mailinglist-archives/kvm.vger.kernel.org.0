Return-Path: <kvm+bounces-33098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D75E99E4A28
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 00:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CED2D188318C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 23:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8669C19F49E;
	Wed,  4 Dec 2024 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LUlLcHaR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99C4165EFC;
	Wed,  4 Dec 2024 23:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733355606; cv=fail; b=Mxqfl5bd5lMQeIcaRqqqDFTYiSsDSdvao39X0neOi3eovJLRFOZ+v/GijamR5/Tqnod9bnW/l66NpHRLNrqKbN+op6L/lciDKdsPS1Z2exxirNp8/4rJ7De+O2la6zxygs6JlProKtpASx6zuAgmDbj6MNeiZ3mZ2Y5ZdS2qFXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733355606; c=relaxed/simple;
	bh=jv5fY5+Ch33fPg08yxtJ7FBazLlH0wYN23VMmAgxEZI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZT7WIf+Q6BI7ka6H4Kzfn6Ahr9jaXVoZ9knKURomgrHKjoyuOp76eSatCPKVuKw7ZRwij6zz0z3Q8fBm7ZEqK+k9O6H2waG8bZRvsU9Bnhx/aahlHsElcc/chFvUFl5SM32vPfMWhAO0nO37Be7fgJEzBXvaNyCXiz6QU/nJiyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LUlLcHaR; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733355605; x=1764891605;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jv5fY5+Ch33fPg08yxtJ7FBazLlH0wYN23VMmAgxEZI=;
  b=LUlLcHaRneH1gtU0dfOZm9M1AsFGXFXNapLIZA9vMYnshvSNbvvj9gGJ
   1uv8LfDcJ9Plm/+NgoAWIBJrH2m3Dnak1FQhD82oJC7fE5ZDyfQXPl2xj
   osz4eqRpqjSQs4A+5HaqBeshP3Nw4fpQwyi9CmDqUdLczlH4p/JC7jgov
   iGp6vvBpkdIqfzJFpV40N3AfXawosaFhKg58uunYg39makwfaz17PYYJN
   E2hVPBBBIvXOSk7IUUTh3dRjhKMugVLtt15kdJe65762vYxVI1KHE5RtJ
   k2zqMdARlQD/sTEM5NaurvKEXMHhZIi0je7tltPj1On/uHhwnWHsA6hNT
   Q==;
X-CSE-ConnectionGUID: 9lHMPAyYQjitwbJo9eeRdA==
X-CSE-MsgGUID: nqxLZilQQpCxYw7raF70tA==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="45033859"
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="45033859"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 15:40:04 -0800
X-CSE-ConnectionGUID: L/rWwbkZROaCnhhTMlKQOw==
X-CSE-MsgGUID: iOOzI8SITvm2TYyZbw0Q9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="93813095"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2024 15:40:04 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Dec 2024 15:40:03 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Dec 2024 15:40:03 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Dec 2024 15:40:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wHcR6vfu8FaMNmBD/2OMGT0Ofx1ONko4XoiKQhp/ksOF8E7v6OSUT12BkxIN1GwcCAzVg9PFj0HTZ3efBrMUX6rYWJ0NEhA8ra/NzaSShcxUUjvfUSzKV13cj5QZmFF/7GwwEOXjXV1Fg29XTc/ObZo+wShzD7ZgzdSwQ6vHcYuv/Xvdq0pfbVuZlS1liPMd9oRuIe+vMEnhKrqpso9qKjiKFrKea1VyI0KkfMjqDIlBczsVhqDBRQP/kMek8KVtyjzwV5NNZv6XLCcJcWhclaYziVUyflXO5DLuuzKuYpfZSQkPwboTY11MAIoV/3f0UMGBdfaDun5nBtgmcQ/Rdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jv5fY5+Ch33fPg08yxtJ7FBazLlH0wYN23VMmAgxEZI=;
 b=TkeFb7pZ5ZmqDYR8bDZ7uMnjhFSfy0cRCxi5UxuAzYiF+4YJKC1VnUSp0s5C3KORu8U/ZPwS3Mj1e97EjF3NTl6VQJALestIdHLYkp+wz+iX7Q+t/rOh6Nh+Lw5CH0E42QA/qnMTN1psPGbFd6+j4k2HhIJfBqpYGFmtqwKbKUiA8F7xL0bB1/52zTq2gv65TgIUU131hvg+ajyLZ/zUBDiBXh4rUEc7dMf1NNI110jvCgxlZQk99n762F/YmuapT5o9UCR5ucYUcDHfztQbp5wckK8DGvQf19lN8UUPzHC0JmtEA5msHhwFxEiNNP0XA2JTkeG8BzzXFojbVmbnsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV3PR11MB8482.namprd11.prod.outlook.com (2603:10b6:408:1bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 23:40:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 23:40:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Thread-Topic: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Thread-Index: AQHbPFI1CpXUe0dtwEa1D+tl1lrdQLLCpF0AgAiMhYCAAv0xgIAFNDOAgAAEoYCAAFbIgIABHPqAgAAckQCAAGbYgIAAUfgAgAAFaQCAAAVygIAAR3GAgAAL3oCAAMTRgA==
Date: Wed, 4 Dec 2024 23:40:00 +0000
Message-ID: <66f87df1ba2bfc399fefb2622965644e8017a0e1.camel@intel.com>
References: <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
	 <Z04Ffd7Lqxr4Wwua@google.com>
	 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
	 <Z05SK2OxASuznmPq@google.com>
	 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
	 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com>
	 <Z0+vdVRptHNX5LPo@intel.com>
	 <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com>
	 <Z0/4wsR2WCwWfZyV@intel.com>
	 <2bcd34eb-0d1f-46c0-933f-fb1d70c70a1e@intel.com>
	 <Z1A5QWaTswaQyE3k@intel.com>
	 <c9b14955-6e2f-4490-a18c-0537ffdfff30@intel.com>
In-Reply-To: <c9b14955-6e2f-4490-a18c-0537ffdfff30@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV3PR11MB8482:EE_
x-ms-office365-filtering-correlation-id: 74ea403b-acba-4add-0f43-08dd14bcf819
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UE9Dc2wzaFNDSEJvOTBVOTZDNERJOWVFalRoTENLV3BvWjlHR3pzbUhBVVFl?=
 =?utf-8?B?YjByd3gzTW5KV3VkYnJ5Mjk5eEN4djRDbTdIeXdGRjREbVQ1Ly9jaXNoVlBu?=
 =?utf-8?B?Qk84QWJqUE1wUW00YXVySWp4ZFlXSzM4djRmRXBScDZadXBuOGlmVWRxTnVh?=
 =?utf-8?B?b3JIWDZDamtKb0dhWEI2WnVHbVlqa09jK0luVDVRSVVuR3gvWHNJVzRNZjNK?=
 =?utf-8?B?YWk4NXpYYnVBM3dPSmNGTGErOHB1S3JrbGM1YjBXaXFHcDBHRlYyRnVWaWNa?=
 =?utf-8?B?clRIL29kYitvOUxvS1BQN0FPbHZzUThxQWRRbWNWbnp1cUsxNWkyMWg5NEdp?=
 =?utf-8?B?M2cwOS9jRnlITFZZRWxWSzFRUjhIQWZIZm9IK1lXcTVMeklNMDJ2aWsvVkNZ?=
 =?utf-8?B?b3lKcU5QRTFUZHFPQmt0NlJONk11eXhnMitqWEJQQVBITU1uUmdTcG92YTBh?=
 =?utf-8?B?WGR0a2dEbVhGdjhZK1FYT0J3ZTl0RW1UTjVJOUtoWHNyWXpkd1U3OGtpSHBr?=
 =?utf-8?B?SnF2Yjl2c0lQemZXVG12SGxWKytLci91WHlxQUxVMGFSdWx1MVpNWjFWa3JI?=
 =?utf-8?B?Q2krWjM2TDR2TDRnUUxFUWorTEhsSTZKY1ovWFpueTNxVUlhb2NFMGszMXJr?=
 =?utf-8?B?anUzbmRaQ1Nmdk0wckM0R0Y5QTRpbW9ydjQ3Z0gyQ0tBM3pKdEVwc1JwKzJq?=
 =?utf-8?B?eU5tejVqdHZwamFXTHhWL0Q2RFNvTVJuS25VZHFEK3dUemsyQWFRdXFIdmF1?=
 =?utf-8?B?N3paa1o2VDZOakZGK2J6bGdnNkN2Z3RISXR3SzE4WGtFUmRlN3lmMTFXbmND?=
 =?utf-8?B?U2xsQXpxWkxUWU83QkQ3eWJMcmtmTjNHdE02eXBrSGFpeTJRWnpOSkZlMUN3?=
 =?utf-8?B?VTYzQWwxYjlzQTgyRlpxTUVrOWQvZkdtQUxxUjB6ZzRndi91SGxrcTMxbERq?=
 =?utf-8?B?eVVPL2wweTg5TVVYTkdWM1laa1V1OUhZRkc0bFBvVGFMdUhBKzBUem5EMko5?=
 =?utf-8?B?L2g5NTZRODdidkJZN1BBZkd2aVdKZDFGTWlxN2toNXJOSnpmQW9MeTV3R3dl?=
 =?utf-8?B?SzZnbXU0ZndrdVJ4Vm9aN0RhSE9jUk9wbytnMXBHN2U2SVdKbzY1WHZwdWFH?=
 =?utf-8?B?RXdtY2NEaWkvU05BUUd6cStwaXR5VjFaUHdSNktlalBIeEhPWk53Y1h5cU9p?=
 =?utf-8?B?WEdtSW5WNXdRakFSQXhVUkJpa2NkbE54UTh5V3RwZ3h1VURmL2xleE9RR0hO?=
 =?utf-8?B?MEtTTEkrZUd0R2lyTVJkc00vQWJMOVRObHdiOGdRUGlyT2VseGJRcnJzQ3J2?=
 =?utf-8?B?dzV1VlNXdjFQNWU3LzNJK1JEbU1IeEU3a3VzcEVyVUtLRUpkQ0Q1RWpFbnpG?=
 =?utf-8?B?SE8rUHhCZUZxbjUyMjJrL25qcFg4UUdnb0U4YnpjSndhRnpNcURLOU1Db2tS?=
 =?utf-8?B?VTY5VmpySW9XT1BiZi9LYkRiWVUwM1ZnQUMvMW9PaXF5OC80Z0I2NFNhNjRL?=
 =?utf-8?B?azVkL3FFNEtyZ3NndkI2dUROSGwyeVYxK0xJYlJLQ2pXNHBadjhxM1k3RFFs?=
 =?utf-8?B?dWpBbktIb2pybzFxRXZtYU5WMVM1RnBBc0xXVDdCamNGZmxWMS9ERmwrRjFj?=
 =?utf-8?B?dm9tZHlqVU1TSHZMTjNuOFU4Wk9DZVpKdExYWldyUVlvOHZETWRkUEtpMXV0?=
 =?utf-8?B?REM4T1dubFRTQ1RvSE51b3A2VkxIcXlnSjU1ZnNOTmFkU29MUTN2emNGM0pl?=
 =?utf-8?B?SFkzUFExM2habEhQb2Jkb29BQ1lHb29IeGhmNm5ZYkd6OXJ4V1ljdFkxa2Nj?=
 =?utf-8?B?QmpvT290NE95dE81QWVKNVgrb3duVnR1WHhJSzQxZWZzN3hWK0ZYOXhsaTEr?=
 =?utf-8?B?SkJrclh1OFQyVDhMZTI2QlJxckcwRnBZeURTMWFnRFpGMU5PMHZnSVFkMndC?=
 =?utf-8?Q?R+NwrEj+oRM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzhscjJUK1Y1TExUVk9CZ1l3K1FSZmZ2emY0VjJZWkxCSk5rNngvWWxnYWpa?=
 =?utf-8?B?SkxhVkhkWlVydENFYlRSU0NmV3hqa0dYaENtWUV2OU9FMjNPbkEvdFpEN00y?=
 =?utf-8?B?dzRVSWxnMVBWUVRXZFJ3c0lNd1BpYjYwZ0pIMUZlYUMzbWR2VnpYc3lndG0z?=
 =?utf-8?B?ODhoa2YwclgweE40OE9aV3FDdFpQa25obXp5NndyL0lWMVRHT2VtM3RoM0tX?=
 =?utf-8?B?dG4zQ0l5VzBPRVl0eWttRGIyZGV3VVZSa3pTd29VZkVRQ084a2NudGhlYlhD?=
 =?utf-8?B?bDUrUUMrSXZHZWllZjFlcHhCT1hlWDlHWXM3MnA5RENMbGVwNTY3R3RDcXJ6?=
 =?utf-8?B?SEJJc2g5cDZMc3N2UXhvTW9aU0pxRWc0UGJ4VUJLUVlCc2M0YjdIa2VXaDFW?=
 =?utf-8?B?WjAxREEvUy82bEJJVVc5MGtlWEo3R2hUaTk4TzFsbndUUGRRQXkzYXJkK3lm?=
 =?utf-8?B?R284akNpa1dKMkxsZW9FekdIZS9DVGFlUWwvUm8reWRlajBSd09DekZJVWJH?=
 =?utf-8?B?c0ZzczRkbmwvZ1J4VzltQ3MreDlMeDZTcmI1UWEzY2I3RlNOUkZJck9vcVpV?=
 =?utf-8?B?ajUrK2QrSHFxVXRFM2ptWU83V0huYTRzQ1VYb0RNMEhNZkpVZGhnSGwwNExB?=
 =?utf-8?B?VnRDYVRmMWpsOTRRYkdLYXdhZnZSemxPWjltSkl2OU54QkNVZEVZZzRNQjIw?=
 =?utf-8?B?MVBCNlgrY1huMkZjNnBFNGpQWUU0ZEJ5QVpaSHNHbGtCRnhXa3ZjcTJZWURX?=
 =?utf-8?B?dUtiSUhjcENoRm5uUXRSdTFoMmdSZktXTDIweUpYSTVqZEg2TTd1MThseWdi?=
 =?utf-8?B?WW5RVnNiY3AwKzVqdDJuajBZbGdaZzNOS2xJcy9wbjJOL3hhT2NVcDcySU1N?=
 =?utf-8?B?dHhhZjA2cWNZVmJjWjFqT2J3bTFmNG5xKzZqMU1BZEMrTjFoVTZVYlNmS0pw?=
 =?utf-8?B?cGY3MnlZMGVXUGFVdXFrSTN3NEl2YkhPUW4xRmRPczVpajgzZ015MWxGd01B?=
 =?utf-8?B?NU5JTVoxQURLSTJkLys1VDA3dStTeEtMUUJjTEhNNEJCem1laERsZ25vbW5i?=
 =?utf-8?B?ZkhHWDNPTUYvKzV4ckNhSFFSSDdhdjhpRDlzNTlTaDd5cGhOSUxPc3VKUldw?=
 =?utf-8?B?emlReWlvaHlnSWJPMjZQS0lFNlFaaG5zREx2YVBjQllsOWJRd0tjNXJIVDBC?=
 =?utf-8?B?UktPNjZwbHllN0w1c0VLSHV3M2hwci9WRUYwMnF3dEZWKytoNmhrQVIvR0ZR?=
 =?utf-8?B?WUhMMkU3K1VMTDRXMlpJYUprV3dqZmR0N3ZRSDFBSEM4TmFkZm5YN1VQNE9B?=
 =?utf-8?B?Zmgvb0xVeXBFSDJ1V2dVUGxOWEsxT040L3FXYjh4Yy9tWk04WitRRExBY3B0?=
 =?utf-8?B?U3V5eHNZY29wRy8rY1JxWk9OTTZOYkdkUm9sdm16K1BzOEdTcXMzRHcrMStw?=
 =?utf-8?B?QU00RXpZV1Q5UHhSUXdpazdYdCtoTjJsbUlxVlI1N3JQRlBvL1V3akJzQ0E4?=
 =?utf-8?B?cVNwdUlxdVU4YnlKalgvTW5ocWg5YTg3S2l1bEk3cTYyN2QrckZ4SURYSkFW?=
 =?utf-8?B?elJDajJyUkl0VU8wbmQ1eVJBdlNNN0dQbG1UMmhxajQybGtCc2ZQdHIzTHFa?=
 =?utf-8?B?eEE3TnpQdlpCbitqRi9GVmwwSWdha0U2NnVYNFlQTWZSRjR5b29lcFkzaXNo?=
 =?utf-8?B?cVFRODVCcWUwWGxjUmhJelVNOXZTak1yWTdrc2RIaGZERlczbEZHY25sU2Z2?=
 =?utf-8?B?U0dnd2p1bzRsR3JKOXR1RUtOVnk0OEZMQWk0VWhqYjViRHcrT1hWNnNEUWEv?=
 =?utf-8?B?NHlCVE5rMU8yMlpGbEltWVZmS0RFYVdaMmZKKzlCNmhCQVlrQ0NIVnBQVG16?=
 =?utf-8?B?bFJ2SUxtMWhzRGlKaVl3RVluZDIwOXBXanFOcXlqZWhDSkNDS0ZHdzBjTXJO?=
 =?utf-8?B?VnM0U2ZVVXBRdzlMUnFLT0pYa0o4UzRnUWhnN2JENlo4dmNvSDlTci9xekQ0?=
 =?utf-8?B?UlNqS2Vnd2F4YWZVUzRnc0R6K2ZSS3Fab3hsc2lGRHZBOU0yN2ZBSUZPczNi?=
 =?utf-8?B?SmFOVmkxWEdjQmxPRUdpa0JsRkVJOGtwZHROTzFzdU5rdGRkZWt1SEFaS1Ay?=
 =?utf-8?B?b1lRVDNvZjVWUGtVR0hPM1gxNmJCQkZBcU12OTZaNklzRzhmeUV2eGxCQ3dj?=
 =?utf-8?B?bWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D46625EA2932B14883CEFCB5018787CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ea403b-acba-4add-0f43-08dd14bcf819
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2024 23:40:00.4816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lsWOG/pICR6xJ3qE2SZuWrCmBOeQMbkpd6IjAjlZ6yySSHxWkQVnF6I47X6fFIjlZZ2XqfoVGweDRaujaYsZsYolTm1W9+HWiADi5xkvLd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8482
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEyLTA0IGF0IDEzOjU1ICswMjAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiA+ID4gPiANCj4gPiA+ID4gVGhleSBhcmUgY2xlYXJlZCBmcm9tIHRoZSBjb25maWd1cmFibGUg
Yml0bWFwIGJ5DQo+ID4gPiA+IHRkeF9jbGVhcl91bnN1cHBvcnRlZF9jcHVpZCgpLA0KPiA+ID4g
PiBzbyB0aGV5IGFyZSBub3QgY29uZmlndXJhYmxlIGZyb20gYSB1c2Vyc3BhY2UgcGVyc3BlY3Rp
dmUuIERpZCBJIG1pc3MNCj4gPiA+ID4gYW55dGhpbmc/DQo+ID4gPiA+IEtWTSBzaG91bGQgY2hl
Y2sgdXNlciBpbnB1dHMgYWdhaW5zdCBpdHMgYWRqdXN0ZWQgY29uZmlndXJhYmxlIGJpdG1hcCwN
Cj4gPiA+ID4gcmlnaHQ/DQo+ID4gPiANCj4gPiA+IE1heWJlIEkgbWlzdW5kZXJzdGFuZCBidXQg
d2UgcmVseSBvbiB0aGUgVERYIG1vZHVsZSB0byByZWplY3QNCj4gPiA+IGludmFsaWQgY29uZmln
dXJhdGlvbi7CoCBXZSBkb24ndCBjaGVjayBleGFjdGx5IHdoYXQgaXMgY29uZmlndXJhYmxlDQo+
ID4gPiBmb3IgdGhlIFREWCBNb2R1bGUuDQo+ID4gDQo+ID4gT2ssIHRoaXMgaXMgd2hhdCBJIG1p
c3NlZC4gSSB0aG91Z2h0IEtWTSB2YWxpZGF0ZWQgdXNlciBpbnB1dCBhbmQgbWFza2VkDQo+ID4g
b3V0IGFsbCB1bnN1cHBvcnRlZCBmZWF0dXJlcy4gc29ycnkgZm9yIHRoaXMuDQoNClRoaXMgdXNl
ZCB0byBiZSBob3cgaXQgYmVoYXZlZCwgYnV0IElJUkMgUGFvbG8gaGFkIHN1Z2dlc3RlZCB0byBz
aW1wbGlmeSBpdCBieQ0KbGV0dGluZyB0aGUgVERYIG1vZHVsZSBkbyB0aGUgcmVqZWN0aW9uLiBC
dXQgdGhhdCB3YXMgdW5kZXIgdGhlIGFzc3VtcHRpb24gdGhlcmUNCndhc24ndCBhbnkgVERYIHN1
cHBvcnRlZCBDUFVJRCBjb25maWd1cmF0aW9uIHRoYXQgd2FzIGhhcm1mdWwgdG8gS1ZNLg0KDQpX
ZSBhbHNvIHVzZWQgdG8gZmlsdGVyIHdoaWNoIENQVUlEIGZlYXR1cmVzIHRoYXQgd2VyZW4ndCBz
dXBwb3J0ZWQgYnkgS1ZNLCBidXQNCnRoaXMgd2FzIGFsc28gZHJvcHBlZCB0byBtYWtlIHRoaW5n
cyBzaW1wbGVyLg0KDQo+ID4gDQo+ID4gPiANCj4gPiA+IFRTWCBhbmQgV0FJVFBLRyBhcmUgbm90
IGludmFsaWQgZm9yIHRoZSBURFggTW9kdWxlLCBidXQgS1ZNDQo+ID4gPiBtdXN0IGVpdGhlciBz
dXBwb3J0IHRoZW0gYnkgcmVzdG9yaW5nIHRoZWlyIE1TUnMsIG9yIGRpc2FsbG93DQo+ID4gPiB0
aGVtLsKgIFRoaXMgcGF0Y2ggZGlzYWxsb3dzIHRoZW0gZm9yIG5vdy4NCj4gPiANCj4gPiBZZXMu
IEkgYWdyZWUuIHdoYXQgaWYgYSBuZXcgZmVhdHVyZSAoc3VwcG9ydGVkIGJ5IGEgZnV0dXJlIFRE
WCBtb2R1bGUpIGFsc28NCj4gPiBuZWVkcyBLVk0gdG8gcmVzdG9yZSBzb21lIE1TUnM/IGN1cnJl
bnQgS1ZNIHdpbGwgYWxsb3cgaXQgdG8gYmUgZXhwb3NlZA0KPiA+IChzaW5jZQ0KPiA+IG9ubHkg
VFNYL1dBSVRQS0cgYXJlIGNoZWNrZWQpOyB0aGVuIHNvbWUgTVNScyBtYXkgZ2V0IGNvcnJ1cHRl
ZC4gSSBtYXkgdGhpbmsNCj4gPiB0aGlzIGlzIG5vdCBhIGdvb2QgZGVzaWduLiBDdXJyZW50IEtW
TSBzaG91bGQgd29yayB3aXRoIGZ1dHVyZSBURFggbW9kdWxlcy4NCj4gDQo+IFdpdGggcmVzcGVj
dCB0byBDUFVJRCwgSSBnYXRoZXIgdGhpcyBraW5kIG9mIHRoaW5nIGhhcyBiZWVuDQo+IGRpc2N1
c3NlZCwgc3VjaCBhcyBoZXJlOg0KPiANCj4gCWh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9a
aFZzSFZxYWZmN0FLYWd1QGdvb2dsZS5jb20vDQo+IA0KPiBhbmQgUmljayBhbmQgWGlhb3lhbyBh
cmUgd29ya2luZyBvbiBzb21ldGhpbmcuDQoNClRoaXMgaXMgYXJvdW5kIGZpeGVkIDAvMSBiaXRz
LCBhbmQganVzdCB0byBoZWxwIHVzZXJzcGFjZSB1bmRlcnN0YW5kIHdoYXQNCmNvbmZpZ3VyYXRp
b25zIGFyZSBwb3NzaWJsZS4gSXQgaXNuJ3QgaW50ZW5kZWQgdG8gZmlsdGVyIGFueSBiaXRzIG9u
IHRoZSBLVk0NCnNpZGUuDQoNCj4gDQo+IEluIGdlbmVyYWwsIEkgd291bGQgZXhwZWN0IGEgbmV3
IFREWCBNb2R1bGUgd291bGQgYWR2ZXJ0aXNlIHN1cHBvcnQgZm9yDQo+IG5ldyBmZWF0dXJlcywg
YnV0IEtWTSB3b3VsZCBoYXZlIHRvIG9wdCBpbiB0byB1c2UgdGhlbS4NCg0KVGhpcyBpcyB0cnVl
IGZvciBhdHRyaWJ1dGVzL3hmYW0sIGJ1dCBpc24ndCBmb3IgQ1BVSUQgbGVhZnMuIFdlIHVzZWQg
dG8gZmlsdGVyDQp0aGVtIGluIHZhcmlvdXMgd2F5cyBidXQgaXQgd2FzIG1lc3N5LiBUaGUgc3Vn
Z2VzdGlvbiB3YXMgdG8gc2ltcGxpZnkgaXQuIFRoZQ0KY3VycmVudCBhcHByb2FjaCBpcyB0byB0
cmVhdCBhbnkgVERYIG1vZHVsZSBjaGFuZ2VzIHRoYXQgYnJlYWsgdGhlIGhvc3QgbGlrZQ0KdGhh
dCBhcyBURFggbW9kdWxlIGJ1Z3MuIFNlZSB0aGlzIGNvdmVybGV0dGVyIGZvciBtb3JlIGluZm8g
b24gdGhlIGhpc3Rvcnk6DQoNCglodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDA4MTIy
MjQ4MjAuMzQ4MjYtMS1yaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbS8NCg==

