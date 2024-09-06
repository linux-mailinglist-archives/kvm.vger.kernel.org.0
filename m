Return-Path: <kvm+bounces-25972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2BD696E791
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 356701F23B10
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 02:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBCF2232A;
	Fri,  6 Sep 2024 02:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgsYLhH3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D43CD2FF;
	Fri,  6 Sep 2024 02:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725588622; cv=fail; b=pjvzLpqcoXiXmm3vIkaNvGACRPrJSddlZvQw+w6PaTHT2AWQmkK4jqcg1GngyFDW258u/N9HZLR5GzOMxSRY7wwb42xkopUM1GhzkiCJ8d31tcsz5Vcw3bEOQk5H1tSaJTYpxVjposlOL3DO1ROpRKypk3x07GFIzwKEGF7NFPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725588622; c=relaxed/simple;
	bh=ouU7rI77WJ1dHL/sx66CODUkec7kwl0zJoDO7YZbCl8=;
	h=Message-ID:Date:Subject:References:From:To:CC:In-Reply-To:
	 Content-Type:MIME-Version; b=S1vcjSWQGZ3YErTsmNEDp+K4E41eypfSii1kazMZ+IyZD97QTU5oAeZM5jPoZ/RCeQX86eA8hjnFZ3bPBbHQJoNhTOyV4ghTL3MI6ZDfF8t5OjxwedizUT2d77qxGfMbQdKgqyU4+OAhSwTE4tDnWUzCfLiob+W9udAz8aZ+zvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KgsYLhH3; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725588621; x=1757124621;
  h=message-id:date:subject:references:from:to:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ouU7rI77WJ1dHL/sx66CODUkec7kwl0zJoDO7YZbCl8=;
  b=KgsYLhH36pcy4VorDGDhaearPvx/vaGCCR9KOeHi5JY892FEGM/XQIjb
   Xj7CvLEewj24kf23ZUctiQtwQYpqDF6UQu+yprH3fJr7U9s9nmMDLih1y
   tw8ReG0bS3JHNPAEFF/IBZwOwXU1Sm43ryHbYo1z7NrKyIJaf69NiLMf7
   5H9P8X4wum6sv6EK/JvsYvTJeOVfneaEhvQgg7scyOkaNOWqkJg6BSRjd
   XCnwGOmxxbWx2rJ8nFHfVOaBtb6Z6D+JFdAc11+1xdA8RHQ+zUjfoJ3Tc
   kX6jg1znqoThzYpShS7Sop3gqU4axNYWhoLTEb9bjx984Bzi2/NtkkeQM
   Q==;
X-CSE-ConnectionGUID: oWnMbc8BSXmV/SvZBGnxOw==
X-CSE-MsgGUID: K6UVgnaTT2m1C8I/KlsDCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="13400054"
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="13400054"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 19:10:20 -0700
X-CSE-ConnectionGUID: lnL0Q3tUQXWej64bBiQZXQ==
X-CSE-MsgGUID: 0u4w0FwORvCrP/wuFEJuNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="65858265"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 19:10:20 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 19:10:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 19:10:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 19:10:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=muaMcvSr6X3shhscwX9wV9JecUIJpRUaomPid7rCfEvRAZu+O67HKxhBbRJUl7t0eazB9uUyBYQEH+/NjKj2jrDfFTZhCF2ID02X0M7eH0IOgIraZZwRWUuK44JcvWYi4ybPEdTM+rxeQWT6xKqc7H6Pnz3fGwcuEX8H4O+iA6Aq7bUNPRAiEuBT3O6itMwkBj7jvONZsTDqVGXLJe4Cz0zN1E1/msJy90XaInzx7oDyca1okKsYuRP9MmdIWRrlW81rQHOHp16S6GW8mH+i0e5xKiPyKEADmwFDoz0UUoTr/vq0jpvPNDYRhsE9phIlI2Ljjlv4+XNBPxSE81NKBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHaUzfljjeSGyQFrNeyro2zR/5r5S2p6Px/urod356A=;
 b=eVT5ygqjaspaRGk1y5Lq7G9NBwV1GQdR4NcbNuNcOnokfARzdRrRjgb16wx/zgzdJ0L4vxQMG2icoOQZ0tyod7yNF0rgpqc4/yPtUkKJVoBrNo/M21Bv/d35hwvixsH+M1QCOFksbQHKM3p4JBWmxzfMuDCJqQ8JAjkJzGHRQ4XG7tb9jNhDQbdXsqti84IorPS6jwbmvIFmJaSJ/TeavhZtvmsnukRbIpVY9DSQe0vHJ3+m1fMPrEBZOcyKabAHNZs/Imv8MzzU3uzL7ELb2EyYohLGij4MXKP4GPimmTn4P3VRgaNMQjP3DGsCi6JWRp1F/RmhmURUBiFmZnG5Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5064.namprd11.prod.outlook.com (2603:10b6:510:3b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 02:10:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 02:10:10 +0000
Message-ID: <5303616b-5001-43f4-a4d7-2dc7579f2d0d@intel.com>
Date: Fri, 6 Sep 2024 14:10:03 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-15-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <dmatlack@google.com>, <isaku.yamahata@gmail.com>, <yan.y.zhao@intel.com>,
	<nik.borisov@suse.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20240904030751.117579-15-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0769.namprd03.prod.outlook.com
 (2603:10b6:408:13a::24) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB5064:EE_
X-MS-Office365-Filtering-Correlation-Id: 349b9620-bdbe-4585-cea7-08dcce190901
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UXZEUHl2WU5oblc3VVo0SkI3Zi9QajJUSnl2NEcralV2b3hYZ0NLenVXbDZ4?=
 =?utf-8?B?YWNyc1dMdDlINTBhSGN5clRmMHhRVzlpVk9IRUhGb0J6ZVV4UWxJa2lTRGVp?=
 =?utf-8?B?dzZlNkVJSkFnME5KN25BOWVnbUhQWkR0NFl3aGhpdlU4WFdFS2ZVM2xqVTJt?=
 =?utf-8?B?YzgvT1JTWDZpeXpEcU9jMGNwZkltSWl5MmtlL2p4MU5reVV2VlUvTWRRN2py?=
 =?utf-8?B?R1NtcFdESW1Md21DKy9oWUNsd1RRTTl3NjFYditOMmgxL0sxS29rT2RQdHhB?=
 =?utf-8?B?cmhyaCtvdXprVzNwWkI5djRJd2dlSnZOMTRmWFg2T1Y0WFNKbW5yK21RWVNx?=
 =?utf-8?B?U3lrdGJQUjBId0dzb28wRStBRmtQdXZwaUgrMElwaTZ3eW1vVitJV0dVNlRt?=
 =?utf-8?B?Mzg1WXRMc2RxVGlyc2hXa1pyb1R1TlJXMFhXcG9UenFZdnM0dHZ6OEFwY1BF?=
 =?utf-8?B?R1AyeTdkWFAyLzJpdzFQa2M0TVVqU0liNG5JNTdRZms2YkUzMjlWSncwdnYv?=
 =?utf-8?B?cGdud1pDVDB4SmwvNUNPY3gwZTJGRElHa3NZckZiWVg4Y2djN0xONDdUbW11?=
 =?utf-8?B?NE0vTmdVQ2J5Z3ZDV3lBZkV2WFltVlFOeUhkRXFBOFpGNWpBWTY4dHorYm4r?=
 =?utf-8?B?UjFYeGNoSWVqOFJEWktVdjBkbEMyMmpVSFpISitHQ3g2RGpkZG1NMDJ1OVZQ?=
 =?utf-8?B?dEhXQWNKcmJ6dGFYR215d0hBeVpid2JERUIrMS8ydG9oQkFNbmtVS3VteWll?=
 =?utf-8?B?VkdPZWxnNmozMVdGK29vaUR2d2Niekp3a1dRME9WWXo4VEgxeVJ5NTVXZWVX?=
 =?utf-8?B?NEhNQUIwUjZOaGdKQ3Iyem1yTUFxZ2RhdHpiYithK0V3UzFVL1J2dTJIVWtt?=
 =?utf-8?B?WlpIZjZXQytlUy8wUW9ERitUb3hORysxVGdLTUpveHhOdnEvL2ZEazZ3T09E?=
 =?utf-8?B?TGxWOThveWd3bjVkWXlnUXFUM3VRVmRrdGJCWVhCZjdlWk02VWd0WE82VDBV?=
 =?utf-8?B?Y1RFV3FwUVlYRVFUOTdueUxEbjZaM1hVbjM4dy9rTUdPblJkeEdET2xQL2Fq?=
 =?utf-8?B?cGJPV0xyRmZ2T24wdnI0MTRSZTEzTHAxWXNaZzhKaVhFYWxFbTlYdFN1TzFx?=
 =?utf-8?B?UmVWdEpFRGkzdlByVHVFbDlCZFNkbkpnQkh3QVRvMk9xRFgvQUtzUTZjY1ox?=
 =?utf-8?B?K0Frcmd3b01vSWdGSXNqOUtFVEJ5dWxZblU1UVRlOXJNeWgrZWljZ0Z6ZXRR?=
 =?utf-8?B?SGRRcTRPaHdSNWI1cDZhTTZWM2dvZ3Q2bU1SbzhwRXRoRnRzL2h4SnhDRERF?=
 =?utf-8?B?K3N5RVpkdjRhVHVldmwxUTVXM2J4anNaV2MxNjlFMHl3ZTNYdkNXZWJ6cXZT?=
 =?utf-8?B?alhMOVdZL2JDOGk1MGpBRTh0OFA4RlliL3hURHlYR1dtZWdVampLeGlUMndr?=
 =?utf-8?B?QnRZMDdQR1UzZzRva24zMHhoZWYwcWxQSTlKTWdzN2VFSXJvU29wS1I1bm80?=
 =?utf-8?B?L2lZbG1DVzVWdStqUmlXekkxMzZUT2Iyd3pHNEZJNU9ETEtXKzZ4RDJoRVpz?=
 =?utf-8?B?aWI4Um9CaDY4WVlhSE50ZVVHV09TNHBINVZoZXZBU2VFbWJDeVFYdnlUV0t5?=
 =?utf-8?B?Vm9RS1UzZm5Gc1UyMEcyOHZMT2Z5bkprVmtTZTZLNmpIOEppT1lYRElXZkdq?=
 =?utf-8?B?aEFpcy9UTElibmp3TWljdEhWaUtQQUEwd1I0ZXJmUk5yNERpUHB5Ri9rbUlO?=
 =?utf-8?B?NDh6Zy96enZkdkVSMVFUR3M3czEyYzNpbnZMRlJjcHlSZDV2NFpwaHp3TDJP?=
 =?utf-8?B?TUhSRkN0NDhUUk1PaS9yZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXRUK3haNFB3dERKMHFHeXBwNjNnL3Zwd0xhMEJoYnJ3WkFUSFkvT05vV2Fk?=
 =?utf-8?B?dDdYQXAwZmt2L3RveC9nM1luaUVCTE5zVzdtOVVKQWhMK3VScWdVZDE4VjFi?=
 =?utf-8?B?R2xlUmYrWSttTkJia0xVWWc5bzRhRlpWSndxa0ZSOGNmQ1lKNFY4Z25kNGtN?=
 =?utf-8?B?dG1hWVkwS0ZJc2tYOTNsWHl3OEk2TXZzYW42ek1MN2ErdWVZMy9xRFlhYzFP?=
 =?utf-8?B?MGNNdHdSNDVHT3RTSXdpOEN0OWJPREpwSUtVNVR0dGxhSlVBNkZxMnlpOUww?=
 =?utf-8?B?ems2ZEVOU0xuMUdPcVE1dnpsblpNc00rbEswc2YwdldZc25DbDdSbENRTnlZ?=
 =?utf-8?B?T3NYT0dXVnR0YkcxYm1QK25HVG5EdjJGbVVKeS9WUFZwQ1p5aTBRbmltSFVL?=
 =?utf-8?B?U29OTXpvMzNLcXZ4YkRMTmk4YlVsM21yWVJmTENFNVVXbjNia2o0QnRYVFFa?=
 =?utf-8?B?MHR0VmZ5bnlGWE54eHI1d25xM2wyeTRUU1czVVdiYUd6ajRTY3plMGtsZVhY?=
 =?utf-8?B?YnU0WUJVY0N2dFE3cDlnS1A2ZlBNSmdvSzlON21QdmxIakI3azl3eUFOMy9C?=
 =?utf-8?B?OW9LNCtEem5sdHA2TXE3M0VZOXBxZStHZURtTUVFVFZtTThHaU4zRGdGdUhv?=
 =?utf-8?B?VUlrSlMvT1NrYkxyZmtsM2F0L2xwb2pJM2FqazgzREVFZDMxWWM0bVJCTzgr?=
 =?utf-8?B?YjJkSFRGQlRNdVNzZFk4MEZNZzRFSllzZW9PcmtvcGdzaFVhS3VrNnNGZ2RR?=
 =?utf-8?B?YjZnRlg4dWkydE9zMkJzTERBanljazducG5rYmJqOUE3cDlmVVRQdXVQa3Ra?=
 =?utf-8?B?M1dlaGUyQkpBRytiQURBTURuaEg2dWpGMjd4VFkxVjNDOWpxZnlFQ0hDNUdD?=
 =?utf-8?B?SkQzak53S1kxWlpMQnF5blJmY1h4ODdqbXdLT3FLSjlaTEtTRzdFVkRaUVZw?=
 =?utf-8?B?bEM0MFZOcU1ZSXR6RnFYQzZ5N1pWU29UN2JuU2pJOThkcGtuTEx4ZjRkcldD?=
 =?utf-8?B?YmduNThDOHU3b04zK2hyN216MXJra3U2VU14a29BRHZ6eGZ2SWFwbllKVFpv?=
 =?utf-8?B?KzhCOTZNcXZPZHUrUnQ0WCtDbExrd0xvOW5sbGhDU2pDdEpNbTJ2d0kxcHJT?=
 =?utf-8?B?Yys1SCtlWVhMdDVtbzgxbktaa01GRDlMbzZhTFdjRk5VTko1T21IanY1TFMz?=
 =?utf-8?B?ZUlRdDFuc3BYMXpxNGNmWExITFp2RWRjUHIwbnk4czFQK25sdWFWU2RFS0JL?=
 =?utf-8?B?cFdudHZ4d0Fmai9jdVE3UThZeHZndUR2R3NtOXVkOW5URFhQRkJ4Um8zcEhG?=
 =?utf-8?B?Y3BGZC9uZCtRUnFPSW9pU3JtdmtuR1JJTW9PR1B5QU12RENGOWZCTmxGbTZ3?=
 =?utf-8?B?UXFyTU9JKzh5RGIwNVFsOEdqdXlGcU0vOVcrVEhEc1V3TGFTeHkwN1VMOXBM?=
 =?utf-8?B?a25YWFlXaFR5ZzhTcVJTZHV3WFhEUGwxUlNXSzhZd2VCREZGYXlRcjJZaEZi?=
 =?utf-8?B?eDNiVFgwYXd6RU80dkEwbS81SzNGc1A1dFZIOG9KbFBhQmtnWklhY3hyWUxI?=
 =?utf-8?B?cjVKcktHZCsxVnYvU3BlMFl3NzJQZ21HeXB1cUF1WmpXOTN2N2ZBZ3d0Tkd5?=
 =?utf-8?B?cFRwenluNmlLOUJnMnJZeUZDM3hKWGFLMmJDdndaRXZvYU5TTGNBU1REZThY?=
 =?utf-8?B?dmlMb0ZlcTluZDdNTjZ1WHRVYThNZDhRUHZDWEF3aWROMUFqYklFSkI4NXlO?=
 =?utf-8?B?U3c3a1dObjFPcjhDN2hLcmRhSDJhQWRtNUhHV25NTnN4dkllc3k2VFhicjZr?=
 =?utf-8?B?bE95eFpoV3Y0a2dGMGg3ZmRpSDVLdXJTNEZ3UjVTS1lheWQzUjlSOXZPSGFG?=
 =?utf-8?B?ZmJJY2hzVERvWDl2c0ZURi84KzBSbTA0cjdqTVdwc3EwQUY2TnFhNnFRbC9r?=
 =?utf-8?B?czlPeFp4c0lReUIvWDBrWEdRd2VraWZYNUNsV0k2YjZCckVDNzJmdFJLenY1?=
 =?utf-8?B?dVJ3TmNSbnZPK0dob1J5VHU3Qm9Xa3RKM3lmY3NxVnVSMWNJR0YvY21MYjhM?=
 =?utf-8?B?RkJ0d0ZZZGNRd090U1BSNGFreWJNbi90QVFiRWFPU0pmVzdISDBGVWZ3VlFP?=
 =?utf-8?Q?W94fA9tPY8SuqHtTiGMIZ1KcI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 349b9620-bdbe-4585-cea7-08dcce190901
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 02:10:10.1270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ENWFNSJqWt14pbhog310fI2VeD1Rf7GGuTAmQ64IGgqhBjXxqqvYOFCrrgmbhYWcjwxcdHEy2A0cNi8WhJc/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5064
X-OriginatorOrg: intel.com


> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -36,9 +36,21 @@ static __init int vt_hardware_setup(void)
>   	 * is KVM may allocate couple of more bytes than needed for
>   	 * each VM.
>   	 */
> -	if (enable_tdx)
> +	if (enable_tdx) {
>   		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
>   				sizeof(struct kvm_tdx));
> +		/*
> +		 * Note, TDX may fail to initialize in a later time in
> +		 * vt_init(), in which case it is not necessary to setup
> +		 * those callbacks.  But making them valid here even
> +		 * when TDX fails to init later is fine because those
> +		 * callbacks won't be called if the VM isn't TDX guest.
> +		 */
> +		vt_x86_ops.link_external_spt = tdx_sept_link_private_spt;
> +		vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
> +		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
> +		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;

Nit:  The callbacks in 'struct kvm_x86_ops' have name "external", but 
TDX callbacks have name "private".  Should we rename TDX callbacks to 
make them aligned?

> +	}
>   
>   	return 0;
>   }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 6feb3ab96926..b8cd5a629a80 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -447,6 +447,177 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>   	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
>   }
>   
> +static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
> +{
> +	struct page *page = pfn_to_page(pfn);
> +
> +	put_page(page);
> +}
> +
> +static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> +			    enum pg_level level, kvm_pfn_t pfn)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	hpa_t hpa = pfn_to_hpa(pfn);
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	u64 entry, level_state;
> +	u64 err;
> +
> +	err = tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
> +	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
> +		tdx_unpin(kvm, pfn);
> +		return -EAGAIN;
> +	}

Nit: Here (and other non-fatal error cases) I think we should return 
-EBUSY to make it consistent with non-TDX case?  E.g., the non-TDX case has:

                 if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
                         return -EBUSY;

And the comment of tdp_mmu_set_spte_atomic() currently says it can only 
return 0 or -EBUSY.  It needs to be patched to reflect it can also 
return other non-0 errors like -EIO but those are fatal.  In terms of 
non-fatal error I don't think we need another -EAGAIN.

/*
  * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically

[...]

  * Return:
  * * 0      - If the SPTE was set.
  * * -EBUSY - If the SPTE cannot be set. In this case this function will
  *	      have no side-effects other than setting iter->old_spte to
  *            the last known value of the spte.
  */

[...]

> +
> +static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> +				      enum pg_level level, kvm_pfn_t pfn)
> +{
>
[...]

> +
> +	hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
> +	do {
> +		/*
> +		 * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
> +		 * this page was removed above, other thread shouldn't be
> +		 * repeatedly operating on this page.  Just retry loop.
> +		 */
> +		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
> +	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));

In what case(s) other threads can concurrently lock the PAMT entry, 
leading to the above BUSY?

[...]

> +
> +int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> +				 enum pg_level level, kvm_pfn_t pfn)
> +{
> +	int ret;
> +
> +	/*
> +	 * HKID is released when vm_free() which is after closing gmem_fd

 From latest dev branch HKID is freed from vt_vm_destroy(), but not 
vm_free() (which should be tdx_vm_free() btw).

static void vt_vm_destroy(struct kvm *kvm)
{
         if (is_td(kvm))
                 return tdx_mmu_release_hkid(kvm);

         vmx_vm_destroy(kvm);
}

Btw, why not have a tdx_vm_destroy() wrapper?  Seems all other vt_xx()s 
have a tdx_xx() but only this one calls tdx_mmu_release_hkid() directly.

> +	 * which causes gmem invalidation to zap all spte.
> +	 * Population is only allowed after KVM_TDX_INIT_VM.
> +	 */

What does the second sentence ("Population ...")  meaning?  Why is it 
relevant here?


