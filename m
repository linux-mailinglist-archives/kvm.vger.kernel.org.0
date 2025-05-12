Return-Path: <kvm+bounces-46269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAEFAB46CA
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 23:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BABD07A1C25
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706DC24EF6D;
	Mon, 12 May 2025 21:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k5YKcA3P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2142561B0;
	Mon, 12 May 2025 21:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747086812; cv=fail; b=II8MW+IWu0lashLxw2xllZCM6wgoT+h8Lt3PMb79rkLO19j6O/6Wgrj6X9zssoBeJljcNFR/f9QAPmKwlNELeKD07tNimoAhra3207juCTz9Nq+5a7cGVCkU36IETTEJqO4KXNfMJNm8doKqaEchDq6mKuHpMFc/0aifHJXnllw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747086812; c=relaxed/simple;
	bh=iAdXNZ/NzaU2yo/LH2m4lBTCfmIO4Y8YASNuvDWeP2U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TmdPonBuvcSJ5S0B3XimS8VOunX0QH+JAVdhoVIKix8RNqDd4/1ldE6DlMB3GGyTQFekncpVkrrs9YBO30vo564ctM9bsc6q4GfEsX4pvMjca1K+39P5l7gZSNFOB+plMDFiGR6keQJ8sAEPjy5DBAdN7SHBzkpMQfJxWC0nl0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k5YKcA3P; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747086811; x=1778622811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iAdXNZ/NzaU2yo/LH2m4lBTCfmIO4Y8YASNuvDWeP2U=;
  b=k5YKcA3PaUTed5Y5cD8Ove8kCTVNT3NvUhqP00bRJTEKPK7opIRN/OAo
   Wwa2ZKbP1mQUpCwjXn2pktyDYgbZ2cUrHajhJo7Bcxkkzw7CXJ5kFS3Th
   RiCvlNFo+uHRqVAw3GXyGPTsrWLEh2MebBkR2X+cRvgx/v3C4Eo8/MA9B
   MYDEzi0AXhJQgUFYUtgxk4iFKqa90gpxwCftzCubEdZ6r0FzfYaDPs8WB
   E7/JC0GJeyknLbpdNUvRyeBY2ysqM62wI8LxqFPzHf/MWX50+mQ93UbsC
   4RWCFkNReZDWqHX5I+jEe8xfe4hCMc8zgIaqSRJ8W+zi1RSbECFbsBwkB
   w==;
X-CSE-ConnectionGUID: 1Z8FpACVSHCPacaoMcdgTA==
X-CSE-MsgGUID: rO/GoFx1R+qBB2GC3ct/PQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="59910309"
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="59910309"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 14:53:31 -0700
X-CSE-ConnectionGUID: xL2HzQoBT3acUQ1e3jxY+w==
X-CSE-MsgGUID: V4gZ+HdyTRm1z/yHizwbQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,283,1739865600"; 
   d="scan'208";a="138015067"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 14:53:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 14:53:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 14:53:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 14:53:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJdIU5pUG68BWJTmgyEDNbp2UKbP7iqu8+uQp/YByk9TtDOgmnQmjfMSFd3j7VO5Lgro9bF/u38ueWCA50FZDOurLtNYUBB5XbQF9wCCbIYBYCqOxj/TLi1GesvKeoJh+eG414lN6I0mZHOgKA4z0+D/Fj+mJ2vTVJTvPnHy2W8Xfz4sjhT4ocoWKgn9WEbXiDQngE7nObR2fVPwpowrtJ07fr013GRxDWqXiHvTWuRP5xEjUugUtyf0dPVaBSJlzyMv6T7L/pymjJ3/lzHOMxkkGcIojsfptsGBTO7H0GgS5PyBxKTSxbQJa/zhvDdIfIJsnRv6fS2qyxSh6mUhsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAdXNZ/NzaU2yo/LH2m4lBTCfmIO4Y8YASNuvDWeP2U=;
 b=wYTYrDmao+gemGyCP40QcsvyosQLxaZstDv3vLWuGOMLkRwtPKofMnp154/rGxSfdQLqJiMduvOoPxf4SgXUyfMG5uttA3O49qA1F1zniHXpYLkCPH0jJ10mGZXPOn2YJzoMmCPd4bpZDNiQSWBslNVPgUST1digqbj3PdKQIazILTAlyH27pla1qbQ+z7fvA+aZhhholBsXMcs8WPR3Cx92uDrwfKhSbESEXc+DN6ZNRgxUO70uyvhAifKjReIUJri1bFMkp1TMlzsketv7jTeDZbyAGZt0vJaX3phya1v2FkBnKZvmCSkO29zDsiit9MvfquKKsEyEZnKEQXgjbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7723.namprd11.prod.outlook.com (2603:10b6:610:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Mon, 12 May
 2025 21:53:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Mon, 12 May 2025
 21:53:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 18/21] KVM: x86: Split huge boundary leafs before
 private to shared conversion
Thread-Topic: [RFC PATCH 18/21] KVM: x86: Split huge boundary leafs before
 private to shared conversion
Thread-Index: AQHbtMZ+14Tf5LzGk0+2X6kh0KPzFbPLDE4AgANURYCAAUZygA==
Date: Mon, 12 May 2025 21:53:26 +0000
Message-ID: <9d2cf5239691294a8d94a797c15a823f7862b77e.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030844.502-1-yan.y.zhao@intel.com>
	 <fa85ac0cf3e6fae190dca953006d57c02fac6978.camel@intel.com>
	 <aCFb/ecA2AR2sNm1@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCFb/ecA2AR2sNm1@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7723:EE_
x-ms-office365-filtering-correlation-id: 935b99f2-1c1a-446b-7a34-08dd919f6cb4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TmlSZ2ZDV3pacTF5eG02RENXcTV6WGZ3VkhzTmMwekh1eHJ6c1pIOUlHSGl1?=
 =?utf-8?B?cGJxRGg3TCs2NDlPT3NraDdPRU0rR0NyU1FUT3R6R1NQcllpb0hRTWRGZ0pu?=
 =?utf-8?B?ZEd5eUJ1V2d4TmxWWVBKS1FaVjlZbVZwaG1JZnRNT0E4UWRHeDVmNWpPc3gz?=
 =?utf-8?B?ZmtocUJSWkRxZlVRVHVnQ21PTVF3ekxUZTBuSkhVa04yT2Jkazlid2p2WjUy?=
 =?utf-8?B?UytJT095TXBJa0NTOUtZV2NCWWt1blEvWDFUS2JBNXFVTUdIcm1RYXQxckZm?=
 =?utf-8?B?L2JCV01aQVNYeEZnWFAxQ3pKVzdvOUxUYjBQM0V4NVhXZGNQbFZWQ0EyZnRZ?=
 =?utf-8?B?cDRiQll2eEdydnBvT2NyMEdKYmRNcDl6djViWlRiVnFIdDZtZGNOZHc0cDdm?=
 =?utf-8?B?V2hsaWNCRldkTzZCV0ZsZzlaUW83Mm51b3VOcElDQVlKZmhTQVByRTg5L0hz?=
 =?utf-8?B?NkFDaHczdXNkaDExTW1wUk8zTHRBNkVBa1AwRUlQZGJDZWtlckxNckMyWXFr?=
 =?utf-8?B?V01RRytmZThJY2FrSURyWHR6ZldXZVQzZjRNQTlDMEpUMmdkNncvUWlnYWI5?=
 =?utf-8?B?dWd5R0VXZ1gxcERadGxwb1ByamY3UFNzNEJTRHBzYVJlVWFhbUZxanRmZ1o4?=
 =?utf-8?B?L0VxeDRBOFJzZisyaHlXakZqMDlPdFhBOWRrMmlMcWw1V0l4Si8za2tvWUZr?=
 =?utf-8?B?aUNEL2x3d0phS25MenFPU2VuQkFDemRyS0hQMFlmQ2lTR2xlNmwyS2NFUnhw?=
 =?utf-8?B?aWU1cjZFY1ByMVkxS0tMOEVSdHQzM1kvVGVOa2JGSVNqRnA2Zk42eTRaazRJ?=
 =?utf-8?B?UDJnZ0dlTHJDS1NVMjk2SGhWVnk5czFVRVBoMm1YT0RKeFFmS0lHckVjcnlE?=
 =?utf-8?B?Tm5pb0NTMkF5cjlNVXkwNkw4SEQrYnB3cTJ4ZkdwVkxvMCtDZHVaNkdSL3lM?=
 =?utf-8?B?Z2tsazlTa2JWdmFRR3lRb05zUE9GakdxaEdRUkljSjNkZFN3VmtCTnp4WG0x?=
 =?utf-8?B?dUh5SUloNlZkczhBZjBrOHBWazVTR09MZHJIbWljSm1jV1ZZOHpNUVh2R0pv?=
 =?utf-8?B?bXVCNjA1bzdKbGI1NXFCK2pzTWZOV2JodlcwaWlCaTk3ZFE0ZTNTMXVPUFdR?=
 =?utf-8?B?OTJDUWVOUzJwU0I5L3hYVVdWTkdHYVZuMUo2UUhORXRaeTgrd3VnZEZRTnVK?=
 =?utf-8?B?TC9reTRzWGwyaGYvcDVqejJaQ3FiZXZxcWxYU094dTN1TWFTUk1raVFBVXBr?=
 =?utf-8?B?MDNQaS9hN1ZZT24ySm1rdGttbXJUTTNQaGtMTnRjODByS0hCTVlGNmorejVi?=
 =?utf-8?B?SXUzNnA5T28vQWR5RGlKcXdiVU5XZHdUMXNxRktCNnFqdDJ1OWxIYitBWjdS?=
 =?utf-8?B?UndFYjNmOWlhYXBjb2tzT042cEE1dmg5UExZZU1tRmJkeVQ2bGQ5SVhScFNR?=
 =?utf-8?B?NTFuemM3R3UySDV5c0FXbzMyaDJ5MGQ4dUIzdjZQUUZ3b1ZpcUxsSWpxNll3?=
 =?utf-8?B?QlJJUmllenUvaXNzMkw3N3ZxKysxVFp1b05xSFBjM3N3Yk9NSWFUUzNEWDFz?=
 =?utf-8?B?TDVseTJHb0s2TVVWcXlrWDNvbTlzdEQxVnFseWlQQVlVQkxPVGY2RGwxblpW?=
 =?utf-8?B?bTVNNHMrTTArQ3ZzeUw5Q0hiRTM1eU9mZmJpMHBWNVl0ZVhVekFkcjBZYUFs?=
 =?utf-8?B?VnoxaU5yYUhGL1o5aEk0YWNaRkJkVWxsMWNOQWFlL0JsMFN2NXJMenBMWDkw?=
 =?utf-8?B?d1pWRnVHR3BJMldQSkkwbkxLK1g1M21vQ2Q5cWtDTlpya0gwcFNhWWtObktN?=
 =?utf-8?B?UFRCb0lJUUlrbFRubms0dlhoSmhHSWlUdXBvUmFnaTVrc25CSWkwZU1kWVhF?=
 =?utf-8?B?aTdXU0hXbnNkdUlTeGsybHc0UmJwMkQ2UUZxdWcvZVJVNmNFREVFeW95VGx2?=
 =?utf-8?B?WEMwUkYrN2U3aTZMR3ZjemZ3c21oZG1lQkhVazNBMDhXSHdxcmd5SUpySFdC?=
 =?utf-8?Q?+tBy23qgB5MbkYw6X8ilC7SlfvqwXU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFRRK2VwSnZKVDdDMWRyN2I4NEQvdzVUODNNb1ROdU13eE5jSkxTKzJBZG9s?=
 =?utf-8?B?TUhqOWdoc3lRSFp2Zk1rNVdqZDFvbzU4M3BxUXVNR0gwb1dIVWF3TDlsOUli?=
 =?utf-8?B?VENrbkdSWTVBNnZ2b3ZleVY3UkF2QnJEOUQyVGNUaU1BM2VkZE5maFk0SFQ0?=
 =?utf-8?B?U3IrYUhHYnQ1d3FabmM5eWxKZ0p3WldtdHdQOEpqV2xQcXNNRXVrVDZFZG91?=
 =?utf-8?B?KzN0WHd4TC9MZTVlK3VsMHVwTDJYYmkwaTVQdk04ZENTaTZYY3llblNHMjdY?=
 =?utf-8?B?c2RxcUpEeUZOUlR0aGprRUJwRzZ6ZVJEY0N1OTVaaHRWQWxYQVpQMFBscVpN?=
 =?utf-8?B?QXpKZ2V3aEN1QkRDa1d6a1VwWFgzL2JwTzdValhvM2pCb0lpR1J4T3ZGdm4y?=
 =?utf-8?B?K3dMN2krQlZBeG1WV21saUR5cGFFRmhORCtYTUM3UVk3Y1lsTlZ2Yy8wUmhR?=
 =?utf-8?B?ditDZzFRL3NZR3YyVFp3SDJORnIwb0s1OTB1NG0vcWxUdGg0Z0l2a0ZaejFT?=
 =?utf-8?B?V0FxK0FwajBtNWlJcDBtcEtQb2Z3bWU2TDJOZXlubU1KTDdMdC9xVzFvM1FI?=
 =?utf-8?B?U24zTzU5WlQ2YXFXSm5CL0k3TUpFak1manRIbVVKZkVXMlA1R0dId0NYWkFu?=
 =?utf-8?B?czdjby93b0pybnh1aytaUmZ2ZEwvdkxvbDAzcC9wRityY0R2VGpUamQ4TXd5?=
 =?utf-8?B?dEZNMEhmZ1Bld08xbm03Q3FYdUM5UXFiRWhiMTg2bUpza1VGWUNXd2pnMHZS?=
 =?utf-8?B?TlVpcHhwRVFaYTJucGI2ZmI0SDl5YTdpK3I3V21kSm9EZ2FwVTRPT2hlMElL?=
 =?utf-8?B?RHN6MDU4QmlEcTF0RWthWWdqWWhvdnNvb3VxQjhXT215SnF6eVNkV25hemxZ?=
 =?utf-8?B?ZExIVXNuSTZDTkRLNFRpNXZMQjkrbWFiVXAzcnJjeURsam5mTWFEYy96MWpE?=
 =?utf-8?B?UW1hbmtwaEt5c0tIeGVZNUdTN0poNWY1NlowK21BeG9OQ2UzWXhUR0wwa3VD?=
 =?utf-8?B?WDA4NWZjRlljNEg2ZmU0cExUa0plUWU0Wml0V1FNakdtZ1NMWURBanhSK1lv?=
 =?utf-8?B?VGdyRXp1NExIYVVkNUJ0dUJ0VDV2R3YxUy9KaDJ5YzlyYWptZWRObmxEUDMr?=
 =?utf-8?B?bmtLKzFJRkRCeHk5WVc4WjlTc0N1N1lGRnIwMVorVlFudUFmZ2VCT29BaWVI?=
 =?utf-8?B?cU5kYmVYZlF5MEVRUHNvUHNwUStlbDhjT01ITXBLdlY4SjZBY0lYdmUvbmRP?=
 =?utf-8?B?eWkrY0NVcG1rVGNpaXN4NTBFK1NwT2NpMkVEN0dEVW9JUWZXR2NlTzFQUUJy?=
 =?utf-8?B?WTVZM1FOWFh0M25veGpkQ3R0TXprTmZ4QjltWUVINHpqWDVaWS8vQzZ5MTdF?=
 =?utf-8?B?N1A3TnNLL3IvMjZHSXBTV0dubDFZVS9CRUp3dGJxZGtDbXdPa1h2UnZLMHB0?=
 =?utf-8?B?Q1R6cm5jSkxTVkNKYjdtNjVsOEFaOUpzTEl3V2lEaTlWUWtoSXR2RGw4UDl0?=
 =?utf-8?B?NXQyY2ZlUDMzKzZGaXgrNTdvQzZ5WGhvT1lWaWdIenRWVUZFYUdQZXJuYnZ6?=
 =?utf-8?B?NXN2TUJyU2xuVFYxU1F4Kyt3UFloL3hKS2t0NDJjY1h5ZGZXdjA1VkhaNUhD?=
 =?utf-8?B?VnZFTjVyNm1sQ0hTaXl2ZHNKUjMxR2syMjdveGFFRWxNenZ4WGtVcnh2QStt?=
 =?utf-8?B?MHhZWXNNb1drcVJGRG5xdktzL2dNNHdhVnlyR3lLY0tYcGhsV1FqUWhzdEho?=
 =?utf-8?B?T3Exc2pmZWNBd1E0SkFOc3Z1cWJ6cDVEemZENkE5M1RTT0E5T09GTDViUnJV?=
 =?utf-8?B?WFdpTDlCa3lCNWxDeXZNKzcrVXJQMjVnYmVNOUluUVEreHNRR2NmKytmYk1a?=
 =?utf-8?B?Zy9VSFJjOG83alArRTFyQlp1aEpxRDR5NWpSZ1BSdGJpMUlHeXRGNFprRkda?=
 =?utf-8?B?ejRKTGE3YkV2WWlvMWU4RGdyWFRCMHZOQktpbVpxQzdDczFrZVkySHF5a1Bx?=
 =?utf-8?B?V29XQ3BkNFpleE5hWnEzMkxrWG5ubWFkR2pnNzUyY3RITHNGb21DWHlwNU9E?=
 =?utf-8?B?N3kzd0pjdmx2SVVoZWVHSjVEYlBReTVGS0tVMm80S2ZQb2NMNWQyUk4yVDZk?=
 =?utf-8?B?QlQ2Y1piNEdGU0loOVVOVm5qWHVMTDJDMHJoMnpiZXNYV2lyTWNJWWxQb200?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14BF6F756D0ECA499A6BD7C41B2B1251@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935b99f2-1c1a-446b-7a34-08dd919f6cb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 21:53:26.5877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xIneF2x2n1JFNPm9GMkw3ONoSbzABISpA8/n3D03ROqjj0iocu31mdjvW7hmhtHAvgMXkF5tjVIYkXD1r89OJ0wb87NztH+Yw24nq+AKMQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7723
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTEyIGF0IDEwOjI1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBG
QUxMT0NfRkxfUFVOQ0hfSE9MRSBkZW1vdGlvbiBmYWlsdXJlIGRvZXNuJ3QgbG9vayBsaWtlIGl0
IGlzIGFkZHJlc3NlZCBpbg0KPiA+IHRoaXMNCj4gSG1tLCBGQUxMT0NfRkxfUFVOQ0hfSE9MRSBk
ZW1vdGlvbiBmYWlsdXJlIGlzIGhhbmRsZWQgaW4gcGF0Y2ggMTkuDQoNCk9oLCByaWdodCB5b3Ug
YXJlLg0KDQo+IA0KPiA+IHNlcmllcy4gSSBub3RpY2VkIHRoYXQgbW11IG5vdGlmaWVyIGZhaWx1
cmVzIGFyZSBhbGxvd2VkIHRvIGJlIGhhbmRsZWQgYnkNCj4gPiBibG9ja2luZyB1bnRpbCBzdWNj
ZXNzIGlzIHBvc3NpYmxlLCBpbiBtb3N0IGNhc2VzLiBLVk0ganVzdCBkb2Vzbid0IG5lZWQgdG8N
Cj4gPiBiZWNhdXNlIGl0IGNhbid0IGZhaWwuIFdlIGNvdWxkIHRoaW5rIGFib3V0IGRvaW5nIHJl
dHJpZXMgZm9yDQo+ID4gRkFMTE9DX0ZMX1BVTkNIX0hPTEUsIHdoaWxlIGNoZWNraW5nIGZvciBz
aWduYWxzLiBPciBhZGRpbmcgYSBFTk9NRU0gZXJyb3INCj4gPiBjb2RlDQo+ID4gdG8gZmFsbG9j
YXRlLg0KPiBJbiBwYXRjaCAxOSwgRkFMTE9DX0ZMX1BVTkNIX0hPTEUgY291bGQgcmV0dXJuIC1F
Tk9NRU0uDQoNClllcy4gSXQgaXMgbm90IGluIHRoZSBtYW4gcGFnZXMsIGJ1dCBsb29raW5nIHRo
aXMgbW9ybmluZyBJIHNlZSBvdGhlciBmYWxsb2NhdGUNCmhhbmRsZXJzIGFyZSBhbHJlYWR5IHJl
dHVybmluZyBpdC4NCg0KPiANCj4gUmV0dXJuaW5nIC1FTk9NRU0gbWF5IGJlIGluZXZpdGFibGUg
YXMgd2UgY2FuJ3QgZW5kbGVzc2x5IHJldHJ5LiBTbyBmb3INCj4gc2ltcGxpY2l0eSwgdGhlcmUn
cyBubyByZXRyeSBpbiB0aGlzIHNlcmllcy4NCg0KT2ssIHNlZW1zIGdvb2QuDQoNCj4gDQo+IA0K
PiBCZXNpZGVzIHRoYXQsIGRvIHlvdSB0aGluayB3aGV0aGVyIHdlIG5lZWQgdG8gY29uZHVjdCBz
cGxpdHRpbmdzIGJlZm9yZSBhbnkNCj4gdW5tYXAgaXMgaW52b2tlZD8NCj4gDQo+IEFzIGluIHRo
ZSBwYXRjaCBsb2c6DQo+ICINCj4gVGhlIGRvd25zaWRlIG9mIHRoaXMgYXBwcm9hY2ggaXMgdGhh
dCBhbHRob3VnaA0KPiBrdm1fc3BsaXRfYm91bmRhcnlfbGVhZnMoKcKgwqDCoMKgwqDCoMKgIA0K
PiBpcyBpbnZva2VkIGJlZm9yZSBrdm1fdW5tYXBfZ2ZuX3JhbmdlKCkgZm9yIGVhY2ggR0ZOIHJh
bmdlLCB0aGUNCj4gZW50aXJlwqDCoMKgwqDCoMKgwqDCoMKgwqAgDQo+IGNvbnZlcnNpb24gcmFu
Z2UgbWF5IGNvbnNpc3Qgb2Ygc2V2ZXJhbCBHRk4gcmFuZ2VzLiBJZiBhbiBvdXQtb2YtDQo+IG1l
bW9yecKgwqDCoMKgwqDCoMKgwqDCoCANCj4gZXJyb3Igb2NjdXJzIGR1cmluZyB0aGUgc3BsaXR0
aW5nIG9mIGEgR0ZOIHJhbmdlLCBzb21lIHByZXZpb3VzIEdGTg0KPiByYW5nZXPCoMKgwqDCoMKg
wqAgDQo+IG1heSBoYXZlIGJlZW4gc3VjY2Vzc2Z1bGx5IHNwbGl0IGFuZCB6YXBwZWQsIGV2ZW4g
dGhvdWdoIHRoZWlyDQo+IHBhZ2XCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCANCj4gYXR0cmli
dXRlcyByZW1haW4gdW5jaGFuZ2VkIGR1ZSB0byB0aGUgc3BsaXR0aW5nIGZhaWx1cmUuIFRoaXMg
bWF5IG5vdCBiZQ0KPiBhwqDCoMKgwqDCoCANCj4gYmlnIHByb2JsZW0gYXMgdGhlIHVzZXIgY2Fu
IHJldHJ5IHRoZSBpb2N0bCB0byBzcGxpdCBhbmQgemFwIHRoZQ0KPiBmdWxswqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCANCj4gcmFuZ2UuDQo+ICINCg0KSWYgd2UgZW5kZWQgdXAgcGx1bWJpbmcgdGhl
IHphcHBpbmcgZXJyb3JzIGFsbCB0aGUgd2F5IHRocm91Z2ggdGhlIE1NVSwgaXQNCnByb2JhYmx5
IHdvdWxkIGJlIHNpbXBsZXIgdG8gZG8gaXQgZHVyaW5nIHRoZSB1bm1hcC4gT2YgY291cnNlIGNh
bGxlcnMgd291bGQNCmhhdmUgdG8gYmUgYXdhcmUgdGhlIHJhbmdlIG1heSBiZSBoYWxmIHVubWFw
cGVkIG9uIGVycm9yLiBJIHRoaW5rIHRoZSB3YXkgeW91DQpoYXZlIGl0IGlzIG5pY2UgZm9yIG5v
dCBjaHVybmluZyB0aGUgTU1VIHRob3VnaC4NCg0KQnV0IGZvciB0aGUgY2FzZSBvZiBoYXZpbmcg
dG8gcmV0cnkgdGhlIHNwbGl0IGFuZCB3YWxraW5nIHRoZSBtaXJyb3IgRVBUIHJhbmdlDQphZ2Fp
biwgaXQncyBhIHJhcmUgY2FzZSBhbmQgbm90IHdvcnRoIG9wdGltaXppbmcgZm9yLiBMZXQncyBu
b3QgY29uc2lkZXIgaXQNCm11Y2guDQo=

