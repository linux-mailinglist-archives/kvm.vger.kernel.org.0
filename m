Return-Path: <kvm+bounces-32974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB969E30BC
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 02:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A74BB241A5
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4BABE4E;
	Wed,  4 Dec 2024 01:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W1By6ZcT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF004400;
	Wed,  4 Dec 2024 01:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733275468; cv=fail; b=X/M0sXgs3UEpQq7Rp0OUjNOwKLeNUgbQHr5mHIt+jENA9V23ivBgKWvBUpUBA6XYM7FZFhlDYEllXtoaA1rLVBhuIXNATiSzLIpEAqfm2cyQ9z7PyeZBtYyur0N5N3gIMuVxfBRjh1z4zKu7iB53sfq+q50VpEyZO91dkI6Syf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733275468; c=relaxed/simple;
	bh=p19by8cCGM2nOiM7Icd2q71KDmGMNs3tEnm3WKH7H8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T3E2bTi6+i+jUgCCnwJ1KxMp2uzuDnNRFUhRuTP9Q8aO5xnypCnjx1sXER14tnVDJmpbJzQ2FALnAOqerDWf9pJR0kkkyrUGvqtcoOmvz29ngO2TsSITGsCSIgmRk6T8wSvH4694kr1c8LHYTvzm/yVV+si3BQvpznbmLa8hZ40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W1By6ZcT; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733275467; x=1764811467;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p19by8cCGM2nOiM7Icd2q71KDmGMNs3tEnm3WKH7H8k=;
  b=W1By6ZcTOBZgOMxJ+KETuibvrOmOFCNJHp3QfT6KNI13lKStx6EICxXt
   m2SKmFVUVctOfNKjbZnBP6x58+F8EkuOkjhNWnIZ0DBQhqXlRkTRw7m2i
   SDrhNzqPBGxpq75jP861c5cVDgMcqujVs2dMpFNfob4dHlrW4SJ6pla2K
   Agb6UDt58NXw5QL9uhw4SfcDcgEOFV4qtHvxmSjQhuxOniOE+Sg5roJv7
   xbV2qF18RNgy/Ro18Gld4sgoJ8Y4DcgGesNwUrryvqAaUwiyqcc70X2D5
   4gGxlsWoC3NQqsAfPe+ctZTuMUz4swCQ2KRhTSvogM64f6rUiFLMfwCMN
   g==;
X-CSE-ConnectionGUID: LfO8qsp8QmScyQqq6RxT9Q==
X-CSE-MsgGUID: B3jldsFgQ5CahoBnihOOLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="50935818"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="50935818"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 17:24:26 -0800
X-CSE-ConnectionGUID: A6rSKgdKQ6i9acn/w3m4wA==
X-CSE-MsgGUID: RBwzEblPS3eSAU18vfWrsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="93272117"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 17:24:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 17:24:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 17:24:24 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 17:24:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=do/z4D1Bav8imDw351dzrTo53clXwhoNAoifYFeqYSYP9Zb9oNWFb7wQUmOY7HPcR5wfVnGax1jsuOrJrz/WN1gFVpQCpdncF8U8r2aaXEm4cxL+qgF3g9tuVWCh4ne8CxT/3nwWQYHgQcGt1/QG4KbwdSrnLKVCEKhxGIxtuXTwTptJC4LU3SEYHtCNNlEXYIduby2smarmJVnGcApKxsKsR+IYlwQye2gzL+ULUPkaLLscpPu7yMUolmhcGD9SQZ57pAPEHUDPeUE4HtNzVp42uYTbinpZRqm82yv6o/+Xl6QQTccb1L4PokjnLraNbr5YfKr5PJqCde81DG/HaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p19by8cCGM2nOiM7Icd2q71KDmGMNs3tEnm3WKH7H8k=;
 b=XD3tLfaAO+DHFQk0tinBEMLowIVK5rBzMWPSpalLMrWElJtSlozvvTp08+P+ivSe7iCbqC3BY2c42AstdBhGuNtT6fkaDJPSVomu94kj7r2Eyyv4ZhBPUNPQ9wPiqS8dVn9z4druzuO6842kusTgZhl3QWfFHV9Vey5rP1j1PDKEuN4CaIh8bi8qQqE9V/DjbTRTRJa7sxwXIzeUdXjrPnXRtoliDTEiQrjMhMyJHKb9QUmH+V9odeAzYOOk3P2Jg71GG+MmPr7SKAdlTuIYmnh3fBBpDJ5uUyU0Xgok6jEuAIatV3JHPPoM3THi6z5dt3QZ3iv+R9c6QucQoTldYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8476.namprd11.prod.outlook.com (2603:10b6:806:3af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 01:24:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 01:24:16 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Subject: Re: [RFC PATCH v2 0/6] SEAMCALL Wrappers
Thread-Topic: [RFC PATCH v2 0/6] SEAMCALL Wrappers
Thread-Index: AQHbRR87ZlKIRe+9dUaxLKEERfvJYrLVTDOA
Date: Wed, 4 Dec 2024 01:24:16 +0000
Message-ID: <e69033f1a0ec210c87ee596f96c8c1096ef1d59b.camel@intel.com>
References: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20241203010317.827803-1-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8476:EE_
x-ms-office365-filtering-correlation-id: 6bba9c20-8e21-4d1c-5f56-08dd14025e72
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cVJkaFZ5MDQ3VWREVFZRakh1aEZ4NUthQnlteWZVa01zMGJtZHVRL0dxY3Ro?=
 =?utf-8?B?SFYrakZyOHV3UFdTS1dxZXhHSWJyMnEyWEF2YjhTQTI3c3BMKzYrcnRtN0V6?=
 =?utf-8?B?aVFTWkNqSnpoUEc4K3hPcjZSR1pCVTZMNlhOdm5EQStQM3hES0Y4MkRWOFk0?=
 =?utf-8?B?NTVaVXlEdS9LdnpBNnE4QVh0NVovdXhWZDJJOVBEenhOR3hoWEwzVWoxTWJU?=
 =?utf-8?B?SVpaNjR2VUxGbHEzWmRRbFhablJ5S0JJWXQyUnBzTC9iVlBBcnh5QlpQd2lk?=
 =?utf-8?B?K0RENHZFdXpJZHhZdGliVVd3d3o3T0pqRjRNQ3R3OEt2TWdtSXlwLzNPUERi?=
 =?utf-8?B?cEc5N01VVldGWG9jaHROaHhyejMvNHBxRE5TOHN5SWwzVlVkMCt6N0N4Yzh2?=
 =?utf-8?B?YVFJZ1FqNm9YbzRLUGlxSVU4elFHUjlqQldDOEJKdnAvU0xJT1ErdWFYSVRy?=
 =?utf-8?B?TWVpT3RoaTNGSkVaWXRsUlJrclM3dU9HenBvanNqTjRnNW9UN3hnQjlxS0lh?=
 =?utf-8?B?NnZBcHNaTGVuTHc2Q2svY2IwNk81c3dDYzVCaWZUeUdxTVZnRkhnQmhROWNu?=
 =?utf-8?B?N0FnVGNQM3dvZDFMU04ybE9JNEtlOFRNZ3YrV2NLek01L0JSMEtSS0NXclQx?=
 =?utf-8?B?UHBLMlZRc2xld3F1ZzRMOXllbUl6anBnQnpWTEF2NEhudk1nTHhOdDRvZmo2?=
 =?utf-8?B?VmlvTTBnNGxNdEZPNFBDZHJteFZIQ3JlRERFdTduRzQraEhLLzgxOStBSDUx?=
 =?utf-8?B?NTNkTHpBZ0daYkhlMm1MMnNWY0l5VmZGZzBOMnM1bG9qV1ptSGg4N1h5QWZP?=
 =?utf-8?B?bzJPanlsMUxGemsrdGY3dUJ4d1dhMnVVM256aXFBUFJSYjA5Mm5YMks1SDFz?=
 =?utf-8?B?VUJ1UWhsTDlpTUZjVFgxdCs1UDZweW9VN0wxdytVWEY1OWlmeWdHUlVqQWE0?=
 =?utf-8?B?elhWYS9EK3l0cWk2UjMxTWt2UG9GQjk3b0E0UVprVjkzWEdjQ1lleTJaUEN3?=
 =?utf-8?B?czV3MnRnYjk0Z1l4SjZhd1ltbHp3UWN5ZmU2N2VXeGliNk9OVnVJZmR2Vzho?=
 =?utf-8?B?dkQzcXJWN0tsYnRGOURkWXJPRnZydE0rWXd3OW1MN2ZpZ0ZaY0ZmYU8xSHl0?=
 =?utf-8?B?cWFYdEM3T3Q3VUxTTlFCUEVoNkNicHNLaUliQTI4eEx2MjJSZWEvMktRV1Na?=
 =?utf-8?B?U0lFcUlMbVNhQU1YOVMxRHg1MEVOODlteE4zdEJWR0dkT1l2eWNQaDZ5b1ZE?=
 =?utf-8?B?RFBPckI4RllkYzhNQ0Jxdy9TNGdZUDNwWm5qRW5adHBTK01RdVhncnRnV09v?=
 =?utf-8?B?dC91UGtVNE9IV3Urc3FhblRobVczNUhEZmtJVWpTOXJGWlY4SDEvNTR1d3l5?=
 =?utf-8?B?ZkRqZm8yOWFWazFDL1hOSmJVbkozNTVXU0pzdXZVMGhtRkV3UVh5RmpZdWFV?=
 =?utf-8?B?WkVuRm1xOGFaaGJLQUxyS0kwN2dWc3RpMGQwMFhudlpzTWJLUzdHYjU5aEp3?=
 =?utf-8?B?bWJBemMyYnQ5dk1IUldnT3I2enRmODJmODYzTmx1SkJUYVQvUmhCZWptaFVu?=
 =?utf-8?B?UlVvSU1XazYvWnhNTVozZ3ZmYjZjNW9yT2R0a0x4WWNVbkhJS1JSMXFyQUZH?=
 =?utf-8?B?WjNncHJSWDZHNjNMZ1dQY0pQWi9VYmFxSWVUS0pIU0Y0a1FKTURCQVp4REl4?=
 =?utf-8?B?Wi85NmJXRXYzUUE2d1NYSlE2U2x3VzlZS0NOeXU2SGFNeFpBbk5CYXV5dGla?=
 =?utf-8?B?aVRId0hOOGlIYnRVQ1V4VUVSZ0dFYk1aeWRYUy9WdUlzZmkzMG5Pais2dk5y?=
 =?utf-8?B?WmdzUWtkc2ZhbnBHMlArNW1ia3VlQ1V5V1ZOSFdnSjJqWDZzdnRQeUExUDlj?=
 =?utf-8?B?M3VLSkd6S0pqRkIwdHVNMVNGT1VuTUxMNVZGSVk3M1VXaFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M001V25oeS9WYWV2N0NlWHhXaXRsUmxNbzhzemNDbzBLalJnajMzTjh4eGhH?=
 =?utf-8?B?WUp1Rmc5bTlrN2lyaEJ5WkdiU1RyM0pTaVVZVDVCSGJ1R2xvanltaExEbkp6?=
 =?utf-8?B?RkZ1RUx2ZG5ON21vWUliVEZXTUtuUWFnSEhjMUoxUmh6Z2NCNENOM3JFNUU0?=
 =?utf-8?B?SDF0Ym5VVXB2bDJiRWRyS09IVVkxN0hobjZjWFh5OEk5S2x5Q0IwYysxa3RR?=
 =?utf-8?B?UmVRWDVlNjJzbjRYWjlNU3FIWTloU3c1UDJidFMrUnFUNHYzQkhTZUQ4V0x0?=
 =?utf-8?B?TFNqbkdNZWo2MnF5VUVFM3g5MzNPZWJMUit1VVBYQ2lYNFE0U2ZYQ0Q5Q1dm?=
 =?utf-8?B?MFlGUEE4aUZkRm9rM0RJQ2VsWEZLM3hJZS9JeHdrcExGRmlKWmRVTm9CU0kr?=
 =?utf-8?B?SEpLTnVadUFPNlpIYkpUY1RjWFBXQjlmS3R3NldVOENxaFI1R0IwRXhBM214?=
 =?utf-8?B?SXkyUHhOQXd3VEVyQmt5VGRhRkErb3MyRnFteXVBS0Z1cHVEK2dKdGVpSmtv?=
 =?utf-8?B?TU1ObWgzWFRUME9PYnhVeDJpMTlZNXdEQkx5NVcvKytqZTNHR0phbGkwTnNW?=
 =?utf-8?B?MGtTQ0xlUlBmNmZacDZ6WGlLZGhyKzgwWlJUS0d3TUR1YXBpVjJqY3ZoNUY3?=
 =?utf-8?B?TVl6ckNCYzdHemkzYnBPVnZrbjFNWEd0dGlac0RFazAzblNQQ0VQa3BheTZ1?=
 =?utf-8?B?TE1JdDlLdzRIQWtoUEVNTnN3MjZGcGVVNWtqZWIvM3BDNDZZOHNKNEoxekZX?=
 =?utf-8?B?b21zSENiRDJLeXdaRml3cmkxeVJESGlKVWxQYWZ3QUlzSklXRWNwTHJxMWc5?=
 =?utf-8?B?aE94ZnFyQm1XRCtoQ3AzZjlXYTRjWXVJSDl3eFkrME51NkhqendQMS9uSHRz?=
 =?utf-8?B?Ynh0R3FrejVJM0dkNTNkZGtydFRpM0V0QVpYZW9ZTFpJWGRsbXgrZzByUkZL?=
 =?utf-8?B?NXMwMS9pcHRmTWoyVVl6MW9ZMUtmZHNTZzROaTZDajMxT1lXMjBNU0NqdG9z?=
 =?utf-8?B?VmVJQ0FiV2pDQWNxc1BEUlFDTHUxcVFSM20vcDRZVWJuOTQ1MzdIT2Q0MXZE?=
 =?utf-8?B?R3ZSTjY0S0tSL0dVenErL3BSb2R4UHZPTktoUDRXVUdLekhILytiaTQwUktQ?=
 =?utf-8?B?cWxIYVF5d01iUlNOaUZOMi95dUZiNkhlM0c1QTJmajRSQjc4U3BwalJTdEgv?=
 =?utf-8?B?QWJJSUhQRXFXL1hIdHBCSytMaTVKSFBUVWZIUzFLWGExMVQ1eTlNUGI5blVp?=
 =?utf-8?B?cGhxN3VoY0NUK0ZVazladXk3Rk94V0tpcmZFY0xRUktqQm9rY1FvZjF5SkJJ?=
 =?utf-8?B?RVBCS1p2cHNLRkdSUS9ScFBlQVZHa0dKbVE2elRJLzhyTkgzcUdDVzl5MDJW?=
 =?utf-8?B?VFdkNFlzU0hUcUU5aVE2U0xEN1R4VjZTcEVOTGQxaW00dkpCNTFuU2ZsTEMz?=
 =?utf-8?B?ZjJaYTBMTXNlSC8zdVdEWURUNktOU3JiaDAzdEcyOC9RSFNkUGxwczZJY3NW?=
 =?utf-8?B?N2J3OEwxOXNud2laeVNOZlBybUxMaWtlTnFoQ2dTMGZuQ1BhblJUZ0NEdjZo?=
 =?utf-8?B?NkszV0svZHNRU1VkSXZGRDBEK2V0ME1WMDZUYzNFb2lUZDhpODNpUWVnTS9n?=
 =?utf-8?B?U0JxS05TWTYvczBnS1pVZnFodnhkYncvYStTNUVtU0x4QnEzS3dPelNrckJn?=
 =?utf-8?B?d2EzWkU3dDk5OW9XdE8rU3lXNVd0dHdyeE5kdno2SUV6aUJsSEpRbTNGTjVy?=
 =?utf-8?B?R3QydE1LTGdUNVJPb2t0alhKSmZQQ3B3ZSt2eVROUWx6UHFPOUd5d2RZMUhR?=
 =?utf-8?B?NTY3NHZ3NVczTVd2RGZ6VENJVzBWUHJDa21rK2hPdGYwSWFyWGJaSHdjZlYx?=
 =?utf-8?B?S3dmWkIwVFZ6STBuT3VIUHl2WEsyQzgrckNCUDNFaS8vdVJ4OGtFMml4V0lG?=
 =?utf-8?B?bkZFd2pSU3VFWExkc29ZbTYrbzYrc1lORmQzenhOM1FzMmJmbDViU0NRU3M4?=
 =?utf-8?B?Lzd0eTk0UXBjbUhtTlN6Q3dXaUN0VWtsTzlod2pZRnA4cDNpdFNOb0JCMXgw?=
 =?utf-8?B?Q092WnB0cFhpNUdEUFg3TGdubTdXZjBVSk80SzRsNkJWY2p1SlAwc1gwcm44?=
 =?utf-8?Q?gG/OW5BpIz97XEq/Y36gWRnLU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DD5EC0B0B4E294DA4B63E4751C7E32E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bba9c20-8e21-4d1c-5f56-08dd14025e72
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2024 01:24:16.3405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BI2zSRIDnGXRZ0rcaZw5V1Y92ZvSYkW6LIr79oPl5GdgsDJkE3FS46lAsWP6RMgTXa6B/FI2rrCkMf/5nduQLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8476
X-OriginatorOrg: intel.com

PiANCj4gVGhpcyBpcyBiZWNhdXNlIGl0IHdpbGwgbm90IHZhcnkgYmV0d2VlbiB2Q1BVcy4gRG9p
bmcgaXQgdGhhdCB3YXkgDQo+IGJhc2ljYWxseSBwcmVzZXJ2ZXMgdGhlIGV4aXN0aW5nIGRhdGEg
ZHVwbGljYXRpb24sIGJ1dCB0aGVzZSBjb3VudHMgYXJlIA0KPiBiYXNpY2FsbHkgImdsb2JhbCBt
ZXRhZGF0YSIuIFRoZSBnbG9iYWwgbWV0YWRhdGEgcGF0Y2hlcyBleHBvcnQgdGhlbSBhcyBhIA0K
PiBzaXplLCBidXQgS1ZNIHdhbnRzIHRvIHVzZSB0aGVtIGFzIGEgcGFnZSBjb3VudC4gU28gd2Ug
c2hvdWxkIG5vdCBiZSANCj4gaW5jbHVkaW5nIHRoZXNlIGNvdW50cyBpbiBlYWNoIFREIHNjb3Bl
ZCBzdHJ1Y3R1cmUgYXMgaXMgY3VycmVudGx5IGRvbmUuIFRvDQo+IGFkZHJlc3MgdGhlIGR1cGxp
Y2F0aW9uIHdlIG5lZWQgdG8gY2hhbmdlIHRoZSAiZ2xvYmFsIG1ldGFkYXRhIHBhdGNoZXMiDQo+
IHRvIGV4cG9ydCB0aGUgY291bnQgaW5zdGVhZCBvZiBzaXplLg0KPiANCg0KQ3VycmVudGx5IHRo
ZSBnbG9iYWwgbWV0YWRhdGEgcmVhZGluZyBzY3JpcHQgZ2VuZXJhdGVzIHRoZSBzdHJ1Y3QgbWVt
YmVyIGJhc2VkDQpvbiB0aGUgImZpZWxkIG5hbWUiIG9mIHRoZSBKU09OIGZpbGUuICBUaGUgSlNP
TiBmaWxlIHN0b3JlcyB0aGVtIGFzICJzaXplIjoNCg0KICAiVERSX0JBU0VfU0laRSIsICJURENT
X0JBU0VfU0laRSIsICJURFZQU19CQVNFX1NJWkUiDQoNCldlIHdpbGwgbmVlZCB0byB0d2VhayB0
aGUgc2NyaXB0IHRvIG1hcCAibWV0YWRhdGEgZmllbGQgbmFtZSIgdG8gImtlcm5lbA0Kc3RydWN0
dXJlIG1lbWJlciBuYW1lIiwgYW5kIG1vcmUgInNwZWNpYWwgaGFuZGxpbmcgZm9yIHNwZWNpZmlj
IGZpZWxkcyIgd2hlbg0KYXV0byBnZW5lcmF0aW5nIHRoZSBjb2RlLg0KDQpJdCdzIGZlYXNpYmxl
IGJ1dCBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgaXQncyB3b3J0aCB0byBkbywgc2luY2Ugd2UgYXJl
IGJhc2ljYWxseQ0KdGFsa2luZyBhYm91dCBjb252ZXJ0aW5nIHNpemUgdG8gcGFnZSBjb3VudC4N
Cg0KQWxzbywgZnJvbSBnbG9iYWwgbWV0YWRhdGEncyBwb2ludCBvZiB2aWV3LCBwZXJoYXBzIGl0
IGlzIGFsc28gZ29vZCB0byBqdXN0DQpwcm92aWRlIGEgbWV0YWRhdGEgd2hpY2ggaXMgY29uc2lz
dGVudCB3aXRoIHdoYXQgbW9kdWxlIHJlcG9ydHMuICBIb3cga2VybmVsDQp1c2VzIHRoZSBtZXRh
ZGF0YSBpcyBhbm90aGVyIGxheWVyIG9uIHRvcCBvZiBpdC4NCg0KQnR3LCBwZXJoYXBzIHdlIGRv
bid0IG5lZWQgdG8ga2VlcCAndGRjc19ucl9wYWdlcycgYW5kICd0ZGN4X25yX3BhZ2VzJyBpbg0K
J3N0cnVjdCB0ZHhfdGQnLCBpLmUuLCBhcyBwZXItVEQgdmFyaWFibGVzLiAgVGhleSBhcmUgY29u
c3RhbnRzIGZvciBhbGwgVERYDQpndWVzdHMuDQoNCkUuZy4sIGFzc3VtaW5nIEtWTSBpcyBzdGls
bCBnb2luZyB0byB1c2UgdGhlbSwgaXQgY2FuIGp1c3QgYWNjZXNzIHRoZW0gdXNpbmcgdGhlDQpt
ZXRhZGF0YSBzdHJ1Y3R1cmU6DQoNCglzdGF0aWMgaW5saW5lIGludCB0ZHhfdGRjc19ucl9wYWdl
cyh2b2lkKQ0KCXsNCgkJcmV0dXJuIHRkeF9zeXNpbmZvLT50ZF9jdHJsLnRkY3hfYmFzZV9zaXpl
ID4+IFBBR0VfU0hJRlQ7DQoJfQ0KDQpBRkFJQ1QgdGhleSBhcmUgb25seSB1c2VkIHdoZW4gY3Jl
YXRpbmcvZGVzdHJveWluZyBURCBmb3IgYSBjb3VwbGUgb2YgdGltZXMsIHNvDQpJIGFzc3VtZSBk
b2luZyAiPj4gUEFHRV9TSElGVCIgYSBjb3VwbGUgb2YgdGltZXMgd29uJ3QgcmVhbGx5IG1hdHRl
ci4gDQo=

