Return-Path: <kvm+bounces-44937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 708FBAA50AA
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:46:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB9B64C04EE
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168392620D1;
	Wed, 30 Apr 2025 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H7BvEmdv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6817405A;
	Wed, 30 Apr 2025 15:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746027961; cv=fail; b=tf3CPQeftD81Lk8YCraFdgHNWrdc5mow7IWeotDZ6rAw0vwznsvueKPO/ajHHOLmBF0B+fSwAMScBvQsTZalURcxem4pHZnN8SGGrwiZ1zNqKUZOta9QAYta0BgFBdot8tEhfiBgS/o5MhMoWXdvfjYjJwu8eWpC5hoFw8AvjCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746027961; c=relaxed/simple;
	bh=uAuWeCIWAyQ2g8IF8rQhTiPv+WdnIpUJLRtH2lK8sVg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k4XPMtycFjOvS/Yiv88ovysUS48cBtM0G85jVc9UnVQcZgcI3TSA0HaENaZkmWUiZfwhog/K3ze64sxNIcimkcag2Q5L1pCGtWMVPxHxXTk+FYxUqUAgzNQlGmaqhec4v+0Sz9fFEf4P0gmP0JOCHE/X01vIiDwW0nNcJVnkOsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H7BvEmdv; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746027959; x=1777563959;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uAuWeCIWAyQ2g8IF8rQhTiPv+WdnIpUJLRtH2lK8sVg=;
  b=H7BvEmdv5+mhe20r2KH2Ir+AXq9IDKuzU44nl9BmzpSFLh5acLitCUNK
   Ih4qVPzo9Z4+aLiHO5lmA5SwaR5TqHy892Z87cctPNH48N4kHDNKKHc9w
   vZWpLaI9FuitIwmjmDLluUKpRStgLsh6Zq4d/llKxNbJLzO8rrQnmBH/G
   Bz3mk1d3tiJRlk4rq08cI+1Bv5zPiOM3sRdcTeKMQP0/Loa4aRvD/44Cv
   vPPRisEoQVP6I7kCiqlUaOWbKiSyT614QORq/CC+rPtAhA57KUBI3RBw+
   QU8ZX/fwmUHaEak/iC7cmmDSV4/2rJETdZ2zQ1XsD+O2DoOCDoK3lD4nl
   Q==;
X-CSE-ConnectionGUID: Kfk/+ILtQIG6oF0cu1N92w==
X-CSE-MsgGUID: JLW5TnvIQAKLbRjG/UWkMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="47603956"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="47603956"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 08:45:58 -0700
X-CSE-ConnectionGUID: RTDQHhqiSbePJOW3npjrXA==
X-CSE-MsgGUID: cDZHtuLdRCGldzcIi3p8eQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="134097907"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 08:45:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 08:45:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 08:45:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 08:45:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g2DAe3ceRT1vSVGTJDXAXfcD9dpRxd1RfLpGv8YnJpP4TisLVIMnDcfUXItRInmKQsJuqF2Zobxw9xD6yGPYijehdHwRc46g1UoIfNbEpZaWheuBRQk1Y/3GkC+zwM13GDROg6LeJxv+Eypmy7Qr8TJGGJCE83gQbK+ompYYXju26vXlnJyECDcYM5S3/2/1viw0+DfbW/O/lo2XnM7gz2pcwkclUhboLDDLJaQWCfb51YV6NocKJ1oCVS8ZR4s+OL0W2m2aitU3tE57bw72WiCacmu8RX4Qje6Hurbqv7SGzIiP8+xJ+c+TYS9D39hOUQas978Ohh/SBpoUJWRDAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAuWeCIWAyQ2g8IF8rQhTiPv+WdnIpUJLRtH2lK8sVg=;
 b=hCnaYcaOd3WyNK6kckHhxJS6ubqjaN12zTGAqkg1QAEmL4AaGZFZpOpaq5No27/rGAQ4gtbtSrkLTNBbyXVsYu7yDY2G8auKxZ24aidd/ujdGWwL+B4tOFnvtT2F+1395GQ1ZRQI7Y8GKBWwvsdqcxvg1m/olbfokXIky9RqZ9Vic/TRb//DSLwSpd4pZHgC7N4LE7t2F2ONpTTE1ucrz2R3IJnB3cqdMwIslKwlKS2xHsRvccMxZNiqAjMDYnBLem0F6LaIRAT3vWPCkqkwkHScnJFwB8GLYhQdF69/94oyHzGRZ9gAh9buV23GlNT3/6bHygGnZ+FhMRQoA+5Lkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6784.namprd11.prod.outlook.com (2603:10b6:806:24c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 15:45:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8699.019; Wed, 30 Apr 2025
 15:45:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "Li, Xin3"
	<xin3.li@intel.com>, "ebiggers@google.com" <ebiggers@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"john.allen@amd.com" <john.allen@amd.com>, "Bae, Chang Seok"
	<chang.seok.bae@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "Spassov, Stanislav" <stanspas@amazon.de>
Subject: Re: [PATCH v5 4/7] x86/fpu: Initialize guest FPU permissions from
 guest defaults
Thread-Topic: [PATCH v5 4/7] x86/fpu: Initialize guest FPU permissions from
 guest defaults
Thread-Index: AQHbqeleekVNKTiu/UupRDUhMWTGFLO8egmA
Date: Wed, 30 Apr 2025 15:45:44 +0000
Message-ID: <886c7cf8338556efe4b261b2398185d11eb8d3f3.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
	 <20250410072605.2358393-5-chao.gao@intel.com>
In-Reply-To: <20250410072605.2358393-5-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6784:EE_
x-ms-office365-filtering-correlation-id: 736e68d0-4ec1-4727-f7c1-08dd87fe1192
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K29jNDdLSXozbGQzMklIYVU5bTgveXRoVTB3TlVPaGd0SEd3Uno1N09yN1FC?=
 =?utf-8?B?ZC9QNmJPY0JPOWxyc1lITXFPQUhXSklzcXV0RUk5Tk8vQm5WNDBEaHovdDZV?=
 =?utf-8?B?QVJLMUs3cFFvOERKdE03MHdDNnY1VGtQSjV1R3EyMGJ1b0crNW5GWnMvVTIv?=
 =?utf-8?B?MkpvZmp0V05sd21NQkJWaG0xVVZibmdTM2E1YitOT0JOWWVraHBxeVdOdUM5?=
 =?utf-8?B?VllmdjgwK3FGNzI0SzVwV1pxNHNNbmVlUUNQMzhvSnFITmh4ZE9zZ3FPN3NB?=
 =?utf-8?B?SlFNVlpUdksrcUV4S0dQcGJyQk8zdWdhZUk0K29HMzRJektvY1lyNWVWbUJ1?=
 =?utf-8?B?ZzNuQUVJWmFlRUxFVGJqV0RlUzF6Z0M4dGV1RWxpdUovNE50bjNwaDhnc0dS?=
 =?utf-8?B?c3hOM3pMTUxUQ0pkWEtiSURyNCtKL0RRdElSSFA1ek1wTUdHcUpXWlNoSlhP?=
 =?utf-8?B?eURDcXlaZk41VEtPU094YXVZM2Y3eUJLR2NHckZrN2xkZHZzUC9QdzZTK1Br?=
 =?utf-8?B?OUpOR1p4dnRSV0xzemZNcnlsK2FsMElCRUhOVXNhQ1UvL1pEZEhlSzEraVdZ?=
 =?utf-8?B?ZW1xdXJKbGtwUFBtUUFYK0ZRV21nbUJVbzF2SUxEdFR2eE44YUE3VmludXlr?=
 =?utf-8?B?d05wRU0xaVdCWEJDT1FmVlo1eEpCaTQ5cW5QbFc4OTVsZlZmcHNjcGlrclV6?=
 =?utf-8?B?cndEVDBVRm5ud3U0aGcxeFdYSGRkcjZRdVJKWGZZdGxsOU1wcFpJZE42U0Fm?=
 =?utf-8?B?ZWFIWjNCZGw1OS9XVUlodndrOEVFVXNjdDBqWnJRZmE0NFVDR2htNFlnaFlL?=
 =?utf-8?B?bm8raEErMDVvRXlvSno2NXEwNkk1ZnNjZlh4SjZPdWcwMEFlVWxvNUFIY0xo?=
 =?utf-8?B?eU9rNlBPRFlWclRoVWxSclM0NU9NM0ZPUTVpWitZbThwUE9mMFRPcmNGSTRD?=
 =?utf-8?B?Z0lQTHJtdlE4M2xSdUN4YUJjVHNvcHB3bmQ3U242L0szZkhlVjMyU3EzNTY4?=
 =?utf-8?B?TlVKSy80VTZHcUkyMTNrQ0ZnSmZCaEJMWGQwWk5rWUdnL2EyUlZPZVZwUHl1?=
 =?utf-8?B?Y2NpT0pDTUxrdmdQV1FXSmRWbWhmNjJjYXE2K2xDVStTWFpVcFd2MmxQSFps?=
 =?utf-8?B?YllqTmtYOHNKMXo4Mm9CUUp5ZnVuU1hjbi91SkFuZHFzUHEwdWtUNThNckNT?=
 =?utf-8?B?SnpoUld6VG9OamRHNDlXRlJhQ2hiSlF0Z3VIczI2NitETy9VWElaWUgyTzRm?=
 =?utf-8?B?NDBIbEI3S29LeUZNbFN4amxXNk5GNlZlRjNRR3pRb29kREt1djUwVWpOK0dZ?=
 =?utf-8?B?U0NsQ0VEUWJtaXNlYjVzZmlnRVVsTUlVOXMwVVF3NjJYd2tseENTN09jZ1k0?=
 =?utf-8?B?NldEY3RITnRDY3hBS29EQmdWRXdyWFdZZENMVmJsd2Z3eldYZTVUdStoR1oy?=
 =?utf-8?B?a2xGS2ZKbU8zaFhFT09DbnlwL1ZxMzNPajYvYnRlR0RkSXhBQkdhcTIvRS9G?=
 =?utf-8?B?ekJoRkZVWmEzWER2ZjU2dk8xd2l0UXkxZFhnb1pWR25qbWM3djR6bk5Ia1lY?=
 =?utf-8?B?NnVQMHJXWWNFbHlEQzFxN1JiRHR2UFlWS1NTZmhnS1dSQWdaN2hRVnFDN1dG?=
 =?utf-8?B?VnN6OEJtNXpoVStMY3RaUzU2elY5Y0tkYy84ZTZjSlQzM2lHNXFETDFjYlBC?=
 =?utf-8?B?UlpVSWEzQXQ0N1NRREZ2Sk1xN2tlWjVpQ05lZ3RVOWh1N01ld0NhaGJtUytt?=
 =?utf-8?B?V1BUY0hEL2twcVlmVHl4d2MwNm9BU3UvWU04ZFJWTjkwRURVVnd2a25la044?=
 =?utf-8?B?RWRucytOeSs4dHZ0c1dBb1FzODdMcVQ0TTA2bmhpMmhYWmdMV3ZLU0hFT3h0?=
 =?utf-8?B?ZlAvaGNXNWd1NysydmNsamx0eXZOS2xlZmwzaHJsMitKNHY0SmtyZXNTK2tZ?=
 =?utf-8?B?MVZQcTRnVHd6YWVtSFRtQm1KazhCRW1uYXdYaEs4S3lDZ1kxY1RGTXFXeG5Q?=
 =?utf-8?Q?jjFiKX15bdpJaLzaSVrVKu8Acl6SpE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K09haTg0aWtxdkJRby91RWRGUHorQityM3RWSnpIcW9DTXVKbUcxWFczc2lu?=
 =?utf-8?B?Y0RQZXBoeXpuL1JZV2szUU10T0dPM3BpZ2hnWVBPRzlFditLbjZtd0hDdlNY?=
 =?utf-8?B?SHdqNmlzOWpFZlI4TkhqRCtJN3NYa3dOWnZaSk0vS0tmSkRjMnU0aW5SR2gx?=
 =?utf-8?B?SmF3U2pNclR2cXZIbVdZejRzaGVOM2FaeCs2R3hlWUZJaFpFcDV0bk5LMG8v?=
 =?utf-8?B?dG8wTTNoT2FkMjFiR1FtRDdnaXhxNEZnZmVwVlk4enkrZ25RQ0FobTBiTlI3?=
 =?utf-8?B?VDRXUWVPNHZ4L0x0SXAxN1RtT05pSWV6RFovR1hCZWNSKzhxeHljUjQ5WVh0?=
 =?utf-8?B?c1JVUUg5OXhMSGUzbkgrcU55Qy8xcXEybXkwaHk4STlRazNoeXdNRys4cUF4?=
 =?utf-8?B?YjJGNlU4cTdFSmxxbnJhd3RSajhGZitpbXpiZE0zZ2hhbVRZM240M3IvRkM1?=
 =?utf-8?B?RXl1dUZGbjVkM1phQm91ZUE4N2hWMmhqNXpRb2E5aVVxb1pnYjF5dWVDZkcx?=
 =?utf-8?B?UEFQd1pHN3VZaUk3NlRIVStlaEJuOVhwS3Z6V25lb3JjSllYV3YrRm91MVdH?=
 =?utf-8?B?NG9LS1FzOXJtdGtFZ0VrV2hkdlhscXhxdkdUSGJ1cWdhSHZpNE9sWTRGVVBl?=
 =?utf-8?B?S2IrdlVQTDZvdlRLM2dBUndrcFNtajFEcG9xNmFjUVhkeDhJckFNaVJ1VEZ4?=
 =?utf-8?B?RjdJNzJwM0g5cWpzb0pHMGlTazN0Qk5QVHlCODdxVFRwR05LK0FWbklGWElS?=
 =?utf-8?B?eFZybk0zc1hYQUdnbHpGVFMvbXIya2MyMzllQ3hSaUNmbzJSNTdydERaZ1Zj?=
 =?utf-8?B?TmsyZXpvSTE5UjNJcnBuSDJmMG9ETmtrNDFqNUVCcGFKSUppeFlURVpJU0I2?=
 =?utf-8?B?NG0rQkM1WS9tak1yQXVFc1hHRzZ3NVJqcml0VFo4WmJPTldVRnJYQnlic2xT?=
 =?utf-8?B?RHF5REpKSnFab1NDMUxTajFVTzRQOFdpbVc5WlcvMzRFRzZCSkZOdWJxREE2?=
 =?utf-8?B?YnFxL0JxbktBTlpUaEhKQlJpcjRpb0tnSUl2OG1IUXBmYURLMFh6bnc2SlVx?=
 =?utf-8?B?MjQrVTBlTEVQYzMramU5a0ZSY3d2b2FpclJEcXdwNndQc1hTc05NNTFHaGdo?=
 =?utf-8?B?dy9RWXlmNWJlc2FZbko2VjZkR09zeHFBTmhvVzEzOTdMMC8zWHVORlFLcy9l?=
 =?utf-8?B?Y2Q5ZU4wcDRRZDhJM2JHeCtBT1pRMmZDWjZISHJhSDEwVGlLUzlGcnZUc3Ro?=
 =?utf-8?B?MGN0MTNSMGk5YXY5Z1F6eXZhemxPUFUwcG01UEtqaTY1bEFQR3I5Q0xRdGw1?=
 =?utf-8?B?L0plaCt5ZnNWUHZiejZFeXlPb21wLy85ZVdjN3FFMUZ4eUwzSDJ4cFl3am9L?=
 =?utf-8?B?eGNhNGltamlQS3BYdjBWWS85eFdCZ1lRZml3TVJMaWpBa0xVUmpCbmh0Tmcr?=
 =?utf-8?B?Y0FpSEp2ZEpkTDl3d2ZBbVBqOWtqbDVLUmlRenNLNGhpNm9DYXNuTzBKOGJZ?=
 =?utf-8?B?TUR3cFBhaGVpa0ZMd1EvOXl5Y2JhN0JySHErL09FMnVPSkRUNUJnc3ROQ05E?=
 =?utf-8?B?YW1jQXFVWTErZDcwZlFDTmtxVnNyblRHUGZRdlRSc21ybUhqQkpoWmJYU21M?=
 =?utf-8?B?QlJoQUwyNFZxSFBIMkRmcEcrVGZlaHNBTlh5cGNSaG9HSFFlN05jNjJwbzky?=
 =?utf-8?B?RDJMeXRIRjQxODFPQmE1cjVOZXE0eHZCUnluWnBFeVNNeTZIVjErdnlSVE15?=
 =?utf-8?B?WXpUU2lMNXVubExoTU1uS3VzVEtmT3VpQTBENE45N2EzdGVyenNiQ0hmN2Yv?=
 =?utf-8?B?dVQ5VERCTGdibDgzYWR1cUNKek9IeHoyYUo5NzFydk4yK0xHUkFWZXhVNTdV?=
 =?utf-8?B?TWx5ZldQUHJxTzdtM01BL2RzbjZoWGIxL1Q4S0hjeVNMYlkvMm00cTkrSzVW?=
 =?utf-8?B?aWhDN0ExWGRRNC9KVzlYVUJsM3YwbVdWQjdWTW5Kczk3aXV1NDBXNjFTcWxE?=
 =?utf-8?B?YUFwOEJpbjNOeFhnMEFqZW0zNFY3V0FLK2NvbWp6cEFNN2xTTWx2Y00vcVo3?=
 =?utf-8?B?SXRTQ3M1NThLdzNVa0k4Q1gxTW41ZzRZbFVHZmZLcm4xN1lUWml4aUcwdXNp?=
 =?utf-8?B?N1JscUZvbFZrZjA0UlBvVU9MTERtZWZiR1g5R21GdVpiSjZQN3hxQzlkRHA3?=
 =?utf-8?Q?JhXfVymGwU/hDsYqTzIOECE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <858C41C35B39E54DA9E3597E4249C54C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 736e68d0-4ec1-4727-f7c1-08dd87fe1192
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 15:45:44.2667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BtufOOmGxMWgyIYs7gA0bGL1PFJtSGq2k9wMXn6VMxwGc2yUWll5ltTWeJju7KCrilD2DWlabKQ3sbogXsXllZBe6mAKG1PIST9erTmXvWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6784
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTEwIGF0IDE1OjI0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCg0KPiAr
CWZwdS0+Z3Vlc3RfcGVybS5fX3VzZXJfc3RhdGVfc2l6ZSA9IGd1ZXN0X2RlZmF1bHRfY2ZnLnVz
ZXJfc2l6ZTsNCg0KVGhpcyBwYXJ0IGRlcGVuZHMgb24gd2hldGhlciB3ZSBoYXZlIHRoZSBzZXBh
cmF0ZSBndWVzdCBmaWVsZCBvciBub3QuIE90aGVyd2lzZQ0KcGF0Y2ggbG9va3MgZ29vZC4NCg0K
UmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4N
Cg0K

