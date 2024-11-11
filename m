Return-Path: <kvm+bounces-31528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA149C4711
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 21:43:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EE83B29ED7
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D5C21B86E4;
	Mon, 11 Nov 2024 20:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6Ae1QlU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5631EB36;
	Mon, 11 Nov 2024 20:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356588; cv=fail; b=nYnL/xWXrLCjJWz7OewWwFH1FNHKT8wS2YSYxFUksQ1dwqKAldyPT2KSbTOHJX2CJNlVFaqCKY7RBpzE2L4Tq1RwYhKI1WrJMVYn8EncsJR3anaSS6YNlUZjWfUnir19fUqe3pfjAi1tGEePIqncHIF8VpfsZz6xBY58Lgq2gzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356588; c=relaxed/simple;
	bh=/NcZ7KsZ6UdwL137B3fb+Jh0wrVzdxrDwdPqwTW5iCU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U2COIPlhsfNpZrG7HW7ZZ29VpGWFEdAy1WG01KXjJZT8r0+q2molKeCy4v7Rhp/obQdUZNewL/ItvUJ9BFtTXhaXT2R232drSLFzr5sreYxqC2YcioUwVz/ZqyCEYPWrECMdIpw0fzmL69MuyMtJ0GAybBW+zfRsfL82zsMeHPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6Ae1QlU; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731356586; x=1762892586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/NcZ7KsZ6UdwL137B3fb+Jh0wrVzdxrDwdPqwTW5iCU=;
  b=Q6Ae1QlUB8ulJ1rt9sm8c1dUxSZ4d4A/NFk8DGimpv4+os0J8y0eM8w0
   gXJBP38ibHr1eWMCAShIapINEPcuHKlLSkzuQ9d4KO/ebzB5L7aV4HY/w
   IPgDvfm7mE4GztgtUYZ5nZACkTBrm7hVltjo0thH8BtzFusEYnOynUZu1
   9eNd3LJsgviqPXCc7W1ysC5CqZtW6G+gzyykY6k3ry9/bf6lwb5m3DIr3
   q1BAYcWfDhFGgb0GUrtimREKugx1qyQjGBHuj0HG/u+aXoATQ9iI3y7JE
   Z9N7Vo6JWiUyq4F46C64Ay9DcI/kk1wKWrFzyd4vTI3rVWyHv1aX9AUWs
   A==;
X-CSE-ConnectionGUID: m9uC+9b6RR6PgS3ex2d6iw==
X-CSE-MsgGUID: SKmnI400S2a92wzo3dsidA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31353909"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31353909"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 12:23:05 -0800
X-CSE-ConnectionGUID: xvDtPh8WQZenWcV8XCM3NA==
X-CSE-MsgGUID: 03BbKwpqTBiWk7NnE9xLqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="91100859"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Nov 2024 12:23:05 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 11 Nov 2024 12:23:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 11 Nov 2024 12:23:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Nov 2024 12:23:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N6EM1ssX67hHR7OFLOwHRVSes69uOVpScAb8WPTET6jKlxTtbOPFJiOeTF1JPzc86gOUjVQUYDONP5lhaKzv/UST56XoY35/p4chFF1NiEFz+m31XSlz3Ko2/Gdl479iLC0tflhqExXKNS95E1RCrHrt1tI6+yy21st8hVHTc88lVblrMUR5IZQuOGfugrNdS6medZn/2NcVBsYyWtpDir/jfTNSRleBdvsRzI8I9EcBgX+zkidUc9JWz7hg1wJbBeej2IWgrYKwNpbj0Ra7OoPjLQaMUZ/TwnJdXlZrVKn6avZ9W+OxU2+xB5Rwco95/8E94ZYF30m7M12YasMw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NcZ7KsZ6UdwL137B3fb+Jh0wrVzdxrDwdPqwTW5iCU=;
 b=cd9FCQ+jEJ/aPYecVR/truAJxQtqoioH4T2TCA/vxwstKmjQuEICcQ3+Nb2CEcU0HMVIiagz8VCkHLuXslOT86RlGb35l4FivMYHAXQLV1ldf/xNLjhBsJDscTff/2NkJWh/ux3sUzvwiKfk3MnlE4loXI8mMiHwy6PDtJS7Bfh3hE9RYAgcetgs7HfnQLNev/kImlpbnsmhwVnGWsC0aglJlLTKulbtf9Yo3sDf73PqPrHdHd6sYul5YYutm3xbuOtGUnk3vZC7bmOncyZSl/3PLHg7mZBvuJg87znPGcZU/sAPYRm9YkhzWyOR219wrW82F3Mcvor0so/2HxyOBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH7PR11MB7642.namprd11.prod.outlook.com (2603:10b6:510:27d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 20:22:53 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 20:22:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v7 07/10] x86/virt/tdx: Trim away tail null CMRs
Thread-Topic: [PATCH v7 07/10] x86/virt/tdx: Trim away tail null CMRs
Thread-Index: AQHbNCV8bUyZjDEZMEejbJ+ipXVHSbKyeyOAgAALhwA=
Date: Mon, 11 Nov 2024 20:22:53 +0000
Message-ID: <6b5e400950eca6cf9160c68049de15ba2ac1efdd.camel@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
	 <fba5b229f4e0a80aa8bb1001c1aa27fddec5f172.1731318868.git.kai.huang@intel.com>
	 <4702f25d-0b01-484c-b542-767dcec97256@intel.com>
In-Reply-To: <4702f25d-0b01-484c-b542-767dcec97256@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|PH7PR11MB7642:EE_
x-ms-office365-filtering-correlation-id: 39b49ae9-8d84-4e16-e139-08dd028e9f18
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Nm1ITGJsR2cvTFRBL3pCN2lmR3NGeTlnWlduVzRWOVBmcUxGR2ZtK1FWTmhD?=
 =?utf-8?B?KzNBdHRTRlhHODdESWltOFc0ZHJ2R1dzbmhmRnk5WW1ESGdyWm1oeVFNY3lS?=
 =?utf-8?B?a1RmVC9IbFBNaUNjUVFWR1g3S0hKdFFwU1lGK2Z1VXFHZzkvMkcxQndCdUs1?=
 =?utf-8?B?akMyd2NFUjBXTE5vdjZmTEVrM1BIU3dibkl5VDdxL3VVZTcrczhTdVhIRmJ3?=
 =?utf-8?B?L25NVE5vL0hwZ1NvTWhGaFBVbGFudEJnNlFleVVwQTBUZ2ZPT1ZjUUV3N0ls?=
 =?utf-8?B?bkxrQVRFbUJiYlBGbjdWVVhsc1l0Y2w0LzArTi9ZUGhkeHExYnNwa20vcXNJ?=
 =?utf-8?B?VUQ5WnJTOGZzWnRiMFVHUzR4UmF0THhnZUtodjVIUXRDL09FVXNVNVM1c29x?=
 =?utf-8?B?VnQwWitoWXBTR3pCcUoxdE1Kc0I0eXpuMTV4b1pnYUIvSE1kdytYS3dyNW5F?=
 =?utf-8?B?anhGcllualhFKzNPRWtldU96SXJvRGN6YkxldFlidDEvVW9HVGR4TUUvYWs3?=
 =?utf-8?B?ZkY0bU5hbXdmMjlxM05YZ1dxL1FCY2N3aHN2UlUzMGo1QWpLeEVyR1RkYm82?=
 =?utf-8?B?aGRudUI1SmZWbU9qQjNkeUJHdWg5djNhTzI1ZWFDZWhmaXNjWEltSkRRcWtq?=
 =?utf-8?B?M01TK0ZhVis4cFRVY3d3R2JlMEg0S2dtNGpwQkdoY1F3NklTY2xJOXVzY0hZ?=
 =?utf-8?B?bC9JOEhqUFdCcDB2NCtOWm5wN2V6YXM3NmVsaXQ4NUZZaStzQnhGY3V4SytD?=
 =?utf-8?B?UnFUbjRQcS84dzF4SUowRzNjaUJ1VS9vNFdVWHk1aDdJRjNoTEFRU3FCck85?=
 =?utf-8?B?MXJGTnBuM2ZHbnpNKzZKaG5qU2g2MFRBRFlTWk01U2xTTnNWTmxPM0JQU0hP?=
 =?utf-8?B?YXI4OFBUdGh5M3Q5MVd3ajRTQzd5akFYMW5UOVJUb1RqcUJjdU9tRkpQVnZQ?=
 =?utf-8?B?NjB1cVZoTy83OXgvMG95SnBaK1o4VitkYk1idjRRUjlldUcycm9hTUlKWnpi?=
 =?utf-8?B?VjJ0b0xnME15dmxDeUttUFVDazlxMzIwSFFwczljM09lQWM1WDBDRXl2NHJv?=
 =?utf-8?B?b29KZmRMTG5pU1R4MlRMcXBqRWNWSk5lYjBuc1pTYk54U2lFTWdFNE9leFBM?=
 =?utf-8?B?KzgrRDRnZ04wSTYwKzNlS2ZtYzVDMkJxZzVhcFYxeUZzT0sxTHg5Rm45WDRv?=
 =?utf-8?B?cXhVRml1aUtsNm1mSVhsNTFGOC9JU0JCY0tpRFNaTEN4S2ZBM0ZVaVdDSjU5?=
 =?utf-8?B?NUErSXdKM3dEaXJvMWNnWDF2OVRiOXpQR3ZXRnBKNmNybjdhdkZIdy8raHNw?=
 =?utf-8?B?M0xQWEpOT3dEbXAzL2tlOXI5U3hmaS9NaWVBSDd1VGdhVms1a0dSb21ybFNo?=
 =?utf-8?B?N0NTVkplYjhxeFFGMGtLMGZkb1NqYzlSaGx0MFNaQy80dnkwY2FzNll3S2lR?=
 =?utf-8?B?Q3hkcXF1aUhwbytxaEtVdmJyOHBLWGhkRmUwR0hndERxYTJhUUFud3o3Y215?=
 =?utf-8?B?bURxVS83S21rZmZPSUZDZkNFZHhSKzRhYWgvajBpRXlCVlRZKy9jZXJLakVW?=
 =?utf-8?B?Njg1Ym1tWENrYWVRTW1yKzBNejVjdUNXRDhVS1pmOU1qaTdCbDgxbDFHYzNk?=
 =?utf-8?B?RUs2bEorc0loZ3Z0Ym10SEJISngyRWFBMS84ejZXUEEzZWNVU2VaK0JYaUcv?=
 =?utf-8?B?cklJYUdPSGE4aktqZ25SNEE1aVhGN2dVcTd2bTNrUjRsZWhGbU14TC90V3Vj?=
 =?utf-8?B?SS9weDBXRUpzV1RjNFJVUFk5UmN4Y2Z6RzZMNkZCNGtaa2wvNU93Qm93WWdy?=
 =?utf-8?B?ODNuUDJkRVE5SDRkbHczazNoU1A4VkZqNlhYa0thUks1Mmp2WWM5bXNIR3lP?=
 =?utf-8?Q?sL9vpOMUgE7rZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWZZbHFybThXZHo0ejVyQkwrRk5lNHlnWnk0ejFhSEpQbVdNck1pTXUyb2Z6?=
 =?utf-8?B?WVFmTE5QY3lEV3hpeGtKcTlnVjk0U0VKdzcrL1REOXRrUnpiei80ZG90NWZn?=
 =?utf-8?B?dXRHV2o2NlliajFrV3FNbzM2aTFBZ1d4Z28vOFJjY3lqT3h1Z1A2blVKSGZ2?=
 =?utf-8?B?RkJPUW9ZUE81QmExQjkvNG0zKzR0U1lxcjU2VndaZnRzaFdMdmNDTVdZYmhB?=
 =?utf-8?B?S2dacXRlbk1UblV3OTFiNkRISWNyZ0c0NC9CMTdXQXVxZHh6bU12QTlMYmR1?=
 =?utf-8?B?bUxzUi9GMGZVdWtveEgwQWVUaXRYUktJU2hnZThrU0pyQ3pQY242N2ZHU0VR?=
 =?utf-8?B?cDROWDJqb3ArTDJaZDNobjJsOUcwWUhCZzU2UU50bTJSWEk1MkFRNkxFL2dl?=
 =?utf-8?B?aUtlNVFSR0tnWFBYT0RmaEJxeHBaNWdiZW1xLzZsZkw1QmsyYlhhWGowbWx4?=
 =?utf-8?B?c2h4TWgxVEQwZ3FYKzYvdFpCUWM4eVJ6Ynh5TEgzMWxXbnRkbEhJcHN6bVFv?=
 =?utf-8?B?aThmZ3c5NTl6TzRPNkJHTFlnZjVCbjZ0eHlBVEJnV3FISzBJZ0ViZnpMSDNv?=
 =?utf-8?B?MFgzMkRXTzUvRi9TUW1zcTk4bm1Rc0NqZ3Z6U1dFWTJDTHlXWVBabFlhK3FK?=
 =?utf-8?B?dWVoVkpOWE11MFVWUkZzenJPK3VMR24ydU5yMkRpN1NUdStxMmhVVU9HM1VN?=
 =?utf-8?B?V3BnUzJmZVN3cmxFSnZsaHVPQkw3VURYWWFpNmczQ0VPMDdROCsvYXJFSXVR?=
 =?utf-8?B?UG5ueDdndFBqaEZhdXkyS285dXY0TEZTek1qU3Y2a0RqdllBcDdBc2duRWlx?=
 =?utf-8?B?UlFKMmdlTk1RY1c1R3VHL2w2SFpZTlJVbVRTRnRpSFd2ZGlyN0dMVjc0NWll?=
 =?utf-8?B?Y1ZqaGM4NURIKzh3dlJrVnNwS1dOd2sxWWRSOG52NW5hbzRNVjI0UDJYQkZa?=
 =?utf-8?B?SERXMi9CZEs3cXRNaHl6YmhwQlpBM0tCWUxFQUUrMER4Z3R5Q1U5QnV3Q255?=
 =?utf-8?B?QkI5bVZLMDloNkZISmd5UFFNUVZUbGl1cVkvK3orNjBUZnEwMTVHYWwzcjFl?=
 =?utf-8?B?aXJnb1pxc3NmZ0pYZnFXNFl1YlE5ajVuazRSTWxodnplbzVhbzRFM0ExUDNn?=
 =?utf-8?B?R2RsblBIZ0NjMDBia3laTGs0aWZRUlFrcWk2WHRTbGtRVWsrYThrdDBDNVUv?=
 =?utf-8?B?ZkJEMXFwQW9Od0xiQ29aeVFtbTdnN3VsQWw5SUdXQkdaUGVLRml6cUR5L3Uw?=
 =?utf-8?B?WWRORnpIak9EUFNlTVBvRm5LVkVyeEE0TmxRR0VyMk0vNEhJRURtaXJnYnFB?=
 =?utf-8?B?cVRFbGlJMm5sRHpyQW9HUzEvZ0o2Y3Q1WVNxRXVRdDZ3aEpiNmY4K3NaVm4y?=
 =?utf-8?B?UUx4L1NEY2hTQlJ1VmpLMVljb2pwT010NEp0bFNLY2cvZ1loTGdiS1dmOW8x?=
 =?utf-8?B?STdtMVdieDlETDUwdVVtaDNKaGpvZzg0MmRLeGE0Zks1WnpxYTR4eTdvRmJa?=
 =?utf-8?B?OEpGSUxidStkRTM1WUcyaTRHSzhzSGhJa0NqMElnTmxaVXJ1N3NtSFZyUVgx?=
 =?utf-8?B?OVVhNk14dlZRQ3oyQ0w5a2xBK215VVBFUW1xNDJFbW9YUFhic2JMQ0hHeTBY?=
 =?utf-8?B?eGZXRGI1SEg4YnF3MllyQzVCY3RpYlBhcHB4MVBjM29UZXYvMFNrczBXUWpJ?=
 =?utf-8?B?akxPcUpmbVF2dVBsVG9KMFVsVXFNaEZheXYrc016bTRHUU5mQVg1bm5yUlBF?=
 =?utf-8?B?MnhkOFFTMGdEZjliOFplQTIrWnlSUWNMenA5WjlRcTlPZjVnVm5VU1VpZ1Rx?=
 =?utf-8?B?SlJlc1B5NlZmNHlkQzRFbTBlZDh0L2xLNFZUaElDOW9reU9LbS91ZXlad2V2?=
 =?utf-8?B?dm5PdWxwb3lPZnlWSmo3bWFCb3FJTFVHS0l2NDlaTFBhS1N2dy9URHFzbUlz?=
 =?utf-8?B?TlZURDhFQTE2Nm1XQnRqTGZIMjRodHo3N3lVc1M0QmFYTlRoZEZiM01iUXBk?=
 =?utf-8?B?S2E0V25uU3piZ0NrR25DeGJPcW0rYWRJQ1ZNamhFMEUrR3owWEtkdTFxRG0w?=
 =?utf-8?B?R1BiOUgzT2lBYlBhbHUrU2RNMTI2LzN4QVZtd0tJWjJ0RkdEMHdFZEhxNDRa?=
 =?utf-8?Q?/NjzHcClCWZDVGFaQ9I5d8aKj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F4ED12460552D4DAE8A082199A6BD28@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b49ae9-8d84-4e16-e139-08dd028e9f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 20:22:53.4233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V+ijuOnqEcjKZIh5vHnfGvXdRr7eY5seT7Zp8qxI7ON7ZKCbZ6T6ZufdvXGlNzBxzZDkpStQkixmZpZZN6am5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7642
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTExLTExIGF0IDExOjQxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMTEvMjQgMDI6MzksIEthaSBIdWFuZyB3cm90ZToNCj4gPiBURFggYXJjaGl0ZWN0dXJh
bGx5IHN1cHBvcnRzIHVwIHRvIDMyIENNUnMuICBUaGUgZ2xvYmFsIG1ldGFkYXRhIGZpZWxkDQo+
ID4gIk5VTV9DTVJTIiByZXBvcnRzIHRoZSBudW1iZXIgb2YgQ01SIGVudHJpZXMgdGhhdCBjYW4g
YmUgcmVhZCBieSB0aGUNCj4gPiBrZXJuZWwuICBIb3dldmVyLCB0aGF0IGZpZWxkIG1heSBqdXN0
IHJlcG9ydCB0aGUgbWF4aW11bSBudW1iZXIgb2YgQ01Scw0KPiA+IGFsYmVpdCB0aGUgYWN0dWFs
IG51bWJlciBvZiBDTVJzIGlzIHNtYWxsZXIsIGluIHdoaWNoIGNhc2UgdGhlcmUgYXJlDQo+ID4g
dGFpbCBudWxsIENNUnMgKHNpemUgaXMgMCkuDQo+ID4gDQo+ID4gVHJpbSBhd2F5IHRob3NlIG51
bGwgQ01ScywgYW5kIHByaW50IHZhbGlkIENNUnMgc2luY2UgdGhleSBhcmUgdXNlZnVsDQo+ID4g
YXQgbGVhc3QgdG8gZGV2ZWxvcGVycy4NCj4gPiANCj4gPiBNb3JlIGluZm9ybWF0aW9uIGFib3V0
IENNUiBjYW4gYmUgZm91bmQgYXQgIkludGVsIFREWCBJU0EgQmFja2dyb3VuZDoNCj4gPiBDb252
ZXJ0aWJsZSBNZW1vcnkgUmFuZ2VzIChDTVJzKSIgaW4gVERYIDEuNSBiYXNlIHNwZWMgWzFdLCBh
bmQNCj4gPiAiQ01SX0lORk8iIGluIFREWCAxLjUgQUJJIHNwZWMgWzJdLg0KPiA+IA0KPiA+IE5v
dyBnZXRfdGR4X3N5c19pbmZvKCkganVzdCByZWFkcyBrZXJuZWwtbmVlZGVkIGdsb2JhbCBtZXRh
ZGF0YSB0bw0KPiA+IGtlcm5lbCBzdHJ1Y3R1cmUsIGFuZCBpdCBpcyBhdXRvLWdlbmVyYXRlZC4g
IEFkZCBhIHdyYXBwZXIgZnVuY3Rpb24NCj4gPiBpbml0X3RkeF9zeXNfaW5mbygpIHRvIGludm9r
ZSBnZXRfdGR4X3N5c19pbmZvKCkgYW5kIHByb3ZpZGUgcm9vbSB0byBkbw0KPiA+IGFkZGl0aW9u
YWwgdGhpbmdzIGxpa2UgZGVhbGluZyB3aXRoIENNUnMuDQo+IA0KPiBJJ20gbm90IHN1cmUgSSB1
bmRlcnN0YW5kIHdoeSB0aGlzIHBhdGNoIGlzIGhlcmUuDQo+IA0KPiBXaGF0IGRvZXMgdHJpbW1p
bmcgYnV5IHVzIGluIHRoZSBmaXJzdCBwbGFjZT8NCg0KSSB0aGluayB0aGUgZ2xvYmFsIG1ldGFk
YXRhIHByb3ZpZGVkIGJ5IHRoZSBjb3JlIGtlcm5lbCBzaG91bGQgb25seSByZWZsZWN0IHRoZQ0K
cmVhbCB2YWxpZCBDTVJzIHZpYSAnbnVtX2NtcnMnLCBzbyB3aGVuIHRoZSBrZXJuZWwgdXNlcyBD
TVJzIGl0IGNhbiBqdXN0IGdldA0KdmFsaWQgb25lcy4NCg0KT25lIGltbWVkaWF0ZSBuZWVkIGlz
IHRoZSBuZXh0IHBhdGNoIHdpbGwgbmVlZCB0byBsb29wIG92ZXIgQ01ScyB0byBzZXQgdXANCnJl
c2VydmVkIGFyZWFzIGZvciBURE1Scy4gIElmIHdlIGRvbid0IHRyaW0gaGVyZSwgd2Ugd2lsbCBu
ZWVkIHRvIGV4cGxpY2l0bHkNCnNraXAgYWxsIG51bGwgQ01ScyBpbiBlYWNoIGxvb3AuICBUaGlz
IHdpbGwgcmVzdWx0IGluIG1vcmUgZHVwbGljYXRlZCBjb2RlIGFuZA0KaXMgbm90IGFzIGNsZWFu
IGFzIHRyaW1taW5nIGF0IGVhcmx5IElNTy4NCg0KSSBzaG91bGQgY2FsbCB0aGlzIG91dCBoZXJl
IHRob3VnaC4gwqANCg0KSG93IGFib3V0IEkgY2xhcmlmeSB0aGlzIGluIHRoZSBjaGFuZ2Vsb2cg
bGlrZSBiZWxvdz8NCg0KIg0KQSBmdXR1cmUgZml4IHRvIGEgbW9kdWxlIGluaXRpYWxpemF0aW9u
IGZhaWx1cmUgaXNzdWUgd2lsbCBuZWVkIHRvIGxvb3Agb3ZlciBhbGwNCkNNUnMuICBUcmltIGF3
YXkgdGhvc2UgbnVsbCBDTVJzIG9uY2UgZm9yIGFsbCBoZXJlIHNvIHRoYXQgdGhlIGtlcm5lbCBk
b2Vzbid0DQpuZWVkIHRvIGV4cGxpY2l0bHkgc2tpcCB0aGVtIGVhY2ggdGltZSB3aGVuIGl0IHVz
ZXMgQ01ScyBpbiBsYXRlciB0aW1lLiAgQWxzbw0KcHJpbnQgdmFsaWQgQ01ScyBzaW5jZSB0aGV5
IGFyZSB1c2VmdWwgYXQgbGVhc3QgdG8gZGV2ZWxvcGVycy4NCiINCg==

