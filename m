Return-Path: <kvm+bounces-57179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEA6B510A0
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 10:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F405463F07
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 08:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5DB314B8A;
	Wed, 10 Sep 2025 08:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ERpAfaj7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1889D30F812;
	Wed, 10 Sep 2025 08:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757491376; cv=fail; b=njVWcvFHYX4kl5E7y9pii7rodilZhM8PWHyPahgkIbfH6Jpd1y1hj189Batl3v4VrKIXB7tMLSkHCJTjMJ9hnN+UqBwSYQPZCMNaMnt9Lv9ZaydUQRxEi49ZcnsQcArasFa0JkepN5ZBFMsqFuYGIQ+jLuaJoPQQVKcyHgdu8ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757491376; c=relaxed/simple;
	bh=grzr/d+0Bl+aPLSSG76RpA7pMDP0VrvDLtmkdT7QJck=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H0XZXYYmHv9E5FG0Q9jOLImye8+v5Zs1LTCghHZ4ibQW5dOVUf7Pt2ncQUWyLjBWQzkcdCzvxzAwC93PD4FnRNVtH4tCX+Y83LmnU6Xa+oXLYSs+9EJMSLtmkD/FbVJVCkQWWoZsjODdMF2bR7GldmQIUs5R51/r05RcmJfVYLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ERpAfaj7; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757491374; x=1789027374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=grzr/d+0Bl+aPLSSG76RpA7pMDP0VrvDLtmkdT7QJck=;
  b=ERpAfaj7/xTM2z1nPVJODa4Prluoul7xE2f1kSJdqhP0nnLn1hihCfYn
   c3ho6+dXQAXHPImVGdKxkvzZGhg5o0Zkv79VH+2AaYIiC0EjQx9X/Ed2v
   XlZjdCg5SK5vWlExcGJKQwNOxf4FiRL4Mun+wbnat0rry+upA0H0wWmCZ
   RLjmOlvcncm6GWQq3L8wIRHU6ko5pJo73BCyDlTeEOn0aNgWfE9SAYwV5
   IxMHk5cN9zjADuMHtoHvGbOETaqkHWJ6H1HGDl1139I9xIGvGlap1pLwo
   OAeRaB/GR25oRDS0TuN1L3nkdy/HYwV3PXYMAzKXHQ9dMxiHD4hoOf8bu
   A==;
X-CSE-ConnectionGUID: YAjVqFd4RY6K/aOgBdo4rA==
X-CSE-MsgGUID: 0LbOn4FgSl2cGoQIbEtakw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="77401250"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="77401250"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 01:02:53 -0700
X-CSE-ConnectionGUID: tVZ3cVqBTYe0ndeWOEke4Q==
X-CSE-MsgGUID: 1x+3RkQoTaaDZSpL5IPSHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="204084958"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 01:02:53 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 01:02:51 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 01:02:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.60) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 01:02:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xX4Wf+dkAMgHumZSSn7su3s8mmjzRgZ3BMA7u20zZ4oxkNcVQ2pkkJS5uS/X22VU4Zm5/8Fa67PoSY9w7Z4bLF3woBev7zAdHhJiLtLME4vPpmCc94UO+lM6iv8eJo0eu7rUJ6Jsq1MrVNC6HYJsc/BcsiKF7D/L8X7Rsw+LM3mRumRyeMAg4IYuvjybMkFmpfyUXbeIz1PQWF8bjz6gK7SObMvyPAD1/2CvrhFPudL9QGDU+0Wf2AOBIgXrNyzYzxAeta110DH1eAhMRpDw7gkbMvjY1aNCLgHioihj2tvcteRES8d+6t89ayWa958uTZTvHL9wefH2G/TRFuRCvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grzr/d+0Bl+aPLSSG76RpA7pMDP0VrvDLtmkdT7QJck=;
 b=ws5eMdC25W8hBci2bqxqqZYndYjxtfjgLIaCmI2/OPvV2lblMOfi6+Q04NPkwTULzuiw3cznrDRYuyUOAJV3TYpFVfqbnsKnXtanQTaRhrwFzPcWui4wyrkuf8Vci2Q5mWGNy+YRjho+E3zXgm9jmhjzUFkrafVfUTPbO6NpmigH+mDQpbrhKt4XYorUXkGHcy0tYbI53CZtU0xtIB2fIt++T+0C/ZW+ALkCtNMUieXTEKAduxVrQmilu8/aAi41DSQzi5pSIZ2OM2gWlakWW6gxQR5G5JzwpP4K8nDAB084nY0BcPiD70bOO1wrr3xgvJQ45sk0gBAmgbxFVid1Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BY1PR11MB7983.namprd11.prod.outlook.com (2603:10b6:a03:52b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 08:02:47 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 08:02:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "xin@zytor.com" <xin@zytor.com>
CC: "brgerst@gmail.com" <brgerst@gmail.com>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "pavel@kernel.org" <pavel@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "kprateek.nayak@amd.com" <kprateek.nayak@amd.com>,
	"rafael@kernel.org" <rafael@kernel.org>, "david.kaplan@amd.com"
	<david.kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: Re: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
Thread-Topic: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
Thread-Index: AQHcIbhd14UC0LurTkGsI74DGd7tB7SMDyGA
Date: Wed, 10 Sep 2025 08:02:46 +0000
Message-ID: <1301b802284ed5755fe397f54e1de41638aec49c.camel@intel.com>
References: <20250909182828.1542362-1-xin@zytor.com>
	 <20250909182828.1542362-2-xin@zytor.com>
In-Reply-To: <20250909182828.1542362-2-xin@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BY1PR11MB7983:EE_
x-ms-office365-filtering-correlation-id: 4d9de674-60a4-44e0-4098-08ddf0406d99
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?czlKRStiRGJhdWx2bzFlSExpbVIrbHpVbUxZQWhQZlgyQUpPeG05RTg2SnI4?=
 =?utf-8?B?ODJGS0liYzF0cE9qWHpnUjZLTjdPNXc3b2FnZkpoS0JaNDlFMEtRZVFZblZD?=
 =?utf-8?B?Rm1MZ05IZWdEZU9uemFGTGVFQnF1cHhZZDdTSm1JcGE5NWhMOWNDNnN0L2FK?=
 =?utf-8?B?VjgrdVdMTjhhd2NWSGwzVzl3ZENjaFpaMjdTd0E5eWkvaU14dUhqTzZmV2Nv?=
 =?utf-8?B?RHh6bHZFRWhVTlFkM1ZsVGVYVE1rUW1uR2FBY3JHS242TFc2YmZ2K2d4RjJL?=
 =?utf-8?B?cHE4K0l6aml5THJPV3loSWVLeXpaSUttdU9YdU5VS3I1UWNPV1Y0RWRqejZQ?=
 =?utf-8?B?R05HSHN5K0l2YTZXcWRiUVUxMXIyaitWRitTbzhEajdoN0ZZbVE4TEg0dVFI?=
 =?utf-8?B?NlJWUGQ1eHhHMlNFMGwxeHZGN0oveFZIL1VuYmNrUWVMYXZtdDZCSytabDZq?=
 =?utf-8?B?K0VaVWVtYmozbUU4RTNSWG9rdW1ldDMvaWVKaXVWQ0dVUWZQcFl1d0VJMVBM?=
 =?utf-8?B?eVYvY0t2dk1CNUhPS0hYREFVeUFnS3NJamVtUnVrcDhrenZ4dlFzRk5zRDA2?=
 =?utf-8?B?a1l4a3BlN1BGa1JQNlFIdW4yaVNTSnNwN0JaZExSNFg1K1IwaTVKL2dLM0dS?=
 =?utf-8?B?U3dBNWtRY3pRWFo4c0VvV3FRMk1NR28vaG5vdEJkamdxaGtRVFNCb0hKQnRy?=
 =?utf-8?B?UlVONVgrR2cxM0hTRU1BemJFVkk5cmVLd0VMM2lyQXRpOVlONmovbmtkRloz?=
 =?utf-8?B?N2ZwdWJvSWJyRktTNzFZeXdwL3U0WTNiZStJNmQzTVV4Tmd4a1VibWJKdVFi?=
 =?utf-8?B?VjJ2OFVXblhlWEpGbDdrNjNhVHFWR0dzQlF1Q0xuclhNa1BnVFhGT1RVS0ZT?=
 =?utf-8?B?dEEzdUg4RFFCK0VaQnlNUVdsOGZRM1RxME9Mck9qUG5WYzB0cWZQNHMzdGYz?=
 =?utf-8?B?ZWFhM1JydWJQTVZtN3lxdVQ0SHlXT2FIVlhlL3oyZWFjTnhzRXNHUk1ERCtZ?=
 =?utf-8?B?WWN0YURycER6R3ZxaG9ycloxY2h2SGlHUnBDV2V4RUVsb2Z6K2RZK1I0ZmF2?=
 =?utf-8?B?MVhtKy93bU90eDM1QTgyQWRRWUtBZTlKMUMveUpRUnpsY0FxcUZBMER5dlgx?=
 =?utf-8?B?UFphTVQ0Y2h1VWFOMk9tWHNkMTNVcGxldTIvWTl0bFpreHVmOUVrVWY5WURG?=
 =?utf-8?B?LzVrNjc5OHlNZVJ6NFFJVmJ0UURyUzJPMFJ2UUFVdGh5N245NFdyZnJiNWwv?=
 =?utf-8?B?OWJqUVpSUUQ4U1RWYjZLaFljNmJreGhLSXFqTURRNHJkcUNZRnNwQUdqQ0Jm?=
 =?utf-8?B?dERqR2VkR0NFTUtLVng2OTNUQVMxd3NlYWI0N1V4VnBqaVlLM3ZvY1pwdmd4?=
 =?utf-8?B?RmxheWdFb292b2UrR29mYUI4cTBPckt0QVc1NEZxUnIrbVFjTTU3ZE1PV0k5?=
 =?utf-8?B?bjRkNXY2Z2o3Qit2WjYrYWZvQ2xKbTVVanU4eGh2RjhGb2NsVUlJTy9TVEV1?=
 =?utf-8?B?cHJVOFhhbFB2UERCdjgxc054dWpLNERMSlZXVm5pbUgycDZFbzFRQXJsZVR0?=
 =?utf-8?B?MUg3b1JuVHYwRm8ra3lFcmhmUmxzRXBWbWF1eVp0TjlWVDhPdm04MXE3emZF?=
 =?utf-8?B?dGtjbm4xQ0d1NmxXMEFxcDUzQlVLNkZnWi9YbkFsbVAvMm5uQ1doRllzWnVt?=
 =?utf-8?B?T1BJWU9ta1E3N2pONzVyL1NaWFc1SGUzdWJTL2NSM09lZXgzZkNDem11WFY3?=
 =?utf-8?B?Mnc5c2toSUJqRWtCWHNUR1FkKzdOVkxidmJCVFV1NGxWU2Z5eFBya1NVOG1t?=
 =?utf-8?B?TDhiM1B1NmFPMXM1Q1NKcXhtWm9QSk4vaVVYQ2FWa2dOYXBPQ2NlL2tRMGNV?=
 =?utf-8?B?NXNMZHJLTThnbEVrYzM0MjJTWkhqczdmcThSdnIyYWI1UXRObDNMZGhBRGxR?=
 =?utf-8?B?MEZvNkFPcDlnNkttZzZhQTF5c2xWcEg4b2FlN0JZa1drZ0hBbHpOd25qUE9a?=
 =?utf-8?Q?fakrS+bVUFsg+C1d0wtlFE2wg8AiFk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFlZY3ZoS2UxcW14M0dtdDFWQ0dxN0o2bTdjcGZTVzhyc2hSeFAydDdZQnZO?=
 =?utf-8?B?ZTBYVGVIZ2R0d2xpTHZBWklhb3F1YUxWKy9jYmJ6K2Z1RnMxdVZkTlB2c0dz?=
 =?utf-8?B?S0V1NmhjMVNrd2crRkx0clhLUVN6Y1RhcWZCQUp2QlFmVHF1cHV5cEtmVHlQ?=
 =?utf-8?B?QVRYWDV2Mm04QTFxdXYvbk5UOE5Gb3VVSGNVVEh2RXZ0MnYxVUhybitoc1BJ?=
 =?utf-8?B?QkYzYlhEanNkNFplSEdNZjM3M3d1UjhBSmR0dWdFb3R3VUZyNUZDL2QzTm02?=
 =?utf-8?B?dEM3QnFRTHlIVXU3bGFQaTlwRUJSS0xPdG5LTDdqci9aUnZXYXFqczdJSGtR?=
 =?utf-8?B?VlFyV3ZTVVRKZmc4VWpXR0JpaUtnclptSlpmYWpHdnhwVzk2RUtuQ3RHa3p5?=
 =?utf-8?B?SDloUklUMFJkbGhSL2ZDK3VIbTNJZ3FDYTlGQUpuai9NWUpCNkZFVWhtMUcw?=
 =?utf-8?B?OElvS1hRWGJKQ0dZZEp1TUlOTFIyN2VKUkI0SDh5bk1WTnAzZWNYYTM1cTlv?=
 =?utf-8?B?bzJpYVBuZHRHNWpqWXFXaWw3Qm1FVVAzZytvNkNYbzVaYitVQS8xejFMWE5I?=
 =?utf-8?B?ZlkzZkw1RFJEZFVacm1rY0Q4Z0I0Q01aUUxzenN0YUZLc3ZXVGdHekkveUIv?=
 =?utf-8?B?UUVZbkdUSlFKekdzSVkxRnZmQXNPZnpDTjNKNzJRT2J2eEoxcnhwMDFQRUhD?=
 =?utf-8?B?MkRFS3ZnSFZtajVxekllMEpjUXBDdzRwcVppemJXMzhQeE9lSGRCS1VHeGpE?=
 =?utf-8?B?Q2pLaUJQclcxVDlJaVBJd0p6bW9PU2tjVGpmZnhieURWVkxYS2J5ay9IZzN3?=
 =?utf-8?B?aktpQTY5L2NtL1BNL080UzNhQkU4K0ZwZkFaVmRydCtqaHJ0RER2S1NSeFdH?=
 =?utf-8?B?MEZGZExoSUx5K1U2bldhOWNCQk43RzZKMW9EbjFXcW1GdUI4WkRGMUxlRlJK?=
 =?utf-8?B?dGVoaGhxWXZWTlEzaEdObnkrUzRpODM3V3dpWmlYUTgxaFFiQ1NLZGlHSlJn?=
 =?utf-8?B?THVlaTVXQzhPdTRxdDVXNS9aNm9rQzZ6THhINHp3cUNaL0JnbGlLeUFENzgw?=
 =?utf-8?B?cnR2alRxTjJiV0N2SktkM2ZXWGZkWmdhN2RjUTRjRmlGVXhreXBNaHlod1FQ?=
 =?utf-8?B?eklVUVZhTVYrem00SGZ1K2NKUkxmUXBkSmxNcWpacEZnMjE0VDd6WW1GV3cr?=
 =?utf-8?B?clJrMjlJcnVNc01SRUJMNFJNZTZnTG8rNEpiaCtPZElYckdoRWduUEJxRUdE?=
 =?utf-8?B?djdZMmNlWm5Rd3lxWWVmWDN3K3ZYZklWWmM1K3gvMTA2ekkwNHlpK08yRHNU?=
 =?utf-8?B?VFdOSmxETHhkUlpOOEgxL3Vid3Zzd0RocFVzVjBxZmkvMXd6cDBKanE0ZU1a?=
 =?utf-8?B?VmN4c2VEYnZFTEpTbXZjWlVjVSt6a0lGanNzdWNHT1ZBNUh0RTY0bGM2NVg5?=
 =?utf-8?B?aWlIS2pBck42U3liQ3FSZkIzbEFRaXV3ZTFuaTFhWmk5VE9XT0s4bnA3amtp?=
 =?utf-8?B?TEROM1htUFVrYVIrbjlab0FPWDk4VFVWSlZVSVJIaWZRb3FUSGt4dmc5emRh?=
 =?utf-8?B?U1NKUnI2SXNnWXdnY0IvdFQxdjV5TzdhNk9XUHZLYzVCcXMvNkhsNUdJSkcr?=
 =?utf-8?B?RTdDV2QxdGIyaUNTL3VaT0JFN0hvb0lhRGVaTkMrUnBONmFWODlsYisvSXJo?=
 =?utf-8?B?QXBTRFl4dVFCbmFHUy9tbDRsS3ZvS0hYaVh3aGtaM3kzaG1UOFAydUlpclJR?=
 =?utf-8?B?MXZFaEd6c3VNeW4wMjV3TzhZS1B2MkhnMFlXaTZ1aTU0bmYzNzRrM3luTDM2?=
 =?utf-8?B?N3RrLy9zakNlWU83MmkvZVlKRzVxZDg3R2dYS1VoRWROSjl3WnJjcnNudE1T?=
 =?utf-8?B?SHV1WThWQ3F0elViWVdzQndycndwbHJ2eHo1Z1Y4TE9uR2E5c1FoSGxWUHZx?=
 =?utf-8?B?TWNJUXdkYy9MekxOb0tCTFdpWTBHT3YrdEVNTVdoQjBOMjRKZnNMY1JnK1Bx?=
 =?utf-8?B?U2t5dHpOeXFEOW1zOVBqeVNxaVRsN2hSTHhmN2lDTWtVZHBiUUZrSW5tWjBP?=
 =?utf-8?B?NWtMS3NEL2hjTExFR1JIU1FnOVpZd2FKZERmeU1ZQUFwYlRHUE5LclJYWmp5?=
 =?utf-8?Q?LE3SwieWf+4UmK9Ek/xY26vrI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62C32D1E61145D4E820D469B9013EB3C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9de674-60a4-44e0-4098-08ddf0406d99
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2025 08:02:46.3746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +snlj+MyjDyl1khMsNV02V0Od6HPHxubjk083jhVndBs8FYmJfpTlsYjVlJACBA8kBVpOyrD9QwcEasxGF8RVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7983
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTA5IGF0IDExOjI4IC0wNzAwLCBYaW4gTGkgKEludGVsKSB3cm90ZToN
Cj4gTW92ZSB0aGUgVk1YT04gc2V0dXAgZnJvbSB0aGUgS1ZNIGluaXRpYWxpemF0aW9uIHBhdGgg
dG8gdGhlIENQVSBzdGFydHVwDQo+IHBoYXNlIHRvIGd1YXJhbnRlZSB0aGF0IGhhcmR3YXJlIHZp
cnR1YWxpemF0aW9uIGlzIGVuYWJsZWQgZWFybHkgYW5kDQo+IHdpdGhvdXQgaW50ZXJydXB0aW9u
Lg0KPiANCj4gQXMgYSByZXN1bHQsIEtWTSwgb2Z0ZW4gbG9hZGVkIGFzIGEga2VybmVsIG1vZHVs
ZSwgbm8gbG9uZ2VyIG5lZWRzIHRvIHdvcnJ5DQo+IGFib3V0IHdoZXRoZXIgb3Igbm90IFZNWE9O
IGhhcyBiZWVuIGV4ZWN1dGVkIG9uIGEgQ1BVIChlLmcuLCBDUFUgb2ZmbGluZQ0KPiBldmVudHMg
b3Igc3lzdGVtIHJlYm9vdHMgd2hpbGUgS1ZNIGlzIGxvYWRpbmcpLg0KDQpLVk0gaGFzIGEgbW9k
dWxlIHBhcmFtZXRlciAnZW5hYmxlX3ZpcnRfYXRfbG9hZCcsIHdoaWNoIGNvbnRyb2xzIHdoZXRo
ZXINCnRvIGVuYWJsZSB2aXJ0dWFsaXphdGlvbiAoaW4gY2FzZSBvZiBWTVgsIFZNWE9OKSB3aGVu
IGxvYWRpbmcgS1ZNIG9yIGRlZmVyDQp0aGUgZW5hYmxpbmcgdW50aWwgdGhlIGZpcnN0IFZNIGlz
IGNyZWF0ZWQuDQoNCkNoYW5naW5nIHRvIHVuY29uZGl0aW9uYWxseSBkbyBWTVhPTiB3aGVuIGJy
aW5naW5nIHVwIHRoZSBDUFUgd2lsbCBraW5kYQ0KYnJlYWsgdGhpcy4gIE1heWJlIGV2ZW50dWFs
bHksIHdlIG1pZ2h0IHN3aXRjaCB0byB1bmNvbmRpdGlvbmFsbHkgVk1YT04sDQpidXQgbm93IGl0
IHNlZW1zIGEgZHJhbWF0aWMgbW92ZS4NCg0KSSB3YXMgdGhpbmtpbmcgdGhlIGNvZGUgY2hhbmdl
IHdvdWxkIGJlIHRoZSBjb3JlIGtlcm5lbCBvbmx5IHByb3ZpZGVzIHRoZQ0KVk1YT04vT0ZGIEFQ
SXMgZm9yIEtWTSAoYW5kIG90aGVyIGtlcm5lbCBjb21wb25lbnRzIHRvIHVzZSwgaS5lLiwgbW9y
ZQ0KbGlrZSAibW92aW5nIiBWTVggY29kZSBvdXQgb2YgS1ZNLiANCiANCg0KWy4uLl0NCg0KPiAr
c3RhdGljIGJvb2wgaXNfdm14X3N1cHBvcnRlZCh2b2lkKQ0KPiArew0KPiArCWludCBjcHUgPSBy
YXdfc21wX3Byb2Nlc3Nvcl9pZCgpOw0KPiArDQo+ICsJaWYgKCEoY3B1aWRfZWN4KDEpICYgKDEg
PDwgKFg4Nl9GRUFUVVJFX1ZNWCAmIDMxKSkpKSB7DQo+ICsJCS8qIE1heSBub3QgYmUgYW4gSW50
ZWwgQ1BVICovDQo+ICsJCXByX2luZm8oIlZNWCBub3Qgc3VwcG9ydGVkIGJ5IENQVSVkXG4iLCBj
cHUpOw0KPiArCQlyZXR1cm4gZmFsc2U7DQo+ICsJfQ0KPiArDQo+ICsJaWYgKCF0aGlzX2NwdV9o
YXMoWDg2X0ZFQVRVUkVfTVNSX0lBMzJfRkVBVF9DVEwpIHx8DQo+ICsJICAgICF0aGlzX2NwdV9o
YXMoWDg2X0ZFQVRVUkVfVk1YKSkgew0KPiArCQlwcl9lcnIoIlZNWCBub3QgZW5hYmxlZCAoYnkg
QklPUykgaW4gTVNSX0lBMzJfRkVBVF9DVEwgb24gQ1BVJWRcbiIsIGNwdSk7DQo+ICsJCXJldHVy
biBmYWxzZTsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gdHJ1ZTsNCj4gK30NCj4gKw0KPiArLyog
SUEtMzIgU0RNIFZvbCAzQjogVk1DUyBzaXplIGlzIG5ldmVyIGdyZWF0ZXIgdGhhbiA0a0IuICov
DQo+ICt1bmlvbiB2bXhvbl92bWNzIHsNCj4gKwlzdHJ1Y3Qgdm1jc19oZHIgaGRyOw0KPiArCWNo
YXIgZGF0YVtQQUdFX1NJWkVdOw0KPiArfTsNCj4gKw0KPiArc3RhdGljIERFRklORV9QRVJfQ1BV
X1BBR0VfQUxJR05FRCh1bmlvbiB2bXhvbl92bWNzLCB2bXhvbl92bWNzKTsNCj4gKw0KPiArLyoN
Cj4gKyAqIEV4ZWN1dGVkIGR1cmluZyB0aGUgQ1BVIHN0YXJ0dXAgcGhhc2UgdG8gZXhlY3V0ZSBW
TVhPTiB0byBlbmFibGUgVk1YLiBUaGlzDQo+ICsgKiBlbnN1cmVzIHRoYXQgS1ZNLCBvZnRlbiBs
b2FkZWQgYXMgYSBrZXJuZWwgbW9kdWxlLCBubyBsb25nZXIgbmVlZHMgdG8gd29ycnkNCj4gKyAq
IGFib3V0IHdoZXRoZXIgb3Igbm90IFZNWE9OIGhhcyBiZWVuIGV4ZWN1dGVkIG9uIGEgQ1BVIChl
LmcuLCBDUFUgb2ZmbGluZQ0KPiArICogZXZlbnRzIG9yIHN5c3RlbSByZWJvb3RzIHdoaWxlIEtW
TSBpcyBsb2FkaW5nKS4NCj4gKyAqDQo+ICsgKiBWTVhPTiBpcyBub3QgZXhwZWN0ZWQgdG8gZmF1
bHQsIGJ1dCBmYXVsdCBoYW5kbGluZyBpcyBrZXB0IGFzIGEgcHJlY2F1dGlvbg0KPiArICogYWdh
aW5zdCBhbnkgdW5leHBlY3RlZCBjb2RlIHBhdGhzIHRoYXQgbWlnaHQgdHJpZ2dlciBpdCBhbmQg
Y2FuIGJlIHJlbW92ZWQNCj4gKyAqIGxhdGVyIGlmIHVubmVjZXNzYXJ5Lg0KPiArICovDQo+ICt2
b2lkIGNwdV9lbmFibGVfdmlydHVhbGl6YXRpb24odm9pZCkNCj4gK3sNCj4gKwl1NjQgdm14b25f
cG9pbnRlciA9IF9fcGEodGhpc19jcHVfcHRyKCZ2bXhvbl92bWNzKSk7DQo+ICsJaW50IGNwdSA9
IHJhd19zbXBfcHJvY2Vzc29yX2lkKCk7DQo+ICsJdTY0IGJhc2ljX21zcjsNCj4gKw0KPiArCWlm
ICghaXNfdm14X3N1cHBvcnRlZCgpKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwlpZiAoY3I0X3Jl
YWRfc2hhZG93KCkgJiBYODZfQ1I0X1ZNWEUpIHsNCj4gKwkJcHJfZXJyKCJWTVggYWxyZWFkeSBl
bmFibGVkIG9uIENQVSVkXG4iLCBjcHUpOw0KPiArCQlyZXR1cm47DQo+ICsJfQ0KPiArDQo+ICsJ
bWVtc2V0KHRoaXNfY3B1X3B0cigmdm14b25fdm1jcyksIDAsIFBBR0VfU0laRSk7DQo+ICsNCj4g
KwkvKg0KPiArCSAqIEV2ZW4gdGhvdWdoIG5vdCBleHBsaWNpdGx5IGRvY3VtZW50ZWQgYnkgVExG
UywgVk1YQXJlYSBwYXNzZWQgYXMNCj4gKwkgKiBWTVhPTiBhcmd1bWVudCBzaG91bGQgc3RpbGwg
YmUgbWFya2VkIHdpdGggcmV2aXNpb25faWQgcmVwb3J0ZWQgYnkNCj4gKwkgKiBwaHlzaWNhbCBD
UFUuDQo+ICsJICovDQo+ICsJcmRtc3JxKE1TUl9JQTMyX1ZNWF9CQVNJQywgYmFzaWNfbXNyKTsN
Cj4gKwl0aGlzX2NwdV9wdHIoJnZteG9uX3ZtY3MpLT5oZHIucmV2aXNpb25faWQgPSB2bXhfYmFz
aWNfdm1jc19yZXZpc2lvbl9pZChiYXNpY19tc3IpOw0KPiArDQo+ICsJaW50ZWxfcHRfaGFuZGxl
X3ZteCgxKTsNCj4gKw0KPiArCWNyNF9zZXRfYml0cyhYODZfQ1I0X1ZNWEUpOw0KPiArDQo+ICsJ
YXNtIGdvdG8oIjE6IHZteG9uICVbdm14b25fcG9pbnRlcl1cblx0Ig0KPiArCQkgX0FTTV9FWFRB
QkxFKDFiLCAlbFtmYXVsdF0pDQo+ICsJCSA6IDogW3ZteG9uX3BvaW50ZXJdICJtIih2bXhvbl9w
b2ludGVyKQ0KPiArCQkgOiA6IGZhdWx0KTsNCj4gKw0KPiArCXJldHVybjsNCj4gKw0KPiArZmF1
bHQ6DQo+ICsJcHJfZXJyKCJWTVhPTiBmYXVsdGVkIG9uIENQVSVkXG4iLCBjcHUpOw0KPiArCWNy
NF9jbGVhcl9iaXRzKFg4Nl9DUjRfVk1YRSk7DQo+ICsJaW50ZWxfcHRfaGFuZGxlX3ZteCgwKTsN
Cj4gK30NCj4gKw0KPiAgLyoNCj4gICAqIFRoaXMgZG9lcyB0aGUgaGFyZCB3b3JrIG9mIGFjdHVh
bGx5IHBpY2tpbmcgYXBhcnQgdGhlIENQVSBzdHVmZi4uLg0KPiAgICovDQo+IEBAIC0yMTIwLDYg
KzIxOTksMTIgQEAgdm9pZCBpZGVudGlmeV9zZWNvbmRhcnlfY3B1KHVuc2lnbmVkIGludCBjcHUp
DQo+ICANCj4gIAl0c3hfYXBfaW5pdCgpOw0KPiAgCWMtPmluaXRpYWxpemVkID0gdHJ1ZTsNCj4g
Kw0KPiArCS8qDQo+ICsJICogRW5hYmxlIEFQIHZpcnR1YWxpemF0aW9uIGltbWVkaWF0ZWx5IGFm
dGVyIGluaXRpYWxpemluZyB0aGUgcGVyLUNQVQ0KPiArCSAqIGNwdWluZm9feDg2IHN0cnVjdHVy
ZSwgZW5zdXJpbmcgdGhhdCB0aGlzX2NwdV9oYXMoKSBvcGVyYXRlcyBjb3JyZWN0bHkuDQo+ICsJ
ICovDQo+ICsJY3B1X2VuYWJsZV92aXJ0dWFsaXphdGlvbigpOw0KPiAgfQ0KDQpBRkFJQ1QgaGVy
ZSB0aGVyZSdzIGEgZnVuY3Rpb25hbCBkcmF3YmFjaywgdGhhdCB0aGlzIGltcGxlbWVudGF0aW9u
DQpkb2Vzbid0IGhhbmRsZSBWTVhPTiBmYWlsdXJlIHdoaWxlIHRoZSBleGlzdGluZyBLVk0gY29k
ZSBkb2VzIHZpYSBhIENQVUhQDQpjYWxsYmFjay4NCg0KPiAgDQo+ICB2b2lkIHByaW50X2NwdV9p
bmZvKHN0cnVjdCBjcHVpbmZvX3g4NiAqYykNCj4gQEAgLTI1NTEsNiArMjYzNiwxMiBAQCB2b2lk
IF9faW5pdCBhcmNoX2NwdV9maW5hbGl6ZV9pbml0KHZvaWQpDQo+ICAJKmMgPSBib290X2NwdV9k
YXRhOw0KPiAgCWMtPmluaXRpYWxpemVkID0gdHJ1ZTsNCj4gIA0KPiArCS8qDQo+ICsJICogRW5h
YmxlIEJTUCB2aXJ0dWFsaXphdGlvbiByaWdodCBhZnRlciB0aGUgQlNQIGNwdWluZm9feDg2IHN0
cnVjdHVyZQ0KPiArCSAqIGlzIGluaXRpYWxpemVkIHRvIGVuc3VyZSB0aGlzX2NwdV9oYXMoKSB3
b3JrcyBhcyBleHBlY3RlZC4NCj4gKwkgKi8NCj4gKwljcHVfZW5hYmxlX3ZpcnR1YWxpemF0aW9u
KCk7DQo+ICsNCj4gDQoNCkFueSByZWFzb24gdGhhdCB5b3UgY2hvb3NlIHRvIGRvIGl0IGluIGFy
Y2hfY3B1X2ZpbmFsaXplX2luaXQoKT8gIFBlcmhhcHMNCmp1c3QgYSBhcmNoX2luaXRjYWxsKCkg
b3Igc2ltaWxhcj8NCg0KS1ZNIGhhcyBhIHNwZWNpZmljIENQVUhQX0FQX0tWTV9PTkxJTkUgdG8g
aGFuZGxlIFZNWE9OL09GRiBmb3IgQ1BVDQpvbmxpbmUvb2ZmbGluZS4gIEFuZCBpdCdzIG5vdCBp
biBTVEFSVFVQIHNlY3Rpb24gKHdoaWNoIGlzIG5vdCBhbGxvd2VkIHRvDQpmYWlsKSBzbyBpdCBj
YW4gaGFuZGxlIHRoZSBmYWlsdXJlIG9mIFZNWE9OLg0KDQpIb3cgYWJvdXQgYWRkaW5nIGEgVk1Y
IHNwZWNpZmljIENQVUhQIGNhbGxiYWNrIGluc3RlYWQ/DQoNCkluIHRoaXMgd2F5LCBub3Qgb25s
eSB3ZSBjYW4gcHV0IGFsbCBWTVggcmVsYXRlZCBjb2RlIHRvZ2V0aGVyIChlLmcuLA0KYXJjaC94
ODYvdmlydC92bXgvdm14LmMpIHdoaWNoIGlzIHdheSBlYXNpZXIgdG8gcmV2aWV3L21haW50YWlu
LCBidXQgYWxzbw0Kd2UgY2FuIHN0aWxsIGhhbmRsZSB0aGUgZmFpbHVyZSBvZiBWTVhPTiBqdXN0
IGxpa2UgaW4gS1ZNLg0KDQooYnR3LCBvcmlnaW5hbGx5IEtWTSdzIENQVUhQIGNhbGxiYWNrIHdh
cyBhbHNvIGluIFNUQVJUVVAgc2VjdGlvbiwgYnV0DQpsYXRlciB3ZSBjaGFuZ2VkIHRvIGFmdGVy
IHRoYXQgaW4gb3JkZXIgdG8gaGFuZGxlIFZNWE9OIGZhaWx1cmUgYW5kDQpjb21wYXRpYmlsaXR5
IGNoZWNrIGZhaWx1cmUgZ3JhY2VmdWxseS4pDQoNClsuLi5dDQoNCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L3Bvd2VyL2NwdS5jIGIvYXJjaC94ODYvcG93ZXIvY3B1LmMNCj4gaW5kZXggOTE2NDQx
ZjVlODVjLi4wZWVjMzE0Yjc5YzIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L3Bvd2VyL2NwdS5j
DQo+ICsrKyBiL2FyY2gveDg2L3Bvd2VyL2NwdS5jDQo+IEBAIC0yMDYsMTEgKzIwNiwxMSBAQCBz
dGF0aWMgdm9pZCBub3RyYWNlIF9fcmVzdG9yZV9wcm9jZXNzb3Jfc3RhdGUoc3RydWN0IHNhdmVk
X2NvbnRleHQgKmN0eHQpDQo+ICAJLyogY3I0IHdhcyBpbnRyb2R1Y2VkIGluIHRoZSBQZW50aXVt
IENQVSAqLw0KPiAgI2lmZGVmIENPTkZJR19YODZfMzINCj4gIAlpZiAoY3R4dC0+Y3I0KQ0KPiAt
CQlfX3dyaXRlX2NyNChjdHh0LT5jcjQpOw0KPiArCQlfX3dyaXRlX2NyNChjdHh0LT5jcjQgJiB+
WDg2X0NSNF9WTVhFKTsNCj4gICNlbHNlDQo+ICAvKiBDT05GSUcgWDg2XzY0ICovDQo+ICAJd3Jt
c3JxKE1TUl9FRkVSLCBjdHh0LT5lZmVyKTsNCj4gLQlfX3dyaXRlX2NyNChjdHh0LT5jcjQpOw0K
PiArCV9fd3JpdGVfY3I0KGN0eHQtPmNyNCAmIH5YODZfQ1I0X1ZNWEUpOw0KPiAgI2VuZGlmDQo+
ICAJd3JpdGVfY3IzKGN0eHQtPmNyMyk7DQo+ICAJd3JpdGVfY3IyKGN0eHQtPmNyMik7DQo+IEBA
IC0yOTEsNiArMjkxLDkgQEAgc3RhdGljIHZvaWQgbm90cmFjZSBfX3Jlc3RvcmVfcHJvY2Vzc29y
X3N0YXRlKHN0cnVjdCBzYXZlZF9jb250ZXh0ICpjdHh0KQ0KPiAgCSAqIGJlY2F1c2Ugc29tZSBv
ZiB0aGUgTVNScyBhcmUgImVtdWxhdGVkIiBpbiBtaWNyb2NvZGUuDQo+ICAJICovDQo+ICAJbXNy
X3Jlc3RvcmVfY29udGV4dChjdHh0KTsNCj4gKw0KPiArCWlmIChjdHh0LT5jcjQgJiBYODZfQ1I0
X1ZNWEUpDQo+ICsJCWNwdV9lbmFibGVfdmlydHVhbGl6YXRpb24oKTsNCj4gIH0NCj4gDQoNCklm
IHdlIHN0aWxsIGxldmVyYWdlIHdoYXQgS1ZNIGlzIGRvaW5nIC0tIHVzaW5nIHN5c2NvcmVfb3Bz
IGNhbGxiYWNrIC0tIEkNCnRoaW5rIHdlIGNhbiBhdm9pZCBjaGFuZ2luZyB0aGlzIGZ1bmN0aW9u
IGJ1dCBrZWVwIGFsbCBWTVggY29kZSBpbiBhDQpkZWRpY2F0ZWQgZmlsZS4NCg==

