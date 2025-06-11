Return-Path: <kvm+bounces-49081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 28E55AD5968
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 121F8188BBDD
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15F72BD5A7;
	Wed, 11 Jun 2025 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NMkDlM3t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56C127E7F0;
	Wed, 11 Jun 2025 14:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749653932; cv=fail; b=NRsXjqVLJnuYJaJAx0bIBwHdRtyUzn2YcOAZSbnobC3xPWD7ywqtHDA4S21i/fwhaaPrLovhrVAOJVSiBQenGaSnsk6Eyn05wTASrn8Uo76nGBjAbyKtLaokhOJrVpA7hDcHLsth5o6nZheRMCeYWS3aZWCZsELgr/OENG6RLzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749653932; c=relaxed/simple;
	bh=fjZKUFcVndKVs3vULBviAdzqVTowmhhLiEBNPxJ7vZE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fCkPibrOB7vujosX9vuilMye0GGQ9S5crxoF9HLjMLgU8oJ5bI5ARObTeo6kobM90Mj6/Yzl2irJx2ZqMOseJGANGwpDsJh2RRPFwabnhE6Rcs8gv3sK87nZM8Toyi2n28P78PgsfdxcQzshZa/sp7TPwr6R8EFJJV/H6wY6daU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NMkDlM3t; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749653931; x=1781189931;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fjZKUFcVndKVs3vULBviAdzqVTowmhhLiEBNPxJ7vZE=;
  b=NMkDlM3tSxWbMGSe6g8N/hWk0PfMBS4DXXNGpDNTg/HPWFmvt1xJ6/KN
   a9A7PB7AAgju8feEukH2p/u+k2yrSJLy7xapaMFjPAsC7qPFfJSiduhij
   XHRfkQkyAQOwgwr6R0Fea1SzVmVvswrXH9RTEVnvS0ANHM4mnqLLqd0CE
   y96W3EROheC0xH//rQuPc35UU6Way3tKkiOCvpke8d+STEyBa6jcvlYip
   k4ajFJ45rTCTkFfJhgJWAM9pA2haD5UPkoHWlpRK/cGNVRu4A7pGfjXDb
   Sm32lCgxzLtFhacpnTGEnEN0iITFtLSy/uYk1jDelM5AB5M/yGih0tw/p
   Q==;
X-CSE-ConnectionGUID: XkgJDx7bQrOaFgjkSSuw2g==
X-CSE-MsgGUID: Is8EtQIkRvSXVU8qckkXTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="63211036"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="63211036"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:58:51 -0700
X-CSE-ConnectionGUID: P5SeANi6TdGlUPl4L+tSWg==
X-CSE-MsgGUID: oC5Gb2WORjeHAGcmZlmv2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="147103182"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:58:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:58:49 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 07:58:49 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.64) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:58:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NbYSjQeKG3k+qnw0pVuiAo2hHsDFVzMuhYZL7FIMkS0zqn4ZDBu8tRZudLJzl6KEUWqgrwdAm4JXI1uEXviwtRABTMFSX6VNlME7/VmYkX2um+xFeJMnVD/tzLOuQAk8VTAOB6BJxkjp+RSZqKOU6E+mLGk7XGGHdYQYsrVQHI22kVYraZWFO3XIUSwFaK7Fxf9wPhLOIZ/RW7aY/g1eYCtES6L2n5oB42nd7iRsUuKTcbIw05ofMu7S0vutlWm5us6m0vUURTwUapyMxlbim7fCTVwWhEzYWL2sPaKF4xcYlDDk6By+bJ3Oo4Fw7AQmmjhlA0eUiWVMdbHfvPQ9Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjZKUFcVndKVs3vULBviAdzqVTowmhhLiEBNPxJ7vZE=;
 b=JkylZ9DGZZKCKLd+3L4/nPzPDfNH9AMxnUuj/LLJIpI0COO7hiigR0Ql9dATz6ESLaP9lCiBtas8f0pKIdVnpdZJRYzTah2A+mUxzICS9IcyouSlBMTKAgo96wYvcFxraf7NrTMjTRs0y6u2K0tgGzxrOMMYjWyrSkNuDba9y2Rr167UM5uA7I7FbE75ZEASde7L9qyeVMNCgA+uwIDy0deDfe+d6sCKpytjWzd0L+UC15AwxecS4VcSzVQ4hSbMyC8YKoQX5KTFoQl/Cca9g3VbmO/6XwT1PkeFjlJi4H7mOAX3Idb1AyAiHSeaksf2W32v8qKzx0ENNQ/aupo/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4671.namprd11.prod.outlook.com (2603:10b6:806:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Wed, 11 Jun
 2025 14:58:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 14:58:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAESDYCAAAs3gIAA02cAgAABHgA=
Date: Wed, 11 Jun 2025 14:58:33 +0000
Message-ID: <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
	 <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
	 <aEmYqH_2MLSwloBX@google.com>
In-Reply-To: <aEmYqH_2MLSwloBX@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4671:EE_
x-ms-office365-filtering-correlation-id: 5906d925-b640-4c48-7b82-08dda8f86f8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MDhsMDVpNEtkaUN4MW4rak1JdENONnVMczhvcTZZT3RJUkNoSEpJcmF2STRl?=
 =?utf-8?B?Rm9jQ2V6a09vc09QVUQwQ3lPNXRUNjlsblRVNURtL3M0b2MzU1dnMFQzUHI5?=
 =?utf-8?B?UmtvK3JRY3B5bkpMNmhpeno1UjdmeFRzS3dGMUVMWWlsVlJoa0pIaEJ1ZjlP?=
 =?utf-8?B?bkRic2NyaWxoNzZDajYzZ0NFbmRDNjZldFZTbkEyNHEyMFBYUmpuQzlmdGZK?=
 =?utf-8?B?M0xLMEltZEtFMFVOeGR5NG5GaWptZDdYNy92Qm9tSzJiRFFzUmw1anhxaXd2?=
 =?utf-8?B?ZmY3b210MmlJdnZxVEd3d2ZuRDFWTnJMR2pVc1EzbFRWOUp0UGk4TGlydHlC?=
 =?utf-8?B?SEtnRkJ6cEgrUVNJL3d5aG14K2Y1OEZnOEN3SUNrcG5hOGdObXhNNlBnYjI2?=
 =?utf-8?B?aER6K2xiTDB3UHFWdExORG5rV2w1UXowMm5rYmJycmRLeWNVVHdlcW1CL0lO?=
 =?utf-8?B?NHJmM3ZBQzQ3dlZ3cEFHTFQrUnIrM09pNmhkTFZVUjROa1V1elBZU3FXaE13?=
 =?utf-8?B?QlhIR3BCOFgrS3BTeHNuNmxjMWxoWi9kSzJxK1lTWENvVUlkVGVidmRGam1L?=
 =?utf-8?B?VFhaVE5kd3J4RG9NZGhaSTBkSHhsRmVRVm5JVXRzb1JQY21qUWlIYS9rOE9u?=
 =?utf-8?B?SWVoT2VHanM2REduc21sRlQ3WWNNUGE5dkpKWGI4NzlJeGwwRzYvZGtxYk9z?=
 =?utf-8?B?RHZ4aWhxUThKc21MbnMrKzhkMXAvNW1MaTBHMjFqYjJPOTVmWGVJRmV0aW1H?=
 =?utf-8?B?aENtVllxNnBHUkszVHNMcTN3WlpUejAzZE8ydnFzV0YydnFUbGpDRG9sdUhI?=
 =?utf-8?B?TjliOEl1QmZ2akQ4dWtJVlJLZ1I3TTl6Zkd3bkk3SnU0UEJiNmxVc29nYjRx?=
 =?utf-8?B?M2xzTnA1ZE5vTmdpU0o2YTc1dWpTRHhvRlZjVmxCRU1WK1haNThNbFJialVj?=
 =?utf-8?B?aFdsL3ZYNXRiTzMvT0Vjc2RMN0VPaCs3K24vVnRMNVJ5UnRtOWFsbGt0d3gr?=
 =?utf-8?B?S3EvVTdkNWIwa0NDdUFHbmg3OWIrRkFXK3RrNjd6ZitqaGtMenN4UXhkWWtF?=
 =?utf-8?B?bUlqOC9yMTk2cnJDbUpzbUwzOUFBR2RRVWRTRmwyZDZkNmNpVUFVT1NZNFl1?=
 =?utf-8?B?Q3R1d1dhYlpkblliSjhCMFRkemRhRmdPd0RtNUZWMHRTMWpSdHBhK2hxWE5V?=
 =?utf-8?B?eDdhVG5Vb3JLVGhnc3RIN1ZLUTc3ZlNFSTB1Y0Y2QVM0c3NMVkRCVGxyQUg0?=
 =?utf-8?B?blNEcHF1UU1QRCttei81ci9SNC92UVExT05RM1NzY28zbjRSaWlsQnJ0S0pG?=
 =?utf-8?B?SVRxbmFvenZKRlkwbDF1YVFoUnR2WUhaTGtTRmU0S2ppZURIa2lEeHhCRXBY?=
 =?utf-8?B?dzl2YnVuRUlwdjBrWjVrUVBVS1lNUk9sY1pDbUppN1k4MUJFM29wS3BPaDFm?=
 =?utf-8?B?L3owSXZLM3A2RVJOU1JXaENGUFJmQSs2eldsRkhsbkJ3VGtYZHYva00xdjBJ?=
 =?utf-8?B?Z3g5SEZ6T2hFT3Y2cnp2cC9JVHE5Zzl3NGR6SXcranVrNnlJZnBFME1Ub081?=
 =?utf-8?B?UWFmbnVRMit6U09kUXJrNXRXTzhJN05TeU5Rek9TblZFaWFvTHhpNnhsakw2?=
 =?utf-8?B?QXVGaHh2eWJHWEcxaktvWG9ZYzA0YnZuRmRHcnNMaXJUY01CY3lKSjE1QTFP?=
 =?utf-8?B?eElkR2NYaG1TeGRzOSt5OURBK3hBZ09VT2theVRqS3NieEhxZzVXMjN0MkZj?=
 =?utf-8?B?SktKTHZmT1gxNU9vRlp0dXd5VW9rKzNVWmp2bXBrVStldUc0WlN3ZTlMU3Vl?=
 =?utf-8?B?S2tjRkNQNEllckozb1g0WTFyRnpJUWZ0N1pNTGpxK0pjeFNWYmZVRW9GaVRB?=
 =?utf-8?B?V0hXeCsvemRDTkhmNHc0bTRRU2s5S2FZRE1rS3lIdStHSXRMTG12NWJ4RkpU?=
 =?utf-8?B?RmMxMHRLVXh5QUdzZm9XOG1IendDcTRJb1c5NEd0ZmF2SkdJaEhCMHB5Tjh2?=
 =?utf-8?Q?7868Z9MhmcxJXBy8jLPwMl4sTh4kUg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkFCWlkxM1VxS2ZSYTZQYlZZTGFianlkcHZzbXlsMlk0ZHhwNk5kL25BMzM5?=
 =?utf-8?B?YVlMdlcxWWUvTm03cUsvbENjcm54cjJRM1VPSk9pVEQ3aUxWTmo1Rm82cXp2?=
 =?utf-8?B?Wmc4SFUzQVdoWFY2ZTEyV3gwMk9MeklhNUJ1bW1BM2pNQXU1aGlDQndyQ0R5?=
 =?utf-8?B?SUx1QmFwSXU5eEo1L2JmdkdlcFpPNkJOVlJHN2pUSGZLOC9rZTk1eDlxdXk0?=
 =?utf-8?B?RHJHd0Y2VEwybHcvUENwcWZJQmVLRHk4RmlrQXlJeE1oSWxMNmdoaXZwcFVO?=
 =?utf-8?B?aW1iejhRdjNpTGxiMzQ3SzFwK0xncUxoM3NVUWVUclhlbzlFNHVXbnd1N3hh?=
 =?utf-8?B?Y0d0SEhxNENzQzVKVXBtQVRxUzhEY0pTcTZPellFSzh6STdIMCtKaVlxRUJR?=
 =?utf-8?B?RzBtZU5RM20vVm4wdGxPb0hUckRaZEVNTHZLTm9IYTUxVmgyVVJtR1hJWWxn?=
 =?utf-8?B?Y1ZpYnlqVW9VSzFNbi9PZEQ3SU9iV3pTQkk4d0ZZejNSUmdxOGdkTndiVXpr?=
 =?utf-8?B?UnJZQ0NiWi80K2VoY3M4cUd0Szg1L1dmRm9zekdvdnp2MTdKVDA5NUFwZ2x3?=
 =?utf-8?B?ZlNlTE1seFg1MTlmWStzSVpqNm9lMkpxZnkrTHBOVHdrRFd1TGZBZ2xVUXdw?=
 =?utf-8?B?UFFmMnNlb0tsT2ljWVJGSjRaREN5U1BoUTRLUnVVOE9zVG9NL1JsdW5jNUZy?=
 =?utf-8?B?Ump3cUtFbmtSTU5URHpxN2YyVVFJL2FhYjF4VjNRT3lsdm9kTzMwcGdBUDMx?=
 =?utf-8?B?ZGZwcjkvVUExdVBrcUxyU3hVOHFhTXJldmxwNjdLT0ptQ0Z3dTFtcmJ6N1Zi?=
 =?utf-8?B?WlVUY0pxWG5vcmtUNnNFL1V4cFlWQkJ0OVQxVFM0bk5WQzdtN1V5ZWxvMWZ2?=
 =?utf-8?B?YmVRWmJid2FYY1RJc2lqSWhYMnU1a0NtY2o0eU53djYxdWxJdkkxYnNBT3dk?=
 =?utf-8?B?M0FFTExIRmQ1bmpSZ0w5ZnE4b2dLN2ZNNjJDRmFCZXRzRXFibnVtQkptUmZC?=
 =?utf-8?B?d1RVMmFDYzM2RkhnS21qTTAvODZ6aUVzdy80aUFhdThEcDNkSG44VVRTeUdk?=
 =?utf-8?B?NlExdEtnZlRxMitJYXVFOU94Q2lmQnRsaWFJZWN2M1JSUDBIcHk1c1QyelFj?=
 =?utf-8?B?SkdTYmxDZVRNSGpram1rcHp6R2M0YTVzOEIxK3BNQTlQbFE1RFBGazcvcHpu?=
 =?utf-8?B?SjRVVklJS0F6eisxbTRQeSsyUGNEbXJXU29SWVZJcGdsd2NtYUJzbFBBKytO?=
 =?utf-8?B?emp4S29ELzVDZTNIYU9ucTJDUXJ0eEd5YUpOZ2o2TE10TElUKzFVRnRFOHox?=
 =?utf-8?B?amdHT0Vuc081UHJZL09HNDN6RkVlTEZvN2tydU9IMTJLZ3h6UFZWa1NoTWV0?=
 =?utf-8?B?bnd2ZWhJbUJPZWNrM0c5OEdzUkVQM1FabFc5LzRyM1FIZHRHMDRPZDJmaWxy?=
 =?utf-8?B?QUJ5VDBHVFZBdVE1MEpQWFpaRGJkSCtDZ2p4WW1iYlNnaWdzb3ZYc3NHK09N?=
 =?utf-8?B?MWsxaGZ5SU9ickRIeC9UWFNPdXVjOXorcGJhYmhBMWlEb1cxWDBvMk5jYjZE?=
 =?utf-8?B?dE92RjJ3R1BTNG1KK2tKRlJscEd4RHplR3UwUGd0L0ZJQmI5SmFIdEY5bjNK?=
 =?utf-8?B?bU52SVhnNXV5Tkh3ZlFQWkN0c1V6QktBQjNYVXR1TFkwazJjUFhkeXVDbFVr?=
 =?utf-8?B?MzRuSFE1WXRzeVhTR0hiVGlpdFhUSVFsVmlOcDdBekRVR0xUalZ3cVY3Rm5r?=
 =?utf-8?B?U2dMM0tzVlk4TzdFVWJRemY4TTdsWU5HUmNJZHdDK0pKZExsTzlMc1o0OTdr?=
 =?utf-8?B?bm4zWXVkZGE2ODVXVjJoL3VxcC9vMVBxU214enFyVFFVVjB5WThaMElJbmFD?=
 =?utf-8?B?Wi80cENWUGhsN1M5MCtWUEpkYXA2Rkp5UVRra0hrU3pEc2tLNzFLOUdObEU3?=
 =?utf-8?B?WWpTQThkRHFsWSt0cmZYcXg3MVdBZHl1SkNIVnBqSml5dGszL0R0bzJ6TXA5?=
 =?utf-8?B?bDBCOFpLYXpOejV5a0xFenROK1AyclRZa0FBQWFCTlcvOTVjVzB4S0pwQ1J2?=
 =?utf-8?B?a3R0azhpdEk2SEtLTGc0ZDdLYXZCeGtML0JVZVFWMGp3WkEwVG4yZlNGR091?=
 =?utf-8?B?a09iM1Y4R3EwL3JZSjR5T2ZjejVVWk1Gbk5JSkZ1bjVZdzJYNVVSNEIxRGNK?=
 =?utf-8?Q?ySjxXPfMWOoYeE3zdtd1P+c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8503EB1F8356824DA0FA70164F8001B0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5906d925-b640-4c48-7b82-08dda8f86f8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 14:58:33.2948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fm+Z4rzKxgo9GLAtQtCMny80kOH9WlZBZYcQ65D2h3xYtff82B6xta5u3Bd7u8DHzHPHx0y21kTt9eBNE1RDJ5TIe8o44HVMj0Vho1qZPQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4671
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDA3OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IExldCdzIHNlZSB3aGF0IFBhb2xvIGFuZCBTZWFuIHdpbGwgc2F5Lg0KPiANCj4g
S2lja2luZyB0aGlzIHRvIHVzZXJzcGFjZSBzZWVtcyBwcmVtYXR1cmUuwqAgQUlVSSwgbm8gIm9w
dGlvbmFsIiBWTUNBTEwNCj4gZmVhdHVyZXMNCj4gYXJlIGRlZmluZWQgYXQgdGhpcyB0aW1lLCBp
LmUuIHRoZXJlJ3Mgbm90aGluZyB0byBlbnVtZXJhdGUuwqAgQW5kIHRoZXJlJ3Mgbm8NCj4gZ3Vh
cmFudGVlIHRoYXQgdGhlcmUgd2lsbCBldmVyIGJlIGNhcGFiaWx0aWVzIHRoYXQgcmVxdWlyZSBl
bnVtZXJhdGlvbiBmcm9tIA0KPiAqdXNlcnNwYWNlKi7CoCBFLmcuIGlmIGZhbmN5IGZlYXR1cmUg
WFlaIHJlcXVpcmVzIGVudW1lcmF0aW9uLCBidXQgdGhhdCBmZWF0dXJlDQo+IHJlcXVpcmVzIGV4
cGxpY2l0IEtWTSBzdXBwb3J0LCB0aGVuIGZvcmNpbmcgdXNlcnNwYWNlIHdpbGwgYmUgbWVzc3ku
DQo+IA0KPiBTbyBJIGRvbid0IHNlZSB3aHkgS1ZNIHNob3VsZCBhbnl0aGluZyBvdGhlciB0aGFu
IHJldHVybiAnMCcgdG8gdGhlIGd1ZXN0IChvcg0KPiB3aGF0ZXZlciB2YWx1ZSBzYXlzICJ0aGVy
ZSdzIG5vdGhpbmcgaGVyZSIpLg0KDQpHZXRRdW90ZSBpcyBub3QgcGFydCBvZiB0aGUgIkJhc2Ui
IFREVk1DQUxMcyBhbmQgc28gaGFzIGEgYml0IGluDQpHZXRUZFZtQ2FsbEluZm8uIFdlIGNvdWxk
IG1vdmUgaXQgdG8gYmFzZT8NCg0KUGFvbG8gc2VlbWVkIGtlZW4gb24gR2V0VGRWbUNhbGxJbmZv
IGV4aXRpbmcgdG8gdXNlcnNwYWNlLCBidXQgdGhpcyB3YXMgYmVmb3JlDQp0aGUgc3BlYyBvdmVy
aGF1bC4NCg==

