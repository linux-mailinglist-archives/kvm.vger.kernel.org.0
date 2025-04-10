Return-Path: <kvm+bounces-43040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EC0EA8350C
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 02:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA33D3B8D05
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 00:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB926182D7;
	Thu, 10 Apr 2025 00:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NSaGK+yQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238F63C3C;
	Thu, 10 Apr 2025 00:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744244217; cv=fail; b=NAKN2CcCGi3Z8zE/gQ3TTdDUMRYY/YygQEO4Pggix2GeOeG+WGfYdY7G34/FcG/A2FF8CN1NRtPcYVYkcaDFXl3VA9MfAZ2lZOrnVH8GERbWi5hBXYxmZGdiWg+FjWli/i/ZUznKdoyE+gPFFjS3CCXaeIXiZrnna5q9Sv0neq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744244217; c=relaxed/simple;
	bh=7U2XLAqkHZW+wZJHGAxGyUA79tx5mwSD1OWZ8jQQzL8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eFR3Npk1heJjbOGMBZXtC3WI3kNojMQI8OQap6tIlhOjC/WYN8We1c2hJVz8rWlHiOvbPUfPQjPpAXU9RLV84sIQmm2VvV/Db74ffJs9uOLN1Jc6hwvZB8ugk45uwxEnKTH6vZbxEKIUZBZLD6fz3aCKGpR2eVxZ4hdA3SRe1EQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NSaGK+yQ; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744244216; x=1775780216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7U2XLAqkHZW+wZJHGAxGyUA79tx5mwSD1OWZ8jQQzL8=;
  b=NSaGK+yQmczz/FdOFoor8A/J0YLaPGeWLudrTzA0K/KFuuV8vMlX2cHC
   z3IKv3KASbHx2JrFOG5clF6vuy4pUptmwmnZ0AyJXvdtePj76i9FV1RBT
   f6WacnHOzGciXIM5nb7xWnxmYOm4b9FWIDGqa4C50UDiV5H/zte1caE3D
   rlNhvOy9OSSV7oNccsqBwVE8OzumW+jXaPChm7OmfpzG/7wReQ1PmmpwY
   H1Hxbt/PeD92Lwd4xd35rpsADDPH+AkR6q938wYjHW7unXGmYXna36ZTh
   /t5p4ryA/fmK7OClHeeXNZR35a+fe5h3/WuLQdRMH/A+T6QnDDyxTYYAz
   A==;
X-CSE-ConnectionGUID: Y4zf3l8WRc2/Yib4i8jmHA==
X-CSE-MsgGUID: f18V9tf/R2uXZrXBD7WaWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="63286059"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="63286059"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 17:16:16 -0700
X-CSE-ConnectionGUID: N80MDoKmQ4eDATb7lbkGHg==
X-CSE-MsgGUID: BqrXqXguRD20wKJgRZzP2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="132878410"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 17:16:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 17:16:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 17:16:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 17:16:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OklU+gkhzv/01HENO4cawow6sHqAwujgWYrVaQ1YfEweoFTLoIyN5CdF934KUYP0LQ/Xhf6iVW1UUIwCGxzXUvd2T0WErejlBiPHKVumkTgsSFUq8kDbhIPhoHrx3ZneBS+E9IL1ZvlJOTAtSJxluygn/VZLfzYUsiMC32ZhZVaXKeKrvoF6A0KVdc6VDNrgTB2DAJP8O5jesyAnJC3xTJ77tiaTdxOR/HX2owKNrLcAPHuFz33iCnDpeNjFS7Z/FrrjV/ryTrt2pMDimauH3/OPXFUTGh9Vt6bMbUWLQ+eZeUNHmty3SXN7HZWk3DGmBO0F91gewnX4vhc1sunlyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7U2XLAqkHZW+wZJHGAxGyUA79tx5mwSD1OWZ8jQQzL8=;
 b=c7jgpf9uExZaXg93zI41oqOM7zEKg/BhT1BX3nLeHPU9/EQeXoTYptMoxLvyzmylkQyIJ1eKegRknJJR8G26pUGqXMGUBOsGansomlXjY/0Bq9Ahz0yKfXDBqDPrUBMymj06bl2QoCrS8F/YOhrNwurrTDMkcVMId6OU1IWX2gy2M0KvxWCE+AVIKuwqQlguxt0e5+XVkuWSRs/dAJJ+KydF83yDIGHtj9KfI1dIfr9+lgxUfZSu/pNOVTenycyRoblk97X0FfRSeR80BwTgo9nn47hA/LvoxhRqngtdtF5OLnfMHMQNN8E3YY7l2fYbj+kYV5pprOOIp1e4Lah59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8576.namprd11.prod.outlook.com (2603:10b6:806:3b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.35; Thu, 10 Apr
 2025 00:15:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 00:15:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Gao, Chao" <chao.gao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Topic: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Index: AQHbo2Q+reE/k3eiXkm8HRe31hfG0LOPjGSAgADJMACACw/5gIAArxEA
Date: Thu, 10 Apr 2025 00:15:47 +0000
Message-ID: <e835e48004350cb17cae70b015cc04169e55b743.camel@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
	 <20250402001557.173586-2-binbin.wu@linux.intel.com>
	 <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
	 <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
	 <Z_Z61UlNM1vlEdW1@google.com>
In-Reply-To: <Z_Z61UlNM1vlEdW1@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8576:EE_
x-ms-office365-filtering-correlation-id: 4901ca08-bcb0-4fa0-20b6-08dd77c4d809
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Sk05L3B6b0FUeGg0a1czUk9RY2lRMFJXTFdGdWJ4cUo1Si95V0w5Y2hTdTJU?=
 =?utf-8?B?cVJjaG4rcy8zbDBmMzRKSWZNS0VGdFhZeE9ubnZSK0hHWWVPRFJ3eXo4UzBO?=
 =?utf-8?B?dVY2bmNqYkFvSVF5UVNoaTJmOHU4TUVMOC80amNtZWd0Z2xrRVFJNFNNamc4?=
 =?utf-8?B?aUJTa2hvVlZ4WnI5elRJaWRGbFdCMTQ2UTlNNmtJM3lZalVKSGl4RjBCK2RS?=
 =?utf-8?B?MGJNYmtoaVM4S2lUaUllSTBvRElJYUs0QktmVmlCSjY0VnpTM0ZMMHdzZUJQ?=
 =?utf-8?B?U2hObURIcmxSY3ZzQU0xWnpsRDRTY0VvNjhjVEx2QW0wcmxiS0ErWE9pZit3?=
 =?utf-8?B?c3diMktiN2F2dFZURlR1bTJmWXV3Ry82NzE0enpJNnZZRElic3VJb2ZUWjQ3?=
 =?utf-8?B?aUtubEswK3djbVZLMU05b05TTTR5eC9FemxKTVlSTzhsS29aMjRhVGg1WkFJ?=
 =?utf-8?B?VU1JNURZMDJFUFB1OWltS3JJY1ppV09GUjNZUHNMRzFHYWIxZDdDOG45dVE3?=
 =?utf-8?B?NWVZZTUvQWhhZGRJV1FhNkVJME1KT2FBeUFHSXpkVUozcTAvZHlwRHhVS0hU?=
 =?utf-8?B?TjdMbW5KVzd5dlNGNDVtbXg0ajFmd3hXRnlSdWs3OHVJREVPZ2xDaDVaSU5P?=
 =?utf-8?B?ZjRoZ3c5dFAzNitlQitaLzhHc0RZb1ZMMGF6WEVobnFub0RwRmQ4YTgrTFp0?=
 =?utf-8?B?NUhyT2E4MmZKWGpwSVdZRzlFRHZpb2pUNFZzenBDUUNYendhV2d2SVp1Tk9s?=
 =?utf-8?B?MzhUSXpJZ2hnVkZQd1N0b0Y3NFk3alh6bExFdFpkWDUvVlVOdS8wT0s3enZq?=
 =?utf-8?B?REt1UnErTnZZVWs0RnltckQ3ODRpZ0tQL1I1L2NWQVNzeklCaFhzQ2VaMmly?=
 =?utf-8?B?VHE4bVFNckVWbVNBRXlEVmM1UVAzVlVPdDk3MWg5ME9renZMck9ZdG9yWHFm?=
 =?utf-8?B?Z3BjUitRdXROTVRnMzltWGNMR2RuaWI4OWlGN3IzUW9LK2VLOW1hNmJpTHNr?=
 =?utf-8?B?MCtnSm9yV1NuWklFZGRXTDlDcWRyckRQMmpEWERNMHh1bE45UklVY1Q3akJx?=
 =?utf-8?B?UERJTFFWZ1R6M2RwdW9WbWdmWlRlYitrLzhwSlIwSWdUQW9VQ0Rqb0Q4OGhv?=
 =?utf-8?B?SDJ5VEhXWVJ2UGM1NjYxTlpXOXc3NDJoVE1NeEtpck9BeUxHb3BCREEzZTFi?=
 =?utf-8?B?bUYrZEpuaG1CRVVEWi9xdVR6d0N5UnlwRlpWMUZrWDdQdmVoU2FiRHhuczhU?=
 =?utf-8?B?VUlLY1BvYzd6MnloNXZLaFcwWEFvQTh6ME5ySU5JSHpjSU9ENXhiSEFraDI4?=
 =?utf-8?B?ZU1RMk1DdUhNQy95SXdsZFdxTzZmZ3NMSEgzKzhLWjZXUGhKV015dXZNTjNP?=
 =?utf-8?B?b1ArTGpIMUcvV0tmMC9nU1VFNDZVSkdHT3lxN0Y5QmNtejlJSHlKT0dCUTFy?=
 =?utf-8?B?dll6NXVoVXkxcFl1eUQvdGFZa2Y3ZENQR09FY2VRcTdqQVFtb3FZdkFpenRY?=
 =?utf-8?B?b0U1b0s4L0hvQ3VjaUljOG9VdXpRK3pBSHJwTGhvUUYyaWVmdFgyWWpwOTAw?=
 =?utf-8?B?OHUrM0xaNXdZNmR1bUFZOXVWVzB0ak15Y1hsc1dPNnhVeGJ3SXFZQWJhS0F2?=
 =?utf-8?B?OEhNTWlnNDMrM00xem91Y25pUkFqVzY2ZHdxajVCTkxRdldmYVFBakliLzF4?=
 =?utf-8?B?dEpYcFdMdndKY3YxZVFFeEdjWS9Od3o5cVRmRzNDLy9aekNqZktkYThXUnYr?=
 =?utf-8?B?N1ZyRGFtRXRKK0NQSzd3cElVNm41cmJFcEdrazduVlZib2xRdzJnQkxWcVZx?=
 =?utf-8?B?NkRRTmJLK0xEZW1KZlVFYnFKTE00aDJuOThXUzR5VkpscFpWc3FNUjVCTUV0?=
 =?utf-8?B?NVQvRGZYZ1ZHNkIzNE9uc1d0R0pDeVdlOC9CcTlCcGRGZ3M0UXVsNmpvRGRm?=
 =?utf-8?Q?so5ar+zEePSR72QcvWSoLhvxiYlYWeov?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODBEdG9iOVVadmpraEx2Wk9GUHkvcHVCWFoycmJLZm9qVDFNQ3FWV3kyYUdW?=
 =?utf-8?B?UVE5a0RVZHkveFNDNVNzN3ZVMW9kNitOeVk4NDlYcGRWTkxlcjZaUXBuZ1RN?=
 =?utf-8?B?VXB3VmMzcUhqaXhPZEZyQmF4UkRMY05yREY3YTMwS0hyUnVnWGFPQ1R2Vmtu?=
 =?utf-8?B?ckNtVnFJek5McTI3YThmbG9EdGQ4NUdzakl3TnZ5MnBIQ3F0TzNMdk10WkpT?=
 =?utf-8?B?bzFSUUNOVkk3MEh1elBsaURQa3BRMFo0S0w0dVBheXF4UVZoZVVOQTZiU1VK?=
 =?utf-8?B?bytpN09wUFRmekl2VDRqd1JTeWhIRk55ZlpOSno0c0Y3VkhXcVdGcDZRQ1V3?=
 =?utf-8?B?QmF6Rml5dzFTR3NlRitwa3IzYjEvaSttaDlNUW1OWDNlSEcrWXQ0VTNETFdZ?=
 =?utf-8?B?Z0ZvSXhnRWdQWk1lNENqYUlBOVZHYU8rMHdlOUhxNTZJTURUa09WelZZQnp0?=
 =?utf-8?B?ektPN1Rid2ZUMTlKYUd3S2h2T2QwTkxkZ3h3Zys4K2NncFZSeWpRcVc4bVVD?=
 =?utf-8?B?ZkFxeTBIeVowNnFXR0NtWUtZUmNOSmpKUTJYUC83SVhNcFhWTVlSMi9UTkJo?=
 =?utf-8?B?Zm1qbUphV0NHSlVmZml3NCtSQWpKS2tEcnd0THdwSm5NU1A1RTJUYzFHU1BQ?=
 =?utf-8?B?azFMN2NFL2RkR2h4dnBJdU1FdXA2eW1XejRFVld5bUcrdE5MV0hNMm05aGVT?=
 =?utf-8?B?K2x0N2ZEU3dlc2QyVFh4MjkwanVuMWVULzN2QU0yVWkwWVBCUVNrSEFyNzcx?=
 =?utf-8?B?WWowU0tmMGdHdk1LT0lCazhYcDVwZWlaMC90N1JvNjRVUzZjR2tRanoyR0py?=
 =?utf-8?B?TTE2NTZKNnZERDBxMDFzdGE4WUJva0YzN0I3MHZBY1lGSkwwSytZOWpONnpN?=
 =?utf-8?B?ZjlvR0JSZWNrdGdSOVpHYmF4b2xBN1poZnJwbTVicVJ5Yi9aQSszQURBYjdC?=
 =?utf-8?B?WGZkL1lMenpwemZyMzEvbEdLQ2ZCb2ZWZmd4d0U0N3MrYjcrREZaRWkyNWFs?=
 =?utf-8?B?c080R3Z6YVlnQ3RVaU1TR3pWclRWYXRPZmRHekYrZG9La21xVmtJMTUvaWo0?=
 =?utf-8?B?cjhnSWVod1BjVEk2UU94OWkweGhraGw3QUFGbnNTcDUvTXFERnBJOVQ3T2Nh?=
 =?utf-8?B?SE1FKzFsYTV5eW1HOVlsK1ZHZmNrZXpjUUEvRWplK3lCSmZVMUV2MGFOall4?=
 =?utf-8?B?QWw2ald4cDRSeHI0YkNWMXBJRVg0TVFaenlYRzcvWVdPYVp5cVQwY1Boak9U?=
 =?utf-8?B?N1V0SmxvNjFSNU9WWnJoeVloMVI5aWxZay9LZCtyNkdyNU5TenBlOGt1R3hq?=
 =?utf-8?B?ZU0vQnZQdHFmcC9NMlJSVHI4SU9lWGtPbUJnVEVKQmlPTkFuVlJtaGczbmtW?=
 =?utf-8?B?MUdqcTVicEZpYVlob0tmVUlUMXUxRmVtYWsvWWo2QjVOVCsrLytSdStCTFh6?=
 =?utf-8?B?aU5Ca1hRSWZuWUIwclY0UlR2TnRyQndIRjY2b0JnMGNjVzMxQThuOGt3dDNt?=
 =?utf-8?B?cURMcklwL3NxeVEzNE83c3RpWW1TUGpLMXI4eTROTDh1WXZhZThyaHBNNXpr?=
 =?utf-8?B?N0xlVVVmeXo5QTFRTWpjdVBOSEFUcG1FbUR0d2pIa1lsbWo4cFQ0NnNSZ29J?=
 =?utf-8?B?MFlNcHBrWHo5ZTZUdTk1dTdnMDFyUUJCb0xKOGRvOVpuVWdVc0dJbkVFZE9i?=
 =?utf-8?B?M1ZUNERWNkZWZFMvZi9FQWhxNUNma01wU3dubnJBL045OHg4dEVvZHQzQTNR?=
 =?utf-8?B?U05TQlNtYUI4NEU0d0V0ZVp6SC8zNUk5TjBxZHZQaWdwTW45ODd3dE1kK2Zp?=
 =?utf-8?B?WGQrM1d1Q0tCUFdpWTZ1aE90ZzAra3UrU0FHOWhRcldQMjdpSmQ5YU0rMkVT?=
 =?utf-8?B?K0lMYkd2c3d3L0R2aG11QVJaTDBkczFoWFRvNVhuT3Bwcjc1MkhoeE96QzBq?=
 =?utf-8?B?TEY4V0hNQU5mQUNZYjE1MGMrbG5TQndEU1NrSHdJb21FcnYvYVJldUtDUWo5?=
 =?utf-8?B?MHR2MEVjVitXVnh3Z095WDRISUxmTXpTdjdQa0ZBNGdMVTZoZzk2TVc0ZEJp?=
 =?utf-8?B?ZE1oNjgwSjFpWGg4WEMwSTh2Z2YzaVpyaW0ybm51NkoyNFZnbDhWd3VCQWJj?=
 =?utf-8?Q?pAYOIb46YaA2o4uKgyygpO30s?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12A846D2DBCB3142A9BAEA64CF6D7B59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4901ca08-bcb0-4fa0-20b6-08dd77c4d809
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 00:15:47.7632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qgprLpgdOIVOrlpnwswtwbYiN0oH753N65PfV2PM6my/7V9FDoUWdmlD3/OTiI3ywyFdtYXE7D6qk3yBzVohFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8576
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTA5IGF0IDA2OjQ5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAwMiwgMjAyNSwgQmluYmluIFd1IHdyb3RlOg0KPiA+IE9uIDQv
Mi8yMDI1IDg6NTMgQU0sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+ICtzdGF0aWMgaW50IHRk
eF9nZXRfcXVvdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ID4gPiArew0KPiA+ID4gPiAr
CXN0cnVjdCB2Y3B1X3RkeCAqdGR4ID0gdG9fdGR4KHZjcHUpOw0KPiA+ID4gPiArDQo+ID4gPiA+
ICsJdTY0IGdwYSA9IHRkeC0+dnBfZW50ZXJfYXJncy5yMTI7DQo+ID4gPiA+ICsJdTY0IHNpemUg
PSB0ZHgtPnZwX2VudGVyX2FyZ3MucjEzOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJLyogVGhlIGJ1
ZmZlciBtdXN0IGJlIHNoYXJlZCBtZW1vcnkuICovDQo+ID4gPiA+ICsJaWYgKHZ0X2lzX3RkeF9w
cml2YXRlX2dwYSh2Y3B1LT5rdm0sIGdwYSkgfHwgc2l6ZSA9PSAwKSB7DQo+ID4gPiA+ICsJCXRk
dm1jYWxsX3NldF9yZXR1cm5fY29kZSh2Y3B1LCBURFZNQ0FMTF9TVEFUVVNfSU5WQUxJRF9PUEVS
QU5EKTsNCj4gPiA+ID4gKwkJcmV0dXJuIDE7DQo+ID4gPiA+ICsJfQ0KPiA+ID4gSXQgaXMgYSBs
aXR0bGUgYml0IGNvbmZ1c2luZyBhYm91dCB0aGUgc2hhcmVkIGJ1ZmZlciBjaGVjayBoZXJlLiAg
VGhlcmUgYXJlIHR3bw0KPiA+ID4gcGVyc3BlY3RpdmVzIGhlcmU6DQo+ID4gPiANCj4gPiA+IDEp
IHRoZSBidWZmZXIgaGFzIGFscmVhZHkgYmVlbiBjb252ZXJ0ZWQgdG8gc2hhcmVkLCBpLmUuLCB0
aGUgYXR0cmlidXRlcyBhcmUNCj4gPiA+IHN0b3JlZCBpbiB0aGUgWGFycmF5Lg0KPiA+ID4gMikg
dGhlIEdQQSBwYXNzZWQgaW4gdGhlIEdldFF1b3RlIG11c3QgaGF2ZSB0aGUgc2hhcmVkIGJpdCBz
ZXQuDQo+ID4gPiANCj4gPiA+IFRoZSBrZXkgaXMgd2UgbmVlZCAxKSBoZXJlLiAgRnJvbSB0aGUg
c3BlYywgd2UgbmVlZCB0aGUgMikgYXMgd2VsbCBiZWNhdXNlIGl0DQo+ID4gPiAqc2VlbXMqIHRo
YXQgdGhlIHNwZWMgcmVxdWlyZXMgR2V0UXVvdGUgdG8gcHJvdmlkZSB0aGUgR1BBIHdpdGggc2hh
cmVkIGJpdCBzZXQsDQo+ID4gPiBhcyBpdCBzYXlzICJTaGFyZWQgR1BBIGFzIGlucHV0Ii4NCj4g
PiA+IA0KPiA+ID4gVGhlIGFib3ZlIGNoZWNrIG9ubHkgZG9lcyAyKS4gIEkgdGhpbmsgd2UgbmVl
ZCB0byBjaGVjayAxKSBhcyB3ZWxsLCBiZWNhdXNlIG9uY2UNCj4gPiA+IHlvdSBmb3J3YXJkIHRo
aXMgR2V0UXVvdGUgdG8gdXNlcnNwYWNlLCB1c2Vyc3BhY2UgaXMgYWJsZSB0byBhY2Nlc3MgaXQg
ZnJlZWx5Lg0KPiANCj4gKDEpIGlzIGluaGVyZW50bHkgcmFjeS4gIEJ5IHRoZSB0aW1lIEtWTSBl
eGl0cyB0byB1c2Vyc3BhY2UsIHRoZSBwYWdlIGNvdWxkIGhhdmUNCj4gYWxyZWFkeSBiZWVuIGNv
bnZlcnRlZCB0byBwcml2YXRlIGluIHRoZSBtZW1vcnkgYXR0cmlidXRlcy4gIEtWTSBkb2Vzbid0
IGNvbnRyb2wNCj4gc2hhcmVkPD0+cHJpdmF0ZSBjb252ZXJzaW9ucywgc28gdWx0aW1hdGVseSBp
dCdzIHVzZXJzcGFjZSdzIHJlc3BvbnNpYmlsaXR5IHRvDQo+IGhhbmRsZSB0aGlzIGNoZWNrLiAg
RS5nLiB1c2Vyc3BhY2UgbmVlZHMgdG8gdGFrZSBpdHMgbG9jayBvbiBjb252ZXJzaW9ucyBhY3Jv
c3MNCj4gdGhlIGNoZWNrK2FjY2VzcyBvbiB0aGUgYnVmZmVyLiAgT3IgaWYgdXNlcnBzYWNlIHVu
bWFwcyBpdHMgc2hhcmVkIG1hcHBpbmdzIHdoZW4NCj4gYSBnZm4gaXMgcHJpdmF0ZSwgdXNlcnNw
YWNlIGNvdWxkIGJsaW5kbHkgYWNjZXNzIHRoZSByZWdpb24gYW5kIGhhbmRsZSB0aGUNCj4gcmVz
dWx0aW5nIFNJR0JVUyAob3Igd2hhdGV2ZXIgZXJyb3IgbWFuaWZlc3RzKS4NCg0KT2ggcmlnaHQg
aXQgaXMgcmFjeS4gOi0pDQoNCj4gDQo+IEZvciAoMiksIHRoZSBkcml2aW5nIG1vdGl2aWF0aW9u
IGZvciBkb2luZyB0aGUgY2hlY2tzIChvciBub3QpIGlzIEtWTSdzIEFCSS4NCg0KUmlnaHQuDQoN
Cj4gSS5lLiB3aGV0aGVyIG5vciBLVk0gc2hvdWxkIGhhbmRsZSB0aGUgY2hlY2sgZGVwZW5kcyBv
biB3aGF0IEtWTSBkb2VzIGZvcg0KPiBzaW1pbGFyIGV4aXRzIHRvIHVzZXJzcGFjZS4gIEhlbHBp
bmcgdXNlcnNwYWNlIGlzIG5pY2UtdG8taGF2ZSwgYnV0IG5vdCBtYW5kYXRvcnkNCj4gKGFuZCBo
ZWxwaW5nIHVzZXJzcGFjZSBjYW4gYWxzbyBjcmVhdGUgdW5kZXNpcmFibGUgQUJJKS4NCj4gDQo+
IE15IHByZWZlcmVuY2Ugd291bGQgYmUgdGhhdCBLVk0gZG9lc24ndCBibGVlZCB0aGUgU0hBUkVE
IGJpdCBpbnRvIGl0cyBleGl0IEFCSS4NCj4gQW5kIGF0IGEgZ2xhbmNlLCB0aGF0J3MgZXhhY3Rs
eSB3aGF0IEtWTSBkb2VzIGZvciBLVk1fSENfTUFQX0dQQV9SQU5HRS4gIEluDQo+IF9fdGR4X21h
cF9ncGEoKSwgdGhlIHNvIGNhbGxlZCAiZGlyZWN0IiBiaXRzIGFyZSBkcm9wcGVkIChPTUcsIHdo
bydzIGJyaWxsaWFudA0KPiBpZGVhIHdhcyBpdCB0byBhZGQgbW9yZSB1c2Ugb2YgImRpcmVjdCIg
aW4gdGhlIE1NVSBjb2RlKToNCj4gDQo+IAl0ZHgtPnZjcHUucnVuLT5oeXBlcmNhbGwuYXJnc1sw
XSA9IGdwYSAmIH5nZm5fdG9fZ3BhKGt2bV9nZm5fZGlyZWN0X2JpdHModGR4LT52Y3B1Lmt2bSkp
Ow0KPiAJdGR4LT52Y3B1LnJ1bi0+aHlwZXJjYWxsLmFyZ3NbMV0gPSBzaXplIC8gUEFHRV9TSVpF
Ow0KPiAJdGR4LT52Y3B1LnJ1bi0+aHlwZXJjYWxsLmFyZ3NbMl0gPSB2dF9pc190ZHhfcHJpdmF0
ZV9ncGEodGR4LT52Y3B1Lmt2bSwgZ3BhKSA/DQo+IAkJCQkJICAgS1ZNX01BUF9HUEFfUkFOR0Vf
RU5DUllQVEVEIDoNCj4gCQkJCQkgICBLVk1fTUFQX0dQQV9SQU5HRV9ERUNSWVBURUQ7DQo+IA0K
PiBTbywgS1ZNIHNob3VsZCBrZWVwIHRoZSB2dF9pc190ZHhfcHJpdmF0ZV9ncGEoKSwgYnV0IEtW
TSBhbHNvIG5lZWRzIHRvIHN0cmlwIHRoZQ0KPiBTSEFSRUQgYml0IGZyb20gdGhlIEdQQSByZXBv
cnRlZCB0byB1c2Vyc3BhY2UuDQoNClllYWggZmluZSB0byBtZS4NCg0K

