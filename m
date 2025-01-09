Return-Path: <kvm+bounces-34861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F64FA06C9F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 05:01:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AAE33A2AA3
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 04:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241EB153BD9;
	Thu,  9 Jan 2025 04:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gaHpl4/Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A5F748D;
	Thu,  9 Jan 2025 04:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736395299; cv=fail; b=icFEObCTBrgN7564eWV5TIm0UZtjV2NKoumP/dN7vNsdltf/v8gLI3Q1TaTU3nxzTOWcwINsxDZJk6YERS3xf+V2hRd2RqxWyWTGhP0O+UIAJ/fCWvj3Euuf5jfp0hzU5uCD5diIDF4dBuX3MljNgHOmDUjHWkmJY0XWRcDsuBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736395299; c=relaxed/simple;
	bh=vuXjxMBv+xownVS+yM2YkRdo1OIpM8HkmUxmcfw4Gr0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=arkpxkyOO7QkR/LNrj6Yh0hAS8qWnLMnokznRaqj2hf+u4oHbUotlnhyrpJRmHJ9yRhYMISiIP1amS2J4vUSzfELiOodfq+X+Za7PGaI88iT3bk8hvUslW0p0PQQ/PdZkFdizM91Qu64P2ZRCu/DXVqcTWAM9AQ65CdLe6ulptg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gaHpl4/Z; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736395297; x=1767931297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vuXjxMBv+xownVS+yM2YkRdo1OIpM8HkmUxmcfw4Gr0=;
  b=gaHpl4/Z5ze9YNww7US9W23MLkfSEDkd1//EpGo7OpCGyrEaxJQJAokE
   4Ot3HzKwIIjCWvyNnH++GS8j3OQ9scuEgja5xp9rgUlHYL1ig0UupV2qI
   MAerVzWjG9s+cEJfSZ8Trn6vm6uCaUUWfxNhomb2XfPxmFAvjnbgKHD5A
   36yCSFuXZv26mwDkJbVBekdWlAvcKZyUCmY/efSyId9Mama8ekltBbI1O
   w62TO+rEItMPwJk+IjmdvA2OLzQmhXfLoe6ceCkQGR51v/0WA9o7VPaTE
   YYhU8PwSOMtwDKRkMjmLVe12GTqEd3zaHDPu2GycDa2/KRVv3ymCDPj0L
   g==;
X-CSE-ConnectionGUID: fFPh+VG9Quy1oEKJMskTHQ==
X-CSE-MsgGUID: 0+o5J/8eRkSlDCcJaJgSVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="62018144"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="62018144"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 20:01:37 -0800
X-CSE-ConnectionGUID: T2lTboDsQmKFDIM6eIMTAA==
X-CSE-MsgGUID: lP9xMS12RiCZEspB6scnhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="103252008"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jan 2025 20:01:36 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 8 Jan 2025 20:01:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 8 Jan 2025 20:01:35 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 8 Jan 2025 20:01:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Arys2ASl77dRn+0njCniHEJWkpRo48xNlaxmDjpM859K403ZQLJIOdrIvbIjR1fJwHAYxVdiOcJJ8G0KKR+QhsQvwgHNo7vaeuYscs76XGW9kX84qhhMsxzTC8lPvu59ohk6CSOqkX0h/O590AcXHxSkNbmzc1rdcjE+K/QvfZsrTgzVoxIQJMFZjcfTNW1YVlKyyq5nN+bsA2Dy3KMKli5b9uFG1aZfkDyUOViRPyYW3smF5JQl+LhPvl4BljwILFQXI8bdgBjQR1OqIz5zipFwISNiKHd5JBo8R5lU2xqhFb0Ohcw553uVu/GMiTptkubiaKaTEwfiVZXFz6pGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuXjxMBv+xownVS+yM2YkRdo1OIpM8HkmUxmcfw4Gr0=;
 b=iHSYQyyudPCX1R15+AxsP4aY0V4f4hK792NnhqQy3KmxQzAN/tbQfvcxhf5CdMSOR/JUhQxYahhcC4B8f7i6TOqMCoToZyu0BhI13IJLRLbxeTiOAlcCufC0K0PTzJTKHn4m9cLa0TpjWHzKy68g6irowvwEBnTHLvJxokkwMk6p2J5YJPFx3AbCCSdI4tAFJHmQ/n/lxxoYej2zeCac3jDmkn1rPHDVl7EGj+Awf1Pg2YAEfK6112yrvI/y+dl6dROKjySGn4fbboCVoH50UEsEbNIx9h8i6h9eliaYRBG3rcQUvN9n90qI77j1IsOrP3UXi2NeN3wACu+19aV1bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4557.namprd11.prod.outlook.com (2603:10b6:806:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Thu, 9 Jan
 2025 04:01:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 04:01:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
Thread-Topic: [PATCH 11/16] KVM: TDX: Always block INIT/SIPI
Thread-Index: AQHbSdaN3/8Qprs8nkqRa97lp/p8PbMMqC0AgAAJCICAAHGogIAAxUUAgAAFpQCAAAlNgIAAC24A
Date: Thu, 9 Jan 2025 04:01:03 +0000
Message-ID: <47c3f636becd74cb2f6183f76e7839d4ecc64578.camel@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
	 <20241209010734.3543481-12-binbin.wu@linux.intel.com>
	 <473c1a20-11c8-4e4e-8ff1-e2e5c5d68332@intel.com>
	 <904c0aa7-8aa6-4ac2-b2d3-9bac89355af1@linux.intel.com>
	 <Z36OYfRW9oPjW8be@google.com>
	 <8fccaab6-fda3-489c-866d-f0463ebbad65@linux.intel.com>
	 <de52a2dbdcf844483cbc7aef03ffde1d7bc030d9.camel@intel.com>
	 <619071d1-416d-4df6-9acc-775770b82e7e@linux.intel.com>
In-Reply-To: <619071d1-416d-4df6-9acc-775770b82e7e@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4557:EE_
x-ms-office365-filtering-correlation-id: c2817565-65dc-4801-5179-08dd30623c40
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SklkMXpIZWwxZEdHUlcxRWpwWW9lZlBKajZEdllMNWlRd3RqRjdnaXViNVlh?=
 =?utf-8?B?RVlPMEFDQUVKT2NIbTluZndaRkNDeEdhM1dFMWt4YnI5eTAzWFRHbmRhMkxo?=
 =?utf-8?B?ODRBS25obE9xSWozV0Q5N0RkM2lBTWFEamZqNDdpT3RaVjQ5WC9VM2xaYnU0?=
 =?utf-8?B?aEc4SGxpZnZaRXVUeFZjZHpFK2xLZkMyeVJGTGdkdno3cXJYaWJuYmt4UEIy?=
 =?utf-8?B?UHo0OFhoUW1vOGFhMjgvZDhxdEFrM3JRTEt6NEZBRitxWVlzcThObHphc3kw?=
 =?utf-8?B?VU9FaTJtc3hFMCtmenJwejFzWDk4Qy9tVHFRckJHK1BDUlM4T1FmcXZRckhl?=
 =?utf-8?B?ZlhkZHVzZmRVMFFMOWJOR0pEZ2RyaFNUNGIya1EvQ2xuQ0xiTDcrbXB6Rjdl?=
 =?utf-8?B?cHFoV3dJcVZSZ1Y3N2orOVFhSDhhazlnZDQ1TEdxYkF4eWI4VXZieGVvQVlC?=
 =?utf-8?B?czJaMnQybGRGNzk1UFVzRURUUWV2c1A0djVWRFZMcERjK3RGZk5JRWE5WDg3?=
 =?utf-8?B?ZDdTYmVDOHRYeW1xS2tUaHdIcy9JaU5uMjhINHIxK3lBbHFOZlBuRStCbzUw?=
 =?utf-8?B?YjQ4anlCNzZrN3JCV2FTbVRGaEgzZXhzeDN0WHF3VmZlTm4wdlNLNDhwQncz?=
 =?utf-8?B?YzhyaVVHU2RHUU4wQ1FxWXhUZVFnVnhLRjFBU0lZaldyeTFHdWlnZVZSdG40?=
 =?utf-8?B?OTFoWjkwRTBUSU83TTRvUVRlNFpBUWpNT29XNnZOYjV2ZTk0a0YxU3gxN0RP?=
 =?utf-8?B?L1RFSVdUbE5tQkVrV2FBQ2tRcFRGaTJGNTFwZmxEQjVEVERZR2VIRjlCdXJW?=
 =?utf-8?B?cUxOcTlyazJ4YmFLbk42eHdiT1ZwQWNyQi9rK3VnQzR0UTJzeXVoSnVzMGNO?=
 =?utf-8?B?TDgxY3hCcDBRRSsySVpxdEU0NXl1YjA2WmJuTTNzQUVlK0JmQ1Z3cDg0clJa?=
 =?utf-8?B?dUlScG1JdVRxN0ljK3dOaG5qZ3hvUlhvdFd6alZickZwRTNoTGs3QU0yWmJP?=
 =?utf-8?B?a21GTFB5dEdkZndISmZPVVRvN3ErOWRWZEZuT0VtbXdITk1jVGZjNHVxR2F5?=
 =?utf-8?B?YlFGWVUxcnQ4dTd3TmFtM2RJMHpNOG9Nb2p1VmJWZjBQQVQxQm5KUlRVQlFh?=
 =?utf-8?B?UnNrZTRoSzQvNGw0a1Z4WkMwOWdpWVhOZHBkWmhwZU41ZEtLZ0g1cnVPM2JZ?=
 =?utf-8?B?d09xM05Ub1hPQWJxNVdCU01wc2V5ZXhVUmowUGs4ZGZhbHNra1FwVkNsTW5j?=
 =?utf-8?B?QTRkamRXL3BSeWh4bWJOL1JOamhMRDdjdzlnenRESVF6cm5TenJqZ3VRRG1Y?=
 =?utf-8?B?Y1pCZnI2RXJ0S3MyTnV6R2JBQmhaam5HVVBqdWdTV24zd0VoUkY3TzBkK2Ry?=
 =?utf-8?B?QmxISzVJQUtSZWU4VzJYMHBJR3V0ZTN0Q1U0czYzaUh6blVVUks2WnBmZjBM?=
 =?utf-8?B?c2V2anFjdXZNVlc2VFFVMTNkRDM0SnV3QnlvcWdZWFh4eVNyU3lEelp3NEor?=
 =?utf-8?B?UllDbW5KQnZUb3NkaGlXSUdVUityaFJVS3Y5OFc1VVpZbUEwcDhLZVlJdi96?=
 =?utf-8?B?Q1U1MU51UDlyQVlxaEdxaUdCS2tCSmYwUU1JTWg3MDQzM1R1b0gvaFNrZ2pN?=
 =?utf-8?B?Sk9PeVAwdTdsd0F2aFpxRjhiT1k1L204bUM2dzVSWE8wNmh0Q1dpQ3RxQWd2?=
 =?utf-8?B?VWlYb09iRms0d05pZFp2L3ArTE02M2YraTF5eW14cE9OdTFiS2c4TXFWenY2?=
 =?utf-8?B?ektUWlYyTUJKTld5eEpqTzhRK0p5VzN4bEpnQ3NqNUZiOS9WMUtxMk8wSzZI?=
 =?utf-8?B?VVNZNFlqRHkxVnZBWEFrK2c0OHJZRWlXVE9IeFltVTkwSG5VWmZpK1VxbGlB?=
 =?utf-8?B?QVoyQ1QveHA5bytPZTlNRXUzRFRoa0doRFdJU1hhaUpSWFBCWThya2ZTcXVM?=
 =?utf-8?Q?2Seb+0xyWUymWxhdn7dA7uUYnh8RIrb0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDRacGFlMVkyTkVWZjZyeHdrU2tka0hLbDZnbkpldmt1TUZJMWptVmZqb2h0?=
 =?utf-8?B?aUlmL3lnZFpuWTExZllCRGpjcHFteTZha0RIZDRGeUVoUXgxTUZIUDVQZkxl?=
 =?utf-8?B?dVM4ZStoa0hLcENyaTRTQzdzcnBJV1B1TG9iczRXaURteE8rb2pXa3FBamhk?=
 =?utf-8?B?SGdXVHdPVlFFa1ZYN3pIZHI3blZSdEdKNi8xTkZBNWhOYXZOZWdKTHhVcTha?=
 =?utf-8?B?ZzROSEI4QmtpdTNLVXp5bXR2NE5ZOTF0WGpsVng3cVRvQ0ZZSU0wQUQvZkxi?=
 =?utf-8?B?dWNKMVFxZ0FMeU9oVERjR0htYWxxaEZIbkUxd0tkVmZFRmM3aEJXRWhSWk1V?=
 =?utf-8?B?WHBtOW5CYjlVdUNtSGpQcjRINHErVmdPSnBSZWJuZHd2M0FlS0Y2aFBMOUU0?=
 =?utf-8?B?V1dOdHM0ckJDZ1dKcDNGWWI1d2s1ZGFRZ0x2SnZudmVoSTI0L1dBNHhOQkpj?=
 =?utf-8?B?VVdEK2YxRER2YW96VWZQZ2ZLM25LWGkwbElVem84V1kyOUlkZmt1a2h0Y2Mz?=
 =?utf-8?B?RnNnTEttTGkrNG5DU0tqVkNLV1dMSno5Vk9XNFJpMUI1T0Q4eGNkUWdiN0Fv?=
 =?utf-8?B?Z0tBbkpURlYyeWZja1BXU1RvbGNFOTMyU2U0bSthMmRkeDFmd2xmZ05jMFBK?=
 =?utf-8?B?ZStkOFBvb1U1bnhuQ2E4S2p2cENZcDNyZkM2NkVtNTZoYlZWOTR0QU9sSjRa?=
 =?utf-8?B?Z3FNbGhzYnFYbWFPMWR6Ukh1KzlxTjIrMlVsR2FmcU1oWnlCT2RmaStNMjlE?=
 =?utf-8?B?SlRsckthK0lqMmkzRGxReStrUmtPZWJ3dXo1Y3krKzBFNHRhL3kzWm16OW1q?=
 =?utf-8?B?K0F6T09CQXI3cUsvTEs4RkJtTnE0ZjVLRmFkejlYV0F4YU5SY2JVeHlXL3Ra?=
 =?utf-8?B?MWhaR2lEU09OUTE2VlYzWk5ubzlvVXlhQURWZnYrb3VpdElPc1BhY01hdCtV?=
 =?utf-8?B?RGx3NHpvVHBUeG56MThtSzVBdEJ4aCtzTlhxRDltUVhObFpqenkrUC85Qmdm?=
 =?utf-8?B?RVJXRkpCbGlPZG54THdEWnV1SjRiRjBtREdublNua2phZ2JDUHhGcWtmMWtZ?=
 =?utf-8?B?VXRvMStzU3NucVcxRHB1NHJZVWJ2NHRRZVgxbXRjUVRmOHN1MEtDS3A1dExP?=
 =?utf-8?B?TUJGQy95Wm9Od3JMbkpoQ3JtazZ4Nk9KdWNZS0xTVUtpOWVISWRYSDl4TFo5?=
 =?utf-8?B?NS9XUnJGN2k0d1lXL1lHeTI1NnZuWlhjNUpkdVdnZDRqS29iT3pqNUJsU3po?=
 =?utf-8?B?Z1AvbGg1WWNkQTI5M1RFSFM3cXE4cFVDZm5qcVVlL1BjODZWQ0FQMTZvRkM4?=
 =?utf-8?B?RVFCWk9laXV5Z2xjSEwxcVJHODBxQ3RSYUZhZDNvanZjZUpRS0pQdlUyMDBl?=
 =?utf-8?B?RFl2UWJJSU5FOUxaR0R0eVlEakxKa1hpSGJOUnd0OHA1aDRwRkFOVXdDb29i?=
 =?utf-8?B?RXdRRnNQeEg3b3ZhNnU2SXdrenFpTEh1Wm5qRnRJQzdZYTF0SFgwZHBndm45?=
 =?utf-8?B?MEp0dFdwVnBMSEtWNW94QWpqWXM1Sys1bDhMa28zdzhkVHdCbmdzaU5TTFl0?=
 =?utf-8?B?MytrMHFDcjY2RFIvTVJtVXJHcm9mUnduZUhEaW53V00yY1BHSTA3QTZtZjhy?=
 =?utf-8?B?RjN6VXdCR0JXeEFMUDhwRnRPUkhtSzhLZGlieWRuMTd4YWM5aG41aDU4TTcw?=
 =?utf-8?B?ak1Nbmc4c09wdDRSOGxRMFBiUlpsQXNZNUZ0V0J3OGZCZStXSVJQclo4OG5u?=
 =?utf-8?B?Tmx4VG1LdU5GcG4ydXFLcHhrb2ErOVRsbHFxeE9XVWgybnAxbmdmK054UGwy?=
 =?utf-8?B?czBBOHYzT2RZVVJtOUxjYnhzVytXNDVPT0h3Q1dGU2VXVUt1V1FERE0zbFVi?=
 =?utf-8?B?UHc5M0VyUnZzTmhrS0xUWkd4eCt3ai9oSEJraFB5eEJUTXEwY0VEdXQzUjBG?=
 =?utf-8?B?bVZvSko0YlZEN2FWSzQreTQ4T2tFYzA4R0RqMUhYaWhIQzRaY3EyVmkzNmJS?=
 =?utf-8?B?MG8vYkx6YmVCRnJrZ24rZlRjYWxDZnFRSDR2ZHlFQS9vZXBkRFQvemtWdTRw?=
 =?utf-8?B?cDVCekNmYkE5OFhDSHIrVkNrQ3QwZktCTFBad2xacFU1eDBIcFIrckUwQ0dC?=
 =?utf-8?Q?wMT6T/TkwxxE77BNBZ5ctnmKX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4ED5762F715F204A9E703C618DCC4854@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2817565-65dc-4801-5179-08dd30623c40
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2025 04:01:03.1818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5uAidm4bT5U6XtokgjCj0dVEGnDmTvREzweWkPy+aa6xK1zaNMiC1Xd8+Z3ypVRcwpz4lwb+ztIu67lwB/8bJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4557
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAxLTA5IGF0IDExOjIwICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiANCj4gT24gMS85LzIwMjUgMTA6NDYgQU0sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gVGh1
LCAyMDI1LTAxLTA5IGF0IDEwOjI2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4gPiA+ID4g
PiBJIHRoaW5rIHdlIGNhbiBqdXN0IHNheSBURFggZG9lc24ndCBzdXBwb3J0IHZjcHUgcmVzZXQg
bm8gbWF0dGVyIGR1ZSB0bw0KPiA+ID4gPiA+ID4gSU5JVCBldmVudCBvciBub3QuDQo+ID4gPiA+
IFRoYXQncyBub3QgZW50aXJlbHkgYWNjdXJhdGUgZWl0aGVyIHRob3VnaC7CoCBURFggZG9lcyBz
dXBwb3J0IEtWTSdzIHZlcnNpb24gb2YNCj4gPiA+ID4gUkVTRVQsIGJlY2F1c2UgS1ZNJ3MgUkVT
RVQgaXMgInBvd2VyLW9uIiwgaS5lLiB2Q1BVIGNyZWF0aW9uLsKgIEVtdWxhdGlvbiBvZg0KPiA+
ID4gPiBydW50aW1lIFJFU0VUIGlzIHVzZXJzcGFjZSdzIHJlc3BvbnNpYmlsaXR5Lg0KPiA+ID4g
PiANCj4gPiA+ID4gVGhlIHJlYWwgcmVhc29uIHdoeSBLVk0gZG9lc24ndCBkbyBhbnl0aGluZyBk
dXJpbmcgS1ZNJ3MgUkVTRVQgaXMgdGhhdCB3aGF0DQo+ID4gPiA+IGxpdHRsZSBzZXR1cCBLVk0g
ZG9lcy9jYW4gZG8gbmVlZHMgdG8gYmUgZGVmZXJlZCB1bnRpbCBhZnRlciBndWVzdCBDUFVJRCBp
cw0KPiA+ID4gPiBjb25maWd1cmVkLg0KPiA+ID4gPiANCj4gPiA+ID4gS1ZNIHNob3VsZCBhbHNv
IFdBUk4gaWYgYSBURFggdkNQVSBnZXRzIElOSVQsIG5vPw0KPiA+ID4gVGhlcmUgd2FzIGEgS1ZN
X0JVR19PTigpIGlmIGEgVERYIHZDUFUgZ2V0cyBJTklUIGluIHYxOSwgYW5kIGxhdGVyIGl0IHdh
cw0KPiA+ID4gcmVtb3ZlZCBkdXJpbmcgdGhlIGNsZWFudXAgYWJvdXQgcmVtb3ZpbmcgV0FSTl9P
Tl9PTkNFKCkgYW5kIEtWTV9CVUdfT04oKS4NCj4gPiA+IA0KPiA+ID4gU2luY2UgSU5JVC9TSVBJ
IGFyZSBhbHdheXMgYmxvY2tlZCBmb3IgVERYIGd1ZXN0cywgYSBkZWxpdmVyeSBvZiBJTklUDQo+
ID4gPiBldmVudCBpcyBhIEtWTSBidWcgYW5kIGEgV0FSTl9PTl9PTkNFKCkgaXMgYXBwcm9wcmlh
dGUgZm9yIHRoaXMgY2FzZS4NCj4gPiBDYW4gVERYIGd1ZXN0IGlzc3VlIElOSVQgdmlhIElQST8g
IFBlcmhhcHMgS1ZNX0JVR19PTigpIGlzIHNhZmVyPw0KPiBURFggZ3Vlc3RzIGFyZSBub3QgZXhw
ZWN0ZWQgdG8gaXNzdWUgSU5JVCwgYnV0IGl0IGNvdWxkIGluIHRoZW9yeS4NCj4gSXQgc2VlbXMg
bm8gc2Vyb3VzIGltcGFjdCBpZiBndWVzdCBkb2VzIGl0LCBub3Qgc3VyZSBpdCBuZWVkcyB0byBr
aWxsIHRoZQ0KPiBWTSBvciBub3QuDQo+IA0KPiBBbHNvLCBpbiB0aGlzIHBhdGNoLCBmb3IgVERY
IGt2bV9hcGljX2luaXRfc2lwaV9hbGxvd2VkKCkgaXMgYWx3YXlzDQo+IHJldHVybmluZyBmYWxz
ZSwgc28gdnRfdmNwdV9yZXNldCgpIHdpbGwgbm90IGJlIGNhbGxlZCB3aXRoIGluaXQ9dHJ1ZS4N
Cj4gQWRkaW5nIGEgV0FSTl9PTl9PTkNFKCkgaXMgdGhlIGd1YXJkIGZvciB0aGUgS1ZNJ3MgbG9n
aWMgaXRzZWxmLA0KPiBub3QgdGhlIGd1YXJkIGZvciBndWVzdCBiZWhhdmlvci4NCj4gDQoNClll
YWggYWdyZWVkLiAgSSByZXBsaWVkIHRvbyBlYXJseSBiZWZvcmUgbG9va2luZyBhdCB0aGUgcGF0
Y2guDQo=

