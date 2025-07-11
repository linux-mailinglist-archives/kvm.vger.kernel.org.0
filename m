Return-Path: <kvm+bounces-52081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F70B010F0
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 03:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F4D25807BE
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE87A1442F4;
	Fri, 11 Jul 2025 01:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hrqPHrB6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FA35FDA7;
	Fri, 11 Jul 2025 01:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752198640; cv=fail; b=gpkAMeiozz4cPPWXyd8+KJqqaWgLI1+0kZw3F9a/tMn5tuRDApqnarqT3hW1UQPXKUXdhVjeHhgKkpgEUNblSFizMMI7npU81+6PM5ebNK5Nt8Yl8Fh2hfWB7c8qqvgmqR44RLeLyN8HtPsxDWjGR3G1pvBttNosjPIFozrx5hQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752198640; c=relaxed/simple;
	bh=LYSNRw5rqC9utVeZMmZBILTyOMFp1lStDEXy34EwiJI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QZAOOs9uda2NprwIpa+etQrUKBVsdCkUnWGmPfHa7WbHdIIoDcSvPzISyxUMXKiQhYsiAO8fWiyqGGCNiyPgGgV7PyJ9GA4Hknr5VrDlvo6YODrIz37K0bf2uywcViKXjc/E4ziNadYb5FAVV33r90NMcpZxmepBfSleIpfoVrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hrqPHrB6; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752198638; x=1783734638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LYSNRw5rqC9utVeZMmZBILTyOMFp1lStDEXy34EwiJI=;
  b=hrqPHrB6qL8YKotNFYUzlrsTHhLjEL7Q/cgQGJBFRGqFkOMSedTq/9k5
   g4tBIRkhqImx0gSPbFLXj8EXy0GHaUmEVUzl8lMJM7eq0VJxNIXVJN5UI
   hv2xWNqpPri6oIoFIqu4Qy9WD3NBt+g0soZudS0UiL/f5fdrVlxx2q2v7
   xmMh4k+cirQODQ5hKC5LY9Oz3IRTeuQMxMdegGm6hE8gIF/MjVQQ2nDBg
   vMB5o7vewfdY1aq0X+2A+Kq/JHWb32iVtgtfe6pAYGuw5zycEHtLJumBc
   d9GW2qFdQ1Oq1HfDbzgVUHQpEd6GWfyZLnpLnhbj850Ujg9c3L0Ab3cDM
   Q==;
X-CSE-ConnectionGUID: WOGP8cdaQHyzhs68aQV7/Q==
X-CSE-MsgGUID: nU/KqwpTR1+FClsUr1KvkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="65942531"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="65942531"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 18:50:37 -0700
X-CSE-ConnectionGUID: 6hSVIDyMTjyUbQ2KT7cK+A==
X-CSE-MsgGUID: +2jEjZ4RSGa1O8xEbucIhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="156968151"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 18:47:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 18:47:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 18:47:32 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.66)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 18:47:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aXoB1HEDblmeS0OI1G8nHQnLE5RJ7VM5dnPKteYqFdGVADuVUpNCRX26IiRq9jxe2gmY37qjhEACNZ5yABaRTQuCIFYdKw3atPMee9+yvT7XodJdlMnBEdnfK9mXpojHVyFeRDf9el7GpwIttnib64rhV/UWxCAfVjTG91BSy2zOV6xiyc8SnVqzVTrYxADkfwJXd4YkRrNv3M5QnP3TyR6ZO9p/BR2mWgAOaIEKUfo96ikLVmQi1JDu2eq0NUgRnW7JB6jyCKdcULO7egD3HfhEuSG31PjmTdHPslt0y8T0Bt6m4uYm2j/0TJ4YiIPmyY8PmVRjuaApG0Tw4pzBvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYSNRw5rqC9utVeZMmZBILTyOMFp1lStDEXy34EwiJI=;
 b=cx8rc2iuJeNaat6DUexV8wsqh4KMNTh+4ktaemqMg0WY28y8kriSixzv+mURnMylZ/bMbTyJ0MJRf2aYFmUSCZGXVfASoLcdFnJbFxtFPYI4dvc4aryJJ1RJ7EJ7n7dJxhIFupr4A/tdZXqyF9ITbkaJhGiOPL1NX/4u+zIOf/YlkOthQG0VDg5sGR1ot+MDpp+p5a6V+fFIVLi/uSBLnhac2lYeJA5viY6IXB4e4oiReU2q7NeaILOipyDyKdvwvfIuK4Z26oh6EhlFgNlgkEEk4u0GC5YO+gy5aDUw//FMTjukFgNbeClHlnQKuMqH2emR76ZR6WqzrTaW6Q4JPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9374.namprd11.prod.outlook.com (2603:10b6:208:581::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Fri, 11 Jul
 2025 01:46:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 01:46:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tabba@google.com" <tabba@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQAgAB5m4CAALvngIAAXakAgAANiACAAXZuAIAAMLoAgAlDjYCAA28yAA==
Date: Fri, 11 Jul 2025 01:46:45 +0000
Message-ID: <53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com>
References: <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
	 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
	 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
	 <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
	 <diqzy0t74m61.fsf@ackerleytng-ctop.c.googlers.com>
	 <04d3e455d07042a0ab8e244e6462d9011c914581.camel@intel.com>
	 <diqz7c0q48g7.fsf@ackerleytng-ctop.c.googlers.com>
	 <a9affa03c7cdc8109d0ed6b5ca30ec69269e2f34.camel@intel.com>
	 <diqz1pqq5qio.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz1pqq5qio.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9374:EE_
x-ms-office365-filtering-correlation-id: c00ef1c9-d42a-4dbe-b558-08ddc01ccb24
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TGNIT2FMR2ZzV05zR0ovdXRyd0tBM2NKaHBUamxGM1dSVU02VnRxNDJwd09v?=
 =?utf-8?B?YkhyMldtOTdGT0FEUDIyUHkzTTRLVjBzRWppWmZpVW5kREx5QmM4aVFFQW9O?=
 =?utf-8?B?bXgvUU5uM3dpSVhkQW8xOGkxYktBZEhQR3lhM1EzNUowK0ZlRDdDYzBNWjN2?=
 =?utf-8?B?aEZjNWs0R2xGY0ZtRm14bE1rb1VsVnArQUpicE83VFo0Nk1MOXJtd0hrbkcy?=
 =?utf-8?B?S2N3djlIOGxQZ29FRlhobjd4UXFPc0IzM3p6bGRRRy9tRHdQMENNSzJiaVBi?=
 =?utf-8?B?MmY3N0hqRGc4VXREMWVzcUE4UjdheWtjM3lHNGJzSWpQb05nQm94bG1POWV4?=
 =?utf-8?B?dlN0RldIbk1BdUoxQVhPZVhXemc2MThkamRnWUUwWlJXV1gwcEltd0ZQdVRK?=
 =?utf-8?B?YmxCMDl6YkpJOGYwcksrMFZRSHJJVnRqVHlrUjUzd0RLd0NmaGl3ZTdOTGdH?=
 =?utf-8?B?TnZwNmkxNHVObEJSNVN5MjFtZnRvV2lrZXRIUmpoMUJFbVl6SGl0dk5oUDBD?=
 =?utf-8?B?am1KUTVyRUxvNEMxQy8rZ0ZKTHR2Yzh3T0Q2QWQ5ems0aWJ5VGthQTRuU2hG?=
 =?utf-8?B?ZmpCN1A5eDI0M3ZCMUh1bm5EM293QlZpTmx5eFJ2L3VtNEJ1VGxad1NtbGJq?=
 =?utf-8?B?M00yREhsR245eHVOTnJMdFdVaGJiaTZiTjE0UHNpN05VVzdIK0MwelJEK2NF?=
 =?utf-8?B?TWJ4S1o5VGZxL2MyZ1pDamYwaDZ4Q0JlOHgxTVNRS3I2TXQrakE1VS84UXpz?=
 =?utf-8?B?eHcrWU1vb0x2VnNZUUUreFkyL21DbW1sdjl2UldlV3QrMERIdFAwVkEveWZR?=
 =?utf-8?B?cFY0Qis0eUpCSEo4WTRibjFkUEcyL0orOE5xTzRsSEJJSUxjcmkvTmlNMnln?=
 =?utf-8?B?c2xWRy9HZmVWRUxwS2RFSXZYOVAzbEZlbGJHTXpzUzdxcGJlSWYybXhvMm93?=
 =?utf-8?B?Z3NnYm9iTit5eVRpc1EyM241MjVDeEVlU0ZSaVhPZkVkMkNlZFpzMW45ZVBQ?=
 =?utf-8?B?RmRuajlLNHVvMmlGb3JCTlhSZDE5d044bm5ZQTluSWVscDFvYWk0eU81WlZP?=
 =?utf-8?B?b0VEck5LNlNWVVJPd3hBNEVaaDZUbVpsTDhKaVcvMWJRTkRSNTIvSENCemZo?=
 =?utf-8?B?bjNQcnFxZVRhNS96aEI5UzFiZ001ZVlPQ1RLUHJhM21CRk8vUDhwcHNmQWky?=
 =?utf-8?B?bjZZN3YyOHErSDhXclAzNXVzQTVCVmRBTkpWeUk4Vy9IRG1iTE9hK2Zxdy9w?=
 =?utf-8?B?Q29JUFhVbXk1RVo0UC8yUlpUMHk1bFI3Zm51Mkk5RW90Sm4xYjYyMERST1dG?=
 =?utf-8?B?R1ZOTm9UWi9YU2I0Nk5UeUpibUZKVlh0NGJNV2dWWE4yL0NhZEM1MUUrSUQ5?=
 =?utf-8?B?clFPdzVvS0c1Tmo0N25IaVNDcVVxT2o2VTNXOUxYR1FVZWJ3N3o4TXNFdWp1?=
 =?utf-8?B?TUthS3NGYTRJamZhZEcxbTNpRnp4WVNwM3RSemNkSzJVaUR6RXMxSzB0bXpq?=
 =?utf-8?B?dllwUmJaeFR3M0VVK3ExWEhKUTBjWENkL0ZjTVJFTUErUHVrb09YV1lDRUlG?=
 =?utf-8?B?bWoxWnRGWnFiTENHekZpMng0UmtkREN1Z3M4enJOam9XWDhpQW4zbFdrVC9O?=
 =?utf-8?B?czRBeE1ram9LVVRrWG04OGhVUGIwb1d1aFpXckJkU1FqczAzNHYwL3FJMG56?=
 =?utf-8?B?bzZITStxTW1RVHF5cFdmSmx0bjh6d1lvM2ROeUVKUWVGaDgvMFdYUWdUSE81?=
 =?utf-8?B?bDZ1dEhhUkQ2L1ZOVmxucVFva2tENGxBMVJiN3RwWjRZOTNURmc0d3VhbGVX?=
 =?utf-8?B?SUdPQWhGNFRWRHNuSG1oM3RZTllQa2pTS0lFYVkwOC9mSkVoSFh6bjQ5SGxp?=
 =?utf-8?B?TXhqdG1TdGVPaUU1N1lHNnFjc2VBQ2wwTThZRjExc21IUGY4Y2VmRE5LeTJ1?=
 =?utf-8?B?K0xEaGNrRnM0bDl4RGQweEpxN2t2WnhhL1RDczZ2c0NmVFFtak0vU1UyS2ZF?=
 =?utf-8?Q?uxWpXxSqlVZOv16tfZ+2oJoVyTBuOU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUJZRnlZeVJzSDcrZnZGVWJpMk9ZZ2hVVmw4V2FRRmc3eG0zVWFtL01QRlcy?=
 =?utf-8?B?U1orVU5Qa3Ewdk5vSVV0SXNqYlBpMXJDbCt4YVRvQXA5d29PdWw5RSszcjBF?=
 =?utf-8?B?Ry9IMzJXV2t2QWtZd1NFMU9mTTlpQkxQN2ptTXZKZDRuMnE4cnRoay80ZzND?=
 =?utf-8?B?MStrYVZOUEU5RStFclozakZvOGZ0bUVGU0tJNVlWY2tjL3FzdVNYTmM0OUhL?=
 =?utf-8?B?RzcyeVVwYnNPWUxOTDl4aXI4YVRCSmNZVGcwaHlnUFc5TWt6SkhyMG85WjdR?=
 =?utf-8?B?U3ZFRGQxM3dNTUNtcFFDcGltc0NOS1RqeWlOM08xbUdSUHlzbVhSRFNzTzJV?=
 =?utf-8?B?aWtiSUVtdGNNVks1MGEvT0NlNjVHWkpTczZNN0IrZUFQR0F2K1FwNGp2NTE3?=
 =?utf-8?B?WGt6ZmptWW5DaXgrU0ZxR3VpVTU4a2pwSkFjMU1YNHIydDBOMVFBSEhJMzQ3?=
 =?utf-8?B?VmNMZWpsWTdEeTF5NzhjZXh6dlN1aWdadGo3SlFkaDdjVWI5L0tFMDZqZjJm?=
 =?utf-8?B?Z20xNVZMMTBHNmp5eEpFYy9wRi80d21OYldaaVptQXZpdWpJM1kzWU5oZ2gw?=
 =?utf-8?B?Wkp0V2V1U3l3aUpWMHN5VXdZLy9qK1M4dElLbDYySGRDRzg2SnMzdTM3MkZM?=
 =?utf-8?B?MG5VNHYwSHZqWkFybkw1aDNCUkJmdDQ4aXM0RVVzU1BZQjdaOEw1U0QvZENV?=
 =?utf-8?B?SEdzTVRERUFaU09BTW9yL3QxbGxJRGhOaU1iU0d4OWZqbWphK1dGOWRvQVE2?=
 =?utf-8?B?Y2FiUEpQOVBYMEowNnFwb3BhSWNrd1JIcnZnNHFNU0daSEx6TytCeEsvakxG?=
 =?utf-8?B?UVYyVXFMdzBlS2xlL1RDMHhLazVhT3AvSDNUUWlubUFHTnpCbjg5M0J3VUVj?=
 =?utf-8?B?OGtaaTg1MjdyTVR3dFhsN3ZxNFBxeTIxVHB5T2ZDMk5kSTAzL3A5MXhqbXZR?=
 =?utf-8?B?eENCbDYxeDBucjNFbi9FbzAxUG5UTWRUZUVyYnlQT0hZd3g4eG5EcjQwTUw5?=
 =?utf-8?B?My9OaU1LY3pjeDFKQ2t1RWhDSzZIb3hpTksyR1BqQlk0OERRQ1hQNTlnaExL?=
 =?utf-8?B?ZDRaeE5RRmJVZmxkcWpPelViV29tWWJkS3JTaU1za2dJbFpscmZUYVFXbXdG?=
 =?utf-8?B?Nmw5bzFmVDZGcFN5RlhrWGxjUEhMN3I5RUhzajcyWml5OW81bWdZbGszWGxF?=
 =?utf-8?B?dkt2QWFhdmczTXkzd0lKT0xqYjNGbWdYTEhWOVhrYzRPN2JnNmI5WjBNaTJY?=
 =?utf-8?B?WjlNVGY4cHZxcEZCdG8xTXRiMytIWVNWWTJ6QllTMXhGRjFWV2ZxejIySGdU?=
 =?utf-8?B?SVVDUmU4bUpzbE5Sa05jZ2dVL0FtaXlJQ2RWQ2c3R2NIOVNDSUtacVUwS2hO?=
 =?utf-8?B?cHBQY1h5OW0zTE9CYUg5eWE2dmVSRFJWMUg0b1EwMElQVm9hczU3QSs5akl2?=
 =?utf-8?B?WEhiazB0aTdpWG12bk5BWU9yS2xBbWYzdzY5SmdsdUVjeHZsSmtRSE81TlBH?=
 =?utf-8?B?c0xoRGErcmFkWStCOGRQQVhhK1ZzM3NtRHdjVlYrQitTY0FzYXJ4U1VsaWxt?=
 =?utf-8?B?VVBpM2tNc3ZMemkrVjdjT3BXemlnNnpDTjlWajVyeU52ekR3RE9jN0I4SHJu?=
 =?utf-8?B?VVdOL216ZHQzR0prbEdIc1NxY0ozY0FWdTdTSmJRRjFBWEZBYmZkdUdON0Z0?=
 =?utf-8?B?bUJwcCtMS0RLQ0VhSmhyekhBeW50YURkWjhoZGJSSzVXUGlBNWFIeWZhSERH?=
 =?utf-8?B?V3NpQ0VjNnZJa3Fzd2tTZ0Z6NnA4WWpjVXlxU0dHNWtoY0ZuSFdpQ1cybmZO?=
 =?utf-8?B?ZVUrdXVNeDE0eW4va0MyT0RLVTBFVS92dEM4M0oxazZSN281SnFtZFdBMVNl?=
 =?utf-8?B?bDFRaFhpUTl3b25PenFrOXkwOWN3ZXZYZi92b0VxbC9mNFd0cHVpaHpVVytn?=
 =?utf-8?B?eTNvTGZZY0IwN2JwNTA3eW0rcVVtTmw2MVhxQnJLMG1HRDNHVFJnVUIzUXpM?=
 =?utf-8?B?bFk0ZUN2c0xjSW15WE5tWklwYmxRZjNMSG9HM1V5NnlzTFRqTHVueW9xdExB?=
 =?utf-8?B?NWJGNy83dmp3OUdxY1NTT1B4ZlJwaDJCanJ3WFdMK0FhRHpVS0d5QmxoSmpC?=
 =?utf-8?B?blJla2M3dFNBNzNMWTNURWhlWG5iaVJPZDFBL280Zit0TkhEckpxS3VodEhw?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8B83EBC5999584BA2AD5FDF652B8DED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c00ef1c9-d42a-4dbe-b558-08ddc01ccb24
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 01:46:45.5975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Wcj7o1/n3fEzD3QO/gxSFjgmtaWsLuvs1T4/exjUbVqyw5sW0zoJkcCk3oP5jxH7SX904n5NP9xvjCW0R3Pryq14pMY83p655uxGjhEUmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9374
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDE0OjE5IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
ID4gT2sgc291bmRzIGdvb2QuIFNob3VsZCB3ZSBqdXN0IGNvbnRpbnVlIHRoZSBkaXNjdXNzaW9u
IHRoZXJlPw0KPiANCj4gSSB0aGluayB3ZSdyZSBhdCBhIHBvaW50IHdoZXJlIGZ1cnRoZXIgZGlz
Y3Vzc2lvbiBpc24ndCByZWFsbHkNCj4gdXNlZnVsLiBLaXJpbGwgZGlkbid0IHNlZW0gd29ycmll
ZCBhYm91dCB1c2luZyBIV3BvaXNvbiwgc28gdGhhdCdzIGENCj4gZ29vZCBzaWduLiBJIHRoaW5r
IHdlIGNhbiBnbyBhaGVhZCB0byB1c2UgSFdwb2lzb24gZm9yIHRoZSBuZXh0IFJGQyBvZg0KPiB0
aGlzIHNlcmllcyBhbmQgd2UgbWlnaHQgbGVhcm4gbW9yZSB0aHJvdWdoIHRoZSBwcm9jZXNzIG9m
IHRlc3RpbmcgaXQuDQo+IA0KPiBEbyB5b3UgcHJlZmVyIHRvIGp1c3Qgd2FpdCB0aWxsIHRoZSBu
ZXh0IGd1ZXN0X21lbWZkIGNhbGwgKG5vdw0KPiByZXNjaGVkdWxlZCB0byAyMDI1LTA3LTE3KSBi
ZWZvcmUgcHJvY2VlZGluZz8NCg0KQWgsIEkgbWlzc2VkIHRoaXMgYW5kIGpvaW5lZCB0aGUgY2Fs
bC4gOikNCg0KQXQgdGhpcyBwb2ludCwgSSB0aGluayBJJ20gc3Ryb25nbHkgaW4gZmF2b3Igb2Yg
bm90IGRvaW5nIGFueXRoaW5nIGhlcmUuDQoNCllhbiBhbmQgSSBoYWQgYSBkaXNjdXNzaW9uIG9u
IG91ciBpbnRlcm5hbCB0ZWFtIGNoYXQgYWJvdXQgdGhpcy4gSSdsbCBzdW1tYXJpemU6DQoNCllh
biBjb25maXJtZWQgdG8gbWUgYWdhaW4sIHRoYXQgdGhlcmUgaXNuJ3QgYSBzcGVjaWZpYyBleHBl
Y3RlZCBmYWlsdXJlIGhlcmUuIFdlDQphcmUgdGFsa2luZyBhYm91dCBidWdzIGdlbmVyYXRpbmcg
dGhlIGludmFsaWRhdGlvbiBmYWlsdXJlLCBhbmQgbGVhdmluZyB0aGUgcGFnZQ0KbWFwcGVkLiBC
dXQgaW4gdGhlIGNhc2Ugb2YgYSBidWcgaW4gYSBub3JtYWwgVk0sIGEgcGFnZSBjYW4gYWxzbyBi
ZSBsZWZ0IG1hcHBlZA0KdG9vLg0KDQpXaGF0IGlzIGRpZmZlcmVudCBoZXJlLCBpcyB3ZSBoYXZl
IHNvbWV0aGluZyAoYSByZXR1cm4gY29kZSkgdG8gY2hlY2sgdGhhdCBjb3VsZA0KY2F0Y2ggc29t
ZSBvZiB0aGUgYnVncy4gQnV0IHRoaXMgaXNuJ3QgdGhlIG9ubHkgY2FzZSB3aGVyZSBhIFNFQUNN
QUxMIGhhcyBhIHNwZWMNCmRlZmluZWQgZXJyb3IgdGhhdCB3ZSBjYW4ndCBoYW5kbGUgaW4gYSBu
by1mYWlsIGNvZGUgcGF0aC4gSW4gdGhvc2Ugb3RoZXIgY2FzZXMsDQp3ZSBoYW5kbGUgdGhlbSBi
eSBtYWtpbmcgc3VyZSB0aGUgZXJyb3Igd29uJ3QgaGFwcGVuIGFuZCB0cmlnZ2VyIGEgVk1fQlVH
X09OKCkNCmlmIGl0IGRvZXMgYW55d2F5LiBXZSBjYW4gYmUgY29uc2lzdGVudCBieSBqdXN0IGRv
aW5nIHRoZSBzYW1lIHRoaW5nIGluIHRoaXMNCmNhc2UuIEltcGxlbWVudGluZyBpdCBsb29rcyBs
aWtlIGp1c3QgcmVtb3ZpbmcgdGhlIHJlZmNvdW50aW5nIGluIHRoZSBjdXJyZW50DQpjb2RlLg0K
DQpBbmQgdGhpcyBWTV9CVUdfT04oKSB3aWxsIGxlYWQgdG8gYSBzaXR1YXRpb24gYWxtb3N0IGxp
a2UgdW5tYXBwaW5nIGFueXdheSBzaW5jZQ0KdGhlIFREIGNhbiBubyBsb25nZXIgYmUgZW50ZXJl
ZC4gV2l0aCBmdXR1cmUgVk0gc2h1dGRvd24gd29yayB0aGUgcGFnZXMgd2lsbCBub3QNCmJlIHpl
cm9lZCBhdCBzaHV0ZG93biB1c3VhbGx5IGVpdGhlci7CoFNvIHdlIHNob3VsZCBub3QgYWx3YXlz
IGV4cGVjdCBjcmFzaGVzIGlmDQp0aG9zZSBwYWdlcyBhcmUgcmV0dXJuZWQgdG8gdGhlIHBhZ2Ug
YWxsb2NhdG9yLCBldmVuIGlmIGEgYnVnIHR1cm5zIHVwLg0KQWRkaXRpb25hbGx5IEtWTV9CVUdf
T04oKSB3aWxsIGxlYXZlIGEgbG91ZCB3YXJuaW5nLCBhbGxvd2luZyB1cyB0byBmaXggdGhlIGJ1
Zy4NCg0KQnV0IFlhbiByYWlzZWQgYSBwb2ludCB0aGF0IG1pZ2h0IGJlIHdvcnRoIGRvaW5nIHNv
bWV0aGluZyBmb3IgdGhpcyBjYXNlLiBPbiB0aGUNCnBhcnRpYWwgd3JpdGUgZXJyYXRhIHBsYXRm
b3JtcyAoYSBURFggc3BlY2lmaWMgdGhpbmcpLCBwYWdlcyB0aGF0IGFyZSByZWNsYWltZWQNCm5l
ZWQgdG8gYmUgemVyb2VkLiBTbyB0byBtb3JlIGNsZWFubHkgaGFuZGxlIHRoaXMgc3Vic2V0IG9m
IGNhdGNoLWFibGUgYnVncyB3ZQ0KYXJlIGZvY3VzZWQgb24sIHdlIGNvdWxkIHplcm8gdGhlIHBh
Z2UgYWZ0ZXIgdGhlIEtWTV9CVUdfT04oKS4gQnV0IHRoaXMgc3RpbGwNCm5lZWQgdG8gYmUgd2Vp
Z2hlZCB3aXRoIGhvdyBtdWNoIHdlIHdhbnQgdG8gYWRkIGNvZGUgdG8gYWRkcmVzcyBwb3RlbnRp
YWwgYnVncy4NCg0KDQpTbyBvbiB0aGUgYmVuZWZpdCBzaWRlLCBpdCBpcyB2ZXJ5IGxvdyB0byBt
ZS4gVGhlIG90aGVyIHNpZGUgaXMgdGhlIGNvc3Qgc2lkZSwNCndoaWNoIEkgdGhpbmsgaXMgbWF5
YmUgYWN0dWFsbHkgYSBzdHJvbmdlciBjYXNlLiBXZSBjYW4gb25seSBtYWtlIFREWCBhIHNwZWNp
YWwNCmNhc2UgdG9vIG1hbnkgdGltZXMgYmVmb3JlIHdlIHdpbGwgcnVuIGludG8gdXBzdHJlYW0g
cHJvYmxlbXMuIE5vdCB0byBsZWFuIG9uDQpTZWFuIGhlcmUsIGJ1dCBoZSBiYW5ncyB0aGlzIGRy
dW0uIElmIHdlIGZpbmQgdGhhdCB3ZSBoYXZlIGNhc2Ugd2hlcmUgd2UgaGF2ZSB0bw0KYWRkIGFu
eSBzcGVjaWFsbmVzcyBmb3IgVERYIChpLmUuIG1ha2luZyBpdCB0aGUgb25seSB0aGluZyB0aGF0
IHNldHMgdGhlIHBvaXNvbg0KYml0IG1hbnVhbGx5KSwgd2Ugc2hvdWxkIGxvb2sgYXQgY2hhbmdp
bmcgdGhlIFREWCBhcmNoIHRvIGFkZHJlc3MgaXQuIEknbSBub3QNCnN1cmUgd2hhdCB0aGF0IGxv
b2tzIGxpa2UsIGJ1dCB3ZSBoYXZlbid0IHJlYWxseSB0cmllZCB0b28gaGFyZCBpbiB0aGF0DQpk
aXJlY3Rpb24geWV0Lg0KDQpTbyBpZiBURFggaGFzIGEgbGltaXRlZCBudW1iZXIgb2YgImdldHMg
dG8gYmUgc3BlY2lhbCIgY2FyZHMsIEkgZG9uJ3QgdGhpbmsgaXQNCmlzIHBydWRlbnQgdG8gc3Bl
bmQgaXQgb24gc29tZXRoaW5nIHRoaXMgbXVjaCBvZiBhbiBlZGdlIGNhc2UuIFNvIG91ciBwbGFu
IGlzIHRvDQpyZWx5IG9uIHRoZSBLVk1fQlVHX09OKCkgZm9yIG5vdy4gQW5kIGNvbnNpZGVyIFRE
WCBhcmNoIGNoYW5nZXMgKGN1cnJlbnRseQ0KdW5rbm93biksIGZvciBob3cgdG8gbWFrZSB0aGUg
c2l0dWF0aW9uIGNsZWFuZXIgc29tZWhvdy4NCg0KWWFuLCBpcyB0aGF0IHlvdXIgcmVjb2xsZWN0
aW9uPyBJIGd1ZXNzIHRoZSBvdGhlciBwb2ludHMgd2VyZSB0aGF0IGFsdGhvdWdoIFREWA0KZG9l
c24ndCBuZWVkIGl0IHRvZGF5LCBmb3IgbG9uZyB0ZXJtLCB1c2Vyc3BhY2UgQUJJIGFyb3VuZCBp
bnZhbGlkYXRpb25zIHNob3VsZA0Kc3VwcG9ydCBmYWlsdXJlLiBCdXQgdGhlIGFjdHVhbCBnbWVt
L2t2bSBpbnRlcmZhY2UgZm9yIHRoaXMgY2FuIGJlIGZpZ3VyZWQgb3V0DQpsYXRlci4gQW5kIHRo
YXQgZXh0ZXJuYWwgRVBUIHNwZWNpZmljIFREUCBNTVUgY29kZSBjb3VsZCBiZSB0d2Vha2VkIHRv
IG1ha2UNCnRoaW5ncyB3b3JrIGEgbGl0dGxlIHNhZmVyIGFyb3VuZCB0aGlzLg0K

