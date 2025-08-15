Return-Path: <kvm+bounces-54816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68B70B28897
	for <lists+kvm@lfdr.de>; Sat, 16 Aug 2025 00:57:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5DE43A35FF
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 22:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC562877D8;
	Fri, 15 Aug 2025 22:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UnUkxXJH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A261126AA88;
	Fri, 15 Aug 2025 22:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755298625; cv=fail; b=COt6CPoyupjLfhEMQHlVRw9ffDBju8eroMy12duRu6MeDK6svr4wiQ1mLtpqHJ/Je/f58pxPuI6a9ti7SV87udYH2naNR5xlHkMhGS9DjbVOePSS5870jqx+lJGdnRZMIJdmW7cZPnlqJ3CSeS8g+xFLAl62iBIkQoa6nlVOPOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755298625; c=relaxed/simple;
	bh=mplx3OhKkFiIh/3kO212SHvFNI6jue1ZtRiFzyD/oak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Oleg0HANapEGaiC/0tziRpsgzi/bRgrbKKaDpOFrzV+jOhYMWXnk6lxBCBIxNJm4WO+EO8zYAEXi5TwGYy4OfP3U4zkPEcU1JnLH4cwvBbXaUH5gNHmhVftY2B/0bqpwFwt+/n3Ylh5imRyHFZ+6dURRM9/OONX7RykLvtWGAp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UnUkxXJH; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755298623; x=1786834623;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mplx3OhKkFiIh/3kO212SHvFNI6jue1ZtRiFzyD/oak=;
  b=UnUkxXJHxbCTxjG2Gxrp2oYEkOUqyaugK2trOP93ySBdDorEaXVcy1Oj
   +/2PZpwLATRATrqOB737POr88GA758tXKf33Ju6CnUAgUfrt/AZ4ZvlWp
   UcskCJMbggwyOYRfwf4MHwZghYmiQKXH7tkXjUE+fnjWS0Ls+Qy9RB4Va
   dMOhBfBF0gdtdm2K8GQVXNVeobzJzw2/5fPE3dMoptMW11oEcp5OgjpxV
   M1bwx7nK2afp65C673SDj7ErswSHnAsDRvIJO0HiT57d+/l4x6RWkU9LE
   G0Hwt6emFRGLHdXp6ALQ8CVZ3jdv35lNsY1AVWDdyEW0xRMPcU6Kbqk1W
   g==;
X-CSE-ConnectionGUID: 3XpldCJMRXennmbmiBhMOw==
X-CSE-MsgGUID: PWhB28gsSYSYAqkj3zpCQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="57531299"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57531299"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 15:57:03 -0700
X-CSE-ConnectionGUID: UQnBfLyzR8WfdJytRIVYcg==
X-CSE-MsgGUID: pNf2/HgpSEWz480sEqNQcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="172326188"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 15:57:03 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 15:57:02 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 15:57:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.42) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 15:57:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyA04aSWnbF3lzwhefFuOkcB7j4/6+2xU4dkXTugnnx6kMNRqeoO2smWYTg6HKBPvULx5SMcqvNpcshJuua/vZZm/EQ9LKr7XoAq3gltTgZLoqNYjKF6ZgGl8Cth58EEFpRlNGD+fXEBN5EIWHx09dt4RwcxHzp8KWQ2yprjHzVFZbAbHutdm8+CTtCPHjg6TyDonw2UZY118Npon7B1MmLdeVFiht9Te+Nhlh+dnBKsX/jjCHg/W+Qlaqr3WlWmRgBMp6Hod5Q+0CVH64YNYeU0j0Wt32jaDZo9tm3bVWZqd2RgU1ph1AkTBEfvv1ZvzhjoE9e2glFa1MnNzmSa5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mplx3OhKkFiIh/3kO212SHvFNI6jue1ZtRiFzyD/oak=;
 b=HzYehwvyjLZ6ebaHC4GLjr6//Gc1PxSMFtG0oMn9nd4CfwH8TfH5mmGUNAR5BVru7p2E++GzNDvTiSsyRJIGwtuvwBvdm0nlLrQ/SJtRmcGGT3TAR11eLHniL7ibmK4DwJWxhSOwI2xkcIRCu/kgJ9PwklmBzqIyNqJGlPI1EsSu36x6yg3dgnXXM0WsZ2nHEa1Hvew3rFkBjE5+2ITQdh2VDep/KK/BRRs54yXJldnQ3mmis/QW3gVM6SaFDoWFXG1kvtenGpgevF0UCJC2fHSsqKrb1Mc53a3ZLzSwh/jcJcyo3o7JID3nsSBy2zLAI4SkaynpEr/cZCWjerPeHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5312.namprd11.prod.outlook.com (2603:10b6:5:393::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Fri, 15 Aug
 2025 22:57:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 22:57:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "xin@zytor.com" <xin@zytor.com>
Subject: Re: [PATCH v12 00/24] Enable CET Virtualization
Thread-Topic: [PATCH v12 00/24] Enable CET Virtualization
Thread-Index: AQHcCzS3+MwpQEh6T0GXLR4X4IuqRbRkWWaA
Date: Fri, 15 Aug 2025 22:57:00 +0000
Message-ID: <a988d316494fef4b26e86b9ad9d86f48c70c08d8.camel@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5312:EE_
x-ms-office365-filtering-correlation-id: 550952a9-01bf-467f-c4d1-08dddc4f0b26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bXNYWFJyRVhZSkwzdlIrNk1OT3lEYS9XR3hONEFKSjFuZlVYN2MyUjd4Wkpk?=
 =?utf-8?B?dzVXRVhsU1MwY0M5ZGtoYmdjTkZNUjNaaDBWVDE0SHdST0FyRFNoclJSaHo1?=
 =?utf-8?B?M1NEM2k5bE8rT1k1OXVPQXZITkQwcFdrbmdBNU1iS1FaOFBKbjZHamx2NHFa?=
 =?utf-8?B?Y2U0SzRQZkZ1MDNEclB6amdSb3lwdmMrckF3MjJnc0RaQmo2TnQzTGE3Tkg3?=
 =?utf-8?B?RldRRDRCMDYzNk1mMnExZGsyREhZR204ZDRBbWhnWGdpTFg3dGxRcEhQMytX?=
 =?utf-8?B?ZjlNdW1PdnZ4azA5Wm5pWHZyejFCemZuSUQ5NEk3aUxkUnJWT2dnVFdWUndW?=
 =?utf-8?B?Z0dKY1d3Z1NzLzVoT09IaHd1Wi9hOHdHSjNSRUpCVjNqQ1daYXJHVncwYXBj?=
 =?utf-8?B?SUQzTFBkcmVYN1dmUUI3N2hZZ3JFNUhiVHhpSGJmMTNxbm1OL0hkb3FMeUxX?=
 =?utf-8?B?VVFZU212N2FwMVQwNllkRVRLVk51ZVpLcnA0L2REKzBqV09OaUNUK05ZdXBl?=
 =?utf-8?B?NW1kQ1h1OHJjby9pVmZJbFJqci93MGt1RHc1THltdTBDRjFIQ2RSUU4xcEho?=
 =?utf-8?B?L0w2WGtudjRkMW9acHYwVFdvWWpGTTJSVnVKeXdaWGpUN2pnaWlGek4vQTJG?=
 =?utf-8?B?dE84NGhzMVlsUll6OXRtTVVXdEJja3JOdHJKdnRwZkJWTjlBK0t6bjRoWFNr?=
 =?utf-8?B?ZS83UWNnc1grZ1N6RDB2T3BPdUJDbmU0bG8yWFVQUGJWdGVzQXVBZDVaSlBn?=
 =?utf-8?B?QTUxa2tueGRDOWgvTmZsRitza2VCQ2JLT2E0VFI4ZjVCV2pOWjd5cnVoemVI?=
 =?utf-8?B?eklrQjlqa2RuSDJ5MnVQczNJK1VRMXVqcWYvc2tYM08rM05OUmRFbGVCVDB2?=
 =?utf-8?B?ZUJNOHpnY3hjY21JOTc0VW15cDBlUmhqR20yaC9RYkJaczJTQ1RjRXV4Mjky?=
 =?utf-8?B?dGtFUGRmZnVZSmo0cEI2ZFZnaFV3TlpZWUhoZTJQVXlGcG0zNmpZcDBZQjdI?=
 =?utf-8?B?cjhhVXhMZ3JEbGVXUjJvTW5OZDc5VStEWGpTSVhBOCs0Q1loendwTkxtbkNr?=
 =?utf-8?B?UjlRT3VTaXFlb20zZFlOWTJXbmc2bWZSQzlObVZZQVFoTFdsQWVOeXVibDY2?=
 =?utf-8?B?OXhYaEJzRkpOazhqZVQ3TUxDbmdyRHVqZjk4Wi9wMmNVYUZwODRQS0RWSVZP?=
 =?utf-8?B?cEwwYVdRVWc3a2lPSDNPWUhwZEltSTBLQ2Q1MnRaMlVqQ3pySkduQ3U4UHZt?=
 =?utf-8?B?SEx6aXFlL1RPL0tyczFSL0xmZnpZZHZSd3FqajR1dk5PdHRhZ3pqNHJHUEQw?=
 =?utf-8?B?NWN4aStrNEV4d0UxQnhGMTJtZVBGS0QvcGN3RmNZdHI2TGhRNE5tdGZSUFI4?=
 =?utf-8?B?RlhrOW1CbnZQSDV6QTloMHFYcHNibHovWTBxczRsRVhMM0Y0UG1PS2lYekVk?=
 =?utf-8?B?UFNXZGhnMWZXaVNvUXpOdGRkdys0STdXWkhmbkVwQTVSR0prSngvWXFBa2FW?=
 =?utf-8?B?OXl4czRrK1ZGTC9mQ0Z6SWp4M2k2blJtdEJiWmZkMkEzOVN1S1hweXBjaGxl?=
 =?utf-8?B?MGF5VGhYL3hWbmQ2TXBVOEFGRHNrYUkwMS9qVlhIbWVNSENlbEpJM1ZGR1hi?=
 =?utf-8?B?Y2JRWlYzOG41dC9ycndQMmFjTkV2MG5MVDdhUWhzYVRPbE1hYVhxVGJkNXdy?=
 =?utf-8?B?aHlTK3p4UVR5UlFDQTlsWVgxSXcwM0RIT2pRWjdaaExEN2JNeTNmVDNLdUhz?=
 =?utf-8?B?Z2U1NzBIbjljSEV5amlFZ05oNmdRV3h5a2JxNExqWEE5SC8wMitjVzE2QytO?=
 =?utf-8?B?aFUvUWdtMnJ5dFAwS29vQlFSNDg4eTQ2SVkyZEpRVCtuMWpISWhIZWI3Nisy?=
 =?utf-8?B?ZnVjUm14U2NMenhhMG45cVRibURRZVRnNVJCWDFqeXZ4T1doWWFSTGM2aVpy?=
 =?utf-8?B?R09IVG1MZ2txR3VNRWhUVkxsdFpSWWd3Q0JHd2dhMXVOVUdiaXJhSVFhWUhr?=
 =?utf-8?Q?FqLZzrwUHPYPDAxw5a4eMoL2TAfRe8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TERsQVJTODJhV3Z4OW40dXpnUGgzbnpHNy9qSzFUVDhwQzZOa1VZTTE3MFVY?=
 =?utf-8?B?NzBzSDRuZ05LUSthdElralBNT0ZSazRLOUtWMTNuWlZCWUhobXdSMjlJS3BZ?=
 =?utf-8?B?ZVRKTWdOd3RVZFp4ZGl0NHVOWlNPdDJVUGFqN3pDQVJHbktpa29rR3NTT3FJ?=
 =?utf-8?B?T0xHd0ZvVzRjdVMvZERRejZpUFU1cmI1QkVMMTBPdnNhcE1GaHMvTVJDVGxR?=
 =?utf-8?B?Y2RBc09iUlpEWEQwcHNZQ2Ztbk5KbjVrbEJUYnRmcjAxTkdzVUt6MVNTZHRq?=
 =?utf-8?B?ZUppOUlwRFlad3NJNDlkak83QUlzTkpMd1o4Sjh5YXBSb054RTlkV2ZpajFK?=
 =?utf-8?B?TXErd1FpZC82dXMzVUdzM0RIOE9xelFyeUFVNnpBVG5QZ0JkRWM2ODlkT2p1?=
 =?utf-8?B?Nm4rYlJGdjV0RGhXZFphTGsvUHpzZnorV3haL1R3NWZSVFlqQTJRWFQ2Y2Ns?=
 =?utf-8?B?ajF5NUp0VXRsRU9uMXhMT2lLN2Y5VXI3b25kRkJHOTRIK1pGeXRnaXFuLzFE?=
 =?utf-8?B?OWszZzU1Zi80QUVmTlorODdqeWNZQ05pbS9KcXF4VkFkMnlITUx3MkcvTVEw?=
 =?utf-8?B?WW5MUUl0a0grZlUrMU5KYlh2bzJneGZKd084QVJXa21sZHU4cWRkOXZBU0Qy?=
 =?utf-8?B?WTk1Y0E0dVBvTitzTVZLUms5SDBSS01sN2VCMjNTNjBFWE5lOUxTSFpmeXdN?=
 =?utf-8?B?T0RHUm1halZZRTBraWRQWTgzNDhvcEVXSmdRL0Z3NzNFazhvRENZSWxPaFk5?=
 =?utf-8?B?aTIxbzRwOUxVUVgxZHFXbUZSZk9pdjJjbFdjODZwd3NkcWNqbXNHeVg4UnJY?=
 =?utf-8?B?MUovV05IY2dzbDduVzhYRXVIL3Nydkg5QTlnbmRxcFZ0SDc5ZHBJTVQ3OGVU?=
 =?utf-8?B?U0ZweHRlQ3U3a1pNQndNME1ycm1KbFpqWDV1Y3UydUlSMHRUb3dBR1g2ZGhX?=
 =?utf-8?B?UW91ZmszNEtCdzZPR1VMa1N3NlVIdUlZS0E0OEFnRTFhS2ZvYVJ6WHZ4bG9y?=
 =?utf-8?B?OVRPSHVEZGMzU0ZLcTdvaGVOTkxGY1poWURHc2gvaWwxdTBrb2MxTHlhcnd4?=
 =?utf-8?B?ZXFVY2c1WUhOYXRVNERtYUViYnE4OWRMK2l3NVBWT01lbjVlaHNjWjZWck80?=
 =?utf-8?B?NlFiOGY0c0pTNWNtdEZ5TnVGRVY2MExhRHh6VzFEc3JHRi80QlZiQXZoRUFS?=
 =?utf-8?B?RXM3SlJHZ0hjZktrd0UwaHI3LzNmSHN4d3ljMElQVGV6TXlBc2N6c2RKUlB0?=
 =?utf-8?B?dmVNdzlIRFRWaHJ0QlhnayswVStKVnkwUGlvU1B2RUQyMi9IVzFlSytZVm9W?=
 =?utf-8?B?RkxSdC9NZTluU2s3T0xFbTNqUFhiRzdwNG8ySzdtS0tLbnJ4djlxT0FZSDND?=
 =?utf-8?B?ODNIa3lDWE9xcWcwS0wvZGZtRnVwSE9FZFRnbXNJK0d1bUFuVUtlNUQ5RU5H?=
 =?utf-8?B?QmMzSFBGRVF4WENXVzZKOWpDaDRhb0o0WVcvWGFCczBOOFdva1FQNjhxU0hE?=
 =?utf-8?B?eWcrK1hwTE9wVGU0VVV1WEx2RGllb3N4ZFRiK25hanZuMHVWVXByTVh6TURW?=
 =?utf-8?B?N25IZW9WMmR1b0dLNi96ZHpxVDhFR1FxN2pvK0h6U3o0UjBzUU04eUdOSGJa?=
 =?utf-8?B?cmpENEk2M2JseFI5ZCtoT2xMSWlPanVmQW5XVnVjeGh0dVpEMmRpQUp2eVdr?=
 =?utf-8?B?THNRbVVQdGtsakdxQ0g2WWxYQys1OHBDSjJWbmJuaUR0cUpLOTFZUFVpbXZD?=
 =?utf-8?B?YkhVWm41c0tMdk04NkdjbWhmRTRFc2ZzM216M3hkMU9iWC9uVEhVeHcrd0tR?=
 =?utf-8?B?SXJaK3RKR0l2RFIzNVZJZVY0MUliOXhDTlo0Y2lydXJmcGZyVTYybnVzR2xL?=
 =?utf-8?B?WFd6b084eU1LMGk2TmdGaXp1UHNrZHRsekRsVS9TOFdEOXlsMnlMTGgrUS9Y?=
 =?utf-8?B?RFlOK1Ayd3pNTnd0MUdpQXZMcDVMY0tDT0hLalFBS0trLy8wTzVhRWJSeTNo?=
 =?utf-8?B?S3plMWZ4bFM2WmVRbWxERUxMd0ZzLzNISFBPaC85NU1HaDVFYjdqY2c0Q3Z6?=
 =?utf-8?B?cWg2OWxuUFlONmdkTWt6N2JrQzgraXIrQXJ3MzV3a1plOExNNGZVUldFaDF4?=
 =?utf-8?B?MkhLWk0weTc3SEpDK1EzZ2dSajdFTThvMmlKSWJhejZOcUgxU3NzMXpzNE92?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC38EE9C25BDF841822AED5C8D32AD34@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550952a9-01bf-467f-c4d1-08dddc4f0b26
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 22:57:00.3867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IDTaqe6E6vPUWRT1iCmeIhnhvzX1c4iPMTR1alNXDJyS5OEiXrONh9/yyujLTCVpKaW/rClALt2VVkvM9VeSAbeH4kyAKtY+NxGSh27y/Bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5312
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA4LTExIGF0IDE5OjU1IC0wNzAwLCBDaGFvIEdhbyB3cm90ZToNCj4gVGVz
dHMNCj4gPT09PT09DQo+IFRoaXMgc2VyaWVzIGhhcyBzdWNjZXNzZnVsbHkgcGFzc2VkIHRoZSBi
YXNpYyBDRVQgdXNlciBzaGFkb3cgc3RhY2sgdGVzdA0KPiBhbmQga2VybmVsIElCVCB0ZXN0IGlu
IGJvdGggTDEgYW5kIEwyIGd1ZXN0cy4gVGhlIG5ld2x5IGFkZGVkDQo+IEtWTS11bml0LXRlc3Rz
IFsyXSBhbHNvIHBhc3NlZCwgYW5kIGl0cyB2MTEgaGFzIGJlZW4gdGVzdGVkIHdpdGggdGhlIEFN
RA0KPiBDRVQgc2VyaWVzIGJ5IEpvaG4gWzNdLg0KDQpJIGd1ZXNzIHRoZXJlIGlzIGEgYnVnLCBi
dXQgSSBnYXZlIHVzZXIgc2hhZG93IHN0YWNrIGEgd2hpcmwgb24gTDEvTDIgYW5kIGRpZG4ndA0K
aGl0IGl0Lg0KDQpUZXN0ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGlu
dGVsLmNvbT4NCg==

