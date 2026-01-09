Return-Path: <kvm+bounces-67577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 43174D0B225
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 17:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F5BB30AF9FB
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 16:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E70035E530;
	Fri,  9 Jan 2026 16:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ca6piW62"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E18D35CB9A;
	Fri,  9 Jan 2026 16:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974745; cv=fail; b=C821oU81h3Lfm+4wq1TxNrSCnqccrycP5TYmZUMt6gnw7kv2sSX65DEweTx/KCPZE/6BOVKTrDbRxltoXXetuTXaTlj8uqiqZyfKJ9wf0yVBJQJ2DcrZIDyyJMHDuYKa//f8AdI3kip22UkE+v/cHbMHxA+COtqzK4l1xM0jfcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974745; c=relaxed/simple;
	bh=tNc6qROh3h5GZCzc9qKB9i37bDcBXUDji33oJrzv6UE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vE15Y7THBWSBFrsMoUvEm3KNn6d+/O1eNQOskrMwcjREMGNmU5V0U84pElcEx+sX5nUaiYJ/iTL8EMvdGc/NZ3E/OOMjm+kwlsOQa8nVUb48cRLMu2yPbQYd9CYr7+NWrQvimnEtQhYQjaXl97gkpuZhSSeSZcX71C4c3dSEN30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ca6piW62; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767974743; x=1799510743;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tNc6qROh3h5GZCzc9qKB9i37bDcBXUDji33oJrzv6UE=;
  b=ca6piW62npyy3M1Wv8llg6oJw4Gsp/JdVsFvJ06zqqfk7vuvJiLTlCgU
   H4fMe2ta6Nj134MynB/myAbkRai6STZXAu3jdb7oD43uduaXckRYgZ3+G
   Mh/kzpD13Q7GFv0JYTn5/CXAfwu0HfiAq1j5uOJ9hC252hK0mR0edUvUs
   ctLKSOpRnCqgSJXvjhspbZvYE8F6jgHS4jqDTPPeSkOCH5J8R+369khoc
   cSvvbyJYO1m3enowQ/diYpyXOJmSK0IUxY8iTLfGiVg43AXQ2udCP0EBX
   ODrcE8val3Z+dyrUM+4MUZVx2VnNbdFx4OegMs0AhiwTx53Fe0c2Y4X21
   Q==;
X-CSE-ConnectionGUID: lWcrdlk4QJikTh6LjYDxeA==
X-CSE-MsgGUID: ESVNKCQGT5el2FPR7hd0UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="94830351"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="94830351"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 08:05:42 -0800
X-CSE-ConnectionGUID: NeOnMWIfRX6Vy/LFhFFhOw==
X-CSE-MsgGUID: FyUMzi0QRzSXQCrt/0kefQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="203515318"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 08:05:42 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 08:05:41 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 08:05:41 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 08:05:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JCR6wDx6bV/eWEZ/yYOcllyhP29lzqdbvwHybgBDrzR8AAkGTEmLuHBiFftaxkCw2IaljNajcBnP7rCMPbwAkSBKtvACo41yMj95r5tpadkvMa95W2jO9+KRsW9O3mhJ/d0ZDXsXP17LDCZ8lQ5fbbqrwk6Z6muy+GwTIdezpmnV23uf0W4FGJVNXjWx6PFUe13ykkaSqrlymJaHhlbhG0rjQ3Pecrztvallh2aoGdstRZy3n8X3qqIttmxntbLojffL0eKKrFrpi+pfI6+tOKI3A6JIP8sZTNILCIb6mHKV+cnt+oumaIJuwOV44xxSYLORJyjMeg7mnK2JJfj8cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNc6qROh3h5GZCzc9qKB9i37bDcBXUDji33oJrzv6UE=;
 b=O/UJMfS20vk1zrfU6T+2eeABEewpPW4UFUF+rcHQ9KL4kCfjlzonTq5QJkx0CtGl/Gs/XcCwWxdPoEwpdA3O71LoVZy5DolrHmbCtN1r8eZ76N7lhNjGpjB32wt01t0kw4AltBX7wYnlMtHB6idfY1dLk8aBqgb1/zAMV3/mpySm24ewZGdTtceZPO/Vsegs5aKHXWJx422zXQ+33ODxo2mF0JwDJ/QbXKE74BzsvNK/luNtwPi4p4f/pWJsHxXmWCAeFo3MYbAHELg4wv/UKnByYOJboqJ+5n8/UmrrdVc8gB8H8GC5LV2RyjzMXV0nKX3yt7GW/mBZotyUNG6NWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4883.namprd11.prod.outlook.com (2603:10b6:303:9b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:05:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 16:05:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcWoEG0U6tpU/nuka5qLmVaBAkzLUwtToAgBO02gCAAGMxgIAA2fqAgADZ3wCAAJGaAIABc+aAgABC4gCAAJ30AIAA51mA
Date: Fri, 9 Jan 2026 16:05:30 +0000
Message-ID: <4b75ddb133d35d133725ba270a9dfcb9acda38b4.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
	 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
	 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
	 <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
	 <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>
	 <aV32uDSqEDOgYp6L@yilunxu-OptiPlex-7050>
	 <44fb20f8cfaa732eb34c3f5d3a3ff0c22c713939.camel@intel.com>
	 <aV+o1VOTxt8hU4ou@yilunxu-OptiPlex-7050>
	 <b4af0f9795d69fdc1f6599032335a2103c2fe29a.camel@intel.com>
	 <aWBlcCUvybAYWed8@yilunxu-OptiPlex-7050>
In-Reply-To: <aWBlcCUvybAYWed8@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4883:EE_
x-ms-office365-filtering-correlation-id: 8a6e3753-d7b6-4d51-5ef1-08de4f98e994
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eUxOcXh5Z0o4MHBRYVNkbzJkL1hlNjRaMU9PUmhlM2ZLZk1ITGo4cERPM3c4?=
 =?utf-8?B?eWMyY0trS3hNWHV5OHhRNzE0bTVPbEFUZTZ5RXdFN1hCYkJkdDZFQ1pMTWdz?=
 =?utf-8?B?QmV5L3B6MEs2TmNlc2pTV0QyZFNRK0RqSzM5d3BTSmZKbkJEdk1YY0lmdzBB?=
 =?utf-8?B?STF4b2ZOeTFZUnVldEtyak82QjZHbXJCSHdTdm55SGJiVVIwS3ZJNklTbDQ0?=
 =?utf-8?B?OU9FdHRET29FaXhVQjJTK21EWE5EMFBWRjQrRWk0MTNUa1lHWXM2dFN6TlEw?=
 =?utf-8?B?cWZaSURabklGVVRxaEJDZlNReGdBdzlyMjkzcTcyVWc1bkExQTRwTlZNa3FJ?=
 =?utf-8?B?Z0RiK3BFVndHMXFKRmIwc2lkNkllSE4zSEtoTFp1Si9CQU5LRVMzbm9McmVn?=
 =?utf-8?B?cnZrTjdLYWtaV0FZKzg0VTFka0ltL2FnUjZ0QjdwMGV2d2kxWDEwMHU1MU1m?=
 =?utf-8?B?Y2puNWdYTUZveHV6V052V25EbktYMjBCbHR0c0o1dk95ZkZrZGRhSWtyenVK?=
 =?utf-8?B?UnVabXpXbThuK0Z3SU9aZURaaWJUb2tKQnNCQ2lKVWhDbS9tdFNVM1RCQlhS?=
 =?utf-8?B?SmpzTE00Q1NMR296M2puZHlwQ25sc2FDZWtsbjFWMy9acHIreERyeWtIdVpr?=
 =?utf-8?B?dGxTcDkxQ2JIYUJ5T0VwZTdkTytDZ3M1c0NiV0h6eFovY2l6Ry9JVldvWm1u?=
 =?utf-8?B?aHVybFMvcWJMcnhRN0JFU3BYakFHQjYvVFdWcVdIbSt0RXlxeDRqRnVKLzFO?=
 =?utf-8?B?RGxBdGpUUytROUl6dFl0WitvVm9XRS9veDVPMGxYTDA0SWdtaXZTUFNXTC8w?=
 =?utf-8?B?TFBKR2ltRFRNWjRCTFNIKzZJalphM3lTV2l1cUJoUndXLzQ4bmxpY1NGcVNE?=
 =?utf-8?B?Z1k3bGRnbzlYNzhkVVJkUzFKSFVTdUpHTW5LUEkwQUxDWnZ4aUVaeUZVSHRa?=
 =?utf-8?B?Qy9UQndGa2VXWXFIa2UzMUkyM2Jtb2xkMjduaDdtWVlQR3docklzMjlpZ2xI?=
 =?utf-8?B?NVBoMFRLZDd2d2NwZ3QreUJXWDl6aFllOGkxbHozeFpmb3FWamFkcVM4M1Bm?=
 =?utf-8?B?RW5jMHg5UzNkVVAwRFFXTVNPSnlzYVhtWU1FS1pNdEZCRm1uOG1KMEN4b3Nx?=
 =?utf-8?B?dmtxQ3VRaGlDRlRGZkdwVEg4MW0rRHdldnhGd0oyUnBuWHRpb2F2anhldGZv?=
 =?utf-8?B?eEdpSnI4NVkwOGNRYXE5Mk9xb291Y2d6eStZejl5cisxb0ZjZWtHd01QUXBm?=
 =?utf-8?B?V3N4d2d3WThuL2x2bDhZcXlpME9SdjRKR29ia09TaGpWYWl0c1E4QVZBUVpr?=
 =?utf-8?B?cm1aYWxmNXZXY09ORTdKbkcwTGR4YnhJME9DVHRiSEFHVklZQnJ6cVhSUUJE?=
 =?utf-8?B?SDVrWFN3blJFdk5HcFIvbnFOdE1jY3pVeWNrb2xxQXJOZ2xGdXRaVU9oRW43?=
 =?utf-8?B?ZHpTMlgwYTJEY3hWS0E0OWF6N01DVlUvRTlnQWNUSXRLNnBYTXF2Sm1zeFE3?=
 =?utf-8?B?VGVONDc3TDg2c0ZSU0dmSGxMbkUwWU9FczAxa1BsRUk2LzFoakdFTzFZWnow?=
 =?utf-8?B?ditpZW9RdVBIZ0Z2eGNhS3RnSXluaHVEWHJQRXdSWkJvcERNQnlZME0xSGpP?=
 =?utf-8?B?S1R3SUEybmlpQmJoQlpHQ1BvemEwMms2dHVlcDIvcVFQRUJoL1lqSTVmTUdO?=
 =?utf-8?B?YUhjL0FSMlFlWnRFVms1dWw1alNYSTkzUER1YjRQWjZGaXNucnBwRHhFWEw1?=
 =?utf-8?B?Q0pkcks5dVJuU0pmUGZjVUNBbW8vOTFORXVISWpnK05ucnBrUXBmYVF4dVA3?=
 =?utf-8?B?QXh2MXZENnJSdVduWEJHOEhiY2MyRzcrS2Q0amhFb0VDaEtOdzJZRzZsTW5q?=
 =?utf-8?B?N0dGeVovVStObjJJK25UbklQNVJDcGRvbWVhUlpLbzU4R0ZCcXVVWkNNOHpr?=
 =?utf-8?B?YnVtVHJQVVM2ZXBCZ3hyUGZ0R285RTc2ZjhyNVdCWUN4cDRXZFZjdUhpdGkw?=
 =?utf-8?B?QXp5aHVvTytUMDVBSEpic3l0S0M3cytSc2JkWUg3bXc3dG9xM0ZUdlcyelBk?=
 =?utf-8?Q?AP5XLM?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFhqalFlSFd0QTRjalJaU0hLRHVSWTBGdjVMMmlwb2JmbTk5WngreHlLMHBz?=
 =?utf-8?B?TXk2dmQ4Ni82R1dGbGE1UFQ5a1h5WFNDUHRBSzhvbGxLK0RaR28yWjIzMEw4?=
 =?utf-8?B?VlNSRUJBVjM5ZGh4RDZpMVZEeE5Fa2IyV2NvYksyZXB3aHdjOTUrS3ZISVdZ?=
 =?utf-8?B?N1VuQi9sR1dmSHltVk42YmpVSU5vMEdoc1RTUUNNY2p4cXhSb2w3QVlxR3c0?=
 =?utf-8?B?TDlsOCtKWElTaEd4eE5KdFRIeHpZNm5FQ0g1NUdlcnBqYlhUVnFBYkRUVVNS?=
 =?utf-8?B?ZkVJTDRFc0V6Z3J0ZjhuVFZBbnRKRTlpYnhrenhGYlhMM1Jyb3pRK3Y1TUlL?=
 =?utf-8?B?TEpqM2JTYytyd0tGNC90YUZPUnNBS2I4QnRMd3owbHRXbkxVQmZTL1pvVlh4?=
 =?utf-8?B?RW5pdldDUndXZHpveVFoanUzOGh0Y09tUDlUNlluSXdjZFFOTUN2TEQvdTBF?=
 =?utf-8?B?VnNQS2FsdVkrdUR3SWNFZ0Q4UXg1dEdwYVdpU3JaSFdVSUJ4UTd3anBvdTR1?=
 =?utf-8?B?MGZ6YzNaK0pTYWlySGc0a2tQUGRWUmdUaVlQSmhFdG9jZElDdTZtRkpZeFBq?=
 =?utf-8?B?ZlRBSU5hSWFFK1lPVTRXVmtjNVFzellJak11RitLN2l6VTd2YmVCNWVENWNI?=
 =?utf-8?B?S21yellnSXYwcDRwWjZSWWpJR3A3WmgxT01JS0J6SDhzc0IxNWJxZklZdHRY?=
 =?utf-8?B?UmNWVHhrUG1iaExybmREZ0hPWGxjaDh0RE9tdUl4UnJqMFVmMnA0b0xOdDFJ?=
 =?utf-8?B?TGhWeWsreGJINDNCQlhHNUNPVlNqWmpjQjlOeGJtbWNIZ1oyZzlkYmxXaVEr?=
 =?utf-8?B?VDZGdjlvdXZZUnpYT3Y4eHpYcjRQVUkwdmNXSC9kcVVxUlVjWVQ3cXkza05Q?=
 =?utf-8?B?QnBld0x5aktWYW1RUDZsQ0g4RnB4MmFvR1pHYm5FanovTjFtMjgrWTFDRzF0?=
 =?utf-8?B?aVA1d3NnT1A4aVJpeDd3MlB0S3FOVjVZWEZiYy9jRzhwRnFqQ0pROWR3VjFt?=
 =?utf-8?B?eHhoN2ZVKzRpTVM3TjF3dXp4aHdBNUhqdm9ub2RUUDBWV3c1L0ZibFRhSGhk?=
 =?utf-8?B?bEladTNmL21HbFllK2xaRnppQ0d5ZEwxUnQrNG4yalNyVTNJZHZGQzgxRVNO?=
 =?utf-8?B?Q0k1a093U0V5amVxODdFR3BrdFVhMFZIcFBBT3MwUjBnUWoydmVvTVFwWW85?=
 =?utf-8?B?T0lZOXV5cVVWUUJDeUdCNHRFdW9TZVhlSnZEeXZFeHZCUms2SlJCMHorUUtY?=
 =?utf-8?B?SElvTVBPaHJ2ZUtLVXJqbVhnZmIycG50ckRGZkdESGErVytsa3dYTGZ3LzlO?=
 =?utf-8?B?UzJXLzQ2Y3ZMWnN0dVY0U3phcnRZQ0k0MWZmSWxWQjdPeDlYN2lmZVJ5NWdx?=
 =?utf-8?B?QSs3ZVlTTm8zY3F2YytBeDZaWWhoZm51ZW9sNVlZeUJQSlRram5BUmI5bHNT?=
 =?utf-8?B?a3NWOC9Wem91eC9UeUpwMG16MVdCN2h5dTQzcEUvMldzcUtKcnRWWXhBTVc2?=
 =?utf-8?B?ZmpLdy9rUEwzUG9LRzZNNk1NWm1WVHJPUVN1MiswVG1sYWRoaVR5dGNqU05w?=
 =?utf-8?B?OTBPRUFVV3dKdzI3NTlTaHBwSGZvbEIybGpvaVdBNUM4dnM2OG1UMno3c3gz?=
 =?utf-8?B?czV4T2hLUU4wQmFFa2lHTlk1MEFCK082WHdnUSt1RmxMM25mNHZQREF0L1Av?=
 =?utf-8?B?VFNJQnVLSlliVjMraWhlUFk2dVFRb3M5WDhDcDV6Zk5KMHhhUU5GT0gwVVdT?=
 =?utf-8?B?dm5rbE15a1NEK3BVbDI4ZVlkZTNmYWMyQzZLT0svQUpmUjBPVW9YQjBKK0kw?=
 =?utf-8?B?VnVhNzI3QS9ueE1rNGJaRFNBeGRxNTVoQ1pOb0pkT2FsSGcwT080eDZpZm4v?=
 =?utf-8?B?MEtObUM2QXFHMk1PVGxIVDBHK1NBYmd4bTk2TG5xTmNVTVpLY1ludStYS3Br?=
 =?utf-8?B?bkJSR2RFL0p2RVJUay82b1FWb2s1Z29XTlpqQTZpcTVXRm1pa1dRbzhDU2Jy?=
 =?utf-8?B?cm5CZ2pCZ1B4ZzlaN1pqN0F5OXl6RU9FRmNzVVdNQmwwTk9lamUrV28xc29U?=
 =?utf-8?B?ZVJBWEh4bzYvNDhyZnErR1FMOVVEaENLUkg5S01wVXpFT3k5SDNaclRKM1B3?=
 =?utf-8?B?cnIySzFNdUFVd2pCVldDTVdNa1FtVXduY1BFbi9ldmhPaENlL3ByTWNCL0lG?=
 =?utf-8?B?SDFzb3BnTUk1Zi9HazhYY0VHNVpHVFlFMVRkaUNES1l3eFVtTm8xZW1GTjdL?=
 =?utf-8?B?RUZoYTlrUTB5NGpaY3g3LzY5dzh4VXpvUHhRWWVqWUptR01RTXN0Ujc5NVRH?=
 =?utf-8?B?eGNtN2FzUDREM0hKK01nU0NsWHdtRkIyVGVIS1F5cTNtWUU0MWFzVm9LNEFY?=
 =?utf-8?Q?bzzVNuUD725rvPT8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF500649831BDE4284EFAE7868D5E6FB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6e3753-d7b6-4d51-5ef1-08de4f98e994
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 16:05:30.5545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KTVJ7Rm6aKRQ21Q6tFkhIWusQg4VfWueGibiFThEy3/Gh8MX1B9cKaGlHekFXTXPcSsUzRqvUkGhK1eMwkJWBu76MJMRESFLYVIPgcIbIIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4883
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAxLTA5IGF0IDEwOjE4ICswODAwLCBYdSBZaWx1biB3cm90ZToNCj4gT24g
dGhlIG90aGVyIGhhbmQsIHRoZSBjb3N0IG9mIGEgbmV3bHkgZGVzaWduZWQgZmlybXdhcmUgaW50
ZXJmYWNlDQo+IGZvciBhbiBhbHJlYWR5IG9ubGluZSBmdW5jdGlvbmFsaXR5IGlzIG5vdCBsb3cs
IGVzcGVjaWFsbHkgd2hlbiB5b3UNCj4gd2FudCBiYWNrd2FyZCBjb21wYXRpYmlsaXR5IHRvIG9s
ZCBURFggTW9kdWxlLiBUaGUgd29yc3QgY2FzZSBpcyB3ZQ0KPiBrZWVwIGJvdGggc2V0cyBvZiB0
aGUgY29kZS4uLg0KDQpJIHRoaW5rIFREWCBtb2R1bGUgY2hhbmdlcyBhcmUgc29tZXRoaW5nIHRv
IGNvbnNpZGVyIGxvbmcgdGVybS4gV2UNCmFscmVhZHkgZGlzY3Vzc2VkIG5vdCBvdmVyaGF1bGlu
ZyB0aGUgbWV0YWRhdGEgcmVhZGluZyBhZ2FpbiBhaGVhZCBvZg0KdGhlIGN1cnJlbnQgd29yaywg
c28gSSBkb24ndCB0aGluayB0aGVyZSBpcyBhbnl0aGluZyBlbHNlIHRvIGRpc2N1c3MNCmhlcmUu
DQo=

