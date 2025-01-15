Return-Path: <kvm+bounces-35484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 825A2A11636
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:49:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F2C03A2148
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BB31F5E6;
	Wed, 15 Jan 2025 00:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J8EUlCUd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1886529A0;
	Wed, 15 Jan 2025 00:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736902170; cv=fail; b=B8iIKsQ+LtUUVShBVOP3NS5q5TxE/n2DRm0WXbwvpPMupAFgtrpbRaCYAJ9PAYmOsPIT5xHxKDKjmPi7xaxL5lVHb0s+c9Sw0bzxt4LIPcT5CoWs/R8ZR1SceUk8Qr4mgx724csc+Guowx2txQJm3IBMgYLvZ1LoxWpR/jIHUD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736902170; c=relaxed/simple;
	bh=2rukmL1gDF8bfpecdgAPZd8+5OECf5VwDk3FnnW7HUQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kQW4Dxpc9MCm7F6ocgqVxZ/xXugTqIHSKSOXuVPJQbFrWmuUbFLoYZVDtskUaG68jy4nfS3WbxiADObNm1M2Fpx8Np01xXf6zgobciE9Z9lfFhczcAVYQyeTdtNc/bJSueC7Y1OUIIUUuS/1E2S/BMJPFXTrI7cX6dtQuU7BvGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J8EUlCUd; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736902167; x=1768438167;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2rukmL1gDF8bfpecdgAPZd8+5OECf5VwDk3FnnW7HUQ=;
  b=J8EUlCUdTsIFVREu9tnGfS/oJiFQF9thTuib3ZfbuvDOr/Wxz2hqdFHq
   lGh6v3rtQfsv6VKj8af4bIqYtCLPIqNXA72EA4R02Em2NHCXOw+bMalId
   mgNXJ4p4XeSI1syQMxNVuG8gwLB71B7JAkS434p+yH6iHi4LAInARULN+
   00/i573kVNnlmcLTzBT51i0B19+pADW1SRFt8Kv/iWPwBqSsDgIXDtKdc
   UBWb0abCSVPVhRNzy9vKR+JDtkgGcfUre/9SsRbtgaFqT71FzlvOB7WTJ
   2AH1NybjoVQLsvivbL7gBfuBEOiJO2xUCTKttGt06ajUqnDoBIZNcJU0A
   Q==;
X-CSE-ConnectionGUID: WhJXs8MoQJKf9zXRlf0YjA==
X-CSE-MsgGUID: AmTiOYmERAS6OKdF+oEheg==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37378812"
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="37378812"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 16:49:26 -0800
X-CSE-ConnectionGUID: Aaf04GhWQB6Q/2ETSx5tMw==
X-CSE-MsgGUID: TqFnE//yRHyhHWC+MjlYcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105839929"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 16:49:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 16:49:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 16:49:25 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 16:49:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gn8S//aj8fRhZaU28CFnZRfm+e7/gU2a/ZNSkQAzeVFpU8cDCURc/kOPcXNjcz+O1lLrHV+UjIVMMAGF3EihylaS7dP1lcdhUTy8w9Nkes50h0M+dozgFLlXFtmrjGUA3qCdkwQjsNnj67RmNrKhXPeZ0neeZDWOSXT5dTTaaubFGIYkjZP3iwuRKXEMpTB7/a/lK7a+EjhW6b7wlHqEqp5GW0x4t5FowDOKDT/UoO0Up3bFfaDXf04KOI6CvOs677kLiwWp+/LeRMa14cDpjv+94Lo85E2BNFc0gbMTF2rGOvq8Rqb0Rb5eoRasMLETYLjbMWJ54yRScxNLaPUHjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rukmL1gDF8bfpecdgAPZd8+5OECf5VwDk3FnnW7HUQ=;
 b=nwiOIV1rk+IjTw619NP2yLMub4eHa68rCCk1DvQUnqGRwdgHMNBmzPOb4yrccGD6pamhypADjkrXfwBNVvmYB0ESeZMPUGyRFgfu1p+kBSXywZ/2saeaznsgePNH3U35G5lZWcE9ejRMLWV0yTgw6QOJFaTkXU6uTumc8z1buPH/caoLjI0nCOw3oL7FBGNgKBGtqf+UXnm2ty3gAJRy9ytm8RGE+Ex2gA+nTheYfZjdDO4w7zI/qgIqPUjJmCwo8M0YwpgZSautlQOQFdSsXMtAPO0qNincwn7GcaHQQ0yQiqG0R7wLadXCtosqJm//duXAu8YOG/v3IVGEdOOVxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8701.namprd11.prod.outlook.com (2603:10b6:610:1c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 00:49:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 00:49:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Thread-Topic: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Thread-Index: AQHbXCHZnPs8r4rRz0yF1XZL7xOWcLMEJPsAgAUgfgCADbtkAIAAFXcA
Date: Wed, 15 Jan 2025 00:49:15 +0000
Message-ID: <6345272506c5bc707f11b6f54c4bd5015cedcd95.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-9-pbonzini@redhat.com>
	 <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
	 <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
	 <be581731-07e0-4d5c-bee6-1eb653b7b72d@redhat.com>
In-Reply-To: <be581731-07e0-4d5c-bee6-1eb653b7b72d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8701:EE_
x-ms-office365-filtering-correlation-id: d5d6febf-70bf-460e-8ca5-08dd34fe6fe5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Tm1RWkxDRVNlaUJrTHpCV2VNMlNQeUtPTGtRM3ZUR1lBOW1zU2d6eTdSdHEr?=
 =?utf-8?B?dEhJdk1MK2ZUT1krRFdPbUF2eExFQjlPeW1JTnJnTWxEZHdHdHppRlphZjZM?=
 =?utf-8?B?WHpuMXgzc1Y2eDd4RXhuc3JVMjBJRy8xV0kxWE1GT2d4MEdTcEovOUdyTnha?=
 =?utf-8?B?ZEl5OUFEWll1WURvWFY4S1FMck44bEszVFVNNXMrSHEzemRNa0hWYUdFd0o2?=
 =?utf-8?B?TTFJR0NaeFlXMm10UVROOXdCNUhlZmtxTkNKNTJwRkU2elo0U0s0Y2kyK1dI?=
 =?utf-8?B?bUlJZm9ienhNSXJac0FlOXdESkdRQWtnYWxJMm95R0NwZE91L1hqSnZjcTBs?=
 =?utf-8?B?VWxkU2JvMFVvRFoxZjZ6RWhxbDhISzlhQTAyUzdQMEVTa0hUTW1WZDVZcFA1?=
 =?utf-8?B?KzNQYTAxQjFvVThlQVlvWDFqc2Y5THVKM3dpSWJ6dzV5RGs2dUM5Y0lVYU5q?=
 =?utf-8?B?TTJSaWQyT0w4MzgxKzB1WWhraHI4bTA3RlpTRjhmQjVUNXhsRThHQ0lyYS9V?=
 =?utf-8?B?YS9aNkZUamlhckJsSE01c29ZRUxhMi9FbWJxK1kvWHA1Q0ZtRjkwSm11UzlL?=
 =?utf-8?B?clF4MTJVQXZJVU9mNGw4RjZNUkN2clI0L2ZKNWEvbUFlQUlXNlB1OHJtQkc1?=
 =?utf-8?B?ZWVyUEo5b1NLd215R0thVzRpOG1yTWs5Vkh2YnRKN1dFNUFmeUpxUC9WVTVj?=
 =?utf-8?B?bmdweXRxOFJlUndrVEdaUE90Y0RxSWN2eXI1aXN1SnNKZ1pGcHAxdWtNWm1y?=
 =?utf-8?B?WUcxUTYzbmwzTHdQYXRrYWQzQi9yTU5GOEVpeHhUVWZLV2hTdi9iSS80TUVX?=
 =?utf-8?B?RGx0MWZVenVmdDV6YWVFYld1UEF2QTNVOVBsZS9wMS8wbTlzeUloZGxHdFls?=
 =?utf-8?B?SGR6cXROR3pkcGpkK3h1eUx0bHlMdS9GVXRQZm5UNUk5ck1FdytQbE11TnpT?=
 =?utf-8?B?RkRXQmdQVXEwTHl0MlRKc3dKZitVQ1VkZTdKN0pLVnlLenVISlhlTmV6blAy?=
 =?utf-8?B?YlFxRjdhV2ZtellYd25mRC9teG16WVgvOUw3elZxRXo2dWlZSkNZdVYwRnBL?=
 =?utf-8?B?Njd1c1hMOFcvRFBqUlRWZjVwVkdVY2JiclFaejdEN2xiQ0pOSUlaOGhiMkFK?=
 =?utf-8?B?cFMyOVZoekMyWmpRVERpNkkzNUU5RitwaDl5QXlibXRBZitNMmFlUlFoeXZx?=
 =?utf-8?B?a3Z5bW9hSHlHQnhyWmNHODFXZ2w1cURwMGM1WVI0ZXdFVnVocUFncFV5ODA4?=
 =?utf-8?B?WUhWT2FzemVVRStlclJXVjNvNHYvUnl2MzVPN1o4VndIMDBnSGF3UWFjWFB2?=
 =?utf-8?B?Y0Z1UzdMQkFwRzd4eEg1L0FxcGZmbnRpQnZ2RWdKT3BvSG9CNGlVMDJQTlFO?=
 =?utf-8?B?WG5wbkFPdFZ0MnZxTGE0emxwbk9UWUdUMDV1bEM0bFlJc0tSTmJrbnF3bHUw?=
 =?utf-8?B?TWxETXRZOVR3SFd0aTNudWt6Y0IySkQrM0NBeHRPcGZtL2Rmb09ydE01Ti9a?=
 =?utf-8?B?ZnR3K1p4eitNdGdUSDBiMDIrUW45TE5ZUVBxaWpDek1zZ0xMVG5wZFFYaVdl?=
 =?utf-8?B?eFB1bmxyYUV6ODJnMDJEdUZQaTMzL3J5M2J3a2Nkc3pBbDNBYVF3eUxmaEF6?=
 =?utf-8?B?WTJoUWRtbWt0MkZwVW5IUTZyL3I5U0NWSUdZYytqRHJzRFUrU2NvcmRNWlVP?=
 =?utf-8?B?NktocloyeUt6bXRQUU1wN3lkem42TDBIN2tSQ3luei8ybTkwaFZFL3VrMWFm?=
 =?utf-8?B?UG9sdkpGQzF6Q2FteUVCcFZiRXorNkZmMzNFYWdGcHZ5bFhjck1QZDFzV2ln?=
 =?utf-8?B?K0JiYTBPT1l3b1p6MHJzMnprRFBGczc5WFFHcGdVWnBIUE1pYlptQWxKNWlK?=
 =?utf-8?B?V08xZWxESnFxUUh5bUxEc2xNcUxOTjhJa1NrTmZ1Sy9ENXVKQjZOR0lzVzVx?=
 =?utf-8?Q?vXotSWdjD2/TS1Af1X2iIstQ9ue5wQVC?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVBNWFBmVzJxK0RYbzIyVTVBblFuMEJtRTh3M3dBclYzY3hXNXhFVW1LRUpV?=
 =?utf-8?B?dGZaMkFlVXNicUhzM1FIQUpGSE90K3BuTUkrenAzT3cwd3Nua0RsL3NsSXU2?=
 =?utf-8?B?cGw0aFZ0ZzdLQk1NS3ltTmZxQlZXdWRiR2Rnc1FGNGJJa0lSeXZaZ3BjdzhW?=
 =?utf-8?B?SHBnNVd0R09xZ3JRdE5FTlFaQW1ld2JrY29PMkp5UHlNWDZvR01EU25NZ0Qw?=
 =?utf-8?B?dmRiWm1pMm5MUU5aVlFtVW1Ed2ZoS1o4YTRHVU9vOUQxblljeVFoWWZlZEF5?=
 =?utf-8?B?WkxxeFdMblBYckZ1V1MyMWJRdmtYb0wzMGdXaW5GcE0vLzk3U1g4Vld0cWdG?=
 =?utf-8?B?ams4VHV2ZFRidTJZeFUzYkpUaGNUK0JZVTBqMW5udDIvR3JwQ0pKdVF3SFFa?=
 =?utf-8?B?Tzg5V3dNM3ltdWd2aEh2UTJ5RmNQZXhKdDdYWFBBSWkwTXhIZTREYkVxRW1w?=
 =?utf-8?B?SnRUV2Y1VjBOVlpQUklleWRYTUNhbThjbHJLd3BZVU9YZFk1V3kvcnZRL3ND?=
 =?utf-8?B?eWZrUENoNWxpdVUwT0RTRkRtVlMwZFNlNElXcGwvc3B3MWZnNmVydmxoaVVK?=
 =?utf-8?B?MWZuZWRhMTJCaWdGMkxDNExuczhuZ1d6UGxwU0M4QW1kNnRjLzV5ZTFWOGlR?=
 =?utf-8?B?Z0xaR1B0eENQRkdLL3hlUWRtSTNsa2FwNitCZDgxaXNmWTVqNnFVRFVaUTd0?=
 =?utf-8?B?N0trK25ka2Rid3QzV3plbGJmUmNIQnpVbzhKVi94Yi9MVWhpOElxb1Ezbm12?=
 =?utf-8?B?YjV0TWhjdFR0VWdQd1J5eTRCV3k3Q3BQWmZseHFUV25XT0tReHlHSTFCdmxY?=
 =?utf-8?B?MzdJWWdseVpVVys4UmNEbGFQc2VpcW94aktDczMxSUo4YlpkT0NPMTFoSmZ0?=
 =?utf-8?B?VkZNdythaXlnWStlWXFCNW1HSzdOOHdQU3l0MmNFc1pMVXVGV3pEa201Y0pC?=
 =?utf-8?B?eWdjdnhaanZONVpXT2c4c2xqeXkzR3lsS1JUVDFOZjYyOGg0ZE1ielMvblVy?=
 =?utf-8?B?VEVvS2E4N2pNV21hVHEvNlJiME5qRlAwcTFKek1RaEpscDdNdTRnbTErK0M0?=
 =?utf-8?B?TjBXWWU4a0VXbjdzT0tyMVpKZEhKRjg5UW1FWXVOVkNoZEtyR3QwT3FXOTJ6?=
 =?utf-8?B?OGpCN252cFVGMG5vdjBtUkdWOFN0S0FnN2dsRmVaVytJaFNidmw0K1JFYnBR?=
 =?utf-8?B?bTg1RWhpWFN4dWd6MmhVLzVEV0hMNTNsUHV5L2c4dFBqaGszajNRUVhEbWht?=
 =?utf-8?B?NTBLZlNmMC91YjhXTCtTcjFOVXRTQzl6Q1I2M2Q1QjhzcnU5cm0xc1gwS295?=
 =?utf-8?B?aGJ2b1VUVVFhN1NOSmZObGRZMmlDRHJndUZOOHZSdjhBUEJKZ2o0cXFoOU05?=
 =?utf-8?B?Y1Z3RkVaVkw2TUxMMS92Z3dzN09OellUQ1Q3SnVXcitFbWZhemhxOWNBd0J4?=
 =?utf-8?B?a0FONnhoZTM4dEE2WDR4TTBrQTBTZWNCYnVYbUtldm9CaHhuN29pMmFHUE42?=
 =?utf-8?B?R0pVSG5STlhiMmRRVDVtWWFxQVJBMGF5ZWY2WWdQaG1RcjRORTdiQ1lEWUFV?=
 =?utf-8?B?c2w2eVFvRWhUcGZ5K3V6NlQ4V2UrazJpOXlxcWZVWmlOVUtYRWxITjdkbm4y?=
 =?utf-8?B?Vk9WVWloSTdFRjVaenhXaTNsNWQyaWFScmlWT3F4ZVl0RStlbTlRb1dpdFRB?=
 =?utf-8?B?aURNVGtQYVpGUitpTjV4UFU1WjJJb3hQWkd2YXJUMmRwRnhXRk9UZUFJUzBs?=
 =?utf-8?B?UHcxNDM4MUVVS2dHVjRsYlhRVUw4c2V5S1VadUFEcURXdW11MExDODJRazhq?=
 =?utf-8?B?eGpHZ1ozQkJxaExSOEdCQklrSHV3Um1JTmFpeFZXWmwrZ3BXTzBqRU5oOFBx?=
 =?utf-8?B?ZHI1R3VldzVOb2RiNm5CNzgzbitGNjc0ZmVlN3l2cDFKbkpOdWU3VUZ2VlZ1?=
 =?utf-8?B?MHNDMHZQeHhLYndQYXJaOUhvU2wxeHdCMklhZEZUNVR0aExZYTJ6VTN3TkxG?=
 =?utf-8?B?cGIxUEQzc29iZHRzRHVMcXRGN1I1VEd1d25IejJQR3ZDR2xKam1UZmVWd0hY?=
 =?utf-8?B?S2xmVTFKdjVsdTRWOHM5bHBpdTdaNlovNFF3bmNsY3YxQ0NNdXV0SUpZa3Ir?=
 =?utf-8?B?VGhqZnNyNkI2MU5aa0szOHN4NGxXcVVlNlpGd0lNdXV5QXBIQUlqZDE5d0Zt?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB7637D80AE5184DB6EA3209092A7E20@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d6febf-70bf-460e-8ca5-08dd34fe6fe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 00:49:16.0071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kxYWYzt4KtfVA8zk87TnTGAYPHmOvCg1HG/efNkOMsVaQKIOVU96vSxH8ASYSrflZl3zi/9WJxMZ+Nf46S4RRlKCn/vioS3qHUUwFUBUv1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8701
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTE1IGF0IDAwOjMyICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBJJ3ZlIHB1c2hlZCB0byBrdm0tY29jby1xdWV1ZTsgaWYgeW91IGhhdmUgc29tZSB0aW1lIHRv
IGRvdWJsZSBjaGVjayANCj4gd2hhdCBJIGRpZCB0aGF0J3MgZ3JlYXQsIG90aGVyd2lzZSBpZiBJ
IGRvbid0IGhlYXIgZnJvbSB5b3UgSSdsbCBwb3N0IA0KPiBhcm91bmQgbm9vbiBFdXJvcGVhbiB0
aW1lIHRoZSB2MyBvZiB0aGlzIHNlcmllcy4NCg0KTGV2ZWwgaGFuZGxpbmcgYW5kIGdwYSBlbmNv
ZGluZyBsb29rcyBmaW5lIHRvIG1lLg0KDQpJIGdldCBhIGJ1aWxkIGVycm9yOg0KDQpJbiBmaWxl
IGluY2x1ZGVkIGZyb20gL2hvbWUvcnBlZGdlY28vcmVwb3MvbGludXgvaW5jbHVkZS9hc20tDQpn
ZW5lcmljL21lbW9yeV9tb2RlbC5oOjUsDQogICAgICAgICAgICAgICAgIGZyb20gYXJjaC94ODYv
aW5jbHVkZS9hc20vcGFnZS5oOjg5LA0KICAgICAgICAgICAgICAgICBmcm9tIGxpbnV4L2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oOjIwLA0KICAgICAgICAgICAgICAgICBmcm9tIGxp
bnV4L2FyY2gveDg2L2luY2x1ZGUvYXNtL3RpbWV4Lmg6NSwNCiAgICAgICAgICAgICAgICAgZnJv
bSBsaW51eC9pbmNsdWRlL2xpbnV4L3RpbWV4Lmg6NjcsDQogICAgICAgICAgICAgICAgIGZyb20g
bGludXgvaW5jbHVkZS9saW51eC9jbG9ja3NvdXJjZS5oOjEzLA0KICAgICAgICAgICAgICAgICBm
cm9tIGxpbnV4L2luY2x1ZGUvbGludXgvY2xvY2tjaGlwcy5oOjE0LA0KICAgICAgICAgICAgICAg
ICBmcm9tIGxpbnV4L2FyY2gveDg2L2tlcm5lbC9pODI1My5jOjY6DQpsaW51eC9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS90ZHguaDogSW4gZnVuY3Rpb24g4oCYbWtfa2V5ZWRfcGFkZHLigJk6DQpsaW51
eC9pbmNsdWRlL2FzbS1nZW5lcmljL21lbW9yeV9tb2RlbC5oOjM4OjU4OiBlcnJvcjog4oCYdm1l
bW1hcOKAmSB1bmRlY2xhcmVkDQooZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pOyBkaWQgeW91
IG1lYW4g4oCYbWVtX21hcOKAmT8NCiAgIDM4IHwgI2RlZmluZSBfX3BhZ2VfdG9fcGZuKHBhZ2Up
ICAgICAodW5zaWduZWQgbG9uZykoKHBhZ2UpIC0gdm1lbW1hcCkNCiAgICAgIHwgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fg0K
DQouLi5hbmQgbmVlZGVkIHRoaXM6DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQppbmRleCAyMDFmMmU5MTA0MTEu
LmE4YTZmYmQ3YmY3MSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQor
KysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KQEAgLTM1LDYgKzM1LDcgQEANCiANCiAj
aW5jbHVkZSA8dWFwaS9hc20vbWNlLmg+DQogI2luY2x1ZGUgPGFzbS90ZHhfZ2xvYmFsX21ldGFk
YXRhLmg+DQorI2luY2x1ZGUgPGxpbnV4L3BndGFibGUuaD4NCiANCiAvKg0KICAqIFVzZWQgYnkg
dGhlICNWRSBleGNlcHRpb24gaGFuZGxlciB0byBnYXRoZXIgdGhlICNWRSBleGNlcHRpb24NCg0K
DQpOaXQsIHdoaXRlc3BhY2UgZXJyb3JzOg0KDQorc3RhdGljIGlubGluZSB1NjQgbWtfa2V5ZWRf
cGFkZHIodTE2IGhraWQsIHN0cnVjdCBwYWdlICpwYWdlKQ0KK3sNCisgICAgICAgdTY0IHJldDsN
CisNCisgICAgICAgcmV0ID0gcGFnZV90b19waHlzKHBhZ2UpOw0KKyAgICAgICAvKiBLZXlJRCBi
aXRzIGFyZSBqdXN0IGFib3ZlIHRoZSBwaHlzaWNhbCBhZGRyZXNzIGJpdHM6ICovDQorICAgICAg
IHJldCB8PSBoa2lkIDw8IGJvb3RfY3B1X2RhdGEueDg2X3BoeXNfYml0czsNCisgICAgICAgDQog
IF4gZXh0cmEgdGFiIGhlcmUNCisgICAgICAgcmV0dXJuIHJldDsNCit9DQorDQoNCitzdGF0aWMg
aW5saW5lIGludCBwZ19sZXZlbF90b190ZHhfc2VwdF9sZXZlbChlbnVtIHBnX2xldmVsIGxldmVs
KQ0KK3sNCisgICAgICAgIFdBUk5fT05fT05DRShsZXZlbCA9PSBQR19MRVZFTF9OT05FKTsNCisg
ICAgICAgIHJldHVybiBsZXZlbCAtIDE7DQorIF4gc3BhY2VzIGluc3RlYWQgb2YgdGFicw0KKw0K
K30NCg0KTGFzdGx5LCBURCdzIGFyZSBub3QgYm9vdGluZyBmb3IgbWUsIHdpdGggYSBRRU1VIGVy
cm9yLiBTdGlsbCBkZWJ1Z2dpbmcgdGhpcy4NCg==

