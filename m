Return-Path: <kvm+bounces-71153-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mO2cIy9RlGktCQIAu9opvQ
	(envelope-from <kvm+bounces-71153-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 12:29:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EA24A14B5C1
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 12:29:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 16308301C89A
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 11:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A48332919;
	Tue, 17 Feb 2026 11:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m+FPSckX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2D53328E0;
	Tue, 17 Feb 2026 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771327765; cv=fail; b=E80w6B+Xgxc9oc/X2lhR+hFcMpVUUKEdBxw4Vkw+bGWHmy3Aq/fbDMqS9RkYeeUOT6GLpS1vRUoe4jTrYtmOQFjkNNdYL38kDxL2O/tfdNFiNz4WI0uV1qlIipz/Xzk4seyR468/zPEQz1i951LFe4hN2UzSYFuaJPF+KfR8CWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771327765; c=relaxed/simple;
	bh=ojcdkTWjwRfCIQkD0/74pjw373TD/FXrBJQtEWfAB3U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bP90nf7oicdHPplZYe/oH8wnTcvI0h0rVSJyd2gAB1E8JVeJggIrKPLk0bM6CoiYWuhonNEXAIGwsZL0Etby28eYYeD+Ky2ihMDXaBaSzELk4/Z9vvpMcw2+MNI44As702R3gTCY8cnSOvKk3CjjJjkSkAc6uMlJcYXSXdRf/Ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m+FPSckX; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771327764; x=1802863764;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ojcdkTWjwRfCIQkD0/74pjw373TD/FXrBJQtEWfAB3U=;
  b=m+FPSckXuaOvUZA0aFi1dh5nu2dbgolbzQJdP8v8BW0TCRdDhmgOINJM
   NMCctuQ2/6gsHAbmCimBwwO5p90xPocj+g3jsGoDlFSTg773BMMnJD8zZ
   tM56VRctjfWO6DHGo/+Nm6oPHtU82lKZGH3NIgYVlf3xoBsvd7kz2kPhP
   Vc6WKe3oK8FyGTThqWyHZB6sx8iMy41Pum+lGTGFsKGkS8oK5/6nVczk9
   n3bWzLcXBh7LQf1L4x0EDAEvTUj41i4bsh1BwAruDYip3gopfUnH4Aevz
   jNX0ZK2GERjzGvrEJ25ENcPVQvyT02WHlW/W9Awyd4fWqPcG8WKvHiYqI
   Q==;
X-CSE-ConnectionGUID: lyrcXSwcRCWdwlHuyCWh8w==
X-CSE-MsgGUID: UefA/bcMS6qe0W/4yCIg0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="95024377"
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="95024377"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 03:29:24 -0800
X-CSE-ConnectionGUID: 3lUhccxPTKyinvJLtY6Rew==
X-CSE-MsgGUID: nHT92jeHRCCJvK0ag+pD8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="251540407"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 03:29:23 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 03:29:22 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 17 Feb 2026 03:29:22 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 03:29:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hECLxZ5eouAz8tron5pAhIyoSDvSc7bZwnsGKffE8GKMZcWVJTpbhhTTjzy/jQkp3BlWWerhZHPgpaoyhcrQ5D+vhrx7pMYsLDjWA7TXusXu/BTEY0TmxnOGCiEahdaWZh/jXA+r1apnQ8YWzlA+R7zIdfkEmjqjdd0EnRwnNoYT62zcpaNv7f2DHUKRpf62egIzXAtSGP+/hPMqEOe0B4ulOoadQzUkV0xZFHQpI9OZA1EttMPBeGCxfIeDTuPD4KHapzROZVN39RiJpnswxDdOIcMWU+rbZHpgRxobTkQwy0PLJVxYzUz1uqQmMzf07ZD4wmoMok/O+6ICwYibkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojcdkTWjwRfCIQkD0/74pjw373TD/FXrBJQtEWfAB3U=;
 b=tGXAbCHo+1XzClZEG/11CTPUede9uIOkxg3+j+f745l0eTjnifLTkKv4jb9fXHbFbNS1Oo4i0OPEyzlF8l7RtAGRCAlRDklnbMcE5eHjxRK7otFov431AodASkdSxF4IcUrUOdE0h8i/tdao4x5oyRHK54iC0iUdEcBo1O5p7ar0jYxU/RO7IqwZbAlWfG50YWf9hPVhwNpWG7mlK0/WITHMAPMmQrZOfFie7Vi9feLpGBrOvPu7uSY0Cmj2PXdGe1bSJ2DHfKXMEpQVnFnIx6wpm4cxxnmix69bSz0H2TBcE5XMEv4xF4G4advEDQoIaUnbxstenDO8+K2Yb5uX+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by PH3PPF058255456.namprd11.prod.outlook.com (2603:10b6:518:1::d06) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Tue, 17 Feb
 2026 11:29:13 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 11:29:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "tglx@kernel.org" <tglx@kernel.org>, "namhyung@kernel.org"
	<namhyung@kernel.org>, "acme@kernel.org" <acme@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>, "Gao,
 Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v3 10/16] x86/virt/tdx: Drop the outdated requirement that
 TDX be enabled in IRQ context
Thread-Topic: [PATCH v3 10/16] x86/virt/tdx: Drop the outdated requirement
 that TDX be enabled in IRQ context
Thread-Index: AQHcnVFb9iqZyCLtM0iMN9IRRY2SGrWGxqIA
Date: Tue, 17 Feb 2026 11:29:12 +0000
Message-ID: <4317ad31f4ef883daee264f72f032974c044c0cc.camel@intel.com>
References: <20260214012702.2368778-1-seanjc@google.com>
	 <20260214012702.2368778-11-seanjc@google.com>
In-Reply-To: <20260214012702.2368778-11-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|PH3PPF058255456:EE_
x-ms-office365-filtering-correlation-id: 89dbefc3-5535-46f8-92b0-08de6e17c69e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?UHZCWUNINUtjQUlxVXNqSytpWEZlMVRDVmNaTEVQNDQ4eWFPNmNJNVhFOTA5?=
 =?utf-8?B?TEJ0Skg1TkxsVlZ4RjBwdFhGWThyZmRybk5IQUYrUlFKZXBLbnNNUGVXenhF?=
 =?utf-8?B?NkNnTGx5UWI2QXE3dlRKUlpaRXhZVmRZVUs0R1VjSGIxeFVYVXZBNjNrV0Mx?=
 =?utf-8?B?RjA0RjhHeGdSU2JoS3NERkx6L2RTaStLV2tOVTNzc2dpUlVVcTVXTnVpQU1j?=
 =?utf-8?B?aEpIVGpMQ0xYNEswN2JHNDE0enp4c3V0eUgvcFNBUUFKQ2hCUGVmTDVWSlBZ?=
 =?utf-8?B?b0RiUFNnY3JBbGpIb0hXV2M2Q3l2NEs0dGtab3pkNytpR2lPa3NUV0tFS3B6?=
 =?utf-8?B?TjRSbk1DbkNEVk84L1RKbWYxOUh4QVJiNmdmaS95blNRamtlN25pVklLTjhx?=
 =?utf-8?B?K2FUOVJuNVljK1pzc00vTGd3c01uMXJ4Q1lPU3lUaXFzOXdLY0xJR0dEdXhX?=
 =?utf-8?B?anJXMitmWWZuc3FISWwxakZTZEM2a0xlbHd3WnoxdEhkRVNOaUttUTlab3gr?=
 =?utf-8?B?SExhc2ZsRjdOVWM2WFVxUDVpbm5CVG11RGxFNHhlVnVoNXVoNENSclNVVTB1?=
 =?utf-8?B?U3N6NjhXdSsyVXhEK29UVVRWVGhEb3lFWEhvRzJKZTlkczNJdzBJTE5LNDlj?=
 =?utf-8?B?M1luUGc5WHg3eGZnYVBFWSt4MFFMcGNDRHBPRjExTGxNYmdtY3drSlF6dkYx?=
 =?utf-8?B?M25seXRESGU3TnBhT3dMenRSOHRwbnJ5Z0lUMitDSXhkZnYvVlZiNVlkMTUw?=
 =?utf-8?B?Ym9wOHVZVUlhSUNqRUtVZ2dBS0k0bStFNGw5Ui9SOWRFNlo4V2ZrTnA4QjBp?=
 =?utf-8?B?NzV6WlZiT01KVnRxNFNjV3FJQmxSVi9YVmFXRnZkUDFsUnFMU1M5QkVQb3J2?=
 =?utf-8?B?TUJtRSs3RFBDZzF3RGYyR3NGWi9RVGdtTi9va3pjNVNQcnhQNTdLYzRLZkFM?=
 =?utf-8?B?QUNPczlDeGFIeVRaSGRqNXJibjZic2xMTHpzNXNsUDA2bVJXM1E4VC82a2ov?=
 =?utf-8?B?cS9uZFZQN3dEOCtuMmJEcjhhMzZ1VEVtWmtQbHVVMlY0bGtnOC9wTVJiV0RM?=
 =?utf-8?B?Rnp1NWhqRE1oclJLWk51SlBHMGJEOE9ldDMzejd3S0RjYjhaRU5rV012RGZw?=
 =?utf-8?B?Q1FzWkJCZ2MvVE1DSmFreXdXWjFmUG5BTE9jUDNBbVBIRVArV2U1cDRCTmhV?=
 =?utf-8?B?V0wwSjJrRW1QRWZUNWdRQVVXR0NPS0F4bWJFQmoxMEdvMnB0aTR6M2lIdUpC?=
 =?utf-8?B?MXZUOHJOTldOcEFkSndDY0RMSGI0WmduL1UxT2dBMUo2bGRTTjBrZUVuemhk?=
 =?utf-8?B?YTVHWjdRcVU2YTJxUE5sMS90QXVWN2JoZFhXMXVWVDlqTzRmK0JSY1dYZVR6?=
 =?utf-8?B?RzI4K1hWbU9QbExTUnJkVEU1YzZqQjhmTlhHSTZJci9QRUpNYWM5SGllTVN3?=
 =?utf-8?B?dmMrUnFvTDYxUTNSUENHODdiK0tQQjNIMGtKNE8xNFNZWnJ5Szk5QVRYOVk1?=
 =?utf-8?B?VVBwYk1OQitsdEUzVDJZQWUyR3EyYXdMUmZEOXlETEx0SFpzeU9BRWJ0eXlm?=
 =?utf-8?B?a1pUOHl1ZmRpQXQrQm1ZUW9pV3haU0pLRDFpZUZ2WWFFNHFoSG9McGNXbGR1?=
 =?utf-8?B?Z09aUkFMTlpVTXE5enVXQjNTVi9BSDNUSVlRYnR5Wm5lQ2hoYitJbnUvRzJt?=
 =?utf-8?B?OHpWTmM0dlVNeDJZSmJUOVluTkN5V080cFlnT0tuTEUvUnphcGV4MUhSWDRy?=
 =?utf-8?B?MHJmaWQvZHl0Nmt4S0d2MUoxbEJQWnNxL2pWVC9FdWI1RG8yR2ExUFVRNStq?=
 =?utf-8?B?U2JCc05IUWR5RFJndnR6dXFRaFg3TlpTZXZIWlk3azQ1M095L3lDTlp5MnBE?=
 =?utf-8?B?WXJnM2RVRWF1UFhsSmxHenY2V3hnVW5RWlZRSzg1MjJyLzJjYThRVmdZdzYr?=
 =?utf-8?B?WUI1WHd1ait2dTJwZjFxM0xoSG8wcC9sWjVKcmUvRSt5ZE5zOEs2VUQyWDBK?=
 =?utf-8?B?dENrd3ExaHJIR2Z2UVkzbjN3UHhVVFAxQXJRNVZlOUdKWE5oclU3bTAvYldh?=
 =?utf-8?B?NzZyMlNuR21ocjB5NDlDcnhjaGlLUnlScE8wVVB2a29WYURTdEtxN0FQS01Q?=
 =?utf-8?B?R0ZxTFVOZXRMWW9ic3VNMmN1ZTJkcjAvTnpwNi9PVHlxOUZLV25yTnd0cWc1?=
 =?utf-8?B?dkJ6dTR5NDBHamppWlFrKzFpZFdQRm1WdUROZ2Njb1pnNHozbU1PMjZra1l3?=
 =?utf-8?B?OVU2biswemU4dXIyM3o3eUdsdU93PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1ZFU293emt4KzFXVXRGczg0eFgycTFWNDkvc2o0dHRueUJTUEN1dmFUZGJZ?=
 =?utf-8?B?bnhpbFRoSENQTHEvVTIxakdHRXR3M0o0S25GSUpkYkh2UHdpVkVFVUFpK2d2?=
 =?utf-8?B?NkN4bzEyNVdrbmhzRTUxUmVxT0crbjRRNEtzMHdpV1lXRGJyanY5QkhsZ09I?=
 =?utf-8?B?aWRDL3FsdDJNcXp1UnJRMkZlTkQraXJsaFVHU1ZJenhZcHNUSjYxK1NkQjg4?=
 =?utf-8?B?S0VTYzYxY1A3WDBUbXh4TTF0TUx6RHBVRWw1MHFodWducXJ5dFVKeEs3dnJM?=
 =?utf-8?B?VnVQMzhkTGthZjhaaU1MT1J5ajQxeHJBZlNxY0hTVTJpY2oxZkJyZXE3Uy8z?=
 =?utf-8?B?dVltbUpoNGh6UzNYcnZPNnNjN291RjU4Zm9Ebk1hb25FSzEzckwybGUzd1Fv?=
 =?utf-8?B?NWJWME9ielB1OHpVcnRtVTI0Q21OWkdzTjlpT2Y1dnpHNjJwV1pkVnN2Mmc1?=
 =?utf-8?B?cW03QlZVLzc3UUo1NjJkckdMbmxxdkRUbld2Tk04RDF4c25LdS9pTHJQTHRV?=
 =?utf-8?B?eE5PVFJ1SmJUL09ObVpaK3pQeE5lRE96WnBocnJUczVNbjF3U1JBUTdSQ2tw?=
 =?utf-8?B?cUR1ajBOaGdmWUhXWmRFR3Zha3Q5anh2M1ROaEx0T2JxeC9CQ3lYbDFkNklo?=
 =?utf-8?B?SUFveEMrR3dmUkZ2ak0wN2tkY0Y5MGtPSHBKMFVDOVljT2Mrdkd1RGI2ZXFk?=
 =?utf-8?B?dXYvV2lTMjNLMVVpbTBTcnhwZnZsbmRQTFZXRk9RNXQxeTJWYWhHL0FDS2NB?=
 =?utf-8?B?WkZQbUtxSzhuWWR3emdMbFVSTURKKzFCQmVxUkx4YzhjUm5EN0xsOGxJRitK?=
 =?utf-8?B?dnhtMzJCUHhpL3dMQTNtWHVqTHkxSVJHSWVLcFdmV05KWmZianBwMVhWbUxl?=
 =?utf-8?B?aEk2M1JBazd6OW9uS1dNbmVtclBBWER6NXYrdGtSWXZNSktRQ2ZvSHBvYm9G?=
 =?utf-8?B?ZGw2RDRkTmpqeUNmNDYxZVp3MFFiaGlGL1lrOFo0UHplb0pGMy9xcE5wMW1y?=
 =?utf-8?B?RjBaU2RTYkxwWnF3U3Y1VFdBOG1rTGgwMWkzNGJBa1pObnFPaVRDdWRKbFJ2?=
 =?utf-8?B?WkZDSVc1akdHaDBrOS9rZVRvOEhRcnNUSTIxSHdhRW1zc0NlZnpiempzNVA3?=
 =?utf-8?B?Q2ZZSWYrRCs1YVpZNjdLU3habGN6S1gwRVJyU3kraDRVS251amp4ODg1Mm1Q?=
 =?utf-8?B?OU9uZm9ROWoyMmhNb3FSQjlUdVcyL2F1bG1McHhTZmxJTTlaeUEvRHNPUjBY?=
 =?utf-8?B?T2xJdFpkOGhLV0VJZE8wWnNzSE5EM0dDTjhIVHU4TCtocWg4elUxR25GS1E2?=
 =?utf-8?B?bndhVkpoV3llVDhBU3EzU0thazcrQUsrUi9rVDY5SmNjUjVwRFRYN1paallu?=
 =?utf-8?B?cVA2OHpIR1N1STMzWC9wUlRTSnhpaHZBa3hDVUFlaVdQSmQzL0V2UHZzazBE?=
 =?utf-8?B?WkpxLzcrZkQrdExDL3M4VXplaytvVDQ1K2Rjb1pkekRmdnY4S3BVUXU5aU5G?=
 =?utf-8?B?MjBZcUM2VnZubW5LZUJDUlYwTTlqYWtmU2FyZW1sdS85OUhadlZUUTNHVmNN?=
 =?utf-8?B?OWNkbTBMaDJ1bHdYeERDRUFBV2tCeXhvd0tHS0oyU3dCUjJLZ0JNZzVYVm5z?=
 =?utf-8?B?dG93aGJJWTl4YWxXdVFyWVRHRXdBTUdGSW5DNU4ybGVlaUlMNW9VZksweERa?=
 =?utf-8?B?Q3kwRWRTY1FpZzhPd3Jpa2ZVMHQ2dGE4eVF5c20vSTNIT2dOUCs5VUg3Zmt3?=
 =?utf-8?B?TlR5V1U5SHpSV0tCSEk1aG5BWlFoa3dWVkpFbzRWeGZsS1NyUFBpRWRkMm96?=
 =?utf-8?B?RW0rQVAwckF6TUZGb0FoUlVKS3hROXJWRjAzRUdNazdValgrREZWUTJ3ZTA5?=
 =?utf-8?B?VUdld0thSWZJWnVVUWpMbjhjbUdzQVpJb3lzV1AxNjd3bmxYOElEWWlPWlB2?=
 =?utf-8?B?K3Z4T0M0U21sdlZlWnlaa2YzM0paaEZuSFV6RmNqcUlyY3c1WmtPWlhEdUJX?=
 =?utf-8?B?SEpKRE41VkljNDBKbW9WaHlpWHIwN3RxTlpQR0ZMREpTbWtzcFhteE5mbWN6?=
 =?utf-8?B?NWwzM05ydmlaeEE2WEs4WHY2dUJNUllWTW5oY0R6TkFqNmxmOGxveVAxN25N?=
 =?utf-8?B?MlVQTVEycERERUxxVFExVDFCbTcwUkN5c0NUMUdjdTFySzJ6VFgwd1o1ZXkv?=
 =?utf-8?B?SVZXNHI1R1ViM2VQNW80VXMzWnBSY0ZGQ2lqOVVER0Y0WVYrMEVpa3R2YmZi?=
 =?utf-8?B?bkcxeEhJVnBVSHpoQ2dUU2NHSVREVUdpd1d2MmlVUG1HbmV6Tkw1ajhIeEtJ?=
 =?utf-8?B?c1BVSy9Xdk1oSmpDNkkxVElYWWF2NVNCSnlVUFIxNXBWZTlBNzVLQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49C785ADA4F95D41A664F2789F97AA96@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89dbefc3-5535-46f8-92b0-08de6e17c69e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2026 11:29:12.8642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VjLXH1Paj3bMNe3dc+nuHB6xC/f8BEVACaNgzLwvCbdh9Xu+w+3ZBNlGAzwt6GQXFQsjQAsFdU3TLpsL0wFPFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF058255456
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71153-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: EA24A14B5C1
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAyLTEzIGF0IDE3OjI2IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW1vdmUgVERYJ3Mgb3V0ZGF0ZWQgcmVxdWlyZW1lbnQgdGhhdCBwZXItQ1BVIGVu
YWJsaW5nIGJlIGRvbmUgdmlhIElQSQ0KPiBmdW5jdGlvbiBjYWxsLCB3aGljaCB3YXMgYSBzdGFs
ZSBhcnRpZmFjdCBsZWZ0b3ZlciBmcm9tIGVhcmx5IHZlcnNpb25zIG9mDQo+IHRoZSBURFggZW5h
YmxlbWVudCBzZXJpZXMuICBUaGUgcmVxdWlyZW1lbnQgdGhhdCBJUlFzIGJlIGRpc2FibGVkIHNo
b3VsZA0KPiBoYXZlIGJlZW4gZHJvcHBlZCBhcyBwYXJ0IG9mIHRoZSByZXZhbXBlZCBzZXJpZXMg
dGhhdCByZWxpZWQgb24gYSB0aGUgS1ZNDQo+IHJld29yayB0byBlbmFibGUgVk1YIGF0IG1vZHVs
ZSBsb2FkLg0KPiANCj4gSW4gb3RoZXIgd29yZHMsIHRoZSBrZXJuZWwncyAicmVxdWlyZW1lbnQi
IHdhcyBuZXZlciBhIHJlcXVpcmVtZW50IGF0IGFsbCwNCj4gYnV0IGluc3RlYWQgYSByZWZsZWN0
aW9uIG9mIGhvdyBLVk0gZW5hYmxlZCBWTVggKHZpYSBJUEkgY2FsbGJhY2spIHdoZW4NCj4gdGhl
IFREWCBzdWJzeXN0ZW0gY29kZSB3YXMgbWVyZ2VkLg0KPiANCj4gTm90ZSwgYWNjZXNzaW5nIHBl
ci1DUFUgaW5mb3JtYXRpb24gaXMgc2FmZSBldmVuIHdpdGhvdXQgZGlzYWJsaW5nIElSUXMsDQo+
IGFzIHRkeF9vbmxpbmVfY3B1KCkgaXMgaW52b2tlZCB2aWEgYSBjcHVocCBjYWxsYmFjaywgaS5l
LiBmcm9tIGEgcGVyLUNQVQ0KPiB0aHJlYWQuDQo+IA0KPiBMaW5rOiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9hbGwvWnlKT2lQUW5CejMxcUxaN0Bnb29nbGUuY29tDQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCg0KSGkgU2VhbiwN
Cg0KVGhlIGZpcnN0IGNhbGwgb2YgdGR4X2NwdV9lbmFibGUoKSB3aWxsIGFsc28gY2FsbCBpbnRv
DQp0cnlfaW5pdF9tb2R1bGVfZ2xvYmFsKCkgKGluIG9yZGVyIHRvIGRvIFRESF9TWVNfSU5JVCks
IHdoaWNoIGFsc28gaGFzIGENCmxvY2tkZXBfYXNzZXJ0X2lycXNfZGlzYWJsZWQoKSArIGEgcmF3
IHNwaW5sb2NrIHRvIG1ha2Ugc3VyZSBUREhfU1lTX0lOSVQgaXMNCm9ubHkgY2FsbGVkIG9uY2Ug
d2hlbiB0ZHhfY3B1X2VuYWJsZSgpIGFyZSBjYWxsZWQgZnJvbSBJUlEgZGlzYWJsZWQgY29udGV4
dC4NCg0KVGhpcyBwYXRjaCBvbmx5IGNoYW5nZXMgdGR4X2NwdV9lbmFibGUoKSBidXQgZG9lc24n
dCBjaGFuZ2UNCnRyeV9pbml0X21vZHVsZV9nbG9iYWwoKSwgdGh1cyB0aGUgZmlyc3QgY2FsbCBv
ZiB0ZHhfY3B1X2VuYWJsZSgpIHdpbGwgc3RpbGwNCnRyaWdnZXIgdGhlIGxvY2tkZXBfYXNzZXJ0
X2lycXNfZGlzYWJsZWQoKSBmYWlsdXJlIHdhcm5pbmcuDQoNCkkndmUgdHJpZWQgdGhpcyBzZXJp
ZXMgb24gbXkgbG9jYWwgYW5kIEkgZGlkIHNlZSBzdWNoIFdBUk5JTkcgZHVyaW5nDQpib290Wypd
LiAgV2UgbmVlZCB0byBmaXggdGhhdCB0b28uDQoNCkJ1dCBobW0sIENoYW8ncyAiUnVudGltZSBU
RFggbW9kdWxlIHVwZGF0ZSIgc2VyaWVzIGFjdHVhbGx5IG5lZWRzIHRvIGNhbGwNCnRkeF9jcHVf
ZW5hYmxlKCkgd2hlbiBJUlEgZGlzYWJsZWQsIElJVUMsIHNpbmNlIGl0IGlzIGNhbGxlZCB2aWEN
CnN0b3BfbWFjaGluZV9jcHVzbG9ja2VkKCk6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2
bS8yMDI2MDIxMjE0MzYwNi41MzQ1ODYtMTgtY2hhby5nYW9AaW50ZWwuY29tLw0KDQpNYXliZSB3
ZSBjYW4ganVzdCBrZWVwIHRkeF9jcHVfZW5hYmxlZCgpIGFzLWlzPw0KDQpbKl0gbG9ja2RlcCBX
QVJOSU5HKCk6DQoNClsgICAgNy43NTU2NDJdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQ0KWyAgICA3Ljc1NjYzOV0gX19sb2NrZGVwX2VuYWJsZWQgJiYgdGhpc19jcHVfcmVh
ZChoYXJkaXJxc19lbmFibGVkKQ0KWyAgICA3Ljc1NjY0Ml0gV0FSTklORzogYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5jOjExOSBhdA0KdHJ5X2luaXRfbW9kdWxlX2dsb2JhbCsweDE4OS8weDFj
MCwgQ1BVIzA6IGNwdWhwLzAvMjENCg0K

