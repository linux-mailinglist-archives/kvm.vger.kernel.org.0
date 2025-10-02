Return-Path: <kvm+bounces-59395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3110BB2C6C
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35E1B19C3EDA
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A192D24B6;
	Thu,  2 Oct 2025 08:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZKHs70PU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE0516132F;
	Thu,  2 Oct 2025 08:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759392631; cv=fail; b=FXTMDYlmbqS1IXuWuBWStq4gY33mUEIHcDbyB09R6qQ8JT4TmSgY3DcW9w0GuJXM39AdcS6DH0uSOSxDhHZ421AdIci0PI1bQcK/CmKgCGEdlddGiotgUZ+M8aGQyPrXdDpozUIyJBYWMdefDnTiR1RbBaml3fsi7PYHc9auQHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759392631; c=relaxed/simple;
	bh=3nRV6J3+nJ3svolNL0ZS5JDc8TZp46cAXXCCbkGTJ0U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hFVfSPOz6opqi5CxCsJUPff0vbyU/WDu3SB+tkJ0dT1fdgeqQrf3yDNXY8wgTxds5S7jw6x4YXjd6N6Pn9q0GLv7G3do4GG8BnMSByWUCfKvRm9zkPSWXMdvXZRpd7L8h9KbwbXrr2aLfP7lD1dtqCCDKXHwN5pLLm4B+MS2fa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZKHs70PU; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759392630; x=1790928630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3nRV6J3+nJ3svolNL0ZS5JDc8TZp46cAXXCCbkGTJ0U=;
  b=ZKHs70PUA6RjplrEp5RmwEYnbQpopDn67SbvgGNne6o1+e5goNSloO8A
   zV8XdZm0P1BgOxO8+/loXEtZqxuWt6WQzZAfgSyOyzQ2gUIDnWnjh9rn5
   eYS/gVlJ5tGrZRNDC5Ib/xLfhcAtATRRkubjGwvEvpftkM5OI+AL12C4V
   DVlGN8tgu4DM4z859MmMOu+UxHjLCDBWG6l6rMDDCL3gl8kq/EAx/4oFV
   VcWlacO6dibnFuAtFKEnIMQ/zpd5wEsd7id3johCEw86TamZv6mszvI+4
   0PqdDKnJxKl5HqabcMkezXBnKQlu5QViUjw1ckZ7Y/lsIhRvQIwB52qtv
   w==;
X-CSE-ConnectionGUID: 9X/HGAO+SY2j95a3xhDfFw==
X-CSE-MsgGUID: kBekhYzXSPOQOhUCnVev3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="65525559"
X-IronPort-AV: E=Sophos;i="6.18,309,1751266800"; 
   d="scan'208";a="65525559"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 01:10:29 -0700
X-CSE-ConnectionGUID: qjolc7lrTgyEPR5U2v/GVA==
X-CSE-MsgGUID: MCJJDL9aQviNgiDX4R1NWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,309,1751266800"; 
   d="scan'208";a="209938942"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 01:10:29 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 2 Oct 2025 01:10:27 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 2 Oct 2025 01:10:27 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.9) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 2 Oct 2025 01:10:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qg4ZYaBToD5+VNAb5LcvQ99lZUG9Cauf3KC0CX4IplSuTHEv5x553ii6CogUTvx4+c9xzpQ9plfqGt62ecWuvMUaQTCZgfM7fTZhkLq8ZBc1rmatFAySi9OhdMcV9AInBkai8yr9OKn0fWqbhCYgRetX92yZJ4zibEGQD1pQ40CrcTVbqnZ54i2S/4avKGnXQaPYRDD4EiRYu8l/mKAtQEcnPI4xwaroNDdmkPPAFxhbUtN1jG/ab4mGGkfTpX/6P8wYUZ8cT+M2tfUvO6Wb9Px/OmQF+S6ALrA+jCIpwfA9tXHWgBjI9vsC8iHQXhK6R54owdp989UGxX4DVnBNhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nRV6J3+nJ3svolNL0ZS5JDc8TZp46cAXXCCbkGTJ0U=;
 b=L8NsCAsKRsOLxPLZ4PzDWHB950j1R+Ng6rylo2BOZbwlDKby9ei6KLcNhXqPr9YARKnSiQFHdZhWhzNG4fX/ilYmaBuA+uWBv3jIKXxnLGb1SjeHjCNUDsh7bnM0SfbNC6fQj+GaLkdIkyJXFKwq6zUQU5RAi91M5d63lRYOEt3GowhTvg/wfHbmJhp3Hi+8uEPs53/PYis6B9d/5KgSZWvlKxmI37KMadR4itXVtj/3Xy4yT0CGtnAZwkyRNJv65S3BROCfiNOPG1R59qYAkrPV9JaUizb+/N3Evucxahe6TqGAoaeEiw+jqVLE8iqzusiJOfQb87geagNFnAa68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5750.namprd11.prod.outlook.com (2603:10b6:8:11::17) by
 CO1PR11MB5140.namprd11.prod.outlook.com (2603:10b6:303:9e::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Thu, 2 Oct 2025 08:10:19 +0000
Received: from DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a]) by DM8PR11MB5750.namprd11.prod.outlook.com
 ([fe80::4df9:c236:8b64:403a%4]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 08:10:19 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Juergen Gross <jgross@suse.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Hansen, Dave" <dave.hansen@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "x86@kernel.org"
	<x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Gao, Chao" <chao.gao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
Subject: RE: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Topic: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Index: AQHcG1sHR09kpBppk0GYfhNVrRmfiLSrHywAgAFNloCAAExKAIAA0KKAgAAuMwCAAOKHcIAAEFMAgAAFd8A=
Date: Thu, 2 Oct 2025 08:10:19 +0000
Message-ID: <DM8PR11MB5750C89171E7DD732C6B4BBEE7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
 <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
 <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
 <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
 <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <27d19ea5-d078-405b-a963-91d19b4229c8@suse.com>
In-Reply-To: <27d19ea5-d078-405b-a963-91d19b4229c8@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|CO1PR11MB5140:EE_
x-ms-office365-filtering-correlation-id: 0d3038ca-5dd6-4980-f26a-08de018b20a5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SGdvOVRGU21BZGErTzlrOEVWbTR2YVpCeDNPWEJlNUp3UEZoRHZhUW9VbHJC?=
 =?utf-8?B?bGphd1R2VmN5c0RScFUxeWZROFhPcXg3VlNvYWM1MEVKUFY0WEE3NnJpa01B?=
 =?utf-8?B?WWEwL1BDWENQbmFsU3pqSnYydFdlcDFRNXB1aHV0eWc0ai9haWpSWHRwMzJn?=
 =?utf-8?B?UTZiMURvR2RtbXg1WEFKRE5aRi9GUElXbE16cEtlcnZnSVFPbml0MEQ0cFBS?=
 =?utf-8?B?ZG1MdHdVNXRWOXQ2M1U2M25va2NXVERyUGdEY1grdHFmcUQ1Vk9FejBLK3pQ?=
 =?utf-8?B?SW5MNkQyVjV1K1RLV0c5VGx4NXpwWXJ4WEpzd0lFOTkyY3puYXlVdXRsNk81?=
 =?utf-8?B?MlcrWm9pRGtCdWRTSnhaNG43czBVb0Y0M0ZLcmpEbkV0ZmJjOFFmdm9XTUJv?=
 =?utf-8?B?bnRkTXpJSW0weC9leFBuMW8rQWZJK25pVHJHSWdCTDM3aTY2Rk5sRVpQVWYw?=
 =?utf-8?B?MXA3Um5ranh0UTZLRk9OaVl1K0xHTGF0dDJveDBxeFJsWldKMW9wTitsMGxs?=
 =?utf-8?B?TFFxVVFOVlhBY3p2Rkk0MFNMVEtFUlJIRjAxWVdJOGc1eGlCM1J1emFMWEFv?=
 =?utf-8?B?alF2U21RRm1lQWhnUkQrUnZ4ekhPMjRtK1lCS0VWaUYzQ0dXZUN1LytXeWcx?=
 =?utf-8?B?TnJNb0YvK3BQbERySzUwM1dwS1lEeWdCcVdpTnVJSUNrZXQrNlJyOVcyVlo5?=
 =?utf-8?B?NU5XSXB1SysvU043eEY1bVVMMTZ4cWpzR0xKSXcveTNHNG0vM3BDYkJiVS9w?=
 =?utf-8?B?ZU9WclE2Q2N4YnIyTkRPeWthTUd1cFZJemhQY0NyRmVWWFM2WEprUnJyVjI5?=
 =?utf-8?B?Y0RKSFBJRWJTdVducklGRTh4T2Fuc0NjMTQ2VEpETmtUbFZOWlNORjZFRDFL?=
 =?utf-8?B?bGxiWlV6aC80TzM0M0tscDNNQ2cyVTUyRy9RVXpNblowNFJkcnlrVlkxQk9o?=
 =?utf-8?B?ZnlRWGY5SjFNZGg3Z0tLdGppRitPQnlVQ0ZuWmVybkNVMXFTSjZYc0dnUCtk?=
 =?utf-8?B?UU5Rb29adDJxdW9VN3R0UjY1UFo1Y2xJNXlDd1N5MkJnNjJNWGJqTGErbVFo?=
 =?utf-8?B?TGJvQzhGZm44a3ZROStDbmtpMURyQjNwZXhxdFZiaUo2ZXhzT3lCd2htQ2ky?=
 =?utf-8?B?ZGZoSFhNUzJZTnZCZjFJYmlBd0I4L0Z0K0g4RER0WFZReFZQWjNZR2JzZGVp?=
 =?utf-8?B?U3h5T0dkVkFtZjNxOG1MWVBjWUdDb0VoSlRieWxPZFVFNVBtRU11NVhvSGox?=
 =?utf-8?B?ZElWbUZPNnFYTlJLcmdXR2wreS9wdHhLdDhNbWw3cG9RREtZOUFkSGJzY2dQ?=
 =?utf-8?B?TDhhVnBsTkZDK2FoQUIrWmxZT1lTZnMwR20vSHlYbEN6bGh4Q0FqUGJKQ09Z?=
 =?utf-8?B?S1lqM2hscStJVm9DZHcrcDFGa3N0R040eUVuL0lobFMzVzJKZU5TZzQ3YVlh?=
 =?utf-8?B?VkFMTnUwZWRNRGlWNE83WnYxNDBnY3EzMjNISWgrM05QQVpOUTJBd3JXMENQ?=
 =?utf-8?B?SEEyYkJxRFBJdnY3dDNwQzRYR3VVYlp4S2F2TmVGaXQwNVhmL0trTy9uRGJv?=
 =?utf-8?B?clh5SFp5T0RZUXRJMVl1cTI3dTNydkl2QXZkLzFXOWtPT2JuSlJjc1BBc0tM?=
 =?utf-8?B?NWQvRnFPV2hqd1lwN1Nuc25sUFVUaEhVMTdIYVJKZ3JVSnpST01NdHZRMUxM?=
 =?utf-8?B?d0lRdjZra01KVEsrNnFlRXZrNlJXdWdMbmtVbzRtOEl3WldpeCtsZTRIRmRq?=
 =?utf-8?B?dk42Sk5veGR1Nkd3M1NpOXBnaTJzUEFGUnNaUUJBZDV6QUl2My8ydXZDUHdX?=
 =?utf-8?B?UW1nS3h0WjBKdUpINGExajRWR2lZWGtoTG9VRzNOdmtwRGFUdW1JV1FtTHhG?=
 =?utf-8?B?RHFRb3RNODRXbzRGNVNjOFlsaVUrOEYxWmZZY01ROTk0QURDSkl6WkpBaTZm?=
 =?utf-8?B?TEw4MWlVQlkvWE84VDFEMmpVSFFsSzZBSThURmR4dEZXYUpwNkZlbDBURTZI?=
 =?utf-8?B?QmZqeWpLeE1GUVNqbGZ4MXJ4ejU5UXp5UkhOcjV5Y01pcHJpcFdVbDBxOGN4?=
 =?utf-8?Q?hx9OjV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2E2YjlTVWd0cFp2dG5iM0s3dTBoTFZXbGhpRERlbHhHRTJWckNaZ3o5MUpn?=
 =?utf-8?B?NDVqaG1hZVArcnQ4Njg0QVlVaTdhc1pGcXkvbVEzRVpHTFNzWHpIM1A4UWMw?=
 =?utf-8?B?WTJOWEI4ZHBUU1MwNWJHS0R4Zng2alVhU3N3R0F4bTN6NC9uYlJzVnpCL2hh?=
 =?utf-8?B?Ti9WbUJLREs4L3E1UHEyK0lWVkk2RnJxc1liRElZYk95emh2R3ArL25jYld2?=
 =?utf-8?B?cURQaUNvNERMVzdZSkd1MGpDbDZEeFMrRHhnUEVYU1Iybm8xM0hkNlFPVC8v?=
 =?utf-8?B?bW5JbGdrdi9MdHFtVjBDcVRGTGRvWEMvZWhDOFk0TmpkN1FRR0MxeVoveU5Q?=
 =?utf-8?B?UVBhTDVEanNwa0xEOVBXWXJZN3JLQ1J2TEJLZ1d2ek9ZdG8yME5UYXhqbjJn?=
 =?utf-8?B?Yk55eld1em4vRDBRR09KdXpOYlR4TVBmemQwUTZnWDgxdXFEdXRuRWFrd08x?=
 =?utf-8?B?UXlqWHBwdi9teFRxVzMyMkNXQjgxSkZUZ28xSzFYaHZZTEJYQXUwdU0zSWZI?=
 =?utf-8?B?WUxsVjVQZVlmK0MvdjhVYWYzV0xMTUJLZzYwSjhGSUd5cHlJSGhRMnZwbzVz?=
 =?utf-8?B?R0M2OU1QRVdlT3VqcGtKL3M5WjRhRGVGZVZDcFNyR0RpLytOQTNTdWwxOUFh?=
 =?utf-8?B?Y1k3eVI4cThtRHRXbFp2aWxjN1g1ZGJQT0R0WVBYWVBRQnk5ekZFMm9MK21o?=
 =?utf-8?B?a3VEM1AyUUwzcHpqWUx4MU1rK09tT0t2amRvN3EzMzNzQmgvSXRtQzFDcFpi?=
 =?utf-8?B?ZDR4a3BoK2wrYlUxNjFRM3g3M3R5UWhpWTVvN3NHNEF3bHFpeEdZb1RNaG02?=
 =?utf-8?B?cnU3SGRtNWxKREVHT2UvQVlnNnIvaGt5R2tTbTY3aC9iaDhBbE9NQ3hmRGt3?=
 =?utf-8?B?RzFxVTMyRnNHL3dRV2p4Z2FHb0FGUkRaZXhCYnltSHlaSmdNYUwvejNMVVZ6?=
 =?utf-8?B?OWg0YndRVHBhN3hEbXl1OHYveUFXLzZXR0plYUMzU1lNbmUzTnFOTkwxL0du?=
 =?utf-8?B?VDZBOWpVazdEQTcxazc5cEcvMXpKcmNLaDFndG5uUVVzQU1nUXNIUW5ja0hQ?=
 =?utf-8?B?WDVYcHFjMWlreWJoSWJNOG5pczRTc0lhUDlTNFc4L1ZlZXZOR0p5OCtJWWVI?=
 =?utf-8?B?VjhrdmM1TUttSUx2WkI5Q3FpdUZYUUllM2Jyc1cwSWV0SnAya3p0TVhPQjZR?=
 =?utf-8?B?ZzVaTTBBdi81cDZIUXlrQzRUYzJGSldVcm1qT1ZXTDFkM0U2SkkyaFMramJt?=
 =?utf-8?B?cTlsU20rNC9PVVh5VmNEVHptZDZvOTBENDRPVE94c0FDcHJsR2lkTXd2WG1B?=
 =?utf-8?B?VXg3VDFZTVhVTjZiaHRpMHExMitqbGJuZ24xeWp5NUQ4MVlXSjlMbU0vcmdL?=
 =?utf-8?B?US9YeEpnU0N3Uk84blNYMzJyOEdvS05vakt2Zk15eVAwWCthVUpHUUdCL1R2?=
 =?utf-8?B?TTA4MTIyR3prdCtFMndmTi82a3BGU0RUUHRXeDRoSVpRNmwrWWUrU0tMVUlo?=
 =?utf-8?B?R21hRUdWQ2VGa2xCT0dibWI3WC9LK21VckVRWDBGRncvczBVWllBcDh0MlBs?=
 =?utf-8?B?UEFrZzkwQndqUFZMZUlSQTdVSkE1QzREcGUyOTJieTRtdWlxcHNjVWtUd0VU?=
 =?utf-8?B?QnB2NnF2NGRPdEk5amJWZk9USmwzdDc0VEsveWh1a2FpRVlwRlZOdGd3bm1j?=
 =?utf-8?B?ckxUcDlJNnUvZ3Q5dFlaOXQrNS8vbTRCdHllT0NmRUJaWFIxY0FnTnpLaUtU?=
 =?utf-8?B?blFwVGYwYmdWcU9wMm1yVXpLYnBKeTBTaURic1M1Sy9lcmxHMnRORjhwWXVU?=
 =?utf-8?B?ZHhyM1J6aU15MkdmMFEybUI2c3p0UlcyK2xiT05ZelhWdUZFcUZmV0tPVXlB?=
 =?utf-8?B?YmJmcDZ0cFZ1NWIyMXE5Tm15NXBEZW9HYXNkT1pUdHlwbHdGSFJhTWkxVEk2?=
 =?utf-8?B?V2syOTRIL2RJZENiUlM1MkxBM0FFeFc4NEQra2lLY1phaE00eDhOTUw5S1Ja?=
 =?utf-8?B?M014R1FMNXMzREhERHZuOUg0ODFuNVFnbWJUczlRS0M2cmJZMlhsRStOOW94?=
 =?utf-8?B?Mjk1ZFNPbUdma0g0ZVRTZ0dZNExIVDJlWWx3bFRSSkFFMVpYNVBoampMNUEw?=
 =?utf-8?B?cWd5SHZnNzRwR1ZtOVpEYWpETmxRN2xQU1RnMFFtM3ZkWElPNzF6VS9yUWxj?=
 =?utf-8?Q?peVdR1UcOPCsnB56r107hLuJ6oNzIQjTPvaHzQCzkuI9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3038ca-5dd6-4980-f26a-08de018b20a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2025 08:10:19.3003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ian1bDn5KwwUZZE0/gFxTUj4gwV9uytooO80tmNAadRZ8sJQsaKyMpL3dfyvY4+uJ//DkNRn2EmyDn+N0m7rOJlfAgHQsXnnT+p4UOqoJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5140
X-OriginatorOrg: intel.com

PiBPbiAwMi4xMC4yNSAwODo1OSwgUmVzaGV0b3ZhLCBFbGVuYSB3cm90ZToNCj4gPj4gT24gV2Vk
LCBPY3QgMSwgMjAyNSBhdCA3OjMy4oCvQU0gRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVs
LmNvbT4NCj4gPj4gd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gT24gOS8zMC8yNSAxOTowNSwgVmlzaGFs
IEFubmFwdXJ2ZSB3cm90ZToNCj4gPj4+IC4uLg0KPiA+Pj4+PiBBbnkgd29ya2Fyb3VuZHMgYXJl
IGdvaW5nIHRvIGJlIHNsb3cgYW5kIHByb2JhYmx5IGltcGVyZmVjdC4gVGhhdCdzDQo+IG5vdA0K
PiA+Pj4+DQo+ID4+Pj4gRG8gd2UgcmVhbGx5IG5lZWQgdG8gZGVwbG95IHdvcmthcm91bmRzIHRo
YXQgYXJlIGNvbXBsZXggYW5kIHNsb3cgdG8NCj4gPj4+PiBnZXQga2R1bXAgd29ya2luZyBmb3Ig
dGhlIG1ham9yaXR5IG9mIHRoZSBzY2VuYXJpb3M/IElzIHRoZXJlIGFueQ0KPiA+Pj4+IGFuYWx5
c2lzIGRvbmUgZm9yIHRoZSByaXNrIHdpdGggaW1wZXJmZWN0IGFuZCBzaW1wbGVyIHdvcmthcm91
bmRzIHZzDQo+ID4+Pj4gYmVuZWZpdHMgb2Yga2R1bXAgZnVuY3Rpb25hbGl0eT8NCj4gPj4+Pg0K
PiA+Pj4+PiBhIGdyZWF0IG1hdGNoIGZvciBrZHVtcC4gSSdtIHBlcmZlY3RseSBoYXBweSB3YWl0
aW5nIGZvciBmaXhlZCBoYXJkd2FyZQ0KPiA+Pj4+PiBmcm9tIHdoYXQgSSd2ZSBzZWVuLg0KPiA+
Pj4+DQo+ID4+Pj4gSUlVQyBTUFIvRU1SIC0gdHdvIENQVSBnZW5lcmF0aW9ucyBvdXQgdGhlcmUg
YXJlIGltcGFjdGVkIGJ5IHRoaXMNCj4gPj4+PiBlcnJhdHVtIGFuZCBqdXN0IGRpc2FibGluZyBr
ZHVtcCBmdW5jdGlvbmFsaXR5IElNTyBpcyBub3QgdGhlIGJlc3QNCj4gPj4+PiBzb2x1dGlvbiBo
ZXJlLg0KPiA+Pj4NCj4gPj4+IFRoYXQncyBhbiBlbWluZW50bHkgcmVhc29uYWJsZSBwb3NpdGlv
bi4gQnV0IHdlJ3JlIHNwZWFraW5nIGluIGJyb2FkDQo+ID4+PiBnZW5lcmFsaXRpZXMgYW5kIEkn
bSB1bnN1cmUgd2hhdCB5b3UgZG9uJ3QgbGlrZSBhYm91dCB0aGUgc3RhdHVzIHF1byBvcg0KPiA+
Pj4gaG93IHlvdSdkIGxpa2UgdG8gc2VlIHRoaW5ncyBjaGFuZ2UuDQo+ID4+DQo+ID4+IExvb2tz
IGxpa2UgdGhlIGRlY2lzaW9uIHRvIGRpc2FibGUga2R1bXAgd2FzIHRha2VuIGJldHdlZW4gWzFd
IC0+IFsyXS4NCj4gPj4gIlRoZSBrZXJuZWwgY3VycmVudGx5IGRvZXNuJ3QgdHJhY2sgd2hpY2gg
cGFnZSBpcyBURFggcHJpdmF0ZSBtZW1vcnkuDQo+ID4+IEl0J3Mgbm90IHRyaXZpYWwgdG8gcmVz
ZXQgVERYIHByaXZhdGUgbWVtb3J5LiAgRm9yIHNpbXBsaWNpdHksIHRoaXMNCj4gPj4gc2VyaWVz
IHNpbXBseSBkaXNhYmxlcyBrZXhlYy9rZHVtcCBmb3Igc3VjaCBwbGF0Zm9ybXMuICBUaGlzIHdp
bGwgYmUNCj4gPj4gZW5oYW5jZWQgaW4gdGhlIGZ1dHVyZS4iDQo+ID4+DQo+ID4+IEEgcGF0Y2gg
WzNdIGZyb20gdGhlIHNlcmllc1sxXSwgZGVzY3JpYmVzIHRoZSBpc3N1ZSBhczoNCj4gPj4gIlRo
aXMgcHJvYmxlbSBpcyB0cmlnZ2VyZWQgYnkgInBhcnRpYWwiIHdyaXRlcyB3aGVyZSBhIHdyaXRl
IHRyYW5zYWN0aW9uDQo+ID4+IG9mIGxlc3MgdGhhbiBjYWNoZWxpbmUgbGFuZHMgYXQgdGhlIG1l
bW9yeSBjb250cm9sbGVyLiAgVGhlIENQVSBkb2VzDQo+ID4+IHRoZXNlIHZpYSBub24tdGVtcG9y
YWwgd3JpdGUgaW5zdHJ1Y3Rpb25zIChsaWtlIE1PVk5USSksIG9yIHRocm91Z2gNCj4gPj4gVUMv
V0MgbWVtb3J5IG1hcHBpbmdzLiAgVGhlIGlzc3VlIGNhbiBhbHNvIGJlIHRyaWdnZXJlZCBhd2F5
IGZyb20gdGhlDQo+ID4+IENQVSBieSBkZXZpY2VzIGRvaW5nIHBhcnRpYWwgd3JpdGVzIHZpYSBE
TUEuIg0KPiA+Pg0KPiA+PiBBbmQgYWxzbyBtZW50aW9uczoNCj4gPj4gIkFsc28gbm90ZSBvbmx5
IHRoZSBub3JtYWwga2V4ZWMgbmVlZHMgdG8gd29ycnkgYWJvdXQgdGhpcyBwcm9ibGVtLCBidXQN
Cj4gPj4gbm90IHRoZSBjcmFzaCBrZXhlYzogMSkgVGhlIGtkdW1wIGtlcm5lbCBvbmx5IHVzZXMg
dGhlIHNwZWNpYWwgbWVtb3J5DQo+ID4+IHJlc2VydmVkIGJ5IHRoZSBmaXJzdCBrZXJuZWwsIGFu
ZCB0aGUgcmVzZXJ2ZWQgbWVtb3J5IGNhbiBuZXZlciBiZSB1c2VkDQo+ID4+IGJ5IFREWCBpbiB0
aGUgZmlyc3Qga2VybmVsOyAyKSBUaGUgL3Byb2Mvdm1jb3JlLCB3aGljaCByZWZsZWN0cyB0aGUN
Cj4gPj4gZmlyc3QgKGNyYXNoZWQpIGtlcm5lbCdzIG1lbW9yeSwgaXMgb25seSBmb3IgcmVhZC4g
IFRoZSByZWFkIHdpbGwgbmV2ZXINCj4gPj4gInBvaXNvbiIgVERYIG1lbW9yeSB0aHVzIGNhdXNl
IHVuZXhwZWN0ZWQgbWFjaGluZSBjaGVjayAob25seSBwYXJ0aWFsDQo+ID4+IHdyaXRlIGRvZXMp
LiINCj4gPg0KPiA+IFdoaWxlIHRoZSBzdGF0ZW1lbnQgdGhhdCB0aGUgcmVhZCB3aWxsIG5ldmVy
IHBvaXNvbiB0aGUgbWVtb3J5IGlzIGNvcnJlY3QsDQo+ID4gdGhlIHNpdHVhdGlvbiB3ZSBjYW4g
dGhlb3JldGljYWxseSB3b3JyeSBhYm91dCBpcyB0aGUgZm9sbG93aW5nIGluIG15DQo+IHVuZGVy
c3RhbmRpbmc6DQo+ID4NCj4gPiAxLiBEdXJpbmcgaXRzIGV4ZWN1dGlvbiBvbiBwbGF0Zm9ybSB3
aXRoIHBhcnRpYWwgd3JpdGUgcHJvYmxlbSwgaG9zdCBPUyBvcg0KPiBvdGhlcg0KPiA+IGFjdG9y
IGV4ZWN1dGluZyBvdXRzaWRlIG9mIFNFQU0gbW9kZSB0cmlnZ2VycyBwYXJ0aWFsIHdyaXRlIGlu
dG8gYSBjYWNoZSBsaW5lDQo+IHRoYXQNCj4gPiBvcmlnaW5hbGx5IGJlbG9uZ2VkIHRvIFREWCBw
cml2YXRlIG1lbW9yeS4NCj4gPiBUaGlzIGlzIHNtdGggdGhhdCBob3N0IE9TIG9yIG90aGVyIGVu
dGl0aWVzIHNob3VsZCBub3QgZG8sIGJ1dCBpdCBjb3VsZCBoYXBwZW4NCj4gZHVlDQo+ID4gdG8g
aG9zdCBPUyBidWdzLCBldGMuDQo+ID4gMi4gVGhlIGFib3ZlIGNhdXNlcyB0aGUgc3BlY2lmaWVk
IGNhY2hlIGxpbmUgdG8gYmUgcG9pc29uZWQgYnkgbWVtDQo+IGNvbnRyb2xsZXIuDQo+ID4gSG93
ZXZlciwgaGVyZSB3ZSBhc3N1bWUgdGhhdCBubyBvbmUgYWNjZXNzZXMgdGhpcyBjYWNoZSBsaW5l
IGZyb20gVERYDQo+IG1vZHVsZSwNCj4gPiBURCBndWVzdHMgb3IgSG9zdCBPUyBmb3IgdGhlIHRp
bWUgYmVpbmcgYW5kIHRoZSBwcm9ibGVtIHJlbWFpbnMgaGlkZGVuLg0KPiA+IDMuIEhvc3QgT1Mg
Y3Jhc2hlcyBkdWUgdG8gc29tZSBvdGhlciBpc3N1ZSwga2R1bXAgY3Jhc2gga2VybmVsIGlzIHRy
aWdnZXJlZCwNCj4gPiBhbmQga2R1bXAgc3RhcnRzIHRvIHJlYWQgYWxsIHRoZSBtZW1vcnkgZnJv
bSB0aGUgcHJldmlvdXMgaG9zdCBrZXJuZWwgdG8NCj4gZHVtcA0KPiA+IHRoZSBkaWFnbm9zdGlj
cyBpbmZvLg0KPiA+IDQuIEF0IHNvbWUgcG9pbnQgb2YgdGltZSwga2R1bXAgY3Jhc2gga2VybmVs
IHJlYWNoZXMgdGhlIG1lbW9yeSB3aXRoIHRoZQ0KPiBwb2lzb25lZA0KPiA+IGNhY2hlIGxpbmUs
IGNvbnN1bWVzIHBvaXNvbiwgYW5kIHRoZSAjTUMgaXMgaXNzdWVkIGZvciB0aGUga2VybmVsIHNw
YWNlLg0KPiA+DQo+ID4gSXNuJ3QgdGhpcyB0aGUgcmVhc29uIGZvciBhbHNvIGRpc2FibGluZyBr
ZHVtcD8gT3IgZG8gSSBtaXNzIHNtdGg/DQo+IA0KPiBTbyBsZXRzIGNvbXBhcmUgdGhlIDIgY2Fz
ZXMgd2l0aCBrZHVtcCBlbmFibGVkIGFuZCBkaXNhYmxlZCBpbiB5b3VyIHNjZW5hcmlvDQo+IChj
cmFzaCBvZiB0aGUgaG9zdCBPUyk6DQo+IA0KPiBrZHVtcCBlbmFibGVkOiBObyBkdW1wIGNhbiBi
ZSBwcm9kdWNlZCBkdWUgdG8gdGhlICNNQyBhbmQgc3lzdGVtIGlzDQo+IHJlYm9vdGVkLg0KPiAN
Cj4ga2R1bXAgZGlzYWJsZWQ6IE5vIGR1bXAgaXMgcHJvZHVjZWQgYW5kIHN5c3RlbSBpcyByZWJv
b3RlZCBhZnRlciBjcmFzaC4NCj4gDQo+IFdoYXQgaXMgdGhlIG1haW4gY29uY2VybiB3aXRoIGtk
dW1wIGVuYWJsZWQ/IEkgZG9uJ3Qgc2VlIGFueSBkaXNhZHZhbnRhZ2UNCj4gd2l0aA0KPiBlbmFi
bGluZyBpdCwganVzdCB0aGUgYWR2YW50YWdlIHRoYXQgaW4gbWFueSBjYXNlcyBhIGR1bXAgd2ls
bCBiZSB3cml0dGVuLg0KDQpJIGFtIG5vdCBpbiB0aGUgcG9zaXRpb24gdG8ganVkZ2UgYWJvdXQg
d2hhdCBzaG91bGQgYmUgZG9uZSBhYm91dCBrZHVtcCBpbiBMaW51eCwNCm5laXRoZXIgSSBhbSBh
cmd1aW5nIG9uZSB3YXkgb3IgYW5vdGhlci4NCkkganVzdCB3YW50ZWQgdG8gZmlsbCB0aGUgZ2Fw
IGFuZCBleHBsYWluIHRoZSB0ZWNobmljYWwgc2NlbmFyaW8gYWJvdmUNCndoaWNoIEkgdGhpbmsg
d2FzIG1pc3NpbmcgZnJvbSB0aGlzIHRocmVhZC4gV2hhdGV2ZXIgZGVjaXNpb24gaXMgdGFrZW4g
YnkgDQpjb21tdW5pdHkgc2hvdWxkIHJlbHkgb24gdW5kZXJzdGFuZGluZyB0aGUgSFcgYmVoYXZp
b3VyLCBzbyB0aGlzIGlzIHdoYXQNCkkgdHJpZWQgdG8gZXhwbGFpbiBhYm92ZS4NCg0KQmVzdCBS
ZWdhcmRzLA0KRWxlbmEuDQo=

