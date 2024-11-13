Return-Path: <kvm+bounces-31816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D644D9C7E08
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 23:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62CF91F223D4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E6A18BC35;
	Wed, 13 Nov 2024 22:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T+xKASgt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B207415AAC1;
	Wed, 13 Nov 2024 22:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731535262; cv=fail; b=iziyZ/fLmqfkxiFxT/6RkJvyoAudsd4UG06TAi17rnjxepxS7AyXgBiiku0MmvekyEh0F0LN+HAOb8x6vyD5JZmj6tShNRUlOtPeN7x48HovL9XB470XMeCpCJKddKOfl3XlJ7AwJYnVXFLC3zcCW4djvUAiySTHcO2ClCvxws4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731535262; c=relaxed/simple;
	bh=F5LU6FF8t7djOeaCHQNu7KMMQwuBMcSFgPGqCI0FSiI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZHiQAu5weV+FQ6sspPlXPc8OtlEOd+5n8lG0GMdnHvn0r7QN8i8vFAFGFyxstb/KNkDIIlps8CqBwAzvEceyZ5wSF3jaziXNv7e1aGzAbxvntDa3yiH7YRzQqmz6kXNKJ5po0FUvcCg+RPGXT4B1enB7aM03YDRy4lOPZJEP09s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T+xKASgt; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731535261; x=1763071261;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F5LU6FF8t7djOeaCHQNu7KMMQwuBMcSFgPGqCI0FSiI=;
  b=T+xKASgt1zBu22rtvSWSxRv8m9jaqPvck6CbsTR+nJ0rj1k+6mntGY/K
   XP5NshIKvnv2KPI0UoBm+Tiybgu2FtndpbeYkTg4nvJYYHv7Vifiw0EMd
   zK3JOMclCz2kDlCpYJ9a51jnfHMGVqYjpoSMbPOEsX6KH1Ypptox2Ev1b
   XnuQ+X9YtioDu1kHgwk3uUhQIMigDQ3y96Vf22zPExH64QXboZQ2GtNG6
   1XXHWWL4GyS5ZUm6jqFfickeUrK4uJzXGqd3eo6AxTO/xOmxUk77ISnCb
   +xL9HWVnj8BmekcF0PbWCNMwbacWzvNDFDnIMU808YPR8Pmw9mPX/Jn1X
   A==;
X-CSE-ConnectionGUID: gjDN3oHXS2OjdsdIGpR9aw==
X-CSE-MsgGUID: O3M1a6q0SZWRtJgO7VKDLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31222041"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31222041"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 14:01:00 -0800
X-CSE-ConnectionGUID: Ze460n1uTMuj3HpsfiRrpA==
X-CSE-MsgGUID: YfEhr2JjRRyUiOZfyo04Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="93063904"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 14:01:00 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 14:00:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 14:00:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 14:00:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YG9L2UvhUWSmdcrR+j8jJR3sHH1hbg7tfLn/WXwXl3OXoKP6JduvJYew3zd1parODyqwh4Inig7F2hNTz0s1I+quykixF6F5ELTKwQnI16EMQ9KoXNcrxnCenWSMEOG1JYS4cUL1mxZlMrRHVj5MNyvZQ4ixw3rw1QmEGqahosSpzdmzTYz4gkkBA7Ek9z+nPjpViiI7jAsLmkj2Nsh1QrSU2ieFkcMbnuI3PJhlBLRCD41l6+cqdY0NGtoT96/n34DBa6t2cY+lYgl1dUQdNKCvaCvwaPAMiLU7vP+mnAQfVIj25HwUaWhnc5mEaUb16tXjJgu/wrEOkQsnProlQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5LU6FF8t7djOeaCHQNu7KMMQwuBMcSFgPGqCI0FSiI=;
 b=PV2OHjOMr/VgDXNa44SWHCRjvCFWW7fB2jQq0bA5NmzIHMtebry3oIz2rPjojvb2iXzFwcb8tIPci0h99MHslRLSJ8ZetQj7BylyPkN0ihRKHq/hziUqRdBIXDDiROX2aGZKMQwZHyUfC5YcYvnBHwOmHd35jmFhoSlsPXjxOwwLS265zTmvtJCcHAG5zq4B7Nlu465dMzritGYXD3qz+Z5fD3EGP2fnjVALKIoVmRmr+5S9i1MFAgLFevb2tOUjcPQetOc0rPS17RP+1T99W7X7vCRJ5RGtNXu5MmsX/ns2fxc0xW7HXby9xs+y0C8PoEtLEVOpnKHsmUe54gngJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by PH0PR11MB4871.namprd11.prod.outlook.com (2603:10b6:510:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 22:00:54 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%6]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 22:00:54 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
Thread-Topic: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 page cache management
Thread-Index: AQHbKv4rca7tZFwUNEOLKBi110Inj7K0baeAgAFX54CAAATNAIAACg6AgAABzICAAALSgA==
Date: Wed, 13 Nov 2024 22:00:54 +0000
Message-ID: <92fcc4832bdb10be424a5bcd214c5e9e746ede44.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
	 <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
	 <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
	 <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
	 <2adb22bef3f5d2b7e606031f406528e982a6360a.camel@intel.com>
	 <e00c6169-802b-452b-939d-49ce5622c816@intel.com>
In-Reply-To: <e00c6169-802b-452b-939d-49ce5622c816@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|PH0PR11MB4871:EE_
x-ms-office365-filtering-correlation-id: ed08c055-aff9-4fa1-89d4-08dd042ea585
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?d05hNUVPdG4rbnAxQ3dkdHNpNDJTaVRMNnU5amVtaXEyeEQ0dGo0c1NRRXln?=
 =?utf-8?B?bG80MWNoZVpFbG1FQkdBWTJVeXpMcXRqdnRaaVpldFJEb0hINGlUYTgwL3JQ?=
 =?utf-8?B?MS9yd3QvZVhHd2Q0YzM5cEhRZ2cvZmlDcVQxVm9xZmpINlJUMXVYdFRqWU5a?=
 =?utf-8?B?c2owUEgycUxOb2lUNGlSWGkyekNSWHRIczF3MnJ1ZGFMM2FIVHVnYXpsQnMx?=
 =?utf-8?B?dGE2NUxJbDFoSzUxeHdubnhpSlJmZG85YTU3bmZ0eUczd2ZHSXJkRk5lQWdj?=
 =?utf-8?B?VGN0QmxIN0dyOFFOK29WcTRiMGpQOUszRVJ6MjRsZ3huRkwySHVFdytyM0hW?=
 =?utf-8?B?SlpDNEtwQ2ZLOUsvY2JEa0lwSUxNUjhOZDZOeG8xY2JmSUlyYy9uNDllYTg0?=
 =?utf-8?B?ZnZXTmN1aHpENmxaa2YzTkxCanROcW5RdDgySDNOVkp2TWo4aUdRNzY0WGdZ?=
 =?utf-8?B?a201Q3RDZXBTM1diendraGo0K1V2UjZCWTVzcEZwVDgxRlBsdFJvRzc4Ymsy?=
 =?utf-8?B?aXZSaXloazNZY0J0RVE5YnZlaEZCOWpoZ1R3d0NWejlyNXJ5Um1lTFMrTXda?=
 =?utf-8?B?Y2twSSsySEFEVVZHOGJPcmRXSXpXd0dHU2VXZXMvMHRjOUUrdnZNVmV1TlV3?=
 =?utf-8?B?K3lnZWdFZllrWnFvOFJjOTVlU1RMUjFIVnJoQW9xUFBCNEp0cm5xWk5TZ0ZC?=
 =?utf-8?B?cEJGUmxNcnNQemlhTW5JRW1VSGJrOEhERUhXYnVQS3hJNmhZSnNTNENjU2lh?=
 =?utf-8?B?MnlVQ1VUd2xScVhpL3ZqVGxxa1UvQmpwUnQwRmlzakQzMlFzNmxEZVNUL0Fu?=
 =?utf-8?B?cW1tRURNOVUvSjc3UHhaeWlTNDE3V3dNODdkTDdlNnpKRUtRbWNtZCtNZndv?=
 =?utf-8?B?TXBlb1JoVlRFU1lUOHA2YUF0SnZIalJxaW00WjFSYm1zc3A3R3A4MDR1RDQy?=
 =?utf-8?B?WXpWbHMra0FJZUJUUW5vOU1nbXMvaWk5MmNGeVY1WXpjTDZMNXRCbHZ4bGNv?=
 =?utf-8?B?b1JVL3ZLRTJRSW5VbUhLemJGS21PZ24rRmZxT2VvUTB5S0tDam8rY25YQk41?=
 =?utf-8?B?bGpJM2NNNjhuUmtFY2ZNaUlCZklZTTJ4Nnl4b0w0aU1WbnZHUytVbk1VV1VU?=
 =?utf-8?B?OEFtVUpwOTZZQ1hIRnhwc2pPYVdVNWVBbjJvenNtbTFpVFZ4MEQvekJHZ3pU?=
 =?utf-8?B?WUl1clNsS2c3V0NUWW53OVQxMnFDRUZyOGhPMmt0WmhEanYzV0NWVVc0WDln?=
 =?utf-8?B?QlFBZVlXWng3QjFvbU1uamp5eURrYjF0SUgyWVVTekVzZ1RnRTIzUytod2xR?=
 =?utf-8?B?REhjN2FYaVBsV3FsSUN3Z3JWd2hIeEU2MmxDck1YTXo0L2dOT1JaU05SQStx?=
 =?utf-8?B?TStNZmtsV3VIbkZpa2dOdmJxbmx5MnZxMGJFOHZNdXU5N2Y4MndTVitpUE9W?=
 =?utf-8?B?OWZEMXpzb1ZKaCtkTXNCNEo1dzhNZDNHRlFsQnBvVDdPQVQ2YVBMUldrT3dX?=
 =?utf-8?B?NisyaFpTeGxvc1pYZ21JMGp3UElrMzlkTW80Z3BzNHI3MjV0SHVuTHQyelMv?=
 =?utf-8?B?NW1uM3AzOFVWTnlZdnpkVXZXZGlqMGRsc05VcHFZNHVUUmk5Y3JwSndDeHgx?=
 =?utf-8?B?TVJ3S3BXWHhvb3BVelNBUWtpZ215WlMzK2ZBM2tzSU9YZUQ0OTNBK09Xdy9X?=
 =?utf-8?B?WHJ5QkFTaUVMOWVpZ1FBYUtGeUlBbUN1bHRmMXZIdzB1b2ZLNFcxbWtTMElS?=
 =?utf-8?B?cHFDWXY2YVAwK3V5bnpyTVl6UnBNZnAxZWFycktqKzZLUVZFOHNIOVkyN0tz?=
 =?utf-8?Q?psTmury8lxzB08bid4jF4ZxHO6/9B5Fwfa1jk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1lkUkZXaWJic1VkbnNHYm5POFdGKzRESEhteTdhdFRWaDArenFrYXpta2pw?=
 =?utf-8?B?WWIwQkdURVR6VWk1Qnp6RmRBQ0tlMHRvamhXcHZaaUh0QXZ3TDZMUGxsVjBB?=
 =?utf-8?B?M0I0bkZpamw3RHVlc1ArMTNKZGxZNk9NVlRqdTRCV0NEbDVWeDJYekVLakp6?=
 =?utf-8?B?TU9icTJmMFhlcmFyRUo1alphZGRFYXp3UnYrT282NmlLZkNkb0hpQkpmRGJp?=
 =?utf-8?B?aXV5R0t3WUZWV3FZdWJhNG1wL1BmNzBoTWtuNXhpL3dZOGIwSnlmNnF1blBk?=
 =?utf-8?B?Tk9ZdEJ4blhlcC9MUlR4aWRNV2JlOE1ucDJvM3ptdXZXWkgrTlQwQjNLU01u?=
 =?utf-8?B?RVFqMFBxb2xKZDZyYkpCMUNER3lhMXJ6bDZVSGlLVGpCME5jdEtWb3BEZGJI?=
 =?utf-8?B?QkE0S2FVZDZ3cFZwVDkzOFNwZVBPWXduZnh5S3JFdkx5MDBaMlRLdmNSa09o?=
 =?utf-8?B?QmpRaXQvRzNRTE4xUkgwQW5EZnVoNExmVzVDeWFzMWZxdUtPVmdzVmhHaU1r?=
 =?utf-8?B?eW9rcE13YXF4VlBvdFU3Vmg2SFJDUkcyYTNpK3U3a2trTG1pdGVwNk4xTUUz?=
 =?utf-8?B?V3ZBclZaSFY5OHd2OG5XRW9NUEhyeVMySEhod2ZsdWxDTHV2RjNTQ0d5bnJu?=
 =?utf-8?B?M0lRcFJ0L3Y2Tm91QS9CRVRBZWpZaVdybU4rMzBPbDJxKzVyTkdWMzhEelNC?=
 =?utf-8?B?d294R1UvRUdRTnFESXkrYkxMNUxLNHJvVjYybTZCZ3lVZEJEN2orTVU4RnRn?=
 =?utf-8?B?d2FuSmVSeldLT0dOVmJrOXBCRTE0YVA2a2pWMUJrZWhVbDh5aGVlekFyUUFY?=
 =?utf-8?B?elgyZlcvdlkrQlFGbzMzT0NEOTNzUnBvS1VxRnVJYlY5bElvc0ltbUNTZE56?=
 =?utf-8?B?WE54NTVBWWh0b1Z4VG9wTFVRRmxpRWlnMERJL0FhUDNNVCtBcVozQlB0NEFI?=
 =?utf-8?B?cU40czlpQ2V2Z1YxT2RXSkZoeXlXd1V0TlBDS01kbW1lRUJRVE9oTHIraDNi?=
 =?utf-8?B?RkNqZjNoZXFRYkcwZmxNV1NEbkNvSy9CTUhKOXMwOWoxemtMbHVhWjlJUFVv?=
 =?utf-8?B?TFA1Y09Fb0NnN0R5WXNycnFTY0RwSVY0VUhsS3VXZ0x4L1lFZHVvOEk4dDdD?=
 =?utf-8?B?SitjR3lDL0FRdCtyd2kvSmtRbzA4eHpwTU5kZFNZMloxSStTNFdWTkpBZDlH?=
 =?utf-8?B?eFZjWlFVWXFMLzVZUFJyUGxxZDcrekNIRCt5Y0JPcmhYNnAvUE56Sm5KdFNv?=
 =?utf-8?B?WUx3dXNCOVN3N3l0WHQwaDZkVFlXUis5M3YyRTFwdVRpL0pWMnR5azNCOWYy?=
 =?utf-8?B?amtNNE9NVVkvWHQ1Rkp4dldPSjF3TVlYSVYraUtkYlZ2VzY1MElaT3hiRDQw?=
 =?utf-8?B?VFBYOHhaRE5aT0J5UEJnbVpCOGRjSUVvQWc4TmN3eUg2Nkg4dFRPUzFVNnE3?=
 =?utf-8?B?ZE5VdTNnSnF3VEZFYXhwdGs2VFB4Rmc0NysyKzJWeGxPTFpUS1E0eG9OZjEr?=
 =?utf-8?B?UUtBQmwwYmFLSytYYWV2UnE0cjVIZk8xaTNaeTYvelFMZnM0WHFSQVUxcTB0?=
 =?utf-8?B?UHc5a3d1SURjMDVEWVpFN1Ivb0lGSWFmQXZ5NGlQUURGejlOV1JpTVNqMng0?=
 =?utf-8?B?clFraGx1bzRlYUFnQnk1ZlhLdVZKOHpPNDlNSnYwQjlqNUdKNUVCWStJbXE4?=
 =?utf-8?B?SGpLWjB3dWNmWnIvTzFLVVhNcHI0SUFzQzF3ZWRrbVJsaXA4WFZDSi9TNnlG?=
 =?utf-8?B?ZWZ2aEpqQW13RTE1VWVSTUNkMm0yODFJV1YwK1JRYk5aNURpMzFHaE1VSisz?=
 =?utf-8?B?REd3NEsxaU5vQzJNSFc1ekRMVCtGampHUmt5Vk5aZUlGclV3QmUxalY5bU42?=
 =?utf-8?B?OVEydHF3anM5M2p6ZDZUYitLcUp6U2lGUTF6MWpjMGY3dmZWQmJGMmRvdlBS?=
 =?utf-8?B?Qzlid3MwVFF2S0l3OUd2YkttRHpMQXNwbVdWNGVtN2NSSTV2WEpoZFQ2MmEr?=
 =?utf-8?B?VjhheGo4ejlqUHU4c0drelBpQVhxMC9RV0NmNWQ0cTY5TnNOaWV4Ty9HRk1o?=
 =?utf-8?B?MmU2N2dZY0Rwa3hKUFNoVjFIeWZnMU0vc3o2RkZxaElXeUxaSWZlVzBMekg2?=
 =?utf-8?B?eWZWT3l4ZExlVWxOcEpwcnQxOFFBS1NMdDNSbjFPRmhVdkVjbHI3T1h5Q01X?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F207BA96F185F47B8C8F22B489C9E09@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed08c055-aff9-4fa1-89d4-08dd042ea585
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 22:00:54.7950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: il0YWK+MGQ9JmEftZEAKECCbAZzbCki+0YqnO4QQCd1bx7dtA/dtgOhz9IvlDieXhV/VsWTKBr4+5/YXTGGlkVJVUxEGcIXT6Dsl78huJh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4871
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTEzIGF0IDEzOjUwIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMTMvMjQgMTM6NDQsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0KPiA+IE1vdmluZyB0
aGVtIHRvIGFyY2gveDg2IG1lYW5zIHdlIG5lZWQgdG8gdHJhbnNsYXRlIHNvbWUgdGhpbmdzIGJl
dHdlZW4gS1ZNJ3MNCj4gPiBwYXJsYW5jZSBhbmQgdGhlIHJlc3Qgb2YgdGhlIGtlcm5lbHMuIFRo
aXMgaXMgZXh0cmEgd3JhcHBpbmcuIEFub3RoZXIgZXhhbXBsZQ0KPiA+IHRoYXQgd2FzIHVzZWQg
aW4gdGhlIG9sZCBTRUFNQ0FMTCB3cmFwcGVycyB3YXMgZ3BhX3QsIHdoaWNoIEtWTSB1c2VzIHRv
IHJlZmVycw0KPiA+IHRvIGEgZ3Vlc3QgcGh5c2ljYWwgYWRkcmVzcy4gdm9pZCAqIHRvIHRoZSBo
b3N0IGRpcmVjdCBtYXAgZG9lc24ndCBmaXQsIHNvIHdlDQo+ID4gYXJlIGJhY2sgdG8gdTY0IG9y
IGEgbmV3IGdwYSBzdHJ1Y3QgKGxpa2UgaW4gdGhlIG90aGVyIHRocmVhZCkgdG8gc3BlYWsgdG8g
dGhlDQo+ID4gYXJjaC94ODYgbGF5ZXJzLg0KPiANCj4gSSBoYXZlIHplcm8gaXNzdWVzIHdpdGgg
bm9uLWNvcmUgeDg2IGNvZGUgZG9pbmcgYSAjaW5jbHVkZQ0KPiA8bGludXgva3ZtX3R5cGVzLmg+
LsKgIFdoeSBub3QganVzdCB1c2UgdGhlIEtWTSB0eXBlcz8NCg0KWW91IGtub3cuLi5JIGFzc3Vt
ZWQgaXQgd291bGRuJ3Qgd29yayBiZWNhdXNlIG9mIHNvbWUgaW50ZXJuYWwgaGVhZGVycy4gQnV0
IHllYS4NCk5ldmVybWluZCwgd2UgY2FuIGp1c3QgZG8gdGhhdC4gUHJvYmFibHkgYmVjYXVzZSB0
aGUgb2xkIGNvZGUgYWxzbyByZWZlcnJlZCB0bw0Kc3RydWN0IGt2bV90ZHgsIGl0IGp1c3QgZ290
IGZ1bGx5IHNlcGFyYXRlZC4gS2FpIGRpZCB5b3UgYXR0ZW1wdCB0aGlzIHBhdGggYXQNCmFsbD8N
Cg0KSSB0aGluaywgaGFuZC13YXZpbmcgaW4gYSBnZW5lcmFsIHdheSwgaGF2aW5nIHRoZSBTRUFN
Q0FMTCB3cmFwcGVycyBpbiBLVk0gY29kZQ0Kd2lsbCByZXN1bHQgaW4gYXQgbGVhc3QgbW9yZSBt
YXJzaGFsaW5nIG9mIHN0cnVjdHMgbWVtYmVycyBpbnRvIGZ1bmN0aW9uIGFyZ3MuDQpCdXQgSSBj
YW4ndCBwb2ludCB0byBhbnkgc3BlY2lmaWMgcHJvYmxlbSBpbiBvdXIgY3VycmVudCBTRUFNQ0FM
THMuDQo=

