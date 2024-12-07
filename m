Return-Path: <kvm+bounces-33236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F23A9E7D18
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 01:00:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04A9D2857C2
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 00:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4132876034;
	Sat,  7 Dec 2024 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X+7Rktew"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F6013DBBE;
	Sat,  7 Dec 2024 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529613; cv=fail; b=MjgbUH5sLh4KKHqF1T3c8Zli/fSKE/BMKgSmyVtcyCfDISkz5WIeqYu0ccgbM+D3c/zoosaTNgLoJ29c58EZfaI7/wsSVDFzVgybapX73Y9hQT94x6mv7s9EQouFekQ+5tjQmiJ48/yrT3LgUkcFRndi6NWdprPiye0NmrP0lnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529613; c=relaxed/simple;
	bh=X88R8ZOYXIC0Hohak+xuMJXI7dFDFARQd2wZ8pNgcOs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MmlNnbS06W5D1wdsnNKJ7cqbhn7RiOfnMiN9wUUgNP3WhaQQAmBKCylnRE6rN9vprBBLohkAqyCdA8nJtpP6rWYXv5W/r7oqHStEuV8nJK1C4yGRgC87IYhvLPcRy0nHEbb831QqPCRiHiFeIKYRSdmVRxk2gwA6epe5HOCvevA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X+7Rktew; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733529611; x=1765065611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X88R8ZOYXIC0Hohak+xuMJXI7dFDFARQd2wZ8pNgcOs=;
  b=X+7RktewDZYDmP3432C24DYomlwK703RhXCdKTH+9w8LwGt832FFAzXk
   arHJKQonrEenexZsuzrNZkYgIjvefgSrSMr+vMFogo+spa1E97HJrJT1w
   GHk8/luSD2NMzzulqvHq3Q7p1i4barWvZ1paTTvkhsi00KQAC090PkMzE
   YDnnk5EQ0djcvTp9OlA7+9qx0X3U8IKw4mlYqo+UAhxYu2BH+7jxHyVd7
   6y3dJWX3fY0agroqMt3cSEiQwzmp+4cFu2gbEukMvhzI6U5+4pw9LGPrR
   DlVKS5vLJ12xZ5C5sbdWdeQRVxUzopG2zSO6pUB1Zp5l+bIiHwb7BvhNz
   Q==;
X-CSE-ConnectionGUID: o71ATWi3Rdq5eKEXkZbzlg==
X-CSE-MsgGUID: qNgkmbi/QxeREVRDZqAC0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="37576887"
X-IronPort-AV: E=Sophos;i="6.12,214,1728975600"; 
   d="scan'208";a="37576887"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 16:00:10 -0800
X-CSE-ConnectionGUID: Sppm6HNgSGqViyLGQIAaXQ==
X-CSE-MsgGUID: lmOiEkunRiKOf7c+TIxaPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,214,1728975600"; 
   d="scan'208";a="125378836"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2024 16:00:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Dec 2024 16:00:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Dec 2024 16:00:10 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Dec 2024 16:00:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HKOa+6W023r99JTqDeS7kEbMV4/ZJawBABanqGjItGs4bM848kW4A7dATrxS8oncziSB5AMAVIoKPNyTuExgA/APgmvA4aURxvFtHFs4I2HoIKP1fQJi2Y/aKwEQ1XAnqQqWWPVGi1F7D8r3em/rOwhdAZeTUP8Axzj3LnSK/WBb42I1Vut8Ahth0uEV848wOrKfMhYydIxWAoM7rfTTp5hPjZjPuV3qDgah18pMQotwarjGI2cHDst397suN0eoMu5zbJOawRYVwKveY7mkQZB/RS2rbe5bHrF+L/1yyWhcOQ8m4x2VRDwKThR4vBlGkg5IcybJNluJVVdYxGuBFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X88R8ZOYXIC0Hohak+xuMJXI7dFDFARQd2wZ8pNgcOs=;
 b=vc8iztPcKJISUEY+YWeVJSLP0f34Z9l2aSHUg9i3+VQkwgss5dsiDn6GFg44bJCuTt42ydwN7/x1DU3oQqiIlob0nBUkXdXrULUWYEJe0DaYo0whDctYm8L2ZNj4u5FW4XqzS4ZSOUQjzX9+Fm+zoqps7coiX5n7UPIVsIXhmvrSmDfq9g2qj9o+hoZqpaY7zFJf8s/hI9eLJnfi5oODZJL6X6BeZsmXb5b+byqcRK8ycBZP/wpgSqKZx/wB2dbBT4kyelCsN0klDorjLANzmSf9rh0RcpPTlxrjKkAogqdbsHmT6IPFW86bwcyZPauha9My4LyB6GQGVmgVRREs7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6881.namprd11.prod.outlook.com (2603:10b6:510:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Sat, 7 Dec
 2024 00:00:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8207.017; Sat, 7 Dec 2024
 00:00:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: RE: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata for
 KVM
Thread-Topic: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata
 for KVM
Thread-Index: AQHbKv4/vFuDP1VR6k6F9GWSzEVqNbLZHhwAgAB/agCAAAMpAIAAfebg
Date: Sat, 7 Dec 2024 00:00:07 +0000
Message-ID: <BL1PR11MB5978299D3FE0EA6DA0DAD0AEF7322@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-4-rick.p.edgecombe@intel.com>
 <419a166c-a4a8-46ad-a7ed-4b8ec23ca7d4@intel.com>
 <47f2547406893baaaca7de5cd84955424940b32b.camel@intel.com>
 <11479069-6f1d-42b8-81b6-376603aea76f@intel.com>
In-Reply-To: <11479069-6f1d-42b8-81b6-376603aea76f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6881:EE_
x-ms-office365-filtering-correlation-id: c79ee5e0-2149-4f93-ac99-08dd16521c70
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RFZpMTFnODZhMk1iZmhnS1RoSEdrZnBrVmxMTHNxNFpsbWFFS2NxQ0gxaE82?=
 =?utf-8?B?bms4TmpuKzdEZFRrejZUeXNPTVM3UDlLcG1uOEYwUUVVaE1CZkZrR210Q1cy?=
 =?utf-8?B?akV2QVlYd3hhTHkzTEhtTWRJRlNsS25IWC9MNjVkVmdwSnZKdndMKzZ6dHpT?=
 =?utf-8?B?dFlxY3ZZRkdaTGdIcnRlVjZaak84cU5VSisrNTZxMmFPb3hqd3pVLzZKL0di?=
 =?utf-8?B?Ym13VlU5N3NRMUpjNU45WWd0azl3NmhNbCtIT1lLdnZEWnB6bnBXM3Y4SkZp?=
 =?utf-8?B?TzZhdkNqeTRXdmFyWGdnanZQdjU0VUgraGM3TTVYRTJmT1EyWUR4TFJXbXpw?=
 =?utf-8?B?ek43TkNoMXVpcUxpbStpMFRGVytscDY0blVDbHozMDZpeGo2cVpKb1hVTUZX?=
 =?utf-8?B?cE5CNlI5cGM1cGtiTE5IZ0hUYmJydmJFbUp4aWw4MHRMeVZOWjZKNTdHVTRn?=
 =?utf-8?B?L3h3d1NQSWhzKzY5Zy9ERnRFdmZhcGVSckYrRldzVXNGNzRkMmZqYnVIVzMw?=
 =?utf-8?B?bkhPcFVnNUl2bzl0cnpzMEpiOVJwRjZSOTRGdWtBZmFpc2FjRTBUWWEzR0c1?=
 =?utf-8?B?ZUQrVEc5anpKb2k1Z3NhYTJxYmNCWHgxaVE1UVlNNlBvMkZheFNOSnVZZlJu?=
 =?utf-8?B?SWhodnQrK2RuZ0VtOG5JVFdPY245NHh0QkY0dTVhVFhkT2V0SlgrVTFzZktZ?=
 =?utf-8?B?ZnAwc0c5TnBZZ24xY1Q2R2pwNWE0Qk1PSHEzZkl5cHJWR0x2UGJRZlVyQWZ6?=
 =?utf-8?B?TmR4NDdBNm92STVXOXMvREFWT0MxNFpDTjZDcEhTWkZDTE16OWJBS0QreE1X?=
 =?utf-8?B?dHVWVGR3ZTBMRWtaZVZlOXk4VTRuNlFiaUJGV2FHOWNJRXc1ZjM0bTZwZUFG?=
 =?utf-8?B?VnNNaGhIR0l5TXdlT1c4UEV4TzBveXFzMiswSnR1VkM5Rk5QVy9TUTh3Z3hV?=
 =?utf-8?B?Z2VXb3FJVzVWY1loVmlLUzZ6dzZqY3ZtMERMbjZjcmxlcnhiMFI3dmhUNVMv?=
 =?utf-8?B?cS9Oc1NIb3Y2M1k0UWdzNkZnSkZndXJ4TTlvKzlIcG1Qa2N0YlU0RERLVkRP?=
 =?utf-8?B?bFB4bXhNUHdSWGN5c0Q3ZmZJYkdUTjdxRWhoQmdxNUxabThnUHp1N1ZYUUNY?=
 =?utf-8?B?WkxFdFpaYTc2VnBlMVFxb2Y4c3I0MjU1ZjBYa1FPQXF4SVpmS3kyZENvYmQz?=
 =?utf-8?B?WDIzNEV2YjI2dTZyTS9FRS9PS3NnVlk4NTNQdlJvZDZKTUVEWk9sOU1LSmIy?=
 =?utf-8?B?dDdEZEY0RkNuS3c2WnFmaUIwL3I1RHVBSmdLcmZodWxMTjVGR1Zvc1hZK2xF?=
 =?utf-8?B?V2pzYUQwSE5KZmV4Z2hNNEZEaFhWRlNmWVZEWWJNRkJKclg0KzZiZXhHcVht?=
 =?utf-8?B?TnZBT0R2OUJqSUU2d0Q4SjV3ZzZQaDdZN01XY2hoRUxWbkhhSlVUZnJSbzc5?=
 =?utf-8?B?dzdBTldSeExDZENkVjgvdWFuTEsybzJQQmdoVmpMeStRVy9MeTEzYXNhcm9I?=
 =?utf-8?B?bDFPMDFCRXV4czhWRkxDNTJ2d0orZVN3Sm90V0p4S3I5cC94eFQ2Y1BhaVZS?=
 =?utf-8?B?VTVvYzI2eVhyTHFWditlSnd3eCswZHZtdThSQTVQanBuODZZUHVyRTRhQVUv?=
 =?utf-8?B?UlR0Z3BINnVEakpvV2FmN1FQNlBjN2VXcS9mdnlwL001QjNuV2lVN2Rxdm96?=
 =?utf-8?B?djhTM2dhdDNvQXlLTGg0aGppcW9sRU9WUWVuSVhHeThBZUtOaVVIWWRGdUdo?=
 =?utf-8?B?NWtUb3g3aTZuMjd2MGxlL0tTSWRIcjFHZWdpVUhBZXo3WXRLenFzWVArRVB5?=
 =?utf-8?B?Y0R6RzkrTE1SMnh3UHNadHZYaXQ2bCtCZXpWQUpUTHZvY3hOaGNiQ1BuRVV0?=
 =?utf-8?B?aElDdGw5T0c2YWFKdGtIR2hONG5yN3AzbTRaaTZ6dHRiMkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1dBTDJCUDRMMGNHS1ZibG40Y0V3VHIwa1hEOEk1ZkkzWHpORGZ6STFVR3Vr?=
 =?utf-8?B?c0dkQkZjRmlucE44NWUvVmpUSW9qaFVkQUU3bEkyTG9hVTJGblRWQkl0TSs3?=
 =?utf-8?B?ajBPMEQzd0FTUFdUZU1lZDA5b21aK0tuWFVlOUptRTVlUlpNMlZvMmUzMjdB?=
 =?utf-8?B?eTJPWFB6dUVxeTdOSXdPMWo2RE9Dc1NmbGs0a3NjMkpsOUMzQWwzYzUrb1li?=
 =?utf-8?B?Qkt4ZkxSZ0tlWmgwTnk4dEFoTndiSHJMTkU3d3lqZnJsWTJRRHpMY2h5MjN3?=
 =?utf-8?B?eWlSdHowdmJXa25nWTRCdWVKWTIyV2dVdHF5d0E5bGtKM0lGZUZQR3BLQUpv?=
 =?utf-8?B?U2lQQm1HM0UrOU9YN3Vkcm9xRWtSWFN3N1B0ejRDR0ljcmxtMlh1Ry9HUU8z?=
 =?utf-8?B?SkdWOHlvT211R0VJZVZleDVTZkNzaS9EZmhucy9rS3NEVmFEZXI1bVlWOGlG?=
 =?utf-8?B?b1orK21PS2tOUFRSa1QxcFc3SzhSSEJnbTBDUDIxVVFjWFduUnBXaFd0N2tC?=
 =?utf-8?B?amxxUC9YRFVWZHpueWpYZ0JXeURtRXRFeDdndEZHR0RFc0ltR1gva0ZKT3FX?=
 =?utf-8?B?ZmpWLzZJaVYyVnVGM1ZraFlOekFMWFNpVFBIK2NhMnNSNmR0M0xPQ3hJOGFk?=
 =?utf-8?B?ZTQ0d3dxUDdtMHhKM050bFNtNzYxVVlVQVFXdzNOaUdzMG1MTGM1OUpOZGRr?=
 =?utf-8?B?SnU2TTRkK0haalIxZzRZMFpEc2QremxBVFd1eG1aYjNkWVI1eXhVeW4zVmVV?=
 =?utf-8?B?bkNIQ0hnT0dqWHRwOW9jZU1hSnE4KzRKa1VPZ1ZFZE1HY3NVTlZrYk1QY0to?=
 =?utf-8?B?S0s2VzJRNWlWcjlhZWZJbUh3a3lHbDE2N014SHNHYU1OSXlVQTRVd0poQlVZ?=
 =?utf-8?B?S214dHkyV25xOFhaRXF1amlXNUxHcVJidTZYa1JjaFAyeWNNVnB6SzFqSGMx?=
 =?utf-8?B?RTZHUGdqODVaVnAvZllhZUZadytESXlZelhGckM2cFZGZUFjUC9tQUF2ZGth?=
 =?utf-8?B?Vml3TytYam4zL3J5d09FNTFrejVGczFVSTN3K080bmRIZGFzdy96RzZpbndI?=
 =?utf-8?B?Z0l4M0pqSFZCTkFnZStRajNxT3NSR0JLZ1NhWEpOWG9mZGlIQ0dobWt2Uk1i?=
 =?utf-8?B?dEpVY1ZYVUx0dS92bXc1TmlPVnRBRE5RYXBNcmp1dFF2aDZmMDBRSFVLUUwv?=
 =?utf-8?B?MGFjcVRudzE0bG4rSTNhQzVJaDNoM0JQUjVQd3pvWFRYaG5DWDQxc3VEdmJl?=
 =?utf-8?B?eG5pTUZDaXk3a0cwV3VGek5GSVY4Vzl4bk1ZdWRSVEc0Tm10Vkc4TFdJQzh1?=
 =?utf-8?B?SlE0UVZicDZydFIwYnoxTkFIWklSWGthVVU0eVNkdkNhQTYyVko3cEdTM3ox?=
 =?utf-8?B?UmpRY0pvQ1FFV2lTdElUeDBDRHZzMWorbGlzaFZTSFhTK0FDbWUvNUcxQ3lE?=
 =?utf-8?B?WkpxdUorQVJFc0JZZW8zWGxURGZkbXRLUzdPKzN4UGVjQXlLQjZvRkNtQ0VR?=
 =?utf-8?B?emI3dS80czRFMjh4cldhSmgyUWV2QkZ1RGVkbzdNcEtna1hFZUkrbG40bTNC?=
 =?utf-8?B?bE5HbjRoOFZrSmZCcGpvMDFRNVdWcUpGQVhnOVJRTFJlZ3dKMjZkQ0UwTEEx?=
 =?utf-8?B?bkU2NFQzTmNIa1l1SGVJc3JmQlJ0S0puZGRwUXBwODEzOEdRNkZHcXZXQkth?=
 =?utf-8?B?TEhzYS9UOEljWVVWTmlDTktXbmh3c0toTFZkd1k1bWlNT29hY0I0YWZVT0xX?=
 =?utf-8?B?ZGFaZFhST2FYWHQrZVo3dEdFelROSVczQ3hYV01iRFdaSzdzSjhxTnlXTVpq?=
 =?utf-8?B?SW5RbGozVnZYaVBVVFZFQnIxdlo0RUN6c2c2Q3ZiM2ZiUXF2QVhHcE5RbTlu?=
 =?utf-8?B?NFFsK2tESWdSWEVyN1dBKzlCYjRheHZ3Wm01Q20zRFVGN3NHZFlyYW9LbkhW?=
 =?utf-8?B?c1VsSXA2Y2hZUXNHSHRZb3lKdGgrWU5KZzc1MnRXNitRd0lWcUxLckpXMGZj?=
 =?utf-8?B?d2VUL0JaWTU1L0lwRXQzcFVJUkVyMnlsMUxZenhxNnpZN294T0NJTW4rVyt0?=
 =?utf-8?B?Ujd1ejZpcDNVVTErV25PZEIxV3NXMWM4VUhIbEpnTnEyeDEybWMrM0tGZmdI?=
 =?utf-8?B?L3pMWXNMSzFEZTV1cFRqbHZyMUhmREE2TmxVajNjOTFLWXFKWmEwK1NTVUxO?=
 =?utf-8?Q?+XLKajOniDV6LMrnKpBAUH3ml7aAl6ydmjQF/93vuyr+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79ee5e0-2149-4f93-ac99-08dd16521c70
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2024 00:00:07.6300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SXhTVwqqqxLeydEnlgZvAcrKHbaR6Cesa93arOseOcQ2dp3aatkDj1EMu38S9YzX5uJbjP4zW1Na4PGJ0726YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6881
X-OriginatorOrg: intel.com

PiBPbiAxMi82LzI0IDA4OjEzLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IEl0IGlzIG5vdCBzYWZl
LiBXZSBuZWVkIHRvIGNoZWNrDQo+ID4NCj4gPiAgICAgICBzeXNpbmZvX3RkX2NvbmYtPm51bV9j
cHVpZF9jb25maWcgPD0gMzIuDQo+ID4NCj4gPiBJZiB0aGUgVERYIG1vZHVsZSB2ZXJzaW9uIGlz
IG5vdCBtYXRjaGVkIHdpdGggdGhlIGpzb24gZmlsZSB0aGF0IHdhcw0KPiA+IHVzZWQgdG8gZ2Vu
ZXJhdGUgdGhlIHRkeF9nbG9iYWxfbWV0YWRhdGEuaCwgdGhlIG51bV9jcHVpZF9jb25maWcNCj4g
PiByZXBvcnRlZCBieSB0aGUgYWN0dWFsIFREWCBtb2R1bGUgbWlnaHQgZXhjZWVkIDMyIHdoaWNo
IGNhdXNlcw0KPiA+IG91dC1vZi1ib3VuZCBhcnJheSBhY2Nlc3MuDQo+IA0KPiBUaGUgSlNPTiAq
SVMqIHRoZSBBQkkgZGVzY3JpcHRpb24uIEl0IGNhbid0IGNoYW5nZSBiZXR3ZWVuIHZlcnNpb25z
IG9mIHRoZQ0KPiBURFggbW9kdWxlLiBJdCBjYW4gb25seSBiZSBleHRlbmRlZC4gVGhlICIzMiIg
aXMgbm90IGluIHRoZSBzcGVjIGJlY2F1c2UgdGhlDQo+IHNwZWMgcmVmZXJzIHRvIHRoZSBKU09O
IQ0KDQpBaCwgeWVhaCwgYWdyZWVkLCB0aGUgInNwZWMgcmVmZXJzIHRvIHRoZSBKU09OIi4gIDot
KQ0K

