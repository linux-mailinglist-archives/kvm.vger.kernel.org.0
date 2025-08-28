Return-Path: <kvm+bounces-56171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB66BB3AA96
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E5ED7B9630
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C32233A031;
	Thu, 28 Aug 2025 19:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YqutFkzw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E62322A2C;
	Thu, 28 Aug 2025 19:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756408121; cv=fail; b=sXyncB4DacQULRRQz3vr5jkVeLivRQZoJLy9ibPfSRe5CqQi+ZtQt4mPLtXWF0c/wm/JZr6WRAsZ4ZZKh/mSnZXpxvrLnZhFB2aqiZwWlIgdDcjEyZ6HKlLhmyiEHRy02FzbKmNPy+Ol1zJm0KaxOAhGrezRsD976nf+xUNMsi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756408121; c=relaxed/simple;
	bh=UNmjCDT8ensCavjmohP1RIMJjBq2a6+wYa4voVGjiU4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TsvqmIzwjJ4E2W8VOmOK9j+yyJPGHwTLMj/de9VAgxKAwEPwRgruSkF3EICP/nZYCcUZ/LK3CyWZWv0tTYRduorFTCTRLl/5sxMtBii4ywNY5KKmgotu48jjNpPeHtvIpOAuju/juV2+XAlTvmlbJZVUfe5qhrtgkgjgfe7MQLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YqutFkzw; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756408120; x=1787944120;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UNmjCDT8ensCavjmohP1RIMJjBq2a6+wYa4voVGjiU4=;
  b=YqutFkzw8GqB6D8v7sU9Hvn1x22NEtG0IpJusRGpZA/SQV6bNPs5hNH2
   CnQ/2gyg55EHcHzYRLSiX3H6LyPjfMblMIM4zrCTrMm9uDa3e+Sv7S9ty
   ZJ5h7fRVCnXNMKjKvxNz019HwJt5aDZ58fi+MBC2MmMtU8yKAtPr1PsC7
   8iwO0nsu9jHPPDCYjhn5oYLpQQjz7EkM/ABtKwAcFhJ/5GGtE1JbR1dzF
   ecet6e1DQEcQzIB6IAWozfYA1TBjE8jKY7BSaZS3EREkszDzECafV5qm9
   hR5JsqD+mOXnf6idLqVG8E3BuY26npT2ED3ISDx8ceS1aTieQjI0chLIj
   g==;
X-CSE-ConnectionGUID: 1Ui7h5FHRdmlTCiBkF8reA==
X-CSE-MsgGUID: WXJD69gwRl6GXHMpyg6NlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="70130892"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="70130892"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 12:08:39 -0700
X-CSE-ConnectionGUID: VjYNZdrLT32tVR41wYQfnQ==
X-CSE-MsgGUID: AuJpi51MTzu//oZ/WMWy9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175480064"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 12:08:39 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 12:08:37 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 12:08:37 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.47)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 12:08:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jP/7khHofZKj8COYKBflCujsAeBeU5N0cM+nzYPQNgzG4EVoms/kd+7ZRQc9h6RardNU69+Q0nW/WyCeSknjEIXs5Ho8r0ZJ3rMLDwEAIRcxmAJLs6hxOLGgre+uKjdU7UAq82c/W+9r63NSoMQM1u2f7sCPerWrt4HGtMQfCkeBpggdPZcVpsVQeDmEi/SXbrhnP96NKH6OWEf8Rg14wZbjxoZuYI0lPyT/EI5VXS9FXyvnt/pwbeRdiXwg3eZ+ymP3g81+NabRfi28RRW+G2u1fyRUhMfrfF8ksOwwbSKWB6FGnPF7AZrOW51OoHE+r57EeWoClmxeW2lq9I3ztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNmjCDT8ensCavjmohP1RIMJjBq2a6+wYa4voVGjiU4=;
 b=F83n3FEWVz8Q+mzbBl4Tt/J9ZNIDIEGFRVDRMGvp0GrbipqFqwApqSe19KkRGQAvsPAJIo+ISpByt7dDj/u0X3r2dien6tQBESbOckxE8mjHD5JZ5aiHT3Kv5640T9KNHqn1bQ+pXvQ5Sm820V/qMH+z9k2iU+rARZ7iA24UUTIR/ZhY5E9uQ6SnO1JZXm7dZXDE8OYpYHOrXYxITpMfKWPE9lPIv8DbrSneqppFgW9Hgzkl4SKFMPoicYyaCQNvMnb37wqLubnN+8pe3xHswsSXNK9vIu8fyQUdWBIGWt9fDwT91gc8hjy/+BR9iVOCL2TThLajCuqjxhZoS/3G1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PPF1FCD3EAF0.namprd11.prod.outlook.com (2603:10b6:f:fc00::f12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 19:08:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 19:08:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
Thread-Topic: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Thread-Index: AQHcFuZaMDeZr458G0eulsQOyqpL0bR2NLWAgACpbYCAAIduAIAALZGAgADdWYA=
Date: Thu, 28 Aug 2025 19:08:29 +0000
Message-ID: <8e5cd292a95cb449e22f63661c54dbb86932159c.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-10-seanjc@google.com>
	 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com>
	 <3dc6f577250021f0bda6948dedb4df277f902877.camel@intel.com>
	 <aK/vfyw5lyIZgdH7@yzhao56-desk.sh.intel.com>
In-Reply-To: <aK/vfyw5lyIZgdH7@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PPF1FCD3EAF0:EE_
x-ms-office365-filtering-correlation-id: 07cd8a31-88f8-402a-d8df-08dde6664676
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MytTSjFzWWZ2Y3pXMDFubGFhVURlQi8xcngyQmZQSmVobWY3T1NOMkYrQTNH?=
 =?utf-8?B?cmxJVm5xU2R2YXF6a3QxT2EyRG5BaHgzSzNPdTl4Q3ljek9xS1NoS2VnNmVX?=
 =?utf-8?B?elhweTJuaVZWeDU0ZW5XamhPeFI2Uno2cXkrQ1BobFhqQ2QrbzVZQnhXSWMx?=
 =?utf-8?B?elI4SGJqUHBVNUlyTXdGek9hM0VHQjRNMUpydzZVQngrVHdPaWowbTB2anpm?=
 =?utf-8?B?SjVMQnRuRnB6cUo0VXNSWWVFNVRoY1VHdWN0OHAvWHJoY2M4MFhUZnBKdjBv?=
 =?utf-8?B?ZUVDakJFT3ZLTy91VG5NYVhETG52aDJsbEtQcEFnMlpMeGpRcmFUUzFVZUZM?=
 =?utf-8?B?K3RuNW1ZcDRxSDdaTXNsL2RidWYxUURWYTJzUWdZNWR5SlN4blJjZ1VHSk43?=
 =?utf-8?B?VjQxbnJzdkZyOGNhK0d0ZHE2cEpqbkRIRXpqSE1seU5VME42SVBQOGM5d0F5?=
 =?utf-8?B?VnJXREg3VEtXUXJQUlBsTlhnREsyQWZZZ3RRcDkxeVNZQVpwbmkvMTV1c21j?=
 =?utf-8?B?TWRxR09ZNnF3b0VXQjB6RVJwVi9aQTk1SGZNYzkvQzZzaGRxZWhsM1lhRWxP?=
 =?utf-8?B?SDg2QzFqMExGK0RZOVRmbmpFRUk5MnNJbDNpMk5WWG1IWXZ2K1FwdHdyZzVv?=
 =?utf-8?B?bFFtOHhtdGVwenhTVEFEZmtkb1pmckxoWFZ3UndUWDJxTHFoMkpHbStUZzJl?=
 =?utf-8?B?Vy9sUmU3S1lVZG9jUk1oT3dTd01qY2Z3QUlDNHVlMmJWcHB4VmhrSFdyWFpW?=
 =?utf-8?B?di9QWXAwdmI5OHorYkZMN3c2cHg3dFYzSXU4dGN2eUNZM0NRV0l0ME5QWkk2?=
 =?utf-8?B?TzdEUnd2N0FBT1czUm5ybmJ2SmZGcm9aSzZHU1E0S0hINlhnREZMYktMMWpJ?=
 =?utf-8?B?TmdTWHQ4a2ZWZ2dIYm12SktWb1ZJSjFnd0t6S0dySFVwQzBOdDVneGNhN2tl?=
 =?utf-8?B?c0ZnSk5nbUFVSVRuamVKVU5well4ajhuT0ozekVvaGhuU2llaHNDY1I0TGdC?=
 =?utf-8?B?QWRqTWplZjR6eGZpaDZmQmtMbGNTVXFwcHdoQjhnUmQ1VUhVRzdKZ2lxdjZG?=
 =?utf-8?B?MHI0bkxxTXdjazRrYmNaTFJVYTRXaGtoaEZoYTFFNlU2blE3OEJKcFowenpJ?=
 =?utf-8?B?NmVJS1VOZEU0VXBqWGxKNThqM21FamVXbUhPeEpET3pQWUdHMHE2eWFydGJS?=
 =?utf-8?B?ckI0ZERMcEEwSVZERmw4TDFlNmdQVHEyNm5sUjlhenk4SmZ2bkdNL1F2Z1FW?=
 =?utf-8?B?VjE1UXRibWpvNFpsWWYrRGdvdmEzVFBsWWR4amsvYThpMys2TkQ4MXZSVFRJ?=
 =?utf-8?B?ZFA4bDBxNEZBT212ZFJ5R01KMUxleWhhdjlxVGExMVp5M2NUbjlPeTRLN0R2?=
 =?utf-8?B?TGFiY2MzdmdVdWg2TDdsMTN6TU13c3E1M0taU3Axd0FwNGpLTWt2SUFTdzhj?=
 =?utf-8?B?aEZGTXZINXJ3VVpMNDJLRnd5MUFOSEhRRTBBM1RaUW0rV3BTR2VabGEydmQ5?=
 =?utf-8?B?Nm9JKysxK3Myd2M3NjVWa2Z6bytZSWxEd3E1LzJQRmJSYzkrM1I1Q0dtK2F4?=
 =?utf-8?B?b0J4YVdGMmhUTTJQbEZRK2wrNVo0L214S0VzOUh2WWliOFJSRlh5dE5xMGwx?=
 =?utf-8?B?bi94QWJ6RlFTaE5rNTZUR0liZHFtL2ppWUt3STh3OXdwQ3BaYlZhcEp6NDdJ?=
 =?utf-8?B?U3RZcDhsR0JvUjI3YlUyUnNyMXJPL2hIVUlwTXIrenVMQmJLMVpYYkpKTHZ2?=
 =?utf-8?B?dzhQbjZFcWt2cEp5ZW5WS3VocXdqdlkwai96cE82QW9zbXp3bnR5WHlmWk1i?=
 =?utf-8?B?VXNDbFJTM1p2MzY4ZkljMkpxQVhBL0p3c0I0M2liSzhFZGNOWDNPaGltUDJF?=
 =?utf-8?B?b0lmUmNjdWprbkk4MHNXa2FjUjM4RCtPa2V2aUkyU2xtbU5ybzE3dFdqdldr?=
 =?utf-8?B?bFhRNFBCdFNnY0ZPdXZUZkxvRm56SUpYNzU3cmNFelRrYkM4dkJDd1Q2cmRa?=
 =?utf-8?Q?7/eZV5nq9oqROgX2gnF/ulBM6x96r8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnZuZE5qUkFaWlZjVzVKajVuemx2SkMxVTlkUHpMcithcVZDeDA3N1REeDdS?=
 =?utf-8?B?MEEzdGczMloxOHFucXhFZEpISmYzVDhvKzlRR0loQzh2dE9RT05YVUxla2NM?=
 =?utf-8?B?d3BwZWdCUXhnWGRQRmd5OFNxNWxnRmxFK29TWjJWT3pzSDhjbjhDN2xJY3cr?=
 =?utf-8?B?Q2tYZFBuSnZtQkdFc09WUlJIamhJMzIrODJGY2t1dlkxWC93QWlXMEgxV01v?=
 =?utf-8?B?R2tKS2tHdDNKZ0VuTkZTSFFhbmpmcGVmQm9odHV2bEhFQWdkNkVKTU1IRFRU?=
 =?utf-8?B?dEcwaVc0cEdaK1lUOGRYcENoRnJlSnozaXJoSzQ1TUdab0NKeWtvQSttekFt?=
 =?utf-8?B?cHhiMVRQb1hUU1diclY4VFhLeGVHYWFoVnBTS2FaRnQvRnFETDN5TmFHM0Zh?=
 =?utf-8?B?bGxOYU1jQlQwNEI1UGcyN3ZjK0NGcE8zcU9FMDVocVBhQmYyU1pFNzdKcXM3?=
 =?utf-8?B?TnY3ZFZVTUNIbHA1UGdPZ3dGM0xUdGdDcmpGYmx3czN3eUYzZlpua1JPbDFB?=
 =?utf-8?B?ZEE2SzNON0IraGdRVWVvOEtYRXpvUXVXaWNhbTRnTlljWENVbWQ3MkhPRHJt?=
 =?utf-8?B?UWoxSUxpNE02ckNKVmw5blI2Z3Z0RFYxTzRENnk5UjkyelBDakZTMVRURXVn?=
 =?utf-8?B?cjBpaEcwUWloTFNCQUVLenJWRm9KMkhBQXppMDc0WVJmai9NM2JXcXlKeEp0?=
 =?utf-8?B?a09kK3JBRjVHV3ZDbnJZRUlvODNYMG9UcnEvbXBqSmRxVmNBQTFER2pJbTRu?=
 =?utf-8?B?Z2xKWjdlamVoNUpvN3M3UXdtbmxLNG9UVi8ySGxZSFQ2aTlzMG92eDh0UWVK?=
 =?utf-8?B?Tkt0cytXSWE2TW95RmRlR0RzbVozZFdUZ2c0Nm41bXBOSURkdXhaaUN0blBw?=
 =?utf-8?B?RXRuOUtKS3lPcUJETGFUVGhDOWNqSGVTdGx5akJmaTE5Y053M2xsUkdtTmhL?=
 =?utf-8?B?UFQ4MVgyT0dYdW93THI4TUhxZDNEdVplNFpnMEl1Y2NZdWZibWpqM0I4UFhD?=
 =?utf-8?B?bHd0dFFxRTBLc1F4cHp2L2dIVDhXM250alhieGpuR2hHd3Y4SjlmTGIrc0hV?=
 =?utf-8?B?MTd3RUxXMTBFWWdMWXVKVXExeWxBZWNuRUxQTlI1bG42VVMrS0dEOS9wUzI0?=
 =?utf-8?B?YjlLL0pNR0ljSGVualRuaVJ6dHpuRDFFdXZGdnRjb3JSaWY5WFo2MUpTVmV3?=
 =?utf-8?B?Sm9PakhzQVdwRDZVOWF2MEZESUFvQXlGSmhnZmZnQWc2U0RFOGJ0SndRMSsr?=
 =?utf-8?B?N2N6c3l4dFZtb05HOGRjWFluMzErVHY2bzV2eDdhVllWeG5xS0tlQXk4WHJp?=
 =?utf-8?B?SGVBQlE0R0RnVjkvU3R2ZDBBd3B2emwzdXQxd3o5eWY1ZGExZDVvZGZNSFFp?=
 =?utf-8?B?SzdiOEhJd0lab0FMMXFjSWE5dFBKUU5rNS8wMnhVa1NIbW9oNW85SlEyei9R?=
 =?utf-8?B?Nll0c3pqR3RFejh4ZlN1TXhNSU9SeUZxU2RwTjJXdkI5ZEc0MEl1dnV6VFR1?=
 =?utf-8?B?NUx3MjExOEVHNCtUdlltYzVJWVgvTHBLOUYrMDZkQUJQcDRjSUJEKzM5R2hr?=
 =?utf-8?B?bFVBSUZwWDB6bHA3WUVpQjlBQ0RPNStFd1AyMG9Oa25qdHlhdTBwQmpIa0sy?=
 =?utf-8?B?Mnl3WW9ZYzRnQzdYOURkNTN0eUkva2lxU2lOd1oxTHRJT3VOZk90ZTF3dzBK?=
 =?utf-8?B?UkFUZHpRSHJEYmUxM0oyV0hkSEo5QnAxMGNiNlJ0SnZTb2RUYzZsRHVVNUxv?=
 =?utf-8?B?d2pIMUxZTVgva3hiZUNaZkVENENYNUpHQW1CQ2RLb1E4a0NheitPMk11RTNy?=
 =?utf-8?B?ZkdSaE5WakRmWldXeWR6YWlpc0p0QXV3a3R4V2NVd0xDMHVOTm5UeDlGSEFl?=
 =?utf-8?B?a1QwRzRWc2R3VUE5QkU2SnBFQmFFTzhGeE5kVHlrNVVyZ3JKNnZZV2p1Q29r?=
 =?utf-8?B?dUp5WnVEZzJkbmVFbmo5aHAvcnJKN3JiajVwNnJiMGowWlJJbkZYWkkvMUNu?=
 =?utf-8?B?d2x0UHU4NENsSzQ3anZKKzJIc0g3MnJVelpIVWlTRENzc3dvRm0wRzJsdXda?=
 =?utf-8?B?QmJtM0tKYkZvdW5oN0loRE1sUHdWZTJJNW1HTWY4VTNjWGNFMmFxSVQzZjB3?=
 =?utf-8?B?RVBxOE9IT1ZKMGNJZk9wOXJLWjVLVVV5MkdqTk1EdW80b2lrdE8zZmg4Nytk?=
 =?utf-8?B?RXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A47FC834F701347857B015E8577E4BC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cd8a31-88f8-402a-d8df-08dde6664676
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 19:08:29.9566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IFIH7ELfiCbyeIg8db1wKZc6beTKpv4F6tocqOdljRE70/jokd7aRAiYgGgHldQFPrP3uO3+VdF1HiVig9zmiCGOvUOPM2dWyXUE/ivHw6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1FCD3EAF0
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDEzOjU2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBS
ZWFzb25zIHRoYXQgdGRoX21lbV9wYWdlX2FkZCgpIGNvdWxkIGdldCBCVVNZOg0KPiA+IDEuIElm
IHR3byB2Q1BVJ3MgdHJpZWQgdG8gdGRoX21lbV9wYWdlX2FkZCgpIHRoZSBzYW1lIGdwYSBhdCB0
aGUgc2FtZSB0aW1lwqANCj4gPiB0aGV5DQo+ID4gY291bGQgY29udGVuZCB0aGUgU0VQVCBlbnRy
eSBsb2NrDQo+ID4gMi4gSWYgb25lIHZDUFUgdHJpZXMgdG8gdGRoX21lbV9wYWdlX2FkZCgpIHdo
aWxlIHRoZSBvdGhlciB6YXBzIChpLmUuDQo+ID4gdGRoX21lbV9yYW5nZV9ibG9jaygpKS4NCj4g
SG1tLCB0d28gdGRoX21lbV9wYWdlX2FkZCgpcyBjYW4ndCBjb250ZW5kIGFzIHRoZXkgYXJlIHBy
b3RlY3RlZCBieSBib3RoDQo+IHNsb3RfbG9jayBhbmQgZmlsZW1hcCBsb2NrLg0KPiANCj4gV2l0
aCByZWdhcmQgdG8gdGhlIGNvbnRlbnRpb24gdG8gdGRoX21lbV9yYW5nZV9ibG9jaygpLCBwbGVh
c2UgY2hlY2sgbXkNCj4gYW5hbHlzaXMgYXQgdGhlIGFib3ZlIFsxXS4NCg0KVGhlIGFuYWx5c2lz
IG1pc3NlZCB0aGUgdGRoX21lbV9wYWdlX2FkZCgpIGZhaWx1cmUgcGF0aA0KDQo+IA0KPiB0ZGhf
bWVtX3BhZ2VfYWRkKCkgY291bGQgZ2V0IEJVU1kgdGhvdWdoLCB3aGVuIGEgbWlzYmVoYXZlZCB1
c2Vyc3BhY2UgaW52b2tlcw0KPiBLVk1fVERYX0lOSVRfTUVNX1JFR0lPTiBvbiBvbmUgdkNQVSB3
aGlsZSBpbml0aWFsaXppbmcgYW5vdGhlciB2Q1BVLg0KPiANCj4gUGxlYXNlIGNoZWNrIG1vcmUg
ZGV0YWlscyBhdCBbMl0uDQo+IA0KPiBbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIw
MjUwMTEzMDIxMDUwLjE4ODI4LTEteWFuLnkuemhhb0BpbnRlbC5jb20vDQoNCkFoLCB0aGUgVERS
IGxvY2suIEkgYWN0dWFsbHkgcmVmZXJyZWQgdG8gYW4gb2xkZXIgdmVyc2lvbiBvZiB5b3VyIGxv
Y2tpbmcNCmFuYWx5c2lzIHRoYXQgZGlkbid0IGhhdmUgdGhhdCBvbmUuIEJ1dCB0aGlzIG1lYW5z
IHRoZSBwcmVtYXAgY291bnQgY291bGQgZ2V0DQpvdXQgb2Ygc3luYyBmb3IgdGhhdCByZWFzb24g
dG9vLg0KDQo+IA0KPiANCj4gPiBJIGd1ZXNzIHNpbmNlIHdlIGRvbid0IGhvbGQgTU1VIGxvY2sg
d2hpbGUgd2UgdGRoX21lbV9wYWdlX2FkZCgpLCAyIGlzIGENCj4gPiBwb3NzaWJpbGl0eS4NCj4g
MiBpcyBwb3NzaWJsZSBvbmx5IGZvciBwYXJhbm9pZCB6YXBzLg0KPiBTZWUgImNhc2UgMy4gVW5l
eHBlY3RlZCB6YXBzIiBpbiBbMV0uDQoNClNlYW4ncyBsb2NrZGVwIGFzc2VydCBoYW5kbGVzIGhh
bGYgb2YgdGhvc2UgY2FzZXMuIE1heWJlIHdlIGNvdWxkIGFsc28gcmUtDQpjb25zaWRlciBhIEtW
TV9CVUdfT04oKSBpbiB0aGUgaW52YWxpZCB6YXAgcGF0aHMgYWdhaW4gaWYgaXQgY29tZXMgdG8g
aXQuDQoNCj4gDQo+IA0KPiA+ID4gV2hhdCByZWFzb25hYmxlIHVzZSBjYXNlIGlzIHRoZXJlIGZv
ciBncmFjZWZ1bGx5IGhhbmRsaW5nDQo+ID4gPiB0ZGhfbWVtX3BhZ2VfYWRkKCkNCj4gPiA+IGZh
aWx1cmU/DQo+ID4gPiANCj4gPiA+IElmIHRoZXJlIGlzIGEgbmVlZCB0byBoYW5kbGUgZmFpbHVy
ZSwgSSBnb3R0YSBpbWFnaW5lIGl0J3Mgb25seSBmb3IgdGhlIC0NCj4gPiA+IEVCVVNZDQo+ID4g
PiBjYXNlLsKgIEFuZCBpZiBpdCdzIG9ubHkgZm9yIC1FQlVTWSwgd2h5IGNhbid0IHRoYXQgYmUg
aGFuZGxlZCBieSByZXRyeWluZw0KPiA+ID4gaW4NCj4gPiA+IHRkeF92Y3B1X2luaXRfbWVtX3Jl
Z2lvbigpP8KgIElmIHRkeF92Y3B1X2luaXRfbWVtX3JlZ2lvbigpIGd1YXJhbnRlZXMgdGhhdA0K
PiA+ID4gYWxsDQo+ID4gPiBwYWdlcyBtYXBwZWQgaW50byB0aGUgUy1FUFQgYXJlIEFERGVkLCB0
aGVuIGl0IGNhbiBhc3NlcnQgdGhhdCB0aGVyZSBhcmUNCj4gPiA+IG5vDQo+ID4gPiBwZW5kaW5n
IHBhZ2VzIHdoZW4gaXQgY29tcGxldGVzIChldmVuIGlmIGl0ICJmYWlscyIpLCBhbmQgc2ltaWxh
cmx5DQo+ID4gPiB0ZHhfdGRfZmluYWxpemUoKSBjYW4gS1ZNX0JVR19PTi9XQVJOX09OIHRoZSBu
dW1iZXIgb2YgcGVuZGluZyBwYWdlcyBiZWluZw0KPiA+ID4gbm9uLXplcm8uDQo+ID4gDQo+ID4g
TWF5YmUgd2UgY291bGQgdGFrZSBtbXUgd3JpdGUgbG9jayBmb3IgdGhlIHJldHJ5IG9mIHRkaF9t
ZW1fcGFnZV9hZGQoKS4gT3INCj4gPiBtYXliZQ0KPiA+IGV2ZW4gZm9yIGEgc2luZ2xlIGNhbGwg
b2YgaXQsIHVudGlsIHNvbWVvbmUgd2FudHMgdG8gcGFyYWxsZWxpemUgdGhlDQo+ID4gb3BlcmF0
aW9uLg0KPiBIbW0uIEkgcHJlZmVyIHJldHVybmluZyAtQlVTWSBkaXJlY3RseSBhcyBpbnZva2lu
ZyBLVk1fVERYX0lOSVRfTUVNX1JFR0lPTiANCj4gYmVmb3JlIGZpbmlzaGluZyBpbml0aWFsaXpp
bmcgYWxsIHZDUFVzIGFyZSB1bmNvbW1vbi4NCg0KSSB3YXMgbG9va2luZyBndWFyYW50ZWVpbmcg
aXRzIHN1Y2Nlc3Mgd2hlbiBTZWFuIHBvc3RlZCBoaXMgc3VnZ2VzdGlvbiB0byByZXR1cm4NCnRv
IHRoZSBvcmlnaW5hbCBwYXR0ZXJuLiBJJ20gaW4gZmF2b3Igb2YgdGhhdCBkaXJlY3Rpb24uIElm
IHlvdSBhZ3JlZSB3ZSBjYW4NCmNhbGwgdGhpcyBtb290LiANCg==

