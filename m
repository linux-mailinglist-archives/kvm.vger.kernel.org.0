Return-Path: <kvm+bounces-26438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D305974737
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46588287783
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0735579C0;
	Wed, 11 Sep 2024 00:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W+nuF1nz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D82EBE;
	Wed, 11 Sep 2024 00:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726013966; cv=fail; b=XyhTMlAg1UUycNA9lYp1UZlxNPIjt/9DGMHJgRMFUdBXhC01jGLa3JBM/lk22A38LgoaZptX8OrbsbCKQEf1c2rjhuZLXo8NtcmL1aAmHKQIRWsVtsuk325fkvMPgPfWuWV7vGdGHoIiD5kmqRXOqTpxyCCjp20G3/H4IRCBfcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726013966; c=relaxed/simple;
	bh=eJZBNjxynvJ0Egs3DPJKPijsBGhU6x7lBfApuYKrwNU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eOvFarQ6BUmx11yfBZjBHieOpBDBrVvVEMmnWsyncAJl1oBYt9ovc94N6fmiDW//o8NHOyo39TRyDt1hifSe7SG1VDjbDZ3/+3i7CDCObX7KR2uPhVfu0rHk6cI7QXbTkpflmHgoPlLRorRLwi//2Y/EFsLSa6u1f+yNVhrIOHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W+nuF1nz; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726013965; x=1757549965;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eJZBNjxynvJ0Egs3DPJKPijsBGhU6x7lBfApuYKrwNU=;
  b=W+nuF1nzVs6rpgT9Hbduq+f7jlUnpDh64cApRVvLjtL42cZz1A3c4fFi
   ZyLHNXqx4Hvq0Bg/2T9OjRXOK9Cl8X4Y0EWJkW1hhXz6WVc5LhgQTNFeE
   GrNJPNIlMKEJTgTkoFSq6NEEEtYgwgXaenF41BjzYkZBw5qRTiLgdoeMe
   P2Eesuc5cFa6q3w02JHxeyWQI3MhYtKipu1GdOmuu61J3jX1S9udWoHit
   bIHGNRBHYrTLHAWlf/y4/326tIcS/9WvEXXDZMGNYt2cEnQBQmAHr1LnC
   X5urw6ik7UYu5kC+uEw3c3MZmhCHd/mPOD7KoAtl71dd6mN+/VslFOjBK
   w==;
X-CSE-ConnectionGUID: 9bJu8p5CTkmhg3yguNPtaA==
X-CSE-MsgGUID: +Aflsc4URaKus0eFQefM1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="24612104"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="24612104"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 17:19:24 -0700
X-CSE-ConnectionGUID: dD7KgOaOQj24wB0lN7Dt+w==
X-CSE-MsgGUID: qnc7bT0vSay00bGvVaRQdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="104659361"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 17:19:23 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:19:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:19:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 17:19:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 17:19:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hUHy+4+aeo+ntJv1GtLfpEYZOgiMvxSfUiH7xhOtHldpKqLRXcdXeds/Y3s/+Bp2lK3aYrYYeO24yrzEjKbYiMOmatpVZwBg9T5ZbDSJU2DERcTomfk0SOmwgCyLEFdXalfLcsAE3oB/vzwI9UpyD7T993QBQv22iB5F1ZKUOyBwMfuiQwhcfaqxUKqsZmf4NwjpJ0oOAwFZtiS+EENVId9yo30V+MQ8AasCCh2TLG1Muv7exc86XNNxwwlJg4tzpB6z3IknUzg2RnIIbYljnURLCnbsxrWHAivbpFAstAYDHAVxT2S141mU3MzG7y/WnwnGF6lp1szZxOd0ivkalQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJZBNjxynvJ0Egs3DPJKPijsBGhU6x7lBfApuYKrwNU=;
 b=IFBtwH1DSGO838QmEnD4h6nAZLlIlrI/OmBh6kvqZ+Bo0Yv8OdL85wLNjw2hf4IsacH8OtASc4hYw8YBAfYPdxUJ8FmCa0JE1Wa4994vcpq5iV5ZkW/+Yy3X8Hfx5IRvqY5pnbTIrP68vJOO6W505m6S+uL3XZ0wpH/js4idK6kNighF6pd6xI+4iaLg9NHlC4J0QHBed2Dpl1nFM7Ln+KG5YxCZSKOvKE907SZm1ibCYjPWg1ADKRD5TWXaELB+RmjmpDyJbiwHtO/ERPfQXHSzm2uhXIvhQwe5met3A7uUrYbSHuG6bJOVK84Y1DvzODBR1+4H2KzRauTbx/Tvog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6148.namprd11.prod.outlook.com (2603:10b6:208:3ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Wed, 11 Sep
 2024 00:19:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 00:19:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Thread-Topic: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Thread-Index: AQHa/neylxoaYrTILUWaulhlDyL5EbJQ2kkAgADpRIA=
Date: Wed, 11 Sep 2024 00:19:20 +0000
Message-ID: <32a4ef78dcdfc45b7fae81ceb344afaf913c9e4b.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-17-rick.p.edgecombe@intel.com>
	 <6d0198fc-02ba-4681-8332-b6c8424eec59@redhat.com>
In-Reply-To: <6d0198fc-02ba-4681-8332-b6c8424eec59@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6148:EE_
x-ms-office365-filtering-correlation-id: 11c902c7-32c0-4f56-b363-08dcd1f761b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V2RnODVJMzVnMm9hVWl6NHM5dTJ4MTNBUHg0VDhuSzVnL2lmSVNNeGpZQ3lZ?=
 =?utf-8?B?cHhycDdMc3NkeUJSRFdydlVQaHNDY2dkNktYR1VBMllpdG1PU3A2WUdlN0V3?=
 =?utf-8?B?MGxieHBURWlHTEhMM0hsZmp2cDFPenhpc0p6dnBtMlR3UUlqakwwL0ZFQWpo?=
 =?utf-8?B?THIyS3V5U0IxclF2N3dzZ1d6bzRWT2tUTUJwTUgzQlU4SWNqSng3YWxPcXJw?=
 =?utf-8?B?Rnp4TlRLZjlrZ2E5cDNQaTdTbkN5Y041NkdGK0Rab1dvbXArQ253TUphNTZY?=
 =?utf-8?B?aVlJeHk1dXpYUGZXT09IRThsbWVQQW52bElTenRmQ2JuUEc0Y25ML3NvR0o4?=
 =?utf-8?B?SUNySWpOMUFaNHpPbWNWNlJ3TUtvU2NtYmFTaGU4OVU1dmtob0toMWtrUGhI?=
 =?utf-8?B?SFpRSnByaFVSdWdMUFZBUjZQNlBnc2tWZTc2RHJPblZKcDBiV0NRNCtTMWd1?=
 =?utf-8?B?b0pVb2luTFVBeHp2QUxhbkR4R2wxbHlGSHVSdmFtdDlFL042cTBVN3IrRnV2?=
 =?utf-8?B?L2ZYUzMrMkVHMGs1UTVyd1c0b1NYRDZqaFl5amdKRFNNU1BJT3RiQUxWejBN?=
 =?utf-8?B?OENjZlRDcUJxMHBEcis3VzZubkRSVy9rbmxNbWpUNDNobFlLWGIrZWo1K3FN?=
 =?utf-8?B?Zk9NcDZ5RlFINlZMMTR4ajFvdzhCUElsV21FcUdUNTlOeVEzSUxSdU9ucVZa?=
 =?utf-8?B?RzVzZG96ZS93UUdXaEQ1cEdFSklKOEUrQ2Z1TStoN05XNVhUd1N4clBtYjEr?=
 =?utf-8?B?aStpZzNNZ1dMZERhQUxmaUNrZ1NhZmhkSnRnck8xTERvdVYzRVBVMDBRTUVC?=
 =?utf-8?B?WDlEbjFDNlNnUjlWK05CZWlPZGRQTDh0cXN1UUI5RTZqZVoxaWZvYVBJVUJG?=
 =?utf-8?B?blRTOFhJK0NGL1ZuNlRkYVJVWHhQY3BvVGd6Zm5FVXovbDJBcUZUcFdIeDFT?=
 =?utf-8?B?WVhNekVsRWxOVWM5RXorVk1VS2lXRVpMSyswaDFiNzFzM2s4OEl1VzhxaVRu?=
 =?utf-8?B?MkU3R0FhZk5BeTYwTFMrSFYrdTRLSy9LT01GWm9ldGNKNkd0ME16Nm9idERr?=
 =?utf-8?B?THhZQUpyS09RZzVoY3hrMEJjanROL3VGOXZweis3OVI0dUJXR3c4clQwM0Zr?=
 =?utf-8?B?VVUrT3F2YVFzdFNGZGYremNYeDlnblJWK3NyVDhnYzJlVG5Rcm5hMk45WkMr?=
 =?utf-8?B?VStoc1ArcWc1MmNVMWlScWZIMzUyODJUeEErQWRzTE5tZ3FxM3Zac0QxWHQ1?=
 =?utf-8?B?L2VvUEY0YlJ0SWhZdzVFOW9QMVhvL0FQb2hIZXUzU1hBVGN6K1RMRHJLZDVR?=
 =?utf-8?B?TEluVFhCUDZUZ1Z5cVUyK3FSWjJJY3FWUU9SYXRoU1RnaHMwckZjcDg4dWlD?=
 =?utf-8?B?Yys5SE4xOEIzRGxUVHo2dlhLSDN6VEg2VGpqU3pyNVlNdUZONjk5OU14UUdD?=
 =?utf-8?B?S3VXWjN5UXJBbVliOHZ6WWgyM05mOFpoVHI1amIrdVdOL3kwclhsWHliUWpy?=
 =?utf-8?B?TkFsMC83UWo3Q042K0lOTFZUOTNpLzZMSldNWHBVdDJBUmM4WmFnNVZyeTQz?=
 =?utf-8?B?dDRFbkUvYS9hL1NCN0tJWkdsRzByOGRwYXo0ZFNxWjJSMk1wRzdiNlJJdlVL?=
 =?utf-8?B?c2J6YW9Qc3FTUXpjNkg3SEdVS3o5YzZZWjhYNm1zMGRtc0FMUDl0RWJ5S1ZQ?=
 =?utf-8?B?ZkFsM3R0eWI1elhPUiszMW9tNzMreXZ6cENOVWNWUWRJdHpzNmI5Z2V3UDBW?=
 =?utf-8?B?NWpLRjcxNXBIV2tka2tpd0YzaFhSazV6R2RGQSt1bjhkeDFKVHVYRlZWSklx?=
 =?utf-8?B?OG1pemRUYUZmcER2RUdVUDlFVE1IU1BRY25DdnV1WnhsQkVhdjZUTnRpc2w5?=
 =?utf-8?B?S3FjNk0wWUM2b1dOZXRVbjFHT3g5bENDWHZmT0pGNkJWNWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFQ5bUp2QVJPTFdIdDRTaTZIQk5PeFRXaGFYaytGWjJGQUtPQWhCTWdBU1pK?=
 =?utf-8?B?K1dYclRveGVkQ0hJZUxWZTFsdzg0eEs5VUhLMUNqajhCUGxNNzhnQ25XT0Jo?=
 =?utf-8?B?VmM3d29JWUN1TVRjMmp5d2Mwbi9QcnBCU2hlbWFSK3FzOHpXUkFxOGl2enl4?=
 =?utf-8?B?VmE4OS84QWpJZXBwMUZhekFPVDdnMUtGS2JqTy9EVTNQT0xlRTlXSVpWSDVY?=
 =?utf-8?B?dUEzMzg5RC9rMFBFZFRVSGRqcGUzQlM3WjFINi9TN0kwRkcvbXhrWG5kV2Fl?=
 =?utf-8?B?UWQ1R0FjZzExRi9jNTVibVNXa2htS0QwNE5MbEpFV1NEREJoQURXeDI1L0Ro?=
 =?utf-8?B?Rm5EMmpueVl0SVlNMnN6MlFyVE81UG9rclVmeWJUV0M1TGdzYjgyNlVjSk1I?=
 =?utf-8?B?OWVNdnpsWFUvZGlZbnY3ODNlRGhDaUlXTzdnR1djc2g4aFNvQXZGMVBvWmZp?=
 =?utf-8?B?K0RlMVg4eE9PZjBYYWNxbllCZ1pubUJwR29GOXdEV2h2Ym1reStZeC8xUEI2?=
 =?utf-8?B?NVJhQ2RibFFiN2NLOSs2OVJBbndQRHcrQWVtNGNkV1VtYnJHSHdqbzZZdlBL?=
 =?utf-8?B?OHd3a28yeHczNGJtTllXUC9yNTJLTkZpUE5rdzZpcmZJcVhoVVIzNDZkQWZ5?=
 =?utf-8?B?RDc3ckFQL1p4QXFhWlNFY0dwRWdzTGhHd1lXWjhyYkdCaFFjaWpaUjlWNEQz?=
 =?utf-8?B?SHNGN1AyVlFkV2xFdm9QZjh1OGRYeWJYTmdNVUs3Z1V6azBzU0Q0UkF4ZFlm?=
 =?utf-8?B?Q2lXYU1DMWVJTWx5bGxRUllXQjZaLzBEbkZEWUZDZnl2N0p4NktGWXA2OWdR?=
 =?utf-8?B?RktHaU16Uk5IQlpJN1pROVgzYnlyV2IrdW1yaWNlMUcyQWY2RUNKazZCeUs3?=
 =?utf-8?B?MDFoYjY0aENuSFNVaktnSkRZemNRdWx6VVVldWtNcTJzNVNPOVY5S0RrQnRT?=
 =?utf-8?B?VmZlMkltbHV5NE5pWlh5OCtISG96SmJzRXNLQ2NDakhQeFZvR083eXQ1MzlQ?=
 =?utf-8?B?UHYrY1F5KzNqTHJoK0lCU1l4TEpQN1U4dHFoMVo5aExQU2g3MExZWm9FdTNo?=
 =?utf-8?B?V2pEQjQ3eWxUV1I5cm8zSnpxZVpqMXQ4ZjhHYUVjSXd0dVdvZDY4dFN3Zkty?=
 =?utf-8?B?bHRhVzdJblF4ODZvTVVseW5ONXNlZ01KZWlFanNTcjFFWE1uRnJZOFFUbi9y?=
 =?utf-8?B?UkZTOG5sVUkrbDdYMTVQZVlLZlhsWHlqUXpPN3BTWHZBRy9PZWxPbjBJRlhi?=
 =?utf-8?B?a3J3OFZadkxJSzlLa0hzM0xOcUlkR2c3enRvQzFSeU10ejRDdnlWQzJOZGla?=
 =?utf-8?B?b0pSdnczd1ZEZU50c2QrMllnMUFvTWtKVnFsNHE0eWZxbEw4K2o2eE9CdE10?=
 =?utf-8?B?Mk90bHN3K0pZSzFBTzJXU2hjeDM5Qmw2dnovUmNGT1VjOWtycVVZeHN3cGJV?=
 =?utf-8?B?SHpNNjkxTWhOTjNnaGZKYWpCb2QrZy9Gc1Jmaks3N0NxamdkbHRpaS85cXVz?=
 =?utf-8?B?Mit4RUcvYU5ScTJpbnFBQ2NHV3BpRmZjNVZFVVZYcUYxdk5wckNkSVNobElP?=
 =?utf-8?B?MUlOcTNnbFFSNjdOWjJyUXFsS1FQcW55YUcyK2kvMnlJdnhXdmxRYjFKdHBG?=
 =?utf-8?B?YnJEcFpIOTFuZXpabU1sMVhQajR5VVBsa2RBb3BZc0JkTDNLUlVrZy90V3NG?=
 =?utf-8?B?bDZ0NmVoaFNoUG9hM3NDMk1zKzAwbUdUV3k3N0poS3p2T2hIUW5UU1ZHNnc3?=
 =?utf-8?B?czdZSjFIY0oza1BvUGxPMnEzQW1MajY3aVpXazQvV1dkK3JrVWw0dDBOdmJJ?=
 =?utf-8?B?bzYrWUZwMUs2bVF2cm1jcXM3MEkzaE1WTWNTaFNBT1pmSlRSN3RKVkNPKzB1?=
 =?utf-8?B?Z1ZoYTR4ckpGbmhUZXc0bStUQVB0bVVkOVNmZ2Z4SFhpQ1orOGpWSVBWMlJK?=
 =?utf-8?B?UHVoeElPRXNjQ0xVRlpiMmU0QVYrYldnek05OXdkNkthRksrVlBRRHd6NzJl?=
 =?utf-8?B?a1Jrdm1ISmNBQXVReU1ibk9KZVozOU9sM3RTa0JxaDlPZ3Nhdm1SSlBYSjhu?=
 =?utf-8?B?MkVaTVR6cHI0ZzBKYktXMmgybGl4S0srY2JaQXVGM0sxeW14K1RUTUpuVm1Q?=
 =?utf-8?B?LzRuWUdJN3V0SzdaM1ozeXhvcWc1bnhFbTN5eW11ZlpKS3RWR0VteW8yTkJ4?=
 =?utf-8?Q?8E3eleqiiMzyUt3lJkdAAfA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DB9417FD2F83743A1DC5F1538B33F02@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c902c7-32c0-4f56-b363-08dcd1f761b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 00:19:20.5589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X2k4jNoSTje2OOQHpmXLl5IKmSSL+UwdQ+zSbuFbBT+qzS+PTcrzb8WRHkhXv0IFMQdvCLfbkhqwCWMrOTwyCmy/mO4fFnJK0YSrtp0U/UE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6148
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDEyOjI0ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
IE9uIDkvNC8yNCAwNTowNywgUmljayBFZGdlY29tYmUgd3JvdGU6Cj4gPiArc3RhdGljIGludCB0
ZHhfbWVtX3BhZ2VfcmVjb3JkX3ByZW1hcF9jbnQoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4s
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZW51bSBwZ19sZXZlbCBsZXZlbCwga3ZtX3Bm
bl90Cj4gPiBwZm4pCj4gPiArewo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGt2bV90ZHggKmt2
bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqAvKiBSZXR1
cm5pbmcgZXJyb3IgaGVyZSB0byBsZXQgVERQIE1NVSBiYWlsIG91dCBlYXJseS4gKi8KPiA+ICvC
oMKgwqDCoMKgwqDCoGlmIChLVk1fQlVHX09OKGxldmVsICE9IFBHX0xFVkVMXzRLLCBrdm0pKSB7
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdGR4X3VucGluKGt2bSwgcGZuKTsK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiA+ICvC
oMKgwqDCoMKgwqDCoH0KPiAKPiBTaG91bGQgdGhpcyAiaWYiIGFscmVhZHkgYmUgcGFydCBvZiBw
YXRjaCAxNCwgYW5kIGluIAo+IHRkeF9zZXB0X3NldF9wcml2YXRlX3NwdGUoKSByYXRoZXIgdGhh
biB0ZHhfbWVtX3BhZ2VfcmVjb3JkX3ByZW1hcF9jbnQoKT8KCkhtbSwgbWFrZXMgc2Vuc2UgdG8g
bWUuIFRoYW5rcy4K

