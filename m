Return-Path: <kvm+bounces-11751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D09787AB0D
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 17:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7BF41F22D88
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 16:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477C74AEC8;
	Wed, 13 Mar 2024 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LO3ypuYe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E870D482D0;
	Wed, 13 Mar 2024 16:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710347152; cv=fail; b=VnlHh7DQYyHlPq94CACn8lpX7N+NtnfGNuTswfs0VVjaHj3IDPhxvqlj3TgGck5xFPyLtN0cISlBYL05jNBwOPxYIBzwvAWgBPRpH957gYJV8Tq4P153ewhBIln27aAJ79a1ceRiLOEy3suEifUQF7ymmm2w5OcDzzbwKnNXQ1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710347152; c=relaxed/simple;
	bh=OwUf7uElIFOnv4WsD/Ciynt10eg4nSYP0tE6Q5aOjII=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RadsnCPDO+JS9DbvyhqrBA/nZgKXs3C4Xq3Cq0ZGMCGiHetTKbIi7S+Ka9D8b8c+eMeL/ElHmurg4uctPYjdcif5qsuD9s4GXdeZvXbW6VIqaCasII76CZvH/oyyqu/fusb7oazF5Pq6QLxnID5ZDPDfbkztWvLjOU4gAA4s/bE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LO3ypuYe; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710347151; x=1741883151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OwUf7uElIFOnv4WsD/Ciynt10eg4nSYP0tE6Q5aOjII=;
  b=LO3ypuYefmuACAH/3uHEI+OA+mt518dbmEWPVcakhLYPcUz3SlWycdAn
   g+V/O61J+JbZ0pPzBnbwSVOCfZt/BL9ykSrerfYJXS9dCvBRCPFR6SJFZ
   DcQUei7bWhR4XHfEIjcDfIRpp0+kA8D/IcNGwnJxfhU28mLlWHgkb6k1m
   I278tVTzYqHVh0mS+UUFOqJemdX442r2iNiPwRQPqmhHtzaB1sOQ8YjIG
   2O+sN6mfB1gJEgermU7Z6CH7g241kC2IhlxdLJ1kDhDQN+hfoR+st33Qg
   fFzl62wS3/qgCvkQK73+JBL7FtpNEPxXdmvA4rYUfcIYttlWl9/rcjFJO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="5297351"
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="5297351"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 09:25:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,123,1708416000"; 
   d="scan'208";a="12066988"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Mar 2024 09:25:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 09:25:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Mar 2024 09:25:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Mar 2024 09:25:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aj98KL16ANLOfHdmP6mT/HUQW3eUjL+3HckiHJtIQLs+tJFc/hN7ruPHeiAxszFRcoFS5W5rSH70BXeOlD7S1OPbaFFeJfHxvK0KBEj9CJ8BGVlpqOtJviM0RaMM4+4qzT6Ubghf3s1jGaTXbLOuj2eROhBjZFKnw7FnJRWx5NT2O3Am7jQjo4Wfh3XLBi/77PKhE+DwfIzAwfuvNCBwSUqcXsF3Xw26PApZURTo3irgY1md6EcXddgE48BrgZjeVuLUpZhTweyg463RKcke4VOp7duRtWH/PHGc9ViNYqNEERF9YX4f/JVHo7K1Jym0WJgwW5ILDtnRDPqlwCGf6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwUf7uElIFOnv4WsD/Ciynt10eg4nSYP0tE6Q5aOjII=;
 b=gMJEP9SEs860LQlV+/YVXyS7rrrAmZ/d6y3x5WJVhWknal9oeeWMVpnJ1b3i61T0ntaA9y+SBzcNEXM7rOfajmFO5orRAhXF25haPXZe1lZ7+mxSCVwegzRsjs9SEMGtAHBLCVYKzfxHaFUeww3MxVkDVVJe0KAzxHJS5hl/hlN8dDPF5TcNJ9RFcX1XPnawOioQv8UI0tGCaD2WMk1gyu+2vS4pL+01aS7A0RL7YfqMK6xejJpSIEEPGDapuWp2koMN8QhvVefkx+NwR8aPhdG6Vqd7MW4m+6aGCYTcOnWM9p0JUBXfByCeWUt2pNDIT5Pl7QzLP1f61vLtkih29g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB6867.namprd11.prod.outlook.com (2603:10b6:930:5d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Wed, 13 Mar
 2024 16:25:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::fc9e:b72f:eeb5:6c7b]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::fc9e:b72f:eeb5:6c7b%5]) with mapi id 15.20.7386.016; Wed, 13 Mar 2024
 16:25:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dongli.zhang@oracle.com"
	<dongli.zhang@oracle.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "hao.p.peng@linux.intel.com"
	<hao.p.peng@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
Thread-Topic: [PATCH] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
Thread-Index: AQHadKN4OH6SmKEpJ02B1g4zIHBBnrE1bjoAgABurYA=
Date: Wed, 13 Mar 2024 16:25:42 +0000
Message-ID: <60d6242e12030c744ff88322b84d0aa586e2d43d.camel@intel.com>
References: <20240312173334.2484335-1-rick.p.edgecombe@intel.com>
	 <ccb21523-54b8-770a-bdac-c63f9c8080db@oracle.com>
In-Reply-To: <ccb21523-54b8-770a-bdac-c63f9c8080db@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB6867:EE_
x-ms-office365-filtering-correlation-id: 134093de-995c-4bf8-bdcb-08dc437a3a41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eUSxlHMsXIjIOqYLA9GKxFAQBXKap912n3N6ImMThKgRROwQzMzFBoEosg1/y6iZmzGrTfiCDzT/Df7nWRacGhUWWCBfH+EG34WMpnGSx+l0di3sSJD3P6hU6/gIMrqyU72k0s1tnNp/tebHgs9RJrcvR65XPOYtMDxtxscaNurzAwxsAoYvibTZUfowYIJMlgx1G6UI1gd2dR4xdLVoGduUC0oCp8TxEvpKURvomAAsNS0/F26XcbWo6rEe5XFJ0+VW8NhVvyF8m8o20Aadlm9MZO50WUiMBSFbiO6MXDN5qOVsKbbCpbcqT/WoEvP+DeCUhtFR8gcGWQEG/8/ygrR3rCiksLR3wgs+X2QFxG6TwFg8AWa8wayYtNP2ulSrLY7rm3RIfTCejNj37n5SBiXA/v+iniSlXqa0VDv7fvLfvqGiek7FIQfQh9PW9hzyCdRBe38RR83juPhAU9qCkibcTFAx7WZAKpyDGU3Nz2q6FFLx9hQbdRIUVXxbegLs1qlBXTSrWZkDlTEiWO4nte0F6TPSzdSaqeIsVokZryPFSyR9hcu4yRA6P8WYSIJFEgFHCsYAiEzG4Ppb+2DroSC4Gh6D9qYIuGCqsFGtdSp7rVWNBNaBeUMAb+csvKSKp6YLO4PKTE5K38iyy6OQ6ocOZJzzg7a0ZiPFj9uGylba9Fh9X2VlQ+SGzHk6DA7Qx+mkHrtx5GsahT1MSovk4y8K90g3iNLu8IiHyi8nvGM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODlGVTRueXFLS2N3Z1ZXTkJpUkwzNXdCcnV3NEwzNndsKzR6SjFBL2gxY09H?=
 =?utf-8?B?ZzRPTFpTN01BK2RPRnlwcW9pakt1MCs1cFlwb2o1S091T2dNRjhDRUhEK2J4?=
 =?utf-8?B?VXhyNjIxSC9qTGgxV0kwMnZkYWFCMVZoYjZyaHdrRXZNTUh4Z3lRd2cva0Fr?=
 =?utf-8?B?cytZTFZyLyszRmJJSW50ZmRrNk0xK3lSR1JXWmwwRHF3STRUSDFsZDhDZ0hX?=
 =?utf-8?B?cEJnclB0Uk1WSnF3T0Z2YkEvRnZTcGliMlJhRmt6TUkrRmVsa2hnaGdzNndv?=
 =?utf-8?B?TzFhcWNRNlh6YStxZG4rWENiTCsySzVUdVQwWFNhc1NNdGFVU0tXcTZBQndu?=
 =?utf-8?B?V1N6OGRCazRhMnJ4OFJaTGpIczVRa1QxZ2VUTHhFRTU0eFZJdDkvUElSYjZ1?=
 =?utf-8?B?S2RmajRnNmU4bVJVM0krQUV3VFAzUlhnYU1pTnV4Y0U1YVgrWjRHcEIzaTY0?=
 =?utf-8?B?NGsrV0M5TmZhZUc4QnJFMm5tT2VGcU5JdEFNdnhaNVltSzZRaGRIUWFmTkxv?=
 =?utf-8?B?UGVtTndObkVOTHJ3U3JtV3FtcE5wVG9ML3NQcE5BL2NjMlpiWXVjSUN4TCtM?=
 =?utf-8?B?S1ZNOTgwaVVpZW5tV2pnL09QMks0a01FSWt3N2c2VWdNRHMyRmxmU3FkQnJP?=
 =?utf-8?B?OHVTYk80VC92Q0hjYU5vRk1BeEVHY3VmeTIvV0piK21tTDJyVFIvampoSWR2?=
 =?utf-8?B?bVczK3JKVE94azNPNDhCRmFKR0RqWGVrb3hzL1RoNG9kU25DdENQTW9wUVZt?=
 =?utf-8?B?b2FNRTlhSzJLeDNsZkZTMEpNQ1FweU1KTG03R1JuTCtzQ2c5WDhLOXdyM21L?=
 =?utf-8?B?ZWI3ZE5FVVRLMzRNS2RrYVd1V3FjWkRRR2dxRTdvc1JjeHdNL2g1VWdSVTRS?=
 =?utf-8?B?aENvSW9KOXBwTCtkSlFzUjI2QWZCNytDTzFqS1BwNVZpK210c1hOc3pDS1kw?=
 =?utf-8?B?a0tlekN1NzlHM1QvWmRpSjZodG1hWUtqVm1XdUJySjN2OS9oWmorQkJBT3Vn?=
 =?utf-8?B?TW9yOGwzR1J6c3pTNWZpT1NRZTlVS1k1R0hkRGFNdjlxQ293czF2dnBjMjBO?=
 =?utf-8?B?ekhLNXJFejk0clZCVm9TOHM3ZGhpZUowV1JNRDhvVlRpSytSQ0l0KzVxTXdh?=
 =?utf-8?B?M1RRRFRuTmRaMDdKZ2JYd0tEWVpZZ1RKQ3pJOSs2dlhCQUhteHU4WG4xNm1R?=
 =?utf-8?B?eUFkcE9VaTVZbzJ3R2tYM1lDWkNuYlpkRmRUbnlUc3VYTk5VRmpncWlmRzJD?=
 =?utf-8?B?WWJXcCtDc2NCcWRXNUhEeGo0cmJBaDh0UVJaNU5yM0JPU3ArYjVtM1RYUFlP?=
 =?utf-8?B?WHdsK0RjbklJWlpIa25XVVczbkFFdzZhcXRxRkRHMDFjK0J4RTdDZ2dMdjRn?=
 =?utf-8?B?MGVZTlFWVloyT29rdmcxRFJQaUlaTUU4WUdZZmJldEk3QVJnaDhYQlNLMnJa?=
 =?utf-8?B?bWlVbnV4UnBrYUhrb1NiWnlEZForY3VZVEFwdVF1RDdOVzZIYWdvT3BBWGZE?=
 =?utf-8?B?MEJEdHJhR0xESU5panlCdUtJbzU4R2VCYy9yaE9Sayt0VmlFOU9ZMUJOc2dG?=
 =?utf-8?B?NXpMdXBNRUNlWmc4UDBnMzYrWENzVW5lVmdzd1dLd2g0c0hTNG84WHZYTk9a?=
 =?utf-8?B?VnN2YWp2ZkVScmlwMkZ5b00ycFhDYjFaYllWOFJSaWJqaDB0WU55a3ZoYWpj?=
 =?utf-8?B?a21FTVFOWllxcXpBSEN0M2E2a3o5eWl6eXlRSHlNMW1hS2hCVDBjQlMxRkt5?=
 =?utf-8?B?MmZzUlNSVW9TV2FuaE9BbEJoYzIwazkvTlh0QXQzYlpwbVZnaEZEZTFnZjZ5?=
 =?utf-8?B?SlhhZ3FBQStnL0lzQWRGL1BOQmE5OFFUaDdNSUlDczN5WVJnY05ldW4zbEkv?=
 =?utf-8?B?aTJKcXhsYTJ0OElXVW5NU285M24rbDJPMmxleHdrdHd0SlNSWTluU2tYQ3dj?=
 =?utf-8?B?Ky9SM1QxcEd2UEdlQ1B0NWJobDZrUVcxZDYrTEQyZVYwY0kwM21Wc2hVRHJS?=
 =?utf-8?B?bkxMYjQ4RUF6TktGWmhBSG56aUFGcGo4bi85VFdQVWI5TERaZkc4cmdOZzg4?=
 =?utf-8?B?N1dtRWZYL2xiK0luTUFCbkVNU0N2clBZdElCazRrVDJlVXMrTzduV2ZsU25U?=
 =?utf-8?B?QU9oSjg0RlZDVWVmOXJyNFBMSTQwajJkRlZnWFY0YWpOQmlrZGZGSHU0NWJX?=
 =?utf-8?Q?EsGpiDVh5WDM30pGzADZ9ow=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7414762586B789489B05DFF1E3075D1B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 134093de-995c-4bf8-bdcb-08dc437a3a41
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2024 16:25:42.2047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oVT/SQdjWGx6CeulogVsN7TNBVHz4EtGVIJMxXexcDo+JtsoRs8/wGlqsprTg5RiItpH2Gmm/YZEPcfYx2XPl30wXJt4gzHTBeqYjXaU2xI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6867
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTEzIGF0IDAyOjQ5IC0wNzAwLCBEb25nbGkgWmhhbmcgd3JvdGU6DQo+
IFRoZSBtZW1zbG90IGlkPTEwIGhhczoNCj4gLSBiYXNlX2dmbj0xMDQ4NTc2DQo+IC0gbnBhZ2Vz
PTEwMjQNCj4gDQo+IFRoZXJlZm9yZSwgImxldmVsIC0gMcKgIHdpbGwgbm90IGNvbnRhaW4gYW4g
ZW50cnkgZm9yIGVhY2ggR0ZOIGF0IHBhZ2UNCj4gc2l6ZQ0KPiBsZXZlbCIuIElmIGFsaWduZWQs
IHdlIGV4cGVjdCBscGFnZV9pbmZvWzBdIHRvIGhhdmUgNTEyIGVsZW1lbnRzLg0KPiANCj4gMUdC
OiBscGFnZV9pbmZvWzFdIGhhcyAxIGVsZW1lbnQNCj4gMk1COiBscGFnZV9pbmZvWzBdIGhhcyAy
IGVsZW10bnRzDQoNCjEwNDg1NzYgR0ZOIGlzIDJNQiBhbGlnbmVkLCAxMDI0IHBhZ2VzIGlzIGFs
c28gMk1CIGFsaWduZWQuIFRoZXJlIGFyZQ0KNTEyIDRrIHBhZ2VzIGluIGEgMk1CIGh1Z2UgcGFn
ZSwgc28gc2l6ZSBvZiAyIGZvciBucGFnZXM9MTAyNCBsb29rcw0KcmlnaHQgdG8gbWUuIE9uZSBz
dHJ1Y3QgZm9yIGVhY2ggcG90ZW50aWFsIDJNQiBodWdlIHBhZ2UgaW4gdGhlIHJhbmdlLg0KDQpJ
IHRoaW5rIG92ZXJhbGwgeW91IGFyZSBzYXlpbmcgaW4gdGhpcyByZXNwb25zZSB0aGF0IHlvdSBk
aWRuJ3QgZmluZA0KYW55IHByb2JsZW0gaW4gdGhlIGFuYWx5c2lzIG9yIGZpeC4gSXMgdGhhdCBj
b3JyZWN0Pw0K

