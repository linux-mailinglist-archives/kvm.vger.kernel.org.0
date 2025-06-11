Return-Path: <kvm+bounces-49070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CF3AD5864
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9115188C2CA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA7128C2A2;
	Wed, 11 Jun 2025 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fd5pxYFR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65E126AAAA;
	Wed, 11 Jun 2025 14:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749651470; cv=fail; b=kZ2qzLdbyHzsInN5ARMzozkAb1nfeRJNn4Sd9mlfTTvm9cuow7feEmiqGAxsc3RJe8Ze3Re+STWBQHmtBFF6uLqPof+nvcPROt5t/iCww1cRw2fGzSM/i45e7/M94a4UXzpdxsxp2nsC97yIC54tHk6IIM4SC+bz1eI5YH03kxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749651470; c=relaxed/simple;
	bh=XwO0nNUzQPcR5YxwcGK80oAIUwpvH6ASQ5GERkwgT5M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=deKxO3dByQ3aTbbHK8/JDzlH5MJKUr0D0vPxL37tU7XQ90pYF2jaB8S8NJ5DcT3ujSXycrSpdZyC2eKIL4G3T+DrjiCF65S6DL2bCbyWXHmhudMpdrE2Jn4R/UYBlrq8mosjsXB9Hm5qcnOCAy8cI/aEevEvbGKbzg2d98c1yy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fd5pxYFR; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749651469; x=1781187469;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XwO0nNUzQPcR5YxwcGK80oAIUwpvH6ASQ5GERkwgT5M=;
  b=Fd5pxYFROZCSOqP7grw7H4u0xp29u0HLoK7/8lZSGoguPIUA+5rTWWgt
   ctVfZOWf3SUf45WGJl4blIVJ+VlRBSmjy3vqShcUGIfQUjR79JodsOf1U
   JUB3QcoafQKRNdHTpnuZTOnRZJ0bFWAlDHFo3y+3Ko1WSfcEqzviGvLTU
   nbefeKnRbof5DQbHB9NawRofRWR8G5Btu6BIysHZHuqXA5GjxsoU+EFxE
   /K+6MunVW4HjNeEtiPJ36zyq6RRKuM0eqrcoJnZZ/khG/oas+5OyRvxa5
   yO526tXuQ3n8Nd98UQuu/q4SGal6ILBflmqGlv2lCpXe9OikMVXFBD4KP
   A==;
X-CSE-ConnectionGUID: GMKTTGvISn6nK2v8PR30og==
X-CSE-MsgGUID: cTPi9dknQDySBOzOSrXSkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="62407285"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="62407285"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:17:48 -0700
X-CSE-ConnectionGUID: 60RLlBIgQyqgBgBxz5RpyA==
X-CSE-MsgGUID: AvPhNSfGQhO9o8yZDGYneA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="170387735"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:17:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:17:47 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 07:17:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.76)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:17:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cqU4jmHOW/V8f/1kjrCp/2dZOaSHIXo5TiN35TwBtxDgE8RVxLLnqDnqEJPuvsE+8ipRAVkBcl6mrjbY4s3hFB0D4b+AI+eLU0TFhGEALUXX+hpac58aOYZoIEG+VyTRiNjXJF0X2v6FOtBvNHwEj0PWG7QR843xLxyJh+s0w5OrJSgDOmgcNtenlzexwDnoPR5nG3h7+/nj+uQwG2JxpxOTbN7+diEE6evTK4rpDGxfYtBL58AaN5GVcu95jrjfnI05k5stvu8Uv6Pf8glm1sq3kBQLNdE3S+FgoRgJWIH90261A1miZL4cV5EcJK8wZ/vzTRLqdEj0qeS10/FQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwO0nNUzQPcR5YxwcGK80oAIUwpvH6ASQ5GERkwgT5M=;
 b=BYCf2HKfdvFtTf+HXuU0VdOje8/bgP9a8glmXvGUxgonw2XjBcWrjgM33WQxbVMANnNgK/0mAuLbXPWL8uuLR9jCGVxyx4cQtYQCypiOkFYR2Pb1YL/Y2aXTi7120whZzpRPqpMnrAXzqNrjJuVAvDVEXaWhEn6VMnalKwRyj6hxOm6jZZ/lfYmdn+amoEJtEjH/Rh5DCyXYLU+Obrw8QJS9Dcubf6IXW3eN5j/RbIdnNuFI9XgHU77rW44XV2dIUXyf8NordMJsb1P6e9ZWSQK3y9t5cJ+uoOXpjQVo9WSqH8r/JNGpLp5szwJL/EwNDNFiWieUhFIr/639UxfRwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6125.namprd11.prod.outlook.com (2603:10b6:8:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Wed, 11 Jun
 2025 14:17:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 14:17:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAB+0YCAAAEdAIAAmbcAgAAI/wCAAMOrgA==
Date: Wed, 11 Jun 2025 14:17:28 +0000
Message-ID: <1676dd89cb71218195b52f3d8cf5982597120fc4.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <9421ffccdc40fb5a75921e758626354996abb8a9.camel@intel.com>
	 <d4285aa9adb60b774ca1491e2a0be573e6c82c07.camel@intel.com>
	 <e2e7f3d0-1077-44c6-8a1d-add4e1640d32@linux.intel.com>
	 <d53d6131-bf99-4bb0-8d25-00834864402d@intel.com>
In-Reply-To: <d53d6131-bf99-4bb0-8d25-00834864402d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6125:EE_
x-ms-office365-filtering-correlation-id: 8c1729aa-aa5e-435a-f533-08dda8f2b26b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cjNNOVY3ZGJoR0lzNU5TQmhPWDRXV3pQd2lGL3I0U2pDL2FLUWs1TURIVm41?=
 =?utf-8?B?ZkVvR0V6bitYbUZYZ0NNSUhoYldMREVod3JtcEsvSHM0Q2pkcTVSamlINkVp?=
 =?utf-8?B?UzU5Vk5GWTBVdnRRNVVsQ2d1MWU0b2MyblR6U3UrcjErb0lBVkRjS2NZMXUr?=
 =?utf-8?B?bHpNME5VQndHQTNIR2tEMWhxRXJVVlRJc3haSjhkRGN5bGltZ29PRVJxblAr?=
 =?utf-8?B?d3pRK1BlbGp1bVdEd1k0a0RXVW9FVG9lVUNLZEJVTEhuWlRheVNGR3pUWDA3?=
 =?utf-8?B?UzBRa1haWE1yU2o0Y2IwWEZPa3RPZy9QQm1INlhHejRnM29ZeWNVODBYN1FT?=
 =?utf-8?B?WXVKRUJiTW04M1AraVhnQTNDaWNvZDZNb1NsZHg2NllKOWVnYkNDNmVVZzFn?=
 =?utf-8?B?c0pMblNucC84c2lvT3F2TTVlTG5vR1AvN25MZFNJbm5haGJLWUcrRkJLdU9r?=
 =?utf-8?B?UjN3TmhTdWtFdURWWTdweVd4NW4xTER5bXRaZlFYenZxby8rZkdoSUt2VHdH?=
 =?utf-8?B?VVZRb01VTUhoZGxiK2FsZklaUzNyZThwK0J5TUdiRkpHd0tWOFppdkI3TUV4?=
 =?utf-8?B?ajhRaWp6UGZWcTh4RVlGRUsydG1hSSs1K1lCUlhUZzVGOGV2bEt6dDdhWjdG?=
 =?utf-8?B?ZDkwRmJIclhUUEZoOUdhTmlVanh1SDRHQXNvODBsSFlnOS93QUFtZnNxU3M2?=
 =?utf-8?B?ZzVzOFJxQ0FJWVBqM3V3ZGc3OU1ldy9CaVV2VnJ0d0p3L1dTMTY3ZXpsbE56?=
 =?utf-8?B?Nys1YUZ1WDNaL2J5aUFlZWZ1cUxySlVDaFFtd3pYYUJPdVFpQnIvb3Ira3Yw?=
 =?utf-8?B?dXRmdTVrejBIaUF6UjZYRVR0cHRYR0xEWkJ1OUFBR0g1RC8wdDlKMUFPa1ZC?=
 =?utf-8?B?enhuQnJFS2pSY2xqQ1NnY1FDUzU2d3RJRTNsYWxZdko0WHlYL0hSRSt4TFdZ?=
 =?utf-8?B?TkdkK1MxWS9JM1p1Z0JwTVpiTnA1eXpVb1NzKzU2TWN1ZXY1aVhIblU5MEtp?=
 =?utf-8?B?Rm0zQmlwbVBacThFbEdoUWV6dnk0cXM2b2JKa2ZEWFBTTkZiMUswR3RoY0ph?=
 =?utf-8?B?SnpkWG9sU2x2bWFHRjJyRmVydk5tSUZtbEFZUTlycURkVE5qZTg4bENYL3V6?=
 =?utf-8?B?NWdtMTg4LzZCNkIrM3JocGpBTDlPbjFqcnowYmJ2OW5yL3UrR3VuclVUM0Z1?=
 =?utf-8?B?Ni9wbDZkY2x0ZTdpdHBTUmRicnRGaWl6a3ZHZjBnRGtkZit5QVhOSHFLT09D?=
 =?utf-8?B?MEZTSEhpMnN1YS84ZUJIcHdQQ0w0SEJ6TG9mR0xYaVdCUFpUdE5lNzZ5UGts?=
 =?utf-8?B?MEVtMVdkMzN4bGIvc2VvanYvYXJoK2R0T1V2YnlCZE9nVFhBdFRWNDU4K0FJ?=
 =?utf-8?B?TC8xZnVEUEVxTDNrZlY4QWcvcEo2bGVKSEZDbi9JVUdTWjNOZjlKTE5ZSkZ5?=
 =?utf-8?B?dUhlVUNkR1VDekNwQlRUQVRqaHpsd1ZobTNLOFlYTVRMelE5aHEySTI1WitT?=
 =?utf-8?B?b05JZnNTYWtvdEtRM3VacURUbjRnTnZZUGU0K2ZQajZQNitrRmsvMXZHZ1BO?=
 =?utf-8?B?RzU5NGwwQ2hpMzJKYnRySElCbnN2dXd2UEdCclFsaVNVZzJ0RlBDekYyN1Bi?=
 =?utf-8?B?allpY3dadU5SK0JNQS94ZmxCL2NoYmlhNS9SVmwrcEdabXJUMWEreDhnTC9L?=
 =?utf-8?B?N0RsQmxhNnptdndQTmpyUUVKTkZMU1gxSmFYRU5aVTRFQXB4Vm8za0p2U1Ix?=
 =?utf-8?B?ZEV2RHVwWnRXN25iaGhuWUxMMEk1ZkZISVpRUk9SRWRqdVRGT1JmTmxYcGpE?=
 =?utf-8?B?a2R1Ni9adjdxTUIwaFJCeWptTnJEWDhaQkVzMS9ZcGtyUWFuaXVIcnY0SkRQ?=
 =?utf-8?B?d05YMnRDVWVNL2haNTJ6WUtRdU1iOVJzRHVSSFl4TnRlMVlaNTJKaEJ0TkJs?=
 =?utf-8?B?bmM0M3g5b2J3dDNxMUhtZWNBT1grd2RaVU5wKzlyL3RqSXZYNzB5ZlJQdUhY?=
 =?utf-8?Q?csbTBkJkWPYGW8jv4tW8/VFX55Dt6E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bU8vWVBGWGNqdjJSUXZXN0FhVmZCM0d2MUNPbGNMVGI3SWNQQjlEblBjT3BG?=
 =?utf-8?B?NHA0N0FzU2VLeUh0REU5c3lkelV6Z25PYzRaWThMWm85RFlOKzBsMHgwcnp0?=
 =?utf-8?B?eEEyT0xNQnA2eU9OZ1dpTG40QUlHYmdnUjQ5QzZwNDBRcVhYZ3RnTDlGaGxv?=
 =?utf-8?B?UG9SNzN2N0FURkxFYXM5cFNRK1NFd2xzcjAwR2dIcjZhUjExYllyTnpiUkx0?=
 =?utf-8?B?RzdzRTl6WFpiQ3hsZ2dqb2dNaG1sVG1EWmdXS2ZycVdlVlUzTGZyeXBMZ0V5?=
 =?utf-8?B?Zy8rOWVTUCtDVnZMZEcydGNhU3BDNGVJdWFmN1lvdmpGeFBmNC9DYkhrSHlW?=
 =?utf-8?B?QVlqNkkyc21FKzhKQnYyMDJUM052RGZtaXdmczQ0U1FGLytkazJKODZNb3la?=
 =?utf-8?B?SjhNU3Nka0pUcDNJTjFSUTFyN1BoWXRFakF0TDFKQ1ZJNHRwa1REeDc1ckFz?=
 =?utf-8?B?WkcxaE5rRWd1MHhxTkVMTHpDeDh5VXhCVmR3RmpQQW1wdEVaT3FyTjJCRFVa?=
 =?utf-8?B?dnlDclFwK2g0VVFtSlN2V1IvZTR2d1dKNVBPemtVMVR0c2xQOFJ2R0IyQVRJ?=
 =?utf-8?B?RXY0aXRaZ01pdnB6MXVOLy9CVkZ0dGNFZE12S1NhblRHV1BybG8zbEs5VHRT?=
 =?utf-8?B?VVdCTkx4cEtWNit0bjErdDJwRTVNbHVTUHJNaHN4SjBQL25qc2kxdU56c2hn?=
 =?utf-8?B?V3loeXE5WXNjZiszcmx3ak5xOS9Ld2t3N2NtdGlybFhZR1BNN0xUQUxza0Ny?=
 =?utf-8?B?bzBWWkdxVFN1QTA0SkpkYWpiQ1c0Ulh2b2lPTUJ3QkxYOTgwK1UzWkhPaDN1?=
 =?utf-8?B?dkRhT3M4OGF1bmhvZjh5bEVyMEdUb3RtMTh4L1FIZUpOL2xjWjhqOUo4Mkg3?=
 =?utf-8?B?VlMzWFNrVktSODhEaWxqTVhnQUhqTFBBOU9mS2x1L3lNa0ZxdzBwUTJkdktI?=
 =?utf-8?B?MVF0Nm1DekwwZXZ6VEppbWhyYUVEdE5jMTRrYVRDd1ZDYk9ERkppMVBCRDV2?=
 =?utf-8?B?ODlrUUFvUlpRRUFJc3pkeFJ6QXRyUGJnY0FCa2psczZGeUlhQWZVay81dVlY?=
 =?utf-8?B?T0hQYkJLMFMzVGcwSnk4cDBvWmpFeGROY1ZPNWovVWR5OUI1ZVpRNHBuTCtW?=
 =?utf-8?B?ZTBwd0lzS1Z0UDZXUmtRNFVRNk04VUtNMnFWdklsQ29WNTlBd0tPTFkxT1Jh?=
 =?utf-8?B?dlh4UEVJZVI1d1RNRURWbytqWHJ4QmV2MmFHL01Ld1l2Slc1c1U4czdYZmN0?=
 =?utf-8?B?Q1NzdS9kem8wSFdLQjFBVDNGVzZsTnFwNG1nZ0F5Mk05cU93aUVKeGh6RmVv?=
 =?utf-8?B?UC9yblRDN25uSTdlSjhpRGxpN1VXR3UzaS9PdVo4MG1BektsYVg5ZU1OWEg4?=
 =?utf-8?B?SGQ3SXA0emd5eDBUeFVHQ2llS0kycTdId3BzSXRUcWhTbmYwNFdBUkFNcjgw?=
 =?utf-8?B?MEZUTEg3b2JmenVvbFpyMFhQM3pqV1ZYbEYzNHNMRjVVdVBOMG8wL2o0Rnda?=
 =?utf-8?B?ditxTEIzdVBrbWVrZnJOWWdzdlZKOUZObDdaS1ZxYXJOdkZwdmx6L09tLzRF?=
 =?utf-8?B?SHYxdDVORVV2VkcxMUJDcEYzTi96SG9CcVpSeDVuaktoZlFOWWx0d2ZJWjdR?=
 =?utf-8?B?NUFLUDNxSDhsRnRWOXBKY3YvQXJwWWRoYlZ5eVFuT0oyYjBCVGJXUytmbDRY?=
 =?utf-8?B?WUcxNG1BREFKbFVKVDc5QXRncTBSTjM4UWI2eTJnY1l6Y0t2bEowdGxPV1NS?=
 =?utf-8?B?WElSb1MxcG1JSVhvcWVXT0NyQTUxSzY4cmF2RXlFOVpPVHZQME80U0dxOVRN?=
 =?utf-8?B?aTl1ZDhESStBQjNTRldsT2N4T3QvdHV2UXBFbUFkcFVhaXhpMEZ0TERXWC90?=
 =?utf-8?B?Nm8rVEx1Q054Vnlrbm9BU0czNWtsT2FwaW14bVUvWm54eUl5b2ExV0g3Rk5q?=
 =?utf-8?B?ZTZOMXdZV1dCMEw5VjhHWXNOK0xjM3RENmN1VGNZZ1VKZUFvQVdBaWNkT1Rq?=
 =?utf-8?B?eTh3ZWlUSVFqSmlvSUE3V2dsd3dnbEh6eExDTHp2R3QwZkJIRTFpUnFVYW5H?=
 =?utf-8?B?bngyK3VUeU9ZcVZjdi9JUmZSSlhMNjVkeEtLcVZiMHhVWW0xQnRCWitlWS9K?=
 =?utf-8?B?cElBSFkrUzdNa01xWGxSeHdCYXpjYW1QSndIWjRvUENucklUdG1OZVlLYnVm?=
 =?utf-8?B?U3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EC5776FB096BC469C18759C9EA6E955@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1729aa-aa5e-435a-f533-08dda8f2b26b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 14:17:28.5076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aKs/lL/HF9v39H0X6L2F/UJDv8S9+sWJMALE1riiGV7zzfNedQnnfdmlskFiLB0bTg8Ail62zdBGr3W4wXYozwDi+fsqHVeWEQwx0QHFj9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6125
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDEwOjM3ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IE1heWJlIHdlIGNhbiB1c2UgYSBURFggc3BlY2lmaWMgb3B0LWluIGludGVyZmFjZSBpbnN0ZWFk
IG9mIFREVk1DQUxMIA0KPiA+IHNwZWNpZmljDQo+ID4gaW50ZXJmYWNlLg0KPiA+IEJ1dCBub3Qg
c3VyZSB3ZSBzaG91bGQgYWRkIGl0IG5vdyBvciBsYXRlci4NCj4gDQo+IEZvciBzaW1wbGljaXR5
LCBJIHByZWZlciBzZXBhcmF0ZSBvcHQtaW4gaW50ZXJmYWNlcywgaXQgbWFrZXMgY29kZSBzaW1w
bGVyLg0KDQpXaGF0IGlzIHRoZSBwcm9ibGVtIHdpdGggdXNpbmcgdGhlIGV4aXN0aW5nIGV4aXQg
b3B0LWluIGludGVyZmFjZT8NCg==

