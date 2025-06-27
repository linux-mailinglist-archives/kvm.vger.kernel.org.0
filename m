Return-Path: <kvm+bounces-50930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 163F7AEAC1A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 03:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E66D61C42BBA
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 01:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A2E288A2;
	Fri, 27 Jun 2025 01:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJ/E2kQk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038862C18A;
	Fri, 27 Jun 2025 01:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750986041; cv=fail; b=R0YkNSGtS81p883ORy2OWbgiG40977DDkbI2VDjUq1hNRRiG1Nebj0x/3yxMBQYp6Lkd5Mv2KNF3/DY7mOajMbu9QRDUmAmkH+06+15zV5bk5VBX55OLC8StWdQ58nxW9X7LR6hMqbxWGgKz4nfHG2Q4OsdiHL6jhYFMr4cewNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750986041; c=relaxed/simple;
	bh=+6pssQ1+WPbAiaXVPyJGtEtWm0V8vbe+V4Rd1h+fYw4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S+e0U8aDYU4dXzNa+7SQghDN/CdQJE9zYeg0Z/DGnm2UDlaAfJrZNhHAYpGLH7rFbHoIs6HYNTmCV/60Q6f2+dJl50hLJfG13cKy+p37tNVpBvtueUJDNWckjjcFWQBRahr8cS9xsulu3/Cz0LhWIYwu07zuaP7FaPw6B3hZF5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJ/E2kQk; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750986040; x=1782522040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+6pssQ1+WPbAiaXVPyJGtEtWm0V8vbe+V4Rd1h+fYw4=;
  b=cJ/E2kQk/wGur3OCTD/88pB8fXgO9F2ByFUUr8olx9NtY9JVgwD1/Kf9
   WsSO2YRS4G0E3tdKeSQFRIH6tVUcfK/eJoqW0gHyNJ4vVCfiPwecXfjzj
   2LjI83IisOoghtCtRHi3TkzsQ8VHYguj4K+xYzr7miK6IVQknLiEWWNRH
   13ttVMuouHaAE80pzCQzF7ruKvrUZfE/dtSUKciccvsrgNB5z72Mb8sHz
   noIwqAG3HA/QZYdwOPSwB5KeDShMSijjduEX4gzJr5zaplTVrw2g6kNc0
   rHCR1IqkCCzQgmo5f17Dr4+h/DnTiYwG0NzkF8LaUbHjMKAiEXpfAWHyB
   Q==;
X-CSE-ConnectionGUID: 8yVXlyrZS5KaDvoHViQBgQ==
X-CSE-MsgGUID: 4b2EMEorSZiMlyV4zIL4QA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="64734835"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="64734835"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 18:00:40 -0700
X-CSE-ConnectionGUID: 5H3y61h0QcSfOiDBK+xCwg==
X-CSE-MsgGUID: lAQRXl6rSE+A34LmXGnpKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="157059003"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 18:00:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 18:00:38 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 18:00:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.61)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 18:00:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C0pPMUPTeYzoCpx+9Z8YxZlG8EZfAwGIPAAuc8pTrcRhBDW7JHYUpDHB/aAzAhvo0IyauvX0c53wD/0lPpGhfOna2J9xmrs+NydiL2I99Kjm2nRSSAvpOwsh/PJ7KF1hapPeuZL9leRWtRWxgwa1yaw4+wTnpOgj8zThk/FZuemaAt1fIXrEPT22kwT8uKo2JMe8Kj+CSI+6cpP9Wo1parJdQ0sdUN6iLpik+bd+6OCCG1DRrH/H+qQmTBDErZ9mGT/y66hpvqYFYZ8GRgNFNHk6Is+vOwGZpa2EZvOIGY+sSz4Xlv97BT0+XiCF5rRtB0Tyz85lRERamDLFwiezhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6pssQ1+WPbAiaXVPyJGtEtWm0V8vbe+V4Rd1h+fYw4=;
 b=V3FIxcWkFmPjjpV8wStRLVpQoKyYzZaU2TOboytb8kcWo2XOUN8SU1cX87pGJNKiXoHIeqtFKGML3fP0CM9Zm42dZcsijCygPWyaLzTjucd8kGwML1HwPElSttH/Jl0fkInep5A1gSZ4ffZhQZRPfQP7W5Af+LjLlYvjNoihLHg4VFhSv7V5cNRG++KjiXTvlH3KmXEa7KnNjn7bxLVRzmIDgkj/PoEZkW5SD+8onTVA6ksitx5kdQ/e6Th8vma5fmBeBaSubnCTR5p2kC4wqJtx1OusmaNHQ46+8h6I/jomN52gJBdgnUrld13AlkXplAipRRD3MGGLkeiSJdViLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW4PR11MB7128.namprd11.prod.outlook.com (2603:10b6:303:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Fri, 27 Jun
 2025 01:00:22 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 01:00:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "nik.borisov@suse.com" <nik.borisov@suse.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "sagis@google.com"
	<sagis@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Chen, Farrah" <farrah.chen@intel.com>
Subject: Re: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Topic: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Index: AQHb5ob2sxTequ6YNU2TEnElo1JBELQWIFEAgAAQUQA=
Date: Fri, 27 Jun 2025 01:00:21 +0000
Message-ID: <afaee18873e1830b366916df087585d261cbc433.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
		 <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
	 <f8ed9f899681e0aa9cc443c8c90a3a303655d0b8.camel@intel.com>
In-Reply-To: <f8ed9f899681e0aa9cc443c8c90a3a303655d0b8.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW4PR11MB7128:EE_
x-ms-office365-filtering-correlation-id: 89aa5f4d-1af6-4483-d71f-08ddb515fe1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YmpTNk5OMW5Hb2NHYmZNM0Z5bTlNek5zWEpNdmpIZEk0aHdna0dlaHlzelVY?=
 =?utf-8?B?ajBjbXpRdDVkQVY0MW44UkZBZEljNXBJaVAvN1QwWnFjYTVzQmF6TjFxeTJI?=
 =?utf-8?B?ZGF6NytLWjNEemtFTENSWFRIR3RWVmZxZCs4R0FpdXdyMHRjVDBOcUZwVnRn?=
 =?utf-8?B?ZUFGTFVJL05EMUFHY2x0VEs4b01OaFRhSVNRU2hYc2g4bEsyMXYxS3B2Rjda?=
 =?utf-8?B?TGRXYjNUSEpBZUJhVU0xRmpVOURJWUNPQzNGUG45a3Bmbzd4azFGZVQ0RzQ3?=
 =?utf-8?B?VDhxY0MrTng1VXlVSnhhcXhCbTNSaFBGc2NJSXdoYUNESm5zbmR5SWhKWDFG?=
 =?utf-8?B?T2YvdFEybHVVWm9XaE5JZnJlZUJPOG83WXR0T3JJRjZHTFlOdkd1aklHUysz?=
 =?utf-8?B?MzgxZ3MzeDRUajRncllSR3lyaGx3QXViaWVjZTAydktWUDlvWHFSaUdGZ011?=
 =?utf-8?B?UExSaGt6dmQyeWFqM1ExR2xKc1hoK3k5bDFRN0oxVEZFbUdhM25XaDJDTHVO?=
 =?utf-8?B?b0d0SUxMTnRjQjdmNGZLZ3d3OVEyRGVJbTY1Q01KN2F6SzV4QXNncDdPTUpZ?=
 =?utf-8?B?NW1mN1o3OHFhRlVrU1EydlE3WmI0RHZ2NTUxUGhZVHRPSkpJM0c3SzI5eUts?=
 =?utf-8?B?V1h6bW1ObHVMNXBsVCtQMzBHSUxxcDFsTVM0R2ptZENUek04QmZMcUMrTUF6?=
 =?utf-8?B?RUJxZlJDSjZoaWRkOWFFVWhDS2l5Z1dITW1MWTVqMjllY2dyVEhGK3VxT21w?=
 =?utf-8?B?V21GMFN2OFRlZVpseDRhM3JoY0Zob1Q5VUVHYVJFd3lCdUp5dmJlRi9oT1Y5?=
 =?utf-8?B?TnloQXAzUVNpc0I4U1ZiWkNqY0lJNFlYd0l1TjAwTVhQaFhsRGx0QnlrcFNz?=
 =?utf-8?B?aXJvdExiUnVDalo2a1ZzY0ZDcGZaOUtmRGFOcU9JWlZkRVZQa0hHWnFZTDQ1?=
 =?utf-8?B?T09PUXB6eFQ4NXkrNW5jcHNSdHRGczJVWVJXWGh3T0RFajhzbUhhN0FqQ1VI?=
 =?utf-8?B?TG0wbFlmMGZJejlPV28ycVhnUzU2THVEbldlV1B5VWpacXJSOUxpN0N0cW0y?=
 =?utf-8?B?ZTJQUWs3L3cyajZhWU9ucklPZUlkbXZLdURWRnV5ekl1Z2luV0VzWWRYc3VB?=
 =?utf-8?B?U2pjYWdKclhPMU1jbkpiOWdPelhuajNRWkR0WUNuY1Z5dTNISW5tRWN1b0Fa?=
 =?utf-8?B?QXNrRFVMNHUrOXNGYThla0N3eHRJRU5aRzV6eUpuQTI0Tk5YM0lzQmJYRDB1?=
 =?utf-8?B?bnovVVRHZjliNDNXVTM0V1ZaZFl0dHlJd01ydW9aSVFNZC8vUnFFNTVKb2ZO?=
 =?utf-8?B?S1JHaTFKQWpydGExUXJON2JZR0pjbFFSeG0zdmlFb0s2Q2l1ZzJOc08wZGNn?=
 =?utf-8?B?bDZYR0JxWjFxQ2hHOFpyWVpPbFg3NWpPamdyaXRSZkU5T3VyL1RyblFUallE?=
 =?utf-8?B?c2hva2ZyenZya1hPbmRkanNLc2FOQlIzYlJRdkFrUExVTW13c2U0NmVuWlR2?=
 =?utf-8?B?WHN0bE5uMUoyb3NMZHlvNWNZMG5OekdVb29vR1VORUptNkQ4TWpRZWJubk1y?=
 =?utf-8?B?d20vN3lGaUR6akUzeFErekVKWHU4VFpIVWpoNmUydDhXb1dkcVRsVGttMHhI?=
 =?utf-8?B?NmhCdXRuSmh3ZVR3LzBDZnRQZEVxdGZEbEpzRnc2dWdyQ05aVjY4ZE5kNUtV?=
 =?utf-8?B?ako2cVRyaW1nS3JaenFRWm15ZGkzckNhamJoWis3S096VGljQlU0Q2VPdXRa?=
 =?utf-8?B?aW1Ga2hkbk5YeXI1WUpEcVJWNmVpYmE1MXI3cXNqWkZEUnU5WTZDN0JIU3h0?=
 =?utf-8?B?UzJXMjlpaXdDNStoa1phSzBEZnM2WTdaTEl4aGhnRXNkb2w1NGVCSktTSXVB?=
 =?utf-8?B?elAxb3dYS3VUNzBJbU9LcnFnRjJrOXJGQnU0b3Q5ZGJ2SHVRZEk2bjVzUFdM?=
 =?utf-8?B?T0YxVG5GZEk4Rm5PNmVPMnNyNzhnZkd4c2p3ZVp3U2xENDZGSjJYenlSVmFu?=
 =?utf-8?Q?YA9owI3oghO87GMPYCCCnCwt3Jb1tg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlR4VnRtbU1kdkVwRS93SjVVNzRHay9TS2NPZXdYczJpeFVDU2ZQTWRiWFdy?=
 =?utf-8?B?ODhkTE1tODZXRTZTY2FBTDk4eC9pTThVTXU2Y2V4ZnRMWVFBT0dKdk5POWJ4?=
 =?utf-8?B?cnd0WGlhZm5veWs3M2d3QlZWZVcvcTZPZExwMzhPMWdiQ3ZKQ05sc3M5MlR4?=
 =?utf-8?B?SlM1Tk5oVmRTUCt3cGJzWEZxN1M2TUdDNWNiTGZoS2pPcnlhbVRvcmt3T1VK?=
 =?utf-8?B?Rm5YeVU2dlBKRFNQU0ZCM0ZQK1h4UHZ1aG5LN2h5TkRnSkwwZnY0bzB0SzNN?=
 =?utf-8?B?RFFNTzNvRG1JekFreExJejRXSkpUNDhnd1pTMC9ZOU5zN3g2a3pXa2hFSFVp?=
 =?utf-8?B?TzM0QWxtSWFOVkR6MUpYbUdJSjBHaGU4MHNJZXhTN2plcFRGYjhLMmRnSENq?=
 =?utf-8?B?NkorOVZmOWJVMmdBbEpQWTlRMElEb28yN3htNkpQOWgyenVJUFhvMnpTL01i?=
 =?utf-8?B?enh5Q2Q2VVVVOE81Q01IVnlERFNXVVlGeUIzaDlSU3VuOGJ1d1JrelBXeDNC?=
 =?utf-8?B?SlNIcXN6SXNRTVZpSVdwVFJMT3hrdTBlZ0Q1Y24rWURURU1zMGhReDdONlk5?=
 =?utf-8?B?WG1zSC94bFBlODcrL21YSjVoQjJNa2dCRW1Pb1VYbG0vTzhQWXV5LzdiTXBP?=
 =?utf-8?B?YUZmUXh6SmdOZm01OEEybXhrcERWaUVWWVc0RVZNcmx3R3hnM1U5WlozWjdk?=
 =?utf-8?B?UHhCV2dzQVU4NWVhSjBrMlBaaHpwODdLcEZ0R2k3QUx1Y1JCTDdGOS8waUlD?=
 =?utf-8?B?MVBkSGlIT2JpVE5Tb2RtS25yVzRKZDdUSWNaek5lTWNtM1ZKQSs2VXFXRTZx?=
 =?utf-8?B?NnEybW0zUVd6VU1uMUNHbFVSeWV5WTMyNjhVcjRZT1RKcTFaY3JsdWYwaWU1?=
 =?utf-8?B?NlNoSkZiWnZZbUN4NFdhdzBOako1SWRSYUpPWEZjNXhlbm5KRHAySlZ4SDBt?=
 =?utf-8?B?aWFMK1hxVjNBK2x0YzBiNFVTeUNjQld0NVlQbFRwY1pZZlJXMG9RbndDa1N3?=
 =?utf-8?B?MVlTbVV6WVlCVmdWV2xuV3l6MzIvUkVqR2RKNVIxRDdmaUYzNmN4QVR0dCtz?=
 =?utf-8?B?b2pOSWVUeVJVZGdPKzBHQUF3VzVselRlYUNtT090K0VsdDIxL3ZOaWthQWdr?=
 =?utf-8?B?eU82NTlhTzJySVJvQ1I2SlFwYVlWSldNUXkxWVNSc3E3a1d5TnhOeU5tUlFa?=
 =?utf-8?B?WUNPcmxzNXJNemtuYkFzei9MUFFBWWJUdE1KWnlqdXViQTAzVEFTNm9ROGV5?=
 =?utf-8?B?M1h6QXE5TUgxNkFNdjhMU1BjNnYwWmppTkU0UFJLek8wekJMd1kzUVc5dC93?=
 =?utf-8?B?dXRBTzdQTCs4Uk03UTFwdzdzczFacjBLNG42VWhKU2JBRG1mcVJqbEFoa3Vh?=
 =?utf-8?B?M3N3UVdyTSt5YUhld1hVUmNWVWNjZjMvdGx1U1p0c3o5bXQ1aitCQlV6TEN2?=
 =?utf-8?B?UzBsdS9IZ3FUQXZhNklQdjFGaHpXRTY0L1ZzZ1Q5UzBPeEZUVDBkNXJYbnN2?=
 =?utf-8?B?dVpIeTQ4NSthQnFuTzVJWUR6VXZobVZGdnlsNVkyQnIrR3BZUG5MRk1wcXd3?=
 =?utf-8?B?TUpMZkNaTjdYMG5FK2h3eUxpeTdXblhucGFIT1BNMEN0RTNFMG5DU2JuMjZL?=
 =?utf-8?B?OGxlZFdNVGlxa285dHdOT1BXM1lzTmhJRkx4SUZPWndLY0xqaWdaRzhxcWtT?=
 =?utf-8?B?TnpHdGxWTERLQjJWeGYxZVQ4b3JkZWlJMFZDcWJtYmMzSm1GU1dMcUJSOVlO?=
 =?utf-8?B?c2JGVG5ONjB3cnl2bWc4ZVhGOFZIVS84YU1rTDBVV0Q0UHVRaWxxVW5zbkNo?=
 =?utf-8?B?YTdDaDhJQU00VzJOMkxhTFFlU2kzaWUxOHd0OEZXMENIdlVGdnFVM0ZTR0Nt?=
 =?utf-8?B?Q2dKZm9JOUdwMzFvZW10V3ZaOGtLNlhBbkJEU09TRW1CamFKaDlzcEtTcTRm?=
 =?utf-8?B?dDFCUlJlOWxzTVZubTc3citiSUJzWURNOFZJMklldENuNTZPVDNGNWFGdnlV?=
 =?utf-8?B?TXBGZURaOFQvckxoalJWMlViZXB1RWtCM1FjbDllNS92RTlscGMxbHY5U1F2?=
 =?utf-8?B?UlNQRHlSUTNzTGgvNjJFcGFNUmVEL3lzaksvSUl6K25lMFp6OHVVRWV3RGZK?=
 =?utf-8?B?ZVZ5R3JmclJtNFlBeGxUSFozcmxrNVJxLzJhQ2RjTXpueit0b2o5YXNIMER2?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73F26D34C6855E4DA31A6BFB993C86B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89aa5f4d-1af6-4483-d71f-08ddb515fe1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 01:00:21.8527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 07sBUTXcWZXwVBk5O+jWk9fWXmpnTU1dm2x4fImI5kqzFR25IvWLpXfXCsNSetjPqrK92qMTUwC6wGYUjZHkgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7128
X-OriginatorOrg: intel.com

DQo+ID4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiArKysgYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+IEBAIC0yMjEsNiArMjIxLDggQEAgdTY0IHRkaF9tZW1f
cGFnZV9yZW1vdmUoc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIHU2NCBsZXZlbCwgdTY0ICpl
eHRfZXJyMSwgdTYNCj4gPiAgdTY0IHRkaF9waHltZW1fY2FjaGVfd2IoYm9vbCByZXN1bWUpOw0K
PiA+ICB1NjQgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF90ZHIoc3RydWN0IHRkeF90ZCAqdGQpOw0K
PiA+ICB1NjQgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lkKHU2NCBoa2lkLCBzdHJ1Y3QgcGFn
ZSAqcGFnZSk7DQo+ID4gKw0KPiANCj4gTml0OiBUaGVyZSBpcyBhIG5ldyBsaW5lIGhlcmUsIGJ1
dCBub3QgYmVsb3cuIEkgZ3Vlc3MgaXQncyBvay4NCg0KSSB3aWxsIHJlbW92ZS4NCg0KDQpbLi4u
XQ0KDQo+ID4gKwlpZiAoZW5hYmxlX3RkeCkNCj4gPiArCQkvKg0KPiA+ICsJCSAqIElnbm9yZSB0
aGUgcmV0dXJuIHZhbHVlLiAgQHRkeF9yZWJvb3RfbmIgaXMgdXNlZCB0byBmbHVzaA0KPiA+ICsJ
CSAqIGNhY2hlIGZvciBhbGwgQ1BVcyB1cG9uIHJlYm9vdGluZyB0byBhdm9pZCBoYXZpbmcgdG8g
ZG8NCj4gPiArCQkgKiBXQklOVkQgaW4ga2V4ZWMgd2hpbGUgdGhlIGtleGVjLWluZyBDUFUgc3Rv
cHMgYWxsIHJlbW90ZQ0KPiA+ICsJCSAqIENQVXMuICBGYWlsdXJlIHRvIHJlZ2lzdGVyIGlzbid0
IGZhdGFsLCBiZWNhdXNlIGlmIEtWTQ0KPiA+ICsJCSAqIGRvZXNuJ3QgZmx1c2ggY2FjaGUgZXhw
bGljaXRseSB1cG9uIHJlYm9vdGluZyB0aGUga2V4ZWMNCj4gPiArCQkgKiB3aWxsIGRvIGl0IGFu
eXdheS4NCj4gPiArCQkgKi8NCj4gPiArCQlyZWdpc3Rlcl9yZWJvb3Rfbm90aWZpZXIoJnRkeF9y
ZWJvb3RfbmIpOw0KPiA+ICsNCj4gDQo+IFRoZSBjb21tZW50IHNob3VsZCBiZSBpbnNpZGUgYSB7
fS4NCg0KV2lsbCBkby4NCg0KPiANCj4gPiAgCXJldHVybiByOw0KPiA+ICANCj4gPiAgc3VjY2Vz
c19kaXNhYmxlX3RkeDoNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3Rk
eC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gaW5kZXggYzdhOWEwODdjY2Fm
Li43MzQyNWU5YmVlMzkgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3Rk
eC5jDQo+ID4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gQEAgLTE4NzAs
MyArMTg3MCwxMiBAQCB1NjQgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lkKHU2NCBoa2lkLCBz
dHJ1Y3QgcGFnZSAqcGFnZSkNCj4gPiAgCXJldHVybiBzZWFtY2FsbChUREhfUEhZTUVNX1BBR0Vf
V0JJTlZELCAmYXJncyk7DQo+ID4gIH0NCj4gPiAgRVhQT1JUX1NZTUJPTF9HUEwodGRoX3BoeW1l
bV9wYWdlX3diaW52ZF9oa2lkKTsNCj4gPiArDQo+ID4gK3ZvaWQgdGR4X2NwdV9mbHVzaF9jYWNo
ZSh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlsb2NrZGVwX2Fzc2VydF9wcmVlbXB0aW9uX2Rpc2FibGVk
KCk7DQo+ID4gKw0KPiA+ICsJd2JpbnZkKCk7DQo+ID4gKwl0aGlzX2NwdV93cml0ZShjYWNoZV9z
dGF0ZV9pbmNvaGVyZW50LCBmYWxzZSk7DQo+ID4gK30NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwo
dGR4X2NwdV9mbHVzaF9jYWNoZSk7DQo+IA0KPiBEb2VzIHRoaXMgbmVlZCB0byBiZSBoZXJlPyBX
aHkgbm90IGluIEtWTT8NCg0KT3RoZXJ3aXNlIHRoZSAnY2FjaGVfc3RhdGVfaW5jb2hlcmVudCcg
dmFyaWFibGUgbmVlZHMgdG8gYmUgZXhwb3J0ZWQuICBJdCdzDQpnb29kIHRvIGhpZGUgdGhlIGRl
dGFpbHMgaW4gVERYIGNvcmUgY29kZSB0b28uDQo=

