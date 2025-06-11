Return-Path: <kvm+bounces-49078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8612AD5926
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 413EC3A1F8F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1258D258CDC;
	Wed, 11 Jun 2025 14:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XFJTQRFo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6661E485;
	Wed, 11 Jun 2025 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749652920; cv=fail; b=eRiogoAfdEmKUos3lnRWQg4bRAhXUUQ9jq0qJ+eGZ03zV8ZgLv7AEL2DfioBElhFDWJrPpJtmGBqhbYNHQ2OQ6oGn0M3AmK3U3F3uxmaIqpr2BEt+hBdC+Ott4Dqw+9UgDYHjDUr4JsQe0sqVY//ews/dbwJ16Fz+NhRvA0UeAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749652920; c=relaxed/simple;
	bh=lcHOM3clIjMTW/+eLkd/NC698834up28cG7dfFWCpug=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jJi6KDSRkoWxC9kJXH3z9mZo2ZaL3xONWjvPH7bETpnV73PReHMAu4L7TdCeX+m4Yb0nU30J/PrDuJ0dYpH39yxXzNKNLvEBihVdZPhZL2njDrGfe47OPOlDj8EfeYXnViIgr3cWVav5+eEfyg5sxk2oTrLGxGYFuBEN0d5mlbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XFJTQRFo; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749652918; x=1781188918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lcHOM3clIjMTW/+eLkd/NC698834up28cG7dfFWCpug=;
  b=XFJTQRFoTB8fuKM9L3kKbX8nHi6v/T2R5yeut6eCmBjUmbCCfn/bakPn
   sRmEMiUcmxPY3bJUIyDE/ARuh74poVPG14wNazugEh5EDUyKJHsN/SuDw
   I0qS0ILunISKitE8w2Ffp129SESToasBDotM3WK80mo4X6gudvqtQYu7E
   f9h3i859ZN2wpVqLyVnhtIWDvqNn7+sECiEhPwgh7pi4ns0+mPR/xUtpf
   osfGjlgd6FGQg6DWFa2WNcadrMCz1+cU5jda6a0yst4CKbJkVeJEi0cex
   1DphSps0p9UrNF+4aNXclUE4aJprTob4if83jImFbQzYIMYv6fzeiSIWO
   g==;
X-CSE-ConnectionGUID: IAdR56zzSii3vjy32yfKGw==
X-CSE-MsgGUID: 7iTuPz0gRQaaj7cxyF89Sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51899510"
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="51899510"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:41:58 -0700
X-CSE-ConnectionGUID: qhSPKA/GQUOJdDZ+/efEiA==
X-CSE-MsgGUID: agPFAMZXRICcLr4JKOazxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,228,1744095600"; 
   d="scan'208";a="148119947"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 07:41:58 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:41:57 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 07:41:57 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.65)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 07:41:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0plmyhrQuME2QHQ3PxiGIHRI1BRVwG5Ir5F+J96MGBmBTyPUlHMU1fxHkU9Tb+2jgpdXLxDZt48A9D8/g5KnrCeRs12u/Bs17zenp6Vw6RGcoagCER2jiHTU1T+oWdIuq+hy+p7IvyL9mJmsTb/tOB29mydIrhPFG8SkiUC0Q7yW26ZiSY8F4WvQnuF8iz5OAp18eXu7s0p0ALydc+yARnYAwc0GM6KSIOJarsEHKE8Y/an1XCzKNn1uAwS///lii7NpVxa1P7XRuQAEZ+ZHVqm1gn2eArWHR0+ZUwZTwJJWVSHtHU61FAllrH6TCtLAeRBYCthN+ueTbIHCO6ghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcHOM3clIjMTW/+eLkd/NC698834up28cG7dfFWCpug=;
 b=DpkT8f/MG4SeXBKrP/k0YqG+0nDcktO88+tyMHkfc4/LJVNPr5tyzXtqNTlZrJ5tno/erLBWKLa40JRJuPvDoAnHtxLE7XL3w2OvZ5htWlGzN/LK+A2uvOhM8fscc4pZaqESCRzMqJOYVZAIwOHlV9SxuWu4ZVJZ1tmB/axXEOsPa1MeMbI9VtQMef5e6/fHvGvb2/oOA+M1ewTxL3rF6ASfbksnzP5RpF8ZgABaJug8GVu91JNZANRrE99QsM4fViev03FG6CpG8XowLvJGtjJ0RpATSFD9/fFu3d8o7ULUDsyv+waY+zdFH5+foMBelEeFaZQWNRxYtUNTvQJwJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7481.namprd11.prod.outlook.com (2603:10b6:8:14b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Wed, 11 Jun
 2025 14:41:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 14:41:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Lindgren, Tony"
	<tony.lindgren@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAB+0YCAAAEdAIAAmbcAgAAI/wCAAMOrgIAABNkAgAAB6wA=
Date: Wed, 11 Jun 2025 14:41:41 +0000
Message-ID: <f24b69851a0565ed6d5b284df0e7d8399e65ff69.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <9421ffccdc40fb5a75921e758626354996abb8a9.camel@intel.com>
	 <d4285aa9adb60b774ca1491e2a0be573e6c82c07.camel@intel.com>
	 <e2e7f3d0-1077-44c6-8a1d-add4e1640d32@linux.intel.com>
	 <d53d6131-bf99-4bb0-8d25-00834864402d@intel.com>
	 <1676dd89cb71218195b52f3d8cf5982597120fc4.camel@intel.com>
	 <d1f70f8c-032e-4467-940c-18cf09c67eb2@intel.com>
In-Reply-To: <d1f70f8c-032e-4467-940c-18cf09c67eb2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7481:EE_
x-ms-office365-filtering-correlation-id: b6d66d81-b6e7-4ca3-4fc0-08dda8f6143d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?azN3UUtoZ0RIWW5NTHVLRWdJQ1BPekdvbzRKa3JNNDBSblpQYUxXNFgwKzZr?=
 =?utf-8?B?RHBGZjBraGl3V2hyNlZhcVhxb1czU1Q2Y3FxcXAyb3hQWTRuRDI0Z09VZVZI?=
 =?utf-8?B?YVZhYTlPdGo2Q0N4M2prMFRpek82K2ZhMFNmZ3huL0k3Y2Z2MWFiUzl4SDdi?=
 =?utf-8?B?MWVleUpUUXNHZUJvTjRwZ1U1eUZSRlpLcXgydy9pYTYyeWFpUUlXRlBzMHp0?=
 =?utf-8?B?bVl0UjJJb2k5R0V4aVJHZ3hHVHZsbkhxOXVDZS95U1ova2NWMDQ2ZVdPUXFD?=
 =?utf-8?B?WnJrM1pSR2ZXUkxUQmdFeW1zZmFPRkZiSWRrVk9ObmtCT2N3ekc4UGNVbklK?=
 =?utf-8?B?dDBrNHV5dFR0MTBDK0h2T2pKWHhRaTU3eTNMSFRLUHRTM3VYdVZQU3BwMkpp?=
 =?utf-8?B?VHFrSE9VUWkxdVpIL0xzV0NOWjFUbmRLaE0rdDhySDVFTFBGWHJNSVgvY0g0?=
 =?utf-8?B?ZW94ajV1eE9POGpJd2pOQlVUOGptRFpvbWcyd0lhN1hHZmV0YkcxTW5RSXlO?=
 =?utf-8?B?YkIvQW1pQkhaWVBTV0tvdkY4MjJCczdNdjVyYk1adjJiZy9EaForSWdwOHcv?=
 =?utf-8?B?S3hVVVVpSjBMUDQrb0VOYVpCdHVzRVp5UW0vV0FFWDFkajQ5bDVQRFBheGtu?=
 =?utf-8?B?L0pabDVoQWY3Zi9JSDdLbWhvQVNUMjl1TnN4Nkc0Zm1pMzdOUnlkNWdXRTZR?=
 =?utf-8?B?NG5sT1huWmNVU2RlYjBhZGdoK1RTWjMyMkJuQ3ZXTmFqWmx6YVltZzlKbEhC?=
 =?utf-8?B?Q0Jicy8zQUJ0cHhJZ2MydmVJQjlqelQ4MUR4YzZTVzZmYWVQR3J6YzhBVDMz?=
 =?utf-8?B?QmhlU0w3ZENHU0ROdml0NVJXVnlmd0xqRGRQY0x4R3F6TEdLdDRjYVVKalpL?=
 =?utf-8?B?OFBKcWdnSDJ1L2ZFUW9IVTVocU5LLzdheXA1eDdnRU5HNzd2Ly9SVDVWLzlV?=
 =?utf-8?B?SUQveWM2amFLYUU5UHpaS2VjdVBjdm4wNVVVY0srRVpLMFZFVk5VY3NqTjlJ?=
 =?utf-8?B?cTFkZ09KSzhUWEZvZnp5S0FXVU5XREdyeXVnZkFFNzRtc1FLdDBNS24yeWJP?=
 =?utf-8?B?bDcyTHdzOHdRVHZDZkZFOTN2a3UzR0dGWUh2OXpJZmkrZ2VJSjB4SmI2RE0y?=
 =?utf-8?B?RDJjM0tTTEQxQU9obmN5dFZZWkU0amtmbHZEMjVCNjRQekZvazgwb0dCamJB?=
 =?utf-8?B?OGI3dEh3QlY5TTF0UG5SSDdHaXpBbTBIK1FnUU8vK2tNY08yd0JwV3kxeE03?=
 =?utf-8?B?TEo3WlRzYURvRThoZ2VNSXB5OFhhQ0hxYzI2SWhjTWgrdXhmUW1mOGRQb1Ni?=
 =?utf-8?B?L25jdVN6UHNJcTlrc0E4NEM0dE9hczg0NEg0aXpkYjZFTENkNWc2Yjc2UCtR?=
 =?utf-8?B?WWJ2cHJuSmkxT04vVFhpcUR0MUxhWCtkQmFWNDFMOXdESUhDNGVHT1p2SDJZ?=
 =?utf-8?B?V1VSY3o4TzVNbDN0SG82eG5LbUQxUkJIR1ozdVRUdjB3WWtPSWpmYUxIZ1R4?=
 =?utf-8?B?YzYrcnJLY2twRjJjN1lWUTFiZW1aeVhKajZ1dE9IWnNycWtFRXM2d1RzT0tY?=
 =?utf-8?B?NWt3WjFQWDVEazNQSDhYQVpWQmsrMVpJUTNtTVVrakNhUElkVUVCcEJoaTNG?=
 =?utf-8?B?eTNzN0hqT0dVZ0pyaVNSNUdLc2V1ZE9hc1VwMWRKQm16RFdiSjJOMHpRaFBq?=
 =?utf-8?B?NUp0cU42SDVxU2FQaFpzamo3cWZ3aExBQlZmUHNON0tvZCtORFF1NEQ4Vmk2?=
 =?utf-8?B?UjlBa09FRDI5bnA2WUFlaldMc3d5L3NoRHo5eEx3YzFFSHExRnVDQXgrSitO?=
 =?utf-8?B?aTBBOUx3b0dNQWQ5dHFuUWxyWDdZbklPRHBFM3FBM2h0UEdLOW9VU1ZvN1Zp?=
 =?utf-8?B?MkhPRWlCbWhSNDdNbUtKYVRsaUlsZFcrQ3B5cjF6Z0YxbnEyLzlhdHBWUHlN?=
 =?utf-8?B?eWZHODdudmFnMElMbmtlK3prKzA1MW93OUtzSWloSEpoelJBajNXUWh4VnZn?=
 =?utf-8?B?WVY3THpWN3hBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVZqZUpiVm43QUFDU1MwK2hOSGswaVBRbmdOTWRTTnB3Qy9XSlkvUWpkdGxQ?=
 =?utf-8?B?bER4V280V2FvN051MlNmYnpwUzVVSjY0ZnZZbis2cWt5UkcrN3lTRnFlOHB1?=
 =?utf-8?B?M0FZSHRNQXdYVXFaSU94TnBVUzVkU29aRm9PS2JhM0t5UTdZZEZoSE5ESDFr?=
 =?utf-8?B?c09uMk8wYVZ5TkUyWG0xN2RacFExOWd1bXE0YUhCbUM1MGdtUkJ1aEVIWjJ4?=
 =?utf-8?B?VDBLUURiZEh6Q1h4c1pVOU9DREZ0R1pOR3RMdWgvRTJMUzdXYWdZb1c2OCtT?=
 =?utf-8?B?SWR6UlpnRldzS1FYbUIvTVJ6YzVidkRpK1p6VFVEY2pqL2FvTmd2d1hlOFNQ?=
 =?utf-8?B?b0NlTlJFR2NxWnFkb0dnT21JVkpWMUhBU0dJN28yWXNGeE1nV0VpRjI4UTMy?=
 =?utf-8?B?T3l4b1BFL0NZTnNod0wrd0x5V2x2bG1sNlh5cXhjTzFYUERiZFVHeG5xbElR?=
 =?utf-8?B?emhyMW9DTFoxaFlNR2FVZDFxSW9pb3pmd2IwTEY5M1l1RmVXSFJSQVduZDNM?=
 =?utf-8?B?cFRBMlBTRzZnM3pmU01PbkxxNmFGOEZaNUdINTlaQ21SZzVDY0xpWERjTG5C?=
 =?utf-8?B?TXlFVThmaXdaYUZveDdtOVpFZWl0Z21LaUQxSWNVaGR2MlBXYnZXaVJoTGdQ?=
 =?utf-8?B?ckJxMDhwQ2RvK1FHNHlSOWovM0F6V2syRDdFR0Q3ZU9DdzNmMzI3Yk9BQXVJ?=
 =?utf-8?B?bmhsc2VMSEMxYmlvODk3WFFhbER5QnBodTVUQUZZbXloQi9VRm0xTFJsNW1R?=
 =?utf-8?B?aldnMkpDa1A3aFVCV0FJZi9KTDFjWVVlYm55Y1hDUldyQno1UFVvektwRHUr?=
 =?utf-8?B?aTZ6czNDS0RoWDZMRFJjazNFaFZVOHdMUFdqb0hOQk1ZbXA3MEFLdTYvQm9i?=
 =?utf-8?B?ek11VjhHTEZyaVZDMG1hVWNxbHhaVVJFQW5Hd05EREsrTmxiaVgrZFE4dDJO?=
 =?utf-8?B?SmJyRU1VbEc3ODBsaGNJNDFaR08zUG1Sdm1OMjFwYkdjMFk3bktrcjErMlk3?=
 =?utf-8?B?VzNnWmh0V0FFbnNUQ3F2Y0V6Mi9BSE1RMmZySXltZjJBWm9Ga1B1elRDK3M4?=
 =?utf-8?B?TmJQS3dDV1llTEtTWlhpY04xRVk5aWwyQlBPSVh2ZFN2b1Rqa3ZIOExOTTVm?=
 =?utf-8?B?YjBYUHJ5NXo5S2V0QTg0Y014UUxvVUtlTnZYY0wzREZkMTBFMDN4SU1yWnZ2?=
 =?utf-8?B?clBKaHFaRkpReG5aNDduTnFHYVRBb3hMbXpNalFreXpWQTMrUlJpdEpSS0w0?=
 =?utf-8?B?Tkd4dXcvZ3RsYktMNTFZRUZrTGZEdzFBNkJJb0N3bmZ6dVQyZ3o2eUVGblNx?=
 =?utf-8?B?OXpKWE9EN3ZrQWI5Njc2ZW5MTEF5Y2lORjNGN21DMzcxV0ZmMGFJTy9oWXUx?=
 =?utf-8?B?N1dBbWV5YzRmVC9sNXltL3Z2OXkzVGhPbzJFWmNxdFgwK2daT0hocUUzMGp4?=
 =?utf-8?B?UWRjZDRiVTJBblNGUGc5YzJibW5vMTdUNGl3YndBN1IrMVBuRWZoOHM2Rldy?=
 =?utf-8?B?YkhBQ2MvZHhyUTRPd3U5aGU0T05aeFdxMnZWbkNaNnV6THdRMWg2b1hUSEV6?=
 =?utf-8?B?aG5peXo4M3R4d3RDVHFXZVlBeDFPR0xrUXQvSmhXM1BnL0MrTjgwVGhtdDhq?=
 =?utf-8?B?NktibDVUNkxLYXhNanhEMktxUWpKUktzamZwcWlmeVhsVzlUcXNjNWV5MmJH?=
 =?utf-8?B?di8yS0M3TjRtdFJFNjR0dkZ4a0dsUkl1NzEwYm5qSmM5NWJFbGJyMENXbUdZ?=
 =?utf-8?B?L2N2QWFDWXBVUEFrMDRmc2Y0OXN5OW82R21tN3orWlp2U3ZtR0QreWwvUldI?=
 =?utf-8?B?YTh2Z2VLMXE0L2grNmlvSWQwdzB2WXoxNnQ0OUZPM0xoai9pRFlYK0V5Z0xP?=
 =?utf-8?B?L0JwOEFycnpJUXUyT1JZS2s5citNWnhyV3dIWCtSYkxMQThFSFVCeFpOWHZH?=
 =?utf-8?B?d09PYmVmekhCcldNelR2VW9PVjd3QlFVOFlVZXV1LzVDUWdGbzVXeEhlUUhV?=
 =?utf-8?B?WlA4cnF1Q01Gc1NjbnRsN0FFY0twMnhQRTdpTlo5dUxHOWV5ajY1TExFMEhp?=
 =?utf-8?B?UDgrR29PYkNGREhEbWlhbHZua1VnL2V6S0w0VzVPbDhIZGY5eGhkeWZTWjRD?=
 =?utf-8?B?cWF3eDNxNmc3OHpBajJnQkRLdEtSaUo4RUl5UFpOTmdSNHhzSnVXSXlnYjYv?=
 =?utf-8?Q?/njIv95TyZrxtWXxAEH1j+U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D883AFEE2BA91458047309892CFE8F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d66d81-b6e7-4ca3-4fc0-08dda8f6143d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 14:41:41.1146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6G0scJuQuT6MjO+bn/7ID4tZqeX7aj+uNoOz0rXkhrhoUnVQd+Cun221hZX5ca38kgG0urtd3S6AlNv3IJALE3nfEatF7ydNSAFXSvhtllw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7481
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDIyOjM0ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IFdoYXQgaXMgdGhlIHByb2JsZW0gd2l0aCB1c2luZyB0aGUgZXhpc3RpbmcgZXhpdCBvcHQtaW4g
aW50ZXJmYWNlPw0KPiANCj4gSXQgbWl4ZXMgdXAgY29tbW9uIEtWTSBkZWZpbmVkIGh5cGVyY2Fs
bCBsZWFmcyAoS1ZNX0hDXyopIHdpdGggVERYIA0KPiBzcGVjaWZpYyBURFZNQ0FMTCBsZWFmcy4g
U3VyZWx5IGl0IGNhbiB3b3JrIGJ1dCBpdCBqdXN0IGRvZXNuJ3QgbG9vayANCj4gY2xlYW4gdG8g
bWUuDQoNCiAtIFREVk1DYWxsSW5mbyBpcyB1c2VkIHRvIGV4cG9zZSB3aGljaCBURFZNQ2FsbHMg
YXJlIGV4cG9zZSB0byB0aGUgZ3Vlc3QNCihjbGVhbikNCiAtIEtWTSBIQyBvcHQtaW4gaXMgdXNl
ZCB0byBleHBvc2Ugd2hpY2ggZXhpdHMgS1ZNIHNob3VsZCBmd2QgdG8gdXNlcnNwYWNlDQooc2Vl
bXMgY2xlYW4gdG8gbWUpDQoNClRoZXJlIGlzIGFuIGFzeW1tZXRyeSBpbiB0aGF0IHdoYXQgaXMg
cmV0dXJuZWQgaW4gVERWTUNhbGxJbmZvIGNhbid0IGJlIGJsaW5kbHkNCmR1bXBlZCBpbnRvIGEg
S1ZNIG9wdC1pbiBpbnRlcmZhY2UuIEJ1dCB0aGUgbG9naWMgbWF0Y2hpbmcgVERWTUNhbGxJbmZv
IGxlYWYgPC0+DQpLVk0gSEMgbmVlZHMgdG8gYmUgc29tZXdoZXJlLiBUaGUgZGVmYXVsdCBwbGFj
ZSBzaG91bGQgYmUgdXNlcnNwYWNlLg0KDQpEaWQgSSBtaXNzIGFueXRoaW5nPw0K

