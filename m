Return-Path: <kvm+bounces-49637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F99ADBD37
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 00:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C7AE1892333
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 22:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13DA32264B2;
	Mon, 16 Jun 2025 22:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jypaUpUq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A190B1F4701;
	Mon, 16 Jun 2025 22:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750114174; cv=fail; b=ASd2e8cjEAIkiHjwSibpwOf5Akl3OxIGYOO4glUzqCIY+dbRVoazxRus9Ye1wZA2cDUHTM4AxSB7jf1tLthWbO03oth5y4dNIoS6L9EKpHCIs4O07IptuY7DGJ8f7bmwOJBj2RMAkqPJJ343xJYsL7a0k5Prn3OhYROv0Ad07vI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750114174; c=relaxed/simple;
	bh=BjdjhfDeE0P0W9+e1hjgodY1sUEC45OcpS9eukNl4Xg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QHVQ+ctp8IeMX6xdm0gNKeSuOilCPh16Y41yHfGmBLrmCRtOPA9LP+p/MCtLc6rzgQZZ7hHlaRjpX1gg2fw3sDQ8Vr7HcZ+6nirSXUsZC6FVe6My3kQfqFnv8h3Mocne9iwxf3BgP33WtsIwUQjySaXhaWV84AXhrUJOYhJjoAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jypaUpUq; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750114173; x=1781650173;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BjdjhfDeE0P0W9+e1hjgodY1sUEC45OcpS9eukNl4Xg=;
  b=jypaUpUqLLNwxOtRBaePyboz5dO4Al41Xm81zHHrZ+llH7+FH5zhxz4P
   SoI6xa0M+HdambtY978NNdZYcIHtdMo/6HqhSClgDQ72iepABJOGfjaKj
   4VmpQmET1y6f/MfQhI5L1eH/jt979FKR2Papxdo/T6rYAV7uzi2hPJ27S
   2dppyOCmNMZWvpIYKbmvtptEbyqhoo3At3Pwv792PvQXJfxMU4CVhTfZU
   MwGrJbOjeYFDIHvyLwYN4tZMsG0fP1py2iXguohqpo/d/zuqfcIv1seQl
   wMPyaJYNtbWdQqnQ594Oh9RnqSblHIxQUWL/3afZ+9BiuYhPHoXr6EsZc
   Q==;
X-CSE-ConnectionGUID: 4opf4LA2R4S6wA+dh0ECCA==
X-CSE-MsgGUID: fB+3BOqxTg2QwJBGaG8yRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="69713464"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="69713464"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 15:49:32 -0700
X-CSE-ConnectionGUID: TsAd6FzGSGG9NkiyGg+rMw==
X-CSE-MsgGUID: ff7MHc7ASSSxLVWnOwM9Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="153894511"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 15:49:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 15:49:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 15:49:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.75) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 15:49:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHieZ8ihIw0upa1rN3K1xSCXEfk41NiF2rbGYUffEceCr99yR9gNc33WO5NIrvzjFMdiVfGh9jy/HxGpiC9p0cxzR4B3EHounDFPENQEUogwXs+QeAnej4aanWqI6bUfZoFiYZw0EyG6wPJ4cN5GOxkb8YY1DFuEBNQcBjBQFn5Kd+PEPkszxIu+Q3SN8PqwSIo+6MtM5WN+IQv7mI+KKvNZ9Bu7NVgN4YH9JdlF53kDv+3A9HyR7+wXWMEomPne5YehvMUy/IhuhrN8wgnHaWQstd08BUICJ2B30/J6D9bJLADKdaBQ1p3njyvIgFg+/UKmQzjmhh8Y32e1cWmRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BjdjhfDeE0P0W9+e1hjgodY1sUEC45OcpS9eukNl4Xg=;
 b=eRE0RakYMFomqEXutcDKlA0e8W30koyglkqbm0EeH89ySDwIbk+reE9MQ0ZOBhUvbJZOgSMXClgpIDIkutym7Ec65uRLzGcpgWpDmaosFymqYiXp9qckKyVhVco2eO5E6rwa2KGOfJnQ8HhU31FS9BPjWzuTx2KgofuTXQNrj/VDadjdgbZeNsJOppi57vEP4h8/Xeqo/9gjq05UNjJaMfyANFWig1n8G9SyfpuSj0yggoKjK/lgTdBMKHi+IINT7hbK/jN6lHgyS2xfz8GRFk021BX8K+UtLp8yoRcys0cJWq+fp8gkcQgz6u3nqTdiqyYxkkvPn+pU4r7JIBQW/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7332.namprd11.prod.outlook.com (2603:10b6:208:434::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 22:49:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Mon, 16 Jun 2025
 22:49:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYA=
Date: Mon, 16 Jun 2025 22:49:00 +0000
Message-ID: <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
References: <aEmVa0YjUIRKvyNy@google.com>
	 <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
	 <aEtumIYPJSV49_jL@google.com>
	 <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
	 <aEt0ZxzvXngfplmN@google.com>
	 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
	 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
	 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
	 <aEyj_5WoC-01SPsV@google.com>
	 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
	 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
In-Reply-To: <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7332:EE_
x-ms-office365-filtering-correlation-id: e644e387-3569-406e-a214-08ddad27fc6d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UDE3NVh2c3BtS2dOVEd0SHBVMFFoaHl4em9pQ1RwK0I0SGlRSE1FSHlvNjll?=
 =?utf-8?B?SlkzNENhYWNIbmR5VFFPS3NwR252SXdXTW5rOHptd21qeVd1WGo3TW81UWY2?=
 =?utf-8?B?aGwrcUZNR3ZET2V4Wi90Z05nT1o4OUdpbmRjeXlwREpWbUg5WUJobUtZN1Rl?=
 =?utf-8?B?cG1DWnFxaUpCRWtvMDlPV1VXWFFVZmRVbkJENFFVcjcyRWJucTJrQmdGQTUx?=
 =?utf-8?B?RG0vNVR2c2hlem9sOVlVWk9zd0V6K29BSnVhNXpyN1VLeGRFcUNtdXNpT2pH?=
 =?utf-8?B?blh0RE5XYmpVUVFZYUlrZ3RrRHN3bTBEMHo3Ym5yQnFGTTdTdEZBSHJxNngy?=
 =?utf-8?B?eElkRXZPTjNVeko3SVhrM3l6TlZBT1pkYnpLVkdTNGY5emVXRG9jY0djZ0dt?=
 =?utf-8?B?dEFyQ1lEU0hpcDhhdUs5MzArRmZ3QnJIKzZpUDJVUHhSekFMbTJxN3YwMmQx?=
 =?utf-8?B?NEMwemFka09KeE1ydWVxYmpLNW05ZTQ5Q2MxRUtFNkxnVDh0eGZkdWN5K1Na?=
 =?utf-8?B?SE9JK3hPM0ZIbktmNU5RUzJuUzdtS0V6NGpZNVFWdXZKODZjZDBlU2k1L3RP?=
 =?utf-8?B?RUZ1eWhlMDB4TVJ3Y0g2ZVNTbVFSOFpFeXV3SXMwcm0wQ2RqemJtSXZCcm1z?=
 =?utf-8?B?N1ZOVGRPeE9hMkk0NXlyMGhJcWJoV2J3OXN3bVE3VUxFTkJDQVBic2hDT0px?=
 =?utf-8?B?Z3I3NHBMa1dmOThPNElqQWt5TmU4ODhsZjR3elZJb3diMWl2bUF1elIxMEtU?=
 =?utf-8?B?Y3BobTlMQ094dGRtRStoZUdqSmxyUFI5dnFyT0VxV1RIS24vNUYzT3FjM2pI?=
 =?utf-8?B?QzdFU3U3ZDlDMUhPRHg5RXNRQVcwWTVQUnZpUmlqT2RxSTN3eGJuLzZ4NEx5?=
 =?utf-8?B?VHUycnFFVVkwVjJXekZWczljWUpkdEtEbUp1MmN1NWlSNTdMdk83VHF3WUlv?=
 =?utf-8?B?alhPVFNtcVFDZThUblFGSnlLWWtGcFNtVWJFOHc4TW5qZXpMb1BsZnVsZ1Ba?=
 =?utf-8?B?NWh1OFdIdGJoSHg0OWNHa3NYMy81Y3ZGZVR2TnFOaTVoQXlmcVpRMFRMOGpM?=
 =?utf-8?B?U0YrR21rWERDUGlSYTEwU2ZMRjVVYkRuTkJsTEpWdHBROWs0QWJHdVdJTnlF?=
 =?utf-8?B?MWFheGRIY3lodUJuOHo0VzQ2aFU3S2trME1KakhITStwRUoyVEVnSWpBM1Vo?=
 =?utf-8?B?TytvRWxSQ3JhNDd1YWVBYzdGR2JnZ0hheit3MjRXUitobXBLNjNSVldVc3N6?=
 =?utf-8?B?L21yaXZ0NXoxc25mVUhzcDRrVDBiWkdOTDlITEtZMkF0NUJGczMzVytrZnEz?=
 =?utf-8?B?MHp6MkhGNnpDTXFqQnZDQm1DZ1hvQWIzaWU0dW1LdkdLM253MjFlZXJTZTZT?=
 =?utf-8?B?S3FoNUNrY2pGb0VsZlh6dWJjU1B6Q0VmMk1MYll1UWZTL0tjb3lRWXVHbGNT?=
 =?utf-8?B?ZzZXbkZRS3I2K3dUVHlCREhXUWdCaFA0N2tCWGhSRGg0a0JOVDhwOTJkZkxC?=
 =?utf-8?B?eFYra1diYmxmeVRsc0NPQTNHM2lvUDExSDVCUllGdWx1NGZwbDc3QyszNVVj?=
 =?utf-8?B?YzB3K050emxENHdjNVpMengvTXdpNVZ0WUJSbG9kVlh5VUdoMURxQWdoVmlz?=
 =?utf-8?B?cjZuMmdXMCs1TmNzOUZoZjdxcUwwSE9DSzl0YWEyN3BUUU5weHFjL2F4Rm1G?=
 =?utf-8?B?TzhPTG5lOFJPVERmRjFJUGlYQ1ByRWZ1VGROaXN6QXVBWk91NTU5ZUdWL2Zp?=
 =?utf-8?B?eWlvZWRFVDhabWR5N21rdjFzTnFSS1FRM2RNNGRZSStNOHNyeC9aOUtvRUNN?=
 =?utf-8?B?RStCLzJYelN4MWkxZUo3dStycHpaUzJzSW1XY05IZ3k1K3hvRmZYVFA0Uk9F?=
 =?utf-8?B?TVFuN1NLWXExcmlaK3FRWGtQSjMzeDNRMXhzNEYzT0E3ZjN4RnNFVFBBNmxp?=
 =?utf-8?B?cFdyY0NWT2FKRkRFdWdSR08wWUtFdytjOXo4NXl5aDNEZHNUYkQrWlNLbGEv?=
 =?utf-8?B?SWtYNGZMcXp3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHNtd24xb0FjQjZhUlBaeElhQlhpb2cwTTFYOXZEbWNub2xweHQwVlZYMlRZ?=
 =?utf-8?B?SmVIbElnOG96dGorUDBOMmVIajhyeEc1aGxIVUlhSUpJQXZxaFoxbHVtQmI3?=
 =?utf-8?B?SSthQ3NFYVdUZWg2NWxsVytqY1hjTXZDWkNvbXpsVDUvNDM5dzNBZ1UwalI2?=
 =?utf-8?B?RHRsL2VhSFFOQmxwbVQzQjNNK2ZqQlU2T1ZCMU02cWdCeUZ0RHQ0M1R4aXJm?=
 =?utf-8?B?UkJ4QWdBbkpMVTVUTzl6cGxoWmQyUWI2emNGREhrNHl6TG5xdVB1MGF1ckhY?=
 =?utf-8?B?ckJSS2pXVXNyMjJZd0QrbXlQT2ZzR3Q5alpCV3RQNlJRdmhDeHQ3MlFxclFS?=
 =?utf-8?B?UXJiK0s3S1VCejd2eDhQbE9MME9qZkxPTldCNmFxbXVTV3hoYnlqRWtHcFcy?=
 =?utf-8?B?REpFQXN2bmhsMEFocC9XU2FMbDBlSm5xeTBCaElpdlREdUVSc0NTYWtXLzVB?=
 =?utf-8?B?VFVEdVVvQWtGMVk3V2pTVVJBRXNMckFRdm5NNXVtYjQ3YW9PTFVQNDh0RGJU?=
 =?utf-8?B?RzdvN1dvVUhiWDlhajQ3UkhnczFjYVJncFJLdUZYSDM4ZjFSNGt3MTFNMFVQ?=
 =?utf-8?B?N2tRL1lMd3FSd3FXenJvejZvMmRNOUJHRmtwMFRCaHNNbyt0MGZzZ2FabHB3?=
 =?utf-8?B?NE8vWHErOForTlpSMW9EcWkzckRwSzh0L2FqTDlHN3U1eCtybDQvZzF5MmU4?=
 =?utf-8?B?S3JBZ0JtV0toQzRUUXJpWWw4T2x0ejJWaVk2TXg3bTFzYjEwQnFmaEJzWTBF?=
 =?utf-8?B?ZVd2aHFKcjh4NGY2azZiWW5wN084akJ3ZWZKRVdObUxHVS9NWStJK05vMnV2?=
 =?utf-8?B?YXN6dDMwZkNKOVBkdmt4NGxWTG1lZGpnVUw4WDBZT0FYS0NPSEZkMGdpRUcz?=
 =?utf-8?B?dlJWOGtpQkM0Q0dvT05NYkhnb0trV2xZM2MrSmRxQm9vQkNZU2htcmZscWor?=
 =?utf-8?B?VzBYR0dZaHFLcUJMMG5hR1gzSktMM2JSeE84VVRORlFSbE1jclo2Qmw3Nm5m?=
 =?utf-8?B?V2greWtIU1Z4dzhRK1JpZ3R4cyt2VzlVZjJXc0VjTWc1TjV6NnovWmxTdFZm?=
 =?utf-8?B?T251TXdXRElLNUxCNDBTSGhhNDJDYy9CNG1nUG42R2dRRXpvdlhleUdnRTlX?=
 =?utf-8?B?aW9UTmxIZnczR2lOcjFiSHdmajNTVzhjRGxRNm40ZFlGZzdRRGFhWmtJY3Iy?=
 =?utf-8?B?ejl5dVArNEJNdmZuR0FMbHhDZTliTmRRREtnd3RJK2FWd21uZTA3ZlhSM0p1?=
 =?utf-8?B?K09JSVVsdk15bG1qZE9kSWltMnd3dCsyL0tXbjlNeTlWR1VGM2dUejFxdS9S?=
 =?utf-8?B?K245Nks5VmExeUxJZndqZUl4MkNTUFJuUTV5bHZ4UG53czUwb2pialJLZ0FI?=
 =?utf-8?B?RkZiNEVFSHBFTUtFSzRoR1B2eVFLZTVaT1FmY1pGUURCYnJhN2VRS0RaMDdq?=
 =?utf-8?B?clo3VFVLQndva0JoQlJVOXVUZWJObmNqNkhXQWpPVElpeTh4YitnTWJVOUxp?=
 =?utf-8?B?WlkwejdaTmZjSUhRSUJHMkp6TnJOdlNtZUFzWUl5NjVobENWUGpSSWtiQUg5?=
 =?utf-8?B?NGJsZGpOYTQ0WVdHYkNMd2dINmd1bnh2ZHE3K2FBVzdmN2s1cWdrbHpIaDN4?=
 =?utf-8?B?NkNHTEZNNm5tSi81SVhzTGEzQXRidHNLbkxDTUorTmRHTXJzd3l6bGsvVDIy?=
 =?utf-8?B?c2pWZ0lXbWNmcnNkSmpEYnVhMzVRY2VaenBOdExaNjNLNHZvWkZ3OU5QUlpF?=
 =?utf-8?B?dlJxNmlVY2ZhaUJYMFFJNEwxVWExN0RDSVpaL1NlUVYyVTZ3TGtacWs3Nk9i?=
 =?utf-8?B?cjlFOFZPVnNhdHorKzU3UGlRQlBnUXlocjJrQXA3V3drUjU1Y0gzQ1FvM3hZ?=
 =?utf-8?B?YXRaRzZVelhxd3ZyVFA1NHVJczhoc2RzQ2JHVGVCRGl5QjVCaGlBQVN5SlI4?=
 =?utf-8?B?cFBtWDh6dmZRQ21NYmR2RlVLQ2YwcGVFaElVdm5wbjdWcFVsVTR3cjBUczBB?=
 =?utf-8?B?QVVlU0RmWWwyVnJLNDJpQUNoYnlBcytrWUpDZktybFRwQ3grV2F2US9OV04r?=
 =?utf-8?B?L2R4UTBDcllway84MlVZZXRkdlN3V29KVnN2QXBTYjIveWZaWElmM1JsYVFv?=
 =?utf-8?B?akJQVjBHUUUvVXQvdlFnS0xBY2RZSlFoQjhocnJXMUoydkxIN0lWSzA0aXRT?=
 =?utf-8?Q?lPnQoykbcx9wQZpCOPHOwWc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <906BBCAB33A997479B8D918D1BFE7748@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e644e387-3569-406e-a214-08ddad27fc6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2025 22:49:00.6640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h4IEhqpn/MkYmmI2urTjOqo/wBl703/+zGcEGBA5fvF0WshVD88XnHBRuMLmYi0bp3Hvwhi6pp70r9T+lrtEl4OoBGEvsHjQ6flQLKMJ8Ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7332
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTE2IGF0IDExOjE0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBP
aCwgbmljZS4gSSBoYWRuJ3Qgc2VlbiB0aGlzLiBBZ3JlZSB0aGF0IGEgY29tcHJlaGVuc2l2ZSBn
dWVzdCBzZXR1cCBpcw0KPiA+IHF1aXRlDQo+ID4gbWFudWFsLiBCdXQgaGVyZSB3ZSBhcmUgcGxh
eWluZyB3aXRoIGd1ZXN0IEFCSS4gSW4gcHJhY3RpY2UsIHllcyBpdCdzDQo+ID4gc2ltaWxhciB0
bw0KPiA+IHBhc3NpbmcgeWV0IGFub3RoZXIgYXJnIHRvIGdldCBhIGdvb2QgVEQuDQo+IENvdWxk
IHdlIGludHJvZHVjZSBhIFREIGF0dHIgVERYX0FUVFJfU0VQVF9FWFBMSUNJVF9ERU1PVElPTj8N
Cj4gDQo+IEl0IGNhbiBiZSBzb21ldGhpbmcgc2ltaWxhciB0byBURFhfQVRUUl9TRVBUX1ZFX0RJ
U0FCTEUgZXhjZXB0IHRoYXQgd2UgZG9uJ3QNCj4gcHJvdmlkZSBhIGR5bmFtaWNhbCB3YXkgYXMg
dGhlIFREQ1NfQ09ORklHX0ZMRVhJQkxFX1BFTkRJTkdfVkUgdG8gYWxsb3cgZ3Vlc3QNCj4gdG8N
Cj4gdHVybiBvbi9vZmYgU0VQVF9WRV9ESVNBQkxFLg0KPiAoU2VlIHRoZSBkaXNhYmxlX3NlcHRf
dmUoKSBpbiAuL2FyY2gveDg2L2NvY28vdGR4L3RkeC5jKS4NCj4gDQo+IFNvLCBpZiB1c2Vyc3Bh
Y2UgY29uZmlndXJlcyBhIFREIHdpdGggVERYX0FUVFJfU0VQVF9FWFBMSUNJVF9ERU1PVElPTiwg
S1ZNDQo+IGZpcnN0DQo+IGNoZWNrcyBpZiBTRVBUX0VYUExJQ0lUX0RFTU9USU9OIGlzIHN1cHBv
cnRlZC4NCj4gVGhlIGd1ZXN0IGNhbiBhbHNvIGNoZWNrIGlmIGl0IHdvdWxkIGxpa2UgdG8gc3Vw
cG9ydCBTRVBUX0VYUExJQ0lUX0RFTU9USU9OIHRvDQo+IGRldGVybWluZSB0byBjb250aW51ZSBv
ciBzaHV0IGRvd24uIChJZiBpdCBkb2VzIG5vdCBjaGVjaw0KPiBTRVBUX0VYUExJQ0lUX0RFTU9U
SU9OLA0KPiBlLmcuLCBpZiB3ZSBkb24ndCB3YW50IHRvIHVwZGF0ZSBFREsyLCB0aGUgZ3Vlc3Qg
bXVzdCBhY2NlcHQgbWVtb3J5IGJlZm9yZQ0KPiBtZW1vcnkgYWNjZXNzaW5nKS4NCj4gDQo+IC0g
aWYgVEQgaXMgY29uZmlndXJlZCB3aXRoIFNFUFRfRVhQTElDSVRfREVNT1RJT04sIEtWTSBhbGxv
d3MgdG8gbWFwIGF0IDJNQg0KPiB3aGVuDQo+IMKgIHRoZXJlJ3Mgbm8gbGV2ZWwgaW5mbyBpbiBh
biBFUFQgdmlvbGF0aW9uLiBUaGUgZ3Vlc3QgbXVzdCBhY2NlcHQgbWVtb3J5DQo+IGJlZm9yZQ0K
PiDCoCBhY2Nlc3NpbmcgbWVtb3J5IG9yIGlmIGl0IHdhbnRzIHRvIGFjY2VwdCBvbmx5IGEgcGFy
dGlhbCBvZiBob3N0J3MgbWFwcGluZywNCj4gaXQNCj4gwqAgbmVlZHMgdG8gZXhwbGljaXRseSBp
bnZva2UgYSBURFZNQ0FMTCB0byByZXF1ZXN0IEtWTSB0byBwZXJmb3JtIHBhZ2UNCj4gZGVtb3Rp
b24uDQo+IA0KPiAtIGlmIFREIGlzIGNvbmZpZ3VyZWQgd2l0aG91dCBTRVBUX0VYUExJQ0lUX0RF
TU9USU9OLCBLVk0gYWx3YXlzIG1hcHMgYXQgNEtCDQo+IMKgIHdoZW4gdGhlcmUncyBubyBsZXZl
bCBpbmZvIGluIGFuIEVQVCB2aW9sYXRpb24uDQo+IA0KPiAtIE5vIG1hdHRlciBTRVBUX0VYUExJ
Q0lUX0RFTU9USU9OIGlzIGNvbmZpZ3VyZWQgb3Igbm90LCBpZiB0aGVyZSdzIGEgbGV2ZWwNCj4g
aW5mbw0KPiDCoCBpbiBhbiBFUFQgdmlvbGF0aW9uLCB3aGlsZSBLVk0gaG9ub3JzIHRoZSBsZXZl
bCBpbmZvIGFzIHRoZSBtYXhfbGV2ZWwgaW5mbywNCj4gwqAgS1ZNIGlnbm9yZXMgdGhlIGRlbW90
aW9uIHJlcXVlc3QgaW4gdGhlIGZhdWx0IHBhdGguDQoNCkkgdGhpbmsgdGhpcyBpcyB3aGF0IFNl
YW4gd2FzIHN1Z2dlc3RpbmcuIFdlIGFyZSBnb2luZyB0byBuZWVkIGEgcWVtdSBjb21tYW5kDQps
aW5lIG9wdC1pbiB0b28uDQoNCj4gDQo+ID4gV2UgY2FuIHN0YXJ0IHdpdGggYSBwcm90b3R5cGUg
dGhlIGhvc3Qgc2lkZSBhcmcgYW5kIHNlZSBob3cgaXQgdHVybnMgb3V0LiBJDQo+ID4gcmVhbGl6
ZWQgd2UgbmVlZCB0byB2ZXJpZnkgZWRrMiBhcyB3ZWxsLg0KPiBDdXJyZW50IEVESzIgc2hvdWxk
IGFsd2F5cyBhY2NlcHQgcGFnZXMgYmVmb3JlIGFjdHVhbCBtZW1vcnkgYWNjZXNzLg0KPiBTbywg
SSB0aGluayBpdCBzaG91bGQgYmUgZmluZS4NCg0KSXQncyBub3QganVzdCB0aGF0LCBpdCBuZWVk
cyB0byBoYW5kbGUgdGhlIHRoZSBhY2NlcHQgcGFnZSBzaXplIGJlaW5nIGxvd2VyIHRoYW4NCnRo
ZSBtYXBwaW5nIHNpemUuIEkgd2VudCBhbmQgbG9va2VkIGFuZCBpdCBpcyBhY2NlcHRpbmcgYXQg
NGsgc2l6ZSBpbiBwbGFjZXMuIEl0DQpob3BlZnVsbHkgaXMganVzdCBoYW5kbGluZyBhY2NlcHRp
bmcgYSB3aG9sZSByYW5nZSB0aGF0IGlzIG5vdCAyTUIgYWxpZ25lZC4gQnV0DQpJIHRoaW5rIHdl
IG5lZWQgdG8gdmVyaWZ5IHRoaXMgbW9yZS4NCg==

