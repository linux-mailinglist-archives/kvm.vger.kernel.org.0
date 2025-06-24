Return-Path: <kvm+bounces-50582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 471A7AE7236
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF1B11BC319D
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C8C25B30C;
	Tue, 24 Jun 2025 22:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GeLbO/uH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2C6257422;
	Tue, 24 Jun 2025 22:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750803745; cv=fail; b=TkmakHPLDQiR1tYtX0KuXi4zO0leElgrIzkzSlSnR+iPljeseoR5igMtTdF4QA1xYYAsh60K6Q1IM0Pe1DyPEkjFelGUxy+0v4g2jANdXGQI0fbEkmyuqjn7XH5Gcfdsw9B9PqCCdZKEzOFKK1504so0h6oYP7F7B3Mz4ub7QUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750803745; c=relaxed/simple;
	bh=v+KBtLUmL9V9EzKS/cxyvavtijIgc87Z/t4U8p8/yPM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QM2ghYBHE2L0UYxN0PCp4IQbKi1Bvufq810W5C8f+Z76dM/p89eGUe2N4KbDbkmuZKi1xSCRxuG+Ry1K2Gmm1VYdpN/aCOWU1FF5ESUp11L/qySG6ukJajb6IKYLeq+hEomR6Tmj/X3AXifxU3WfAmKo1JnsOZ+sE4xPW3vp43c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GeLbO/uH; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750803744; x=1782339744;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v+KBtLUmL9V9EzKS/cxyvavtijIgc87Z/t4U8p8/yPM=;
  b=GeLbO/uH//CErgJ7EvyA9FT+L/yMzWZdXlj8Sk5oAIxz/qrqM/AijmsY
   96hrV4vl9ARiYowTe+NJ8UTG0a3CpXSkcBgwN8oxqKAXN/J98DxpsskIq
   WYUf38p/SJTwVGfJWJHghTs16KMU7G7a9j7q6MRrHAAauW7XXwKvPH9Dc
   jF3PqqBIMaZOxZ+Cd2x3lMB/fH+K4OGpFezcZh3WN3rTzi5cmgQnBhwTu
   B/tBZK0ywsHi4FkmJ3tTlfPIYcd8svhuAuxaDzRMcVYTHF+yZ5p3O9zyo
   IGIq/gDVzmeRnQxaZ0niVtZ31u2LvRAx7H17YlKT3M/S9VqtLRYv+lenA
   w==;
X-CSE-ConnectionGUID: Jk4kcykvRB2LJUQVHym3bQ==
X-CSE-MsgGUID: kVVK55uMT0+e0zlYVA3BnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="52293101"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="52293101"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 15:22:23 -0700
X-CSE-ConnectionGUID: akszEYPHRmOYE4IgP+9uuw==
X-CSE-MsgGUID: lFYF3v8ORk6vvx75nmTkcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="152208396"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 15:22:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 15:22:22 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 15:22:22 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.53)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 15:22:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=arkkpgwrvgpcasVIBykiLB8QG1ADm07lOKOT+1UHe5vA3Sa48pl7F+9HML9lG0uTjjVcayeh7nt8Kg4SV0J64AgZnD60ECmI4VQ2TtgvXlziDL99CW+V7FK4RNCdX9nzAm8yvDf9Rotzolc7hCue59cqc2vqWkc1ThvHp7Id/wjZo+b8a/FbJP1TwypcbZFInJFcRO8gRI4DuSmjQ/zC7ikfPtCTIQIo+CxJf/9otqyzZMXahhlxOqHRvqYbTU9b6JLlxIYOFOX5fA+46oRUXvdZCdWf24cj3n7Hv9asUh0sMm9N0em7PmpSSZUbGNKwLGfFgyKTEXQhB6S9jlcItA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+KBtLUmL9V9EzKS/cxyvavtijIgc87Z/t4U8p8/yPM=;
 b=E+kLGQ1or96qcct9N0gf1Bn7XvrTqSKF/b8llW7M9dHcugOmjzTYHW1w0z5s9GVXu1cc5PP9YwZUM7EwrfZyiSuAK9l3eJgBjTmf6OrMlef+JQ04B6U4Wkr34ktDX0ZDbuVqR7A6Wk39maOumdZK2jKMpWRGB83U27KQ4n29ZFbxB52MlnEjfd0BKfANdO4VaZRYZEjHUu9BU9jJGK6P4YWI3TfmrkuuFau719iEJ7d9sWsomBT4+ALNy5qzV9Y9zQtSSjN8Mm+gZWzQI0nanIu2DyQJWMPGKdJNdYLSAtmFQt/pzTTmoiDXAxnfldSw7KeNVjvuS7sV1VPse2Bxug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Tue, 24 Jun
 2025 22:22:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Tue, 24 Jun 2025
 22:22:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gADAwICAALtLAIAADtCA
Date: Tue, 24 Jun 2025 22:22:18 +0000
Message-ID: <7a94595b5298a89f527575b4e7b963883939c102.camel@intel.com>
References: <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
	 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
	 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
	 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
	 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
	 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
	 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
	 <aFp7j+2VBhHZiKx/@yzhao56-desk.sh.intel.com>
	 <diqz7c10ltg3.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz7c10ltg3.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5176:EE_
x-ms-office365-filtering-correlation-id: a9ceaa58-a123-45a8-c28e-08ddb36d9504
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WW8zSEtQSTUrb3hWeVZPUyt1cjRDNk5QVnB3RktzaEF4UnYxaDAxNXhaazVP?=
 =?utf-8?B?NjhwNEp6WStBa05DT0RjYWdOWjk2TFVRMzB2aTA0T2grcUFiNWtEazFuZ25N?=
 =?utf-8?B?M2MwS1dteUZuc3VYTG0wd01ib0pSME9DOStIZ25xdkZ4Ym4xWURCbWNKZVB0?=
 =?utf-8?B?cDZVdW5WSUg2RmRNU3J2eDlxcUxMT3dMR2RiVnpLeCtNQ2VjVDFkdWpzem56?=
 =?utf-8?B?QzR1cnY4N2tUZlpMYVpDeVZENWgwYWtWd1FRcTNGQUE5dFA0OVpmWTdMR1c1?=
 =?utf-8?B?UGZlUEZJcmJEZFY2Q0xUS1Z2K2V6RFRVZ2VoQnpRMVdiZUF6eGJkYUZPNEg5?=
 =?utf-8?B?eWl5clNLbUw3S1p3bkNuSlJhWUhCdEFiYkRUV1B1TU5KeXRCSTdydGlCZ2xG?=
 =?utf-8?B?bkVuc0dzWW5HdnJrL1hQNHhOeGtXRlRjWWlEV1NJZzBlMEU3b0RnYlREQkwx?=
 =?utf-8?B?WjlvU2hOam1kOWp0aE9KL0RLd214WVpoZTU2YUxydGN5SnZSOWxvUVFhRFE0?=
 =?utf-8?B?Q0dkV0VMdTNCUzB3SnJYemx1S1NPbnczUnJXVjFudzljaEVjeFhOZlRWZ2g5?=
 =?utf-8?B?eDc2RWRUeE1qQ2syL1lWWHl6RDdHK0U3NitxNUdBZmFVWlhMeWRZV2pINVlB?=
 =?utf-8?B?KzhxN0tub01samlYdHZDWk5IQS9PaDZjQ2xWVEJQdHhySEFTdkF0TzRVeVgy?=
 =?utf-8?B?UkRTYjVLZUhwOXpudFZUTGtabVhmTEk4dzB6bHpOQWRaV2ZVektVdVcwU1Fu?=
 =?utf-8?B?L1RrRWRpeXA4b3JLYnh3VGtXZy94YnhjYzNQdzYxb3hRMzUxQXl4NHI2ajV1?=
 =?utf-8?B?OWpGc0NoQzRsNjUxbGtzS1V0djRLdmtnek1XYU1TM01RYTlmblRNRDR2U3Z2?=
 =?utf-8?B?Nm0wbS9hWkswa3FmTzRaQlFZb0FOdFhLVE1QSURoV25oa0NiNmJjTy95OWJV?=
 =?utf-8?B?ZnltY0x2UExDd1lZQXNvbWZ6bEJ4em9JNjRpek9PZ0wwWjN5dEViQXNyS1Fl?=
 =?utf-8?B?QVp5RmRFdld0WW81R3pDZWxxUUxqa240RDFDM3ZwYVRVTEtNWHpJaFdpSWlC?=
 =?utf-8?B?N3JlNWJWanlmUzYweDc5VjhOWk5kdnRCYll6UC83Zk9Zd2ZFUXZ5OGFwU1Fz?=
 =?utf-8?B?SzJqZ1dGd0M4dFBvN2VGT0dWVk9mZ25lLzBKTnVqTVdaSXc1aEc4VEZMWTJJ?=
 =?utf-8?B?SDg1aWdQU0JhVGFjSmsvdTV2a0xkbm5JVEZzMElVZEhQNTgrR2xmaWFyaG9r?=
 =?utf-8?B?bVhLci9lMm5DOUlkL3puNjBWcGpaWDBzODV0Y0RJcFBLalNEU0pOMGV5N2pL?=
 =?utf-8?B?NkhpZ3ErUWJrVDlkQVdOQ1VqUHUyeC9uMk42bmlvaDUwdmd1cXRXd1dvWlVR?=
 =?utf-8?B?SWd1V2ZYRExiVllzTDdldjgxelk4VzhKek1qYlBScGI2SVh5MnJ3cFl6VjFZ?=
 =?utf-8?B?b2ZNeER2S0VHUGx0TzljMGZzWlU3QUpEZmVVdlNTcUZaYjNDOGY0d3BYNUpm?=
 =?utf-8?B?U3NVN1dFVi9zWHErQUNQUXlNWXBYT093ZHZueEJRdVZmYWZRWVNFb251ZEFy?=
 =?utf-8?B?UHFPVWZSTjIzOE5rS0xUcXVHeVVzcHNNcEE0OWtvMUU3S0sramdDKzdBMENw?=
 =?utf-8?B?OWhwWk51ekIyQ2hGRVRlRkxoVldSZGMySGNLeklkcVF0cWdDMVZVWFBHL3c2?=
 =?utf-8?B?cTErNmhiV3FsVVdYRG1MV09SdytnaENsb3FPNEFtRkQ1VGR1QzMrci9kTkVr?=
 =?utf-8?B?ejN1SkpZR3hSZ3RsQmQ0aGxBQTBXSExOMkIwM0pzdFBZOFhwU291TW1VS1M1?=
 =?utf-8?B?UTFWdVlJT3hUV3hWWU5GaWxnakNnTS8rdmFrYWpjY0NvUUNLTE1xT3dBWnpV?=
 =?utf-8?B?THRJb0Q1V3o5ZmpDSGJVcmhZNmRaSXgzVW9DNXE1YnZHU0ZWMURLbTQ0ZXA2?=
 =?utf-8?B?RUhpNXpBd3VGYjhCR1VmK09TVS83cG9zdlZPY0RuRXNvc2Mwb05yYllCTCtW?=
 =?utf-8?Q?eQ4U+/msGchTcXbjxt9iBGHbWydUWY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1NTZ1VxdDVuZXl2Vk9SZmRTWFpxTGZSRmFpUWd1RnBMbnAvaURQelZ3cThI?=
 =?utf-8?B?c3QvcmFPamZPak1NRzBNZGhBMFR6UXFaWmg3anQ4T2VPYXVVTGIwVEZPOWFp?=
 =?utf-8?B?ckRmd3c3UDJRcEo4VVp0dEJDOVBrWUlQWEhXOU5Wa2V1cUp1cG1MbXRuckVU?=
 =?utf-8?B?QlFRZGc1aFZtNXFuYjJEeXhIYzNaSVN3T0czNXNqODdabjBUVTlvNjdZMS9W?=
 =?utf-8?B?RHM3N20yK09lNGtLaXR1MTRKK3JKV3JWdGRNOHRtSzAyNG1WNzFoeHZlVjdj?=
 =?utf-8?B?cCtzL3NQSlUrNFljTEVkUmNCL1RESGlyTmp5aWl3K3kxc3h3VldXbDlyTzVM?=
 =?utf-8?B?cXJHYzZNYUs4NjVQZVNSMHZSK29hQmduWFcwTTdpaGNGU04xWWRZVjdjT1o4?=
 =?utf-8?B?bUo3cGhPVnBmWEJzeHJIbXhSdDdpTGxXaFVqRXhZWUZWUXNYcHFManBua2hT?=
 =?utf-8?B?a3pqZW4zUTJ6eU1pa2VyWGJpVmduRHZWekdvUW1CK1N1WUxSOHR4eDRONkFo?=
 =?utf-8?B?TTEwKzBYbU9oa0N3N0c5RFZldlkzcnRMS283UCtDVU9iL0thSnkySGRFbHlP?=
 =?utf-8?B?YnpHU2hQMUJzNk1vNHVEZ0tUMnV3M2ZpR1hHK3ZlMU9FQkxEZkcvbzNWaHF1?=
 =?utf-8?B?T2xCQ0w4RWIvK0kwdzYyM1dlWE5CR3dkblRVcUN3US9tNzBZNXZHYXMyMU5H?=
 =?utf-8?B?bS9xanNISmVoU0RxK3BGTTNlbHpUSHduWkhDK1BHY0hrOVJOR1Z3bHJ4Y3BP?=
 =?utf-8?B?S295N0JvN2ZOUmE2SitObFNoWlZTQ3ZOQWtlRmxSMHFkZERGWEtNMG1vdy9B?=
 =?utf-8?B?Z2lWb3YwbFpHSGhLNk1vQUN1Q3NyOUUyS2E5eEszNFA5RDRDN1paV0luV0hy?=
 =?utf-8?B?RmMycURCbTJ5bFlvTCt0WlZQRkhDUFRscFlGcE52SHhVOXd0bFBIa1M4MDhl?=
 =?utf-8?B?cFFKYWRiR2lGeENsZGJqVEQweTRyWlhhbjJ4SHV5QVEzUWIwbU1yNmdYb0hn?=
 =?utf-8?B?S2V1OThQaHNvOGJkSVBIV2R0TjRaRmFkZ3ZYZEtEUE9aTUFIM2NCZ0F2K3Vs?=
 =?utf-8?B?Nk5ZTUkxZVZGWm9ndFIzVUtxNW42UGFTMFdKU0R1WVJLc0YwbVZNbDJaNEYy?=
 =?utf-8?B?Szd5OXd3TWVaS3p1TnladjJEVklVOU5ucXlldG52bStVRERlL04wUDF2ejEy?=
 =?utf-8?B?TlZ3dmQyVEhpbW53NkdJTHUxb2hEbGJ4aUlsajMreXNZY2VuQnFnbitxKzFq?=
 =?utf-8?B?UEk3cWhaM2lPaXFQR3ZGbW1JdTNHclQ5ZDA4Z3hmVHRzQXFwNUNEeEtURXRC?=
 =?utf-8?B?a09nZGdZT2pRNjhRWUcxZWZOWEJQSHZ0S1RBNEk1N3F5TC9wbnVuN01SZlVB?=
 =?utf-8?B?YW9TbWp6RDFqSXFsK3d5VGxRVVgzcUZiSW41WUMwMXdFZkdhbkxHcThiN3FJ?=
 =?utf-8?B?dms0SmxLZ3NkZ1kxNVVicnpmYVU0R3FtUmFwZ2F1bDBkNUNhMWNjUkhGRzVQ?=
 =?utf-8?B?WTVnTW12RGdGU3FaSjd1L3lWTzdTdHVZWjcxRjJkL3E4Sm5Td25jMHJZT2RT?=
 =?utf-8?B?NUVHenRxQTQ3QTNWeWU1dmd6dWx4S05zd1c0NXVxM3JoM0ZaUVpvZnNZdERV?=
 =?utf-8?B?bjJTS1ZHbzRmQWRBM2dHb2ZMZHc0L1BzKy81UzlkSmE3bUliSnI1KzF6T1Fn?=
 =?utf-8?B?bTl1L2ZEWUUvMFhDajliNU9XUi84SGF6SkJCRDlNK3hhOWpLZTJRMW11WUpj?=
 =?utf-8?B?TXViak5FVW5CeHRiK3hMM21seVAxR0RldDFuL01mWllTakFMS0tMaW5kWXdE?=
 =?utf-8?B?QnI3N00rOW84T0NNUklIQWZmbEF4NER4akVubFEvbGJaUnVrN05QWmgrSnRm?=
 =?utf-8?B?Wm9IUkM5UXB1SHRlbEFMdmR6RkZhVnVUY3BFNnVydEcxYlFyeUNLTkVUU0RB?=
 =?utf-8?B?VlJkSnRPNlpqeERaODRibmxhbmljWDB3V0FwZmJUdE5KUFN5Q2ZuWE1DSXlJ?=
 =?utf-8?B?UVJST05FZHhlZGMxQWZpL01LcHZiQWlLZFRmeEZvRGo2bzBuNHpvT2JIM3Bj?=
 =?utf-8?B?NE03Y0s0Y1RFWDNaU28wUC9kUWJTb0dpdThpZnJLMVZKTlNRTXM5RG10OEx1?=
 =?utf-8?B?TnJPdU16R3NVVWRxcG1JSWxSc3lnbEI3ODVLNmtkb2pvNG9QWnZrS0tvOTVx?=
 =?utf-8?Q?rlRjyDSJ8Ye8On8e/IMUxak=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C745B5D69A2804DA0CA7E5D816D0F0E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ceaa58-a123-45a8-c28e-08ddb36d9504
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2025 22:22:18.9182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j2uT/7ROKKd2L4tHRF/lE87f4zOGi/nV2CMln+13rqPSTsKXA8ilfhwe1BtJwovy+PWviXfT/4djT+tBefyoMeFD9x9sniKYIQHSgUy+KDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5176
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTI0IGF0IDE0OjI5IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
IEkgaGF2ZSBhbm90aGVyIG9wdGlvbiBoIHRvIGFkZDogaWYgdGhlcmUgaXMgYSB1bm1hcHBpbmcg
ZXJyb3IgZnJvbSBURFgsDQo+IGNhbiBpdCBiZSBhbiBpbmRpY2F0aW9uIG9mIGNvbXByb21pc2Us
IGluIHRlcm1zIG9mIHNlY3VyaXR5PyBTaG91bGQgVERYDQo+IGNvbnRpbnVlIHRvIGJlIHRydXN0
ZWQgdG8gcnVuIHRoZSBURCBvciBvdGhlciBURHMgc2VjdXJlbHk/IElmIHRoZXJlIGlzDQo+IHNv
bWUgdW5tYXBwaW5nIGVycm9yLCBjb3VsZCBjb3JyZWN0bmVzcyBpbiB0aGUgZW50aXJlIGhvc3Qg
YmUgaW4NCj4gcXVlc3Rpb24/DQoNCk1heWJlLCBidXQgaXQncyB0aGUgVERYIG1vZHVsZSdzIGpv
YiB0byBkbyBzb21ldGhpbmcgYWJvdXQgdGhpcy4gVGhlIHRocmVhdA0KbW9kZWwgb2YgVERYIGRv
ZXNuJ3QgaW52b2x2ZSB0aGUgaG9zdCBWTU0gZW5zdXJpbmcgaW50ZWdyaXR5IG9mIHRoZSBURC4N
Cg0KPiANCj4gSWYgZWl0aGVyIGNvcnJlY3RuZXNzIG9yIHNlY3VyaXR5IGlzIGJyb2tlbiwgd291
bGQgaXQgYmUgYWNjZXB0YWJsZSB0bw0KPiBkbyBhIGZ1bGwgQlVHX09OIGFuZCBjcmFzaCB0aGUg
c3lzdGVtLCBzaW5jZSBuZWl0aGVyIFREWCBub3IgcmVndWxhciBWTXMNCj4gb24gdGhlIGhvc3Qg
c2hvdWxkIHRydXN0ZWQgdG8gcnVuIGNvcnJlY3RseSBhZnRlciB0aGlzIGtpbmQgb2YgZXJyb3I/
DQoNCkJVR19PTigpIHdvbid0IGJlIGFjY2VwdGFibGUuIFNlZSBMaW51cycgb3BpbmlvbiBvbiB0
aGUgc3ViamVjdC4gVGhlIHN0YW5kYXJkDQpwcmFjdGljZSBpcyB0byB3YXJuIGFuZCBsZXQgcGVv
cGxlIHJ1biBwYW5pY19vbl93YXJuIGlmIHRoZXkgd2FudCB0byBiZQ0KcGFyYW5vaWQuIEFuZCB3
ZSBhbHJlYWR5IHdpbGwgZ2VuZXJhdGUgYSB3YXJuaW5nIHNvIGl0J3MgcG9zc2libGUgdG8gY29u
ZmlndXJlDQpmb3IgdGhpcyBiZWhhdmlvciB0b2RheS4NCg==

