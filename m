Return-Path: <kvm+bounces-43231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 440A0A88035
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 14:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23CF3189600F
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 12:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF228635D;
	Mon, 14 Apr 2025 12:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PXkRiVqD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01CC29DB78;
	Mon, 14 Apr 2025 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744632930; cv=fail; b=TmX0AgghwWvdYfJgdB0EF6Hr0nG4jyNWOFVTu5RgMxA0LtkYqBnXn7s7uk3PAmuAEzq/ow3GgccVeZ4TKGRe4VS7f6BfSDdlAj8/gbgITmGy+6qQlMW0evICJAMSvaWPN/FExqBOVUSh2LpPWSqtU8xCz1qDWuFZkjsLiQ7JUGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744632930; c=relaxed/simple;
	bh=WyQobNXACcRqbf6nFWj23I8n6AZUiJJLbDYjzFVOSTI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mnwN+b8AWlwIb6BrhttTWlIRCKPJ0yWmTAGo9GQxi9BxlSRMtOPd5zVKZXsO+hkXCLB14tpux1shDz5UBRi/j+Oar4gtPGpqbrrA2ndmimlwm9j6K6xTODJIBiiC2KxvDXSCYjPeIOhPhlg5BYxNBl8+vNCLUL2Kr0J4BpWh8ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PXkRiVqD; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744632930; x=1776168930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WyQobNXACcRqbf6nFWj23I8n6AZUiJJLbDYjzFVOSTI=;
  b=PXkRiVqDcMuEH3jzk5sxVvLPLSeeyXFr5F4prJn6CWxp9BglJF7e7ySk
   5Rt77QzXXikrsyEIAskU4h3dMGI8ETCrUGgzux7FIW0H/esvXuQnWAdCo
   38BLTP0pNG7nvMdKdamoKeBVVIoRZr4CPSRz6F09zco5uy0TrBr/R2dX2
   REQSHUC5LSPCPM+cPS83biHG7vWSkquyvRLfDzblrwZNz1HnSYhQBgqDm
   9WOqCm1ksqj2uSvhA12tK4qJr1ujV523VZsxEE42czQn1cgbLeBrsrelB
   9GubrUrz3CCr8BmnrMyPmBXptTdKdeYKZbwdq+IKVgrxIZh25ha5jEFD+
   w==;
X-CSE-ConnectionGUID: 7pc1wzvgQKSvHpT8o8YZfQ==
X-CSE-MsgGUID: IJ7ui2EEQPGWbr0/0CD3aQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="46188944"
X-IronPort-AV: E=Sophos;i="6.15,212,1739865600"; 
   d="scan'208";a="46188944"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 05:15:29 -0700
X-CSE-ConnectionGUID: r0NrX/buR7uBtIIswsbfKA==
X-CSE-MsgGUID: BUs0kpbwSHeaHVddJK1YWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,212,1739865600"; 
   d="scan'208";a="129766794"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2025 05:15:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 14 Apr 2025 05:15:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 14 Apr 2025 05:15:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 14 Apr 2025 05:15:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hof0sTKSGpHpTPrxnPWK71q6+HZyCihLxZ90GQBiqXvdNtgzILQ1TOLvZiP1uAITaolIXBNkW1UGi9J5IqnyxV0EQTsfe2SPFiPfjPR/njOeyjQ84ZZv3jqL5yOhY56RczqCUt8hO6048xwu18t8yxgD/UFSMq3i5fzoXY86Se2e8glXRlQi/qwO610/GykhfJefNl+f0WQrQSUB5L8w7LY+8DiruqJRAXhhM5lvZvL7Nnj1XrjCN6/6qqAlzk7QDkVR1K3+0A2OhtVowPxhzFQ4RHbC/ppmwhKcS7WpnYKjABi1JsEF9ldhqfTaR+KQ6GdD9HpjcqRJEwsJiU6bfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyQobNXACcRqbf6nFWj23I8n6AZUiJJLbDYjzFVOSTI=;
 b=tiFMUKq7JllI/0gAAjyazeljNAaKOha7SYJBpG1Ynh0fYYqMN+1n28oiSqmoCNRI+aiMCGjM/JoQLaVnnxcRrJL0iMnNQedNiSTx7VULmxqrPrD/q3vRs7OxoycRFm5E5lHoWmerQEhau1sGplIs/jH7p9vDj+CMMmY3Kph8uhqvlBs45AXaxDE+IqTBLMC935+2aWbw8DTNav3AI3bfHUdZLJW3XxT7SZpilxk4inJA7qsNsGSr6xOduypJEX+/s7ZOM7OFsJi2xFBBDjngdjE4d5ZEVRPmdJxnw8N5BADcDQtSyYr7xPWxr1pv0qtdF8os3eAKFhpkpc6rhHZU0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6478.namprd11.prod.outlook.com (2603:10b6:8:89::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.29; Mon, 14 Apr
 2025 12:15:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 12:15:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Thread-Topic: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
Thread-Index: AQHbnMYXLpF+MXvWuk+lHsbQWRH5lrOdjP+AgAC1wwCAAIlugIAEaAyA
Date: Mon, 14 Apr 2025 12:15:23 +0000
Message-ID: <616212d3261c3c3213bced1fdb6b2f0982c55928.camel@intel.com>
References: <20250324140849.2099723-1-chao.gao@intel.com>
	 <Z_g-UQoZ8fQhVD_2@google.com> <Z/jWytoXdiGdCeXz@intel.com>
	 <Z_lKE-GjP3WQrdkR@google.com>
In-Reply-To: <Z_lKE-GjP3WQrdkR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6478:EE_
x-ms-office365-filtering-correlation-id: 7a2f9d51-4f13-4c64-5d22-08dd7b4e08ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bFRkRnR5QWhwb1ExZWJ4QjJwQkFhd3lHYWNNWDl3MEgzemRCUFdCZ0d3Z2Vq?=
 =?utf-8?B?eTYzdEwyNldyaUcycmoyZHY5VVgwS21BYURxTzJHUERreEh5eVMxMm1VelZL?=
 =?utf-8?B?bWxVK1BzSW1OL3dYeXp3dGR2bjZSaEVsRmZDaFZLUXVEYnBINTR3WWxOaTFW?=
 =?utf-8?B?VDNBNTk4TXl4YmEwTmpJbldMb2VOaW5VZlkyNWhPN2RueUliSkxCSEhoTm53?=
 =?utf-8?B?OVc0Q2ExbUlhRzF3Tmp4b2RseXViMEV0S2ZvK2o3cHorU2ZuQURVdWdmZ0hC?=
 =?utf-8?B?Smp6VG9ENEFRdDIvSXBad2cvT3ZaT0F2YzJzbFlOTXVLc0tibE52ZDB3U0tL?=
 =?utf-8?B?K3ZxS1I4blZnOWR2UnlldFZRSnQrZ0QxS3U5N2g4TkRic2VqTnJDdU4xSzh0?=
 =?utf-8?B?cklGVEV1RS9GaDhKRDNUZEZLbDFJcmUzb3pST3ZFSTVNcDNvVEkwQWp6WTNt?=
 =?utf-8?B?WUgwTzNjUTU5S05WSVd1MVprM0FPQStPNnljQlZ2VDJZUGVLcnZKSVJiTm1K?=
 =?utf-8?B?WWxZTjlnRkFocWtYWjhwUjl0eVo2dkRiOFpMYzQ4WU5YZVV5eWpERWxXb1VC?=
 =?utf-8?B?YmZ4SlFHcUJOUjEzbjhCZUxSV3RMM3pFbFc4RVB5VksrSUMzb3BaUGZ5OEk2?=
 =?utf-8?B?ZE03V0pFSzdVVThjWlMreWwvaTBSd0RRc29CZ2hYL2puTmlPb0FPUm83MjhM?=
 =?utf-8?B?UE0vVkVveW5qZkIyeVhNNVplWVkwM2JZeWUwaWk5dzF0UTI5Z0pEaEpJZEE0?=
 =?utf-8?B?b1NybE5pQk5YdmxkMjdYOHgwVFNFQ2ZGM3VwcDRpNmErMUNiaVBpWldrNzRC?=
 =?utf-8?B?eVBPemtxWUhmb2xUNXlaK2tiUE1RS1l6L0FxOVRUcXg0b3ZvMy9DbVU4YnQ3?=
 =?utf-8?B?YjY3NDBkOXEvZVk5YTlUYktjTEtjRTRMMVM2R2JQd1ZQQ2FEcUFCWmt0UFls?=
 =?utf-8?B?WE9PR0FMUFVFOXJPR2pPWEpGcjE5eVBTNkQ0SUJrb3pFbnQ5ZDVHZXZxRllj?=
 =?utf-8?B?SXBncWdpTVhzN3UwMFJqYnB4aCtsNHF4d2ZNMTJ3aHdya1lwRG55bkxIS3ZE?=
 =?utf-8?B?RWhhRXlZU1hQQklaY01BUWpQelh6WHhXWEEzRlVPQTMxcjBzVXdmS0YyZEt6?=
 =?utf-8?B?dUNqdXptRHdKR0FQcU5XZm5NZTRDSHNBYmFuM3ljUW5pbkJnYi9QcGdRWU96?=
 =?utf-8?B?M1Y0YWdzdVFSWkdVSDZ5V2NUbkt3VW5udEl4aGd2SkU0Nzh6cm1xT0h5NmY0?=
 =?utf-8?B?aWdtTlVlV3RzZHVsUHFjNTNPbzc0d2ljamNKMytlOVdZbkIwOEZ3VTRlUDFo?=
 =?utf-8?B?dGVIY2JrUUtGYVdOUkpFOEJ1Q3haU0RxZDdJTTFGUW1jTVNheS9MeXhzSDd2?=
 =?utf-8?B?OWhmTHB2SWNzYzlwOXErVmJON3BtNlE1bDRhd1lSaTUveTMzR0sydFpCdmZv?=
 =?utf-8?B?aVMyRmcvbkV6VDVINmZycHc5SW1aTyt5MktlWDdtcXFxQmZCMkJmYUtxVFNt?=
 =?utf-8?B?K1AyZk9FdzljKzJPSWlISEVHY1BXS0swZlBJMlFnNVZaSVNGbk0vYWtDZnBm?=
 =?utf-8?B?cktEaWJZZVAyZkE1U2VNcHcvV3VvRUNzNjFDWHV3ejFZRDNkclhaOVFDRG9s?=
 =?utf-8?B?ZHg2UU5QbEV5T2FmblM4VGZIQ2ZwUlljY3dtRGw3ZHNrNi9qWXJ1VHIyT0RC?=
 =?utf-8?B?OW9UQ01qYjgvWUsvTGNZVFM1SEdLV01GNXlTL1JGNE5XcWFIRTAvc2t2N2Rk?=
 =?utf-8?B?WTJZNUhEYUVybWRCVHZURjZac0hvZkYwS0cyTHlTN0tRY3h2SkNaVWJoTG9J?=
 =?utf-8?B?aHpVSWo5blNTa3dEc0NQbXNBS3NORy8vMndVVEh1MHhqdWlqSzBWemxubHk4?=
 =?utf-8?B?U2l3dVI0a1huTmVTM2R4Yjdjd2NWbzBkZWQ0Ti95TUhDcjlPNWM0UmRFSzZ2?=
 =?utf-8?B?ZE1jZGhGbU81RGFEZG1rMk5iY1kwVkkyZm8zR1VwZ1VIKzBoMUVHeHFYVHgx?=
 =?utf-8?B?R2g5QVhMRjJ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXRpWEprQUNDc0FpM25halo4WkpsV2I3akRDenBSTkJ3UG5rY1hNTTZvYXBY?=
 =?utf-8?B?WkJ5WU9NWHEyc3lrbzlsRDhWVEk3ZElaUkpuOExrbEpobHBPREJOdFY5ajNC?=
 =?utf-8?B?Z0VjVksvVUlkRThmbEg0Z0N2azh0NnVGaHpGQ0dQNXJJTmFFSElhbDJMMEh5?=
 =?utf-8?B?RmpMYXpiaVIrQTVQYm5rTE5iVEFDazlITDVzWU1Ock9Bb0IvaURtc2VTZjln?=
 =?utf-8?B?M1kvR0ZIaUNuZytnTlJrdGdVaUkySkRzZk93V25PSktXVU9Fb1hpMjhDbTFv?=
 =?utf-8?B?MFB4NTROVUtXQnBGbk94VFNzeG53WXhKU0ZBdGl4QzhzTit0NHpWb2NBOGk2?=
 =?utf-8?B?NFAyNm54czRxbUtXbGJia2VaU253eFZ2VC9FYnJzRlRJVnRiNjhxNnpxakha?=
 =?utf-8?B?MUxJZkwzUFBsb0k0QzJxeHhsWnlTc09aTWRDbTBTQnljSUQ0T0RDSHh2Y000?=
 =?utf-8?B?dm90TkdwWjR5NWJwNXJkVHMxcUUxT2ZZSG5EVDVZWVVqWW5EVkdzQ205ZGtJ?=
 =?utf-8?B?LzRJRVRRTW1qNGcySCtab0ZsWVowaEtwejdGaitScFV0QzdYUVU4MU16cjJn?=
 =?utf-8?B?SWxyZS81ZUhsWmI4eDUxT0ZwekxDT0FQdXRpRkNWOXpYYk1SOFA5Y3BtSzZv?=
 =?utf-8?B?aFFUMVhUODFZbmxCTk9WOEJSNXpMYzNta0lReElPbnNGVGFQdms2a0oyRjQ1?=
 =?utf-8?B?dXBldkxGNFJzK2t0OU1OdVBScVQ0a1gxaDVZb3o1WFRkRXVaQS9hTE1hc0lz?=
 =?utf-8?B?bnMzckJvK0hITlNkODE1UDJvbHZmcjRUbU9rZVJUTlN4OTRmYk9xYjkrdW80?=
 =?utf-8?B?VVhGcWFqdzBaMWFnYjlWWDJrQzBRaURFZ2cxR3ZmSTZiQTVZdDhzTHpJWkcr?=
 =?utf-8?B?dVJoSWZpN01LekVjWlQ2QnJLYS8yaGtRbFR5MEV1N3YzbGo0TE9mMG5RcVVJ?=
 =?utf-8?B?S1Y5V1VsTVUySGM3akV2VXlXU2Jwc290bHQwVmU5Z3F3UHlnOWZtR3V3NW5J?=
 =?utf-8?B?ci91ektJbk1wblVkRUpSTExPMWZyYTV6am5KNUhQRWdYTVA1dURYczdoTHVy?=
 =?utf-8?B?TXRZRnFuREdYamQ3QUFXVG1LT0lIZDJpbk5zWlRtNWRGdmRoOGJlSFFUcVh1?=
 =?utf-8?B?T0lxRW5Gd3N1aW4rMllkb3lnbllYd24wYW5JV2xnWU5MNUxjaDRQYThRbkdW?=
 =?utf-8?B?QVRnY0JtZ3F6aU5oam5VTnc4MVljWjVNL0xjUFhIcExwdU5CYXAzQjlxazlW?=
 =?utf-8?B?MEZMR1ZzVHNPemxRWm9MK1YvMk5LNXB5b2VNckkwWEw0Nm5mbERxVDVNVkd6?=
 =?utf-8?B?WjBwR1A1MU1UNFpTLzd0dnhmNTdMOEhSSm4yNmNJTGhkYndHMFdITklGVXU2?=
 =?utf-8?B?UEVYZ1d5eW12WE82Y0ovbkp5M3p2clNxVzNycWlKR0ZWTktJNnpnb0VDS2xi?=
 =?utf-8?B?QUo0dDJERk1JUGUwbVFRWnFGNmhSU0VTY1pqeEhpN1ltQy9MT3FZSmk3dkFD?=
 =?utf-8?B?N2hnMXdyOXlhS2Q0eVRkR2VYQXdOSzZTTzluRjdrMnk4UkREdU42TEpqR1Rn?=
 =?utf-8?B?eVozK2J4ZVdMNkZXakdNL1VuNVd1Y1QyM2pGUVNzZG14SGJmbWZpY0Vyb3NX?=
 =?utf-8?B?OEFJZFlLZ3dnUHQ0c09PcXF0Rks0TkczWHFWMHpYY2tHZXZ4WWVWRkVGNE5I?=
 =?utf-8?B?NS8xUnNEWlZvWXJFSHJlRERrSGhXcGo2aHhRTVJ3OGRjNXJvN0dpQXExYVVs?=
 =?utf-8?B?RkFQd3R3K2EwMW16Mkt3ZzVmYno0RlVWd05oNzE4TVlRR2xPZWlndWpsQWMx?=
 =?utf-8?B?U3pCSTNQamZOcTRhdGhaQWJpUkdMcGNlMU5LRGt5aGRaVVVNdFBmbXNDZG5t?=
 =?utf-8?B?M05VYTVCSnFlS3dvczAxMHByREdKTGQ4UHRrUGRHZXYrVnMzclA0em5xY09w?=
 =?utf-8?B?ajVsYnFRTjVFN2tNM3dRVzNLZ3Zxb2Q5UC85UFNjVDhQVXhVOTJva3prRStZ?=
 =?utf-8?B?NTlYNmJJd1ZDdzBTT1VnbGJPaFFFRVRZbE1EY3QwM3RuY1FXR2ozelYvaHZk?=
 =?utf-8?B?SlgxbFNLTXdINEJLSU9IS3cwYjQ0alBKMW9uZjFkSVB3aFRLZUIrdEd4ZHJJ?=
 =?utf-8?Q?jcgIdwT7xc5Ow8f3avTx965CH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09EADE8E7D00564EA5EBE5BDB774AA2E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2f9d51-4f13-4c64-5d22-08dd7b4e08ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2025 12:15:23.9719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hvRls8Dcd4JTGTQcizuRnOYOLn/3qYSdwzzbrPdabtrLAVaoHUGOx89gLGENEhh9hCClh9YyI2XTaPyikeI4Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6478
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA0LTExIGF0IDA5OjU3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gDQo+ID4gPiBPbiBhIHZlcnkgcmVsYXRlZCB0b3BpYywgZG9lc24ndCBTUFIr
IG5vdyBmbHVzaCB0aGUgVk1DUyBjYWNoZXMgb24gVk1YT0ZGP8KgIElmDQo+ID4gDQo+ID4gQWN0
dWFsbHkgdGhpcyBiZWhhdmlvciBpcyBub3QgcHVibGljbHkgZG9jdW1lbnRlZC4NCj4gDQo+IFdl
bGwgc2hvb3QuwqAgVGhhdCBzaG91bGQgcHJvYmFibHkgYmUgcmVtZWRpZWQuwqAgRXZlbiBpZiB0
aGUgYmVoYXZpb3IgaXMgZ3VhcmFudGVlZA0KPiBvbmx5IG9uIENQVXMgdGhhdCBzdXBwb3J0IFNF
QU0sIF90aGF0XyBkZXRhaWwgc2hvdWxkIGJlIGRvY3VtZW50ZWQuwqAgSSdtIG5vdA0KPiBob2xk
aW5nIG15IGJyZWF0aCBvbiBJbnRlbCBhbGxvd2luZyB0aGlyZCBwYXJ0eSBjb2RlIGluIFNFQU0s
IGJ1dCB0aGUgbW9kZSBfaXNfDQo+IGRvY3VtZW50ZWQgaW4gdGhlIFNETSwgYW5kIHNvIElNTywg
dGhlIFNETSBzaG91bGQgYWxzbyBkb2N1bWVudCBob3cgdGhpbmdzIGxpa2UNCj4gY2xlYXJpbmcg
dGhlIFZNQ1MgY2FjaGUgYXJlIHN1cHBvc2VkIHRvIHdvcmsgd2hlbiB0aGVyZSBhcmUgVk1DU2Vz
IHRoYXQgInVudHJ1c3RlZCINCj4gc29mdHdhcmUgbWF5IG5vdCBiZSBhYmxlIHRvIGFjY2Vzcy4N
Cj4gDQo+ID4gPiB0aGF0J3MgZ29pbmcgdG8gYmUgdGhlIGFyY2hpdGVjdHVyYWwgYmVoYXZpb3Ig
Z29pbmcgZm9yd2FyZCwgd2lsbCB0aGF0IGJlaGF2aW9yDQo+ID4gPiBiZSBlbnVtZXJhdGVkIHRv
IHNvZnR3YXJlP8KgIFJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB0aGVyZSdzIHNvZnR3YXJlIGVudW1l
cmF0aW9uLA0KPiA+ID4gSSB3b3VsZCBsaWtlIHRvIGhhdmUgdGhlIGVtZXJnZW5jeSBkaXNhYmxl
IHBhdGggZGVwZW5kIG9uIHRoYXQgYmVoYXZpb3IuwqAgSW4gcGFydA0KPiA+ID4gdG8gZ2FpbiBj
b25maWRlbmNlIHRoYXQgU0VBTSBWTUNTZXMgd29uJ3Qgc2NyZXcgb3ZlciBrZHVtcCwgYnV0IGFs
c28gaW4gbGlnaHQgb2YNCj4gPiA+IHRoaXMgYnVnLg0KPiA+IA0KPiA+IEkgZG9uJ3QgdW5kZXJz
dGFuZCBob3cgd2UgY2FuIGdhaW4gY29uZmlkZW5jZSB0aGF0IFNFQU0gVk1DU2VzIHdvbid0IHNj
cmV3DQo+ID4gb3ZlciBrZHVtcC4NCj4gDQo+IElmIEtWTSByZWxpZXMgb24gVk1YT0ZGIHRvIHB1
cmdlIHRoZSBWTUNTIGNhY2hlLCB0aGVuIGl0IGdpdmVzIGEgbWVhc3VyZSBvZg0KPiBjb25maWRl
bmNlIHRoYXQgcnVubmluZyBURFggVk1zIHdvbid0IGxlYXZlIGJlaGluZCBTRUFNIFZNQ1NlcyBp
biB0aGUgY2FjaGUuwqAgS1ZNDQo+IGNhbid0IGVhc2lseSBjbGVhciBTRUFNIFZNQ1NzLCBidXQg
SUlSQywgdGhlIG1lbW9yeSBjYW4gYmUgImZvcmNlZnVsbHkiIHJlY2xhaW1lZA0KPiBieSBwYXZp
bmcgb3ZlciBpdCB3aXRoIE1PVkRJUjY0QiwgYXQgd2hpY2ggcG9pbnQgaGF2aW5nIFZNQ1MgY2Fj
aGUgZW50cmllcyBmb3INCj4gdGhlIG1lbW9yeSB3b3VsZCBiZSBwcm9ibGVtYXRpYy4NCg0KSSBh
bSBub3Qgc3VyZSB3aHkgd2UgbmVlZCB0byB1c2UgTU9WRElSNjRCIHRvIGNsZWFyIFNFQU0gVk1D
U2VzIGluIGtkdW1wPyANClJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB3ZSBkbyB0aGF0IG9yIG5vdCwg
SUlVQyB0aGVyZSBpcyBubyBoYXJtIGV2ZW4gd2Ugc3RpbGwNCmhhdmUgU0VBTSBWTUNTIGNhY2hl
IGVudHJpZXMgaW4ga2R1bXA6DQoNClRoZXkgYXJlIGFzc29jaWF0ZWQgd2l0aCBURFggcHJpdmF0
ZSBLZXlJRChzKS4gIFN1ZGRlbiB3cml0ZSBiYWNrIG9mIHRoZW0NCmRvZXNuJ3QgbWF0dGVyIGJl
Y2F1c2Ugd2hlbiByZWFkaW5nIHRoZW0gZnJvbSAvcHJvYy92bWNvcmUgdGhleSBhcmUgZ2FyYmFn
ZQ0KYW55d2F5LiAgQW5kIElJVUMgbm8gbWFjaGluZSBjaGVjayAoZHVlIHRvIFREIGJpdCBtaXNt
YXRjaCkgd2lsbCBoYXBwZW4gZWl0aGVyLg0KDQo=

