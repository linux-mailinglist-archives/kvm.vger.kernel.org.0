Return-Path: <kvm+bounces-16537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E0E48BB39D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B57861F237FC
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 19:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B9B41C72;
	Fri,  3 May 2024 19:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CV0nML8S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D84819470;
	Fri,  3 May 2024 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714762994; cv=fail; b=cZsBV4KpyJQ6UWqJEFJqoBTvmhDomitSRyGWYZp5Sj998wpqxuF7mjTG9v2QfLVbJYbc1uX/NJmmv1bT26iGzjByFT+2lukhDReXAklpCahK585od6x9FxaX+lbOAoR06MNsTGkGtEaONRRcXLabFt+sL0fQZckbZEQNQeu8jdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714762994; c=relaxed/simple;
	bh=Eq0RawsEOb5bkUniPX0sS1beUERCMCPoqENBEe4BjWo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iylZtS1Rvz8RWhtCWV9I1iSY2kEOe/QD5OMWnzgsJPPRquIXoAH1kJzQCFLiMTM0dz+2DXZtLV+nB8VlhLwGeP2b5xXnePNtbp7G6fhYKoK8VjTwDPeIoi3BASEQToAwLWWKZFZBmWxmOqdhL3z8orbfGH5MY4f0E3nEQ8R/mpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CV0nML8S; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714762993; x=1746298993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Eq0RawsEOb5bkUniPX0sS1beUERCMCPoqENBEe4BjWo=;
  b=CV0nML8Sn2ZiJW5AYx3JLUa4XqiQ2OA66k/daQxAOjGL+yjXRr2mVyEw
   Idm5Ecrws23M4yHSDRuQ+HlxufG2lUUUHONUmj2BHu9Tn2N+8QMkJT0ls
   PGw80crKkeCqTUk1GZhxULeVzI+roqcHtY45N/zK3lQYtV6OTyFnEQNio
   7/SiDYakLso/aCiKYYyhMpMGEp0o5WivP5yrfqjzkOOnM1VM12X33/bY+
   hF0t1rNN+KICtsFK2KHPg7ZYR777IexCz3SdjYD3IT/VyNP/USLqmTNch
   Y7fcP1tYJu0ItEzTyHD0EOpAOZIx/l5dYcDxoCQcaac4V4gTL+nX0n4Pv
   g==;
X-CSE-ConnectionGUID: +Yny7pOuR/2aTr3sYLfwYQ==
X-CSE-MsgGUID: By8E1RMZSAqTrdLI5T75MA==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="10738517"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="10738517"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 12:03:12 -0700
X-CSE-ConnectionGUID: 5ZKZO7zsREGvVORf8XMh0A==
X-CSE-MsgGUID: A81qwOC+S6qlac4KGz0gJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="32030209"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 May 2024 12:03:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 12:03:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 12:03:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 3 May 2024 12:03:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 3 May 2024 12:03:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpVBvsv6jJhVMAC6n4QoVQbDIFK871IOK5aLd6oW5zyjSrhdG1u71Q7gpDqFE+xoH/imMTCJFGbaFAp5tDvOlupBaCrk+5nqkmLH8Nrh2tCxnMoe5ZzPgyLyOeoMfTP0gtKu+GQ8LhgX8VMo9SZLnG9R+MUiy1SIO+TGdvWpCXyvAt/52fSp3FL5GSscAh5xsJ8Ib96M4J3046a6fL6LEz2hBPQosgu86DGl9L5Ow2hsZV0UjuGUfuZMgmvnQx3X8pKO5OtXQ4/BWIvm8fPIDCPdJhJC2RnCA1Ifcr9K6Any+9dIVhILac51lE69qu0I3O3bzE1ucRlAaNq0blGvyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eq0RawsEOb5bkUniPX0sS1beUERCMCPoqENBEe4BjWo=;
 b=WnTG5TcxeH8B0RnHMmb9HPhc++uP2V/6tKDxxS7nQc9kDR/0gs11FenyjVgOgNtJSWooRDod5csBibH4BSZbeaWfuQGHmSXe5xfakSnDDH6Pf9CpNAYmzpu+52OTsdalKaqMIsaFVNEBJ/UCmMorKoDtBKDT+kuB7xX5nLX1C5I+LjveE+jSQgu9Qsyk/PhIYAGIFz+TabIs84LUPBG7HUciLOzbduFX12NQO2WplEQfcLmtqe1voVg7Pv3LVAAZ8Zv3HtPLqGxTZ7ufpVCc3FIMKXkEvDgQGqdagnvpMi6kPTqEZ+GWPlX3yqYxJ/ciE4zT9fQUOq5VXPOExzwFEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6514.namprd11.prod.outlook.com (2603:10b6:208:3a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 3 May
 2024 19:03:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 19:03:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 3/5] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Topic: [PATCH 3/5] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Thread-Index: AQHanO1KbxcU5bsJu0u2fcnRk1NAs7GEo1kAgAALCoCAATDJgA==
Date: Fri, 3 May 2024 19:03:00 +0000
Message-ID: <18f5114bd700f13fac5b36bd322745cb2ea2ab15.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <393931ee1d8f0dfb199b3e81aa660f2af0351129.1709288433.git.kai.huang@intel.com>
	 <ebc3ef050ce889980c46275dac9eb21ab7289b8a.camel@intel.com>
	 <6940c326-bfca-4c67-badf-ab5c086bf492@intel.com>
In-Reply-To: <6940c326-bfca-4c67-badf-ab5c086bf492@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6514:EE_
x-ms-office365-filtering-correlation-id: 09bf0bc7-4ce1-45c9-9060-08dc6ba3a71d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WXBRTmF1RWlNdVNLOWU4WkdmWnJNT1RaN3BVVkk0VGJSQlQ0WjdNR2pLVVU2?=
 =?utf-8?B?WWhZR092N3d3d2tqOG5NaEZuVytQYld5cVhuS3FHamExVGdTY1UvWmhSOHlH?=
 =?utf-8?B?NGIzcDh6VkNGSFM2dm1WTTBacmhHTEdQUEhSTExFSDJLakVFbWRZR0hKaktE?=
 =?utf-8?B?ZFd1RXc0c2g0UmJ1QmFFaXFiS1VFc2FPYjVHZU1Eam1OZWorUUpBaTZxM2Fm?=
 =?utf-8?B?QTd1Rnk4RDQvTlpINk5DSHVhQWFWMDMvcU5KM1pZSFBLajVTdi9Bck9NamN0?=
 =?utf-8?B?VXNSbFo3RTZYbnlMTmNiNzBlMERxVXdYdkN3emh3b0FFK2V3TU15bXp0aEpU?=
 =?utf-8?B?M1VVMEhQQ3dBc1NrV2krY3l0K2lLOHJWd2c4VjNZRm1aWG9VTUdnOUZXc0Zz?=
 =?utf-8?B?UmNsQ3g2bTMxSmM1MDRJR1hGTkhqMUtKdjk3MmpOcTVlcjNtZDNWdGxGbE92?=
 =?utf-8?B?Sk5UK2pFK0k5VXozSm1iSXF3ZjQrNTZNbUh4cUJkbWFES3luRks1ZjVQTjB1?=
 =?utf-8?B?K09TYVc2M05EMnRPSnNrK1IzYzJaajBuNGw5RXRIVnp3Mzk0NENDWktYOE9B?=
 =?utf-8?B?QkdrUnEwRGJjcDlqVXlWUm15dVpVdHlRTG5rWUF3aTFjaE1xZ2kxK0RadkY2?=
 =?utf-8?B?UGVtWDI3U0VtNDJPalE2TnhCRHJDd1BSQjBiUUNRMGVNazFUTjV2K200Q1JS?=
 =?utf-8?B?K1BET0EvNGkxKzlWeUEwR3Q1V1lETnk1OTRzcDQ5VE5sSy9jZFE4S1FLalZR?=
 =?utf-8?B?VVRtM2x5UVJ5SzZvTjE3dDU4ZG1qRHlneWMwT05kdjZwMi9hdzF2T0wrWUVE?=
 =?utf-8?B?dk15V3BqR09KSG9tWlRGZ0xqelNmMWtKTXFmWkcvVGRYV3A3QjBtcWg5d0tv?=
 =?utf-8?B?OTI4cUVQTFNrN0piM0w3eUJDYzhuelZMZzIrcG1DUnczL1prWWQ1Y2NCOHl2?=
 =?utf-8?B?Rzc5S08vK2llSUh0RERNZDBackVwSXdmcXptS3prOGwrOTVFZCtnM09HVnVB?=
 =?utf-8?B?eUJRSy9QalVrUkkvMDZuaSswU0IzaC81a2E1Nk95T0VFZXEvaE1ITWF1OGRv?=
 =?utf-8?B?RWxlK25wVStNMWhuSUkvS2VOcE9EU2tnUWxDMWNrZGFGc2FjaExDSk8rTC9C?=
 =?utf-8?B?SHVlWDhSRXIwVk1DVkJ0bXR4RTlQUEFISmlYVStsbml4ejJwaHljNERQaWw4?=
 =?utf-8?B?S1V5SS9JSkFXTm5PNHRlN0NBWk9QWjM3N0pjaEk4Z1F4ZHV3a0NCMXc3dGNS?=
 =?utf-8?B?QVhnYnpMdVNpajVTV1BpUk5mVWFydTgwdm1zVzg4aHZ3Q2tQQUo3RGk3UTBz?=
 =?utf-8?B?eDgyNmk5MDE2bXdXQUdFSEFNTzIxTWRKRVUweWVNbGNCRm0zSG1xN0tCWXdE?=
 =?utf-8?B?M1NrYTJiWnhodzhWZ3pYRlRFN0o5cVdWelYxKy9qZE16bS9jVWtMcTQwV0xF?=
 =?utf-8?B?YWZ5ZzluY1VURm5QMlVsRm1qV1l6SVlpYXZXVGsyYm5GVU1RQnQrbjFxTkFk?=
 =?utf-8?B?NDliNFBpQXptdVl5MGNIL2dFaEkrK2s1VmN1aWJoVHdkTHhTdW5PSlhEREth?=
 =?utf-8?B?NmNJdWRJa2dxd1RlcDBkdC92MStXdlFyNWhTb3J0V1BlRG13QngvNzlyeEN2?=
 =?utf-8?B?S2JFRkRQTzdHY09tM09ObVQ4S0t5UGxjTTZjMHRnK0ZDWHJsRXNaRUQyRGpV?=
 =?utf-8?B?TTBaNytEcDdzOFhpU0JaUlN3UWMvMEw0aEVrQ3p5QTBjY3RHaloyVnpKWWdK?=
 =?utf-8?B?eXcxVGk1R3VYN0w2blVEWjdqTUJQaUNORmdSNyttT0NXQTJBU2JVM01TR00w?=
 =?utf-8?B?eUI0TC9WbHZKc2pXY2U5dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3JRejRYZnhNaWkyUFFFMWFnLzJzN1NmOXVUTWRFZnZtM0tUaDlBN1ZIM0JD?=
 =?utf-8?B?YkU4aExYRjJ1dWIxbVF1RUg5dE1UZFhMNytoWXFSWTlOTjVUSlpiaEV0Yk8w?=
 =?utf-8?B?MjhSUERVOGlPN3VhdnNmbVhPcjkrQXh2MCsvYlo2MlpoUElVZStJUkJEeCtL?=
 =?utf-8?B?NmpXQ0d3RWpTRDJXMXNpamdRZ3IybWNwMUFpYnIvQTZjKzVrOHk3dUJ0MmNk?=
 =?utf-8?B?cGE1QWdRSkhJL1JJeWZEQ2cxZld6bS9zUHpJOVp6ODdZZFRFb0hHYytxd1Bo?=
 =?utf-8?B?L2ZFaG5uT1d4WGdZWTdDcFRtV25QQ3YycndEcUxuY1cyK1ZDYVF2V1ZML0hU?=
 =?utf-8?B?a08wVXN4cmVTZ0VBVVJ6TmtQNWg5aE5ua1A3NDl5alVCTTJpV1ZJSXZFSkMx?=
 =?utf-8?B?TlhGTmowcDBGVzlRemJ1b2svSTZVUHZkSlJ0bW9SOWdyVllzMmNqRGJjbUhm?=
 =?utf-8?B?eG5XemZsL0JKN29MZTRrMkFGRHhDNzFKWmpqTnpQdk9QODVLaXNxUGhER28r?=
 =?utf-8?B?WHIwaHMxTThzMGsxVDlabUFoVW9zS0Q3V09MbUtYbWxIeGZ1UzN0ZlpWRmkv?=
 =?utf-8?B?anR0QUZpOGt2R05IaTdCUDJRS21ZN0xmVllKVC80d2xaYVRDc1pMK2ptcnh0?=
 =?utf-8?B?eFJKTEg4Q1ZiMDUvZDB4NXJ6OGMrYnJJcnczTWI4RW5qNzN3eHJhOHRxK2Jl?=
 =?utf-8?B?dWM1Rkx5RStTNUtUTkl1UVd1Ti8rODNPVjJkN0lmMFp1eG1NaU9sR2VwZk5H?=
 =?utf-8?B?Q3hQUVF4NWxKNTc0VVNsb2xNNWdDWlVTNXRjaGYwQmtqRUtDNEovaTV6NnFM?=
 =?utf-8?B?cjQ1SkdFV0NzWWltRXFKUmdwY0dNdGYyQzdjc2lKQnBDWnBJdFNHU0V6WkZO?=
 =?utf-8?B?Qk51ZXNMenMxdDhEZXIwZGUrK3I2SktibkxVMTNjQVdNVHdyenBSckN4WmtU?=
 =?utf-8?B?WjZka0NpclVFWkI5V0Zta1VUTjZ6alFDSmZKVWtlV21aWW5pZ2pZZ0ZKVzZP?=
 =?utf-8?B?dWVDemRZVk1uTFlZWTRsK3pIVWJacGtNZ0YzRHlna0R3dnB2Q1lGQm40YUJz?=
 =?utf-8?B?WmhYSlpRWTVXK3paVkp5Z2IzWU5WRkFpc0ZqQkdMSVBtSGZuTDRtOG95U2c5?=
 =?utf-8?B?SmRDK0pNL1NMVDgzcU9adkMrdGF3Y0VIMnpnTzF3bnB4Um5KeTZXV3BEbjRU?=
 =?utf-8?B?KzR3UStHQkdMclhuemIwOHI4RGFHaTRUMmRMRENXeUxtdllTb1MrY2pqeGk4?=
 =?utf-8?B?SE1VRmdwYWpiRnNCS2FnRXU4REFwNmpvVTZsZmdlVXh0ZkZ0QWhSSFQxOHNV?=
 =?utf-8?B?N255SkgzQUZaU1dIZVpGY3N5ZjRwV2V2czEzOUt0OGhQOFhhWlovWjJraXBk?=
 =?utf-8?B?RmlNaWhNcEVoY2FnUVlQTFk3bmdPQjdmWXBkVDJZOEo5anFOMTVaZkV3TGVq?=
 =?utf-8?B?ZmdRdEh4ZVlvOU5WTW1NdklRcWhzVG5OZGU2K3lyRWVtb2xUaU50RVRRc2pG?=
 =?utf-8?B?N21wK205cW5rRVpDdzFLTnFsOExWOWNwMitZWEJQaGc1ZG1hQ29UTmZ6TEF4?=
 =?utf-8?B?bGNUei8vK0ZuR0RBM1k5Q05sR2VhdUM1VUU3VFU1emthSU5nMlM0VGlhTjNz?=
 =?utf-8?B?RHRiYTBiRm4zeFh6S1plY0ZheDE1bkZET1h2R0lFVis5K1h4LzFiRUFlWlND?=
 =?utf-8?B?azIrQ2luMW15SVhHR3I1OWJoVDE4R3lYYnhmT1piSDRnUlF0MTRXQm0wN1BG?=
 =?utf-8?B?QS9PQjl5SU14YTE5QTJWQzBnelJEOUNPRFQ1dTc4dkIyMm9QWjJEMWF5K214?=
 =?utf-8?B?TVB5QkFqYmh6TmdrK1JhLzltcWE4RXdkcmxSdWkrdHZPbGJoMXJoUGRBelk5?=
 =?utf-8?B?L1dxK3J5Z0JkQi9vemNVdlIycVpBRTE4L1J2SE11WkdUeGQ2cGJBdHdvNlI0?=
 =?utf-8?B?OWxuNjdFZkZOSWpyVlNhR3pwcTU0Ti83SFdURWUxT0lJaE8vZDVsd2FVcmc5?=
 =?utf-8?B?ZUtCcC81WTNldDNHbUxLMDczcmxnTzFlZ3poYkhiM0VTY21jeUhNdXdmanpK?=
 =?utf-8?B?N2RUeUZ0eVFDdWt3OFMvUXA4d3QrbTg0VW5IOHZxMzR1UGZhanQ3MjdSQTRF?=
 =?utf-8?B?MldzdThRVGhSa0RidkROYzBaTU5DYTk5eXJSY25YZjFZd0hDTXMxR3EvVSt1?=
 =?utf-8?Q?1Zu4StyPAnTu2pxsl/ZTy9M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F52F1430177F1478D7F837E8E395A2B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09bf0bc7-4ce1-45c9-9060-08dc6ba3a71d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 19:03:00.6820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pa7sKtob/WwJFiZ/l8rrPHl4/IeubRMbq0C2luQIaYv4dpWHHWY3xAEtm7rW8wuBgWkAfDt+4jZrYm0zrTbGBzLhMUgWL1zbhCweuM/3Q0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6514
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDEyOjUyICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAi
DQo+IFRoZSBtZXRhZGF0YSByZWFkaW5nIGNvZGUgdXNlcyB0aGUgVERfU1lTSU5GT19NQVAoKSBt
YWNybyB0byBkZXNjcmliZSANCj4gdGhlIG1hcHBpbmcgYmV0d2VlbiB0aGUgbWV0YWRhdGEgZmll
bGRzIGFuZCB0aGUgbWVtYmVycyBvZiB0aGUgJ3N0cnVjdCANCj4gdGR4X3RkbXJfc3lzaW5mbycu
wqAgSS5lLiwgaXQgaGFyZC1jb2RlcyB0aGUgJ3N0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvJyANCj4g
aW5zaWRlIHRoZSBtYWNyby4NCg0KSG93IGFib3V0Og0KDQpUaGUgVERYIG1vZHVsZSBpbml0aWFs
aXphdGlvbiBjb2RlIGN1cnJlbnRseSB1c2VzIHRoZSBtZXRhZGF0YSByZWFkaW5nDQppbmZyYXN0
cnVjdHVyZSB0byByZWFkIHNldmVyYWwgVERYIG1vZHVsZSBmaWVsZHMsIGFuZCBwb3B1bGF0ZSB0
aGVtIGFsbCBpbnRvIHRoZQ0Kc2FtZSBrZXJuZWwgZGVmaW5lZCBzdHJ1Y3QsICJzdHJ1Y3QgdGR4
X3RkbXJfc3lzaW5mbyIuIFNvIHRoZSBoZWxwZXIgbWFjcm9zIGZvcg0KbWFyc2hhbGluZyB0aGUg
ZGF0YSBmcm9tIHRoZSBURFggbW9kdWxlIGludG8gdGhlIHN0cnVjdCBmaWVsZHMgaGFyZGNvZGUg
dGhhdA0Kc3RydWN0IG5hbWUuDQoNCj4gDQo+IEFzIHBhcnQgb2YgdW5iaW5kaW5nIG1ldGFkYXRh
IHJlYWQgd2l0aCAnc3RydWN0IHRkeF90ZG1yX3N5c2luZm8nLCB0aGUgDQo+IFREX1NZU0lORk9f
TUFQKCkgbWFjcm8gbmVlZHMgdG8gYmUgY2hhbmdlZCB0byBhZGRpdGlvbmFsbHkgdGFrZSB0aGUg
DQo+IHN0cnVjdHVyZSBhcyBhcmd1bWVudCBzbyBpdCBjYW4gYWNjZXB0IGFueSBzdHJ1Y3R1cmUu
wqAgVGhhdCB3b3VsZCBtYWtlIA0KPiB0aGUgY3VycmVudCBjb2RlIHRvIHJlYWQgVERNUiByZWxh
dGVkIG1ldGFkYXRhIGZpZWxkcyBsb25nZXIgaWYgdXNpbmcgDQo+IFREX1NZU0lORk9fTUFQKCkg
ZGlyZWN0bHkuDQoNCkZ1dHVyZSBjaGFuZ2VzIHdpbGwgYWxsb3cgZm9yIG90aGVyIHR5cGVzIG9m
IG1ldGFkYXRhIHRvIGJlIHJlYWQsIHRoYXQgZG9uJ3QNCm1ha2Ugc2Vuc2UgdG8gcG9wdWxhdGUg
dG8gdGhhdCBzcGVjaWZpYyBzdHJ1Y3QuIFRvIGFjY29tbW9kYXRlIHRoaXMgdGhlIGRhdGENCm1h
cnNoYWxpbmcgbWFjcm8sIFREX1NZU0lORk9fTUFQLCB3aWxsIGJlIGV4dGVuZGVkIHRvIHRha2Ug
ZGlmZmVyZW50IHN0cnVjdHMuDQpVbmZvcnR1bmF0ZWx5LCBpdCB3aWxsIHJlc3VsdCBpbiB0aGUg
dXNhZ2Ugb2YgVERfU1lTSU5GT19NQVAgZm9yIHBvcHVsYXRpbmcNCnN0cnVjdCB0ZHhfdGRtcl9z
eXNpbmZvIHRvIGNoYW5nZSB0by4uLiBbc29tZSB1bmRlc2lyYWJsZSBzaXR1YXRpb25dLg0KDQpR
dWVzdGlvbiBmb3IgeW91Og0KSXMgdGhpcyBqdXN0IHRvIG1ha2UgaXQgc2hvcnRlciwgb3IgdG8g
YXZvaWQgZHVwbGljYXRpb24gb2Ygc3BlY2lmeWluZyB0aGUNCnN0cnVjdCBuYW1lPyBMaWtlIGlz
IGl0IGEgbWl0aWdhdGlvbiBmb3IgZXhjZWVkaW5nIDgwIGNoYXJzIG9yIDEwMD8NCg0KPiANCj4g
RGVmaW5lIGEgd3JhcHBlciBtYWNybyBmb3IgcmVhZGluZyBURE1SIHJlbGF0ZWQgbWV0YWRhdGEg
ZmllbGRzIHRvIG1ha2UgDQo+IHRoZSBjb2RlIHNob3J0ZXIuDQo+ICINCj4gDQo+IEJ5IHR5cGlu
ZywgaXQgcmVtaW5kcyBtZSB0aGF0IEkga2luZGEgbmVlZCB0byBsZWFybiBob3cgdG8gc2VwYXJh
dGUgdGhlIA0KPiAiaGlnaCBsZXZlbCBkZXNpZ24iIHZzICJsb3cgbGV2ZWwgaW1wbGVtZW50YXRp
b24gZGV0YWlscyIuwqAgSSB0aGluayB0aGUgDQo+IGxhdHRlciBjYW4gYmUgc2VlbiBlYXNpbHkg
aW4gdGhlIGNvZGUsIGFuZCBwcm9iYWJseSBjYW4gYmUgYXZvaWRlZCBpbiANCj4gdGhlIGNoYW5n
ZWxvZy4NCg0KRXNwZWNpYWxseSBmb3IgVERYIHdpdGggYWxsIGl0J3MgY29tcGxleGl0eSBhbmQg
YWNyb255bXMgSSB0aGluayBpdCBoZWxwcyB0bw0KZXhwbGFpbiBpbiBzaW1wbGUgdGVybXMuIExp
a2UgaW1hZ2luZSBpZiBzb21lb25lIHdhcyB3b3JraW5nIGF0IHRoZWlyIGNvbXB1dGVyDQphbmQg
eW91IHRhcHBlZCBvbiB0aGVpciBzaG91bGRlciwgaG93IHdvdWxkIHlvdSBpbnRyb2R1Y2UgdGhp
cyBjaGFuZ2U/IElmIHlvdQ0Kc3RhcnQgd2l0aCAiVERNUiByZWxhdGVkIGdsb2JhbCBtZXRhZGF0
YSBmaWVsZHMiIGFuZCAic3RydWN0IHRkeF90ZG1yX3N5c2luZm8iDQp0aGV5IGFyZSBnb2luZyB0
byBoYXZlIHRvIHN0cnVnZ2xlIHRvIGNvbnRleHQgc3dpdGNoIGludG8gaXQuDQoNCkZvciBlYWNo
IHBhdGNoLCBpZiB0aGUgY29ubmVjdGlvbiBpcyBub3QgY2xlYXIsIGVhc2UgdGhlbSBpbnRvIGl0
LiBPZiBjb3Vyc2UNCmV2ZXJ5b25lIGhhcyB0aGUgZGlmZmVyZW50IHByZWZlcmVuY2VzLCBzbyBZ
TU1WLiBCdXQgZXNwZWNpYWxseSB0aGUgdGlwIGZvbGtzDQpzZWVtIHRvIGFwcHJlY2lhdGUgaXQu
DQoNCj4gDQo+IEkgYW0gbm90IHN1cmUgd2hldGhlciBhZGRpbmcgdGhlIFREX1NZU0lORk9fTUFQ
X1RETVJfSU5GTygpIG1hY3JvIGJlbG9uZyANCj4gdG8gd2hpY2ggY2F0ZWdvcnksIGVzcGVjaWFs
bHkgd2hlbiBJIG5lZWRlZCBhIGxvdCB0ZXh0IHRvIGp1c3RpZnkgdGhpcyANCj4gY2hhbmdlICh0
aHVzIEkgd29uZGVyIHdoZXRoZXIgaXQgaXMgd29ydGggdG8gZG8pLg0KPiANCj4gT3IgYW55IHNo
b3J0ZXIgdmVyc2lvbiB0aGF0IHlvdSBjYW4gc3VnZ2VzdD8NCj4gDQoNCkkgZG9uJ3QgdGhpbmsg
aXQgaXMgdG9vIGxvbmcuDQo=

