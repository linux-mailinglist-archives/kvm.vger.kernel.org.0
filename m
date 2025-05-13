Return-Path: <kvm+bounces-46398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DB1AB5EC4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 23:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C85D119E297D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 21:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4E7202983;
	Tue, 13 May 2025 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RhsY+yBE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9560720C46B;
	Tue, 13 May 2025 21:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747173527; cv=fail; b=TdczXthY1PXPzN5WTxrvc2HPOJzfZlslCo6SnFsrR6KI+Ikta9gHc37U556YbaGbSet8cP07qaDTvXKC33CI3IXAyFHaasTXiiIVzxtHEa98ncG1K0aF/ugu2vvDnvxT3VLuGQf/wrI2nH9vld6LqBLnlebvOBsinFQtNiwZ8OQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747173527; c=relaxed/simple;
	bh=Hbmu375r1LvnQQKQMNJLcOwkYCIJ0CevN0+dGJVTQA8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wi7FOSAyqm+hAEF0I6WK3puATpQEglrB/eJC13Q9SCmxt2uNbF9TvzDT2ZImCPN2P8LD9d53SqHwiqV546jds51NobjAVd3IIVdOseZOZjbn2r0EjNmSWI6FWBEb9HG7VKF1OaQdw86husj/HkKFLdlMcFQ4XsQLlt37fTxFk5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RhsY+yBE; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747173526; x=1778709526;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hbmu375r1LvnQQKQMNJLcOwkYCIJ0CevN0+dGJVTQA8=;
  b=RhsY+yBEW8bzqdfwJIurfPT4cwTyNFESGU3lR0LtTG6B/SXnnV8Bl6zY
   xaKu2dF72tiaw/cOEmfDYBWklSvo+ItBTH4/1jlSXE1cC1xkPPeiinMrW
   So0iD1ui9SukUWRIlRlb1L6hWkUWf8Kfc8rIGEYeHj3JAzuexeAIGVa8B
   WJDjnmtHmXN2nwKwkGassMHDkXCuDHJdKARQ66nRgfiFtOFG9w9e7UaWo
   ZScdN5/ZqLK83KMpcrNRo1uuRobasqy3KfIUPeNpZHRzw5mqvJCmaMHP0
   xdsgLwpXUsHl1l1UKayh7VJ/IU9fW2iX+RggUH1QDWtuCdQohx9Mfl3LG
   Q==;
X-CSE-ConnectionGUID: SYwlt5gXQbOOI0bOM7UT5g==
X-CSE-MsgGUID: qrxNHH5RTtuGg0TZ0t+LGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="52852584"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="52852584"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 14:58:45 -0700
X-CSE-ConnectionGUID: Y1rpzcveTKShCQ/6zX+qsg==
X-CSE-MsgGUID: uKGE1ykUR56OCK1LFaQGQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="174956709"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 14:58:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 14:58:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 14:58:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 14:58:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DdyafKn1KI3g+40Z9i8p5XoefnzoipXkNLKqQ9WwJHHrh2ZHDCyhKV0VacWXiBkRtK8FpRxYyVfaZRXzCsw/IvW+OebLFoFNQl0XSLLzd93Mymq07FW5pUUT+mlY+cK6KTHo5zJRXuvJktD4kr7Z5h5rUagto98JNNDyAarWFMShxI5mJy9dTJ8m1zvkbcSS/2cS/dqGsGAc3SDk6Iv1BBboV6OKE0F9VKYe3QcQYw61Kfxd2WXVoL8A3XfkJSfc7NAZ1BcD+JkF/Mrjb+AXyLAfz7CDK/wzEN7HzdXpZsJ94edgKcnqw7uP49AwrtrUBeHOKpXIPbxaLoItDigTgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hbmu375r1LvnQQKQMNJLcOwkYCIJ0CevN0+dGJVTQA8=;
 b=rGddt8ZWgRPv1fwWeg8aF6Gzt/wrQDmausTIYBb1n1lemu7HO5evPQpnZqBlPIrNN6Cqy0S8C0l+w0HZIbUY9r3RRGowspYVqoHU0ZwemW3jaaOK+Hu1g84tj/y+61XzK1+A13CRLFeSXeFMf2saqJnsoH2+PL53iIj5iLkp/QCiQ85XHV6Xy/4igFZMOtcV5IVJUXNDwcIPQBeF4XDaFblpwnr55UZI5SCwvCV3MqRm/vVPT7m0bixFRcRjAYaEcack3+GibARmBhD8Dms5vwKfHKX6OMvyRU6n9gKhl57bkITqsLNZml7Jmv4brXWC/TFBjOZcsHrdh8L4i+fTDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8703.namprd11.prod.outlook.com (2603:10b6:610:1cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 13 May
 2025 21:58:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 21:58:41 +0000
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
Subject: Re: [RFC PATCH 21/21] KVM: x86: Ignore splitting huge pages in fault
 path for TDX
Thread-Topic: [RFC PATCH 21/21] KVM: x86: Ignore splitting huge pages in fault
 path for TDX
Thread-Index: AQHbtMaS0P6wVjngyUe5H6xhJH3fWLPROtEA
Date: Tue, 13 May 2025 21:58:41 +0000
Message-ID: <f1c4d09b81877bdcc16073afd70a48265ac5230f.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030926.554-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030926.554-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8703:EE_
x-ms-office365-filtering-correlation-id: 6d522f1a-2b72-4a05-1455-08dd926952ae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WDFEOHM0UnkyQStsNHEzNGc4Y1dUSFAyL1NOdUFGVStrTFhvclREVURuYWZH?=
 =?utf-8?B?Kzc1N042RlNiWGQ2c1lHekZSWW5sZGJ4OGo5bTRIT00rcGZVQ2dTS2VEVnVQ?=
 =?utf-8?B?SXk3NVhSaVJMT0tHYmlLQWRBeXFEZWNIM3QvZjgzajJHRi9CR1hYNzFoVGNk?=
 =?utf-8?B?ekd2bnhXbllVcnl6cmpMcFJEQ3FpZ0haOWhOS3ozMUZJdEhaYWcvbU5PbHBV?=
 =?utf-8?B?d2lUZU9VUmlVMFlMcmVFN3VVVzNoVTB0bmVCVS9tNzJUNFNJK3NRRnNxNUd1?=
 =?utf-8?B?VjRYY01ocXBhM1pTT0VUWk0xRlB4NnpYN0JPcllTd2c0bVFXYnZGTmNLaDBC?=
 =?utf-8?B?T0xzUXNBaEVvSFNMaUZNQU01dlpiNzFZeUdhYWZMOXRzbHBUSFVtQ0gvRU5T?=
 =?utf-8?B?aytRbDM1N0pucitlUFFVU1orUHZiTmFuZEc5K3g2ZEpkbm81YU5LbTdJQU5U?=
 =?utf-8?B?Ri9kT3A3WUsyQXdTK0pJdkdpUEY1WXVTNmw5TkFKbm5HMkdMeTBhRE82SVpN?=
 =?utf-8?B?UC9zQ1BXQWhxNXhsd3YzQjQwQXRZVEZYWHB5dlkrVTlZUkVyTEU5NUw3ZjNr?=
 =?utf-8?B?Vnk3VGtyZ2lSaVo5TnQwR1BDajI0WXpmZE1lWmpxUEcxd1pqRDQyK01HVWdz?=
 =?utf-8?B?V1haVnJMSmk4MWJlVmpybEpUTHhVcHFWbkdwYUVMbHFURHdvS2VFZVBheDA5?=
 =?utf-8?B?bFY4MVJ3T0dRMmNSbVYwUHl6ZEF2empVYmI3M3pTd05ZYkNxZGJ5UWNLUDBz?=
 =?utf-8?B?SFR5TWdDWmo3bXF4MHZEWnp0RHQrcFFRUEltSEwwSjVRd20rZk13LzlhNTBH?=
 =?utf-8?B?UFAyL09XTlZOZS9pOTVISnVkNmltY2lYSjAvcUhzL0t0T2JwZGNpNGRzamhM?=
 =?utf-8?B?S1JucEhFT1A3ZkIrMkF3L0VUVTAreTFjWnNQYnE3a3hkSDNuUVNJOEw1amJk?=
 =?utf-8?B?Yit6My9UWVRNRTlqU3A0ZnZ6Z3pPb25Qejdwekg4akdzZHFJL0pxNjdhTnBN?=
 =?utf-8?B?QWJ3anRyLysvRlVqbHNjemU3dDZUdGZVMFQxSjkwNkRUNVlTampWL1lhRUVG?=
 =?utf-8?B?UHorenFOeHZaVkRnclJGNzl6Y0ZQTzB3UXhIcjVFRzYzcCtWYXErcnJBQlRT?=
 =?utf-8?B?bHNubEVuTE9OSDNKKzhadDJUSTJQMVQzdktkSzNGTE1lVk5Gc05vVzJkNTdZ?=
 =?utf-8?B?OVI0WmswTS9JS3FSU1RrUldXTWdONjJ6czlVWXF5cEVtL3I1UFU5L2ozbnJC?=
 =?utf-8?B?OWlBU0RRVzJuY3VBcjhsU0tHQjJqREpmNlRINGJnYmRZZWY0MkFaWGQxS0pa?=
 =?utf-8?B?U056Zm9pQ1kwYmtNRTZQTloyK2hFaHV5Vml1Qm9ITlBONzhsdFJ3SzNHazFw?=
 =?utf-8?B?cHdxek80U2ZuNEtBeG1xQjI1SFhNTFBSVkN1QllWSjJkRk9NSklYRzVnM09U?=
 =?utf-8?B?V3NRZU9MMzVJRS9sc2Q4STNmY21EeEF3VGkvclF0eGJORkMwSThZRzJidnFZ?=
 =?utf-8?B?djdrcTRmanVZNE9WOTRpR3diVElHZ3pyWk0ydG96dDNPUmQvclk3Wlk1Tk55?=
 =?utf-8?B?T2hReVhoZHZpTmZUSWMrSms5eEE5ZzRXVVpJdjFmV1dXS3ZPTTFMM0NibEdE?=
 =?utf-8?B?TVVDcTdPWFJuSFdQWUdGWURxLzk3ZjBLTnY3UGRwdVp3UVBBeFRJaElTZXcw?=
 =?utf-8?B?MUk3dHhGZStsU244VWViNW0zbi9YTkxPK3lCL2RIblFYclljdEt5SDU5TXJo?=
 =?utf-8?B?UGVMakVOV3krYjZGdUpFMS9hWktBQ1A2dG5PbGtsKzFvQjhkQ0wrSm5VbHhN?=
 =?utf-8?B?bXBxQUZkUGFCN1BkSkVKWmt0VDVabmY1clpFK0dodUlHTXUrMURuR1RacXhp?=
 =?utf-8?B?UUJGdWVJRzZ2VmlkRGZIWnFZMWVlSWVHcTFMOGYzbWpINjhjMWlJNkJEdVBX?=
 =?utf-8?B?bTBYVFBxTHRwUFRBOHhZUlpRZm41OXhnY1BwWkZlNDdvUDZHTWN3TDFYWE9V?=
 =?utf-8?Q?jYqnFUcSYT+QB0rh91scwx2p25Xys4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2FYOVZmamovNGJVY2g0UHM4Qk1GMGdqd2lqSXY2Q2orekpNNWltdEJUMDhm?=
 =?utf-8?B?eTlZOSt0S3dyZDVNM1d2elkrWVFQS0pwUEJINkxUSmpLaDlWeGNON2YrbDRO?=
 =?utf-8?B?LzBXaTRLdm9pRVo4a1RLenVhQ0xNUWRITG1naDkwSEQyanFoSll0YlVMRGRr?=
 =?utf-8?B?T2NWQjE0cVFaWGRtNEo5NnEwdFNYN2pxSXFNZEtXTUs3MWdKazFranRBYVhT?=
 =?utf-8?B?VHoyN1JQN0pUdC9BaHNVaXgweWU2a1lZMkRxWWVqdVRMbytLQS9tTitOOEhh?=
 =?utf-8?B?UEZJYldiVWNKUjBKQmNSYlZ5SUpYT3FSd1dldWNwOG9jVC9SZnlKTkIxQW5G?=
 =?utf-8?B?TTZ5RDdyVU1tQldTdDRMaVJXaE1qMlRzbU9MS1BrMkxJTUo5NlpKdUI4c0gz?=
 =?utf-8?B?STZqZVdUbW9lRmtTbUZ5WlB1eDA2ZExWRkFVaTl0WS9sSDlybkZFN2ZwS3dJ?=
 =?utf-8?B?aC81WThNSDJxb2hrZFZmckE1WjBqQVFLSVVnL0NpZWI3eUFtSnh0VkVtanpX?=
 =?utf-8?B?Sk84d0ZLL1pVMml2Vm5EN0pKT0VHSEZnZXNidFBVZ2RLL2RKTS9FbDczRU5u?=
 =?utf-8?B?ZG1leVMxcHNXOEVyZXI5ZTVuT21lNG44d2xXV0xjSGY2cjZ0QXhrQW9keDNz?=
 =?utf-8?B?WXNJcHNaR0JaTkRXN3V5VHdJdjF3TnFsZEVOcU9uaE9aQ2Y0VzNRZlhBbWwv?=
 =?utf-8?B?OGlaZGE0VCtUN2RzSm93QS9xUjAxMWJyVWh5ZmFhYUVpZlZSMld2NUppZjFU?=
 =?utf-8?B?WXc4RXJDUng3VzNIVktPbDZ0VHJvMEtVejJGNW44YmRGNlVEdW5JeEs4N0RP?=
 =?utf-8?B?NUJGTVllbEk2KzdUOCtMalZWREI1dnVHblAyek84UERzekJkdEt0dWRnVXNt?=
 =?utf-8?B?OFlORVZxRmlXektCb25wN2t3TlBSa2xvczhQSXdTNThrRFkvbWgxMjlCWWlG?=
 =?utf-8?B?dmdXV2h3N0hlS3ZyanovRWJJMmF4NG1kVWdjTEpFQkh3L2hqTVZDMXN2RnM1?=
 =?utf-8?B?My9GN0dqeHNEUnd2clVLTEh3Yy9ESk9SaTF4QjJxdk9yWk16SWZPWlQ3NDBw?=
 =?utf-8?B?ellWWWNCdUtwTmpsMVdJOTBrdzJBYWR6Z25YRFJ5Smk1YXRNOHpHZ1RmQlBh?=
 =?utf-8?B?eXdOUDF5dDhtRFU2aGFkMnhEeDlwM1hMK0ZLQmV0VzZlblNoSGxILzltekQ3?=
 =?utf-8?B?cUdxQm1la3NTTTRxV2hUZ0VpM2hkMU9kYXo3WTBxczltK1JrMFcwYktaOUsw?=
 =?utf-8?B?bEE2WGRDb2szQlUyUlMySWJmcFpvWjVMaDlrcnJFc3RGR0NSMURXMzRyaHQr?=
 =?utf-8?B?b3RnQUd1dzFjbGMrbGgzdGhQcEt6d1pwZHdSK0FJKys5Z1hxeU5XaVZZaE4y?=
 =?utf-8?B?aktEc3VoK3lPekVDa3FESUNQTUlaMDVSRFRXZHBMRmpZQXV0NlVwYlgwbCtP?=
 =?utf-8?B?NlF3RmRFdThKQWlzUmN4aHpUcHdhWmRMQVBlbGt0bkZNMVYzM1dsR3JMS1Vl?=
 =?utf-8?B?R09nUk9kQ1VzN0NSelp0K1N2bDdzaG9DdXRjUVBDWkdXVWxkZUx5YSt6K1lM?=
 =?utf-8?B?TGF4T2Ryd1AyMnNGMllhZ3diOU8zQ0tTcm5SVzdUYm9ablVuQkpDU0N5Zi83?=
 =?utf-8?B?eXVNU0Frbkl1LzVtTVNzQkhxYWgySmhHMEZxeDE4TkZuMy8rREpobGMvTTZD?=
 =?utf-8?B?OTZ2QTRORERCNjE1YSsydk16UU4vYWxZWTFydnF1cjNEOUFBd2dNeVRuc3BH?=
 =?utf-8?B?c0RFRlFuVEFhYktIcUxoQjFSWFN3UU9VRjA4RzlrZ2VDOSsvWDdNalJlbzBk?=
 =?utf-8?B?TW5jS3kzdUk4L3EySGVEWko3VVZWdU5qTEtud0JlL2F3cms5Q1lNaXFpZEpM?=
 =?utf-8?B?VU1IM1haVGhZc0lqVitGM1BJcmMzZC9oOG83NTMrbitFRHFaN2Y0VlREUGll?=
 =?utf-8?B?bWJVa2tRWGYyeWZkb0FjeUhENWNSanFTSlFmODRkNmdFY0ZXRnVBOXZMSXNF?=
 =?utf-8?B?b3VBbW12YkxyMHpFb0JLV3pZdzN3b2VEa05TNkh1N2xnUjJJdHZ1SVliZGkx?=
 =?utf-8?B?WnZsdUl2N3hjbGRUYXhSYmNMWklXUkU0NDBVOS9aWFNsSVdHMjgrdjBiY0hS?=
 =?utf-8?B?N2x3Nm1ON00zN2s3cVJyVUdsekhEZXllYm9LeStJZXhFQlp1T0Vzd29KSUtQ?=
 =?utf-8?Q?YluNeFy7Zask5zBKMdoaNrY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F211202B70F0EA43A7D595F3D8C8748B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d522f1a-2b72-4a05-1455-08dd926952ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 21:58:41.2241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YveeO6aq+UCQw9ifoxt2vnNbpE7YFGLZ+6W31OhevFgdttRimDS8qEptvTPp7iTZHhaID7XBR8oYSVt62n0IU6+sSyZG+mIp8Nnk3IyrEa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8703
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCg0KPiAg
aW50IHRkeF9zZXB0X3NwbGl0X3ByaXZhdGVfc3B0KHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2Zu
LCBlbnVtIHBnX2xldmVsIGxldmVsLA0KPiAtCQkJICAgICAgIHZvaWQgKnByaXZhdGVfc3B0KQ0K
PiArCQkJICAgICAgIHZvaWQgKnByaXZhdGVfc3B0LCBib29sIG1tdV9sb2NrX3NoYXJlZCkNCj4g
IHsNCj4gIAlzdHJ1Y3QgcGFnZSAqcGFnZSA9IHZpcnRfdG9fcGFnZShwcml2YXRlX3NwdCk7DQo+
ICAJaW50IHJldDsNCj4gQEAgLTE4NDIsNiArMTg0MiwyOSBAQCBpbnQgdGR4X3NlcHRfc3BsaXRf
cHJpdmF0ZV9zcHQoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sIGVudW0gcGdfbGV2ZWwgbGV2
ZWwsDQo+ICAJaWYgKEtWTV9CVUdfT04odG9fa3ZtX3RkeChrdm0pLT5zdGF0ZSAhPSBURF9TVEFU
RV9SVU5OQUJMRSB8fCBsZXZlbCAhPSBQR19MRVZFTF8yTSwga3ZtKSkNCj4gIAkJcmV0dXJuIC1F
SU5WQUw7DQo+ICANCj4gKwkvKg0KPiArCSAqIFNwbGl0IHJlcXVlc3Qgd2l0aCBtbXVfbG9jayBo
ZWxkIGZvciByZWFkaW5nIGNhbiBvbmx5IG9jY3VyIHdoZW4gb25lDQo+ICsJICogdkNQVSBhY2Nl
cHRzIGF0IDJNQiBsZXZlbCB3aGlsZSBhbm90aGVyIHZDUFUgYWNjZXB0cyBhdCA0S0IgbGV2ZWwu
DQo+ICsJICogSWdub3JlIHRoaXMgNEtCIG1hcHBpbmcgcmVxdWVzdCBieSBzZXR0aW5nIHZpb2xh
dGlvbl9yZXF1ZXN0X2xldmVsIHRvDQo+ICsJICogMk1CIGFuZCByZXR1cm5pbmcgLUVCVVNZIGZv
ciByZXRyeS4gVGhlbiB0aGUgbmV4dCBmYXVsdCBhdCAyTUIgbGV2ZWwNCj4gKwkgKiB3b3VsZCBi
ZSBhIHNwdXJpb3VzIGZhdWx0LiBUaGUgdkNQVSBhY2NlcHRpbmcgYXQgMk1CIHdpbGwgYWNjZXB0
IHRoZQ0KPiArCSAqIHdob2xlIDJNQiByYW5nZS4NCj4gKwkgKi8NCj4gKwlpZiAobW11X2xvY2tf
c2hhcmVkKSB7DQo+ICsJCXN0cnVjdCBrdm1fdmNwdSAqdmNwdSA9IGt2bV9nZXRfcnVubmluZ192
Y3B1KCk7DQo+ICsJCXN0cnVjdCB2Y3B1X3RkeCAqdGR4ID0gdG9fdGR4KHZjcHUpOw0KPiArDQo+
ICsJCWlmIChLVk1fQlVHX09OKCF2Y3B1LCBrdm0pKQ0KPiArCQkJcmV0dXJuIC1FT1BOT1RTVVBQ
Ow0KPiArDQo+ICsJCS8qIFJlcXVlc3QgdG8gbWFwIGFzIDJNQiBsZWFmIGZvciB0aGUgd2hvbGUg
Mk1CIHJhbmdlICovDQo+ICsJCXRkeC0+dmlvbGF0aW9uX2dmbl9zdGFydCA9IGdmbl9yb3VuZF9m
b3JfbGV2ZWwoZ2ZuLCBsZXZlbCk7DQo+ICsJCXRkeC0+dmlvbGF0aW9uX2dmbl9lbmQgPSB0ZHgt
PnZpb2xhdGlvbl9nZm5fc3RhcnQgKyBLVk1fUEFHRVNfUEVSX0hQQUdFKGxldmVsKTsNCj4gKwkJ
dGR4LT52aW9sYXRpb25fcmVxdWVzdF9sZXZlbCA9IGxldmVsOw0KPiArDQo+ICsJCXJldHVybiAt
RUJVU1k7DQoNClRoaXMgaXMgdG9vIGhhY2t5IHRoZSB3YXkgaXQgaW5mZXJzIHNvIG11Y2ggZnJv
bSBtbXVfbG9ja19zaGFyZWQuIFNpbmNlIGd1ZXN0cw0Kc2hvdWxkbid0IGJlIGRvaW5nIHRoaXMs
IHdoYXQgYWJvdXQganVzdCBkb2luZyBrdm1fdm1fZGVhZCgpLCB3aXRoIGEgbGl0dGxlDQpwcl93
YXJuKCk/IE1heWJlIGV2ZW4ganVzdCBkbyBpdCBpbiBzZXRfZXh0ZXJuYWxfc3B0ZV9wcmVzZW50
KCkgYW5kIGRlY2xhcmUgaXQNCnRoZSBydWxlIGZvciBleHRlcm5hbCBwYWdlIHRhYmxlcy4gSXQg
Y2FuIHNocmluayB0aGlzIHBhdGNoIHNpZ25pZmljYW50bHksIGZvcg0Kbm8gZXhwZWN0ZWQgdXNl
ciBpbXBhY3QuDQoNCj4gKwl9DQo+ICsNCj4gIAlyZXQgPSB0ZHhfc2VwdF96YXBfcHJpdmF0ZV9z
cHRlKGt2bSwgZ2ZuLCBsZXZlbCwgcGFnZSk7DQo+ICAJaWYgKHJldCA8PSAwKQ0KPiAgCQlyZXR1
cm4gcmV0Ow0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC94ODZfb3BzLmggYi9hcmNo
L3g4Ni9rdm0vdm14L3g4Nl9vcHMuaA0KPiBpbmRleCAwNjE5ZTkzOTBlNWQuLmZjYmE3Njg4NzUw
OCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC94ODZfb3BzLmgNCj4gKysrIGIvYXJj
aC94ODYva3ZtL3ZteC94ODZfb3BzLmgNCj4gQEAgLTE1OSw3ICsxNTksNyBAQCBpbnQgdGR4X3Nl
cHRfc2V0X3ByaXZhdGVfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4gIGludCB0
ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0K
PiAgCQkJCSBlbnVtIHBnX2xldmVsIGxldmVsLCBrdm1fcGZuX3QgcGZuKTsNCj4gIGludCB0ZHhf
c2VwdF9zcGxpdF9wcml2YXRlX3NwdChzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwgZW51bSBw
Z19sZXZlbCBsZXZlbCwNCj4gLQkJCSAgICAgICB2b2lkICpwcml2YXRlX3NwdCk7DQo+ICsJCQkg
ICAgICAgdm9pZCAqcHJpdmF0ZV9zcHQsIGJvb2wgbW11X2xvY2tfc2hhcmVkKTsNCj4gIA0KPiAg
dm9pZCB0ZHhfZmx1c2hfdGxiX2N1cnJlbnQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gIHZv
aWQgdGR4X2ZsdXNoX3RsYl9hbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gQEAgLTIyOCw3
ICsyMjgsOCBAQCBzdGF0aWMgaW5saW5lIGludCB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRl
KHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgDQo+ICBzdGF0aWMgaW5saW5lIGludCB0
ZHhfc2VwdF9zcGxpdF9wcml2YXRlX3NwdChzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4g
IAkJCQkJICAgICBlbnVtIHBnX2xldmVsIGxldmVsLA0KPiAtCQkJCQkgICAgIHZvaWQgKnByaXZh
dGVfc3B0KQ0KPiArCQkJCQkgICAgIHZvaWQgKnByaXZhdGVfc3B0LA0KPiArCQkJCQkgICAgIGJv
b2wgbW11X2xvY2tfc2hhcmVkKQ0KPiAgew0KPiAgCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gIH0N
Cg0K

