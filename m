Return-Path: <kvm+bounces-52208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D40F3B026EF
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 00:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0EC1585DE2
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3C7221544;
	Fri, 11 Jul 2025 22:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fJrCI3gb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4D10A1E;
	Fri, 11 Jul 2025 22:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752273073; cv=fail; b=f3FnEEi4CkSeqGU0OKeBxfj7dHk/poCNZgqHKczBCNJWTn4Sn+NyiXz75KZmsrnW8YzZO2IdCoVzYel+uUmO6OvVHqaWbUvEvBCZcjZMau3yLkfktNPezwd1e+VnxK+3BkMp9Dh3eBLo2UliGJoB6o6Hgss8av7PdGS2Hc4+6uA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752273073; c=relaxed/simple;
	bh=1RzxZsqP3l4n44Xr51VgxpzOjip/4dY9tHyoAwoQW1U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d9nO9XpvvA12Ake9UmVB76yoP+D9riLTMyASVZ9KQ4cRE4CAb/OfAh5YikJZWDrjXtmOm/ZW7EfHlNgVkCMZo/KagaXBY3Si4eS/cZq12QjTc5RBY9nyL04arMJzgGjMgi1Pf4jLsnvWooZu2DlxyEQIlF2TkWCre0b8zhxsRbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fJrCI3gb; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752273072; x=1783809072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1RzxZsqP3l4n44Xr51VgxpzOjip/4dY9tHyoAwoQW1U=;
  b=fJrCI3gbeA57LLckxj2Ozs8Ra0wNWxn7esEp6G8pgt3JoCouM8Ml1wjD
   jvH9Pfl1r8tzasgbGEGpDHoZqRLMlbUR+ogndGgyAzS+n3+zyclKNCYxH
   F9GJdG3znRZJMnMANGqpR7tbs0xyfaPOHzeLwkNbJY2HHNUMn+wGLE5r8
   H4z652qedOLlAmJL+OMNx9peMLWw1vfvPOzbeGln+UcpG4bvhKp3xjl0q
   wEVJUm/C61w2p7MTix+ol1szy9AYpfVSXv/8UXfxP1TV93jOxdGNWAGXa
   w2ICqa60rFonzRrrKexHyJ1+1/HZ6FQ4Ti/ZsmlRiDtUaQUuLK3I5kM4J
   A==;
X-CSE-ConnectionGUID: DZEz5eMuSE2o5AEX10lQCg==
X-CSE-MsgGUID: m05BbuVRTe6kjMm23LmVgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72156906"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="72156906"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 15:31:11 -0700
X-CSE-ConnectionGUID: SMv+YWbiQQ6XlXCrgaeCZw==
X-CSE-MsgGUID: E+8kUbn4STK6RMGu1Ja41Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="162038922"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 15:31:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 15:31:03 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 15:31:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.84)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 15:31:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HyUSgJPsA3a5O9XDneDKOzsBwQEhgfybULwzD4qwjqXIOSn5Rq8Z84HTNvng6/Mt3dKiGC4J1udK+sIl5EEt9nSzKU7G+Zt7obzIHx4jOpgbX8Kd69T6YvrbLKHvYozCjvPzzjTEHegYFv9JoCSVjzOhc8YVl+AMeBUHPQojamOV8rI8RH5dCcshIagFgJt7ErCsEN9qkSxcLEtgKiRNbIHZBEsQRikNqzNyeXovnIRZgfgEqRGdq1hQl/MpXFfEmfZvqUvOBBIi6vIBjqCq2LNfv8XudujTbq0ABOgGh5nz9VMF31lNwRhZJ7z5CTTmSYd2ENzGi+ODeaJA/zOUBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1RzxZsqP3l4n44Xr51VgxpzOjip/4dY9tHyoAwoQW1U=;
 b=WSoBDK09GNpZ1iNojwIFWCI7xPHsZ7m0Nr3s8R1xTU6erouF0aauSPEvXJs4bikddQBvxhWpp81eGN6E3CZiL1Izh/eK0K398x1WR91GDz07XmiJUbeXRb4EB8vX7Sdful0OCmoIyJBw3cjXnmjW3jRY45vtn8kTRN2dp8slBACx7I6Ff4GcyO89ov87gYCUnt6jVHsS4CIZY0pBV1ZvSZ1UU4ka/lt7PoQkEFTHKKDy8dwRDPH9qBKzpw0G/xcLszcFtIMBbjK/tenBAq0CZI3zmLFgnMawtHsJUCdRbI17MuF2+HgBD0FYFz/JizJwvWh49kNR/gw9uP8HT1ZwSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7725.namprd11.prod.outlook.com (2603:10b6:208:3fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Fri, 11 Jul
 2025 22:31:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 22:31:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Thread-Topic: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
Thread-Index: AQHb2raNt52nCBW150es8dK7MAv5xrQUisKAgAEmNgCAFxzJAIAARa4AgAAJ4YCAAAr4gIAAiT8A
Date: Fri, 11 Jul 2025 22:31:01 +0000
Message-ID: <08cef2fec1426330d32ada6b2de662d8837f2fb1.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <175088949072.720373.4112758062004721516.b4-ty@google.com>
	 <aF1uNonhK1rQ8ViZ@google.com>
	 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
	 <aHEMBuVieGioMVaT@google.com>
	 <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
	 <aHEdg0jQp7xkOJp5@google.com>
In-Reply-To: <aHEdg0jQp7xkOJp5@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7725:EE_
x-ms-office365-filtering-correlation-id: 431abce8-b993-474b-81ad-08ddc0ca9dac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cm0zRkhUK1Z6NnJEbmUvZEJuS3ZPeUluNUpIN1VTVHQ5M091Znl5ZDhVbE1j?=
 =?utf-8?B?WEw0czlrTlMzVHUzZjlqMDFad0xZTVQ2Y0Q0SzhjbmZ4U3JCK0hHcDVac2dO?=
 =?utf-8?B?Yy9WamNBc3Ird1RYbnpiSGRKNFl1VGlLNklLdm41MVBvM1ljNFNpYnRGcUxW?=
 =?utf-8?B?SVd3Y3B6SFpxNVVDd3pBSDdwMGZteFlJOHNUUlpEcWdWSGZaQ2s2KzNZRHg4?=
 =?utf-8?B?dzNWS0xNTWdOT2VNWDRRSWFhc0RPRWRTTHVMSFQ0R3d0N0tLQTFZeGFGc0Zx?=
 =?utf-8?B?NEd4OVZOckU5NUxIRDA1T0d6WWhiVFdGYXk2aUVxMUlCQkFqcEQ5WThYeW9t?=
 =?utf-8?B?NmJGNXhVa2ZGUzErbUZDQS9Ba2s5RHpUbnp2Vy9oa3V6cXM3eW1DTXRQTit3?=
 =?utf-8?B?QmpyMUcwY0F5eUhmUHRyeW9zNU90SjRXTk83cmkwZ3NQM2VBQnpPT2lFdHI4?=
 =?utf-8?B?TXU1T3padEM1Y1RjQ0cyLzJSZ2lFTWpvYWJtTjhEc2NtNml2N2lFL3JFRWMv?=
 =?utf-8?B?VlM5aHA1N2VhU3dvaUxYNU9nOGRvV0cvVXV6dGdDVU1EYkJuVHI2U1BxdndK?=
 =?utf-8?B?clNhTHhpNEFpMk5iODFYa0l4QlBrSS96MDhRYjlVQXc5OExQYWw5VHM0eksr?=
 =?utf-8?B?M3dMRmhwZm14cHhPZWJkZmVwbHhBRmNrRVZXZEdocENDV0w4M3lZRUVpMzFv?=
 =?utf-8?B?NUFlTzFoZmtRM01wMDRkN1k5YXF3Y0ovRVFBMEJvdTdtM2pXaWtUZU1xVHdq?=
 =?utf-8?B?anA2dTJieFZGdmtvajJSWlpGS1l0WjFqREtlT2QzdUtqcksvWlRwT3dWMWFu?=
 =?utf-8?B?RDREZHYvWGxKVFZaMXJCazBFU0RtUmorNUFqKzNESXEvcWd0T2NpUzQxL3JU?=
 =?utf-8?B?OVExQWhTOXdmKzZRSDlMNGNOSFczdmdIWFZaNk1RT1JLWVhZYlliL3pvaVQ0?=
 =?utf-8?B?WXQyRTFNOUM5Y2xWcVlWa2tUcWNPdUZsWU91UithTmZVQjcvanR0VDZ2ZmpB?=
 =?utf-8?B?R29qdFc1dmFpQ3JGVHAxMDlIMlBSeXBJazM4WmZHSzJjYVc1ZnpNN1l0QnZ3?=
 =?utf-8?B?VGhPZFdhMmhxWS9QMCt2U3BidExuV3JlK0hJUU0yOWVyOUphbHZ6YVArNi9l?=
 =?utf-8?B?TGJSeldERlhZbHpJcHo4dUlYazA4K25FNWROU3BvdXlUaG9vWnlQN0kyQkkv?=
 =?utf-8?B?dEZadDljRytoaGtqNk02VXJQWWN2VjN4WDU4RHZUbHRxQmFvVnNldGE3U3Fj?=
 =?utf-8?B?T0UxMnhWS3ppM3U5VFQ5NitTaG96UG9nbjNTL09Rc040d0tPL054c0NSTWxD?=
 =?utf-8?B?VFBjYnI2NXdqdDY1eDhQRFNxWmt6V054NXF1djVRY2l4Y1BlVVIwWVZzY0VZ?=
 =?utf-8?B?UGdUS1VweFBrcngzbkpuNFFwOHRsUU10ZjJucTJZdys0VGZEVlIyTmVsL3Z6?=
 =?utf-8?B?YjhHU0Z5WlFxSUV4U2h2VHM1WnVsWVJlOUxQMithUUVzQjlFN3BTdkFjOHhS?=
 =?utf-8?B?cGlVS01NSVMvNDV6aDZOOUxNZDdRK0NMeWphZEdiaFl0T3BObG9UeEljUDZp?=
 =?utf-8?B?VVJOeVV5SkFFWjIrdE82VGxBWFBSQURKanZVbDkwWktkSW95R09YK0N6M2dv?=
 =?utf-8?B?dTlQTDArbE1OMjRFc3NhS2JyU1BJQ2FSNFdBcFRnUmZkK1BrYVdLWms5V3lS?=
 =?utf-8?B?WlZaYm4wT2hBTTdrazNzNmg2R0xVNSsrSldYa0V6UFdXZC9DZEhieHA0WHBx?=
 =?utf-8?B?Tnd6OXRQRWdmWU1Qc1IwQW1ETWtrTng2MDdKdnM1T3VMMlZ2aVNUQUNUUG9M?=
 =?utf-8?B?WElaNVUzei9lbm0yWHVqREErY3FZcTRnNlBCazY2anFGZEhKVlRMK0xDaEVr?=
 =?utf-8?B?QzhSYWJRZTQxOVJaakV6UXhLaS8wdDIyejRMUFRrQXkzOVBWczBXa1BWdGtX?=
 =?utf-8?B?aGlCYXBCRnhUdlVLQnQvTEFObS9zL3JmTnJENVQ5VFVZd1p4K0FzVnhQTG9O?=
 =?utf-8?B?YXJxVXVNdlZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDh3YVpKUW93cnF1RC9ocC9mN0t6NzdoMVB4QXJnRTlYdVRuQ1UvUzhtalZi?=
 =?utf-8?B?Y3dyN3FkQW5xeGVHcWlrank1clVpaUtiS29WS2pIdnQ2Wk1Qd3gyc1J5QXFa?=
 =?utf-8?B?UXVjMHkvYnBaMC8xT0d3VDJWSENBaTYvYUNyZityc2xnSXRFTGV1Rjg1WHhi?=
 =?utf-8?B?akpzaU8vWXo4MCt2cERBN1R3WDI1b0tyU2NzdlhFSkFMakJoRzFiMUErN29D?=
 =?utf-8?B?OUhmSlpyeUpRTnlCcGEzR0VaUUJkeGJibVNsb0ljbzUvZ2I2ZFFYVGx0Tm02?=
 =?utf-8?B?Y0lQOEcvR3NzazFqYmg0RFN1S0Fva0ROQ1RYZWIwSCtIbHpCbnhiYVFaSng4?=
 =?utf-8?B?elpXYnh0czFSYTM2NXF1OG14Q200YXhiS1V6YlZjMzMyV3JOb3orbWtucHAr?=
 =?utf-8?B?SXZuSW1MdDdDSXdKcGYvVVpzRTF5d0k3aFl4d0RFRW1wU2FCMlBjc3hkMW81?=
 =?utf-8?B?cmxaSGpSWjN3SGlYRUNHV3VHbDhOZERDaENaaFdBMy9vbGE5RzFnaFBlYVpn?=
 =?utf-8?B?MFIvSVRtVWlEVXNkbHE3bHU2a2RjbDNpanBMSk1jZ2VQb3FHSVE0T01Na3U4?=
 =?utf-8?B?ZTZZMExxRWxCV25kdVpBRERIYzljSU53SVhsRmxjK2dZQUpxcElpc1o4d3da?=
 =?utf-8?B?cWlGRkdIa3FaYnlyU3VaWHVLMnV4a1ZxK0p3RFhCRGlKVzBndXZqdXQwM2Fv?=
 =?utf-8?B?SERnUEw5SkpBVm9ITzR6cGdxOUlzS0sxNEV6eHBBZTF6MCt5Z3k0SERtNHBR?=
 =?utf-8?B?RHFOVm0zQitKSitVZWVxVjZmR1FSZ1RzQ1IyZ3N3TERrVEllanI4YXNmTVJw?=
 =?utf-8?B?WmtMZ0d4OFhZbHJnRHR4R0JuK3p3cVQrVGZudFNtWnY1MU5xVjlINHMyTHp6?=
 =?utf-8?B?MERPOVl1am92OWhNOXhzTkMzSnIvcG95YVdHUVNidlVoWm9qeStaZGRsWmV1?=
 =?utf-8?B?dTRScWJGOTVkUFlOcG1CcnEvQ2lGWWpzcGUwWU5kRHI2QStRVUpDcGpDZUkr?=
 =?utf-8?B?SVZxYkN5OUpLZlpUUVVsd2dWcmIyeDE3Q1pTRVZPR3lkWSs1R0dOd0MvWjg2?=
 =?utf-8?B?aWI5b1FRRXVKTTdjYUdjVlZ0Y0pFbWxrRTB2SURKc0hueU9NL29pekV1RTBR?=
 =?utf-8?B?SE1HSUVWOThOVm03SUFrR2hPbHFqcEJWM1JjZUpNejZHVzFLWU5TRDMwdyth?=
 =?utf-8?B?dGIrTE5pWkFHa2U3dEpLYm0yb2NFNmNwdjZ2cFFEUU5PMEUwcFFXQXJQdWlL?=
 =?utf-8?B?eE1PTlc4V25ObTBIQkNwZHBnaGxwdEsrUVJvdU1tY1JPeHhhVFhzbE9LeGg1?=
 =?utf-8?B?MWpuS0hJUTF4aXJYYVNod3lkOVpqVXlnVnM4UHh3WENkdHVDWDZwVXQ0NlEy?=
 =?utf-8?B?aGtIUWRTMk1XNWNhOWV2N3BlbUFSdncwOWF2NmttaDVvNlhMZjNrQ1ByYk5C?=
 =?utf-8?B?MThxazE3bnFSQWlJQU9leGtlcko4ekdhMW1WYTZBZkZwVCtHNE1ENHUyN0V3?=
 =?utf-8?B?R3d5bTcvN1ZWOFRUbjB5ZDI0NmJTS1NLU1c1aW9SVmdFWmFXT1BrV0E4K3p4?=
 =?utf-8?B?SUpJQmRtbzVTY2M3MmZZaG55N082aFkxUjdmRFdFV2x6V21NR3F6UXpWaGY1?=
 =?utf-8?B?MkhZbGdlVnhjdVQ1dnJlOFhZSGNLazRNdDNQYUZJY2xvdUk1bHYzUm9CRnBQ?=
 =?utf-8?B?RGJGM3RJdVBGQWJTdm53d3diaXBRTnNiRHpJWXduQWlVWGJvRmJielNjSnF2?=
 =?utf-8?B?V0tLSWExb0pjUlQ1K3ZJZjg1VTk0TFhLcjFSS0dvbHVNUFZSbm95SEdFRlBl?=
 =?utf-8?B?V0U5cGVuRmFsQ1VGc3ZyM3paSGt5cW5kRXI0RlNsQUhJN3JuT2xPdVllL1VG?=
 =?utf-8?B?SElnOUQyNWxYR1NyRGpVYXJ0SG1sRk8rdkdkd2NUdG43eW9MZWtFajhSdDU3?=
 =?utf-8?B?RStJdHdUNnZJYlBQZVd4VHRNeEN2K2lsUWdYV0UreFIvdkxHN3Q2RHpuREJR?=
 =?utf-8?B?Z2ErZW40bUgvTzNCbWl4aGJRR01MTURkbWNYVTJsZGoyWWlIZ091T0p0QlBz?=
 =?utf-8?B?VHNxV2Nobys5WjJ2ZUxNOUVzSEVBcldOemtpeEVnMHJsYklRYUpjanNPQk54?=
 =?utf-8?B?SjRHcVFlTko3cXIzZFI3UW9FazUwVzdtNmVxeDRNenBzSHh0NWV5MmZDa0Rk?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <110F9C4946E36B45940E3ECDD60C33A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 431abce8-b993-474b-81ad-08ddc0ca9dac
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 22:31:01.7566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GKpnGlSsSvrmrlXxArgEkN5j0fgl2ArakevhUyGR4Eckujdbm2b4qO623LTgWqQdqdb4+bLSF/T++mjsskAofPp5hwjn0kP1LMys+wIvPOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7725
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDA3OjE5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gQnVnZ2VyLCB5b3UncmUgcmlnaHQuwqAgSXQncyBzaXR0aW5nIGF0IHRoZSB0
b3Agb2YgJ2t2bS14ODYgdm14Jywgc28gaXQNCj4gPiA+IHNob3VsZCBiZQ0KPiA+ID4gZWFzeSBl
bm91Z2ggdG8gdGFjayBvbiBhIGNhcGFiaWxpdHkuDQo+ID4gPiANCj4gPiA+IFRoaXM/DQo+ID4g
DQo+ID4gSSdtIHdvbmRlcmluZyBpZiB3ZSBuZWVkIGEgVERYIGNlbnRyYWxpemVkIGVudW1lcmF0
aW9uIGludGVyZmFjZSwgZS5nLiwgbmV3DQo+ID4gZmllbGQgaW4gc3RydWN0IGt2bV90ZHhfY2Fw
YWJpbGl0aWVzLiBJIGJlbGlldmUgdGhlcmUgd2lsbCBiZSBtb3JlIGFuZCBtb3JlDQo+ID4gVERY
IG5ldyBmZWF0dXJlcywgYW5kIGFzc2lnbmluZyBlYWNoIGEgS1ZNX0NBUCBzZWVtcyB3YXN0ZWZ1
bC4NCj4gDQo+IE9oLCB5ZWFoLCB0aGF0J3MgYSBtdWNoIGJldHRlciBpZGVhLsKgIEluIGFkZGl0
aW9uIHRvIG5vdCBwb2xsdXRpbmcgS1ZNX0NBUCwNCg0KSG93IGRvIHlvdSBndXlzIHNlZSBpdCBh
cyB3YXN0ZWZ1bD8gVGhlIGhpZ2hlc3QgY2FwIGlzIGN1cnJlbnRseSAyNDIuIEZvciAzMiBiaXQN
CktWTSB0aGF0IGxlYXZlcyAyMTQ3NDgzNDA1IGNhcHMuIElmIHdlIGNyZWF0ZSBhbiBpbnRlcmZh
Y2Ugd2UgZ3JvdyBzb21lIGNvZGUgYW5kDQpkb2NzLCBhbmQgZ2V0IDY0IGFkZGl0aW9uYWwgb25l
cyBmb3IgVERYIG9ubHkuDQoNClRoZSBsZXNzIGludGVyZmFjZXMgdGhlIGJldHRlciBJIHNheSwg
c28gS1ZNX0NBUF9URFhfVEVSTUlOQVRFX1ZNIHNlZW1zIGJldHRlci4NClhpYW95YW8sIGlzIHRo
aXMgc29tZXRoaW5nIFFFTVUgbmVlZHM/IE9yIG1vcmUgb2YgYSBjb21wbGV0ZW5lc3Mga2luZCBv
ZiB0aGluZz8NCg==

