Return-Path: <kvm+bounces-54462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D61B21872
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 00:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 229D31A246DA
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B542E427B;
	Mon, 11 Aug 2025 22:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hXsEE+mS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F76A226CF9;
	Mon, 11 Aug 2025 22:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754951466; cv=fail; b=Nh9qhKV37FrtHDjXjSeGHbg/3zYiLwK73ucFowGtvCD1G2g36WzIshztxBkoqrV129b4T94/5MjWGrR9iFOC1NLozCi9QK6WfEZiq6eeCkWn9AmtFCnqe12r0jDhispAMQGkZHHvCQQICm81B0CH8KEFPDM2JlCOQHU4Jny6T3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754951466; c=relaxed/simple;
	bh=UcbRHbhV8Cy5W+RETWoN+otG8w22qFlHbKv0pXy++6g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MG2j3R5373coKJhSEQlLbrchPBNqp/rN2YN5d4OGaHV9xsBgikv7ISin2bjenjLFeSHIDcr7FrLvHoZVIKxJxyTYLoqyVFRrdBPSvJnlZWNbQycHlRdmteAIderuCzRvzipKZ9WItm288eztYmzLvAwheN0mkN3flncfuIPPilU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hXsEE+mS; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754951464; x=1786487464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UcbRHbhV8Cy5W+RETWoN+otG8w22qFlHbKv0pXy++6g=;
  b=hXsEE+mSybRR9ST2GsSWBT++2gElbbxGU8JaUJq3y0ZAXPt4/q/0nt5Q
   1NmWdefqTdGp3Gymjqd4SdqbaUtcBL+CWsqzdCf+gDJyDo83346S6DKYP
   VoA29+nW476PuyeVgkXh9rJXXkYupF3yFolhCt5Pc3b9qLlkvBAH2FFDa
   mv5pbq4u1fRdoCl95TnW+4zseXmQ41MR/NTqi8rn/9Pc6kWTDIAGkPXdM
   8pIOEJeXicj5+7/4yWsCmfwLYhXt9YIOuS5+ro+wQEt5A0larrRNYRTdF
   gNBXSrscWD+9Jh3pC4D7Kc6pm41ply3T1bxVc6fKKfQbT8mPtpWuhcRX6
   g==;
X-CSE-ConnectionGUID: dwCkh5zWSuyDYbNHf6WuaQ==
X-CSE-MsgGUID: KYOtfMW1SqWf71zdMJUuZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="59827354"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="59827354"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 15:31:02 -0700
X-CSE-ConnectionGUID: rlbevCz5SA2vDcPnZHABMg==
X-CSE-MsgGUID: nObyBbqJR/ui05axw6jRAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="170232398"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 15:31:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 15:31:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 15:31:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.47)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 15:31:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBa1K0uvSzN0NswXrz1CVr0q4mKvyQ00jUNxBY25ee7MR/Fx4dHk9cTKG9RltKB2mEqX78Tbl6JQIlWSRF3wBg+2lvuuIbZ0DePR3qYPEqcZR24WXOTltPyY4RcntXHCRwhPGLO7ZyXT/rF4Gl440Au9eNTBxZndMTSNwE9gXov9FzTSRCTL+vDp8RslrQ/o3i6RfogaC7ytFdlF32pZiffwVrhgysi36NIVbGWPsCVYmjAqnkPFNuDpVmZYk+KHM5W0uhpBp5b9TpkmWzhDJmz2xk94xaHCTwngyOXt9IkNgfTrNEDFzHX7SyGQFVTe+NxDPesaOG0OMZfVAdPpUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcbRHbhV8Cy5W+RETWoN+otG8w22qFlHbKv0pXy++6g=;
 b=ZrkSa3MnsIOUQhSW7FqBYlgDZnRgpGZVovQaqrZmIzrsrw2z/i9QOW8Jglg2+ZT3ILbymxXgcvsxNlSzCkezXg5gJhZDjoFSosvdMM6yH97EVrZJX+sYM8JRMOGnt9SFkLr8kmUlfqxafshOthB7/cuQfHZ9FxYL0jG9ta2tcIOvEejevSuz5W6Up8EQxDNegbjbypKZavYiSB6Rxx6c4S1aEuq90CtgEZVGYetPd72yvR2NcQtmCDye9Xq7Kyr6F42s7x43CcSWVo0KBjXt6sSQYvGm89q2Es3eUuHuVPFaCe9Xs+mew9SHueFYpQCoULNn3W68cMEvYzyZCdpfAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6116.namprd11.prod.outlook.com (2603:10b6:930:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 22:30:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 22:30:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kas@kernel.org" <kas@kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
Thread-Index: AQHb2XKrCJQDYmgN9EmkL7mVJaZZf7RZwqaAgAOdgICAAQwrgA==
Date: Mon, 11 Aug 2025 22:30:58 +0000
Message-ID: <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
	 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
In-Reply-To: <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6116:EE_
x-ms-office365-filtering-correlation-id: 36597e5e-08a4-4fd4-b761-08ddd926bebf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L3RBTjZxbmNSbnY1VUo3bUhqTklmNnFIQUEzN0cwRXovdlI0ZlVJQXNXWUl6?=
 =?utf-8?B?MkFQdWJhRnAvZW1yS2dLWkppWVRkWlZ1SUV3MHVVMEZoR0VyQnRoTWFVWjM5?=
 =?utf-8?B?R1NYaGFEQnQ1RTAzSGVNOGgrQ0lvdmN6Ty84bVI1MnJOdWh5RVprbHBuaXkz?=
 =?utf-8?B?YStmdko2bTlrekhyVWRHVDU4ZGVjNk16YzhVSEgyWUF3MVhnTVJCZWNMR0R4?=
 =?utf-8?B?UkNXWHI1UFRUMWs3KzdoYlFtVkh6YnZJTWszeEI5NWdjNHlhbWlQMkFIVkdS?=
 =?utf-8?B?aXhGS1JxUFpudHExM05sVWhWUkRkSnd1YnM2TkxBYmV2N0FQQXYxcWhNd2ZI?=
 =?utf-8?B?MU04M2ZBeDhpYXk1RVFqcm80d1ZVWGM4VkJCcDRIQzhibEk5STlOWVRrcXIx?=
 =?utf-8?B?WlhtaXNseElhR2tMaEowUkZtTkZPN3h3eEJXdGJwZUVKSnF4KzZGbjA1MzhP?=
 =?utf-8?B?TGhVUFB5cXE0VFBxS3Y0czNtRllGcE8rUXNwWVJBQUVZODExb3IyWVhXNXRJ?=
 =?utf-8?B?VnY3dHNVM3g5Uy9IWUJjSEgvWFZ2SmJUdmFVK0xyWWQvajc2SlM4VENBUXlD?=
 =?utf-8?B?RUhoOUhEemdROU1jTjdnU0M2WjRWSDZXN0hVWmdNaUdNT2Z2cnc0V2VyNEll?=
 =?utf-8?B?R2VQUXcrN29ScER5b1VJeXdFL2VYaTNLOW83cExSWm16cktuVWkxbG8vQ1NU?=
 =?utf-8?B?NUwrNGVydkcrS2ZuN3FWcVNCcUNpTzVIZzJ2S3RadXg0dVdCU1lSWGN0TmZ4?=
 =?utf-8?B?RmEvd3YwRHRvUEpTQlp2MXBFZm4wYkk1VE5QZzVRbGkxOFRWN1ljM3FpVEJY?=
 =?utf-8?B?OEF5TTRkbzR4RkYwUTlUcTYrb09ZTWRpcjZtTnZvc2VGUVdYTWNGeWY1VEZj?=
 =?utf-8?B?SUhUMW03Lzk3N25JeVlpYlJuVWlGWURIeE5yV1l2VDZ0L2w2S3pNbzBhZ0dT?=
 =?utf-8?B?STNxenhGQStNL2lwaHVtV1c0Mjh3K2pnZEdvbWZiYzNCNFhIMHVRZVFOOWVa?=
 =?utf-8?B?b0gxRnNsWlptR2l0eFNQZVpjUzMxSVVzdlpJblVHcXlrVnNXV3BvTXhxMW9Q?=
 =?utf-8?B?WmJ0OWp6dTQxdUJFQnA4dWcvMkN6Sk52MXZvUVpyeUp1UmpsTHhjMG8xejdr?=
 =?utf-8?B?N0kwNzBoNGViYW1OTUFMMytVZ1FUKzFORk5HMVpLcU5mV1N2dlRvbnBGMXZD?=
 =?utf-8?B?dGhOWTBpVE5ZdGhMNmNZcllwUExXemRrRWU5R1UxVm1ZZ0p1TmJhdGpzOVd6?=
 =?utf-8?B?WVhGNnVXTkVPbWhVRWdBVFVTVUp1a04zeXJOWHhVSTNKcnpIamdvTStxQ09C?=
 =?utf-8?B?NXZibGVlVWVIWFVnUEpSOS94SGozd0VUTnBOV0pxaDdaUDN0YnNYdmFrSnhJ?=
 =?utf-8?B?dGkxTFE3bDNNWlV3U1JBcDE1aHdORy9NWTJ1VmtXeDZNVTFQTTJEa1lMK2ti?=
 =?utf-8?B?L3JMbERzWmpOVVI5VWNPMlgrUi9PckF4aFdHcGtHVFFhUHM2ZHNINE1rZjhG?=
 =?utf-8?B?N2JvT0Uvd3NFeUdNL2lJdHdLL2NLTnIrVXlnUW51RVJVSzZ3cmtKdEZPVUdP?=
 =?utf-8?B?cmp1b0NUSnlVS2NxQVlsRUdGNERjZGw3N2tIU29DenV3cERqMnFOVHEwM2RN?=
 =?utf-8?B?NnVIR0lXNDJXR0w3K1Q0SUdzamV3TXkwdHBJN1JwbDVLeERUZUVremlNWnN4?=
 =?utf-8?B?TXR5UGxrVGk1Uk43UHJYNWViOXhJYXFxY3hvMjlyckRBTitOempscFNSUnhD?=
 =?utf-8?B?ZjVmZjJMaThKVElkR2ZvaEUySlJYNGpWenJUbFE4NHRRdXFza2YyYXIxVmlK?=
 =?utf-8?B?eEQ2OXgrVHJIOGt1Mkl5NFUra0pqMldaSHRQZm1LaURSS2lrNXorSVpiOTVR?=
 =?utf-8?B?aWd4UWo5R0E4Vzc4QUg1ZFdhYyt5aUpSY3FsNTExbm43RUdYQlVEZnIwWkl2?=
 =?utf-8?B?cTdQdjN2bDNJUXRFK200WUJQSVg4YnFOMUdJT3BVWjZRSGFtdDladkFDVkdr?=
 =?utf-8?Q?7B1O1nDB7iB0hvAdHrRNaunqoAlJmQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHhiaW16dENiMVVxNUVYYlE4QjVSQzQvcTU2UkdvVFdEK1lKeEhQVm9kbVp3?=
 =?utf-8?B?cUZ0ZE00Zk9TN2phL3hvM0ZTTGdDZGpzZUVBL3Avc1VsN2ZQck5VdUpscFpr?=
 =?utf-8?B?clFuWHJES3k4RGY5WkZrVWN4N2ltZmF1MnRsUVBPRkZoOVRsb29FeW5VQStK?=
 =?utf-8?B?MXozM3hOdDVqcmxhcGdBSjJVbzQ2MVRFY09mTjZhMDZtMThvdEUwQVJ3ckV2?=
 =?utf-8?B?R2dqVytldUREVVBGUjBva0VqRk5SdXkrdldaN1Y0cEFYeGJqWlVieXRxOWRa?=
 =?utf-8?B?TlowNFgxcm9VZ3lsOWE1L2QvV2pGZEdYcXlleWVaeTJzbkVBSUlDam9LaXJI?=
 =?utf-8?B?bXRFSGsva1Rhd25DTGdESG5pOXB0MHpJQ09udGllVnZDWFNOZVhydmFFcU1E?=
 =?utf-8?B?K3NDVXo0ZzEzU1hEWHQwOCtvdDl3K3dQaEpOdFR1cGFvSElxVmE1V05ZMWdH?=
 =?utf-8?B?ekwzSjlEcGkwaVJCMGhsUVFVWTM5b2dJQ0RZSHd0a2xNQmQwNU9USmdIbVFY?=
 =?utf-8?B?VWVnNklzWWkyQ0YrVXNTVEdHbkp4d1JmUVdrUHAxMFlqZm9JbHBNYnY2dk9i?=
 =?utf-8?B?cHBlUmY0Y05KQ0N2RzcyZ0ZrOHorMjF0c2pyM20vTGVtNUNDeW1TREMvK0Vi?=
 =?utf-8?B?b0NnbVRZVnJEeXBrcDZ0aXo3eFZ6cGowWFhoSm5ZUWZWbG9wenEyVGRFRWhC?=
 =?utf-8?B?UTJhMkl6Z0NwaDBmbjFVSm1acUJvUDB2bEJBTWpaakdwN254NkNzQmlaN0V3?=
 =?utf-8?B?ZHNUSDQ4cHZScWVFcVo2N1pvQlY0ZUhVaERscVNIdkxoTzE3a3dOZ0JrQ205?=
 =?utf-8?B?UGx6aHJ1cEVLR1RHeDJXeDJzWFp5ODR0VWlLUkRiVkIxMUpwTExzbEs5a3p2?=
 =?utf-8?B?NzRQTTNZWTZnZ3ZNRXpIWnd5VTVDUi8xSlA0ZlpnTG9jMkVad3Q2azdrLytt?=
 =?utf-8?B?a09RQVFIaHNiY1E1aDl5VGVNYlVEcllTNTF3TGhBN2FndDRkdG1INVpXZjJy?=
 =?utf-8?B?dkszZHNXYklzcWRyMy9ZbW9oL0lJZlg2Uk50NWRhaERYTjJUeWp6YjQzVkpm?=
 =?utf-8?B?NFFrY2FOcWRsekpGSHF5UURNZHhBczQzR0ZOMnFzV1BkcXhjcVJ0R3VwazY4?=
 =?utf-8?B?WitqK2J4UGloSE8ycHcydVZhSEMwQnBxbndGKy91cEkvd2xhaDI1SS8zU3gz?=
 =?utf-8?B?YkNTNmZZZnlsc2tLRHF6VEF4Y1grbSt4YkkyT0liS2FmMkNwdXRMM1VDK2JR?=
 =?utf-8?B?SWZDT20yb00rc0FNa09QSkxVNjNnSlllQzZRdk16dE8xYytMSStoVE1hTXY0?=
 =?utf-8?B?S2t2KzdJTSt0OC9YRjRRVU93VzJ0Y1ZrRzF5S295Q096UU04U1JNT1d2THpx?=
 =?utf-8?B?MTY5YmpWa2RyL3UzaTBvQ0lsUlp2N1FVZzNaMDBET3Bpajd6akpwUy85WUZE?=
 =?utf-8?B?MmlpSmx3dEJqTkY0NVBKY2tTMTg2dThVdUJFNzFHYnFCSk0ySVE1Q1YremR6?=
 =?utf-8?B?eWF1WVRnVW10SC9GOVRYZEFKVmpocW52QU45cDB5akRoZm9CZEprWHVkVXR1?=
 =?utf-8?B?WjVMbjI4bmg4amJNUE5WeGwwYUdRVTJKazM3OFc4Zy9ERzV6bmZnN2JHdTMz?=
 =?utf-8?B?Q3VJdTJrVTJpcURRUTdXUmE5K2N5UEJlRjRITW1leEs2bXBtM1pMSW0vUUQw?=
 =?utf-8?B?VER0ZHlyZmpndzdOMVZGRStDa1BJT3RtdnBzeGpJNytRVzhQdnpPTTRzTlpl?=
 =?utf-8?B?WU5VdTg4ZGhuYmE1VWtLdEE5NSthNG9keWVNUzVBNHV0azF6dTRkMW45S09C?=
 =?utf-8?B?MWZQLzM5eUJuNE10WnBKWXVQVHNyZEErOGd1cGFERFNZRmdVK2dnNkd3T0p4?=
 =?utf-8?B?QnVsTU8yTjhxVUhzMit5VG0yNCt4ejBmeUJ1bm1YK2FDMUtJZDhjY3p5djRV?=
 =?utf-8?B?RmhiNTNDemw3Y2hVVjRSbERVQ3FYSks3UHIvaytuMTlOMmFOdExYMDJzbUFS?=
 =?utf-8?B?NkMvRW9qU3orU2xVcURZY3BkNmFmcHhXVmlKbC9nNy9lYlUzQUxxSTFTWXo3?=
 =?utf-8?B?bFRlNTg3MUFhWkhERUU1ZTEvdEhIaStSWmFhNWZBeHA2cm5PUzJTV0grMEt2?=
 =?utf-8?B?Y0dLV2RxRmNhN1NYQkhYMFBZT3ZhMFN0L0lnbUhuaWtMOUxoeVViNEcxZ04x?=
 =?utf-8?B?bHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <93474BF396E0854EA753410E70AF19DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36597e5e-08a4-4fd4-b761-08ddd926bebf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 22:30:58.8599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aPADrznQ/EPvGgEkOt0UTX/qSDu8csgHYTMol0EuAtVxKMvo4bMGH6EYwdgm21Mq76ZJJA8ACANvWnpOfundUVwEymVPzTid9JKDC2E+cW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6116
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA4LTExIGF0IDA3OjMxICswMTAwLCBrYXNAa2VybmVsLm9yZyB3cm90ZToN
Cj4gPiBJIGRvbid0IHNlZSBhbnkgb3RoZXIgcmVhc29uIGZvciB0aGUgZ2xvYmFsIHNwaW4gbG9j
aywgS2lyaWxsIHdhcyB0aGF0IGl0Pw0KPiA+IERpZA0KPiA+IHlvdSBjb25zaWRlciBhbHNvIGFk
ZGluZyBhIGxvY2sgcGVyIDJNQiByZWdpb24sIGxpa2UgdGhlIHJlZmNvdW50PyBPciBhbnkNCj4g
PiBvdGhlcg0KPiA+IGdyYW51bGFyaXR5IG9mIGxvY2sgYmVzaWRlcyBnbG9iYWw/IE5vdCBzYXlp
bmcgZ2xvYmFsIGlzIGRlZmluaXRlbHkgdGhlDQo+ID4gd3JvbmcNCj4gPiBjaG9pY2UsIGJ1dCBz
ZWVtcyBhcmJpdHJhcnkgaWYgSSBnb3QgdGhlIGFib3ZlIHJpZ2h0Lg0KPiANCj4gV2UgaGF2ZSBk
aXNjdXNzZWQgdGhpcyBiZWZvcmVbMV0uIEdsb2JhbCBsb2NraW5nIGlzIHByb2JsZW1hdGljIHdo
ZW4geW91DQo+IGFjdHVhbGx5IGhpdCBjb250ZW50aW9uLiBMZXQncyBub3QgY29tcGxpY2F0ZSB0
aGluZ3MgdW50aWwgd2UgYWN0dWFsbHkNCj4gc2VlIGl0LiBJIGZhaWxlZCB0byBkZW1vbnN0cmF0
ZSBjb250ZW50aW9uIHdpdGhvdXQgaHVnZSBwYWdlcy4gV2l0aCBodWdlDQo+IHBhZ2VzIGl0IGlz
IGV2ZW4gbW9yZSBkdWJpb3VzIHRoYXQgd2UgZXZlciBzZWUgaXQuDQo+IA0KPiBbMV0NCj4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzRiYjIxMTlhLWZmNmQtNDJiNi1hY2Y0LTg2ZDg3YjBl
OTkzOUBpbnRlbC5jb20vDQoNCkFoLCBJIHNlZS4NCg0KSSBqdXN0IGRpZCBhIHRlc3Qgb2Ygc2lt
dWx0YW5lb3VzbHkgc3RhcnRpbmcgMTAgVk1zIHdpdGggMTZHQiBvZiByYW0gKG5vbiBodWdlDQpw
YWdlcykgYW5kIHRoZW4gc2h1dHRpbmcgdGhlbSBkb3duLiBJIHNhdyA3MDEgY29udGVudGlvbnMg
b24gc3RhcnR1cCwgYW5kIDUzDQptb3JlIG9uIHNodXRkb3duLiBUb3RhbCB3YWl0IHRpbWUgMm1z
LiBOb3QgaG9ycmlibGUgYnV0IG5vdCB0aGVvcmV0aWNhbCBlaXRoZXIuDQpCdXQgaXQgcHJvYmFi
bHkgd2Fzbid0IG11Y2ggb2YgYSBjYWNoZWxpbmUgYm91bmNpbmcgd29yc2UgY2FzZS4gQW5kIEkg
Z3Vlc3MgdGhpcw0KaXMgb24gbXkgbGF0ZXN0IGNoYW5nZXMgbm90IHRoaXMgZXhhY3QgdjIsIGJ1
dCBpdCBzaG91bGRuJ3QgaGF2ZSBjaGFuZ2VkLg0KDQpCdXQgaG1tLCBpdCBzZWVtcyBEYXZlJ3Mg
b2JqZWN0aW9uIGFib3V0IG1haW50YWluaW5nIHRoZSBsb2NrIGFsbG9jYXRpb25zIHdvdWxkDQph
cHBseSB0byB0aGUgcmVmY291bnRzIHRvbz8gQnV0IHRoZSBob3RwbHVnIGNvbmNlcm5zIHNob3Vs
ZG4ndCBhY3R1YWxseSBiZSBhbg0KaXNzdWUgZm9yIFREWCBiZWNhdXNlIHRoZXkgZ2V0cyByZWpl
Y3RlZCBpZiB0aGUgYWxsb2NhdGlvbnMgYXJlIG5vdCBhbHJlYWR5DQp0aGVyZS4gU28gY29tcGxl
eGl0eSBvZiBhIHBlci0yTUIgbG9jayBzaG91bGQgYmUgbWluaW1hbCwgYXQgbGVhc3QNCmluY3Jl
bWVudGFsbHkuIFRoZSBkaWZmZXJlbmNlIHNlZW1zIG1vcmUgYWJvdXQgbWVtb3J5IHVzZSB2cyBw
ZXJmb3JtYW5jZS4NCg0KV2hhdCBnaXZlcyBtZSBwYXVzZSBpcyBpbiB0aGUgS1ZNIFREWCB3b3Jr
IHdlIGhhdmUgcmVhbGx5IHRyaWVkIGhhcmQgdG8gbm90IHRha2UNCmV4Y2x1c2l2ZSBsb2NrcyBp
biB0aGUgc2hhcmVkIE1NVSBsb2NrIHBhdGguIEFkbWl0dGVkbHkgdGhhdCB3YXNuJ3QgYmFja2Vk
IGJ5DQpoYXJkIG51bWJlcnMuIEJ1dCBhbiBlbm9ybW91cyBhbW91bnQgb2Ygd29yayB3ZW50IGlu
dG8gbGV0dGluZ3MgS1ZNIGZhdWx0cw0KaGFwcGVuIHVuZGVyIHRoZSBzaGFyZWQgbG9jayBmb3Ig
bm9ybWFsIFZNcy4gU28gb24gb25lIGhhbmQsIHllcyBpdCdzIHByZW1hdHVyZQ0Kb3B0aW1pemF0
aW9uLiBCdXQgb24gdGhlIG90aGVyIGhhbmQsIGl0J3MgYSBtYWludGFpbmFiaWxpdHkgY29uY2Vy
biBhYm91dA0KcG9sbHV0aW5nIHRoZSBleGlzdGluZyB3YXkgdGhpbmdzIHdvcmsgaW4gS1ZNIHdp
dGggc3BlY2lhbCBURFggcHJvcGVydGllcy4NCg0KSSB0aGluayB3ZSBuZWVkIHRvIGF0IGxlYXN0
IGNhbGwgb3V0IGxvdWRseSB0aGF0IHRoZSBkZWNpc2lvbiB3YXMgdG8gZ28gd2l0aCB0aGUNCnNp
bXBsZXN0IHBvc3NpYmxlIHNvbHV0aW9uLCBhbmQgdGhlIGltcGFjdCB0byBLVk0uIEknbSBub3Qg
c3VyZSB3aGF0IFNlYW4ncw0Kb3BpbmlvbiBpcywgYnV0IEkgd291bGRuJ3Qgd2FudCBoaW0gdG8g
Zmlyc3QgbGVhcm4gb2YgaXQgd2hlbiBoZSB3ZW50IGRpZ2dpbmcNCmFuZCBmb3VuZCBhIGJ1cmll
ZCBnbG9iYWwgc3BpbiBsb2NrIGluIHRoZSBmYXVsdCBwYXRoLg0K

