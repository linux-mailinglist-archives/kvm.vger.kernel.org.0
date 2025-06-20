Return-Path: <kvm+bounces-50147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F07AE222A
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:27:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B580A4A215C
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682332EACFF;
	Fri, 20 Jun 2025 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JaUHA/f8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF82EA16A;
	Fri, 20 Jun 2025 18:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750444048; cv=fail; b=nDNWHEAxqG76ZiLrlny4ljzmqgBOAcGHs2Mi0dY+GTFFmwFe+FB28AeOeaAnZ9ZlZJCBRlqeGZtCF+ZxSCIDZyrg8vd5Hgcxdxr7XocO6J/BGRw8I238q5NWq9WqHOw05U3WbjzQcUeaNa4brOHjwQ2Pz0lo3J0EHa1aDohqT2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750444048; c=relaxed/simple;
	bh=gezxJkn/odN8YCN4fM1ACERdj0wXAK/TJKHKnnSJYTM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EG2ZLWjlS2kZk38g0tsBXmPQgZlYMyNMI99bp+7kMq4qlgauiJGb6pBDyFa8j9LueI19ymOWPYzwbyIZJ4BMiV83/mLknmucr/cUHhjoAOtS/CcEcLphyYvua7Q68jyPdQ7TO4hv713GxEdt1Y3Uxw3O2YjfjwvUtnCa4fPcYtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JaUHA/f8; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750444047; x=1781980047;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gezxJkn/odN8YCN4fM1ACERdj0wXAK/TJKHKnnSJYTM=;
  b=JaUHA/f8LupZfpSZ5qbZbcsMyYak9C6tEQ73xZEXieyM0IVWDhxrgVI0
   Vo0XbZAPfF8FE3r7vUdNxyv6UAEYARE2+s9hyZZPvmHwqaT9JbyXDt9gv
   jHfhixJ8At3MRu6q4qfABIReUb0KlBpRVueayG4wiqLP7PVkSUJJmY1PZ
   Ver63GqWQ40ioeqgzPQPv/dqyJPgA55WbTfaudn0GFUNcmTi3kHODxF+1
   ZmwGAVTAFVxUSkldloo8TSRQVD9DPFm+DhTMnnZ0JW4V7nBzZRmAd4Wbx
   AsAkcZ541raq9+FyJUH4wI+ewZd+m32hXD+gcjmlRWdrfi9523w0CFK6G
   A==;
X-CSE-ConnectionGUID: DteVZAYvQ3WGdAxMCZB/Fg==
X-CSE-MsgGUID: Qrx/xoCrSeq4lbyPyh+VsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="64068861"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="64068861"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 11:27:24 -0700
X-CSE-ConnectionGUID: 9qzuA6moSm2PhiYpZbytiw==
X-CSE-MsgGUID: oWQxKU+VRy+BzAus7LVK4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="150575927"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 11:27:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 11:27:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 20 Jun 2025 11:27:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.58)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 11:27:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rq8drkUfhv/WEg/7pTRAAvodxSaqPiXcsKEh/KajOa0KB3MlXgheEbd1PjwKalMbQLGGMKiHR9LslfWFS3n9qxsfUJszSWv17byVXzil5DAO3fBfXLjX8ZsdxjZ97mrLxm5/hXVw2hVI8sZZ646pUIv+OgtWOmvimZplCn4rbQYYv6e4aVLDTUN/TOCOgo/HmxFo2dSOKmq6eSxBl86oablZg7dJ3rkY4DCLAjLb+qoUJFWNHhLm7ZAisrg+EVbV5AeopnsljFgN4lI7PF+qaRWv7jfmh46G2nxzyEtkIGWqAv7dUhdKZ+T+iIp2ekbaJlBOrheeu4/NsvAM7ktEVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gezxJkn/odN8YCN4fM1ACERdj0wXAK/TJKHKnnSJYTM=;
 b=RK2ZypcboDMhx5pygpLlHtlShVXIi+dH6binRkTiiVTLhEuxgtFgOJQhDDFutXFil/HK4S9GMbdonWpbByCwzAyCrKE44FYjmW8wS+T3sL/NUEYLJu3Lcd16nX6nACxsVh959d6OzkVYhhY9lGkMywZV9AFEclACf0hgplj3bsfVunD6/dmca5XcMVtmM0uxCyzB7bwTcGMB+1nGLz/7ATxO1nHWhT1ww3nv2eo9A8ehb8ALk5MGp7QgbvdHLB9NBSl+8oys8AQZoAc9sboxs2GFCxLeZRZSXKAyjmMBsf2FwA9ceHXDKYYUCDL6uLEM88Tp9TbnZcNOYT2ReG/TTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB7414.namprd11.prod.outlook.com (2603:10b6:806:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 20 Jun
 2025 18:27:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 18:27:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAESDYCAAAs3gIAA02cAgAABHgCAABiEAIAAB40AgAAWhQCADii7gA==
Date: Fri, 20 Jun 2025 18:27:20 +0000
Message-ID: <991293852693a4edf434d89c8c6c74ab93b0a0bb.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <671f2439-1101-4729-b206-4f328dc2d319@linux.intel.com>
	 <7f17ca58-5522-45de-9dae-6a11b1041317@intel.com>
	 <aEmYqH_2MLSwloBX@google.com>
	 <effb33d4277c47ffcc6d69b71348e3b7ea8a2740.camel@intel.com>
	 <aEmuKII8FGU4eQZz@google.com>
	 <089eeacb231f3afa04f81b9d5ddbb98b6d901565.camel@intel.com>
	 <aEnHYjTGofgGiDTH@google.com>
In-Reply-To: <aEnHYjTGofgGiDTH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB7414:EE_
x-ms-office365-filtering-correlation-id: 3dae6076-f982-49d8-d35e-08ddb028184c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RXJaWGpjZGxXcmVsYjhrTWt1OFJKMFptZ2JqdnB0d3FBVFlIZmV0YlZsUnpm?=
 =?utf-8?B?UThBc1BqNDZpWUsycVhXaVppbFR1ZEYvaVp4UDJoSDIzbFhkdDEvblFOL0Rn?=
 =?utf-8?B?SW03ZHkxQ1ArcEc3d1poYkVValV3MlRqeUw2OEIvaDM4UFZ0OHloWGFPQjRK?=
 =?utf-8?B?ZkdTeEM5ZUtvdmkvTzRqQlB4emNMZDY2dkt1WkRsK2tIa29BR090eXNkRy8r?=
 =?utf-8?B?NjVuTFBZVTZ5cndOWGdabVhYSURuNkhXQmxPcVU4bzBqSzVzSEpvZmRnZ2p1?=
 =?utf-8?B?MDN1TkJuZkJGVDJVV1pUb3AvQzNqNTkyQ2x3OStyNDdac3kvclpEWkdVUUR1?=
 =?utf-8?B?Y1k3aU5BemdZdkRscVhCMTg2ZVg5Sm9ySFF3bUNnUW9rVXpWQVdYcm14ajh6?=
 =?utf-8?B?SC9tbm00bWZTMVFRMmdQRHhxVGFiMXNzWi9rbDdLSHZHSlZTMWZsL3J1RDdV?=
 =?utf-8?B?dmN2MzNRajhpMTczT0E1MUpRL0Yrbk1BS1dFRXRsb3VHcGp0RGpTcWJkd2pG?=
 =?utf-8?B?ZmRrUmZ0cTY5Z00vNWlMZ1grL2VhQ0JwbGRxVEF0NC90L0FVU3FyMEJkWGl6?=
 =?utf-8?B?dWR3SjlCTlJhS0VGRHNwYjNBeGRpemJYak5WLy9yQ1NDRHFha1dCckI2aVNl?=
 =?utf-8?B?SjRwSDdyMkdXbHRYLzhsUUhKZnpnR3ZjUkF5K2lzRHpmQXlYWGliQTJqUnJr?=
 =?utf-8?B?N202dDVJWmRQNUdhdkowR1JxdllFQzVDK1NHYlY1Ym83Y1oyTW9wNDdoOFU1?=
 =?utf-8?B?M3A5NmZ5UTB6UnJlbzlYU0YxQ0p5OVBSdlo3a241Y1ZUdGVYT3ZKc2NOdndL?=
 =?utf-8?B?WkROM1ZpbWdaMXc4UmlSdktwTUlxSzNmbUhEZVgvdzJZNUJZTjdRelkzdTlo?=
 =?utf-8?B?NVB2TjE1S2M0aDBxYkFmVEx0S2pTcmxtU2tNenJJdUdpb0NselNEVmNkU2to?=
 =?utf-8?B?NGwvZ05hcFUzMWxNMjJCbmhQNVdNRWxmNExiazY0aGw0bmFqYmpDeUIvbkd1?=
 =?utf-8?B?YVFhdzJPOE5EeTZZVE03YnluNkwxbHZVdEMvR0NEOGFCNjBYZkpiSjhQNlVh?=
 =?utf-8?B?WVpSOWovL21Pd3dxeDNxSzZlaXJvNHd5SUg0eXlybUlpOEowcE5XVXEzRnpH?=
 =?utf-8?B?OVZ6bG94bENZdTFPS2RnTnhoRGJFazBhS25YQyttcnhpa3lsY291WVlLRWVF?=
 =?utf-8?B?VlJEYitGRGJoL1lIdUZYeUtPdWRiV2hDR1RteFVWUEM0RDE2c1lyMk1QUzJ1?=
 =?utf-8?B?SkdoS2ZJbTVoN0xkeDdENkgyZUswOWRMbmJmNUh4V2hEcmJGbXVoWE44b0JH?=
 =?utf-8?B?MUdxN0RHaUxNdnFZY20vOEswZVFzTzJjNmkvb1paTzJ4R0JQZ1k4MU5jVUdD?=
 =?utf-8?B?MGZNbGtSOXNKcWgvWjROUmtiUFNNbVNuaDBtUiszMU02K1llN0JCM1VtQStK?=
 =?utf-8?B?aTJadm5IWngvYTVJSWxCaDQyRm9ZQ0QvTmNmN2d2M29CMVh3NVBaZk9yelpi?=
 =?utf-8?B?cG5ia2tRL3RoQk9ucEJhMnlCaVpnTlRsUTZqZzRNNmhUdHQ2dzZvRkp4MnJ6?=
 =?utf-8?B?RExGRHFhb1NlT1VDZVpPdnBzbVlSekpVQVpFOWtqbFBzQkY1akMyV3JLbU9w?=
 =?utf-8?B?ZHljN29sODhScE1WQUJxdk5pVFZ2dmJjczBoK1hKZWMrZ3pyQzBqcVF3NEhK?=
 =?utf-8?B?UUtsUlgrV21FNjJTcE5ZZzU0aGpLUU9Tbm11bmNtcWJTK3NMZldvby96UW5i?=
 =?utf-8?B?d0t5RkdtbVExajYrSC9wTEpDUzFuVkhrQVQ2eEY3TlF1K1RkNzVWakNCREh4?=
 =?utf-8?B?R253ZVVoUEw4cmxtM2djUWc2Y2RabEZQdlZldWh6OFBuT1RKYWJMeExpYXBO?=
 =?utf-8?B?ejZTanFJR3MyY0VQRW53dkFSTFlDK040MXg2RWhlUHRnZE9VckRmTUV1NjJh?=
 =?utf-8?B?Y2doWGd4UmJvQm1zWXlSUUZ1L1VkM25Na0FUczZoZEd1djdocSthRkN3cTdR?=
 =?utf-8?Q?jsHl0T1ReEoTVvRmGmz3NUhJwB0jGs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YldGdSt6V3JOaTBEMGRQUVJmdzh0QmtLdHFLbUxabVdhdVVMb0FicjVCS1ZI?=
 =?utf-8?B?WDhoUnR2UDZYdVZYVVN1TjJ4VWdUdCtHMFFaZU1yMG8vbGE1MHh5U2VONWs2?=
 =?utf-8?B?ZHRGK25ObDhWNlRWRkVnZ0lGU2RWRkI3dWkyVEE1b0VLTTBqbllvV3FIczB4?=
 =?utf-8?B?NEY4K0JoRVgrOVNMQ1FPdlFxR3ZSMFBmajQ2cWJXQzZtcG5PZUJpb3R3QlF6?=
 =?utf-8?B?UEhucUR2bzNUR2lqM2pUaElGYUxOSDBqN3pueWxZdGh2cmlTaVBIeUlOWlNj?=
 =?utf-8?B?QWd3LzdNS3NlS3lvanBVVnNIQldDdVBDUTFYcjc2K2o1QkM0YUtqWUxWdExr?=
 =?utf-8?B?c042OXY2bnlXV244S0pHbjdzSitqT1pSWHBlbHFrc2VKczFoanE3NXp6RVpx?=
 =?utf-8?B?Smh2ZU5Pd2ZSR0pyd1FLcXpGVitaTmFjVlVSNHRwd1J0VFhQNElvOWM4Q3Vq?=
 =?utf-8?B?SDlhaEtsSFNZS0c5ZElyYnhNRHZtTHRjVWwvOHhsMmdRaUc4SmZreU8wd3Vu?=
 =?utf-8?B?NVBjZzBkT0xGQVV0ZmFKbXU2cm1zNWVvQzdkRkQvRG5wVXJpZHd3OEFUSkYz?=
 =?utf-8?B?LzVTb3lCSVYwZDlYNHpqN091aHhORkRwYklQQ1RtV2FTclJMMzk5Rlh2WG9R?=
 =?utf-8?B?RzR1RFRPVlRBWGZnUmp3Z3F0cmxkMDJvRmhUOXNSMmw4SFg1Z0F4eHZVYkkx?=
 =?utf-8?B?UHZyMy9OUHdMeDVNdGsvRFpCUU1OYVBUUXBHdldaUmFIY3NhMlBPMzFnaTdN?=
 =?utf-8?B?M3lnbGRvSFFuVis4UkFIc01FQ3h0aWJBb3hvQmoxSHEyVXpVU3E0aHNLQjBU?=
 =?utf-8?B?YUxCMFZzVDYxeGRGZmovTlZ6Q25BQVNaQUxCdm5xUGxCblJhUVBFcUt6ZEF1?=
 =?utf-8?B?Rm04aytPMXhEdXYwNXN1aGVKNy9SQ1BXZ1FISzdwRnZsRTJ2OVFtVFpBWUFq?=
 =?utf-8?B?Um54ZDdyNkswejdNWWh3VG1vUGhvQ01QdExtemMzWjJwd0VRQ204TVRKb0Jn?=
 =?utf-8?B?YTE4S2NveTZ5d3F3enk5VDRrZ0wyQi95NlMxaXRqbUJLS2JQRHFoUFEvV1pH?=
 =?utf-8?B?bzlVM3ZPL2t0cUtzZktUVlp6SXk2R1RXK05GcHZyell0UjVrVG9kRWs1SHo2?=
 =?utf-8?B?a0hLZUNhelhhdnFHd3RqMXBNZWdOb2JxTCszc28vWWozM0JSTXBPQzlKQWZV?=
 =?utf-8?B?eGxhMUJjU3JhbEpKL3NaNGFnUzIrdEpJb1lXOFhwOEJhdlVGVm52SnNyS3JJ?=
 =?utf-8?B?UXBOVUl6VTZ0MWxFeWxuU2ViczlCbEdEMHVxK2ZXVTd3RTZqVVY2THR1M1BC?=
 =?utf-8?B?dVlnZDBRNEk0ZjZSNGNROEdkYUlrenhuUnR3aG9rTzMweVBTZGo3SHFLUlk1?=
 =?utf-8?B?NnJPb2F3eXVHdkRyd0JKdkRLOEQvQm5QS254MUJZWkZCTU81RzIrNWdaQ09H?=
 =?utf-8?B?VXgxRVdDS1g5ZmRRL1BBTXVESE9hR3JvSi9qbzlzblUyNU9HL1BXSE5DZ1ZF?=
 =?utf-8?B?QmQyb3Y0TVhQMVBRTjJjM3Jna0FVSDRScXhZdURQSmlFZ3g0Nnp3R2pkRERG?=
 =?utf-8?B?STAvL0tDV0hjSFFrYTEwLzhVYVlWcWlEMTR1bERwRHNFdW45Zkx0LzJYQmFU?=
 =?utf-8?B?UHNtQTdrT09EY3BsSDNGMytLTUsyMEVYL1dacG54MDR2M3VsTUJ5L21WWGQ5?=
 =?utf-8?B?aEowOUpFdWoxMytwWU1pSkVTa3ZKZmJ5WHVnbWpVc0l1NVJZL09neU1XWWov?=
 =?utf-8?B?bnNCOFFJL0NFYlBKMEFhMkxzeWRUR0t5UWt2RHpGaWdwYWZVZS96RGQ2NlRQ?=
 =?utf-8?B?NHc4RWtvM1drNXdGOGVIQVlQdWtCMG4vSEtVQ1lYOCtjYjUybGIwOE1sc0FH?=
 =?utf-8?B?dEluZ3kzbmlYa1FNdUp5VVpKQ1c4T3pBTmNYeDBCOHFOYjQ3TXA1WG1BZzMz?=
 =?utf-8?B?R25vZHIrMWxYTVFTNmo1RDN2SVhHUmNNeWdOcVVwRnY3eWFKSytoRURaczRB?=
 =?utf-8?B?enBtM1V5T2ZoVmEybi9kUjUrcFNzUml5NEJWaUJXdGNLTHYyeTJQQnBsL3pw?=
 =?utf-8?B?a0E1YWVnZEk0eGJJeEdUR05PcjhwNDJyb1ZndzdaMWZCekRaUm8wMmVqaVRG?=
 =?utf-8?B?clZPZzNsUENXTkNrNEFuSzdUeXVSc2IycTZiSmk5TERqdkhvQWVTT0NHVnRI?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA28B9AD4ACD2B44876C3E9873A7F701@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dae6076-f982-49d8-d35e-08ddb028184c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2025 18:27:20.8709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DmXmECEz5EuCD9Qvz9K6r3CIWqMIq6SHd1Ka3q5RPw1J25z/3hqg1VeF4zcoI6ZzN+KnacQOwoQZxpKuQBJoUPT/URUFa+H2i9mXGQ1eqXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7414
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDExOjEzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEp1biAxMSwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBXZWQsIDIwMjUtMDYtMTEgYXQgMDk6MjYgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiA+IEdldFF1b3RlIGlzIG5vdCBwYXJ0IG9mIHRoZSAiQmFzZSIgVERWTUNB
TExzIGFuZCBzbyBoYXMgYSBiaXQgaW4NCj4gPiA+ID4gR2V0VGRWbUNhbGxJbmZvLiBXZSBjb3Vs
ZCBtb3ZlIGl0IHRvIGJhc2U/DQo+ID4gPiANCj4gPiA+IElzIEdldFF1b3RlIGFjdHVhbGx5IG9w
dGlvbmFsP8KgIFREWCB3aXRob3V0IGF0dGVzdGF0aW9uIHNlZW1zIHJhdGhlcg0KPiA+ID4gcG9p
bnRsZXNzLg0KPiA+IA0KPiA+IEkgZG9uJ3Qga25vdyBpZiB0aGF0IHdhcyBhIGNvbnNpZGVyYXRp
b24gZm9yIHdoeSBpdCBnb3QgYWRkZWQgdG8gdGhlIG9wdGlvbmFsDQo+ID4gY2F0ZWdvcnkuIFRo
ZSBpbnB1dHMgd2VyZSBnYXRoZXJlZCBmcm9tIG1vcmUgdGhhbiBqdXN0IExpbnV4Lg0KPiANCj4g
SWYgdGhlcmUncyBhbiBhY3R1YWwgdXNlIGNhc2UgZm9yIFREWCB3aXRob3V0IGF0dGVzdGF0aW9u
LCB0aGVuIGJ5IGFsbCBtZWFucywNCj4gbWFrZSBpdCBvcHRpb25hbC7CoCBJJ20gZ2VudWluZWx5
IGN1cmlvdXMgaWYgdGhlcmUncyBhIGh5cGVydmlzb3IgdGhhdCBwbGFucyBvbg0KPiBwcm9kdWN0
aXppbmcgVERYIHdpdGhvdXQgc3VwcG9ydGluZyBhdHRlc3RhdGlvbi7CoCBJdCdzIGVudGlyZWx5
IHBvc3NpYmxlIChsaWtlbHk/KQ0KPiBJJ20gbWlzc2luZyBvciBmb3JnZXR0aW5nIHNvbWV0aGlu
Zy4NCg0KSXQgdHVybnMgb3V0IHRoZXJlIGlzIGEgVk1NIHRoYXQgaGFzIGEgcHJvcHJpZXRhcnkg
aW50ZXJmYWNlIHRoYXQgdGhleSB1c2UNCmluc3RlYWQgb2YgR2V0UXVvdGUuDQo=

