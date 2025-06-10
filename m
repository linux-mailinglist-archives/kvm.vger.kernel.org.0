Return-Path: <kvm+bounces-48811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 832FEAD3F7C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 004BA3A7B3E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 16:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093B9242D76;
	Tue, 10 Jun 2025 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pc7OkhSj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AE024169E;
	Tue, 10 Jun 2025 16:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749574275; cv=fail; b=X9tn6niUkoOSGD0I1cBqatuUTb2F2fhPVUC30XeYFLDgb//lnS38EKpAJGJOtrcX74S1wF3Vtb5f8jY/SN2kk9N7QdfDL1TXoQbQ3yTrEtQGsqMcNeIYPBFQsjUzZJiv8DyNeATVoJgoXxnGApFzLBo0ie3Sx1HiMvt4lGq1biw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749574275; c=relaxed/simple;
	bh=wsxIlscV+bd6GUYtypThUmM6adcJfhAmuVeE/Z6YFF0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TKf3X2Zsy1qMlmou2d/PSe2rmmiZBRR+CP6pSu3HYcYrYPZK6UkNWrTYNKv4BOuMia2otMLqAnXeW8zqQgYrW8b5BSVhpdntD410t8uUSDcnSpw3wbGry50y6hD9nc1vcbOuJN4V4/W1NlnsEuS1WMSw5nRBGedijldgN/mbAK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pc7OkhSj; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749574273; x=1781110273;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wsxIlscV+bd6GUYtypThUmM6adcJfhAmuVeE/Z6YFF0=;
  b=Pc7OkhSjqrSG+/74+BatkkcpYfK45jSQA2CP29rIvMf+c/XOiAXZMJPE
   wy9nR0DqsdDe6PR0qb4OIk5w0oD5y+Jn8/dP8w38aGea+iHGkEZiHwbQg
   diKK9AmQFsLqXgRVW+0EGvzM92CqNaF0PfMLpjXrJAdNClNiGrzg/rPKf
   dSFqYTfLY6x2rNQKLGIZl3wJXSGxo0zUtYwRQk1YE2RFEAl6Ngwzrb9XN
   4nIBCdslKLu0Z9Uh7BRVspzs4USShKR+OenuVqTR9lQ6pTtoiuiqKriB2
   EaL2FZVVDIJo2FlZ+kTj9d9LY4JKr4L0rQBqlcGYmA5klmgUyYY/nljGI
   w==;
X-CSE-ConnectionGUID: IQY9/WP1R9+SoD/vk5MfxA==
X-CSE-MsgGUID: Qmi4fDsBRPW67/4DFXG9sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="55490132"
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="55490132"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 09:51:04 -0700
X-CSE-ConnectionGUID: i53LEa3LRDGsGA9UgWGHLg==
X-CSE-MsgGUID: b61sBkexTwC+lJHpFvzSCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="146872214"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 09:51:05 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 09:51:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 09:51:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.79)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 09:51:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Df+KEyLQ8aaMWILNS7DIRXEDB17v0f/MZ2yQ4Mtk3Nk7LPX3m0ksP8KUNmsilSaEn7VxajSbBZSiUM34WdAn96q77ydFqew/mj6OClkbkJeUba3VhQLtDlI+4lcsu6ce8vtb0zNke+P6fcm2JywKePkci7t6e2ZJeZvl2mebAX3S1Pptg5ro69KYeZlRs7UoPiBhHn1WC7FuinOPVlT01kSn4b4Uf1mfCGDrLnwla/uNY9QALWfn3is0XmTT4yyIz5/DCdWhQH5R9MOfNOWcIdQphbhTkFtxe4jpRhSdtzWkvzSEW3o9dlX/weSiPlmqLi8wii9g4MDDysuPSqeLAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsxIlscV+bd6GUYtypThUmM6adcJfhAmuVeE/Z6YFF0=;
 b=l/fZwLZeL0m7PZJYSY+0eoZ8xCGotTNypGnfZhZdlKuH+TF4wwvSmhy3afRIWCEIw/qUeRuX25dx5UuSdHmFnjF7hJ7qz6XfNrNPIhmpBNQTycSCEAk4CQwpGwxUxPfIFrhF0A8HXBV5PUDymD1T8MKO368EQ/sJ1mb4y26+W7gyvFxdgKm52qCjNBpV/RJgUjJazalFbtwOf5Q3yUYhIutR/g4x5gmXWI4i5m/IV8SLM1yzmpeETbapOkACTE7BRPLMesXJm7tXXr4vlw6z+GQHbBWi8ssBuf8tHv4vJrKjMn5z48JA0mpnVu9ECWQl2WjYrqA1wFiRzHYVGIzVtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN0PR11MB6085.namprd11.prod.outlook.com (2603:10b6:208:3cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Tue, 10 Jun
 2025 16:50:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 16:50:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAB+0YA=
Date: Tue, 10 Jun 2025 16:50:47 +0000
Message-ID: <9421ffccdc40fb5a75921e758626354996abb8a9.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
In-Reply-To: <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN0PR11MB6085:EE_
x-ms-office365-filtering-correlation-id: 838eaf51-ef31-426a-1248-08dda83ef34c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cDlucWFWNi9wWERmNWFMMkpvSUJVazFjSEorWFZTRVFhT3lwMkxiQzFSWDNm?=
 =?utf-8?B?MlRyckF2N20zR3VFeitBUGxRcXlWYURnb2ljKzlndEZDZ3JlYy9rRy8ydnpz?=
 =?utf-8?B?SGE4Rlg4WXN0V3F1ajZkNU9xY3Q2S3h0TmUvUzFRS0c0cmhOeU9zQlF2WE5z?=
 =?utf-8?B?TDJwNlJMa3lPeG5PTlIzV2NkOWdUa3RFbG40YWdOY1FSczZnbmxPNFpvTHM3?=
 =?utf-8?B?eklQM0RKc3BockZNUmRjTzJHajdUUWppaWthVGtDNUU5WHR6TUs3blNoM3dT?=
 =?utf-8?B?cy9DZ1JJUCtWTDl5NHFkM1g0OFVNMS9zV1hZZUc2cFFDS1YyNmJDZnNaK3J6?=
 =?utf-8?B?d0VNZ1Y3SnA5QXloekYxcjhkb2VCNzA5NWY0Smd2UXVrVy9keUhtcGZzcFc4?=
 =?utf-8?B?TGRTUURXelo1MER2a0g3N3g5Z3lqWUJ5YnF3dVJXVFFQenptemZNbW9IY1Jk?=
 =?utf-8?B?aVg2Y0VQbFNGMk50NWkwVHN5N0JDOThDVFIrRytkSitGNmJSTmpicXpVZ2k3?=
 =?utf-8?B?VUVEQ2dOdjN1ZmJCT2xhOWRpMlJYenVEN21SZmtnb2c0OTY5UUVWblByMXdk?=
 =?utf-8?B?YkZkWXpTVzVZbmdCU0FlcHFzeWlza0NvMkQ2TG1YNW9XbDJTTUlhUlZoOExu?=
 =?utf-8?B?QWZTZFdNRWdtZjhIWWJWbklTR3IvUnhkdmhKQUNDdDdtQWNQMHRrdkhMUWll?=
 =?utf-8?B?ODR4elhqMW9mS1c2UndZcldvWXN3ZEZWSHpCT2ZybzZjS1RuQlN0MmR6dFdw?=
 =?utf-8?B?YmZKWFY5MENiZUNRbFd2Z1dweWFiUnVUdGJqbFFkRUtPa3hmNk85S1FVYWtx?=
 =?utf-8?B?d211QmRPb05MQ2I0WnNmUmZ6MU9HY2RqM1ZnWUo5YTRvNEZkZk01bVpJVGVR?=
 =?utf-8?B?bEFjRkN4SllnbzVhZmVMaXRuMTlsYjFsMmlYOFZNNnl5ek5vR1VxL09DSVpR?=
 =?utf-8?B?REtTcWJubDFYZ2g2KzdoeUI2SVpSRHdHeTNiRDAyNGx0YUVWQ1hCNmNVS1gx?=
 =?utf-8?B?eTJpbFprWVNzNDQ1TFcyczRzYzcxdld4VFJpRmx6Z2E3cFAyVi91VVVBQ1Rt?=
 =?utf-8?B?UkpwV1RRZjNwazBHU3ZmYXhvb1NTMThRUG5ab2ZSb2ZBcEpSQWhIL3drRVFT?=
 =?utf-8?B?Uk5ycE5QV293T1R6SVFQczNSK3VDb0UwRTVrRng1bkJnSzNqeFQ4Q3NrYXZa?=
 =?utf-8?B?Y3RqcUJzNFhEcVhwa2l0UXU1eFN5WHhNdDBxNXEzcFBvbEZPL1phU2R6c2Fo?=
 =?utf-8?B?clNXalpNYXlLcFIxU080YWJzUDZaMU04THByMUM0NUIrWjJrYk9PMXJtU3Rq?=
 =?utf-8?B?Q1FpWnlYZHZWZkt4dFRhdE04cmtINTFKd2o0ajAybVhJaERYQXhzRkNtM0Fv?=
 =?utf-8?B?WENPb2puV2hkQ1JySzRSOEUzRkVMOGJ6alZsS2M3dlBLYVFrWTRSWWlIOExG?=
 =?utf-8?B?NXcrQk82d1l3UUoyOWpGYjBUWGtVaHVZWTZEZDVjbHIzMzNQNmIzbGZpRzJj?=
 =?utf-8?B?T1JMZmpJdHYxUVpkTUprOGE2YXFNVmN6alFBU2lpalpvVG40S053L2pjOXZO?=
 =?utf-8?B?dGRTTXAyTHF2ZGJITlFsMmhrQ1BhWVZPY1ZkVm1iK1BFSXhjTlBIajJtRkFT?=
 =?utf-8?B?ZDNad0JnbDVqeHNRN2FzTWZqbTJZWFVpNlMrN3J0akxIa2JmQmJxZ1VvaFlK?=
 =?utf-8?B?dXNsem4xWXhUSVVsY3M5Y0tPL0owQkxUQ2c3TlJzVktPVXlIYktVMnNDOURp?=
 =?utf-8?B?UkFYWUtQNGJodlkzNlpLbGVWOHlBUGh0Z3ozL2p6QWI1TDR3QWRXTmtTZXRY?=
 =?utf-8?B?ZjlKeE9OZEwrSjVCcDB5UGJCMTZCUDhva0NPcmtVcm9XcEI5cFZLaWR2RjB6?=
 =?utf-8?B?cjRESlMzbVI5SGFkdkJnSi93Y2pieGU0eXNuaXg4ZmdNRE9USi9rY29vVWt5?=
 =?utf-8?B?TFIrSTNrTElLMFVWd2VuaTN3OFJrMXpucHBmbDdoZ0FtZnorSXMvQmFtZHJR?=
 =?utf-8?Q?N5qqCIBrt1YLRXwN4yk2UlDBgInvKg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NG1IWkJ1dXlpZjJDWFdoT3NyWEtDbWpCUVRybTV6SGQxbi94N0RSRXE4OHpI?=
 =?utf-8?B?enlLSVFtbEFXTjVDei9QMGZ6VkVEcHJYRTB2ZVBlNEtGajhHck1SVGRzK0U5?=
 =?utf-8?B?bHF0QnVRVzd6NEVjNVRkQ1h6MlJQYUE1eHo5U3VYUm9kNzZCaVN4NS81elRM?=
 =?utf-8?B?SStET0Zra2VLTytnajJ1bkZYOGhNWFROTVk2Uk9qWmdxenZOVFE2ckIyd21l?=
 =?utf-8?B?VjV6OTBoUHdwVXJjam1CYTF1WDlzSHY2bVkyczhFY3BWb1VObTJzVGh3NFlE?=
 =?utf-8?B?M0hSWU9VMldQbGRoTGhvR1FlMUlna3RTM25tT0luUnZGMmk4dHNlRWhDU3Jm?=
 =?utf-8?B?VFU0Z3lwelVidTVNUlFCT1ExWmtjc2t3TktJbm5aaWJUdWJPcnFBUlRPS0ho?=
 =?utf-8?B?ZW13cHBMelkxL01yWW8rc0JoUEdGb2gvekdmSnhIWW9DMUYvTVJtK2RCSjJN?=
 =?utf-8?B?OVlWSUtITUl2YmFTRWR3ZCtLSHhUVnhKSjlsaUU1NHNCREdocENwdTVVYnBG?=
 =?utf-8?B?Q1hqRE9UbGgrY2xwb1RzRlN0cnZ2dXpJSUxLdmpPZUQ0ODVZY1hwTnl2Y1VO?=
 =?utf-8?B?SUJIS3ZyTTBNVnhlc21TTVhlZ01EZzdJUWd3SDV3aVNmN01FVjlPL2NJYXdv?=
 =?utf-8?B?T3BvQk1kUkRlWnJWU0lYMFM5bWdUYWlNZ2g4b1lKV3NoWWx6S09GK05aT0xS?=
 =?utf-8?B?RTMrVFpYb1JEeE5CclRRSEcyRWRpdytvM2ZMUmY3OXZlcWdDSk4vZE9mdFh0?=
 =?utf-8?B?VHlUSTBzS2hlL2lhOHVKZ1U5emk2R3B2TlNTcys0UGVvTGZxMmRFRlBwVXZ2?=
 =?utf-8?B?UDRNVEs0c3BEdVNFR3I4cktIRW5KTzZsL3AzV0sycSsxMTJRQnQ3d2ZrM2xH?=
 =?utf-8?B?LzBTSzRhRU1KczhhaDJYVkE2RHRzRFlxSEdUeDI1QkpOaGFSdzFBU0g1YlNz?=
 =?utf-8?B?Y2gyUWhKZUdTNGNScDQwTWFyZ3B2UTdHc3Azb3l5b2FKcGk4NHlsSEVGeDlp?=
 =?utf-8?B?alpWSFFuRk9qdmlkUWphREkzY2krYnpzVzlkMlRpUW9HakU2UEVGT3d4ZGNV?=
 =?utf-8?B?Zm1KVGlqY0hTdzhYYmFrNDgzaVlJOFgvdU9yNmlaVlJvQWVLRnIwY1pYWVVY?=
 =?utf-8?B?akx0Qm5OeTZMWUpFR2xNY3BLeStyWGxhOTRLNEdGU21GODZCa203d1ppeUZC?=
 =?utf-8?B?OUdpM0tncGdCczQzUXEvVjJEQUgzNXNPSUxEMGRud1VqdVJVdml1M25uVXBJ?=
 =?utf-8?B?WTFDdmNVdGE2N0NMMGJqM0ZaVGo0ZkVNbTV1WDBDTTdldDR4anJLNmtBUFhi?=
 =?utf-8?B?aWplZnJjTGhjRDBIRENSU3NORVB0eFlNTWlCbW1ocUpwbCsvam10U1lCTDFn?=
 =?utf-8?B?eTJLT0VzblY0OTNMSmFYSTF2T3R6WFFqUHZxVFhEUnUzV1J6OUtEKzFaRTh1?=
 =?utf-8?B?Zk1FMzNaR1BOYXd6Ky9Fb25peGErUXlTMHllUG82c0FNQTJmNVVVM2RtSkRj?=
 =?utf-8?B?WEpjcHc5eUkrNDk1cjA4UWx2eWMvVG5KUTJEMkVyTU5QdmEyY1hYWXZYYktM?=
 =?utf-8?B?VVNCc2pEczNVeWtWRVYrWXVCSW9HRXdKU28rVFVJYXJobjlmRHovOWxtVEt6?=
 =?utf-8?B?MEJVTWVCRVo4WFk4Wm5vQUZlZWttSGprL1FqVGp3S0NmQzEzKzBFSFNJYWJM?=
 =?utf-8?B?MDZ2K1RLR2Y5bU15ZGJVZlFLOUkxNHY4dFhkRlFPQkVUQndRaG1mNW05WEs3?=
 =?utf-8?B?S2dSNFBheHcwQldEV0FOUUN5NUF2dDdkZERvQzRBVWEvM01oc09MempYTys5?=
 =?utf-8?B?bkhrOEdzS0NnYko4V2t2M1ZZaDJhZDc3U1VRSjVqbWhqeHRFWDM4bytuVXZ6?=
 =?utf-8?B?WFNtUm5WOThvWXoyUE1YeFdnMzIvemJWQ1hBRWpabjRLVmgyQnFiMTU1a2t0?=
 =?utf-8?B?SHZQSWpYSU1Da0l1ZSt2MDF6eE91S0VnWUtzeCtaTmtERWt1VS8zLzNTSTNT?=
 =?utf-8?B?OHNxcUFtSEtiWUFVdVI1cFlkK2xmV0lnRW05NGZEZ0sxWFFidDBEMjVqam11?=
 =?utf-8?B?VFR0elkvZG5ndDhSRndBbGl5dk1WM2w2YjVpWVpCYlVOYXcrSmZyRmVjQTEw?=
 =?utf-8?B?T05sWGVUWHV2QzU0OThqSGxYbi9PM0NSeWdwZVozdEtLRWlPOTR6TmJCOHU5?=
 =?utf-8?B?a0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <649B6FF775AE514980F3367716C0AEDD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838eaf51-ef31-426a-1248-08dda83ef34c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 16:50:47.9239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZwiLy914GJMzHIKaUuMomwRmyYMcjgT4Z5apHOx+r8/JJ8OTjRI46lJJgwsUIbXjGa4SRbZptIV3Mp16uibq1s61OWCQBqMHym/r0oO64g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6085
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTEwIGF0IDE3OjE2ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IMKgwqDCoCBBIG5ldyBLVk0gZXhpdCByZWFzb24gS1ZNX0VYSVRfVERYX0dFVF9URFZNQ0FMTF9J
TkZPIGFuZCBpdHMgc3RydWN0dXJlDQo+ID4gwqDCoMKgIGFyZSBhZGRlZC4gVXNlcnNwYWNlIGlz
IHJlcXVpcmVkIHRvIGhhbmRsZSB0aGUgZXhpdCByZWFzb24gYXMgdGhlDQo+ID4gaW5pdGlhbA0K
PiA+IMKgwqDCoCBzdXBwb3J0IGZvciBURFguDQo+IA0KPiBJdCBkb2Vzbid0IGxvb2sgbGlrZSBh
IGdvb2QgYW5kIGNvcnJlY3QgZGVzaWduLg0KPiANCj4gQ29uc2lkZXIgdGhlIGNhc2UgdGhhdCB1
c2Vyc3BhY2Ugc3VwcG9ydHMgU2V0dXBFdmVudE5vdGlmeUludGVycnVwdCBhbmQgDQo+IHJldHVy
bnMgYml0IDEgb2YgbGVhZl9vdXRwdXRbMF0gYXMgMSB0byBLVk0sIGFuZCBLVk0gcmV0dXJucyBp
dCB0byBURCANCj4gZ3Vlc3QgZm9yIFREVk1DQUxMX0dFVF9URF9WTV9DQUxMX0lORk8uIFNvIFRE
IGd1ZXN0IHRyZWF0cyBpdCBhcyANCj4gU2V0dXBFdmVudE5vdGlmeUludGVycnVwdCBpcyBzdXBw
b3J0LiBCdXQgd2hlbiBURCBndWVzdCBpc3N1ZXMgdGhpcyANCj4gVERWTUNBTEwsIEtWTSBkb2Vz
bid0IHN1cHBvcnQgdGhlIGV4aXQgdG8gdXNlcnNwYWNlIGZvciB0aGlzIHNwZWNpZmljIA0KPiBs
ZWFmIGFuZCB1c2Vyc3BhY2UgZG9lc24ndCBoYXZlIGNoYW5jZSB0byBoYW5kbGUgaXQuDQoNCldo
eSBkbyB3ZSBuZWVkIGFuIG9wdC1pbiBpbnRlcmZhY2UgaW5zdGVhZCBvZiBhIHdheSB0byBleHBv
c2Ugd2hpY2ggZXhpdCdzIGFyZQ0Kc3VwcG9ydGVkIGJ5IEtWTT8gSSB3b3VsZCB0aGluayB0aGUg
bmVlZCBmb3IgYSBURFZNQ0FMTCBvcHQtaW4gaW50ZXJmYWNlIHdvdWxkDQpvbmx5IGNvbWUgdXAg
aWYgdGhlcmUgd2FzIGEgYmFkIGd1ZXN0IHRoYXQgd2FzIG1ha2luZyBURFZNQ0FMTHMgdGhhdCBp
dCBkaWQgbm90DQpzZWUgaW4gR2V0VGRWbUNhbGxJbmZvLiBTbyB0aGF0IHdlIHdvdWxkIGFjdHVh
bGx5IHJlcXVpcmUgYW4gb3B0LWluIGlzIG5vdA0KZ3VhcmFudGVlZC7CoA0KDQpBbm90aGVyIGNv
bnNpZGVyYXRpb24gY291bGQgYmUgaG93IHRvIGhhbmRsZSBHZXRRdW90ZSBmb3IgYW4gZXZlbnR1
YWwgVERWTUNBTEwNCm9wdC1pbiBpbnRlcmZhY2UsIHNob3VsZCBpdCBiZSBuZWVkZWQuIFRoZSBw
cm9ibGVtIHdvdWxkIGJlIEdldFF1b3RlIHdvdWxkIGJlDQpvcHRlZCBpbiBieSBkZWZhdWx0IGFu
ZCBtYWtlIHRoZSBpbnRlcmZhY2Ugd2VpcmQuIEJ1dCB3ZSBtYXkgbm90IHdhbnQgdG8gaGF2ZSBh
DQpURFZNQ2FsbCBzcGVjaWZpYyBvcHQtaW4gaW50ZXJmYWNlLiBUaGVyZSBjb3VsZCBiZSBvdGhl
ciBURFggYmVoYXZpb3JzIHRoYXQgd2UNCm5lZWQgdG8gb3B0LWluIGFyb3VuZC4gSW4gd2hpY2gg
Y2FzZSB0aGUgb3B0LWluIGludGVyZmFjZSBjb3VsZCBiZSBtb3JlIGdlbmVyaWMsDQphbmQgYnkg
aW1wbGVtZW50aW5nIHRoZSBURFZNQ2FsbCBvcHQtaW4gaW50ZXJmYWNlIGFoZWFkIG9mIHRpbWUg
d2Ugd291bGQgZW5kIHVwDQp3aXRoIHR3byBvcHQtaW4gaW50ZXJmYWNlcyBpbnN0ZWFkIG9mIG9u
ZS4NCg0KU28gaG93IGFib3V0IGp1c3QgYWRkaW5nIGEgZmllbGQgdG8gc3RydWN0IGt2bV90ZHhf
Y2FwYWJpbGl0aWVzIHRvIGRlc2NyaWJlIHRoZQ0KS1ZNIFREVk1jYWxscz8gT3Igc29tZSBvdGhl
ciBwbGFjZT8gQnV0IGRvbid0IGludmVudCBhbiBvcHQtaW4gaW50ZXJmYWNlDQp1bnRpbC9pZiB3
ZSBuZWVkIGl0Lg0K

