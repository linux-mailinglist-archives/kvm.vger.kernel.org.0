Return-Path: <kvm+bounces-44238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6125A9BB42
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAC221BA2F93
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8857628F516;
	Thu, 24 Apr 2025 23:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ix+2Eqg0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6CA28FFD4;
	Thu, 24 Apr 2025 23:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537331; cv=fail; b=FW7Mq6UY8OY95+pfSh/O/8rDnpbI8ZC73YEsTTKHxtIncZZjQUGngISM+mtw6aLrK7AisnVqwIxSZubUxJfKeb9hrRIkL99i/+OJAprS1hUt5D4bvJuv/Giqp0M98K/SScnCcEzzEJkgMVE0hExoDwk+yVO1XvQ52aSdxwFJUR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537331; c=relaxed/simple;
	bh=3uvjWnikZ0cSVzpW69HD8efKEq3ivDlnel9ktgtfMIA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eUIgds403OaTNuOwsk2PvXR4nthgjnjNWDqK/cgWOhGApeus+rzHBQULdrR2vijsNW/2YvMNHlne7cYItvuzIhvG5y//twcZpboerWjP4qtsG090vswJvPNvKMhev8MlY+158JZEcRQqBhMe3z70jrkQ2cc0dPIM/5W0x4F5roc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ix+2Eqg0; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745537326; x=1777073326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3uvjWnikZ0cSVzpW69HD8efKEq3ivDlnel9ktgtfMIA=;
  b=Ix+2Eqg0CfptKX2/gw919hxz6nbKn+E7w5TBoJO51M9JaCkc4C243LTa
   hvn5IrpX1UM45SLQhGCJTa6Q7fVdlUciE47LKpWEjBBgLKLOWKWmgOV+i
   0aBiJO+VBSPpjyT3mEaCO7wv7Mb71NKgWCZY8Llt2PwhWGMoJae1+Wjjf
   gRtt3M6+5ev9346KKDYwNBOyCFNP1tpPXkMSvsOjMVfQ2RrAbvjZ+HlTM
   jLheEVN/oY89YjYYoY0FpziD8YsSVZV9X6iWr0j3VO8FzlFUegs6eTgNj
   AWOuZKwSjXgkZNm5khOGj8aVvwtTNXymIBGDuCF3lYQ4R1d6CCjHDiA33
   g==;
X-CSE-ConnectionGUID: 2Bx3QeVORAGiT5jcoI2Zpg==
X-CSE-MsgGUID: sVDxyQ6YTYi1kQTGDL3zVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="47327458"
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="47327458"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 16:28:45 -0700
X-CSE-ConnectionGUID: bvSmEqT6TzepYh+rAgiuSw==
X-CSE-MsgGUID: kKiLfjmVS5OiMJbsSAHvQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,237,1739865600"; 
   d="scan'208";a="163710361"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 16:28:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 16:28:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 16:28:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 16:28:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BOfPI9I0vtN26affHrxCPmrVTUkTDof94bIv+5vTjBxygUYUKdOppEW+IMZ1iV97Tz5SF2iLZ1WAvIOUz5KKPk8YgEuTFp8/bRrxZBJCuwJzCEn4c/lb0OdW9PTd0PxeIdNGyoLy8+Ygausi4usZGtp6EQS47ARfFOYKffbAlZJ28FlTzt2zyB8IJCLaHXMQS4fvdagXxXDLGd1FRQrsfx2YTTnheUvXwfiJ4LjtYtQKdiUA0xf5a7rnawUWdesSXudLsfRI0KeZUpYTm4tqCrXcaOnsn5YPyU6VMCkg8WrHPjRgpGIuCNTZ/Sti/ZASc7qnYVAPkKJWmP/qg+sGJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3uvjWnikZ0cSVzpW69HD8efKEq3ivDlnel9ktgtfMIA=;
 b=MsBvki6gg5nGGytBvivyqLuW2IpeOblWdEgWWdCeU7srMtMkruRVHaZQ7JFGEGP4JiNrbXcjJXdrweLjI3oIY2sLpdOYC6so8vFYqQZz/ehdGdR4k6kxPFtzr9yK12Zc2iFsXxLO+mpmDT7QTYSCwEJxbnOcp2otW4EzB9LWc6cz4qr/B12hK29ZYcsI7U0SYDEgqZKYTXiTqTLn8QhXcOFTQoKgLOGeKhQqYVnQ+MoVFWHnJS9+JDit0JQVNWzqQ2dQhH//Fph++CYCOTEEuKM2hVS4D7gTu4r+YTfw7oGCjxXKIgURhZzFcVOd0i21xx2hOel3XmMws3M3fOlG2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7192.namprd11.prod.outlook.com (2603:10b6:8:13a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Thu, 24 Apr
 2025 23:28:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8678.025; Thu, 24 Apr 2025
 23:28:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "Bae, Chang Seok"
	<chang.seok.bae@intel.com>, "Spassov, Stanislav" <stanspas@amazon.de>,
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, "Li, Xin3"
	<xin3.li@intel.com>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "john.allen@amd.com" <john.allen@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"vigbalas@amd.com" <vigbalas@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "bp@alien8.de" <bp@alien8.de>, "Liu, Zhao1"
	<zhao1.liu@intel.com>, "ubizjak@gmail.com" <ubizjak@gmail.com>
Subject: Re: [PATCH v5 0/7] Introduce CET supervisor state support
Thread-Topic: [PATCH v5 0/7] Introduce CET supervisor state support
Thread-Index: AQHbqelOjyGjL8Ku1Uax9ey0eGq7pLOzjVwA
Date: Thu, 24 Apr 2025 23:28:33 +0000
Message-ID: <0f43a0e3e6b839779a36c0474a7ccd85ac753ba3.camel@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
In-Reply-To: <20250410072605.2358393-1-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7192:EE_
x-ms-office365-filtering-correlation-id: 0a5e168c-8d4f-43fb-63ee-08dd8387baee
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZXJTdFBSQXVFRjFvYk43T21hWkt6bjZZenBZTUFHN2RsUjBxaVBpYlhoNUNP?=
 =?utf-8?B?dHhObVZJN2p1N2VBN1Jnbmd0L0V1OTExMXB6MFRRaUhwd3FlMFcxNUdqRlhm?=
 =?utf-8?B?YVplS0QrMjZQSEM3cEN3RnIzdWtWNS85OHArWm1TeUdZVmxSdWh0REtsWTJq?=
 =?utf-8?B?T2pEVFJSeEFUbHNqNUYxVURxbUcvUkhWdFFRM3pIQW9TTmVLYzZzNFNMM1Nu?=
 =?utf-8?B?NTl5ZG94N1l4THV6bTMzUW44Smh0b1hTaGViUUd0RkVIYXNUSnRnNWlpRnVI?=
 =?utf-8?B?STJLNW5wS1RveUlLVFNwYTBsWkt2T1BEb3pEZ0ZMMXhtRitaQldNRnZqN0Nu?=
 =?utf-8?B?cGlWc0h6QVFwVUxRWEpPcm8zUzVNdG0vWTVBL2dHYTNzZ3Y0RWozL1JBeFM1?=
 =?utf-8?B?Tk5zd2xheVQ2V21zM2NIcU9seWx5MXZ0SHNsdkZ5NzlJVFUvL2JkL0E2TWhz?=
 =?utf-8?B?SGNuR3oyRDFtR1BYTkR0azFqUlAzMnp5a2JZd0Jia3czbXJreGhDRG1lTm9u?=
 =?utf-8?B?ZVBwblFCYktBQVpBa2NBSjRQQVplcVBxVEx4T0lVOU15S3hJZ0pUVWpLbWFH?=
 =?utf-8?B?THBJSUQ1L2hFMGNuUVlnV3pVSFJMMUxxOTllaEpJWnk2SVdFN0E0NmxrOUsw?=
 =?utf-8?B?R3d0ZUNIZFpSS2FBaWdNMXEvdWhDdzlCQ29ZTmNpMDA2aU8wVWVnTysrMGY2?=
 =?utf-8?B?ekZrcFhINWZZSnd1K0YycXNyZXhrZXY4M1FLdzdoWTBwaFhOODRrMWhOengr?=
 =?utf-8?B?dzM5KzZpQ0tSNms0TXpyMENvQUd4cEFtdlR3MkphaHFLNGFGeHhvNE8yNUkw?=
 =?utf-8?B?UmVYUjVwRU1UZVFDQjAzVjNWdTA1THpDYUdBSTFvRENQUC8rWC9pcUc5TXFx?=
 =?utf-8?B?bWtoV01udVU3emZpK1dCTHpZMUh4VUpVUURCQ3ZkYWhqTmhsZzlGaVdjcXkx?=
 =?utf-8?B?QmE3a1lTdS9uUE42NTEyZDdSbmg2QklUckE2bUVDcC9SSk9NS1lGcVJrOHRo?=
 =?utf-8?B?YzU2ZFpObmsxUXI1QnVzS2VzWmpOSmUyQ1FuQUdUeW1BU2V3djlIbUZaOEVN?=
 =?utf-8?B?V2VBS3BrZm1wc21nRUp2c2xjUG52WFdqcS9qbG93c3JRTXh5NTU2d0dUa0Fx?=
 =?utf-8?B?UEt5dnFlTXpoRnF2ZVN3ZGdMYU5SKzN6ZWFYS1lkbC9TWDZqWUdaTDlzQ3BR?=
 =?utf-8?B?cGxiTHBnNGZQWTZja3BTbjRBbXhiZmprNmN5aG5TYnp5Njl3a1lTVDYzc1Yv?=
 =?utf-8?B?NEo3SGMrMHdwR09uWkxqckRhQW5ieVZQb1JzV0xIOHBQVzhKVDJYY1hwYUds?=
 =?utf-8?B?b3hIN3R6N3orbncveHRPQXNnNEVBbXpLbUNER1Z4VHpqZldGOEk3VnZTZEIx?=
 =?utf-8?B?b040eXh1V2tyQUZ1VlZRa1UvN3VqengvN2NmaG1KdUtIN204RFh6TUZtWXBi?=
 =?utf-8?B?cURlbEN1Z1NwWE9xSU16Sk9wekJqa2NsOERrQXZGZVJENUQ4dWE0Z2lnZEh4?=
 =?utf-8?B?NDl0R0FBempCakV0RkVucmFPc0FscWh0NXlUOUNycHUyVU5KQnVacjQxc3Mz?=
 =?utf-8?B?V1dQTXorOG9nWllrKzY4SDd2OUxBZS9OUzF0NlptZkMzYXNOYUthUE1jOGZn?=
 =?utf-8?B?c05yMEtSQlRUd21iekIzYlk5Mk1EVmV5dldEZS9HdjE0dFVGd3VNY2xJdEZ4?=
 =?utf-8?B?am1Xa1RIbEhoZzJqalhBRHNxTXVEcXNzakVlaEpLSVFXc2tLS1BkYXdMdnAv?=
 =?utf-8?B?WDdCVkZ2eGlpVk9OOC9aczYwY3V6UGVMRkRqanlOWk1QZmRTclV2TVBSZmFs?=
 =?utf-8?B?K1paNWF2d0FRQVVDODllSXJUZXdPMU5YQ0ZjSGUwZEQ3RGtWRmVDeHo0Zi9q?=
 =?utf-8?B?a3dDQ3plakcwZUMyRTk3ZmxRZTdZL0RUNWRHMVpBZVJOVUlNSWFwTyt6SG52?=
 =?utf-8?B?ZWkxVHJTNjR2cWNCS2V2MnZjWGFTTTFDVTN2MlVUeW9kR0ZtTzJuTi9mVkZB?=
 =?utf-8?Q?p8082L9dQJTKfkUNIxfmU7+7MXvz0U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjRYa0w1VFViOUxiK2FVK2FWTmtlRGUwV1pxQnV5VXhUK1hiTDNiWkMrb2lD?=
 =?utf-8?B?TXNFK0craFFzdmZ2UURYN09Fb3BmSlpEZ3BQZDlCRW9aSnRUQ0NYZ05JMFBt?=
 =?utf-8?B?VGw3alcycm5UcE03Q3cwNzhlNzU5RWJ3aWQ4U3R3VUpXNjhQaFBubEd5MUtR?=
 =?utf-8?B?RDVsSENVNXIzL3lrSVMyaVVwdGRiNVN6c2U3RE5BWm9ZQkRhZGtxeEN6NG83?=
 =?utf-8?B?c0doNk95Vmhjbk5RQWIydC94bFN1WVh5dEVRcmlFR21JK3RKbk9tR3drTVYr?=
 =?utf-8?B?RHIvNTRkNWp6cUVkL1MrVWl3M010bC9CTGF6MWtESmFXYVU5SUxzUnZBRDdk?=
 =?utf-8?B?cXc3cUdoSmthWDA2NENuSkNzRXQ1bWkxKyswUEFQUmNpa3N1dFEzQWFiQVBt?=
 =?utf-8?B?UXNUcnIyVDEzQ1ZCS1kxRHhuQ1B2UnZZc1RsUy94enlObTNkM1hUdWxYd3JZ?=
 =?utf-8?B?blE2eDhpWm9pSHBSaWhueVZKeXNiM2pzS0ViYjZjdVg5dWNJY2hmckRQdnYw?=
 =?utf-8?B?Sm0xQmZaQitCbGhhalVnRi9pS2hHekd6L0dvT0N6eWEzQ0MxZjY4MUl3anpq?=
 =?utf-8?B?UnRBVnZZZGlrZ3drNnlMZXgzVUpwSlI3L3dJL2gwVEduNnJNWHFPeW05RGJz?=
 =?utf-8?B?bW95OStxSDV6L0hWYTc0ZndoUFo4YThSVG5LNUV4Q1NCL1dNZW16SStwT2ZV?=
 =?utf-8?B?bkVOQzRkQURJQXVYTi9FR2R0RHNEOHVnbVNjMmJnOVZFUUZGeFZIUko3SmR1?=
 =?utf-8?B?Smk5R1V1NnBoMnh3VVhVN2FDVGFFR1pVLzNCWmo3QjgvbjNvY2k4TkFVZnhp?=
 =?utf-8?B?TTV5SXBHYVM4QStWcGVCSzMzdEJmSDJkaTd3N1BLN3R3V2g1Vy82UklzWFpw?=
 =?utf-8?B?am9kZVJqclNvYk1MbFpJTThFVThKZlNTN1hWcGV1VCtJaGJ3eEU4TGIxNmdU?=
 =?utf-8?B?Z1p5ZFZNeThKcFlxYTQzSkwrR1JBWDlFcUg5Mnhtb1pkNXA3V2w3MTB1ZTZF?=
 =?utf-8?B?TVRQczdwRWQwZzRlOG5UZ25NSERvNkswWTloTWt3YUU5eWVKMHJkMzcxV0RE?=
 =?utf-8?B?Vm85MmRRRWM4bXQvY2g4ekR4VklCVnlyUkR5L08rVGlaZ2ZWUEpsNXd4cXZt?=
 =?utf-8?B?dVpHUjM2WXc4ckg0Y29qUVI4VE44SnhOYWk4THltSExNem00UEdJaklTR1Jk?=
 =?utf-8?B?NDdaNVRnVlE5bG03cHE0VS9SeUhmNkFzRTVXQ1FMY0NZV2F6YWdQYXI4UFZx?=
 =?utf-8?B?UUE0bFFOd1BWLzhKdzJxWVJ1d0FqdFpac1IvU1grVGJ3NkhWK21vY0g5VVdo?=
 =?utf-8?B?cVpJOHJiL3lKdVdjT3l4R1l5Y0VoR3dIbHp1TUtUT1lxL0Nxa1V1dzNNZzBS?=
 =?utf-8?B?UGp2RE0rYmRrakV3OVRneXlyRjJhYnFDUHRYMmtVYmx1UHlyTHBsdE5xNEJZ?=
 =?utf-8?B?U2UwUHd0a0NBTWJOMW1FQUxkWUtRZVJyZ3M5Y3U4Zzg5R0doM0dSZTkyOERs?=
 =?utf-8?B?ZFVTd2N1eWRnTDBMR2U1S2tFdnMvTFJsaXNkNzViK0xJOGRIYjNBN0x2TUpx?=
 =?utf-8?B?MStLOTR3SjVXU2JxQkZPeEZTZi9iVTBwWGExTm1INDdzMURQUzJoME85Y3dn?=
 =?utf-8?B?K2l4TDZjTC9ZdVJManZJa1Fnd3dvYVZsWkIyenc3ZVFZeXY0cXdMVDM3RDlv?=
 =?utf-8?B?ZkpBUW1meVZ1MlQ0Rkd0czVKQlFZTXZnbW9aUXJOU0JkYWJtZnF1TFd2Z083?=
 =?utf-8?B?UU5VY2NRNThJY0hBU093MFhhNjZRM3FFV1FNKzBnbE1jdk50a0ZOaXE2SGw5?=
 =?utf-8?B?ekw2UjA1Y2o3VjM0UGErekt2TEFKMWx6ZVJjc3Q2V0NNVlI1ZFIwRjBodnhD?=
 =?utf-8?B?UEFOcHo0eFVDUzVlTElNa213VitoYlFiMmhkR0YvTE9mTjhyV1F0UjV5ZlBH?=
 =?utf-8?B?QjZRT0YwVEl4cUl5UHhqdEUwUEpRcjlPR2hDNnVsN0xjT3Z5cDkzMmdHTnNK?=
 =?utf-8?B?eTF6cWpCakZ3U0JGYkdmU3VwV0JiRzJoTHo0NlRHNjYwaDUwd3p4VXJJMCti?=
 =?utf-8?B?WFZFUEIyandhRXhkYnd1eFVncXozcVJhQVB5U1VyMXhoM2ZoUjF3RlBmYXhP?=
 =?utf-8?B?cmd3aVlQcG9lekNWM3kvN3kyY3BOenM3VnRjVmFMSG01R3hlV3I4SkZ5V2lX?=
 =?utf-8?B?ZEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <192AF2C09FC01A4885DF4CF66D8E17B0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a5e168c-8d4f-43fb-63ee-08dd8387baee
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2025 23:28:33.6088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7143HUgVpZkUjrqGicsJmrEcpRuKOIpv3vwAJhUvom6RnbWQ/L3IxjhpS+n8VZpe/w5u9dHBbYvsUKbPFXzwWGU+Hy/t64MShfEGcR9HBcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7192
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTEwIGF0IDE1OjI0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPT0g
UGVyZm9ybWFuY2UgPT0NCj4gDQo+IFdlIG1lYXN1cmVkIGNvbnRleHQtc3dpdGNoaW5nIHBlcmZv
cm1hbmNlIHdpdGggdGhlIGJlbmNobWFyayBbNF0gaW4gZm9sbG93aW5nDQo+IHRocmVlIGNhc2Vz
Lg0KPiANCj4gY2FzZSAxOiB0aGUgYmFzZWxpbmUuIGkuZS4sIHRoaXMgc2VyaWVzIGlzbid0IGFw
cGxpZWQNCj4gY2FzZSAyOiBiYXNlbGluZSArIHRoaXMgc2VyaWVzLiBDRVQtUyBzcGFjZSBpcyBh
bGxvY2F0ZWQgZm9yIGd1ZXN0IGZwdSBvbmx5Lg0KPiBjYXNlIDM6IGJhc2VsaW5lICsgYWxsb2Nh
dGUgQ0VULVMgc3BhY2UgZm9yIGFsbCB0YXNrcy4gSGFyZHdhcmUgaW5pdA0KPiDCoMKgwqDCoMKg
wqDCoCBvcHRpbWl6YXRpb24gYXZvaWRzIHdyaXRpbmcgb3V0IENFVC1TIHNwYWNlIG9uIGVhY2gg
WFNBVkVTLg0KPiANCj4gVGhlIHBlcmZvcm1hbmNlIGRpZmZlcmVuY2VzIGluIHRoZSB0aHJlZSBj
YXNlcyBhcmUgdmVyeSBzbWFsbCBhbmQgZmFsbCB3aXRoaW4gdGhlDQo+IHJ1bi10by1ydW4gdmFy
aWF0aW9uLg0KDQpJdCBzZWVtcyBsaWtlIHRoaXMgZGlsZW1tYSBpcyBzZXR0bGVkLg0KDQpJIGhh
ZCB0aGUgcXVlc3Rpb24gYWJvdXQgd2h5IHdlIG5lZWQgYSBzZXBhcmF0ZSBndWVzdCB1c2VyIGZl
YXR1cmVzIGFuZCBzaXplLg0KT3RoZXJ3aXNlIGl0IGxvb2tzIHByZXR0eSBnb29kIHRvIG1lLiBJ
J2xsIHJldHVybiB0byByZXZpZXcgdGhlIHJlc3QgYWZ0ZXIgdGhlDQphbnN3ZXIgZm9yIHRoZSBu
ZWVkIGZvciBzZXBhcmF0ZSBndWVzdCBkZWZhdWx0IHVzZXIgZmVhdHVyZXMuDQo=

