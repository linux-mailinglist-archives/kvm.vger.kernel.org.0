Return-Path: <kvm+bounces-69631-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CN/fCwPce2noIwIAu9opvQ
	(envelope-from <kvm+bounces-69631-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:15:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8D9B537F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 69772301C11A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A986F36AB4F;
	Thu, 29 Jan 2026 22:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YltWumCm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674B82BF001;
	Thu, 29 Jan 2026 22:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769724919; cv=fail; b=VAVIRjWZX8pGz52hbQjuUrihmjLLF8809HvD+PZJhB7CTNUIqJZd+Nuf4cDMFFKITKcPHFGhflsABIFcsBwATikEffhasXU7qU1ne/9ndlUBo2OJ+mw6V9YXw8bz+GXoo2G9/OdWe4rTqFMc75IaCKk1hw0Amt/1CDrqz7OKg5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769724919; c=relaxed/simple;
	bh=O7tXzwavdPATVjhUgD6QpyVgNUDLscKOftmrfhPgIQw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z0qO4wLKSQW0oWECWlXB5VVsnn8pxJ9RZBUVXuaYKzFwwo1NJ1lUD0YVtSpfDH/RiaHqQIK4+SdsW3OVt8kFIU+VkH0GBg/QIKEHH6yhjsS/c30/75ly6LMroFlhtBqHNI/0DqZP9EXACLkjIlm0HRKZAdXmNR1YCoNVf3359vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YltWumCm; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769724918; x=1801260918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=O7tXzwavdPATVjhUgD6QpyVgNUDLscKOftmrfhPgIQw=;
  b=YltWumCm5E3uZEBIOX/3ev5bAGiCIIUwgERAZ9ODeIUXqFeDTWKNmujj
   phpLJp0+gjOreYU9ZZbAVynYUaj/Vh43BWNtTrcSsTONPj0aBNlk71WrY
   wyWYGEGthxi0rd7WUPZIuLlVw54wM2pdPrWOkclrCMlhNSTFhHayz3/Mu
   M1O7Vr4xz9luBPZEFeXZQvY5aVp+uLL0DtqItLNCccvNWh7Qvy27fMglt
   7YQsdJ0DZkkw81v+ZO2TzBAT8xr6mCDkEvbDwxYGCP3Dy7mku5F6UtOzz
   G0DHti1EpYILWF88hyFCj5pPKZqzWFkP15U6PQGrFZPEbAyH469HHiMOi
   Q==;
X-CSE-ConnectionGUID: 9H4UHpxPSgix/GhPB1kq9A==
X-CSE-MsgGUID: V0jhMrWgRYKMSL1olqyhyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70886207"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="70886207"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 14:15:18 -0800
X-CSE-ConnectionGUID: CU3y7vpGS3SCv+wZl+Erwg==
X-CSE-MsgGUID: 1FTlhLv5QY+tI+7X16kBdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="213185046"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 14:15:18 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 14:15:17 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 14:15:17 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.25) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 14:15:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCp+MmvSxDSNr9UQN0T31kyiOwHPjdpZh7J9umHfRMaZSFsdqz8FW1oyVgP6Q07u65kIjiVtZDYcF4fU6FhMeo+x7E1/2KwgKDFKvsZTWr/AsBSVWkR2AbJ/9TMSsKjOaOBsNijrr2DwDs/ymSWkb5IL/fCzNcUHVb2KaemY1422HIu0UqsiA5jXgZO0Ejg+D0BEiJqvImaBAnJ7djifx6/2ntvfQbbK6tCrKDp3+YZzTtdLOyW4B05ck7gNxYubnkh7ANgBZwddPZ4Ty/FzJKP1rgRz50zg0FQOyV+fVEJ4Ht1uV5+CP5rFS9l9GQMySvs4LSkbqtlC91lxL1W5dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7tXzwavdPATVjhUgD6QpyVgNUDLscKOftmrfhPgIQw=;
 b=BbnfsC1uQcO1CjL91NX1YSz040LZLwQ72oKB7w5Tz7MmtULF7qNrMLJwoHO/jKuEpGhD3KE68tudSyVvHou9umh5nksAb5vquHzK0XrZrirJ545e0dERQVYRHlwFB07ujChf1+Rl4U86NBzDx6MLATCoiG+TqJVU3p1LrQkIjj1qfLP2U+A4DOqdIEfmuRjyb7aOSCYeW631EswGf6G/dl+B+X714Rm9kJtX079Oh5ixheeYR6zPBPihTD3QaY1fF5nhDgBJ1mgW/G51w1IOYUM4H3KkpFANI05YdxJmIVHibgZiXSX808OWfC6Lon7To6/9UD5oJkRMtFCnVCnfsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH3PPFDC3198517.namprd11.prod.outlook.com (2603:10b6:518:1::d55) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 22:15:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.007; Thu, 29 Jan 2026
 22:15:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 03/45] KVM: TDX: Account all non-transient page
 allocations for per-TD structures
Thread-Topic: [RFC PATCH v5 03/45] KVM: TDX: Account all non-transient page
 allocations for per-TD structures
Thread-Index: AQHckLzLkXxNUHz4J02f6Uj4ZN6HFLVpt/8A
Date: Thu, 29 Jan 2026 22:15:13 +0000
Message-ID: <9bdcf78f1b21a31e24acb2445250227a80a0a486.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-4-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH3PPFDC3198517:EE_
x-ms-office365-filtering-correlation-id: 1fade447-ef07-46d1-a4a0-08de5f83e01a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YmM4WGI0MlRxNXlyU0dua1JOUlFJTkRBOFZZNjRaRjlYeW9LQWNMUWZxVUcy?=
 =?utf-8?B?UzljWHBaNzhrQXlaRjhOaVpzM3J6ZzZ0aTBOMzI3RFRYZnVTTEdOdW9YZEhR?=
 =?utf-8?B?aTJJcG5EMU9qdUVBUFNMbWJ6T0M2Njh5M0JRenNkdTk3ejRtZXpuOUltcDZq?=
 =?utf-8?B?b2VqOFBYV3RVVStOdkRKV29VY1dING5TLzNmWkVqbDRZWms1bTF1dnd6dlhH?=
 =?utf-8?B?SVZsbTFORjMydDRyUytFU1BzUElvOFk1ZWF4Y29pYldGbStGOWNpSGUxb2RW?=
 =?utf-8?B?TkZsYXZUeituYjlKZ3B4QVo0OWlKUTVrKzFONXNoVHpLQXlmNDBmY1VmTDZv?=
 =?utf-8?B?azhNZHB3bTRDZEJmZ3NvaGdCZU9tdW54M2MzTU5YUXp1MWt5WEFWUnlZSFpm?=
 =?utf-8?B?czN3V1U1STB0dHJRc0hDdjR0K3NJME5IeGswckMxTEJOeE9TVGZDTFBzRlJw?=
 =?utf-8?B?YTRyYkMrTnJYY3dsNFNSSjB5UjN1WWdaSTc3UVNlVmdFa1kwVWlYOUo1d0s4?=
 =?utf-8?B?cVh5R25OK1czRHk0UEhwbm5EekhKRHdGajJSR1BUNjZheFF0SGNmUzZQNTNH?=
 =?utf-8?B?U1BWMVR5dnZ2NGljWjlFeDBvbDhLbzE2aXdLcG9zSjZKSC9GUjVuYlVWU0pV?=
 =?utf-8?B?NnRkUW16eSt4Nngrb2t4MHY3dXRER0toYmVISGRiSGZVeFRmaDFvMkNpYzQ2?=
 =?utf-8?B?ZkY0ZTI3WUxxamUwOFpuc2N2VjAwbWpxNHBpTkc2TVBSbU5WSU5qOTBSTzdN?=
 =?utf-8?B?NW4rU1lhQlg4aXhOeDl5dzA4QTE4WDhoaXZOczcyRU96OWRNQWZUdEQ1L05l?=
 =?utf-8?B?Tk1GSkVJdmJDSFRKQjRpUVJvYkN5dXNXVFE5dHZCUmo2MTR0cmE3d2VST1k5?=
 =?utf-8?B?U1RiYW4weVZDUFdtWWNGRFV3c09mNWlCbksxaFNsMWFqUFBSNzBEUG1hQWlw?=
 =?utf-8?B?d1VhYnNwK3RPb0t3UWpqRjNFWXRaSnEycC96OU4zbVFHelFiNFZxVzhQWllC?=
 =?utf-8?B?UVQwMTZpK05xSzNWZmdraDBVNXNPekszZVo3V0puSGUyS0RmbG85Q2toNGZm?=
 =?utf-8?B?Q1phbDVNTG5POUltMzRrRXEvMktSWUMxWHVXU0w4K1NYZ2VkeE1tZEhMTDhQ?=
 =?utf-8?B?Q2JkQXplNVBiYnZjc3EyMkFNVHRZbXFRU1p0MnFSdFpDa041a1dTdHc3N0xM?=
 =?utf-8?B?QkMvYm9LRExLUXZjNGpZUmUvUmM3NW5yam0rcVNiMzhRMzNWTmI3TTVxRW9R?=
 =?utf-8?B?ejV0RHJ6OWVvSzd5akM5YmFoTFVsUmtVYk5ra0ZhbS9Cc3ZNbkRGN1BxVjRU?=
 =?utf-8?B?RHJZMVFpdFUyU2U0K1AxdkUzRkxvMVF4bkdYTytYMVJjR0xHYzRrdFh2ZFpk?=
 =?utf-8?B?WTNsUkhBWThFSmJOMnkycnZ0RUFiSWdORVVYeHJueU44cWhHWEtmQU9ZS3Vr?=
 =?utf-8?B?aW1PLzZLeHZIblQ4akd5ejNjdTVEZEV0aHYzbm8wc1ViSkY5OFJpNWNpdk5i?=
 =?utf-8?B?VFJrOVVCSVBZU21OWUlrRmxZU2crVExnRWtjRXRUNG1FdHJ0a3lTekJLOVJt?=
 =?utf-8?B?Ni9jQllDak1IRWlzR1VtYlVwWWJtQXVrSEYrenRaclk2NnJDaFI2T1JLNUQ4?=
 =?utf-8?B?bElBb3NMcDExR29yYWFCNk9TV2tiTkFkdUZFdW04R2tkQXo4c2E0VU5UaDFE?=
 =?utf-8?B?VkNwTTRJejdTZkxtTnRmYU1TM0lEcXVmblcxc2podEJnSFRtK2x2emVWR3dE?=
 =?utf-8?B?S2RXQUNncDBpVUtWcVNCZ042RmJ3Ni9TbHQ2OERLV0U5bVd1RnBCS201M2dJ?=
 =?utf-8?B?R0dESVFGSHMzRnZVYTRzRmh2WGRLaGM2YTZyenM2S3N2a2xMcjFNbTdidjBv?=
 =?utf-8?B?K3BmRDJEd2hmME5JeDBkaWRqTGNtZXVMSXdBZUh5ai9IV3FSSTRib0xLYVBt?=
 =?utf-8?B?NUZnajJoUGlXc1pxMjBFaU11dWExVmxKUFNMV1Y3cVNLRVZKU09mSWJRMTJN?=
 =?utf-8?B?YVNqMkRuM2ZHd1c4Z2hESTJ0SU9WdlA0VVVZb1VCU2U5aHVrbUxiN01DNGtN?=
 =?utf-8?B?T2dUVGliYmg1K3RrNEdFS2RQcU10WXBHZzFrWnduN0dTQ2xBejRxVVhrVS8x?=
 =?utf-8?B?emREOHh4cXY1eEFTS2JOTmhJWkQyNnpPenZYYTZ5MkVZdzFSdGYyYkl3L0lT?=
 =?utf-8?Q?RLpNs5KgugTqyv3vmaYkkOo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFBzVlM1ZTgxY1ppcmROZTI1OTkrRlZvTUM4WmhsalJieCt3c20rbVR1eEtG?=
 =?utf-8?B?Z2ZicEpXNGhQSSs5djIxMU9sSzZMcTB2WWRlaXlpTDlDbnpuNlJ5aU8xZjZC?=
 =?utf-8?B?L0Z3b3MrNmU0ZURSNmJSYUV6R0Zhcm56MFhwRDE0WjI3THh5Q0xVRFNIMmMv?=
 =?utf-8?B?Q1FVVmJ1OEJKeTVFZGJwbSs3bVc0a3psTi92eDR3eTVkKzhqRWFLeUdhNmov?=
 =?utf-8?B?d0VpK1NnUTFiTlBWZ0Vid2xrc0prUTNOeHR0UlUrbUI3WEVyUmJlNEhpelIz?=
 =?utf-8?B?Zi91eGdpZUQyKzFrd2VPNVFUNkkrR2lVMEFCeWxRRE1IcVJQYVZzR0p4VEo5?=
 =?utf-8?B?b2llVlE3ajV1OE5yR0lIeGQ1VWw1SFJmRGJNeW93Q1BxMmlHaHVCYjd0K0RN?=
 =?utf-8?B?dElDY3lkQkVCc1dtZkYrcTlSeXlxRExmR0JEakV6OUcvT0Fwa2MyWG05UStB?=
 =?utf-8?B?bVBTQmg5MWpPaGZJTmNNaXowMHd5WnhqOW5IMWlVL1lpYUc2VXRqV252SHFZ?=
 =?utf-8?B?dlVrVWlmNWJwS3Z3cXd4VXNKWG1tMHNxWkJzdnF2Q0xQUFZMc1BnMFRZa2NF?=
 =?utf-8?B?MGg3VXhpY1oyMTBlSnBzRlhUemFCUXNvdkRVS0p0a0U1K3RNL091SE1SUnZt?=
 =?utf-8?B?TmdiUXNLaU9PVVUvTERKQjJqdXpmblBmRFFGdHp2Q0lNbzBRVkpyNmVVUnZP?=
 =?utf-8?B?eHJ3L3ZTQVRGMHBnTm9LM2JrWGhVS01UNFF0VHVFT01INXdQaG5NWHRlZ1Jt?=
 =?utf-8?B?YnRuZ2I4ZGNsYjBPNFBkUk1XaEx3ejBqRVpScm93eHk3SU9uWG5zenV1OUtS?=
 =?utf-8?B?ajBvdExjUHRVVmhFcjV6R2thbVdoUXpBTFNTODN4QlZQOWYzbFZNeUloanZQ?=
 =?utf-8?B?SkE5ZmZTUnYwSHh5Vk1za2pocHNidTZmMVhMWE9paWJMMDNDTUdQbkNua1Vl?=
 =?utf-8?B?Sy9WVWpOcmFDay8xQk5WNHR5ZlkzWWRWUVdNNE41ZEtkazV6Wi9kMllmMzV4?=
 =?utf-8?B?VXh0NW4zbHkxeUs3RmlicHNsUE1BWHZXVkJ6YmxiQWlOV0NoT3duc0FqTjdP?=
 =?utf-8?B?K25sVE5jQTJ4cTNONDFUY2VvNTRxc0FWRlBmSDlMREgxVFNRd0l4QTgzbklG?=
 =?utf-8?B?WkhFVzluOTdYZ0N6ZldSeVpra081K3J4anhyanMwL1pqZlphcjlZN0tyTjFs?=
 =?utf-8?B?Wmx3QVhnVUVZdjlzSDBpM1pSYkZXWkQvYzhqVGRZREs1Y0lhbER1OFFjMUZN?=
 =?utf-8?B?TnRET0FrRlV5dk1BVnlTVmZ5SkdYMnIrdzZETWJwanBBcmRPM1lnTEVmbDBP?=
 =?utf-8?B?cHNpSWs0VElkOXNnZmRKSEdlTzNCMUxMU2laTlpTR0J5OTR1MTFSUEpHTGhu?=
 =?utf-8?B?bXhNdTNJUnBqQVNMLzdXVmNJS0hhd3p3d3FqUXh3ZGVGbm9JZzlQWU16bXpC?=
 =?utf-8?B?V09nc2dLWFZHdFltQ09zRXRxZ3l6dEpEQlFWbldsTC9qbVVQWUhNSjI0cUlH?=
 =?utf-8?B?NDdpNTgxalliM0xnRnZKNEZabnQvSlY4cWVYK2tiSWpiekplTldDaFlUUjlp?=
 =?utf-8?B?MDNHT0Vvcm8yR1FoeU8rMnFjazlVOG05ZzluTk9KTWI0SzFON3VIVysraUcz?=
 =?utf-8?B?RzZGdGJjYlRseDNqVHo5bmUzMmtRcjhkYWZ5TTlpSVlTSDRseGNlZ1I2T0JY?=
 =?utf-8?B?OHQ4bU5ZWXN6QXNBd2hEUWVuOHNCNko2SExyYUptZHJvclNDV3IrZUVBUmI3?=
 =?utf-8?B?MjBiMCt2dUQyMkNsK3d6NG9DaGQ1UzRyVlZvQkkvQ1pubVY0eFZUcjJ3WnI4?=
 =?utf-8?B?SVVMekpFTmVDNHVleCsxVVNRS2xYd2pFSmFnYkRlYUxCcUZDcmQ3U09vNTBR?=
 =?utf-8?B?SGhXV2ttRndrckFJU1d2V3o0ckJ4U3k0bStoa1ZmZytQQUVsQ0xaUzlZQUdM?=
 =?utf-8?B?b2o2ZzhKdG4zWkVmMVZNcGUyemQ3eEQwYjJIc1I5VHVGWEhqM2RlMXhmbjFv?=
 =?utf-8?B?QUROd3BTUDZyOWJtSllWTHlhSGZ4NWFjcXB3UFhSdHM1d21zcHZmZzFuaTBP?=
 =?utf-8?B?bHVMTGVlaTIvanJiUTkxOFl1a1p5VXZiUU1hMkVWdUF3TDN4RWZnQjVKdEJq?=
 =?utf-8?B?RWxIQitYMDhZNjRXVnltZnRYTlQyNWxFbThuM0xVeWFYak9sbCt0RVdKN2hW?=
 =?utf-8?B?RHc0MmVWYWlIMUZvME9kWm9Sd1MzUDN3ODllcno5NHgzSFA0aTFHSTNhUTdo?=
 =?utf-8?B?Uy9GOWZyZHdYemNKN3VVSGtiSFlZVDZWNjhERnZBaWVnMTVoY3ZVN21iSEVy?=
 =?utf-8?B?L3NuSmEwRnJ6YWo2WG9qdWpVVWNmUllGMVUrTk0zUkZHVzgrSnZZZ09BUjV6?=
 =?utf-8?Q?k9vLk5/Axbd+Osjk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71BED3A565FF8A46BD406B8BBB645AA6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fade447-ef07-46d1-a4a0-08de5f83e01a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 22:15:13.8040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: js+aDMZz0TePZfQMvtdDaMcXCd4w4iPwHNMnEEYxG5y4j4cuQVqcUqSRZEWY/yedZcotps8PLAuykBXR4LdhaU2Bu/Ugi7rdkLmVwYXcO9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFDC3198517
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69631-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 9C8D9B537F
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBY2NvdW50IGFsbCBub24tdHJhbnNpZW50IGFsbG9jYXRpb25zIGFzc29jaWF0ZWQg
d2l0aCBhIHNpbmdsZSBURCAob3IgaXRzDQo+IHZDUFVzKSwgYXMgS1ZNJ3MgQUJJIGlzIHRoYXQg
YWxsb2NhdGlvbnMgdGhhdCBhcmUgYWN0aXZlIGZvciB0aGUgbGlmZXRpbWUNCj4gb2YgYSBWTSBh
cmUgYWNjb3VudGVkLsKgIExlYXZlIHRlbXBvcmFyeSBhbGxvY2F0aW9ucywgaS5lLiBhbGxvY2F0
aW9ucyB0aGF0DQo+IGFyZSBmcmVlZCB3aXRoaW4gYSBzaW5nbGUgZnVuY3Rpb24vaW9jdGwsIHVu
YWNjb3VudGVkLCB0byBhZ2FpbiBhbGlnbiB3aXRoDQo+IEtWTSdzIGV4aXN0aW5nIGJlaGF2aW9y
LCBlLmcuIHNlZSBjb21taXQgZGQxMDM0MDdjYTMxICgiS1ZNOiBYODY6IFJlbW92ZQ0KPiB1bm5l
Y2Vzc2FyeSBHRlBfS0VSTkVMX0FDQ09VTlQgZm9yIHRlbXBvcmFyeSB2YXJpYWJsZXMiKS4NCj4g
DQo+IEZpeGVzOiA4ZDAzMmI2ODNjMjkgKCJLVk06IFREWDogY3JlYXRlL2Rlc3Ryb3kgVk0gc3Ry
dWN0dXJlIikNCj4gRml4ZXM6IGE1MGY2NzNmMjVlMCAoIktWTTogVERYOiBEbyBURFggc3BlY2lm
aWMgdmNwdSBpbml0aWFsaXphdGlvbiIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+
IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0K
DQpSZXZpZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29t
Pg0K

