Return-Path: <kvm+bounces-32976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D57BD9E30F9
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 02:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0BF8167197
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D561A296;
	Wed,  4 Dec 2024 01:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/cxWOcV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0531E802;
	Wed,  4 Dec 2024 01:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733277497; cv=fail; b=Zcoztny94TY5oRALp/Ut4qnOQqDGFKNnb2kpaidFCc6Pc1FLK7cqU0isvgCIEj69LQ6gKVOVvDrx5J1qus+UdFiQZLq2qfPTIHpqmcjUXjLqjlstzABzBO90JB2IEINyaex168YOYHfc6H0nAkib09gQj4xZPkf2DKrxde4lxG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733277497; c=relaxed/simple;
	bh=vr5tKxxmcN6rILmB2yiWR2UN3/jVFP9/T11+5N5wO/Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LFAyLyvpEnL8XqXcT7TXxsef8XpxRgoV6zCHBReebc3rPYtM4Dw81gUvK+1bDzRKgHYPiILXs9BadRHwve9ij6nE4rqJ0mDExwp1vBAV89zEphWdjc9CNwpEt97yOmo14v6giPGRgTSXsG/GInbsHodskn7uATLzHSZWhOLHR6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/cxWOcV; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733277495; x=1764813495;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vr5tKxxmcN6rILmB2yiWR2UN3/jVFP9/T11+5N5wO/Y=;
  b=g/cxWOcVcQm0ooqqSXjdr0jtb9eWAurZbznfGY/XH08+n/LLazDYsZRh
   HPZGwn7i6okGsl9eLbc5CDszB1fMnbv3efFaQf/nYkCPtzihFmzHypGQ3
   EFNgDuaVxR2aVnhNe57O/tcJ6lcC5D4xkjXG8vLJ9EynRXekYJATqJCvk
   4Du1huGLon5iWgBVTTl4mx/cwFWBd7u7j4M1qPlLiydoqq1OCNO0SKJBL
   75LnnGqHMSjRE+5iy4xJluvDxbO78YTxRdMmUU8kgIYElpMiJtU0Jioc1
   XhCectZMW2fX4OEV4mo0iiGRg2Jc0QNKNbNTCgt4tGMR3oHPn0AKG1rw+
   Q==;
X-CSE-ConnectionGUID: bmlnxzCuS52uxYpUyuSIyQ==
X-CSE-MsgGUID: R9s6l9h8ToyI23DqXd8kPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="33269814"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="33269814"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 17:58:07 -0800
X-CSE-ConnectionGUID: FVQO+9nkRdCKu5mOA9OFPg==
X-CSE-MsgGUID: 7yCFpnT3SvOKujXaqe9TNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="93279502"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 17:58:01 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 17:58:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 17:58:00 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 17:58:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KnMTvJoy8fCoUQDDr3dC5w9aO3x2KOHZYP9sQGyp1brNTW/vTHXVv+kTXSf9o+6r6rA5V5oltD4lmJRgFPCqkbPhkiztE8BuAzg98eSuGEtikjwFjl/XWg5hjuAUbb6zH+D8d15EVXxExqTaG0Kv9yTHgP2KTwaVQlsGu1hiwXktFATj3X/5gEpa2bedW8Hvn+sWmiQTttR/5fGcMf/jbEBuqvabPadTk5eYO/bvB7FofkqOdR4zcwBO0IjOF8RT8yzz3jxGRnkd/1Yme4BHu6hPYnB/openQjATtQpYXXGMGxuTr8d4p5dxqGZGoDF8dYqtZ3bGxFroblhCg4+Aug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vr5tKxxmcN6rILmB2yiWR2UN3/jVFP9/T11+5N5wO/Y=;
 b=PDrMZYwf5+BfDOv8aIms5uRbtMndEY9rl0RLNyBFM3CSAtQAeCgJdjcpBmGH7oEwNUlKuQ+DNOUNiu9ImZXFiTqjTcDq3faM2nRwzNhKs2+3B5uxLy0vvHd2nsToIypJGM+oBmqU5iLx0IUjtky/EW4UqP6p8e51J+G9y+tOY9y3VF/9VAX991VA9eTC3QkeLtT0YITw7OZEQFPADSS6uFDTHKxImkIBsVF8QHiYChgoifmjBF3R/rHuezYRbhKmjT7GWQ44kIIdobyr6X/sXbxXhMWf+hUcroGBdV3aNQ8DFu2ziJ9/lUSGnvjSbB+hIjfgNH2tv/bGzGsh+avqFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB8130.namprd11.prod.outlook.com (2603:10b6:8:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 01:57:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 01:57:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "x86@kernel.org"
	<x86@kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [RFC PATCH v2 0/6] SEAMCALL Wrappers
Thread-Topic: [RFC PATCH v2 0/6] SEAMCALL Wrappers
Thread-Index: AQHbRR87DCMHcQGjt0K65E2d+aJ1grLVTDkAgAAJaAA=
Date: Wed, 4 Dec 2024 01:57:57 +0000
Message-ID: <c8d4bae2834555474c4c709642f86d2ec86a276e.camel@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
	 <e69033f1a0ec210c87ee596f96c8c1096ef1d59b.camel@intel.com>
In-Reply-To: <e69033f1a0ec210c87ee596f96c8c1096ef1d59b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB8130:EE_
x-ms-office365-filtering-correlation-id: 31c3d862-f116-4941-4155-08dd14071348
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RU1iRlZYRm5KWGhPMmhvLzNVWXZDaW5taGxwb3VwLzR0ZlVqMjU3aytQNU93?=
 =?utf-8?B?cU1USTlDdGt0YUYvUXB5OHFJMnZoaGhGdGc4MGs4bkxhcUZROUVKUm5Ta0FZ?=
 =?utf-8?B?ZFYraWgzMzl2ZXcxOURkalVoR0RCSGgvSkgvU1p6eFpWUHpldVBvMllTQ3Fa?=
 =?utf-8?B?YkxkV29NOWlBUlBJWHRZdjY3M2NmY3E4dzh4M2p5WjlyNkI4OTk2YS9tdldo?=
 =?utf-8?B?U3E0UGdXSG5aN0ZqTGloNTQvNFVyb2liMmZROTZZa1JNK1ZSUStUN2w3M2l5?=
 =?utf-8?B?cUlSZW9yOGtoSnRadVZBRElsWVd4clE2K0Nmd0toT1dZQVo4bjdwWVh3bk1T?=
 =?utf-8?B?OGxjYnpSR0xUdzFSTklmbWc1N09VdWo4Rk0reHE2Nnhlei9OSDNJdm9TMm5L?=
 =?utf-8?B?ekZ2TkdVVGV4Wi9naWRTZHR5NXNlUWJZWHcrclJuYlBxVW5ZZlhmT3RsSzRG?=
 =?utf-8?B?U0hQRjRWY3B5b2wxMTE2bllOeDFnK1F2UjZPWjhmQy93bzdyS2sxdGlYUkZt?=
 =?utf-8?B?N2IzekM4ME5qWTh3M29UbXRYbVhIcWVqMHJTYmNOVHJkWGlzZXBLZVBocERN?=
 =?utf-8?B?WjN5SHBpT1hLamZjbWRxM003QzJjcnAyQWNaMVRObzFudHUzS2U1ZUlVaitU?=
 =?utf-8?B?L01vNGxCVlhoYktRSzN6U1F4eUxUeTBlOTMyMDR4NnhnaW9IK01HRUFRcmRR?=
 =?utf-8?B?RWRHWlBxa214V3ZlcUFrV3l3R0dqdFcyT05tbGdmdW1nbWZHajZRcStuYmtw?=
 =?utf-8?B?R25FNU1tbFVaRkNFdjV5MGpGV3V3ak01L01qZk9TNTFSQVR3bm8rQWlqdHZ3?=
 =?utf-8?B?OFFjbEQvRTJzSmVuRG9XRG9USjFETUVGZnBrV0RCamZnb1NJMzNqSENmUEJo?=
 =?utf-8?B?UEFXaExibVRDYkZ4R1k3WkJuUGtKblN2RnNWUnZyS0VwVXJQNHAzV1BTL3Vm?=
 =?utf-8?B?NWtMek1aNHF2cDFSQVpVY1RmMlh3R2w5Qlg4cmVYQ1IwYmY2SDRXSi9JL3Zy?=
 =?utf-8?B?ZDNrdUpyWXBuOVd4NGZ6cjNzY2NNYzliampUZjE2dzZ6SkhQb2tYZEZ6eERX?=
 =?utf-8?B?TGFFdkxLK3F4cnZibkRuMW5taWs1Y0lVR2xxZHFQYlNac20vV0owZ2I3ZFVl?=
 =?utf-8?B?U2NXUWtBWFlGT3R0UksvcVZFV3JKZGlVYXBuREhRQWgxWDI3S2wveTAzT1BK?=
 =?utf-8?B?a2VWL09aTmlyZDF2bTQ0NjRjUDR0U3F6WUQvNlNlWGt6S0ZQTDd3a0dvRzNz?=
 =?utf-8?B?dlBJYitmZEtoVzRlT2F2cVNHekVnaGl4Tlg3SjIyMmhKUmlzMUJPR0xNdlFl?=
 =?utf-8?B?QlB3ZHhGV0QzemFsOUZiNzFheVVlc25BaVZhTzdWUHp4NVpjaTBmZkN1Y3cv?=
 =?utf-8?B?T3I5K1YycTgwbmU5M3NSZzBxazliZVIvaHF2ZE9EYnFhWnZNTTQ1c0huOW8y?=
 =?utf-8?B?bmpMcEtJdUZ6SGpqekdIZU5YbExJUjhlL3h0ZnpLbWFXK3JHOGl0SXBKK0RB?=
 =?utf-8?B?VC9TSzhMU1ZCL0tpNXZYaGhEV21PY3RqdXVTbTBCa0pTSWhiRDdSMGpPR0c2?=
 =?utf-8?B?eEtSUDVTOVFDczZ0K01DQk9meXRrS2tHbXo2RVVOa2JSVVpuMFFOeFBLVzlF?=
 =?utf-8?B?QXRNcldRMkdUSmZUaEFHS2xRZndYZHR2VXRxSE8zQmcwR25MWG4rSG5vaUta?=
 =?utf-8?B?NjYyRHNZYWtxUlZhNENqVnRZVTUrajAzanAzREpab2RKd2xqN1ZqekV6YlVC?=
 =?utf-8?B?RVhmLzNEK0EwYjZlcWJhaitPVkt3U1ZwaU1CN2pudEg2ODM3TllSaUxKeGxn?=
 =?utf-8?B?OU5mTlpsOWNEeXZPclJ3SjEyR2hoM1BCYWVHYlFzZ3JGSWpYN2xTR096MDZi?=
 =?utf-8?B?OWEzRXpQTHYyR0VMZXU3anYvRC91V0kwN0R4NVdHQkIzQ2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2hTOHpUU3ZDNTlZbWo5NVM4MTN6QzJvZUIyWmk4Y01kZXFxbGp3VHQ0Q3k4?=
 =?utf-8?B?dytUbldteHVOT3hNYlcxcE5YZXBkYzdzUzVrY2lINk9xSXhMVHpITG1MUGxz?=
 =?utf-8?B?cFFpdEhzQ3pZc1NzWVcrOWgwVGZLZEo0cWhkZEZBUEk1RGhjUDBuNVhuUGo0?=
 =?utf-8?B?MHVrVFRoRDA4SXRENGNDRHBjby91UE1xVFM3VG1CYk0vZUc5dDVJeCtvMi85?=
 =?utf-8?B?Ti92WDJzOUtkNUl6b0RzcGlrSVFMdHNmRjdFMEZvRVhPcW1RelVGRUJMdmpw?=
 =?utf-8?B?RHZkYkYrdTBhdm5sUGRJWWFKalF5ZFZHNXZhY0xEcU9xUjB5SVVSMHYvWEF0?=
 =?utf-8?B?aDlqMEk1MktXandXZDUxNm1XbUs1ZGRPY0VQcUg0VUdOTXpnM2s4RUU0N1VO?=
 =?utf-8?B?SmhyYkY3Q0NWUmpLdm40VjV0V0tGMTh5WWtTaDdjL3cvZjFhdCtKUXU0K1l4?=
 =?utf-8?B?bHM0OUQ1OGZpaWpGck1GQ1dLNkRmTWZZSDVGUndHVit2N3Y0MVBqbWtBc1B5?=
 =?utf-8?B?M3BWa0p3VDdaM0QrWEtveFFkZTdPeFlnYTZrZHQrdTNpR211OFU2eFZ1MVFK?=
 =?utf-8?B?clpNM0xVaHdmWVFRNzN4Q0QxVk0zOWR0akZ1OHRGK0xpS3p4MjdCK2wrWEdL?=
 =?utf-8?B?TWZ5WENydndySlVZbjR1czlXNVJENFpVUUtLQnpqOU43OWFtWTJEdWZQYjlG?=
 =?utf-8?B?aVdhZ0hsWlBUd0JjMmZ1Zy8xSjNwbFhaTVE1Y2tHSHU4Tlc2YnlPQkprTWZP?=
 =?utf-8?B?cWs0cFE2b29QZi9LVWd1WUpCdmduUXlqb2x5NDZySTFXa3MyaW1OOVg2dlhJ?=
 =?utf-8?B?S3ZNc092dlNMeE9aZGFoUklIQzZLVXU0YW43c0srVWhxQ3QyZ1Rkdzd2U0VH?=
 =?utf-8?B?R05VZ0ptSkNpR3lLbk5NWUtzaWRjNTBwVzZzMjloNFc3aHY5Y2JuQUVyQzND?=
 =?utf-8?B?bjd4cHp5YkNZcjZtbFA4ZmNnVEpYVXNIVUtQQzFnT3RZZ3IzSWVINFhMWVVy?=
 =?utf-8?B?U0Y3bCtzeW5CakNxUnBrNDJKdTk1UHM1RGdXaU1XdEZpZHNDSm9EeW9mTHVy?=
 =?utf-8?B?SXdMYWN3M2ZFSkM2NjE5dW5LK2ZmeFo2aGY2ZHVOOWI2eldZUFBJTEhXNUg2?=
 =?utf-8?B?QVZMUVI1ZXJXcnZmNXFxUnBwempjTy9TZFdzMXkrL05VbWNybkxHTkt1Y3pu?=
 =?utf-8?B?OTQwRWg5R1JwTERkSVVFZm1EeE96TE95UHdFeHlUcHJvNHJEZVVLK0FjdVp0?=
 =?utf-8?B?MlFHbmZCRTJNUUx2VmxBV0ZDdFFDUEtUUHhKVnJ5UWdNS1dNUStPZnkxVFU1?=
 =?utf-8?B?ejJYbHRpOGtkS3Z5VGVyNWdON2dTOVhIOWJzcTdlRGNUZTdxWjBXNWRKRWdY?=
 =?utf-8?B?MzVkWmlZckJHMVFOVWJ6U29JV0ZQamZVdGRVTkt5KzJJWFBQUlZEMklRWXJt?=
 =?utf-8?B?cVFkN2JFdmdhVlN3TDBiMHlDM2V1VkluNlV2S2VwektCdjNUN0Z0cUZnNGRj?=
 =?utf-8?B?RHh4SE4rS3BCdk81ZGVCaE44TzRIZ0psUGdSUVZLQ2FxTE9haFUwL1dQM1pI?=
 =?utf-8?B?Z0xUZWJ1N0hqTUZwOHN1aEJuaU43eU1yRHpxMDN1a29KNVJkKy9Ob2JpSUF5?=
 =?utf-8?B?UGpmL2hFK2dOejBQVlMxenJ6SitPb1ZZWCtJQmx2emRGWHdYWWpyZU5pa2VP?=
 =?utf-8?B?eTJHdHp3UjV5M2Q1Y2Y5clpmcDA1dTkyZ3lWMVYzejJodGEvNzJFTzh3ZmxE?=
 =?utf-8?B?ZzNyU0Q0TlU1NTkzenZGUEZHOXFScUNteW4xNzZrOFFtd2VyRDRYYWZlcmpR?=
 =?utf-8?B?blZybTFUNWloTTFGNFdERk5nUENoQndQTWlWNy9WU2VpTUpaM1VyNmZ0R1lJ?=
 =?utf-8?B?dEFHTExwYm56Tzc2UENaZm1qWlY3UnUyaUdFdEtrMS9INzZDakVxbGVQZTBX?=
 =?utf-8?B?RHcyemoxUkhwL3VuWTlMWGlZNS9sS0FnV1FTQnF6QUIvKy9xaURobFhheFZj?=
 =?utf-8?B?UEhoSFIzejVEbG1CYlNsQUtQai84VzBBVExhcU1DZGVLZDJ6N25kNHpWZEJG?=
 =?utf-8?B?Mml0OFptdU1UOHE2TkpLK05sNUhXVUhxNmRiNmR2eVFmK1htei9tL0tOalpK?=
 =?utf-8?B?QXpLeTRMTkFRZ1R5UHJQNGF2cUowQW5UNXZuemN4WTNCZ2wxd2ZWY1JqaVdL?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D8E4831196B494A9AFC7BDB08D62EE1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c3d862-f116-4941-4155-08dd14071348
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2024 01:57:57.6706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LOfdQu9f+lkpOlWAzYgfShUV1Wgn9Uv013n55vAf261GWHSR+POWcF4/XNCB0Fpe4RTccM8TEtTQ0D9iRaymljAO8aLfZb8lKEnFmz0l5zY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8130
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEyLTA0IGF0IDAxOjI0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBD
dXJyZW50bHkgdGhlIGdsb2JhbCBtZXRhZGF0YSByZWFkaW5nIHNjcmlwdCBnZW5lcmF0ZXMgdGhl
IHN0cnVjdCBtZW1iZXIgYmFzZWQNCj4gb24gdGhlICJmaWVsZCBuYW1lIiBvZiB0aGUgSlNPTiBm
aWxlLsKgIFRoZSBKU09OIGZpbGUgc3RvcmVzIHRoZW0gYXMgInNpemUiOg0KPiANCj4gwqAgIlRE
Ul9CQVNFX1NJWkUiLCAiVERDU19CQVNFX1NJWkUiLCAiVERWUFNfQkFTRV9TSVpFIg0KPiANCj4g
V2Ugd2lsbCBuZWVkIHRvIHR3ZWFrIHRoZSBzY3JpcHQgdG8gbWFwICJtZXRhZGF0YSBmaWVsZCBu
YW1lIiB0byAia2VybmVsDQo+IHN0cnVjdHVyZSBtZW1iZXIgbmFtZSIsIGFuZCBtb3JlICJzcGVj
aWFsIGhhbmRsaW5nIGZvciBzcGVjaWZpYyBmaWVsZHMiIHdoZW4NCj4gYXV0byBnZW5lcmF0aW5n
IHRoZSBjb2RlLg0KPiANCj4gSXQncyBmZWFzaWJsZSBidXQgSSBhbSBub3Qgc3VyZSB3aGV0aGVy
IGl0J3Mgd29ydGggdG8gZG8sIHNpbmNlIHdlIGFyZSBiYXNpY2FsbHkNCj4gdGFsa2luZyBhYm91
dCBjb252ZXJ0aW5nIHNpemUgdG8gcGFnZSBjb3VudC4NCg0KQWgsIHJpZ2h0LiBTbyBnaXZlbiB0
aGF0IHRoaXMgaXMgZ2VuZXJhdGVkIGNvZGUsIHdlIHNob3VsZCBwcm9iYWJseSBqdXN0IGFkZCB0
aGUNCndyYXBwZXJzIGxpa2UgeW91IHN1Z2dlc3QuIEluIGFueSBjYXNlLCB3ZSBzaG91bGQgcmVt
b3ZlIHRoZSBjb3VudHMgZnJvbSB0aGUgbmV3DQphcmNoL3g4NiBzdHJ1Y3RzLg0KDQo+IA0KPiBB
bHNvLCBmcm9tIGdsb2JhbCBtZXRhZGF0YSdzIHBvaW50IG9mIHZpZXcsIHBlcmhhcHMgaXQgaXMg
YWxzbyBnb29kIHRvIGp1c3QNCj4gcHJvdmlkZSBhIG1ldGFkYXRhIHdoaWNoIGlzIGNvbnNpc3Rl
bnQgd2l0aCB3aGF0IG1vZHVsZSByZXBvcnRzLsKgIEhvdyBrZXJuZWwNCj4gdXNlcyB0aGUgbWV0
YWRhdGEgaXMgYW5vdGhlciBsYXllciBvbiB0b3Agb2YgaXQuDQoNCkknbSBub3Qgc3VyZSBJIGJ1
eSB0aGlzIG9uZSB0aG91Z2guIFRoZSBleHBvcnRlZCBhcmNoL3g4NiBpbnRlcmZhY2Ugc2hvdWxk
bid0DQpoYXZlIHRvIG1hdGNoIHRoZSBIVyBkaXJlY3RseS4NCg0KPiANCj4gQnR3LCBwZXJoYXBz
IHdlIGRvbid0IG5lZWQgdG8ga2VlcCAndGRjc19ucl9wYWdlcycgYW5kICd0ZGN4X25yX3BhZ2Vz
JyBpbg0KPiAnc3RydWN0IHRkeF90ZCcsIGkuZS4sIGFzIHBlci1URCB2YXJpYWJsZXMuwqAgVGhl
eSBhcmUgY29uc3RhbnRzIGZvciBhbGwgVERYDQo+IGd1ZXN0cy4NCj4gDQo+IEUuZy4sIGFzc3Vt
aW5nIEtWTSBpcyBzdGlsbCBnb2luZyB0byB1c2UgdGhlbSwgaXQgY2FuIGp1c3QgYWNjZXNzIHRo
ZW0gdXNpbmcgdGhlDQo+IG1ldGFkYXRhIHN0cnVjdHVyZToNCj4gDQo+IAlzdGF0aWMgaW5saW5l
IGludCB0ZHhfdGRjc19ucl9wYWdlcyh2b2lkKQ0KPiAJew0KPiAJCXJldHVybiB0ZHhfc3lzaW5m
by0+dGRfY3RybC50ZGN4X2Jhc2Vfc2l6ZSA+PiBQQUdFX1NISUZUOw0KPiAJfQ0KPiANCj4gQUZB
SUNUIHRoZXkgYXJlIG9ubHkgdXNlZCB3aGVuIGNyZWF0aW5nL2Rlc3Ryb3lpbmcgVEQgZm9yIGEg
Y291cGxlIG9mIHRpbWVzLCBzbw0KPiBJIGFzc3VtZSBkb2luZyAiPj4gUEFHRV9TSElGVCIgYSBj
b3VwbGUgb2YgdGltZXMgd29uJ3QgcmVhbGx5IG1hdHRlci4NCg0KTm9uZSBvZiB0aGUgdXNlcnMg
YXJlIGluIGZhc3QgcGF0aHMuIFVzaW5nIHBhZ2UgY291bnQgZGlyZWN0bHkgd291bGQgYmUgbW9y
ZQ0KYWJvdXQgcmVkdWNpbmcgd3JhcHBlciBjbHV0dGVyLg0KDQo=

