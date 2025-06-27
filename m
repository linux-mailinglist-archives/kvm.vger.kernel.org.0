Return-Path: <kvm+bounces-50929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C908EAEAC09
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BA061C27D9A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:56:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFBDD60DCF;
	Fri, 27 Jun 2025 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mea8UPnf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EF59460;
	Fri, 27 Jun 2025 00:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750985783; cv=fail; b=AcCgeO7D7egul0ydEgyvIdI8GU7S0N1gYE/v60WBES7PEy8caAgR2LH9U7XlgGzyM8k8h5bZ/LW9ehIxCHkqYw403qBengLhZPSg3wO6kU7FxqqRdeF+zFtHF8dAzeVpxo0fGbJceJYru7TRv+gQmhh3nEj18VOwpMcP7MGFE8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750985783; c=relaxed/simple;
	bh=Xl23EniHNbujhxqvtQtSYKQpYFi3JGGhTiqoQzkLLRw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aKO67144OJ1Y/A8NURLPZTG8+ayVyT0QZWpj21D0vZXLk7Q6GDguV7bdK3TOt3mxaf3CsZKEtMASPnhAZ7Lc/aSqIaAysccVr1ZMzAL3YXNvwINrZGg2YXZ1hWOwRlIkixN4x37qtBBATiRIjkWbWu97mjAKWEG28UQ0aa0A0uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mea8UPnf; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750985781; x=1782521781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Xl23EniHNbujhxqvtQtSYKQpYFi3JGGhTiqoQzkLLRw=;
  b=Mea8UPnfy0NFvtwrz28JifSyivqoY0XvKk1Gifr6zusUeeBtW7mJ5ZPs
   rdtp5eFwStm2fcvJ0//uptYYgIuKPq/iZLxm3jQWTLp52KCco7+1jDqmI
   DvB31ksmnx3CmLPAfmQYyf/QNXEehPVsVpdeM9HorteRRqiQwfB6kfXK1
   UrtRfgZLV1R/UsWdiuDYXZPWiTQA6W5lL9Ho8XVdlkfxGwriVHGgMAr1z
   QJe6N1+euolV3d2v+X8iBQkjqO5vOvM9XF/Dml1S/vxpDsoZ2pl3OtHMC
   eea9hSancScs/empM9chLGR5qxuS8GTY3IqbVHYejEuOaPc8f8+8a3d9C
   Q==;
X-CSE-ConnectionGUID: kne+r5+aTzGOCQPVlZ+K3Q==
X-CSE-MsgGUID: 3eYT8rMyQKyPYxCLhpJALA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53023233"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="53023233"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:56:19 -0700
X-CSE-ConnectionGUID: Ysw3/U9+TMGdo0oE6hKlzw==
X-CSE-MsgGUID: SUQW4TRATGCh56zKjqVqgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="153379396"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:56:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:56:18 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 17:56:18 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.43)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:56:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZI0eZ/e3jUzIzHLvOJnLQjLBgSoEOlNHsvQtjMYHJwi2qAv+tuAy5e39SCN0XYc61EBlJfZ/L7SUo2VPv2AT4fzAzjwB7sHulxXOBRIra9Bf5A2/OX3TDyJWIPTgYKUxokXWvNsO9KyaoTlNzPUiaLjsN4K5LWPL/NWg1F+gekDHGhjS4QpBb8kY6zrS608nIX7JzNsZjJdgqQRBPgHKn2wYT4QH0aVa2a9GYEGDV3ciCClQaBy6Dbfvjjg4vBLxUJLOHdfY4Hb2JbhAW3tUKNCt6q3iqWQtFfDYlYyoSPOh1xt0iTBmlbkKQCY2qkhipaN+8/x81KrZxoQ6g3vhQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xl23EniHNbujhxqvtQtSYKQpYFi3JGGhTiqoQzkLLRw=;
 b=A0X2RvOTYfiLpobTEcu8FOoZKEYc8Vm8sFn2k+MgZPaCo1ZyzV3Hrs5mbNjj69hQunooMwzd+hlYeug9YvEorNouPlBZ7wGiJlmZ0Y6QQX7RujepFhMXuQBNCebHRRD1sMTrhITItfhgdY5wgX9SZhCAiv+cY88fycc1AC96vt9WbTBW0IHcg/JgZzH5aVNjXxwNC9hmyeTT2+s5P78xYwfQEmhQrTzeBywr70PiWwykQ6NfpZKKBIB1uPVbY8uE3VeUmezwvP88SQHauAjV6RGFcKbpZHJhHqucK/Zh4xzZx1WJhUjFH3PQHekotynXRN8/rplhCnnvhEfberY0eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW4PR11MB7128.namprd11.prod.outlook.com (2603:10b6:303:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Fri, 27 Jun
 2025 00:56:08 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 00:56:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Topic: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Index: AQHb4EnDpX31F9fykECcZZx9vdaxeLQJAkSAgAr5c4CAAB9IgIAAZo+AgAABkICAAC0ggIAA7dQAgAByfACAAAN2gIAAJ+uA
Date: Fri, 27 Jun 2025 00:56:07 +0000
Message-ID: <5ef7770cce1e78344a94a6b6c58eca78c616bbb1.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-3-adrian.hunter@intel.com>
	 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
	 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
	 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
	 <c315604761ad760fc29bebdb007fac239a1b45f9.camel@intel.com>
	 <91df7051-2405-4609-9e86-2bbc02829644@intel.com>
	 <8c24d9b9c888eed972e8ee75fa9d31cc7fd72a73.camel@intel.com>
	 <DS7PR11MB6077ED08B85A000014BDAE00FC7AA@DS7PR11MB6077.namprd11.prod.outlook.com>
	 <f51e62543aa765da3b4f4ed19aa13340881fbc89.camel@intel.com>
	 <b439abd6-9fd9-4f51-82e2-c8b1304e7cca@intel.com>
In-Reply-To: <b439abd6-9fd9-4f51-82e2-c8b1304e7cca@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW4PR11MB7128:EE_
x-ms-office365-filtering-correlation-id: 63b3d92f-50e6-442e-e413-08ddb51566bf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VzNHcGQvT29TSWRMend6ckFZeEJ3dGxLbFA0VjVkSG8raThrY0xrcUZvZzV1?=
 =?utf-8?B?VTFRck5wV0tvT0VBQVlvVnVvNGFpRE9iWnlIVE5OVTFBNXQ0ekgxVXF4U2Vs?=
 =?utf-8?B?U25sbmdzNlMwWW1oWFpLRXRTT0xsTC8wT3g5QjEyYWEveHVwMkNvN3Y4cVRj?=
 =?utf-8?B?Q3hhUXB0KzZhVGN2cUxhQnhjZ0dBNk5TNW0vT04vUkQvSXd1NUV6R0xnVElX?=
 =?utf-8?B?ZDVHWTdDMXNSTmNlb0VkenJudER3YkpSb2hzZXY5c1pKSXJqSlpVRnhaWFBD?=
 =?utf-8?B?RXBKVnB5VUphaVdmVGwzNVIyQWsyRDcwTnJwTzFoLzdWVnZWMmpjcXNzY2Q2?=
 =?utf-8?B?U0ZaQ05CNktKWnNmaENqRWliL05QWXcvb2IyWUsvNi9PYms3c0xyM2ZFTmwz?=
 =?utf-8?B?UTR1SncrQm1hRnloZjhQQWZwQ0lBdXBGWE9Na3dsWUpUUU5JblBzb0daUHZX?=
 =?utf-8?B?OTBQZTJ4aTZXRkhuZndRcEQyWTgwZURRUjEyNVdwS0dzZXd3NTZiNUpXY29s?=
 =?utf-8?B?bXpMbVhMekN1QWFsaWJFcEZPc3E4ZERQYU5nWlBpbGdodnBiMmdCdmlCeDlJ?=
 =?utf-8?B?L1YvbVprT0swVzBpWkVWMDA0L1hMOVYwa3lIQ3ZPM0pFN0hwWW43aWNPQkh1?=
 =?utf-8?B?Ync0NkpRUitFZzZYb0o0TFp5UnNQWklHcVBZYTFOMkZTNmZqN2E4UkNIdUk5?=
 =?utf-8?B?Vm5ZMXp2ckVYT0pYYWxqcWRyYzJYUVR2RDZrajY5U09jNm1vTGdob2VGcE9M?=
 =?utf-8?B?VGJxVVdTbnFBVnpUdTZIdStXQkpKUExOVzlPd05Jbmd1MGFUcWVPaWw3eUZx?=
 =?utf-8?B?SkdweFFIc0RYSjJ3a1lFVG5qdDF3WThhdEtvVUVqREUxUDJka1phaEkwVFRl?=
 =?utf-8?B?dUVCUlJBeU02RzNBWEU0bHN3Y2RQYkp0Y3RtRk1kNEJSNWN5K2pxajRNd2t2?=
 =?utf-8?B?UWZSR2VMQzFiUEU0K0NheThXc09YMmY1Kzl1UDRoWGJGVHlDcCtOaVBGWmF6?=
 =?utf-8?B?M0E1MjlMM1hLVjVYZ1NpQ2dQWEhZYitpdk5hU05nMzhrZ0VObFhDS3lydkVO?=
 =?utf-8?B?L3dldWVOTkFxdW05NTJZdy9IRGRtczVHT1duNGxPWGpmcFJvSmN6SzljaGZE?=
 =?utf-8?B?ZTRFeXU1S1hyVXJVMTc0RCtLSWprSHZBWStxdjN4WVBtQTdCUDd5N0lLY1Fs?=
 =?utf-8?B?L1hxaVBETmdVYjYveDJmN1R2TG1kNC85cFAzTndGc1NJNm9SUHZKS1VHRTk2?=
 =?utf-8?B?ZGFTNmFHRkNMU242ZVRSU3NFalE4QjNpdUNmZmZjbmY0UHF1R2N1VGw0dll3?=
 =?utf-8?B?REhHbjVzQXJQUWh4RERxWU9BNW9GWEVsaHQ1bzVnd0pYRlhpZmFqTHdkMWRa?=
 =?utf-8?B?WUFlS2IvaEZGOWEvME5FQ3V5ZkhEd0tLTXN3K2t0aWFwdFBQVFFma3c2STU4?=
 =?utf-8?B?VWhKQkFPallHTzM5a1UxUzV2NWZWRXR1ajQ2ZkIrblkvc0NJbTlKcTNYb3Ja?=
 =?utf-8?B?dnlRM0xrVllsaUtOUnlQUVJ5dGlJQVFjSEJLS2hwS25PbTQ3VEtES2h1ZDh3?=
 =?utf-8?B?S3MvZGNrL09qQURkU29CYnUyUG00QzlWRlNRR0ZleDZmZEZ2WUhWTkhMbEhx?=
 =?utf-8?B?ektGYlZxVUlzUjJqNnNRdlZrTWJ0aTIvOWhucDdSdXpnTDdPQ1AzdEJKeTFx?=
 =?utf-8?B?aGVkUWlxYkJrR3lXZHg3RHhYWWo1MnJBc1hoZDRYaHBUWUltSkVNYnhOVTUz?=
 =?utf-8?B?UjBCSFdXSUpXVDllaVI3Yi9COXlkcEV2R1p1UlNWZG1DdFdNQUJiOUMrOFla?=
 =?utf-8?B?Z2lmSjczZ1dOL2dZU09OZ3pUY3VCekwwTkl0bVR2RVBsVmtacEgvRUNCeEVy?=
 =?utf-8?B?UjVaN2RTY1dFYWdmdVRYWXNHWENqcVpVbzdhK0ZWbC9xSDVSdDB1UUQvbkh5?=
 =?utf-8?B?ejNOekZEVUk4YURleE5mS2ZCc051WGU1TmtSWlZhYjd5a3IzanZDVDhJY3Q0?=
 =?utf-8?B?SjlVMVhQMFpnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUJZeE80SUJzeUNibGREWTdvWVlFZVM1TDVIajIrdVRoOXdjTW9PMGpGZXAv?=
 =?utf-8?B?YjdHa0hGZEo5T1N2bDdkcEhxbUVQREdiMjk4bVlzMHRvMjlYNjM0aGFOVGgw?=
 =?utf-8?B?NXpzeDV3NWxQOTV4V295QUE4akhiN2xWTFpuWFNLQXFZTjVqeU5aRHRHRzJu?=
 =?utf-8?B?WFEwa0Z3cEJ3MFBTbzBSQlB3MjcxNk4yN3lwVGN0UmhRY0FJTTkyR2ovYU9s?=
 =?utf-8?B?aEpJM1RYNWlJWDRtM2RVUWJ6a0VoNHNVM3JxVWRYcUZJQnI2QXpkbU9NaW54?=
 =?utf-8?B?Umh2WUdNR0ZRdWJjcHV0Mi9pMmtDcE83aXgvenlaNDc5ZGEydXEwYVZVbWgw?=
 =?utf-8?B?dWJQNFcvK2gzTXNnTzlYdjJWVHdOVlQvTFRDeHJ5Nk5haXJpYkFONldzUlVn?=
 =?utf-8?B?V3REdlM1N3MzYXhLOWlUV0N2amlibGUzY1kxTTlaZ2JzcFRUYUpVRVlsM1FW?=
 =?utf-8?B?TzhNNWxYY3o3dGFVKy9JeWZ2ejhSbGs3MkQ5NmJIRTcrRHo0WnhhWFJzUFhG?=
 =?utf-8?B?ZDhDZSs0dUZlVXZYWGlnbUtRYlQrSXJ5YWtqRnVIWVJPNm45NEJpajBJYUhj?=
 =?utf-8?B?M1BkYjNEZTdXdUZBMHdpTlltVk82TjdvNzYyWVlpa2xiaEVtQmNsQm1KYUMr?=
 =?utf-8?B?NjZDVEFYWTVBdVU3Q1FEZ00rZXdzbEhrSWtTMFFMdEovM2RjcHhJUHhQclhS?=
 =?utf-8?B?aWplTzdYZklWQ3VvbFJOajNoQy9EYlVjcWJLQndZdkpSRnpPSDZ5N01BNVVa?=
 =?utf-8?B?RzVXNHQxMjk3SGZ2QnVnVkxuc1E3aHpHNWl5cVRNVkVBZTdHV2ZqWktDalR1?=
 =?utf-8?B?TndCandXeCtxN1haWkRuYjBvWS9aYlJ3eFBENEpqU0FRaGdYYk00Y01QSk1E?=
 =?utf-8?B?NWRIdk9JS1gyOHRIWTdmUVpoOWk2RmVjSHQ5MnBwVFdQQUJLa2hwbkQrY2VS?=
 =?utf-8?B?bGk1TFVTcjJqeUdURHhXbzIraW4zZHQyUkdQMHc0NGdTRGNiYVYwdkt3Z3ox?=
 =?utf-8?B?RW5aeStiUzRzL3ViRVNraHJpMXJ2Y210OUYvYzdESVJkY0huYXgySjBhbFBm?=
 =?utf-8?B?OWE5RDJmd2FwK09Wc01xQWdzems4MHQ2Zk1iMUw3OGpjTktxVVdxUmd6elpE?=
 =?utf-8?B?Q3lRT0N2T1lFU1JPd0pQa00zazcyVTFIbHVVdmd0NmpSTG1OeXlsc3hUZU5X?=
 =?utf-8?B?UFlteUc3YlZuM3pkdjdyYVprNG9SNFBUUkJNS0drTHlERGtqMUdoS0g3VG1a?=
 =?utf-8?B?aFAyL3EvUC9JdlhuN3FUV1loOXVOcjQ2dG5GbFFGYmxJOU5RMWtwbmxxVzNM?=
 =?utf-8?B?ZGRaMEF6MFJ2Zkc2cUk2RXFsRHAxdE43QjI5RlBtTzhrMUROZVJDT25FSzRU?=
 =?utf-8?B?WUZpTVh1aEhXVWp4b0JJWXR4YlF0OUdkQlNlcGt4QzdoMWJjam9Yc2lwandv?=
 =?utf-8?B?NVlrUGV3L1VRMlR5eFNJd3cwQVhmV2hQcUgrZ290aHRoajQ5bml1UWVpdEN3?=
 =?utf-8?B?dlovcFh3blFqV1EvTDJ6dCtIYWQrcVFFOTZIRDlhT2lSTUhiVXJpU1NSSmw5?=
 =?utf-8?B?MXZwM0diVGJIVzVTVVBwdWdMSE5URlhaM3I1bzk4K2x6TG5NUEFKWEd3SVVK?=
 =?utf-8?B?T1BoVlJjZlprZmNJcmhpc2NiSTFxellERzlhbEY1bnE4dlNRMThNUVh0QThB?=
 =?utf-8?B?TG5ETlNhbkVjVGRyUnd1Mm55YkhYUW1JaDJ3bldGdi91TkpFRm1WVzNGbDRK?=
 =?utf-8?B?RkJrTmRWU0t6dmVXQUxkclZVZURzcnVpSjBlQnVXTzVlRmtmcERYK3FSb2E5?=
 =?utf-8?B?Lzl3S1NNa1hhS1NKK20yMThLODhvQ2prREQwY1RMR2ovQmZvdXRzajdzMDRC?=
 =?utf-8?B?MEo0ZEdqc3NHMm5WMDRTRXg0TkgwM3Rxamg3L201dURMRE9PVGptOExmUHBR?=
 =?utf-8?B?SXBIcEpUdUdYVG9iZUxlb2pZcmh6eGFqUnpyckxwa0hYMnhhZXJjQmhxZUJh?=
 =?utf-8?B?d2VsbERrdnhiSlg2UkpvZk41Z0dYMDRHUXAyS1NQendQNDMwdTRjaU1yRis4?=
 =?utf-8?B?RUtONGF5U3F1SVBlTGxYTHMrMXFreWRKNVBCT1p4czFnRnJzSUh2bUVPT3N3?=
 =?utf-8?B?VXRrTW1CTHVXaUlaQmkxYkVmSzRlTG1aWUNKMkdSNWlzaXduWnF3Mlc4UkpS?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C9DC711819C4B43978991B6E6C596C4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b3d92f-50e6-442e-e413-08ddb51566bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 00:56:07.8833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ppW6drRWqiUk8yV01Zp5vobUCfhAQ55z/Z2aYWRlh1U60j96w8Wfd5QhJI97uVbc5c82nDiiiLwtvHgicz4EXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7128
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDE1OjMzIC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDYvMjYvMjUgMTU6MjAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gQnV0IElNSE8gd2UgbWF5
IHNob3VsZCBqdXN0IGhhdmUgYSBzaW1wbGUgcG9saWN5IHRoYXQgd2hlbiBhIHBhZ2UgaXMgbWFy
a2VkDQo+ID4gYXMgcG9pc29uZWQsIGl0IHNob3VsZCBuZXZlciBiZSB0b3VjaGVkIGFnYWluLiAg
SXQncyBvbmx5IG9uZSBwYWdlIGFueXdheQ0KPiA+IChmb3Igb25lIFREKSBzbyBsb3NpbmcgdGhh
dCBkb2Vzbid0IHNlZW0gYmFkIHRvIG1lLiAgSWYgd2Ugd2FudCB0byBjbGVhciB0aGUNCj4gPiBw
b2lzb25lZCBwYWdlLCB0aGVuIHBlcmhhcHMgd2Ugc2hvdWxkIG1hcmsgdGhhdCBwYWdlIHRvIGJl
IG5vdC1wb2lzb25lZA0KPiA+IGFnYWluLg0KPiANCj4gVGhlIHNpbXBsZXN0IHBvbGljeSBpcyB0
byBkbyBub3RoaW5nLg0KPiANCj4gVGhlIGtlcm5lbCBvbmx5IGhhcyAyOSBwbGFjZXMgdGhhdCBj
aGVjayBQYWdlSFdQb2lzb24oKS4gSSdkIGd1ZXNzIHRoYXQNCj4gcm91Z2hseSBoYWxmIG9mIHRo
b3NlIGFyZSB0aGUgbWVtb3J5LWZhaWx1cmUuYyBpbmZyYXN0cnVjdHVyZSBhbmQNCj4gYmFyZS1t
aW5pbXVtIGNvZGUgdG8gaGFuZGxlIHBvaXNvbiwgbGlrZSBub3QgYWxsb3dpbmcgcGFnZXMgdG8g
Z28gYmFjaw0KPiBpbnRvIHRoZSBhbGxvY2F0b3IuDQo+IA0KPiBUaGVyZSBhcmUgc29tZXRoaW5n
IGxpa2UgNSwwMDAgbGluZXMgb2YgY29kZSBpbiB0aGUga2VybmVsIHRoYXQgZGVhbA0KPiB3aXRo
IGEgbGl0ZXJhbCAnc3RydWN0IHBhZ2UnLiAyOSBjaGVja3MgZm9yIH41LDAwMCBzaXRlcyBpcyBw
cmV0dHkNCj4gbWludXNjdWxlLiBXZSBvYnZpb3VzbHkgZG9uJ3QgaGF2ZSBhIHBvbGljeSB0aGF0
IGV2ZXJ5IHBsYWNlIHRoYXQgdXNlcw0KPiAnc3RydWN0IHBhZ2UnIG5lZWRzIHRvIGNoZWNrIGZv
ciBwb2lzb24uIFdlIGFsc28gZG9uJ3QgZXZlbiBoYXZlIGENCj4gcG9saWN5IHdoZXJlIHdyaXRl
cyB0byBvciByZWFkcyBmcm9tIGEgcGFnZSBjaGVjayBmb3IgcG9pc29uLg0KDQpJdCB3YXMgbXkg
dW5kZXJzdGFuZGluZyB0aGF0IGlmIHBhZ2UgaXMgbWFya2VkIGFzIHBvaXNvbmVkIHRoZSBrZXJu
ZWwgc2hvdWxkDQpub3QgdG91Y2ggdGhhdCBhZ2Fpbi4gIEkgdGhvdWdodCB0aGUga2VybmVsIHNo
b3VsZCBoYXZlIGFscmVhZHkgaW1wbGVtZW50ZWQNCmluIHRoaXMgd2F5LCBsaWtlIG5vdCBhbGxv
d2luZyBwYWdlcyB0byBnbyBiYWNrIHRvIHRoZSBhbGxvY2F0b3IsIGFuZCB0aGUNCnBsYWNlcyB0
aGF0IHVzZSAnc3RydWN0IHBhZ2UnIHlvdSBtZW50aW9uZWQgc2hvdWxkIGFscmVhZHkga25vdyB0
aGUgcGFnZSBpcw0Kbm90IHBvaXNvbmVkLg0KDQpUaGF0IGJlaW5nIHNhaWQgaXQncyBqdXN0IG15
IGd1ZXNzLCBzbyBteSBiYWQuDQoNCj4gDQo+IFdoeSBpcyB0aGlzIFREWCBjb2RlIHNvIHNwZWNp
YWwgdGhhdCBQYWdlSFdQb2lzb24oKSBuZWVkcyB0byBiZSBjaGVja2VkLg0KPiBGb3IgaW5zdGFu
Y2U6DQo+IA0KPiAkIGdyZXAgLXIgUGFnZUhXUG9pc29uIGFyY2gveDg2Lw0KPiBhcmNoL3g4Ni9r
ZXJuZWwvY3B1L21jZS9jb3JlLmM6CVNldFBhZ2VIV1BvaXNvbihwKTsNCj4gYXJjaC94ODYva2Vy
bmVsL2NwdS9tY2UvY29yZS5jOglTZXRQYWdlSFdQb2lzb24ocCk7DQo+IA0KPiBJbiBvdGhlciB3
b3JkcywgdGhpcyB3b3VsZCBiZSB0aGUgKk9OTFkqIGFyY2gveDg2IHNpdGUuIFdoeT8NCg0KVGhp
cyBpcyB0aGUgY2FzZSB0aGF0IEkga25vdyB0aGUga2VybmVsIGNvdWxkIHRvdWNoIHBvaXNvbmVk
IHBhZ2UuICBBbmQgSQ0KZGlkbid0IGtub3cgd3JpdGluZyB0byBoYXJkd2FyZSBlcnJvciBtZW1v
cnkgaXMgZmluZSwgYnV0IEkgdGhvdWdodCB3ZQ0Kc2hvdWxkIGp1c3Qgc2tpcCBpdCBmb3Igc2Fm
ZXR5Lg0KDQpCdXQgcGVyIFRvbnkgaXQgc2hvdWxkIGJlIGZpbmUgdG8gd3JpdGUgdG8gaXQsIHNv
IEkgYW0gZmluZSB0byBub3QgaGF2ZSB0aGUNClBhZ2VIV1BvaXNvbigpIGNoZWNrIGhlcmUuDQo=

