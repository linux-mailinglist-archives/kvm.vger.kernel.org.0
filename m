Return-Path: <kvm+bounces-56180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA2DB3AB53
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 22:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56AA4A011C0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 20:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC422284B25;
	Thu, 28 Aug 2025 20:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BdxijZ35"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609EF27E079;
	Thu, 28 Aug 2025 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756412025; cv=fail; b=KLBmVp2tO34Ko6Pd0Gh41rAIJpHfCr6vla/+8vSZ/6GKiLAAV9j2lx0xbFpwl8GpoVWHYin0z8U5/pTYiBRuET3kp5GRFxTcRGOBOoo1eSu47N/rtGua0ewTAD7LHZYpO8p14OGbP6XB/1u5o8nMn4bH72H02yLDmg8Ox3XlVpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756412025; c=relaxed/simple;
	bh=/SjNOGz/dfDfvef4hB2f9Q01ajKbYsC+BHyRV4mttOk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TBOwX06GKnFWZtvyThdSaZIoYQhRRZpynBr4cxZLcCm94+dFIL7h+OvtyQQ56EUY5BXAarsIFFv6M9QeUVLNtq2Bi1j4/weM8EWkoxE6MInz8fxaTgteKR+ZUXOpe66JYpInwpBuASaDC3+5EKG1wIWP6HvCp2E2A+K5fbeQsYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BdxijZ35; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756412023; x=1787948023;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/SjNOGz/dfDfvef4hB2f9Q01ajKbYsC+BHyRV4mttOk=;
  b=BdxijZ351/DuU1apBGI0O8P13TlpBXFOjlq8dX7MrC6uo7xsXThPn+JN
   l9zOfeUSOS7iFs6AI4Wy/Wwp+Z9841mnedMvcGDZAETLBOfttGcx4dBgF
   dPZVkKBdU+zY3bVG4GuHMU/cI5ygnWgy6HfgS8HTciW0LspQfvvPg3BZj
   DXMsyKb72bXKuTBiAl5F1z9D8AgZkCrKdI4sFpfzDWBw3/gZ4R0g5TOye
   AReEa4t0uTt+k1GWK1/AbqWQJg7g469vWO5E4+eLEB6dzRTKSOC1dLRgi
   xDhkWG3TdVFQWGvlElhJ+OBV5lUaTKK84XRtBA0tdb5+npA2dyu9ZEfDY
   g==;
X-CSE-ConnectionGUID: CrVMU26GR92f+7IxL0zJzA==
X-CSE-MsgGUID: hdK/nPBVRrKHMM1mrV6itA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="61329154"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="61329154"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 13:13:41 -0700
X-CSE-ConnectionGUID: 5cRFvas1Q7mGwQgewAN2EQ==
X-CSE-MsgGUID: IVDUhq+kQqS6WuwRFvOfqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170374460"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 13:13:41 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 13:13:40 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 13:13:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.82)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 13:13:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DIIfScRBX2iPhoRhih/0j96g3Z1+1QZOdcLTRXEy4t4wfMhI0Rvl6TlhiO+UXqd0PF9qJGuNd379CES6kwKf8ClYblcLqHOP89DqnGXroKt5/khtSVNx4OFK+LIguei215/7Dh6HpCxsBe1XQYdbo8MFu3noBRVHl2XD7rtOgNBxbmqwYVtYvQ8KALqaxwClpnpHixc8tvyx9V8YG6Srdq1sxM/lD4smEwjUU0nEnX3/yVtRTjyfKv/Nz9ADW6VIvfbCT9FBv5tOA1wwRdXH2+uslOca2hwwoGp4O24nks2OBFmHh6zJdNzoDW+kx+5IF2HKmftl7XvWWONEXV0awA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SjNOGz/dfDfvef4hB2f9Q01ajKbYsC+BHyRV4mttOk=;
 b=NTrF/YyzJa2l6M0UPa8uIHuu74dgzXWwMekHqarEqzQNGnVUMsimf0GiqiVATA3/ULCvwQ0vE2cKoO1YMrJbtfgdk9px+OizKTJdGO0v6Y5DmwhbOs/lux/lMENvfZH2ZyNBxm/NyLkDJ5ml2rAcoLHP71hg7uAiTg0DmUMYFA/m6i/OFPVYBbtTGpbZcfB1YCR598rnazxwptTvymzrA1OW6TEPQ8m3cKFUwLeTGKdNrXHCCYn1s8mu8Yrr52viCqzD4PpBSbdAdY024rp5xY+WHwnHechvHk7qvpM20XLHhL9PX/HWbPRZdAeK7yDYL1bUh2a0ktX1Dz5Hlug4aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7602.namprd11.prod.outlook.com (2603:10b6:806:348::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 20:13:25 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 20:13:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Thread-Topic: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Thread-Index: AQHcFuZaACFmy6w2NkqjEK4wxyWKhLR3VG6AgAEfpoCAAA6JAA==
Date: Thu, 28 Aug 2025 20:13:25 +0000
Message-ID: <9e55a0e767317d20fc45575c4ed6dafa863e1ca0.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-7-seanjc@google.com>
	 <11edfb8db22a48d2fe1c7a871f50fc07b77494d8.camel@intel.com>
	 <aLCsM6DShlGDxPOd@google.com>
In-Reply-To: <aLCsM6DShlGDxPOd@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7602:EE_
x-ms-office365-filtering-correlation-id: 6a2d6e0a-bffb-47f5-01b2-08dde66f587f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aXpXaS9SL0pJZ1ZsM2ZSSWZhQlNmR1NrbFJUS0tOeGpmeEtUREpmbDFQeVpS?=
 =?utf-8?B?Nm8xaExudUZtZkYyUHlLNnNMRXdLd3ZaQk9CRHdGUGNxT3oxVW0zNWk2WCtS?=
 =?utf-8?B?NThaSjdIMGxDVkFGZmNKZGdlYXdUeWk1dE1odlhvcG83LzBuZHV6ZDdsRGJq?=
 =?utf-8?B?bVZGMHE0R08rNHpFMDd5dGdqM3JUWWVlL0pLMVQ1UGlReFJ0OXJ0OWE0SUFq?=
 =?utf-8?B?K0lOelVCQ1NlN0ZVTGRpbDJ1aWlNM2pmaUZFRVNld2NDbW9ubTdJdkR5aVAy?=
 =?utf-8?B?cGlCUFlGMjNER3ZTZDhFRWpIRlFGbGRTaW51WDNuMjBhZnJYdEpzZmV3UjAv?=
 =?utf-8?B?c3Z2SmhlRXU3RkU3MURFOG40azFrd2F2K2dDUHZUNXNPQS96ajJxZVZZclRK?=
 =?utf-8?B?R1hnM0ZzYW5OSCtEbnNlbmFBSGJ2dkZQYXljSlJNdmg5S1QvQXdFamtLNmdh?=
 =?utf-8?B?dTBhdTQ5R3llMnlLQ0hWdkg1WEhUd2gvODh0dDlqdFg2WlB3azB3TFYzNkVy?=
 =?utf-8?B?VDh5L0swTUpPWHFWUmkxek1DR1VybW96dWFhS09iQTBDRExTQ0FadDdab2V0?=
 =?utf-8?B?VjJGb2Y1UVZqclNDVENuQktDN0FSRCsyMnBMQmpsb3prYys5SWxBMjJGZFBR?=
 =?utf-8?B?R0JmaHJxNG9Cc0MxbHhTVG84ZVZVY1VuQVo2aDBKRHdDMmJESHdpaWVnMjho?=
 =?utf-8?B?VnVyMjhhdk5TenpvbG5vK2R1cWlIN095WTZEV2dKanZySmg5U1pkK09tTkZa?=
 =?utf-8?B?MG9IMitDeWl4SUk0a24zNFlReWd0R291akNxNk5HV01JdmxZWEdxeG0yZEta?=
 =?utf-8?B?UmdWMDJ1NEFnbzE2RThRSW5saXZRVythZHROZndkeU5yZkZLdzNVQklycVQ0?=
 =?utf-8?B?RDJOeTg2dFk5NGdSRmtOUVg4K1p5c2xYaWtld0FNTGxoZTJxMjQvTGhybUJI?=
 =?utf-8?B?emVzZFVlYnd5ZkpESmUvS3VxTGtXZk5pT1NZM1UyazRZRndISXZmY01iT2tK?=
 =?utf-8?B?V1hYbFFyeGVDS3FvS3hnc21mTGdDR3FFM2FhR2VnL1NCWDUzb05aMDZERTBY?=
 =?utf-8?B?bEtGVU1NdG9QdUcxTVQ1QklqY3FJTWsrdjFQODMvS1IwVXVFU1RZaHk2WG91?=
 =?utf-8?B?Tmw2cXNhN3VadHdFQTdOQjFQcTlkK1NmamVHZENhN1lwdzVyVElteWhMWkl2?=
 =?utf-8?B?WnFiRi93azd3S0Y0cFN3MDJJUFBoYTh1dFZYMzhyVFJTaDFpdXN3Q1FudEdU?=
 =?utf-8?B?Qjk0RXVyMUdCelhiQS8wbGxhYXNzQlpsZDV4cEFlODlBczdFMy9WaW1BN2RJ?=
 =?utf-8?B?R1lYMlZyV0RlMEUvWUsyaitYTCtBL1pwYS9uRkFWWEpwNW9SSE9HbG1YTjN4?=
 =?utf-8?B?alJDdkFIVEZTamRKSmVjWEgyMVFxejJLbFlpeEJYWjUwMjY5dWVBMnlXVnBL?=
 =?utf-8?B?cDhRNEFwajQzWjI2S2RkeHJodDJkdDh3V3AxTExDTXovNnpSQnZraUU4Y1Zq?=
 =?utf-8?B?UVpuSnUwNlIwVHcra1psV2dKWUtyYUR3L3FENmtWb1l2OVRlRVVjcHM1eGJV?=
 =?utf-8?B?OG01VmJaVVlWcGdMempBRFJ0QzltcERveE1zUGkvN0RGU290aEtmMFA4OGg0?=
 =?utf-8?B?Qk5nOUR3WkwrZ09uMFZLMURJM0hiUkVvaUd0bk9JZDRQVTZoMjgzQTRWNkd0?=
 =?utf-8?B?dzkxekNpeHVYTmRFUUxwNlJvWm1uZURwdTJUMG5sRTlFREdXTzYwbngrcmpj?=
 =?utf-8?B?N1k2UzlrMGMraXh5V2hnRExQY20zMDg4aHgxbk5GQ3lpWUo3ZThzSTEvaElM?=
 =?utf-8?B?bmwrVFNQM3RIWkNzU0hGRDhCTUJ1Y3pySkxhR2tPVThZaVJHanR6TzNuazcr?=
 =?utf-8?B?TDI2SnovNUo2N091eEtpK09zd3dvSnQzbDlrL2ZDa2NPMEl4ZytYRTRmL0My?=
 =?utf-8?B?eE45c1dWc1d4UEhFTGpyM1dLWTkvUUt2Szh3WXB5RVdtUkJxSjR0SW9LYUQ0?=
 =?utf-8?B?T3dlY1NJUllRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TE5QT2RKWEJZL1l5VDRhdElCUFU1KzluYnNoTGdNMGV1Rjh0ZmxYYmZISXFO?=
 =?utf-8?B?VERIazhCTTB3enpuV0hMdzV5ai9xWWZ2ZEpNWjFIT1F5LytRMm10Um0zZWRy?=
 =?utf-8?B?b2x1QlJienBKTlNIdXFNOWlkYUF0QVduN2FXa1l2UGxJYnpFdVdzRzhXeHAv?=
 =?utf-8?B?UU9yY2g1SFVIYmhLbEpNdkxjNFowaVp2Zk9IZ3RmRklpRVpDUDkzU3ROd2Vz?=
 =?utf-8?B?NW5MTEtxUm1YS1EwdmxPZW5JdzZNT21YcHJ0QVo0RG5XTVpNRW80NDJkbCty?=
 =?utf-8?B?aU5ZL2ZSU0p0WVdQMFprUDB0N2l3RElVdFg3dUVIMUlXemh5aW1XRjJIcU9J?=
 =?utf-8?B?eisyRHovZzRtRGdsTWFWdzhNOTVySnFtRzBRVlpjVTNCK0ozY2hjY01UVjF1?=
 =?utf-8?B?dmovbTQwM1Badnhic3V5VlZpbG1CakhDVTQ2SUJhYkNkYjljNWhPSHVrWmlW?=
 =?utf-8?B?STRuY3VpNzArQnRVSDVQTGE0MDY0YTRjaThPdEx0NXA5RGFCUXZXNkhHaWg1?=
 =?utf-8?B?SXFGMVFQUE85U3NLbllQODEyZTREb1o1WEpMVDBPbGNtTVNwWGdFWkJmWUZ1?=
 =?utf-8?B?VDJ6cVF1TnRSZVk2SU9YZDRVaDNjSFlsNVRoSHJncDBUS1ZpdmNrVVgxSStB?=
 =?utf-8?B?WnM2TEswRGduVjhORFpaOUIvSTkrWWZxQWU1NG40RGRBVVBONWgxampUN0Vw?=
 =?utf-8?B?b3o3b0QxNlRJWVVyYzF5ZGlmZnEvd0ZOSVU4bVk1SEplTTAzR3hZZmIzcWpD?=
 =?utf-8?B?TTkzcTIzaXl0aXJsQTJwTW8vVnZ1T2JtTkt1cjM3MEJubnZDUUZNbzgxaGpQ?=
 =?utf-8?B?cHRXaTZSYkdUVE4zVHVUd0M3YUxCS0V1dGlsWEVIWlVERThLY3RpV0NEajR3?=
 =?utf-8?B?bjhxQ05HZUVyRGRqdTgyaVRtVjBjOW1DcThoTnpzWTFiNnphUzJnSDM2WGZC?=
 =?utf-8?B?UncyN2JhQWs2UkpPbmw5ekpYd3A3UTNGb1Z3SndVdU1wT0Jtd1poVCs4dWlE?=
 =?utf-8?B?cVFxUWhxQlU4WXVqR1NsbGljZis4YXZacGxMNGNielc0c2V4L1JLVWZ5UWl5?=
 =?utf-8?B?ZTRHQVdITUlLZEliSWhmcGlMUVFwWUk5dldid29ZaE5aTmVvQTJRa0ZxSmxl?=
 =?utf-8?B?d3Y3NkJ0eTJBWi9PZitpYVgyYXU0VnRTWDgvTnpZWDc0eThRZ2svRXhmVHQy?=
 =?utf-8?B?TlVQK0Q5N3Iwb0NRdGJOTXVSK29kTnVWenNpVzQxNjdPN3JoSWJuWmpna29i?=
 =?utf-8?B?a0MrQzJKbzY1ZnVDNDdHK3BzSUh6ZG1mUUxIS2FZQjcwM0NUT1RYc2VGRVVG?=
 =?utf-8?B?b3hOVGcwMXBpRW9NZm9hMThiTDZ2alJpNS9vUndqSEJBWWQ5bWFJaDF4RCtE?=
 =?utf-8?B?Ymp0Y1pta2tQdThibzFLbHRQQjJlVTRaZjYybnBvMHdKZDhQbVV2U1ZYaEs2?=
 =?utf-8?B?NFlKT0NDMVZvWk5jcnVTYkQwOFZpZ2M5RUVCWnBhS1drTGxnMEQzaTJGSmQ3?=
 =?utf-8?B?MW9nckMyN0tjRHNaWlQ5bmplQkw3bUV2cmw2WFgwYWdiY0lVWkE2RjNzdDJK?=
 =?utf-8?B?eE4vSjdMSjBiQ1Q4YnZPeStHQzZRZEZQWFhGRzRDckQ4czlYY3NYNEhjOVdO?=
 =?utf-8?B?NGt1LzNjT2hkUkF2VDRJSjBJRUpwNmhzNGhEOFE0R1NEbEV2bGpwWlNBMDJ3?=
 =?utf-8?B?RWpxRHVZdkRDMitlTDErSlJmdlhhRjN1TTJKNFZURFJ2elZET1NBc2tHTDFY?=
 =?utf-8?B?eEVveDZPdU4yeFJIcjdhNUMvdlFWRkhib1k3YVVHOTY5cFVYYWE2Y3QvTW15?=
 =?utf-8?B?NlJCbFc4K3R6Nlk4ditSRDErYTl4U3doVUQwamdxaThvTzlZbFB0VFJtaWwy?=
 =?utf-8?B?enEyRURYY3JpbmJjTlNzSVZNSkFUekkrOTdFMzFSYXhPaHlmM1FrbVJRYVdK?=
 =?utf-8?B?WmFqMmRydEFQM1djY2dDN2pIdnJxeGh2aENQVkwxODRPQUlDd3FFU3FXK21P?=
 =?utf-8?B?Qm1NV3VCek1KZCs4bzdQQlhPTTJrbzV5SVgvbm9nZFk1SVBnNzJQVCtTa0Fk?=
 =?utf-8?B?MU9ZWHdGdXl0SFpFMkEwam85U29tb2lNUm1Yem1pWEIwQkhoSC9VYnRYQUZq?=
 =?utf-8?B?Y1lJN1AzNkt4aGhaU2Vjb0lOVzYzRWRwZTE2am5HN0dBN25tekxiMysxUjdR?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1BF7F456BF1074C97E3BF00DB61B952@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2d6e0a-bffb-47f5-01b2-08dde66f587f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 20:13:25.6742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a9NkR937j1rfr5A1dblysA8xKvP4ZOrCTW2jPq+fwUJG/kYSR5ermGlwEJD6beGLuqAWT8nE25sfLbo9CZci+SqbF5jQe1B5txHUd56SsTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7602
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDEyOjIxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBHZW5lcmFsbHkgc3BlYWtpbmcsIHRoZSBudW1iZXIgb2YgS1ZNX0JVR19PTigpcyBp
cyBmaW5lLsKgIFdoYXQgd2UgY2FuIGRvIHRob3VnaA0KPiBpcyByZWR1Y2UgdGhlIGFtb3VudCBv
ZiBib2lsZXJwbGF0ZSBhbmQgdGhlIG51bWJlciBvZiBwYXRocyB0aGUgcHJvcGFnYXRlIGEgU0VB
TUNBTEwNCj4gZXJyIHRocm91Z2ggbXVsdGlwbGUgbGF5ZXJzLCBlLmcuIGJ5IGVsaW1pbmF0aW5n
IHNpbmdsZS11c2UgaGVscGVycyAod2hpY2ggaXMgbWFkZQ0KPiBlYXNpZXIgYnkgcmVkdWNpbmcg
Ym9pbGVycGxhdGUgYW5kIHRodXMgbGluZXMgb2YgY29kZSkuDQo+IA0KPiBDb25jcmV0ZWx5LCBp
ZiB3ZSBjb21iaW5lIHRoZSBLVk1fQlVHX09OKCkgdXNhZ2Ugd2l0aCBwcl90ZHhfZXJyb3IoKToN
Cj4gDQo+ICNkZWZpbmUgX19URFhfQlVHX09OKF9fZXJyLCBfX2ZuX3N0ciwgX19rdm0sIF9fZm10
LCBfX2FyZ3MuLi4pCQkJXA0KPiAoewkJCQkJCQkJCQlcDQo+IAlzdHJ1Y3Qga3ZtICpfa3ZtID0g
KF9fa3ZtKTsJCQkJCQlcDQo+IAlib29sIF9fcmV0ID0gISEoX19lcnIpOwkJCQkJCQlcDQo+IAkJ
CQkJCQkJCQlcDQo+IAlpZiAoV0FSTl9PTl9PTkNFKF9fcmV0ICYmICghX2t2bSB8fCAhX2t2bS0+
dm1fYnVnZ2VkKSkpIHsJCVwNCj4gCQlpZiAoX2t2bSkJCQkJCQkJXA0KPiAJCQlrdm1fdm1fYnVn
Z2VkKF9rdm0pOwkJCQkJXA0KPiAJCXByX2Vycl9yYXRlbGltaXRlZCgiU0VBTUNBTEwgIiBfX2Zu
X3N0ciAiIGZhaWxlZDogMHglbGx4IglcDQo+IAkJCQnCoMKgIF9fZm10ICJcbiIswqAgX19lcnIs
wqAgX19hcmdzKTvCoAkJXA0KPiAJfQkJCQkJCQkJCVwNCj4gCXVubGlrZWx5KF9fcmV0KTsJCQkJ
CQkJXA0KPiB9KQ0KPiANCj4gI2RlZmluZSBURFhfQlVHX09OKF9fZXJyLCBfX2ZuLCBfX2t2bSkJ
CQkJXA0KPiAJX19URFhfQlVHX09OKF9fZXJyLCAjX19mbiwgX19rdm0sICIlcyIsICIiKQ0KPiAN
Cj4gI2RlZmluZSBURFhfQlVHX09OXzEoX19lcnIsIF9fZm4sIF9fcmN4LCBfX2t2bSkJCQlcDQo+
IAlfX1REWF9CVUdfT04oX19lcnIsICNfX2ZuLCBfX2t2bSwgIiwgcmN4IDB4JWxseCIsIF9fcmN4
KQ0KPiANCj4gI2RlZmluZSBURFhfQlVHX09OXzIoX19lcnIsIF9fZm4sIF9fcmN4LCBfX3JkeCwg
X19rdm0pCQlcDQo+IAlfX1REWF9CVUdfT04oX19lcnIsICNfX2ZuLCBfX2t2bSwgIiwgcmN4IDB4
JWxseCwgcmR4IDB4JWxseCIsIF9fcmN4LCBfX3JkeCkNCj4gDQo+ICNkZWZpbmUgVERYX0JVR19P
Tl8zKF9fZXJyLCBfX2ZuLCBfX3JjeCwgX19yZHgsIF9fcjgsIF9fa3ZtKQlcDQo+IAlfX1REWF9C
VUdfT04oX19lcnIsICNfX2ZuLCBfX2t2bSwgIiwgcmN4IDB4JWxseCwgcmR4IDB4JWxseCwgcjgg
MHglbGx4IiwgX19yY3gsIF9fcmR4LCBfX3I4KQ0KDQpJbiBnZW5lcmFsIHNvdW5kcyBnb29kLiBC
dXQgdGhlcmUgaXQncyBhIGJpdCBzdHJhbmdlIHRvIHNwZWNpZnkgdGhlbSByY3gsIHJkeCwNCmV0
YyBpbiBhIGdlbmVyYWwgaGVscGVyLiBUaGlzIGlzIGZhbGxvdXQgZnJvbSB0aGUgZXhpc3Rpbmcg
Y2hhaW4gb2Ygc3RyYW5nZQ0KbmFtaW5nOg0KDQpGb3IgZXhhbXBsZSB0ZGhfbWVtX3JhbmdlX2Js
b2NrKCkgcGx1Y2tzIHRoZW0gZnJvbSB0aG9zZSByZWdpc3RlcnMgYW5kIGNhbGxzDQp0aGVtIGV4
dF9lcnIxIGR1ZSB0byB0aGVpciBjb25kaXRpb25hbCBtZWFuaW5nLiBUaGVuIEtWTSBnaXZlcyB0
aGVtIHNvbWUgbW9yZQ0KbWVhbmluZyB3aXRoICdlbnRyeScgYW5kICdsZXZlbF9zdGF0ZSIuIFRo
ZW4gcHJpbnRzIHRoZW0gb3V0IGFzIG9yaWdpbmFsDQpyZWdpc3RlciBuYW1lcy4gSG93IGFib3V0
IGtlZXBpbmcgdGhlIEtWTSBuYW1lcywgbGlrZToNCg0KI2RlZmluZSBURFhfQlVHX09OXzIoX19l
cnIsIF9fZm4sIGFyZzEsIGFyZzIsIF9fa3ZtKQkJXA0KCV9fVERYX0JVR19PTihfX2VyciwgI19f
Zm4sIF9fa3ZtLCAiLCAiICNhcmcxICIgMHglbGx4LCAiICNhcmcyICINCjB4JWxseCIsIGFyZzEs
IGFyZzIpDQoNCnNvIHlvdSBnZXQ6IGVudHJ5OiAweDAwIGxldmVsOjB4RjAwDQoNCkkgKnRoaW5r
KiB0aGVyZSBpcyBhIHdheSB0byBtYWtlIHRoaXMgd29yayBsaWtlIHZhciBhcmdzIGFuZCBoYXZl
IGEgc2luZ2xlDQpmdW5jdGlvbiwgYnV0IGl0IGJlY29tZXMgaW1wb3NzaWJsZSBmb3IgcGVvcGxl
IHRvIHJlYWQuDQoNCg0KPiANCj4gDQo+IEFuZCBhIG1hY3JvIHRvIGhhbmRsZSByZXRyeSB3aGVu
IGtpY2tpbmcgdkNQVXMgb3V0IG9mIHRoZSBndWVzdDoNCj4gDQo+ICNkZWZpbmUgdGRoX2RvX25v
X3ZjcHVzKHRkaF9mdW5jLCBrdm0sIGFyZ3MuLi4pCQkJCQlcDQo+ICh7CQkJCQkJCQkJCVwNCj4g
CXN0cnVjdCBrdm1fdGR4ICpfX2t2bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7CQkJCVwNCj4gCXU2
NCBfX2VycjsJCQkJCQkJCVwNCj4gCQkJCQkJCQkJCVwNCj4gCWxvY2tkZXBfYXNzZXJ0X2hlbGRf
d3JpdGUoJmt2bS0+bW11X2xvY2spOwkJCQlcDQoNClRoZXJlIGlzIGEgZnVuY3Rpb25hbCBjaGFu
Z2UgaW4gdGhhdCB0aGUgbG9jayBhc3NlcnQgaXMgbm90IHJlcXVpcmVkIGlmIEJVU1kNCmF2b2lk
YW5jZSBjYW4gYmUgZ3VhcmFudGVlZCB0byBub3QgaGFwcGVuLiBJIGRvbid0IHRoaW5rIGl0IHNo
b3VsZCBiZSBuZWVkZWQNCnRvZGF5LiBJIGd1ZXNzIGl0J3MgcHJvYmFibHkgYmV0dGVyIHRvIG5v
dCByZWx5IG9uIGhpdHRpbmcgcmFyZSByYWNlcyB0byBjYXRjaA0KYW4gaXNzdWUgbGlrZSB0aGF0
Lg0KDQo+IAkJCQkJCQkJCQlcDQo+IAlfX2VyciA9IHRkaF9mdW5jKGFyZ3MpOwkJCQkJCQlcDQo+
IAlpZiAodW5saWtlbHkodGR4X29wZXJhbmRfYnVzeShfX2VycikpKSB7CQkJCVwNCj4gCQlXUklU
RV9PTkNFKF9fa3ZtX3RkeC0+d2FpdF9mb3Jfc2VwdF96YXAsIHRydWUpOwkJCVwNCj4gCQlrdm1f
bWFrZV9hbGxfY3B1c19yZXF1ZXN0KGt2bSwgS1ZNX1JFUV9PVVRTSURFX0dVRVNUX01PREUpOwlc
DQo+IAkJCQkJCQkJCQlcDQo+IAkJX19lcnIgPSB0ZGhfZnVuYyhhcmdzKTsJCQkJCQlcDQo+IAkJ
CQkJCQkJCQlcDQo+IAkJV1JJVEVfT05DRShfX2t2bV90ZHgtPndhaXRfZm9yX3NlcHRfemFwLCBm
YWxzZSk7CQlcDQo+IAl9CQkJCQkJCQkJXA0KPiAJX19lcnI7CQkJCQkJCQkJXA0KPiB9KQ0KPiAN
Cj4gQW5kIGRvIGEgYml0IG9mIG1hc3NhZ2luZywgdGhlbiB3ZSBjYW4gZW5kIHVwIGUuZy4gdGhp
cywgd2hpY2ggSU1PIGlzIG11Y2ggZWFzaWVyDQo+IHRvIGZvbGxvdyB0aGFuIHRoZSBjdXJyZW50
IGZvcm0gb2YgdGR4X3NlcHRfcmVtb3ZlX3ByaXZhdGVfc3B0ZSgpLCB3aGljaCBoYXMNCj4gc2V2
ZXJhbCBkdXBsaWNhdGUgc2FuaXR5IGNoZWNrcyBhbmQgZXJyb3IgaGFuZGxlcnMuDQo+IA0KPiBU
aGUgdGRoX2RvX25vX3ZjcHVzKCkgbWFjcm8gaXMgYSBsaXR0bGUgbWVhbiwgYnV0IEkgdGhpbmsg
aXQncyBhIG5ldCBwb3NpdGl2ZQ0KPiBhcyBlbGltaW5hdGVzIHF1aXRlIGEgbG90IG9mICJub2lz
ZSIsIGFuZCB0aHVzIG1ha2VzIGl0IGVhc2llciB0byBmb2N1cyBvbiB0aGUNCj4gbG9naWMuwqAg
QW5kIGFsdGVybmF0aXZlIHRvIGEgdHJhbXBvbGluZSBtYWNybyB3b3VsZCBiZSB0byBpbXBsZW1l
bnQgYSBndWFyZCgpDQo+IGFuZCB0aGVuIGRvIGEgc2NvcGVkX2d1YXJkKCksIGJ1dCBJIHRoaW5r
IHRoYXQnZCBiZSBqdXN0IGFzIGhhcmQgdG8gcmVhZCwgYW5kDQo+IHdvdWxkIHJlcXVpcmUgYWxt
b3N0IGFzIG11Y2ggYm9pbGVycGxhdGUgYXMgdGhlcmUgaXMgdG9kYXkuDQo+IA0KPiBzdGF0aWMg
dm9pZCB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3Qg
Z2ZuLA0KPiAJCQkJCSBlbnVtIHBnX2xldmVsIGxldmVsLCB1NjQgc3B0ZSkNCj4gew0KPiAJc3Ry
dWN0IHBhZ2UgKnBhZ2UgPSBwZm5fdG9fcGFnZShzcHRlX3RvX3BmbihzcHRlKSk7DQo+IAlpbnQg
dGR4X2xldmVsID0gcGdfbGV2ZWxfdG9fdGR4X3NlcHRfbGV2ZWwobGV2ZWwpOw0KPiAJc3RydWN0
IGt2bV90ZHggKmt2bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+IAlncGFfdCBncGEgPSBnZm5f
dG9fZ3BhKGdmbik7DQo+IAl1NjQgZXJyLCBlbnRyeSwgbGV2ZWxfc3RhdGU7DQo+IA0KPiAJLyoN
Cj4gCSAqIEhLSUQgaXMgcmVsZWFzZWQgYWZ0ZXIgYWxsIHByaXZhdGUgcGFnZXMgaGF2ZSBiZWVu
IHJlbW92ZWQsIGFuZCBzZXQNCj4gCSAqIGJlZm9yZSBhbnkgbWlnaHQgYmUgcG9wdWxhdGVkLiBX
YXJuIGlmIHphcHBpbmcgaXMgYXR0ZW1wdGVkIHdoZW4NCj4gCSAqIHRoZXJlIGNhbid0IGJlIGFu
eXRoaW5nIHBvcHVsYXRlZCBpbiB0aGUgcHJpdmF0ZSBFUFQuDQo+IAkgKi8NCj4gCWlmIChLVk1f
QlVHX09OKCFpc19oa2lkX2Fzc2lnbmVkKHRvX2t2bV90ZHgoa3ZtKSksIGt2bSkpDQo+IAkJcmV0
dXJuOw0KPiANCj4gCS8qIFRPRE86IGhhbmRsZSBsYXJnZSBwYWdlcy4gKi8NCj4gCWlmIChLVk1f
QlVHX09OKGxldmVsICE9IFBHX0xFVkVMXzRLLCBrdm0pKQ0KPiAJCXJldHVybjsNCj4gDQo+IAll
cnIgPSB0ZGhfZG9fbm9fdmNwdXModGRoX21lbV9yYW5nZV9ibG9jaywga3ZtLCAma3ZtX3RkeC0+
dGQsIGdwYSwNCj4gCQkJwqDCoMKgwqDCoCB0ZHhfbGV2ZWwsICZlbnRyeSwgJmxldmVsX3N0YXRl
KTsNCj4gCWlmIChURFhfQlVHX09OXzIoZXJyLCBUREhfTUVNX1JBTkdFX0JMT0NLLCBlbnRyeSwg
bGV2ZWxfc3RhdGUsIGt2bSkpDQo+IAkJcmV0dXJuOw0KPiANCj4gCS8qDQo+IAkgKiBURFggcmVx
dWlyZXMgVExCIHRyYWNraW5nIGJlZm9yZSBkcm9wcGluZyBwcml2YXRlIHBhZ2UuwqAgRG8NCj4g
CSAqIGl0IGhlcmUsIGFsdGhvdWdoIGl0IGlzIGFsc28gZG9uZSBsYXRlci4NCj4gCSAqLw0KPiAJ
dGR4X3RyYWNrKGt2bSk7DQo+IA0KPiAJLyoNCj4gCSAqIFdoZW4gemFwcGluZyBwcml2YXRlIHBh
Z2UsIHdyaXRlIGxvY2sgaXMgaGVsZC4gU28gbm8gcmFjZSBjb25kaXRpb24NCj4gCSAqIHdpdGgg
b3RoZXIgdmNwdSBzZXB0IG9wZXJhdGlvbi4NCj4gCSAqIFJhY2Ugd2l0aCBUREguVlAuRU5URVIg
ZHVlIHRvICgwLXN0ZXAgbWl0aWdhdGlvbikgYW5kIEd1ZXN0IFREQ0FMTHMuDQo+IAkgKi8NCj4g
CWVyciA9IHRkaF9kb19ub192Y3B1cyh0ZGhfbWVtX3BhZ2VfcmVtb3ZlLCBrdm0sICZrdm1fdGR4
LT50ZCwgZ3BhLA0KPiAJCQnCoMKgwqDCoMKgIHRkeF9sZXZlbCwgJmVudHJ5LCAmbGV2ZWxfc3Rh
dGUpOw0KPiAJaWYgKFREWF9CVUdfT05fMihlcnIsIFRESF9NRU1fUEFHRV9SRU1PVkUsIGVudHJ5
LCBsZXZlbF9zdGF0ZSwga3ZtKSkNCj4gCQlyZXR1cm47DQo+IA0KPiAJZXJyID0gdGRoX3BoeW1l
bV9wYWdlX3diaW52ZF9oa2lkKCh1MTYpa3ZtX3RkeC0+aGtpZCwgcGFnZSk7DQo+IAlpZiAoVERY
X0JVR19PTihlcnIsIFRESF9QSFlNRU1fUEFHRV9XQklOVkQsIGt2bSkpDQo+IAkJcmV0dXJuOw0K
PiANCj4gCXRkeF9jbGVhcl9wYWdlKHBhZ2UpOw0KPiB9DQoNClNlZW1zIGxpa2UgdGFzdGVmdWwg
bWFjcm8taXphdGlvbiB0byBtZS4NCg0K

