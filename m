Return-Path: <kvm+bounces-17430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EF98C674E
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6B66B21259
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 13:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6871085C6F;
	Wed, 15 May 2024 13:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RoGe/MEc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA168595B;
	Wed, 15 May 2024 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779495; cv=fail; b=o4k7Q/akU3j4dL0nN/i3Z117+DYGg2Wuikob0EcA+GsqDOreT1cNxrDjXHPQ+JcTmTEeGqOYsFOZPa24KFdI8RdtPlC6JQ9i5zC/YIQGsirSHYdipO6PQx7tFvXrXR+7pZ3gF3XsoanVe3eq4q5+b1FCILFjbQyvn8klXuQ5sbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779495; c=relaxed/simple;
	bh=P1oVsuOVN69su9eRgQU85grwXbSea5wJ84SOgH2YYnY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oFbmXC/P7381ioOASvF9o7ZuNKMeQReoHJQhK+Bfh/tuFLwZNAsGR5QazbDsCQ0YdgHIJkWSj0Uv7HChn/1kz9+rl4XC/XRQ2+wyvFwoexPm9d7+vDslpdMJRkYIk7qPQmwlVXnGngd/dtXzyoOA/1SH7Zok1dndhW+Z2x8voBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RoGe/MEc; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715779494; x=1747315494;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=P1oVsuOVN69su9eRgQU85grwXbSea5wJ84SOgH2YYnY=;
  b=RoGe/MEctV9fIwia2SIpOBJa0xL/EjFKFq6OUixHD0BPIhZrmZf36VY4
   q749iR8WW/flFWxMgOEcymtgWQ2Afs0fYOEvsTwN9uK3AUTKvLDVPU7zo
   WbG82Hl+VUktSdZe3krE26XeeT2VjQYp8oIuvBMv2hSn2z2IVQKkDpm8I
   Mj0f+YaymwhKtzvT7JUWUO3oMU4CE/1ncV6NAYahhmjbo7NmlQIXF7eo+
   S2gVtJXbiDfFJTBLkCcYBk1a+xLul4WO/zYo5BPj7XdEmf3c8aMku20Zp
   fBlhPDHHKWAWz/0Exo5RJRj7LQgADc1W+/NWSI7EAzQbmZLNWIyHxLSGa
   g==;
X-CSE-ConnectionGUID: Cw5reropS7eDK6whAhfSzg==
X-CSE-MsgGUID: kBE0Pm1tTMWI2QZ0yWScFA==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="22967985"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="22967985"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 06:24:53 -0700
X-CSE-ConnectionGUID: 7AFjseF7RrqO9yilpT3Zng==
X-CSE-MsgGUID: yeQFJ7ZcRkSaSbJC4eDUXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="31054422"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 06:24:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 06:24:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 06:24:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 06:24:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 06:24:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQW46ZR09rPcVOCGhU++gu5XN1wRUFePsGodaXOijFBIcmuakwlNCGFZ1UCDw7YQXXgNExRYO29MT0/t2PsRyMKB89Z8yywPbkQ8qB09DTH30IPqzx3nYj4/LoEcTxelawqz+VFpYw6qLzlhDAdhPPGDz98qKSx7wN4I8JajD1LQeqEmazQ5M0pYSqTrHUwP7Daf5yhq2ffHft+ZIl5ld8jGgobps0/bcmlf5Ol/EgcfiPwl/spsMhheXvaSvRWDitzyOS4G3fKG2H3A5HX68QvAl9g8ggClOu6XqUnivXghpsvvLMi6d6O/KEDeDa463PL0G5d/R0xQ6sdUj2v0Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1oVsuOVN69su9eRgQU85grwXbSea5wJ84SOgH2YYnY=;
 b=KhXGxtxmVFmir2yV/9+I/CWFkCgjJd4nioL3/e5HncNMG8mzBy15NRL59K3o9pLyCkMI1W0JZQhNYgoSkXV47Zlu9+88Hjju5dyeRJJHVzZklseHOqxBiS1xztmE8Ub6Llbya58j3xaXHdkiQgDnYm+oPGN4pHOHeSXtksixMQ4ZJJZZVv5YrzyKDBE7SL2U3xJgys0FlY6K5IWxAVCNnIQiFQiEHAyYonAW23Z0hsUl6PosAsSnqjhiviwhmylAM9nSxgAJn5p4Anx3W7yescDjHz3ayePJKzRpk9KoTbLOPpHTb/F9m4ug0Ci3j2uP7r16UceLAjjNt4Y4olOZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7324.namprd11.prod.outlook.com (2603:10b6:610:14f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 13:24:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 13:24:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Topic: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Index: AQHapmNnM2EwuCp9C0Ktey26qV0e9LGYSbYA
Date: Wed, 15 May 2024 13:24:45 +0000
Message-ID: <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7324:EE_
x-ms-office365-filtering-correlation-id: 8a925b44-ede2-4e84-b759-08dc74e2637c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Q0ZjQjQxZkdzZisveUdpaGNWTUVOU0kvYlVZWGtCem52YVArSjNKRU9ETkV3?=
 =?utf-8?B?V0NKb1k1ZktMOFlheC8wbHFzQUl6RnR6Rld2V2JXenIzRE9WcnJ1cWtkYUdR?=
 =?utf-8?B?bjRNYnpUOVdsVTY1aUwwQ1N3WVR1bVZCYUJvM1JSeko4ZWN0RUI4YVJsejBz?=
 =?utf-8?B?bEJmQ3BVU3lPY3NabjNsWk4vMUI2UjNqSTAxcC9zMStuNzEyN2tPTGZNVjBM?=
 =?utf-8?B?YTJsalMvczZtdTNTNXNmb0xhbjB5bHU3NUdTM1NleGZBcUNQOXd6UDJCaWY3?=
 =?utf-8?B?dEJjUW9SbURoaC9tU2I4emhYclBaRXhNU1NNN2xLYnEyanRoejhJdTRGRXhu?=
 =?utf-8?B?dlMwR1FPVEY5UFl2ckoyV2l2NlZGNmxhUmkxWTBsMlN2L09EUWpuUW96Z3BM?=
 =?utf-8?B?cVRmbmk0VG8vakh1MElvdEZESjJqbGc3UFRkZU8rbFBPQ0FnRGdwNzRSTGx0?=
 =?utf-8?B?UVNLQnE5L3VRTWRhdzdoS0NqNE5VU1dGUzBteW45ZTh3ckhRMks4UC9WVG1D?=
 =?utf-8?B?ck5KRGdzckQ4Q2ZZOVMxS3FLTkpIR1JybFlPZkRsSDhFM1ZDMW9YbGh4STZV?=
 =?utf-8?B?WklRRVlWQjQ1dk5helFoZk5nbDRJeVcvWXllOFRDMUJnVi9rMTZxWXgxRnlL?=
 =?utf-8?B?UXlZRUNUZ0JJMmpOSkJBTkczbll6L0VlUjNIRUk1L3VVY3pVc2ZYL09nK0xN?=
 =?utf-8?B?elU5YW9uTTBrdHc3K3dxT2NXQmpoQ3RFYnR3RWNwdWp2dFFuSlF5RHVxbTBF?=
 =?utf-8?B?c3hGNk5Jd3d6emVucVJ5KzdSWmJlMnYybDZzQ1VSYnQ0YTh4SmVWUEtPRStT?=
 =?utf-8?B?ZEVxM0VLSjVRb3NlR2dWOEt2alBNMzZBMkhXWE9lZ2VvVnloSEtmcVZYdTFG?=
 =?utf-8?B?VHpYQ1VLZ0xIaWtWVWwvd3N5TXplUzh3Q1ZvUWI3Z3ZvOHJ5MzV0dExLS1k1?=
 =?utf-8?B?TlpUUVcyV1NMQkM4NGg4VkVCZlVpV0J6NXZxOWZmNlUyOTFwTDNOZzl0UGZz?=
 =?utf-8?B?TTdZTnRpN014Q2VKVzNFMEpiNk9Fd0ZNSWdRcnFUQWM2ZUt5Q3pTTnZDK294?=
 =?utf-8?B?QVdIREh6SWVSVnE0SHB6MTZqWWtObFY1dzFOSDVMUHVYMzF1UEh6WmE4aG1N?=
 =?utf-8?B?V0NNeGt3K000RGFTbmdSOXNrTHc3L1BtTFlvdlZmWGkxOWY4Zi9CM0RpZHRS?=
 =?utf-8?B?WjdkZnZXTWpRRmVhaTc3cEs5Yi9yVWRCRVpKZ2tHZXQwb2xXUFdPSHlsY0RS?=
 =?utf-8?B?TWhSS1gvN1lhZit0WTVxeUo3N1NaSlgwbGV1UDBsVDhQV2ZJOGtaMmRqSnFk?=
 =?utf-8?B?V1BHbmpzWjBsUmJQMnNsOFZJbU16bVJDK01YWkdwRjdUL3crTnVJSzRGL0w1?=
 =?utf-8?B?S1YvTHNhd3padWtjQ2VTdUswc2hBblRvRFRyRk5qWGd1bmYySkZiUWp2a0VP?=
 =?utf-8?B?OUY5ZWFJOW92bk9hWVlVL3IxS3hYdUw5VXdWVkwybEJPQVQ2WXdMaWRXL1FJ?=
 =?utf-8?B?QTJsTXVPUzQ5bTB0UUhKc3c5QTRwaXA4U1EzMFJOZG1jcFdseHhpVC9HY25m?=
 =?utf-8?B?cXdKU1N0a1pRTUdLWmdmSExSL2VwalBXRmZKWDVCYUorQWpqYW9oelV3a1pP?=
 =?utf-8?B?dlgrQU5HQlY3SlJHWTFQZmxpbmVteEd4YjNmYzB5RGxZazdlbmZkOHdtL0JE?=
 =?utf-8?B?VTNjT2hpa29JMzdrN1QwK3V0YWFGbUpIck5sSnJUQzVZZFRGblQ4USs0bElC?=
 =?utf-8?Q?L0zMSnWdcK8DoEw9uM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzlHUXNuelZBY2c0YmJxTzdXb3pKREZtZ0NRSzl3bW1XUDF2ZmNlTHJIVWRL?=
 =?utf-8?B?TXF1TThpWmdpOUpVUXRvc0FtcjV0N0JNUVNOSVpSeURNb1p0Qmh5UE0vVFg1?=
 =?utf-8?B?TlZINDRmQlNweUxzWTJFVWtvZHIvWS9ZMnJuMDhKNUkxSWEweXhvQVpWczJt?=
 =?utf-8?B?bDd4c25YdzdURStZblN5OWZMWmRQSDFhcUYzbW5hQjlQdnBQT2g0N2lnL1VT?=
 =?utf-8?B?TmR2c1U0Y1ZWZDRYcm90eFBtck1DSm9kRk05UFgza3p3OFhZeVFTRDBRYkRN?=
 =?utf-8?B?SFJFQUJIWnhRb29FS01Rc0ZVczVlU0FUaHNsbVNzMSszV0oycm9SZnNVSzNZ?=
 =?utf-8?B?SUhzaHBzK0o4dHU5aXJ0YkZKWmZUczJsTkNLT29oTWdPbUFIa09QZnRvNEZr?=
 =?utf-8?B?MUZ0VERZVkFaSGFOeW1vSVFDelc0YUFrMFpZRHg5djlXZklIV0lvTnkxL0R0?=
 =?utf-8?B?UHJMNnBsWWR1dXBDY3ZldXpRNWZOeEIvUjlaVGIzS3Q4R1RzQysrdGJ0Vy9M?=
 =?utf-8?B?QlFOTHlUa2lKMW9KS3l6M2Z2SWVyczRvSzUrbWcxWFd3SU1oM0ltYVBKbGFl?=
 =?utf-8?B?eVRJMzRKWGFsK2M3WjJQSU5nZisya1dOeTV0dllEL2t1MGFSVGN4bnFWR1hU?=
 =?utf-8?B?WTF2Qld6bllSS2taQThodURFMmVTTEx4OGVPYkpEUXhMV3hzdVV2Ym1kVVM5?=
 =?utf-8?B?TUdXWFVyOEk4SWhiZVE2Wm5kdm54UDVaQUltbXdWYW5uUlFCM3RTc3BuYTZr?=
 =?utf-8?B?MTRtUTNZMFNNL3BNcWN3ejNrMHhiczIvQjc2emhkYjduWnl6UlMxQ0MzK0tF?=
 =?utf-8?B?QzFjQ0hIb2hCbjFUN3RQU3RFdzZrVXBTUDVRUjZnNys5bEx2R2F2Y0g4SHll?=
 =?utf-8?B?NXpvYzMrckV5cHROZERkcGduQm1Nc2k2UmFoVUw3V3I5K3N1K0RsMitId3ZV?=
 =?utf-8?B?eVVabXpLUlE3bC9GOTRPV0h1UGttWXJMZnlXcnVMZk9oTkJ5ZzZDc3pRNzc4?=
 =?utf-8?B?SkNkQWF4bmkrSnNPZ09LNzVFbk5KVlVFV0xWYjlZK1J3RjJ2Ry8vZzNUNDJY?=
 =?utf-8?B?dmg2WVl5RktFMDRHNTBRMHMxM3RRM0Q5SnorYTJxRDhBTEsrSk5UVXlIdEZC?=
 =?utf-8?B?V3h0bU5USW9xV0RXNXZ5T0hlMW5YdWl0V01tMm1raVM4MzlmYWo1QzRWTFJS?=
 =?utf-8?B?SGdCODQ2c3B1NjVER1hEUEd0aDUyNEJ0RGorOVdiY1VRSTlNZHhCUmdaUTcv?=
 =?utf-8?B?RWluNldsT0t4RTYraGM2VmRuTEo2L0pBVXJNMzJUQU52SEFBTCt1cHluSkJK?=
 =?utf-8?B?SmE5Z25xL1pxTVRMTlZISE0yaW1sc2EwNitLZ0lKVzZ1NGVMK3pyV0NSVit6?=
 =?utf-8?B?QnZhZVZaek9xMlliNEpHamZCVk1VNkhKRTQ0aUJwcUFPZ0xGWWFwcFBHL2ND?=
 =?utf-8?B?NWg3WVBKbW9LbDFzaXpFaU9nMmIxczZSVHlxZUErQkkzcE9oN2x0THBCYStM?=
 =?utf-8?B?bEtoai82Vm5tKzFUa01ERkZYdHUzaHNpS3lvRDMva3ljY0lUcE1VVXhyS3RW?=
 =?utf-8?B?K01qTE1EdW13cnFIWnFCNEh0cENVQ3ArQlk1K3QzcThsU25qeWRJRFdBUXV4?=
 =?utf-8?B?YlFseGRvWkIzMUUvV0VWWjZFNndmdHUrbVFYV2pSU3BWdHp3cjVpOE1wL09z?=
 =?utf-8?B?NGtTcTJCRlZsbUxmeFZ6dFJrc2pNc0VMOE1GcGtiWDdUaks5QlV2dmRZZTFI?=
 =?utf-8?B?cU5TUzhyMTk3VEpOU0Nqcy9JNFQzQnNxdmd6ZDFwVFlKYVd3S0hWV0IvanVa?=
 =?utf-8?B?bmk4TnBWSU9UbkMrYlZGdGpicFFRSmVGdlpnRDNvVitTZk1LQ2tmVzNjNzVv?=
 =?utf-8?B?N3hsSDBHVkZyNHBEQzhOcm84L0s4V3htRVVRc0lmZnR0eWczbEk1cHhqTmY1?=
 =?utf-8?B?UHN6RUI0c2Y5VEpUQU00cm9JMTJ2Rkk2RC9WYjhJbW5NWE94aHViakdlekh3?=
 =?utf-8?B?SG5uVE5Zck9oclVmbXJyeVdweEhqN1BwWlNkQnEvM2tLZWpRaHJ3TVI2c0E3?=
 =?utf-8?B?NnZ6Y2YxUWVxWGZuS1doY1VXVy9BRmpoai9RenhkRnBIUy9VQ0NtNmVrbmls?=
 =?utf-8?Q?FigKyc+E/Fd9ht4xz1sk4IaYr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C90F4682FB9A01429B69DCF6256907D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a925b44-ede2-4e84-b759-08dc74e2637c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 13:24:45.9982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YaYDROL/4Z3MGtUwfdNjIXJO31wBhJws28wpA2ZJzSD1egqkh3zdi7Mrp0vUNrMCOqxqd8lgg2lGEVErY5wDEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7324
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTE0IGF0IDE3OjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gRnJvbTogWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiANCj4gSW50cm9kdWNl
IGEgcGVyLW1lbXNsb3QgZmxhZyBLVk1fTUVNX1pBUF9MRUFGU19PTkxZIHRvIHBlcm1pdCB6YXAg
b25seSBsZWFmDQo+IFNQVEVzIHdoZW4gZGVsZXRpbmcgYSBtZW1zbG90Lg0KPiANCj4gVG9kYXkg
InphcHBpbmcgb25seSBtZW1zbG90IGxlYWYgU1BURXMiIG9uIG1lbXNsb3QgZGVsZXRpb24gaXMg
bm90IGRvbmUuDQo+IEluc3RlYWQgS1ZNIHdpbGwgaW52YWxpZGF0ZSBhbGwgb2xkIFREUHMgKGku
ZS4gRVBUIGZvciBJbnRlbCBvciBOUFQgZm9yDQo+IEFNRCkgYW5kIGdlbmVyYXRlIGZyZXNoIG5l
dyBURFBzIGJhc2VkIG9uIHRoZSBuZXcgbWVtc2xvdCBsYXlvdXQuIFRoaXMgaXMNCj4gYmVjYXVz
ZSB6YXBwaW5nIGFuZCByZS1nZW5lcmF0aW5nIFREUHMgaXMgbG93IG92ZXJoZWFkIGZvciBtb3N0
IHVzZSBjYXNlcywNCj4gYW5kICBtb3JlIGltcG9ydGFudGx5LCBpdCdzIGR1ZSB0byBhIGJ1ZyBb
MV0gd2hpY2ggY2F1c2VkIFZNIGluc3RhYmlsaXR5DQo+IHdoZW4gYSBWTSBpcyB3aXRoIE52aWRp
YSBHZWZvcmNlIEdQVSBhc3NpZ25lZC4NCj4gDQo+IFRoZXJlJ3MgYSBwcmV2aW91cyBhdHRlbXB0
IFsyXSB0byBpbnRyb2R1Y2UgYSBwZXItVk0gZmxhZyB0byB3b3JrYXJvdW5kIGJ1Zw0KPiBbMV0g
Ynkgb25seSBhbGxvd2luZyAiemFwcGluZyBvbmx5IG1lbXNsb3QgbGVhZiBTUFRFcyIgZm9yIHNw
ZWNpZmljIFZNcy4NCj4gSG93ZXZlciwgWzJdIHdhcyBub3QgbWVyZ2VkIGR1ZSB0byBsYWNraW5n
IG9mIGEgY2xlYXIgZXhwbGFuYXRpb24gb2YNCj4gZXhhY3RseSB3aGF0IGlzIGJyb2tlbiBbM10g
YW5kIGl0J3Mgbm90IHdpc2UgdG8gImhhdmUgYSBidWcgdGhhdCBpcyBrbm93bg0KPiB0byBoYXBw
ZW4gd2hlbiB5b3UgZW5hYmxlIHRoZSBjYXBhYmlsaXR5Ii4NCj4gDQo+IEhvd2V2ZXIsIGZvciBz
b21lIHNwZWNpZmljIHNjZW5hcmlvcywgZS5nLiBURFgsIGludmFsaWRhdGluZyBhbmQNCj4gcmUt
Z2VuZXJhdGluZyBhIG5ldyBwYWdlIHRhYmxlIGlzIG5vdCB2aWFibGUgZm9yIHJlYXNvbnM6DQo+
IC0gVERYIHJlcXVpcmVzIHJvb3QgcGFnZSBvZiBwcml2YXRlIHBhZ2UgdGFibGUgcmVtYWlucyB1
bmFsdGVyZWQgdGhyb3VnaG91dA0KPiAgIHRoZSBURCBsaWZlIGN5Y2xlLg0KPiAtIFREWCBtYW5k
YXRlcyB0aGF0IGxlYWYgZW50cmllcyBpbiBwcml2YXRlIHBhZ2UgdGFibGUgbXVzdCBiZSB6YXBw
ZWQgcHJpb3INCj4gICB0byBub24tbGVhZiBlbnRyaWVzLg0KPiANCj4gU28sIFNlYW4gcmUtY29u
c2lkZXJlZCBhYm91dCBpbnRyb2R1Y2luZyBhIHBlci1WTSBmbGFnIG9yIHBlci1tZW1zbG90IGZs
YWcNCj4gYWdhaW4gZm9yIFZNcyBsaWtlIFREWC4gWzRdDQo+IA0KPiBUaGlzIHBhdGNoIGlzIGFu
IGltcGxlbWVudGF0aW9uIG9mIHBlci1tZW1zbG90IGZsYWcuDQo+IENvbXBhcmVkIHRvIHBlci1W
TSBmbGFnIGFwcHJvYWNoLA0KPiBQcm9zOg0KPiAoMSkgQnkgYWxsb3dpbmcgdXNlcnNwYWNlIHRv
IGNvbnRyb2wgdGhlIHphcHBpbmcgYmVoYXZpb3IgaW4gZmluZS1ncmFpbmVkDQo+ICAgICBncmFu
dWxhcml0eSwgb3B0aW1pemF0aW9ucyBmb3Igc3BlY2lmaWMgdXNlIGNhc2VzIGNhbiBiZSBkZXZl
bG9wZWQNCj4gICAgIHdpdGhvdXQgZnV0dXJlIGtlcm5lbCBjaGFuZ2VzLg0KPiAoMikgQWxsb3dz
IGRldmVsb3BpbmcgbmV3IHphcHBpbmcgYmVoYXZpb3JzIHdpdGhvdXQgcmlza2luZyByZWdyZXNz
aW9ucyBieQ0KPiAgICAgY2hhbmdpbmcgS1ZNIGJlaGF2aW9yLCBhcyBzZWVuIHByZXZpb3VzbHku
DQo+IA0KPiBDb25zOg0KPiAoMSkgVXNlcnMgbmVlZCB0byBlbnN1cmUgYWxsIG5lY2Vzc2FyeSBt
ZW1zbG90cyBhcmUgd2l0aCBmbGFnDQo+ICAgICBLVk1fTUVNX1pBUF9MRUFGU19PTkxZIHNldC5l
LmcuIFFFTVUgbmVlZHMgdG8gZW5zdXJlIGFsbCBHVUVTVF9NRU1GRA0KPiAgICAgbWVtc2xvdCBp
cyB3aXRoIFpBUF9MRUFGU19PTkxZIGZsYWcgZm9yIFREWCBWTS4NCj4gKDIpIE9wZW5zIHVwIHRo
ZSBwb3NzaWJpbGl0eSB0aGF0IHVzZXJzcGFjZSBjb3VsZCBjb25maWd1cmUgbWVtc2xvdHMgZm9y
DQo+ICAgICBub3JtYWwgVk0gaW4gc3VjaCBhIHdheSB0aGF0IHRoZSBidWcgWzFdIGlzIHNlZW4u
DQoNCkkgZG9uJ3QgcXVpdGUgZm9sbG93IHRoZSBsb2dpYyB3aHkgdXNlcnNwYWNlIHNob3VsZCBi
ZSBpbnZvbHZlZC4NCg0KVERYIGNhbm5vdCB1c2UgInBhZ2UgdGFibGUgZmFzdCB6YXAiLCBhbmQg
bmVlZCB0byB1c2UgYSBkaWZmZXJlbnQgd2F5IHRvDQp6YXAsIGEuay5hLCB6YXAtbGVhZi1vbmx5
IHdoaWxlIGhvbGRpbmcgTU1VIHdyaXRlIGxvY2ssIGJ1dCB0aGlzIGRvZXNuJ3QNCm5lY2Vzc2Fy
aWx5IG1lYW4gc3VjaCB0aGluZyBzaG91bGQgYmUgZXhwb3NlZCB0byB1c2Vyc3BhY2U/DQoNCkl0
J3Mgd2VpcmQgdGhhdCB1c2Vyc3BhY2UgbmVlZHMgdG8gY29udHJvbCBob3cgZG9lcyBLVk0gemFw
IHBhZ2UgdGFibGUgZm9yDQptZW1zbG90IGRlbGV0ZS9tb3ZlLg0KDQpUaGUgWzJdIG1lbnRpb25z
IHRoZXJlIGFyZSBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudCBmb3IgY2VydGFpbiBWTXMgaWYgS1ZN
DQpkb2VzIHphcC1sZWFmLW9ubHksIGJ1dCBBRkFJQ1QgaXQgZG9lc24ndCBwcm92aWRlIGNvbmNy
ZXRlIGFyZ3VtZW50IHdoeSBpdA0KbmVlZHMgdG8gYmUgZXhwb3NlZCB0byB1c2Vyc3BhY2Ugc28g
aXQgY2FuIGJlIGRvbmUgYXMgcGVyLXZtICh0aGF0IHdob2xlDQp0aHJlYWQgYmFzaWNhbGx5IHdh
cyB0YWxraW5nIGFib3V0IHRoZSBidWcgaW4gWzFdKS4gIEUuZy4sIHNlZToNCg0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcva3ZtLzIwMjAwNzEzMTkwNjQ5LkdFMjk3MjVAbGludXguaW50ZWwuY29t
L1QvI203MDJiMjczMDU3Y2MzMTg0NjVjYjVhMTY3N2Q5NGU5MjNkY2U5ODMyDQoNCiINCllhLCBh
IGNhcGFiaWxpdHkgaXMgYSBiYWQgaWRlYS4gSSB3YXMgY29taW5nIGF0IGl0IGZyb20gdGhlIGFu
Z2xlIHRoYXQsIGlmDQp0aGVyZSBpcyBhIGZ1bmRhbWVudGFsIHJlcXVpcmVtZW50IHdpdGggZS5n
LiBHUFUgcGFzc3Rocm91Z2ggdGhhdCByZXF1aXJlcw0KemFwcGluZyBhbGwgU1BURXMsIHRoZW4g
ZW5hYmxpbmcgdGhlIHByZWNpc2UgY2FwYWJpbGl0eSBvbiBhIHBlci1WTSBiYXNpcw0Kd291bGQg
bWFrZSBzZW5zZS4gIEJ1dCBhZGRpbmcgc29tZXRoaW5nIHRvIHRoZSBBQkkgb24gcHVyZSBzcGVj
dWxhdGlvbiBpcw0Kc2lsbHkuDQoiDQoNClNvIHRvIG1lIGxvb2tzIGl0J3Mgb3ZlcmtpbGwgdG8g
ZXhwb3NlIHRoaXMgInphcC1sZWFmLW9ubHkiIHRvIHVzZXJzcGFjZS4NCldlIGNhbiBqdXN0IHNl
dCB0aGlzIGZsYWcgZm9yIGEgVERYIGd1ZXN0IHdoZW4gbWVtc2xvdCBpcyBjcmVhdGVkIGluIEtW
TS4NCg0KPiANCj4gSG93ZXZlciwgb25lIHRoaW5nIGRlc2VydmVzIG5vdGluZyBmb3IgVERYLCBp
cyB0aGF0IFREWCBtYXkgcG90ZW50aWFsbHkNCj4gbWVldCBidWcgWzFdIGZvciBlaXRoZXIgcGVy
LW1lbXNsb3QgZmxhZyBvciBwZXItVk0gZmxhZyBhcHByb2FjaCwgc2luY2UNCj4gdGhlcmUncyBh
IHVzYWdlIGluIHJhZGFyIHRvIGFzc2lnbiBhbiB1bnRydXN0ZWQgJiBwYXNzdGhyb3VnaCBHUFUg
ZGV2aWNlDQo+IGluIFREWC4gSWYgdGhhdCBoYXBwZW5zLCBpdCBjYW4gYmUgdHJlYXRlZCBhcyBh
IGJ1ZyAobm90IHJlZ3Jlc3Npb24pIGFuZA0KPiBmaXhlZCBhY2NvcmRpbmdseS4NCj4gDQo+IEFu
IGFsdGVybmF0aXZlIGFwcHJvYWNoIHdlIGNhbiBhbHNvIGNvbnNpZGVyIGlzIHRvIGFsd2F5cyBp
bnZhbGlkYXRlICYNCj4gcmVidWlsZCBhbGwgc2hhcmVkIHBhZ2UgdGFibGVzIGFuZCB6YXAgb25s
eSBtZW1zbG90IGxlYWYgU1BURXMgZm9yIG1pcnJvcmVkDQo+IGFuZCBwcml2YXRlIHBhZ2UgdGFi
bGVzIG9uIG1lbXNsb3QgZGVsZXRpb24uIFRoaXMgYXBwcm9hY2ggY291bGQgZXhlbXB0IFREWA0K
PiBmcm9tIGJ1ZyBbMV0gd2hlbiAidW50cnVzdGVkICYgcGFzc3Rocm91Z2giIGRldmljZXMgYXJl
IGludm9sdmVkLiBCdXQNCj4gZG93bnNpZGUgaXMgdGhhdCB0aGlzIGFwcHJvYWNoIHJlcXVpcmVz
IGNyZWF0aW5nIG5ldyB2ZXJ5IHNwZWNpZmljIEtWTQ0KPiB6YXBwaW5nIEFCSSB0aGF0IGNvdWxk
IGxpbWl0IGZ1dHVyZSBjaGFuZ2VzIGluIHRoZSBzYW1lIHdheSB0aGF0IHRoZSBidWcNCj4gZGlk
IGZvciBub3JtYWwgVk1zLg0KPiANCj4gTGluazogaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9y
Zy9wcm9qZWN0L2t2bS9wYXRjaC8yMDE5MDIwNTIxMDEzNy4xMzc3LTExLXNlYW4uai5jaHJpc3Rv
cGhlcnNvbkBpbnRlbC5jb20gWzFdDQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2
bS8yMDIwMDcxMzE5MDY0OS5HRTI5NzI1QGxpbnV4LmludGVsLmNvbS9ULyNtYWJjMDExOTU4M2Rh
Y2Y2MjEwMjVlOWQ4NzNjODVmNGZiYWE2NmQ1YyBbMl0NCj4gTGluazogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcva3ZtLzIwMjAwNzEzMTkwNjQ5LkdFMjk3MjVAbGludXguaW50ZWwuY29tL1QvI20x
ODM5Yzg1MzkyYTdhMDIyZGY5ZTUwNzg3NmJiMjQxYzAyMmM0ZjA2IFszXQ0KPiBMaW5rOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9rdm0vWmhTWUVWQ0hxU09wVktNaEBnb29nbGUuY29tIFs0XQ0K
PiBTaWduZWQtb2ZmLWJ5OiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IFNpZ25l
ZC1vZmYtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4g
LS0tDQo+IFREWCBNTVUgUGFydCAxOg0KPiAgLSBOZXcgcGF0Y2gNCj4gLS0tDQo+ICBhcmNoL3g4
Ni9rdm0vbW11L21tdS5jICAgfCAzMCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0NCj4g
IGFyY2gveDg2L2t2bS94ODYuYyAgICAgICB8IDE3ICsrKysrKysrKysrKysrKysrDQo+ICBpbmNs
dWRlL3VhcGkvbGludXgva3ZtLmggfCAgMSArDQo+ICB2aXJ0L2t2bS9rdm1fbWFpbi5jICAgICAg
fCAgNSArKysrLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCA1MSBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMgYi9hcmNo
L3g4Ni9rdm0vbW11L21tdS5jDQo+IGluZGV4IDYxOTgyZGE4YzhiMi4uNGE4ZTgxOTc5NGRiIDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2
bS9tbXUvbW11LmMNCj4gQEAgLTY5NjIsMTAgKzY5NjIsMzggQEAgdm9pZCBrdm1fYXJjaF9mbHVz
aF9zaGFkb3dfYWxsKHN0cnVjdCBrdm0gKmt2bSkNCj4gIAlrdm1fbW11X3phcF9hbGwoa3ZtKTsN
Cj4gIH0NCj4gIA0KPiArc3RhdGljIHZvaWQga3ZtX21tdV96YXBfbWVtc2xvdF9sZWFmcyhzdHJ1
Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fbWVtb3J5X3Nsb3QgKnNsb3QpDQo+ICt7DQo+ICsJaWYg
KEtWTV9CVUdfT04oIXRkcF9tbXVfZW5hYmxlZCwga3ZtKSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+
ICsJd3JpdGVfbG9jaygma3ZtLT5tbXVfbG9jayk7DQo+ICsNCj4gKwkvKg0KPiArCSAqIFphcHBp
bmcgbm9uLWxlYWYgU1BURXMsIGEuay5hLiBub3QtbGFzdCBTUFRFcywgaXNuJ3QgcmVxdWlyZWQs
IHdvcnN0DQo+ICsJICogY2FzZSBzY2VuYXJpbyB3ZSdsbCBoYXZlIHVudXNlZCBzaGFkb3cgcGFn
ZXMgbHlpbmcgYXJvdW5kIHVudGlsIHRoZXkNCj4gKwkgKiBhcmUgcmVjeWNsZWQgZHVlIHRvIGFn
ZSBvciB3aGVuIHRoZSBWTSBpcyBkZXN0cm95ZWQuDQo+ICsJICovDQo+ICsJc3RydWN0IGt2bV9n
Zm5fcmFuZ2UgcmFuZ2UgPSB7DQo+ICsJCS5zbG90ID0gc2xvdCwNCj4gKwkJLnN0YXJ0ID0gc2xv
dC0+YmFzZV9nZm4sDQo+ICsJCS5lbmQgPSBzbG90LT5iYXNlX2dmbiArIHNsb3QtPm5wYWdlcywN
Cj4gKwkJLm1heV9ibG9jayA9IHRydWUsDQo+ICsJfTsNCj4gKw0KPiArCWlmIChrdm1fdGRwX21t
dV91bm1hcF9nZm5fcmFuZ2Uoa3ZtLCAmcmFuZ2UsIGZhbHNlKSkNCj4gKwkJa3ZtX2ZsdXNoX3Jl
bW90ZV90bGJzKGt2bSk7DQo+ICsNCj4gKwl3cml0ZV91bmxvY2soJmt2bS0+bW11X2xvY2spOw0K
PiArfQ0KPiArDQo+ICB2b2lkIGt2bV9hcmNoX2ZsdXNoX3NoYWRvd19tZW1zbG90KHN0cnVjdCBr
dm0gKmt2bSwNCj4gIAkJCQkgICBzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpzbG90KQ0KPiAgew0K
PiAtCWt2bV9tbXVfemFwX2FsbF9mYXN0KGt2bSk7DQo+ICsJaWYgKHNsb3QtPmZsYWdzICYgS1ZN
X01FTV9aQVBfTEVBRlNfT05MWSkNCj4gKwkJa3ZtX21tdV96YXBfbWVtc2xvdF9sZWFmcyhrdm0s
IHNsb3QpOw0KPiArCWVsc2UNCj4gKwkJa3ZtX21tdV96YXBfYWxsX2Zhc3Qoa3ZtKTsNCj4gIH0N
Cj4gIA0KPiAgdm9pZCBrdm1fbW11X2ludmFsaWRhdGVfbW1pb19zcHRlcyhzdHJ1Y3Qga3ZtICpr
dm0sIHU2NCBnZW4pDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4
Ni9rdm0veDg2LmMNCj4gaW5kZXggN2M1OTNhMDgxZWJhLi40YjNlYzJlYzc5ZTkgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4g
QEAgLTEyOTUyLDYgKzEyOTUyLDIzIEBAIGludCBrdm1fYXJjaF9wcmVwYXJlX21lbW9yeV9yZWdp
b24oc3RydWN0IGt2bSAqa3ZtLA0KPiAgCQlpZiAoKG5ldy0+YmFzZV9nZm4gKyBuZXctPm5wYWdl
cyAtIDEpID4ga3ZtX21tdV9tYXhfZ2ZuKCkpDQo+ICAJCQlyZXR1cm4gLUVJTlZBTDsNCj4gIA0K
PiArCQkvKg0KPiArCQkgKiBTaW5jZSBURFggcHJpdmF0ZSBwYWdlcyByZXF1aXJlcyByZS1hY2Nl
cHRpbmcgYWZ0ZXIgemFwLA0KPiArCQkgKiBhbmQgVERYIHByaXZhdGUgcm9vdCBwYWdlIHNob3Vs
ZCBub3QgYmUgemFwcGVkLCBURFggcmVxdWlyZXMNCj4gKwkJICogbWVtc2xvdHMgZm9yIHByaXZh
dGUgbWVtb3J5IG11c3QgaGF2ZSBmbGFnDQo+ICsJCSAqIEtWTV9NRU1fWkFQX0xFQUZTX09OTFkg
c2V0IHRvbywgc28gdGhhdCBvbmx5IGxlYWYgU1BURXMgb2YNCj4gKwkJICogdGhlIGRlbGV0aW5n
IG1lbXNsb3Qgd2lsbCBiZSB6YXBwZWQgYW5kIFNQVEVzIGluIG90aGVyDQo+ICsJCSAqIG1lbXNs
b3RzIHdvdWxkIG5vdCBiZSBhZmZlY3RlZC4NCj4gKwkJICovDQo+ICsJCWlmIChrdm0tPmFyY2gu
dm1fdHlwZSA9PSBLVk1fWDg2X1REWF9WTSAmJg0KPiArCQkgICAgKG5ldy0+ZmxhZ3MgJiBLVk1f
TUVNX0dVRVNUX01FTUZEKSAmJg0KPiArCQkgICAgIShuZXctPmZsYWdzICYgS1ZNX01FTV9aQVBf
TEVBRlNfT05MWSkpDQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCQkvKiB6YXAtbGVh
ZnMtb25seSB3b3JrcyBvbmx5IHdoZW4gVERQIE1NVSBpcyBlbmFibGVkIGZvciBub3cgKi8NCj4g
KwkJaWYgKChuZXctPmZsYWdzICYgS1ZNX01FTV9aQVBfTEVBRlNfT05MWSkgJiYgIXRkcF9tbXVf
ZW5hYmxlZCkNCj4gKwkJCXJldHVybiAtRUlOVkFMOw0KDQpJZiB0aGlzIHphcC1sZWFmLW9ubHkg
aXMgc3VwcG9zZWQgdG8gYmUgZ2VuZXJpYywgSSBkb24ndCBzZWUgd2h5IHdlIHdhbnQNCnRvIG1h
a2UgaXQgb25seSBmb3IgVERQIE1NVT8NCg0K

