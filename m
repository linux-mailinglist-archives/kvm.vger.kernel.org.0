Return-Path: <kvm+bounces-56101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE6CB39B51
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B34A1C26F68
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016E530BBB2;
	Thu, 28 Aug 2025 11:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DKLz7vQF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC3B15B0FE
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 11:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379868; cv=fail; b=heOKsiAPRpgNHBlAHhIaDFiVskFsI6V4yzJXsZmv9r9+UaqfFizWiVINNGxY06WTPXcFyIa0o2WsS/UtQ37eYxeLq+dAZ6WWcYNIBFbBDs+fL+yan5sNqmy4LGT1kAhZHxohf4gisFkXkB7WVax68k2x+YMKA7i7JE4kcOpTBlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379868; c=relaxed/simple;
	bh=gKQFabR+n9qwj4pT7o+ksw2GGi5BYgFbO7ACMgBzuP8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iEXcYjjLbLnlE6jqCtUpU1WNO5nd/2Ml/W96IxyPz3pmS+7xv90izG5mlWU03tahB60Tfyb1w2oNLqvcx8pXj+RuX/4Lwu2Eg/QUGu0W4m64EcH5dbyTr1VloYlCuNUg+UoDLeKnCB0BAE6JyZ1OgfMhJm2dvVb/+riqBffEbEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DKLz7vQF; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756379867; x=1787915867;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gKQFabR+n9qwj4pT7o+ksw2GGi5BYgFbO7ACMgBzuP8=;
  b=DKLz7vQFsKFGlBel/UJWujVCfSLZEpLxlqrngDafkQjS7xz6rVr/S93l
   CiBqC4yI451SjsTqNVeJHToXpiG5YQztQI1lZjAI0wZ8DlgwAcbK66J+9
   m/Pca7cOtKaMkUzjV/DlzG6uwA8P6uFH+/uTW7OuGzyAOtVW3AAgV5E4a
   UezRcQZE3f/CinUTbBmiXVE7D9F6tVXgMIUAiK1trCY5J1oAYcexkG81p
   etqht3wF4Z7yjQ79RjPxKX05RWYAl31pPfuBJj9y+3MZrTSTRoy9gyQNl
   JGG7mxdfkCXCDQLn5zmsCecXTHeOQ3x82qlRwcILw1dfnp1Ph7Yra0dsB
   A==;
X-CSE-ConnectionGUID: 96UDrOGXQDmll+sh73wORQ==
X-CSE-MsgGUID: g3TcT7vsQtmjd1z8xG/Ldw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62479607"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62479607"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 04:17:46 -0700
X-CSE-ConnectionGUID: +YUghzsGTqOGjK4d2apKKA==
X-CSE-MsgGUID: 3O5yAjY+T2mW1b2cPUDEvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="201051189"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 04:17:46 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 04:17:45 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 04:17:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.81) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 04:17:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EtwWcYS7mPvDUYZIyn0+cwgN6BinJxB8Eb1pZWNN4sWPrfHc88etjTyu9aeGL+SLhIfbC93iE+LCeyCBfhDz6Y3S9VbzHLVinqdZCMvfv675v+j1nFQ/wJYNG3tEoOvExet4zu4yCVgNtm7n8xOY+wUBwZRpIn31pzrSkRqZYlSopC7GygnEX9baF0Pal01Ew6k4yGGNLgYD7qZCFKOiITs4fviV4Ng+uJ+E7Y6W6TGH7E2AMeyoD3GShETbaz430a7eZvaMRitK2t/+6V3LCCxOG8eakg15639lfJmSHJKDF1/XQKnPvPDEvoY0/A6UwfPNbd8AplM9ghNlm1QWAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKQFabR+n9qwj4pT7o+ksw2GGi5BYgFbO7ACMgBzuP8=;
 b=sS1l5mV9ho0n8RJMPnQvtdGd8CmK0fhdKHj1DIVb0OfewvX+QTNrQEF3RbKyUYkVigfZlalxNEX6Tc+H1X+MMzml04cmrygMujAear9Emo89NiExvZKh9iW7dz58+pLNVhMJ8jHrBMkBGhxJ3vB8xIPxr0fyJHyKUAHgvBZDoSGHKNMqjcSDsGoP7/qk//yAh40rUhrS9uX68eMmXjun3dxjis1jkWX2N28ug1Mrym4Jai7So7tNUkZRXnHeEqm4e5SIQKROLysPI4FARHfAAS3eEEYkj2t1d/R65xoC0wmPgLD5mOYuHaCnXW33IRiCSotVk30qfgGONHWzdOAVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL4PR11MB8869.namprd11.prod.outlook.com (2603:10b6:208:5a8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Thu, 28 Aug
 2025 11:17:39 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9073.016; Thu, 28 Aug 2025
 11:17:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "nikunj@amd.com"
	<nikunj@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Thread-Topic: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcFdP/eGfeNpsxKkei0uEsxdMRfrR3LX6AgABzVoCAAEHjAIAAAtaAgAAHLICAAAJUgA==
Date: Thu, 28 Aug 2025 11:17:38 +0000
Message-ID: <2938e7f71318f1ed03f5db6a5e4efa460bb5fd79.camel@intel.com>
References: <20250825152009.3512-1-nikunj@amd.com>
		 <20250825152009.3512-5-nikunj@amd.com>
		 <fb9f2dcb176b9a930557cabc24186b70522d945d.camel@intel.com>
		 <86c883c4-c9a6-4ec8-b5f3-eb90b0b7918d@amd.com>
		 <9e214c34f68ac985530020cef61f480f2c5922c9.camel@intel.com>
		 <fd1b557e-8b19-4e71-8e60-3b35864d63cb@amd.com>
	 <444b1373702fb4871e82381bf3e01d9228df7f01.camel@intel.com>
In-Reply-To: <444b1373702fb4871e82381bf3e01d9228df7f01.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL4PR11MB8869:EE_
x-ms-office365-filtering-correlation-id: 6346188d-d3cc-425d-bc49-08dde6247f96
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RFNhM2lPVGR2YWx4bGNNNzNHNjk3VUczby8xL3M0VU9KekpCRnJYYzdFSTBT?=
 =?utf-8?B?TXdZOEY4ODgxYUFnYVcvNEIzS3gxTWdnVTFsblJOSGNwRW9hcGJFREx4U09U?=
 =?utf-8?B?Ti9LTm1MTzFuVHRBT2pWTHRPclR5alUyck82WFpPdzQ0Nld3bFJ2UzhOVjZE?=
 =?utf-8?B?SjRwOVozVi9pZ3RsWmFCSkRER1paWWxwcWF0a0Z3M3FUbWppanRwb3lyaGdw?=
 =?utf-8?B?cVBDU1BWNUlpaDZsRTkxR2NHQ0lhS3V4WVVNTFFsK3ZmUFlLOWd6VENPem56?=
 =?utf-8?B?aVlaMzR3UTRlVy9HWEc3cWJYdlZEdU9tczhmczU1OC9zc2xJU1FvTnZmM0Yw?=
 =?utf-8?B?c3FjMU1EZk45QVJSb3NLdVNZQks5alpYSGsrWlJvOWRUWThQblNUYnVid2Uy?=
 =?utf-8?B?dFd0MnhHUGF6SnRGdkd2NVFUeUF0NHJic1J6Qm5UQldYYzRoSms1cEV2Z2Na?=
 =?utf-8?B?WElXQnF2RkR6SlBybHk3MEJWT3E3Rmt6WVNaMTBnUjNUeFZzV1JpV0ZZWGVk?=
 =?utf-8?B?WHBDV2xrTkZqN3BLTlA0Z2dlZ3VoT0xDNythd0o0KzVXUStFRnRwRXAwaGkr?=
 =?utf-8?B?anFrMUhjMlh5Y2hEQkhTcFMxaVlEOFZRUWFtTlpNRGJPV0F1elhLMFBydk5o?=
 =?utf-8?B?K1BBci9Xd3RaYnhJb0VjNG1KMEo4RWx1RCs3dHNrcG51eFhUU05sMW4xMXM0?=
 =?utf-8?B?Ni85SEx6U3BOWkVOaE5vaGZTVERDdktSc01BY3lrbmdSVXFzTWphTjhmY0N5?=
 =?utf-8?B?THhQWnExbEc5NjQzbnNKZ0xWVGZDakpyanpvU3hRdE9IdHdLb1JSWmJ3ZlZk?=
 =?utf-8?B?cytXWEtTMEM3RStKTUdiR1B2OW1iNzA4YlBUQ1BLZGgzTEFQWUlKQVdqTUhH?=
 =?utf-8?B?bmRwL2lFR3I4RitqZEdvZWdBcW9FTlhTRm14eU9TaExSZ280OE92cXVDYVNJ?=
 =?utf-8?B?T2VHbUNJZUQra1F5b00vK2JBVzhsaG5NT3pkODNyYStGVWt4VVRQdDlCL2Za?=
 =?utf-8?B?Ky91b0FFQitTM01tbEpSL2d4VjNUOG1teE9lTnFTTW5lZFZPM0FMVVdWTGd5?=
 =?utf-8?B?NzNtWlFEWFZWd0JVdWRuaytDaUJCdDhHMUpSNVczN2haSU5JbHh4SjVoMGxT?=
 =?utf-8?B?SEZRTW1oV0gxVTdJaXNKb1B4eTUyYjlvMHZSVGZZU21QaXRoTXBkWnBvcjBa?=
 =?utf-8?B?TnN0cjVNbHJLeFNkOWk1NWVMejJmUG0yV0IyaHNMbyswdmxZMkYyOXBOM2Ns?=
 =?utf-8?B?SXg3aFJ1TllJOCtUMTBOVmVRU1Y4L0NiMnB2RWFPNTBiMzcvSzJBUWFUVG1U?=
 =?utf-8?B?ajNGbGpxbVNHekc2QklSK2tEcEVCRjRUekY4MWxrZjZnTGVRdFZubnh6MjZZ?=
 =?utf-8?B?MXd0amdOdXpiUnhHZmR6RmxWakhGYnpEOEd0SDlVYWRPY0pMTVRoYTVNS0Z3?=
 =?utf-8?B?dDVDbE10b25PUzc4UTVqM2dSdHQ5OHRRQU80YTNpd0hXbXlpaEN5REIrMlZO?=
 =?utf-8?B?NlVTM3JDeFg5MUU1ZjMrMkRkdXA0K3l1RjI3ZmFJVkNhTGliY3J0dmJDOFNw?=
 =?utf-8?B?MW9xWkpsck8zQTdoL0RVOVdYb05rUnpEYTJ4MUNJZkQ3QmZpb3ZqR1NjZ1Nx?=
 =?utf-8?B?enVLbm1vYTlzWWJnanFWRThqcFhha0VhaWlVMFoyb2U2UWp5QkVIVEljSGR2?=
 =?utf-8?B?V1hPZjRWQ3NqMDd0aWh6MHprUC9ubmlyeEhsVnJDWFNpN3QrZmJZRWhJazZN?=
 =?utf-8?B?SjVmQWJnRzRLNGFJRUJCU2phVUh3YjNUK0EwZjZoeWVMZS9UZ3o5cDZQSHgy?=
 =?utf-8?B?TlNEc1NEOUQwKzlja0tEalJ1Qm9DTjZzQmVxUmNlaTJJSlNNei9WOFEwVXZD?=
 =?utf-8?B?dFUweEgrbEt5WDdGRFlOU0J3bno2OS9xZmp6TkNUblhXMFlKS1BjaVZmUTgy?=
 =?utf-8?B?Qml4bXorbkl1dUJiYXdnVnpTemVHTXRrUndHakhiRk5hRjlhaVJzd2w4NHdh?=
 =?utf-8?B?dGxzYzQwQ0VRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkttWkh5TjRCNUtuT3VXVUxaYWk2YWoxSjhmNDluOTZOVDhDUlJkdWxhNld1?=
 =?utf-8?B?bnV2Q2x0MStUMEZNd1RxT0t0QWZLM0JoMUZIQTFUWnYxci80TTlzeUNKK0Rk?=
 =?utf-8?B?cVZNRUtkNzdiOVM1REQvRnB5WXI4T3dnQ0FDTy9XTzNJWlJoZ0Q4QklTSDdv?=
 =?utf-8?B?M3VQVGdYY2E0QzRjbnVTSTBudUYydHZSNjV1NkgrT05JOVZseGJYNWpBRlNL?=
 =?utf-8?B?bFVwUGNDZERFSWNPTUwrU1l3K0JDL2ZNYWpDeVA3R2EvbzcxblAvTGp5bmhS?=
 =?utf-8?B?YzRzMVluMy9IZWUwZ1NJekh3S0l6UUwyWmloa3AzbmsyS0haWmdCdHFHODgz?=
 =?utf-8?B?RkVWRERKRUhGTlpxWFZUZnpNamtMQlN0a0tMMUhwYXpkbUcxWGZkUHc0MVJ1?=
 =?utf-8?B?S296NUxvOU1zRHMxNUdTcnRURk9WajFXZmdvSnI2blJSM3lRVGhhdjFrek1h?=
 =?utf-8?B?UElQWWNrRGc2UXFTWHRsdEUwQ1VIZE50TmNubVVIcGVhbUwwcVFqM1BSRk1v?=
 =?utf-8?B?d3UvYkY5cm5aNTBnUnIyUGNGeC9FWGtMak1CYlF5ZFR6T2ZNNExaK3FQY1d5?=
 =?utf-8?B?UGpwOURuWDZ3cy9PWVFadVdoZjZndktidEgxYnl6ZVhZcVNka3luc2tRcTVW?=
 =?utf-8?B?azdjUzUzb1piaU56NEZPRXNWS3pCclpGTEU4bEg0MkhmSXY3N2ZseGlSSU5x?=
 =?utf-8?B?VVlReW9ncHBuZHNYYVVoSTVzNS8zZFVKdTJMYXBKNVpJYm54dmc2b3VoTDZa?=
 =?utf-8?B?WmlERmpyTWJxSk9wN1k0MGkrelRmTmlxZjk5WXpRVUdhYjRocG9iV1ZJRDIw?=
 =?utf-8?B?WFgrZ2NBMnlTVnUrQ2J3SHZTRjdmWUhsdFd3alZ5Vm0vSFFNTExqMGUvRWNT?=
 =?utf-8?B?S2trdXJhT0g4aHZOT1VCTmtmTTJ2OEtISUtaa1dXcE1Nak1GbVB4Z0hWQ1lW?=
 =?utf-8?B?NytIT3c1dDdYSEFDN25QUThscjBMZ2RFd2hVZ2R0bGh2bVh2R0V1a01hT2tV?=
 =?utf-8?B?VWQwZkg5RmFFTEtjazFjSUw3d210R3lrQnpJMGMyQVBCUlNRU3dnWTRsenJ4?=
 =?utf-8?B?Y2tlUkhaVUVwM0NvZHd5WnkrdlpyRHRXZlNMN0tQTHZaSDhBT3VCdW5uQ1d3?=
 =?utf-8?B?TjhXRE92cU5OMklHN0I3Rmp2aVhEOVByL3JNRjFaOTRHTCs5UEE0WDZyRmJX?=
 =?utf-8?B?dmV3Wk96OE9HbmNXRjkyREwrRUk2ZGdtSG4xZ2h1NnF6eGVhN1pwbFpoQ1Jm?=
 =?utf-8?B?TklvOFM4ckJQT1I4Y1pLYnkwVmMySUM1UVpoZ1h1Z0NDTjBTK2tLQlBoTU1V?=
 =?utf-8?B?aWdxYlBmYUFzR0twdXdiMEozSi9Ha3FMUkNRQTQ1MkR2SS9pb3hyRTRJNjlv?=
 =?utf-8?B?ZGVnOEhwNlBlMWUxTDFTTDhocGJEUnl1dnEvSVhWZEgyeWRUMWVjbStmb3hG?=
 =?utf-8?B?aU9PRXJoSXp6bjJrSkdLVzVSVVN1RDRvRVdnN2R3TEpHcHRuZjV6V2Zvd01X?=
 =?utf-8?B?cWM1cWxReFErbHBFa1hxMk9YUkNacUpUSldUWDVjQkVkUG1DQ2VkUlVVS3Rs?=
 =?utf-8?B?dUh3ZWJFV2JrN3B0cTBJaitYbTJLZDBOc0loTHUveFQyUlIyRkU0UXRHdzR5?=
 =?utf-8?B?SGJCdi9XYXRZRWYrcVBsMjBMRHRGdFZZQmpvakNGRHJrSkhvcnFQd1drSFdq?=
 =?utf-8?B?cTROZzRpQnZJMVJlL29XMmcwVHdTQ1BDRkpyZFU5dTg0MUtQRlJJZnhhcUdR?=
 =?utf-8?B?ZlpmZGI5Q0orYmZmdGxmUkFnNWM0VDVlTkpoeDkrK1U4RG15MEJqeW95OHZN?=
 =?utf-8?B?ZEpSeDN0aStvdy9CTkJlV1k3UTJNSUtmdkVQejlsY29vc0hCdVJ0N2F4N2Z4?=
 =?utf-8?B?VGNXSlYzTnlTWnB5UWEzNWR0aXhGNEQ3WkNVajBONnJURUFIeHZBK05UbmJm?=
 =?utf-8?B?WUNjcDlza3dOdmE0SHlqUEZMWlYyNkcyUUVWU3h4SVlMUDZoUGpvUkZZZThh?=
 =?utf-8?B?SkVxTHIwMzFTL2w4MWxiTzFacjBycndRcTdjM05GUkRXUWZGTG1sTTFhVmpp?=
 =?utf-8?B?eUs2YmdnNFd0THdLMU9ocmRlTzNyMjkwb2ZiVkhnT2tPMGVFQUFRcERJdUxj?=
 =?utf-8?Q?C/fAsuFFB6ihkXCzHUbNnF6rx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3F9BB78BBFFF14F9F2ABDD161E9BA80@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6346188d-d3cc-425d-bc49-08dde6247f96
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 11:17:38.9889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y0tL4V6/NGjxzl/r/k6Na9ClXWphVGyyKFHIVsQwDujOAFYe3iCHNNTO6trpllX+4gi/hbSEPmM9tEUsn3kZNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8869
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDExOjA5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjUtMDgtMjggYXQgMTY6MTMgKzA1MzAsIE5pa3VuaiBBLiBEYWRoYW5pYSB3cm90
ZToNCj4gPiBPbiA4LzI4LzIwMjUgNDowMyBQTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IE9u
IFRodSwgMjAyNS0wOC0yOCBhdCAxMjowNyArMDUzMCwgTmlrdW5qIEEuIERhZGhhbmlhIHdyb3Rl
Og0KPiA+ID4gPiANCj4gPiA+ID4gT24gOC8yOC8yMDI1IDU6MTQgQU0sIEh1YW5nLCBLYWkgd3Jv
dGU6DQo+ID4gPiA+ID4gT24gTW9uLCAyMDI1LTA4LTI1IGF0IDE1OjIwICswMDAwLCBOaWt1bmog
QSBEYWRoYW5pYSB3cm90ZToNCj4gPiA+ID4gPiA+ICsJaWYgKHBtbCkgew0KPiA+ID4gPiA+ID4g
KwkJc3ZtLT5wbWxfcGFnZSA9IHNucF9zYWZlX2FsbG9jX3BhZ2UoKTsNCj4gPiA+ID4gPiA+ICsJ
CWlmICghc3ZtLT5wbWxfcGFnZSkNCj4gPiA+ID4gPiA+ICsJCQlnb3RvIGVycm9yX2ZyZWVfdm1z
YV9wYWdlOw0KPiA+ID4gPiA+ID4gKwl9DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSSBkaWRuJ3Qg
c2VlIHRoaXMgeWVzdGVyZGF5LsKgIElzIGl0IG1hbmRhdG9yeSBmb3IgQU1EIFBNTCB0byB1c2UN
Cj4gPiA+ID4gPiBzbnBfc2FmZV9hbGxvY19wYWdlKCkgdG8gYWxsb2NhdGUgdGhlIFBNTCBidWZm
ZXIsIG9yIHdlIGNhbiBhbHNvIHVzZQ0KPiA+ID4gPiA+IG5vcm1hbCBwYWdlIGFsbG9jYXRpb24g
QVBJPw0KPiA+ID4gPiANCj4gPiA+ID4gQXMgaXQgaXMgZGVwZW5kZW50IG9uIEh2SW5Vc2VXckFs
bG93ZWQsIEkgbmVlZCB0byB1c2Ugc25wX3NhZmVfYWxsb2NfcGFnZSgpLg0KPiA+ID4gDQo+ID4g
PiBTbyB0aGUgcGF0Y2ggMiBpcyBhY3R1YWxseSBhIGRlcGVuZGVudCBmb3IgUE1MPw0KPiA+IA0K
PiA+IE5vdCByZWFsbHksIGlmIHRoZSBwYXRjaCAyIGlzIG5vdCB0aGVyZSwgdGhlIDJNQiBhbGln
bm1lbnQgd29ya2Fyb3VuZCB3aWxsIGJlDQo+ID4gYXBwbGllZCB0byBQTUwgcGFnZSBhbGxvY2F0
aW9uLg0KPiANCj4gU291bmRzIHRoZXkgYXJlIHJlbGF0ZWQsIGF0IGxlYXN0Lg0KPiANCj4gSSBk
b24ndCBoYXZlIGludGVudGlvbiB0byBqdWRnZSB3aGV0aGVyIHBhdGNoIDIgc2hvdWxkIGJlIGlu
IHRoaXMgc2VyaWVzDQo+IG9yIG5vdCwgbm9yIHdoZXRoZXIgc25wX3NhZmVfYWxsb2NfcGFnZV9u
b2RlKCkgaXMgdGhlIHJpZ2h0IHBsYWNlIHRvDQo+IHdvcmthcm91bmQgdGhlIDJNQiBhbGlnbm1l
bnQgZm9yIFBNTCBidWZmZXIuDQo+IA0KPiBJIGp1c3QgdGhpbmsgaXQncyBnb29kIHRvIHNlZSBz
b21lIHRleHQgZXhwbGFpbmluZyB3aHkgcGF0Y2ggMiBpcyBuZWVkZWQNCj4gZm9yIFBNTCBpZiBl
dmVudHVhbGx5IHlvdSBkZWNpZGUgdG8ga2VlcCBpdCBpbiB0aGlzIHNlcmllcy4NCg0KQnR3LCB0
aGVyZSdzIG9uZSBiaWcgY29tbWVudCBpbiBzbnBfc2FmZV9hbGxvY19wYWdlX25vZGUoKToNCg0K
ICAgICAgICAvKg0KICAgICAgICAgKiBBbGxvY2F0ZSBhbiBTTlAtc2FmZSBwYWdlIHRvIHdvcmth
cm91bmQgdGhlIFNOUCBlcnJhdHVtIHdoZXJlIA0KICAgICAgICAgKiB0aGUgQ1BVIHdpbGwgaW5j
b3JyZWN0bHkgc2lnbmFsIGFuIFJNUCB2aW9sYXRpb24gI1BGIGlmIGENCiAgICAgICAgICogaHVn
ZXBhZ2UgKDJNQiBvciAxR0IpIGNvbGxpZGVzIHdpdGggdGhlIFJNUCBlbnRyeSBvZiBhDQogICAg
ICAgICAqIDJNQi1hbGlnbmVkIFZNQ0IsIFZNU0EsIG9yIEFWSUMgYmFja2luZyBwYWdlLiAgDQoJ
ICogLi4uDQoJICovDQoNCllvdSBtaWdodCB3YW50IHRvIGluY2x1ZGUgdGhlIFBNTCBidWZmZXIg
dG8gdGhlIGxpc3QgdG9vLg0K

