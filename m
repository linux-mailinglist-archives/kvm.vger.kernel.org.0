Return-Path: <kvm+bounces-19919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2308E90E270
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 06:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 133321C2226C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 04:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAB147796;
	Wed, 19 Jun 2024 04:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OHYARIlv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3339117999;
	Wed, 19 Jun 2024 04:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718772771; cv=fail; b=ZEAQEiR5YAm7U5+QGyR4cnLirCgeVskHxs8daxMyfotIuVwfxbRXobTlz7rdP1h7c+r0HHSRtaNrl6XbNFMkR2C+sq7grD+jzGHSTcg+NFi7yi8UsLp/5fHA8Et2QRoJ8FpFSWA+ribntn5psDKsn1z4mLWGr37Olm9k7Nakx7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718772771; c=relaxed/simple;
	bh=d/OoYE8kMBtiW8DbtSe9sD/BK5drO/nA14TWhcjCZYo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k//8pSmdg1PR/NZ8nb27r+mJIzf4XWwpd5mjmdGFn19snqzaaVQOrSM9CBbKpHfhwj8LxWhqLrqPu4FGdFh2xD0MwUxFqeqvz73Ou5SnqM8UIT9tVJeY5R+dRWeQ3LVTsrq5yvrXFo5JqZ7Bruw9pM17yM4VhyzJbtbJK8a7Mfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OHYARIlv; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718772770; x=1750308770;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=d/OoYE8kMBtiW8DbtSe9sD/BK5drO/nA14TWhcjCZYo=;
  b=OHYARIlvOerWjatCJ2IcFaLLSSHP/E0mLp1w3myB2kp2JgAURMV+hBOO
   6xek7YQYfC3d0Ooua+RyXjww9gEKIDjQOBRxCn3GPfnk1W2cPBCPcyl8/
   Hq75tqaiVeO1nmOis3R0+TT/2qc2c4PyBcYQ63S9N54abTT2tcNCJmuGv
   mONRMi2fzkO8f49KLZhaO+jIHq/4iYuLOil5xsFHtbJYzWoF3n7jTOgS8
   +45KnPaSBwYtI5rGXwxQ17mc8oIfJha7yWl9iLOU/ErAy04lRQY27m5d1
   9YTaOurGSZMUag3/VWgYUkbMASUpmF93ptYumdEiWUc0O8IOfvGh10XoC
   Q==;
X-CSE-ConnectionGUID: ctWXtbIgQxixR4BzpF+6xA==
X-CSE-MsgGUID: 0XhPXkKIQ/mPHVF6euvhmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="26812947"
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="26812947"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 21:52:49 -0700
X-CSE-ConnectionGUID: mlHw67HjT2SbKiF65QLdhw==
X-CSE-MsgGUID: LiAHXZ9cSvSkMgQUe4h3HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="41743073"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 21:52:48 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 21:52:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 21:52:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 21:52:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emcudbAUrWOk/VYv7chexwmfvcNO3FKEPgbTKRC/hjb72OF/Bbp6qovhMpZKd4ur48lkhAdMDlfFWmKAQ5vxKdFzJh+rFhzf4MRQEMjWskX62/PhGt0W2o3PGgMVMb9seOk5TlRJ3Uq76f2JcP09UNItmuvlVZWun3zmI+bzPPKRtSj1AhpnUxf14AeCNpJyvnXmvpbqRx2rKhUrBDctRcEpuJxkloYIAzhMc+KhteETncl/8loLtVBI+r1WRD8O20BHL9DCphsfv+X+UcWxhXnuD11DMfpj88sr1M2n04xiyyuQ0Sqzxyt8JQDcpasKo3iwlSPSVYFXAWFqzOhXsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/OoYE8kMBtiW8DbtSe9sD/BK5drO/nA14TWhcjCZYo=;
 b=RNaG8/+7jha2Y8/o7Ssny3Jfj182k8URAAmxBxw6hmxE1cr8u6+XekZOfb5lCLPovczTF3fmiQVZuDV7ndh/mpqGRBtNo19aq2ReF0hr5wvBs7Ye6wfPTGQ/cx/YqS54XXj0g8vRhYWqF9HCQXCCitB/Z6QBJwjau160Z9iFSUI+dgXSP1WAOu6uKbR9sYWkpzNRlmUlaMnHyYkXkAmReJa1PCVzxvr0Ci0nZ6gdLfh70XTs0tfwT8fwPdNgrvkF+7/5X7bmZZaey7sEk/UZ05C7qvys7KJWDOxe0NM2YEBu8mennq1MHQiZ923w4hrFpDkyQkaNUSDgY8teRyHm1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5239.namprd11.prod.outlook.com (2603:10b6:208:31a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Wed, 19 Jun
 2024 04:52:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 04:52:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Topic: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Index: AQHaaI2/dJkfmwuOl0Kzt5Q4G20a/rGPjNSAgABl+QCAAANegIAAB3kAgAAJ9QCAAO1bAIAFfyEAgBj234CAANvZgIAAtdgAgAcL1wCADwerAIABjg2AgASxLYCAAP0FgIAAfaWAgABt4gA=
Date: Wed, 19 Jun 2024 04:52:45 +0000
Message-ID: <2108fefffb4dd88a80beeecaf087e64613d0e3ec.camel@intel.com>
References: <20240509235522.GA480079@ls.amr.corp.intel.com>
	 <Zj4phpnqYNoNTVeP@google.com>
	 <50e09676-4dfc-473f-8b34-7f7a98ab5228@intel.com>
	 <Zle29YsDN5Hff7Lo@google.com>
	 <f2952ae37a2bdaf3eb53858e54e6cc4986c62528.camel@intel.com>
	 <ZliUecH-I1EhN7Ke@google.com>
	 <38210be0e7cc267a459d97d70f3aff07855b7efd.camel@intel.com>
	 <405dd8997aaaf33419be6b0fc37974370d63fd8c.camel@intel.com>
	 <ZmzaqRy2zjvlsDfL@google.com>
	 <5bb2d7fc-cfe9-4abd-a291-7ad56db234b3@intel.com>
	 <ZnGehy1JK_V0aJQR@google.com>
	 <fcbc5a898c3434af98656b92a83dbba01d055e51.camel@intel.com>
In-Reply-To: <fcbc5a898c3434af98656b92a83dbba01d055e51.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5239:EE_
x-ms-office365-filtering-correlation-id: e6c7f73f-da42-4edb-7c98-08dc901ba8e8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|366013|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?K1NSdUp6dVFya1JiUi9qMDZLWUcxSDF3bFJDTkhYNUwrL0J1YmhNZmd2VFRX?=
 =?utf-8?B?c3B3V1pBdW5DSGlsMlh0cG5tT2JTbGJQandlbU1LNEQ5U2kwZXpQWVdwZVA2?=
 =?utf-8?B?blJQdDBGcmlEL3M2cW9rSzMvR0R3TWJxL2tQWU9USWg1RkYyOXBDQU5xRjBV?=
 =?utf-8?B?SnF3ZzhuYnQ4Ty9Xb0FEZTJYUXgzUnVpWU1TZHdZaERnWkd2Q3Q4N2tsNFd3?=
 =?utf-8?B?cldKUk5hVFZzWWNtbVI3WmpSalhBbWhGd01ZcHRHelByaWthT0FlT242bU1G?=
 =?utf-8?B?SHRTRlJZZXEzcVBhNXZGUXFTZTBOekJOam9OZU5lbWRDMFVFeXJJcTJtei9E?=
 =?utf-8?B?U1lxZVF2Q2oyT1IwRUlvb2FOK2dkbm9GL3VCUFpPeVhwb2QvY3h2R1gyVXZY?=
 =?utf-8?B?eE5Vam9aSWg0VDVVN1EvNkJrZ3JHVy9aZEhkaGpnQ25XOHppb2FYZDFoOEtW?=
 =?utf-8?B?SzliMURtaStoYno2UTRid1M3clJYU0EyOXhEaXNMOU4yTlhFRUJQVTdpMkhD?=
 =?utf-8?B?R3p5OHdheUdFK0xyVUxDQWVmck9RVVdtTXcvYnJCdkhiaTNVNVFzVEU4WHdq?=
 =?utf-8?B?Znh1VDlrSlJ1VlVMOUg4d2RFLzdTN002cWMyckNBZWZzdFZCZ2Njd0VrMHlR?=
 =?utf-8?B?aHRjTG5mcHVNV3lkK3c0R2FDVjlubnBQSHJuK1AwVVdzYlRvUWt6bGdVeHZF?=
 =?utf-8?B?TC9JQXFNcEcrK3dqdTRzU2pWTEpwcmpab1JDVW0xRXIwR1hUNjBJYzRsUzVK?=
 =?utf-8?B?M2FsVHBuMlhOZTdHdUhSVnQreFJhYk5xSjhFZXdaMTkvcWh0ZWh4WFB6YnpC?=
 =?utf-8?B?c1RLT1lCcEIybi96elBGcERiV0VGaFpIT2QxZ2tBQVBNN2R3VHM3WXRIYStO?=
 =?utf-8?B?QVMrbFZnSFI5WjFkOWNaOU9VMFBFNnlldm1jTE0ySmM0eUJXQW1mRm8xWnRY?=
 =?utf-8?B?M0lyTEs5RWhQNmVKZnlQTFhkR3pNT2JqRFh5S3JHREF6em1oMGYzdmEwZWFn?=
 =?utf-8?B?TmVXN3dyL01WMGxTSlJvM3BrSHc2dzkwZElWVlY4emF1VHJ4ckE1dGhUUUlm?=
 =?utf-8?B?RnFHa0ZXVmgwWngrUGtDM3dMNGxOSXhmU0NCMEZ2bWV3MkhUb1lyRDJzTmZj?=
 =?utf-8?B?S2svODA4Wk9zd0lqb1RvR2xSLy9YRE00c2cyRzR4K3FJRjFKZ0Q2WDRKMlVB?=
 =?utf-8?B?dHBJT3VhZ0pMRTFaSDMzL3ZORkpVSE5mREoxUjJlVitHSk01MVZ1cGxkUDdH?=
 =?utf-8?B?ZTlUbVhBU3dXRlRjZHAvQjg3V2lPd2dZZTFaMDhwcVhUWlR3UGs1aXRKVkZ2?=
 =?utf-8?B?YWkyZy9qc2dEMVd3YnBJdnMvS0Y3SWk3c3p5TGxhdHVZekRTSmVraEV2RDJh?=
 =?utf-8?B?MkY5SFVXejROWFJ1bEVXYzBkOTZzTDdaT0xxVUM4Z2hNOU9uaUFWdVc3NVVn?=
 =?utf-8?B?YjZHMzVzVnVnR3lMSnNuQkJiUG95UytwMTlRRWljMnhmV0xpRVoyN1hCL1JL?=
 =?utf-8?B?cjdjRGVuOVFXbTEvQTFGbHlJVDc2WWxuQVEwRkVHQ2hURHBiMVdLc2tLeHJz?=
 =?utf-8?B?L1V3c0dwb0lBR05UMGRSZWp2aGR5cllrQjBPM2grUmt5Mk5BL0hLMzBOTVJn?=
 =?utf-8?B?YVMvNmlhT0crcTZZMjN3YzNLRWVwa2FNKzkrUE14ZlpPVkk0czdsaFF4akV0?=
 =?utf-8?B?UkhQUnE3anlDQnlXYUFna2pBQjQrN0xjR0FkckZzb0pTMVNDVVNPYnBMKzc1?=
 =?utf-8?B?WEY1bVdzOE4rR3QwS2E1OVpkV2Z4RStidWhYL3JOZmhPU1Vvb1UwdTZ5MkJQ?=
 =?utf-8?Q?5chCgYS2aoS8OJ01I15nBaqiVsZCT5h9Ve0Oo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlRNaVhPYStVenhaZ1ZhMG9xVERydlVpVm1pZytCc2lRL1V5eGtEbU5zbEY0?=
 =?utf-8?B?cWpFMjRnQWlqVi81d3M4Kzl3QnEwTnU1anRqZHdQVW93SGplSEo1YTdZUUFs?=
 =?utf-8?B?SDJWRWpSc2N2Zk95d1JKR2pLeWI3ZG9jeFFQekw5UGxZMm9LL3kzVWRaWG1h?=
 =?utf-8?B?ZnhKODg1YnpZOW9ZcFZuazdPYk1YS1lZOFNCSWdZSDBlM2NIYnlRM3VXZkhI?=
 =?utf-8?B?dGJNMFl0MGZ5TkFCazJZNFdLV3dmVFovNkpGN3lIczZmWVFEYzBJMVB5b0ZP?=
 =?utf-8?B?a3Zwd3F5SVlvZW10WFNXSXloNDlyenNvZ3VmcUxZVDZvaG8vb2h6WEhTam00?=
 =?utf-8?B?ZjNnZys0NVZITGpvQ3pPRm9JOTQ0UThoczhGWmZJcFVrNzNlaG5SUHJvRW12?=
 =?utf-8?B?enRkT3FIMkF3QlBVOVVtT1dBeHhwSU5wUzhIbzdwT0VRVTZJalVlSnBGTWNZ?=
 =?utf-8?B?WXRMaExpNU9FL2lxY28vdmloWTFHTm8zVGt0VCtLZE9NK3BxL0tQNDNGNnBQ?=
 =?utf-8?B?OWYzcHFEZUt0bzRQMnptVmFWS2c4amcvU0F0Z2tpZ0ZXZ0V0S3JMVmhISUts?=
 =?utf-8?B?Z3Fod2ZsVXcxZGd3TnducEFyUzBZTG1uVDBNWnBEc0RtSzRyei9yK0pwWjFW?=
 =?utf-8?B?cG9ndzlHVEpWZU1yS3NzSGl2TzIwR1VMMHF6RWI3ZFVBcFZLQ0Q4NHFVRUdK?=
 =?utf-8?B?a2FJLzZSa0RkMkowTkZPLzJkT3d1K2p3MFhPaGxkZ0l3eFZUKzZnT2xGTlpi?=
 =?utf-8?B?dU1ZL0JPV3F0Nzk0ejhXZk9ENmVTUDJMUTBCZjlGZjhhdEgrNTBuRWt3VzJa?=
 =?utf-8?B?WnZzM3E4UVhuTDJjaHBmT1Q3UHVZSUE0NjFZekt0MlRZOUNVSTZoM0JkZWFz?=
 =?utf-8?B?MWhFZU1KTmpFU28ybjdzWjhUN0JoRHZ2ZlQ1QXc3VnVLMHpnWGszRVg0K09I?=
 =?utf-8?B?Wml4ZUVFUGFSK1ZZNWhNUjk2NE5sT3RobEwvMm5ldkg3RmhmUk5wRmI2NUlE?=
 =?utf-8?B?V1VqWms3VFVjWnJoL05KcDU5ZkV2S21WTnoya1crbEVMWU00RkxaOVgyR1Fq?=
 =?utf-8?B?ci8yckY5QWVLM3lHVFVMNnJpTmFnQjRRZ0lONXhJYXh5NkdvREIzTHFOVzc4?=
 =?utf-8?B?R0lFYzhXcFlBU1Azb3FHbTQvUjJzaXhlQ1IzRnVObWQ5K3RUbjJzdkx5c3BD?=
 =?utf-8?B?QWNiWE5RbWM0TTRnanBiZGQ1eGQ1bjY4N1RTdVdlSHpOK3EvazFaMWljTFFP?=
 =?utf-8?B?QTdpMUFNbWxseUhUR1ZaYmNtS2dvMVNxZHVxQmh3S09XTkJMV2JONFZGY3Nj?=
 =?utf-8?B?bzRDSFh3MVdmMjlaclJMM0tyc0MxK2U2ZUZ6dGVGRnNOSzhiaHVtNk5jSUNV?=
 =?utf-8?B?WkVTNnlVVFdwOWs1M3laR0pPYWFKUm01eGFYR1grUEhTczc0OXJnMDRVdDln?=
 =?utf-8?B?SUZOS2laUVdVc1NaRmt1OENsY3JOcmxFeDVmY2dKYks3NDVTT1Y0RGN4aGM0?=
 =?utf-8?B?U2ZiNEpzSTdjU3pXOTlQMVhTcngxUk10Zk93dDBUR1V5anZrL0ZzRzZzOUla?=
 =?utf-8?B?QU83WDNIMis2K3BiUTYxQ1dHQWdKdFhiL0pvZjJ2b1FZKzFWUkFPMWtMQmxG?=
 =?utf-8?B?am9Ja0FpRzh5aktpd3pHakNLQk81R2hMV29pRElPZ1ZmSlpZZ0dXczNqTjZi?=
 =?utf-8?B?OUdLNm1tNGRteklQV1lienllN0FpelJ0VVBZU0huRnMyelYrWE9aNnUyU2Mv?=
 =?utf-8?B?M2NnL0ZmWmx0c3h2TFo4YzU4aVlpUWRyS1dHeTFZV3pxdEhxUXV5a3dGcWNt?=
 =?utf-8?B?d2prekMrY1ZwZjN2azFLL3J3OS93TTAyQ3pKUVZFdUM2bUlTQlByQlp3VE1v?=
 =?utf-8?B?VnZqamhnUXBOSU5sUmZEVjlaVDkvdUtzbmZPb0VFUDM3dmQwQzZRSEROVXVp?=
 =?utf-8?B?dGlrUmtqN0h6RnZLSlVjNWlHbHpuTWozZzFLY0FWVDVuQnhZenVDa2MxeGVo?=
 =?utf-8?B?cHVkcmRjMlVuVVFXZ1YvMG9OQXB2SUI0QkJXZ1NibkIreEw5ci93cS9PNE1W?=
 =?utf-8?B?cEhvSkxOc1BGdWEvUUkyRDZTS2toendoK3RtOGxqQVR5SjFpcjMxR05DdTli?=
 =?utf-8?B?Y3g2ZXZEdGhBQXJlbSs0djJySy91eWQ1ZXgyRldMWkl0cjhXRUNXNEdBTUVH?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15B52A5AEA3EBB4F8F6D87058446E0D6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c7f73f-da42-4edb-7c98-08dc901ba8e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2024 04:52:45.1646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fl0Rbuj9qIowpzFTirxyLgzXGqMUe8/ZPjsMmg79xg0wkKUMfi04EoGEcaYNZHldlIvKOQ1EwA0pSRURTwOvfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5239
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDIyOjE5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUdWUsIDIwMjQtMDYtMTggYXQgMDc6NDkgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gT24gVHVlLCBKdW4gMTgsIDIwMjQsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+IE9u
IDE1LzA2LzIwMjQgMTI6MDQgcG0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+
IE9uIEZyaSwgSnVuIDE0LCAyMDI0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+ID4gPiAtIFRo
ZSAibWF4X3ZjcHVzX3Blcl90ZCIgY2FuIGJlIGRpZmZlcmVudCBkZXBlbmRpbmcgb24gbW9kdWxl
IHZlcnNpb25zLiBJbg0KPiA+ID4gPiA+ID4gcHJhY3RpY2UgaXQgcmVmbGVjdHMgdGhlIG1heGlt
dW0gcGh5c2ljYWwgbG9naWNhbCBjcHVzIHRoYXQgYWxsIHRoZQ0KPiA+ID4gPiA+ID4gcGxhdGZv
cm1zICh0aGF0IHRoZSBtb2R1bGUgc3VwcG9ydHMpIGNhbiBwb3NzaWJseSBoYXZlLg0KPiA+ID4g
PiANCj4gPiA+ID4gSXQncyBhIHJlYXNvbmFibGUgcmVzdHJpY3Rpb24sIGUuZy4gS1ZNX0NBUF9O
Ul9WQ1BVUyBpcyBhbHJlYWR5IGNhcHBlZCBhdCBudW1iZXINCj4gPiA+ID4gb2Ygb25saW5lIENQ
VXMsIGFsdGhvdWdoIHVzZXJzcGFjZSBpcyBvYnZpb3VzbHkgYWxsb3dlZCB0byBjcmVhdGUgb3Zl
cnN1YnNjcmliZWQNCj4gPiA+ID4gVk1zLg0KPiA+ID4gPiANCj4gPiA+ID4gSSB0aGluayB0aGUg
c2FuZSB0aGluZyB0byBkbyBpcyBkb2N1bWVudCB0aGF0IFREWCBWTXMgYXJlIHJlc3RyaWN0ZWQg
dG8gdGhlIG51bWJlcg0KPiA+ID4gPiBvZiBsb2dpY2FsIENQVXMgaW4gdGhlIHN5c3RlbSwgaGF2
ZSBLVk1fQ0FQX01BWF9WQ1BVUyBlbnVtZXJhdGUgZXhhY3RseSB0aGF0LCBhbmQNCj4gPiA+ID4g
dGhlbiBzYW5pdHkgY2hlY2sgdGhhdCBtYXhfdmNwdXNfcGVyX3RkIGlzIGdyZWF0ZXIgdGhhbiBv
ciBlcXVhbCB0byB3aGF0IEtWTQ0KPiA+ID4gPiByZXBvcnRzIGZvciBLVk1fQ0FQX01BWF9WQ1BV
Uy4gPg0KPiA+ID4gPiBTdGF0aW5nIHRoYXQgdGhlIG1heGltdW0gbnVtYmVyIG9mIHZDUFVzIGRl
cGVuZHMgb24gdGhlIHdoaW1zIFREWCBtb2R1bGUgZG9lc24ndA0KPiA+ID4gPiBwcm92aWRlIGEg
cHJlZGljdGFibGUgQUJJIGZvciBLVk0sIGkuZS4gSSBkb24ndCB3YW50IHRvIHNpbXBseSBmb3J3
YXJkIFREWCdzDQo+ID4gPiA+IG1heF92Y3B1c19wZXJfdGQgdG8gdXNlcnNwYWNlLg0KPiA+ID4g
DQo+ID4gPiBUaGlzIHNvdW5kcyBnb29kIHRvIG1lLiAgSSB0aGluayBpdCBzaG91bGQgYmUgYWxz
byBPSyBmb3IgY2xpZW50IHRvbywgaWYgVERYDQo+ID4gPiBldmVyIGdldHMgc3VwcG9ydGVkIGZv
ciBjbGllbnQuDQo+ID4gPiANCj4gPiA+IElJVUMgd2UgY2FuIGNvbnN1bHQgdGhlIEBucl9jcHVf
aWRzIG9yIG51bV9wb3NzaWJsZV9jcHVzKCkgdG8gZ2V0IHRoZQ0KPiA+ID4gIm51bWJlciBvZiBs
b2dpY2FsIENQVXMgaW4gdGhlIHN5c3RlbSIuICBBbmQgd2UgY2FuIHJlamVjdCB0byB1c2UgdGhl
IFREWA0KPiA+ID4gbW9kdWxlIGlmICdtYXhfdmNwdXNfcGVyX3RkJyB0dXJucyB0byBiZSBzbWFs
bGVyLg0KPiA+IA0KPiA+IEkgYXNzdW1lIFREWCBpcyBpbmNvbXBhdGlibGUgd2l0aCBhY3R1YWwg
cGh5c2ljYWwgQ1BVIGhvdHBsdWc/IMKgDQo+ID4gDQo+IA0KPiBDb3JyZWN0Lg0KPiANCj4gPiBJ
ZiBzbywgd2UgY2FuIGFuZA0KPiA+IHNob3VsZCB1c2UgbnVtX3ByZXNlbnRfY3B1cygpLiDCoA0K
PiA+IA0KPiANCj4gT24gVERYIHBsYXRmb3JtIG51bV9wcmVzZW50X2NwdXMoKSBhbmQgbnVtX3Bv
c3NpYmxlX2NwdXMoKSBzaG91bGQgYmUganVzdA0KPiBpZGVudGljYWwsIGJlY2F1c2UgVERYIHJl
cXVpcmVzIEJJT1MgdG8gbWFyayBhbGwgYWxsIHBoeXNpY2FsIExQcyB0aGUNCj4gcGxhdGZvcm0g
YXMgZW5hYmxlZCwgYW5kIFREWCBkb2Vzbid0IHN1cHBvcnQgcGh5c2ljYWwgQ1BVIGhvdHBsdWcu
DQo+IA0KPiBVc2luZyBudW1fcHJlc2VudF9jcHVzKCkgdy9vIGhvbGRpbmcgQ1BVIGhvdHBsdWcg
bG9jayBpcyBhIGxpdHRsZSBiaXQNCj4gYW5ub3lpbmcgZnJvbSBjb2RlJ3MgcGVyc3BlY3RpdmUs
IGJ1dCBpdCdzIE9LIHRvIG1lLiAgV2UgY2FuIGFkZCBhIGNvbW1lbnQNCj4gc2F5aW5nIFREWCBk
b2Vzbid0IHN1cHBvcnQgcGh5c2ljYWwgQ1BVIGhvdHBsdWcuDQo+IA0KPiA+IElmICBsb2FkaW5n
IHRoZSBURFggbW9kdWxlIGNvbXBsZXRlbHkgZGlzYWJsZXMNCj4gPiBvbmxpbmluZyBDUFVzLCB0
aGVuIHdlIGNhbiB1c2UgbnVtX29ubGluZV9jcHVzKCkuDQoNCk1pc3NlZCB0aGlzIG9uZS4NCg0K
Tm8gbG9hZGluZy9pbml0aWFsaXppbmcgVERYIG1vZHVsZSBkb2Vzbid0IGRpc2FibGUgb25saW5p
bmcgQ1BVcy4gIFREWA0KbW9kdWxlIGNhbiBiZSBpbml0aWFsaXplZCBvbiBhIHN1YnNldCBvZiBw
aHlzaWNhbCBsb2dpY2FsIENQVXMuICBBbHNvLA0KYWZ0ZXIgbW9kdWxlIGluaXRpYWxpemF0aW9u
LCBsb2dpY2FsIENQVSBjYW4gYmUgcHV0IHRvIG9mZmxpbmUgYW5kIHRoZW4NCmJyb3VnaHQgYmFj
ayB0byBvbmxpbmUgYWdhaW4uDQo=

