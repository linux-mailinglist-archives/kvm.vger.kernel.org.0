Return-Path: <kvm+bounces-26107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B1597149A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 12:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 465341F23B20
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 10:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B02E1B3B19;
	Mon,  9 Sep 2024 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JuleNt57"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E001B3743;
	Mon,  9 Sep 2024 09:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725875992; cv=fail; b=AWieFh87CvQD7Lf7jdZTpAwd68YGd7863wv22rWGmJxDn1L5dy+aysA8yezXckMLeYYdxhreJElGdPFcE/CRYZRhr3JdQWsNPIJhGePYnKht0uCdquy0UQlzhpV6uY4H9ReelBpEKpGMEr24E+yNvJSz7hlIV1EzRr6hB+8/SJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725875992; c=relaxed/simple;
	bh=GVQ5v4oWCWX0HCoEXCwYScSY8CNA2NTMoaQ8Kaqzf6Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dox3c1lWSBm2feCyy469rg4LOyY6NJh/d5ZGXXBjcn7y/uGzKKi/OEEt7xuXZLg6w7letko5Mbxb2xzfKNYcXqUNxVirloKCDlF4ANMvQouAAIzHsH7/tsmNFwYcy+ZefOvZSCGE6WuFSjnoQnK9HxNOfGwLVoRtrFolTecUdrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JuleNt57; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725875991; x=1757411991;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GVQ5v4oWCWX0HCoEXCwYScSY8CNA2NTMoaQ8Kaqzf6Y=;
  b=JuleNt57Vee3tTySAX28IPRfoF5c4vUUiQvTx+TNXqWvA0qPtmgJu+Xv
   gQU0WxzURJGQr8F73B5h+HiVxksopYRAWp0vcUzxYcBxEA38N29gOHdNi
   KXDs46z+bCxl7xR0vUlt6yfSu3sw0DmoOuPsKrmthfdwdEh5GI8UZuH8C
   Q954t+507UHyANysqfpBDTVU8yM8Y4bn5DKzNdN0zqq3qr6ZC3O2o1M6A
   fB+SihT5DP2WFmt0Z6BTaCeVSQVcXKC2VTICNqbKYgWjwFvwJYMEsRTnf
   A092o2DugVOep5MXEi+qDoXNFYyd+BlJ1eLMbrae1jMw4DFqYQVg6Q0DW
   A==;
X-CSE-ConnectionGUID: ywqUUFj/QTWTlETIsZNQ4w==
X-CSE-MsgGUID: kIPeAk4XTN+4Ps1V0+/gIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="35943972"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="35943972"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 02:59:37 -0700
X-CSE-ConnectionGUID: cqwKgs4PRauxMZRpjB+5Dg==
X-CSE-MsgGUID: IRzzx7tGRnSGryVb34qz+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="71204117"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 02:59:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 02:59:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 02:59:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 02:59:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFB3SfYlMJvTIyhE6Mg3X96Q7XfGqEpFVk9eQy2t2uMYDSSRgau5l5bgg2TUf7AIAuSxSZciexXuaijQw+JIAu78LgeRdjOkoFiXSF9J7F+K2/Em/NZ/8OakVKsJzGRMJuiVJ1LEO7qO9xAC310RikDS9WGZFCNnZhQ42JCegzjkQFo31eOP/eSUIx0C04DDx/J/fxq6oCMGa9W+6z0glmtzX4+ecZlPoZuM9Ab17GwuJU5ueD6ImVaGB5AmbIbGUYBY1dVWi6WIAROtiJgP3+xjQuC88pdtTG0iMRIzesdi9o/9HBhjmGh9kz5iWY7CpwxyEFC+prU3obOm3nCpCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVQ5v4oWCWX0HCoEXCwYScSY8CNA2NTMoaQ8Kaqzf6Y=;
 b=Qy1Cw2oulHoqWubADs/GycNUyvg/ZAaSjHGE9dTv6IbqeG7NyiNGzqBsuIFqQsXZpfUwerP+qoHVTBTHdI3GFgfgznlqRNXqboshCIZ6UKzITFvzIZ2wnBc/9aa/++mMagWa4vP30ah4DwaBF6lZq2KAN4u2igfZyC0AyL2TzbGNFuvO08ovyGCSui8TCbz+mE95UCB+ua0KqA5J4f0HfUxp9QbF1efdewhtdZNxV+jQop3g+6l56jaL+ZuzUAL/0VjrNqM/vF19n2wEanyfU2qIi+IJbgFvpJzVhOhWgo4V3soWR5KsH/Wt0z69RLXXcj/kpl5nitMr6KPVIZ+ARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6205.namprd11.prod.outlook.com (2603:10b6:208:3c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Mon, 9 Sep
 2024 09:59:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 09:59:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>
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
Thread-Index: AQHa+E/0m/jBQj198EGqOMKWFia1grI91ySAgA2AK4CAA/YAAA==
Date: Mon, 9 Sep 2024 09:59:34 +0000
Message-ID: <6c2c3122eb7c7a615c382e172d9c6d59e595a67a.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <9eb6b2e3577be66ea2f711e37141ca021bf0159b.1724741926.git.kai.huang@intel.com>
	 <5235e05e-1d73-4f70-9b5d-b8648b1f4524@intel.com>
	 <66db7469dbfdd_22a2294c0@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66db7469dbfdd_22a2294c0@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6205:EE_
x-ms-office365-filtering-correlation-id: 1c9f0bdf-d11d-4db9-e43b-08dcd0b61ba8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RG9sbG1pQktNZnl0OGlWMzFJZHVvMXBGbWxlRWZzRTVNdU4xQzNlekk2SEpV?=
 =?utf-8?B?NVpYek5PQ1liRWQ4SmJidklUQko3V0RzaW90Y29kWjVSeTQrSU1xR0RBblVa?=
 =?utf-8?B?UDJvMzNDd1dLeHdyWmltUlpuU2J6YzVvb3dPZUxhZGFRbERIZzBla2J0V1Nl?=
 =?utf-8?B?TklNOFZKRTdidFpsaVJmRnhxM285UTNJK3VhUFpoZ3RIUUliNzBhYUtKci9U?=
 =?utf-8?B?ZzdWWm9uV3JmTDUvQmwzTkJibGlpaUNKYUpKbnJkbFh0TUN1amVVaUFwSXRI?=
 =?utf-8?B?Vld3QVlua0xNRU93c1VDZ3JXaTdiTjdtLytVQjNtMzZnaFhyQWlsM0dTaWI1?=
 =?utf-8?B?U3RoZmZrLzgyL3RvNUlRNVpvNnMxTHIzYzM5OURaN2xJc2k2ZmdNMW1NSUx5?=
 =?utf-8?B?emtMSkVMUFBPd0l5WFZQT2RwcEhLYTN0WGU5TC94S3ZKTXdWVHdjRjQ0UktX?=
 =?utf-8?B?aUd1UWlKZjFtc0FiYlMxTG40LzNLS1ZnUUhMd2hGZUxDUHo3VzlWeEFNdXJ3?=
 =?utf-8?B?QjVmVEh2TDlabU5SemtkOXV0OHl6NlRyeGJudUVrQUp3R2xqbmNsdWNjR0hk?=
 =?utf-8?B?Y1NqV3orUXhqRVYreDRYeTNxbXEwa2ZpNCtFQlNsR0lhb0FtMHNaSC9tWEhu?=
 =?utf-8?B?V1pNOTRvZmpTSDEwUC9VVXhLQnFlbkFoeW0ybWRPajhIc1BzVW91cHVtQVZq?=
 =?utf-8?B?dWt5bVB4UmRyZEZZbkExMndpMGY1Y0hSOUk2bE9LNnIxVFNqelRjY0c2QzE5?=
 =?utf-8?B?ampiWUVIdndVRFpTWjczeXdleXRWTGtqU2UwUDU4WTN5UlRsOUlVMjhMWFlk?=
 =?utf-8?B?dCtsWWVBeEVjQkw3bVdQZVJLajRKOTdDcFlVNUV0Q0QyZlltRWR4ait1REJH?=
 =?utf-8?B?RXVnd2M1NlVkeVJWbC9UUHhCRnpnZ0ZIbFkvblcvdnNSd0lOL1IrdFE1V0RU?=
 =?utf-8?B?OWVJdDVlRG5LamRZemlqL1dSaE9Mc215a2VwZzNPeHQ2OTUxZ3BYZ1FKY0t2?=
 =?utf-8?B?RkdRTzRPVHEyRGdpSTl2RG1uWndSUGp5R2V4WTNOK2M0YlV6UXlvMDkzTUFj?=
 =?utf-8?B?eHhweW1IZ3gvNmI0MEZpeXNVTXpiWjZTMm91cGFkWkIwdiswT1dqaTBkYnZJ?=
 =?utf-8?B?VSt0Uyt1U2ZPWXIyMk1QRXp1cVhGRmorS0hKQm9kVnYyenpLUHJEWm9ZNGlS?=
 =?utf-8?B?SnphUDBTVTdiTjdJK0hRWGtXQ0pMQmtxNkxyN05hL3lGdXgxMmF1ZTdpOFR1?=
 =?utf-8?B?ZlE5bDR3QkJxaTVTV0lrdnJQVVZzWmx2MGlXUWxYNDlva0dvMlNRWlIweUpW?=
 =?utf-8?B?NE8rcUxja3YzMnlhNEF4NjVRaGs2L1NZak1vTXhtMS9VTW9JTCtVRk14aGs4?=
 =?utf-8?B?ZXdMcGN3cU1wQ3Y4alVNZ2ZYeGdqZ0pZRGhLeUZyYnNzRXRGYkZwNW00blBE?=
 =?utf-8?B?N0w5aHhrbU5OMHZuK1dFMkhMNGl2cklWNUNuRzRCM1NZRFF1ZDlJc3VmSG9o?=
 =?utf-8?B?dUVQOXZSWGgyWG9oUUw1d1FGalZoblRoQ2J4VllMYWJkdWtRZWprMXBBU2Z3?=
 =?utf-8?B?YUhlMVVxMWc1UC9GeVBrZDZkYzFidHMzMWNjaTIyVVN4WDRaK3U1UHpmR1dP?=
 =?utf-8?B?L1lXK1MxV3VJbWphLzZRYnl2U2tnU0hrcTR1cDhKRmFMcGVxS1MwNFFoL0Zt?=
 =?utf-8?B?VHFXNnpGekFDc1R4V3dmcVBvNVlSNjBNaUw3MXVEOHNMVk5VU0ZRWVBqaTVL?=
 =?utf-8?B?ZW40UGtabkh6QUQ3cGY0SmxPdFZpUGovMFVqYjgyM1FocFAvNFJUZ3pQVzN4?=
 =?utf-8?B?ZS94dnNjczR3cWhkVFk3KzBiaitVZHM0bjJ6ZFl5MTJtei9TK1VncjNBZzRT?=
 =?utf-8?B?NEFnaGtZdHVTd0trR2Q1WTNEU3RCcVhDaHFnSmNuWlAra2Y3VmpYcC9VZkVJ?=
 =?utf-8?Q?DiAq9xMIx3A=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTJwNmVaOHpsdWRmanQ3NVloTUhFVW5yTHAvNnBycWZlTjdpWG1ybDZwRVJR?=
 =?utf-8?B?RUFjcFpuTHpjWWlYYjRQZXl5anprTUhKaGlCY3V3YXpER284Rmx2aUliOU84?=
 =?utf-8?B?cjdjODFWNTZlSVdnUzNxdm83SHA3K2FoNS9WRXhOMlQzQmp2SExKWkdiZUp5?=
 =?utf-8?B?ZkpPcVpQakhoN25WeEdpMzlQUUtndkJSZU5zKzNYZUEyRnIrQW5UZzdqRk5T?=
 =?utf-8?B?RUFCOGRYNVVGVzJJVEwxN0ErQnhsMXE1Qm5hU1VucERWdnV3M0xRN2FXSmpw?=
 =?utf-8?B?NGExMkJIYTd5Q2llRGYzcXozOG9HVmQva0Q0WFNrMThlakxkN3lydjQ5eUUy?=
 =?utf-8?B?dUVxRURkZFNEL1lZRlhESlBMQk5YUzhkeEM4a0g0MUVzOXc5aTVHN3lPY0dJ?=
 =?utf-8?B?VG9SOHpkVGpCVTlmOU9RR21LNTR4SjZqSW1TZ0t1RVUweWdhQzhzMnBsUjh0?=
 =?utf-8?B?NU9YbkRiNzBOODBpd3JEY1N0cUt1SXBWbmcrakJ6bnBzK1JxSm4xc1NFOFpC?=
 =?utf-8?B?Nm1qQzZJb2Yyc2lYMURMVmFPdS84UktjaUxHaHFKQTlpUDgrWUxiSWdWYzFG?=
 =?utf-8?B?elZXR0crOHZ6UE1mWFhaUXFDYklSMXJVVHhHV0RsSjBGcEZUM1NiM2tkRy9h?=
 =?utf-8?B?NDNac2xoNWpzSjZMVEs3b1NNYWZ0U3g0ekNaWjE5U1ZkZGkybjRzRDZxb1Jq?=
 =?utf-8?B?VHg3TXNqd3ZQQ1V3MllaR040cmZyNXB0Q3RSbGZDRGJTekJ6UDhIRDNzWlF6?=
 =?utf-8?B?YU82MmxTb3R4TlE1MitQdFdRMEhudEhVNERNL1lGYy9MQlMrTHFXVDlPeTND?=
 =?utf-8?B?V1BmN244YzNxUlNXd1FtM0ZzU255NXZLZjRBRHoxOHQ1Nk12QnF4c3F6TTB1?=
 =?utf-8?B?Y2U0YzRuVUoydUNlUldORnBjeFBmTUt2V3JDOTc1UXhlZFNyTmFHb1Avd2xl?=
 =?utf-8?B?K21DakZhQ0FISm5zWXJhU2tYaXNHcHd4VWxCZ1FJeW4yb2xjWWgrOHFRMndE?=
 =?utf-8?B?NDN3WTR2ZzFBWXdLZHN3YVl3V3NVQnlzKzdHc2thRGJ0UHZVblF0aUtXY05y?=
 =?utf-8?B?Ry9kTXFnYXVTTE1Zdy9LcFJyWW9NeGwyd1ZSSDdMc29xR29YdDBscUd1L281?=
 =?utf-8?B?L3N6cnJmekNrcW5pNGIwb21qdWMranNJVVdic0F3aDlkR0lSK0VCL2xkUlB0?=
 =?utf-8?B?aHdkOFJiMzZEUHZiYjhwcVg0QTYvOURJYmlIOWpIdjNPNThKM3YxeXhHMmlk?=
 =?utf-8?B?V3Y3UC9kL1lSSHJERDlDRzUrOVBYdlBGbXFqUVQ3dlRwcFkxbWpLdjBVUzZr?=
 =?utf-8?B?WDN5YmEyY2dDS0RmMUJFbnNOMlZodUVvRnVRSFRDUHZxWXNMbUtKbEE2WkY0?=
 =?utf-8?B?WVJqdCtBNzBFTW1DaWRzRS8vN2hGRTY1c3UrYysySUF1WUhUVVdwV2ppZndj?=
 =?utf-8?B?TUNWNi9yWmtIRDVzMXRReVhWdSs4QkY5QnNHelJWVHh3Q0lsaFk1UTFMTFln?=
 =?utf-8?B?UUVxU2l4YktISTgrRkt5WVVYMHFESjhBT1UyN0tub21PSGtKU3IxSE45V2xt?=
 =?utf-8?B?NHFwTC9UMjg5TWF0K05tTHVyZGU4WjZadDNYN2dTdURiZElRWFp5aGJ2TFpI?=
 =?utf-8?B?UTJUajBCMEtDV0Y3MVVpSUhMU3VwejJiMm5pT205Z1RZVnZndkZDZFZrSy9J?=
 =?utf-8?B?U2ptT3ZFcEhvbGtzT0hXZG1ybnNEWmg1ampVQ0ZsQVpReC9IbU8wSzJnSS9u?=
 =?utf-8?B?MjhuNE1ZeHMxK0VSVmN0Y0NhcTJaMmM4TFBjTmNtNUtocGFqRTZPWnpxYnlr?=
 =?utf-8?B?R2lKalQ5Tkh3cVA1TEo5aTFDQks1WnRQMXNFMU1WcGZSVlZPb2FsSDdtYVEv?=
 =?utf-8?B?ZU5LdG1YWjlxYTNEYVpjUWxqY0pnRkZ5WS80Wk56U3Yxb2dLZkhWYjBBazY0?=
 =?utf-8?B?UW9JOEcrYURrNHZNbDNwWDNERk5tTmlsd1NKOWhOSXdHTmZ6MGRZenJBYlFS?=
 =?utf-8?B?WlFlQkJNZjZ5dDcxMGROc2E5MG1QZ1hkc0xiNnhUdHM4Wk00OHpuQWpvL0VD?=
 =?utf-8?B?bUdONlE2d3R6THVkZnBJbVh2UlB5SENBRHd1VTRXOEk0NEppVExiQjgxc3Fx?=
 =?utf-8?Q?9jdEPr6ADZBmA8M2v4nixLi6i?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42A8A27A73B8E84CBB8541FA94A16FD6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9f0bdf-d11d-4db9-e43b-08dcd0b61ba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 09:59:34.6380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c6CjMDCusbAhmjw+EUeMugi29L4EP4uveUnGLOwGAJP3KzkAcd3zYaoQKu9Q9EKpi0w0085mcMzUeFpP7nWjvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6205
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDE0OjMwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEFkcmlhbiBIdW50ZXIgd3JvdGU6DQo+IFsuLl0NCj4gPiBBbm90aGVyIHBvc3NpYmlsaXR5IGlz
IHRvIHB1dCB0aGUgbWFjcm8gYXQgdGhlIGludm9jYXRpb24gc2l0ZToNCj4gPiANCj4gPiAjZGVm
aW5lIFJFQURfU1lTX0lORk8oX2ZpZWxkX2lkLCBfbWVtYmVyKQkJCQlcDQo+ID4gCXJldCA9IHJl
dCA/OiByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KE1EX0ZJRUxEX0lEXyMjX2ZpZWxkX2lkLAlc
DQo+ID4gCQkJCQkgICAgICAgJnN5c2luZm9fdGRtci0+X21lbWJlcikNCj4gPiANCj4gPiAJUkVB
RF9TWVNfSU5GTyhNQVhfVERNUlMsICAgICAgICAgICAgIG1heF90ZG1ycyk7DQo+ID4gCVJFQURf
U1lTX0lORk8oTUFYX1JFU0VSVkVEX1BFUl9URE1SLCBtYXhfcmVzZXJ2ZWRfcGVyX3RkbXIpOw0K
PiA+IAlSRUFEX1NZU19JTkZPKFBBTVRfNEtfRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9zaXpl
W1REWF9QU180S10pOw0KPiA+IAlSRUFEX1NZU19JTkZPKFBBTVRfMk1fRU5UUllfU0laRSwgICAg
cGFtdF9lbnRyeV9zaXplW1REWF9QU18yTV0pOw0KPiA+IAlSRUFEX1NZU19JTkZPKFBBTVRfMUdf
RU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9zaXplW1REWF9QU18xR10pOw0KPiA+IA0KPiA+ICN1
bmRlZiBSRUFEX1NZU19JTkZPDQo+ID4gDQo+ID4gQW5kIHNvIG9uIGluIGxhdGVyIHBhdGNoZXM6
DQo+ID4gDQo+ID4gI2RlZmluZSBSRUFEX1NZU19JTkZPKF9maWVsZF9pZCwgX21lbWJlcikJCQkJ
XA0KPiA+IAlyZXQgPSByZXQgPzogcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoTURfRklFTERfSURf
IyNfZmllbGRfaWQsCVwNCj4gPiAJCQkJCSAgICAgJnN5c2luZm9fdmVyc2lvbi0+X21lbWJlcikN
Cj4gPiANCj4gPiAJUkVBRF9TWVNfSU5GTyhNQUpPUl9WRVJTSU9OLCAgICBtYWpvcik7DQo+ID4g
CVJFQURfU1lTX0lORk8oTUlOT1JfVkVSU0lPTiwgICAgbWlub3IpOw0KPiA+IAlSRUFEX1NZU19J
TkZPKFVQREFURV9WRVJTSU9OLCAgIHVwZGF0ZSk7DQo+ID4gCVJFQURfU1lTX0lORk8oSU5URVJO
QUxfVkVSU0lPTiwgaW50ZXJuYWwpOw0KPiA+IAlSRUFEX1NZU19JTkZPKEJVSUxEX05VTSwgICAg
ICAgIGJ1aWxkX251bSk7DQo+ID4gCVJFQURfU1lTX0lORk8oQlVJTERfREFURSwgICAgICAgYnVp
bGRfZGF0ZSk7DQo+ID4gDQo+ID4gI3VuZGVmIFJFQURfU1lTX0lORk8NCj4gDQo+IExvb2tzIGxp
a2UgYSByZWFzb25hYmxlIGVuaGFuY2VtZW50IHRvIG1lLg0KDQpZZWFoIHdpbGwgZG8uICBUaGFu
a3MuDQo=

