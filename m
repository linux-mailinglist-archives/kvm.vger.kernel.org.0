Return-Path: <kvm+bounces-30117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EB5A9B6FE8
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 23:38:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1CD71F21F7E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F7221503D;
	Wed, 30 Oct 2024 22:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cYv4TlFJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472BA1D356C;
	Wed, 30 Oct 2024 22:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730327921; cv=fail; b=NPnLaxhtxcrOvM/eFFkhYtOWNWGmTwx4Uu+70LADz13qD9FP2WFjSpgJxy3XPTiTnKVr/62uYvMZixyb3Ri9o1UP3Ep8cyu5Qq5nixm3aN1yTdu1nX+7nr4kmTjZ23EHwBRmWGmsGAVuheiYWrvEWvg3C5W80W5Wt0+H+SHf41U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730327921; c=relaxed/simple;
	bh=lgS4Oyb5kqDddIP1QpWBev+/gRplqs3iSKzt+M1UpmU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rcm3p8URniuLRFcQ7VzpDLaficln0R+cJdx3Wx0exWstH+Ex+bd3PWPJcPia2oqTHHIkPrQQXRiDugl1gm8dJMllQVz59qoZCXui91uJfmVeay4Qj2OcPEfKOTai2pr5ZHD54r622S96T87z4SsnExAJH/cUKGcsA+Z5jRgFJng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cYv4TlFJ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730327919; x=1761863919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lgS4Oyb5kqDddIP1QpWBev+/gRplqs3iSKzt+M1UpmU=;
  b=cYv4TlFJ/v7AogdhXmA2PPJTsTdbR/77vemTkwskMS9wiNsL0PfgrJR8
   aiZd0rtLzFTKJzYgyfrp2456j52GraX9fHxAcplbH/gB1EF7Rt0Aii+A1
   JrU9u1UEYM5r1+1Rx7p0ZZTB4gGSh01uy8xk/wXqtVGzlkIhBhOCwhILO
   bAel0LPDVXw6KwYOqTbqcuGtXaEfmpsqIXg+Y3xw2WVhr4VFPCTeQw452
   ALEf8o9XMT5kgMLvbv5iQ7ivOWi3qbVy5I/DAv8LOGws3a3zRTQSiCQim
   86nTK7ukbYh3ulgWdWloFrk1o81fUpb+o0/N9Mwkgi+ZZq/bY8N+inEpU
   w==;
X-CSE-ConnectionGUID: HOgy1pCXRgumbfbBtj7Ndw==
X-CSE-MsgGUID: fvGkFwujQFOuueHsTec19Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="30266138"
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="30266138"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 15:38:37 -0700
X-CSE-ConnectionGUID: kUq4gvG+SXCEILZ1+PGZGA==
X-CSE-MsgGUID: SbGFnSrYSXSqJ8S8K69GFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="105774932"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2024 15:38:37 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 30 Oct 2024 15:38:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 30 Oct 2024 15:38:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 30 Oct 2024 15:38:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JmlPnMgd1+aG/3uEXAkIQXbLTeI4BkZLBn2Pb5Yyi3nqbzewZnw+4f1UIYLpSdm0t6SglTHDe7H0mSh+Dy+cpS4xuTAbbMuTQQc2Gvn+aMl1ANIMMTiXqCfUFinh+CoG3omY20UCu0DdwnE+BfsLm4m67Zi1Ef9RVmqi05cbYIuaYJ+G9qdkhuz3bJ8oJ0vbSap9Jk6o0QaWVCQ/z2HGpJof0TuX/7vOWUrMRtJQnlDPHHInlgalrqIRTmJGKjI89DRzMm3ldLaCqPeEloE9/x5fSQ2cDPrSAPZCqk12B61/VaBV0kbNtRIYCOoyQ/pQIkwrE0mjkJyu7YsPWs/rIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgS4Oyb5kqDddIP1QpWBev+/gRplqs3iSKzt+M1UpmU=;
 b=c8MpnXj2N3MDz8Yj3uS+oPi2TCq+BG79mtz6HJoiEf8T6J1eAZqWpz1Wm7ULjH1Yrh7Ds1nU3LT9m/Hi90wwAtVqdbkCbG4NQw9WL0atEGHJOWeNZ1vGwrq12lQCrjSK/tOjfk6MseaVVjKVvJdgJLsWD8ciuXEdZYCd2Ce2uChqZae2gnBlHXVNAb/4xVJ4uTyxCXJQlVdgJ5a4vl5TLI+VLTmu/VbSHo8wDZmpM2ZZFuQ7uVxMD9cmS0AM4yMFuNS4rUX3T2QNLkA/glp3eIX3hjGtzYZOfzEdJI3FX99m6/banASISSmipOlCTviKM1JiPiYEnLTdiKC+9xDOLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4696.namprd11.prod.outlook.com (2603:10b6:208:26d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.18; Wed, 30 Oct
 2024 22:38:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 22:38:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 12/25] KVM: TDX: Define TDX architectural definitions
Thread-Topic: [PATCH v2 12/25] KVM: TDX: Define TDX architectural definitions
Thread-Index: AQHbKv4rkwOWaJyVUkmgVUvire2auLKf4ueA
Date: Wed, 30 Oct 2024 22:38:33 +0000
Message-ID: <25bf543723a176bf910f27ede288f3d20f20aed1.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-13-rick.p.edgecombe@intel.com>
In-Reply-To: <20241030190039.77971-13-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4696:EE_
x-ms-office365-filtering-correlation-id: f33349ef-7518-40c1-5b70-08dcf933964e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S1BrWnFBZXd1NEtzS05zRGs5NDJzRVdBcmdueW5WM3JITnMyRU9mZmF4SnVT?=
 =?utf-8?B?MDNZNFV0cVQzekxJUk1pN3Nhc0ZrUzdQZkdZL0M5cFpDaGRVT0tBRStiUnBU?=
 =?utf-8?B?U09oaTdieGlKS2VwZzBkc0Q3SjdXVE4rSk1tQUQ2NUhsVHdwNjd2WWVBcjFl?=
 =?utf-8?B?NHZTeXlZRVZndGovdHd1c3FVK1UvUXl1bnlVUk5aeXpQUWxlYnNyL010ZURF?=
 =?utf-8?B?aUhsL25kWG1HQmdmNGZoRnJ4c3ZCRGJNUTRUN0RxZ2lBbmFlcmxVcERaMXNM?=
 =?utf-8?B?RmYzWmFLRURrNFFrSHAvdm9EZlg0MDd0RU1wRDdVRFpId0tDU2hVa0tUajJL?=
 =?utf-8?B?LzVLdmZyU1FhWE9yRHFXSlNYSzRSbitZQ2p1QmM3VE1MZEVhQkpYV3hzQTJW?=
 =?utf-8?B?bDRoVWZsc202K2N0Tng2WldnWEtVaXp6UGVQby8yTW5sOGRwcGhVYnR0M1hy?=
 =?utf-8?B?TERVa3B4RnRISHFESVRGRDZmMEJyMlFSZ0hXUEQ0MVgzdEw2OE95Z1gwYUNB?=
 =?utf-8?B?ZkJFMkRnUEp0UERVWno2ajJUak1TVkVodGgyTlRLU284Wk9aME90UVFmb3JB?=
 =?utf-8?B?WDlvUy9rY3lDc3FOU0hrdkN5N1h0blBSZVE1K2N3RlVjckFjOVhqMkxSUktn?=
 =?utf-8?B?RE9qTE9YcWhXaDdjZ25NbFhKYlRqY293V0hiUURVaFZwYmhOTkZ2bmdvV2Rq?=
 =?utf-8?B?YndrV3NlNHNMa0JHN3B4KytoR0tuQ21nSEdHaGNqM1I0aS9PSmloeWZJNE92?=
 =?utf-8?B?dytmdEtLdWQ0OEVsQ3ZUQlVmQ1pyaEVXWVMzUWxVc09TVnorR1RSQXVETHVs?=
 =?utf-8?B?cUR2ZTgwMnBOU1ViMG93Si83U0E3clpPZjgzc1pXZlZPZVBCa3RQTjBjR1l6?=
 =?utf-8?B?cFkrM01vVnd0OTJIdkFiWGNjRjRBYndoS0IyQ2xWb1JNQUlTMXNiUjlWUTFO?=
 =?utf-8?B?bFFqVkRUTTFZSS96NTJhM2NmRFozZENWdk4wWElEOGh4RVpzTHoyT3lBcXk3?=
 =?utf-8?B?b0Mvc0dPeWZXMzU5aFc3TjdSZTBVTlRadkFyQVdLYWxrM1J0Qm1DS2FFZkls?=
 =?utf-8?B?VVduWXd3RVI1WUpka2pjcHdreDNjM2JENGc2WDRLNnIrOGlja2VGaXFCQVZC?=
 =?utf-8?B?Zk0zNlg0WDFydU80V040dm9ndGtERjcrdG50b0tXR3FWVzNZVy9LK3JPU0pP?=
 =?utf-8?B?aXFxaEVIUlFHeUZ0NmxvOHZEL2VUSGkvWHNqZ0ptSVpHenByc0lIKzExT2dm?=
 =?utf-8?B?UldzYzBKT2R0YzJQNXdlWEJrZ0pLd2NOOFVjQVJPdDhxeDdCd3dNYlh4enhD?=
 =?utf-8?B?UFBUQVVoUHhuOVRzZlo4czl0QjNmSDM0Z1BoODVVRm1XRHNSblhPRXIrVnFa?=
 =?utf-8?B?bzl1cXBOWkI3REZqZi9leWZqMnF5dUV1Y3NKY1JyNWdBMjlMYTlKTldGQkRJ?=
 =?utf-8?B?K3hTK3pnZGpYbFBTK3lqbUxMbzJTWXd3U1VNcHM1QXU4YzFXeTk0cng1a2s5?=
 =?utf-8?B?N2FYY1hieWJLdVlzSU5jampjL2xCNnk5dG11N1ppVCtPdGlQaTV5c1dxVWJ3?=
 =?utf-8?B?d3BqV3BWUktMUjhTQ0dxT1pDbHlVamhUYS9LeXVJZjJZTHYyTENrWStmUGZG?=
 =?utf-8?B?Y2RXc2JUVXpJcmh6dVEzRklqWnF4TC9UT0xLZG0rOThtWlBwaXZtQUkrMWh0?=
 =?utf-8?B?M2ZtUDgvTHVNelpUOHBBUWN1TENZSXV5NkdYL0NlSk5GdjZqdE9CR3BLbTR6?=
 =?utf-8?B?cTgvSjFVRFZSWjBMRWNHMVluNGJsK3JJdlY3QVdNUjFuSXp0dGo4UGFET0xm?=
 =?utf-8?Q?30VQegNXwprBXdc3D5LC7KnvuRgusZQeoEuLE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUV6bmk4YVBQbnUyWDJKK0E5QXhoUjMxWTFUNXNQMGVHcTNvN3JOUG1VSmQy?=
 =?utf-8?B?d0hJcGVoNk8vd05zWGkweDN0U0VZdnh2YW9FcFNVclJwaG05NVArcG1md0kz?=
 =?utf-8?B?dGo1TU9HS3FWS1daMXU4YWJPeThCOHdoeDE3UzAzNmxxRTRsWUsxVTdMNlE4?=
 =?utf-8?B?UjlPU2JPOWdSM3kzejFJOWM4NjczTXF4N2hkVHRlRGFkb2ZVNTg4NjIzT0N1?=
 =?utf-8?B?eVcvQjJySER2eDhQazRKdU1uK0pMaWx6QkU2bXVSNzZBZnlIVnVaUGl4YlhI?=
 =?utf-8?B?dU9Mc21ZeEVjWmJiZlVBS0FzeDQyR1MzeHVETFdpQkxuWFFRbkFyTWtwOTd3?=
 =?utf-8?B?Y2phOGM4WEcybWN5OVJGRzJNWjh1cEhPTVhxSnphK2F5Q0Z1ZUpwbjdIUWRY?=
 =?utf-8?B?VVFLZWhYNEt3U2U4cWRLQ0JVeDVRaUJ6RDFLaDVoZjhTZ09kazdySGxYOU1D?=
 =?utf-8?B?dGs4b1pwa0lLZS85NmcwaHpycThrdEIrMUV3YkxnWDZBTTZielFoLzN4UXFz?=
 =?utf-8?B?Z01lYnFkY0M3Vm0vTFY0Z1dPT0NXRjZmRWJHbjNXcFlGZ0IxblBkQnA1cGRL?=
 =?utf-8?B?YjREL2UrOTgxN0ptM3lpRlhPV0Y1WDMrSWh1QWI5ZWtKQjRHQ0JPdE9jWGc4?=
 =?utf-8?B?dlpmNjBlcHlUemQ4Yms0V0lFWmJ5S0JLcXFldGxLOEJuMC9PYnFMQVdxMnpK?=
 =?utf-8?B?aGpoRWxaTG5keUs4c3RNbDY4VCtYdE1VRDJTOGN3YitabkJ0U2lJSUN4R1Y5?=
 =?utf-8?B?MlhDT3dKeExLbXhVTHpYZkxDWlhYQUl6bGR2QmZPOWhob1kraXlMRHdNWTky?=
 =?utf-8?B?aEV2NXgwTmJhdHRVZzAwYTRpSGFZU1J1UjlSSDROd08rcVhnUzZEdDMvT1Jw?=
 =?utf-8?B?QWt0VU5UY204TmxWdndzcHVEOEdUeFQ4MkNaN21EUFJDeFB4Y0JMb3p3VTFJ?=
 =?utf-8?B?M1dPd3M5K1dIZS94eGUwSUJDcnhPY3EzSGlaUzB3amUrTzdYeThKL3FWMVVQ?=
 =?utf-8?B?U2htWFFzR0U4eUxmYTVEY0N1d21zV2JiSGdvSmxHcm0ra2tkeEhrdHNEeTAw?=
 =?utf-8?B?OHlSQ1hDTjRCUEI5cFBKRWlCNUxiKzlMdk9vNU1QVzlQVjZxMFh1VEUwTjds?=
 =?utf-8?B?TlUyazZIN1BFUG0xckhUUzVoam56b2hBYXJjNXdDeGZ4cjZGQjQ0bFRDblNG?=
 =?utf-8?B?S2RYeVJSRzZJVlNTSC95ZHIvdUJrTFQvTkZQemRySmJUUmpCT3E0YXMzL2s0?=
 =?utf-8?B?eEtJR3ZMamV5YnVWSlpuREVqZ21ld0RuRGVsaWtqVDRYMVV5QjZDRDlDTENi?=
 =?utf-8?B?T1JTNTRlTTYxSVRBRkE0UVZEYWJRa2dFbG5icTBOTTh5SkNucHNBQzdiZG1I?=
 =?utf-8?B?WFRJTFRmakl2a1lRYmFMSDIvMEkxUVRXRWw3SjJ4bVNmcE1oaktaN3JtU2F1?=
 =?utf-8?B?TTM4TCtWQzJWeFR4ZzhiTHkyaVYvZ0ptRUZTK3N2TFJhdzgzUlRnOGxOU2pN?=
 =?utf-8?B?cjJMN2dXYmtSQ0NFQmhSQkNGQkxVcEQ5UG1rSkkveDdBVEFON2hhRWw0a05S?=
 =?utf-8?B?TkY0endRcXNYVEdBbFlya2ZqUXJJTVZibUpzQSsyT0czT3RBQndmS1VxNVlU?=
 =?utf-8?B?T29zSTVJZFNEbVlISU00ckpxVUE3RlNlWm5LeHJjMmRqWndtY2ZMOGxqU09R?=
 =?utf-8?B?WFBzM21LdjUrNTZEcHF0aGFNN0w2OUVuYkNtbG5qbWM0TlFzcVpFb282ZDI5?=
 =?utf-8?B?SE5TZVdkbWVwYlp2b2d0c0kzN3JlL2tCbE0rQjVpckpudTJ1YnVxdzBiQ0J3?=
 =?utf-8?B?bXh1ekR6NGV1ak1CN1RRN043ZHVlVWhMQlJTcG5ZTDZHaDFuSWpKWFhFRG9Y?=
 =?utf-8?B?TEk2cC9JN3ViUDNqMTBhWmFjdUNsdkU3aWFnbmcyN0hCamR4R2Rwc29aUEFz?=
 =?utf-8?B?cEsyVlJCZVk4THYxRDkwNGgvMHFFSXAyanhMaWdYaWM2SWszTmE3N2lzb1FT?=
 =?utf-8?B?MjhOMkw5ZEp5M1FLU0NJT1lEM0RTS1lrZGN2TUNBRENzVTZ6TkhweS9wQnRO?=
 =?utf-8?B?S0xDQ2N2WnNIbVl5Vnp3L1kzcmV2U3JmbzZYUjhoRFBmT2gxVGVKNkFRcWxJ?=
 =?utf-8?Q?MmiQal7zaOdVNHlBaSaXZrmMi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4D379E6F4CF1B408F4DCE51CBB862E7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f33349ef-7518-40c1-5b70-08dcf933964e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2024 22:38:34.0082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LqGy06tA/bptxXkD91ia2//IsvugWecB+nMpOoUxVWUItlkVEFuWPmgax8NZOpM55Jq4aFSSAGbpA48VBvmUuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4696
X-OriginatorOrg: intel.com

DQo+ICsjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCj4gKw0KPiArI2RlZmluZSBURFhfVkVSU0lP
Tl9TSElGVAkJMTYNCj4gKw0KPiArLyoNCj4gKyAqIFREWCBTRUFNQ0FMTCBBUEkgZnVuY3Rpb24g
bGVhdmVzDQo+ICsgKi8NCj4gKyNkZWZpbmUgVERIX1ZQX0VOVEVSCQkJMA0KPiArI2RlZmluZSBU
REhfTU5HX0FERENYCQkJMQ0KPiArI2RlZmluZSBUREhfTUVNX1BBR0VfQURECQkyDQo+ICsjZGVm
aW5lIFRESF9NRU1fU0VQVF9BREQJCTMNCj4gKyNkZWZpbmUgVERIX1ZQX0FERENYCQkJNA0KPiAr
I2RlZmluZSBUREhfTUVNX1BBR0VfQVVHCQk2DQo+ICsjZGVmaW5lIFRESF9NRU1fUkFOR0VfQkxP
Q0sJCTcNCj4gKyNkZWZpbmUgVERIX01OR19LRVlfQ09ORklHCQk4DQo+ICsjZGVmaW5lIFRESF9N
TkdfQ1JFQVRFCQkJOQ0KPiArI2RlZmluZSBUREhfVlBfQ1JFQVRFCQkJMTANCj4gKyNkZWZpbmUg
VERIX01OR19SRAkJCTExDQo+ICsjZGVmaW5lIFRESF9NUl9FWFRFTkQJCQkxNg0KPiArI2RlZmlu
ZSBUREhfTVJfRklOQUxJWkUJCQkxNw0KPiArI2RlZmluZSBUREhfVlBfRkxVU0gJCQkxOA0KPiAr
I2RlZmluZSBUREhfTU5HX1ZQRkxVU0hET05FCQkxOQ0KPiArI2RlZmluZSBUREhfTU5HX0tFWV9G
UkVFSUQJCTIwDQo+ICsjZGVmaW5lIFRESF9NTkdfSU5JVAkJCTIxDQo+ICsjZGVmaW5lIFRESF9W
UF9JTklUCQkJMjINCj4gKyNkZWZpbmUgVERIX1ZQX1JECQkJMjYNCj4gKyNkZWZpbmUgVERIX01O
R19LRVlfUkVDTEFJTUlECQkyNw0KPiArI2RlZmluZSBUREhfUEhZTUVNX1BBR0VfUkVDTEFJTQkJ
MjgNCj4gKyNkZWZpbmUgVERIX01FTV9QQUdFX1JFTU9WRQkJMjkNCj4gKyNkZWZpbmUgVERIX01F
TV9TRVBUX1JFTU9WRQkJMzANCj4gKyNkZWZpbmUgVERIX1NZU19SRAkJCTM0DQo+ICsjZGVmaW5l
IFRESF9NRU1fVFJBQ0sJCQkzOA0KPiArI2RlZmluZSBUREhfTUVNX1JBTkdFX1VOQkxPQ0sJCTM5
DQo+ICsjZGVmaW5lIFRESF9QSFlNRU1fQ0FDSEVfV0IJCTQwDQo+ICsjZGVmaW5lIFRESF9QSFlN
RU1fUEFHRV9XQklOVkQJCTQxDQo+ICsjZGVmaW5lIFRESF9WUF9XUgkJCTQzDQoNClRob3NlIGFy
ZSBub3QgbmVlZGVkIGFueW1vcmUgZ2l2ZW4gdGhlIHg4NiBjb3JlIGlzIGV4cG9ydGluZyBhbGwg
S1ZNLW5lZWRlZA0KU0VBTUNBTEwgd3JhcHBlcnMuDQoNCg==

