Return-Path: <kvm+bounces-49785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3519AADE021
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 02:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 086C43A94F5
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 00:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6909A81720;
	Wed, 18 Jun 2025 00:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H27QfVd0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BCD2AD14;
	Wed, 18 Jun 2025 00:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750207308; cv=fail; b=Mz1KjSsJmpOCkDiE4TBWOvHitpy2EsYPBUvWXAA0ZdlIZ7taWqn/lR66E92/QYDrH7zd4o4H3qHr2K48QQugAiaSFfNvI6tHShT5DWYPAdqWR/CWO9468zVAUUwK9paVHKFuo0hBlj94jOGoO9RrAn8/J/lXo04g2vly5rjOLJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750207308; c=relaxed/simple;
	bh=1Un7bwpeb/AP6Iq4rtQi1B80hQe/sPMDksGStrmR3YA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pLenUSSFkvD0yULQJTkaYwAy3Xq06SYHcP5UVnPkJun8FWaqlb6WbgCDjmMhTMU2YKacPKUI2eQnRY2ARCwy5Dgu08wwdGOqfrgaO0dVRbo+bAQCbDTMhocJs+rziHSskrNhPLZjzz5ldwDbE5mxPUILHUm6HiFjATxY/th6MJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H27QfVd0; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750207307; x=1781743307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1Un7bwpeb/AP6Iq4rtQi1B80hQe/sPMDksGStrmR3YA=;
  b=H27QfVd0MIrYdq7D7ctj9TnWxs6r0iHaEN/jVu7cVQrxT/Nv5i+mTCt4
   wyz9fawwJm3hPxKnWFqCTko10LvnZAniQXq2yTD8211o3fTd8uu4tPArH
   Sx8VAw1kaeuXUEbhbbgpKc5I533UW5iJK529H4X9DyMR3xf81PX+B4s9L
   M/pzQNH1al3QDdWlQokEjUr9ZqyGTIYiA4bTUSidKFwhR1twn99B8OKHo
   UUGX0nPL1d6uMhmQb8ZeYTZrDzEFh+kTGtUXmDxYLnkuoPUtTsTgF4IuV
   4cT/y4Yk7dYZlOtFhwn9RB+vOZYoXcBcc6FuRtIUUSGXEX2hdAZyFDqu0
   w==;
X-CSE-ConnectionGUID: tFbzMZ+FT+Wk9atlMP+CQQ==
X-CSE-MsgGUID: d2jrYqJjTVixdIQsyVA28w==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52497913"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="52497913"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:41:46 -0700
X-CSE-ConnectionGUID: /5yNvuIdTNOPir4zhRSB4Q==
X-CSE-MsgGUID: albojfEeQx+wTyi4o9G2XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="153932033"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 17:41:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:41:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 17:41:45 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.61) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 17:41:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpycqA/0uWPySSMWJkiKY35hoAF4Aryfqm1HAax8GA0/OAfZn5Ci5L7ozVty7ebTZPF0SvUsLhQOf/OK/F+c8bF0qCltON/rE+2DyuvrFUONh/JKLZOaWr+DKfyT9f313IyIPc59VQnFi3PwlGVbCCCDLnbTfYWnaKnW2uZ62pFvy7H+X2HwqbvHyYa+TVQrOkx5xeXgFUzhxP79G8AgWpvjTaHLizeDSOFGDTTkFrxCCpLETvp2Pk8coaqbuX97E+EsNTcLBxGaYWzYekoz+H3L3eHtlzLK/1yLNWubIYcI5Dvb2fQ6VBNafG/siYGR44VAUq1clmyw8NFTCIAoIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Un7bwpeb/AP6Iq4rtQi1B80hQe/sPMDksGStrmR3YA=;
 b=mWnXyuRrG5HS2mZpERpE0vdM/LaJSZc32nuHzhr6HgyR1RTVSqRTIhlKQEVG1HWESe2XucN55hKbCwJnYHBPuWj6YHDhe/7RhRBxBhR7YUVMqszWtzjogA/jT1Qe3PsT4fGoynC+OwKtamDhwqBsSGb3IoIvlXitM3IjEhTBfYL/nP/pk+hdOxxqN2ZOH9cJZZmp/W6xzikF/EPNPQ/4FaJy7BGOBWUWRTWtfWVqnsYwQJpIN/GNVR3TxcjfDlDVhyHCpbf6MT8GtId/StvZqnYVGidZ9e3JMIARMdsQ6RevvPE09+zAZaQfLAsY/M0wl0WDCHrPNWPP2r1QOpuJMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA3PR11MB9349.namprd11.prod.outlook.com (2603:10b6:208:571::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Wed, 18 Jun
 2025 00:41:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Wed, 18 Jun 2025
 00:41:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoA=
Date: Wed, 18 Jun 2025 00:41:38 +0000
Message-ID: <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
	 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
	 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
	 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA3PR11MB9349:EE_
x-ms-office365-filtering-correlation-id: 85170f33-fb46-4fb7-ab25-08ddae00e2c4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YnZRRUVSN1lMMng3SGFaekVhVzhlaWpRYU5sSEF3VE9ydmlVMWpDVHJFeEtp?=
 =?utf-8?B?am5iSTBQdXpEM2IwbXk0TVo1SXNQU2NKdi8zdHRGVERWNE1lOStoYkpJVVd6?=
 =?utf-8?B?cGlpeTJ2ZW45bU9LWlFUVFNPUUlrU0xVeG5weXJLdU40cUZBNC9tNXkvVjBC?=
 =?utf-8?B?N1dJM3JkRTBSbVFpYUFqMnFpVFFLTUoxTE9vQjRaRzFSa2k2SDJIOUUxdFlF?=
 =?utf-8?B?YjRTZzFCd0tpSTFDU2cwM1Y5eGl0K0ZWSVRDOWNOSkQ3dnlEUEtFbWZJVUxo?=
 =?utf-8?B?TnFucmUrQlRzbzkvOGF6Z0diTkc3dlhaYlNpTGlUY0gyTFVLVlVJSzZmbGsv?=
 =?utf-8?B?Skg0alVUd0paZlRCaWZFNC9Cb1Y5eWREeTdmQ3JtSFBqNXBMZkM0ZDBTQmhr?=
 =?utf-8?B?SGhhS3J0aXJ4Z2x1aVhiYWpseitkU2JWdVhlclFkZlYwMkdMRC9SaXAxdDV4?=
 =?utf-8?B?REM1WngrV0VQeGJEaEN2dGljQkhDMm8ySUNHaFZOa1hQeEFvMVB1TzRQTUhu?=
 =?utf-8?B?RmUzS3FoL2FQSHpTZHY3QmxFY0gvb0R1UVhEdGpWdm9vL3dFNXRoWFpINDRP?=
 =?utf-8?B?V0tQdjlyMTNyZ1FCZGx3K1ZXUktRcllCekhJZlUwdzcwN2lEaHQvZlN3VDM1?=
 =?utf-8?B?blg3WUprRWhSR1ArMGRTNkhnY0Q5eEJEaFp3TGllYzJIQ0I4UnpvUWlEbWVm?=
 =?utf-8?B?cGpQak1PcUxmR3I1OWtwTVQwNTFhWkxkV3JxN1hHOGZSSFh4Z3A0dHFWelNz?=
 =?utf-8?B?c0lGRHR1cWhnYS9zQ0FWWUFXU1o2K0o3SlMrMTMwdmpHNDNydUZjMUlrbkJ3?=
 =?utf-8?B?YUdieWNQbTBobWx0U2JSRS9WVXM3cW1nUlJLWGRWR3lyaytOZWdoM2dJcXpV?=
 =?utf-8?B?MkU0NGZINWNOSXJLcDRJZ2VrNWRIRzBxRC9vMXJiS0oxZ1pEWDFxVmJVSzZN?=
 =?utf-8?B?SHJLenA0bThGRnIrbHdORXFpZ3BYOXZNd1dVbEhtU0hSa1BWeHBySG0zRFVW?=
 =?utf-8?B?Y09RVmprS2RDT0RTYWVvUVBUMU1VOTN3cFlySit0V2lTQmpramRGcVl4OXp3?=
 =?utf-8?B?ZmRHOWpFWjFQaVF5REhzQSs3UkduWjUzZ2pKODQyU3Q5UFMwNEJoQXF6dGM3?=
 =?utf-8?B?bEZlMUtoNk41RkpQVFdDTUFqUjFkWUxwaU9nZHpMcmdrRWVJNzdmOXIrYTJB?=
 =?utf-8?B?czdjR293UitiQVBWUis1QjJTU2VyekpHRnNFbURHR0xRMSt5TTJYMFVtSnRp?=
 =?utf-8?B?Y1B2MUtZK1g0ZXdJUUo5TWdPSU1pYUE5N3JremNvazVJdjQvUXBUWTdLVXRx?=
 =?utf-8?B?WkNCRHdiMTA1ZWliSVh6eGJBd3FpS3JxSi85SG5lQlEwVUFQYWhhd1hwRm1l?=
 =?utf-8?B?TjhDNVQrQ3hJWXk4OXJ0NjcwdnV4RUZxNGFYR3NrVXJWc3Bzb21lZnM1amVz?=
 =?utf-8?B?NGIrY2lZMmxhb2pQdmhHb3ROSjBEVWVycGJjV1BYMHFKWjdZNTB0WDZ6VkV4?=
 =?utf-8?B?SXE1RGVEMnREanA5MWIvaVlVVXIrZ3ExOVVzMjFLZURNWlhtQzdNTXlpS1ov?=
 =?utf-8?B?aUxnZ3BoRHoyWjlTQ3djbkNJL2lCcDVjbnVZNTRyTDFGVDdVTm1xQmtwdUpO?=
 =?utf-8?B?UVVqSkRlREE5V2xjbFZHNVJaK3N1R2JQaTJFR1VTV3ltZnFNc2xRMVBOY08y?=
 =?utf-8?B?WS9EcVNBbndZdVB0bFdhajhjaGtFRnRsdjVhLzJjcjl1djRiZ3FvSzVXaXdt?=
 =?utf-8?B?aWRkM202YTRqdzZQSVRCU3BEV1BSdjFFNlFFV3R5dEpRQUlKQ2hiNW5oR3No?=
 =?utf-8?B?ZFgxbGhNaGZqZzlDbzVpWkR1clllWHgvYzViSDBoemgyeFpHTHVkc1FyNTgr?=
 =?utf-8?B?UjJwdXhyK054emRTcGg1ekpHbWxmWFVaN29XZXBEcUdRZmtlb09NWWlDbVVu?=
 =?utf-8?Q?yJ/quYm1u1g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TU1ZNEtHOXp4dThJY2psQkhQajcwTG8vazdGSDFOWlZiNXVZOFd4NktkYmw0?=
 =?utf-8?B?YzkyNEhZam9BZnU5ekQrNE1UbnRZeFhkVStkWFo1aVNldzVRYkhRRUk1UVdL?=
 =?utf-8?B?T1NWeUpOS3B1ZVVUYkFOUjRnN0tvWU53SDdvcmRHQzNwWUwxL2tvakZhVWho?=
 =?utf-8?B?aTZCODA5VExQQnNJVlI4S2dKRjF5WUJIZTBWK2F1Snl2OXlQYkk4V0ZoLzBQ?=
 =?utf-8?B?TzFBSGhDUldrZWNUR2MvSytBQzd2ckhTWDRWMEJrWSsvZGYza2dPTVVEUS9D?=
 =?utf-8?B?TGZsbWlSNkZPQTBqRkdUNG1wMXVXMVhlSExrd0szNzJFTG4zakJJNjByNGFw?=
 =?utf-8?B?U3pFeVJ5VVZKMHUzSXR5QS9mNEtsekZaYnJsSEJTL1NLaWF2NEFIamxRbk9F?=
 =?utf-8?B?VDFWNEhBU09BOE9pOVk3V1N5bXFWQXJyd0hBSE5CVWpPWDM2QTJpSkFNRVky?=
 =?utf-8?B?Vml6UWV6UzBBYXY3VWpBbjR2ekdyRXplR2FoV0tXY0NKc3FVYlNCa3R2a01X?=
 =?utf-8?B?bE10TkJsWTY4Z2N3RjcwVVhxaCtvcjlEdWhxYnV6RnVvT2xwWGNlWDFYVmxT?=
 =?utf-8?B?b1JiWnRzNU9CZ1hFQncvY1MwTHBYWUh2NHJGSEU1SjVhTEI5cWZ0T0MxeSsz?=
 =?utf-8?B?MFJPeS9tbURxUm1ZK0Zna3BHa0tyZ1NCRllrTzF2enM3OGxVQzRhektDaHZQ?=
 =?utf-8?B?MXJ4L0J3UHRyL0ZRNHdINlVWZHc3WVRFYk5Zcm1FWlY1OGhqRHpKSWdCUllr?=
 =?utf-8?B?UUFPV0FncWViTkk1R2FPNzdJcmx4MUNjSnlPZm5TZFJHRURHTnkwSWQ3dFZO?=
 =?utf-8?B?Sy9vbGtkdVp2ZmFuMnArLzhrVUt5MEN6Z1dWVTF2amgyZUtEcDRQVGhEVEhi?=
 =?utf-8?B?TXhIYUovV3IzaVBCMFZlWEhEZytzMnM0OVh6Y0RaRFJLMURpb0hkWTFXZklS?=
 =?utf-8?B?Rjh4bXpnb0I0TkZxam5udkZBQ21nQjJiTGtuM0lVY3BMc1ptWklGK0ZkdHBQ?=
 =?utf-8?B?Z1NhcVQ2eHJNMHc5ay9QeE5EYXFxS1lUeHBqRTFucFVWR0xUcVR3RlhiaU1R?=
 =?utf-8?B?NDNIb1lEK1EwbTFvMlRQMGFkdG1YeGZxV1REejQzVlZFaitKcXZZbFJRWHFh?=
 =?utf-8?B?NWRkMUJHRXFNc2lZQVZGekl5aVVqZUNSRytXS0dsd3dZd21ESU9tZlNKOHIr?=
 =?utf-8?B?ajk0aWlrd1ZvdHVGZyt3cGtmRTh2ZFRBVjVUVklJNE81UVB6MWdQaEhCUkt0?=
 =?utf-8?B?Skd6aTllQ0JXM05NT0VRQkE5NHpxRUl1TDVteDk2LzY5R0grYXdmSXRKWHR0?=
 =?utf-8?B?Sko0V0RiTzE1N0xVRzBUVEFvQW1ZRnZLN2NtQXJGdDhCRVN4YndUYklic01N?=
 =?utf-8?B?T00xNVJGbVlhU2FBK0Q4d011R1piZWZGVkpwM0ZYNmJGL3VSaUhZZlhwcDNE?=
 =?utf-8?B?WU9xbERmTVFKQlBtak5MYVdIR213UnlhK05hV1pQeFRQbVRtenZ1U2tyUzVF?=
 =?utf-8?B?OU9NK2wzbitQYkY0VjFpMSsrTkphY21VYm5xQnl2U1U4OE94ckFQQ0xEZ2sx?=
 =?utf-8?B?MFNRWjJZU0RJYnRNVUw0NnRrTVVaOHAvN1hyWkQ5cUNTMzZxQkhMU205TW8v?=
 =?utf-8?B?OXdiT2JlK3B5cTYvQzQ0REdvTkdqK2VIcE1xN3JxYkZUS0xadFVYZ25zN1o0?=
 =?utf-8?B?VE04djZ1aE1YdS9US0Z1T0ZocVlRSEpKeHZ2SDhodUs1RFJVSDhWSEZnZEl2?=
 =?utf-8?B?YVVsY2hrWE5nc1lXOVIyQzVEd2VpVFg2RzgvL2hKK1czWEc0UXMwSG9UcXZF?=
 =?utf-8?B?ak8rZUdtdForSERabzVtN21HbjJ0cWtMWUx5V0dyeWs1c29iSlI2ZUFZbW1k?=
 =?utf-8?B?YmlEcEJKTDdsR3BjdzNNMEV1dG9WMFNCWjRtVEdjbkpWWXdtU2J2T1ROczV3?=
 =?utf-8?B?OGl5UURBTjExeXRqMDg3c1hydjFFOGVFYVR6QWpTSERiTEhtL1h1UkJIMUNF?=
 =?utf-8?B?a3p0QnZ5ZUlLZ01kdW9hdm9jR24rdHNuN3N4SEZxMGJBdzhqaHhrRUJyZkNI?=
 =?utf-8?B?cExmNDNBc0FoU0VHQm1FOWlCcTAzNER0RTdMUFF6UEtRd09yK0hNT0svMGlv?=
 =?utf-8?B?RFl5WlpDRHVKS1JHSStZcTBYcmdXVUdhMEtaeFFKUkg1VDVaN2JqYzVIUW5U?=
 =?utf-8?B?TWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0AB450E7E6ECD4D8D208A5F0BD91C00@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85170f33-fb46-4fb7-ab25-08ddae00e2c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 00:41:38.4012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ElXGwJ0qhaQO1BejcV5ZQmXUgjzHMf5tJfjmNyJ+VX+GXJjc14zIqg65J9ihw4H2TJylua45bDZ2+vRFutKLejVcIHPwwKHFEmEVYunCOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9349
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTE4IGF0IDA4OjE5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBJ
IGRvbid0IHRoaW5rIGEgcG90ZW50aWFsIGJ1ZyBpbiBLVk0gaXMgYSBnb29kIGVub3VnaCByZWFz
b24uIElmIHdlIGFyZQ0KPiA+IGNvbmNlcm5lZCBjYW4gd2UgdGhpbmsgYWJvdXQgYSB3YXJuaW5n
IGluc3RlYWQ/DQo+ID4gDQo+ID4gV2UgaGFkIHRhbGtlZCBlbmhhbmNpbmcga2FzYW4gdG8ga25v
dyB3aGVuIGEgcGFnZSBpcyBtYXBwZWQgaW50byBTLUVQVCBpbg0KPiA+IHRoZQ0KPiA+IHBhc3Qu
IFNvIHJhdGhlciB0aGFuIGRlc2lnbiBhcm91bmQgcG90ZW50aWFsIGJ1Z3Mgd2UgY291bGQgZm9j
dXMgb24gaGF2aW5nIGENCj4gPiBzaW1wbGVyIGltcGxlbWVudGF0aW9uIHdpdGggdGhlIGluZnJh
c3RydWN0dXJlIHRvIGNhdGNoIGFuZCBmaXggdGhlIGJ1Z3MuDQo+IEhvd2V2ZXIsIGlmIGZhaWxp
bmcgdG8gcmVtb3ZlIGEgZ3Vlc3QgcHJpdmF0ZSBwYWdlIHdvdWxkIG9ubHkgY2F1c2UgbWVtb3J5
DQo+IGxlYWssDQo+IGl0J3MgZmluZS4gDQo+IElmIFREWCBkb2VzIG5vdCBob2xkIGFueSByZWZj
b3VudCwgZ3Vlc3RfbWVtZmQgaGFzIHRvIGtub3cgdGhhdCB3aGljaCBwcml2YXRlDQo+IHBhZ2Ug
aXMgc3RpbGwgbWFwcGVkLiBPdGhlcndpc2UsIHRoZSBwYWdlIG1heSBiZSByZS1hc3NpZ25lZCB0
byBvdGhlciBrZXJuZWwNCj4gY29tcG9uZW50cyB3aGlsZSBpdCBtYXkgc3RpbGwgYmUgbWFwcGVk
IGluIHRoZSBTLUVQVC4NCg0KS0FTQU4gZGV0ZWN0cyB1c2UtYWZ0ZXItZnJlZSdzIGxpa2UgdGhh
dC4gSG93ZXZlciwgdGhlIFREWCBtb2R1bGUgY29kZSBpcyBub3QNCmluc3RydW1lbnRlZC4gSXQg
d29uJ3QgY2hlY2sgYWdhaW5zdCB0aGUgS0FTQU4gc3RhdGUgZm9yIGl0J3MgYWNjZXNzZXMuDQoN
CkkgaGFkIGEgYnJpZWYgY2hhdCBhYm91dCB0aGlzIHdpdGggRGF2ZSBhbmQgS2lyaWxsLiBBIGNv
dXBsZSBpZGVhcyB3ZXJlDQpkaXNjdXNzZWQuIE9uZSB3YXMgdG8gdXNlIHBhZ2VfZXh0IHRvIGtl
ZXAgYSBmbGFnIHRoYXQgc2F5cyB0aGUgcGFnZSBpcyBpbi11c2UNCmJ5IHRoZSBURFggbW9kdWxl
LiBUaGVyZSB3YXMgYWxzbyBzb21lIGRpc2N1c3Npb24gb2YgdXNpbmcgYSBub3JtYWwgcGFnZSBm
bGFnLA0KYW5kIHRoYXQgdGhlIHJlc2VydmVkIHBhZ2UgZmxhZyBtaWdodCBwcmV2ZW50IHNvbWUg
b2YgdGhlIE1NIG9wZXJhdGlvbnMgdGhhdA0Kd291bGQgYmUgbmVlZGVkIG9uIGd1ZXN0bWVtZmQg
cGFnZXMuIEkgZGlkbid0IHNlZSB0aGUgcHJvYmxlbSB3aGVuIEkgbG9va2VkLg0KDQpGb3IgdGhl
IHNvbHV0aW9uLCBiYXNpY2FsbHkgdGhlIFNFQU1DQUxMIHdyYXBwZXJzIHNldCBhIGZsYWcgd2hl
biB0aGV5IGhhbmQgYQ0KcGFnZSB0byB0aGUgVERYIG1vZHVsZSwgYW5kIGNsZWFyIGl0IHdoZW4g
dGhleSBzdWNjZXNzZnVsbHkgcmVjbGFpbSBpdCB2aWENCnRkaF9tZW1fcGFnZV9yZW1vdmUoKSBv
ciB0ZGhfcGh5bWVtX3BhZ2VfcmVjbGFpbSgpLiBUaGVuIGlmIHRoZSBwYWdlIG1ha2VzIGl0DQpi
YWNrIHRvIHRoZSBwYWdlIGFsbG9jYXRvciwgYSB3YXJuaW5nIGlzIGdlbmVyYXRlZC4NCg0KQWxz
byBpdCB3YXMgbWVudGlvbmVkIHRoYXQgU0dYIGRpZCBoYXZlIGEgc2ltaWxhciBpc3N1ZSB0byB3
aGF0IGlzIGJlaW5nIHdvcnJpZWQNCmFib3V0IGhlcmU6DQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9saW51eC1zZ3gvYUNZZXkxVzZpN2kzeVBMTEBnbWFpbC5jb20vVC8jbTg2YzhjNGNmMGU2Yjlh
NjUzYmYwNzA5YTIyYmIzNjAwMzRhMjRkOTUNCg0KPiANCj4gDQo+ID4gPiANCj4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiBUaGlzIHdvdWxkIGFsbG93IGd1ZXN0X21lbWZkIHRvIG1haW50YWluIGFuIGlu
dGVybmFsIHJlZmVyZW5jZSBjb3VudA0KPiA+ID4gPiA+IGZvcg0KPiA+ID4gPiA+IGVhY2gNCj4g
PiA+ID4gPiBwcml2YXRlIEdGTi4gVERYIHdvdWxkIGNhbGwgZ3Vlc3RfbWVtZmRfYWRkX3BhZ2Vf
cmVmX2NvdW50KCkgZm9yDQo+ID4gPiA+ID4gbWFwcGluZw0KPiA+ID4gPiA+IGFuZA0KPiA+ID4g
PiA+IGd1ZXN0X21lbWZkX2RlY19wYWdlX3JlZl9jb3VudCgpIGFmdGVyIGEgc3VjY2Vzc2Z1bCB1
bm1hcHBpbmcuIEJlZm9yZQ0KPiA+ID4gPiA+IHRydW5jYXRpbmcNCj4gPiA+ID4gPiBhIHByaXZh
dGUgcGFnZSBmcm9tIHRoZSBmaWxlbWFwLCBndWVzdF9tZW1mZCBjb3VsZCBpbmNyZWFzZSB0aGUg
cmVhbA0KPiA+ID4gPiA+IGZvbGlvDQo+ID4gPiA+ID4gcmVmZXJlbmNlIGNvdW50IGJhc2VkIG9u
IGl0cyBpbnRlcm5hbCByZWZlcmVuY2UgY291bnQgZm9yIHRoZSBwcml2YXRlDQo+ID4gPiA+ID4g
R0ZOLg0KPiA+ID4gPiANCj4gPiA+ID4gV2hhdCBkb2VzIHRoaXMgZ2V0IHVzIGV4YWN0bHk/IFRo
aXMgaXMgdGhlIGFyZ3VtZW50IHRvIGhhdmUgbGVzcyBlcnJvcg0KPiA+ID4gPiBwcm9uZQ0KPiA+
ID4gPiBjb2RlIHRoYXQgY2FuIHN1cnZpdmUgZm9yZ2V0dGluZyB0byByZWZjb3VudCBvbiBlcnJv
cj8gSSBkb24ndCBzZWUgdGhhdA0KPiA+ID4gPiBpdA0KPiA+ID4gPiBpcyBhbg0KPiA+ID4gPiBl
c3BlY2lhbGx5IHNwZWNpYWwgY2FzZS4NCj4gPiA+IFllcywgZm9yIGEgbGVzcyBlcnJvciBwcm9u
ZSBjb2RlLg0KPiA+ID4gDQo+ID4gPiBJZiB0aGlzIGFwcHJvYWNoIGlzIGNvbnNpZGVyZWQgdG9v
IGNvbXBsZXggZm9yIGFuIGluaXRpYWwgaW1wbGVtZW50YXRpb24sDQo+ID4gPiB1c2luZw0KPiA+
ID4gdGR4X2hvbGRfcGFnZV9vbl9lcnJvcigpIGlzIGFsc28gYSB2aWFibGUgb3B0aW9uLg0KPiA+
IA0KPiA+IEknbSBzYXlpbmcgSSBkb24ndCB0aGluayBpdCdzIG5vdCBhIGdvb2QgZW5vdWdoIHJl
YXNvbi4gV2h5IGlzIGl0IGRpZmZlcmVudA0KPiA+IHRoZW4NCj4gPiBvdGhlciB1c2UtYWZ0ZXIg
ZnJlZSBidWdzPyBJIGZlZWwgbGlrZSBJJ20gbWlzc2luZyBzb21ldGhpbmcuDQo+IEJ5IHRkeF9o
b2xkX3BhZ2Vfb25fZXJyb3IoKSwgaXQgY291bGQgYmUgaW1wbGVtZW1lbnRlZCBhcyBvbiByZW1v
dmFsIGZhaWx1cmUsDQo+IGludm9rZSBhIGd1ZXN0X21lbWZkIGludGVyZmFjZSB0byBsZXQgZ3Vl
c3RfbWVtZmQga25vdyBleGFjdCByYW5nZXMgc3RpbGwNCj4gYmVpbmcNCj4gdW5kZXIgdXNlIGJ5
IHRoZSBURFggbW9kdWxlIGR1ZSB0byB1bm1hcHBpbmcgZmFpbHVyZXMuDQo+IERvIHlvdSB0aGlu
ayBpdCdzIG9rPw0KDQpFaXRoZXIgd2F5IGlzIG9rIHRvIG1lLiBJdCBzZWVtcyBsaWtlIHdlIGhh
dmUgdGhyZWUgb2sgc29sdXRpb25zLiBCdXQgdGhlIHRvbmUNCm9mIHRoZSB0aHJlYWQgaXMgdGhh
dCB3ZSBhcmUgc29sdmluZyBzb21lIGRlZXAgcHJvYmxlbS4gTWF5YmUgSSdtIG1pc3NpbmcNCnNv
bWV0aGluZy4NCg==

