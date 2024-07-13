Return-Path: <kvm+bounces-21590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8861C930305
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 03:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A188B1C215FD
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C243101E6;
	Sat, 13 Jul 2024 01:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nPOnDYOV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D427FC13C;
	Sat, 13 Jul 2024 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720834120; cv=fail; b=fSU3o+n4UcmkRom5cZpW1J2Mozvo8bganpQIbHl/TRj71q2z+w89pnm71NT9s4Zx6oW4QyDFzCkRDg+u0uTkxOcQwNo+IFerJjwAbPlCkPqCf68bJ/Df5xfThgBfbz8R0kVVzaY4nYfzLLvIyOk1PJl01fTDGXuSRUN6gDYWby8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720834120; c=relaxed/simple;
	bh=6zxkuQHZvf31LTqoeqesZKX/v0AeaOgOuctb++pST3s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YWpcDS12h7XLYsHaQT3PRGdQ//3o9CrAaLxA6jd3W8ysj+VUvFXwzbTzLtONwHOTawH/TM//5zAlOlEoSLMr3rpTRNk/QLm4j16sn4KmuAgWE8BWFWDblzv75sMDZeVwbP4KximOgbzBkddn2aNYIYFW1Q1sEDUmNwvhDV+lDQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nPOnDYOV; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720834119; x=1752370119;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6zxkuQHZvf31LTqoeqesZKX/v0AeaOgOuctb++pST3s=;
  b=nPOnDYOVmfNYMZalJhbjc4FABIum2yJuTM6UQex2Bij9m4WivjmD8l2K
   ZKcSy8eIHk/Ys9YQdBSAujIoAKHDpR5lwkPIcYkgsR2u9DJXIsf8wbAPQ
   oUxZ5OHppeUI1mXGW9FvBMvl0k2y8jd95rdxfKjpWJf4HiwwYdCElxVQI
   5tdQ3NSm2Vlddtwwuxy++olh31eINVxS5HUUgbVsaJgatLjO5xILoHMRC
   788iD3G1op8D3WtrRJ/IsXLWQg4VVPOO/wpmFKOrf8+fhKDTy9zIvs5oI
   eBfFKY3Zd/GwU0Wb9qfoSLevaIp2eTVsrFoy+W44h1gevma0oxpiLFmgz
   g==;
X-CSE-ConnectionGUID: 1hjPyYh4SuKkJ28TtGciUQ==
X-CSE-MsgGUID: eBNYQn8eSAmjETagUUDMNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11131"; a="18138368"
X-IronPort-AV: E=Sophos;i="6.09,204,1716274800"; 
   d="scan'208";a="18138368"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2024 18:28:38 -0700
X-CSE-ConnectionGUID: eHzhq0E9SjukSOWyCy5HRA==
X-CSE-MsgGUID: girPqNiiRkGg+COoao3w4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,204,1716274800"; 
   d="scan'208";a="80165195"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jul 2024 18:28:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 12 Jul 2024 18:28:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 12 Jul 2024 18:28:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 12 Jul 2024 18:28:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2STx88kowFUkC2CK3zcqxf1phbc5vVr3ObsgL6tYwj9kI+xYzKbtF2KYH84IqJv6/nsrA3vuoqXHby8BjSsu4dwzdAtcOYi8mmZWZ4xXJ4qXxhKSju+RpzyQQNiZduyhAz9XblMLxD1fYKbbuT8Xnl3whnmfQVl0e+Z9P1UG9NFsyT0G4KE4vl1RBzIdjvBsGD+A+MdqTkHqfI2EU5ayJBX+ebzMVJAs8lt3K1zr4f3XbBqFzPOZS/msW054RYxi/uUCMnBbDRIoqDEM0Brq99gnY9yGh+9fR9KwGgIT3dTWtvfgVS6LAFtFnh6YHeWZ6e8WGijj4Tu9tAdpkrvug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zxkuQHZvf31LTqoeqesZKX/v0AeaOgOuctb++pST3s=;
 b=wFe7tpLC/6t4eLVKaGayWbn7sOhW4ZqSXorMKgvehZ2xcChTGgjx+QlLH4d7vM6XZxJh5BVF/G7G6MDmJZIjZgi5wSZ+I5RgomgrN1zjCcAgc69GQbQQZjvXV/0Cf1abeH7oauIUVa/xlQLfEKYog25c74A2inYdhLhknRQVrP0m8RNewiZYibHpw+d8T9bCvp0uMW9rbOamxnvqZdx7B03VCV8uYhTL5G0TlyzhNd38/4ZtUZMfBxnbfdaPQhJijocS6TGdtandwnm70F6dVX1etNQG7Q5hzm+SHEw33sqCqWp3wb0PqepvpSv+ay6DVkx745LO+/flTyf1yC6HMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB7086.namprd11.prod.outlook.com (2603:10b6:806:2b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.34; Sat, 13 Jul
 2024 01:28:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7762.020; Sat, 13 Jul 2024
 01:28:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Thread-Topic: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Thread-Index: AQHa1MP6tknHBB/QAEixGUJsVbkOOA==
Date: Sat, 13 Jul 2024 01:28:34 +0000
Message-ID: <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
	 <20240711222755.57476-10-pbonzini@redhat.com>
In-Reply-To: <20240711222755.57476-10-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB7086:EE_
x-ms-office365-filtering-correlation-id: ad878f46-3bb4-4b21-db15-08dca2db1d0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TnlIbGVJRjVrVVhCTnZSSzl0V25penBHQWZOVDREUEY4STZuV0tLUnFnY01y?=
 =?utf-8?B?VHVhMjhyZnVRRWcwVkJmb0dSK2o5bXRXb00ydUw3aW9waGlMV3B6d3hGUEJt?=
 =?utf-8?B?ZjByR0pXWDFtQmZ0bUdXNjFIY2lTbEg5b3M5Nm9jdUdFMDAzVU1NRHZWcDRG?=
 =?utf-8?B?ZmwrYW1tTE9XcjVUU0Q4dEE2eXFaZTlhZHBTWVJnaHR1TU5YaVBhSmFKS1RE?=
 =?utf-8?B?UGlOSnlXNGdkaTR0RkpJaTlQSk9XbFNsU1pvR0tXZzBMLzBhR1dFNHE2alMz?=
 =?utf-8?B?TGdkaUJ3K3VrVkZFeUdLYnBqTEJHR1VIOEJkeDdpQ0tWdmpQcWhmOW8rdXZO?=
 =?utf-8?B?WU5xTldWb0NPdmRGeXlWd05GUVhVU1pXbG5ESGdGWnFGWDFVTFF1OHo3ZVEz?=
 =?utf-8?B?RjkzNUVETU93TS9rV0duSTZHM2hCckF2T2daYUtlODRiUjd3VDU2QjE5aXpH?=
 =?utf-8?B?eFBacUZmTTFVY25zclA2WkQ3R0ZRd3NrMWI5K21tek5yQXlZUEhEb25TT0Jh?=
 =?utf-8?B?bEp2YTMvaDl4WFZvNVJwK2dLOEFQTm42N1VtWVNTVEUza3YvRDBnZHhOeTA0?=
 =?utf-8?B?SDVWWjJCaE9BSGdUSFJFcGw1M3Z5SG53Z3RMNkcrM0o0VWZjK0ZZM21MREht?=
 =?utf-8?B?b0hHZVJFeUhBMCt4aHBwTHpvdHc2cVpPc0lYclJZTE5WcEwwRHk3bkt0QmdZ?=
 =?utf-8?B?QmVYTFlIaFdHMm9NK2x4ZE1rVXlPMFlkTGkxMFBIQ1ozVi95b2ZJOXJQTENX?=
 =?utf-8?B?RFFYc0dXLzBLOGsyUGNMN0NMbExWRTlCOHdOV0FOajBuZkpuc2JjTGltc2NN?=
 =?utf-8?B?UzArTDJuc2duNFR1VnpodW11Y3c4Rm95eTBvbzVJNGlZSm1pU3MwL2l6UW05?=
 =?utf-8?B?bjliTGl6T2dmY29PU1U5eVBwaXlRRU1YNmhMc0ZySGJUL1pwc1BFak1xYmNF?=
 =?utf-8?B?akthNTVXZU8yaXRaMktmY2wzYmFsOThQcXNYRDErNmFMM29yOHdVbDBDSXVP?=
 =?utf-8?B?SUpzRWZ1andRUGlXc3I3OG1NSUJLTkdFVlUvdnR4Ry9JcjZtdVNIQzc0Y2tp?=
 =?utf-8?B?N1pPU3V5SGxJSHpOR3ZQYUN5TlAzdjREbVQ4ZzMrWXB1OG1LeUp4Q2xaenJk?=
 =?utf-8?B?YUltUWJ1NmhQTFJxZ3h0TXJmU1JCTlIvRWRYUEVNaEZwNkZiNVhTaE44WHpX?=
 =?utf-8?B?ZGhJd2YrL0FYQWVzRC9XYXRyUWQ3OVJQZ0kvMTJsRTBlTmdEaUJoSVZiUFVO?=
 =?utf-8?B?blZBcEZrVDNIZGdvek5FdmppaDVXL2ZhbE9Sdkd2L2N2NnNoUVMrN0I0bDhP?=
 =?utf-8?B?aTM2S1FvaGh0TWc2ZXhMT1lZRGRBRDg3NDR1TUdIRlNGWklGK2NjRXhOSlBW?=
 =?utf-8?B?N2N2M0NEd2dURW1uWURvUmxlTE5OelIvVFRJR2hkdVJ4cHJHZW8ybTR5aHVF?=
 =?utf-8?B?MFlpVHZVUGNHMXNnZ3NuUjVIVDlZSDJta05vT1JrUll0UStXSkRCa0VsV2xa?=
 =?utf-8?B?N3BJcVlOOU90L3VUTWF1WkJ0UXpTbnFYVUVDNkE4TzNJTktlRXYrazNlQ3dN?=
 =?utf-8?B?b0RQMUpndytwRWpwMng3UFkwSzIrczMzWE9CY2UxUkpIS1AzT0poaDYwRE1G?=
 =?utf-8?B?RTd3akVxM2Q0ODZIV1pqRkxKdUVwYjNSYWlaK0doR21mU3BSTE9oSnRLbktQ?=
 =?utf-8?B?NFRnZGxxSVEyTUdLNDBsQ01BK2tDYTBFMEEyUjhQM2VxSTdCWGIwMUY1NjI0?=
 =?utf-8?B?NzJHczZQVWppTnYvdkdJM3kxbUt3MFowTnU5NFJnRHMxKzlDN3NwT1FFRWk5?=
 =?utf-8?B?eDVzMDFvSlU3eHkwOERPVXkyb0Q3N25oZ2dMMHEwRjlJRlNNOTIzczFkbEx2?=
 =?utf-8?B?ZFJ2RXFHZnhRSWIySVgyaGU3bHdQbll2RCt5ZmswTDgxZVE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yno5cXVFQ2JuRU1DeXlFalVYVFdKVENtVXgzckdCRFd5eHRaaXRlWk81Q1Bz?=
 =?utf-8?B?c0NsWVo3NmE3SVVEbERhQ2ZXYm1HWlU5QUpET0JtSEZuQXZ6QUxCNGFUOEtM?=
 =?utf-8?B?WGJhbXhUMEVTODI0OGFlOVVPYnB6UzJkM1MxejF0V3dUenJKVUVkWmFKUGJH?=
 =?utf-8?B?TWR5Mlp1REhiTU9rVjEvL0tzOXQ3bXFSUXFGZFV1WTlqNnp4THBJcFJUV3Ru?=
 =?utf-8?B?ZGRNY0JPNlcyd2FwMFNTdlREcUREdlZjWVF4MkkreUwyWExNTm9RcjVrYmls?=
 =?utf-8?B?UEtNem5rZ0YwcGZzQU9UWE1rSVV3T1REY1VlSUZyWGpyd0tGYXg0blF3MGxr?=
 =?utf-8?B?ZXI0dEhCWFdndkVRNVYxaHVyL1RXazBLa2drbnkzVndvdkNNZU1SeDdiUFZN?=
 =?utf-8?B?WDZNZG5vclVKZWVYMjh3VmZVNkFvUzBuNjFPT0pSOU9TeS85TDFDRHJJNlhq?=
 =?utf-8?B?K2FJMW01Nm5OUi9HeFlLQVk2N3JpMVhZbDdQS3RaNkZsRERWRm9uTzRydEta?=
 =?utf-8?B?SnZhNUVMY3ZYb2Qvam4wR1NlWGh0cEw0ckNlVUp4Y2czN1dBTGtYQXR6cFJm?=
 =?utf-8?B?YW4rbjNBcEUrb0pUTUVFZ2pYbW5FOWhKM3l3eTJMaitBVkdCR1NPTzkzaTdk?=
 =?utf-8?B?ZllVb3VXQlE0SHZndTR1OXc5V2VJWTdqMUVaMW9uTU5iSXZJTjU2eCtvY1lw?=
 =?utf-8?B?VXFxUmdzYndQZE9qY2ZaYzBWZjM3ZGtyU0J3WEpDaW5oWEsxR05YejIxTXpy?=
 =?utf-8?B?Rk5PZFVrbmkyY2hPZkY2Qml0K3RnV2UvenRVM2FseUxLTk41ZFVJdjd1U0VB?=
 =?utf-8?B?dHVwSEhVUmIvU1NCdC8yR1BSV2tlVWp5NVUzQ3hWb05JRHl0aHpGTWZmcTRa?=
 =?utf-8?B?WEZKU3ZESWhmalg5Z3g2OXQzSDhGOHl0Y21QY1c1YzhhM0lIa0FOYVNnL2c5?=
 =?utf-8?B?aUUwd0syWFhNc0lwaDIyY2o3bC9OS1JqM3YwQW83WnBhM0tBdURSeXY0a1lW?=
 =?utf-8?B?NkR3VUVhbmF1SzFSczBKSnhBakdMdDlNZ1o2cFpiUnMwS1IzellRdWY1MVY2?=
 =?utf-8?B?TDh2OEo4cFhYVzFSWEV4NzQvNytyL1BjdGU0Y1Y3d3Vwait5OVVsUjByT084?=
 =?utf-8?B?MzZrWFJ2RVRoZlUzUXFMQkVPbkNOMTkzQ04vU21lRlg3VEh1bGNMOXdPYnFB?=
 =?utf-8?B?aWk2NkFKZllpSEFVT1FndXRPOENpcGNsd2hVNWZQRS9maFlnTzlnQXBlZ1Ni?=
 =?utf-8?B?TnNTYlJCRjhFaEVVN29Bbm1YTXQxSTg1eVdOMitkdkowL1dhKzkrVW1RakpJ?=
 =?utf-8?B?Z1BidEJ3Vk5Uc05YSHIrdFpsdGZHTEliQ003b1ZKYjZqMStiMHRPejh6d2pK?=
 =?utf-8?B?S0F2Q2s1NUtublVtbE4xNE9WU05LUnhPUm01Z2ViK2RMdW1FemgxV08rMWtZ?=
 =?utf-8?B?MGxTTHlEeXdkQmpNdDF4ZmwybjVWalZldUZtckV1Q3NtaGc3dHB5b2dHZGsr?=
 =?utf-8?B?ank2L2RtNURkT2NJWFVYQ1orNUtQSE9hVmhvUnQzNFBSSFVrSXdnM0wwT0lo?=
 =?utf-8?B?NW9qZ3JSYy96VjR3TWk4d2lQUXpNWUdXb0k4YzRUZjlpWURTQ0Y3R0FJRDZM?=
 =?utf-8?B?YWtFNVVJckZ3MUFKSFRDc1dVd0tlc0Fua0xQcjk2a01tMmhuL2lmYmtwdHJW?=
 =?utf-8?B?RDhOdzdhOHpiZjJMZlFnYVBNaWlWZUQ2N0NUUXVIZU1NcE9HbStFSVBqNDFl?=
 =?utf-8?B?RjlMYk11aG9BQmF4cjkrMDRpRDJDN2dWdGJlUVFoMjFMMGZsR0xGYzF1R1Bz?=
 =?utf-8?B?NzYrc2p2NU9CVnJ5cmtsYkRjdHVhVCtMVnp3emM4VU9zcS9wVWY2UEd0enNI?=
 =?utf-8?B?a0xSQ21ScUZpWXFzMFJzV0FvSnFPSWlWOWVCeVZDVkliWkIycDRGcWptcnJw?=
 =?utf-8?B?cFRYTFJxTGkzN21kRFJvSE1XYmhac3MxN0NSOVFQMXBVNHE2M3NpblQyVSth?=
 =?utf-8?B?SHJrN0xhYVRrdDAyenBFNnZLZjEvOEdBV0UyUGVyZTMrNDJyWkNPNlpJVitP?=
 =?utf-8?B?dmlYd2U0bEVJUnFXM0VpNGJibi9pUVkxZUZoNjRxNlBhVUNmcTBvV29zTUpl?=
 =?utf-8?B?eTlFdzkxYnpPbEE0L0dJZGRpV2kyalVIK29QMkdsQlgwdFhkVHZCUXlqZ3Vt?=
 =?utf-8?Q?q83KPJDygoqJ726sTnRFycY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0A3576B6289FE4796DE78E94C3FEEB0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad878f46-3bb4-4b21-db15-08dca2db1d0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2024 01:28:34.8541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lZGenZjdEubFI7wEabJs9LRG1zXdiBpYd9iKbDiIUEhNPgXVh60UevdmNm/oxpzmY3o9JQeOipRwvVg8n1g8mKjFHKoTNDqngoyhEYxLuwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7086
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA3LTExIGF0IDE4OjI3IC0wNDAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBEbyBub3QgYWxsb3cgcG9wdWxhdGluZyB0aGUgc2FtZSBwYWdlIHR3aWNlIHdpdGggc3RhcnR1
cCBkYXRhLsKgIEluIHRoZQ0KPiBjYXNlIG9mIFNFVi1TTlAsIGZvciBleGFtcGxlLCB0aGUgZmly
bXdhcmUgZG9lcyBub3QgYWxsb3cgaXQgYW55d2F5LA0KPiBzaW5jZSB0aGUgbGF1bmNoLXVwZGF0
ZSBvcGVyYXRpb24gaXMgb25seSBwb3NzaWJsZSBvbiBwYWdlcyB0aGF0IGFyZQ0KPiBzdGlsbCBz
aGFyZWQgaW4gdGhlIFJNUC4NCj4gDQo+IEV2ZW4gaWYgaXQgd29ya2VkLCBrdm1fZ21lbV9wb3B1
bGF0ZSgpJ3MgY2FsbGJhY2sgaXMgbWVhbnQgdG8gaGF2ZSBzaWRlDQo+IGVmZmVjdHMgc3VjaCBh
cyB1cGRhdGluZyBsYXVuY2ggbWVhc3VyZW1lbnRzLCBhbmQgdXBkYXRpbmcgdGhlIHNhbWUNCj4g
cGFnZSB0d2ljZSBpcyB1bmxpa2VseSB0byBoYXZlIHRoZSBkZXNpcmVkIHJlc3VsdHMuDQo+IA0K
PiBSYWNlcyBiZXR3ZWVuIGNhbGxzIHRvIHRoZSBpb2N0bCBhcmUgbm90IHBvc3NpYmxlIGJlY2F1
c2Uga3ZtX2dtZW1fcG9wdWxhdGUoKQ0KPiBob2xkcyBzbG90c19sb2NrIGFuZCB0aGUgVk0gc2hv
dWxkIG5vdCBiZSBydW5uaW5nLsKgIEJ1dCBhZ2FpbiwgZXZlbiBpZg0KPiB0aGlzIHdvcmtlZCBv
biBvdGhlciBjb25maWRlbnRpYWwgY29tcHV0aW5nIHRlY2hub2xvZ3ksIGl0IGRvZXNuJ3QgbWF0
dGVyDQo+IHRvIGd1ZXN0X21lbWZkLmMgd2hldGhlciB0aGlzIGlzIGFuIGludGVudGlvbmFsIGF0
dGVtcHQgdG8gZG8gc29tZXRoaW5nDQo+IGZpc2h5LCBvciBtaXNzaW5nIHN5bmNocm9uaXphdGlv
biBpbiB1c2Vyc3BhY2UsIG9yIGV2ZW4gc29tZXRoaW5nDQo+IGludGVudGlvbmFsLsKgIE9uZSBv
ZiB0aGUgcmFjZXJzIHdpbnMsIGFuZCB0aGUgcGFnZSBpcyBpbml0aWFsaXplZCBieQ0KPiBlaXRo
ZXIga3ZtX2dtZW1fcHJlcGFyZV9mb2xpbygpIG9yIGt2bV9nbWVtX3BvcHVsYXRlKCkuDQo+IA0K
PiBBbnl3YXksIG91dCBvZiBwYXJhbm9pYSwgYWRqdXN0IHNldl9nbWVtX3Bvc3RfcG9wdWxhdGUo
KSBhbnl3YXkgdG8gdXNlDQo+IHRoZSBzYW1lIGVycm5vIHRoYXQga3ZtX2dtZW1fcG9wdWxhdGUo
KSBpcyB1c2luZy4NCg0KVGhpcyBwYXRjaCBicmVha3Mgb3VyIHJlYmFzZWQgVERYIGRldmVsb3Bt
ZW50IHRyZWUuIEZpcnN0DQprdm1fZ21lbV9wcmVwYXJlX2ZvbGlvKCkgaXMgY2FsbGVkIGR1cmlu
ZyB0aGUgS1ZNX1BSRV9GQVVMVF9NRU1PUlkgb3BlcmF0aW9uLA0KdGhlbiBuZXh0IGt2bV9nbWVt
X3BvcHVsYXRlKCkgaXMgY2FsbGVkIGR1cmluZyB0aGUgS1ZNX1REWF9JTklUX01FTV9SRUdJT04g
aW9jdGwNCnRvIGFjdHVhbGx5IHBvcHVsYXRlIHRoZSBtZW1vcnksIHdoaWNoIGhpdHMgdGhlIG5l
dyAtRUVYSVNUIGVycm9yIHBhdGguDQoNCkdpdmVuIHdlIGFyZSBub3QgYWN0dWFsbHkgcG9wdWxh
dGluZyBkdXJpbmcgS1ZNX1BSRV9GQVVMVF9NRU1PUlkgYW5kIHRyeSB0bw0KYXZvaWQgYm9vdGlu
ZyBhIFREIHVudGlsIHdlJ3ZlIGRvbmUgc28sIG1heWJlIHNldHRpbmcgZm9saW9fbWFya191cHRv
ZGF0ZSgpIGluDQprdm1fZ21lbV9wcmVwYXJlX2ZvbGlvKCkgaXMgbm90IGFwcHJvcHJpYXRlIGlu
IHRoYXQgY2FzZT8gQnV0IGl0IG1heSBub3QgYmUgZWFzeQ0KdG8gc2VwYXJhdGUuDQo=

