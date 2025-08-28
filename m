Return-Path: <kvm+bounces-56169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C462B3AA82
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BE96A02960
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72587337693;
	Thu, 28 Aug 2025 19:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QVHbtLK+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC81020E6E3;
	Thu, 28 Aug 2025 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756407723; cv=fail; b=AVGTm4EF1slgbvq9GoQIQzUvE/H6ZKEj3T8RcIqxkZMDk/MBnLX0eT7afnhVP57CpeBWavvCQ2tExtzbDR7XMJ8Js1X9f+GjDzbM/pOwJUuo+XGae4YIhqzsQ8fareGio4Gs8dwMiUmsGM8sDwKIJj9FPenZ52SRsCoM96oHiyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756407723; c=relaxed/simple;
	bh=T7lksKRTjiwLDZGbQ1brz25rkxNM6SAkQJS9Ulzq+7Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hY+mJHETQkX377/SujmR66ggJQTx2GAHzdSz4MGHcvYVrXdEGWRNa3NUinPdhp+5z9Vm4YT0SZtGtvTmE/6SuZ9keJNKR/IfcqJ1+B81uTo9N+CHzrH98fdeebH8yGF3WY5tpV7+e68Y4JOmKPo+SQ+mVbxgAiKoQdaQtewUSdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QVHbtLK+; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756407722; x=1787943722;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T7lksKRTjiwLDZGbQ1brz25rkxNM6SAkQJS9Ulzq+7Y=;
  b=QVHbtLK+vqfc2570TxiJfUW93rbQexnLwmRnHELWYtYLjzTdjc7fO6pw
   OfCuR1kVgSNuULwjVjZNv2/t3IsPVGC54QziAcG/j3t7X92BoiTW5Yka1
   NwduDwMceI6fOR1i9G08PIPY6NAsm3sGahHSWo3qRIe/dAzr3aTqzOLts
   DmJSsasbztvAj4lV3AtJhQkj6LCp7uJyOv1iND4DIqCsSxl0BxLa+l5Up
   lv69RpPCw1PVNx3Aw/AdxC5oDsUrndAdKBV6PRn4CX354Bgj/Kn7rIDTD
   lZWdK5HN0nKYwfoberjGGK93Ofd0pEgIRd93wzlfT3Fho23RTjf8dygjo
   g==;
X-CSE-ConnectionGUID: 5V6a+oibSjKYXQGRkqP9XA==
X-CSE-MsgGUID: AMEnNNRHQ1KELALWSax6iQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58792845"
X-IronPort-AV: E=Sophos;i="6.18,220,1751266800"; 
   d="scan'208";a="58792845"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 12:02:01 -0700
X-CSE-ConnectionGUID: rOhVfXWOReW+UTbFEFaKmg==
X-CSE-MsgGUID: sY0EM8wzTu6/8lqskOMkdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,220,1751266800"; 
   d="scan'208";a="169440211"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 12:02:00 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 12:02:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 12:02:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.77)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 12:01:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGKj1/Bu/E6WzgHWIJQ0amHm64aIPYXy4CFPlDf0Nv64TeNmaQC/RUXZgwlhs1aOloa99101GJDGm5JnMF6REgciGAy9YnZPe3fdO1XwUe5YLMwlNgjon883RNTgxr/JegUVrUDqHpfPHzhIalfhimTQv6UbVdA6nKNyStt4Rk4YnVczvdGki8lqWEr/GB9nUhEn5MNvNpolCMH4tbLw6OYlv5mDHzmkE1WsH/ptM1vuyPIg+TtybD4bXT0axOVmzzRNG+th6uw91rXD3Apk9VdTSelitCI+4kzYcjkhd2+YJ0ij1fUpobrKrIJhIyhGFdhwibL+FXMipUhgXqHCDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7lksKRTjiwLDZGbQ1brz25rkxNM6SAkQJS9Ulzq+7Y=;
 b=LKXa2grGyx3OsJgq0/7XiMiWnzOA6P8DDV4Nj2DUKLAhBM77aD5ukbHHWGMShwdDuKa1EbYHWerjVq8KUu/dcI1cZ42mTXLcLaOISkK3hFptG1zCdPrPDlDe0fEkaPFmk/BUW+ij61m1DcM7p+Yp28PnJnP6aYEuffYtPiv/e7T0/7ND5nIecZ1TIlCGq4GpwGxK6kKKKdGhfxyPaLimDqA/amCw5Oy9fwtq840dyAxGoOYgQrtkcR0PNor5qy/kQGZrWdB5oDX4y21wLVZAsZAbcBsYwXnXNHUkrKteyM4F1cs8mQkUo2dRkJfQvdxtKDGwW4wAs3C0Nhh+vJurbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PPF1FCD3EAF0.namprd11.prod.outlook.com (2603:10b6:f:fc00::f12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 19:01:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 19:01:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 00/12] KVM: x86/mmu: TDX post-populate cleanups
Thread-Topic: [RFC PATCH 00/12] KVM: x86/mmu: TDX post-populate cleanups
Thread-Index: AQHcFuZRr42QsAITLEiYTVXl2k2t/LR4bpwA
Date: Thu, 28 Aug 2025 19:01:49 +0000
Message-ID: <567d67970b610fe1e9d09dbfaa935e05093495e0.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PPF1FCD3EAF0:EE_
x-ms-office365-filtering-correlation-id: d1953371-4d76-4382-f0ea-08dde6655795
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OElEQkZmUjJSeU5QbW5TRjdyTDYvUExOV2FUZ2t2YTM2U1d2bmRNcEpPbVJh?=
 =?utf-8?B?ODVKTFVRZVpjRThCTE5xSDhyZ2Jqbk0vTEhsdGFLNk51cTdrQUdzdHBtNlhF?=
 =?utf-8?B?L2gyVkZZSm5PUEZOOXlQVFl5enZmZklJVkMwMDN1d3orVjFlaUVIc3Z6K2Zr?=
 =?utf-8?B?WWNUSHVDS3B1WkUxZ0pwVzBlMFE0dnh0d0NucEduWk5vdklCbk5JcDFYdXpJ?=
 =?utf-8?B?V3o0MTFoR2NKL3NOaDFjMWY2c1dsU2pzcjJMUTYwdE8zM0VIN0M3MUFuaHZJ?=
 =?utf-8?B?WEhQbzRrOStqemF4UXZwVWVITUxQY0o2WWFMaDFJNS9Bd2R1amM0aG5tSk0y?=
 =?utf-8?B?RzJ5WnVpSDhiR0h5UEJpT1lQc2V5NnNhUUZCU1BndGxYRDZ2cUZxMmZGcnd5?=
 =?utf-8?B?S1ZyZUFMUWo0MmRkYm00MFRGTXNhWUlqNkk1d3ZLN1lPeEhSd2xJTExYMkZZ?=
 =?utf-8?B?OVpkWmh6N2lxdDZ4WU5hNzR2V1NrQk1oL0NXUGJralJxcEdFRk9Ddk9jTWJH?=
 =?utf-8?B?aHlQSXp2OVpTa20xOEgrQ240R0M4eGZLY244SVhQTGFJamY2RmcyRUt0UjQ0?=
 =?utf-8?B?b09mdWhyLytlY2RSNEVIRGx4VlRlbmw2WGw1S1FRZi9wNGdId0pQNEg3MWE3?=
 =?utf-8?B?cDg0ak9UbGRBSFJ4Si9mbTFsQjlzUVBWT1R5b2pnZm1uTk53UU5ZblMvaWh5?=
 =?utf-8?B?bmIvczJBZFVpWjJOYmY4a0F0dzh3RlgxcURwN2FFSVBabU1zNFRaSHp1OTFE?=
 =?utf-8?B?b0lSSlhHb1JPL29hbjZBSmV4U2t6T2NrK2ZJYllQcjZTUHpmSkpnR29pN1Ey?=
 =?utf-8?B?dWc4UDJTYW5taGlLd0RpOHUvcWo1b21rQTBISzZKSGcwZXFvb0U2TFd0YWVT?=
 =?utf-8?B?VzlLMVJVdzVHdDVWZ0tGbzdYVUFHeWUxZVhlUFNlMnRzNWJ6MmEyK2s2dEIv?=
 =?utf-8?B?dWZ5NzgxaWl0NzhlSVNxVXhpWkdFOG10OFFlRE43RVRUK1lBekpRdWVJWkR1?=
 =?utf-8?B?UlBFdHBuZXFoZXNRYWVFemVWM3RHcDVyL2FrdnlzTEdTQWJLNUttTnM5Rkli?=
 =?utf-8?B?dnpBZkhjVVptOVB3eFNyS0N6cExUS2o1ZEd3UmNlaXRtNnU0Wk8rYVZaL1dy?=
 =?utf-8?B?cTloWWtPUGcwYzNrN1JsMG8wMnBiUU1aRXJTd0orQkk5c2tUUm5jamJHUTNN?=
 =?utf-8?B?a1RJSW1UT1hXR3dyaTFqK1Jvd0d5K3JKcXpGMjRWSnFvNUwvUkxJRDRrZEVs?=
 =?utf-8?B?Z3ROL1R2RTRFVGRhWGVZa2FLZE5xT1ZzL0I0TWJHRkRNdVhFU3JWMHBXWjBp?=
 =?utf-8?B?UWlaQnBVeXZRaGkrMnkxSEVMamR3NFpVd0NQU0ptS2QwcS8vRzFmMXkrQS8r?=
 =?utf-8?B?aHE3MmJkQkdUMDNlWURvTHR0b0V5TlN2cjRJeDJLN1RydWp1bE9TS2tWaXdv?=
 =?utf-8?B?eENValN5QjV1TXcvcWF4S2JVKzFNa2VtNW9mWDN1ZEdWUWtyY2hGVWwxVDJx?=
 =?utf-8?B?ZnR5bk9MUHFjeXYyTlBKclQvYkI0bXRhNG9jd1NpcGFZQjA5YUk4TlpBSW1j?=
 =?utf-8?B?V1JkUTJYbUNVb2VUajFPaFFmQW81YmJnTStNM1puNnJGWTdMWmhnTlYvK0d4?=
 =?utf-8?B?d3l6cEJrQm1DaXBNbjBaWTF6Zm8zQ2kraWpRSDF0aktUUUhsSm1BaU05czZm?=
 =?utf-8?B?L3UzQXkvWjBkZ1hKWElzb0dsYVRZQkpHU2xkRHFwTHlJSW1IZjRhVmJSbTZH?=
 =?utf-8?B?TUtFbUFHWUp5a0F0NFM5QmZFS1AwcVhyQjUzM2RjVEJDMXRPRWZOTllSek9U?=
 =?utf-8?B?KzBoYXlKMUFrd3VBL3dXbWt3OHBlNitHL2czYmhCUEJKK1Z5YzR6RmlGT1JG?=
 =?utf-8?B?dmg5Q2RIRHoxNVNUR2t1ckdiTWUrZG9TS3c0a2hTRHhsb29GS3JxTjNKUUVN?=
 =?utf-8?B?dG1Ra2VZZlFDdGJvYWpiOGwxeGJJWjU2akxCVWROSHBkaU5hKzc1K1VMZWFM?=
 =?utf-8?B?bGJLdEJUNG5RPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTc3c3hmdW9oVk5lSW5NS2FXaXpKc0hBSTU3WGp2T00vTFcvbDhaZ2pRL3My?=
 =?utf-8?B?M1AyWFIwNStkb3l5ZU9yU1kxbmF2Q1h2S3pCdjY2RVFGK2RLWTdzakpmNUlT?=
 =?utf-8?B?c1o2S2JGdVlvTU51VmxaNFcrNis1VHF6WXJZZTFyK0RySlhieUdtY2YyZ1RK?=
 =?utf-8?B?VlZkclgyKzlsbnIwYVBRTzBIemVLRjltTk9FTFZYTWZ3bTNJQVk1eU9RaG5V?=
 =?utf-8?B?TjZPUGdiYVBjRVIxS3FRTFhmL3grRUFsakhNUWE1YkhGOWJrOVVYK2w1SW9G?=
 =?utf-8?B?U1ZZa3B1Mk9jeDdCc3VQNkEwOU9adnpKM0QvMmloVUpEdWRvck8xMTdhTWJq?=
 =?utf-8?B?eEhaYXd0V1N2SERiSEdPNGxaUmlLc0FreGliTk4xcnZRTmNNcklzTU43anM5?=
 =?utf-8?B?SzNQQzN1SzNNdUpzOWtDdWdNazY2NzJac2ljNlZxYitXT3RuN2MxL0dhbEJN?=
 =?utf-8?B?QUE1TzZod0wxMFRaaHFLeTlneGFWUjVXbzduSjZmekpiV0dNOWx1MHBOUDlz?=
 =?utf-8?B?SE1lR3BKRWlkeTdodDBZOFkwT3Q2T05nY0VWdjc5NWV6aEJEUHgyQ2NrTE9F?=
 =?utf-8?B?VE50YXg1cjVVZWozNmt6VXBoMmt3K2EwN0htSWFqdzRxaTc3cXl5SGQreHF1?=
 =?utf-8?B?clNrY1NsQ2QwSWpFYktwMkE4S2ZDTXZuczZUSitlS2RNaHBjWERPcnY0blNI?=
 =?utf-8?B?NXhEQ0x6SzVEL09tTmNTRFhWSE1aMjBHcUpad0tocHBaZ3BhOVpZQzdhWU82?=
 =?utf-8?B?OVFVVTF1b3pqN2hRNGRtOTVJbjZTSlRVNFJaT0R2SlY4UkFmelV5dnJIZ3l5?=
 =?utf-8?B?UVhLL3N1djdLYlZGK1dhQWR5c005YkFkQjBnNVYvNkU5VWVPL1pNK3BhRnpo?=
 =?utf-8?B?cmxYNWw5cDJIOURFK0lJeEdPMlMxa1NnTkh5ZitLd2M3Q05oWWlUdlpsK1d6?=
 =?utf-8?B?Y3ZWZEcyMXA1N3lXcDd6UENQSUJIZzFnQjk3WEhHWFlraVdOcFVnNXRwcFVN?=
 =?utf-8?B?d1NzVVl4RWtjKzZtR1JsdVoxUG5IZ1lERUhjNCtEKzBFaEdnTENMSjlMMlU5?=
 =?utf-8?B?MGl2bTlPR3JoZVNwNkVybFhIUzhtNndvMGpIbFBHYkJTQmNoOFhoTEwydCtE?=
 =?utf-8?B?elduTEtNSUpFNWE5bFJpdTVaUU1qV2htMUZQeFZXS2NkWWRidGVKUnBvTnNs?=
 =?utf-8?B?REh1dXdJZFNIc2dSNHB4cE9pVmErRE95Ym4vOUF0N21uODJtTlBnbUMzNmZM?=
 =?utf-8?B?UDJpYXFwSXAxV1ZMcFAxVVZYbHFFMTQ0YVJ3TnFER0szcEVBSmdidWRKcGVk?=
 =?utf-8?B?RUpsKzRIOTY2dUJKL1lOaW1RNC91c3pha29sS3Q5dGo2aVNvbnVLejlvMC9o?=
 =?utf-8?B?YVRncnM2VlBWWWZZcUFvbGgwbW9TbWRzUHpNenh4WVhidGMrQlZkUjFWL3ov?=
 =?utf-8?B?NlNaeEwwN3YwUUowNGkrVUx4UzhPbHVheS9ueGk4OGU2bnJhUEtzS0xnWEZl?=
 =?utf-8?B?ZEpPS1UzTnBOaERFSmtaOExQWEg2RVFTQm5TT3YxWEduY0g0YWR6ZVFTRkFu?=
 =?utf-8?B?NnNIdmNNVTdCSUpxMnp4ZkRvZzhCS0I5dWUrOU1uZm4zZkk2NkN1ZzZOUVk3?=
 =?utf-8?B?OUNoa2xETnFxQTk3QUx0VXhQK3VYVmFsbkhZbS82dXFmVW91MFFDV1FYWlQv?=
 =?utf-8?B?RkZ6T1NCSUtSMXFoa2VPWDQyazRlRkplZ2QraVNOcm9PLzBhbFRESklFWUdK?=
 =?utf-8?B?UGs1MVU4cUlpRjFWSEtrQlZpcDhpTm5JWFpLTkU5NnNTSlZjbTIwMnlYc21r?=
 =?utf-8?B?cit3UWVEV05ZRFBrKzZCMjVwTWlQampNVHNyM2tmRURXdHAvS2dpTk9LQ3N3?=
 =?utf-8?B?N29RTXZOOG1RbXZubk9LaGtOc2lOKzg3WnpxNzhPaGIza2hZbGdFc0p2bC83?=
 =?utf-8?B?N3Fxei9od0JRd3FSNU9SclF4UkdHd0laVzM2NmpxL3dIc21jVDczcUc3MjBQ?=
 =?utf-8?B?bXJ1M29ZVmRHTHhpZjBKQWJ1NGJOcG14bFZ4cGxrK0syZE9kQWxZMjhLNUNi?=
 =?utf-8?B?dVJaNVJkTTJWTTFvYWNINXRrWkVLaTRoc2Q3THdxRnQrVzZhcUxQNTNabFVK?=
 =?utf-8?B?dk0yTGkxUVNPVkhxdVlwQXZxVVJiRkxCS2gydkZ5bEV0cENVZWJwVnhYUFY5?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCA064E5E90401499CB89DEA18D31B87@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1953371-4d76-4382-f0ea-08dde6655795
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 19:01:49.1926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVD6q84qxG63a7MLOpLoR/SjLpfTPZiIFu1z0MjSCHDkdAFzGqIWrYFVXx+Hv3XMn9i4vBg/dV1FhDWht7HeXnRzuwXuKdf3p6y2jOZUo14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1FCD3EAF0
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDE3OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSRkMgYXMgdGhpcyBpcyBjb21waWxlIHRlc3RlZCBvbmx5IChtb3N0bHkgZHVlIHRv
IGxhY2sgb2YgYWNjZXNzIHRvIGEgVERYDQo+IGNhcGFibGUgc3lzdGVtLCBidXQgYWxzbyBkdWUg
dG8gbGFjayBvZiBjeWNsZXMpLg0KDQpMZXQgdXMga25vdyBob3cgd2UgY291bGQgYmVzdCBoZWxw
IHdpdGggdGhpcy4gVGhlIHNlcmllcyBmYWlscyB0aGUgdGVzdHMgYmVjYXVzZQ0Kb2YgdGhlIHBh
Z2Ugc2l6ZSBpc3N1ZSBZYW4gcG9pbnRlZC4gV2UgY291bGQganVzdCByZXZpZXcgYW5kIHRlc3Qg
YSB2Miwgb3IgaWYNCnlvdSB3YW50IHVzIHRvIHB1bGwgdG9nZXRoZXIgdGhlIGZlZWRiYWNrLCB0
ZXN0IHRoZSByZXN1bHQsIGFuZCByZXBvc3QgcGxlYXNlDQpsZXQgdXMga25vdy4gSSB0aGluayBl
aXRoZXIgc2hvdWxkIHdvcmsgZnJvbSBvdXIgZW5kLg0KDQpJIHN1c3BlY3QgVmlzaGFsIGNvdWxk
IGhvb2sgeW91IHVwIHdpdGggYSBURFggbWFjaGluZS4gQnV0IGlmIHlvdSBuZWVkIGFueSBzZXR1
cA0KaGVscCB0aGVyZSB0b28sIHBsZWFzZSBzaG91dC4NCg==

