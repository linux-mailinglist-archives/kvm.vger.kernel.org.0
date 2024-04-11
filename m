Return-Path: <kvm+bounces-14311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 390C38A1F0C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4731AB23220
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0728F14A83;
	Thu, 11 Apr 2024 18:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UX5YB2+f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF01EEB5;
	Thu, 11 Apr 2024 18:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712861551; cv=fail; b=YHhDbRJz0ld/SjAwJQ4NMyQ6chJWxRm8j8tkQPs82pEfyFEyl4QE2KNM9xF3lWJnw6Eju/9585RHxiQ8mJ1eFZxeArwnK1autUEXcvSRRq8LuuZa6sFV/TFsc2a+Y21an1n9ZaO/8ERE83xdwWeHUiD15qAunvLI8Qf/OeZhClw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712861551; c=relaxed/simple;
	bh=Xa86N1dCqP7lP6P2N3/QRnakda9rndsvid02SIvCO6Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NGzrnajbauAXH+bvkH8hEX5dVuxnuOJeBj8hD/DNjn1LzoJF3nBMyebf18JEOjjwUhz5KhddaynScjxbh4QEyLDo0GYVhmezJi3yy71exkztPlAysGXzr44Papi6If4sCxJq9SvFNvNNYZ+b1Zl4OfEAIe7veVPYCCNXrvta10M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UX5YB2+f; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712861550; x=1744397550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Xa86N1dCqP7lP6P2N3/QRnakda9rndsvid02SIvCO6Q=;
  b=UX5YB2+fpMYQLDBY64dqR4FnyWLMcuFfVzBf/brALCINL7A1bHyKI7cw
   BpgwqhEYz+Z3CLD6LIV+ZtViUI+65mfzpCF+M7ilQHtPfKvokAN5dCe9c
   TT7f72raUptBdQQRUxzNEwb/e/BoWsy+i4D6BgjsH2w88c9unXNcdUkjv
   iOAWnpS8XIDzEuyaBHAjqEqfKwLEu2uZhthnYLkSAIqlgWJl1Sa6wyjAA
   4vw53nXL9ewEHtVPlzq1lHCzMzf1RHGw0S88il33ko8ZHJi356nYndSLj
   dfqdC0D46UyDuYHHUX4K6JgjQm3fygaGPI/WVf03ON/byuNjUgDJYynI/
   A==;
X-CSE-ConnectionGUID: 5hceyH1wQG2sumLO/Lwo0A==
X-CSE-MsgGUID: gAoyD5T/SY68l9XU9caeaA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8152652"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="8152652"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 11:52:29 -0700
X-CSE-ConnectionGUID: UsR1OAZfR8yb8IHc9OUQ6Q==
X-CSE-MsgGUID: q7x/5iOZT2CQ6PCNUL021Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="21049395"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 11:52:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 11:52:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 11:52:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 11:52:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 11:52:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUYMdEPlJd7YcI/ETTiJnreTFcc+tqY0+l+x91NC9E60H1rct+DbMgzDDG+0hwyPzze7Wyk/+88ZzntgCLxEBsmNKIMW/rQp2vOEiTZxI5BPE1zbvBl7Npvu/n7lwqTXVYNWj5MXJLtM76bpa/GMjX68jiFcG5+v1iD8LiO6ArxWZSChqpLz/IfubzZo7ZX+D4Fw6Pyvb7MtQH67A8SYniiHw/I8ypRNdvsf5WDW6BMD3D8J8ifujMblYdi7RPZuS9JUjaGgtCFjnhMr60VEMxHFFOoysMqwm2MVDiBCGoMtWK7LiJRETEFl6zo0jJtjNOCtSAXJlyJu6UkjRd2m9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xa86N1dCqP7lP6P2N3/QRnakda9rndsvid02SIvCO6Q=;
 b=AKO8mZDErR8YpCCO8zhcofmSsoZT0n387atJw3bxucJW7+cGRy0h6cfLaS2VJtHKQi8rcABYcJ1RRhIYpEtzVtdjuegtvPMMn6zOH3I4KzxoLnhzLYjMdUvLgRf5BxyGyqBCOzlEUeNUWtHN8p5iflssouIjxdgbXm0C+e2s5CVO7B1soehizYNwNnFdStu2vacZWCtzVPBwreR9pOqLwVQzGOR+Bb9yGNZjLBO3abi0tJOa+3c0yQAqLfpkMRKmXJVEhprsWa4Db4MNiz91qONCohhOtIIgk49PwNgtIHy3a0KDOFP+YEoWeNPfxBVJxVfrLx0Jf5oKlNd/htjJ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8414.namprd11.prod.outlook.com (2603:10b6:610:17e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 11 Apr
 2024 18:52:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 18:52:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>,
	"srutherford@google.com" <srutherford@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Wang, Wei W"
	<wei.w.wang@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qOMqOgejWDsE6lTffyy9yei7FcJJkAgAJt44CAABa0AIAAE3AAgAAzlgCAAAskgIAAE5mAgAAfEYCAANyAgIAACmCAgAAHM4CAAAowgIACJcGAgADccgCAAA75gIAAAsoAgAA5l4A=
Date: Thu, 11 Apr 2024 18:52:25 +0000
Message-ID: <437e0da5de22c0a1e77e25fcb7ebb1f052fef754.camel@intel.com>
References: <ZhRxWxRLbnrqwQYw@google.com>
	 <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
	 <ZhSb28hHoyJ55-ga@google.com>
	 <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
	 <ZhVdh4afvTPq5ssx@google.com>
	 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
	 <ZhVsHVqaff7AKagu@google.com>
	 <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
	 <ZhfyNLKsTBUOI7Vp@google.com>
	 <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
	 <ZhgBGkPTwpIsE6P6@google.com>
In-Reply-To: <ZhgBGkPTwpIsE6P6@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8414:EE_
x-ms-office365-filtering-correlation-id: 876bda9d-da57-4b24-959d-08dc5a5887b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 78YFOjFl98eUPoCT2/aQFBAlbLo9sQA0hOoESnW5AqBxlMaXLXJB5pETYEJwlfgSu6zwVHns+mBrTJMsZBc2XtE1RGUKVynxk+dnKMmgDHWcyixDj1kAwUrmwg9i35fxXtxVSzoRa+b4OzI9THKSWW3DfeSEiU6QWzBYZPB/JmdQmTi2fdRqfEYLDnUjxwdUkUKjkDtsXMSrbMMnANSl/lvnftG9zpw3zVDGVM9mJ4pJf6ReNhEwElNf+vGDizrOs8XKqtCUJqzzZL2gUiJUKG/cJTQcjgVKe4wUXIj3vj4FdnrXh94QYdHhgXt4/5F1wqpHTnRJYYZAQyVAClgzNNxzcCHdrXFFMQVnuRaB6TNlr4Lq8dCG1KPqV9iJ0pGYlwnOYR6UN8iCB1PpGB0q+nJhMmD+Ya+H0o/NxDZHiPMEEngR7uhmVM/tYycUKVMrkVxPIoavprmaI5IbvdJ5AKTsTVrXtYip6RHv4Rgseyy7lxXfRroSxDinxqy4dntymZcdJjtHX5yQazf8GKk+W1q2FkoAnvif5pa5ztnjxKqpE5u/b5EKhuq1Ds6yMOBiZlwXH6antP5MxbI1sPBduWa89OfzQ8dx8mFYcIgcxs9nTCATMuAsXTubLeW+19S66aLyrS5fZWH6mznLFdbxvljBIMFubsWsWgU3DMpS11KAQ8w/BvOKf9kXG5Aos1TsR84YEs4r8BftbmO5N3dzLECrTK0bctWyH8mowgMYo0I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTJqWjlGblZDTm5EOW5oakF0eGk5eXpUd200bzBkbTZSclg5emRoRVNiMW1a?=
 =?utf-8?B?c3MxZFR1cEJCaTdnREcwdXplb0k0MEE5VWx1T3k5cXNCUFlQWDVlN1VkSWoz?=
 =?utf-8?B?Z0ZkTW9ZTzRKUkhDV1dOc0xSdDBMcnN1RlhOaTREajhwNkpUQ2lkNnFvMmky?=
 =?utf-8?B?RTc5bGxxSWZ5RVZ0R0hvazhYRlY0VEI4Q2c0cGFpcXc4NG53RjVKZVpERnEy?=
 =?utf-8?B?dEJKR2R6Y3JCOURBOG01QTdNdEdIV1BPYVhoUmMvTkVZN2IwN0NhVFBYdURD?=
 =?utf-8?B?L0lUY2IwSVNGWmU3ZXZBV3c4clAxQzl1VVBOdHh6U0hOWXpsUnBwOFFSeitU?=
 =?utf-8?B?ZlJNdzRha25zcjA5elNad3NrQzFPMEpGQWtnZlBwZUV6MFl0K25UcUt4bGta?=
 =?utf-8?B?RGhhTnBCZHdZWHZwK2UwTHM4c1dRMjkxOGE3NkFWVGNTM0lhY242RGk1SEhG?=
 =?utf-8?B?WmFMUVYrZU0zSVo4TFN1bFJYaUhZeHFzRnZzTUQ4ZTZQZ2NmQy8xTS9vZ3gz?=
 =?utf-8?B?WlFqT3RzWmlOTEFyK2Jza2NjUVdkSkdsNEIwRlhpdy9kSVJpL2JyODMvVU1s?=
 =?utf-8?B?MUt6OE0wQkg1Q3lPU0dYaXJsTzdoY2pZQXIrT05XRkUyaTZwb1BFdGtQbStE?=
 =?utf-8?B?b0tTMkZ6MWNGQTJRRWQvVkdXd05rT2gwYVIrKzBVdHY4QWtMMFhvRlF4UTlo?=
 =?utf-8?B?b2ZLelZZNUFlOWtEZGUwNTMrRlBDeUk2cmVwclF5Vmk5bU16T2RhNDZUdGZX?=
 =?utf-8?B?SjFYRzdXR0ZQWEtIMDRHS3d0OC82aW5jckVmUmtKZlVVT2xqdTdWVW9yQURE?=
 =?utf-8?B?bXZlRC8zMWFHVitIVVB6Ky9xMWJNM1NPZHhiZSs0Y0RacjRFdFY5Vm1kN2F4?=
 =?utf-8?B?a2pBTEpQQUZGTVEvYk5MaU5TNHQyTjBSN3ErY0FFK1paUzQ3bzhYMjFUU1My?=
 =?utf-8?B?ck9qK3k3ZnlxdjZQTDBrVG0xUUxSMXVKdXVoVE4yZm5kczFDbjV1UkkxYnpI?=
 =?utf-8?B?NTVocmxvSzdGSUlBYlVYMnltSDBQbEVyTmVPNi92WmZEcUp3c0luREh1Y0hk?=
 =?utf-8?B?RVdlV1AyWTZrRW9JMDlXM3BUVVdGQnVwU3hDQUo2c1VrY3dCY3dEeUcwWEU3?=
 =?utf-8?B?Y3FzZDBvTkR6S3dTTjB6T1hRbWJyMGYvZitqandJaXc3OEtuYk5lRm4ySGVT?=
 =?utf-8?B?T2IxNGlOcG1UTys2cTl2K3AvRy9GT1ZIOSt6VkpsOHJpRmxqRjlVL093UDYy?=
 =?utf-8?B?R2JCRDZ6Umh1YS9CWmVGUHM1UFdtdjBkNENFRG1tcDZhOU5KWStoUkNvSkdB?=
 =?utf-8?B?eFR4NTZmQW84SGVoNGt6Q0ZIbFMxQ0JGVTkzdERGcGx0N3FUMk9yM1RwSFFv?=
 =?utf-8?B?ckpmY0lxZTFlanlpS3JVRmRlMGJud0NEekJzcFlCT2x3N1ROVnJ4UkxValh0?=
 =?utf-8?B?dHNQZ1lrcWxmRDhVTE9yU09CRXhDNjE2aThXQzh4akpYYXlvaXg5c3k3R25O?=
 =?utf-8?B?Ulp1YXlUT0t1ZlE4TU92SGM4dEtVUHJIZVkwMlZtdUVsUkFwT1FkOE5CQm9m?=
 =?utf-8?B?NHR6Z2NUa0JwR0hxZEhLNENTQ0d3QVFyWlI3Y3RVa3ZhZUs5ZkcvZEJHUmN1?=
 =?utf-8?B?YkhwL29vaUZlK1dUUDRQcDVVY3dQU2cyR1lNUlUreXFJVzFpUE5uamRieFZm?=
 =?utf-8?B?V0xuNEtFYlM2RE9icFBITTF3QjRjRGh6cmxkTjdsb0hrdHE5ZU9UL1ByWVV2?=
 =?utf-8?B?azBkZi8zbTdQUUNwUFJmckRCakk0OWo3cVlHRkl1RElWVFZZVzh4TnlBSTEr?=
 =?utf-8?B?dXRqNmQ1dTYzb3V2YlF2YXRtT0g0MUsvWXdDTjRzWXhRUTZDOE1yT0trajZ4?=
 =?utf-8?B?STBzSGUvRWVXVEVqclI2WG1qcnJGZFFBRHVqUW02eEthMTlxNVg1S202dHkv?=
 =?utf-8?B?MWt4YndMdWx0MzJPRWNNR3FSQStWMHpHakRXdzFtOGx0Z1VEQit1VVhtS2x3?=
 =?utf-8?B?d1ZyVzJtU1pveUJTLzk0Ri9OZWs1YkF6allPekhUS2JOWkE0R3gxOUVCcTBD?=
 =?utf-8?B?K2FxalN6M2RlRXFHNUNVSUhHcWQ1bXFFeXl4YnRpVEhtcnNma3Bld0ZwclFJ?=
 =?utf-8?B?RFlwUk8rMGduUjNmdnJJakRNS2x0K0JOWkVvcFBENmJQdkw4bmdKYllaSkZy?=
 =?utf-8?Q?HHuhS0IFHvBDDKxUgkuVTI4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2E1B3691EDC944BA1A65425D3876D3F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 876bda9d-da57-4b24-959d-08dc5a5887b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2024 18:52:25.9749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rki0+b1dHbKNqwb25YQJay63C3X/Xpppn6sc726i7aKVxET7OjMXFNT62+pEA8NRCU97kYpMOabbEA7illjhcwjpgC//urKCudDdzYWFlMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8414
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTExIGF0IDA4OjI2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAxMSwgMjAyNCwgWGlhb3lhbyBMaSB3cm90ZToNCj4gPiBmbGV4
aWJsZSAoY29uZmlndXJhYmxlKSBiaXRzIGlzIGtub3duIHRvIFZNTSAoS1ZNIGFuZCB1c2Vyc3Bh
Y2UpIGJlY2F1c2UgVERYDQo+ID4gbW9kdWxlIGhhcyBpbnRlcmZhY2UgdG8gcmVwb3J0IHRoZW0u
IFNvIHdlIGNhbiB0cmVhdCBhIGJpdCBhcyBmaXhlZCBpZiBpdCBpcw0KPiA+IG5vdCByZXBvcnRl
ZCBpbiB0aGUgZmxleGlibGUgZ3JvdXAuIChvZiBjb3Vyc2UgdGhlIGR5bmFtaWMgYml0cyBhcmUg
c3BlY2lhbA0KPiA+IGFuZCBleGNsdWRlZC4pDQo+IA0KPiBEb2VzIHRoYXQgaW50ZXJmYWNlIHJl
cG9ydGVkIHRoZSBmaXhlZCBfdmFsdWVzXz8NCg0KU28gYmFja2luZyB1cCBhIGJpdCB0byB0aGUg
cHJvYmxlbSBzdGF0ZW1lbnQuIEkgdGhpbmsgdGhlcmUgYXJlIHR3byByZWxhdGVkDQpyZXF1aXJl
bWVudHMuIChwbGVhc2UgY29ycmVjdCkNCg0KVGhlIGZpcnN0IGlzIGEgc2ltcGxlIGZ1bmN0aW9u
YWwgb25lLiBLVk0gaXMgaW52b2x2ZWQgaW4gdmlydHVhbGl6aW5nIFREDQpiZWhhdmlvci4gSWYg
ZW5hYmxlcyB2YXJpb3VzIGxvZ2ljIGJhc2VkIG9uIGl0cyBrbm93bGVkZ2Ugb2YgYSB2Q1BV4oCZ
cyBDUFVJRA0Kc3RhdGUuIFNvbWUgb2YgdGhpcyBsb2dpYyBpcyBuZWNlc3NhcnkgZm9yIFREWC4g
SXQgY2FuIGVuZCB1cCBlbmdhZ2luZyBsb2dpYyBmb3INCmF0IGxlYXN0Og0KWDg2X0ZFQVRVUkVf
WDJBUElDDQpYODZfRkVBVFVSRV9YU0FWRQ0KWDg2X0ZFQVRVUkVfU01FUA0KWDg2X0ZFQVRVUkVf
U01BUA0KWDg2X0ZFQVRVUkVfRlNHQkFTRQ0KWDg2X0ZFQVRVUkVfUEtVDQpYODZfRkVBVFVSRV9M
QTU3DQpURFggcGllY2VzIG5lZWQgZm9yIHNvbWUgb2YgdGhlc2UgYml0cyB0byBnZXQgc2V0IGlu
IHRoZSB2Q1BVIG9yIEtWTeKAmXMgcGFydCBvZg0KdGhlIG5lY2Vzc2FyeSB2aXJ0dWFsaXphdGlv
biB3b250IGZ1bmN0aW9uLg0KDQpUaGUgc2Vjb25kIGlzc3VlIGlzIHRoYXQgdXNlcnNwYWNlIGNh
buKAmXQga25vdyB3aGF0IENQVUlEIHZhbHVlcyBhcmUgY29uZmlndXJlZA0KaW4gdGhlIFRELiBJ
biB0aGUgZXhpc3RpbmcgQVBJIGZvciBub3JtYWwgZ3Vlc3RzLCBpdCBrbm93cyBiZWNhdXNlIGl0
IHRlbGxzIHRoZQ0KZ3Vlc3Qgd2hhdCBDUFVJRCB2YWx1ZXMgdG8gaGF2ZS4gQnV0IGZvciB0aGUg
VERYIG1vZHVsZSB0aGF0IG1vZGVsIGlzDQpjb21wbGljYXRlZCB0byBmaXQgaW50byBpbiBpdHMg
QVBJIHdoZXJlIHlvdSB0ZWxsIGl0IHNvbWUgdGhpbmdzIGFuZCBpdCBnaXZlcw0KeW91IHRoZSBy
ZXN1bHRpbmcgbGVhdmVzLiBIb3cgdG8gaGFuZGxlIEtWTV9TRVRfQ1BVSUQga2luZCBvZiBmb2xs
b3dzIGZyb20gdGhpcw0KaXNzdWUuDQoNCk9uZSBvcHRpb24gaXMgdG8gZGVtYW5kIHRoZSBURFgg
bW9kdWxlIGNoYW5nZSB0byBiZSBhYmxlIHRvIGVmZmljaWVudGx5IHdlZGdlDQppbnRvIEtWTeKA
mXMgZXhpdGluZyDigJx0ZWxs4oCdIG1vZGVsLiBUaGlzIGxvb2tzIGxpa2UgdGhlIG1ldGFkYXRh
IEFQSSB0byBxdWVyeSB0aGUNCmZpeGVkIGJpdHMuIFRoZW4gdXNlcnNwYWNlIGNhbiBrbm93IHdo
YXQgYml0cyBpdCBoYXMgdG8gc2V0LCBhbmQgY2FsbA0KS1ZNX1NFVF9DUFVJRCB3aXRoIHRoZW0u
IEkgdGhpbmsgaXQgaXMgc3RpbGwga2luZCBvZiBhd2t3YXJkLiAiVGVsbCBtZSB3aGF0IHlvdQ0K
d2FudCB0byBoZWFyPyIsICJPayBoZXJlIGl0IGlzIi4NCg0KQW5vdGhlciBvcHRpb24gd291bGQg
YmUgdG8gYWRkIFREWCBzcGVjaWZpYyBLVk0gQVBJcyB0aGF0IHdvcmsgZm9yIHRoZSBURFgNCm1v
ZHVsZSdzIOKAnGFza+KAnSBtb2RlbCwgYW5kIG1lZXQgdGhlIGVudW1lcmF0ZWQgdHdvIGdvYWxz
LiBJdCBjb3VsZCBsb29rIHNvbWV0aGluZw0KbGlrZToNCjEuIEtWTV9URFhfR0VUX0NPTkZJR19D
UFVJRCBwcm92aWRlcyBhIGxpc3Qgb2YgZGlyZWN0bHkgY29uZmlndXJhYmxlIGJpdHMgYnkNCktW
TS4gVGhpcyBpcyBiYXNlZCBvbiBzdGF0aWMgZGF0YSBvbiB3aGF0IEtWTSBzdXBwb3J0cywgd2l0
aCBzYW5pdHkgY2hlY2sgb2YNClREX1NZU0lORk8uQ1BVSURfQ09ORklHW10uIEJpdHMgdGhhdCBL
Vk0gZG9lc27igJl0IGtub3cgYWJvdXQsIGJ1dCBhcmUgcmV0dXJuZWQgYXMNCmNvbmZpZ3VyYWJs
ZSBieSBURF9TWVNJTkZPLkNQVUlEX0NPTkZJR1tdIGFyZSBub3QgZXhwb3NlZCBhcyBjb25maWd1
cmFibGUuICh0aGV5DQp3aWxsIGJlIHNldCB0byAxIGJ5IEtWTSwgcGVyIHRoZSByZWNvbW1lbmRh
dGlvbikNCjIuIEtWTV9URFhfSU5JVF9WTSBpcyBwYXNzZWQgdXNlcnNwYWNlcyBjaG9pY2Ugb2Yg
Y29uZmlndXJhYmxlIGJpdHMsIGFsb25nIHdpdGgNClhGQU0gYW5kIEFUVFJJQlVURVMgYXMgZGVk
aWNhdGVkIGZpZWxkcy4gVGhleSBnbyBpbnRvIFRESC5NTkcuSU5JVC4NCjMuIEtWTV9URFhfSU5J
VF9WQ1BVX0NQVUlEIHRha2VzIGEgbGlzdCBvZiBDUFVJRCBsZWFmcy4gSXQgcHVsbHMgdGhlIENQ
VUlEIGJpdHMNCmFjdHVhbGx5IGNvbmZpZ3VyZWQgaW4gdGhlIFREIGZvciB0aGVzZSBsZWFmcy4g
VGhleSBnbyBpbnRvIHRoZSBzdHJ1Y3Qga3ZtX3ZjcHUsDQphbmQgYXJlIGFsc28gcGFzc2VkIHVw
IHRvIHVzZXJzcGFjZSBzbyBldmVyeW9uZSBrbm93cyB3aGF0IGFjdHVhbGx5IGdvdA0KY29uZmln
dXJlZC4NCg0KS1ZNX1NFVF9DUFVJRCBpcyBub3QgdXNlZCBmb3IgVERYLg0KDQpUaGVuIHdlIGdl
dCBURFggbW9kdWxlIGZvbGtzIHRvIGNvbW1pdCB0byBuZXZlciBicmVha2luZyBLVk0vdXNlcnNw
YWNlIHRoYXQNCmZvbGxvd3MgdGhpcyBsb2dpYy4gT25lIHRoaW5nIHN0aWxsIG1pc3NpbmcgaXMg
aG93IHRvIGhhbmRsZSB1bmtub3duIGZ1dHVyZQ0KbGVhZnMgd2l0aCBmaXhlZCBiaXRzLiBJZiBh
IGZ1dHVyZSBsZWFmIGlzIGRlZmluZWQgYW5kIGdldHMgZml4ZWQgMSwgUUVNVQ0Kd291bGRuJ3Qg
a25vdyB0byBxdWVyeSBpdC4gV2UgbWlnaHQgbmVlZCB0byBhc2sgZm9yIHNvbWUgVERYIG1vZHVs
ZSBndWFyYW50ZWVzDQphcm91bmQgdGhhdC4gSXQgbWlnaHQgYWxyZWFkeSBiZSB0aGUgZXhwZWN0
YXRpb24gdGhvdWdoLCBiYXNlZCBvbiB0aGUNCmRlc2NyaXB0aW9uIG9mIGhvdyB0byBoYW5kbGUg
dW5rbm93biBjb25maWd1cmFibGUgYml0cy4NCg0KWGlhb3lhbywgd291bGQgaXQgd29yayBmb3Ig
dXNlcnNwYWNlPw0K

