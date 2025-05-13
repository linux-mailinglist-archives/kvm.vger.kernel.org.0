Return-Path: <kvm+bounces-46396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E8B6AB5E59
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 23:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 502BE7ADE72
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 21:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E697201267;
	Tue, 13 May 2025 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jbhte0Il"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1EF1FFC4F;
	Tue, 13 May 2025 21:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747171208; cv=fail; b=uo0ZPVxo3Cx3NbijThRr5f8mnRHCoX+bvRK6iCo0KBCLLNYNgrh4dweffML3Z8q5FWDiVN9JOtUg2+zRmxl8wWfus9YRe2KKr6G9lZP+UA9hrExsts/n+UJStKi7r9QAIUMpETA9+bQdjh5yhtz+DDGxaBMeLNGkUI+GKGVpwKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747171208; c=relaxed/simple;
	bh=X5Kov2vRqDpxKL4PKJZiLhzKqerSqYUbxIcQOxHjpX4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=go6hp3UQ/Jiq5NlaOvTrTaHS/ypyb+we8VWzX2c5lzOR0WYZWcox/OUUUZcsdae4IZrDc4JAo04vlzwUQ772K4ws2xgxQW/JfiMbrRtZ/Lc5zA4AiaqFJgu2DdmhPtalH2o8hCa8B+USzgmcNZhH+5UbhlxGIN7e3oHUX0Us1I8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jbhte0Il; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747171207; x=1778707207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X5Kov2vRqDpxKL4PKJZiLhzKqerSqYUbxIcQOxHjpX4=;
  b=jbhte0IlS2mB0JyziD6XaArSlVzVcxRES9NISOYPUt5smhj3iRYf3RIn
   OthLjhozwj0ltHgNLTrHXaiG/lfJ2SHkDjbjdc9xr1X5gaBLTXubE5gXO
   D0Bjudn/5z/jliYacGDAbd7tFmHtIDEIQQo+vp8w07zQCFFEU5y26I6j3
   x7EdnB1jv8r9Rjee+BXaLMAR8nz1ooPjrSp8ZWELClGBhNJdQ652CBIPg
   kKQGvuEcP08bPtiFdDUldx23b5Gme6xvc1JbagCF20yQpeRyf0ktl6EbA
   wByzsJw/3o0LDYq35gN00BKfOobLAVgmHmM2UXgS/JwTV4kbBK7ez+jeE
   g==;
X-CSE-ConnectionGUID: qoRj+TgVQ6WUVmc8V7t9gA==
X-CSE-MsgGUID: yIn3+EoTTI2R/FNQc2+39g==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49029835"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49029835"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 14:20:06 -0700
X-CSE-ConnectionGUID: 3AVYM4QMRSyQPEC2vRonGA==
X-CSE-MsgGUID: rHx+HbnJQU2b+ArKaA7pKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="137709250"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 14:20:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 14:20:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 14:20:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 14:20:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fIQvxksUs3nFVxQmjXyCcanMs2tIancmddwJFiSa/66lUlFeS6hZs42x1adsBXvOGrhLEl7XT98M2Hbd7mS0PaOMMN1ntJmtdKiOfaa5/skSdXUeTcmv1bhfl5hfP9JQNBdjKuwj1V4ivyMOUJeg/1HyMUi3LxDlnaoDvJybb5pVYZ2DOxC2CEXVkVEenQRt6jzsCdiht/nSSDm7LaJJp2oDWut5dQELrudAfIe4AUb6Y1TgHU6dyYLCALpFYVJmYf5snftCFrsQwBwtR/t29kUDW0jQRzte+jNgTOZSbNQXchrNj5DS3MBLY+oQxNBbXMtpA+Mc4iS/PPPF7otJ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5Kov2vRqDpxKL4PKJZiLhzKqerSqYUbxIcQOxHjpX4=;
 b=cwSow/FcyaaSHAGK5WLT69Q8mJ+BIOFUeDvqKoNq85q5J/GSoZaRzveYJ1RKe6IkMrUGH1R+WooAJGK9eciJmzEHOHSgpxl0FuYw2yvjEX/fJmhWAzsBVazCXh+KwZgBlhYN/3fd2EEYbVXZr0B2KgtHRQQMOEINXp4Xj1aPuJJ6lINh7QRAWpVt4qF1I94g8mcmifk6AIeglA8wu+NZRchWWdN7ArAZABDlxFvb2DAsgbYACkumRUIdRyUnYcnUYHI+QDNo1Wu4GbbisD70GVAzhvUmlbwE1mqEVlsTSmv0yCMExPMjiICoUtVoBeRKSt+gDzeu5uvUFFMrpz4ZkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB7421.namprd11.prod.outlook.com (2603:10b6:510:281::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 13 May
 2025 21:20:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 21:20:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level according
 to vCPU's ACCEPT level
Thread-Topic: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level
 according to vCPU's ACCEPT level
Thread-Index: AQHbtMZGizk+eJuph02+8m+gmHBwDrPRMAQA
Date: Tue, 13 May 2025 21:20:01 +0000
Message-ID: <7307f6308d6e506bad00749307400fc6e65bc6e4.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030713.403-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030713.403-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB7421:EE_
x-ms-office365-filtering-correlation-id: cbcf813a-e70f-4300-5e82-08dd9263ebd9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S2lJeE1oblh6VmF1RS8xRHlBWmxBYW1kK2wwaG4rQU5GL2QvTnk2akJNRCtG?=
 =?utf-8?B?eHR1dnFRaG5kMVRINk9lem42T2R2M3ZPRlh2SlJBUmtWSDlnL1VmUC9ibUpE?=
 =?utf-8?B?Mklja1dLTE5YNG9IeE9tN1A2TXMzYmNXMjVuZ0JBTlVBOUliRzJVa0ErMjMy?=
 =?utf-8?B?ZjFGUmoxWHVYeWVNRjgvRUtDTlBCK3ptQUVyK0RtRnRmeGtDMnlPcUtUZFFH?=
 =?utf-8?B?b1ZodXJpaHlWWXBGQlNsVFppY24xNDlIQ01xTVVZdDB6b1VrYVFGYk9VSUVm?=
 =?utf-8?B?dThsRUhwVVhOYnNKa08wV2tZUWp4Q08zNTcxSmNqbXpVbkFJcmttZE1nOTVN?=
 =?utf-8?B?d3ZhWjVaejZZZWw2SUVJWFlyMTUwQjVQOVhzU2g3ZW5zdWg4RTlyYVRETEg5?=
 =?utf-8?B?UFZGMnpTbGlvQk9NejVObjFndEFTVm9nR0tOdWgxK05WMWwrM1QrOHp4Nmgw?=
 =?utf-8?B?Vm9XMXJJMjRQRXo4R0VUUFRlMitibDRodmIvMDlTUU1CcStkNFpDcG9vTCts?=
 =?utf-8?B?SDlJdnBQTmMzYjlYZnNNYlA4ZmltYklRbjJsYitNOFVSV0F2eDIzUlZOdlFm?=
 =?utf-8?B?SU84UmZNeU9zS1RoWnhsd1Fzd04wR1liWFl0VnhycW5ob1FtdlNua3NvRlo5?=
 =?utf-8?B?NElVZWpIM0hRR0Q1OGxoSEo0d3JkanVDRklWNy94WWorQXRiNzFUMUZtN3dG?=
 =?utf-8?B?RnNWZi9zQmdVM0REV1QrZmNwRGRnRGw1a0tmNjByQlZ4c0N3SDNjNTJ4U2FY?=
 =?utf-8?B?Zk1HNzRXRWovUEovTmZHUjh0RXFFS0pabnhxTmQrOFA2QkdKaHRwSTV1SHJ3?=
 =?utf-8?B?TWtkRmFjQlMvRUZiL0Izdm1TZXpiZ0NmQWtaSkNRVU9OdW1TUDhxNW45aVlO?=
 =?utf-8?B?QmVMTW9lTWtoRHRzQW90dW9xSTFBUUo4SXFxSm1taHBxZWpETSs1eUFZUS8x?=
 =?utf-8?B?VXozcWp4S3pIanVRYVlzYTZXZ1BmalIzallxUEJQWXE4RmpjclYyVlFKemho?=
 =?utf-8?B?VDFCbEVmUHQ2Mk0xMjd0SFdYQndYT0xuT2dBYjQwZERJSnNmbEY3QzA1ZWRn?=
 =?utf-8?B?UHlvK09LNjRJVUQvSzQ3RnhMR2doeVJYTHVSQ0twajluSzVqbGxLWE4vR1dT?=
 =?utf-8?B?c1paVEJ3ME9hbE9haG5KR2FUWE95dlBQVnVVRFhVSWdKdXV2SnVSd2l4ZXNw?=
 =?utf-8?B?OThGMTJhYmdYOU1OUVE5cEQxVFVkS1A0bmU1czV4TnJRWFRLQnEzNURxd0VB?=
 =?utf-8?B?b1RYNEd1eVovM2F1YVF3NXRObHVsOWkrY1FnMFB5MjdycFlBSW95QnlVeVAz?=
 =?utf-8?B?VStTY09TY1FQWmhPZDE5dG9ZY2VMR21HWUo5eitxN2w0a0FnTk1vck8xcFRD?=
 =?utf-8?B?S0lHcENHYUlvNFF4Y1N1ZjhDOUxkNG9rQ0l2TUNCWjd1Q1BldW9iVGUrNVpO?=
 =?utf-8?B?VGdPOVozbXJBSW5TR1p2TTFGZDBxWWtFSVhDd3lqYXBuUFN1aFFqMCtoaWxj?=
 =?utf-8?B?aEhjTUYrMWc5VDEwVFgxWVdTUmVPbHNhZDUyeVM1OGh2R0I4N0pOT1hRZWlP?=
 =?utf-8?B?eHlmK3BrT3lja295cUE4YkwrbFd0RjlnclNIYzNIOXNPbnRwMFE1SC8yaTlz?=
 =?utf-8?B?TUY3R0l5SFBWNWV5QmdIMElTZnlZKzlyTUp5QUcvbVpoQjBRQnhPS0txYUo4?=
 =?utf-8?B?NExldkIySUFlRGtObXBSYkdTNmNSeXJYTEFhR3hReThzUytJd1Rrc1Nzc0xZ?=
 =?utf-8?B?MTBMT0RZNm9EWlI5OUxaYUd4N0xZWEc0SHpia25Dc1JOeGJPRS9ITUk1WEh6?=
 =?utf-8?B?a1pXb09lQ3BEQm50NzV5UTV4bXhhekFYaDVsZmxqbXNoNjJCcHd5cmFKRXNT?=
 =?utf-8?B?L1Q0Y2VSM0dRMXVyczI2WDRVL01QeUQ2Mk5qSllrRFRKV3JmWE85VkdXbzBo?=
 =?utf-8?B?WnF2K05RY3FST1pWMHZWc2EwS2RUWVBLVzR6MERrY3RIV3poUVhiZnNiSWJF?=
 =?utf-8?Q?7oJ8W9TqqxFhV2jioMOikVYRTj4grQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWNNeHJ5dkpMUTRlUndSby9OUWJpem5YSThqN2RaMUczRVFPaUJWYkRJYjBI?=
 =?utf-8?B?alUyZ1lTVjFSTGtDaXYvRFhnNkJrbmVpc3ZkOHFRa29zenNJVU01cTZhVDBC?=
 =?utf-8?B?cGhlUTFIcDlFV050eTNsZUVzejQ3dU4vSXM0bktLRWJJWWJiR2RwWkJURmIw?=
 =?utf-8?B?TkNlOXdmUVdsY3B5d0RNbS95ZGN3Qy9pc2FsUXpSZWhDc2VKU0hQL0k1NGtm?=
 =?utf-8?B?VDhrdzVzUG9aQ0h4dkROampNT0N1YllhTWZHWkZaSzZOREhrbnJMSHUrTlhm?=
 =?utf-8?B?RlV0d1U3TlJ5RTV5TWUyZ09aOHZaOVN5MjVwcTAwUHJ3dkJYNGVWREp0QXFa?=
 =?utf-8?B?VnhiN2xpRUpJbzRGSzBEVE1HVVcybEdIWC9iYm5nMk1CcXZ1Y2JUZlphNXMw?=
 =?utf-8?B?V1hBMGtFTStXcDhSVm5obG1LcjBsaldpblUvb0NQeDcycHl5MVIwKzB1eXZF?=
 =?utf-8?B?U2k2U3d4R0JIZ0duRnFMVFQ3bDd4WDg4dkVYRnBZS3Y2bXlGV2dGRGRpNVN0?=
 =?utf-8?B?K01jQVdKNXBnZ2tkMHpwaVJLUkc5S25IWVdFM29uTWNQbldObTNrUFI4RkVv?=
 =?utf-8?B?eDUvL0VXYWxGYW1rYmw3dThEbjFMVWNkcjNOWXN4elVROVlJR2g2dHM5cTlN?=
 =?utf-8?B?YmtLemhXWDNmN2pQMFE5V1pBa3hNbmwwVnBMbWVsaHlqQWF4UXJYNlVPVDU2?=
 =?utf-8?B?Q3hmVFlXN1lMVzk3UTRtTXhPengxSmpyQ2l2MHhSbW0vc1ZMSm5sOWl3RkFx?=
 =?utf-8?B?UUREdHBPZXp4cnJhOTh0WWFkMjhwSFZQcXNqVzVSUmdCVEU3eEd6UngwNGR5?=
 =?utf-8?B?aTdpcC9qNStXeHhITUphUlhNbUlWd2lxdWZmZWNBdFg5dERZSVFjekh4bFJT?=
 =?utf-8?B?SzlUS2JzQU1OeXllUnFZYW5ud09mWTI3WG43Y2FyTkxIcGpxblNLdFFpL1dx?=
 =?utf-8?B?QUZGRXVPbWZXRlZuODluZkw3NEhRNkdQY0Jrb1FRb2h0Tk9JYis0TkkyVTF0?=
 =?utf-8?B?bHl4bG93SmNnTmRPNS9mc0hlVGVFdDZ2OGhndHh4MGp5dG1Xdm5ncVdFMC9T?=
 =?utf-8?B?ZE44KzVpWkVQN0YvaHlkenoxWUNYREI4M3QzR3o2cFBpSDA5dmc3UVFKUWRC?=
 =?utf-8?B?WjdFN2Y4VlVNckNzYmJLbVp0S05CaUIzZTZYcm85YVV6VUc2SXhZWUdBOVJr?=
 =?utf-8?B?cFF3Rit3cGhpY2J6bjB2NkhrZi82dHJGUEJJWkxtSlZQMUt1Q0sxTjBmcWdO?=
 =?utf-8?B?NnZ4ZHd3QWs5bGYvQ3luNHBNNFpmT1J4ZzZkT3l6UDRaS0pGTVRYY1B5TW83?=
 =?utf-8?B?bXpmbXdVcjZNdkFKdlFYQ3ZaZkRtNmJqU3JhdGFuWHBGTEZQcjFvVDU3ZUV0?=
 =?utf-8?B?cWI0K1E1elI4TCs2cm5wY0Q3Ry9xRjJpeURwTmJNMDlER0lHT3llMmpoZXpQ?=
 =?utf-8?B?V1Z6SUNvRXFDWXh4V0Z0MWd5cVBGSW9DQlA1K1BZa20ydTFnQ3ZRakU0ejI4?=
 =?utf-8?B?K3FaV1E5WGk5amRUKzREVUlMbEVpS0R0V0pJL3VGYS9mcEFZVDc0T1Rwd2Rj?=
 =?utf-8?B?eUhNVDQ1NS9vekJYdkwvdUN2NDd0S05ZalAwNnlqcTZTc05xaXc3ZWFkM1Yz?=
 =?utf-8?B?QmFHRGZ6bStQMVpjSlJKcWY4QkJXdTk1MElvRG9ROHF1ZzZYL09pT0h5eGhj?=
 =?utf-8?B?NWZvcmZ3eTRLNzBJK1RxRTJFc3FpeWZtNHlLM2V4ZVdTUm5ja2cxR2RFQll6?=
 =?utf-8?B?b0VBSlNaVmFCbGVRcXVYRXVYeTkyWG9uQ1NiZ1FCdStWbnovT1c4cWFhOHRO?=
 =?utf-8?B?eVJlWVZ4NGdrTmhKL1JmSlpkbytPU1ZkVTVPcTRtT0dNSE5KOUV4SXQwRmYy?=
 =?utf-8?B?VjBNWGhIT3d2QXBRZWxRRXlFRm91SGN0N0VMMTN3emlFQzZUTnAzTEdBMS9r?=
 =?utf-8?B?OGdRVExIZTdtYmg4aGhzWDAzdVlOSlF2MEZxUndxYXBWSlBQbVFmbWs2U25k?=
 =?utf-8?B?Yk93cytiWmtkVkFnWnVCQ2FOeXNjUENHNEluWUFmM2F4ZVFzNllFUVE3MEI1?=
 =?utf-8?B?TkpPQmNkL2s1VnAzOWFaY2pVMEhJWUlzZE9pSVBXc2hvS0hhcU9SS1MrOGhs?=
 =?utf-8?B?aFpsNFVEblA1M1BWMmc2OFNsK1BmT1F6c09xUW1Gd2MvYWhzNUlpck1OZHFa?=
 =?utf-8?Q?MU74iJE4T7OzwZmqCAVT1GE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73CDA153285AF94A9D74F980C68531E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcf813a-e70f-4300-5e82-08dd9263ebd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 21:20:01.2339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4fTx6BCGekDL6Xzxof44kgrj36TIkVkUDorBgjUp8y3DWRVCxd/ucZzK7qmXp3A5ZfTnoQMkOUlhWtBzIcKByu47m87UqqyjlCMQ6WrM4Y4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7421
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRGV0
ZXJtaW5lIHRoZSBtYXggbWFwcGluZyBsZXZlbCBvZiBhIHByaXZhdGUgR0ZOIGFjY29yZGluZyB0
byB0aGUgdkNQVSdzDQo+IEFDQ0VQVCBsZXZlbCBzcGVjaWZpZWQgaW4gdGhlIFREQ0FMTCBUREcu
TUVNLlBBR0UuQUNDRVBULg0KPiANCj4gV2hlbiBhbiBFUFQgdmlvbGF0aW9uIG9jY3VycyBkdWUg
dG8gYSB2Q1BVIGludm9raW5nIFRERy5NRU0uUEFHRS5BQ0NFUFQNCj4gYmVmb3JlIGFueSBhY3R1
YWwgbWVtb3J5IGFjY2VzcywgdGhlIHZDUFUncyBBQ0NFUFQgbGV2ZWwgaXMgYXZhaWxhYmxlIGlu
DQo+IHRoZSBleHRlbmRlZCBleGl0IHF1YWxpZmljYXRpb24uIFNldCB0aGUgdkNQVSdzIEFDQ0VQ
VCBsZXZlbCBhcyB0aGUgbWF4DQo+IG1hcHBpbmcgbGV2ZWwgZm9yIHRoZSBmYXVsdGluZyBHRk4u
IFRoaXMgaXMgbmVjZXNzYXJ5IGJlY2F1c2UgaWYgS1ZNDQo+IHNwZWNpZmllcyBhIG1hcHBpbmcg
bGV2ZWwgZ3JlYXRlciB0aGFuIHRoZSB2Q1BVJ3MgQUNDRVBUIGxldmVsLCBhbmQgbm8NCj4gb3Ro
ZXIgdkNQVXMgYXJlIGFjY2VwdGluZyBhdCBLVk0ncyBtYXBwaW5nIGxldmVsLCBUREcuTUVNLlBB
R0UuQUNDRVBUIHdpbGwNCj4gcHJvZHVjZSBhbm90aGVyIEVQVCB2aW9sYXRpb24gb24gdGhlIHZD
UFUgYWZ0ZXIgcmUtZW50ZXJpbmcgdGhlIFRELCB3aXRoDQo+IHRoZSB2Q1BVJ3MgQUNDRVBUIGxl
dmVsIGluZGljYXRlZCBpbiB0aGUgZXh0ZW5kZWQgZXhpdCBxdWFsaWZpY2F0aW9uLg0KDQpNYXli
ZSBhIGxpdHRsZSBtb3JlIGluZm8gd291bGQgaGVscC4gSXQncyBiZWNhdXNlIHRoZSBURFggbW9k
dWxlIHdhbnRzIHRvDQoiYWNjZXB0IiB0aGUgc21hbGxlciBzaXplIGluIHRoZSByZWFsIFMtRVBU
LCBidXQgS1ZNIGNyZWF0ZWQgYSBodWdlIHBhZ2UuIEl0DQpjYW4ndCBkZW1vdGUgdG8gZG8gdGhp
cyB3aXRob3V0IGhlbHAgZnJvbSBLVk0uDQoNCj4gDQo+IEludHJvZHVjZSAidmlvbGF0aW9uX2dm
bl9zdGFydCIsICJ2aW9sYXRpb25fZ2ZuX2VuZCIsIGFuZA0KPiAidmlvbGF0aW9uX3JlcXVlc3Rf
bGV2ZWwiIGluICJzdHJ1Y3QgdmNwdV90ZHgiIHRvIHBhc3MgdGhlIHZDUFUncyBBQ0NFUFQNCj4g
bGV2ZWwgdG8gVERYJ3MgcHJpdmF0ZV9tYXhfbWFwcGluZ19sZXZlbCBob29rIGZvciBkZXRlcm1p
bmluZyB0aGUgbWF4DQo+IG1hcHBpbmcgbGV2ZWwuDQo+IA0KPiBJbnN0ZWFkIG9mIHRha2luZyBz
b21lIGJpdHMgb2YgdGhlIGVycm9yX2NvZGUgcGFzc2VkIHRvDQo+IGt2bV9tbXVfcGFnZV9mYXVs
dCgpIGFuZCByZXF1aXJpbmcgS1ZNIE1NVSBjb3JlIHRvIGNoZWNrIHRoZSBlcnJvcl9jb2RlIGZv
cg0KPiBhIGZhdWx0J3MgbWF4X2xldmVsLCBoYXZpbmcgVERYJ3MgcHJpdmF0ZV9tYXhfbWFwcGlu
Z19sZXZlbCBob29rIGNoZWNrIGZvcg0KPiByZXF1ZXN0IGxldmVsIGF2b2lkcyBjaGFuZ2VzIHRv
IHRoZSBLVk0gTU1VIGNvcmUuIFRoaXMgYXBwcm9hY2ggYWxzbw0KPiBhY2NvbW1vZGF0ZXMgZnV0
dXJlIHNjZW5hcmlvcyB3aGVyZSB0aGUgcmVxdWVzdGVkIG1hcHBpbmcgbGV2ZWwgaXMgdW5rbm93
bg0KPiBhdCB0aGUgc3RhcnQgb2YgdGR4X2hhbmRsZV9lcHRfdmlvbGF0aW9uKCkgKGkuZS4sIGJl
Zm9yZSBpbnZva2luZw0KPiBrdm1fbW11X3BhZ2VfZmF1bHQoKSkuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
WWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92
bXgvdGR4LmMgICAgICB8IDM2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0K
PiAgYXJjaC94ODYva3ZtL3ZteC90ZHguaCAgICAgIHwgIDQgKysrKw0KPiAgYXJjaC94ODYva3Zt
L3ZteC90ZHhfYXJjaC5oIHwgIDMgKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDQyIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14
L3RkeC5jIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBpbmRleCA4Njc3NWFmODVjZDguLmRk
NjNhNjM0ZTYzMyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiArKysg
Yi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IEBAIC0xODU5LDEwICsxODU5LDM0IEBAIHN0YXRp
YyBpbmxpbmUgYm9vbCB0ZHhfaXNfc2VwdF92aW9sYXRpb25fdW5leHBlY3RlZF9wZW5kaW5nKHN0
cnVjdCBrdm1fdmNwdSAqdmNwDQo+ICAJcmV0dXJuICEoZXEgJiBFUFRfVklPTEFUSU9OX1BST1Rf
TUFTSykgJiYgIShlcSAmIEVQVF9WSU9MQVRJT05fRVhFQ19GT1JfUklORzNfTElOKTsNCj4gIH0N
Cj4gIA0KPiArc3RhdGljIGlubGluZSB2b2lkIHRkeF9nZXRfYWNjZXB0X2xldmVsKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgZ3BhX3QgZ3BhKQ0KPiArew0KPiArCXN0cnVjdCB2Y3B1X3RkeCAqdGR4
ID0gdG9fdGR4KHZjcHUpOw0KPiArCWludCBsZXZlbCA9IC0xOw0KPiArDQo+ICsJdTY0IGVlcV90
eXBlID0gdGR4LT5leHRfZXhpdF9xdWFsaWZpY2F0aW9uICYgVERYX0VYVF9FWElUX1FVQUxfVFlQ
RV9NQVNLOw0KPiArDQo+ICsJdTMyIGVlcV9pbmZvID0gKHRkeC0+ZXh0X2V4aXRfcXVhbGlmaWNh
dGlvbiAmIFREWF9FWFRfRVhJVF9RVUFMX0lORk9fTUFTSykgPj4NCj4gKwkJCVREWF9FWFRfRVhJ
VF9RVUFMX0lORk9fU0hJRlQ7DQo+ICsNCj4gKwlpZiAoZWVxX3R5cGUgPT0gVERYX0VYVF9FWElU
X1FVQUxfVFlQRV9BQ0NFUFQpIHsNCj4gKwkJbGV2ZWwgPSAoZWVxX2luZm8gJiBHRU5NQVNLKDIs
IDApKSArIDE7DQo+ICsNCj4gKwkJdGR4LT52aW9sYXRpb25fZ2ZuX3N0YXJ0ID0gZ2ZuX3JvdW5k
X2Zvcl9sZXZlbChncGFfdG9fZ2ZuKGdwYSksIGxldmVsKTsNCj4gKwkJdGR4LT52aW9sYXRpb25f
Z2ZuX2VuZCA9IHRkeC0+dmlvbGF0aW9uX2dmbl9zdGFydCArIEtWTV9QQUdFU19QRVJfSFBBR0Uo
bGV2ZWwpOw0KPiArCQl0ZHgtPnZpb2xhdGlvbl9yZXF1ZXN0X2xldmVsID0gbGV2ZWw7DQo+ICsJ
fSBlbHNlIHsNCj4gKwkJdGR4LT52aW9sYXRpb25fZ2ZuX3N0YXJ0ID0gLTE7DQo+ICsJCXRkeC0+
dmlvbGF0aW9uX2dmbl9lbmQgPSAtMTsNCj4gKwkJdGR4LT52aW9sYXRpb25fcmVxdWVzdF9sZXZl
bCA9IC0xOw0KDQpXZSBoYWQgc29tZSBpbnRlcm5hbCBjb252ZXJzYXRpb25zIG9uIGhvdyBLVk0g
dXNlZCB0byBzdHVmZiBhIGJ1bmNoIG9mIGZhdWx0DQpzdHVmZiBpbiB0aGUgdmNwdSBzbyBpdCBk
aWRuJ3QgaGF2ZSB0byBwYXNzIGl0IGFyb3VuZCwgYnV0IG5vdyB1c2VzIHRoZSBmYXVsdA0Kc3Ry
dWN0IGZvciB0aGlzLiBUaGUgcG9pbnQgd2FzIChJSVJDKSB0byBwcmV2ZW50IHN0YWxlIGRhdGEg
ZnJvbSBnZXR0aW5nDQpjb25mdXNlZCBvbiBmdXR1cmUgZmF1bHRzLCBhbmQgaXQgYmVpbmcgaGFy
ZCB0byB0cmFjayB3aGF0IGNhbWUgZnJvbSB3aGVyZS4NCg0KSW4gdGhlIFREWCBjYXNlLCBJIHRo
aW5rIHRoZSBwb3RlbnRpYWwgZm9yIGNvbmZ1c2lvbiBpcyBzdGlsbCB0aGVyZS4gVGhlIE1NVQ0K
Y29kZSBjb3VsZCB1c2Ugc3RhbGUgZGF0YSBpZiBhbiBhY2NlcHQgRVBUIHZpb2xhdGlvbiBoYXBw
ZW5zIGFuZCBjb250cm9sIHJldHVybnMNCnRvIHVzZXJzcGFjZSwgYXQgd2hpY2ggcG9pbnQgdXNl
cnNwYWNlIGRvZXMgYSBLVk1fUFJFX0ZBVUxUX01FTU9SWS4gVGhlbiBpdCB3aWxsDQpzZWUgdGhl
IHN0YWxlICB0ZHgtPnZpb2xhdGlvbl8qLiBOb3QgZXhhY3RseSBhIGNvbW1vbiBjYXNlLCBidXQg
YmV0dGVyIHRvIG5vdA0KaGF2ZSBsb29zZSBlbmRzIGlmIHdlIGNhbiBhdm9pZCBpdC4NCg0KTG9v
a2luZyBtb3JlIGNsb3NlbHksIEkgZG9uJ3Qgc2VlIHdoeSBpdCdzIHRvbyBoYXJkIHRvIHBhc3Mg
aW4gYSBtYXhfZmF1bHRfbGV2ZWwNCmludG8gdGhlIGZhdWx0IHN0cnVjdC4gVG90YWxseSB1bnRl
c3RlZCByb3VnaCBpZGVhLCB3aGF0IGRvIHlvdSB0aGluaz8NCg0KZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9z
dC5oDQppbmRleCBmYWFlODJlZWZkOTkuLjNkYzQ3NmRhNjM5MSAxMDA2NDQNCi0tLSBhL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmgNCkBAIC0yODIsNyArMjgyLDExIEBAIGVudW0geDg2X2ludGVyY2VwdF9zdGFnZTsN
CiAgKiB3aGVuIHRoZSBndWVzdCB3YXMgYWNjZXNzaW5nIHByaXZhdGUgbWVtb3J5Lg0KICAqLw0K
ICNkZWZpbmUgUEZFUlJfUFJJVkFURV9BQ0NFU1MgICBCSVRfVUxMKDQ5KQ0KLSNkZWZpbmUgUEZF
UlJfU1lOVEhFVElDX01BU0sgICAoUEZFUlJfSU1QTElDSVRfQUNDRVNTIHwgUEZFUlJfUFJJVkFU
RV9BQ0NFU1MpDQorDQorI2RlZmluZSBQRkVSUl9GQVVMVF9MRVZFTF9NQVNLIChCSVRfVUxMKDUw
KSB8IEJJVF9VTEwoNTEpIHwgQklUX1VMTCg1MikpDQorI2RlZmluZSBQRkVSUl9GQVVMVF9MRVZF
TF9TSElGVCA1MA0KKw0KKyNkZWZpbmUgUEZFUlJfU1lOVEhFVElDX01BU0sgICAoUEZFUlJfSU1Q
TElDSVRfQUNDRVNTIHwgUEZFUlJfUFJJVkFURV9BQ0NFU1MgfA0KUEZFUlJfRkFVTFRfTEVWRUxf
TUFTSykNCiANCiAvKiBhcGljIGF0dGVudGlvbiBiaXRzICovDQogI2RlZmluZSBLVk1fQVBJQ19D
SEVDS19WQVBJQyAgIDANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L21tdV9pbnRlcm5h
bC5oIGIvYXJjaC94ODYva3ZtL21tdS9tbXVfaW50ZXJuYWwuaA0KaW5kZXggMWMxNzY0ZjQ2ZTY2
Li5iZGIxYjBlYWJkNjcgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdV9pbnRlcm5h
bC5oDQorKysgYi9hcmNoL3g4Ni9rdm0vbW11L21tdV9pbnRlcm5hbC5oDQpAQCAtMzYxLDcgKzM2
MSw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGt2bV9tbXVfZG9fcGFnZV9mYXVsdChzdHJ1Y3Qga3Zt
X3ZjcHUNCip2Y3B1LCBncGFfdCBjcjJfb3JfZ3BhLA0KICAgICAgICAgICAgICAgIC5ueF9odWdl
X3BhZ2Vfd29ya2Fyb3VuZF9lbmFibGVkID0NCiAgICAgICAgICAgICAgICAgICAgICAgIGlzX254
X2h1Z2VfcGFnZV9lbmFibGVkKHZjcHUtPmt2bSksDQogDQotICAgICAgICAgICAgICAgLm1heF9s
ZXZlbCA9IEtWTV9NQVhfSFVHRVBBR0VfTEVWRUwsDQorICAgICAgICAgICAgICAgLm1heF9sZXZl
bCA9IChlcnIgJiBQRkVSUl9GQVVMVF9MRVZFTF9NQVNLKSA+Pg0KUEZFUlJfRkFVTFRfTEVWRUxf
U0hJRlQsDQogICAgICAgICAgICAgICAgLnJlcV9sZXZlbCA9IFBHX0xFVkVMXzRLLA0KICAgICAg
ICAgICAgICAgIC5nb2FsX2xldmVsID0gUEdfTEVWRUxfNEssDQogICAgICAgICAgICAgICAgLmlz
X3ByaXZhdGUgPSBlcnIgJiBQRkVSUl9QUklWQVRFX0FDQ0VTUywNCmRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0vdm14L2NvbW1vbi5oIGIvYXJjaC94ODYva3ZtL3ZteC9jb21tb24uaA0KaW5kZXgg
OGY0NmEwNmUyYzQ0Li4yZjIyYjI5NGVmOGIgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vdm14
L2NvbW1vbi5oDQorKysgYi9hcmNoL3g4Ni9rdm0vdm14L2NvbW1vbi5oDQpAQCAtODMsNyArODMs
OCBAQCBzdGF0aWMgaW5saW5lIGJvb2wgdnRfaXNfdGR4X3ByaXZhdGVfZ3BhKHN0cnVjdCBrdm0g
Kmt2bSwNCmdwYV90IGdwYSkNCiB9DQogDQogc3RhdGljIGlubGluZSBpbnQgX192bXhfaGFuZGxl
X2VwdF92aW9sYXRpb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFfdCBncGEsDQotICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nIGV4aXRf
cXVhbGlmaWNhdGlvbikNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHVuc2lnbmVkIGxvbmcgZXhpdF9xdWFsaWZpY2F0aW9uLA0KKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgdTggbWF4X2ZhdWx0X2xldmVsKQ0KIHsNCiAgICAg
ICAgdTY0IGVycm9yX2NvZGU7DQogDQpAQCAtMTA3LDYgKzEwOCwxMCBAQCBzdGF0aWMgaW5saW5l
IGludCBfX3ZteF9oYW5kbGVfZXB0X3Zpb2xhdGlvbihzdHJ1Y3QNCmt2bV92Y3B1ICp2Y3B1LCBn
cGFfdCBncGEsDQogICAgICAgIGlmICh2dF9pc190ZHhfcHJpdmF0ZV9ncGEodmNwdS0+a3ZtLCBn
cGEpKQ0KICAgICAgICAgICAgICAgIGVycm9yX2NvZGUgfD0gUEZFUlJfUFJJVkFURV9BQ0NFU1M7
DQogDQorICAgICAgIEJVSUxEX0JVR19PTihLVk1fTUFYX0hVR0VQQUdFX0xFVkVMID49ICgxIDw8
DQpod2VpZ2h0NjQoUEZFUlJfRkFVTFRfTEVWRUxfTUFTSykpKTsNCisNCisgICAgICAgZXJyb3Jf
Y29kZSB8PSAodTY0KW1heF9mYXVsdF9sZXZlbCA8PCBQRkVSUl9GQVVMVF9MRVZFTF9TSElGVDsN
CisNCiAgICAgICAgcmV0dXJuIGt2bV9tbXVfcGFnZV9mYXVsdCh2Y3B1LCBncGEsIGVycm9yX2Nv
ZGUsIE5VTEwsIDApOw0KIH0NCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5j
IGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KaW5kZXggZTk5NGE2YzA4YTc1Li4xOTA0N2RlNGQ5
OGQgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQorKysgYi9hcmNoL3g4Ni9r
dm0vdm14L3RkeC5jDQpAQCAtMjAyNyw3ICsyMDI3LDcgQEAgc3RhdGljIGludCB0ZHhfaGFuZGxl
X2VwdF92aW9sYXRpb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KICAgICAgICAgKiBoYW5kbGUg
cmV0cmllcyBsb2NhbGx5IGluIHRoZWlyIEVQVCB2aW9sYXRpb24gaGFuZGxlcnMuDQogICAgICAg
ICAqLw0KICAgICAgICB3aGlsZSAoMSkgew0KLSAgICAgICAgICAgICAgIHJldCA9IF9fdm14X2hh
bmRsZV9lcHRfdmlvbGF0aW9uKHZjcHUsIGdwYSwgZXhpdF9xdWFsKTsNCisgICAgICAgICAgICAg
ICByZXQgPSBfX3ZteF9oYW5kbGVfZXB0X3Zpb2xhdGlvbih2Y3B1LCBncGEsIGV4aXRfcXVhbCwN
CktWTV9NQVhfSFVHRVBBR0VfTEVWRUwpOw0KIA0KICAgICAgICAgICAgICAgIGlmIChyZXQgIT0g
UkVUX1BGX1JFVFJZIHx8ICFsb2NhbF9yZXRyeSkNCiAgICAgICAgICAgICAgICAgICAgICAgIGJy
ZWFrOw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0v
dm14L3ZteC5jDQppbmRleCBlZjJkNzIwOGRkMjAuLmI3MGEyZmYzNTg4NCAxMDA2NDQNCi0tLSBh
L2FyY2gveDg2L2t2bS92bXgvdm14LmMNCisrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCkBA
IC01NzgyLDcgKzU3ODIsNyBAQCBzdGF0aWMgaW50IGhhbmRsZV9lcHRfdmlvbGF0aW9uKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSkNCiAgICAgICAgaWYgKHVubGlrZWx5KGFsbG93X3NtYWxsZXJfbWF4
cGh5YWRkciAmJiAha3ZtX3ZjcHVfaXNfbGVnYWxfZ3BhKHZjcHUsDQpncGEpKSkNCiAgICAgICAg
ICAgICAgICByZXR1cm4ga3ZtX2VtdWxhdGVfaW5zdHJ1Y3Rpb24odmNwdSwgMCk7DQogDQotICAg
ICAgIHJldHVybiBfX3ZteF9oYW5kbGVfZXB0X3Zpb2xhdGlvbih2Y3B1LCBncGEsIGV4aXRfcXVh
bGlmaWNhdGlvbik7DQorICAgICAgIHJldHVybiBfX3ZteF9oYW5kbGVfZXB0X3Zpb2xhdGlvbih2
Y3B1LCBncGEsIGV4aXRfcXVhbGlmaWNhdGlvbiwNCktWTV9NQVhfSFVHRVBBR0VfTEVWRUwpOw0K
IH0NCiANCiBzdGF0aWMgaW50IGhhbmRsZV9lcHRfbWlzY29uZmlnKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCg0KDQo=

