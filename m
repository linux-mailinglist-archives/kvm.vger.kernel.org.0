Return-Path: <kvm+bounces-57766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FD8B59EF3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EE703A99F3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1DE2FFFA4;
	Tue, 16 Sep 2025 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MqYiJQNg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA70B26F28C;
	Tue, 16 Sep 2025 17:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758042614; cv=fail; b=ewKaL90ojLvj2xWUyiN7iWEURcfJF45E6pTorSb6ZMNDwr2qFp4pipLOv68GNtdF9uSLdHWLDsi6UMUblB++ur7WZx+L59uQwaH2rsg5fy8cdEWpWVZN83VmsTILoXtPTsFlKNWv/lYH4C3TxWy/gwB0fmG35rXymycXoG4SBKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758042614; c=relaxed/simple;
	bh=w+0OSDk8X+cTQgE3lcuFY8zet/n+MctY5piIQSrJ+J0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mEcQNm7IYW1B9Z8Nw4ccXwdBexy4s3NALHyXJZNEi3stR+pEURI50UoQvZdHHEef4NX7MEzBIKvy3locw0cNfhqpuJyRhX20/9KjDWqbLeViaaK6hs4GhGoE3HFWSSBDY//UtsOULzJ5xHDNzbUniIHR5W2qbanLb3Y+jJ4GIak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MqYiJQNg; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758042613; x=1789578613;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w+0OSDk8X+cTQgE3lcuFY8zet/n+MctY5piIQSrJ+J0=;
  b=MqYiJQNgNgsZEcqa2U8dtbdwNRXd6K2KUxmCdDItbSw6CuyHVcWO6kE2
   Ov055H09XxaEHf+LGp1lA6eRXxdIPKsYPLMDkfFNm4Buiis3MQD3E4WMS
   lYq6OdSG4vO4NycIqUOxqbGL0LUO+8jThybPZuzep178qN+ZMUjMcah2n
   dFwAblJcYRLkxVRUzHRIvzKRhoIBTiK9aHD4d01ztTgiYOyUaH8dJtvpk
   FIqzk5vXqGq4HZGXHUiM/p2dLnRiwoH/r3u/oIdlqEUoODs57Yn6SWr2O
   X62FPDMpR13SXIhJiQvDpUMVt9LSnmm1DWpSEJNxnZIyo/hP8hKrXnXxn
   g==;
X-CSE-ConnectionGUID: Ai0NopT0RHiAn8t62pBKnA==
X-CSE-MsgGUID: WolQcdoaSf2VPG2oayzf2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="47908560"
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="47908560"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 10:10:12 -0700
X-CSE-ConnectionGUID: ijqunoJCSWW3cf7pR+/yFQ==
X-CSE-MsgGUID: 840ckbarQte0/EiR1CnZYg==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 10:10:12 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 10:10:11 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 10:10:11 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.24) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 10:10:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsdSjKKC8DuzIQdy4+pnEds+VwFd7qq9FmCJp4tJZm0KMJBwZK+PBDaq1dbWxGu3zJl0PwB0YbfeC1WbxvPBYXP7sdVJ5fhM3ohWaFIFEVwMn06j+cZo4WoMqKjtyZyhJ55dSDVqvzRWTh6O736NPuFNH+6lgKU18Eo/H4RR0RfARQ23DzH99KEJeYCMPMsqxehE5VHr8jzljFPQsdhnEM3pcbelyXhs4GyDAbqjWOpsyll4MQjOH+gMp2HU4/OyPeyXg2MKfDBzlZo8ZEyBCfoSI5uMSNtU/V12zpjxCiEiq36GS/TAPl/gcTEneW+R4UxsjZDzNkbHMprX8KsD3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+0OSDk8X+cTQgE3lcuFY8zet/n+MctY5piIQSrJ+J0=;
 b=UZDYsjvp5hx/qkLEH1b2y1g6arhYXd/nVTYPc9IX683UF1QT5JzsMFsBvKENvUD2e48CGpCnV77J89tTXaceDUdhgGLjKqF9MvDJ75w+B46G0hd4OovtBzU2JEY+c3hONmbS1PqFiZColB44CZ5HC084t/Wgz09S21eWKYnV73W2TQRiJdcduTwjdQxwEDbl9qtPbu8yKP9CxGFlxEagfmjDKrL4ZU9BenKrooOlICX17sndl94DNADeWPSx+9c9kJSj8E7QGr1xlRWXlVmlABjuy898oKYrMq15SvVD4IEpUR6AKTxTpDpg+3/hB1WORojulJh34g5wMQqMLwAWcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 17:10:09 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 17:10:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill@shutemov.name" <kirill@shutemov.name>
CC: "Gao, Chao" <chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCHv2 04/12] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHb2XK3Zzo+5cyiVkKYUJ8ur2xfN7SVh7+AgACcMACAAIKtAA==
Date: Tue, 16 Sep 2025 17:10:08 +0000
Message-ID: <1d6fbdcaf0ac6657bff3b9de089d9afac6fc757f.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-5-kirill.shutemov@linux.intel.com>
	 <6c545c841afcd23e1b3a4fcb47573ee3a178d6e1.camel@intel.com>
	 <bfaswqmlsyycr3alibn6f422cjtpd6ybssjekvrrz4zdwgwfcz@pxy25ra4sln2>
In-Reply-To: <bfaswqmlsyycr3alibn6f422cjtpd6ybssjekvrrz4zdwgwfcz@pxy25ra4sln2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6680:EE_
x-ms-office365-filtering-correlation-id: a56ef0b1-2e06-4270-6ab5-08ddf543e3cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?a2VrdkNpMmFXdldOd1NuWWRSenZNbUl3a2c0aWoyNkVrSWJGczR2TjVOaWpI?=
 =?utf-8?B?MmkyRVhFWjVpTUxhU1VXWWVLRWorQ3dNdGxMOU9vZUFpd3REQ0pnYnZ2T0p6?=
 =?utf-8?B?amdFWm9sMHRvWWpSQXhRM3hpNWg1blpKRUlhb3I3MHVPbE5Yd1UwYzNOT0ox?=
 =?utf-8?B?YXZPNWxpS3c3QkZZcWFPdndSdjkvZGFxVGRkb3BxWkF5aVFzNGRKYUZqZW9x?=
 =?utf-8?B?NWx6RzJab2JjaERFOTYveFU4Mm4zL0NNMnVvTE9jcEpPakxTbmIxZGtka2Fl?=
 =?utf-8?B?ZkRVK09rVW5hMlRGcmp5MHFoWjhMZy9Rc3kvckR3WCtMTFZUZ0ZJdDdvMkcx?=
 =?utf-8?B?K3RwWmpPWDRTcmdQTFZ1QldqQnZLMWIvMUJTdVdrVlpmekNITmFZSkdUS3lp?=
 =?utf-8?B?U3RNSnNVV0hUYVRKQlFmbjhJdUpkVGZESEtyZzJ4USt0b3ZZTUduaGljZzNr?=
 =?utf-8?B?VUlnNTVOSE1OeXVqWGtaek9nNEI4VzloSEszN2VaWGNUSVliZFpHMHd6L1hI?=
 =?utf-8?B?VTBxV3FlYlJKT3FDeE1lTmtKaWJoT0MxSEZ3TThESHo4YlF0NXM0RWdLQTZw?=
 =?utf-8?B?YkEydzZickhHdjdNUlNPOGVuT3RDMlNhbk91eGNuRk5zT3c0cGNYdzA5TFFy?=
 =?utf-8?B?SjNhSmt5ZUF2aDRET2JNcHR3MXpwUHNJVCtGRFd2WGN4bE9lemNhQi8vS2lC?=
 =?utf-8?B?Nml1QitUZElWSDJxbjBHeGNHcVoxRGdXR3V3eGhtYXZIYTJ3K3ZGUGhQbUNC?=
 =?utf-8?B?UFdtdlpwVGhreHJjWFpOTXd2YVZ3bHI3NFlhVUFJMHlFLzN4NTlkRkorSTFL?=
 =?utf-8?B?NElMVjZlVlFHSThLbittbGZScHoxaW81RWhyTHBQK3dtNUREOEgrSHJRZ2k5?=
 =?utf-8?B?U0ZDK0NZZ3cya1JQaWtCREphM2dPR2k4SVdiUGoxOGRpMU9ZK3A4elArVkN4?=
 =?utf-8?B?TGpxNXcvY3oySmQ0K1I0V0VuSzRNZ2pVcHBUOGNBNXNuR0ZpN3NnODJCZk1W?=
 =?utf-8?B?YWlta1M5VTJwb2w1S0dFZGUwMXROWXlMT3ptYlIyaTRnbEhoN2hPblFNdmNz?=
 =?utf-8?B?Z284ZXFyT2lLSWYrTWNjb1JvM1dwSW1tTTErWUhxaGxFbHpYWkZSMjhoMGUz?=
 =?utf-8?B?RTJtVzJxNEJyRDhxcGVQR0dITTVhUlVuZlZtZlg0T0pYOGpSWGxNQnNyQmQ4?=
 =?utf-8?B?UEZUQnkxUTVaTUJrNU9CNGhtdzZHeXQxUDh1dVEvU0hGUmxHTnB5T2tORHlJ?=
 =?utf-8?B?aHpBUFdDVzZZVHFQblBEdW1GQy9IdnVzNG1jUFRudWkvVWQ1YVBZb0pTcVVu?=
 =?utf-8?B?QTlHWEdGaGJOdURGR1RlbjVYV0RQRFJ4OVVheUFSQUEyenI3N3NwYlBiamY3?=
 =?utf-8?B?NjVaMEF3UEt5OHZRRDRQU3FrVWlwU0FmOW9UZGhvWGpIZGlxWW8ycjBZczBS?=
 =?utf-8?B?QlZ2UTdEdjNDM2hKaGYzbGpoSjIrN0RmUjFXSVNHVHNaek1MSElpNVN0Z25o?=
 =?utf-8?B?eG9QZk1pQmtmNFJST29UMEpkZm4zVzdnR0NRYVFxamZMQnpvWG5DMi9UQVlk?=
 =?utf-8?B?Y25UY1FnOGs1NW5uQ2E5WlV3OS9SUjQzcXlpZ0NXNnBaMWRraHphMWZlbHlk?=
 =?utf-8?B?U1E2NkhmQmhuSFErTFJhZDVKRGUxdDA5S1l0MExRSC9hY0F6L3BxdXZTWHNR?=
 =?utf-8?B?S21SejlSNGRocnlaOXVhL0RLb2ZEL0Y0UktlMXB0c2x0R1VvaEVkN1c4NEgx?=
 =?utf-8?B?T3QrRGg4WFFHamFmUXNLQWQ3dzFlaDg2MVdERDFoUWx2dkVQMjdNLzFkcG1L?=
 =?utf-8?B?ZkFyK0d0SWpld3hFVU5xTm1zZllNbEtHbzY3Z3FtRWgxRWxPbDNQVjZnRmE0?=
 =?utf-8?B?b09vSjFBTTFJb3NEQ2d6OEx2UUkwYkhzbkQwWld6OGhCL3d5a01CQ0lkTzJJ?=
 =?utf-8?B?Z09IVDYwK2xCaUo1OG1mYW9odFFhTnM3ZDVmZ1pqSlZqNjEwU084bUJNeDQz?=
 =?utf-8?Q?cGXqWiposzDMHFQKtSVm+EgPkM9SgM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dktXSy9rRndDWDdEanFkemJOZWlzTUFxbzV5am1YUWU1UURlWmF1Q1hDdTZE?=
 =?utf-8?B?b2NhSEg3RitOeWZxOEhTQ3V6Tko3Ti8xRnc4ZzEreXlvczVwTlR0K0pMa2ZH?=
 =?utf-8?B?QzFRTjJnNzdpQ1Vlemx0VCtqSm0rZDBmc0pDL1dIWkZjR3NXWW1JL1RONUNq?=
 =?utf-8?B?d3ArOXZDQ0Z1aEZjMm1zNE94M2F3OXV0QmhyWHlTd21wbUtaeis2ZmZHZ0po?=
 =?utf-8?B?ZE5xc1V6dy9wY0xzNDA2M2VseFpyQ0hyMFVCUnNCeFBxZ2hzUGJEZkpmYkVm?=
 =?utf-8?B?bjNpNnJ2M3RWMjY4OUtpRDgweDViamFNbmFzb2R6QzZCcUxuaFJaNnN6ZG1D?=
 =?utf-8?B?eVFzblE5M3BzVFNLYXkwTTRjNThGcVZWRUQvRDNsODdBMFZJQzYwVjBaYnFs?=
 =?utf-8?B?a3VIbmx1SHozbG5CdjkxWUM0M1ZHWUhpTGtiYlIxQkVaUjlZclM2YkhPUXZl?=
 =?utf-8?B?MHI0cjM5UnhmRUU0YkRwdnY2dHcrMHY3MFRKQnAzQ0h5T0ZGUHk0eTRvdXpI?=
 =?utf-8?B?eER3MERlYjNIK0g4b2k5T21PclZPRUsyRkFwK1FOeGhBVThsSUhBM2wrWEtM?=
 =?utf-8?B?QU9WVlAwUUw5SE1JR3RtWTVZTzhwYkpkMnVlRk1DSkFtSTUzLzZ3YmpzZ2Vw?=
 =?utf-8?B?aE1PNlV5K0E0R2ZmUzJodmtEM0U3VXM3aVNWUUliNXc4K3pWd2NkaVdUelNH?=
 =?utf-8?B?bW5JZW5YM3VjZ1prV2ZzMmg1SitjMktKa2RZZW8xOXVuLzludy91MjNyZjk0?=
 =?utf-8?B?N1ZSMzJCdnpyc1BQejlZYTF4UlpXR2hoa0YzazcyRERkU2RYazlzbGpScG9O?=
 =?utf-8?B?dnFHOGM3Z21mWFhpSm1Dd3prUWYyNGxwdFVtc21wM3NnY0JIWGRTVWxMTkU0?=
 =?utf-8?B?SEJvUXFTR3Z0ano3RDd2YUlabjJvNEdLdFlCbmp5YnZCRTR6TnRVeHFZdFk5?=
 =?utf-8?B?cFRXbFhGd1laaWNDTlVaYjhCQ05VQ3NWTUVSMDQ1MWw0RGpselNyOE1uSDdD?=
 =?utf-8?B?dGl5Ym5ZN0taK2VEOFMwQ2pJK01uWTVNd0RFMTZtZzdJcXNLUTNVVW1Pc08y?=
 =?utf-8?B?bmlicm5IeXdqUzl6U0N3T1lBcGxiSXYwaHFPb1BNVklrVVp6czBiYXFZNTN2?=
 =?utf-8?B?dXJuZU4vdzFLQjdvK0VTeitNQTI1M1pxRjVycTZKOGY5ViswejZtYXcwL2Zz?=
 =?utf-8?B?QzlySFBuRGtwYVc4d0RqbytEZnJJS0hIWjFMVDJ0eDJxMU1jbCtYYVJKV2NU?=
 =?utf-8?B?bVRSVjJuMGJwL1FjUnp5MlNRVnUvenJzdnFCM29VRXhHdVRXT2ZucDN3R1d0?=
 =?utf-8?B?MVRxcEJWOVp6NVZ4c0h3THlCMDRMUWFCVjlML0dZRzB6aDRoYi80L0J1U2dF?=
 =?utf-8?B?ODhJbEl3d2wza3lNUVlOcGQ1RHhLd2haL2d6eVZZZjZPK3FGQlU2cWR3Z1FD?=
 =?utf-8?B?YWtkOTB1dXYyVno3UStHWVpXVTU0bTVXTExjNWFsVUMvYlJhZGVOR3hRVC81?=
 =?utf-8?B?cmFRakwzRWxrTjV0bnF5MEdUNHF2M2duSnB1U2NSd1UzL2FxUWdScHdvVzk0?=
 =?utf-8?B?Y3F2QTFFamlOOTR2RW5BMWFQUldIcjVjVUtoV3E2MDJkYWEvaG9yK2VpS1VX?=
 =?utf-8?B?UmdSeG92dTY3TzBwSjh0WXpSTUpzQW5CWDF6a1pad0o1cWw0NWJ5OWR2ZlF0?=
 =?utf-8?B?WnhDVHYraE1iNUxCSHNieXBsbHJaNEpSYk9CbU10TDl6aytLSDFzbktoOEt6?=
 =?utf-8?B?NDlVVXltYkJpdTlZM0t2OC9NNTg5YVNPU3FYYSsrcjNvdTgvNDNIWHVTVndR?=
 =?utf-8?B?a2VYQUJiY1QrUnZyNUlBdDhVWW9lTUwyWWpSdGg3d1B4cmNxZzZWaXFia2VU?=
 =?utf-8?B?UjJXVEVBVXBsR05CYS9ibnhvY0c0YlpMbU9RaGd3bDV1dUUwZ0VJZ2VXRFJR?=
 =?utf-8?B?anRLYWhVc0RHMWdHa0tLZ2JxNFUxQmxUTGprQWZGaWJHU1hqR29CcmN2a0lD?=
 =?utf-8?B?b0ZicTBrQ3hCbm1FMUdiZ1Ezd0REOU9heFpBYW55QVZWWmZqVFBXckZMbXB5?=
 =?utf-8?B?MFZienR5eU1HeFc0ekttc0ZmSlAwWlJ5b3JyT2lJYlhHNzEvZnc5c3hLU0di?=
 =?utf-8?B?MFhlMG8wWmN5bHB4Z0hvVm9ucmhjem1CNS9XdzhXVWFZZ3d5U041VnBnVjNC?=
 =?utf-8?B?bHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C562378477C7547ABEE75509B5DB558@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56ef0b1-2e06-4270-6ab5-08ddf543e3cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2025 17:10:08.9528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RKQhrs74iRyUlJlnaqtoV0kwDmSF4tUwfrAUiS0Wbty/N1xTkl3sIceB9D1y7NTOKvUOpBq1AsqdO0Qo0BXZaaaOWTPQBRChC+xsevHUgdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTE2IGF0IDEwOjIyICswMTAwLCBLaXJ5bCBTaHV0c2VtYXUgd3JvdGU6
DQo+IE15IGdpdCBoYXMgY29tbWVudCBmb3IgdGhlIGNoZWNrOg0KPiANCj4gaHR0cHM6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva2FzL2xpbnV4LmdpdC90cmVlL2Fy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYz9oPXRkeC9kcGFtdCZpZD0zNzU3MDZmZTczYTg0OTlk
YmRkZGIyMmMxM2QxOWQ3Mjg2MjgwYWQ2I24yMTYwDQo+IA0KDQpZZXMsIEkgc2F3IGJ1dCB3YXNu
J3QgZW5vdWdoIGZvciBtZS4NCg0KPiBDb25zaWRlciB0aGUgZm9sbG93aW5nIHNjZW5hcmlvDQo+
IA0KPiAJCUNQVTAJCQkJCUNQVTENCj4gdGR4X3BhbXRfcHV0KCkNCj4gwqAgYXRvbWljX2RlY19h
bmRfdGVzdCgpID09IHRydWUNCj4gwqDCoAkJCQkJdGR4X3BhbXRfZ2V0KCkNCj4gCQkJCQnCoCBh
dG9taWNfaW5jX25vdF96ZXJvKCkgPT0gZmFsc2UNCj4gCQkJCQnCoCB0ZHhfcGFtdF9hZGQoKQ0K
PiAJCQkJCcKgwqDCoCA8dGFrZXMgcGFtdF9sb2NrPg0KPiAJCQkJCcKgwqDCoCAvLyBDUFUwIG5l
dmVyIHJlbW92ZWQgUEFNVCBtZW1vcnkNCj4gCQkJCQnCoMKgwqAgdGRoX3BoeW1lbV9wYW10X2Fk
ZCgpID09IEhQQV9SQU5HRV9OT1RfRlJFRQ0KPiAJCQkJCcKgwqDCoCBhdG9taWNfc2V0KDEpOw0K
PiAJCQkJCcKgwqDCoCA8ZHJvcHMgcGFtdF9sb2NrPg0KPiDCoCA8dGFrZXMgcGFtdF9sb2NrPg0K
PiDCoCAvLyBMb3N0IHRoZSByYWNlIHRvIENQVTENCj4gwqAgYXRvbWljX3JlYWQoKSA+IDANCj4g
wqAgPGRyb3AgcGFtdF9sb2NrPg0KPiANCj4gRG9lcyBpdCBtYWtlIHNlbnNlPw0KDQpBaCwgeWVz
IHRoYW5rcy4gSXQgZmFsbHMgb3V0IGZyb20gdGhlIGFzeW1tZXRyeSBvZiB3aGVuIHRoZSBpbmMv
ZGVjIGhhcHBlbnMNCmJldHdlZW4gZ2V0L3B1dC4NCg==

