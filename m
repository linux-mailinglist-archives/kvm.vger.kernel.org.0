Return-Path: <kvm+bounces-53678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5890B15548
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C76018A4D9B
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C691A28505C;
	Tue, 29 Jul 2025 22:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dGlQXG0o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A690284684;
	Tue, 29 Jul 2025 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753828074; cv=fail; b=QBGHHQqB5m0uSFnbe+tzxlEkkN4H4F8pFdFuCpw1zflPzcgycG8ZYjrjQ6dGNCQhs8vO6sd/XoWVFZGdDWbTKrRP3UgnHNF5aD5ccKyZDCT9wu/J1aJjUJp6o8PWLMJQZbNyoVywWpSMNPwwQI8lz/k8MiwlcpNwqsNe2bHZSp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753828074; c=relaxed/simple;
	bh=sdD3+Q8S5IkCF4m8e3gy30qcQAF+RFp5slh3qfQ0CoQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z1nELJqZFt0udhoCmb48if7/j/SYP/6ZqjF6OJWWwWqHuqURE30zf8kf+Y4qhY3daYJSKDAe9C27kgZM7hzxGBcUTdlSSaIlj/PTL+jb0jLflfFPZJr5sEHHiP0CBRQYHAhTQPU4fTCJkWrjQQOtIlUUfNDPjmkD4clX0ssDryo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dGlQXG0o; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753828073; x=1785364073;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sdD3+Q8S5IkCF4m8e3gy30qcQAF+RFp5slh3qfQ0CoQ=;
  b=dGlQXG0oxtTIwEviLJiUHIpi9TqHm1UdNuhgSvzN5JjE0+QqGI6rMn+S
   /YSoCt3btxMQe4Ct++DL/yhm77b/kacy5xqYEZu3hwDcUDgLlg1XqG4id
   Fg91WXVFOpGiMSGU0KXdzbdKp/lsFOxu5su6Gli2WplylFfJyLyVHwwrT
   veJV3gEconDBD8WM6b2FgjINUPcYi7E6jcbEeWO6SSm2wHCBsMpjMEPZG
   lsG8CM53AoBMgUa9fhz8h8ePxCuy0pXKfvi4qhFR4XvWNInkXRUG4/OZ4
   aM1OKf+hYKc67uFRh8PC2EF3xoeuRMevD1iiUd25jDkm4pr2nqckZ/AZF
   w==;
X-CSE-ConnectionGUID: q6so3si9QiaI94CKWGZ4sg==
X-CSE-MsgGUID: OO/lvMJpQS6dgMSB1B2Gew==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56054213"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56054213"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 15:27:53 -0700
X-CSE-ConnectionGUID: EGimb9puSr2oHsEdboFyqw==
X-CSE-MsgGUID: pWfX8Uz8SUmHzvZVmEcHMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="163598519"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 15:27:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 15:27:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 15:27:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.50)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 15:27:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LhjZPzxIPF1CdVhEWnoGsz9YhIN1mipMjAhddGJu042lU8yTUvfsEvCOLwTD5z36DttJMnPhOH+/guDeAaMv1iK1TMIWrM77c/PUXfUHjyMOilWe0AkjE5mJP9klQBYffdh9a/g7NaBY0w7ARGQQtvGjzJv/qCjmRHQNyMeudS/R/BXKuAQLNnrw7VMQy94celDi1QRxpsvOOBQNq2Jbq1a3HBqNK75g7cLhXKw9FT5BPFCJdMzejQ2x2tTBaOa8C9v7dP7CF8E7z0wQI4vXyg2X8v4ffDsdosykkUk0SOSc3gElc8HIs/gZgJ1XvlDJQQZnfRgMQ5y0U76AhcAKmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdD3+Q8S5IkCF4m8e3gy30qcQAF+RFp5slh3qfQ0CoQ=;
 b=pLpszaKlNa3RiaekGSdMbusTz3mG6pXLkPJmzcgo0gTQt8SeuxNqqacyMaFw0kfpL//AeE8ILb32d+ZPYDhD/7Y/awS+pK8dHvZwlHHIcxPFGR6f9NQikv4iMGQk7RJA6YpNt4s1EoaDvZQGh1Ql2XM2AD4bZULGmYG1K8tehVtbehh5PX9bgf+zsAj+vWg6QBztN3Q9VJf5w1mhjFVzBdgPxuMN0j9aIxIQ/IeL3o0OSN22xMaVkDMyU4rxcoPgJn8dS6jGS1QVqSS3w5nUe59ujpo0gY42dagoL6jsGt/UBB0nchoDJ/eoTyadga+l4Y8uowzZmSVLDPnX9VssmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4605.namprd11.prod.outlook.com (2603:10b6:806:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 22:27:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8964.025; Tue, 29 Jul 2025
 22:27:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "Annapurve, Vishal" <vannapurve@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Thread-Topic: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Thread-Index: AQHcAL+7V9fiN+6xT0aRmIRaSyEMmrRJrnYA
Date: Tue, 29 Jul 2025 22:27:34 +0000
Message-ID: <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
	 <20250729193341.621487-3-seanjc@google.com>
In-Reply-To: <20250729193341.621487-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4605:EE_
x-ms-office365-filtering-correlation-id: c31bec05-0484-4217-272e-08ddceef1dd4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MCt6MVZldEZ2OGg3b3AvdkZmVW9NM0hNUk90ZW9pUGlNSzZiS1dVckdwR2tz?=
 =?utf-8?B?YjlweGxJOFJXcVBIUDY3aU1XaWNlRHRxSGRPckV1M2ZqWlA3dW4rVGd4LzNC?=
 =?utf-8?B?UUEvZ3dHRmNLRVBBc2NaemxVRHhoU0h5a25CRWZpaHh1TXJ5SmlhRzJLWXda?=
 =?utf-8?B?SHpOQThyTUpack4wN3pTN3RyQ3R3d1M1Rm1heUUydXlPYWRDekw5aEhqZDVp?=
 =?utf-8?B?VWxZTklGNWZhVW84WGFCSjNJOXp2bFBvYlhUUzVEemVlREVkdkJ2WEhEMXB6?=
 =?utf-8?B?OG9KMGJRZ1M5WmxNR1Y2bmlLQjRXNWRRaWpmVzJhYTFkdHdKN1hKQzlSL01D?=
 =?utf-8?B?UTd3bWNaVmg5YjZkcFNKR0hvTlhkcUwwZXVFcnE1bVRuQitiRTM4SGlXWUZh?=
 =?utf-8?B?dlhvQjRSV0psUG9iYnJRSjdLU1lPUUIzVEU1blJrMUNRcU9pNXM1OHQrYnQr?=
 =?utf-8?B?Z3ZHU1EzUFlSeXFKSW96Z3oyS0c1ZDZibjVrY3dubHdoTFlLSHJHS0tVN2FR?=
 =?utf-8?B?TS9YWnRWTG1PY3B0Q0NEbHNsNDl5bzY1ZDMrOWVKQm5kQjhBbmp3cFhTMXQr?=
 =?utf-8?B?TkJONmtwRDZuRjhHc0l5YlluUmdxaWozZkI1KzdpbjVTWlJpUWpWTURIMWM3?=
 =?utf-8?B?czkyMG9UYjFmMGtRRXdzOVhuOVBsNityVnJ3eFgrZmpqUUNTUVRQblRmMkhH?=
 =?utf-8?B?SkRXYk9xWms2YWhyWm90bmJVc3EzRURqRWNMWmFKMnJpSEl0aDNQOURqcEU1?=
 =?utf-8?B?M3dVQzFVYThFMUlVZTBLV1VkU0Zsa1J1YWZaOXRwNnhGNlFYd3VzR2lRemNn?=
 =?utf-8?B?YnJwenZNbXdHR0xTUjU2RHJrTlZrY3VIRnYwRmI0Y0JsN1lqM2pVVGNkUHl2?=
 =?utf-8?B?MURsemlkMHIyRmpRTENBWXlXTVhMVGpqUlRBNEFZcjZaS2Rlc2Z1ZHhkeEdP?=
 =?utf-8?B?RG4vVTcxc2hFQlFQa1FHUnVmRTZmdG9JVmY4YnF6d2VsTC9wK3FNYlZ6YlV4?=
 =?utf-8?B?UEVaVzBMT3JlS3IxcW00bFJncWtNc1YyMWlCdTBhTHJnaElEYkU4N2lTa2NI?=
 =?utf-8?B?ZnMvbUcyL2VNYmVoMFdRMFFER3FnWlFCN3N5Y0lzaEtTWWZxZUlJTDZEMkFh?=
 =?utf-8?B?aDNETXc3SmU0VkNVSE1LazdpTTRZN25aNHNUYmVPVVBZa2xjL1dGMTE0RlRt?=
 =?utf-8?B?dWJ6M0VTMmZGaWdKc211OFB1SDRLUk5TblI0WjB3VWIwcW5STitadGlzd2tL?=
 =?utf-8?B?dkQ5b1ZENmRzSlNSMUtHT3NtUno3OGlwVW5PUEQwNzFyTzhINTRXcndrRmdo?=
 =?utf-8?B?c2RlZWtnYllzUWVINWpuN1daQnpKbGk5Sll6RWdLVWNPSkVBNkc0VkZHcFNB?=
 =?utf-8?B?Z2FCTndSQ1JjUFI4N1FYR3Q2cVFQcW5OdTJUeFM0V2hoZlFTWVg1ZDRFbEJh?=
 =?utf-8?B?QU1NbXQ5V1E3VWZZTjI3TlR6RjA2dFU5ZnN1TWxudS8vZU9UenpjRDFuL3Fk?=
 =?utf-8?B?ZlFIRnRnWlBmUDZvNkwrZmxzZVlwd2RIMVYwMU1jRWxhWDlLd2hyRTMzTlJY?=
 =?utf-8?B?aW9IRk43SEF5VDA4ZmF6RkpRQVJ4VElEOUkwTmtQUWtuZThwZmdtcTV5NFY5?=
 =?utf-8?B?M2dqVjV5RytzYm0yT0JKN2dGbUh5a3J3cUJDeUMzVkdhb3plRWhnUnlFbEFn?=
 =?utf-8?B?S01YV1lhVitxbFM0eVd1MkxQQmxWR0w4RTRwL1lZV2twd1RpVEdqc1Y1Mi93?=
 =?utf-8?B?RzNIM0xzZ3RnUHc3VTVkQ0tHeEVwWjJiemorUW1mc2Jnbm1tL0YrbTV3THg1?=
 =?utf-8?B?cS9Wak1kVmNxekwyK1psSXZXNHpGR2p6Z1BiMmNQZDBOZDR6OXRqRWFiRXQr?=
 =?utf-8?B?c1JxdmgvUnhhNzIrOVVPVnVNVjNFb3JGblEzYXRaTU5uRzBJSnVPZ3dnRC9q?=
 =?utf-8?B?dGdpOTVrNU5EZldWdWFIOEtLZ0VWTzVyM0loWTd4bUxzQWZBY21MTGcwdU1l?=
 =?utf-8?Q?i+ovlD7mk/aCaNSottTFb/6VuAOT4U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0tGU3B0cXpBbzVGUXArQXhEN2hOMkt5Wjk0WTFzVU5uUDd6VVZRT04wTCt3?=
 =?utf-8?B?dTVCeHVBVEZzdEdZdHlGVEF0K3lBUEdXYnFwZlVNUUVTcG40QnY3MUdVd3l6?=
 =?utf-8?B?LzMxZ3pUUjkxTkdhNzQyeFBNTEhUYjNleXRIZndHVVgwZEppbTQxbXpqUjhJ?=
 =?utf-8?B?ZlJxVGRQK3RicVBDSE1sQzY4SEZad1pzQVNMT2M4djNOWnBrc3RLd1ZCQU5p?=
 =?utf-8?B?RW5zdEoyVEovdnRxelcrdWJJd3ArUUdBNkQyRHhFdzhNMHpGTXBWUWN3UVNr?=
 =?utf-8?B?cDZUNmxxdW9oc1lQek1DUm4rQnhTS0RPUFd6akRYaEJOY09yc1pscHV5SXZw?=
 =?utf-8?B?OHQ1eFkzcTIyVVlXL29tdGFpbWRySkhYN0FGbE5VSmdVZ2czaU8xWGd6Ni9y?=
 =?utf-8?B?YUQzMkdVSFRNTEdOK3haUlAwVDcrMVVPcExyMitDa3IwUlZ3U0xxaG01azVI?=
 =?utf-8?B?MmdNcWU2TUNibmV4WjFXSmNla3Q1bzV4RktBbnpHa0UvbHoyL3B1VFlNdnNN?=
 =?utf-8?B?QjNSempaU0pNKzRmK1FJaU5yL3NralNZSmZSQnMramtybHY1bmk5V2tGUTQ2?=
 =?utf-8?B?MW5EMUxvNDhzNDR5MzFXZmM2djB2bnM1VktGdTFXYWZuT1lIV3NKVm9Kb1lw?=
 =?utf-8?B?TkVDMXZWQlU0bzUvZXVzKytrZWlTL0JKODRXWDZobjVHMjVGa1lvbEIxZDE0?=
 =?utf-8?B?NCtmZFJKSFFjV2VpamxhNG9tMHJDMFdSQ2Nvemh6cTRxWU8rakd1Q0UzeWlx?=
 =?utf-8?B?am9KL2pFdmJnaGJqZ1ArdnJMcTVJTEFqRWxaOHlBSUFwNHM0SW0yZjFXQ1VN?=
 =?utf-8?B?S2xjRENqNG9LMVRzTitMRTVBU2lYdkR1eE1IRHVFSnQza0loYTJXVE10V3Iv?=
 =?utf-8?B?WHlaV1hnZXdUT1pUUmdvRk9oaTltVkFWd3BPZC9hUmE3cGJpOG0vdTUyT2tC?=
 =?utf-8?B?UjBlVHBuTjFRQVpiRTBleStiaVF3OU1qQ3JFMlphMXNJcGNNYnFxNlZQNnYy?=
 =?utf-8?B?TDN0MzhpVGp1aDdJQ09uQ2ZiZ2Y0a2NVcHFmMWRXamJ3R1IyQlBUcmxDZGVv?=
 =?utf-8?B?bGFzcjZGZit4M3VmUllaV0FLc1BpTGpmc3lkb3pFYjRnd2FsbU8wMVZUSWZ4?=
 =?utf-8?B?eDBVblptR3RHRzEvS3VvTFBPeHdjd01OTVpSdXhrM1lqeDVicDdOYUFnejdt?=
 =?utf-8?B?NmRmd2IyMk00VkJXKzdJRWl4bmRTR3VrSGNKWWNGLzBDcXlCaXlEcVJPOUxT?=
 =?utf-8?B?dnZtYjR1Wmg1Yi9ScjFxUkNiTUVmS08xTHF2Uk4wUlF6a1M0emxzemlsUmRY?=
 =?utf-8?B?Rmx4QjZDM2R2ZmJIQW56WXNONlIxTm9wSk1kZDFpekRXWWtjNWJYN2QvSDh6?=
 =?utf-8?B?elJ6TWRxSFpxQzdqdkY1SjZ4aU50MndPUW1MVGxuVTd1TW5aMnBUOVdranlz?=
 =?utf-8?B?bE1zOGdodzhDcEtuNVd6RDVIZGNIZzg0UUI4bk1ma1ZtTDliQ3RBZlBHQ25j?=
 =?utf-8?B?QmZZd2xDZElOTllwcWo0Tkp3dk9BcUsxUktwcS9PeklqalhuQVVBMW9nYUhF?=
 =?utf-8?B?Qk83SFk3cEUyU0g0L1Irc05HL2RJV090OWNQQVRoUDM0L3VhQ2hNY0dKd2t4?=
 =?utf-8?B?SmhQSlFXdDJ1amVyUTcrSHlwWXVNdW5mSStSTFJ1MXc1TldZZHEvYnI3KzZl?=
 =?utf-8?B?TkFBSzNIVW1obmlHSXRSRDNza3dyemIyS0ovMFRBVWFESlZYK1Z5M3VZbXpX?=
 =?utf-8?B?UEdGdVhTZ0dNUXhoZVdzTGZ6WWtnRDdMeXVUWUJvdmNWL0RoZktaVGMyWjhV?=
 =?utf-8?B?UDRZbXl2YW43WExmcys4MEQrR2lzRjdYK0tSRFd6SU9vajZ2eTkrcTlzYVY0?=
 =?utf-8?B?YjlmU0hycTEwM0RqK0NGZm9HaEswYlBwTHpwWHRCYTNOMkhTM2dwRjhJUjZw?=
 =?utf-8?B?bW5TSjRXWHhNNitsQkJ4bHJhV0EvOUg2dkMzNjd1S1JJSzQySEJ3NHR4VkVw?=
 =?utf-8?B?NGVjQVlNMnc2WmdFM0s2cVhYUm1iaWREb3NwR1ZBcktEeDYwMkZ4cHFROG9G?=
 =?utf-8?B?T21HbVkxQ2l0b3l0L1hsenhIcEhaUU81V1RBNWo2cUNpMjQyTE1Odlc1WCtN?=
 =?utf-8?B?YVFtOVMvRzJheWM4RXF0Q2g0OHdEVHcwOEo5dG9ZRzNuSWtrRnRheEw5amdy?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <339A614E24C8EF41BA9CBFA5AEB70C68@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31bec05-0484-4217-272e-08ddceef1dd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2025 22:27:34.8852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c5uo52Z5BggsTbEVKCayqC+tYV2lfEbvWiw6EbkFSlZU3GLuwGLOB2lcZ7Fn1+LusKT5u5YsyN/NrT/QiRfIiuOWKGNOHQtqPzEfsQJEUhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4605
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTI5IGF0IDEyOjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2
bS92bXgvdGR4LmMNCj4gaW5kZXggM2UwZDRlZGVlODQ5Li5jMmVmMDNmMzljMzIgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90
ZHguYw0KPiBAQCAtMTkzNywxMCArMTkzNyw4IEBAIHN0YXRpYyBpbnQgdGR4X2hhbmRsZV9lcHRf
dmlvbGF0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gwqANCj4gwqAJaWYgKHZ0X2lzX3Rk
eF9wcml2YXRlX2dwYSh2Y3B1LT5rdm0sIGdwYSkpIHsNCj4gwqAJCWlmICh0ZHhfaXNfc2VwdF92
aW9sYXRpb25fdW5leHBlY3RlZF9wZW5kaW5nKHZjcHUpKSB7DQo+IC0JCQlwcl93YXJuKCJHdWVz
dCBhY2Nlc3MgYmVmb3JlIGFjY2VwdGluZyAweCVsbHggb24gdkNQVSAlZFxuIiwNCj4gLQkJCQln
cGEsIHZjcHUtPnZjcHVfaWQpOw0KPiAtCQkJa3ZtX3ZtX2RlYWQodmNwdS0+a3ZtKTsNCj4gLQkJ
CXJldHVybiAtRUlPOw0KPiArCQkJa3ZtX3ByZXBhcmVfbWVtb3J5X2ZhdWx0X2V4aXQodmNwdSwg
Z3BhLCAwLCB0cnVlLCBmYWxzZSwgdHJ1ZSk7DQo+ICsJCQlyZXR1cm4gLUVGQVVMVDsNCj4gwqAJ
CX0NCj4gwqAJCS8qDQo+IMKgCQkgKiBBbHdheXMgdHJlYXQgU0VQVCB2aW9sYXRpb25zIGFzIHdy
aXRlIGZhdWx0cy7CoCBJZ25vcmUgdGhlDQoNClRoZSB2bV9kZWFkIHdhcyBhZGRlZCBiZWNhdXNl
IG1pcnJvciBFUFQgd2lsbCBLVk1fQlVHX09OKCkgaWYgdGhlcmUgaXMgYW4NCmF0dGVtcHQgdG8g
c2V0IHRoZSBtaXJyb3IgRVBUIGVudHJ5IHdoZW4gaXQgaXMgYWxyZWFkeSBwcmVzZW50LiBBbmQg
dGhlDQp1bmFjY2VwdGVkIG1lbW9yeSBhY2Nlc3Mgd2lsbCB0cmlnZ2VyIGFuIEVQVCB2aW9sYXRp
b24gZm9yIGEgbWlycm9yIFBURSB0aGF0IGlzDQphbHJlYWR5IHNldC4gSSB0aGluayB0aGlzIGlz
IGEgYmV0dGVyIHNvbHV0aW9uIGlycmVzcGVjdGl2ZSBvZiB0aGUgdm1fZGVhZA0KY2hhbmdlcy4N
Cg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNv
bT4NCg0KQnV0IGhtbSwgdGFuZ2VudGlhbGx5IHJlbGF0ZWQsIGJ1dCBZYW4gZG8gd2UgaGF2ZSBh
IHNpbWlsYXIgcHJvYmxlbSB3aXRoDQpLVk1fUFJFX0ZBVUxUX01FTU9SWSBhZnRlciB3ZSBzdGFy
dGVkIHNldHRpbmcgcHJlX2ZhdWx0X2FsbG93ZWQgZHVyaW5nIFREDQpmaW5hbGl6YXRpb24/DQo=

