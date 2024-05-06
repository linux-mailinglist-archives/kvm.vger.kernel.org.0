Return-Path: <kvm+bounces-16720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F9D8BCCE7
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 13:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F0D6283504
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A72143861;
	Mon,  6 May 2024 11:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="axlliXHk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3B41420C6;
	Mon,  6 May 2024 11:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714995318; cv=fail; b=XK+/WyeIVn9oU2OzyoGClDJYN/dUEdbYgZxU6AqsuRwpDJLHqjYamWCKpplkofTxiKXDT5t2YufEeZR0dn2e71k/eS0hqkDbSQe02dnvfmMPg52HAjLZtvfpfAMMnZ9LL0nFZV0lNtpoMg5uxtuVgXuc8tgclmGCi+y20z72jpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714995318; c=relaxed/simple;
	bh=DvCtR4DWxsamFPfDN0HR3DSux7HwzxWTAvfEVl/Y0pw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CVJN/bmaujE0wGyowQW0rCwc6gDTUzV1TEZDh37KuRebl8VYADocGiJjAabGlbu+xgUHC5ji+SMqAicF7uepgZ2wi18Gp0HDL49p3+dZTnQSRmQn9ELGw6KbECc/ydSxqVQnz0ZZCVGKdCDZFcOp8dWREHnToB2bx+9LfLvTaNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=axlliXHk; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714995316; x=1746531316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DvCtR4DWxsamFPfDN0HR3DSux7HwzxWTAvfEVl/Y0pw=;
  b=axlliXHkZhskDM0llYSpV5QiX7ohoazXF9BjQ82Os1E/L2pmpaQCYX1y
   BVSqcSreZGvyGY8KaSd0HEmpEwi7BcbAAKFvIp+zRQOiJ0KpyFzbBbyoK
   Vqofbgcoch0Gy7hSjlOZWBkpVhPX1kDGIlbgSvgZFG8qF4gC7obQSvTlr
   Ra3gnCBGZliV3uPaTeI3JP2OyXrGVCeShx2Ms6D22ZxOlTfsJbj17Biw6
   jfn/AMa/SrJlL83ZUUBskNMhlWmrz1u9Mjhe+5JMqb7rBBE/cXNLxX6U0
   Qf0lQYROY1d93yYAZZxFQqqSB+5pYWQUIvgbw0+SwxVNbzCWcRrgfekXo
   Q==;
X-CSE-ConnectionGUID: 1NAIXtuNRGacYyayUQ/mjw==
X-CSE-MsgGUID: aai3rq0jR82N1a//NOtShg==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="33243817"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="33243817"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 04:35:13 -0700
X-CSE-ConnectionGUID: zPsLUwpSQqyizcQX6W0kIg==
X-CSE-MsgGUID: Bp9M+0htRz+6xhOo73JiKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="65589540"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 04:35:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 04:35:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 04:35:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 04:35:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 04:35:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQGbzISwhWY4X6fZcFiFJ0C5ARd0hGFwNGrSh6/iV2+n5EvhLgLGakRnpryufMbrm0SJbxBpeEq8VzqYXRqc9toQxd7VzgMiC+R3WFp1D5edfkTF4iezvAWYazlZqJ55bR20AlVs5Ul5d54aGe+3dfQYMgte1nTL7idu7NVCuCUfy/WDAs08Fw6dPlPYeZIPMBETqgh22kEM/GEHCKwlgkZoCH73FRZACPmyx/cCSFEpL9wFD1mgU41h2Kk2DjaN6v9QqKeqWVNFF5q++OJ7tihJMPLW8CEljPgiCG0HQfd+N2lpxP8bpqybtfdpOR1ueyQCc7//ysvJDfUXYQpBuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvCtR4DWxsamFPfDN0HR3DSux7HwzxWTAvfEVl/Y0pw=;
 b=Y1MxWCZNfvCxA1wTXZq1GbnLg7NJJ6HUmP044jV2u2ZWScf4wNRQu2HjtZq/HyuFmSoZNv3woX2s6Pe465Xd2xmKFZLBQcIT8UpBt/AdN5iIkXcQUoQxqKseCoJoZODbdw8yYolOsjn9bWVHxivAWMzfk8QvSiYi//byU4cNg5oWdmIVl9r8CS9tl4hLdeI14C1Vu6jY/33QrXoAe8olPz53RcphcIccvwrd6igo8SCPs0rvtuYLJ7VaM4FpoZcgKBi3Ns6+6wx+Qxbc0WBaHuQnGGZXzqeDkV8bnbAVPtGKoQ4Ld8L9zYnxb1OJZo+1MEtqMx87lnCqnBUkzKDR8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4822.namprd11.prod.outlook.com (2603:10b6:510:39::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Mon, 6 May
 2024 11:35:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 11:35:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Thread-Topic: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Thread-Index: AQHaa8Opiw/p6jPiUkazZesVJV9oz7GFCB6AgAAgbwCAARAkAIAEQqwA
Date: Mon, 6 May 2024 11:35:10 +0000
Message-ID: <eacb326a450be89fa49fb90bdfea1f2ed415685a.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
	 <affad906c557f251ab189770f5a45cd2087aca19.camel@intel.com>
	 <330c909a-4b96-4960-9cad-fd10e86c67b8@intel.com>
	 <6e839de0e66ac2a9a8af7fd78757b2ed1bffbca4.camel@intel.com>
In-Reply-To: <6e839de0e66ac2a9a8af7fd78757b2ed1bffbca4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4822:EE_
x-ms-office365-filtering-correlation-id: d50fdae3-69e3-44b7-e90d-08dc6dc096bb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NDA3bXQxS3AvYnZoeWJIT3NXSnA1UlRZd21uekVodzdBZTZBTkpHSGs1b0lP?=
 =?utf-8?B?ZjcwL001L3llbjJ0WnRDaUtUQmtUYTBWdm85eU4rT1l1Rk9WanM0T1Z6QjFX?=
 =?utf-8?B?d2JEU3d4YmQzNzViQWNNM21GTUZBQkRQZ3VEMjk0M21SRjEyUmhVWDk2S2Q0?=
 =?utf-8?B?SldLQmE1ZXlheHBtMUkwSW5iS1FwbVhCTGJiQnhlSGRRNmp1NmQ5WVpETGFS?=
 =?utf-8?B?WjVSdmx2TTlKSTRnaDNNNmZqbTBxSlZMdmRUUHBhMThWRDFadXdLV2dIY0Z2?=
 =?utf-8?B?bC9oOEQ1aU1VWm1zVlFnOVFKTEs3L3RXVFhlVVhycWZ3Q29MRXAwT2tsbkto?=
 =?utf-8?B?LzNxZUo2a2JLNyt4RDFqMHF2S3RkVkFKNm1vbmJVTGVOcmxVZS9zcTJSVUp0?=
 =?utf-8?B?OWs4Ui9abzNMME95U205NjFYNnNvQnNmcENjYkIrcmRtUzg1RnJ5ZWNlb0Js?=
 =?utf-8?B?ZSswNWpYUzVvcFRVbkRsbVBzRmRyckVCa2xWMEZVMHBUeFE0Uk45T1hIYm9M?=
 =?utf-8?B?M2lPVnBnakRNdXlCVkNXNkVPVCtmU3FPY3ViQzJrVVVQRllCNzFvcW95aVRO?=
 =?utf-8?B?UXh5VWJOcE9vVXJSSWRGc2VtdWxDeUFWTHhscTFrOEhVTEg0aHhyajhQQ3B4?=
 =?utf-8?B?dk8xenlORXgwWExaTHJTaHM3RlpoUGRnZ21pZmJkM0dtaERlRTJRcmI0YkJs?=
 =?utf-8?B?T3lncGNoWGRId0JtclUrM0VyTnJSRWtnd3VXbFpodndWdkhJaUIvT0ZoQU92?=
 =?utf-8?B?TjZjWklaTFByZzdMZENZSlNEN1VoS3A1VHJkcVN5cXpqV0xkYmRrZERNR3lC?=
 =?utf-8?B?VTh5b2RETk01RWpnOVM2OS9OUFlRYUczdnhoUXYyUzBOdHpOWUJzdEFDVmxt?=
 =?utf-8?B?SmxKS25Pd0VDb0FFNTZDb3AvVUVwRS9SOFJOOUs5QmVlZldKVmo4UVUwQkp0?=
 =?utf-8?B?U245WFhiMlN3azBJcWNvR28vNWxhWXdaZmhOMXo4VWRpcGttdFdhdmhhT0w3?=
 =?utf-8?B?MUlWWVBQVnI3Ui9FbHRDQm1FZUZqSjNmTFNob2hmVVpmcDNYRTJqUFZVa01F?=
 =?utf-8?B?ZkF2QUF2NFJaRmZLVkxVU2FsUTJHaFo5S3IybDVqL1NHQnRqMEJZdUpGaHdv?=
 =?utf-8?B?NHE3ZHFXNmJWR0doRW5zUkVFTis2ZGlIbTcyZzdWblVUaTlhN0NUaFdJYlk4?=
 =?utf-8?B?UjlGUUZFUWdpZDhHOE5yWUFqQWZ3REZBN1d4WFBndGVrTVU3ZGJNcHRJVzlF?=
 =?utf-8?B?R25qUjVnc1F1bUFXTHd3Rlc1d1R5bXJ4SU1mdTBuaXNzaWZmNGpmaitsUW5P?=
 =?utf-8?B?VmFSUXpqYzNGTkpRMldiMFFKdG5ibFVVcGlyZ3hJK3J6UGVWdml5eUtkYWx3?=
 =?utf-8?B?RXRIR0s0YUk4Z2dlVnZ6YkExT040ekgvVTExYURSRVhWZ1NYWFlnOEdoN1N0?=
 =?utf-8?B?V3lFeFFPNUNzUjRHRWdwSVU5NFJhemRGVktyc2grRVRkQ2ZvcjBSNXJpVTVF?=
 =?utf-8?B?d3YwTGJOc0c1bGJhY1dTVUhNL1IyUFgvcUVWRmpyaFFzQ0dkT3dZb1BZdkJ3?=
 =?utf-8?B?Zkl4Rk1ITHNtbVFCNGZpQ3Q5WWJJMmlpRjlRSXNEdk52cUNDejVSUi85emYy?=
 =?utf-8?B?dVQ1WjI3Qk9RWUhpTTA0a2djL2FybHRld2pXTDg1TldiZ0tuR2YxMjZpTmRC?=
 =?utf-8?B?ZHhPWk1BekVHVkgydGd2Uk9yOUV2UFFCNDhaKy95bFJKUEErTU5hQkhmMHcx?=
 =?utf-8?B?MU1jSHZrdklnczBXV3UxMFFsb2FRa1c0a3NTVG1YbXJBNjR5VmkybzQvVVI3?=
 =?utf-8?B?RnlHSUljNWp1cmdjRHRDUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTdRUHJzUjkxenRhOU9CVEkyR3YwSG01WGdCUlMzazlNWHRDdHg2aE1ucmJ2?=
 =?utf-8?B?Vi9GN01WOTErRk5FTHVlbkFUV3d4d1U5cG11bldsd2NaVUdmU2pyVVQ4VE9q?=
 =?utf-8?B?dWJqS2ZQY2tnVktQbENTZ1ZqeVc4eVhCVWE1QTYyV1hLS2JsZmZIWlI3RHhZ?=
 =?utf-8?B?VDhlZE5PY1ZMUU43TGd1QTF6Y0prQVFjMWhvTEVhZlNoSWdTcGQ1VUNLdXlF?=
 =?utf-8?B?eHVJQjFXeWU4dDIrV09DTmhkcEI1UUZFL3VFRUpDMG1QQVMzbTRaZHZ0c2hC?=
 =?utf-8?B?elBhRkwwRlh4Qy81WFJMNmlIY3c2NVpUU1ZRazcvdkNralQzU0lLSllwRXlD?=
 =?utf-8?B?bngwSTZ1ZkNvL2UzdXRNWWJ0S3lrc043MXpVRW9NSVVWaFFMOC9nSWQ1b3VI?=
 =?utf-8?B?ejVVSDFtUFYwUlV1UWF1Um85d0dzck1jV0w0T1pUcE1wQ1UrRW1MY0NLYWJ4?=
 =?utf-8?B?MS9mRHFINnRpRVovWXhvQTIzaG4zaVF6NHl3UmIzZjcrcnhnaFliZXhoT09B?=
 =?utf-8?B?Z1pWWVFsNnJrbUU5c1JPNGhmcTd1c0JUcm4rYm84ekZxandrWkZZOTNQNjhw?=
 =?utf-8?B?YkFrUnBnVkJSc0thWklWcHRrUktMaTQrdEg0bDdPcUJzb0FTazFFTnBpMHlR?=
 =?utf-8?B?eG9ZVzIxMEFoS0UzcmVkZ3kwd3VKT2xlYTBKTlo1ajlSbnhnWWlQUzZ0QVVu?=
 =?utf-8?B?YzZaYm8xZldwdjRING0zazNSQWRwRHNRODg2YWlaWW41SlhscGNxNmsvMVdo?=
 =?utf-8?B?QVJaekV2WWpHSDAxbDFuT3V5a01NQkZiajRhYXdmREtPL1FxbUtoS29CeDB0?=
 =?utf-8?B?UHBMUnA2Wk5pd2ZRUzF6Tkc1anNnWmNyM0VWbFdMbmtrYVA5dmlWVGlTZVJ6?=
 =?utf-8?B?UHBjR0kzMU9ybFdVV2hXanduWEsyclp2bUlBMzZGdmQ1RXRldnREMTlqcmFU?=
 =?utf-8?B?L3Nkb1R0SGxWay8xdWZFVXlCeDhKdER4eW9JbDNrYXgvamMwQTRaT3dERERk?=
 =?utf-8?B?NENoMERFbUI1Y21SZGlYVDE5UjF3eTlDcXlHR1hieVRLeXBkL2RHQ0Rmcmcx?=
 =?utf-8?B?UXBtMjc3dFRsNVg4M3NVODhFRTdXa3NLYTNqeWJRSURKaHdsR0JQU2hJc0d5?=
 =?utf-8?B?NkF3WFczRGJ6aDZmbWg4MlEzaDFPZTZNamI5RDNvZTdibmhxay9hRFEvaExq?=
 =?utf-8?B?dCsxR04yNjlzZnFaa2tHdkV3SXUva3diRGlwVTBXcHVJeThYVndTdWE2NTVV?=
 =?utf-8?B?NzFHbFhMZ01IODZGZmF5M0FsMnVqeVBMN3BraGFvZnZaMWhhTmx6aDRsMmlm?=
 =?utf-8?B?TXV1R3c3OERiQU5GOVFOVjdIcFJ0aDVWQUF1R2dBOFJWYThaSnFhMStPWmRs?=
 =?utf-8?B?TUkzYWhBYmx6Z3ZYd3VOZ21kMkE0SHZiZEUyc01Nc1d1NVNDYk1LMnFjU3Q4?=
 =?utf-8?B?ZnVQYXN4WGZKMjFQQUEyVVB4M0I0Y1VTWHozYXcyT1dZcUJvdGVoU3VRWXZO?=
 =?utf-8?B?cEcrdkhxQzJQalQ3QXB5bVdNUUV6RUhya0cxNmdkaGoyTzRtQUc1NWpsOVBZ?=
 =?utf-8?B?WEZLVzdONUlKTSttSUxZZzhBYllXOHBMd2p5aFdBZ3NQMnE5dFN0K01RbjFN?=
 =?utf-8?B?UitmaURxdVU5MkliVTIrRFEvZWRWZ3lPZEVpL0dlaXFiSS9ocTc1SldXSDRZ?=
 =?utf-8?B?QzZVSldMd0VSNlB0K2RJU0pzV0tRRGp3bk53Vjc0SURiOVc3aXg2aEtNdWRE?=
 =?utf-8?B?bE1LdEUzZVdyWGVUSS9Qd2pKbG14RUgySnRQTVVSYzlTVG9wNkxaWGdaQXhr?=
 =?utf-8?B?RytOa1Rld3YxNTJPNU5zY1lqdEIyT2k2NUZiZk9DM0J1ck1URngzN3I4cCs3?=
 =?utf-8?B?RW92d3Z2OFJ5WTdET0FBMjFFWnZGUHh6Ujc0VmgxTmVhNEFwWGtyTllMUEx6?=
 =?utf-8?B?WnUzaFVmS2EzNlpuRXJMLzJDemk4bUNnZTNYb015SnM0YVVHb1FSc3lUTW5X?=
 =?utf-8?B?TVBGd2EyRUxaWTRYNkNHdFNLN0tiRXJNcWNaQU1tVENZQlJGRzl4L21WT0s2?=
 =?utf-8?B?bm9jc3VGZDhxb25pQ1EzUFVOZjRqZUJDWVkwRnU2ZTJxdWFKamk1K21KOG9r?=
 =?utf-8?Q?lBLtCUizZ4SNEkrOVhsBUNMUL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A72CF1ABD4AA434B8115B753FB7B4E7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d50fdae3-69e3-44b7-e90d-08dc6dc096bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 11:35:10.9600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G/nevl45umZlPfh0d83FDINnHiPmCnSiszxjO5lZT9Qj0L76H97OEDKYyfxbzliVOF7f55AnHn7iy64IH7uWvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4822
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDE4OjMxICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gRnJpLCAyMDI0LTA1LTAzIGF0IDE0OjE3ICsxMjAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IA0KPiA+IA0KPiA+IE9uIDMvMDUvMjAyNCAxMjoyMSBwbSwgRWRnZWNvbWJlLCBSaWNr
IFAgd3JvdGU6DQo+ID4gPiBPbiBTYXQsIDIwMjQtMDMtMDIgYXQgMDA6MjAgKzEzMDAsIEthaSBI
dWFuZyB3cm90ZToNCj4gPiA+ID4gS1ZNIHdpbGwgbmVlZCB0byByZWFkIGEgYnVuY2ggb2Ygbm9u
LVRETVIgcmVsYXRlZCBtZXRhZGF0YSB0byBjcmVhdGUgYW5kDQo+ID4gPiA+IHJ1biBURFggZ3Vl
c3RzLsKgIEV4cG9ydCB0aGUgbWV0YWRhdGEgcmVhZCBpbmZyYXN0cnVjdHVyZSBmb3IgS1ZNIHRv
IHVzZS4NCj4gPiA+ID4gDQo+ID4gPiA+IFNwZWNpZmljYWxseSwgZXhwb3J0IHR3byBoZWxwZXJz
Og0KPiA+ID4gPiANCj4gPiA+ID4gMSkgVGhlIGhlbHBlciB3aGljaCByZWFkcyBtdWx0aXBsZSBt
ZXRhZGF0YSBmaWVsZHMgdG8gYSBidWZmZXIgb2YgYQ0KPiA+ID4gPiDCoCDCoMKgIHN0cnVjdHVy
ZSBiYXNlZCBvbiB0aGUgImZpZWxkIElEIC0+IHN0cnVjdHVyZSBtZW1iZXIiIG1hcHBpbmcgdGFi
bGUuDQo+ID4gPiA+IA0KPiA+ID4gPiAyKSBUaGUgbG93IGxldmVsIGhlbHBlciB3aGljaCBqdXN0
IHJlYWRzIGEgZ2l2ZW4gZmllbGQgSUQuDQo+ID4gPiA+IA0KPiA+ID4gQ291bGQgMiBiZSBhIHN0
YXRpYyBpbmxpbmUgaW4gYSBoZWxwZXIsIGFuZCB0aGVuIG9ubHkgaGF2ZSBvbmUgZXhwb3J0Pw0K
PiA+IA0KPiA+IEkgYXNzdW1lIHlvdSB3ZXJlIHRoaW5raW5nIGFib3V0IG1ha2luZyAyKSBjYWxs
IHRoZSAxKSwgc28gd2UgZG9uJ3QgbmVlZCANCj4gPiB0byBleHBvcnQgMikuDQo+ID4gDQo+ID4g
VGhpcyBpcyBub3QgZmVhc2libGUgZHVlIHRvOg0KPiA+IA0KPiA+IGEpLiAxKSBtdXN0ICdzdHJ1
Y3QgdGR4X21ldGFkYXRhX2ZpZWxkX21hcHBpbmcnIHRhYmxlIGFzIGlucHV0LCBhbmQgZm9yIA0K
PiA+IHRoYXQgd2UgbmVlZCB0byB1ZXMgdGhlIFREWF9TWVNJTkZPX01BUCgpIG1hY3JvIHRvIGRl
ZmluZSBhIHN0cnVjdHVyZSANCj4gPiBmb3IganVzdCBvbmUgJ3U2NCcgYW5kIGRlZmluZSBhICdz
dHJ1Y3QgdGR4X21ldGFkYXRhX2ZpZWxkX21hcHBpbmcnIA0KPiA+IHRhYmxlIHdoaWNoIG9ubHkg
aGFzIG9uZSBlbGVtZW50IGZvciB0aGF0Lg0KPiA+IA0KPiA+IGIpLiBURFhfU1lTSU5GT19NQVAo
KSBtYWNybyBhY3R1YWxseSBkb2Vzbid0IHN1cHBvcnQgdGFraW5nIGEgbWV0YWRhdGEgDQo+ID4g
ZmllbGQgInZhcmlhYmxlIiwgYnV0IGNhbiBvbmx5IHN1cHBvcnQgdXNpbmcgdGhlIG5hbWUgb2Yg
dGhlIG1ldGFkYXRhIGZpZWxkLg0KPiA+IA0KPiA+IEhvd2V2ZXIgd2UgY2FuIHRyeSB0byBtYWtl
IDEpIGFzIGEgd3JhcHBlciBvZiAyKS7CoCBCdXQgdGhpcyB3b3VsZCANCj4gPiByZXF1aXJlIHNv
bWUgY2hhbmdlIHRvIHRoZSBwYXRjaCA0Lg0KPiA+IA0KPiA+IEknbGwgcmVwbHkgc2VwYXJhdGVs
eSB0byBwYXRjaCA0IGFuZCB5b3UgY2FuIHRha2UgYSBsb29rIHdoZXRoZXIgdGhhdCBpcyANCj4g
PiBiZXR0ZXIuDQo+IA0KPiBIYXZpbmcgb25lIGV4cG9ydCB3b3VsZCBiZSBuaWNlLiBZZWEsIHNp
bmNlIHRoZSBtdWx0aXBsZSBmaWVsZCBwcm9jZXNzaW5nDQo+IHZlcnNpb24ganVzdCBsb29wcyBh
bnl3YXksIGRvaW5nIGl0IGxpa2UgeW91IHByb3Bvc2Ugc2VlbXMgcmVhc29uYWJsZS4NCg0KU3Vy
ZSBJJ2xsIHN3aXRjaCB0byB1c2UgdGhlIG5ldyBjb2RlIGFzIHJlcGxpZWQgaW4gcGF0Y2ggNC4N
Cg==

