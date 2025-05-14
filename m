Return-Path: <kvm+bounces-46406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 528AEAB6009
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 02:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAB3C16E734
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 00:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312382F2A;
	Wed, 14 May 2025 00:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P8kGHQ/W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BDE819;
	Wed, 14 May 2025 00:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747181264; cv=fail; b=AKbft4/NJ0xghteL0eATJxyDwYHWdHIigdzo4kopZYEGSi2YBREVIfebtRncOH+hKFljopfRl601YCWOew382S39+5MdfDrsOjCV4jZWKaaqOOXlSWFfDxMHvg6xGM/aPYl7yygGdnRPRg3n5C2LteZKnkAx9qO/2JBuRo7Lypw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747181264; c=relaxed/simple;
	bh=zKWDSCSD5yeyHu3bnJm4XQp6XLCEEWeUYpcESIQE5QU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iRBbONsnCD8m9S2Zk2St/4L5I/inTrUWw6lMrW5scR4W5V1WH4x0FxdDQz+NJQJ3jkAij7auonDTcCtOew2q/X67fxIc64roQWYxXJbGxIQSXRfF1myG3NLTWjjA3+8URf7gqLiZFiyCqMhnaeyyqGpf4ESUPuxzlZAnpZzGtig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P8kGHQ/W; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747181262; x=1778717262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zKWDSCSD5yeyHu3bnJm4XQp6XLCEEWeUYpcESIQE5QU=;
  b=P8kGHQ/W5NaPG7uQ6eX0UNazSucRAfCQTsc0BhciZppm+mliA1lv0ohp
   gCFp5RLOKcfgzAvbBAnKnIMSrXeDVpDSCIe4Oi7Y58sj7qFmj8HRMpPS3
   DyfhWa+7t7nENeyFSU9MjktFIYTyl6ruOyWW1Sv2rsWxzAQFd0G38564O
   KU6/aLg6QeBgj5eOFI2GtTkPEq5Rq8ghpD/0FKNaA0lKiUxyvimzO4d+O
   3gvsp3ub3aDvdkNVx2cop4wb/jB0Un+i7Cpa5KvqXK42fgs+xmb97JBhU
   EqxSBs2XdXh/JuvqnSpHL+bGvPTaIOeQa9bxnPEF5Zg4Fe76yBdNgXhDZ
   w==;
X-CSE-ConnectionGUID: UMYloQUXTRS76BnGPtTmDg==
X-CSE-MsgGUID: jKoM9NJfSQ+FwDNGRDchYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="66466886"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="66466886"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 17:07:42 -0700
X-CSE-ConnectionGUID: MaaPpqe/QCKefcNXqwmFow==
X-CSE-MsgGUID: Jfu4JxOAREG7NWUrP3liyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="137739143"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 17:07:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 17:07:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 17:07:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 17:07:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSFWZw66wM3EdhVSoG/l782J6MoCOPxkJOOjNOzAWk/0s8vOskB4T2QHx12fscOP1TwtWrB04cED2QAUHRHWVbUE6sY0ghksrJXBz+vFwR1neMaszFAw/OaZToXU3mBumqgOGOM+V+PBsCQdKWyJ1NazMeTwXMjQ65BmKG7XdlXZi5rLAYF/HfBwWpq5nv6xNFCcq1nWDgBkuAy2rMx0ykm0nV19F4b9KUsBm3EQv62prmwbijToCBQtEg4RRbxbwqQCrytK2Q/RplMsh5zwDaSP1vpjDPNk5nEYwvuEw/MxMOV3R91nmbCITbHCrbLXtul8JgW01rFmOmI6ZYCG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKWDSCSD5yeyHu3bnJm4XQp6XLCEEWeUYpcESIQE5QU=;
 b=R8kL0ApL5FyohLqVz5o06NsEtIgOBjNcPlnVRD0b0LLIuFjNWVd5mvSO7OEI1pECzqv4DOKHtK5lkR4XZpoyrmfrLyUQOF+i/q1DMVj4Aix69bqVSozFLMbgHo662kW7ohnFbyH8W+9ZLBEb9dWe1JJVtncfPvAJt1twG8ZJtdFl9EYhM/R91Xcw/Z0Clh+wztnLAj8Zw8XNav8kcNDBj73jLxQWraNwq6qFC27ph8P9hazIx2L/GPfovt8wc2irwS/5p9wtNSY6OXszC7PvGZfItuwqto7gbIR5EyXU287Pr3jt6rNbnpRioaFhXURuAAncFxeVwLOrIWdV4p8baw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3303.namprd11.prod.outlook.com (2603:10b6:a03:18::15)
 by BL3PR11MB6506.namprd11.prod.outlook.com (2603:10b6:208:38d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Wed, 14 May
 2025 00:07:37 +0000
Received: from BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c]) by BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c%6]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 00:07:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 09/12] KVM: TDX: Preallocate PAMT pages to be used in
 page fault path
Thread-Topic: [RFC, PATCH 09/12] KVM: TDX: Preallocate PAMT pages to be used
 in page fault path
Thread-Index: AQHbu2NZtY7z1A7uyUaQkDKwbSADL7PRUZqA
Date: Wed, 14 May 2025 00:07:37 +0000
Message-ID: <4c0c38c65ea62266a45223e2268b577a10585f45.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-10-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250502130828.4071412-10-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3303:EE_|BL3PR11MB6506:EE_
x-ms-office365-filtering-correlation-id: 5b0cb0d5-e158-44a4-cee6-08dd927b55da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Uk5ubzh5a1FSQ2dnTkZsL0IyRHhWNHF4cGd0Q3hPTVVuVXQxUnVzRytMNU9L?=
 =?utf-8?B?TE9jd1FIc2NTWXpZK3Q4VTAzNmthL3B0UXY3SkxNMGRwSDArY3I5Nk1qMFp5?=
 =?utf-8?B?Z0QxZ0YxQjlYc3hURXYvZ0hRUEhiVkEraFRxVVJZT3EzdGJueTZjZWxKWE13?=
 =?utf-8?B?VGcyUlBzQ2JqVmtaN09WTUFJaXBXd3QwVDVyUENySWtORG1CQSswclFnZDFG?=
 =?utf-8?B?UnljUEN1TUFsSnlsajZFTnptY0EwYnQyak5NRXZPK2VrYTQxclVEOHhIdEZq?=
 =?utf-8?B?ZjJWaFplSWJlaWYwQjVyWmg3QkNXVFJ6WkM1aHBYVzdnTFprazBMNUdLZWhh?=
 =?utf-8?B?MTJ1VDZQeTRkOE9ocnRJM2p3TURtMUlFTldjQU9sY21VZmpHNXJkWFBFNlNP?=
 =?utf-8?B?eFBPWTFEVVMxM1V2NUJmUmFYU2NDRE85cjcrdWVsWUkwUGtsVFZtcnBMWHZT?=
 =?utf-8?B?VkdnWUZHQkpXMThBWXl1N2dtZ3JIenEzb1owSDdiRXhYNzAwdWZDQzRndUd4?=
 =?utf-8?B?cmpyYk5HcUo2UUhSQzltM1ZHbWx2NmkvazcxODBkaEJOZkNqNXN6bFdBNFB5?=
 =?utf-8?B?NHlKS1BxWEhRemNxSTl5Zzl5NTRWdG1pVXowTXlBMTNLTjVuamdHVkpwYnAy?=
 =?utf-8?B?MmV2ZkRiZ2c4L1lJTXkvVVZVekxOVTM5MkphSUVqNnRyNFJQRld2Z3ZIR0xM?=
 =?utf-8?B?Y05kRk9RR0xXQ0pPVmxnYTQwSjdXWkZ1eXRwOHhRNzh3MkExOVR6T0NpU0F2?=
 =?utf-8?B?Y2t5bHpRN3VkRitTQjJXN3AxeGpBeEZ6aENJQ21XNE1HM3A0TUxBWUpqT0JI?=
 =?utf-8?B?TDRQeVZ3bFc4TklvK1V6Y3V4Uld6RHR5RVNJbTB3aFdqZjNtTGQyYXMrbWNZ?=
 =?utf-8?B?azhNUVNJUjlkN2FBWGlIODVsRDNJL1E3anB6eG56aWNqSGJ1MkVTYzVPbDJm?=
 =?utf-8?B?TDd2RnlIc05Xd0NCN3VhYUtGUkNaZS9xWjRUVWtYUm9pRm1OYnZqTWhGNmZN?=
 =?utf-8?B?bm1FZ2tSTUw0Nm9xNUphdytBSUJYUmcrUGxJMHk0a0prVExscmZHVm5VY1U3?=
 =?utf-8?B?KzhkVytaWk5WTk9uRG85QkF5Wk1iaDhDM1Jvci91dnRYOWhZTlp0OXEzUUVq?=
 =?utf-8?B?V1ZXb2d4SlMxdEZpcnhXTEpScDdWcXBMWXJJMjZzMUFXOFBUWURCcGlKek9Q?=
 =?utf-8?B?QjFIU2cxZzcvUVlqbkE4TzZjZk1xOWRKOG90M2VvWXBvWlhpWklBc2VScDFE?=
 =?utf-8?B?b1V2Q21FeE9UL0JKcWtWL0dieUVnNzdpb0dkTjJ6VEVWYmJJaE1pcTlqay84?=
 =?utf-8?B?U2R1RG1QbUsvNDZZZ2dqUnlwekVDUkVFNjhxSG5nUHBPRHhuaTcwZ1paSlFG?=
 =?utf-8?B?R2h1RG85K1JxbnRUOE16Z1RnbWE1WmtGR0p3NEZCRzFEdXRpbEljeVQ1T3ZB?=
 =?utf-8?B?LytudUJHZUIrbTFsY2ZXZnNwNmpjRTlkQ2NPT2dLQkZOU01ENDUranF4WkZo?=
 =?utf-8?B?bzEremJtQ0Z0V3RTOUpYaFpURTljUUhmT2paUjZyRWVWM2d3OVhaTGhBUEl6?=
 =?utf-8?B?c0RPcldWTnJZTFpjVjRwRlNnd3pUUFQ1aUdRVWVWcjZQSlB2dUNvMmxHRzdO?=
 =?utf-8?B?OC9YMFN3ay9LYm9tYm45T2ZST3Fac09GbElQbVkwdmY1SXh3Ti9neERzZS94?=
 =?utf-8?B?cHZjekVPaUc1TGxjUy90UFRxVWZlVnZRM3pwYXFaSUdiQzdTYmYxZDZ3WXBk?=
 =?utf-8?B?aGlUdW0zODJQbXo4RUQ1VjRGSldFTkh6b2p2clZ0TTBoV0I4TFlVN1hSd2tL?=
 =?utf-8?B?YjJZVTFRVXFBcFlHUFJhMm5mQ1Vka09aN1RBS0pwbTMzc3F3VnJxQU5YWlhy?=
 =?utf-8?B?eFRKZDZRNGJhUVRiQ0JmVUxjZDBhbXlUb2NYWXh0bzhGQmUxM2pmeVgzVzFw?=
 =?utf-8?B?bW12VXVCdXJQdmVWbUJjU2dyN29aTTZTRkVWS2RGZUo5cjI4enFRbEZpdWlk?=
 =?utf-8?Q?F5JYvR6qyE1BnUa3QE/a3SA4CgWTX0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3303.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1JTNkMvWGtwU2Vwdklick5kUDNiYnRYb1dIY0hiZnpmTUZCVmoxWDRZYllm?=
 =?utf-8?B?WmVnZEkxNjlmdUlRMitYdGxiY1pDWDlOOXVLT0o3SUVLc3crdWtyZFh0WS9l?=
 =?utf-8?B?YVo0WWFYSHVKcXhMdzhXNDkzNytoVXNuczdJb0MwcEwzamxwSnVRcnJwemFM?=
 =?utf-8?B?eHN0ZE9lM25HbTlwbzUvS0Rld0dxdjIxWjFYcEhpMGV6bzU0ekJvM1NQQU9E?=
 =?utf-8?B?YTlEVExCUG1oNWdWRURhdG9EMVY4cTJCMWNKZnlpcGV2OU9tY2pFNEdUN29S?=
 =?utf-8?B?cEYrNVphV0ZEeDNLZ2Fobm1USklFTFFqS25JOXdsbUhINWhiMEVIYm5qSmdq?=
 =?utf-8?B?NEt1ZXdsNFZNZzkwZDZGN3hzOTJSR2RwY2FTQXB1WjZoTjMxUVBJNEptL1ZX?=
 =?utf-8?B?c2g2TTJId1E0OWpsZ0tsSUxObnRDYjRHNnRWNXp3a3FBVFBKQmRqRHhFK01X?=
 =?utf-8?B?U1pNc21MVWZCcTc5S1RuemZUWDVlbHZ5TzZBSm5vMzZFRmsxa3RSYXlGVDYy?=
 =?utf-8?B?NmZSVzhidS9QNjZERnhjRVZ6SnZLR25sS3NNSWdweDRGdEo1RzFZSUJ0TTAx?=
 =?utf-8?B?RDV0NXp3dFZLaGRkYmw1VTh2bHgvWGozd0lyaVJ2bkI5Rml3RzdDVDQ3N0pu?=
 =?utf-8?B?VjVLbkJpY2l6UEE5Wk5TK0xWcmdvdW40SjRwRmdSTzZQS1FBSWZVamhkaEh2?=
 =?utf-8?B?NVFUWHd2WHgrMG9TYkt6SU1IU1JMTlZLSmxkNDlpTW1BaTUrd2lPcDZiN1VT?=
 =?utf-8?B?QlhEMFkyOFJEQk5NVllXNFdtSDQ5MzdDaEF0eURyT0RLbGk1TUdlNTNyRXds?=
 =?utf-8?B?alpPUlFScTV0dENMYjRJcFFCSkhzMTlSNkxlVEM1VEZDZDlLcng3QlRPNW1H?=
 =?utf-8?B?T3VXNVJldnlvY0lxMmk2WHk0UnVaNnVwWEw4Y3Bzd1E4ck41YTFKNDRYcjBi?=
 =?utf-8?B?QWUva01FNWVQaEd3NlVLNDdmY3hPejNld21obEIwcEl4R1Y4cURNZGhITEds?=
 =?utf-8?B?K0h0MkNiRVFYc1dMV2VBcmYxeVR2Z3BGSzZJSFVSU1dHMXZTWlVKcklJNVBs?=
 =?utf-8?B?TURTRXhIcUVIZnV5aXRMZzB2amxvbldqOGpCS2lrRHp0QllSdUU0OEI2bGps?=
 =?utf-8?B?Q0JRWUdGY0IxKzNIb2p4bVF1d3RodjRRSlFSc0JZRTBCYVlOK2pWVGtNVGFI?=
 =?utf-8?B?OWxQazBPRVBsbHA0L3RVNFR4Uy9pMVhpZllTVUpldmsrV3NSRmNDbGRQL29z?=
 =?utf-8?B?Nm41bzVMZFdjTnMwWG5PV1FYcDJlaUJRY3ZUbGFSdGplR1J5TGQxSndncVpj?=
 =?utf-8?B?V1lGc1NLa2lMU2g1Uyt6bHlvVFJGSGdsUndHbTI1U0RiQzhpR3NmOFZBUXVo?=
 =?utf-8?B?T01leFNGY1hZMFdLNVRzdFZWaE56NmN5WWpsMnVtT25jQWQza1pBbFlXdWd4?=
 =?utf-8?B?SXNNNS9nWmNtL1VzNlBHc1BDSkdLMkloVHJqc055RTYyMXA2VnE2RDRBZ0Zx?=
 =?utf-8?B?cGNtYXZrSFFjM013SFM2cko4OWZySi8yRkczdUd3ZlpLRHdZNC9RcFlDdFAy?=
 =?utf-8?B?WDNZbDlEZGlzMmU0TENYbmhqSHIzbkV4OVpPTHlJOEFMWGFNQ1VPdVM4a2tr?=
 =?utf-8?B?S3paaTN5Q1JtN0ppcG5UNnpocWlaNXFNSEhCcElkcVlvZDl1R2ZsTHkzVkpp?=
 =?utf-8?B?UjJNT0kwYitFS1BITzZ0WlhGdnNDYjBzYk1GU3RGczR1cXhraGR4bUU1c1Bj?=
 =?utf-8?B?TTJhczNXays0blkvb2l1RGNyT29yK1lPOVNvcWVSUlRlRTc1bjJsUUVuQUd2?=
 =?utf-8?B?NjZndWhjckQ1cXhPUzUrcTlidzdxcVRwU0Y3eHhHYUtZL2xwalVpSzA4WDRP?=
 =?utf-8?B?MnladmRmenFjQ1pGRWswbC9DMTRuaTNobDc1eUJLclZLem1UZHpBN2RoSXkr?=
 =?utf-8?B?UUJhdEpKcVgxc0pKYjhZbTc5M0N2dGVTbkptSUlQSEFWODNyZnUxTXMvTzlI?=
 =?utf-8?B?SHJleS9tMG16NGZwVjZUYUF2K2FFbDVqcVhFSGtvZ1JGN0t1RUNMTlF6YVlo?=
 =?utf-8?B?UXkzZTJud1V6VTdScW91ZTZQZXRkdnRYa1JxNWVFeUxkUEtyQklWVmZFaG8w?=
 =?utf-8?Q?2eLWZkdV2OKPtz0OQWwTpQqON?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06AA2131B1DEA74EA0E63607BEA99991@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3303.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0cb0d5-e158-44a4-cee6-08dd927b55da
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 00:07:37.5482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RAk0lSVPYpB9Rkya4sWxupTnNJ8QINip2QUNg3eLucodY3OLEozkFI2/QGjui/topF1pDy/XCqhI5t7WpZGWDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6506
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTAyIGF0IDE2OjA4ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IFByZWFsbG9jYXRlIGEgcGFnZSB0byBiZSB1c2VkIGluIHRoZSBsaW5rX2V4dGVybmFs
X3NwdCgpIGFuZA0KPiBzZXRfZXh0ZXJuYWxfc3B0ZSgpIHBhdGhzLg0KPiANCj4gSW4gdGhlIHdv
cnN0LWNhc2Ugc2NlbmFyaW8sIGhhbmRsaW5nIGEgcGFnZSBmYXVsdCBtaWdodCByZXF1aXJlIGEN
Cj4gdGR4X25yX3BhbXRfcGFnZXMoKSBwYWdlcyBmb3IgZWFjaCBwYWdlIHRhYmxlIGxldmVsLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogS2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZA
bGludXguaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0
LmggfCAgMiArKw0KPiAgYXJjaC94ODYva3ZtL21tdS9tbXUuYyAgICAgICAgICB8IDEwICsrKysr
KysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oDQo+IGluZGV4IDkxOTU4YzU1ZjkxOC4uYTU2NjE0OTlhMTc2IDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ICsrKyBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gQEAgLTg0OSw2ICs4NDksOCBAQCBzdHJ1Y3Qg
a3ZtX3ZjcHVfYXJjaCB7DQo+ICAJICovDQo+ICAJc3RydWN0IGt2bV9tbXVfbWVtb3J5X2NhY2hl
IG1tdV9leHRlcm5hbF9zcHRfY2FjaGU7DQo+ICANCj4gKwlzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlf
Y2FjaGUgcGFtdF9wYWdlX2NhY2hlOw0KPiArDQo+ICAJLyoNCj4gIAkgKiBRRU1VIHVzZXJzcGFj
ZSBhbmQgdGhlIGd1ZXN0IGVhY2ggaGF2ZSB0aGVpciBvd24gRlBVIHN0YXRlLg0KPiAgCSAqIElu
IHZjcHVfcnVuLCB3ZSBzd2l0Y2ggYmV0d2VlbiB0aGUgdXNlciBhbmQgZ3Vlc3QgRlBVIGNvbnRl
eHRzLg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2
bS9tbXUvbW11LmMNCj4gaW5kZXggYTI4NGRjZTIyN2EwLi43YmZhMGRjNTA0NDAgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9t
bXUuYw0KPiBAQCAtNjE2LDYgKzYxNiwxNSBAQCBzdGF0aWMgaW50IG1tdV90b3B1cF9tZW1vcnlf
Y2FjaGVzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBtYXliZV9pbmRpcmVjdCkNCj4gIAkJ
aWYgKHIpDQo+ICAJCQlyZXR1cm4gcjsNCj4gIAl9DQo+ICsNCj4gKwlpZiAodmNwdS0+a3ZtLT5h
cmNoLnZtX3R5cGUgPT0gS1ZNX1g4Nl9URFhfVk0pIHsNCj4gKwkJaW50IG5yID0gdGR4X25yX3Bh
bXRfcGFnZXModGR4X2dldF9zeXNpbmZvKCkpOw0KPiArCQlyID0ga3ZtX21tdV90b3B1cF9tZW1v
cnlfY2FjaGUoJnZjcHUtPmFyY2gucGFtdF9wYWdlX2NhY2hlLA0KPiArCQkJCQkgICAgICAgbnIg
KiBQVDY0X1JPT1RfTUFYX0xFVkVMKTsNCj4gKwkJaWYgKHIpDQo+ICsJCQlyZXR1cm4gcjsNCj4g
Kwl9DQo+ICsNCj4gIAlyZXR1cm4ga3ZtX21tdV90b3B1cF9tZW1vcnlfY2FjaGUoJnZjcHUtPmFy
Y2gubW11X3BhZ2VfaGVhZGVyX2NhY2hlLA0KPiAgCQkJCQkgIFBUNjRfUk9PVF9NQVhfTEVWRUwp
Ow0KPiAgfQ0KPiBAQCAtNjI2LDYgKzYzNSw3IEBAIHN0YXRpYyB2b2lkIG1tdV9mcmVlX21lbW9y
eV9jYWNoZXMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgCWt2bV9tbXVfZnJlZV9tZW1vcnlf
Y2FjaGUoJnZjcHUtPmFyY2gubW11X3NoYWRvd19wYWdlX2NhY2hlKTsNCj4gIAlrdm1fbW11X2Zy
ZWVfbWVtb3J5X2NhY2hlKCZ2Y3B1LT5hcmNoLm1tdV9zaGFkb3dlZF9pbmZvX2NhY2hlKTsNCj4g
IAlrdm1fbW11X2ZyZWVfbWVtb3J5X2NhY2hlKCZ2Y3B1LT5hcmNoLm1tdV9leHRlcm5hbF9zcHRf
Y2FjaGUpOw0KPiArCWt2bV9tbXVfZnJlZV9tZW1vcnlfY2FjaGUoJnZjcHUtPmFyY2gucGFtdF9w
YWdlX2NhY2hlKTsNCj4gIAlrdm1fbW11X2ZyZWVfbWVtb3J5X2NhY2hlKCZ2Y3B1LT5hcmNoLm1t
dV9wYWdlX2hlYWRlcl9jYWNoZSk7DQo+ICB9DQo+ICANCg0KSUlVQywgdGhpcyBwYXRjaCBjYW4g
YmUgYXZvaWRlZCBpZiB3ZSBjcmVhdGUgYW4gYWN0dWFsIGttZW1fY2FjaGUgZm9yDQptbXVfZXh0
ZXJuYWxfc3B0X2NhY2hlIHdpdGggYW4gYWN0dWFsICdjdG9yJyB3aGVyZSB3ZSBzaW1wbHkgY2Fs
bA0KdGR4X2FsbG9jX3BhZ2UoKSBhcyByZXBsaWVkIHRvIHRoZSBwcmV2aW91cyBwYXRjaC4NCg==

