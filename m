Return-Path: <kvm+bounces-40914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7575EA5F07A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 11:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B4E519C0E0C
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561F5264626;
	Thu, 13 Mar 2025 10:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F965loSc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2ED1D54FE;
	Thu, 13 Mar 2025 10:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741861213; cv=fail; b=mJTRrsetcHN3/OCJ/h4bo7Abu5CWMAEjhvUAsEy0LGgvBrP/5KZFcpHHbtkBVJFTpNTrEMTq9dbjqnzO4J2BXMHFc7QCbw4CX3BPab2rTUSWgP8mc36Ov09RSUGXUiz0TzOHGlK1E+g+cESR2ghH+S9YFU6Ac1y1pvQEgZMZcak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741861213; c=relaxed/simple;
	bh=DSa+2zO/UOmOxFsABPye1PY84oUOcsGik6MTVCAJOIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YMLp73MCaSosw8Qks4RbPShSPMnIasTW7/BiVqidHPV3Kw84edCqb/9r4nohXyKV9R3384SR7kYOL1hvH92WjwPUqoAIcB4skB+NeM3qhOQWV2N33opQxwvbJg231IkveEaSky73lcbb07A9p59Z+GobAXQpxfKfQ5wN112F6j4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F965loSc; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741861212; x=1773397212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DSa+2zO/UOmOxFsABPye1PY84oUOcsGik6MTVCAJOIg=;
  b=F965loScKJg/7yjxMInBr0uwUpBo27P4NprsddZnI3hdwXmXy9SwCmV/
   NbRcdkVw56DvvfltLaG2nGftN1202RWHLIvdwyetONhdoqzLeem9AJAhc
   BHUkU734K5gKc6MdamVjMAXeZ8a8IvQV5osbCzQndaeBMaPfEAYrM+2XT
   QLphZ/VcBZ9IXUEDQg1OpNb798KRThU5csR00QG+Tk+nhPYvf+y1CLwEw
   oc0xz/0kpvLDWor5P61hsdrHmvRnMfxNZ/TdlwTn2dwdTOj5hIavIZNRi
   J9R9QyFb+f5K9AFe3cnItZ2r5oa5JIyNy1sBx/y9B5dOavIqSNFn6ur0N
   w==;
X-CSE-ConnectionGUID: FX5XZvlfQhSDrYAbgjWuBw==
X-CSE-MsgGUID: +/7Km3L/S9SyxEvDTVjMyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11371"; a="53964669"
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="53964669"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 03:20:11 -0700
X-CSE-ConnectionGUID: wur03GetRHi19tIfZ2us9A==
X-CSE-MsgGUID: wu1JLsf2T1iLqNgUKnwiEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="121834961"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 03:20:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 13 Mar 2025 03:20:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 13 Mar 2025 03:20:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 13 Mar 2025 03:20:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/fumayli35PYwMRKHJowE+5HDFUK/fpFKN6Toi0Lh60R6UQiNJbRtc9Aav2BSpEAFZvsVWJFikMi99k+zQXT+jOH1gJBKKbqy1uzB3JtijbBTNpowMcK89V0r9XZTiqu4YpVKqZR5R9RzFLjVkAVV85REBcAZ5oMH7v90BJCihYP0o4uNU1LEhznC3pLpqpN/eLY2XlMLq2hNkQ5tyXgUzPPBwNqIhaQ44ANdGjJhhBOFWZqrdhSCOoWfRRQ5lw0z86oX4Bd/WU62Sa4VZxFKWJ5zo+fE9taz8jBpDtOH4Oead/PV7V0Zc6v9qSDbiiu/6yEFR553Ql/82sJFXMtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSa+2zO/UOmOxFsABPye1PY84oUOcsGik6MTVCAJOIg=;
 b=GKJkrIKsIqfovqnAmfhOVAjnL2VkC69qPrKcB6x2HmdSVYa2r4/ChDFlMADTxcuxJ3cDc4NzPoq2pSfcijLySAURGKwc8XgP+ZFX0FNF4iYyZj2B1Ik7kCebMAeV5SRHWcMn3NPP0Hn8sp2YRutVbY+q0RQh24H6w6kw2ifbwtBNOGt2CJhLlfbYlr5o9SQuoeWgZ9uw7bPswaWonGrp6rhYbVX95aGfv/cWabcoml/ThoNLwzmsaVp0p2w0L9TsCQoNqbVsGhL4XI2lpfd2XjiuMPB1STDEKytvWp71DidnA79oXCsY66QvlbVDSZT/joaIfKXe1XAw1gQXXm6uAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7391.namprd11.prod.outlook.com (2603:10b6:610:151::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.28; Thu, 13 Mar
 2025 10:19:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 10:19:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "szy0127@sjtu.edu.cn" <szy0127@sjtu.edu.cn>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhang,
 Mingwei" <mizhang@google.com>, "kevinloughlin@google.com"
	<kevinloughlin@google.com>
Subject: Re: [PATCH 6/7] x86, lib: Add wbinvd and wbnoinvd helpers to target
 multiple CPUs
Thread-Topic: [PATCH 6/7] x86, lib: Add wbinvd and wbnoinvd helpers to target
 multiple CPUs
Thread-Index: AQHbiLqRbMPiVX/4v0Kvdt9cwB8TeLNw8V8A
Date: Thu, 13 Mar 2025 10:19:37 +0000
Message-ID: <fe6773324ed53b5b0df95bf816e4d7050a4d958e.camel@intel.com>
References: <20250227014858.3244505-1-seanjc@google.com>
	 <20250227014858.3244505-7-seanjc@google.com>
In-Reply-To: <20250227014858.3244505-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7391:EE_
x-ms-office365-filtering-correlation-id: aea2aaf6-4cfd-4964-5cf5-08dd62188f18
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?c2k4eTJSZVJncDNRT3hiYUd5WHQ0S2k4K1lPUll2eGQ2NVlhMXlWU1lvbDZt?=
 =?utf-8?B?bnlSakJPb0RoZEJxM2JCRC93NTFoYXgvOWY1M0I4SGN4VGpLYlRkU2RSSy83?=
 =?utf-8?B?K3Q5RGgvOVZnYVcyaUozMUhGWFNTcHRzL2F0NU5yZjBUVzRGOXJIS0xnODNl?=
 =?utf-8?B?Z0RCSGZLcStabnhtKzE3WnFCRnRpQVJOTVc4bWlXWkRKRFdOS0JjdHNxOGt0?=
 =?utf-8?B?UThyMW9JQ1hSZ0ZUbmFxZzhOd2Ftb2hDQlN1d1JUZC9kVmxvOVJvU01vTHdP?=
 =?utf-8?B?QWcwc3BNL2xBTmM0NjI3RndDQlNud3BlaFpaWmpVMUZVd0xLam5OanZtV3dt?=
 =?utf-8?B?L0JQdEdlMVhCVWNEZndlMWEvM2hld2NDeVpYNUlpM3VGZHN1eDFHZElnR1lr?=
 =?utf-8?B?eks0R2M3Y3F2RUhQbHRVRlJha3N0cEMyU05GSHpVZmppVjF3eGVXVzJNR2tW?=
 =?utf-8?B?WE45RlRiNE1xbE9FV2FNamJiVWtZZjB0NHg5a1VxUjFLdlhuUFVsdHNseXY1?=
 =?utf-8?B?SFhzM0UveDVWUDNpK1o5VGdXc1VIQVBYVUNDa0JzSUkydzRaV2l3WU5PMXpQ?=
 =?utf-8?B?OXAzOUJNenlkdEtoM0hLQnZvM2Q5QnNIbTBIaXI0K2p3WDZOa0c0V2xlL1hv?=
 =?utf-8?B?SnAyNWZkNnIrbUZPSVVpZnBXaTVpSFM5UXF1dFBLbmVqNW50WlJnaS91VVRI?=
 =?utf-8?B?REgwNlNMeTUwM3Fka1BCVzhXNkJLUTkyaXhJSEcxVXg1VFBnTExGWVJsZEtk?=
 =?utf-8?B?RFJKSUdUOGpLNnBLRTFwQXhhZUYwUmoyUjVvUU1EN0NqWCt5YmhiTjJkQStw?=
 =?utf-8?B?Q3I3b004RVBYNnJEUzRqRkRkb0REUlFBazJURkpNdklsSmVmY1RaU3ZqUUVQ?=
 =?utf-8?B?TG90U2RIbEdORjE0Zjl5UkhLQ05WYUg4MUV6WlptdU9Zd2Z6cWk2UXUybi9E?=
 =?utf-8?B?SWlxQmFSRnB3SERwMXhoN091R3AxN2VpUFdzSnBid2dRK0haWmpMbElTWE9s?=
 =?utf-8?B?YnQwM0w4NXhnL2NPcjljMWk0ZFUzMDc2eUhZS2tEOFNBUHVsRm9TdUJmaEtu?=
 =?utf-8?B?Z3U2ZXRXbUtOS3FhNk1IQkwySG5Vem1LejRuTitONVV3dlVHbmFEaDhETC9p?=
 =?utf-8?B?SHBtUHZVUmh2bkNVeWo1N3FQRFdLY01nejhxbGI0eUlLdjBuSzNkRlVZY1c0?=
 =?utf-8?B?WnluY2hxcjNiN2FDZE44YlE1RzIxalV4ZUQ5ajZjbCtPR2lGQzRuTVptUmxh?=
 =?utf-8?B?dlg2c1dKNk1ISUpHcGU0R1h0RDJGRnVUdEtYYVcvUFdPTUJsdjFJRy9XR0tx?=
 =?utf-8?B?d0NlV00rSDg4QTZhenlZWTVsR3ptbUg4aVZBVEwwbW8zc2NNUUxxZlFxZTVz?=
 =?utf-8?B?MEF6TFllNjdyMGdVS25nS09pVEFCbFk3WG5QRXdNTkFtcktSMnNZa01FYzRr?=
 =?utf-8?B?T0JuTVpJcjJWWXM5by8rK1k2d0lhaWJtQVZsT2h5ajBONzQvVmgraDgzNmJJ?=
 =?utf-8?B?dHVURk5vYmxvQ3RyTUlrTmoveXIyQzBqQWNXaXVLaStBSnBya0dDaTJ2RVJU?=
 =?utf-8?B?YXlpcUNEaDJBcVU1dGJidkI5QmwxYVdZZzBYdnNBYTVqR01MZ1plcFVKeXI5?=
 =?utf-8?B?VVptbkRkOHE2ODR0ZlBlRTFVRUU3K3NiaG9DZUFWdk5Ebmd1WFViVXBiV2t4?=
 =?utf-8?B?RDJWWStFWm9HTnFaemljaFJmRTVZajBoZHlQL3BDVi92TTZ0d2VkNkRJbWxh?=
 =?utf-8?B?Y0N4b3d0dEVuczcrNTVOT2ZTNzlRcGFwV3ZSMEVqOWRZZmhoRnhEMTB6MDhT?=
 =?utf-8?B?Wi91VnhYWXZadmZ2VEdYU2E5ckRXS0Y3S0NNZ2tvbllKRjd4Z0VoZUVjV2ox?=
 =?utf-8?B?RUcvV1VSdjJQdUZobW5lZ3U4N2dzZWloSUVvakg2ZVNvd2t3RGxvZnZXV3ZF?=
 =?utf-8?Q?HZvi4wYLlLznPq8Jseoxg+i4IgbbIqT/?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnUyZDRuclBtbmd3aXV0eDl1VkF0OHNjbFdGWmhCajdKVlJhUDR3UVkxeDhp?=
 =?utf-8?B?U2xxK1FQcWtHeVIrZ3AyTVkyMmRTNXp5YjNqem9GQ3FOR0RyVUE3WFNZSG5n?=
 =?utf-8?B?UG13TWQvTDJZMnZySzhENjJsblZkSEFMS09IOFFXY1pERm96OUUvdGo3TFk4?=
 =?utf-8?B?WmdGdUhjeVpTMXhGdnlqUjFwV3BXWnc1dDZ3bmhVaUwvOUQ4Rnk2M014eFZF?=
 =?utf-8?B?enUzZndsMnJXdGsyTFJOOVJQbStYNXBFckRDckpQV3RlTmhuRHoxZVFid1Z4?=
 =?utf-8?B?OU16OGF5SEJVSU0vNEp6UmRieHUxNTZiTHB1Q2dzMGZnTkVna2d4U1FpZ2Jq?=
 =?utf-8?B?eEFjUjZZK0dSMHlMV2xnVHA5THhrRW1tWjYxUDBvVW45NWFScHVZRVI4Q1po?=
 =?utf-8?B?V0UrUDhNdUpzVEdiNVhNaGcyZm5udmswanA5Um9GcDB6SzIyRXZuc1VZdGQy?=
 =?utf-8?B?MlRlakltQ3BKeHNiY0VvRWl1QlJOQTZkWUcxUWlOZklVMkhqNUJhTnhDQ0M4?=
 =?utf-8?B?K012N20reFNhR3BWLy9SbUNhNWVTNFlJWkY4Z1N6dFk2ekRRWEozMGhBaWlQ?=
 =?utf-8?B?eWhLUGRHR29ZZGlXSHZEb2RzYXhIb0ticnpHdDR5Sy9EbWtUYUdud2pZdTVw?=
 =?utf-8?B?NmJ4N0FXRWxNR204ZTVwRkN3V05RYklEVDI3U0p3c3Q4OUZOZmltdVBMaGhT?=
 =?utf-8?B?d0NkZ205NnIyTEdqOHRkMnJndGtCSHVrbTAxbllLT3kvRGcrQ25PSTlYcXQ2?=
 =?utf-8?B?Q3h4OXFHbktveXIvdGZsbytDbndGdWlacE9ZTGJoUEhybUVFbTMrTlc1ak5P?=
 =?utf-8?B?dVpQRE9oaEU5SUJxRlp6MlVmVXBvcDRJbGswVWo4SWZ0WjF1RTZVdUlqWGRk?=
 =?utf-8?B?RFpwNnBnSUJRcnhrSDJrZXJ5b1QzV3N2cjFFbmpFMWNMRGFpeml5YmhCU0ZW?=
 =?utf-8?B?cjdQcXN5MWY4Q3RLQWVtaldwV1BPanp3ZEJNd1hEM2FVSHdySGhOUDdSS3pD?=
 =?utf-8?B?Njl5d2FyRjZNZnhDYmk0UWhLeVZwTE9MM0FvOHJkRGhiV0tLeDJQdy85a08z?=
 =?utf-8?B?eFk4cUF6Y2tTRUJjaTNOOVpDYVNWZzN3cXRSbnFxMzZFeXMwMUdQalEwZ3VX?=
 =?utf-8?B?UEcyU1BqWnExbWlMS0RBbDNjSGxqNVdKSjZ5VkpzZFRVK1ROcE4rUGQ5R2ZL?=
 =?utf-8?B?aHRxbkl1Mll4S254eFl6RHlnbWZ3R3RpQzRqWnVFSHZnR0t4M3VPNURySVRy?=
 =?utf-8?B?NFBZVlR4NEVmZmVSbHFuS2ovVEdITEpxNTZnNGdtdURaRTBUYmhpRnJzQ3l2?=
 =?utf-8?B?RGxHQmREM3R5M0xISkpaNWJuVWZFZVFUNEo4VFhrTkpVUVZCaUZCNUFLdVda?=
 =?utf-8?B?S1BVQSsyS3psV2p4Y05EUFBhTG8wcFZiblRiSUIzTERRRGFsYmFXRnRjMWlD?=
 =?utf-8?B?aWs0QmwzbTdvSXRMbWowRHNkYzMrOFhiL2swSG9MZVdsd0YrL3V5b3MyZm9l?=
 =?utf-8?B?bnp2a2ZVdjRramJldi9MTDRKT3d2R3M3cTVGR1hQV0I0RTR4TytHNlRrbm9q?=
 =?utf-8?B?WVNiaWo3ak9YTC9KUjVTaHFnZ2wxNnNYNjh4Um1USjJnWThubzNhbC9BNXlU?=
 =?utf-8?B?bzVBY0NZWUZDU05CQW5MOXo1UlZWc2xCa2tuNm9QY3lEVHpZTDk2ekZqTXd1?=
 =?utf-8?B?am9YZXpFbFUra05rdzNIaDNJMEJib1NzaFZYcG9PK09VaVpWcTBSUWpvQU5F?=
 =?utf-8?B?ZWU1UG1LRGZEbWx1NzlIWXVvdzFqUGVJRFErYWZoVnpsVDdtZVZJS0hVY0cx?=
 =?utf-8?B?blJtVUdWTGlPbW95YXhHV0F0emZqVmNZcjZUYlJyTkJwSXhFM0g3ZkpXNjcw?=
 =?utf-8?B?U09jNVhxNTE1bmltdTBJS3dqZEJCQ0xXWGp1YVhpd3M0VzUzaTVPL1FtZW54?=
 =?utf-8?B?eHdkd3ExOEtLUi8rdzdYMytKWC9sYmFxNDMwOVRQemx6TXFPNVNjOHQ0TTFo?=
 =?utf-8?B?M3FNeEo1TEtWZWFTZE5yVkhVMWFVSzM0SVdlKzV1RzZhS3o5ckw2OVgzbzBT?=
 =?utf-8?B?TE15elBXUitIMlc1amllL0lkb2FBdWxnTnovRG4reFFnaDZGM2VlVGVJMVcr?=
 =?utf-8?Q?/V4syrkRO7IIi5DAV1f65Jdfv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01F316C173AA104498F2382A8C5A7350@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea2aaf6-4cfd-4964-5cf5-08dd62188f18
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2025 10:19:37.5828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BX0kZXEdLog54UpkI5CAgLnxSV+qxssHuo/Fw/dSfIsvBJjx071UluSqXhLnfNdaMq7rgJqZpJANYTd6gqFPWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7391
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAyLTI2IGF0IDE3OjQ4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBaaGV5dW4gU2hlbiA8c3p5MDEyN0BzanR1LmVkdS5jbj4NCj4gDQo+IEV4
dHJhY3QgS1ZNJ3Mgb3Blbi1jb2RlZCBjYWxscyB0byBkbyB3cml0ZWJhY2sgY2FjaGVzIG9uIG11
bHRpcGxlIENQVXMgdG8NCj4gY29tbW9uIGxpYnJhcnkgaGVscGVycyBmb3IgYm90aCBXQklOVkQg
YW5kIFdCTk9JTlZEIChLVk0gd2lsbCB1c2UgYm90aCkuDQo+IFB1dCB0aGUgb251cyBvbiB0aGUg
Y2FsbGVyIHRvIGNoZWNrIGZvciBhIG5vbi1lbXB0eSBtYXNrIHRvIHNpbXBsaWZ5IHRoZQ0KPiBT
TVA9biBpbXBsZW1lbnRhdGlvbiwgZS5nLiBzbyB0aGF0IGl0IGRvZXNuJ3QgbmVlZCB0byBjaGVj
ayB0aGF0IHRoZSBvbmUNCj4gYW5kIG9ubHkgQ1BVIGluIHRoZSBzeXN0ZW0gaXMgcHJlc2VudCBp
biB0aGUgbWFzay4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFpoZXl1biBTaGVuIDxzenkwMTI3QHNq
dHUuZWR1LmNuPg0KPiBSZXZpZXdlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lA
YW1kLmNvbT4NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDI1MDEyODAxNTM0
NS43OTI5LTItc3p5MDEyN0BzanR1LmVkdS5jbg0KPiBbc2VhbjogbW92ZSB0byBsaWIsIGFkZCBT
TVA9biBoZWxwZXJzLCBjbGFyaWZ5IHVzYWdlXQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlz
dG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KQXNzdW1lIHRoZSBpc3N1ZSBwb2ludGVk
IGJ5IFpoZXl1biB3aWxsIGJlIGFkZHJlc3NlZDoNCg0KQWNrZWQtYnk6IEthaSBIdWFuZyA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCg==

