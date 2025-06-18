Return-Path: <kvm+bounces-49922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A74ADF9EC
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:54:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B1EE16A045
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4602DE1F8;
	Wed, 18 Jun 2025 23:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iT+ItKvJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E2017D2;
	Wed, 18 Jun 2025 23:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750290832; cv=fail; b=quz+WeP/44L9KAnwBRfFGN2n6HWSTprNRO/3mndbkPEazbk+FxMTjk1yk7nKL9YdAqv8uZE08vUAlzIiDOOJX6l9nEMRrHezSPKVtxNkxdvtMbAWrya8GTvHs+rNdOsyCvhRwOf+6vRhXvRbgAjpeg438Yum/ZuH4kdNwPona9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750290832; c=relaxed/simple;
	bh=JypMlDvQKZ3xE6XUUejIq5kyZ5DTF5eWfFf1MhLBv4c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bnAjXvm2iZvoj4k2vaHI+JiJm4EGCsqDULSkLjVMLHqq9Ltkn9GnWliYc4TkTMrbeZE4lcdOvahmlSNASZnSiizJ4XXrRJRmHY/GN0mnZFl9CKW3eYmpYDP/QovzMe3RIJS0Hp7REjxeDmz1TLgyl/Ix9ap1DaSt9CAJfHl1m1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iT+ItKvJ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750290831; x=1781826831;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JypMlDvQKZ3xE6XUUejIq5kyZ5DTF5eWfFf1MhLBv4c=;
  b=iT+ItKvJ0r3moLtQSFyrHi6zifeIe7XzOO4xl5q+tersAnsMBd8sG/jm
   kMLvaEkxdoL6q7FHerMi3EPzghH0mJpKJU3949YfWnWnZ9WDKsg0Rl1kX
   r28euk9IASBurJvHMQ+47miq/X5z1BzxQ9fQPFK8YmqswTNsWYyE5911T
   +v4VKmflv5MlHmU3xxdiSnkJCPubB+HzRDzhS7P4Ts4cnUgH6rGr/XvXX
   dybJmc+Yk+V8CWqndvCxAP4FT/ds0z6lI0colAkg+6flwa76VqrtKdv7L
   ZQ9jhBYLjyFYznu31ovI5p9tiaN7xir1jARjLISKAh1zcIaC8zmMsVUL0
   Q==;
X-CSE-ConnectionGUID: 5Sf5pEBXSjCI2RBVFG9n4Q==
X-CSE-MsgGUID: Qz3xXKaTS6qXdyC5IvW+0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52677232"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="52677232"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:53:51 -0700
X-CSE-ConnectionGUID: 6es8T1GvQMOO5VxZFMFAAA==
X-CSE-MsgGUID: kYvx4kroQzKpw8qv2Tokng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="173917870"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:53:50 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:53:49 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 16:53:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.65)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:53:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hyk6zGiUGBH2D0SV4VBXpZuMkylS9TXhVd+TJgfXZUVUJSPvrR17XUzWNWY2IdL9UcbphxNhE8bze7xYJtiEEmkNsqryAbDvWtZooqLoUJoF08pmNzGIvTcznzKK2NjH8wrmUkvPUo/6qDwx5qwZcBOIKxhBVjpJnKUx1dQybysYNshsEIeh/+wGtS+fCS8v5nm9x8snlu45oesRhlQVMVvPcHi1l3qYJRE9xh3Qj2R7+0FMVMFAunG7P3mV96ip5biBehuF0BBUDP8MAzr6DfxpKPLKkbRFONOtMUURPdZSPJ7WIhf6l5QRBWZ8EhbSdrPivRkxTErvLEcj8CvdJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JypMlDvQKZ3xE6XUUejIq5kyZ5DTF5eWfFf1MhLBv4c=;
 b=h7TkAYQwWpQ+RSzJ5xygfXtt0Q4Wyg9jnI/ThP7D6nOJ7J6CSm6+m1GQHVwOkyLdhXQf2+3PgmWayP11pOT+F0Dk472oVUoZm5BjYY+eQM14k8mjSccadrw8Q/mqcxMO+rTWQH8T+tS9x85OdnKGXHJ50NZHOg4ZzaoygjKtAJIsdfuUxbZoTn8lNw9tovRiJtpOUWMTqL8LRa1bH993EzYr5s+1MlTJZxz0TJ1b1jUKebgiNRIMCWbfOzzpeLd9MxcbmH6WMpdKc1MoWGYCTVVfWojZBBiH5Nq0Aa+sLqeyW9Br5nIfUaYOaIgasqpQjwQVu7nusGmLojyn9zclnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB5993.namprd11.prod.outlook.com (2603:10b6:8:5c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 23:53:18 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.020; Wed, 18 Jun 2025
 23:53:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao,
 Chao" <chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Index: AQHb4Em/yMlXy4vBpkewoE3shZA4ALQJjo8AgAAFPgCAAAPuAA==
Date: Wed, 18 Jun 2025 23:53:18 +0000
Message-ID: <ced6b59fb9747c3e57d92b0a5620f9867bdaa106.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
		 <20250618120806.113884-2-adrian.hunter@intel.com>
	 <32c01f03f4971a76f1b7ef3634ee4e6c0ee5d899.camel@intel.com>
	 <SJ1PR11MB60831B85840BD194CBFA6CBFFC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB60831B85840BD194CBFA6CBFFC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB5993:EE_
x-ms-office365-filtering-correlation-id: 297e057b-28a5-4e63-afb4-08ddaec34ca5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q3JVeWdHNG5ZWFRnSFErUkloSkx1NXVxUWRIRU1hOWd5dDk4c0FKZnpXQ1dJ?=
 =?utf-8?B?d3JXeEdtSFd0djRPWi9Kamh1alpnUkZUc2pydXA4OHpnSks1L1JBQXc1UTVK?=
 =?utf-8?B?TExINkZSdmZrUmI1QS93L2gyUnByY1JmdVUwbG01Q1l4RVhuM2c5V0Y4TUFl?=
 =?utf-8?B?ZjA0MGpHbTMxaG1oQTlkbUxxU0s4OUpuZHozVFltYlBSQjJSYktyWFZBR0Zv?=
 =?utf-8?B?d0s4MUc4UnJqNzZaZEtqTi9EckZ0c3k3dU8rQmdiQlEwZ0FjODRSZ3p3Y1ZM?=
 =?utf-8?B?enp6Tnd1alNJamVFWkZiTnFtWm5NOTI4RFZ0M09nT1V4RjRYQmQxV2JpSFI0?=
 =?utf-8?B?VmVIc0lvcHo2MG9KcmRkRlRjamJqWWtjMGl0bmlFT296eGJIUHgyMHdIZ1NO?=
 =?utf-8?B?NWcrcEZPN0RRY0pTd0F5cGhkVlhIZ0JzY0hrWm1XSkFqbEE2blZtWG15ZFYz?=
 =?utf-8?B?YWtvSlFrN1J6V0ZtUVlwUTM3ODc1Wm13bUhicm1sVVZ0ZVVhVDZ3VFh0TXVk?=
 =?utf-8?B?U1E1ZTZzYnVicFArRU03YkFaQ3F2TmdxWFhQbkpMNkc2NWRqYTVnS094K1dN?=
 =?utf-8?B?cXZFblVjNVdZMkxlYVBPM2k4NHFLMWdRZ2ZkcEczVU9aT3FVQ2xsVzZoUG85?=
 =?utf-8?B?aGVaWndhc2V5UW9MK3JVWEZZWHN3Y1NQUnp0NUZJSkVERHB1c2hZL1pNWVN2?=
 =?utf-8?B?eXlYM1dnMGF5cmpTc3c2d1BSdVpCT0FyRzh4U3c4UXZsaW1HZXNDbXZmbzJx?=
 =?utf-8?B?aEc0MEp6MFRiZFdRM1NRS3Ztb01ZemZXcHJnL2tNdkpqTE11Y3RBWVVRN09x?=
 =?utf-8?B?VnU4ZE5yRVBVaVNBTmhGeUhxK3JOYVhZVHQwZDBpdHFrWVFTMHdNUkVmUzZI?=
 =?utf-8?B?MHFBdXpvcGRDZURhMkEzcEZkWW0rQnUwWk02cjAwODVWblVwdnpVYm83djFU?=
 =?utf-8?B?dGk0UUpGdE1QV1Z4ZWRsaVUvNkdnK2FNamJROElvYldmd0o1NzMxelk1TkFF?=
 =?utf-8?B?M01OOWJ6bDVQVzdWNzg4RmZZTlkxbnpOcWxCR1VYTXJEbS9ZUTZuckIzMnpy?=
 =?utf-8?B?bDhEL0NJQTJoM2lEQjRGMk91bHBsQ2ZxOEVMaEZ2dGxHazVqVm8walZJdk0w?=
 =?utf-8?B?SmIxaVRtMXFTVy9OQkM2T3YvajhndUdqOG4zNVpjM1ZFLzBTS1hDTlRaTnoy?=
 =?utf-8?B?VUl3Vi82RW1NZHNhcUNLS0dnaDl1OEY1TWN6MGJUNkh6dW9Ub2tMbHh6ZEIz?=
 =?utf-8?B?eW5BeCtxcDBpRG9XK25HVm9CWWJNck1QaFZ1Yk9NZ2tyTUFkZDdtazlYdUxl?=
 =?utf-8?B?YW9QTnNTQWpwUWhFSmlmc2xJYVVXcnJDaHNQUnJEQUprRTFHQVNtMThObVR2?=
 =?utf-8?B?Z0tyVEg2RVFjOVZyTkM3MEN2UHUrQ0ZMVC85QzRyRFN4MzB0SVd6ZkpvVUdV?=
 =?utf-8?B?SkdXVXZsZFRjdVVwaDlZeFhoTklndmV6cmRrOHJyamRiZXpJdmp5WE8rdS9Y?=
 =?utf-8?B?MWlrQ3dUYWpzbDZrRzZudmdPK3lqb0hkWlF4WnFrdk0zUXh3Z1BNWUNweWxO?=
 =?utf-8?B?MXNHN3YrQ0piQU9lMkhQc0hHWHU4ZkNwNFdJVW9pUFF5Smk1SnRDZDZzMHJJ?=
 =?utf-8?B?MENpRjlmL1JhUjNDZXdKUnZMQkUrTHR4QmZSbjZhRzE5cm5XY3BPTDVxOGs0?=
 =?utf-8?B?MGNQSmRuMFBFeFBQWWpldmhvSkpUeGE0RW9pbjJmeElBZGRNNFBLcFUveVk4?=
 =?utf-8?B?OExzMUtuMDl5Y1BnaXZWVHRpaTBYRVRENXN4dFVodlBkeTltTWdheFk2cFR6?=
 =?utf-8?B?dzJmQ2pNT2xUNEl6ZWRFUkhlM0hScXl1dVVvUDBMYkpaQU9Rd2tDTWhGRmg2?=
 =?utf-8?B?VUVQUTA1WnhLRmVzcy9UNWhwbFZwQUVoRE9vcmtveE5sY3d1UkJiOGNBL3p6?=
 =?utf-8?B?eEFjbnFZbE1mdHBGcWc0SnFOT0pHbnpHTHp5T1FrNDVyM2ppcEt6dnJQZjVZ?=
 =?utf-8?Q?87eJYIeyIk64O9b+ZEWOCwH5hyCHpQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlcwL2VESUNiVWtHN1NQUUFjZ2xmcFlhdS9HbGViajA5WlVob2phWm8xRjIv?=
 =?utf-8?B?b2k0cm5iSnhuckk2UUI4ZU9SQTRTQjNjTExuWWwxRkVrdnV2ZkFZdTVoZXZG?=
 =?utf-8?B?RjZ6SXpYZ1NzcmRyTzRXQ0didGpTY0hEMzRUM0xMaWgvVmR4K0wvVEhzWmt6?=
 =?utf-8?B?YXBTTlU4b1d5QkRTNy9kTjgwY1l2eE1xNVFFSlRDLytGQ2dXRW81VFU4bEFN?=
 =?utf-8?B?UXdvR08vcHV6VEI0bkluaHFmKzFWVk8xQW9pQ2xHdmhoaktTVVZ4RzdxcDJo?=
 =?utf-8?B?NlJjbGIxUEJZYWlaSUpWdHlxeE1JYkhQc0FBNkhzMy9KTlJ0N0JBM1BrazFm?=
 =?utf-8?B?SGVjaGsyaUhadmlyY0c5dmlKSXlPcE1uU2tSUkNPaXJXUk5pWEh0L3RMbmQw?=
 =?utf-8?B?RlVwWUlGaTZ2TUdoS3dXcndvd1BDMXpKdkZpWDZiSko2dU5ldjJ3SnpVcVUr?=
 =?utf-8?B?a3haZ0UwSW1yQkh5enVEZVhCczZlQW5Wak91d1JuR1NkUmlPY0wyaXltajNX?=
 =?utf-8?B?am9JRmsrdWxkc0ZraU1WSHFjNFYwMzRRWDEzZkcrYUFmTUp3TXNrOEF6a0lh?=
 =?utf-8?B?bXU1K09hOVlmeVBiQXFpZWlBcS9iSEFhaC9IVmw4RGRtOUxocnE1dW1pVFBa?=
 =?utf-8?B?TnN6dWVZb1AyL2lJRDdZUUNhc3JXbkttRno5WE5BdGdwMjRjQ2JPN24xVFZz?=
 =?utf-8?B?dzVTZHlhR2NMR2RjZXV1UVdGQmVCcjk2K0hObVVvdXZjQS83RGNUSGQ3WUNv?=
 =?utf-8?B?K2swbU9ac1ovQVlraC9PSVpSTFlDU1h4Z1RVcTROQmN2b0psMUFiUlI2ekkr?=
 =?utf-8?B?T3JmUVgwV08wNVNaUk1vcldNcE1udE9SNEc4WkcyMFZzM25HYW1Mdk5QYWhr?=
 =?utf-8?B?Um0weEdqZC9pZHdobTZLK3FTTTdyTitNMVovSThLMWs0OXByeThWU3JYSGNl?=
 =?utf-8?B?MlJIRE10cHhkWTdCSVcrTGordzFpa05wL1NicHFQb2ZwRmMzamxtNzNMaEF1?=
 =?utf-8?B?L2JMakZHdXFJbk40TkN1dmEwekxqdGRFWFZ2eFVlY0szUGl0eVg5Yk0xVEVi?=
 =?utf-8?B?VEtkeitwcmRaUlBmTEc1MGczT1dwSXlLM3ExaFBHL2xMaHRmZGFkd1Yrd0hh?=
 =?utf-8?B?RytKWDR0VmFqZWFUdG9EQUg5dS9PSVMzMEx4dkcrTVpjU2doSzE3WDI1NlZI?=
 =?utf-8?B?b1ZsaGViWVVSVFlDZlgzWkxINC9uUWM3QzZDQWduY1RhUE5DTkNvZHhZdjUy?=
 =?utf-8?B?YUg2TktJczdVd1VKeDJxU3lHVHZaZ0hvdk1rQXdOYjJQbkVHUG5adElHZkxI?=
 =?utf-8?B?Y2lNekk5WFFiSTF1UkdTdDZHdXd5WlBrVzBtSkt2VlhrOHFyU2Z5RDBYOTJJ?=
 =?utf-8?B?SFU0YVVYSWNqdmY5TWhxK2ZtSnYyL1NKcC9sN1hJOGhJRnF3RHIvSDZTc0R3?=
 =?utf-8?B?ZG1rQWovRGhvVFQ2T29NREFnN2hLczI3QXB3TmtPUHdWYzJieEtvL2ZqMmhr?=
 =?utf-8?B?V00xejhtZi9RUmg1K0pFSGpKNHUyK1NEOFcrNThnM1FtWHNManQ4TzNmSjJo?=
 =?utf-8?B?TmVuN2h6YjRMVzlxd3JvMm85NkFBMEFqVXM2RmdVeFl2WDE0NkE4MTh6bERR?=
 =?utf-8?B?NXBEaGJxb29LYjhIb2JiUkNaTXlkZ1ovcmlIeFlyellRdWxyTml1Z1FDeld6?=
 =?utf-8?B?SG5WZzZuQXd2dUtTRDVhbFBxVWtXNW5wOTRzaTRIYXZRVmdTcHo4TTFDYzNC?=
 =?utf-8?B?eUpUMkw1Ymx6OTRvZ1NEdWUzY0E4dVRONXpWWS8xQTFNWFVnV0NpZjVsVFB1?=
 =?utf-8?B?RUZqcGdaRC9ZUmRENGpoUlNoS21CdmtmSWFCWDlZZWxrcDdkRVRIYWFRYXZP?=
 =?utf-8?B?aFc1dzIybVFkWW9pcFBmemFVTzZNdzBIWEZtYVVLK2NTS1BOQkJzN2c5bHpw?=
 =?utf-8?B?OWRodnAyUDZXa3JIUVF5cnU4YmZiSE5MZ1ErNTNOWXRBb1cvcGtsUG1sMVdp?=
 =?utf-8?B?QjFiVFluUmtkYXBiRDFKTHM1Y1hEb0JNZW5aaUxCNW0vRlYwREVveDJ2UVZj?=
 =?utf-8?B?ZWZCTlQrT1NNdnRNVTg4QzNYdW5SRjdGK1pseTMrRXVEUVRoRkE2ZzJkUlpC?=
 =?utf-8?Q?OSQXGPQvulHR1YK4GVZ3yHYvU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF45873B1A9BDA49B50E6386D474FF41@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 297e057b-28a5-4e63-afb4-08ddaec34ca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 23:53:18.3617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gg68Bpj18nw9SjizZzPn+WNofS9WxSyD3uyHsA/5qDHKh7g0oGiqTMk3R+ap5FmhxMtVdd3NpOf+1CFhJXJlHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5993
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTE4IGF0IDIzOjM5ICswMDAwLCBMdWNrLCBUb255IHdyb3RlOg0KPiA+
ID4gQ29tbWl0IDhhMDFlYzk3ZGMwNjYgKCJ4ODYvbWNlOiBNYXNrIG91dCBub24tYWRkcmVzcyBi
aXRzIGZyb20gbWFjaGluZQ0KPiA+ID4gY2hlY2sgYmFuayIpIGludHJvZHVjZWQgYSBuZXcgI2Rl
ZmluZSBNQ0lfQUREUl9QSFlTQUREUiBmb3IgdGhlIG1hc2sgb2YNCj4gPiA+IHZhbGlkIHBoeXNp
Y2FsIGFkZHJlc3MgYml0cyB3aXRoaW4gdGhlIG1hY2hpbmUgY2hlY2sgYmFuayBhZGRyZXNzIHJl
Z2lzdGVyLg0KPiA+ID4gDQo+ID4gPiBUaGlzIGlzIHBhcnRpY3VsYXJseSBuZWVkZWQgaW4gdGhl
IGNhc2Ugb2YgZXJyb3JzIGluIFREWC9TRUFNIG5vbi1yb290IG1vZGUNCj4gPiA+IGJlY2F1c2Ug
dGhlIHJlcG9ydGVkIGFkZHJlc3MgY29udGFpbnMgdGhlIFREWCBLZXlJRC4NCj4gPiA+IA0KPiA+
IA0KPiA+IEp1c3Qgd29uZGVyaW5nLCBkbyB5b3Uga25vdyB3aGV0aGVyIHRoaXMgaXMgZG9jdW1l
bnRlZCBhbnl3aGVyZT8gIElmIGl0IGlzLA0KPiA+IEkgdGhpbmsgaXQgc2hvdWxkIGJlIGhlbHBm
dWwgaWYgeW91IGNhbiByZWZlciB0aGF0IGluIHRoZSBjaGFuZ2Vsb2cuDQo+IA0KPiBJdCdzIHNv
cnQgb2YgaGludGVkIGF0IGluIHRoZSBTRE0gVm9sIDNCIEZpZ3VyZSAxNy03LiBJQTMyX01DaV9B
RERSIE1TUg0KPiB3aXRoIHRoZSBmb290bm90ZSBpbiB0aGUgZGlhZ3JhbToNCj4gDQo+IMKgwqAi
VXNlZnVsIGJpdHMgaW4gdGhpcyBmaWVsZCBkZXBlbmQgb24gdGhlIGFkZHJlc3MgbWV0aG9kb2xv
Z3kgaW4gdXNlIHdoZW4gdGhlDQo+IMKgwqDCoHRoZSByZWdpc3RlciBzdGF0ZSBpcyBzYXZlZC4i
DQoNClRoYW5rcyBmb3IgdGhlIGluZm8uDQoNCj4gDQo+IE1heWJlIHRoZXJlIGlzIHNvbWV0aGlu
ZyBtb3JlIGV4cGxpY2l0IGluIGRvY3VtZW50YXRpb24gZm9yIG1lbW9yeSBlbmNyeXB0aW9uPw0K
DQpJIGRpZG4ndCBmaW5kIGFueS4gIFRoZSBURFggbW9kdWxlIGJhc2UgYXJjaGl0ZWN0dXJlIHNw
ZWMgKDE2LjIuMy4gTWVtb3J5DQpJbnRlZ3JpdHkgRXJyb3IgTG9nZ2luZywgTWFjaGluZSBDaGVj
a3MgYW5kIFVuYnJlYWthYmxlIFNodXRkb3ducykgc2F5cw0KYmVsb3c6DQoNCiAgVGhlIHBvaXNv
biBtZW1vcnkgYWRkcmVzcywgYXQgYSBncmFudWxhcml0eSBubyBmaW5lciB0aGFuIDMyIGJ5dGVz
LCBpcw0KICBsb2dnZWQgaW4gSUEzMl9NQ2lfQUREUkVTUyBNU1JzLg0KDQpJdCBkb2Vzbid0IGV4
cGxpY2l0bHkgc2F5IEtleUlEIGlzIGFwcGVuZGVkLg0K

