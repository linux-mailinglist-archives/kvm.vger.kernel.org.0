Return-Path: <kvm+bounces-15977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD968B2B39
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60EF51C23ED0
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 21:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E142415D5CF;
	Thu, 25 Apr 2024 21:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kd3czBfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A7015CD58;
	Thu, 25 Apr 2024 21:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714081494; cv=fail; b=b4SBJgsyDVC2+Mcikvmi4vryaTm5sRaMWrWuC/lDiIfDn1aBoaZkPPYy63gX95nxAdwkiFrdzJTwvHySg6TzFP4YG019BIFcaiVdtKFOQUEk7BgpNLjzXBb5hOyASNetebLaGais5EbUB0ZgcEmdq4ihOBhkbOKYvUxAdSiQT94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714081494; c=relaxed/simple;
	bh=eB4iWElIrM4zo+FHMS81T5stgpSaHaF2jbHDVaU3Zs0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uY4amtWZ/OaPxOJUaT40G2PNZbc2elPsBS0Tt350UlaRfIrvtQ6xcwcx7Madg1Sk3BDuFOiNCgUHyjyNZL9QS7pR/d+B89d4SXYX2P4mW+Lk/s60zeTVecwNgjFEAwQjQY/4KrGWr1TgkQGRDTVlMvE2MPLNkotAgGihCNMkg10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kd3czBfZ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714081492; x=1745617492;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eB4iWElIrM4zo+FHMS81T5stgpSaHaF2jbHDVaU3Zs0=;
  b=Kd3czBfZEhX6Jv5RKNdv7PDDQA7r82hFWSvSZxa/TeITti3LqXVHeqf6
   EAZzGg4mGioIApRSp+iExhgpUSjSQ7cr5Oil12ipth6m3A58Tq4Q2aic2
   Bb//PHu1uXXuAmZlYoFDgAuCBFuQwd2dxSNMHwuy1AzURlffKZBXenSBd
   NCzK4Gqsr3dXv12utyznbbbqoTQzhObRmLSRLjoW4ONek2Q0p7MiXCQur
   h6/bJK97YiMOjSSaKC7LbYlDJ7KdFubdB2Rgk8k7ePz+CdlV6FaJQXACJ
   9xuziAf/gx/jMSR1eTJQHzzgupgmOBo0LkzBQDTY/5sWKINZVjQJJSqzK
   Q==;
X-CSE-ConnectionGUID: 8SgLml9nT6e/gAg4N2ZdNQ==
X-CSE-MsgGUID: cLH5zgpiRA+x0AwBIfPFbg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9961699"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="9961699"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 14:44:51 -0700
X-CSE-ConnectionGUID: R6QGyjM/QFmmfB3p06gZfg==
X-CSE-MsgGUID: gstu84+4Tyuq1dWx+qr4tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="62690822"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 14:44:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 14:44:50 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 14:44:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 14:44:50 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 14:44:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/lFZE/NKkNvL6abRmDtW8iTmq1NYewMd/d5oh8vXGUxwSJUOqYHYFaUkpG/xcst2ppvPMFWd2gPF7PEOqcryzfzU/5CuEDxY+bWuioPEIpmn8q6EobuA2LMyIFOokPU2YIioAQUHM6EliNfCeqvYzkXPDXgyBpccVMkDe3sRbxr+NY2PkoC+jCOUfSlbaQjopnJnnnEzdpaBFCCrT3sN0+iIYe4yRoh/90y4fNz5wuaqefvR1bb5OEDAT/kCU4ABkNjIcc1VFpAwWwmxC4r9UHq2DxlBGgTRZeQ1kGvMOHJUhk6WnN6dbhCsbHijzF0jYNe1KlcW6mCGBn5W/q3Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB4iWElIrM4zo+FHMS81T5stgpSaHaF2jbHDVaU3Zs0=;
 b=Lv3W9WqQmu4taqCxnr5vVPAL7mFbVSWbzkcZSNIYwp558qaDXL6uRpx06RYWDY0S4VvNODgCq/06N1a6sXtRmuL2khk5edmStk4WtRPWLCcISV3fMCAZwLA/N4+KlgDJkcykxEQ1/SDU6jkv/JsTLbwe185srERlCoWYQ8z3HGCEBtAYmpSzFNeUi2VCCSnGD9tYmEl8Y8gV2Bo+N5uZAiuJJfVwJHPdRa1uYoMRtaNcxgilTSvWL7q8EnEFK2F1jR6Y0LAki4SmxQifoGarn+0y0WtFbo77si3h8E/Um2OMa6hlqx6EL4KXJNTPYlHa3fciEpqgWFMWaSdpnJ5BlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB6669.namprd11.prod.outlook.com (2603:10b6:a03:449::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.24; Thu, 25 Apr
 2024 21:44:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 21:44:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "Liu, Zhao1" <zhao1.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Kang, Shan"
	<shan.kang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
Thread-Topic: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate
 mask in its accessor
Thread-Index: AQHaccEFvtQhH+vFrkOHoBYSjiDforE4/FIAgAAjwQCAGgLcgIACjaUAgCJxxQCAAOpDgIAATVuAgAB2F4A=
Date: Thu, 25 Apr 2024 21:44:46 +0000
Message-ID: <26afec9c667327191850b17c511901623e91976e.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-9-seanjc@google.com> <ZfRtSKcXTI/lAQxE@intel.com>
	 <ZfSLRrf1CtJEGZw2@google.com>
	 <1e063b73-0f9a-4956-9634-2552e6e63ee1@intel.com>
	 <ZgyBckwbrijACeB1@google.com> <ZilmVN0gbFlpnHO9@google.com>
	 <64cc46778ccc93e28ec8d39b3b4e31842154f382.camel@intel.com>
	 <Zipru9eB9oDOOuxf@google.com>
In-Reply-To: <Zipru9eB9oDOOuxf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB6669:EE_
x-ms-office365-filtering-correlation-id: a32fbc08-92a3-4b69-8ec5-08dc6570ecdc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?bjdkRVVmRnhGYVpCNDY0NFBxa29jaTY3aStzTlM5SmpiV0xrVjZYMjRoczJU?=
 =?utf-8?B?WnNhZnZXSGtrSWlzUnZMVHk5R0FPTmNLWUpDejVSWE4raHcwK21YbmZydnBm?=
 =?utf-8?B?WWh2MTJKR2ZWeEU4VjNLZHNxajdlYnFHenEzdi9Vbm56SW54SEliSXNpWlBw?=
 =?utf-8?B?SFJuWjRpMkhSSUZPV3JCLzUrMWNEOGRqK0NOdHZnTEZxTEVodUprYzY1QjhL?=
 =?utf-8?B?NzQ0VkxWb3JZcnFVS210aXJmWkJVS3F1YW95WEpQWkxrVlEvMXR0c3JDQkN2?=
 =?utf-8?B?NmFCN3hlUXoreDFsVDZ4Y1hpa0pPN3BITzloUTRDOGU0a1F3UXN3SzRGTGNk?=
 =?utf-8?B?Y2FsaVpGVFUyZ1pibXllOVN5SmVVdndHUkw0dWplTTFWbkx1S3JUS1VMYjZE?=
 =?utf-8?B?SUFQbXQ5MG1WT0hlZzFNdDZOVDhPL0xIZ3R4RDlVa09DM2tqeUF5TCsvRU45?=
 =?utf-8?B?T0JEVk9laHFXbVJqNVZIZVRGaU9lck9Ld2ZtQ3F6eHErcEdFYmtRMFdLMlZN?=
 =?utf-8?B?WW4xcGtQN2VHc2FJcGp5VjBSOCsra21Yb1BOMzNEZEt6OUZIc0F2ZzcwOEdt?=
 =?utf-8?B?eVFIQ0JYQ1ZZRHVuU0tDVTczYlFIZ3Nsb3JwaksralhkUjhtVllXWEtHSytn?=
 =?utf-8?B?cEg0WThpdFNvVktlZjF5RXBLb1VHc21OWWY5SXpKT2ZPYXpYaHJGNDFmYXUy?=
 =?utf-8?B?Z3ZjZUlpb3lMN1c0SW5PYjFsWnBTOG5IcmorV3hlTUQrWFhwMUdyTENQTHRF?=
 =?utf-8?B?NVRjSWRERnM1THdlampsc1JFaGFJcUZ5VVJKRThLdGQ0eVhRWE16WldLMER0?=
 =?utf-8?B?NThQL0xCejJYcFl2Y1QyL21ON2hzdks2QnBOb2dhVUIyY3U3d0NBenBFK09V?=
 =?utf-8?B?Z0ZPTFFodEVKN0pnSkVJaEtXS3BQWUFpZU9LbmFQYXkzS1I5YndxWmIyQVdH?=
 =?utf-8?B?TTZGeXpRV0pMdjkxQ1pXU3Z5dGxpeGo3aXRsdTF6WkczTWNzTG1nSHorSmhB?=
 =?utf-8?B?MkpVa0ZHZmVJQlZlUEV2K2Nsa0U1ZE5GQWI3WFZnSHFjVnhMZ0d5aS8vMHN2?=
 =?utf-8?B?NWhGbFR1bndSSG9VRlJnNGFwS3JndW9UMUs3VHBzTHM0QmsyUGtkaHVzQTRH?=
 =?utf-8?B?Z05mTXEvQmI5OGVmditsc1hJL0NabWY5VzZlcTRNSkRvWUdzcnJodXlRd0lU?=
 =?utf-8?B?bi8rTDFUQ0lVVDkwMGo4YnRmSTQ3Y1ZWUWl6RFBMVmU4aWRlWGgzVmwycFZv?=
 =?utf-8?B?Tm5aTExsSy8xMFVsWTVtNWk0c1BIVWNxZzgzaFlhemhmVzhsdzNLaVdORzNR?=
 =?utf-8?B?WkxlQnlrRm9MRS9hSWtOaS90VmpvQVNjWTQ2UGtYSFJYREVaRjYxY3JoQUF4?=
 =?utf-8?B?RGsrKzlKcEFyWWNZdG5SQ2E3b1VzSmkxd0pkTFlzai8wejZueUM3YTFleHVW?=
 =?utf-8?B?eGEvdkprWWJZY3BxdjdiaERSUTduLzBSa2NzZkhOTkVlRStmR3BmeDNmK2dK?=
 =?utf-8?B?d241UE16Yll2cVU2czBBUDJsSG5oc2MwNEp6Snh0UHcrT1lyV3grQmdRUGNn?=
 =?utf-8?B?d085alFnNkl2a0pYNko2SmE4L1VhM1o5TGY5Z0czMitsNEhhSUxaNHNhdUFV?=
 =?utf-8?B?NEtyWXEzckFzMU9QU0tKdWlaM3BRZDBYUGZZSXhkcld6azVGUVdHNFdpT1Zp?=
 =?utf-8?B?bzA0WS9qUVB6OTBmR0ZyTjI2dHBqTEprTFhVcHBFSVhNZHVUVVQ3dU8yNlZy?=
 =?utf-8?B?R1B0ek5WVVBmQnJtbk5XdmREQ2JvZDRMb3BVM1AxV1A5cmF6c0ZtM3NmZDFw?=
 =?utf-8?B?TEpCb2tzYURsTFQ1TUxtdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUhYOTFTNU5JSjVma0NITGs5OFl2dVJHRDhpc01OUjVsZ1VhVUZ4MTNiNVgv?=
 =?utf-8?B?cE83SDcwODJiTUFCUXVvMmhST3RJb3dOWTZjSGh1aEQ3MXdEdGpGZllWcUJr?=
 =?utf-8?B?Q2FlVmJtTHE4Q1hWVTVLaXhPZXo5bkdhMzYzdVIxNUk2VXdXdWFDNmZOSDJ2?=
 =?utf-8?B?NUZFYVhoMnVpRFBXTWU4eGlnWVlOczdaNUF1LzBReXBLV2VHMmRrMi9yMzJE?=
 =?utf-8?B?clpNeHBqMnFwcXMwZTY0VE5pRjdnbkdGS3dKVjFBeDNDdmFyQ280eGNmTlph?=
 =?utf-8?B?NG5LTzJOaE9RQkk5d1VJYmtGZFRaaklRQVdWbk9LKys3aHZEZ0xzVnNPQzZ3?=
 =?utf-8?B?blZUMkp4d0xPbGJCdWxLZHVoNFdDeVVnOXZ2dldQV1habzRCcjZaWHo1aTJ3?=
 =?utf-8?B?WE8zZmdmR2lOWkNjT3BOK2UzYWJxNmNKdkdwVmliY2NkZ0g4TnhNQ0YzY3Bk?=
 =?utf-8?B?ME1pZEc1RC84czJYTnhwR3lKZ3BpY0dHRDduc0NHL3NJdXpxZFFtT1NIb04y?=
 =?utf-8?B?V2I0cUdTclUxcUN0VS92L1N6dkZXbHE0Smx6Sit2cDA2QXpkV0svZTh6VWZj?=
 =?utf-8?B?dVgzRDZaK2xTeGt1LzBrd2RuKzZwazB0TEJVS2dGdUpkK0UzTjJtK0FlOWs2?=
 =?utf-8?B?WWRzQmcyOUxiSm1uTm96Lzl5anArSWJpdUlDaXRJZStyUkVYcUVTQ1VBOVVF?=
 =?utf-8?B?RG9QWFNaclN6ZjlUNDBnd0VkendRNXhkTENxUmt2QzFMc3JlK1JhNHJOemtJ?=
 =?utf-8?B?MjdKRnZYeEtheE9EKzhDYUwrRnB2WWp4UlJhdjN2d3lPTVpVTXlCaTJlNkpH?=
 =?utf-8?B?eEpzaGV4bmJzU1hRQjkxdWU1Y2FIZFVxSm1KbmNJQUtITktxU2tpQlhsTkhI?=
 =?utf-8?B?c216aTNIQlB2Y1U1dnl5ai85bGFtd2lwUWhkZ3d6RG1QNTlUWUtyUW55aDdT?=
 =?utf-8?B?M0gyUStXNUM0V2dqTlljeGQvd1U2bmxvZ3o2SFYzQVdCK2d0dkpIazZlV083?=
 =?utf-8?B?WHNzR1RMeUJ2NGVzblJDZnl3c1kxcjlQRTU3MlVVdmpUV3BzVVBvL2x5QnlM?=
 =?utf-8?B?TS9hWit6QXpLa3lGdFpDdC9zUG5Hb0VnODJnZUQ3ditrSTJ6UXpQNzh4aXA2?=
 =?utf-8?B?RnFPR083cmQyRlhSaXBlbFZzWEJHOElibDd3c2prbmo0czArbXlvZHc3aWIx?=
 =?utf-8?B?WmVINFBDRlN6MjJSNlBYc3hjZ0k3bDFKM0JHbFVhV2ZVR0tFUFQxK1pkTUY5?=
 =?utf-8?B?ZHZ2b3ozbkNSdFVQUkpiSW8rN1hHL0hRRWN4cDI3aWVTSlhkTWlIR1FJMkl1?=
 =?utf-8?B?NlMrQ2NVVGZ3S1hGaEl3N2lRaUJNU2tNK2djM0FyY1V3VytyZ1p0Z0s1QW4x?=
 =?utf-8?B?dmQ3L1JMTkRBMkRTODdIZE8wa3JHRHl4TVZNWUwxRUJLcmtvREtBbjIvK2pI?=
 =?utf-8?B?MG9Lc0x5VVc2SmFPUWZvOVJYdjNOckxsRFV3N2x1MFRWR0lFT2dINXhBQ3Ry?=
 =?utf-8?B?WDIwaEMzZnBpV2x1bjNCYkV6OENtTFBYTm0zSngyVDVaZzhLaXNnZy9wN3RL?=
 =?utf-8?B?NGVQMVhKQ2tiMlNIeGFmM3hHdjVSMHFPYkNIV2F0R1lJaUt0M1BKdld5cFp1?=
 =?utf-8?B?ZlREaXcxWkF2Rll0cWJoSXRYeTZHYXJzYWlKQ3FpM2o1V2Y4OEx6cFR6azcx?=
 =?utf-8?B?V3JoRUpEbkJ3MS85TkdPS1ZQdldia3IvdzZocW92TGNnV2w1REovU2l5VERY?=
 =?utf-8?B?ZlhyMktKVGt2aTh3R3dmSzFSemlNTWZxNWJlUTRwTXVCcHNmT3I3TEw3WS9K?=
 =?utf-8?B?L0VUbnZrODVVN3ZiYnFJcmpFZGw2d3VadFE2YVhJZ0M0YWttOUg5U0N0eEVH?=
 =?utf-8?B?bHFabTVtbTZjWHFiQ0NOQ2FaVk9VSm1hSXBTQk5COEYyeTRvbzZ2czJsSXpZ?=
 =?utf-8?B?L1BwZTBzMUIrbU1KTFhlNndCcTIwQ2xTM3NmcStWbTI0QTdTVGhRUFlybSt3?=
 =?utf-8?B?T1RWeWIxYWxnRTc5eDMzVm1NWC8vU0MvR21IZDlQM2hPMFdvZk9ZQXZLWWRJ?=
 =?utf-8?B?Z3YyUXg1UGxjZVdRNHNvKys0SUlSNUtIVEY5RzNPQytpaTA2WHUzNHdwSGFr?=
 =?utf-8?B?UUx0cGtPWmNiUVZRZWJib3luSnIvVk9jZlNiR25kYmlqUEM3YVNpNjhzbGhp?=
 =?utf-8?B?bHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D287FD3D9D8F414C8F1E24FBD078935B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a32fbc08-92a3-4b69-8ec5-08dc6570ecdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 21:44:46.4235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SVf8RkhQ9WiikB97Mz1BAYz/OttUhJrNEygwdYZWlwqMUtBuQBn4FzNBCgf6Lr6nuPnZHLggekFvf8wfL+rdJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6669
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDA3OjQyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAyNSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNC0wNC0yNCBhdCAxMzowNiAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+ID4gPiBzdGF0aWMgaW5saW5lIHUzMiB2bXhfYmFzaWNfdm1jc19tZW1fdHlwZSh1NjQg
dm14X2Jhc2ljKQ0KPiA+ID4gPiA+IHsNCj4gPiA+ID4gPiAJcmV0dXJuICh2bXhfYmFzaWMgJiBH
RU5NQVNLX1VMTCg1MywgNTApKSA+Pg0KPiA+ID4gPiA+IAkJVk1YX0JBU0lDX01FTV9UWVBFX1NI
SUZUOw0KPiA+ID4gPiA+IH0NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBsb29rcyBub3QgaW50dWl0
aXZlIHRoYW4gb3JpZ2luYWwgcGF0Y2guDQo+ID4gPiA+IA0KPiA+ID4gPiBZZWFoLCBhZ3JlZWQs
IHRoYXQncyB0YWtpbmcgdGhlIHdvcnN0IG9mIGJvdGggd29ybGRzLiAgSSdsbCB1cGRhdGUgcGF0
Y2ggNSB0byBkcm9wDQo+ID4gPiA+IFZNWF9CQVNJQ19NRU1fVFlQRV9TSElGVCB3aGVuIGVmZmVj
dGl2ZWx5ICJtb3ZpbmciIGl0IGludG8gdm14X2Jhc2ljX3ZtY3NfbWVtX3R5cGUoKS4NCj4gPiA+
IA0KPiA+ID4gRHJhdC4gIEZpbmFsbHkgZ2V0dGluZyBiYWNrIHRvIHRoaXMsIGRyb3BwaW5nIFZN
WF9CQVNJQ19NRU1fVFlQRV9TSElGVCBkb2Vzbid0DQo+ID4gPiB3b3JrIGJlY2F1c2UgaXQncyB1
c2VkIGJ5IG5lc3RlZF92bXhfc2V0dXBfYmFzaWMoKSwgYXMgaXMgVk1YX0JBU0lDX1ZNQ1NfU0la
RV9TSElGVCwNCj4gPiA+IHdoaWNoIGlzIHByZXN1bWFibHkgd2h5IHBhc3QgbWUga2VwdCB0aGVt
IGFyb3VuZC4NCj4gPiA+IA0KPiA+ID4gSSdtIGxlYW5pbmcgdG93YXJkcyBrZWVwaW5nIHRoaW5n
cyBhcyBwcm9wb3NlZCBpbiB0aGlzIHNlcmllcy4gIEkgZG9uJ3Qgc2VlIHVzDQo+ID4gPiBnYWlu
aW5nIGEgdGhpcmQgY29weSwgb3IgZXZlbiBhIHRoaXJkIHVzZXIsIGkuZS4gSSBkb24ndCB0aGlu
ayB3ZSBhcmUgY3JlYXRpbmcgYQ0KPiA+ID4gZnV0dXJlIHByb2JsZW0gYnkgb3BlbiBjb2Rpbmcg
dGhlIHNoaWZ0IGluIHZteF9iYXNpY192bWNzX21lbV90eXBlKCkuICBBbmQgSU1PDQo+ID4gPiBj
b2RlIGxpa2UgdGhpcw0KPiA+ID4gDQo+ID4gPiAJcmV0dXJuICh2bXhfYmFzaWMgJiBWTVhfQkFT
SUNfTUVNX1RZUEVfTUFTSykgPj4NCj4gPiA+IAkgICAgICAgVk1YX0JBU0lDX01FTV9UWVBFX1NI
SUZUOw0KPiA+ID4gDQo+ID4gPiBpcyBhbiB1bm5lY2Vzc2FyeSBvYmZ1c2NhdGlvbiB3aGVuIHRo
ZXJlIGlzIGxpdGVyYWxseSBvbmUgdXNlciAodGhlIGFjY2Vzc29yKS4NCj4gPiA+IA0KPiA+ID4g
QW5vdGhlciBpZGVhIHdvdWxkIGJlIHRvIGRlbGV0ZSBWTVhfQkFTSUNfTUVNX1RZUEVfU0hJRlQg
YW5kIFZNWF9CQVNJQ19WTUNTX1NJWkVfU0hJRlQsDQo+ID4gPiBhbmQgZWl0aGVyIG9wZW4gY29k
ZSB0aGUgdmFsdWVzIG9yIHVzZSBsb2NhbCBjb25zdCB2YXJpYWJsZXMsIGJ1dCB0aGF0IGFsc28g
c2VlbXMNCj4gPiA+IGxpa2UgYSBuZXQgbmVnYXRpdmUsIGUuZy4gc3BsaXRzIHRoZSBlZmZlY3Rp
dmUgZGVmaW5pdGlvbnMgb3ZlciB0b28gbWFueSBsb2NhdGlvbnMuDQo+ID4gDQo+ID4gQWx0ZXJu
YXRpdmVseSwgd2UgY2FuIGFkZCBtYWNyb3MgbGlrZSBiZWxvdyB0byA8YXNtL3ZteC5oPiBjbG9z
ZSB0bw0KPiA+IHZteF9iYXNpY192bWNzX3NpemUoKSBldGMsIHNvIGl0J3Mgc3RyYWlnaHRmb3J3
YXJkIHRvIHNlZS4NCj4gPiANCj4gPiArI2RlZmluZSBWTVhfQlNBSUNfVk1DUzEyX1NJWkUJKCh1
NjQpVk1DUzEyX1NJWkUgPDwgMzIpDQo+ID4gKyNkZWZpbmUgVk1YX0JBU0lDX01FTV9UWVBFX1dC
CShNRU1fVFlQRV9XQiA8PCA1MCkNCj4gDQo+IEhtbSwgaXQncyBhIGJpdCBoYXJkIHRvIHNlZSBp
dCdzIHNwZWNpZmljYWxseSBWTUNTMTIgc2l6ZSwgYW5kIGdpdmVuIHRoYXQgcHJpb3INCj4gdG8g
dGhpcyBzZXJpZXMsIFZNWF9CQVNJQ19NRU1fVFlQRV9XQiA9IDYsIEknbSBoZXNpdGFudCB0byBy
ZS1pbnRyb2R1Y2UvcmVkZWZpbmUNCj4gdGhhdCBtYWNybyB3aXRoIGEgZGlmZmVyZW50IHZhbHVl
Lg0KPiANCj4gV2hhdCBpZiB3ZSBhZGQgYSBoZWxwZXIgaW4gdm14LmggdG8gZW5jb2RlIHRoZSBW
TUNTIGluZm8/ICBUaGVuIHRoZSAjZGVmaW5lcyBmb3INCj4gdGhlIHNoaWZ0cyBjYW4gZ28gYXdh
eSBiZWNhdXNlIHRoZSBvcGVuIGNvZGVkIHNoaWZ0cyBhcmUgY29sb2NhdGVkIGFuZCBtb3JlDQo+
IG9idmlvdXNseSByZWxhdGVkLiAgRS5nLg0KPiANCj4gICBzdGF0aWMgaW5saW5lIHU2NCB2bXhf
YmFzaWNfZW5jb2RlX3ZtY3NfaW5mbyh1MzIgcmV2aXNpb24sIHUxNiBzaXplLCB1OCBtZW10eXBl
KQ0KPiAgIHsNCj4gCXJldHVybiByZXZpc2lvbiB8ICgodTY0KXNpemUgPDwgMzIpIHwgKCh1NjQp
bWVtdHlwZSA8PCA1MCk7DQo+ICAgfQ0KPiANCj4gDQo+IGFuZA0KPiANCj4gICBzdGF0aWMgdm9p
ZCBuZXN0ZWRfdm14X3NldHVwX2Jhc2ljKHN0cnVjdCBuZXN0ZWRfdm14X21zcnMgKm1zcnMpDQo+
ICAgew0KPiAJLyoNCj4gCSAqIFRoaXMgTVNSIHJlcG9ydHMgc29tZSBpbmZvcm1hdGlvbiBhYm91
dCBWTVggc3VwcG9ydC4gV2UNCj4gCSAqIHNob3VsZCByZXR1cm4gaW5mb3JtYXRpb24gYWJvdXQg
dGhlIFZNWCB3ZSBlbXVsYXRlIGZvciB0aGUNCj4gCSAqIGd1ZXN0LCBhbmQgdGhlIFZNQ1Mgc3Ry
dWN0dXJlIHdlIGdpdmUgaXQgLSBub3QgYWJvdXQgdGhlDQo+IAkgKiBWTVggc3VwcG9ydCBvZiB0
aGUgdW5kZXJseWluZyBoYXJkd2FyZS4NCj4gCSAqLw0KPiAJbXNycy0+YmFzaWMgPSB2bXhfYmFz
aWNfZW5jb2RlX3ZtY3NfaW5mbyhWTUNTMTJfUkVWSVNJT04sIFZNQ1MxMl9TSVpFLA0KPiAJCQkJ
CQkgWDg2X01FTVRZUEVfV0IpOw0KPiANCj4gCW1zcnMtPmJhc2ljIHw9IFZNWF9CQVNJQ19UUlVF
X0NUTFMNCj4gCWlmIChjcHVfaGFzX3ZteF9iYXNpY19pbm91dCgpKQ0KPiAJCW1zcnMtPmJhc2lj
IHw9IFZNWF9CQVNJQ19JTk9VVDsNCj4gICB9DQoNClllYWggdGhpcyBpcyBiZXR0ZXIuICBUaGFu
a3MuDQo=

