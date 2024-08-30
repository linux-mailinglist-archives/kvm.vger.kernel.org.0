Return-Path: <kvm+bounces-25496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2B1965F9E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FB611F290C1
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D3018FDD2;
	Fri, 30 Aug 2024 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XbznMuqY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921721428E2;
	Fri, 30 Aug 2024 10:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015156; cv=fail; b=OPZM2BTl9OwLl0MhkikL5bhpR/OxMPKRuiJz6TLaJ+KTJORA8eaJ1cHcjmZCejDU/Hoer7/7LL3RhG3I/EWibJm/GLFfFIKfRL31Na4exvNe7H7GvZktRJGrBHV7g6hUv3op4OJMXrxkl10hdGBxvFIls8YlwKzsImfM5RIB+Qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015156; c=relaxed/simple;
	bh=y7QUKmu7o3Gs+KdXjc9OaQFA3Ts9X7tAjwZr6+O9lwc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wh3yvdUCDPkSAYVyMyCbVuqaUigOgpPubdR07uwQ0qB0rNrd+hOqb3oWNfhnWWNyoeeZVPdDqk0ElyvlOOetoNSkhBhzImNa5JdXQJSSvYRRd0/D1d/0RyPBCCS68BJmY/QXmG/eUtMv5m6x/p2UZp7EQnvKpv+tFsBTScITSuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XbznMuqY; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725015155; x=1756551155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y7QUKmu7o3Gs+KdXjc9OaQFA3Ts9X7tAjwZr6+O9lwc=;
  b=XbznMuqYXpnVfdDNfCaR9Pwo8Z0yR/nxIpM+hCpeGRxadxJmpZM41x2I
   UmwtaYnLJxFkDeZiswZtF0v1i9bSS+S0fnkbZyNCQDyBX8rdODbv4zyFB
   9l80QBBUYMtsfVmRYL6S06mnn5lkRcmPJbzTq5ITYFvRqPbp1WPIkD8oI
   GuGl0Z0lUNdqPDmNYAEDjz6A0nEnVtzLQMu7gf7twYn6Iz87lpRVKaa9V
   rFT09gmGCxsYdODoZd0jEdnzEI/FkhsZMolY25SgfVPSK+L9sDuqaFPE2
   N7hVOvxRsUm/1SukLy3fyugoGHvelejQWHljz90k+Y2mrrjuyBOrJQAJi
   Q==;
X-CSE-ConnectionGUID: eHXEtYjuRuWyspxDIYD45A==
X-CSE-MsgGUID: BU0gOhafSgeI7Vp+MkWhuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23515764"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23515764"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 03:52:34 -0700
X-CSE-ConnectionGUID: hdjwNS3dTsCTGjuIAKo2SA==
X-CSE-MsgGUID: jeG1euI5Q7u6sFuJypu8cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="94599121"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 03:52:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 03:52:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 03:52:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 03:52:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zAU0qiH+cGAxHgFFoq9e2zJTz0dYSuEjN9trsNh6HjO3r6RyhuXo0xr1gjHbC4P5xgeUnLjOHsa6b1vNJTZE4faO3nSkkGlX7RfoeUFSbGdLQMXZMaIPh2oLePc9f8syNkjUXYuZRIxeV2I0NLoXKfRPv/EMaEOpavWZc6QXagKrEgvMjnbqAIHRpyFGeJ5x5crP2yEDXeb+JPlLOgM7NFos6cYHCa8/w9Dvnv68FjAUOgy9/Ckz9NTQiIjQh8AOXWreZnNadPI9WKoSpvL9SqVuBrZZusylnfk+jT3abntkAjVcCXTIsTX7Mj7B2npBhtFzUn5EXfjSYrMZCHYIfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7QUKmu7o3Gs+KdXjc9OaQFA3Ts9X7tAjwZr6+O9lwc=;
 b=Kl9+W9QvRRRNlLL/rZhfdsAYZuwaPUgDfKy91ZBXPqg/5Ba+B1YeX3000U2zxlf93VJGnxS7uqLg5ZJ4hS0BnresjjtVstxbVXrQfnndxV+js47T70e3G6SjpmIbOfS5zAWnzNDsetd5Qt4v68QWU4ybhtWGhOuPwUVHqB2xKEqxw5BBFxJfg4z4Is6XxTf315GOhBP71VxFB/QPP0vFx01d4wbeRXzUZulN6Y2Bq5LbSwueSaBE7evkeMUd3w2FU4W8/nMXkK7cPkLWDWfJDJmRHuhEVewSOT0omPsYJdofe2JAwjHXi93QHdybyq9x6bn4W+OX1wGDZLDpZPT0yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5300.namprd11.prod.outlook.com (2603:10b6:610:bf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 10:52:30 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 10:52:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 2/8] x86/virt/tdx: Remove 'struct field_mapping' and
 implement TD_SYSINFO_MAP() macro
Thread-Topic: [PATCH v3 2/8] x86/virt/tdx: Remove 'struct field_mapping' and
 implement TD_SYSINFO_MAP() macro
Thread-Index: AQHa+E/0m/jBQj198EGqOMKWFia1grI91ySAgAHNo4A=
Date: Fri, 30 Aug 2024 10:52:29 +0000
Message-ID: <b78ff897309014ea151f6eec68beff9b88f00e15.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
	 <5235e05e-1d73-4f70-9b5d-b8648b1f4524@intel.com>
In-Reply-To: <5235e05e-1d73-4f70-9b5d-b8648b1f4524@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5300:EE_
x-ms-office365-filtering-correlation-id: 0a241bf5-dd55-4913-1093-08dcc8e1d82d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?d2NtNis5eVd6VTNuTk9JN3Y1MTl1Z0FJeDFKaXBlRVpZVjNVZk5Kak9HUjA3?=
 =?utf-8?B?ak5VU1VWUVV6YTQyRVVDSWxibGx1K1UzcGM2eEt3dTFGa0hrYjlIaHpqbGdR?=
 =?utf-8?B?YUZLamtISHRVYTA4OTdjdkZPVkJSbkh5UlYxZ2d3S0lxL3k5djlOSjN3UEpl?=
 =?utf-8?B?YjEzZG9YN0lSZlBnRHJjZW85dDFWelZ0OXRDTkw0UlBicVd3d0hSMm1ndDRT?=
 =?utf-8?B?MTN5RUZwR2tmTUlRYkNZV1FieHZNMnVjYWQ0Ym8wTk5mSWVUeDFLWmdTb0F3?=
 =?utf-8?B?ZEtqdW9ZcklrbVhVU2UvdjFSWDdnbER2RnVjelJnOHNrSjJxb0JPYWhIbXJx?=
 =?utf-8?B?VlRwcXpobG1qWSs2VU0rUEZCQTRiU05WQ2NtZVJmMmV0ZSsxQzBJOUZzUzNa?=
 =?utf-8?B?ODErQkw5MVhjZnpOZ0NqVGs2U01ZZE51V2I3VXROUU00QXdVVGY0czA3MGQz?=
 =?utf-8?B?MjZqYWV5emJCSUkvaVFsaEx4QWpLSzNxMm9MMjAzMmNYSmxxRUpFY1VScW1a?=
 =?utf-8?B?bjdGdEo1ZVB3WWphSFVVUGpFR3o0RExKblVGbnRsWFhaY29pR2VXV051SlhD?=
 =?utf-8?B?TzVYeGVJbStLemFXYjZqMmJxdTMvOE1HdTZPaEZFajlpSGd4SHYwRkVDZ2M2?=
 =?utf-8?B?QURjNFNPK2pYRXRvQXlRcmNYWDZwRTFlZEhHSGdMU1dlQVBILzY2L1F4TGlk?=
 =?utf-8?B?ZmV5NEYzZ2pGaCthNmg4UXhjaDRVUHJCSVBZWUd0YU9ac0xwSE5hOFJUR0p0?=
 =?utf-8?B?L2xvSDFhZEhmL3E1Y3d5MUVPSE8zcHoyYlpzTG5vZkZJS1NQOWRvOXZoWjFY?=
 =?utf-8?B?RXhrNGlFRm5zNU1PZEVzQ2g1SjVzSU5PdGgvbUtFU2daUmlLZkNQOEw5NXlH?=
 =?utf-8?B?bzhzOGljMmRwUjcyN2QydjcrZXlkanYvMm1ONU1yZ3RLT0ZiY1hMLzZ2WHZ2?=
 =?utf-8?B?NWZwR1dZVmhqSmdDZDV6YUpIaVA5ZENFaW9rZDZFOWFpMlROQWw2aWEwbW5M?=
 =?utf-8?B?b1NEK1RyNXlPYmdhdnl1MEpEdzdVbStJdXNKaDZWNnVvNmZBQjdzdnRVdVcw?=
 =?utf-8?B?RVl2KzlMVHFLM3BmK2dabHRza3NuL3h4bmU2WTFXZWNBMWNMS0lsb1VMNDZJ?=
 =?utf-8?B?blZ3WkVxSmhzOTQzaW01UXJwWTU0VS8yOGNqSjhJeE5TSElVaFZ4SnB6ZE5H?=
 =?utf-8?B?ait3dmcxeFBCYTB6VUgwTjZRcnFhSDVxeFRtbE1acjIvVTVnREo2WldFSjhU?=
 =?utf-8?B?dFl2cHFIL1pUUGJvdC9ON2hTTUtoL0Mrc0tIdUNjTEM4SHN1VDVUWlpZdmt1?=
 =?utf-8?B?ay9pRUI3dG5lNkFnUkFKS2ttSjdOMkltZHV4YzJERENyWnBLR0RGZ0M4UzJq?=
 =?utf-8?B?d3JwSFI5Zmh2NUl0eTBkTUNWODVQZjR1bEFWUDF1SXlVMmxCNVpmSDdXRlFQ?=
 =?utf-8?B?QXpWYTdQV1JvWFYzVFkwQ05WRHFoL1llRkRmWnRNUGkwMEcycnA2aFFJaEkz?=
 =?utf-8?B?MklDK0JhdVZXRGdtRGdUVHp4Zm1xQkVJa2Fmb01xdkNLOXRQZ2VuOWc0Y21M?=
 =?utf-8?B?Y3lmTDZWbU9PV3BKRFg2VWxUV3hQZXBoS3Y0K2dIRzk0UHdzWVQ0ZXRZamZw?=
 =?utf-8?B?aTF5bXVQdW9tQlVJYldJY3VvZjRaUVNMWUpDSUlTZG9oVFJpM1Mzd2IzMGNm?=
 =?utf-8?B?b2t2bzAyWHhEMjB6Zlc3RWxWL2RUMWx3QWZkUDRrMytzRzZDeStOZXgwZVl4?=
 =?utf-8?B?emJaRlVTajQySWZVR25IOWpNVXY2N1dOYi9YWEIwS3lTb2k5OGYyVngzZzYy?=
 =?utf-8?B?Z0s4bGJzNTVDYzFKbzR5MzFlc1RCM01yMXE1VGl0ZmNud0U5WHp4MWtvZVRv?=
 =?utf-8?Q?k7bNTz/hqjbKG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHI1ZkpxeG10WWpjTWNrKzc0bFdMMTJydjF6OUxjK2FYRnNtbWZMU3RKcVhR?=
 =?utf-8?B?eXlsa2tUZWZFbXdZSU8xamhOTTVrQmtGYU01U2EvelR5Yk5RbFZTZVdnTENV?=
 =?utf-8?B?bW9YdkZzTlRXbVh5YWRKdnJNMWY3SkVEVFd6Zm5rT09QK2tTdURUa0hteXBI?=
 =?utf-8?B?OGtoQStMczVGMnhLMHZnRG5DNGxmWDVqenlTcTJQaFlmVHNqN0V6ekN5ZFhL?=
 =?utf-8?B?TGtYclFYdkNCdVcrQW9CeHZhRGVPTmUxQUpXMzV5MU5KZ1hCcUNxa25RbG0z?=
 =?utf-8?B?V09OWWdWRU1rZGxnL0trWWpaU1lFa1VpSnFjak1pNFJTa2NNeFpucGxNV1Bj?=
 =?utf-8?B?ZDZGTHZ5djlXNno5RXZDcGVoOXhhbmQvQ2RjL3pob0dweTVFVVhiNzdvU3RR?=
 =?utf-8?B?WTVHK24rc1h4emhxRWk0dVhPZ1VYSHAwOEl3Y2FCUGd2eGxPWERCY1d0Mit0?=
 =?utf-8?B?S21YZm9qVmc3cktZMlpmVEVOVFMxMmFKeFVFSUM1bHYxVWkrbGxJV3h0OEU4?=
 =?utf-8?B?aUdXNitiYlFGYXlCUVJEV3laK1NDbERLWFRvRkhRSXNYUUpkYzBHazZOOWt6?=
 =?utf-8?B?SWc4eXdyUmw2TUZlZ0phK2U4cjlWU3NVWmdEMy9LbWVFbmR2TGVmVmhnMnZ4?=
 =?utf-8?B?cjRvRE5JQTFWWXN3QWZ4RGgvdTBua1ZPRk9tNWJIM0RBWFhxR1RsdGh6czRv?=
 =?utf-8?B?b2d6dHhZT3VFejlKSHFIZGpUcWQ0K2xwSGVORDlsdlJZTy9oeUhQMWhuWk1z?=
 =?utf-8?B?QjJDc1N5c2RLYXpmSUNIempCNUVOUlNpMS9DSFcrTEpzMHpteFhUa3RWWFRC?=
 =?utf-8?B?bjdPODBCNktzcG9rQXN4b3Y3anNNdjN4M3dvL1N0Ui9COHUxUU9kc2M3WDAw?=
 =?utf-8?B?ZnpLQmxodWRHelVWSmFWaGJ0aXBreVo2YTNGY0pmZjhZUndZNzlSZUoyWUU3?=
 =?utf-8?B?aWZwSEZlaWtiYXV4M2paaTlrRDhWRmQ2ZUtQeUl5eEhrK3JJUGgzZ2dUcUoz?=
 =?utf-8?B?Nm1QbTNVU25EZXlwZE9iZVZST29VVTdrdkZYblZ2TVZrWGkwMzNzZjJ0MFYy?=
 =?utf-8?B?VzJSQmg2VzlwWkZsR0lPUkVxOTJxeE9xSTZIMCtkdEJHVzB6Zy9welRJdDQw?=
 =?utf-8?B?NFZ5aWRueURvV2grYndMbEdkZWNtYVRWUjAyUjBnWkM4SElhc3B3QmFjQ09s?=
 =?utf-8?B?cCthSVA2YXl3T2E1aGpTdnluelMyNURFbUx0VlRCM3V2Mm14RWQ5Z1o1cng2?=
 =?utf-8?B?dXl0d0lnMk81dlRzaENaelZGcWRKNjN2UGcxWlZvYWlyc05UdEI3ZjNBS1Uy?=
 =?utf-8?B?Qzg1OUdjVkJCeExIZmcxY3dubVVRYkFwc3NMbmlJMk1kWklCckkzMzZhM3o0?=
 =?utf-8?B?VUhtWk9wVFUweGlBRy95WFFpR1BoVUVOeEtxTWpqS2ljTlNRMEJIM1JIWTRz?=
 =?utf-8?B?Q21XbW5RS2RDcXB2TUtFOHJoYmd3RnlTYW1YSFV1clFtWm00RHJsZkhma1VN?=
 =?utf-8?B?c2VYcDlaV1NwRUpYdnlpaUJRcDh1NjhERDlRU2pheTBGK1Rzc3MvbVN0d2lq?=
 =?utf-8?B?OTM0N2hVbUIwWVY4anhybVRGSTVNdThBWVgzRGtoblBUM2xLaElodCtkQ3or?=
 =?utf-8?B?dmZCOU9iRyt4cjNhVnN0OEF1R2RQVVNmcVFiRllOcnU2NnNhdW52T0tVcVdY?=
 =?utf-8?B?dGFUT2c1d2MzSlpaMUlTZ0VQc2djMW12NG5hZTB2U1BScHZkc3g3L3BTaUI2?=
 =?utf-8?B?UTE3SHBoaHNSOW93a0wvalAwR1EwN0d1Ny9BL1hYWm1RbHI3cEU2MjFWTXdr?=
 =?utf-8?B?U0RwNGtIUzhoSlFUbHg1aks4WDkyalhRT1VsQWxOcElhU0U1SE1YT2xxcnh0?=
 =?utf-8?B?TzRWeXdaOGZHMWdINnVSbkFTWWdQc3FXem5vZWY3aDcvTjVrVnBJb3o1akRz?=
 =?utf-8?B?Z0hnZ1ZFKzQwY2twYVBCdmxHVHpJWVhUakhaNE1PSlFnT3ZFRkRoaEl3T01x?=
 =?utf-8?B?bU1uNHBLMzMyeCs0UjVqZGtGYWZCbEhCY2xIWFN4cXZBZUkrMXV5cndKQkZk?=
 =?utf-8?B?akF5N1RzM1dvY3JhUUljK0d0RjY5MDRZZFY3ZjVzZWVDbTBLWVdYMGJ5SElM?=
 =?utf-8?Q?F2mb8VFLtKvIzqkAt4UGTDJPg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5645600DC1081344ACF8EFCD9459CA1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a241bf5-dd55-4913-1093-08dcc8e1d82d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 10:52:29.9213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBt2dpRQObb/3eYmp4Zkl1EZyg/oJOxa7OiJXZMw71+bF0aXX2DPco7lmd2emBU0TzrhGIy7YcyzYXkZKhMK1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5300
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA4LTI5IGF0IDEwOjIwICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiBPbiAyNy8wOC8yNCAxMDoxNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiANCj4gU3ViamVjdCBjb3Vs
ZCBiZSAiU2ltcGxpZnkgdGhlIHJlYWRpbmcgb2YgR2xvYmFsIE1ldGFkYXRhIEZpZWxkcyINCg0K
T0suDQoNCj4gDQo+ID4gVEw7RFI6IFJlbW92ZSB0aGUgJ3N0cnVjdCBmaWVsZF9tYXBwaW5nJyBz
dHJ1Y3R1cmUgYW5kIHVzZSBhbm90aGVyIHdheQ0KPiA+IHRvIGltcGxlbWVudCB0aGUgVERfU1lT
SU5GT19NQVAoKSBtYWNybyB0byBpbXByb3ZlIHRoZSBjdXJyZW50IG1ldGFkYXRhDQo+ID4gcmVh
ZGluZyBjb2RlLCBlLmcuLCBzd2l0Y2hpbmcgdG8gdXNlIGJ1aWxkLXRpbWUgY2hlY2sgZm9yIG1l
dGFkYXRhIGZpZWxkDQo+ID4gc2l6ZSBvdmVyIHRoZSBleGlzdGluZyBydW50aW1lIGNoZWNrLg0K
PiANCj4gUGVyaGFwczoNCj4gDQo+ICAgUmVtb3ZlICdzdHJ1Y3QgZmllbGRfbWFwcGluZycgYW5k
IGxldCByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KCkgYWNjZXB0DQo+ICAgdGhlIG1lbWJlciB2
YXJpYWJsZSBhZGRyZXNzLCBzaW1wbGlmeWluZyB0aGUgY29kZSBpbiBwcmVwYXJhdGlvbiBmb3Ig
YWRkaW5nDQo+ICAgc3VwcG9ydCBmb3IgbW9yZSBtZXRhZGF0YSBzdHJ1Y3R1cmVzIGFuZCBmaWVs
ZCBzaXplcy4NCg0KRmluZSB0byBtZS4gIEkgd291bGQgbGlrZSBhbHNvIHRvIG1lbnRpb24gdGhl
cmUgYXJlIGltcHJvdmVtZW50cyBpbiB0aGUgbmV3DQpjb2RlIChhcyBzdWdnZXN0ZWQgYnkgRGFu
KSwgc28gSSB3aWxsIHNheToNCg0KIi4uLiwgc2ltcGxpZnlpbmcgYW5kIGltcHJvdmluZyB0aGUg
Y29kZSBpbiBwcmVwYXJhdGlvbiAuLi4iLg0KDQo+IA0KPiA+IA0KPiA+IFRoZSBURFggbW9kdWxl
IHByb3ZpZGVzIGEgc2V0IG9mICJnbG9iYWwgbWV0YWRhdGEgZmllbGRzIi4gIFRoZXkgcmVwb3J0
DQo+IA0KPiBHbG9iYWwgTWV0YWRhdGEgRmllbGRzDQoNCk9LLiANCg0KPiANCj4gPiB0aGluZ3Mg
bGlrZSBURFggbW9kdWxlIHZlcnNpb24sIHN1cHBvcnRlZCBmZWF0dXJlcywgYW5kIGZpZWxkcyBy
ZWxhdGVkDQo+ID4gdG8gY3JlYXRlL3J1biBURFggZ3Vlc3RzIGFuZCBzbyBvbi4NCj4gPiANCj4g
PiBGb3Igbm93IHRoZSBrZXJuZWwgb25seSByZWFkcyAiVEQgTWVtb3J5IFJlZ2lvbiIgKFRETVIp
IHJlbGF0ZWQgZ2xvYmFsDQo+ID4gbWV0YWRhdGEgZmllbGRzLCBhbmQgYWxsIG9mIHRob3NlIGZp
ZWxkcyBhcmUgb3JnYW5pemVkIGluIG9uZSBzdHJ1Y3R1cmUuDQo+IA0KPiBUaGUgcGF0Y2ggaXMg
c2VsZi1ldmlkZW50bHkgc2ltcGxlciAoMjEgaW5zZXJ0aW9ucygrKSwgMzYgZGVsZXRpb25zKC0p
KQ0KPiBzbyB0aGVyZSBkb2Vzbid0IHNlZW0gdG8gYmUgYW55IG5lZWQgZm9yIGZ1cnRoZXIgZWxh
Ym9yYXRpb24uICBQZXJoYXBzDQo+IGp1c3Qgcm91bmQgaXQgb2ZmIGFuZCBzdG9wIHRoZXJlLg0K
PiANCj4gICAuLi4gYW5kIGFsbCBvZiB0aG9zZSBmaWVsZHMgYXJlIG9yZ2FuaXplZCBpbiBvbmUg
c3RydWN0dXJlLA0KPiAgIGJ1dCB0aGF0IHdpbGwgY2hhbmdlIGluIHRoZSBuZWFyIGZ1dHVyZS4N
Cg0KSSB0aGluayB0aGUgY29kZSBjaGFuZ2UgaGVyZSBpcyBub3Qgb25seSB0byByZWR1Y2UgdGhl
IExvQyAoaS5lLiwgc2ltcGxpZnkgdGhlDQpjb2RlKSwgYnV0IGFsc28gaW1wcm92ZSB0aGUgY29k
ZSwgc28gSSB3b3VsZCBsaWtlIHRvIGtlZXAgdGhlIHRoaW5ncyBtZW50aW9uZWQNCmJ5IERhbiBp
biB0aGUgY2hhbmdlbG9nLg0KDQo+IA0KPiA+IA0KPiA+IFRoZSBrZXJuZWwgY3VycmVudGx5IHVz
ZXMgJ3N0cnVjdCBmaWVsZF9tYXBwaW5nJyB0byBmYWNpbGl0YXRlIHJlYWRpbmcNCj4gPiBtdWx0
aXBsZSBtZXRhZGF0YSBmaWVsZHMgaW50byBvbmUgc3RydWN0dXJlLiAgVGhlICdzdHJ1Y3QgZmll
bGRfbWFwcGluZycNCj4gPiByZWNvcmRzIHRoZSBtYXBwaW5nIGJldHdlZW4gdGhlIGZpZWxkIElE
IGFuZCB0aGUgb2Zmc2V0IG9mIHRoZSBzdHJ1Y3R1cmUNCj4gPiB0byBmaWxsIG91dC4gIFRoZSBr
ZXJuZWwgaW5pdGlhbGl6ZXMgYW4gYXJyYXkgb2YgJ3N0cnVjdCBmaWVsZF9tYXBwaW5nJw0KPiA+
IGZvciBlYWNoIHN0cnVjdHVyZSBtZW1iZXIgKHVzaW5nIHRoZSBURF9TWVNJTkZPX01BUCgpIG1h
Y3JvKSBhbmQgdGhlbg0KPiA+IHJlYWRzIGFsbCBtZXRhZGF0YSBmaWVsZHMgaW4gYSBsb29wIHVz
aW5nIHRoYXQgYXJyYXkuDQo+ID4gDQo+ID4gQ3VycmVudGx5IHRoZSBrZXJuZWwgb25seSByZWFk
cyBURE1SIHJlbGF0ZWQgbWV0YWRhdGEgZmllbGRzIGludG8gb25lDQo+ID4gc3RydWN0dXJlLCBh
bmQgdGhlIGZ1bmN0aW9uIHRvIHJlYWQgb25lIG1ldGFkYXRhIGZpZWxkIHRha2VzIHRoZSBwb2lu
dGVyDQo+ID4gb2YgdGhhdCBzdHJ1Y3R1cmUgYW5kIHRoZSBvZmZzZXQ6DQo+ID4gDQo+ID4gICBz
dGF0aWMgaW50IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYodTY0IGZpZWxkX2lkLA0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCBvZmZzZXQsDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHRkeF9zeXNfaW5mb190
ZG1yICp0cykNCj4gPiAgIHsuLi59DQo+ID4gDQo+ID4gRnV0dXJlIGNoYW5nZXMgd2lsbCBuZWVk
IHRvIHJlYWQgbW9yZSBtZXRhZGF0YSBmaWVsZHMgaW50byBkaWZmZXJlbnQNCj4gPiBzdHJ1Y3R1
cmVzLiAgVG8gc3VwcG9ydCB0aGlzIHRoZSBhYm92ZSBmdW5jdGlvbiB3aWxsIG5lZWQgdG8gYmUg
Y2hhbmdlZA0KPiA+IHRvIHRha2UgJ3ZvaWQgKic6DQo+ID4gDQo+ID4gICBzdGF0aWMgaW50IHJl
YWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYodTY0IGZpZWxkX2lkLA0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGludCBvZmZzZXQsDQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgdm9pZCAqc3RidWYpDQo+ID4gICB7Li4ufQ0KPiA+IA0K
PiA+IFRoaXMgYXBwcm9hY2ggbG9zZXMgdHlwZS1zYWZldHksIGFzIERhbiBzdWdnZXN0ZWQuICBB
IGJldHRlciB3YXkgaXMgdG8NCj4gPiBtYWtlIGl0IGJlIC4uDQo+ID4gDQo+ID4gICBzdGF0aWMg
aW50IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYodTY0IGZpZWxkX2lkLCB1MTYgKnZhbCkgey4u
Ln0NCj4gPiANCj4gPiAuLiBhbmQgbGV0IHRoZSBjYWxsZXIgY2FsY3VsYXRlIHRoZSBidWZmZXIg
aW4gYSB0eXBlLXNhZmUgd2F5IFsxXS4NCj4gPiANCj4gPiBBbHNvLCB0aGUgdXNpbmcgb2YgdGhl
ICdzdHJ1Y3QgZmllbGRfbWFwcGluZycgbG9zZXMgdGhlIGFiaWxpdHkgdG8gYmUNCj4gPiBhYmxl
IHRvIGRvIGJ1aWxkLXRpbWUgY2hlY2sgYWJvdXQgdGhlIG1ldGFkYXRhIGZpZWxkIHNpemUgKGVu
Y29kZWQgaW4NCj4gPiB0aGUgZmllbGQgSUQpIGR1ZSB0byB0aGUgZmllbGQgSUQgaXMgImluZGly
ZWN0bHkiIGluaXRpYWxpemVkIHRvIHRoZQ0KPiA+ICdzdHJ1Y3QgZmllbGRfbWFwcGluZycgYW5k
IHBhc3NlZCB0byB0aGUgZnVuY3Rpb24gdG8gcmVhZC4gIFRodXMgdGhlDQo+ID4gY3VycmVudCBj
b2RlIHVzZXMgcnVudGltZSBjaGVjayBpbnN0ZWFkLg0KPiA+IA0KPiA+IERhbiBzdWdnZXN0ZWQg
dG8gcmVtb3ZlIHRoZSAnc3RydWN0IGZpZWxkX21hcHBpbmcnLCB1bnJvbGwgdGhlIGxvb3AsDQo+
ID4gc2tpcCB0aGUgYXJyYXksIGFuZCBjYWxsIHRoZSByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2
KCkgZGlyZWN0bHkgd2l0aA0KPiA+IGJ1aWxkLXRpbWUgY2hlY2sgWzFdWzJdLiAgQW5kIHRvIGlt
cHJvdmUgdGhlIHJlYWRhYmlsaXR5LCByZWltcGxlbWVudA0KPiA+IHRoZSBURF9TWVNJTkZPX01B
UCgpIFszXS4NCj4gPiANCj4gPiBUaGUgbmV3IFREX1NZU0lORk9fTUFQKCkgaXNuJ3QgcGVyZmVj
dC4gIEl0IHJlcXVpcmVzIHRoZSBmdW5jdGlvbiB0aGF0DQo+ID4gdXNlcyBpdCB0byBkZWZpbmUg
YSBsb2NhbCB2YXJpYWJsZSBAcmV0IHRvIGNhcnJ5IHRoZSBlcnJvciBjb2RlIGFuZCBzZXQNCj4g
PiB0aGUgaW5pdGlhbCB2YWx1ZSB0byAwLiAgSXQgYWxzbyBoYXJkLWNvZGVzIHRoZSB2YXJpYWJs
ZSBuYW1lIG9mIHRoZQ0KPiA+IHN0cnVjdHVyZSBwb2ludGVyIHVzZWQgaW4gdGhlIGZ1bmN0aW9u
LiAgQnV0IG92ZXJhbGwgdGhlIHByb3Mgb2YgdGhpcw0KPiA+IGFwcHJvYWNoIGJlYXQgdGhlIGNv
bnMuDQo+ID4gDQo+ID4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2ExMDdiMDY3
LTg2MWQtNDNmNC04NmI1LTI5MjcxY2I5M2RhZEBpbnRlbC5jb20vVC8jbTdjZmIzYzE0NjIxNGQ5
NGIyNGU5NzhlZWI4NzA4ZDkyYzBiMTRhYzYgWzFdDQo+ID4gTGluazogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcva3ZtL2ExMDdiMDY3LTg2MWQtNDNmNC04NmI1LTI5MjcxY2I5M2RhZEBpbnRlbC5j
b20vVC8jbWJlNjVmMDkwM2ZmNzgzNWJjNDE4YTkwN2YwZDAyZDdhOWUwYjc4YmUgWzJdDQo+ID4g
TGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2ExMDdiMDY3LTg2MWQtNDNmNC04NmI1
LTI5MjcxY2I5M2RhZEBpbnRlbC5jb20vVC8jbTgwY2RlNWU2NTA0YjNhZjc0ZDkzM2VhMGNiZmMz
Y2E5ZDI0Njk3ZDMgWzNdDQo+IA0KPiBQcm9iYWJseSBqdXN0IG9uZSBsaW5rIHdvdWxkIHN1ZmZp
Y2UsIHNheSB0aGUgcGVybWFsaW5rIHRvIERhbidzDQo+IGNvbW1lbnQ6DQo+IA0KPiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9rdm0vNjZiMTYxMjFjNDhmNF80ZmM3Mjk0MjRAZHdpbGxpYTIteGZo
LmpmLmludGVsLmNvbS5ub3RtdWNoLw0KDQpbMV0gYW5kIFsyXSBhcmUgYWN0dWFsbHkgcmVwbGll
cyB0byBkaWZmZXJlbnQgcGF0Y2hlcywgc28gSSB3b3VsZCBsaWtlIHRvIGtlZXANCnRoZW0uICBb
MV0gYW5kIFszXSBhcmUgcmVwbGllcyB0byB0aGUgc2FtZSBwYXRjaCwgc28gSSBjb3VsZCByZW1v
dmUgWzNdLCBidXQgSQ0KdGhpbmsga2VlcGluZyBhbGwgb2YgdGhlbSBpcyBhbHNvIGZpbmUgc2lu
Y2UgaXQncyBtb3JlIGVhc3kgdG8gZmluZCB0aGUgZXhhY3QNCmNvbW1lbnQgdGhhdCBJIHdhbnQg
dG8gYWRkcmVzcy4NCg0KPiANCj4gPiBTdWdnZXN0ZWQtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmou
d2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiANCj4gPiB2MiAtPiB2MzoNCj4gPiAgLSBSZW1v
dmUgJ3N0cnVjdCBmaWVsZF9tYXBwaW5nJyBhbmQgcmVpbXBsZW1lbnQgVERfU1lTSU5GT19NQVAo
KS4NCj4gPiANCj4gPiAtLS0NCj4gPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIHwgNTcg
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMjEgaW5zZXJ0aW9ucygrKSwgMzYgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90
ZHguYw0KPiA+IGluZGV4IGU5NzliZjQ0MjkyOS4uN2U3NWMxYjEwODM4IDEwMDY0NA0KPiA+IC0t
LSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguYw0KPiA+IEBAIC0yNzAsNjAgKzI3MCw0NSBAQCBzdGF0aWMgaW50IHJlYWRf
c3lzX21ldGFkYXRhX2ZpZWxkKHU2NCBmaWVsZF9pZCwgdTY0ICpkYXRhKQ0KPiA+ICAJcmV0dXJu
IDA7DQo+ID4gIH0NCj4gPiAgDQo+ID4gLXN0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfZmll
bGQxNih1NjQgZmllbGRfaWQsDQo+ID4gLQkJCQkgICAgIGludCBvZmZzZXQsDQo+ID4gLQkJCQkg
ICAgIHN0cnVjdCB0ZHhfc3lzX2luZm9fdGRtciAqdHMpDQo+ID4gK3N0YXRpYyBpbnQgcmVhZF9z
eXNfbWV0YWRhdGFfZmllbGQxNih1NjQgZmllbGRfaWQsIHUxNiAqdmFsKQ0KPiA+ICB7DQo+ID4g
LQl1MTYgKnRzX21lbWJlciA9ICgodm9pZCAqKXRzKSArIG9mZnNldDsNCj4gPiAgCXU2NCB0bXA7
DQo+ID4gIAlpbnQgcmV0Ow0KPiA+ICANCj4gPiAtCWlmIChXQVJOX09OX09OQ0UoTURfRklFTERf
SURfRUxFX1NJWkVfQ09ERShmaWVsZF9pZCkgIT0NCj4gPiAtCQkJTURfRklFTERfSURfRUxFX1NJ
WkVfMTZCSVQpKQ0KPiA+IC0JCXJldHVybiAtRUlOVkFMOw0KPiA+ICsJQlVJTERfQlVHX09OKE1E
X0ZJRUxEX0lEX0VMRV9TSVpFX0NPREUoZmllbGRfaWQpICE9DQo+ID4gKwkJCU1EX0ZJRUxEX0lE
X0VMRV9TSVpFXzE2QklUKTsNCj4gDQo+IFRoaXMgZ2V0cyByZW1vdmVkIG5leHQgcGF0Y2gsIHNv
IHdoeSBkbyBpdA0KDQpUaGlzIHBhdGNoIEkgZGlkbid0IGFkZCB0aGUgYnVpbGQtdGltZSBjaGVj
ayBpbiB0aGUgKG5ldykgVERfU1lTSU5GT19NQVAoKSwgc28NCkkgY2hhbmdlZCB0aGUgcnVudGlt
ZSBjaGVjayB0byBidWlsZC10aW1lIGNoZWNrIGhlcmUgc2luY2Ugd2UgY2FuIGFjdHVhbGx5IGRv
DQppdCBoZXJlLiAgSSB0aGluayBldmVuIGZvciB0aGlzIG1pZGRsZSBzdGF0ZSBwYXRjaCB3ZSBz
aG91bGQgZG8gdGhlIGJ1aWxkLXRpbWUNCmNoZWNrLiAgSSBjYW4gbW92ZSBpdCB0byB0aGUgKG5l
dykgVERfU1lTSU5GT19NQVAoKSB0aG91Z2ggaWYgdGhhdCdzIGJldHRlci4NCg0KPiANCj4gPiAg
DQo+ID4gIAlyZXQgPSByZWFkX3N5c19tZXRhZGF0YV9maWVsZChmaWVsZF9pZCwgJnRtcCk7DQo+
ID4gIAlpZiAocmV0KQ0KPiA+ICAJCXJldHVybiByZXQ7DQo+ID4gIA0KPiA+IC0JKnRzX21lbWJl
ciA9IHRtcDsNCj4gPiArCSp2YWwgPSB0bXA7DQo+ID4gIA0KPiA+ICAJcmV0dXJuIDA7DQo+ID4g
IH0NCj4gPiAgDQo+ID4gLXN0cnVjdCBmaWVsZF9tYXBwaW5nIHsNCj4gPiAtCXU2NCBmaWVsZF9p
ZDsNCj4gPiAtCWludCBvZmZzZXQ7DQo+ID4gLX07DQo+ID4gLQ0KPiA+IC0jZGVmaW5lIFREX1NZ
U0lORk9fTUFQKF9maWVsZF9pZCwgX29mZnNldCkgXA0KPiA+IC0JeyAuZmllbGRfaWQgPSBNRF9G
SUVMRF9JRF8jI19maWVsZF9pZCwJICAgXA0KPiA+IC0JICAub2Zmc2V0ICAgPSBvZmZzZXRvZihz
dHJ1Y3QgdGR4X3N5c19pbmZvX3RkbXIsIF9vZmZzZXQpIH0NCj4gPiAtDQo+ID4gLS8qIE1hcCBU
RF9TWVNJTkZPIGZpZWxkcyBpbnRvICdzdHJ1Y3QgdGR4X3N5c19pbmZvX3RkbXInOiAqLw0KPiA+
IC1zdGF0aWMgY29uc3Qgc3RydWN0IGZpZWxkX21hcHBpbmcgZmllbGRzW10gPSB7DQo+ID4gLQlU
RF9TWVNJTkZPX01BUChNQVhfVERNUlMsCSAgICAgIG1heF90ZG1ycyksDQo+ID4gLQlURF9TWVNJ
TkZPX01BUChNQVhfUkVTRVJWRURfUEVSX1RETVIsIG1heF9yZXNlcnZlZF9wZXJfdGRtciksDQo+
ID4gLQlURF9TWVNJTkZPX01BUChQQU1UXzRLX0VOVFJZX1NJWkUsICAgIHBhbXRfZW50cnlfc2l6
ZVtURFhfUFNfNEtdKSwNCj4gPiAtCVREX1NZU0lORk9fTUFQKFBBTVRfMk1fRU5UUllfU0laRSwg
ICAgcGFtdF9lbnRyeV9zaXplW1REWF9QU18yTV0pLA0KPiA+IC0JVERfU1lTSU5GT19NQVAoUEFN
VF8xR19FTlRSWV9TSVpFLCAgICBwYW10X2VudHJ5X3NpemVbVERYX1BTXzFHXSksDQo+ID4gLX07
DQo+ID4gKy8qDQo+ID4gKyAqIEFzc3VtZXMgbG9jYWxseSBkZWZpbmVkIEByZXQgYW5kIEBzeXNp
bmZvX3RkbXIgdG8gY29udmV5IHRoZSBlcnJvcg0KPiA+ICsgKiBjb2RlIGFuZCB0aGUgJ3N0cnVj
dCB0ZHhfc3lzX2luZm9fdGRtcicgaW5zdGFuY2UgdG8gZmlsbCBvdXQuDQo+ID4gKyAqLw0KPiA+
ICsjZGVmaW5lIFREX1NZU0lORk9fTUFQKF9maWVsZF9pZCwgX21lbWJlcikJCQkJCQlcDQo+IA0K
PiAiTUFQIiBtYWRlIHNlbnNlIHdoZW4gaXQgd2FzIGluIGEgc3RydWN0IHdoZXJlYXMNCj4gbm93
IGl0IGlzIHJlYWRpbmcuDQo+IA0KPiA+ICsJKHsJCQkJCQkJCQkJXA0KPiA+ICsJCWlmICghcmV0
KQkJCQkJCQkJXA0KPiA+ICsJCQlyZXQgPSByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KE1EX0ZJ
RUxEX0lEXyMjX2ZpZWxkX2lkLAlcDQo+ID4gKwkJCQkJJnN5c2luZm9fdGRtci0+X21lbWJlcik7
CQkJXA0KPiA+ICsJfSkNCj4gPiAgDQo+ID4gIHN0YXRpYyBpbnQgZ2V0X3RkeF9zeXNfaW5mb190
ZG1yKHN0cnVjdCB0ZHhfc3lzX2luZm9fdGRtciAqc3lzaW5mb190ZG1yKQ0KPiA+ICB7DQo+ID4g
LQlpbnQgcmV0Ow0KPiA+IC0JaW50IGk7DQo+ID4gKwlpbnQgcmV0ID0gMDsNCj4gPiAgDQo+ID4g
LQkvKiBQb3B1bGF0ZSAnc3lzaW5mb190ZG1yJyBmaWVsZHMgdXNpbmcgdGhlIG1hcHBpbmcgc3Ry
dWN0dXJlIGFib3ZlOiAqLw0KPiA+IC0JZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoZmllbGRz
KTsgaSsrKSB7DQo+ID4gLQkJcmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNihmaWVsZHNb
aV0uZmllbGRfaWQsDQo+ID4gLQkJCQkJCWZpZWxkc1tpXS5vZmZzZXQsDQo+ID4gLQkJCQkJCXN5
c2luZm9fdGRtcik7DQo+ID4gLQkJaWYgKHJldCkNCj4gPiAtCQkJcmV0dXJuIHJldDsNCj4gPiAt
CX0NCj4gPiArCVREX1NZU0lORk9fTUFQKE1BWF9URE1SUywJICAgICAgbWF4X3RkbXJzKTsNCj4g
PiArCVREX1NZU0lORk9fTUFQKE1BWF9SRVNFUlZFRF9QRVJfVERNUiwgbWF4X3Jlc2VydmVkX3Bl
cl90ZG1yKTsNCj4gPiArCVREX1NZU0lORk9fTUFQKFBBTVRfNEtfRU5UUllfU0laRSwgICAgcGFt
dF9lbnRyeV9zaXplW1REWF9QU180S10pOw0KPiA+ICsJVERfU1lTSU5GT19NQVAoUEFNVF8yTV9F
TlRSWV9TSVpFLCAgICBwYW10X2VudHJ5X3NpemVbVERYX1BTXzJNXSk7DQo+ID4gKwlURF9TWVNJ
TkZPX01BUChQQU1UXzFHX0VOVFJZX1NJWkUsICAgIHBhbXRfZW50cnlfc2l6ZVtURFhfUFNfMUdd
KTsNCj4gDQo+IEFub3RoZXIgcG9zc2liaWxpdHkgaXMgdG8gcHV0IHRoZSBtYWNybyBhdCB0aGUg
aW52b2NhdGlvbiBzaXRlOg0KPiANCj4gI2RlZmluZSBSRUFEX1NZU19JTkZPKF9maWVsZF9pZCwg
X21lbWJlcikJCQkJXA0KPiAJcmV0ID0gcmV0ID86IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkMTYo
TURfRklFTERfSURfIyNfZmllbGRfaWQsCVwNCj4gCQkJCQkgICAgICAgJnN5c2luZm9fdGRtci0+
X21lbWJlcikNCj4gDQo+IAlSRUFEX1NZU19JTkZPKE1BWF9URE1SUywgICAgICAgICAgICAgbWF4
X3RkbXJzKTsNCj4gCVJFQURfU1lTX0lORk8oTUFYX1JFU0VSVkVEX1BFUl9URE1SLCBtYXhfcmVz
ZXJ2ZWRfcGVyX3RkbXIpOw0KPiAJUkVBRF9TWVNfSU5GTyhQQU1UXzRLX0VOVFJZX1NJWkUsICAg
IHBhbXRfZW50cnlfc2l6ZVtURFhfUFNfNEtdKTsNCj4gCVJFQURfU1lTX0lORk8oUEFNVF8yTV9F
TlRSWV9TSVpFLCAgICBwYW10X2VudHJ5X3NpemVbVERYX1BTXzJNXSk7DQo+IAlSRUFEX1NZU19J
TkZPKFBBTVRfMUdfRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9zaXplW1REWF9QU18xR10pOw0K
PiANCj4gI3VuZGVmIFJFQURfU1lTX0lORk8NCj4gDQo+IEFuZCBzbyBvbiBpbiBsYXRlciBwYXRj
aGVzOg0KPiANCj4gI2RlZmluZSBSRUFEX1NZU19JTkZPKF9maWVsZF9pZCwgX21lbWJlcikJCQkJ
XA0KPiAJcmV0ID0gcmV0ID86IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKE1EX0ZJRUxEX0lEXyMj
X2ZpZWxkX2lkLAlcDQo+IAkJCQkJICAgICAmc3lzaW5mb192ZXJzaW9uLT5fbWVtYmVyKQ0KPiAN
Cj4gCVJFQURfU1lTX0lORk8oTUFKT1JfVkVSU0lPTiwgICAgbWFqb3IpOw0KPiAJUkVBRF9TWVNf
SU5GTyhNSU5PUl9WRVJTSU9OLCAgICBtaW5vcik7DQo+IAlSRUFEX1NZU19JTkZPKFVQREFURV9W
RVJTSU9OLCAgIHVwZGF0ZSk7DQo+IAlSRUFEX1NZU19JTkZPKElOVEVSTkFMX1ZFUlNJT04sIGlu
dGVybmFsKTsNCj4gCVJFQURfU1lTX0lORk8oQlVJTERfTlVNLCAgICAgICAgYnVpbGRfbnVtKTsN
Cj4gCVJFQURfU1lTX0lORk8oQlVJTERfREFURSwgICAgICAgYnVpbGRfZGF0ZSk7DQo+IA0KPiAj
dW5kZWYgUkVBRF9TWVNfSU5GTw0KPiANCg0KVGhpcyBpcyBmaW5lIHRvIG1lLiAgQnV0IEFGQUlD
VCBLaXJpbGwgZG9lc24ndCBsaWtlIHRoZSAiI3VuZGVmIiBwYXJ0Lg0KDQpLaXJpbGwsIGRvIHlv
dSBoYXZlIGNvbW1lbnRzPw0KDQpPdGhlcndpc2UgSSB3aWxsIGdvIHdpdGggd2hhdCBBZHJpYW4g
c3VnZ2VzdGVkLg0K

